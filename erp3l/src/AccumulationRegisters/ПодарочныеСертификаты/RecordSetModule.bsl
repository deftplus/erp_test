#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

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
	|	Таблица.Период КАК Период,
	|	Таблица.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.Сумма
	|		ИНАЧЕ -Таблица.Сумма
	|	КОНЕЦ КАК СуммаПередЗаписью
	|ПОМЕСТИТЬ 
	|	ПодарочныеСертификатыПередЗаписью
	|ИЗ
	|	РегистрНакопления.ПодарочныеСертификаты КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И НЕ &ЭтоНовый";
	
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
	|	ТаблицаИзменений.Период КАК Период,
	|	ТаблицаИзменений.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	СУММА(ТаблицаИзменений.СуммаИзменение) КАК СуммаИзменение
	|ПОМЕСТИТЬ ТаблицаИзмененийПодарочныеСертификаты
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Период КАК Период,
	|		Таблица.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|		Таблица.СуммаПередЗаписью КАК СуммаИзменение
	|	ИЗ
	|		ПодарочныеСертификатыПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.Период КАК Период,
	|		Таблица.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|		ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|				-Таблица.Сумма
	|			ИНАЧЕ
	|				Таблица.Сумма
	|		КОНЕЦ КАК СуммаИзменение
	|	ИЗ
	|		РегистрНакопления.ПодарочныеСертификаты КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Период,
	|	ТаблицаИзменений.ПодарочныйСертификат
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.СуммаИзменение) > 0
	|;
	|УНИЧТОЖИТЬ ПодарочныеСертификатыПередЗаписью
	|";
	
	Запрос.ВыполнитьПакет();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
