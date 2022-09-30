///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяТаблицыДанных = Параметры.ИмяТаблицы;
	ТекущийОбъект = ЭтотОбъект();
	ЗаголовокТаблицы  = "";
	
	// Определяемся, что за таблица к нам пришла.
	Описание = ТекущийОбъект.ХарактеристикиПоМетаданным(ИмяТаблицыДанных);
	МетаИнфо = Описание.Метаданные;
	Заголовок = МетаИнфо.Представление();
	
	// Список и колонки
	СтруктураДанных = "";
	Если Описание.ЭтоСсылка Тогда
		ЗаголовокТаблицы = МетаИнфо.ПредставлениеОбъекта;
		Если ПустаяСтрока(ЗаголовокТаблицы) Тогда
			ЗаголовокТаблицы = Заголовок;
		КонецЕсли;
		
		СписокДанных.ПроизвольныйЗапрос = Ложь;
		
		СвойстваСписка = СтруктураСвойствДинамическогоСписка();
		СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
		СвойстваСписка.ОсновнаяТаблица = ИмяТаблицыДанных;
		
		УстановитьСвойстваДинамическогоСписка(Элементы.СписокДанных, СвойстваСписка);
		
		Поле = СписокДанных.Отбор.ДоступныеПоляОтбора.Элементы.Найти(Новый ПолеКомпоновкиДанных("Ссылка"));
		ТаблицаКолонок = Новый ТаблицаЗначений;
		Колонки = ТаблицаКолонок.Колонки;
		Колонки.Добавить("Ссылка", Поле.ТипЗначения, ЗаголовокТаблицы);
		СтруктураДанных = "Ссылка";
		
		КлючФормыДанных = "Ссылка";
		
	ИначеЕсли Описание.ЭтоНабор Тогда
		Колонки = ТекущийОбъект.ИзмеренияНабораЗаписей(МетаИнфо);
		Для Каждого ТекущийЭлементКолонки Из Колонки Цикл
			СтруктураДанных = СтруктураДанных + "," + ТекущийЭлементКолонки.Имя;
		КонецЦикла;
		СтруктураДанных = Сред(СтруктураДанных, 2);
		
		СписокДанных.ПроизвольныйЗапрос = Истина;
		
		ШаблонТекстаЗапроса = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	&ИменаПолейИРеквизитов
		|ИЗ
		|	&ИмяТаблицыМетаданных КАК ИмяТаблицыМетаданных";
		
		ТекстЗапроса = СтрЗаменить(ШаблонТекстаЗапроса, "&ИменаПолейИРеквизитов", СтруктураДанных);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяТаблицыМетаданных", ИмяТаблицыДанных);
		
		СвойстваСписка = СтруктураСвойствДинамическогоСписка();
		СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
		СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
		
		УстановитьСвойстваДинамическогоСписка(Элементы.СписокДанных, СвойстваСписка);
		
		Если Описание.ЭтоПоследовательность Тогда
			КлючФормыДанных = "Регистратор";
		Иначе
			КлючФормыДанных = Новый Структура(СтруктураДанных);
		КонецЕсли;
			
	Иначе
		// Без колонок???
		Возврат;
	КонецЕсли;
	
	ТекущийОбъект.ДобавитьКолонкиВТаблицуФормы(
		Элементы.СписокДанных, 
		"Порядок, Отбор, Группировка, СтандартнаяКартинка, Параметры, УсловноеОформление",
		Колонки);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
//

&НаКлиенте
Процедура ОтборПриИзменении(Элемент)
	
	Элементы.СписокДанных.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДанных
//

&НаКлиенте
Процедура СписокДанныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуТекущегоОбъекта();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
//

&НаКлиенте
Процедура ОткрытьТекущийОбъект(Команда)
	ОткрытьФормуТекущегоОбъекта();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОтобранныеЗначения(Команда)
	ПроизвестиВыбор(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьТекущуюСтроку(Команда)
	ПроизвестиВыбор(Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьСвойстваДинамическогоСписка(Список, СтруктураПараметров)
	
	Форма = Список.Родитель;
	
	Пока ТипЗнч(Форма) <> Тип("ФормаКлиентскогоПриложения") Цикл
		Форма = Форма.Родитель;
	КонецЦикла;
	
	ДинамическийСписок = Форма[Список.ПутьКДанным];
	ТекстЗапроса = СтруктураПараметров.ТекстЗапроса;
	
	Если Не ПустаяСтрока(ТекстЗапроса) Тогда
		ДинамическийСписок.ТекстЗапроса = ТекстЗапроса;
	КонецЕсли;
	
	ОсновнаяТаблица = СтруктураПараметров.ОсновнаяТаблица;
	
	Если Не ПустаяСтрока(ОсновнаяТаблица) Тогда
		ДинамическийСписок.ОсновнаяТаблица = ОсновнаяТаблица;
	КонецЕсли;
	
	ДинамическоеСчитываниеДанных = СтруктураПараметров.ДинамическоеСчитываниеДанных;
	
	Если ТипЗнч(ДинамическоеСчитываниеДанных) = Тип("Булево") Тогда
		ДинамическийСписок.ДинамическоеСчитываниеДанных = ДинамическоеСчитываниеДанных;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СтруктураСвойствДинамическогоСписка()
	
	Возврат Новый Структура("ТекстЗапроса, ОсновнаяТаблица, ДинамическоеСчитываниеДанных");
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуТекущегоОбъекта()
	ТекПараметры = ПараметрыФормыТекущегоОбъекта(Элементы.СписокДанных.ТекущиеДанные);
	Если ТекПараметры <> Неопределено Тогда
		ОткрытьФорму(ТекПараметры.ИмяФормы, ТекПараметры.Ключ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроизвестиВыбор(ВесьРезультатОтбора = Истина)
	
	Если ВесьРезультатОтбора Тогда
		Данные = ВсеВыбранныеЭлементы();
	Иначе
		Данные = Новый Массив;
		Для Каждого ТекСтрока Из Элементы.СписокДанных.ВыделенныеСтроки Цикл
			Элемент = Новый Структура(СтруктураДанных);
			ЗаполнитьЗначенияСвойств(Элемент, Элементы.СписокДанных.ДанныеСтроки(ТекСтрока));
			Данные.Добавить(Элемент);
		КонецЦикла;
	КонецЕсли;
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ИмяТаблицы", Параметры.ИмяТаблицы);
	СтруктураПараметров.Вставить("ДанныеВыбора", Данные);
	СтруктураПараметров.Вставить("ДействиеВыбора", Параметры.ДействиеВыбора);
	СтруктураПараметров.Вставить("СтруктураПолей", СтруктураДанных);
	ОповеститьОВыборе(СтруктураПараметров);
КонецПроцедуры

&НаСервере
Функция ЭтотОбъект(ТекущийОбъект = Неопределено) 
	Если ТекущийОбъект = Неопределено Тогда
		Возврат РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	Возврат Неопределено;
КонецФункции

&НаСервере
Функция ПараметрыФормыТекущегоОбъекта(Знач Данные)
	
	Если Данные = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(КлючФормыДанных) = Тип("Строка") Тогда
		Значение = Данные[КлючФормыДанных];
		ТекИмяФормы = ЭтотОбъект().ПолучитьИмяФормы(Значение) + ".ФормаОбъекта";
	Иначе
		// Там структура с именами измерений.
		Если Данные.Свойство("Регистратор") Тогда
			Значение = Данные.Регистратор;
			ТекИмяФормы = ЭтотОбъект().ПолучитьИмяФормы(Значение) + ".ФормаОбъекта";
		Иначе
			ЗаполнитьЗначенияСвойств(КлючФормыДанных, Данные);
			ТекПараметры = Новый Массив;
			ТекПараметры.Добавить(КлючФормыДанных);
			ИмяКлючаЗаписи = СтрЗаменить(Параметры.ИмяТаблицы, ".", "КлючЗаписи.");
			Значение = Новый(ИмяКлючаЗаписи, ТекПараметры);
			ТекИмяФормы = Параметры.ИмяТаблицы + ".ФормаЗаписи";
		КонецЕсли;
		
	КонецЕсли;
	Результат = Новый Структура("ИмяФормы", ТекИмяФормы);
	Результат.Вставить("Ключ", Новый Структура("Ключ", Значение));
	Возврат Результат;
КонецФункции

&НаСервере
Функция ВсеВыбранныеЭлементы()
	
	Данные = ЭтотОбъект().ТекущиеДанныеДинамическогоСписка(СписокДанных);
	
	Результат = Новый Массив();
	Для Каждого ТекСтрока Из Данные Цикл
		Элемент = Новый Структура(СтруктураДанных);
		ЗаполнитьЗначенияСвойств(Элемент, ТекСтрока);
		Результат.Добавить(Элемент);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции	

#КонецОбласти
