#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Склад)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

// Вычисляет принятое количество, согласно данным регистра накопления "Товары к поступлению".
//
// Параметры:
//  Отбор - ТаблицаЗначений - таблица товаров по которым необходимо получить принятое количество
//  Корректировка - ТаблицаЗначений	 - таблица товаров сторно
//  ТолькоОрдерныеСклады - Булево - указывает на расчет принятого количества только на ордерных складах.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - таблица принятых товаров.
//
Функция ТаблицаОформлено(Отбор, Корректировка, ТолькоОрдерныеСклады = Ложь) Экспорт

	МетаданныеРегистра = Метаданные.РегистрыНакопления.ТоварыКПоступлению;
	ТаблицаОтбора = Новый ТаблицаЗначений;
	ТаблицаОтбора.Колонки.Добавить("Номенклатура",   Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаОтбора.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаОтбора.Колонки.Добавить("Склад",          Новый ОписаниеТипов("СправочникСсылка.Склады"));
	ТаблицаОтбора.Колонки.Добавить("Назначение",     Новый ОписаниеТипов("СправочникСсылка.Назначения"));
	ТаблицаОтбора.Колонки.Добавить("Ссылка",         МетаданныеРегистра.Измерения.ДокументПоступления.Тип);
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(Отбор, ТаблицаОтбора);

	Запрос = Новый Запрос();

	// Запрос оформленного количества по заказу.
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Таблица.Номенклатура КАК Номенклатура,
		|	Таблица.Характеристика КАК Характеристика,
		|	Таблица.Назначение КАК Назначение,
		|	Таблица.Склад КАК Склад,
		|	Таблица.Ссылка КАК ДокументПоступления
		|ПОМЕСТИТЬ ВТОтбор
		|ИЗ
		|	&Отбор КАК Таблица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Таблица.Номенклатура КАК Номенклатура,
		|	Таблица.Характеристика КАК Характеристика,
		|	Таблица.Назначение КАК Назначение,
		|	Таблица.Склад КАК Склад,
		|	Таблица.КПоступлению КАК Количество
		|ПОМЕСТИТЬ ВТКорректировка
		|ИЗ
		|	&Корректировка КАК Таблица
		|ГДЕ
		|	Таблица.КПоступлению <> 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Набор.Номенклатура КАК Номенклатура,
		|	Набор.Характеристика КАК Характеристика,
		|	Набор.Назначение КАК Назначение,
		|	Набор.Склад КАК Склад,
		|	СУММА(Набор.Количество) КАК Количество
		|ИЗ
		|	(ВЫБРАТЬ
		|		Таблица.Номенклатура КАК Номенклатура,
		|		Таблица.Характеристика КАК Характеристика,
		|		Таблица.Назначение КАК Назначение,
		|		Таблица.Склад КАК Склад,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|				ТОГДА Таблица.КОформлениюОрдеров - Таблица.Принимается
		|			ИНАЧЕ Таблица.Принимается
		|		КОНЕЦ КАК Количество
		|	ИЗ
		|		РегистрНакопления.ТоварыКПоступлению КАК Таблица
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОтбор КАК Фильтр
		|			ПО Таблица.Номенклатура = Фильтр.Номенклатура
		|				И Таблица.Характеристика = Фильтр.Характеристика
		|				И Таблица.Склад = Фильтр.Склад
		|				И Таблица.Назначение = Фильтр.Назначение
		|				И Таблица.ДокументПоступления = Фильтр.ДокументПоступления
		|	ГДЕ
		|		Таблица.Активность
		|		И (Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|					И Таблица.КОформлениюОрдеров <> 0
		|				ИЛИ Таблица.Принимается <> 0)
		|		И &ВсеСклады
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		Таблица.Номенклатура,
		|		Таблица.Характеристика,
		|		Таблица.Назначение,
		|		Таблица.Склад,
		|		-Таблица.Количество
		|	ИЗ
		|		ВТКорректировка КАК Таблица
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОтбор КАК Фильтр
		|			ПО Таблица.Номенклатура = Фильтр.Номенклатура
		|				И Таблица.Характеристика = Фильтр.Характеристика
		|				И Таблица.Склад = Фильтр.Склад
		|				И Таблица.Назначение = Фильтр.Назначение) КАК Набор
		|
		|СГРУППИРОВАТЬ ПО
		|	Набор.Номенклатура,
		|	Набор.Характеристика,
		|	Набор.Назначение,
		|	Набор.Склад
		|
		|ИМЕЮЩИЕ
		|	СУММА(Набор.Количество) > 0";
	
	Если ТолькоОрдерныеСклады Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ВсеСклады",
			"Таблица.Склад.ИспользоватьОрдернуюСхемуПриПоступлении
			|И Таблица.Склад.ДатаНачалаОрдернойСхемыПриПоступлении <= &ТекущаяДата");
		Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	Иначе
		Запрос.УстановитьПараметр("ВсеСклады", Истина);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Корректировка", Корректировка);
	Запрос.УстановитьПараметр("Отбор",         ТаблицаОтбора);
	
	УстановитьПривилегированныйРежим(Истина);
	Таблица = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	Таблица.Индексы.Добавить("Номенклатура, Характеристика, Склад, Назначение");
	
	Возврат Таблица;
	
КонецФункции

Функция ТекстЗапросаОсталосьОформитьПоОрдерам(ДополнитьСериямиИзРегистратора = Ложь, ОтборПоИзмерениям = Неопределено) Экспорт
	
	Если ДополнитьСериямиИзРегистратора Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Таблица.Регистратор         КАК Регистратор,
		|	Таблица.ВидДвижения         КАК ВидДвижения,
		|	Таблица.ДокументПоступления КАК Распоряжение,
		|	Таблица.Номенклатура        КАК Номенклатура,
		|	Таблица.Характеристика      КАК Характеристика,
		|	Таблица.Назначение          КАК Назначение,
		|	Таблица.Склад               КАК Склад,
		|	Таблица.Серия               КАК Серия,
		|	СУММА(Таблица.КОформлениюПоступленийПоОрдерам)  КАК Количество
		|ПОМЕСТИТЬ ВтДанныеРегистра
		|ИЗ
		|	РегистрНакопления.ТоварыКПоступлению КАК Таблица
		|ГДЕ
		|	Таблица.ДокументПоступления В(&Распоряжения)
		|	И НЕ Таблица.Регистратор В (&Регистратор)
		|	И Таблица.Активность
		|	
		|СГРУППИРОВАТЬ ПО
		|	Таблица.Регистратор,
		|	Таблица.ВидДвижения,
		|	Таблица.ДокументПоступления,
		|	Таблица.Характеристика,
		|	Таблица.Серия,
		|	Таблица.Назначение,
		|	Таблица.Склад,
		|	Таблица.Номенклатура
		|
		|ИМЕЮЩИЕ
		|	СУММА(Таблица.КОформлениюПоступленийПоОрдерам) > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Таблица.Ссылка КАК Регистратор,
		|	Таблица.Номенклатура,
		|	Таблица.Характеристика,
		|	Таблица.Назначение,
		|	Таблица.Серия,
		|	Сумма(Таблица.Количество) КАК Количество
		|ПОМЕСТИТЬ ВтДанныеПриходногоОрдера
		|ИЗ Документ.ПриходныйОрдерНаТовары.Товары КАК Таблица
		|ГДЕ
		|	Таблица.Ссылка В (Выбрать Т.Регистратор ИЗ ВтДанныеРегистра КАК Т)
		|СГРУППИРОВАТЬ ПО
		|	Таблица.Ссылка,
		|	Таблица.Номенклатура,
		|	Таблица.Характеристика,
		|	Таблица.Назначение,
		|	Таблица.Серия
		|;
		|ВЫБРАТЬ
		|	Таблица.Распоряжение,
		|	Таблица.Номенклатура,
		|	Таблица.Характеристика,
		|	Таблица.Назначение,
		|	Таблица.Склад,
		|	ВЫБОР КОГДА Таблица.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) ТОГДА
		|		ЕстьNull(ДанныеДокументаПоступления.Серия, ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка))
		|	ИНАЧЕ
		|		Таблица.Серия
		|	КОНЕЦ КАК Серия,
		|	Сумма(ВЫБОР КОГДА Таблица.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) 
		|			И ДанныеДокументаПоступления.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) ТОГДА
		|		ДанныеДокументаПоступления.Количество
		|	ИНАЧЕ
		|		Таблица.Количество
		|	КОНЕЦ) КАК Количество
		|ПОМЕСТИТЬ ВтПринято
		|ИЗ
		|	ВтДанныеРегистра КАК Таблица
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтДанныеПриходногоОрдера КАК ДанныеДокументаПоступления
		|		ПО Таблица.Регистратор = ДанныеДокументаПоступления.Регистратор
		|		И Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|		И Таблица.Номенклатура = ДанныеДокументаПоступления.Номенклатура
		|		И Таблица.Характеристика = ДанныеДокументаПоступления.Характеристика
		|		И Таблица.Назначение = ДанныеДокументаПоступления.Назначение
		|		И (Таблица.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|			ИЛИ Таблица.Серия = ДанныеДокументаПоступления.Серия)
		|ГДЕ
		|	НЕ ДанныеДокументаПоступления.Регистратор ЕСТЬ NULL
		|		
		|СГРУППИРОВАТЬ ПО
		|	Таблица.Распоряжение,
		|	Таблица.Номенклатура,
		|	Таблица.Характеристика,
		|	Таблица.Назначение,
		|	ВЫБОР КОГДА Таблица.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) ТОГДА
		|		ЕстьNull(ДанныеДокументаПоступления.Серия, ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка))
		|	ИНАЧЕ
		|		Таблица.Серия
		|	КОНЕЦ,
		|	Таблица.Склад
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Таблица.Ссылка КАК Регистратор,
		|	Таблица.Номенклатура,
		|	Таблица.Характеристика,
		|	Таблица.Назначение,
		|	Таблица.Серия,
		|	Сумма(Таблица.Количество) КАК Количество
		|ПОМЕСТИТЬ ВтДанныеДокументаПоступления
		|ИЗ Документ.ПеремещениеТоваров.Товары КАК Таблица
		|ГДЕ
		|	Таблица.Ссылка В (Выбрать Т.Регистратор ИЗ ВтДанныеРегистра КАК Т)
		|	И Таблица.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|СГРУППИРОВАТЬ ПО
		|	Таблица.Ссылка,
		|	Таблица.Номенклатура,
		|	Таблица.Характеристика,
		|	Таблица.Назначение,
		|	Таблица.Серия
		|;
		|ВЫБРАТЬ
		|	Таблица.Распоряжение,
		|	Таблица.Номенклатура,
		|	Таблица.Характеристика,
		|	Таблица.Назначение,
		|	Таблица.Склад,
		|	ВЫБОР КОГДА Таблица.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) ТОГДА
		|		ДанныеДокументаПоступления.Серия
		|	ИНАЧЕ
		|		Таблица.Серия
		|	КОНЕЦ КАК Серия,
		|	Сумма(ВЫБОР КОГДА Таблица.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) ТОГДА
		|		ДанныеДокументаПоступления.Количество
		|	ИНАЧЕ
		|		Таблица.Количество
		|	КОНЕЦ) КАК Количество
		|ПОМЕСТИТЬ ВтОформлено
		|ИЗ
		|	ВтДанныеРегистра КАК Таблица
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтДанныеДокументаПоступления КАК ДанныеДокументаПоступления
		|		ПО Таблица.Регистратор = ДанныеДокументаПоступления.Регистратор
		|		И Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|		И Таблица.Номенклатура = ДанныеДокументаПоступления.Номенклатура
		|		И Таблица.Характеристика = ДанныеДокументаПоступления.Характеристика
		|		И Таблица.Назначение = ДанныеДокументаПоступления.Назначение
		|		И (Таблица.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|			ИЛИ Таблица.Серия = ДанныеДокументаПоступления.Серия)
		|ГДЕ
		|	НЕ ДанныеДокументаПоступления.Регистратор ЕСТЬ NULL
		|		
		|
		|СГРУППИРОВАТЬ ПО
		|	Таблица.Распоряжение,
		|	Таблица.Номенклатура,
		|	Таблица.Характеристика,
		|	Таблица.Назначение,
		|	ВЫБОР КОГДА Таблица.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) ТОГДА
		|		ДанныеДокументаПоступления.Серия
		|	ИНАЧЕ
		|		Таблица.Серия
		|	КОНЕЦ,
		|	Таблица.Склад
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Набор.Распоряжение         КАК Распоряжение,
		|	Набор.Номенклатура         КАК Номенклатура,
		|	Набор.Характеристика       КАК Характеристика,
		|	Набор.Назначение           КАК Назначение,
		|	Набор.Склад                КАК Склад,
		|	Набор.Серия                КАК Серия,
		|	СУММА(Набор.Количество)    КАК Количество
		|ИЗ
		|	(
		|	ВЫБРАТЬ
		|		Таблица.Распоряжение         КАК Распоряжение,
		|		Таблица.Номенклатура         КАК Номенклатура,
		|		Таблица.Характеристика       КАК Характеристика,
		|		Таблица.Назначение           КАК Назначение,
		|		Таблица.Склад                КАК Склад,
		|		Таблица.Серия                КАК Серия,
		|		Таблица.Количество           КАК Количество
		|	ИЗ
		|		ВтПринято КАК Таблица
		|		
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		Таблица.Распоряжение         КАК Распоряжение,
		|		Таблица.Номенклатура         КАК Номенклатура,
		|		Таблица.Характеристика       КАК Характеристика,
		|		Таблица.Назначение           КАК Назначение,
		|		Таблица.Склад                КАК Склад,
		|		Таблица.Серия                КАК Серия,
		|		-Таблица.Количество          КАК Количество
		|	ИЗ
		|		ВтОформлено КАК Таблица
		|		
		|	) КАК Набор
		|
		|СГРУППИРОВАТЬ ПО
		|	Распоряжение,
		|	Номенклатура,
		|	Характеристика,
		|	Назначение,
		|	Склад,
		|	Серия";
		
	Иначе
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Таблица.ДокументПоступления КАК Распоряжение,
		|	Таблица.Номенклатура        КАК Номенклатура,
		|	Таблица.Характеристика      КАК Характеристика,
		|	Таблица.Назначение          КАК Назначение,
		|	Таблица.Склад               КАК Склад,
		|	Таблица.Серия               КАК Серия,
		|	Таблица.КОформлениюПоступленийПоОрдерамРасход   КАК КОформлениюРасход,
		|	Таблица.КОформлениюПоступленийПоОрдерамПриход   КАК КОформлениюПриход
		|ПОМЕСТИТЬ ВтДанныеРегистра
		|ИЗ
		|	РегистрНакопления.ТоварыКПоступлению.Обороты(, , , ДокументПоступления В (&Распоряжения)
		|	И &Отбор1
		|	)КАК Таблица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Набор.Распоряжение         КАК Распоряжение,
		|	Набор.Номенклатура         КАК Номенклатура,
		|	Набор.Характеристика       КАК Характеристика,
		|	Набор.Назначение           КАК Назначение,
		|	Набор.Склад                КАК Склад,
		|	Набор.Серия                КАК Серия,
		|	СУММА(Набор.Количество)    КАК Количество
		|ИЗ
		|	(
		|	ВЫБРАТЬ
		|		Таблица.Распоряжение         КАК Распоряжение,
		|		Таблица.Номенклатура         КАК Номенклатура,
		|		Таблица.Характеристика       КАК Характеристика,
		|		Таблица.Назначение           КАК Назначение,
		|		Таблица.Склад                КАК Склад,
		|		Таблица.Серия                КАК Серия,
		|		Таблица.КОформлениюПриход    КАК Количество
		|	ИЗ
		|		ВтДанныеРегистра КАК Таблица
		|	ГДЕ
		|		Таблица.КОформлениюПриход > 0
		|		
		|	ОБЪЕДИНИТЬ ВСЕ
		|		
		|	ВЫБРАТЬ
		|		Таблица.Распоряжение         КАК Распоряжение,
		|		Таблица.Номенклатура         КАК Номенклатура,
		|		Таблица.Характеристика       КАК Характеристика,
		|		Таблица.Назначение           КАК Назначение,
		|		Таблица.Склад                КАК Склад,
		|		Таблица.Серия                КАК Серия,
		|		-Таблица.КОформлениюРасход   КАК Количество
		|	ИЗ
		|		ВтДанныеРегистра КАК Таблица
		|	ГДЕ
		|		Таблица.КОформлениюРасход > 0
		|		
		|	ОБЪЕДИНИТЬ ВСЕ
		|		
		|	ВЫБРАТЬ
		|		Таблица.ДокументПоступления  КАК Распоряжение,
		|		Таблица.Номенклатура         КАК Номенклатура,
		|		Таблица.Характеристика       КАК Характеристика,
		|		Таблица.Назначение           КАК Назначение,
		|		Таблица.Склад                КАК Склад,
		|		Таблица.Серия                КАК Серия,
		|		СУММА(Таблица.КОформлениюПоступленийПоОрдерам) КАК Количество
		|	ИЗ
		|		РегистрНакопления.ТоварыКПоступлению КАК Таблица
		|	ГДЕ
		|		Таблица.Регистратор В(&Регистратор)
		|		И Таблица.ДокументПоступления В(&Распоряжения)
		|		И Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|		И Таблица.КОформлениюПоступленийПоОрдерам > 0
		|		И Таблица.Активность
		|		И &Отбор1
		|
		|	СГРУППИРОВАТЬ ПО
		|		Таблица.ДокументПоступления,
		|		Таблица.Номенклатура,
		|		Таблица.Характеристика,
		|		Таблица.Назначение,
		|		Таблица.Серия,
		|		Таблица.Склад
		|	) КАК Набор
		|
		|СГРУППИРОВАТЬ ПО
		|	Распоряжение,
		|	Номенклатура,
		|	Характеристика,
		|	Назначение,
		|	Склад,
		|	Серия";
		
	КонецЕсли;
	
	ТекстОтбора = "";
	Если ЗначениеЗаполнено(ОтборПоИзмерениям) Тогда
		
		Для Каждого КлючЗначение Из ОтборПоИзмерениям Цикл
			
			ЛевоеЗначение  		= КлючЗначение.Ключ;
			ВидСравненияЗапроса = КлючЗначение.Значение.ВидСравнения;   
			ПравоеЗначение 		= КлючЗначение.Значение.ПравоеЗначение;
			
			ТекстОтбора = ТекстОтбора + " И "
						+ "(" + ЛевоеЗначение + ") " + ВидСравненияЗапроса + " (" + ПравоеЗначение + ")";
			
		КонецЦикла;
		
	КонецЕсли;

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &Отбор1", ТекстОтбора);
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Текст запроса получает остаток по ресурсу КОформлениюПоступленийПоОрдерам
//
// Параметры:
//  ОтборПоИзмерениям - Структура - Ключ - имя измерения, Значение - имя параметра в запросе, например:
//  
// Возвращаемое значение:
//  Строка - текст запроса
//
Функция ТекстЗапросаОформленоПоОрдерам(ОтборПоИзмерениям = Неопределено) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Таблица.ДокументПоступления КАК Распоряжение,
	|	Таблица.Номенклатура        КАК Номенклатура,
	|	Таблица.Характеристика      КАК Характеристика,
	|	Таблица.Назначение          КАК Назначение,
	|	Таблица.Склад               КАК Склад,
	|	Таблица.Серия               КАК Серия,
	|	Сумма(Таблица.КОформлениюПоступленийПоОрдерамПриход) КАК Количество
	|ИЗ
	|	РегистрНакопления.ТоварыКПоступлению.Обороты(, , , ДокументПоступления В (&Распоряжения)
	|	И &Отбор1
	|	)КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.ДокументПоступления,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	Таблица.Назначение,
	|	Таблица.Склад,
	|	Таблица.Серия
	|";
	
	ТекстОтбора = "";
	Если ЗначениеЗаполнено(ОтборПоИзмерениям) Тогда
		
		Для Каждого КлючЗначение Из ОтборПоИзмерениям Цикл
			
			ЛевоеЗначение  		= КлючЗначение.Ключ;
			ВидСравненияЗапроса = КлючЗначение.Значение.ВидСравнения;   
			ПравоеЗначение 		= КлючЗначение.Значение.ПравоеЗначение;
			
			ТекстОтбора = ТекстОтбора + " И "
						+ "(" + ЛевоеЗначение + ") " + ВидСравненияЗапроса + " (" + ПравоеЗначение + ")";
			
		КонецЦикла;
		
	КонецЕсли;

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &Отбор1", ТекстОтбора);
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Текст запроса получает остаток по ресурсу КОформлениюНакладныхПоРаспоряжению
// Остаток дополняется движениями, сделанными накладной заданной в параметре Регистратор
//
// Параметры:
//  ИмяВременнойТаблицы	 - Строка - Поместить результат во временную таблицу с заданным именем. 
//  ОтборПоИзмерениям	 - Структура - Ключ - имя измерения, Значение - имя параметра в запросе, например:
//  									Новый Структура("Номенклатура", "Товар") будет преобразовано в тексте запроса в:
//  									Номенклатура В(&Товар)
//  Выражение			 - Строка - Условие для секции ИМЕЮЩИЕ по ресурсам.
//  								Например, строка вида "КОформлению <> 0" будет преобразована в тексте запроса в:
//  								СУММА(Набор.КОформлению) <> 0
// 
// Возвращаемое значение:
//  Строка - текст запроса
//
Функция ТекстЗапросаОстатки(ИмяВременнойТаблицы = "", ОтборПоИзмерениям = Неопределено, Выражение = "") Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Набор.ДокументПоступления  КАК Распоряжение,
	|	Набор.Номенклатура         КАК Номенклатура,
	|	Набор.Характеристика       КАК Характеристика,
	|	Набор.Назначение           КАК Назначение,
	|	Набор.Склад                КАК Склад,
	|	Набор.Серия                КАК Серия,
	|	СУММА(Набор.КОформлению)   КАК КОформлению
	|,&ПОМЕСТИТЬ
	|ИЗ(
	|	ВЫБРАТЬ
	|		Таблица.ДокументПоступления                КАК ДокументПоступления,
	|		Таблица.Номенклатура                       КАК Номенклатура,
	|		Таблица.Характеристика                     КАК Характеристика,
	|		Таблица.Назначение                         КАК Назначение,
	|		Таблица.Склад                              КАК Склад,
	|		Таблица.Серия                              КАК Серия,
	|		Таблица.КОформлениюНакладныхПоРаспоряжениюОстаток КАК КОформлению
	|	ИЗ
	|		РегистрНакопления.ТоварыКПоступлению.Остатки(, 
	|&ОтборПоИзмерениямРегистр
	|			) КАК Таблица
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Таблица.ДокументПоступления                КАК ДокументПоступления,
	|		Таблица.Номенклатура                       КАК Номенклатура,
	|		Таблица.Характеристика                     КАК Характеристика,
	|		Таблица.Назначение                         КАК Назначение,
	|		Таблица.Склад                              КАК Склад,
	|		Таблица.Серия                              КАК Серия,
	|		Таблица.КОформлениюНакладныхПоРаспоряжению КАК КОформлению
	|	ИЗ
	|		РегистрНакопления.ТоварыКПоступлению КАК Таблица
	|	ГДЕ
	|		Активность
	|		И Регистратор = &Регистратор
	|		И ВидДвижения = ЗНАЧЕНИЕ(ВидДВиженияНакопления.Расход)
	|		И &ОтборПоИзмерениямСторно
	|	) КАК Набор
	|
	|СГРУППИРОВАТЬ ПО
	|	ДокументПоступления,
	|	Номенклатура,
	|	Характеристика,
	|	Назначение,
	|	Склад,
	|	Серия
	|
	|,&ИМЕЮЩИЕ";
	
	Если Не ПустаяСтрока(ИмяВременнойТаблицы) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ",&ПОМЕСТИТЬ", "ПОМЕСТИТЬ " + ИмяВременнойТаблицы);
		ТекстЗапроса = ТекстЗапроса + 
		"
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Распоряжение,
		|	Номенклатура,
		|	Характеристика,
		|	Назначение,
		|	Склад";
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ",&ПОМЕСТИТЬ", "");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборПоИзмерениям) Тогда
		
		ТекстОтбораПоИзмерениям = "";
		
		Для Каждого КлючЗначение Из ОтборПоИзмерениям Цикл
			
			ТекстОтбораПоИзмерениям = 
				ТекстОтбораПоИзмерениям
				+ ?(ПустаяСтрока(ТекстОтбораПоИзмерениям), "", " И ")
				+ КлючЗначение.Ключ
				+ " В(&"
				+ КлючЗначение.Значение
				+ ")";
				
		КонецЦикла;
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОтборПоИзмерениямРегистр", ТекстОтбораПоИзмерениям);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ОтборПоИзмерениямСторно", Символы.ПС + "И " + ТекстОтбораПоИзмерениям);
	
	Иначе
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОтборПоИзмерениямРегистр", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ОтборПоИзмерениямСторно", "");
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(Выражение) Тогда
		
		Если СтрНайти(Выражение, "КОформлению") <> 0 Тогда
			Выражение = СтрЗаменить(Выражение, "КОформлению", "СУММА(Набор.КОформлению)");
		КонецЕсли;
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ",&ИМЕЮЩИЕ", "ИМЕЮЩИЕ " + Выражение);
		
	Иначе
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ",&ИМЕЮЩИЕ", "");
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.ТоварыКПоступлению.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.7.206";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("b4cf2e91-7b19-4595-bef6-df6012ea8a4a");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.ТоварыКПоступлению.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновляет движения документов информационной базы по регистру накопления ""Товары к поступлению"".
	|До завершения обработчика работа с документами не рекомендуется, т.к. информация в регистре некорректна.';
	|en = 'Updates infobase document records in the ""Goods for receipt"" accumulation register.
	|Until the handler is finished, it is not recommended that you work with the documents as information in the register is incorrect.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.АктОРасхожденияхПослеПеремещения.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.АктОРасхожденияхПослеПриемки.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ВозвратТоваровОтКлиента.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ЗаказНаПеремещение.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ЗаказНаСборку.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ЗаказПоставщику.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ЗаявкаНаВозвратТоваровОтКлиента.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПеремещениеТоваров.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПоступлениеТоваровНаСклад.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПоступлениеТоваровОтХранителя.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПриемкаТоваровНаХранение.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПриобретениеТоваровУслуг.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПриходныйОрдерНаТовары.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПрочееОприходованиеТоваров.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.СборкаТоваров.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.ТоварыКПоступлению.ПолноеИмя());
	//++ НЕ УТ
	//++ Локализация
	Читаемые.Добавить(Метаданные.Документы.ВозвратМатериаловИзПроизводства.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ВыпускПродукции.ПолноеИмя());
	//-- Локализация
	//-- НЕ УТ
	//++ НЕ УТКА
	//++ Локализация
	Читаемые.Добавить(Метаданные.Документы.МаршрутныйЛистПроизводства.ПолноеИмя());
	//-- Локализация
	//-- НЕ УТКА
	//++ НЕ УТ
	Читаемые.Добавить(Метаданные.Документы.ВозвратСырьяОтПереработчика.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ДвижениеПродукцииИМатериалов.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ЗаказМатериаловВПроизводство.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ЗаказПереработчику.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПоступлениеОтПереработчика.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПроизводствоБезЗаказа.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.РаспределениеВозвратныхОтходов.ПолноеИмя());
	//++ НЕ УТКА
	Читаемые.Добавить(Метаданные.Документы.ЗаказДавальца.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПоступлениеСырьяОтДавальца.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ЭтапПроизводства2_2.ПолноеИмя());
	//-- НЕ УТКА
	//-- НЕ УТ
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.ТоварыКПоступлению.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.АктОРасхожденияхПослеПриемки.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ВозвратТоваровОтКлиента.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ВозвратТоваровОтКлиента.ОбработатьДополнительныеРеквизитыДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "До";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ВозвратТоваровОтКлиента.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаказНаПеремещение.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаказНаСборку.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаказПоставщику.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаказПоставщику.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаявкаНаВозвратТоваровОтКлиента.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаявкаНаВозвратТоваровОтКлиента.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ПеремещениеТоваров.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ПоступлениеТоваровНаСклад.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ПоступлениеТоваровОтХранителя.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ПриемкаТоваровНаХранение.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ПриобретениеТоваровУслуг.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ПриобретениеТоваровУслуг.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ПрочееОприходованиеТоваров.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.СборкаТоваров.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыНакопления.ТоварыОрганизаций.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "Любой";
	//++ НЕ УТ
	//++ Локализация
	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ВыпускПродукции.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыСведений.ОтражениеДокументовВРеглУчете.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "Любой";
	//-- Локализация
	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ДвижениеПродукцииИМатериалов.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаказМатериаловВПроизводство.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаказПереработчику.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаказПереработчику.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ПроизводствоБезЗаказа.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.РаспределениеВозвратныхОтходов.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";
	//-- НЕ УТ
	//++ НЕ УТКА
	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаказДавальца.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаказДавальца.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЭтапПроизводства2_2.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЭтапПроизводства2_2.СгенерироватьНедостающиеКлючиАналитикиУчетаНоменклатуры";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыСведений.ОтражениеДокументовВМеждународномУчете.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "Любой";
	//-- НЕ УТКА

КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ИмяРегистра = "ТоварыКПоступлению";
	ПолноеИмяРегистра = "РегистрНакопления.ТоварыКПоступлению";
	
	СписокДокументов = ДокументыКОбновлению();
	
	ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	ДопПараметры.ПолучитьТекстыЗапроса = Истина;
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = СтрСоединить(СписокДокументов, ",");
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Период УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Период УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();
	
	Для каждого ПолноеИмяДокумента Из СписокДокументов Цикл
		ИмяДокумента	= СтрРазделить(ПолноеИмяДокумента, ".")[1];
		ТекстыЗапроса	= Документы[ИмяДокумента].ДанныеДокументаДляПроведения(Неопределено, ИмяРегистра, ДопПараметры);
		Регистраторы	= ПроведениеДокументов.РегистраторыДляПерепроведения(ТекстыЗапроса,
																			ПолноеИмяРегистра,
																			ПолноеИмяДокумента);
		
		ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.ТоварыКПоступлению";
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазыУТ.ДополнительныеПараметрыПерезаписиДвиженийИзОчереди();
	ДополнительныеПараметры.ОбновляемыеДанные = Параметры.ОбновляемыеДанные;
	
	СписокДокументов = ДокументыКОбновлению();
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(СписокДокументов,
																						ПолноеИмяРегистра,
																						Параметры.Очередь,
																						ДополнительныеПараметры);
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

Функция ДокументыКОбновлению()
	СписокДокументов = Новый Массив;
	СписокДокументов.Добавить("Документ.АктОРасхожденияхПослеПеремещения");
	СписокДокументов.Добавить("Документ.АктОРасхожденияхПослеПриемки");
	СписокДокументов.Добавить("Документ.ВозвратТоваровОтКлиента");
	СписокДокументов.Добавить("Документ.ЗаказНаПеремещение");
	СписокДокументов.Добавить("Документ.ЗаказНаСборку");
	СписокДокументов.Добавить("Документ.ЗаказПоставщику");
	СписокДокументов.Добавить("Документ.ЗаявкаНаВозвратТоваровОтКлиента");
	СписокДокументов.Добавить("Документ.ПеремещениеТоваров");
	СписокДокументов.Добавить("Документ.ПоступлениеТоваровНаСклад");
	СписокДокументов.Добавить("Документ.ПриобретениеТоваровУслуг");
	СписокДокументов.Добавить("Документ.ПриходныйОрдерНаТовары");
	СписокДокументов.Добавить("Документ.ПрочееОприходованиеТоваров");
	СписокДокументов.Добавить("Документ.СборкаТоваров");
	
	//++ НЕ УТ
	//++ Устарело_Производство21
	СписокДокументов.Добавить("Документ.ВозвратМатериаловИзПроизводства");
	СписокДокументов.Добавить("Документ.ВыпускПродукции");
	//-- Устарело_Производство21
	СписокДокументов.Добавить("Документ.ВозвратСырьяОтПереработчика");

	СписокДокументов.Добавить("Документ.ДвижениеПродукцииИМатериалов");
	СписокДокументов.Добавить("Документ.ЗаказМатериаловВПроизводство");
	СписокДокументов.Добавить("Документ.ЗаказПереработчику");
	СписокДокументов.Добавить("Документ.ПоступлениеОтПереработчика");
	//-- НЕ УТ
	СписокДокументов.Добавить("Документ.ПоступлениеТоваровОтХранителя");
	СписокДокументов.Добавить("Документ.ПриемкаТоваровНаХранение");
	//++ НЕ УТ
	СписокДокументов.Добавить("Документ.ПроизводствоБезЗаказа");
	СписокДокументов.Добавить("Документ.РаспределениеВозвратныхОтходов");
	//-- НЕ УТ
	
	//++ НЕ УТКА
	//++ Устарело_Производство21
	СписокДокументов.Добавить("Документ.МаршрутныйЛистПроизводства");
	//-- Устарело_Производство21
	СписокДокументов.Добавить("Документ.ЗаказДавальца");
	СписокДокументов.Добавить("Документ.ПоступлениеСырьяОтДавальца");
	СписокДокументов.Добавить("Документ.ЭтапПроизводства2_2");
	//-- НЕ УТКА
	Возврат СписокДокументов
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
