
#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.Владелец) Тогда
		ВызватьИсключение НСтр("ru = 'Предусмотрено открытие обработки только из документов.';
								|en = 'Data processor can be opened only from documents.'");
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
	
	ЗаполнитьТаблицуТовары();
	
	СформироватьИнформационнуюНадписьОтборы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы
		И Модифицированность Тогда
		
		Отказ = Истина;
		ТекстПредупреждения = НСтр("ru = 'Данные были изменены. Все изменения будут потеряны.';
									|en = 'All changes made to the data will be lost.'");
		
		Возврат;
		
	КонецЕсли;
	
	Если ПеренестиВДокумент
		Или ВыполняетсяЗакрытие
		Или Не ТоварыПодобраны Тогда
		
		Возврат;
		
	Иначе
		Отказ = Истина;
		
		ТекстВопроса       = НСтр("ru = 'Подобранные товары не перенесены в документ. Перенести?';
									|en = 'Selected items are not added to the document. Do you want to add them?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		Если РазрешитьПереносРезультатовВДокумент() Тогда
			ПеренестиВДокумент = Истина;
			ВыполняетсяЗакрытие = Истина;
			
			Закрыть();
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	ВыполняетсяЗакрытие = Истина;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ПеренестиВДокумент Тогда
		Структура = Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище());
		
		ОповеститьОВыборе(Структура);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыПометкаПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	РасчитатьКоличествоВСтроке(Объект.Товары, ТекущиеДанные, ТоварыПодобраны);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПодобраноПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ТекущиеДанные.Пометка = ТекущиеДанные.КоличествоПодобрано > 0;
	
	РасчитатьКоличествоВСтроке(Объект.Товары, ТекущиеДанные, ТоварыПодобраны);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ОчиститьСообщения();
	
	Если РазрешитьПереносРезультатовВДокумент() Тогда
		ПеренестиВДокумент = Истина;
		
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	ОтметитьВсеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометку(Команда)
	
	СнятьПометкуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьТаблицуТовары();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Установка условного оформления для элемента 'КоличествоПодобрано' табличной части 'Товары'.
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыКоличествоПодобрано.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.Пометка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТовары()
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыОрганизаций) Тогда
		
		Объект.Товары.Очистить();
		
		Возврат;
		
	Иначе
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	КлючиАналитики.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ КлючиАналитики
		|ИЗ
		|	Справочник.КлючиАналитикиУчетаНоменклатуры КАК КлючиАналитики
		|ГДЕ
		|	КлючиАналитики.МестоХранения = &Договор
		|;
		|
		|//////////////////////////////////////////////////////////////////////////////// 1
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТоварыПереданные.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
		|	ТоварыПереданные.НомерГТД                   КАК НомерГТД,
		|	ТоварыПереданные.КоличествоОстаток          КАК КоличествоОстаток
		|ПОМЕСТИТЬ ТоварыПереданные
		|ИЗ
		|	РегистрНакопления.ТоварыОрганизаций.Остатки(&Период,
		|			АналитикаУчетаНоменклатуры В
		|					(ВЫБРАТЬ
		|						КлючиАналитики.Ссылка
		|					ИЗ
		|						КлючиАналитики КАК КлючиАналитики)
		|			И Организация = &Организация) КАК ТоварыПереданные
		|
		|ГДЕ
		|	ТоварыПереданные.КоличествоОстаток > 0
		|;
		|
		|//////////////////////////////////////////////////////////////////////////////// 2
		|ВЫБРАТЬ
		|	ЕСТЬNULL(КлючиАналитики.Номенклатура,
		|		ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК Номенклатура,
		|	ЕСТЬNULL(КлючиАналитики.Характеристика,
		|		ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)) КАК Характеристика,
		|	ВЫБОР
		|		КОГДА Товары.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
		|			ТОГДА ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|		ИНАЧЕ КлючиАналитики.Назначение
		|	КОНЕЦ                                         КАК Назначение,
		|	ЕСТЬNULL(КлючиАналитики.Серия,
		|		ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)) КАК Серия,
		|	ТоварыПереданные.НомерГТД                     КАК НомерГТД,
		|	ТоварыПереданные.НомерГТД.СтранаПроисхождения КАК СтранаПроисхождения,
		|	СУММА(ТоварыПереданные.КоличествоОстаток)     КАК КоличествоОсталосьПодобрать,
		|	СУММА(ТоварыПереданные.КоличествоОстаток)     КАК КоличествоОстаток
		|ИЗ
		|	ТоварыПереданные КАК ТоварыПереданные
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК КлючиАналитики
		|		ПО ТоварыПереданные.АналитикаУчетаНоменклатуры = КлючиАналитики.Ссылка
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Товары
		|		ПО КлючиАналитики.Номенклатура = Товары.Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ЕСТЬNULL(КлючиАналитики.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)),
		|	ЕСТЬNULL(КлючиАналитики.Характеристика, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)),
		|	ВЫБОР
		|		КОГДА Товары.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
		|			ТОГДА ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|		ИНАЧЕ КлючиАналитики.Назначение
		|	КОНЕЦ,
		|	ЕСТЬNULL(КлючиАналитики.Серия, ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)),
		|	ТоварыПереданные.НомерГТД
		|
		|УПОРЯДОЧИТЬ ПО
		|	Номенклатура,
		|	Характеристика,
		|	Серия,
		|	ВЫБОР
		|		КОГДА Товары.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
		|			ТОГДА ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|		ИНАЧЕ КлючиАналитики.Назначение
		|	КОНЕЦ,
		|	НомерГТД";
		
	КонецЕсли;
	
	ДатаПериода = КонецДня(ТекущаяДатаСеанса());
	Период      = Новый Граница(ДатаПериода, ВидГраницы.Включая);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("Период",      Период);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Договор",     Объект.Договор);
	
	Объект.Товары.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура СформироватьИнформационнуюНадписьОтборы()
	
	ИнформационнаяНадписьОтборы = НСтр("ru = 'Отбор по: %Организация%, %Партнер%, %Договор%.';
										|en = 'Filter by: %Организация%, %Партнер%, %Договор%.'");
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы, "%Организация%", Объект.Организация);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы, "%Партнер%",     Объект.Владелец);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы, "%Договор%",     Объект.Договор);
	
КонецПроцедуры

&НаСервере
Функция РазрешитьПереносРезультатовВДокумент()
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

&НаСервере
Функция АдресТоваровВХранилище()
	
	Отбор = Новый Структура("Пометка", Истина);
	ОтобранныеТовары      = Объект.Товары.Выгрузить(Отбор);
	
	Возврат ПоместитьВоВременноеХранилище(ОтобранныеТовары, УникальныйИдентификатор);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура РасчитатьКоличествоВСтроке(Товары, ТекущиеДанные, ФормаМодифицирована)
	
	ТекущиеДанные.КоличествоОсталосьПодобрать = ТекущиеДанные.КоличествоОстаток - ТекущиеДанные.КоличествоПодобрано;
	
	Отбор = Новый Структура("Пометка", Истина);
	ПомеченныеСтроки = Товары.НайтиСтроки(Отбор);
	
	ТоварыПодобраны = ПомеченныеСтроки.Количество() > 0;
	
КонецПроцедуры

&НаСервере
Процедура ОтметитьВсеНаСервере()
	
	Модифицированность = Истина;
	
	Для Каждого СтрокаТоваров Из Объект.Товары Цикл
		СтрокаТоваров.КоличествоПодобрано = СтрокаТоваров.КоличествоОстаток;
		СтрокаТоваров.Пометка = Истина;
		
		РасчитатьКоличествоВСтроке(Объект.Товары, СтрокаТоваров, ТоварыПодобраны);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СнятьПометкуНаСервере()
	
	Для Каждого СтрокаТоваров Из Объект.Товары Цикл
		СтрокаТоваров.Пометка = Ложь;
		
		РасчитатьКоличествоВСтроке(Объект.Товары, СтрокаТоваров, ТоварыПодобраны);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти
