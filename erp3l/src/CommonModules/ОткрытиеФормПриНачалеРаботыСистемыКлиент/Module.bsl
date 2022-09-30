
#Область ПрограммныйИнтерфейс

// Обработчик события ПриНачалеРаботыСистемы вызывается
// для выполнения действий, требуемых для подсистемы ОткрытиеФормПриНачалеРаботыСистемы.
//
Процедура ПриНачалеРаботыСистемы() Экспорт
	
	МассивФорм = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске().ФормыОткрываемыеПриНачалеРаботыСистемы;
	
	Для Каждого ТекущаяФорма Из МассивФорм Цикл
		
		Если ТекущаяФорма.ОткрыватьПоУмолчанию Тогда
			
			ОткрытьТекущуюФорму(ТекущаяФорма);
			
		Иначе
			
			Если СтрНайти(ВРег(ПараметрЗапуска), ВРег(ТекущаяФорма.ПараметрЗапуска)) = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			ОткрытьТекущуюФорму(ТекущаяФорма);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если НЕ ПустаяСтрока(глФормаНачальнойНастройкиПрограммы) Тогда
		
		ТекущаяФорма = ОткрытиеФормПриНачалеРаботыСистемыКлиентСерверПереопределяемый.ОписаниеНастроекФормы();
		ТекущаяФорма.Вставить("ИмяЗапускаемойФормы", глФормаНачальнойНастройкиПрограммы);
		ТекущаяФорма.Вставить("ОткрыватьМодально", Истина);
		
		ОткрытьТекущуюФорму(ТекущаяФорма);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Открывает форму необходимого рабочего места.
//
// Параметры:
//	ПараметрыТекущейФормы - Структура - параметры для открытия формы рабочего места (кассира, помощника продаж и т.п.).
//
Процедура ОткрытьТекущуюФорму(ПараметрыТекущейФормы)
	
	Если ПараметрыТекущейФормы.НеобходимыНастройки И Не ПараметрыТекущейФормы.НастройкиУстановлены Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При попытке открытия формы ""%1"" произошла ошибка - не заданы настройки формы. Обратитесь к администратору.';
				|en = 'An error occurred when trying to open the ""%1"" form - form settings are not specified. Please contact the administrator.'"),
			ПараметрыТекущейФормы.ИмяЗапускаемойФормы);
		
		ВызватьИсключение ТекстСообщения;
		
	КонецЕсли;
	
	Если ВРег(ПараметрыТекущейФормы.ПараметрЗапуска) = ВРег("WarehouseMobileWorkplace") Тогда
		
		Если Не ПараметрыТекущейФормы.Параметры.Свойство("РазрешениеЭкрана") Тогда
			
			ИмяЗапускаемойФормы = "Обработка.РабочееМестоРаботникаСклада.Форма.ФормаРабочегоМеста_320х320";
			
		Иначе
			
			Если ПараметрыТекущейФормы.Параметры.РазрешениеЭкрана = ПредопределенноеЗначение("Перечисление.РазрешенияЭкрана.Разрешение320х320") Тогда
				
				ИмяЗапускаемойФормы = "Обработка.РабочееМестоРаботникаСклада.Форма.ФормаРабочегоМеста_320х320";
				
			ИначеЕсли ПараметрыТекущейФормы.Параметры.РазрешениеЭкрана = ПредопределенноеЗначение("Перечисление.РазрешенияЭкрана.Разрешение240х320") Тогда
				
				ИмяЗапускаемойФормы = "Обработка.РабочееМестоРаботникаСклада.Форма.ФормаРабочегоМеста_240х320";
				
			ИначеЕсли ПараметрыТекущейФормы.Параметры.РазрешениеЭкрана = ПредопределенноеЗначение("Перечисление.РазрешенияЭкрана.Разрешение480х640") Тогда
				
				ИмяЗапускаемойФормы = "Обработка.РабочееМестоРаботникаСклада.Форма.ФормаРабочегоМеста_480х640";
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ИмяЗапускаемойФормы = ПараметрыТекущейФормы.ИмяЗапускаемойФормы;
		
	КонецЕсли;
	
	ПараметрыОткрытияФормы = Новый Структура;
	Для Каждого КлючИЗначение Из ПараметрыТекущейФормы.Параметры Цикл
		ПараметрыОткрытияФормы.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	Если ПараметрыТекущейФормы.ОткрыватьМодально Тогда
		ОткрытьФорму(ИмяЗапускаемойФормы, ПараметрыОткрытияФормы,,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	Иначе
		
		ИмяКлючевойОперации = СтрШаблон(
		"ОткрытиеФормПриНачалеРаботыСистемыКлиент.%1", ИмяЗапускаемойФормы);
		ОценкаПроизводительностиКлиент.ЗамерВремени(ИмяКлючевойОперации);
		
		ОткрытьФорму(ИмяЗапускаемойФормы, ПараметрыОткрытияФормы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
