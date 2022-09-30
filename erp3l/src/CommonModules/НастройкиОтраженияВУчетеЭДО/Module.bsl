
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает способ обработки электронного документа.
//   
// Параметры:
// 	КлючНастроек - см. НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтраженияВУчете
// 	
// Возвращаемое значение:
//  Структура:
// 	 * СпособОбработки - Строка - Способ обработки
// 	 * ПредлагатьСохранятьНастройки - Булево - предлагать сохранять настройки.
Функция НастройкиОтраженияВУчете(КлючНастроек) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("СпособОбработки", "Вручную");
	Результат.Вставить("ПредлагатьСохранятьНастройки", Ложь);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиПолученияЭлектронныхДокументов.СпособОбработки КАК СпособОбработки,
	|	НЕ НастройкиПолученияЭлектронныхДокументов.НеПредлагатьСохранятьНастройки КАК ПредлагатьСохранятьНастройки
	|ИЗ
	|	РегистрСведений.НастройкиПолученияЭлектронныхДокументов КАК НастройкиПолученияЭлектронныхДокументов
	|ГДЕ
	|	НастройкиПолученияЭлектронныхДокументов.ВидДокумента В (&ВидДокумента)
	|	И НастройкиПолученияЭлектронныхДокументов.Получатель = &Получатель
	|	И НастройкиПолученияЭлектронныхДокументов.Отправитель = &Отправитель
	|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя = &ИдентификаторОтправителя
	|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя = &ИдентификаторПолучателя
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкиПолученияЭлектронныхДокументов.СпособОбработки КАК СпособОбработки,
	|	НЕ НастройкиПолученияЭлектронныхДокументов.НеПредлагатьСохранятьНастройки КАК ПредлагатьСохранятьНастройки
	|ИЗ
	|	РегистрСведений.НастройкиПолученияЭлектронныхДокументов КАК НастройкиПолученияЭлектронныхДокументов
	|ГДЕ
	|	НастройкиПолученияЭлектронныхДокументов.ВидДокумента В (&ВидДокумента)
	|	И НастройкиПолученияЭлектронныхДокументов.Получатель = &Получатель
	|	И НастройкиПолученияЭлектронныхДокументов.Отправитель = &Отправитель
	|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя = """"
	|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя = """"";
	
	Запрос.УстановитьПараметр("Отправитель"             , КлючНастроек.Отправитель);
	Запрос.УстановитьПараметр("Получатель"              , КлючНастроек.Получатель);
	Запрос.УстановитьПараметр("ИдентификаторОтправителя", КлючНастроек.ИдентификаторОтправителя);
	Запрос.УстановитьПараметр("ИдентификаторПолучателя" , КлючНастроек.ИдентификаторПолучателя);
	Запрос.УстановитьПараметр("ВидДокумента"        	, КлючНастроек.ВидДокумента);	
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	РезультатЗапроса = РезультатыЗапроса[0];
	Если РезультатЗапроса.Пустой() Тогда
		РезультатЗапроса = РезультатыЗапроса[1];
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует(
			"ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС") Тогда
			МодульЭлектронноеАктированиеЕИС = ОбщегоНазначения.ОбщийМодуль("ЭлектронноеАктированиеЕИС");
			Если МодульЭлектронноеАктированиеЕИС.
				ИспользоватьЭлектронноеАктированиеВЕИС() Тогда
				МодульЭлектронноеАктированиеЕИС.НастройкиОтраженияВУчете(
					КлючНастроек, Результат);
			КонецЕсли;
		КонецЕсли;
			
		Возврат Результат;
		
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		
		Результат.Вставить("СпособОбработки", Выборка.СпособОбработки);
		Результат.Вставить("ПредлагатьСохранятьНастройки", Выборка.ПредлагатьСохранятьНастройки);

	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаписатьНастройкуПолученияДокументов(КлючНастроек, СпособОбработки, НеПредлагатьСохранятьНастройки, Отказ) Экспорт
	
	Если КлючНастроек = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ТекущаяНастройка = ТекущаяНастройкаОтраженияВУчете(КлючНастроек);
	
	Если ТекущаяНастройка = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НастройкиПолученияЭлектронныхДокументов");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Получатель"              , ТекущаяНастройка.Получатель);
		ЭлементБлокировки.УстановитьЗначение("Отправитель"             , ТекущаяНастройка.Отправитель);
		ЭлементБлокировки.УстановитьЗначение("ИдентификаторОтправителя", ТекущаяНастройка.ИдентификаторОтправителя);
		ЭлементБлокировки.УстановитьЗначение("ИдентификаторПолучателя" , ТекущаяНастройка.ИдентификаторПолучателя);
		ЭлементБлокировки.УстановитьЗначение("ВидДокумента"            , ТекущаяНастройка.ВидДокумента);
		Блокировка.Заблокировать();
		
		МенеджерЗаписи = РегистрыСведений.НастройкиПолученияЭлектронныхДокументов.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ТекущаяНастройка);
		МенеджерЗаписи.Прочитать();
		
		Если Не МенеджерЗаписи.Выбран() Тогда
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ТекущаяНастройка);
		КонецЕсли;
		
		Записать = Ложь;
		Если СпособОбработки <> Неопределено Тогда
			Записать = Истина;
			МенеджерЗаписи.СпособОбработки = СпособОбработки;
		КонецЕсли;
		
		Если НеПредлагатьСохранятьНастройки <> Неопределено Тогда
			Записать = Истина;
			МенеджерЗаписи.НеПредлагатьСохранятьНастройки = НеПредлагатьСохранятьНастройки;
		КонецЕсли;
		
		Если Записать Тогда
			
			МенеджерЗаписи.Записать();
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Отказ = Истина;
		
		Информация = ИнформацияОбОшибке();
		
		ЭлектронноеВзаимодействие.ОбработатьОшибку(НСтр("ru = 'Обновление настроек отражения в учете';
														|en = 'Update accounting registration settings'"),
			ПодробноеПредставлениеОшибки(Информация),
			НСтр("ru = 'Не удалось обновить настройки отражения в учете';
				|en = 'Cannot update accounting registration settings'"));
	КонецПопытки;
	
КонецПроцедуры

// См. НастройкиЭДО.СоздатьНастройкиОтраженияВУчете
Процедура СоздатьНастройкиОтраженияВУчете(Организация, Контрагент, ИдентификаторОрганизации, ИдентификаторКонтрагента,
	Отказ = Ложь) Экспорт
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("СоздатьНастройкиОтраженияВУчетеЭДО", "Организация",
		Организация, Метаданные.ОпределяемыеТипы.Организация.Тип);
		
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("СоздатьНастройкиОтраженияВУчетеЭДО", "Контрагент",
		Контрагент, Метаданные.ОпределяемыеТипы.УчастникЭДО.Тип);
	
	ОписаниеТиповСтрока100 = Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(100));
	ТекущаяТаблица = ЭлектронныеДокументыЭДО.ШаблонНастроекОтраженияВУчете(
		ИнтеграцияЭДО.ПрофилиНастроекОтраженияВходящихДокументов().ПервоначальноеЗаполнение);
	ТекущаяТаблица.Колонки.Добавить("Отправитель"              , Метаданные.ОпределяемыеТипы.УчастникЭДО.Тип);
	ТекущаяТаблица.Колонки.Добавить("Получатель"               , Метаданные.ОпределяемыеТипы.Организация.Тип);
	ТекущаяТаблица.Колонки.Добавить("ИдентификаторОтправителя" , ОписаниеТиповСтрока100);
	ТекущаяТаблица.Колонки.Добавить("ИдентификаторПолучателя"  , ОписаниеТиповСтрока100);
	
	ТекущаяТаблица.ЗаполнитьЗначения(Контрагент               , "Отправитель");
	ТекущаяТаблица.ЗаполнитьЗначения(Организация              , "Получатель");
	ТекущаяТаблица.ЗаполнитьЗначения(ИдентификаторКонтрагента , "ИдентификаторОтправителя");
	ТекущаяТаблица.ЗаполнитьЗначения(ИдентификаторОрганизации , "ИдентификаторПолучателя");
	
	НоваяТаблица = ТекущиеНастройкиОтраженияВУчете(Организация, Контрагент, ИдентификаторОрганизации,
		ИдентификаторКонтрагента, ТекущаяТаблица);
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НастройкиПолученияЭлектронныхДокументов");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Отправитель" , Контрагент  );
		ЭлементБлокировки.УстановитьЗначение("Получатель"  , Организация );
		
		Блокировка.Заблокировать();
		
		НастройкиОтправкиЭД = РегистрыСведений.НастройкиПолученияЭлектронныхДокументов.СоздатьНаборЗаписей();
		НастройкиОтправкиЭД.Отбор.Отправитель.Установить(Контрагент);
		НастройкиОтправкиЭД.Отбор.Получатель.Установить(Организация);
		НастройкиОтправкиЭД.Загрузить(НоваяТаблица);
		НастройкиОтправкиЭД.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Информация = ИнформацияОбОшибке();
		ЭлектронноеВзаимодействие.ОбработатьОшибку(НСтр("ru = 'Создание настроек отражения в учете электронных документов';
														|en = 'Create settings of recording in electronic document accounting'"),
			ПодробноеПредставлениеОшибки(Информация), КраткоеПредставлениеОшибки(Информация));
		Отказ = Истина;
		
	КонецПопытки;
	
КонецПроцедуры

// См. СинхронизацияЭДОСобытия.ПриУдаленииУчетнойЗаписи
Процедура ПриУдаленииУчетнойЗаписи(ИдентификаторУчетнойЗаписи) Экспорт
	
	НаборЗаписей = РегистрыСведений.НастройкиПолученияЭлектронныхДокументов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдентификаторПолучателя.Установить(ИдентификаторУчетнойЗаписи);
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Возвращает настройки получения ЭД по ИД участников.
//
// Параметры:
//  ИДОтправителя - Строка - строка с уникальный идентификатор отправителя.
//  ИДПолучателя  - Строка - строка с уникальный идентификатор получателя.
//  Организация   - ОпределяемыйТип.Организация - ссылка на справочник организаций.
//  Контрагент  - ОпределяемыйТип.УчастникЭДО - ссылка на справочник контрагенты.
//  СоздаватьНастройки - Булево - создавать настройки автоматически.
//
// Возвращаемое значение:
//  Структура - структура параметров с настройками обмена.
//
Функция ПолучитьНастройкиПолученияПоИдентификаторам(ИДОтправителя, ИДПолучателя,
							Организация, Контрагент,
							СоздаватьНастройки = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыНастройки = Неопределено;
	
	Запросы = Новый Массив;
	ОтборПриглашений = СинхронизацияЭДО.НовыйОтборПриглашений();
	ОтборПриглашений.ИдентификаторОрганизации = "&ИдентификаторПолучателя";
	ОтборПриглашений.ИдентификаторКонтрагента = "&ИдентификаторОтправителя";
	ЗапросПриглашений = СинхронизацияЭДО.ЗапросПриглашений("ПриглашенияКОбменуЭлектроннымиДокументами",
		ОтборПриглашений);
	Запросы.Добавить(ЗапросПриглашений);
	
	ОтборУчетныхЗаписей = СинхронизацияЭДО.НовыйОтборУчетныхЗаписей();
	ОтборУчетныхЗаписей.УчетныеЗаписи = "&ИдентификаторПолучателя";
	ЗапросУчетныхЗаписей = СинхронизацияЭДО.ЗапросУчетныхЗаписей("УчетныеЗаписиЭДО", ОтборУчетныхЗаписей);
	Запросы.Добавить(ЗапросУчетныхЗаписей);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПриглашенияКОбменуЭлектроннымиДокументами.Статус КАК Статус,
	|	УчетныеЗаписиЭДО.Организация КАК Организация,
	|	ПриглашенияКОбменуЭлектроннымиДокументами.Контрагент КАК Контрагент
	|ИЗ
	|	ПриглашенияКОбменуЭлектроннымиДокументами КАК ПриглашенияКОбменуЭлектроннымиДокументами
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
	|		ПО ПриглашенияКОбменуЭлектроннымиДокументами.ИдентификаторОрганизации = УчетныеЗаписиЭДО.ИдентификаторЭДО";
	
	ИтоговыйЗапрос = ОбщегоНазначенияБЭД.СоединитьЗапросы(Запрос, Запросы);
	ИтоговыйЗапрос.УстановитьПараметр("ИдентификаторПолучателя", ИДПолучателя);
	ИтоговыйЗапрос.УстановитьПараметр("ИдентификаторОтправителя", ИДОтправителя);
	
	ТаблицаПриглашений = ИтоговыйЗапрос.Выполнить().Выгрузить();
	
	Присоединен = Ложь;
	СтатусПриглашения = Неопределено;
	Если ТаблицаПриглашений.Количество() > 0 Тогда
		СтатусПриглашения = ТаблицаПриглашений[0].Статус;
		Если ПриглашенияЭДО.ПриглашениеПринято(СтатусПриглашения) Тогда
			Присоединен = Истина;
		КонецЕсли;
		// Если на входе не были определены организация или контрагент (это может быть, если, например, у контрагента
		// сменился КПП), определим их из приглашения и будем использовать, пока пользователь не создаст нового контрагента
		// или не отредактирует старого.
		Если Не ЗначениеЗаполнено(Организация) Тогда
			Организация = ТаблицаПриглашений[0].Организация;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Контрагент) Тогда
			Контрагент = ТаблицаПриглашений[0].Контрагент;
		КонецЕсли;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Организация", ?(ЗначениеЗаполнено(Организация), Организация, Неопределено));
	Запрос.УстановитьПараметр("Контрагент" , ?(ЗначениеЗаполнено(Контрагент), Контрагент, Неопределено));
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НастройкиПолученияЭлектронныхДокументов.Получатель КАК Организация,
	|	НастройкиПолученияЭлектронныхДокументов.Отправитель КАК Контрагент
	|ИЗ
	|	РегистрСведений.НастройкиПолученияЭлектронныхДокументов КАК НастройкиПолученияЭлектронныхДокументов
	|ГДЕ
	|	ВЫБОР
	|		КОГДА &Организация = НЕОПРЕДЕЛЕНО
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ НастройкиПолученияЭлектронныхДокументов.Получатель = &Организация
	|	КОНЕЦ
	|	И ВЫБОР
	|		КОГДА &Контрагент = НЕОПРЕДЕЛЕНО
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ НастройкиПолученияЭлектронныхДокументов.Отправитель = &Контрагент
	|	КОНЕЦ
	|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя = &ИдентификаторОтправителя
	|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя = &ИдентификаторПолучателя
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	НастройкиПолученияЭлектронныхДокументов.Получатель,
	|	НастройкиПолученияЭлектронныхДокументов.Отправитель
	|ИЗ
	|	РегистрСведений.НастройкиПолученияЭлектронныхДокументов КАК НастройкиПолученияЭлектронныхДокументов
	|ГДЕ
	|	НастройкиПолученияЭлектронныхДокументов.Получатель = &Организация
	|	И НастройкиПолученияЭлектронныхДокументов.Отправитель = &Контрагент
	|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя = """"
	|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя = """"";
	
	Запрос.УстановитьПараметр("ИдентификаторПолучателя", ИДПолучателя);
	Запрос.УстановитьПараметр("ИдентификаторОтправителя", ИДОтправителя);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ПараметрыНастройки = Новый Структура;
		ПараметрыНастройки.Вставить("Организация",         Выборка.Организация);
		ПараметрыНастройки.Вставить("Контрагент",          Выборка.Контрагент);
	ИначеЕсли СоздаватьНастройки И Присоединен Тогда
		
		НастройкиОтправкиЭДО.СоздатьНастройкиОтправки(Организация, Контрагент, Неопределено, ИДПолучателя, ИДОтправителя);
		СоздатьНастройкиОтраженияВУчете(Организация, Контрагент, "", "");
		
		Возврат ПолучитьНастройкиПолученияПоИдентификаторам(ИДОтправителя, ИДПолучателя, Организация, Контрагент, Ложь);
		
	КонецЕсли;
	
	Возврат ПараметрыНастройки;
	
КонецФункции

// См. НастройкиЭДОСобытия.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
#Область РегистрыСведений_НастройкиПолученияЭлектронныхДокументов_ОбработатьДанныеДляПереходаНаНовуюВерсию

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыСведений.НастройкиПолученияЭлектронныхДокументов.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "1.9.3.65";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.ЗапускатьИВПодчиненномУзлеРИБСФильтрами = Истина;
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("dcef58f0-38cb-46b9-ae67-707974f74626");
	Обработчик.Многопоточный = Истина;
	Обработчик.ОчередьОтложеннойОбработки = 3;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.НастройкиПолученияЭлектронныхДокументов.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = '1С:Обмен с контрагентами: обновление настроек получения электронных документов';
									|en = '1C:Exchange with counterparties: update of electronic document receiving settings'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыСведений.НастройкиПолученияЭлектронныхДокументов.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Справочники.ВидыДокументовЭДО.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыСведений.НастройкиПолученияЭлектронныхДокументов.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.РегистрыСведений.НастройкиПолученияЭлектронныхДокументов.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();
	
	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Справочники.ВидыДокументовЭДО.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";
	
	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Справочники.СообщениеЭДОПрисоединенныеФайлы.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "Любой";

#КонецОбласти

	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// См. НастройкиЭДО.ПриЗаполненииСписковСОграничениемДоступа
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт

	Списки.Вставить(Метаданные.РегистрыСведений.НастройкиПолученияЭлектронныхДокументов, Истина);
	
КонецПроцедуры

// См. НастройкиЭДО.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных
Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт
	
	Описание = Описание + "
	|РегистрСведений.НастройкиПолученияЭлектронныхДокументов.Чтение.Организации
	|РегистрСведений.НастройкиПолученияЭлектронныхДокументов.Изменение.Организации
	|";
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекущиеНастройкиОтраженияВУчете(Организация, Контрагент, ИдентификаторОрганизации, ИдентификаторКонтрагента,
	ТаблицаНастроек)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаНастроек.Отправитель КАК Отправитель,
		|	ТаблицаНастроек.Получатель КАК Получатель,
		|	ТаблицаНастроек.ИдентификаторОтправителя КАК ИдентификаторОтправителя,
		|	ТаблицаНастроек.ИдентификаторПолучателя КАК ИдентификаторПолучателя,
		|	ТаблицаНастроек.ВидДокумента КАК ВидДокумента,
		|	ТаблицаНастроек.СпособОбработки КАК СпособОбработки
		|ПОМЕСТИТЬ ТаблицаНастроек
		|ИЗ
		|	&ТаблицаНастроек КАК ТаблицаНастроек
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаНастроек.Отправитель КАК Отправитель,
		|	ТаблицаНастроек.Получатель КАК Получатель,
		|	ТаблицаНастроек.ИдентификаторОтправителя КАК ИдентификаторОтправителя,
		|	ЕСТЬNULL(ТаблицаНастроек.ИдентификаторПолучателя, НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя) КАК ИдентификаторПолучателя,
		|	ТаблицаНастроек.ВидДокумента КАК ВидДокумента,
		|	ЕСТЬNULL(НастройкиПолученияЭлектронныхДокументов.СпособОбработки, ТаблицаНастроек.СпособОбработки) КАК СпособОбработки,
		|	НастройкиПолученияЭлектронныхДокументов.НеПредлагатьСохранятьНастройки КАК НеПредлагатьСохранятьНастройки
		|ИЗ
		|	ТаблицаНастроек КАК ТаблицаНастроек
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиПолученияЭлектронныхДокументов КАК НастройкиПолученияЭлектронныхДокументов
		|		ПО ТаблицаНастроек.Отправитель = НастройкиПолученияЭлектронныхДокументов.Получатель
		|			И ТаблицаНастроек.Получатель = НастройкиПолученияЭлектронныхДокументов.Отправитель
		|			И ТаблицаНастроек.ИдентификаторОтправителя = НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя
		|			И (ТаблицаНастроек.ИдентификаторПолучателя = НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя
		|				ИЛИ НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя = """")";
	
	Запрос.УстановитьПараметр("ИдентификаторОтправителя", ИдентификаторКонтрагента);
	Запрос.УстановитьПараметр("ИдентификаторПолучателя", ИдентификаторОрганизации);
	Запрос.УстановитьПараметр("Отправитель", Контрагент);
	Запрос.УстановитьПараметр("Получатель", Организация);
	Запрос.УстановитьПараметр("ТаблицаНастроек", ТаблицаНастроек);
	
	РезультатыЗапроса = Запрос.Выполнить();
	
	ТаблицаНастроек = РезультатыЗапроса.Выгрузить();
	
	Для Каждого СтрокаТаблицы Из ТаблицаНастроек Цикл
		СтрокаТаблицы.ИдентификаторОтправителя = ВРег(СтрокаТаблицы.ИдентификаторОтправителя);
		СтрокаТаблицы.ИдентификаторПолучателя  = ВРег(СтрокаТаблицы.ИдентификаторПолучателя);
	КонецЦикла;
	
	Возврат ТаблицаНастроек;
	
КонецФункции

Функция ТекущаяНастройкаОтраженияВУчете(КлючНастроек)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиПолученияЭлектронныхДокументов.НеПредлагатьСохранятьНастройки КАК НеПредлагатьСохранятьНастройки,
		|	НастройкиПолученияЭлектронныхДокументов.Получатель КАК Получатель,
		|	НастройкиПолученияЭлектронныхДокументов.Отправитель КАК Отправитель,
		|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя КАК ИдентификаторОтправителя,
		|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя КАК ИдентификаторПолучателя,
		|	НастройкиПолученияЭлектронныхДокументов.ВидДокумента КАК ВидДокумента,
		|	НастройкиПолученияЭлектронныхДокументов.СпособОбработки КАК СпособОбработки
		|ИЗ
		|	РегистрСведений.НастройкиПолученияЭлектронныхДокументов КАК НастройкиПолученияЭлектронныхДокументов
		|ГДЕ
		|	НастройкиПолученияЭлектронныхДокументов.Получатель = &Получатель
		|	И НастройкиПолученияЭлектронныхДокументов.Отправитель = &Отправитель
		|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя = &ИдентификаторОтправителя
		|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя = &ИдентификаторПолучателя
		|	И НастройкиПолученияЭлектронныхДокументов.ВидДокумента = &ВидДокумента
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НастройкиПолученияЭлектронныхДокументов.НеПредлагатьСохранятьНастройки,
		|	НастройкиПолученияЭлектронныхДокументов.Получатель,
		|	НастройкиПолученияЭлектронныхДокументов.Отправитель,
		|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя,
		|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя,
		|	НастройкиПолученияЭлектронныхДокументов.ВидДокумента,
		|	НастройкиПолученияЭлектронныхДокументов.СпособОбработки
		|ИЗ
		|	РегистрСведений.НастройкиПолученияЭлектронныхДокументов КАК НастройкиПолученияЭлектронныхДокументов
		|ГДЕ
		|	НастройкиПолученияЭлектронныхДокументов.Получатель = &Получатель
		|	И НастройкиПолученияЭлектронныхДокументов.Отправитель = &Отправитель
		|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя = """"
		|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя = &ИдентификаторПолучателя
		|	И НастройкиПолученияЭлектронныхДокументов.ВидДокумента = &ВидДокумента
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НастройкиПолученияЭлектронныхДокументов.НеПредлагатьСохранятьНастройки,
		|	НастройкиПолученияЭлектронныхДокументов.Получатель,
		|	НастройкиПолученияЭлектронныхДокументов.Отправитель,
		|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя,
		|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя,
		|	НастройкиПолученияЭлектронныхДокументов.ВидДокумента,
		|	НастройкиПолученияЭлектронныхДокументов.СпособОбработки
		|ИЗ
		|	РегистрСведений.НастройкиПолученияЭлектронныхДокументов КАК НастройкиПолученияЭлектронныхДокументов
		|ГДЕ
		|	НастройкиПолученияЭлектронныхДокументов.Получатель = &Получатель
		|	И НастройкиПолученияЭлектронныхДокументов.Отправитель = &Отправитель
		|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя = """"
		|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя = """"
		|	И НастройкиПолученияЭлектронныхДокументов.ВидДокумента = &ВидДокумента";
	
	Запрос.УстановитьПараметр("ВидДокумента"            , КлючНастроек.ВидДокумента);
	Запрос.УстановитьПараметр("ИдентификаторОтправителя", КлючНастроек.ИдентификаторОтправителя);
	Запрос.УстановитьПараметр("ИдентификаторПолучателя" , КлючНастроек.ИдентификаторПолучателя);
	Запрос.УстановитьПараметр("Получатель"              , КлючНастроек.Получатель);
	Запрос.УстановитьПараметр("Отправитель"             , КлючНастроек.Отправитель);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
	Если Таблица.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Таблица[0]);
	
КонецФункции

#КонецОбласти