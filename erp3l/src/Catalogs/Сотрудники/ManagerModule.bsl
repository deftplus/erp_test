#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	СотрудникиВнутренний.ДобавитьКомандыПечати(КомандыПечати);
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - Массив - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати - СписокЗначений - значение - ссылка на объект;
//                                   представление - имя области, в которой был выведен объект (выходной параметр);
//  ПараметрыВывода - Структура - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	СотрудникиВнутренний.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Т
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОрганизацииВКоторыхРаботалиСотрудники КАК Т2 
	|	ПО Т2.Сотрудник = Т.Ссылка
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Т2.Организация)
	|	и ЗначениеРазрешено(Т.ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ПоискИУдалениеДублей

// См. ПоискИУдалениеДублейПереопределяемый.ПриОпределенииОбъектовСПоискомДублей
//
Функция ВозможностьЗаменыЭлементов(Знач ПарыЗамен, Знач Параметры = Неопределено) Экспорт
	
	Результат = Новый Соответствие;
	Для Каждого КлючЗначение Из ПарыЗамен Цикл
		
		ТекущаяСсылка = КлючЗначение.Ключ;
		ЦелеваяСсылка = КлючЗначение.Значение;
		
		Если ТекущаяСсылка = ЦелеваяСсылка Тогда
			Продолжить;
		КонецЕсли;
		
		// Исключение замен подработок головного сотрудника
		Если ТекущаяСсылка.ГоловнойСотрудник = ЦелеваяСсылка.ГоловнойСотрудник Тогда
			
			Ошибка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Нельзя менять подработки головного сотрудника ""%1"" на подработку ""%2""';
					|en = 'Сannot change side jobs of ""%1"" main employee to the ""%2"" side job'"),
				ТекущаяСсылка, ЦелеваяСсылка);
			
			Результат.Вставить(ТекущаяСсылка, Ошибка);
			
		// Исключение замены головных сотрудников на подработки и наоборот
		ИначеЕсли ТекущаяСсылка.ГоловнойСотрудник = ТекущаяСсылка И ЦелеваяСсылка <> ЦелеваяСсылка.ГоловнойСотрудник Тогда
			
			Ошибка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Нельзя менять основного сотрудника ""%1"" на подработку ""%2""';
					|en = 'Сannot change ""%1"" main employee to the ""%2"" side job'"),
				ТекущаяСсылка, ЦелеваяСсылка);
			
			Результат.Вставить(ТекущаяСсылка, Ошибка);
			
		ИначеЕсли ТекущаяСсылка.ГоловнойСотрудник <> ТекущаяСсылка И ЦелеваяСсылка = ЦелеваяСсылка.ГоловнойСотрудник Тогда
			
			Ошибка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Нельзя менять подработку ""%1"" на основного сотрудника ""%2""';
					|en = 'Сannot change the ""%1"" side job to ""%2"" main employee'"),
				ТекущаяСсылка, ЦелеваяСсылка);
			
			Результат.Вставить(ТекущаяСсылка, Ошибка);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// См. ПоискИУдалениеДублейПереопределяемый.ПриОпределенииОбъектовСПоискомДублей
//
Процедура ПараметрыПоискаДублей(ПараметрыПоиска, ДополнительныеПараметры = Неопределено) Экспорт
	
	Ограничение = Новый Структура;
	Ограничение.Вставить("Представление",      НСтр("ru = 'Являются подработками сотрудников.';
													|en = 'These are employee side jobs.'"));
	Ограничение.Вставить("ДополнительныеПоля", "ГоловнойСотрудник");
	ПараметрыПоиска.ОграниченияСравнения.Добавить(Ограничение);
	
	// Размер таблицы для передачи в обработчик.
	ПараметрыПоиска.КоличествоЭлементовДляСравнения = 100;
	
КонецПроцедуры

// См. ПоискИУдалениеДублейПереопределяемый.ПриОпределенииОбъектовСПоискомДублей
//
Процедура ПриПоискеДублей(ТаблицаКандидатов, ДополнительныеПараметры = Неопределено) Экспорт
	
	Для Каждого Вариант Из ТаблицаКандидатов Цикл
		Если Вариант.Поля1.ГоловнойСотрудник = Вариант.Ссылка2
			Или Вариант.Ссылка1 = Вариант.Поля2.ГоловнойСотрудник
			Или Вариант.Поля1.ГоловнойСотрудник = Вариант.Поля2.ГоловнойСотрудник Тогда
			
			Вариант.ЭтоДубли = Ложь;
		Иначе
			Вариант.ЭтоДубли = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПоискИУдалениеДублей

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	СотрудникиВнутренний.ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	СотрудникиВнутренний.ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
КонецПроцедуры

#КонецЕсли

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СотрудникиКлиентСервер.ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СотрудникиВызовСервера.ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция СтандартныйОтбор() Экспорт
	Возврат СотрудникиВнутренний.СтандартныйОтбор();
КонецФункции

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаФизическоеЛицоВШапке("ФизическоеЛицо", "Ссылка");
КонецФункции

#Область ОбработчикиПравилРегистрации

Процедура ЗарегистрироватьИзмененияПриОбработке(ИмяПланаОбмена, ПРО, Объект, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Выгрузка) Экспорт
	СинхронизацияДанныхЗарплатаКадры.ОграничитьРегистрациюОбъектаОтборомПоСотруднику(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Объект, Объект);
КонецПроцедуры

Процедура ЗарегистрироватьИзмененияПриОбработкеДоп(ИмяПланаОбмена, ПРО, Объект, Ссылка, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш) Экспорт
	СинхронизацияДанныхЗарплатаКадры.ОграничитьРегистрациюОбъектаОтборомПоСотруднику(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Объект, Ссылка);
КонецПроцедуры

Функция ПринадлежностиОбъекта() Экспорт
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("ГоловнаяОрганизация");
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПоследниеКадровыеПереводы(Сотрудники) Экспорт
	Возврат СотрудникиВнутренний.ПоследниеКадровыеПереводы(Сотрудники);
КонецФункции

#Область Печать

Процедура ДобавитьКомандуПечатиЛичнойКарточкиТ2(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Справочник.Сотрудники";
	КомандаПечати.Идентификатор = "ПФ_MXL_Т2";
	КомандаПечати.Представление = НСтр("ru = 'Личная карточка (Т-2)';
										|en = 'Employee data card (T-2)'");
	КомандаПечати.Порядок = 40;
	
КонецПроцедуры

Процедура ДобавитьКомандуПечатиПриказаОПриеме(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Справочник.Сотрудники";
	КомандаПечати.Идентификатор = "ПФ_MXL_Т1";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о приеме';
										|en = 'Hiring order'");
	КомандаПечати.Порядок = 10;
	КомандаПечати.Картинка = БиблиотекаКартинок.СторонняяПечатнаяФорма;
	КомандаПечати.ДополнительныеПараметры.Вставить("РеквизитыДетализации", "РаботаСотрудник");
	КомандаПечати.ДополнительныеПараметры.Вставить("СторонняяПечатнаяФорма", Истина);
	
КонецПроцедуры

Процедура ДобавитьКомандуПечатиПриказаОПереводе(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Справочник.Сотрудники";
	КомандаПечати.Идентификатор = "ПФ_MXL_Т5";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о переводе';
										|en = 'Transfer order'");
	КомандаПечати.Порядок = 20;
	КомандаПечати.Картинка = БиблиотекаКартинок.СторонняяПечатнаяФорма;
	КомандаПечати.ДополнительныеПараметры.Вставить("РеквизитыДетализации", "РаботаСотрудник");
	КомандаПечати.ДополнительныеПараметры.Вставить("СторонняяПечатнаяФорма", Истина);
	
КонецПроцедуры

Процедура ДобавитьКомандуПечатиПриказаОбУвольнении(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Справочник.Сотрудники";
	КомандаПечати.Идентификатор = "ПФ_MXL_Т8";
	КомандаПечати.Представление = НСтр("ru = 'Приказ об увольнении';
										|en = 'Dismissal order'");
	КомандаПечати.Порядок = 30;
	КомандаПечати.Картинка = БиблиотекаКартинок.СторонняяПечатнаяФорма;
	КомандаПечати.ДополнительныеПараметры.Вставить("РеквизитыДетализации", "РаботаСотрудник");
	КомандаПечати.ДополнительныеПараметры.Вставить("СторонняяПечатнаяФорма", Истина);
	
КонецПроцедуры

Процедура ДобавитьКомандуПечатиКарточкиУчетаСтраховыхВзносов(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Отчет.КарточкаУчетаПоСтраховымВзносам";
	КомандаПечати.Идентификатор = "КарточкаУчетаПоСтраховымВзносам";
	КомандаПечати.Представление = НСтр("ru = 'Карточка учета страховых взносов';
										|en = 'Record card of insurance contributions'");
	КомандаПечати.Порядок = 60;
	
КонецПроцедуры

Процедура ДобавитьКомандуПечатиРегистраНалоговогоУчетаПоНДФЛ(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Отчет.РегистрНалоговогоУчетаПоНДФЛ";
	КомандаПечати.Идентификатор = "ПечатьРегистрНалоговогоУчетаПоНДФЛПоСотруднику";
	КомандаПечати.Представление = НСтр("ru = 'Регистр налогового учета по НДФЛ';
										|en = 'PIT ledger'");
	КомандаПечати.Порядок = 60;
	
КонецПроцедуры

Процедура ДобавитьКомандуПечатиСогласияНаОбработкуПерсональныхДанных(КомандыПечати) Экспорт 
	
	Если ПравоДоступа("ИнтерактивноеДобавление", Метаданные.Документы.СогласиеНаОбработкуПерсональныхДанных) Тогда
		
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Идентификатор = "СогласиеНаОбработкуПерсональныхДанных";
		КомандаПечати.Представление = НСтр("ru = 'Согласие на обработку ПДн...';
											|en = 'Consent to personal data processing ...'");
		КомандаПечати.Обработчик = "СотрудникиКлиент.ОткрытьФормуСогласиеНаОбработкуПерсональныхДанных";
		КомандаПечати.Картинка = БиблиотекаКартинок.СторонняяПечатнаяФорма;
		КомандаПечати.ДополнительныеПараметры.Вставить("СторонняяПечатнаяФорма", Истина);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
