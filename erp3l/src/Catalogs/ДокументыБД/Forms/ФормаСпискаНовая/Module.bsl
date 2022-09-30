
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Владелец") И ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
		
		ТипБД=Параметры.Отбор.Владелец;
		
		Если ТипБД.ВерсияПлатформы=Перечисления.ПлатформыВнешнихИнформационныхБаз.ADO Тогда
			
			ОбщегоНазначенияУХ.СообщитьОбОшибке(НСтр("ru = 'Для выбранного типа информационной базы доступны только таблицы ADO'"), Отказ,,СтатусСообщения.Информация);
			Возврат;
			
		КонецЕсли;
		
		ОбновитьОтборПоВладельцу();
		
		Элементы.ТипБД.Доступность=Ложь;
		
	Иначе
		
		Элементы.ТипБД.Доступность=Истина;
		ТипБД=Справочники.ТипыБазДанных.ТекущаяИБ;
		ОбновитьОтборПоВладельцу();
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТипБДПриИзменении(Элемент)
	
	ОбновитьОтборПоВладельцу();

КонецПроцедуры

&НаСервере
Процедура ОбновитьОтборПоВладельцу()
	
	ОбщегоНазначенияКлиентСерверУХ.УстановитьЭлементОтбора(Список.Отбор, "Владелец", ТипБД, ВидСравненияКомпоновкиДанных.Равно, , Истина);
	
		
	Если ТипБД = Справочники.ТипыБазДанных.ТекущаяИБ Тогда
		
		Элементы.СписокЗагрузитьИЗВИБ.Заголовок = НСтр("ru = 'Обновить по данным текущей ИБ'");		
		Элементы.СписокЗаполнитьКлючевыеРеквизитыМСФО.Видимость = Истина;
		
	Иначе
		
		Элементы.СписокЗагрузитьИЗВИБ.Заголовок = НСтр("ru = 'Обновить по данным внешней ИБ'");
		Элементы.СписокЗаполнитьКлючевыеРеквизитыМСФО.Видимость = Ложь;
		
	КонецЕсли;
	
	Если ТипБД = Справочники.ТипыБазДанных.ТекущаяИБ Тогда
		
		Заголовок = НСтр("ru = 'Документы текущей информационной базы'");
				
	Иначе
		
		Заголовок = НСтр("ru = 'Документы внешней информационной базы'");
				
	КонецЕсли;
			
КонецПроцедуры // ОбновитьОтборПоВладельцу() 

&НаКлиенте
Процедура ЗагрузитьИЗВИБ(Команда)
	
	Если НЕ ЗначениеЗаполнено(ТипБД) Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Не указан тип внешней информационной базы.'"));
		Возврат;
		
	Иначе
		
		ЗаполнитьСписокДокументов(ТипБД);
		Элементы.Список.Обновить();
		
	КонецЕсли;
			
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокДокументов(ТипБД)
	
	ОбщегоНазначенияУХ.ЗаполнитьСписокДокументовБД(ТипБД);
		
КонецПроцедуры // ЗаполнитьСписокСправочников()

&НаСервереБезКонтекста
Процедура ЗаполнитьКлючевыеРеквизитыМСФОНаСервере()
	Справочники.ДокументыБД.ЗаполнитьКлючевыеРеквизитыМСФОПоУмолчанию();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКлючевыеРеквизитыМСФО(Команда)
	ЗаполнитьКлючевыеРеквизитыМСФОНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура ПометитьНаУдалениеОтсутствующие(Команда)
	ОбщегоНазначенияУХ.ПометитьНаУдалениеОтсутствующие("Справочник.ДокументыБД");
	Элементы.Список.Обновить();
КонецПроцедуры

