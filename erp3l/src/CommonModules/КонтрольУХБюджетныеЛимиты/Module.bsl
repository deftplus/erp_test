
#Область ПрограммныйИнтерфейс

// Функция возвращает объект-проверку
Функция Создать() Экспорт
	
	Проверка = КонтрольУХ.Новый_Проверка();
	Проверка.Объект = КонтрольУХБюджетныеЛимиты;
	Проверка.Источник = ИмяИсточника();
	Проверка.ВидКонтроля = ПланыВидовХарактеристик.ВидыКонтроляДокументов.КонтрольБюджетныхЛимитов;
	Проверка.ИмяРеквизита = "ЕстьПревышениеЛимитыБюджет";
	
	Возврат Проверка;
	
КонецФункции

// Функция возвращает Истина, если для этого документа проверка выполняется
Функция ТребуетсяДляДокумента(ИмяДокумента) Экспорт
	Возврат Истина;
КонецФункции

// Функция возвращает Истина, если требуется выполнение проверки
Функция ТребуетсяПроверка(ПараметрыКонтроля, Источник) Экспорт
	Возврат Истина;
КонецФункции

// Функция выполняет обработку данных источника
Функция ОбработатьДанныеИсточника(ИнформацияДляКонтроля, Источник) Экспорт
	
	// Инициализируем запрос
	Запрос = Новый Запрос;
	Если Источник.Свойство("Параметры") И ТипЗнч(Источник.Параметры) = Тип("Структура") Тогда
		Для Каждого КлючЗначение Из Источник.Параметры Цикл
			Запрос.УстановитьПараметр(КлючЗначение.Ключ, КлючЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ОбщегоНазначенияОПК.ЗагрузитьТаблицуВоВременнуюТаблицуЗапроса(
		Запрос, 
		"ВТ_ТаблицаПлановССуммамиЛимитирования", 
		Источник.ПланыДокумента);
	
	// Получаем планируемые движения лимитов
	КонтрольЛимитовУХ.ПолучитьТаблицуЛимитов(Запрос, Источник.Параметры.Дата, Истина);
	
	//
	РезультатЗапроса = ВыполнитьКонтрольЛимитов(Запрос);
	
	//
	РезультатЗапроса.Колонки.Добавить("КонтрольНарушен", Новый ОписаниеТипов("Булево"));
	
	// Результат контроля резерва
	СтруктураПоиска = Новый Структура("ВидКонтроля", ПланыВидовХарактеристик.ВидыКонтроляДокументов.КонтрольБюджетныхРезервов);
	РезультатКонтроляРезервов = РезультатЗапроса.Скопировать(СтруктураПоиска);
	ИнформацияДляКонтроля.Вставить("РезультатКонтроляРезервов", РезультатКонтроляРезервов);
	
	// Результат контроля бюджета
	СтруктураПоиска = Новый Структура("ВидКонтроля", ПланыВидовХарактеристик.ВидыКонтроляДокументов.КонтрольБюджетныхЛимитов);
	Возврат РезультатЗапроса.Скопировать(СтруктураПоиска);
	
КонецФункции

// Процедура выполняет контроль обработанных данных
Функция ВыполнитьКонтроль(ИнформацияДляКонтроля, ДанныеДляКонтроля) Экспорт
	
	КонтрольНарушен = Ложь;
	Для Каждого Строка Из ДанныеДляКонтроля Цикл
		
		Доступно = Строка.Лимит + Строка.ЛимитИзменение 
			- Строка.Зарезервировано - Строка.ЗарезервированоИзменение
			- Строка.Заявлено - Строка.ЗаявленоИзменение
			- Строка.Исполнено - Строка.ИсполненоИзменение;
		
		Строка.КонтрольНарушен = Доступно < 0;
		КонтрольНарушен = КонтрольНарушен ИЛИ Строка.КонтрольНарушен;
		
	КонецЦикла;
	
	Возврат КонтрольНарушен;
	
КонецФункции

// Функция возвращает Истина, если нарушение контроля должно приводить к блокированию проведения
Функция БлокироватьПроведение(КлючКонтроля) Экспорт
	Возврат БлокироватьПроведениеДляВидаКонтроля(ПланыВидовХарактеристик.ВидыКонтроляДокументов.КонтрольБюджетныхЛимитов, КлючКонтроля);
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает имя источника для проверки
//
Функция ИмяИсточника() Экспорт
	
	Возврат "ИзменениеБюджетныхЛимитовРезервов";
	
КонецФункции

// Процедура возвращает табличный документ с расшифровкой контроля документа
//
Функция СформироватьРасшифровкуКонтроля(Проверка, СтрокаКонтроль) Экспорт
	
	ДанныеКонтроля = ПолучитьИзВременногоХранилища(СтрокаКонтроль.АдресРезультата);
	
	// ЦФО и проект
	ЦФОПроект = ДанныеКонтроля.Скопировать(, "ЦФО, Проект");
	ЦФОПроект.Свернуть("ЦФО, Проект", "");
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("ЦФО", Справочники.Организации.ПустаяСсылка());
	Реквизиты.Вставить("Проект", Справочники.Проекты.ПустаяСсылка());
	Если ЦФОПроект.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(Реквизиты, ЦФОПроект[0]);
	КонецЕсли;
	
	//
	ТабДок = Новый ТабличныйДокумент;
	
	ТаблицаПериодов = ДанныеКонтроля.Скопировать(,"ПериодЛимитирования, Лимит, ЛимитИзменение, Зарезервировано, ЗарезервированоИзменение, Заявлено, ЗаявленоИзменение, Исполнено, ИсполненоИзменение");
	ТаблицаПериодов.Свернуть("ПериодЛимитирования", "Лимит, ЛимитИзменение, Зарезервировано, ЗарезервированоИзменение, Заявлено, ЗаявленоИзменение, Исполнено, ИсполненоИзменение");
	
	//
	Макет = ПланыВидовХарактеристик.ВидыКонтроляДокументов.ПолучитьМакет("КонтрольЛимитовПоБюджетам");
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ШапкаТаблицы = ПолучитьОбластиОтчета(Макет, "ШапкаТаблицы");
	ПодвалТаблицы = ПолучитьОбластиОтчета(Макет, "ПодвалТаблицы");
	ГруппаПериод = ПолучитьОбластиОтчета(Макет, "ГруппировкаПериод");
	Детали = ПолучитьОбластиОтчета(Макет, "Детали");
	
	//
	ТабДок.Очистить();
	
	// Формирование заголовка
	ОбластьЗаголовок.Параметры.Документ = СтрокаКонтроль.Документ;
	ОбластьЗаголовок.Параметры.ЦФО = Реквизиты.ЦФО;
	Если ЗначениеЗаполнено(Реквизиты.Проект) Тогда
		ОбластьЗаголовок.Параметры.Проект = Реквизиты.Проект;
	Иначе
		ОбластьЗаголовок.Параметры.Проект = НСтр("ru = '<без проекта>'");
	КонецЕсли;
	ОбластьЗаголовок.Параметры.ДатаВремяКонтроля = СтрокаКонтроль.ВремяПроверки;
	ОбластьЗаголовок.Параметры.ТекущееВремя = ТекущаяДатаСеанса();
	ОбластьЗаголовок.Параметры.ТекущийПользователь = Пользователи.ТекущийПользователь();
	ТабДок.Вывести(ОбластьЗаголовок);
	
	// 
	ТабДок.НачатьАвтогруппировкуСтрок();
	
	// 
	ВывестиОбластиОтчета(ТабДок, ШапкаТаблицы);

	// 
	МассивПериодов = ТаблицаПериодов.ВыгрузитьКолонку("ПериодЛимитирования");
	ДатыНачалаПериодов = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивПериодов, "ДатаНачала");
	
	// Сортируем таблицу периодов по дате начала
	ТаблицаПериодов.Колонки.Добавить("ДатаНачала", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	Для Каждого Стр Из ТаблицаПериодов Цикл
		Стр.ДатаНачала = ДатыНачалаПериодов[Стр.ПериодЛимитирования];
	КонецЦикла;
	ТаблицаПериодов.Сортировать("ДатаНачала");
	
	Для каждого СтрокаПериод Из ТаблицаПериодов Цикл
		
		СтрокиОтчета = ДанныеКонтроля.НайтиСтроки(Новый Структура("ПериодЛимитирования", СтрокаПериод.ПериодЛимитирования));
		ЗаполнитьСуммыВОбласти(ГруппаПериод, СтрокаПериод);
		
		ВывестиОбластиОтчета(ТабДок, ГруппаПериод, 1);
		Для Каждого ВыборкаДетальныеЗаписи Из СтрокиОтчета Цикл
			ЗаполнитьСуммыВОбласти(Детали, ВыборкаДетальныеЗаписи);
			ВывестиОбластиОтчета(ТабДок, Детали, 2);
		КонецЦикла;
		
	КонецЦикла; 
	
	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	
	Если ТаблицаПериодов.Количество() > 0 Тогда
		
		Если ТаблицаПериодов.Количество() = 0 Тогда
			ПодвалТаблицы.Начало.Параметры.ДиапазонПериодов = "";
		ИначеЕсли ТаблицаПериодов.Количество() = 1 Тогда
			ПодвалТаблицы.Начало.Параметры.ДиапазонПериодов = Строка(ТаблицаПериодов[0].ПериодЛимитирования);
		Иначе
			ПодвалТаблицы.Начало.Параметры.ДиапазонПериодов = Строка(ТаблицаПериодов[0].ПериодЛимитирования)
				+ " - " + Строка(ТаблицаПериодов[ТаблицаПериодов.Количество()-1].ПериодЛимитирования);
		КонецЕсли; 
		
		//
		ТаблицаПериодов.Свернуть("", "Лимит, ЛимитИзменение, Зарезервировано, ЗарезервированоИзменение, Заявлено, ЗаявленоИзменение, Исполнено, ИсполненоИзменение");
		ЗаполнитьСуммыВОбласти(ПодвалТаблицы, ТаблицаПериодов[0]);
		
		ВывестиОбластиОтчета(ТабДок, ПодвалТаблицы);
		
	КонецЕсли;
	
	//
	ТабДок.Вывести(ОбластьПодвал);
	ТабДок.ИтогиСправа = Ложь;
	
	Возврат ТабДок;
	
КонецФункции

// Процедура сохраняет данные для контроля в табличной части документа
//
// Параметры:
//  ДанныеДляКонтроля	- Таблица значений	- Результат контроля
//  РезультатыКонтроля	- ТабличнаяЧасть	- табличная часть РезультатыКонтроля проверяемого документа
//
Процедура СохранитьДанныеДляКонтроляВДокументе(ДанныеДляКонтроля, РезультатыКонтроля) Экспорт
	
	// НомерСтроки
	Если ДанныеДляКонтроля.Колонки.Найти("НомерСтроки") = неопределено Тогда
		ДанныеДляКонтроля.Колонки.Добавить("НомерСтроки", ОбщегоНазначения.ОписаниеТипаЧисло(10,0));
		Поз = 1;
		Для Каждого Строка Из ДанныеДляКонтроля Цикл
			Строка.НомерСтроки = Поз;
			Поз = Поз + 1;
		КонецЦикла;
	КонецЕсли;
	
	// АналитикаПланированияСтатейБюджетов
	Если ДанныеДляКонтроля.Колонки.Найти("АналитикаПланированияСтатейБюджетов") = неопределено Тогда
		ДанныеДляКонтроля.Колонки.Добавить("АналитикаПланированияСтатейБюджетов", Новый ОписаниеТипов("СправочникСсылка.КлючиАналитикиПланированияСтатейБюджетов"));
	КонецЕсли;
	ИменаПолей = РегистрыСведений.АналитикаПланированияСтатейБюджетов.ИменаПолейКоллекцииПоУмолчанию();
	ИменаПолей.ПриходРасход = "";
	РегистрыСведений.АналитикаПланированияСтатейБюджетов.ЗаполнитьВКоллекции(ДанныеДляКонтроля, ИменаПолей);
	
	// АналитикаПланированияСтруктуры
	Если ДанныеДляКонтроля.Колонки.Найти("АналитикаПланированияСтруктуры") = неопределено Тогда
		ДанныеДляКонтроля.Колонки.Добавить("АналитикаПланированияСтруктуры", Новый ОписаниеТипов("СправочникСсылка.КлючиАналитикиПланированияСтруктуры"));
	КонецЕсли;
	ИменаПолей = РегистрыСведений.АналитикаПланированияСтруктуры.ИменаПолейКоллекцииПоУмолчанию();
	ИменаПолей.Организация = "";
	РегистрыСведений.АналитикаПланированияСтруктуры.ЗаполнитьВКоллекции(ДанныеДляКонтроля, ИменаПолей);
	
	// АналитикаКонтроляБюджетныхЛимитовРезервов
	Если ДанныеДляКонтроля.Колонки.Найти("КлючКонтроля") = неопределено Тогда
		ДанныеДляКонтроля.Колонки.Добавить("КлючКонтроля", Новый ОписаниеТипов("СправочникСсылка.КлючиКонтроляБюджетныхЛимитовРезервов"));
	КонецЕсли;
	ИменаПолей = РегистрыСведений.АналитикаКонтроляБюджетныхЛимитовРезервов.ИменаПолейКоллекцииПоУмолчанию();
	ИменаПолей.АналитикаКонтроляБюджетныхЛимитовРезервов = "КлючКонтроля";
	РегистрыСведений.АналитикаКонтроляБюджетныхЛимитовРезервов.ЗаполнитьВКоллекции(ДанныеДляКонтроля, ИменаПолей);
	
	Для Каждого Строка Из ДанныеДляКонтроля Цикл
		ЗаполнитьЗначенияСвойств(РезультатыКонтроля.Добавить(), Строка);
	КонецЦикла;
	
КонецПроцедуры // СохранитьДанныеДляКонтроляВДокументе()

// Функция возвращает соответствие с описанием колонок таблицы данных контроля, которые получаются из ключа контроля
//
// Возвращаемое значение:
//   Соответствие   - {ИмяКолонки, Структура("ИмяКолонки, ОписаниеТипа, ПутьКДанным")}
//
Функция КолонкиДанныхКонтроля() Экспорт
	
	Колонки = Новый Соответствие;
	КонтрольУХ.ДобавитьКолонкуКонтроля(Колонки, 
		"Предназначение",
		Метаданные.ОпределяемыеТипы.Предназначения.Тип);
	КонтрольУХ.ДобавитьКолонкуКонтроля(Колонки, 
		"ДокументРезервирования",
		Новый ОписаниеТипов("ДокументСсылка.ОперативныйПлан"));
	КонтрольУХ.ДобавитьКолонкуКонтроля(Колонки, 
		"ПериодЛимитирования",
		Новый ОписаниеТипов("СправочникСсылка.Периоды"));
	КонтрольУХ.ДобавитьКолонкуКонтроля(Колонки, 
		"ЦФО",
		Метаданные.ОпределяемыеТипы.ЦФО.Тип,
		"АналитикаПланированияСтруктуры.ЦФО");
	КонтрольУХ.ДобавитьКолонкуКонтроля(Колонки, 
		"Проект",
		Метаданные.ОпределяемыеТипы.Проекты.Тип,
		"АналитикаПланированияСтруктуры.Проект");
	КонтрольУХ.ДобавитьКолонкуКонтроля(Колонки, 
		"СтатьяБюджета",
		Метаданные.ПланыВидовХарактеристик.ВидыБюджетов.Тип,
		"АналитикаПланированияСтатейБюджетов.СтатьяБюджета");
	КонтрольУХ.ДобавитьКолонкуКонтроля(Колонки, 
		"Аналитика1",
		Метаданные.ПланыВидовХарактеристик.ВидыСубконтоКорпоративные.Тип,
		"АналитикаПланированияСтатейБюджетов.Аналитика1");
	КонтрольУХ.ДобавитьКолонкуКонтроля(Колонки, 
		"Аналитика2",
		Метаданные.ПланыВидовХарактеристик.ВидыСубконтоКорпоративные.Тип,
		"АналитикаПланированияСтатейБюджетов.Аналитика2");
	КонтрольУХ.ДобавитьКолонкуКонтроля(Колонки, 
		"Аналитика3",
		Метаданные.ПланыВидовХарактеристик.ВидыСубконтоКорпоративные.Тип,
		"АналитикаПланированияСтатейБюджетов.Аналитика3");
	КонтрольУХ.ДобавитьКолонкуКонтроля(Колонки, 
		"Аналитика4",
		Метаданные.ПланыВидовХарактеристик.ВидыСубконтоКорпоративные.Тип,
		"АналитикаПланированияСтатейБюджетов.Аналитика4");
	КонтрольУХ.ДобавитьКолонкуКонтроля(Колонки, 
		"Аналитика5",
		Метаданные.ПланыВидовХарактеристик.ВидыСубконтоКорпоративные.Тип,
		"АналитикаПланированияСтатейБюджетов.Аналитика5");
	КонтрольУХ.ДобавитьКолонкуКонтроля(Колонки, 
		"Аналитика6",
		Метаданные.ПланыВидовХарактеристик.ВидыСубконтоКорпоративные.Тип,
		"АналитикаПланированияСтатейБюджетов.Аналитика6");
		
	Результат = Новый Структура;
	Результат.Вставить("Источник", "Справочник.КлючиКонтроляБюджетныхЛимитовРезервов");
	Результат.Вставить("Колонки", Колонки);
	
	Возврат Результат;
	
КонецФункции

//
Функция БлокироватьПроведениеДляВидаКонтроля(ВидКонтроля, КлючКонтроля) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидКонтроля", ВидКонтроля);
	Запрос.УстановитьПараметр("КлючКонтроля", КлючКонтроля);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА &ВидКонтроля = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыКонтроляДокументов.КонтрольБюджетныхЛимитов)
	|			ТОГДА ЕСТЬNULL(ПараметрыЛимитирования.КонтрольЛимитов, ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыКонтроляДокументов.ПустаяСсылка))
	|		КОГДА &ВидКонтроля = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыКонтроляДокументов.КонтрольБюджетныхРезервов)
	|			ТОГДА ЕСТЬNULL(ПараметрыЛимитирования.КонтрольРезервов, ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыКонтроляДокументов.ПустаяСсылка))
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыКонтроляДокументов.ПустаяСсылка)
	|	КОНЕЦ = ЗНАЧЕНИЕ(Перечисление.РежимыКонтроляДокументов.Блокировать) КАК БлокироватьПроведение
	|ИЗ
	|	Справочник.КлючиКонтроляБюджетныхЛимитовРезервов КАК КлючиКонтроляБюджетныхЛимитовРезервов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыЛимитирования КАК ПараметрыЛимитирования
	|		ПО КлючиКонтроляБюджетныхЛимитовРезервов.Предназначение = ПараметрыЛимитирования.ВидБюджета.Предназначение
	|			И (НАЧАЛОПЕРИОДА(КлючиКонтроляБюджетныхЛимитовРезервов.ПериодЛимитирования.ДатаНачала, ГОД) = ПараметрыЛимитирования.Период)
	|ГДЕ
	|	КлючиКонтроляБюджетныхЛимитовРезервов.Ссылка = &КлючКонтроля";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.БлокироватьПроведение;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыполнитьКонтрольЛимитов(Запрос)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Запрос.ВидКонтроля КАК ВидКонтроля,
	|	Запрос.Предназначение КАК Предназначение,
	|	Запрос.ДокументРезервирования КАК ДокументРезервирования,
	|	Запрос.ПериодЛимитирования КАК ПериодЛимитирования,
	|	Запрос.ЦФО КАК ЦФО,
	|	Запрос.Проект КАК Проект,
	|	Запрос.СтатьяБюджета КАК СтатьяБюджета,
	|	Запрос.Аналитика1 КАК Аналитика1,
	|	Запрос.Аналитика2 КАК Аналитика2,
	|	Запрос.Аналитика3 КАК Аналитика3,
	|	Запрос.Аналитика4 КАК Аналитика4,
	|	Запрос.Аналитика5 КАК Аналитика5,
	|	Запрос.Аналитика6 КАК Аналитика6,
	|	Запрос.Валюта КАК Валюта,
	|	СУММА(Запрос.Лимит) КАК Лимит,
	|	СУММА(Запрос.Зарезервировано) КАК Зарезервировано,
	|	СУММА(Запрос.Заявлено) КАК Заявлено,
	|	СУММА(Запрос.Исполнено) КАК Исполнено,
	|	СУММА(Запрос.ЛимитИзменение) КАК ЛимитИзменение,
	|	СУММА(Запрос.ЗарезервированоИзменение) КАК ЗарезервированоИзменение,
	|	СУММА(Запрос.ЗаявленоИзменение) КАК ЗаявленоИзменение,
	|	СУММА(Запрос.ИсполненоИзменение) КАК ИсполненоИзменение,
	|	СУММА(Запрос.ЛимитСтало) КАК ЛимитСтало,
	|	СУММА(Запрос.ЗарезервированоСтало) КАК ЗарезервированоСтало,
	|	СУММА(Запрос.ЗаявленоСтало) КАК ЗаявленоСтало,
	|	СУММА(Запрос.ИсполненоСтало) КАК ИсполненоСтало
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыКонтроляДокументов.КонтрольБюджетныхЛимитов) КАК ВидКонтроля,
	|		ЛимитыПоБюджетамОбороты.Предназначение КАК Предназначение,
	|		ЗНАЧЕНИЕ(Документ.ОперативныйПлан.ПустаяСсылка) КАК ДокументРезервирования,
	|		ЛимитыПоБюджетамОбороты.ПериодЛимитирования КАК ПериодЛимитирования,
	|		ЛимитыПоБюджетамОбороты.ЦФО КАК ЦФО,
	|		ЛимитыПоБюджетамОбороты.Проект КАК Проект,
	|		ЛимитыПоБюджетамОбороты.СтатьяБюджета КАК СтатьяБюджета,
	|		ЛимитыПоБюджетамОбороты.Аналитика1 КАК Аналитика1,
	|		ЛимитыПоБюджетамОбороты.Аналитика2 КАК Аналитика2,
	|		ЛимитыПоБюджетамОбороты.Аналитика3 КАК Аналитика3,
	|		ЛимитыПоБюджетамОбороты.Аналитика4 КАК Аналитика4,
	|		ЛимитыПоБюджетамОбороты.Аналитика5 КАК Аналитика5,
	|		ЛимитыПоБюджетамОбороты.Аналитика6 КАК Аналитика6,
	|		ЛимитыПоБюджетамОбороты.Валюта КАК Валюта,
	|		ЛимитыПоБюджетамОбороты.ЛимитОборот + ЛимитыПоБюджетамОбороты.КорректировкаОборот КАК Лимит,
	|		ЛимитыПоБюджетамОбороты.ЗарезервированоОборот + ЛимитыПоБюджетамОбороты.ДефицитРезерваОборот КАК Зарезервировано,
	|		ЛимитыПоБюджетамОбороты.ЗаявленоОборот КАК Заявлено,
	|		ЛимитыПоБюджетамОбороты.ИсполненоОборот КАК Исполнено,
	|		0 КАК ЛимитИзменение,
	|		0 КАК ЗарезервированоИзменение,
	|		0 КАК ЗаявленоИзменение,
	|		0 КАК ИсполненоИзменение,
	|		ЛимитыПоБюджетамОбороты.ЛимитОборот + ЛимитыПоБюджетамОбороты.КорректировкаОборот КАК ЛимитСтало,
	|		ЛимитыПоБюджетамОбороты.ЗарезервированоОборот + ЛимитыПоБюджетамОбороты.ДефицитРезерваОборот КАК ЗарезервированоСтало,
	|		ЛимитыПоБюджетамОбороты.ЗаявленоОборот КАК ЗаявленоСтало,
	|		ЛимитыПоБюджетамОбороты.ИсполненоОборот КАК ИсполненоСтало
	|	ИЗ
	|		РегистрНакопления.ЛимитыПоБюджетам.Обороты(
	|				,
	|				,
	|				,
	|				(Предназначение, ПериодЛимитирования, Валюта, ЦФО, Проект, СтатьяБюджета, Аналитика1, Аналитика2, Аналитика3, Аналитика4, Аналитика5, Аналитика6) В
	|					(ВЫБРАТЬ
	|						ВТ_ДвиженияЛимитыПоБюджетам.Предназначение КАК Предназначение,
	|						ВТ_ДвиженияЛимитыПоБюджетам.ПериодЛимитирования КАК ПериодЛимитирования,
	|						ВТ_ДвиженияЛимитыПоБюджетам.Валюта КАК Валюта,
	|						ВТ_ДвиженияЛимитыПоБюджетам.ЦФО КАК ЦФО,
	|						ВТ_ДвиженияЛимитыПоБюджетам.Проект КАК Проект,
	|						ВТ_ДвиженияЛимитыПоБюджетам.СтатьяБюджета КАК СтатьяБюджета,
	|						ВТ_ДвиженияЛимитыПоБюджетам.Аналитика1 КАК Аналитика1,
	|						ВТ_ДвиженияЛимитыПоБюджетам.Аналитика2 КАК Аналитика2,
	|						ВТ_ДвиженияЛимитыПоБюджетам.Аналитика3 КАК Аналитика3,
	|						ВТ_ДвиженияЛимитыПоБюджетам.Аналитика4 КАК Аналитика4,
	|						ВТ_ДвиженияЛимитыПоБюджетам.Аналитика5 КАК Аналитика5,
	|						ВТ_ДвиженияЛимитыПоБюджетам.Аналитика6 КАК Аналитика6
	|					ИЗ
	|						ВТ_ДвиженияЛимитыПоБюджетам КАК ВТ_ДвиженияЛимитыПоБюджетам)) КАК ЛимитыПоБюджетамОбороты
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыКонтроляДокументов.КонтрольБюджетныхЛимитов),
	|		ЛимитыПоБюджетам.Предназначение,
	|		ЗНАЧЕНИЕ(Документ.ОперативныйПлан.ПустаяСсылка),
	|		ЛимитыПоБюджетам.ПериодЛимитирования,
	|		ЛимитыПоБюджетам.ЦФО,
	|		ЛимитыПоБюджетам.Проект,
	|		ЛимитыПоБюджетам.СтатьяБюджета,
	|		ЛимитыПоБюджетам.Аналитика1,
	|		ЛимитыПоБюджетам.Аналитика2,
	|		ЛимитыПоБюджетам.Аналитика3,
	|		ЛимитыПоБюджетам.Аналитика4,
	|		ЛимитыПоБюджетам.Аналитика5,
	|		ЛимитыПоБюджетам.Аналитика6,
	|		ЛимитыПоБюджетам.Валюта,
	|		-(ЛимитыПоБюджетам.Лимит + ЛимитыПоБюджетам.Корректировка),
	|		-(ЛимитыПоБюджетам.Зарезервировано + ЛимитыПоБюджетам.ДефицитРезерва),
	|		-ЛимитыПоБюджетам.Заявлено,
	|		-ЛимитыПоБюджетам.Исполнено,
	|		0,
	|		0,
	|		0,
	|		0,
	|		-(ЛимитыПоБюджетам.Лимит + ЛимитыПоБюджетам.Корректировка),
	|		-(ЛимитыПоБюджетам.Зарезервировано + ЛимитыПоБюджетам.ДефицитРезерва),
	|		-ЛимитыПоБюджетам.Заявлено,
	|		-ЛимитыПоБюджетам.Исполнено
	|	ИЗ
	|		РегистрНакопления.ЛимитыПоБюджетам КАК ЛимитыПоБюджетам
	|	ГДЕ
	|		&ЭтоНовый = ЛОЖЬ
	|		И ЛимитыПоБюджетам.Регистратор = &Ссылка
	|		И (ЛимитыПоБюджетам.Предназначение, ЛимитыПоБюджетам.ПериодЛимитирования, ЛимитыПоБюджетам.ЦФО, ЛимитыПоБюджетам.Проект, ЛимитыПоБюджетам.СтатьяБюджета, ЛимитыПоБюджетам.Аналитика1, ЛимитыПоБюджетам.Аналитика2, ЛимитыПоБюджетам.Аналитика3, ЛимитыПоБюджетам.Аналитика4, ЛимитыПоБюджетам.Аналитика5, ЛимитыПоБюджетам.Аналитика6, ЛимитыПоБюджетам.Валюта) В
	|				(ВЫБРАТЬ
	|					ВТ_ДвиженияЛимитыПоБюджетам.Предназначение КАК Предназначение,
	|					ВТ_ДвиженияЛимитыПоБюджетам.ПериодЛимитирования КАК ПериодЛимитирования,
	|					ВТ_ДвиженияЛимитыПоБюджетам.ЦФО КАК ЦФО,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Проект КАК Проект,
	|					ВТ_ДвиженияЛимитыПоБюджетам.СтатьяБюджета КАК СтатьяБюджета,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика1 КАК Аналитика1,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика2 КАК Аналитика2,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика3 КАК Аналитика3,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика4 КАК Аналитика4,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика5 КАК Аналитика5,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика6 КАК Аналитика6,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Валюта КАК Валюта
	|				ИЗ
	|					ВТ_ДвиженияЛимитыПоБюджетам КАК ВТ_ДвиженияЛимитыПоБюджетам)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыКонтроляДокументов.КонтрольБюджетныхРезервов),
	|		ЛимитыПоБюджетамОбороты.Предназначение,
	|		ЛимитыПоБюджетамОбороты.ДокументРезервирования,
	|		ЛимитыПоБюджетамОбороты.ПериодЛимитирования,
	|		ЛимитыПоБюджетамОбороты.ЦФО,
	|		ЛимитыПоБюджетамОбороты.Проект,
	|		ЛимитыПоБюджетамОбороты.СтатьяБюджета,
	|		ЛимитыПоБюджетамОбороты.Аналитика1,
	|		ЛимитыПоБюджетамОбороты.Аналитика2,
	|		ЛимитыПоБюджетамОбороты.Аналитика3,
	|		ЛимитыПоБюджетамОбороты.Аналитика4,
	|		ЛимитыПоБюджетамОбороты.Аналитика5,
	|		ЛимитыПоБюджетамОбороты.Аналитика6,
	|		ЛимитыПоБюджетамОбороты.Валюта,
	|		ЛимитыПоБюджетамОбороты.ЛимитОборот + ЛимитыПоБюджетамОбороты.КорректировкаОборот,
	|		ЛимитыПоБюджетамОбороты.ЗарезервированоОборот + ЛимитыПоБюджетамОбороты.ДефицитРезерваОборот,
	|		ЛимитыПоБюджетамОбороты.ЗаявленоОборот,
	|		ЛимитыПоБюджетамОбороты.ИсполненоОборот,
	|		0,
	|		0,
	|		0,
	|		0,
	|		ЛимитыПоБюджетамОбороты.ЛимитОборот + ЛимитыПоБюджетамОбороты.КорректировкаОборот,
	|		ЛимитыПоБюджетамОбороты.ЗарезервированоОборот,
	|		ЛимитыПоБюджетамОбороты.ЗаявленоОборот,
	|		ЛимитыПоБюджетамОбороты.ИсполненоОборот
	|	ИЗ
	|		РегистрНакопления.ЛимитыПоБюджетам.Обороты(
	|				,
	|				,
	|				,
	|				(Предназначение, ДокументРезервирования, ПериодЛимитирования, Валюта, ЦФО, Проект, СтатьяБюджета, Аналитика1, Аналитика2, Аналитика3, Аналитика4, Аналитика5, Аналитика6) В
	|					(ВЫБРАТЬ
	|						ВТ_ДвиженияЛимитыПоБюджетам.Предназначение КАК Предназначение,
	|						ВТ_ДвиженияЛимитыПоБюджетам.ДокументРезервирования КАК ДокументРезервирования,
	|						ВТ_ДвиженияЛимитыПоБюджетам.ПериодЛимитирования КАК ПериодЛимитирования,
	|						ВТ_ДвиженияЛимитыПоБюджетам.Валюта КАК Валюта,
	|						ВТ_ДвиженияЛимитыПоБюджетам.ЦФО КАК ЦФО,
	|						ВТ_ДвиженияЛимитыПоБюджетам.Проект КАК Проект,
	|						ВТ_ДвиженияЛимитыПоБюджетам.СтатьяБюджета КАК СтатьяБюджета,
	|						ВТ_ДвиженияЛимитыПоБюджетам.Аналитика1 КАК Аналитика1,
	|						ВТ_ДвиженияЛимитыПоБюджетам.Аналитика2 КАК Аналитика2,
	|						ВТ_ДвиженияЛимитыПоБюджетам.Аналитика3 КАК Аналитика3,
	|						ВТ_ДвиженияЛимитыПоБюджетам.Аналитика4 КАК Аналитика4,
	|						ВТ_ДвиженияЛимитыПоБюджетам.Аналитика5 КАК Аналитика5,
	|						ВТ_ДвиженияЛимитыПоБюджетам.Аналитика6 КАК Аналитика6
	|					ИЗ
	|						ВТ_ДвиженияЛимитыПоБюджетам КАК ВТ_ДвиженияЛимитыПоБюджетам
	|					ГДЕ
	|						ВТ_ДвиженияЛимитыПоБюджетам.ДокументРезервирования <> НЕОПРЕДЕЛЕНО
	|						И ВТ_ДвиженияЛимитыПоБюджетам.ДокументРезервирования <> ЗНАЧЕНИЕ(Документ.ОперативныйПлан.ПустаяСсылка))) КАК ЛимитыПоБюджетамОбороты
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыКонтроляДокументов.КонтрольБюджетныхРезервов),
	|		ЛимитыПоБюджетам.Предназначение,
	|		ЛимитыПоБюджетам.ДокументРезервирования,
	|		ЛимитыПоБюджетам.ПериодЛимитирования,
	|		ЛимитыПоБюджетам.ЦФО,
	|		ЛимитыПоБюджетам.Проект,
	|		ЛимитыПоБюджетам.СтатьяБюджета,
	|		ЛимитыПоБюджетам.Аналитика1,
	|		ЛимитыПоБюджетам.Аналитика2,
	|		ЛимитыПоБюджетам.Аналитика3,
	|		ЛимитыПоБюджетам.Аналитика4,
	|		ЛимитыПоБюджетам.Аналитика5,
	|		ЛимитыПоБюджетам.Аналитика6,
	|		ЛимитыПоБюджетам.Валюта,
	|		-(ЛимитыПоБюджетам.Лимит + ЛимитыПоБюджетам.Корректировка),
	|		-(ЛимитыПоБюджетам.Зарезервировано + ЛимитыПоБюджетам.ДефицитРезерва),
	|		-ЛимитыПоБюджетам.Заявлено,
	|		-ЛимитыПоБюджетам.Исполнено,
	|		0,
	|		0,
	|		0,
	|		0,
	|		-(ЛимитыПоБюджетам.Лимит + ЛимитыПоБюджетам.Корректировка),
	|		-ЛимитыПоБюджетам.Зарезервировано,
	|		-ЛимитыПоБюджетам.Заявлено,
	|		-ЛимитыПоБюджетам.Исполнено
	|	ИЗ
	|		РегистрНакопления.ЛимитыПоБюджетам КАК ЛимитыПоБюджетам
	|	ГДЕ
	|		&ЭтоНовый = ЛОЖЬ
	|		И ЛимитыПоБюджетам.Регистратор = &Ссылка
	|		И (ЛимитыПоБюджетам.Предназначение, ЛимитыПоБюджетам.ПериодЛимитирования, ЛимитыПоБюджетам.ЦФО, ЛимитыПоБюджетам.Проект, ЛимитыПоБюджетам.СтатьяБюджета, ЛимитыПоБюджетам.Аналитика1, ЛимитыПоБюджетам.Аналитика2, ЛимитыПоБюджетам.Аналитика3, ЛимитыПоБюджетам.Аналитика4, ЛимитыПоБюджетам.Аналитика5, ЛимитыПоБюджетам.Аналитика6, ЛимитыПоБюджетам.Валюта, ЛимитыПоБюджетам.ДокументРезервирования) В
	|				(ВЫБРАТЬ
	|					ВТ_ДвиженияЛимитыПоБюджетам.Предназначение КАК Предназначение,
	|					ВТ_ДвиженияЛимитыПоБюджетам.ПериодЛимитирования КАК ПериодЛимитирования,
	|					ВТ_ДвиженияЛимитыПоБюджетам.ЦФО КАК ЦФО,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Проект КАК Проект,
	|					ВТ_ДвиженияЛимитыПоБюджетам.СтатьяБюджета КАК СтатьяБюджета,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика1 КАК Аналитика1,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика2 КАК Аналитика2,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика3 КАК Аналитика3,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика4 КАК Аналитика4,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика5 КАК Аналитика5,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика6 КАК Аналитика6,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Валюта КАК Валюта,
	|					ВТ_ДвиженияЛимитыПоБюджетам.ДокументРезервирования КАК ДокументРезервирования
	|				ИЗ
	|					ВТ_ДвиженияЛимитыПоБюджетам КАК ВТ_ДвиженияЛимитыПоБюджетам
	|				ГДЕ
	|					ВТ_ДвиженияЛимитыПоБюджетам.ДокументРезервирования <> НЕОПРЕДЕЛЕНО
	|					И ВТ_ДвиженияЛимитыПоБюджетам.ДокументРезервирования <> ЗНАЧЕНИЕ(Документ.ОперативныйПлан.ПустаяСсылка))
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыКонтроляДокументов.КонтрольБюджетныхЛимитов),
	|		ВТ_ДвиженияЛимитыПоБюджетам.Предназначение,
	|		ЗНАЧЕНИЕ(Документ.ОперативныйПлан.ПустаяСсылка),
	|		ВТ_ДвиженияЛимитыПоБюджетам.ПериодЛимитирования,
	|		ВТ_ДвиженияЛимитыПоБюджетам.ЦФО,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Проект,
	|		ВТ_ДвиженияЛимитыПоБюджетам.СтатьяБюджета,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Аналитика1,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Аналитика2,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Аналитика3,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Аналитика4,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Аналитика5,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Аналитика6,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Валюта,
	|		0,
	|		0,
	|		0,
	|		0,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Лимит,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Зарезервировано,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Заявлено,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Исполнено,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Лимит,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Зарезервировано,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Заявлено,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Исполнено
	|	ИЗ
	|		ВТ_ДвиженияЛимитыПоБюджетам КАК ВТ_ДвиженияЛимитыПоБюджетам
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыКонтроляДокументов.КонтрольБюджетныхРезервов),
	|		ВТ_ДвиженияЛимитыПоБюджетам.Предназначение,
	|		ВТ_ДвиженияЛимитыПоБюджетам.ДокументРезервирования,
	|		ВТ_ДвиженияЛимитыПоБюджетам.ПериодЛимитирования,
	|		ВТ_ДвиженияЛимитыПоБюджетам.ЦФО,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Проект,
	|		ВТ_ДвиженияЛимитыПоБюджетам.СтатьяБюджета,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Аналитика1,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Аналитика2,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Аналитика3,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Аналитика4,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Аналитика5,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Аналитика6,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Валюта,
	|		0,
	|		0,
	|		0,
	|		0,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Лимит,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Зарезервировано + ВТ_ДвиженияЛимитыПоБюджетам.ДефицитРезерва,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Заявлено,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Исполнено,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Лимит,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Зарезервировано,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Заявлено,
	|		ВТ_ДвиженияЛимитыПоБюджетам.Исполнено
	|	ИЗ
	|		ВТ_ДвиженияЛимитыПоБюджетам КАК ВТ_ДвиженияЛимитыПоБюджетам
	|	ГДЕ
	|		ВТ_ДвиженияЛимитыПоБюджетам.ДокументРезервирования <> ЗНАЧЕНИЕ(Документ.ОперативныйПлан.ПустаяСсылка)
	|			ИЛИ (ВТ_ДвиженияЛимитыПоБюджетам.Зарезервировано <> 0 И &ЭтоНовый)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	// Уменьшить входящие и исходящее заявлено и зарезервировано на сумму увеличенную документами ЗаявкаНаКорректировкуЛимитов и КорректировкаЛимитов
	|	
	|	ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыКонтроляДокументов.КонтрольБюджетныхЛимитов),
	|		ЛимитыПоБюджетам.Предназначение,
	|		ЛимитыПоБюджетам.ДокументРезервирования,
	|		ЛимитыПоБюджетам.ПериодЛимитирования,
	|		ЛимитыПоБюджетам.ЦФО,
	|		ЛимитыПоБюджетам.Проект,
	|		ЛимитыПоБюджетам.СтатьяБюджета,
	|		ЛимитыПоБюджетам.Аналитика1,
	|		ЛимитыПоБюджетам.Аналитика2,
	|		ЛимитыПоБюджетам.Аналитика3,
	|		ЛимитыПоБюджетам.Аналитика4,
	|		ЛимитыПоБюджетам.Аналитика5,
	|		ЛимитыПоБюджетам.Аналитика6,
	|		ЛимитыПоБюджетам.Валюта,
	|		0,
	|		-ЛимитыПоБюджетам.Зарезервировано,
	|		-ЛимитыПоБюджетам.Заявлено,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		-ЛимитыПоБюджетам.Зарезервировано,
	|		-ЛимитыПоБюджетам.Заявлено,
	|		0
	|	ИЗ
	|		РегистрНакопления.ЛимитыПоБюджетам КАК ЛимитыПоБюджетам
	|	ГДЕ
	|		(ЛимитыПоБюджетам.Предназначение, ЛимитыПоБюджетам.ДокументРезервирования, ЛимитыПоБюджетам.ДокументПланирования, ЛимитыПоБюджетам.ПериодЛимитирования, ЛимитыПоБюджетам.Валюта, ЛимитыПоБюджетам.ЦФО, ЛимитыПоБюджетам.Проект, ЛимитыПоБюджетам.СтатьяБюджета, ЛимитыПоБюджетам.Аналитика1, ЛимитыПоБюджетам.Аналитика2, ЛимитыПоБюджетам.Аналитика3, ЛимитыПоБюджетам.Аналитика4, ЛимитыПоБюджетам.Аналитика5, ЛимитыПоБюджетам.Аналитика6) В
	|				(ВЫБРАТЬ
	|					ВТ_ДвиженияЛимитыПоБюджетам.Предназначение КАК Предназначение,
	|					ВТ_ДвиженияЛимитыПоБюджетам.ДокументРезервирования КАК ДокументРезервирования,
	|					ВТ_ДвиженияЛимитыПоБюджетам.ДокументПланирования КАК ДокументПланирования,
	|					ВТ_ДвиженияЛимитыПоБюджетам.ПериодЛимитирования КАК ПериодЛимитирования,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Валюта КАК Валюта,
	|					ВТ_ДвиженияЛимитыПоБюджетам.ЦФО КАК ЦФО,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Проект КАК Проект,
	|					ВТ_ДвиженияЛимитыПоБюджетам.СтатьяБюджета КАК СтатьяБюджета,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика1 КАК Аналитика1,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика2 КАК Аналитика2,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика3 КАК Аналитика3,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика4 КАК Аналитика4,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика5 КАК Аналитика5,
	|					ВТ_ДвиженияЛимитыПоБюджетам.Аналитика6 КАК Аналитика6
	|				ИЗ
	|					ВТ_ДвиженияЛимитыПоБюджетам КАК ВТ_ДвиженияЛимитыПоБюджетам
	|				ГДЕ
	|					ВТ_ДвиженияЛимитыПоБюджетам.ДокументПланирования <> НЕОПРЕДЕЛЕНО)
	|		И (ЛимитыПоБюджетам.Регистратор ССЫЛКА Документ.ЗаявкаНаКорректировкуЛимитов
	|				ИЛИ ЛимитыПоБюджетам.Регистратор ССЫЛКА Документ.КорректировкаЛимитов)) КАК Запрос
	|
	|СГРУППИРОВАТЬ ПО
	|	Запрос.Проект,
	|	Запрос.Аналитика2,
	|	Запрос.Аналитика4,
	|	Запрос.Аналитика5,
	|	Запрос.Аналитика6,
	|	Запрос.ПериодЛимитирования,
	|	Запрос.ЦФО,
	|	Запрос.Аналитика1,
	|	Запрос.Аналитика3,
	|	Запрос.Валюта,
	|	Запрос.Предназначение,
	|	Запрос.ДокументРезервирования,
	|	Запрос.СтатьяБюджета,
	|	Запрос.ВидКонтроля";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ПолучитьОбластиОтчета(Макет, ИмяОбласти);
	
	Результат = Новый Структура("Начало, До_Свободно, До, ТО_Итог, ТО, ИзРезерва, После_Свободно, После");
	Результат.Начало = Макет.ПолучитьОбласть(ИмяОбласти+"|"+"Начало");
	Результат.ДО_Свободно = Макет.ПолучитьОбласть(ИмяОбласти+"|"+"ДО_Свободно");
	Результат.ДО = Макет.ПолучитьОбласть(ИмяОбласти+"|"+"ДО");
	Результат.ТО_Итог = Макет.ПолучитьОбласть(ИмяОбласти+"|"+"ТО_Итог");
	Результат.ТО = Макет.ПолучитьОбласть(ИмяОбласти+"|"+"ТО");
	Результат.ИзРезерва = Макет.ПолучитьОбласть(ИмяОбласти+"|"+"ИзРезерва");
	Результат.После_Свободно = Макет.ПолучитьОбласть(ИмяОбласти+"|"+"После_Свободно");
	Результат.После = Макет.ПолучитьОбласть(ИмяОбласти+"|"+"После");
	Возврат Результат;
	
КонецФункции

Процедура ВывестиОбластиОтчета(ТабДок, СтруктураМакетов, УровеньСтроки = 0)
	
	ТабДок.Вывести(СтруктураМакетов.Начало, УровеньСтроки);
	ТабДок.Присоединить(СтруктураМакетов.До_Свободно);
	ТабДок.НачатьГруппуКолонок("ДО", Ложь);
	ТабДок.Присоединить(СтруктураМакетов.До);
	ТабДок.ЗакончитьГруппуКолонок();
	ТабДок.Присоединить(СтруктураМакетов.ТО_Итог);
	ТабДок.НачатьГруппуКолонок("ТО", Ложь);
	ТабДок.Присоединить(СтруктураМакетов.ТО);
	ТабДок.ЗакончитьГруппуКолонок();
	ТабДок.Присоединить(СтруктураМакетов.ИзРезерва);
	ТабДок.Присоединить(СтруктураМакетов.После_Свободно);
	ТабДок.НачатьГруппуКолонок("После", Ложь);
	ТабДок.Присоединить(СтруктураМакетов.После);
	ТабДок.ЗакончитьГруппуКолонок();
	
КонецПроцедуры

Процедура ЗаполнитьСуммыВОбласти(ОбластьОтчета, Данные)
	
	// Расчет
	ДоступноДо = Данные.Лимит - Данные.Зарезервировано - Данные.Заявлено - Данные.Исполнено;
	Если Данные.ЗаявленоИзменение > 0 И Данные.ЗарезервированоИзменение < 0 Тогда
		// Это заявка по резерву
		ТекущаяОперация = - Данные.ЗаявленоИзменение;
		ТекущаяОперацияИзРезерва = Данные.ЗарезервированоИзменение;
	Иначе
		ТекущаяОперация = Данные.ЛимитИзменение - Данные.ЗарезервированоИзменение - Данные.ЗаявленоИзменение - Данные.ИсполненоИзменение;
		ТекущаяОперацияИзРезерва = 0;
	КонецЕсли;
	
	ДоступноПосле = ДоступноДо + ТекущаяОперация - ТекущаяОперацияИзРезерва;
	
	// Заполнение областей
	ОбластьОтчета.Начало.Параметры.Заполнить(Данные);
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ОбластьОтчета.Начало.Параметры, "СтрАналитики") Тогда
		ОбластьОтчета.Начало.Параметры.СтрАналитики = КонтрольУХ.ПолучитьПредставлениеСтатьиБюджетаИАналитик(Данные);
	КонецЕсли;
	
	//
	ОбластьОтчета.До_Свободно.Параметры.Лимит = ДоступноДо;
	ОбластьОтчета.До.Параметры.Заполнить(Данные);
	//
	ОбластьОтчета.ТО_Итог.Параметры.ТекущаяОперация = ТекущаяОперация;
	ОбластьОтчета.ТО.Параметры.ЛимитИзменение = Данные.ЛимитИзменение;
	ОбластьОтчета.ТО.Параметры.ЗарезервированоИзменение = Данные.ЗарезервированоИзменение;
	ОбластьОтчета.ТО.Параметры.ЗаявленоИзменение = Данные.ЗаявленоИзменение;
	ОбластьОтчета.ТО.Параметры.ИсполненоИзменение = Данные.ИсполненоИзменение;
	//
	ОбластьОтчета.ИзРезерва.Параметры.ТекущаяОперацияИзРезерва = ТекущаяОперацияИзРезерва;
	//
	ОбластьОтчета.После_Свободно.Параметры.Доступно =  ДоступноПосле;
	ОбластьОтчета.После.Параметры.ЛимитИсх = Данные.Лимит + Данные.ЛимитИзменение;
	ОбластьОтчета.После.Параметры.ЗарезервированоИсх = Данные.Зарезервировано + Данные.ЗарезервированоИзменение;
	ОбластьОтчета.После.Параметры.ЗаявленоИсх = Данные.Заявлено + Данные.ЗаявленоИзменение;
	ОбластьОтчета.После.Параметры.ИсполненоИсх = Данные.Исполнено + Данные.ИсполненоИзменение;
	
КонецПроцедуры

#КонецОбласти
 

