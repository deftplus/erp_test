#Область ПрограммныйИнтерфейс

// Функция получает коэффициент пересчета из текущей валюты в новую валюту.
//
// Параметры:
//	ТекущаяВалюта - СправочникСсылка.Валюты - Текущая валюта документа
//	НоваяВалюта - СправочникСсылка.Валюты - Новая валюта документа
//	Дата - Дата - Дата документа
//
// Возвращаемое значение:
//	Число - Коэффициент пересчета в новую валюту
//
Функция ПолучитьКоэффициентПересчетаИзВалютыВВалюту(ТекущаяВалюта, НоваяВалюта, Дата) Экспорт
	
	Если ТекущаяВалюта <> НоваяВалюта Тогда
		КурсТекущейВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ТекущаяВалюта, Дата);
		КурсНовойВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(НоваяВалюта, Дата);
		Если КурсНовойВалюты.Курс * КурсТекущейВалюты.Кратность <> 0 Тогда
			КоэффициентПересчета = (КурсТекущейВалюты.Курс * КурсНовойВалюты.Кратность) / (КурсНовойВалюты.Курс * КурсТекущейВалюты.Кратность);
		Иначе
			КоэффициентПересчета = 0;
		КонецЕсли;
	Иначе
		КоэффициентПересчета = 1;
	КонецЕсли;
	
	Возврат КоэффициентПересчета;
	
КонецФункции // ПолучитьКоэффициентПересчетаИзВалютыВВалюту()

// Функция получает коэффициенты пересчета сумм из валюты документа в валюту взаиморасчетов,
// в валюты управленческого и регламентированного учета.
//
// Параметры:
//	ВалютаДокумента - СправочникСсылка.Валюты - Валюта документа
//	ВалютаВзаиморасчетов - СправочникСсылка.Валюты - Валюта взаиморасчетов документа
//	Период - Дата - Дата документа
//	КурсДокумента - Число - Необязательный, курс валюты документа
//	КратностьДокумента - Число - Необязательный, кратность валюты документа
//
// Возвращаемое значение:
//   Структура - Параметры курса валюты.
//	   * КоэффициентПересчетаВВалютуВзаиморасчетов 	- Число - Коэффициент пересчета в валюту взаиморасчетов.
//	   * КоэффициентПересчетаВВалютуУПР 			- Число - Коэффициент пересчета в валюту управленческого учета.
//	   * КоэффициентПересчетаВВалютуРегл 			- Число - Коэффициент пересчета в валюту регламентированного учета.
//
Функция ПолучитьКоэффициентыПересчетаВалюты(ВалютаДокумента, ВалютаВзаиморасчетов, Период, КурсДокумента = Неопределено, КратностьДокумента = Неопределено) Экспорт

	ВалютаУпр  = ОбщегоНазначенияПовтИспУХ.ПолучитьВалютуУправленческогоУчета();
	ВалютаРегл = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();

	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	КурсыВалют.Валюта    КАК Валюта,
	|	КурсыВалют.Курс      КАК Курс,
	|	КурсыВалют.Кратность КАК Кратность
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&Период,
	|		Валюта = &ВалютаУпр ИЛИ Валюта = &ВалютаРегл ИЛИ Валюта = &ВалютаВзаиморасчетов ИЛИ Валюта = &ВалютаДокумента
	|	) КАК КурсыВалют
	|");
	Запрос.УстановитьПараметр("Период",               Период);
	Запрос.УстановитьПараметр("ВалютаУпр",            ВалютаУпр);
	Запрос.УстановитьПараметр("ВалютаРегл",           ВалютаРегл);
	Запрос.УстановитьПараметр("ВалютаДокумента",      ВалютаДокумента);
	Запрос.УстановитьПараметр("ВалютаВзаиморасчетов", ВалютаВзаиморасчетов);

	КурсВалютыУпр            = 1;
	КратностьВалютыУпр       = 1;

	КурсВалютыРегл           = 1;
	КратностьВалютыРегл      = 1;

	КурсВзаиморасчетов       = 1;
	КратностьВзаиморасчетов  = 1;

	КурсВалютыДокумента      = 1;
	КратностьВалютыДокумента = 1;

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		Если Выборка.Валюта = ВалютаУпр Тогда

			КурсВалютыУпр      = Выборка.Курс;
			КратностьВалютыУпр = Выборка.Кратность;

		КонецЕсли;

		Если Выборка.Валюта = ВалютаРегл Тогда

			КурсВалютыРегл      = Выборка.Курс;
			КратностьВалютыРегл = Выборка.Кратность;

		КонецЕсли;

		Если Выборка.Валюта = ВалютаВзаиморасчетов Тогда

			КурсВзаиморасчетов      = Выборка.Курс;
			КратностьВзаиморасчетов = Выборка.Кратность;

		КонецЕсли;

		Если Выборка.Валюта = ВалютаДокумента Тогда

			КурсВалютыДокумента      = Выборка.Курс;
			КратностьВалютыДокумента = Выборка.Кратность;

		КонецЕсли;
	КонецЦикла;

	Если ЗначениеЗаполнено(КурсДокумента) Тогда
		
		Если ВалютаДокумента = ВалютаРегл И НЕ ВалютаВзаиморасчетов = ВалютаРегл Тогда
			КурсВзаиморасчетов = КурсДокумента;
			КратностьВзаиморасчетов = КратностьДокумента;
			КурсВалютыДокумента = 1;
			КратностьВалютыДокумента = 1;
		Иначе
			КурсВалютыДокумента = КурсДокумента;
			КратностьВалютыДокумента = КратностьДокумента;
			КурсВзаиморасчетов = 1;
			КратностьВзаиморасчетов = 1;
		КонецЕсли;
		
	КонецЕсли;
	
	Результат = Новый Структура("КоэффициентПересчетаВВалютуВзаиморасчетов, КоэффициентПересчетаВВалютуУПР, КоэффициентПересчетаВВалютуРегл");

	Результат.КоэффициентПересчетаВВалютуУпр  = КурсВалютыДокумента * КратностьВалютыУпр / (КратностьВалютыДокумента * КурсВалютыУпр); 
	Результат.КоэффициентПересчетаВВалютуРегл = КурсВалютыДокумента * КратностьВалютыРегл / (КратностьВалютыДокумента * КурсВалютыРегл);
	Результат.КоэффициентПересчетаВВалютуВзаиморасчетов = КурсВалютыДокумента * КратностьВзаиморасчетов / (КратностьВалютыДокумента * КурсВзаиморасчетов);

	Возврат Результат;

