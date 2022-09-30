
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Владелец") 
		И ЗначениеЗаполнено(Параметры.Отбор.Владелец) 
		И ТипЗнч(Параметры.Отбор.Владелец) = Тип("СправочникСсылка.ВидыОтчетов") 
		И Параметры.Отбор.Владелец.Предназначение=Перечисления.ПредназначенияЭлементовСтруктурыОтчета.ОборотноСальдоваяВедомость Тогда
		
		Элементы.ВидИтогаПоСчету.Видимость=Истина;
			
	ИначеЕсли Параметры.Отбор.Свойство("Владелец") 
		И  ТипЗнч(Параметры.Отбор.Владелец) = Тип("Массив") Тогда
		Элементы.СсылкаВладелец.Видимость=Истина;
		Элементы.ВидИтогаПоСчету.Видимость=Истина;	
	Иначе	
		Элементы.ВидИтогаПоСчету.Видимость=Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ВыделенныеСтроки") Тогда
		
		Элементы.Список.ТекущаяСтрока =  Параметры.ТекСтрока;
		
		Для Каждого вСтр Из Параметры.ВыделенныеСтроки Цикл
			
			Элементы.Список.ВыделенныеСтроки.Добавить(вСтр);  
			
		КонецЦикла;	
			
	КонецЕсли;	
	
    	
	
КонецПроцедуры
