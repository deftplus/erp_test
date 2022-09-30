#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ВидыЗапасовУказаныВручную = Ложь;
	
	ВидыЗапасов.Очистить();
	Серии.Очистить();
	
	СкидкиНаценкиЗаполнениеСервер.ОтменитьСкидки(ЭтотОбъект, "Товары", Ложь);
	
	УчетНДСУП.СкорректироватьСтавкуНДСВТЧДокумента(ЭтотОбъект, Товары);
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "Товары,ВидыЗапасов,ОплатаПлатежнымиКартами");
	
	ОтчетОРозничныхВозвратахЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
		
	Иначе
		
		КассаККМ = Справочники.КассыККМ.АвтономнаяКассаККМПоУмолчанию();
		Если КассаККМ <> Неопределено Тогда
			ЗаполнитьДокументПоКассеККМ(КассаККМ);
		КонецЕсли;
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ОтчетОРозничныхВозвратахЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры // ОбработкаЗаполнения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
		
	НоменклатураСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
															НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОтчетОРозничныхВозвратах));
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
																
		ЗаполнитьАналитикиУчетаНоменклатуры();
		ЗаполнитьВидыЗапасов(Отказ);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;

	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "Товары,ВидыЗапасов,ОплатаПлатежнымиКартами");
	
	ОтчетОРозничныхВозвратахЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ТаблицаИзменений = УчетНДСУП.НоваяТаблицаИзмененийРасчетов();
	СтрокаИзменений = ТаблицаИзменений.Добавить();
	СтрокаИзменений.Документ = Ссылка;
	СтрокаИзменений.Период = Дата;
	УчетНДСУП.ОтразитьВУчетеНДСИзменениеРасчетовСКлиентами(ТаблицаИзменений);

	ОтчетОРозничныхВозвратахЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ОтчетОРозничныхВозвратахЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ДополнительныеСвойства.Вставить("ПараметрыЗаполненияВидовЗапасов", ПараметрыЗаполненияВидовЗапасов());
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ОтчетОРозничныхВозвратахЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	ПроверяемыеРеквизиты.Очистить();
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОтчетОРозничныхПродажах),
												Отказ,
												МассивНепроверяемыхРеквизитов);
	
	Если Не ПоРезультатамИнвентаризации Тогда
		НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	Иначе
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоУпаковок");
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТЗНоменклатура.Номенклатура,
		|	ТЗНоменклатура.НомерСтроки
		|ПОМЕСТИТЬ ТЗНоменклатура
		|ИЗ
		|	&ТЗНоменклатура КАК ТЗНоменклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТЗНоменклатура.Номенклатура,
		|	ТЗНоменклатура.НомерСтроки
		|ИЗ
		|	ТЗНоменклатура КАК ТЗНоменклатура
		|ГДЕ
		|	ТЗНоменклатура.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)");
		
		Запрос.УстановитьПараметр("ТЗНоменклатура", Товары.Выгрузить(,"Номенклатура, НомерСтроки"));
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
		
			ТекстОшибки = СтрШаблон(НСтр("ru = 'В режиме заполнения документа ""По результатам инвентаризации"" услуг в списке ""Товары"" быть не должно.
			                                 |Обнаружена услуга в строке %1 списка ""Товары""';
			                                 |en = 'Services are prohibited in the Item list in the ""By physical inventory count results"" document population mode. Service is found in line %1 of the Item list
			                                 |'"), Выборка.НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", Выборка.НомерСтроки, "Номенклатура"),
				,
				Отказ);
		
		КонецЦикла;
		
	КонецЕсли;
	
	СуммаОплатыПлатежнымиКартами = ОплатаПлатежнымиКартами.Итог("Сумма");
	Если ОплатаПлатежнымиКартами.Количество() > 0
		И СуммаОплатыПлатежнымиКартами <> 0
		И СуммаОплатыПлатежнымиКартами > ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС) Тогда
		
		ТекстОшибки = НСтр("ru = 'Сумма оплаты платежными картами превышает сумму документа';
							|en = 'Card payment amount is greater than the document amount'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ОплатаПлатежнымиКартами",
			,
			Отказ);
		
	КонецЕсли;
	
	Если ПоРезультатамИнвентаризации Тогда
		
		КлючевыеРеквизиты = Новый Массив;
		КлючевыеРеквизиты.Добавить("Номенклатура");
		КлючевыеРеквизиты.Добавить("Характеристика");
		ОбщегоНазначенияУТ.ПроверитьНаличиеДублейСтрокТЧ(ЭтотОбъект, "Товары", КлючевыеРеквизиты, Отказ);
		
	КонецЕсли;

	Если НЕ СкладыСервер.ИспользоватьСкладскиеПомещения(Склад,Дата) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Помещение");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам") Тогда
		ПроверяемыеРеквизиты.Добавить("Подразделение");
	КонецЕсли;
	
	Для каждого СтрокаНачислениеБонусныхБаллов Из НачислениеБонусныхБаллов Цикл
		Если ЗначениеЗаполнено(СтрокаНачислениеБонусныхБаллов.ДатаНачисления)
			И ЗначениеЗаполнено(СтрокаНачислениеБонусныхБаллов.ДатаСписания) Тогда
			
			Если СтрокаНачислениеБонусныхБаллов.ДатаСписания < СтрокаНачислениеБонусныхБаллов.ДатаНачисления Тогда
				
				ТекстОшибки = НСтр("ru = 'Дата списания бонусных баллов меньше даты начисления';
									|en = 'The write-off date of bonus points is earlier than the date of accrual'");
				НомерСтроки = СтрокаНачислениеБонусныхБаллов.НомерСтроки;
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачислениеБонусныхБаллов", НомерСтроки, "ДатаСписания"),
				,
				Отказ);
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОтчетОРозничныхВозвратахЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

// Инициализирует документ
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Склад = ЗначениеНастроекПовтИсп.ПолучитьРозничныйСкладПоУмолчанию(Склад);
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	КонецЕсли;
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	ПараметрыЗаполнения = Документы.ОтчетОРозничныхВозвратах.ПараметрыЗаполненияНалогообложенияНДСПродажи(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);
	
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
КонецПроцедуры // ИнициализироватьДокумент()

// Заполняет отчет о розничных продажах в соответствии с отбором.
//
// Параметры
//  ДанныеЗаполнения - Структура со значениями отбора.
//
Процедура ЗаполнитьДокументПоОтбору(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("КассаККМ") Тогда
		
		ЗаполнитьДокументПоКассеККМ(ДанныеЗаполнения.КассаККМ);
		
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьДокументПоОтбору()

// Заполняет документ по кассе ККМ
//
Процедура ЗаполнитьДокументПоКассеККМ(КассаККМ)
	
	РеквизитыКассыККМ = Справочники.КассыККМ.РеквизитыКассыККМ(КассаККМ);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыКассыККМ);
	
КонецПроцедуры // ЗаполнитьДокументПоКассеККМ()

#КонецОбласти

#Область ВидыЗапасов

// Функция формирует временные данных документа.
//
// Возвращаемое значение:
//	МенеджерВременныхТаблиц - менеджер временных таблиц.
//
Функция ВременныеТаблицыДанныхДокумента(ОтборПоСпособуОпределенияСебестоимости = "Все") Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	&Склад КАК Склад,
	|	Неопределено КАК Партнер,
	|	Неопределено КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	&НалогообложениеНДС КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратОтРозничногоПокупателя) КАК ХозяйственнаяОперация,
	|	ЛОЖЬ КАК ЕстьСделкиВТабличнойЧасти,
	|
	|	ВЫБОР КОГДА СтруктураПредприятия.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоПодразделению)
	|		И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|	ТОГДА
	|		&Подразделение
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|	КОНЕЦ КАК Подразделение,
	|
	|	ВЫБОР КОГДА СтруктураПредприятия.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоМенеджерамПодразделения)
	|		И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|	ТОГДА
	|		&Менеджер
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	КОНЕЦ КАК Менеджер,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|ИЗ
	|	Справочник.Организации КАК Организации
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|	ПО
	|		СтруктураПредприятия.Ссылка = &Подразделение
	|ГДЕ
	|	Организации.Ссылка = &Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	
	|	ТаблицаТоваров.НоменклатураНабора КАК НоменклатураНабора,
	|	ТаблицаТоваров.ХарактеристикаНабора КАК ХарактеристикаНабора,	
	|	ТаблицаТоваров.АналитикаУчетаНаборов КАК АналитикаУчетаНаборов,	
	
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА (НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров)
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаТоваров.КоличествоПоРНПТ
	|	КОНЕЦ КАК КоличествоПоРНПТ,
	
	|	&Склад КАК Склад,
	|	ВЫБОР
	|		КОГДА ТаблицаТоваров.ДокументРеализации = ЗНАЧЕНИЕ(Документ.ОтчетОРозничныхПродажах.ПустаяСсылка)
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ТаблицаТоваров.ДокументРеализации
	|	КОНЕЦ КАК ДокументРеализации,
	|	ТаблицаТоваров.СпособОпределенияСебестоимости КАК СпособОпределенияСебестоимости,
	|	ТаблицаТоваров.ПоЧекуКоррекции КАК ПоЧекуКоррекции,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТоваров.Сумма КАК Сумма,	
	|	ТаблицаТоваров.Сумма + (ТаблицаТоваров.СуммаНДС * &ЦенаВключаетНДС) КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|	ТаблицаТоваров.СуммаРучнойСкидки КАК СуммаРучнойСкидки,	
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ТаблицаТоваров.НомерГТД КАК НомерГТД,
	|	ТаблицаТоваров.Партнер КАК Партнер,
	|	ТаблицаТоваров.Продавец КАК Продавец
	
	|ПОМЕСТИТЬ ВтТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|
	|ГДЕ
	|	&БезОтбора 
	|	ИЛИ (ТаблицаТоваров.СпособОпределенияСебестоимости В (&СпособыОпределенияСебестоимости)
	|	И ТаблицаТоваров.ПоЧекуКоррекции = &ПоЧекуКоррекции)
	
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	
	|	ТаблицаТоваров.НоменклатураНабора КАК НоменклатураНабора,
	|	ТаблицаТоваров.ХарактеристикаНабора КАК ХарактеристикаНабора,	
	|	ТаблицаТоваров.АналитикаУчетаНаборов КАК АналитикаУчетаНаборов,	
	
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ТаблицаТоваров.КоличествоПоРНПТ КАК КоличествоПоРНПТ,	
	|	ТаблицаТоваров.Склад КАК Склад,
	|	ТаблицаТоваров.ДокументРеализации КАК ДокументРеализации,
	|	ТаблицаТоваров.СпособОпределенияСебестоимости КАК СпособОпределенияСебестоимости,
	|	ТаблицаТоваров.ПоЧекуКоррекции КАК ПоЧекуКоррекции,	
	|	ТаблицаТоваров.Сделка КАК Сделка,
	|	ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТоваров.Сумма КАК Сумма,	
	|	ТаблицаТоваров.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|	ТаблицаТоваров.СуммаРучнойСкидки КАК СуммаРучнойСкидки,	
	|	ТаблицаТоваров.СуммаВознаграждения КАК СуммаВознаграждения,
	|	ТаблицаТоваров.СуммаНДСВознаграждения КАК СуммаНДСВознаграждения,
	|	ИСТИНА КАК ПодбиратьВидыЗапасов,	
	|	ТаблицаТоваров.НомерГТД КАК НомерГТД,
	|	ТаблицаТоваров.Партнер КАК Партнер,
	|	ТаблицаТоваров.Продавец КАК Продавец	
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	ВтТаблицаТоваров КАК ТаблицаТоваров
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО ТаблицаТоваров.Номенклатура = СпрНоменклатура.Ссылка
	|		
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатурыОтгрузки КАК АналитикаУчетаНоменклатурыОтгрузки,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.ДокументРеализации КАК ДокументРеализации,
	|	ТаблицаВидыЗапасов.СпособОпределенияСебестоимости КАК СпособОпределенияСебестоимости,
	|	ТаблицаВидыЗапасов.ПоЧекуКоррекции КАК ПоЧекуКоррекции,	
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаВидыЗапасов.КоличествоПоРНПТ
	|	КОНЕЦ КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	ТаблицаВидыЗапасов.СуммаРучнойСкидки КАК СуммаРучнойСкидки,		
	|	ТаблицаВидыЗапасов.Партнер КАК Партнер,
	|	ТаблицаВидыЗапасов.Продавец КАК Продавец	
	|
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|ГДЕ
	|	&БезОтбора
	|	ИЛИ (ТаблицаВидыЗапасов.СпособОпределенияСебестоимости В (&СпособыОпределенияСебестоимости)
	|	И ТаблицаВидыЗапасов.ПоЧекуКоррекции = &ПоЧекуКоррекции)
	|;
	|
	|/////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатурыОтгрузки КАК АналитикаУчетаНоменклатурыОтгрузки,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	НЕОПРЕДЕЛЕНО КАК ВидЗапасовПолучателя,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ЕСТЬNULL(АналитикаОтгрузки.МестоХранения, ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)) КАК СкладОтгрузки,
	|	Аналитика.МестоХранения КАК Склад,
	|	ТаблицаВидыЗапасов.ДокументРеализации КАК ДокументРеализации,
	|	ТаблицаВидыЗапасов.СпособОпределенияСебестоимости КАК СпособОпределенияСебестоимости,
	|	ТаблицаВидыЗапасов.ПоЧекуКоррекции КАК ПоЧекуКоррекции,	
	|	ТаблицаВидыЗапасов.Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.КоличествоПоРНПТ КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	ТаблицаВидыЗапасов.СуммаРучнойСкидки КАК СуммаРучнойСкидки,	
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную,
	|	ТаблицаВидыЗапасов.Партнер КАК Партнер,
	|	ТаблицаВидыЗапасов.Продавец КАК Продавец	
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК АналитикаОтгрузки
	|		ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатурыОтгрузки = АналитикаОтгрузки.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.УстановитьПараметр("Менеджер", Ответственный);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоПодразделениямМенеджерам", ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам"));
	
	Запрос.УстановитьПараметр("НалогообложениеНДС", НалогообложениеНДС);
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Запрос.УстановитьПараметр("ЦенаВключаетНДС", ?(ЦенаВключаетНДС, 0, 1));
	
	ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОтРозничногоПокупателя;
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("ТаблицаТоваров", Товары);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ВидыЗапасов);
	
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	
	Запрос.УстановитьПараметр("БезОтбора", Истина);
	Запрос.УстановитьПараметр("СпособыОпределенияСебестоимости", Неопределено);
	Запрос.УстановитьПараметр("ПоЧекуКоррекции", Ложь);

	Если ОтборПоСпособуОпределенияСебестоимости = "ВозвратыПоДокументуПродажи" Тогда
		Запрос.УстановитьПараметр("БезОтбора", Ложь);
		Запрос.УстановитьПараметр("СпособыОпределенияСебестоимости", Перечисления.СпособыОпределенияСебестоимости.ИзДокументаПродажи);
		Запрос.УстановитьПараметр("ПоЧекуКоррекции", Ложь);
	ИначеЕсли ОтборПоСпособуОпределенияСебестоимости = "КоррекцияПоДокументуПродажи" Тогда
		Запрос.УстановитьПараметр("БезОтбора", Ложь);		
		Запрос.УстановитьПараметр("СпособыОпределенияСебестоимости", Перечисления.СпособыОпределенияСебестоимости.ИзДокументаПродажи);
		Запрос.УстановитьПараметр("ПоЧекуКоррекции", Истина);
	ИначеЕсли ОтборПоСпособуОпределенияСебестоимости = "ВозвратыБезДокументаПродажи" Тогда
		Запрос.УстановитьПараметр("БезОтбора", Ложь);		
		СпособыОпределенияСебестоимости = Новый Массив;
		СпособыОпределенияСебестоимости.Добавить(Перечисления.СпособыОпределенияСебестоимости.Вручную);
		СпособыОпределенияСебестоимости.Добавить(Перечисления.СпособыОпределенияСебестоимости.ИзТекущегоДокумента);
		СпособыОпределенияСебестоимости.Добавить(Перечисления.СпособыОпределенияСебестоимости.ПустаяСсылка());
		Запрос.УстановитьПараметр("СпособыОпределенияСебестоимости", СпособыОпределенияСебестоимости);
		Запрос.УстановитьПараметр("ПоЧекуКоррекции", Ложь);		
	КонецЕсли;
	
	УчетПрослеживаемыхТоваровЛокализация.УстановитьПараметрыИспользованияУчетаПрослеживаемыхТоваров(Запрос);
		
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

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
	|	ТаблицаДанныхДокумента.Подразделение,
	|	ТаблицаДанныхДокумента.Менеджер,
	|	ТаблицаДанныхДокумента.Назначение КАК Назначение,
	|
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	&НалогообложениеНДС КАК НалогообложениеНДС,
	|
	|	ТаблицаТоваров.Количество КАК Количество
	|	
	|ПОМЕСТИТЬ ТаблицаТоваровИАналитики
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокумента КАК ТаблицаДанныхДокумента
	|	ПО
	|		ИСТИНА
	|ГДЕ
	|	ТаблицаТоваров.Номенклатура.ТипНоменклатуры В
	|		(ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|;
	|");
	Запрос.УстановитьПараметр("НалогообложениеНДС", НалогообложениеНДС);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	ИменаРеквизитов = "Организация, Дата, Склад, НалогообложениеНДС";
	
	Возврат ЗапасыСервер.ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц, Ссылка, ИменаРеквизитов);
	
КонецФункции

Функция ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|ИЗ (
	|	ВЫБРАТЬ
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|		ТаблицаТоваров.Партнер КАК Партнер,
	|		ТаблицаТоваров.Продавец КАК Продавец,
	|		ТаблицаТоваров.СпособОпределенияСебестоимости КАК СпособОпределенияСебестоимости,
	|		ТаблицаТоваров.ПоЧекуКоррекции КАК ПоЧекуКоррекции,
	|		ТаблицаТоваров.НомерГТД КАК НомерГТД,
	|		ТаблицаТоваров.Количество КАК Количество,
	|		ТаблицаТоваров.СуммаСНДС КАК СуммаСНДС,
	|		ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|		ТаблицаТоваров.СуммаРучнойСкидки КАК СуммаРучнойСкидки
	|	ИЗ
	|		ТаблицаТоваров КАК ТаблицаТоваров
	|	ГДЕ
	|		ТаблицаТоваров.Номенклатура.ТипНоменклатуры В
	|			(ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|			 ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|		ТаблицаВидыЗапасов.Партнер КАК Партнер,
	|		ТаблицаВидыЗапасов.Продавец КАК Продавец,
	|		ТаблицаВидыЗапасов.СпособОпределенияСебестоимости КАК СпособОпределенияСебестоимости,
	|		ТаблицаВидыЗапасов.ПоЧекуКоррекции КАК ПоЧекуКоррекции,
	|		ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|		-ТаблицаВидыЗапасов.Количество КАК Количество,
	|		-ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|		-ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|		-ТаблицаВидыЗапасов.СуммаРучнойСкидки КАК СуммаРучнойСкидки	
	|	ИЗ
	|		ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|	) КАК ТаблицаТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.СтавкаНДС,
	|	ТаблицаТоваров.Партнер,
	|	ТаблицаТоваров.Продавец,
	|	ТаблицаТоваров.СпособОпределенияСебестоимости,
	|	ТаблицаТоваров.ПоЧекуКоррекции,
	|	ТаблицаТоваров.НомерГТД
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаТоваров.Количество) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаСНДС) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаНДС) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаРучнойСкидки) <> 0
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;

	РезультатЗапрос = Запрос.Выполнить();
	
	Возврат (Не РезультатЗапрос.Пустой());
	
КонецФункции

Процедура ЗаполнитьДопКолонкиВидовЗапасов(ПодготовленнаяТаблицаТовары = Неопределено, ПараметрыСопоставления = Неопределено) Экспорт
	
	Если ПодготовленнаяТаблицаТовары = Неопределено Тогда
		ТаблицаТовары = Товары.Выгрузить(, "АналитикаУчетаНоменклатуры, ДокументРеализации, СпособОпределенияСебестоимости, ПоЧекуКоррекции, Партнер, Продавец, АналитикаУчетаНаборов, Количество, КоличествоПоРНПТ, Сумма, СтавкаНДС, СуммаНДС, СуммаРучнойСкидки");
	Иначе
		ТаблицаТовары = ПодготовленнаяТаблицаТовары;
	КонецЕсли;
	
 	ТаблицаТовары.Свернуть("АналитикаУчетаНоменклатуры, ДокументРеализации, СпособОпределенияСебестоимости, ПоЧекуКоррекции, Партнер, Продавец, АналитикаУчетаНаборов, СтавкаНДС",
		"Количество, КоличествоПоРНПТ, Сумма, СуммаНДС, СуммаРучнойСкидки");
	
	Если ПараметрыСопоставления = Неопределено Тогда
		СтруктураПоиска = Новый Структура("АналитикаУчетаНоменклатуры");
	Иначе	
		СтруктураПоиска = ПараметрыСопоставления;
	КонецЕсли;
	
	Для Каждого СтрокаТоваров Из ТаблицаТовары Цикл

		КоличествоТоваров = СтрокаТоваров.Количество;
		СуммаСНДС = ?(ЦенаВключаетНДС, СтрокаТоваров.Сумма, СтрокаТоваров.Сумма + СтрокаТоваров.СуммаНДС);
		СуммаНДС = СтрокаТоваров.СуммаНДС;
		СуммаРучнойСкидки = СтрокаТоваров.СуммаРучнойСкидки;
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТоваров);
		Для Каждого СтрокаЗапасов Из ВидыЗапасов.НайтиСтроки(СтруктураПоиска) Цикл

			Если СтрокаЗапасов.Количество = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Количество = Мин(КоличествоТоваров, СтрокаЗапасов.Количество);

			НоваяСтрока = ВидыЗапасов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
			
			НоваяСтрока.АналитикаУчетаНаборов = СтрокаТоваров.АналитикаУчетаНаборов;
			
			НоваяСтрока.Партнер = СтрокаТоваров.Партнер;
			НоваяСтрока.Продавец = СтрокаТоваров.Продавец;
			НоваяСтрока.СпособОпределенияСебестоимости = СтрокаТоваров.СпособОпределенияСебестоимости;
			НоваяСтрока.ПоЧекуКоррекции = СтрокаТоваров.ПоЧекуКоррекции;
			
			НоваяСтрока.Количество = Количество;
			НоваяСтрока.КоличествоПоРНПТ = Количество * СтрокаЗапасов.КоличествоПоРНПТ
															/ СтрокаЗапасов.Количество;
			
			Если Количество >= КоличествоТоваров Тогда
				НоваяСтрока.СуммаСНДС = СуммаСНДС;
				НоваяСтрока.СуммаНДС = СуммаНДС;
			ИначеЕсли СтрокаЗапасов.Количество <> 0 Тогда
				НоваяСтрока.СуммаСНДС = Мин(СуммаСНДС, Количество * СтрокаЗапасов.СуммаСНДС / СтрокаЗапасов.Количество);
				НоваяСтрока.СуммаНДС = Мин(СуммаНДС, Количество * СтрокаЗапасов.СуммаНДС / СтрокаЗапасов.Количество);
			КонецЕсли;
			
			НоваяСтрока.СуммаРучнойСкидки = ?(КоличествоТоваров <> 0, Количество * СуммаРучнойСкидки / КоличествоТоваров, 0);

			СтрокаЗапасов.Количество = СтрокаЗапасов.Количество - НоваяСтрока.Количество;
			СтрокаЗапасов.КоличествоПоРНПТ = СтрокаЗапасов.КоличествоПоРНПТ - НоваяСтрока.КоличествоПоРНПТ;			
			СтрокаЗапасов.СуммаСНДС = СтрокаЗапасов.СуммаСНДС - НоваяСтрока.СуммаСНДС;
			СтрокаЗапасов.СуммаНДС = СтрокаЗапасов.СуммаНДС - НоваяСтрока.СуммаНДС;
			СтрокаЗапасов.СуммаРучнойСкидки = СтрокаЗапасов.СуммаРучнойСкидки - НоваяСтрока.СуммаРучнойСкидки;
			
			КоличествоТоваров = КоличествоТоваров - НоваяСтрока.Количество;
			СуммаСНДС = СуммаСНДС - НоваяСтрока.СуммаСНДС;
			СуммаНДС = СуммаНДС - НоваяСтрока.СуммаНДС;
			СуммаРучнойСкидки = СуммаРучнойСкидки - НоваяСтрока.СуммаРучнойСкидки;

			Если КоличествоТоваров = 0 Тогда
				Прервать;
			КонецЕсли;

		КонецЦикла;
		
	КонецЦикла;
	
	МассивУдаляемыхСтрок = ВидыЗапасов.НайтиСтроки(Новый Структура("Количество", 0));
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		ВидыЗапасов.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
			
	ВидыЗапасовПерезаполнены = Ложь;
	
	ВозвратыПоДокументамПродажи = Товары.НайтиСтроки(Новый Структура("СпособОпределенияСебестоимости, ПоЧекуКоррекции", Перечисления.СпособыОпределенияСебестоимости.ИзДокументаПродажи, Ложь));
	СторноПоДокументамПродажи = Товары.НайтиСтроки(Новый Структура("СпособОпределенияСебестоимости, ПоЧекуКоррекции", Перечисления.СпособыОпределенияСебестоимости.ИзДокументаПродажи, Истина));
	
	ЕстьВозвратыПоДокументамПродажи  = ВозвратыПоДокументамПродажи.Количество() > 0;
	ЕстьСторноПоДокументамПродажи  = СторноПоДокументамПродажи.Количество() > 0;
	ЕстьВозвратыБезДокументовПродажи = (ВозвратыПоДокументамПродажи.Количество() + СторноПоДокументамПродажи.Количество()) <> Товары.Количество();
	
	Если ЕстьВозвратыПоДокументамПродажи Тогда
		МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента("ВозвратыПоДокументуПродажи");
		Если Не Проведен
			Или ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект)
			Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
			Или ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц) Тогда
			
			Если ЕстьВозвратыБезДокументовПродажи 
				Или ЕстьСторноПоДокументамПродажи Тогда
				
				ВидыЗапасовБезДокументовПродажи = ВидыЗапасов.Выгрузить(Новый Структура("СпособОпределенияСебестоимости, ПоЧекуКоррекции",
																			Перечисления.СпособыОпределенияСебестоимости.Вручную, Ложь));
				ОбщегоНазначенияУТ.ДобавитьСтрокиВТаблицу(ВидыЗапасовБезДокументовПродажи, ВидыЗапасов.Выгрузить(Новый Структура("СпособОпределенияСебестоимости, ПоЧекуКоррекции",
																			Перечисления.СпособыОпределенияСебестоимости.ИзТекущегоДокумента, Ложь)));																			
				ОбщегоНазначенияУТ.ДобавитьСтрокиВТаблицу(ВидыЗапасовБезДокументовПродажи, ВидыЗапасов.Выгрузить(Новый Структура("СпособОпределенияСебестоимости, ПоЧекуКоррекции",
				                                                            Перечисления.СпособыОпределенияСебестоимости.ПустаяСсылка(), Ложь)));
				
				ВидыЗапасовСторноПоДокументуПродажи = ВидыЗапасов.Выгрузить(Новый Структура("СпособОпределенияСебестоимости, ПоЧекуКоррекции",
																			Перечисления.СпособыОпределенияСебестоимости.ИзДокументаПродажи, Истина));
				ВидыЗапасов.Очистить();																
			КонецЕсли;
			
			ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
			ПараметрыЗаполнения.ПодбиратьВидыЗапасовПоИнтеркампани = Ложь;
			ПараметрыЗаполнения.СообщатьОбОшибкахЗаполнения = Истина;
			ПараметрыЗаполнения.ПриНехваткеТоваровОрганизацииЗаполнятьВидамиЗапасовПоУмолчанию = Ложь;
			Отборы = ПараметрыЗаполнения.ОтборыВидовЗапасов;
			Отборы.Организация = Организация;
			Отборы.НалогообложениеНДС = НалогообложениеНДС;
			УчетНДСУП.ПараметрыЗаполненияВидовЗапасовПоНалогообложению(ПараметрыЗаполнения.ОтборыВидовЗапасов, Организация, Дата, НалогообложениеНДС);
			
			ПараметрыЗаполнения.ИмяТаблицыОстатков = "РеализованныеТовары";
			ЗапасыСервер.ЗаполнитьВидыЗапасовПоОстаткамКОформлению(ЭтотОбъект, МенеджерВременныхТаблиц, Отказ, ПараметрыЗаполнения);
			
			ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, АналитикаУчетаНоменклатурыОтгрузки, ДокументРеализации, ВидЗапасов, ВидЗапасовОтгрузки, НомерГТД, СтавкаНДС",
								"Количество, КоличествоПоРНПТ, СуммаСНДС, СуммаНДС");
			
			ПодготовленнаяТаблицаТовары = ОбщегоНазначенияУТ.ПоказатьВременнуюТаблицу(МенеджерВременныхТаблиц, "ТаблицаТоваров");
			
			ПараметрыСопоставления = Новый Структура("АналитикаУчетаНоменклатуры,ДокументРеализации");		
			ЗаполнитьДопКолонкиВидовЗапасов(ПодготовленнаяТаблицаТовары, ПараметрыСопоставления);
			
			Если Не Отказ Тогда
				ВидыЗапасовПерезаполнены = Истина;
			КонецЕсли;
						
			Если ЕстьВозвратыБезДокументовПродажи Тогда
				ОбщегоНазначенияУТ.ДобавитьСтрокиВТаблицу(ВидыЗапасов, ВидыЗапасовБезДокументовПродажи);
			КонецЕсли;
			Если ЕстьСторноПоДокументамПродажи Тогда
				ОбщегоНазначенияУТ.ДобавитьСтрокиВТаблицу(ВидыЗапасов, ВидыЗапасовСторноПоДокументуПродажи);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
		
 	Если ЕстьВозвратыБезДокументовПродажи Тогда
		МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента("ВозвратыБезДокументаПродажи");
		Если Не Проведен
			Или ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект)
			Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
			Или ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц) Тогда
			
			Если ЕстьВозвратыПоДокументамПродажи
				Или ЕстьСторноПоДокументамПродажи Тогда
				
				ВидыЗапасовПоДокументамПродажи = ВидыЗапасов.Выгрузить(Новый Структура("СпособОпределенияСебестоимости",
																			Перечисления.СпособыОпределенияСебестоимости.ИзДокументаПродажи));
				ВидыЗапасов.Очистить();
			КонецЕсли;
			
			ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
			ПараметрыЗаполнения.ПодбиратьВидыЗапасовПоИнтеркампани = Ложь;
			ПараметрыЗаполнения.СообщатьОбОшибкахЗаполнения = Ложь;
			ПараметрыЗаполнения.ПриНехваткеТоваровОрганизацииЗаполнятьВидамиЗапасовПоУмолчанию = Истина;
			Отборы = ПараметрыЗаполнения.ОтборыВидовЗапасов;
			Отборы.Организация = Организация;
			Отборы.НалогообложениеНДС = НалогообложениеНДС;
			УчетНДСУП.ПараметрыЗаполненияВидовЗапасовПоНалогообложению(ПараметрыЗаполнения.ОтборыВидовЗапасов, Организация, Дата, НалогообложениеНДС);
			
			ПараметрыЗаполнения.ИмяТаблицыОстатков = "ТаблицаВидыЗапасов";
			ЗапасыСервер.ЗаполнитьВидыЗапасовПоОстаткамКОформлению(ЭтотОбъект, МенеджерВременныхТаблиц, Отказ, ПараметрыЗаполнения);
						
			ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, АналитикаУчетаНоменклатурыОтгрузки, ВидЗапасов, ВидЗапасовОтгрузки, НомерГТД, СтавкаНДС",
								"Количество, КоличествоПоРНПТ, СуммаСНДС, СуммаНДС");
			
			ПодготовленнаяТаблицаТовары = ОбщегоНазначенияУТ.ПоказатьВременнуюТаблицу(МенеджерВременныхТаблиц, "ТаблицаТоваров");
			
			ЗаполнитьДопКолонкиВидовЗапасов(ПодготовленнаяТаблицаТовары);
			
			Если Не Отказ Тогда
				ВидыЗапасовПерезаполнены = Истина;
			КонецЕсли;
			
			Если ЕстьВозвратыПоДокументамПродажи
				Или ЕстьСторноПоДокументамПродажи Тогда
				ОбщегоНазначенияУТ.ДобавитьСтрокиВТаблицу(ВидыЗапасов, ВидыЗапасовПоДокументамПродажи);
			КонецЕсли;
			
		КонецЕсли;	
	КонецЕсли;
	
	Если ЕстьСторноПоДокументамПродажи Тогда		
		МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента("КоррекцияПоДокументуПродажи");
		Если Не Проведен
			Или ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект)
			Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
			Или ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц) Тогда
			
			Если ЕстьВозвратыБезДокументовПродажи 
				Или ЕстьВозвратыПоДокументамПродажи Тогда
				
				ВидыЗапасовПоВозвратам = ВидыЗапасов.Выгрузить(Новый Структура("ПоЧекуКоррекции", Ложь));
				
				ВидыЗапасов.Очистить();																
			КонецЕсли;
			
			ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
			ПараметрыЗаполнения.ИмяТаблицыОстатков = "РеализованныеТовары";
			ПараметрыЗаполнения.ПриНехваткеТоваровОрганизацииЗаполнятьВидамиЗапасовПоУмолчанию = Ложь;
			ПараметрыЗаполнения.БезОтбораПоНомерамГТД = Истина;
			
			ЗапасыСервер.ЗаполнитьВидыЗапасовПоОстаткамКОформлению(ЭтотОбъект,
																	МенеджерВременныхТаблиц,
																	Отказ,
																	ПараметрыЗаполнения);
																	
			ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, АналитикаУчетаНоменклатурыОтгрузки, ДокументРеализации, ВидЗапасов, ВидЗапасовОтгрузки, НомерГТД, СтавкаНДС",
								"Количество, КоличествоПоРНПТ, СуммаСНДС, СуммаНДС");
			
			ПодготовленнаяТаблицаТовары = ОбщегоНазначенияУТ.ПоказатьВременнуюТаблицу(МенеджерВременныхТаблиц, "ТаблицаТоваров");
			
			ПараметрыСопоставления = Новый Структура("АналитикаУчетаНоменклатуры,ДокументРеализации");		
			ЗаполнитьДопКолонкиВидовЗапасов(ПодготовленнаяТаблицаТовары, ПараметрыСопоставления);
			
			Если Не Отказ Тогда
				ВидыЗапасовПерезаполнены = Истина;
			КонецЕсли;
			
			Если ЕстьВозвратыПоДокументамПродажи Или ЕстьВозвратыБезДокументовПродажи Тогда
				ОбщегоНазначенияУТ.ДобавитьСтрокиВТаблицу(ВидыЗапасов, ВидыЗапасовПоВозвратам);
			КонецЕсли;
			
	    КонецЕсли;
	КонецЕсли;
				
КонецПроцедуры

// Заполняет аналитики учета номенклатуры. Используется в отчете ОстаткиТоваровОрганизаций.
Процедура ЗаполнитьАналитикиУчетаНоменклатуры() Экспорт
	
	МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(Неопределено, Склад, Подразделение, Неопределено);
	ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
	ИменаПолей.Назначение = "";
	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета, ИменаПолей);
	РегистрыСведений.АналитикаУчетаНаборов.ЗаполнитьВКоллекции(Товары);

КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ПараметрыЗаполненияВидовЗапасов()
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	ПараметрыЗаполнения.ОтборыВидовЗапасов.НалогообложениеНДС = НалогообложениеНДС;
	ПараметрыЗаполнения.ПодбиратьВТЧТоварыПринятыеНаОтветственноеХранение = "Никогда";
	
	Возврат ПараметрыЗаполнения; 
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
