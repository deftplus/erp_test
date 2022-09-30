
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		УстановитьВидимость();
	
	КонецЕсли; 
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьВидимость();
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЕдиницаИзмеренияПриИзменении(Элемент)
	
	ЕдиницаИзмеренияПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура УстановитьВидимость()
	
	КодЕдиницыИзмерения = "";
	
	Если ЗначениеЗаполнено(Объект.ЕдиницаИзмерения) Тогда
	
		КодЕдиницыИзмерения = СокрЛП(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ЕдиницаИзмерения, "Код"));
	
	КонецЕсли; 
	
	Если КодЕдиницыИзмерения = "354" Тогда // Секунда
	
		Элементы.ГруппаТрудоемкость.Видимость = Ложь;
	
	ИначеЕсли КодЕдиницыИзмерения = "355" Тогда // Минута
	
		Элементы.ГруппаТрудоемкость.Видимость = Ложь;
	
	ИначеЕсли КодЕдиницыИзмерения = "356" Тогда // Час
	
		Элементы.ГруппаТрудоемкость.Видимость = Ложь;
	
	ИначеЕсли КодЕдиницыИзмерения = "359" Тогда // Сутки
	
		Элементы.ГруппаТрудоемкость.Видимость = Ложь;
	
	Иначе
	
		Элементы.ГруппаТрудоемкость.Видимость = Истина;
	
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ЕдиницаИзмеренияПриИзмененииНаСервере()
	
	КодЕдиницыИзмерения = "";
	
	Если ЗначениеЗаполнено(Объект.ЕдиницаИзмерения) Тогда
	
		КодЕдиницыИзмерения = СокрЛП(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ЕдиницаИзмерения, "Код"));
	
	КонецЕсли; 
	
	Если КодЕдиницыИзмерения = "354" Тогда // Секунда
	
		Объект.Трудоемкость = 1;
		Объект.КратностьТрудоемкости = 3600;
		Элементы.ГруппаТрудоемкость.Видимость = Ложь;
	
	ИначеЕсли КодЕдиницыИзмерения = "355" Тогда // Минута
	
		Объект.Трудоемкость = 1;
		Объект.КратностьТрудоемкости = 60;
		Элементы.ГруппаТрудоемкость.Видимость = Ложь;
	
	ИначеЕсли КодЕдиницыИзмерения = "356" Тогда // Час
	
		Объект.Трудоемкость = 1;
		Объект.КратностьТрудоемкости = 1;
		Элементы.ГруппаТрудоемкость.Видимость = Ложь;
	
	ИначеЕсли КодЕдиницыИзмерения = "359" Тогда // Сутки
	
		Объект.Трудоемкость = 24;
		Объект.КратностьТрудоемкости = 1;
		Элементы.ГруппаТрудоемкость.Видимость = Ложь;
	
	Иначе
	
		Элементы.ГруппаТрудоемкость.Видимость = Истина;
	
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти
