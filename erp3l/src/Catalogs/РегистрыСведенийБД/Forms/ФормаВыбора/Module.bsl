
&НаКлиенте
Процедура ЗагрузитьИЗВИБ(Команда)
	
	Если НЕ ЗначениеЗаполнено(ТипБД) Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Не указан тип внешней информационной базы'"));
		Возврат;
		
	Иначе
		
		ЗаполнитьСписокРегистровСведений(ТипБД);
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокРегистровСведений(ТипБД)
		
	ОбщегоНазначенияУХ.ЗаполнитьСписокРегистровБД(ТипБД,,,,Истина);
	
КонецПроцедуры //

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		ТипБД = Параметры.Отбор.Владелец;
	Иначе
		ТипБД = Справочники.ТипыБазДанных.ТекущаяИБ;
		НовыйЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
		НовыйЭлементОтбора.Использование = Истина;
		НовыйЭлементОтбора.ПравоеЗначение = ТипБД;
	КонецЕсли;
	Если ТипБД = Справочники.ТипыБазДанных.ТекущаяИБ Тогда
		
		Элементы.СписокЗагрузитьИЗВИБ.Заголовок = НСтр("ru = 'Обновить по данным текущей ИБ'");
		
	Иначе
		
		Элементы.СписокЗагрузитьИЗВИБ.Заголовок = НСтр("ru = 'Обновить по данным внешней ИБ'");
		
	КонецЕсли;
	
КонецПроцедуры

