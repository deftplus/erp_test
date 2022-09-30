#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	ЗаполнитьЗначенияСвойств(СвойстваСписка, Сотрудники);
	
	Сотрудники.Параметры.УстановитьЗначениеПараметра("Склад", Параметры.Склад);
	
	Если Параметры.ЭтоКурьер Тогда
		Заголовок = НСтр("ru = 'Выбор курьера';
						|en = 'Select courier'");
	Иначе
		Заголовок = НСтр("ru = 'Выбор сборщика';
						|en = 'Select picker'");
		СвойстваСписка.ТекстЗапроса = СтрЗаменить(Сотрудники.ТекстЗапроса, "Курьер", "Сборщик");
	КонецЕсли;
	
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Сотрудники, СвойстваСписка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудники


// Обработка событие "Выбор" табличного поля "Сотрудники"
// 
// Параметры:
// 	Элемент - ТаблицаФормы - Список сотрудников
// 	ВыбраннаяСтрока - СправочникСсылка.ФизическиеЛица
// 	Поле - ПолеФормы
// 	СтандартнаяОбработка - Булево
&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Закрыть(ВыбраннаяСтрока);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	Закрыть(Элементы.Сотрудники.ТекущаяСтрока);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти