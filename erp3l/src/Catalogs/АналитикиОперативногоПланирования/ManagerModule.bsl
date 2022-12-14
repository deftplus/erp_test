#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс
	
#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Параметры.Отбор.Вставить("Ссылка", ОперативноеПланированиеПовтИспУХ.ПолучитьДоступныеДляВыбораАналитикиОперативногоПланирования());
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Функция возвращает массив аналитик, по которым возможно лимитирование по бюджетам
Функция ПолучитьЛимитируемыеАналитики() экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Справочники.АналитикиОперативногоПланирования.ВидБюджета);
	Массив.Добавить(Справочники.АналитикиОперативногоПланирования.Период);
	Массив.Добавить(Справочники.АналитикиОперативногоПланирования.ЦФО);
	Массив.Добавить(Справочники.АналитикиОперативногоПланирования.Проект);
	Массив.Добавить(Справочники.АналитикиОперативногоПланирования.СтатьяБюджета);
	Массив.Добавить(Справочники.АналитикиОперативногоПланирования.Аналитика1);
	Массив.Добавить(Справочники.АналитикиОперативногоПланирования.Аналитика2);
	Массив.Добавить(Справочники.АналитикиОперативногоПланирования.Аналитика3);
	Массив.Добавить(Справочники.АналитикиОперативногоПланирования.Аналитика4);
	Массив.Добавить(Справочники.АналитикиОперативногоПланирования.Аналитика5);
	Массив.Добавить(Справочники.АналитикиОперативногоПланирования.Аналитика6);
	Массив.Добавить(Справочники.АналитикиОперативногоПланирования.Валюта);
	
	Возврат Массив;
		
КонецФункции

#Область ОбработчикиОбновления

// Первоначальное заполнение 
Процедура ПервоначальноеЗаполнение() Экспорт
	
	// Заполняет реквизит ВозможноЛимитирование
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЛимитируемыеАналитики", Справочники.АналитикиОперативногоПланирования.ПолучитьЛимитируемыеАналитики());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АналитикиОперативногоПланирования.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА АналитикиОперативногоПланирования.Предопределенный
	|				И АналитикиОперативногоПланирования.Ссылка В (&ЛимитируемыеАналитики)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ВозможноЛимитирование
	|ИЗ
	|	Справочник.АналитикиОперативногоПланирования КАК АналитикиОперативногоПланирования
	|ГДЕ
	|	АналитикиОперативногоПланирования.ВозможноЛимитирование <> ВЫБОР
	|			КОГДА АналитикиОперативногоПланирования.Предопределенный
	|					И АналитикиОперативногоПланирования.Ссылка В (&ЛимитируемыеАналитики)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.ВозможноЛимитирование = Выборка.ВозможноЛимитирование;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьДо6АналитикСтатьи() Экспорт
	
	// Справочник.АналитикиОперативногоПланирования
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АналитикиОперативногоПланирования.Ссылка КАК Ссылка,
	|	АналитикиОперативногоПланирования.ВозможноЛимитирование КАК ВозможноЛимитирование
	|ИЗ
	|	Справочник.АналитикиОперативногоПланирования КАК АналитикиОперативногоПланирования
	|ГДЕ
	|	АналитикиОперативногоПланирования.ВозможноЛимитирование = ЛОЖЬ
	|	И АналитикиОперативногоПланирования.Ссылка В (ЗНАЧЕНИЕ(Справочник.АналитикиОперативногоПланирования.Аналитика4), ЗНАЧЕНИЕ(Справочник.АналитикиОперативногоПланирования.Аналитика5), ЗНАЧЕНИЕ(Справочник.АналитикиОперативногоПланирования.Аналитика6))";
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект);
	КонецЦикла;
	
КонецПроцедуры	
	
#КонецОбласти 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
#КонецОбласти

#КонецЕсли 