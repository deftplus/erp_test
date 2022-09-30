#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДоговорыКонтрагентовФормыУХ.ПриСозданииНаСервереВерсииСоглашения(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	ЦветБазовыхЗначений = ЦветаСтиля.ФонУправляющегоПоля;
	УстановитьВалютыВФорме(ЭтотОбъект);
	РежимРедактирования = НЕ Объект.Проведен;
	
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	ДоговорыКонтрагентовФормыУХ.ПриЧтенииНаСервереВерсииСоглашения(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ДоговорыКонтрагентовФормыУХКлиент.ПриОткрытииВерсииСоглашения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	Если ИмяСобытия = "ОбъектСогласован" Тогда
		#Область УниверсальныеПроцессыСогласование
		ОпределитьСостояниеОбъекта();
		#КонецОбласти	
	ИначеЕсли ИмяСобытия = "ОбъектОтклонен" Тогда
		#Область УниверсальныеПроцессыСогласование
		ОпределитьСостояниеОбъекта();
		#КонецОбласти
	ИначеЕсли ИмяСобытия = "МаршрутИнициализирован" Тогда
		#Область УниверсальныеПроцессыСогласование
		ОпределитьСостояниеОбъекта();
		#КонецОбласти		
	ИначеЕсли ИмяСобытия = "СостояниеЗаявкиПриИзменении" Тогда
		#Область УниверсальныеПроцессыСогласование
		ОпределитьСостояниеОбъекта();
		#КонецОбласти		
	ИначеЕсли ИмяСобытия = "Запись_ВерсияФИ" Тогда
		ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);
	КонецЕсли;
	
	ДоговорыКонтрагентовФормыУХКлиент.ОбработкаОповещенияВерсииСоглашения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	ДоговорыКонтрагентовФормыУХКлиент.ОбработкаЗаписиНовогоВерсияСоглашения(ЭтаФорма, НовыйОбъект, Источник, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ДоговорыКонтрагентовФормыУХ.ОбработкаПроверкиЗаполненияНаСервереВерсияСоглашения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ДоговорыКонтрагентовФормыУХКлиент.ПередЗаписьюВерсииСоглашения(ЭтотОбъект, Отказ, ПараметрыЗаписи);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ДоговорыКонтрагентовФормыУХ.ПередЗаписьюНаСервереВерсияСоглашения(ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ДоговорыКонтрагентовФормыУХ.ПриЗаписиНаСервереВерсияСоглашения(ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	
	ДоговорыКонтрагентовФормыУХ.ПослеЗаписиНаСервереВерсияСоглашения(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ДоговорыКонтрагентовФормыУХКлиент.ПослеЗаписиВерсииСоглашения(ЭтотОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НомерПриИзменении(Элемент)
	
	ДоговорыКонтрагентовФормыУХКлиент.ПриИзмененииНомераДоговора(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаДоговораПриИзменении(Элемент)
	ДоговорыКонтрагентовФормыУХКлиент.ПриИзмененииДатыДоговора(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		КонтрагентПриИзмененииНаСервере();
		ДоговорыКонтрагентовФормыУХКлиент.ПриИзмененииКонтрагентаКлиент(ЭтотОбъект, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидСоглашенияПриИзменении(Элемент)
	ДоговорыКонтрагентовФормыУХКлиент.ПриИзмененииВидаСоглашения(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура РуководительКонтрагентаПриИзменении(Элемент)
	ДоговорыКонтрагентовФормыУХКлиент.ПриИзмененииПредставленияРуководителяКонтрагента(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура РуководительКонтрагентаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДоговорыКонтрагентовФормыУХКлиент.НачалоВыбораРуководителяКонтрагента(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ФайлДоговораОткрытие(Элемент, СтандартнаяОбработка)
	ДоговорыКонтрагентовФормыУХКлиент.ОткрытиеФайлДоговора(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ФайлДоговораСоздание(Элемент, СтандартнаяОбработка)
	ДоговорыКонтрагентовФормыУХКлиент.СозданиеФайлаДоговора(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПодписанПриИзменении(Элемент)
	ДоговорыКонтрагентовФормыУХКлиент.ПриИзмененииПодписан(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СуммаПервоначальногоПлатежаВПервойВалютеПриИзменении(Элемент)
	
	Если Объект.ВидСделки = ПредопределенноеЗначение("Перечисление.ВидыВалютныхСвопов.ПродалКупил") Тогда
		
		Объект.СуммаОкончательногоПлатежаВПервойВалюте = Объект.СуммаПервоначальногоПлатежаВПервойВалюте;
		ПересчитатьЗависимыеСуммы(ЭтотОбъект);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПервоначальногоПлатежаВоВторойВалютеПриИзменении(Элемент)
	
	Если Объект.ВидСделки = ПредопределенноеЗначение("Перечисление.ВидыВалютныхСвопов.КупилПродал") Тогда
		Объект.СуммаОкончательногоПлатежаВоВторойВалюте = Объект.СуммаПервоначальногоПлатежаВоВторойВалюте;
		ПересчитатьЗависимыеСуммы(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СуммаОкончательногоПлатежаВоВторойВалютеПриИзменении(Элемент)
	
	Если Объект.ВидСделки = ПредопределенноеЗначение("Перечисление.ВидыВалютныхСвопов.КупилПродал") Тогда
		Объект.СуммаПервоначальногоПлатежаВоВторойВалюте = Объект.СуммаОкончательногоПлатежаВоВторойВалюте;
		ПересчитатьЗависимыеСуммы(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СуммаОкончательногоПлатежаВПервойВалютеПриИзменении(Элемент)
	Если Объект.ВидСделки = ПредопределенноеЗначение("Перечисление.ВидыВалютныхСвопов.ПродалКупил") Тогда
		Объект.СуммаПервоначальногоПлатежаВПервойВалюте = Объект.СуммаОкончательногоПлатежаВПервойВалюте;
		ПересчитатьЗависимыеСуммы(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВидСделкиПриИзменении(Элемент)
	УстановитьВалютыВФорме(ЭтотОбъект);
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПерваяВалютаПриИзменении(Элемент)
	УстановитьВалютыВФорме(ЭтотОбъект);
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВтораяВалютаПриИзменении(Элемент)
	УстановитьВалютыВФорме(ЭтотОбъект);
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СостояниеДоговораПриИзменении(Элемент)
	ДоговорыКонтрагентовФормыУХКлиент.ПриИзмененииСостоянияДоговора(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыУчетаФИПриИзменении(Элемент)
	ДоговорыКонтрагентовФормыУХКлиентСервер.ПриИзмененииПараметрыУчетаФИ(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ТекстПроизводственныеКалендариНажатие(Элемент, СтандартнаяОбработка)
	
	ДоговорыКонтрагентовФормыУХКлиент.ИзменитьПроизводственныеКалендари(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	СтарыйКонтрагент = Объект.Контрагент;
	
	ПартнерПриИзмененииНаСервере();
	
	Если ЗначениеЗаполнено(Объект.Контрагент) И Объект.Контрагент <> СтарыйКонтрагент Тогда
		ДоговорыКонтрагентовФормыУХКлиент.ПриИзмененииКонтрагентаКлиент(ЭтотОбъект, Элемент);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РежимИспользованияГрафикаПриИзменении(Элемент)
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);
	ВыполнитьКонтрольДокумента();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьСклоненияРуководительКонтрагента(Команда)
	
	ДоговорыКонтрагентовФормыУХКлиент.ПоказатьСклоненияРуководительКонтрагента(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСклоненияДолжностьРуководителяКонтрагента(Команда)
	
	ДоговорыКонтрагентовФормыУХКлиент.ПоказатьСклоненияДолжностьРуководителяКонтрагента(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСклоненияРуководитель(Команда)
	
	ДоговорыКонтрагентовФормыУХКлиент.ПоказатьСклоненияРуководитель(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСклоненияДолжностьРуководителя(Команда)
	
	ДоговорыКонтрагентовФормыУХКлиент.ПоказатьСклоненияДолжностьРуководителя(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьВерсию(Команда)
	
	РежимРедактирования = НЕ РежимРедактирования;
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);
	
КонецПроцедуры

#Область КонтрольДокумента

&НаКлиенте
Процедура ВыполнитьКомандуУХ(Команда)
	
	Если Команда.Имя = "ВыполнитьКонтрольДокумента" Тогда
		ВыполнитьКонтрольДокументаНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтрольДокумента()
	ВыполнитьКонтрольДокументаНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьКонтрольДокумента()
	ПодключитьОбработчикОжидания("Подключаемый_КонтрольДокумента", 0.1, Истина);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКонтрольДокументаНаСервере()
	КонтрольУХ.ВыполнитьИнтерактивныйКонтроль(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ТаблицаКонтроляДокументаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТД =  Элемент.ТекущиеДанные;
	Если ТД = неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	КонтрольУХКлиент.ПоказатьРасшифровкуКонтроля(Объект, ТД);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ТаблицаКонтроляДокументаПриАктивизацииЯчейки(Элемент)
	Элемент.ТекущаяСтрока = неопределено;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВалютыВФорме(Форма)
	
	Объект = Форма.Объект;
	
	Если Объект.ВидСделки = ПредопределенноеЗначение("Перечисление.ВидыВалютныхСвопов.КупилПродал") Тогда
		
		Форма.БазоваяВалюта =  Объект.ВтораяВалюта;
		Форма.ВалютаРасчетов = Объект.ПерваяВалюта;
		
	Иначе
		
		Форма.БазоваяВалюта =  Объект.ПерваяВалюта;
		Форма.ВалютаРасчетов = Объект.ВтораяВалюта;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПересчитатьЗависимыеСуммы(Форма)
	
	Объект = Форма.Объект;
	
	Если Объект.КратностьПервоначальногоПлатежа = 0 ИЛИ Объект.КратностьОкончательногоПлатежа = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Невозможно пересчитать сумму в валюте, т.к. курс валют не задан.'"));
		Возврат;
	КонецЕсли;
	
	Если Объект.ВидСделки = ПредопределенноеЗначение("Перечисление.ВидыВалютныхСвопов.КупилПродал") Тогда
		
		Объект.СуммаПервоначальногоПлатежаВПервойВалюте =  Объект.СуммаПервоначальногоПлатежаВоВторойВалюте * Объект.КурсПервоначальногоПлатежа / Объект.КратностьПервоначальногоПлатежа;
		Объект.СуммаОкончательногоПлатежаВПервойВалюте =  Объект.СуммаОкончательногоПлатежаВоВторойВалюте * Объект.КурсОкончательногоПлатежа / Объект.КратностьОкончательногоПлатежа;
		
	Иначе
		
		Объект.СуммаПервоначальногоПлатежаВоВторойВалюте =  Объект.СуммаПервоначальногоПлатежаВПервойВалюте * Объект.КурсПервоначальногоПлатежа / Объект.КратностьПервоначальногоПлатежа;
		Объект.СуммаОкончательногоПлатежаВоВторойВалюте =  Объект.СуммаОкончательногоПлатежаВПервойВалюте * Объект.КурсОкончательногоПлатежа / Объект.КратностьОкончательногоПлатежа;

		
	КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура КурсПервоначальногоПлатежаПриИзменении(Элемент)
	ПересчитатьЗависимыеСуммы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура КратностьПервоначальногоПлатежаПриИзменении(Элемент)
	ПересчитатьЗависимыеСуммы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура КурсОкончательногоПлатежаПриИзменении(Элемент)
	ПересчитатьЗависимыеСуммы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура КратностьОкончательногоПлатежаПриИзменении(Элемент)
	ПересчитатьЗависимыеСуммы(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("ДоговорОбъект"));

КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ДоговорыКонтрагентовФормыУХ.ПриИзмененииОрганизацииСервер(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере()
	ДоговорыКонтрагентовФормыУХ.ПриИзмененииКонтрагентаСервер(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, ДоговорОбъект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, ДоговорОбъект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, ДоговорОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
   УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект, ДоговорОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
   УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект, ДоговорОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область УниверсальныеПроцессыСогласование

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСогласования(Команда)
	
	ДоговорыКонтрагентовФормыУХКлиент.Подключаемый_ВыполнитьКомандуСогласования(ЭтотОбъект, Команда)
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтатусОбъектаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	Если ВыбранноеЗначение = РеквизитСостояниеЗаявки(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;

	Если (Объект.Ссылка.Пустая()) ИЛИ (ЭтаФорма.Модифицированность) Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("СостояниеЗаявкиОбработкаВыбораПродолжение", ЭтотОбъект, Новый Структура("ВыбранноеЗначение", ВыбранноеЗначение));
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
			|Изменение состояния возможно только после записи данных.
			|Данные будут записаны.'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
		Возврат;
	КонецЕсли;
	
	ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение); 

КонецПроцедуры


&НаСервере
Процедура ОпределитьСостояниеОбъекта(ОбновитьОтветственныхВход = Ложь)
	ДействияСогласованиеУХСервер.ОпределитьСостояниеЗаявки(ЭтаФорма, ОбновитьОтветственныхВход);
КонецПроцедуры	

&НаКлиенте
Процедура СостояниеЗаявкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	Если ВыбранноеЗначение = РеквизитСостояниеЗаявки(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;

	Если Объект.Ссылка.Пустая() Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("СостояниеЗаявкиОбработкаВыбораПродолжение", ЭтотОбъект, Новый Структура("ВыбранноеЗначение", ВыбранноеЗначение));
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
			|Изменение состояния возможно только после записи данных.
			|Данные будут записаны.'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
		Возврат;
	КонецЕсли;
	
	ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение); 
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение)
	ДействияСогласованиеУХКлиент.ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СостояниеЗаявкиОбработкаВыбораПродолжение(Результат, Параметры) Экспорт
 
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Записать();
		ИзменитьСостояниеЗаявкиКлиент(Параметры.ВыбранноеЗначение);
	КонецЕсли;
 
КонецПроцедуры

&НаСервере
Функция ИзменитьСостояниеЗаявки(Ссылка, Состояние)
	
	Возврат УправлениеПроцессамиСогласованияУХ.ПеревестиЗаявкуВПроизвольноеСостояние(Ссылка, Состояние, , , ЭтаФорма);
	
КонецФункции

// Возвращает значение реквизита СостояниеЗаявки на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСостояниеЗаявки(ФормаВход)
	Возврат ФормаВход["СостояниеЗаявки"];
КонецФункции

// Возвращает значение реквизита СтатусОбъекта на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСтатусОбъекта(ФормаВход)
	Возврат ФормаВход["СтатусОбъекта"];
КонецФункции

// Возвращает значение реквизита Согласующий на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСогласующий(ФормаВход)
	Возврат ФормаВход["Согласующий"];
КонецФункции

&НаСервере
Процедура ПартнерПриИзмененииНаСервере()
	
	ОплатаВВалюте = Истина;
	ПартнерПриИзмененииСервер(Объект.Партнер, 
								Объект.Контрагент, 
								ОплатаВВалюте);
								
	Если ЗначениеЗаполнено(Объект.Контрагент) И Объект.Контрагент <> СтарыйКонтрагент Тогда
		
		КонтрагентПриИзмененииНаСервере();
		
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПартнерПриИзмененииСервер(Партнер, Контрагент, ОплатаВВалюте)
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
КонецПроцедуры


// Выполняет обработчик ПриИзменении, сопоставленный по умолчанию для элемента Элемент
&НаКлиенте
Процедура ВыполнитьПредыдущийОбработчикПриИзмененииОрганизации(Элемент)
	#Если НЕ ВебКлиент Тогда
	ИмяЭлемента = Элемент.Имя;
	Если ЗначениеЗаполнено(ИмяЭлемента) Тогда
		Для Каждого ТекОбработчикиИзмененияОрганизации Из ЭтаФорма["ОбработчикиИзмененияОрганизации"] Цикл
			Если СокрЛП(ТекОбработчикиИзмененияОрганизации.ИмяРеквизита) = СокрЛП(ИмяЭлемента) Тогда
				СтрокаВыполнения = ТекОбработчикиИзмененияОрганизации.ИмяОбработчика + "(Элемент);";
				Выполнить СтрокаВыполнения;
			Иначе
				// Выполняем поиск далее.
			КонецЕсли; 
		КонецЦикла;	
	Иначе
		// Передан пустой элемент.
	КонецЕсли;
	#КонецЕсли
КонецПроцедуры		// ВыполнитьПредыдущийОбработчикПриИзмененииОрганизации()

&НаКлиенте
Процедура ДокументОбъектОсновнойЦФОПриИзменении(Элемент)
	#Если ВебКлиент Тогда
	ОпределитьСостояниеОбъекта(Истина);	
	#КонецЕсли
КонецПроцедуры


&НаКлиенте
Процедура ПриИзмененииЭлементаОрганизации_Подключаемый(Элемент) Экспорт
	ОпределитьСостояниеОбъекта(Истина);		
	ВыполнитьПредыдущийОбработчикПриИзмененииОрганизации(Элемент);
КонецПроцедуры		// ПриИзмененииЭлементаОрганизации_Подключаемый()


#КонецОбласти

#Область ПараметрыОперацийГрафика
&НаКлиенте
Процедура НастроитьПараметрыОпераций(Команда)
	
	ПараметрыКоманды = ДанныеОткрытияПараметровОперацийГрафика();			
	ДоговорыКонтрагентовФормыУХКлиент.ОткрытьПараметрыОперацийГрафика(ЭтотОбъект, ПараметрыКоманды);	
	
КонецПроцедуры

&НаСервере
Функция ДанныеОткрытияПараметровОперацийГрафика()	
	Возврат ДоговорыКонтрагентовФормыУХ.ДанныеОткрытияПараметровОперацийГрафика(ЭтотОбъект);	
КонецФункции

&НаКлиенте
Процедура ЗавершитьНастройкуОпераций(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		ЗагрузитьНастройкиОпераций(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиОпераций(Адрес)	
	ДоговорыКонтрагентовФормыУХ.ЗагрузитьПараметрыОперацийГрафика(ЭтотОбъект, Адрес);
КонецПроцедуры
#КонецОбласти
