
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Владелец") И ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
		
		ТипБД=Параметры.Отбор.Владелец;
		ОбновитьОтборПоВладельцу();
		
		Элементы.ТипБД.Доступность=Ложь;
		
	ИначеЕсли Параметры.Отбор.Свойство("Контролируемый") И ЗначениеЗаполнено(Параметры.Отбор.Контролируемый) Тогда
		
		ТипБД=Справочники.ТипыБазДанных.ТекущаяИБ;
		
		ОбновитьОтборПоВладельцу();
		
		ОбщегоНазначенияКлиентСерверУХ.УстановитьЭлементОтбора(Список.Отбор,"Контролируемый",Истина,ВидСравненияКомпоновкиДанных.Равно,,Истина);
		
		Элементы.ТипБД.Доступность=Ложь;
			
	Иначе
		
		Элементы.ТипБД.Доступность=Истина;
		ТипБД=Справочники.ТипыБазДанных.ТекущаяИБ;			
		ОбновитьОтборПоВладельцу();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтборПоВладельцу()
	
	ОбщегоНазначенияКлиентСерверУХ.УстановитьЭлементОтбора(Список.Отбор,"Владелец",ТипБД,ВидСравненияКомпоновкиДанных.Равно,,Истина);
	
	Если ТипБД=Справочники.ТипыБазДанных.ТекущаяИБ Тогда
		
		Элементы.СписокЗагрузитьИЗВИБ.Заголовок = НСтр("ru = 'Обновить по данным текущей ИБ'");
		
	Иначе
		
		Элементы.СписокЗагрузитьИЗВИБ.Заголовок = НСтр("ru = 'Обновить по данным внешней ИБ'");
		                                                             
	КонецЕсли;
	
	Если ТипБД=Справочники.ТипыБазДанных.ТекущаяИБ Тогда
		
		Заголовок = НСтр("ru = 'Планы видов характеристик текущей информационной базы'");
		
	Иначе
		
		Заголовок = НСтр("ru = 'Планы видов характеристик внешней информационной базы'");
		
	КонецЕсли;
		
КонецПроцедуры // ОбновитьОтборПоВладельцу() 

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокСправочников(ТипБД)
	
	ОбщегоНазначенияУХ.ЗаполнитьСписокСправочниковБД(ТипБД);
		
КонецПроцедуры // ЗаполнитьСписокСправочников()

&НаКлиенте
Процедура ЗагрузитьИЗВИБ(Команда)
	
	Если НЕ ЗначениеЗаполнено(ТипБД) Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Не указан тип внешней информационной базы'"));
		Возврат;
		
	Иначе
		
		ЗаполнитьСписокСправочников(ТипБД);
		Элементы.Список.Обновить();
		
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ТипБДПриИзменении(Элемент)
	
	ОбновитьОтборПоВладельцу();
	
КонецПроцедуры
