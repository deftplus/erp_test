#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает реквизиты объекта, которые необходимо блокировать от изменения
//
// Возвращаемое значение:
//  Массив - блокируемые реквизиты объекта.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("ТипПодключаемогоОборудования");
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Коды товаров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "КодыТоваров";
	КомандаПечати.Представление = НСтр("ru = 'Коды товаров';
										|en = 'Goods codes'");

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КодыТоваров") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"КодыТоваров",
			НСтр("ru = 'Коды товаров';
				|en = 'Goods codes'"),
			СформироватьПечатнуюФормуКодыТоваров(МассивОбъектов, ОбъектыПечати, ПараметрыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуКодыТоваров(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КодыТоваров";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.ПравилаОбменаСПодключаемымОборудованиемOffline.ПФ_MXL_КодыТоваров");
	ПервыйДокумент = Истина;
	
	Для Каждого ОбъектМассива Из МассивОбъектов Цикл
		
		Если ТипЗнч(ОбъектМассива) = Тип("Структура") Тогда
			Объект = ОбъектМассива.ПравилоОбмена;
		Иначе
			Объект = ОбъектМассива;
		КонецЕсли;
		
		ПодключаемоеОборудованиеOfflineВызовСервера.ОбновитьКодыТоваров(Объект);
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = НСтр("ru = 'Коды товаров';
														|en = 'Goods codes'");
		ОбластьМакета.Параметры.ПравилоОбмена  = Объект;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьКод   = Макет.ПолучитьОбласть("ШапкаТаблицы|Код");
		ОбластьТовар = Макет.ПолучитьОбласть("ШапкаТаблицы|Товар");
		ТабличныйДокумент.Вывести(ОбластьКод);
		ТабличныйДокумент.Присоединить(ОбластьТовар);
		
		ОбластьКод   = Макет.ПолучитьОбласть("Строка|Код");
		ОбластьТовар = Макет.ПолучитьОбласть("Строка|Товар");
		
		Товары = ПодключаемоеОборудованиеOfflineВызовСервера.ДанныеТоваровПоПравилуОбмена(Объект, Справочники.ВидыЦен.ПустаяСсылка(), Справочники.ВидыЦен.ПустаяСсылка());
		МаксимальныйКодВесовогоТовара = ПодключаемоеОборудованиеOfflineВызовСервера.МаксимальныйКодВесовогоТовара();
		
		Для Каждого СтрокаТЧ Из Товары Цикл
			
			Если ОбъектМассива.ТипПодключаемогоОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток Тогда
				ОбластьКод.Параметры.Код = СтрокаТЧ.Код - МаксимальныйКодВесовогоТовара;
			Иначе
				ОбластьКод.Параметры.Код = СтрокаТЧ.Код;
			КонецЕсли;
			ТабличныйДокумент.Вывести(ОбластьКод);
			
			Если СтрокаТЧ.Используется Тогда
				ОбластьТовар.Параметры.Товар = СтрокаТЧ.Наименование;
			Иначе
				ОбластьТовар.Параметры.Товар = "";
			КонецЕсли;
			ТабличныйДокумент.Присоединить(ОбластьТовар);
			
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Вывести подписи.
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Ответственный = Пользователи.ТекущийПользователь();
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Объект);
	
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти


#КонецОбласти

#КонецЕсли