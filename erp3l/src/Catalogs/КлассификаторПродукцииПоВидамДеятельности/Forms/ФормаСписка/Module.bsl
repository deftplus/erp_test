#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	ДополнительныеПараметры = Новый Структура;
	Если Копирование Тогда
		ДополнительныеПараметры.Вставить("Наименование", ТекДанные.Наименование);
		ДополнительныеПараметры.Вставить("Код", ТекДанные.Код);
		ДополнительныеПараметры.Вставить("НаименованиеПолное", ТекДанные.НаименованиеПолное);
		ДополнительныеПараметры.Вставить("ЕдиницаСтатистическогоУчета", ТекДанные.ЕдиницаСтатистическогоУчета);
		ДополнительныеПараметры.Вставить("ВидСвободныхСтрокФормСтатистики", ТекДанные.ВидСвободныхСтрокФормСтатистики);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекстВопроса = НСтр("ru = 'Есть возможность подобрать продукцию по видам деятельности из классификатора (ОКПД).
		|Подобрать?';
		|en = 'You can select products by activity categories from the classifier (RNCPA).
		|Select?'");
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьИзКлассификатора(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Назначение", ПредопределенноеЗначение("Перечисление.ВидыСвободныхСтрокФормСтатистики.ВидыПродукцииОпт")); 
	ПараметрыФормы.Вставить("Подбор", Истина); 
	
	ОткрытьФорму("ОбщаяФорма.ДобавлениеЭлементовВКлассификаторСтатотчетность", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВопросЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Назначение", ПредопределенноеЗначение("Перечисление.ВидыСвободныхСтрокФормСтатистики.ВидыПродукцииОпт")); 
		ПараметрыФормы.Вставить("Подбор", Истина); 

		ОткрытьФорму("ОбщаяФорма.ДобавлениеЭлементовВКлассификаторСтатотчетность", ПараметрыФормы, ЭтаФорма);
	Иначе
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ДополнительныеПараметры);
		ОткрытьФорму("Справочник.КлассификаторПродукцииПоВидамДеятельности.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
