#Область ОписаниеПеременных
// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Перем ФормаДлительнойОперации Экспорт;
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Параметры.Свойство("ОснованиеОбособленныйКонтрагент") Тогда
		НаОснованииОбособленногоКонтрагента = Истина;
	КонецЕсли;
	ЦветГиперссылки = ЦветаСтиля.ГиперссылкаЦвет;
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриЧтенииСозданииНаСервере();
		ЗаполнитьПоОснованию(Параметры);
	КонецЕсли;
	
	УстановитьПараметрыВыбораГоловногоКонтрагента();
	//++ Локализация
	Если Параметры.Ключ.Пустая() Тогда
		ЗаполнитьРеквизитыПоТекстуЗаполнения(Параметры.ТекстЗаполнения);
	КонецЕсли;
	//-- Локализация
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	ДополнительныеПараметрыКИ = УправлениеКонтактнойИнформацией.ПараметрыКонтактнойИнформации();
	ДополнительныеПараметрыКИ.Вставить("ИмяЭлементаДляРазмещения", "ГруппаКонтактнаяИнформация");
	ДополнительныеПараметрыКИ.Вставить("ПоложениеЗаголовкаКИ", ПоложениеЗаголовкаЭлементаФормы.Лево);
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтаФорма, Объект, ДополнительныеПараметрыКИ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереКонтрагент(ЭтотОбъект, Параметры);
	Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется = Ложь;
	КонецЕсли;
	РеквизитыПроверкиКонтрагентов.НеИспользоватьКэш = Истина;
	УстановитьРеквизитыПроверкиКонтрагента(ЭтотОбъект);
	ПроверкаКонтрагентовВызовСервераПереопределяемыйУТ.ПриСозданииНаСервереУправлениеВидимостью(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// ИнтернетПоддержкаПользователей.СПАРКРиски
	ДополнительныеПараметрыСПАРК = Неопределено;
	Контрагент = ?(Параметры.Ключ.Пустая(), Объект.ИНН, Объект.Ссылка);
	
	ВидКонтрагентаСПАРКРиски = Перечисления.ЮрФизЛицо.ВидКонтрагентаСПАРКРиски(Объект.Ссылка);
	
	ПараметрыПроцедуры = Новый Структура("ВариантОтображения", "Многострочный");
	СПАРКРиски.ПриСозданииНаСервере(
		ЭтотОбъект,
		Объект,
		Контрагент,
		ВидКонтрагентаСПАРКРиски,
		ПараметрыПроцедуры);
	// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
		
	// ИнтернетПоддержкаПользователей.СПАРКРиски
	СПАРКРиски.ДобавитьПодключаемыеКомандыКонтрагента(ЭтотОбъект, Объект, Элементы.ПодменюСПАРК, ДополнительныеПараметрыСПАРК);
	// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСправочника();
	ПараметрыПриСозданииНаСервере.Форма                 = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.КомандыЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСправочника(ПараметрыПриСозданииНаСервере);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриЧтенииСозданииНаСервере();
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	ПартнерыИКонтрагентыЛокализация.ОбработкаПроверкиЗаполненияНаСервереКонтрагент(Отказ, ПроверяемыеРеквизиты, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПередЗаписьюНаСервереКонтрагент(ЭтотОбъект, ТекущийОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПриОткрытииКонтрагент(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// ИнтернетПоддержкаПользователей.СПАРКРиски
	СПАРКРискиКлиент.ПриОткрытии(ЭтотОбъект, Объект);
	// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПриОткрытии = ОбменСКонтрагентамиКлиент.ПараметрыПриОткрытии();
	ПараметрыПриОткрытии.Форма                            = ЭтотОбъект;
	ПараметрыПриОткрытии.МестоРазмещенияКоманд            = Элементы.КомандыЭДО;
	ПараметрыПриОткрытии.ЕстьОбработчикОбновитьКомандыЭДО = Истина;
	
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ПараметрыПриОткрытии);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если НаОснованииОбособленногоКонтрагента И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОповеститьОВыборе(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ПартнерыИКонтрагентыЛокализацияКлиент.ПередЗаписьюКонтрагент(Отказ, ПараметрыЗаписи, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.СПАРКРиски
	СПАРКРискиКлиент.ОбработкаОповещения(ЭтотОбъект, Объект, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСправочника();
	ПараметрыОповещенияЭДО.Форма                            = ЭтотОбъект;
	ПараметрыОповещенияЭДО.МестоРазмещенияКоманд            = Элементы.КомандыЭДО;
	ПараметрыОповещенияЭДО.ЕстьОбработчикОбновитьКомандыЭДО = Истина;

	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСправочника(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьЗаголовокФормы();
	УправлениеДоступностью(ЭтаФорма);
	НастроитьПанельНавигации();
	УстановитьПараметрыВыбораГоловногоКонтрагента();
	
	ПараметрыЗаписиСПАРКРиски = ПараметрыЗаписи;
	// ИнтернетПоддержкаПользователей.СПАРКРиски
	СПАРКРиски.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписиСПАРКРиски);
	// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидКонтрагентаПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
	Если ВидКонтрагента = "ОбособленноеПодразделение" Тогда
		
		Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо");
		Объект.ОбособленноеПодразделение = Истина;
		
		Если Объект.ГоловнойКонтрагент = Объект.Ссылка Тогда
			Объект.ГоловнойКонтрагент = Неопределено;
		КонецЕсли;
		
	Иначе
		СтрокаЮрФизЛицо = "Перечисление.ЮрФизЛицо." + ВидКонтрагента;
		Объект.ЮрФизЛицо = ПредопределенноеЗначение(СтрокаЮрФизЛицо);
		Объект.ОбособленноеПодразделение = Ложь;
		
		Если Объект.ГоловнойКонтрагент <> Объект.Ссылка Тогда
			Объект.ГоловнойКонтрагент = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	УстановитьРеквизитыПроверкиКонтрагента(ЭтотОбъект);
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентаВСправочнике(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	УправлениеДоступностью(ЭтаФорма);
	ОтключитьОтметкуНезаполненного();
	
	// ИнтернетПоддержкаПользователей.СПАРКРиски
	ЭтотОбъект.ИндексыСПАРКРиски = Неопределено;
	ОбновитьОтображениеИндексыСПАРК();
	// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеСокращенноеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	ПартнерыИКонтрагентыКлиент.СокрЮрНаименованиеПриИзменении(Объект.Наименование, Объект.НаименованиеПолное);
КонецПроцедуры

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГоловнойКонтрагентПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	ОтключитьОтметкуНезаполненного();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереходКИсторииНаименованияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ИсторияНаименований" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТекущееНаименованиеПолное", Объект.НаименованиеПолное);
		ПараметрыФормы.Вставить("ИсторияНаименований", Объект.ИсторияНаименований);
		ПараметрыФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
		ПараметрыФормы.Вставить("ЮрФизлицо", Объект.ЮрФизЛицо);
		
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ИсторияНаименованийПослеЗакрытия", ЭтотОбъект);
		ОткрытьФорму("Справочник.Контрагенты.Форма.РедактированиеИсторииНаименований", ПараметрыФормы, ЭтотОбъект,,,,ОповещениеОЗакрытии);

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	ПартнерыИКонтрагентыЛокализацияКлиент.ПроверитьИНН(ЭтотОбъект);
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентаВСправочнике(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	ОтключитьОтметкуНезаполненного();
	
	// ИнтернетПоддержкаПользователей.СПАРКРиски
	ЭтотОбъект.ИндексыСПАРКРиски = Неопределено;
	ОбновитьОтображениеИндексыСПАРК();
	// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
КонецПроцедуры

&НаКлиенте
Процедура КПППриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентаВСправочнике(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИндексыСПАРКРискиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	// ИнтернетПоддержкаПользователей.СПАРКРиски
	СПАРКРискиКлиент.ОбработкаНавигационнойСсылки(ЭтотОбъект, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
	Возврат;
КонецПроцедуры

#Область УниверсальныеОбработчикиСобытий

&НаКлиенте
Процедура Подключаемый_ОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ПартнерыИКонтрагентыЛокализацияКлиент.ОкончаниеВводаТекста_Контрагент(Элемент,
		Текст,
		ДанныеВыбора,
		Параметры,
		СтандартнаяОбработка,
		ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент)
	ПартнерыИКонтрагентыЛокализацияКлиент.ПриИзмененииРеквизита_Контрагент(
		Элемент,
		ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаНавигационнойСсылкиФормы(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ПартнерыИКонтрагентыЛокализацияКлиент.ОбработкаНавигационнойСсылкиФормы_Контрагент(Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОкончанииИзмененияРеквизитаЛокализации(ИмяЭлемента, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.ТребуетсяВызовСервера Тогда
		ПриОкончанииИзмененияРеквизитаЛокализацииНаСервере(ИмяЭлемента, ДополнительныеПараметры.ПараметрыОбработки);
	КонецЕсли;
	
	Если ИмяЭлемента = "ГоловнойКонтрагент" Тогда
		ГоловнойКонтрагентПриИзменении(Элементы.ГоловнойКонтрагент);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриОкончанииИзмененияРеквизитаЛокализацииНаСервере(ИмяЭлемента, ПараметрыОбработки)
	
	ПартнерыИКонтрагентыЛокализация.ПриОкончанииИзмененияРеквизита_Контрагент(ИмяЭлемента, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКонтактнаяИнформация

// СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

// Обработчик события начало выбора подсистемы "Контактная информация"
// 
// Параметры:
// 	Элемент              - ПолеФормы - элемент формы, в котором произошло событие.
// 	ДанныеВыбора         - Структура - данные, используемые для выбора.
// 	СтандартнаяОбработка - Булево - признак стандартной обработки события.
//
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыОткрытия = Новый Структура("Страна", Объект.СтранаРегистрации);
	
	Отбор = Новый Структура("ИмяРеквизита", Элемент.Имя);
	Строки = ЭтаФорма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
	ДанныеСтроки = ?(Строки.Количество() = 0, Неопределено, Строки[0]);
	Если ДанныеСтроки <> Неопределено Тогда
		Если ДанныеСтроки.Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.МеждународныйАдресКонтрагента") Тогда
			ПараметрыОткрытия.Вставить("РазрешитьВводАдресаВСвободнойФорме", Ложь);
		КонецЕсли;
		Если (ДанныеСтроки.Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ЮрАдресКонтрагента")
			ИЛИ ДанныеСтроки.Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ФактАдресКонтрагента")) Тогда
			ПараметрыОткрытия.Вставить("Страна", Объект.СтранаРегистрации);
		КонецЕсли;
	КонецЕсли;
	
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка, ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка);
КонецПроцедуры

// Обработчик очистки контактной информации
// 
// Параметры:
// 	Элемент              - ПолеФормы - элемент формы, содержащей контактную информацию.
// 	СтандартнаяОбработка - Булево - признак стандартной обработки события.
//
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

// Обработчик выполнения команды подсистемы "Контактная информация"
// 
// Параметры:
// 	Команда - КомандаФормы -выполняемая команда
//
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.АвтоПодборАдреса(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

// Обработчик события обработка выбора подсистемы "Контактная информация"
// 
// Параметры:
// 	Элемент              - ПолеФормы - элемент формы, в котором произошло событие.
// 	ВыбранноеЗначение    - Структура - выбранная контактная информация.
// 	СтандартнаяОбработка - Булево - признак стандартной обработки события.
//
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент.Имя, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат) Экспорт
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтактнаяИнформация

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЛокализации(Команда)
	
	ПартнерыИКонтрагентыЛокализацияКлиент.ВыполнитьКомандуЛокализации(Команда, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьВыполнениеКомандыЛокализации(ИмяКоманды, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.ТребуетсяВызовСервера Тогда
		ПродолжитьВыполнениеКомандыЛокализацииНаСервере(ИмяКоманды, ДополнительныеПараметры.ПараметрыОбработки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПродолжитьВыполнениеКомандыЛокализацииНаСервере(ИмяКоманды, ПараметрыОбработки)
	
	ПартнерыИКонтрагентыЛокализация.ВыполнитьКомандуЛокализации(ЭтаФорма, ИмяКоманды, ПараметрыОбработки);
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКомандыЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбновитьКоманды(ЭтотОбъект, Объект);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура ЗаполнитьПоИНН(Команда)
	Подключаемый_ВыполнитьКомандуЛокализации(Команда);
	
	// ИнтернетПоддержкаПользователей.СПАРКРиски
	ЭтотОбъект.ИндексыСПАРКРиски = Неопределено;
	ОбновитьОтображениеИндексыСПАРК();
	// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ПартнерыИКонтрагентыЛокализация.УстановитьУсловноеОформлениеКонтрагент(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ПартнерыИКонтрагентыЛокализация.ПриЧтенииСозданииНаСервереКонтрагент(ЭтаФорма);
	
	ПравоИзмененияОбъекта = ПравоДоступа("Изменение", Метаданные.Справочники.Контрагенты);
	УпрощенныйВводДоступен = ПартнерыИКонтрагенты.УпрощенныйВводДоступен() ИЛИ ТолькоПросмотр;
	УстановитьЗаголовокФормы();
	
	Если Объект.ОбособленноеПодразделение Тогда
		ВидКонтрагента = "ОбособленноеПодразделение";
	ИначеЕсли ЗначениеЗаполнено(Объект.ЮрФизЛицо) Тогда
		ВидКонтрагента = ОбщегоНазначения.ИмяЗначенияПеречисления(Объект.ЮрФизЛицо);
	КонецЕсли;
	
	Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		Если Объект.ОбособленноеПодразделение Тогда
			ТолькоПросмотр = Истина;
		Иначе
			Элементы.ВидКонтрагента.СписокВыбора.Удалить(Элементы.ВидКонтрагента.СписокВыбора.НайтиПоЗначению("ОбособленноеПодразделение"));
		КонецЕсли;
	КонецЕсли;
	
	УправлениеДоступностью(ЭтаФорма);
	НастроитьПанельНавигации();

КонецПроцедуры

&НаСервере
Процедура НастроитьПанельНавигации()

	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ИспользоватьДанныеКонтрагентаФизическогоЛица", Объект.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо);
	
	ОбщегоНазначенияУТ.НастроитьФормуПоПараметрам(ЭтаФорма, СтруктураНастроек);

КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()
	Если Объект.Ссылка.Пустая() Тогда
		Заголовок = НСтр("ru = 'Контрагент (создание)';
						|en = 'Counterparty (Create)'");
	Иначе
		Заголовок = Объект.Наименование + " (" + НСтр("ru = 'Контрагент (юридическое или физическое лицо)';
														|en = 'Counterparty: business or person'");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованию(Параметры)
	Если Параметры.Свойство("Основание") И ТипЗнч(Параметры.Основание) = Тип("Структура") Тогда
		
		Если Параметры.Основание.Свойство("АдресЭППартнера") И ЗначениеЗаполнено(Параметры.Основание.АдресЭППартнера) Тогда
			СтруктураДанных = Новый Структура;
			СтруктураДанных.Вставить("Представление", Параметры.Основание.АдресЭППартнера);
			СтруктураДанных.Вставить("КонтактнаяИнформация", "");
			ПартнерыИКонтрагенты.ЗаполнитьЭлементКонтактнойИнформации(ЭтотОбъект,
			                                                          ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailКонтрагента"),
			                                                          СтруктураДанных);
		КонецЕсли;
		
		Если Параметры.Основание.Свойство("СокращенноеНаименование") И ЗначениеЗаполнено(Параметры.Основание.СокращенноеНаименование) Тогда
			Объект.НаименованиеПолное = Параметры.Основание.СокращенноеНаименование;
		КонецЕсли;
		
		Если Параметры.Основание.Свойство("ПредставлениеАдреса") И ЗначениеЗаполнено(Параметры.Основание.ПредставлениеАдреса) Тогда
			СтруктураДанных = Новый Структура;
			СтруктураДанных.Вставить("Представление", Параметры.Основание.ПредставлениеАдреса);
			СтруктураДанных.Вставить("КонтактнаяИнформация", "");
			Если Параметры.Основание.Свойство("Адрес") Тогда
				СтруктураДанных.Вставить("КонтактнаяИнформация", Параметры.Основание.Адрес);
			КонецЕсли;
			ПартнерыИКонтрагенты.ЗаполнитьЭлементКонтактнойИнформации(ЭтотОбъект,
				                                                          ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ФактАдресКонтрагента"),
				                                                          СтруктураДанных);
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)
	
	ПартнерыИКонтрагентыЛокализацияКлиентСервер.УправлениеЭлементамиЮридическихРеквизитов(Форма);
	ПартнерыИКонтрагентыЛокализацияКлиентСервер.УправлениеДоступностьюКонтрагент(Форма);
	
	ПартнерыИКонтрагентыЛокализацияКлиентСервер.ОбновитьСтрокиИсторииНаименований(Форма.Объект.ИсторияНаименований,
		Форма.ПереходКИсторииНаименования,
		Форма.ЦветГиперссылки);
	Форма.Элементы.НаименованиеСокращенное.ТолькоПросмотр = Форма.Объект.ИсторияНаименований.Количество() > 1;
	
	Форма.Элементы.Партнер.Видимость = НЕ ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораГоловногоКонтрагента()
	
	ПараметрыВыбораГоловногоКонтрагента = Новый Массив;
	Для Каждого ПараметрВыбора Из Элементы.ГоловнойКонтрагент.ПараметрыВыбора Цикл
		
		ПараметрыВыбораГоловногоКонтрагента.Добавить(ПараметрВыбора);
		
	КонецЦикла;
	
	ПараметрыВыбораГоловногоКонтрагента.Добавить(Новый ПараметрВыбора("ИсключаяКонтрагента", Объект.Ссылка));
	Элементы.ГоловнойКонтрагент.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораГоловногоКонтрагента);
	
КонецПроцедуры

#Область ПериодическиеРеквизиты

&НаКлиенте
Процедура ИсторияНаименованийПослеЗакрытия(Результат, ДополнительныеПараметры) Экспорт

	ОчиститьСообщения();
	
	Если ТипЗнч(Результат) = Тип("Структура")
		И Результат.Свойство("ИсторияНаименований") Тогда
		
		Модифицированность = Истина;
		НоваяИсторияНаименований = Результат.ИсторияНаименований;
		НоваяИсторияНаименований.Сортировать("Период");
	
		Объект.ИсторияНаименований.Очистить();
		Если НоваяИсторияНаименований.Количество() > 1 Тогда
			Для Каждого СтрокаИстории Из НоваяИсторияНаименований Цикл
				ЗаписьИстории = Объект.ИсторияНаименований.Добавить();
				ЗаполнитьЗначенияСвойств(ЗаписьИстории, СтрокаИстории);
			КонецЦикла;
		КонецЕсли;
		
		НовоеТекущееНаименование = НоваяИсторияНаименований[НоваяИсторияНаименований.Количество()-1].НаименованиеПолное;
		
		Если НовоеТекущееНаименование <> Объект.НаименованиеПолное Тогда
			
			Объект.НаименованиеПолное = НовоеТекущееНаименование;
			
		КонецЕсли;
		
		УправлениеДоступностью(ЭтаФорма);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

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
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#Область ПроверкаКонтрагентов
// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьРеквизитыПроверкиКонтрагента(Форма)
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		Форма.РеквизитыПроверкиКонтрагентов.ЮрФизЛицо                 = Форма.Объект.ЮрФизЛицо;
		Форма.РеквизитыПроверкиКонтрагентов.ЭтоЮридическоеЛицо        = (Форма.Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо") 
		                                                            Или  Форма.Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент"));
		// Здесь как иностранных контрагентов указываем всех контрагентов, которые не подлежат проверке.
		Форма.РеквизитыПроверкиКонтрагентов.ЭтоИностранныйКонтрагент  = Форма.Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент")
		                                                                Или Форма.Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПоТекстуЗаполнения(ТекстЗаполнения)

	Если ПустаяСтрока(ТекстЗаполнения) Тогда
		
		Возврат;
	
	ИначеЕсли ЭтоИНН(ТекстЗаполнения) Тогда 
	
		Объект.Наименование = "";
		Объект.ИНН = ТекстЗаполнения;
		Объект.ЮрФизЛицо = ?(СтрДлина(ТекстЗаполнения) = 10,
			Перечисления.ЮрФизЛицо.ЮрЛицо,
			Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель);
			
		ТекстЗаполнения = Неопределено;
		
	Иначе 
		
		Объект.Наименование = ТекстЗаполнения;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоИНН(СтрокаИНН)
	Возврат ЗначениеЗаполнено(СтрокаИНН)
		И ТипЗнч(СтрокаИНН) = Тип("Строка")
		И (СтрДлина(СтрокаИНН) = 10 ИЛИ СтрДлина(СтрокаИНН) = 12)
		И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаИНН);
КонецФункции 
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

&НаКлиенте
Процедура ПроверитьКонтрагента(Команда)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПроверитьКонтрагентаПоКнопке(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область Локализация

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

// ИнтернетПоддержкаПользователей.СПАРКРиски
&НаКлиенте
Процедура Подключаемый_ОбновитьОтображениеИндексыСПАРК()
	ОбновитьОтображениеИндексыСПАРК();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеИндексыСПАРК()
	
	Если Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо")
		Или Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент") Тогда
			ВидКонтрагентаБИП = ПредопределенноеЗначение("Перечисление.ВидыКонтрагентовСПАРКРиски.ЮридическоеЛицо");
	ИначеЕсли Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ИндивидуальныйПредприниматель") Тогда
		ВидКонтрагентаБИП = ПредопределенноеЗначение("Перечисление.ВидыКонтрагентовСПАРКРиски.ИндивидуальныйПредприниматель");
	Иначе
		ВидКонтрагентаБИП = ПредопределенноеЗначение("Перечисление.ВидыКонтрагентовСПАРКРиски.ПустаяСсылка");
	КонецЕсли;
	
	ПараметрыОтображения = Новый Структура("ВариантОтображения", "Многострочный");
	СПАРКРискиКлиент.ОтобразитьИндексыСПАРК(
		ЭтотОбъект.ИндексыСПАРКРиски,
		Объект,
		Объект.ИНН, // Искать по ИНН
		ВидКонтрагентаБИП,
		ЭтотОбъект,
		ПараметрыОтображения,
		Истина);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду1СПАРКРиски(Команда)
	СПАРКРискиКлиент.ВыполнитьПодключаемуюКоманду(Команда, ЭтотОбъект, Объект);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.СПАРКРиски

//++ Локализация
&НаКлиенте
Процедура ФоновоеЗаданиеПроверитьНаКлиенте()
	
	РезультатВыполнения = ПартнерыИКонтрагентыЛокализацияВызовСервера.ФоновоеЗаданиеВыполнено(ФоновоеЗаданиеИдентификатор, ФоновоеЗаданиеАдресХранилища);
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ПартнерыИКонтрагентыЛокализацияКлиент.ВыполнитьЗаполнениеРеквизитовПоИНН(ЭтаФорма, РезультатВыполнения.РеквизитыКонтрагента);
	Иначе
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчика);
		ПодключитьОбработчикОжидания("ФоновоеЗаданиеПроверитьНаКлиенте", ПараметрыОбработчика.ТекущийИнтервал, Истина);
	КонецЕсли;
	
КонецПроцедуры
//-- Локализация

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов()
	ПроверкаКонтрагентовКлиент.ПредложитьВключитьПроверкуКонтрагентов(ЭтотОбъект);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ОбработатьРезультатПроверкиКонтрагентов()
	ПроверкаКонтрагентовКлиент.ОбработатьРезультатПроверкиКонтрагентовВСправочнике(ЭтотОбъект);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

#КонецОбласти

#Область УХ_Внедрение

&НаКлиенте
Процедура Подключаемый_ОткрытьПараметрыКлассификаторов(Команда)
	
	ПроверитьЗаписанностьОбъекта(НСтр("ru = 'Классификаторы'"), Новый ОписаниеОповещения("Подключаемый_ОткрытьПараметрыКлассификаторовОбъектЗаписан", ЭтотОбъект));
			
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПараметрыКлассификаторовОбъектЗаписан(Результат, ДополнительныеПараметры) Экспорт
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("КодОКОПФ", Объект.КодОКОПФ);
	СтруктураПараметров.Вставить("НаименованиеОКОПФ", Объект.НаименованиеОКОПФ);
	
	ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаПараметрыКлассификаторовУХ", СтруктураПараметров, ЭтаФорма,,,, Новый ОписаниеОповещения("Подключаемый_ОткрытьПараметрыКлассификаторовЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПараметрыКлассификаторовЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    СтруктураПараметров = Результат;
    
    Если ЗначениеЗаполнено(СтруктураПараметров) И СтруктураПараметров <> КодВозвратаДиалога.Отмена Тогда
        ЗаполнитьЗначенияСвойств(Объект, СтруктураПараметров);
        ЗаполнитьОписаниеКлассификаторов();
        Модифицированность = Истина;	
    КонецЕсли;
    
    Возврат;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОрганизационнаяЕдиницаУХПриИзменении(Элемент)
	
	ЗначенияРеквизитов = ОбщегоНазначенияУХ.ПолучитьЗначенияРеквизитов(
							Объект.ОрганизационнаяЕдиница, 
							"ИНН,КПП,СтранаРегистрации,ЮридическоеФизическоеЛицо,ОбособленноеПодразделение");
							
	ЗаполнитьЗначенияСвойств(Объект, ЗначенияРеквизитов);
							
	ВидКонтрагентаПриИзменении(Элементы.ВидКонтрагента);// заполнить по ИНН и КПП
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьДокументРазмерКонтрагента(Команда) Экспорт
	НайденныйДокумент = НайтиДокументРегистрацииРазмера(Объект.Ссылка);
	Если ЗначениеЗаполнено(НайденныйДокумент) Тогда
		ПоказатьЗначение(, НайденныйДокумент);
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Контрагент", Объект.Ссылка);
		ОткрытьФорму("Документ.РегистрацияРазмераКонтрагентаДляЕИС.Форма.ФормаДокумента", ПараметрыФормы);
	КонецЕсли;
КонецПроцедуры		// Подключаемый_ОткрытьДокументРазмерКонтрагента()

&НаКлиенте
Процедура ПроверитьЗаписанностьОбъекта(ИмяФормы, ОповещениеПослеЗаписи, ТекстВопроса = Неопределено)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если ТекстВопроса = Неопределено Тогда
			ТекстВопроса = Нстр("ru = 'Данные еще не записаны.
			|Переход к ""%ИмяФормы%"" возможен только после записи данных.
			|Данные будут записаны.'");
			ТекстВопроса = СтрЗаменить(ТекстВопроса, "%ИмяФормы%", ИмяФормы);
		КонецЕсли;
				
		ПоказатьВопрос(Новый ОписаниеОповещения("ПроверитьЗаписанностьОбъектаОбработкаОтвета", ЭтотОбъект, ОповещениеПослеЗаписи), ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		Возврат;
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОповещениеПослеЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаписанностьОбъектаОбработкаОтвета(КодОтвета, ДополнительныеПараметры) Экспорт
	
	Если КодОтвета = КодВозвратаДиалога.ОК Тогда 
		
		ЭлементЗаписан = Записать();
		
		Если Не ЭлементЗаписан Тогда
			Возврат;
		КонецЕсли;
		
	    Оповещение = ДополнительныеПараметры;
		
		ВыполнитьОбработкуОповещения(Оповещение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОписаниеКлассификаторов() экспорт
	
	СтрокаОписанияКлассификаторов = НСтр("ru = 'ОКОПФ: %КодОКОПФ%. Организационно-правовая форма: %НаименованиеОКОПФ%.'");
										   													
	СтрокаОписанияКлассификаторов = СтрЗаменить(СтрокаОписанияКлассификаторов,
												"%КодОКОПФ%",    
												?(ЗначениеЗаполнено(Объект.КодОКОПФ), Объект.КодОКОПФ, НСтр("ru = 'не указано'")));
	СтрокаОписанияКлассификаторов = СтрЗаменить(СтрокаОписанияКлассификаторов, 
												"%НаименованиеОКОПФ%",    
												?(ЗначениеЗаполнено(Объект.НаименованиеОКОПФ), Объект.НаименованиеОКОПФ, НСтр("ru = 'не указано'")));
	
	Элементы.ДекорацияОписаниеКлассификаторов.Заголовок = СтрокаОписанияКлассификаторов;
	
КонецПроцедуры

// Возвращает документ, регистрирующий размер для текущего контрагента.
&НаСервереБезКонтекста
Функция НайтиДокументРегистрацииРазмера(СсылкаВход)
	ПустойДокумент = Документы.РегистрацияРазмераКонтрагентаДляЕИС.ПустаяСсылка();
	РезультатФункции = ПустойДокумент;
	Если ЗначениеЗаполнено(СсылкаВход) Тогда
		РезультатФункции = РегистрыСведений.РазмерыКонтрагентовДляЕИС.НайтиДокументРегистрацииРазмера(СсылкаВход);
	Иначе
		РезультатФункции = ПустойДокумент;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции		 // НайтиДокументРегистрацииРазмера()

#КонецОбласти 
