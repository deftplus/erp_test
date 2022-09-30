
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементДанных Из Параметры.Изменения Цикл
		
		Если ТипЗнч(ЭлементДанных.Объект) = Тип("Соответствие") Тогда
			Продолжить;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(Изменения.Добавить(), ЭлементДанных);
		
	КонецЦикла;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти