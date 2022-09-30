#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	//++ НЕ УТКА
	МеханизмыДокумента.Добавить("МеждународныйУчет");
	//-- НЕ УТКА
	МеханизмыДокумента.Добавить("РезервыПредстоящихРасходов");
	МеханизмыДокумента.Добавить("УчетДоходовРасходов");
	МеханизмыДокумента.Добавить("УчетПрочихАктивовПассивов");
	
	НачислениеСписаниеРезервовПредстоящихРасходовЛокализация.ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента);
	
КонецПроцедуры

#КонецОбласти

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
	НачислениеСписаниеРезервовПредстоящихРасходовЛокализация.ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);

КонецПроцедуры

// Возвращает данные по объектам учета резервов предстоящих расходов: направление деятельности, остатки на регистре,
//	данные по начислению и списанию. Данные заполняются на основании одного из следующих условий:
//		- дата, переданная в параметрах заполнения входит в период действия объекта учета резервов;
//		- есть остатки на регистре на дату, переданную в параметрах.
//	Параметры:
//		ПараметрыЗаполнения - Структура - структура, содержащая следующие ключи:
//			Дата - дата и время - дата, на которую необходимо получить данные регистра "РезервыПредстоящихРасходов";
//			Ссылка - ДокументСсылка - ссылка на документ, остатки по которому не надо учитывать при получении данных из регистра;
//			Организация - СправочникСсылка.Организации - Организация, по которой необходимо получить данные;
//			ВидРезервов - СправочникСсылка.Резервы - Резерв, по которому необходимо получить данные;
//		ОбъектыУчетаРезервов - СправочникСсылка.ОбъектыУчетаРезервовПредстоящихРасходов - если задан, то возвращаются данные только по этому объекту учета;
//
// Возвращаемое значение:
//		РезультатЗапроса - Данные результата запроса.
//
Функция ДанныеДляЗаполненияРезервов(ПараметрыЗаполнения, ОбъектыУчетаРезервов = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РезервыПредстоящихРасходовОстатки.Организация КАК Организация,
	|	РезервыПредстоящихРасходовОстатки.ВидРезервов КАК ВидРезервов,
	|	РезервыПредстоящихРасходовОстатки.ОбъектУчетаРезервов КАК ОбъектУчетаРезервов,
	|	-РезервыПредстоящихРасходовОстатки.СуммаРеглОстаток КАК СуммаРеглОстаток,
	|	-РезервыПредстоящихРасходовОстатки.СуммаУпрОстаток КАК СуммаУпрОстаток
	|ПОМЕСТИТЬ ОстаткиРезервовПредстоящихРасходов
	|ИЗ
	|	РегистрНакопления.РезервыПредстоящихРасходов.Остатки(
	|			&Граница,
	|			Организация = &Организация
	|				И ВидРезервов = &ВидРезервов
	|				И (НЕ &ОтборПоОбъектуУчетаРезервов ИЛИ ОбъектУчетаРезервов В (&ОбъектыУчетаРезервов))) КАК РезервыПредстоящихРасходовОстатки
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ВидРезервов,
	|	ОбъектУчетаРезервов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОбъектыУчетаРезервовПредстоящихРасходов.Ссылка КАК ОбъектУчетаРезервов,
	|	ОбъектыУчетаРезервовПредстоящихРасходов.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ОбъектыУчетаРезервовПредстоящихРасходов.ПодразделениеНачисления КАК ПодразделениеНачисления,
	|	ОбъектыУчетаРезервовПредстоящихРасходов.НаправлениеДеятельностиНачисления КАК НаправлениеДеятельностиНачисления,
	|	ОбъектыУчетаРезервовПредстоящихРасходов.СтатьяРасходовНачисления КАК СтатьяРасходовНачисления,
	|	ОбъектыУчетаРезервовПредстоящихРасходов.АналитикаРасходовНачисления КАК АналитикаРасходовНачисления,
	|	ОбъектыУчетаРезервовПредстоящихРасходов.ПодразделениеСписания КАК ПодразделениеСписания,
	|	ОбъектыУчетаРезервовПредстоящихРасходов.НаправлениеДеятельностиСписания КАК НаправлениеДеятельностиСписания,
	|	ОбъектыУчетаРезервовПредстоящихРасходов.СтатьяДоходовСписания КАК СтатьяДоходовСписания,
	|	ОбъектыУчетаРезервовПредстоящихРасходов.АналитикаДоходовСписания КАК АналитикаДоходовСписания,
	|	ЕСТЬNULL(РезервыПредстоящихРасходовОстатки.СуммаРеглОстаток, 0) КАК ТекущаяСуммаРегл,
	|	ЕСТЬNULL(РезервыПредстоящихРасходовОстатки.СуммаУпрОстаток, 0) КАК ТекущаяСуммаУпр
	|ИЗ
	|	Справочник.ОбъектыУчетаРезервовПредстоящихРасходов КАК ОбъектыУчетаРезервовПредстоящихРасходов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиРезервовПредстоящихРасходов КАК РезервыПредстоящихРасходовОстатки
	|		ПО (РезервыПредстоящихРасходовОстатки.ОбъектУчетаРезервов = ОбъектыУчетаРезервовПредстоящихРасходов.Ссылка)
	|			И (РезервыПредстоящихРасходовОстатки.Организация = ОбъектыУчетаРезервовПредстоящихРасходов.Организация)
	|			И (РезервыПредстоящихРасходовОстатки.ВидРезервов = ОбъектыУчетаРезервовПредстоящихРасходов.ВидРезервов)
	|ГДЕ
	|	ОбъектыУчетаРезервовПредстоящихРасходов.Организация = &Организация
	|	И ОбъектыУчетаРезервовПредстоящихРасходов.ВидРезервов = &ВидРезервов
	|	И ВЫБОР
	|			КОГДА &ОтборПоОбъектуУчетаРезервов
	|				ТОГДА ОбъектыУчетаРезервовПредстоящихРасходов.Ссылка В (&ОбъектыУчетаРезервов)
	|			ИНАЧЕ ЕСТЬNULL(РезервыПредстоящихРасходовОстатки.СуммаРеглОстаток, 0) > 0
	|					ИЛИ ЕСТЬNULL(РезервыПредстоящихРасходовОстатки.СуммаУпрОстаток, 0) > 0
	|					ИЛИ ОбъектыУчетаРезервовПредстоящихРасходов.НачалоПериода <= &ТекДата
	|						И (ОбъектыУчетаРезервовПредстоящихРасходов.КонецПериода > &ТекДата
	|							ИЛИ ОбъектыУчетаРезервовПредстоящихРасходов.КонецПериода = ДАТАВРЕМЯ(1, 1, 1))
	|		КОНЕЦ;
	|
	|УНИЧТОЖИТЬ ОстаткиРезервовПредстоящихРасходов";
	
	Запрос.УстановитьПараметр("Граница", Новый Граница(Новый МоментВремени(ПараметрыЗаполнения.Дата, ПараметрыЗаполнения.Ссылка), ВидГраницы.Исключая));	
	Запрос.УстановитьПараметр("ТекДата", ПараметрыЗаполнения.Дата);
	Запрос.УстановитьПараметр("Организация", ПараметрыЗаполнения.Организация);
	Запрос.УстановитьПараметр("ВидРезервов", ПараметрыЗаполнения.ВидРезервов);
	Запрос.УстановитьПараметр("ОбъектыУчетаРезервов", ОбъектыУчетаРезервов);
	Запрос.УстановитьПараметр("ОтборПоОбъектуУчетаРезервов", ОбъектыУчетаРезервов <> Неопределено И ОбъектыУчетаРезервов.Количество() > 0);
	
	Результат = Запрос.Выполнить();
	
	Возврат Результат;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

// Возвращает параметры выбора статей в документе.
// 
// Параметры:
// 	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации -См. ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики
//
// Возвращаемое значение:
//  Массив Из см. ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики -
//
Функция ПараметрыВыбораСтатейИАналитик(ХозяйственнаяОперация) Экспорт
	
	МассивПараметровВыбора = Новый Массив;
	
	#Область РезервыСтатьяРасходовНачисления
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "Объект.Резервы";
	ПараметрыВыбора.Статья      = "СтатьяРасходовНачисления";
	
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаРасходовНачисления";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("РезервыСтатьяРасходовНачисления");
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("РезервыАналитикаРасходовНачисления");
	
	МассивПараметровВыбора.Добавить(ПараметрыВыбора);
	#КонецОбласти
	
	#Область ПрочиеДоходыСтатьяДоходов
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным =    "Объект.Резервы";
	ПараметрыВыбора.Статья = "СтатьяДоходовСписания";
	
	ПараметрыВыбора.ВыборСтатьиДоходов = Истина;
	ПараметрыВыбора.АналитикаДоходов = "АналитикаДоходовСписания";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("РезервыСтатьяДоходовСписания");	
	ПараметрыВыбора.ЭлементыФормы.АналитикаДоходов.Добавить("РезервыАналитикаДоходовСписания");
	
	МассивПараметровВыбора.Добавить(ПараметрыВыбора);
	#КонецОбласти
	
	Возврат МассивПараметровВыбора;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  см. ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Запрос			= Новый Запрос;
	ТекстыЗапроса	= Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		////////////////////////////////////////////////////////////////////////////
		// Создадим запрос инициализации движений
		
		ЗаполнитьПараметрыИнициализации(Запрос, Документ);
		
		////////////////////////////////////////////////////////////////////////////
		// Сформируем текст запроса
		
		ТекстЗапросаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаПрочиеДоходы(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаРезервыПредстоящихРасходов(Запрос, ТекстыЗапроса, Регистры);
		
		НачислениеСписаниеРезервовПредстоящихРасходовЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос,
																									ТекстыЗапроса,
																									Регистры);
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)

	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.ВидРезервов КАК ВидРезервов
	|ИЗ
	|	Документ.НачислениеСписаниеРезервовПредстоящихРасходов КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаВтНачисления(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтНачисления";
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Строки.ПодразделениеНачисления КАК Подразделение,
	|	Строки.НаправлениеДеятельностиНачисления КАК НаправлениеДеятельностиНачисления,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	Строки.ОбъектУчетаРезервов КАК ОбъектУчетаРезервов,
	|	Строки.СтатьяРасходовНачисления КАК СтатьяРасходов,
	|	Строки.АналитикаРасходовНачисления КАК АналитикаРасходов,
	|	ВЫБОР
	|		КОГДА Строки.УстановитьНовуюСуммуРегл И Строки.ТекущаяСуммаРегл < Строки.НоваяСуммаРегл
	|		ТОГДА Строки.НоваяСуммаРегл - Строки.ТекущаяСуммаРегл
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаРегл,
	|	ВЫБОР
	|		КОГДА НЕ &УправленческийУчетОрганизаций 
	|			ТОГДА 0
	|		КОГДА Строки.УстановитьНовуюСуммаУпр И Строки.ТекущаяСуммаУпр < Строки.НоваяСуммаУпр
	|		ТОГДА Строки.НоваяСуммаУпр - Строки.ТекущаяСуммаУпр
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаУпр,
	|
	|	Строки.ИдентификаторСтроки КАК ИдентификаторСтроки
	|
	|ПОМЕСТИТЬ ВтНачисления
	|ИЗ
	|	Документ.НачислениеСписаниеРезервовПредстоящихРасходов.Резервы КАК Строки
	|ГДЕ
	|	Строки.Ссылка = &Ссылка
	|	И (Строки.УстановитьНовуюСуммуРегл И Строки.ТекущаяСуммаРегл < Строки.НоваяСуммаРегл
	|	ИЛИ Строки.УстановитьНовуюСуммаУпр И Строки.ТекущаяСуммаУпр < Строки.НоваяСуммаУпр)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтСписания(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтСписания";
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Строки.ПодразделениеСписания КАК Подразделение,
	|	Строки.НаправлениеДеятельностиСписания КАК НаправлениеДеятельностиСписания,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	Строки.ОбъектУчетаРезервов КАК ОбъектУчетаРезервов,
	|	Строки.СтатьяДоходовСписания КАК СтатьяДоходов,
	|	Строки.АналитикаДоходовСписания КАК АналитикаДоходов,
	|	ВЫБОР
	|		КОГДА Строки.УстановитьНовуюСуммуРегл И Строки.ТекущаяСуммаРегл > Строки.НоваяСуммаРегл
	|		ТОГДА Строки.ТекущаяСуммаРегл - Строки.НоваяСуммаРегл
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаРегл,
	|	ВЫБОР
	|		КОГДА НЕ &УправленческийУчетОрганизаций 
	|			ТОГДА 0
	|		КОГДА Строки.УстановитьНовуюСуммаУпр И Строки.ТекущаяСуммаУпр > Строки.НоваяСуммаУпр
	|		ТОГДА Строки.ТекущаяСуммаУпр - Строки.НоваяСуммаУпр
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаУпр,
	|	
	|	Строки.ИдентификаторСтроки КАК ИдентификаторСтроки
	|
	|ПОМЕСТИТЬ ВтСписания
	|ИЗ
	|	Документ.НачислениеСписаниеРезервовПредстоящихРасходов.Резервы КАК Строки
	|ГДЕ
	|	Строки.Ссылка = &Ссылка
	|	И (Строки.УстановитьНовуюСуммуРегл И Строки.ТекущаяСуммаРегл > Строки.НоваяСуммаРегл
	|	ИЛИ Строки.УстановитьНовуюСуммаУпр И Строки.ТекущаяСуммаУпр > Строки.НоваяСуммаУпр)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтИсходныеПрочиеРасходы";
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтНачисления", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтНачисления(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Организация КАК Организация,
	|	ТаблицаНачислений.Подразделение КАК Подразделение,
	|	ТаблицаНачислений.НаправлениеДеятельностиНачисления КАК НаправлениеДеятельности,
	|	ТаблицаНачислений.СтатьяРасходов КАК СтатьяРасходов,
	|	ТаблицаНачислений.АналитикаРасходов КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО КАК ВидДеятельностиНДС,
	|
	|	0 КАК СуммаСНДС,
	|	0 КАК СуммаБезНДС,
	|	СУММА(ТаблицаНачислений.СуммаУпр) КАК СуммаБезНДСУпр,
	|	СУММА(ТаблицаНачислений.СуммаРегл) КАК СуммаСНДСРегл,
	|	СУММА(ТаблицаНачислений.СуммаРегл) КАК СуммаБезНДСРегл,
	|	0 КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.НачислениеРезервовПредстоящихРасходов) КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаНоменклатуры,
	|	
	|	ТаблицаНачислений.ИдентификаторСтроки КАК ИдентификаторФинЗаписи,
	|	ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.НачислениеРезервовПредстоящихРасходов) КАК  НастройкаХозяйственнойОперации
	|
	|ПОМЕСТИТЬ ВтИсходныеПрочиеРасходы
	|ИЗ
	|	ВтНачисления КАК ТаблицаНачислений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаНачислений.СтатьяРасходов,
	|	ТаблицаНачислений.АналитикаРасходов,
	|	ТаблицаНачислений.Подразделение,
	|	ТаблицаНачислений.НаправлениеДеятельностиНачисления,
	|	ТаблицаНачислений.ИдентификаторСтроки
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтПрочиеРасходы";
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтИсходныеПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстЗапросаТаблицаВтПрочиеРасходы();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеРасходы";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстЗапросаТаблицаПрочиеРасходы();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ТекстЗапросаПрочиеДоходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеДоходы";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтСписания", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтСписания(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Организация КАК Организация,
	|	ТаблицаСписаний.Подразделение КАК Подразделение,
	|	ТаблицаСписаний.НаправлениеДеятельностиСписания КАК НаправлениеДеятельности,
	|	ТаблицаСписаний.СтатьяДоходов КАК СтатьяДоходов,
	|	ТаблицаСписаний.АналитикаДоходов КАК АналитикаДоходов,
	|	СУММА(0) КАК Сумма,
	|	СУММА(ТаблицаСписаний.СуммаРегл) КАК СуммаРегл,
	|	СУММА(ТаблицаСписаний.СуммаУпр) КАК СуммаУпр,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеРезервовПредстоящихРасходов) КАК ХозяйственнаяОперация,
	|	
	|	ТаблицаСписаний.ИдентификаторСтроки КАК ИдентификаторФинЗаписи,
	|	ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.СписаниеРезервовПредстоящихРасходов) КАК  НастройкаХозяйственнойОперации
	|	
	|ИЗ
	|	ВтСписания КАК ТаблицаСписаний
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаСписаний.СтатьяДоходов,
	|	ТаблицаСписаний.АналитикаДоходов,
	|	ТаблицаСписаний.Подразделение,
	|	ТаблицаСписаний.НаправлениеДеятельностиСписания,
	|	ТаблицаСписаний.ИдентификаторСтроки";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

Процедура ТекстЗапросаРезервыПредстоящихРасходов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РезервыПредстоящихРасходов";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтНачисления", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтНачисления(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтСписания", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтСписания(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Организация КАК Организация,
	|	&ВидРезервов КАК ВидРезервов,
	|	ТаблицаНачислений.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ТаблицаНачислений.ОбъектУчетаРезервов КАК ОбъектУчетаРезервов,
	|	СУММА(ТаблицаНачислений.СуммаРегл) КАК СуммаРегл,
	|	СУММА(ТаблицаНачислений.СуммаУпр) КАК СуммаУпр,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.НачислениеРезервовПредстоящихРасходов) КАК ХозяйственнаяОперация,
	|	
	|	ТаблицаНачислений.ИдентификаторСтроки КАК ИдентификаторФинЗаписи,
	|	ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.НачислениеРезервовПредстоящихРасходов) КАК НастройкаХозяйственнойОперации
	|	
	|ИЗ
	|	ВтНачисления КАК ТаблицаНачислений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаНачислений.ОбъектУчетаРезервов,
	|	ТаблицаНачислений.НаправлениеДеятельности,
	|	ТаблицаНачислений.ИдентификаторСтроки 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	&Организация,
	|	&ВидРезервов,
	|	ТаблицаСписаний.НаправлениеДеятельности,
	|	ТаблицаСписаний.ОбъектУчетаРезервов,
	|	СУММА(ТаблицаСписаний.СуммаРегл),
	|	СУММА(ТаблицаСписаний.СуммаУпр),
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеРезервовПредстоящихРасходов),
	|	
	|	ТаблицаСписаний.ИдентификаторСтроки КАК ИдентификаторФинЗаписи,
	|	ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.СписаниеРезервовПредстоящихРасходов) КАК НастройкаХозяйственнойОперации
	|	
	|ИЗ
	|	ВтСписания КАК ТаблицаСписаний
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаСписаний.ОбъектУчетаРезервов,
	|	ТаблицаСписаний.НаправлениеДеятельности,
	|	ТаблицаСписаний.ИдентификаторСтроки ";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#Область ПроводкиРеглУчета

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт

	Возврат НачислениеСписаниеРезервовПредстоящихРасходовЛокализация.ТекстОтраженияВРеглУчете();

КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламентированном учете.
//
// Возвращаемое значение:
//   Строка - сформированный текст запроса.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт

	Возврат НачислениеСписаниеРезервовПредстоящихРасходовЛокализация.ТекстЗапросаВТОтраженияВРеглУчете();

КонецФункции

#КонецОбласти

#Область Прочее

#Область ЗагрузкаИзФайла

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Загрузка из файла.

// Устанавливает параметры загрузки.
//
Процедура УстановитьПараметрыЗагрузкиИзФайлаВТЧ(Параметры) Экспорт
	Возврат;
КонецПроцедуры

// Производит сопоставление данных, загружаемых в табличную часть ПолноеИмяТабличнойЧасти,
// с данными в ИБ, и заполняет параметры АдресТаблицыСопоставления и СписокНеоднозначностей.
// 
// Параметры:
// 	АдресЗагружаемыхДанных    - Строка - адрес временного хранилища с таблицей значений, в которой
//                                        находятся загруженные данные из файла. Состав колонок:
//     Идентификатор - Число - порядковый номер строки.
//     остальные колонки соответствуют колонкам макета ЗагрузкаИзФайла.
// 	АдресТаблицыСопоставления - Строка - адрес временного хранилища с пустой таблицей значений,
//                                        являющейся копией табличной части документа,
//                                        которую необходимо заполнить из таблицы АдресЗагружаемыхДанных.
// 	СписокНеоднозначностей    - ТаблицаЗначений - список неоднозначных значений, для которых в ИБ имеется несколько:
// 		* Идентификатор - Число - порядковый номер строки.
// 		Остальные колонки.
// 	ПолноеИмяТабличнойЧасти   - Строка -
// 	ДополнительныеПараметры   - Структура - 
Процедура СопоставитьЗагружаемыеДанные(АдресЗагружаемыхДанных, АдресТаблицыСопоставления, СписокНеоднозначностей, ПолноеИмяТабличнойЧасти, ДополнительныеПараметры) Экспорт
	
	Резервы =  ПрочитатьТаблицуКЗагрузке(АдресТаблицыСопоставления);
	ЗагружаемыеДанные = ПрочитатьТаблицуКЗагрузке(АдресЗагружаемыхДанных);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ДанныеДляСопоставления.ОбъектУчетаРезервов КАК СТРОКА(&НаименованиеДлина)) КАК Наименование,
	|	ДанныеДляСопоставления.Идентификатор КАК Идентификатор
	|ПОМЕСТИТЬ ДанныеДляСопоставления
	|ИЗ
	|	&ДанныеДляСопоставления КАК ДанныеДляСопоставления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(СправочникДляСопоставления.Ссылка) КАК ОбъектУчетаРезервов,
	|	ДанныеДляСопоставленияПоНаименованию.Идентификатор,
	|	КОЛИЧЕСТВО(ДанныеДляСопоставленияПоНаименованию.Идентификатор) КАК Количество
	|ИЗ
	|	ДанныеДляСопоставления КАК ДанныеДляСопоставленияПоНаименованию
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыУчетаРезервовПредстоящихРасходов КАК СправочникДляСопоставления
	|		ПО (СправочникДляСопоставления.Наименование = ДанныеДляСопоставленияПоНаименованию.Наименование)
	|			И НЕ СправочникДляСопоставления.ЭтоГруппа
	|ГДЕ
	|	НЕ СправочникДляСопоставления.Ссылка ЕСТЬ NULL
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДляСопоставленияПоНаименованию.Идентификатор";
	
	НаименованиеДлина = Метаданные.Справочники.ОбъектыУчетаРезервовПредстоящихРасходов.ДлинаНаименования;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&НаименованиеДлина", НаименованиеДлина); 
	
	Запрос.УстановитьПараметр("ДанныеДляСопоставления", ЗагружаемыеДанные);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаРезультата = РезультатЗапроса.Выгрузить();
	
	Для каждого СтрокаТаблицы Из ЗагружаемыеДанные Цикл 
		
		НоваяСтрока = Резервы.Добавить();
		НоваяСтрока.Идентификатор = СтрокаТаблицы.Идентификатор;
		
		СтрокаРезультата = ТаблицаРезультата.Найти(СтрокаТаблицы.Идентификатор, "Идентификатор");
		Если СтрокаРезультата <> Неопределено Тогда 
			Если СтрокаРезультата.Количество = 1 Тогда 
				НоваяСтрока.ОбъектУчетаРезервов  = СтрокаРезультата.ОбъектУчетаРезервов;
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы,, "Идентификатор,ОбъектУчетаРезервов");
			ИначеЕсли СтрокаРезультата.Количество > 1 Тогда 
				ЗаписьОНеоднозначности = СписокНеоднозначностей.Добавить();
				ЗаписьОНеоднозначности.Идентификатор = СтрокаТаблицы.Идентификатор; 
				ЗаписьОНеоднозначности.Колонка = "ОбъектУчетаРезервов";
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Резервы, АдресТаблицыСопоставления);
	
КонецПроцедуры

// Описание
// 
// Параметры:
// 	ПолноеИмяТабличнойЧасти - Строка - полное имя табличной части, в которую загружаются данные.
// 	СписокНеоднозначностей - Массив, ТаблицаЗначений - Список для заполнения с неоднозначными данными. Колонки:
//     * Идентификатор        - Число  - Уникальный идентификатор строки.
//     * Колонка              - Строка -  Имя колонки с возникшей неоднозначностью.
// 	ИмяКолонки - Строка - имя колонки, в который возникла неоднозначность.
// 	ЗагружаемыеЗначенияСтрока - Строка - Загружаемые данные на основании которых возникла неоднозначность.
// 	ДополнительныеПараметры - Структура -
Процедура ЗаполнитьСписокНеоднозначностей(ПолноеИмяТабличнойЧасти, СписокНеоднозначностей, ИмяКолонки, ЗагружаемыеЗначенияСтрока, ДополнительныеПараметры) Экспорт
	
	Если ИмяКолонки = "ОбъектУчетаРезервов" Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОбъектыУчетаРезервов.Ссылка
		|ИЗ
		|	Справочник.ОбъектыУчетаРезервовПредстоящихРасходов КАК ОбъектыУчетаРезервов
		|ГДЕ
		|	ОбъектыУчетаРезервов.Наименование = &Наименование";
		Запрос.УстановитьПараметр("Наименование", ЗагружаемыеЗначенияСтрока.ОбъектУчетаРезервов);
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			СписокНеоднозначностей.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает таблицу, переданную через временное хранилище
// 
// Параметры:
// 	АдресВременногоХранилища - Строка - адрес хранилища, в котором лежит таблица
// Возвращаемое значение:
// 	ТаблицаЗначений - таблица с колонками:
// 		* Идентификатор - Число - порядковый номер.
// 		Остальные колонки.
Функция ПрочитатьТаблицуКЗагрузке(АдресВременногоХранилища)
	Возврат ПолучитьИзВременногоХранилища(АдресВременногоХранилища); // ТаблицаЗначений
КонецФункции

#КонецОбласти

#КонецОбласти


#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Документы.НачислениеСписаниеРезервовПредстоящихРасходов.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.5.1";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("88aef98e-7831-441e-90d3-b69e90bd950b");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Документы.НачислениеСписаниеРезервовПредстоящихРасходов.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет реквизит %1 в табличных частях.';
									|en = 'Populates attribute %1 in tabular sections.'");
	Обработчик.Комментарий = СтрШаблон(Обработчик.Комментарий, "ИдентификаторСтроки");

	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.НачислениеСписаниеРезервовПредстоящихРасходов.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Документы.НачислениеСписаниеРезервовПредстоящихРасходов.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");

КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = ПустаяСсылка().Метаданные().ПолноеИмя();
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Дата УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Дата УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Документ.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.НачислениеСписаниеРезервовПредстоящихРасходов КАК Документ
	|ГДЕ
	|	ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			Документ.НачислениеСписаниеРезервовПредстоящихРасходов.Резервы КАК ТабЧасть
	|		ГДЕ
	|			ТабЧасть.Ссылка = Документ.Ссылка
	|			И ТабЧасть.ИдентификаторСтроки = """")";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = ПустаяСсылка().Метаданные().ПолноеИмя();
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	Для Каждого Документ Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		
		Попытка
			Ссылка = Документ.Ссылка;
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			ДокументОбъект = Ссылка.ПолучитьОбъект();
			
			Если ДокументОбъект <> Неопределено Тогда
				ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ДокументОбъект, "Резервы");
			КонецЕсли;
			
			Если ДокументОбъект <> Неопределено И ДокументОбъект.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Ссылка);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Документ.Ссылка);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
