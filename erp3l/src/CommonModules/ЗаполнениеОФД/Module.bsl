
#Область СлужебныйПрограммныйИнтерфейс

// Функция выполняет Истина, если есть алгоритм заполнения документа ОФД по документу ОбъектСсылка
Функция ЕстьАлгоритмЗаполнения(ОбъектСсылка) Экспорт
	
	Если ОбъектСсылка = неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ОбщийМодульАлгоритм = ЗаполнениеОФДПовтИсп.АлгоритмЗаполненияОбъекта(ОбъектСсылка.Метаданные().ПолноеИмя());
	Возврат ОбщийМодульАлгоритм <> неопределено;
	
КонецФункции

// Функция выполняет заполнение документа ОбъектОФД по данным документа ОбъектСсылка
Функция ВыполнитьЗаполнение(ОбъектСсылка, ОбъектОФД, ТолькоHASH = Ложь) Экспорт
	
	Если ОбъектСсылка = неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ОбщийМодульАлгоритм = ЗаполнениеОФДПовтИсп.АлгоритмЗаполненияОбъекта(ОбъектСсылка.Метаданные().ПолноеИмя());
	Если ОбщийМодульАлгоритм = неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДанныеЗаполнения = ОбщийМодульАлгоритм.СобратьДанныеДляЗаполнения(ОбъектСсылка, ОбъектОФД.ДополнительныеСвойства);
	Если ДанныеЗаполнения = неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// HASH
	Если ДанныеЗаполнения.Свойство("КлючевыеРеквизиты") Тогда
		//
		ХЕШ = Новый ХешированиеДанных(ХешФункция.SHA256);
		Данные = ДанныеЗаполнения.Шапка[0];
		Для Каждого Реквизит Из ДанныеЗаполнения.КлючевыеРеквизиты Цикл
			ХЕШ.Добавить(ЗначениеВСтрокуВнутр(Данные[Реквизит]));
		КонецЦикла;
		
		HASH = XMLСтрока(ХЕШ.ХешСумма);
		HASHРассчитан = Истина;
	Иначе
		HASH = "";
		HASHРассчитан = Ложь;
	КонецЕсли;
	
	//
	ЗаполнятьШапку = Ложь;
	ЗаполнятьФакт = Ложь;
	ОбъектОФД.ТребуетсяКорректировка = Ложь;
	
	Если ТолькоHASH Тогда
		ОбъектОФД.HASH = HASH; // Только для случая, когда необходимо посчитать только HASH
		Возврат Истина;
	ИначеЕсли HASHРассчитан = ЛОЖЬ Тогда
		// Документ без HASH. Работаем по старому.
		ЗаполнятьШапку = Истина;
		ЗаполнятьФакт = Истина;
	ИначеЕсли ОбъектОФД.Скорректирован = ЛОЖЬ Тогда
		// Документ не корректировался пользователем и заполняем все.
		ЗаполнятьШапку = Истина;
		ЗаполнятьФакт = Истина;
	ИначеЕсли HASH = ОбъектОФД.HASH Тогда
		// Документ корректировался пользователем и HASH не изменился
		ЗаполнятьШапку = Истина;
	Иначе
		// Документ корректировался пользователем и изменились ключевые реквизиты
		ОбъектОФД.ТребуетсяКорректировка = Истина;
	КонецЕсли;
	
	// Заполним шапку документа ОФД
	Если ДанныеЗаполнения.Свойство("Шапка") И ЗаполнятьШапку Тогда
		ЗаполнитьЗначенияСвойств(ОбъектОФД, ДанныеЗаполнения.Шапка[0]);
		ОбъектОФД.HASH = HASH;
	КонецЕсли;
	
	//
	ТабличныеЧасти = Новый Структура;
	Если ЗаполнятьФакт Тогда
		ТабличныеЧасти.Вставить("Взаиморасчеты", 				ОбъектОФД.Взаиморасчеты);
		ТабличныеЧасти.Вставить("БюджетДвиженияДенежныхСредств",ОбъектОФД.БюджетДвиженияДенежныхСредств);
		ТабличныеЧасти.Вставить("БюджетДоходовИРасходов", 		ОбъектОФД.БюджетДоходовИРасходов);
		ТабличныеЧасти.Вставить("БюджетДвиженияРесурсов", 		ОбъектОФД.БюджетДвиженияРесурсов);
	КонецЕсли;
	
	ТаблицаЗаполнения = неопределено;
	Для Каждого ОписаниеТЧ Из ТабличныеЧасти Цикл
		ОписаниеТЧ.Значение.Очистить();
		Если ДанныеЗаполнения.Свойство(ОписаниеТЧ.Ключ, ТаблицаЗаполнения) Тогда
			Для Каждого Строка Из ТаблицаЗаполнения Цикл
				ЗаполнитьЗначенияСвойств(ОписаниеТЧ.Значение.Добавить(), Строка);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	// Заполнение реквизитов договор, ЦФО, Проект в шапке документа
	ДоговорыДокумента = Новый Массив;
	ЦФОДокумента = Новый Массив;
	ПроектыДокумента = Новый Массив;
	ТабличныеЧасти.Удалить("Взаиморасчеты");
	Для Каждого ОписаниеТЧ Из ТабличныеЧасти Цикл
		Для Каждого Строка Из ОписаниеТЧ.Значение Цикл
			Если ЗначениеЗаполнено(Строка.ДоговорКонтрагента) Тогда
				ДоговорыДокумента.Добавить(Строка.ДоговорКонтрагента);
			КонецЕсли;
			Если ЗначениеЗаполнено(Строка.ЦФО) Тогда
				ЦФОДокумента.Добавить(Строка.ЦФО);
			КонецЕсли;
			Если ЗначениеЗаполнено(Строка.Проект) Тогда
				ПроектыДокумента.Добавить(Строка.Проект);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// Если договор не заполнен, попытаемся его найти
	Если НЕ ЗначениеЗаполнено(ОбъектОФД.ДоговорКонтрагента) Тогда
		ДоговорыДокумента = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ДоговорыДокумента);
		Если ДоговорыДокумента.Количество() = 1 Тогда
			ОбъектОФД.ДоговорКонтрагента = ДоговорыДокумента[0];
		КонецЕсли;
	КонецЕсли;
	
	// Если ЦФО не заполнен, попытаемся его найти
	Если НЕ ЗначениеЗаполнено(ОбъектОФД.ЦФО) Тогда
		ЦФОДокумента = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ЦФОДокумента);
		Если ЦФОДокумента.Количество() = 1 Тогда
			ОбъектОФД.ЦФО = ЦФОДокумента[0];
		КонецЕсли;
	КонецЕсли;
	
	// Если проект не заполнен, попытаемся его найти
	Если НЕ ЗначениеЗаполнено(ОбъектОФД.Проект) Тогда
		ПроектыДокумента = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ПроектыДокумента);
		Если ПроектыДокумента.Количество() = 1 Тогда
			ОбъектОФД.Проект = ПроектыДокумента[0];
		КонецЕсли;
	КонецЕсли;
	
	// ОтражатьВоВзаиморасчетах
	ОбъектОФД.ОтражатьВоВзаиморасчетах = ОбъектОФД.Взаиморасчеты.Количество() > 0;
	
	Возврат Истина;
	
КонецФункции

// Возвращает признак необходимости заполнения ОФД по переданной ссылке на документ
Функция ТребуетсяЗаполнение(ОбъектСсылка) Экспорт
	
	Если ОбъектСсылка = неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ОбщийМодульАлгоритм = ЗаполнениеОФДПовтИсп.АлгоритмЗаполненияОбъекта(ОбъектСсылка.Метаданные().ПолноеИмя());
	Если ОбщийМодульАлгоритм = неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ОбщийМодульАлгоритм.ТребуетсяЗаполнение(ОбъектСсылка);
	
КонецФункции

// Процедура формирует ДокОФД.ДополнительныеСвойства дополнительную информацию, требуемую для работы алгоритмов заполнения
Процедура ПодготовитьДопИнформациюДляОтраженияДокумента(Источник, ДокОФД) Экспорт
	
	Если Источник = неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбщийМодульАлгоритм = ЗаполнениеОФДПовтИсп.АлгоритмЗаполненияОбъекта(Источник.Ссылка.Метаданные().ПолноеИмя());
	Если ОбщийМодульАлгоритм = неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбщийМодульАлгоритм.ПодготовитьДопИнформациюДляОтраженияДокумента(Источник, ДокОФД);
	
КонецПроцедуры

#Область ПодпискиНаСобытия

// Обработка подписки на событие ПодготовкаОтраженияДокументаПоБюджетам
Процедура ПодготовкаОтраженияДокументаПоБюджетамОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт
	
	Если ТипЗнч(Источник) = Тип("ДокументОбъект.ОтражениеФактическихДанныхБюджетирования") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗаполнениеОФД.ЕстьАлгоритмЗаполнения(Источник.Ссылка) Тогда
		Документы.ОтражениеФактическихДанныхБюджетирования.ОтразитьФактическоеДвижениеПоБюджетамПоПредопределенномуПравилу(Источник, Отказ);
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		ВстраиваниеОПКПереопределяемый.ОбработатьНастраиваемыеПравила(Источник, Отказ);
	КонецЕсли;
	
КонецПроцедуры

// Обработка подписки на событие ОтменитьОтражениеДокументаПоБюджетам
Процедура ОтменитьОтражениеДокументаПоБюджетамОбработкаУдаленияПроведения(Источник, Отказ) Экспорт
	ВстраиваниеОПКПереопределяемый.ОбработатьНастраиваемыеПравилаПриОтменеПроведения(Источник, Отказ);
КонецПроцедуры

// Обработка подписки на событие ДокументыДляОтраженияПоБюджетамПередЗаписью
Процедура ДокументыДляОтраженияПоБюджетамПередЗаписью(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Источник.Ссылка) Тогда
		Возврат; // Записан новый документ
	КонецЕсли;
	
	Если ЗаполнениеОФД.ЕстьАлгоритмЗаполнения(Источник.Ссылка) Тогда
		ПометкаСсылки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "ПометкаУдаления");
		Источник.ДополнительныеСвойства.Вставить("ИзмениласьПометкаУдаления", 
			Источник.ПометкаУдаления <> ПометкаСсылки);
	КонецЕсли;
	
КонецПроцедуры

// Обработка подписки на событие ДокументыДляОтраженияПоБюджетамПриЗаписи
Процедура ДокументыДляОтраженияПоБюджетамПриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Источник.ДополнительныеСвойства.Свойство("ИзмениласьПометкаУдаления") 
			ИЛИ Источник.ДополнительныеСвойства.ИзмениласьПометкаУдаления = ЛОЖЬ Тогда
		Возврат;
	КонецЕсли;
	
	СуществующиеОФД = ВсеОФДИсточника(Источник.Ссылка);
	Если Источник.ПометкаУдаления = Истина Тогда
		// Установлена пометка удаления
		УстановитьПометкуУдаленияУВсехНепомеченныхДокументовОФД(СуществующиеОФД);
	Иначе
		// Снята пометка удаления
		СнятьПометкуУдаленияСПоследнегоНепроведенногоДокумента(СуществующиеОФД);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает массив документов Отражение фактических данных по его источнику Источник.
Функция ВсеОФДИсточника(ИсточникСсылка)
	
	УстановитьПривилегированныйРежим(Истина); // По причине обработки любых ссылок.
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИсходныйДокумент", ИсточникСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОтражениеФактическихДанныхБюджетирования.Ссылка КАК ОФД,
	|	ОтражениеФактическихДанныхБюджетирования.ПометкаУдаления КАК ПометкаУдаления,
	|	ОтражениеФактическихДанныхБюджетирования.МоментВремени КАК МоментВремени
	|ИЗ
	|	Документ.ОтражениеФактическихДанныхБюджетирования КАК ОтражениеФактическихДанныхБюджетирования
	|ГДЕ
	|	ОтражениеФактическихДанныхБюджетирования.ИсходныйДокумент = &ИсходныйДокумент
	|
	|УПОРЯДОЧИТЬ ПО
	|	МоментВремени";
	Результат = Запрос.Выполнить();
	Возврат Результат.Выгрузить();
	
КонецФункции

Процедура УстановитьПометкуУдаленияУВсехНепомеченныхДокументовОФД(СуществующиеОФД)
	
	СтруктураПоиска = Новый Структура("ПометкаУдаления", Ложь);
	ОФДКОбработке = СуществующиеОФД.НайтиСтроки(СтруктураПоиска);
	Если ОФДКОбработке.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из ОФДКОбработке Цикл
		УстановитьПометкуУдаленияОФД(Строка.ОФД, Истина)
	КонецЦикла;
	
КонецПроцедуры

Процедура СнятьПометкуУдаленияСПоследнегоНепроведенногоДокумента(СуществующиеОФД)
	
	Если СуществующиеОФД.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОФДКОбработке = СуществующиеОФД[СуществующиеОФД.Количество()-1];
	Если ОФДКОбработке.ПометкаУдаления = Истина Тогда
		УстановитьПометкуУдаленияОФД(ОФДКОбработке.ОФД, Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьПометкуУдаленияОФД(ОФД, ПометкаУдаления)
	
	Если НЕ ЗначениеЗаполнено(ОФД) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ОФД) <> Тип("ДокументСсылка.ОтражениеФактическихДанныхБюджетирования") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		ОФД.ПолучитьОбъект().УстановитьПометкуУдаления(ПометкаУдаления);
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Синхронизация пометки удаления документа-источника и документа ОФД'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
 