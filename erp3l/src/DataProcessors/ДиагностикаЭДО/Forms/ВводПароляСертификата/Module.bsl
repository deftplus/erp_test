

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Сертификат", Сертификат);
	
	Пояснение = "";
	Если Параметры.Свойство("Пояснение", Пояснение) И ЗначениеЗаполнено(Пояснение) Тогда
		Элементы.Пояснение.Заголовок = Пояснение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ЗавершениеРаботыПрограммы = ЗавершениеРаботы;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ЭлектроннаяПодписьКлиент.УстановитьПарольСертификата(Сертификат, Пароль);
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти