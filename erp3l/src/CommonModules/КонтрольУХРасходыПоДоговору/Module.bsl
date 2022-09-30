
#Область СлужебныйПрограммныйИнтерфейс

// Функция возвращает объект-проверку
Функция Создать() Экспорт
	
	Проверка = КонтрольУХ.Новый_Проверка();
	Проверка.Объект = КонтрольУХРасходыПоДоговору;
	Проверка.Источник = ИмяИсточника();
	Проверка.ВидКонтроля = ПланыВидовХарактеристик.ВидыКонтроляДокументов.КонтрольРасходовПоДоговору;
	Проверка.СтандартныйКонтроль = Истина;
	
	Возврат Проверка;
	
КонецФункции

// Функция возвращает Истина, если для этого документа проверка выполняется
Функция ТребуетсяДляДокумента(ИмяДокумента) Экспорт
	Возврат Истина;
КонецФункции

// Функция возвращает Истина, если требуется выполнение проверки
Функция ТребуетсяПроверка(ПараметрыКонтроля, Источник) Экспорт
	
	Если ТипЗнч(Источник) <> Тип("Структура") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Истина;
	
	ОбязательныеПоля = "Организация,Контрагент,Договор";
	Для Каждого ИмяПоля Из СтрРазделить(ОбязательныеПоля, ",") Цикл
		Результат = Результат И Источник.Свойство(ИмяПоля) И ЗначениеЗаполнено(Источник[ИмяПоля]);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Функция выполняет обработку данных источника
Функция ОбработатьДанныеИсточника(ИнформацияДляКонтроля, Источник) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	//
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Для Каждого КлючЗначение Из Источник Цикл
		Если ТипЗнч(КлючЗначение.Значение) = Тип("ТаблицаЗначений") Тогда
			Продолжить;
		КонецЕсли;
		Запрос.УстановитьПараметр(КлючЗначение.Ключ, КлючЗначение.Значение);
	КонецЦикла;
	
	//
	ОбщегоНазначенияОПК.ЗагрузитьТаблицуВоВременнуюТаблицуЗапроса(
		Запрос, "ВТ_ДанныеДляПроверки", Источник.ДанныеДляПроверки);
	
	ТекстыЗапросов = Новый Массив;
	
	ТекстыЗапросов.Добавить(КонтрольУХВстраивание.ТекстЗапроса_РасходыПоДоговору_ЗаявленоИзменение());
	ТекстыЗапросов.Добавить(КонтрольУХВстраивание.ТекстЗапроса_Предел());
	ТекстыЗапросов.Добавить(КонтрольУХВстраивание.ТекстЗапроса_РасходыПоДоговору_Заявлено());
	ТекстыЗапросов.Добавить(КонтрольУХВстраивание.ТекстЗапроса_РасходыПоДоговору_Факт());
	ТекстыЗапросов.Добавить(ТекстЗапроса_ИтоговыйЗапрос());
	
	Запрос.Текст = СтрСоединить(ТекстыЗапросов, ОбщегоНазначенияОПК.ТекстРазделителяЗапросовПакета());
	
	Данные = Запрос.Выполнить().Выгрузить();
	
	Возврат Данные;
	
КонецФункции

// Процедура выполняет контроль обработанных данных
Процедура ВыполнитьКонтроль(ИнформацияДляКонтроля, СтрокаРезультат, ДанныеДляКонтроля) Экспорт
КонецПроцедуры

// Функция возвращает Истина, если нарушение контроля должно приводить к блокированию проведения
Функция БлокироватьПроведение(КлючКонтроля) Экспорт
	
	РежимКонтроля = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПланыВидовХарактеристик.ВидыКонтроляДокументов.КонтрольРасходовПоДоговору, "РежимКонтроля");
	Возврат РежимКонтроля = Перечисления.РежимыКонтроляДокументов.Блокировать
	
КонецФункции

// Возвращает имя источника для проверки
//
Функция ИмяИсточника() Экспорт
	Возврат "РасходыПоДоговору";
КонецФункции

// Возвращает структуру-источник для проверки документа
Функция СтруктураИсточник(Документ, Организация, КонтрольОплаты) Экспорт
	
	//
	Результат = Новый Структура;
	Результат.Вставить("КонтрольОплаты",	КонтрольОплаты); // Если Истина, то контролируем оплату иначе контролируем поставку
	Результат.Вставить("Документ", 			Документ);
	Результат.Вставить("Организация",		Организация);
	Результат.Вставить("Заявлено",			0);
	Результат.Вставить("Контрагент");
	Результат.Вставить("Договор");
	
	// Таблица с данными
	ДанныеДляПроверки = Новый ТаблицаЗначений;
	ДанныеДляПроверки.Колонки.Добавить("Организация",	Метаданные.ОпределяемыеТипы.Организации.Тип);
	ДанныеДляПроверки.Колонки.Добавить("ЭтоОплата",		Новый ОписаниеТипов("Булево"));
	ДанныеДляПроверки.Колонки.Добавить("Контрагент",	Метаданные.ОпределяемыеТипы.Контрагенты.Тип);
	ДанныеДляПроверки.Колонки.Добавить("Договор",		Метаданные.ОпределяемыеТипы.Договор.Тип);
	ДанныеДляПроверки.Колонки.Добавить("ОбъектРасчетов",Новый ОписаниеТипов("СправочникСсылка.ОбъектыРасчетов"));
	ДанныеДляПроверки.Колонки.Добавить("Валюта",		Метаданные.ОпределяемыеТипы.Валюты.Тип); // Валюта взаиморасчетов
	ДанныеДляПроверки.Колонки.Добавить("Сумма",			Метаданные.ОпределяемыеТипы.ДенежнаяСуммаЛюбогоЗнака.Тип); // Сумма взаиморасчетов
	
	Результат.Вставить("ДанныеДляПроверки", ДанныеДляПроверки);
	
	Возврат Результат;
	
КонецФункции

// Процедура возвращает табличный документ с расшифровкой контроля документа
//
Функция СформироватьРасшифровкуКонтроля(Проверка, СтрокаКонтроль) Экспорт
	
	РезультатКонтроля = ПолучитьИзВременногоХранилища(СтрокаКонтроль.АдресРезультата);
	ДанныеКонтроля = РезультатКонтроля.Скопировать();
	
	// КОНТРОЛЬ РАСХОДОВ ПО ДОГОВОРУ
	ДанныеКонтроля.Колонки.Добавить("КонтрагентПредставление");
	ВсеРеквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(
		ДанныеКонтроля.ВыгрузитьКолонку("Контрагент"), "Наименование, НаименованиеПолное");
	Для Каждого Строка Из ДанныеКонтроля Цикл
		Реквизиты = ВсеРеквизиты[Строка.Контрагент];
		Если Реквизиты = неопределено Тогда
			Строка.КонтрагентПредставление = НСтр("ru = 'Не указан'");
		ИначеЕсли ЗначениеЗаполнено(Реквизиты.НаименованиеПолное) Тогда
			Строка.КонтрагентПредставление = Реквизиты.НаименованиеПолное;
		Иначе
			Строка.КонтрагентПредставление = Реквизиты.Наименование;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СформироватьОтчетКонтрольРасходовПоДоговору(СтрокаКонтроль, ДанныеКонтроля);
	
КонецФункции

