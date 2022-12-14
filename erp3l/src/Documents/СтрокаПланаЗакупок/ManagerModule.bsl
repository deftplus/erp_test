#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	
#Область ОбщийПрограмныйИнтерфейс

	
// Создать строку по переданным значениям и записать ее.
//
// Параметры:
//  ЗначенияДляЗаполнения - Any - Объект реквизиты которого,
//		будут использованы для заполнения строки плана.
// 
// Возвращаемое значение:
//   - СправочникСсылка.СтрокаПланаЗакупок. Созданная строка
//		плана закупок.
//
Функция СоздатьСтроку(ЗначенияДляЗаполнения) Экспорт
	Перем СтрокаОбъект;
	СтрокаОбъект = Документы.СтрокаПланаЗакупок.СоздатьДокумент();
	СтрокаОбъект.Заполнить(ЗначенияДляЗаполнения);	
	СтрокаОбъект.Записать();
	Возврат СтрокаОбъект.Ссылка;
КонецФункции

// Определяет, что строка плана закупок должна проводиться
// в соотвествтии с ФЗ-223.
//
Функция ЭтоФЗ223(СтрокаПланаОбъект) Экспорт
	Возврат ЦентрализованныеЗакупкиВызовСервераУХ.ОрганизацияЗакупаетПоФЗ223(
			СтрокаПланаОбъект.ОрганизацияДляЗаключенияДоговора);
КонецФункции

// Возвращает ссылку на предыдущую версию строки плана закупок.
//
// Параметры:
//  Ссылка - ДокументСсылка.СтрокаПланаЗакупок - версия плана
//		для которой нужно получить предыдущую версию.
// 
// Возвращаемое значение:
//   ДокументСсылка.СтрокаПланаЗакупок - найденный документ.
//
Функция ПолучитьПредыдущуюВерсиюСтроки(Ссылка) Экспорт
	Если ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Ссылка.ДокументОснование;
	КонецЕсли;
	Возврат Документы.СтрокаПланаЗакупок.ПустаяСсылка();
КонецФункции

Функция ПолучитьВерсиюСтрокиПоНомеруГПЗ(
								ПериодЗакупок,
						        ОрганизацияДляЗаключенияДоговора,
								ИнновационныйПланЗакупок,
								НомерВГПЗ) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтрокиПланаЗакупокСрезПоследних.СтрокаПлана КАК СтрокаПлана
		|ИЗ
		|	РегистрСведений.СтрокиПланаЗакупок.СрезПоследних(
		|			,
		|			ИнновационныйПланЗакупок = &ИнновационныйПланЗакупок
		|				И НомерВГПЗ = &НомерВГПЗ
		|				И ОрганизацияДляЗаключенияДоговора = &ОрганизацияДляЗаключенияДоговора
		|				И ПериодЗакупок = &ПериодЗакупок) КАК СтрокиПланаЗакупокСрезПоследних";
	
	Запрос.УстановитьПараметр("ИнновационныйПланЗакупок", ИнновационныйПланЗакупок);
	Запрос.УстановитьПараметр("НомерВГПЗ", НомерВГПЗ);
	Запрос.УстановитьПараметр("ОрганизацияДляЗаключенияДоговора", ОрганизацияДляЗаключенияДоговора);
	Запрос.УстановитьПараметр("ПериодЗакупок", ПериодЗакупок);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	КонецЕсли;
	Возврат Документы.СтрокаПланаЗакупок.ПустаяСсылка();
КонецФункции
		 
Функция ПолучитьАктуальнуюВерсиюСтрокиПоИдентификатору(
							ИдентификаторСтрокиПланаЗакупок) Экспорт
	Если ЗначениеЗаполнено(ИдентификаторСтрокиПланаЗакупок) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	СтрокиПланаЗакупокСрезПоследних.СтрокаПлана КАК СтрокаПлана
			|ИЗ
			|	РегистрСведений.СтрокиПланаЗакупок.СрезПоследних(, ИдентификаторСтрокиПланаЗакупок = &ИдентификаторСтрокиПланаЗакупок) КАК СтрокиПланаЗакупокСрезПоследних";
		
		Запрос.УстановитьПараметр(
			"ИдентификаторСтрокиПланаЗакупок", 
			ИдентификаторСтрокиПланаЗакупок);
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			Возврат ВыборкаДетальныеЗаписи.СтрокаПлана;
		КонецЕсли;
	КонецЕсли;
	Возврат Документы.СтрокаПланаЗакупок.ПустаяСсылка();
КонецФункции

// Для контроля повторного ввода на основании.
//
Функция ПолучитьВведенныеНаОсновании(ОснованиеСсылка, ИсключитьСсылку) Экспорт
	Возврат
		ЦентрализованныеЗакупкиУХ.ПолучитьДокументыПоОтбору(
			"СтрокаПланаЗакупок",
			Новый Структура("ДокументОснование, Проведен",
							 ОснованиеСсылка, Истина),
			ИсключитьСсылку);
КонецФункции

// Проверяет, что для указанной строки плана нет более
// поздних версий.
//
// Параметры:
//  Ссылка - ДокументСсылка.СтрокаПланаЗакупок - строка для проверки.
// 
// Возвращаемое значение:
//   - Булево - Истина - строка является актуальной.
//				Ложь - строка не актуальна, есть более поздние.
//
Функция ЭтоАктуальнаяВерсия(Ссылка) Экспорт
	Если ЗначениеЗаполнено(Ссылка)
				И ЗначениеЗаполнено(Ссылка.ИдентификаторСтрокиПланаЗакупок) Тогда
		АктуальнаяВерсия = 
			ПолучитьАктуальнуюВерсиюСтрокиПоИдентификатору(
				Ссылка.ИдентификаторСтрокиПланаЗакупок);
		Возврат АктуальнаяВерсия = Ссылка;
	КонецЕсли;
	Возврат Истина;
КонецФункции

// Для переданного массива ссылок на строки плана закупок
// возвращает массив уникальных значений реквизита
// "ОрганизацияДляЗаключенияДоговора".
//
Функция ОрганизацииДляЗаключенияДоговора(мСтрокПланаЗакупок) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	СтрокаПланаЗакупок.ОрганизацияДляЗаключенияДоговора КАК ОрганизацияДляЗаключенияДоговора
		|ИЗ
		|	Документ.СтрокаПланаЗакупок КАК СтрокаПланаЗакупок
		|ГДЕ
		|	СтрокаПланаЗакупок.Ссылка В(&мСсылок)";
	Запрос.УстановитьПараметр("мСсылок", мСтрокПланаЗакупок);
	Возврат Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.Прямой);
КонецФункции

Функция ТребуетсяЗаполнитьОбязательныеРеквизитыОбоснованияНМЦ(
												ДокументСсылка,
												МассивНезаполненныхРеквизитов) Экспорт
	МассивНезаполненныхРеквизитов = Новый Массив;
	Реквизиты = ПолучитьРеквизитыТребуемыеДляОбоснованияНМЦ(ДокументСсылка);
	Если Реквизиты.ТребуетсяОбоснованиеНМЦ = Ложь Тогда
		Возврат Ложь;
	КонецЕсли;
	// ОценкаНМЦЗавершена
	Если Реквизиты.ОценкаНМЦЗавершена = Ложь Тогда
		МассивНезаполненныхРеквизитов.Добавить(НСтр(
			"ru='	Обоснование строки плана закупок не завершено, завершите обоснование'"));
	КонецЕсли;
	Возврат МассивНезаполненныхРеквизитов.Количество() > 0;
КонецФункции

// Возвращает ссылку на актуальную версию строки плана СтрокаПланаВход.
Функция ПолучитьАктуальнуюСтрокуПлана(СтрокаПланаВход) Экспорт
	РезультатФункции = СтрокаПланаВход;
	МассивРезультат = Новый Массив;
	ПолучитьАктуальнуюСтрокуРекурсивно(СтрокаПланаВход, МассивРезультат);
	Если МассивРезультат.Количество() > 0 Тогда
		РезультатФункции = МассивРезультат[0];
	Иначе
		РезультатФункции = СтрокаПланаВход;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции		 // ПолучитьАктуальнуюСтрокуПлана()

// Возвращает соответствие актуальных версий строк плана строкам из массива МассивСтрокПлана.
Функция ПолучитьСоответствиеАктуализацииВерсийСтрокПлана(МассивСтрокПлана) Экспорт
	РезультатФункции = Новый Соответствие;
	Для Каждого ТекМассивСтрокПлана Из МассивСтрокПлана Цикл
		АктуальнаяВерсия = ПолучитьАктуальнуюСтрокуПлана(ТекМассивСтрокПлана);
		РезультатФункции.Вставить(ТекМассивСтрокПлана, АктуальнаяВерсия);		
	КонецЦикла;
	Возврат РезультатФункции;
КонецФункции		 // ПолучитьСоответствиеАктуализацииВерсийСтрокПлана()

// Возвращает самую раннюю версию документа СтрокаПланаВход.
Функция ПолучитьПервуюВерсиюСтрокиПлана(СтрокаПланаВход, МассивСостояний = Неопределено) Экспорт
	РезультатФункции = СтрокаПланаВход;
	СтатусЧерновик = Перечисления.СтатусыВыгружаемыхОбъектовЕИС.Черновик;
	ТекДокумент = СтрокаПланаВход;
	ТекОснование = ТекДокумент.ДокументОснование;
	Пока ЗначениеЗаполнено(ТекОснование) Цикл
		Если ТипЗнч(ТекДокумент) = Тип("ДокументСсылка.СтрокаПланаЗакупок") Тогда
			ТекДокумент = ТекОснование;
			ТекОснование = ТекДокумент.ДокументОснование;
			Если ТипЗнч(МассивСостояний) = Тип("Массив") Тогда
				СтатусДокумента = УправлениеПроцессамиСогласованияУХ.ВернутьСтатусОбъекта(ТекДокумент, СтатусЧерновик);
				НайденноеСостояние = МассивСостояний.Найти(СтатусДокумента);
				Если НайденноеСостояние <> Неопределено Тогда
					РезультатФункции = ТекДокумент;
				Иначе
					// Пропускаем этот документ, т.к. не подходит по статусу.
				КонецЕсли;
			Иначе
				РезультатФункции = ТекДокумент;
			КонецЕсли;
		Иначе
			ТекОснование = Неопределено;
		КонецЕсли;
	КонецЦикла;
	Возврат РезультатФункции;
КонецФункции		 // ПолучитьПервуюВерсиюСтрокиПлана()

// Возвращает версию строки СтрокаПланаВход, принадлежащую документ-основанию
// ДокументВход программы закупок.
Функция ПолучитьВерсиюСтрокиПланаОснования(СтрокаПланаВход, ДокументВход) Экспорт
	РезультатФункции = Документы.СтрокаПланаЗакупок.ПустаяСсылка();
	ПерваяВерсияИсходнойСтроки = ПолучитьПервуюВерсиюСтрокиПлана(СтрокаПланаВход);
	МассивСтрокОснования = Новый Массив;
	Для Каждого ТекСтрокиПланаЗакупок Из ДокументВход.СтрокиПланаЗакупок Цикл
		МассивСтрокОснования.Добавить(ТекСтрокиПланаЗакупок);
	КонецЦикла;	
	Для Каждого ТекСтрокиПланаВалютные Из ДокументВход.СтрокиПланаВалютные Цикл
		МассивСтрокОснования.Добавить(ТекСтрокиПланаВалютные);
	КонецЦикла;
	МассивСтрокОснования = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивСтрокОснования);
	МассивСтрокОснования = ОбщегоНазначенияКлиентСерверУХ.УдалитьПустыеЭлементыМассива(МассивСтрокОснования);
	Для Каждого ТекМассивСтрокОснования Из МассивСтрокОснования Цикл
		ТекСтрокаПлана = ТекМассивСтрокОснования.СтрокаПланаЗакупок;
		ТекПерваяВерсия = ПолучитьПервуюВерсиюСтрокиПлана(ТекСтрокаПлана);
		Если ТекПерваяВерсия = ПерваяВерсияИсходнойСтроки Тогда
			РезультатФункции = ТекСтрокаПлана;
			Прервать;
		Иначе
			// Выполняем поиск далее.
		КонецЕсли;
	КонецЦикла;	
	Возврат РезультатФункции;
КонецФункции		 // ПолучитьВерсиюСтрокиПланаОснования()


// Рассчитывает Сумму контракта документа Строка плана закупок по её таблице
// номенклатуры ТаблицаВход.
Функция ПолучитьСуммуКонтрактаПоТаблицеНоменклатуры(ТаблицаВход) Экспорт
	// Получим уникальные строки.
	РезультатФункции = 0;
	СверткаИзмерения = ТаблицаВход.Скопировать();
	СверткаИзмерения.Свернуть("Приоритет,Номенклатура,Организация,МестоПоставки,Проект,ДоговорСПокупателем,Менеджер");
	Для Каждого ТекСверткаИзмерения Из СверткаИзмерения Цикл
		// Отделим уникальные строки по измерениям.
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Приоритет", ТекСверткаИзмерения.Приоритет);
		СтруктураПоиска.Вставить("Номенклатура", ТекСверткаИзмерения.Номенклатура);
		СтруктураПоиска.Вставить("Организация", ТекСверткаИзмерения.Организация);
		СтруктураПоиска.Вставить("МестоПоставки", ТекСверткаИзмерения.МестоПоставки);
		СтруктураПоиска.Вставить("Проект", ТекСверткаИзмерения.Проект);
		СтруктураПоиска.Вставить("ДоговорСПокупателем", ТекСверткаИзмерения.ДоговорСПокупателем);
		СтруктураПоиска.Вставить("Менеджер", ТекСверткаИзмерения.Менеджер);
		НайденныеСтроки = ТаблицаВход.НайтиСтроки(СтруктураПоиска);
		МаксимальноеЗначение = 0;
		Для Каждого ТекНайденныеСтроки Из НайденныеСтроки Цикл
			Если ТекНайденныеСтроки.ИтогоЗаВесьПериод > МаксимальноеЗначение Тогда
				МаксимальноеЗначение = ТекНайденныеСтроки.ИтогоЗаВесьПериод;
			Иначе
				// Пропускаем.
			КонецЕсли;
		КонецЦикла;	
		РезультатФункции = РезультатФункции + МаксимальноеЗначение;
	КонецЦикла;
	Возврат РезультатФункции;
КонецФункции		 // ПолучитьСуммуКонтрактаПоТаблицеНоменклатуры()	


//Возвращат даты начала-окончания поставки по табличной части номенклатура
Функция ДатыПериодаНачалаОкончанияПоставки(СтрокаПлана) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СтрокаПлана",СтрокаПлана);
	Запрос.Текст = "ВЫБРАТЬ
	               |	МИНИМУМ(СтрокаПланаЗакупокНоменклатура.ПериодПотребности.ДатаНачала) КАК ПериодПотребностиДатаНачала,
	               |	МАКСИМУМ(СтрокаПланаЗакупокНоменклатура.ПериодПотребности.ДатаОкончания) КАК ПериодПотребностиДатаОкончания,
	               |	СтрокаПланаЗакупокНоменклатура.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.СтрокаПланаЗакупок.Номенклатура КАК СтрокаПланаЗакупокНоменклатура
	               |ГДЕ
	               |	СтрокаПланаЗакупокНоменклатура.Ссылка = &СтрокаПлана
	               |	И &СтрокаПлана <> ЗНАЧЕНИЕ(Документ.СтрокаПланаЗакупок.ПустаяСсылка)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	СтрокаПланаЗакупокНоменклатура.Ссылка";
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Структура = Новый Структура();
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			Структура.Вставить("ДатаНачала",Выборка.ПериодПотребностиДатаНачала);
			Структура.Вставить("ДатаОкончания",Выборка.ПериодПотребностиДатаОкончания);
		КонецЦикла;
		Возврат Структура;
	КонецЕсли;
КонецФункции

Функция ДатыПериодаНачалаОкончанияПоставкиПоЗакупочнойПроцедуре(ЗакупочнаяПроцедура) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗакупочнаяПроцедура",ЗакупочнаяПроцедура);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Лоты.СтрокаПланаЗакупок КАК СтрокаПланаЗакупок
	               |ПОМЕСТИТЬ СтрокиПланаЗакупок
	               |ИЗ
	               |	Справочник.Лоты КАК Лоты
	               |ГДЕ
	               |	Лоты.ЗакупочнаяПроцедура = &ЗакупочнаяПроцедура
	               |	И Лоты.ПометкаУдаления = ЛОЖЬ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	МИНИМУМ(СтрокаПланаЗакупокНоменклатура.ПериодПотребности.ДатаНачала) КАК ПериодПотребностиДатаНачала,
	               |	МАКСИМУМ(СтрокаПланаЗакупокНоменклатура.ПериодПотребности.ДатаОкончания) КАК ПериодПотребностиДатаОкончания
	               |ИЗ
	               |	Документ.СтрокаПланаЗакупок.Номенклатура КАК СтрокаПланаЗакупокНоменклатура
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СтрокиПланаЗакупок КАК СтрокиПланаЗакупок
	               |		ПО СтрокаПланаЗакупокНоменклатура.Ссылка = СтрокиПланаЗакупок.СтрокаПланаЗакупок";
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Структура = Новый Структура();
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			Структура.Вставить("ДатаНачала",Выборка.ПериодПотребностиДатаНачала);
			Структура.Вставить("ДатаОкончания",Выборка.ПериодПотребностиДатаОкончания);
		КонецЦикла;
		Возврат Структура;
	КонецЕсли;
КонецФункции	

#КонецОбласти


#Область ВнутреннийПрограмныйИнтерфейс

Функция ПолучитьОстаткиПереходящегоПлана(СтрокаПланаЗакупок,ДатаОстатков) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СтрокаПланаЗакупок",СтрокаПланаЗакупок);
	Запрос.УстановитьПараметр("ДатаОстатков",ДатаОстатков);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ПотребностиВНоменклатуре.Регистратор КАК Регистратор,
	               |	ПотребностиВНоменклатуре.НомерСтроки КАК НомерСтроки,
	               |	ПотребностиВНоменклатуре.Активность КАК Активность,
	               |	ПотребностиВНоменклатуре.Организация КАК Организация,
	               |	ПотребностиВНоменклатуре.Приоритет КАК Приоритет,
	               |	ПотребностиВНоменклатуре.Номенклатура КАК Номенклатура,
	               |	ПотребностиВНоменклатуре.Характеристика КАК Характеристика,
	               |	ПотребностиВНоменклатуре.МестоПоставки КАК МестоПоставки,
	               |	ПотребностиВНоменклатуре.Проект КАК Проект,
	               |	ПотребностиВНоменклатуре.Менеджер КАК Менеджер,
	               |	ПотребностиВНоменклатуре.СтавкаНДС КАК СтавкаНДС,
	               |	ПотребностиВНоменклатуре.Коэффициент КАК Коэффициент,
	               |	ПотребностиВНоменклатуре.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	               |	СУММА(ВЫБОР
	               |			КОГДА ПотребностиВНоменклатуре.Регистратор.ВнеПлановойПотребности = ИСТИНА
	               |				ТОГДА ПотребностиВНоменклатуре.КоличествоВнеПлана
	               |			ИНАЧЕ ПотребностиВНоменклатуре.КоличествоВОбеспечении
	               |		КОНЕЦ) КАК КоличествоОбщее,
	               |	СУММА(ВЫБОР
	               |			КОГДА ПотребностиВНоменклатуре.Регистратор.ВнеПлановойПотребности = ИСТИНА
	               |				ТОГДА ПотребностиВНоменклатуре.СуммаВнеПлана
	               |			ИНАЧЕ ПотребностиВНоменклатуре.СуммаВОбеспечении
	               |		КОНЕЦ) КАК СуммаОбщее
	               |ПОМЕСТИТЬ СтрокаПланаЗакупок
	               |ИЗ
	               |	РегистрНакопления.ПотребностиВНоменклатуре КАК ПотребностиВНоменклатуре
	               |ГДЕ
	               |	ПотребностиВНоменклатуре.Регистратор = &СтрокаПланаЗакупок
	               |	И ПотребностиВНоменклатуре.ПериодПотребности.ДатаОкончания <= &ДатаОстатков
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ПотребностиВНоменклатуре.Организация,
	               |	ПотребностиВНоменклатуре.Регистратор,
	               |	ПотребностиВНоменклатуре.Номенклатура,
	               |	ПотребностиВНоменклатуре.Коэффициент,
	               |	ПотребностиВНоменклатуре.Характеристика,
	               |	ПотребностиВНоменклатуре.Проект,
	               |	ПотребностиВНоменклатуре.Активность,
	               |	ПотребностиВНоменклатуре.Менеджер,
	               |	ПотребностиВНоменклатуре.Приоритет,
	               |	ПотребностиВНоменклатуре.ЕдиницаИзмерения,
	               |	ПотребностиВНоменклатуре.СтавкаНДС,
	               |	ПотребностиВНоменклатуре.МестоПоставки,
	               |	ПотребностиВНоменклатуре.НомерСтроки
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ПланПоставокПоДоговорамОбороты.Приоритет КАК Приоритет,
	               |	ПланПоставокПоДоговорамОбороты.Номенклатура КАК Номенклатура,
	               |	ПланПоставокПоДоговорамОбороты.Характеристика КАК Характеристика,
	               |	ПланПоставокПоДоговорамОбороты.Организация КАК Организация,
	               |	ПланПоставокПоДоговорамОбороты.МестоПоставки КАК МестоПоставки,
	               |	ПланПоставокПоДоговорамОбороты.Проект КАК Проект,
	               |	ПланПоставокПоДоговорамОбороты.Менеджер КАК Менеджер,
	               |	СУММА(ПланПоставокПоДоговорамОбороты.КоличествоПриход) КАК КоличествоПриход,
	               |	СУММА(ПланПоставокПоДоговорамОбороты.СуммаПриход) КАК СуммаПриход,
	               |	ПланПоставокПоДоговорамОбороты.Лот.СтрокаПланаЗакупок КАК ЛотСтрокаПланаЗакупок
	               |ПОМЕСТИТЬ ПланПоставок
	               |ИЗ
	               |	РегистрНакопления.ПланПоставокПоДоговорам.Обороты КАК ПланПоставокПоДоговорамОбороты
	               |ГДЕ
	               |	ПланПоставокПоДоговорамОбороты.Лот.СтрокаПланаЗакупок = &СтрокаПланаЗакупок
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ПланПоставокПоДоговорамОбороты.Приоритет,
	               |	ПланПоставокПоДоговорамОбороты.Номенклатура,
	               |	ПланПоставокПоДоговорамОбороты.Характеристика,
	               |	ПланПоставокПоДоговорамОбороты.Организация,
	               |	ПланПоставокПоДоговорамОбороты.МестоПоставки,
	               |	ПланПоставокПоДоговорамОбороты.Проект,
	               |	ПланПоставокПоДоговорамОбороты.Менеджер,
	               |	ПланПоставокПоДоговорамОбороты.Лот.СтрокаПланаЗакупок
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СтрокаПланаЗакупок.Регистратор КАК Регистратор,
	               |	СтрокаПланаЗакупок.НомерСтроки КАК НомерСтроки,
	               |	СтрокаПланаЗакупок.Активность КАК Активность,
	               |	СтрокаПланаЗакупок.Организация КАК Организация,
	               |	СтрокаПланаЗакупок.Приоритет КАК Приоритет,
	               |	СтрокаПланаЗакупок.Номенклатура КАК Номенклатура,
	               |	СтрокаПланаЗакупок.Характеристика КАК Характеристика,
	               |	СтрокаПланаЗакупок.МестоПоставки КАК МестоПоставки,
	               |	СтрокаПланаЗакупок.Проект КАК Проект,
	               |	СтрокаПланаЗакупок.Менеджер КАК Менеджер,
	               |	СтрокаПланаЗакупок.СтавкаНДС КАК СтавкаНДС,
	               |	СтрокаПланаЗакупок.Коэффициент КАК Коэффициент,
	               |	СтрокаПланаЗакупок.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	               |	ЕСТЬNULL(СтрокаПланаЗакупок.КоличествоОбщее - ЕСТЬNULL(ПланПоставок.КоличествоПриход, 0), 0) КАК КоличествоОбщее,
	               |	ЕСТЬNULL(СтрокаПланаЗакупок.СуммаОбщее - ЕСТЬNULL(ПланПоставок.СуммаПриход, 0), 0) КАК СуммаОбщее
	               |ИЗ
	               |	СтрокаПланаЗакупок КАК СтрокаПланаЗакупок
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ПланПоставок КАК ПланПоставок
	               |		ПО (ПланПоставок.Приоритет = СтрокаПланаЗакупок.Приоритет)
	               |			И (ПланПоставок.Номенклатура = СтрокаПланаЗакупок.Номенклатура)
	               |			И (ПланПоставок.Характеристика = СтрокаПланаЗакупок.Характеристика)
	               |			И (ПланПоставок.МестоПоставки = СтрокаПланаЗакупок.МестоПоставки)
	               |			И (ПланПоставок.Организация = СтрокаПланаЗакупок.Организация)
	               |			И (ПланПоставок.Проект = СтрокаПланаЗакупок.Проект)
	               |			И (ПланПоставок.Менеджер = СтрокаПланаЗакупок.Менеджер)";
	Результат = Запрос.Выполнить();
	Возврат Результат.Выгрузить();
КонецФункции	

Функция ЗаполненаНМЦ(РезультатЗапросаТЧНоменклатура)
	ВыборкаНоменклатуры = РезультатЗапросаТЧНоменклатура.Выбрать();
	Пока ВыборкаНоменклатуры.Следующий() Цикл
		Если ВыборкаНоменклатуры.ТребуетсяОбоснованиеНМЦ
				И НЕ ЗначениеЗаполнено(ВыборкаНоменклатуры.Цена)
				И ТипЗнч(ВыборкаНоменклатуры.Номенклатура) 
						= Тип("СправочникСсылка.Номенклатура") Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат Истина;
КонецФункции

Функция РезультатЗапросаСодержитДанные(РезультатЗапроса, ИмяПоляДляПроверки)
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ВыборкаРезультата = 
			РезультатЗапроса.Выбрать();
		Пока ВыборкаРезультата.Следующий() Цикл
			Если ЗначениеЗаполнено(ВыборкаРезультата[ИмяПоляДляПроверки]) Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЦикла;		
	КонецЕсли;
	Возврат Ложь;
КонецФункции

Функция ПолучитьЗапросыНаПроведениеЗакупки(СтрокаПланаЗакупок)
	Отбор = Новый Структура("ДокументОснование, Проведен", 
							СтрокаПланаЗакупок, Истина);
	Возврат ЦентрализованныеЗакупкиУХ.ПолучитьДокументыПоОтбору(
		"ОбоснованиеТребованийКЗакупочнойПроцедуре",
		Отбор);
	КонецФункции
	
Функция ПолучитьЗапросыНаПроведениеЗакупкиПоСтрокеПланаЗакупок(СтрокаПланаЗакупок)
	Отбор = Новый Структура(
		"ДокументОснование, Проведен", 
		СтрокаПланаЗакупок, Истина);
	Возврат ЦентрализованныеЗакупкиУХ.ПолучитьДокументыПоОтбору(
		"ОбоснованиеТребованийКЗакупочнойПроцедуре",
		Отбор);
КонецФункции

Функция ПолучитьРеквизитыТребуемыеДляОбоснованияНМЦ(ДокументСсылка)
	ТребуемыеРеквизиты = "ТребуетсяОбоснованиеНМЦ"
		+ ", ОценкаНМЦЗавершена";
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		ДокументСсылка, ТребуемыеРеквизиты);
КонецФункции

// Рекурсивно находит актуальные версии строки плана закупок СтрокаПланаВход и помещает
// результат в МассивРезультатИзм. Параметр ГлубинаРекурсииВход защищает от бесконечной
// рекурсии.
Процедура ПолучитьАктуальнуюСтрокуРекурсивно(СтрокаПланаВход, МассивРезультатИзм, ГлубинаРекурсииВход = 0)
	Если ГлубинаРекурсииВход > 9999 Тогда
		Возврат;
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	СтрокаПланаЗакупок.ДокументОснование КАК ДокументОснование,
		|	СтрокаПланаЗакупок.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.СтрокаПланаЗакупок КАК СтрокаПланаЗакупок
		|ГДЕ
		|	НЕ СтрокаПланаЗакупок.ПометкаУдаления
		|	И СтрокаПланаЗакупок.ДокументОснование = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	СтрокаПланаЗакупок.Дата УБЫВ";
	Запрос.УстановитьПараметр("Ссылка", СтрокаПланаВход);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		// Документ-потомок не найден. Текущая версия является актуальной.
		МассивРезультатИзм.Добавить(СтрокаПланаВход);
	Иначе	
		// Найден потомок. Вызовем поиск относительно него.
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ДокументПотомок = ВыборкаДетальныеЗаписи.Ссылка;
			Если ЗначениеЗаполнено(ДокументПотомок) Тогда
				Если ДокументПотомок <> СтрокаПланаВход Тогда
					ПолучитьАктуальнуюСтрокуРекурсивно(ДокументПотомок, МассивРезультатИзм, ГлубинаРекурсииВход + 1); 
				Иначе
					МассивРезультатИзм.Добавить(ДокументПотомок);
				КонецЕсли;
			Иначе
				МассивРезультатИзм.Добавить(СтрокаПланаВход);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры		 // ПолучитьАктуальнуюСтрокуРекурсивно()

#КонецОбласти

#КонецЕсли