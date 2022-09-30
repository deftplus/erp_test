#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс
	
#Область СтандартныеПодсистемыКоманды

// Добавляет команду создания объекта на основании.
// 
// Параметры:
// 	КомандыСозданияНаОсновании - ТаблицаЗначений - перечень команд
// Возвращаемое значение:
// 	Неопределено, СтрокаТаблицыЗначений - Добавленная Команда.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	МетаданныеДокумента = ПустаяСсылка().Метаданные();
	
	Если ПравоДоступа("Добавление", МетаданныеДокумента) Тогда
		
		КомандаСоздатьНаОсновании						= КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер				= МетаданныеДокумента.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление			= ОбщегоНазначения.ПредставлениеОбъекта(МетаданныеДокумента);
		КомандаСоздатьНаОсновании.РежимЗаписи			= "Записывать";
		КомандаСоздатьНаОсновании.ФункциональныеОпции	= "ИспользоватьЗаявкиНаКорректировкуЛимитов";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Заполняет список команд создания на основании.
// 
// Параметры:
// 	КомандыСозданияНаОсновании - ТаблицаЗначений - перечень команд
// 	Параметры - Структура - параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	Документы.КорректировкаЛимитов.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьТаблицыПоДокументуОснованию(Объект, Источник) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.Проведен = ИСТИНА Тогда
		ТекстСообщения = НСтр("ru = 'Документ основание должен быть не проведенным'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	//
	Менеджер = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Источник.Ссылка);
	Попытка
		ТаблицаПланов = Менеджер.ПланыДокумента(Источник);
	Исключение
	    Возврат;
	КонецПопытки;
	
	Объект.Планы.Загрузить(ТаблицаПланов);
	
	//
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Объект.Основание);
	
	Если ТаблицаПланов.Колонки.Найти("Период") = неопределено Тогда
		ТаблицаПланов.Колонки.Добавить("Период", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.ДатаВремя));
		ТаблицаПланов.ЗаполнитьЗначения(Объект.Дата, "Период");
	КонецЕсли;
	
	// Формируем колонку ДатаОперации
	Если ТаблицаПланов.Колонки.Найти("ДатаОперации") = неопределено Тогда
		ТаблицаПланов.Колонки.Добавить("ДатаОперации", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.ДатаВремя));
	КонецЕсли;
	ТаблицаПланов.ЗагрузитьКолонку(ТаблицаПланов.ВыгрузитьКолонку("Период"), "ДатаОперации");
	
	// Формируем колонки ресурсы
	ТаблицаПланов.Колонки.Добавить("Лимит", ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
	ТаблицаПланов.Колонки.Добавить("Зарезервировано", ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
	ТаблицаПланов.Колонки.Сумма.Имя = "Заявлено";
	ТаблицаПланов.Колонки.Добавить("Исполнено", ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
	
	ОбщегоНазначенияОПК.ЗагрузитьТаблицуВоВременнуюТаблицуЗапроса(Запрос, "ВТ_ТаблицаПлановССуммамиЛимитирования", ТаблицаПланов);
	КонтрольЛимитовУХ.ПолучитьТаблицуЛимитов(Запрос, Объект.Дата, Истина);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЛимитыПоБюджетамОбороты.Предназначение КАК Предназначение,
	|	ЛимитыПоБюджетамОбороты.ПериодЛимитирования КАК ПериодЛимитирования,
	|	ЛимитыПоБюджетамОбороты.ЦФО КАК ЦФО,
	|	ЛимитыПоБюджетамОбороты.Проект КАК Проект,
	|	ЛимитыПоБюджетамОбороты.СтатьяБюджета КАК СтатьяБюджета,
	|	ЛимитыПоБюджетамОбороты.Аналитика1 КАК Аналитика1,
	|	ЛимитыПоБюджетамОбороты.Аналитика2 КАК Аналитика2,
	|	ЛимитыПоБюджетамОбороты.Аналитика3 КАК Аналитика3,
	|	ЛимитыПоБюджетамОбороты.Аналитика4 КАК Аналитика4,
	|	ЛимитыПоБюджетамОбороты.Аналитика5 КАК Аналитика5,
	|	ЛимитыПоБюджетамОбороты.Аналитика6 КАК Аналитика6,
	|	ЛимитыПоБюджетамОбороты.Валюта КАК Валюта,
	|	ВЫБОР
	|		КОГДА ЛимитыПоБюджетамОбороты.ЛимитОборот + ЛимитыПоБюджетамОбороты.КорректировкаОборот - ЛимитыПоБюджетамОбороты.ЗарезервированоОборот - ЛимитыПоБюджетамОбороты.ЗаявленоОборот - ЛимитыПоБюджетамОбороты.ИсполненоОборот < 0
	|			ТОГДА 0
	|		ИНАЧЕ ЛимитыПоБюджетамОбороты.ЛимитОборот + ЛимитыПоБюджетамОбороты.КорректировкаОборот - ЛимитыПоБюджетамОбороты.ЗарезервированоОборот - ЛимитыПоБюджетамОбороты.ЗаявленоОборот - ЛимитыПоБюджетамОбороты.ИсполненоОборот
	|	КОНЕЦ КАК Свободно
	|ПОМЕСТИТЬ ВТ_Свободно
	|ИЗ
	|	РегистрНакопления.ЛимитыПоБюджетам.Обороты(
	|			,
	|			,
	|			,
	|			(Предназначение, ПериодЛимитирования, Валюта, ЦФО, Проект, СтатьяБюджета, Аналитика1, Аналитика2, Аналитика3, Аналитика4, Аналитика5, Аналитика6) В
	|				(ВЫБРАТЬ
	|					Данные.Предназначение,
	|					Данные.ПериодЛимитирования,
	|					Данные.Валюта,
	|					Данные.ЦФО,
	|					Данные.Проект,
	|					Данные.СтатьяБюджета,
	|					Данные.Аналитика1,
	|					Данные.Аналитика2,
	|					Данные.Аналитика3,
	|					Данные.Аналитика4,
	|					Данные.Аналитика5,
	|					Данные.Аналитика6
	|				ИЗ
	|					ВТ_ДвиженияЛимитыПоБюджетам КАК Данные)) КАК ЛимитыПоБюджетамОбороты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыБюджетов.Ссылка КАК ВидБюджета,
	|	ВТ_Лимиты.Предназначение КАК Предназначение,
	|	ВТ_Лимиты.ПериодЛимитирования КАК ПериодЛимитирования,
	|	ВТ_Лимиты.ЦФО КАК ЦФО,
	|	ВТ_Лимиты.Проект КАК Проект,
	|	ВТ_Лимиты.СтатьяБюджета КАК СтатьяБюджета,
	|	ВТ_Лимиты.Аналитика1 КАК Аналитика1,
	|	ВТ_Лимиты.Аналитика2 КАК Аналитика2,
	|	ВТ_Лимиты.Аналитика3 КАК Аналитика3,
	|	ВТ_Лимиты.Аналитика4 КАК Аналитика4,
	|	ВТ_Лимиты.Аналитика5 КАК Аналитика5,
	|	ВТ_Лимиты.Аналитика6 КАК Аналитика6,
	|	ВТ_Лимиты.Валюта КАК Валюта,
	|	ВТ_Лимиты.Заявлено КАК Сумма,
	|	ЕСТЬNULL(ВТ_Свободно.Свободно, 0) КАК Свободно,
	|	ВЫБОР
	|		КОГДА ВТ_Лимиты.Заявлено > ЕСТЬNULL(ВТ_Свободно.Свободно, 0)
	|			ТОГДА ВТ_Лимиты.Заявлено - ЕСТЬNULL(ВТ_Свободно.Свободно, 0)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КОбеспечению,
	|	ПараметрыЛимитирования.ИспользоватьЛимитирование КАК ИспользоватьЛимитирование,
	|	ПараметрыЛимитирования.СпособОпределенияВалютыЛимитирования КАК СпособОпределенияВалютыЛимитирования
	|ИЗ
	|	ВТ_ДвиженияЛимитыПоБюджетам КАК ВТ_Лимиты
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.ВидыБюджетов КАК ВидыБюджетов
	|		ПО ВТ_Лимиты.Предназначение = ВидыБюджетов.Предназначение
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Свободно КАК ВТ_Свободно
	|		ПО ВТ_Лимиты.Предназначение = ВТ_Свободно.Предназначение
	|			И ВТ_Лимиты.ПериодЛимитирования = ВТ_Свободно.ПериодЛимитирования
	|			И ВТ_Лимиты.Валюта = ВТ_Свободно.Валюта
	|			И ВТ_Лимиты.ЦФО = ВТ_Свободно.ЦФО
	|			И ВТ_Лимиты.Проект = ВТ_Свободно.Проект
	|			И ВТ_Лимиты.СтатьяБюджета = ВТ_Свободно.СтатьяБюджета
	|			И ВТ_Лимиты.Аналитика1 = ВТ_Свободно.Аналитика1
	|			И ВТ_Лимиты.Аналитика2 = ВТ_Свободно.Аналитика2
	|			И ВТ_Лимиты.Аналитика3 = ВТ_Свободно.Аналитика3
	|			И ВТ_Лимиты.Аналитика4 = ВТ_Свободно.Аналитика4
	|			И ВТ_Лимиты.Аналитика5 = ВТ_Свободно.Аналитика5
	|			И ВТ_Лимиты.Аналитика6 = ВТ_Свободно.Аналитика6
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыЛимитирования КАК ПараметрыЛимитирования
	|		ПО ВТ_Лимиты.Предназначение = ПараметрыЛимитирования.ВидБюджета.Предназначение
	|			И (НАЧАЛОПЕРИОДА(ВТ_Лимиты.ПериодЛимитирования.ДатаНачала, ГОД) = ПараметрыЛимитирования.Период)";
	
	ТаблицаЛимитов = Запрос.Выполнить().Выгрузить();
		
	//
	Объект.ЛимитыПоБюджетам.Загрузить(ТаблицаЛимитов);
	
	//
	Реквизиты = "Организация, Контрагент, ДоговорКонтрагента";
	ЗаполнитьЗначенияСвойств(Объект,
		ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Источник, Реквизиты),
		Реквизиты);
	
КонецПроцедуры

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаДвиженияЛимитовПоБюджетам(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСерверОПК.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Ссылка КАК Регистратор,
	|	ДанныеДокумента.Дата КАК Дата,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Комментарий КАК Комментарий,
	|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.Основание КАК Основание,
	|	ДанныеДокумента.Ответственный КАК Ответственный
	|ИЗ
	|	Документ.ЗаявкаНаКорректировкуЛимитов КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ТаблицаРеквизитов = Запрос.Выполнить().Выгрузить();
	Реквизиты = ТаблицаРеквизитов[0];
	
	Для Каждого Колонка Из ТаблицаРеквизитов.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
КонецПроцедуры

Процедура ТекстЗапросаДвиженияЛимитовПоБюджетам(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ЛимитыПоБюджетам";
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.ВидБюджета.Предназначение КАК Предназначение,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.ПериодЛимитирования КАК ПериодЛимитирования,
	|	ЗНАЧЕНИЕ(Документ.ОперативныйПлан.ПустаяСсылка) КАК ДокументРезервирования,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Валюта КАК Валюта,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.ЦФО КАК ЦФО,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Проект КАК Проект,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.СтатьяБюджета КАК СтатьяБюджета,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Аналитика1 КАК Аналитика1,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Аналитика2 КАК Аналитика2,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Аналитика3 КАК Аналитика3,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Аналитика4 КАК Аналитика4,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Аналитика5 КАК Аналитика5,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Аналитика6 КАК Аналитика6,
	|	&Основание КАК ДокументПланирования,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Свободно КАК Заявлено,
	|	0 КАК КОбеспечению
	|ИЗ
	|	Документ.ЗаявкаНаКорректировкуЛимитов.ЛимитыПоБюджетам КАК ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам
	|ГДЕ
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Ссылка = &Ссылка
	|	И ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Свободно <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Период,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.ВидБюджета.Предназначение,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.ПериодЛимитирования,
	|	ЗНАЧЕНИЕ(Документ.ОперативныйПлан.ПустаяСсылка),
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Валюта,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.ЦФО,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Проект,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.СтатьяБюджета,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Аналитика1,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Аналитика2,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Аналитика3,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Аналитика4,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Аналитика5,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Аналитика6,
	|	&Ссылка,
	|	0,
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.КОбеспечению
	|ИЗ
	|	Документ.ЗаявкаНаКорректировкуЛимитов.ЛимитыПоБюджетам КАК ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам
	|ГДЕ
	|	ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.Ссылка = &Ссылка
	|	И ЗаявкаНаКорректировкуЛимитовЛимитыПоБюджетам.КОбеспечению <> 0";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли