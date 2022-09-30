
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
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

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаНачалаЗакупокПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДатаНачалаЗакупок) 
		И ЗначениеЗаполнено(Объект.ДатаНачалаПродаж) 
		И Объект.ДатаНачалаЗакупок > Объект.ДатаНачалаПродаж Тогда
		Объект.ДатаНачалаПродаж = Объект.ДатаНачалаЗакупок;
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(Объект.ДатаНачалаЗакупок) 
		И ЗначениеЗаполнено(Объект.ДатаЗапретаЗакупки) 
		И Объект.ДатаНачалаЗакупок > Объект.ДатаЗапретаЗакупки Тогда
		Объект.ДатаЗапретаЗакупки = КонецДня(Объект.ДатаНачалаЗакупок)+1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаЗапретаЗакупкиПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДатаНачалаЗакупок) 
		И ЗначениеЗаполнено(Объект.ДатаЗапретаЗакупки) 
		И Объект.ДатаНачалаЗакупок > Объект.ДатаЗапретаЗакупки Тогда
		Объект.ДатаЗапретаЗакупки = КонецДня(Объект.ДатаНачалаЗакупок)+1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПродажПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДатаНачалаЗакупок) 
		И ЗначениеЗаполнено(Объект.ДатаНачалаПродаж) 
		И Объект.ДатаНачалаЗакупок > Объект.ДатаНачалаПродаж Тогда
		Объект.ДатаНачалаПродаж = Объект.ДатаНачалаЗакупок;
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(Объект.ДатаНачалаЗакупок) 
		И ЗначениеЗаполнено(Объект.ДатаЗапретаПродажи) 
		И Объект.ДатаНачалаПродаж > Объект.ДатаЗапретаПродажи Тогда
		Объект.ДатаЗапретаПродажи = КонецДня(Объект.ДатаНачалаПродаж)+1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаЗапретаПродажиПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДатаНачалаПродаж) 
		И ЗначениеЗаполнено(Объект.ДатаЗапретаПродажи) 
		И Объект.ДатаНачалаПродаж > Объект.ДатаЗапретаПродажи Тогда
		Объект.ДатаЗапретаПродажи = КонецДня(Объект.ДатаНачалаПродаж)+1;
	КонецЕсли;
	
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

#КонецОбласти

