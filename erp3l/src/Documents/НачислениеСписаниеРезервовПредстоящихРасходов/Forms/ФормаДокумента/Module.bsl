#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);

КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ПредставлениеПериода = ОбщегоНазначенияУТКлиентСервер.ПолучитьПредставлениеПериодаРегистрации(Объект.Дата);
	
	ПараметрыВыбораСтатейИАналитик = Документы.НачислениеСписаниеРезервовПредстоящихРасходов.ПараметрыВыбораСтатейИАналитик(Перечисления.ХозяйственныеОперации.ПустаяСсылка());
	ДоходыИРасходыСервер.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ПараметрыГиперссылки = РаботаСФайлами.ГиперссылкаФайлов();
	ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
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
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПредставлениеПериода = ОбщегоНазначенияУТКлиентСервер.ПолучитьПредставлениеПериодаРегистрации(Объект.Дата);
	
	ПараметрыВыбораСтатейИАналитик = Документы.НачислениеСписаниеРезервовПредстоящихРасходов.ПараметрыВыбораСтатейИАналитик(Перечисления.ХозяйственныеОперации.ПустаяСсылка());
	ДоходыИРасходыСервер.ПриЧтенииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
	ДоходыИРасходыСервер.ПослеЗаписиНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ПроверитьСоответствиеРеквизитовРезервам();		
КонецПроцедуры

&НаКлиенте
Процедура ВидРезервовПриИзменении(Элемент)
	ПроверитьСоответствиеРеквизитовРезервам();
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбработчикЗакрытия = Новый ОписаниеОповещения("ПредставлениеПериодаНачалоВыбораЗавершение", ЭтотОбъект);
	ПараметрыФормы 	   = Новый Структура("Значение, РежимВыбораПериода", Объект.Дата, "МЕСЯЦ");
	
	ОткрытьФорму("ОбщаяФорма.ВыборПериода",
		ПараметрыФормы, 
		ЭтотОбъект, 
		УникальныйИдентификатор,
		,
		, 
		ОбработчикЗакрытия,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Объект.Дата = НачалоМесяца(Объект.Дата);
	ОбщегоНазначенияУТКлиент.РегулированиеПредставленияПериодаРегистрации(
		Направление,
		СтандартнаяОбработка,
		Объект.Дата,
		ПредставлениеПериода);
	Объект.Дата = КонецМесяца(Объект.Дата);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРезервы

&НаКлиенте
Процедура РезервыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ДоходыИРасходыКлиентСервер.ПриДобавленииСтрокиВТаблицу(ЭтотОбъект, Элементы.Резервы.ТекущиеДанные, "Объект.Резервы");
КонецПроцедуры

&НаКлиенте
Процедура РезервыОбъектУчетаРезервовПриИзменении(Элемент)
	ЗаполнитьТЧДаннымиРегистра(Элементы.Резервы.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура РезервыСтатьяРасходовНачисленияПриИзменении(Элемент)
	ДоходыИРасходыКлиентСервер.СтатьяПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура РезервыСтатьяРасходовНачисленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура РезервыСтатьяДоходовСписанияПриИзменении(Элемент)
	ДоходыИРасходыКлиентСервер.СтатьяПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура РезервыСтатьяДоходовСписанияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура РезервыАналитикаРасходовНачисленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДоходыИРасходыКлиент.НачалоВыбораАналитикиРасходов(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура РезервыАналитикаРасходовНачисленияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ДоходыИРасходыКлиент.АвтоПодборАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура РезервыАналитикаРасходовНачисленияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ДоходыИРасходыКлиент.ОкончаниеВводаТекстаАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
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


// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	 РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

&НаКлиенте
Процедура ЗагрузкаДанныхИзФайла(Команда)
	
	Если Объект.Резервы.Количество() Тогда
		ПараметрыОповещения = Новый Структура("ИмяСобытия", Команда.Имя);
		ОчисткаТЧОписаниеОповещения = Новый ОписаниеОповещения("ВопросОчисткиТабличнойЧастиЗавершение", ЭтотОбъект, ПараметрыОповещения);
		ТекстВопроса = НСтр("ru = 'Очистить таблицу резервов перед заполнением по данным из файла?';
							|en = 'Clear table of reserve before filling in according to data from file?'");
		ПоказатьВопрос(ОчисткаТЧОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	Иначе
		ЗагрузитьДанныеИзФайлаНачало();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Перед заполнением резервов необходимо заполнить организацию документа';
								|en = 'Populate document company before populating reserves'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, "Организация", "Объект.Организация");
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ВидРезервов) Тогда
		ТекстСообщения = НСтр("ru = 'Перед заполнением резервов необходимо заполнить вид резервов документа';
								|en = 'Populate document reserve kind before populating reserve'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, "ВидРезервов", "Объект.ВидРезервов");
		Возврат;
	КонецЕсли;
	
	Если Объект.Резервы.Количество() Тогда
		ПараметрыОповещения = Новый Структура("ИмяСобытия", Команда.Имя);
		ОчисткаТЧОписаниеОповещения = Новый ОписаниеОповещения("ВопросОчисткиТабличнойЧастиЗавершение", ЭтотОбъект, ПараметрыОповещения);
		ТекстВопроса = НСтр("ru = 'Очистить таблицу резервов перед заполнением по данным регистра?';
							|en = 'Clear table of reserve before filling in according to register data?'");
		ПоказатьВопрос(ОчисткаТЧОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	Иначе
		ЗаполнитьТЧДаннымиРегистра();
	КонецЕсли;
		
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

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезервыНоваяСуммаРегл.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Резервы.УстановитьНовуюСуммуРегл");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<без изменений>';
																|en = '<without changes>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезервыНоваяСуммаУпр.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Резервы.УстановитьНовуюСуммаУпр");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<без изменений>';
																|en = '<without changes>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	// Установка видимости сумм упр. учет в зависимости от ФО.
	
	ИменаЭлементовУпрУчета = Новый Массив;
	ИменаЭлементовУпрУчета.Добавить("РезервыТекущаяСуммаУпр");
	ИменаЭлементовУпрУчета.Добавить("РезервыУстановитьНовуюСуммаУпр");
	ИменаЭлементовУпрУчета.Добавить("РезервыНоваяСуммаУпр");
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	Для Каждого ИмяЭлементаУпрУчета Из ИменаЭлементовУпрУчета Цикл
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяЭлементаУпрУчета);
		
	КонецЦикла;

	НачалоПериодаИспользованияУУ  = РасчетСебестоимостиПовтИсп.ДатаНачалаВеденияУправленческогоУчетаОрганизаций();
	НачалоПериодаИспользованияПУ22 = РасчетСебестоимостиПовтИсп.ДатаПереходаНаПартионныйУчетВерсии22();
	ПартионныйУчетВерсии22 = РасчетСебестоимостиПовтИсп.ПартионныйУчетВерсии22();
	УправленческийУчетОрганизаций = РасчетСебестоимостиПовтИсп.УправленческийУчетОрганизаций();
	
	ГруппаИли = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборЭлемента = ГруппаИли.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Дата");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = Макс(НачалоПериодаИспользованияПУ22, НачалоПериодаИспользованияУУ);
	
	ОтборЭлемента = ГруппаИли.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = ПартионныйУчетВерсии22 И УправленческийУчетОрганизаций;
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

#Область ЗаполнениеТабличнойЧасти

&НаКлиенте
Процедура ЗагрузитьДанныеИзФайлаНачало()
	
	ПараметрыЗагрузки = ЗагрузкаДанныхИзФайлаКлиент.ПараметрыЗагрузкиДанных();
	ПараметрыЗагрузки.ПолноеИмяТабличнойЧасти = "НачислениеСписаниеРезервовПредстоящихРасходов.Резервы";
	ПараметрыЗагрузки.Заголовок = НСтр("ru = 'Загрузка резервов из файла';
										|en = 'Import reserves from file'");
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьДанныеИзФайлаЗавершение", ЭтотОбъект);
	ЗагрузкаДанныхИзФайлаКлиент.ПоказатьФормуЗагрузки(ПараметрыЗагрузки, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзФайлаЗавершение(АдресЗагруженныхДанных, ДополнительныеПараметры) Экспорт
	
	Если АдресЗагруженныхДанных = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЗагрузитьДанныеИзФайлаНаСервере(АдресЗагруженныхДанных);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеИзФайлаНаСервере(АдресЗагруженныхДанных)
	
	ЗагруженныеДанные = ПолучитьИзВременногоХранилища(АдресЗагруженныхДанных);
	
	СтрокиИзменены = Ложь;
	
	ОбъектыУчетаРезервов = ОбщегоНазначения.ВыгрузитьКолонку(ЗагруженныеДанные, "ОбъектУчетаРезервов", Истина);
	
	ПараметрыЗаполненияРезервов = Новый Структура("Дата, Ссылка, Организация, ВидРезервов");
	ЗаполнитьЗначенияСвойств(ПараметрыЗаполненияРезервов, Объект);
	Результат = Документы.НачислениеСписаниеРезервовПредстоящихРасходов.ДанныеДляЗаполненияРезервов(ПараметрыЗаполненияРезервов, ОбъектыУчетаРезервов);
	
	Выборка  = Результат.Выбрать();
	
	Если ЗагруженныеДанные.Количество() <> Выборка.Количество() Тогда
		Сообщение = НСтр("ru = 'Не для всех загружаемых строк были найдены соответствия в справочнике ""Объекты учета резервов"". Не все строки были загружены.';
						|en = 'Matches were found not for all imported lines in the ""Reserve accounting objects"" catalog. Not all lines were imported.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение, Объект.Ссылка, "Объект.Резервы");
	КонецЕсли;
	
	Пока Выборка.Следующий() Цикл
		СтруктураПоиска = Новый Структура("ОбъектУчетаРезервов", Выборка.ОбъектУчетаРезервов);
		МассивСтрокСТекущимОбъектомРезервов = Объект.Резервы.НайтиСтроки(СтруктураПоиска);
		Если МассивСтрокСТекущимОбъектомРезервов.Количество() Тогда
			СтрокаРезерва = МассивСтрокСТекущимОбъектомРезервов.Получить(0);
		Иначе
			СтрокаРезерва = Объект.Резервы.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаРезерва, Выборка);
			СтрокиИзменены = Истина;
		КонецЕсли;
		ЗагруженныеСтроки = ЗагруженныеДанные.НайтиСтроки(СтруктураПоиска);
		Для каждого НайденнаяСтрока Из ЗагруженныеСтроки Цикл
			СтрокаРезерва.НоваяСуммаРегл = СтрокаРезерва.НоваяСуммаРегл + НайденнаяСтрока.НоваяСуммаРегл;
			СтрокаРезерва.НоваяСуммаУпр = СтрокаРезерва.НоваяСуммаУпр + НайденнаяСтрока.НоваяСуммаУпр;
		КонецЦикла;
		СтрокаРезерва.УстановитьНовуюСуммуРегл = ЗначениеЗаполнено(СтрокаРезерва.НоваяСуммаРегл);
		СтрокаРезерва.УстановитьНовуюСуммаУпр = ЗначениеЗаполнено(СтрокаРезерва.НоваяСуммаУпр);
		СтрокиИзменены = СтрокиИзменены ИЛИ ЗначениеЗаполнено(СтрокаРезерва.НоваяСуммаРегл) ИЛИ ЗначениеЗаполнено(СтрокаРезерва.НоваяСуммаУпр);			
	КонецЦикла;
	
	Если СтрокиИзменены Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОчисткиТабличнойЧастиЗавершение(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Резервы.Очистить();
	ИначеЕсли Результат = КодВозвратаДиалога.Отмена И ДополнительныеПараметры.ИмяСобытия <> "ИзменениеРеквизитов" Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ИмяСобытия = "Заполнить" Тогда
		ЗаполнитьТЧДаннымиРегистра();
	ИначеЕсли ДополнительныеПараметры.ИмяСобытия = "ЗагрузкаДанныхИзФайла" Тогда
		ЗагрузитьДанныеИзФайлаНачало();
	ИначеЕсли ДополнительныеПараметры.ИмяСобытия = "ИзменениеРеквизитов" И Результат <> КодВозвратаДиалога.Да Тогда
		Объект.ВидРезервов = ДополнительныеПараметры.СтарыеРеквизиты.ВидРезервов;
		Объект.Организация = ДополнительныеПараметры.СтарыеРеквизиты.Организация;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТЧДаннымиРегистра(ИдентификаторСтроки = Неопределено)
	
	ОбъектыУчетаРезервов = Новый Массив;
	// Если Идентификатор строки не определен - значит заполняем всю табличную часть
	Если ИдентификаторСтроки <> Неопределено Тогда
		СтрокаРезерва = Объект.Резервы.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если СтрокаРезерва <> Неопределено Тогда
			// Проверим, есть ли такой объект учета в списке, и если есть, то выдадим сообщение об ошибке:
			СтруктураПоиска = Новый Структура("ОбъектУчетаРезервов", СтрокаРезерва.ОбъектУчетаРезервов);
			МассивСтрокСТекущимОбъектомРезервов = Объект.Резервы.НайтиСтроки(СтруктураПоиска);
			Если МассивСтрокСТекущимОбъектомРезервов.Количество() > 1 Тогда
				Для каждого СтрокаТекущегоОбъекта Из МассивСтрокСТекущимОбъектомРезервов Цикл
					Если СтрокаТекущегоОбъекта.ПолучитьИдентификатор() <> ИдентификаторСтроки Тогда
						ТекстОшибки = НСтр("ru = 'Строка с введенным объектом учета резервов уже есть в документе.';
											|en = 'Line with entered reserve accounting object already exists in the document.'");
						Путь = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Резервы", СтрокаТекущегоОбъекта.НомерСтроки, "ОбъектУчетаРезервов");
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Объект.Ссылка, Путь);
						СтрокаРезерва.ОбъектУчетаРезервов = Справочники.ОбъектыУчетаРезервовПредстоящихРасходов.ПустаяСсылка();
					КонецЕсли;
				КонецЦикла;
				Возврат;
			КонецЕсли;
			ОбъектыУчетаРезервов.Добавить(СтрокаРезерва.ОбъектУчетаРезервов);
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыЗаполненияРезервов = Новый Структура("Дата, Ссылка, Организация, ВидРезервов");
	ЗаполнитьЗначенияСвойств(ПараметрыЗаполненияРезервов, Объект);
	Результат = Документы.НачислениеСписаниеРезервовПредстоящихРасходов.ДанныеДляЗаполненияРезервов(ПараметрыЗаполненияРезервов, ОбъектыУчетаРезервов);
	
	Выборка  = Результат.Выбрать();
	
	Если ОбъектыУчетаРезервов.Количество() = 0 Тогда
		Пока Выборка.Следующий() Цикл
			СтруктураПоиска = Новый Структура("ОбъектУчетаРезервов", Выборка.ОбъектУчетаРезервов);
			МассивСтрокСТекущимОбъектомРезервов = Объект.Резервы.НайтиСтроки(СтруктураПоиска);
			Если МассивСтрокСТекущимОбъектомРезервов.Количество() Тогда
				СтрокаРезерва = МассивСтрокСТекущимОбъектомРезервов.Получить(0);
				ЗаполнитьЗначенияСвойств(СтрокаРезерва, Выборка, "ТекущаяСуммаРегл,ТекущаяСуммаУпр");
			Иначе
				СтрокаРезерва = Объект.Резервы.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРезерва, Выборка);
			КонецЕсли;
		КонецЦикла;
	Иначе
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(СтрокаРезерва, Выборка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСоответствиеРеквизитовРезервам()
	
	Если Объект.Резервы.Количество() Тогда
		
		ОбъектУчетаРезервов = Неопределено;
		Для каждого СтрокаРезерва Из Объект.Резервы Цикл
			Если ЗначениеЗаполнено(СтрокаРезерва.ОбъектУчетаРезервов) Тогда
				ОбъектУчетаРезервов = СтрокаРезерва.ОбъектУчетаРезервов;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ОбъектУчетаРезервов = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		РеквизитыРезерва = ДанныеРезерва(ОбъектУчетаРезервов);
		
		Если РеквизитыРезерва.Организация <> Объект.Организация
			ИЛИ РеквизитыРезерва.ВидРезервов <> Объект.ВидРезервов Тогда
			
			ПараметрыОповещения = Новый Структура("ИмяСобытия, СтарыеРеквизиты", "ИзменениеРеквизитов", РеквизитыРезерва);
			ОчисткаТЧОписаниеОповещения = Новый ОписаниеОповещения("ВопросОчисткиТабличнойЧастиЗавершение", ЭтотОбъект, ПараметрыОповещения);
			ТекстВопроса = НСтр("ru = 'Таблица резервов будет очищена. Продолжить?';
								|en = 'Reserve table will be cleared. Continue?'");
			ПоказатьВопрос(ОчисткаТЧОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеРезерва(ОбъектУчетаРезервов)
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОбъектУчетаРезервов, "Организация, ВидРезервов");
	
КонецФункции

#КонецОбласти

&НаКлиенте
Процедура ПредставлениеПериодаНачалоВыбораЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт 
	
	Если ВыбранныйПериод = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Объект.Дата = КонецМесяца(ВыбранныйПериод);
	ПредставлениеПериода = ОбщегоНазначенияУТКлиентСервер.ПолучитьПредставлениеПериодаРегистрации(Объект.Дата);
	
КонецПроцедуры

#КонецОбласти
