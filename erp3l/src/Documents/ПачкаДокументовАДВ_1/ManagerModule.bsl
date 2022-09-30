#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(Сотрудники.Сотрудник, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ПачкаДокументовАДВ_1;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыИФункцииДляПроверкиПерсональныхДанныхФизическихЛиц

Функция ВыгрузитьФайлыВоВременноеХранилище(Ссылка, УникальныйИдентификатор = Неопределено) Экспорт 
	
	ДанныеФайла = ЗарплатаКадры.ПолучитьДанныеФайла(Ссылка, УникальныйИдентификатор);
	
	ОписаниеВыгруженногоФайла = ПерсонифицированныйУчет.ОписаниеВыгруженногоФайлаОтчетности();
	
	ОписаниеВыгруженногоФайла.Владелец = Ссылка;
	ОписаниеВыгруженногоФайла.АдресВоВременномХранилище = ДанныеФайла.СсылкаНаДвоичныеДанныеФайла;
	ОписаниеВыгруженногоФайла.ИмяФайла = ДанныеФайла.ИмяФайла;
	ОписаниеВыгруженногоФайла.ПроверятьCheckXML = Истина;
	ОписаниеВыгруженногоФайла.ПроверятьCheckUFA = Истина;
	ОписаниеВыгруженногоФайла.ПроверятьПОПД = Истина;
	
	ВыгруженныеФайлы = Новый Массив;
	ВыгруженныеФайлы.Добавить(ОписаниеВыгруженногоФайла);
	
	Возврат ВыгруженныеФайлы;
	
КонецФункции

Функция ПолучитьСтруктуруПроверяемыхДанных() Экспорт
	
	СтруктураПроверяемыхДанных = ПерсонифицированныйУчет.ПолучитьСтруктуруПроверяемыхДанных();
	ПерсонифицированныйУчет.ДокументыАДВДополнитьСтруктуруПроверяемыхДанных(СтруктураПроверяемыхДанных);
	
	Возврат СтруктураПроверяемыхДанных;
	
КонецФункции

Функция ПолучитьПредставленияПроверяемыхРеквизитов() Экспорт
	Возврат ПерсонифицированныйУчет.ПолучитьПредставленияПроверяемыхРеквизитов();
КонецФункции

Функция ПолучитьСоответствиеРеквизитовФормеОбъекта(ДанныеДляПроверки) Экспорт
	
	СоответствиеРеквизитовПутиВФорме = ПерсонифицированныйУчет.ПолучитьСоответствиеРеквизитовФормеОбъекта();
	ПерсонифицированныйУчет.ДокументыАДВДополнитьСоответствиеРеквизитовФормеОбъекта(СоответствиеРеквизитовПутиВФорме);
	
	Возврат СоответствиеРеквизитовПутиВФорме;
	
КонецФункции

Функция ПолучитьСоответствиеРеквизитовПутиВФормеОбъекта() Экспорт
	
	СоответствиеРеквизитовПутиВФормеОбъекта = ПерсонифицированныйУчет.ПолучитьСоответствиеРеквизитовПутиВФормеОбъекта();
	ПерсонифицированныйУчет.ДокументыАДВДополнитьСоответствиеРеквизитовПутиВФормеОбъекта(СоответствиеРеквизитовПутиВФормеОбъекта);
	
	Возврат СоответствиеРеквизитовПутиВФормеОбъекта;
	
КонецФункции

Функция ПолучитьСоответствиеПроверяемыхРеквизитовОткрываемымОбъектам(ДокументСсылка, ДанныеДляПроверки) Экспорт
	Возврат Новый Структура;
КонецФункции

#КонецОбласти

#Область ПроцедурыПолученияДанныхДляЗаполненияИПроведенияДокумента

// Возвращает таблицу значений, содержащую данные для заполнения
// в табличную часть "Сотрудники" документа "ПачкаДокументовАДВ_1".
//
// Параметры:
//	Ссылка
//	Организация
//	Дата
//
// Возвращаемое значение:
//	Таблица значений с колонками
//		ФизическоеЛицо
//      АдресРегистрации
//		АдресФактический.
//      Телефоны
//      Фамилия
//      Имя
//      Отчество
//      Пол
//      ДатаРождения
//      МестоРождения
//      Гражданство
//      ВидДокумента
//      СерияДокумента
//      НомерДокумента
//      ДатаВыдачи
//      КемВыдан
//
Функция ПолучитьДанныеСотрудниковБезСтраховыхНомеровПФР(Ссылка, Организация, Дата) Экспорт
	
	СписокПустыхНомеровПФР = Новый СписокЗначений;
	СписокПустыхНомеровПФР.Добавить("");
	СписокПустыхНомеровПФР.Добавить("   -   -      ");
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Организация",			Организация);
	Запрос.УстановитьПараметр("Ссылка",					Ссылка);
	Запрос.УстановитьПараметр("СписокПустыхНомеровПФР",	СписокПустыхНомеровПФР);
	
	КадровыйУчет.СоздатьВТФизическиеЛицаРаботавшиеВОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, Организация, Дата, Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФизическиеЛица.Ссылка КАК ФизическоеЛицо
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			АнкетаЗастрахованногоЛицаСотрудники.Сотрудник КАК ФизЛицо
	|		ИЗ
	|			Документ.ПачкаДокументовАДВ_1.Сотрудники КАК АнкетаЗастрахованногоЛицаСотрудники
	|		ГДЕ
	|			АнкетаЗастрахованногоЛицаСотрудники.Ссылка <> &Ссылка
	|			И АнкетаЗастрахованногоЛицаСотрудники.Ссылка.Проведен
	|			И АнкетаЗастрахованногоЛицаСотрудники.Ссылка.Организация = &Организация
	|			И АнкетаЗастрахованногоЛицаСотрудники.Ссылка.ДокументПринятВПФР) КАК УжеПроанкетированные
	|		ПО ФизическиеЛица.Ссылка = УжеПроанкетированные.ФизЛицо
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТФизическиеЛицаРаботавшиеВОрганизации КАК ВТФизическиеЛицаРаботавшиеВОрганизации
	|		ПО ФизическиеЛица.Ссылка = ВТФизическиеЛицаРаботавшиеВОрганизации.ФизическоеЛицо
	|ГДЕ
	|	УжеПроанкетированные.ФизЛицо ЕСТЬ NULL 
	|	И ФизическиеЛица.СтраховойНомерПФР В(&СписокПустыхНомеровПФР)";
	
	Возврат ПолучитьДанныеПоФизЛицам(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ФизическоеЛицо"), Дата, Организация);
	
КонецФункции

// Возвращает выборку из результата запроса, содержащую данные для физ. лица, для заполнения
// в табличную часть "Сотрудники" документа "ПачкаДокументовАДВ_1".
//
// Параметры:
//	СписокФизЛиц
//	Дата
//
// Возвращаемое значение:
//	Выборка из результата запроса с данными физ. лица.
//
Функция ПолучитьДанныеПоФизЛицам(СписокФизЛиц, Дата, Организация = Неопределено) Экспорт
	
	КадровыеДанные = "Наименование,Фамилия,Имя,Отчество,Пол,ДатаРождения,МестоРождения,"
		+ "ДокументВид,ДокументСерия,ДокументНомер,ДокументКемВыдан,ДокументДатаВыдачи,"
		+ "Страна,АдресПоПрописке,АдресПоПропискеПредставление,АдресМестаПроживания,"
		+ "АдресМестаПроживанияПредставление,ТелефонДомашнийПредставление,ИНН";
		
	ВозвращаемаяТаблица = КадровыйУчет.КадровыеДанныеФизическихЛиц(Истина, СписокФизЛиц, КадровыеДанные, Дата);
	
	ВозвращаемаяТаблица.Колонки.ФизическоеЛицо.Имя = "Сотрудник";
	ВозвращаемаяТаблица.Колонки.Страна.Имя = "Гражданство";
	ВозвращаемаяТаблица.Колонки.ДокументВид.Имя = "ВидДокумента";
	ВозвращаемаяТаблица.Колонки.ДокументСерия.Имя = "СерияДокумента";
	ВозвращаемаяТаблица.Колонки.ДокументНомер.Имя = "НомерДокумента";
	ВозвращаемаяТаблица.Колонки.ДокументКемВыдан.Имя = "КемВыдан";
	ВозвращаемаяТаблица.Колонки.ДокументДатаВыдачи.Имя = "ДатаВыдачи";
	
	ВозвращаемаяТаблица.Колонки.ТелефонДомашнийПредставление.Имя = "Телефоны";
	
	ВозвращаемаяТаблица.Колонки.АдресПоПрописке.Имя = "АдресРегистрации";
	ВозвращаемаяТаблица.Колонки.АдресПоПропискеПредставление.Имя = "АдресРегистрацииПредставление";
	
	ВозвращаемаяТаблица.Колонки.АдресМестаПроживания.Имя = "АдресФактический";
	ВозвращаемаяТаблица.Колонки.АдресМестаПроживанияПредставление.Имя = "АдресФактическийПредставление";
	
	ВозвращаемаяТаблица.Колонки.Добавить("МестоРожденияПредставление");
	Для Каждого СтрокаВозвращаемаяТаблица Из ВозвращаемаяТаблица Цикл
		СтрокаВозвращаемаяТаблица.МестоРожденияПредставление = ПерсонифицированныйУчетКлиентСервер.ПредставлениеМестаРождения(СтрокаВозвращаемаяТаблица.МестоРождения);
		Если СокрЛП(СтрокаВозвращаемаяТаблица.Фамилия) = "-" Тогда
			СтрокаВозвращаемаяТаблица.Фамилия = "";
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВозвращаемаяТаблица;
	
КонецФункции

// Выбирает данные, необходимые для заполнения утвержденных форм из ТЧ "Сотрудники".
//
// Параметры: 
//  МассивСсылок - в качестве параметра может передаваться либо массив ссылок на документы "ПачкаДокументовАДВ_1",
//				    либо ссылка на документ "ПачкаДокументовАДВ_1".
//
// Возвращаемое значение:
//  Результат запроса к данным работников документа.
//
Функция СформироватьЗапросПоСотрудникамДляПечати(МассивСсылок) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПачкаДокументовАДВ_1Сотрудники.НомерСтроки КАК НомерСтроки,
	|	ПачкаДокументовАДВ_1Сотрудники.Ссылка.Дата КАК ДатаДокумента,
	|	ПачкаДокументовАДВ_1Сотрудники.Сотрудник КАК ФизЛицо,
	|	ПачкаДокументовАДВ_1Сотрудники.Сотрудник.Наименование КАК ФизЛицоНаименование,
	|	ПачкаДокументовАДВ_1Сотрудники.Сотрудник.СтраховойНомерПФР КАК ФизЛицоСтраховойНомерПФР,
	|	ПачкаДокументовАДВ_1Сотрудники.АдресРегистрации КАК АдресРегистрации,
	|	ПачкаДокументовАДВ_1Сотрудники.АдресФактический КАК АдресФактический,
	|	ПачкаДокументовАДВ_1Сотрудники.АдресРегистрацииПредставление КАК АдресРегистрацииПредставление,
	|	ПачкаДокументовАДВ_1Сотрудники.АдресФактическийПредставление КАК АдресФактическийПредставление,
	|	ПачкаДокументовАДВ_1Сотрудники.Телефоны КАК Телефоны,
	|	ПачкаДокументовАДВ_1Сотрудники.Фамилия КАК Фамилия,
	|	ПачкаДокументовАДВ_1Сотрудники.Имя КАК Имя,
	|	ПачкаДокументовАДВ_1Сотрудники.Отчество КАК Отчество,
	|	ПачкаДокументовАДВ_1Сотрудники.Пол КАК Пол,
	|	ПачкаДокументовАДВ_1Сотрудники.ДатаРождения КАК ДатаРождения,
	|	ПачкаДокументовАДВ_1Сотрудники.МестоРождения КАК МестоРождения,
	|	ПачкаДокументовАДВ_1Сотрудники.Гражданство.Наименование КАК Страна,
	|	ПачкаДокументовАДВ_1Сотрудники.ВидДокумента КАК ДокументВид,
	|	ПачкаДокументовАДВ_1Сотрудники.ВидДокумента.КодПФР КАК ДокументВидКодПФР,
	|	ПачкаДокументовАДВ_1Сотрудники.ВидДокумента.Наименование КАК ДокументВидНаименование,
	|	ПачкаДокументовАДВ_1Сотрудники.СерияДокумента КАК ДокументСерия,
	|	ПачкаДокументовАДВ_1Сотрудники.НомерДокумента КАК ДокументНомер,
	|	ПачкаДокументовАДВ_1Сотрудники.ДатаВыдачи КАК ДокументДатаВыдачи,
	|	ПачкаДокументовАДВ_1Сотрудники.КемВыдан КАК ДокументКемВыдан,
	|	ПачкаДокументовАДВ_1Сотрудники.ИНН КАК ИНН,
	|	ВЫБОР
	|		КОГДА ПачкаДокументовАДВ_1Сотрудники.ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.СвидетельствоОРождении)
	|			ТОГДА ПачкаДокументовАДВ_1Сотрудники.НомерАктовойЗаписиПриРождении
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК НомерАктовойЗаписи,
	|	ПачкаДокументовАДВ_1Сотрудники.Ссылка КАК Ссылка,
	|	ПачкаДокументовАДВ_1Сотрудники.Ссылка.Дата КАК Дата
	|ИЗ
	|	Документ.ПачкаДокументовАДВ_1.Сотрудники КАК ПачкаДокументовАДВ_1Сотрудники
	|ГДЕ
	|	ПачкаДокументовАДВ_1Сотрудники.Ссылка В(&МассивСсылок)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

/// Получение данных для файла.
// Формирует запрос по шапке документа.
//
// Параметры: 
//  Нет
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШапкеДокумента(Ссылка)
	
	Запрос = Новый Запрос;
	// Установим параметры запроса.
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	// Впишем в запрос дополнительные таблицы.
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ОписаниеИсточникаДанных = ПерсонифицированныйУчет.ОписаниеИсточникаДанныхДляСоздатьВТСведенияОбОрганизациях();
	ОписаниеИсточникаДанных.ИмяТаблицы = "Документ.ПачкаДокументовАДВ_1";
	ОписаниеИсточникаДанных.ИмяПоляОрганизация = "Организация";
	ОписаниеИсточникаДанных.ИмяПоляПериод = "ОкончаниеОтчетногоПериода";
	ОписаниеИсточникаДанных.СписокСсылок = Ссылка;
	ПерсонифицированныйУчет.СоздатьВТСведенияОбОрганизацияхПоОписаниюДокументаИсточникаДанных(Запрос.МенеджерВременныхТаблиц, ОписаниеИсточникаДанных, Ложь);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПачкаДокументовАДВ_1.Дата КАК Дата,
	|	ПачкаДокументовАДВ_1.Номер КАК Номер,
	|	СведенияОбОрганизациях.Организация КАК Организация,
	|	СведенияОбОрганизациях.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	СведенияОбОрганизациях.Наименование КАК Наименование,
	|	СведенияОбОрганизациях.НаименованиеПолное КАК НаименованиеПолное,
	|	СведенияОбОрганизациях.ИНН КАК ИНН,
	|	СведенияОбОрганизациях.КПП КАК КПП,
	|	СведенияОбОрганизациях.ЮридическоеФизическоеЛицо КАК ЮридическоеФизическоеЛицо,
	|	СведенияОбОрганизациях.ОГРН КАК ОГРН,
	|	ПачкаДокументовАДВ_1.Ответственный КАК Ответственный,
	|	ПачкаДокументовАДВ_1.Ссылка КАК Ссылка,
	|	ПачкаДокументовАДВ_1.НомерПачки КАК НомерПачки,
	|	СведенияОбОрганизациях.РегистрационныйНомерПФР КАК РегистрационныйНомерПФР,
	|	СведенияОбОрганизациях.КодПоОКПО КАК КодПоОКПО,
	|	СведенияОбОрганизациях.НаименованиеСокращенное КАК НаименованиеСокращенное,
	|	ПачкаДокументовАДВ_1.ИмяФайлаДляПФР КАК ИмяФайлаДляПФР
	|ИЗ
	|	Документ.ПачкаДокументовАДВ_1 КАК ПачкаДокументовАДВ_1
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСведенияОбОрганизациях КАК СведенияОбОрганизациях
	|		ПО ПачкаДокументовАДВ_1.Организация = СведенияОбОрганизациях.ОрганизацияДокумента
	|			И ПачкаДокументовАДВ_1.ОкончаниеОтчетногоПериода = СведенияОбОрганизациях.Период
	|ГДЕ
	|	ПачкаДокументовАДВ_1.Ссылка = &Ссылка";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

// Выбирает данные, необходимые для заполнения утвержденных форм из ТЧ "Сотрудники".
//
// Параметры: 
//  Нет						
//
// Возвращаемое значение:
//  Результат запроса к данным работников документа.
//
Функция СформироватьЗапросПоСотрудникам(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПачкаДокументовАДВ_1Сотрудники.НомерСтроки КАК НомерСтроки,
	|	ПачкаДокументовАДВ_1Сотрудники.Ссылка.Дата КАК ДатаДокумента,
	|	ПачкаДокументовАДВ_1Сотрудники.Сотрудник КАК ФизЛицо,
	|	ПачкаДокументовАДВ_1Сотрудники.Сотрудник.Наименование КАК ФизЛицоНаименование,
	|	ПачкаДокументовАДВ_1Сотрудники.Сотрудник.СтраховойНомерПФР КАК ФизЛицоСтраховойНомерПФР,
	|	ПачкаДокументовАДВ_1Сотрудники.АдресРегистрации КАК АдресРегистрации,
	|	ПачкаДокументовАДВ_1Сотрудники.АдресФактический КАК АдресФактический,
	|	ПачкаДокументовАДВ_1Сотрудники.АдресРегистрацииПредставление КАК АдресРегистрацииПредставление,
	|	ПачкаДокументовАДВ_1Сотрудники.АдресФактическийПредставление КАК АдресФактическийПредставление,
	|	ПачкаДокументовАДВ_1Сотрудники.Телефоны КАК Телефоны,
	|	ПачкаДокументовАДВ_1Сотрудники.Фамилия КАК Фамилия,
	|	ПачкаДокументовАДВ_1Сотрудники.Имя КАК Имя,
	|	ПачкаДокументовАДВ_1Сотрудники.Отчество КАК Отчество,
	|	ПачкаДокументовАДВ_1Сотрудники.Пол КАК Пол,
	|	ПачкаДокументовАДВ_1Сотрудники.ДатаРождения КАК ДатаРождения,
	|	ПачкаДокументовАДВ_1Сотрудники.МестоРождения КАК МестоРождения,
	|	ВЫБОР
	|		КОГДА ПачкаДокументовАДВ_1Сотрудники.Гражданство = ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия)
	|			ТОГДА ""РОССИЯ""
	|		ИНАЧЕ ПачкаДокументовАДВ_1Сотрудники.Гражданство.Наименование
	|	КОНЕЦ КАК Страна,
	|	ПачкаДокументовАДВ_1Сотрудники.ВидДокумента КАК ДокументВид,
	|	ПачкаДокументовАДВ_1Сотрудники.ВидДокумента.КодПФР КАК ДокументВидКодПФР,
	|	ПачкаДокументовАДВ_1Сотрудники.ВидДокумента.Наименование КАК ДокументВидНаименование,
	|	ПачкаДокументовАДВ_1Сотрудники.СерияДокумента КАК ДокументСерия,
	|	ПачкаДокументовАДВ_1Сотрудники.НомерДокумента КАК ДокументНомер,
	|	ПачкаДокументовАДВ_1Сотрудники.ДатаВыдачи КАК ДокументДатаВыдачи,
	|	ПачкаДокументовАДВ_1Сотрудники.КемВыдан КАК ДокументКемВыдан,
	|	ПачкаДокументовАДВ_1Сотрудники.ИНН КАК ИНН,
	|	ВЫБОР
	|		КОГДА ПачкаДокументовАДВ_1Сотрудники.ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.СвидетельствоОРождении)
	|			ТОГДА ПачкаДокументовАДВ_1Сотрудники.НомерАктовойЗаписиПриРождении
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК НомерАктовойЗаписи
	|ИЗ
	|	Документ.ПачкаДокументовАДВ_1.Сотрудники КАК ПачкаДокументовАДВ_1Сотрудники
	|ГДЕ
	|	ПачкаДокументовАДВ_1Сотрудники.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура ОбработкаФормированияФайла(Объект) Экспорт
	
	ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапкеДокумента(Объект.Ссылка).Выбрать();
	ВыборкаПоСотрудникам = СформироватьЗапросПоСотрудникам(Объект.Ссылка).Выбрать();
	
	ВыборкаПоШапкеДокумента.Следующий();
	
	ТекстФайла = СформироватьВыходнойФайл(ВыборкаПоШапкеДокумента, ВыборкаПоСотрудникам);
	
	ЗарплатаКадры.ЗаписатьФайлВАрхив(Объект.Ссылка, ВыборкаПоШапкеДокумента.ИмяФайлаДляПФР, ТекстФайла);
	
