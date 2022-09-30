
#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
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
	ВнеоборотныеАктивыКлиент.ОповеститьОЗаписиДокументаВЖурналНМА();
	
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
	
	ЗаполнитьСлужебныеРеквизитыТЧ();
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(Элемент.Имя);
	
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

&НаКлиенте
Процедура ВидАктивовПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидАктивов) Тогда
		Объект.ВидАктивов = ПредопределенноеЗначение("Перечисление.ВидыВнеоборотныхАктивов.ОсновноеСредство");
	КонецЕсли;
	
	Если ВидАктивовДоИзменения = Объект.ВидАктивов Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ПрочиеРасходы.Количество() <> 0 Тогда
		ТекстВопроса = НСтр("ru = 'При изменении вида активов будут удалены расходы. Продолжить?';
							|en = 'When changing the asset type, expenses will be deleted. Continue?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ВидАктивовПриИзмененииЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ВидАктивовПриИзмененииЗавершение(КодВозвратаДиалога.Да, Неопределено);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПрочиеРасходы

&НаКлиенте
Процедура ПрочиеРасходыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СписокОбъектов = ОбщегоНазначенияУТКлиентСервер.Массив(ВыбранноеЗначение);
	ВнеоборотныеАктивыКлиентСервер.ОбработкаВыбораЭлемента(Объект.ПрочиеРасходы, "ВнеоборотныйАктив", СписокОбъектов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеРасходыСтатьяРасходовПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ПрочиеРасходы.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаТаблицы.СтатьяРасходов) Тогда
		СтатьяПрочихРасходовПриИзмененииСервер(КэшированныеЗначения);
	Иначе
		СтрокаТаблицы.ПринимаетсяКНУ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеРасходыСуммаРеглПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПрочиеРасходы.ТекущиеДанные;
		
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуПР");
	СтруктураДействий.Вставить("ПересчитатьСуммуНУ");
	СтруктураДействий.Вставить("ПересчитатьСуммуВР");
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеРасходыСуммаНУПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПрочиеРасходы.ТекущиеДанные;
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуВР");
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеРасходыСуммаПРПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПрочиеРасходы.ТекущиеДанные;
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуВР");
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
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
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыПодбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыПодбора.Вставить("Контекст", "БУ, УУ");
	
	Если Объект.ВидАктивов = ПредопределенноеЗначение("Перечисление.ВидыВнеоборотныхАктивов.ОсновноеСредство") Тогда
		ОткрытьФорму("Справочник.ОбъектыЭксплуатации.ФормаВыбора", 
						ПараметрыПодбора, Элементы.ПрочиеРасходы,,,,, 
						РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли Объект.ВидАктивов = ПредопределенноеЗначение("Перечисление.ВидыВнеоборотныхАктивов.ОбъектыСтроительства") Тогда
		ОткрытьФорму("Справочник.ОбъектыСтроительства.ФормаВыбора", 
						ПараметрыПодбора, Элементы.ПрочиеРасходы,,,,, 
						РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли Объект.ВидАктивов = ПредопределенноеЗначение("Перечисление.ВидыВнеоборотныхАктивов.НМА") Тогда
		ОткрытьФорму("Справочник.НематериальныеАктивы.ФормаВыбора", 
						ПараметрыПодбора, Элементы.ПрочиеРасходы,,,,, 
						РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		ТекстСообщения = НСтр("ru = 'Необходимо выбрать вид активов';
								|en = 'Select asset type'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "ВидАктивов", "Объект"); 
	КонецЕсли; 
	
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

	ВидАктивовДоИзменения = Объект.ВидАктивов;
	ВедетсяРегламентированныйУчетВНА = ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА();
	
	Если Объект.ОтражатьВУпрУчете И Объект.ОтражатьВРеглУчете Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах;
	ИначеЕсли Объект.ОтражатьВУпрУчете Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомУчете;
	ИначеЕсли Объект.ОтражатьВРеглУчете Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.РегламентированномУчете;
	КонецЕсли; 
	
	ОграничитьВыборАктивовИСтатейЗатрат(ЭтотОбъект);
	ЗаполнитьСлужебныеРеквизитыТЧ();
	
	ОбновитьЗаголовокФормы();
	
	НастроитьЗависимыеЭлементыФормы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Снятие отметки незаполненного при разделе учета "Регламентированный"
	Элемент = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы.ПрочиеРасходыСумма.Имя);
	ГруппаОтбора = КомпоновкаДанныхКлиентСервер.ДобавитьГруппуОтбора(Элемент.Отбор.Элементы, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(ГруппаОтбора, "Объект.ОтражатьВРеглУчете", Истина);
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(ГруппаОтбора, "Объект.ПрочиеРасходы.СуммаБезНДС", 0, ВидСравненияКомпоновкиДанных.НеРавно);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы.ПрочиеРасходыСуммаБезНДС.Имя);
	ГруппаОтбора = КомпоновкаДанныхКлиентСервер.ДобавитьГруппуОтбора(Элемент.Отбор.Элементы, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(ГруппаОтбора, "Объект.ОтражатьВРеглУчете", Истина);
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(ГруппаОтбора, "Объект.ПрочиеРасходы.Сумма", 0, ВидСравненияКомпоновкиДанных.НеРавно);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы.ПрочиеРасходыСуммаРегл1.Имя);
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы.ПрочиеРасходыСуммаРегл.Имя);
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(Элемент.Отбор, "Объект.ОтражатьВУпрУчете", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияПриСозданииНаСервере()

	Если Параметры.Свойство("АктивизироватьСтроку") Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаРасходы;
		Если Параметры.АктивизироватьСтроку <= Объект.ПрочиеРасходы.Количество() Тогда
			Элементы.ПрочиеРасходы.ТекущаяСтрока = Параметры.АктивизироватьСтроку - 1;
		КонецЕсли;
	КонецЕсли;
	
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
	
	Элементы.ПрочиеРасходыСуммаРегл1.Заголовок = СтрШаблон(НСтр("ru = 'Сумма регл. (%1)';
																|en = 'Local accounting amount (%1)'"), Строка(ВалютаРегламентированногоУчета));
	Элементы.ПрочиеРасходыГруппаСуммыРегл.Заголовок = СтрШаблон(НСтр("ru = 'Регламентированный учет (%1)';
																	|en = 'Local accounting (%1)'"), Строка(ВалютаРегламентированногоУчета));
	Элементы.ПрочиеРасходыГруппаСуммыУпр.Заголовок = СтрШаблон(НСтр("ru = 'Управленческий учет (%1)';
																	|en = 'Management accounting (%1)'"), Строка(ВалютаУправленческогоУчета));
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОбъектыСтроительства") Тогда
		ЭлементСписка = Элементы.ВидАктивов.СписокВыбора.НайтиПоЗначению(Перечисления.ВидыВнеоборотныхАктивов.ОбъектыСтроительства);
		Если ЭлементСписка <> Неопределено Тогда
			Элементы.ВидАктивов.СписокВыбора.Удалить(ЭлементСписка);
		КонецЕсли; 
	КонецЕсли; 
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрослеживаемыхИмпортныхТоваров") Тогда
		Элементы.ПрослеживаемыеТоварыОсновноеСредство.СписокВыбора.ЗагрузитьЗначения(ДоступныеОсновныеСредства());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыТЧ()

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакПринимаетсяКНУ");
	СтруктураДействий.Вставить("ПересчитатьСуммуНУ");
	Для Каждого СтрокаТЧ Из Объект.ПрочиеРасходы Цикл
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТЧ, СтруктураДействий, Неопределено);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормы(Знач ИзмененныеРеквизиты = "")

	ПриИзмененииРеквизитов(ИзмененныеРеквизиты);
	
	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	
	ОбновитьВсе = СтруктураИзмененныхРеквизитов.Количество() = 0;
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ФормаВложенияВоВнеоборотныеАктивы_ПриИзмененииРеквизитов(
		ЭтотОбъект, СтруктураИзмененныхРеквизитов);
	
	ВспомогательныеРеквизиты = Новый Структура;
	ВспомогательныеРеквизиты.Вставить("ПрименяетсяПБУ18", Ложь);
	ВспомогательныеРеквизиты.Вставить("ВедетсяУчетПостоянныхИВременныхРазниц", Ложь);
	ВспомогательныеРеквизиты.Вставить("ВедетсяРегламентированныйУчетВНА", ВедетсяРегламентированныйУчетВНА);
	ВводОстатковВнеоборотныхАктивовЛокализация.ФормаВложенияВоВнеоборотныеАктивы_ДополнитьВспомогательныеРеквизиты(
		ЭтотОбъект, ВспомогательныеРеквизиты);
	
	ПараметрыРеквизитовОбъекта = ЗначенияСвойствЗависимыхРеквизитов_ВводОстатков2_4(
									Объект, ВспомогательныеРеквизиты, ИзмененныеРеквизиты);
									
	ОбщегоНазначенияУТКлиентСервер.НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, ПараметрыРеквизитовОбъекта);
	
	Если НЕ ОбновитьВсе Тогда
		ОбщегоНазначенияУТКлиентСервер.ОчиститьНеиспользуемыеРеквизиты(Объект, ПараметрыРеквизитовОбъекта);
	КонецЕсли; 
	
	Если ОбновитьВсе Тогда
		Элементы.КартинкаДокументПереходаНа2_4.Видимость = Ложь;
		Элементы.ДекорацияДокументПереходаНа2_4.Видимость = Ложь;
		Элементы.ВводОстатковПо.Видимость = Ложь;
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВОперативномУчете")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВБУиНУ")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВУУ")
		ИЛИ ОбновитьВсе Тогда
		
		Если Объект.ОтражатьВОперативномУчете Тогда
			
			Элементы.ВариантОтраженияВУчете.Видимость = Истина;
			
			// Условия должны совпадать с условиями в процедуре ПриИзмененииРеквизитов().
			Элементы.ВариантОтраженияВУчете.ТолькоПросмотр =
				Объект.ОтражатьВБУиНУ
					И НЕ Объект.ОтражатьВОперативномУчете 
					И НЕ Объект.ОтражатьВУУ
				ИЛИ Объект.ОтражатьВУУ
					И НЕ Объект.ОтражатьВОперативномУчете 
					И НЕ Объект.ОтражатьВБУиНУ
				ИЛИ Объект.ОтражатьВОперативномУчете 
					И Объект.ОтражатьВУУ
					И НЕ Объект.ОтражатьВБУиНУ
				ИЛИ Объект.ОтражатьВБУиНУ
					И Объект.ОтражатьВУУ
					И НЕ Объект.ОтражатьВОперативномУчете;
		Иначе
			Элементы.ВариантОтраженияВУчете.Видимость = Ложь;
		КонецЕсли; 
				
	КонецЕсли; 
	
	Если СтруктураИзмененныхРеквизитов.Свойство("Организация") Тогда
		ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
	КонецЕсли;
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ФормаВложенияВоВнеоборотныеАктивы_НастроитьЗависимыеЭлементыФормы(
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
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах"));
				
		ОтражатьВРеглУчете = 
			(ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.РегламентированномУчете")
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах"));
				
		Если Объект.ОтражатьВУпрУчете <> ОтражатьВУпрУчете Тогда
			Объект.ОтражатьВУпрУчете = ОтражатьВУпрУчете;
			СписокРеквизитов.Добавить("ОтражатьВУпрУчете");
		КонецЕсли; 
		Если Объект.ОтражатьВРеглУчете <> ОтражатьВРеглУчете Тогда
			Объект.ОтражатьВРеглУчете = ОтражатьВРеглУчете;
			СписокРеквизитов.Добавить("ОтражатьВРеглУчете");
		КонецЕсли; 
		
	КонецЕсли; 
	
	ИзмененныеРеквизиты = СтрСоединить(СписокРеквизитов, ",");

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗначенияСвойствЗависимыхРеквизитов_ВводОстатков2_4(Объект, ВспомогательныеРеквизиты, ИзмененныеРеквизиты)

	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	ОбновитьВсе = СтруктураИзмененныхРеквизитов.Количество() = 0;
	
	ПараметрыРеквизитовОбъекта = Новый Массив;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВУпрУчете")
		ИЛИ ОбновитьВсе Тогда
		
		ОбщегоНазначенияУТКлиентСервер.ДобавитьПараметрыРеквизитаОбъекта(
			"ПрочиеРасходы.СуммаБезНДС", 
			"ПрочиеРасходыСуммаБезНДС", 
			"Видимость", 
			Объект.ОтражатьВУпрУчете, 
			ПараметрыРеквизитовОбъекта);
		
		ОбщегоНазначенияУТКлиентСервер.ДобавитьПараметрыРеквизитаОбъекта(
			"ПрочиеРасходы.Сумма", 
			"ПрочиеРасходыСумма", 
			"Видимость", 
			Объект.ОтражатьВУпрУчете, 
			ПараметрыРеквизитовОбъекта);
		
	КонецЕсли; 
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВРеглУчете")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("Дата") 
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("Организация")
		ИЛИ ОбновитьВсе Тогда
		
		ЗначениеСвойства = 
			Объект.ОтражатьВРеглУчете
					И НЕ ВспомогательныеРеквизиты.ВедетсяУчетПостоянныхИВременныхРазниц
				ИЛИ НЕ ВспомогательныеРеквизиты.ВедетсяРегламентированныйУчетВНА;
			
		ОбщегоНазначенияУТКлиентСервер.ДобавитьПараметрыРеквизитаОбъекта(
			"ПрочиеРасходы.СуммаРегл", 
			"ПрочиеРасходыСуммаРегл1", 
			"Видимость", 
			ЗначениеСвойства, 
			ПараметрыРеквизитовОбъекта);
		
		//
		ЗначениеСвойства = 
			Объект.ОтражатьВРеглУчете 
			И ВспомогательныеРеквизиты.ВедетсяУчетПостоянныхИВременныхРазниц;
		
		ОбщегоНазначенияУТКлиентСервер.ДобавитьПараметрыРеквизитаОбъекта(
			"", 
			"ПрочиеРасходыСуммаРегл", 
			"ВидимостьЭлемента", 
			Объект.ОтражатьВРеглУчете И ВспомогательныеРеквизиты.ВедетсяУчетПостоянныхИВременныхРазниц, 
			ПараметрыРеквизитовОбъекта);
		
		ОбщегоНазначенияУТКлиентСервер.ДобавитьПараметрыРеквизитаОбъекта(
			"ПрочиеРасходы.СуммаНУ", 
			"ПрочиеРасходыСуммаНУ", 
			"Видимость", 
			ЗначениеСвойства, 
			ПараметрыРеквизитовОбъекта);
		
		ОбщегоНазначенияУТКлиентСервер.ДобавитьПараметрыРеквизитаОбъекта(
			"ПрочиеРасходы.СуммаПР", 
			"ПрочиеРасходыСуммаПР", 
			"Видимость", 
			ЗначениеСвойства, 
			ПараметрыРеквизитовОбъекта);
		
		ОбщегоНазначенияУТКлиентСервер.ДобавитьПараметрыРеквизитаОбъекта(
			"ПрочиеРасходы.СуммаВР", 
			"ПрочиеРасходыСуммаВР", 
			"Видимость", 
			ЗначениеСвойства, 
			ПараметрыРеквизитовОбъекта);
		
	КонецЕсли; 
	
	Возврат ПараметрыРеквизитовОбъекта;
	
КонецФункции

&НаСервере
Процедура ОбновитьЗаголовокФормы()
	
	Заголовок = ВнеоборотныеАктивыВызовСервера.ПредставлениеВводаОстатков(Объект);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОграничитьВыборАктивовИСтатейЗатрат(Форма)

	ПараметрыВыбораСтатьи = Новый Массив;
	ПараметрыВыбораСтатьи.Добавить(Новый ПараметрВыбора("Отбор.ТипРасходов", ПредопределенноеЗначение("Перечисление.ТипыРасходов.ФормированиеСтоимостиВНА")));
	
	Если Форма.Объект.ВидАктивов = ПредопределенноеЗначение("Перечисление.ВидыВнеоборотныхАктивов.ОбъектыСтроительства") Тогда
		
		ЗаголовокАктива = НСтр("ru = 'Объект строительства';
								|en = 'Assets under construction'");
		ТипАктивов = Новый ОписаниеТипов("СправочникСсылка.ОбъектыСтроительства");
		ПараметрыВыбораСтатьи.Добавить(Новый ПараметрВыбора("Отбор.РасходыНаОбъектыСтроительства", Истина));
		
	ИначеЕсли Форма.Объект.ВидАктивов = ПредопределенноеЗначение("Перечисление.ВидыВнеоборотныхАктивов.НМА") Тогда
		
		ЗаголовокАктива = НСтр("ru = 'Нематериальный актив (расходы на НИОКР)';
								|en = 'Intangible asset (R&D expenses)'");
		ТипАктивов = Новый ОписаниеТипов("СправочникСсылка.НематериальныеАктивы");
		ПараметрыВыбораСтатьи.Добавить(Новый ПараметрВыбора("Отбор.РасходыНаНМАиНИОКР", Истина));
		
	Иначе
		
		ЗаголовокАктива = НСтр("ru = 'Основное средство';
								|en = 'Fixed asset'");
		ТипАктивов = Новый ОписаниеТипов("СправочникСсылка.ОбъектыЭксплуатации");
		ПараметрыВыбораСтатьи.Добавить(Новый ПараметрВыбора("Отбор.РасходыНаОбъектыЭксплуатации", Истина));
	КонецЕсли;
	
	Форма.Элементы.ПрочиеРасходыВнеоборотныйАктив.Заголовок = ЗаголовокАктива;
	Форма.Элементы.ПрочиеРасходыВнеоборотныйАктив.ОграничениеТипа = ТипАктивов;
	Форма.Элементы.ПрочиеРасходыСтатьяРасходов.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораСтатьи);
	
КонецПроцедуры

&НаСервере
Процедура СтатьяПрочихРасходовПриИзмененииСервер(КэшированныеЗначения)
	
	СтрокаТаблицы = Объект.ПрочиеРасходы.НайтиПоИдентификатору(Элементы.ПрочиеРасходы.ТекущаяСтрока);
	
	СтруктураДействий = Новый Структура("ЗаполнитьПризнакПринимаетсяКНУ");
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТаблицы, СтруктураДействий, КэшированныеЗначения);
	ЗаполнитьСуммуПР(СтрокаТаблицы);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСуммуПР(СтрокаТаблицы)

	Если НЕ СтрокаТаблицы.ПринимаетсяКНУ И ВедетсяУчетПостоянныхИВременныхРазниц Тогда
		СтрокаТаблицы.СуммаПР = СтрокаТаблицы.СуммаРегл;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВидАктивовПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.ПрочиеРасходы.Очистить();
		ОграничитьВыборАктивовИСтатейЗатрат(ЭтотОбъект);
	Иначе
		Объект.ВидАктивов = ВидАктивовДоИзменения;
	КонецЕсли;
	
	ВидАктивовДоИзменения = Объект.ВидАктивов;
	
КонецПроцедуры

&НаСервере
Функция ДоступныеОсновныеСредства()
	
	СписокВнеоборотныхАктивов = Объект.ПрочиеРасходы.Выгрузить(,"ВнеоборотныйАктив").ВыгрузитьКолонку("ВнеоборотныйАктив");
	
	ДоступныеОсновныеСредства = Новый Массив();
	Для каждого ВнеоборотныйАктив Из СписокВнеоборотныхАктивов Цикл
		Если ТипЗнч(ВнеоборотныйАктив) = Тип("СправочникСсылка.ОбъектыЭксплуатации")Тогда
			ДоступныеОсновныеСредства.Добавить(ВнеоборотныйАктив);		
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДоступныеОсновныеСредства;
	
КонецФункции

&НаКлиенте
Функция ДанныеОПрослеживаемыхТоварахКорректны()
	
	ДанныеКорректны = Истина;
	ОсновныеСредства = ДоступныеОсновныеСредства();
	Для каждого Стр Из Объект.ПрослеживаемыеТовары Цикл
		Если ОсновныеСредства.Найти(Стр.ОсновноеСредство) = Неопределено Тогда
			СтрокаСообщения = НСтр("ru = 'Данные табличной части прослеживаемых товаров не соответствуют данным о внеоборотных активах. 
			|Значение %1 отсутствует в табличной части ""Расходы"".';
			|en = 'Data of the traceable goods table does not correspond to the data of fixed assets. 
			|The %1 value is missing in the ""Expenses"" table.'"); 
			СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, Стр.ОсновноеСредство);
			ОбщегоНазначенияКлиент.СообщитьПользователю(СтрокаСообщения,Объект.Ссылка);
			ДанныеКорректны = Ложь;	
		КонецЕсли;	
	КонецЦикла;

	Возврат ДанныеКорректны;

КонецФункции

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
