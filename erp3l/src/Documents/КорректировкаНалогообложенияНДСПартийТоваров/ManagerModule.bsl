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
	МеханизмыДокумента.Добавить("ОперативныйУчетТоваровОрганизаций");
	//++ НЕ УТ
	МеханизмыДокумента.Добавить("РегламентированныйУчет");
	//-- НЕ УТ
	МеханизмыДокумента.Добавить("СебестоимостьИПартионныйУчет");
	МеханизмыДокумента.Добавить("УчетПрочихАктивовПассивов");
	
КонецПроцедуры

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  Структура - коллекция элементов:
//     * Таблица<ИмяРегистра> - ТаблицаЗначений - таблица данных для отражения в регистр.
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
		
		ТекстЗапросаТаблицаТоварыОрганизаций(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаСебестоимостьТоваров(Запрос, ТекстыЗапроса, Регистры);
		
		РасчетСебестоимостиПроведениеДокументов.ОтразитьВМеханизмеУчетаЗатратИСебестоимости(Документ, Запрос, ТекстыЗапроса, Регистры);
		
		//++ НЕ УТ
		РеглУчетПроведениеСервер.ТекстЗапросаТаблицаОтражениеДокументовВРеглУчете(Запрос, ТекстыЗапроса, Регистры);
		//-- НЕ УТ
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

#КонецОбласти

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Добавляет команду создания документа "Корректировка налогообложения НДС".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.КорректировкаНалогообложенияНДСПартийТоваров) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.КорректировкаНалогообложенияНДСПартийТоваров.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.КорректировкаНалогообложенияНДСПартийТоваров);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
КонецПроцедуры

#Область ЗакрытиеМесяца

// Процедура отменяет проведение документов "Корректировка налогообложения НДС товаров".
//
// Параметры:
// 	ПериодРегистрации - Дата - Месяц регистрации документа корректировки.
//
Процедура ОтменитьКорректировкуНалогообложенияНДС(ПериодРегистрации) Экспорт
	
	ПартионныйУчетВключен  = РасчетСебестоимостиПовтИсп.ПартионныйУчетВключен(НачалоМесяца(ПериодРегистрации));
	ПоследнийМесяцКвартала = (КонецКвартала(ПериодРегистрации) = КонецМесяца(ПериодРегистрации));
	Если НЕ (ПартионныйУчетВключен И ПоследнийМесяцКвартала) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Операция.Ссылка
	|ИЗ
	|	Документ.КорректировкаНалогообложенияНДСПартийТоваров КАК Операция
	|ГДЕ
	|	Операция.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И Операция.Проведен
	|");
	Запрос.УстановитьПараметр("ДатаНачала",    НачалоМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(ПериодРегистрации));
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ДокументОбъект.ДополнительныеСвойства.Вставить(РасчетСебестоимостиПрикладныеАлгоритмы.ИмяСлужебногоДополнительногоСвойстваОбъекта());
		ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	КонецЦикла;
	
КонецПроцедуры

// Процедура анализирует необходимость формирования документов по корректировке налогообложения НДС
// для партий товаров с истекающим периодом принятия НДС к вычету
// (для налогообложения по фактическому использованию).
//
// Параметры:
//	ПериодРегистрации - Дата - закрываемый месяц
//	СозданаКорректировка - Булево - В параметр устанавливается признак, что корректировка выполнена.
//
Процедура СкорректироватьНалогообложениеНДС(ПериодРегистрации, СозданаКорректировка) Экспорт
	
	ПартионныйУчетВключен  = РасчетСебестоимостиПовтИсп.ПартионныйУчетВключен(НачалоМесяца(ПериодРегистрации));
	ПоследнийМесяцКвартала = (КонецКвартала(ПериодРегистрации) = КонецМесяца(ПериодРегистрации));
	
	// Формируем документ в последнем месяце отчетного периода и только при партионном учете.
	Если НЕ (ПартионныйУчетВключен И ПоследнийМесяцКвартала) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	СпрОрганизации.Ссылка КАК Организация
	|ПОМЕСТИТЬ НДСПоФактическомуИспользованию
	|ИЗ
	|	РегистрСведений.НастройкиУчетаНДС.СрезПоследних(&ДатаОкончания) КАК ДанныеРегистра
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК СпрОрганизации
	|		ПО СпрОрганизации.ГоловнаяОрганизация = ДанныеРегистра.Организация
	|ГДЕ
	|	ДанныеРегистра.ПрименяетсяУчетНДСПоФактическомуИспользованию
	|;
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	тПартии.Организация	КАК Организация,
	|	ИСТИНА				КАК ФормироватьДвижения
	|ПОМЕСТИТЬ ВтПартии
	|	
	|ИЗ (
	|	ВЫБРАТЬ
	|		Остатки.Организация						КАК Организация,
	|		Остатки.АналитикаУчетаНоменклатуры		КАК АналитикаУчетаНоменклатуры,
	|		Остатки.ДокументПоступления				КАК ДокументПоступления,
	|		Остатки.ВидЗапасов						КАК ВидЗапасов,
	|		Остатки.АналитикаУчетаПартий			КАК АналитикаУчетаПартий,
	|		Остатки.КоличествоОстаток				КАК Количество
	|	ИЗ
	|		РегистрНакопления.ПартииТоваровОрганизаций.Остатки(&НачалоСледКвартала,
	|			Организация В (
	|			ВЫБРАТЬ
	|				НДСПоФактическомуИспользованию.Организация
	|			ИЗ
	|				НДСПоФактическомуИспользованию КАК НДСПоФактическомуИспользованию
	|			)
	|		) КАК Остатки
	|	
	|		// Дата документа поступления должны быть в определенном диапазоне
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			РегистрНакопления.ПартииТоваровОрганизаций КАК Партии
	|		ПО
	|			Партии.Период МЕЖДУ &НачПериода И &КонПериода
	|			И Партии.Регистратор = Остатки.ДокументПоступления
	|			И Партии.Регистратор = Партии.ДокументПоступления
	|			И Партии.АналитикаУчетаПартий <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПартий.ПустаяСсылка)
	|	
	|		// Аналитика учета партий должны быть с налогообложением по фактическому использованию
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			РегистрСведений.АналитикаУчетаПартий КАК АУП
	|		ПО
	|			АУП.КлючАналитики = Остатки.АналитикаУчетаПартий
	|			И АУП.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПоФактическомуИспользованию)
	|	ГДЕ
	|		Остатки.КоличествоОстаток > 0
	|
	|) КАК тПартии
	|
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Организации.Ссылка							КАК Организация,
	|	ЕСТЬNULL(Партии.ФормироватьДвижения, ЛОЖЬ)	КАК ФормироватьДвижения,
	|	ЕСТЬNULL(КорНДС.Проведен, ЛОЖЬ)				КАК Проведен,
	|	ЕСТЬNULL(КорНДС.Ссылка, НЕОПРЕДЕЛЕНО)		КАК Ссылка
	|ИЗ
	|	Справочник.Организации КАК Организации
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ВтПартии КАК Партии
	|	ПО
	|		Организации.Ссылка = Партии.Организация
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Документ.КорректировкаНалогообложенияНДСПартийТоваров КАК КорНДС
	|	ПО
	|		Организации.Ссылка = КорНДС.Организация
	|		И КорНДС.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|		И НЕ КорНДС.ПометкаУдаления
	|
	|ГДЕ
	|	НЕ (Партии.Организация ЕСТЬ NULL И КорНДС.Организация ЕСТЬ NULL)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Партии.Организация ВОЗР,
	|	КорНДС.Проведен УБЫВ
	|");
	
	НачалоСледНалПериода = (КонецМесяца(ПериодРегистрации) + 1);
	
	Запрос.УстановитьПараметр("НачалоСледКвартала",	КонецМесяца(ПериодРегистрации) + 1);
	Запрос.УстановитьПараметр("НачПериода",			ДобавитьМесяц(НачалоСледНалПериода, -36));
	Запрос.УстановитьПараметр("КонПериода",			ДобавитьМесяц(КонецКвартала(НачалоСледНалПериода), -36));
	Запрос.УстановитьПараметр("ДатаНачала",			НачалоМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("ДатаОкончания",		КонецМесяца(ПериодРегистрации));
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	ТекОрганизация = Неопределено;
	МассивОрганизаций = Новый Массив;
	СозданаКорректировка = Ложь;
	
	Пока Выборка.Следующий() Цикл
		
		Если Не ТекОрганизация = Выборка.Организация Тогда
			ТекОрганизация = Выборка.Организация;
			МассивОрганизаций.Добавить(ТекОрганизация);
		Иначе
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.Ссылка) Тогда
			Корректировка = Выборка.Ссылка.ПолучитьОбъект();
		Иначе
			Корректировка = Документы.КорректировкаНалогообложенияНДСПартийТоваров.СоздатьДокумент();
		КонецЕсли;
		
		Корректировка.ДополнительныеСвойства.Вставить(РасчетСебестоимостиПрикладныеАлгоритмы.ИмяСлужебногоДополнительногоСвойстваОбъекта());
		
		Если Выборка.ФормироватьДвижения Тогда
			
			Корректировка.Дата = КонецКвартала(ПериодРегистрации);
			Корректировка.Организация = Выборка.Организация;
			Корректировка.ПеремещениеПодДеятельность = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
			Корректировка.Записать(РежимЗаписиДокумента.Проведение);
			
			СозданаКорректировка = Истина;
			
		ИначеЕсли Выборка.Проведен Тогда
			
			Корректировка.Записать(РежимЗаписиДокумента.ОтменаПроведения);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПроводкиРеглУчета

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт
	
	Возврат "";
	
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламентированном учете.
//
// Возвращаемое значение:
//	ТекстЗапроса - Строка - Текст запроса создания временных таблиц.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	
	Возврат ""
	
КонецФункции

#КонецОбласти

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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Корректировка.Ссылка,
	|	Корректировка.Дата,
	|	Корректировка.Организация,
	|	Корректировка.ПеремещениеПодДеятельность
	|ИЗ
	|	Документ.КорректировкаНалогообложенияНДСПартийТоваров КАК Корректировка
	|ГДЕ
	|	Корректировка.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	НачалоСледНалПериода = (КонецКвартала(Реквизиты.Дата) + 1);
	
	Запрос.УстановитьПараметр("Период",						Реквизиты.Дата);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",		Перечисления.ХозяйственныеОперации.ПеремещениеТоваров);
	Запрос.УстановитьПараметр("ПоФактИспользованию",		Перечисления.ТипыНалогообложенияНДС.ПоФактическомуИспользованию);
	Запрос.УстановитьПараметр("Организация",				Реквизиты.Организация);
	Запрос.УстановитьПараметр("ПеремещениеПодДеятельность",	Реквизиты.ПеремещениеПодДеятельность);
	Запрос.УстановитьПараметр("НачПериода",					ДобавитьМесяц(НачалоСледНалПериода, -36));
	Запрос.УстановитьПараметр("КонПериода",					КонецКвартала(ДобавитьМесяц(НачалоСледНалПериода, -36)));
	
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
КонецПроцедуры

Функция ТекстЗапросаВтВидыЗапасов(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтВидыЗапасов";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Организация КАК Организация,
	|	ВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ВЫБОР
	|		КОГДА &ПартионныйУчетВерсии22
	|			ТОГДА ВидыЗапасов.ВидЗапасов
	|		ИНАЧЕ ВидыЗапасов.ВидЗапасовПолучателя
	|	КОНЕЦ КАК ВидЗапасовПолучателя,
	|	ВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Серия КАК Серия,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.МестоХранения КАК Склад,
	|	ВидыЗапасов.ДокументПоступления КАК ДокументПоступления,
	|	ВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ВидыЗапасов.Стоимость КАК Стоимость,
	|	ВидыЗапасов.СтоимостьБезНДС КАК СтоимостьБезНДС,
	|	ВидыЗапасов.СтоимостьРегл КАК СтоимостьРегл,
	|	ВидыЗапасов.НДСРегл КАК НДСРегл,
	|	ВидыЗапасов.ПостояннаяРазница КАК ПостояннаяРазница,
	|	ВидыЗапасов.ВременнаяРазница КАК ВременнаяРазница,
	|	ВидыЗапасов.Количество КАК Количество,
	|	ВидыЗапасов.Количество КАК КоличествоПоРНПТ
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	Документ.КорректировкаНалогообложенияНДСПартийТоваров.ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	ВидыЗапасов.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаТоварыОрганизаций(Запрос, ТекстыЗапроса, Регистры)
	ИмяРегистра = "ТоварыОрганизаций";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	Если НЕ ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтВидыЗапасов", ТекстыЗапроса) Тогда
		ТекстЗапросаВтВидыЗапасов(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	1													КАК Порядок,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)				КАК ВидДвижения,
	|	&Период												КАК Период,
	|	&Организация										КАК Организация,
	|	&Организация										КАК ОрганизацияОтгрузки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры		КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.Номенклатура						КАК Номенклатура,
	|	ТаблицаВидыЗапасов.Характеристика					КАК Характеристика,
	|	ТаблицаВидыЗапасов.ВидЗапасов						КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.Количество						КАК Количество,
	|	ТаблицаВидыЗапасов.КоличествоПоРНПТ					КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.НомерГТД							КАК НомерГТД,
	|	&ХозяйственнаяОперация								КАК ХозяйственнаяОперация,
	|	&ПеремещениеПодДеятельность							КАК НалогообложениеНДС,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры		КАК КорАналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасовПолучателя				КАК КорВидЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|ГДЕ
	|	НЕ &ПартионныйУчетВерсии22
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2													КАК Порядок,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)				КАК ВидДвижения,
	|	&Период												КАК Период,
	|	&Организация										КАК Организация,
	|	&Организация										КАК ОрганизацияОтгрузки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры		КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.Номенклатура						КАК Номенклатура,
	|	ТаблицаВидыЗапасов.Характеристика					КАК Характеристика,
	|	ТаблицаВидыЗапасов.ВидЗапасовПолучателя				КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.Количество						КАК Количество,
	|	ТаблицаВидыЗапасов.КоличествоПоРНПТ					КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.НомерГТД							КАК НомерГТД,
	|	&ХозяйственнаяОперация								КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО										КАК НалогообложениеНДС,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры		КАК КорАналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасов						КАК КорВидЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|ГДЕ
	|	НЕ &ПартионныйУчетВерсии22
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаСебестоимостьТоваров(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	ИмяРегистра = "СебестоимостьТоваров";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтВидыЗапасов", ТекстыЗапроса) Тогда
		ТекстЗапросаВтВидыЗапасов(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	1 КАК Порядок,
	|	ВидыЗапасов.НомерСтроки КАК НомерСтрокиДокумента,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах) КАК РазделУчета,
	|	ВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|
	|	ВидыЗапасов.Количество КАК Количество,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры,
	|	ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах) КАК КорРазделУчета,
	|	ВидыЗапасов.ВидЗапасовПолучателя КАК КорВидЗапасов,
	|
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО КАК КорОрганизация,
	|	НЕОПРЕДЕЛЕНО КАК ВидДеятельностиНДС,
	|	&ПеремещениеПодДеятельность КАК КорВидДеятельностиНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.Потребление) КАК ТипЗаписи
	|ИЗ
	|	ВтВидыЗапасов КАК ВидыЗапасов
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2 КАК Порядок,
	|	ВидыЗапасов.НомерСтроки КАК НомерСтрокиДокумента,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах) КАК РазделУчета,
	|	ВидыЗапасов.ВидЗапасовПолучателя КАК ВидЗапасов,
	|
	|	ВидыЗапасов.Количество КАК Количество,
	|	НЕОПРЕДЕЛЕНО КАК КорАналитикаУчетаНоменклатуры,
	|	НЕОПРЕДЕЛЕНО КАК КорРазделУчета,
	|
	|	НЕОПРЕДЕЛЕНО КАК КорВидЗапасов,
	|
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО КАК КорОрганизация,
	|	(ВЫБОР
	|		КОГДА &ПартионныйУчетВерсии22 ТОГДА &ПеремещениеПодДеятельность
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО КОНЕЦ) КАК ВидДеятельностиНДС,
	|	НЕОПРЕДЕЛЕНО КАК КорВидДеятельностиНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.Перемещение) КАК ТипЗаписи
	|ИЗ
	|	ВтВидыЗапасов КАК ВидыЗапасов
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок, НомерСтрокиДокумента";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

#Область ПартионныйУчет

Функция ОписаниеРегистровУчетаЗатратИСебестоимости(Документ) Экспорт
	
	ОписаниеРегистров = Новый Массив;
	ОписаниеРегистров.Добавить(Метаданные.РегистрыНакопления.СебестоимостьТоваров);
	
	Возврат ОписаниеРегистров;
	
КонецФункции

Функция УстановитьДополнительныеПараметрыОперацийУчетаЗатратИСебестоимости(Документ, Запрос = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Массив;
	
	Если Запрос <> Неопределено Тогда
		// Нет дополнительных параметров.
	КонецЕсли;
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

Функция СформироватьДополнительныеТаблицыОперацийУчетаЗатратИСебестоимости(Документ, Запрос = Неопределено, ТекстыЗапроса = Неопределено) Экспорт
	
	ДополнительныеТаблицы = Новый Массив;
	ДополнительныеТаблицы.Добавить("ВтВидыЗапасов");
	
	Если Запрос <> Неопределено Тогда
	
		Если НЕ ПроведениеДокументов.ЕстьТаблицаЗапроса(ДополнительныеТаблицы[0], ТекстыЗапроса) Тогда
			ТекстЗапросаВтВидыЗапасов(Запрос, ТекстыЗапроса);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ДополнительныеТаблицы;
	
КонецФункции

Функция ОписаниеОперацийУчетаСебестоимости(Документ) Экспорт
	
	ОписаниеОпераций = Новый Массив;
	
	#Область Перемещение_Товар
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	// Описание документа
	|	ТаблицаДокумента.Дата 	КАК Период,
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	НЕОПРЕДЕЛЕНО 			КАК КорректируемыйДокумент,
	|
	// Поля учета номенклатуры
	|	ТаблицаДокумента.Организация 					 КАК Организация,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры 	 КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасов					 КАК ВидЗапасов,
	|	ТаблицаДокумента.ПеремещениеПодДеятельность		 КАК ВидДеятельностиНДС,
	|	ТаблицаДокумента.ПеремещениеПодДеятельность	 	 КАК ВидДеятельностиНДСДокумента,
	|
	// Корреспондирующие поля
	|	НЕОПРЕДЕЛЕНО                                     КАК КорОрганизация,
	|	НЕОПРЕДЕЛЕНО 									 КАК КорПартия,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры	 КАК КорАналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасовПолучателя          КАК КорВидЗапасов,
	|
	// Поля аналитики финансового учета
	|	НЕОПРЕДЕЛЕНО 						КАК Сделка,
	|	НЕОПРЕДЕЛЕНО 						КАК Подразделение,
	|	НЕОПРЕДЕЛЕНО						КАК Менеджер,
	|	НЕОПРЕДЕЛЕНО 						КАК ГруппаПродукции,
	|
	// Количественные и суммовые показатели
	|	ТаблицаВидыЗапасов.Количество 			КАК Количество,
	|	НЕОПРЕДЕЛЕНО 							КАК ИдентификаторСтроки,
	|
	// Прочие поля
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПеремещениеТоваров) КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО 							КАК ИдентификаторФинЗаписи,
	|	НЕОПРЕДЕЛЕНО 							КАК НастройкаХозяйственнойОперации
	|
	|ИЗ
	|	Документ.КорректировкаНалогообложенияНДСПартийТоваров КАК ТаблицаДокумента
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|		ПО ИСТИНА
	|ГДЕ
	|	ТаблицаДокумента.Ссылка В (&Ссылка)
	|";
	
	РасчетСебестоимостиПроведениеДокументов.ДобавитьОписаниеОперацииДляОтраженияВУчетеСебестоимости(
		ОписаниеОпераций,
		Перечисления.ОперацииУчетаСебестоимости.Перемещение,
		ТекстЗапроса);
		
	#КонецОбласти
	
	Возврат ОписаниеОпераций;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецОбласти

#КонецЕсли
