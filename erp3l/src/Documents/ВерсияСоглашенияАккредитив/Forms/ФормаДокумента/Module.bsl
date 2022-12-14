
#Область ПеременныеФормы
&НаКлиенте
Перем ИсходнаяДатаСтроки;
#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДоговорыКонтрагентовФормыУХ.ПриСозданииНаСервереВерсииСоглашения(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	ФинансовыеИнструментыФормы.ПриСозданииНаСервереФормыГрафика(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	РежимРедактирования = НЕ Объект.Проведен;
	
	ИнициализироватьИнструмент();
	
	ФинансовыеИнструментыФормыКлиентСервер.УстановитьОтборСтрокГрафика(ЭтотОбъект);	
	
	УстановитьУсловноеОформление();
	
	БюджетДвиженияДенежныхСредствИспользуется = ПолучитьФункциональнуюОпцию("БюджетДвиженияДенежныхСредствИспользуется");
	БюджетДоходовРасходовИспользуется = ПолучитьФункциональнуюОпцию("БюджетДоходовРасходовИспользуется");
	БюджетЗакупокИспользуется = ПолучитьФункциональнуюОпцию("БюджетЗакупокИспользуется");
	
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);
	
	Если Параметры.Ключ.Пустая() Тогда
		ПриЧтенииСозданииНаСервере();
	Иначе
		// Не новый объект.
	КонецЕсли;
	ОбновитьГрафикНаСервере();	
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
		ИнициализироватьИнструмент();
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

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ДоговорыКонтрагентовФормыУХКлиент.ПослеЗаписиВерсииСоглашения(ЭтотОбъект, ПараметрыЗаписи);
	
	ФинансовыеИнструментыФормыКлиент.ПослеЗаписиВерсииСоглашения(ЭтотОбъект, ПараметрыЗаписи);

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
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		РежимРедактирования = Ложь;
	КонецЕсли;
	ИнициализироватьИнструмент();
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);

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
Процедура ВалютаВзаиморасчетовПриИзменении(Элемент)
	ДоговорыКонтрагентовФормыУХКлиент.ПриИзмененииВалютыВзаиморасчетов(ЭтотОбъект, Элемент);
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
Процедура ФиксированныйСчетОрганизацииПриИзменении(Элемент)
	ДоговорыКонтрагентовФормыУХКлиент.ПриИзмененииФиксированныйСчетОрганизации(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ФиксированныйСчетКонтрагентаПриИзменении(Элемент)
	ДоговорыКонтрагентовФормыУХКлиент.ПриИзмененииФиксированныйСчетКонтрагента(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПодписанПриИзменении(Элемент)
	ДоговорыКонтрагентовФормыУХКлиент.ПриИзмененииПодписан(ЭтотОбъект, Элемент);
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
Процедура ДатаОтсчетаПроцентныхПериодовПриИзменении(Элемент)
	
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаКредитаПриИзменении(Элемент)
	ЗаполнитьВыборкуПогашение();
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаДействияПриИзменении(Элемент)
	ЗаполнитьВыборкуПогашение();
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияДействияПриИзменении(Элемент)
	ЗаполнитьВыборкуПогашение();
КонецПроцедуры

&НаКлиенте
Процедура ВыплачиватьПроцентыПериодическиПриИзменении(Элемент)
	
	Если Объект.АвтоматическиеВычисления Тогда
		РассчитатьСуммыПроцентовНаСервере();
		ВыполнитьКонтрольДокумента();
	КонецЕсли;
	
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВыплачиватьПроцентыВДатыПогашенияТелаПриИзменении(Элемент)
	
	Если Объект.АвтоматическиеВычисления Тогда
		РассчитатьСуммыПроцентовНаСервере();
		ВыполнитьКонтрольДокумента();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПериодичностьУплатыПроцентовПриИзменении(Элемент)
	
	Если Объект.АвтоматическиеВычисления Тогда
		РассчитатьСуммыПроцентовНаСервере();
		ВыполнитьКонтрольДокумента();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПервогоПроцентногоПериодаПриИзменении(Элемент)
	
	Если Объект.АвтоматическиеВычисления Тогда
		РассчитатьСуммыПроцентовНаСервере();
		ВыполнитьКонтрольДокумента();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СдвигДатыУплатыПроцентовПриИзменении(Элемент)
	
	Если Объект.АвтоматическиеВычисления Тогда
		РассчитатьСуммыПроцентовНаСервере();
		ВыполнитьКонтрольДокумента();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТочкаОтсчетаСдвигаДатыУплатыПриИзменении(Элемент)
	
	Если Объект.АвтоматическиеВычисления Тогда
		РассчитатьСуммыПроцентовНаСервере();
		ВыполнитьКонтрольДокумента();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПроцентнаяСтавкаПриИзменении(Элемент)
	
	Если Объект.АвтоматическиеВычисления Тогда
		РассчитатьСуммыПроцентовНаСервере();
		ВыполнитьКонтрольДокумента();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура БазаДляРасчетаПроцентовПриИзменении(Элемент)
	
	Если Объект.АвтоматическиеВычисления Тогда
		РассчитатьСуммыПроцентовНаСервере();
		ВыполнитьКонтрольДокумента();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПереносДатСНерабочихДнейПриИзменении(Элемент)
	
	Если Объект.АвтоматическиеВычисления Тогда
		РассчитатьСуммыПроцентовНаСервере();
		ВыполнитьКонтрольДокумента();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИзменяетсяДлительностьПроцентногоПериодаПриПереносеПриИзменении(Элемент)
	
	Если Объект.АвтоматическиеВычисления Тогда
		РассчитатьСуммыПроцентовНаСервере();
		ВыполнитьКонтрольДокумента();
	КонецЕсли;

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

#Область ОбработчикиСобытийЭлементовТаблицыФормыГрафикРасчетов

&НаКлиенте
Процедура ГрафикРасчетовПриАктивизацииЯчейки(Элемент)
	
	Если Элемент.ТекущийЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
			
	Элементы.ГрафикРасчетовКонтекстноеМенюРасшифроватьСуммуГрафика.Доступность = 
		(Элемент.ТекущийЭлемент = Элементы.ГрафикРасчетовКомиссииЗаОткрытиеНачислено 
		ИЛИ Элемент.ТекущийЭлемент = Элементы.ГрафикРасчетовКомиссииЗаОткрытиеУплачено);
		
	ИмяЭлемента = Элемент.ТекущийЭлемент.Имя;
	Элементы.ГрафикРасчетовКонтекстноеМенюОткрытьИсториюИзмененияЗначения.Доступность =
		ДоговорыКонтрагентовФормыУХКлиент.ДоступностьПоказатьИсториюИзмененияЗначения(ИмяЭлемента, ОписаниеГрафика);
	
	ДоговорыКонтрагентовФормыУХКлиент.ПриАктивизацииЯчейкиГрафикаРасчетов(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикРасчетовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	ДоговорыКонтрагентовФормыУХКлиент.ПередНачаломДобавленияСтрокиГрафикаРасчетов(ЭтотОбъект, Элемент, Отказ, Копирование, Родитель, Группа, Параметр);
КонецПроцедуры

&НаКлиенте
Процедура ГрафикРасчетовПередНачаломИзменения(Элемент, Отказ)
	ДоговорыКонтрагентовФормыУХКлиент.ПередНачаломИзмененияСтрокиГрафикаРасчетов(ЭтотОбъект, Элемент, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ГрафикРасчетовПередУдалением(Элемент, Отказ)
	ДоговорыКонтрагентовФормыУХКлиент.ПередНачаломУдаленияСтрокиГрафикаРасчетов(ЭтотОбъект, Элемент, Отказ);
	ОбновитьГрафикНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыГрафикЛинейный

&НаКлиенте
Процедура ГрафикРасчетовЛинейныйПередУдалением(Элемент, Отказ)	
	ДоговорыКонтрагентовФормыУХКлиент.ПередУдалениемСтрокиГрафика(ЭтотОбъект, Элемент, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ГрафикРасчетовЛинейныйПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ДоговорыКонтрагентовФормыУХКлиент.ПриНачалеРедактированияСтрокиГрафика(ЭтотОбъект, НоваяСтрока, Копирование, ИсходнаяДатаСтроки);
КонецПроцедуры

&НаКлиенте
Процедура ГрафикРасчетовЛинейныйПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ПодключитьОбработчикОжидания("ПриОкончанииРедактированияДетализацииГрафика", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПриОкончанииРедактированияДетализацииГрафика()
	ОбновитьГрафикНаСервере();
	ВыполнитьКонтрольДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ГрафикРасчетовЛинейныйПередНачаломИзменения(Элемент, Отказ)
	АналитикиСтатейБюджетовУХКлиент.ПередНачаломИзмененияСтрокиТаблицыФормы(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ГрафикРасчетовЛинейныйПриАктивизацииСтроки(Элемент)
	АналитикиСтатейБюджетовУХКлиент.ПриАктивизацииСтрокиТаблицыФормы(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ГрафикРасчетовЛинейныйПослеУдаления(Элемент)
	ОбновитьГрафикНаСервере();
	ВыполнитьКонтрольДокумента();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ГрафикРасчетовЛинейныйДатаПриИзменении(Элемент)	
	ДоговорыКонтрагентовФормыУХКлиент.ПриИзмененииДатыСтрокиГрафика(ЭтотОбъект, Элемент, ИсходнаяДатаСтроки);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ГрафикРасчетовЛинейныйСуммаПриИзменении(Элемент)
	ДоговорыКонтрагентовФормыУХКлиент.ПриИзмененииСуммыСтрокиГрафика(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ГрафикРасчетовЛинейныйСуммаКорректировкаПриИзменении(Элемент)
	ДоговорыКонтрагентовФормыУХКлиент.ПриИзмененииСуммыКорректировкиСтрокиГрафика(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ГрафикРасчетовЛинейныйОперацияГрафикаПриИзменении(Элемент)
	ДоговорыКонтрагентовФормыУХКлиент.ПриИзмененииОперацииСтрокиГрафика(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтатьяБюджета_ПриИзменении(Элемент)
	АналитикиСтатейБюджетовУХКлиент.ПриИзмененииСтатьиБюджета(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АналитикаСтатьиБюджета_ПриИзменении(Элемент)
	АналитикиСтатейБюджетовУХКлиент.ПриИзмененииАналитикиСтатьиБюджета(ЭтотОбъект, Элемент.Имя);
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

&НаКлиенте
Процедура ОбновитьФактическиеДанные(Команда)
	ОбновитьФактическиеДанныеНаСервере();
	ВыполнитьКонтрольДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ВычисленияАвтоматически(Команда)
	
	Объект.АвтоматическиеВычисления = Истина;
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВычисленияВручную(Команда)
	
	Объект.АвтоматическиеВычисления = Ложь;
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);

	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсториюИзмененияЗначения(Команда)
	
	ФинансовыеИнструментыФормыКлиент.ПоказатьИсториюИзмененияЗначения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьПоправкиВДетализацииГрафика(Команда)
	
	ОтображатьПоправки = Не Элементы.ГрафикРасчетовЛинейныйОтображатьПоправкиВДетализацииГрафика.Пометка;
	
	Элементы.ГрафикРасчетовЛинейныйОтображатьПоправкиВДетализацииГрафика.Пометка = ОтображатьПоправки;
	
	Элементы.ГрафикРасчетовЛинейныйСуммаРасчет.Видимость = ОтображатьПоправки;
	Элементы.ГрафикРасчетовЛинейныйСуммаКорректировка.Видимость = ОтображатьПоправки;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьДатуЗагрузкиФакта(Команда)
	Объект.ГраницаФактическихДанных = Дата(1,1,1);
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДетализацию(Команда)
	ДоговорыКонтрагентовФормыУХКлиентСервер.УстановитьВидимостьДетализации(ЭтотОбъект);
КонецПроцедуры   

&НаКлиенте
Процедура ПоказатьФактВГрафике(Команда)
	ДоговорыКонтрагентовФормыУХКлиентСервер.УстановитьВидимостьКолонокФакта(ЭтотОбъект);
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

&НаСервере
Процедура ЗаполнитьГрафикНаСервере()
	
	ФинансовыеИнструментыУХ.ОбновитьКолонкиЗадолженности(Объект.График, ОписаниеГрафика);
	ФинансовыеИнструментыФормыКлиентСервер.ОбновитьИтоги(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммыПроцентов(Команда)
	РассчитатьСуммыПроцентовНаСервере();
	ВыполнитьКонтрольДокумента();
КонецПроцедуры

&НаСервере
Процедура РассчитатьСуммыПроцентовНаСервере()
	
	СтруктураДействий = Новый Структура;
	Секции = Новый Массив;
	Если Не ФинансовыеИнструментыУХ.СтрокиСекцииГрафика(Объект.ГрафикРасчетов, ОписаниеГрафика["ОсновнойДолг"]).Количество() Тогда
		Секции.Добавить("ОсновнойДолг");
	КонецЕсли;
	Секции.Добавить("КомиссииЗаОткрытие");
	СтруктураДействий.Вставить("Пересчитать", Новый Структура("СекцииГрафика", Секции));
	ФинансовыеИнструментыУХ.ПересчетГрафика(Объект, 0, ОписаниеГрафика, ОперацииГрафика, СтруктураДействий);	
	
	АналитикиСтатейБюджетовУХ.ЗаполнитьРеквизитыАналитикВсехСтатей(ЭтотОбъект);
	ОбновитьГрафикНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВыборкуПогашение()
	
	Если ЗначениеЗаполнено(Объект.ДатаНачалаДействия) И ЗначениеЗаполнено(Объект.ДатаОкончанияДействия) Тогда
		
		ФинансовыеИнструментыУХ.ОбновитьОсновнойДолгПоДаннымОбъекта(Объект, ОписаниеГрафика,,,ОперацииГрафика);

		Если Объект.АвтоматическиеВычисления Тогда
			РассчитатьСуммыПроцентовНаСервере();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьНачисления(Команда)
	Элементы.ГрафикОтображатьНачисления.Пометка = НЕ Элементы.ГрафикОтображатьНачисления.Пометка;
	ДоговорыКонтрагентовФормыУХКлиентСервер.УправлениеФормойВерсияСоглашения(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура РасшифроватьСуммуГрафика(Команда)
	
	ФинансовыеИнструментыФормыКлиент.РасшифроватьСуммуГрафика(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьФактическиеДанныеНаСервере()
	СтруктураДействий = Новый Структура("ЗагружатьФакт");
	ОбновитьГрафикНаСервере(СтруктураДействий);
	ФинансовыеИнструментыФормыКлиентСервер.УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьИнструмент()
	
	// Инициализируем описание для общих методов.
	КолонкиРасчет = ФинансовыеИнструментыФормы.РасчетныеКолонки(ОписаниеГрафика);
	ДоговорыКонтрагентовФормыУХ.ИнициализироватьПереченьОперацийГрафика(ЭтотОбъект);
	АктуальнаяВерсия = РегистрыСведений.ВерсииРасчетов.ПолучитьАктуальнуюВерсиюФинансовогоИнструмента(Объект.ДоговорКонтрагента);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	//УсловноеОформление.Элементы.Очистить();
	ДоговорыКонтрагентовФормыУХ.ДобавитьЭлементыУсловногоОформленияГрафикРасчетов(ЭтотОбъект);
	
	ФинансовыеИнструментыФормы.УстановитьУсловноеОформлениеФормыГрафика(УсловноеОформление, ОписаниеГрафика);
	
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
	
    ОплатаВВалюте = (Объект.ВалютаВзаиморасчетов <> Константы.ВалютаРегламентированногоУчета.Получить());
	
	ПартнерПриИзмененииСервер(Объект.Партнер, 
								Объект.Контрагент, 
								ОплатаВВалюте, 
								Объект.БанковскийСчетКонтрагента);
								
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
	ОбновитьЗаголовокФормы();
	ЗаполнитьПараметрыВыбораПартнера();
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

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Результат = ДоговорыКонтрагентовФормыУХКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора);
	Если Результат.Свойство("ОбновитьГрафикРасчетов") Тогда
		ОбновитьГрафикНаСервере();
		ВыполнитьКонтрольДокумента();
	КонецЕсли;
	
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

&НаСервере
Процедура ОбновитьГрафикНаСервере(Знач СтруктураДействий = Неопределено)
	
	Если СтруктураДействий = Неопределено Тогда
		СтруктураДействий = Новый Структура;
	КонецЕсли;
	
	ДоговорыКонтрагентовФормыУХ.ОбновитьТаблицуГрафикРасчетов(ЭтотОбъект, СтруктураДействий, ОписаниеГрафика);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииЭлементаОрганизации_Подключаемый(Элемент) Экспорт
	ОпределитьСостояниеОбъекта(Истина);		
	ВыполнитьПредыдущийОбработчикПриИзмененииОрганизации(Элемент);
КонецПроцедуры		// ПриИзмененииЭлементаОрганизации_Подключаемый()

#КонецОбласти

#Область ЗагрузкаГрафика
&НаКлиенте
Процедура ЗагрузитьГрафик(Команда) Экспорт	
	Данные = ДанныеДляЗагрузкиГрафикаСервер();
	ДоговорыКонтрагентовФормыУХКлиент.ОткрытьЗагрузкуГрафика(ЭтотОбъект, Данные);	
КонецПроцедуры

&НаСервере
Функция ДанныеДляЗагрузкиГрафикаСервер()
	Возврат ДоговорыКонтрагентовФормыУХ.ДанныеДляЗагрузкиГрафика(ЭтотОбъект);
КонецФункции

&НаКлиенте
Процедура ЗагрузитьГрафикЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия = Неопределено 
		ИЛИ РезультатЗакрытия = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьГрафикНаСервере(РезультатЗакрытия);

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьГрафикНаСервере(АдресГрафика) Экспорт
	ДоговорыКонтрагентовФормыУХ.ЗагрузитьГрафик(ЭтотОбъект, АдресГрафика);	
КонецПроцедуры
#КонецОбласти

#Область ПереносФакта
&НаКлиенте
Процедура ПеренестиФакт(Команда)	
	ДоговорыКонтрагентовФормыУХКлиент.НачатьПереносФактаВГрафик(ЭтотОбъект);	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеВыбораДатыПереносаФакта(Дата, ДополнительныеПараметры) Экспорт
	Если ЗначениеЗаполнено(Дата) Тогда
		 ПеренестиФактНаСервере(Дата);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПеренестиФактНаСервере(ДатаПереноса)
	ДоговорыКонтрагентовФормыУХ.ПеренестиФактВГрафик(ЭтотОбъект, ДатаПереноса);
КонецПроцедуры
#КонецОбласти

#Область СравнениеВерсийГрафиков
&НаКлиенте
Процедура Подключаемый_СравнитьВерсииГрафиков(Команда)	
	ПараметрыКоманды = ПараметрыКомандыСравнитьВерсииГрафиков();
	ДоговорыКонтрагентовФормыУХКлиент.ОткрытьСравнениеВерсийГрафиков(ЭтотОбъект, ПараметрыКоманды);	
КонецПроцедуры

&НаСервере
Функция ПараметрыКомандыСравнитьВерсииГрафиков()
	Возврат ДоговорыКонтрагентовФормыУХ.ПараметрыКомандыСравнитьВерсииГрафиков(ЭтотОбъект);
КонецФункции	
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
