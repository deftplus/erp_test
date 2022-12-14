#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	

// Получить массив ПредложенийПоставщиков указанному лоту.
//
// Параметры:
//  Лот - СправочникСсылка.Лоты - лот для отбора предложений.
// 
// Возвращаемое значение:
//	Массив(ДокументСсылка.ПредложениеПоставщика).
//	Если предлжений не найдено, то возвращает пустой массив.
//
Функция ПолучитьПроведенныеПоЛоту(Лот) Экспорт
	Если НЕ ЗначениеЗаполнено(Лот) Тогда
		Возврат Новый Массив;
	КонецЕсли;
	Отбор = Новый Структура;
	Отбор.Вставить("Лот", Лот);
	Отбор.Вставить("Проведен", Истина);
	Возврат ЦентрализованныеЗакупкиУХ.ПолучитьДокументыПоОтбору(
		"ПредложениеПоставщика",
		Отбор);
КонецФункции
	
// Получить массив ПредложенийПоставщиков допущенные к
// участию в торгах по указанному лоту.
//
// Параметры:
//  Лот - СправочникСсылка.Лоты - лот для отбора предложений.
//  НомерПереторжкиВход - Число - номер переторжки для отбора предложений.
// 
// Возвращаемое значение:
//	Массив(ДокументСсылка.ПредложениеПоставщика).
//	Если предлжений не найдено, то возвращает пустой массив.
//
Функция ПолучитьДопущенныеКУчастиюПоЛоту(Лот, НомерПереторжкиВход = Неопределено) Экспорт
	РезультатФункции = Новый Массив;
	Если ЗначениеЗаполнено(Лот) Тогда
		Отбор = Новый Структура;
		Отбор.Вставить("Лот", Лот);
		Отбор.Вставить("ДопущенКУчастию", Истина);
		Отбор.Вставить("Проведен", Истина);
		Если НомерПереторжкиВход <> Неопределено Тогда
			Отбор.Вставить("НомерПереторжки", НомерПереторжкиВход);
		Иначе
			// Не добавляем отбор по номеру переторжки.
		КонецЕсли;
		РезультатФункции = ЦентрализованныеЗакупкиУХ.ПолучитьДокументыПоОтбору("ПредложениеПоставщика", Отбор);
	Иначе
		РезультатФункции = Новый Массив;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции		// ПолучитьДопущенныеКУчастиюПоЛоту()

// Получить массив ПредложенийПоставщиков допущенные к
// участию в закупочной процедуре .
//
// Параметры:
//  Закупка - СправочникСсылка.ЗакупочныеПроцедуры - закупка для отбора предложений.
// 
// Возвращаемое значение:
//	Массив(ДокументСсылка.ПредложениеПоставщика).
//	Если предлжений не найдено, то возвращает пустой массив.
//
Функция ПолучитьДопущенныеКУчастиюВЗакупке(Закупка) Экспорт
	Если НЕ ЗначениеЗаполнено(Закупка) Тогда
		Возврат Новый Массив;
	КонецЕсли;
	Отбор = Новый Соответствие;
	Отбор.Вставить("Лот.Владелец", Закупка);
	Отбор.Вставить("ДопущенКУчастию", Истина);
	Отбор.Вставить("Проведен", Истина);
	Возврат ЦентрализованныеЗакупкиУХ.ПолучитьДокументыПоОтбору(
		"ПредложениеПоставщика",
		Отбор);
КонецФункции

// Возвращает массив ссылок предложений поставщика для закупочной
// процедуры.
//
Функция ПолучитьПоЗакупочнойПроцедуре(ЗакупочнаяПроцедура, Проведен=Неопределено) Экспорт
	Если НЕ ЗначениеЗаполнено(ЗакупочнаяПроцедура) Тогда
		Возврат Новый Массив;
	КонецЕсли;
	Отбор = Новый Соответствие;
	Отбор.Вставить("Лот.Владелец", ЗакупочнаяПроцедура);
	Отбор.Вставить("ПометкаУдаления", Ложь);
	Если Проведен <> Неопределено Тогда
		Отбор.Вставить("Проведен", Проведен);
	КонецЕсли;
	Возврат ЦентрализованныеЗакупкиУХ.ПолучитьДокументыПоОтбору(
		"ПредложениеПоставщика", Отбор);
КонецФункции

// Получить массив ПредложенийПоставщиков проведённых и привязанных к закупочной процедуре.
//
// Параметры:
//  Закупка - СправочникСсылка.ЗакупочныеПроцедуры - закупка для отбора предложений.
// 
// Возвращаемое значение:
//	Массив(ДокументСсылка.ПредложениеПоставщика).
//	Если предлжений не найдено, то возвращает пустой массив.
//
Функция ПолучитьПроведенныеПоЗакупке(Закупка) Экспорт
	Если НЕ ЗначениеЗаполнено(Закупка) Тогда
		Возврат Новый Массив;
	КонецЕсли;
	Отбор = Новый Соответствие;
	Отбор.Вставить("Лот.Владелец", Закупка);
	Отбор.Вставить("Проведен", Истина);
	Возврат ЦентрализованныеЗакупкиУХ.ПолучитьДокументыПоОтбору("ПредложениеПоставщика", Отбор);
КонецФункции

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
		
	Ограничение.ТекстДляВнешнихПользователей =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК ЭтотСписок
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВнешниеПользователи КАК СпрВнешПользователи 
	|    ПО СпрВнешПользователи.ОбъектАвторизации = ЭтотСписок.АнкетаПоставщика 
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|    ЗначениеРазрешено(СпрВнешПользователи.Ссылка)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецЕсли