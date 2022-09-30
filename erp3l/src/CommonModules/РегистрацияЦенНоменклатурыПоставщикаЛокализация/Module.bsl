
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	//++ Локализация
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("ДокументСсылка.КоммерческоеПредложениеПоставщика") Тогда
	
		ЗаполнитьПоКоммерческомуПредложениюПоставщика(ДанныеЗаполнения, Объект);
		
	КонецЕсли;
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

//++ Локализация

#Область СлужебныеПроцедурыИФункции

// Заполняет регистрацию цен номенклатуры поставщика на основании коммерческого предложения поставщика.
//
// Параметры:
//  Основание      - ДокументСсылка.КоммерческоеПредложениеПоставщика - ссылка на документ основание.
//  ДокументОбъект - ДокументОбъект.РегистрацияЦенНоменклатурыПоставщика - заполняемый документ.
//
Процедура ЗаполнитьПоКоммерческомуПредложениюПоставщика(Основание, ДокументОбъект) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КоммерческоеПредложение.Дата КАК Дата,
	|	КоммерческоеПредложение.Валюта КАК Валюта,
	|	КоммерческоеПредложение.Поставщик КАК Партнер,
	|	КоммерческоеПредложение.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	КоммерческоеПредложение.Ссылка КАК ДокументОснование,
	|	НЕ КоммерческоеПредложение.Проведен КАК ЕстьОшибкиПроведен,
	|	КоммерческоеПредложение.РегистрироватьЦеныПоставщика КАК РегистрироватьЦеныПоставщика
	|ИЗ
	|	Документ.КоммерческоеПредложениеПоставщика КАК КоммерческоеПредложение
	|ГДЕ
	|	КоммерческоеПредложение.Ссылка = &Ссылка";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Основание);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаШапка = РезультатЗапроса.Выбрать();
	ВыборкаШапка.Следующий();
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		ВыборкаШапка.ДокументОснование,
		,
		ВыборкаШапка.ЕстьОшибкиПроведен);
	Документы.РегистрацияЦенНоменклатурыПоставщика.СообщитьОбОшибкахРегистрацииЦенОснованием(ВыборкаШапка.РегистрироватьЦеныПоставщика, ВыборкаШапка.ДокументОснование);
	ЗаполнитьЗначенияСвойств(ДокументОбъект, ВыборкаШапка);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ОтносительныеКурсыВалютСрезПоследних.Валюта КАК Валюта,
	|	ОтносительныеКурсыВалютСрезПоследних.КурсЧислитель КАК КурсЧислитель,
	|	ОтносительныеКурсыВалютСрезПоследних.КурсЗнаменатель КАК КурсЗнаменатель
	|ПОМЕСТИТЬ ВременнаяТаблицаКурсыВалют
	|ИЗ
	|	РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(
	|			&Дата,
	|			(Валюта = &Валюта
	|				ИЛИ Валюта В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						ЕСТЬNULL(Товары.ВидЦеныПоставщика.Валюта, ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка))
	|					ИЗ
	|						Документ.КоммерческоеПредложениеПоставщика.Товары КАК Товары
	|					ГДЕ
	|						Товары.Ссылка = &Ссылка)) И БазоваяВалюта = &БазоваяВалюта) КАК ОтносительныеКурсыВалютСрезПоследних
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Валюта
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.ВидЦеныПоставщика КАК ВидЦеныПоставщика,
	|	Товары.ЕдиницаИзмерения КАК Упаковка,
	|	ВЫРАЗИТЬ(Товары.Цена * ВЫБОР
	|			КОГДА &ЦенаВключаетНДС
	|					И НЕ ЕСТЬNULL(Товары.ВидЦеныПоставщика.ЦенаВключаетНДС, ЛОЖЬ)
	|				ТОГДА ВЫБОР
	|						КОГДА Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС)
	|								ИЛИ Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС0)
	|							ТОГДА 1
	|						КОГДА Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС20)
	|								ИЛИ Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС20_120)
	|							ТОГДА 100 / 120
	|						КОГДА Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС18)
	|								ИЛИ Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС18_118)
	|							ТОГДА 100 / 118
	|						КОГДА Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС10)
	|								ИЛИ Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС10_110)
	|							ТОГДА 100 / 110
	|					КОНЕЦ
	|			КОГДА НЕ &ЦенаВключаетНДС
	|					И ЕСТЬNULL(Товары.ВидЦеныПоставщика.ЦенаВключаетНДС, ЛОЖЬ)
	|				ТОГДА ВЫБОР
	|						КОГДА Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС)
	|								ИЛИ Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС0)
	|							ТОГДА 1
	|						КОГДА Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС20)
	|								ИЛИ Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС20_120)
	|							ТОГДА 1.2
	|						КОГДА Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС18)
	|								ИЛИ Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС18_118)
	|							ТОГДА 1.18
	|						КОГДА Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС10)
	|								ИЛИ Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС10_110)
	|							ТОГДА 1.1
	|					КОНЕЦ
	|			ИНАЧЕ 1
	|		КОНЕЦ * ВЫБОР
	|			КОГДА &Валюта <> ЕСТЬNULL(Товары.ВидЦеныПоставщика.Валюта, ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка))
	|				ТОГДА ВЫБОР
	|						КОГДА ЕСТЬNULL(КурсыВалютыСоглашения.КурсЗнаменатель, 0) > 0
	|								И ЕСТЬNULL(КурсыВалютыСоглашения.КурсЧислитель, 0) > 0
	|								И ЕСТЬNULL(КурсыВалюты.КурсЗнаменатель, 0) > 0
	|								И ЕСТЬNULL(КурсыВалюты.КурсЧислитель, 0) > 0
	|							ТОГДА КурсыВалюты.КурсЧислитель * КурсыВалютыСоглашения.КурсЗнаменатель / (КурсыВалютыСоглашения.КурсЧислитель * КурсыВалюты.КурсЗнаменатель)
	|						ИНАЧЕ 0
	|					КОНЕЦ
	|			ИНАЧЕ 1
	|		КОНЕЦ КАК ЧИСЛО(31, 2)) КАК Цена
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	Документ.КоммерческоеПредложениеПоставщика.Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаКурсыВалют КАК КурсыВалюты
	|		ПО (КурсыВалюты.Валюта = &Валюта)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаКурсыВалют КАК КурсыВалютыСоглашения
	|		ПО (КурсыВалютыСоглашения.Валюта = ЕСТЬNULL(Товары.ВидЦеныПоставщика.Валюта, ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)))
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|	И Товары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.ВидЦеныПоставщика КАК ВидЦеныПоставщика,
	|	СРЕДНЕЕ(Товары.Цена / ВЫБОР
	|			КОГДА Товары.Упаковка <> ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|				ТОГДА &ТекстЗапросаКоэффициентУпаковки
	|			ИНАЧЕ 1
	|		КОНЕЦ) КАК ЦенаЗаБазовуюЕдиницу,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Товары.Упаковка) КАК КоличествоРазличныхУпаковок
	|ПОМЕСТИТЬ ТоварыСРазличнымиУпаковкамиЦенами
	|ИЗ
	|	Товары КАК Товары
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.ВидЦеныПоставщика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.ВидЦеныПоставщика КАК ВидЦеныПоставщика,
	|	МИНИМУМ(ВЫБОР
	|			КОГДА ТоварыСРазличнымиУпаковкамиЦенами.КоличествоРазличныхУпаковок > 1
	|				ТОГДА ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|			ИНАЧЕ Товары.Упаковка
	|		КОНЕЦ) КАК Упаковка,
	|	СРЕДНЕЕ(ВЫБОР
	|			КОГДА ТоварыСРазличнымиУпаковкамиЦенами.КоличествоРазличныхУпаковок > 1
	|				ТОГДА ТоварыСРазличнымиУпаковкамиЦенами.ЦенаЗаБазовуюЕдиницу
	|			ИНАЧЕ Товары.Цена
	|		КОНЕЦ) КАК Цена
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыСРазличнымиУпаковкамиЦенами КАК ТоварыСРазличнымиУпаковкамиЦенами
	|		ПО Товары.Номенклатура = ТоварыСРазличнымиУпаковкамиЦенами.Номенклатура
	|			И Товары.Характеристика = ТоварыСРазличнымиУпаковкамиЦенами.Характеристика
	|			И Товары.ВидЦеныПоставщика = ТоварыСРазличнымиУпаковкамиЦенами.ВидЦеныПоставщика
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.ВидЦеныПоставщика";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"Товары.Упаковка",
		"Товары.Номенклатура"));
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("Ссылка",          Основание);
	Запрос.УстановитьПараметр("Дата",            ВыборкаШапка.Дата);
	Запрос.УстановитьПараметр("Валюта",          ВыборкаШапка.Валюта);
	Запрос.УстановитьПараметр("ЦенаВключаетНДС", ВыборкаШапка.ЦенаВключаетНДС);
	Запрос.УстановитьПараметр("БазоваяВалюта", ЗначениеНастроекПовтИсп.БазоваяВалютаПоУмолчанию());
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ДанныеДляЗаполнения = РезультатЗапроса[3].Выгрузить();
	
	Если Не ЗначениеЗаполнено(ДанныеДляЗаполнения) Тогда
		ВызватьИсключение НСтр("ru = 'Отсутствует номенклатура для регистрации цен';
								|en = 'No products to register prices'");
	КонецЕсли;
	
	ДокументОбъект.Товары.Загрузить(ДанныеДляЗаполнения);
	
КонецПроцедуры

#КонецОбласти

//-- Локализация

