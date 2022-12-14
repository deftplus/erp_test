#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов,
		КоллекцияПечатныхФорм,
		ОбъектыПечати,
		ПараметрыВывода);
	
КонецПроцедуры
	
// Возвращает ссылку на документ Запрос на проведение закупки по документу
// Строка плана закупок. Когда получить ссылку однозначно невозможно - 
// возвращает пустую ссылку.
Функция ПолучитьПоСтрокеПланаЗакупок(СтрокаПланаВход) Экспорт
	РезультатФункции = Документы.ОбоснованиеТребованийКЗакупочнойПроцедуре.ПустаяСсылка();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ОбоснованиеТребованийКЗакупочнойПроцедуре.Ссылка КАК Ссылка,
		|	ОбоснованиеТребованийКЗакупочнойПроцедуре.ДокументОснование КАК ДокументОснование
		|ИЗ
		|	Документ.ОбоснованиеТребованийКЗакупочнойПроцедуре КАК ОбоснованиеТребованийКЗакупочнойПроцедуре
		|ГДЕ
		|	НЕ ОбоснованиеТребованийКЗакупочнойПроцедуре.ПометкаУдаления
		|	И ОбоснованиеТребованийКЗакупочнойПроцедуре.ДокументОснование = &ДокументОснование";
	Запрос.УстановитьПараметр("ДокументОснование", СтрокаПланаВход);
	РезультатЗапроса = Запрос.Выполнить();
	Выгрузка = РезультатЗапроса.Выгрузить();
	Если Выгрузка.Количество() = 1 Тогда
		ПерваяСтрока = Выгрузка[0];
		РезультатФункции = ПерваяСтрока.Ссылка;
	Иначе
		РезультатФункции = Документы.ОбоснованиеТребованийКЗакупочнойПроцедуре.ПустаяСсылка();
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции		// ПолучитьЗапросНаПроведениеЗакупкиПоСтрокеПлана()

// Возвращает документ ЗапросНаПроведениеЗакупки по данным лота ЛотВход.
// Когда однозначно такой документ получить нельзя - возвращает пустую
// ссылку.
Функция ПолучитьЗапросНаПроведениеЗакупкиПоЛоту(ЛотВход) Экспорт
	РезультатФункции = Документы.ОбоснованиеТребованийКЗакупочнойПроцедуре.ПустаяСсылка();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	Лоты.Ссылка КАК Лот,
		|	Лоты.СтрокаПланаЗакупок КАК СтрокаПланаЗакупок,
		|	ОбоснованиеТребованийКЗакупочнойПроцедуре.Ссылка КАК ОбоснованиеТребованийКЗакупочнойПроцедуре
		|ИЗ
		|	Справочник.Лоты КАК Лоты,
		|	Документ.ОбоснованиеТребованийКЗакупочнойПроцедуре КАК ОбоснованиеТребованийКЗакупочнойПроцедуре
		|ГДЕ
		|	НЕ Лоты.ПометкаУдаления
		|	И Лоты.Ссылка = &Ссылка
		|	И НЕ ОбоснованиеТребованийКЗакупочнойПроцедуре.ПометкаУдаления";
	Запрос.УстановитьПараметр("Ссылка", ЛотВход);
	РезультатЗапроса = Запрос.Выполнить();
	Выгрузка = РезультатЗапроса.Выгрузить();
	Если Выгрузка.Количество() = 1 Тогда
		ПерваяСтрока = Выгрузка[0];
		РезультатФункции = ПерваяСтрока.ОбоснованиеТребованийКЗакупочнойПроцедуре;	
	Иначе
		РезультатФункции = Документы.ОбоснованиеТребованийКЗакупочнойПроцедуре.ПустаяСсылка();
	КонецЕсли;
	Возврат РезультатФункции;	
КонецФункции		// ПолучитьЗапросНаПроведениеЗакупкиПоЛоту()

#КонецЕсли
