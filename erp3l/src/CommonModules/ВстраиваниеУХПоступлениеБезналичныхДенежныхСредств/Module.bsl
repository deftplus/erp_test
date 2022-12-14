#Область ПрограммныйИнтерфейс

#Область ФормаДокумента

// Нетиповое событие документа. Вызывается перед исполнением основного кода.
Процедура ПриЧтенииСозданииНаСервере(Форма) Экспорт
	// 
	СоздатьЭлементыФормыДокумента(Форма);
	
КонецПроцедуры

Процедура ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	
	//
	АналитикиСтатейБюджетовУХ.ЗаполнитьРеквизитыАналитикВсехСтатей(Форма);
	
КонецПроцедуры

Процедура ОграничениеТипаДокументаПланирования(Форма) Экспорт
	
	ОписаниеТипов = Новый ОписаниеТипов("ДокументСсылка.ОжидаемоеПоступлениеДенежныхСредств, ДокументСсылка.ОперативныйПлан");
	
	Форма.Элементы.РасшифровкаПлатежаДокументПланирования.ОграничениеТипа = ОписаниеТипов;
	
КонецПроцедуры

Функция УстановитьВидимость(Форма) Экспорт
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	ВидимостьСтатьиДДСВШапке = Элементы.СтатьяДвиженияДенежныхСредств.Видимость;
	Элементы.Аналитика1.Видимость = ВидимостьСтатьиДДСВШапке;
	Элементы.Аналитика2.Видимость = ВидимостьСтатьиДДСВШапке;
	Элементы.Аналитика3.Видимость = ВидимостьСтатьиДДСВШапке;
		
	// ЦФО, Проект, ДокументПланирования в шапке
	УправленческиеАналитикиВШапке = 
		Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.КонвертацияВалюты
		ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратНеперечисленныхДС
		ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратНеперечисленнойЗарплатыПоЗарплатномуПроекту
		ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствСДругогоСчета
		ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыНаРасчетныйСчет
		ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВнутренняяПередачаДенежныхСредств
		ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыПоПлатежнойКарте;
		
	Элементы.ЦФО.Видимость = УправленческиеАналитикиВШапке;
	Элементы.Проект.Видимость = УправленческиеАналитикиВШапке;
	Элементы.ДокументПланирования.Видимость = УправленческиеАналитикиВШапке;
	
КонецФункции

Процедура РасшифровкаПлатежаДоговорКредитаДепозитаПриИзменении(Форма, ТекущаяСтрока) Экспорт
	Объект = Форма.Объект;
	ЗаполнитьСтрокуРасшифровкиПоДоговору(ТекущаяСтрока.ДоговорКредитаДепозита, Объект.Ссылка, ТекущаяСтрока);
КонецПроцедуры

Процедура РасшифровкаПлатежаДоговорАрендыПриИзменении(Форма, ТекущаяСтрока) Экспорт
	Объект = Форма.Объект;
	ЗаполнитьСтрокуРасшифровкиПоДоговору(ТекущаяСтрока.ДоговорАренды, Объект.Ссылка, ТекущаяСтрока);
КонецПроцедуры

Процедура РасшифровкаПлатежаОбъектРасчетовПриИзменении(Форма, ТекущаяСтрока) Экспорт
	Объект = Форма.Объект;
	Договор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущаяСтрока.ОбъектРасчетов, "Договор");
	ЗаполнитьСтрокуРасшифровкиПоДоговору(Договор, Объект.Ссылка, ТекущаяСтрока);
КонецПроцедуры	

Процедура ПриИзмененииДоговора(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	ЗаполнитьЭлементСтруктурыЗадолженностиПоДоговору(Объект.РасшифровкаПлатежа, Объект.Договор, Объект.Ссылка);	
	АналитикиСтатейБюджетовУХ.ЗаполнитьРеквизитыАналитикВсехСтатей(Форма);
	
КонецПроцедуры

Процедура ХозяйственнаяОперацияПриИзменении(Форма) Экспорт
	
	ЗаполнитьЭлементСтруктурыЗадолженностиПоУмолчанию(Форма.Объект);
	АналитикиСтатейБюджетовУХ.ЗаполнитьРеквизитыАналитикВсехСтатей(Форма);
	
	УстановитьПараметрыЭлементовСтруктурыЗадолженности(Форма);
	
КонецПроцедуры

#КонецОбласти 

#Область МодульОбъекта

Процедура ПриЗаписи(Объект, Отказ) экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	//
	МассивВсехРеквизитов = Новый Массив; МассивРеквизитовОперации = Новый Массив;
	Документы.ПоступлениеБезналичныхДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		Объект.ХозяйственнаяОперация, 
		МассивВсехРеквизитов, 
		МассивРеквизитовОперации);
	
	ЕстьРасшифровка = (МассивРеквизитовОперации.Найти("РасшифровкаПлатежа") <> Неопределено);
	
	ИменаРеквизитов = "ДокументПланирования,ИдентификаторПозиции";
	
	ИспользованныеПозиции = Объект.РасшифровкаПлатежа.Выгрузить(, ИменаРеквизитов);
	Если НЕ ЕстьРасшифровка Тогда
		ИспользованныеПозиции.Очистить();
		ЗаполнитьЗначенияСвойств(ИспользованныеПозиции.Добавить(), Объект, ИменаРеквизитов);
	КонецЕсли;
	
	// Записать состояния плаженой позиции 
	ДенежныеСредстваВстраиваниеУХ.ЗаписатьСостояниеИспользованныхПлатежныхПозиций(Объект, ИспользованныеПозиции);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов) Экспорт
	
	// используем реквизит ЭлементСтруктурыЗадолженности вместо типового
	МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.ТипСуммыКредитаДепозита");
	Если МассивНепроверяемыхРеквизитов.Найти("РасшифровкаПлатежа") <> Неопределено Тогда	
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.ЭлементСтруктурыЗадолженности");
	КонецЕсли;
		
КонецПроцедуры

Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	ЗаполнитьТипСуммыКредитаДепозита(Объект);
КонецПроцедуры

#КонецОбласти 

#Область МодульМенеджера

// Определяет свойства полей формы////// в зависимости от данных
//
// Возвращаемое значение:
//    ТаблицаЗначений - таблица с колонками Поля, Условие, Свойства.
//
Функция НастройкиПолейФормы(Настройки) Экспорт
	
	// Статья доступна и для операций распоряжения
	НастройкиСтатьи = ФормыУХ.ПолучитьНастройкиПоля(Настройки, "СтатьяДвиженияДенежныхСредств", "Видимость");
	Если НастройкиСтатьи.Количество() > 0 Тогда
		Элемент = НастройкиСтатьи[0];
		ГруппаИЛИ = Элемент.Условие.Элементы[0];
		ФормыУХ.НовыйОтбор(ГруппаИЛИ, "ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствСДругогоСчета);
		ФормыУХ.НовыйОтбор(ГруппаИЛИ, "ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыНаРасчетныйСчет);
		
		// ЦФО, Проект, ДокументПланирования в шапке
		Элемент.Поля.Добавить("ЦФО");
		Элемент.Поля.Добавить("Проект");
		Элемент.Поля.Добавить("ДокументПланирования");
		
	КонецЕсли;
		
	// вместо типа суммы кредита и депозита используем наш реквизит ЭлементСтруктурыЗадолженности
	Элементы  = ФормыУХ.ПолучитьНастройкиПоля(Настройки, "РасшифровкаПлатежа.ТипСуммыКредитаДепозита", "Видимость");
	Для каждого Элемент Из Элементы Цикл
		Элемент.Условие.Элементы.Очистить();
		ФормыУХ.НовыйОтбор(Элемент.Условие, "Дополнительно.Истина", Ложь);
	КонецЦикла;
	
	// СтраницаВалютныйКонтроль
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("СтраницаВалютныйКонтрольУХ");
	ФормыУХ.НовыйОтбор(Элемент.Условие, "Дополнительно.ВалютныйКонтрольУХ", Истина);
	Элемент.Свойства.Вставить("Видимость");
	
КонецФункции

#КонецОбласти 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьЭлементыФормыДокумента(Форма) 
	
	Если ФормыУХ.ЭлементыФормыУХУжеСозданы(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	//
	ФормыУХ.ЭлементыФормыУХДобавлены(Форма);
	
	ПараметрыЭлементов = ПолучитьПараметрыЭлементовПоУмолчанию();
	
	//
	ПараметрыПоляВвода = Новый Структура;
	
	ПараметрыПоляФлажка = Новый Структура;
	ПараметрыПоляФлажка.Вставить("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Право);
	
	#Область АналитикиСтатьиБюджета
		
	// Статьи бюджетов
	АСБ = АналитикиСтатейБюджетовУХ;
	МассивОписанийСтатей = Новый Массив;
	
	/////////////////////////////////////////////////////////////////////////
	АналитикиСтатейБюджетовУХ.СтатьяИАналитикиТаблицыЗначенийРеквизитаФормыВТаблицеФормы(МассивОписанийСтатей,
		"Объект.РасшифровкаПлатежа", "РасшифровкаПлатежа",
		"СтатьяДвиженияДенежныхСредств", "РасшифровкаПлатежаСтатьяДвиженияДенежныхСредств",
		"Аналитика%1", "РасшифровкаПлатежаАналитика%1",
		ФормыУХ.РазместитьПередЭлементомСтрокой(Элементы.РасшифровкаПлатежаСумма)
	);
	АналитикиСтатейБюджетовУХ.СтатьяИАналитикиТаблицыЗначенийРеквизитаФормыВПоляхФормы(МассивОписанийСтатей,
		"Объект.РасшифровкаПлатежа", "РасшифровкаПлатежа",
		"СтатьяДвиженияДенежныхСредств", "РасшифровкаБезРазбиенияСтатьяДвиженияДенежныхСредств",
		"Аналитика%1", "РасшифровкаБезРазбиенияАналитика%1",
		ФормыУХ.РазместитьПередЭлементомСтрокой(Элементы.РасшифровкаБезРазбиенияПодразделение)
	);
	АналитикиСтатейБюджетовУХ.СтатьяИАналитикиОбъектаВПоляхФормы(МассивОписанийСтатей,
		"СтатьяДвиженияДенежныхСредств", "СтатьяДвиженияДенежныхСредств",
		"Аналитика%1", "АналитикаШапка%1",
		ФормыУХ.РазместитьВГруппеСтрокой(Элементы.СтатьяДвиженияДенежныхСредств.Родитель)
	);
		
	// Создать элементы формы для статей бюджетов и их аналитик
	АналитикиСтатейБюджетовУХ.СоздатьСтатьиБюджетовИАналитики(Форма, МассивОписанийСтатей, ПараметрыЭлементов.ПолеВвода);
	#КонецОбласти 
	
	// ЦФО
	ФормыУХ.СоздатьПолеФормы(
		Элементы, 
		"ЦФО",
		НСтр("ru = 'ЦФО'"), 
		"Объект.ЦФО",
		ВидПоляФормы.ПолеВвода,
		Элементы.ГруппаДополнительныеРеквизитыШапки, 
		, 
		ПараметрыЭлементов.ПолеВвода);	
		
	// Проект
	ФормыУХ.СоздатьПолеФормы(
		Элементы, 
		"Проект",
		НСтр("ru = 'Проект'"), 
		"Объект.Проект",
		ВидПоляФормы.ПолеВвода,
		Элементы.ГруппаДополнительныеРеквизитыШапки, 
		, 
		ПараметрыЭлементов.ПолеВвода);	
		
	// ДокументПланирования
	События = Новый Структура("ПриИзменении, ОбработкаВыбора",
								"Подключаемый_ПриИзмененииДокПланирования", 
								"Подключаемый_ОбработкаВыбораДокументПланирования");
	
	ФормыУХ.СоздатьПолеФормы(
		Элементы, 
		"ДокументПланирования",
		НСтр("ru = 'Документ планирования'"), 
		"Объект.ДокументПланирования",
		ВидПоляФормы.ПолеВвода,
		Элементы.ГруппаДополнительныеРеквизитыШапки, 
		, 
		ПараметрыЭлементов.ПолеВвода,
		События);	
	
	#Область РеквизитыРасшифровки

	Куда1 = Элементы.РасшифровкаБезРазбиенияПодразделение;
	Куда  = Элементы.РасшифровкаПлатежаПодразделение;

	// ЦФО 
	События = Новый Структура("ПриИзменении", "Подключаемый_ПриИзмененииЦФО");
	ФормыУХ.СоздатьПолеФормы(Элементы, "РасшифровкаБезРазбиенияЦФО",, "Элементы.РасшифровкаПлатежа.ТекущиеДанные.ЦФО",,		
			Куда1.Родитель, Куда1, ПараметрыЭлементов.ПолеВвода, События);
	ФормыУХ.СоздатьПолеФормы(Элементы, "РасшифровкаПлатежаЦФО",, "Объект.РасшифровкаПлатежа.ЦФО",,		
			Куда.Родитель, Куда, ПараметрыЭлементов.ПолеВвода28, События);
			
	// Проект
	События = Новый Структура("ПриИзменении", "Подключаемый_ПриИзмененииПроекта");
	ФормыУХ.СоздатьПолеФормы(Элементы, "РасшифровкаБезРазбиенияПроект",, "Элементы.РасшифровкаПлатежа.ТекущиеДанные.Проект",,	
			Куда1.Родитель, Куда1, ПараметрыЭлементов.ПолеВвода, События);
	ФормыУХ.СоздатьПолеФормы(Элементы, "РасшифровкаПлатежаПроект",, "Объект.РасшифровкаПлатежа.Проект",,	
			Куда.Родитель, Куда, ПараметрыЭлементов.ПолеВвода28, События);
			
	//ДокументПланирования
	События = Новый Структура("ПриИзменении, ОбработкаВыбора",
								"Подключаемый_ПриИзмененииДокПланирования", 
								"Подключаемый_ОбработкаВыбораДокументПланирования");
	
	Куда1 = Элементы.РасшифровкаБезРазбиенияСтатьяДоходов;
	Куда  = Элементы.РасшифровкаПлатежаСтатьяДоходов;
	ФормыУХ.СоздатьПолеФормы(Элементы, "РасшифровкаБезРазбиенияДокументПланирования",, "Элементы.РасшифровкаПлатежа.ТекущиеДанные.ДокументПланирования",,	
			Куда1.Родитель, Куда1, ПараметрыЭлементов.ПолеВвода, События);
	ФормыУХ.СоздатьПолеФормы(Элементы, "РасшифровкаПлатежаДокументПланирования",, "Объект.РасшифровкаПлатежа.ДокументПланирования",,
			Куда.Родитель, Куда, ПараметрыЭлементов.ПолеВвода28, События);
			
			
	// Элемент структуры задолженности
	Элемент = ФормыУХ.СоздатьПолеФормы(Элементы, "РасшифровкаПлатежаЭлементСтруктурыЗадолженности",, 
		"Объект.РасшифровкаПлатежа.ЭлементСтруктурыЗадолженности",, Элементы.РасшифровкаПлатежа, 
		Элементы.РасшифровкаПлатежаТипСуммыКредитаДепозита,,
		Новый Структура("ПриИзменении", "Подключаемый_РасшифровкаПлатежаЭлементСтруктурыЗадолженностиПриИзменении"));
	
	Элемент = ФормыУХ.СоздатьПолеФормы(Элементы, "РасшифровкаБезРазбиенияЭлементСтруктурыЗадолженности",, 
		"Объект.РасшифровкаПлатежа.ЭлементСтруктурыЗадолженности",, Элементы.РасшифровкаБезРазбиения, 
		Элементы.РасшифровкаБезРазбиенияТипСуммыКредитаДепозита, ПараметрыЭлементов.ПолеВвода,
		Новый Структура("ПриИзменении", "Подключаемый_РасшифровкаПлатежаЭлементСтруктурыЗадолженностиПриИзменении"));
		
	УстановитьПараметрыЭлементовСтруктурыЗадолженности(Форма);		
			
	#КонецОбласти
	
	#Область ВалютныйКонтроль
	СтраницаВалютныйКонтроль = ФормыУХ.СоздатьГруппуФормы(Элементы, "СтраницаВалютныйКонтрольУХ", Нстр("ru = 'Валютный контроль'"), 
		ВидГруппыФормы.Страница, Элементы.ГруппаСтраницы);
		
	ФормыУХ.СоздатьПолеФормы(Элементы, "КодВалютнойОперацииУХ", НСтр("ru = 'Код валютной операции'"), 
		"Объект.КодВалютнойОперации", ВидПоляФормы.ПолеВвода, СтраницаВалютныйКонтроль,, ПараметрыЭлементов.ПолеВвода28);
	#КонецОбласти
	
КонецПроцедуры

Функция ПолучитьПараметрыЭлементовПоУмолчанию()
	
	//
	ПараметрыПоляВвода = Новый Структура;
	
	//
	ПараметрыПоляВвода28 = Новый Структура;
	ПараметрыПоляВвода28.Вставить("ПоложениеЗаголовка", 	ПоложениеЗаголовкаЭлементаФормы.Лево);
	ПараметрыПоляВвода28.Вставить("АвтоМаксимальнаяШирина",	Ложь);
	ПараметрыПоляВвода28.Вставить("МаксимальнаяШирина",		28);
	
	//
	ПараметрыПоляФлажка = Новый Структура;
	ПараметрыПоляФлажка.Вставить("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Право);
	
	// Вертикальная группа
	ПараметрыВертикаль = Новый Структура;
	ПараметрыВертикаль.Вставить("ОтображатьЗаголовок",	Ложь);
	ПараметрыВертикаль.Вставить("Группировка",			ГруппировкаПодчиненныхЭлементовФормы.Вертикальная);
	ПараметрыВертикаль.Вставить("Объединенная",			Истина);
	ПараметрыВертикаль.Вставить("Отображение",			ОтображениеОбычнойГруппы.Нет);
	
	// Параметры элементов, которые можно использовать в формах
	ПараметрыЭлементов = Новый Структура;
	ПараметрыЭлементов.Вставить("ПолеФлажка",	ПараметрыПоляФлажка);
	ПараметрыЭлементов.Вставить("ПолеВвода",	ПараметрыПоляВвода);
	ПараметрыЭлементов.Вставить("ПолеВвода28",	ПараметрыПоляВвода28);
	ПараметрыЭлементов.Вставить("ГруппаВ",		ПараметрыВертикаль);
	
	Возврат ПараметрыЭлементов;
	
КонецФункции

Процедура УстановитьПараметрыЭлементовСтруктурыЗадолженности(Форма) Экспорт
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
		
	МассивВсехРеквизитов = Новый Массив; МассивРеквизитовОперации = Новый Массив;
	Документы.ПоступлениеБезналичныхДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(Объект.ХозяйственнаяОперация, 
		МассивВсехРеквизитов, МассивРеквизитовОперации);
		
	МассивСвязей = Новый Массив;
	МассивПараметровВыбора = Новый Массив;
	
	Если МассивРеквизитовОперации.Найти("Договор") <> Неопределено Тогда
		МассивСвязей.Добавить(Новый СвязьПараметраВыбора("ДоговорКонтрагента", "Объект.Договор"));
	ИначеЕсли МассивРеквизитовОперации.Найти("РасшифровкаПлатежа.ДоговорКредитаДепозита") <> Неопределено Тогда
		МассивСвязей.Добавить(Новый СвязьПараметраВыбора("ДоговорКонтрагента", 
			"Элементы.РасшифровкаПлатежа.ТекущиеДанные.ДоговорКредитаДепозита"));
	ИначеЕсли МассивРеквизитовОперации.Найти("РасшифровкаПлатежа.ДоговорАренды") <> Неопределено Тогда
		МассивСвязей.Добавить(Новый СвязьПараметраВыбора("ДоговорКонтрагента", 
			"Элементы.РасшифровкаПлатежа.ТекущиеДанные.ДоговорАренды"));
	Иначе
		МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("ДоговорКонтрагента", Неопределено));
	КонецЕсли;
	
	Если МассивРеквизитовОперации.Найти("РасшифровкаПлатежа.ОбъектРасчетов") <> Неопределено Тогда
		МассивСвязей.Добавить(Новый СвязьПараметраВыбора("ОбъектРасчетов", 
			"Элементы.РасшифровкаПлатежа.ТекущиеДанные.ОбъектРасчетов"));
	КонецЕсли;
	
	МассивСвязей.Добавить(Новый СвязьПараметраВыбора("Ссылка", "Объект.Ссылка"));
		
	Элементы.РасшифровкаПлатежаЭлементСтруктурыЗадолженности.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивСвязей);
	Элементы.РасшифровкаПлатежаЭлементСтруктурыЗадолженности.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
	
	Элементы.РасшифровкаБезРазбиенияЭлементСтруктурыЗадолженности.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивСвязей);
	Элементы.РасшифровкаБезРазбиенияЭлементСтруктурыЗадолженности.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);

КонецПроцедуры

Функция ДоговорСтрокиРасшифровки(Строка, Объект, МассивРеквизитовОперации)
	
	Если МассивРеквизитовОперации.Найти("РасшифровкаПлатежа.ОбъектРасчетов") <> Неопределено
		И ЗначениеЗаполнено(Строка.ОбъектРасчетов) Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Строка.ОбъектРасчетов, "Договор");
	КонецЕсли;
		
	Если МассивРеквизитовОперации.Найти("Договор") <> Неопределено Тогда
		Возврат Объект.Договор;
	ИначеЕсли МассивРеквизитовОперации.Найти("РасшифровкаПлатежа.ДоговорКредитаДепозита") <> Неопределено Тогда
		Возврат Строка.ДоговорКредитаДепозита;
	ИначеЕсли МассивРеквизитовОперации.Найти("РасшифровкаПлатежа.ДоговорАренды") <> Неопределено Тогда
		Возврат Строка.ДоговорАренды;
	КонецЕсли;

	Возврат Неопределено;
	  
КонецФункции

Процедура ЗаполнитьЭлементСтруктурыЗадолженностиПоУмолчанию(Объект) Экспорт
	
	МассивВсехРеквизитов = Новый Массив; МассивРеквизитовОперации = Новый Массив;
	Документы.ПоступлениеБезналичныхДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(Объект.ХозяйственнаяОперация, 
		МассивВсехРеквизитов, МассивРеквизитовОперации);
	
	Для каждого Строка ИЗ Объект.РасшифровкаПлатежа Цикл
		
		Договор = ДоговорСтрокиРасшифровки(Строка, Объект, МассивРеквизитовОперации);
		МассивЭлементов = ЗаявкиНаОперацииВызовСервера.ЭлементыСтруктурыЗадолженностиПоДоговору(Договор, Объект.Ссылка);
		Если МассивЭлементов.Количество() >= 1 Тогда 
			ЭлементСтруктурыЗадолженности = МассивЭлементов[0];
		Иначе
			ЭлементСтруктурыЗадолженности = Неопределено;
		КонецЕсли;
		
		Строка.ЭлементСтруктурыЗадолженности = ЭлементСтруктурыЗадолженности;
		
		СтатьяДДС = ЗаявкиНаОперацииВызовСервера.СтатьяДДСПоЭлементуСтруктурыЗадолженности(Договор, 
			ЭлементСтруктурыЗадолженности, ПредопределенноеЗначение("Перечисление.ВидыДвиженийПриходРасход.Расход"));
			
		Если ЗначениеЗаполнено(СтатьяДДС) Тогда
			Строка.СтатьяДвиженияДенежныхСредств = СтатьяДДС;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьЭлементСтруктурыЗадолженностиПоДоговору(РасшифровкаПлатежа, Договор, Ссылка)
	
	МассивЭлементов = ЗаявкиНаОперацииВызовСервера.ЭлементыСтруктурыЗадолженностиПоДоговору(Договор, Ссылка);
	Если МассивЭлементов.Количество() >= 1 Тогда 
		ЭлементСтруктурыЗадолженности = МассивЭлементов[0];
	Иначе
		ЭлементСтруктурыЗадолженности = Неопределено;
	КонецЕсли;
	
	СтатьяДДС = ЗаявкиНаОперацииВызовСервера.СтатьяДДСПоЭлементуСтруктурыЗадолженности(Договор, 
		ЭлементСтруктурыЗадолженности, ПредопределенноеЗначение("Перечисление.ВидыДвиженийПриходРасход.Расход"));
	
	Для каждого Строка ИЗ РасшифровкаПлатежа Цикл
		Строка.ЭлементСтруктурыЗадолженности = ЭлементСтруктурыЗадолженности;
		Если ЗначениеЗаполнено(СтатьяДДС) Тогда
			Строка.СтатьяДвиженияДенежныхСредств = СтатьяДДС;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьСтрокуРасшифровкиПоДоговору(Договор, Ссылка, Строка)
	
	МассивЭлементов = ЗаявкиНаОперацииВызовСервера.ЭлементыСтруктурыЗадолженностиПоДоговору(Договор, Ссылка);
	Если МассивЭлементов.Количество() >= 1 Тогда 
		ЭлементСтруктурыЗадолженности = МассивЭлементов[0];
	Иначе
		ЭлементСтруктурыЗадолженности = Неопределено;
	КонецЕсли;
	
	СтатьяДДС = ЗаявкиНаОперацииВызовСервера.СтатьяДДСПоЭлементуСтруктурыЗадолженности(Договор, 
		ЭлементСтруктурыЗадолженности, ПредопределенноеЗначение("Перечисление.ВидыДвиженийПриходРасход.Расход"));
	
	Строка.ЭлементСтруктурыЗадолженности = ЭлементСтруктурыЗадолженности;
	Если ЗначениеЗаполнено(СтатьяДДС) Тогда
		Строка.СтатьяДвиженияДенежныхСредств = СтатьяДДС;
	КонецЕсли;
	
