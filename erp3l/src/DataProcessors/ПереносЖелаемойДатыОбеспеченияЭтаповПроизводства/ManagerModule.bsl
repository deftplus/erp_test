#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Изменяет желаемую дату обеспечения этапов, приводя ее к дате начала этапов по графику производства.
//
// Параметры:
//  Распоряжение - ДокументСсылка.ЗаказНаПроизводство2_2 - заказ, этапы которого необходимо откорректировать.
//  АдресХранилища - Строка - адрес хранилища, в которое будет помещен результат.
//
Процедура ПеренестиЖелаемыеДатыОбеспечения(Распоряжение, АдресХранилища) Экспорт
	
	СхемаКомпоновкиДанных = Обработки.ПереносЖелаемойДатыОбеспеченияЭтаповПроизводства.ПолучитьМакет("Макет");
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	ПроцессорКомпоновки = ИнициализироватьПроцессорКомпоновки(
		СхемаКомпоновкиДанных,
		"ОбработкаДанных",
		ДанныеРасшифровки,
		Распоряжение);
	
	Этапы = Новый ТаблицаЗначений; // см. ПроизводствоСервер.СлужебнаяСтруктураТаблицыЗначений
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(Этапы);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Если Этапы.Количество() > 0 Тогда
		Этапы.Колонки.НачалоЭтапа.Имя = "Дата";
		КоличествоОбработанных = Документы.ЭтапПроизводства2_2.ИзменитьЖелаемыеДатыОбеспечения(Этапы);
	Иначе
		КоличествоОбработанных = 0;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("КоличествоОбработанных", КоличествоОбработанных);
	Результат.Вставить("КоличествоВсего", Этапы.Количество());
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПрочитатьИВывестиЭтапыРаспоряжения(Параметры, АдресХранилища)Экспорт
	
	СхемаКомпоновкиДанных = Обработки.ПереносЖелаемойДатыОбеспеченияЭтаповПроизводства.ПолучитьМакет("Макет");
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	ПроцессорКомпоновки = ИнициализироватьПроцессорКомпоновки(
		СхемаКомпоновкиДанных,
		"ВыводДанных",
		ДанныеРасшифровки,
		Параметры.Распоряжение);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;		
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабличныйДокумент);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	
	Результат = Новый Структура;
	Результат.Вставить("ТабличныйДокумент", ТабличныйДокумент);
	Результат.Вставить("СхемаКомпоновкиДанных", СхемаКомпоновкиДанных);
	Результат.Вставить("ДанныеРасшифровки", ДанныеРасшифровки);
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
	
КонецПроцедуры

Функция ИнициализироватьПроцессорКомпоновки(СхемаКомпоновкиДанных, КлючВарианта, ДанныеРасшифровки, Распоряжение)
	
	ПараметрРаспоряжение = СхемаКомпоновкиДанных.Параметры.Найти("Распоряжение");
	ПараметрРаспоряжение.Значение = Распоряжение;
	
	ПараметрСтатус = СхемаКомпоновкиДанных.Параметры.Найти("СтатусРабочийГрафик");
	ПараметрСтатус.Значение = РегистрыСведений.ГрафикЭтаповПроизводства2_2.СтатусРабочийГрафик();
	
	НастройкиКомпоновкиДанных = СхемаКомпоновкиДанных.ВариантыНастроек.Найти(КлючВарианта).Настройки;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	Если КлючВарианта = "ОбработкаДанных" Тогда
		ТипГенератора = Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений");
	Иначе
		ТипГенератора = Тип("ГенераторМакетаКомпоновкиДанных");
	КонецЕсли;
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
		СхемаКомпоновкиДанных, 
		НастройкиКомпоновкиДанных,
		ДанныеРасшифровки,
		,
		ТипГенератора);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,, ДанныеРасшифровки);
	
	Возврат ПроцессорКомпоновки;
	
КонецФункции

#КонецОбласти

#КонецЕсли
