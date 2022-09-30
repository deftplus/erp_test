#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	#Область УниверсальныеПроцессыСогласование
	ВстраиваниеОПКПереопределяемый.НарисоватьПанельСогласованияИОпределитьСостояниеОбъекта(ЭтаФорма);
	#КонецОбласти
	
	Если Параметры.Ключ.Пустая() Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
		
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ПриЧтенииСозданииНаСервере();
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	#Область УниверсальныеПроцессыСогласование
	Если ИмяСобытия = "ОбъектСогласован" Тогда
		ОпределитьСостояниеОбъекта();	
	ИначеЕсли ИмяСобытия = "ОбъектОтклонен" Тогда
		ОпределитьСостояниеОбъекта();	
	ИначеЕсли ИмяСобытия = "МаршрутИнициализирован" Тогда
		ОпределитьСостояниеОбъекта();		
	ИначеЕсли ИмяСобытия = "СостояниеЗаявкиПриИзменении" Тогда
		ОпределитьСостояниеОбъекта();
	КонецЕсли;
	#КонецОбласти
	
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

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	АналитикиСтатейБюджетовУХ.ЗаполнитьВидыАналитикиИзТаблицы(ЭтотОбъект, ТекущийОбъект, Отказ);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область АналитикиСтатьиБюджета

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	АналитикиСтатейБюджетовУХ.ПодготовитьТаблицуВидовАналитик(ЭтотОбъект, ЭтотОбъект, Элементы.ГруппаВидыАналитик);
КонецПроцедуры

&НаКлиенте
Процедура ВидыАналитикПриИзменении(Элемент)
	АналитикиСтатейБюджетовУХКлиент.ВидыАналитикПриИзменении(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияБлокирующиеСсылкиНажатие(Элемент)
	АналитикиСтатейБюджетовУХКлиент.ДекорацияБлокирующиеСсылкиНажатие(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииПараметровЛимитирования(Элемент)
	
	ПриИзмененииПараметровЛимитированияНаСервере(Элемент.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииПараметровЛимитированияНаСервере(ИмяЭлемента)
	
	АналитикиСтатейБюджетовУХ.ПриИзмененииПараметровЛимитирования(ЭтотОбъект, ИмяЭлемента);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаРаскрытияПриИзменении(Элемент)
	ЗаполнитьВидыАналитикПоГруппеРаскрытияНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидыАналитикПоГруппеРаскрытияНаСервере()
	АналитикиСтатейБюджетовУХ.ЗаполнитьВидыАналитикПоГруппеРаскрытияВФорме(ЭтотОбъект, Объект.ГруппаРаскрытия);
КонецПроцедуры

#КонецОбласти

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
    УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область УниверсальныеПроцессыСогласование

&НаКлиенте
Процедура ПринятьКСогласованию_Подключаемый() Экспорт
	ВстраиваниеОПККлиентПереопределяемый.ПринятьКСогласованию(ЭтаФорма, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ИсторияСогласования_Подключаемый() Экспорт
	ВстраиваниеОПККлиентПереопределяемый.ИсторияСогласования(ЭтаФорма, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура СогласоватьДокумент_Подключаемый() Экспорт
	ВстраиваниеОПККлиентПереопределяемый.СогласоватьДокумент(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьСогласование_Подключаемый() Экспорт
	ВстраиваниеОПККлиентПереопределяемый.ОтменитьСогласование(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура МаршрутСогласования_Подключаемый() Экспорт
	ВстраиваниеОПККлиентПереопределяемый.МаршрутСогласования(ЭтаФорма, Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ОпределитьСостояниеОбъекта(ОбновитьОтветственныхВход = Ложь)
	ВстраиваниеОПКПереопределяемый.ОпределитьСостояниеЗаявки(ЭтаФорма, ОбновитьОтветственныхВход);
КонецПроцедуры

#КонецОбласти
