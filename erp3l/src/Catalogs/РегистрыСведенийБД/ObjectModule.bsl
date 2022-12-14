Перем ТекСоединениеВИБ Экспорт; // Текущее соединение с внешней информационной базой

Процедура ЗаполнитьРеквизитыОбъекта(Кэш = Неопределено, ЕстьИзменения = Истина) Экспорт
	
	Если Не ПроверитьНаименование() Тогда	
		Возврат;		
	КонецЕсли;
	
	ТекущаяИБ = (Владелец = Справочники.ТипыБазДанных.ТекущаяИБ);
	
	Если Не ТекущаяИБ Тогда
		
		Если ТекСоединениеВИБ = Неопределено Тогда
			
			ТекСоединениеВИБ = ОбщегоНазначенияУХ.ПолучитьСоединениеСВИБПоУмолчанию(Владелец, 1);
			
			Если ТекСоединениеВИБ = Неопределено Тогда
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ТекСоединениеВИБ = Обработки.РаботаСМетаданнымиУХ.Создать();
		
	КонецЕсли;
		
	СтруктураОписания = ОбщегоНазначенияУХ.ПолучитьСтруктуруОписанияРегистраСведенийБД(Наименование, ТекСоединениеВИБ, Кэш);
	Если НЕ ЗначениеЗаполнено(СтруктураОписания.Регистраторы) Тогда
		СтруктураОписания.Регистраторы = "";
	КонецЕсли;
	
	Если СтруктураОписания.Свойство("ТекстОшибки") Тогда
		
		ОбщегоНазначенияУХ.СообщитьОбОшибке(СтруктураОписания.ТекстОшибки, Истина,, СтатусСообщения.Внимание);
		Возврат;
		
	КонецЕсли;
	
	ОбщегоНазначенияУХ.ЗаполнитьИзмененныеРеквизиты(ЭтотОбъект, СтруктураОписания, "Реквизиты,Измерения,Ресурсы", ЕстьИзменения);
	ОбщегоНазначенияУХ.ЗагрузитьИзмененнуюТабЧасть(Ресурсы, СтруктураОписания.Ресурсы, ЕстьИзменения);
	ОбщегоНазначенияУХ.ЗагрузитьИзмененнуюТабЧасть(Измерения, СтруктураОписания.Измерения, ЕстьИзменения);
	ОбщегоНазначенияУХ.ЗагрузитьИзмененнуюТабЧасть(Реквизиты, СтруктураОписания.Реквизиты, ЕстьИзменения);	
	
КонецПроцедуры // ЗаполнитьРеквизитыОбъекта()

Процедура УстановитьСоответствияПолейИСправочниковБД()
	
	ТаблицаРеквизитовСправочников = Новый ТаблицаЗначений;
	ТаблицаРеквизитовСправочников.Колонки.Добавить("Вид", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(1000)));
	ТаблицаРеквизитовСправочников.Колонки.Добавить("ИмяПоля", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(1000)));
	ТаблицаРеквизитовСправочников.Колонки.Добавить("ЭтоИзмерение", Новый ОписаниеТипов("Булево"));
	
	ЭтоИзмерение = Истина;
	ДобавитьТипыРеквизитовВТаблицу(ТаблицаРеквизитовСправочников, Измерения, "Справочник", ЭтоИзмерение);
	ДобавитьТипыРеквизитовВТаблицу(ТаблицаРеквизитовСправочников, Ресурсы, "Справочник");
	ДобавитьТипыРеквизитовВТаблицу(ТаблицаРеквизитовСправочников, Реквизиты, "Справочник");
	
	Если ЗначениеЗаполнено(ТаблицаРеквизитовСправочников) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаРеквизитовСправочников.Вид КАК Вид,
		|	ТаблицаРеквизитовСправочников.ИмяПоля КАК ИмяПоля,
		|	ТаблицаРеквизитовСправочников.ЭтоИзмерение КАК ЭтоИзмерение
		|ПОМЕСТИТЬ ТаблицаРеквизитовСправочников
		|ИЗ
		|	&ТаблицаРеквизитовСправочников КАК ТаблицаРеквизитовСправочников
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Вид
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СправочникиБД.Ссылка КАК СправочникБД,
		|	ТаблицаРеквизитовСправочников.ИмяПоля КАК ИмяПоля,
		|	МАКСИМУМ(ТаблицаРеквизитовСправочников.ЭтоИзмерение) КАК ЭтоИзмерение,
		|	&ПодчинениеРегистратору КАК ПодчинениеРегистратору
		|ПОМЕСТИТЬ ВТ_НовыйНабор
		|ИЗ
		|	ТаблицаРеквизитовСправочников КАК ТаблицаРеквизитовСправочников
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СправочникиБД КАК СправочникиБД
		|		ПО (СправочникиБД.Владелец = &ТипБД)
		|			И ТаблицаРеквизитовСправочников.Вид = СправочникиБД.Наименование
		|
		|СГРУППИРОВАТЬ ПО
		|	СправочникиБД.Ссылка,
		|	ТаблицаРеквизитовСправочников.ИмяПоля
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	СправочникБД,
		|	ИмяПоля
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РегистрыСведенийИСвязанныеСправочникиБД.СправочникБД КАК СправочникБД,
		|	РегистрыСведенийИСвязанныеСправочникиБД.ИмяПоля КАК ИмяПоля,
		|	РегистрыСведенийИСвязанныеСправочникиБД.Измерение КАК ЭтоИзмерение,
		|	РегистрыСведенийИСвязанныеСправочникиБД.ПодчинениеРегистратору КАК ПодчинениеРегистратору
		|ПОМЕСТИТЬ ВТ_СтарыйНабор
		|ИЗ
		|	РегистрСведений.РегистрыСведенийИСвязанныеСправочникиБД КАК РегистрыСведенийИСвязанныеСправочникиБД
		|ГДЕ
		|	РегистрыСведенийИСвязанныеСправочникиБД.ТипБД = &ТипБД
		|	И РегистрыСведенийИСвязанныеСправочникиБД.РегистрСведенийБД = &РегистрСведенийБД
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	СправочникБД,
		|	ИмяПоля
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(ВТ_НовыйНабор.СправочникБД, ВТ_СтарыйНабор.СправочникБД) КАК СправочникБД,
		|	ЕСТЬNULL(ВТ_НовыйНабор.ИмяПоля, ВТ_СтарыйНабор.ИмяПоля) КАК ИмяПоля,
		|	ЕСТЬNULL(ВТ_НовыйНабор.ЭтоИзмерение, ВТ_СтарыйНабор.ЭтоИзмерение) КАК Измерение,
		|	ЕСТЬNULL(ВТ_НовыйНабор.ПодчинениеРегистратору, ВТ_СтарыйНабор.ПодчинениеРегистратору) КАК ПодчинениеРегистратору,
		|	ВЫБОР
		|		КОГДА НЕ ВТ_НовыйНабор.ИмяПоля ЕСТЬ NULL
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ДобавленнаяЗапись
		|ИЗ
		|	ВТ_НовыйНабор КАК ВТ_НовыйНабор
		|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_СтарыйНабор КАК ВТ_СтарыйНабор
		|		ПО ВТ_НовыйНабор.СправочникБД = ВТ_СтарыйНабор.СправочникБД
		|			И ВТ_НовыйНабор.ИмяПоля = ВТ_СтарыйНабор.ИмяПоля
		|ГДЕ
		|	(ВТ_НовыйНабор.ИмяПоля ЕСТЬ NULL
		|			ИЛИ ВТ_СтарыйНабор.ИмяПоля ЕСТЬ NULL
		|			ИЛИ ВТ_НовыйНабор.ЭтоИзмерение <> ВТ_СтарыйНабор.ЭтоИзмерение
		|			ИЛИ ВТ_НовыйНабор.ПодчинениеРегистратору <> ВТ_СтарыйНабор.ПодчинениеРегистратору)";
		
		ПодчинениеРегистратору = (СтрДлина(Регистраторы) > 0);
		
		Запрос.УстановитьПараметр("ТипБД", ЭтотОбъект.Владелец);
		Запрос.УстановитьПараметр("РегистрСведенийБД", ЭтотОбъект.Ссылка);
		Запрос.УстановитьПараметр("ПодчинениеРегистратору", ПодчинениеРегистратору);
		Запрос.УстановитьПараметр("ТаблицаРеквизитовСправочников", ТаблицаРеквизитовСправочников);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НаборЗаписей = РегистрыСведений.РегистрыСведенийИСвязанныеСправочникиБД.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ТипБД.Установить(ЭтотОбъект.Владелец);
			НаборЗаписей.Отбор.РегистрСведенийБД.Установить(ЭтотОбъект.Ссылка);
			НаборЗаписей.Отбор.СправочникБД.Установить(Выборка.СправочникБД);
			НаборЗаписей.Отбор.ИмяПоля.Установить(Выборка.ИмяПоля);
			
			Если Выборка.ДобавленнаяЗапись Тогда
				НоваяСтрока = НаборЗаписей.Добавить();
				НоваяСтрока.ТипБД = ЭтотОбъект.Владелец;
				НоваяСтрока.РегистрСведенийБД = ЭтотОбъект.Ссылка;
				НоваяСтрока.СправочникБД = Выборка.СправочникБД;
				НоваяСтрока.ИмяПоля = Выборка.ИмяПоля;
				НоваяСтрока.Измерение = Выборка.Измерение;
				НоваяСтрока.ПодчинениеРегистратору = ПодчинениеРегистратору;
			Иначе
				// удаление записи
			КонецЕсли;
			
			НаборЗаписей.ОбменДанными.Загрузка = Истина;
			НаборЗаписей.Записать(Истина);

		КонецЦикла;
		
	КонецЕсли;
			
КонецПроцедуры // УстановитьСоответствияПолейИСправочниковБД()

Процедура ДобавитьТипыРеквизитовВТаблицу(ТаблицаТиповРеквизитов, ТаблицаРеквизитов, ВыбранныйТип, ЭтоИзмерение = Ложь)
	
	Для Каждого СтрокаРеквизита ИЗ ТаблицаРеквизитов Цикл
		
		МассивТипов = СтрРазделить(СтрокаРеквизита.ТипДанных, ";");
		
		Для Каждого СтрТип ИЗ МассивТипов Цикл
			
			ОписаниеТипа = СтрРазделить(СтрТип, ".");	
			Если ОписаниеТипа.Количество() = 2 И ОписаниеТипа[0] = ВыбранныйТип Тогда
				
				СтрокаТиповРеквизитов = ТаблицаТиповРеквизитов.Добавить();
				СтрокаТиповРеквизитов.Вид = ОписаниеТипа[1];
				СтрокаТиповРеквизитов.ИмяПоля = СтрокаРеквизита.Имя;
				СтрокаТиповРеквизитов.ЭтоИзмерение = ЭтоИзмерение;
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;

КонецПроцедуры
	
Функция ПроверитьНаименование()
	
	ЕстьОшибки = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		
		ОбщегоНазначенияУХ.СообщитьОбОшибке(
			Нстр("ru = 'Для обрабатываемого регистра сведений внешней информационной базы не указано наименование.'"),
			ЕстьОшибки,,СтатусСообщения.Внимание);
		
	КонецЕсли;
	
	Возврат НЕ ЕстьОшибки;
			
КонецФункции // ПроверитьНаименование()

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = НЕ ПроверитьНаименование();
		
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда		
		Возврат;		
	КонецЕсли;
	
	УстановитьСоответствияПолейИСправочниковБД();
			
КонецПроцедуры