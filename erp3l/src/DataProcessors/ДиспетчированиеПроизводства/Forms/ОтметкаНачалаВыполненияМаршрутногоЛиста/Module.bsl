//++ Устарело_Производство21
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ПолеДата  = ТекущаяДатаСеанса();
	ПолеВремя = ТекущаяДатаСеанса();
	
	ОперативныйУчетПроизводства.ЗаполнитьВыборВремени(Элементы.ПолеВремя.СписокВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		ДатаИВремя = ПолеДата + Час(ПолеВремя) * 3600 + Минута(ПолеВремя) * 60;
		Закрыть(Новый Структура("ФактическоеНачало", ДатаИВремя));
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти
//-- Устарело_Производство21
