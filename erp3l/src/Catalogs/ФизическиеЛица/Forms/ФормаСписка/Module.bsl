#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельФормы;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	ЗащитаПерсональныхДанных.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, Элементы.Список);
	// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	
	Если Параметры.РежимВыбора = Истина Тогда
		
		Элементы.Список.РежимВыбора = Истина;
		Если НЕ ЗакрыватьПриВыборе Тогда
		
			Если НЕ ПустаяСтрока(Параметры.АдресСпискаПодобранныхСотрудников) Тогда
				МассивПодобранных = ПолучитьИзВременногоХранилища(Параметры.АдресСпискаПодобранныхСотрудников);
				СписокПодобранных.ЗагрузитьЗначения(МассивПодобранных);
			КонецЕсли;
		
		КонецЕсли;
		
		Если ТолькоПросмотр Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"Список",
				"ИзменятьСоставСтрок",
				Ложь);
			
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьСписокПодобранныхСотрудников();
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,,, "ВАрхиве");
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныеФизическиеЛица.Количество() > 0 Тогда
		ОповеститьОВыборе(ВыбранныеФизическиеЛица.ВыгрузитьЗначения());
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	ЗащитаПерсональныхДанныхКлиент.ОбработкаОповещенияФормыСписка(Элементы.Список, ИмяСобытия);
	// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	
	Если Элементы.Список.РежимВыбора И ИмяСобытия = "СозданоФизическоеЛицо" И Источник = Элементы.Список Тогда
		
		Если Элементы.Список.МножественныйВыбор И ТипЗнч(Параметр) <> Тип("Массив") Тогда
			ПараметрОповещения = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Параметр);
		Иначе
			ПараметрОповещения = Параметр;
		КонецЕсли; 
		
		ОповеститьОВыборе(ПараметрОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеФормыЭлементаСправочникаФизическиеЛица");
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если Элементы.Список.РежимВыбора Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если ТипЗнч(Значение) = Тип("Массив") Тогда
			СписокЗначений = Значение;
		Иначе
			СписокЗначений = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Значение);
		КонецЕсли;
		
		Если СписокЗначений.Количество() > 0 Тогда
			
			Если Элементы.Список.МножественныйВыбор Тогда
				
				ОбновитьСписокПодобранных(СписокЗначений);
				Если СписокЗначений.Количество() > 1 Тогда
					Закрыть();
				КонецЕсли; 
				
			Иначе
				
				Если СписокПодобранных.НайтиПоЗначению(СписокЗначений[0]) = Неопределено Тогда
					ОповеститьОВыборе(СписокЗначений[0]);
				Иначе
					Закрыть();
				КонецЕсли;
				
			КонецЕсли; 
			
		КонецЕсли; 
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеФормыНовогоЭлементаСправочникаФизическиеЛица");
	
	Если Не Группа И Элементы.Список.РежимВыбора Тогда
		
		Отказ = Истина;
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
		
		ОткрытьФорму("Справочник.ФизическиеЛица.ФормаОбъекта", ПараметрыОткрытия, Элемент);

	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	ЗащитаПерсональныхДанных.ПриПолученииДанныхНаСервере(Настройки, Строки);
	// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.ЗащитаПерсональныхДанных

&НаКлиенте
Процедура Подключаемый_ПоказыватьСоСкрытымиПДн(Команда) 
	ЗащитаПерсональныхДанныхКлиент.ПоказыватьСоСкрытымиПДн(ЭтотОбъект, Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписокПодобранных(Значение)
	
	Если ТипЗнч(Значение) = Тип("Массив") Тогда
		СписокЗначений = Значение;
	Иначе
		СписокЗначений = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Значение);
	КонецЕсли;
	
	Для каждого ВыбранноеЗначение Из СписокЗначений Цикл
		Если СписокПодобранных.НайтиПоЗначению(ВыбранноеЗначение) = Неопределено Тогда
			СписокПодобранных.Добавить(ВыбранноеЗначение);
			ВыбранныеФизическиеЛица.Добавить(ВыбранноеЗначение);
		КонецЕсли; 
	КонецЦикла;
	
	УстановитьСписокПодобранныхСотрудников();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСписокПодобранныхСотрудников()
	
	ЭлементУсловногоОформления = Неопределено;
	Для каждого ЭлементОформления Из УсловноеОформление.Элементы Цикл
		Если ЭлементОформления.Представление = НСтр("ru = 'Выделение подобранных';
													|en = 'Select the picked'") Тогда
			ЭлементУсловногоОформления = ЭлементОформления;
			Прервать;
		КонецЕсли; 
	КонецЦикла; 
	
	Если ЭлементУсловногоОформления <> Неопределено Тогда
		ЭлементУсловногоОформления.Отбор.Элементы[0].ПравоеЗначение = СписокПодобранных;
	КонецЕсли; 
		
КонецПроцедуры

#КонецОбласти