КонецФункции

// Функция пересчитывает сумму документа из текущей валюты в новую валюту.
//
// Параметры:
//	СуммаДокумента - Число - Текущая сумма документа
//	ТекущаяВалюта - СправочникСсылка.Валюты - Текущая валюта документа
//	НоваяВалюта - СправочникСсылка.Валюты - Новая валюта документа
//	Дата - Дата - Дата документа
//
// Возвращаемое значение:
//	Число - Новая сумма документа
//
Функция ПересчитатьСуммуДокументаВВалюту(СуммаДокумента, ТекущаяВалюта, НоваяВалюта, Дата) Экспорт
	
	СтруктураКурсовТекущейВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ТекущаяВалюта, Дата);
	СтруктураКурсовНовойВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(НоваяВалюта, Дата);
	
	Возврат РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(СуммаДокумента, СтруктураКурсовТекущейВалюты, СтруктураКурсовНовойВалюты);
	
КонецФункции

//Процедура заполняет курс и кратность документа по умолчанию
//
// Параметры:
//	Курс - Число - Курс для расчета
//	Кратность - Число - Кратность для расчета
//	ВалютаДокумента - СправочникСсылка.Валюты - Валюта документа
//	ВалютаВзаиморасчетов - СправочникСсылка.Валюты - Валюта взаиморасчетов документа
//	Дата - Дата - Необязательный, дата документа
//
Процедура ЗаполнитьКурсКратностьПоУмолчанию(Курс, Кратность, ВалютаДокумента, ВалютаВзаиморасчетов, Дата = Неопределено) Экспорт
	
	ВалютаРеглУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если ВалютаДокумента = ВалютаВзаиморасчетов 
		ИЛИ НЕ ЗначениеЗаполнено(ВалютаДокумента) 
		ИЛИ НЕ ЗначениеЗаполнено(ВалютаВзаиморасчетов) Тогда
		
		Курс      = 1;
		Кратность = 1;
		Возврат;
		
	ИначеЕсли ВалютаДокумента = ВалютаРеглУчета И НЕ ВалютаВзаиморасчетов = ВалютаРеглУчета Тогда
		
		СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаВзаиморасчетов, Дата);
		
	ИначеЕсли НЕ ВалютаДокумента = ВалютаРеглУчета И ВалютаВзаиморасчетов = ВалютаРеглУчета Тогда
		
		СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
		
	Иначе
		
		КурсВалютыВзаиморасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаВзаиморасчетов, Дата);
		КурсВалютыДокумента      = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
		СтруктураКурса           = ПолучитьКроссКурсВалют(КурсВалютыДокумента,КурсВалютыВзаиморасчетов);
		
	КонецЕсли;
	
	Курс      = СтруктураКурса.Курс;
	Кратность = СтруктураКурса.Кратность;
	
КонецПроцедуры

//Функция возвращает кросс-курс двух валют
//
// Параметры:
//	Валюта1 - Структура - Параметры курса валюты, относительно которой рассчитывается курс
//       * Курс      - Число - Курс валюты относительно валюты регламентированного учета.
//       * Кратность - Число - Кратность валюты относительно валюты регламентированного учета.
//	Валюта2 - Структура - Параметры курса валюты, курс которой рассчитывается
//       * Курс      - Число - Курс валюты относительно валюты регламентированного учета.
//       * Кратность - Число - Кратность относительно валюты регламентированного учета.
//
// Возвращаемое значение: 
//   Структура - Параметры кросс-курса.
//       * Курс      - Число - Кросс-курс валюты.
//       * Кратность - Число - Приведенная кратность.
//
Функция ПолучитьКроссКурсВалют(Валюта1, Валюта2) Экспорт
	
	КурсПриведенный = Валюта1.Курс / Валюта2.Курс;
	КратностьПриведенная = Валюта1.Кратность / Валюта2.Кратность;
	
	Пока Окр(КратностьПриведенная) <> КратностьПриведенная Цикл
		КурсПриведенный = КурсПриведенный * 10;
		КратностьПриведенная = КратностьПриведенная * 10;
	КонецЦикла;
	
	СтруктураКурса = СтруктураКурсаВалюты();
	СтруктураКурса.Курс = Окр(КурсПриведенный, 4);
	СтруктураКурса.Кратность = КратностьПриведенная;
	
	Возврат СтруктураКурса;
	
КонецФункции

//Функция возвращает структуру параметров курса валюты
//
// Параметры:
//	Курс - Число - Необязательный, курс валюты.
//	Кратность - Число - Необязательный, кратность валюты.
//
// Возвращаемое значение: 
//   Структура - Параметры курса валюты.
//	   * Курс 		- Число - курс валюты.
//	   * Кратность 	- Число - кратность курса.
//
Функция СтруктураКурсаВалюты(Курс = 0, Кратность = 0) Экспорт
	
	Структура = Новый Структура;
	Структура.Вставить("Курс", Курс);
	Структура.Вставить("Кратность", Кратность);
	Возврат Структура;

КонецФункции

#Область УстаревшийПрограммныйИнтерфейс

// Устарела. Следует использовать РаботаСКурсамиВалют.ПолучитьКурсВалюты.
//Функция возвращает информацию о курсе валюты на основе ссылки на валюту.
// Данные возвращаются в виде структуры.
//
// Параметры:
// ВыбраннаяВалюта - Справочник.Валюты / Ссылка - ссылка на валюту, информацию
//                  о курсе которой необходимо получить
//
// Возвращаемое значение:
// ДанныеКурса   - стуктура, содержащая информацию о последней доступной 
//                 записи курса
//
Функция ЗаполнитьДанныеКурсаДляВалюты(ВыбраннаяВалюта, Знач ДатаКурса=Неопределено) Экспорт
	
	Если ДатаКурса = Неопределено Тогда
		ДатаКурса = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Возврат РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВыбраннаяВалюта, ДатаКурса);
	
КонецФункции

// Устарела. Следует использовать РаботаСКурсамиВалют.ПересчитатьВВалюту.
Функция ПересчитатьВВалюту(Знач Сумма, Знач ИсходнаяВалюта, Знач НоваяВалюта, Знач Дата) Экспорт
	Возврат РаботаСКурсамиВалют.ПересчитатьВВалюту(Сумма, ИсходнаяВалюта, НоваяВалюта, Дата);
КонецФункции

// Устарела. Следует использовать РаботаСКурсамиВалют.ПолучитьКурсВалюты.
// Возвращает курс валюты на дату.
//
// Параметры:
//   Валюта    - СправочникСсылка.Валюты - Валюта, для которой получается курс.
//   ДатаКурса - Дата - Дата, на которую получается курс.
//
// Возвращаемое значение: 
//   Структура - Параметры курса.
//       * Курс      - Число - Курс валюты на указанную дату.
//       * Кратность - Число - Кратность валюты на указанную дату.
//       * Валюта    - СправочникСсылка.Валюты - Ссылка валюты.
//       * ДатаКурса - Дата - Дата получения курса.
//
Функция ПолучитьКурсВалюты(Валюта, ДатаКурса) Экспорт
	
	Возврат РаботаСКурсамиВалют.ПолучитьКурсВалюты(Валюта, ДатаКурса);
	
КонецФункции

#КонецОбласти

#КонецОбласти

