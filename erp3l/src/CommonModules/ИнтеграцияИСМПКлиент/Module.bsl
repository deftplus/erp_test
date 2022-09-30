#Область ПрограммныйИнтерфейс

#Область ОбменДанными

// Выполняет подготовку к передаче в сервис ИС МП сообщения по документу и начинает процедуру обмена
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма
//  ПараметрыОбработкиДокументов - (См. ИнтеграцияИСМПСлужебныйКлиентСервер.ПараметрыОбработкиДокументов)
//  ОповещениеПриЗавершении - ОписаниеОповещения - Оповещение при завершении операции
Процедура ПодготовитьКПередаче(Форма, ПараметрыОбработкиДокументов, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	ОчиститьСообщения();
	
	ВходящиеДанные = Новый Массив;
	ВходящиеДанные.Добавить(ПараметрыОбработкиДокументов);
	
	РезультатОбмена = ИнтеграцияИСМПВызовСервера.ПодготовитьКПередаче(
		ВходящиеДанные,
		Форма.УникальныйИдентификатор);
	
	ИнтеграцияИСМПСлужебныйКлиент.ОбработатьРезультатОбмена(
		РезультатОбмена, Форма, Неопределено, ОповещениеПриЗавершении);
	
КонецПроцедуры

// Выполняет подготовку к передаче в сервис ИС МП сообщения по документу и начинает процедуру обмена
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма
//  ПараметрыЗагрузки - Структура - Структура со свойствами:
//   * Организация - ОпределяемыйТип.Организация - Организация
//   * Интервал - Структура - Структура со свойствами:
//     ** НачалоПериода - Дата - Дата начала периода.
//     ** КонецПериода - Дата - Дата окончания периода.
//  ОповещениеПриЗавершении - ОписаниеОповещения - Оповещение при завершении операции
Процедура ЗагрузитьВходящиеДокументы(Форма, ПараметрыЗагрузки, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	ОчиститьСообщения();
	
	РезультатОбмена = ИнтеграцияИСМПВызовСервера.ЗагрузитьВходящиеДокументы(
		ПараметрыЗагрузки,
		Форма.УникальныйИдентификатор);
	
	ИнтеграцияИСМПСлужебныйКлиент.ОбработатьРезультатОбмена(
		РезультатОбмена, Форма, Неопределено, ОповещениеПриЗавершении);
	
КонецПроцедуры

// Выполняет отправку подготовленных сообщений, загрузку новых документов, обработку ответов из ИС МП.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - источник команды выполнения обмена
//  Организация - Неопределено, Массив, ОпределяемыйТип.Организация - Организация или несколько организаций,
//                                                                    по которым необходимо выполнить обмен.
//  ОповещениеПриЗавершении - ОписаниеОповещения - Оповещение при завершении операции.
Процедура ВыполнитьОбмен(Форма, Организация = Неопределено, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	ОчиститьСообщения();
	
	РезультатОбмена = ИнтеграцияИСМПВызовСервера.ВыполнитьОбмен(
		Организация,
		Форма.УникальныйИдентификатор);
	
	ИнтеграцияИСМПСлужебныйКлиент.ОбработатьРезультатОбмена(
		РезультатОбмена, Форма,, ОповещениеПриЗавершении);
	
КонецПроцедуры

// Отменяет последнюю операцию (например, если возникла ошибка передачи данных).
//
// Параметры:
//   ДокументСсылка - ДокументСсылка - документ, по которому требуется отменить операцию.
//
Процедура ОтменитьПоследнююОперацию(ДокументСсылка) Экспорт
	
	Изменения = ИнтеграцияИСМПВызовСервера.ОтменитьПоследнююОперацию(ДокументСсылка);
	
	Если Изменения <> Неопределено Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Контекст",                ДокументСсылка);
		ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", Неопределено);
		
		ИнтеграцияИСМПСлужебныйКлиент.ПослеЗавершенияОбмена(
			Изменения,
			ДополнительныеПараметры);
		
	Иначе
		
		ИнтеграцияИСМПВызовСервера.ВосстановитьСтатусДокументаПоДаннымПротоколаОбмена(ДокументСсылка);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон(
				НСтр("ru = 'Операция отмены не может быть выполнена для документа %1 по причине нарушения внутренней структуры хранения данных.
				           |Выполнена операция восстановления статуса по данным протокола обмена.';
				           |en = 'Операция отмены не может быть выполнена для документа %1 по причине нарушения внутренней структуры хранения данных.
				           |Выполнена операция восстановления статуса по данным протокола обмена.'"),
				ДокументСсылка));
		
	КонецЕсли;
	
КонецПроцедуры

// Удаляет неотправленную операцию из очереди передачи данных в ИС МП.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - документ, по которому требуется отменить передачу данных.
//
Процедура ОтменитьПередачу(ДокументСсылка) Экспорт
	
	Изменения = ИнтеграцияИСМПВызовСервера.ОтменитьПередачу(ДокументСсылка);
	
	Если Изменения <> Неопределено Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Контекст",                ДокументСсылка);
		ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", Неопределено);
		
		ИнтеграцияИСМПСлужебныйКлиент.ПослеЗавершенияОбмена(
			Изменения,
			ДополнительныеПараметры);
		
	Иначе
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтрШаблон(
				НСтр("ru = 'Операция отмены не может быть выполнена для документа %1 по причине нарушения внутренней структуры хранения данных.
				           |Выполнена операция восстановления статуса по данным протокола обмена.';
				           |en = 'Операция отмены не может быть выполнена для документа %1 по причине нарушения внутренней структуры хранения данных.
				           |Выполнена операция восстановления статуса по данным протокола обмена.'"),
				ДокументСсылка));
		
	КонецЕсли;
	
КонецПроцедуры

Функция ОрганизацииДляОбмена(Форма) Экспорт
	
	Организации = Форма.Организации.ВыгрузитьЗначения();
	Если Организации.Количество() = 0 Тогда
		Возврат Неопределено;
	ИначеЕсли Организации.Количество() = 1 Тогда
		Возврат Организации[0];
	Иначе
		Возврат Организации;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область РаботаВСпискахДокументов

// Обработчик команд по выполнению требуемого дальнейшего действия в динамических списках.
//
// Параметры:
//  ДинамическийСписок - ТаблицаФормы - список в котором выполняется команда.
//  ДальнейшееДействие - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - действие, которое будет выполнено.
Процедура ПодготовитьСообщенияКПередаче(ДинамическийСписок, ДальнейшееДействие) Экспорт
	
	ОчиститьСообщения();
	
	Контекст = ИнтеграцияИСКлиент.СтруктураПодготовкиСообщенийКПередаче(
		ДинамическийСписок, ДальнейшееДействие,
		Новый ОписаниеОповещения("ПодготовитьСообщенияКПередачеЗавершение", ЭтотОбъект));
	
	ИменаКолонокДальнейшиеДействия = Новый Массив;
	ИменаКолонокДальнейшиеДействия.Добавить("ДальнейшееДействиеИСМП1");
	ИменаКолонокДальнейшиеДействия.Добавить("ДальнейшееДействиеИСМП2");
	ИменаКолонокДальнейшиеДействия.Добавить("ДальнейшееДействиеИСМП3");
	ИнтеграцияИСКлиент.ОпределитьДоступностьДействий(
		Контекст, ИменаКолонокДальнейшиеДействия, "Организация");
	
	ИнтеграцияИСКлиент.ПодготовитьСообщенияКПередаче(Контекст);
	
КонецПроцедуры

// Обработчик завершения процедуры ПодготовитьСообщенияКПередаче.
//
// Параметры:
//  Контекст - Структура - контекст выполнения обработчика:
//   * МассивДокументов - массив - список ссылок на обрабатываемые документы,
//   * НепроведенныеДокументы - массив - документы, исключенные из обработки,
//   * ДинамическийСписок - ТаблицаФормы - список в котором выполняется команда,
//   * ДальнейшееДействие - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - действие, которое будет выполнено.
//  ДополнительныеПараметры - Структура, Неопределено - Дополнительные параметры
Процедура ПодготовитьСообщенияКПередачеЗавершение(Контекст, ДополнительныеПараметры = Неопределено) Экспорт
	
	ОчиститьСообщения();
	
	ВходящиеДанные = Новый Массив;
	Для Каждого ДокументСсылка Из Контекст.МассивДокументов Цикл
		
		ПараметрыОбработкиДокументов = ИнтеграцияИСМПСлужебныйКлиентСервер.ПараметрыОбработкиДокументов();
		ПараметрыОбработкиДокументов.Ссылка             = ДокументСсылка;
		ПараметрыОбработкиДокументов.Организация        = Контекст.РеквизитыДокументов[ДокументСсылка].Организация;
		ПараметрыОбработкиДокументов.ДальнейшееДействие = Контекст.ДальнейшееДействие;
		
		ВходящиеДанные.Добавить(ПараметрыОбработкиДокументов);
		
	КонецЦикла;
	
	Форма = Неопределено;
	Если ТипЗнч(Контекст) = Тип("Структура")
		И Контекст.Свойство("ДинамическийСписок")
		И ТипЗнч(Контекст.ДинамическийСписок) = Тип("ТаблицаФормы") Тогда
		Форма = ИнтеграцияИСКлиент.ПолучитьФормуПоЭлементуФормы(Контекст.ДинамическийСписок);
	КонецЕсли;
	
	РезультатОбмена = ИнтеграцияИСМПВызовСервера.ПодготовитьКПередаче(
		ВходящиеДанные,
		Форма.УникальныйИдентификатор);
	
	ИнтеграцияИСМПСлужебныйКлиент.ОбработатьРезультатОбмена(
		РезультатОбмена, Форма, Неопределено);
	
КонецПроцедуры

// Выполняет архивирование документов.
// 
// Параметры:
// 	Результат - КодВозвратаДиалога - Ответ на вопрос архивирования.
// 	ДополнительныеПараметры - Структура - Структура дополнительных параметров.
//
Процедура АрхивироватьДокументы(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	Изменения = ИнтеграцияИСМПВызовСервера.АрхивироватьДокументы(
		ДополнительныеПараметры.ДокументыКАрхивированию);
	
	Если Изменения <> Неопределено Тогда
		
		ИнтеграцияИСМПСлужебныйКлиент.ПослеЗавершенияОбмена(
			Изменения, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет архивирование распоряжений к оформлению.
// 
// Параметры:
// 	Результат - КодВозвратаДиалога - Ответ на вопрос архивирования.
// 	ДополнительныеПараметры - Структура - Структура дополнительных параметров.
//
Процедура АрхивироватьРаспоряжения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	Изменения = ИнтеграцияИСМПВызовСервера.АрхивироватьРаспоряженияКОформлению(
		ДополнительныеПараметры.Распоряжения,
		ДополнительныеПараметры.ПустаяСсылка);
	
	Если Изменения <> Неопределено Тогда
		
		ИнтеграцияИСМПСлужебныйКлиент.ПослеЗавершенияОбмена(
			Изменения, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

//Выполняет команду создания документа, с предварительным выбором вида продукции или способа ввода в оборот.
//
Процедура ОткрытьФормуСозданияДокумента(ПолноеИмяДокумента, ДокументОснование = Неопределено, Владелец = Неопределено, ОписаниеОповещения = Неопределено) Экспорт
	
	ПараметрыОбъектаВыбора = ПараметрыИнтерактивногоВыбораОтбораЗаполнения(ПолноеИмяДокумента, ДокументОснование);
	
	Если ПараметрыОбъектаВыбора.ОбъектыДляВыбора.Количество() > 1 Тогда
		
		ПараметрыВыбораИзСписка = Новый Структура;
		ПараметрыВыбораИзСписка.Вставить("ОбъектыДляВыбора",   ПараметрыОбъектаВыбора.ОбъектыДляВыбора);
		ПараметрыВыбораИзСписка.Вставить("ПолноеИмяДокумента", ПолноеИмяДокумента);
		ПараметрыВыбораИзСписка.Вставить("ДокументОснование",  ДокументОснование);
		ПараметрыВыбораИзСписка.Вставить("Владелец",           Владелец);
		ПараметрыВыбораИзСписка.Вставить("ОписаниеОповещения", ОписаниеОповещения);
		ПараметрыВыбораИзСписка.Вставить("ИмяФильтра",         ПараметрыОбъектаВыбора.ИмяФильтра);
		
		ИнтеграцияИСКлиент.ВыбратьИзСпискаИОткрытьФормуСозданияДокумента(ПараметрыВыбораИзСписка);
		
	Иначе
		
		ИнтеграцияИСКлиент.ОткрытьФормуСозданияДокумента(ПолноеИмяДокумента, ДокументОснование, Владелец, ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область РаботаВФормахДокументов

#Область Сертификация

Функция НастройкиРаботыССертификацией() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Кэш", "КэшСертификации");
	Результат.Вставить("ТаблицаФормы", "Товары");
	Результат.Вставить("Номенклатура", "Номенклатура");
	Результат.Вставить("Сертификация", "ТоварыСертификация");
	Возврат Результат;
	
КонецФункции

Процедура ОбновитьСписокВыбораСертификации(Форма, НастройкиРаботыССертификацией = Неопределено) Экспорт
	
	Если НастройкиРаботыССертификацией = Неопределено Тогда
		НастройкиРаботыССертификацией = НастройкиРаботыССертификацией();
	КонецЕсли;
	
	ТекущиеДанные = Форма.Элементы[НастройкиРаботыССертификацией.ТаблицаФормы].ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	КэшСертификации = Форма[НастройкиРаботыССертификацией.Кэш];
	Номенклатура = ТекущиеДанные[НастройкиРаботыССертификацией.Номенклатура];
	ЭлементСертификация = Форма.Элементы[НастройкиРаботыССертификацией.Сертификация];
	
	ЭлементСертификация.СписокВыбора.Очистить();
	Для Каждого СтрокаКэша Из КэшСертификации Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаКэша.Номенклатура) Или Номенклатура = СтрокаКэша.Номенклатура Тогда
			ЭлементСертификация.СписокВыбора.Добавить(СтрокаКэша.Представление);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПервичныйДокумент

Функция НастройкиРаботыСПервичнымДокументом() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Кэш", "КэшПервичныхДокументов");
	Результат.Вставить("ТаблицаФормы", "Товары");
	Результат.Вставить("ПричинаПеремаркировки", "ПричинаПеремаркировки");
	Результат.Вставить("ПервичныйДокумент", "ТоварыПредставлениеПервичногоДокумента");
	Возврат Результат;
	
КонецФункции

Процедура ОбновитьСписокВыбораПервичногоДокумента(Форма, НастройкиРаботыСПервичнымДокументом = Неопределено) Экспорт
	
	Если НастройкиРаботыСПервичнымДокументом = Неопределено Тогда
		НастройкиРаботыСПервичнымДокументом = НастройкиРаботыСПервичнымДокументом();
	КонецЕсли;
	
	ТекущиеДанные = Форма.Элементы[НастройкиРаботыСПервичнымДокументом.ТаблицаФормы].ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьПричинуПеремаркировки = НастройкиРаботыСПервичнымДокументом.Свойство("ПричинаПеремаркировки");
	Если ИспользоватьПричинуПеремаркировки Тогда
		ПричинаПеремаркировки = ТекущиеДанные[НастройкиРаботыСПервичнымДокументом.ПричинаПеремаркировки];
	КонецЕсли;
	
	Кэш = Форма[НастройкиРаботыСПервичнымДокументом.Кэш];
	ЭлементПервичныйДокумент = Форма.Элементы[НастройкиРаботыСПервичнымДокументом.ПервичныйДокумент];
	
	ЭлементПервичныйДокумент.СписокВыбора.Очистить();
	Для Каждого СтрокаКэша Из Кэш Цикл
		
		Если Не ИспользоватьПричинуПеремаркировки
			Или ИнтеграцияИСМПКлиентСервер.СоответствиеПричинПеремаркировкиПервичногоДокумента(
			СтрокаКэша.ПричинаПеремаркировки,
			ПричинаПеремаркировки) Тогда
				
			ЭлементПервичныйДокумент.СписокВыбора.Добавить(
				Формат(Кэш.Индекс(СтрокаКэша), "ЧРД=; ЧН=0; ЧГ=0;"), СтрокаКэша.ПредставлениеПервичногоДокумента);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОтборПоОрганизации

Процедура ОткрытьФормуВыбораОрганизаций(Форма, Префикс, Префиксы = Неопределено, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Организации", Форма.Организации.ВыгрузитьЗначения());
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма",                   Форма);
	ДополнительныеПараметры.Вставить("Префикс",                 Префикс);
	ДополнительныеПараметры.Вставить("Префиксы",                Префиксы);
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	ОткрытьФорму(
		"ОбщаяФорма.ФормаВыбораСпискаОрганизацийИСМП",
		ПараметрыОткрытияФормы,
		Форма,,,,
		Новый ОписаниеОповещения("ПослеЗавершенияВыбораОрганизаций", ЭтотОбъект, ДополнительныеПараметры));
	
КонецПроцедуры

Процедура ПослеЗавершенияВыбораОрганизаций(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма             = ДополнительныеПараметры.Форма;
	СписокОрганизаций = Результат.Организации;
	ПрименятьОтбор    = ДополнительныеПараметры.ОповещениеПриЗавершении = Неопределено;
	
	Если Результат.СохраненыНастройки Тогда
		Форма.ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам();
	КонецЕсли;
	
	ОбработатьВыборОрганизаций(Форма, СписокОрганизаций, ПрименятьОтбор,
		ДополнительныеПараметры.Префикс, ДополнительныеПараметры.Префиксы);
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, СписокОрганизаций);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьВыборОрганизаций(Форма, Результат, ПрименятьОтбор, Префикс = Неопределено, Префиксы = Неопределено) Экспорт
	
	ИнтеграцияИСКлиентСервер.НастроитьОтборПоОрганизации(Форма, Результат, Префикс, Префиксы);
	
	Если ПрименятьОтбор Тогда
		ОрганизацияОтборПриИзменении(Форма);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОрганизацияОтборПриИзменении(Форма)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Список") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Форма.Список,
			"Организация", Форма.Организации, ВидСравненияКомпоновкиДанных.ВСписке,,Форма.Организации.Количество() > 0);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "СписокКОформлению") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Форма.СписокКОформлению,
			"Организация", Форма.Организации, ВидСравненияКомпоновкиДанных.ВСписке,, Форма.Организации.Количество() > 0);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОтветственныеЗаАктуализациюТокеновАвторизации

// Подключает обработчик ожидания для показа напоминаний ответственному за актуализацию токенов авторизации.
//
Процедура ПодключитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации() Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если Не ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ИнтеграцияИСМПВызовСервера.ИспользуетсяМаркируемаяПродукция() Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбновлениеНастроекОтветственногоЗаАктуализациюТокеновАвторизации();
	
	ПодключитьОбработчикОжидания("ОбработчикОжиданияВыполнитьОбновлениеНастроекОтветственногоЗаАктуализациюТокеновАвторизации", 3600);
	
КонецПроцедуры

// Выполняет обновление настроек ответственного за актуализацию токенов авторизации ИСМП.
// Настройки содержатся в глобальной переменной ПараметрыПриложения.
// 
// Параметры:
//  ДляПросмотра - Булево - определяет для чего нужно получить настройки:
//                          для просмотра списка токенов или для актуализации токенов.
//
Процедура ВыполнитьОбновлениеНастроекОтветственногоЗаАктуализациюТокеновАвторизации(ДляПросмотра = Ложь) Экспорт
	
	Настройки = ИнтеграцияИСМПВызовСервера.НастройкиОтветственногоЗаАктуализациюТокеновАвторизации(ДляПросмотра);
	
	ИмяПараметраНастроек = ИмяПараметраНастроекОтветственногоЗаАктуализациюТокеновАвторизации();
	
	ТекущиеНастройки = ПараметрыПриложения[ИмяПараметраНастроек];
	
	Если Настройки.Количество() = 0 Тогда
		Если ТекущиеНастройки <> Неопределено Тогда
			ПараметрыПриложения.Удалить(ИмяПараметраНастроек);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ТребуетсяПроверкаНапоминаний = Ложь;
	Для Каждого Настройка Из Настройки Цикл
		Если Настройка.ВремяОповещения > 0 Тогда
			ТребуетсяПроверкаНапоминаний = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПодключитьПроверкуНапоминаний = Ложь;
	Если ТекущиеНастройки = Неопределено Тогда
		ПодключитьПроверкуНапоминаний = ТребуетсяПроверкаНапоминаний;
		НастройкиОтветственного = Новый Структура;
		НастройкиОтветственного.Вставить("Настройки",                    Настройки);
		НастройкиОтветственного.Вставить("ОткрытаФормаПросмотра",        Ложь);
		НастройкиОтветственного.Вставить("ОткрытаФормаАктуализации",     Ложь);
		НастройкиОтветственного.Вставить("ТребуетсяПроверкаНапоминаний", ТребуетсяПроверкаНапоминаний);
		НастройкиОтветственного.Вставить("ВремяСледующейПроверки",       Дата(1,1,1));
		ПараметрыПриложения.Вставить(ИмяПараметраНастроек, НастройкиОтветственного);
	Иначе
		ПодключитьПроверкуНапоминаний = ТребуетсяПроверкаНапоминаний
			И Не ТекущиеНастройки.ТребуетсяПроверкаНапоминаний
			И Не ТекущиеНастройки.ОткрытаФормаПросмотра;
		ПараметрыПриложения[ИмяПараметраНастроек].Настройки                    = Настройки;
		ПараметрыПриложения[ИмяПараметраНастроек].ТребуетсяПроверкаНапоминаний = ТребуетсяПроверкаНапоминаний;
		ПараметрыПриложения[ИмяПараметраНастроек].ВремяСледующейПроверки       = Дата(1,1,1);
	КонецЕсли;
	
	Если ПодключитьПроверкуНапоминаний Тогда
		ПодключитьОбработчикОжидания("ОбработчикОжиданияПроверитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации", 60);
	КонецЕсли;
	
	Если ТекущиеНастройки <> Неопределено
		И ТребуетсяПроверкаНапоминаний Тогда
		ПроверитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации();
	КонецЕсли;
	
КонецПроцедуры

// Проверяет наличие напоминаний для ответственного за актуализацию токенов авторизации ИС МП.
// При необходимости, открывает форму актуализации токенов авторизации ИС МП.
//
Процедура ПроверитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации() Экспорт
	
	ИмяПараметраНастроек    = ИмяПараметраНастроекОтветственногоЗаАктуализациюТокеновАвторизации();
	ИмяПараметраНапоминаний = ИмяПараметраНапоминанийОтветственногоЗаАктуализациюТокеновАвторизации();
	
	НастройкиОтветственного = ПараметрыПриложения[ИмяПараметраНастроек];
	ТекущиеНапоминания      = ПараметрыПриложения[ИмяПараметраНапоминаний];
	
	Если НастройкиОтветственного = Неопределено
		Или Не НастройкиОтветственного.ТребуетсяПроверкаНапоминаний
		И Не НастройкиОтветственного.ОткрытаФормаПросмотра Тогда
		
		ОтключитьОбработчикОжидания("ОбработчикОжиданияПроверитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации");
		
		Если ТекущиеНапоминания <> Неопределено Тогда
			ПараметрыПриложения.Удалить(ИмяПараметраНапоминаний);
		КонецЕсли;
		
		Если НастройкиОтветственного <> Неопределено
			И НастройкиОтветственного.ОткрытаФормаАктуализации Тогда
			ОткрытьФормуАктуализацииТокеновАвторизации();
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	ДатаСеанса = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	Если Не НастройкиОтветственного.ОткрытаФормаПросмотра
		И НастройкиОтветственного.ТребуетсяПроверкаНапоминаний
		И НастройкиОтветственного.ВремяСледующейПроверки > ДатаСеанса Тогда
		Возврат;
	КонецЕсли;
	
	Напоминания = ИнтеграцияИСМПВызовСервера.ПолучитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации(НастройкиОтветственного.Настройки);
	
	Если ТекущиеНапоминания = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметраНапоминаний, Напоминания);
	Иначе
		ПараметрыПриложения[ИмяПараметраНапоминаний] = Напоминания;
	КонецЕсли;
	
	ТребуетсяАктуализация = Ложь;
	Если НастройкиОтветственного.ТребуетсяПроверкаНапоминаний Тогда
		
		ОповеститьЧерез       = 0;
		Для Каждого Напоминание из Напоминания Цикл
			Если Не Напоминание.ОповещениеИспользуется Тогда
				Продолжить;
			КонецЕсли;
			Если Напоминание.ТребуетсяАктуализация
				И Напоминание.ОповеститьЧерез = 0 Тогда
				ТребуетсяАктуализация = Истина;
				ОповеститьЧерез = 0;
				Прервать;
			КонецЕсли;
			Если Напоминание.ОповеститьЧерез > 0
				И (ОповеститьЧерез = 0
				Или Напоминание.ОповеститьЧерез < ОповеститьЧерез) Тогда
				ОповеститьЧерез = Напоминание.ОповеститьЧерез;
			КонецЕсли;
		КонецЦикла;
		
		Если ОповеститьЧерез > 0 Тогда
			ПараметрыПриложения[ИмяПараметраНастроек].ВремяСледующейПроверки = ДатаСеанса + ОповеститьЧерез;
		КонецЕсли;
		
	КонецЕсли;
		
	Если ТребуетсяАктуализация
		Или НастройкиОтветственного.ОткрытаФормаАктуализации Тогда
		ОткрытьФормуАктуализацииТокеновАвторизации();
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму актуализации токенов авторизации ИС МП
//
Процедура ОткрытьФормуАктуализацииТокеновАвторизации() Экспорт
	
	ИмяПараметра = "ИнтеграцияИСМП.ФормаАктуализацииТокеновАвторизации";
	
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		
		ИмяФормы = "РегистрСведений.ДанныеКлючаСессииИСМП.Форма.ФормаПросмотраИАктуализацииТокеновАвторизации";
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Актуализация", Истина);
		
		ПараметрыПриложения.Вставить(ИмяПараметра,
			ПолучитьФорму(ИмяФормы, ПараметрыФормы, , "Актуализация"));
		
	КонецЕсли;
	
	Форма = ПараметрыПриложения[ИмяПараметра];
	Форма.Открыть();
	
КонецПроцедуры

// Возвращает имя параметра, хранящего настройки ответственного за актуализацию токенов авторизации ИС МП.
// 
// Возвращаемое значение:
//  Строка - имя параметра.
//
Функция ИмяПараметраНастроекОтветственногоЗаАктуализациюТокеновАвторизации() Экспорт
	
	Возврат "ИнтеграцияИСМП.НастройкиОтветственногоЗаАктуализациюТокеновАвторизации";
	
КонецФункции

// Возвращает имя параметра, хранящего настройки ответственного за актуализацию токенов авторизации ИС МП.
// 
// Возвращаемое значение:
//  Строка - имя параметра.
//
Функция ИмяПараметраНапоминанийОтветственногоЗаАктуализациюТокеновАвторизации() Экспорт
	
	Возврат "ИнтеграцияИСМП.НапоминанияОтветственногоЗаАктуализациюТокеновАвторизации";
	
КонецФункции

#КонецОбласти

#Область ЧастичноеВыбытие

// Параметры открытия формы настройки частичного выбытия.
// 
// Возвращаемое значение:
//  Структура - Параметры открытия формы настройки частичного выбытия:
// * ФормаВладелец                   - ФормаКлиентскогоПриложения - Обязательный. Форма-владелец настройки.
// * РежимПросмотра                  - Булево                     - Открывает форму только для просмотра
// * Номенклатура                    - ОпределяемыйТип.Номенклатура - Номенклатура для настройки соответствий.
// * ЕдиницаХранения                 - ОпределяемыйТип.Упаковка     - Базовая единица хранения.
// * НаборУпаковок                   - ОпределяемыйТип.НаборУпаковокНоменклатурыИС - Набор упаковок, если используется.
// * УпаковкиВключены                - Булево  - Для номенклатуры упаковки используются и включены.
// * ДопустимоИспользованиеУпаковок         - Булево  - В конфигурации присутствует механизм упаковок.
// * ДопустимыУпаковкиМеньшеЕдиницыХранения - Булево  - Коэффициент упаковки может быть менее 1.
// * КарточкаТовараСодержитВесовойПризнак   - Булево  - Карточка товара содержит признак весового товара.
Функция ПараметрыОткрытияФормыНастройкиНоменклатуры() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	// Состояние
	ВозвращаемоеЗначение.Вставить("ФормаВладелец",      Неопределено);
	ВозвращаемоеЗначение.Вставить("РежимПросмотра",     Ложь);
	// Источник данных
	ВозвращаемоеЗначение.Вставить("Номенклатура",       Неопределено);
	ВозвращаемоеЗначение.Вставить("ВидПродукции",       Неопределено);
	ВозвращаемоеЗначение.Вставить("ЕдиницаХранения",    Неопределено);
	ВозвращаемоеЗначение.Вставить("НаборУпаковок",      Неопределено);
	ВозвращаемоеЗначение.Вставить("УпаковкиВключены",   Ложь);
	// Параметры конфигурации
	ВозвращаемоеЗначение.Вставить("ДопустимоИспользованиеУпаковок",         Истина);
	ВозвращаемоеЗначение.Вставить("ДопустимыУпаковкиМеньшеЕдиницыХранения", Истина);
	ВозвращаемоеЗначение.Вставить("КарточкаТовараСодержитВесовойПризнак",   Истина);
	ВозвращаемоеЗначение.Вставить("ДопустимаНастройкаЛогистическойЕдиницы", Истина);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Обработка действия гиперссылки настройки параметров номенклатуры.
// 
// Параметры:
//  ОповещениеОЗавершении      - ОписаниеОповещения - Оповещение о завершении настройки.
//  ПараметрыОбработкиДействия - см. ПараметрыОткрытияФормыНастройкиНоменклатуры.
Процедура ОбработкаДействияНастройкиНоменклатуры(ОповещениеОЗавершении, ПараметрыОбработкиДействия) Экспорт
	
	Если Не ЗначениеЗаполнено(ПараметрыОбработкиДействия.Номенклатура) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Настройка возможна только для сохраненной номенклатуры.';
										|en = 'Настройка возможна только для сохраненной номенклатуры.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ПараметрыОбработкиДействия);
	ПараметрыОткрытия.Удалить("ФормаВладелец");
	
	ОткрытьФорму(
		"ОбщаяФорма.ФормаНастройкиНоменклатурыИС",
		ПараметрыОткрытия,
		ПараметрыОбработкиДействия.ФормаВладелец,,,,
		ОповещениеОЗавершении);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаНавигационнойСсылкиВФормеДокументаОснования(Форма, Объект,
			Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, СобытиеОбработано = Ложь) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Форма",  Форма);
	Контекст.Вставить("Объект", Объект);
	Контекст.Вставить("ДокументОснование", Объект.Ссылка);
	Контекст.Вставить("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки);
	Контекст.Вставить("СобытиеОбработано", СобытиеОбработано);
	
	Если Форма.Модифицированность ИЛИ НЕ ЗначениеЗаполнено(Контекст.ДокументОснование) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения(
			"ОбработкаНавигационнойСсылкиВФормеДокументаОснованияЗавершение",
			ЭтотОбъект,
			Контекст);
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Документ ""%1"" %2. Записать?';
				|en = 'Документ ""%1"" %2. Записать?'"),
			Контекст.ДокументОснование,
			?(НЕ ЗначениеЗаполнено(Контекст.ДокументОснование), НСтр("ru = 'не записан';
																	|en = 'не записан'"), НСтр("ru = 'был изменен';
																								|en = 'был изменен'")));
		
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ВыполнитьКомандуГиперссылкиВФормеДокументаОснования(
			Контекст.ДокументОснование,
			НавигационнаяСсылкаФорматированнойСтроки,
			Форма,
			СобытиеОбработано);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаНавигационнойСсылкиВФормеДокументаОснованияЗавершение(РезультатВопроса, Контекст) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если Контекст.Объект.Проведен Тогда
		Если Контекст.Форма.ПроверитьЗаполнение() Тогда
			Контекст.Форма.Записать();
		КонецЕсли;
	Иначе
		Контекст.Форма.Записать();
	КонецЕсли;
	
	Если НЕ Контекст.Форма.Модифицированность И ЗначениеЗаполнено(Контекст.ДокументОснование) Тогда
		
		ВыполнитьКомандуГиперссылкиВФормеДокументаОснования(
			Контекст.ДокументОснование,
			Контекст.НавигационнаяСсылкаФорматированнойСтроки,
			Контекст.Форма,
			Контекст.СобытиеОбработано);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКомандуГиперссылкиВФормеДокументаОснования(ДокументОснование, НавигационнаяСсылкаФорматированнойСтроки, Форма, СобытиеОбработано)
	
	ОписаниеКоманды = ИнтеграцияИСКлиентСервер.ПреобразоватьИмяКомандыНавигационнойСсылкиВоВнутреннийФормат(
		НавигационнаяСсылкаФорматированнойСтроки);
	
	// Открытие протокола обмена
	Если ИнтеграцияИСКлиентСервер.ЭтоКомандаНавигационнойСсылкиОткрытьПротоколОбмена(ОписаниеКоманды) Тогда
		
		ОткрытьПротоколОбмена(ДокументОснование, Форма);
		
		СобытиеОбработано = Истина;
		Возврат;
		
	КонецЕсли;
	
	// Создание документа
	Если ИнтеграцияИСКлиентСервер.ЭтоКомандаНавигационнойСсылкиСоздатьОбъект(ОписаниеКоманды) Тогда
		
		ПолноеИмяДокумента = ИнтеграцияИСКлиентСервер.ИмяОбъектаДляОткрытияИзВнутреннегоФорматаКомандыНавигационнойСсылки(ОписаниеКоманды);
		
		ОткрытьФормуСозданияДокумента(ПолноеИмяДокумента, ДокументОснование, Форма);
		СобытиеОбработано = Истина;
		Возврат;
		
	КонецЕсли;
	
	// Открытие документа
	Если ИнтеграцияИСКлиентСервер.ЭтоКомандаНавигационнойСсылкиОткрытьОбъект(ОписаниеКоманды) Тогда
		
		ПолноеИмяДокумента   = ИнтеграцияИСКлиентСервер.ИмяОбъектаДляОткрытияИзВнутреннегоФорматаКомандыНавигационнойСсылки(ОписаниеКоманды);
		ЧастиИмениОбъекта    = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПолноеИмяДокумента, ".");
		ДокументыПоОснованию = ИнтеграцияИСМПВызовСервера.ДокументыИСМППоДокументуОснованию(ДокументОснование);
		МассивДокументов     = ДокументыПоОснованию[ЧастиИмениОбъекта[1]];
		
		Если МассивДокументов.Количество() = 1 Тогда
			ПоказатьЗначение(, МассивДокументов[0].Ссылка);
			СобытиеОбработано = Истина;
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	// Открытие формы резервирования кодов маркировки
	Если ИнтеграцияИСМПКлиентСервер.ЭтоКомандаНавигационнойСсылкиПулКодовМаркировки(ОписаниеКоманды) Тогда
		
		ПараметрыФормы = Новый Структура("Документ", ДокументОснование);
		
		Открытьформу(
			"РегистрСведений.ПулКодовМаркировкиСУЗ.Форма.ФормаРезервирования",
			ПараметрыФормы, Форма);
		
		СобытиеОбработано = Истина;
		
		Возврат;
		
	КонецЕсли;
	
	//открытие формы сверки кодов маркировки
	Если ИнтеграцияИСМПКлиентСервер.ЭтоКомандаНавигационнойСсылкиОткрытьФормуСверкиКодовМаркировки(ОписаниеКоманды) Тогда
		
		СверкаКодовМаркировкиИСМПКлиент.ОткрытьФормуРезультатовСверкиКодовМаркировки(Форма);
		
		СобытиеОбработано = Истина;
		
		Возврат;
		
	КонецЕсли;
	
	// Открытие произвольной навигационной ссылки
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки);
	
	СобытиеОбработано = Истина;
	
КонецПроцедуры

Функция ПараметрыИнтерактивногоВыбораОтбораЗаполнения(ПолноеИмяДокумента, ДокументОснование)
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ИмяФильтра");
	ВозвращаемоеЗначение.Вставить("ОбъектыДляВыбора");
	
	ВозвращаемоеЗначение.ИмяФильтра       = "ЗаполнениеСВидомПродукции";
	ВозвращаемоеЗначение.ОбъектыДляВыбора = ИнтеграцияИСМПВызовСервера.ВидыПродукцииДанныхЗаполнения(
		ПолноеИмяДокумента, ДокументОснование);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Процедура ОткрытьПротоколОбмена(Документ, Владелец = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура("Документ", Документ);
	
	ОткрытьФорму(
		"Справочник.ИСМППрисоединенныеФайлы.Форма.ФормаПротоколОбмена",
		ПараметрыФормы,
		Владелец,
		Новый УникальныйИдентификатор,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Возвращает пользовательское представление заголовка формы загрузки кодов маркировки
//
// Параметры:
//   Владелец         - ФормаКлиентскогоПриложения - источник вызова.
//   ДоступнаИерархия - Булево           - режим иерархической загрузки (из форм проверки и подбора).
//
// Возвращаемое значение:
//   Строка - заголовок
//
Функция ЗаголовокФормыЗагрузкиКодовМаркировки(Владелец, ДоступнаИерархия = Ложь) Экспорт
	
	ВозвращаемоеЗначение = НСтр("ru = 'Загрузка кодов маркировки';
								|en = 'Загрузка кодов маркировки'");
	Если Не ДоступнаИерархия
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Владелец.Объект, "Ссылка")
		И ЗначениеЗаполнено(Владелец.Объект.Ссылка) Тогда
		ВозвращаемоеЗначение = СтрШаблон(НСтр("ru = 'Загрузка кодов маркировки в %1';
												|en = 'Загрузка кодов маркировки в %1'"), Владелец.Объект.Ссылка);
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти