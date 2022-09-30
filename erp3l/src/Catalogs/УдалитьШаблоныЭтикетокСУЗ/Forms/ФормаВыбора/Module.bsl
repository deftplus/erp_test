#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	УстановитьОтборСпискаПриОткрытии();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ШаблоныЭтикетокСУЗ" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьИзСУЗ(Команда)

	ОткрытьФорму("Справочник.УдалитьШаблоныЭтикетокСУЗ.Форма.ФормаЗагрузкаИзСУЗ", , ЭтаФорма, УникальныйИдентификатор);
		
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьОтборСпискаПриОткрытии()

	ЗначениеОтбораПоОрганизации = Неопределено;
	Параметры.Отбор.Свойство("Организация", ЗначениеОтбораПоОрганизации);
	
	Если ЗначениеОтбораПоОрганизации = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Организации = Новый СписокЗначений();
	Организации.Добавить(ЗначениеОтбораПоОрганизации);
	Если ЗначениеЗаполнено(ЗначениеОтбораПоОрганизации) Тогда
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ЗначениеОтбораПоОрганизации);
		Если МенеджерОбъекта <> Неопределено Тогда
			Организации.Добавить(МенеджерОбъекта.ПустаяСсылка());
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организации, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
	
	Параметры.Отбор.Удалить("Организация");
	
КонецПроцедуры

#КонецОбласти
