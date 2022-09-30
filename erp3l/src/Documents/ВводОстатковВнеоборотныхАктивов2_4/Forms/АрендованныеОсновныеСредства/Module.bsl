
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
	
	#Область СтандартныеПодсистемы
	
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
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ВводОстатковВнеоборотныхАктивов2_4", ПараметрыЗаписи, Объект.Ссылка);
	Оповестить("Запись_ВводОстатков", ПараметрыЗаписи, Объект.Ссылка);
	ОбщегоНазначенияУТКлиент.ОповеститьОЗаписиДокументаВЖурнал();
	ВнеоборотныеАктивыКлиент.ОповеститьОЗаписиДокументаВЖурналОС();
	
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура АрендованныеОСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВнеоборотныеАктивыКлиентСервер.ОбработкаВыбораЭлемента(Объект.АрендованныеОС, "ОсновноеСредство", ВыбранноеЗначение);
	
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
Процедура Подобрать(Команда)
	
	ПараметрыПодбораОС = ВнеоборотныеАктивыКлиентСервер.ПараметрыПодбора(Элементы.АрендованныеОСОсновноеСредство, ЭтотОбъект);
	
	ОткрытьФорму("Справочник.ОбъектыЭксплуатации.ФормаВыбора", 
					ПараметрыПодбораОС, Элементы.АрендованныеОС,,,,, 
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриВыполненииКоманды(Команда)

	ВводОстатковВнеоборотныхАктивовКлиентЛокализация.ФормаАрендованныеОсновныеСредства_ПриВыполненииКоманды(Команда, ЭтаФорма);

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

	ДатаНачалаУчетаВнеоборотныхАктивов2_4 = ВнеоборотныеАктивыЛокализация.ДатаНачалаУчетаВнеоборотныхАктивов2_4();
	
	ОбновитьЗаголовокФормы();
	
	Элементы.Контрагент.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	Элементы.АрендованныеОСДоговор.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов");
	
	Элементы.АрендованныеОСДоговор.АвтоОтметкаНезаполненного = Ложь;
	
	ПараметрыВыбораДоговор = Новый Массив;
	ПараметрыВыбораДоговор.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления", Ложь));
	ПараметрыВыбораДоговор.Добавить(Новый ПараметрВыбора("Отбор.Статус", Перечисления.СтатусыДоговоровКонтрагентов.Действует));
	Элементы.АрендованныеОСДоговор.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораДоговор);
	
	СвязиПараметровВыбораДоговор = Новый Массив;
	СвязиПараметровВыбораДоговор.Добавить(Новый СвязьПараметраВыбора("Отбор.Организация", "Объект.Организация"));
	СвязиПараметровВыбораДоговор.Добавить(Новый СвязьПараметраВыбора("Отбор.Контрагент", "Объект.Контрагент"));
	Элементы.АрендованныеОСДоговор.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровВыбораДоговор);
	
	НастроитьЗависимыеЭлементыФормы();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияПриСозданииНаСервере()

	Если Параметры.Свойство("АктивизироватьСтроку") Тогда
		АктивизироватьСтроку = Параметры.АктивизироватьСтроку;
		Если АктивизироватьСтроку <= Объект.АрендованныеОС.Количество() И АктивизироватьСтроку > 0 Тогда
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаОС;
			Элементы.АрендованныеОС.ТекущаяСтрока = АктивизироватьСтроку - 1;
		КонецЕсли;
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормы(Знач ИзмененныеРеквизиты = "")
	
	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	ОбновитьВсе = СтруктураИзмененныхРеквизитов.Количество() = 0;
	
	Если ОбновитьВсе Тогда
		Элементы.КартинкаДокументПереходаНа2_4.Видимость = Ложь;
		Элементы.ДекорацияДокументПереходаНа2_4.Видимость = Ложь;
		Элементы.ВводОстатковПо.Видимость = Ложь;
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВОперативномУчете")
		ИЛИ ОбновитьВсе Тогда
		
		Элементы.АрендованныеОСДатаПринятияКУчету.Видимость = Объект.ОтражатьВОперативномУчете;
		Элементы.АрендованныеОСМОЛ.Видимость = Объект.ОтражатьВОперативномУчете;
		
		ПараметрыВыбораОС = Новый Массив;
		
		ОтборСостояние = Новый Массив;
		Если Объект.ОтражатьВОперативномУчете Тогда
			ОтборСостояние.Добавить(Перечисления.СостоянияОС.НеПринятоКУчету);
			ОтборСостояние.Добавить(Перечисления.СостоянияОС.СнятоСУчета);
		Иначе
			ОтборСостояние.Добавить(Перечисления.СостоянияОС.ПринятоКЗабалансовомуУчету);
		КонецЕсли; 
		ПараметрыВыбораОС.Добавить(Новый ПараметрВыбора("Отбор.Состояние", ОтборСостояние));
		ПараметрыВыбораОС.Добавить(Новый ПараметрВыбора("Контекст", "БУ,УУ"));
		
		Элементы.АрендованныеОСОсновноеСредство.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораОС);
		
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("Дата")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВОперативномУчете")
		ИЛИ ОбновитьВсе Тогда
		
		ДатаДокумента = ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса());
		ДатаНачалаУчета = ВнеоборотныеАктивыЛокализация.ДатаНачалаУчетаВнеоборотныхАктивов2_4();
		
		Элементы.АрендованныеОСДокументВводаВЭксплуатацию.Видимость = 
			Объект.ОтражатьВОперативномУчете
			И ДатаНачалаУчета > ДатаДокумента;
			
	КонецЕсли;
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ФормаАрендованныеОсновныеСредства_НастроитьЗависимыеЭлементыФормы(
		ЭтаФорма, СтруктураИзмененныхРеквизитов);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокФормы()
	
	Заголовок = ВнеоборотныеАктивыВызовСервера.ПредставлениеВводаОстатков(Объект);

КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьВыполнениеКомандыЛокализации(ИмяКоманды, ПараметрыОповещения) Экспорт
	
	Если ПараметрыОповещения.ТребуетсяВызовСервера Тогда
		ПриВыполненииКомандыЗавершениеНаСервере(ИмяКоманды, ПараметрыОповещения.ПараметрыОбработки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриВыполненииКомандыЗавершениеНаСервере(Знач ИмяКоманды, Знач ДополнительныеПараметры)
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ФормаАрендованныеОсновныеСредства_ПриВыполненииКоманды(ИмяКоманды, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
