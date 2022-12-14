#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДоговорыКонтрагентовФормыУХ.ПриСозданииНаСервереВерсииСоглашения(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	ЦветБазовыхЗначений = ЦветаСтиля.ФонУправляющегоПоля;
	РежимРедактирования = НЕ Объект.Проведен;

	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);
	
	Если Параметры.Ключ.Пустая() Тогда
		ПриЧтенииСозданииНаСервере();
	Иначе
		// Не новый объект.
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

	ДоговорыКонтрагентовФормыУХ.ПриЧтенииНаСервереВерсииСоглашения(ЭтотОбъект, ТекущийОбъект);
	ПриЧтенииСозданииНаСервере();

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
	
	ПересчитатьСуммуВВалютеРасчетов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПервоначальногоПлатежаВоВторойВалютеПриИзменении(Элемент)
	
	Если Объект.СуммаВБазовойВалюте <> 0 Тогда
	
		Объект.ФорвардныйКурс = Объект.СуммаВВалютеРасчетов / Объект.СуммаВБазовойВалюте * Объект.КратностьПлатежа;
		
		ПересчитатьФинансовыйРезультат(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ВидСделкиПриИзменении(Элемент)
	ПересчитатьФинансовыйРезультат(ЭтотОбъект);
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПерваяВалютаПриИзменении(Элемент)
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВтораяВалютаПриИзменении(Элемент)
	Если Объект.ВидДоговораУХ = ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.ПоставочныйВалютныйФорвард") Тогда
		Объект.ВалютаПлатежа = Объект.ВалютаРасчетов;
	КонецЕсли;
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
Процедура КурсПервоначальногоПлатежаПриИзменении(Элемент)
	ПересчитатьСуммуВВалютеРасчетов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура КратностьПервоначальногоПлатежаПриИзменении(Элемент)
	ПересчитатьСуммуВВалютеРасчетов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура КурсСпотПриИзменении(Элемент)
	ПересчитатьФинансовыйРезультат(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПлатежаПриИзменении(Элемент)
	ПересчитатьФинансовыйРезультат(ЭтотОбъект);
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);
КонецПроцедуры


&НаКлиенте
Процедура КурсВалютыПлатежаПриИзменении(Элемент)
	ПересчитатьФинансовыйРезультат(ЭтотОбъект);
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
Процедура ПересчитатьСуммуВВалютеРасчетов(Форма)
	
	Объект = Форма.Объект;
	
	Если Объект.КратностьПлатежа = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Невозможно пересчитать сумму в валюте, т.к. курс валют не задан.'"));
		Возврат;
	КонецЕсли;
	
	Объект.СуммаВВалютеРасчетов =  Объект.СуммаВБазовойВалюте * Объект.ФорвардныйКурс / Объект.КратностьПлатежа;
	
	ПересчитатьФинансовыйРезультат(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПересчитатьФинансовыйРезультат(Форма)

	Объект = Форма.Объект;
	Если Объект.ВидДоговораУХ = ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.ПоставочныйВалютныйФорвард")
		ИЛИ (Объект.ВидДоговораУХ = ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.РасчетныйВалютныйФорвард")
			И Объект.ВалютаПлатежа = Объект.ВалютаРасчетов) Тогда
	
		Объект.ЭквивалентБазовойСуммы = Объект.СуммаВБазовойВалюте * Объект.КурсСпот / Объект.КратностьПлатежа;
		
		Объект.ФинансовыйРезультат = Объект.ЭквивалентБазовойСуммы - Объект.СуммаВВалютеРасчетов;
		
	ИначеЕсли Объект.КурсСпот = 0 Тогда
		
		// Считать еще рано.
		Объект.ФинансовыйРезультат = 0;
		
	Иначе
		
		СуммаПлатежаВБазовойВалюте = Объект.СуммаВБазовойВалюте * (1 - Объект.ФорвардныйКурс / Объект.КурсСпот);
		
		Если Объект.ВалютаПлатежа = Объект.БазоваяВалюта Тогда
			Объект.ФинансовыйРезультат = СуммаПлатежаВБазовойВалюте;
		Иначе
			Объект.ФинансовыйРезультат = СуммаПлатежаВБазовойВалюте * Объект.КурсСпотВалютыПлатежа / Объект.КратностьПлатежа;
		КонецЕсли;
		
	КонецЕсли;

	
	Если Объект.ВидСделки = ПредопределенноеЗначение("Перечисление.ВидыВалютныхФорвардов.ПродажаВалюты") Тогда
		
		Объект.ФинансовыйРезультат = -Объект.ФинансовыйРезультат;
		
	КонецЕсли;
	
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

&НаСервереБезКонтекста
Процедура ЗаполнитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент, ОплатаВВалюте, БанковскийСчетКонтрагента)
	
	Если (ЗначениеЗаполнено(БанковскийСчетКонтрагента)
		И Контрагент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БанковскийСчетКонтрагента,"Владелец"))
		ИЛИ НЕ ЗначениеЗаполнено(Контрагент) Тогда
		Возврат;
	КонецЕсли;
		
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 2
	|	БанковскиеСчетаКонтрагентов.Ссылка КАК БанковскийСчетКонтрагента
	|ИЗ
	|	Справочник.БанковскиеСчетаКонтрагентов КАК БанковскиеСчетаКонтрагентов
	|ГДЕ
	|	БанковскиеСчетаКонтрагентов.Владелец = &Контрагент
	|	И ((БанковскиеСчетаКонтрагентов.ВалютаДенежныхСредств = &ВалютаРегл И НЕ &ОплатаВВалюте)
	|	ИЛИ (БанковскиеСчетаКонтрагентов.ВалютаДенежныхСредств <> &ВалютаРегл И &ОплатаВВалюте))
	|	И НЕ БанковскиеСчетаКонтрагентов.ПометкаУдаления
	|");
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("ОплатаВВалюте", ОплатаВВалюте);
	Запрос.УстановитьПараметр("ВалютаРегл", Константы.ВалютаРегламентированногоУчета.Получить());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 И Выборка.Следующий() Тогда
		БанковскийСчетКонтрагента = Выборка.БанковскийСчетКонтрагента;
	Иначе
		БанковскийСчетКонтрагента = Справочники.БанковскиеСчетаКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПартнерПриИзмененииСервер(Партнер, Контрагент, ОплатаВВалюте, БанковскийСчетКонтрагента)
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	ЗаполнитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент, ОплатаВВалюте, БанковскийСчетКонтрагента);
	
КонецПроцедуры

&НаСервере
Процедура ПартнерПриИзмененииНаСервере()
	
	ОплатаВВалюте = Истина;
	ПартнерПриИзмененииСервер(Объект.Партнер, 
								Объект.Контрагент, 
								ОплатаВВалюте, 
								Объект.СчетКонтрагентаВБазовойВалюте);
								
	Если ЗначениеЗаполнено(Объект.Контрагент) И Объект.Контрагент <> СтарыйКонтрагент Тогда
		
		КонтрагентПриИзмененииНаСервере();
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыВыбораПартнера()
	
	МассивПараметровВыбораПартнера = Новый Массив;
	
	ОперацииЗакупки = ЗакупкиСервер.ХозяйственныеОперацииПоОсновной(Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика);
	ОперацииИмпорта = ЗакупкиСервер.ХозяйственныеОперацииПоОсновной(Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту);
	ОперацииВСтранахЕАЭС = ЗакупкиСервер.ХозяйственныеОперацииПоОсновной(Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС);
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиенту
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПроизводствоИзДавальческогоСырья
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию Тогда
		
		МассивПараметровВыбораПартнера.Добавить(Новый ПараметрВыбора("Отбор.Клиент", Истина));
		
	ИначеЕсли ОперацииЗакупки.Найти(Объект.ХозяйственнаяОперация) <> Неопределено
		Или ОперацииИмпорта.Найти(Объект.ХозяйственнаяОперация) <> Неопределено
		Или ОперацииВСтранахЕАЭС.Найти(Объект.ХозяйственнаяОперация) <> Неопределено
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссию
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаХранениеСПравомПродажи Тогда
		
		МассивПараметровВыбораПартнера.Добавить(Новый ПараметрВыбора("Отбор.Поставщик", Истина));
		
	КонецЕсли;
	
	Элементы.Партнер.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбораПартнера);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокФормы()

	ПартнерыИКонтрагенты.ЗаголовокЭлементаПартнерВЗависимостиОтХозяйственнойОперации(
		ЭтотОбъект, "Партнер", Объект.ХозяйственнаяОперация);
	ПартнерыИКонтрагенты.ЗаголовокЭлементаСчетКонтрагентаВЗависимостиОтХозяйственнойОперации(
		ЭтотОбъект, "БанковскийСчетКонтрагента", Объект.ХозяйственнаяОперация);
		
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	ЗаполнитьПараметрыВыбораПартнера();
	ОбновитьЗаголовокФормы();
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