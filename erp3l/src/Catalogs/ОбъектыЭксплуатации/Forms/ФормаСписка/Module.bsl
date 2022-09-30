
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	НастроитьЗависимыеЭлементыФормы();
	УстановитьДоступность(ЭтотОбъект);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьОтборы(ЭтотОбъект);
	УстановитьДоступность(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСтатусПриИзменении(Элемент)
	
	УстановитьОтборы(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОтборЭксплуатирующееПодразделениеПриИзменении(Элемент)
	
	УстановитьОтборы(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОтборКлассПриИзменении(Элемент)
	
	УстановитьОтборы(ЭтотОбъект);
	УстановитьДоступность(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОтборПодклассПриИзменении(Элемент)
	
	УстановитьОтборы(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСтатусРедактируется(Команда)
	
	УстановитьСтатус("Редактируется", НСтр("ru = 'Редактируется';
											|en = 'Being edited'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусВЭксплуатации(Команда)
	
	УстановитьСтатус("ВЭксплуатации", НСтр("ru = 'В эксплуатации';
											|en = 'In operation'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЛиквидирован(Команда)
	
	УстановитьСтатус("Ликвидирован", НСтр("ru = 'Ликвидирован';
											|en = 'Disposed'"));

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьКласс(Команда)
	
	//++ НЕ УТКА
	ВыделенныеСсылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	УправлениеРемонтамиКлиент.ИзменитьКлассОбъектовЭксплуатации(ВыделенныеСсылки);
	//-- НЕ УТКА
	
	Возврат; // В КА пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список, Список);
	
КонецПроцедуры

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормы()
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеРемонтами")
		ИЛИ НЕ ПравоДоступа("Редактирование", Метаданные.Справочники.ОбъектыЭксплуатации) Тогда
		
		Элементы.УстановитьСтатусРедактируется.Видимость = Ложь;
		Элементы.УстановитьСтатусВЭксплуатации.Видимость = Ложь;
		Элементы.УстановитьСтатусЛиквидирован.Видимость = Ложь;
		Элементы.ИзменитьКласс.Видимость = Ложь;
		Элементы.ИзменитьВыделенные.Видимость = Ложь;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборы(Форма)
	
	Список = Форма.Список;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Статус",
		Форма.ОтборСтатус,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Форма.ОтборСтатус));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ЭксплуатирующееПодразделение",
		Форма.ОтборЭксплуатирующееПодразделение,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Форма.ОтборЭксплуатирующееПодразделение));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Класс",
		Форма.ОтборКласс,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Форма.ОтборКласс));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Подкласс",
		Форма.ОтборПодкласс,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Форма.ОтборПодкласс));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатус(ЗначениеСтатуса, ПредставлениеСтатуса)

	//++ НЕ УТКА
	ВыделенныеСсылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	УправлениеРемонтамиКлиент.УстановитьСтатусОбъектовЭксплуатации(ЗначениеСтатуса, ПредставлениеСтатуса, ВыделенныеСсылки);
	//-- НЕ УТКА

	Возврат; // В КА пустой обработчик

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Справочник.ОбъектыЭксплуатации.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступность(Форма)
	
	Элементы = Форма.Элементы;
	Элементы.ОтборПодкласс.ТолькоПросмотр = НЕ ЗначениеЗаполнено(Форма.ОтборКласс);
	
КонецПроцедуры

#КонецОбласти