////////////////////////////////////////////////////////////////////////////////
// Модуль содержит клиент-серверные методы, используемые для управления договорами
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс
// Функция формирует структуру описания связанного договора
// 
// Возвращаемое значение:
//  Структура - Описание связанного договора.
//
Функция ОписаниеСвязанногоДоговора() Экспорт
	
	Возврат Новый Структура("ВидСвязи,БазовыйДоговор,ПодчиненныйДоговор");
	
КонецФункции

Функция РеквизитыВерсииСоглашенияСтрокой(Номер, Дата) Экспорт
	
	// Версия 123 от 08.12.1999
	
	Слова = Новый Массив;
	Слова.Добавить(НСтр("ru = 'Версия'"));
	Если ЗначениеЗаполнено(Номер) Тогда
		Слова.Добавить(СокрЛП(Номер));
	КонецЕсли;
	Если ЗначениеЗаполнено(Дата) Тогда
		Слова.Добавить(СтрШаблон(НСтр("ru = 'от %1'"), Формат(Дата, "ДЛФ=D")));
	КонецЕсли;
	
	Возврат СтрСоединить(Слова, " ");
	
КонецФункции

Функция ЭтоВалютныйДоговорМСФО(ДоговорОбъект) Экспорт

	Если ДоговорОбъект.ВидДоговораУХ = ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.ВалютныйСвоп")
		ИЛИ ДоговорОбъект.ВидДоговораУХ = ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.РасчетныйВалютныйФорвард")
		ИЛИ ДоговорОбъект.ВидДоговораУХ = ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.ПоставочныйВалютныйФорвард")
		ИЛИ ДоговорОбъект.ВидДоговораУХ = ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.ВалютноПроцентныйСвоп") Тогда
		// инструменты валютные по своей сути.
		Возврат Истина;
	КонецЕсли;
	
	Организация = ДоговорОбъект.Организация;
	
	ВалютаВзаиморасчетов = ?(ДоговорОбъект.ВидДоговораУХ = ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.ПроцентныйСвоп"),
							ДоговорОбъект.ВалютаОрганизации,
							ДоговорОбъект.ВалютаВзаиморасчетов);
	
	Если Не ЗначениеЗаполнено(Организация) ИЛИ Не ЗначениеЗаполнено(ВалютаВзаиморасчетов) Тогда
		// Не с чем сравнивать.
		Возврат Ложь;
	Иначе
		
		ФункциональнаяВалюта = ОбщегоНазначенияУХ.ПолучитьЗначениеРеквизита(Организация, "ФункциональнаяВалюта");
		Возврат (ВалютаВзаиморасчетов <> ФункциональнаяВалюта);
		
	КонецЕсли;
		
КонецФункции // ЭтоВалютныйДоговорМСФО()

Функция ВидыДоговоровСПоставщиком() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.СПоставщиком"));
	Результат.Добавить(ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.ВвозИзЕАЭС"));
	Результат.Добавить(ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.Импорт"));
	Результат.Добавить(ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.СПереработчиком"));
	Результат.Добавить(ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.СПоклажедателем"));
	Результат.Добавить(ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.РасчетноКассовоеОбслуживание"));
	
	Возврат Результат;
	
КонецФункции

Функция ВидыДоговоровСПокупателем() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.СПокупателем"));
	Результат.Добавить(ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.СДавальцем"));
	Результат.Добавить(ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.СХранителем"));
	
	Возврат Результат;
	
КонецФункции

Функция ВидыДоговоровЛизинг() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.ЛизингПолученный"));
	
	Возврат Результат;
	
КонецФункции

Функция ВидыДоговоровПроизводныеИструменты() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.ВалютноПроцентныйСвоп"));
	Результат.Добавить(ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.ВалютныйСвоп"));
	Результат.Добавить(ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.ПоставочныйВалютныйФорвард"));
	Результат.Добавить(ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.ПроцентныйСвоп"));
	Результат.Добавить(ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.РасчетныйВалютныйФорвард"));
	
	Возврат Результат;
	
КонецФункции

Функция ЭтоДоговорСПоставщиком(ВидДоговораУХ) Экспорт
	
	Возврат (ВидыДоговоровСПоставщиком().Найти(ВидДоговораУХ) <> Неопределено);
	
КонецФункции

Функция ЭтоДоговорСПокупателем(ВидДоговораУХ) Экспорт
	
	Возврат (ВидыДоговоровСПокупателем().Найти(ВидДоговораУХ) <> Неопределено);

КонецФункции

Функция ЕстьЗеркалированиеДоговора(ВидДоговораУХ) Экспорт 

	ВстречныйВидДоговора = УправлениеДоговорамиУХКлиентСерверПовтИсп.ПолучитьВстречныйВидДоговораУХ(ВидДоговораУХ);
	
	Возврат ЗначениеЗаполнено(ВстречныйВидДоговора);

КонецФункции

Процедура ПроверитьИзменитьДатуВерсииСоглашения(ЭтоПерваяВерсия, ДатаНачалаДействия, ДатаВерсииСоглашения) Экспорт
	
	Если Не ЭтоПерваяВерсия Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаНачалаДействия) И ДатаВерсииСоглашения > ДатаНачалаДействия Тогда
		ДатаВерсииСоглашения = ДатаНачалаДействия;
	КонецЕсли;
	
КонецПроцедуры

Функция НовыйИменаКлючевыхРеквизитов() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("ДатаНачалаДействия");
	Результат.Вставить("ДатаОкончанияДействия");
	Результат.Вставить("Сумма");
	
	Возврат Результат;
	
КонецФункции

Функция ОтборВерсийСоглашений(Объект) Экспорт
	
	Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ГрафикРасчетовСПокупателемПоставщиком") Тогда
		Отбор = Новый Структура("ОбъектРасчетов", Объект.ОбъектРасчетов);
	Иначе
		Отбор = Новый Структура("ДоговорКонтрагента", Объект.ДоговорКонтрагента);
	КонецЕсли;
	
	Возврат Отбор;
КонецФункции

// Проверяет необходимость формировать платежные позиции по графику
//
// Параметры:
//  Объект	 - ДокументСсылка.ВерсияСоглашенияКоммерческийДоговор и ост. - документ для которого проверяется необходимость формировать позиции по графику
// 
// Возвращаемое значение:
//   - Булево
//
Функция ФормироватьПозицииЗаявокПоГрафику(Объект) Экспорт
	
	Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ВерсияСоглашенияКоммерческийДоговор") Тогда
		Возврат Объект.ПорядокРасчетов = ПредопределенноеЗначение("Перечисление.ПорядокРасчетов.ПоДоговорамКонтрагентов")
			И Объект.СпособФормированияПлатежей = ПредопределенноеЗначение("Перечисление.СпособыФормированияПлатежейПоДоговору.ПоГрафикуПлатежей")
			И Объект.РежимИспользованияГрафика = ПредопределенноеЗначение("Перечисление.РежимыИспользованияГрафика.КонтрольЛимитовИСозданиеПозиций");
	Иначе		
		Возврат Объект.РежимИспользованияГрафика = ПредопределенноеЗначение("Перечисление.РежимыИспользованияГрафика.КонтрольЛимитовИСозданиеПозиций");
	КонецЕсли;

КонецФункции	

Функция ОперацияГрафикаПоИмениКолонки(ИмяКолонки, ОписаниеГрафика) Экспорт
	
	Для Каждого Элемент Из ОписаниеГрафика Цикл
		
		Секция = Элемент.Значение;
		Если ВРЕГ(Секция.КолонкаПриход) = ВРЕГ(ИмяКолонки) Тогда
			
			Возврат Секция.КолонкаПриходОперация;
			
		ИначеЕсли ВРЕГ(Секция.КолонкаРасход) = ВРЕГ(ИмяКолонки) Тогда
			
			Возврат Секция.КолонкаРасходОперация;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#Область ОбработчикиСобытийМодуляМенеджера

Процедура ОбработкаПолученияПолейПредставленияВерсияСоглашения(Поля, СтандартнаяОбработка) Экспорт

	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("НомерДополнительногоСоглашения");
	Поля.Добавить("ДоговорКонтрагента");
	Поля.Добавить("Номер");
	Поля.Добавить("Дата");
	Поля.Добавить("Проведен");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставленияВерсияСоглашения(Данные, Представление, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Если Данные.Проведен Тогда
		ШаблонПредставления = НСтр("ru = '[ДоговорКонтрагента] (вер. [НомерДополнительногоСоглашения] от [Дата])'");
	Иначе
		ШаблонПредставления = НСтр("ru = '[ДоговорКонтрагента] (сохраненный черновик от [Дата])'")
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("ДоговорКонтрагента", Данные.ДоговорКонтрагента);
	Параметры.Вставить("НомерДополнительногоСоглашения", Данные.НомерДополнительногоСоглашения);
	Параметры.Вставить("Дата", Формат(Данные.Дата, "ДЛФ=DT"));

	Представление = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонПредставления, Параметры);
	
КонецПроцедуры

#КонецОбласти

// Процедура - Заполняет дату отсчета проверки ковенантов
//
// Параметры:
//  Объект						 - ДокументОбъект.ВерсияСоглашенияКредит 
//  ДатаНачалаДействияДоговора	 - Дата - дата начала действия договора контрагента 
//
Процедура ЗаполнитьДатуОтсчетаПроверкиКовенантов(Объект, ДатаНачалаДействияДоговора) Экспорт
	Если НЕ ЗначениеЗаполнено(Объект.ДатаОтсчетаПроверкиКовенантов) ИЛИ Объект.ДатаОтсчетаПроверкиКовенантов < ДатаНачалаДействияДоговора Тогда
		ОбщегоНазначенияКлиентСерверУХ.УстановитьНовоеЗначение(Объект.ДатаОтсчетаПроверкиКовенантов, ДатаНачалаДействияДоговора);
	КонецЕсли;
КонецПроцедуры	

Функция ДоступенГрафикРасчетовВерсияСоглашенияКредит(ВидДоговораУХ) Экспорт
	 Возврат (ВидДоговораУХ <> ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.Овердрафт"));
КонецФункции	

Функция ПроверитьЗаполнениеУсловийФинансовогоИнструмента(Форма) Экспорт

	Объект = Форма.Объект;
	
	Возврат НЕ Объект.ВидСоглашения = ПредопределенноеЗначение("Перечисление.ВидыСоглашений.РамочныйДоговор")
		И ЗначениеЗаполнено(Объект.ДатаНачалаДействия) И ЗначениеЗаполнено(Объект.ДатаОкончанияДействия)
		И ЗначениеЗаполнено(Объект.Сумма);
	
КонецФункции

 
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
