////////////////////////////////////////////////////////////////////////////////
// Модуль предназначен для реализации фукнциональности механизма шаблонов 
// заполнения контексте вызова сервера.
////////////////////////////////////////////////////////////////////////////////

// Серверная обертка функции СтруктураДанныхОбъектаШаблонаПоСсылке модуля УправлениеШаблонамиЗаполненияУХ.
Функция ПолучитьСтруктуруДанныхОбъектаШаблона(ОбъектШаблонаВход) Экспорт
	РезультатФункции = УправлениеШаблонамиЗаполненияУХ.СтруктураДанныхОбъектаШаблонаПоСсылке(ОбъектШаблонаВход);
	Возврат РезультатФункции;
КонецФункции

// Серверная обертка функции ПолучитьИмяОсновнойФормы модуля УправлениеШаблонамиЗаполненияУХ.
Функция ПолучитьИмяОсновнойФормы(ЭталонныйЭлементВход) Экспорт
	РезультатФункции = УправлениеШаблонамиЗаполненияУХ.ПолучитьИмяОсновнойФормы(ЭталонныйЭлементВход);
	Возврат РезультатФункции;
КонецФункции

// Создаёт новый шаблон заполнения по объекту ОбъектРодительВход с реквизитами
// СписокРеквизитовВход и табличными частями СписокТабличныхЧастейВход.
Функция СоздатьШаблон(ОбъектРодительВход, СписокРеквизитовВход, СписокТабличныхЧастейВход, НаименованиеШаблонаВход = "", АналитикаОтбораВход = Неопределено, ВариантЗаполненияВход = Неопределено) Экспорт
	РезультатФункции = Справочники.ШаблоныЗаполнения.ПустаяСсылка();
	НачатьТранзакцию();
	ЕстьОшибки = Ложь;
	Попытка 
		// Получение параметров.
		Если СокрЛП(НаименованиеШаблонаВход) = "" Тогда
			НаименованиеРабочее = Справочники.ШаблоныЗаполнения.ПолучитьНаименованиеШаблонаПоУмолчанию(ОбъектРодительВход);
		Иначе
			НаименованиеРабочее = НаименованиеШаблонаВход;
		КонецЕсли;
		// Создание элемента.
		НовыйШаблон = Справочники.ШаблоныЗаполнения.СоздатьЭлемент();
		НовыйШаблон.ЗаполнитьИзОбъекта(НаименованиеРабочее, ОбъектРодительВход, СписокРеквизитовВход, СписокТабличныхЧастейВход, АналитикаОтбораВход, ВариантЗаполненияВход);
		НовыйШаблон.Записать();
		РезультатФункции = НовыйШаблон.Ссылка;
	Исключение
		ТекстСообщения = НСтр("ru = 'Не удалось создать шаблон по объекту %ОбъектРодитель%: %ОписаниеОшибки%'");
		ЕстьОшибки = Истина;
	КонецПопытки;
	Если ЕстьОшибки Тогда
		ОтменитьТранзакцию();
	Иначе
		ЗафиксироватьТранзакцию();
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

// По варианту заполнения шаблона ВариантЗаполненияВход возвращает структуру, 
// содержащую СписокРеквизитовДляПереноса и СписокТабличныхЧастейДляПереноса.
Функция ПолучитьСтруктуруРеквизитовВариантаЗаполненияШаблона(ВариантЗаполненияВход) Экспорт
	РезультатФункции = Новый Структура;
	РезультатФункции = Справочники.ВариантыЗаполненияШаблонов.ПолучитьСтруктуруРеквизитовВариантаЗаполненияШаблона(ВариантЗаполненияВход);
	Возврат РезультатФункции;
КонецФункции

// Возвращает структуру, в которой ключи - наименование ревизита для заполнения
// из шаблона, а значения - значения соответственных реквизитов.
Функция ПолучитьСтруктуруРеквизитовВШаблоне(ШаблонВход) Экспорт
	РезультатФункции = Новый Структура;
	Для Каждого ТекРеквизитыШаблона Из ШаблонВход.РеквизитыШаблона Цикл
		Если СокрЛП(ТекРеквизитыШаблона.ТабличнаяЧасть) = "" Тогда
			КлючСтруктуры = ТекРеквизитыШаблона.НаименованиеРеквизита;
			ЗначениеСтруктуры = ТекРеквизитыШаблона.ЗначениеРеквизита;
			РезультатФункции.Вставить(КлючСтруктуры, ЗначениеСтруктуры);
		Иначе
			// Не добавляем строки таб частей.
		КонецЕсли;
	КонецЦикла;
	Возврат РезультатФункции;
КонецФункции	

// Возвращает структуру с табличными частями и шаблона заполнения ШаблонВход,
// упакованные в виде массивов структур.
Функция ПолучитьСтруктуруТабличныхЧастейВШаблоне(ШаблонВход) Экспорт
	РезультатФункции = Новый Структура;
	// Заполним массив табличных частей.
	ТабРеквизиты = ШаблонВход.РеквизитыШаблона.Выгрузить();
	ТабРеквизиты.Сортировать("ТабличнаяЧасть Возр, НомерСтрокиТаблицы возр");
	СверткаТабЧасти = ТабРеквизиты.Скопировать();
	СверткаТабЧасти.Свернуть("ТабличнаяЧасть");
	Для Каждого ТекСверткаТабЧасти Из СверткаТабЧасти Цикл
		Если ТекСверткаТабЧасти.ТабличнаяЧасть <> "" Тогда
			РезультатФункции.Вставить(ТекСверткаТабЧасти.ТабличнаяЧасть, Новый Массив);
		Иначе
			// Реквизит объекта. Не добавляем.
		КонецЕсли;
	КонецЦикла;
	// Создадим результирующую структуру.
	ПоследнийНомерСтроки = -1;
	ТекТабЧасть = "";
	НоваяСтрока = Новый Структура;
	Для каждого ТекТабРеквизиты Из ТабРеквизиты Цикл
		Если ТекТабРеквизиты.ТабличнаяЧасть <> "" Тогда
			Попытка
				ТекНомерСтроки = ТекТабРеквизиты.НомерСтрокиТаблицы;
				Если (ТекНомерСтроки <> ПоследнийНомерСтроки) ИЛИ (ТекТабЧасть <> ТекТабРеквизиты.ТабличнаяЧасть) Тогда
					НоваяСтрока = Новый Структура;
					РезультатФункции[ТекТабРеквизиты.ТабличнаяЧасть].Добавить(НоваяСтрока);	
				Иначе
					//Пользуемся уже существующей строкой
				КонецЕсли;
				НоваяСтрока.Вставить(ТекТабРеквизиты.НаименованиеРеквизита, ТекТабРеквизиты.ЗначениеРеквизита);
				ПоследнийНомерСтроки = ТекНомерСтроки;
				ТекТабЧасть = ТекТабРеквизиты.ТабличнаяЧасть;
			Исключение
				ТекстСообщения = НСтр("ru = 'Не удалось считать значения табличной части %ТабличнаяЧасть%: %ОписаниеОшибки%'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки());
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТабличнаяЧасть%", Строка(ТекТабРеквизиты.ТабличнаяЧасть));
				ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	Возврат РезультатФункции;
КонецФункции

// Возвращает организацию для заключения договора закупочной процедуры,
// к которой привязан лот ЛотВход.
Функция ПолучитьОрганизациюЗакупочнойПроцедурыЛота(ЛотВход) Экспорт
	РезультатФункции = УправлениеШаблонамиЗаполненияУХ.ПолучитьОрганизациюЗакупочнойПроцедурыЛота(ЛотВход);
	Возврат РезультатФункции;
КонецФункции		// ПолучитьОрганизациюЗакупочнойПроцедурыЛота()
