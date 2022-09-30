#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает параметры выбора статей и аналитик.
// 
// Возвращаемое значение:
//   Структура - см. ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики.
//
Функция ПараметрыВыбораСтатейИАналитик(ХозяйственнаяОперация) Экспорт
	
	ПараметрыВыбораСтатейИАналитик = Новый Массив;
	
	#Область РасходыПриУСН
	
	// СтатьяРасходов
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным           = "Объект.РасходыПриУСН";
	ПараметрыВыбора.Статья                = "СтатьяРасходов";
	ПараметрыВыбора.ДоступностьПоОперации = Неопределено;
	ПараметрыВыбора.ВыборСтатьиРасходов   = (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковПрочихРасходовУСН);
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("РасходыПриУСНПрочиеРасходыСтатьяРасходов");
	
	ПараметрыВыбораСтатейИАналитик.Добавить(ПараметрыВыбора);
	
	#КонецОбласти
	
	Возврат ПараметрыВыбораСтатейИАналитик;
	
КонецФункции

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	МеханизмыДокумента.Добавить("РеестрДокументов");
	//++ НЕ УТКА
	МеханизмыДокумента.Добавить("МеждународныйУчет");
	//-- НЕ УТКА
	
	ВводОстатковЛокализация.ВводОстатковРасходовПриУСНЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента);
	
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
//     Таблица<ИмяРегистра> - ТаблицаЗначений - таблица данных для отражения в регистр.
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, Документ);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
	
	ВводОстатковЛокализация.ВводОстатковРасходовПриУСНДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеДокументов.ДобавитьЗапросыСторноДвижений(Запрос, ТекстыЗапроса, Регистры, ПустаяСсылка().Метаданные());
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

#КонецОбласти

#Область СозданиеНаОсновании

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
	Обработки.СправочноеРазмещениеНоменклатуры.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
	ИсправлениеДокументов.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, ПустаяСсылка().Метаданные());
	
	ВводОстатковЛокализация.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры);
	
КонецПроцедуры

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	ВводОстатковЛокализация.ВводОстатковРасходовПриУСНДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);
КонецПроцедуры

#КонецОбласти

//++ НЕ УТ
#Область ПроведениеРегламентированныйУчет

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт
	Возврат ВводОстатковЛокализация.ВводОстатковРасходовПриУСНТекстОтраженияВРеглУчете();
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламентированном учете
//
// Возвращаемое значение:
//  Строка - Содержащая текст запроса временных таблиц для отражения в регл. учете.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	Возврат ВводОстатковЛокализация.ВводОстатковРасходовПриУСНТекстЗапросаВТОтраженияВРеглУчете();
КонецФункции

#КонецОбласти

#Область ЗаполнениеПоДаннымОперативногоУчета

// Возвращает таблицу значения для заполнения документа ввода остатков данными, полученными по данным оперативного учета.
// 
// Параметры:
// 	Дата - Дата - Дата, на которую формируются остатки.
// 	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция, для которой выбираются остатки
// 	Организации - Массив - Массив, содержащий элементы типа СправочникСсылка.Организации, для которых выбираются остатки.
// 	ДополнительныйОтбор - Структура - Структура, содержащая ключ и значение дополнительного отбора.
// 	ПараметрыЗаполненияОстатков - Структура - Структура, содержащая дополнительные параметры необходимые, для заполнения остатков.
// Возвращаемое значение:
// 	ТаблицаЗначений, Неопределено - Если для данной хозяйственной операции есть данные, для нее возвращается таблица значений с значениями заполнения.
//
Функция ОстаткиПоТипуОперации(Дата, ХозяйственнаяОперация, Организации, ДополнительныйОтбор = Неопределено, ПараметрыЗаполненияОстатков = Неопределено) Экспорт
	Возврат Неопределено;
КонецФункции

// Возвращает массив в котором содержатся имена полей при изменении которых, необходимо генерировать новый документ ввода остатков.
// 
// Параметры:
// 	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция, для которой определяются ключевые поля.
// Возвращаемое значение:
// 	Массив - Массив содержащий имена полей.
//
Функция КлючевыеПоляРеглУчетаПоТипуОперации(ХозяйственнаяОперация) Экспорт
	МассивКлючевыхПолей = Новый Массив;
	Возврат МассивКлючевыхПолей;
КонецФункции

#КонецОбласти
//-- НЕ УТ

#Область ДляВызоваИзДругихПодсистем

// Добавляет команду создания документа на основании.
//
// Параметры:
//  КомандыСоздатьНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Возврат СозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Документы.ВводОстатковРасходовПриУСН);
	
КонецФункции

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

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Документы.ВводОстатковРасходовПриУСН.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.7.66";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("6a969360-2f99-4ef1-b32e-c5b555f1db7c");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Документы.ВводОстатковРасходовПриУСН.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет заполнение реквизита ""Партия"".';
									|en = 'Populates ""Lot reference"" attribute.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.ВводОстатковРасходовПриУСН.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Документы.ВводОстатковРасходовПриУСН.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Документы.ВводОстатковРасходовПриУСН.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
КонецПроцедуры

// Регистрирует данные для обработчика обновления ОбработатьДанныеДляПереходаНаНовуюВерсию
// 
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = "Документ.ВводОстатковРасходовПриУСН";
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Дата УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Дата УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РасходыПриУСН.Ссылка
	|ИЗ
	|	Документ.ВводОстатковРасходовПриУСН.РасходыПриУСН КАК РасходыПриУСН
	|ГДЕ
	|	РасходыПриУСН.Ссылка.ХозяйственнаяОперация В (
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВводОстатковПрочихРасходовУСН),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВводОстатковРасходовУСНПоМатериалам),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВводОстатковРасходовУСНПоТоварам))
	|	И РасходыПриУСН.Партия = НЕОПРЕДЕЛЕНО
	|";
	
	Регистраторы = Запрос.Выполнить().Выгрузить();
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Регистраторы.ВыгрузитьКолонку("Ссылка"));
	
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
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Документ.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			ДокументОбъект = Документ.Ссылка.ПолучитьОбъект();
			ОбъектИзменен = Ложь;
			
			Если ДокументОбъект <> Неопределено Тогда
				
				Для каждого СтрокаТЧ Из ДокументОбъект.РасходыПриУСН Цикл
					
					Если ЗначениеЗаполнено(СтрокаТЧ.ДокументВозникновенияРасходов) И НЕ ЗначениеЗаполнено(СтрокаТЧ.Партия) Тогда
						СтрокаТЧ.Партия = СтрокаТЧ.ДокументВозникновенияРасходов;
						ОбъектИзменен = Истина;
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
				
			Если ОбъектИзменен Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Документ.Ссылка);
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

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	ВыбраннаяОперация = Неопределено;
	
	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
		ВыбраннаяОперация = Параметры.Ключ.ХозяйственнаяОперация;
	ИначеЕсли Параметры.Свойство("ЗначенияЗаполнения") Тогда
		Параметры.ЗначенияЗаполнения.Свойство("ХозяйственнаяОперация", ВыбраннаяОперация);
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") Тогда
		ВыбраннаяОперация = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Параметры.ЗначениеКопирования,"ХозяйственнаяОперация");
	ИначеЕсли Параметры.Свойство("ОтборПоТипамОпераций") И Параметры.ОтборПоТипамОпераций.Количество() = 1 Тогда
		
		ВыбраннаяОперация = Параметры.ОтборПоТипамОпераций[0].Значение;
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ХозяйственнаяОперация", ВыбраннаяОперация);
		
		Параметры.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		Если Параметры.Свойство("Организация") Тогда
			ЗначенияЗаполнения.Вставить("Организация", Параметры.Организация);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Ссылка");
	Поля.Добавить("Номер");
	Поля.Добавить("Дата");
	Поля.Добавить("ХозяйственнаяОперация");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Данные.Ссылка <> Неопределено Тогда
		Представление = ВводОстатковВызовСервера.ЗаголовокДокументаВводОстатковПоХозяйственнойОперации(Данные.Ссылка,
			Данные.Номер,
			Данные.Дата,
			Данные.ХозяйственнаяОперация);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	Запрос                       = Новый Запрос;
	ТекстыЗапроса                = Новый СписокЗначений();
	
	ПолноеИмяДокумента = "Документ.ВводОстатковРасходовПриУСН"; 
	ВЗапросеЕстьИсточник = Ложь;
	
	ЗначенияПараметров = Новый Структура;
	ЗначенияПараметров.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Документы.ВводОстатковРасходовПриУСН));
	
	ПереопределениеРасчетаПараметров = Новый Структура;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		ВЗапросеЕстьИсточник = Истина;
		
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
	Результат.ТекстЗапроса       = ТекстЗапроса;
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст ="ВЫБРАТЬ
		|	ДанныеДокумента.Дата КАК Период,
		|	ДанныеДокумента.Номер КАК Номер,
		|	ДанныеДокумента.Ссылка КАК Ссылка,
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.Валюта КАК Валюта,
		|	ДанныеДокумента.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
		|	ЛОЖЬ КАК ОбособленныйУчетТоваровПоСделке,
		|	ДанныеДокумента.Проведен КАК Проведен,
		|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
		|	ДанныеДокумента.Ответственный КАК Ответственный,
		|	СУММА(ЕСТЬNULL(ДанныеТабличнойЧастиРасходыПриУСН.СуммаРасходов, 0)) КАК Сумма,
		|	ДанныеДокумента.ОтражатьВОперативномУчете КАК ОтражатьВОперативномУчете,
		|	ДанныеДокумента.Исправление КАК Исправление,
		|	ДанныеДокумента.СторнируемыйДокумент КАК СторнируемыйДокумент,
		|	ДанныеДокумента.ИсправляемыйДокумент КАК ИсправляемыйДокумент,
		|	ВЫРАЗИТЬ(ДанныеДокумента.Комментарий КАК СТРОКА(100)) КАК Комментарий
		|ИЗ
		|	Документ.ВводОстатковРасходовПриУСН КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВводОстатковРасходовПриУСН.РасходыПриУСН КАК ДанныеТабличнойЧастиРасходыПриУСН
		|		ПО ДанныеДокумента.Ссылка = ДанныеТабличнойЧастиРасходыПриУСН.Ссылка
		|ГДЕ
		|	ДанныеДокумента.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Валюта,
		|	ДанныеДокумента.ХозяйственнаяОперация,
		|	ДанныеДокумента.Проведен,
		|	ДанныеДокумента.ПометкаУдаления,
		|	ВЫРАЗИТЬ(ДанныеДокумента.Комментарий КАК СТРОКА(100)),
		|	ДанныеДокумента.Исправление,
		|	ДанныеДокумента.СторнируемыйДокумент,
		|	ДанныеДокумента.ИсправляемыйДокумент,
		|	ДанныеДокумента.Ответственный";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();

	Запрос.УстановитьПараметр("Период",                                Реквизиты.Период);
	Запрос.УстановитьПараметр("Номер",                                 Реквизиты.Номер);
	Запрос.УстановитьПараметр("Проведен",                              Реквизиты.Проведен);
	Запрос.УстановитьПараметр("Организация",                           Реквизиты.Организация);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",                 Реквизиты.ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("ИспользоватьУчетПрочихДоходовРасходов", ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов"));
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета",        ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Реквизиты.Организация));
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета",            Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("ПустоеНазначение",                      Справочники.Назначения.ПустаяСсылка());
	Запрос.УстановитьПараметр("Ответственный",                         Реквизиты.Ответственный);
	Запрос.УстановитьПараметр("Комментарий",                           Реквизиты.Комментарий);
	Запрос.УстановитьПараметр("ПометкаУдаления",                       Реквизиты.ПометкаУдаления);
	Запрос.УстановитьПараметр("Валюта",                                Реквизиты.Валюта);
	Запрос.УстановитьПараметр("ОтражатьВОперативномУчете",             Реквизиты.ОтражатьВОперативномУчете);
	Запрос.установитьПараметр("Сумма",                                 Реквизиты.Сумма);
	Запрос.УстановитьПараметр("Исправление",                           Реквизиты.Исправление);
	Запрос.УстановитьПараметр("СторнируемыйДокумент",                  Реквизиты.СторнируемыйДокумент);
	Запрос.УстановитьПараметр("ИсправляемыйДокумент",                  Реквизиты.ИсправляемыйДокумент);
	Запрос.УстановитьПараметр("ИдентификаторМетаданных", 
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Документы.ВводОстатковРасходовПриУСН));
	
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры


Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	&ИдентификаторМетаданных КАК ТипСсылки,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	&Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК Партнер,
	|	НЕОПРЕДЕЛЕНО КАК МестоХранения,
	|	НЕОПРЕДЕЛЕНО КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО КАК Подразделение,
	|	&Период КАК ДатаДокументаИБ,
	|	&Ссылка КАК Ссылка,
	|	&Номер КАК НомерДокументаИБ,
	|	НЕОПРЕДЕЛЕНО КАК Статус,
	|	&Ответственный КАК Ответственный,
	|	ЛОЖЬ КАК ДополнительнаяЗапись,
	|	НЕОПРЕДЕЛЕНО КАК Дополнительно,
	|	&Проведен КАК Проведен,
	|	&ПометкаУдаления КАК ПометкаУдаления,
	|	НЕОПРЕДЕЛЕНО КАК ДатаПервичногоДокумента,
	|	НЕОПРЕДЕЛЕНО КАК НомерПервичногоДокумента,
	|	&Валюта КАК Валюта,
	|	НЕОПРЕДЕЛЕНО КАК Договор,
	|	НЕОПРЕДЕЛЕНО КАК НаправлениеДеятельности,
	|	&Период КАК ДатаОтраженияВУчете,
	|	СУММА(ЕСТЬNULL(ДанныеТабличнойЧастиРасходыПриУСН.СуммаРасходов, 0)) КАК Сумма,
	|	&Исправление КАК СторноИсправление,
	|	&СторнируемыйДокумент КАК СторнируемыйДокумент,
	|	&ИсправляемыйДокумент КАК ИсправляемыйДокумент,
	|	ВЫРАЗИТЬ(ДанныеДокумента.Комментарий КАК СТРОКА(100)) КАК Комментарий,
	|	НЕОПРЕДЕЛЕНО КАК Приоритет
	|ИЗ
	|	Документ.ВводОстатковРасходовПриУСН КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВводОстатковРасходовПриУСН.РасходыПриУСН КАК ДанныеТабличнойЧастиРасходыПриУСН
	|		ПО ДанныеДокумента.Ссылка = ДанныеТабличнойЧастиРасходыПриУСН.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокумента.Ссылка,
	|	ВЫРАЗИТЬ(ДанныеДокумента.Комментарий КАК СТРОКА(100))";
	
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
	
	ВводОстатковЛокализация.ВводОстатковРасходовПриУСНДобавитьКомандыПечати(КомандыПечати);
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
КонецПроцедуры

#КонецОбласти


#КонецОбласти

#КонецЕсли
