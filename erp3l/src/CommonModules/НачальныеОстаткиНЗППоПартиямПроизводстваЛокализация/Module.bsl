
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый документ.
//  Отказ - Булево - Признак проведения документа.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то проведение документа выполнено не будет.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ОбработкаПроведения(Объект, Отказ, РежимПроведения) Экспорт
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения - Строка - Текст, используемый для заполнения документа.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//
Процедура ОбработкаУдаленияПроведения(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//  РежимЗаписи - РежимЗаписиДокумента - В параметр передается текущий режим записи документа. Позволяет определить в теле процедуры режим записи.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина, то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПриЗаписи(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  ОбъектКопирования - ДокументОбъект.НачальныеОстаткиНЗППоПартиямПроизводства - Исходный документ, который является источником копирования.
//
Процедура ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	//++ Локализация
	МеханизмыДокумента.Добавить("РегламентированныйУчет");
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

//++ НЕ УТ
#Область ПроводкиРегУчета

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт
	
	//++ Локализация
	
	#Область ТекстНачальныеОстаткиМатериаловПартийПроизводства // (Дт 2Х :: Кт 000)
	ТекстНачальныеОстаткиМатериаловПартийПроизводства =
	// Начальные остатки партий производства (Дт 2Х :: Кт 000).
	"ВЫБРАТЬ
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	Стоимости.ИдентификаторСтроки КАК ИдентификаторСтроки,

	|	Стоимости.СуммаБалансовая КАК Сумма,
	|	Стоимости.СуммаБалансоваяУУ КАК СуммаУУ,

	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Производство) КАК ВидСчетаДт,
	|	Стоимости.ГруппаПродукции КАК АналитикаУчетаДт,
	|	Операция.Подразделение КАК МестоУчетаДт,

	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Операция.Подразделение КАК ПодразделениеДт,
	|	Стоимости.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,

	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.МатериальныеЗатраты) КАК СубконтоДт1,
	|	Стоимости.Номенклатура КАК СубконтоДт2,
	|	Стоимости.ГруппаПродукции КАК СубконтоДт3,

	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	Стоимости.СуммаНУ КАК СуммаНУДт,
	|	Стоимости.СуммаПР КАК СуммаПРДт,
	|	Стоимости.СуммаВР КАК СуммаВРДт,
	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,

	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеКт,
	|	НЕОПРЕДЕЛЕНО КАК НаправлениеДеятельностиКт,

	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.Вспомогательный) КАК СчетКт,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,

	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	Стоимости.СуммаНУ КАК СуммаНУКт,
	|	Стоимости.СуммаПР КАК СуммаПРКт,
	|	Стоимости.СуммаВР КАК СуммаВРКт,
	|	""Ввод остатков материальных затрат партий производства"" КАК Содержание
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.НачальныеОстаткиНЗППоПартиямПроизводства КАК Операция
	|	ПО Операция.Ссылка = ДокументыКОтражению.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтСтоимости КАК Стоимости
	|	ПО Операция.Ссылка = Стоимости.Ссылка
	|
	|ГДЕ
	|	НЕ Стоимости.СуммаБалансовая = 0
	|		ИЛИ НЕ Стоимости.СуммаНУ = 0
	|";
	#КонецОбласти
	
	#Область ТекстНачальныеОстаткиНематериальныхЗатратПартийПроизводства // (Дт 2Х :: Кт 000)
	ТекстНачальныеОстаткиНематериальныхЗатратПартийПроизводства =
	// Начальные остатки партий производства (Дт 2Х :: Кт 000).
	"ВЫБРАТЬ
	|	НематериальныеЗатраты.Ссылка КАК Ссылка,
	|	НематериальныеЗатраты.Период КАК Период,
	|	НематериальныеЗатраты.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,

	|	НематериальныеЗатраты.Сумма КАК Сумма,
	|	НематериальныеЗатраты.СуммаУУ КАК СуммаУУ,

	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Производство) КАК ВидСчетаДт,
	|	НематериальныеЗатраты.ГруппаПродукции КАК АналитикаУчетаДт,
	|	НематериальныеЗатраты.Подразделение КАК МестоУчетаДт,

	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	НематериальныеЗатраты.Подразделение КАК ПодразделениеДт,
	|	НематериальныеЗатраты.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,

	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	НематериальныеЗатраты.ТипЗатрат КАК СубконтоДт1,
	|	НематериальныеЗатраты.Затрата КАК СубконтоДт2,
	|	НематериальныеЗатраты.ГруппаПродукции КАК СубконтоДт3,

	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	НематериальныеЗатраты.СуммаНУ КАК СуммаНУДт,
	|	НематериальныеЗатраты.СуммаПР КАК СуммаПРДт,
	|	НематериальныеЗатраты.СуммаВР КАК СуммаВРДт,
	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,

	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеКт,
	|	НЕОПРЕДЕЛЕНО КАК НаправлениеДеятельностиКт,

	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.Вспомогательный) КАК СчетКт,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,

	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	НематериальныеЗатраты.СуммаНУ КАК СуммаНУКт,
	|	НематериальныеЗатраты.СуммаПР КАК СуммаПРКт,
	|	НематериальныеЗатраты.СуммаВР КАК СуммаВРКт,
	|	""Ввод остатков нематериальных затрат партий производства"" КАК Содержание
	|ИЗ
	|	НематериальныеЗатраты КАК НематериальныеЗатраты
	|
	|ГДЕ
	|	НЕ НематериальныеЗатраты.Сумма = 0
	|		ИЛИ НЕ НематериальныеЗатраты.СуммаНУ = 0
	|";
	#КонецОбласти
	
	ТекстыЗапроса = Новый Массив;
	ТекстыЗапроса.Добавить(ТекстНачальныеОстаткиМатериаловПартийПроизводства);
	ТекстыЗапроса.Добавить(ТекстНачальныеОстаткиНематериальныхЗатратПартийПроизводства);
	
	Возврат СтрСоединить(ТекстыЗапроса, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());

	//-- Локализация
	
	Возврат "";
	
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламентированном учете
//
// Возвращаемое значение:
//   Строка - сформированный текст запроса.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	
	//++ Локализация
	
	ТекстЗапроса =
	// Формирование временной таблицы нематериальных затрат
	"ВЫБРАТЬ
	|	ПрочиеРасходыНЗП.Регистратор						КАК Ссылка,
	|	ПрочиеРасходыНЗП.Период								КАК Период,
	|	ПрочиеРасходыНЗП.Организация						КАК Организация,
	|	ПрочиеРасходыНЗП.Подразделение						КАК Подразделение,
	|	ЕСТЬNULL(Назначения.НаправлениеДеятельности,
	|		СпрПартииПроизводства.НаправлениеДеятельности)	КАК НаправлениеДеятельности,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее)		КАК ТипЗатрат,
	|	ПрочиеРасходыНЗП.СтатьяРасходов						КАК Затрата,
	|	ЕСТЬNULL(СпрПартииПроизводства.ГруппаПродукции,
	|		ЗНАЧЕНИЕ(Справочник.ГруппыАналитическогоУчетаНоменклатуры.ПустаяСсылка)) КАК ГруппаПродукции,
	|	СУММА(ПрочиеРасходыНЗП.СтоимостьРегл)				КАК Сумма,
	|	СУММА(ПрочиеРасходыНЗП.СтоимостьРегл
	|		- ПрочиеРасходыНЗП.ПостояннаяРазница
	|		- ПрочиеРасходыНЗП.ВременнаяРазница)			КАК СуммаНУ,
	|	СУММА(ПрочиеРасходыНЗП.СтоимостьУпр)				КАК СуммаУУ,
	|	СУММА(ПрочиеРасходыНЗП.ПостояннаяРазница)			КАК СуммаПР,
	|	СУММА(ПрочиеРасходыНЗП.ВременнаяРазница)			КАК СуммаВР
	|ПОМЕСТИТЬ НематериальныеЗатраты
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ПрочиеРасходыНезавершенногоПроизводства КАК ПрочиеРасходыНЗП
	|	ПО ПрочиеРасходыНЗП.Регистратор = ДокументыКОтражению.Ссылка
	|		И НЕ ПрочиеРасходыНЗП.Сторно
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПартииПроизводства КАК СпрПартииПроизводства
	|	ПО СпрПартииПроизводства.Ссылка = ПрочиеРасходыНЗП.ПартияПроизводства
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Назначения КАК Назначения
	|	ПО Назначения.Ссылка = СпрПартииПроизводства.Назначение
	|
	|СГРУППИРОВАТЬ ПО
	|	ПрочиеРасходыНЗП.Регистратор,
	|	ПрочиеРасходыНЗП.Период,
	|	ПрочиеРасходыНЗП.Организация,
	|	ПрочиеРасходыНЗП.Подразделение,
	|	ЕСТЬNULL(Назначения.НаправлениеДеятельности,
	|		СпрПартииПроизводства.НаправлениеДеятельности),
	|	ПрочиеРасходыНЗП.СтатьяРасходов,
	|	ЕСТЬNULL(СпрПартииПроизводства.ГруппаПродукции,
	|		ЗНАЧЕНИЕ(Справочник.ГруппыАналитическогоУчетаНоменклатуры.ПустаяСсылка))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТрудозатратыНЗП.Регистратор									КАК Ссылка,
	|	ТрудозатратыНЗП.Период										КАК Период,
	|	ТрудозатратыНЗП.Организация									КАК Организация,
	|	ТрудозатратыНЗП.Подразделение								КАК Подразделение,
	|	ЕСТЬNULL(Назначения.НаправлениеДеятельности,
	|		СпрПартииПроизводства.НаправлениеДеятельности)			КАК НаправлениеДеятельности,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.СдельнаяОплатаТруда)	КАК ТипЗатрат,
	|	ТрудозатратыНЗП.ВидРабот									КАК Затрата,
	|	ЕСТЬNULL(СпрПартииПроизводства.ГруппаПродукции,
	|		ЗНАЧЕНИЕ(Справочник.ГруппыАналитическогоУчетаНоменклатуры.ПустаяСсылка)) КАК ГруппаПродукции,
	|	СУММА(ТрудозатратыНЗП.СтоимостьРегл)						КАК Сумма,
	|	СУММА(ТрудозатратыНЗП.СтоимостьРегл)						КАК СуммаНУ,
	|	СУММА(ТрудозатратыНЗП.Стоимость)							КАК СуммаУУ,
	|	0															КАК СуммаПР,
	|	0															КАК СуммаВР
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТрудозатратыНезавершенногоПроизводства КАК ТрудозатратыНЗП
	|	ПО ТрудозатратыНЗП.Регистратор = ДокументыКОтражению.Ссылка
	|		И НЕ ТрудозатратыНЗП.Сторно
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПартииПроизводства КАК СпрПартииПроизводства
	|	ПО СпрПартииПроизводства.Ссылка = ТрудозатратыНЗП.ПартияПроизводства
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Назначения КАК Назначения
	|	ПО Назначения.Ссылка = СпрПартииПроизводства.Назначение
	|
	|СГРУППИРОВАТЬ ПО
	|	ТрудозатратыНЗП.Регистратор,
	|	ТрудозатратыНЗП.Период,
	|	ТрудозатратыНЗП.Организация,
	|	ТрудозатратыНЗП.Подразделение,
	|	ЕСТЬNULL(Назначения.НаправлениеДеятельности,
	|		СпрПартииПроизводства.НаправлениеДеятельности),
	|	ТрудозатратыНЗП.ВидРабот,
	|	ЕСТЬNULL(СпрПартииПроизводства.ГруппаПродукции,
	|		ЗНАЧЕНИЕ(Справочник.ГруппыАналитическогоУчетаНоменклатуры.ПустаяСсылка))
	|";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияУТ.РазделительЗапросовВПакете();
	
	//-- Локализация
	Возврат "";
	
КонецФункции

#КонецОбласти
//-- НЕ УТ

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса проведения.
//  Регистры - Строка, Структура - Список регистров проведения документа через запятую или в ключах структуры.
//
Процедура ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	//++ Локализация
	ТекстЗапросаТаблицаОтражениеДокументовВРеглУчете(Запрос, ТекстыЗапроса, Регистры);
	//-- Локализация
	
КонецПроцедуры

//++ Локализация

Функция ТекстЗапросаТаблицаОтражениеДокументовВРеглУчете(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОтражениеДокументовВРеглУчете";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Дата						КАК Период,
	|	&Организация				КАК Организация,
	|	НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ)	КАК ДатаОтражения
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

//-- Локализация

#КонецОбласти

#КонецОбласти
