#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользуетсяСервисКабинетСотрудника") Тогда
		ВызватьИсключение НСтр("ru = 'Сервис подключен. Нельзя изменить значение ""Сервис 1С:Кабинет сотрудника в локальной сети""';
								|en = 'The service is connected. You cannot change the ""1C:Employee account service on the local network"" value'");
	КонецЕсли;
			
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли
