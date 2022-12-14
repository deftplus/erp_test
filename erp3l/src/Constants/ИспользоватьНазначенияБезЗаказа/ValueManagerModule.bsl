#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("КонстантаВычисленаПослеБлокировки") Тогда
		
		ВызватьИсключение НСтр("ru = 'Значение константы ""Использовать назначения без заказа"" должно вычисляться после установки исключительной блокировки';
								|en = 'Value of the ""Use assignments without order"" constant should be calculated after exclusive lock is set'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
