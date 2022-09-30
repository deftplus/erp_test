#Если Сервер ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства)
		Или ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Текущее состояние остатков помещается во временную таблицу,
	// чтобы при записи получить изменение актуальных остатков регистра.
	
	ТекстыЗапросовДляПолученияТаблицыИзменений = 
		ЗакрытиеМесяцаСервер.ТекстыЗапросовДляПолученияТаблицыИзмененийРегистра(Метаданные(), Отбор);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстыЗапросовДляПолученияТаблицыИзменений.ТекстВыборкиНачальныхДанных;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
	
	ДополнительныеСвойства.Вставить("ТекстВыборкиТаблицыИзменений", ТекстыЗапросовДляПолученияТаблицыИзменений.ТекстВыборкиТаблицыИзменений);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
	// Проверка ОбменДанными.Загрузка не требуется, т.к. данный объект в РИБ при записи должен создавать задания.
	Если Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства)
		Или ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивТекстовЗапроса = Новый Массив;
	МассивТекстовЗапроса.Добавить(ДополнительныеСвойства.ТекстВыборкиТаблицыИзменений);
	
	ТекстЗаданияКФормированиюДвиженийПоНДС =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(ТаблицаИзменений.Период, МЕСЯЦ) КАК Месяц,
	|	ТаблицаИзменений.Организация КАК Организация,
	|	ТаблицаИзменений.ДокументОплаты КАК СчетФактура
	|ПОМЕСТИТЬ ИмяВТ
	|ИЗ
	|	ТаблицаИзмененийНДСАвансыПолученные КАК ТаблицаИзменений
	|";
	ИмяВТ = Метаданные().Имя + "_ЗаданияКФормированиюДвиженийПоНДС";
	ТекстЗаданияКФормированиюДвиженийПоНДС = СтрЗаменить(ТекстЗаданияКФормированиюДвиженийПоНДС, "ИмяВТ", ИмяВТ);
	
	МассивТекстовЗапроса.Добавить(ТекстЗаданияКФормированиюДвиженийПоНДС);
	
	Запрос = Новый Запрос;
	Запрос.Текст = СтрСоединить(МассивТекстовЗапроса, ОбщегоНазначения.РазделительПакетаЗапросов());
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Результат = Запрос.ВыполнитьПакет();
	Выборка = Результат[Результат.Количество() - 1].Выбрать();
	
	ПроведениеДокументов.ЗарегистрироватьТаблицуКонтроля(
		ДополнительныеСвойства,
		ИмяВТ,
		Выборка.Следующий() И Выборка.Количество > 0);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли