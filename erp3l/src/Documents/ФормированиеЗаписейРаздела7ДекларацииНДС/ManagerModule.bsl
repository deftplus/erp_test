#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Подготавливает данные для заполнения документа
//
// Параметры:
//   СтруктураПараметров - Структура - структура входных параметров с ключами:
//     * Организация           - СправочникСсылка.Организация - организация, для которой будут получены данные для заполнения документа.
//     * Дата                  - Дата - дата, на которую будут получены данные для заполнения документа.
//   АдресХранилища - Строка - адрес временного хранилища для помещения результата выполнения.
Процедура ПодготовитьДанныеДляЗаполнения(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура;
	НеоблагаемыеНДСОперации = НовыйНеоблагаемыеНДСОперации();
	ПодтверждающиеДокументы = НовыйПодтверждающиеДокументы();
	
	ДанныеДляЗаполнения.Вставить("НеоблагаемыеНДСОперации",         НеоблагаемыеНДСОперации);
	ДанныеДляЗаполнения.Вставить("ПодтверждающиеДокументы",         ПодтверждающиеДокументы);
	
	Заполнение7РазделаДекларацииПоНДСПереопределяемый.ЗапросПоДаннымЗаполнения7РазделаДекларацииПоНДС(
		СтруктураПараметров, ДанныеДляЗаполнения); 
		
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

// Возвращает следующий по порядку ключ строки.
//
// Параметры:
//	НеоблагаемыеНДСОперации - ТабличнаяЧастьДокумента, ТаблицаЗначений - Таблица документа.
//
// Возвращаемое значение:
//	Число - Значение нового ключа строки.
//
Функция ПолучитьНовыйКлючСтроки(НеоблагаемыеНДСОперации) Экспорт
	
	Если НеоблагаемыеНДСОперации.Количество() = 0 Тогда
		Возврат 1;
	КонецЕсли;
	
	СписокКлючей = Новый СписокЗначений;
	СписокКлючей.ЗагрузитьЗначения(НеоблагаемыеНДСОперации.ВыгрузитьКолонку("КлючСтроки"));
	СписокКлючей.СортироватьПоЗначению(НаправлениеСортировки.Убыв);
	
	МаксимальныйКлюч = СписокКлючей[0].Значение;
	
	Возврат МаксимальныйКлюч + 1;
	
КонецФункции

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	МеханизмыДокумента.Добавить("УчетНДС");
	
КонецПроцедуры

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  Структура - коллекция элементов:
//     * Таблица<ИмяРегистра> - ТаблицаЗначений - таблица данных для отражения в регистр.
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Запрос			= Новый Запрос;
	ТекстыЗапроса	= Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		////////////////////////////////////////////////////////////////////////////
		// Создадим запрос инициализации движений
		
		Запрос.УстановитьПараметр("Ссылка", Документ);
		Запрос.УстановитьПараметр("КодыРеализацийНеНаТерриторииРФ", 
			Справочники.КодыОперацийРаздела7ДекларацииПоНДС.КодыРеализацииНеНаТерриторииРФ());
		Запрос.УстановитьПараметр("ПравилаЗаполненияДекларацииС4кв2020", 
			УчетНДС.ПравилаЗаполненияДекларацииС4кв2020(Документ.Дата));
		
		////////////////////////////////////////////////////////////////////////////
		// Сформируем текст запроса
		
		ТекстЗапросаНДСЗаписиРаздела7Декларации(Запрос, ТекстыЗапроса, Регистры);
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 23, 0);
	
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - ТаблицаЗначений - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.
//  Параметры - Структура - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - ТаблицаЗначений - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Возврат СозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Документы.ФормированиеЗаписейРаздела7ДекларацииНДС);
	
КонецФункции

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НовыйНеоблагаемыеНДСОперации()
	
	НеоблагаемыеНДСОперации = Новый ТаблицаЗначений;
	
	НеоблагаемыеНДСОперации.Колонки.Добавить("КодОперации", Новый ОписаниеТипов("СправочникСсылка.КодыОперацийРаздела7ДекларацииПоНДС"));
	НеоблагаемыеНДСОперации.Колонки.Добавить("ДокументРеализации", Документы.ТипВсеСсылки());
	НеоблагаемыеНДСОперации.Колонки.Добавить("Контрагент", Новый ОписаниеТипов("СправочникСсылка.Контрагенты,СправочникСсылка.Организации"));
	НеоблагаемыеНДСОперации.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	НеоблагаемыеНДСОперации.Колонки.Добавить("СуммаРеализации", ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
	НеоблагаемыеНДСОперации.Колонки.Добавить("СуммаПриобретения", ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
	НеоблагаемыеНДСОперации.Колонки.Добавить("НДСПрямой", ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
	НеоблагаемыеНДСОперации.Колонки.Добавить("НДСРаспределенный", ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
	НеоблагаемыеНДСОперации.Колонки.Добавить("КлючСтроки", ОбщегоНазначения.ОписаниеТипаЧисло(5));
	
	Возврат НеоблагаемыеНДСОперации;
	
КонецФункции

Функция НовыйПодтверждающиеДокументы()
	
	ПодтверждающиеДокументы = Новый ТаблицаЗначений;
	
	ПодтверждающиеДокументы.Колонки.Добавить("ТипДокумента", Новый ОписаниеТипов("СправочникСсылка.ТипыДокументов"));
	ПодтверждающиеДокументы.Колонки.Добавить("НомерДокумента", ОбщегоНазначения.ОписаниеТипаСтрока(50));
	ПодтверждающиеДокументы.Колонки.Добавить("ДатаДокумента", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	ПодтверждающиеДокументы.Колонки.Добавить("КлючСтроки", ОбщегоНазначения.ОписаниеТипаЧисло(5));
	
	Возврат ПодтверждающиеДокументы;
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;
	
	Возврат ИсточникиДанных; 

КонецФункции

Функция ТекстЗапросаНДСЗаписиРаздела7Декларации(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "НДСЗаписиРаздела7Декларации";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации,
		|	СУММА(ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.СуммаРеализации) КАК СуммаРеализации,
		|	СУММА(ВЫБОР
		|			КОГДА &ПравилаЗаполненияДекларацииС4кв2020
		|				ТОГДА ВЫБОР
		|						КОГДА ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации В (&КодыРеализацийНеНаТерриторииРФ)
		|							ТОГДА 0
		|						ИНАЧЕ ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.СуммаПриобретения
		|					КОНЕЦ
		|			КОГДА КодыОперацийРаздела7ДекларацииПоНДС.ОперацияНеПодлежитНалогообложению
		|				ТОГДА ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.СуммаПриобретения
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК СуммаПриобретения,
		|	СУММА(ВЫБОР
		|			КОГДА &ПравилаЗаполненияДекларацииС4кв2020
		|				ТОГДА ВЫБОР
		|						КОГДА ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации В (&КодыРеализацийНеНаТерриторииРФ)
		|							ТОГДА 0
		|						ИНАЧЕ ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.НДСПрямой + ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.НДСРаспределенный
		|					КОНЕЦ
		|			КОГДА КодыОперацийРаздела7ДекларацииПоНДС.ОперацияНеПодлежитНалогообложению
		|				ТОГДА ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.НДСПрямой + ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.НДСРаспределенный
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК СуммаНДС,
		|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Дата КАК Период,
		|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Ссылка КАК Регистратор,
		|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Организация
		|ИЗ
		|	Документ.ФормированиеЗаписейРаздела7ДекларацииНДС.НеоблагаемыеНДСОперации КАК ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КодыОперацийРаздела7ДекларацииПоНДС КАК КодыОперацийРаздела7ДекларацииПоНДС
		|		ПО ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации = КодыОперацийРаздела7ДекларацииПоНДС.Ссылка
		|ГДЕ
		|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации,
		|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Дата,
		|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Ссылка,
		|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Организация";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецЕсли