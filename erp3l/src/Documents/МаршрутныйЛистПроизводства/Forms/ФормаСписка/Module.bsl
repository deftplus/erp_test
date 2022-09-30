//++ Устарело_Производство21
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("ОтборПоСпискуЗаказов") Тогда
		ОтборПоСпискуЗаказов(Параметры.ОтборПоСпискуЗаказов);
	ИначеЕсли Параметры.Свойство("ОтборПоСпискуПродукции") Тогда
		ОтборПоСпискуПродукции(Параметры.ОтборПоСпискуПродукции);
	ИначеЕсли Параметры.Свойство("ОтборПоСпискуЭтаповГрафика") Тогда
		ОтборПоСпискуЭтаповГрафика(Параметры.ОтборПоСпискуЭтаповГрафика);
	ИначеЕсли Параметры.Свойство("ОтборПоСпискуЭтапов") Тогда
		ОтборПоСпискуЭтапов(Параметры.ОтборПоСпискуЭтапов);
	КонецЕсли; 
	
	Список.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности", НачалоДня(ТекущаяДатаСеанса()));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "СписокРабочихЦентров", Новый Массив);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ЕстьОтборПоРабочемуЦентру", Ложь);
	
	Если Параметры.Свойство("Подразделение", Подразделение) Тогда
		УстановитьОтборПоПодразделению();
	КонецЕсли; 
	
	ОпределитьУправлениеМаршрутнымиЛистами();
	
	Если Параметры.Свойство("РабочийЦентр", ОтборРабочийЦентр) Тогда
		УстановитьОтборПоРабочемуЦентру();
	КонецЕсли; 
	
	Если Параметры.Свойство("Статус", Статус) Тогда
		УстановитьОтборПоСтатусу();
	КонецЕсли; 
	
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.ДиспетчерОтбор.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Документы.МаршрутныйЛистПроизводства));
		
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.СписокКоманднаяПанель);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если Параметры.Свойство("НеЗагружатьОтборы") Тогда
		Настройки.Удалить("Подразделение");
		Настройки.Удалить("ОтборРабочийЦентр");
		Настройки.Удалить("Статус");
	КонецЕсли; 
	
	Если Параметры.Свойство("Подразделение") Тогда
		Настройки.Вставить("Подразделение", Параметры.Подразделение);
	КонецЕсли;
	Если Параметры.Свойство("РабочийЦентр") Тогда
		Настройки.Вставить("ОтборРабочийЦентр", Параметры.РабочийЦентр);
	КонецЕсли; 
	Если Параметры.Свойство("Статус") Тогда
		Настройки.Вставить("Статус", Параметры.Статус);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОпределитьУправлениеМаршрутнымиЛистами();
	
	УстановитьОтборПоДиспетчеру();
	УстановитьОтборПоСтатусу();
	УстановитьОтборПоПодразделению();
	УстановитьОтборПоРабочемуЦентру();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусОтборПриИзменении(Элемент)
	
	УстановитьОтборПоСтатусу();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеОтборПриИзменении(Элемент)
	
	УстановитьОтборПоПодразделению();
	
КонецПроцедуры
 
&НаКлиенте
Процедура ДиспетчерОтборПриИзменении(Элемент)
	
	УстановитьОтборПоДиспетчеру();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборРабочийЦентрПриИзменении(Элемент)
	
	УстановитьОтборПоРабочемуЦентру();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	Если Параметры.Свойство("ОтборПоСпискуЗаказов")
		ИЛИ Параметры.Свойство("ОтборПоСпискуПродукции")
		ИЛИ Параметры.Свойство("ОтборПоСпискуЭтапов")
		ИЛИ Параметры.Свойство("ОтборПоСпискуЭтаповГрафика") Тогда
		
		ОчиститьПользовательскиеОтборы(Настройки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если НЕ Копирование Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура КомандаУстановитьСтатусСоздан(Команда)
	
	УстановитьСтатус("Создан", НСтр("ru = 'Создан';
									|en = 'Created'"));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьСтатусКВыполнению(Команда)
	
	УстановитьСтатус("КВыполнению", НСтр("ru = 'К выполнению';
										|en = 'For completion'"));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьСтатусВыполняется(Команда)
	
	УстановитьСтатус("Выполняется", НСтр("ru = 'Выполняется';
										|en = 'Active'"));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьСтатусВыполнен(Команда)
	
	УстановитьСтатус("Выполнен", НСтр("ru = 'Выполнен';
										|en = 'Completed'"));
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

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
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыМаршрутныхЛистовПроизводства.Выполнен;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЗакрытыйДокумент);
	

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);


КонецПроцедуры

#Область Отборы

&НаСервере
Процедура УстановитьОтборПоСтатусу()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Статус", 
		Статус, 
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Статус));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоДиспетчеру()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Диспетчер", 
		Диспетчер, 
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Диспетчер));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПодразделению()

	ОпределитьУправлениеМаршрутнымиЛистами();
	УстановитьОтборПоРабочемуЦентру();
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Подразделение", 
		Подразделение, 
		ВидСравненияКомпоновкиДанных.ВИерархии,
		, // Представление - автоматически
		ЗначениеЗаполнено(Подразделение));

КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоРабочемуЦентру()

	// Определим рабочие центры, которые относятся к выбранному РЦ
	Если НЕ ОтборРабочийЦентр.Пустая() Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	РабочиеЦентры.Ссылка
		|ИЗ
		|	Справочник.РабочиеЦентры КАК РабочиеЦентры
		|ГДЕ
		|	РабочиеЦентры.Ссылка В ИЕРАРХИИ(&РабочийЦентр)";
		Запрос.УстановитьПараметр("РабочийЦентр", ОтборРабочийЦентр);
		
		СписокРабочихЦентров = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	Иначе
		СписокРабочихЦентров = Новый Массив;
	КонецЕсли; 
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "СписокРабочихЦентров", СписокРабочихЦентров);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ЕстьОтборПоРабочемуЦентру", НЕ ОтборРабочийЦентр.Пустая());

КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.МаршрутныйЛистПроизводства.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочие

&НаКлиенте
Процедура УстановитьСтатус(ЗначениеСтатуса, ПредставлениеСтатуса)

	ВыделенныеСсылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЗначениеСтатуса",      ЗначениеСтатуса);
	ДополнительныеПараметры.Вставить("ПредставлениеСтатуса", ПредставлениеСтатуса);
	ДополнительныеПараметры.Вставить("ВыделенныеСсылки",     ВыделенныеСсылки);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВопросУстановитьСтатус", ЭтаФорма, ДополнительныеПараметры);
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'У выделенных в списке документов будет установлен статус ""%1"". Продолжить?';
																				|en = 'The ""%1"" status will be set for the documents selected in the list. Continue?'"), ПредставлениеСтатуса);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура ВопросУстановитьСтатус(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(
										ДополнительныеПараметры.ВыделенныеСсылки, 
										ДополнительныеПараметры.ЗначениеСтатуса);
										
	ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(
			Элементы.Список, 
			КоличествоОбработанных, 
			ДополнительныеПараметры.ВыделенныеСсылки.Количество(), 
			ДополнительныеПараметры.ПредставлениеСтатуса);

КонецПроцедуры

&НаСервере
Процедура ОпределитьУправлениеМаршрутнымиЛистами()

	Если НЕ Подразделение.Пустая() Тогда
		ПараметрыПодразделения = ПроизводствоСервер.ПараметрыПроизводственногоПодразделения(Подразделение);
		УправлениеМаршрутнымиЛистами = ПараметрыПодразделения.УправлениеМаршрутнымиЛистами;
	Иначе
		УправлениеМаршрутнымиЛистами = Перечисления.УправлениеМаршрутнымиЛистами.ПустаяСсылка();
		ОтборРабочийЦентр = Справочники.РабочиеЦентры.ПустаяСсылка();
	КонецЕсли;

	ВидимостьОтбораПоРЦ = (НЕ Подразделение.Пустая());
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтборРабочийЦентр", "Видимость", ВидимостьОтбораПоРЦ);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "УправлениеМаршрутнымиЛистами", УправлениеМаршрутнымиЛистами);
	
КонецПроцедуры

&НаСервере
Процедура ОтборПоСпискуЗаказов(СписокЗаказов)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Распоряжение", СписокЗаказов);

	Заголовок = НСтр("ru = 'Маршрутные листы производства (установлен отбор по заказам)';
					|en = 'Production route sheets (filter by orders is set)'");
	АвтоЗаголовок = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ОтборПоСпискуПродукции(СписокПродукции)

	ТаблицаПродукции = Новый ТаблицаЗначений;
	ТаблицаПродукции.Колонки.Добавить("Заказ", Новый ОписаниеТипов("ДокументСсылка.ЗаказНаПроизводство"));
	ТаблицаПродукции.Колонки.Добавить("КодСтроки", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10,0,ДопустимыйЗнак.Неотрицательный)));
	Для каждого ДанныеПродукции Из СписокПродукции Цикл
		СтрокаПродукции = ТаблицаПродукции.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПродукции, ДанныеПродукции);
	КонецЦикла; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаПродукции.Заказ КАК Заказ,
	|	ТаблицаПродукции.КодСтроки КАК КодСтроки
	|ПОМЕСТИТЬ ТаблицаПродукции
	|ИЗ
	|	&ТаблицаПродукции КАК ТаблицаПродукции
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Заказ,
	|	КодСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	МаршрутныйЛистПроизводства.Ссылка
	|ИЗ
	|	ТаблицаПродукции КАК ТаблицаПродукции
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.МаршрутныйЛистПроизводства КАК МаршрутныйЛистПроизводства
	|		ПО (МаршрутныйЛистПроизводства.Распоряжение = ТаблицаПродукции.Заказ)
	|			И (МаршрутныйЛистПроизводства.КодСтроки = ТаблицаПродукции.КодСтроки)";
	
	Запрос.УстановитьПараметр("ТаблицаПродукции", ТаблицаПродукции);
	
	СписокДокументов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", СписокДокументов);

	Заголовок = НСтр("ru = 'Маршрутные листы производства (установлен отбор по продукции)';
					|en = 'Production route sheets (filter by products is set)'");
	АвтоЗаголовок = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ОтборПоСпискуЭтаповГрафика(СписокЭтапов)

	ТаблицаЭтапов = Новый ТаблицаЗначений;
	ТаблицаЭтапов.Колонки.Добавить("Заказ", Новый ОписаниеТипов("ДокументСсылка.ЗаказНаПроизводство"));
	ТаблицаЭтапов.Колонки.Добавить("КодСтрокиПродукция", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10,0,ДопустимыйЗнак.Неотрицательный)));
	ТаблицаЭтапов.Колонки.Добавить("КодСтрокиЭтапыГрафик", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10,0,ДопустимыйЗнак.Неотрицательный)));
	Для каждого ДанныеЭтапа Из СписокЭтапов Цикл
		СтрокаЭтап = ТаблицаЭтапов.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаЭтап, ДанныеЭтапа);
	КонецЦикла; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаЭтапов.Заказ КАК Заказ,
	|	ТаблицаЭтапов.КодСтрокиПродукция КАК КодСтрокиПродукция,
	|	ТаблицаЭтапов.КодСтрокиЭтапыГрафик КАК КодСтрокиЭтапыГрафик
	|ПОМЕСТИТЬ ТаблицаЭтапов
	|ИЗ
	|	&ТаблицаЭтапов КАК ТаблицаЭтапов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Заказ,
	|	КодСтрокиПродукция,
	|	КодСтрокиЭтапыГрафик
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	МаршрутныйЛистПроизводства.Ссылка
	|ИЗ
	|	ТаблицаЭтапов КАК ТаблицаЭтапов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.МаршрутныйЛистПроизводства КАК МаршрутныйЛистПроизводства
	|		ПО (МаршрутныйЛистПроизводства.Распоряжение = ТаблицаЭтапов.Заказ)
	|			И (МаршрутныйЛистПроизводства.КодСтроки = ТаблицаЭтапов.КодСтрокиПродукция)
	|			И (МаршрутныйЛистПроизводства.КодСтрокиЭтапыГрафик = ТаблицаЭтапов.КодСтрокиЭтапыГрафик)";
	
	Запрос.УстановитьПараметр("ТаблицаЭтапов", ТаблицаЭтапов);
	
	СписокДокументов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", СписокДокументов);

	Заголовок = НСтр("ru = 'Маршрутные листы производства (установлен отбор по этапам)';
					|en = 'Production route sheets (filter by stages is set)'");
	АвтоЗаголовок = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ОтборПоСпискуЭтапов(СписокЭтапов)

	ТаблицаЭтапов = Новый ТаблицаЗначений;
	ТаблицаЭтапов.Колонки.Добавить("Заказ", Новый ОписаниеТипов("ДокументСсылка.ЗаказНаПроизводство"));
	ТаблицаЭтапов.Колонки.Добавить("КодСтрокиПродукция", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10,0,ДопустимыйЗнак.Неотрицательный)));
	ТаблицаЭтапов.Колонки.Добавить("Этап", Новый ОписаниеТипов("СправочникСсылка.ЭтапыПроизводства"));
	Для каждого ДанныеЭтапа Из СписокЭтапов Цикл
		СтрокаЭтап = ТаблицаЭтапов.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаЭтап, ДанныеЭтапа);
	КонецЦикла; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаЭтапов.Заказ КАК Заказ,
	|	ТаблицаЭтапов.КодСтрокиПродукция КАК КодСтрокиПродукция,
	|	ТаблицаЭтапов.Этап КАК Этап
	|ПОМЕСТИТЬ ТаблицаЭтапов
	|ИЗ
	|	&ТаблицаЭтапов КАК ТаблицаЭтапов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Заказ,
	|	КодСтрокиПродукция,
	|	Этап
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	МаршрутныйЛистПроизводства.Ссылка
	|ИЗ
	|	ТаблицаЭтапов КАК ТаблицаЭтапов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.МаршрутныйЛистПроизводства КАК МаршрутныйЛистПроизводства
	|		ПО (МаршрутныйЛистПроизводства.Распоряжение = ТаблицаЭтапов.Заказ)
	|			И (МаршрутныйЛистПроизводства.КодСтроки = ТаблицаЭтапов.КодСтрокиПродукция)
	|			И (МаршрутныйЛистПроизводства.Этап = ТаблицаЭтапов.Этап)";
	
	Запрос.УстановитьПараметр("ТаблицаЭтапов", ТаблицаЭтапов);
	
	СписокДокументов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", СписокДокументов);

	Заголовок = НСтр("ru = 'Маршрутные листы производства (установлен отбор по этапам)';
					|en = 'Production route sheets (filter by stages is set)'");
	АвтоЗаголовок = Ложь;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОчиститьПользовательскиеОтборы(Настройки)
	
	Для Каждого ЭлементКоллекции Из Настройки.Элементы Цикл
		
		Если ТипЗнч(ЭлементКоллекции) = Тип("ОтборКомпоновкиДанных") Тогда
			ЭлементКоллекции.Элементы.Очистить();
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
//-- Устарело_Производство21