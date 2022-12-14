#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает схему компоновки данных для настройки соответствия оборотов
//
// Параметры:
// 	СчетРеглУчетаДт - ПланСчетовСсылка.Хозрасчетный - СчетДт оборота регл. учета
// 	СчетРеглУчетаКт - ПланСчетовСсылка.Хозрасчетный - СчетКт оборота регл. учета.
//
// Возвращаемое значение:
// 	СхемаКомпоновкиДанных - СхемаКомпоновкиДанных - Схема, применяемая для настройки соответствия оборотов.
//
Функция СхемыКомпоновкиДанных(СчетРеглУчетаДт, СчетРеглУчетаКт) Экспорт
	
	СхемаКомпоновкиДанных = Справочники.СоответствияОборотовМеждународногоУчета.ПолучитьМакет("СхемаКомпоновкиДанных");
	ПоляНабора = СхемаКомпоновкиДанных.НаборыДанных[0].Поля;
	
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(СчетРеглУчетаДт);
	МассивСчетов.Добавить(СчетРеглУчетаКт);
	РеквизитыСчетов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивСчетов, "Код, Наименование");
	
	Счета = Новый Структура;
	Счета.Вставить("Дт", СчетРеглУчетаДт);
	Счета.Вставить("Кт", СчетРеглУчетаКт);
	Для каждого Счет Из Счета Цикл
		
		Если Не ЗначениеЗаполнено(Счет.Значение) Тогда
			Продолжить;
		КонецЕсли;
		
		ПоложениеСчета = Счет.Ключ;
		ПолеГруппа = ПоляНабора.Найти("Счет" + ПоложениеСчета);
		РеквизитыСчета = РеквизитыСчетов[Счет.Значение];
		ПолеГруппа.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								"%1, %2", РеквизитыСчета.Код, РеквизитыСчета.Наименование);
		
		ВидыСубконто = ФинансоваяОтчетностьПовтИсп.ВидыСубконтоСчета(Счет.Значение);
		Для НомерСубконто = 1 По 3 Цикл
			ПутьКДанным = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							"Счет%1.Субконто%1%2", ПоложениеСчета, НомерСубконто);
			Поле = ПоляНабора.Найти(ПутьКДанным);
			СтрокаВидСубконто = ВидыСубконто.Найти(НомерСубконто, "НомерСубконто");
			Если СтрокаВидСубконто <> Неопределено Тогда
				Поле.Заголовок = Строка(СтрокаВидСубконто.ВидСубконто);
				Поле.ТипЗначения = СтрокаВидСубконто.ТипЗначения;
			Иначе
				Поле.ОграничениеИспользования.Условие = Истина;
				Поле.ОграничениеИспользованияРеквизитов.Условие = Истина;
				Поле.ОграничениеИспользования.Поле = Истина;
				Поле.ОграничениеИспользованияРеквизитов.Поле = Истина;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат СхемаКомпоновкиДанных;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Справочники.СоответствияОборотовМеждународногоУчета.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.6.14";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("a138b320-e776-43e7-bb46-39ebc7e222ba");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.СоответствияОборотовМеждународногоУчета.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Конвертирует выражения заполнения субконто в новый формат.
	|Заполняет реквизит ПланСчетов.';
	|en = 'Converts extra dimension population expressions to a new format.
	|Populates the ПланСчетов attribute.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Справочники.ВидыКонтактнойИнформации.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Справочники.ПланыСчетовМеждународногоУчета.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Справочники.СоответствияОборотовМеждународногоУчета.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Справочники.СоответствияОборотовМеждународногоУчета.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Справочники.СоответствияОборотовМеждународногоУчета.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "МультиязычностьСервер.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "ОбновлениеИнформационнойБазыУТ.ОбработатьВидыКонтактнойИнформацииУТ";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Справочники.ВидыКонтактнойИнформации.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Справочники.ВидыНоменклатуры.ОбработатьДополнительныеРеквизитыНоменклатурыДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "Любой";

КонецПроцедуры

#Область Обработчики_2_5_5

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = "Справочник.СоответствияОборотовМеждународногоУчета";
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Ссылка");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоответствияОборотовМеждународногоУчета.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СоответствияОборотовМеждународногоУчета КАК СоответствияОборотовМеждународногоУчета
	|ГДЕ
	|	НЕ СоответствияОборотовМеждународногоУчета.ЭтоГруппа
	|	И (НЕ СоответствияОборотовМеждународногоУчета.УдалитьПереходНаНовыеФормулыВыполнен
	|		ИЛИ СоответствияОборотовМеждународногоУчета.ПланСчетов = ЗНАЧЕНИЕ(Справочник.ПланыСчетовМеждународногоУчета.ПустаяСсылка))";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.СоответствияОборотовМеждународногоУчета";
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	ПланСчетовПоУмолчанию = Справочники.ПланыСчетовМеждународногоУчета.ПланСчетовПоУмолчанию();
	
	Для Каждого ЭлементСправочника Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ЭлементСправочника.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			СправочникОбъект = ЭлементСправочника.Ссылка.ПолучитьОбъект();
			
			Если СправочникОбъект = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ЭлементСправочника.Ссылка);
			Иначе
				
				ОбъектИзменен = Ложь;
			
				ОбработатьИзменениеВыраженийЗаполненияСубконто(СправочникОбъект, ОбъектИзменен);
				
				Если СправочникОбъект.ЭтоГруппа И Не ЗначениеЗаполнено(СправочникОбъект.ПланСчетов) Тогда
					СправочникОбъект.ПланСчетов = ПланСчетовПоУмолчанию;
				КонецЕсли;
				
				Если СправочникОбъект.Модифицированность() Или ОбъектИзменен Тогда
					ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
				Иначе
					ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ЭлементСправочника.Ссылка);
				КонецЕсли;
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), ЭлементСправочника.Ссылка);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры


// Выполняет обработку изменений выражений заполнения аналитик (перевод формул на новый формат).
// 
// Параметры:
// 	СправочникОбъект - СправочникОбъект.СоответствияОборотовМеждународногоУчета - Обрабатываемый объект.
// 	ОбъектИзменен - Булево - Флаг изменения объекта.
//
Процедура ОбработатьИзменениеВыраженийЗаполненияСубконто(СправочникОбъект, ОбъектИзменен)
	
	Если НЕ СправочникОбъект.ЭтоГруппа
		И НЕ СправочникОбъект.УдалитьПереходНаНовыеФормулыВыполнен Тогда
		ВыраженияДляОбработки = Новый Соответствие;
		ИсходныеВыражения = Новый Массив;
		Для Каждого СтрокаТЧ Из СправочникОбъект.НастройкиЗаполненияСубконто Цикл
			Если ЗначениеЗаполнено(СтрокаТЧ.Выражение)
				И НЕ ЗначениеЗаполнено(СтрокаТЧ.ВыражениеИсторияПереходаНаНовыеФормулы) Тогда
				ИндексСтроки = СправочникОбъект.НастройкиЗаполненияСубконто.Индекс(СтрокаТЧ);
				ВыраженияДляОбработки.Вставить(ИндексСтроки, СтрокаТЧ.Выражение);
				Если ИсходныеВыражения.Найти(СтрокаТЧ.Выражение) = Неопределено Тогда
					ИсходныеВыражения.Добавить(СтрокаТЧ.Выражение);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ ВыраженияДляОбработки.Количество() = 0 Тогда
			
			СхемаПолученияДанных = СхемыКомпоновкиДанных(СправочникОбъект.СчетРеглУчетаДт, СправочникОбъект.СчетРеглУчетаКт);
			
			
			РезультатПреобразований = РаботаСФормулами.ПреобразоватьВФорматИдентификаторовОперандыФормулыСКД(ИсходныеВыражения,
				СхемаПолученияДанных);
				
			Если РезультатПреобразований.ЕстьОшибки Тогда
				ТекстОшибок = "";
				Для Каждого КлючИЗначение Из РезультатПреобразований.СообщенияОшибокПреобразования Цикл
					ТекстОшибок = ТекстОшибок + ?(ТекстОшибок = "", "", " / " + Символы.ПС) + КлючИЗначение.Значение;
				КонецЦикла;
				СправочникОбъект.УдалитьЕстьОшибкиПереходаНаНовыйФорматФормул = Истина;
				ИмяСобытияОшибкиЖР = НСтр("ru = 'Перевод формул и выражение в новый формат';
											|en = 'Conversion of formulas and expression to a new format'");
				ЗаписьЖурналаРегистрации(ИмяСобытияОшибкиЖР,
					УровеньЖурналаРегистрации.Ошибка,
					СправочникОбъект.Метаданные(),
					СправочникОбъект.Ссылка,
					ТекстОшибок);
				// Переход на новый формат формул не гарантируется, т.к. выражения могут содержать ошибки.
				// Отказа от транзакции не происходит.
			КонецЕсли;
			
			ПреобразованныеВыражения = РезультатПреобразований.ПреобразованныеВыражения;
			Для каждого ИндексСтрокиИВыражение Из ВыраженияДляОбработки Цикл
				ИндексСтроки = ИндексСтрокиИВыражение.Ключ;
				СтрокаТЧ = СправочникОбъект.НастройкиЗаполненияСубконто[ИндексСтроки];
				
				ИсходноеВыражение = ИндексСтрокиИВыражение.Значение;
				ВыражениеЗамены = ПреобразованныеВыражения.Получить(ИсходноеВыражение);
				Если ЗначениеЗаполнено(ВыражениеЗамены) Тогда
					СтрокаТЧ.Выражение = ВыражениеЗамены;
				КонецЕсли;
				СтрокаТЧ.ВыражениеИсторияПереходаНаНовыеФормулы = ИсходноеВыражение;
			КонецЦикла;
			
		КонецЕсли;
		
		СправочникОбъект.УдалитьПереходНаНовыеФормулыВыполнен = Истина;
		ОбъектИзменен = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
