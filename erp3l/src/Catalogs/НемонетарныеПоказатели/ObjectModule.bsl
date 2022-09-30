
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		Наименование = НаименованиеДляПечати;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
