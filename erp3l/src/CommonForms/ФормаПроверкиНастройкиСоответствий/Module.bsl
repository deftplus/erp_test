
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ПланВидовХарактеристикБД) Тогда
		
		ТипБД=Параметры.ПланВидовХарактеристикБД.Владелец;
		ТипДанных=Параметры.ПланВидовХарактеристикБД.ТипЗначения;
		
	Иначе
		
		ТипБД=Параметры.ТипБД;
		ТипДанных=Параметры.ТипДанных;
			
	КонецЕсли;
	
	ОбновитьТаблицуСоответствия();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуСоответствия()
	
	ТаблицаНастроек=ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьТаблицуСоответствий(ТипБД,ТипДанных);
	
	Для Каждого Строка ИЗ ТаблицаНастроек Цикл
		
		НоваяСтрока=ТабНастройкаСоответствий.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка);
		
	КонецЦикла;

КонецПроцедуры // ОбновитьТаблицуСоответствия() 

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповестить("ЗакрытаФормаПроверкиНастроекСоответствия");
	
КонецПроцедуры

&НаКлиенте
Процедура ТабНастройкаСоответствийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя="ТабНастройкаСоответствийНастройкаСоответствия" Тогда
		
		СтандартнаяОбработка=Ложь;
		
		Если ЗначениеЗаполнено(Элементы.ТабНастройкаСоответствий.ТекущиеДанные.НастройкаСоответствия) Тогда
			
			ПоказатьЗначение(,Элементы.ТабНастройкаСоответствий.ТекущиеДанные.НастройкаСоответствия);
			
		Иначе
			
			МассивОписание=СтрРазделить(Элементы.ТабНастройкаСоответствий.ТекущиеДанные.ТаблицаАналитикиВИБ,".",Ложь);			
			
			ТекНастройкаСоответствия=Новый Структура;
			ТекНастройкаСоответствия.Вставить("ТипОбъектаВИБ",			МассивОписание[0]);
			ТекНастройкаСоответствия.Вставить("ОписаниеОбъектаВИБ",		Элементы.ТабНастройкаСоответствий.ТекущиеДанные.ОписаниеОбъектаВИБ);

			ТекНастройкаСоответствия.Вставить("Владелец",ТипБД);
			
			ОткрытьФорму("Справочник.СоответствиеВнешнимИБ.ФормаОбъекта",Новый Структура("ЗначенияЗаполнения",ТекНастройкаСоответствия),ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);			
			
			Возврат;
				
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия="ЗаписанаНастройкаСоответствия"	
		И (НЕ Элементы.ТабНастройкаСоответствий.ТекущиеДанные=Неопределено) 
		И Параметр.ТипБД=ТипБД
		И Параметр.ОписаниеОбъектаВИБ=Элементы.ТабНастройкаСоответствий.ТекущиеДанные.ОписаниеОбъектаВИБ Тогда
		
		Элементы.ТабНастройкаСоответствий.ТекущиеДанные.НастройкаСоответствия=Параметр.НастройкаСоответствия;
		
	КонецЕсли;
			
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАвтоматическиНаСервере()
	
	ИнтеграцияСВнешнимиСистемамиУХ.СформироватьНастройкиСоответствия(ТипБД,ТипДанных,РеквизитФормыВЗначение("ТабНастройкаСоответствий"));
	ОбновитьТаблицуСоответствия();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьАвтоматически(Команда)
	
	ЗаполнитьАвтоматическиНаСервере();
	
КонецПроцедуры
