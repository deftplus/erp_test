////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

//
Функция ПросроченнаяЗадолженностьПоПараметрам(ДанныеПараметровЗапроса) Экспорт
	
	ТекстЗапроса = ТекстЗапросаДебиторскаяЗадолженность()
		+ ОбщегоНазначенияУХ.ТекстРазделителяЗапросовПакета()
		+ ТекстЗапросаПросроченнаяДебиторскаяЗадолженностьЗавершение();
	
	Схема = Новый СхемаЗапроса;
	Схема.УстановитьТекстЗапроса(ТекстЗапроса);
	
	// Установка параметров отбора в основном запросе ДебиторскойЗадолженности
	ТекстУсловия = СформироватьТекстОтбора(ДанныеПараметровЗапроса);
	
	Источник1 = Схема.ПакетЗапросов[0].Операторы[0].Источники[0].Источник;
	Источник2 = Схема.ПакетЗапросов[0].Операторы[1].Источники[0].Источник;
	
	Источник1.Параметры[1].Выражение = Новый ВыражениеСхемыЗапроса(ТекстУсловия);
	Источник2.Параметры[1].Выражение = Новый ВыражениеСхемыЗапроса(ТекстУсловия);
	
	Возврат Схема.ПолучитьТекстЗапроса();
	
КонецФункции

Функция ПросроченнаяЗадолженностьСИтогами() Экспорт
	
	ТекстЗапроса = ТекстЗапросаДебиторскаяЗадолженность()
		+ ОбщегоНазначенияУХ.ТекстРазделителяЗапросовПакета()
		+ ТекстЗапросаПросроченнаяДебиторскаяЗадолженностьЗавершение();
	
	Схема = Новый СхемаЗапроса;
	Схема.УстановитьТекстЗапроса(ТекстЗапроса);
	
	СхемаЗапроса = Схема.ПакетЗапросов[2];
	СхемаЗапроса.ОбщиеИтоги = Ложь;
	СхемаЗапроса.КонтрольныеТочкиИтогов.Добавить("Организация");
	СхемаЗапроса.КонтрольныеТочкиИтогов.Добавить("ОжидаемаяДата");
	СхемаЗапроса.КонтрольныеТочкиИтогов.Добавить("Контрагент");
	
	СхемаЗапроса.ВыраженияИтогов.Добавить("Сумма");
	СхемаЗапроса.ВыраженияИтогов.Добавить("Пени");
	
	Возврат Схема.ПолучитьТекстЗапроса();
	
КонецФункции

Функция ПросроченнаяЗадолженностьПоРасчетномуДокументу(ДанныеПараметровЗапроса) Экспорт
	
	ТекстЗапроса = ТекстЗапросаДебиторскаяЗадолженность()
		+ ОбщегоНазначенияУХ.ТекстРазделителяЗапросовПакета()
		+ ТекстЗапросаПросроченнаяДебиторскаяЗадолженностьЗавершение();
	
	Схема = Новый СхемаЗапроса;
	Схема.УстановитьТекстЗапроса(ТекстЗапроса);
	
	// Установка параметров отбора в основном запросе ДебиторскойЗадолженности
	ТекстУсловия = СформироватьТекстОтбора(ДанныеПараметровЗапроса);
	
	Источник1 = Схема.ПакетЗапросов[0].Операторы[0].Источники[0].Источник;
	Источник2 = Схема.ПакетЗапросов[0].Операторы[1].Источники[0].Источник;
	
	Источник1.Параметры[1].Выражение = Новый ВыражениеСхемыЗапроса(ТекстУсловия);
	Источник2.Параметры[1].Выражение = Новый ВыражениеСхемыЗапроса(ТекстУсловия);
	
	
	Схема.ПакетЗапросов[1].Операторы[0].Отбор.Удалить(0);
	
	Возврат Схема.ПолучитьТекстЗапроса();
	
КонецФункции

Функция ПросроченнаяЗадолженность() Экспорт
	
	ТекстЗапроса = ТекстЗапросаДебиторскаяЗадолженность()
		+ ОбщегоНазначенияУХ.ТекстРазделителяЗапросовПакета()
		+ ТекстЗапросаПросроченнаяДебиторскаяЗадолженностьЗавершение();
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Функция возвращает текст запроса для формы выбора документов дебиторской задолженности
Функция ТекстЗапросаДебиторскаяЗадолженностьФормаПодбора(Параметры) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Организация",				неопределено);
	Результат.Вставить("НаДату",					неопределено);
	
	Если НЕ ТипЗнч(Параметры) <> Тип("Структура") 
		  И НЕ ТипЗнч(Параметры) <> Тип("ДанныеФормыЭлементКоллекции") Тогда
		Возврат Результат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Результат, Параметры);
	Если НЕ ЗначениеЗаполнено(Результат.Организация) Тогда
		ВызватьИсключение НСтр("ru = 'Отсутствует обязательный отбор по полю Организация'");
	КонецЕсли;
	
	//
	ТекстЗапроса = ТекстЗапросаДебиторскаяЗадолженность() 
		+ ОбщегоНазначенияУХ.ТекстРазделителяЗапросовПакета()
		+ ТекстЗапросаДебиторскаяЗадолженностьНеВключеннаяВРеестрЗавершение();
		
	Схема = Новый СхемаЗапроса;
	Схема.УстановитьТекстЗапроса(ТекстЗапроса);
	
	// Источники
	Источник1 = Схема.ПакетЗапросов[0].Операторы[0].Источники[0].Источник;
	Источник2 = Схема.ПакетЗапросов[0].Операторы[1].Источники[0].Источник;
	
	// Отборы в 
	ТекстУсловия = СформироватьТекстОтбора(Результат);
	Если ЗначениеЗаполнено(ТекстУсловия) Тогда
		// Отбор в виртуальной таблице Остатки
		Источник1.Параметры[1].Выражение = Новый ВыражениеСхемыЗапроса(ТекстУсловия);
		Источник2.Параметры[1].Выражение = Новый ВыражениеСхемыЗапроса(ТекстУсловия);
	КонецЕсли;
		
	// получать задолженность на дату
	Если Параметры.Свойство("НаДату") ИЛИ ЗначениеЗаполнено(Параметры.НаДату) Тогда
		// Дата получения остатков в виртуальнойТаблице Остатки
		Источник1.Параметры[0].Выражение = Новый ВыражениеСхемыЗапроса("&НаДату");
		Источник2.Параметры[0].Выражение = Новый ВыражениеСхемыЗапроса("&НаДату");
	КонецЕсли;
	
	Возврат Схема.ПолучитьТекстЗапроса();
	
КонецФункции
	
// Функция возвращает структуру с информацией о дебиторской задолженности
Функция ДебиторскаяЗадолженностьПоПараметрам(Параметры) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("СуммаОбязательства",0);
	Результат.Вставить("Валюта",					неопределено);
	Результат.Вставить("ДатаПлановогоПогашения",	неопределено);
	Результат.Вставить("ДатаВозникновения",			неопределено);
	Результат.Вставить("Организация",				неопределено);
	Результат.Вставить("Контрагент",				неопределено);
	Результат.Вставить("Договор",					неопределено);
	Результат.Вставить("ОбъектРасчетов",			неопределено);
	Результат.Вставить("РасчетныйДокумент",			неопределено);
	Результат.Вставить("НаДату",					неопределено);
	
	Если НЕ ТипЗнч(Параметры) <> Тип("Структура") 
		  И НЕ ТипЗнч(Параметры) <> Тип("ДанныеФормыЭлементКоллекции") Тогда
		Возврат Результат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Результат, Параметры);
	Если НЕ ЗначениеЗаполнено(Результат.Организация)
			ИЛИ НЕ ЗначениеЗаполнено(Результат.Контрагент)
			ИЛИ НЕ ЗначениеЗаполнено(Результат.Договор)
			ИЛИ НЕ ЗначениеЗаполнено(Результат.ОбъектРасчетов)
			ИЛИ НЕ ЗначениеЗаполнено(Результат.РасчетныйДокумент) Тогда
		Возврат Результат;
	КонецЕсли;
	
	//
	Запрос = Новый Запрос;
	Для Каждого КлючЗначение Из Результат Цикл
		Запрос.УстановитьПараметр(КлючЗначение.Ключ, КлючЗначение.Значение);
	КонецЦикла;
	Запрос.Текст = ТекстЗапросаДебиторскаяЗадолженностьПоПараметрам(Результат);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция возвращает данные для оповещения о приближении срока оплаты
