// ++ НЕ УТКА

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ПланСчетовОбъект = Справочники.ПланыСчетовМеждународногоУчета.Международный.ПолучитьОбъект();
	Если Не ЗначениеЗаполнено(ПланСчетовОбъект.ВалютаПредставления) Тогда
		ПланСчетовОбъект.ВалютаПредставления = ЭтотОбъект.Значение;
		ПланСчетовОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

// -- НЕ УТКА