
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Владелец") 
		И ЗначениеЗаполнено(Параметры.Отбор.Владелец)
		И Параметры.Отбор.Владелец.Предназначение=Перечисления.ПредназначенияЭлементовСтруктурыОтчета.ОборотноСальдоваяВедомость Тогда
		
		Элементы.ВидИтогаПоСчету.Видимость=Истина;
		
	Иначе
		
		Элементы.ВидИтогаПоСчету.Видимость=Ложь;
		
	КонецЕсли;
	
КонецПроцедуры
