#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Не ПроведениеДокументов.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый",    ДополнительныеСвойства.СвойстваДокумента.ЭтоНовый);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.ЗаказНаСборку  КАК ЗаказНаСборку,
	|	Таблица.Номенклатура   КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	Таблица.Серия          КАК Серия,
	|	Таблица.КодСтроки      КАК КодСтроки,
	|	Таблица.ТипСборки      КАК ТипСборки,
	|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|			Таблица.Заказано
	|		ИНАЧЕ
	|			-Таблица.Заказано
	|	КОНЕЦ                  КАК ЗаказаноПередЗаписью,
	|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|			Таблица.КОформлению
	|		ИНАЧЕ
	|			-Таблица.КОформлению
	|	КОНЕЦ                  КАК КОформлениюПередЗаписью
	|ПОМЕСТИТЬ ДвиженияЗаказыНаСборкуПередЗаписью
	|ИЗ
	|	РегистрНакопления.ЗаказыНаСборку КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И НЕ &ЭтоНовый
	|";
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ПроведениеДокументов.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаИзменений.ЗаказНаСборку               КАК ЗаказНаСборку,
	|	ТаблицаИзменений.Номенклатура                КАК Номенклатура,
	|	ТаблицаИзменений.Характеристика              КАК Характеристика,
	|	ТаблицаИзменений.Серия                       КАК Серия,
	|	ТаблицаИзменений.ТипСборки                   КАК ТипСборки,
	|	СУММА(ТаблицаИзменений.ЗаказаноИзменение)    КАК ЗаказаноИзменение,
	|	СУММА(ТаблицаИзменений.КОформлениюИзменение) КАК КОформлениюИзменение
	|ПОМЕСТИТЬ ДвиженияЗаказыНаСборкуИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.ЗаказНаСборку       КАК ЗаказНаСборку,
	|		Таблица.Номенклатура        КАК Номенклатура,
	|		Таблица.Характеристика      КАК Характеристика,
	|		Таблица.Серия               КАК Серия,
	|		Таблица.ТипСборки           КАК ТипСборки,
	|		Таблица.ЗаказаноПередЗаписью    КАК ЗаказаноИзменение,
	|		Таблица.КОформлениюПередЗаписью КАК КОформлениюИзменение
	|	ИЗ
	|		ДвиженияЗаказыНаСборкуПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.ЗаказНаСборку      КАК ЗаказНаСборку,
	|		Таблица.Номенклатура       КАК Номенклатура,
	|		Таблица.Характеристика     КАК Характеристика,
	|		Таблица.Серия              КАК Серия,
	|		Таблица.ТипСборки          КАК ТипСборки,
	|		ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|				-Таблица.Заказано
	|			ИНАЧЕ
	|				Таблица.Заказано
	|		КОНЕЦ                  КАК ЗаказаноПередЗаписью,
	|		ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|				-Таблица.КОформлению
	|			ИНАЧЕ
	|				Таблица.КОформлению
	|		КОНЕЦ                      КАК КОформлениюИзменение
	|	ИЗ
	|		РегистрНакопления.ЗаказыНаСборку КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.ЗаказНаСборку,
	|	ТаблицаИзменений.Номенклатура,
	|	ТаблицаИзменений.Характеристика,
	|	ТаблицаИзменений.Серия,
	|	ТаблицаИзменений.ТипСборки
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.КОформлениюИзменение) <> 0
	|	ИЛИ СУММА(ТаблицаИзменений.ЗаказаноИзменение) <> 0
	|ИНДЕКСИРОВАТЬ ПО
	|	ТаблицаИзменений.ЗаказНаСборку,
	|	ТаблицаИзменений.Номенклатура,
	|	ТаблицаИзменений.Характеристика,
	|	ТаблицаИзменений.Серия,
	|	ТаблицаИзменений.ТипСборки
	|;
	|УНИЧТОЖИТЬ ДвиженияЗаказыНаСборкуПередЗаписью
	|";
	
	Выборка = Запрос.ВыполнитьПакет()[0].Выбрать();
	ЕстьИзменения = Выборка.Следующий() И Выборка.Количество > 0;
	ПроведениеДокументов.ЗарегистрироватьТаблицуКонтроля(ДополнительныеСвойства,
		"ДвиженияЗаказыНаСборкуИзменение", ЕстьИзменения);
	
	Если ЕстьИзменения
		И ПолучитьФункциональнуюОпцию("ИспользоватьДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров") Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров",
			Константы.ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров.Получить());
		Запрос.УстановитьПараметр("МерныеТипыЕдиницИзмерений",
			Справочники.УпаковкиЕдиницыИзмерения.МерныеТипыЕдиницИзмерений());
		Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
		
		ТекстЗапроса = "
		|ВЫБРАТЬ
		|	Таблица.ЗаказНаСборку,
		|	Таблица.Номенклатура,
		|	Таблица.Характеристика,
		|	Таблица.Серия,
		|	Таблица.ТипСборки
		|ПОМЕСТИТЬ ДвиженияЗаказыНаСборкуИзменениеМерныеТовары
		|ИЗ
		|	ДвиженияЗаказыНаСборкуИзменение КАК Таблица
		|ГДЕ 
		|	Таблица.Номенклатура.ЕдиницаИзмерения.ТипИзмеряемойВеличины В (&МерныеТипыЕдиницИзмерений)
		|СГРУППИРОВАТЬ ПО
		|	Таблица.ЗаказНаСборку,
		|	Таблица.Номенклатура,
		|	Таблица.Характеристика,
		|	Таблица.Серия,
		|	Таблица.ТипСборки
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|";
		
		// Основная таблица
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	ЗаказыНаСборку.ВидДвижения    КАК ВидДвижения,
		|	ЗаказыНаСборку.ЗаказНаСборку  КАК ЗаказНаСборку,
		|	ЗаказыНаСборку.Номенклатура   КАК Номенклатура,
		|	ЗаказыНаСборку.Характеристика КАК Характеристика,
		|	ЗаказыНаСборку.Серия          КАК Серия,
		|	ЗаказыНаСборку.ТипСборки      КАК ТипСборки,
		|	ЗаказыНаСборку.КОформлению    КАК КОформлению
		|ПОМЕСТИТЬ ВТЗаказыНаСборку
		|ИЗ
		|	РегистрНакопления.ЗаказыНаСборку КАК ЗаказыНаСборку
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		ДвиженияЗаказыНаСборкуИзменение КАК Изменения
		|		ПО ЗаказыНаСборку.ЗаказНаСборку     = Изменения.ЗаказНаСборку
		|			И ЗаказыНаСборку.Номенклатура   = Изменения.Номенклатура
		|			И ЗаказыНаСборку.Характеристика = Изменения.Характеристика
		|			И ЗаказыНаСборку.Серия          = Изменения.Серия
		|			И ЗаказыНаСборку.ТипСборки      = Изменения.ТипСборки
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|";
		
		// Допустимые отклонения
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	ЗаказыНаСборку.ЗаказНаСборку  КАК ЗаказНаСборку,
		|	ЗаказыНаСборку.Номенклатура   КАК Номенклатура,
		|	ЗаказыНаСборку.Характеристика КАК Характеристика,
		|	ЗаказыНаСборку.Серия          КАК Серия,
		|	ЗаказыНаСборку.ТипСборки      КАК ТипСборки,
		|	СУММА(ЗаказыНаСборку.КОформлению
		|		* (&ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров / 100)) КАК ДопустимоеОтклонение
		|ПОМЕСТИТЬ ВТДопустимыеОтклоненияЗаказыНаСборку
		|ИЗ
		|	ВТЗаказыНаСборку КАК ЗаказыНаСборку
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		ДвиженияЗаказыНаСборкуИзменениеМерныеТовары КАК Изменения
		|		ПО ЗаказыНаСборку.ЗаказНаСборку     = Изменения.ЗаказНаСборку
		|			И ЗаказыНаСборку.Номенклатура   = Изменения.Номенклатура
		|			И ЗаказыНаСборку.Характеристика = Изменения.Характеристика
		|			И ЗаказыНаСборку.Серия          = Изменения.Серия
		|			И ЗаказыНаСборку.ТипСборки      = Изменения.ТипСборки
		|ГДЕ
		|	ЗаказыНаСборку.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|СГРУППИРОВАТЬ ПО
		|	ЗаказыНаСборку.ЗаказНаСборку,
		|	ЗаказыНаСборку.Номенклатура,
		|	ЗаказыНаСборку.Характеристика,
		|	ЗаказыНаСборку.Серия,
		|	ЗаказыНаСборку.ТипСборки
		|ИНДЕКСИРОВАТЬ ПО
		|	ЗаказНаСборку,
		|	Номенклатура,
		|	Характеристика,
		|	Серия,
		|	ТипСборки
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|";
		
		//Остатки
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	ЗаказыНаСборку.ЗаказНаСборку      КАК ЗаказНаСборку,
		|	ЗаказыНаСборку.Номенклатура       КАК Номенклатура,
		|	ЗаказыНаСборку.Характеристика     КАК Характеристика,
		|	ЗаказыНаСборку.Серия              КАК Серия,
		|	ЗаказыНаСборку.ТипСборки          КАК ТипСборки,
		|	СУММА(ВЫБОР КОГДА ЗаказыНаСборку.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|			ЗаказыНаСборку.КОформлению
		|		ИНАЧЕ
		|			-ЗаказыНаСборку.КОформлению
		|	КОНЕЦ)                            КАК КОформлениюОстаток
		|ПОМЕСТИТЬ ВТЗаказыНаСборкуОстатки
		|ИЗ
		|	ВТЗаказыНаСборку КАК ЗаказыНаСборку
		|СГРУППИРОВАТЬ ПО
		|	ЗаказыНаСборку.ЗаказНаСборку,
		|	ЗаказыНаСборку.Номенклатура,
		|	ЗаказыНаСборку.Характеристика,
		|	ЗаказыНаСборку.Серия,
		|	ЗаказыНаСборку.ТипСборки
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|";
		
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗаказыОстатки.ЗаказНаСборку КАК ЗаказНаСборку
		|ИЗ
		|	ВТЗаказыНаСборкуОстатки КАК ЗаказыОстатки
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		ВТДопустимыеОтклоненияЗаказыНаСборку КАК ДопустимыеОтклонения
		|		ПО
		|			ЗаказыОстатки.ЗаказНаСборку    = ДопустимыеОтклонения.ЗаказНаСборку
		|			И ЗаказыОстатки.Номенклатура   = ДопустимыеОтклонения.Номенклатура
		|			И ЗаказыОстатки.Характеристика = ДопустимыеОтклонения.Характеристика
		|			И ЗаказыОстатки.Серия          = ДопустимыеОтклонения.Серия
		|			И ЗаказыОстатки.ТипСборки      = ДопустимыеОтклонения.ТипСборки
		|ГДЕ
		|	ЗаказыОстатки.КОформлениюОстаток <= ДопустимыеОтклонения.ДопустимоеОтклонение
		|	И ЗаказыОстатки.КОформлениюОстаток >= -ДопустимыеОтклонения.ДопустимоеОтклонение
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|";
		
		Запрос.Текст = ТекстЗапроса;
		
		ВыборкаЗаказ = Запрос.Выполнить().Выбрать();
		
		Пока ВыборкаЗаказ.Следующий() Цикл
			
			РегистрыСведений.ОчередьЗаказовККорректировкеСтрокМерныхТоваров.ДобавитьЗаказВОчередь(
				ВыборкаЗаказ.ЗаказНаСборку);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли