
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный", "Объект.Организация", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ПриПолученииДанныхНаСервере("Объект");
		
		Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
			СотрудникПриИзмененииНаСервере();
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьИнфонадписьИсправления(ЭтотОбъект);
	
	ОбработатьОтображениеПоясненийАдреса();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ЗапросВФССОПроверкеРаботодателя", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ФиксацияСохранитьРеквизитыФормыФикс(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ФиксацияВторичныхДанныхВДокументахФормы.УстановитьМодифицированность(ЭтотОбъект, Ложь);	
	ФиксацияЗаполнитьРеквизитыФормыФикс(ЭтотОбъект.Объект);
	ФиксацияУстановитьОбъектЗафиксирован();
	ФиксацияОбновитьФиксациюВФорме();
	
	УстановитьПредставлениеКИ();
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПослеЗаписиНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеДанныхФизическогоЛица" Тогда
		ОбновитьВторичныеДанныеДокумента(Ложь, Истина, Ложь);
	КонецЕсли;	
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Объект.Страхователи.Очистить();
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	Объект.Страхователи.Очистить();
	СотрудникПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = УправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
		ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица"),
		Объект.Адрес);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяРеквизита", "Адрес");
	
	Оповещение = Новый ОписаниеОповещения("АдресЗавершениеВыбора", ЭтотОбъект, ДополнительныеПараметры);
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, ЭтотОбъект, Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура АдресОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = УправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
		ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ЮрАдресОрганизации"),
		Объект.АдресОрганизации);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяРеквизита", "АдресОрганизации");
	
	Оповещение = Новый ОписаниеОповещения("АдресЗавершениеВыбора", ЭтотОбъект, ДополнительныеПараметры);
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, ЭтотОбъект, Оповещение);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСтрахователи

&НаКлиенте
Процедура СтрахователиСправкаПриИзменении(Элемент)
	СтрахователиСправкаПриИзмененииНаСервере(Элементы.Страхователи.ТекущаяСтрока);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОтменитьВсеИсправления(Команда) 
	ОтменитьВсеИсправленияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьКарточкуСотрудника(Команда)
	Если Не ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		Возврат;
	КонецЕсли;
	ПараметрыФормы = Новый Структура("Ключ", Объект.Сотрудник);
	ОткрытьФорму("Справочник.Сотрудники.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьИсправленияДанныхСотрудника(Команда)
	
	ФиксацияСброситьФиксациюИзмененийПоОснованиюЗаполнения("Сотрудник");
	ОбновитьВторичныеДанныеДокумента(Ложь, Истина, Истина);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ПодписиДокументов

// ЗарплатаКадрыПодсистемы.ПодписиДокументов
&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементПриИзменении(Элемент)
	ПодписиДокументовКлиент.ПриИзмененииПодписывающегоЛица(ЭтотОбъект, Элемент.Имя);
	Если Элемент.Имя = ПодписиДокументовКлиентСервер.ИмяЭлементаФормыПоРолиПодписанта("Руководитель") Тогда
		ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтотОбъект, "Руководитель");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементНажатие(Элемент)
	ПодписиДокументовКлиент.РасширеннаяПодсказкаНажатие(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры
// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов

#КонецОбласти

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	ФиксацияВторичныхДанныхВДокументахФормы.ИнициализироватьМеханизмФиксацииРеквизитов(ЭтотОбъект, ТекущийОбъект);
	ФиксацияВторичныхДанныхВДокументахФормы.ПодключитьОбработчикиФиксацииИзмененийРеквизитов(ЭтотОбъект, ФиксацияЭлементыОбработчикаЗафиксироватьИзменение());
	ФиксацияВторичныхДанныхВДокументахФормы.УстановитьМодифицированность(ЭтотОбъект, Ложь);	
	
	ОбновитьВторичныеДанныеДокумента(Истина, Истина, Ложь);
	
	ФиксацияОбновитьФиксациюВФорме();
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьВсеИсправленияНаСервере()
	
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОчиститьФиксациюИзменений(ЭтотОбъект, Объект);
	ФиксацияЗаполнитьРеквизитыФормыФикс(Объект);
	ФиксацияОбновитьФиксациюВФорме();
	ОбновитьВторичныеДанныеДокумента(Истина, Истина, Истина);
	ОбработатьОтображениеПоясненийАдреса();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОчиститьФиксациюИзменений(ЭтотОбъект, Объект);
	ФиксацияЗаполнитьРеквизитыФормыФикс(Объект);
	ФиксацияОбновитьФиксациюВФорме();
	ОбновитьВторичныеДанныеДокумента(Истина, Истина, Истина);
	ОбработатьОтображениеПоясненийАдреса();
	
КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	
	ФиксацияСброситьФиксациюИзмененийПоОснованиюЗаполнения("Сотрудник");
	Объект.Страхователи.Очистить();
	ОбновитьВторичныеДанныеДокумента(Ложь, Истина, Истина);
	ОбработатьОтображениеПоясненийАдреса();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресЗавершениеВыбора(РезультатОткрытияФормы, ПараметрыОповещения) Экспорт 
	
	Если ТипЗнч(РезультатОткрытияФормы) <> Тип("Структура") Тогда
		// не было изменений в данных
		Возврат;
	КонецЕсли;
	
	ИмяРеквизитаАдрес = ПараметрыОповещения.ИмяРеквизита;
	
	Объект[ИмяРеквизитаАдрес] = РезультатОткрытияФормы.КонтактнаяИнформация;
	ФиксацияЗафиксироватьИзменениеРеквизита(ИмяРеквизитаАдрес);
	ЭтотОбъект[ИмяРеквизитаАдрес] = РезультатОткрытияФормы.Представление;
	Модифицированность = Истина;
	ОбработатьОтображениеПоясненийАдреса();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставлениеКИ()
	КонтактнаяИнформацияБЗК.ОбновитьПолеВводаКонтактнойИнформации(
		ЭтотОбъект,
		"Адрес",
		Объект.Адрес,
		Перечисления.ТипыКонтактнойИнформации.Адрес);
	
	КонтактнаяИнформацияБЗК.ОбновитьПолеВводаКонтактнойИнформации(
		ЭтотОбъект,
		"АдресОрганизации",
		Объект.АдресОрганизации,
		Перечисления.ТипыКонтактнойИнформации.Адрес);
КонецПроцедуры

&НаСервере
Процедура ОбработатьОтображениеПоясненийАдреса()
	
	Адрес 			= ЭтотОбъект.Адрес;
	СписокПолей 	= Объект.Адрес;
	Элемент 		= ЭтотОбъект.Элементы["Адрес"];
	ВидАдреса 		= Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица;
	
	УправлениеКонтактнойИнформациейЗарплатаКадры.УстановитьОтображениеПоляАдреса(Адрес, СписокПолей, Элемент, ЭтотОбъект, ВидАдреса);	
	
	АдресОрганизации	= ЭтотОбъект.АдресОрганизации;
	СписокПолей 		= Объект.АдресОрганизации;
	Элемент 			= ЭтотОбъект.Элементы["АдресОрганизации"];
	ВидАдреса 			= Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации;
	
	УправлениеКонтактнойИнформациейЗарплатаКадры.УстановитьОтображениеПоляАдреса(АдресОрганизации, СписокПолей, Элемент, ЭтотОбъект, ВидАдреса);	
 
КонецПроцедуры

&НаСервере
Функция ОбъектЗафиксирован() Экспорт
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	Возврат ДокументОбъект.ОбъектЗафиксирован();
	
КонецФункции

#Область МеханизмФиксацииИзменений

&НаСервере
Функция ФиксацияОписаниеФормы(ПараметрыФиксацииВторичныхДанных) Экспорт
	
	ОписаниеФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеФормы();
	
	ОписаниеЭлементовФормы = Новый Соответствие();
	ОписаниеЭлементаФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеЭлементаФормы();
	
	ОписаниеЭлементаФормы.ПрефиксПути = "Объект";
	
	Для каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		ОписаниеЭлементовФормы.Вставить(ОписаниеФиксацииРеквизита.Ключ, ОписаниеЭлементаФормы);
	КонецЦикла;
	
	ПустоеОписаниеЭлементовФормы = Новый Соответствие();
	ПустоеОписаниеЭлементовФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеЭлементаФормы();
	ОписаниеЭлементовФормы.Вставить("Адрес", ПустоеОписаниеЭлементовФормы);
	ОписаниеЭлементовФормы.Вставить("АдресОрганизации", ПустоеОписаниеЭлементовФормы);
		
	ОписаниеФормы.Вставить("ОписаниеЭлементовФормы", ОписаниеЭлементовФормы);
	
	Возврат ОписаниеФормы;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ФиксацияЭлементыОбработчикаЗафиксироватьИзменение()
	
	ОписаниеЭлементов = Новый Соответствие;
	ОписаниеЭлементов.Вставить("НаименованиеТерриториальногоОрганаФСС",		"НаименованиеТерриториальногоОрганаФСС");
	ОписаниеЭлементов.Вставить("Руководитель",								"Руководитель");
	ОписаниеЭлементов.Вставить("ДолжностьРуководителя",						"ДолжностьРуководителя");
	ОписаниеЭлементов.Вставить("АдресОрганизации",							"АдресОрганизации");
	ОписаниеЭлементов.Вставить("РегистрационныйНомерФСС",					"РегистрационныйНомерФСС");
	ОписаниеЭлементов.Вставить("ДополнительныйКодФСС",						"ДополнительныйКодФСС");
	ОписаниеЭлементов.Вставить("КодПодчиненностиФСС",						"КодПодчиненностиФСС");
	
	// Данные сотрудника
	ОписаниеЭлементов.Вставить("Фамилия",									"Фамилия");
	ОписаниеЭлементов.Вставить("Имя",										"Имя");
	ОписаниеЭлементов.Вставить("Отчество",									"Отчество");
	ОписаниеЭлементов.Вставить("СтраховойНомерПФР",							"СтраховойНомерПФР");
	ОписаниеЭлементов.Вставить("Адрес",										"Адрес");
	         	
	Возврат	ОписаниеЭлементов
	
КонецФункции

&НаКлиенте
Процедура ФиксацияЗафиксироватьИзменениеРеквизита(ИмяРеквизита, ТекущаяСтрока = 0)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтотОбъект, ИмяРеквизита, ТекущаяСтрока)
КонецПроцедуры

&НаСервере
Процедура ФиксацияСброситьФиксациюИзмененийПоОснованиюЗаполнения(ОснованиеЗаполнения, ТекущаяСтрока = 0)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения(ЭтотОбъект, ОснованиеЗаполнения, ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ФиксацияОбновитьФиксациюВФорме()
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбновитьФорму(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ФиксацияЗаполнитьРеквизитыФормыФикс(ТекущийОбъект)
	ФиксацияВторичныхДанныхВДокументахФормы.ЗаполнитьРеквизитыФормыФикс(ЭтотОбъект, ТекущийОбъект);
КонецПроцедуры	

&НаСервере
Процедура ФиксацияСохранитьРеквизитыФормыФикс(Форма, ТекущийОбъект)   
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СохранитьРеквизитыФормыФикс(Форма, ТекущийОбъект);
КонецПроцедуры

&НаСервере
Функция ФиксацияПодготовленныйДокумент()
	
	ПодготовленныйДокумент = РеквизитФормыВЗначение("Объект");
	ФиксацияСохранитьРеквизитыФормыФикс(ЭтотОбъект, ПодготовленныйДокумент);
	
	Возврат ПодготовленныйДокумент;
	
КонецФункции 

&НаСервере
Процедура ФиксацияУстановитьОбъектЗафиксирован();
	 ФиксацияВторичныхДанныхВДокументахФормы.УстановитьОбъектЗафиксирован(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьВторичныеДанныеДокумента(ДанныеОрганизации = Истина, ДанныеСотрудника = Истина, ОбновлятьБезусловно = Истина) Экспорт
	
	Документ = ФиксацияПодготовленныйДокумент();
	
	Если Документ.ОбновитьВторичныеДанныеДокумента(ДанныеОрганизации, ДанныеСотрудника, ОбновлятьБезусловно) Тогда
		Если НЕ Документ.ЭтоНовый() Тогда
			ФиксацияВторичныхДанныхВДокументахФормы.УстановитьМодифицированность(ЭтотОбъект, Истина);	
		КонецЕсли;
		ЗначениеВРеквизитФормы(Документ, "Объект");
		ФиксацияЗаполнитьРеквизитыФормыФикс(Объект);
	КонецЕсли;
	
	ПодписиДокументовКлиентСервер.УстановитьПредставлениеПодписей(ЭтотОбъект);
	УстановитьПредставлениеКИ();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(Элемент, СтандартнаяОбработка = Ложь) Экспорт
	
	Если ТипЗнч(ЭтотОбъект.ТекущийЭлемент) = Тип("ТаблицаФормы")  Тогда
		ТекущаяСтрока = ЭтотОбъект.ТекущийЭлемент.ТекущаяСтрока;
	Иначе	
		ТекущаяСтрока = 0;
	КонецЕсли;
	
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(ЭтотОбъект, Элемент, ФиксацияЭлементыОбработчикаЗафиксироватьИзменение(), ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьИнфонадписьИсправления(Форма)
	Форма.ИнфоНадписьИсправления = НСтр("ru = 'Выделенные жирным шрифтом личные данные зафиксированы в документе и могут отличаться от данных в карточке сотрудника';
										|en = 'Personal data in bold type was recorded in the document and may differ from the data of the employee card'");	
КонецПроцедуры

&НаСервере
Процедура СтрахователиСправкаПриИзмененииНаСервере(Идентификатор)
	
	ТекущаяСтрока = Объект.Страхователи.НайтиПоИдентификатору(Идентификатор);
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.Справка) Тогда 
				
		СтруктураСправки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ТекущаяСтрока.Справка, "Страхователь, ПериодРаботыС, ПериодРаботыПо");
		СтруктураСтрахователя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтруктураСправки.Страхователь, "РегистрационныйНомерФСС, ДополнительныйКодФСС, КодПодчиненностиФСС, НаименованиеТерриториальногоОрганаФСС, ИНН, КПП");
	
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтруктураСправки);		
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтруктураСтрахователя);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти




