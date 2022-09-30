#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ДатаНачалаЗакупок) 
		И ЗначениеЗаполнено(ДатаЗапретаЗакупки) 
		И ДатаНачалаЗакупок = ДатаЗапретаЗакупки Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Период закупок должен быть больше одного дня.';
				|en = 'Purchase period should be longer than one day.'"),
			ЭтотОбъект,
			"ДатаЗапретаЗакупки",
			,
			Отказ);
		
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ДатаНачалаПродаж) 
		И ЗначениеЗаполнено(ДатаЗапретаПродажи) 
		И ДатаНачалаПродаж = ДатаЗапретаПродажи Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Период продаж должен быть больше одного дня.';
				|en = 'Sales period should be longer than one day.'"),
			ЭтотОбъект,
			"ДатаЗапретаПродажи",
			,
			Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли