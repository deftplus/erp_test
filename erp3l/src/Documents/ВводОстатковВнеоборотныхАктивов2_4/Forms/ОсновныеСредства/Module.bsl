
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ИнициализацияПриСозданииНаСервере();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриЧтенииСозданииНаСервере();
		
	КонецЕсли;
	
	#Область УниверсальныеМеханизмы
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

	#КонецОбласти
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
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
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();

	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение И НЕ ДанныеОПрослеживаемыхТоварахКорректны() Тогда
		Отказ = Истина;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ВводОстатковВнеоборотныхАктивов2_4", ПараметрыЗаписи, Объект.Ссылка);
	Оповестить("Запись_ВводОстатков", ПараметрыЗаписи, Объект.Ссылка);
	ОбщегоНазначенияУТКлиент.ОповеститьОЗаписиДокументаВЖурнал();
	ВнеоборотныеАктивыКлиент.ОповеститьОЗаписиДокументаВЖурналОС();
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтотОбъект, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтраженияВУчетеПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВОперативномУчетеПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВБУиНУПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВУУПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(Элемент.Имя);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОС

&НаКлиенте
Процедура ОСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИзменитьСтрокуОС();
	
КонецПроцедуры

&НаКлиенте
Процедура ОСПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ИзменитьСтрокуОС(Истина, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ОСПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущийЭлемент <> Элементы.ОСНомерСтроки Тогда
		Отказ = Истина;
		ИзменитьСтрокуОС();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПодборНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСведения(Команда)
	
	ИзменитьСтрокуОС();
	
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	
	ПараметрыПодбораОС = ВнеоборотныеАктивыКлиентСервер.ПараметрыПодбора(Элементы.ОСОсновноеСредство, ЭтотОбъект);
	
	ОткрытьФорму("Справочник.ОбъектыЭксплуатации.ФормаВыбора", 
					ПараметрыПодбораОС, Элементы.ОС,,,,, 
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриВыполненииКоманды(Команда)

	ВводОстатковВнеоборотныхАктивовКлиентЛокализация.ФормаОсновныеСредства_ПриВыполненииКоманды(Команда, ЭтаФорма);

КонецПроцедуры

#Область ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)

	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	Если Объект.ОтражатьВУпрУчете Тогда 
		
		Если Объект.ОтражатьВБУ И Объект.ОтражатьВНУ Тогда
			ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах;
		ИначеЕсли Объект.ОтражатьВУпрУчете И Объект.ОтражатьВБУ Тогда
			ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИБухгалтерскомУчете;
		ИначеЕсли Объект.ОтражатьВУпрУчете И Объект.ОтражатьВНУ Тогда
			ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИНалоговомУчете;
		Иначе
			ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомУчете;
		КонецЕсли;
		
	ИначеЕсли Объект.ОтражатьВБУ И Объект.ОтражатьВНУ Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.РегламентированномУчете;
	ИначеЕсли Объект.ОтражатьВБУ Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.БухгалтерскомУчете;
	ИначеЕсли Объект.ОтражатьВНУ Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.НалоговомУчете;
	КонецЕсли; 
	
	ОбновитьЗаголовокФормы();
	
	НастроитьЗависимыеЭлементыФормы();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияПриСозданииНаСервере()

	Если Параметры.Свойство("АктивизироватьСтроку") Тогда
		АктивизироватьСтроку = Параметры.АктивизироватьСтроку;
		Если АктивизироватьСтроку <= Объект.ОС.Количество() И АктивизироватьСтроку > 0 Тогда
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаОС;
			Элементы.ОС.ТекущаяСтрока = АктивизироватьСтроку - 1;
		КонецЕсли; 
	КонецЕсли; 
	
	СписокРеквизитов = Новый Массив;
	Для каждого МетаданныеРеквизита Из Метаданные.Документы.ВводОстатковВнеоборотныхАктивов2_4.ТабличныеЧасти.ОС.Реквизиты Цикл
		СписокРеквизитов.Добавить(МетаданныеРеквизита.Имя);
	КонецЦикла; 

	РеквизитыОС = СтрСоединить(СписокРеквизитов, ",");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрослеживаемыхИмпортныхТоваров") Тогда
		Элементы.ПрослеживаемыеТоварыОсновноеСредство.СписокВыбора.ЗагрузитьЗначения(ДоступныеОсновныеСредства());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокФормы()
	
	Заголовок = ВнеоборотныеАктивыВызовСервера.ПредставлениеВводаОстатков(Объект);

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтрокуОС(НоваяСтрока = Ложь, Копирование = Ложь)
	
	ТекущиеДанные = Элементы.ОС.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено И НЕ Копирование И НЕ НоваяСтрока Тогда
		Возврат;
	КонецЕсли; 

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ссылка", Объект.Ссылка);
	ПараметрыФормы.Вставить("Дата", Объект.Дата);
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	ПараметрыФормы.Вставить("Местонахождение", Объект.Местонахождение);
	ПараметрыФормы.Вставить("ОтражатьВРеглУчете", Объект.ОтражатьВРеглУчете);
	ПараметрыФормы.Вставить("ОтражатьВУпрУчете", Объект.ОтражатьВУпрУчете);
	ПараметрыФормы.Вставить("ОтражатьВБУ", Объект.ОтражатьВБУ);
	ПараметрыФормы.Вставить("ОтражатьВНУ", Объект.ОтражатьВНУ);
	ПараметрыФормы.Вставить("ОтражатьВБУиНУ", Объект.ОтражатьВБУиНУ);
	ПараметрыФормы.Вставить("ОтражатьВОперативномУчете", Объект.ОтражатьВОперативномУчете);
	ПараметрыФормы.Вставить("ОтражатьВУУ", Объект.ОтражатьВУУ);
	ПараметрыФормы.Вставить("ХозяйственнаяОперация", Объект.ХозяйственнаяОперация);
	ПараметрыФормы.Вставить("РасчетыМеждуОрганизациямиАрендатор", Объект.РасчетыМеждуОрганизациямиАрендатор);
	ПараметрыФормы.Вставить("СохраняемыеРеквизиты", РеквизитыОС);
	ПараметрыФормы.Вставить("НоваяСтрока", НоваяСтрока);
	ПараметрыФормы.Вставить("Копирование", Копирование);
	
	ИдентификаторСтроки = Неопределено;
	Если ТекущиеДанные <> Неопределено Тогда
		ИдентификаторСтроки = ТекущиеДанные.ПолучитьИдентификатор();
		Если НЕ НоваяСтрока ИЛИ Копирование Тогда
			ЗначенияРеквизитов = Новый Структура(РеквизитыОС);
			ЗаполнитьЗначенияСвойств(ЗначенияРеквизитов, ТекущиеДанные);
			ПараметрыФормы.Вставить("ЗначенияРеквизитов", ЗначенияРеквизитов);
		КонецЕсли; 
		Если Копирование Тогда
			ЗначенияРеквизитов.ОсновноеСредство = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	ДопПараметры = Новый Структура("НоваяСтрока,ИдентификаторСтроки", НоваяСтрока, ИдентификаторСтроки);
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьСтрокуОСЗавершение", ЭтотОбъект, ДопПараметры);
	ОткрытьФорму("Документ.ВводОстатковВнеоборотныхАктивов2_4.Форма.РедактированияСтрокиОС", ПараметрыФормы,,,,, ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтрокуОСЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		ИзменитьСтрокуОСЗавершениеНаСервере(РезультатЗакрытия, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьСтрокуОСЗавершениеНаСервере(Знач РезультатЗакрытия, Знач ДополнительныеПараметры)

	Модифицированность = Истина;

	Если ДополнительныеПараметры.НоваяСтрока Тогда
		СтрокаТаблицы = Объект.ОС.Добавить();
	Иначе
		СтрокаТаблицы = Объект.ОС.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, РезультатЗакрытия);
		
КонецПроцедуры

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормы(Знач ИзмененныеРеквизиты = "")
	
	ПриИзмененииРеквизитов(ИзмененныеРеквизиты);
	
	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	ОбновитьВсе = СтруктураИзмененныхРеквизитов.Количество() = 0;
	
	Если ОбновитьВсе Тогда
		Элементы.КартинкаДокументПереходаНа2_4.Видимость = Ложь;
		Элементы.ДекорацияДокументПереходаНа2_4.Видимость = Ложь;
		Элементы.ВводОстатковПо.Видимость = Ложь;
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВОперативномУчете")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВБУиНУ")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВУУ")
		ИЛИ ОбновитьВсе Тогда
		
		Элементы.ВариантОтраженияВУчете.ТолькоПросмотр =
			НЕ Объект.ОтражатьВОперативномУчете
			И Объект.ОтражатьВУУ
			И НЕ Объект.ОтражатьВБУиНУ;

		ПараметрыВыбораОС = Новый Массив;
		
		ОтборСостояние = Новый Массив;
		Если Объект.ОтражатьВОперативномУчете Тогда
			ОтборСостояние.Добавить(Перечисления.СостоянияОС.НеПринятоКУчету);
			ОтборСостояние.Добавить(Перечисления.СостоянияОС.СнятоСУчета);
		Иначе
			ОтборСостояние.Добавить(Перечисления.СостоянияОС.ПринятоКУчету);
		КонецЕсли; 
		ПараметрыВыбораОС.Добавить(Новый ПараметрВыбора("Отбор.Состояние", ОтборСостояние));
		ПараметрыВыбораОС.Добавить(Новый ПараметрВыбора("Контекст", "БУ,УУ"));
		
		Элементы.ОСОсновноеСредство.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораОС);
		
	КонецЕсли; 
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ФормаОсновныеСредства_НастроитьЗависимыеЭлементыФормы(
		ЭтотОбъект, СтруктураИзмененныхРеквизитов);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитов(ИзмененныеРеквизиты)

	Если НЕ ЗначениеЗаполнено(ИзмененныеРеквизиты) Тогда
		Возврат; 
	КонецЕсли; 
	
	СписокРеквизитов = СтрРазделить(ИзмененныеРеквизиты, ",");
	
	Если СписокРеквизитов.Найти("ОтражатьВОперативномУчете") <> Неопределено
		ИЛИ СписокРеквизитов.Найти("ОтражатьВБУиНУ") <> Неопределено
		ИЛИ СписокРеквизитов.Найти("ОтражатьВУУ") <> Неопределено Тогда
		
		Если Объект.ОтражатьВБУиНУ
			И НЕ Объект.ОтражатьВОперативномУчете 
			И НЕ Объект.ОтражатьВУУ Тогда
			
			ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.РегламентированномУчете");
			СписокРеквизитов.Добавить("ВариантОтраженияВУчете");
			
		ИначеЕсли Объект.ОтражатьВУУ
			И НЕ Объект.ОтражатьВОперативномУчете 
			И НЕ Объект.ОтражатьВБУиНУ Тогда
			
			ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомУчете");
			СписокРеквизитов.Добавить("ВариантОтраженияВУчете");
			
		ИначеЕсли Объект.ОтражатьВОперативномУчете 
			И Объект.ОтражатьВУУ
			И НЕ Объект.ОтражатьВБУиНУ Тогда
			
			ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомУчете");
			СписокРеквизитов.Добавить("ВариантОтраженияВУчете");
			
		ИначеЕсли Объект.ОтражатьВБУиНУ
			И Объект.ОтражатьВУУ
			И НЕ Объект.ОтражатьВОперативномУчете Тогда
			
			ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах");
			СписокРеквизитов.Добавить("ВариантОтраженияВУчете");
			
		ИначеЕсли Объект.ОтражатьВБУиНУ
			И Объект.ОтражатьВОперативномУчете Тогда
			
			ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах");
			СписокРеквизитов.Добавить("ВариантОтраженияВУчете");
		КонецЕсли; 
		
	КонецЕсли; 
	
	Если СписокРеквизитов.Найти("ВариантОтраженияВУчете") <> Неопределено Тогда
		
		Если НЕ ЗначениеЗаполнено(ВариантОтраженияВУчете) Тогда
			ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомУчете");
		КонецЕсли; 
		
		ОтражатьВУпрУчете = 
			(ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомУчете")
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах")
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИБухгалтерскомУчете")
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИНалоговомУчете"));
				
		ОтражатьВРеглУчете = 
			(ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.РегламентированномУчете")
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах")
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.БухгалтерскомУчете")
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.НалоговомУчете")
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИБухгалтерскомУчете")
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИНалоговомУчете"));
				
		ОтражатьВБУ = 
			(ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах")
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.РегламентированномУчете")
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.БухгалтерскомУчете")
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИБухгалтерскомУчете"));
				
		ОтражатьВНУ = 
			(ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах")
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.РегламентированномУчете")
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.НалоговомУчете")
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИНалоговомУчете"));
				
		Если Объект.ОтражатьВУпрУчете <> ОтражатьВУпрУчете Тогда
			Объект.ОтражатьВУпрУчете = ОтражатьВУпрУчете;
			СписокРеквизитов.Добавить("ОтражатьВУпрУчете");
		КонецЕсли; 
		
		Если Объект.ОтражатьВРеглУчете <> ОтражатьВРеглУчете Тогда
			Объект.ОтражатьВРеглУчете = ОтражатьВРеглУчете;
			СписокРеквизитов.Добавить("ОтражатьВРеглУчете");
		КонецЕсли; 
		
		Если Объект.ОтражатьВБУ <> ОтражатьВБУ Тогда
			Объект.ОтражатьВБУ = ОтражатьВБУ;
			СписокРеквизитов.Добавить("ОтражатьВБУ");
		КонецЕсли; 
		
		Если Объект.ОтражатьВНУ <> ОтражатьВНУ Тогда
			Объект.ОтражатьВНУ = ОтражатьВНУ;
			СписокРеквизитов.Добавить("ОтражатьВНУ");
		КонецЕсли; 
		
	КонецЕсли; 
	
	Если СписокРеквизитов.Найти("Дата") <> Неопределено
		ИЛИ СписокРеквизитов.Найти("Организация") <> Неопределено
		ИЛИ СписокРеквизитов.Найти("ОтражатьВБУиНУ") <> Неопределено
		ИЛИ СписокРеквизитов.Найти("ОтражатьВОперативномУчете") <> Неопределено
		ИЛИ СписокРеквизитов.Найти("ОтражатьВУУ") <> Неопределено
		ИЛИ СписокРеквизитов.Найти("ОтражатьВРеглУчете") <> Неопределено
		ИЛИ СписокРеквизитов.Найти("ОтражатьВУпрУчете") <> Неопределено Тогда
		
		ЗаполнитьРеквизитыВзависимостиОтСвойств(Объект.ОС);
	КонецЕсли; 
	
	ИзмененныеРеквизиты = СтрСоединить(СписокРеквизитов, ",");

КонецПроцедуры
 
&НаСервере
Процедура ПодборНаСервере(ВыбранноеЗначение)

	ДобавленныеСтроки = ВнеоборотныеАктивыКлиентСервер.ОбработкаВыбораЭлемента(Объект.ОС, "ОсновноеСредство", ВыбранноеЗначение);
	
	ЗаполнитьРеквизитыВзависимостиОтСвойств(ДобавленныеСтроки);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыВзависимостиОтСвойств(СписокСтрок)

	ВспомогательныеРеквизитыОбъекта = Документы.ВводОстатковВнеоборотныхАктивов2_4.ВспомогательныеРеквизиты(Объект, Ложь);
	
	Для каждого ДанныеСтроки Из СписокСтрок Цикл
		
		ВспомогательныеРеквизиты = Документы.ВводОстатковВнеоборотныхАктивов2_4.ДополнитьВспомогательныеРеквизитыПоДаннымСтроки(
											Объект, ДанныеСтроки, ВспомогательныеРеквизитыОбъекта);
		
		ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ВводОстатков(
										ДанныеСтроки, ВспомогательныеРеквизиты, "");
										
		Документы.ВводОстатковВнеоборотныхАктивов2_4.ЗаполнитьРеквизитыВзависимостиОтСвойств(
				ДанныеСтроки, ВспомогательныеРеквизиты, ПараметрыРеквизитовОбъекта);
				
		ОбщегоНазначенияУТКлиентСервер.ОчиститьНеиспользуемыеРеквизиты(ДанныеСтроки, ПараметрыРеквизитовОбъекта);
		
		Документы.ВводОстатковВнеоборотныхАктивов2_4.ЗаполнитьЗначенияПоУмолчанию(ДанныеСтроки, Объект);
		
	КонецЦикла; 

КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()

	НастроитьЗависимыеЭлементыФормы("Дата");

КонецПроцедуры
 
&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()

	НастроитьЗависимыеЭлементыФормы("Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьВыполнениеКомандыЛокализации(ИмяКоманды, ПараметрыОповещения) Экспорт
	
	Если ПараметрыОповещения.ТребуетсяВызовСервера Тогда
		ПриВыполненииКомандыЗавершениеНаСервере(ИмяКоманды, ПараметрыОповещения.ПараметрыОбработки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриВыполненииКомандыЗавершениеНаСервере(Знач ИмяКоманды, Знач ДополнительныеПараметры)
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ФормаОсновныеСредства_ПриВыполненииКоманды(ИмяКоманды, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция ДоступныеОсновныеСредства()
	
	ДоступныеОсновныеСредства = Объект.ОС.Выгрузить(,"ОсновноеСредство").ВыгрузитьКолонку("ОсновноеСредство");
	
	Возврат ДоступныеОсновныеСредства;
	
КонецФункции

&НаКлиенте
Функция ДанныеОПрослеживаемыхТоварахКорректны()
	
	ДанныеКорректны = Истина;
	ОсновныеСредства = ДоступныеОсновныеСредства();
	Для каждого Стр Из Объект.ПрослеживаемыеТовары Цикл
		Если ОсновныеСредства.Найти(Стр.ОсновноеСредство) = Неопределено Тогда
			СтрокаСообщения = НСтр("ru = 'Данные табличной части прослеживаемых товаров не соответствуют данным об основных средствах. 
			|Значение %1 отсутствует в табличной части ""Основные средства"".';
			|en = 'Data of the traceable goods table does not correspond to the data of fixed assets. 
			|The %1 value is missing in the ""Fixed assets"" table.'"); 
			СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, Стр.ОсновноеСредство);
			ОбщегоНазначенияКлиент.СообщитьПользователю(СтрокаСообщения,Объект.Ссылка);
			ДанныеКорректны = Ложь;	
		КонецЕсли;	
	КонецЦикла;

	Возврат ДанныеКорректны;

КонецФункции

&НаСервере
Процедура ОСОсновноеСредствоПриИзмененииНаСервере()
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрослеживаемыхИмпортныхТоваров") Тогда
		Элементы.ПрослеживаемыеТоварыОсновноеСредство.СписокВыбора.ЗагрузитьЗначения(ДоступныеОсновныеСредства());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОСОсновноеСредствоПриИзменении(Элемент)
	ОСОсновноеСредствоПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СформироватьВедомость(Команда)
	
	ДоступныеОсновныеСредства = ДоступныеОсновныеСредства();
	Отбор = Новый Структура;
    Отбор.Вставить("Организация", Объект.Организация);   
	Отбор.Вставить("ОсновноеСредство", ДоступныеОсновныеСредства);
	ПериодОтчета = Новый СтандартныйПериод();
	ПериодОтчета.ДатаНачала = НачалоДня(Объект.Дата);
	ПериодОтчета.ДатаОкончания = КонецДня(Объект.Дата);
 	Отбор.Вставить("Период", ПериодОтчета);		
	ПараметрыФормы = Новый Структура("Отбор, СформироватьПриОткрытии, КлючВарианта", Отбор, Истина, "Основной");	
	УчетПрослеживаемыхТоваровКлиентСерверЛокализация.СформироватьВедомость(ПараметрыФормы);

КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
		
	Если ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.СтраницаПрослеживаемыеТовары Тогда
		Элементы.ПрослеживаемыеТоварыОсновноеСредство.СписокВыбора.ЗагрузитьЗначения(ДоступныеОсновныеСредства());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
