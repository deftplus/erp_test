
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Владелец") 
		И ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
		
		Если Параметры.Отбор.Владелец.Предназначение=Перечисления.ПредназначенияЭлементовСтруктурыОтчета.БюджетДвиженияДенежныхСредств Тогда
			
			Элементы.СтатьяДвиженияДенежныхСредств.Видимость=Истина;
			Элементы.ПриходРасход.Видимость=Истина;
			
		ИначеЕсли Параметры.Отбор.Владелец.Предназначение=Перечисления.ПредназначенияЭлементовСтруктурыОтчета.БюджетДоходовИРасходов Тогда
			
			Элементы.СтатьяДоходовИРасходов.Видимость=Истина;
			Элементы.ПриходРасход.Видимость=Истина;
			
		ИначеЕсли Параметры.Отбор.Владелец.Предназначение=Перечисления.ПредназначенияЭлементовСтруктурыОтчета.ОборотноСальдоваяВедомость Тогда 
			
			Элементы.СчетБД.Видимость=Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