// Процедура сохраняет данные для контроля в табличной части документа
//
// Параметры:
//  ДанныеДляКонтроля	- Таблица значений	- Результат контроля
//  РезультатыКонтроля	- ТабличнаяЧасть	- табличная часть РезультатыКонтроля проверяемого документа
//
Процедура СохранитьДанныеДляКонтроляВДокументе(ДанныеДляКонтроля, РезультатыКонтроля) Экспорт
	
	Инфо = РегистрыСведений.АналитикаКонтроляПоДоговорам.ИнформацияОКлюче();
	ИменаПолей = КонтрольУХКлючи.ИменаПолейКоллекцииПоУмолчанию(Инфо);
	ИменаПолей.АналитикаКонтроляПоДоговорам = "КлючКонтроля";
	
	КонтрольУХКлючи.ЗаполнитьВКоллекции(Инфо, ДанныеДляКонтроля, ИменаПолей);
	
	// Загрузить результат контроля в тч.РезультатыКонтроля
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
		"Организация",
		Новый ОписаниеТипов("СправочникСсылка.Организации"));
	КонтрольУХ.ДобавитьКолонкуКонтроля(Колонки, 
		"Контрагент",
		Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	КонтрольУХ.ДобавитьКолонкуКонтроля(Колонки, 
		"Договор",
		Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов"));
	КонтрольУХ.ДобавитьКолонкуКонтроля(Колонки, 
		"ВерсияСоглашения",
		Новый ОписаниеТипов("ДокументСсылка.ВерсияСоглашенияКоммерческийДоговор"));
	
	Результат = Новый Структура;
	Результат.Вставить("Источник", "Справочник.КлючиКонтроляПоДоговорам");
	Результат.Вставить("Колонки", Колонки);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьОтчетКонтрольРасходовПоДоговору(СтрокаКонтроль, ДанныеКонтроля)
	
	ТабДок = Новый ТабличныйДокумент;
	
	Макет = ПланыВидовХарактеристик.ВидыКонтроляДокументов.ПолучитьМакет("КонтрольРасходовПоДоговору");
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");
	
	ТабДок.Очистить();
	ОбластьЗаголовок.Параметры.Документ = СтрокаКонтроль.Документ;
	
	ОбластьЗаголовок.Параметры.ДатаВремяКонтроля = СтрокаКонтроль.ВремяПроверки;
	ОбластьЗаголовок.Параметры.ТекущееВремя = ТекущаяДатаСеанса();
	ОбластьЗаголовок.Параметры.ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);

	//
	ТабДок.НачатьАвтогруппировкуСтрок();
	Для каждого Данные Из ДанныеКонтроля Цикл
		ОбластьДетальныхЗаписей.Параметры.Заполнить(Данные);
		ОбластьДетальныхЗаписей.Параметры.ДоступноПослеОперации = 
			Данные.Лимит + Данные.ЛимитИзменение
			- Данные.Исполнено - Данные.ИсполненоИзменение
			- Данные.Зарезервировано - Данные.ЗарезервированоИзменение 
			- Данные.Заявлено - Данные.ЗаявленоИзменение;
		ТабДок.Вывести(ОбластьДетальныхЗаписей);
	КонецЦикла; 
	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	
	//
	ДанныеКонтроля.Свернуть("", "Лимит, Исполнено, Зарезервировано, Заявлено, ЛимитИзменение, ИсполненоИзменение, ЗарезервированоИзменение, ЗаявленоИзменение");
	Если ДанныеКонтроля.Количество()>0 Тогда
		Данные = ДанныеКонтроля[0];
		ОбластьПодвалТаблицы.Параметры.Заполнить(Данные);
		ОбластьПодвалТаблицы.Параметры.ДоступноПослеОперации = 
			Данные.Лимит + Данные.ЛимитИзменение
			- Данные.Исполнено - Данные.ИсполненоИзменение
			- Данные.Зарезервировано - Данные.ЗарезервированоИзменение 
			- Данные.Заявлено - Данные.ЗаявленоИзменение;
	КонецЕсли;
	
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ТабДок.Вывести(ОбластьПодвал);
	
	Возврат ТабДок;
	
КонецФункции

Функция ТекстЗапроса_ИтоговыйЗапрос()
	
	Возврат
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыКонтроляДокументов.КонтрольРасходовПоДоговору) КАК ВидКонтроля,
	|	ЗНАЧЕНИЕ(Справочник.КлючиКонтроляПоДоговорам.ПустаяСсылка) КАК КлючКонтроля,
	|	Запрос.Организация КАК Организация,
	|	Запрос.Контрагент КАК Контрагент,
	|	Запрос.Договор КАК Договор,
	|	ВЫРАЗИТЬ(Запрос.Договор КАК Справочник.ДоговорыКонтрагентов).ВерсияСоглашения КАК ВерсияСоглашения,
	|	Запрос.Валюта КАК Валюта,
	|	Запрос.ЭтоОплата КАК ЭтоОплата,
	|	СУММА(Запрос.Лимит) КАК Лимит,
	|	0 КАК Зарезервировано,
	|	СУММА(Запрос.Заявлено) КАК Заявлено,
	|	СУММА(Запрос.Исполнено) КАК Исполнено,
	|	0 КАК ЛимитИзменение,
	|	0 КАК ЗарезервированоИзменение,
	|	СУММА(Запрос.ЗаявленоИзменение) КАК ЗаявленоИзменение,
	|	0 КАК ИсполненоИзменение,
	|	СУММА(Запрос.Лимит) - СУММА(Запрос.Заявлено) - СУММА(Запрос.Исполнено) - СУММА(Запрос.ЗаявленоИзменение) КАК ДоступноПослеОперации,
	|	СУММА(Запрос.Лимит) - СУММА(Запрос.Заявлено) - СУММА(Запрос.Исполнено) - СУММА(Запрос.ЗаявленоИзменение) < 0 КАК КонтрольНарушен
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВТ_Лимит.ЭтоОплата КАК ЭтоОплата,
	|		ВТ_Лимит.Организация КАК Организация,
	|		ВТ_Лимит.Контрагент КАК Контрагент,
	|		ВТ_Лимит.Договор КАК Договор,
	|		ВТ_Лимит.Валюта КАК Валюта,
	|		ВТ_Лимит.Лимит КАК Лимит,
	|		0 КАК Заявлено,
	|		0 КАК Исполнено,
	|		0 КАК ЗаявленоИзменение
	|	ИЗ
	|		ВТ_Лимит КАК ВТ_Лимит
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ВТ_Заявлено.ЭтоОплата,
	|		ВТ_Заявлено.Организация,
	|		ВТ_Заявлено.Контрагент,
	|		ВТ_Заявлено.Договор,
	|		ВТ_Заявлено.Валюта,
	|		0,
	|		ВТ_Заявлено.Заявлено,
	|		0,
	|		0
	|	ИЗ
	|		ВТ_Заявлено КАК ВТ_Заявлено
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ВТ_Факт.ЭтоОплата,
	|		ВТ_Факт.Организация,
	|		ВТ_Факт.Контрагент,
	|		ВТ_Факт.Договор,
	|		ВТ_Факт.Валюта,
	|		0,
	|		0,
	|		ВТ_Факт.Исполнено,
	|		0
	|	ИЗ
	|		ВТ_Факт КАК ВТ_Факт
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ВТ_ЗаявленоИзменение.ЭтоОплата,
	|		ВТ_ЗаявленоИзменение.Организация,
	|		ВТ_ЗаявленоИзменение.Контрагент,
	|		ВТ_ЗаявленоИзменение.Договор,
	|		ВТ_ЗаявленоИзменение.Валюта,
	|		0,
	|		0,
	|		0,
	|		ВТ_ЗаявленоИзменение.ЗаявленоИзменение
	|	ИЗ
	|		ВТ_ЗаявленоИзменение КАК ВТ_ЗаявленоИзменение) КАК Запрос
	|ГДЕ
	|	Запрос.ЭтоОплата = &КонтрольОплаты
	|
	|СГРУППИРОВАТЬ ПО
	|	Запрос.Организация,
	|	Запрос.Контрагент,
	|	Запрос.Договор,
	|	Запрос.Валюта,
	|	Запрос.ЭтоОплата";
	
КонецФункции

#КонецОбласти
 
