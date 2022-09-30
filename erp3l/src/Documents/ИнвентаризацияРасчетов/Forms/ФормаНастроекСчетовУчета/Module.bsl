#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВыбранныеСчетаУчета = Новый Массив;
	Если Параметры.Свойство("ВыбранныеСчетаУчета") Тогда
		ВыбранныеСчетаУчета = Параметры.ВыбранныеСчетаУчета;
	КонецЕсли;
	
	// Если установлен режим выбора, то выбранные счета учета служат фильтром для выбираемых счетов и на форме будут
	// выведены только они в виде дерева:
	Параметры.Свойство("РежимВыбора", РежимВыбора);
	РежимВыбора = ?(ЗначениеЗаполнено(РежимВыбора), РежимВыбора, Ложь);
	
	ТекущееЗначение = Неопределено;
	Параметры.Свойство("ТекущееЗначение", ТекущееЗначение);
	
	ДеревоСчетовУчета(ВыбранныеСчетаУчета, ТекущееЗначение);
	
	Элементы.ДеревоСчетовУчетаГруппаУправленияФлажками.Видимость = Не РежимВыбора;
	Элементы.ДеревоСчетовУчетаПометка.Видимость = Не РежимВыбора;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоСчетовУчета

&НаКлиенте
Процедура ДеревоСчетовУчетаПометкаПриИзменении(Элемент)
	
	СчетаУчетаМодифицированы = Истина;
	ТекущиеДанные = ТекущийЭлемент.ТекущиеДанные;
	Если ТекущиеДанные.Пометка = 2 Тогда
		ТекущиеДанные.Пометка = 0;
	КонецЕсли;
	ПометитьВложенныеЭлементы(ТекущиеДанные);
	ПометитьЭлементыРодителей(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСчетовУчетаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если РежимВыбора И Не Элементы.ДеревоСчетовУчета.ТекущиеДанные.ПолучитьЭлементы().Количество() Тогда
		СтандартнаяОбработка = Ложь;
		Закрыть(Элементы.ДеревоСчетовУчета.ТекущиеДанные.Счет);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСчетовУчетаПриАктивизацииСтроки(Элемент)
	Если РежимВыбора Тогда
		Элементы.ФормаВыбрать.Доступность = Не Элементы.ДеревоСчетовУчета.ТекущиеДанные.ПолучитьЭлементы().Количество();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВыполнить()
	
	Если РежимВыбора Тогда
		Закрыть(Элементы.ДеревоСчетовУчета.ТекущиеДанные.Счет);
	Иначе
		Закрыть(ПолучитьСчетаУчетаРекурсивно(ДеревоСчетовУчета.ПолучитьЭлементы()));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьВыполнить()
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для каждого ВложенныйЭлемент Из ДеревоСчетовУчета.ПолучитьЭлементы() Цикл
		ВложенныйЭлемент.Пометка = 1;
		ПометитьВложенныеЭлементы(ВложенныйЭлемент);
	КонецЦикла;
	СчетаУчетаМодифицированы = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для каждого ВложенныйЭлемент Из ДеревоСчетовУчета.ПолучитьЭлементы() Цикл
		ВложенныйЭлемент.Пометка = 0;
		ПометитьВложенныеЭлементы(ВложенныйЭлемент);
	КонецЦикла;
	СчетаУчетаМодифицированы = Истина;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДеревоСчетовУчета(ВыбранныеСчетаУчета, НачальноеЗначение)
	
	ГруппыДоступныхСчетовУчета = Новый Массив;
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.ФинансовыеВложения);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПоставщикамиИПодрядчиками);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПокупателямиИЗаказчиками);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоКраткосрочнымКредитамИЗаймам);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоДолгосрочнымКредитамИЗаймам);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоНалогам);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоСоциальномуСтрахованию);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПерсоналомПоОплатеТруда);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПерсоналомПоПрочимОперациям);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСРазнымиДебиторамиИКредиторами);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицами_);
	
	ИсключенияИзГрупп = Новый Массив;
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.Паи);
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.Акции);
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.ДолговыеЦенныеБумаги);
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.НДСпоАвансамИПредоплатам);
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.НДСпоАвансамИПредоплатамВыданным);
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.КорректировкаРасчетовПрошлогоПериода);
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоНДСотложенномуДляУплатыВБюджет);
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыНДСНалоговогоАгента);
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.НДСНачисленныйПоОтгрузке);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Счет,
	|	Хозрасчетный.Код КАК КодСчета,
	|	Хозрасчетный.Наименование,
	|	ВЫБОР
	|		КОГДА Хозрасчетный.Ссылка В (&ВыбранныеСчетаУчета)
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Пометка
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В ИЕРАРХИИ(&ГруппыДоступныхСчетовУчета)
	|	И НЕ Хозрасчетный.Ссылка В (&ИсключенияИзГрупп)
	|	И НЕ Хозрасчетный.ЗапретитьИспользоватьВПроводках
	|	И ВЫБОР КОГДА &РежимВыбора ТОГДА Хозрасчетный.Ссылка В (&ВыбранныеСчетаУчета) ИНАЧЕ ИСТИНА КОНЕЦ
	|ИТОГИ ПО
	|	Счет ТОЛЬКО ИЕРАРХИЯ";
	Запрос.УстановитьПараметр("ВыбранныеСчетаУчета", ВыбранныеСчетаУчета);
	Запрос.УстановитьПараметр("РежимВыбора", РежимВыбора);
	Запрос.УстановитьПараметр("ГруппыДоступныхСчетовУчета", ГруппыДоступныхСчетовУчета);
	Запрос.УстановитьПараметр("ИсключенияИзГрупп", ИсключенияИзГрупп);
	
	ДеревоСчетов = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		
	ДеревоСчетов.Колонки.Добавить("Картинка", Новый ОписаниеТипов("Картинка"));
	
	ЗначениеВРеквизитФормы(ДеревоСчетов, "ДеревоСчетовУчета");
	
	УстановитьПометкиИКартинкиДерева(ДеревоСчетовУчета.ПолучитьЭлементы(), БиблиотекаКартинок.ПланСчетов, НачальноеЗначение);
	
КонецПроцедуры

&НаСервере
Функция УстановитьПометкиИКартинкиДерева(СтрокиДерева, Картинка, НачальноеЗначение)
	
	ЕстьПомеченные = Ложь;
	ЕстьНеПомеченные = Ложь;
	
	Для каждого СтрокаДерева Из СтрокиДерева Цикл
		ПодчиненныеСтроки = СтрокаДерева.ПолучитьЭлементы();
		Если СтрокаДерева.Счет.Пустая() И СтрокаДерева.ПолучитьРодителя() = Неопределено Тогда
			Для каждого Стр Из ПодчиненныеСтроки Цикл
				НоваяСтрока = СтрокиДерева.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Стр);
			КонецЦикла;
			СтрокаПустогоСчета = СтрокаДерева;
		КонецЕсли;
		СтрокаДерева.Картинка = Картинка;
		Если ПодчиненныеСтроки.Количество() Тогда
			СтрокаДерева.Пометка = УстановитьПометкиИКартинкиДерева(ПодчиненныеСтроки, Картинка, НачальноеЗначение);
		КонецЕсли;
		
		Если СтрокаДерева.Счет = НачальноеЗначение Тогда
			Элементы.ДеревоСчетовУчета.ТекущаяСтрока = СтрокаДерева.ПолучитьИдентификатор();
		КонецЕсли;
		
		ЕстьПомеченные = ЕстьПомеченные ИЛИ СтрокаДерева.Пометка;
		ЕстьНеПомеченные = ЕстьНеПомеченные ИЛИ Не СтрокаДерева.Пометка = 1;
		
	КонецЦикла;
	
	Если Не СтрокаПустогоСчета = Неопределено Тогда
		СтрокиДерева.Удалить(СтрокаПустогоСчета);
	КонецЕсли;
	
	Возврат ЗначениеПометки(ЕстьПомеченные, ЕстьНеПомеченные);
	
КонецФункции

// Процедура рекурсивно устанавливает/снимает пометку для родителей передаваемого элемента.
//
// Параметры:
// Элемент      - ДанныеФормыКоллекцияЭлементовДерева.
//
&НаКлиенте
Процедура ПометитьЭлементыРодителей(Элемент)
	
	Родитель = Элемент.ПолучитьРодителя();
	
	Если Родитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементыРодителя = Родитель.ПолучитьЭлементы();
	Если ЭлементыРодителя.Количество() = 0 Тогда
		Родитель.Пометка = 0;
	ИначеЕсли Элемент.Пометка > 1 Тогда
		Родитель.Пометка = 2;
	Иначе
		Родитель.Пометка = ЗначениеПометкиЭлементов(ЭлементыРодителя);
	КонецЕсли;
	
	ПометитьЭлементыРодителей(Родитель);
	
КонецПроцедуры

// Процедура рекурсивно устанавливает/снимает пометку для вложенных элементов начиная
// с передаваемого элемента.
//
// Параметры:
// Элемент      - ДанныеФормыКоллекцияЭлементовДерева.
//
&НаКлиенте
Процедура ПометитьВложенныеЭлементы(Элемент)

	ВложенныеЭлементы = Элемент.ПолучитьЭлементы();
	
	Если Не ВложенныеЭлементы.Количество() = 0 Тогда
		Для Каждого ВложенныйЭлемент Из ВложенныеЭлементы Цикл
			ВложенныйЭлемент.Пометка = Элемент.Пометка;
			ПометитьВложенныеЭлементы(ВложенныйЭлемент);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЗначениеПометкиЭлементов(ЭлементыРодителя)
	
	ЕстьПомеченные = Ложь;
	ЕстьНепомеченные = Ложь;
	
	Для каждого ЭлементРодителя Из ЭлементыРодителя Цикл
		
		Если ЭлементРодителя.Пометка > 1 ИЛИ (ЕстьПомеченные И ЕстьНепомеченные) Тогда
			ЕстьПомеченные = Истина;
			ЕстьНепомеченные = Истина;
			Прервать;
		ИначеЕсли ЭлементРодителя.Пометка = 1 Тогда
			ЕстьПомеченные = ЕстьПомеченные ИЛИ ЭлементРодителя.Пометка;
			ЕстьНепомеченные = ЕстьНепомеченные ИЛИ НЕ ЭлементРодителя.Пометка;
		Иначе
			ЕстьНепомеченные = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЗначениеПометки(ЕстьПомеченные, ЕстьНеПомеченные);
	
КонецФункции

&НаКлиенте
Функция ПолучитьСчетаУчетаРекурсивно(ТекущиеЭлементыДерева)
	
	МассивВозврата = Новый Массив;
	
	Для каждого СтрокаДерева Из ТекущиеЭлементыДерева Цикл
		ПодчиненныеЭлементыТекущейСтрокеДерева = СтрокаДерева.ПолучитьЭлементы();
		Если ПодчиненныеЭлементыТекущейСтрокеДерева.Количество() И СтрокаДерева.Пометка <> 0 Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивВозврата, ПолучитьСчетаУчетаРекурсивно(ПодчиненныеЭлементыТекущейСтрокеДерева));
		ИначеЕсли СтрокаДерева.Пометка Тогда
			МассивВозврата.Добавить(СтрокаДерева.Счет);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивВозврата;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеПометки(ЕстьПомеченные, ЕстьНеПомеченные)
	
	Если ЕстьПомеченные Тогда
		Если ЕстьНепомеченные Тогда
			Возврат 2;
		Иначе
			Возврат 1;
		КонецЕсли;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

#КонецОбласти