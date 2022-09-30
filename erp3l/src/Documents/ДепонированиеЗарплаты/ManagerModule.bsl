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
	
	МеханизмыДокумента.Добавить("ИнтеграцияБЗК");
	//++ НЕ УТКА
	МеханизмыДокумента.Добавить("МеждународныйУчет");
	//-- НЕ УТКА
	МеханизмыДокумента.Добавить("РегламентированныйУчет");
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
		
		ТекстЗапросаТаблицаДвиженияПоПрочимАктивамПассивам(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаОплатаВедомостейНаВыплатуЗарплаты(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаПрочиеАктивыПассивы(Запрос, ТекстыЗапроса, Регистры);
		РеглУчетПроведениеСервер.ТекстЗапросаТаблицаОтражениеДокументовВРеглУчете(Запрос, ТекстыЗапроса, Регистры);
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
	
	НоваяКоманда = Документы.РасходныйКассовыйОрдер.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Добавляет команду создания документа "Депонирование зарплаты".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ДепонированиеЗарплаты) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ДепонированиеЗарплаты.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = НСтр("ru = 'Депонирование заработной платы';
														|en = 'Salary depositing'");
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьЗаявкиНаРасходованиеДенежныхСредств";
		
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

// Процедура заполняет массивы реквизитов, зависимых от функциональных опций.
//
// Параметры:
//	МассивВсехРеквизитов - Массив - Массив всех имен реквизитов, зависимых от хозяйственной операции
//	МассивРеквизитовОперации - Массив - Массив имен реквизитов, используемых в выбранной хозяйственной операции.
//
Процедура ЗаполнитьИменаРеквизитовПоКонтексту(МассивВсехРеквизитов, МассивРеквизитовОперации) Экспорт
	
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("ДепонентыЗаполнить");
	
	МассивРеквизитовОперации = Новый Массив;
	
	Если Константы.ИспользоватьНачислениеЗарплаты.Получить() Тогда
		МассивРеквизитовОперации.Добавить("ДепонентыЗаполнить");
	КонецЕсли;
	
КонецПроцедуры

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт
	
	// Дт 70 :: Кт 76.04
	
	ТекстДепонирование = "
	|ВЫБРАТЬ
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	Строки.Сумма КАК Сумма,
	|	Строки.Сумма / КурсВалютыУпрУчета.Курс КАК СуммаУУ,
	|
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеДт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыСПерсоналомПоОплатеТруда) КАК СчетДт,
	|	ВЫБОР КОГДА Операция.ПроводкиПоРаботникам
	|		ТОГДА Строки.ФизическоеЛицо
	|	ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеКт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоДепонированнымСуммам) КАК СчетКт,
	|	Строки.ФизическоеЛицо КАК СубконтоКт1,
	|	Операция.Ссылка КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Депонирование заработной платы"" КАК Содержание
	|
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ДепонированиеЗарплаты КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ 
	|		Документ.ДепонированиеЗарплаты.Депоненты КАК Строки
	|	ПО 
	|		Операция.Ссылка = Строки.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		КурсыВалют КАК КурсВалютыУпрУчета
	|	ПО
	|		КурсВалютыУпрУчета.Валюта = &ВалютаУпрУчета
	|		И КурсВалютыУпрУчета.Дата = НАЧАЛОПЕРИОДА(Операция.Дата, День)
	|";
	
	Возврат ТекстДепонирование;
	
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса временной таблицы.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	
	ТекстЗапроса = "";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Процедура заполняет субконто на счете 76.04 Расчеты по депонированным суммам
//
Процедура НастроитьАналитикуПоДепонированнойЗарплате() Экспорт
	
	СчетОбъект = ПланыСчетов.Хозрасчетный.РасчетыПоДепонированнымСуммам.ПолучитьОбъект();
	Субконто2 = СчетОбъект.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Депонирования, "ВидСубконто");
	Если Субконто2 = Неопределено Тогда
		НовыйВид = СчетОбъект.ВидыСубконто.Добавить();
		НовыйВид.ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Депонирования;
		НовыйВид.Суммовой    = Истина;
		Попытка
			СчетОбъект.Записать();
		Исключение
			ТекстСообщения = НСтр("ru = 'Установка субконто на счете 76.04 не выполнена по причине: %Причина%';
									|en = 'Extra dimension is not set for account 76.04 due to: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.ПланыСчетов.Хозрасчетный, ПланыСчетов.Хозрасчетный.РасчетыПоДепонированнымСуммам, ТекстСообщения);
		КонецПопытки
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДепонированиеЗарплаты.Дата КАК Период,
	|	ДепонированиеЗарплаты.Организация КАК Организация,
	|	ДепонированиеЗарплаты.Ведомость КАК Ведомость
	|ИЗ
	|	Документ.ДепонированиеЗарплаты КАК ДепонированиеЗарплаты
	|ГДЕ
	|	ДепонированиеЗарплаты.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",                                 Реквизиты.Период);
	Запрос.УстановитьПараметр("Ссылка",                                 ДокументСсылка);
	Запрос.УстановитьПараметр("Организация",                            Реквизиты.Организация);
	Запрос.УстановитьПараметр("Ведомость",                              Реквизиты.Ведомость);
	Запрос.УстановитьПараметр("ИспользоватьНачислениеЗарплаты",         Константы.ИспользоватьНачислениеЗарплаты.Получить());
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",                  Перечисления.ХозяйственныеОперации.ДепонированиеЗарплаты);
	Запрос.УстановитьПараметр("Валюта",                                 Константы.ВалютаРегламентированногоУчета.Получить());
	Запрос.УстановитьПараметр("ИспользоватьУчетПрочихАктивовПассивов",  ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихАктивовПассивов"));
	Запрос.УстановитьПараметр("НастройкаХозяйственнойОперации",         Справочники.НастройкиХозяйственныхОпераций.ДепонированиеЗарплаты);
	Запрос.УстановитьПараметр("ИдентификаторФинЗаписи",                 ДокументСсылка.УникальныйИдентификатор());
	
КонецПроцедуры

Функция ТекстЗапросаВТДанныеВедомостей(Запрос, ТекстыЗапроса)
	
	ИмяВременнойТаблицы = "ТаблицаДанныеВедомостей";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Зарплата.Ссылка КАК Ведомость,
	|	Зарплата.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СУММА(Зарплата.КВыплате) КАК Сумма
	|ПОМЕСТИТЬ ТаблицаДанныеВедомостей
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВКассу.Зарплата КАК Зарплата
	|ГДЕ
	|	&ИспользоватьНачислениеЗарплаты
	|	И Зарплата.Ссылка = &Ведомость
	|	И Зарплата.Сотрудник.ФизическоеЛицо В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				Депоненты.ФизическоеЛицо
	|			ИЗ
	|				Документ.ДепонированиеЗарплаты.Депоненты КАК Депоненты
	|			ГДЕ
	|				Депоненты.Ссылка = &Ссылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	Зарплата.Ссылка,
	|	Зарплата.ФизическоеЛицо
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Зарплата.Ссылка,
	|	Зарплата.ФизическоеЛицо,
	|	СУММА(Зарплата.КВыплате)
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыРаздатчиком.Зарплата КАК Зарплата
	|ГДЕ
	|	&ИспользоватьНачислениеЗарплаты
	|	И Зарплата.Ссылка = &Ведомость
	|	И Зарплата.ФизическоеЛицо В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				Депоненты.ФизическоеЛицо
	|			ИЗ
	|				Документ.ДепонированиеЗарплаты.Депоненты КАК Депоненты
	|			ГДЕ
	|				Депоненты.Ссылка = &Ссылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	Зарплата.Ссылка,
	|	Зарплата.ФизическоеЛицо
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НЕОПРЕДЕЛЕНО,
	|	Депоненты.ФизическоеЛицо,
	|	СУММА(Депоненты.Сумма)
	|ИЗ
	|	Документ.ДепонированиеЗарплаты.Депоненты КАК Депоненты
	|ГДЕ
	|	НЕ &ИспользоватьНачислениеЗарплаты
	|	И Депоненты.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Депоненты.ФизическоеЛицо";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяВременнойТаблицы);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаОплатаВедомостейНаВыплатуЗарплаты(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОплатаВедомостейНаВыплатуЗарплаты";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	Если НЕ ПроведениеДокументов.ЕстьТаблицаЗапроса("ТаблицаДанныеВедомостей", ТекстыЗапроса) Тогда
		ТекстЗапросаВТДанныеВедомостей(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&Период                                КАК ДатаПлатежа,
	|	&Организация                           КАК Организация,
	|	ТаблицаДанныеВедомостей.Ведомость      КАК Ведомость,
	|	ТаблицаДанныеВедомостей.ФизическоеЛицо КАК ФизическоеЛицо
	|ИЗ
	|	ТаблицаДанныеВедомостей КАК ТаблицаДанныеВедомостей
	|ГДЕ
	|	&ИспользоватьНачислениеЗарплаты";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПрочиеАктивыПассивы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеАктивыПассивы";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельности,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ОплатаТруда) КАК Статья,
	|	НЕОПРЕДЕЛЕНО КАК Аналитика,
	|	СУММА(ВЫРАЗИТЬ(Депоненты.Сумма * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2))) КАК Сумма
	|ИЗ
	|	Документ.ДепонированиеЗарплаты.Депоненты КАК Депоненты
	|ГДЕ
	|	Депоненты.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	|	&Организация,
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельности,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ДепонированнаяЗарплата),
	|	Депоненты.ФизическоеЛицо,
	|	СУММА(ВЫРАЗИТЬ(Депоненты.Сумма * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2)))
	|ИЗ
	|	Документ.ДепонированиеЗарплаты.Депоненты КАК Депоненты
	|ГДЕ
	|	Депоненты.Ссылка = &Ссылка
	|	
	|СГРУППИРОВАТЬ ПО
	|	Депоненты.ФизическоеЛицо";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДвиженияПоПрочимАктивамПассивам(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияПоПрочимАктивамПассивам";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельности,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ОплатаТруда) КАК Статья,
	|	НЕОПРЕДЕЛЕНО КАК Аналитика,
	|	ЗНАЧЕНИЕ(Справочник.НастройкиСчетовУчетаПрочихОпераций.ПустаяСсылка) КАК НастройкаСчетовУчета,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийПрочихАктивовПассивов.Дебет) КАК ДебетКредит,
	|
	|	СУММА(Депоненты.Сумма) КАК СуммаРегл,
	|	СУММА(ВЫРАЗИТЬ(Депоненты.Сумма * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2))) КАК СуммаУпр,
	|	СУММА(ВЫРАЗИТЬ(Депоненты.Сумма * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2))) КАК СуммаСНДС,
	|	СУММА(ВЫРАЗИТЬ(Депоненты.Сумма * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2))) КАК СуммаБезНДС,
	|
	|	&ИдентификаторФинЗаписи КАК ИдентификаторФинЗаписи,
	|	&НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации
	|ИЗ
	|	Документ.ДепонированиеЗарплаты.Депоненты КАК Депоненты
	|ГДЕ
	|	Депоненты.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельности,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ДепонированнаяЗарплата) КАК Статья,
	|	Депоненты.ФизическоеЛицо КАК Аналитика,
	|	ЗНАЧЕНИЕ(Справочник.НастройкиСчетовУчетаПрочихОпераций.ПустаяСсылка) КАК НастройкаСчетовУчета,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийПрочихАктивовПассивов.Кредит) КАК ДебетКредит,
	|
	|	СУММА(Депоненты.Сумма) КАК СуммаРегл,
	|	СУММА(ВЫРАЗИТЬ(Депоненты.Сумма * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2))) КАК СуммаУпр,
	|	СУММА(ВЫРАЗИТЬ(Депоненты.Сумма * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2))) КАК СуммаСНДС,
	|	СУММА(ВЫРАЗИТЬ(Депоненты.Сумма * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2))) КАК СуммаБезНДС,
	|
	|	&ИдентификаторФинЗаписи КАК ИдентификаторФинЗаписи,
	|	&НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации
	|ИЗ
	|	Документ.ДепонированиеЗарплаты.Депоненты КАК Депоненты
	|ГДЕ
	|	Депоненты.Ссылка = &Ссылка
	|СГРУППИРОВАТЬ ПО
	|	Депоненты.ФизическоеЛицо";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос)
	
	Если Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуУпр") Тогда
		Возврат;
	КонецЕсли;
	
	Коэффициенты = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентыПересчетаВалюты(
		Запрос.Параметры.Валюта,
		Запрос.Параметры.Валюта,
		Запрос.Параметры.Период,
		Запрос.Параметры.Организация);
	
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуУпр", Коэффициенты.КоэффициентПересчетаВВалютуУПР);
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Печать реестра депонированных сумм
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "РеестрДепонированныхСумм";
	КомандаПечати.Представление = НСтр("ru = 'Печать реестра депонированных сумм';
										|en = 'Print deposited amount registry'");

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РеестрДепонированныхСумм") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"РеестрДепонированныхСумм",
			НСтр("ru = 'Реестр депонированных сумм';
				|en = 'Deposited amount registry'"),
			РеестрДепонированныхСумм(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция РеестрДепонированныхСумм(МассивОбъектов, ОбъектыПечати, ИмяМакета = "Документ.ДепонированиеЗарплаты.РеестрДепонированныхСумм") Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РеестрДепонированныхСумм";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы(ИмяМакета);
	
	// получаем данные для печати
	ВыборкаШапок = ВыборкаДляПечатиШапки(МассивОбъектов);
	ВыборкаСтрок = ВыборкаДляПечатиТаблицы(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаШапок.Следующий() Цикл
		
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подсчитываем количество страниц документа - для корректного разбиения на страницы.
		ВсегоСтрокДокумента = ВыборкаСтрок.Количество();
		
		ОбластьМакетаШапкаДокумента = Макет.ПолучитьОбласть("ШапкаДокумента");
		ОбластьМакетаШапка			= Макет.ПолучитьОбласть("Шапка");
		ОбластьМакетаСтрока 		= Макет.ПолучитьОбласть("Строка");
		ОбластьМакетаИтогПоСтранице = Макет.ПолучитьОбласть("ИтогПоЛисту");
		ОбластьМакетаПодвал 		= Макет.ПолучитьОбласть("Подвал");
		
		// массив с двумя строками - для разбиения на страницы
		ВыводимыеОбласти = Новый Массив();
		ВыводимыеОбласти.Добавить(ОбластьМакетаСтрока);
		ВыводимыеОбласти.Добавить(ОбластьМакетаИтогПоСтранице);
		
		// выводим данные о документе
		ОбластьМакетаШапкаДокумента.Параметры.Заполнить(ВыборкаШапок);
		ОбластьМакетаШапкаДокумента.Параметры.ДатаДокумента	= Формат(ВыборкаШапок.Дата, "ДЛФ=D");
		
		ТабличныйДокумент.Вывести(ОбластьМакетаШапкаДокумента);
		ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
		
		ВыведеноСтраниц = 1; ВыведеноСтрок = 0; ИтогоНаСтранице = 0; Итого = 0;
		// выводим данные по строкам документа.
		ВыборкаСтрок.Сбросить();
		Пока ВыборкаСтрок.НайтиСледующий(ВыборкаШапок.Депонирование, "Депонирование") Цикл
			
			ОбластьМакетаСтрока.Параметры.Заполнить(ВыборкаСтрок);
			
			ОбластьМакетаСтрока.Параметры.ФизическоеЛицо = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 %2 %3';
					|en = '%1 %2 %3'"), ВыборкаСтрок.Фамилия, ВыборкаСтрок.Имя, ВыборкаСтрок.Отчество);
			
			// разбиение на страницы
			ВыведеноСтрок = ВыведеноСтрок + 1;
			
			// Проверим, уместится ли строка на странице или надо открывать новую страницу
			ВывестиПодвалЛиста = Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ВыводимыеОбласти);
			Если Не ВывестиПодвалЛиста И ВыведеноСтрок = ВсегоСтрокДокумента Тогда
				ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
				ВывестиПодвалЛиста = Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ВыводимыеОбласти);
			КонецЕсли;
			Если ВывестиПодвалЛиста Тогда
				
				ОбластьМакетаИтогПоСтранице.Параметры.ИтогоНаСтранице = ИтогоНаСтранице;
				ТабличныйДокумент.Вывести(ОбластьМакетаИтогПоСтранице);
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
				ВыведеноСтраниц = ВыведеноСтраниц + 1;
				ИтогоНаСтранице = 0;
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакетаСтрока);
			ИтогоНаСтранице = ИтогоНаСтранице + ВыборкаСтрок.Сумма;
			Итого = Итого + ВыборкаСтрок.Сумма;
			
		КонецЦикла;
		
		Если ВыведеноСтрок > 0 Тогда 
			ОбластьМакетаИтогПоСтранице.Параметры.ИтогоНаСтранице = ИтогоНаСтранице;
		КонецЕсли;
		
		ВыводимыеОбласти = Новый Массив();
		ВыводимыеОбласти.Добавить(ОбластьМакетаСтрока);
		ВыводимыеОбласти.Добавить(ОбластьМакетаИтогПоСтранице);
		ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
		Для Сч = 1 По ОбластьМакетаСтрока.Параметры.Количество() Цикл
			ОбластьМакетаСтрока.Параметры.Установить(Сч - 1,""); 
		КонецЦикла;
		ОбластьМакетаСтрока.Параметры.ФизическоеЛицо = " ";
		Пока ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ВыводимыеОбласти) Цикл
			ТабличныйДокумент.Вывести(ОбластьМакетаСтрока);
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ОбластьМакетаИтогПоСтранице);
		
		ОбластьМакетаПодвал.Параметры.Заполнить(ВыборкаШапок);
		
		ОбластьМакетаПодвал.Параметры.Итого = Итого;
		ТабличныйДокумент.Вывести(ОбластьМакетаПодвал);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаШапок.Ссылка);
		
	КонецЦикла; // по документам
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Формирует запрос по документу
//
// Параметры:
//  Депонирования - массив ДокументСсылка.ДепонированиеЗарплаты.
//
// Возвращаемое значение:
//  Результат запроса
//
Функция ВыборкаДляПечатиШапки(Депонирования)
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ОтветственныеЛицаСервер.СформироватьВременнуюТаблицуОтветственныхЛицДокументов(Депонирования, МенеджерВременныхТаблиц);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Депонирования", Депонирования);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДепонированиеЗарплаты.Ссылка КАК Депонирование,
	|	ДепонированиеЗарплаты.Ведомость КАК Ссылка,
	|	ДепонированиеЗарплаты.Дата КАК Дата,
	|	ДепонированиеЗарплаты.Ведомость.Номер КАК Номер,
	|	ДепонированиеЗарплаты.Организация КАК Организация,
	|	ВЫРАЗИТЬ(ДепонированиеЗарплаты.Организация.НаименованиеПолное КАК СТРОКА(300)) КАК НазваниеОрганизации,
	|	ВЫРАЗИТЬ(ДепонированиеЗарплаты.Организация.КодПоОКПО КАК СТРОКА(10)) КАК КодПоОКПО,
	|	ТаблицаОтветственныеЛица.ГлавныйБухгалтерНаименование КАК ГлавныйБухгалтер,
	|	ТаблицаОтветственныеЛица.БухгалтерНаименование КАК Бухгалтер,
	|	ТаблицаОтветственныеЛица.КассирНаименование КАК Кассир
	|ИЗ
	|	Документ.ДепонированиеЗарплаты КАК ДепонированиеЗарплаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОтветственныеЛица КАК ТаблицаОтветственныеЛица
	|		ПО ДепонированиеЗарплаты.Ссылка = ТаблицаОтветственныеЛица.Ссылка
	|ГДЕ
	|	ДепонированиеЗарплаты.Ссылка В(&Депонирования)";
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

// Формирует запрос по табличной части документа
//
// Параметры:
//  Ведомости - массив ДокументСсылка.ВедомостьНаВыплатуЗарплатыВБанк.
//
// Возвращаемое значение:
//  Выборка из результата запроса.
//
Функция ВыборкаДляПечатиТаблицы(Депонирования)
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Депонирования", Депонирования);
	
	Если Константы.ИспользоватьНачислениеЗарплаты.Получить() Тогда
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ДепонированиеЗарплатыДепоненты.Ссылка КАК Депонирование,
		|	ДепонированиеЗарплатыДепоненты.Ссылка.Дата КАК Период,
		|	ВедомостьВКассуЗарплата.Ссылка КАК Ссылка,
		|	ВедомостьВКассуЗарплата.Ссылка.Номер КАК НомерВедомости,
		|	МИНИМУМ(ВедомостьВКассуЗарплата.НомерСтроки) КАК НомерСтроки,
		|	ВедомостьВКассуЗарплата.Сотрудник КАК Сотрудник,
		|	ВедомостьВКассуЗарплата.Сотрудник.Код КАК ТабельныйНомер,
		|	ВедомостьВКассуЗарплата.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
		|	СУММА(ВедомостьВКассуЗарплата.КВыплате) КАК Сумма
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.ДепонированиеЗарплаты.Депоненты КАК ДепонированиеЗарплатыДепоненты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВедомостьНаВыплатуЗарплатыВКассу.Зарплата КАК ВедомостьВКассуЗарплата
		|		ПО ДепонированиеЗарплатыДепоненты.Ссылка.Ведомость = ВедомостьВКассуЗарплата.Ссылка
		|			И ДепонированиеЗарплатыДепоненты.ФизическоеЛицо = ВедомостьВКассуЗарплата.Сотрудник.ФизическоеЛицо
		|			И (ДепонированиеЗарплатыДепоненты.Ссылка В (&Депонирования))
		|
		|СГРУППИРОВАТЬ ПО
		|	ДепонированиеЗарплатыДепоненты.Ссылка,
		|	ДепонированиеЗарплатыДепоненты.Ссылка.Дата,
		|	ВедомостьВКассуЗарплата.Ссылка,
		|	ВедомостьВКассуЗарплата.Ссылка.Номер,
		|	ВедомостьВКассуЗарплата.Сотрудник,
		|	ВедомостьВКассуЗарплата.Сотрудник.Код,
		|	ВедомостьВКассуЗарплата.Сотрудник.ФизическоеЛицо
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДепонированиеЗарплатыДепоненты.Ссылка,
		|	ДепонированиеЗарплатыДепоненты.Ссылка.Дата,
		|	ВедомостьРаздатчикомЗарплата.Ссылка,
		|	ВедомостьРаздатчикомЗарплата.Ссылка.Номер,
		|	МИНИМУМ(ВедомостьРаздатчикомЗарплата.НомерСтроки),
		|	ВедомостьРаздатчикомЗарплата.Сотрудник,
		|	ВедомостьРаздатчикомЗарплата.Сотрудник.Код,
		|	ВедомостьРаздатчикомЗарплата.Сотрудник.ФизическоеЛицо,
		|	СУММА(ВедомостьРаздатчикомЗарплата.КВыплате)
		|ИЗ
		|	Документ.ДепонированиеЗарплаты.Депоненты КАК ДепонированиеЗарплатыДепоненты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВедомостьНаВыплатуЗарплатыРаздатчиком.Зарплата КАК ВедомостьРаздатчикомЗарплата
		|		ПО ДепонированиеЗарплатыДепоненты.Ссылка.Ведомость = ВедомостьРаздатчикомЗарплата.Ссылка
		|			И ДепонированиеЗарплатыДепоненты.ФизическоеЛицо = ВедомостьРаздатчикомЗарплата.Сотрудник.ФизическоеЛицо
		|			И (ДепонированиеЗарплатыДепоненты.Ссылка В (&Депонирования))
		|
		|СГРУППИРОВАТЬ ПО
		|	ДепонированиеЗарплатыДепоненты.Ссылка,
		|	ДепонированиеЗарплатыДепоненты.Ссылка.Дата,
		|	ВедомостьРаздатчикомЗарплата.Ссылка,
		|	ВедомостьРаздатчикомЗарплата.Ссылка.Номер,
		|	ВедомостьРаздатчикомЗарплата.Сотрудник,
		|	ВедомостьРаздатчикомЗарплата.Сотрудник.Код,
		|	ВедомостьРаздатчикомЗарплата.Сотрудник.ФизическоеЛицо";
		
		Запрос.Выполнить();
		
		ОписательВременныхТаблиц = 
		КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
			Запрос.МенеджерВременныхТаблиц,
			"ВТДанныеДокументов");
			КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Истина, "Фамилия, Имя, Отчество, Подразделение");
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеДокументов.Депонирование КАК Депонирование,
		|	ДанныеДокументов.Ссылка КАК Ведомость,
		|	ДанныеДокументов.НомерСтроки КАК НомерСтроки,
		|	КадровыеДанныеСотрудников.Подразделение КАК Подразделение,
		|	ДанныеДокументов.НомерВедомости КАК НомерВедомости,
		|	ДанныеДокументов.ТабельныйНомер КАК ТабельныйНомер,
		|	КадровыеДанныеСотрудников.Фамилия КАК Фамилия,
		|	КадровыеДанныеСотрудников.Имя КАК Имя,
		|	КадровыеДанныеСотрудников.Отчество КАК Отчество,
		|	ДанныеДокументов.Сумма КАК Сумма
		|ИЗ
		|	ВТДанныеДокументов КАК ДанныеДокументов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
		|		ПО ДанныеДокументов.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
		|
		|УПОРЯДОЧИТЬ ПО
		|	Депонирование,
		|	Ведомость,
		|	НомерСтроки";
		
	Иначе
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ДепонированиеЗарплатыДепоненты.Ссылка КАК Депонирование,
		|	ДепонированиеЗарплатыДепоненты.Ссылка КАК Ведомость,
		|	ДепонированиеЗарплатыДепоненты.НомерСтроки КАК НомерСтроки,
		|	"""" КАК Подразделение,
		|	ДепонированиеЗарплатыДепоненты.Ссылка.Номер КАК НомерВедомости,
		|	"""" КАК ТабельныйНомер,
		|	ФИОФизическихЛицСрезПоследних.Фамилия,
		|	ФИОФизическихЛицСрезПоследних.Имя,
		|	ФИОФизическихЛицСрезПоследних.Отчество,
		|	ДепонированиеЗарплатыДепоненты.Сумма
		|ИЗ
		|	Документ.ДепонированиеЗарплаты.Депоненты КАК ДепонированиеЗарплатыДепоненты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизическихЛиц.СрезПоследних КАК ФИОФизическихЛицСрезПоследних
		|		ПО ДепонированиеЗарплатыДепоненты.ФизическоеЛицо = ФИОФизическихЛицСрезПоследних.ФизическоеЛицо
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ведомость,
		|	НомерСтроки";
		
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

#КонецОбласти

#КонецЕсли
