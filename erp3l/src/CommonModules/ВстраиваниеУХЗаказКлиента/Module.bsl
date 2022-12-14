
#Область ПрограммныйИнтерфейс
	
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область СобытияМодуляФормы

#Область ФормаДокумента

#Область СтандартныеОбработчики

Процедура ФормаДокумента_ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	АналитикиПланированияДокументов.ПриЧтенииНаСервере(Форма);
КонецПроцедуры

Процедура ФормаДокумента_ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Элементы = Форма.Элементы;
	
	#Область УниверсальныеПроцессыСогласование
	ДействияСогласованиеУХСервер.НарисоватьПанельСогласованияИОпределитьСостояниеОбъекта(Форма);
	Элементы.Переместить(Элементы.ГруппаСтатусыСогласования, Элементы.ГруппаДанныеДокумента, Элементы.ГруппаСтраницы);
	#КонецОбласти
	
	АналитикиПланированияДокументов.ПриСозданииНаСервере(Форма, Элементы.Комментарий.Родитель, Элементы.Комментарий);
	КонтрольУХ.ПодготовитьФормуНаСервере(Форма, Форма.Элементы.ГруппаСтраницы);
	
КонецПроцедуры

Процедура ФормаДокумента_ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	КонтрольУХ.ИнициализироватьРезультатыКонтроля(Форма);
КонецПроцедуры

#КонецОбласти 

#КонецОбласти 

#КонецОбласти 

#Область Менеджер

#Область ИсточникиДляКонтроляДокумента
	
Функция ИсточникиДокумента(Объект) Экспорт
	
	Источники = Новый Соответствие;
	
	//// 1. Источник для контроля бюджетных лимитов и резервов
	//КонтрольУХ.ДобавитьИсточник(
	//	Источники, 
	//	КонтрольУХБюджетныеЛимиты, 
	//	Источник_БюджетныеЛимитыРезервы(Объект));
	//
	// 2. Планы по взаиморасчетам с контрагентом
	//КонтрольУХ.ДобавитьИсточник(
	//	Источники, 
	//	КонтрольУХВзаиморасчетыПоКонтрагенту, 
	//	Источник_ВзаиморасчетыПоКонтрагенту(Объект));
	//
	//// 3. Планы по взаиморасчетам по договору
	//КонтрольУХ.ДобавитьИсточник(
	//	Источники, 
	//	КонтрольУХВзаиморасчетыПоДоговору,
	//	Источник_ВзаиморасчетыПоДоговору(Объект));
	//
	// 4. Контроль суммы расходов по договору
	КонтрольУХ.ДобавитьИсточник(
		Источники, 
		КонтрольУХРасходыПоДоговору,
		Источник_РасходыПоДоговору(Объект));
	
	Возврат Источники;
	
КонецФункции
	
//Функция Источник_БюджетныеЛимитыРезервы(Объект)
//	
//	//
//	Источник = Новый Структура;
//	
//	// Параметры
//	ДопПараметры = Новый Структура;
//	ДопПараметры.Вставить("Дата", 						Объект.Дата);
//	ДопПараметры.Вставить("Ссылка", 					Объект.Ссылка);
//	ДопПараметры.Вставить("ЭтоНовый", 					НЕ ЗначениеЗаполнено(Объект.Ссылка));
//	
//	ТаблицаПланов = ПланыДокумента(Объект);
//	ТаблицаПланов.Колонки.Сумма.Имя = "Заявлено";
//	ТаблицаПланов.Колонки.Добавить("Лимит",				Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(18, 2)));
//	ТаблицаПланов.Колонки.Добавить("Зарезервировано",	Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(18, 2)));
//	ТаблицаПланов.Колонки.Добавить("Исполнено",			Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(18, 2)));
//	
//	//
//	Источник.Вставить("Параметры", ДопПараметры);
//	Источник.Вставить("ПланыДокумента", ТаблицаПланов);
//	
//	Возврат Источник;
//	
//КонецФункции

Функция Источник_ВзаиморасчетыПоКонтрагенту(Объект)
	
	// Если незаполнен контрагент, то контроль не выполняется
	Контрагент = Объект.Контрагент;
	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		Возврат неопределено;
	КонецЕсли;
	
	// Если роль определить не удалось, то контроль не выполняется
	Результат = Новый Структура;
	Результат.Вставить("Заявка", Объект.Ссылка);
	Результат.Вставить("Контрагент", Объект.Контрагент);
	Результат.Вставить("РольКонтрагента", Перечисления.РолиКонтрагентов.Покупатели);
	Результат.Вставить("Валюта", Объект.Валюта);
	Результат.Вставить("СуммаПлатежа", Объект.СуммаДокумента);
	
	Возврат Результат;
	
КонецФункции

Функция Источник_ВзаиморасчетыПоДоговору(Объект)
	
	Если Не ЗначениеЗаполнено(Объект.Контрагент) ИЛИ Не ЗначениеЗаполнено(Объект.Договор) Тогда
		// Контроль не выполняется
		Возврат неопределено;
	КонецЕсли;
	
	Взаиморасчеты = Новый ТаблицаЗначений;
	Взаиморасчеты.Колонки.Добавить("Организация", Метаданные.ОпределяемыеТипы.Организации.Тип);
	Взаиморасчеты.Колонки.Добавить("Контрагент", Метаданные.ОпределяемыеТипы.Контрагенты.Тип);
	Взаиморасчеты.Колонки.Добавить("Договор", Метаданные.ОпределяемыеТипы.Договор.Тип);
	Взаиморасчеты.Колонки.Добавить("ОбъектРасчетов", Новый ОписаниеТипов("СправочникСсылка.ОбъектыРасчетов"));
	Взаиморасчеты.Колонки.Добавить("ВалютаВзаиморасчетов", Новый ОписаниеТипов("СправочникСсылка.Валюты"));
	Взаиморасчеты.Колонки.Добавить("СуммаВзаиморасчетов", Метаданные.ОпределяемыеТипы.ДенежнаяСуммаЛюбогоЗнака.Тип);
	
	// Поставка
	Строка = Взаиморасчеты.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, Объект, "Организация, Контрагент, Договор, ОбъектРасчетов");
	Строка.ВалютаВзаиморасчетов = Объект.Валюта;
	Строка.СуммаВзаиморасчетов = Объект.СуммаДокумента;
	
	Результат = Новый Структура;
	Результат.Вставить("РасшифровкаПлатежа", Взаиморасчеты);
	
	// Устаревшая схема
	Результат.Вставить("Заявка", Объект.Ссылка);
	Результат.Вставить("Организация", Объект.Организация);
	Результат.Вставить("Контрагент", Объект.Контрагент);
	Результат.Вставить("Договор", Объект.Договор);
	Результат.Вставить("СуммаПлатежа", Объект.СуммаДокумента);
	
	Возврат Результат;
	
КонецФункции

Функция Источник_РасходыПоДоговору(Объект)
	
	Если Не ЗначениеЗаполнено(Объект.Договор) Тогда
		Возврат неопределено; // Контроль не выполняется
	КонецЕсли;
	
	КонтрольОплаты = Ложь;
	Результат = КонтрольУХРасходыПоДоговору.СтруктураИсточник(Объект.Ссылка, Объект.Организация, КонтрольОплаты);
	Результат.Контрагент = Объект.Контрагент;
	Результат.Договор = Объект.Договор;
	
	Строка = Результат.ДанныеДляПроверки.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, Объект);
	Строка.Сумма = Объект.СуммаДокумента;
	Строка.ЭтоОплата = КонтрольОплаты;
	
	Возврат Результат;
	
КонецФункции


#КонецОбласти 

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
#КонецОбласти
 
