
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Исполнитель", Исполнитель);
	Параметры.Свойство("ТекущийПользователь", ТекущийПользователь);
	
	Элементы.КомандаИсполнительЗадачи.Заголовок = 
		Строка(Исполнитель);
	
	Элементы.КомандаТекущийПользователь.Заголовок = СтрШаблон(
		НСтр("ru = 'Я, %1';
			|en = 'Me, %1'"),
		Строка(ТекущийПользователь));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаИсполнительЗадачи(Команда)
	
	Закрыть("taskPerformer");
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаТекущийПользователь(Команда)
	
	Закрыть("currentUser");
	
КонецПроцедуры

#КонецОбласти