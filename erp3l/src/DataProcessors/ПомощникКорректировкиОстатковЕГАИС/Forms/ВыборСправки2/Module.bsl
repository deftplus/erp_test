
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	ПроверитьОбработатьПереданныеПараметры(Отказ);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ПринудительноЗакрытьФорму И НЕ ЗавершениеРаботы И Модифицированность Тогда
		
		Отказ = Истина;
		
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Сохранить';
															|en = 'Сохранить'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не сохранять';
															|en = 'Не сохранять'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена';
																|en = 'Отмена'"));
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемВопросЗавершение", ЭтотОбъект),
			НСтр("ru = 'Введенные данные не сохранены, сохранить?';
				|en = 'Введенные данные не сохранены, сохранить?'"),
			СписокКнопок);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	ВыполнитьСохранениеРезультата();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиНайденныеМарки

&НаКлиенте
Процедура НайденныеМаркиПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.НайденныеМарки.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если (ПредыдущаяСтрокаТаблицы<>ТекущиеДанные.ПолучитьИдентификатор()) Тогда
		
		ПредыдущаяСтрокаТаблицы = ТекущиеДанные.ПолучитьИдентификатор();
		ИнформацияПоСправкам2.Очистить();
		Элементы.НайденныеМаркиСправка2.СписокВыбора.Очистить();
		Для Каждого ЭлементСписка Из ТекущиеДанные.ДоступныеСправки Цикл
			Элементы.НайденныеМаркиСправка2.СписокВыбора.Добавить(ЭлементСписка.Значение);
			НоваяСтрока = ИнформацияПоСправкам2.Добавить();
			НоваяСтрока.Справка2 = ЭлементСписка.Значение;
			НоваяСтрока.НеПроверено = ЭлементСписка.Представление;
		КонецЦикла;
		Элементы.НайденныеМаркиСправка2.СписокВыбора.Добавить(Неопределено, НСтр("ru = '<Излишки прочих партий>';
																				|en = '<Излишки прочих партий>'"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверитьОбработатьПереданныеПараметры(Отказ)
	
	//Нужно сопоставлять
	Если Параметры.НайденныеМарки.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Для Каждого НоваяМарка Из Параметры.НайденныеМарки Цикл
		ЗаполнитьЗначенияСвойств(НайденныеМарки.Добавить(), НоваяМарка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Выбранное количество
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Использование = Истина;
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаПроблемаГосИС);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Излишки прочих партий>';
																			|en = '<Излишки прочих партий>'"));
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("НайденныеМаркиСправка2");
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НайденныеМарки.Справка2");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ОтборЭлемента.Использование = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемВопросЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		
		ВыполнитьСохранениеРезультата();
		
	ИначеЕсли ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		
		ПринудительноЗакрытьФорму = Истина;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСохранениеРезультата()
	
	РезультатСопоставления = Новый Массив;
	Для Каждого НоваяМарка Из НайденныеМарки Цикл
		ДанныеСтроки = Новый Структура;
		ДанныеСтроки.Вставить("АкцизнаяМарка", НоваяМарка.АкцизнаяМарка);
		ДанныеСтроки.Вставить("Справка2", НоваяМарка.Справка2);
		РезультатСопоставления.Добавить(ДанныеСтроки);
	КонецЦикла;
	
	Модифицированность = Ложь;
	ОповеститьОВыборе(РезультатСопоставления);
	
КонецПроцедуры

#КонецОбласти
