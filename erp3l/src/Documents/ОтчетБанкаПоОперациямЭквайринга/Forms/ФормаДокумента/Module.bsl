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
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ОтчетБанкаПоОперациямЭквайринга.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ИсправлениеДокументов.ПриСозданииНаСервере(ЭтаФорма, Элементы.СтрокаИсправление);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Документ.ОтчетБанкаПоОперациямЭквайринга.Форма.ФормаПодбораПлатежей" Тогда
		ПолучитьПлатежиИзХранилища(РезультатВыбора.ПодборВходящихПлатежей, РезультатВыбора.АдресПлатежейВХранилище);
		РассчитатьСуммуДокумента();
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;
	
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
	
	ПараметрыВыбораСтатейИАналитик = Документы.ОтчетБанкаПоОперациямЭквайринга.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПриЧтенииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ПриЧтенииСозданииНаСервере();

	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИсправлениеДокументов.ПриЧтенииНаСервере(ЭтаФорма, Элементы.СтрокаИсправление);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ОтчетБанкаПоОперациямЭквайринга", ПараметрыЗаписи, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИсправлениеДокументовКлиент.ПослеЗаписи(Объект);
	
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
	
	ДоходыИРасходыСервер.ПослеЗаписиНаСервере(ЭтотОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	ИсправлениеДокументовКлиент.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДоговорЭквайрингаПриИзменении(Элемент)
	
	ПараметрыПроверки = РаботаСТабличнымиЧастямиКлиент.ПараметрыПроверкиЗаполнения();
	ПараметрыПроверки.ТабличнаяЧасть = Объект.Покупки;
	ПараметрыПроверки.ПроверятьРаспроведенность = Ложь;
	Оповещение = Новый ОписаниеОповещения("ДоговорЭквайрингаПриИзмененииЗавершение", ЭтотОбъект);
	РаботаСТабличнымиЧастямиКлиент.ПроверитьВозможностьЗаполнения(ЭтаФорма, Оповещение, ПараметрыПроверки);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорЭквайрингаПриИзмененииЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Объект.Возвраты.Очистить();
	Объект.СуммаПокупок = 0;
	Объект.СуммаВозвратов = 0;
	Объект.СуммаКомиссии = 0;
	Объект.СуммаДокумента = 0;
	
	Если ЗначениеЗаполнено(Объект.ДоговорЭквайринга) Тогда
		ДоговорЭквайрингаПриИзмененииСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДоговорЭквайрингаПриИзмененииСервер()
	
	ЗначенияРеквизитов = Справочники.ДоговорыЭквайринга.РеквизитыДоговора(Объект.ДоговорЭквайринга);
	
	ИспользуютсяЭквайринговыеТерминалы = ЗначенияРеквизитов.ИспользуютсяЭквайринговыеТерминалы;
	ФиксированнаяСтавкаКомиссии = ЗначенияРеквизитов.ФиксированнаяСтавкаКомиссии;
	
	Объект.Организация    = ЗначенияРеквизитов.Организация;
	Объект.Валюта         = ЗначенияРеквизитов.Валюта;
	
	Объект.ДетальнаяСверкаТранзакций = ЗначенияРеквизитов.ДетальнаяСверкаТранзакций;
	Объект.ОтражатьКомиссию = (ЗначенияРеквизитов.СпособОтраженияКомиссии = Перечисления.СпособыОтраженияЭквайринговойКомиссии.ВОтчете);
	
	Если Объект.ОтражатьКомиссию Тогда
		
		Если ЗначенияРеквизитов.ФиксированнаяСтавкаКомиссии Тогда
			СтавкаКомиссии = ЗначенияРеквизитов.СтавкаКомиссии;
		Иначе
			СтавкаКомиссии = 0;
		КонецЕсли;
		
		Объект.СтатьяРасходов    = ЗначенияРеквизитов.СтатьяРасходов;
		Объект.АналитикаРасходов = ЗначенияРеквизитов.АналитикаРасходов;
		Объект.Подразделение     = ЗначенияРеквизитов.ПодразделениеРасходов;
	КонецЕсли;
	
	Если Не Объект.ДетальнаяСверкаТранзакций И Не Объект.ОтражатьКомиссию Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Выбранный договор эквайринга не предусматривает ввод отчетов банка по эквайрингу.';
				|en = 'The selected acquiring agreement does not provide for the input of bank acquiring reports.'"));
	КонецЕсли;
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КомиссияПриИзменении(Элемент)
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	ДоходыИРасходыКлиентСервер.СтатьяПриИзменении(ЭтотОбъект, Элементы.СтатьяРасходов);
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовПриИзменении(Элемент)
	ДоходыИРасходыКлиентСервер.АналитикаРасходовПриИзменении(ЭтотОбъект, Элемент);
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
Процедура СтрокаИсправлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
		
		ИсправлениеДокументовКлиент.СтрокаИсправлениеОбработкаНавигационныйСсылки(
			ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
			
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПокупки

&НаКлиенте
Процедура ПокупкиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупкиПослеУдаления(Элемент)
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВозвраты

&НаКлиенте
Процедура ВозвратыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвратыПослеУдаления(Элемент)
	
	РассчитатьСуммуДокумента();
	
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
Процедура ОткрытьПодборВТабличнуюЧастьВозвраты(Команда)
	
	ПараметрыПроверки = РаботаСТабличнымиЧастямиКлиент.ПараметрыПроверкиЗаполнения();
	ПараметрыПроверки.ПроверяемыеРеквизиты.Вставить("ДоговорЭквайринга", НСтр("ru = 'Договор эквайринга';
																				|en = 'Acquiring agreement'"));
	Оповещение = Новый ОписаниеОповещения("ОткрытьПодборВТабличнуюЧастьВозвратыЗавершение", ЭтотОбъект);
	РаботаСТабличнымиЧастямиКлиент.ПроверитьВозможностьЗаполнения(ЭтаФорма, Оповещение, ПараметрыПроверки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборВТабличнуюЧастьВозвратыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	АдресПлатежейВХранилище = АвтоТест_ПоместитьВозвратыВХранилище();
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("АдресПлатежейВХранилище", АдресПлатежейВХранилище);
	ПараметрыПодбора.Вставить("Организация", Объект.Организация);
	ПараметрыПодбора.Вставить("Валюта", Объект.Валюта);
	ПараметрыПодбора.Вставить("ДоговорЭквайринга", Объект.ДоговорЭквайринга);
	ПараметрыПодбора.Вставить("ИспользуютсяЭквайринговыеТерминалы", ИспользуютсяЭквайринговыеТерминалы);
	
	ОткрытьФорму("Документ.ОтчетБанкаПоОперациямЭквайринга.Форма.ФормаПодбораПлатежей", ПараметрыПодбора, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборВТабличнуюЧастьПокупки(Команда)
	
	ПараметрыПроверки = РаботаСТабличнымиЧастямиКлиент.ПараметрыПроверкиЗаполнения();
	ПараметрыПроверки.ПроверяемыеРеквизиты.Вставить("ДоговорЭквайринга", НСтр("ru = 'Договор эквайринга';
																				|en = 'Acquiring agreement'"));
	Оповещение = Новый ОписаниеОповещения("ОткрытьПодборВТабличнуюЧастьПокупкиЗавершение", ЭтотОбъект);
	РаботаСТабличнымиЧастямиКлиент.ПроверитьВозможностьЗаполнения(ЭтаФорма, Оповещение, ПараметрыПроверки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборВТабличнуюЧастьПокупкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	АдресПлатежейВХранилище = АвтоТест_ПоместитьПокупкиВХранилище();
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("АдресПлатежейВХранилище", АдресПлатежейВХранилище);
	ПараметрыПодбора.Вставить("Организация", Объект.Организация);
	ПараметрыПодбора.Вставить("Валюта", Объект.Валюта);
	ПараметрыПодбора.Вставить("ДоговорЭквайринга", Объект.ДоговорЭквайринга);
	ПараметрыПодбора.Вставить("ИспользуютсяЭквайринговыеТерминалы", ИспользуютсяЭквайринговыеТерминалы);
	ПараметрыПодбора.Вставить("ПодборВходящихПлатежей", Истина);
	
	ОткрытьФорму("Документ.ОтчетБанкаПоОперациямЭквайринга.Форма.ФормаПодбораПлатежей", ПараметрыПодбора, ЭтаФорма);
	
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

#Область ПодборыИОбработкаПроверкиКоличества

// Функция используется в автотесте процесса продаж.
//
// Возвращаемое значение:
//	Строка - строка адреса во временном хранилище, содержащее результат выгрузки табличной части Покупки.
//
&НаСервере
Функция АвтоТест_ПоместитьПокупкиВХранилище() Экспорт 

	АдресПлатежейВХранилище = ПоместитьВоВременноеХранилище(
		Объект.Покупки.Выгрузить(,"ДатаПлатежа, ЭквайринговыйТерминал, КодАвторизации, НомерПлатежнойКарты, Сумма"),
		УникальныйИдентификатор);
		
	Возврат АдресПлатежейВХранилище;
	
КонецФункции

// Функция используется в автотесте процесса продаж.
//
// Возвращаемое значение:
//	Строка - строка адреса во временном хранилище, содержащее результат выгрузки табличной части Возвраты.
//
&НаСервере
Функция АвтоТест_ПоместитьВозвратыВХранилище() Экспорт 

	АдресПлатежейВХранилище = ПоместитьВоВременноеХранилище(
		Объект.Возвраты.Выгрузить(,"ДатаПлатежа, ЭквайринговыйТерминал, КодАвторизации, НомерПлатежнойКарты, Сумма"),
		УникальныйИдентификатор);
	
	Возврат АдресПлатежейВХранилище;
	
КонецФункции

&НаСервере
Процедура ПолучитьПлатежиИзХранилища(ПодборВходящихПлатежей, АдресПлатежейВХранилище)

	Если ПодборВходящихПлатежей Тогда
		Объект.Покупки.Загрузить(ПолучитьИзВременногоХранилища(АдресПлатежейВХранилище));
	Иначе
		Объект.Возвраты.Загрузить(ПолучитьИзВременногоХранилища(АдресПлатежейВХранилище));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ДенежныеСредстваСервер.УправлениеЭлементамиФормыПриЧтенииСозданииНаСервере(ЭтотОбъект);
	
	ИспользоватьНесколькоВалют = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	
	Если ЗначениеЗаполнено(Объект.ДоговорЭквайринга) Тогда
		
		ЗначенияРеквизитов = Справочники.ДоговорыЭквайринга.РеквизитыДоговора(Объект.ДоговорЭквайринга);
		
		ИспользуютсяЭквайринговыеТерминалы = ЗначенияРеквизитов.ИспользуютсяЭквайринговыеТерминалы;
		ФиксированнаяСтавкаКомиссии = ЗначенияРеквизитов.ФиксированнаяСтавкаКомиссии;
		
		Если Объект.ОтражатьКомиссию Тогда
			Если (Объект.СуммаПокупок - Объект.СуммаВозвратов) <> 0 Тогда
				СтавкаКомиссии = ДенежныеСредстваКлиентСервер.РассчитатьСтавкуКомиссии(
					Объект.СуммаПокупок - Объект.СуммаВозвратов, Объект.СуммаКомиссии)
			Иначе
				СтавкаКомиссии = 0;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	СтрокаЗаголовка = СтрШаблон(НСтр("ru = 'Сумма (%1)';
									|en = 'Amount (%1)'"), Строка(Объект.Валюта));
	Элементы.ПокупкиСумма.Заголовок = СтрокаЗаголовка;
	Элементы.ВозвратыСумма.Заголовок = СтрокаЗаголовка;
	
	Элементы.НадписьВалютаКомиссия.Заголовок = Строка(Объект.Валюта);
	
	Если Объект.ДетальнаяСверкаТранзакций Тогда
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	Иначе
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	НастроитьЗависимыеЭлементыФормыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормыНаСервере(ИзмененныйРеквизит = "")
	
	ДенежныеСредстваКлиентСервер.НастроитьЭлементыФормы(ЭтаФорма, ИзмененныйРеквизит, РеквизитыФормы(ЭтаФорма));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РеквизитыФормы(Форма)
	
	РеквизитыФормы = Новый Структура;
	РеквизитыФормы.Вставить("ИспользоватьНесколькоВалют");
	РеквизитыФормы.Вставить("ИспользуютсяЭквайринговыеТерминалы");
	
	ЗаполнитьЗначенияСвойств(РеквизитыФормы, Форма);
	
	Возврат РеквизитыФормы;
	
КонецФункции

&НаКлиенте
Процедура РассчитатьСуммуДокумента()
	
	Объект.СуммаПокупок = Объект.Покупки.Итог("Сумма");
	Объект.СуммаВозвратов = Объект.Возвраты.Итог("Сумма");
	
	Если Объект.ОтражатьКомиссию И СтавкаКомиссии <> 0 Тогда
		
		Если ФиксированнаяСтавкаКомиссии Тогда
				Объект.СуммаКомиссии = (Объект.СуммаПокупок - Объект.СуммаВозвратов) / 100 * СтавкаКомиссии;
		Иначе
		
			Если Объект.СуммаПокупок - Объект.СуммаВозвратов <> 0 Тогда
				СтавкаКомиссии = ДенежныеСредстваКлиентСервер.РассчитатьСтавкуКомиссии(
						Объект.СуммаПокупок - Объект.СуммаВозвратов, Объект.СуммаКомиссии);
			Конецесли;
			
		КонецЕсли;
	
	КонецЕсли;
	
	Если Объект.ДетальнаяСверкаТранзакций Тогда
		Объект.СуммаДокумента = Объект.СуммаПокупок - Объект.СуммаВозвратов - Объект.СуммаКомиссии;
	Иначе
		Объект.СуммаДокумента = Объект.СуммаКомиссии;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
