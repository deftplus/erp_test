#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// АПК:277-выкл допустимое исключение
	КабинетСотрудника.ИмущественныеВычетыНДФЛПередЗаписью(ЭтотОбъект);
	// АПК:277-вкл
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// АПК:277-выкл допустимое исключение
	КабинетСотрудника.ИмущественныеВычетыНДФЛПриЗаписи(ЭтотОбъект);
	// АПК:277-вкл
	
КонецПроцедуры



#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли