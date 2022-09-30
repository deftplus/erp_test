
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ОбменДаннымиУТ.ВЭтомУзлеДоступноВыполнениеОперацийЗакрытияМесяца(Отказ) Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ПериодРегистрации") Тогда
		Объект.Дата = Параметры.ПериодРегистрации;
	КонецЕсли;
	
	// Контроль создания документа в подчиенном узле РИБ с фильтрами
	ОбменДаннымиУТУП.КонтрольСозданияДокументовВРаспределеннойИБ(Объект, Отказ);

	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.РаспределениеНДС.ПараметрыВыбораСтатейИАналитик(Объект);
	ДоходыИРасходыСервер.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	УправлениеЭлементамиФормы();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();

	ПараметрыВыбораСтатейИАналитик = Документы.РаспределениеНДС.ПараметрыВыбораСтатейИАналитик(Объект);
	ДоходыИРасходыСервер.ПриЧтенииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДоходыИРасходыСервер.ПослеЗаписиНаСервере(ЭтотОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьНадписьПериод();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("Запись_РаспределениеНДС");
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ПериодПриИзмененииСервер();
	ОбновитьНадписьПериод();
	
КонецПроцедуры

&НаКлиенте
Процедура БазаВыручкаПриИзменении(Элемент)
	
	БазаВыручкаПриИзмененииЛокализация(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СписатьНДСПоРасходамАктивамНаСтатьиОтраженияПриИзменении(Элемент)
	
	СписатьНДСПоРасходамАктивамНаСтатьиОтраженияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	ОбновитьНадписьПериод();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяЗатратНеНДСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	ДоходыИРасходыКлиентСервер.СтатьяПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораАналитикиРасходов(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.АвтоПодборАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.ОкончаниеВводаТекстаАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОпределенияБазыРаспределенияНДСПриИзменении(Элемент)
	
	ВариантОпределенияБазыРаспределенияНДСПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьБазуРаспределенияПоВыручкеСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьДанныеПоВыручкеСервер();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ВариантОпределенияБазыРаспределенияНДСПриИзмененииСервер()
	
	Объект.БазаРаспределенияУстанавливаетсяВручную = 
		?(ВариантОпределенияБазыРаспределенияНДС = 1, Истина, Ложь);
		
	Если Объект.БазаРаспределенияУстанавливаетсяВручную Тогда
		ЗаполнитьБазуРаспределенияПоВыручкеСервер();
	Иначе
		ОбновитьДанныеПоВыручкеСервер();
	КонецЕсли;
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ИнициализацияИЗаполнение

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ОбновитьПараметрыУчетнойПолитики();
	
	ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
	ИспользуетсяУчетПрочихДоходовРасходов = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов");
	
	ВариантОпределенияБазыРаспределенияНДС = ?(Объект.БазаРаспределенияУстанавливаетсяВручную, 1, 0);
	
	Если НЕ Объект.БазаРаспределенияУстанавливаетсяВручную Тогда
		ОбновитьДанныеПоВыручкеСервер();
	КонецЕсли;
	
	ПриЧтенииСозданииНаСервереЛокализация();
	
	НастройкиСистемыЛокализация.УстановитьВидимостьЭлементовЛокализации(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()

	Элементы.ГруппаБазаРаспределения.ТекущаяСтраница = 
		?(Объект.БазаРаспределенияУстанавливаетсяВручную,
			Элементы.ГруппаБазаУказанаВручную,
			Элементы.ГруппаБазаУказанаАвтоматически);
	
	УправлениеЭлементамиФормыЛокализация(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
	
	ПравилаСписания = Документы.РаспределениеНДС.ЗаполнитьПравилаСписанияНДС(Объект.Организация);
	ЗаполнитьЗначенияСвойств(Объект,ПравилаСписания);
	
	ОбновитьПараметрыУчетнойПолитики();
	
	ПараметрыВыбораСтатейИАналитик = Документы.РаспределениеНДС.ПараметрыВыбораСтатейИАналитик(Объект);
	ДоходыИРасходыСервер.ПриИзмененииПараметровВыбораСтатей(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПериодПриИзмененииСервер()
	
	ОбновитьПараметрыУчетнойПолитики();
	ПараметрыВыбораСтатейИАналитик = Документы.РаспределениеНДС.ПараметрыВыбораСтатейИАналитик(Объект);
	ДоходыИРасходыСервер.ПриИзмененииПараметровВыбораСтатей(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаСервере
Процедура СписатьНДСПоРасходамАктивамНаСтатьиОтраженияПриИзмененииСервер()

	ПараметрыВыбораСтатейИАналитик = Документы.РаспределениеНДС.ПараметрыВыбораСтатейИАналитик(Объект);
	ДоходыИРасходыСервер.ПриИзмененииПараметровВыбораСтатей(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНачалоПериода()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	Документы.РаспределениеНДС.УстановитьНачалоПериода(Объект.НачалоПериода, Объект.Дата, Объект.Организация);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПараметрыУчетнойПолитики()
	ПараметрыУчетнойПолитики = НастройкиНалоговУчетныхПолитикПовтИсп.ДействующиеПараметрыНалоговУчетныхПолитик(
		"НастройкиУчетаНДС",
		Объект.Организация,
		Объект.Дата);
		
	Если ПараметрыУчетнойПолитики <> Неопределено Тогда
		ПериодичностьРаспределенияНДС = ПараметрыУчетнойПолитики.ПериодичностьРаспределенияНДС;
	КонецЕсли;
	УстановитьНачалоПериода();
	ОбновитьПараметрыУчетнойПолитикиЛокализация();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНадписьПериод()
	
	Если ПериодичностьРаспределенияНДС = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		ПредставлениеПериода = Формат(Объект.НачалоПериода, НСтр("ru = 'ДФ=''ММММ гггг ""г.""''';
																|en = 'DF=''MMMM yyyy'''"));
	Иначе
		ПредставлениеПериода = Формат(Объект.НачалоПериода, НСтр("ru = 'ДФ=''к ""Квартал"" гггг  ""г.""''';
																|en = 'DF=''q ""Quarter"" yyyy  ""y.""'''"));
	КонецЕсли;
	
	НадписьПериод = ПредставлениеПериода;
	ОбновитьНадписьПериодЛокализация();
	
КонецПроцедуры

#КонецОбласти

#Область Автозаполнение

&НаСервере
Процедура ЗаполнитьБазуРаспределенияПоВыручкеСервер()
	
	Результат = Документы.РаспределениеНДС.ПолучитьБазуРаспределения(Объект.Дата, Объект.НачалоПериода, Объект.Организация);
	Документы.РаспределениеНДС.ЗаполнитьБазуРаспределения(Объект, Результат);
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеПоВыручкеСервер()
	
	Результат = Документы.РаспределениеНДС.ПолучитьБазуРаспределения(Объект.Дата, Объект.НачалоПериода, Объект.Организация);
	Документы.РаспределениеНДС.ЗаполнитьБазуРаспределения(ЭтотОбъект, Результат);
	Документы.РаспределениеНДС.ЗаполнитьБазуРаспределения(Объект, Результат);
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьДокументыЭкспорт(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресВременногоХранилища", ПоместитьБазаДокументыЭкспортВоВременноеХранилище());
	ПараметрыФормы.Вставить("РежимРедактирования", Истина);
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ФормаДокументыЭкспортЗакрытие", ЭтотОбъект);
	ОткрытьФорму("Документ.РаспределениеНДС.Форма.ФормаДокументыЭкспорт", ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьБазаДокументыЭкспортВоВременноеХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.ДокументыЭкспорт.Выгрузить(), УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ФормаДокументыЭкспортЗакрытие(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ФормаДокументыЭкспортЗакрытиеСервер(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ФормаДокументыЭкспортЗакрытиеСервер(АдресВременногоХранилища)
	
	Объект.ДокументыЭкспорт.Загрузить(ПолучитьИзВременногоХранилища(АдресВременногоХранилища));
	
	Объект.ВыручкаНДС0 = 
		Объект.ДокументыЭкспорт.Итог("СуммаВыручки")
		+ Объект.ДокументыЭкспорт.Итог("КорректировкаВыручки");
	
	ДокументыЭкспортПриИзмененииЛокализация();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПосмотретьДокументыЭкспорт(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресВременногоХранилища", ПоместитьДокументыЭкспортВоВременноеХранилище());
	ПараметрыФормы.Вставить("РежимРедактирования", Ложь);
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	
	ОткрытьФорму("Документ.РаспределениеНДС.Форма.ФормаДокументыЭкспорт", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьДокументыЭкспортВоВременноеХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(ДокументыЭкспорт.Выгрузить(), УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти

#Область Локализация

&НаСервере
Процедура УправлениеЭлементамиФормыЛокализация(Форма)
	//++ Локализация
	ЭтоКонецКвартала = (Месяц(Объект.Дата)%3 = 0);
	
	Элементы.ГруппаПрименениеПравила5Процентов.Видимость = УчитыватьПорог5Процентов И ЭтоКонецКвартала;
	
	ПоказыватьВыручкуНеВРФ = Объект.НачалоПериода >= '20190701'
		И УчетНДСУП.ПараметрыУчетаПоОрганизации(Объект.Организация, Объект.НачалоПериода).ЕстьРеализацияРаботУслугНеНаТерриторииРФ;
	Элементы.БазаВыручкаНеРФ.Видимость = ПоказыватьВыручкуНеВРФ;
	Элементы.ВыручкаНеРФ.Видимость = ПоказыватьВыручкуНеВРФ;
	Элементы.БазаВыручкаЕНВД.Видимость = ПрименяетсяЕНВД;
	Элементы.ВыручкаЕНВД.Видимость = ПрименяетсяЕНВД;
	Элементы.БазаДокументыЭкспорт.Видимость = Истина;
	Элементы.ДокументыЭкспорт.Видимость = Истина;
	
	Элементы.ГруппаСтатьяРасходовЕНВД.Видимость = ПрименяетсяЕНВД;
	
	ШаблонЗаголовка = НСтр("ru = 'Документы экспорта сырьевых товаров, работ, услуг (%1)';
							|en = 'Export documents of commodities, works, services (%1)'");
	ТекстЗаголовка = НСтр("ru = 'Документы экспорта сырьевых товаров, работ, услуг';
							|en = 'Export documents of commodities, works, services'");
	Если Объект.ДокументыЭкспорт.Количество() <> 0 Тогда
		Элементы.БазаДокументыЭкспорт.Заголовок = СтрШаблон(ШаблонЗаголовка, Объект.ДокументыЭкспорт.Количество());
	Иначе
		Элементы.БазаДокументыЭкспорт.Заголовок = ТекстЗаголовка;
	КонецЕсли;
	
	Если ДокументыЭкспорт.Количество() <> 0 Тогда
		Элементы.ДокументыЭкспорт.Заголовок = СтрШаблон(ШаблонЗаголовка, ДокументыЭкспорт.Количество());
		Элементы.ДокументыЭкспорт.Доступность = Истина;
	Иначе
		Элементы.ДокументыЭкспорт.Заголовок = ТекстЗаголовка;
		Элементы.ДокументыЭкспорт.Доступность = Ложь;
	КонецЕсли;
		
	УпрощенныйПорядокВычетаНДСПоНесырьевомуЭкспорту = УчетНДСРФ.УпрощенныйПорядокВычетаНДСПоНесырьевомуЭкспорту(Форма.Объект.Дата);
	
	Элементы.ВыручкаНДС0.Видимость = НЕ УпрощенныйПорядокВычетаНДСПоНесырьевомуЭкспорту;
	Элементы.БазаВыручкаНДС0.Видимость = НЕ УпрощенныйПорядокВычетаНДСПоНесырьевомуЭкспорту;
	
	ПоказыватьЭкспортНесырьевыхТоваров = 
		УпрощенныйПорядокВычетаНДСПоНесырьевомуЭкспорту И ПолучитьФункциональнуюОпцию("ИспользоватьПродажиНаЭкспортНесырьевыхТоваров");
	Элементы.ВыручкаНДС0НесырьевыеТовары.Видимость = ПоказыватьЭкспортНесырьевыхТоваров;
	Элементы.БазаВыручкаНДС0НесырьевыеТовары.Видимость = ПоказыватьЭкспортНесырьевыхТоваров;
	
	ПоказыватьЭкспортСырьевыхТоваровУслуг = 
		УпрощенныйПорядокВычетаНДСПоНесырьевомуЭкспорту И ПолучитьФункциональнуюОпцию("ИспользоватьПродажиНаЭкспортСырьевыхТоваровУслуг");
	
	Элементы.ВыручкаНДС0СырьевыеТоварыУслуги.Видимость = ПоказыватьЭкспортСырьевыхТоваровУслуг;
	Элементы.ДокументыЭкспорт.Видимость = ПоказыватьЭкспортСырьевыхТоваровУслуг;
	
	Элементы.БазаВыручкаНДС0СырьевыеТоварыУслуги.Видимость = ПоказыватьЭкспортСырьевыхТоваровУслуг;
	Элементы.БазаДокументыЭкспорт.Видимость = ПоказыватьЭкспортСырьевыхТоваровУслуг;
	
	СформироватьПояснениеПримененияПорога5Процентов();
	//-- Локализация
	Возврат;
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервереЛокализация() 
	
	//++ Локализация
	ВариантПримененияПравила5Процентов = ?(Объект.ПрименитьПравило5Процентов, 1, 0);
	СформироватьПояснениеПримененияПорога5Процентов();
	//-- Локализация
	Возврат;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПараметрыУчетнойПолитикиЛокализация()
	//++ Локализация
	УстанавливатьНачалоПериода = Ложь;
	
	ПараметрыУчетнойПолитики = НастройкиНалоговУчетныхПолитикПовтИсп.ДействующиеПараметрыНалоговУчетныхПолитик(
		"НастройкиУчетаНДС",
		Объект.Организация,
		Объект.Дата);
		
	Если ПараметрыУчетнойПолитики <> Неопределено Тогда
		УчитыватьПорог5Процентов = ПараметрыУчетнойПолитики.Учитывать5ПроцентныйПорог;
		УстанавливатьНачалоПериода = Истина;
	КонецЕсли;
	
	ПараметрыУчетнойПолитики= НастройкиНалоговУчетныхПолитикПовтИсп.ДействующиеПараметрыНалоговУчетныхПолитик(
		"НастройкиСистемыНалогообложения",
		Объект.Организация,
		Объект.Дата);
	
	Если ПараметрыУчетнойПолитики <> Неопределено Тогда
		ПрименяетсяЕНВД = ПараметрыУчетнойПолитики.ПрименяетсяЕНВД;
		УстанавливатьНачалоПериода = Истина;
	КонецЕсли;
	
	Если УстанавливатьНачалоПериода Тогда
		УстановитьНачалоПериода();
	КонецЕсли;
	//-- Локализация
КонецПроцедуры

&НаСервере
Процедура ОбновитьНадписьПериодЛокализация()
	//++ Локализация
	Если КонецКвартала(Объект.НачалоПериода) <> КонецКвартала(Объект.Дата) Тогда
		// Распределение НДС за расширенный налоговый период по НДС (п.2 ст. 55 НК).
		Если НачалоМесяца(Объект.Дата) = НачалоКвартала(Объект.Дата) Тогда
			ШаблонСообщения = НСтр("ru = '%1 - %2 (только ОС и НМА)';
									|en = '%1 - %2 (only FA and IA)'");
			ПредставлениеПериода = СтрШаблон(ШаблонСообщения,
				Формат(Объект.НачалоПериода, "ДЛФ=D"),
				Формат(КонецМесяца(Объект.Дата), "ДЛФ=D"));	
		Иначе
			ШаблонСообщения = НСтр("ru = '%1 - %2';
									|en = '%1 - %2'");
			ПредставлениеПериода = СтрШаблон(ШаблонСообщения,
				Формат(Объект.НачалоПериода, "ДЛФ=D"),
				Формат(КонецМесяца(Объект.Дата), "ДЛФ=D"));
		КонецЕсли; 
	ИначеЕсли КонецМесяца(Объект.Дата) <> КонецКвартала(Объект.Дата) Тогда
		ПредставлениеПериода = Формат(Объект.НачалоПериода, "ДФ='ММММ гггг  ''г. (только ОС и НМА)'''");
	Иначе
		ПредставлениеПериода = Формат(Объект.НачалоПериода, "ДФ='к ''Квартал'' гггг  ''г.'''");
	КонецЕсли;
	
	НадписьПериод = ПредставлениеПериода;	
	//-- Локализация
КонецПроцедуры

&НаСервере
Процедура БазаВыручкаПриИзмененииЛокализация(ИмяЭлемента)
	
	//++ Локализация
	Если ЭтотОбъект.Элементы[ИмяЭлемента] = Элементы.БазаВыручкаНДС0НесырьевыеТовары Тогда
		Объект.ВыручкаНДС0 = Объект.ВыручкаНДС0СырьевыеТоварыУслуги + Объект.ВыручкаНДС0НесырьевыеТовары;
	КонецЕсли;
	//-- Локализация
	
КонецПроцедуры

&НаСервере
Процедура ДокументыЭкспортПриИзмененииЛокализация()
	//++ Локализация
	Объект.ВыручкаНДС0СырьевыеТоварыУслуги = Объект.ДокументыЭкспорт.Итог("СуммаВыручки") + Объект.ДокументыЭкспорт.Итог("КорректировкаВыручки");
	Объект.ВыручкаНДС0 = Объект.ВыручкаНДС0СырьевыеТоварыУслуги + Объект.ВыручкаНДС0НесырьевыеТовары;
	//-- Локализация	
КонецПроцедуры

&НаКлиенте
Процедура ВариантПримененияПравила5ПроцентовПриИзменении(Элемент)
	//++ Локализация
	ВариантПримененияПравила5ПроцентовПриИзмененииСервер();
	//-- Локализация
КонецПроцедуры

//++ Локализация

&НаСервере
Процедура СформироватьПояснениеПримененияПорога5Процентов()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) ИЛИ НЕ УчитыватьПорог5Процентов Тогда
		Элементы.ГруппаПояснениеПримененияПравила5Процентов.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаПояснениеПримененияПравила5Процентов.Видимость = Истина;
	
	Состояние = ЗакрытиеМесяцаСервер.ОпределитьСостояниеЭтаповРасчета(
		Перечисления.ОперацииЗакрытияМесяца.РасчетПартийИСебестоимости,
		Объект.Дата,
		Объект.Организация,
		Ложь,,
		Перечисления.ОперацииЗакрытияМесяца.РасчетПартийИСебестоимости);
	
	Если Состояние = Перечисления.СостоянияОперацийЗакрытияМесяца.ВыполненоСОшибками
	 ИЛИ Состояние = Перечисления.СостоянияОперацийЗакрытияМесяца.НеВыполнено Тогда
		
		КартинкаПояснение = БиблиотекаКартинок.Информация;
		ТекстПояснения = НСтр("ru = 'Расчет себестоимости не выполнен, решение следует принять на основании предварительной оценки.';
								|en = 'Cost is not calculated, decision should be made based on the preliminary estimate. '");
		
	Иначе
		
		Оценка = РаспределениеНДСЛокализация.ОценкаПримененияПравила5Процентов(Объект.Организация, Объект.Дата); // в таблице должна быть только одна строка
		
		Если Оценка.Количество() <> 1 Тогда
			
			Элементы.ГруппаПояснениеПримененияПравила5Процентов.Видимость = Ложь;
			Возврат;
			
		ИначеЕсли Оценка[0].РасходыПоДеятельностиНеОблагаемойНДС = 0 Тогда
			
			Если НЕ Объект.ПрименитьПравило5Процентов Тогда
				КартинкаПояснение = БиблиотекаКартинок.Внимание16;
			Иначе
				КартинкаПояснение = БиблиотекаКартинок.Информация;
			КонецЕсли;
			
			ТекстПояснения = НСтр("ru = 'Отсутствуют расходы по реализации, не облагаемой НДС. Весь НДС может быть принят к вычету.';
									|en = 'No expenses for the sale not subject to VAT. The whole VAT cannot be accepted for deduction.'");
			
		Иначе
			
			Если НЕ Объект.ПрименитьПравило5Процентов И Оценка[0].Доля <= 5 Тогда
				КартинкаПояснение = БиблиотекаКартинок.Внимание16;
				ШаблонПояснения =
					НСтр("ru = 'Расходы по реализациии, не облагаемой НДС (%1 %2), составляют %4% от общих расходов (%3 %2). 
								|Весь НДС может быть принят к вычету.';
								|en = 'Expenses for sale not subject to VAT (%1 %2) make up %4% from total expenses (%3 %2).
								|The whole VAT can be accepted for deduction.'");
			ИначеЕсли Объект.ПрименитьПравило5Процентов И Оценка[0].Доля > 5 Тогда
				КартинкаПояснение = БиблиотекаКартинок.ВниманиеКрасный;
				ШаблонПояснения =
					НСтр("ru = 'Расходы по реализациии, не облагаемой НДС (%1 %2), составляют %4% от общих расходов (%3 %2). 
								|НДС должен быть распределен между видами деятельности.';
								|en = 'Expenses for sale not subject to VAT (%1 %2) make up %4% from total expenses (%3 %2).
								|VAT should be allocated between activity categories. '");
			Иначе
				КартинкаПояснение = БиблиотекаКартинок.Информация;
				ШаблонПояснения = НСтр("ru = 'Расходы по реализациии, не облагаемой НДС (%1 %2), составляют %4% от общих расходов (%3 %2).';
										|en = 'Expenses for sale not subject to VAT (%1 %2) make up %4% from total expenses (%3 %2).'");
			КонецЕсли;
			
			ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонПояснения,  
				Оценка[0].РасходыПоДеятельностиНеОблагаемойНДС,
				ВалютаРегламентированногоУчета,
				Оценка[0].РасходыВсего,
				Формат(Оценка[0].Доля, "ЧДЦ=2"));
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВариантПримененияПравила5ПроцентовПриИзмененииСервер()
	
	Объект.ПрименитьПравило5Процентов = ?(ВариантПримененияПравила5Процентов = 1, Истина, Ложь);
	УправлениеЭлементамиФормы();

КонецПроцедуры

//-- Локализация

#КонецОбласти

#КонецОбласти
