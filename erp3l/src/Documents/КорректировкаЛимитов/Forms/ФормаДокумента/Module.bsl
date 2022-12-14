
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства	
	
	Если Параметры.Ключ.Пустая() Тогда
		ПриЧтенииСозданииНаСервере();
		Модифицированность = Истина;
	КонецЕсли;
	
	ЗаполнитьСписокГодЛимитирования();
	ЗаполнитьСвободно();
	
	#Область УХ_Согласование
	ВстраиваниеОПКПереопределяемый.НарисоватьПанельСогласованияИОпределитьСостояниеОбъекта(ЭтаФорма, Элементы.ГруппаДатаНомер);
	#КонецОбласти
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства	
	
	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
    УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства	
	
	ВычислитьРазницу();
	
	Если Параметры.Ключ.Пустая() Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	АналитикиСтатейБюджетовУХ.ЗаполнитьРеквизитыАналитикВсехСтатей(ЭтотОбъект);
	ЗаполнитьСвободно();
	УстановитьСостояниеДокумента();
	УправлениеФормой();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
    	ОбновитьЭлементыДополнительныхРеквизитов();
	    УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства	
	
	#Область УХ_Согласование
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
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ЗаписанаКорректировкаЛимитов");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	ЗаполнитьПоДаннымОснования();
	ВычислитьРазницу();
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	ПриИзмененииВалютыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ГодЛимитированияПриИзменении(Элемент)
	ГодЛимитированияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОбеспечитьЗаСчетПриИзменении(Элемент)
	ВычислитьРазницу();
	ПодключитьОбработчикОжидания("ОбновитьСвободно", 0.1, Истина);	
КонецПроцедуры

&НаКлиенте
Процедура ВидБюджетаПриИзменении(Элемент)
	ВидБюджетаПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ТекущееОснование", Объект.Основание);
	ДопПараметры.Вставить("Организация", Объект.Организация);
	ДопПараметры.Вставить("Контрагент", Объект.Контрагент);
	ДопПараметры.Вставить("ДоговорКонтрагента", Объект.ДоговорКонтрагента);
	ДопПараметры.Вставить("ЭтоКорректировкаЛимитов", Истина);
	ДопПараметры.Вставить("ВидБюджета", Истина);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОснованиеНачалоВыбораЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Документ.ЗаявкаНаКорректировкуЛимитов.Форма.ФормаВыбораОснования", ДопПараметры, Элемент,,,,
		ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеНачалоВыбораЗавершение(Результат, ДопПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Объект, Результат, "Организация, Контрагент, ДоговорКонтрагента, Основание");
	ЗаполнитьПоДаннымОснования();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
КонецПроцедуры
	
&НаКлиенте
Процедура Подключаемый_СтатьяБюджета_ПриИзменении(Элемент)
	АналитикиСтатейБюджетовУХКлиент.ПриИзмененииСтатьиБюджета(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АналитикаСтатьиБюджета_ПриИзменении(Элемент)
	АналитикиСтатейБюджетовУХКлиент.ПриИзмененииАналитикиСтатьиБюджета(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТребуется

&НаКлиенте
Процедура ТребуетсяПриИзменении(Элемент)
	ВычислитьРазницу();
	ПодключитьОбработчикОжидания("ОбновитьСвободно", 0.1, Истина);	
КонецПроцедуры

&НаКлиенте
Процедура ТребуетсяСтатьяБюджетаПриИзменении(Элемент)
	АналитикиСтатейБюджетовУХКлиент.ПриИзмененииСтатьиБюджета(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ТребуетсяПередНачаломИзменения(Элемент, Отказ)
	АналитикиСтатейБюджетовУХКлиент.ПередНачаломИзмененияСтрокиТаблицыФормы(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ТребуетсяПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	РеквизитыДляПоискаОбеспечения.Очистить();
	
	Если НоваяСтрока ИЛИ Копирование Тогда
		Элементы.Требуется.ТекущиеДанные.ВидБюджета = Объект.ВидБюджета;
		Элементы.Требуется.ТекущиеДанные.Валюта = Объект.Валюта;
		Возврат;
	КонецЕсли;
	
	// В случае изменения реквизитов, обеспечить синхронное их изменение в тч.Обеспечение для вида операции Увеличение
	ЗаполнитьЗначенияСвойств(РеквизитыДляПоискаОбеспечения.Добавить(), Элементы.Требуется.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТребуетсяПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	// В случае изменения реквизитов, обеспечить синхронное их изменение в тч.Обеспечение для вида операции Увеличение
	Если РеквизитыДляПоискаОбеспечения.Количество() > 0 Тогда
		ВыполнитьСинхронизациюСтрокОбеспечения(Элементы.Требуется.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОбеспечитьЗаСчет

&НаКлиенте
Процедура ОбеспечитьЗаСчетСтатьяБюджетаПриИзменении(Элемент)
	АналитикиСтатейБюджетовУХКлиент.ПриИзмененииСтатьиБюджета(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ОбеспечитьЗаСчетПередНачаломИзменения(Элемент, Отказ)
	АналитикиСтатейБюджетовУХКлиент.ПередНачаломИзмененияСтрокиТаблицыФормы(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
    УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
    УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ПодборОбеспечения(Команда)
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("КлючПользовательскихНастроек", "ВыборУстановленныхЛимитовСОтбором");
	ДопПараметры.Вставить("ВидБюджета", Объект.ВидБюджета);
	ДопПараметры.Вставить("Валюта", Объект.Валюта);
	ДопПараметры.Вставить("ГодЛимитирования", Объект.ГодЛимитирования);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПодборОбеспеченияЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Документ.КорректировкаЛимитов.Форма.ФормаПодбораУстановленныхЛимитов", ДопПараметры, ЭтотОбъект,,,,
		ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура УвеличитьЛимит(Команда)
	УвеличитьЛимитПоТекущейСтрокеПотребностей();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОснованию(Команда)
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Основание", Объект.Основание);
	ДопПараметры.Вставить("ДокументОбеспечения", Объект.Ссылка);
	ДопПараметры.Вставить("ДокументПланирования", Объект.ДокументДляОбеспечения);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ИзменитьВидБюджетаВалютуЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Документ.КорректировкаЛимитов.Форма.ФормаВыбораБюджетаВалютыГодаПоОснованию", ДопПараметры, ЭтотОбъект,,,,
		ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ВстраиваниеОПКПереопределяемый.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	//
	УстановитьСостояниеДокумента();

	// Данные для создания полей Аналитика* для элементов Статьи бюджетов
	АСБ = АналитикиСтатейБюджетовУХ;
	
	МассивОписанийСтатей = Новый Массив;
	АналитикиСтатейБюджетовУХ.СтатьяИАналитикиТабличнойЧастиВТаблицеФормы(МассивОписанийСтатей, 
		"Требуется",  "Требуется",
		"СтатьяБюджета", "ТребуетсяСтатьяБюджета",
		"Аналитика%1", "ТребуетсяАналитика%1",
		ФормыУХ.РазместитьВГруппе("ТребуетсяГруппаАналитика1"));
	АналитикиСтатейБюджетовУХ.СтатьяИАналитикиТабличнойЧастиВТаблицеФормы(МассивОписанийСтатей, 
		"ОбеспечитьЗаСчет",  "ОбеспечитьЗаСчет",
		"СтатьяБюджета", "ОбеспечитьЗаСчетСтатьяБюджета",
		"Аналитика%1", "ОбеспечитьЗаСчетАналитика%1",
		ФормыУХ.РазместитьВГруппе("ОбеспечитьЗаСчетГруппаАналитика1"));
	МассивОписанийСтатей[0].ТолькоЛимитируемыеАналитики = Истина;	
	МассивОписанийСтатей[1].ТолькоЛимитируемыеАналитики = Истина;
		
	// Создать элементы формы для статей бюджетов и их аналитик
	АналитикиСтатейБюджетовУХ.СоздатьСтатьиБюджетовИАналитики(ЭтотОбъект, МассивОписанийСтатей);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДаннымОснования()
	
	Документы.КорректировкаЛимитов.ЗаполнитьПоДокументуОснованию(ЭтаФорма.Объект, Объект.Основание);
	
	АналитикиСтатейБюджетовУХ.ЗаполнитьРеквизитыАналитикВсехСтатей(ЭтотОбъект);
	
	ЗаполнитьСписокГодЛимитирования();
	ЗаполнитьСвободно();
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидБюджетаВалютуЗавершение(Результат, ДопПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ВидБюджета = Результат.ВидБюджета;
	Объект.Валюта = Результат.Валюта;
	Объект.ГодЛимитирования = Результат.ГодЛимитирования;
	
	ЗаполнитьТребуетсяПоВидуБюджетаВалютеНаСервере();
	ВычислитьРазницу();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТребуетсяПоВидуБюджетаВалютеНаСервере()
	Документы.КорректировкаЛимитов.ЗаполнитьТребуетсяПоОснованию(Объект);
	АналитикиСтатейБюджетовУХ.ЗаполнитьРеквизитыАналитикВсехСтатей(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	// 
	ВидимостьКолонокСвободно = НЕ Объект.Проведен;
	Элементы.ТребуетсяСвободно.Видимость = ВидимостьКолонокСвободно;
	Элементы.ОбеспечитьЗаСчетСвободно.Видимость = ВидимостьКолонокСвободно;
	
	//
	УказаноОснование = ЗначениеЗаполнено(Объект.Основание);
	Элементы.ЗаполнитьПоОснованию.Видимость = УказаноОснование;
	Элементы.ВидБюджета.ТолькоПросмотр = УказаноОснование;
	Элементы.ВидБюджета.ПропускатьПриВводе = УказаноОснование;
	Элементы.ГодЛимитирования.ТолькоПросмотр = УказаноОснование;
	Элементы.ГодЛимитирования.ПропускатьПриВводе = УказаноОснование;
	
	Элементы.Требуется.ИзменятьСоставСтрок = НЕ УказаноОснование;
	Элементы.Требуется.ТолькоПросмотр = УказаноОснование;
	
	//
	ВалютаДоступна = Объект.СпособОпределенияВалютыЛимитирования = Перечисления.СпособыОпределенияВалютыЛимитирования.ВалютаОперации
		ИЛИ Объект.СпособОпределенияВалютыЛимитирования = Перечисления.СпособыОпределенияВалютыЛимитирования.ВалютаЛимитированияЦФО;
	Элементы.Валюта.ТолькоПросмотр = УказаноОснование ИЛИ НЕ ВалютаДоступна;
	Элементы.Валюта.ПропускатьПриВводе = УказаноОснование ИЛИ НЕ ВалютаДоступна;
	
	// Параметры выбора ЦФО
	Если Объект.СпособОпределенияВалютыЛимитирования = Перечисления.СпособыОпределенияВалютыЛимитирования.ВалютаЛимитированияЦФО Тогда
		Элементы.ТребуетсяЦФО.ФормаВыбора = "РегистрСведений.ПараметрыЛимитированияЦФО.Форма.ФормаВыбораЦФО";
		ФормыУХКлиентСервер.ДобавитьСвязьПараметровВыбора(Элементы.ТребуетсяЦФО, "Отбор.ВалютаЛимитирования", "Объект.Валюта");
	Иначе
		ФормыУХКлиентСервер.УдалитьСвязьПараметровВыбора(Элементы.ТребуетсяЦФО, "Отбор.ВалютаЛимитирования", "Объект.Валюта");
		Элементы.ТребуетсяЦФО.ФормаВыбора = "";
	КонецЕсли;
	
	Элементы.ОбеспечитьЗаСчетПодборОбеспечения.Доступность = НЕ ТолькоПросмотр;
	Элементы.ОбеспечитьЗаСчетУвеличитьЛимит.Доступность = НЕ ТолькоПросмотр;
	Элементы.ЗаполнитьПоОснованию.Доступность = НЕ ТолькоПросмотр;
	
КонецПроцедуры

&НаКлиенте
Процедура УвеличитьЛимитПоТекущейСтрокеПотребностей()
	
	ТД = Элементы.Требуется.ТекущиеДанные;
	Если ТД = неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//
	Реквизиты = "ЦФО, Проект, СтатьяБюджета, Аналитика1, Аналитика2, Аналитика3, Аналитика4, Аналитика5, Аналитика6, ПериодЛимитирования, КОбеспечению";
	
	//
	СтрокаОбеспечения = Объект.ОбеспечитьЗаСчет.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаОбеспечения, ТД);
	СтрокаОбеспечения.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийКорректировкаЛимитов.Увеличение");
	
	//
	ТекущиеДанные = Новый Структура(Реквизиты);
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ТД);
	СтрокаОбеспечения.Сумма = РассчитатьСуммуУвеличения(ТекущиеДанные);
	
	ЗаполнитьСвободно();
	ВычислитьРазницу();
	
КонецПроцедуры

&НаСервере
Функция РассчитатьСуммуУвеличения(ТекущиеДанные)
	
	Реквизиты = "ЦФО, Проект, СтатьяБюджета, Аналитика1, Аналитика2, Аналитика3, Аналитика4, Аналитика5, Аналитика6, ПериодЛимитирования";
	
	//
	Требуется = Объект.Требуется.Выгрузить();
	Требуется.Колонки.Добавить("Сумма", Метаданные.ОпределяемыеТипы.ДенежнаяСуммаЛюбогоЗнака.Тип);
	
	Для Каждого Строка Из Требуется Цикл
		Строка.Сумма = Строка.КОбеспечению;
	КонецЦикла;
	
	Для Каждого СтрокаОбеспечение Из Объект.ОбеспечитьЗаСчет Цикл
		Если СтрокаОбеспечение.ВидОперации = Перечисления.ВидыОперацийКорректировкаЛимитов.Увеличение Тогда
			Строка = Требуется.Добавить();
			ЗаполнитьЗначенияСвойств(Строка, СтрокаОбеспечение);
			Строка.Сумма = -СтрокаОбеспечение.Сумма;
		КонецЕсли;
	КонецЦикла;
	
	Требуется.Свернуть(Реквизиты, "Сумма");
	
	СтруктураПоиска = Новый Структура(Реквизиты);
	ЗаполнитьЗначенияСвойств(СтруктураПоиска, ТекущиеДанные);
	
	Строки = Требуется.НайтиСтроки(СтруктураПоиска);
	Если Строки.Количество() > 0 Тогда
		
		
		ЗакрытоПереносом = Объект.ОбеспечитьЗаСчет.Выгрузить(Новый Структура("ВидОперации", Перечисления.ВидыОперацийКорректировкаЛимитов.Перенос)).Итог("Сумма");
		Осталось = Требуется.Итог("Сумма") - ЗакрытоПереносом;
		Если Осталось <0 Тогда
			Осталось = 0;
		КонецЕсли;
		
		Возврат Мин(Строки[0].Сумма, Осталось);
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьСинхронизациюСтрокОбеспечения(ТД)
	
	Если ТД = неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РеквизитыДляПоискаОбеспечения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИменаРеквизитов = "ЦФО, Проект, СтатьяБюджета, Аналитика1, Аналитика2, Аналитика3, Аналитика4, Аналитика5, Аналитика6, ПериодЛимитирования";
	СтруктураПоиска = Новый Структура(ИменаРеквизитов);
	ЗаполнитьЗначенияСвойств(СтруктураПоиска, РеквизитыДляПоискаОбеспечения[0]);
	
	Если НЕ ИзменилисьЗначения(СтруктураПоиска, ТД) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПоиска.Вставить("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийКорректировкаЛимитов.Увеличение"));
	
	Для Каждого Строка Из Объект.ОбеспечитьЗаСчет.НайтиСтроки(СтруктураПоиска) Цикл
		ЗаполнитьЗначенияСвойств(Строка, ТД, ИменаРеквизитов);
		АналитикиСтатейБюджетовУХКлиент.ПриИзмененииСтатьиБюджета(ЭтотОбъект, Элементы.ОбеспечитьЗаСчетСтатьяБюджета.Имя);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ИзменилисьЗначения(СтруктураПоиска, ТД)
	
	Для Каждого КлючЗначение Из СтруктураПоиска Цикл
		
		ТекущееЗначение = неопределено;
		Если НЕ ТД.Свойство(КлючЗначение.Ключ, ТекущееЗначение) Тогда
			Продолжить;
		КонецЕсли;
		
		Если КлючЗначение.Значение <> ТекущееЗначение Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура ВычислитьРазницу()
	Разница = Объект.Требуется.Итог("КОбеспечению") - Объект.ОбеспечитьЗаСчет.Итог("Сумма");
	
	Текст = НСтр("ru = 'Требуется увеличить лимиты бюджета'");
	Если Разница <> 0 Тогда
		Текст = СтрШаблон(Текст + " (%1 %2)", Разница, Объект.Валюта)
	КонецЕсли;
	Элементы.ГруппаТребуетсяУвеличитьЛимитыБюджета.Заголовок = Текст;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТаблицуСвободно()
	
	ИменаРеквизитов = "ПериодЛимитирования, ЦФО, Проект, СтатьяБюджета, Аналитика1, Аналитика2, Аналитика3, Аналитика4, Аналитика5, Аналитика6";
	
	ДанныеДокумента = Объект.Требуется.Выгрузить(, ИменаРеквизитов);
	ДанныеДокумента.Колонки.Добавить("ВидБюджета", Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ВидыБюджетов"));
	ДанныеДокумента.Колонки.Добавить("Предназначение", Новый ОписаниеТипов("ПеречислениеСсылка.ПредназначенияЭлементовСтруктурыОтчета"));
	ДанныеДокумента.Колонки.Добавить("Валюта", Новый ОписаниеТипов("СправочникСсылка.Валюты"));
	ИменаРеквизитов = "ВидБюджета, Предназначение, Валюта," + ИменаРеквизитов;
	
	Для Каждого Строка Из Объект.ОбеспечитьЗаСчет Цикл
		ЗаполнитьЗначенияСвойств(ДанныеДокумента.Добавить(), Строка);
	КонецЦикла;
	ДанныеДокумента.ЗаполнитьЗначения(Объект.ВидБюджета, "ВидБюджета");
	ДанныеДокумента.ЗаполнитьЗначения(Объект.ВидБюджета.Предназначение, "Предназначение");
	ДанныеДокумента.ЗаполнитьЗначения(Объект.Валюта, "Валюта");
	ДанныеДокумента.Свернуть(ИменаРеквизитов, "");
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ОбщегоНазначенияОПК.ЗагрузитьТаблицуВоВременнуюТаблицуЗапроса(Запрос, "ВТ_Данные", ДанныеДокумента);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыБюджетов.Ссылка КАК ВидБюджета,
	|	ЛимитыПоБюджетамОбороты.Предназначение КАК Предназначение,
	|	ЛимитыПоБюджетамОбороты.ПериодЛимитирования КАК ПериодЛимитирования,
	|	ЛимитыПоБюджетамОбороты.ЦФО КАК ЦФО,
	|	ЛимитыПоБюджетамОбороты.Проект КАК Проект,
	|	ЛимитыПоБюджетамОбороты.СтатьяБюджета КАК СтатьяБюджета,
	|	ЛимитыПоБюджетамОбороты.Аналитика1 КАК Аналитика1,
	|	ЛимитыПоБюджетамОбороты.Аналитика2 КАК Аналитика2,
	|	ЛимитыПоБюджетамОбороты.Аналитика3 КАК Аналитика3,
	|	ЛимитыПоБюджетамОбороты.Аналитика4 КАК Аналитика4,
	|	ЛимитыПоБюджетамОбороты.Аналитика5 КАК Аналитика5,
	|	ЛимитыПоБюджетамОбороты.Аналитика6 КАК Аналитика6,
	|	ЛимитыПоБюджетамОбороты.Валюта КАК Валюта,
	|	ЛимитыПоБюджетамОбороты.ЛимитОборот КАК ЛимитОборот,
	|	ЛимитыПоБюджетамОбороты.КорректировкаОборот КАК КорректировкаОборот,
	|	ЛимитыПоБюджетамОбороты.ЗарезервированоОборот КАК ЗарезервированоОборот,
	|	ЛимитыПоБюджетамОбороты.ЗаявленоОборот КАК ЗаявленоОборот,
	|	ЛимитыПоБюджетамОбороты.ИсполненоОборот КАК ИсполненоОборот,
	|	ЛимитыПоБюджетамОбороты.КОбеспечениюОборот КАК КОбеспечениюОборот,
	|	ЛимитыПоБюджетамОбороты.ЛимитОборот + ЛимитыПоБюджетамОбороты.КорректировкаОборот - ЛимитыПоБюджетамОбороты.ЗарезервированоОборот - ЛимитыПоБюджетамОбороты.ЗаявленоОборот - ЛимитыПоБюджетамОбороты.ИсполненоОборот КАК Свободно
	|ИЗ
	|	РегистрНакопления.ЛимитыПоБюджетам.Обороты(
	|			,
	|			,
	|			,
	|			(Предназначение, ПериодЛимитирования, Валюта, ЦФО, Проект, СтатьяБюджета, Аналитика1, Аналитика2, Аналитика3, Аналитика4, Аналитика5, Аналитика6) В
	|				(ВЫБРАТЬ
	|					ВТ_Данные.Предназначение,
	|					ВТ_Данные.ПериодЛимитирования,
	|					ВТ_Данные.Валюта,
	|					ВТ_Данные.ЦФО,
	|					ВТ_Данные.Проект,
	|					ВТ_Данные.СтатьяБюджета,
	|					ВТ_Данные.Аналитика1,
	|					ВТ_Данные.Аналитика2,
	|					ВТ_Данные.Аналитика3,
	|					ВТ_Данные.Аналитика4,
	|					ВТ_Данные.Аналитика5,
	|					ВТ_Данные.Аналитика6
	|				ИЗ
	|					ВТ_Данные)) КАК ЛимитыПоБюджетамОбороты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.ВидыБюджетов КАК ВидыБюджетов
	|		ПО ЛимитыПоБюджетамОбороты.Предназначение = ВидыБюджетов.Предназначение";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСвободно()
	
	ИменаРеквизитов = "ВидБюджета, ПериодЛимитирования, Валюта, ЦФО, Проект, СтатьяБюджета, Аналитика1, Аналитика2, Аналитика3, Аналитика4, Аналитика5, Аналитика6";
	
	ТаблицаСвободно = ПолучитьТаблицуСвободно();
	
	СтруктураПоиска = Новый Структура(ИменаРеквизитов);
	
	Для Каждого Строка Из Объект.Требуется Цикл
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, Строка);
		СтруктураПоиска.ВидБюджета = Объект.ВидБюджета;
		СтруктураПоиска.Валюта = Объект.Валюта;
		Строки = ТаблицаСвободно.НайтиСтроки(СтруктураПоиска);
		Если Строки.Количество() = 0 Тогда
			Строка.Свободно = 0;
		Иначе
			Строка.Свободно = Строки[0].Свободно;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Строка Из Объект.ОбеспечитьЗаСчет Цикл
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, Строка);
		СтруктураПоиска.ВидБюджета = Объект.ВидБюджета;
		СтруктураПоиска.Валюта = Объект.Валюта;
		
		Строки = ТаблицаСвободно.НайтиСтроки(СтруктураПоиска);
		Если Строки.Количество() = 0 Тогда
			Строка.Свободно = 0;
		Иначе
			Строка.Свободно = Строки[0].Свободно;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСвободно()
	ЗаполнитьСвободно();
КонецПроцедуры

&НаСервере
Процедура ВидБюджетаПриИзмененииНаСервере()
	
	ЗаполнитьСписокГодЛимитирования();
	ГодЛимитированияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ГодЛимитированияПриИзмененииНаСервере()
	Документы.КорректировкаЛимитов.ЗаполнитьПараметрыЛимитирования(ЭтотОбъект.Объект);
	УдалитьОшибочныеСтроки();
	УправлениеФормой();
КонецПроцедуры

&НаСервере
Процедура УдалитьОшибочныеСтроки()
	ТребуетсяОшибочные = ПолучитьТребуетсяНеСоответствуютНастройкам();
	Если ТребуетсяОшибочные.Количество() > 0 Тогда
		УдалитьТребуетсяПоИдентификаторам(ТребуетсяОшибочные);
		Объект.ОбеспечитьЗаСчет.Очистить();
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДатыНачалаДействияПараметровЛимитирования(ВидБюджета, Год)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидБюджета", ВидБюджета);
	Запрос.УстановитьПараметр("Год", Год);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПараметрыЛимитирования.ВидБюджета КАК ВидБюджета,
	|	ПараметрыЛимитирования.Период КАК Период
	|ИЗ
	|	РегистрСведений.ПараметрыЛимитирования КАК ПараметрыЛимитирования
	|ГДЕ
	|	ПараметрыЛимитирования.ВидБюджета = &ВидБюджета
	|
	|ОБЪЕДИНИТЬ // Так должно быть
	|
	|ВЫБРАТЬ
	|	&ВидБюджета,
	|	&Год
	|ГДЕ
	|	&Год <> ДАТАВРЕМЯ(1,1,1,0,0,0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Период");
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокГодЛимитирования()
	
	ДатыПараметровЛимитирования = ПолучитьДатыНачалаДействияПараметровЛимитирования(Объект.ВидБюджета, Объект.ГодЛимитирования);
	
	Элемент = Элементы.ГодЛимитирования;
	Элемент.СписокВыбора.Очистить();
	
	Для Каждого Дата Из ДатыПараметровЛимитирования Цикл
		Элемент.СписокВыбора.Добавить(Дата, Формат(Дата, "ДФ=гггг"));
	КонецЦикла;
	
	Если Элемент.СписокВыбора.Количество() = 0 Тогда
		Объект.ГодЛимитирования = 0;
	ИначеЕсли Элемент.СписокВыбора.НайтиПоЗначению(Объект.ГодЛимитирования) = неопределено Тогда
		Объект.ГодЛимитирования = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТребуетсяНеСоответствуютНастройкам()
	
	Периоды = Объект.Требуется.Выгрузить(, "ПериодЛимитирования").ВыгрузитьКолонку("ПериодЛимитирования");
	ДатаНачалаПериодовЛимитирования = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(Периоды, "ДатаНачала");
	
	Результат = Новый Массив;
	Для Каждого Строка Из Объект.Требуется Цикл
		Если НЕ СтрокаСоответствуетТребованиям(Строка, ДатаНачалаПериодовЛимитирования) Тогда
			Результат.Добавить(Строка.ПолучитьИдентификатор());
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция СтрокаСоответствуетТребованиям(Строка, ДатаНачалаПериодовЛимитирования)
	
	Данные = ДатаНачалаПериодовЛимитирования[Строка.ПериодЛимитирования];
	Если Данные = неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Год = НачалоГода(Данные.ДатаНачала);
	
	Если Строка.ВидБюджета = Объект.ВидБюджета
		И Строка.Валюта = Объект.Валюта
		И Год = Объект.ГодЛимитирования Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УдалитьТребуетсяПоИдентификаторам(Идентификаторы)
	
	Для Каждого Идентификатор Из Идентификаторы Цикл
		Строка = Объект.Требуется.НайтиПоИдентификатору(Идентификатор);
		Если Строка <> неопределено Тогда
			Объект.Требуется.Удалить(Строка);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииВалютыНаСервере()
	
	УдалитьОшибочныеСтроки();
	
КонецПроцедуры

#Область ВызовыОбщихПроцедурИФункцийСогласованияОбъектов

&НаСервере
Процедура ОпределитьСостояниеОбъекта(ОбновитьОтветственныхВход = Ложь)
	ВстраиваниеОПКПереопределяемый.ОпределитьСостояниеЗаявки(ЭтаФорма, ОбновитьОтветственныхВход);
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбъектаПриИзменении_Подключаемый()
	НовоеЗначениеСтатуса = РеквизитСтатусОбъекта(ЭтаФорма);
	ПроверитьСохранениеИзменитьСтатус(НовоеЗначениеСтатуса);	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбъектаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение = РеквизитСтатусОбъекта(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьСохранениеИзменитьСтатус(ВыбранноеЗначение);
КонецПроцедуры

// Проверяет сохранение текущего объекта и изменяет его статус
// НовоеЗначениеСтатусаВход.
&НаКлиенте
Процедура ПроверитьСохранениеИзменитьСтатус(НовоеЗначениеСтатусаВход)
	Если (Объект.Ссылка.Пустая()) ИЛИ (ЭтаФорма.Модифицированность) Тогда
		СтруктураПараметров = Новый Структура("ВыбранноеЗначение", НовоеЗначениеСтатусаВход);
		ОписаниеОповещения = Новый ОписаниеОповещения("СостояниеЗаявкиОбработкаВыбораПродолжение", ЭтотОбъект, СтруктураПараметров);
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
		|Изменение состояния возможно только после записи данных.
		|Данные будут записаны.'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		Возврат;
	КонецЕсли;
	ИзменитьСостояниеЗаявкиКлиент(НовоеЗначениеСтатусаВход);	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеЗаявкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение = РеквизитСостояниеЗаявки(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;

	ПроверитьСохранениеИзменитьСтатус(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение)
	ВстраиваниеОПККлиентПереопределяемый.ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СостояниеЗаявкиОбработкаВыбораПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Записать();
		ИзменитьСостояниеЗаявкиКлиент(Параметры.ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИзменитьСостояниеЗаявки(Ссылка, Состояние)
	Возврат ВстраиваниеОПКПереопределяемый.ПеревестиЗаявкуВПроизвольноеСостояние(Ссылка, Состояние, , , ЭтаФорма);
КонецФункции

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

&НаКлиенте
Процедура ПриИзмененииЭлементаОрганизации_Подключаемый(Элемент) Экспорт
	ОпределитьСостояниеОбъекта(Истина);		
	ВыполнитьПредыдущийОбработчикПриИзмененииОрганизации(Элемент);
КонецПроцедуры		// ПриИзмененииЭлементаОрганизации_Подключаемый()

// Возвращает значение реквизита СостояниеЗаявки на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСостояниеЗаявки(ФормаВход)
	Возврат ФормаВход["СостояниеЗаявки"];
КонецФункции

// Возвращает значение реквизита СтатусОбъекта на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСтатусОбъекта(ФормаВход)
	Возврат ФормаВход["СтатусОбъекта"];
КонецФункции

// Возвращает значение реквизита Согласующий на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСогласующий(ФормаВход)
	Возврат ФормаВход["Согласующий"];
КонецФункции

// Выполняет обработчик ПриИзменении, сопоставленный по умолчанию для элемента Элемент
&НаКлиенте
Процедура ВыполнитьПредыдущийОбработчикПриИзмененииОрганизации(Элемент)
	#Если НЕ ВебКлиент Тогда
	ИмяЭлемента = Элемент.Имя;
	Если ЗначениеЗаполнено(ИмяЭлемента) Тогда
		Для Каждого ТекОбработчикиИзмененияОрганизации Из ЭтаФорма["ОбработчикиИзмененияОрганизации"] Цикл
			Если СокрЛП(ТекОбработчикиИзмененияОрганизации.ИмяРеквизита) = СокрЛП(ИмяЭлемента) Тогда
				СтрокаВыполнения = ТекОбработчикиИзмененияОрганизации.ИмяОбработчика + "(Элемент);";
				Выполнить СтрокаВыполнения;
			Иначе
				// Выполняем поиск далее.
			КонецЕсли; 
		КонецЦикла;	
	Иначе
		// Передан пустой элемент.
	КонецЕсли;
	#КонецЕсли
КонецПроцедуры		// ВыполнитьПредыдущийОбработчикПриИзмененииОрганизации()	

#КонецОбласти

&НаКлиенте
Процедура ПодборОбеспеченияЗавершение(Результат, ДопПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	Осталось = Объект.Требуется.Итог("КОбеспечению") - Объект.ОбеспечитьЗаСчет.Итог("Сумма");
	Если Осталось < 0 Тогда
		Осталось = 0;
	КонецЕсли;
	
	Строка = Объект.ОбеспечитьЗаСчет.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, Результат);
	Строка.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийКорректировкаЛимитов.Перенос");
	Строка.Сумма = Мин(Результат.Свободно, Осталось);
	
	ВычислитьРазницу();
	ПослеПодбораОбеспечения();
	
КонецПроцедуры

&НаСервере
Процедура ПослеПодбораОбеспечения()
	ЗаполнитьСвободно();
	АналитикиСтатейБюджетовУХ.ЗаполнитьРеквизитыАналитикВсехСтатей(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПустоеНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

