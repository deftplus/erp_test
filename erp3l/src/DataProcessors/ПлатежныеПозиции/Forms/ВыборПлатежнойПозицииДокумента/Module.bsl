
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "ВводНаОсновании, ИмяОбъектаМетаданныхСоздаваемогоДокумента");
	Синонимы = Новый Структура;
	Синонимы.Вставить("ПриходРасход", НСтр("ru = 'Направление'"));
	Синонимы.Вставить("ЗаявкаНаОперацию", НСтр("ru = 'Заявка на операцию'"));
	УправлениеФормойУХ.УстановитьПредставлениеОтбора(ЭтотОбъект,,,,,Синонимы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВводНаОсновании Тогда
		ДополнительныеПараметры = Новый Структура("ИмяОбъектаМетаданных", ИмяОбъектаМетаданныхСоздаваемогоДокумента);
		ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ВыборПлатежнойПозицииДокумента", ПлатежныеПозицииКлиент, ДополнительныеПараметры);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВводНаОсновании Тогда
		Результат = Новый Структура("ВводНаОснованииПлатежнойПозиции, Основание", Истина, ТекДанные.ИдентификаторПозиции);
		Закрыть(Результат);
	Иначе
		Результат = Новый Структура("ДокументПланирования, ИдентификаторПозиции, СуммаПлатежа, ДоговорКонтрагента");
		Результат.ДокументПланирования			 = ТекДанные.ЗаявкаНаОперацию;
		Результат.СуммаПлатежа					 = ТекДанные.Сумма;
		Результат.ДоговорКонтрагента			 = ТекДанные.ДоговорКонтрагента;
		Результат.ИдентификаторПозиции			 = ТекДанные.ИдентификаторПозиции;
		ОповеститьОВыборе(Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
#КонецОбласти
