#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ДанныеОРасхождениях") Тогда
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли; 
	
	ДатыОстатков = Новый ФиксированноеСоответствие(Параметры.ДатыОстатков);
	
	Для каждого ОписаниеРасхождения Из Параметры.ДанныеОРасхождениях Цикл
		ЗаполнитьЗначенияСвойств(РезультатыПроверки.Добавить(), ОписаниеРасхождения);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРезультатыПроверки

&НаКлиенте
Процедура РезультатыПроверкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "РезультатыПроверкиПредставлениеОшибки" Тогда
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("ДатаОстатков", ДатыОстатков.Получить(Элемент.ТекущиеДанные.Сотрудник));
		
		МассивОбъектов = Новый Массив;
		МассивОбъектов.Добавить(Элемент.ТекущиеДанные.Сотрудник);
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Справочник.Сотрудники", "СправкаПоОтпускамСотрудника", 
				МассивОбъектов, ЭтаФорма, ПараметрыПечати);
				
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
