///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Обработчики условных вызовов из БСП

// Читает и устанавливает настройку предупреждение о продолжительной синхронизации АРМ
// Параметры:
//     ЗначениеФлага     - Булево - устанавливаемое значение флага
//     ОписаниеНастройки - Структура - принимает значение для описания настройки
// Для внутреннего использования.
//
Функция ФлагНастройкиВопросаОДолгойСинхронизации(ЗначениеФлага = Неопределено, ОписаниеНастройки = Неопределено) Экспорт
	ОписаниеНастройки = Новый Структура;
	
	ОписаниеНастройки.Вставить("КлючОбъекта",  "НастройкиПрограммы");
	ОписаниеНастройки.Вставить("КлючНастроек", "ПоказыватьПредупреждениеОДолгойСинхронизацииАРМ");
	ОписаниеНастройки.Вставить("Представление", НСтр("ru = 'Показывать предупреждение о длительной синхронизации';
													|en = 'Show warning about long synchronization'"));
	
	ОписаниеНастроек = Новый ОписаниеНастроек;
	ЗаполнитьЗначенияСвойств(ОписаниеНастроек, ОписаниеНастройки);
	
	Если ЗначениеФлага = Неопределено Тогда
		// Чтение
		Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ОписаниеНастроек.КлючОбъекта, ОписаниеНастроек.КлючНастроек, Истина);
	КонецЕсли;
	
	// Запись
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ОписаниеНастроек.КлючОбъекта, ОписаниеНастроек.КлючНастроек, ЗначениеФлага, ОписаниеНастроек);
КонецФункции

// Для внутреннего использования
// 
Функция АдресДляВосстановленияПароляУчетнойЗаписи() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат СокрЛП(Константы.АдресДляВосстановленияПароляУчетнойЗаписи.Получить());
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ, ИСПОЛЬЗУЕМЫЕ НА СТОРОНЕ СЕРВИСА

// Для внутреннего использования
// 
Процедура СоздатьНачальныйОбразАвтономногоРабочегоМеста(Параметры,
		АдресВременногоХранилищаНачальногоОбраза,
		АдресВременногоХранилищаИнформацииОПакетеУстановки) Экспорт
	
	ПомощникСозданияАвтономногоРабочегоМеста = Обработки.ПомощникСозданияАвтономногоРабочегоМеста.Создать();
	
	ЗаполнитьЗначенияСвойств(ПомощникСозданияАвтономногоРабочегоМеста, Параметры);
	
	ПомощникСозданияАвтономногоРабочегоМеста.СоздатьНачальныйОбразАвтономногоРабочегоМеста(
				Параметры.НастройкаОтборовНаУзле,
				Параметры.ВыбранныеПользователиСинхронизации,
				АдресВременногоХранилищаНачальногоОбраза,
				АдресВременногоХранилищаИнформацииОПакетеУстановки);
	
КонецПроцедуры

// Для внутреннего использования
// 
Процедура УдалитьАвтономноеРабочееМесто(Параметры, АдресХранилища) Экспорт
	
	ОбменДаннымиСервер.ПроверитьВозможностьАдминистрированияОбменов();
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
	    ЭлементБлокировки = Блокировка.Добавить(ОбщегоНазначения.ИмяТаблицыПоСсылке(Параметры.АвтономноеРабочееМесто));
	    ЭлементБлокировки.УстановитьЗначение("Ссылка", Параметры.АвтономноеРабочееМесто);
	    Блокировка.Заблокировать();
		
		ЗаблокироватьДанныеДляРедактирования(Параметры.АвтономноеРабочееМесто);
		АвтономноеРабочееМестоОбъект = Параметры.АвтономноеРабочееМесто.ПолучитьОбъект();
		
		Если АвтономноеРабочееМестоОбъект <> Неопределено Тогда
			
			АвтономноеРабочееМестоОбъект.ДополнительныеСвойства.Вставить("УдалениеНастройкиСинхронизации");
			АвтономноеРабочееМестоОбъект.Удалить();
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Для внутреннего использования
// 
Функция АвтономнаяРаботаПоддерживается() Экспорт
	
	Возврат ОбменДаннымиПовтИсп.АвтономнаяРаботаПоддерживается();
	
КонецФункции

// Для внутреннего использования
// 
Функция КоличествоАвтономныхРабочихМест() Экспорт
	
	ШаблонТекста = "ПланОбмена.%1";
	ИмяПланаОбменаСтрокой = СтрШаблон(ШаблонТекста, ПланОбменаАвтономнойРаботы());
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	&ИмяПланаОбмена КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка <> &ПриложениеВСервисе
	|	И НЕ Таблица.ПометкаУдаления";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяПланаОбмена", ИмяПланаОбменаСтрокой);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПриложениеВСервисе", ПриложениеВСервисе());
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Количество;
КонецФункции

// Для внутреннего использования
// 
Функция ПриложениеВСервисе() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбменДаннымиСервер.ГлавныйУзел() <> Неопределено Тогда
		
		Возврат ОбменДаннымиСервер.ГлавныйУзел();
		
	Иначе
		
		Возврат ПланыОбмена[ПланОбменаАвтономнойРаботы()].ЭтотУзел();
		
	КонецЕсли;
	
КонецФункции

// Для внутреннего использования
// 
Функция АвтономноеРабочееМесто() Экспорт
	
	ШаблонТекста = "ПланОбмена.%1";
	ИмяПланаОбменаСтрокой = СтрШаблон(ШаблонТекста, ПланОбменаАвтономнойРаботы());
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Таблица.Ссылка КАК АвтономноеРабочееМесто
	|ИЗ
	|	&ИмяПланаОбмена КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка <> &ПриложениеВСервисе
	|	И НЕ Таблица.ПометкаУдаления";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяПланаОбмена", ИмяПланаОбменаСтрокой);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПриложениеВСервисе", ПриложениеВСервисе());
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.АвтономноеРабочееМесто;
КонецФункции

// Для внутреннего использования
// 
Функция ПланОбменаАвтономнойРаботы() Экспорт
	
	Возврат ОбменДаннымиПовтИсп.ПланОбменаАвтономнойРаботы();
	
КонецФункции

// Для внутреннего использования
// 
Функция ЭтоУзелАвтономногоРабочегоМеста(Знач УзелИнформационнойБазы) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиПовтИсп.ЭтоУзелАвтономногоРабочегоМеста(УзелИнформационнойБазы);
	
КонецФункции

// Для внутреннего использования
// 
Функция ДатаПоследнейУспешнойСинхронизации(АвтономноеРабочееМесто) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	МИНИМУМ(СостоянияУспешныхОбменовДанными.ДатаОкончания) КАК ДатаСинхронизации
	|ИЗ
	|	&СостоянияУспешныхОбменовДанными КАК СостоянияУспешныхОбменовДанными
	|ГДЕ
	|	СостоянияУспешныхОбменовДанными.УзелИнформационнойБазы = &АвтономноеРабочееМесто";
	
	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&СостоянияУспешныхОбменовДанными", "РегистрСведений.СостоянияУспешныхОбменовДаннымиОбластейДанных");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&СостоянияУспешныхОбменовДанными", "РегистрСведений.СостоянияУспешныхОбменовДанными");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("АвтономноеРабочееМесто", АвтономноеРабочееМесто);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат ?(ЗначениеЗаполнено(Выборка.ДатаСинхронизации), Выборка.ДатаСинхронизации, Неопределено);
КонецФункции

// Для внутреннего использования
// 
Функция СформироватьНаименованиеАвтономногоРабочегоМестаПоУмолчанию() Экспорт
	
	ШаблонТекста = "ПланОбмена.%1";
	ИмяПланаОбменаСтрокой = СтрШаблон(ШаблонТекста, ПланОбменаАвтономнойРаботы());
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	&ИмяПланаОбмена КАК Таблица
	|ГДЕ
	|	Таблица.Наименование ПОДОБНО &ШаблонИмени";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяПланаОбмена", ИмяПланаОбменаСтрокой);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ШаблонИмени", НаименованиеАвтономногоРабочегоМестаПоУмолчанию() + "%");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Количество = Выборка.Количество;
	
	Если Количество = 0 Тогда
		
		Возврат НаименованиеАвтономногоРабочегоМестаПоУмолчанию();
		
	Иначе
		
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"%1 (%2)",
			НаименованиеАвтономногоРабочегоМестаПоУмолчанию(), XMLСтрока(Количество + 1));
		
	КонецЕсли;
	
КонецФункции

// Для внутреннего использования
// 
Функция СформироватьПрефиксАвтономногоРабочегоМеста(Знач ПоследнийПрефикс = "") Экспорт
	
	ДопустимыеСимволы = ДопустимыеСимволыПрефиксаАвтономногоРабочегоМеста();
	
	СимволПоследнегоАвтономногоРабочегоМеста = Лев(ПоследнийПрефикс, 1);
	
	ПозицияСимвола = СтрНайти(ДопустимыеСимволы, СимволПоследнегоАвтономногоРабочегоМеста);
	
	Если ПозицияСимвола = 0 ИЛИ ПустаяСтрока(СимволПоследнегоАвтономногоРабочегоМеста) Тогда
		
		Символ = Лев(ДопустимыеСимволы, 1); // Используем первый символ
		
	ИначеЕсли ПозицияСимвола >= СтрДлина(ДопустимыеСимволы) Тогда
		
		Символ = Прав(ДопустимыеСимволы, 1); // Используем последний символ
		
	Иначе
		
		Символ = Сред(ДопустимыеСимволы, ПозицияСимвола + 1, 1); // Используем следующий символ
		
	КонецЕсли;
	
	ПрефиксПриложения = Прав(ПолучитьФункциональнуюОпцию("ПрефиксИнформационнойБазы"), 1);
	
	Результат = "[Символ][ПрефиксПриложения]";
	Результат = СтрЗаменить(Результат, "[Символ]", Символ);
	Результат = СтрЗаменить(Результат, "[ПрефиксПриложения]", ПрефиксПриложения);
	
	Возврат Результат;
КонецФункции

// Для внутреннего использования
// 
Функция ИмяФайлаПакетаУстановки() Экспорт
	
	Возврат НСтр("ru = 'Автономная работа.zip';
				|en = 'Standalone mode.zip'");
	
КонецФункции

// Для внутреннего использования
// 
Функция ОписаниеОграниченийПередачиДанных(АвтономноеРабочееМесто) Экспорт
	
	ПланОбменаАвтономнойРаботы = ПланОбменаАвтономнойРаботы();
	
	НастройкаОтборовНаУзлеПоУмолчанию = ОбменДаннымиСервер.НастройкаОтборовНаУзле(ПланОбменаАвтономнойРаботы, "");
	
	Если НастройкаОтборовНаУзлеПоУмолчанию.Количество() = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	// Нельзя менять данные, полученные из кэша, поэтому копируем структуру настроек для дальнейшего заполнения
	НастройкаОтборовНаУзле = ОбщегоНазначения.СкопироватьРекурсивно(НастройкаОтборовНаУзлеПоУмолчанию, Ложь);
	
	Реквизиты = Новый Массив;
	
	Для Каждого Элемент Из НастройкаОтборовНаУзле Цикл
		
		Реквизиты.Добавить(Элемент.Ключ);
		
	КонецЦикла;
	
	Реквизиты = СтрСоединить(Реквизиты, ",");
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(АвтономноеРабочееМесто, Реквизиты);
	
	Для Каждого Элемент Из НастройкаОтборовНаУзле Цикл
		
		Если ТипЗнч(Элемент.Значение) = Тип("Структура") Тогда
			
			Таблица = ЗначенияРеквизитов[Элемент.Ключ].Выгрузить();
			
			Для Каждого ВложенныйЭлемент Из Элемент.Значение Цикл
				
				НастройкаОтборовНаУзле[Элемент.Ключ][ВложенныйЭлемент.Ключ] = Таблица.ВыгрузитьКолонку(ВложенныйЭлемент.Ключ);
				
			КонецЦикла;
			
		Иначе
			
			НастройкаОтборовНаУзле[Элемент.Ключ] = ЗначенияРеквизитов[Элемент.Ключ];
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ОбменДаннымиСервер.ОписаниеОграниченийПередачиДанных(ПланОбменаАвтономнойРаботы, НастройкаОтборовНаУзле, "");
КонецФункции

// Для внутреннего использования
// 
Функция МониторАвтономныхРабочихМест() Экспорт
	
	ШаблонТекста = "ПланОбмена.%1";
	ИмяПланаОбменаСтрокой = СтрШаблон(ШаблонТекста, ПланОбменаАвтономнойРаботы());
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	СостоянияУспешныхОбменовДанными.УзелИнформационнойБазы КАК АвтономноеРабочееМесто,
	|	МИНИМУМ(СостоянияУспешныхОбменовДанными.ДатаОкончания) КАК ДатаСинхронизации
	|ПОМЕСТИТЬ СостоянияУспешныхОбменовДанными
	|ИЗ
	|	РегистрСведений.СостоянияУспешныхОбменовДаннымиОбластейДанных КАК СостоянияУспешныхОбменовДанными
	|СГРУППИРОВАТЬ ПО
	|	СостоянияУспешныхОбменовДанными.УзелИнформационнойБазы
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПланОбмена.Ссылка КАК АвтономноеРабочееМесто,
	|	ЕСТЬNULL(СостоянияУспешныхОбменовДанными.ДатаСинхронизации, Неопределено) КАК ДатаСинхронизации
	|ИЗ
	|	&ИмяПланаОбмена КАК ПланОбмена
	|		ЛЕВОЕ СОЕДИНЕНИЕ СостоянияУспешныхОбменовДанными КАК СостоянияУспешныхОбменовДанными
	|		ПО ПланОбмена.Ссылка = СостоянияУспешныхОбменовДанными.АвтономноеРабочееМесто
	|ГДЕ
	|	ПланОбмена.Ссылка <> &ПриложениеВСервисе
	|	И НЕ ПланОбмена.ПометкаУдаления
	|УПОРЯДОЧИТЬ ПО
	|	ПланОбмена.Представление";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяПланаОбмена", ИмяПланаОбменаСтрокой);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПриложениеВСервисе", ПриложениеВСервисе());
	Запрос.Текст = ТекстЗапроса;
	
	НастройкиСинхронизации = Запрос.Выполнить().Выгрузить();
	НастройкиСинхронизации.Колонки.Добавить("ПредставлениеДатыСинхронизации");
	
	Для Каждого НастройкаСинхронизации Из НастройкиСинхронизации Цикл
		
		Если ЗначениеЗаполнено(НастройкаСинхронизации.ДатаСинхронизации) Тогда
			НастройкаСинхронизации.ПредставлениеДатыСинхронизации =
				ОбменДаннымиСервер.ОтносительнаяДатаСинхронизации(НастройкаСинхронизации.ДатаСинхронизации);
		Иначе
			НастройкаСинхронизации.ПредставлениеДатыСинхронизации = НСтр("ru = 'не выполнялась';
																		|en = 'not performed'");
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НастройкиСинхронизации;
КонецФункции

// Для внутреннего использования
// 
Функция СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста() Экспорт
	
	Возврат НСтр("ru = 'Автономная работа.Создание автономного рабочего места';
				|en = 'Standalone mode.Create standalone workplace'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

// Для внутреннего использования
// 
Функция СобытиеЖурналаРегистрацииУдалениеАвтономногоРабочегоМеста() Экспорт
	
	Возврат НСтр("ru = 'Автономная работа.Удаление автономного рабочего места';
				|en = 'Standalone mode.Delete standalone workplace'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

// Для внутреннего использования
// 
Функция ТекстИнструкцииИзМакета(Знач ИмяМакета) Экспорт
	
	Результат = Обработки.ПомощникСозданияАвтономногоРабочегоМеста.ПолучитьМакет(ИмяМакета).ПолучитьТекст();
	Результат = СтрЗаменить(Результат, "[НазваниеПрограммы]", Метаданные.Синоним);
	Результат = СтрЗаменить(Результат, "[ВерсияПлатформы]", ОбменДаннымиВМоделиСервиса.ТребуемаяВерсияПлатформы());
	Возврат Результат;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ, ИСПОЛЬЗУЕМЫЕ НА СТОРОНЕ АВТОНОМНОГО РАБОЧЕГО МЕСТА

// Для внутреннего использования
// 
Процедура СинхронизироватьДанныеСПриложениемВИнтернете() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЭтоАвтономноеРабочееМесто() Тогда
		
		ПодробноеПредставлениеОшибкиДляЖурналаРегистрации =
			НСтр("ru = 'Эта информационная база не является автономным рабочим местом. Синхронизация данных отменена.';
				|en = 'This infobase is not a standalone workplace. Data synchronization is canceled.'",
			ОбщегоНазначения.КодОсновногоЯзыка());
		ПодробноеПредставлениеОшибки =
			НСтр("ru = 'Эта информационная база не является автономным рабочим местом. Синхронизация данных отменена.';
				|en = 'This infobase is not a standalone workplace. Data synchronization is canceled.'");
		
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииСинхронизацияДанных(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибкиДляЖурналаРегистрации);
		ВызватьИсключение ПодробноеПредставлениеОшибки;
		
	КонецЕсли;
	
	УзелОбмена = ПриложениеВСервисе();
	
	Отказ = Ложь;
	ОбменДаннымиСервер.ПроверитьВозможностьЗапускаОбмена(УзелОбмена, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОбмена = ОбменДаннымиСервер.ПараметрыОбмена();
	ПараметрыОбмена.ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.WS;
	ПараметрыОбмена.ВыполнятьЗагрузку = Истина;
	ПараметрыОбмена.ВыполнятьВыгрузку = Истина;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
		ПараметрыОбмена.ИнтервалОжиданияНаСервере   = 30;
		ПараметрыОбмена.ДлительнаяОперацияРазрешена = Истина;
	КонецЕсли;
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(УзелОбмена, ПараметрыОбмена, Отказ);
	
	Если Отказ Тогда
		ВызватьИсключение НСтр("ru = 'В процессе синхронизации данных с приложением в Интернете возникли ошибки (см. журнал регистрации).';
								|en = 'Errors occurred during data synchronization with the web application. See the event log.'");
	КонецЕсли;
	
КонецПроцедуры

// Для внутреннего использования.
// 
Процедура ВыполнитьНастройкуАвтономногоРабочегоМестаПриПервомЗапуске() Экспорт
	
	Если Не ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ВызватьИсключение НСтр("ru = 'Первый запуск автономного рабочего места должен выполняться в файловой информационной базе.';
								|en = 'The first start of a standalone workplace must be performed in a file infobase.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗагрузитьДанныеНачальногоОбраза();
	ЗагрузитьПараметрыИзНачальногоОбраза();
	
	// Правила обмена не мигрируют в РИБ, поэтому выполняем загрузку правил.
	ОбменДаннымиСервер.ВыполнитьОбновлениеПравилДляОбменаДанными();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ОбменДаннымиСервер.ПриПродолженииНастройкиПодчиненногоУзлаРИБ();
	
КонецПроцедуры

// Для внутреннего использования
// 
Процедура ОтключитьАвтоматическуюСинхронизациюДанныхСПриложениемВИнтернете(Источник) Экспорт
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		
		ОтключитьАвтоматическуюСинхронизацию = Ложь;
		
		Для Каждого СтрокаНабора Из Источник Цикл
			
			Если СтрокаНабора.ВидТранспортаСообщенийОбменаПоУмолчанию = Перечисления.ВидыТранспортаСообщенийОбмена.WS
				И Не СтрокаНабора.WSЗапомнитьПароль Тогда
				
				ОтключитьАвтоматическуюСинхронизацию = Истина;
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ОтключитьАвтоматическуюСинхронизацию Тогда
			
			УстановитьПривилегированныйРежим(Истина);
			
			РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
				Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете, Ложь);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Для внутреннего использования
// 
Функция НеобходимоВыполнитьНастройкуАвтономногоРабочегоМестаПриПервомЗапуске() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Не Константы.НастройкаПодчиненногоУзлаРИБЗавершена.Получить() И ЭтоАвтономноеРабочееМесто();
	
КонецФункции

// Для внутреннего использования
// 
Функция СинхронизироватьДанныеСПриложениемВИнтернетеПриНачалеРаботы() Экспорт
	
	Возврат ЭтоАвтономноеРабочееМесто()
		И Константы.НастройкаПодчиненногоУзлаРИБЗавершена.Получить()
		И Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриНачалеРаботыПрограммы.Получить()
		И СинхронизацияССервисомДавноНеВыполнялась()
		И ОбменДаннымиСервер.СинхронизацияДанныхРазрешена();
		
КонецФункции

// Для внутреннего использования
// 
Функция СинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииРаботы() Экспорт
	
	Возврат ЭтоАвтономноеРабочееМесто()
		И Константы.НастройкаПодчиненногоУзлаРИБЗавершена.Получить()
		И Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииРаботыПрограммы.Получить()
		И ОбменДаннымиСервер.СинхронизацияДанныхРазрешена();
		
КонецФункции

// Для внутреннего использования
// 
Функция РасписаниеСинхронизацииДанныхПоУмолчанию() Экспорт // Каждый час
	
	Месяцы = Новый Массив;
	Для Сч = 1 По 12 Цикл
		Месяцы.Добавить(Сч);
	КонецЦикла;
	
	ДниНедели = Новый Массив;
	Для Сч = 1 По 7 Цикл
		ДниНедели.Добавить(Сч);
	КонецЦикла;
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.Месяцы                   = Месяцы;
	Расписание.ДниНедели                = ДниНедели;
	Расписание.ПериодПовтораВТечениеДня = 60*60; // 60 минут
	Расписание.ПериодПовтораДней        = 1; // каждый день
	
	Возврат Расписание;
КонецФункции

// Для внутреннего использования
// 
Функция ЭтоАвтономноеРабочееМесто() Экспорт
	
	Возврат ОбменДаннымиСервер.ЭтоАвтономноеРабочееМесто();
	
КонецФункции

// Для внутреннего использования
// 
Функция ПараметрыФормыВыполненияОбменаДанными() Экспорт
	
	Возврат Новый Структура("УзелИнформационнойБазы, АдресДляВосстановленияПароляУчетнойЗаписи, ЗакрытьПриУспешнойСинхронизации",
		ПриложениеВСервисе(), АдресДляВосстановленияПароляУчетнойЗаписи(), Истина);
КонецФункции

// Для внутреннего использования
// 
Функция СинхронизацияССервисомДавноНеВыполнялась(Знач Интервал = 3600) Экспорт // 1 час по умолчанию
	
	Возврат Истина;
	
КонецФункции

// Определяет возможность внесения изменений в объект
// Объект нельзя записать в Автономном рабочем месте, если он одновременно соответствует следующим условиям:
//	1. Это автономное рабочее место.
//	2. Это неразделенный объект метаданных.
//	3. Этот объект входит в состав плана обмена автономной работы.
//	4. Не входит в список исключений.
//
// Параметры:
//   ОбъектМетаданных - ОбъектМетаданных - метаданные проверяемого объекта
//   ТолькоПросмотр - Булево - если Истина, то объект доступен только для просмотра.
//
Процедура ОпределитьВозможностьИзмененияДанных(ОбъектМетаданных, ТолькоПросмотр) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат;
	КонецЕсли;
	
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТолькоПросмотр = ЭтоАвтономноеРабочееМесто()
		И (Не МодульРаботаВМоделиСервиса.ЭтоРазделенныйОбъектМетаданных(ОбъектМетаданных.ПолноеИмя(),
			МодульРаботаВМоделиСервиса.РазделительОсновныхДанных())
			И Не МодульРаботаВМоделиСервиса.ЭтоРазделенныйОбъектМетаданных(ОбъектМетаданных.ПолноеИмя(),
				МодульРаботаВМоделиСервиса.РазделительВспомогательныхДанных()))
		И Не ОбъектМетаданныхЯвляетсяИсключением(ОбъектМетаданных)
		И Метаданные.ПланыОбмена[ПланОбменаАвтономнойРаботы()].Состав.Содержит(ОбъектМетаданных);
	
КонецПроцедуры

Функция ПоддерживаетсяПередачаБольшихФайлов() Экспорт
	
	МодульТехнологияСервиса = ОбщегоНазначения.ОбщийМодуль("ТехнологияСервиса");
	ВерсияБТС = МодульТехнологияСервиса.ВерсияБиблиотеки();
	
	Возврат ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияБТС, "1.2.2.24") >= 0;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьИспользованиеИтоговРегистров(ФлагИспользования)
	
	ДатаСеанса = ТекущаяДатаСеанса();
	РегистрНакопленияПериод  = КонецМесяца(ДобавитьМесяц(ДатаСеанса, -1)); // Конец прошлого месяца.
	РегистрБухгалтерииПериод = КонецМесяца(ДатаСеанса); // Конец текущего месяца.
	
	ВидОстатки = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки;
	
	Для Каждого РегистрМетаданные Из Метаданные.РегистрыНакопления Цикл
		
		Если РегистрМетаданные.ВидРегистра <> ВидОстатки Тогда
			Продолжить;
		КонецЕсли;
		
		РегистрНакопленияМенеджер = РегистрыНакопления[РегистрМетаданные.Имя];
		
		РегистрНакопленияМенеджер.УстановитьИспользованиеИтогов(ФлагИспользования);
		РегистрНакопленияМенеджер.УстановитьИспользованиеТекущихИтогов(ФлагИспользования);
		
		Если ФлагИспользования Тогда
			РегистрНакопленияМенеджер.УстановитьМаксимальныйПериодРассчитанныхИтогов(РегистрНакопленияПериод);
			РегистрНакопленияМенеджер.ПересчитатьТекущиеИтоги();
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого РегистрМетаданные Из Метаданные.РегистрыБухгалтерии Цикл
		
		РегистрБухгалтерииМенеджер = РегистрыБухгалтерии[РегистрМетаданные.Имя];
		
		РегистрБухгалтерииМенеджер.УстановитьИспользованиеИтогов(ФлагИспользования);
		РегистрБухгалтерииМенеджер.УстановитьИспользованиеТекущихИтогов(ФлагИспользования);
		
		Если ФлагИспользования Тогда
			РегистрБухгалтерииМенеджер.УстановитьМаксимальныйПериодРассчитанныхИтогов(РегистрБухгалтерииПериод);
			РегистрБухгалтерииМенеджер.ПересчитатьТекущиеИтоги();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ЭтоОбъектНачальногоОбразаУзлаРИБ(Знач Объект)
	
	Если ОбменДаннымиПовтИсп.АвтономнаяРаботаПоддерживается() Тогда
		РежимРегистрации = СтандартныеПодсистемыПовтИсп.РежимРегистрацииДанныхДляПланаОбмена(
			Объект.ПолноеИмя(), ОбменДаннымиПовтИсп.ПланОбменаАвтономнойРаботы());
		Если РежимРегистрации = "АвторегистрацияОтключена" Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Для внутреннего использования
// 
Функция НаименованиеАвтономногоРабочегоМестаПоУмолчанию()
	
	Результат = НСтр("ru = 'Автономная работа - %1';
					|en = 'Standalone mode - %1'");
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Результат, ПолноеИмяПользователя());
	
КонецФункции

// Для внутреннего использования
// 
Функция ДопустимыеСимволыПрефиксаАвтономногоРабочегоМеста()
	
	Возврат НСтр("ru = 'АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЭЮЯабвгдежзиклмнопрстуфхцчшэюя';
				|en = 'ABCDEFGHIKLMNOPQRSTVXYZabcdefghiklmnopqrstvxyz'"); // 54 символа
	
КонецФункции

// Для внутреннего использования
// 
Процедура ЗагрузитьПараметрыИзНачальногоОбраза()
	
	Параметры = ПолучитьПараметрыИзНачальногоОбраза();
	
	ГлавныйУзелСсылка = ПланыОбмена.ГлавныйУзел();
	Попытка
		ПланыОбмена.УстановитьГлавныйУзел(Неопределено);
	Исключение
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение НСтр("ru = 'Возможно, информационная база открыта в режиме конфигуратора.
		|Завершите работу конфигуратора и повторите запуск программы.';
		|en = 'The infobase might be opened in Designer mode.
		|Close Designer and restart the application.'");
	КонецПопытки;
	
	НачатьТранзакцию();
	Попытка
		ИзменитьИспользованиеРазделения(Истина, Параметры.ОбластьДанных);
		
		ГлавныйУзелОбъект = ГлавныйУзелСсылка.ПолучитьОбъект();
		ГлавныйУзелОбъект.ОбменДанными.Загрузка = Истина;
		ГлавныйУзелОбъект.ДополнительныеСвойства.Вставить("ЭтоГлавныйУзелАРМ");
		ГлавныйУзелОбъект.ДополнительныеСвойства.Вставить("УдалениеНастройкиСинхронизации");
		ГлавныйУзелОбъект.Удалить();
		
		ИзменитьИспользованиеРазделения(Ложь);
		
		// Создаем узлы плана обмена автономной работы в нулевой области данных.
		УзелАвтономногоРабочегоМеста = ПланыОбмена[ПланОбменаАвтономнойРаботы()].ЭтотУзел().ПолучитьОбъект();
		УзелАвтономногоРабочегоМеста.Код          = Параметры.КодАвтономногоРабочегоМеста;
		УзелАвтономногоРабочегоМеста.Наименование = Параметры.НаименованиеАвтономногоРабочегоМеста;
		УзелАвтономногоРабочегоМеста.ДополнительныеСвойства.Вставить("ПолучениеСообщенияОбмена");
		УзелАвтономногоРабочегоМеста.Записать();
		
		УзелПриложенияВСервисе = ПланыОбмена[ПланОбменаАвтономнойРаботы()].СоздатьУзел();
		УзелПриложенияВСервисе.УстановитьСсылкуНового(ГлавныйУзелСсылка);
		УзелПриложенияВСервисе.Код          = Параметры.КодПриложенияВСервисе;
		УзелПриложенияВСервисе.Наименование = Параметры.НаименованиеПриложенияВСервисе;
		УзелПриложенияВСервисе.ДополнительныеСвойства.Вставить("ПолучениеСообщенияОбмена");
		УзелПриложенияВСервисе.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
	// Назначение созданного узла главным.
	ПланыОбмена.УстановитьГлавныйУзел(ГлавныйУзелСсылка);
	СтандартныеПодсистемыСервер.СохранитьГлавныйУзел();
	
	НачатьТранзакцию();
	Попытка
		Константы.ИспользоватьСинхронизациюДанных.Установить(Истина);
		Константы.НастройкиПодчиненногоУзлаРИБ.Установить("");
		Константы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Установить(Параметры.Префикс);
		Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриНачалеРаботыПрограммы.Установить(Истина);
		Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииРаботыПрограммы.Установить(Истина);
		Константы.ЗаголовокСистемы.Установить(Параметры.ЗаголовокСистемы);
		
		Константы.ЭтоАвтономноеРабочееМесто.Установить(Истина);
		Константы.ИспользоватьРазделениеПоОбластямДанных.Установить(Ложь);
		
		// Константа влияет на открытие помощника по настройке автономного рабочего места.
		Константы.НастройкаПодчиненногоУзлаРИБЗавершена.Установить(Истина);
		
		// Добавляем запись в РС транспорта обмена.
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("ВидТранспортаСообщенийОбменаПоУмолчанию", Перечисления.ВидыТранспортаСообщенийОбмена.WS);
		СтруктураЗаписи.Вставить("WSИспользоватьПередачуБольшогоОбъемаДанных", Истина);
		СтруктураЗаписи.Вставить("WSURLВебСервиса", Параметры.URL);
		СтруктураЗаписи.Вставить("Корреспондент", ПриложениеВСервисе());
		
		РегистрыСведений.НастройкиТранспортаОбменаДанными.ДобавитьЗапись(СтруктураЗаписи);
		
		// Добавляем запись в РС общих настроек узлов информационных баз.
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("УзелИнформационнойБазы", ПриложениеВСервисе());
		СтруктураЗаписи.Вставить("НастройкаЗавершена", Истина);
		СтруктураЗаписи.Вставить("Префикс", Параметры.Префикс);
		Если Параметры.Свойство("ПрефиксПриложенияВСервисе") Тогда
			СтруктураЗаписи.Вставить("ПрефиксКорреспондента", Параметры.ПрефиксПриложенияВСервисе);
		КонецЕсли;
		ОбменДаннымиСлужебный.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "ОбщиеНастройкиУзловИнформационныхБаз");
		
		// Устанавливаем дату создания начального образа, как дату первой успешной синхронизации данных.
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("УзелИнформационнойБазы", ПриложениеВСервисе());
		СтруктураЗаписи.Вставить("ДействиеПриОбмене", Перечисления.ДействияПриОбмене.ВыгрузкаДанных);
		СтруктураЗаписи.Вставить("ДатаОкончания", Параметры.ДатаСозданияНачальногоОбраза);
		РегистрыСведений.СостоянияУспешныхОбменовДанными.ДобавитьЗапись(СтруктураЗаписи);
		
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("УзелИнформационнойБазы", ПриложениеВСервисе());
		СтруктураЗаписи.Вставить("ДействиеПриОбмене", Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
		СтруктураЗаписи.Вставить("ДатаОкончания", Параметры.ДатаСозданияНачальногоОбраза);
		РегистрыСведений.СостоянияУспешныхОбменовДанными.ДобавитьЗапись(СтруктураЗаписи);
		
		// Устанавливаем расписание синхронизации по умолчанию.
		// Расписание отключаем, т.к. пароль пользователя не задан.
		РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете, Ложь);
		РегламентныеЗаданияСервер.УстановитьРасписаниеРегламентногоЗадания(Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете, РасписаниеСинхронизацииДанныхПоУмолчанию());
		
		// Создаем пользователя ИБ и связываем его с пользователем из справочника пользователей.
		Роли = Новый Массив;
		Роли.Добавить("АдминистраторСистемы");
		Роли.Добавить("ПолныеПрава");
		
		ОписаниеПользователяИБ = Новый Структура;
		ОписаниеПользователяИБ.Вставить("Действие", "Записать");
		ОписаниеПользователяИБ.Вставить("Имя",       Параметры.ИмяВладельца);
		ОписаниеПользователяИБ.Вставить("Роли",      Роли);
		ОписаниеПользователяИБ.Вставить("АутентификацияСтандартная", Истина);
		ОписаниеПользователяИБ.Вставить("ПоказыватьВСпискеВыбора", Истина);
		
		Пользователь = Справочники.Пользователи.ПолучитьСсылку(Новый УникальныйИдентификатор(Параметры.Владелец)).ПолучитьОбъект();
		
		Если Пользователь = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'Идентификация пользователя не выполнена.
				|Возможно, справочник пользователей не включен в состав плана обмена автономной работы.';
				|en = 'User identification failed.
				|The Users catalog might not be included in the exchange plan of the standalone mode.'");
		КонецЕсли;
		
		УстановитьМинимальнуюДлинуПаролейПользователей(0);
		УстановитьПроверкуСложностиПаролейПользователей(Ложь);
		
		Пользователь.Служебный = Ложь;
		Пользователь.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
		Пользователь.ДополнительныеСвойства.Вставить("СозданиеАдминистратора",
			НСтр("ru = 'Начальная настройка автономного рабочего места.';
				|en = 'Initial standalone workplace setup.'"));
		Пользователь.Записать();
		
		ПланыОбмена.УдалитьРегистрациюИзменений(УзелПриложенияВСервисе.Ссылка);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Функция ИзменитьИспользованиеРазделения(Использование, ОбластьДанных = 0)
	
	Если Не Использование Тогда
		ПараметрыСеанса.ОбластьДанныхЗначение      = ОбластьДанных;
		ПараметрыСеанса.ОбластьДанныхИспользование = Использование;
	КонецЕсли;
	
	МенеджерЗначения = Константы.ИспользоватьРазделениеПоОбластямДанных.СоздатьМенеджерЗначения();
	МенеджерЗначения.ОбменДанными.Загрузка = Истина;
	МенеджерЗначения.Значение = Использование;
	МенеджерЗначения.Записать();
	
	Если Использование Тогда
		ПараметрыСеанса.ОбластьДанныхЗначение      = ОбластьДанных;
		ПараметрыСеанса.ОбластьДанныхИспользование = Использование;
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецФункции

// Для внутреннего использования
// 
Процедура ЗагрузитьДанныеНачальногоОбраза()
	
	КаталогИнформационнойБазы = ОбщегоНазначенияКлиентСервер.КаталогФайловойИнформационнойБазы();
	
	ИмяФайлаДанныхНачальногоОбраза = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
		КаталогИнформационнойБазы,
		"data.xml");
	
	ФайлДанныхНачальногоОбраза = Новый Файл(ИмяФайлаДанныхНачальногоОбраза);
	Если Не ФайлДанныхНачальногоОбраза.Существует() Тогда
		Возврат; // Данные начального образа были успешно загружены ранее
	КонецЕсли;
	
	ДанныеНачальногоОбраза = Новый ЧтениеXML;
	ДанныеНачальногоОбраза.ОткрытьФайл(ИмяФайлаДанныхНачальногоОбраза);
	ДанныеНачальногоОбраза.Прочитать();
	ДанныеНачальногоОбраза.Прочитать();
	
	ОбменДаннымиСлужебный.ОтключитьОбновлениеКлючейДоступа(Истина, Ложь);
	
	Попытка
		УстановитьИспользованиеИтоговРегистров(Ложь);
		
		Пока ВозможностьЧтенияXML(ДанныеНачальногоОбраза) Цикл
			
			ЭлементДанных = ПрочитатьXML(ДанныеНачальногоОбраза);
			ЭлементДанных.ДополнительныеСвойства.Вставить("СозданиеНачальногоОбраза");
			
			ЭлементДанных.ОбменДанными.Загрузка = Истина;
			ЭлементДанных.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
			ЭлементДанных.Записать();
			
		КонецЦикла;
		
		УстановитьИспользованиеИтоговРегистров(Истина);
		
		ОбменДаннымиСлужебный.ОтключитьОбновлениеКлючейДоступа(Ложь, Ложь);
		
	Исключение
		
		ОбменДаннымиСлужебный.ОтключитьОбновлениеКлючейДоступа(Ложь, Ложь);
		
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ДанныеНачальногоОбраза = Неопределено;
		ВызватьИсключение;
	КонецПопытки;
	
	ДанныеНачальногоОбраза.Закрыть();
	
	Попытка
		УдалитьФайлы(ИмяФайлаДанныхНачальногоОбраза);
	Исключение
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста(), УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// Для внутреннего использования
// 
Функция ПолучитьПараметрыИзНачальногоОбраза()
	
	СтрокаXML = Константы.НастройкиПодчиненногоУзлаРИБ.Получить();
	
	Если ПустаяСтрока(СтрокаXML) Тогда
		ВызватьИсключение НСтр("ru = 'В автономное рабочее место не были переданы настройки.
									|Работа с автономным рабочим место невозможна.';
									|en = 'Settings were not transferred to a standalone workplace.
									|Cannot work with the standalone workplace.'");
	КонецЕсли;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	
	ЧтениеXML.Прочитать(); // Параметры
	ВерсияФормата = ЧтениеXML.ПолучитьАтрибут("ВерсияФормата");
	
	ЧтениеXML.Прочитать(); // ПараметрыАвтономногоРабочегоМеста
	
	Результат = СчитатьДанныеВСтруктуру(ЧтениеXML);
	
	ЧтениеXML.Закрыть();
	
	Возврат Результат;
КонецФункции

// Для внутреннего использования
// 
Функция СчитатьДанныеВСтруктуру(ЧтениеXML)
	
	// возвращаемое значение функции
	Результат = Новый Структура;
	
	Если ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка чтения XML';
								|en = 'XML reading error'");
	КонецЕсли;
	
	ЧтениеXML.Прочитать();
	
	Пока ЧтениеXML.ТипУзла <> ТипУзлаXML.КонецЭлемента Цикл
		
		Ключ = ЧтениеXML.Имя;
		
		Результат.Вставить(Ключ, ПрочитатьXML(ЧтениеXML));
		
	КонецЦикла;
	
	ЧтениеXML.Прочитать();
	
	Возврат Результат;
КонецФункции

// Для внутреннего использования
// 
Функция СобытиеЖурналаРегистрацииСинхронизацияДанных()
	
	Возврат НСтр("ru = 'Автономная работа.Синхронизация данных';
				|en = 'Standalone mode.Data synchronization'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в другие подсистемы

// Выполняет проверку объекта на вхождение в список исключений
Функция ОбъектМетаданныхЯвляетсяИсключением(Знач ОбъектМетаданных)
	
	// Безопасное хранилище паролей
	Если ОбъектМетаданных = Метаданные.РегистрыСведений.БезопасноеХранилищеДанных Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Справочник ИдентификаторыОбъектовМетаданных является объектом начального узла РИБ.
	// В подчиненных узлах РИБ допустимо обновление многих реквизитов справочника по значениям
	// свойств метаданных в строгом соответствии главному узлу (требуется для нештатных ситуаций).
	// Контроль изменения осуществляется в справочнике в процедуре ПередЗаписью модуля объекта.
	Если ОбъектМетаданных = Метаданные.Справочники.ИдентификаторыОбъектовМетаданных Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат ЭтоОбъектНачальногоОбразаУзлаРИБ(ОбъектМетаданных);
	
КонецФункции

#КонецОбласти