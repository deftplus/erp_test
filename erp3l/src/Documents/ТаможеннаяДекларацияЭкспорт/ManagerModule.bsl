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
	
	МеханизмыДокумента.Добавить("РеестрДокументов");
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
		
		ЗаполнитьПараметрыИнициализации(Запрос, Документ);
		
		////////////////////////////////////////////////////////////////////////////
		// Сформируем текст запроса
		
		ТекстЗапросаТаблицаСведенияТаможенныхДекларацийЭкспорт(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

#КонецОбласти

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

// Возвращает количество счетов-фактур к оформлению.
//
// Параметры:
//	Параметры - структура со следующими свойствами:
//	* МассивОрганизаций - Массив - массив организаций.
//	* НачалоПериода - Дата - ограничение снизу на дату документа-основания.
//	* КонецПериода - Дата - ограничение сверху на дату документа-основания.
//	* БезОграниченияПериода - Булево - не ограничивать по дате документа-основания
//
// Возвращаемое значение:
//	Число - количество счетов-фактур к оформлению.
//
Функция ЕстьСчетаФактурыКОформлению(Параметры) Экспорт
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОрганизаций", Параметры.МассивОрганизаций);
	Запрос.УстановитьПараметр("НачалоПериода",     Параметры.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",      Параметры.КонецПериода);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(1) КАК КоличествоДокументовКОформлению
	|	ИЗ
	|		РегистрСведений.ТаможенныеДекларацииЭкспортКРегистрации КАК КРегистрации
	|	ГДЕ
	|		КРегистрации.ДатаРеализации МЕЖДУ &НачалоПериода И &КонецПериода
	|		И &УсловиеОтбора
	|";
	
	Если ЗначениеЗаполнено(Параметры.МассивОрганизаций) Тогда
		УсловиеОтбора = "КРегистрации.Организация В (&МассивОрганизаций)";
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеОтбора", УсловиеОтбора);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"И &УсловиеОтбора", "");
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И НЕ Выборка.КоличествоДокументовКОформлению = NULL Тогда
		Возврат Выборка.КоличествоДокументовКОформлению;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции


// Меняет реквизит СборСопроводительныхДокументовЗавершен документа без перепроведения и с отключением проверки
// дат запрета изменения.
//
// Параметры:
//	Ссылка - ДокументСсылка.ТаможеннаяДекларацияЭкспорт - документ, в котором нужно установить состояние
//	СборЗавершен - Булево - новое состояние сбора.
//
Процедура УстановитьСостояниеСбораСопроводительныхДокументов(Ссылка, СборЗавершен) Экспорт
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(Ссылка);
		ДокументОбъект = Ссылка.ПолучитьОбъект();
		ДокументОбъект.СборСопроводительныхДокументовЗавершен = СборЗавершен;
		ДокументОбъект.ДополнительныеСвойства.Вставить("ПроверкаДатыЗапретаИзменения", Ложь);
		ДокументОбъект.Записать();
	Исключение
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Не удалось заблокировать документ: %1. Возможно, документ редактируется другим пользователем';
				|en = 'Cannot unlock document: %1. It may be currently edited by another user'"),
			Ссылка);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	КонецПопытки;
	
КонецПроцедуры

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

#Область СлужебныеПроцедурыИФункции

#Область СозданиеНаОсновании

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Добавляет команду создания документа "Таможенная декларация на экспорт".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ТаможеннаяДекларацияЭкспорт) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ТаможеннаяДекларацияЭкспорт.ПолноеИмя();
		КомандаСоздатьНаОсновании.Обработчик = "УчетНДСРФКлиент.ТаможеннаяДекларацияЭкспортНаОсновании";
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ТаможеннаяДекларацияЭкспорт);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ВестиУчетТаможенныхДекларацийНаЭкспорт";
		
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область Проведение

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт

	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.ТаможеннаяДекларацияЭкспорт";
	
	ВЗапросеЕстьИсточник = Истина;
	ТекстыЗапросаВременныхТаблиц = Новый Соответствие();
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать",           """""");
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		
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
										ПереопределениеРасчетаПараметров,
										ТекстыЗапросаВременныхТаблиц);
	Иначе	
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ПереопределениеРасчетаПараметров,
										ТекстыЗапросаВременныхТаблиц);
	КонецЕсли; 

	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаможеннаяДекларацияЭкспорт.Ссылка КАК Ссылка,
	|	ТаможеннаяДекларацияЭкспорт.Дата КАК Дата,
	|	ТаможеннаяДекларацияЭкспорт.Организация КАК Организация,
	|	ТаможеннаяДекларацияЭкспорт.Организация.ВалютаРегламентированногоУчета КАК Валюта,
	|	ТаможеннаяДекларацияЭкспорт.Номер КАК НомерВходящегоДокумента,
	|	ТаможеннаяДекларацияЭкспорт.КодОперации КАК КодОперации,
	|	ТаможеннаяДекларацияЭкспорт.Примечание КАК Примечание,
	|	ТаможеннаяДекларацияЭкспорт.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ТаможеннаяДекларацияЭкспорт.СборСопроводительныхДокументовЗавершен КАК СборСопроводительныхДокументовЗавершен,
	|	ТаможеннаяДекларацияЭкспорт.Автор КАК Автор,
	|	ТаможеннаяДекларацияЭкспорт.Комментарий КАК Комментарий
	|ПОМЕСТИТЬ Реквизиты
	|ИЗ
	|	Документ.ТаможеннаяДекларацияЭкспорт КАК ТаможеннаяДекларацияЭкспорт
	|ГДЕ
	|	ТаможеннаяДекларацияЭкспорт.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Ссылка,
	|	Реквизиты.Дата КАК Дата,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.НомерВходящегоДокумента КАК НомерВходящегоДокумента,
	|	Реквизиты.КодОперации КАК КодОперации,
	|	Реквизиты.Примечание КАК Примечание,
	|	Реквизиты.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	Реквизиты.СборСопроводительныхДокументовЗавершен КАК СборСопроводительныхДокументовЗавершен,
	|	Реквизиты.Автор КАК Автор,
	|	Реквизиты.Комментарий КАК Комментарий
	|ИЗ
	|	Реквизиты КАК Реквизиты";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", Реквизиты.ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("Комментарий",           Реквизиты.Комментарий);
	
	ЗначенияПараметровПроведения = ЗначенияПараметровПроведения();
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла; 
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)

	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ТаможеннаяДекларацияЭкспорт"));

	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Функция ТекстЗапросаТаблицаСведенияТаможенныхДекларацийЭкспорт(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СведенияТаможенныхДекларацийЭкспорт";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Дата                         КАК Период,
	|	Реквизиты.Ссылка                       КАК Регистратор,
	|	ДокументыОснования.ДокументОснование   КАК ДокументОтгрузки,
	|	Реквизиты.Организация                  КАК Организация,
	|	Реквизиты.НомерВходящегоДокумента      КАК НомерТаможеннойДекларации,
	|	Реквизиты.КодОперации                  КАК КодОперации,
	|	СопроводительныеДокументы.КодТС        КАК КодТС,
	|	СопроводительныеДокументы.ВидДокумента КАК ВидДокумента,
	|	СопроводительныеДокументы.НомерТСД     КАК НомерТСД,
	|	СопроводительныеДокументы.ДатаТСД      КАК ДатаТСД,
	|	Реквизиты.Примечание                   КАК Примечание
	|ИЗ
	|	Реквизиты КАК Реквизиты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ТаможеннаяДекларацияЭкспорт.ДокументыОснования КАК ДокументыОснования
	|		ПО Реквизиты.Ссылка = ДокументыОснования.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ТаможеннаяДекларацияЭкспорт.СопроводительныеДокументы КАК СопроводительныеДокументы
	|		ПО Реквизиты.Ссылка = СопроводительныеДокументы.Ссылка
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Ссылка КАК Ссылка,
	|	ДанныеДокумента.Дата КАК ДатаДокументаИБ,
	|	ДанныеДокумента.Номер КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных КАК ТипСсылки,
	|	ДанныеДокумента.Организация КАК Организация,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.Договор КАК Договор,
	|	ДанныеДокумента.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ДанныеДокумента.Склад КАК МестоХранения,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ДанныеДокумента.Ответственный КАК Ответственный,
	|	ДанныеДокумента.Автор КАК Автор,
	|	&Комментарий КАК Комментарий,
	|	ДанныеДокумента.Организация.ВалютаРегламентированногоУчета КАК Валюта,
	|	0 КАК Сумма,
	|	НЕОПРЕДЕЛЕНО КАК Статус,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
	|	ЛОЖЬ КАК ДополнительнаяЗапись,
	|	НЕОПРЕДЕЛЕНО КАК РазделительЗаписи,
	|	"""" КАК Дополнительно,
	|	ДанныеДокумента.Дата КАК ДатаПервичногоДокумента,
	|	ДанныеДокумента.Номер КАК НомерПервичногоДокумента,
	|	ЛОЖЬ КАК СторноИсправление,
	|	НЕОПРЕДЕЛЕНО КАК СторнируемыйДокумент,
	|	НЕОПРЕДЕЛЕНО КАК ИсправляемыйДокумент,
	|	ДанныеДокумента.Дата КАК ДатаОтраженияВУчете,
	|	НЕОПРЕДЕЛЕНО КАК Приоритет
	|ИЗ
	|	Документ.ТаможеннаяДекларацияЭкспорт КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ФормированиеГиперссылкиВЖурналеДокументовНДС

Функция СформироватьГиперссылкуКОформлению(Параметры) Экспорт
	
	Если Не ПравоДоступа("Изменение", Метаданные.Документы.ТаможеннаяДекларацияЭкспорт) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Параметры.Вставить("МассивОрганизаций",?(ЗначениеЗаполнено(Параметры.Организация), 
											ОбщегоНазначенияУТКлиентСервер.Массив(Параметры.Организация),
											Неопределено));
	
	ТекстГиперссылки = НСтр("ru = 'ТД экспорт';
							|en = 'Customs declaration export'");
	
	Если ЕстьСчетаФактурыКОформлению(Параметры) Тогда
		Возврат Новый ФорматированнаяСтрока(ТекстГиперссылки,,ЦветаСтиля.НезаполненноеПолеТаблицы,,
			ИмяФормыТаможеннаяДекларацияЭкспорт());
	Иначе
		Возврат Новый ФорматированнаяСтрока(ТекстГиперссылки,,,,
			ИмяФормыТаможеннаяДекларацияЭкспорт());
	КонецЕсли;
	
КонецФункции

Функция ИмяФормыТаможеннаяДекларацияЭкспорт() Экспорт
	
	Возврат "Документ.ТаможеннаяДекларацияЭкспорт.Форма.ФормаРабочееМесто";
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Документы.ТаможеннаяДекларацияЭкспорт.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.7.49";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("5c2f5939-170b-4789-8df4-8ccfc9469386");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Документы.ТаможеннаяДекларацияЭкспорт.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет служебные реквизиты документа ""Таможенная декларация на экспорт"".';
									|en = 'Fills in service details of the document ""Export customs declaration"".'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ТаможеннаяДекларацияЭкспорт.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Документы.ТаможеннаяДекларацияЭкспорт.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Документы.ТаможеннаяДекларацияЭкспорт.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.РеализацияТоваровУслуг.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "Любой";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.РеализацияТоваровУслуг.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = "Документ.ТаможеннаяДекларацияЭкспорт";
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Дата УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Дата УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаможеннаяДекларацияЭкспорт.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ТаможеннаяДекларацияЭкспорт КАК ТаможеннаяДекларацияЭкспорт
	|ГДЕ
	|	ТаможеннаяДекларацияЭкспорт.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПустаяСсылка)"
	);
	
	Данные = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Данные);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Документ.ТаможеннаяДекларацияЭкспорт";
	
	НовыеРеквизиты = Новый Массив;
	НовыеРеквизиты.Добавить("Контрагент");
	НовыеРеквизиты.Добавить("Партнер");
	НовыеРеквизиты.Добавить("Договор");
	НовыеРеквизиты.Добавить("Склад");
	НовыеРеквизиты.Добавить("Подразделение");
	НовыеРеквизиты.Добавить("НаправлениеДеятельности");
	РеквизитыСтрокой = СтрСоединить(НовыеРеквизиты, ",");
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаОбновляемыхДанных", ОбновляемыеДанные);
	
	Запрос.Текст =
	"ВЫБРАТЬ ТаблицаДанных.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТОбъектыДляОбработки
	|ИЗ &ТаблицаОбновляемыхДанных КАК ТаблицаДанных;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОбъектыДляОбработки.Ссылка КАК Ссылка,
	|	ОбъектыДляОбработки.Ссылка.ВерсияДанных КАК ВерсияДанных,
	|	ДокументыОснования.ДокументОснование КАК ДокументОснование,
	|	ЕСТЬNULL(ДанныеОснований.Склад, НЕОПРЕДЕЛЕНО) КАК Склад,
	|	ЕСТЬNULL(ДанныеОснований.Подразделение, НЕОПРЕДЕЛЕНО) КАК Подразделение,
	|	ЕСТЬNULL(ДанныеОснований.НаправлениеДеятельности, НЕОПРЕДЕЛЕНО) КАК НаправлениеДеятельности,
	|	ЕСТЬNULL(ДанныеОснований.Контрагент, НЕОПРЕДЕЛЕНО) КАК Контрагент,
	|	ЕСТЬNULL(ДанныеОснований.Партнер, НЕОПРЕДЕЛЕНО) КАК Партнер,
	|	ЕСТЬNULL(ДанныеОснований.Договор, НЕОПРЕДЕЛЕНО) КАК Договор
	|ИЗ
	|	ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.ТаможеннаяДекларацияЭкспорт.ДокументыОснования КАК ДокументыОснования
	|	ПО ОбъектыДляОбработки.Ссылка = ДокументыОснования.Ссылка
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК ДанныеОснований
	|	ПО ДокументыОснования.ДокументОснование = ДанныеОснований.Ссылка
	|ИТОГИ ПО Ссылка
	|";
	
	ОтборОснования = Новый Структура("ДокументОснование");
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДокументов = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаДокументов.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ВыборкаДокументов.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			ДокументОбъект = ОбновлениеИнформационнойБазыУТ.ПроверитьПолучитьОбъект(
				ВыборкаДокументов.Ссылка, ВыборкаДокументов.ВерсияДанных, Параметры.Очередь);
			Если ДокументОбъект = Неопределено Тогда
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ДокументОбъект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОформлениеТаможеннойДекларацииЭкспорт;
			
			ЗначенияРеквизитов = Новый Структура(РеквизитыСтрокой);
			
			Для Каждого СтрокаТаблицы Из ДокументОбъект.ДокументыОснования Цикл
				
				ПерваяСтрока = Истина;
				
				ОтборОснования.ДокументОснование = СтрокаТаблицы.ДокументОснование;
				
				ВыборкаОснований = ВыборкаДокументов.Выбрать();
				Если ВыборкаОснований.НайтиСледующий(ОтборОснования) Тогда
					
					Если ПерваяСтрока Тогда
						ПерваяСтрока = Ложь;
						ЗаполнитьЗначенияСвойств(ЗначенияРеквизитов, ВыборкаОснований);
						Продолжить;
					КонецЕсли;
					
					Для Каждого Реквизит Из НовыеРеквизиты Цикл
						
						Если ЗначенияРеквизитов.Свойство(Реквизит)
							И ЗначенияРеквизитов[Реквизит] <> ВыборкаОснований[Реквизит] Тогда
							ЗначенияРеквизитов.Удалить(Реквизит);
						КонецЕсли;
						
					КонецЦикла;
					
				КонецЕсли;
				
			КонецЦикла;
			
			Если ЗначенияРеквизитов.Количество() > 0 Тогда
				ЗаполнитьЗначенияСвойств(ДокументОбъект, ЗначенияРеквизитов);
			КонецЕсли;
			
			ЗначенияРеквизитов = Неопределено;
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект,,, РежимЗаписиДокумента.Запись);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), ВыборкаДокументов.Ссылка);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
