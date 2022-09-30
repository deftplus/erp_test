
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Заполнение.
	Итоги = ЗаполнитьТаблицуДвижений(Параметры.ДанныеРасшифровки);
	НадписьДоступно = Итоги.КоличествоДоступно;
	НадписьПотребность = Итоги.КоличествоПотребность;
	
	// Настройка формы.
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(&Номенклатура КАК Справочник.Номенклатура).Наименование КАК Номенклатура,
		|	ВЫРАЗИТЬ(&Характеристика КАК Справочник.ХарактеристикиНоменклатуры).Наименование КАК Характеристика,
		|	ВЫРАЗИТЬ(&Назначение КАК Справочник.Назначения).Наименование КАК Назначение,
		|	ВЫРАЗИТЬ(&Номенклатура КАК Справочник.Номенклатура).ЕдиницаИзмерения КАК ЕдиницаИзмерения";
	Запрос.УстановитьПараметр("Номенклатура",   Параметры.Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Параметры.Характеристика);
	Запрос.УстановитьПараметр("Назначение",     Параметры.Назначение);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	НадписьХарактеристика = ?(ЗначениеЗаполнено(Параметры.Характеристика), ", Выборка.Характеристика", "");
	Элементы.ДекорацияТовар.Заголовок = СтрШаблон(Элементы.ДекорацияТовар.Заголовок,
		Выборка.Номенклатура, НадписьХарактеристика, Выборка.Назначение, Выборка.ЕдиницаИзмерения);
	
	Если Параметры.Режим = "РАСПРЕДЕЛЕНИЕ_ОСТАТКОВ" Тогда
		
		Элементы.НадписьПотребность.Видимость = Ложь;
		Элементы.ТоварРасшифровкаДоступно.Видимость = Ложь;
		Заголовок = СтрШаблон(НСтр("ru = 'График перемещения товаров со склада: %1';
									|en = 'Schedule of goods transfer from the warehouse: %1'"), Параметры.СкладОтправитель);
		Элементы.ТоварРасшифровкаСклад.Заголовок = НСтр("ru = 'Склад-получатель';
														|en = 'Destination warehouse'");
		
	ИначеЕсли Параметры.Режим = "ОБЕСПЕЧЕНИЕ_ПОТРЕБНОСТЕЙ" Тогда
		
		Элементы.НадписьДоступно.Видимость = Ложь;
		Элементы.ТоварРасшифровкаДатаПотребности.Видимость = Ложь;
		Элементы.ТоварРасшифровкаПериод.Видимость = Ложь;
		Элементы.ТоварРасшифровкаПотребность.Видимость = Ложь;
		Заголовок = СтрШаблон(НСтр("ru = 'График перемещения товаров на склад: %1';
									|en = 'Schedule of goods transfer to the warehouse: %1'"), Параметры.СкладПолучатель);
		Элементы.ТоварРасшифровкаСклад.Заголовок = НСтр("ru = 'Склад-отправитель';
														|en = 'Origin warehouse'");
		
	КонецЕсли;
	
	// Подписки стандартных подсистем.
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТабличнойЧастиТоварРасшифровка

&НаКлиенте
Процедура ТоварРасшифровкаОтметкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТоварРасшифровка.ТекущиеДанные;
	ТекущиеДанные.КПеремещениюПоСтроке = ?(ТекущиеДанные.Отметка, ТекущиеДанные.КПеремещению, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварРасшифровкаКПеремещениюПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТоварРасшифровка.ТекущиеДанные;
	ТекущиеДанные.КПеремещениюПоСтроке = ?(ТекущиеДанные.Отметка, ТекущиеДанные.КПеремещению, 0);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ПараметрЗакрытия = Новый Структура();
	
	КПеремещению = Объект.ТоварРасшифровка.Итог("КПеремещениюПоСтроке");
	ПараметрЗакрытия.Вставить("КПеремещению", КПеремещению);
	ДанныеРасшифровки = ПоместитьВоВременноеХранилищеТоварРасшифровка();
	ПараметрЗакрытия.Вставить("ДанныеРасшифровки", ДанныеРасшифровки);
	Закрыть(ПараметрЗакрытия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗаполнитьТаблицуДвижений(ДанныеРасшифровки)
	
	СтруктураРезультата = Обработки.УправлениеПеремещениемОбособленныхТоваров.ДетальныеЗаписи(Параметры);
	
	КоличествоДоступно = СтруктураРезультата.КоличествоДоступно;
	КоличествоПотребность = СтруктураРезультата.КоличествоПотребность;
	
	Итоги = Новый Структура("КоличествоДоступно, КоличествоПотребность", КоличествоДоступно, КоличествоПотребность);
	
	Объект.ТоварРасшифровка.Загрузить(СтруктураРезультата.ДетальныеЗаписи);
	
	// Расчет количества к перемещению
	Если ЭтоАдресВременногоХранилища(ДанныеРасшифровки) Тогда
		
		ЗаполнитьКоличествоКПеремещениюПоДаннымРасшифровки(ДанныеРасшифровки);
		
	Иначе
		
		Если Параметры.Режим = "РАСПРЕДЕЛЕНИЕ_ОСТАТКОВ" Тогда
			
			Для Каждого СтрокаТаблицы Из Объект.ТоварРасшифровка Цикл
				
				Если СтрокаТаблицы.ЭтоЗаГраницейПериода Или КоличествоДоступно <= 0 Тогда
					Прервать;
				КонецЕсли;
				
				СтрокаТаблицы.КПеремещению = Мин(СтрокаТаблицы.Потребность, КоличествоДоступно);
				СтрокаТаблицы.КПеремещениюПоСтроке = СтрокаТаблицы.КПеремещению;
				
				Если СтрокаТаблицы.КПеремещению > 0 Тогда
					СтрокаТаблицы.Отметка = Истина;
				КонецЕсли;
				
				КоличествоДоступно = КоличествоДоступно - СтрокаТаблицы.КПеремещению;
				
			КонецЦикла;
		
		ИначеЕсли Параметры.Режим = "ОБЕСПЕЧЕНИЕ_ПОТРЕБНОСТЕЙ" Тогда
			
			Для Каждого СтрокаТаблицы Из Объект.ТоварРасшифровка Цикл
				
				Если СтрокаТаблицы.ЭтоЗаГраницейПериода Или КоличествоПотребность <= 0 Тогда
					Прервать;
				КонецЕсли;
				
				СтрокаТаблицы.КПеремещению = Мин(СтрокаТаблицы.Доступно, КоличествоПотребность);
				СтрокаТаблицы.КПеремещениюПоСтроке = СтрокаТаблицы.КПеремещению;
				
				Если СтрокаТаблицы.КПеремещению > 0 Тогда
					СтрокаТаблицы.Отметка = Истина;
				КонецЕсли;
				
				КоличествоПотребность = КоличествоПотребность - СтрокаТаблицы.КПеремещению;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Итоги;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКоличествоКПеремещениюПоДаннымРасшифровки(ДанныеРасшифровки)
	
	ТаблицаДанныеРасшифровки = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	
	Для Счетчик = 1 По ТаблицаДанныеРасшифровки.Количество() Цикл
		
		СтрокаРасшифровки = ТаблицаДанныеРасшифровки[Счетчик - 1];
		
		НайденнаяСтрока = Неопределено;
		Для Каждого СтрокаТаблицы Из Объект.ТоварРасшифровка Цикл
			
			Если СтрокаТаблицы.Период < СтрокаРасшифровки.Период
					Или СтрокаТаблицы.Период = СтрокаРасшифровки.Период И СтрокаТаблицы.ДатаПотребности < СтрокаРасшифровки.ДатаПотребности
					Или СтрокаТаблицы.Период = СтрокаРасшифровки.Период И СтрокаТаблицы.ДатаПотребности = СтрокаРасшифровки.ДатаПотребности
						И СтрокаТаблицы.СкладНаименование < СтрокаРасшифровки.СкладНаименование Тогда
				
				Продолжить;
				
			Иначе
				
				Если СтрокаТаблицы.Период = СтрокаРасшифровки.Период И СтрокаТаблицы.ДатаПотребности = СтрокаРасшифровки.ДатаПотребности
						И СтрокаТаблицы.Склад = СтрокаРасшифровки.Склад Тогда
				
					НайденнаяСтрока = СтрокаТаблицы;
					
				Иначе
					
					НайденнаяСтрока = Объект.ТоварРасшифровка.Вставить(Объект.ТоварРасшифровка.Индекс(СтрокаТаблицы));
					НайденнаяСтрока.ЭтоЗаГраницейПериода = Истина;
					
				КонецЕсли;
				
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если НайденнаяСтрока = Неопределено Тогда
			
			НайденнаяСтрока = Объект.ТоварРасшифровка.Добавить();
			НайденнаяСтрока.ЭтоЗаГраницейПериода = Истина;
			
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(НайденнаяСтрока, СтрокаРасшифровки);
		НайденнаяСтрока.КПеремещениюПоСтроке = НайденнаяСтрока.КПеремещению;
		
		Если НайденнаяСтрока.КПеремещению > 0 Тогда
			НайденнаяСтрока.Отметка = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
	
&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Оформление просроченных дат потребности.
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварРасшифровкаПериод.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТоварРасшифровка.ЭтоДефицит");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	
	// Оформление дат потребности за границей обеспечиваемого периода.
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварРасшифровка.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТоварРасшифровка.ЭтоЗаГраницейПериода");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	
	Если Параметры.Режим = "РАСПРЕДЕЛЕНИЕ_ОСТАТКОВ" Тогда
		
		// Оформление К перемещению > Доступно.
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НадписьКПеремещению.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТоварРасшифровка.ИтогКПеремещениюПоСтроке");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
		ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("НадписьДоступно");
		
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
		
	ИначеЕсли Параметры.Режим = "ОБЕСПЕЧЕНИЕ_ПОТРЕБНОСТЕЙ" Тогда
		
		// Оформление К перемещению > Потребность.
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НадписьКПеремещению.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТоварРасшифровка.ИтогКПеремещениюПоСтроке");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
		ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("НадписьПотребность");
		
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
		
		// Оформление К перемещению > Доступно.
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварРасшифровкаКПеремещению.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТоварРасшифровка.КПеремещениюПоСтроке");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
		ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТоварРасшифровка.Доступно");
		
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьВоВременноеХранилищеТоварРасшифровка()
	
	ТаблицаЗначений = Объект.ТоварРасшифровка.Выгрузить(
		Новый Структура("Отметка", Истина),
		"Период, ДатаПотребности, СкладНаименование, Склад, КПеремещению");
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаЗначений);
	
КонецФункции

#КонецОбласти
