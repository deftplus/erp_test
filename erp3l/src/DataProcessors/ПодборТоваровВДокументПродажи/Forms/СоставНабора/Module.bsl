#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	
	ВидЦены                   = Параметры.ВидЦены;
	Соглашение                = Параметры.Соглашение;
	Цена                      = Параметры.Цена;
	Дата                      = Параметры.Дата;
	ДатаОтгрузки              = Параметры.ДатаОтгрузки;
	Склад                     = Параметры.Склад;
	Номенклатура              = Параметры.Номенклатура;
	Характеристика            = Параметры.Характеристика;
	Валюта                    = Параметры.Валюта;
	ЦенаВключаетНДС           = Параметры.ЦенаВключаетНДС;
	ТипНоменклатуры           = Параметры.ТипНоменклатуры;
	ОтображатьОстатки         = Параметры.ОтображатьОстатки;
	
	Склады.ЗагрузитьЗначения(Параметры.Склады);
	ВидыЦен.ЗагрузитьЗначения(Параметры.ВидыЦен);
	
	Элементы.ВидЦены.ТолькоПросмотр     = Не Параметры.РедактироватьВидЦены;
	Элементы.ВидЦены.ПропускатьПриВводе = Не Параметры.РедактироватьВидЦены;
	Элементы.Цена.ТолькоПросмотр        = Не Параметры.РедактироватьЦену;
	Элементы.Цена.ПропускатьПриВводе    = Не Параметры.РедактироватьЦену;
	
	НаименованиеТовара = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(Параметры.Номенклатура, Параметры.Характеристика);
	ТекстЗаголовка     = НСтр("ru = 'Состав набора ""%НаименованиеТовара%""';
								|en = 'Set content ""%НаименованиеТовара%""'");
	ТекстЗаголовка     = СтрЗаменить(ТекстЗаголовка, "%НаименованиеТовара%", НаименованиеТовара); 
	
	Заголовок = ТекстЗаголовка;
	
	Если Параметры.СкрытьЦену Тогда
		Элементы.Цена.Видимость    = Ложь;
		Элементы.Валюта.Видимость  = Ложь;
		Элементы.ВидЦены.Видимость = Ложь;
		ЭтаФорма.АвтоЗаголовок     = Ложь;
	КонецЕсли;
	
	Если Не Параметры.ИспользоватьДатыОтгрузки Тогда
		Элементы.ДатаОтгрузки.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.ЭтоУслуга Тогда
		ДатаОтгрузки = '00010101';
		Склад = Справочники.Склады.ПустаяСсылка();
		Элементы.ДатаОтгрузки.Видимость = Ложь;
	КонецЕсли;
	
	Если Не Параметры.ИспользоватьСкладыВТабличнойЧасти Тогда
		Склад = Неопределено;
	КонецЕсли;
	
	Элементы.Склад.Видимость = (Не Параметры.ЭтоУслуга Или Не Параметры.ИспользоватьДатыОтгрузки) 
		И Параметры.Склады.Количество() > 1 И Параметры.ИспользоватьСкладыВТабличнойЧасти;
	ОбщегоНазначенияУТКлиентСервер.ДобавитьПараметрВыбора(Элементы.Склад, "Ссылка", Параметры.Склады);
	
	КоличествоУпаковок = 1;
	
	// Заполнить список выбора видов цен.
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыЦен.Ссылка КАК ВидЦен
	|ИЗ
	|	Справочник.ВидыЦен КАК ВидыЦен
	|ГДЕ
	|	НЕ ВидыЦен.ПометкаУдаления
	|	И ВидыЦен.ИспользоватьПриПродаже
	|	И ВидыЦен.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДействияВидовЦен.Действует)
	|	И ВидыЦен.ЦенаВключаетНДС = &ЦенаВключаетНДС");
	
	Запрос.УстановитьПараметр("ЦенаВключаетНДС", ЦенаВключаетНДС);
	
	Элементы.ВидЦены.СписокВыбора.Очистить();
	Элементы.ВидЦены.СписокВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидЦен"));
	Элементы.ВидЦены.СписокВыбора.Добавить(Справочники.ВидыЦен.ПустаяСсылка(), НСтр("ru = '<произвольная>';
																					|en = '<custom>'"));
	
	Элементы.Цена.ТолькоПросмотр = ЗначениеЗаполнено(ВидЦены);
	Элементы.Цена.ПропускатьПриВводе = ЗначениеЗаполнено(ВидЦены);

	// Настроить видимость и установить значения реквизитов для редактирования ручных скидок, наценок.
	СуммаДокумента = КоличествоУпаковок * Цена;
	
	Если Не Параметры.ИспользоватьРучныеСкидкиВПродажах Или Параметры.СкрыватьРучныеСкидки Тогда
		
		Элементы.ГруппаПараметрыСкидкиНаценки.Видимость = Ложь;
		
	Иначе
		
		// Установить свойства элементов относящихся к скидкам (наценкам).
		ИспользоватьОграниченияРучныхСкидок = (ПолучитьФункциональнуюОпцию("ИспользоватьОграниченияРучныхСкидокВПродажахПоПользователям")
		                                      Или ПолучитьФункциональнуюОпцию("ИспользоватьОграниченияРучныхСкидокВПродажахПоСоглашениям"));
		
		Если ИспользоватьОграниченияРучныхСкидок Тогда
			
			СтруктураТаблиц = ПолучитьИзВременногоХранилища(Параметры.АдресВоВременномХранилище);
			
			МаксимальныйПроцентСкидки  = СтруктураТаблиц.Ограничения[0].МаксимальныйПроцентРучнойСкидки;
			МаксимальныйПроцентНаценки = СтруктураТаблиц.Ограничения[0].МаксимальныйПроцентРучнойНаценки;
			
			Если МаксимальныйПроцентСкидки > 0 Тогда
				Элементы.ПроцентСкидки.КнопкаСпискаВыбора = Истина;
				Элементы.ПроцентСкидки.СписокВыбора.Добавить(МаксимальныйПроцентСкидки, Формат(МаксимальныйПроцентСкидки, "ЧДЦ=2"));
			КонецЕсли;
			
			Если МаксимальныйПроцентНаценки > 0 Тогда
				Элементы.ПроцентНаценки.КнопкаСпискаВыбора = Истина;
				Элементы.ПроцентНаценки.СписокВыбора.Добавить(МаксимальныйПроцентНаценки, Формат(МаксимальныйПроцентНаценки, "ЧДЦ=2"));
			КонецЕсли;
			
		КонецЕсли;
		
		Элементы.НадписьМаксимальнаяРучнаяСкидка.Видимость  = ИспользоватьОграниченияРучныхСкидок;
		Элементы.НадписьМаксимальнаяРучнаяСкидка.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Макс. скидка: %1%2';
				|en = 'Max. discount: %1%2'"),
			МаксимальныйПроцентСкидки,
			"%");
		
		Элементы.НадписьМаксимальнаяРучнаяНаценка.Видимость = ИспользоватьОграниченияРучныхСкидок;
		Элементы.НадписьМаксимальнаяРучнаяНаценка.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Макс. наценка: %1%2';
				|en = 'Max markup: %1%2'"),
			МаксимальныйПроцентНаценки,
			"%");
		
		Элементы.НадписьМаксимальнаяСкидкаНеОграничена.Видимость   = Не ИспользоватьОграниченияРучныхСкидок;
		Элементы.НадписьМаксимальнаяНаценкаНеОграничена.Видимость  = Не ИспользоватьОграниченияРучныхСкидок;
		
		// Установить варианты выбора ручной скидки (наценки).
		Элементы.ВариантПредоставления.СписокВыбора.Добавить(1, НСтр("ru = 'Скидка';
																	|en = 'Discount'"));
		Элементы.ВариантПредоставления.СписокВыбора.Добавить(2, НСтр("ru = 'Наценка';
																	|en = 'Markup'"));
		
		// Установить значение варианта предоставления при открытии.
		ВариантПредоставления = 1; // Скидка
		Элементы.ВариантыПредоставления.ТекущаяСтраница = Элементы.ВариантыПредоставления.ПодчиненныеЭлементы.Скидка;
		
	КонецЕсли;
	
	ТекстЗаголовкаЦены = НСтр("ru = 'Цена';
								|en = 'Price'");
	
	Если ЗначениеЗаполнено(Валюта) Тогда
		ТекстЗаголовкаЦены = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Цена (%1)';
																							|en = 'Price (%1)'"), Валюта);
	КонецЕсли;
	
	Элементы.СоставНабораЦена.Заголовок = ТекстЗаголовкаЦены;
	
	РассчитатьПараметрыНабора();
	
	КодФормы = "Обработка_ПодборТоваровВДокументПродажи_Форма";
	
	Элементы.ОстаткиТоваров.Видимость = ОтображатьОстатки;
	ПодборТоваровКлиентСервер.УстановитьТекстНадписиОтображатьОстатки(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидЦеныПриИзменении(Элемент)
	
	ВидЦеныПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенаПриИзменении(Элемент)
	
	ВидЦены = Неопределено;
	
	РассчитатьПараметрыНабора();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантПредоставленияПриИзменении(Элемент)
	
	Если ВариантПредоставления = 1 Тогда
		Элементы.ВариантыПредоставления.ТекущаяСтраница = Элементы.ВариантыПредоставления.ПодчиненныеЭлементы.Скидка;
	Иначе
		Элементы.ВариантыПредоставления.ТекущаяСтраница = Элементы.ВариантыПредоставления.ПодчиненныеЭлементы.Наценка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьНабор(Команда)
	
	Отказ = Ложь;
	ОчиститьСообщения();
	
	Если КоличествоУпаковок = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено количество';
																|en = 'Quantity is not filled in'"),,"КоличествоУпаковок",,Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	
	Если ВариантПредоставления = 1 Тогда
		ПроцентРучнойСкидки = ПроцентРучнойСкидкиНаценки;
	Иначе
		ПроцентРучнойСкидки = -ПроцентРучнойСкидкиНаценки;
	КонецЕсли;
	
	Если ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Набор") Тогда
		
		ПодобранныеТовары = ПодобранныеТовары();
		
	Иначе
		
		ПодобранныеТовары = Новый Массив;
		
		ПараметрыТовара = ПодборТоваровКлиентСервер.ПараметрыТовара();
		ПараметрыТовара.Номенклатура        = Номенклатура;
		ПараметрыТовара.Характеристика      = Характеристика;
		ПараметрыТовара.Цена                = Цена;
		ПараметрыТовара.ВидЦены             = ВидЦены;
		ПараметрыТовара.КоличествоУпаковок  = КоличествоУпаковок;
		ПараметрыТовара.Склад               = Склад;
		ПараметрыТовара.ДатаОтгрузки        = ДатаОтгрузки;
		
		ПараметрыТовара.ПроцентРучнойСкидки = ПроцентРучнойСкидки;
		
		ПодобранныеТовары.Добавить(ПараметрыТовара);
		
	КонецЕсли;
	
	Результат = Новый Структура("ПодобранныеТовары, МаксимальнаяДатаОтгрузки", ПодобранныеТовары, ДатаОтгрузки);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПроцентСкидки.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПроцентРучнойСкидкиНаценки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("МаксимальныйПроцентСкидки");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьОграниченияРучныхСкидок");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПроцентНаценки.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПроцентРучнойСкидкиНаценки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("МаксимальныйПроцентНаценки");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьОграниченияРучныхСкидок");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);

КонецПроцедуры

&НаСервере
Процедура ВидЦеныПриИзмененииНаСервере()
	
	Элементы.Цена.ТолькоПросмотр = ЗначениеЗаполнено(ВидЦены);
	Элементы.Цена.ПропускатьПриВводе = ЗначениеЗаполнено(ВидЦены);
	
	Если Не ЗначениеЗаполнено(ВидЦены) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫРАЗИТЬ(ЦеныНоменклатурыСрезПоследних.Цена * КурсыСрезПоследних.КурсЧислитель / КурсыСрезПоследних.КурсЗнаменатель /
	|				КурсыСрезПоследнихВалютаЦены.КурсЧислитель * КурсыСрезПоследнихВалютаЦены.КурсЗнаменатель
	|	* ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 1) / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1) КАК ЧИСЛО(31,2)) КАК Цена
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|			КОНЕЦПЕРИОДА(&Дата, ДЕНЬ),
	|			Номенклатура = &Номенклатура
	|				И Характеристика = &Характеристика
	|				И ВидЦены = &ВидЦены) КАК ЦеныНоменклатурыСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата, БазоваяВалюта = &БазоваяВалюта) КАК КурсыСрезПоследних
	|		ПО (КурсыСрезПоследних.Валюта = ЦеныНоменклатурыСрезПоследних.Валюта)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата,
	|				Валюта = &Валюта И БазоваяВалюта = &БазоваяВалюта) КАК КурсыСрезПоследнихВалютаЦены
	|		ПО (ИСТИНА)");
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ВЫРАЗИТЬ(&Упаковка КАК Справочник.УпаковкиЕдиницыИзмерения)", Неопределено));
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ЦеныНоменклатурыСрезПоследних.Упаковка",
			"ЦеныНоменклатурыСрезПоследних.Номенклатура"));
	Запрос.УстановитьПараметр("ВидЦены",        ВидЦены);
	Запрос.УстановитьПараметр("Дата",           Дата);
	Запрос.УстановитьПараметр("Номенклатура",   Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	Запрос.УстановитьПараметр("Упаковка",       Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка());
	Запрос.УстановитьПараметр("Валюта",         Валюта);
	Запрос.УстановитьПараметр("БазоваяВалюта", ЗначениеНастроекПовтИсп.БазоваяВалютаПоУмолчанию());
	
	Цена = 0;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если ЗначениеЗаполнено(Выборка.Цена) Тогда
			Цена = Выборка.Цена;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Набор Тогда
		РассчитатьПараметрыНабора();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПодобранныеТовары()
	
	Если ВариантПредоставления = 1 Тогда
		ПроцентРучнойСкидки = ПроцентРучнойСкидкиНаценки;
	Иначе
		ПроцентРучнойСкидки = -ПроцентРучнойСкидкиНаценки;
	КонецЕсли;
	
	ПараметрыКомплектующих = Новый Структура;
	ПараметрыКомплектующих.Вставить("НоменклатураНабора",              Номенклатура);
	ПараметрыКомплектующих.Вставить("ХарактеристикаНабора",            Характеристика);
	ПараметрыКомплектующих.Вставить("ВариантКомплектацииНоменклатуры", ВариантКомплектацииНоменклатуры);
	ПараметрыКомплектующих.Вставить("ВидЦены", ВидЦены);
	ПараметрыКомплектующих.Вставить("Валюта", Валюта);
	Если Склады.Количество() = 1 Тогда
		ПараметрыКомплектующих.Вставить("Склад", Склады.Получить(0).Значение);
	КонецЕсли;
	ПараметрыКомплектующих.Вставить("КоличествоУпаковок", КоличествоУпаковок);
	ПараметрыКомплектующих.Вставить("ДатаОтгрузки", ДатаОтгрузки);
	ПараметрыКомплектующих.Вставить("ПроцентРучнойСкидки", ПроцентРучнойСкидки);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Дата",    Дата);
	ДополнительныеПараметры.Вставить("Валюта",  Валюта);
	ДополнительныеПараметры.Вставить("Цена",    Цена);
	ДополнительныеПараметры.Вставить("ВидЦены", ВидЦены);
	Если ЗначениеЗаполнено(Соглашение) Тогда
		ДополнительныеПараметры.Вставить("Соглашение", Соглашение);
	КонецЕсли;
	ДополнительныеПараметры.Вставить("Склады", Склады);
	
	ПодобранныеТовары = НаборыВызовСервера.Комплектующие(ПараметрыКомплектующих, ДополнительныеПараметры);
	
	Возврат ПодобранныеТовары;
	
КонецФункции

&НаСервере
Процедура РассчитатьПараметрыНабора()
	
	ПараметрыВариантаКомплектацииНоменклатуры = НаборыВызовСервера.ПараметрыВариантаКомплектацииНоменклатуры(
		Номенклатура,
		Характеристика);
		
	Если Не ЗначениеЗаполнено(ПараметрыВариантаКомплектацииНоменклатуры) Тогда
		Возврат;
	КонецЕсли;
	
	ВариантКомплектацииНоменклатуры = ПараметрыВариантаКомплектацииНоменклатуры.ВариантКомплектацииНоменклатуры;
	
	ПодобранныеТовары = ПодобранныеТовары();
	
	ЦенаНабора = 0;
	ВНаличииНаборов = Неопределено;
	ДоступноНаборов = Неопределено;
	
	СоставНабора.Очистить();
	Для Каждого СтрокаТЧ Из ПодобранныеТовары Цикл
		
		НоваяКомплектующая = СоставНабора.Добавить();
		НоваяКомплектующая.Номенклатура = СтрокаТЧ.Номенклатура;
		НоваяКомплектующая.Характеристика = СтрокаТЧ.Характеристика;
		НоваяКомплектующая.Упаковка = СтрокаТЧ.Упаковка;
		НоваяКомплектующая.Количество = СтрокаТЧ.КоличествоУпаковок;
		НоваяКомплектующая.Цена = СтрокаТЧ.Цена;
		
		Если СтрокаТЧ.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар
			ИЛИ СтрокаТЧ.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.МногооборотнаяТара Тогда
		
			НоваяКомплектующая.ВНаличии = СтрокаТЧ.ВНаличии;
			НоваяКомплектующая.Доступно = СтрокаТЧ.Доступно;
			
			Если НоваяКомплектующая.Количество <> 0 Тогда
				ВНаличииВСтроке = Цел (НоваяКомплектующая.ВНаличии / НоваяКомплектующая.Количество);
			Иначе
				ВНаличииВСтроке = 0;
			КонецЕсли;
			
			Если НоваяКомплектующая.Количество <> 0 Тогда
				ДоступноВСтроке = Цел (НоваяКомплектующая.Доступно / НоваяКомплектующая.Количество);
			Иначе
				ДоступноВСтроке = 0;
			КонецЕсли;
			
			Если ВНаличииНаборов = Неопределено Или ВНаличииВСтроке < ВНаличииНаборов Тогда
				ВНаличииНаборов = ВНаличииВСтроке;
			КонецЕсли;
			
			Если ДоступноНаборов = Неопределено Или ДоступноВСтроке < ДоступноНаборов Тогда
				ДоступноНаборов = ДоступноВСтроке;
			КонецЕсли;
			
		КонецЕсли;
		
		ЦенаНабора = ЦенаНабора + СтрокаТЧ.Цена * СтрокаТЧ.КоличествоУпаковок;
		
	КонецЦикла;
	
	ВНаличии = ВНаличииНаборов;
	Доступно = ДоступноНаборов;
	
	Если ПараметрыВариантаКомплектацииНоменклатуры.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих Тогда
		Элементы.Цена.Доступность = Ложь;
		Цена = ЦенаНабора;
	Иначе
		Элементы.Цена.Доступность = Истина;
	КонецЕсли;
	
	Элементы.ЕдиницаИзмерения.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СоставНабораПриАктивизацииСтроки(Элемент)
	
	Если Элементы.СоставНабора.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТовара = СоставНабора.НайтиПоИдентификатору(Элементы.СоставНабора.ТекущаяСтрока);
	
	ИнформацияОТоваре = ПодборТоваровВызовСервера.ЦенаПродажиИОстаткиТовара(СтрокаТовара.Номенклатура,
			СтрокаТовара.Характеристика, Соглашение, Валюта, Склады, ВидыЦен);
	
	ОстаткиПоСкладам = ОстаткиТоваров.ПолучитьЭлементы();
	ОстаткиПоСкладам.Очистить();
	
	ЦенаПродажиТовара = ИнформацияОТоваре.Цена;
	ХарактеристикиИспользуются = Ложь;
	
	НаименованиеУпаковкиЕдиницыИзмерения = ?(ЗначениеЗаполнено(ЦенаПродажиТовара.Упаковка),
		Строка(ЦенаПродажиТовара.Упаковка), 
		Строка(ЦенаПродажиТовара.ЕдиницаИзмерения));
		
	Для Каждого СтрокаТбл Из ИнформацияОТоваре.ТекущиеОстатки Цикл
		
		СтрокаОстаткиПоСкладам = ОстаткиПоСкладам.Добавить();
		
		СтрокаОстаткиПоСкладам.Период = ТекущаяДатаСеанса;
		СтрокаОстаткиПоСкладам.ПериодОписание = НСтр("ru = 'Сейчас';
													|en = 'Now'");
		СтрокаОстаткиПоСкладам.Доступно = СтрокаТбл.Свободно;
		
		СтрокаОстаткиПоСкладам.ДоступноОписание = "";
		
		Если ЗначениеЗаполнено(СтрокаОстаткиПоСкладам.Доступно) Тогда
			СтрокаОстаткиПоСкладам.ДоступноОписание = Формат(СтрокаОстаткиПоСкладам.Доступно,"ЧДЦ=3") + " " + НаименованиеУпаковкиЕдиницыИзмерения;
		КонецЕсли;
		
		СтрокаОстаткиПоСкладам.Склад = СтрокаТбл.Склад;
		СтрокаОстаткиПоСкладам.СкладОписание = Строка(СтрокаТбл.Склад);
		
		ПланируемыеОстаткиПоДатам = СтрокаОстаткиПоСкладам.ПолучитьЭлементы();
		
		Для Каждого СтрокаТбл Из ИнформацияОТоваре.ПланируемыеОстатки Цикл
			
			Если Не (СтрокаТбл.Склад = СтрокаОстаткиПоСкладам.Склад) Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаПланируемыеОстаткиПоДатам = ПланируемыеОстаткиПоДатам.Добавить();
			
			СтрокаПланируемыеОстаткиПоДатам.Период = СтрокаТбл.Период;
			СтрокаПланируемыеОстаткиПоДатам.ПериодОписание = Формат(СтрокаТбл.Период, "ДЛФ=D");
			СтрокаПланируемыеОстаткиПоДатам.Доступно = СтрокаТбл.Доступно;
			
			Если ЗначениеЗаполнено(СтрокаПланируемыеОстаткиПоДатам.Доступно) Тогда
				СтрокаПланируемыеОстаткиПоДатам.ДоступноОписание = Формат(СтрокаОстаткиПоСкладам.Доступно,"ЧДЦ=3") + " " + НаименованиеУпаковкиЕдиницыИзмерения;
			КонецЕсли;
			
			СтрокаПланируемыеОстаткиПоДатам.Склад = СтрокаТбл.Склад;
			СтрокаПланируемыеОстаткиПоДатам.СкладОписание = "";
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьОстаткиНадписьНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОтображатьОстатки = Не ОтображатьОстатки;
	Элементы.ОстаткиТоваров.Видимость = ОтображатьОстатки;
	ПодборТоваровКлиентСервер.УстановитьТекстНадписиОтображатьОстатки(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
