#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ЗаполнитьЗначенияСвойств(Объект, Параметры);
	ХозяйственнаяОперация = Параметры.ХозяйственнаяОперация;
	Объект.ЭтапыГрафикаОплаты.Очистить();
	ИдентификаторВызывающейФормы = Параметры.УникальныйИдентификатор;
	ЗаполнитьЭтапыОплатыИзВременногоХранилищаСервер(Параметры.АдресВоВременномХранилище);
	РассчитатьИтоговыеПоказателиСоглашенияСКлиентом(ЭтаФорма);
	ЭтаФорма.ТолькоПросмотр = Параметры.ТолькоПросмотр;
	
	МассивПараметров = Новый Массив;
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Значение", Перечисления.ВариантыОплатыКлиентом.КредитПослеОтгрузки));
	КонецЕсли;
	Элементы.ЭтапыГрафикаОплатыВариантОплаты.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	Если ЗначениеЗаполнено(Объект.Календарь) Тогда 
		РежимУчетаОтсрочки = 1;
	Иначе
		Элементы.Календарь.Доступность = Ложь;
	КонецЕсли;
	Элементы.ФормаОК.Видимость = Объект.Статус <> Перечисления.СтатусыПланов.Утвержден;
	Элементы.ГруппаСтатусУтвержден.Видимость = Объект.Статус = Перечисления.СтатусыПланов.Утвержден;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ВыполняетсяЗакрытие Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если Модифицированность И Не Готово Тогда
			
			СписокКнопок = Новый СписокЗначений();
			СписокКнопок.Добавить("Закрыть", НСтр("ru = 'Закрыть';
													|en = 'Close'"));
			СписокКнопок.Добавить("НеЗакрывать", НСтр("ru = 'Не закрывать';
														|en = 'Do not close'"));
			
			Отказ = Истина;
			ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтр("ru = 'Все измененные данные будут потеряны. Закрыть форму?';
																									|en = 'All changed data will be lost. Close the form?'"), СписокКнопок);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОтветНаВопрос = РезультатВопроса;
	
	Если ОтветНаВопрос = "Закрыть" Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ЗаполнитьЭтапыОплатыИзВременногоХранилищаСервер(АдресВоВременномХранилище)
	
	ЭтапыОплаты = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	Для Каждого ТекСтрока Из ЭтапыОплаты Цикл
		НоваяСтрока = Объект.ЭтапыГрафикаОплаты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыПослеУдаления(Элемент)
	
	РассчитатьИтоговыеПоказателиСоглашенияСКлиентом(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РассчитатьИтоговыеПоказателиСоглашенияСКлиентом(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыВариантОплатыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = (ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияКлиенту"));
	
	Если НЕ СтандартнаяОбработка 
		И ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию") Тогда
		
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОплатыКлиентом.КредитПослеОтгрузки"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимУчетаОтсрочкиПриИзменении(Элемент)
	
	Элементы.Календарь.Доступность = ?(РежимУчетаОтсрочки = 1, Истина, Ложь);
	Элементы.Календарь.АвтоОтметкаНезаполненного = ?(РежимУчетаОтсрочки = 1, Истина, Ложь);
	
	Если РежимУчетаОтсрочки = 1 Тогда
		ЗаполнитьПроизводственныйКалендарьНаСервере();
	Иначе
		Объект.Календарь = ПредопределенноеЗначение("Справочник.ПроизводственныеКалендари.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	
	Готово = Истина;
	СтруктураОбъекта = Новый Структура();
	СтруктураОбъекта.Вставить("Календарь", Объект.Календарь);
	СтруктураОбъекта.Вставить("АдресВоВременномХранилище", ПоместитьВоВременноеХранилищеНаСервере());
	СтруктураОбъекта.Вставить("Статус", Объект.Статус);
	
	Закрыть(СтруктураОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыСдвиг.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.СдвигЗаполненНеВерно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыПроцентПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.ПроцентЗаполненНеВерно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыПроцентПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.СдвигЗаполненНеВерно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.НомерСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("НомерСтрокиПолнойОплаты");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НомерСтрокиПолнойОплаты");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Seagreen);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыПроцентПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.ПроцентПлатежа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьВоВременноеХранилищеНаСервере()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.ЭтапыГрафикаОплаты.Выгрузить(), ИдентификаторВызывающейФормы);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьИтоговыеПоказателиСоглашенияСКлиентом(Форма)
	
	ПроцентПлатежейОбщий = 0;
	ПредыдущееЗначениеСдвига = 0;
	Форма.НомерСтрокиПолнойОплаты = 0;
	Для Каждого ТекСтрока Из Форма.Объект.ЭтапыГрафикаОплаты Цикл
		
		ПроцентПлатежейОбщий = ПроцентПлатежейОбщий + ТекСтрока.ПроцентПлатежа;
		ТекСтрока.ПроцентЗаполненНеВерно = (ПроцентПлатежейОбщий > 100);
		Если ПроцентПлатежейОбщий = 100 Тогда
			Форма.НомерСтрокиПолнойОплаты = ТекСтрока.НомерСтроки;
		КонецЕсли;
		
		ТекСтрока.СдвигЗаполненНеВерно = (ПредыдущееЗначениеСдвига > ТекСтрока.Сдвиг);
		ПредыдущееЗначениеСдвига = ТекСтрока.Сдвиг;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПроизводственныйКалендарьНаСервере()
	
	КалендарныеГрафики.ЗаполнитьПроизводственныйКалендарьВФорме(ЭтаФорма, "Объект.Календарь");
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти