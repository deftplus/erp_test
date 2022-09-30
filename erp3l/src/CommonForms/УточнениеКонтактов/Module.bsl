///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Предмет = Параметры.Предмет;
	Письмо  = Параметры.Письмо;
	НеИзменятьПредставлениеПриИзмененииКонтакта = (ТипЗнч(Письмо) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее"));
	
	Для каждого ЭлементСпискаВыбранных Из Параметры.СписокВыбранных Цикл
	
		Для каждого ЭлементМассива Из ЭлементСпискаВыбранных.Значение Цикл
			
			ПараметрыПоиска = Новый Структура;
			ПараметрыПоиска.Вставить("Адрес", ЭлементМассива.Адрес);
			
			НайденныеСтроки = ТаблицаКонтактов.НайтиСтроки(ПараметрыПоиска);
			
			Если НайденныеСтроки.Количество() > 0 Тогда
				
				СтрокаКонтакта = НайденныеСтроки[0];
				
				Если Не ЗначениеЗаполнено(СтрокаКонтакта.Контакт)
					И ЗначениеЗаполнено(ЭлементМассива.Контакт) Тогда
					
					СтрокаКонтакта.Контакт = ЭлементМассива.Контакт;
					
				КонецЕсли;
				
			Иначе
				
				НоваяСтрока = ТаблицаКонтактов.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока,ЭлементМассива);
				НоваяСтрока.Группа = ЭлементСпискаВыбранных.Представление;
				НоваяСтрока.ПолноеПредставление = ВзаимодействияКлиентСервер.ПолучитьПредставлениеАдресата(
				ЭлементМассива.Представление,ЭлементМассива.Адрес, "");
				
			КонецЕсли;
			
		КонецЦикла;
	
	КонецЦикла;
	
	ЗаполнитьСпискиНайденныхКонтактовПоEmail();
	ЗаполнитьТаблицыТекущихEmailКонтактов();
	ОпределитьДоступностьИзмененияДляКонтактов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВыбранКонтакт" Тогда
		
		ТекущиеДанные = Элементы.ТаблицаКонтактов.ТекущиеДанные;
		ТекущиеДанные.Контакт = Параметр.ВыбранныйКонтакт;
		ЗаполнитьАдресаКонтакта(Элементы.ТаблицаКонтактов.ТекущаяСтрока);
		УстановитьСнятьПризнакИзменятьЕслиНеобходимо(ТекущиеДанные);
		Модифицированность = Истина;
	
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаКонтактовПриАктивизацииЯчейки(Элемент)
	
	ТекущиеДанные = Элементы.ТаблицаКонтактов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент.Имя = "ТаблицаКонтактовКонтакт" Тогда
		
		Элементы.ТаблицаКонтактовКонтакт.СписокВыбора.Очистить();
		Если ТекущиеДанные.СписокНайденныхКонтактов.Количество() > 0 Тогда
			Элементы.ТаблицаКонтактовКонтакт.СписокВыбора.ЗагрузитьЗначения(
			ТекущиеДанные.СписокНайденныхКонтактов.ВыгрузитьЗначения());
		КонецЕсли;
		
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "ТаблицаКонтактовТекущийАдресКонтакта" Тогда
		
		Элементы.ТаблицаКонтактовТекущийАдресКонтакта.СписокВыбора.Очистить();
		Если ТекущиеДанные.ТаблицаАдресовКонтакта.Количество() > 0 Тогда
			Для каждого СтрокаТаблицыАдресов Из ТекущиеДанные.ТаблицаАдресовКонтакта Цикл
				Элементы.ТаблицаКонтактовТекущийАдресКонтакта.СписокВыбора.Добавить(
				   Новый Структура("Вид,Адрес",СтрокаТаблицыАдресов.Вид, СтрокаТаблицыАдресов.АдресЭП),
				   СформироватьПредставлениеАдресаСВидом(СтрокаТаблицыАдресов.АдресЭП, СтрокаТаблицыАдресов.ВидНаименование));
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКонтактовТекущийАдресКонтактаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКонтактовТекущийАдресКонтактаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ТаблицаКонтактов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат ;
	КонецЕсли;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") 
		И (ВыбранноеЗначение.Адрес <> ТекущиеДанные.ТекущийАдресКонтакта 
		ИЛИ ВыбранноеЗначение.Вид <> ТекущиеДанные.ТекущийВидКонтактнойИнформации) Тогда
			
		ТекущиеДанные.ТекущийАдресКонтакта = ВыбранноеЗначение.Адрес;
		ТекущиеДанные.ТекущийВидКонтактнойИнформации = ВыбранноеЗначение.Вид;
		ТекущиеДанные.ТекущийАдресКонтактаПредставление = СформироватьПредставлениеАдресаСВидом(
			ВыбранноеЗначение.Адрес,ВыбранноеЗначение.Вид);
			
		УстановитьСнятьПризнакИзменятьЕслиНеобходимо(ТекущиеДанные);
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ТаблицаКонтактовКонтактОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ТаблицаКонтактов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Контакт <> ВыбранноеЗначение Тогда
		
		ТекущиеДанные.Контакт = ВыбранноеЗначение;
		Модифицированность    = Истина;
		
		УстановитьСнятьПризнакИзменятьЕслиНеобходимо(ТекущиеДанные);
		
		Если НЕ ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
			
			ПриОчисткеКонтакта(ТекущиеДанные);
			
		Иначе
			
			ЗаполнитьАдресаКонтакта(Элементы.ТаблицаКонтактов.ТекущаяСтрока);
			
		КонецЕсли;
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКонтактовКонтактОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаКонтактов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПриОчисткеКонтакта(ТекущиеДанные);
	УстановитьСнятьПризнакИзменятьЕслиНеобходимо(ТекущиеДанные);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКонтактовКонтактПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТаблицаКонтактов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Контакт) Тогда
		ПриОчисткеКонтакта(ТекущиеДанные);
	Иначе
		ЗаполнитьАдресаКонтакта(Элементы.ТаблицаКонтактов.ТекущаяСтрока);
	КонецЕсли;
	
	УстановитьСнятьПризнакИзменятьЕслиНеобходимо(ТекущиеДанные);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКонтактовКонтактНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.ТаблицаКонтактов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ТолькоEmail",                       Истина);
	ПараметрыОткрытия.Вставить("ТолькоТелефон",                     Ложь);
	ПараметрыОткрытия.Вставить("ЗаменятьПустыеАдресИПредставление", Ложь);
	ПараметрыОткрытия.Вставить("ДляФормыУточненияКонтактов",        Истина);
	ПараметрыОткрытия.Вставить("ИдентификаторФормы",                УникальныйИдентификатор);
	
	ВзаимодействияКлиент.ВыбратьКонтакт(
			Предмет, ТекущиеДанные.Адрес, ТекущиеДанные.Представление,
			ТекущиеДанные.Контакт, ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКонтактовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОКВыполнить()
	
	СохранитьИЗакрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаКонтактовИзменять.Имя);
	
	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаКонтактов.Адрес");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаКонтактов.ТекущийАдресКонтакта");

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаКонтактов.Контакт");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаКонтактов.Адрес");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаКонтактовИзменять.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТаблицаКонтактов.ДоступноИзменение");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	РезультатВыбора = Новый Массив;
	ЕстьКонтактнаяИнформацияДляИзменения = Ложь;
	Для каждого СтрокаТаблицыКонтактов Из ТаблицаКонтактов Цикл
		
		Если СтрокаТаблицыКонтактов.Изменять Тогда
			ЕстьКонтактнаяИнформацияДляИзменения = Истина;
		КонецЕсли;
	
		СтруктураДанные = Новый Структура;
		
		СтруктураДанные.Вставить("Представление", СтрокаТаблицыКонтактов.Представление);
		СтруктураДанные.Вставить("Адрес", СтрокаТаблицыКонтактов.Адрес);
		СтруктураДанные.Вставить("Контакт", СтрокаТаблицыКонтактов.Контакт);
		СтруктураДанные.Вставить("Группа", СтрокаТаблицыКонтактов.Группа);
		
		РезультатВыбора.Добавить(СтруктураДанные);
		
	КонецЦикла;
	
	Если ЕстьКонтактнаяИнформацияДляИзменения Тогда
		ИзменитьКонтактнуюИнформациюДляВыбранных();
	КонецЕсли;
	
	ВыполненаКомандаЗакрытия = Истина;
	
	Если Не Модифицированность Тогда
		Закрыть();
		Возврат;
	Иначе
		Модифицированность = Ложь;
	КонецЕсли;
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

// Возвращает данные строки таблицы Найденные контакты.
// 
// Параметры:
//  ВыделеннаяСтрока  - ДанныеФормыЭлементКоллекции - строка, данные которой получаются.
//
// Возвращаемое значение:
//  Структура:
//   * НаименованиеВладельца - Строка
//   * Наименование          - Строка
//   * Представление         - Строка
//   * Ссылка                - ОпределяемыйТип.КонтактВзаимодействия
//
&НаСервере
Функция ДанныеСтрокиНайденныеКонтакты(ВыделеннаяСтрока)
	
	Возврат ВыделеннаяСтрока;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСпискиНайденныхКонтактовПоEmail()
	
	// Получим список адресов, для которых не указан email.
	МассивАдресов = Новый Массив;
	Для Каждого СтрокаТаблицы Из ТаблицаКонтактов Цикл
		Если Не ПустаяСтрока(СтрокаТаблицы.Адрес) Тогда
			МассивАдресов.Добавить(СтрокаТаблицы.Адрес);
		КонецЕсли;
	КонецЦикла;
	
	// Если для всех адресов email указан, то поиск не осуществляем.
	Если МассивАдресов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Найдем контакты по email
	НайденныеКонтакты = Взаимодействия.ПолучитьВсеКонтактыПоСпискуEmail(МассивАдресов);
	Если НайденныеКонтакты.Строки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Строка Из НайденныеКонтакты.Строки Цикл
		Строка.Представление = ВРег(Строка.Представление);
	КонецЦикла;
	
	// Для каждой строки проставим список найденных контактов.
	Для Каждого СтрокаТаблицы Из ТаблицаКонтактов Цикл
		Если Не ПустаяСтрока(СтрокаТаблицы.Адрес)  Тогда
			Группа = НайденныеКонтакты.Строки.Найти(ВРег(СтрокаТаблицы.Адрес), "Представление");
			Если Группа = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Для Каждого Группа Из Группа.Строки Цикл 
			
				СтрокаГруппы = ДанныеСтрокиНайденныеКонтакты(Группа);
				Если СтрокаТаблицы.СписокНайденныхКонтактов.НайтиПоЗначению(Группа.Контакт) = Неопределено Тогда
					ПредставлениеКонтакта = СтрокаГруппы.Наименование + ?(ПустаяСтрока(СтрокаГруппы.НаименованиеВладельца), "", " (" + СтрокаГруппы.НаименованиеВладельца + ")");
					СтрокаТаблицы.СписокНайденныхКонтактов.Добавить(СтрокаГруппы.Контакт, ПредставлениеКонтакта);
				КонецЕсли;
				
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьПредставлениеАдресаСВидом(Адрес, ВидКИ)

	Если ПустаяСтрока(Адрес) Тогда
		Возврат Строка(ВидКИ);
	Иначе
		Возврат Строка(ВидКИ) + " (" + Адрес + ")";
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицыТекущихEmailКонтактов()
	
	МассивОписанияТиповКонтактов = ВзаимодействияКлиентСервер.ОписанияКонтактов();
	ИменаПредопределенных = Метаданные.Справочники.ВидыКонтактнойИнформации.ПолучитьИменаПредопределенных();
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Контакты.Контакт
	|ПОМЕСТИТЬ ВсеКонтакты
	|ИЗ
	|	&Контакты КАК Контакты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Контакты.Контакт
	|ПОМЕСТИТЬ Контакты
	|ИЗ
	|	ВсеКонтакты КАК Контакты
	|ГДЕ
	|	Контакты.Контакт <> НЕОПРЕДЕЛЕНО
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыКонтактнойИнформации.Ссылка КАК Вид,
	|	ВидыКонтактнойИнформации.Наименование КАК ВидНаименование,
	|	ТаблицаКонтакты.Ссылка КАК Контакт
	|ПОМЕСТИТЬ ПользователиВидыКИ
	|ИЗ
	|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации,
	|	Справочник.Пользователи КАК ТаблицаКонтакты
	|ГДЕ
	|	ВидыКонтактнойИнформации.Родитель = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.СправочникПользователи)
	|	И ВидыКонтактнойИнформации.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	|	И ТаблицаКонтакты.Ссылка В
	|			(ВЫБРАТЬ
	|				Контакты.Контакт
	|			ИЗ
	|				Контакты КАК Контакты)
	|;"; 
	
	Для каждого ЭлементМассиваОписания Из МассивОписанияТиповКонтактов Цикл

		Если ЭлементМассиваОписания.Имя = "Пользователи" Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяВарианта = "Справочник" + ЭлементМассиваОписания.Имя;
		Если ИменаПредопределенных.Найти(ИмяВарианта) <> Неопределено Тогда
			ВариантОтбора = "ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации." + ИмяВарианта + ")";
		Иначе
			ВариантОтбора = """" + ИмяВарианта +"""";
		КонецЕсли;
		
		ТекстЗапроса = ТекстЗапроса + "
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВидыКонтактнойИнформации.Ссылка КАК Вид,
		|	ВидыКонтактнойИнформации.Наименование КАК ВидНаименование,
		|	ТаблицаКонтакты.Ссылка КАК Контакт
		|ПОМЕСТИТЬ ВременнаяТаблицаВидыКИ
		|ИЗ
		|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации,
		|	&ИмяСправочника КАК ТаблицаКонтакты
		|ГДЕ
		|	ВидыКонтактнойИнформации.ИмяГруппы = &ВариантОтбора
		|	И ВидыКонтактнойИнформации.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
		|	И ТаблицаКонтакты.Ссылка В
		|			(ВЫБРАТЬ
		|				Контакты.Контакт
		|			ИЗ
		|				Контакты КАК Контакты)
		|	И &УсловиеПоГруппе
		|;";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВременнаяТаблицаВидыКИ", ЭлементМассиваОписания.Имя + "ВидыКИ");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяСправочника",        "Справочник." + ЭлементМассиваОписания.Имя);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ВариантОтбора",         ВариантОтбора);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &УсловиеПоГруппе",       ?(ЭлементМассиваОписания.Иерархический,"И (НЕ ТаблицаКонтакты.ЭтоГруппа)",""));
		
	КонецЦикла;
	
	ТекстЗапроса = ТекстЗапроса + "
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КонтактыВидыКИ.Контакт,
	|	ЕСТЬNULL(КонтактнаяИнформация.АдресЭП, """") КАК АдресЭП,
	|	КонтактыВидыКИ.Вид,
	|	КонтактыВидыКИ.ВидНаименование КАК ВидНаименование
	|ИЗ
	|	ПользователиВидыКИ КАК КонтактыВидыКИ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи.КонтактнаяИнформация КАК КонтактнаяИнформация
	|		ПО КонтактыВидыКИ.Контакт = КонтактнаяИнформация.Ссылка
	|			И КонтактыВидыКИ.Вид = КонтактнаяИнформация.Вид";
	
	Для каждого ЭлементМассиваОписания Из МассивОписанияТиповКонтактов Цикл
		
		Если ЭлементМассиваОписания.Имя = "Пользователи" Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КонтактыВидыКИ.Контакт,
		|	ЕСТЬNULL(КонтактнаяИнформация.АдресЭП, """"),
		|	КонтактыВидыКИ.Вид,
		|	КонтактыВидыКИ.ВидНаименование
		|
		|ИЗ
		|	&ИмяТаблицыВидыКИ КАК КонтактыВидыКИ
		|		ЛЕВОЕ СОЕДИНЕНИЕ &ИмяТаблицыКонтактнаяИнформация КАК КонтактнаяИнформация
		|		ПО КонтактыВидыКИ.ВИД = КонтактнаяИнформация.Вид
		|			И КонтактыВидыКИ.Контакт = КонтактнаяИнформация.Ссылка"; // @query-part-1
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяТаблицыВидыКИ",               ЭлементМассиваОписания.Имя + "ВидыКИ");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяТаблицыКонтактнаяИнформация", "Справочник." + ЭлементМассиваОписания.Имя + ".КонтактнаяИнформация");
	
	КонецЦикла;
	
	ТекстЗапроса = ТекстЗапроса + "
		|
		|ИТОГИ ПО
		|	Контакт"; // @query-part-1

	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Контакты",ТаблицаКонтактов.Выгрузить());
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ДеревоРезультатов = Результат.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Для каждого СтрокаТаблицыКонтактов Из ТаблицаКонтактов Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицыКонтактов.Контакт) Тогда
			НайденнаяСтрока = ДеревоРезультатов.Строки.Найти(СтрокаТаблицыКонтактов.Контакт, "Контакт");
			Если НайденнаяСтрока <> Неопределено Тогда
				
				ЗаполнитьТаблицуАдресовИзКоллекции(СтрокаТаблицыКонтактов, НайденнаяСтрока.Строки);
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуАдресовИзКоллекции(СтрокаТаблицыКонтактов, Коллекция)
	
	СтрокаТаблицыКонтактов.ТаблицаАдресовКонтакта.Очистить();
	СтрокаТаблицыКонтактов.ТекущийАдресКонтакта              = "";
	СтрокаТаблицыКонтактов.ТекущийВидКонтактнойИнформации    = Справочники.ВидыКонтактнойИнформации.ПустаяСсылка();
	СтрокаТаблицыКонтактов.ТекущийАдресКонтактаПредставление = "";
	
	Если Коллекция = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	БылоНайденоСопоставлениеАдресов = Ложь;
	
	Для каждого СтрокаКоллекции Из Коллекция Цикл
		
		НоваяСтрокаТаблицыАдресов = СтрокаТаблицыКонтактов.ТаблицаАдресовКонтакта.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТаблицыАдресов, СтрокаКоллекции);
		Если ВРег(СтрокаТаблицыКонтактов.Адрес) = ВРег(СтрокаКоллекции.АдресЭП) Тогда
			СтрокаТаблицыКонтактов.ТекущийАдресКонтакта              = СтрокаТаблицыКонтактов.Адрес;
			СтрокаТаблицыКонтактов.ТекущийВидКонтактнойИнформации    = СтрокаКоллекции.Вид;
			СтрокаТаблицыКонтактов.ТекущийАдресКонтактаПредставление = 
				СформироватьПредставлениеАдресаСВидом(СтрокаТаблицыКонтактов.Адрес, СтрокаКоллекции.ВидНаименование);
			БылоНайденоСопоставлениеАдресов = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если (НЕ БылоНайденоСопоставлениеАдресов) И Коллекция.Количество() > 0 Тогда
		
		СтрокаТаблицыКонтактов.ТекущийАдресКонтакта              = Коллекция[0].АдресЭП;
		СтрокаТаблицыКонтактов.ТекущийВидКонтактнойИнформации    = Коллекция[0].Вид;
		СтрокаТаблицыКонтактов.ТекущийАдресКонтактаПредставление = 
			СформироватьПредставлениеАдресаСВидом(Коллекция[0].АдресЭП,Коллекция[0].Вид);
		СтрокаТаблицыКонтактов.Изменять                          = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОчисткеКонтакта(ТекущиеДанные)

	ТекущиеДанные.СписокНайденныхКонтактов.Очистить();
	ТекущиеДанные.ТаблицаАдресовКонтакта.Очистить();
	ТекущиеДанные.Представление                     = "";
	ТекущиеДанные.ТекущийАдресКонтакта              = "";
	ТекущиеДанные.ТекущийВидКонтактнойИнформации    =
		ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ПустаяСсылка");
	ТекущиеДанные.ТекущийАдресКонтактаПредставление = "";

КонецПроцедуры

&НаСервере
Процедура ИзменитьКонтактнуюИнформациюДляВыбранных()
	
	МетаданныеИсходящееПисьмо = Метаданные.Документы.ЭлектронноеПисьмоИсходящее;
	МетаданныеВходящееПисьмо = Метаданные.Документы.ЭлектронноеПисьмоВходящее;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ТаблицаКонтакты.Контакт,
	|	ТаблицаКонтакты.Адрес,
	|	ТаблицаКонтакты.ТекущийВидКонтактнойИнформации,
	|	ТаблицаКонтакты.Изменять
	|ПОМЕСТИТЬ ВсеКонтакты
	|ИЗ
	|	&ТаблицаКонтакты КАК ТаблицаКонтакты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВсеКонтакты.Контакт,
	|	ВсеКонтакты.Адрес,
	|	ВсеКонтакты.ТекущийВидКонтактнойИнформации КАК Вид
	|ИЗ
	|	ВсеКонтакты КАК ВсеКонтакты
	|ГДЕ
	|	ВсеКонтакты.Изменять";
	
	Запрос.УстановитьПараметр("ТаблицаКонтакты", ТаблицаКонтактов.Выгрузить());
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			МетаданныеКонтакта = Выборка.Контакт.Метаданные();
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(МетаданныеКонтакта.ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Контакт);
			Блокировка.Заблокировать();
			
			КонтактОбъект = Выборка.Контакт.ПолучитьОбъект(); // ОпределяемыйТип.КонтактВзаимодействия
			
			УправлениеКонтактнойИнформацией.ДобавитьКонтактнуюИнформацию(Выборка.Контакт, Выборка.Адрес, Выборка.Вид, , Истина);
			
			Запрос = Новый Запрос;
			Запрос.Текст = "
			|ВЫБРАТЬ
			|	ЭлектронноеПисьмоВходящееПолучателиПисьма.Ссылка КАК Ссылка,
			|	ЭлектронноеПисьмоВходящееПолучателиПисьма.Адрес,
			|	ЭлектронноеПисьмоВходящееПолучателиПисьма.Контакт,
			|	""ПолучателиПисьма"" КАК ИмяТабличнойЧасти
			|ИЗ
			|	Документ.ЭлектронноеПисьмоВходящее.ПолучателиПисьма КАК ЭлектронноеПисьмоВходящееПолучателиПисьма
			|ГДЕ
			|	ЭлектронноеПисьмоВходящееПолучателиПисьма.Адрес = &Адрес
			|	И ЭлектронноеПисьмоВходящееПолучателиПисьма.Контакт = НЕОПРЕДЕЛЕНО
			|	И ЭлектронноеПисьмоВходящееПолучателиПисьма.Ссылка <> &Письмо
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ЭлектронноеПисьмоВходящееПолучателиКопий.Ссылка,
			|	ЭлектронноеПисьмоВходящееПолучателиКопий.Адрес,
			|	ЭлектронноеПисьмоВходящееПолучателиКопий.Контакт,
			|	""ПолучателиКопий""
			|ИЗ
			|	Документ.ЭлектронноеПисьмоВходящее.ПолучателиКопий КАК ЭлектронноеПисьмоВходящееПолучателиКопий
			|ГДЕ
			|	ЭлектронноеПисьмоВходящееПолучателиКопий.Адрес = &Адрес
			|	И ЭлектронноеПисьмоВходящееПолучателиКопий.Контакт = НЕОПРЕДЕЛЕНО
			|	И ЭлектронноеПисьмоВходящееПолучателиКопий.Ссылка <> &Письмо
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ЭлектронноеПисьмоВходящее.Ссылка,
			|	ЭлектронноеПисьмоВходящее.ОтправительАдрес,
			|	ЭлектронноеПисьмоВходящее.ОтправительКонтакт,
			|	""Отправитель""
			|ИЗ
			|	Документ.ЭлектронноеПисьмоВходящее КАК ЭлектронноеПисьмоВходящее
			|ГДЕ
			|	ЭлектронноеПисьмоВходящее.ОтправительАдрес = &Адрес
			|	И ЭлектронноеПисьмоВходящее.ОтправительКонтакт = НЕОПРЕДЕЛЕНО
			|	И ЭлектронноеПисьмоВходящее.Ссылка <> &Письмо
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Ссылка,
			|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Адрес,
			|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Контакт,
			|	""ПолучателиПисьма""
			|ИЗ
			|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиПисьма КАК ЭлектронноеПисьмоИсходящееПолучателиПисьма
			|ГДЕ
			|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Адрес = &Адрес
			|	И ЭлектронноеПисьмоИсходящееПолучателиПисьма.Контакт = НЕОПРЕДЕЛЕНО
			|	И ЭлектронноеПисьмоИсходящееПолучателиПисьма.Ссылка <> &Письмо
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Ссылка,
			|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Адрес,
			|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Контакт,
			|	""ПолучателиКопий""
			|ИЗ
			|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиКопий КАК ЭлектронноеПисьмоИсходящееПолучателиКопий
			|ГДЕ
			|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Адрес = &Адрес
			|	И ЭлектронноеПисьмоИсходящееПолучателиКопий.Контакт = НЕОПРЕДЕЛЕНО
			|	И ЭлектронноеПисьмоИсходящееПолучателиКопий.Ссылка <> &Письмо
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Ссылка,
			|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Адрес,
			|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Контакт,
			|	""ПолучателиСкрытыхКопий""
			|ИЗ
			|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиСкрытыхКопий КАК ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий
			|ГДЕ
			|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Адрес = &Адрес
			|	И ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Контакт = НЕОПРЕДЕЛЕНО
			|	И ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Ссылка <> &Письмо
			|ИТОГИ ПО
			|	Ссылка";
			
			Запрос.УстановитьПараметр("Адрес",Выборка.Адрес);
			Запрос.УстановитьПараметр("Письмо",Письмо);
			
			Результат = Запрос.Выполнить();
			МассивИсходящихПисем = Новый Массив;
			МассивВходящихПисем  = Новый Массив;
			
			ВыборкаПисьма = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПисьма.Следующий() Цикл
				
				Если ТипЗнч(ВыборкаПисьма.Ссылка) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Тогда
					МассивВходящихПисем.Добавить(ВыборкаПисьма.Ссылка);
				Иначе
					МассивИсходящихПисем.Добавить(ВыборкаПисьма.Ссылка);
				КонецЕсли;
				
			КонецЦикла;
			
			Если МассивВходящихПисем.Количество() > 0 Тогда
				
				Блокировка = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить(МетаданныеВходящееПисьмо.ПолноеИмя());
				
				ИсточникБлокировки = Новый ТаблицаЗначений;
				ИсточникБлокировки.Колонки.Добавить("Письмо", Новый ОписаниеТипов("ДокументСсылка.ЭлектронноеПисьмоВходящее"));
				ИсточникБлокировки.ЗагрузитьКолонку(МассивВходящихПисем, "Письмо");
				
				ЭлементБлокировки.ИсточникДанных = ИсточникБлокировки;
				ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "Письмо");
				
				Блокировка.Заблокировать();
				
			КонецЕсли;
			
			Если МассивИсходящихПисем.Количество() > 0 Тогда
				
				Блокировка = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить(МетаданныеИсходящееПисьмо.ПолноеИмя());
				
				ИсточникБлокировки = Новый ТаблицаЗначений;
				ИсточникБлокировки.Колонки.Добавить("Письмо", Новый ОписаниеТипов("ДокументСсылка.ЭлектронноеПисьмоИсходящее"));
				ИсточникБлокировки.ЗагрузитьКолонку(МассивИсходящихПисем, "Письмо");
				
				ЭлементБлокировки.ИсточникДанных = ИсточникБлокировки;
				ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "Письмо");
				
				Блокировка.Заблокировать();
				
			КонецЕсли;
			
			ВыборкаПисьма.Сбросить();
			
			ВыборкаПисьма = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПисьма.Следующий() Цикл
				
				ПисьмоОбъект = ВыборкаПисьма.Ссылка.ПолучитьОбъект();
				ВыборкаДеталиПисьма = ВыборкаПисьма.Выбрать();
				Пока ВыборкаДеталиПисьма.Следующий() Цикл
					Если ВыборкаДеталиПисьма.ИмяТабличнойЧасти = "Отправитель" Тогда
						ПисьмоОбъект.ОтправительКонтакт = КонтактОбъект.Ссылка;
					Иначе
						НайденныеСтроки = 
							ПисьмоОбъект[ВыборкаДеталиПисьма.ИмяТабличнойЧасти].НайтиСтроки(Новый Структура("Адрес", Выборка.Адрес));
						Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
							Если Не ЗначениеЗаполнено(НайденнаяСтрока.Контакт) Тогда
								НайденнаяСтрока.Контакт = КонтактОбъект.Ссылка;
							КонецЕсли;
						КонецЦикла;
					КонецЕсли;
				КонецЦикла;
				
				ПисьмоОбъект.Записать();
				
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Во время обновления контактной информации %1 произошла ошибка
				|%2';
				|en = 'Error occurred when updating contact information %1:
				|%2'", ОбщегоНазначения.КодОсновногоЯзыка()),
				Выборка.Контакт, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(УправлениеЭлектроннойПочтой.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка, , , ТекстСообщенияОбОшибке);
			
			Продолжить;
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСнятьПризнакИзменятьЕслиНеобходимо(ТекущиеДанные)
	
	Если (Не ЗначениеЗаполнено(ТекущиеДанные.Адрес) 
		Или Не ЗначениеЗаполнено(ТекущиеДанные.Контакт) 
		Или ВРег(ТекущиеДанные.Адрес) = ВРег(ТекущиеДанные.ТекущийАдресКонтакта)
		Или Не ТекущиеДанные.ДоступноИзменение) Тогда
		
		ТекущиеДанные.Изменять = Ложь;
		
	Иначе
		
		ТекущиеДанные.Изменять = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАдресаКонтакта(ТекущаяСтрока)
	
	ТекущиеДанные  = ТаблицаКонтактов.НайтиПоИдентификатору(ТекущаяСтрока);
	ТаблицаАдресов = ВзаимодействияВызовСервера.ПолучитьАдресаЭлектроннойПочтыКонтакта(ТекущиеДанные.Контакт,Истина);
	
	Если (Не НеИзменятьПредставлениеПриИзмененииКонтакта) ИЛИ ПустаяСтрока(ТекущиеДанные.Представление) Тогда
		ТекущиеДанные.Представление = Строка(ТекущиеДанные.Контакт);
	КонецЕсли;
	ЗаполнитьТаблицуАдресовИзКоллекции(ТекущиеДанные, ТаблицаАдресов);
	
	ОпределитьДоступностьИзмененияДляКонтактов();

КонецПроцедуры

&НаСервере
Процедура ОпределитьДоступностьИзмененияДляКонтактов()

	Для каждого СтрокаКонтакт Из ТаблицаКонтактов Цикл
	
		Если Не ЗначениеЗаполнено(СтрокаКонтакт.Контакт) Тогда
			
			СтрокаКонтакт.ДоступноИзменение = Ложь;
			
		Иначе
			
			ПравоИзменения = ПравоДоступа("Изменение", Метаданные.НайтиПоТипу(ТипЗнч(СтрокаКонтакт.Контакт)));
			СтрокаКонтакт.ДоступноИзменение = ПравоИзменения;
			Если Не ПравоИзменения Тогда
				СтрокаКонтакт.ДоступноИзменение = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не СтрокаКонтакт.ДоступноИзменение Тогда
			
			СтрокаКонтакт.Изменять = Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
