
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПРОТОКОЛИРУЕМОЕ_СОБЫТИЕ = "Справочник.ПравилаИмпортаТаблиц.Форма.ФормаЭлемента";
	
	Если ПустаяСтрока(ТекущийОбъект.ПравилаXML) Тогда
		Возврат;
	КонецЕсли;
	
	ЧтениеХML = Новый ЧтениеXML;
	
	Попытка
		ЧтениеХML.УстановитьСтроку(ТекущийОбъект.ПравилаXML);
		Правила = СериализаторXDTO.ПрочитатьXML(ЧтениеХML);
	Исключение
		ПротоколируемыеСобытияУХ.ДобавитьЗаписьОшибка(ПРОТОКОЛИРУЕМОЕ_СОБЫТИЕ, ТекущийОбъект.Метаданные(), ТекущийОбъект.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	
	МассивРеквизитов = Новый Массив;
	
	МассивРеквизитов.Добавить(Новый РеквизитФормы("ТаблицаПравила", Новый ОписаниеТипов("ТаблицаЗначений")));
	
	Для Каждого Колонка Из Правила.Колонки Цикл
		МассивРеквизитов.Добавить(Новый РеквизитФормы(Колонка.Имя, Колонка.ТипЗначения, "ТаблицаПравила"));
	КонецЦикла; 
	
	ИзменитьРеквизиты(МассивРеквизитов);
	
	ЭлементПравила = Элементы.Добавить("ТаблицаПравила", Тип("ТаблицаФормы"), Элементы.Таблица);
	ЭлементПравила.ПутьКДанным = "ТаблицаПравила";
	ЭлементПравила.ИзменятьПорядокСтрок = Ложь;
	ЭлементПравила.ИзменятьСоставСтрок = Ложь;
	ЭлементПравила.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
	
	Для Каждого Колонка Из Правила.Колонки Цикл
		ЭлементКолонка = Элементы.Добавить(Колонка.Имя, Тип("ПолеФормы"), ЭлементПравила);
		ЭлементКолонка.ПутьКДанным = "ТаблицаПравила." + Колонка.Имя;
	КонецЦикла; 
	
	ЗначениеВРеквизитФормы(Правила, "ТаблицаПравила");
	
КонецПроцедуры
