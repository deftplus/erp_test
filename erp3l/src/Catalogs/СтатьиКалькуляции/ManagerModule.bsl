#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП.
//
// Возвращаемое значение:
//	Массив - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	Результат = Новый Массив;
	Результат.Добавить("ТипЗатрат");
	Результат.Добавить("Идентификатор");
	Возврат Результат;
КонецФункции

// Определяет настройки начального заполнения элементов
//
// Параметры:
//  Настройки - Структура - настройки заполнения:
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Истина;
	
КонецПроцедуры

// Вызывается при начальном заполнении справочника.
//
// Параметры:
//  КодыЯзыков - Массив - список языков конфигурации. Актуально для мультиязычных конфигураций.
//  Элементы   - ТаблицаЗначений - данные заполнения. Состав колонок соответствует набору реквизитов
//                                 справочника.
//  ТабличныеЧасти - Структура - Ключ - Имя табличной части объекта.
//                               Значение - Выгрузка в таблицу значений пустой табличной части.
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	#Область ПолуфабрикатыПроизводимыеВПроцессе
	Элемент = Элементы.Добавить(); // СправочникОбъект.СтатьиКалькуляции - 
	Элемент.ИмяПредопределенныхДанных = "ПолуфабрикатыПроизводимыеВПроцессе";
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Элемент, "Наименование", "ru = 'Полуфабрикаты производимые в процессе';
		|en = 'Semi-finished products manufactured in the process.'", КодыЯзыков); // @НСтр
	Элемент.ТипЗатрат = Перечисления.ТипыЗатрат.Материальные;
	Элемент.РеквизитДопУпорядочивания = 0;
	Элемент.Идентификатор = "ПолуфабрикатыПроизводимыеВПроцессе";
	#КонецОбласти
//++ НЕ УТКА
	#Область РазбираемыеИзделия
	Элемент = Элементы.Добавить(); // СправочникОбъект.СтатьиКалькуляции -
	Элемент.ИмяПредопределенныхДанных = "РазбираемыеИзделия";
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Элемент, "Наименование", "ru = 'Разбираемые изделия';
		|en = 'Products being disassembled'", КодыЯзыков); // @НСтр
	Элемент.ТипЗатрат = Перечисления.ТипыЗатрат.Материальные;
	Элемент.РеквизитДопУпорядочивания = 0;
	Элемент.Идентификатор = "РазбираемыеИзделия";
	#КонецОбласти

	#Область РемонтируемыеИзделия
	Элемент = Элементы.Добавить(); // СправочникОбъект.СтатьиКалькуляции -
	Элемент.ИмяПредопределенныхДанных = "РемонтируемыеИзделия";
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Элемент, "Наименование", "ru = 'Ремонтируемые изделия';
		|en = 'Products under R&M'", КодыЯзыков); // @НСтр
	Элемент.ТипЗатрат = Перечисления.ТипыЗатрат.Материальные;
	Элемент.РеквизитДопУпорядочивания = 0;
	Элемент.Идентификатор = "РемонтируемыеИзделия";
	#КонецОбласти
//-- НЕ УТКА
КонецПроцедуры


// Вызывается при начальном заполнении создаваемого элемента.
//
// Параметры:
//  Объект                  - СправочникОбъект.СтатьиКалькуляции - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения.
//  ДополнительныеПараметры - Структура - Дополнительные параметры.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка, Метаданные.Справочники.СтатьиКалькуляции);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность		
КонецПроцедуры

#КонецЕсли

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьКлиентСервер.ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьКлиентСервер.ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Справочники.СтатьиКалькуляции.ЗаполнитьЭлементыНачальнымиДанными";
	Обработчик.Версия = "2.5.5.51";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("88b7b505-0814-4ffe-bc6e-3896452e16b4");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.СтатьиКалькуляции.ЗарегистрироватьПредопределенныеЭлементыДляОбновления";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновление наименований предопределенных элементов.
	|До завершения обработки наименования этих элементов в ряде случаев будет отображаться некорректно.';
	|en = 'Updates the names of predefined items.
	|While the update is in progress, names of predefined items might be displayed incorrectly.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Справочники.СтатьиКалькуляции.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Справочники.СтатьиКалькуляции.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Справочники.СтатьиКалькуляции.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "МультиязычностьСервер.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "Любой";

КонецПроцедуры

Процедура ЗарегистрироватьПредопределенныеЭлементыДляОбновления(Параметры) Экспорт
	
	ОбновлениеИнформационнойБазыУТ.ЗарегистрироватьПредопределенныеЭлементыДляОбновления(Параметры, Метаданные.Справочники.СтатьиКалькуляции);
	
КонецПроцедуры

Процедура ЗаполнитьЭлементыНачальнымиДанными(Параметры) Экспорт
	
	ОбновлениеИнформационнойБазыУТ.ЗаполнитьЭлементыНачальнымиДанными(Параметры, Метаданные.Справочники.СтатьиКалькуляции, Ложь, "Наименование");
	
КонецПроцедуры

// Заполняет идентификатор и тип затрат предопределенной статьи калькуляции.
// 
// Возвращаемое значение:
// 	Булево
Функция НастроитьСтатьюКалькуляцииПредопределенныхЭлементов() Экспорт
	
	МетаданныеОбъекта = Метаданные.Справочники.СтатьиКалькуляции;
	ПолноеИмяОбъекта  = МетаданныеОбъекта.ПолноеИмя();
	
	СписокСтатей = Новый Массив;
	СписокСтатей.Добавить("ПолуфабрикатыПроизводимыеВПроцессе");
//++ НЕ УТКА
	СписокСтатей.Добавить("РазбираемыеИзделия");
	СписокСтатей.Добавить("РемонтируемыеИзделия");
//-- НЕ УТКА

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СтатьиКалькуляции.Ссылка КАК Ссылка,
	|	СтатьиКалькуляции.ВерсияДанных КАК ВерсияДанных
	|ИЗ
	|	Справочник.СтатьиКалькуляции КАК СтатьиКалькуляции
	|ГДЕ
	|	СтатьиКалькуляции.Идентификатор = """"
	|	И СтатьиКалькуляции.ТипЗатрат = ЗНАЧЕНИЕ(Перечисление.ТипыЗатрат.ПустаяСсылка)
	|	И СтатьиКалькуляции.ИмяПредопределенныхДанных В (&СписокСтатей)
	|");
	Запрос.УстановитьПараметр("СписокСтатей", СписокСтатей);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			Блокировка.Добавить(ПолноеИмяОбъекта).УстановитьЗначение("Ссылка", Выборка.Ссылка);
			Блокировка.Заблокировать();
			
			Объект = Выборка.Ссылка.ПолучитьОбъект(); // СправочникОбъект.СтатьиКалькуляции - 
			
			Если Объект <> Неопределено И Объект.ВерсияДанных = Выборка.ВерсияДанных Тогда
				
				Если Не ЗначениеЗаполнено(Объект.Идентификатор) Тогда
					Объект.Идентификатор = Объект.ИмяПредопределенныхДанных;
				КонецЕсли;
				
				Если Не ЗначениеЗаполнено(Объект.ТипЗатрат) Тогда
					Объект.ТипЗатрат = Перечисления.ТипыЗатрат.Материальные;
				КонецЕсли;
				
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать элемент: %Ссылка% по причине: %Причина%';
									|en = 'Cannot process the item: %Ссылка%. Reason: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеОбъекта,
				Выборка.Ссылка,
				ТекстСообщения);
			Продолжить;
		КонецПопытки;
		
	КонецЦикла;
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьРеквизитДопУпорядочиванияГруппСтатейДоходов() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СтатьиКалькуляции.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СтатьиКалькуляции КАК СтатьиКалькуляции
	|ГДЕ
	|	СтатьиКалькуляции.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	СтатьиКалькуляции.Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		Объект = Выборка.Ссылка.ПолучитьОбъект(); // СправочникОбъект.СтатьиКалькуляции
		ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка);
		НастройкаПорядкаЭлементов.ЗаполнитьЗначениеРеквизитаУпорядочивания(Объект, Ложь);
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
	КонецЦикла;
КонецПроцедуры

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли
