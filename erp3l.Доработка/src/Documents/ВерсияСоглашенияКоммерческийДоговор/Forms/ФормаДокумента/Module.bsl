
&НаСервере
Процедура ллл_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	//иначе я не понимаю как вообще руками создать договор в валюте
	//Конилов
	
	
	Если Параметры.Свойство("ЗначенияЗаполнения") И  Параметры.ЗначенияЗаполнения.Свойство("ВалютаВзаиморасчетов") тогда
		Объект.ВалютаВзаиморасчетов=Параметры.ЗначенияЗаполнения.ВалютаВзаиморасчетов;
		
		
		
	КонецЕсли;	
	
	
КонецПроцедуры
