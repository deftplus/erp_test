
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
//++ НЕ УТ
	ВнеоборотныеАктивыЛокализация.УстановитьПараметрыНабораСвойствВНА22();
//-- НЕ УТ

КонецПроцедуры

#КонецОбласти

#КонецЕсли