Функция ДанныеДляОповещенияОПриближенииСрокаОплаты() Экспорт
	
	//
	ТекстЗапроса = ТекстЗапросаДебиторскаяЗадолженность() 
		+ ОбщегоНазначенияУХ.ТекстРазделителяЗапросовПакета()
		+ ТекстЗапросаДебиторскаяЗадолженностьДляОповещенияЗавершение();
	
	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//
Функция СформироватьТекстОтбора(Параметры)
	
	ПараметрыЗапроса = Новый Соответствие;
	ПараметрыЗапроса.Вставить("Организация", "АналитикаУчетаПоПартнерам.Организация");
	ПараметрыЗапроса.Вставить("Контрагент", "АналитикаУчетаПоПартнерам.Контрагент");
	ПараметрыЗапроса.Вставить("Договор", "АналитикаУчетаПоПартнерам.Договор");
	ПараметрыЗапроса.Вставить("ОбъектРасчетов", "ОбъектРасчетов");
	ПараметрыЗапроса.Вставить("РасчетныйДокумент", "РасчетныйДокумент");
	
	МассивУсловий = Новый Массив;
	Для Каждого КлючЗначение Из ПараметрыЗапроса Цикл
		
		Если НЕ Параметры.Свойство(КлючЗначение.Ключ) Тогда
			Продолжить;
		КонецЕсли;
		
		МассивУсловий.Добавить(КлючЗначение.Значение + " = &" + КлючЗначение.Ключ);
		
	КонецЦикла;
	
	Возврат СтрСоединить(МассивУсловий, " И ");
	
КонецФункции

#Область ТекстыЗапросов
	
// Функция возвращает текст запроса получения дебиторской задолженности
Функция ТекстЗапросаДебиторскаяЗадолженность()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	РасчетыСКлиентамиПоСрокамОстатки.АналитикаУчетаПоПартнерам.Организация КАК Организация,
	|	РасчетыСКлиентамиПоСрокамОстатки.АналитикаУчетаПоПартнерам.Контрагент КАК Контрагент,
	|	РасчетыСКлиентамиПоСрокамОстатки.АналитикаУчетаПоПартнерам.Договор КАК Договор,
	|	РасчетыСКлиентамиПоСрокамОстатки.ОбъектРасчетов КАК ОбъектРасчетов,
	|	РасчетыСКлиентамиПоСрокамОстатки.РасчетныйДокумент КАК РасчетныйДокумент,
	|	РасчетыСКлиентамиПоСрокамОстатки.Валюта КАК Валюта,
	|	РасчетыСКлиентамиПоСрокамОстатки.ДатаВозникновения КАК ДатаВозникновения,
	|	РасчетыСКлиентамиПоСрокамОстатки.ДатаПлановогоПогашения КАК ДатаПлановогоПогашения,
	|	РасчетыСКлиентамиПоСрокамОстатки.ДолгОстаток КАК СуммаОбязательства
	|ПОМЕСТИТЬ ВТ_ДебиторскаяЗадолженность
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоСрокам.Остатки КАК РасчетыСКлиентамиПоСрокамОстатки
	|ГДЕ
	|	РасчетыСКлиентамиПоСрокамОстатки.ДолгОстаток > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РасчетыСПоставщикамиПоСрокамОстатки.АналитикаУчетаПоПартнерам.Организация,
	|	РасчетыСПоставщикамиПоСрокамОстатки.АналитикаУчетаПоПартнерам.Контрагент,
	|	РасчетыСПоставщикамиПоСрокамОстатки.АналитикаУчетаПоПартнерам.Договор,
	|	РасчетыСПоставщикамиПоСрокамОстатки.ОбъектРасчетов,
	|	РасчетыСПоставщикамиПоСрокамОстатки.РасчетныйДокумент,
	|	РасчетыСПоставщикамиПоСрокамОстатки.Валюта,
	|	РасчетыСПоставщикамиПоСрокамОстатки.ДатаВозникновения,
	|	РасчетыСПоставщикамиПоСрокамОстатки.ДатаПлановогоПогашения,
	|	РасчетыСПоставщикамиПоСрокамОстатки.ПредоплатаОстаток
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщикамиПоСрокам.Остатки КАК РасчетыСПоставщикамиПоСрокамОстатки
	|ГДЕ
	|	РасчетыСПоставщикамиПоСрокамОстатки.ПредоплатаОстаток > 0";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Форма выбора дебиторской задолженности: дебиторская задолженность не включенная в реестр уступленных требований
Функция ТекстЗапросаДебиторскаяЗадолженностьНеВключеннаяВРеестрЗавершение()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВТ_ДебиторскаяЗадолженность.Организация КАК Организация,
	|	ВТ_ДебиторскаяЗадолженность.Контрагент КАК Контрагент,
	|	ВТ_ДебиторскаяЗадолженность.Договор КАК Договор,
	|	ВТ_ДебиторскаяЗадолженность.ОбъектРасчетов КАК ОбъектРасчетов,
	|	ВТ_ДебиторскаяЗадолженность.РасчетныйДокумент КАК РасчетныйДокумент,
	|	ВТ_ДебиторскаяЗадолженность.Валюта КАК Валюта,
	|	ВТ_ДебиторскаяЗадолженность.СуммаОбязательства КАК СуммаВзаиморасчетов,
	|	ВТ_ДебиторскаяЗадолженность.ДатаПлановогоПогашения КАК ДатаПлановогоПогашения
	|ИЗ
	|	ВТ_ДебиторскаяЗадолженность КАК ВТ_ДебиторскаяЗадолженность
	|ГДЕ
	|	НЕ (ВТ_ДебиторскаяЗадолженность.Организация, ВТ_ДебиторскаяЗадолженность.Контрагент, ВТ_ДебиторскаяЗадолженность.Договор, ВТ_ДебиторскаяЗадолженность.ОбъектРасчетов, ВТ_ДебиторскаяЗадолженность.РасчетныйДокумент) В
	|				(ВЫБРАТЬ
	|					РеестрУступленныхДенежныхТребованийУступленныеТребования.Ссылка.Организация КАК Организация,
	|					РеестрУступленныхДенежныхТребованийУступленныеТребования.Контрагент КАК Контрагент,
	|					РеестрУступленныхДенежныхТребованийУступленныеТребования.Договор КАК Договор,
	|					РеестрУступленныхДенежныхТребованийУступленныеТребования.ОбъектРасчетов КАК ОбъектРасчетов,
	|					РеестрУступленныхДенежныхТребованийУступленныеТребования.РасчетныйДокумент КАК РасчетныйДокумент
	|				ИЗ
	|					Документ.РеестрУступленныхДенежныхТребований.УступленныеТребования КАК РеестрУступленныхДенежныхТребованийУступленныеТребования
	|				ГДЕ
	|					РеестрУступленныхДенежныхТребованийУступленныеТребования.Ссылка.Проведен = ИСТИНА
	|					И РеестрУступленныхДенежныхТребованийУступленныеТребования.Ссылка.Организация = &Организация)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаДебиторскаяЗадолженностьДляОповещенияЗавершение()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВТ_ДебиторскаяЗадолженность.Организация КАК Организация,
	|	ВТ_ДебиторскаяЗадолженность.Контрагент КАК Контрагент,
	|	ВТ_ДебиторскаяЗадолженность.Договор КАК ДоговорКонтрагента,
	|	ВТ_ДебиторскаяЗадолженность.ОбъектРасчетов КАК ОбъектРасчетов,
	|	ВТ_ДебиторскаяЗадолженность.РасчетныйДокумент КАК РасчетныйДокумент,
	|	ВТ_ДебиторскаяЗадолженность.Валюта КАК Валюта,
	|	ВТ_ДебиторскаяЗадолженность.СуммаОбязательства КАК Сумма,
	|	ВТ_ДебиторскаяЗадолженность.ДатаПлановогоПогашения КАК ДатаПлановогоПогашения,
	|	ПРЕДСТАВЛЕНИЕ(ВТ_ДебиторскаяЗадолженность.РасчетныйДокумент) КАК ОбъектРасчетовПредставление,
	|	ВТ_ДебиторскаяЗадолженность.Договор.Ответственный КАК Ответственный
	|ИЗ
	|	ВТ_ДебиторскаяЗадолженность КАК ВТ_ДебиторскаяЗадолженность,
	|	Константа.ФормироватьОповещенияОПриближенииДатыПлатежаЗаКоличествоДней КАК ФормироватьОповещенияОПриближенииДатыПлатежаЗаКоличествоДней
	|ГДЕ
	|	ВТ_ДебиторскаяЗадолженность.ДатаПлановогоПогашения > ДАТАВРЕМЯ(1, 1, 1)
	|	И ВТ_ДебиторскаяЗадолженность.ДатаПлановогоПогашения = ДОБАВИТЬКДАТЕ(&ТекущаяДата, ДЕНЬ, ФормироватьОповещенияОПриближенииДатыПлатежаЗаКоличествоДней.Значение)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаПросроченнаяДебиторскаяЗадолженностьЗавершение()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВТ_ДебиторскаяЗадолженность.Организация КАК Организация,
	|	ВТ_ДебиторскаяЗадолженность.Контрагент КАК Контрагент,
	|	ВТ_ДебиторскаяЗадолженность.Договор КАК Договор,
	|	ВТ_ДебиторскаяЗадолженность.ОбъектРасчетов КАК ОбъектРасчетов,
	|	ВТ_ДебиторскаяЗадолженность.Валюта КАК Валюта,
	|	ВТ_ДебиторскаяЗадолженность.РасчетныйДокумент КАК РасчетныйДокумент,
	|	ВТ_ДебиторскаяЗадолженность.ДатаВозникновения КАК ДатаВозникновения,
	|	ВТ_ДебиторскаяЗадолженность.ДатаПлановогоПогашения КАК ДатаПлановогоПогашения,
	|	ДОБАВИТЬКДАТЕ(ВТ_ДебиторскаяЗадолженность.ДатаПлановогоПогашения, ДЕНЬ, ДнейПросрочки.Значение) КАК ДатаПлановойПросрочки,
	|	ВТ_ДебиторскаяЗадолженность.СуммаОбязательства КАК СуммаОбязательства,
	|	ВЫРАЗИТЬ(ВТ_ДебиторскаяЗадолженность.Договор КАК Справочник.ДоговорыКонтрагентов).СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	ВЫРАЗИТЬ(ВТ_ДебиторскаяЗадолженность.Договор КАК Справочник.ДоговорыКонтрагентов).ПериодРасчетаПени КАК ПериодРасчетаПени,
	|	ВЫРАЗИТЬ(ВТ_ДебиторскаяЗадолженность.Договор КАК Справочник.ДоговорыКонтрагентов).СтавкаПени КАК СтавкаПени,
	|	ВЫРАЗИТЬ(ВТ_ДебиторскаяЗадолженность.Договор КАК Справочник.ДоговорыКонтрагентов).Ответственный КАК Ответственный
	|ПОМЕСТИТЬ ВТ_Данные
	|ИЗ
	|	ВТ_ДебиторскаяЗадолженность КАК ВТ_ДебиторскаяЗадолженность,
	|	Константа.КоличествоДнейПросрочкиПоПлатежамДляФормированияПретензий КАК ДнейПросрочки
	|ГДЕ
	|	ДОБАВИТЬКДАТЕ(ВТ_ДебиторскаяЗадолженность.ДатаПлановогоПогашения, ДЕНЬ, ДнейПросрочки.Значение) < &ДатаДляГенерации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Данные.Организация КАК Организация,
	|	ВТ_Данные.Контрагент КАК Контрагент,
	|	ВТ_Данные.Договор КАК Договор,
	|	ВТ_Данные.ОбъектРасчетов КАК ОбъектРасчетов,
	|	ВТ_Данные.РасчетныйДокумент КАК РасчетныйДокумент,
	|	ВТ_Данные.Валюта КАК Валюта,
	|	ВТ_Данные.ДатаВозникновения КАК ДатаВозникновения,
	|	ВТ_Данные.ДатаПлановогоПогашения КАК ДатаПлановогоПогашения,
	|	ВТ_Данные.ДатаПлановогоПогашения КАК ОжидаемаяДата,
	|	ВТ_Данные.ДатаПлановойПросрочки КАК ДатаПлановойПросрочки,
	|	ВТ_Данные.СуммаОбязательства КАК Сумма,
	|	ВТ_Данные.Ответственный КАК Ответственный,
	|	ВТ_Данные.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	РАЗНОСТЬДАТ(ВТ_Данные.ДатаПлановогоПогашения, &ДатаДляГенерации, ДЕНЬ) КАК ДнейПросрочки,
	|	ВЫРАЗИТЬ(ВТ_Данные.СуммаОбязательства * РАЗНОСТЬДАТ(ВТ_Данные.ДатаПлановогоПогашения, &ДатаДляГенерации, ДЕНЬ) * ВЫБОР
	|			КОГДА ВТ_Данные.ПериодРасчетаПени = ЗНАЧЕНИЕ(Перечисление.Периодичность.День)
	|				ТОГДА ВТ_Данные.СтавкаПени / 100
	|			КОГДА ВТ_Данные.ПериодРасчетаПени = ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|				ТОГДА ВТ_Данные.СтавкаПени / 100 / 30
	|			КОГДА ВТ_Данные.ПериодРасчетаПени = ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|				ТОГДА ВТ_Данные.СтавкаПени / 100 / 360
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК ЧИСЛО(18, 2)) КАК Пени
	|ИЗ
	|	ВТ_Данные КАК ВТ_Данные
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИзменениеПретензии.РасшифровкаПредметаСпора КАК Претензия
	|		ПО (Претензия.Ссылка.ПометкаУдаления = ЛОЖЬ)
	|			И ВТ_Данные.Организация = Претензия.Ссылка.Организация
	|			И ВТ_Данные.Контрагент = Претензия.Ссылка.Контрагент
	|			И ВТ_Данные.Договор = Претензия.Ссылка.Договор
	|			И ВТ_Данные.ОбъектРасчетов = Претензия.ОбъектРасчетов
	|			И ВТ_Данные.РасчетныйДокумент = Претензия.РасчетныйДокумент
	|ГДЕ
	|	Претензия.Ссылка ЕСТЬ NULL";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти 

// Процедура возвращает структуру с данными взаиморасчетов по совокупности измерений взаиморасчетов:
//		Организация
//		Контрагент
//		Договор
//		ОбъектРасчетов
//		РасчетныйДокумент
//		НаДату
// Расчтываются следующие свойства
//		ДатаВозникновения
//		ДатаПлановогоПогашения
//		Валюта
//		СуммаОбязательства
//	
Функция ТекстЗапросаДебиторскаяЗадолженностьПоПараметрам(Параметры)
	
	Схема = Новый СхемаЗапроса;
	Схема.УстановитьТекстЗапроса(ТекстЗапросаДебиторскаяЗадолженность());
	
	// Помещать во временную таблицу
	Схема.ПакетЗапросов[0].ТаблицаДляПомещения = "";
	
	// Источники
	Источник1 = Схема.ПакетЗапросов[0].Операторы[0].Источники[0].Источник;
	Источник2 = Схема.ПакетЗапросов[0].Операторы[1].Источники[0].Источник;
	
	// Отборы в 
	ТекстУсловия = СформироватьТекстОтбора(Параметры);
	Если ЗначениеЗаполнено(ТекстУсловия) Тогда
		// Отбор в виртуальной таблице Остатки
		Источник1.Параметры[1].Выражение = Новый ВыражениеСхемыЗапроса(ТекстУсловия);
		Источник2.Параметры[1].Выражение = Новый ВыражениеСхемыЗапроса(ТекстУсловия);
	КонецЕсли;
		
	// получать задолженность на дату
	Если Параметры.Свойство("НаДату") ИЛИ ЗначениеЗаполнено(Параметры.НаДату) Тогда
		// Дата получения остатков в виртуальнойТаблице Остатки
		Источник1.Параметры[0].Выражение = Новый ВыражениеСхемыЗапроса("&НаДату");
		Источник2.Параметры[0].Выражение = Новый ВыражениеСхемыЗапроса("&НаДату");
	КонецЕсли;
	
	Возврат Схема.ПолучитьТекстЗапроса();
	
КонецФункции

#КонецОбласти

