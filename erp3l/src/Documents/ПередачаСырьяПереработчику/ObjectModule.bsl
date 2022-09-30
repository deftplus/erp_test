#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ЗаполнениеУсловийПродаж

// Заполняет условия продаж в заказе клиента
//
// Параметры:
//	УсловияПродаж - Структура - Структура для заполнения.
//
Процедура ЗаполнитьУсловияПродаж(Знач УсловияПродаж) Экспорт
	
	Если УсловияПродаж = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//******************************************************************************
	// Валюта
	
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = УсловияПродаж.Валюта;
	КонецЕсли;
	
	//******************************************************************************
	// Организация и банковский счет организации
	
	Если ЗначениеЗаполнено(УсловияПродаж.Организация) И Не ЗначениеЗаполнено(Организация) Тогда
		
		Организация = УсловияПродаж.Организация;
		СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
		СтруктураПараметров.Организация    		= Организация;

		БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
		
	КонецЕсли;
	
	//******************************************************************************
	// Контрагент
	
	Если Не УсловияПродаж.Типовое Тогда
		
		Если ЗначениеЗаполнено(УсловияПродаж.Контрагент) И УсловияПродаж.Контрагент <> Контрагент Тогда
			Контрагент = УсловияПродаж.Контрагент;
		КонецЕсли;
		
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
	//******************************************************************************
	// Контактное лицо
	
	Если Не УсловияПродаж.Типовое Тогда
		
		Если ЗначениеЗаполнено(УсловияПродаж.КонтактноеЛицо) И Не ЗначениеЗаполнено(КонтактноеЛицо) Тогда
			КонтактноеЛицо = УсловияПродаж.КонтактноеЛицо;
		КонецЕсли;
		
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Партнер, КонтактноеЛицо);
	
	//******************************************************************************
	// Договор и Банковские счета
	
	Если УсловияПродаж.ИспользуютсяДоговорыКонтрагентов <> Неопределено И УсловияПродаж.ИспользуютсяДоговорыКонтрагентов Тогда
		
		ХозяйственнаяОперацияДоговора = Перечисления.ХозяйственныеОперации.ПроизводствоУПереработчика;
		Параметрыобъекта = ПараметрыОбъектаССоглашением();
		Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(Параметрыобъекта, ХозяйственнаяОперацияДоговора);
		ПродажиСервер.ЗаполнитьБанковскиеСчетаПоДоговору(Договор, БанковскийСчетОрганизации, БанковскийСчетКонтрагента);
		
	КонецЕсли;
	
	//******************************************************************************
	// Склад и ответственные
	
	Если ЗначениеЗаполнено(УсловияПродаж.Склад) И Не ЗначениеЗаполнено(Склад) Тогда
		
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
			
			Если ЗначениеЗаполнено(УсловияПродажПоУмолчанию.Соглашение) Тогда
				
				ЗаполнитьУсловияПродаж(УсловияПродажПоУмолчанию);
				
				СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
				СтруктураПараметров.Организация    		= Организация;
				СтруктураПараметров.БанковскийСчет		= БанковскийСчетОрганизации;

				БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
				
			КонецЕсли;
			
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

#Область Прочее

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
	|	Неопределено                                              КАК Партнер,
	|	Неопределено                                              КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)    КАК Договор,
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
	|	ВЫБОР
	|		КОГДА СделкиСКлиентами.ОбособленныйУчетТоваровПоСделке
	|				И &ФормироватьВидыЗапасовПоСделкам
	|			ТОГДА &Сделка
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка)
	|	КОНЕЦ                                                     КАК Сделка,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)                  КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|		ПО СтруктураПредприятия.Ссылка = &Подразделение
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СделкиСКлиентами КАК СделкиСКлиентами
	|		ПО СделкиСКлиентами.Ссылка = &Сделка
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
	|	ТаблицаТоваров.Серия                          КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий            КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.Назначение                     КАК Назначение,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры     КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Количество                     КАК Количество,
	|	ТаблицаТоваров.Склад                          КАК Склад,
	|	ТаблицаТоваров.ЗаказПереработчику             КАК ЗаказПереработчику,
	|	ТаблицаТоваров.КодСтроки                      КАК КодСтроки,
	|	ТаблицаТоваров.Сумма                          КАК Сумма,
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
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки                 КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры  КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасов                  КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД                    КАК НомерГТД,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)       КАК СкладОтгрузки,
	|	ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка)  КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.ЗаказПереработчику          КАК ЗаказПереработчику,
	|	ТаблицаВидыЗапасов.ЗалоговаяСтоимость          КАК ЗалоговаяСтоимость,
	|	ТаблицаВидыЗапасов.КодСтроки                   КАК КодСтроки,
	|	&Сделка                                        КАК Сделка,
	|	ТаблицаВидыЗапасов.Количество                  КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаВидыЗапасов.КоличествоПоРНПТ
	|	КОНЕЦ                                          КАК КоличествоПоРНПТ,
	|	&ВидыЗапасовУказаныВручную                     КАК ВидыЗапасовУказаныВручную
	|ПОМЕСТИТЬ ВТВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Аналитика.Номенклатура							КАК Номенклатура,
	|	Аналитика.Характеристика						КАК Характеристика,
	|	Аналитика.Серия									КАК Серия,
	|	Аналитика.МестоХранения 						КАК Склад,
	|	ТаблицаВидыЗапасов.НомерСтроки					КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры	КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасов					КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД						КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СтавкаНДС					КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.СкладОтгрузки				КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.ЗаказПереработчику			КАК ЗаказПереработчику,
	|	ТаблицаВидыЗапасов.ЗалоговаяСтоимость			КАК ЗалоговаяСтоимость,
	|	ТаблицаВидыЗапасов.КодСтроки					КАК КодСтроки,
	|	ТаблицаВидыЗапасов.Сделка						КАК Сделка,
	|	ТаблицаВидыЗапасов.Количество					КАК Количество,
	|	ТаблицаВидыЗапасов.КоличествоПоРНПТ				КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.ВидыЗапасовУказаныВручную	КАК ВидыЗапасовУказаныВручную
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВТВидыЗапасов КАК ТаблицаВидыЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия,
	|	Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТВидыЗапасов
	|";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка",                          Ссылка);
	Запрос.УстановитьПараметр("Дата",                            Дата);
	Запрос.УстановитьПараметр("Организация",                     Организация);
	Запрос.УстановитьПараметр("Менеджер",                        Менеджер);
	Запрос.УстановитьПараметр("Подразделение",                   Подразделение);
	Запрос.УстановитьПараметр("Сделка",                          Сделка);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",           ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("ПередачаПоЗаказам",               ПередачаПоЗаказам);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную",       ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоПодразделениямМенеджерам", ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам"));
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоСделкам", ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоСделкам"));
	Запрос.УстановитьПараметр("РеализацияПоНесколькимЗаказам",   ПередачаПоЗаказам И Не ЗначениеЗаполнено(ЗаказПереработчику));
	Запрос.УстановитьПараметр("ТаблицаТоваров",                  Товары);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов",              ВидыЗапасов);
	
	УчетПрослеживаемыхТоваровЛокализация.УстановитьПараметрыИспользованияУчетаПрослеживаемыхТоваров(Запрос);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ПараметрыОкругления = Документы.ПередачаСырьяПереработчику.ПараметрыТЧДляОкругления();
	НоменклатураСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи, ПараметрыОкругления["Товары"]);
	
	СуммаДокумента = Товары.Итог("Сумма");
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ПередачаСырьяПереработчику));
	
	ОбщегоНазначенияУТ.ИзменитьПризнакСогласованностиДокумента(
		ЭтотОбъект,
		РежимЗаписи);
		
	Если ПередачаПоЗаказам И ЗначениеЗаполнено(ЗаказПереработчику) Тогда
		
		Для Каждого ТекСтрока Из Товары Цикл
			
			Если Не ЗначениеЗаполнено(ТекСтрока.ЗаказПереработчику) Тогда
				ТекСтрока.ЗаказПереработчику = ЗаказПереработчику;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
		
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		СкладГруппа = Справочники.Склады.ЭтоГруппа(Склад);
		Если Не СкладГруппа Тогда
			СкладыСервер.ЗаполнитьСкладыВТабличнойЧасти(Склад, СкладГруппа, Товары, Ложь);
		КонецЕсли;
		
		ЗаполнитьАналитикиУчетаНоменклатуры();
		ЗаполнитьВидыЗапасов(Отказ);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "Товары,ВидыЗапасов");
	
	ПередачаСырьяПереработчикуЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

// Заполняет аналитики учета номенклатуры. Используется в отчете ОстаткиТоваровОрганизаций.
Процедура ЗаполнитьАналитикиУчетаНоменклатуры() Экспорт
	
	МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(
		Перечисления.ХозяйственныеОперации.ПередачаПереработчику,
		Склад,
		Подразделение,
		Партнер);
	
	// Если Склад - группа, то для аналитики учета номенклатуры склад берем из ТЧ
	ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
	
	РеквизитыСклада = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Склад, "ЭтоГруппа, ВыборГруппы");
	
	Если РеквизитыСклада.ЭтоГруппа И РеквизитыСклада.ВыборГруппы = Перечисления.ВыборГруппыСкладов.РазрешитьВЗаказахИНакладных Тогда
		ИменаПолей.Вставить("Произвольный", "Склад");
	КонецЕсли;
	
	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(
		Товары,
		МестаУчета,
		ИменаПолей);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("МассивЗаказов") Тогда
			ЗаполнитьДокументПоПараметрам(ДанныеЗаполнения);
		Иначе
			ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
		КонецЕсли;
		
	КонецЕсли;
	
	ПередачаСырьяПереработчикуЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ДополнительныеСвойства.Вставить("НеобходимостьЗаполненияКассыПриФОИспользоватьНесколькоКассЛожь", Ложь);
	ДополнительныеСвойства.Вставить("НеобходимостьЗаполненияСчетаПриФОИспользоватьНесколькоСчетовЛожь", Ложь);
	ОтветственныеЛицаСервер.ЗаполнитьМенеджера(ЭтотОбъект, Ложь);
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);

	Если Не ЗначениеЗаполнено(Менеджер) Тогда
		Менеджер = Пользователи.ТекущийПользователь();
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыПроверкиКоличества = Документы.ПередачаСырьяПереработчику.ПараметрыТЧДляОкругления();
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(
		ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверкиКоличества["Товары"]);
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ПередачаСырьяПереработчику);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, ПараметрыУказанияСерий,	Отказ, МассивНепроверяемыхРеквизитов);
	
	Для ТекИндекс = 0 По Товары.Количество() - 1 Цикл
		
		Если ПередачаПоЗаказам
			И Не ЗначениеЗаполнено(ЗаказПереработчику)
			И Не ЗначениеЗаполнено(Товары[ТекИндекс].ЗаказПереработчику) Тогда
			
			ТекстОшибки = НСтр("ru = 'Не заполнено поле ""Заказ переработчику"" в строке %НомерСтроки% списка ""Сырье и материалы""';
								|en = '""Purchase order — Subcontracting"" is required in line %НомерСтроки% of the ""Raw and consumable materials"" list'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", Товары[ТекИндекс].НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", Товары[ТекИндекс].НомерСтроки, "ЗаказПереработчику"),
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ВернутьМногооборотнуюТару Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаВозвратаМногооборотнойТары");
	КонецЕсли;
	
	ДоставкаТоваров.ПроверитьЗаполнениеРеквизитовДоставки(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ, ПередачаПоЗаказам);
	
	Если ЗначениеЗаполнено("ДатаВозвратаМногооборотнойТары") И ВернутьМногооборотнуюТару И ДатаВозвратаМногооборотнойТары < НачалоДня(Дата) Тогда
		
		ТекстОшибки = НСтр("ru = 'Дата возврата многооборотной тары не должна быть меньше даты документа.';
							|en = 'Reusable packagings return date can not be later than the document date.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ДатаВозвратаМногооборотнойТары",
			,
			Отказ);
		
	КонецЕсли;
	
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
	
	ПродажиСервер.ПроверитьКорректностьЗаполненияДокументаПродажи(ЭтотОбъект,Отказ);
	
	ПередачаСырьяПереработчикуЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ДоставкаТоваров.ОтразитьСостояниеДоставки(Ссылка, Отказ);
	
	ПередачаСырьяПереработчикуЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ДополнительныеСвойства.Вставить("ПараметрыЗаполненияВидовЗапасов", ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов());
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ДоставкаТоваров.ОтразитьСостояниеДоставки(Ссылка, Отказ, Истина);
	
	ПередачаСырьяПереработчикуЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Согласован					= Ложь;
	ЗаказПереработчику			= Неопределено;
	ХозяйственнаяОперация		= Метаданные.Документы.ПередачаСырьяПереработчику.Реквизиты.ХозяйственнаяОперация.ЗначениеЗаполнения;
	ПередачаПоЗаказам			= Ложь;
	ВидыЗапасовУказаныВручную	= Ложь;
	
	Для Каждого ТекСтрока Из Товары Цикл
		
		ТекСтрока.ЗаказПереработчику = Неопределено;
		ТекСтрока.КодСтроки = 0;
		
	КонецЦикла;
	НазначениеПоУмолчанию = НаправленияДеятельностиСервер.ТолкающееНазначение(НаправлениеДеятельности);
	НакладныеСервер.ЗаполнитьНазначенияВТабличнойЧасти(Товары, НазначениеПоУмолчанию);
	
	Серии.Очистить();
	ВидыЗапасов.Очистить();
	
	ИнициализироватьДокумент();
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "Товары,ВидыЗапасов");
	
	ПередачаСырьяПереработчикуЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ПередачаСырьяПереработчикуЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	Префикс = ОбщегоНазначенияУТПовтИсп.ДополнительныйПрефиксНумератораДокументыРеализацииТоваров();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьДокументПоПараметрам(СтруктураЗаполнения)
	
	МассивЗаказов = СтруктураЗаполнения.МассивЗаказов;
	
	ПараметрыЗаполнения = Документы.ПередачаСырьяПереработчику.ПараметрыЗаполненияДокумента();
	ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, СтруктураЗаполнения);
	Документы.ПередачаСырьяПереработчику.ИнициализироватьПараметрыЗаполнения(ПараметрыЗаполнения,
		СтруктураЗаполнения.РеквизитыШапки, МассивЗаказов);
	
	ТаблицаНакладная = Документы.ПередачаСырьяПереработчику.ДанныеТаблицыТоварыДокумента(ЭтотОбъект.Ссылка);
	
	Документы.ПередачаСырьяПереработчику.ЗаполнитьПоЗаказамОрдерам(ТаблицаНакладная, Ссылка, ПараметрыЗаполнения);
	
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
	
	Документы.ПередачаСырьяПереработчику.ЗаполнитьШапкуДокументаПоЗаказу(ЭтотОбъект, ПараметрыЗаполнения, МассивЗаказов);
	
	Документы.ПередачаСырьяПереработчику.ОбновитьЗависимыеРеквизитыТабличнойЧасти(Товары, ПараметрыЗаполнения);
	
	ЗаполнитьУсловияПродажПоУмолчанию();
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)

	Если ДанныеЗаполнения.Свойство("Партнер") Тогда
		
		Партнер = ДанныеЗаполнения.Партнер;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
			ЗаполнитьУсловияПродажПоУмолчанию();
		КонецЕсли;
		
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
	
	СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияКассыОрганизацииПоУмолчанию();
	СтруктураПараметров.Организация = Организация;
	СтруктураПараметров.Касса		= Касса;
	Касса                     = ЗначениеНастроекПовтИсп.ПолучитьКассуОрганизацииПоУмолчанию(СтруктураПараметров);
	
	ХозяйственнаяОперация     = Метаданные.Документы.ПередачаСырьяПереработчику.Реквизиты.ХозяйственнаяОперация.ЗначениеЗаполнения;
	Склад                     = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	
	СтруктураОтветственного = ПродажиСервер.ПолучитьОтветственногоПоСкладу(Склад);
	Если СтруктураОтветственного <> Неопределено Тогда
		Отпустил          = СтруктураОтветственного.Ответственный;
		ОтпустилДолжность = СтруктураОтветственного.ОтветственныйДолжность;
	КонецЕсли;
	
	Если Не ПередачаПоЗаказам Тогда
		УчетСырьяПоНазначениям = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСтрокуВидовЗапасов(СтрокаТоваров, СтруктураПоиска, Ресурсы)
	
	Для Каждого СтрокаЗапасов Из ВидыЗапасов.НайтиСтроки(СтруктураПоиска) Цикл
		
		Если СтрокаЗапасов.Количество = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		КоличествоПоСтроке = Мин(Ресурсы.КоличествоТоваровПоСтроке, СтрокаЗапасов.Количество);
		
		НоваяСтрока = ВидыЗапасов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
		
		НоваяСтрока.Упаковка           = СтрокаТоваров.Упаковка;
		НоваяСтрока.ЗаказПереработчику = СтрокаТоваров.ЗаказПереработчику;
		НоваяСтрока.КодСтроки          = СтрокаТоваров.КодСтроки;
		НоваяСтрока.Количество         = КоличествоПоСтроке;
		НоваяСтрока.КоличествоПоРНПТ   = КоличествоПоСтроке * СтрокаЗапасов.КоличествоПоРНПТ / СтрокаЗапасов.Количество;
		
		Если Ресурсы.КоличествоТоваровПоСтроке = 0 Тогда
			НоваяСтрока.КоличествоУпаковок = 0;
		Иначе
			НоваяСтрока.КоличествоУпаковок = Ресурсы.КоличествоУпаковокПоСтроке * КоличествоПоСтроке
												/ Ресурсы.КоличествоТоваровПоСтроке;
		КонецЕсли;
		
		Если КоличествоПоСтроке = Ресурсы.КоличествоТоваровПоСтроке Тогда
			НоваяСтрока.ЗалоговаяСтоимость = Ресурсы.СуммаПоСтроке;
		Иначе
			НоваяСтрока.ЗалоговаяСтоимость = Ресурсы.СуммаПоСтроке * КоличествоПоСтроке
												/ Ресурсы.КоличествоТоваровПоСтроке;
		КонецЕсли;
		
		Ресурсы.КоличествоТоваровПоСтроке  = Ресурсы.КоличествоТоваровПоСтроке  - НоваяСтрока.Количество;
		Ресурсы.КоличествоУпаковокПоСтроке = Ресурсы.КоличествоУпаковокПоСтроке - НоваяСтрока.КоличествоУпаковок;
		Ресурсы.СуммаПоСтроке              = Ресурсы.СуммаПоСтроке              - НоваяСтрока.ЗалоговаяСтоимость;
		
		СтрокаЗапасов.Количество		= СтрокаЗапасов.Количество - НоваяСтрока.Количество;
		СтрокаЗапасов.КоличествоПоРНПТ	= СтрокаЗапасов.КоличествоПоРНПТ - НоваяСтрока.КоличествоПоРНПТ;
		
		Если Ресурсы.КоличествоТоваровПоСтроке = 0 Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьДопКолонкиВидовЗапасов() Экспорт
	
	КолонкиГруппировок = "АналитикаУчетаНоменклатуры, Упаковка, ЗаказПереработчику, КодСтроки";
	КолонкиСуммирования = "Количество, КоличествоУпаковок, Сумма";
	
	ТаблицаТовары = Товары.Выгрузить(, КолонкиГруппировок + ", " + КолонкиСуммирования);
	ТаблицаТовары.Свернуть(КолонкиГруппировок, КолонкиСуммирования);
	
	СтруктураПоиска = Новый Структура("АналитикаУчетаНоменклатуры");
	
	Для Каждого СтрокаТоваров Из ТаблицаТовары Цикл
		Ресурсы = Новый Структура;
		Ресурсы.Вставить("КоличествоТоваровПоСтроке",  СтрокаТоваров.Количество);
		Ресурсы.Вставить("КоличествоУпаковокПоСтроке", СтрокаТоваров.КоличествоУпаковок);
		Ресурсы.Вставить("СуммаПоСтроке",              СтрокаТоваров.Сумма);
		
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
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект,
																МенеджерВременныхТаблиц,
																Отказ,
																ПараметрыЗаполнения);
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД, Склад", "Количество, КоличествоПоРНПТ");
		
		ЗаполнитьДопКолонкиВидовЗапасов();
		ЗаполнитьВидЗапасовПолучателя();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Процедура формирует временную таблицу товаров с аналитикой обособленного учета.
//
// Параметры:
//	МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - менеджер временных таблиц,
//								который будет содержать созданную таблицу.
//
Процедура СформироватьВременнуюТаблицуТоваровИАналитики(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ВЫБОР
	|		КОГДА ТаблицаТоваров.СтатусУказанияСерий = 14
	|			ТОГДА ТаблицаТоваров.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Серия,
	|	ТаблицаТоваров.Склад,
	|
	|	ТаблицаДанныхДокумента.Подразделение						КАК Подразделение,
	|	ТаблицаДанныхДокумента.Менеджер								КАК Менеджер,
	|	ТаблицаДанныхДокумента.Сделка								КАК Сделка,
	|	
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)					КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка)	КАК Соглашение,
	|	НЕОПРЕДЕЛЕНО												КАК НалогообложениеНДС,
	|	
	|	ТаблицаТоваров.Назначение									КАК Назначение,
	|	ТаблицаТоваров.Количество									КАК Количество
	|	
	|ПОМЕСТИТЬ ТаблицаТоваровИАналитики
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокумента КАК ТаблицаДанныхДокумента
	|	ПО
	|		ИСТИНА
	|;
	|");
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ПараметрыОбъектаССоглашением(ИменаРеквизитов = "")
	
	Если ПустаяСтрока(ИменаРеквизитов) Тогда
		ИменаРеквизитов = "Партнер, Договор, Контрагент, Организация";
	КонецЕсли;
	
	ПараметрыОбъекта = Новый Структура(ИменаРеквизитов);
	ЗаполнитьЗначенияСвойств(ПараметрыОбъекта, ЭтотОбъект);
	
	ПараметрыОбъекта.Вставить("Соглашение", Справочники.СоглашенияСПоставщиками.ПустаяСсылка());
	
	Возврат ПараметрыОбъекта;
	
КонецФункции

#КонецОбласти

#Область ВидыЗапасов

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	ИменаРеквизитов = "Организация,Дата";
	
	Возврат ЗапасыСервер.ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц, Ссылка, ИменаРеквизитов);
	
КонецФункции

Функция ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаТоваров.Склад                       КАК Склад,
	|		ТаблицаТоваров.ЗаказПереработчику          КАК ЗаказПереработчику,
	|		ТаблицаТоваров.КодСтроки                   КАК КодСтроки,
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры  КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаТоваров.Количество                  КАК Количество,
	|		ТаблицаТоваров.Сумма                       КАК Сумма
	|	ИЗ
	|		ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВидыЗапасов.Склад                       КАК Склад,
	|		ТаблицаВидыЗапасов.ЗаказПереработчику          КАК ЗаказПереработчику,
	|		ТаблицаВидыЗапасов.КодСтроки                   КАК КодСтроки,
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры  КАК АналитикаУчетаНоменклатуры,
	|		-ТаблицаВидыЗапасов.Количество                 КАК Количество,
	|		-ТаблицаВидыЗапасов.ЗалоговаяСтоимость         КАК Сумма
	|	ИЗ
	|		ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов) КАК ТаблицаТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.Склад,
	|	ТаблицаТоваров.ЗаказПереработчику,
	|	ТаблицаТоваров.КодСтроки,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры
	|
	|ИМЕЮЩИЕ
	|	(СУММА(Количество) <> 0) ИЛИ (СУММА(Сумма) <> 0)");
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Результат = Запрос.Выполнить();
	Возврат Не Результат.Пустой();
	
КонецФункции

Процедура ЗаполнитьВидЗапасовПолучателя()
			
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Запасы.НомерСтроки,
	|	Запасы.ВидЗапасов,
	|	Запасы.ВидЗапасовПолучателя,
	|	Запасы.АналитикаУчетаНоменклатуры
	|
	|ПОМЕСТИТЬ Запасы
	|ИЗ
	|	&ВидыЗапасов КАК Запасы
	|;
	|////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Запасы.НомерСтроки                        КАК НомерСтроки,
	|	Ключи.Номенклатура                        КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &Проведен
	|			ТОГДА Запасы.ВидЗапасовПолучателя
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	КОНЕЦ КАК ТекущийВидЗапасов,
	|	ЛОЖЬ                                      КАК ЭтоВозвратнаяТара,
	|	СпрВидыЗапасов.Организация                КАК Организация,
	|	&ХозяйственнаяОперация                    КАК ХозяйственнаяОперация, 
	|	ВЫБОР КОГДА СпрВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	// При передаче в производство комиссионный товар выкупается отчетом комитенту о списании и проходит как собственный.
	|		ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
	|		ИНАЧЕ СпрВидыЗапасов.ТипЗапасов
	|	КОНЕЦ                                     КАК ТипЗапасов,
	|	НЕОПРЕДЕЛЕНО                              КАК Соглашение,
	|	НЕОПРЕДЕЛЕНО                              КАК Валюта,
	|	&НалогообложениеОрганизации               КАК НалогообложениеНДС,
	|	&НалогообложениеОрганизации               КАК НалогообложениеОрганизации,
	|	НЕОПРЕДЕЛЕНО                              КАК ВладелецТовара,
	|	НЕОПРЕДЕЛЕНО                              КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО                              КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.ВидыЦенПоставщиков.ПустаяСсылка) КАК ВидЦены
	|ПОМЕСТИТЬ ИсходнаяТаблицаТоваров
	|ИЗ
	|	Запасы КАК Запасы
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК СпрВидыЗапасов
	|	ПО СпрВидыЗапасов.Ссылка = Запасы.ВидЗапасов
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Ключи
	|	ПО Ключи.Ссылка = Запасы.АналитикаУчетаНоменклатуры
	|
	|ГДЕ
	|	СпрВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	|");
	
	ВыгружаемыеКолонки = "НомерСтроки, АналитикаУчетаНоменклатуры, ВидЗапасов, ВидЗапасовПолучателя";
	ПараметрыУчетаПоОрганизации = УчетНДСУП.ПараметрыУчетаПоОрганизации(Организация, Дата);
	Запрос.УстановитьПараметр("НалогообложениеОрганизации", ПараметрыУчетаПоОрганизации.ОсновноеНалогообложениеНДСПродажи);
	Запрос.УстановитьПараметр("ВидыЗапасов", ВидыЗапасов.Выгрузить(, ВыгружаемыеКолонки));
	Запрос.УстановитьПараметр("ПартионныйУчетВерсии22",	РасчетСебестоимостиПовтИсп.ПартионныйУчетВерсии22(НачалоМесяца(Дата)));
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("Проведен", Проведен);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	Запрос.Выполнить();
	
	ЗапасыСервер.ЗаполнитьВидыЗапасовПоУмолчанию(МенеджерВременныхТаблиц, ВидыЗапасов,, "ВидЗапасовПолучателя");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
