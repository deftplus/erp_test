#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Номер");
	Поля.Добавить("Дата");
	Поля.Добавить("ПланСчетовУчета");
	Поля.Добавить("Описание");	
		
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Данные.Описание) Тогда
		
		ШаблонП = НСтр("ru = '%1 №%2 %3'");
		Представление = СтрШаблон(ШаблонП, Данные.ПланСчетовУчета, Данные.Номер, Данные.Описание);
	
	Иначе 
		
		ШаблонП = НСтр("ru = '%1 №%2'");
		Представление = СтрШаблон(ШаблонП, Данные.ПланСчетовУчета, Данные.Номер);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

Функция ЗначениеУП(ИмяРеквизита, Организация = Неопределено, ДатаУП = Неопределено, Сценарий = Неопределено) Экспорт 

	Запрос = Новый Запрос(ТекстЗапроса_ЗначениеУП(ИмяРеквизита));
	
	Запрос.УстановитьПараметр("Организация",	Организация);
	Запрос.УстановитьПараметр("ДатаУП", 		?(ЗначениеЗаполнено(ДатаУП), ДатаУП, ТекущаяДата()));
	Запрос.УстановитьПараметр("Сценарий", 		?(ЗначениеЗаполнено(Сценарий), Сценарий, Справочники.Сценарии.Факт));
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить()[0].Значение;
	
КонецФункции

Функция ЗначенияУП(ИменаРеквизитовУП, Организация = Неопределено, ДатаУП = Неопределено, Сценарий = Неопределено) Экспорт 

	Запрос = Новый Запрос(ТекстЗапроса_ЗначенияУП(ИменаРеквизитовУП));
	
	Запрос.УстановитьПараметр("Организация",	Организация);
	Запрос.УстановитьПараметр("ДатаУП", 		?(ЗначениеЗаполнено(ДатаУП), ДатаУП, ТекущаяДата()));
	Запрос.УстановитьПараметр("Сценарий", 		Сценарий);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция РеквизитыДокумента(Запрос, ИменаДопРеквизитов = Неопределено, ИмяПериодОтчета = "ПериодОтчета", Отказ = Неопределено) Экспорт

	ИмяДокумента = Метаданные.НайтиПоТипу(ТипЗнч(Запрос.Параметры.Ссылка)).Имя;
	
	ТекстДопРеквизиты = ТекстДопРеквизиты(ИменаДопРеквизитов, ИмяПериодОтчета);
	
	ТекстЗапроса = Новый Массив;
	НомераТаблиц = Новый Структура;
	
	ТекстЗапроса.Добавить(ТекстЗапроса_втУП(НомераТаблиц));
	ТекстЗапроса.Добавить(ТекстЗапроса_втАОСВ(НомераТаблиц, ТекстДопРеквизиты));
	ТекстЗапроса.Добавить(ТекстЗапроса_Реквизиты(НомераТаблиц, ТекстДопРеквизиты));
	
	Запрос.Текст = СтрСоединить(ТекстЗапроса, ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета());
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВводВНАВЭксплуатациюМСФО", ИмяДокумента);
			
	Реквизиты = ПроведениеСерверУХ.СтрокаТаблицыЗначенийВСтруктуру(Запрос.Выполнить().Выгрузить()[0]);
	
	МСФОУХ.ПроверитьРеквизиты(Реквизиты, Отказ);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Запрос.Параметры, Реквизиты, Ложь);
	
	Возврат Реквизиты;

КонецФункции

Функция ЗаменитьФиксированныеСчетаУчетаБД(ТекстЗапроса) Экспорт

	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетныеПолитикиМСФО") Тогда
		Возврат ТекстЗапроса;	
	КонецЕсли;
	
	СтрокаПоиска = "Справочник.ФиксированныеСчетаУчетаБД КАК";
	ТекстЗамены = 
	"ВЫБРАТЬ
	|	т.Ссылка КАК Ссылка,
	|	ЕСТЬNULL(рс.Счет, т.Счет) КАК Счет,
	|	ЕСТЬNULL(рс.Субконто1, т.Субконто1) КАК Субконто1,
	|	ЕСТЬNULL(рс.Субконто2, т.Субконто2) КАК Субконто2,
	|	ЕСТЬNULL(рс.Субконто3, т.Субконто3) КАК Субконто3
	|ИЗ
	|	Справочник.ФиксированныеСчетаУчетаБД КАК т
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФиксированныеСчетаБД КАК рс
	|		ПО т.Ссылка = рс.ВидСчета
	|			И (рс.УчетнаяПолитика = &УчетнаяПолитика)";
		
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, СтрокаПоиска,	СтрШаблон("(%1) КАК", ТекстЗамены));
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ФиксированныйСчет(ФиксированныйСчетБД, УчетнаяПолитика = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(УчетнаяПолитика) 
		Или Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетныеПолитикиМСФО") Тогда
	
		Возврат ФиксированныйСчетБД.Счет;
	
	КонецЕсли;
	
	Отбор = Новый Структура("УчетнаяПолитика, ВидСчета", УчетнаяПолитика, ФиксированныйСчетБД);
	ЗначенияУП = РегистрыСведений.ФиксированныеСчетаБД.Получить(Отбор);
	Возврат ЗначенияУП.Счет;

КонецФункции

#КонецОбласти

#Область ЗапросУП

// Функция - Текст запроса значения УП
//
// Параметры:
//  ИменаРеквизитов	 - <Строка>	 - строка полями получения, например:
//	|т.Сценарий КАК Сценарий
//	|т.УчетнаяПолитика КАК УчетнаяПолитика
//	|т.ПрименяетсяС КАК ПрименяетсяС
//  |УчетнаяПолитика.ВалютаИсточник КАК ВалютаИсточник
//  |УчетнаяПолитика.ВалютаУчета КАК ВалютаУчета
//  |УчетнаяПолитика.ПланСчетовУчета КАК ПланСчетовУчета
//  |ШаблонТрансляции.ПланСчетовИсточник КАК ПланСчетовИсточник
//  НомераТаблиц	 - <Структура>	 - номера таблиц
// 
// Возвращаемое значение:
//   - Текст запроса
//
Функция ТекстЗапроса_ЗначенияУП(ИменаРеквизитов = "", НомераТаблиц = Неопределено) Экспорт
	
	Если НомераТаблиц <> Неопределено Тогда
		
		НомераТаблиц.Вставить("втПоОгранизации",	НомераТаблиц.Количество());
		НомераТаблиц.Вставить("втОбщие", 			НомераТаблиц.Количество());
		НомераТаблиц.Вставить("ЗначенияУП", 		НомераТаблиц.Количество());
		
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	т.Период КАК Период,
	|	т.Организация КАК Организация,
	|	т.Сценарий КАК Сценарий,
	|	т.УчетнаяПолитика КАК УчетнаяПолитика
	|ПОМЕСТИТЬ втПоОгранизации
	|ИЗ
	|	РегистрСведений.УчетныеПолитикиМСФО.СрезПоследних(
	|			&ДатаУП,
	|			Организация В (&Организация)
	|				И ВЫБОР
	|					КОГДА &Сценарий = НЕОПРЕДЕЛЕНО
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ Сценарий В (&Сценарий)
	|				КОНЕЦ) КАК т
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Сценарий
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	т.Период КАК Период,
	|	Организации.Ссылка КАК Организация,
	|	ЕСТЬNULL(т.Сценарий, ЗНАЧЕНИЕ(Справочник.Сценарии.ПустаяСсылка)) КАК Сценарий,
	|	т.УчетнаяПолитика КАК УчетнаяПолитика
	|ПОМЕСТИТЬ втОбщие
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетныеПолитикиМСФО.СрезПоследних(
	|				&ДатаУП,
	|				Организация В (ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))
	|					И ВЫБОР
	|						КОГДА &Сценарий = НЕОПРЕДЕЛЕНО
	|							ТОГДА ИСТИНА
	|						ИНАЧЕ Сценарий В (&Сценарий)
	|					КОНЕЦ) КАК т
	|		ПО (ИСТИНА)
	|ГДЕ
	|	Организации.Ссылка В(&Организация)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Сценарий
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&ДопПоля КАК ДопПоля,
	|	т.Организация КАК Организация
	|ИЗ
	|	(ВЫБРАТЬ
	|		втОбщие.Организация КАК Организация,
	|		ЕСТЬNULL(втПоОгранизации.Сценарий, втОбщие.Сценарий) КАК Сценарий,
	|		ВЫБОР
	|			КОГДА НЕ втОбщие.Период ЕСТЬ NULL
	|					И (втПоОгранизации.Период ЕСТЬ NULL
	|						ИЛИ втОбщие.Период > втПоОгранизации.Период)
	|				ТОГДА втОбщие.УчетнаяПолитика
	|			ИНАЧЕ втПоОгранизации.УчетнаяПолитика
	|		КОНЕЦ КАК УчетнаяПолитика,
	|		ВЫБОР
	|			КОГДА НЕ втОбщие.Период ЕСТЬ NULL
	|					И (втПоОгранизации.Период ЕСТЬ NULL
	|						ИЛИ втОбщие.Период > втПоОгранизации.Период)
	|				ТОГДА втОбщие.Период
	|			ИНАЧЕ втПоОгранизации.Период
	|		КОНЕЦ КАК ПрименяетсяС
	|	ИЗ
	|		втОбщие КАК втОбщие
	|			ЛЕВОЕ СОЕДИНЕНИЕ втПоОгранизации КАК втПоОгранизации
	|			ПО втОбщие.Организация = втПоОгранизации.Организация
	|				И (ВЫБОР
	|					КОГДА втОбщие.Сценарий = ЗНАЧЕНИЕ(Справочник.Сценарии.ПустаяСсылка)
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ втПоОгранизации.Сценарий = втОбщие.Сценарий
	|				КОНЕЦ)) КАК т";
	                                        
	Возврат СтрЗаменить(ТекстЗапроса, "&ДопПоля КАК ДопПоля", ИменаРеквизитов);
	
КонецФункции

Функция ТекстЗапроса_ЗначениеУП(ИмяРеквизита = "ВалютаУчета")

	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	т.УчетнаяПолитика.ВалютаУчета КАК Значение
	|ИЗ
	|	РегистрСведений.УчетныеПолитикиМСФО.СрезПоследних(
	|			&ДатаУП,
	|			Организация В (&Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))
	|				И Сценарий = &Сценарий) КАК т
	|
	|УПОРЯДОЧИТЬ ПО
	|	т.Организация УБЫВ";
	
	Возврат СтрЗаменить(ТекстЗапроса, "ВалютаУчета", ИмяРеквизита);
	
КонецФункции

Функция ТекстЗапроса_втУП(НомераТаблиц)

	НомераТаблиц.Вставить("втУП", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	УП.Период КАК Период,
	|	УП.УчетнаяПолитика КАК УП
	|ПОМЕСТИТЬ втУП
	|ИЗ
	|	РегистрСведений.УчетныеПолитикиМСФО КАК УП
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВводВНАВЭксплуатациюМСФО КАК втДокумент
	|		ПО УП.Организация В (втДокумент.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))
	|			И втДокумент.Сценарий = УП.Сценарий
	|			И втДокумент.Дата >= УП.Период
	|ГДЕ
	|	втДокумент.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	УП.Период УБЫВ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	УП.УчетнаяПолитика";
	
	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапроса_втАОСВ(НомераТаблиц, ТекстДопРеквизиты = Неопределено)

	НомераТаблиц.Вставить("втАОСВ", НомераТаблиц.Количество());
		
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	т.Ссылка КАК ВидОтчетаАОСВ
	|ПОМЕСТИТЬ втАОСВ
	|ИЗ
	|	Справочник.ВидыОтчетов КАК т
	|ГДЕ
	|	т.Предназначение = ЗНАЧЕНИЕ(Перечисление.ПредназначенияЭлементовСтруктурыОтчета.ОборотноСальдоваяВедомость)
	|	И т.ИспользоватьПоУмолчанию
	|	И НЕ т.НеФормироватьАналитическиеРаскрытия
	|	И ЛОЖЬ
	|	И т.ПланСчетов В
	|			(ВЫБРАТЬ
	|				втУП.УП.ПланСчетовУчета
	|			ИЗ
	|				втУП КАК втУП)";
	
	Если (ТекстДопРеквизиты <> Неопределено) 
		И СтрНайти(ТекстДопРеквизиты, "ВидОтчета") > 0 Тогда
	
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ЛОЖЬ", "ИСТИНА");
	
	КонецЕсли;
	
	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапроса_Реквизиты(НомераТаблиц, ТекстДопРеквизиты = Неопределено)

	НомераТаблиц.Вставить("втРеквизитыУП", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	д.Дата КАК Период,
	|	д.Дата КАК Дата,
	|	д.Организация КАК Организация,
	|	""ДопПоля"" КАК ДопПоля,
	|	д.Сценарий КАК Сценарий,
	|	д.Ссылка КАК Ссылка,
	|	ЕСТЬNULL(ВЫБОР
	|			КОГДА втУП.УП.ШаблонТрансляции.НаправлениеТрансляции = ЗНАЧЕНИЕ(Перечисление.НаправленияТрансляцииДанных.РегистрБухгалтерииВРегистрБухгалтерии)
	|				ТОГДА ЗНАЧЕНИЕ(Перечисление.МоделиУчетаМСФО.ТранзакционныйУчетПроводки)
	|			ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.МоделиУчетаМСФО.ТрансформационныйУчетКорректировки)
	|		КОНЕЦ, д.Организация.Удалить_МодельУчетаМСФО) КАК МодельУчетаМСФО,
	|	ЕСТЬNULL(втУП.УП.ШаблонТрансляции.НаправлениеТрансляции = ЗНАЧЕНИЕ(Перечисление.НаправленияТрансляцииДанных.РегистрБухгалтерииВРегистрБухгалтерии), д.Организация.Удалить_МодельУчетаМСФО = ЗНАЧЕНИЕ(Перечисление.МоделиУчетаМСФО.ТранзакционныйУчетПроводки)) КАК ФормироватьПроводкиМСФО,
	|	ЕСТЬNULL(втУП.УП.ВалютаУчета, д.Организация.ФункциональнаяВалюта) КАК ФункциональнаяВалюта,
	|	ЕСТЬNULL(втУП.УП.ВалютаУчетаДоп, д.Организация.Удалить_ВалютаПредоставленияОтчетности) КАК ВалютаПредставления,
	|	ЕСТЬNULL(втУП.УП.ВалютаИсточник, д.Организация.ФункциональнаяВалюта) КАК ВалютаИсточник,
	|	ЕСТЬNULL(втУП.УП.ВалютаИсточникДоп, д.Организация.ФункциональнаяВалюта) КАК ВалютаИсточникДоп,
	|	ЕСТЬNULL(втУП.УП.ПланСчетовУчета, псМСФО.Ссылка) КАК ПланСчетовМСФО,
	|	ЕСТЬNULL(втУП.Период, д.Дата) КАК ДатаУП,
	|	ЕСТЬNULL(втУП.УП, д.Организация) КАК УчетнаяПолитика
	|ИЗ
	|	Документ.ВводВНАВЭксплуатациюМСФО КАК д
	|		ЛЕВОЕ СОЕДИНЕНИЕ втУП КАК втУП
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ втАОСВ КАК втАОСВ
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПланыСчетовБД КАК псМСФО
	|		ПО (втУП.УП ЕСТЬ NULL)
	|			И (псМСФО.Наименование = ""МСФО"")
	|			И (псМСФО.Владелец = ЗНАЧЕНИЕ(Справочник.ТипыБазДанных.ТекущаяИБ))
	|ГДЕ
	|	д.Ссылка = &Ссылка";
	
	Если ТекстДопРеквизиты <> Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, """ДопПоля""", ТекстДопРеквизиты);	
	КонецЕсли;
	
	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстДопРеквизиты(ИменаДопРеквизитов, ИмяПериодОтчета)

	ПутиДопРеквизитов = ПутиДопРеквизитов(ИменаДопРеквизитов, ИмяПериодОтчета);
	
	Замены = Новый Массив;
	Для каждого р Из ПутиДопРеквизитов Цикл
		ВыражениеПоля = ?(р.Значение = Неопределено, "д." + р.Ключ, р.Значение);
		Замены.Добавить(СтрШаблон("%1 КАК %2", ВыражениеПоля, р.Ключ));
	КонецЦикла;
	Замены.Добавить("NULL");
	
	Возврат СтрСоединить(Замены, ", ");

КонецФункции

Функция ПутиДопРеквизитов(ИменаДопРеквизитов, ИмяПериодОтчета = "ПериодОтчета")

	Если ТипЗнч(ИменаДопРеквизитов) = Тип("Строка") Тогда
	    Результат = Новый Структура(ИменаДопРеквизитов);
	Иначе 
		Результат = ИменаДопРеквизитов;
	КонецЕсли;
	
	ПолеАлгоритмРСБУ = 
	"ИСТИНА В
	|		(ВЫБРАТЬ
	|			т.Значение
	|		ИЗ
	|			Константа.АлгоритмНачиcленияАмортизацииАналогичноРСБУ КАК т)";

	тПериодОтчета = "д." + ИмяПериодОтчета;
	
	ИсточникДоп = Новый Структура(
						"ПериодОтчета, ДатаНачала, ДатаОкончания,
						|ЭлиминирующаяОрганизация, РегламентированнаяОрганизация,
						|ВидОтчета, ПланСчетовИсточник,
						|АлгоритмРСБУ, РеализуемыеАктивыВГО",
		
						тПериодОтчета,
						тПериодОтчета + ".ДатаНачала",
						тПериодОтчета + ".ДатаОкончания",
	
						"д.Организация.ЭлиминирующаяОрганизация",
						"д.Организация.ИспользоватьВРегламентированномУчете",
						
	                    "втАОСВ.ВидОтчетаАОСВ",
	                    "втУП.УП.ШаблонТрансляции.ПланСчетовИсточник",
	
						ПолеАлгоритмРСБУ,	
						"ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоКорпоративные.РеализуемыеАктивыВГО)"
					);
	
	ЗаполнитьЗначенияСвойств(Результат, ИсточникДоп);
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область Обновление

Процедура Обновление_ПерейтиНаУП(Параметры = Неопределено) Экспорт
	
	НомераТаблиц = Новый Структура;
	Запрос = Новый Запрос(ТекстЗапроса_ДляОбновления(НомераТаблиц));
	Запрос.УстановитьПараметр("Дата", КонецГода(ТекущаяДата()));
	РезультатПакет = Запрос.ВыполнитьПакет();
	
	СозданныеУП = Новый Соответствие;
	
	Выборка = РезультатПакет[НомераТаблиц.СоздатьУП].Выбрать();	
	Пока Выборка.Следующий() Цикл
		
		УП = Документы.УчетнаяПолитикаМСФО.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(УП, Выборка);
		УП.УстановитьНовыйНомер();
		УП.Комментарий = НСтр("ru = 'Создан автоматически при обновлении ИБ'");
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(УП);
		
		СозданныеУП.Вставить(Выборка.УчетнаяПолитикаСоздать, УП.Ссылка);
		
	КонецЦикла; 
	
	Выборка = РезультатПакет[НомераТаблиц.СоздатьРС].Выбрать();	
	Пока Выборка.Следующий() Цикл
		
		УП = Выборка.УчетнаяПолитикаСоздать;
		Если ТипЗнч(Выборка.УчетнаяПолитикаСоздать) = Тип("Число") Тогда
			УП = СозданныеУП.Получить(Выборка.УчетнаяПолитикаСоздать);	
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(УП) Тогда
			
			ОписаниеОшибки = НСтр("ru = 'Не удалось установить учетную политику для организации <%1> в сценарии <%2> на дату <%3>'");
			ЗаписьЖурналаРегистрации(
					ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
					УровеньЖурналаРегистрации.Ошибка, , , 
					СтрШаблон(ОписаниеОшибки, Выборка.Организация, Выборка.Сценарий, Выборка.Период)
				);

			Продолжить;
			
		КонецЕсли;
		
		МСФОВызовСервераУХ.ЗаписатьУПМСФО(УП, Выборка.Организация, Выборка.Сценарий, Выборка.Период, Ложь);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ТекстЗапроса_ДляОбновления(НомераТаблиц)
	
	НомераТаблиц.Вставить("втОрганизации", НомераТаблиц.Количество()); //возможные организации
	НомераТаблиц.Вставить("втСценарии", НомераТаблиц.Количество()); //возможные сценарии
	НомераТаблиц.Вставить("втШаблоныИстория", НомераТаблиц.Количество());//все возможные шаблоны
	НомераТаблиц.Вставить("втШаблоныВозможные", НомераТаблиц.Количество());//разные шаблоны
	
	НомераТаблиц.Вставить("втВозможныеУП", НомераТаблиц.Количество());//
	НомераТаблиц.Вставить("втНайденныеУП", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("втТребуемыеУстановкиУП", НомераТаблиц.Количество());
		
	НомераТаблиц.Вставить("СоздатьРС", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("СоздатьУП", НомераТаблиц.Количество());
	
	Возврат
	"ВЫБРАТЬ
	|	т.Ссылка КАК Организация,
	|	т.ФункциональнаяВалюта КАК ВалютаУчета,
	|	т.Удалить_МодельУчетаМСФО КАК МодельУчетаМСФО,
	|	т.Удалить_ПланСчетов КАК ПланСчетовИсточник,
	|	т.Удалить_ВалютаПредоставленияОтчетности КАК ВалютаУчетаДоп,
	|	т.Удалить_СпособТрансляции КАК СпособТрансляции,
	|	т.Удалить_ПорогПризнанияАренды КАК ПорогПризнанияАренды,
	|	т.Удалить_ПорогСущественностиВНА КАК ПорогСущественностиВНА,
	|	т.Удалить_ИсточникДляЧистойЦеныПродажиЗапасов КАК ИсточникДляЧистойЦеныПродажиЗапасов,
	|	т.Удалить_РежимТрансформационнойКорректировки КАК РежимТрансформационнойКорректировки
	|ПОМЕСТИТЬ втОрганизации
	|ИЗ
	|	Справочник.Организации КАК т
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	т.Сценарий КАК Сценарий
	|ПОМЕСТИТЬ втСценарии
	|ИЗ
	|	РегистрБухгалтерии.МСФО.Остатки(&Дата, , , ) КАК т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АВТОНОМЕРЗАПИСИ() КАК Номер,
	|	т.Период КАК Период,
	|	т.ПланСчетов КАК ПланСчетовИсточник,
	|	т.ШаблонТрансляцииПараллельныйУчет КАК ШаблонТрансляции,
	|	ЕСТЬNULL(втСценарии.Сценарий, т.Сценарий) КАК Сценарий
	|ПОМЕСТИТЬ втШаблоныИстория
	|ИЗ
	|	РегистрСведений.Удалить_ОсновныеШаблоныТрансляцииПлановСчетов КАК т
	|		ЛЕВОЕ СОЕДИНЕНИЕ втСценарии КАК втСценарии
	|		ПО (т.Сценарий = ЗНАЧЕНИЕ(Справочник.Сценарии.ПустаяСсылка))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	т.ПланСчетовИсточник КАК ПланСчетовИсточник,
	|	т.ШаблонТрансляции КАК ШаблонТрансляции,
	|	МИНИМУМ(т.Период) КАК ДатаМинимум
	|ПОМЕСТИТЬ втШаблоныВозможные
	|ИЗ
	|	втШаблоныИстория КАК т
	|
	|СГРУППИРОВАТЬ ПО
	|	т.ПланСчетовИсточник,
	|	т.ШаблонТрансляции
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	АВТОНОМЕРЗАПИСИ() КАК НомерСтарый,
	|	втШаблоныВозможные.ПланСчетовИсточник КАК ПланСчетовИсточник,
	|	втОрганизации.МодельУчетаМСФО КАК МодельУчетаМСФО,
	|	втОрганизации.ВалютаУчета КАК ВалютаУчета,
	|	втОрганизации.ПланСчетовИсточник КАК ПланСчетовИсточникОрганизации,
	|	втОрганизации.ВалютаУчетаДоп КАК ВалютаУчетаДоп,
	|	втОрганизации.СпособТрансляции КАК СпособТрансляции,
	|	втОрганизации.ПорогПризнанияАренды КАК ПорогПризнанияАренды,
	|	втОрганизации.ПорогСущественностиВНА КАК ПорогСущественностиВНА,
	|	втОрганизации.РежимТрансформационнойКорректировки КАК РежимТрансформационнойКорректировки,
	|	втОрганизации.ИсточникДляЧистойЦеныПродажиЗапасов КАК ИсточникДляЧистойЦеныПродажиЗапасов,
	|	втШаблоныВозможные.ДатаМинимум КАК Дата,
	|	втШаблоныВозможные.ШаблонТрансляции КАК ШаблонТрансляции
	|ПОМЕСТИТЬ втВозможныеУП
	|ИЗ
	|	втОрганизации КАК втОрганизации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втШаблоныВозможные КАК втШаблоныВозможные
	|		ПО (ИСТИНА)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(д.Ссылка, т.НомерСтарый) КАК УчетнаяПолитикаСоздать,
	|	т.Дата КАК Дата,
	|	т.НомерСтарый КАК НомерСтарый,
	|	т.МодельУчетаМСФО КАК МодельУчетаМСФО,
	|	т.ВалютаУчета КАК ВалютаУчета,
	|	т.ПланСчетовИсточник КАК ПланСчетовИсточник,
	|	т.ВалютаУчетаДоп КАК ВалютаУчетаДоп,
	|	т.СпособТрансляции КАК СпособТрансляции,
	|	т.ПорогПризнанияАренды КАК ПорогПризнанияАренды,
	|	т.ПорогСущественностиВНА КАК ПорогСущественностиВНА,
	|	т.РежимТрансформационнойКорректировки КАК РежимТрансформационнойКорректировки,
	|	т.ИсточникДляЧистойЦеныПродажиЗапасов КАК ИсточникДляЧистойЦеныПродажиЗапасов,
	|	д.Ссылка КАК УП,
	|	т.ШаблонТрансляции КАК ШаблонТрансляции
	|ПОМЕСТИТЬ втНайденныеУП
	|ИЗ
	|	втВозможныеУП КАК т
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УчетнаяПолитикаМСФО КАК д
	|		ПО т.ШаблонТрансляции = д.ШаблонТрансляции
	|			И т.ВалютаУчета = д.ВалютаУчета
	|			И т.ВалютаУчетаДоп = д.ВалютаУчетаДоп
	|			И т.СпособТрансляции = д.СпособТрансляции
	|			И т.ПорогПризнанияАренды = д.ПорогПризнанияАренды
	|			И т.ПорогСущественностиВНА = д.ПорогСущественностиВНА
	|			И т.РежимТрансформационнойКорректировки = д.РежимТрансформационнойКорректировки
	|			И т.ИсточникДляЧистойЦеныПродажиЗапасов = д.ИсточникДляЧистойЦеныПродажиЗапасов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втШаблоныИстория.Период КАК Период,
	|	втШаблоныИстория.Сценарий КАК Сценарий,
	|	втОрганизации.Организация КАК Организация,
	|	МАКСИМУМ(УчетныеПолитикиМСФО.УчетнаяПолитика) КАК УчетнаяПолитика,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втШаблоныИстория.ШаблонТрансляции) <= 1
	|			ТОГДА МАКСИМУМ(втШаблоныИстория.Номер)
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|					КОГДА втОрганизации.Организация.Удалить_ПланСчетов = втШаблоныИстория.ПланСчетовИсточник
	|						ТОГДА втШаблоныИстория.ШаблонТрансляции
	|				КОНЕЦ) = 1
	|			ТОГДА МАКСИМУМ(ВЫБОР
	|						КОГДА втОрганизации.Организация.Удалить_ПланСчетов = втШаблоныИстория.ПланСчетовИсточник
	|							ТОГДА втШаблоныИстория.Номер
	|					КОНЕЦ)
	|		КОГДА КОЛИЧЕСТВО(ВЫБОР
	|					КОГДА втШаблоныИстория.ПланСчетовИсточник.Наименование = ""Хозрасчетный""
	|						ТОГДА втШаблоныИстория.ШаблонТрансляции
	|				КОНЕЦ) > 0
	|			ТОГДА МАКСИМУМ(ВЫБОР
	|						КОГДА втШаблоныИстория.ПланСчетовИсточник.Наименование = ""Хозрасчетный""
	|							ТОГДА втШаблоныИстория.Номер
	|					КОНЕЦ)
	|		ИНАЧЕ МАКСИМУМ(втШаблоныИстория.Номер)
	|	КОНЕЦ КАК НомерПриДубляхИсточников
	|ПОМЕСТИТЬ втТребуемыеУстановкиУП
	|ИЗ
	|	втШаблоныИстория КАК втШаблоныИстория
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втОрганизации КАК втОрганизации
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетныеПолитикиМСФО КАК УчетныеПолитикиМСФО
	|		ПО втШаблоныИстория.Период = УчетныеПолитикиМСФО.Период
	|			И втШаблоныИстория.Сценарий = УчетныеПолитикиМСФО.Сценарий
	|			И (втОрганизации.Организация = УчетныеПолитикиМСФО.Организация)
	|ГДЕ
	|	УчетныеПолитикиМСФО.УчетнаяПолитика ЕСТЬ NULL
	|
	|СГРУППИРОВАТЬ ПО
	|	втОрганизации.Организация,
	|	втШаблоныИстория.Период,
	|	втШаблоныИстория.Сценарий
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	НомерПриДубляхИсточников
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втШаблоныИстория.Период КАК Период,
	|	втШаблоныИстория.Сценарий КАК Сценарий,
	|	втОрганизации.Организация КАК Организация,
	|	втНайденныеУП.УП КАК УП,
	|	втНайденныеУП.ПланСчетовИсточник КАК ПланСчетовИсточник,
	|	втНайденныеУП.ШаблонТрансляции КАК ШаблонТрансляции,
	|	втНайденныеУП.УчетнаяПолитикаСоздать КАК УчетнаяПолитикаСоздать,
	|	втНайденныеУП.НомерСтарый КАК НомерСтарый,
	|	втНайденныеУП.МодельУчетаМСФО КАК МодельУчетаМСФО,
	|	втНайденныеУП.ВалютаУчета КАК ВалютаУчета,
	|	втНайденныеУП.ВалютаУчетаДоп КАК ВалютаУчетаДоп,
	|	втНайденныеУП.СпособТрансляции КАК СпособТрансляции,
	|	втНайденныеУП.ПорогПризнанияАренды КАК ПорогПризнанияАренды,
	|	втНайденныеУП.ПорогСущественностиВНА КАК ПорогСущественностиВНА,
	|	втНайденныеУП.РежимТрансформационнойКорректировки КАК РежимТрансформационнойКорректировки
	|ИЗ
	|	втШаблоныИстория КАК втШаблоныИстория
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втТребуемыеУстановкиУП КАК втТребуемыеУстановкиУП
	|		ПО втШаблоныИстория.Номер = втТребуемыеУстановкиУП.НомерПриДубляхИсточников
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втНайденныеУП КАК втНайденныеУП
	|		ПО втШаблоныИстория.ПланСчетовИсточник = втНайденныеУП.ПланСчетовИсточник
	|			И втШаблоныИстория.ШаблонТрансляции = втНайденныеУП.ШаблонТрансляции
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втОрганизации КАК втОрганизации
	|		ПО (втНайденныеУП.МодельУчетаМСФО = втОрганизации.МодельУчетаМСФО)
	|			И (втНайденныеУП.ВалютаУчета = втОрганизации.ВалютаУчета)
	|			И (втНайденныеУП.ПланСчетовИсточник В (втНайденныеУП.ПланСчетовИсточник, втОрганизации.ПланСчетовИсточник))
	|			И (втНайденныеУП.ВалютаУчетаДоп = втОрганизации.ВалютаУчетаДоп)
	|			И (втНайденныеУП.СпособТрансляции = втОрганизации.СпособТрансляции)
	|			И (втНайденныеУП.ПорогПризнанияАренды = втОрганизации.ПорогПризнанияАренды)
	|			И (втНайденныеУП.ПорогСущественностиВНА = втОрганизации.ПорогСущественностиВНА)
	|			И (втНайденныеУП.РежимТрансформационнойКорректировки = втОрганизации.РежимТрансформационнойКорректировки)
	|			И (втТребуемыеУстановкиУП.Организация = втОрганизации.Организация)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	т.УчетнаяПолитикаСоздать КАК УчетнаяПолитикаСоздать,
	|	т.НомерСтарый КАК НомерСтарый,
	|	т.МодельУчетаМСФО КАК МодельУчетаМСФО,
	|	т.ВалютаУчета КАК ВалютаУчета,
	|	т.ПланСчетовИсточник КАК ПланСчетовИсточник,
	|	т.ВалютаУчетаДоп КАК ВалютаУчетаДоп,
	|	т.СпособТрансляции КАК СпособТрансляции,
	|	т.ПорогПризнанияАренды КАК ПорогПризнанияАренды,
	|	т.ПорогСущественностиВНА КАК ПорогСущественностиВНА,
	|	т.ШаблонТрансляции КАК ШаблонТрансляции,
	|	т.ШаблонТрансляции.ПланСчетовПриемник КАК ПланСчетовУчета,
	|	т.Дата КАК Дата,
	|	ВалютаРУ.Значение КАК ВалютаИсточник,
	|	т.ИсточникДляЧистойЦеныПродажиЗапасов КАК ИсточникДляЧистойЦеныПродажиЗапасов,
	|	т.РежимТрансформационнойКорректировки КАК РежимТрансформационнойКорректировки
	|ИЗ
	|	втНайденныеУП КАК т
	|		ЛЕВОЕ СОЕДИНЕНИЕ Константа.ВалютаРегламентированногоУчета КАК ВалютаРУ
	|		ПО (ИСТИНА)
	|ГДЕ
	|	т.УП ЕСТЬ NULL";

КонецФункции

#КонецОбласти

#КонецЕсли
