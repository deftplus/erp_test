#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция формирует временные данных документа
//
// Возвращаемое значение:
//	МенеджерВременныхТаблиц - менеджер временных таблиц.
//
Функция ВременныеТаблицыДанныхДокумента() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&Дата                                                     КАК Дата,
	|	&Организация                                              КАК Организация,
	|	&Сделка                                                   КАК Сделка,
	|	&Партнер                                                  КАК Партнер,
	|	Неопределено                                              КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	&Договор                                                  КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)                  КАК Валюта,
	|	&ХозяйственнаяОперация                                    КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО                                              КАК НалогообложениеНДС,
	|	ЛОЖЬ                                                      КАК ЕстьСделкиВТабличнойЧасти,
	|	ВЫБОР
	|		КОГДА СтруктураПредприятия.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоПодразделению)
	|				И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|			ТОГДА &Подразделение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|	КОНЕЦ                                                     КАК Подразделение,
	|	ВЫБОР
	|		КОГДА СтруктураПредприятия.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоМенеджерамПодразделения)
	|				И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|			ТОГДА &Менеджер
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	КОНЕЦ                                                     КАК Менеджер,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.ПродукцияДавальца)      КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|		ПО СтруктураПредприятия.Ссылка = &Подразделение
	|
	|ГДЕ
	|	Организации.Ссылка = &Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки                    КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура                   КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика                 КАК Характеристика,
	|	ТаблицаТоваров.Серия                		  КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий            КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры     КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Упаковка                       КАК Упаковка,
	|	ТаблицаТоваров.Количество                     КАК Количество,
	|	ТаблицаТоваров.Склад                          КАК Склад,
	|	ТаблицаТоваров.ЗаказДавальца                  КАК ЗаказДавальца,
	|	ТаблицаТоваров.КодСтроки                      КАК КодСтроки,
	|	ТаблицаТоваров.Назначение                     КАК Назначение
	|ПОМЕСТИТЬ ВтТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки                    КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура                   КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика                 КАК Характеристика,
	|	ТаблицаТоваров.Серия                		  КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий            КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры     КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Упаковка                       КАК Упаковка,
	|	ТаблицаТоваров.Количество                     КАК Количество,
	|	ТаблицаТоваров.Склад                          КАК Склад,
	|	ТаблицаТоваров.ЗаказДавальца                  КАК ЗаказДавальца,
	|	ТаблицаТоваров.КодСтроки                      КАК КодСтроки,
	|	ТаблицаТоваров.Назначение                     КАК Назначение,
	|	НЕОПРЕДЕЛЕНО                                  КАК ДокументРеализации,
	|	0                                             КАК Сумма,
	|	ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	0                                             КАК СуммаСНДС,
	|	0                                             КАК СуммаНДС,
	|	0                                             КАК СуммаВознаграждения,
	|	0                                             КАК СуммаНДСВознаграждения,
	|	&Сделка                                       КАК Сделка,
	|	ИСТИНА                                        КАК ПодбиратьВидыЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)   КАК НомерГТД
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	ВтТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки                КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.Упаковка                   КАК Упаковка,
	|	ТаблицаВидыЗапасов.ВидЗапасов                 КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД                   КАК НомерГТД,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)      КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.ЗаказДавальца              КАК ЗаказДавальца,
	|	ТаблицаВидыЗапасов.КодСтроки                  КАК КодСтроки,
	|	ТаблицаВидыЗапасов.Количество                 КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаВидыЗапасов.КоличествоПоРНПТ
	|	КОНЕЦ                                         КАК КоличествоПоРНПТ
	|ПОМЕСТИТЬ ВТВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки                КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.Упаковка                   КАК Упаковка,
	|	ТаблицаВидыЗапасов.ВидЗапасов                 КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД                   КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СкладОтгрузки              КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.ЗаказДавальца              КАК ЗаказДавальца,
	|	ТаблицаВидыЗапасов.КодСтроки                  КАК КодСтроки,
	|	ТаблицаВидыЗапасов.Количество                 КАК Количество,
	|	ТаблицаВидыЗапасов.КоличествоПоРНПТ           КАК КоличествоПоРНПТ,
	|	Аналитика.Номенклатура                        КАК Номенклатура,
	|	Аналитика.Характеристика                      КАК Характеристика,
	|	Аналитика.МестоХранения                       КАК Склад,
	|	&Сделка                                       КАК Сделка,
	|	Аналитика.Серия                               КАК Серия,
	|	&ВидыЗапасовУказаныВручную                    КАК ВидыЗапасовУказаныВручную
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВТВидыЗапасов КАК ТаблицаВидыЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Склад
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВтТаблицаТоваров
	|";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка",                          Ссылка);
	Запрос.УстановитьПараметр("Дата",                            Дата);
	Запрос.УстановитьПараметр("Организация",                     Организация);
	Запрос.УстановитьПараметр("Менеджер",                        Менеджер);
	Запрос.УстановитьПараметр("Договор",                         Договор);
	Запрос.УстановитьПараметр("Партнер",                         Партнер);
	Запрос.УстановитьПараметр("Подразделение",                   Подразделение);
	Запрос.УстановитьПараметр("Сделка",                          Справочники.СделкиСКлиентами.ПустаяСсылка());
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",           ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("ПередачаПоЗаказам",               ПередачаПоЗаказам);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную",       ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоПодразделениямМенеджерам", ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам"));
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоСделкам", ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоСделкам"));
	Запрос.УстановитьПараметр("РеализацияПоНесколькимЗаказам",   ПередачаПоЗаказам И Не ЗначениеЗаполнено(ЗаказДавальца));
	Запрос.УстановитьПараметр("ТаблицаТоваров",                  Товары);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов",              ВидыЗапасов);
	
	УчетПрослеживаемыхТоваровЛокализация.УстановитьПараметрыИспользованияУчетаПрослеживаемыхТоваров(Запрос);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

// Заполняет условия продаж в заказе клиента
//
// Параметры:
//	УсловияПродаж - Структура - Структура для заполнения.
//
Процедура ЗаполнитьУсловияПродаж(Знач УсловияПродаж) Экспорт
	
	Если УсловияПродаж = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Валюта
	
	Если ЗначениеЗаполнено(УсловияПродаж.Валюта) И ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		Валюта = УсловияПродаж.Валюта;
	КонецЕсли;
	
	// Организация и банковский счет организации
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		
		Если ЗначениеЗаполнено(УсловияПродаж.Организация) И Организация.Пустая() Тогда
			
			Организация = УсловияПродаж.Организация;

			СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
			СтруктураПараметров.Организация = Организация;

			БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Контрагент
	
	Если Не УсловияПродаж.Типовое Тогда
		
		Если ЗначениеЗаполнено(УсловияПродаж.Контрагент) И УсловияПродаж.Контрагент <> Контрагент Тогда
			Контрагент = УсловияПродаж.Контрагент;
		КонецЕсли;
		
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
	// Контактное лицо
	
	Если Не УсловияПродаж.Типовое Тогда
		
		Если ЗначениеЗаполнено(УсловияПродаж.КонтактноеЛицо) И Не ЗначениеЗаполнено(КонтактноеЛицо) Тогда
			КонтактноеЛицо = УсловияПродаж.КонтактноеЛицо;
		КонецЕсли;
		
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Партнер, КонтактноеЛицо);
	
	// Договор и Банковские счета
	
	Если УсловияПродаж.ИспользуютсяДоговорыКонтрагентов <> Неопределено И УсловияПродаж.ИспользуютсяДоговорыКонтрагентов Тогда
		
		ХозяйственнаяОперацияДоговора = Перечисления.ХозяйственныеОперации.ПроизводствоИзДавальческогоСырья;
		Параметрыобъекта = ПараметрыОбъектаССоглашением();
		
		Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(
			Параметрыобъекта,
			ХозяйственнаяОперацияДоговора);
		
		ПродажиСервер.ЗаполнитьБанковскиеСчетаПоДоговору(
			Договор,
			БанковскийСчетОрганизации,
			БанковскийСчетКонтрагента);
		
	КонецЕсли;
	
	// Склад и ответственные
	
	Если ЗначениеЗаполнено(УсловияПродаж.Склад) И Склад.Пустая() Тогда
		
		Склад = УсловияПродаж.Склад;
		
		СтруктураОтветственного = ПродажиСервер.ПолучитьОтветственногоПоСкладу(Склад);
		Если СтруктураОтветственного <> Неопределено Тогда
			Отпустил          = СтруктураОтветственного.Ответственный;
			ОтпустилДолжность = СтруктураОтветственного.ОтветственныйДолжность;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия продаж по умолчанию в заказе клиента
//
Процедура ЗаполнитьУсловияПродажПоУмолчанию() Экспорт
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		
		ПараметрыОтбора = Новый Структура("ИсключитьГруппыСкладовДоступныеВЗаказах, ВыбранноеСоглашение, ХозяйственныеОперации", 
			Истина, 
			Справочники.СоглашенияСКлиентами.ПустаяСсылка(), 
			ХозяйственнаяОперация);
		
		УсловияПродажПоУмолчанию = ПродажиСервер.ПолучитьУсловияПродажПоУмолчанию(
			Партнер,
			ПараметрыОтбора);
		
		Если УсловияПродажПоУмолчанию <> Неопределено Тогда
			
			ЗаполнитьУсловияПродаж(УсловияПродажПоУмолчанию);
			
			СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
			СтруктураПараметров.Организация    		= Организация;
			СтруктураПараметров.БанковскийСчет		= БанковскийСчетОрганизации;

			БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
			
		Иначе
			
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
			
		КонецЕсли;
		
		БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент, , БанковскийСчетКонтрагента);
		
	КонецЕсли;
	
	// Доставка
	ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Партнер, КонтактноеЛицо);
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеДоставкой") Тогда
		АдресДоставки = ФормированиеПечатныхФорм.ПолучитьАдресИзКонтактнойИнформации(Партнер);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	#Область Округление
		
	ПараметрыОкругления = Документы.ПередачаДавальцу.ПараметрыТЧДляОкругления();
	НоменклатураСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи, ПараметрыОкругления["Товары"]);
			
	#КонецОбласти	
	
	СуммаДокумента = 0;
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект,Документы.ПередачаДавальцу));
	
	ОбщегоНазначенияУТ.ИзменитьПризнакСогласованностиДокумента(
		ЭтотОбъект,
		РежимЗаписи);
	
	Если ПередачаПоЗаказам И ЗначениеЗаполнено(ЗаказДавальца) Тогда
		
		Для Каждого ТекСтрока Из Товары Цикл
			
			Если Не ЗначениеЗаполнено(ТекСтрока.ЗаказДавальца) Тогда
				ТекСтрока.ЗаказДавальца = ЗаказДавальца;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(
			ХозяйственнаяОперация,
			Склад,
			Подразделение,
			Партнер);
		
		// Если Склад - группа, то для аналитики учета номенклатуры склад берем из ТЧ
		ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
		Если Склад.ЭтоГруппа И Склад.ВыборГруппы = Перечисления.ВыборГруппыСкладов.РазрешитьВЗаказахИНакладных Тогда
			ИменаПолей.Вставить("Произвольный", "Склад");
		КонецЕсли;
		
		РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(
			Товары,
			МестаУчета,
			ИменаПолей);
		
		ЗаполнитьВидыЗапасов(Отказ);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "Товары,ВидыЗапасов");
	
	ПередачаДавальцуЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

	Если Не ЗначениеЗаполнено(Автор) И ЭтоНовый() Тогда
		Автор = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("МассивЗаказов") Тогда
			ЗаполнитьДокументПоПараметрам(ДанныеЗаполнения);
		Иначе
			ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
		КонецЕсли;
		
	КонецЕсли;
	
	ПередачаДавальцуЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	ОтветственныеЛицаСервер.ЗаполнитьМенеджера(ЭтотОбъект, Ложь);
	ДополнительныеСвойства.Вставить("НеобходимостьЗаполненияКассыПриФОИспользоватьНесколькоКассЛожь",   Ложь);
	ДополнительныеСвойства.Вставить("НеобходимостьЗаполненияСчетаПриФОИспользоватьНесколькоСчетовЛожь", Ложь);
	
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
	Если Не ЗначениеЗаполнено(Менеджер) Тогда
		Менеджер = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыПроверкиКоличества = Документы.ПередачаДавальцу.ПараметрыТЧДляОкругления();
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(
		ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверкиКоличества["Товары"]);
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(
		ЭтотОбъект,
		МассивНепроверяемыхРеквизитов,
		Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ПередачаДавальцу),
		Отказ,
		МассивНепроверяемыхРеквизитов);
	
	ДоставкаТоваров.ПроверитьЗаполнениеРеквизитовДоставки(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ, Истина);
	
	Для ТекИндекс = 0 По Товары.Количество() - 1 Цикл
		
		Если ПередачаПоЗаказам И
			Не ЗначениеЗаполнено(ЗаказДавальца) И
			Не ЗначениеЗаполнено(Товары[ТекИндекс].ЗаказДавальца) Тогда
			
			ТекстОшибки = НСтр("ru = 'Не заполнено поле ""Заказ давальца"" в строке %НомерСтроки% списка ""Выпущенная продукция""';
								|en = '""Material provider order"" is required in line %НомерСтроки% of the ""Released products"" list'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", Товары[ТекИндекс].НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", Товары[ТекИндекс].НомерСтроки, "ЗаказДавальца"),
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Код строки должен быть заполнен, если реализация по заказу
	Если Не ПередачаПоЗаказам Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КодСтроки");
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам") Тогда
		ПроверяемыеРеквизиты.Добавить("Подразделение");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ПередачаДавальцуЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ДоставкаТоваров.ОтразитьСостояниеДоставки(Ссылка, Отказ);
	
	ПередачаДавальцуЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ДополнительныеСвойства.Вставить("ПараметрыЗаполненияВидовЗапасов", ПараметрыЗаполненияВидовЗапасов());
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ДоставкаТоваров.ОтразитьСостояниеДоставки(Ссылка, Отказ, Истина);
	
	ПередачаДавальцуЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Согласован					= Ложь;
	ЗаказДавальца				= Неопределено;
	ХозяйственнаяОперация		= Метаданные.Документы.ПередачаДавальцу.Реквизиты.ХозяйственнаяОперация.ЗначениеЗаполнения;
	ПередачаПоЗаказам			= Ложь;
	ВидыЗапасовУказаныВручную	= Ложь;
	
	Для Каждого СтрТЧ Из Товары Цикл
		
		СтрТЧ.ЗаказДавальца = Неопределено;
		СтрТЧ.КодСтроки = 0;
		
	КонецЦикла;
	
	Серии.Очистить();
	ВидыЗапасов.Очистить();
	
	ИнициализироватьДокумент();
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "Товары,ВидыЗапасов");
	
	ПередачаДавальцуЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ПередачаДавальцуЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	Префикс = ОбщегоНазначенияУТПовтИсп.ДополнительныйПрефиксНумератораДокументыРеализацииТоваров();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьДокументПоПараметрам(СтруктураЗаполнения)
	
	МассивЗаказов = СтруктураЗаполнения.МассивЗаказов;
	
	ПараметрыЗаполнения = Документы.ПередачаДавальцу.ПараметрыЗаполненияДокумента();
	ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, СтруктураЗаполнения);
	Документы.ПередачаДавальцу.ИнициализироватьПараметрыЗаполнения(ПараметрыЗаполнения,
		СтруктураЗаполнения.РеквизитыШапки, МассивЗаказов);
	
	ТаблицаНакладная = Документы.ПередачаДавальцу.ДанныеТаблицыТоварыДокумента(ЭтотОбъект.Ссылка);
	
	Документы.ПередачаДавальцу.ЗаполнитьПоЗаказамОрдерам(ТаблицаНакладная, Ссылка, ПараметрыЗаполнения);
	
	Если ПараметрыЗаполнения.ЗаполнятьПоОрдеру Тогда
		КолонкаТаблицы = ТаблицаНакладная.Колонки.Количество; // КолонкаТаблицыЗначений
		КолонкаТаблицы.Имя        = "КоличествоДоИзменения";
		КолонкаТаблицы = ТаблицаНакладная.Колонки.КоличествоВОрдере; // КолонкаТаблицыЗначений
		КолонкаТаблицы.Имя = "Количество";
	Иначе
		КолонкаТаблицы = ТаблицаНакладная.Колонки.Количество; // КолонкаТаблицыЗначений
		КолонкаТаблицы.Имя        = "КоличествоДоИзменения";
		КолонкаТаблицы = ТаблицаНакладная.Колонки.КоличествоВЗаказе; // КолонкаТаблицыЗначений
		КолонкаТаблицы.Имя = "Количество";
	КонецЕсли;
	
	НакладныеСервер.УдалитьПустыеСтроки(ТаблицаНакладная, "Количество");
	
	Товары.Загрузить(ТаблицаНакладная);
	
	Документы.ПередачаДавальцу.ЗаполнитьШапкуДокументаПоЗаказу(ЭтотОбъект, ПараметрыЗаполнения, МассивЗаказов);
	
	Документы.ПередачаДавальцу.ОбновитьЗависимыеРеквизитыТабличнойЧасти(Товары, ПараметрыЗаполнения);
	
	ЗаполнитьУсловияПродажПоУмолчанию();
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Партнер") Тогда
		
		Партнер = ДанныеЗаполнения.Партнер;
		ЗаполнитьУсловияПродажПоУмолчанию();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Автор                     = Пользователи.ТекущийПользователь();
	Валюта                    = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(Валюта);
	Организация               = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
	СтруктураПараметров.Организация    		= Организация;
	СтруктураПараметров.БанковскийСчет		= БанковскийСчетОрганизации;

	БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
	
	БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент, , БанковскийСчетКонтрагента);
		
	Склад                     = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад, ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовПродажи"), Истина);
	ХозяйственнаяОперация     = Перечисления.ХозяйственныеОперации.ПередачаДавальцу;
	ПередачаПоЗаказам         = Истина; // Всегда только по заказам
	
	СтруктураОтветственного = ПродажиСервер.ПолучитьОтветственногоПоСкладу(Склад);
	Если СтруктураОтветственного <> Неопределено Тогда
		Отпустил              = СтруктураОтветственного.Ответственный;
		ОтпустилДолжность     = СтруктураОтветственного.ОтветственныйДолжность;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	ИменаРеквизитов = "Организация";
	
	Возврат ЗапасыСервер.ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц, Ссылка, ИменаРеквизитов);
	
КонецФункции

Функция ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаТоваров.Склад                      КАК Склад,
	|		ТаблицаТоваров.ЗаказДавальца              КАК ЗаказДавальца,
	|		ТаблицаТоваров.КодСтроки                  КАК КодСтроки,
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаТоваров.Упаковка                   КАК Упаковка,
	|		ТаблицаТоваров.Количество                 КАК Количество
	|	ИЗ
	|		ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВидыЗапасов.Склад                      КАК Склад,
	|		ТаблицаВидыЗапасов.ЗаказДавальца              КАК ЗаказДавальца,
	|		ТаблицаВидыЗапасов.КодСтроки                  КАК КодСтроки,
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаВидыЗапасов.Упаковка                   КАК Упаковка,
	|		-ТаблицаВидыЗапасов.Количество                КАК Количество
	|	ИЗ
	|		ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов) КАК ТаблицаТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.Склад,
	|	ТаблицаТоваров.ЗаказДавальца,
	|	ТаблицаТоваров.КодСтроки,
	|	ТаблицаТоваров.Упаковка,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаТоваров.Количество) <> 0");
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Возврат (Не Запрос.Выполнить().Пустой());
	
КонецФункции

Процедура ЗаполнитьСтрокуВидовЗапасов(СтрокаТоваров, СтруктураПоиска, Ресурсы)
	
	Для Каждого СтрокаЗапасов Из ВидыЗапасов.НайтиСтроки(СтруктураПоиска) Цикл
		
		Если СтрокаЗапасов.Количество = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		КоличествоПоСтроке = Мин(Ресурсы.КоличествоТоваровПоСтроке, СтрокаЗапасов.Количество);
		
		НоваяСтрока = ВидыЗапасов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
		
		НоваяСтрока.Упаковка			= СтрокаТоваров.Упаковка;
		НоваяСтрока.ЗаказДавальца		= СтрокаТоваров.ЗаказДавальца;
		НоваяСтрока.КодСтроки			= СтрокаТоваров.КодСтроки;
		НоваяСтрока.Количество			= КоличествоПоСтроке;
		НоваяСтрока.КоличествоПоРНПТ	= КоличествоПоСтроке * СтрокаЗапасов.КоличествоПоРНПТ / СтрокаЗапасов.Количество;
		
		Если Ресурсы.КоличествоТоваровПоСтроке = 0 Тогда
			НоваяСтрока.КоличествоУпаковок = 0;
		Иначе
			НоваяСтрока.КоличествоУпаковок = Ресурсы.КоличествоУпаковокПоСтроке * КоличествоПоСтроке
												/ Ресурсы.КоличествоТоваровПоСтроке;
		КонецЕсли;
		
		Ресурсы.КоличествоТоваровПоСтроке  = Ресурсы.КоличествоТоваровПоСтроке  - НоваяСтрока.Количество;
		Ресурсы.КоличествоУпаковокПоСтроке = Ресурсы.КоличествоУпаковокПоСтроке - НоваяСтрока.КоличествоУпаковок;
		
		СтрокаЗапасов.Количество		= СтрокаЗапасов.Количество - НоваяСтрока.Количество;
		СтрокаЗапасов.КоличествоПоРНПТ	= СтрокаЗапасов.КоличествоПоРНПТ - НоваяСтрока.КоличествоПоРНПТ;
		
		Если Ресурсы.КоличествоТоваровПоСтроке = 0 Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьДопКолонкиВидовЗапасов() Экспорт
	
	КолонкиГруппировок = "АналитикаУчетаНоменклатуры, Упаковка, ЗаказДавальца, КодСтроки";
	КолонкиСуммирования = "Количество, КоличествоУпаковок";
	
	ТаблицаТовары = Товары.Выгрузить(, КолонкиГруппировок + ", " + КолонкиСуммирования);
	ТаблицаТовары.Свернуть(КолонкиГруппировок, КолонкиСуммирования);
	
	СтруктураПоиска = Новый Структура("АналитикаУчетаНоменклатуры");
	
	Для Каждого СтрокаТоваров Из ТаблицаТовары Цикл
		
		Ресурсы = Новый Структура;
		Ресурсы.Вставить("КоличествоТоваровПоСтроке",  СтрокаТоваров.Количество);
		Ресурсы.Вставить("КоличествоУпаковокПоСтроке", СтрокаТоваров.КоличествоУпаковок);
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТоваров);
		ЗаполнитьСтрокуВидовЗапасов(СтрокаТоваров, СтруктураПоиска, Ресурсы);
		
	КонецЦикла;
	
	МассивУдаляемыхСтрок = ВидыЗапасов.НайтиСтроки(Новый Структура("Количество", 0));
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		ВидыЗапасов.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц		= ВременныеТаблицыДанныхДокумента();
	ПерезаполнитьВидыЗапасов	= ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
	
	Если Не Проведен
		Или ПерезаполнитьВидыЗапасов
		Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
		Или ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц) Тогда
		
		ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
		ПараметрыЗаполнения.ПодбиратьВТЧТоварыПринятыеНаОтветственноеХранение = "Никогда";
		
		ОтборыВидовЗапасов = ПараметрыЗаполнения.ОтборыВидовЗапасов;
		ОтборыВидовЗапасов.Организация = Организация;
		ОтборыВидовЗапасов.ВладелецТовара = Партнер;
		ОтборыВидовЗапасов.Договор = Договор;
		ОтборыВидовЗапасов.ТипЗапасов = Перечисления.ТипыЗапасов.ПродукцияДавальца;
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект,
																МенеджерВременныхТаблиц,
																Отказ,
																ПараметрыЗаполнения);
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД", "Количество, КоличествоПоРНПТ");
		
		ЗаполнитьДопКолонкиВидовЗапасов();
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПараметрыЗаполненияВидовЗапасов()
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	
	ОтборыВидовЗапасов = ПараметрыЗаполнения.ОтборыВидовЗапасов;
	ОтборыВидовЗапасов.Организация = Организация;
	ОтборыВидовЗапасов.ВладелецТовара = Партнер;
	ОтборыВидовЗапасов.Договор = Договор;
	ОтборыВидовЗапасов.ТипЗапасов = Перечисления.ТипыЗапасов.ПродукцияДавальца;
	
	Возврат ПараметрыЗаполнения;
КонецФункции

#КонецОбласти

#Область Прочее

Функция ПараметрыОбъектаССоглашением(ИменаРеквизитов = "")
	
	Если ПустаяСтрока(ИменаРеквизитов) Тогда
		ИменаРеквизитов = "Партнер, Договор, Контрагент, Организация";
	КонецЕсли;
	
	ПараметрыОбъекта = Новый Структура(ИменаРеквизитов);
	ЗаполнитьЗначенияСвойств(ПараметрыОбъекта, ЭтотОбъект);
	
	ПараметрыОбъекта.Вставить("Соглашение", Справочники.СоглашенияСПоставщиками.ПустаяСсылка());
	
	Возврат ПараметрыОбъекта;
	
КонецФункции

// Процедура формирует временную таблицу доступных видов запасов.
//
// Параметры:
//	МенеджерВременныхТаблиц - МенеджерВременныхТаблиц
//
Процедура СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос("
	// Виды запасов продукция давальца
	|ВЫБРАТЬ
	|	ВидыЗапасов.Ссылка         КАК ВидЗапасов,
	|	ВидыЗапасов.Ссылка         КАК ВидЗапасовПродавца,
	|	ВидыЗапасов.Организация    КАК ДляОрганизации
	|ПОМЕСТИТЬ ДоступныеВидыЗапасов
	|ИЗ
	|	Справочник.ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	НЕ ВидыЗапасов.РеализацияЗапасовДругойОрганизации
	|	И ВидыЗапасов.Организация = &Организация
	|	И НЕ ВидыЗапасов.ПометкаУдаления
	|	И ВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.ПродукцияДавальца)
	|	И ВидыЗапасов.ВладелецТовара = &Партнер
	|	И ВидыЗапасов.Договор = &Договор
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВидЗапасов
	|");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Партнер",     Партнер);
	Запрос.УстановитьПараметр("Договор",     Договор);
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	ПараметрыЗаполненияВидовЗапасов = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	ОтборыВидовЗапасов = ПараметрыЗаполненияВидовЗапасов.ОтборыВидовЗапасов;
	ОтборыВидовЗапасов.Организация = Организация;
	ОтборыВидовЗапасов.Партнер = Партнер;
	ОтборыВидовЗапасов.Договор = Договор;
	ОтборыВидовЗапасов.ТипЗапасов = Перечисления.ТипыЗапасов.ПродукцияДавальца;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
