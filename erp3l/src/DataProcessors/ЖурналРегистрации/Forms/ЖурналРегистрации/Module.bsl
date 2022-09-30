///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	МодельСервиса = ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
	
	ОтборЖурналаРегистрации = Новый Структура;
	ОтборЖурналаРегистрацииПоУмолчанию = Новый Структура;
	ЗначенияОтбора = ПолучитьЗначенияОтбораЖурналаРегистрации("Событие").Событие;
	
	Если Не ПустаяСтрока(Параметры.Пользователь) Тогда
		Если ТипЗнч(Параметры.Пользователь) = Тип("СписокЗначений") Тогда
			ОтборПоПользователю = Параметры.Пользователь;
		Иначе
			ИмяПользователя = Параметры.Пользователь;
			ОтборПоПользователю = Новый СписокЗначений;
			ОтборПоПользователю.Добавить(ИмяПользователя, ИмяПользователя);
		КонецЕсли;
		ОтборЖурналаРегистрации.Вставить("Пользователь", ОтборПоПользователю);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.СобытиеЖурналаРегистрации) Тогда
		ОтборПоСобытию = Новый СписокЗначений;
		Если ТипЗнч(Параметры.СобытиеЖурналаРегистрации) = Тип("Массив") Тогда
			Для Каждого Событие Из Параметры.СобытиеЖурналаРегистрации Цикл
				ПредставлениеСобытия = ЗначенияОтбора[Событие];
				ОтборПоСобытию.Добавить(Событие, ПредставлениеСобытия);
			КонецЦикла;
		Иначе
			ОтборПоСобытию.Добавить(Параметры.СобытиеЖурналаРегистрации, Параметры.СобытиеЖурналаРегистрации);
		КонецЕсли;
		ОтборЖурналаРегистрации.Вставить("Событие", ОтборПоСобытию);
	КонецЕсли;
	
	Если МодельСервиса Тогда
		ОтборЖурналаРегистрации.Вставить("ДатаНачала", НачалоДня(ТекущаяДатаСеанса()));
		ОтборЖурналаРегистрации.Вставить("ДатаОкончания", КонецДня(ТекущаяДатаСеанса()));
	Иначе
		Если ЗначениеЗаполнено(Параметры.ДатаНачала) Тогда
			ОтборЖурналаРегистрации.Вставить("ДатаНачала", Параметры.ДатаНачала);
		Иначе
			ОтборЖурналаРегистрации.Вставить("ДатаНачала", НачалоДня(ТекущаяДатаСеанса()));
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Параметры.ДатаОкончания) Тогда
			ОтборЖурналаРегистрации.Вставить("ДатаОкончания", Параметры.ДатаОкончания + 1);
		Иначе
			ОтборЖурналаРегистрации.Вставить("ДатаОкончания", КонецДня(ТекущаяДатаСеанса()));
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Данные <> Неопределено Тогда
		ОтборЖурналаРегистрации.Вставить("Данные", Параметры.Данные);
	КонецЕсли;
	
	Если Параметры.Сеанс <> Неопределено Тогда
		ОтборЖурналаРегистрации.Вставить("Сеанс", Параметры.Сеанс);
	КонецЕсли;
	
	// Уровень - список значений.
	Если Параметры.Уровень <> Неопределено Тогда
		ОтборПоУровню = Новый СписокЗначений;
		Если ТипЗнч(Параметры.Уровень) = Тип("Массив") Тогда
			Для Каждого ПредставлениеУровня Из Параметры.Уровень Цикл
				ОтборПоУровню.Добавить(ПредставлениеУровня, ПредставлениеУровня);
			КонецЦикла;
		ИначеЕсли ТипЗнч(Параметры.Уровень) = Тип("Строка") Тогда
			ОтборПоУровню.Добавить(Параметры.Уровень, Параметры.Уровень);
		Иначе
			ОтборПоУровню = Параметры.Уровень;
		КонецЕсли;
		ОтборЖурналаРегистрации.Вставить("Уровень", ОтборПоУровню);
	КонецЕсли;
	
	// ИмяПриложения - список значений.
	Если Параметры.ИмяПриложения <> Неопределено Тогда
		СписокПриложений = Новый СписокЗначений;
		Для Каждого Приложение Из Параметры.ИмяПриложения Цикл
			СписокПриложений.Добавить(Приложение, ПредставлениеПриложения(Приложение));
		КонецЦикла;
		ОтборЖурналаРегистрации.Вставить("ИмяПриложения", СписокПриложений);
	КонецЕсли;
	
	КоличествоПоказываемыхСобытий = 200;
	
	ОтборПоУмолчанию = ОтборПоУмолчанию(ЗначенияОтбора);
	Если Не ОтборЖурналаРегистрации.Свойство("Событие") Тогда
		ОтборЖурналаРегистрации.Вставить("Событие", ОтборПоУмолчанию);
	КонецЕсли;
	ОтборЖурналаРегистрацииПоУмолчанию.Вставить("Событие", ОтборПоУмолчанию);
	Элементы.ПредставлениеРазделенияДанныхСеанса.Видимость = Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
	
	Критичность = "ВсеСобытия";
	
	// Взводится в значение Истина, если нужно, чтобы формирование журнала регистрации проходило не в фоне.
	ЗапускатьНеВФоне = Параметры.ЗапускатьНеВФоне;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Критичность",	"ПоложениеЗаголовка",		ПоложениеЗаголовкаЭлементаФормы.Нет);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Критичность",	"КнопкаВыбора",				Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Журнал", 		"ПоложениеКоманднойПанели", ПоложениеКоманднойПанелиЭлементаФормы.Нет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Данные.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Журнал.Данные");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПредставлениеМетаданных.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Журнал.ПредставлениеМетаданных");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ОбновитьТекущийСписок", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоличествоПоказываемыхСобытийПриИзменении(Элемент)
	
#Если ВебКлиент ИЛИ МобильныйКлиент Тогда
	КоличествоПоказываемыхСобытий = ?(КоличествоПоказываемыхСобытий > 1000, 1000, КоличествоПоказываемыхСобытий);
#КонецЕсли
	
	ОбновитьТекущийСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура КритичностьПриИзменении(Элемент)
	
	ОтборЖурналаРегистрации.Удалить("Уровень");
	ОтборПоУровню = Новый СписокЗначений;
	Если Критичность = "Ошибка" Тогда
		ОтборПоУровню.Добавить("Ошибка", "Ошибка");
	ИначеЕсли Критичность = "Предупреждение" Тогда
		ОтборПоУровню.Добавить("Предупреждение", "Предупреждение");
	ИначеЕсли Критичность = "Информация" Тогда
		ОтборПоУровню.Добавить("Информация", "Информация");
	ИначеЕсли Критичность = "Примечание" Тогда
		ОтборПоУровню.Добавить("Примечание", "Примечание");
	КонецЕсли;
	
	Если ОтборПоУровню.Количество() > 0 Тогда
		ОтборЖурналаРегистрации.Вставить("Уровень", ОтборПоУровню);
	КонецЕсли;
	
	ОбновитьТекущийСписок();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЖурнал

&НаКлиенте
Процедура ЖурналВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("ТекущиеДанные", Элементы.Журнал.ТекущиеДанные);
	ПараметрыВыбора.Вставить("Поле", Поле);
	ПараметрыВыбора.Вставить("ИнтервалДат", ИнтервалДат);
	ПараметрыВыбора.Вставить("ОтборЖурналаРегистрации", ОтборЖурналаРегистрации);
	ПараметрыВыбора.Вставить("ХранилищеДанных", ХранилищеДанных);
	
	ЖурналРегистрацииКлиент.СобытияВыбор(ПараметрыВыбора);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") И ВыбранноеЗначение.Свойство("Событие") Тогда
		
		Если ВыбранноеЗначение.Событие = "УстановленОтборЖурналаРегистрации" Тогда
			
			ОтборЖурналаРегистрации.Очистить();
			Для Каждого ЭлементСписка Из ВыбранноеЗначение.Отбор Цикл
				ОтборЖурналаРегистрации.Вставить(ЭлементСписка.Представление, ЭлементСписка.Значение);
			КонецЦикла;
			
			Если ОтборЖурналаРегистрации.Свойство("Уровень") Тогда
				Если ОтборЖурналаРегистрации.Уровень.Количество() > 0 Тогда
					Критичность = Строка(ОтборЖурналаРегистрации.Уровень);
				КонецЕсли;
			Иначе
				Критичность = "ВсеСобытия";
			КонецЕсли;
			
			ОбновитьТекущийСписок();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьТекущийСписок()
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.ИндикаторДлительныхОпераций;
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "ФормированиеОтчета");
	
	РезультатВыполнения = ПрочитатьЖурнал();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбновитьТекущийСписокЗавершение", ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(РезультатВыполнения, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекущийСписокЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		ЗагрузитьПодготовленныеДанные(Результат.АдресРезультата);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "НеИспользовать");
		Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
		ПозиционированиеВКонецСписка();
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "НеИспользовать");
		Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
		ПозиционированиеВКонецСписка();
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтбор()
	
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрацииПоУмолчанию;
	Критичность = "ВсеСобытия";
	ОбновитьТекущийСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДанныеДляПросмотра()
	
	ЖурналРегистрацииКлиент.ОткрытьДанныеДляПросмотра(Элементы.Журнал.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотрТекущегоСобытияВОтдельномОкне()
	
	ЖурналРегистрацииКлиент.ПросмотрТекущегоСобытияВОтдельномОкне(Элементы.Журнал.ТекущиеДанные, ХранилищеДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалДатДляПросмотра()
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИнтервалДатДляПросмотраЗавершение", ЭтотОбъект);
	ЖурналРегистрацииКлиент.УстановитьИнтервалДатДляПросмотра(ИнтервалДат, ОтборЖурналаРегистрации, Оповещение)
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтбор()
	
	УстановитьОтборНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеОтбораНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	УстановитьОтборНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоЗначениюВТекущейКолонке()
	
	КолонкиИсключения = Новый Массив;
	КолонкиИсключения.Добавить("Дата");
	
	Если ЖурналРегистрацииКлиент.УстановитьОтборПоЗначениюВТекущейКолонке(
			Элементы.Журнал.ТекущиеДанные,
			Элементы.Журнал.ТекущийЭлемент,
			ОтборЖурналаРегистрации,
			КолонкиИсключения) Тогда
		
		ОбновитьТекущийСписок();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьЖурналДляПередачиВТехподдержку(Команда)
	
	ПараметрыСохраненияФайла = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ПараметрыСохраненияФайла.Диалог.Фильтр = НСтр("ru = 'Данные журнала регистрации';
													|en = 'Event Log data'") + "(*.xml)|*.xml";
	ФайловаяСистемаКлиент.СохранитьФайл(Неопределено, ВыгрузкаЖурналаРегистрации(), "EventLog.xml", ПараметрыСохраненияФайла);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьИнтервалДатДляПросмотраЗавершение(ИнтервалУстановлен, ДополнительныеПараметры) Экспорт
	
	Если ИнтервалУстановлен Тогда
		ОбновитьТекущийСписок();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОтборПоУмолчанию(СписокСобытий)
	
	ОтборПоУмолчанию = Новый СписокЗначений;
	
	Для Каждого СобытиеЖурнала Из СписокСобытий Цикл
		
		Если СобытиеЖурнала.Ключ = "_$Transaction$_.Commit"
			Или СобытиеЖурнала.Ключ = "_$Transaction$_.Begin"
			Или СобытиеЖурнала.Ключ = "_$Transaction$_.Rollback" Тогда
			Продолжить;
		КонецЕсли;
		
		ОтборПоУмолчанию.Добавить(СобытиеЖурнала.Ключ, СобытиеЖурнала.Значение);
		
	КонецЦикла;
	
	Возврат ОтборПоУмолчанию;
КонецФункции

&НаСервере
Функция ПрочитатьЖурнал()
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	КонецЕсли;
	
	ДатаНачала    = Неопределено; // Дата
	ДатаОкончания = Неопределено; // Дата
	ДатыОтбораУказаны = ОтборЖурналаРегистрации.Свойство("ДатаНачала", ДатаНачала) И ОтборЖурналаРегистрации.Свойство("ДатаОкончания", ДатаОкончания)
		И ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания);
		
	Если ДатыОтбораУказаны И ДатаНачала > ДатаОкончания Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "НеИспользовать");
		Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
		ВызватьИсключение НСтр("ru = 'Некорректно заданы условия отбора журнала регистрации.
			|Дата начала не может быть больше даты окончания.';
			|en = 'Incorrect event log filter settings. 
			|The start date cannot be later than the end date.'");
	КонецЕсли;
	
	ПараметрыОтчета = ПараметрыОтчета();
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0; // запускать сразу
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обновление журнала регистрации';
															|en = 'Updating event log'");
	ПараметрыВыполнения.ЗапуститьНеВФоне = ЗапускатьНеВФоне;
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне("ЖурналРегистрации.ПрочитатьСобытияЖурналаРегистрации",
		ПараметрыОтчета, ПараметрыВыполнения);
	
	Если РезультатВыполнения.Статус = "Ошибка" Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
		ВызватьИсключение РезультатВыполнения.КраткоеПредставлениеОшибки;
	КонецЕсли;
	ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	
	ЖурналРегистрации.СформироватьПредставлениеОтбора(ПредставлениеОтбора, ОтборЖурналаРегистрации, ОтборЖурналаРегистрацииПоУмолчанию);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Функция ПараметрыОтчета()
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ОтборЖурналаРегистрации", ОтборЖурналаРегистрации);
	ПараметрыОтчета.Вставить("КоличествоПоказываемыхСобытий", КоличествоПоказываемыхСобытий);
	ПараметрыОтчета.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("МенеджерВладельца", Обработки.ЖурналРегистрации);
	ПараметрыОтчета.Вставить("ДобавлятьДополнительныеКолонки", Ложь);
	ПараметрыОтчета.Вставить("Журнал", РеквизитФормыВЗначение("Журнал"));

	Возврат ПараметрыОтчета;
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные(АдресРезультата)
	Результат      = ПолучитьИзВременногоХранилища(АдресРезультата);
	СобытияЖурнала = Результат.СобытияЖурнала;
	
	Если ХранилищеДанных = Неопределено Тогда
		Адрес = УникальныйИдентификатор;
	Иначе
		Адрес = ХранилищеДанных;
	КонецЕсли;
	ХранилищеДанных = ПоместитьВоВременноеХранилище(Новый Соответствие, Адрес);
	ЖурналРегистрации.ПоместитьДанныеВоВременноеХранилище(СобытияЖурнала, ХранилищеДанных);
	
	ЗначениеВДанныеФормы(СобытияЖурнала, Журнал);
КонецПроцедуры

&НаКлиенте
Процедура ПозиционированиеВКонецСписка()
	Если Журнал.Количество() > 0 Тогда
		Элементы.Журнал.ТекущаяСтрока = Журнал[Журнал.Количество() - 1].ПолучитьИдентификатор();
	КонецЕсли;
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьОтборНаКлиенте()
	
	ОтборФормы = Новый СписокЗначений;
	Для Каждого КлючИЗначение Из ОтборЖурналаРегистрации Цикл
		ОтборФормы.Добавить(КлючИЗначение.Значение, КлючИЗначение.Ключ);
	КонецЦикла;
	
	ОткрытьФорму(
		"Обработка.ЖурналРегистрации.Форма.ОтборЖурналаРегистрации", 
		Новый Структура("Отбор, СобытияПоУмолчанию", ОтборФормы, ОтборЖурналаРегистрацииПоУмолчанию.Событие), 
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КритичностьОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаСервере
Функция ВыгрузкаЖурналаРегистрации()
	Возврат ЖурналРегистрации.ЖурналДляТехподдержки(ОтборЖурналаРегистрации, КоличествоПоказываемыхСобытий, УникальныйИдентификатор);
КонецФункции

#КонецОбласти
