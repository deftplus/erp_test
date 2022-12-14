#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Команды

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	//++ НЕ УТКА
	МеханизмыДокумента.Добавить("МеждународныйУчет");
	//-- НЕ УТКА
	МеханизмыДокумента.Добавить("НематериальныеАктивы");
	МеханизмыДокумента.Добавить("РеестрДокументов");
	МеханизмыДокумента.Добавить("УчетПрочихАктивовПассивов");
	
	ПереоценкаНМАЛокализация.ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента);
	
КонецПроцедуры

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  Структура:
//     * Ключ - Строка - Имя таблицы.
//     * Значение - ТаблицаЗначений - таблица данных для отражения в регистр.
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда

		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		ЗаполнитьПараметрыИнициализации(Запрос, Документ);
	
		ТекстыЗапроса = Новый СписокЗначений;
		ТекстЗапросаТаблицаДокументыПоНМА(ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры);
		
		//++ НЕ УТКА
		ТекстЗапросаТаблицаОтражениеДокументовВМеждународномУчете(ТекстыЗапроса, Регистры);
		//-- НЕ УТКА
		
		ПереоценкаНМАЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	
	КонецЕсли;
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

#КонецОбласти

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Команда = ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если Команда <> Неопределено Тогда
		Команда.ВидимостьВФормах = "ФормаСписка";
	КонецЕсли;
	
	ПереоценкаНМАЛокализация.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры);

КонецПроцедуры

// Добавляет команду создания документа "Переоценка НМА".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//	СтрокаТаблицыЗначений - добавленная команда
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.ПереоценкаНМА2_4) Тогда
		
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ПереоценкаНМА2_4.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ПереоценкаНМА2_4);
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьВнеоборотныеАктивы2_4";
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
	ПереоценкаНМАЛокализация.ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);

КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

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

#Область СлужебныйПрограммныйИнтерфейс

// Формирует таблицы движений при отложенном проведении.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ПереоценкаНМА2_4 - Документ, для которого формируются движения
//  МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - Содержит вспомогательные временные таблицы, которые могут использоваться для формирования движений.
//
// Возвращаемое значение:
//  см. ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения
//
Функция ТаблицыОтложенногоФормированияДвижений(ДокументСсылка, МенеджерВременныхТаблиц) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	ВнеоборотныеАктивыСлужебный.ТекстыЗапросаПриПереоценке(ТекстыЗапроса, "НМА");
	ТекстЗапросаТаблицаПервоначальныеСведенияНМА(ТекстыЗапроса);
	
	ТаблицыДляДвижений = ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(
							Запрос, ТекстыЗапроса, Неопределено);
	
	Возврат ТаблицыДляДвижений;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт

	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.ПереоценкаНМА2_4";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	
	ВЗапросеЕстьИсточник = Истина;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "";
		ВЗапросеЕстьИсточник = Ложь;
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.';
								|en = 'In document %ПолноеИмяДокумента%, adaptation of request for generating records of register %ИмяРегистра% is not implemented.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ВЗапросеЕстьИсточник,
										ПереопределениеРасчетаПараметров);
	Иначе	
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ПереопределениеРасчетаПараметров);
	КонецЕсли; 

	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка                 КАК Ссылка,
	|	ДанныеДокумента.Дата                   КАК Период,
	|	ДанныеДокумента.Номер                  КАК Номер,
	|	ДанныеДокумента.Проведен               КАК Проведен,
	|	ДанныеДокумента.ПометкаУдаления        КАК ПометкаУдаления,
	|	ДанныеДокумента.ОтражатьВРеглУчете     КАК ОтражатьВРеглУчете,
	|	ДанныеДокумента.ОтражатьВУпрУчете      КАК ОтражатьВУпрУчете,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПереоценкаНМА) КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.Организация            КАК Организация,
	|	ДанныеДокумента.Организация.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ДанныеДокумента.Подразделение          КАК Подразделение,
	|	ДанныеДокумента.СтатьяДоходов          КАК СтатьяДоходов,
	|	ДанныеДокумента.АналитикаДоходов       КАК АналитикаДоходов,
	|	ДанныеДокумента.СтатьяРасходов         КАК СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов      КАК АналитикаРасходов,
	|	ЕСТЬNULL(ДанныеДокумента.СтатьяРасходов.ПринятиеКналоговомуУчету, ЛОЖЬ) КАК ПринятиеКНалоговомуУчету,
	|	ДанныеДокумента.Ответственный          КАК Ответственный,
	|	ДанныеДокумента.Комментарий            КАК Комментарий
	|ИЗ
	|	Документ.ПереоценкаНМА2_4 КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("КонецДня", Новый Граница(КонецДня(Реквизиты.Период),ВидГраницы.Включая));
	
	ЗначенияПараметровПроведения = ЗначенияПараметровПроведения(Реквизиты);
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла; 
	
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)

	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ПереоценкаНМА2_4"));
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПереоценкаНМА);
	ЗначенияПараметровПроведения.Вставить("НазваниеДокумента", НСтр("ru = 'Переоценка НМА';
																	|en = 'Revaluate intangible assets'"));
	ЗначенияПараметровПроведения.Вставить("ВедетсяРегламентированныйУчетВНА", ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА());

	ЗначенияПараметровПроведения.Вставить("ХО_УвеличениеНакопленнойАмортизации", Перечисления.ХозяйственныеОперации.УвеличениеНакопленнойАмортизацииНМА);
	ЗначенияПараметровПроведения.Вставить("НастройкаХО_УвеличениеНакопленнойАмортизации", Справочники.НастройкиХозяйственныхОпераций.УвеличениеНакопленнойАмортизацииНМА);

	ЗначенияПараметровПроведения.Вставить("ХО_УменьшениеНакопленнойАмортизации", Перечисления.ХозяйственныеОперации.УменьшениеНакопленнойАмортизацииНМА);
	ЗначенияПараметровПроведения.Вставить("НастройкаХО_УменьшениеНакопленнойАмортизации", Справочники.НастройкиХозяйственныхОпераций.УменьшениеНакопленнойАмортизацииНМА);
	
	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли; 
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Функция ТекстЗапросаТаблицаДокументыПоНМА(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДокументыПоНМА";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ТаблицаНМА.НомерСтроки-1, 0) КАК НомерЗаписи,
	|	&Ссылка                          КАК Ссылка,
	|	ТаблицаНМА.НематериальныйАктив   КАК НематериальныйАктив,
	|	&ХозяйственнаяОперация           КАК ХозяйственнаяОперация,
	|	&Организация                     КАК Организация,
	|	&Подразделение                   КАК Подразделение,
	|	&Период                          КАК Дата,
	|	&ИдентификаторМетаданных         КАК ТипСсылки,
	|	&Проведен                        КАК Проведен,
	|	&ОтражатьВУпрУчете               КАК ОтражатьВУпрУчете,
	|	&ОтражатьВРеглУчете              КАК ОтражатьВРеглУчете
	|ИЗ
	|	Документ.ПереоценкаНМА2_4 КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			Документ.ПереоценкаНМА2_4.НМА КАК ТаблицаНМА
	|		ПО
	|			ТаблицаНМА.Ссылка = ДанныеДокумента.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Ссылка                        КАК Ссылка,
	|	&Период                        КАК ДатаДокументаИБ,
	|	&Номер                         КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных       КАК ТипСсылки,
	|	&Организация                   КАК Организация,
	|	&ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО                   КАК НаправлениеДеятельности,
	|	&Подразделение                 КАК Подразделение,
	|	&Ответственный                 КАК Ответственный,
	|	&Комментарий                   КАК Комментарий,
	|	&Проведен                      КАК Проведен,
	|	&ПометкаУдаления               КАК ПометкаУдаления,
	|	ЛОЖЬ                           КАК ДополнительнаяЗапись,
	|	&Период                        КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать                 КАК НомерПервичногоДокумента,
	|	ЛОЖЬ                           КАК СторноИсправление,
	|	НЕОПРЕДЕЛЕНО                   КАК СторнируемыйДокумент,
	|	НЕОПРЕДЕЛЕНО                   КАК ИсправляемыйДокумент,
	|	&Период                        КАК ДатаОтраженияВУчете,
	|	НЕОПРЕДЕЛЕНО                   КАК Приоритет
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ТекстЗапросаТаблицаПервоначальныеСведенияНМА(ТекстыЗапроса)

	ИмяРегистра = "ПервоначальныеСведенияНМА";
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаТаблицаВтТаблицаНМА(ТекстыЗапроса, "Документ.ПереоценкаНМА2_4");
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Ссылка                                                     КАК Регистратор,
	|	&Период                                                     КАК Период,
	|	&Организация                                                КАК Организация,
	|	ПервоначальныеСведения.НематериальныйАктив                  КАК НематериальныйАктив,
	|	ПервоначальныеСведения.СпособПоступления                    КАК СпособПоступления,
	|
	// ПервоначальнаяСтоимостьУУ
	|	ВЫБОР
	|		КОГДА УчетнаяПолитикаФинансовогоУчета.ПорядокУчетаВНА = ЗНАЧЕНИЕ(Перечисление.ПорядокУчетаВНА.ПоСтандартамРегл)
	|			ТОГДА ПервоначальныеСведения.ПервоначальнаяСтоимостьУУ 
	|					 + ВЫБОР 
	|							КОГДА ТаблицаПереоценки.СуммаДооценкиСтоимостиУУ > 0
	|								ТОГДА ТаблицаПереоценки.СуммаДооценкиСтоимостиУУ 
	|							ИНАЧЕ 0 
	|						КОНЕЦ 
	|					- ВЫБОР 
	|							КОГДА ТаблицаПереоценки.СуммаУценкиСтоимостиУУ > 0
	|								ТОГДА ТаблицаПереоценки.СуммаУценкиСтоимостиУУ 
	|							ИНАЧЕ 0 
	|						КОНЕЦ
	|		ИНАЧЕ ПервоначальныеСведения.ПервоначальнаяСтоимостьУУ
	|	КОНЕЦ КАК ПервоначальнаяСтоимостьУУ,
	|
	// ПервоначальнаяСтоимостьБУ
	|	ПервоначальныеСведения.ПервоначальнаяСтоимостьБУ 
	|		 + ВЫБОР 
	|				КОГДА ТаблицаПереоценки.СуммаДооценкиСтоимостиБУ > 0
	|					ТОГДА ТаблицаПереоценки.СуммаДооценкиСтоимостиБУ 
	|				ИНАЧЕ 0 
	|			КОНЕЦ 
	|		- ВЫБОР 
	|				КОГДА ТаблицаПереоценки.СуммаУценкиСтоимостиБУ > 0
	|					ТОГДА ТаблицаПереоценки.СуммаУценкиСтоимостиБУ 
	|				ИНАЧЕ 0 
	|			КОНЕЦ                                               КАК ПервоначальнаяСтоимостьБУ,
	|
	|	ПервоначальныеСведения.ПервоначальнаяСтоимостьНУ            КАК ПервоначальнаяСтоимостьНУ,
	|	ПервоначальныеСведения.ПервоначальнаяСтоимостьПР            КАК ПервоначальнаяСтоимостьПР,
	|	ПервоначальныеСведения.ПервоначальнаяСтоимостьВР            КАК ПервоначальнаяСтоимостьВР,
	|	ПервоначальныеСведения.МетодНачисленияАмортизацииБУ         КАК МетодНачисленияАмортизацииБУ,
	|	ПервоначальныеСведения.МетодНачисленияАмортизацииНУ         КАК МетодНачисленияАмортизацииНУ,
	|	ПервоначальныеСведения.Коэффициент                          КАК Коэффициент,
	|	ПервоначальныеСведения.АмортизацияДо2002                    КАК АмортизацияДо2002,
	|	ПервоначальныеСведения.АмортизацияДо2009                    КАК АмортизацияДо2009,
	|	ПервоначальныеСведения.СтоимостьДо2002                      КАК СтоимостьДо2002,
	|	ПервоначальныеСведения.ФактическийСрокИспользованияДо2009   КАК ФактическийСрокИспользованияДо2009,
	|	ПервоначальныеСведения.ДатаПриобретения                     КАК ДатаПриобретения,
	|	ПервоначальныеСведения.ДатаПринятияКУчетуУУ                 КАК ДатаПринятияКУчетуУУ,
	|	ПервоначальныеСведения.ДатаПринятияКУчетуБУ                 КАК ДатаПринятияКУчетуБУ,
	|	ПервоначальныеСведения.ДокументПринятияКУчетуУУ             КАК ДокументПринятияКУчетуУУ,
	|	ПервоначальныеСведения.ДокументПринятияКУчетуБУ             КАК ДокументПринятияКУчетуБУ,
	|	ПервоначальныеСведения.ПорядокУчетаНУ                       КАК ПорядокУчетаНУ,
	|	ПервоначальныеСведения.ДокументСписания                     КАК ДокументСписания
	|ИЗ
	|	ТаблицаПереоценки КАК ТаблицаПереоценки
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|			И Регистратор <> &Ссылка
	|			И НематериальныйАктив В
	|					(ВЫБРАТЬ
	|						СписокНМА.НематериальныйАктив
	|					ИЗ
	|						втСписокНМА КАК СписокНМА)
	|		) КАК ПервоначальныеСведения
	|		ПО ТаблицаПереоценки.НематериальныйАктив = ПервоначальныеСведения.НематериальныйАктив
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаФинансовогоУчета.СрезПоследних(&Период, Организация = &ГоловнаяОрганизация) КАК УчетнаяПолитикаФинансовогоУчета
	|		ПО УчетнаяПолитикаФинансовогоУчета.Организация = &ГоловнаяОрганизация
	|ГДЕ
	|	НЕ ПервоначальныеСведения.НематериальныйАктив ЕСТЬ NULL";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

//++ НЕ УТКА

Функция ТекстЗапросаТаблицаОтражениеДокументовВМеждународномУчете(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОтражениеДокументовВМеждународномУчете";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Период                        КАК Период,
	|	&Организация                   КАК Организация,
	|	НАЧАЛОПЕРИОДА(&Период, ДЕНЬ)   КАК ДатаОтражения,
	|	&ХозяйственнаяОперация         КАК ХозяйственнаяОперация";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

//-- НЕ УТКА

#КонецОбласти

#Область ПроведениеПоРеглУчету

Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт

	Возврат ПереоценкаНМАЛокализация.ТекстЗапросаВТОтраженияВРеглУчете();

КонецФункции

Функция ТекстОтраженияВРеглУчете() Экспорт

	Возврат ПереоценкаНМАЛокализация.ТекстОтраженияВРеглУчете();

КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	ПереоценкаНМАЛокализация.ДобавитьКомандыПечати(КомандыПечати);

КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ПараметрыВыбораСтатейИАналитик() Экспорт
	
	ПараметрыВыбораСтатьиИАналитики = Новый Массив;
	
	// СтатьяРасходов
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "Объект";
	ПараметрыВыбора.Статья = "СтатьяРасходов";
	ПараметрыВыбора.ДоступностьПоОперации = Неопределено;
	
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаРасходов";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("СтатьяРасходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("АналитикаРасходов");
	
	ПараметрыВыбораСтатьиИАналитики.Добавить(ПараметрыВыбора);
	
	// СтатьяДоходов
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "Объект";
	ПараметрыВыбора.Статья = "СтатьяДоходов";
	ПараметрыВыбора.ДоступностьПоОперации = Неопределено;
	
	ПараметрыВыбора.ВыборСтатьиДоходов = Истина;
	ПараметрыВыбора.АналитикаДоходов = "АналитикаДоходов";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("СтатьяДоходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаДоходов.Добавить("АналитикаДоходов");
	
	ПараметрыВыбораСтатьиИАналитики.Добавить(ПараметрыВыбора);
	
	Возврат ПараметрыВыбораСтатьиИАналитики;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Документы.ПереоценкаНМА2_4.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.5.1";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("72e42bec-e4e9-496f-a22a-486ceb2c8172");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Документы.ПереоценкаНМА2_4.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновляет документы ""Переоценка НМА"":
								  |- Заполняет реквизит поле ""Идентификатор строки"" в табличных частях.';
								  |en = 'Updates the ""Revaluate intangible assets"" documents:
								  |- Populates the ""Line ID"" field attribute in tables.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.ПереоценкаНМА2_4.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Документы.ПереоценкаНМА2_4.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");

КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = ПустаяСсылка().Метаданные().ПолноеИмя();
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Дата УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Дата УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Документ.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ПереоценкаНМА2_4 КАК Документ
	|ГДЕ
	|	ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			Документ.ПереоценкаНМА2_4.НМА КАК ТабЧасть
	|		ГДЕ
	|			ТабЧасть.Ссылка = Документ.Ссылка
	|			И ТабЧасть.ИдентификаторСтроки = """")
	|	";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = ПустаяСсылка().Метаданные().ПолноеИмя();
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	Для Каждого Документ Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		
		Попытка
			Ссылка = Документ.Ссылка;
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			ДокументОбъект = Ссылка.ПолучитьОбъект();
			
			Если ДокументОбъект <> Неопределено Тогда
				ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ДокументОбъект, "НМА");
			КонецЕсли;
			
			Если ДокументОбъект <> Неопределено И ДокументОбъект.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Ссылка);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Документ.Ссылка);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
