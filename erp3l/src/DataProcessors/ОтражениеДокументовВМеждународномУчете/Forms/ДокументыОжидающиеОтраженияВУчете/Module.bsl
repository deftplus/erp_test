
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ДатаОкончанияПериода") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"ДатаОтражения",
			Параметры.ДатаОкончанияПериода,
			ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
			,
			Истина);
	КонецЕсли;
	
	Если Параметры.Свойство("ДатаЗапрета") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"ДатаОтражения",
			Параметры.ДатаЗапрета,
			ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
			,
			Истина);
	КонецЕсли;
	
	Элементы.Организация.Видимость = Не Параметры.Отбор.Свойство("Организация");
	Элементы.ПланСчетов.Видимость = Не Параметры.Отбор.Свойство("ПланСчетов");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "Запись_ОтражениеДокументовВМеждународномУчете" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПоказатьЗначение(, Элемент.ТекущиеДанные.Документ);
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроводкиМеждународногоУчета(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Для выполнения команды необходимо выбрать документ';
																|en = 'To execute the command, select a document'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура("Регистратор", ТекущиеДанные.Документ);
	ПараметрыФормы = Новый Структура("Отбор", ПараметрыОтбора);
	ОткрытьФорму("РегистрБухгалтерии.Международный.Форма.ПроводкиМеждународногоУчета", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
