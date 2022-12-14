#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Собирает структуру из текстов запросов для дальнейшей проверки даты запрета.
// 
// Параметры:
// 	Запрос - Запрос - Запрос по проверке даты запрета, можно установить параметры
// Возвращаемое значение:
// 	Структура - см. ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов
Функция ТекстЗапросаКонтрольДатыЗапрета(Запрос) Экспорт
	ИмяРегистра = Метаданные.РегистрыНакопления.ПрочаяВыручка.Имя;
	ИмяТаблицыИзменений = "ТаблицаИзмененийПрочаяВыручка"; 
	СтруктураТекстовЗапросов = ПроведениеДокументов.ШаблонТекстЗапросаКонтрольДатыЗапрета(Запрос, 
		ИмяРегистра, 
		ИмяТаблицыИзменений, 
		"ФинансовыйКонтур");
	Возврат СтруктураТекстовЗапросов

КонецФункции

// Формирует тексты запросов для контроля изменений записанных движений регистров.
//
// Параметры:
//  Запрос - Запрос - запрос, хранящий параметры используемые в списке запросов
//  ТекстыЗапроса - СписокЗначений - список текстов запросов и их имен.
//  Документ - ДокументОбъект - записываемый документ.
//
Процедура ИнициализироватьДанныеКонтроляИзменений(Запрос, ТекстыЗапроса, Документ) Экспорт
	
КонецПроцедуры

// Выводит сообщения пользователю при наличии ошибок контроля изменений записанных движений регистров.
//
// Параметры:
//  РезультатыКонтроля - Структура - таблицы с результатами контроля изменений
//  Документ - ДокументОбъект - записываемый документ
//  Отказ - Булево - признак отказа от проведения документа.
//
Процедура СообщитьОРезультатахКонтроляИзменений(РезультатыКонтроля, Документ, Отказ) Экспорт
	
КонецПроцедуры

//++ НЕ УТКА

// Заполняет параметры отражения движений регистра в финансовом учете
//
// Возвращаемое значение:
// 	см. МеждународныйУчетПоДаннымОстаточныхФинансовыхРегистров.ПараметрыОтраженияДвиженийВФинансовомУчете
//
Функция ПараметрыОтраженияДвиженийВФинансовомУчете() Экспорт
	
	ПараметрыОтражения = МеждународныйУчетПоДаннымОстаточныхФинансовыхРегистров.ПараметрыОтраженияДвиженийВФинансовомУчете();
	ПараметрыОтражения.ПутьКДаннымОбъектНастройки = "СтатьяДоходов.ГруппаФинансовогоУчета";
	ПараметрыОтражения.ПутьКДаннымНаправлениеДеятельности = "НаправлениеДеятельности";
	ПараметрыОтражения.ПутьКДаннымПодразделение = "Подразделение";
	ПараметрыОтражения.ПутьКДаннымМестоУчета = "Подразделение";
	ПараметрыОтражения.РесурсыУпр.Добавить("ВыручкаБезНДСУпр");
	ПараметрыОтражения.РесурсыУпр.Добавить("НДСУпр");
	ПараметрыОтражения.РесурсыРегл.Добавить("ВыручкаБезНДСРегл");
	ПараметрыОтражения.РесурсыРегл.Добавить("НДСРегл");
	ПараметрыОтражения.РесурсыКоличество.Добавить("Количество");
	
	МетаданныеРегистра = СоздатьНаборЗаписей().Метаданные();
	МеждународныйУчетПоДаннымОстаточныхФинансовыхРегистров.ЗаполнитьПараметрыОтраженияПоМетаданнымРегистра(ПараметрыОтражения, МетаданныеРегистра);
	
	Возврат ПараметрыОтражения;
	
КонецФункции

//-- НЕ УТКА

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Партнер)
	|	И ЗначениеРазрешено(Подразделение)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.ПрочаяВыручка.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.5.87";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("d263ad40-15e2-4aa4-a0a2-1127ff0a6d42");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.ПрочаяВыручка.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновляет движения документов информационной базы по регистру накопления ""Прочая выручка"".
	|До завершения обработчика работа с документами не рекомендуется, т.к. информация в регистре некорректна.';
	|en = 'Updates movement of documents of the infobase on the ""Revenue — Services and Assets"" accumulation register.
	|Before completion of the handler, work with documents is not recommended, because Information in the register is incorrect.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыНакопления.ПрочаяВыручка.ПолноеИмя());
	//++ НЕ УТ
	//++ Локализация
	Читаемые.Добавить(Метаданные.Документы.ОтражениеЗарплатыВФинансовомУчете.ПолноеИмя());
	//-- Локализация
	//-- НЕ УТ
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.ПрочаяВыручка.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	//++ НЕ УТ
	//++ Локализация
	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "ИнтеграцияБЗК.ОтражениеЗарплатыВФинансовомУчете_ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";
	//-- Локализация
	//-- НЕ УТ

КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеРегистра = СоздатьНаборЗаписей().Метаданные();
	ПолноеИмяРегистра = МетаданныеРегистра.ПолноеИмя();
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Период УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Период УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();
	
	Регистраторы = Новый Массив;
//++ Локализация
//++ НЕ УТ
	Запрос =  Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|		Документ.Ссылка КАК Регистратор
	|	ИЗ
	|		Документ.ОтражениеЗарплатыВФинансовомУчете КАК Документ
	|	ГДЕ
	|		Документ.Проведен
	|		И ИСТИНА В
	|			(ВЫБРАТЬ ПЕРВЫЕ 1
	|				ИСТИНА
	|			ИЗ
	|				РегистрНакопления.ПрочаяВыручка КАК ПрочаяВыручка
	|			ГДЕ
	|				ПрочаяВыручка.Регистратор = Документ.Ссылка)
	|";
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
//-- НЕ УТ
//-- Локализация
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);

КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	Параметры.ОбработкаЗавершена = Истина; //Для УТ 11 обработка не требуется

//++ Локализация

//++ НЕ УТ	
	МетаданныеРегистра = СоздатьНаборЗаписей().Метаданные();
	ПолноеИмяРегистра = МетаданныеРегистра.ПолноеИмя();
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Для Каждого Выборка Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Регистратор = Выборка.Регистратор;// ДокументСсылка - 
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Регистратор);
			Блокировка.Заблокировать();
			
			НаборЗаписей = СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Регистратор);
			
			ДвиженияПрочаяВыручка = Неопределено;
			
			МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Регистратор);
			ДанныеДляПроведения = МенеджерДокумента.ДанныеДокументаДляПроведения(Регистратор, МетаданныеРегистра.Имя);
			ДанныеДляПроведения.Свойство("ТаблицаПрочаяВыручка", ДвиженияПрочаяВыручка); // ТаблицаЗначений -
			
			Если ДвиженияПрочаяВыручка <> Неопределено Тогда
				НаборЗаписей.Загрузить(ДвиженияПрочаяВыручка);
			КонецЕсли;
			
			Если НаборЗаписей.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			Шаблон = НСтр("ru = 'Не удалось записать данные в регистр %1 по регистратору ""%2"", по причине: %3';
							|en = 'Cannot save data to the register %1 for recorder ""%2"". Reason: %3'");
			ТекстСообщения = 
				СтрШаблон(Шаблон,
					ПолноеИмяРегистра,
					Регистратор,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеРегистра,
				,
				ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
		
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
//-- НЕ УТ	

//-- Локализация

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли