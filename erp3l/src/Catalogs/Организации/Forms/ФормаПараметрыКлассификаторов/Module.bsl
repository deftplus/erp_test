#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	КодОКВЭД		   = Параметры.КодОКВЭД;
	КодОКВЭД2		   = Параметры.КодОКВЭД2;
	КодОКОНХ		   = Параметры.КодОКОНХ;
	КодОКОПФ		   = Параметры.КодОКОПФ;
	КодОКФС 		   = Параметры.КодОКФС;
	НаименованиеОКВЭД  = Параметры.НаименованиеОКВЭД;
	НаименованиеОКВЭД2 = Параметры.НаименованиеОКВЭД2;
	НаименованиеОКОПФ  = Параметры.НаименованиеОКОПФ;
	НаименованиеОКФС   = Параметры.НаименованиеОКФС;
	
	ДатаСеанса = ТекущаяДатаСеанса();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы,, ТекстПредупреждения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПолейФормы

&НаКлиенте
Процедура КодОКОПФНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КомментарийВыбора = НСтр("ru = 'Внимание! С 2015 г.введен в действие новый классификатор ОКОПФ
	                             |(приказ Росстандарта 12.12.2014 № 2011-ст).';
	                             |en = 'Warning! A new RNCFI is enacted since 2015
	                             | (the order of Federal Agency on Technical Regulating and Metrology dated 12/12/2014 No.2011-st) '");
	
	ВыбратьКодИзКлассификатора("ОКОПФ", КомментарийВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура КодОКОПФПриИзменении(Элемент)
		
	НаименованиеОКОПФ = НаименованиеКодаКлассификатора("ОКОПФ", КодОКОПФ);
	
КонецПроцедуры

&НаКлиенте
Процедура КодОКВЭДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбратьКодИзКлассификатора("ОКВЭД");
	
КонецПроцедуры

&НаКлиенте
Процедура КодОКВЭДПриИзменении(Элемент)
	
	// Исправление возможной опечатки в разделителе
	КодОКВЭД = СтрЗаменить(КодОКВЭД, ",", ".");
	
	НаименованиеОКВЭД = НаименованиеКодаКлассификатора("ОКВЭД", КодОКВЭД);
	
КонецПроцедуры

&НаКлиенте
Процедура КодОКВЭД2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбратьКодИзКлассификатора("ОКВЭД2");
	
КонецПроцедуры

&НаКлиенте
Процедура КодОКВЭД2ПриИзменении(Элемент)
	
	// Исправление возможной опечатки в разделителе
	КодОКВЭД2 = СтрЗаменить(КодОКВЭД2, ",", ".");
	
	НаименованиеОКВЭД2 = НаименованиеКодаКлассификатора("ОКВЭД2", КодОКВЭД2);
	
КонецПроцедуры

&НаКлиенте
Процедура КодОКФСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ВыбратьКодИзКлассификатора("ОКФС");
	
КонецПроцедуры

&НаКлиенте
Процедура КодОКФСПриИзменении(Элемент)
	
	НаименованиеОКФС = НаименованиеКодаКлассификатора("ОКФС", КодОКФС);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда) 
	
	СохранитьИЗакрыть();	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьИЗакрыть() Экспорт
	
	Модифицированность = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("КодОКВЭД", КодОКВЭД);
	СтруктураПараметров.Вставить("КодОКВЭД2", КодОКВЭД2);
	СтруктураПараметров.Вставить("КодОКОНХ", КодОКОНХ);
	СтруктураПараметров.Вставить("КодОКОПФ", КодОКОПФ);
	СтруктураПараметров.Вставить("КодОКФС", КодОКФС);
	СтруктураПараметров.Вставить("НаименованиеОКВЭД", НаименованиеОКВЭД);	
	СтруктураПараметров.Вставить("НаименованиеОКВЭД2", НаименованиеОКВЭД2);
	СтруктураПараметров.Вставить("НаименованиеОКОПФ", НаименованиеОКОПФ);
	СтруктураПараметров.Вставить("НаименованиеОКФС", НаименованиеОКФС);
	
	Закрыть(СтруктураПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКодИзКлассификатора(ИмяКлассификатора, Комментарий = "", Знач ИмяРеквизитаКод = "")
 
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъекта",      "Справочник");
	ПараметрыФормы.Вставить("НазваниеОбъекта", "Организации");
	ПараметрыФормы.Вставить("НазваниеМакета",  ИмяКлассификатора);
	ПараметрыФормы.Вставить("ТекущийПериод",   ДатаСеанса);
	ИмяРеквизитаКод = ?(НЕ ЗначениеЗаполнено(ИмяРеквизитаКод), "Код" + ИмяКлассификатора, ИмяРеквизитаКод);
	ПараметрыФормы.Вставить("ТекущийКод",      ЭтаФорма[ИмяРеквизитаКод]);
	ПараметрыФормы.Вставить("Комментарий",     Комментарий);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяКлассификатора", ИмяКлассификатора);
	ДополнительныеПараметры.Вставить("ИмяРеквизитаКод",   ИмяРеквизитаКод);
	ДополнительныеПараметры.Вставить("ИмяРеквизитаНаименование", "Наименование" + Сред(ИмяРеквизитаКод, 4));
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыбратьКодИзКлассификатораЗавершение", 
		ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораКода", ПараметрыФормы,,,,, ОповещениеОЗакрытии);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКодИзКлассификатораЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтаФорма[ДопПараметры.ИмяРеквизитаКод] = РезультатВыбора.Код;
	ЭтаФорма[ДопПараметры.ИмяРеквизитаНаименование] = РезультатВыбора.Наименование;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НаименованиеКодаКлассификатора(ИмяКлассификатора, Знач Код)

	СоответствиеКодаНаименованию = ОрганизацииЛокализация.СоответствиеКодовКНаименованиюИзМакета(ИмяКлассификатора);
	
	Возврат СоответствиеКодаНаименованию.Получить(Код);

КонецФункции

#КонецОбласти
