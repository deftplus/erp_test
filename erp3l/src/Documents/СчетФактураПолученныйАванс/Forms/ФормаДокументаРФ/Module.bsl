#Область ОписаниеПеременных

&НаКлиенте
Перем ПроверкаКонтрагентовПараметрыОбработчикаОжидания Экспорт;

&НаКлиенте
Перем ФормаДлительнойОперации Экспорт;

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если СообщитьЧтоНетДанных Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не обнаружены данные для регистрации счета-фактуры.';
																|en = 'Data for registering the tax invoice is not detected.'")); 
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПриОткрытииДокумент(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Основание) 
		И (ТипЗнч(Параметры.Основание) = Тип("ДокументСсылка.СписаниеБезналичныхДенежныхСредств") 
		ИЛИ ТипЗнч(Параметры.Основание) = Тип("ДокументСсылка.РасходныйКассовыйОрдер")) Тогда
		
		Если Объект.Авансы.Количество() = 0 Тогда
			СообщитьЧтоНетДанных = Истина; 
		КонецЕсли; 
	КонецЕсли; 
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.ГруппаИтого.ЦветФона = Новый Цвет();
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереДокумент(ЭтотОбъект, Параметры);
	ПроверкаКонтрагентовВызовСервераПереопределяемыйУТ.ФормаДокументаПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыЭДОПриСоздании = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаДокумента();
	ПараметрыЭДОПриСоздании.Форма = ЭтотОбъект;
	ПараметрыЭДОПриСоздании.ДокументССылка = Объект.Ссылка;
	ПараметрыЭДОПриСоздании.КонтроллерСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыЭДОПриСоздании.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	ПараметрыЭДОПриСоздании.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаДокумента(ПараметрыЭДОПриСоздании);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	Элементы.ДекорацияСостояниеЭДО.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭД");
	
	УчетНДСУПСлужебный.НастроитьСовместныйВыборКонтрагентовОрганизаций(Элементы.Контрагент, Объект.Контрагент);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// СтандартныеПодсистемы.РаботаСФайлами
	ПараметрыГиперссылки = РаботаСФайлами.ГиперссылкаФайлов();
	ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПослеЗаписи = ОбменСКонтрагентами.ПараметрыПослеЗаписиНаСервере();
	ПараметрыПослеЗаписи.Форма = ЭтотОбъект;
	ПараметрыПослеЗаписи.ДокументСсылка = Объект.Ссылка;
	ПараметрыПослеЗаписи.КонтроллерСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыПослеЗаписи.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;

	ОбменСКонтрагентами.ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи, ПараметрыПослеЗаписи);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами	
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();

	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыЭДОПриСоздании = ОбменСКонтрагентами.ПараметрыПриЧтенииНаСервере_ФормаДокумента();
	ПараметрыЭДОПриСоздании.Форма = ЭтотОбъект;
	ПараметрыЭДОПриСоздании.ДокументСсылка = Объект.Ссылка;
	ПараметрыЭДОПриСоздании.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ПараметрыЭДОПриСоздании.КонтроллерСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыЭДОПриСоздании.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	ОбменСКонтрагентами.ПриЧтенииНаСервере_ФормаДокумента(ПараметрыЭДОПриСоздании);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
		
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПослеЗаписи_ФормаДокумента(ЭтаФорма, ПараметрыЗаписи);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами	

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПередЗаписьюНаСервереДокумент(ЭтотОбъект, ТекущийОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьДокументИБПослеЗаполнения"  И Параметр.Найти(Объект.Ссылка) <> Неопределено Тогда
		ЭтаФорма.Прочитать();
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыОповещения = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаДокумента();
	ПараметрыОповещения.Форма = ЭтотОбъект;
	ПараметрыОповещения.ДокументСсылка = Объект.Ссылка;
	ПараметрыОповещения.КонтроллерСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыОповещения.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаДокумента(ИмяСобытия, Параметр, Источник, ПараметрыОповещения);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаСоставленияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.Дата) Тогда
		ЗаполнитьДатуПолучения();
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаИсправленияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.Дата) Тогда
		ЗаполнитьДатуПолучения();
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученПриИзменении(Элемент)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Объект.Дата);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	ПолученПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура КорректировочныйПриИзменении(Элемент)
	
	Если Объект.Корректировочный Тогда
		Объект.СоставленКомиссионеромОтИмениПродавца = Ложь;
	КонецЕсли;
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтаФорма);
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		ДанныеОснования = ПолучитьДанныеОснованияНаСервере(Объект.ДокументОснование);
		
		ЗаполнитьЗначенияСвойств(Объект, ДанныеОснования);
		
		// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
		ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элементы.Контрагент);
		// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокКодовВидовОпераций.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("КодВидаОперацииНачалоВыбораЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииНачалоВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		Объект.КодВидаОперации = ВыбранныйЭлемент.Значение;
		ОбновитьПредставлениеВидаОперации(ЭтаФорма);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииПриИзменении(Элемент)
	
	ОбновитьПредставлениеВидаОперации(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЭДОНажатие(Элемент, СтандартнаяОбработка)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.СостояниеЭДОНажатие_ФормаДокумента(ЭтотОбъект, СтандартнаяОбработка);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура СоставленКомиссионеромОтИмениПродавцаПриИзменении(Элемент)
	
	СоставленКомиссионеромОтИмениПродавцаПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстПродавцыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	Если НавигационнаяСсылка = "ОткрытьФормуПродавцы" Тогда
		
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
		
		СписокПродавцов = Новый СписокЗначений;
		Для каждого Строка Из Объект.Продавцы Цикл
			
			ДанныеПродавца = Новый Структура("Продавец, ИННПродавца, КПППродавца");
			ЗаполнитьЗначенияСвойств(ДанныеПродавца, Строка);
			СписокПродавцов.Добавить(ДанныеПродавца);
			
		КонецЦикла;
	
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Продавцы", СписокПродавцов);
		ПараметрыФормы.Вставить("ДатаСведений", ДатаСведений(Объект)); 
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПродавцыЗавершениеВыбора", ЭтотОбъект);
		
		ОткрытьФорму("Документ.СчетФактураПолученный.Форма.ФормаПродавцы", 
			ПараметрыФормы, 
			ЭтаФорма, 
			, 
			, 
			,
			ОписаниеОповещения, 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	ИначеЕсли НавигационнаяСсылка = "ВыбратьПродавца" Тогда
		
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПродавецЗавершениеВыбора", ЭтотОбъект);
		ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора"
			, 
			, 
			ЭтаФорма, 
			, 
			, 
			, 
			ОписаниеОповещения, 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	Если Объект.Контрагент = Неопределено Тогда
		Объект.Контрагент = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.Контрагенты.ПустаяСсылка");
	КонецЕсли;
	
	ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы(Истина);
	УправлениеДоступностью(ЭтотОбъект);
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	ПриИзмененииКлючевыхРеквизитовСостояниеЭДО();
	
КонецПроцедуры

&НаКлиенте
Процедура КППКонтрагентаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СписокВыбораКПП.Количество() = 0 Тогда
		
		Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
			ЗаполнитьСписокВыбораКПП(СписокВыбораКПП, Объект.Контрагент, ДатаСведений(Объект));
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеВыбора = СписокВыбораКПП;
	
КонецПроцедуры

&НаКлиенте
Процедура КППКонтрагентаПриИзменении(Элемент)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ИННКонтрагентаПриИзменении(Элемент)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура НалогообложениеНДСПриИзменении(Элемент)
	
	НалогообложениеНДСПриИзмененииНаСервере();
	Для Каждого СтрокаАванса Из Объект.Авансы Цикл
		РассчитатьСуммуНДС(СтрокаАванса, "СуммаКомиссия", "СуммаНДСКомиссия");
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАвансы

&НаКлиенте
Процедура АвансыСуммаПриИзменении(Элемент)
	
	РассчитатьСуммуНДС(Элементы.Авансы.ТекущиеДанные, "Сумма", "СуммаНДС");
	
КонецПроцедуры

&НаКлиенте
Процедура АвансыСтавкаНДСПриИзменении(Элемент)

	РассчитатьСуммуНДС(Элементы.Авансы.ТекущиеДанные, "Сумма", "СуммаНДС");
	РассчитатьСуммуНДС(Элементы.Авансы.ТекущиеДанные, "СуммаКомиссия", "СуммаНДСКомиссия");
	
КонецПроцедуры

&НаКлиенте
Процедура АвансыСуммаКомиссияПриИзменении(Элемент)
	
	РассчитатьСуммуНДС(Элементы.Авансы.ТекущиеДанные, "СуммаКомиссия", "СуммаНДСКомиссия");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	 РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

&НаКлиенте
Процедура УказатьИсходныйСчетФактуру(Команда)
	
	ВыделенныеСтроки = Элементы.Авансы.ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() Тогда
		ВыборСчетаФактуры(Ложь, ВыделенныеСтроки);
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриИзмененииКлючевыхРеквизитовСостояниеЭДО()
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	ПараметрыПриИзменении = ОбменСКонтрагентами.ПараметрыПриИзмененииКлючевыхРеквизитовЭДО();
	
	ПараметрыПриИзменении.Форма                 = ЭтотОбъект;
	ПараметрыПриИзменении.ДокументСсылка        = Объект.Ссылка;
	ПараметрыПриИзменении.ДокументОбъект        = РеквизитФормыВЗначение("Объект");
	ПараметрыПриИзменении.КонтроллерСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыПриИзменении.ГруппаСостояниеЭДО    = Элементы.ГруппаСостояниеЭДО;
	
	ОбменСКонтрагентами.ПриИзмененииКлючевыхРеквизитовЭДО(ПараметрыПриИзменении);
	
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

#Область РаботаСКонтрагентами
// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов()
	ПроверкаКонтрагентовКлиент.ПредложитьВключитьПроверкуКонтрагентов(ЭтотОбъект);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ОбработатьРезультатПроверкиКонтрагентов()
	ПроверкаКонтрагентовКлиент.ОбработатьРезультатПроверкиКонтрагентовВДокументе(ЭтотОбъект);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаСервере
Процедура ОтобразитьРезультатПроверкиКонтрагента() Экспорт
	ПроверкаКонтрагентов.ОтобразитьРезультатПроверкиКонтрагентаВДокументе(ЭтотОбъект);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаСервере
Процедура ПроверитьКонтрагентовФоновоеЗадание(ПараметрыФоновогоЗадания) Экспорт
	ПроверкаКонтрагентов.ПроверитьКонтрагентовВДокументеФоновоеЗадание(ЭтотОбъект, ПараметрыФоновогоЗадания);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Процедура ПроверитьКонтрагентов(Команда)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПроверитьКонтрагентовВДокументеПоКнопке(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	УчетНДСУП.УстановитьУсловноеОформлениеСуммНДСПоНалогообложениюЗакупки(ЭтаФорма, "АвансыСтавкаНДС", "АвансыСуммаНДС", "АвансыСуммаНДС");
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.АвансыИсходныйСчетФактура.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Корректировочный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы();
	УправлениеДоступностью(ЭтаФорма);
	ЗаполнитьСписокКодовВидовОпераций();
	ОбновитьИнформациюПоПродавцам();
	
	ЕстьПравоНаРедактирование = ПравоДоступа("Изменение", Метаданные.Документы.СчетФактураПолученныйАванс);
	ОбновитьИнформациюПоСчетуФактуреОснованию();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	ТипОснования = ТипЗнч(Объект.ДокументОснование);
	
	ДоступностьПоляКонтрагент = (ТипОснования = Тип("ДокументСсылка.ВводОстатков")
								ИЛИ ТипОснования = Тип("ДокументСсылка.ВводОстатковВзаиморасчетов")
								ИЛИ ТипОснования = Тип("ДокументСсылка.АвансовыйОтчет")
								ИЛИ ТипОснования = Тип("ДокументСсылка.ВзаимозачетЗадолженности"));
	
	Элементы.Контрагент.Доступность = ДоступностьПоляКонтрагент;
	
	ТипКонтрагентаКонтрагент = ТипЗнч(Объект.Контрагент) = Тип("СправочникСсылка.Контрагенты");
	
	Элементы.ИННКонтрагента.Доступность = ТипКонтрагентаКонтрагент 
	                                       И ЗначениеЗаполнено(Объект.Контрагент);
	Элементы.КППКонтрагента.Доступность = ТипКонтрагентаКонтрагент
	                                       И ЗначениеЗаполнено(Объект.Контрагент)
	                                       И Форма.КонтрагентЮрЛицо;
	
	Элементы.ГруппаНомерДатаИсправления.Видимость = Объект.Исправление;
	Элементы.ГруппаНомерДатаПриИсправлении.Видимость = Объект.Исправление;
	Элементы.ГруппаНомерДата.Видимость = Не Объект.Исправление;
	Элементы.АвансыУказатьИсходныйСчетФактуру.Видимость = Объект.Корректировочный;
	Элементы.ГруппаСоставленОтИмени.Видимость = Не Объект.Корректировочный;
	
	Элементы.ТекстПродавцы.Доступность = Объект.СоставленКомиссионеромОтИмениПродавца;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеОснованияНаСервере(ДокументОснование)
	
	ДанныеОснования = Новый Структура;
	
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ВозвратТоваровМеждуОрганизациями") Тогда
		
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, "Контрагент,РасчетыЧерезОтдельногоКонтрагента,ОрганизацияПолучатель");
		Если ЗначенияРеквизитов.РасчетыЧерезОтдельногоКонтрагента Тогда
			Контрагент = ЗначенияРеквизитов.Контрагент;
		Иначе
			Контрагент = ЗначенияРеквизитов.ОрганизацияПолучатель;
		КонецЕсли; 
		ДанныеОснования.Вставить("Контрагент", Контрагент);
		
	ИначеЕсли ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.ВводОстатков")
		И ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.ВводОстатковВзаиморасчетов")
		И ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.АвансовыйОтчет")
		И ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.ВзаимозачетЗадолженности") Тогда
		
		ДанныеОснования.Вставить("Контрагент", ДоходыИРасходыСервер.ПолучитьКонтрагентаИзОснования(ДокументОснование));
	КонецЕсли;
	
	Возврат ДанныеОснования;

КонецФункции

&НаКлиенте
Процедура ИсправлениеПриИзменении(Элемент)
	
	Если Не Объект.Исправление Тогда
		
		Объект.Номер = "";
		Объект.НомерИсправления = "";
		
		ОчиститьДокументыОснования();
		
	Иначе
		
		ОбновитьИнформациюПоСчетуФактуреОснованию();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстСчетФактураОснованиеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	Если НавигационнаяСсылка = "ОткрытьИсходныеСчетаФактуры" Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьСчетФактуруОснование();
	ИначеЕсли  НавигационнаяСсылка = "ВыборСчетаФактурыОснования" Тогда
		СтандартнаяОбработка = Ложь;
		ВыборСчетаФактуры();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСчетФактуруОснование()
	
	ПоказатьЗначение(, Объект.СчетФактураОснование);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборСчетаФактуры(ВыборОснования = Истина, МассивСтрок = Неопределено)
	
	СтруктураПараметров = Новый Структура;
	
	ЗначениеОтбора = Новый Структура;
	ЗначениеОтбора.Вставить("ПометкаУдаления", Ложь);
	ЗначениеОтбора.Вставить("Проведен", Истина);
	Если ВыборОснования Тогда
		ЗначениеОтбора.Вставить("Исправление", Ложь);
	Иначе
		Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
			ЗначениеОтбора.Вставить("Контрагент", Объект.Контрагент)
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗначениеОтбора.Вставить("ИсключитьСчетФактуру", Объект.Ссылка);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ЗначениеОтбора.Вставить("Организация", Объект.Организация)
	КонецЕсли;
	
	СтруктураПараметров.Вставить("Отбор", ЗначениеОтбора);
	
	ДополнительныеПараметры = Новый Структура("ВыборОснования,МассивСтрок", ВыборОснования, МассивСтрок);
	Оповещение = Новый ОписаниеОповещения("ВыборСчетаФактурыЗавершение", ЭтаФорма, ДополнительныеПараметры);
	
	ОткрытьФорму(
		"Документ.СчетФактураПолученныйАванс.ФормаВыбора",
		СтруктураПараметров,
		ЭтаФорма, , , ,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборСчетаФактурыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Модифицированность = Истина;
		Если ДополнительныеПараметры.ВыборОснования Тогда
			Объект.СчетФактураОснование = Результат;
			ЗаполнитьНаОснованииСчетаФактуры();
		Иначе
			УказатьИсходныйСчетФактуруВАвансах(Результат, ДополнительныеПараметры.МассивСтрок);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УказатьИсходныйСчетФактуруВАвансах(ВыбранныйСчетФактура, МассивСтрок)
	
	Для Каждого ИдентификаторСтроки Из МассивСтрок Цикл
		СтрокаАванса = Объект.Авансы.НайтиПоИдентификатору(ИдентификаторСтроки);
		СтрокаАванса.ИсходныйСчетФактура = ВыбранныйСчетФактура;
		СтрокаАванса.СтавкаНДС = УчетНДСЛокализация.СтавкаНДСПоПеречислению(ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС20_120"));
		СтрокаАванса.СуммаНДС = СтрокаАванса.Сумма;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьДокументыОснования()
	
	Объект.СчетФактураОснование = Неопределено;
	
	ОбновитьИнформациюПоСчетуФактуреОснованию();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюПоСчетуФактуреОснованию()
	
	МассивСтрок = Новый Массив;
	
	Если Объект.Исправление И ЗначениеЗаполнено(Объект.СчетФактураОснование) Тогда
		
		РеквизитыСФ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.СчетФактураОснование, "Номер, Дата");
		СчетФактураОснованиеПредставление = Документы.СчетФактураПолученныйАванс.ПредставлениеСчетаФактуры(СокрЛП(РеквизитыСФ.Номер), РеквизитыСФ.Дата);
		
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			СчетФактураОснованиеПредставление, ,
			ЦветаСтиля.ГиперссылкаЦвет, ,
			ПолучитьНавигационнуюСсылку(Объект.СчетФактураОснование)));
			
	КонецЕсли;
	
	Если ЕстьПравоНаРедактирование И Объект.Исправление Тогда
		
		Если ЗначениеЗаполнено(Объект.СчетФактураОснование) Тогда
			
			МассивСтрок.Добавить("   ");
			
			МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
				НСтр("ru = 'Изменить';
					|en = 'Change'"), ,
				ЦветаСтиля.ГиперссылкаЦвет, ,
				"ВыборСчетаФактурыОснования"));
			
		Иначе
			
			МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
				НСтр("ru = 'Не выбран счет-фактура';
					|en = 'Tax invoice is not selected'"), ,
				WebЦвета.Кирпичный, ,
				"ВыборСчетаФактурыОснования"));
				
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстСчетФактураОснование = Новый ФорматированнаяСтрока(МассивСтрок)
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаОснованииСчетаФактуры()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьИсправлениеПоСчетуФактуре();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	ОбновитьИнформациюПоСчетуФактуреОснованию();
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПолученПриИзмененииСервер()
	
	ЗаполнитьСписокКодовВидовОпераций();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКодовВидовОпераций()
	
	УчетНДС.ЗаполнитьСписокКодовВидовОпераций(
		Перечисления.ЧастиЖурналаУчетаСчетовФактур.ПолученныеСчетаФактуры,
		СписокКодовВидовОпераций,
		?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()));
		
	ОбновитьПредставлениеВидаОперации(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДатуПолучения()
	
	Если Объект.Исправление И ЗначениеЗаполнено(Объект.ДатаИсправления) Тогда
		Объект.Дата = Объект.ДатаИсправления;
	ИначеЕсли ЗначениеЗаполнено(Объект.ДатаСоставления) Тогда
		Объект.Дата = Объект.ДатаСоставления;
	КонецЕсли;
	
	ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы(Истина);
	ЗаполнитьСписокКодовВидовОпераций();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПредставлениеВидаОперации(Форма)
	
	ТекущийКод = Форма.СписокКодовВидовОпераций.НайтиПоЗначению(Форма.Объект.КодВидаОперации);
	Если ТекущийКод <> Неопределено Тогда
		Форма.ПредставлениеВидаОперации = Сред(ТекущийКод.Представление, 4);
	Иначе
		Форма.ПредставлениеВидаОперации = "";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СоставленКомиссионеромОтИмениПродавцаПриИзмененииСервер()
	
	Если НЕ Объект.СоставленКомиссионеромОтИмениПродавца Тогда
		Объект.Продавцы.Очистить();
	КонецЕсли;
	
	ОбновитьИнформациюПоПродавцам();
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродавцыЗавершениеВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПродавцов(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродавецЗавершениеВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СписокПродавцов = Новый СписокЗначений;
	СписокПродавцов.Добавить(Результат);
	
	ЗаполнитьПродавцов(СписокПродавцов, Истина);
	
КонецПроцедуры

&НаСервере 
Процедура ЗаполнитьПродавцов(СписокПродавцов, ПолучатьИННКПП = Ложь)
	
	УчетНДСРФ.ЗаполнитьПродавцов(ЭтотОбъект, СписокПродавцов, ДатаСведений(Объект), ПолучатьИННКПП);
	
	ОбновитьИнформациюПоПродавцам();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюПоПродавцам()
	
	МассивСтрок = Новый Массив();
	
	Если НЕ Объект.СоставленКомиссионеромОтИмениПродавца Тогда
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(""));
	ИначеЕсли Объект.Продавцы.Количество() = 0 Тогда
		МассивСтрок.Добавить(
			Новый ФорматированнаяСтрока(НСтр("ru = 'Выбрать продавца';
											|en = 'Select seller'"), , WebЦвета.Кирпичный, , "ВыбратьПродавца"));
	ИначеЕсли Объект.Продавцы.Количество() = 1 Тогда
		МассивСтрок.Добавить(
			Новый ФорматированнаяСтрока(Строка(Объект.Продавцы[0].Продавец), , ЦветаСтиля.ГиперссылкаЦвет, , ПолучитьНавигационнуюСсылку(Объект.Продавцы[0].Продавец)));
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока("  "));
		МассивСтрок.Добавить(
			Новый ФорматированнаяСтрока(НСтр("ru = 'Добавить';
											|en = 'Add'"), , ЦветаСтиля.ГиперссылкаЦвет, , "ОткрытьФормуПродавцы"));
	Иначе
		ТекстПродавцов = ОбщегоНазначенияУТКлиентСервер.СклонениеСлова(
				Объект.Продавцы.Количество(),
				НСтр("ru = 'продавец';
					|en = 'seller'"), НСтр("ru = 'продавца';
											|en = 'seller'"), НСтр("ru = 'продавцов';
																	|en = 'sellers'"), НСтр("ru = 'м';
																							|en = 'm'"));
		Текст = СтрШаблон(НСтр("ru = 'Выбрано %1 %2';
								|en = 'Selected %1 %2'"), Объект.Продавцы.Количество(), ТекстПродавцов);
		
		МассивСтрок.Добавить(
			Новый ФорматированнаяСтрока(Текст, , ЦветаСтиля.ГиперссылкаЦвет, , "ОткрытьФормуПродавцы"));
	КонецЕсли;
	
	ТекстПродавцы = Новый ФорматированнаяСтрока(МассивСтрок);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы(ИзменятьИННКПП = Ложь) Экспорт
	
	УчетНДСРФ.ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы(ЭтотОбъект, ДатаСведений(Объект), ИзменятьИННКПП); 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДатаСведений(Объект)
	
	Возврат ?(Объект.Исправление, Объект.ДатаИсправления, Объект.ДатаСоставления);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораКПП(СписокВыбора, Контрагент, ДатаСведений)
	
	УчетНДСРФ.ЗаполнитьСписокВыбораКППСчетФактурыПолученные(СписокВыбора, Контрагент, ДатаСведений);
	
КонецПроцедуры

&НаСервере
Процедура НалогообложениеНДСПриИзмененииНаСервере()
	
	Если Объект.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя Тогда
		Объект.КодВидаОперации = "41";
	Иначе
		Объект.КодВидаОперации = "02";
	КонецЕсли;
	ОбновитьПредставлениеВидаОперации(ЭтаФорма);
	
	СтруктураПересчетаСуммы = Новый Структура;
	СтруктураПересчетаСуммы.Вставить("ЦенаВключаетНДС", Истина);
	
	СтруктураДействий = Новый Структура;
	Если Объект.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя Тогда
		СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС",
			Новый Структура("НалогообложениеНДС, Дата", Объект.НалогообложениеНДС, Объект.Дата));
	КонецЕсли;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Объект.Авансы, СтруктураДействий, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуНДС(ТекущиеДанные, ИмяРеквизитаСумма, ИмяРеквизитаСуммаНДС)
	
	ТекущаяСтрока = Новый Структура;
	ТекущаяСтрока.Вставить("Сумма", ТекущиеДанные[ИмяРеквизитаСумма]);
	ТекущаяСтрока.Вставить("СтавкаНДС", ТекущиеДанные.СтавкаНДС);
	ТекущаяСтрока.Вставить("СуммаНДС", ТекущиеДанные[ИмяРеквизитаСуммаНДС]);
	
	СтруктураПересчетаСуммы = Новый Структура;
	СтруктураПересчетаСуммы.Вставить("ЦенаВключаетНДС", Истина);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
	
	ТекущиеДанные[ИмяРеквизитаСуммаНДС] = ТекущаяСтрока.СуммаНДС;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
