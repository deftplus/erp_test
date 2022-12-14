
&НаСервере
Перем БезусловноВыгружаемыеМетаданные;

&НаСервере
Перем СписокНеВыгружаемыхРеквизитов;

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_УзелПланаОбмена");
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ОбменДаннымиСервер.ФормаУзлаПриЗаписиНаСервере(ТекущийОбъект, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если БезусловноВыгружаемыеМетаданные = Неопределено Тогда
		БезусловноВыгружаемыеМетаданные = НалоговыйМониторингВызовСервераПовтИсп.ПолучитьМассивБезусловноПередаваемыхОбъектов();
	КонецЕсли;
	
	Дерево = РеквизитФормыВЗначение("ДеревоМетаданных");
	КореньСправочники = Дерево.Строки.Добавить();
	КореньСправочники.Имя = "Справочник";
	КореньСправочники.Синоним = "Справочники";
	КореньСправочники.ИндексКартинки = 0;
	КореньСправочники.Заблокировано = Истина;
	КореньДокументы = Дерево.Строки.Добавить();
	КореньДокументы.Имя = "Документ";
	КореньДокументы.Синоним = "Документы";
	КореньДокументы.ИндексКартинки = 1;
	КореньДокументы.Заблокировано = Истина;
	КореньРегистрыСведений = Дерево.Строки.Добавить();
	КореньРегистрыСведений.Имя = "РегистрСведений";
	КореньРегистрыСведений.Синоним = "РегистрыСведений";
	КореньРегистрыСведений.ИндексКартинки = 2;
	КореньРегистрыСведений.Заблокировано = Истина;
	КореньРегистрыНакопления = Дерево.Строки.Добавить();
	КореньРегистрыНакопления.Имя = "РегистрНакопления";
	КореньРегистрыНакопления.Синоним = "РегистрыНакопления";
	КореньРегистрыНакопления.ИндексКартинки = 3;
	КореньРегистрыНакопления.Заблокировано = Истина;
	КореньРегистрыБухгалтерии = Дерево.Строки.Добавить();
	КореньРегистрыБухгалтерии.Имя = "РегистрБухгалтерии";
	КореньРегистрыБухгалтерии.Синоним = "РегистрыБухгалтерии";
	КореньРегистрыБухгалтерии.ИндексКартинки = 4;
	КореньРегистрыБухгалтерии.Заблокировано = Истина;
	
	СписокНеВыгружаемыхРеквизитов = Объект.СписокНеВыгружаемыхРеквизитов.Выгрузить();
	ТаблицаМетаданных = ПолучитьСоставПланаОбменаВТаблицеЗначений(БезусловноВыгружаемыеМетаданные);
	ТаблицуМетаданныхВДерево(ТаблицаМетаданных, КореньСправочники, КореньДокументы, КореньРегистрыСведений, КореньРегистрыНакопления, КореньРегистрыБухгалтерии);
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоМетаданных");
	
	Если ТипЗнч(ПланыОбмена.ГлавныйУзел()) = Тип("ПланОбменаСсылка.НалоговыйМониторинг") Тогда
		Элементы.ДеревоМетаданных.Видимость = Ложь;
		Элементы.ПравилаПолученияИзмененийНаГлавномУзле.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	МассивСтрок = Новый Массив;
	СобратьОтключенныеДанные(ДеревоМетаданных.ПолучитьЭлементы(), МассивСтрок);
	Объект.СписокНеВыгружаемыхРеквизитов.Очистить();
	Для каждого Элемент Из МассивСтрок Цикл
		НовСтр = Объект.СписокНеВыгружаемыхРеквизитов.Добавить();
		НовСтр.НеВыгружаемыйРеквизит = Элемент;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСсылочныйТип(ЭлементДерева, ОбъектМетаданных)
	ЭлементДереваРеквизиты = ЭлементДерева.Строки.Добавить();
	ЭлементДереваРеквизиты.Имя = "Реквизиты";
	ЭлементДереваРеквизиты.Синоним = "Реквизиты";
	ЭлементДереваРеквизиты.ИндексКартинки = 5;
	ЭлементДереваРеквизиты.Заблокировано = Истина;
	Для каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
		ЭлементДереваРеквизит = ЭлементДереваРеквизиты.Строки.Добавить();
		ЭлементДереваРеквизит.Имя = Реквизит.Имя;
		ЭлементДереваРеквизит.Синоним = Реквизит.Синоним;
		ЭлементДереваРеквизит.ИндексКартинки = 5;
		ПолноеИмя = ЭлементДерева.Родитель.Имя + "." + ЭлементДерева.Имя + ".Реквизиты." + Реквизит.Имя;
		ЭлементДереваРеквизит.Отметка = (СписокНеВыгружаемыхРеквизитов.Найти(ПолноеИмя) = Неопределено);
		ЭлементДереваРеквизит.Заблокировано = ЭлементДерева.Заблокировано;
	КонецЦикла;
	Если ОбъектМетаданных.ТабличныеЧасти.Количество() > 0 Тогда
		ЭлементДереваТабличныеЧасти = ЭлементДерева.Строки.Добавить();
		ЭлементДереваТабличныеЧасти.Имя = "ТабличныеЧасти";
		ЭлементДереваТабличныеЧасти.Синоним = "Табличные части";
		ЭлементДереваТабличныеЧасти.ИндексКартинки = 6;
		ЭлементДереваТабличныеЧасти.Заблокировано = Истина;
		Для каждого ТабличнаяЧасть Из ОбъектМетаданных.ТабличныеЧасти Цикл
			ЭлементДереваТабличныеЧасть = ЭлементДереваТабличныеЧасти.Строки.Добавить();
			ЭлементДереваТабличныеЧасть.Имя = ТабличнаяЧасть.Имя;
			ЭлементДереваТабличныеЧасть.Синоним = ТабличнаяЧасть.Синоним;
			ЭлементДереваТабличныеЧасть.ИндексКартинки = 6;
			ПолноеИмя = ЭлементДерева.Родитель.Имя + "." + ЭлементДерева.Имя + ".ТабличныеЧасти." + ТабличнаяЧасть.Имя;
			ЭлементДереваТабличныеЧасть.Отметка = (СписокНеВыгружаемыхРеквизитов.Найти(ПолноеИмя) = Неопределено);
			ЭлементДереваТабличныеЧасть.Заблокировано = ЭлементДерева.Заблокировано;
			Для каждого Реквизит Из ТабличнаяЧасть.Реквизиты Цикл
			    ЭлементДереваРеквизит = ЭлементДереваТабличныеЧасть.Строки.Добавить();
				ЭлементДереваРеквизит.Имя = Реквизит.Имя;
				ЭлементДереваРеквизит.Синоним = Реквизит.Синоним;
				ЭлементДереваРеквизит.ИндексКартинки = 5;
				ПолноеИмя = ЭлементДерева.Родитель.Имя + "." + ЭлементДерева.Имя + ".ТабличныеЧасти." + ТабличнаяЧасть.Имя + "." + Реквизит.Имя;
				ЭлементДереваРеквизит.Отметка = (СписокНеВыгружаемыхРеквизитов.Найти(ПолноеИмя) = Неопределено);
				ЭлементДереваРеквизит.Заблокировано = ЭлементДерева.Заблокировано;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРегистр(ЭлементДерева, ОбъектМетаданных, ПроверятьБалансовые = Ложь)
	ЭлементДереваРеквизиты = ЭлементДерева.Строки.Добавить();
	ЭлементДереваРеквизиты.Имя = "Измерения";
	ЭлементДереваРеквизиты.Синоним = "Измерения";
	ЭлементДереваРеквизиты.Заблокировано = Истина;
	ЭлементДереваРеквизиты.ИндексКартинки = 7;
	Для каждого Реквизит Из ОбъектМетаданных.Измерения Цикл		
		ЭлементДереваРеквизит = ЭлементДереваРеквизиты.Строки.Добавить();
		ЭлементДереваРеквизит.Имя = Реквизит.Имя;
		ЭлементДереваРеквизит.Синоним = Реквизит.Синоним;
		ЭлементДереваРеквизит.ИндексКартинки = 7;
		//ПолноеИмя = ЭлементДерева.Родитель.Имя + "." + ЭлементДерева.Имя + ".Измерения." + Реквизит.Имя;
		//ЭлементДереваРеквизит.Отметка = (СписокНеВыгружаемыхРеквизитов.Найти(ПолноеИмя) = Неопределено);
		ЭлементДереваРеквизит.Отметка = Истина;
		ЭлементДереваРеквизит.Заблокировано = Истина;
	КонецЦикла;
	ЭлементДереваРеквизиты = ЭлементДерева.Строки.Добавить();
	ЭлементДереваРеквизиты.Имя = "Ресурсы";
	ЭлементДереваРеквизиты.Синоним = "Ресурсы";
	ЭлементДереваРеквизиты.Заблокировано = Истина;
	ЭлементДереваРеквизиты.ИндексКартинки = 8;
	Для каждого Реквизит Из ОбъектМетаданных.Ресурсы Цикл
		Если ПроверятьБалансовые И НЕ Реквизит.Балансовый Тогда
			ЭлементДереваРеквизит = ЭлементДереваРеквизиты.Строки.Добавить();
			ЭлементДереваРеквизит.Имя = "" + Реквизит.Имя + "Дт";
			ЭлементДереваРеквизит.Синоним = Реквизит.Синоним + " (дт)";
			ЭлементДереваРеквизит.ИндексКартинки = 8;
			ПолноеИмя = ЭлементДерева.Родитель.Имя + "." + ЭлементДерева.Имя + ".Ресурсы." + Реквизит.Имя +  "Дт";
			ЭлементДереваРеквизит.Отметка = (СписокНеВыгружаемыхРеквизитов.Найти(ПолноеИмя) = Неопределено);
			ЭлементДереваРеквизит.Заблокировано = ЭлементДерева.Заблокировано;
			
			ЭлементДереваРеквизит = ЭлементДереваРеквизиты.Строки.Добавить();
			ЭлементДереваРеквизит.Имя = "" + Реквизит.Имя + "Кт";
			ЭлементДереваРеквизит.Синоним = Реквизит.Синоним + " (кт)";
			ЭлементДереваРеквизит.ИндексКартинки = 8;
			ПолноеИмя = ЭлементДерева.Родитель.Имя + "." + ЭлементДерева.Имя + ".Ресурсы." + Реквизит.Имя + "Кт";
			ЭлементДереваРеквизит.Отметка = (СписокНеВыгружаемыхРеквизитов.Найти(ПолноеИмя) = Неопределено);
			ЭлементДереваРеквизит.Заблокировано = ЭлементДерева.Заблокировано;
		Иначе
			ЭлементДереваРеквизит = ЭлементДереваРеквизиты.Строки.Добавить();
			ЭлементДереваРеквизит.Имя = Реквизит.Имя;
			ЭлементДереваРеквизит.Синоним = Реквизит.Синоним;
			ЭлементДереваРеквизит.ИндексКартинки = 8;
			ПолноеИмя = ЭлементДерева.Родитель.Имя + "." + ЭлементДерева.Имя + ".Ресурсы." + Реквизит.Имя;
			ЭлементДереваРеквизит.Отметка = (СписокНеВыгружаемыхРеквизитов.Найти(ПолноеИмя) = Неопределено);
			ЭлементДереваРеквизит.Заблокировано = ЭлементДерева.Заблокировано;
		КонецЕсли;
	КонецЦикла;
	ЭлементДереваРеквизиты = ЭлементДерева.Строки.Добавить();
	ЭлементДереваРеквизиты.Имя = "Реквизиты";
	ЭлементДереваРеквизиты.Синоним = "Реквизиты";
	ЭлементДереваРеквизиты.Заблокировано = Истина;
	ЭлементДереваРеквизиты.ИндексКартинки = 5;
	Для каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
		ЭлементДереваРеквизит = ЭлементДереваРеквизиты.Строки.Добавить();
		ЭлементДереваРеквизит.Имя = Реквизит.Имя;
		ЭлементДереваРеквизит.Синоним = Реквизит.Синоним;
		ЭлементДереваРеквизит.ИндексКартинки = 5;
		ПолноеИмя = ЭлементДерева.Родитель.Имя + "." + ЭлементДерева.Имя + ".Реквизиты." + Реквизит.Имя;
		ЭлементДереваРеквизит.Отметка = (СписокНеВыгружаемыхРеквизитов.Найти(ПолноеИмя) = Неопределено);
		ЭлементДереваРеквизит.Заблокировано = ЭлементДерева.Заблокировано;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СобратьОтключенныеДанные(Дерево, МассивСтрок, Префикс = "")
	Для каждого Строка Из Дерево Цикл
		Если Не (Строка.Заблокировано ИЛИ Строка.Отметка) Тогда
			МассивСтрок.Добавить(?(Префикс = "", Строка.Имя, Префикс + "." + Строка.Имя));
		КонецЕсли;
		СобратьОтключенныеДанные(Строка.ПолучитьЭлементы(), МассивСтрок, ?(Префикс = "", Строка.Имя, Префикс + "." + Строка.Имя));
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСоставПланаОбменаВТаблицеЗначений(БезусловноВыгружаемыеМетаданные)
	Таб = Новый ТаблицаЗначений;
	Таб.Колонки.Добавить("Метаданные");
	Для каждого ЭлементСостава Из Метаданные.ПланыОбмена.НалоговыйМониторинг.Состав Цикл
		НовСтр = Таб.Добавить();
		НовСтр.Метаданные = ЭлементСостава.Метаданные;
	КонецЦикла;
	Таб.Индексы.Добавить("Метаданные");
	Таб.Сортировать("Метаданные");
	Таб.Колонки.Добавить("Заблокировано", Новый ОписаниеТипов("Булево"));
	Для каждого Элемент Из БезусловноВыгружаемыеМетаданные Цикл
		Строка = Таб.Найти(Элемент, "Метаданные");
		Если Строка <> Неопределено Тогда
			Строка.Заблокировано = Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Таб;
КонецФункции

&НаСервере
Функция ЗаполнитьЭлементДереваМетаданных(Корень, ЭлементСостава, ИндексКартинки)
	ЭлементДерева = Корень.Строки.Добавить();
	ЭлементДерева.Имя = ЭлементСостава.Метаданные.Имя;
	ЭлементДерева.Синоним = ЭлементСостава.Метаданные.Синоним;
	ЭлементДерева.ИндексКартинки = ИндексКартинки;
	ПолноеИмя = Корень.Имя + "." + ЭлементДерева.Имя;
	ЭлементДерева.Отметка = (СписокНеВыгружаемыхРеквизитов.Найти(ПолноеИмя) = Неопределено);
	ЭлементДерева.Заблокировано = ЭлементСостава.Заблокировано;
	Возврат ЭлементДерева;
КонецФункции

&НаСервере
Процедура ТаблицуМетаданныхВДерево(ТаблицаМетаданных, КореньСправочники, КореньДокументы, КореньРегистрыСведений, КореньРегистрыНакопления, КореньРегистрыБухгалтерии)
	Для каждого ЭлементСостава Из ТаблицаМетаданных Цикл
		Если Метаданные.РегистрыСведений.Содержит(ЭлементСостава.Метаданные) Тогда
			ЭлементДерева = ЗаполнитьЭлементДереваМетаданных(КореньРегистрыСведений, ЭлементСостава, 2);
			ЗаполнитьРегистр(ЭлементДерева, ЭлементСостава.Метаданные);
		ИначеЕсли Метаданные.РегистрыНакопления.Содержит(ЭлементСостава.Метаданные) Тогда
			ЭлементДерева = ЗаполнитьЭлементДереваМетаданных(КореньРегистрыНакопления, ЭлементСостава, 3);
			ЗаполнитьРегистр(ЭлементДерева, ЭлементСостава.Метаданные);
		ИначеЕсли Метаданные.РегистрыБухгалтерии.Содержит(ЭлементСостава.Метаданные) Тогда
			ЭлементДерева = ЗаполнитьЭлементДереваМетаданных(КореньРегистрыБухгалтерии, ЭлементСостава, 4);
			ЗаполнитьРегистр(ЭлементДерева, ЭлементСостава.Метаданные, Истина);
		ИначеЕсли Метаданные.Справочники.Содержит(ЭлементСостава.Метаданные) Тогда
			ЭлементДерева = ЗаполнитьЭлементДереваМетаданных(КореньСправочники, ЭлементСостава, 0);
			ЗаполнитьСсылочныйТип(ЭлементДерева, ЭлементСостава.Метаданные);
		ИначеЕсли Метаданные.Документы.Содержит(ЭлементСостава.Метаданные) Тогда
			ЭлементДерева = ЗаполнитьЭлементДереваМетаданных(КореньДокументы, ЭлементСостава, 1);
			ЗаполнитьСсылочныйТип(ЭлементДерева, ЭлементСостава.Метаданные);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
