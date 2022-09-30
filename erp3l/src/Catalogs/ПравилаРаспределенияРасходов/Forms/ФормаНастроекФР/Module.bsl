#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ПоказательРаспределения.СписокВыбора.Очистить();
	Элементы.ПоказательРаспределения.СписокВыбора.Добавить("ВыручкаОтПродаж", НСтр("ru = 'Выручка от продаж';
																					|en = 'Sales revenue'"));
	Элементы.ПоказательРаспределения.СписокВыбора.Добавить("СебестоимостьПродаж", НСтр("ru = 'Себестоимость продаж';
																						|en = 'COGS'"));
	Элементы.ПоказательРаспределения.СписокВыбора.Добавить("ВаловаяПрибыль", НСтр("ru = 'Валовая прибыль';
																					|en = 'Gross profit'"));
	//++ НЕ УТ
	Элементы.ПоказательРаспределения.СписокВыбора.Добавить("ПрямыеЗатраты", НСтр("ru = 'Прямые производственные затраты';
																				|en = 'Direct production costs'"));
	//-- НЕ УТ
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.БазаРаспределенияПоПартиям = Перечисления.ТипыБазыРаспределенияРасходов.ВыручкаОтПродаж;
	КонецЕсли;
	
	ЗаполнитьСлужебныеРеквизитыФормы();
	
	ПереключитьСтраницу(ЭтаФорма);
	УстановитьВидимостьСтраниц(ЭтаФорма);
	УстановитьВидимостьЭлементов(ЭтаФорма);
	//++ НЕ УТ
	//++ Локализация
	УстановитьВидимостьЭлементовПоФО();
	//-- Локализация
	НастроитьЗаголовкиПолей(ЭтаФорма);
	//-- НЕ УТ
	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	РеквизитыОтборов = Новый Массив;
	РеквизитыОтборов.Добавить(Новый Структура("ОтборПоНаправлениямДеятельности", "НаправлениеДеятельности"));
	//++ НЕ УТ
	//++ Локализация
	РеквизитыОтборов.Добавить(Новый Структура("ОтборПоГруппамПродукции", "ГруппаПродукции"));
	РеквизитыОтборов.Добавить(Новый Структура("ОтборПоМатериалам", "Материал"));
	РеквизитыОтборов.Добавить(Новый Структура("ОтборПоВидамРабот", "ВидРабот"));
	//-- Локализация
	//-- НЕ УТ
	
	Для Каждого РеквизитСОтбором Из РеквизитыОтборов Цикл
		
		Для Каждого КлючИЗначение Из РеквизитСОтбором Цикл
			
			Объект[КлючИЗначение.Ключ].Очистить();
			Для Каждого Элемент Из ЭтаФорма[КлючИЗначение.Ключ] Цикл 
				
				НоваяСтрока = Объект[КлючИЗначение.Ключ].Добавить();
				НоваяСтрока[КлючИЗначение.Значение] = Элемент.Значение;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	//++ НЕ УТ
	Если ПоказательРаспределения = "ПрямыеЗатраты" Тогда
		Возврат;
	КонецЕсли;
	//-- НЕ УТ
	
	ШаблонТипаБазы = "Перечисление.ТипыБазыРаспределенияРасходов.%1";
	Объект.БазаРаспределенияПоПартиям = ПредопределенноеЗначение(СтрШаблон(ШаблонТипаБазы, ПоказательРаспределения));
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//++ НЕ УТ
	Если Объект.НастройкиБазыРаспределенияПоПартиямИзменены Тогда
		ТекущийОбъект.НастройкиБазыРаспределенияПоПартиям = Новый ХранилищеЗначения(
			НастройкиБазыРаспределенияПоПартиям.ПолучитьНастройки());
	Иначе
		ТекущийОбъект.НастройкиБазыРаспределенияПоПартиям = Новый ХранилищеЗначения(Неопределено);
	КонецЕсли;
	//-- НЕ УТ
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПравилаРаспределения

&НаКлиенте
Процедура НаправлениеРаспределенияПриИзменении(Элемент)
	
	ОбработатьИзменениеНаправленияРаспределения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательРаспределенияПриИзменении(Элемент)
	
	ОбработатьИзменениеПоказательРаспределения();
	
КонецПроцедуры

&НаКлиенте
Процедура БазаРаспределенияПоПартиямПриИзменении(Элемент)
	
	//++ НЕ УТ
	ОбработатьИзменениеБазаРаспределенияПоПартиям();
	//-- НЕ УТ
	
	//В УТ пустой обработчик.
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "НаправленияДеятельности" Тогда
		
		ПараметрыОтбора = Новый Структура("МассивНаправленийДеятельности", ОтборПоНаправлениямДеятельности.ВыгрузитьЗначения());
		ДопПараметрОтбора = "ОтборПоНаправлениямДеятельности";

		ОткрытьФорму("Справочник.ПравилаРаспределенияРасходов.Форма.ФормаОтбора",
				ПараметрыОтбора,
				ЭтаФорма,,,, 
				Новый ОписаниеОповещения("ЗавершитьПодборОтборов", ЭтотОбъект, ДопПараметрОтбора), 
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
				
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстДобавитьИзменитьОтборБазыРаспределенияПоПартиямНажатие(Элемент, СтандартнаяОбработка)
	
	//++ НЕ УТ
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(Объект.БазаРаспределенияПоПартиям) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Перед добавлением отбора необходимо выбрать базу распределения.';
														|en = 'Select allocation base before adding a filter.'"),,
			"Объект.БазаРаспределенияПоПартиям");
		Возврат;
	КонецЕсли;
	//++ Локализация
	Если ПартионныйУчет21 Тогда

		ПараметрыОтбора = Новый Структура();
		ДопПараметрОтбора = "";
		
		ГруппаБазы = ИмяСхемыБазыРаспределения(Объект.БазаРаспределенияПоПартиям);
		Если ГруппаБазы = "МатериальныеЗатраты" Тогда
			
			ПараметрыОтбора.Вставить("МассивМатериалов", ОтборПоМатериалам.ВыгрузитьЗначения());
			ДопПараметрОтбора = "ОтборПоМатериалам";
			
		ИначеЕсли ГруппаБазы = "Трудозатраты" Тогда
			
			ПараметрыОтбора.Вставить("МассивВидовРабот", ОтборПоВидамРабот.ВыгрузитьЗначения());
			ДопПараметрОтбора = "ОтборПоВидамРабот";
			
		КонецЕсли;
		
		ОткрытьФорму("Справочник.ПравилаРаспределенияРасходов.Форма.ФормаОтбора",
				ПараметрыОтбора,
				ЭтаФорма,,,, 
				Новый ОписаниеОповещения("ЗавершитьПодборОтборов", ЭтотОбъект, ДопПараметрОтбора), 
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	Иначе
	//-- Локализация
		ПараметрыОткрытия = ПараметрыОткрытияНастройкиОтборов();
		ПараметрыОткрытия.ИмяСхемы = ИмяСхемыБазыРаспределения(Объект.БазаРаспределенияПоПартиям);
		ПараметрыОткрытия.ИмяНастроекКомпоновщика = "НастройкиБазыРаспределенияПоПартиям";
		Если ПараметрыОткрытия.ИмяСхемы = "МатериальныеЗатраты" Тогда
			ПараметрыОткрытия.НеНастраиватьПараметры = Ложь;
		КонецЕсли;
	
		ОткрытьФормуНастройкиОтборов(ПараметрыОткрытия, НСтр("ru = 'Настройка отбора базы распределения';
															|en = 'Allocation base filter settings'"));
	//++ Локализация
	КонецЕсли;
	//-- Локализация
	//-- НЕ УТ
	
	//В УТ пустой обработчик.
	Возврат;

КонецПроцедуры

&НаКлиенте
Процедура ТекстДобавитьИзменитьОтборПоГруппамПродукцииНажатие(Элемент, СтандартнаяОбработка)
	
	//++ НЕ УТ
	СтандартнаяОбработка = Ложь;
	//++ Локализация	
	ОткрытьФорму("Справочник.ПравилаРаспределенияРасходов.Форма.ФормаОтбора",
			Новый Структура("МассивГруппПродукции", ОтборПоГруппамПродукции.ВыгрузитьЗначения()),
			ЭтаФорма,,,, 
			Новый ОписаниеОповещения("ЗавершитьПодборОтборов", ЭтотОбъект, "ОтборПоГруппамПродукции"), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	//-- Локализация
	//-- НЕ УТ
	
	//В УТ пустой обработчик.
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Подбор

&НаКлиенте
Процедура ЗавершитьПодборОтборов(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ТипЗнч(Результат) = Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
		
	Модифицированность = Истина;	
	
	Если ДополнительныеПараметры = "ОтборПоНаправлениямДеятельности" Тогда
		
		ОтборПоНаправлениямДеятельности.ЗагрузитьЗначения(Результат);
		ОбработатьИзмененияОтбораПоНаправлениямДеятельности(ЭтаФорма);
	//++ НЕ УТ
	//++ Локализация
	ИначеЕсли ДополнительныеПараметры = "ОтборПоГруппамПродукции" Тогда
		
		Модифицированность = Истина;
		ОтборПоГруппамПродукции.ЗагрузитьЗначения(Результат);
		ОбработатьИзмененияОтбораПоГруппамПродукции(ЭтаФорма);
		
	ИначеЕсли ДополнительныеПараметры = "ОтборПоМатериалам" Тогда
		
		ОтборПоМатериалам.ЗагрузитьЗначения(Результат);
		Модифицированность = Истина;
		
		ОбработатьИзмененияНастроекБазыРаспределенияПоПартиям();
		
	ИначеЕсли ДополнительныеПараметры = "ОтборПоВидамРабот" Тогда
		
		ОтборПоВидамРабот.ЗагрузитьЗначения(Результат);
		Модифицированность = Истина;
		
		ОбработатьИзмененияНастроекБазыРаспределенияПоПартиям();
	//-- Локализация
	//-- НЕ УТ

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиИзмененийРеквизитов

&НаКлиенте
Процедура ОбработатьИзменениеНаправленияРаспределения()
	
	ОчиститьЗависимыеРеквизиты("НаправлениеРаспределения");
	
	УстановитьВидимостьСтраниц(ЭтаФорма, "НаправлениеРаспределения");
	ПереключитьСтраницу(ЭтаФорма, "НаправлениеРаспределения");
	УстановитьВидимостьЭлементов(ЭтаФорма, "НаправлениеРаспределения");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеПоказательРаспределения()
	
	ОчиститьЗависимыеРеквизиты("ПоказательРаспределения");		
	УстановитьВидимостьЭлементов(ЭтаФорма, "ПоказательРаспределения");	
	
КонецПроцедуры

//++ НЕ УТ

&НаКлиенте
Процедура ОбработатьИзменениеБазаРаспределенияПоПартиям()
	
	Если Не ИмяСхемыБазыРаспределения(КэшБазаРаспределенияПоПартиям) = 
		ИмяСхемыБазыРаспределения(Объект.БазаРаспределенияПоПартиям) Тогда
		ОчиститьЗависимыеРеквизиты("БазаРаспределенияПоПартиям");
	КонецЕсли;
	
	КэшБазаРаспределенияПоПартиям = Объект.БазаРаспределенияПоПартиям;
	
	НастроитьОформлениеПолей(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзмененияНастроекБазыРаспределенияПоПартиям()

	//++ Локализация
	Если ПартионныйУчет21 Тогда
		Объект.НастройкиБазыРаспределенияПоПартиямИзменены =
			ОтборПоВидамРабот.Количество()
			Или ОтборПоМатериалам.Количество()
			Или ОтборПоГруппамПродукции.Количество();
	Иначе
	//-- Локализация
		Объект.НастройкиБазыРаспределенияПоПартиямИзменены = ОтборУстановлен(
			НастройкиБазыРаспределенияПоПартиям);
	//++ Локализация
		Если Не Объект.НастройкиБазыРаспределенияПоПартиямИзменены Тогда
			ОтборПоВидамРабот.Очистить();
			ОтборПоМатериалам.Очистить();
			ОтборПоГруппамПродукции.Очистить();
		КонецЕсли;
	КонецЕсли;
	//-- Локализация
	Модифицированность = Макс(Модифицированность, Объект.НастройкиБазыРаспределенияПоПартиямИзменены);
	
	НастроитьЗаголовкиПолей(ЭтаФорма, "ОтборБазыРаспределенияПоПартиям");
	
КонецПроцедуры

//++ Локализация

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработатьИзмененияОтбораПоГруппамПродукции(Форма)
	
	Форма.Объект.НастройкиНаправленияРаспределенияИзменены = 
		Форма.ОтборПоВидамРабот.Количество()
		Или Форма.ОтборПоМатериалам.Количество()
		Или Форма.ОтборПоГруппамПродукции.Количество();
		
	НастроитьЗаголовкиПолей(Форма, "ОтборПоГруппамПродукции");
	
КонецПроцедуры
//-- Локализация

//-- НЕ УТ

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработатьИзмененияОтбораПоНаправлениямДеятельности(Форма)
	
	Элементы = Форма.Элементы;
			
	Элементы.ПредставлениеУказанныхНаправленийДеятельности.Заголовок = 
		СформироватьПредставлениеОтбора("НаправленияДеятельности", Форма.ОтборПоНаправлениямДеятельности.ВыгрузитьЗначения(), 
			НСтр("ru = 'направление деятельности, направления деятельности, направлений деятельности';
				|en = 'line of business, lines of business, of lines of business'"));
		
КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьПредставлениеОтбора(Гиперссылка, СписокОтбора, ПредметИсчисления = Неопределено, ТекстУказатьПустоеЗначение = "")
	
	Если СписокОтбора.Количество() = 0 Тогда
		
		Если ПустаяСтрока(ТекстУказатьПустоеЗначение) Тогда
			ТекстУказать = НСтр("ru = 'Указать';
								|en = 'Specify'");
		Иначе
			ТекстУказать = ТекстУказатьПустоеЗначение;
		КонецЕсли;
		
		Возврат Новый ФорматированнаяСтрока(ТекстУказать,,,, Гиперссылка);
		
	КонецЕсли;	
	
	Возврат ПредставлениеОтбора(СписокОтбора, ПредметИсчисления, Гиперссылка);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПредставлениеОтбора(СписокОтбора, ПредметИсчисления, Гиперссылка)
	
	Если СписокОтбора.Количество() = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	Если СписокОтбора.Количество() = 1 Тогда
		ПредставлениеОтбора = СокрЛП(СписокОтбора[0]);
	Иначе
		
		КоличествоПозиций = СписокОтбора.Количество() - 1;
		ДляСклонения = ЧислоПрописью(КоличествоПозиций, , ПредметИсчисления);
		
		НачалоПредмета = СтрНайти(ДляСклонения, Лев(ПредметИсчисления, 3));
		СклоненныйПредмет = Сред(ДляСклонения, НачалоПредмета, СтрНайти(ДляСклонения, " ",, НачалоПредмета) - НачалоПредмета);
		
		Представление = НСтр("ru = '%1 и еще %2 %3';
							|en = '%1 and also %2 %3'");
		
		ПредставлениеОтбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Представление, 
			СокрЛП(СписокОтбора[0]), КоличествоПозиций, 
			СклоненныйПредмет);
			
	КонецЕсли;
	
	ФорматированноеПредставлениеОтбора = Новый ФорматированнаяСтрока(ПредставлениеОтбора,, ЦветаСтиля.ПоясняющийТекст);
	
	ПодстрокаИзменить = Новый ФорматированнаяСтрока(НСтр("ru = '(Изменить)';
														|en = '(Change)'"),,,, Гиперссылка);
	
	Возврат Новый ФорматированнаяСтрока(ФорматированноеПредставлениеОтбора,
		?(ПустаяСтрока(ФорматированноеПредставлениеОтбора), "", " "),
		ПодстрокаИзменить);
	
КонецФункции

//++ НЕ УТ

&НаСервере
Процедура ЗагрузитьБазовыеНастройкиКомпоновщика(ИмяРеквизита = "")
	
	Если ИмяРеквизита = "НастройкиБазыРаспределенияПоПартиям" 
		Или ИмяРеквизита = "" Тогда
		
		ИмяСхемы = Перечисления.ТипыБазыРаспределенияРасходов.ИмяСхемыБазыРаспределения(Объект.БазаРаспределенияПоПартиям);
		
		Если Не ПустаяСтрока(ИмяСхемы) Тогда
			
			СхемаКомпоновки = Перечисления.ТипыБазыРаспределенияРасходов.ПолучитьМакет(ИмяСхемы);
			НастройкиБазыРаспределенияПоПартиям.ЗагрузитьНастройки(СхемаКомпоновки.НастройкиПоУмолчанию);
			
		КонецЕсли;
	
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройкиКомпоновщика(ИмяРеквизитаСНастройками, ДокОбъект = Неопределено)
	
	Если ИмяРеквизитаСНастройками = "НастройкиБазыРаспределенияПоПартиям" Тогда
		МодификаторНастроек = "НастройкиБазыРаспределенияПоПартиямИзменены";
	ИначеЕсли ИмяРеквизитаСНастройками = "НастройкиНаправленияРаспределения" Тогда
		МодификаторНастроек = "НастройкиНаправленияРаспределенияИзменены";
	КонецЕсли;
	
	Если Не Объект[МодификаторНастроек] Тогда
		Возврат;
	КонецЕсли;

	Если ДокОбъект = Неопределено Тогда
		ДокОбъект = РеквизитФормыВЗначение("Объект");
	КонецЕсли;

	НастройкиКомпоновщика = ДокОбъект[ИмяРеквизитаСНастройками].Получить();
	Если Не НастройкиКомпоновщика = Неопределено Тогда
		ЭтаФорма[ИмяРеквизитаСНастройками].ЗагрузитьНастройки(НастройкиКомпоновщика);		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ПараметрыОткрытияНастройкиОтборов()
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ИмяСхемы", "");
	ПараметрыОткрытия.Вставить("ИмяНастроекКомпоновщика", "");
	ПараметрыОткрытия.Вставить("НеНастраиватьПараметры", Истина);
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

// Открывает форму настройки отборов.
// Параметры:
//	ПараметрыОткрытия - Структура - описание структуры в ПараметрыОткрытияНастройкиОтборов
&НаКлиенте
Процедура ОткрытьФормуНастройкиОтборов(ПараметрыОткрытия, ЗаголовокФормы = "")

	Адреса = ПолучитьАдресаСхемыКомпоновкиДанныхВоВременномХранилище(ПараметрыОткрытия);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НеПомещатьНастройкиВСхемуКомпоновкиДанных", Истина);
	ПараметрыФормы.Вставить("НеЗагружатьСхемуКомпоновкиДанныхИзФайла", Истина);
	ПараметрыФормы.Вставить("НеНастраиватьПараметры", ПараметрыОткрытия.НеНастраиватьПараметры);
	ПараметрыФормы.Вставить("НеРедактироватьСхемуКомпоновкиДанных", Истина);
	ПараметрыФормы.Вставить("НеНастраиватьУсловноеОформление", Истина);
	ПараметрыФормы.Вставить("НеНастраиватьВыбор", Истина);
	ПараметрыФормы.Вставить("НеНастраиватьПорядок", Истина);
	ПараметрыФормы.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыФормы.Вставить("АдресСхемыКомпоновкиДанных", Адреса.СхемаКомпоновкиДанных);
	ПараметрыФормы.Вставить("АдресНастроекКомпоновкиДанных", Адреса.НастройкиКомпоновкиДанных);
	ПараметрыФормы.Вставить("Заголовок", ЗаголовокФормы);
	
	ОткрытьФорму("ОбщаяФорма.УпрощеннаяНастройкаСхемыКомпоновкиДанных",
		ПараметрыФормы,,,,,
		Новый ОписаниеОповещения("РедактироватьСхемуКомпоновкиДанныхЗавершение",
			ЭтотОбъект,
			ПараметрыОткрытия),
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);

КонецПроцедуры

&НаСервере
Функция ПолучитьАдресаСхемыКомпоновкиДанныхВоВременномХранилище(Параметры)
	
	Адреса = Новый Структура("СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных");
	Схема = Перечисления.ТипыБазыРаспределенияРасходов.ПолучитьМакет(Параметры.ИмяСхемы);
	
	Если Не ПолучитьФункциональнуюОпцию("АналитическийУчетПоГруппамПродукции") Тогда
		
		ПолеГруппыПродукции = Схема.НаборыДанных[0].Поля.Найти("ГруппаПродукции"); // ПолеНабораДанныхСхемыКомпоновкиДанных
		Если Не ПолеГруппыПродукции = Неопределено Тогда
			
			ПолеГруппыПродукции.ОграничениеИспользования.Условие = Истина;
			ПолеГруппыПродукции.ОграничениеИспользованияРеквизитов.Условие = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПолеНаправленияДеятельности = Схема.НаборыДанных[0].Поля.Найти("НаправлениеДеятельности"); // ПолеНабораДанныхСхемыКомпоновкиДанных
	Если Не ПолеНаправленияДеятельности = Неопределено Тогда
		
		ПолеНаправленияДеятельности.ОграничениеИспользования.Условие = Истина;
		ПолеНаправленияДеятельности.ОграничениеИспользованияРеквизитов.Условие = Истина;
		
	КонецЕсли;

	Адреса.СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(Схема, УникальныйИдентификатор);
	
	Настройки = ЭтаФорма[Параметры.ИмяНастроекКомпоновщика].ПолучитьНастройки();
	Если ЗначениеЗаполнено(Настройки) Тогда
		Адреса.НастройкиКомпоновкиДанных = ПоместитьВоВременноеХранилище(Настройки, УникальныйИдентификатор);
	КонецЕсли;
	
	Возврат Адреса;
	
КонецФункции

&НаКлиенте
Процедура РедактироватьСхемуКомпоновкиДанныхЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	ЭтаФорма[ДополнительныеПараметры.ИмяНастроекКомпоновщика].ЗагрузитьНастройки(
		ПолучитьИзВременногоХранилища(Результат));
	
	ОбработатьИзменениеРеквизитов(ДополнительныеПараметры.ИмяНастроекКомпоновщика);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ОтборУстановлен(НовыеНастройки)
	
	ОтборУстановлен = Ложь;
	НастройкиКомпоновщика = НовыеНастройки.ПолучитьНастройки();
	Для Каждого ЭлементОтбора Из НастройкиКомпоновщика.Отбор.Элементы Цикл
		Если ЭлементОтбора.Использование Тогда
			
			ОтборУстановлен = Истина;
			Прервать;
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОтборУстановлен;
	
КонецФункции
//-- НЕ УТ
#КонецОбласти

#Область УправлениеФормой

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьСтраниц(Форма, ИмяРеквизита = Неопределено)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	// Подразделения.
	Если ИмяРеквизита = Неопределено Или ИмяРеквизита = "СпособРаспределенияПоПодразделениям"
		Или ИмяРеквизита = "НаправлениеРаспределения" Тогда
		Элементы.Вручную.Видимость = 
			(Объект.НаправлениеРаспределения = ПредопределенноеЗначение("Перечисление.НаправлениеРаспределенияПоПодразделениям.ПоКоэффициентам"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПереключитьСтраницу(Форма, ИмяРеквизита = Неопределено)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Если ИмяРеквизита = Неопределено Или ИмяРеквизита = "НаправлениеРаспределения" Тогда
		
		Если Объект.НаправлениеРаспределения = ПредопределенноеЗначение("Перечисление.НаправлениеРаспределенияПоПодразделениям.ПоКоэффициентам") Тогда
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Вручную;
		Иначе
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Правила;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры		

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьЭлементов(Форма, ИмяРеквизита = Неопределено)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Если ИмяРеквизита = "НаправлениеРаспределения" Или ИмяРеквизита = Неопределено Тогда
		Элементы.ПредставлениеУказанныхНаправленийДеятельности.Видимость = 
			Объект.НаправлениеРаспределения = ПредопределенноеЗначение("Перечисление.НаправлениеРаспределенияПоПодразделениям.Указанные");
	КонецЕсли;
	
	Если ИмяРеквизита = "ПоказательРаспределения" Или ИмяРеквизита = Неопределено Тогда
		Элементы.ГруппаБазаРаспределениеПоПартиям.Видимость = (Форма.ПоказательРаспределения = "ПрямыеЗатраты");
	КонецЕсли;
	
КонецПроцедуры

//++ НЕ УТ
//++ Локализация

&НаСервере
Процедура УстановитьВидимостьЭлементовПоФО()
	
	Элементы.ГруппаОтборПоГруппамПродукции.Видимость = ПартионныйУчет21
		 И (ПолучитьФункциональнуюОпцию("АналитическийУчетПоГруппамПродукции")
			Или ОтборПоГруппамПродукции.Количество());
	
КонецПроцедуры
//-- Локализация

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьОформлениеПолей(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Элементы.БазаРаспределенияПоПартиям.ОтметкаНезаполненного = (Форма.ПоказательРаспределения = "ПрямыеЗатраты")
		И Не ЗначениеЗаполнено(Объект.БазаРаспределенияПоПартиям);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗаголовкиПолей(Форма, ИмяРеквизита = Неопределено)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	ПредставлениеГиперссылокОтбора = Новый Соответствие();
	ПредставлениеГиперссылокОтбора.Вставить(Истина, НСтр("ru = 'Отбор установлен, изменить';
														|en = 'Filter is set, change'"));
	ПредставлениеГиперссылокОтбора.Вставить(Ложь, НСтр("ru = 'Отбор не установлен, добавить';
														|en = 'Filter not set, add'"));
	
	Если ИмяРеквизита = "ОтборБазыРаспределенияПоПартиям" 
		Или ИмяРеквизита = Неопределено Тогда
		
		Элементы.ТекстДобавитьИзменитьОтборБазыРаспределенияПоПартиям.Гиперссылка = Истина;
		Элементы.ТекстДобавитьИзменитьОтборБазыРаспределенияПоПартиям.ЦветТекста = Новый Цвет();
		
		//++ Локализация
		Если Форма.ПартионныйУчет21 Тогда
			
			Форма.ТекстДобавитьИзменитьОтборБазыРаспределенияПоПартиям = 
				ПредставлениеГиперссылокОтбора.Получить(
					Форма.ОтборПоВидамРабот.Количество()
					Или Форма.ОтборПоМатериалам.Количество());
					
		Иначе
		//-- Локализация
			Форма.ТекстДобавитьИзменитьОтборБазыРаспределенияПоПартиям = 
				ПредставлениеГиперссылокОтбора.Получить(Объект.НастройкиБазыРаспределенияПоПартиямИзменены);
		//++ Локализация
		КонецЕсли;
		//-- Локализация
		
	КонецЕсли;
	
	//++ Локализация
	Если Форма.ПартионныйУчет21 И (ИмяРеквизита = "ОтборПоГруппамПродукции" 
		Или ИмяРеквизита = Неопределено) Тогда
		Форма.ТекстДобавитьИзменитьОтборПоГруппамПродукции = 
			ПредставлениеГиперссылокОтбора.Получить(Форма.ОтборПоГруппамПродукции.Количество() > 0);
	КонецЕсли;
	//-- Локализация
	
	Если Не ЗначениеЗаполнено(Объект.БазаРаспределенияПоПартиям)
		//++ Локализация
		Или (Объект.БазаРаспределенияПоПартиям = ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СуммаМатериальныхИТрудозатрат")
			И Форма.ПартионныйУчет21)
		//-- Локализация
		Или Объект.БазаРаспределенияПоПартиям = ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ВыручкаОтПродаж")
		Или Объект.БазаРаспределенияПоПартиям = ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СебестоимостьПродаж")
		Или Объект.БазаРаспределенияПоПартиям = ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ВаловаяПрибыль") Тогда
		
		Форма.ТекстДобавитьИзменитьОтборБазыРаспределенияПоПартиям = НСтр("ru = 'Отбор недоступен.';
																			|en = 'Filter is unavailable.'");
		Элементы.ТекстДобавитьИзменитьОтборБазыРаспределенияПоПартиям.Гиперссылка = Ложь;
		Элементы.ТекстДобавитьИзменитьОтборБазыРаспределенияПоПартиям.ЦветТекста = WebЦвета.ТемноСерый;
		
	КонецЕсли;

КонецПроцедуры

//-- НЕ УТ

#КонецОбласти

#Область ИнициализацияФормы

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыФормы()
	
	//++ НЕ УТ
	ПартионныйУчет21 = Не РасчетСебестоимостиПовтИсп.ПартионныйУчетВерсии22();
	КэшБазаРаспределенияПоПартиям = Объект.БазаРаспределенияПоПартиям;
	ЗагрузитьБазовыеНастройкиКомпоновщика();
	
	//++ Локализация
	ОтборПоВидамРабот.ЗагрузитьЗначения(Объект.ОтборПоВидамРабот.Выгрузить(, "ВидРабот").ВыгрузитьКолонку("ВидРабот"));
	ОтборПоГруппамПродукции.ЗагрузитьЗначения(Объект.ОтборПоГруппамПродукции.Выгрузить(, "ГруппаПродукции").ВыгрузитьКолонку("ГруппаПродукции"));
	ОтборПоМатериалам.ЗагрузитьЗначения(Объект.ОтборПоМатериалам.Выгрузить(, "Материал").ВыгрузитьКолонку("Материал"));
	//-- Локализация
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ВосстановитьНастройкиКомпоновщика("НастройкиБазыРаспределенияПоПартиям", ДокументОбъект);

	//-- НЕ УТ
	ОтборПоНаправлениямДеятельности.ЗагрузитьЗначения(
		Объект.ОтборПоНаправлениямДеятельности.Выгрузить(, "НаправлениеДеятельности").ВыгрузитьКолонку("НаправлениеДеятельности"));
	ОбработатьИзмененияОтбораПоНаправлениямДеятельности(ЭтаФорма);
	
	ПоказательРаспределения = ОпределитьЗначениеПоказателяРаспределения(Объект.БазаРаспределенияПоПартиям);
		
КонецПроцедуры

#КонецОбласти

//++ НЕ УТ

#Область РаботаСТипамиБаз

&НаКлиентеНаСервереБезКонтекста
Функция ТипыБазРаспределенияПоГруппе(Группа)
	
	ТипыБаз = Новый Массив;
	Если Группа = "Материалы" Тогда
		
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СуммаМатериальныхЗатрат"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.КоличествоУказанныхМатериалов"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ВесУказанныхМатериалов"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ОбъемУказанныхМатериалов"));
		
	ИначеЕсли Группа = "Трудозатраты" Тогда
		
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СуммаРасходовНаОплатуТруда"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.НормативыОплатыТруда"));
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.КоличествоРаботУказанныхВидов"));
		
	ИначеЕсли Группа = "МатериальныеИТрудозатраты" Тогда
		ТипыБаз.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СуммаМатериальныхИТрудозатрат"));
	КонецЕсли;
	
	Возврат ТипыБаз;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяСхемыБазыРаспределения(БазаРаспределения)
	
	Если Не ТипыБазРаспределенияПоГруппе("Материалы").Найти(БазаРаспределения) = Неопределено Тогда
		Возврат "МатериальныеЗатраты";
	ИначеЕсли Не ТипыБазРаспределенияПоГруппе("Трудозатраты").Найти(БазаРаспределения) = Неопределено Тогда
		Возврат "Трудозатраты";
	ИначеЕсли Не ТипыБазРаспределенияПоГруппе("МатериальныеИТрудозатраты").Найти(БазаРаспределения) = Неопределено Тогда
		Возврат "МатериальныеИТрудозатраты";
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

#КонецОбласти

//-- НЕ УТ

#Область Прочее

&НаКлиенте
Процедура ОбработатьИзменениеРеквизитов(ИмяРеквизита)
	
	Если ИмяРеквизита = "НаправлениеРаспределения" Тогда
		ОбработатьИзменениеНаправленияРаспределения();
	ИначеЕсли ИмяРеквизита = "ПоказательРаспределения" Тогда
		ОбработатьИзменениеПоказательРаспределения();
	ИначеЕсли ИмяРеквизита = "ОтборПоНаправлениямДеятельности" Тогда
		ОбработатьИзмененияОтбораПоНаправлениямДеятельности(ЭтаФорма);
	//++ НЕ УТ
	//++ Локализация
	ИначеЕсли ИмяРеквизита = "ОтборПоГруппамПродукции" Тогда
		ОбработатьИзмененияОтбораПоГруппамПродукции(ЭтаФорма);
	//-- Локализация
	ИначеЕсли ИмяРеквизита = "НастройкиБазыРаспределенияПоПартиям" Тогда
		ОбработатьИзмененияНастроекБазыРаспределенияПоПартиям();
	ИначеЕсли ИмяРеквизита = "БазаРаспределенияПоПартиям" Тогда
		ОбработатьИзменениеБазаРаспределенияПоПартиям();
	//-- НЕ УТ
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОчиститьЗависимыеРеквизиты(ИмяРеквизита)
	
	СтруктураЗависимыхРеквизитов = ЗависимыеРеквизиты(ИмяРеквизита);
	
	Для Каждого РеквизитФормы Из СтруктураЗависимыхРеквизитов.РеквизитыФормы Цикл
		
		Если ТипЗнч(ЭтаФорма[РеквизитФормы]) = Тип("ДанныеФормыКоллекция") Тогда
			ЭтаФорма[РеквизитФормы].Очистить();
		//++ НЕ УТ
		ИначеЕсли ТипЗнч(ЭтаФорма[РеквизитФормы]) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
			ЗагрузитьБазовыеНастройкиКомпоновщика(РеквизитФормы);
		//-- НЕ УТ
		Иначе
			ЭтаФорма[РеквизитФормы] = Неопределено;
		КонецЕсли;
		
		ОбработатьИзменениеРеквизитов(РеквизитФормы);
		
	КонецЦикла;
	
	Для Каждого РеквизитОбъекта Из СтруктураЗависимыхРеквизитов.РеквизитыОбъекта Цикл
		
		Если ТипЗнч(Объект[РеквизитОбъекта]) = Тип("ДанныеФормыКоллекция") Тогда
			Объект[РеквизитОбъекта].Очистить();
		Иначе
			Объект[РеквизитОбъекта] = Неопределено;
		КонецЕсли;
		
		ОбработатьИзменениеРеквизитов(РеквизитОбъекта);
		
	КонецЦикла;
	
	Возврат СтруктураЗависимыхРеквизитов;
	
КонецФункции

// Возвращает первый уровень зависимых реквизитов от переданного.
// Параметры:
//	Реквизит - Строка - имя реквизита, для которого следует получить зависимые реквизиты.
// Возвращаемое значение:
//	Структура - зависимые реквизиты
//		* РеквизитыФормы - Массив - содержит имена зависимых реквизитов формы (Строка).
//		* РеквизитыОбъекта - Массив - содержит имена зависимых реквизитов объекта (Строка).
//
&НаКлиенте
Функция ЗависимыеРеквизиты(Реквизит)
	
	РеквизитыФормы = Новый Массив;
	РеквизитыОбъекта = Новый Массив;
	
	Если Реквизит = "НаправлениеРаспределения" Тогда
		
		РеквизитыФормы.Добавить("ОтборПоНаправлениямДеятельности");
		РеквизитыОбъекта.Добавить("НаправленияДеятельности");
		
		Если Объект.НаправлениеРаспределения = ПредопределенноеЗначение("Перечисление.НаправлениеРаспределенияПоПодразделениям.ПоКоэффициентам") Тогда
			РеквизитыФормы.Добавить("ПоказательРаспределения");
		КонецЕсли;
		
	//++ НЕ УТ
	ИначеЕсли Реквизит = "БазаРаспределенияПоПартиям" Тогда
		
		//++ Локализация
		РеквизитыФормы.Добавить("ОтборПоМатериалам");
		РеквизитыФормы.Добавить("ОтборПоВидамРабот");
		//-- Локализация
		РеквизитыФормы.Добавить("НастройкиБазыРаспределенияПоПартиям");
			
	//-- НЕ УТ
	ИначеЕсли Реквизит = "ПоказательРаспределения" Тогда
		//++ НЕ УТ
		//++ Локализация
		РеквизитыФормы.Добавить("ОтборПоГруппамПродукции");
		//-- Локализация
		//-- НЕ УТ
		РеквизитыОбъекта.Добавить("БазаРаспределенияПоПартиям");
	КонецЕсли;
	
	Возврат Новый Структура("РеквизитыФормы, РеквизитыОбъекта", РеквизитыФормы, РеквизитыОбъекта);
		
КонецФункции

&НаСервереБезКонтекста
Функция ОпределитьЗначениеПоказателяРаспределения(База)
	
	Если База = Перечисления.ТипыБазыРаспределенияРасходов.ВаловаяПрибыль Тогда
		Возврат "ВаловаяПрибыль";
	КонецЕсли;
	
	Если База = Перечисления.ТипыБазыРаспределенияРасходов.СебестоимостьПродаж Тогда
		Возврат "СебестоимостьПродаж";
	КонецЕсли;
	
	Если База = Перечисления.ТипыБазыРаспределенияРасходов.ВыручкаОтПродаж Тогда
		Возврат "ВыручкаОтПродаж";
	КонецЕсли;
	
	//++ НЕ УТ
	Если ЗначениеЗаполнено(База) Тогда
		Возврат "ПрямыеЗатраты";
	КонецЕсли;
	//-- НЕ УТ
	
	Возврат "";
	
КонецФункции

#КонецОбласти

#КонецОбласти
