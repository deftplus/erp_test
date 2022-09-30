
Функция ПроверитьТипЗначения(ЗначениеВход, СтрокаТипаВход) Экспорт
	РезультатФункции = Ложь;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		РезультатФункции = (ТипЗнч(ЗначениеВход) = Тип(СтрокаТипаВход));
	Иначе
		РезультатФункции = Ложь;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

Функция СравнитьСТипом(ТипВход, СтрокаТипаВход) Экспорт
	РезультатФункции = Ложь;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		РезультатФункции = (ТипВход = Тип(СтрокаТипаВход));
	Иначе
		РезультатФункции = Ложь;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

Функция ПолучитьФормуАналитическогоБланка() Экспорт
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Возврат "ФормаМакетаАналитическийБланк";
	Иначе
		Возврат "ФормаМакета";
	КонецЕсли;
КонецФункции

#Область МСФО

Функция ЭтоТипВводСведенийВнаМсфо(ТипДокумента) Экспорт	
	Возврат ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() И (ТипДокумента = Тип("ДокументСсылка.ВводСведенийВНАМСФО"));	
КонецФункции

#КонецОбласти
