
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ПодготовкаПараметровПроведенияДокумента

Функция ПодготовитьПараметрыПроведения(ДополнительныеСвойства, Отказ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДополнительныеСвойства.ДляПроведения.Ссылка);
	
	Реквизиты = МСФОУХ.РеквизитыДокумента(Запрос, "ПериодОтчета, ДатаОкончания, ПериодОтчетаПредыдущий", "ПериодОтчета", Отказ);
	Реквизиты.Вставить("ГраницыПериода",			МСФОВНАВызовСервераУХ.ПолучитьГраницыПериодаДокумента(Реквизиты,,Истина));
	Реквизиты.Вставить("Период",					КонецДня(Реквизиты.ДатаОкончания));
	Реквизиты.Вставить("ФормироватьПроводкиМСФО",	Ложь);
	ДополнительныеСвойства.ДляПроведения.Вставить("Реквизиты", Реквизиты);
	
	Если Отказ Тогда
		Возврат ДополнительныеСвойства;
	КонецЕсли;
	
	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаТаблицаДляПроводок(НомераТаблиц);
	ПроведениеСерверУХ.ДополнитьТаблицамиИзПакетаЗапросов(ДополнительныеСвойства.ТаблицыДляДвижений, Запрос, НомераТаблиц);
	
КонецФункции

Функция ТекстЗапросаТаблицаДляПроводок(НомераТаблиц)
	
	НомераТаблиц.Вставить("втРасчетныеДанные", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("втВидыДвижений", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ТаблицаПроводки", НомераТаблиц.Количество());
	
	Возврат
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ПроводкиТК.СчетПовтораДт = ЗНАЧЕНИЕ(Справочник.СчетаБД.ПустаяСсылка)
	|			ТОГДА ПроводкиТК.СчетДт
	|		ИНАЧЕ ПроводкиТК.СчетПовтораДт
	|	КОНЕЦ КАК СчетДт,
	|	ВЫБОР
	|		КОГДА ПроводкиТК.СчетПовтораДт = ЗНАЧЕНИЕ(Справочник.СчетаБД.ПустаяСсылка)
	|			ТОГДА ПроводкиТК.СубконтоДт1
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК СубконтоДт1,
	|	ВЫБОР
	|		КОГДА ПроводкиТК.СчетПовтораДт = ЗНАЧЕНИЕ(Справочник.СчетаБД.ПустаяСсылка)
	|			ТОГДА ПроводкиТК.СубконтоДт2
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК СубконтоДт2,
	|	ВЫБОР
	|		КОГДА ПроводкиТК.СчетПовтораДт = ЗНАЧЕНИЕ(Справочник.СчетаБД.ПустаяСсылка)
	|			ТОГДА ПроводкиТК.СубконтоДт3
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК СубконтоДт3,
	|	ВЫБОР
	|		КОГДА ПроводкиТК.СчетПовтораКт = ЗНАЧЕНИЕ(Справочник.СчетаБД.ПустаяСсылка)
	|			ТОГДА ПроводкиТК.СчетКт
	|		ИНАЧЕ ПроводкиТК.СчетПовтораКт
	|	КОНЕЦ КАК СчетКт,
	|	ВЫБОР
	|		КОГДА ПроводкиТК.СчетПовтораКт = ЗНАЧЕНИЕ(Справочник.СчетаБД.ПустаяСсылка)
	|			ТОГДА ПроводкиТК.СубконтоКт1
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК СубконтоКт1,
	|	ВЫБОР
	|		КОГДА ПроводкиТК.СчетПовтораКт = ЗНАЧЕНИЕ(Справочник.СчетаБД.ПустаяСсылка)
	|			ТОГДА ПроводкиТК.СубконтоКт2
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК СубконтоКт2,
	|	ВЫБОР
	|		КОГДА ПроводкиТК.СчетПовтораКт = ЗНАЧЕНИЕ(Справочник.СчетаБД.ПустаяСсылка)
	|			ТОГДА ПроводкиТК.СубконтоКт3
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК СубконтоКт3,
	|	ПроводкиТК.Значение,
	|	""Повтор проводки: "" + (ВЫРАЗИТЬ(ПроводкиТК.Комментарий КАК СТРОКА(300))) КАК Комментарий,
	|	ПроводкиТК.НомерПроводки,
	|	ПроводкиТК.ШаблонПроводки,
	|	ПроводкиТК.РесурсРегистра,
	|	ПроводкиТК.ВалютаДт,
	|	ПроводкиТК.ВалютаКт,
	|	ПроводкиТК.КурсВалютыДт,
	|	ПроводкиТК.КурсВалютыКт,
	|	ПроводкиТК.ЗначениеВалютаКт,
	|	ПроводкиТК.ЗначениеВалютаДт,
	|	ПроводкиТК.КоличествоДт,
	|	ПроводкиТК.КоличествоКт,
	|	ПроводкиТК.Корректировка,
	|	ВЫБОР
	|		КОГДА ПроводкиТК.Корректировка.ДействиеВСледующемПериоде = ЗНАЧЕНИЕ(Перечисление.ДействияКорректировкиВСледующемПериоде.ПустаяСсылка)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДействияКорректировкиВСледующемПериоде.СтандартныйАлгоритмПовтора)
	|		ИНАЧЕ ПроводкиТК.Корректировка.ДействиеВСледующемПериоде
	|	КОНЕЦ КАК ДействиеВСледующемПериоде
	|ПОМЕСТИТЬ втРасчетныеДанные
	|ИЗ
	|	Документ.ПовторениеКорректировокПрошлыхПериодов.ПроводкиПовтора КАК ПроводкиТК
	|ГДЕ
	|	ПроводкиТК.Ссылка = &Ссылка
	|	И НЕ ПроводкиТК.ИсключитьИзПовтора
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(т.ВидДвижения) КАК ВидДвижения,
	|	т.СчетДт КАК СчетДт,
	|	т.СчетКт КАК СчетКт
	|ПОМЕСТИТЬ втВидыДвижений
	|ИЗ
	|	РегистрСведений.КорреспонденцииВидовДвиженийМСФО КАК т
	|ГДЕ
	|	(т.СчетДт, т.СчетКт) В
	|			(ВЫБРАТЬ
	|				т.СчетДт,
	|				т.СчетКт
	|			ИЗ
	|				втРасчетныеДанные КАК т)
	|
	|СГРУППИРОВАТЬ ПО
	|	т.СчетДт,
	|	т.СчетКт
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетДт,
	|	СчетКт
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втРасчетныеДанные.СчетДт,
	|	втРасчетныеДанные.СубконтоДт1,
	|	втРасчетныеДанные.СубконтоДт2,
	|	втРасчетныеДанные.СубконтоДт3,
	|	втРасчетныеДанные.СчетКт,
	|	втРасчетныеДанные.СубконтоКт1,
	|	втРасчетныеДанные.СубконтоКт2,
	|	втРасчетныеДанные.СубконтоКт3,
	|	втРасчетныеДанные.Значение,
	|	втРасчетныеДанные.Комментарий,
	|	втРасчетныеДанные.НомерПроводки,
	|	втРасчетныеДанные.ШаблонПроводки,
	|	втРасчетныеДанные.РесурсРегистра,
	|	втРасчетныеДанные.ВалютаДт,
	|	втРасчетныеДанные.ВалютаКт,
	|	втРасчетныеДанные.КурсВалютыДт,
	|	втРасчетныеДанные.КурсВалютыКт,
	|	втРасчетныеДанные.ЗначениеВалютаКт,
	|	втРасчетныеДанные.ЗначениеВалютаДт,
	|	втРасчетныеДанные.КоличествоДт,
	|	втРасчетныеДанные.КоличествоКт,
	|	ЕСТЬNULL(втВидыДвижений.ВидДвижения, ЗНАЧЕНИЕ(Справочник.ВидыДвиженийМСФО.ПрочиеОперации)) КАК ВидДвижения,
	|	втРасчетныеДанные.Корректировка,
	|	втРасчетныеДанные.ДействиеВСледующемПериоде
	|ИЗ
	|	втРасчетныеДанные КАК втРасчетныеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ втВидыДвижений КАК втВидыДвижений
	|		ПО втРасчетныеДанные.СчетДт = втВидыДвижений.СчетДт
	|			И втРасчетныеДанные.СчетКт = втВидыДвижений.СчетКт";

КонецФункции

Процедура СформироватьКорректировки(ДополнительныеСвойства, Отказ) Экспорт
	
	ТаблицаПроводки = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаПроводки;
	Реквизиты 		= ДополнительныеСвойства.ДляПроведения.Реквизиты;
	
	ТаблицаПроводки.Индексы.Добавить("ДействиеВСледующемПериоде");
	КонтекстКорректировки = Новый Структура;
	КонтекстКорректировки.Вставить("ДействиеВСледующемПериоде", Перечисления.ДействияКорректировкиВСледующемПериоде.Повторять);
	КонтекстКорректировки.Вставить("ШаблонКорректировки", Справочники.ШаблоныТрансформационныхКорректировок.ПустаяСсылка());
	КонтекстКорректировки.Вставить("ПериодОтчета", Реквизиты.ПериодОтчета);
	
	//стандартный алгоритм повтора
	ОтборПроводок = Новый Структура("ДействиеВСледующемПериоде", Перечисления.ДействияКорректировкиВСледующемПериоде.СтандартныйАлгоритмПовтора);
	РеквизитыКорректировки = Новый Структура("ДействиеВСледующемПериоде", Перечисления.ДействияКорректировкиВСледующемПериоде.СтандартныйАлгоритмПовтора);
	Реквизиты.Вставить("ВидОперации", Справочники.ВидыОпераций.ПовторКорректировокПредыдущихПериодов);
	Реквизиты.Вставить("РеквизитыКорректировки", РеквизитыКорректировки);
	
	ТрансформационныеКорректировкиУХ.СформироватьКорректировку(Реквизиты, Отказ, ТаблицаПроводки.Скопировать(ОтборПроводок));

	//действие в следующем периоде - повтор
	ОтборПроводок = Новый Структура("ДействиеВСледующемПериоде", Перечисления.ДействияКорректировкиВСледующемПериоде.Повторять);	
	Реквизиты.Вставить("ВидОперации", Справочники.ВидыОпераций.ПовторКорректировокДействиеПовтора);
	РеквизитыКорректировки = Новый Структура("ДействиеВСледующемПериоде", Перечисления.ДействияКорректировкиВСледующемПериоде.Повторять);
	Реквизиты.Вставить("РеквизитыКорректировки", РеквизитыКорректировки);
	
	ТрансформационныеКорректировкиУХ.СформироватьКорректировку(Реквизиты, Отказ, ТаблицаПроводки.Скопировать(ОтборПроводок));

	//действие в следующем периоде - сторно
	ОтборПроводок = Новый Структура("ДействиеВСледующемПериоде", Перечисления.ДействияКорректировкиВСледующемПериоде.Сторнировать);
	РеквизитыКорректировки = Новый Структура("ДействиеВСледующемПериоде", Перечисления.ДействияКорректировкиВСледующемПериоде.СтандартныйАлгоритмПовтора);
	Реквизиты.Вставить("ВидОперации", Справочники.ВидыОпераций.СторноКорректировокОтчетности);
	Реквизиты.Вставить("РеквизитыКорректировки", РеквизитыКорректировки);
	
	ТрансформационныеКорректировкиУХ.СформироватьКорректировку(Реквизиты, Отказ, ТаблицаПроводки.Скопировать(ОтборПроводок));
	
КонецПроцедуры

#КонецОбласти

#Область Заполнение

Функция ПолучитьТаблицуПроводок(КонтекстДокумента) Экспорт

	Запрос = Новый Запрос(ПолучитьТекстЗапроса());
	
	ПериодОтчетаПредыдущий = ОбщегоНазначенияУХ.глОтносительныйПериод(КонтекстДокумента.ПериодОтчета, -1);
	
	РазделыБаланс = Новый Массив;
	РазделыБаланс.Добавить(Справочники.РазделыПланаСчетов.Капитал);
	РазделыБаланс.Добавить(Справочники.РазделыПланаСчетов.Взаиморасчеты);
	РазделыБаланс.Добавить(Справочники.РазделыПланаСчетов.ВнеоборотныеАктивы);
	РазделыБаланс.Добавить(Справочники.РазделыПланаСчетов.ДенежныеСредства);
	РазделыБаланс.Добавить(Справочники.РазделыПланаСчетов.Запасы);
	РазделыБаланс.Добавить(Справочники.РазделыПланаСчетов.ПрочиеАктивыОбязательства);
	РазделыБаланс.Добавить(Справочники.РазделыПланаСчетов.НезавершенныеОперации);
	
	РазделыФинРезультат	= Новый Массив;
	РазделыФинРезультат.Добавить(Справочники.РазделыПланаСчетов.Выручка);
	РазделыФинРезультат.Добавить(Справочники.РазделыПланаСчетов.Себестоимость);
	РазделыФинРезультат.Добавить(Справочники.РазделыПланаСчетов.КоммерческиеАдминистративныеРасходы);
	РазделыФинРезультат.Добавить(Справочники.РазделыПланаСчетов.Закрытие);
	РазделыФинРезультат.Добавить(Справочники.РазделыПланаСчетов.ВнереализационныеДоходыИРасходы);
	
	Запрос.УстановитьПараметр("ПериодОтчета", 			КонтекстДокумента.ПериодОтчета);
	Запрос.УстановитьПараметр("ПериодОтчетаПредыдущий",	КонтекстДокумента.ПериодОтчетаПредыдущий);
	Запрос.УстановитьПараметр("Сценарий", 				КонтекстДокумента.Сценарий);
	Запрос.УстановитьПараметр("Организация", 			КонтекстДокумента.Организация);
	Запрос.УстановитьПараметр("РазделыБаланс", 			РазделыБаланс);
	Запрос.УстановитьПараметр("РазделыФинРезультат", 	РазделыФинРезультат);
	Запрос.УстановитьПараметр("ДокументСсылка", 		КонтекстДокумента.Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

Функция ПолучитьТекстЗапроса()

	Возврат
	"ВЫБРАТЬ
	|	ТрансформационнаяКорректировка.Ссылка КАК Ссылка,
	|	ТрансформационнаяКорректировка.ДействиеВСледующемПериоде КАК ДействиеВСледующемПериоде
	|ПОМЕСТИТЬ втТК
	|ИЗ
	|	Документ.ТрансформационнаяКорректировка КАК ТрансформационнаяКорректировка
	|ГДЕ
	|	ТрансформационнаяКорректировка.ПериодОтчета = &ПериодОтчетаПредыдущий
	|	И ТрансформационнаяКорректировка.Сценарий = &Сценарий
	|	И ТрансформационнаяКорректировка.Организация = &Организация
	|	И ТрансформационнаяКорректировка.Проведен
	|	И ТрансформационнаяКорректировка.КорректировкиЗначенийПоказателей
	|	И ТрансформационнаяКорректировка.ИсходныйДокумент <> &ДокументСсылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаменаСчетов.СчетДт КАК СчетДт,
	|	ЗаменаСчетов.СчетКт КАК СчетКт,
	|	ЗаменаСчетов.СчетЗаменыДт КАК СчетЗаменыДт,
	|	ЗаменаСчетов.СчетЗаменыКт КАК СчетЗаменыКт
	|ПОМЕСТИТЬ втСчетаПовтора
	|ИЗ
	|	Справочник.НастройкиПовторенияПроводокПрошлыхПериодов.ЗаменаСчетов КАК ЗаменаСчетов
	|ГДЕ
	|	ЗаменаСчетов.Ссылка.Организация = &Организация
	|	И НЕ ЗаменаСчетов.Ссылка.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втТК.Ссылка КАК Корректировка,
	|	ПроводкиТК.НомерПроводки КАК НомерПроводки,
	|	ПроводкиТК.СчетДт КАК СчетДт,
	|	ПроводкиТК.СубконтоДт1 КАК СубконтоДт1,
	|	ПроводкиТК.СубконтоДт2 КАК СубконтоДт2,
	|	ПроводкиТК.СубконтоДт3 КАК СубконтоДт3,
	|	ВЫБОР
	|		КОГДА втТК.ДействиеВСледующемПериоде = ЗНАЧЕНИЕ(Перечисление.ДействияКорректировкиВСледующемПериоде.Повторять)
	|			ТОГДА ПроводкиТК.Значение
	|		ИНАЧЕ -ПроводкиТК.Значение
	|	КОНЕЦ КАК Значение,
	|	ПроводкиТК.СчетКт КАК СчетКт,
	|	ПроводкиТК.СубконтоКт1 КАК СубконтоКт1,
	|	ПроводкиТК.СубконтоКт2 КАК СубконтоКт2,
	|	ПроводкиТК.СубконтоКт3 КАК СубконтоКт3,
	|	ПроводкиТК.Комментарий КАК Комментарий,
	|	ПроводкиТК.ШаблонПроводки КАК ШаблонПроводки,
	|	ПроводкиТК.РесурсРегистра КАК РесурсРегистра,
	|	ПроводкиТК.ВалютаДт КАК ВалютаДт,
	|	ПроводкиТК.ВалютаКт КАК ВалютаКт,
	|	ПроводкиТК.КурсВалютыДт КАК КурсВалютыДт,
	|	ПроводкиТК.КурсВалютыКт КАК КурсВалютыКт,
	|	ВЫБОР
	|		КОГДА втТК.ДействиеВСледующемПериоде = ЗНАЧЕНИЕ(Перечисление.ДействияКорректировкиВСледующемПериоде.Повторять)
	|			ТОГДА ПроводкиТК.ЗначениеВалютаКт
	|		ИНАЧЕ -ПроводкиТК.ЗначениеВалютаКт
	|	КОНЕЦ КАК ЗначениеВалютаКт,
	|	ВЫБОР
	|		КОГДА втТК.ДействиеВСледующемПериоде = ЗНАЧЕНИЕ(Перечисление.ДействияКорректировкиВСледующемПериоде.Повторять)
	|			ТОГДА ПроводкиТК.ЗначениеВалютаДт
	|		ИНАЧЕ -ПроводкиТК.ЗначениеВалютаДт
	|	КОНЕЦ КАК ЗначениеВалютаДт,
	|	ПроводкиТК.Повтор КАК Повтор,
	|	ПроводкиТК.Маркер КАК Маркер,
	|	ПроводкиТК.КоличествоДт КАК КоличествоДт,
	|	ПроводкиТК.КоличествоКт КАК КоличествоКт,
	|	ПроводкиТК.ВидДвижения КАК ВидДвижения,
	|	ЕСТЬNULL(втСчетаПовтора.СчетЗаменыДт, ВЫБОР
	|			КОГДА ПроводкиТК.СчетДт.РазделПланаСчетов В (&РазделыФинРезультат)
	|				ТОГДА (ЗНАЧЕНИЕ(Справочник.ФиксированныеСчетаУчетаБД.НераспределеннаяПрибыльНепокрытыйУбытокПредыдущихПериодов)).Счет
	|			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СчетаБД.ПустаяСсылка)
	|		КОНЕЦ) КАК СчетПовтораДт,
	|	ЕСТЬNULL(втСчетаПовтора.СчетЗаменыКт, ВЫБОР
	|			КОГДА ПроводкиТК.СчетКт.РазделПланаСчетов В (&РазделыФинРезультат)
	|				ТОГДА (ЗНАЧЕНИЕ(Справочник.ФиксированныеСчетаУчетаБД.НераспределеннаяПрибыльНепокрытыйУбытокПредыдущихПериодов)).Счет
	|			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СчетаБД.ПустаяСсылка)
	|		КОНЕЦ) КАК СчетПовтораКт
	|ИЗ
	|	втТК КАК втТК
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ТрансформационнаяКорректировка.Проводки КАК ПроводкиТК
	|			ЛЕВОЕ СОЕДИНЕНИЕ втСчетаПовтора КАК втСчетаПовтора
	|			ПО ПроводкиТК.СчетДт = втСчетаПовтора.СчетДт
	|				И ПроводкиТК.СчетКт = втСчетаПовтора.СчетКт
	|		ПО втТК.Ссылка = ПроводкиТК.Ссылка
	|			И (ВЫБОР
	|				КОГДА ПроводкиТК.СчетДт.РазделПланаСчетов В (&РазделыБаланс)
	|						И ПроводкиТК.СчетКт.РазделПланаСчетов В (&РазделыФинРезультат)
	|					ТОГДА ИСТИНА
	|				КОГДА ПроводкиТК.СчетКт.РазделПланаСчетов В (&РазделыБаланс)
	|						И ПроводкиТК.СчетДт.РазделПланаСчетов В (&РазделыФинРезультат)
	|					ТОГДА ИСТИНА
	|				КОГДА (ПроводкиТК.СчетДт, ПроводкиТК.СчетКт) В
	|						(ВЫБРАТЬ
	|							т.СчетДт,
	|							т.СчетКт
	|						ИЗ
	|							втСчетаПовтора КАК т)
	|					ТОГДА ИСТИНА
	|			КОНЕЦ)";

КонецФункции

#КонецОбласти

#КонецЕсли