КонецПроцедуры

// Формирует файл, который можно будет записать на дискетку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента,
//	ВыборкаСотрудники,
//	Отказ
//
// Возвращаемое значение:
//  Строка - содержимое файла
//
Функция СформироватьВыходнойФайл(ВыборкаПоШапкеДокумента, ВыборкаСотрудники)
	
	ДеревоФорматаXML = ПолучитьОбщийМакет("ФорматПФР70XML");
	ТекстФорматаXML = ДеревоФорматаXML.ПолучитьТекст();
	
	ДеревоФормата = ЗарплатаКадры.ЗагрузитьXMLВДокументDOM(ТекстФорматаXML);
	
	СписокОбработанныхАнкет = Новый Соответствие;
	
	ТекстФайла = "";
	НомерДокументаВПачке = 0;

	ДатаЗаполнения 			= ВыборкаПоШапкеДокумента.Дата;
	КоличествоДокументов 	= ВыборкаСотрудники.Количество();
	
	ДатаПостановления846п = РегистрыСведений.ДатыВступленияВСилуНА.ДатаВступленияВСилуНА("ОбновлениеФорматаАДВСогласноПостановлению846п");
	ИспользоватьФормат2021 = ЗначениеЗаполнено(ДатаПостановления846п) И ДатаПостановления846п <= ВыборкаПоШапкеДокумента.Дата;
	
	// Формирование файла версии 07.00.
	
	// Список стран
	СписокСтран = Новый Соответствие;
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтраныМира.Наименование,
	|	СтраныМира.Код
	|ИЗ
	|	Справочник.СтраныМира КАК СтраныМира";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокСтран.Вставить(СокрЛП(Выборка.Наименование), Строка(Выборка.Код));
	КонецЦикла;
	
	НомерДокументаВПачке = 1;
	
	// Создаем начальное дерево
	ДеревоВыгрузки = ЗарплатаКадры.СоздатьДеревоXML();
	
	УзелПФР = ПерсонифицированныйУчет.УзелФайлаПФР(ДеревоВыгрузки);
	
	ПерсонифицированныйУчет.ЗаполнитьИмяИЗаголовокФайла(УзелПФР, ДеревоФормата, ВыборкаПоШапкеДокумента.ИмяФайлаДляПФР);
	
	// Добавляем реквизит ПачкаВходящихДокументов.
	УзелПачкаВходящихДокументов = ПерсонифицированныйУчет.ЗаполнитьНаборЗаписейВходящаяОпись(УзелПФР, ДеревоФормата, "АНКЕТА_ЗЛ", ВыборкаПоШапкеДокумента, КоличествоДокументов,НомерДокументаВПачке);
	
	Сокращение = "";
	ФорматАнкетаЗЛ = ЗарплатаКадры.ЗагрузитьФорматНабораЗаписей(ДеревоФормата, "АНКЕТА_ЗЛ");
	ФорматИностранныйАдрес = ЗарплатаКадры.ЗагрузитьФорматНабораЗаписей(ДеревоФормата, "АдресОбщий", 3);
	ФорматНеструктурированныйАдрес = ЗарплатаКадры.ЗагрузитьФорматНабораЗаписей(ДеревоФормата, "АдресОбщий", 2);
	
	Пока ВыборкаСотрудники.Следующий()	Цикл
		
		// Инициалы должны быть указаны.
		Фамилия = СокрЛП(ВыборкаСотрудники.Фамилия);
		Имя = СокрЛП(ВыборкаСотрудники.Имя);
		Отчество = СокрЛП(ВыборкаСотрудники.Отчество);
		
		НомерДокументаВПачке = 	НомерДокументаВПачке + 1;
		
		НаборЗаписейАнкетаЗЛ = ОбщегоНазначения.СкопироватьРекурсивно(ФорматАнкетаЗЛ);
		
		НаборЗаписейАнкетаЗЛ.НомерВПачке.Значение = НомерДокументаВПачке;
		
		НаборЗаписейАнкетныеДанные = НаборЗаписейАнкетаЗЛ.АнкетныеДанные.Значение;
		НаборЗаписейФИО = НаборЗаписейАнкетныеДанные.ФИО.Значение;
		НаборЗаписейФИО.Фамилия = ВРег(ВыборкаСотрудники.Фамилия);
		НаборЗаписейФИО.Имя = ВРег(ВыборкаСотрудники.Имя);
		НаборЗаписейФИО.Отчество = ВРег(ВыборкаСотрудники.Отчество);
		
		ПерсонифицированныйУчет.УстановитьВыводВФайлСвойстваЗначенияЭлемента(НаборЗаписейАнкетныеДанные.ФИО, "Фамилия");
		ПерсонифицированныйУчет.УстановитьВыводВФайлСвойстваЗначенияЭлемента(НаборЗаписейАнкетныеДанные.ФИО, "Имя");
		ПерсонифицированныйУчет.УстановитьВыводВФайлСвойстваЗначенияЭлемента(НаборЗаписейАнкетныеДанные.ФИО, "Отчество");
		
		ПерсонифицированныйУчет.УстановитьВыводВФайлСвойстваЗначенияЭлемента(НаборЗаписейАнкетныеДанные.ФИО, "Отчество");
		
		Если ПустаяСтрока(ВыборкаСотрудники.АдресРегистрации) Тогда
			НаборЗаписейАнкетныеДанные.Удалить("АдресРегистрации");
		Иначе
			ТекстОшибки  ="";
			НаборЗаписейАдресРегистрации = НаборЗаписейАнкетныеДанные.АдресРегистрации.Значение;
			ПерсонифицированныйУчет.ЗаполнитьАдрес(НаборЗаписейАдресРегистрации, ВыборкаСотрудники.АдресРегистрации, 
					СписокСтран, ФорматНеструктурированныйАдрес, ФорматИностранныйАдрес, Ложь);
				НаборЗаписейАнкетныеДанные.АдресРегистрации.Значение = НаборЗаписейАдресРегистрации;
			НаборЗаписейАнкетныеДанные.АдресРегистрации.Значение = НаборЗаписейАдресРегистрации;
		КонецЕсли;
		
		Если ПустаяСтрока(ВыборкаСотрудники.АдресФактический) Тогда
			НаборЗаписейАнкетныеДанные.Удалить("АдресФактический");
		Иначе
			ТекстОшибки = "";
			НаборЗаписейАдресФактический = НаборЗаписейАнкетныеДанные.АдресФактический.Значение;
			ПерсонифицированныйУчет.ЗаполнитьАдрес(НаборЗаписейАдресФактический, ВыборкаСотрудники.АдресФактический, 
				СписокСтран, ФорматНеструктурированныйАдрес, ФорматИностранныйАдрес, Ложь);
			НаборЗаписейАнкетныеДанные.АдресФактический.Значение = НаборЗаписейАдресФактический;
		КонецЕсли;
		
		НаборЗаписейМестоРождения = НаборЗаписейАнкетныеДанные.МестоРождения.Значение;
		
		МестоРождения = ПерсонифицированныйУчетКлиентСервер.РазложитьМестоРождения(ВыборкаСотрудники.МестоРождения); 
		
		НаборЗаписейМестоРождения.ТипМестаРождения = ?(МестоРождения.Особое = 1, "ОСОБОЕ", "СТАНДАРТНОЕ");
		
		НаборЗаписейМестоРождения.ГородРождения = ПерсонифицированныйУчет.НаименованиеИАдресноеСокращение(ВРЕГ(СокрЛП(МестоРождения.НаселенныйПункт)), Сокращение);
		НаборЗаписейМестоРождения.РайонРождения = ПерсонифицированныйУчет.НаименованиеИАдресноеСокращение(ВРЕГ(СокрЛП(МестоРождения.Район)), Сокращение);
		НаборЗаписейМестоРождения.РегионРождения = МестоРождения.Область;
		НаборЗаписейМестоРождения.СтранаРождения = МестоРождения.Страна;
		
		НаборЗаписейАнкетныеДанные.Телефон.Значение = ВыборкаСотрудники.Телефоны;
		НаборЗаписейАнкетныеДанные.ДатаРождения.Значение = ВыборкаСотрудники.ДатаРождения;
		НаборЗаписейАнкетныеДанные.Пол.Значение = ВРег(ВыборкаСотрудники.Пол);
		НаборЗаписейАнкетныеДанные.Гражданство.Значение = СокрЛП(ВыборкаСотрудники.Страна);
		
		ПерсонифицированныйУчет.УстановитьВыводВФайл(НаборЗаписейАнкетныеДанные.Телефон, "Значение");
		ПерсонифицированныйУчет.УстановитьВыводВФайл(НаборЗаписейАнкетныеДанные.Гражданство, "Значение");
		
		// Заполняем Удостоверяющий документ.
		НаборЗаписейУдостоверяющийДокумент = НаборЗаписейАнкетаЗЛ.УдостоверяющийДокумент.Значение;
		НаборЗаписейДокумент = НаборЗаписейУдостоверяющийДокумент.Документ.Значение;
		
		ДанныеДокумента = ПерсонифицированныйУчет.ПолучитьДанныеДокументаВФорматеПФР(ВыборкаСотрудники.ДокументВид, ВыборкаСотрудники.ДокументСерия, 
				ВыборкаСотрудники.ДокументНомер, ВыборкаСотрудники.ДокументДатаВыдачи,
				ВыборкаСотрудники.ДокументКемВыдан, ВыборкаСотрудники.ДокументВидКодПФР, ВыборкаСотрудники.ДокументВидНаименование);
		
		НаборЗаписейУдостоверяющийДокумент.ТипУдостоверяющего.Значение = ДанныеДокумента.ТипУдостоверяющегоДокумента;
		НаборЗаписейДокумент.НаименованиеУдостоверяющего = ДанныеДокумента.НаименованиеУдостоверяющегоДокумента;
		
		НаборЗаписейДокумент.СерияРимскиеЦифры = ДанныеДокумента.СерияРимскиеЦифры;
		НаборЗаписейДокумент.СерияРусскиеБуквы = ДанныеДокумента.СерияРусскиеБуквы;
		НаборЗаписейДокумент.НомерУдостоверяющего = ДанныеДокумента.НомерУдостоверяющегоДокумента;
		НаборЗаписейДокумент.ДатаВыдачи = ДанныеДокумента.ДатаВыдачи;
		НаборЗаписейДокумент.КемВыдан = ДанныеДокумента.КемВыдан;
		
		Если ИспользоватьФормат2021 Тогда
			НаборЗаписейУдостоверяющийДокумент.НомерАктовойЗаписи.Значение = ВыборкаСотрудники.НомерАктовойЗаписи;
			НаборЗаписейУдостоверяющийДокумент.ИННФизическогоЛица.Значение = ВыборкаСотрудники.ИНН;
		КонецЕсли;
		
		ПерсонифицированныйУчет.УстановитьВыводВФайлСвойстваЗначенияЭлемента(НаборЗаписейУдостоверяющийДокумент.Документ, "СерияРимскиеЦифры");
		ПерсонифицированныйУчет.УстановитьВыводВФайлСвойстваЗначенияЭлемента(НаборЗаписейУдостоверяющийДокумент.Документ, "СерияРусскиеБуквы");
		ПерсонифицированныйУчет.УстановитьВыводВФайл(НаборЗаписейУдостоверяющийДокумент.НомерАктовойЗаписи, "Значение");
		ПерсонифицированныйУчет.УстановитьВыводВФайл(НаборЗаписейУдостоверяющийДокумент.ИННФизическогоЛица, "Значение");
		
		НаборЗаписейАнкетаЗЛ.ДатаЗаполнения.Значение = ДатаЗаполнения;
		
		ЗарплатаКадры.ДобавитьИнформациюВДерево(ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелПачкаВходящихДокументов, "АНКЕТА_ЗЛ",""), НаборЗаписейАнкетаЗЛ);
		
	КонецЦикла;
	
	// Преобразуем дерево в строковое описание XML.
	ТекстФайла = ПерсонифицированныйУчет.ПолучитьТекстФайлаИзДереваЗначений(ДеревоВыгрузки);
	
	Возврат ТекстФайла;
	
КонецФункции

#КонецОбласти

#Область ПроцедурыПечатиДокумента

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// АДВ-1
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ФормаАДВ_1";
	КомандаПечати.Представление = НСтр("ru = 'АДВ-1';
										|en = 'ADV-1'");
	КомандаПечати.Порядок = 10;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	
	// АДВ-6-1
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ФормаАДВ_6_1";
	КомандаПечати.Представление = НСтр("ru = 'АДВ-6-1';
										|en = 'ADV-6-1'");
	КомандаПечати.Порядок = 20;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	
	// Все формы
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ФормаАДВ_1,ФормаАДВ_6_1";
	КомандаПечати.Представление = НСтр("ru = 'Все формы';
										|en = 'All forms'");
	КомандаПечати.Порядок = 30;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт	
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ФормаАДВ_1") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ФормаАДВ_1", "Форма АДВ-1", СформироватьПечатнуюФормуАДВ1(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ФормаАДВ_6_1") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ФормаАДВ_6_1", "Форма АДВ-6-1", СформироватьПечатнуюФормуАДВ6(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуАДВ1(МассивОбъектов, ОбъектыПечати)
	
	Сокращение = "";
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_АнкетаЗастрахованногоЛица_ФормаАДВ_1";
	
	ДатаПостановления485п = РегистрыСведений.ДатыВступленияВСилуНА.ДатаВступленияВСилуНА("ПостановлениеПравленияПФРот27сентября2019Номер485п");
	
	ВыборкаДокументов = СформироватьЗапросПоСотрудникамДляПечати(МассивОбъектов).Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаДокументов.Следующий() Цикл
		
		ИспользоватьФорму2019 = ДатаПостановления485п <> Неопределено И ДатаПостановления485п <= ВыборкаДокументов.Дата;
		ИспользоватьФорму2021 = '20210123' <= ВыборкаДокументов.Дата;
		
		Если ИспользоватьФорму2021 Тогда
			Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПачкаДокументовАДВ_1.ПФ_MXL_ФормаАДВ_1_2021");
		ИначеЕсли ИспользоватьФорму2019 Тогда
			Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПачкаДокументовАДВ_1.ПФ_MXL_ФормаАДВ_1_2019");
		Иначе
			Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПачкаДокументовАДВ_1.ПФ_MXL_ФормаАДВ_1");
		КонецЕсли;
		
		ОбластьАнкета = Макет.ПолучитьОбласть("Анкета");
		
		ВыборкаСотрудники = ВыборкаДокументов.Выбрать();
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		Пока ВыборкаСотрудники.Следующий() Цикл
			
			// Основное
			ОбластьАнкета.Параметры.ДатаЗаполнения = ПерсонифицированныйУчет.ДатаВОтчет(ВыборкаСотрудники.ДатаДокумента);
			ОбластьАнкета.Параметры.Фамилия        = ПерсонифицированныйУчет.СтрокаВОтчет(ВыборкаСотрудники.Фамилия);
			ОбластьАнкета.Параметры.Имя            = ПерсонифицированныйУчет.СтрокаВОтчет(ВыборкаСотрудники.Имя);
			ОбластьАнкета.Параметры.Отчество       = ПерсонифицированныйУчет.СтрокаВОтчет(ВыборкаСотрудники.Отчество);
			Если ВыборкаСотрудники.Пол = Перечисления.ПолФизическогоЛица.Мужской Тогда
				ОбластьАнкета.Параметры.Пол = "М     (м/ж)";
			Иначе
				ОбластьАнкета.Параметры.Пол = "Ж     (м/ж)";
			КонецЕсли;
			ОбластьАнкета.Параметры.ДатаРождения  = ПерсонифицированныйУчет.ДатаВОтчет(ВыборкаСотрудники.ДатаРождения);
			
			МестоРождения = ПерсонифицированныйУчетКлиентСервер.РазложитьМестоРождения(ВыборкаСотрудники.МестоРождения); 
			
			ОбластьАнкета.Параметры.МестоРожденияТип = ?(МестоРождения.Особое = 1, "особое", "");
			
			МестоРождения.НаселенныйПункт = ПерсонифицированныйУчет.НаименованиеИАдресноеСокращение(ВРЕГ(СокрЛП(МестоРождения.НаселенныйПункт)), Сокращение);
			ОбластьАнкета.Параметры.МестоРожденияГород =  ПерсонифицированныйУчет.СтрокаВОтчет(МестоРождения.НаселенныйПункт);
			МестоРождения.Район = ПерсонифицированныйУчет.НаименованиеИАдресноеСокращение(ВРЕГ(СокрЛП(МестоРождения.Район)), Сокращение);
			ОбластьАнкета.Параметры.МестоРожденияРайон = ПерсонифицированныйУчет.СтрокаВОтчет(МестоРождения.Район);
			ОбластьАнкета.Параметры.МестоРожденияОбласть = ПерсонифицированныйУчет.СтрокаВОтчет(МестоРождения.Область);
			ОбластьАнкета.Параметры.МестоРожденияСтрана = ПерсонифицированныйУчет.СтрокаВОтчет(МестоРождения.Страна);
			
			ОбластьАнкета.Параметры.Гражданство = ПерсонифицированныйУчет.СтрокаВОтчет(ВыборкаСотрудники.Страна);
			
			СтруктураАдресРегистрации = ЗарплатаКадры.СтруктураАдресаИзXML(
					ВыборкаСотрудники.АдресРегистрации, Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица);
			СтруктураАдресФактический = ЗарплатаКадры.СтруктураАдресаИзXML(
					ВыборкаСотрудники.АдресФактический, Справочники.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица);
			
			ОбластьАнкета.Параметры.АдресРегистрации = ПерсонифицированныйУчет.ПолучитьПредставлениеАдресаДляПФР(СтруктураАдресРегистрации);
			ОбластьАнкета.Параметры.АдресФактический = ПерсонифицированныйУчет.ПолучитьПредставлениеАдресаДляПФР(СтруктураАдресФактический);
			
			ОбластьАнкета.Параметры.Телефоны = ПерсонифицированныйУчет.СтрокаВОтчет(ВыборкаСотрудники.Телефоны);
			
			ДанныеДокумента = ПерсонифицированныйУчет.ПолучитьДанныеДокументаВФорматеПФР(
					ВыборкаСотрудники.ДокументВид,
					ВыборкаСотрудники.ДокументСерия,
					ВыборкаСотрудники.ДокументНомер, 
					ВыборкаСотрудники.ДокументДатаВыдачи,
					ВыборкаСотрудники.ДокументКемВыдан,
					ВыборкаСотрудники.ДокументВидКодПФР,
					ВыборкаСотрудники.ДокументВидНаименование);
			СерияНомер = ДанныеДокумента.СерияРимскиеЦифры + ?(ЗначениеЗаполнено(ДанныеДокумента.СерияРимскиеЦифры) И ЗначениеЗаполнено(ДанныеДокумента.СерияРусскиеБуквы), " ", "") + ДанныеДокумента.СерияРусскиеБуквы + ",  " + ДанныеДокумента.НомерУдостоверяющегоДокумента;
			ОбластьАнкета.Параметры.СерияНомер = СерияНомер;
			ОбластьАнкета.Параметры.НаименованиеДокумента = ДанныеДокумента.НаименованиеУдостоверяющегоДокумента; 
			ОбластьАнкета.Параметры.ДатаВыдачи = ПерсонифицированныйУчет.ДатаВОтчет(ДанныеДокумента.ДатаВыдачи);
			ОбластьАнкета.Параметры.КемВыдан   = ДанныеДокумента.КемВыдан;
			
			ОбластьАнкета.Параметры.ДатаЗаполнения = ?(ИспользоватьФорму2019,
				ПерсонифицированныйУчет.ДатаВОтчет(ВыборкаСотрудники.Дата), Формат(ВыборкаСотрудники.Дата, "ДФ=дд.ММ.гггг"));
				
			Если ИспользоватьФорму2021 Тогда
				ОбластьАнкета.Параметры.ИНН = ВыборкаСотрудники.ИНН;
				ОбластьАнкета.Параметры.НомерАктовойЗаписи = ВыборкаСотрудники.НомерАктовойЗаписи;
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьАнкета);
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументов.Ссылка);
		
	КонецЦикла;
	
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция СформироватьПечатнуюФормуАДВ6(МассивОбъектов, ОбъектыПечати)
	Возврат ПерсонифицированныйУчет.ВывестиОписьАДВ6(МассивОбъектов, ОбъектыПечати, "АНКТ", "ПФ_MXL_ФормаАДВ_6_1_2017");
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли