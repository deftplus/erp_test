////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

Функция ПолучитьФормуВыбораБанковскогоСчетаОрганизации(Параметры, Владелец) Экспорт
	Возврат ПолучитьФорму("Справочник.БанковскиеСчетаОрганизаций.ФормаВыбора", Параметры, Владелец);
КонецФункции

Процедура ПриИзмененииСтатьиДвиженияДенежныхСредств(Форма, Элемент, ПостфиксАналитик = "") Экспорт
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	ЭтоТаблица = ТипЗнч(Форма.ТекущийЭлемент) = Тип("ТаблицаФормы");
	ПоляФормы = Новый Массив;
	
	Если ЭтоТаблица Тогда
		ДанныеРасшифровки = Форма.ТекущийЭлемент.ТекущиеДанные;
		ИсточникТипов = ДанныеРасшифровки;
		ШаблонПоляЭлемента = Форма.ТекущийЭлемент.Имя + "АналитикаБДДС%1";
	Иначе
		ДанныеРасшифровки = Форма.Элементы.РасшифровкаПлатежа.ТекущиеДанные;
		ИсточникТипов = ДанныеРасшифровки;
		ШаблонПоляЭлемента = "АналитикаБДДС%1"+ ПостфиксАналитик;
	КонецЕсли;
	
	Если ДанныеРасшифровки <> Неопределено Тогда
		ОперативноеПланированиеФормыУХКлиентСервер.ЗаполнитьСведенияОВидахАналитик(ДанныеРасшифровки.СтатьяДвиженияДенежныхСредств, ИсточникТипов);
		
		Для Индекс = 1 По 3 Цикл
			ПоляФормы.Добавить(Элементы[СтрШаблон(ШаблонПоляЭлемента, Индекс)]);
		КонецЦикла;
		
		ОперативноеПланированиеФормыУХКлиентСервер.ПривестиЗначениеТиповАналитик(ДанныеРасшифровки, ИсточникТипов);	
		ОперативноеПланированиеФормыУХКлиентСервер.УправлениеЭлементамиДополнительныхАналитик(ИсточникТипов, ПоляФормы);
		ОперативноеПланированиеФормыУХКлиентСервер.ИзменитьПараметрыВыбораАналитик(ДанныеРасшифровки, ИсточникТипов, ПоляФормы);	
	Иначе
		// Пустая таблица. Данных нет. Пропускаем.
	КонецЕсли;

КонецПроцедуры		// ПриИзмененииСтатьиДвиженияДенежныхСредств()

// Возвращает данные аналитик, когда они заданы без разбиения в форме ФормаВход.
Функция ПолучитьДанныеРасшифровкиБезСписка(ФормаВход) Экспорт
	РезультатФункции = Неопределено;
	Если ФормаВход.Объект.РасшифровкаПлатежа.Количество() > 0 Тогда
		РезультатФункции = ФормаВход.Объект.РасшифровкаПлатежа[0];
	Иначе
		РезультатФункции = Неопределено;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции		// ПолучитьДанныеРасшифровкиБезСписка()

Процедура ОткрытьФормуГенерацииПлатежныхПоручений(Параметры, Владелец) Экспорт
	
	ОткрытьФорму("Обработка.ГенерацияПлатежныхПоручений.Форма", Параметры, Владелец);
	
КонецПроцедуры

Процедура ОбработкаВыбораДокументаПланирования(Форма, Элемент, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт 
	
	// сначала выбор типа
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Тип") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Объект = Форма.Объект;
	
	Если ТипЗнч(Форма.ТекущийЭлемент) = Тип("ТаблицаФормы") Тогда
		ДанныеРасшифровки = Форма.ТекущийЭлемент.ТекущиеДанные;		
	ИначеЕсли Форма.ТекущийЭлемент.Имя = "РасшифровкаБезРазбиенияДокументПланирования" Тогда
		ДанныеРасшифровки = Форма.Элементы.РасшифровкаПлатежа.ТекущиеДанные;
	Иначе
		ДанныеРасшифровки = Объект;
	КонецЕсли;
	
	// выбрана позиция заявки
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтрокаДанныхЗаполнения = "ДокументПланирования, ИдентификаторПозиции";
		ЗаполнитьЗначенияСвойств(ДанныеРасшифровки, ВыбранноеЗначение, СтрокаДанныхЗаполнения);
	Иначе
		ДанныеРасшифровки.ДокументПланирования = ВыбранноеЗначение;
	КонецЕсли;	
	
	Реквизиты = ОперативноеПланированиеФормыУХВызовСервера.ЦФОПроектПоДокументуПланирования(ДанныеРасшифровки.ДокументПланирования);
	ЗаполнитьЗначенияСвойств(ДанныеРасшифровки, Реквизиты);
	
КонецПроцедуры

// Процедура отображает список созданных платежных поручений
Процедура ОткрытьСписокСозданныхПлатежныхПоручений(Форма, Отбор, СписокСозданныхДокументов) Экспорт
	
	Если СписокСозданныхДокументов.Ссылка.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("Отбор",           Отбор);
	ПараметрыФормы.Вставить("ТекущаяСтрока",   СписокСозданныхДокументов.Ссылка[0].Значение);
	ПараметрыФормы.Вставить("СписокВыделения", СписокСозданныхДокументов);
	
	ОткрытьФорму("Обработка.ЖурналДокументовБезналичныеПлатежи.Форма.ФормаСписка", ПараметрыФормы, Форма, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьПослеВыбораБанковскогоСчетаКассы(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ИмяФормы = "Документ." + ДополнительныеПараметры.ИмяДокумента + ".ФормаОбъекта";
		ДополнительныеПараметры.Вставить("БанковскийСчетКасса", Результат.БанковскийСчетКасса);
		ДополнительныеПараметры.Вставить("Сумма", 				Результат.Сумма);
		ДополнительныеПараметры.Вставить("ИдентификаторПозиции",Результат.ИдентификаторПозиции);
		ОткрытьФорму(ИмяФормы, Новый Структура("Основание", ДополнительныеПараметры));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВводНаОсновании

// Создает документ ОФД по одной или нескольким заявкам на расход денежных средств.
//
// Параметры:
//	ОписаниеКоманды - Структура - Описание команды, по которой создаются документы
//	ИмяДокумента - Строка - имя документа в метаданных, который будет создан на основании заявок.
//
Процедура СоздатьДокументОФДНаОснованииЗаявокНаРасходДС(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	ОчиститьСообщения();
	
	//РаспределениеОплаты = Неопределено;
	//Если ДенежныеСредстваВызовСервера.СформироватьДанныеЗаполненияОплаты(МассивСсылок, ФормаОплаты, РаспределениеОплаты) Тогда
	//	
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИсходныйДокумент",                     МассивСсылок);
		//ДополнительныеПараметры.Вставить("НесколькоЗаявокНаРасходованиеСредств",  МассивСсылок.Количество() > 1);
		
	//	Оповещение = Новый ОписаниеОповещения("ВыполнитьПослеВыбораБанковскогоСчетаКассы", ЭтотОбъект, ДополнительныеПараметры);
	//	
	//	Если РаспределениеОплаты.Количество() > 1 Тогда
	//		ДополнительныеПараметры.Вставить("ЗакрыватьПриВыборе", Истина);
	//		ОткрытьФорму("Документ.ЗаявкаНаРасходованиеДенежныхСредств.Форма.РаспределениеОплаты", ДополнительныеПараметры,,,,,
	//			Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	//	ИначеЕсли РаспределениеОплаты.Количество() = 1 Тогда
	//		ВыполнитьОбработкуОповещения(Оповещение,
	//			Новый Структура("БанковскийСчетКасса, Сумма", РаспределениеОплаты[0].БанковскийСчетКасса, РаспределениеОплаты[0].Сумма));
	//	Иначе
	//		ВыполнитьОбработкуОповещения(Оповещение, Новый Структура("БанковскийСчетКасса, Сумма", Неопределено, 0));
	//	КонецЕсли;
	//КонецЕсли;
	
	ИмяФормы = "Документ.ОтражениеФактическихДанныхБюджетирования.ФормаОбъекта";
	//ДополнительныеПараметры.Вставить("БанковскийСчетКасса", Результат.БанковскийСчетКасса);
	//ДополнительныеПараметры.Вставить("Сумма", Результат.Сумма);
	ОткрытьФорму(ИмяФормы, Новый Структура("Основание", ДополнительныеПараметры));
	
КонецПроцедуры
	
// Создает документ начисления МСФО  по одной или нескольким заявкам на расход денежных средств.
//
// Параметры:
//	ОписаниеКоманды - Структура - Описание команды, по которой создаются документы
//	ИмяДокумента - Строка - имя документа в метаданных, который будет создан на основании заявок.
//
Процедура СоздатьДокументНачислениеОперацийМСФОНаОснованииЗаявокНаРасходДС(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	ОчиститьСообщения();
	
	ИмяФормы = "Документ.НачислениеОперацийМСФО.ФормаОбъекта";
	ОткрытьФорму(ИмяФормы, Новый Структура("Основание", МассивСсылок));
	
КонецПроцедуры

#КонецОбласти
