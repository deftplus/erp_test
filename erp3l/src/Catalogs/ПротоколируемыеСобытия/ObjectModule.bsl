
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьОшибки = Ложь;
	
	Для Каждого Запись_ Из Записи Цикл
		Если Запись_.ТипЗаписи = Перечисления.ТипыЗаписейПротоколируемыхСобытий.Ошибка Тогда
			ЕстьОшибки = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
