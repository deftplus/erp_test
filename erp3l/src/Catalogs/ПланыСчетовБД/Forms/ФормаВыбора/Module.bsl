
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Владелец") И ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
		
		ТипБД=Параметры.Отбор.Владелец;
		
		Если ТипБД.ВерсияПлатформы=Перечисления.ПлатформыВнешнихИнформационныхБаз.ADO Тогда
			
			ОбщегоНазначенияУХ.СообщитьОбОшибке(НСтр("ru = 'Для выбранного типа информационной базы доступны только таблицы ADO'"), Отказ, , СтатусСообщения.Информация);
			Возврат;
			
		КонецЕсли;
				
		Элементы.ТипБД.Доступность=Ложь;
		
	ИначеЕсли ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда
		
		ТипБД=Параметры.ТекущаяСтрока.Владелец;
		ОбновитьОтборПоВладельцу();
				
	Иначе
		
		Элементы.ТипБД.Доступность=Истина;	
		ТипБД=Справочники.ТипыБазДанных.ТекущаяИБ;
		ОбновитьОтборПоВладельцу();
		
	КонецЕсли;	
	
	Если ТипБД=Справочники.ТипыБазДанных.ТекущаяИБ Тогда
		
		Элементы.ФормаЗагрузитьИЗВИБ.Заголовок = НСтр("ru = 'Обновить по данным текущей ИБ'");
		
	Иначе
		
		Элементы.ФормаЗагрузитьИЗВИБ.Заголовок = НСтр("ru = 'Обновить по данным внешней ИБ'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтборПоВладельцу()
	
	Справочники.РегистрыБухгалтерииБД.ПроверитьНаличиеОписанийРегистров(ТипБД);
	
	ОбщегоНазначенияКлиентСерверУХ.УстановитьЭлементОтбора(Список.Отбор,"Владелец",ТипБД,ВидСравненияКомпоновкиДанных.Равно,,Истина);
	
	Если ТипБД=Справочники.ТипыБазДанных.ТекущаяИБ Тогда
		
		Элементы.ФормаЗагрузитьИЗВИБ.Заголовок = НСтр("ru = 'Обновить по данным текущей ИБ'");
		
	Иначе
		
		Элементы.ФормаЗагрузитьИЗВИБ.Заголовок = НСтр("ru = 'Обновить по данным внешней ИБ'");
		
	КонецЕсли;
		
КонецПроцедуры // ОбновитьОтборПоВладельцу() 

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокРегистровБухгалтерии(ТипБД)
		
	РаботаСОбъектамиМетаданныхУХ.ЗаполнитьСписокРегистровБД(ТипБД,,Истина,,,Истина,Истина);
	
КонецПроцедуры //

&НаКлиенте
Процедура ТипБДПриИзменении(Элемент)
	
	ОбновитьОтборПоВладельцу();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИЗВИБ(Команда)
	
	Если НЕ ЗначениеЗаполнено(ТипБД) Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Не указан тип внешней информационной базы'"));
		Возврат;
		
	Иначе
		
		ЗаполнитьСписокРегистровБухгалтерии(ТипБД);
		Элементы.Список.Обновить();
		
	КонецЕсли;
			
КонецПроцедуры
