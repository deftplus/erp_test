#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьПослеДобавленияОКП" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	Элементы.Список.Обновить();
	Элементы.Список.ТекущаяСтрока = РезультатВыбора;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.ОбщероссийскийКлассификаторПродукции);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.ФормаПодборИзКлассификатора.Видимость = МожноРедактировать;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Текст = НСтр("ru = 'Есть возможность подобрать из классификатора ОКП
		|Подобрать?';
		|en = 'There is a possibility to select from the RNCP classifier
		|Select?'");
		
	ДополнительныеПараметры = Новый Структура;
	Если Копирование Тогда
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Код", Элемент.ТекущиеДанные.Код);
		ЗначенияЗаполнения.Вставить("Наименование", Элемент.ТекущиеДанные.Наименование);
		ЗначенияЗаполнения.Вставить("НаименованиеПолное", Элемент.ТекущиеДанные.НаименованиеПолное);
		ДополнительныеПараметры.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросПодобратьЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборИзКлассификатора(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Подбор", Истина);
	ПараметрыФормы.Вставить("ИмяСправочника", "ОбщероссийскийКлассификаторПродукции");
		
	ОткрытьФорму("ОбщаяФорма.ДобавлениеЭлементовВКлассификатор", ПараметрыФормы, ЭтаФорма, , , , ,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВопросПодобратьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПодборИзКлассификатора(Неопределено);
	Иначе
		ОткрытьФорму("Справочник.ОбщероссийскийКлассификаторПродукции.Форма.ФормаЭлемента", ДополнительныеПараметры, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

