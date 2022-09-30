#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицуДенежныхДокументов();
	ПодборТоваровКлиентСервер.СформироватьЗаголовокФормыПодбора(
		Заголовок,
		Параметры.ВыбытиеДД);
	
	МодификацияКонфигурацииПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не ВыполняетсяЗакрытие И Модифицированность Тогда
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтр("ru = 'Данные были изменены. Перенести изменения в документ?';
																								|en = 'The data was modified. Migrate the changes to the document?'"), РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполняетсяЗакрытие = Истина;
		Модифицированность = Ложь;
		ПеренестиТоварыВДокумент();
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаТоваровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ТаблицаДД.ТекущиеДанные <> Неопределено Тогда
		
		Если Поле.Имя = "ТаблицаТоваровДенежныйДокумент" Тогда
			ПоказатьЗначение(Неопределено, Элементы.ТаблицаДД.ТекущиеДанные.ДенежныйДокумент);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()
	
	ПеренестиТоварыВДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьТоварыВыполнить()
	
	ВыбратьВсеТоварыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьТоварыВыполнить()
	
	ВыбратьВсеТоварыНаСервере(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаДД.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаДД.ПрисутствуетВДокументе");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Gray);

КонецПроцедуры

#Область Прочее

&НаСервере
Процедура ВыбратьВсеТоварыНаСервере(ЗначениеВыбора = Истина)
	
	Для Каждого СтрокаТаблицы Из ТаблицаДД.НайтиСтроки(Новый Структура("СтрокаВыбрана", Не ЗначениеВыбора)) Цикл
		СтрокаТаблицы.СтрокаВыбрана = ЗначениеВыбора;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьДДВХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаДД.Выгрузить(Новый Структура("СтрокаВыбрана", Истина)));
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуДенежныхДокументов()

	ДанныеОтбора = Новый Структура();
	ДанныеОтбора.Вставить("Ссылка",			Параметры.ВыбытиеДД);
	ДанныеОтбора.Вставить("МОЛ",			Параметры.МОЛ);
	ДанныеОтбора.Вставить("Организация",	Параметры.Организация);
	ДанныеОтбора.Вставить("Подразделение",	Параметры.Подразделение);
	
	Если Параметры.Свойство("Валюта") И Не Параметры.Валюта = Неопределено Тогда
		ДанныеОтбора.Вставить("Валюта", Параметры.Валюта);
	КонецЕсли;
	
	УчетДенежныхДокументов.ЗаполнитьПоОстаткамДД(ДанныеОтбора, ТаблицаДД);
	УстановитьПризнакиПрисутствияСтрокиВДокументе();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПризнакиПрисутствияСтрокиВДокументе()
	
	Для Каждого СтрТЧ Из ТаблицаДД Цикл
		
		ЗнПрисутствия = (Не Параметры.МассивДД.Найти(СтрТЧ.ДенежныйДокумент) = Неопределено);
		СтрТЧ.ПрисутствуетВДокументе = ЗнПрисутствия;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиТоварыВДокумент()
	
	// Снятие модифицированности, т.к. перед закрытием признак проверяется.
	Модифицированность = Ложь;
	
	Закрыть();
	
	ОповеститьОВыборе(Новый Структура("АдресДДВХранилище", ПоместитьДДВХранилище()));
	
КонецПроцедуры

#КонецОбласти

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти