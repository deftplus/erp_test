#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

&НаКлиенте
Перем ОтветПередЗаписью;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ПараметрыВыбораРеквизитов = ЭтапыОплатыСервер.ПараметрыВыбораРеквизитовОплаты(Метаданные.Документы.ПоступлениеДенежныхДокументов);
	
	ВзаиморасчетыСервер.ФормаПриСозданииНаСервере(ЭтаФорма);
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.ГруппаИтоги.ЦветФона = Новый Цвет();
	КонецЕсли;

	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	ИсправлениеДокументов.ПриСозданииНаСервере(ЭтаФорма, Элементы.СтрокаИсправление);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	УстановитьВидимостьОбщихКоманд();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ДенежныеДокументы.Форма.ФормаВыбора" Тогда
		
		ОбработкаВыбораДенежныхДокументовСервер(РезультатВыбора);
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "ОбщаяФорма.РеквизитыПечатиАвансовогоОтчета" Тогда
		
		Если РезультатВыбора <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(Объект, РезультатВыбора);
		КонецЕсли;
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	Если (ИмяСобытия = "ЗачтенаОплата" И Параметр = Объект.Ссылка)
		Или ЗакупкиКлиент.ИзменилисьДокументыОплатыПоставщиком(ИмяСобытия) Тогда
		ИзмененаОплатаСервер(ИмяСобытия, Параметр);
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_СоглашенияСПоставщиками" Тогда
		УстановитьДоступностьСоглашений();
	КонецЕсли;
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	ИсправлениеДокументовКлиент.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ВзаиморасчетыСервер.ФормаПриЧтенииНаСервере(ЭтаФорма);
	
	ПриЧтенииСозданииНаСервере();

	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИсправлениеДокументов.ПриЧтенииНаСервере(ЭтаФорма, Элементы.СтрокаИсправление);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПоступлениеДенежныхДокументов", ПараметрыЗаписи, Объект.Ссылка);
	ВзаиморасчетыКлиент.ФормаПослеЗаписи(ЭтаФорма);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	ИсправлениеДокументовКлиент.ПослеЗаписи(Объект);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
	// Если документ проводится, предложим дозаполнить недостающие данные
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		РассчитатьИтоговыеПоказателиПоступления(ЭтаФорма);
		
		Если Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхДокументовОтПоставщика") Тогда
			Если Не ЗначениеЗаполнено(Объект.ДатаПлатежа) Тогда
				Объект.ДатаПлатежа = Объект.Дата;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ВзаиморасчетыСервер.ФормаПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	РассчитатьИтоговыеПоказателиПоступления(ЭтаФорма);
	
	ОбновитьСостояниеСервер();
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(
		ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
	УстановитьЗаголовокПоХозОперации();
	
	ОбновитьСписокДД(Элементы.ДенежныеДокументыНаименованиеДенежногоДокумента.СписокВыбора);
	
	Если Объект.Проведен И Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаЧерезПодотчетноеЛицо Тогда
		ДенежныеСредстваСервер.ПереоценитьДенежныеСредстваУПодотчетныхЛиц(Объект.Организация, Объект.Дата, Объект.ПодотчетноеЛицо);
	КонецЕсли;
	
	ВзаиморасчетыСервер.ФормаПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект.ДополнительныеСвойства);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.Свойства
	Если ТекущаяСтраница.Имя = "ГруппаДополнительно"
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		
		СвойстваВыполнитьОтложеннуюИнициализацию();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Подключаемый_ОбновитьКоманды();
	ДатаПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ПриИзмененииКонтрагентаСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.Партнер) Тогда
		Возврат;
	КонецЕсли;
	
	ПриИзмененииПартнераСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СоглашениеПриИзменении(Элемент)
	
	ПриИзмененииСоглашенияСервер();
	
	Если ЗначениеЗаполнено(Объект.Соглашение) Тогда
		ЗакупкиКлиент.ОповеститьОбОкончанииЗаполненияУсловийЗакупок();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ПриИзмененииОрганизацииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	
	ПриИзмененииДоговораСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СоглашениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗакупкиКлиент.НачалоВыбораСоглашенияСПоставщиком(
		Элемент, СтандартнаяОбработка, Объект.Партнер, Объект.Соглашение, Объект.Дата);
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыПечатиАвансовогоОтчетаНажатие(Элемент)
	
	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("НазначениеАванса",             Объект.НазначениеАванса);
	ДанныеПечати.Вставить("КоличествоДокументов",         Объект.КоличествоДокументов);
	ДанныеПечати.Вставить("КоличествоЛистов",             Объект.КоличествоЛистов);
	ДанныеПечати.Вставить("Руководитель",                 Объект.Руководитель);
	ДанныеПечати.Вставить("ГлавныйБухгалтер",             Объект.ГлавныйБухгалтер);
	
	ДанныеПечати.Вставить("Дата",                         Объект.Дата);
	ДанныеПечати.Вставить("Организация",                  Объект.Организация);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДанныеПечати", ДанныеПечати);
	
	ОткрытьФорму("ОбщаяФорма.РеквизитыПечатиАвансовогоОтчета",
		СтруктураПараметров, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВалютыНажатие(Элемент, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("НадписьВалютыНажатиеЗавершение", ЭтотОбъект);
	ВзаиморасчетыКлиент.ВалютыИКурсДокументаНажатие(ЭтаФорма, Элемент, СтандартнаяОбработка, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВалютыНажатиеЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		
		ИзмененныеРеквизиты = РезультатЗакрытия.СтарыеЗначенияИзмененныхРеквизитов;
		
		Если ИзмененныеРеквизиты.Количество() > 0 Тогда
			
			НадписьВалютыНажатиеЗавершениеСервер(РезультатЗакрытия);
			
			Если РезультатЗакрытия.НеобходимПересчетСуммДокумента Тогда
				ЦенообразованиеКлиент.ОповеститьОбОкончанииПересчетаСуммВВалюту(ВалютаДокумента, Объект.Валюта);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НадписьВалютыНажатиеЗавершениеСервер(РезультатЗакрытия)
	
	ИзмененныеРеквизиты = РезультатЗакрытия.СтарыеЗначенияИзмененныхРеквизитов;
	
	Если ИзмененныеРеквизиты.Свойство("Валюта") Тогда
		ВалютаДокумента = Объект.Валюта;
	КонецЕсли;
	
	Если ИзмененныеРеквизиты.Свойство("ВалютаВзаиморасчетов") Тогда
		ЗаполнитьДоговорПоУмолчанию();
		ВалютаВзаиморасчетовДокумента = Объект.ВалютаВзаиморасчетов;
		ЗаполнитьОплатуВВалютеПоУмолчанию();
	КонецЕсли;
	
	ВзаиморасчетыСервер.ФормаПриИзмененииРеквизитов(ЭтаФорма, ИзмененныеРеквизиты, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстАвансовыйОтчетОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОчиститьАвансовыйОтчет" Тогда
		
		СтандартнаяОбработка = Ложь;
		Объект.АвансовыйОтчет = Неопределено;
		Модифицированность = Истина;
		ТекстАвансовыйОтчет = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Включить в авансовый отчет';
				|en = 'To include in expense report'"),,,, "ВключитьВАвансовыйОтчет");
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ВключитьВАвансовыйОтчет" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Отбор = Новый Структура;
		Отбор.Вставить("Организация", Объект.Организация);
		Отбор.Вставить("Подразделение", Объект.Подразделение);
		Отбор.Вставить("ПодотчетноеЛицо", Объект.ПодотчетноеЛицо);
		
		ПараметрыФормы = Новый Структура("Отбор", Отбор);
		ПараметрыФормы.Вставить("Дата", Объект.Дата);
		
		Оповещение = Новый ОписаниеОповещения("ПослеВыбораАвансовогоОтчета", ЭтотОбъект);
		
		ОткрытьФорму("Документ.АвансовыйОтчет.Форма.ФормаВыбораСоздания", ПараметрыФормы, ЭтотОбъект,,,, Оповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораАвансовогоОтчета(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Объект.АвансовыйОтчет = Результат;
		Модифицированность = Истина;
		ОбновитьТекстАвансовыйОтчет();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаИсправлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
		
		ИсправлениеДокументовКлиент.СтрокаИсправлениеОбработкаНавигационныйСсылки(
			ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
			
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ДенежныеДокументыПослеУдаления(Элемент)
	
	РассчитатьИтоговыеПоказателиПоступления(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДенежныеДокументыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РассчитатьИтоговыеПоказателиПоступления(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДенежныеДокументыВалютаПриИзменении(Элемент)
	
	РассчитатьИтоговыеПоказателиПоступления(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДенежныеДокументыЦенаПриИзменении(Элемент)
	
	ТекДанные = Элементы.ДенежныеДокументы.ТекущиеДанные;
	ТекДанные.Сумма = ТекДанные.Цена * ТекДанные.Количество;
	ТекДанные.СуммаВзаиморасчетов = 0;
	
	РассчитатьИтоговыеПоказателиПоступления(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДенежныеДокументыКоличествоПриИзменении(Элемент)
	
	ТекДанные = Элементы.ДенежныеДокументы.ТекущиеДанные;
	ТекДанные.Сумма = ТекДанные.Цена * ТекДанные.Количество;
	ТекДанные.СуммаВзаиморасчетов = 0;
	
	РассчитатьИтоговыеПоказателиПоступления(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДенежныеДокументыСуммаПриИзменении(Элемент)
	
	ТекДанные = Элементы.ДенежныеДокументы.ТекущиеДанные;
	ТекДанные.Цена = ?(ТекДанные.Количество = 0, 0, ТекДанные.Сумма / ТекДанные.Количество);
	ТекДанные.СуммаВзаиморасчетов = 0;
	
	РассчитатьИтоговыеПоказателиПоступления(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДенежныеДокументыНаименованиеДенежногоДокументаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		ТекСтрока	= Элементы.ДенежныеДокументы.ТекущаяСтрока;
		ЭтоДД		= (ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ДенежныеДокументы"));
		ЕстьДанные	= (ТекСтрока <> Неопределено);
		
		Если ЭтоДД И ЕстьДанные Тогда
			ОбработкаВыбораДенежныхДокументовСервер(ВыбранноеЗначение, ТекСтрока);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьЭтапыОплатыНажатие(Элемент, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("НадписьЭтапыОплатыНажатиеЗавершение", ЭтотОбъект);
	ВзаиморасчетыКлиент.НадписьЭтапыОплатыНажатие(ЭтаФорма, Элемент, СтандартнаяОбработка, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьЭтапыОплатыНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ИзмененныеРеквизиты = Результат.СтарыеЗначенияИзмененныхРеквизитов;
		ОтразитьИзмененияПравилОплаты(ИзмененныеРеквизиты);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтразитьИзмененияПравилОплаты(ИзмененныеРеквизиты)
	
	ВзаиморасчетыСервер.ФормаПриИзмененииРеквизитов(ЭтаФорма, ИзмененныеРеквизиты, Истина);
	
	Если ИзмененныеРеквизиты.Свойство("ПорядокРасчетов") Тогда
		ОбновитьСостояниеСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыНажатие(Элемент, СтандартнаяОбработка)
	
	ВзаиморасчетыКлиент.РасчетыНажатие(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборДенежныхДокументов(Команда)
	
	Открытие = Новый Структура;
	Открытие.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Открытие.Вставить("МножественныйВыбор", Истина);
	
	Если Объект.ХозяйственнаяОперация =
		ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхДокументовОтПоставщика") Тогда
		
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("Валюта", Объект.Валюта);
		Открытие.Вставить("Отбор", СтруктураОтбора);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ДенежныеДокументы.ФормаВыбора", Открытие, ЭтаФорма);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗачетОплаты(Команда)
	
	ПоместитьРасшифровкуПлатежаВоВременноеХранилище();
	ВзаиморасчетыКлиент.ЗачетОплаты(ЭтаФорма, Элементы.ЗачетОплаты);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ЗаполнитьПодчиненныеСвойстваПоСтатистике(ИмяРеквизитаРодителя)
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьПодчиненныеРеквизитыОбъекта(Объект, ИмяРеквизитаРодителя);
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
	ОпределитьПечатьЕдиногоАвансовогоОтчета();
	УстановитьВидимостьРеквизитовПечатьАвансовогоОтчета();
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаКлиенте
Процедура УстановитьВидимостьОбщихКоманд()
	
	ХозОперации = Новый Массив;
	ХозОперации.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхДокументовОтПоставщика"));
	
	КнопкиСоздать = Новый Структура;
	КнопкиСоздать.Вставить("ФормаОбработкаПомощникЗачетаОплатЗачетОплаты", ХозОперации);
	КнопкиСоздать.Вставить("ФормаДокументСписаниеБезналичныхДенежныхСредствСоздатьНаОсновании", ХозОперации);
	КнопкиСоздать.Вставить("ФормаДокументРасходныйКассовыйОрдерСоздатьНаОсновании", ХозОперации);
	
	Для Каждого КнопкаСоздать Из КнопкиСоздать Цикл
		
		Если КнопкаСоздать.Значение.Найти(Объект.ХозяйственнаяОперация) = Неопределено Тогда
			КнопкаЭлемент = Элементы.Найти(КнопкаСоздать.Ключ);
			Если КнопкаЭлемент <> Неопределено Тогда
				КнопкаЭлемент.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСПоставщиками") Тогда
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Договор.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Соглашение");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Договор");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	Документы.ПоступлениеДенежныхДокументов.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		Объект.ХозяйственнаяОперация, 
		МассивВсехРеквизитов, 
		МассивРеквизитовОперации);
	ДенежныеСредстваСервер.УстановитьВидимостьЭлементовПоМассиву(
		Элементы,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	Элементы.РеквизитыПечатиАвансовогоОтчета.Видимость =
		(Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхДокументовОтПодотчетника)
		И ПравоДоступа("Просмотр", Метаданные.ОбщиеФормы.РеквизитыПечатиАвансовогоОтчета);

	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("ЗаголовокВалюты");
	МассивЭлементов.Добавить("ДекорацияВалюты");
	МассивЭлементов.Добавить("ЗаголовокОплата");
	МассивЭлементов.Добавить("ДекорацияЭтапыОплаты");
	МассивЭлементов.Добавить("ДекорацияСостояниеРасчетов");
	МассивЭлементов.Добавить("ЗачетОплаты");
	
	ВидимостьЭлементов =
		Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхДокументовОтПоставщика;

	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(
		Элементы, МассивЭлементов, "Видимость", ВидимостьЭлементов);
		
	УстановитьВидимостьРеквизитовПечатьАвансовогоОтчета();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСостояниеСервер()
	
	Документы.ПоступлениеДенежныхДокументов.РассчитатьСостояние(
		Объект.Ссылка, Объект.Договор, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ИзмененаОплатаСервер(ИмяСобытия, Параметр)
	
	ВзаиморасчетыСервер.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр);
	ОбновитьСостояниеСервер();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьЗаголовокПоХозОперации()
	
	ХозОперация = Объект.ХозяйственнаяОперация;
	ХозОперации = Перечисления.ХозяйственныеОперации;
	
	Заголовок = "";
	
	Если ХозОперация = ХозОперации.ПоступлениеДенежныхДокументовОтПодотчетника Тогда
		Заголовок = НСтр("ru = 'Поступление денежных документов от подотчетного лица';
						|en = 'Receipt of financial documents from the advance holder'");
	ИначеЕсли ХозОперация = ХозОперации.ПоступлениеДенежныхДокументовОтПоставщика Тогда
		Заголовок = НСтр("ru = 'Поступление денежных документов от поставщика';
						|en = 'Receipt of financial documents from the supplier'");
	КонецЕсли;
	
	НомерДата = ?(Объект.Ссылка.Пустая(), " " + НСтр("ru = '(создание)';
													|en = '(create)'"), " " + Объект.Номер + " " + НСтр("ru = 'от';
																											|en = 'from'") + " " + Объект.Дата);
	Заголовок = Заголовок + НомерДата;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ВалютаДокумента = Объект.Валюта;
	ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
	ДатаНачалаПечатиЕдиногоАвансовогоОтчета = Константы.ДатаНачалаПечатиЕдиногоАвансовогоОтчета.Получить();
	ЕдиныйАвансовыйОтчетБезусловно = Не Константы.ВидимостьДатыНачалаПечатиЕдиногоАвансовогоОтчета.Получить();
	ОпределитьПечатьЕдиногоАвансовогоОтчета();
	
	ОбновитьСписокДД(Элементы.ДенежныеДокументыНаименованиеДенежногоДокумента.СписокВыбора);
	
	УстановитьВидимость();
	УстановитьДоступностьСоглашений();
	ОбновитьСостояниеСервер();
	
	ЗакупкиСервер.УстановитьДоступностьДоговора(
		Объект, Элементы.Договор.Доступность, ?(Элементы.Договор.Видимость, Элементы.Договор.Видимость, Неопределено));
	
	РассчитатьИтоговыеПоказателиПоступления(ЭтаФорма);
	
	УстановитьЗаголовокПоХозОперации();
	
	ОбновитьТекстАвансовыйОтчет();
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства 

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);

КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаСервереБезКонтекста
Процедура ОбновитьСписокДД(СписокДД)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДД.Ссылка
	|ИЗ
	|	Справочник.ДенежныеДокументы КАК ДД
	|ГДЕ
	|	НЕ ДД.ПометкаУдаления И НЕ ДД.ЭтоГруппа
	|УПОРЯДОЧИТЬ ПО
	|	ДД.Представление";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Результат = Запрос.Выполнить();
	СписокДД.Очистить();
	
	Если Не Результат.Пустой() Тогда
		СписокДД.ЗагрузитьЗначения(Результат.Выгрузить().ВыгрузитьКолонку("Ссылка"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьИтоговыеПоказателиПоступления(Форма)
	
	ОтПоставщика = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхДокументовОтПоставщика");
	ОтПоставщика = (Форма.Объект.ХозяйственнаяОперация = ОтПоставщика);
	
	ТЧ = Форма.Объект.ДенежныеДокументы;
	
	// Табличная часть пустая
	Если ТЧ.Количество() = 0 Тогда
		
		Форма.СуммаДокумента = СуммаДокумента(0);
		
	Иначе
		
		Если ЗначениеЗаполнено(ТЧ[0].Валюта) Тогда
			ВалютаДокумента = ТЧ[0].Валюта;
		Иначе
			ВалютаДокумента = ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка");
		КонецЕсли;
		
		Если ОтПоставщика Или ТЧ.НайтиСтроки(Новый Структура("Валюта", ВалютаДокумента)).Количество() = ТЧ.Количество() Тогда
			
			// Валюта указана в шапке, либо все валюты одинаковы
			Форма.СуммаДокумента = СуммаДокумента(ТЧ.Итог("Сумма"));
			
			Если Не ОтПоставщика И ЗначениеЗаполнено(ВалютаДокумента) Тогда
				Форма.ВалютаДокумента = ВалютаДокумента;
			КонецЕсли;
			
		Иначе
			
			// В табличной части указаны разные валюты
			Форма.ВалютаДокумента = ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка");
			Форма.СуммаДокумента = НСтр("ru = 'Разные валюты';
										|en = 'Different currencies'");
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СуммаДокумента(ЗнСумма)
	
	Возврат Формат(ЗнСумма, "ЧДЦ=2; ЧН=");
	
КонецФункции

&НаСервере
Процедура УстановитьДоступностьСоглашений()
	
	Если ЗначениеЗаполнено(Объект.Партнер) Тогда
		КоличествоСоглашенийСПоставшиком = ЗакупкиВызовСервера.ПолучитьКоличествоСоглашенийСПоставщиком(Объект.Партнер);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "Соглашение", "Видимость", КоличествоСоглашенийСПоставшиком > 0);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииКонтрагентаСервер()
	
	ЗакупкиСервер.УстановитьДоступностьДоговора(
		Объект, Элементы.Договор.Доступность, Элементы.Договор.Видимость, Объект.Договор);
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		ЗаполнитьДоговорПоУмолчанию();
	КонецЕсли;
	
	ОбновитьТекстАвансовыйОтчет();
	
	ВзаиморасчетыСервер.ФормаПриИзмененииРеквизитов(ЭтаФорма, "Контрагент");
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииПартнераСервер()
	
	ДокументЗакупки = РеквизитФормыВЗначение("Объект");
	ДокументЗакупки.ЗаполнитьУсловияЗакупокПоУмолчанию();
	ЗначениеВРеквизитФормы(ДокументЗакупки, "Объект");
	
	УстановитьДоступностьСоглашений();
	
	ВалютаДокумента = Объект.Валюта;
	
	ВзаиморасчетыСервер.ФормаПриИзмененииРеквизитов(ЭтаФорма, "Партнер");
	
	ЗакупкиСервер.УстановитьДоступностьДоговора(
		Объект, Элементы.Договор.Доступность, Элементы.Договор.Видимость, Объект.Договор);
		
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ЗаполнитьДоговорПоУмолчанию();
	КонецЕсли;
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииСоглашенияСервер(ПересчитыватьЦены = Истина)
	
	Если ЗначениеЗаполнено(Объект.Соглашение) Тогда
	
		ДокументЗакупки = РеквизитФормыВЗначение("Объект");
		УсловияЗакупок = ЗакупкиСервер.ПолучитьУсловияЗакупок(ДокументЗакупки.Соглашение, Истина, Истина);
		ДокументЗакупки.ЗаполнитьУсловияЗакупок(УсловияЗакупок);
		ЗначениеВРеквизитФормы(ДокументЗакупки, "Объект");
		
		ВалютаДокумента = Объект.Валюта;
	КонецЕсли;
	
	ЗакупкиСервер.УстановитьДоступностьДоговора(
		Объект, Элементы.Договор.Доступность, Элементы.Договор.Видимость, Объект.Договор);
	
	ВзаиморасчетыСервер.ФормаПриИзмененииРеквизитов(ЭтаФорма, "Соглашение, Договор");
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииДоговораСервер()
	
	ВзаиморасчетыСервер.ФормаПриИзмененииРеквизитов(ЭтаФорма, "Договор");
	
	Если ЗначениеЗаполнено(Объект.Договор) Тогда
		РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Договор,"ОплатаВВалюте,НаправлениеДеятельности");
		Объект.ОплатаВВалюте = РеквизитыДоговора.ОплатаВВалюте;
		Объект.НаправлениеДеятельности = РеквизитыДоговора.НаправлениеДеятельности;
	Иначе
		ЗаполнитьОплатуВВалютеПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииОрганизацииСервер()
	
	ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
	
	Если Объект.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхДокументовОтПодотчетника Тогда
		ЗакупкиСервер.УстановитьДоступностьДоговора(
			Объект, Элементы.Договор.Доступность, Элементы.Договор.Видимость, Объект.Договор);
		
		Если ЗначениеЗаполнено(Объект.Организация) Тогда
			ЗаполнитьДоговорПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьПодчиненныеСвойстваПоСтатистике("Организация");
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
	ОбновитьТекстАвансовыйОтчет();
	
	ВзаиморасчетыСервер.ФормаПриИзмененииРеквизитов(ЭтаФорма, "Организация");
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораДенежныхДокументовСервер(ДД, ТекСтрока = Неопределено)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДД.Наименование	КАК НаименованиеДенежногоДокумента,
	|	ДД.Родитель		КАК ГруппаДокумента,
	|	ДД.Валюта		КАК Валюта,
	|	ДД.Цена			КАК Цена,
	|	1				КАК Количество,
	|	ДД.Цена			КАК Сумма
	|
	|ИЗ
	|	Справочник.ДенежныеДокументы КАК ДД
	|
	|ГДЕ
	|	ДД.Ссылка В(&ДД)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДД.Наименование ВОЗР");
	
	Запрос.УстановитьПараметр("ДД", ДД);
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		ДобавитьСтроки = (ТекСтрока = Неопределено);
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НоваяСтрока = ?(ДобавитьСтроки,
				Объект.ДенежныеДокументы.Добавить(),
				Объект.ДенежныеДокументы.НайтиПоИдентификатору(ТекСтрока));
			
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			
		КонецЦикла;
	
		РассчитатьИтоговыеПоказателиПоступления(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДоговорПоУмолчанию()
	
	ДопПараметры = ЗакупкиСервер.ДополнительныеПараметрыОтбораДоговоров();
	ДопПараметры.ВалютаВзаиморасчетов = Объект.ВалютаВзаиморасчетов;
	Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(
		Объект,
		Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика,
		ДопПараметры);
	
	Если Договор <> Объект.Договор Тогда
		Объект.Договор = Договор;
		ПриИзмененииДоговораСервер();
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура ЗаполнитьОплатуВВалютеПоУмолчанию()
	
	Объект.ОплатаВВалюте = ВзаиморасчетыСервер.ПолучитьОплатуВВалютеПоУмолчанию(Объект.ВалютаВзаиморасчетов, Объект.Организация);
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьПечатьЕдиногоАвансовогоОтчета()
	
	Если ЗначениеЗаполнено(ДатаНачалаПечатиЕдиногоАвансовогоОтчета) Тогда
		Если ЗначениеЗаполнено(Объект.Дата) Тогда
			ПечатьЕдиногоАвансовогоОтчета = (Объект.Дата >= ДатаНачалаПечатиЕдиногоАвансовогоОтчета);
		Иначе
			ПечатьЕдиногоАвансовогоОтчета = (ТекущаяДатаСеанса() >= ДатаНачалаПечатиЕдиногоАвансовогоОтчета);
		КонецЕсли;
	Иначе
		ПечатьЕдиногоАвансовогоОтчета = ЕдиныйАвансовыйОтчетБезусловно;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьРеквизитовПечатьАвансовогоОтчета()
	
	ЗакупкаЧерезПодотчетноеЛицо = (Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхДокументовОтПодотчетника);
	
	ВидимостьРеквизитовПечатиАвансовогоОтчета = ЗакупкаЧерезПодотчетноеЛицо
		И Не ПечатьЕдиногоАвансовогоОтчета
		И ПравоДоступа("Просмотр", Метаданные.ОбщиеФормы.РеквизитыПечатиАвансовогоОтчета);
		
	Элементы.РеквизитыПечатиАвансовогоОтчета.Видимость = ВидимостьРеквизитовПечатиАвансовогоОтчета;
	Элементы.ГруппаПечать.Видимость = ВидимостьРеквизитовПечатиАвансовогоОтчета;
	
	Элементы.ТекстАвансовыйОтчет.Видимость = ЗакупкаЧерезПодотчетноеЛицо И ПечатьЕдиногоАвансовогоОтчета;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТекстАвансовыйОтчет()
	
	ТекстАвансовыйОтчет = АвансовыйОтчетЛокализация.ТекстАвансовыйОтчет(Объект.АвансовыйОтчет);
	
КонецПроцедуры

&НаСервере
Процедура ПоместитьРасшифровкуПлатежаВоВременноеХранилище()
	ВзаиморасчетыСервер.ПоместитьРасшифровкуПлатежаВоВременноеХранилище(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

ОтветПередЗаписью = Ложь;

#КонецОбласти
