#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru = 'Пожалуйста, подождите...';
							|en = 'Please wait...'");
	Если Не ПустаяСтрока(Параметры.ТекстСообщения) Тогда
		ТекстСообщения = Параметры.ТекстСообщения + Символы.ПС + ТекстСообщения;
		Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = ТекстСообщения;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Закрыть(Новый Структура("ЗакрытьЗадачу", Истина));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РедактироватьЗадачу(Команда)
	Закрыть(Новый Структура("ЗакрытьЗадачу", Ложь));
КонецПроцедуры


&НаКлиенте
Процедура ЗакрытьЗадачу(Команда)
	Закрыть(Новый Структура("ЗакрытьЗадачу", Истина));
КонецПроцедуры

#КонецОбласти