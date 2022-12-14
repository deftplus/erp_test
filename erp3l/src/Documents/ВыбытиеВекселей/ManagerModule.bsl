#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных мханизмов.
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
		
		ВстраиваниеУХФинансовыеИнструменты.ПодготовитьЗапросФинансовыеИнструменты(Документ, Запрос, ТекстыЗапроса, Регистры);
		
		НомераТаблиц = Новый Структура;
		ТекстЗапроса = Новый Массив;
		ТекстЗапроса.Добавить(ТекстЗапросаРеквизитыДокумента(НомераТаблиц));
		Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВТ_ПараметрыОпераций", ТекстыЗапроса) Тогда
			ТекстЗапроса.Добавить(ТекстЗапросаПараметрыОпераций(НомераТаблиц));
		КонецЕсли;		
		ТекстЗапроса.Добавить(ТекстЗапроса_ТаблицаВекселя(НомераТаблиц));
		ТекстЗапроса.Добавить(ТекстЗапроса_ТаблицаГрафикИсходный(НомераТаблиц));
		ТекстЗапроса.Добавить(ТекстЗапроса_ТаблицаЗадолженностьПоГрафику( НомераТаблиц));
		ТекстЗапроса.Добавить(ТекстЗапроса_ТаблицаОперацииВекселя(НомераТаблиц));
		ТекстЗапроса.Добавить(ТекстЗапросаГрафикРасчетов(НомераТаблиц, "РасчетыСКонтрагентамиГрафики"));
		ТекстЗапроса.Добавить(ТекстЗапросаРасчетыСКонтрагентамиФакт(НомераТаблиц, "РасчетыСКонтрагентамиФакт"));
		
		ВстраиваниеУХ.ДополнитьТекстыЗапроса(ТекстыЗапроса, НомераТаблиц, ТекстЗапроса);
		
	КонецЕсли;

	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);

КонецФункции

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	ВстраиваниеУХФинансовыеИнструменты.ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента, Истина, Ложь);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц = Неопределено)

	Если НомераТаблиц <> Неопределено Тогда
		НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());	
	КонецЕсли;	
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Ссылка,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.Контрагент КАК Контрагент,
	|	Реквизиты.ВидОперации КАК ВидОперации,
	|	Реквизиты.ВалютаДокумента КАК ВалютаДокумента,
	|	Реквизиты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	Реквизиты.ФинансовыйИнструмент КАК ФинансовыйИнструмент,
	|	Реквизиты.ФинансовыйИнструмент.ПараметрыЦеннойБумаги.Векселедатель КАК Векселедатель,
	|	Реквизиты.ФинансовыйИнструмент.ПараметрыЦеннойБумаги.Должник КАК Должник,
	|	Реквизиты.ФинансовыйРезультат КАК ФинансовыйРезультат,
	|	Реквизиты.СуммаОперации КАК СуммаОперации,
	|	Реквизиты.ТекущаяСтоимость КАК ТекущаяСтоимость,
	|	ВЫБОР
	|		КОГДА Реквизиты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийВыбытиеВекселя.ПогашениеВекселя)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоВыданныйВексель,
	|	Реквизиты.ДоговорКонтрагента.ВидДоговораУХ В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.ВидыДоговоровКонтрагентовУХ.ПродажиИПокупки)) КАК ЭтоТорговыйВексель,
	|	Реквизиты.МоментВремени КАК МоментВремени,
	|	Реквизиты.Подразделение КАК Подразделение,
	|	Реквизиты.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	Реквизиты.ЦФО КАК ЦФО,
	|	Реквизиты.Проект КАК Проект,
	|	Реквизиты.ДоговорКонтрагента.ВидДоговораУХ КАК ВидДоговораУХ
	|ПОМЕСТИТЬ втРеквизиты
	|ИЗ
	|	Документ.ВыбытиеВекселей КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса;

КонецФункции

#Область ВзаиморасчетыУХ

Функция ПараметрыВзаиморасчеты(ДанныеЗаполнения) Экспорт 

	Возврат ВстраиваниеУХФинансовыеИнструменты.ПараметрыВзаиморасчетыУХ(ДанныеЗаполнения);	

КонецФункции

Функция ТекстЗапроса_ТаблицаВекселя(НомераТаблиц)

	НомераТаблиц.Вставить("ТаблицаВекселя", НомераТаблиц.Количество());
	
	Возврат
	"ВЫБРАТЬ
	|	ВерсииРасчетовСрезПоследних.ВерсияГрафика КАК ВерсияГрафика,
	|	ВерсииРасчетовСрезПоследних.ПредметГрафика КАК ПредметГрафика
	|ПОМЕСТИТЬ ТаблицаВекселя
	|ИЗ
	|	РегистрСведений.ВерсииРасчетов.СрезПоследних(
	|			&ПериодДоДокумента,
	|			Организация = &Организация
	|				И ПредметГрафика В
	|					(ВЫБРАТЬ
	|						т.ФинансовыйИнструмент
	|					ИЗ
	|						втРеквизиты КАК т)) КАК ВерсииРасчетовСрезПоследних";

КонецФункции

Функция ТекстЗапроса_ТаблицаГрафикИсходный(НомераТаблиц)

	НомераТаблиц.Вставить("ТаблицаГрафикИсходный", НомераТаблиц.Количество());
	
	Возврат
	"ВЫБРАТЬ
	|	РасчетыСКонтрагентамиГрафики.Период КАК Период,
	|	РасчетыСКонтрагентамиГрафики.Активность КАК Активность,
	|	РасчетыСКонтрагентамиГрафики.ВидДвижения КАК ВидДвижения,
	|	РасчетыСКонтрагентамиГрафики.ВерсияГрафика КАК ВерсияГрафика,
	|	РасчетыСКонтрагентамиГрафики.Организация КАК Организация,
	|	РасчетыСКонтрагентамиГрафики.Контрагент КАК Контрагент,
	|	РасчетыСКонтрагентамиГрафики.ПредметГрафика КАК ПредметГрафика,
	|	РасчетыСКонтрагентамиГрафики.ЭлементСтруктурыЗадолженности КАК ЭлементСтруктурыЗадолженности,
	|	РасчетыСКонтрагентамиГрафики.Валюта КАК Валюта,
	|	РасчетыСКонтрагентамиГрафики.Сумма КАК Сумма,
	|	РасчетыСКонтрагентамиГрафики.СтатьяБюджета КАК СтатьяБюджета,
	|	РасчетыСКонтрагентамиГрафики.ПриходРасход КАК ПриходРасход,
	|	РасчетыСКонтрагентамиГрафики.Операция КАК Операция,
	|	втРеквизиты.Векселедатель КАК Векселедатель,
	|	втРеквизиты.Должник КАК Должник,
	|	РасчетыСКонтрагентамиГрафики.Аналитика1 КАК Аналитика1,
	|	РасчетыСКонтрагентамиГрафики.Аналитика2 КАК Аналитика2,
	|	РасчетыСКонтрагентамиГрафики.Аналитика3 КАК Аналитика3,
	|	РасчетыСКонтрагентамиГрафики.Аналитика4 КАК Аналитика4,
	|	РасчетыСКонтрагентамиГрафики.Аналитика5 КАК Аналитика5,
	|	РасчетыСКонтрагентамиГрафики.Аналитика6 КАК Аналитика6,
	|	РасчетыСКонтрагентамиГрафики.ЦФО КАК ЦФО,
	|	РасчетыСКонтрагентамиГрафики.Проект КАК Проект,
	|	РасчетыСКонтрагентамиГрафики.ВидДоговораУХ КАК ВидДоговораУХ
	|ПОМЕСТИТЬ ТаблицаГрафикИсходный
	|ИЗ
	|	РегистрНакопления.РасчетыСКонтрагентамиГрафики КАК РасчетыСКонтрагентамиГрафики
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаВекселя КАК ТаблицаВекселя
	|		ПО РасчетыСКонтрагентамиГрафики.ВерсияГрафика = ТаблицаВекселя.ВерсияГрафика
	|			И РасчетыСКонтрагентамиГрафики.ПредметГрафика = ТаблицаВекселя.ПредметГрафика
	|			И (РасчетыСКонтрагентамиГрафики.Период < &Период)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втРеквизиты КАК втРеквизиты
	|		ПО (ИСТИНА)";

КонецФункции

Функция ТекстЗапроса_ТаблицаЗадолженностьПоГрафику(НомераТаблиц)

	НомераТаблиц.Вставить("ТаблицаЗадолженностьПоГрафику", НомераТаблиц.Количество());
	
	Возврат
	"ВЫБРАТЬ
	|	РасчетыСКонтрагентамиГрафикиОстатки.Организация КАК Организация,
	|	РасчетыСКонтрагентамиГрафикиОстатки.Контрагент КАК Контрагент,
	|	РасчетыСКонтрагентамиГрафикиОстатки.ПредметГрафика КАК ФинансовыйИнструмент,
	|	РасчетыСКонтрагентамиГрафикиОстатки.СуммаОстаток КАК ЗадолженностьПоГрафику,
	|	РасчетыСКонтрагентамиГрафикиОстатки.Валюта КАК Валюта
	|ПОМЕСТИТЬ ТаблицаЗадолженностьПоГрафику
	|ИЗ
	|	РегистрНакопления.РасчетыСКонтрагентамиГрафики.Остатки(
	|			&ПериодДоДокумента,
	|			(ВерсияГрафика, ПредметГрафика) В
	|				(ВЫБРАТЬ
	|					ТаблицаВекселя.ВерсияГрафика КАК ВерсияГрафика,
	|					ТаблицаВекселя.ПредметГрафика КАК ФинансовыйИнструмент
	|				ИЗ
	|					ТаблицаВекселя КАК ТаблицаВекселя)) КАК РасчетыСКонтрагентамиГрафикиОстатки";

КонецФункции

Функция ТекстЗапроса_ТаблицаОперацииВекселя(НомераТаблиц)

	НомераТаблиц.Вставить("ТаблицаОперацииВекселя", НомераТаблиц.Количество());
	
	Возврат
	"ВЫБРАТЬ
	|	ОперацииФинансовыхИнструментов.Ссылка КАК Операция,
	|	ОперацииФинансовыхИнструментов.ЭлементСтруктурыЗадолженности КАК ЭлементСтруктурыЗадолженности,
	|	ВЫБОР
	|		КОГДА ОперацииФинансовыхИнструментов.НаправлениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийПриходРасход.Приход)
	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	КОНЕЦ КАК ВидДвижения,
	|	ОперацииФинансовыхИнструментов.ВидБюджета КАК ВидБюджета,
	|	ОперацииФинансовыхИнструментов.НаправлениеДвижения КАК ПриходРасход,
	|	втРеквизиты.ЭтоВыданныйВексель КАК ЭтоВыданныйВексель,
	|	втРеквизиты.Контрагент КАК Контрагент,
	|	ОперацииФинансовыхИнструментов.ВидОперацииУХ КАК ВидОперацииУХ,
	|	ВТ_ПараметрыОпераций.СтатьяБюджета КАК СтатьяБюджета,
	|	ВТ_ПараметрыОпераций.Аналитика1 КАК Аналитика1,
	|	ВТ_ПараметрыОпераций.Аналитика2 КАК Аналитика2,
	|	ВТ_ПараметрыОпераций.Аналитика3 КАК Аналитика3,
	|	ВТ_ПараметрыОпераций.Аналитика4 КАК Аналитика4,
	|	ВТ_ПараметрыОпераций.Аналитика5 КАК Аналитика5,
	|	ВТ_ПараметрыОпераций.Аналитика6 КАК Аналитика6,
	|	втРеквизиты.ЦФО КАК ЦФО,
	|	втРеквизиты.Проект КАК Проект	
	|ПОМЕСТИТЬ ТаблицаОперацииВекселя
	|ИЗ
	|	Справочник.ОперацииГрафиковДоговоров КАК ОперацииФинансовыхИнструментов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ПараметрыОпераций КАК ВТ_ПараметрыОпераций
	|		ПО (ВТ_ПараметрыОпераций.ОперацияГрафика = ОперацииФинансовыхИнструментов.Ссылка)
	|	ЛЕВОЕ СОЕДИНЕНИЕ втРеквизиты КАК втРеквизиты ПО ИСТИНА
	|ГДЕ
	|	ОперацииФинансовыхИнструментов.Родитель = ВЫБОР
	|			КОГДА втРеквизиты.ЭтоВыданныйВексель
	|				ТОГДА ЗНАЧЕНИЕ(Справочник.ОперацииГрафиковДоговоров.ВексельВыданный)
	|			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ОперацииГрафиковДоговоров.ВексельПолученный)
	|		КОНЕЦ";

КонецФункции

Функция ТекстЗапросаГрафикРасчетов(НомераТаблиц, ИмяТаблицы)
	
	НомераТаблиц.Вставить(ИмяТаблицы, НомераТаблиц.Количество());
	
	Возврат 
	"ВЫБРАТЬ
	|	ТаблицаГрафикИсходный.Период КАК Период,
	|	ТаблицаГрафикИсходный.ВидДоговораУХ  КАК ВидДоговораУХ,
	|	ТаблицаГрафикИсходный.ВидДвижения КАК ВидДвижения,
	|	&Ссылка КАК ВерсияГрафика,
	|	ТаблицаГрафикИсходный.Организация КАК Организация,
	|	ТаблицаГрафикИсходный.Контрагент КАК Контрагент,
	|	ТаблицаГрафикИсходный.ПредметГрафика КАК ПредметГрафика,
	|	ТаблицаГрафикИсходный.ЭлементСтруктурыЗадолженности КАК ЭлементСтруктурыЗадолженности,
	|	ТаблицаГрафикИсходный.Валюта КАК Валюта,
	|	ТаблицаГрафикИсходный.Сумма КАК Сумма,
	|	ТаблицаГрафикИсходный.СтатьяБюджета КАК СтатьяБюджета,
	|	ТаблицаГрафикИсходный.ПриходРасход КАК ПриходРасход,
	|	ТаблицаГрафикИсходный.Операция КАК Операция,
	|	ТаблицаГрафикИсходный.ЦФО КАК ЦФО,
	|	ТаблицаГрафикИсходный.Проект КАК Проект,
	|	ТаблицаГрафикИсходный.Аналитика1 КАК Аналитика1,
	|	ТаблицаГрафикИсходный.Аналитика2 КАК Аналитика2,
	|	ТаблицаГрафикИсходный.Аналитика3 КАК Аналитика3,
	|	ТаблицаГрафикИсходный.Аналитика4 КАК Аналитика4,
	|	ТаблицаГрафикИсходный.Аналитика5 КАК Аналитика5,
	|	ТаблицаГрафикИсходный.Аналитика6 КАК Аналитика6	
	|ИЗ
	|	ТаблицаГрафикИсходный КАК ТаблицаГрафикИсходный
	|ГДЕ
	|	НЕ ТаблицаГрафикИсходный.Операция В (ЗНАЧЕНИЕ(Справочник.ОперацииГрафиковДоговоров.ВексельВыданный_ПогашениеВекселя), ЗНАЧЕНИЕ(Справочник.ОперацииГрафиковДоговоров.ВексельПолученный_ПогашениеВекселя))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Период,
	|	NULL,
	|	ТаблицаОперацииВекселя.ВидДвижения,
	|	&Ссылка,
	|	ТаблицаЗадолженностьПоГрафику.Организация,
	|	ТаблицаЗадолженностьПоГрафику.Контрагент,
	|	ТаблицаЗадолженностьПоГрафику.ФинансовыйИнструмент,
	|	ТаблицаОперацииВекселя.ЭлементСтруктурыЗадолженности,
	|	ТаблицаЗадолженностьПоГрафику.Валюта,
	|	ТаблицаЗадолженностьПоГрафику.ЗадолженностьПоГрафику,
	|	ТаблицаОперацииВекселя.СтатьяБюджета,
	|	ТаблицаОперацииВекселя.ПриходРасход,
	|	ТаблицаОперацииВекселя.Операция,
	|	ТаблицаОперацииВекселя.ЦФО,
	|	ТаблицаОперацииВекселя.Проект,
	|	ТаблицаОперацииВекселя.Аналитика1,
	|	ТаблицаОперацииВекселя.Аналитика2,
	|	ТаблицаОперацииВекселя.Аналитика3,
	|	ТаблицаОперацииВекселя.Аналитика4,
	|	ТаблицаОперацииВекселя.Аналитика5,
	|	ТаблицаОперацииВекселя.Аналитика6	
	|ИЗ
	|	ТаблицаЗадолженностьПоГрафику КАК ТаблицаЗадолженностьПоГрафику
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОперацииВекселя КАК ТаблицаОперацииВекселя
	|		ПО (ТаблицаОперацииВекселя.Операция = ВЫБОР
	|				КОГДА ТаблицаОперацииВекселя.ЭтоВыданныйВексель
	|					ТОГДА ЗНАЧЕНИЕ(Справочник.ОперацииГрафиковДоговоров.ВексельВыданный_ПогашениеВекселя)
	|				ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ОперацииГрафиковДоговоров.ВексельПолученный_ПогашениеВекселя)
	|			КОНЕЦ)
	|ГДЕ
	|	ТаблицаЗадолженностьПоГрафику.Контрагент <> ТаблицаОперацииВекселя.Контрагент
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	втРеквизиты.Период,
	|	втРеквизиты.ВидДоговораУХ,
	|	ТаблицаОперацииВекселя.ВидДвижения,
	|	втРеквизиты.Ссылка,
	|	ТаблицаЗадолженностьПоГрафику.Организация,
	|	втРеквизиты.Контрагент,
	|	ТаблицаЗадолженностьПоГрафику.ФинансовыйИнструмент,
	|	ТаблицаОперацииВекселя.ЭлементСтруктурыЗадолженности,
	|	ТаблицаЗадолженностьПоГрафику.Валюта,
	|	ТаблицаЗадолженностьПоГрафику.ЗадолженностьПоГрафику,
	|	ТаблицаОперацииВекселя.СтатьяБюджета,
	|	ТаблицаОперацииВекселя.ПриходРасход,
	|	ТаблицаОперацииВекселя.Операция,
	|	ТаблицаОперацииВекселя.ЦФО,
	|	ТаблицаОперацииВекселя.Проект,
	|	ТаблицаОперацииВекселя.Аналитика1,
	|	ТаблицаОперацииВекселя.Аналитика2,
	|	ТаблицаОперацииВекселя.Аналитика3,
	|	ТаблицаОперацииВекселя.Аналитика4,
	|	ТаблицаОперацииВекселя.Аналитика5,
	|	ТаблицаОперацииВекселя.Аналитика6	
	|ИЗ
	|	ТаблицаЗадолженностьПоГрафику КАК ТаблицаЗадолженностьПоГрафику
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОперацииВекселя КАК ТаблицаОперацииВекселя
	|		ПО (ТаблицаОперацииВекселя.Операция = ВЫБОР
	|				КОГДА ТаблицаОперацииВекселя.ЭтоВыданныйВексель
	|					ТОГДА ЗНАЧЕНИЕ(Справочник.ОперацииГрафиковДоговоров.ВексельВыданный_ВыдачаВекселя)
	|				ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ОперацииГрафиковДоговоров.ВексельПолученный_ПолучениеВекселя)
	|			КОНЕЦ)
	|		ЛЕВОЕ СОЕДИНЕНИЕ втРеквизиты КАК втРеквизиты
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ТаблицаЗадолженностьПоГрафику.Контрагент <> втРеквизиты.Контрагент
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	втРеквизиты.Период,
	|	втРеквизиты.ВидДоговораУХ,
	|	ТаблицаОперацииВекселя.ВидДвижения,
	|	втРеквизиты.Ссылка,
	|	ТаблицаЗадолженностьПоГрафику.Организация,
	|	втРеквизиты.Контрагент,
	|	ТаблицаЗадолженностьПоГрафику.ФинансовыйИнструмент,
	|	ТаблицаОперацииВекселя.ЭлементСтруктурыЗадолженности,
	|	ТаблицаЗадолженностьПоГрафику.Валюта,
	|	втРеквизиты.ТекущаяСтоимость - ТаблицаЗадолженностьПоГрафику.ЗадолженностьПоГрафику,
	|	ТаблицаОперацииВекселя.СтатьяБюджета,
	|	ТаблицаОперацииВекселя.ПриходРасход,
	|	ТаблицаОперацииВекселя.Операция,
	|	ТаблицаОперацииВекселя.ЦФО,
	|	ТаблицаОперацииВекселя.Проект,
	|	ТаблицаОперацииВекселя.Аналитика1,
	|	ТаблицаОперацииВекселя.Аналитика2,
	|	ТаблицаОперацииВекселя.Аналитика3,
	|	ТаблицаОперацииВекселя.Аналитика4,
	|	ТаблицаОперацииВекселя.Аналитика5,
	|	ТаблицаОперацииВекселя.Аналитика6	
	|ИЗ
	|	ТаблицаЗадолженностьПоГрафику КАК ТаблицаЗадолженностьПоГрафику
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОперацииВекселя КАК ТаблицаОперацииВекселя
	|		ПО (ТаблицаОперацииВекселя.Операция = ВЫБОР
	|				КОГДА ТаблицаОперацииВекселя.ЭтоВыданныйВексель
	|					ТОГДА ЗНАЧЕНИЕ(Справочник.ОперацииГрафиковДоговоров.ВексельВыданный_НачислениеРасхода)
	|				ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ОперацииГрафиковДоговоров.ВексельПолученный_НачислениеДохода)
	|			КОНЕЦ)
	|		ЛЕВОЕ СОЕДИНЕНИЕ втРеквизиты КАК втРеквизиты
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ТаблицаЗадолженностьПоГрафику.ЗадолженностьПоГрафику <> втРеквизиты.ТекущаяСтоимость
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	втРеквизиты.Период,
	|	втРеквизиты.ВидДоговораУХ,
	|	ТаблицаОперацииВекселя.ВидДвижения,
	|	втРеквизиты.Ссылка,
	|	втРеквизиты.Организация,
	|	втРеквизиты.Контрагент,
	|	втРеквизиты.ФинансовыйИнструмент,
	|	ТаблицаОперацииВекселя.ЭлементСтруктурыЗадолженности,
	|	втРеквизиты.ВалютаДокумента,
	|	втРеквизиты.СуммаОперации,
	|	ТаблицаОперацииВекселя.СтатьяБюджета,
	|	ТаблицаОперацииВекселя.ПриходРасход,
	|	ТаблицаОперацииВекселя.Операция,
	|	ТаблицаОперацииВекселя.ЦФО,
	|	ТаблицаОперацииВекселя.Проект,
	|	ТаблицаОперацииВекселя.Аналитика1,
	|	ТаблицаОперацииВекселя.Аналитика2,
	|	ТаблицаОперацииВекселя.Аналитика3,
	|	ТаблицаОперацииВекселя.Аналитика4,
	|	ТаблицаОперацииВекселя.Аналитика5,
	|	ТаблицаОперацииВекселя.Аналитика6	
	|ИЗ
	|	ТаблицаОперацииВекселя КАК ТаблицаОперацииВекселя
	|		ЛЕВОЕ СОЕДИНЕНИЕ втРеквизиты КАК втРеквизиты
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ТаблицаОперацииВекселя.Операция = ВЫБОР
	|			КОГДА втРеквизиты.ЭтоВыданныйВексель
	|				ТОГДА ЗНАЧЕНИЕ(Справочник.ОперацииГрафиковДоговоров.ВексельВыданный_ПогашениеВекселя)
	|			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ОперацииГрафиковДоговоров.ВексельПолученный_ПогашениеВекселя)
	|		КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	втРеквизиты.Период,
	|	втРеквизиты.ВидДоговораУХ,
	|	ТаблицаОперацииВекселя.ВидДвижения,
	|	втРеквизиты.Ссылка,
	|	втРеквизиты.Организация,
	|	втРеквизиты.Контрагент,
	|	втРеквизиты.ФинансовыйИнструмент,
	|	ТаблицаОперацииВекселя.ЭлементСтруктурыЗадолженности,
	|	втРеквизиты.ВалютаДокумента,
	|	ВЫБОР
	|		КОГДА втРеквизиты.ФинансовыйРезультат > 0
	|			ТОГДА втРеквизиты.ФинансовыйРезультат
	|		ИНАЧЕ -втРеквизиты.ФинансовыйРезультат
	|	КОНЕЦ,
	|	ТаблицаОперацииВекселя.СтатьяБюджета,
	|	ТаблицаОперацииВекселя.ПриходРасход,
	|	ТаблицаОперацииВекселя.Операция,
	|	ТаблицаОперацииВекселя.ЦФО,
	|	ТаблицаОперацииВекселя.Проект,
	|	ТаблицаОперацииВекселя.Аналитика1,
	|	ТаблицаОперацииВекселя.Аналитика2,
	|	ТаблицаОперацииВекселя.Аналитика3,
	|	ТаблицаОперацииВекселя.Аналитика4,
	|	ТаблицаОперацииВекселя.Аналитика5,
	|	ТаблицаОперацииВекселя.Аналитика6	
	|ИЗ
	|	ТаблицаОперацииВекселя КАК ТаблицаОперацииВекселя
	|		ЛЕВОЕ СОЕДИНЕНИЕ втРеквизиты КАК втРеквизиты
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ТаблицаОперацииВекселя.Операция = ВЫБОР
	|			КОГДА втРеквизиты.ФинансовыйРезультат > 0
	|				ТОГДА ЗНАЧЕНИЕ(Справочник.ОперацииГрафиковДоговоров.ВексельПолученный_ПрибыльОтПокупкиПродажи)
	|			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ОперацииГрафиковДоговоров.ВексельПолученный_УбытокОтПокупкиПродажи)
	|		КОНЕЦ
	|	И втРеквизиты.ФинансовыйРезультат <> 0";
	
КонецФункции

Функция ТекстЗапросаРасчетыСКонтрагентамиФакт(НомераТаблиц, ИмяТаблицы)
	
	НомераТаблиц.Вставить(ИмяТаблицы, НомераТаблиц.Количество());
	
	Возврат 
	"ВЫБРАТЬ
	|	втРеквизиты.Период КАК Период,
	|	втРеквизиты.ВидДоговораУХ КАК ВидДоговораУХ,
	|	втРеквизиты.Организация КАК Организация,
	|	втРеквизиты.Контрагент КАК Контрагент,
	|	втРеквизиты.ВалютаДокумента КАК Валюта,
	|	втРеквизиты.ДоговорКонтрагента КАК ОбъектРасчетов,
	|	втРеквизиты.СуммаОперации КАК Сумма,
	|	NULL КАК Операция,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ЗНАЧЕНИЕ(Перечисление.ЭлементыСтруктурыЗадолженности.ОсновнойДолг) КАК ЭлементСтруктурыЗадолженности,
	|	NULL КАК СтатьяБюджета,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийПриходРасход.ПустаяСсылка) КАК ПриходРасход
	|ИЗ втРеквизиты КАК втРеквизиты 
	|ГДЕ
	|	втРеквизиты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийВыбытиеВекселя.ПродажаВекселя)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Период,
	|	втРеквизиты.ВидДоговораУХ,
	|	РасчетыСКонтрагентамиФактОстатки.Организация,
	|	РасчетыСКонтрагентамиФактОстатки.Контрагент,
	|	РасчетыСКонтрагентамиФактОстатки.Валюта,
	|	РасчетыСКонтрагентамиФактОстатки.ОбъектРасчетов,
	|	РасчетыСКонтрагентамиФактОстатки.СуммаОстаток,
	|	NULL,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	|	РасчетыСКонтрагентамиФактОстатки.ЭлементСтруктурыЗадолженности,
	|	NULL,
	|	NULL
	|ИЗ
	|	РегистрНакопления.РасчетыСКонтрагентамиФакт.Остатки(
	|			&ПериодДоДокумента,
	|			Организация = &Организация
	|				И ОбъектРасчетов В (ВЫБРАТЬ т.ФинансовыйИнструмент ИЗ втРеквизиты КАК т)) КАК РасчетыСКонтрагентамиФактОстатки
	|	ЛЕВОЕ СОЕДИНЕНИЕ втРеквизиты КАК втРеквизиты ПО ИСТИНА
	|ГДЕ
	|	втРеквизиты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийВыбытиеВекселя.ПродажаВекселя)";
	
КонецФункции

Функция ТекстЗапросаПараметрыОпераций(НомераТаблиц)

	НомераТаблиц.Вставить("ВТ_ПараметрыОпераций", НомераТаблиц.Количество());
		
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ПараметрыОпераций.ОперацияГрафика КАК ОперацияГрафика,
	|	ПараметрыОпераций.СтатьяБюджета КАК СтатьяБюджета,
	|	ПараметрыОпераций.Аналитика1 КАК Аналитика1,
	|	ПараметрыОпераций.Аналитика2 КАК Аналитика2,
	|	ПараметрыОпераций.Аналитика3 КАК Аналитика3,
	|	ПараметрыОпераций.Аналитика4 КАК Аналитика4,
	|	ПараметрыОпераций.Аналитика5 КАК Аналитика5,
	|	ПараметрыОпераций.Аналитика6 КАК Аналитика6
	|ПОМЕСТИТЬ ВТ_ПараметрыОпераций
	|ИЗ
	|	Документ.ВыбытиеВекселей.ПараметрыОпераций КАК ПараметрыОпераций
	|ГДЕ
	|	ПараметрыОпераций.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти

#Область ПроводкиРСБУ

Функция ТекстЗапроса_Проводки(НомераТаблиц, ВидОперации = Неопределено) Экспорт
	
	ТекстПроводки = Новый Массив;	
	НомераТаблиц.Вставить("втТаблицаПроводок", НомераТаблиц.Количество());
	
	//ПогашениеВекселя//должник : не делаем проводок
	
	ТекстПроводки.Добавить(ТекстЗапроса_ПогашениеЗадолженностиВекселем());//ПродажаВекселя//Векселедержатель	
	ТекстПроводки.Добавить(ТекстЗапроса_СписаниеСтоимостиДисконта());//ПродажаВекселя//Векселедержатель	
	ТекстПроводки.Добавить(ТекстЗапроса_СписаниеДБП());//ПродажаВекселя//Векселедержатель	
	ТекстПроводки.Добавить(ТекстЗапроса_ДоходОтПередачиВекселя());//ПродажаВекселя//Векселедержатель
	ТекстПроводки.Добавить(ТекстЗапроса_ПредъявлениеКПогашению());	//ПредъявлениеВекселяКПогашению //Векселедержатель

	
	Разделитель = "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|";
	
	Возврат СтрСоединить(ТекстПроводки, Разделитель);

КонецФункции

#Область ПродажаВекселя

Функция ТекстЗапроса_ПогашениеЗадолженностиВекселем()

	Возврат
	"ВЫБРАТЬ
	|	втОстатки.ФинансовыйИнструмент КАК ФинансовыйИнструмент,
	|	втОстатки.Дата КАК Период,
	|	втОстатки.Валюта КАК Валюта,
	|	втОстатки.КоличествоОстаток КАК Количество,
	|	втОстатки.СуммаОстаток КАК Сумма,
	|	ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетРасходовОтВыбытия) КАК СчетДт,
	|	ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетУчетаФИ) КАК СчетКт,
	|	""Списание стоимости приобретения векселя"" КАК Комментарий
	|ПОМЕСТИТЬ втТаблицаПроводок
	|ИЗ
	|	втОстатки КАК втОстатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втСчетаДокумента КАК втСчетаДокумента
	|		ПО втОстатки.Счет = втСчетаДокумента.Счет
	|			И (втСчетаДокумента.ВидСчетаФИ = ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетУчетаФИ))
	|ГДЕ
	|	втОстатки.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийВыбытиеВекселя.ПродажаВекселя)";

КонецФункции

Функция ТекстЗапроса_СписаниеСтоимостиДисконта()

	Возврат
	"ВЫБРАТЬ
	|	втОстатки.ФинансовыйИнструмент КАК ФинансовыйИнструмент,
	|	втОстатки.Дата КАК Период,
	|	втОстатки.Валюта КАК Валюта,
	|	втОстатки.КоличествоОстаток КАК Количество,
	|	втОстатки.СуммаОстаток КАК Сумма,
	|	ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетРасходовОтВыбытия) КАК СчетДт,
	|	втСчетаДокумента.ВидСчетаФИ КАК СчетКт,
	|	ВЫБОР
	|		КОГДА втОстатки.СуммаОстаток > 0
	|			ТОГДА ""Списание с учета дисконта векселя""
	|		ИНАЧЕ ""Списание с учета премии по векселю""
	|	КОНЕЦ КАК Комментарий
	|ИЗ
	|	втОстатки КАК втОстатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втСчетаДокумента КАК втСчетаДокумента
	|		ПО втОстатки.Счет = втСчетаДокумента.Счет
	|			И (втСчетаДокумента.ВидСчетаФИ = ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетУчетаДисконта))
	|			И (НЕ втОстатки.Счет В
	|					(ВЫБРАТЬ
	|						т.Счет
	|					ИЗ
	|						втСчетаДокумента КАК т
	|					ГДЕ
	|						т.ВидСчетаФИ = ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетУчетаФИ)))
	|ГДЕ
	|	втОстатки.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийВыбытиеВекселя.ПродажаВекселя)";

КонецФункции

Функция ТекстЗапроса_СписаниеДБП()

	Возврат
	"ВЫБРАТЬ
	|	втСобытия.ФинансовыйИнструмент КАК ФинансовыйИнструмент,
	|	втСобытия.Дата КАК Период,
	|	ЕСТЬNULL(втОстатки.Валюта, &ВалютаРегламентированногоУчета) КАК Валюта,
	|	втОстатки.КоличествоОстаток КАК Количество,
	|	ВЫБОР
	|		КОГДА втОстатки.СуммаОстаток > 0
	|			ТОГДА втОстатки.СуммаОстаток
	|		ИНАЧЕ -втОстатки.СуммаОстаток
	|	КОНЕЦ КАК Сумма,
	|	ВЫБОР
	|		КОГДА втОстатки.СуммаОстаток > 0
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетРасходовОтВыбытия)
	|		ИНАЧЕ втСчетаДокумента.ВидСчетаФИ
	|	КОНЕЦ КАК СчетДт,
	|	ВЫБОР
	|		КОГДА втОстатки.СуммаОстаток > 0
	|			ТОГДА втСчетаДокумента.ВидСчетаФИ
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетДоходовОтВыбытия)
	|	КОНЕЦ КАК СчетКт,
	|	ВЫБОР
	|		КОГДА втОстатки.СуммаОстаток > 0
	|			ТОГДА ""Списание доходов будущих периодов по дисконту векселя""
	|		ИНАЧЕ ""Списание расходов будущих периодов по дисконту векселя""
	|	КОНЕЦ КАК Комментарий
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&ПериодДоДокумента,
	|			Счет В
	|				(ВЫБРАТЬ
	|					т.Счет
	|				ИЗ
	|					втСчетаДокумента КАК т
	|				ГДЕ
	|					т.ВидСчетаФИ В (ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетДБП), ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетРБП))),
	|			,
	|			Организация = &Организация
	|				И Субконто1 В
	|					(ВЫБРАТЬ
	|						т.Субконто1
	|					ИЗ
	|						втСчетаДокумента КАК т
	|					ГДЕ
	|						ТИПЗНАЧЕНИЯ(т.Субконто1) В (&ТипСсылкаРБП, ТИП(Справочник.ДоходыБудущихПериодов))
	|						И НЕ т.Субконто1 В (&ПустаяСсылкаРБП, ЗНАЧЕНИЕ(Справочник.ДоходыБудущихПериодов.ПустаяСсылка), НЕОПРЕДЕЛЕНО))) КАК втОстатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втСчетаДокумента КАК втСчетаДокумента
	|		ПО втОстатки.Счет = втСчетаДокумента.Счет
	|			И (втСчетаДокумента.ВидСчетаФИ В (ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетДБП), ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетРБП)))
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втСобытия КАК втСобытия
	|		ПО (ИСТИНА)
	|ГДЕ
	|	втСобытия.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийВыбытиеВекселя.ПродажаВекселя)";

КонецФункции

Функция ТекстЗапроса_ДоходОтПередачиВекселя()

	Возврат
	"ВЫБРАТЬ
	|	т.ФинансовыйИнструмент КАК ФинансовыйИнструмент,
	|	т.Дата КАК Период,
	|	т.ВалютаДокумента КАК Валюта,
	|	1 КАК Количество,
	|	т.СуммаОперации КАК Сумма,
	|	ВЫБОР
	|		КОГДА т.ДоговорКонтрагента.ВидДоговораУХ В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.ВидыДоговоровКонтрагентовУХ.ПродажиИПокупки))
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетУчетаФИ)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетВзаиморасчетов)
	|	КОНЕЦ КАК СчетДт,
	|	ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетДоходовОтВыбытия) КАК СчетКт,
	|	""Доход от реализации векселя"" КАК Комментарий
	|ИЗ
	|	Документ.ВыбытиеВекселей КАК т
	|ГДЕ
	|	т.Ссылка = &Ссылка
	|	И т.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийВыбытиеВекселя.ПродажаВекселя)";

КонецФункции

#КонецОбласти

#Область ПредъявлениеВекселяКПогашению

Функция ТекстЗапроса_ПредъявлениеКПогашению()

	Возврат
	"ВЫБРАТЬ
	|	втОстатки.ФинансовыйИнструмент КАК ФинансовыйИнструмент,
	|	втОстатки.Дата КАК Период,
	|	втОстатки.Валюта КАК Валюта,
	|	1 КАК Количество,
	|	втОстатки.СуммаОстаток КАК Сумма,
	|	ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетУчетаФИ) КАК СчетДт,
	|	ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетУчетаДисконта) КАК СчетКт,
	|	""Перенос дисконта на счет учета ценной бумаги"" КАК Комментарий
	|ИЗ
	|	втОстатки КАК втОстатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втСчетаДокумента КАК втСчетаДокумента
	|		ПО втОстатки.Счет = втСчетаДокумента.Счет
	|			И (втСчетаДокумента.ВидСчетаФИ = ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетУчетаДисконта))
	|			И (НЕ втОстатки.Счет В
	|					(ВЫБРАТЬ
	|						т.Счет
	|					ИЗ
	|						втСчетаДокумента КАК т
	|					ГДЕ
	|						т.ВидСчетаФИ = ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетУчетаФИ)))
	|ГДЕ
	|	втОстатки.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийВыбытиеВекселя.ПредъявлениеВекселяКПогашению)";

КонецФункции

#КонецОбласти

#КонецОбласти

Функция ТекстЗапроса_СчетаДокумента(НомераТаблиц) Экспорт

	НомераТаблиц.Вставить("втСчетаДокумента", НомераТаблиц.Количество());
	
	Возврат
	"ВЫБРАТЬ
	|	т.Ссылка.ФинансовыйИнструмент КАК ФинансовыйИнструмент,
	|	т.Ссылка КАК Ссылка,
	|	т.ВидСчетаФИ КАК ВидСчетаФИ,
	|	т.Счет КАК Счет,
	|	т.Субконто1 КАК Субконто1,
	|	т.Субконто2 КАК Субконто2,
	|	т.Субконто3 КАК Субконто3
	|ПОМЕСТИТЬ втСчетаДокумента
	|ИЗ
	|	Документ.ВыбытиеВекселей.СчетаУчета КАК т
	|ГДЕ
	|	т.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Документ.ФинансовыйИнструмент,
	|	Документ.Ссылка,
	|	ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетВзаиморасчетов),
	|	Документ.СчетВзаиморасчетов,
	|	NULL,
	|	NULL,
	|	NULL
	|ИЗ
	|	Документ.ВыбытиеВекселей КАК Документ
	|ГДЕ
	|	Документ.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	т.Ссылка.ФинансовыйИнструмент,
	|	т.Ссылка,
	|	т.ВидСчетаФИ,
	|	т.Счет,
	|	т.Субконто1,
	|	т.Субконто2,
	|	т.Субконто3
	|ИЗ
	|	Документ.ПоступлениеВекселя.СчетаУчета КАК т
	|ГДЕ
	|	т.Ссылка В
	|			(ВЫБРАТЬ ПЕРВЫЕ 1
	|				ВерсииРасчетовСрезПоследних.ВерсияГрафика КАК ВерсияГрафика
	|			ИЗ
	|				РегистрСведений.ВерсииРасчетов.СрезПоследних(&ПериодДоДокумента, Организация = &Организация
	|					И ПредметГрафика В
	|						(ВЫБРАТЬ
	|							т.ФинансовыйИнструмент
	|						ИЗ
	|							втСобытия КАК т)
	|					И ВерсияГрафика ССЫЛКА Документ.ПоступлениеВекселя) КАК ВерсииРасчетовСрезПоследних)"

КонецФункции

#КонецОбласти
	
#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Подразделение)";

КонецПроцедуры

#Область Отчеты

// Заполняет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	ФинансовыеИнструментыУХ.ДобавитьКомандыОтчетовФИ(КомандыОтчетов, Параметры);
КонецПроцедуры

#КонецОбласти

#Область СозданиеНаОсновании

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Документы.АкцептПротестПереводногоВекселя.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Документы.ВыбытиеВекселей.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Документы.ПоступлениеВекселя.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
	ВстраиваниеУХФинансовыеИнструменты.ДобавитьКомандыСозданияНаОсновании_ВариантыОплат(КомандыСозданияНаОсновании, Параметры);
	
КонецПроцедуры

// Добавляет команду создания документа "Реализация услуг и прочих активов".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	ТекущиеМД = ПустаяСсылка().Метаданные();
	
	Если ПравоДоступа("Добавление", ТекущиеМД) Тогда
		
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = ТекущиеМД.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначения.ПредставлениеОбъекта(ТекущиеМД);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;

	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли