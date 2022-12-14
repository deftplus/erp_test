
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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

		ТекстЗапросаТаблицаРегистрацияТранспортныхСредств(ТекстыЗапроса, Регистры);
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

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт

	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.РегистрацияТранспортныхСредств";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	
	ВЗапросеЕстьИсточник = Истина;
	
	Если ИмяРегистра = "СпособыОтраженияРасходовПоИмущественнымНалогам" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаСпособыОтраженияРасходовПоИмущественнымНалогам(ТекстыЗапроса, Неопределено);
		СинонимТаблицыДокумента = "ТабличнаяЧастьДокумента";
		
	ИначеЕсли ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "";
		ВЗапросеЕстьИсточник = Ложь;
		
	ИначеЕсли ИмяРегистра = "ДокументыПоОС" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаДокументыПоОС(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		
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

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт
	
	ИсточникиДанных = Новый Соответствие;
	Возврат ИсточникиДанных;
	
КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Операция.Организация,
	|	Операция.Дата КАК Период,
	|	Операция.Ссылка,
	|	Операция.Номер,
	|	Операция.ПометкаУдаления,
	|	Операция.Проведен,
	|	Операция.Комментарий,
	|	Операция.Ответственный,
	|	Операция.ПостановкаНаУчетВНалоговомОргане,
	|	Операция.НалоговыйОрган,
	|	Операция.КодПоОКТМО,
	|	Операция.КодПоОКАТО,
	|	Операция.КодВидаТранспортногоСредства,
	|	Операция.НалоговаяБаза,
	|	Операция.ЕдиницаИзмеренияНалоговойБазы,
	|	Операция.НалоговаяСтавка,
	|	Операция.СтавкаОпределяетсяАвтоматически,
	|	Операция.НалоговаяЛьгота,
	|	Операция.КодНалоговойЛьготы,
	|	Операция.ЛьготнаяСтавка,
	|	Операция.ПроцентУменьшения,
	|	Операция.СуммаУменьшения,
	|	Операция.РегиональныйКодЛьготы,
	|	Операция.ЭкологическийКласс,
	|	Операция.ПовышающийКоэффициент,
	|	Операция.НалоговаяСтавкаЗависитОтГодаВыпускаТС,
	|	Операция.УказаныСпособыОтражениеРасходов
	|ИЗ
	|	Документ.РегистрацияТранспортныхСредств КАК Операция
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
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.РегистрацияТранспортныхСредств"));
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.РегистрацияТранспортныхСредств);

	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли; 
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Процедура ТекстЗапросаТаблицаРегистрацияТранспортныхСредств(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РегистрацияТранспортныхСредств";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = 
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	ВЫБОР 
	|		КОГДА ТабличнаяЧастьДокумента.ДатаРегистрации <> ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ТабличнаяЧастьДокумента.ДатаРегистрации
	|		ИНАЧЕ &Период 
	|	КОНЕЦ КАК Период,
	|	
	|	&Организация КАК Организация,
	|	ТабличнаяЧастьДокумента.ОсновноеСредство КАК ОсновноеСредство,
	|	
	|	ИСТИНА КАК ВключатьВНалоговуюБазу,
	|	ТабличнаяЧастьДокумента.РегистрационныйЗнак КАК РегистрационныйЗнак,
	|	ТабличнаяЧастьДокумента.ИдентификационныйНомер КАК ИдентификационныйНомер,
	|	ТабличнаяЧастьДокумента.Марка КАК Марка,
	|	&ПостановкаНаУчетВНалоговомОргане КАК ПостановкаНаУчетВНалоговомОргане,
	|	&НалоговыйОрган КАК НалоговыйОрган,
	|	&КодПоОКТМО КАК КодПоОКТМО,
	|	&КодПоОКАТО КАК КодПоОКАТО,
	|	&КодВидаТранспортногоСредства КАК КодВидаТранспортногоСредства,
	|	&НалоговаяБаза КАК НалоговаяБаза,
	|	&ЕдиницаИзмеренияНалоговойБазы КАК ЕдиницаИзмеренияНалоговойБазы,
	|	&НалоговаяСтавка КАК НалоговаяСтавка,
	|	&СтавкаОпределяетсяАвтоматически КАК СтавкаОпределяетсяАвтоматически,
	|	&НалоговаяЛьгота КАК НалоговаяЛьгота,
	|	&КодНалоговойЛьготы КАК КодНалоговойЛьготы,
	|	&ЛьготнаяСтавка КАК ЛьготнаяСтавка,
	|	&ПроцентУменьшения КАК ПроцентУменьшения,
	|	&СуммаУменьшения КАК СуммаУменьшения,
	|	&РегиональныйКодЛьготы КАК РегиональныйКодЛьготы,
	|	&ЭкологическийКласс КАК ЭкологическийКласс,
	|	ТабличнаяЧастьДокумента.ОбщаяСобственность КАК ОбщаяСобственность,
	|	ТабличнаяЧастьДокумента.ДоляВПравеОбщейСобственностиЧислитель КАК ДоляВПравеОбщейСобственностиЧислитель,
	|	ТабличнаяЧастьДокумента.ДоляВПравеОбщейСобственностиЗнаменатель КАК ДоляВПравеОбщейСобственностиЗнаменатель,
	|	&ПовышающийКоэффициент КАК ПовышающийКоэффициент,
	|	&НалоговаяСтавкаЗависитОтГодаВыпускаТС КАК НалоговаяСтавкаЗависитОтГодаВыпускаТС,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидЗаписиОРегистрации.Регистрация) КАК ВидЗаписи
	|ИЗ
	|	Документ.РегистрацияТранспортныхСредств.ОС КАК ТабличнаяЧастьДокумента
	|ГДЕ
	|	ТабличнаяЧастьДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаСпособыОтраженияРасходовПоИмущественнымНалогам(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СпособыОтраженияРасходовПоИмущественнымНалогам";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Текст =
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	&Организация КАК Организация,
	|	ТабличнаяЧастьДокумента.ОсновноеСредство КАК ОсновноеСредство,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ТранспортныйНалог) КАК ВидНалога,
	|	ИСТИНА КАК СпособОтраженияРасходовЗаданДокументом,
	|	&Ссылка КАК СпособОтраженияРасходов
	|ИЗ
	|	Документ.РегистрацияТранспортныхСредств.ОС КАК ТабличнаяЧастьДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РегистрацияТранспортныхСредств.ОтражениеРасходов КАК ТаблицаОтражениеРасходов
	|		ПО (ТаблицаОтражениеРасходов.Ссылка = ТабличнаяЧастьДокумента.Ссылка)
	|			И (ТаблицаОтражениеРасходов.НомерСтроки = 1)
	|ГДЕ
	|	ТабличнаяЧастьДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра);
	
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
	|	&Период                                 КАК ДатаДокументаИБ,
	|	&Номер                                  КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	&Организация                            КАК Организация,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&Ответственный                          КАК Ответственный,
	|	&Комментарий                            КАК Комментарий,
	|	&Проведен                               КАК Проведен,
	|	&ПометкаУдаления                        КАК ПометкаУдаления,
	|	ЛОЖЬ                                    КАК ДополнительнаяЗапись,
	|	&Период                                 КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать                          КАК НомерПервичногоДокумента,
	|	ЛОЖЬ                                    КАК СторноИсправление,
	|	НЕОПРЕДЕЛЕНО                            КАК СторнируемыйДокумент,
	|	НЕОПРЕДЕЛЕНО                            КАК ИсправляемыйДокумент,
	|	&Период                                 КАК ДатаОтраженияВУчете,
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
	|	&Период                                 КАК Дата,
	|	&Организация                            КАК Организация,
	|	&Проведен                               КАК Проведен,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	ИСТИНА                                  КАК ОтражатьВРеглУчете,
	|	ЛОЖЬ                                    КАК ОтражатьВУпрУчете,
	|	ТаблицаОС.ОсновноеСредство              КАК ОсновноеСредство
	|ИЗ
	|	Документ.РегистрацияТранспортныхСредств КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РегистрацияТранспортныхСредств.ОС КАК ТаблицаОС
	|		ПО ДанныеДокумента.Ссылка = ТаблицаОС.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра, Истина);
	
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
