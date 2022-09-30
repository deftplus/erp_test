
&НаСервере
Процедура ОбновитьРеквизитыПоМетаданным()
	
	СправочникОбъект=РеквизитФормыВЗначение("Объект");
	СправочникОбъект.ЗаполнитьРеквизитыОбъекта();
	ЗначениеВРеквизитФормы(СправочникОбъект,"Объект");
		
КонецПроцедуры // ОбновитьРеквизитыПоМетаданным() 

&НаКлиенте
Процедура ОбновитьРеквизиты(Команда)
	
	ОбновитьРеквизитыПоМетаданным();
		
КонецПроцедуры

&НаКлиенте
Процедура ТипЗначенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;
	
	ДанныеОбъекта=Новый Структура;	
	ДанныеОбъекта.Вставить("ИмяОбъекта",СтрШаблон(Нстр("ru = 'план видов характеристик %1'"), Объект.Синоним));
	ДанныеОбъекта.Вставить("ТекстПоля",Нстр("ru = ' тип значения'"));
	ДанныеОбъекта.Вставить("ТипДанных",Объект.ТипЗначения);	
	
	ОткрытьФорму("ОбщаяФорма.ФормаПросмотраТипаЗначений",ДанныеОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя="РеквизитыТипДанных" Тогда
		
		ДанныеОбъекта=Новый Структура;
		ДанныеОбъекта.Вставить("ИмяОбъекта",СтрШаблон(Нстр("ru = 'план видов характеристик %1'"), Объект.Синоним));
		ДанныеОбъекта.Вставить("ТекстПоля",СтрШаблон(Нстр("ru = ' реквизит %1'"), Элементы.Реквизиты.ТекущиеДанные.Имя));
		ДанныеОбъекта.Вставить("ТипДанных",Элементы.Реквизиты.ТекущиеДанные.ТипДанных);	
		
		ОткрытьФорму("ОбщаяФорма.ФормаПросмотраТипаЗначений",ДанныеОбъекта);		
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиСоответствия(Команда)
	
	ФормаНастройкиСоответствий = "ОбщаяФорма" + "." + "ФормаПроверкиНастройкиСоответствий";
	
	ОткрытьФорму(ФормаНастройкиСоответствий,Новый Структура("ТипБД,ТипДанных",Объект.Владелец,Объект.ТипЗначения));
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.НастройкиСоответствия.Видимость=(НЕ Объект.Владелец=Справочники.ТипыБазДанных.ТекущаяИБ);
	
	Если НЕ Элементы.НастройкиСоответствия.Видимость Тогда
		
		Элементы.СоздаватьПриНеудачномПоискеПриИмпорте.Заголовок=Нстр("ru = 'Создавать при неудачном поиске при импорте'");
		Элементы.ОбновлятьРеквизитыПриИмпорте.Заголовок=Нстр("ru = 'Обновлять реквизиты при импорте'");
		
	Иначе
		
		Элементы.СоздаватьПриНеудачномПоискеПриИмпорте.Заголовок=Нстр("ru = 'Создавать при неудачном поиске при экспорте'");
		Элементы.ОбновлятьРеквизитыПриИмпорте.Заголовок=Нстр("ru = 'Обновлять реквизиты при экспорте'");
		
	КонецЕсли;
	
	// Видимость надписи Отсутствует в конфигурации.
	Элементы.ОтсутствуетВКонфигурацииНадпись.Видимость = Объект.ОтсутствуетВКонфигурации;
КонецПроцедуры


