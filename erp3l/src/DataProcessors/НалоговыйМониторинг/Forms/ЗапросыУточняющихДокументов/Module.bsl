
&НаКлиенте
Процедура ОтметкаОценки(Команда)
	ОтметкаОценкиНаСервере(Элементы.Список.ТекущаяСтрока);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтметкаОценкиНаСервере(ДокументМониторинга)
	
	Если Не ЗначениеЗаполнено(ДокументМониторинга) Тогда 
		Возврат;
	КонецЕсли;
	
	Запись = РегистрыСведений.ОценкаОтветаНаЗапросНалоговогоОргана.СоздатьМенеджерЗаписи();
	Запись.Период = ТекущаяДата();
	Запись.Запрос = ДокументМониторинга;
	Запись.ОценкаНалоговогоОргана = Истина;
	Запись.Записать(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтвет(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(Неопределено, ТекущаяСтрока.Ответ);
	
КонецПроцедуры

&НаКлиенте
Процедура Все(Команда)
	БыстрыйОтбор = 0;
	ОбновитьБыстрыйОтбор();
КонецПроцедуры

&НаКлиенте
Процедура Черновики(Команда)
	БыстрыйОтбор = 1;
	ОбновитьБыстрыйОтбор();
КонецПроцедуры

&НаКлиенте
Процедура НеОбработанные(Команда)
	БыстрыйОтбор = 2;
	ОбновитьБыстрыйОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьБыстрыйОтбор()
	Элементы.СписокВсе.Пометка = Ложь;
	Элементы.СписокЧерновики.Пометка = Ложь;
	Элементы.СписокНеОбработанные.Пометка = Ложь;
	Если БыстрыйОтбор = 0 Тогда
		Элементы.СписокВсе.Пометка = Истина;
	ИначеЕсли БыстрыйОтбор = 1 Тогда
		Элементы.СписокЧерновики.Пометка = Истина;
	ИначеЕсли БыстрыйОтбор = 2 Тогда
		Элементы.СписокНеОбработанные.Пометка = Истина;
	КонецЕсли;
	
	Список.Отбор.Элементы.Очистить();
	Если БыстрыйОтбор = 1 Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОценкаНалогоплательщика");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = 3;
	ИначеЕсли БыстрыйОтбор = 2 Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОценкаНалоговогоОргана");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = Истина;
	КонецЕсли;
КонецПроцедуры