КонецПроцедуры

Функция СтатьяДДСПоЭлементуСтруктурыЗадолженности(ЭлементСтруктурыЗадолженности, Строка, Объект) Экспорт
	
	МассивВсехРеквизитов = Новый Массив; МассивРеквизитовОперации = Новый Массив;
	Документы.ПоступлениеБезналичныхДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(Объект.ХозяйственнаяОперация, 
		МассивВсехРеквизитов, МассивРеквизитовОперации);
			
	Договор = ДоговорСтрокиРасшифровки(Строка, Объект, МассивРеквизитовОперации);	
	СтатьяДДС = ЗаявкиНаОперацииВызовСервера.СтатьяДДСПоЭлементуСтруктурыЗадолженности(Договор, 
		ЭлементСтруктурыЗадолженности, ПредопределенноеЗначение("Перечисление.ВидыДвиженийПриходРасход.Расход"));
		
	Возврат СтатьяДДС;
	
КонецФункции

Процедура ЗаполнитьТипСуммыКредитаДепозита(Объект)
	
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	
	Документы.ПоступлениеБезналичныхДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		Объект.ХозяйственнаяОперация, МассивВсехРеквизитов, МассивРеквизитовОперации);
		
	Если МассивРеквизитовОперации.Найти("РасшифровкаПлатежа.ТипСуммыКредитаДепозита") <> Неопределено Тогда
		
		Для каждого Строка ИЗ Объект.РасшифровкаПлатежа Цикл
			Строка.ТипСуммыКредитаДепозита = ЗаявкиНаОперацииКлиентСервер.ТипСуммыКредитаДепозитаПоЭлементуСтруктурыЗадолженности(
				Строка.ЭлементСтруктурыЗадолженности);
		КонецЦикла;
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти 
