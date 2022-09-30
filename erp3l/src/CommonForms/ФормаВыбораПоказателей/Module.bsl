#Область ОписаниеПеременных

&НаКлиенте
Перем ДействиеВыбрано;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Показатели.Подсказка = Параметры.Комментарий;
	Заголовок = ?(ПустаяСтрока(Параметры.ЗаголовокФормы), НСтр("ru = 'Выбор показателей';
																|en = 'Select indicators'"), Параметры.ЗаголовокФормы);
	
	Если Параметры.ПоказателиДляВыбора.Количество() Тогда
		
		Для Каждого Показатель Из Параметры.ПоказателиДляВыбора Цикл
			НоваяСтрока = Показатели.Добавить();
			НоваяСтрока.Показатель = Показатель.Значение;
			НоваяСтрока.Выбран = Показатель.Пометка;
		КонецЦикла;
		
		Элементы.Показатели.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
		Элементы.Показатели.ИзменятьСоставСтрок = Ложь;
		Элементы.Показатели.ИзменятьПорядокСтрок = Ложь;
		
	Иначе
		
		Для Каждого ВыбранныйПоказатель Из Параметры.ВыбранныеПоказатели Цикл
			НоваяСтрока = Показатели.Добавить();
			НоваяСтрока.Показатель = ВыбранныйПоказатель.Значение;
			НоваяСтрока.Выбран = Истина;
		КонецЦикла;
		
		УстановитьПривилегированныйРежим(Истина);
		ПоказателиРасчетаЗарплаты = ПлановыеНачисленияСотрудников.ПоказателиНачислений();
		УстановитьПривилегированныйРежим(Ложь);
		
		Для Каждого СтрокаПоказателя Из ПоказателиРасчетаЗарплаты Цикл
			Если Параметры.ВыбранныеПоказатели.НайтиПоЗначению(СтрокаПоказателя.Показатель) = Неопределено Тогда
				НоваяСтрока = Показатели.Добавить();
				НоваяСтрока.Показатель = СтрокаПоказателя.Показатель;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ДействиеВыбрано <> Истина Тогда
		ОповеститьОВыборе(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказателиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		
	Если Поле.Имя = "Показатель" Тогда
		ПоказатьЗначение(, Элементы.Показатели.ТекущиеДанные.Показатель);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ДействиеВыбрано = Истина;
	
	Если Не Модифицированность Тогда
		ОповеститьОВыборе(Неопределено);
		Возврат;
	КонецЕсли;
	
	ВыбранныеПоказатели = Новый СписокЗначений;
	Для Каждого СтрокаПоказателя Из Показатели Цикл
		Если СтрокаПоказателя.Выбран Тогда
			ВыбранныеПоказатели.Добавить(СтрокаПоказателя.Показатель);
		КонецЕсли;
	КонецЦикла;
	
	ОповеститьОВыборе(ВыбранныеПоказатели);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ДействиеВыбрано = Истина;
	ОповеститьОВыборе(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	ЗаполнитьОтметки(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметку(Команда)
	ЗаполнитьОтметки(Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьОтметки(ЗначениеОтметки)
	Модифицированность = Истина;
	Для Каждого СтрокаПоказателя Из Показатели Цикл
		СтрокаПоказателя.Выбран = ЗначениеОтметки;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти