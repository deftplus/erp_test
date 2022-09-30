///////////////////////////////////////////////////////////////////////////////
// Модуль "НаправленияДеятельностиСервер", содержит процедуры и функции необходимые для
// работы серверной части форм накладных и заказов.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОбщиеОбработчикиСобытийФорм

// Используется в формах документов, в одноименных процедурах "ПриЧтенииСозданииНаСервере".
// Инициализирует реквизиты формы, используемые при интерактивной работе пользователя. Заполняет назначение, исходя из
// направления деятельности.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма в которой необходимо инициализировать реквизиты связанные с использованием
//                             направлений деятельности.
//
Процедура ПриЧтенииСозданииНаСервере(Форма) Экспорт
	
	ОбъектФормы = Форма.Объект; // ДокументОбъект - 
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ОбъектФормы.Ссылка);
	Форма.МетаданныеФормы = МенеджерОбъекта.ПорядокОбработкиДокументаПриИзмененииНаправленияДеятельности(Форма);
	Форма.НаправленияДеятельностиКэшированныеЗначения = НаправленияДеятельностиКэшированныеЗначения();
	
	Кэш = Форма.НаправленияДеятельностиКэшированныеЗначения;
	Кэш.ИспользоватьОбособленноеОбеспечениеЗаказов = ПолучитьФункциональнуюОпцию("ИспользоватьОбособленноеОбеспечениеЗаказов");
	Кэш.ИспользоватьНаправленияДеятельности        = ПолучитьФункциональнуюОпцию("ИспользоватьУчетЗатратПоНаправлениямДеятельности");
	
	ПорядокОбработкиДокумента = Форма.МетаданныеФормы;
	
	НазначениеПоУмолчанию = Справочники.Назначения.ПустаяСсылка();
	Если ПорядокОбработкиДокумента.ИменаТабличныхЧастейДляЗаполненияНазначения <> Неопределено Тогда
		НазначениеПоУмолчанию = ТолкающееНазначение(Форма.Объект.НаправлениеДеятельности);
	КонецЕсли;

	// Запись данных формы.
	Кэш.НазначениеПоУмолчанию = НазначениеПоУмолчанию;
		
	Если ПорядокОбработкиДокумента.ЗаполнятьНазначениеВШапке И Не ЗначениеЗаполнено(ОбъектФормы.Ссылка) Тогда
		
		// Инициализация назначения у нового документа.
		ШаблонНазначения = МенеджерОбъекта.ШаблонНазначения(Форма.Объект);
		
		// Если текущий вариант обособления не по заказу.
		Если ШаблонНазначения.Заказ = Неопределено Тогда
			Форма.Объект.Назначение = Справочники.Назначения.НайтиПоШаблону(ШаблонНазначения);
		КонецЕсли;
		
	КонецЕсли;
	
	// Работа с флагом Обособленно
	ИмяЭлемента = ПорядокОбработкиДокумента.ИмяЭлементаФормыОбособленно;
	Служебные = Новый Структура("ИмяРеквизитаОбособленно");
	
	Если ИмяЭлемента <> Неопределено Тогда
		ЭлементФормы = Форма.Элементы[ИмяЭлемента];
		МассивПолей = СтрРазделить(ЭлементФормы.ПутьКДанным, ".");
		Служебные.ИмяРеквизитаОбособленно = МассивПолей[2];
	КонецЕсли; 
	ПорядокОбработкиДокумента.Вставить("Служебные", Служебные);
	УстановитьВидимостьЭлементовОбособленно(Форма);
	ПерезаполнитьСлужебныеРеквизитыТабличнойЧасти(Форма);	
	
КонецПроцедуры

// Используется в формах документов, в одноименных процедурах "ПослеЗаписиНаСервере".
// Заполняет реквизит формы "Отгружать обособленно" табличной части исходя из заполненности назначения.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма в которой необходимо инициализировать реквизиты связанные с использованием
//                             направлений деятельности.
//
Процедура ПослеЗаписиНаСервере(Форма) Экспорт

	ПерезаполнитьСлужебныеРеквизитыТабличнойЧасти(Форма);	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовНаФормах

// Используется в формах документов, в процедурах, приводящих к изменению направления деятельности.
// Инициализирует реквизиты формы, используемые при интерактивной работе пользователя. Заполняет назначение, исходя из
// направления деятельности. При необходимости актуализирует назначения в табличных частях документа, в соответствии с
// изменившимся направлением деятельности.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма в которой необходимо инициализировать реквизиты связанные с использованием
//                             направлений деятельности.
//
// Возвращаемое значение:
//  Массив - массив измененных строк табличной части документа.
//
Функция ПриИзмененииНаправленияДеятельности(Форма) Экспорт
	
	НайденныеСтроки = Новый Массив();
	
	Кэш = Форма.НаправленияДеятельностиКэшированныеЗначения;
	ПорядокОбработкиДокумента = Форма.МетаданныеФормы;
	
	Если Не Кэш.ИспользоватьНаправленияДеятельности Или Не Кэш.ИспользоватьОбособленноеОбеспечениеЗаказов Тогда
		Возврат НайденныеСтроки;
	КонецЕсли;
	
	Если ПорядокОбработкиДокумента.ЗаполнятьНазначениеВШапке Тогда
		
		// Инициализируем назначение для измененного документа.
		ОбъектФормы = Форма.Объект; // ДокументОбъект - 
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ОбъектФормы.Ссылка);
		ШаблонНазначения = МенеджерОбъекта.ШаблонНазначения(Форма.Объект);
		
		// Если шаблон заполнен полностью или текущий вариант обособления не по заказу.
		Если ЗначениеЗаполнено(ОбъектФормы.Ссылка) Или ШаблонНазначения.Заказ = Неопределено Тогда
			Назначение = Справочники.Назначения.НайтиПоШаблону(ШаблонНазначения);
		Иначе
			Назначение = Неопределено; // если такого назначения еще нет в базе то нужно чтобы не подбирались остатки по старому назначению.
		КонецЕсли;
		
		// Запись данных формы.
		Форма.Объект.Назначение = Назначение;
		
	КонецЕсли;
	
	Результат = Новый Массив();
	Если ПорядокОбработкиДокумента.ИменаТабличныхЧастейДляЗаполненияНазначения <> Неопределено Тогда
		
		// Получение данных формы.
		НаправлениеДеятельности = Форма.Объект.НаправлениеДеятельности;
		
		// Запись данных формы.
		Кэш.НазначениеПоУмолчанию = ТолкающееНазначение(НаправлениеДеятельности);
		
		ИмяРеквизитаПоЗаказу = ПорядокОбработкиДокумента.ИмяРеквизитаПоЗаказу;
		НазначениеПоУмолчанию = Неопределено;

		ЭтоНакладнаяПоЗаказу = Ложь;
		ЭтоРеквизитБулевогоТипа = Ложь;
		Если ИмяРеквизитаПоЗаказу <> Неопределено Тогда
			ЭтоНакладнаяПоЗаказу = Форма.Объект[ИмяРеквизитаПоЗаказу];
			ЭтоРеквизитБулевогоТипа = ТипЗнч(ЭтоНакладнаяПоЗаказу) = Тип("Булево");
		КонецЕсли;
		
		НазначениеПоУмолчанию = Неопределено;
		Если ИмяРеквизитаПоЗаказу = Неопределено
			Или ЭтоРеквизитБулевогоТипа И Не ЭтоНакладнаяПоЗаказу
			Или Не ЭтоРеквизитБулевогоТипа И Не ЗначениеЗаполнено(ЭтоНакладнаяПоЗаказу) Тогда
			НазначениеПоУмолчанию = Кэш.НазначениеПоУмолчанию;
		КонецЕсли;
		
		Результат = НайтиСтрокиВКоллекциях(
			Форма,
			ПорядокОбработкиДокумента.ИменаТабличныхЧастейДляЗаполненияНазначения,
			ПорядокОбработкиДокумента.УсловияОбработкиСтрок);
			
		Для Каждого Строка Из Результат Цикл
			Строка.Назначение = НазначениеПоУмолчанию;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ПорядокОбработкиДокумента.ИменаТабличныхЧастейДляОчисткиНекорректныхНазначений <> Неопределено Тогда
		
		// Получение данных формы.
		НаправлениеДеятельности = Форма.Объект.НаправлениеДеятельности;
		
		НайденныеСтроки = НайтиСтрокиВКоллекциях(
			Форма,
			ПорядокОбработкиДокумента.ИменаТабличныхЧастейДляОчисткиНекорректныхНазначений,
			ПорядокОбработкиДокумента.УсловияОбработкиСтрок);
			
		ПроверитьЗаполнитьНазначенияСтрокахКоллекции(НайденныеСтроки, НаправлениеДеятельности);
		
		Если Результат.Количество() > 0 Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Результат, НайденныеСтроки);
		Иначе
			Результат = НайденныеСтроки;
		КонецЕсли;
		
	КонецЕсли;
	
	ПерезаполнитьСлужебныеРеквизитыТабличнойЧасти(Форма);	
	
	// Работа с флагом Обособленно
	УстановитьВидимостьЭлементовОбособленно(Форма);

	Возврат Результат;
	
КонецФункции

// Используется в формах документов, в процедурах, приводящих к изменению флага по заказам.
// Управляет видимостью элементов.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма в которой необходимо отреагировать на изменение флага по заказам.
//
Процедура УстановитьВидимостьЭлементовОбособленно(Форма) Экспорт
	
	ПорядокОбработкиДокумента = Форма.МетаданныеФормы;
	НазначениеПоУмолчанию = Справочники.Назначения.ПустаяСсылка();
	Если ПорядокОбработкиДокумента.ИменаТабличныхЧастейДляЗаполненияНазначения <> Неопределено Тогда
		НазначениеПоУмолчанию = ТолкающееНазначение(Форма.Объект.НаправлениеДеятельности);
	КонецЕсли;
	ИмяЭлемента = ПорядокОбработкиДокумента.ИмяЭлементаФормыОбособленно;
	ИмяГруппыЭлементовКоманды = ПорядокОбработкиДокумента.ИмяГруппыЭлементовКомандыОбособленно;
	ИмяРеквизитаПоЗаказу = ПорядокОбработкиДокумента.ИмяРеквизитаПоЗаказу;
	
	Если ИмяЭлемента <> Неопределено Тогда
		
		ЭтоНакладнаяПоЗаказу = Форма.Объект[ИмяРеквизитаПоЗаказу];
		ЭтоРеквизитБулевогоТипа = ТипЗнч(ЭтоНакладнаяПоЗаказу) = Тип("Булево");
		ОтобразитьЭлементы = ЗначениеЗаполнено(НазначениеПоУмолчанию)
			И (ЭтоРеквизитБулевогоТипа И Не ЭтоНакладнаяПоЗаказу
				Или Не ЭтоРеквизитБулевогоТипа И Не ЗначениеЗаполнено(ЭтоНакладнаяПоЗаказу));
		Форма.Элементы[ИмяЭлемента].Видимость = ОтобразитьЭлементы;
		Форма.Элементы[ИмяГруппыЭлементовКоманды].Видимость = ОтобразитьЭлементы;
		
	КонецЕсли;
	 
КонецПроцедуры

// Используется в форме документа заказ переработчику при заполнении документа по спецификации.
// Инициализирует реквизиты формы, используемые при интерактивной работе пользователя. Заполняет назначение, исходя из
// направления деятельности.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма в которой необходимо инициализировать реквизиты связанные с использованием
//                             направлений деятельности.
//
Процедура ПриЗаполненииПоСпецификацииСервер(Форма) Экспорт
	
	Кэш = Форма.НаправленияДеятельностиКэшированныеЗначения;
	
	Если Не Кэш.ИспользоватьНаправленияДеятельности Или Не Кэш.ИспользоватьОбособленноеОбеспечениеЗаказов Тогда
		Возврат;
	КонецЕсли;
	
	// Получение данных формы.
	Назначение = Кэш.НазначениеПоУмолчанию;
	НаправлениеДеятельности = Форма.Объект.НаправлениеДеятельности;
	
	ЗаполнятьНазначение = ЗначениеЗаполнено(Назначение) Или ЗначениеЗаполнено(НаправлениеДеятельности);
	
	Если ЗаполнятьНазначение Тогда
		
		// Обработка.
		УсловияОтбора = Новый Соответствие();
		УсловияОтбора.Вставить("ВозвратныеОтходы", УсловияОбработкиНазначенийВСтроках("ТипНоменклатуры"));
		НайденныеСтроки = НайтиСтрокиВКоллекциях(Форма, "ВозвратныеОтходы", УсловияОтбора);
		ПроверитьЗаполнитьНазначенияСтрокахКоллекции(НайденныеСтроки, НаправлениеДеятельности);
		
	КонецЕсли;
	
КонецПроцедуры

// Используется в формах документов. Заполняет реквизит формы "Отгружать обособленно" табличной части исходя из заполненности назначения.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма в которой необходимо установить условное оформление.
//
Процедура УстановитьУсловноеОформлениеФлагаОбособленно(Форма) Экспорт
	
	ПорядокОбработкиДокумента = Форма.МетаданныеФормы;
	ИмяЭлемента = ПорядокОбработкиДокумента.ИмяЭлементаФормыОбособленно;
	Если ИмяЭлемента <> Неопределено Тогда
		
		ЭлементФормы = Форма.Элементы[ИмяЭлемента];
		МассивПолей = СтрРазделить(ЭлементФормы.ПутьКДанным, ".");
		ПутьКТипуНоменклатуры = МассивПолей[0] + "." + МассивПолей[1] + "." + "ТипНоменклатуры";

		УсловноеОформление = Форма.УсловноеОформление;
		Элемент = УсловноеОформление.Элементы.Добавить();
	
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяЭлемента);
		
		СписокТиповНоменклатуры = Новый СписокЗначений();
		СписокТиповНоменклатуры.Добавить(Перечисления.ТипыНоменклатуры.Товар);
		СписокТиповНоменклатуры.Добавить(Перечисления.ТипыНоменклатуры.Работа);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПутьКТипуНоменклатуры);
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
		ОтборЭлемента.ПравоеЗначение = СписокТиповНоменклатуры;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// В табличной части формы документа устанавливает флаг "Обособленно" для выделенных строк.
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма.
//  Установить - Булево - Истина если нужно установить флаг, Ложь - если нужно сбросить флаг.
Процедура УстановитьСнятьОтметкуОбособленно(Форма, Установить) Экспорт
	
	ПорядокОбработкиДокумента = Форма.МетаданныеФормы;
	Коллекция = 	КоллекцияОтгрузитьОбособленно(Форма);
	ТаблицаФормы = Форма.Элементы[ПорядокОбработкиДокумента.ИменаТабличныхЧастейДляЗаполненияНазначения];
	Для Каждого Идентификатор Из ТаблицаФормы.ВыделенныеСтроки Цикл
		СтрокаКоллекции = Коллекция.НайтиПоИдентификатору(Идентификатор);
		Если СтрокаКоллекции.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар
				Или СтрокаКоллекции.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа Тогда
					ОбновитьФлагИНазначениеВСтроке(Форма, СтрокаКоллекции, Установить);
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#Область Заполнение

// Заполняет реквизит "НаправлениеДеятельности" в строке по данным назначение или переданного параметра
//
// Параметры:
//  ТекущаяСтрока		 - Структура - данные обрабатываемой строки.
//  СтруктураДействий	 - Структура - описывает действия, где Ключ - наименование действия,
//  														   Значение - Структура - параметры действия.
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке.
//  ПараметрыДействия    - Структура, Неопределено - параметры для выполнения данного действия.
//
Процедура ЗаполнитьНаправлениеДеятельности(
			ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения, ПараметрыДействия = Неопределено) Экспорт

	Перем НаправлениеДеятельности;

	Если ЗначениеЗаполнено(ТекущаяСтрока.Назначение) Тогда

		СвойстваНазначение = КэшированныеЗначения.СвойстваНазначений.Получить(ТекущаяСтрока.Назначение);

		Если СвойстваНазначение = Неопределено Тогда

			СвойстваНазначений = Справочники.Назначения.СвойстваНазначений(ТекущаяСтрока.Назначение);
			СвойстваНазначение = СвойстваНазначений.Получить(ТекущаяСтрока.Назначение);

			КэшированныеЗначения.СвойстваНазначений.Вставить(ТекущаяСтрока.Назначение, СвойстваНазначение);

		КонецЕсли;

		НаправлениеДеятельности = СвойстваНазначение.НаправлениеДеятельности;

	ИначеЕсли ПараметрыДействия <> Неопределено Тогда

		НаправлениеДеятельности = ПараметрыДействия.НаправлениеДеятельности;

	КонецЕсли;

	ТекущаяСтрока.НаправлениеДеятельности = НаправлениеДеятельности;

КонецПроцедуры

// Заполняет направление из соглашения или договора
//
// Параметры:
//  НаправлениеДеятельности - СправочникСсылка.НаправленияДеятельности - направление деятельности, которое будет заполнено.
//  Соглашение - СправочникСсылка.СоглашенияСКлиентами, СправочникСсылка.СоглашенияСПоставщиками - Соглашение документа.
//  Договор - СправочникСсылка.ДоговорыКонтрагентов,
//            СправочникСсылка.ДоговорыКредитовИДепозитов,
//            СправочникСсылка.ДоговорыАренды,
//            СправочникСсылка.ДоговорыМеждуОрганизациями - Договор документа.
//
Процедура ЗаполнитьНаправлениеПоУмолчанию(НаправлениеДеятельности, Знач Соглашение = Неопределено, Знач Договор = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(Договор) Тогда
					
		НаправлениеДеятельности = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "НаправлениеДеятельности");
		
	ИначеЕсли ЗначениеЗаполнено(Соглашение) Тогда
		
		НаправлениеДеятельности = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Соглашение, "НаправлениеДеятельности");
		
	КонецЕсли;
		
КонецПроцедуры

// Используется в формах документов. Заполняет реквизит формы "Отгружать обособленно" табличной части исходя из заполненности назначения.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма в которой необходимо инициализировать реквизиты связанные с использованием
//                             направлений деятельности.
//
Процедура ПерезаполнитьСлужебныеРеквизитыТабличнойЧасти(Форма) Экспорт
	
	ПорядокОбработкиДокумента = Форма.МетаданныеФормы;
	ИмяЭлемента = ПорядокОбработкиДокумента.ИмяЭлементаФормыОбособленно;
	Если ИмяЭлемента <> Неопределено Тогда
		
		ИмяРеквизитаПоЗаказу = ПорядокОбработкиДокумента.ИмяРеквизитаПоЗаказу;
		Кэш = Форма.НаправленияДеятельностиКэшированныеЗначения;
		
		ЭтоНакладнаяПоЗаказу = Форма.Объект[ИмяРеквизитаПоЗаказу];
		ЭтоРеквизитБулевогоТипа = ТипЗнч(ЭтоНакладнаяПоЗаказу) = Тип("Булево");
		
		Если ЗначениеЗаполнено(Кэш.НазначениеПоУмолчанию)
			И (ЭтоРеквизитБулевогоТипа И Не ЭтоНакладнаяПоЗаказу
				Или Не ЭтоРеквизитБулевогоТипа И Не ЗначениеЗаполнено(ЭтоНакладнаяПоЗаказу)) Тогда
			ОбновитьФлагИзНазначенияТабличнойЧасти(Форма);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Определяет образует ли хозяйственная операция доход
//
// Параметры:
//  ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция документа или договора.
//
// Возвращаемое значение:
// 		Булево - Истина, если образуется доход.
//
Функция ХозяйственнаяОперацияОбразуетДоход(ХозяйственнаяОперация) Экспорт
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиенту
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиентуРеглУчет
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКомиссионногоТовара
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияВРозницу
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтгрузкаБезПереходаПраваСобственности
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОтКомиссионера
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОтРозничногоПокупателя
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровОтКлиента 
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтчетКомиссионера
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтчетКомиссионераОСписании
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПроизводствоИзДавальческогоСырья
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыкупТоваровХранителем
		//Интеркампани
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию 
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратПоКомиссииМеждуОрганизациями 
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровМеждуОрганизациями
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтчетПоКомиссииМеждуОрганизациями
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоставкаПодПринципала
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствВДругуюОрганизацию Тогда
		
		Возврат Истина;
	
	Иначе
	
		Возврат Ложь;
	
	КонецЕсли;

КонецФункции

// Определяет образует ли хозяйственная операция актив
//
// Параметры:
//  ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция документа или договора.
//
// Возвращаемое значение:
// 		Булево - Истина, если образуется актив.
//
Функция ХозяйственнаяОперацияОбразуетАктив(ХозяйственнаяОперация) Экспорт
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаТоварыВПути
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаФактуровкаПоставки
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаРеглУчет
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаЧерезПодотчетноеЛицо 
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпортуТоварыВПути
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСТоварыВПути
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСФактуровкаПоставки
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровКомитенту
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровПоставщику
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОформлениеГТДБрокером
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОформлениеГТДСамостоятельно 
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПроизводствоУПереработчика
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтчетКомитенту
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтчетКомитентуОСписании
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыкупПринятыхНаХранениеТоваров
		
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеТоваровПоТребованию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаВЭксплуатацию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.Ремонт
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.Модернизация
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаПереработчику
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОтПереработчика
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РазборкаТоваров
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеИзПроизводства
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СторноСписанияНаРасходы
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОприходованиеЗаСчетДоходов
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОприходованиеЗаСчетРасходов
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОприходованиеПриВыбытииОС
		
//++ НЕ УТКА
//++ Устарело_Производство21
		ИЛИ ХозяйственнаяОперация = Тип("ДокументСсылка.ЗаказНаПроизводство")
//-- Устарело_Производство21		
		ИЛИ ХозяйственнаяОперация = Тип("ДокументСсылка.ЗаказНаПроизводство2_2")
//-- НЕ УТКА
		
		//Интеркампани
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию 
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратПоКомиссииМеждуОрганизациями 
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровМеждуОрганизациями
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтчетПоКомиссииМеждуОрганизациями 
		
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОплатаПоставщику
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОплатаДенежныхСредствВДругуюОрганизацию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтДругойОрганизации Тогда
		
		Возврат Истина;
	
	Иначе
	
		Возврат НаправленияДеятельностиЛокализацияСервер.ХозяйственнаяОперацияОбразуетАктив(ХозяйственнаяОперация);
	
	КонецЕсли;

КонецФункции

// Устанавливает видимость направления деятельности по порядку расчетов документа.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма, в которой было находится элемент группы финансового учета.
//	ЭтоЗаказ - Булево - Истина - Документ является заказом.
//	ПоЗаказу - Булево - Истина - Документ введен на основании заказа/заказов.
//
Процедура УстановитьВидимостьНаправленияДеятельности(Форма, ЭтоЗаказ = Ложь, ПоЗаказу = Ложь) Экспорт
	
	ВидимостьЭлемента = Ложь;
	ПорядокРасчетов = Форма.Объект.ПорядокРасчетов;
	
	Если ЭтоЗаказ Тогда
		ВидимостьЭлемента = ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоЗаказам
			Или ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоЗаказамНакладным;
	ИначеЕсли ПоЗаказу Тогда
		ВидимостьЭлемента = ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоНакладным
			Или ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамНакладным
	Иначе
		ВидимостьЭлемента = ПорядокРасчетов <> Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов;
	КонецЕсли;
	
	Форма.Элементы.НаправлениеДеятельности.Видимость = ВидимостьЭлемента;
	
КонецПроцедуры

// Определяет, порядок формирования назначения при фиксации обособленных потребностей в заказах по данному направлению деятельности.
//
// Параметры:
//  Ссылка - СправочникСсылка.НаправленияДеятельности - направление деятельности, которое может быть указано в заказе.
//
// Возвращаемое значение:
//  Булево - Истина, если данное направление деятельности будет использоваться в аналитике обособленной потребности
//           заказа, Ложь - в противном случае.
//
Функция ЭтоНаправлениеДеятельностиСОбособлениемТоваровИРабот(Ссылка) Экспорт
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "УчетЗатрат");
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

// Конструктор структуры парамтеров встраивания направлений деятельности в документ.
//  Возвращаемое значение:
//   Структура - структура полей.
Функция ПорядокОбработкиДокументаПриИзмененииНаправленияДеятельности() Экспорт
	
	ПорядокОбработкиДокумента = Новый Структура();
	ПорядокОбработкиДокумента.Вставить("ИменаТабличныхЧастейДляЗаполненияНазначения",          Неопределено);
	ПорядокОбработкиДокумента.Вставить("ИменаТабличныхЧастейДляОчисткиНекорректныхНазначений", Неопределено);
	ПорядокОбработкиДокумента.Вставить("УсловияОбработкиСтрок",                                Новый Соответствие());
	ПорядокОбработкиДокумента.Вставить("ЗаполнятьНазначениеВШапке",                            Ложь);
	ПорядокОбработкиДокумента.Вставить("ИмяЭлементаФормыОбособленно",                          Неопределено);
	ПорядокОбработкиДокумента.Вставить("ИмяГруппыЭлементовКомандыОбособленно",                 Неопределено);
	ПорядокОбработкиДокумента.Вставить("ИмяРеквизитаПоЗаказу",                                 Неопределено);
		
	Возврат ПорядокОбработкиДокумента;
	
КонецФункции

Функция УсловияОбработкиНазначенийВСтроках(ШаблоныУсловий) Экспорт
	
	Условия = СтрРазделить(ШаблоныУсловий, ",");
	
	УсловияОбработкиСтрок = Новый Массив();
	
	Если Условия.Найти("ТипНоменклатуры") <> Неопределено И Условия.Найти("КодСтроки") <> Неопределено Тогда
		
		СтруктураПолей = Новый Структура();
		СтруктураПолей.Вставить("ТипНоменклатуры", Перечисления.ТипыНоменклатуры.Товар);
		СтруктураПолей.Вставить("КодСтроки", 0);
		
		УсловияОбработкиСтрок.Добавить(СтруктураПолей);
		
		СтруктураПолей = Новый Структура();
		СтруктураПолей.Вставить("ТипНоменклатуры", Перечисления.ТипыНоменклатуры.Работа);
		СтруктураПолей.Вставить("КодСтроки", 0);
		
		УсловияОбработкиСтрок.Добавить(СтруктураПолей);
		
	ИначеЕсли Условия.Найти("ТипНоменклатуры") <> Неопределено Тогда
		
		СтруктураПолей = Новый Структура();
		СтруктураПолей.Вставить("ТипНоменклатуры", Перечисления.ТипыНоменклатуры.Товар);
		
		УсловияОбработкиСтрок.Добавить(СтруктураПолей);
		
		СтруктураПолей = Новый Структура();
		СтруктураПолей.Вставить("ТипНоменклатуры", Перечисления.ТипыНоменклатуры.Работа);
		
		УсловияОбработкиСтрок.Добавить(СтруктураПолей);
		
	КонецЕсли;
	
	Возврат УсловияОбработкиСтрок;
	
КонецФункции

// Конструктор структуры по умолчанию для использования в функциях ОписаниеФормыДокументаДляЗаполненияРеквизитовСвязанныхСНаправлениемДеятельности
// модулей менеджеров документов.
//
// Возвращаемое значение:
//  Структура - структура с полями:
//   *ОформляетсяПоЗаказу - Булево - признак, что строки табличных частей могут быть оформлены по заказу.
//   *ЭтоИсточникПотребности - Булево - признак, что документ является документом фиксации обособленной потребности (заказом).
//   *ЕстьНазначениеВТЧ - Булево - признак, что в строках табличных частей есть реквизит назначение.
//   *ВТЧНазначениеОтгрузки - Булево - признак, что в строках табличных частей реквизит назначение используется для указания
//                            назначения отгружаемых товаров и работ, а не принимаемых).
//   *ТабЧасти - Структура - описание табличной части документа, используется для переопределения общих параметров, заданных для
//                           всех табличных частей.
//
Функция СтруктураОбъекта() Экспорт
	
	ФильтрХозОперация = Новый Массив();
	ФильтрХозОперация.Добавить("ОТГРУЗКА");
	ФильтрХозОперация.Добавить("ПОСТУПЛЕНИЕ");
	ОписаниеТабЧасти = Новый Структура("ФильтрХозОперация, ОформляетсяПоЗаказу", ФильтрХозОперация, Истина);
	
	ТабЧасти = Новый Структура();
	ТабЧасти.Вставить("Товары", ОписаниеТабЧасти);
	
	СтруктураОбъекта = Новый Структура();
	СтруктураОбъекта.Вставить("ТабЧасти", ТабЧасти);
	СтруктураОбъекта.Вставить("ОформляетсяПоЗаказу", Истина);
	СтруктураОбъекта.Вставить("ЭтоИсточникПотребности", Ложь);
	СтруктураОбъекта.Вставить("ЕстьНазначениеВТЧ", Истина);
	СтруктураОбъекта.Вставить("ВТЧНазначениеОтгрузки", Ложь);
	
	Возврат СтруктураОбъекта;
	
КонецФункции

// Возвращает назначение по направлению деятельности.
//
// Параметры:
//  НаправлениеДеятельности - СправочникСсылка.НаправленияДеятельности - направление деятельности.
//
// Возвращаемое значение:
//  СправочникСсылка.Назначения - назначение, связанное с направлением деятельности.
//
Функция ТолкающееНазначение(НаправлениеДеятельности) Экспорт
	
	Назначение = Справочники.Назначения.ПустаяСсылка();
	Если ЗначениеЗаполнено(НаправлениеДеятельности) И ПолучитьФункциональнуюОпцию("ИспользоватьОбособленноеОбеспечениеЗаказов") Тогда
		
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НаправлениеДеятельности, "УчетЗатрат, Назначение");
		Если Реквизиты.УчетЗатрат Тогда
			
			Назначение = Реквизиты.Назначение;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Назначение;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьЗаполнитьНазначенияСтрокахКоллекции(Массив, НаправлениеДеятельности)
	
	Если НЕ ЗначениеЗаполнено(Массив) ИЛИ НЕ ЗначениеЗаполнено(НаправлениеДеятельности) Тогда
		Возврат;
	КонецЕсли;
	
	Таблица = Новый ТаблицаЗначений();
	Таблица.Колонки.Добавить("Назначение", Новый ОписаниеТипов("СправочникСсылка.Назначения"));
	Таблица.Колонки.Добавить("Индекс",     Новый ОписаниеТипов("Число"));
	Для Индекс = 0 По Массив.ВГраница() Цикл
		
		НоваяСтрока = Таблица.Добавить();
		НоваяСтрока.Индекс = Индекс;
		НоваяСтрока.Назначение = Массив[Индекс].Назначение;
		
	КонецЦикла;
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Таблица.Индекс     КАК Индекс,
		|	Таблица.Назначение КАК Назначение
		|ПОМЕСТИТЬ ВтТаблица
		|ИЗ
		|	&Таблица КАК Таблица
		|;
		|
		|////////////////////////////////////
		|ВЫБРАТЬ
		|	Таблица.Индекс  КАК Индекс,
		|	НЕОПРЕДЕЛЕНО    КАК Назначение
		|ИЗ
		|	ВтТаблица КАК Таблица
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Назначения КАК СпрНазначения
		|		ПО СпрНазначения.Ссылка = Таблица.Назначение
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НаправленияДеятельности КАК СпрНаправления
		|		ПО СпрНаправления.Ссылка = &НаправлениеДеятельности
		|
		|ГДЕ
		|	ЕСТЬNULL(СпрНаправления.УчетЗатрат, Ложь)
		|	И НЕ СпрНазначения.Ссылка ЕСТЬ NULL
		|	И СпрНазначения.НаправлениеДеятельности <> СпрНаправления.Ссылка";
		
	Запрос.УстановитьПараметр("НаправлениеДеятельности", НаправлениеДеятельности);
	Запрос.УстановитьПараметр("Таблица",                 Таблица);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Массив[Выборка.Индекс].Назначение = Выборка.Назначение;
	КонецЦикла;
	
КонецПроцедуры

Функция НайтиСтрокиВКоллекциях(Форма, ИменаТабЧастей, УсловияОтбора)
	
	Табчасти = СтрРазделить(ИменаТабЧастей, ",");
	НайденныеСтроки = Новый Массив();
	Для Каждого ИмяТабЧасти Из Табчасти Цикл
		
		УсловияОтбораТабЧасти = УсловияОтбора.Получить(ИмяТабЧасти);
		Для Каждого СтрокаТЧ Из Форма.Объект[ИмяТабЧасти] Цикл
			
			Если УсловияОтбораТабЧасти = Неопределено Или УдовлетворяетОтбору(СтрокаТЧ, УсловияОтбораТабЧасти) Тогда
				
				НайденныеСтроки.Добавить(СтрокаТЧ);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат НайденныеСтроки;
	
КонецФункции

Функция НаправленияДеятельностиКэшированныеЗначения()
	
	КэшированныеЗначения = Новый Структура();
	КэшированныеЗначения.Вставить("ИспользоватьНаправленияДеятельности");
	КэшированныеЗначения.Вставить("ИспользоватьОбособленноеОбеспечениеЗаказов");
	КэшированныеЗначения.Вставить("НазначениеПоУмолчанию");
	Возврат КэшированныеЗначения;
	
КонецФункции

Функция УдовлетворяетОтбору(ПроверяемоеЗначение, УсловияОтбора)
	
	Результат = Истина;
	Для Каждого Условие Из УсловияОтбора Цикл
		
		Результат = Истина;
		Для Каждого Поле Из Условие Цикл
			
			Если ПроверяемоеЗначение[Поле.Ключ] <> Поле.Значение Тогда
				
				Результат = Ложь;
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если Результат Тогда
			Возврат Результат;
		КонецЕсли;
		
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

Процедура ОбновитьФлагИНазначениеВСтроке(Форма, СтрокаКоллекции, Установить)
	
	Служебные = Форма.МетаданныеФормы.Служебные;
	СтрокаКоллекции[Служебные.ИмяРеквизитаОбособленно] = Установить;
	СтрокаКоллекции.Назначение = ?(Установить,
		Форма.НаправленияДеятельностиКэшированныеЗначения.НазначениеПоУмолчанию,
		Справочники.Назначения.ПустаяСсылка());
	
КонецПроцедуры

Процедура ОбновитьФлагИзНазначенияТабличнойЧасти(Форма)
	Служебные = Форма.МетаданныеФормы.Служебные;
	Коллекция = КоллекцияОтгрузитьОбособленно(Форма);
	Для Каждого СтрокаКоллекции Из Коллекция Цикл
		СтрокаКоллекции[Служебные.ИмяРеквизитаОбособленно] = ЗначениеЗаполнено(СтрокаКоллекции.Назначение);
	КонецЦикла;
КонецПроцедуры

Функция КоллекцияОтгрузитьОбособленно(Форма)
	ПорядокОбработкиДокумента = Форма.МетаданныеФормы;
	ИмяЭлемента = ПорядокОбработкиДокумента.ИмяЭлементаФормыОбособленно;
	ЭлементФормы = Форма.Элементы[ИмяЭлемента];
	МассивПолей = СтрРазделить(ЭлементФормы.ПутьКДанным, ".");
	Коллекция = Форма[МассивПолей[0]][МассивПолей[1]];
	Возврат Коллекция; 
КонецФункции
 
#Область УсловноеОформление

// Устанавливает условное для реквизита НаправлениеДеятельности.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма, для которой настраивается условное оформление.
//
Процедура УстановитьУсловноеОформлениеНаправленияДеятельности(Форма) Экспорт
	
	//
	Элемент = Форма.УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеНаправления = Форма.Элементы.НаправлениеДеятельности; // ПолеФормы - 
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ПолеНаправления.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НаправлениеДеятельностиОбязательно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НаправлениеДеятельности");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	//
	Элемент = Форма.УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ПолеНаправления.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НаправлениеДеятельностиОбязательно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НаправлениеДеятельности");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти




