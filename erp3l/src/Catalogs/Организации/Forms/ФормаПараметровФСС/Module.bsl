
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ВидОрганизации 							= Параметры.ВидОрганизации;
	КодПодчиненностиФСС						= Параметры.КодПодчиненностиФСС;
	НаименованиеТерриториальногоОрганаФСС 	= Параметры.НаименованиеТерриториальногоОрганаФСС;
	РегистрационныйНомерФСС 				= Параметры.РегистрационныйНомерФСС;
	ИПКодПодчиненностиФСС 					= Параметры.ИПКодПодчиненностиФСС;
	ИПРегистрационныйНомерФСС 				= Параметры.ИПРегистрационныйНомерФСС;
	
	Если ВидОрганизации = "ИндивидуальныйПредприниматель" Тогда
		Элементы.ГруппаОтступФССИП.Видимость = Истина;
		Элементы.ГруппаОтступРеквизитыФСС.ОтображатьЗаголовок = Истина;
		Элементы.ГруппаОтступРеквизитыФСС.Заголовок = НСтр("ru = 'Отчетность за сотрудников:';
															|en = 'Reporting for employees:'");
	Иначе 
		Элементы.ГруппаОтступФССИП.Видимость = Ложь;
	КонецЕсли;
	
	УстановитьДоступностьЭлементовФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы,, ТекстПредупреждения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда) 
	
	СохранитьИЗакрыть();	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовФормы(Форма)
	
	Если Форма.ВидОрганизации = "ОбособленноеПодразделение" Тогда
		Форма.ДополнительныйКодФСС = Форма.Параметры.ДополнительныйКодФСС;
	Иначе
		Форма.Элементы.ДополнительныйКодФСС.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть() Экспорт
	
	Модифицированность = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("НаименованиеТерриториальногоОрганаФСС", НаименованиеТерриториальногоОрганаФСС);	
	СтруктураПараметров.Вставить("РегистрационныйНомерФСС", РегистрационныйНомерФСС);
	СтруктураПараметров.Вставить("КодПодчиненностиФСС", КодПодчиненностиФСС);
	СтруктураПараметров.Вставить("ИПКодПодчиненностиФСС", ИПКодПодчиненностиФСС);
	СтруктураПараметров.Вставить("ИПРегистрационныйНомерФСС", ИПРегистрационныйНомерФСС);
	
	Если ВидОрганизации = "ОбособленноеПодразделение" Тогда
		СтруктураПараметров.Вставить("ДополнительныйКодФСС", ДополнительныйКодФСС);		
	КонецЕсли;
	
	Закрыть(СтруктураПараметров);
	
КонецПроцедуры

#КонецОбласти
