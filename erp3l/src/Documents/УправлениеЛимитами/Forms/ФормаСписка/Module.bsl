#Область ОбработчикиСобытийФормы
	// Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
	// Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки, ИспользуютсяСтандартныеНастройки)
	
	Если Параметры.Отбор.Количество() > 0 Тогда
		
		Отборы = Новый Массив;
		Отборы.Добавить("ВидБюджета");
		Отборы.Добавить("ЦФО");
		Отборы.Добавить("ВидОперации");
		Отборы.Добавить("ПериодЛимитирования");
		Отборы.Добавить("Проект");
		
		Для Поз = 0 По Отборы.Количество()-1 Цикл
			ИмяОтбора = Отборы[Поз];
			ЗначениеОтбора = неопределено;
			Если НЕ Параметры.Отбор.Свойство(ИмяОтбора, ЗначениеОтбора) Тогда
				Продолжить;
			КонецЕсли;
			Настройки.Элементы[Поз].ПравоеЗначение = ЗначениеОтбора;
			Настройки.Элементы[Поз].Использование = Истина;
		КонецЦикла;
		
		Параметры.Отбор.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
	// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	// Код процедур и функций
#КонецОбласти

