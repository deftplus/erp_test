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
	
	Если Параметры.Свойство("СтруктураОтбора") Тогда
		СтруктураОтбора = Параметры.СтруктураОтбора;
	Иначе
		СтруктураОтбора = Новый Структура;
	КонецЕсли;
	
	Параметры.Свойство("АдресВХранилище",  АдресВХранилище);
	Параметры.Свойство("НачалоПериода",    НачалоПериода);
	Параметры.Свойство("ОкончаниеПериода", ОкончаниеПериода);
	
	СтруктураОтбора.Свойство("Подразделение", Подразделение);
	СтруктураОтбора.Свойство("Подразделение", ПодразделениеПрежнее);
	
	СтруктураОтбора.Свойство("НаправлениеДеятельности", НаправлениеДеятельности);
	СтруктураОтбора.Свойство("НаправлениеДеятельности", НаправлениеДеятельностиПрежнее);
	
	СтруктураОтбора.Свойство("Назначение", Назначение);
	СтруктураОтбора.Свойство("Назначение", НазначениеПрежнее);
	
	СтруктураОтбора.Свойство("ЗаказНаПроизводство", ЗаказНаПроизводство);
	СтруктураОтбора.Свойство("ИсключатьПроизводствоНаСтороне", ИсключатьПроизводствоНаСтороне);
	
	Если СтруктураОтбора.Свойство("ТолькоЭтапыСВыпуском") И СтруктураОтбора.ТолькоЭтапыСВыпуском Тогда
		ЭтапыТекущегоМесяца = Истина;
		Элементы.ЭтапыТекущегоМесяца.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НаправлениеДеятельности)
		И СтруктураОтбора.Свойство("ТолькоУказанноеНаправлениеДеятельности") 
		И СтруктураОтбора.ТолькоУказанноеНаправлениеДеятельности
	Тогда
		Элементы.НаправлениеДеятельности.Доступность = Ложь;
	КонецЕсли;
	
	ЭтоКА = ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация");
	Если ЭтоКА Тогда
		Элементы.ПартииПроизводстваЭтап.Заголовок = НСтр("ru = 'Партия производства';
														|en = 'Production lot'");
		Элементы.ЭтапыТекущегоМесяца.Видимость = Ложь;
	Иначе
		Элементы.ЭтапыТекущегоМесяца.Заголовок = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Только партии, работы по которым выполнялись в текущем месяце (%1)';
					|en = 'Only the lots processed this month (%1)'"), 
				Формат(НачалоПериода,НСтр("ru = 'ДФ=''ММММ гггг''';
											|en = 'DF=''MMMM yyyy'''")));
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВыполняетсяЗакрытие = Ложь;
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если Не ЗначениеЗаполнено(Настройки["ВариантПодбора"]) Тогда
		Настройки["ВариантПодбора"]			= "ПоПродукции";
		Настройки["ВариантПодбораПрежнее"]	= "ПоПродукции";
	КонецЕсли;
	
	Если СтруктураОтбора.Свойство("Организация") Тогда
		Настройки["Организация"] = СтруктураОтбора["Организация"];
	КонецЕсли;
	
	Если СтруктураОтбора.Свойство("Подразделение") Тогда
		Настройки["Подразделение"] = СтруктураОтбора["Подразделение"];
	КонецЕсли;
	
	Если СтруктураОтбора.Свойство("НаправлениеДеятельности") Тогда
		Настройки["НаправлениеДеятельности"] = СтруктураОтбора["НаправлениеДеятельности"];
	КонецЕсли;
	
	Если СтруктураОтбора.Свойство("Назначение") Тогда
		Настройки["Назначение"] = СтруктураОтбора["Назначение"];
	КонецЕсли;
	
	Настройки["Организация"] = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Настройки["Организация"]);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ЗаполнитьТаблицуСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	Если Модифицированность Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если НЕ ВыполняетсяЗакрытие Тогда
			Отказ = Истина;
			ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), 
							НСтр("ru = 'Данные были изменены. Перенести изменения?';
								|en = 'Data has changed. Transfer the changes?'"),
							РежимДиалогаВопрос.ДаНетОтмена);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ВыполняетсяЗакрытие = Истина;
		ПеренестиСтрокиВДокумент();
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
		
	Иначе
		ВыполняетсяЗакрытие = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВариантПодбораПриИзменении(Элемент)
	
	Если ВариантПодбора <> ВариантПодбораПрежнее Тогда
		ЗаполнитьТаблицуСервер();
		ВариантПодбораПрежнее = ВариантПодбора;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыТекущегоМесяцаПриИзменении(Элемент)
	
	ЗаполнитьТаблицуСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Если Подразделение <> ПодразделениеПрежнее Тогда
		ЗаполнитьТаблицуСервер();
		ПодразделениеПрежнее = Подразделение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НазначениеПриИзменении(Элемент)
	
	Если Назначение <> НазначениеПрежнее Тогда
		ЗаполнитьТаблицуСервер();
		НазначениеПрежнее = Назначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеДеятельностиПриИзменении(Элемент)
	
	Если НаправлениеДеятельности <> НаправлениеДеятельностиПрежнее Тогда
		ЗаполнитьТаблицуСервер();
		НаправлениеДеятельностиПрежнее = НаправлениеДеятельности;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаказНаПроизводствоПриИзменении(Элемент)
	ЗаполнитьТаблицуСервер();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент()

	ПеренестиСтрокиВДокумент();

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтрокиЭтапы(Команда)
	
	ОтметитьСтроки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтрокиЭтапы(Команда)
	
	ОтметитьСтроки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокЭтапы(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицуСервер();
	
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
	
	// Видимость этапа.
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПартииПроизводстваЭтап.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантПодбора");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = "ПоПродукции";
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// Текст незаполненного этапа.
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПартииПроизводстваЭтап.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПартииПроизводства.Этап");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<этапы не созданы>';
																|en = '<steps are not created>'"));
	
	// Текст незаполненного подразделения
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПартииПроизводстваПодразделение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПартииПроизводства.Подразделение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<определяется при выпуске>';
																|en = '<determined upon release>'"));
	
КонецПроцедуры

#Область Прочее

&НаСервере
Функция ПоместитьСтрокиВХранилище()
	
	ТаблицаВыбранныхСтрок = ПартииПроизводства.Выгрузить(Новый Структура("СтрокаВыбрана", Истина));
	
	АдресВХранилище = ПоместитьВоВременноеХранилище(ТаблицаВыбранныхСтрок, АдресВХранилище);
	
	Возврат АдресВХранилище;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуСервер()
	
	СтруктураОтбора.Вставить("НачалоПериода",          НачалоПериода);
	СтруктураОтбора.Вставить("ОкончаниеПериода",       ОкончаниеПериода);
	СтруктураОтбора.Вставить("Подразделение",          Подразделение);
	СтруктураОтбора.Вставить("НаправлениеДеятельности",НаправлениеДеятельности);
	СтруктураОтбора.Вставить("Назначение",             Назначение);
	СтруктураОтбора.Вставить("ТолькоТекущийМесяц",     ЭтапыТекущегоМесяца);
	СтруктураОтбора.Вставить("ДетализироватьПоЭтапам", ?(ВариантПодбора = "ПоПродукции", Ложь, Истина));
	СтруктураОтбора.Вставить("ЗаказНаПроизводство",    ЗаказНаПроизводство);
	СтруктураОтбора.Вставить("ИсключатьПроизводствоНаСтороне", ИсключатьПроизводствоНаСтороне);
	
	Результат = ЗатратыСервер.ПартииПроизводстваДляРаспределенияЗатрат(СтруктураОтбора);
	
	ПартииПроизводства.Загрузить(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиСтрокиВДокумент()
	
	АдресВХранилище = ПоместитьСтрокиВХранилище();
	Модифицированность = Ложь;
	
	Закрыть(АдресВХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьСтроки(Пометка)

	Если Элементы.ПартииПроизводства.ВыделенныеСтроки.Количество() > 1 Тогда
		Для каждого ИндексСтроки Из Элементы.ПартииПроизводства.ВыделенныеСтроки Цикл
			СтрокаПроизводство = Элементы.ПартииПроизводства.ДанныеСтроки(ИндексСтроки);
			СтрокаПроизводство.СтрокаВыбрана = Пометка;
		КонецЦикла;
	Иначе
		Для каждого СтрокаПроизводство Из ЭтаФорма.ПартииПроизводства Цикл
			СтрокаПроизводство.СтрокаВыбрана = Пометка;
		КонецЦикла; 
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
