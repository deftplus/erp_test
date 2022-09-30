
#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	//++ Локализация
	//++ НЕ УТ
	МеханизмыДокумента.Добавить("РегламентированныйУчет");
	//-- НЕ УТ
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	//++ Локализация
	УчетПрослеживаемыхТоваровЛокализация.ПроверитьЗаполнениеКоличестваПоРНПТ(Объект, Отказ, Неопределено);
	//-- Локализация
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	
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
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина, то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПриЗаписи(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  ОбъектКопирования - ДокументОбъект - Исходный документ, который является источником копирования.
//
Процедура ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// Добавляет команду создания документа "Авансовый отчет".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Процедура ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	
КонецПроцедуры

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

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
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
	ТекстыОтражения = Новый Массив;
	
#Область ПоступлениеТоваровОтХранителя // (Дт 41.01 :: Кт 45.01)
	ТекстЗапроса = "
	|ВЫБРАТЬ //// Поступление товаров от хранителя (Дт 41.01 :: Кт 45.01)
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	ЕСТЬNULL(Стоимости.Сумма, Строки.Сумма) КАК Сумма,
	|	ЕСТЬNULL(Стоимости.СуммаУУ, Строки.СуммаУУ) КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.НаСкладе) КАК ВидСчетаДт,
	|	Строки.ГруппаФинансовогоУчета КАК АналитикаУчетаДт,
	|	Строки.КорСклад КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Строки.КорПодразделениеАналитики КАК ПодразделениеДт,
	|	Строки.КорНаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	Строки.Номенклатура КАК СубконтоДт1,
	|	Строки.КорСклад КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	Строки.Количество КАК КоличествоДт,
	|	ЕСТЬNULL(Стоимости.СуммаНУ, Строки.СуммаНУ) КАК СуммаНУДт,
	|	ЕСТЬNULL(Стоимости.СуммаПР, Строки.СуммаПР) КАК СуммаПРДт,
	|	ЕСТЬNULL(Стоимости.СуммаВР, Строки.СуммаВР) КАК СуммаВРДт,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.НоменклатураПереданная) КАК ВидСчетаКт,
	|	Строки.ГруппаФинансовогоУчета КАК АналитикаУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Строки.ПодразделениеАналитики КАК ПодразделениеКт,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|	Строки.Контрагент КАК СубконтоКт1,
	|	Строки.Номенклатура КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	Строки.Количество КАК КоличествоКт,
	|	ЕСТЬNULL(Стоимости.СуммаНУ, Строки.СуммаНУ) КАК СуммаНУКт,
	|	ЕСТЬNULL(Стоимости.СуммаПР, Строки.СуммаПР) КАК СуммаПРКт,
	|	ЕСТЬNULL(Стоимости.СуммаВР, Строки.СуммаВР) КАК СуммаВРКт,
	|	""Поступление товаров от хранителя"" КАК Содержание
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ПоступлениеТоваровОтХранителя КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВтСтроки КАК Строки
	|	ПО
	|		Строки.Ссылка = Операция.Ссылка
	|		И Строки.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ВтСтоимости КАК Стоимости
	|	ПО
	|		Строки.Ссылка = Стоимости.Ссылка
	|		И Строки.Номенклатура = Стоимости.Номенклатура
	|		И Строки.КорСклад = Стоимости.КорСклад
	|		И Строки.ГруппаФинансовогоУчета = Стоимости.ГруппаФинансовогоУчета
	|		И Строки.РазделУчета = Стоимости.РазделУчета
	|		И Строки.ИдентификаторСтроки = Стоимости.ИдентификаторСтроки
	|ГДЕ
	|	Строки.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.СобственныеТоварыПереданныеПартнерам)
	|	И Строки.КорРазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах)
	|	И (ВЫБОР
	|			КОГДА Операция.ВозвратПереданнойМногооборотнойТары
	|				ТОГДА Строки.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ)
	|";
	ТекстыОтражения.Добавить(ТекстЗапроса);
#КонецОбласти

#Область ПоступлениеТоваровОтХранителяСкладПроизводства // (Дт 20 :: Кт 45.01)
	ТекстЗапроса = "
	|ВЫБРАТЬ //// Поступление товаров от хранителя на производственный склад (Дт 20 :: Кт 45.01)
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	ЕСТЬNULL(Стоимости.Сумма, Строки.Сумма) КАК Сумма,
	|	ЕСТЬNULL(Стоимости.СуммаУУ, Строки.СуммаУУ) КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Производство) КАК ВидСчетаДт,
	|	Строки.КорГруппаПродукции КАК АналитикаУчетаДт,
	|	Строки.КорПодразделениеАналитики КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Строки.КорПодразделениеАналитики КАК ПодразделениеДт,
	|	Строки.КорНаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	Строки.Номенклатура КАК СубконтоДт1,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.МатериальныеЗатраты) КАК СубконтоДт2,
	|	ЕСТЬNULL(Стоимости.КорГруппаПродукции, Строки.КорГруппаПродукции) КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	Строки.Количество КАК КоличествоДт,
	|	ЕСТЬNULL(Стоимости.СуммаНУ, Строки.СуммаНУ) КАК СуммаНУДт,
	|	ЕСТЬNULL(Стоимости.СуммаПР, Строки.СуммаПР) КАК СуммаПРДт,
	|	ЕСТЬNULL(Стоимости.СуммаВР, Строки.СуммаВР) КАК СуммаВРДт,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.НоменклатураПереданная) КАК ВидСчетаКт,
	|	Строки.ГруппаФинансовогоУчета КАК АналитикаУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Строки.ПодразделениеАналитики КАК ПодразделениеКт,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|	Строки.Контрагент КАК СубконтоКт1,
	|	Строки.Номенклатура КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	Строки.Количество КАК КоличествоКт,
	|	ЕСТЬNULL(Стоимости.СуммаНУ, Строки.СуммаНУ) КАК СуммаНУКт,
	|	ЕСТЬNULL(Стоимости.СуммаПР, Строки.СуммаПР) КАК СуммаПРКт,
	|	ЕСТЬNULL(Стоимости.СуммаВР, Строки.СуммаВР) КАК СуммаВРКт,
	|	""Поступление товаров от хранителя"" КАК Содержание
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ПоступлениеТоваровОтХранителя КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВтСтроки КАК Строки
	|	ПО
	|		Строки.Ссылка = Операция.Ссылка
	|		И Строки.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ВтСтоимости КАК Стоимости
	|	ПО
	|		Строки.Ссылка = Стоимости.Ссылка
	|		И Строки.Номенклатура = Стоимости.Номенклатура
	|		И Строки.КорСклад = Стоимости.КорСклад
	|		И Строки.ГруппаФинансовогоУчета = Стоимости.ГруппаФинансовогоУчета
	|		И Строки.РазделУчета = Стоимости.РазделУчета
	|		И Строки.ИдентификаторСтроки = Стоимости.ИдентификаторСтроки
	|ГДЕ
	|	Строки.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.СобственныеТоварыПереданныеПартнерам)
	|	И Строки.КорРазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты)
	|	И (ВЫБОР
	|			КОГДА Операция.ВозвратПереданнойМногооборотнойТары
	|				ТОГДА Строки.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ)
	|";
	ТекстыОтражения.Добавить(ТекстЗапроса);
#КонецОбласти

#Область ВозвратХранителемПринятыхНаХранениеТоваров // (Дт 002.01 :: Кт 002.03)
	ТекстЗапроса = "
	|ВЫБРАТЬ //// Поступление от хранителя принятых на хранение товаров (Дт 002.01 :: Кт 002.03)
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	ЕСТЬNULL(Стоимости.Сумма, Строки.Сумма) КАК Сумма,
	|	ЕСТЬNULL(Стоимости.СуммаУУ, Строки.СуммаУУ) КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ТМЦНаСкладах) КАК ВидСчетаДт,
	|	Строки.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчетаДт,
	|	Строки.КорСклад КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Строки.КорПодразделениеАналитики КАК ПодразделениеДт, 
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиДт,
	|
	|	НЕОПРЕДЕЛЕНО КАК СчетДт,
	|	Строки.Номенклатура КАК СубконтоДт1,
	|	Строки.Контрагент КАК СубконтоДт2,
	|	Строки.КорСклад КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	Строки.Количество КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ТМЦУХранителей) КАК ВидСчетаКт,
	|	Строки.ГруппаФинансовогоУчета АналитикаУчетаКт,
	|	Строки.Склад КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Строки.ПодразделениеАналитики КАК ПодразделениеКт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиКт,
	|
	|	НЕОПРЕДЕЛЕНО КАК СчетКт,
	|	Строки.Номенклатура КАК СубконтоКт1,
	|	Строки.Контрагент КАК СубконтоКт2,
	|	Строки.Склад.Контрагент КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	Строки.Количество КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Поступление от хранителя принятых на хранение товаров"" КАК Содержание
	|
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ПоступлениеТоваровОтХранителя КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВтСтроки КАК Строки
	|	ПО
	|		Строки.Ссылка = Операция.Ссылка
	|		И Строки.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ВтСтоимости КАК Стоимости
	|	ПО
	|		Строки.Ссылка = Стоимости.Ссылка
	|		И Строки.Номенклатура = Стоимости.Номенклатура
	|		И Строки.Склад = Стоимости.Склад
	|		И Строки.ГруппаФинансовогоУчета = Стоимости.ГруппаФинансовогоУчета
	|		И Строки.РазделУчета = Стоимости.РазделУчета
	|		И Строки.ИдентификаторСтроки = Стоимости.ИдентификаторСтроки
	|ГДЕ
	|	Строки.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаХраненииСПравомПродажиПереданныеПартнерам)
	|";
	ТекстыОтражения.Добавить(ТекстЗапроса);
#КонецОбласти

	Возврат СтрСоединить(ТекстыОтражения, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
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
	//-- Локализация
	Возврат "";
	
КонецФункции

#КонецОбласти
//-- НЕ УТ

// Заполняет массив допустимых наименований входящих документов.
//
// Параметры:
//  МассивНаименований	 - Массив - массив наименования входящих документов.
//
Процедура ДополнитьНаименованияВходящихДокументов(МассивНаименований) Экспорт
	
КонецПроцедуры

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
	//++ НЕ УТ
	ТекстЗапросаТаблицаОтражениеДокументовВРеглУчете(Запрос, ТекстыЗапроса, Регистры);
	//-- НЕ УТ
	//-- Локализация
	
КонецПроцедуры

//++ Локализация

//++ НЕ УТ

Функция ТекстЗапросаТаблицаОтражениеДокументовВРеглУчете(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОтражениеДокументовВРеглУчете";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Период                      КАК Период,
	|	&Организация                 КАК Организация,
	|	НАЧАЛОПЕРИОДА(&Период, ДЕНЬ) КАК ДатаОтражения";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции
//-- НЕ УТ
//-- Локализация

//++ НЕ УТ
#Область ПроводкиРеглУчета

//++ Локализация

////////////////////////////////////////////////////////////////////////////////
// Проведение по регл. учету

//-- Локализация
#КонецОбласти
//-- НЕ УТ

#КонецОбласти

#Область Прочее

#КонецОбласти

#КонецОбласти
