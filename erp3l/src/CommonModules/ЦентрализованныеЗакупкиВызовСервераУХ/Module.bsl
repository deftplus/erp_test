
#Область ВерсионированиеОбъектовДляЕИС


// Добавляет новую запись в регистр сведений ВерсииОбъектовДляЕИС. Номер версии увеличивает на единицу.
// Если версий небыло, то номер устанавливаем в единицу.
// Параметры:
//	Ссылка - ОпределяемыйТип.ОбъектыЦУЗОбменаСЭТП_УХ.
//	ОбоснованиеИзменений - Строка(2000). Непустая строка с причиной изменений.
// Возвращает:
//	Число - номер добавленой версии.
//
Функция ДобавитьВерсиюОбъектаДляЕИС(Ссылка, ОбоснованиеИзменений) Экспорт
	Возврат ЦентрализованныеЗакупкиУХ.ДобавитьВерсиюОбъектаДляЕИС(Ссылка, ОбоснованиеИзменений);
КонецФункции

// Получить номер версии объекта для ЕИС.
// Параметры:
//	Ссылка - ОпределяемыйТип.ОбъектыЦУЗОбменаСЭТП_УХ.
//
// Возвращает:
//	Структура с описанием последней версии:
//		НомерВерсии - Число. Номер последней версии. Если версий нет, то 0.
//		ОбоснованиеИзменений - Строка(2000). Обоснование внесения изменения при создании версии.
//		Дата - Дата+Время - универсальные дата и время создания версии.
//
Функция ПолучитьВерсиюОбъектаДляЕИС(Ссылка) Экспорт
	Возврат ИнтеграцияЦУЗсЭТПСерверУХ.ПолучитьВерсиюОбъектаДляЕИС(Ссылка);
КонецФункции


#КонецОбласти


#Область РедактированиеУИДовДляЕИС


// Возвращает стандартный идентификатор объекта в виде строки.
//
Функция ПолучитьСтандартныйУИД(Объект) Экспорт
	Возврат Строка(Объект.Ссылка.УникальныйИдентификатор());
КонецФункции


#КонецОбласти


#Область РаботаСНоменклатурой


// Функция - Получить цену номенклатуры по типу в указанной
// валюте с учетом или без НДС.
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура - номенклатура.
//  ТипЦены - СправочникСсылка.ТипыЦенНоменклатуры - тип цен.
//  Дата - Дата - дата для учета курса валюты и значения цены.
//  Валюта - СправочникСсылка.Валюты - валюта в которой нужно
//		цену.
//  ЦенаВключаетНДС - Булево - вернуть цену с НДС или нет.
//	СтавкаНДС - СправочникСсылка.СтавкиНДС - ставка, если
//		она отличается от ставки в номенклатуре. Если они
//		совпадают, то можно не указывать.
// 
// Возвращаемое значение:
//	Число - цена установленная на дату в валюте с учетом
//		флага НДС.
//
&НаСервере
Функция ПолучитьЦенуНоменклатурыПоТипу(Номенклатура,
									   Характеристика,
									   ТипЦены, 
									   Дата, 
									   Валюта, 
									   ЦенаВключаетНДС,
									   СтавкаНДС=Неопределено) Экспорт
	Цена = ЦентрализованныеЗакупкиУХ.ПолучитьЦенуНоменклатуры(
				Номенклатура,
				Характеристика,
				ТипЦены, 
				Дата, 
				Валюта);
	Возврат УчетНДСКлиентСервер.ПересчитатьЦенуПриИзмененииФлаговНалогов(
				Цена, 
				ТипЦены.ЦенаВключаетНДС,
				ЦенаВключаетНДС,
				ВстраиваниеУХВызовСервера.ПолучитьСтавкуНДС(
					СтавкаНДС));
КонецФункции

// Возвращает ресурсы регистра сведений НоменклатураСОсобымПорядкомЗакупки
//  наиболее подходящие под номенклатуру и текущие настройки.
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура|
//				   СправочникСсылка.ТоварныеКатегории - позиция номенклатуры
//						или товарная категория, для которой нужно определить
//						флаги особого порядка закупки.
// 
// Возвращаемое значение:
//	- Структура с ресурсами регистра сведений НоменклатураСОсобымПорядкомЗакупки.
//	- Неопределено - не удалось найти настройку регламентирующую закупку
//					 переданной номенклатуры.
//
Функция ПолучитьЗначенияРеквизитовОсобогоПорядкаЗакупкиНоменклатуры(Номенклатура) Экспорт
	Если НЕ ЗначениеЗаполнено(Номенклатура) Тогда
		Возврат Неопределено;
	КонецЕсли;
	УровеньКонтроляПравилНоменклатуры = 
		Константы.УровеньКонтроляПравилНоменклатуры.Получить();
	Если НЕ ЗначениеЗаполнено(УровеньКонтроляПравилНоменклатуры) Тогда
		Возврат Неопределено;
	КонецЕсли;
	Если УровеньКонтроляПравилНоменклатуры = 
			Перечисления.УровниКонтроляПравилНоменклатуры.ОКПД2 Тогда
		Возврат ПолучитьФлагиОсобогоПорядкаЗакупкиПоОКПД2(Номенклатура.КодОКПД2);
	ИначеЕсли УровеньКонтроляПравилНоменклатуры = 
			Перечисления.УровниКонтроляПравилНоменклатуры.ТоварнаяКатегорияНоменклатура Тогда
		Возврат ПолучитьФлагиОсобогоПорядкаЗакупкиПоТоварнойКатегории(Номенклатура);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции


#КонецОбласти


#Область ПолучениеДанных


Функция ПолучитьИменаИзмеренийРегистраПланированияПотребностей() Экспорт
	Результат = Новый Массив;
	ИзмеренияРегистра = 
		Метаданные.РегистрыНакопления.ПотребностиВНоменклатуре.Измерения;
	Для Каждого Измерение Из ИзмеренияРегистра Цикл
		Результат.Добавить(Измерение.Имя);
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ОрганизацияЗакупаетПоФЗ223(Организация) Экспорт
	Если ЗначениеЗаполнено(Организация) Тогда
		Возврат Организация.ЗакупкаПоФЗ223;
	КонецЕсли;
	
	Возврат Ложь;
КонецФункции

// Получить массив с типами, которые входят в определяемый тип "ОбъектыЦУЗОбменаСЭТП_УХ"
Функция ПолучитьТипыОбъектаОбмена() Экспорт
	Возврат ЦентрализованныеЗакупкиУХ.ПолучитьТипыОбъектаОбмена();
КонецФункции

Функция ПолучитьДанныеНаСервере(ДанныеДляПолучения) Экспорт
	ЗначенияДанных = Новый Структура;
	Для Каждого ОписаниеЗначения Из ДанныеДляПолучения Цикл
		ЗначенияДанных.Вставить(ОписаниеЗначения.Имя, Вычислить(ОписаниеЗначения.Формула));
	КонецЦикла;
	
	Возврат ЗначенияДанных;
КонецФункции

Функция ПолучитьМассивЕдиницИзмеренияНоменклатуры(Номенклатура) Экспорт
	Возврат ЦентрализованныеЗакупкиУХ.ПолучитьМассивЕдиницИзмеренияНоменклатуры(Номенклатура);
КонецФункции

Функция МассивНоменклатурыПоТоварнойКатегории(ТоварнаяКатегория) Экспорт
	Возврат ЦентрализованныеЗакупкиУХ.МассивНоменклатурыПоТоварнойКатегории(ТоварнаяКатегория);
КонецФункции

Функция ПолучитьПериодПотребностиПоДате(ДатаДоговора) Экспорт
	Возврат ОбщегоНазначенияУХ.глОтносительныйПериодПоДате(ДатаДоговора, ЦентрализованныеЗакупкиУХ.ПолучитьПериодичностьЗакупок(), 0, Истина);
КонецФункции

Функция ПолучитьПротоколВыбораПоставщиковДляЗакупки(ЗакупочнаяПроцедура) Экспорт
	Возврат Документы.ПротоколВыбораПобедителей.ПолучитьДляЗакупки(
		ЗакупочнаяПроцедура);
КонецФункции
		
Функция ПолучитьЗакупкуПоСтрокеПлана(СтрокаПланаЗакупок, Ошибки) Экспорт
	Возврат Справочники.ЗакупочныеПроцедуры.ПолучитьПоСтрокеПлана(
			СтрокаПланаЗакупок,
			Ошибки);
КонецФункции

// Пересчитывает сумму из валюты в валюту регламентированного учета
//  на указанную дату.
//
// Параметры:
//  Валюта		 - СправочникСсылка.Валюты	 - валюта в которой
//					выражена сумма.
//  ДатаКурса	 - Дата	 - дата на которую брать курс.
//  Сумма		 - Число	 - сумма в валюте для пересчета.
//
// Возвращает:
//	Сумма в валюте регламентированного учета.
//
Функция ПересчитатьСуммуВВалютуРеглУчетаНаДату(Валюта, ДатаКурса, Сумма) Экспорт
	Результат = Новый Структура("СуммаВРублях, Курс", 0, 1);
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Валюта, ДатаКурса);
	Результат.Курс = Окр(СтруктураКурса.Курс / СтруктураКурса.Кратность, 6);
	Результат.СуммаВРублях = РаботаСКурсамиВалютКлиентСерверУХ.ПересчитатьИзВалютыВВалюту(
			Сумма,
			Валюта,
			ВалютаРеглУчета, 
		    СтруктураКурса.Курс,
			1, 
		    СтруктураКурса.Кратность,
			1);
	Возврат Результат;
КонецФункции

// Проверяет корректность периодов начала и окончания закупок.
//
// Параметры:
//  ПериодЗакупокНачало		 - СправчоникСсылка.Периоды	 - период начала.
//  ПериодЗакупокОкончание	 - СправчоникСсылка.Периоды	 - период окончания
// 
// Возвращаемое значение:
//   - Строка - текст сообщения ошибки. Если ошибок нет,
//				то возвращает пустую строку.
//
Функция ПроверитьПериодЗакупок(ПериодЗакупокНачало, ПериодЗакупокОкончание) Экспорт
	ТекстОшибки = "";
	Если ЗначениеЗаполнено(ПериодЗакупокНачало)
			И ЗначениеЗаполнено(ПериодЗакупокОкончание) Тогда
		Если ПериодЗакупокНачало.ДатаНачала > ПериодЗакупокОкончание.ДатаНачала Тогда
			ТекстОшибки = ТекстОшибки
				+ НСтр("ru = 'Период начала закупок не может быть больше периода окончания закупок.'");
		КонецЕсли;
	КонецЕсли;
	Возврат ТекстОшибки;
КонецФункции

// Возвращает товарную категорию номенклатуры из массива МассивНоменклатураВход.
// Если несколько - возвращает любую.
Функция ВернутьТоварнуюКатегорию(МассивНоменклатураВход) Экспорт
	ПустаяТоварнаяКатегория = Справочники.ТоварныеКатегории.ПустаяСсылка();
	РезультатФункции = ПустаяТоварнаяКатегория;
	ТекТоварнаяКатегория = ПустаяТоварнаяКатегория;
	Для Каждого ТекМассивНоменклатураВход Из МассивНоменклатураВход Цикл
		Если ТипЗнч(ТекМассивНоменклатураВход) = Тип("СправочникСсылка.Номенклатура") Тогда
			ТекТоварнаяКатегория = ТекМассивНоменклатураВход.ТоварнаяКатегория;
		ИначеЕсли ТипЗнч(ТекМассивНоменклатураВход) = Тип("СправочникСсылка.ТоварныеКатегории") Тогда
			ТекТоварнаяКатегория = ТекМассивНоменклатураВход;
		Иначе
			ТекстСообщения = НСтр("ru = 'Неизвестный вариант номенклатуры ""%Номенклатура%""'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номенклатура%", Строка(ТекМассивНоменклатураВход));
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
			ТекТоварнаяКатегория = ПустаяТоварнаяКатегория;
		КонецЕсли;
		Если ЗначениеЗаполнено(ТекТоварнаяКатегория) Тогда
			РезультатФункции = ТекТоварнаяКатегория;
			Прервать;		// Значение найдено.
		Иначе
			// Продолжаем поиск далее.
		КонецЕсли;
	КонецЦикла;	
	Возврат РезультатФункции;
КонецФункции		 // ВернутьТоварнуюКатегорию()

#КонецОбласти


#Область РаботаСФормой


Процедура ВыделитьЭлементыФормы(Форма, мИменаЭлементов, Оформление) Экспорт
	Для Каждого ИмяЭлементаФормы из мИменаЭлементов Цикл
		ЭлементФормы = Форма.Элементы.Найти(ИмяЭлементаФормы.Ключ);
		Если ЭлементФормы <> Неопределено Тогда
			Для Каждого ЭлементОформления Из Оформление Цикл
				ЭлементФормы[ЭлементОформления.Ключ] =
					ЭлементОформления.Значение;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры


#КонецОбласти


#Область ТиповыеОбработчикиКоманд


// Возвращает печатную форму протокола.
// См. ЦентрализованныеЗакупкиКлиентУХ.ТиповаяПечатьПротоколаЗакупкиПоДокументу().
//
Функция ТиповойСформироватьПечатнуюФормуПротоколаЗакупкиПоДокументу(
											ПротоколСсылка) Экспорт
	НастройкиФормированияОтчета = Новый Структура;
	НастройкиФормированияОтчета.Вставить(
		"ВыводитьНоменклатуруПоставщиков",
		Истина);
	Возврат Отчеты.ПротоколЗакупочнойПроцедуры.СформироватьПечатнуюФормуПротоколаПоДокументу(
		ПротоколСсылка,
		НастройкиФормированияОтчета);
КонецФункции
	
// Возвращает печатную форму протокола.
// См. ЦентрализованныеЗакупкиКлиентУХ.ТиповаяПечатьПротоколаЗакупкиПоТипу().
//
Функция ТиповойСформироватьПечатнуюФормуПротоколаЗакупкиПоТипу(
												ЗакупочнаяПроцедура,
												ТипПротокола) Экспорт
	НастройкиФормированияОтчета = Новый Структура;
	НастройкиФормированияОтчета.Вставить(
		"ВыводитьНоменклатуруПоставщиков",
		Истина);
	Возврат Отчеты.ПротоколЗакупочнойПроцедуры.СформироватьПечатнуюФормуПротоколаПоТипу(
		ЗакупочнаяПроцедура,
		ТипПротокола,
		НастройкиФормированияОтчета);
КонецФункции


#КонецОбласти


#Область ВнутреннийПрограммныйИнтерфейс


Функция ПолучитьТаблицуИерархииКодаОКПД2(КодОКПД2)
	ТаблицаОКПД2 = Новый ТаблицаЗначений;
	ТаблицаОКПД2.Колонки.Добавить("ОКПД2", ОбщегоНазначения.ОписаниеТипаСтрока(20));
	ТаблицаОКПД2.Колонки.Добавить("КодРодителя", ОбщегоНазначения.ОписаниеТипаСтрока(20));
	ТаблицаОКПД2.Колонки.Добавить("Приоритет", ОбщегоНазначения.ОписаниеТипаЧисло(3,0));
	ДобавитьОКПД2(ТаблицаОКПД2, КодОКПД2);
	Возврат ТаблицаОКПД2;
КонецФункции

Процедура ДобавитьОКПД2(ТаблицаОКПД2, КодОКПД2)
	Массив = СтрРазделить(КодОКПД2, ".");
	ВсегоГрупп = Массив.Количество();
	Для Приоритет = 1 По ВсегоГрупп Цикл
		КодРодителя = "";
		Для Поз = 1 По ВсегоГрупп - Приоритет + 1 Цикл
			КодРодителя = КодРодителя + ?(КодРодителя = "", "", ".") + Массив[Поз-1];
		КонецЦикла; 
		СтрокаТаблицы = ТаблицаОКПД2.Добавить();
		СтрокаТаблицы.ОКПД2 = КодОКПД2;
		СтрокаТаблицы.КодРодителя = КодРодителя;
		СтрокаТаблицы.Приоритет = Приоритет;
	КонецЦикла; 
КонецПроцедуры

Функция ПолучитьФлагиОсобогоПорядкаЗакупкиПоОКПД2(КодОКПД2)
	Если НЕ ЗначениеЗаполнено(КодОКПД2) Тогда
		Возврат Неопределено;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(КодОКПД2) Тогда
		Возврат Неопределено;
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Таблица.ОКПД2 КАК ОКПД2,
	|	Таблица.КодРодителя КАК КодРодителя,
	|	Таблица.Приоритет КАК Приоритет
	|ПОМЕСТИТЬ ВТ_КодыОКПД2
	|ИЗ
	|	&ТаблицаОКПД2 КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТ_КодыОКПД2.ОКПД2 КАК ОКПД2,
	|	ВТ_КодыОКПД2.Приоритет КАК Приоритет,
	|	КлассификаторПродукцииПоВидамДеятельности.Ссылка КАК Ссылка,
	|	ВТ_КодыОКПД2.КодРодителя КАК КодРодителя
	|ПОМЕСТИТЬ ВТ_КлассификаторПриоритет
	|ИЗ
	|	ВТ_КодыОКПД2 КАК ВТ_КодыОКПД2
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлассификаторОКПД2 КАК КлассификаторПродукцииПоВидамДеятельности
	|		ПО ВТ_КодыОКПД2.КодРодителя = КлассификаторПродукцииПоВидамДеятельности.Код
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТ_КлассификаторПриоритет.ОКПД2 КАК ОКПД2,
	|	ВТ_КлассификаторПриоритет.Приоритет КАК Приоритет,
	|	ВТ_КлассификаторПриоритет.КодРодителя КАК КодРодителя,
	|	НоменклатураСОсобымПорядкомЗакупки.УровеньКонтроляНоменклатуры КАК УровеньКонтроляНоменклатуры,
	|	НоменклатураСОсобымПорядкомЗакупки.ЗакупкаВЭлектроннойФорме КАК ЗакупкаВЭлектроннойФорме,
	|	НоменклатураСОсобымПорядкомЗакупки.ПриоритетУчастияМалогоИСреднегоПредпринимательства КАК ПриоритетУчастияМалогоИСреднегоПредпринимательства,
	|	НоменклатураСОсобымПорядкомЗакупки.ПривлечениеМалогоИСреднегоПредпринимательстваКакПодрядчиков КАК ПривлечениеМалогоИСреднегоПредпринимательстваКакПодрядчиков,
	|	НоменклатураСОсобымПорядкомЗакупки.ЗакупкаСодержитСведенияОтносящиесяКГосударственнойТайне КАК ЗакупкаСодержитСведенияОтносящиесяКГосударственнойТайне,
	|	НоменклатураСОсобымПорядкомЗакупки.ЗакупкаИнновационнойВысокотехнологичнойПродукцииИЛекарственныхСредств КАК ЗакупкаИнновационнойВысокотехнологичнойПродукцииИЛекарственныхСредств,
	|	НоменклатураСОсобымПорядкомЗакупки.Организатор КАК Организатор,
	|	НоменклатураСОсобымПорядкомЗакупки.Заказчик КАК Заказчик,
	|	НоменклатураСОсобымПорядкомЗакупки.НеУчитыватьПриРасчетеДолиЗакупокУСМП КАК НеУчитыватьПриРасчетеДолиЗакупокУСМП,
	|	НоменклатураСОсобымПорядкомЗакупки.СпособВыбораПоставщика КАК СпособВыбораПоставщика,
	|	НоменклатураСОсобымПорядкомЗакупки.МетодОценкиПредложенийПоставщиков КАК МетодОценкиПредложенийПоставщиков,
	|	НоменклатураСОсобымПорядкомЗакупки.ТребуетсяОбоснование КАК ТребуетсяОбоснование
	|ПОМЕСТИТЬ ВТ_Данные
	|ИЗ
	|	ВТ_КлассификаторПриоритет КАК ВТ_КлассификаторПриоритет
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураСОсобымПорядкомЗакупки КАК НоменклатураСОсобымПорядкомЗакупки
	|		ПО ВТ_КлассификаторПриоритет.Ссылка = НоменклатураСОсобымПорядкомЗакупки.УровеньКонтроляНоменклатуры
	|			И (НоменклатураСОсобымПорядкомЗакупки.УровеньКонтроляНоменклатуры ССЫЛКА Справочник.КлассификаторОКПД2)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Данные.ОКПД2 КАК ОКПД2,
	|	МИНИМУМ(ВТ_Данные.Приоритет) КАК Приоритет
	|ПОМЕСТИТЬ ВТ_МинимальныйПриоритет
	|ИЗ
	|	ВТ_Данные КАК ВТ_Данные
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Данные.ОКПД2
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТ_Данные.ОКПД2 КАК ОКПД2,
	|	ВТ_Данные.Приоритет КАК Приоритет,
	|	ВТ_Данные.КодРодителя КАК КодРодителя,
	|	ВТ_Данные.УровеньКонтроляНоменклатуры КАК УровеньКонтроляНоменклатуры,
	|	ВТ_Данные.ЗакупкаВЭлектроннойФорме КАК ЗакупкаВЭлектроннойФорме,
	|	ВТ_Данные.ПриоритетУчастияМалогоИСреднегоПредпринимательства КАК ПриоритетУчастияМалогоИСреднегоПредпринимательства,
	|	ВТ_Данные.ПривлечениеМалогоИСреднегоПредпринимательстваКакПодрядчиков КАК ПривлечениеМалогоИСреднегоПредпринимательстваКакПодрядчиков,
	|	ВТ_Данные.ЗакупкаСодержитСведенияОтносящиесяКГосударственнойТайне КАК ЗакупкаСодержитСведенияОтносящиесяКГосударственнойТайне,
	|	ВТ_Данные.ЗакупкаИнновационнойВысокотехнологичнойПродукцииИЛекарственныхСредств КАК ЗакупкаИнновационнойВысокотехнологичнойПродукцииИЛекарственныхСредств,
	|	ВТ_Данные.Организатор КАК Организатор,
	|	ВТ_Данные.Заказчик КАК Заказчик,
	|	ВТ_Данные.НеУчитыватьПриРасчетеДолиЗакупокУСМП КАК НеУчитыватьПриРасчетеДолиЗакупокУСМП,
	|	ВТ_Данные.СпособВыбораПоставщика КАК СпособВыбораПоставщика,
	|	ВТ_Данные.МетодОценкиПредложенийПоставщиков КАК МетодОценкиПредложенийПоставщиков,
	|	ВТ_Данные.ТребуетсяОбоснование КАК ТребуетсяОбоснование
	|ИЗ
	|	ВТ_МинимальныйПриоритет КАК ВТ_МинимальныйПриоритет
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Данные КАК ВТ_Данные
	|		ПО ВТ_МинимальныйПриоритет.ОКПД2 = ВТ_Данные.ОКПД2
	|			И ВТ_МинимальныйПриоритет.Приоритет = ВТ_Данные.Приоритет";
	Запрос.УстановитьПараметр("ТаблицаОКПД2", 
		ПолучитьТаблицуИерархииКодаОКПД2(КодОКПД2));
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	Выб = Результат.Выбрать();
	Выб.Следующий();
	Возврат Выб;
КонецФункции

Функция ПолучитьФлагиОсобогоПорядкаЗакупкиПоТоварнойКатегории(Номенклатура)
	Если НЕ ЗначениеЗаполнено(Номенклатура) Тогда
		Возврат Неопределено;
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	1 КАК Приоритет,
	|	НоменклатураСОсобымПорядкомЗакупки.УровеньКонтроляНоменклатуры КАК УровеньКонтроляНоменклатуры,
	|	НоменклатураСОсобымПорядкомЗакупки.ЗакупкаВЭлектроннойФорме КАК ЗакупкаВЭлектроннойФорме,
	|	НоменклатураСОсобымПорядкомЗакупки.ПриоритетУчастияМалогоИСреднегоПредпринимательства КАК ПриоритетУчастияМалогоИСреднегоПредпринимательства,
	|	НоменклатураСОсобымПорядкомЗакупки.ПривлечениеМалогоИСреднегоПредпринимательстваКакПодрядчиков КАК ПривлечениеМалогоИСреднегоПредпринимательстваКакПодрядчиков,
	|	НоменклатураСОсобымПорядкомЗакупки.ЗакупкаСодержитСведенияОтносящиесяКГосударственнойТайне КАК ЗакупкаСодержитСведенияОтносящиесяКГосударственнойТайне,
	|	НоменклатураСОсобымПорядкомЗакупки.ЗакупкаИнновационнойВысокотехнологичнойПродукцииИЛекарственныхСредств КАК ЗакупкаИнновационнойВысокотехнологичнойПродукцииИЛекарственныхСредств,
	|	НоменклатураСОсобымПорядкомЗакупки.Организатор КАК Организатор,
	|	НоменклатураСОсобымПорядкомЗакупки.Заказчик КАК Заказчик,
	|	НоменклатураСОсобымПорядкомЗакупки.НеУчитыватьПриРасчетеДолиЗакупокУСМП КАК НеУчитыватьПриРасчетеДолиЗакупокУСМП,
	|	НоменклатураСОсобымПорядкомЗакупки.СпособВыбораПоставщика КАК СпособВыбораПоставщика,
	|	НоменклатураСОсобымПорядкомЗакупки.МетодОценкиПредложенийПоставщиков КАК МетодОценкиПредложенийПоставщиков,
	|	НоменклатураСОсобымПорядкомЗакупки.ТребуетсяОбоснование КАК ТребуетсяОбоснование
	|ПОМЕСТИТЬ Данные
	|ИЗ
	|	РегистрСведений.НоменклатураСОсобымПорядкомЗакупки КАК НоменклатураСОсобымПорядкомЗакупки
	|ГДЕ
	|	НоменклатураСОсобымПорядкомЗакупки.УровеньКонтроляНоменклатуры ССЫЛКА Справочник.Номенклатура
	|	И &НоменклатураУказана = ИСТИНА
	|	И НоменклатураСОсобымПорядкомЗакупки.УровеньКонтроляНоменклатуры = &Номенклатура
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2,
	|	НоменклатураСОсобымПорядкомЗакупки.УровеньКонтроляНоменклатуры,
	|	НоменклатураСОсобымПорядкомЗакупки.ЗакупкаВЭлектроннойФорме,
	|	НоменклатураСОсобымПорядкомЗакупки.ПриоритетУчастияМалогоИСреднегоПредпринимательства,
	|	НоменклатураСОсобымПорядкомЗакупки.ПривлечениеМалогоИСреднегоПредпринимательстваКакПодрядчиков,
	|	НоменклатураСОсобымПорядкомЗакупки.ЗакупкаСодержитСведенияОтносящиесяКГосударственнойТайне,
	|	НоменклатураСОсобымПорядкомЗакупки.ЗакупкаИнновационнойВысокотехнологичнойПродукцииИЛекарственныхСредств,
	|	НоменклатураСОсобымПорядкомЗакупки.Организатор,
	|	НоменклатураСОсобымПорядкомЗакупки.Заказчик,
	|	НоменклатураСОсобымПорядкомЗакупки.НеУчитыватьПриРасчетеДолиЗакупокУСМП,
	|	НоменклатураСОсобымПорядкомЗакупки.СпособВыбораПоставщика,
	|	НоменклатураСОсобымПорядкомЗакупки.МетодОценкиПредложенийПоставщиков,
	|	НоменклатураСОсобымПорядкомЗакупки.ТребуетсяОбоснование
	|ИЗ
	|	РегистрСведений.НоменклатураСОсобымПорядкомЗакупки КАК НоменклатураСОсобымПорядкомЗакупки
	|ГДЕ
	|	НоменклатураСОсобымПорядкомЗакупки.УровеньКонтроляНоменклатуры ССЫЛКА Справочник.ТоварныеКатегории
	|	И НоменклатураСОсобымПорядкомЗакупки.УровеньКонтроляНоменклатуры = &ТоварнаяКатегория
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(Данные.Приоритет) КАК Приоритет
	|ПОМЕСТИТЬ ВТ_ПервыйПриоритет
	|ИЗ
	|	Данные КАК Данные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Данные.Приоритет КАК Приоритет,
	|	Данные.УровеньКонтроляНоменклатуры КАК УровеньКонтроляНоменклатуры,
	|	Данные.Приоритет КАК Приоритет1,
	|	Данные.УровеньКонтроляНоменклатуры КАК УровеньКонтроляНоменклатуры1,
	|	Данные.ЗакупкаВЭлектроннойФорме КАК ЗакупкаВЭлектроннойФорме,
	|	Данные.ПриоритетУчастияМалогоИСреднегоПредпринимательства КАК ПриоритетУчастияМалогоИСреднегоПредпринимательства,
	|	Данные.ПривлечениеМалогоИСреднегоПредпринимательстваКакПодрядчиков КАК ПривлечениеМалогоИСреднегоПредпринимательстваКакПодрядчиков,
	|	Данные.ЗакупкаСодержитСведенияОтносящиесяКГосударственнойТайне КАК ЗакупкаСодержитСведенияОтносящиесяКГосударственнойТайне,
	|	Данные.ЗакупкаИнновационнойВысокотехнологичнойПродукцииИЛекарственныхСредств КАК ЗакупкаИнновационнойВысокотехнологичнойПродукцииИЛекарственныхСредств,
	|	Данные.Организатор КАК Организатор,
	|	Данные.Заказчик КАК Заказчик,
	|	Данные.НеУчитыватьПриРасчетеДолиЗакупокУСМП КАК НеУчитыватьПриРасчетеДолиЗакупокУСМП,
	|	Данные.СпособВыбораПоставщика КАК СпособВыбораПоставщика,
	|	Данные.МетодОценкиПредложенийПоставщиков КАК МетодОценкиПредложенийПоставщиков,
	|	Данные.ТребуетсяОбоснование КАК ТребуетсяОбоснование
	|ИЗ
	|	ВТ_ПервыйПриоритет КАК ВТ_ПервыйПриоритет
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Данные КАК Данные
	|		ПО ВТ_ПервыйПриоритет.Приоритет = Данные.Приоритет";
	Если ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Номенклатура, "ТоварнаяКатегория");
		Запрос.УстановитьПараметр("НоменклатураУказана", Истина);
		Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
		Запрос.УстановитьПараметр("ТоварнаяКатегория", Реквизиты.ТоварнаяКатегория);
	Иначе
		Запрос.УстановитьПараметр("НоменклатураУказана", Ложь);
		Запрос.УстановитьПараметр("Номенклатура", Справочники.Номенклатура.ПустаяСсылка());
		Запрос.УстановитьПараметр("ТоварнаяКатегория", Номенклатура);
	КонецЕсли; 
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	Выб = Результат.Выбрать();
	Выб.Следующий();
	Возврат Выб;
КонецФункции


#КонецОбласти
