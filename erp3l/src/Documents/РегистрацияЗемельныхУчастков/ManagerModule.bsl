
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Команды

// Добавляет команду создания документа "Регистрация земельных участков".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.РегистрацияЗемельныхУчастков) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РегистрацияЗемельныхУчастков.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.РегистрацияЗемельныхУчастков);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	МеханизмыДокумента.Добавить("ИмущественныеНалоги");
	МеханизмыДокумента.Добавить("ОсновныеСредства");
	МеханизмыДокумента.Добавить("РеестрДокументов");
	
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
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		ЗаполнитьПараметрыИнициализации(Запрос, Документ);
		
		ТекстЗапросаТаблицаРегистрацияЗемельныхУчастков(ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаСпособыОтраженияРасходовПоИмущественнымНалогам(ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаДокументыПоОС(ТекстыЗапроса, Регистры);
	КонецЕсли;
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

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

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт
	
	ИсточникиДанных = Новый Соответствие;
	Возврат ИсточникиДанных;
	
КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт

	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.РегистрацияЗемельныхУчастков";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	
	ВЗапросеЕстьИсточник = Истина;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "";
		ВЗапросеЕстьИсточник = Ложь;
		
	ИначеЕсли ИмяРегистра = "ДокументыПоОС" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаДокументыПоОС(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		
	ИначеЕсли ИмяРегистра = "СпособыОтраженияРасходовПоИмущественнымНалогам" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаСпособыОтраженияРасходовПоИмущественнымНалогам(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ТабличнаяЧастьДокумента";
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.';
								|en = 'In document %ПолноеИмяДокумента%, adaptation of request for generating records of register %ИмяРегистра% is not implemented.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов"
		ИЛИ ИмяРегистра = "ДокументыПоОС" Тогда
		
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
	|	Операция.Ссылка,
	|	Операция.Номер,
	|	Операция.Дата,
	|	Операция.ПометкаУдаления,
	|	Операция.Проведен,
	|	Операция.Комментарий,
	|	Операция.Ответственный,
	|	Операция.Организация,
	|	Операция.КодКатегорииЗемель,
	|	Операция.ПостановкаНаУчетВНалоговомОргане,
	|	Операция.НалоговыйОрган,
	|	Операция.КодПоОКТМО,
	|	Операция.КодПоОКАТО,
	|	Операция.КБК,
	|	Операция.НалоговаяСтавка,
	|	Операция.НалоговаяЛьготаПоНалоговойБазе,
	|	Операция.КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395,
	|	Операция.КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391,
	|	Операция.УменьшениеНалоговойБазыПоСтатье391,
	|	Операция.УменьшениеНалоговойБазыНаСумму,
	|	Операция.ДоляНеОблагаемойНалогомПлощадиЧислитель,
	|	Операция.ДоляНеОблагаемойНалогомПлощадиЗнаменатель,
	|	Операция.НеОблагаемаяНалогомСумма,
	|	Операция.СниженнаяНалоговаяСтавка,
	|	Операция.ПроцентУменьшенияСуммыНалога,
	|	Операция.СуммаУменьшенияСуммыНалога,
	|	Операция.УказаныСпособыОтражениеРасходов
	|ИЗ
	|	Документ.РегистрацияЗемельныхУчастков КАК Операция
	|ГДЕ
	|	Операция.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	ЗначенияПараметровПроведения = ЗначенияПараметровПроведения(Реквизиты);
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла; 
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)

	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.РегистрацияЗемельныхУчастков"));
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.РегистрацияЗемельныхУчастков);

	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли; 
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Процедура ТекстЗапросаТаблицаРегистрацияЗемельныхУчастков(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РегистрацияЗемельныхУчастков";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	Текст =
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Дата КАК Период,
	|	
	|	&Организация КАК Организация,
	|	ТабличнаяЧастьДокумента.ОсновноеСредство КАК ОсновноеСредство,
	|	
	|	ИСТИНА КАК ВключатьВНалоговуюБазу,
	|	&КодКатегорииЗемель КАК КодКатегорииЗемель,
	|	ТабличнаяЧастьДокумента.КадастровыйНомер КАК КадастровыйНомер,
	|	ТабличнаяЧастьДокумента.КадастроваяСтоимость КАК КадастроваяСтоимость,
	|	ТабличнаяЧастьДокумента.ОбщаяСобственность КАК ОбщаяСобственность,
	|	ТабличнаяЧастьДокумента.ДоляВПравеОбщейСобственностиЧислитель КАК ДоляВПравеОбщейСобственностиЧислитель,
	|	ТабличнаяЧастьДокумента.ДоляВПравеОбщейСобственностиЗнаменатель КАК ДоляВПравеОбщейСобственностиЗнаменатель,
	|	ТабличнаяЧастьДокумента.ЖилищноеСтроительство КАК ЖилищноеСтроительство,
	|	ТабличнаяЧастьДокумента.ДатаНачалаПроектирования КАК ДатаНачалаПроектирования,
	|	ТабличнаяЧастьДокумента.ДатаРегистрацииПравНаОбъектНедвижимости КАК ДатаРегистрацииПравНаОбъектНедвижимости,
	|	&ПостановкаНаУчетВНалоговомОргане КАК ПостановкаНаУчетВНалоговомОргане,
	|	&НалоговыйОрган КАК НалоговыйОрган,
	|	&КодПоОКТМО КАК КодПоОКТМО,
	|	&КодПоОКАТО КАК КодПоОКАТО,
	|	&КБК КАК КБК,
	|	&НалоговаяСтавка КАК НалоговаяСтавка,
	|	&НалоговаяЛьготаПоНалоговойБазе КАК НалоговаяЛьготаПоНалоговойБазе,
	|	&КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395 КАК КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395,
	|	&КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391 КАК КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391,
	|	&УменьшениеНалоговойБазыПоСтатье391 КАК УменьшениеНалоговойБазыПоСтатье391,
	|	&УменьшениеНалоговойБазыНаСумму КАК УменьшениеНалоговойБазыНаСумму,
	|	&ДоляНеОблагаемойНалогомПлощадиЧислитель КАК ДоляНеОблагаемойНалогомПлощадиЧислитель,
	|	&ДоляНеОблагаемойНалогомПлощадиЗнаменатель КАК ДоляНеОблагаемойНалогомПлощадиЗнаменатель,
	|	&НеОблагаемаяНалогомСумма КАК НеОблагаемаяНалогомСумма,
	|	&СниженнаяНалоговаяСтавка КАК СниженнаяНалоговаяСтавка,
	|	&ПроцентУменьшенияСуммыНалога КАК ПроцентУменьшенияСуммыНалога,
	|	&СуммаУменьшенияСуммыНалога КАК СуммаУменьшенияСуммыНалога,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидЗаписиОРегистрации.Регистрация) КАК ВидЗаписи
	|	
	|ИЗ
	|	Документ.РегистрацияЗемельныхУчастков.ОС КАК ТабличнаяЧастьДокумента
	|ГДЕ
	|	ТабличнаяЧастьДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаСпособыОтраженияРасходовПоИмущественнымНалогам(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СпособыОтраженияРасходовПоИмущественнымНалогам";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Текст = 
	"ВЫБРАТЬ
	|	&Дата КАК Период,
	|	&Организация КАК Организация,
	|	ТабличнаяЧастьДокумента.ОсновноеСредство КАК ОсновноеСредство,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ЗемельныйНалог) КАК ВидНалога,
	|	ИСТИНА КАК СпособОтраженияРасходовЗаданДокументом,
	|	&Ссылка КАК СпособОтраженияРасходов
	|ИЗ
	|	Документ.РегистрацияЗемельныхУчастков.ОС КАК ТабличнаяЧастьДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РегистрацияЗемельныхУчастков.ОтражениеРасходов КАК ТаблицаОтражениеРасходов
	|		ПО (ТаблицаОтражениеРасходов.Ссылка = ТабличнаяЧастьДокумента.Ссылка)
	|			И (ТаблицаОтражениеРасходов.НомерСтроки = 1)
	|ГДЕ
	|	ТабличнаяЧастьДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
	Возврат Текст;
	
КонецФункции

Функция ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Ссылка                                 КАК Ссылка,
	|	&Дата                                   КАК ДатаДокументаИБ,
	|	&Номер                                  КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	&Организация                            КАК Организация,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&Ответственный                          КАК Ответственный,
	|	&Комментарий                            КАК Комментарий,
	|	&Проведен                               КАК Проведен,
	|	&ПометкаУдаления                        КАК ПометкаУдаления,
	|	ЛОЖЬ                                    КАК ДополнительнаяЗапись,
	|	&Дата                                   КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать                          КАК НомерПервичногоДокумента,
	|	ЛОЖЬ                                    КАК СторноИсправление,
	|	НЕОПРЕДЕЛЕНО                            КАК СторнируемыйДокумент,
	|	НЕОПРЕДЕЛЕНО                            КАК ИсправляемыйДокумент,
	|	&Дата                                   КАК ДатаОтраженияВУчете,
	|	НЕОПРЕДЕЛЕНО                            КАК Приоритет";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДокументыПоОС(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДокументыПоОС";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ТаблицаОС.НомерСтроки-1, 0)    КАК НомерЗаписи,
	|	&Ссылка                                 КАК Ссылка,
	|	&Дата                                   КАК Дата,
	|	&Организация                            КАК Организация,
	|	&Проведен                               КАК Проведен,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	ИСТИНА                                  КАК ОтражатьВРеглУчете,
	|	ЛОЖЬ                                    КАК ОтражатьВУпрУчете,
	|	ТаблицаОС.ОсновноеСредство              КАК ОсновноеСредство
	|ИЗ
	|	Документ.РегистрацияЗемельныхУчастков КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РегистрацияЗемельныхУчастков.ОС КАК ТаблицаОС
	|		ПО ДанныеДокумента.Ссылка = ТаблицаОС.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область БлокировкаПриОбновленииИБ

Процедура ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ПредставлениеОперации) Экспорт
	
	ВходящиеДанные = Новый Соответствие;
	
	ЗакрытиеМесяцаСервер.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ВходящиеДанные, ПредставлениеОперации);
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Возврат; //В дальнейшем будет добавлен код команд
	
КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ПараметрыВыбораСтатейИАналитик() Экспорт
	
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "Объект.ОтражениеРасходов";
	ПараметрыВыбора.Статья = "СтатьяРасходов";
	
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаРасходов";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("ОтражениеРасходовСтатьяРасходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("ОтражениеРасходовАналитикаРасходов");
	
	Возврат ПараметрыВыбора;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
