#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПланыВидовХарактеристик.ВидыБюджетов.ОбновитьФункциональныеОпцииИспользованияСтатейБюджетов();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли 
