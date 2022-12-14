
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Задача = Параметры.ПараметрКоманды;
	СформироватьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	Перем ВыполненноеДействие, ПараметрВыполненногоДействия;
	
	СтандартнаяОбработка = Ложь;
	
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(
		АдресРасшифровки, Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	
	ДоступныеДействия = Новый Массив;
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение);
	
	ДопПараметры = Новый Структура("ПараметрВыполненногоДействия", ПараметрВыполненногоДействия);
	ОписаниеОповещения = Новый ОписаниеОповещения("РезультатОбработкаРасшифровкиЗавершение",
	                                              ЭтотОбъект,
	                                              ДопПараметры);
	ОбработкаРасшифровки.ПоказатьВыборДействия(ОписаниеОповещения, Расшифровка, ДоступныеДействия,, Истина,);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровкиЗавершение(ВыполненноеДействие, ПараметрВыполненногоДействия, ДополнительныеПараметры) Экспорт
		
	ПоказатьЗначение(, ПараметрВыполненногоДействия);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	СформироватьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьНаСервере()
	
	Результат.Очистить();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Компановка = Отчеты.ВыполнениеЗадачБюджетногоПроцесса.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	Вариант = Компановка.ВариантыНастроек.Найти("СвязанныеЗадачи");
	
	КомпановщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпановщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Компановка));
	КомпановщикНастроек.ЗагрузитьНастройки(Вариант.Настройки);
	
	Отбор = КомпановщикНастроек.Настройки.Отбор;
	НовыйОтбор = Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Задача");
	НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
	НовыйОтбор.Использование = Истина;
	НовыйОтбор.ПравоеЗначение = Задача;
	
	ЭлементОтбора = КомпановщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ОтображатьТолькоПодчиненныеЗадачи");
	ЭлементОтбора.Значение = Истина;
	ЭлементОтбора.Использование = Истина;
	
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	НастройкиКомпоновкиДанных = КомпановщикНастроек.ПолучитьНастройки();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет = КомпоновщикМакета.Выполнить(Компановка, НастройкиКомпоновкиДанных, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет, , ДанныеРасшифровки);
	ПроцессорКомпоновки.Сбросить();
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	АдресРасшифровки = ПоместитьВоВременноеХранилище(ДанныеРасшифровки, ЭтаФорма.УникальныйИдентификатор);
	АдресСхемы = ПоместитьВоВременноеХранилище(Компановка, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти
