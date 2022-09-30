

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Родитель") И ЗначениеЗаполнено(Параметры.Отбор.Родитель) Тогда			
		Элементы.Список.Отображение=ОтображениеТаблицы.Список;	
	Иначе	
		Элементы.Список.Отображение=ОтображениеТаблицы.ИерархическийСписок;	
	КонецЕсли;
	
	ТолькоПроекты = Параметры.ВыборТолькоПроектов;
	ТолькоЭтапы   = Параметры.ВыборТолькоЭтапов;
	
КонецПроцедуры


&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ЕстьПроекты = Ложь;
	
	Если ТолькоЭтапы Тогда
		
		Если ВыборСодержитПроекты(Значение) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Необходимо выбрать только этапы проектов'"),,,,);	
			СтандартнаяОбработка = Ложь;
		КонецЕсли;	
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Функция ВыборСодержитПроекты(Значение)
	
	ЕстьПроекты = Ложь;
	
	Если ТипЗнч(Значение) = Тип("Массив") Тогда
		Для Каждого Стр Из Значение Цикл
			Если Стр.Проект Тогда
				 Возврат Истина;
			КонецЕсли;	
		КонецЦикла;		
	Иначе	
		 ЕстьПроекты = Значение.Проект;
	КонецЕсли;
	
	Возврат ЕстьПроекты;
	
КонецФункции	