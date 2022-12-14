#Область ПрограммныйИнтерфейс

// Параметры конфигурации в примитивном виде на основе данных таблицы значений
// "ПараметрыКонфигурации".
// 
// Параметры:
//  ВходящиеПараметрыКонфигурации - Входящие параметры конфигурации
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Параметры конфигурации в примитивном виде:
// 		* Ключ - Строка, ПланВидовХарактеристикСсылка.СП_ПараметрыКонфигурации
// 		* Значение - Строка, СправочникСсылка.СП_ЗначенияПараметровКонфигурации
//
Функция ПараметрыКонфигурацииВПримитивномВиде(ВходящиеПараметрыКонфигурации) Экспорт
	
	Таблица = НоваяТаблицаПараметровКонфигурации();
		
	Для Каждого Строка Из ВходящиеПараметрыКонфигурации Цикл
		СтрокаТаблицы = Таблица.Добавить();	
		СтрокаТаблицы.Ключ = КлючПараметраКонфигурации(Строка.Ключ);
		СтрокаТаблицы.Значение = ЗначениеПараметраКонфигурации(Строка.Значение);
		СтрокаТаблицы.ТипПараметра = Строка.ТипПараметра;
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НоваяТаблицаПараметровКонфигурации()
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Ключ");
	Таблица.Колонки.Добавить("Значение");
	Таблица.Колонки.Добавить("ТипПараметра");
	
	Возврат Таблица;
		
КонецФункции

Функция КлючПараметраКонфигурации(Значение)
	
	Если ТипЗнч(Значение) = Тип("ПланВидовХарактеристикСсылка.СП_ПараметрыКонфигурации") Тогда
		Возврат Значение.Наименование;
			
	Иначе
		Возврат Значение;
				
	КонецЕсли;
	
КонецФункции

Функция ЗначениеПараметраКонфигурации(Значение)
	
	ТипЗначенияПараметра = ТипЗнч(Значение); 
	Если ТипЗначенияПараметра = Тип("СправочникСсылка.СП_ЗначенияПараметровКонфигурации") Тогда
		Возврат Значение.Наименование;
			
	ИначеЕсли ТипЗначенияПараметра = Тип("Число") Тогда
		Возврат XMLСтрока(Значение);
		
	Иначе
		Возврат Значение;
				
	КонецЕсли;
	
КонецФункции

#КонецОбласти