
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	КоличествоЛет = 1;
	ДатаОкончания = НачалоДня(ТекущаяДатаСеанса())-1;
	ДатаНачала = ДатаОкончания - 86400 * 365 * КоличествоЛет;
	
	ВариантЗаполнения      = Параметры.ВариантЗаполнения;
	ПорядокДолейРаспределения = Параметры.ПорядокДолейРаспределения;
	
	Если ПорядокДолейРаспределения = 0 Тогда
		ПорядокДолейРаспределения = 3;
	КонецЕсли; 
	
	Если ВариантЗаполнения = 1 Тогда
	
		СхемаКомпоновкиДанных = Документы.НормативРаспределенияПлановПродажПоКатегориям.ПолучитьМакет("ЗаполнениеПоСтатистикеПродажСвойствоНоменклатуры");
	
	ИначеЕсли ВариантЗаполнения = 2 Тогда
	
		СхемаКомпоновкиДанных = Документы.НормативРаспределенияПлановПродажПоКатегориям.ПолучитьМакет("ЗаполнениеПоСтатистикеПродажСвойствоХарактеристики");
	
	Иначе
	
		СхемаКомпоновкиДанных = Документы.НормативРаспределенияПлановПродажПоКатегориям.ПолучитьМакет("ЗаполнениеПоСтатистикеПродажРеквизитНоменклатуры");
		ПодстрокаПоиска = "СпрНоменклатура.СезоннаяГруппа";
		ПодстрокаЗамены = "СпрНоменклатура."+Параметры.Реквизит;
		СхемаКомпоновкиДанных.НаборыДанных[0].Запрос = СтрЗаменить(СхемаКомпоновкиДанных.НаборыДанных[0].Запрос, ПодстрокаПоиска, ПодстрокаЗамены);
	
	КонецЕсли; 
	
	
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных); 
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, СтандартнаяОбработка, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	АдресПользовательскихНастроек = ПоместитьВоВременноеХранилище(КомпоновщикНастроек.ПользовательскиеНастройки, УникальныйИдентификатор);
	
	Настройки = Новый Структура;
	Настройки.Вставить("ДатаНачала",                    ДатаНачала);
	Настройки.Вставить("ДатаОкончания",                 ДатаОкончания);
	Настройки.Вставить("ВариантЗаполнения",             ВариантЗаполнения);
	Настройки.Вставить("ПорядокДолейРаспределения",     ПорядокДолейРаспределения);
	Настройки.Вставить("АдресПользовательскихНастроек", АдресПользовательскихНастроек);
	
	Закрыть(Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	ОбщегоНазначенияУТКлиент.РедактироватьПериод(
		ЭтаФорма, 
		Новый Структура("ДатаНачала, ДатаОкончания", "ДатаНачала", "ДатаОкончания"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтбор(Команда)
	
	ПараметрыФормы = Новый Структура("КомпоновщикНастроек", КомпоновщикНастроек);
	ОткрытьФорму("Документ.НормативРаспределенияПлановПродажПоКатегориям.Форма.ФормаОтбора", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
