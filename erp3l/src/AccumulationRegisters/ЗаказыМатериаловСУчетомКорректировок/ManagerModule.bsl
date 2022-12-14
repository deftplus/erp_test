#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//++ НЕ УТКА

#Область Обеспечение

// Получает оформленное накладными по заказам количество.
//
// Параметры:
//  ТаблицаОтбора		 - ТаблицаЗначений - Таблица с полями "Ссылка" и "КодСтроки", строки должны быть уникальными.
//  ИсключитьЗаказ		 - Булево - Признак исключающий заказ из списка оформленных накладных.
//  ОтборПоИзмерениям	 - Структура - ключ структуры определяет имя измерения, по которому будет накладываться отбор,
//  									а значение структуры - искомое значение.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица с полями "Ссылка", "КодСтроки", "Количество". Для каждой пары Заказ-КодСтроки содержит
//                    оформленное накладными количество.
//
Функция ТаблицаОформлено(ТаблицаОтбора, ОтборПоИзмерениям = Неопределено, ИсключитьЗаказ = Ложь) Экспорт

	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.Ссылка    КАК Ссылка,
		|	Таблица.КодСтроки КАК КодСтроки
		|ПОМЕСТИТЬ ВтОтбор
		|ИЗ
		|	&ТаблицаОтбора КАК Таблица
		|ГДЕ
		|	Таблица.КодСтроки > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТЗаказыМатериалов.Распоряжение          КАК Распоряжение,
		|	ТЗаказыМатериалов.КодСтроки             КАК КодСтроки,
		|	ТЗаказыМатериалов.КодСтрокиРаспоряжения КАК КодСтрокиРаспоряжения,
		|	ТЗаказыМатериалов.Номенклатура          КАК Номенклатура,
		|	ТЗаказыМатериалов.Характеристика        КАК Характеристика,
		|	ТЗаказыМатериалов.Склад                 КАК Склад,
		|	ТЗаказыМатериалов.Серия                 КАК Серия
		|ПОМЕСТИТЬ ВТЗаказыМатериаловСУчетомКорректировок
		|ИЗ
		|	РегистрНакопления.ЗаказыМатериаловСУчетомКорректировок.Обороты(,,,
		|			(Распоряжение, КодСтроки) В
		|					(ВЫБРАТЬ
		|						ВтОтбор.Ссылка,
		|						ВтОтбор.КодСтроки
		|					ИЗ
		|						ВтОтбор КАК ВтОтбор)
		|				И ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить)
		|			) КАК ТЗаказыМатериалов
		|ГДЕ
		|	ТЗаказыМатериалов.КоличествоОборот > 0
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Распоряжение,
		|	КодСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТМатериалыИУслуги.Распоряжение                    КАК Ссылка,
		|	ТМатериалыИУслуги.КодСтроки                       КАК КодСтроки,
		|	МАКСИМУМ(ТМатериалыИУслуги.Номенклатура)          КАК Номенклатура,
		|	МАКСИМУМ(ТМатериалыИУслуги.Характеристика)        КАК Характеристика,
		|	МАКСИМУМ(ТМатериалыИУслуги.Склад)                 КАК Склад,
		|	МАКСИМУМ(ТМатериалыИУслуги.Серия)                 КАК Серия,
		|	СУММА(РегистрЗаказы.КОформлению) КАК Количество
		|ИЗ
		|	ВТЗаказыМатериаловСУчетомКорректировок КАК ТМатериалыИУслуги
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыМатериаловВПроизводство КАК РегистрЗаказы
		|		ПО РегистрЗаказы.Распоряжение = ТМатериалыИУслуги.Распоряжение
		|		 И РегистрЗаказы.КодСтроки = ТМатериалыИУслуги.КодСтроки
		|		 И РегистрЗаказы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|		 И РегистрЗаказы.КОформлению <> 0
		|		 И РегистрЗаказы.Активность
		|		 И &ОтборПереопределяемый
		|
		|СГРУППИРОВАТЬ ПО
		|	ТМатериалыИУслуги.Распоряжение,
		|	ТМатериалыИУслуги.КодСтроки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаОтбора", ТаблицаОтбора);
	
	Отбор = Новый Массив;
	Если ИсключитьЗаказ Тогда
		Отбор.Добавить("РегистрЗаказы.Распоряжение <> РегистрЗаказы.Регистратор");
	КонецЕсли;
	Если ЗначениеЗаполнено(ОтборПоИзмерениям) Тогда
		Для Каждого КлючЗначение Из ОтборПоИзмерениям Цикл
			Запрос.УстановитьПараметр(КлючЗначение.Ключ, КлючЗначение.Значение);
			Отбор.Добавить("РегистрЗаказы." + КлючЗначение.Ключ + " В(&" + КлючЗначение.Ключ + ")");
		КонецЦикла;
	КонецЕсли;
	Если ЗначениеЗаполнено(Отбор) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПереопределяемый", СтрСоединить(Отбор, " И "));
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПереопределяемый", "ИСТИНА");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Таблица = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	Таблица.Индексы.Добавить("Ссылка, КодСтроки");
	
	Возврат Таблица;
	
КонецФункции

//++ Устарело_Производство21

// Получает список материалов к обеспечению по заказу на производство
//
// Параметры:
//  Заказ - ДокументСсылка.ЗаказНаПроизводство - заказ на производство.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица содержит список материалов к обеспечению.
//   *ЗаказНаОтгрузку      - ДокументСсылка.ЗаказНаПроизводство          - Заказ на производство,
//   *Номенклатура         - СправочникСсылка.Номенклатура               - Поле из табличной части материалов заказа,
//   *Характеристика       - СправочникСсылка.ХарактеристикиНоменклатуры - Поле из табличной части материалов заказа,
//   *Назначение           - СправочникСсылка.Назначения                 - Поле из табличной части материалов заказа,
//   *Склад                - СправочникСсылка.Склады,                    - Поле из табличной части материалов заказа,
//                         - СправочникСсылка.СтруктураПредприятия       - Поле подразделение из табличной части материалов заказа для работ,
//   *ЖелаемаяДатаОтгрузки - Дата                                        - Поле из табличной части материалов заказа,
//   *Действие             - ПеречислениеСсылка.ВариантыОбеспечения      - Поле из табличной части материалов заказа,
//   *Обособленно          - Булево                                      - Поле из табличной части материалов заказа,
//   *Количество           - Число                                       - Поле из табличной части материалов заказа,
//   *Продукция            - СправочникСсылка.Номенклатура               - Поле группировки потребностей заказа на производство,
//   *Этап                 - СправочникСсылка.Этапы                      - Поле группировки потребностей заказа на производство,
//   *ЭтапПорядок          - Число                                       - Поле группировки потребностей заказа на производство числом,
//   *НомерСтрокиПродукция - Число                                       - Поле группировки потребностей заказа на производство числом.
//
Функция ТаблицаМатериалыЗаказаНаПроизводствоКОбеспечению(Заказ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Очередь = ПланированиеПроизводства.ОчередьЭтаповКОбеспечению(Заказ);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВсеЗаказыПереработчику.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВтЗаказыПереработчику
	|ИЗ
	|	Документ.ЗаказПереработчику.Услуги КАК ВсеЗаказыПереработчику
	|ГДЕ
	|	ВсеЗаказыПереработчику.Распоряжение В(&Заказ)
	|		И ВсеЗаказыПереработчику.Ссылка.Проведен
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|///////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказыМатериалов.ЗаказКлиента    КАК ЗаказКлиента,
	|	ЗаказыМатериалов.КодСтроки       КАК КодСтроки,
	|	ЗаказыМатериалов.Номенклатура    КАК Номенклатура,
	|	ЗаказыМатериалов.Характеристика  КАК Характеристика,
	|	ЗаказыМатериалов.Склад           КАК Склад,
	|	ЗаказыМатериалов.ЗаказаноОстаток - ЗаказыМатериалов.КОформлениюОстаток КАК Количество
	|ПОМЕСТИТЬ ВтЗаказыКлиентов
	|ИЗ
	|	РегистрНакопления.ЗаказыКлиентов.Остатки(,
	|		ЗаказКлиента В(
	|			ВЫБРАТЬ
	|				Заказы.Ссылка КАК Ссылка
	|			ИЗ
	|				ВтЗаказыПереработчику КАК Заказы)) КАК ЗаказыМатериалов
	|
	|ГДЕ
	|	ЗаказыМатериалов.ЗаказаноОстаток - ЗаказыМатериалов.КОформлениюОстаток > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Материалы.Ссылка          КАК ЗаказКлиента,
	|	Материалы.КодСтроки       КАК КодСтроки,
	|	Материалы.Номенклатура    КАК Номенклатура,
	|	Материалы.Характеристика  КАК Характеристика,
	|	Материалы.Склад           КАК Склад,
	|	Материалы.Количество      КАК Количество
	|ИЗ
	|	Документ.ЗаказПереработчику.Материалы КАК Материалы
	|
	|ГДЕ
	|	Материалы.Ссылка  В(
	|		ВЫБРАТЬ
	|			Заказы.Ссылка КАК Ссылка
	|		ИЗ
	|			ВтЗаказыПереработчику КАК Заказы)
	|		И НЕ Материалы.Отменено
	|		И Материалы.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.НеТребуется)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗаказКлиента,
	|	КодСтроки,
	|	Номенклатура,
	|	Характеристика,
	|	Склад
	|;
	|
	|///////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказыМатериалов.Распоряжение          КАК Распоряжение,
	|	ЗаказыМатериалов.КодСтрокиРаспоряжения КАК КодСтрокиРаспоряжения,
	|	ЗаказыМатериалов.Номенклатура          КАК Номенклатура,
	|	ЗаказыМатериалов.Характеристика        КАК Характеристика,
	|	ЗаказыМатериалов.Склад                 КАК Склад,
	|	ЗаказыМатериалов.Назначение            КАК Назначение,
	|	ЗаказыМатериалов.ВариантОбеспечения    КАК ВариантОбеспечения,
	|	ЗаказыМатериалов.Обособленно           КАК Обособленно,
	|	ЗаказыМатериалов.ДатаПотребности       КАК ДатаПотребности,
	|	ЗаказыМатериалов.КоличествоОборот      КАК Количество
	|ПОМЕСТИТЬ ДанныеУчета
	|ИЗ
	|	РегистрНакопления.ЗаказыМатериаловСУчетомКорректировок.Обороты(,,,
	|		Распоряжение = &Заказ) КАК ЗаказыМатериалов
	|ГДЕ
	|	ЗаказыМатериалов.КоличествоОборот > 0
	|		И НЕ ЗаказыМатериалов.Отменено
	|		И ЗаказыМатериалов.ВариантОбеспечения <> ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить)
	|ИНДЕКСИРОВАТЬ ПО
	|	Распоряжение,
	|	КодСтрокиРаспоряжения
	|;
	|///////////////////////////////////////////
	|ВЫБРАТЬ
	|	Набор.ЗаказНаОтгрузку              КАК ЗаказНаОтгрузку,
	|	Набор.Номенклатура                 КАК Номенклатура,
	|	Набор.Характеристика               КАК Характеристика,
	|	Набор.Назначение                   КАК Назначение,
	|	Набор.Склад                        КАК Склад,
	|	Набор.ЖелаемаяДатаОтгрузки         КАК ЖелаемаяДатаОтгрузки,
	|	Набор.Действие                     КАК Действие,
	|	Набор.Обособленно                  КАК Обособленно,
	|	СУММА(Набор.Количество)            КАК Количество,
	|	Набор.НомерСтрокиПродукция         КАК НомерСтрокиПродукция,
	|	Набор.Продукция                    КАК Продукция,
	|	Набор.Этап                         КАК Этап,
	|	Набор.ЭтапПорядок                  КАК ЭтапПорядок,
	|	Набор.КлючСвязи                    КАК КлючСвязи
	|ИЗ(
	|	ВЫБРАТЬ
	|		ТаблицаУслуги.Распоряжение             КАК ЗаказНаОтгрузку,
	|		Материалы.Номенклатура                 КАК Номенклатура,
	|		Материалы.Характеристика               КАК Характеристика,
	|		Материалы.Назначение                   КАК Назначение,
	|		Материалы.Склад                        КАК Склад,
	|		ВЫБОР КОГДА Материалы.Ссылка.НеОтгружатьЧастями ТОГДА
	|					Материалы.Ссылка.ДатаОтгрузки
	|				ИНАЧЕ
	|					Материалы.ДатаОтгрузки
	|			КОНЕЦ                              КАК ЖелаемаяДатаОтгрузки,
	|		Материалы.ВариантОбеспечения           КАК Действие,
	|		Материалы.Обособленно                  КАК Обособленно,
	|		Материалы.Количество                   КАК Количество,
	|		Продукция.НомерСтроки                  КАК НомерСтрокиПродукция,
	|		Продукция.Номенклатура                 КАК Продукция,
	|		Этапы.Этап                             КАК Этап,
	|		0                                      КАК ЭтапПорядок,
	|		Этапы.КлючСвязи                        КАК КлючСвязи
	|	ИЗ
	|		ВтЗаказыКлиентов КАК ЗаказыКлиентов
	|			
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПереработчику.Материалы КАК Материалы
	|			ПО Материалы.Ссылка = ЗаказыКлиентов.ЗаказКлиента
	|			 И Материалы.КодСтроки = ЗаказыКлиентов.КодСтроки
	|			 И Материалы.Номенклатура = ЗаказыКлиентов.Номенклатура
	|			 И Материалы.Характеристика = ЗаказыКлиентов.Характеристика
	|			 И Материалы.Склад = ЗаказыКлиентов.Склад
	|			
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПереработчику.Услуги КАК ТаблицаУслуги
	|			ПО ТаблицаУслуги.Ссылка = Материалы.Ссылка
	|				И ТаблицаУслуги.НомерГруппыЗатрат = Материалы.НомерГруппыЗатрат
	|			
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.ЭтапыГрафик КАК ЭтапыГрафик
	|			ПО ЭтапыГрафик.Ссылка = ТаблицаУслуги.Распоряжение
	|			 И ЭтапыГрафик.КодСтроки = ТаблицаУслуги.КодСтрокиЭтапыГрафик
	|			
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Продукция КАК Продукция
	|			ПО Продукция.Ссылка = ТаблицаУслуги.Распоряжение
	|			 И Продукция.КлючСвязи = ЭтапыГрафик.КлючСвязиПродукция
	|			
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Этапы КАК Этапы
	|			ПО Этапы.Ссылка = ТаблицаУслуги.Распоряжение
	|			 И Этапы.КлючСвязи = ЭтапыГрафик.КлючСвязиЭтапы
	|	ГДЕ
	|		ТаблицаУслуги.РАспоряжение В(&Заказ)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаУслуги.Распоряжение                            КАК ЗаказНаОтгрузку,
	|		РаспоряжениеСпецификация.Номенклатура                 КАК Номенклатура,
	|		РаспоряжениеСпецификация.Характеристика               КАК Характеристика,
	|		РаспоряжениеСпецификация.Назначение                   КАК Назначение,
	|		РаспоряжениеСпецификация.Склад                        КАК Склад,
	|		РаспоряжениеСпецификация.ДатаОтгрузки                 КАК ЖелаемаяДатаОтгрузки,
	|		РаспоряжениеСпецификация.ВариантОбеспечения           КАК Действие,
	|		РаспоряжениеСпецификация.Обособленно                  КАК Обособленно,
	|		-РаспоряжениеСпецификация.КоличествоПоЗаказу          КАК Количество,
	|		Продукция.НомерСтроки                                 КАК НомерСтрокиПродукция,
	|		Продукция.Номенклатура                                КАК Продукция,
	|		Этапы.Этап                                            КАК Этап,
	|		0                                                     КАК ЭтапПорядок,
	|		Этапы.КлючСвязи                                       КАК КлючСвязи
	|	ИЗ
	|		Документ.ЗаказПереработчику.РаспоряжениеСпецификация КАК РаспоряжениеСпецификация
	|			
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПереработчику.Услуги КАК ТаблицаУслуги
	|			ПО ТаблицаУслуги.Ссылка = РаспоряжениеСпецификация.Ссылка
	|			И ТаблицаУслуги.НомерГруппыЗатрат = РаспоряжениеСпецификация.НомерГруппыЗатрат
	|			
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.ЭтапыГрафик КАК ЭтапыГрафик
	|			ПО ЭтапыГрафик.Ссылка = ТаблицаУслуги.Распоряжение
	|			 И ЭтапыГрафик.КодСтроки = ТаблицаУслуги.КодСтрокиЭтапыГрафик
	|			
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Продукция КАК Продукция
	|			ПО Продукция.Ссылка = ТаблицаУслуги.Распоряжение
	|			 И Продукция.КлючСвязи = ЭтапыГрафик.КлючСвязиПродукция
	|			
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Этапы КАК Этапы
	|			ПО Этапы.Ссылка = ТаблицаУслуги.Распоряжение
	|			 И Этапы.КлючСвязи = ЭтапыГрафик.КлючСвязиЭтапы
	|	ГДЕ
	|		РаспоряжениеСпецификация.Ссылка.Проведен
	|			И РаспоряжениеСпецификация.ТипДвиженияЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыДвиженияЗапасов.Отгрузка)
	|			И РаспоряжениеСпецификация.КоличествоПоЗаказу > 0
	|			И ТаблицаУслуги.Распоряжение В (&Заказ)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДанныеУчета.Распоряжение               КАК ЗаказНаОтгрузку,
	|		ДанныеУчета.Номенклатура               КАК Номенклатура,
	|		ДанныеУчета.Характеристика             КАК Характеристика,
	|		ДанныеУчета.Назначение                 КАК Назначение,
	|		
	|		ВЫБОР КОГДА МатериалыИУслуги.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа) ТОГДА
	|					МатериалыИУслуги.Этап.Подразделение
	|				ИНАЧЕ
	|					ДанныеУчета.Склад
	|			КОНЕЦ КАК Склад,
	|		
	|		ВЫБОР КОГДА ДанныеУчета.ДатаПотребности <> ДАТАВРЕМЯ(1,1,1) ТОГДА
	|					ДанныеУчета.ДатаПотребности
	|				ИНАЧЕ
	|					Продукция.НачатьНеРанее
	|			КОНЕЦ                              КАК ЖелаемаяДатаОтгрузки,
	|		ДанныеУчета.ВариантОбеспечения         КАК Действие,
	|		ДанныеУчета.Обособленно                КАК Обособленно,
	|		ДанныеУчета.Количество                 КАК Количество,
	|		
	|		Продукция.НомерСтроки                  КАК НомерСтрокиПродукция,
	|		Продукция.Номенклатура                 КАК Продукция,
	|		Этапы.Этап                             КАК Этап,
	|		0                                      КАК ЭтапПорядок,
	|		Этапы.КлючСвязи                        КАК КлючСвязи
	|	ИЗ
	|			ДанныеУчета КАК ДанныеУчета
	|				
	|				ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.МатериалыИУслуги КАК МатериалыИУслуги
	|				ПО МатериалыИУслуги.Ссылка = ДанныеУчета.Распоряжение
	|				 И МатериалыИУслуги.КодСтроки = ДанныеУчета.КодСтрокиРаспоряжения
	|				
	|				ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Продукция КАК Продукция
	|				ПО Продукция.Ссылка = МатериалыИУслуги.Ссылка
	|				 И Продукция.КлючСвязи = МатериалыИУслуги.КлючСвязиПродукция
	|				
	|				ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Этапы КАК Этапы
	|				ПО Этапы.Ссылка = МатериалыИУслуги.Ссылка
	|				 И Этапы.КлючСвязи = МатериалыИУслуги.КлючСвязиЭтапы
	|	ГДЕ
	|		МатериалыИУслуги.ЗаказатьНаСклад
	|			ИЛИ МатериалыИУслуги.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)) КАК Набор
	|СГРУППИРОВАТЬ ПО
	|	Набор.ЗаказНаОтгрузку,
	|	Набор.Номенклатура,
	|	Набор.Характеристика,
	|	Набор.Назначение,
	|	Набор.Склад,
	|	Набор.ЖелаемаяДатаОтгрузки,
	|	Набор.Действие,
	|	Набор.Обособленно,
	|	Набор.НомерСтрокиПродукция,
	|	Набор.Продукция,
	|	Набор.Этап,
	|	Набор.ЭтапПорядок,
	|	Набор.КлючСвязи
	|ИМЕЮЩИЕ
	|	СУММА(Набор.Количество) > 0");
	Запрос.УстановитьПараметр("Заказ", Заказ);
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Таблица = Запрос.Выполнить().Выгрузить();
	
	Для каждого Строка Из Таблица Цикл
		Строка.ЭтапПорядок = Очередь[Строка.КлючСвязи];
	КонецЦикла;
	Таблица.Колонки.Удалить("КлючСвязи");
	
	Возврат Таблица;
	
КонецФункции

//-- Устарело_Производство21

#КонецОбласти

//-- НЕ УТКА

#Область ДляВызоваИзДругихПодсиыстем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Подразделение)
	|	И ЗначениеРазрешено(Склад)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция Регистраторы()
	
	Массив = Новый Массив(1);
	
	Типы = РегистрыНакопления.ЗаказыМатериаловСУчетомКорректировок.СоздатьНаборЗаписей().Отбор.Регистратор.ТипЗначения.Типы();
	
	ВсеРегистраторы = Новый Массив();
	
	Для Каждого Элемент Из Типы Цикл
		
		Если Элемент = Тип("ДокументСсылка.КорректировкаРегистров") Тогда
			Продолжить;
		КонецЕсли;
		
		Массив[0] = Элемент;
		ОписаниеТипов = Новый ОписаниеТипов(Массив);
		Ссылка = ОписаниеТипов.ПривестиЗначение(Неопределено);
		ВсеРегистраторы.Добавить(ОбщегоНазначения.ИмяТаблицыПоСсылке(Ссылка));
		
	КонецЦикла;
	
	Возврат ВсеРегистраторы;
	
КонецФункции

#Область ОбновлениеИнформационнойБазы

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
//  Обработчики - ТаблицаЗначений - описание полей, см. в процедуре
//                ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.МонопольныйРежим    = Ложь;
//
// Параметры:
// 	Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

#Область ОбработатьДанныеДляПереходаНаНовуюВерсию

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.ЗаказыМатериаловСУчетомКорректировок.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.7.346";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("af86bb49-e839-4199-8384-4e42472dba43");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.ЗаказыМатериаловСУчетомКорректировок.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Формирует движения по данным документов (заполняет ""Вариант обеспечения"" и признак ""Обособленно"")';
									|en = 'Generates records based on the documents data (populates the ""Supply option"" and the ""Pegged"" flag)'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.ЗаказМатериаловВПроизводство.ПолноеИмя());
	//++ НЕ УТКА
	Читаемые.Добавить(Метаданные.Документы.ЗаказНаПроизводство.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.КорректировкаЗаказаМатериаловВПроизводство.ПолноеИмя());
	//-- НЕ УТКА
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.ЗаказыМатериаловСУчетомКорректировок.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.РегистрыНакопления.ЗаказыМатериаловСУчетомКорректировок.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаказМатериаловВПроизводство.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	//++ НЕ УТКА
	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаказНаПроизводство.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.КорректировкаЗаказаМатериаловВПроизводство.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";
	//-- НЕ УТКА

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыНакопления.ЗаказыМатериаловСУчетомКорректировок.ОбработатьКорректировкиРегистровДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "Любой";

#КонецОбласти

#Область ОбработатьКорректировкиРегистровДляПереходаНаНовуюВерсию

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.ЗаказыМатериаловСУчетомКорректировок.ОбработатьКорректировкиРегистровДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.7.206";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("a74129c1-6515-4bea-90e9-18a4ac071ee4");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.ЗаказыМатериаловСУчетомКорректировок.ЗарегистрироватьКорректировкиРегистровДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обрабатывает движения документов ""Корректировка регистров"" (заполняет ""Вариант обеспечения"" и признак ""Обособленно"")';
									|en = 'Processes register records of the ""Register adjustment"" documents (fills in ""Supply option"" and flag ""Separately"")'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыНакопления.ЗаказыМатериаловСУчетомКорректировок.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.ЗаказыМатериаловСУчетомКорректировок.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.РегистрыНакопления.ЗаказыМатериаловСУчетомКорректировок.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыНакопления.ЗаказыМатериаловСУчетомКорректировок.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "Любой";

#КонецОбласти

КонецПроцедуры

// Регистрирует данные к обработке
// 
// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.ЗаказыМатериаловСУчетомКорректировок";
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = СтрСоединить(Регистраторы(), ",");
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Период УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Период УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаРегистра.Регистратор КАК Регистратор
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаРегистра.Регистратор КАК Регистратор
	|	ИЗ
	|		РегистрНакопления.ЗаказыМатериаловСУчетомКорректировок КАК ТаблицаРегистра
	//++ НЕ УТКА
	// Заказ на производство (2.1)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.МатериалыИУслуги КАК ЗаказМатериалыИУслуги
	|		ПО ТаблицаРегистра.Регистратор = ЗаказМатериалыИУслуги.Ссылка
	|			И ТаблицаРегистра.КодСтрокиРаспоряжения = ЗаказМатериалыИУслуги.КодСтроки
	|			И НЕ ТаблицаРегистра.Обособленно
	
	// Корректировка заказа материалов в производство
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.МатериалыИУслуги КАК ЗаказОснованияКорректировкиМатериалыИУслуги
	|		ПО ТИПЗНАЧЕНИЯ(ТаблицаРегистра.Регистратор) = ТИП(Документ.КорректировкаЗаказаМатериаловВПроизводство)
	|			И ВЫРАЗИТЬ(ТаблицаРегистра.Регистратор КАК Документ.КорректировкаЗаказаМатериаловВПроизводство).Распоряжение = ЗаказОснованияКорректировкиМатериалыИУслуги.Ссылка
	|			И ТаблицаРегистра.КодСтрокиРаспоряжения = ЗаказОснованияКорректировкиМатериалыИУслуги.КодСтроки
	|			И НЕ ТаблицаРегистра.Обособленно
	//-- НЕ УТКА
	
	|	ГДЕ
	|		(ТаблицаРегистра.ВариантОбеспечения В (
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.УдалитьОтгрузитьОбособленно),
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.УдалитьИзЗаказов),
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.УдалитьОбособленно))
	//++ НЕ УТКА
	|		ИЛИ ЗаказМатериалыИУслуги.Ссылка ЕСТЬ НЕ NULL 
	|			И ЗаказМатериалыИУслуги.ПроизводитсяВПроцессе
	|		ИЛИ ЗаказОснованияКорректировкиМатериалыИУслуги.Ссылка ЕСТЬ НЕ NULL 
	|			И ЗаказОснованияКорректировкиМатериалыИУслуги.ПроизводитсяВПроцессе
	//-- НЕ УТКА
	|		) И НЕ ТИПЗНАЧЕНИЯ(ТаблицаРегистра.Регистратор) = ТИП(Документ.КорректировкаРегистров)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	// Пропавшие движения в КА после перехода на модульность проведения
	|	ВЫБРАТЬ
	|		ЗаказыМатериаловВПроизводство.Ссылка КАК Регистратор
	|	ИЗ
	|		Документ.ЗаказМатериаловВПроизводство КАК ЗаказыМатериаловВПроизводство
	|	ГДЕ
	|		ЗаказыМатериаловВПроизводство.Проведен
	|		И НЕ ЗаказыМатериаловВПроизводство.УправлениеПроизводством2_2
	|		И НЕ ИСТИНА В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					ИСТИНА
	|				ИЗ
	|					РегистрНакопления.ЗаказыМатериаловСУчетомКорректировок КАК ТаблицаРегистра
	|				ГДЕ
	|					ТаблицаРегистра.Регистратор = ЗаказыМатериаловВПроизводство.Ссылка)
	|	) КАК ТаблицаРегистра
	|";
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыНакопления.ЗаказыМатериаловСУчетомКорректировок;
	ПолноеИмяРегистра  = МетаданныеРегистра.ПолноеИмя();
	
	ПолныеИменаДокументов = Новый Массив;
	ПолныеИменаДокументов.Добавить("Документ.ЗаказМатериаловВПроизводство");
//++ НЕ УТКА
	ПолныеИменаДокументов.Добавить("Документ.ЗаказНаПроизводство");
	ПолныеИменаДокументов.Добавить("Документ.КорректировкаЗаказаМатериаловВПроизводство");
//-- НЕ УТКА
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазыУТ.ДополнительныеПараметрыПерезаписиДвиженийИзОчереди();
	ДополнительныеПараметры.ОбновляемыеДанные = Параметры.ОбновляемыеДанные;
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
		ПолныеИменаДокументов, ПолноеИмяРегистра, Параметры.Очередь, ДополнительныеПараметры);
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры	

// Регистрирует данные к обработке
// 
// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьКорректировкиРегистровДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.ЗаказыМатериаловСУчетомКорректировок";
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = "Документ.КорректировкаРегистров";
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Период УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Период УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаРегистра.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.ЗаказыМатериаловСУчетомКорректировок КАК ТаблицаРегистра
	|ГДЕ
	|	ТаблицаРегистра.ВариантОбеспечения В (
	|							ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.УдалитьОтгрузитьОбособленно),
	|							ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.УдалитьИзЗаказов),
	|							ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.УдалитьОбособленно))
	|		И ТИПЗНАЧЕНИЯ(ТаблицаРегистра.Регистратор) = ТИП(Документ.КорректировкаРегистров)";
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьКорректировкиРегистровДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыНакопления.ЗаказыМатериаловСУчетомКорректировок;
	ПолноеИмяРегистра  = МетаданныеРегистра.ПолноеИмя();
	ОбновляемыеДанные  = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь,
			ПолноеИмяРегистра);
		Возврат;
	КонецЕсли;
	
	ВариантТребуется            = Перечисления.ВариантыОбеспечения.Требуется;
	ВариантИзЗаказов            = Перечисления.ВариантыОбеспечения.УдалитьИзЗаказов;
	ВариантОтгрузить            = Перечисления.ВариантыОбеспечения.Отгрузить;
	ВариантОбособленно          = Перечисления.ВариантыОбеспечения.УдалитьОбособленно;
	ВариантОтгрузитьОбособленно = Перечисления.ВариантыОбеспечения.УдалитьОтгрузитьОбособленно;
	
	Для Каждого Строка Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		
		Попытка
		
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Строка.Регистратор);
			Блокировка.Заблокировать();
						
			НаборЗаписей = РегистрыНакопления.ЗаказыМатериаловСУчетомКорректировок.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Строка.Регистратор);
			НаборЗаписей.Прочитать();
			НаборИзменен = Ложь;
			
			Для каждого ЗаписьНабора Из НаборЗаписей Цикл
			
				Если ЗаписьНабора.ВариантОбеспечения = ВариантИзЗаказов Тогда
					ЗаписьНабора.ВариантОбеспечения = ВариантТребуется;
					НаборИзменен = Истина;
				КонецЕсли;
			
				Если ЗаписьНабора.ВариантОбеспечения = ВариантОтгрузитьОбособленно Тогда
					ЗаписьНабора.ВариантОбеспечения = ВариантОтгрузить;
					ЗаписьНабора.Обособленно        = Истина;
					НаборИзменен = Истина;
				КонецЕсли;
			
				Если ЗаписьНабора.ВариантОбеспечения = ВариантОбособленно Тогда
					ЗаписьНабора.ВариантОбеспечения = ВариантТребуется;
					ЗаписьНабора.Обособленно        = Истина;
					НаборИзменен = Истина;
				КонецЕсли;
		
			КонецЦикла;
		
			Если НаборИзменен Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			КонецЕсли;
		
			ЗафиксироватьТранзакцию();
		
		Исключение
		
			ОтменитьТранзакцию();
		
			Шаблон = НСтр("ru = 'Не удалось записать данные в регистр %1 по регистратору ""%2"", по причине: %3';
							|en = 'Cannot save data to the register %1 for recorder ""%2"". Reason: %3'");
			ТекстСообщения = СтрШаблон(Шаблон,
									   ПолноеИмяРегистра,
									   Строка.Регистратор,
									   ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
									 УровеньЖурналаРегистрации.Предупреждение,
									 МетаданныеРегистра,
									 ,
									 ТекстСообщения);
		
		КонецПопытки;
	
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена =
		Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры	

#КонецОбласти

#КонецОбласти

#КонецЕсли
