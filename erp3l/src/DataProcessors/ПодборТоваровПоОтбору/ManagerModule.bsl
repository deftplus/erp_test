#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция подготавливает структуру данных, необходимую для печати ценников и этикеток.
//
// Параметры:
//  СтруктураНастроек - Структура - данные, структура настроек.
//
// Возвращаемое значение:
//  Структура - данные, необходимые для печати этикеток и ценников.
//
Функция ПодготовитьСтруктуруДанных(СтруктураНастроек) Экспорт
	
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("ТаблицаТоваров",                             Неопределено);
	СтруктураРезультата.Вставить("СоответствиеПолейСКДКолонкамТаблицыТоваров", Новый Соответствие);

#Область ПодготовкаСхемыКомпоновкиДанныхИКомпоновщикаНастроекСкд
	
	// Схема компоновки.
	СхемаКомпоновкиДанных = Обработки.ПодборТоваровПоОтбору.ПолучитьМакет(СтруктураНастроек.ИмяМакетаСхемыКомпоновкиДанных);
	
	Если СтруктураНастроек.Свойство("ИспользуетсяОтборПоВнешнемуИсточникуДанных") Тогда
		ВнешниеНаборыДанных = Неопределено;
		Если СтруктураНастроек.Свойство("ТаблицаТоваров") Тогда
			КолонкиТаблицыТоваров = СтруктураНастроек.ТаблицаТоваров.Колонки;
			МассивКолонок = Новый Массив();

			Если Не КолонкиТаблицыТоваров.Найти("ВидЦены") = Неопределено Тогда
				МассивКолонок.Добавить("ВидЦены");
			КонецЕсли;
		
			Если Не КолонкиТаблицыТоваров.Найти("Цена") = Неопределено Тогда
				МассивКолонок.Добавить("Цена");
			КонецЕсли;

			НастроитьНаборыДанных(СхемаКомпоновкиДанных, КолонкиТаблицыТоваров);

			ДопИменаКолонок = СтрСоединить(МассивКолонок, ", ");
			Если ЗначениеЗаполнено(ДопИменаКолонок) Тогда
				ДопИменаКолонок = ", " + ДопИменаКолонок;
			КонецЕсли;
			
			ВнешниеНаборыДанных = Новый Структура;
			ТаблицаДляИсточника = СтруктураНастроек.ТаблицаТоваров.Скопировать(, "Номенклатура, Характеристика, Серия, Упаковка" + ДопИменаКолонок);// ТаблицаЗначений
			ТаблицаДляИсточника.Свернуть("Номенклатура, Характеристика, Серия, Упаковка" + ДопИменаКолонок);
			ВнешниеНаборыДанных.Вставить("ТаблицаНоменклатуры", ТаблицаДляИсточника);
		КонецЕсли;
	КонецЕсли;
	
	// Подготовка компоновщика макета компоновки данных.
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	Компоновщик.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	Компоновщик.Настройки.Отбор.Элементы.Очистить();
	Компоновщик.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.Полное);
	
	// Отбор и сортировка компоновщика настроек.
	Если СтруктураНастроек.КомпоновщикНастроек <> Неопределено Тогда
		
		КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(
			Компоновщик.Настройки.Отбор,
			СтруктураНастроек.КомпоновщикНастроек.Настройки.Отбор);
			
		КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(
			Компоновщик.Настройки.Порядок,
			СтруктураНастроек.КомпоновщикНастроек.Настройки.Порядок);
			
	КонецЕсли;
	
	ИспользоватьАссортимент = ПолучитьФункциональнуюОпцию("ИспользоватьАссортимент");
	Если ИспользоватьАссортимент Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Компоновщик.Настройки, "АссортиментНаДату", ТекущаяДатаСеанса());
	КонецЕсли;
	
	Если СтруктураНастроек.Свойство("ЦеныНаДату") Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Компоновщик.Настройки, "ЦеныНаДату", СтруктураНастроек.ЦеныНаДату);
	КонецЕсли;
	
	Если СтруктураНастроек.Свойство("Поставщик") Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Компоновщик.Настройки, "Поставщик", СтруктураНастроек.Поставщик);
	КонецЕсли;
	
	Если СтруктураНастроек.Свойство("ОтборПоВариантуРасчетаЦенНаборов") Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			Компоновщик.Настройки.Отбор,
			"ВариантРасчетаЦеныНабора",
			ВидСравненияКомпоновкиДанных.ВСписке,
			СтруктураНастроек.ОтборПоВариантуРасчетаЦенНаборов,
			Неопределено,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	КонецЕсли;
	
	Если СтруктураНастроек.ВестиУчетСертификатовНоменклатуры Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Компоновщик.Настройки, "ВестиУчетСертификатовНоменклатуры", Истина);
	КонецЕсли;
	
	Если СтруктураНастроек.Свойство("ИспользуетсяОтборПоВнешнемуИсточникуДанных") Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Компоновщик.Настройки, "ИспользуетсяОтборПоВнешнемуИсточникуДанных", СтруктураНастроек.ИспользуетсяОтборПоВнешнемуИсточникуДанных);
	Иначе	
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Компоновщик.Настройки, "ИспользуетсяОтборПоВнешнемуИсточникуДанных", Ложь);
	КонецЕсли;
	
	// Выбранные поля компоновщика настроек.
	Для Каждого ОбязательноеПоле Из СтруктураНастроек.ОбязательныеПоля Цикл
		ПолеСКД = КомпоновкаДанныхСервер.НайтиПолеСКДПоПолномуИмени(Компоновщик.Настройки.Выбор.ДоступныеПоляВыбора.Элементы, ОбязательноеПоле);
		Если ПолеСКД <> Неопределено Тогда
			ВыбранноеПоле = Компоновщик.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПоле.Поле = ПолеСКД.Поле;
		КонецЕсли;
	КонецЦикла;
	
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(Компоновщик);
	
	// Компоновка макета компоновки данных.
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(
		СхемаКомпоновкиДанных,
		Компоновщик.ПолучитьНастройки(),,,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));

#КонецОбласти

#Область ПодготовкаВспомогательныхДанныхДляСопоставленияПолейШаблонаИСкд
	
	Для каждого Поле Из МакетКомпоновкиДанных.НаборыДанных.НаборДанных.Поля Цикл
		СтруктураРезультата.СоответствиеПолейСКДКолонкамТаблицыТоваров.Вставить(
			Справочники.ШаблоныЭтикетокИЦенников.ИмяПоляВШаблоне(Поле.ПутьКДанным), Поле.Имя);
	КонецЦикла;

#КонецОбласти

#Область ПодготовкаТаблицыТоваров
	
	ТаблицаТоваров = Новый ТаблицаЗначений;
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	Если ВнешниеНаборыДанных = Неопределено Тогда
		ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
	Иначе
		ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, ВнешниеНаборыДанных);
	КонецЕсли;
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаТоваров);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	СтруктураРезультата.ТаблицаТоваров = ТаблицаТоваров;
	
	Возврат СтруктураРезультата;
	
#КонецОбласти

КонецФункции

Процедура НастроитьНаборыДанных(СхемаКомпоновкиДанных, КолонкиТаблицыТоваров)

	ИспользоватьХарактеристикиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	ИспользоватьСерииНоменклатуры          = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры");
	ИспользоватьУпаковкиНоменклатуры       = ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры");

	РабочийНаборДанных = СхемаКомпоновкиДанных.НаборыДанных[0];

	НаборДанныхНоменклатура                = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
	НаборДанныхНоменклатура.Имя            = "ТаблицаНоменклатуры";
	НаборДанныхНоменклатура.ИмяОбъекта     = "ТаблицаНоменклатуры";
	НаборДанныхНоменклатура.ИсточникДанных = РабочийНаборДанных.ИсточникДанных;
	
	СхемаКомпоновкиДанных.СвязиНаборовДанных.Очистить();
	
	ДобавитьПолеНабораДанныхСКД(НаборДанныхНоменклатура, "Номенклатура", "СправочникСсылка.Номенклатура");
	ДобавитьСвязьНаборовДанныхСКД(СхемаКомпоновкиДанных, НаборДанныхНоменклатура, РабочийНаборДанных, "Номенклатура");
	
	Если ИспользоватьХарактеристикиНоменклатуры И КолонкиТаблицыТоваров.найти("Характеристика") <> Неопределено Тогда
		ДобавитьПолеНабораДанныхСКД(НаборДанныхНоменклатура, "Характеристика", "СправочникСсылка.ХарактеристикиНоменклатуры");
		ДобавитьСвязьНаборовДанныхСКД(СхемаКомпоновкиДанных, НаборДанныхНоменклатура, РабочийНаборДанных, "Характеристика");
	КонецЕсли;
		
	Если ИспользоватьСерииНоменклатуры И КолонкиТаблицыТоваров.найти("Серия") <> Неопределено Тогда
		ДобавитьПолеНабораДанныхСКД(НаборДанныхНоменклатура, "Серия", "СправочникСсылка.СерииНоменклатуры");
		ДобавитьСвязьНаборовДанныхСКД(СхемаКомпоновкиДанных, НаборДанныхНоменклатура, РабочийНаборДанных, "Серия");
	КонецЕсли;
	
	Если ИспользоватьУпаковкиНоменклатуры И КолонкиТаблицыТоваров.найти("Упаковка") <> Неопределено Тогда
		ДобавитьПолеНабораДанныхСКД(НаборДанныхНоменклатура, "Упаковка", "СправочникСсылка.УпаковкиЕдиницыИзмерения");
		ДобавитьСвязьНаборовДанныхСКД(СхемаКомпоновкиДанных, НаборДанныхНоменклатура, РабочийНаборДанных, "Упаковка");
	КонецЕсли;

	Если КолонкиТаблицыТоваров.найти("ВидЦены") <> Неопределено Тогда
		ДобавитьПолеНабораДанныхСКД(НаборДанныхНоменклатура, "ВидЦены", "СправочникСсылка.ВидыЦен");
	КонецЕсли;

	Если КолонкиТаблицыТоваров.найти("Цена") <> Неопределено Тогда
		ДобавитьПолеНабораДанныхСКД(НаборДанныхНоменклатура, "Цена", "Число");
	КонецЕсли;

КонецПроцедуры


// Параметры:
// 	СКД - СхемаКомпоновкиДанных - Изменяемая схема компоновки данных
// 	НаборДанныхНоменклатура - НаборДанныхОбъектСхемыКомпоновкиДанных - Набор данных
// 	РабочийНаборДанных - НаборДанныхОбъектСхемыКомпоновкиДанных - Набор данных
// 	Поле - Строка - Поле для выражения-источника и выражения-приемника
// 
Процедура ДобавитьСвязьНаборовДанныхСКД(СКД, НаборДанныхНоменклатура, РабочийНаборДанных, Поле, ПолеРабочегоНабора = Неопределено)
	
	Связь                     = СКД.СвязиНаборовДанных.Добавить();
	Связь.НаборДанныхИсточник = НаборДанныхНоменклатура.Имя;
	Связь.НаборДанныхПриемник = РабочийНаборДанных.Имя;
	Связь.ВыражениеИсточник   = Поле;
	Связь.ВыражениеПриемник   = ?(ПолеРабочегоНабора = Неопределено, Поле, ПолеРабочегоНабора);
	Связь.Обязательная        = Истина;
	
КонецПроцедуры

// Параметры:
// 	НаборДанных - НаборДанныхОбъектСхемыКомпоновкиДанных - Набор данных
// 	ИмяПоля - Строка - Имя поля
// 	ТипЗначения - Строка - Тип значения
// 
Процедура ДобавитьПолеНабораДанныхСКД(НаборДанных, ИмяПоля, ТипЗначения)
	
	ПолеНабораДанных             = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
	ПолеНабораДанных.Поле        = ИмяПоля;
	ПолеНабораДанных.ПутьКДанным = ИмяПоля;
	ПолеНабораДанных.ТипЗначения = Новый ОписаниеТипов(ТипЗначения);
	
КонецПроцедуры
#КонецОбласти

#КонецЕсли