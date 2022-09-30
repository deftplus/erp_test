
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриЧтенииСозданииНаСервере();
		
	КонецЕсли;
	
	#Область СтандартныеПодсистемы
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыЭДОПриСоздании = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаДокумента();
	ПараметрыЭДОПриСоздании.Форма = ЭтотОбъект;
	ПараметрыЭДОПриСоздании.ДокументСсылка = Объект.Ссылка;
	ПараметрыЭДОПриСоздании.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ПараметрыЭДОПриСоздании.КонтроллерСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыЭДОПриСоздании.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаДокумента(ПараметрыЭДОПриСоздании);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	Элементы.ДекорацияСостояниеЭДО.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭД");
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ГиперссылкаФайлов = РаботаСФайлами.ГиперссылкаФайлов();
	ГиперссылкаФайлов.Размещение = "КоманднаяПанель";
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ГиперссылкаФайлов);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

	#КонецОбласти
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	
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
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
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
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПринятиеКУчетуУзловКомпонентовАмортизации", ПараметрыЗаписи, Объект.Ссылка);
	ОбщегоНазначенияУТКлиент.ОповеститьОЗаписиДокументаВЖурнал();
	ВнеоборотныеАктивыКлиент.ОповеститьОЗаписиДокументаВЖурналОС();
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПослеЗаписи_ФормаДокумента(ЭтаФорма, ПараметрыЗаписи);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтотОбъект, ПараметрыЗаписи);

	ОбщегоНазначенияУТКлиент.ВыполнитьДействияПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	ЗаполнитьИнформациюВПодвале();
	
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

	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПринятиеКУчетуУзловКомпонентовАмортизации" 
		И Источник <> Объект.Ссылка Тогда
		ЗаполнитьИнформациюВПодвале();
	КонецЕсли; 
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область СтраницаОсновное

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы("Дата");
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтраженияВУчетеПриИзменении(Элемент)
	
	ВариантОтраженияВУчетеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы("Организация,ЕстьСвязанныеОрганизации");
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОДокументеВДругомУчетеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "#СоздатьДокумент" Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура("Основание", Объект.Ссылка);
		ОткрытьФорму("Документ.ПринятиеКУчетуУзловКомпонентовАмортизации.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЭДОНажатие(Элемент, СтандартнаяОбработка)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.СостояниеЭДОНажатие_ФормаДокумента(ЭтотОбъект, СтандартнаяОбработка);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	Возврат; // в WE пустой обработчик

КонецПроцедуры  

#КонецОбласти

#Область СтраницаУчет

&НаКлиенте
Процедура ПорядокУчетаУУПриИзменении(Элемент)
	
	ИзмененныеРеквизиты = ВнеоборотныеАктивыКлиентЛокализация.ПриИзмененииПорядкаУчетаУУ_ОС(
							Объект,
							СлужебныеПараметрыФормы);
							
	ИзмененныеРеквизиты = "ПорядокУчетаУУ" + ?(НЕ ПустаяСтрока(ИзмененныеРеквизиты), "," + ИзмененныеРеквизиты, "");
	НастроитьЗависимыеЭлементыФормы(ИзмененныеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияУУПриИзменении(Элемент)
	
	ПриИзмененииСрокаИспользования("СрокИспользованияУУ", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура МетодНачисленияАмортизацииУУПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы("МетодНачисленияАмортизацииУУ");
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)

	РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)

	РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент,
				ПараметрыПеретаскивания, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)

	РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент,
				ПараметрыПеретаскивания, СтандартнаяОбработка);

КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область Локализация

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент)

	ПринятиеКУчетуУзловКомпонентовАмортизацииКлиентЛокализация.ПриИзмененииРеквизита(Элемент, ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОС

&НаКлиенте
Процедура КомпонентыАмортизацииПослеУдаления(Элемент)
	
	НастроитьЗависимыеЭлементыФормы("ОсновноеСредство");
	
КонецПроцедуры

&НаКлиенте
Процедура КомпонентыАмортизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПодборНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура КомпонентыАмортизацииПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ЗаполнитьЗначенияРеквизитовКомпонентовАмортизацииДоИзменения();
	
КонецПроцедуры

&НаКлиенте
Процедура КомпонентыАмортизацииКомпонентАмортизацииПриИзменении(Элемент)
	
	КомпонентыАмортизацииКомпонентАмортизацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КомпонентыАмортизацииСтоимостьБУПриИзменении(Элемент)
	
	КомпонентыАмортизацииСтоимостьБУПриИзмененииНаСервере();
	
	ЗаполнитьЗначенияРеквизитовКомпонентовАмортизацииДоИзменения();
	
КонецПроцедуры

&НаКлиенте
Процедура КомпонентыАмортизацииСтоимостьУУПриИзменении(Элемент)
	
	ЗаполнитьИнформациюВПодвале();
	
	ЗаполнитьЗначенияРеквизитовКомпонентовАмортизацииДоИзменения();
	
КонецПроцедуры

&НаКлиенте
Процедура КомпонентыАмортизацииСтоимостьУУ1ПриИзменении(Элемент)
	
	ЗаполнитьЗначенияРеквизитовКомпонентовАмортизацииДоИзменения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	
	ПараметрыПодбора = ВнеоборотныеАктивыКлиентСервер.ПараметрыПодбора(Элементы.КомпонентыАмортизацииКомпонентАмортизации, ЭтотОбъект);
	
	ОткрытьФорму("Справочник.ОбъектыЭксплуатации.ФормаВыбора", 
					ПараметрыПодбора, Элементы.КомпонентыАмортизации,,,,, 
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтоимость(Команда)
	
	ОчиститьСообщения();
	
	ЗаполнитьПредварительнуюСтоимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтотОбъект);
	
КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

#КонецОбласти

#Область ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
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

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)

	РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);

КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеОС

&НаСервере
Процедура ПодборНаСервере(ВыбранноеЗначение)

	ДобавленныеСтроки = ВнеоборотныеАктивыКлиентСервер.ОбработкаВыбораЭлемента(Объект.КомпонентыАмортизации, "КомпонентАмортизации", ВыбранноеЗначение);

	Если ДобавленныеСтроки.Количество() <> 0 Тогда
		
		ИзмененныеРеквизиты = "КомпонентАмортизации";
		НастроитьЗависимыеЭлементыФормыНаСервере(ИзмененныеРеквизиты);
		
		ЗаполнитьПредварительнуюСтоимость(ДобавленныеСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредварительнуюСтоимость(ВыбранныеСтроки = Неопределено)

	СообщатьОбОшибках = ВыбранныеСтроки = Неопределено;
	
	Отказ = Ложь;
	Если НЕ ЗначениеЗаполнено(Объект.Дата)  Тогда
		Если СообщатьОбОшибках Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Дата"" не заполнено';
									|en = '""Date"" is required'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "Объект", "Дата", Отказ);
		Иначе
			Отказ = Истина;
		КонецЕсли; 
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Если СообщатьОбОшибках Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Организация"" не заполнено';
									|en = '""Company"" is required'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "Объект", "Организация", Отказ); 
		Иначе
			Отказ = Истина;
		КонецЕсли; 
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		Документы.ПринятиеКУчетуУзловКомпонентовАмортизации.ЗаполнитьСтоимость(Объект, ВыбранныеСтроки);
	КонецЕсли;
	
	ЗаполнитьИнформациюВПодвале();
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаСервере
Процедура ОбработатьШтрихкоды(Знач ДанныеШтрихкодов)
	
	ПараметрыПодбора = ВнеоборотныеАктивыКлиентСервер.ПараметрыПодбора(Элементы.КомпонентыАмортизацииКомпонентАмортизации, ЭтотОбъект);
	МассивОбъектов = ВнеоборотныеАктивы.НайтиОсновныеСредстваПоШтрихкодам(ДанныеШтрихкодов, ПараметрыПодбора);
	ПодборНаСервере(МассивОбъектов);
	
КонецПроцедуры

#КонецОбласти

#Область ПриИзмененииРеквизитов

&НаКлиенте
Процедура ПриОкончанииИзмененияРеквизитаЛокализации(ИмяЭлемента, ПараметрыОповещения) Экспорт
	
	Перем ПараметрыДействия;

	Если ПараметрыОповещения.ТребуетсяВызовСервера Тогда
		ПриИзмененииРеквизитаЗавершениеНаСервере(ИмяЭлемента, ПараметрыОповещения.ПараметрыОбработки);
	КонецЕсли;

	Если НЕ ПараметрыОповещения.ТребуетсяВызовСервера Тогда
		
		Если ПараметрыОповещения.ПараметрыОбработки.Свойство("Выполнить_НастроитьЗависимыеЭлементыФормы", ПараметрыДействия) Тогда
			НастроитьЗависимыеЭлементыФормы(ПараметрыДействия);
		КонецЕсли;

		Если ПараметрыОповещения.ПараметрыОбработки.Свойство("Выполнить_ПриИзмененииСрокаИспользования", ПараметрыДействия) Тогда
			ПриИзмененииСрокаИспользования(ПараметрыДействия.ИмяРеквизита, ПараметрыДействия.ОбновитьЕслиСовпадают);
		КонецЕсли;

		Если ПараметрыОповещения.ПараметрыОбработки.Свойство("Выполнить_ЗаполнитьЗначенияРеквизитовКомпонентовАмортизацииДоИзменения", ПараметрыДействия) Тогда
			ЗаполнитьЗначенияРеквизитовКомпонентовАмортизацииДоИзменения();
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитаЗавершениеНаСервере(Знач ИмяЭлемента, Знач ДополнительныеПараметры)
	
	Перем ПараметрыДействия;

	Если ДополнительныеПараметры.Свойство("Выполнить_НастроитьЗависимыеЭлементыФормы", ПараметрыДействия) Тогда
		НастроитьЗависимыеЭлементыФормыНаСервере(ПараметрыДействия);
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("Выполнить_ЗаполнитьИнформациюВПодвале", ПараметрыДействия) Тогда
		ЗаполнитьИнформациюВПодвале();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КомпонентыАмортизацииКомпонентАмортизацииПриИзмененииНаСервере()

	ИзмененныеРеквизиты = "КомпонентАмортизации";
	
	ТекущаяСтрока = Элементы.КомпонентыАмортизации.ТекущаяСтрока;
	ДанныеСтроки = Объект.КомпонентыАмортизации.НайтиПоИдентификатору(ТекущаяСтрока);
	
	ЗаполнитьПредварительнуюСтоимость(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеСтроки));
	
	НастроитьЗависимыеЭлементыФормыНаСервере(ИзмененныеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСрокаИспользования(ИмяРеквизита, ОбновитьЕслиСовпадают)

	СписокРеквизитов = ПолучитьСписокРеквизитовПриИзмененииСрокаИспользования(
						Объект, ИмяРеквизита, СрокиИспользованияСовпадают И ОбновитьЕслиСовпадают);
	
	УстановитьСрокиИспользованияСовпадают(ЭтотОбъект);
	
	НастроитьЗависимыеЭлементыФормы(СписокРеквизитов);		

КонецПроцедуры

&НаСервере
Процедура ВариантОтраженияВУчетеПриИзмененииНаСервере()

	ИзмененныеРеквизиты = "ОтражатьВУпрУчете,ОтражатьВРеглУчете";
	
	ВнеоборотныеАктивыКлиентСервер.ПриИзмененииВариантаОтраженияВУчете(Объект, ВариантОтраженияВУчете, Ложь);
			
	НастроитьЗависимыеЭлементыФормыНаСервере(ИзмененныеРеквизиты);

	ЗаполнитьИнформациюВПодвале();
	
КонецПроцедуры

&НаСервере
Процедура КомпонентыАмортизацииСтоимостьБУПриИзмененииНаСервере()

	ТекущаяСтрока = Элементы.КомпонентыАмортизации.ТекущаяСтрока;
	ТекущиеДанные = Объект.КомпонентыАмортизации.НайтиПоИдентификатору(ТекущаяСтрока);
	
	Если ЗначенияРеквизитовКомпонентовАмортизацииДоИзменения.СтоимостьБУ = ЗначенияРеквизитовКомпонентовАмортизацииДоИзменения.СтоимостьУУ 
		И Объект.ОтражатьВУпрУчете 
		И ВалютыСовпадают
		И ВедетсяРегламентированныйУчетВНА Тогда
		ТекущиеДанные.СтоимостьУУ = ТекущиеДанные.СтоимостьБУ;
	КонецЕсли; 

	ЗаполнитьИнформациюВПодвале();
	
	НастроитьЗависимыеЭлементыФормыНаСервере("СтоимостьБУ");
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ПродолжитьВыполнениеКомандыЛокализации(ИмяКоманды, ПараметрыОповещения) Экспорт

	Перем ПараметрыДействия;
	
	Если ПараметрыОповещения.ТребуетсяВызовСервера Тогда
		ПриВыполненииКомандыЗавершениеНаСервере(ИмяКоманды, ПараметрыОповещения.ПараметрыОбработки);
		Возврат;
	КонецЕсли;

	Если ПараметрыОповещения.ПараметрыОбработки.Свойство("Выполнить_НастроитьЗависимыеЭлементыФормы", ПараметрыДействия) Тогда
		НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, ПараметрыДействия);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриВыполненииКомандыЗавершениеНаСервере(Знач ИмяКоманды, Знач ДополнительныеПараметры)

	Если ДополнительныеПараметры.Свойство("Выполнить_НастроитьЗависимыеЭлементыФормы") Тогда
		НастроитьЗависимыеЭлементыФормыНаСервере(ДополнительныеПараметры.Выполнить_НастроитьЗависимыеЭлементыФормы);
	КонецЕсли; 

КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	ИнициализацияФормыПриСозданииНаСервере();
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	УстановитьСрокиИспользованияСовпадают(ЭтотОбъект);
	
	ВариантОтраженияВУчете = ВнеоборотныеАктивыКлиентСервер.ВариантОтраженияВУчете(Объект, Ложь);
	
	ЗаполнитьИнформациюВПодвале();
	
	НастроитьЗависимыеЭлементыФормыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияФормыПриСозданииНаСервере()

	ЗаполнитьСлужебныеПараметрыФормы();
	
	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
	
	ВалютыСовпадают = (ВалютаУпр = ВалютаРегл);
	
	ВедетсяРегламентированныйУчетВНА = ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА();
	
	Элементы.КомпонентыАмортизацииСтоимостьУУ.Заголовок = СлужебныеПараметрыФормы.ПредставлениеРеквизитов.Получить("КомпонентыАмортизации.СтоимостьУУ");
	Элементы.КомпонентыАмортизацииСтоимостьУУ_Отдельно.Заголовок = СлужебныеПараметрыФормы.ПредставлениеРеквизитов.Получить("КомпонентыАмортизации.СтоимостьУУ");
	Элементы.КомпонентыАмортизацииСтоимостьБУ.Заголовок = СлужебныеПараметрыФормы.ПредставлениеРеквизитов.Получить("КомпонентыАмортизации.СтоимостьБУ");
	Элементы.КомпонентыАмортизацииСтоимостьБУ_Отдельно.Заголовок = СлужебныеПараметрыФормы.ПредставлениеРеквизитов.Получить("КомпонентыАмортизации.СтоимостьБУ");
	Элементы.КомпонентыАмортизацииЛиквидационнаяСтоимость.Заголовок = СлужебныеПараметрыФормы.ПредставлениеРеквизитов.Получить("КомпонентыАмортизации.ЛиквидационнаяСтоимость");
	Элементы.КомпонентыАмортизацииЛиквидационнаяСтоимостьРегл.Заголовок = СлужебныеПараметрыФормы.ПредставлениеРеквизитов.Получить("КомпонентыАмортизации.ЛиквидационнаяСтоимостьРегл");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеПараметрыФормы()

	НовыеСлужебныеПараметрыФормы = Новый Структура;
	НовыеСлужебныеПараметрыФормы.Вставить("ПредставлениеРеквизитов", Документы.ПринятиеКУчетуУзловКомпонентовАмортизации.ПредставлениеРеквизитов(Объект.Организация));
	НовыеСлужебныеПараметрыФормы.Вставить("ЕстьУчетСебестоимости", Ложь);
	НовыеСлужебныеПараметрыФормы.Вставить("ИспользоватьРеглУчет", РеглУчетСервер.ВедетсяРеглУчет(Объект.Дата));
	
	СлужебныеПараметрыФормы = Новый ФиксированнаяСтруктура(НовыеСлужебныеПараметрыФормы);

КонецПроцедуры

&НаСервере
Процедура ИнициализацияФормыПриИзмененииОрганизации()
	
	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
	
	ВалютыСовпадают = (ВалютаУпр = ВалютаРегл);
	
	ПредставлениеРеквизитов = Документы.ПринятиеКУчетуУзловКомпонентовАмортизации.ПредставлениеРеквизитов(Объект.Организация);
	Элементы.КомпонентыАмортизацииСтоимостьБУ.Заголовок = ПредставлениеРеквизитов.Получить("КомпонентыАмортизации.СтоимостьБУ");
	Элементы.КомпонентыАмортизацииСтоимостьБУ_Отдельно.Заголовок = ПредставлениеРеквизитов.Получить("КомпонентыАмортизации.СтоимостьБУ");
	Элементы.КомпонентыАмортизацииЛиквидационнаяСтоимостьРегл.Заголовок = ПредставлениеРеквизитов.Получить("КомпонентыАмортизации.ЛиквидационнаяСтоимостьРегл");
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьЗависимыеЭлементыФормы(Знач ИзмененныеРеквизиты = "")

	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	
	Если ТребуетсяВызовСервераДляНастройкиЭлементовФормы(СтруктураИзмененныхРеквизитов) Тогда
		НастроитьЗависимыеЭлементыФормыНаСервере(ИзмененныеРеквизиты)
	Иначе
		НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, ИзмененныеРеквизиты);
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(Форма, ИзмененныеРеквизиты)

	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	ВспомогательныеРеквизиты = Новый Структура;
	ВспомогательныеРеквизиты.Вставить("ИспользоватьОбъектыСтроительства", Ложь);
	ВспомогательныеРеквизиты.Вставить("ОтражатьВРеглУчете", Объект.ОтражатьВРеглУчете);
	ВспомогательныеРеквизиты.Вставить("ОтражатьВУпрУчете", Объект.ОтражатьВУпрУчете);
	ВспомогательныеРеквизиты.Вставить("ОтражатьВБУ", Объект.ОтражатьВРеглУчете);
	ВспомогательныеРеквизиты.Вставить("ВедетсяРегламентированныйУчетВНА", Форма.ВедетсяРегламентированныйУчетВНА);
	ВспомогательныеРеквизиты.Вставить("ВалютыСовпадают", Форма.ВалютыСовпадают);
	ВспомогательныеРеквизиты.Вставить("ЕстьУчетСебестоимости", Форма.СлужебныеПараметрыФормы.ЕстьУчетСебестоимости);
	ВспомогательныеРеквизиты.Вставить("ИспользоватьРеглУчет", Форма.СлужебныеПараметрыФормы.ИспользоватьРеглУчет);
	
	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	
	ОбновитьВсе = СтруктураИзмененныхРеквизитов.Количество() = 0;
	
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ПринятиеКУчетуУзловКомпонентовАмортизации(
									Объект, ВспомогательныеРеквизиты, ИзмененныеРеквизиты);
	ОбщегоНазначенияУТКлиентСервер.НастроитьЗависимыеЭлементыФормы(Форма, ПараметрыРеквизитовОбъекта);
	
	Если НЕ ОбновитьВсе Тогда
		ОбщегоНазначенияУТКлиентСервер.ОчиститьНеиспользуемыеРеквизиты(Объект, ПараметрыРеквизитовОбъекта, "ОС,ЦелевоеФинансирование");
		
		ИзмененныеРеквизиты = ЗаполнитьРеквизитыВЗависимостиОтСвойств(Объект, ПараметрыРеквизитовОбъекта);

		Если ЗначениеЗаполнено(ИзмененныеРеквизиты) Тогда
			ВнеоборотныеАктивыКлиентСервер.ПриИзмененииРеквизитов_ПринятиеКУчетуУзловКомпонентовАмортизации(Объект, ВспомогательныеРеквизиты, ИзмененныеРеквизиты);
			ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ПринятиеКУчетуУзловКомпонентовАмортизации(
											Объект, ВспомогательныеРеквизиты, ИзмененныеРеквизиты);
		
			ОбщегоНазначенияУТКлиентСервер.НастроитьЗависимыеЭлементыФормы(Форма, ПараметрыРеквизитовОбъекта);
		КонецЕсли;
	КонецЕсли;
	
	#Область СтраницаКомпонентыАмортизации
	
	Если ОбновитьВсе Тогда
		
		Элементы.КомпонентыАмортизацииСтоимостьУУ.Видимость = Ложь;
		Элементы.КомпонентыАмортизацииСтоимостьУУ_Отдельно.Видимость = 
			(Форма.ВедетсяРегламентированныйУчетВНА ИЛИ НЕ Форма.ВалютыСовпадают);
		
	КонецЕсли;
	
	Если ОбновитьВсе Тогда
		Элементы.КомпонентыАмортизацииСтоимостьБУ_Отдельно.Видимость = Истина;
		Элементы.КомпонентыАмортизацииСтоимостьУУ_Отдельно.Видимость = НЕ ВспомогательныеРеквизиты.ВалютыСовпадают;
	
		Элементы.КомпонентыАмортизацииСтоимостьУУ.Видимость = Ложь;
		Элементы.КомпонентыАмортизацииСтоимостьБУ.Видимость = Ложь;
	КонецЕсли;
	
	//++ Локализация
	СтоимостьУУДоступна = 
		Объект.ОтражатьВУпрУчете 
		И (ВспомогательныеРеквизиты.ВедетсяРегламентированныйУчетВНА
			ИЛИ НЕ ВспомогательныеРеквизиты.ВалютыСовпадают);
	
	СтоимостьБУДоступна = Объект.ОтражатьВРеглУчете;
				
	Если СтруктураИзмененныхРеквизитов.Свойство("ПорядокУчетаБУ")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВУпрУчете")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВРеглУчете")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("Организация")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("Дата")
		ИЛИ ОбновитьВсе Тогда
	
		Если СтоимостьУУДоступна
			И СтоимостьБУДоступна Тогда
			
			Элементы.КомпонентыАмортизацииСтоимостьУУ.Видимость = СтоимостьУУДоступна; 
			Элементы.КомпонентыАмортизацииСтоимостьБУ.Видимость = СтоимостьБУДоступна;
			
			Элементы.КомпонентыАмортизацииСтоимостьУУ_Отдельно.Видимость = Ложь;
			Элементы.КомпонентыАмортизацииСтоимостьБУ_Отдельно.Видимость = Ложь;

		Иначе
	
			Элементы.КомпонентыАмортизацииСтоимостьУУ.Видимость = Ложь; 
			Элементы.КомпонентыАмортизацииСтоимостьУУ_Отдельно.Видимость = СтоимостьУУДоступна;
			Элементы.КомпонентыАмортизацииСтоимостьБУ.Видимость = Ложь;
	
			Элементы.КомпонентыАмортизацииСтоимостьБУ_Отдельно.Видимость = СтоимостьБУДоступна;
			
		КонецЕсли;
		
	КонецЕсли;
	//-- Локализация
	
	#КонецОбласти
	
	#Область СтраницаУчет
	
	Если СтруктураИзмененныхРеквизитов.Свойство("СрокИспользованияУУ")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ПорядокУчетаУУ")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВУпрУчете")
		ИЛИ ОбновитьВсе Тогда
		
		Форма.СрокИспользованияУУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(
			Объект.СрокИспользованияУУ);
			
	КонецЕсли;
	
	Если ОбновитьВсе Тогда
		Элементы.ГруппаУчетУУ.ОтображатьЗаголовок = Ложь;
	КонецЕсли;
	
	//++ Локализация
	
	ДоступныНастройкиРеглУчета = (Объект.ОтражатьВРеглУчете И ВспомогательныеРеквизиты.ВедетсяРегламентированныйУчетВНА);
	
	Если СтруктураИзмененныхРеквизитов.Свойство("СрокИспользованияБУ")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ПорядокУчетаБУ")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВРеглУчете")
		ИЛИ ОбновитьВсе Тогда
		
		Форма.СрокИспользованияБУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(
			Объект.СрокИспользованияБУ);
			
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВРеглУчете")
		ИЛИ ОбновитьВсе Тогда
		Элементы.ГруппаУчетУУ.ОтображатьЗаголовок = ДоступныНастройкиРеглУчета;
		Элементы.ГруппаУчетОбщее.ОтображатьЗаголовок = ДоступныНастройкиРеглУчета;
	КонецЕсли;
	
	//-- Локализация
	
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормыНаСервере(ИзмененныеРеквизиты = "")

	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	
	ОбновитьВсе = СтруктураИзмененныхРеквизитов.Количество() = 0;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("Организация") 
		ИЛИ ОбновитьВсе Тогда
		
		ИнициализацияФормыПриИзмененииОрганизации();
		УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
		
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("Дата") 
		ИЛИ ОбновитьВсе Тогда
		
		ВнеоборотныеАктивыСлужебный.УстановитьСвойствоСтруктуры(
			"ЕстьУчетСебестоимости",
			РасчетСебестоимостиПовтИсп.ФормироватьДвиженияПоРегистрамСебестоимости(Объект.Дата),
			СлужебныеПараметрыФормы);
		
		ВнеоборотныеАктивыСлужебный.УстановитьСвойствоСтруктуры(
			"ИспользоватьРеглУчет",
			РеглУчетСервер.ВедетсяРеглУчет(Объект.Дата),
			СлужебныеПараметрыФормы);
		
	КонецЕсли;
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, ИзмененныеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Функция ТребуетсяВызовСервераДляНастройкиЭлементовФормы(СтруктураИзмененныхРеквизитов)

	Если СтруктураИзмененныхРеквизитов.Количество() = 0
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("Дата") 
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("Организация") 
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВРеглУчете")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВУпрУчете") 
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("КомпонентыАмортизации") 
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("КомпонентАмортизации") Тогда
			
		Возврат Истина;
	КонецЕсли; 
	
	Возврат Ложь;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗаполнитьРеквизитыВЗависимостиОтСвойств(Объект, ПараметрыРеквизитовОбъекта)

	ИзмененныеРеквизиты = Новый Массив;
	
	Для каждого ПараметрыРеквизита Из ПараметрыРеквизитовОбъекта Цикл
		
		Если НЕ ЗначениеЗаполнено(ПараметрыРеквизита.ИмяРеквизита)
			ИЛИ СтрРазделить(ПараметрыРеквизита.ИмяРеквизита, ".").ВГраница() <> 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Действие = ВнеоборотныеАктивыКлиентСервер.ОчиститьИлиЗаполнить(Объект, ПараметрыРеквизита);
		
		Если НЕ ЗначениеЗаполнено(Действие) Тогда
			Продолжить;
		КонецЕсли;
		
		#Область СтраницаУчет
		
		Если ПараметрыРеквизита.ИмяРеквизита = "НачислятьАмортизациюУУ" Тогда
			
			Объект[ПараметрыРеквизита.ИмяРеквизита] = ?(Действие = "Заполнить", Истина, Ложь);
			ИзмененныеРеквизиты.Добавить(ПараметрыРеквизита.ИмяРеквизита);
		КонецЕсли;
		
		Если ПараметрыРеквизита.ИмяРеквизита = "ПорядокУчетаУУ"
			И Действие = "Заполнить" Тогда
			Объект[ПараметрыРеквизита.ИмяРеквизита] = ПредопределенноеЗначение("Перечисление.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НачислятьАмортизацию");
			ИзмененныеРеквизиты.Добавить(ПараметрыРеквизита.ИмяРеквизита);
		КонецЕсли;
		
		Если ПараметрыРеквизита.ИмяРеквизита = "МетодНачисленияАмортизацииУУ"
			И Действие = "Заполнить" Тогда
			Объект[ПараметрыРеквизита.ИмяРеквизита] = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.Линейный");
			ИзмененныеРеквизиты.Добавить(ПараметрыРеквизита.ИмяРеквизита);
		КонецЕсли;
		
		#КонецОбласти
		
	КонецЦикла; 
	
	Возврат СтрСоединить(ИзмененныеРеквизиты, ",");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСрокиИспользованияСовпадают(Форма)

	Форма.СрокиИспользованияСовпадают = НЕ Форма.Объект.ОтражатьВУпрУчете ИЛИ (Форма.Объект.СрокИспользованияБУ = Форма.Объект.СрокИспользованияУУ);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСписокРеквизитовПриИзмененииСрокаИспользования(Объект, ИмяРеквизита, ОбновитьСрокИспользования)
	
	СписокРеквизитов = ИмяРеквизита;
	
	Если ИмяРеквизита <> "СрокИспользованияУУ"
		И Объект.ОтражатьВУпрУчете
		И (Объект.СрокИспользованияУУ = 0
			ИЛИ ОбновитьСрокИспользования) Тогда
		
		Объект.СрокИспользованияУУ = Объект[ИмяРеквизита];
		СписокРеквизитов = СписокРеквизитов + ",СрокИспользованияУУ";
		
	КонецЕсли;
	
	Если ИмяРеквизита <> "СрокИспользованияБУ"
		И Объект.ОтражатьВУпрУчете
		И (Объект.СрокИспользованияБУ = 0
			ИЛИ ОбновитьСрокИспользования) Тогда
		
		Объект.СрокИспользованияБУ = Объект[ИмяРеквизита];
		СписокРеквизитов = СписокРеквизитов + ",СрокИспользованияБУ";
		
	КонецЕсли;
	
	Возврат СписокРеквизитов;

КонецФункции

&НаСервере
Процедура ЗаполнитьИнформациюВПодвале()

	ЗаголовокНадписи = ВнеоборотныеАктивыСлужебный.ИнформацияОДокументеВДругомУчете(Объект);
	Если ПредварительнаяСтоимостьОтличаетсяОтФактической() Тогда
		Если ЗаголовокНадписи.Количество() <> 0 Тогда
			ЗаголовокНадписи.Добавить(Символы.ПС);
		КонецЕсли;
		ЗаголовокНадписи.Добавить(НСтр("ru = 'Стоимость, указанная в документе, отличается от фактической.';
										|en = 'Cost specified in the document differs from the actual cost.'"));
	КонецЕсли; 

	Если ЗаголовокНадписи.Количество() <> 0 Тогда
		Элементы.Информация.Заголовок = Новый ФорматированнаяСтрока(ЗаголовокНадписи);
		Элементы.КартинкаИнформация.Видимость = Истина;
		Элементы.Информация.Видимость = Истина;
	Иначе
		Элементы.КартинкаИнформация.Видимость = Ложь;
		Элементы.Информация.Видимость = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция ПредварительнаяСтоимостьОтличаетсяОтФактической()

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаКомпонентовАмортизации.КомпонентАмортизации КАК КомпонентАмортизации,
	|	ТаблицаКомпонентовАмортизации.СтоимостьБУ КАК СтоимостьБУ,
	|	ТаблицаКомпонентовАмортизации.СтоимостьУУ КАК СтоимостьУУ
	|ПОМЕСТИТЬ втТаблицаКомпонентовАмортизации
	|ИЗ
	|	&ТаблицаКомпонентовАмортизации КАК ТаблицаКомпонентовАмортизации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ТаблицаКомпонентовАмортизации.КомпонентАмортизации КАК КомпонентАмортизации
	|ИЗ
	|	втТаблицаКомпонентовАмортизации КАК ТаблицаКомпонентовАмортизации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.СтоимостьОС КАК СтоимостьОС
	|		ПО (СтоимостьОС.Регистратор = &Ссылка)
	|			И ТаблицаКомпонентовАмортизации.КомпонентАмортизации = СтоимостьОС.ОсновноеСредство
	|			И (СтоимостьОС.РасчетСтоимости)
	|			И (СтоимостьОС.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход))
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаКомпонентовАмортизации.КомпонентАмортизации
	|
	|ИМЕЮЩИЕ
	|	(МАКСИМУМ(ТаблицаКомпонентовАмортизации.СтоимостьБУ) <> СУММА(СтоимостьОС.СтоимостьРегл)
	|		ИЛИ МАКСИМУМ(ТаблицаКомпонентовАмортизации.СтоимостьУУ) <> СУММА(СтоимостьОС.Стоимость))";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("ТаблицаКомпонентовАмортизации", Объект.КомпонентыАмортизации.Выгрузить());
	
	Результат = Запрос.Выполнить();
	Результат = НЕ Результат.Пустой();
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ЗаполнитьЗначенияРеквизитовКомпонентовАмортизацииДоИзменения()

	ЗначенияРеквизитовДоИзменения = Новый Структура;
	ЗначенияРеквизитовДоИзменения.Вставить("СтоимостьУУ", 0);
	ЗначенияРеквизитовДоИзменения.Вставить("СтоимостьБУ", 0);
	
	ТекущиеДанные = Элементы.КомпонентыАмортизации.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЗначенияРеквизитовДоИзменения, ТекущиеДанные);
	КонецЕсли;
	
	ЗначенияРеквизитовКомпонентовАмортизацииДоИзменения = Новый ФиксированнаяСтруктура(ЗначенияРеквизитовДоИзменения);

КонецПроцедуры

#КонецОбласти

#КонецОбласти
