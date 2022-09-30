// Управляет доступностью элементов на форме.
&НаСервере
Процедура УправлениеДоступностью()
	// Видимость надписи Отсутствует в конфигурации.
	Элементы.ОтсутствуетВКонфигурацииНадпись.Видимость = Объект.ОтсутствуетВКонфигурации;
КонецПроцедуры		// УправлениеДоступностью()

&НаСервере
Процедура ОбновитьПоДаннымВИБСервер()
	
	ТекОбъект=РеквизитФормыВЗначение("Объект");
	ТекОбъект.ЗаполнитьРеквизитыОбъекта();
    ЗначениеВРеквизитФормы(ТекОбъект,"Объект");
	
	Модифицированность=Истина;
		
КонецПроцедуры // ОбновитьПоДанныммВИБ() 

&НаКлиенте
Процедура ОбновитьПоДаннымВИБ(Команда)
	
	ОбновитьПоДаннымВИБСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмеренияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя="ИзмеренияТипДанных" Тогда
		
		ДанныеОбъекта=Новый Структура;
		ДанныеОбъекта.Вставить("ИмяОбъекта",СтрШаблон(Нстр("ru = 'регистр сведений %1'"), Объект.Синоним));
		ДанныеОбъекта.Вставить("ТекстПоля",СтрШаблон(Нстр("ru = ' измерение %1'"), Элементы.Измерения.ТекущиеДанные.Имя));
		ДанныеОбъекта.Вставить("ТипДанных",Элементы.Измерения.ТекущиеДанные.ТипДанных);	
		
		ОткрытьФорму("ОбщаяФорма.ФормаПросмотраТипаЗначений",ДанныеОбъекта);		
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя="РеквизитыТипДанных" Тогда
		
		ДанныеОбъекта=Новый Структура;
		ДанныеОбъекта.Вставить("ИмяОбъекта",СтрШаблон(Нстр("ru = 'регистр сведений %1'"), Объект.Синоним));
		ДанныеОбъекта.Вставить("ТекстПоля",СтрШаблон(Нстр("ru = ' реквизит %1'"), Элементы.Реквизиты.ТекущиеДанные.Имя));
		ДанныеОбъекта.Вставить("ТипДанных",Элементы.Реквизиты.ТекущиеДанные.ТипДанных);	
		
		ОткрытьФорму("ОбщаяФорма.ФормаПросмотраТипаЗначений",ДанныеОбъекта);		
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РесурсыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя="РесурсыТипДанных" Тогда
		
		ДанныеОбъекта=Новый Структура;
		ДанныеОбъекта.Вставить("ИмяОбъекта",СтрШаблон(Нстр("ru = 'регистр сведений %1'"), Объект.Синоним));
		ДанныеОбъекта.Вставить("ТекстПоля",СтрШаблон(Нстр("ru = ' ресурс %1'"), Элементы.Ресурсы.ТекущиеДанные.Имя));
		ДанныеОбъекта.Вставить("ТипДанных",Элементы.Ресурсы.ТекущиеДанные.ТипДанных);	
		
		ОткрытьФорму("ОбщаяФорма.ФормаПросмотраТипаЗначений",ДанныеОбъекта);		
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура РегистраторыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;
	
	ДанныеОбъекта=Новый Структура;	
	ДанныеОбъекта.Вставить("ИмяОбъекта",СтрШаблон(Нстр("ru = 'регистр сведений %1'"), Объект.Синоним));
	ДанныеОбъекта.Вставить("ТекстПоля",Нстр("ru = ' регистраторы'"));
	ДанныеОбъекта.Вставить("ТипДанных",Объект.Регистраторы);	
	
	ОткрытьФорму("ОбщаяФорма.ФормаПросмотраТипаЗначений",ДанныеОбъекта);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УправлениеДоступностью();
КонецПроцедуры
