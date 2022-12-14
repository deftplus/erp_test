Функция ПодобратьТипЗначения(Т) Экспорт
	
	Длина = СтрДлина(Т);
	Если Длина = 10 ИЛИ Длина = 19 Тогда // канонические представления даты
	
		Точка = КодСимвола(".");
		Пробел = КодСимвола(" ");
		Двоеточие = КодСимвола(":");
		
		Если Длина = 10 Тогда
			Если КодСимвола(Т, 3) = Точка И КодСимвола(Т, 6) = Точка Тогда
				Попытка
					А = Дата(Прав(Т, 4) + Сред(Т, 4, 2) + Лев(Т, 2));
					Возврат Новый ОписаниеТипов("Дата");
				Исключение
				КонецПопытки;
			КонецЕсли;
		Иначе
			Если КодСимвола(Т, 3) = Точка И КодСимвола(Т, 6) = Точка И КодСимвола(Т, 11) = Пробел И КодСимвола(Т, 14) = Двоеточие И КодСимвола(Т, 17) = Двоеточие Тогда
				Попытка
					А = Дата(Сред(Т, 7, 4) + Сред(Т, 4, 2) + Лев(Т, 2) + Сред(Т, 12, 2) + Сред(Т, 15, 2) + Прав(Т, 2));
					Возврат Новый ОписаниеТипов("Дата");
				Исключение
				КонецПопытки;
			КонецЕсли; 
		КонецЕсли;
		
	КонецЕсли;
	
	Попытка
		ТипТ = Вычислить("ТипЗнч(" + Т + ")");
		Типы = Новый Массив;
		Типы.Добавить(ТипТ);
		Возврат Новый ОписаниеТипов(Типы);
	Исключение
	КонецПопытки;
	
	Возврат Новый ОписаниеТипов("Строка");
		
КонецФункции