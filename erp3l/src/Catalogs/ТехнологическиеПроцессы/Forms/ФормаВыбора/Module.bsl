
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор") Тогда
		// Необходимо заполнить поля быстрого отбора
		// чтобы их значения совпадали с отбором в списке.
		СтруктураОтбора = Параметры.Отбор;
		Если СтруктураОтбора.Свойство("Подразделение") Тогда
			ОтборПодразделение = СтруктураОтбора.Подразделение;
			Если ОтборПодразделение.Пустая() Тогда
				Параметры.Отбор.Удалить("Подразделение");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("Режим") Тогда
		Элементы.ОтборПодразделение.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗапретитьВыбор") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			"Ссылка", 
			Параметры.ЗапретитьВыбор, 
			ВидСравненияКомпоновкиДанных.НеРавно,
			, 
			ЗначениеЗаполнено(Параметры.ЗапретитьВыбор));
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область БыстрыеОтборы

&НаКлиенте
Процедура ОтборСтатусПриИзменении(Элемент)
	
	УстановитьОтборПоСтатусу(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	УстановитьОтборПоПодразделению(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНоменклатураПриИзменении(Элемент)
	
	УстановитьОтборПоНоменклатуре();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Копирование Тогда
		
		Отказ = Истина;
		
		КопироватьТехнологическийПроцесс();
		
	ИначеЕсли НЕ ОтборНоменклатура.Пустая() Тогда
		
		Отказ = Истина;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", ОтборНоменклатура);
		ОткрытьФорму("Справочник.ТехнологическиеПроцессы.ФормаОбъекта", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Отборы

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоСтатусу(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список, 
		"Статус", 
		Форма.ОтборСтатус, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Форма.ОтборСтатус));

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоПодразделению(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список, 
		"Подразделение", 
		Форма.ОтборПодразделение, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Форма.ОтборПодразделение));

КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоНоменклатуре()
	
	Справочники.ТехнологическиеПроцессы.УстановитьОтборПоНоменклатуреВСпискеТехнологическихПроцессов(
		Список,
		ОтборНоменклатура);

КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	Справочники.ТехнологическиеПроцессы.УстановитьУсловноеОформлениеСпискаТехнологическихПроцессов(Список.УсловноеОформление);
	
КонецПроцедуры

&НаКлиенте
Процедура КопироватьТехнологическийПроцесс()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВопросКопироватьТехнологическийПроцесс", ЭтаФорма);
	
	ТехнологическиеПроцессыКлиент.ПоказатьВопросКопироватьТехнологическийПроцессСОперациями(ОписаниеОповещения)
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросКопироватьТехнологическийПроцесс(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Ссылка = КопироватьТехнологическийПроцессНаСервере(Элементы.Список.ТекущиеДанные.Ссылка);
	
	Если Ссылка <> Неопределено Тогда
		
		Элементы.Список.ТекущаяСтрока = Ссылка;
		
		ТехнологическиеПроцессыКлиент.ОповеститьОКопированииТехнологическогоПроцессаСОперациями();
		
		ОткрытьФорму("Справочник.ТехнологическиеПроцессы.ФормаОбъекта", Новый Структура("Ключ", Ссылка));
	
	КонецЕсли; 

КонецПроцедуры

&НаСервереБезКонтекста
Функция КопироватьТехнологическийПроцессНаСервере(Источник)
	
	Возврат Справочники.ТехнологическиеПроцессы.СкопироватьТехнологическийПроцессСОперациями(Источник);
	
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

