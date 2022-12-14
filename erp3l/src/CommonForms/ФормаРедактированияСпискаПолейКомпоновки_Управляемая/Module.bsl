
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("КомпоновщикНастроек", КомпоновщикНастроек);
	
	ТаблицаПолей.Очистить();
	Для Каждого Элемент Из параметры.СписокПолей Цикл
		
		ТаблицаПолей.Добавить().Поле = Элемент.Значение;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СписокПолей = Новый СписокЗначений;
	Для Каждого Элемент Из ТаблицаПолей Цикл
		СписокПолей.Добавить(Элемент.Поле);
	КонецЦикла;
	
	ОповеститьОВыборе(СписокПолей);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборПоля_Завершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	Если ВыбранноеЗначение <> Неопределено Тогда
		ТекСтрока = ТаблицаПолей.НайтиПоИдентификатору(Элементы.ТаблицаПолей.ТекущаяСтрока);
		ТекСтрока.Поле = ВыбранноеЗначение;
	Иначе
		// Значение не выбрано. Не добавляем.
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПолейПолеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Режим" , "Все");
	СтруктураПараметров.Вставить("КомпоновщикНастроек", КомпоновщикНастроек);
	ОписаниеОЗакрытии = Новый ОписаниеОповещения("ВыборПоля_Завершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДоступногоПоляКомпоновщикаНастроек_Управляемая", СтруктураПараметров, , , , , ОписаниеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры
