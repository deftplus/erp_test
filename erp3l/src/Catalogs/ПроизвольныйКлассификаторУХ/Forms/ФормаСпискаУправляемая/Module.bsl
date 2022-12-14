
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ОтборыВСписке) Тогда
		Для Каждого Элемент Из Параметры.ОтборыВСписке Цикл
			НовыйОтбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элемент.Ключ);
			НовыйОтбор.ПравоеЗначение = Новый СписокЗначений;
			
			НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			
			Для Каждого ЭлементОтбора Из Элемент.Значение Цикл
				НовыйОтбор.ПравоеЗначение.Добавить(ЭлементОтбора);
			КонецЦикла;
			НовыйОТбор.Использование = Истина;
		КонецЦикла;
	КонецЕсли;
	
	Параметры.Отбор.Свойство("Владелец",Владелец);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьОтборПоВладельцу();
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	УстановитьОтборПоВладельцу();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ.
//
&НаКлиенте
Процедура УстановитьОтборПоВладельцу()
	
	Если НЕ Владелец.Пустая() Тогда
		ТиповыеОтчеты_КлиентУХ.ДобавитьОтбор(Список.Отбор, "Владелец", Владелец);
	Иначе
		ТиповыеОтчеты_КлиентУХ.УдалитьОтбор(Список.Отбор, "Владелец");
	КонецЕсли;
	
КонецПроцедуры



