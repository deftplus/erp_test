#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура проверки заполнения табличных частей правил планирования
//
// Параметры:
// 		Объект - СправочникОбъект.КлассыОбъектовЭксплуатации, СправочникОбъект.ПодклассыОбъектовЭксплуатации - Объект справочника, табличные части которого необходимо проверить
// 		МассивНеПроверяемыхРеквизитов - Массив - Массив имен реквизитов, которые необходимо удалить из проверяемых
// 		Отказ - Булево - Признак ошибки.
//
Процедура ПроверкаЗаполненияПравилПланирования(Объект, МассивНеПроверяемыхРеквизитов, Отказ = Ложь) Экспорт
	
	МассивНеПроверяемыхРеквизитов.Добавить("РемонтныйЦикл.ИнтервалВремени");
	МассивНеПроверяемыхРеквизитов.Добавить("РемонтныйЦикл.ИнтервалВремениПланирования");
	МассивНеПроверяемыхРеквизитов.Добавить("РемонтныйЦикл.ЕдиницаВремени");
	МассивНеПроверяемыхРеквизитов.Добавить("РемонтныйЦикл.ИнтервалНаработки");
	МассивНеПроверяемыхРеквизитов.Добавить("РемонтныйЦикл.ИнтервалНаработкиПланирования");
	МассивНеПроверяемыхРеквизитов.Добавить("РемонтныйЦикл.ПоказательНаработки");
	МассивНеПроверяемыхРеквизитов.Добавить("ПрочиеРемонты.ИнтервалВремени");
	МассивНеПроверяемыхРеквизитов.Добавить("ПрочиеРемонты.ИнтервалВремениПланирования");
	МассивНеПроверяемыхРеквизитов.Добавить("ПрочиеРемонты.ЕдиницаВремени");
	МассивНеПроверяемыхРеквизитов.Добавить("ПрочиеРемонты.ИнтервалНаработки");
	МассивНеПроверяемыхРеквизитов.Добавить("ПрочиеРемонты.ИнтервалНаработкиПланирования");
	МассивНеПроверяемыхРеквизитов.Добавить("ПрочиеРемонты.ПоказательНаработки");
	
	СоответствиеВидовРемонтов = Новый Соответствие;
	
	Для Каждого Строка Из Объект.РемонтныйЦикл Цикл
		
		АдресОшибки = НСтр("ru = 'в строке %НомерСтроки% списка ""Ремонтный цикл""';
							|en = 'in line %НомерСтроки% of the ""R&M cycle"" list'");
		АдресОшибки = СтрЗаменить(АдресОшибки, "%НомерСтроки%", Строка.НомерСтроки);
		
		НомерСтроки = Строка.НомерСтроки;
		
		Если СоответствиеВидовРемонтов.Получить(Строка.ВидРемонта) <> Неопределено Тогда
			// Вид ремонта уже присутствует в табличной части в другой строке
			
			ТекстОшибки = НСтр("ru = 'Вид ремонта ""%ВидРемонта%"" %АдресОшибки% уже присутствует в строке %НомерПредыдущейСтроки%';
								|en = 'Line %НомерПредыдущейСтроки% already contains the ""%ВидРемонта%"" R&M type %АдресОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%АдресОшибки%", АдресОшибки);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ВидРемонта%", Строка.ВидРемонта);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерПредыдущейСтроки%", Формат(СоответствиеВидовРемонтов.Получить(Строка.ВидРемонта), "ЧГ=0"));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				Объект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("РемонтныйЦикл", Строка.НомерСтроки, "ВидРемонта"),,
				Отказ);
		Иначе
			СоответствиеВидовРемонтов.Вставить(Строка.ВидРемонта, НомерСтроки);
		КонецЕсли;
		
		Если Объект.РемонтныйЦиклПоНаработке Тогда
			
			Если Не ЗначениеЗаполнено(Строка.ИнтервалНаработки) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрЗаменить(НСтр("ru = 'Не заполнена колонка ""Межремонтный интервал"" %АдресОшибки%';
									|en = 'The ""R&M interval"" column is required %АдресОшибки%'"), "%АдресОшибки%", АдресОшибки),
					Объект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("РемонтныйЦикл", Строка.НомерСтроки, "ИнтервалНаработки"),
					,
					Отказ);
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Строка.ПоказательНаработки) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрЗаменить(НСтр("ru = 'Не заполнена колонка ""Единица измерения"" %АдресОшибки%';
									|en = 'The ""Unit of measure"" column is required %АдресОшибки%'"), "%АдресОшибки%", АдресОшибки),
					Объект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("РемонтныйЦикл", Строка.НомерСтроки, "ПоказательНаработки"),
					,
					Отказ);
			КонецЕсли;
			
		Иначе
			
			Если Не ЗначениеЗаполнено(Строка.ИнтервалВремени) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрЗаменить(НСтр("ru = 'Не заполнена колонка ""Межремонтный интервал"" %АдресОшибки%';
									|en = 'The ""R&M interval"" column is required %АдресОшибки%'"), "%АдресОшибки%", АдресОшибки),
					Объект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("РемонтныйЦикл", Строка.НомерСтроки, "ИнтервалВремени"),
					,
					Отказ);
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Строка.ЕдиницаВремени) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрЗаменить(НСтр("ru = 'Не заполнена колонка ""Единица измерения"" %АдресОшибки%';
									|en = 'The ""Unit of measure"" column is required %АдресОшибки%'"), "%АдресОшибки%", АдресОшибки),
					Объект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("РемонтныйЦикл", Строка.НомерСтроки, "ЕдиницаВремени"),
					,
					Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	СоответствиеВидовРемонтов.Очистить();
	
	Для Каждого Строка Из Объект.ПрочиеРемонты Цикл
		
		АдресОшибки = НСтр("ru = 'в строке %НомерСтроки% списка ""Прочие ремонты""';
							|en = 'in line %НомерСтроки% of the ""Other R&M"" list'");
		АдресОшибки = СтрЗаменить(АдресОшибки, "%НомерСтроки%", Строка.НомерСтроки);
		
		Если СоответствиеВидовРемонтов.Получить(Строка.ВидРемонта) <> Неопределено Тогда
			// Вид ремонта уже присутствует в табличной части в другой строке
			
			ТекстОшибки = НСтр("ru = 'Вид ремонта ""%ВидРемонта%"" %АдресОшибки% уже присутствует в строке %НомерПредыдущейСтроки%';
								|en = 'Line %НомерПредыдущейСтроки% already contains the ""%ВидРемонта%"" R&M type %АдресОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%АдресОшибки%", АдресОшибки);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ВидРемонта%", Строка.ВидРемонта);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерПредыдущейСтроки%", Формат(СоответствиеВидовРемонтов.Получить(Строка.ВидРемонта), "ЧГ=0"));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				Объект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("РемонтныйЦикл", Строка.НомерСтроки, "ВидРемонта"),,
				Отказ);
		Иначе
			СоответствиеВидовРемонтов.Вставить(Строка.ВидРемонта, НомерСтроки);
		КонецЕсли;
		
		Если Строка.ПоНаработке Тогда
			
			Если Не ЗначениеЗаполнено(Строка.ИнтервалНаработки) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрЗаменить(НСтр("ru = 'Не заполнена колонка ""Межремонтный интервал"" %АдресОшибки%';
									|en = 'The ""R&M interval"" column is required %АдресОшибки%'"), "%АдресОшибки%", АдресОшибки),
					Объект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПрочиеРемонты", Строка.НомерСтроки, "ИнтервалНаработки"),
					,
					Отказ);
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Строка.ПоказательНаработки) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрЗаменить(НСтр("ru = 'Не заполнена колонка ""Единица измерения"" %АдресОшибки%';
									|en = 'The ""Unit of measure"" column is required %АдресОшибки%'"), "%АдресОшибки%", АдресОшибки),
					Объект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПрочиеРемонты", Строка.НомерСтроки, "ПоказательНаработки"),
					,
					Отказ);
			КонецЕсли;
			
		Иначе
			
			Если Не ЗначениеЗаполнено(Строка.ИнтервалВремени) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрЗаменить(НСтр("ru = 'Не заполнена колонка ""Межремонтный интервал"" %АдресОшибки%';
									|en = 'The ""R&M interval"" column is required %АдресОшибки%'"), "%АдресОшибки%", АдресОшибки),
					Объект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПрочиеРемонты", Строка.НомерСтроки, "ИнтервалВремени"),
					,
					Отказ);
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Строка.ЕдиницаВремени) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрЗаменить(НСтр("ru = 'Не заполнена колонка ""Единица измерения"" %АдресОшибки%';
									|en = 'The ""Unit of measure"" column is required %АдресОшибки%'"), "%АдресОшибки%", АдресОшибки),
					Объект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПрочиеРемонты", Строка.НомерСтроки, "ЕдиницаВремени"),
					,
					Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает наборы свойств по классу объектов эксплуатации
//
// Параметры:
// 		Класс - СправочникСсылка.КлассыОбъектовЭксплуатации - Ссылка на класс.
//
// Возвращаемое значение:
// 		Структура - Структура наборов свойств.
//
Функция ПолучитьНаборыСвойств(Класс) Экспорт
	
	СтруктураНаборов = Новый Структура(
		"ПаспортныеХарактеристики",
		Неопределено);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Классы.НаборСвойств КАК ПаспортныеХарактеристики
		|ИЗ
		|	Справочник.КлассыОбъектовЭксплуатации КАК Классы
		|ГДЕ
		|	Классы.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Класс);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат СтруктураНаборов;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтруктураНаборов, Выборка);
	КонецЕсли;
	
	Возврат СтруктураНаборов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Справочники.КлассыОбъектовЭксплуатации.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.7.1";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("69294a7e-338d-40b2-ba32-f40e8454bdb6");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.КлассыОбъектовЭксплуатации.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновляет справочник ""Классы объектов эксплуатации"":
	|- заполняет новый реквизит ""Способ регистрации""';
	|en = 'Updates the ""Maintenance schemes"" catalog:
	|- populates a new ""Registration method"" attribute'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Справочники.КлассыОбъектовЭксплуатации.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Справочники.КлассыОбъектовЭксплуатации.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Справочники.КлассыОбъектовЭксплуатации.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");

КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = "Справочник.КлассыОбъектовЭксплуатации";
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Ссылка");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассыОбъектовЭксплуатации.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КлассыОбъектовЭксплуатации.ПоказателиНаработки КАК КлассыОбъектовЭксплуатации
	|ГДЕ
	|	КлассыОбъектовЭксплуатации.СпособРегистрации = ЗНАЧЕНИЕ(Перечисление.СпособыРегистрацииНаработки.ПустаяСсылка)";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.КлассыОбъектовЭксплуатации";
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;

	Для Каждого Выборка Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект(); // СправочникОбъект.КлассыОбъектовЭксплуатации - 
			
			Для Каждого ДанныеСтроки Из СправочникОбъект.ПоказателиНаработки Цикл
				Если НЕ ЗначениеЗаполнено(ДанныеСтроки.СпособРегистрации) Тогда
					ДанныеСтроки.СпособРегистрации =
						?(ДанныеСтроки.РегистрироватьОтИсточника,
							Перечисления.СпособыРегистрацииНаработки.ОтОбъектаЭксплуатации,
							Перечисления.СпособыРегистрацииНаработки.Независимо);
				КонецЕсли;
			КонецЦикла;
			
			Если СправочникОбъект.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(СправочникОбъект);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			КонецЕсли;
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;

			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Выборка.Ссылка);
			
		КонецПопытки;
		
	КонецЦикла;
	
 	ВнеоборотныеАктивыСлужебный.ПроверитьВыполнениеОбработчика(
 		ПроблемныхОбъектов, 
 		ОбъектовОбработано, 
 		ПолноеИмяОбъекта);
 		
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры
 
#КонецОбласти

#КонецОбласти

#КонецЕсли
