
#Область ПрограммныйИнтерфейс

#Область Проведение

// Формирует параметры для проведения документа по регистрам учетного механизма через общий механизм проведения.
//
// Параметры:
//  Документ - ДокументОбъект - записываемый документ
//  Свойства - См. ПроведениеДокументов.СвойстваДокумента
//
// Возвращаемое значение:
//  Структура - См. ПроведениеДокументов.ПараметрыУчетногоМеханизма
//
Функция ПараметрыДляПроведенияДокумента(Документ, Свойства) Экспорт
	
	Параметры = ПроведениеДокументов.ПараметрыУчетногоМеханизма();
	
	// Проведение
	Если Свойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыНакопления.АмортизацияОС);
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыНакопления.СтоимостьОС);
		
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыСведений.МестонахождениеОС);
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыСведений.ПараметрыАмортизацииОСУУ);
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыСведений.ПервоначальныеСведенияОС);
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыСведений.ПорядокУчетаОС);
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыСведений.ПорядокУчетаОСУУ);

		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыСведений.АрендованныеОС);
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыСведений.ГрафикНачисленияПроцентовПоАренде);
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыСведений.ГрафикНачисленияУслугПоАренде);
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыСведений.ГрафикОплатУслугПоАренде);
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыСведений.ПереданныеВАрендуОС);
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыСведений.УсловияДоговоровАренды);
		
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыСведений.УзлыКомпонентыАмортизации);
		
	КонецЕсли;
	
	// Контроль
	Если Свойства.РежимЗаписи <> РежимЗаписиДокумента.Запись Тогда
		
		Параметры.КонтрольныеРегистрыЗаданий.Добавить(Метаданные.РегистрыНакопления.АмортизацияОС);
		Параметры.КонтрольныеРегистрыЗаданий.Добавить(Метаданные.РегистрыНакопления.СтоимостьОС);
		
		Параметры.КонтрольныеРегистрыЗаданий.Добавить(Метаданные.РегистрыСведений.АрендованныеОС);
		Параметры.КонтрольныеРегистрыЗаданий.Добавить(Метаданные.РегистрыСведений.ГрафикНачисленияПроцентовПоАренде);
		Параметры.КонтрольныеРегистрыЗаданий.Добавить(Метаданные.РегистрыСведений.МестонахождениеОС);
		Параметры.КонтрольныеРегистрыЗаданий.Добавить(Метаданные.РегистрыСведений.ПараметрыАмортизацииОСУУ);
		Параметры.КонтрольныеРегистрыЗаданий.Добавить(Метаданные.РегистрыСведений.ПервоначальныеСведенияОС);
		Параметры.КонтрольныеРегистрыЗаданий.Добавить(Метаданные.РегистрыСведений.ПорядокУчетаОС);
		Параметры.КонтрольныеРегистрыЗаданий.Добавить(Метаданные.РегистрыСведений.ПорядокУчетаОСУУ);
		Параметры.КонтрольныеРегистрыЗаданий.Добавить(Метаданные.РегистрыСведений.УсловияДоговоровАренды);
		
		Параметры.КонтрольныеРегистрыЗаданий.Добавить(Метаданные.РегистрыСведений.УзлыКомпонентыАмортизации);
	КонецЕсли;
	
	Параметры.НезависимыеРегистры.Добавить(Метаданные.РегистрыСведений.ДокументыПоОС);
	
	// Контроль даты запрета
	Если Свойства.РежимЗаписи <> РежимЗаписиДокумента.Запись Тогда
		Параметры.КонтрольныеРегистрыДатаЗапрета.Добавить(Метаданные.РегистрыНакопления.АмортизацияОС);
		Параметры.КонтрольныеРегистрыДатаЗапрета.Добавить(Метаданные.РегистрыНакопления.СтоимостьОС);
	КонецЕсли;
	ОсновныеСредстваЛокализация.ДополнитьПараметрыДляПроведенияДокумента(Параметры, Документ, Свойства);
	
	Возврат Параметры;
	
КонецФункции

// Возвращает тексты запросов для сторнирования движений при исправлении документов
// 
// Параметры:
// 	МетаданныеДокумента - ОбъектМетаданныхДокумент - Метаданные документа, который проводится.
// 
// Возвращаемое значение:
// 	Соответствие - Соответствие полного имени регистра тексту запроса сторнирования
//
Функция ТекстыЗапросовСторнирования(МетаданныеДокумента) Экспорт
	
	ТекстыЗапросов = Новый Соответствие();
	
	Возврат ТекстыЗапросов;
	
КонецФункции

// Процедура формирования движений по подчиненным регистрам основных средств.
//
// Параметры:
//   ТаблицыДляДвижений - Структура - таблицы данных документа
//   Движения - КоллекцияДвижений - коллекция наборов записей движений документа
//   Отказ - Булево - признак отказа от проведения документа.
//
Процедура ОтразитьДвижения(ТаблицыДляДвижений, Движения, Отказ) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "АмортизацияОС");
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "СтоимостьОС");
	
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "МестонахождениеОС");
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "ПараметрыАмортизацииОСУУ");
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "ПервоначальныеСведенияОС");
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "ПорядокУчетаОС");
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "ПорядокУчетаОСУУ");
	
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "АрендованныеОС");
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "ПереданныеВАрендуОС");
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "УсловияДоговоровАренды");
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "ГрафикОплатУслугПоАренде");
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "ГрафикНачисленияУслугПоАренде");
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "ГрафикНачисленияПроцентовПоАренде");
	
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "УзлыКомпонентыАмортизации");

	ОсновныеСредстваЛокализация.ОтразитьДвижения(ТаблицыДляДвижений, Движения, Отказ);
	
КонецПроцедуры

// Процедура формирования движений по независимым регистрам основных средств.
//
// Параметры:
//	ТаблицыДляДвижений - Структура - таблицы данных документа
//	Документ - ДокументСсылка - ссылка на документ
//	МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - менеджер временных таблиц документа
//	Отказ - Булево - признак отказа от проведения документа.
//
Процедура ЗаписатьДанные(ТаблицыДляДвижений, Документ, МенеджерВременныхТаблиц, Отказ) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ИмяТаблицы = "Таблица" + "ДокументыПоОС";
	
	Если ТаблицыДляДвижений.Свойство(ИмяТаблицы) Тогда
		
		Набор = РегистрыСведений.ДокументыПоОС.СоздатьНаборЗаписей();
		Набор.Отбор.Ссылка.Установить(Документ);
		Набор.Загрузить(ТаблицыДляДвижений[ИмяТаблицы]);
		Набор.Записать();
		
	КонецЕсли;
	
	ОсновныеСредстваЛокализация.ЗаписатьДанные(ТаблицыДляДвижений, Документ, МенеджерВременныхТаблиц, Отказ);
	
КонецПроцедуры

// Дополняет текст запроса механизма проверки даты запрета по таблице изменений.
// 
// Параметры:
// 	Запрос - Запрос - используется для установки параметров запроса.
// 
// Возвращаемое значение:
//	Соответствие - соответствие имен таблиц изменения регистров и текстов запросов.
//	
Функция ТекстыЗапросовКонтрольДатыЗапретаПоТаблицеИзменений(Запрос) Экспорт

	СоответствиеТекстовЗапросов = Новый Соответствие();
	СоответствиеТекстовЗапросов.Вставить("АмортизацияОСИзменение", РегистрыНакопления.АмортизацияОС.ТекстЗапросаКонтрольДатыЗапрета(Запрос));
	СоответствиеТекстовЗапросов.Вставить("СтоимостьОСИзменение", РегистрыНакопления.СтоимостьОС.ТекстЗапросаКонтрольДатыЗапрета(Запрос));
	
	Возврат СоответствиеТекстовЗапросов;
	
КонецФункции

#КонецОбласти

#КонецОбласти
