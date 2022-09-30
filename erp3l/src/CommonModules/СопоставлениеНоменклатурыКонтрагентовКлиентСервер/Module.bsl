/////////////////////////////////////////////////////////////////////////////////////////
// СопоставлениеНоменклатурыКонтрагентовКлиентСервер:
// механизм сопоставления номенклатуры контрагентов с номенклатурой информационной базы.
//
////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает набор данных, представляющий номенклатуру информационной базы.
//
// Параметры:
//  Номенклатура   - ОпределяемыйТип.НоменклатураБЭД               - значение для инициализации выходного свойства Номенклатура.
//  Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатурыБЭД - значение для инициализации выходного свойства Характеристика.
//  Упаковка       - ОпределяемыйТип.УпаковкаНоменклатурыБЭД       - значение для инициализации выходного свойства Упаковка.
//
// Возвращаемое значение:
//  Структура - данные, представляющие номенклатуру информационной базы:
//   * Номенклатура   - ОпределяемыйТип.НоменклатураБЭД, Неопределено               - номенклатура ИБ. Неопределено, если не инициализировано.
//   * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатурыБЭД, Неопределено - характеристика номенклатуры ИБ. Неопределено, если не инициализировано.
//   * Упаковка       - ОпределяемыйТип.УпаковкаНоменклатурыБЭД, Неопределено       - упаковка номенклатуры информационной базы. Неопределено, если не инициализировано.
//
Функция НоваяНоменклатураИнформационнойБазы(Знач Номенклатура = Неопределено, Знач Характеристика = Неопределено, Знач Упаковка = Неопределено) Экспорт
	
	НоменклатураИБ = Новый Структура;
	НоменклатураИБ.Вставить("Номенклатура"  , Номенклатура);
	НоменклатураИБ.Вставить("Характеристика", Характеристика);
	НоменклатураИБ.Вставить("Упаковка"      , Упаковка);

	Возврат НоменклатураИБ;
	
КонецФункции

// Возвращает набор данных, представляющий номенклатуру контрагента информационной базы.
//
// Параметры:
//  Номенклатура   - ОпределяемыйТип.НоменклатураБЭД               - значение для инициализации выходного свойства Номенклатура.
//  Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатурыБЭД - значение для инициализации выходного свойства Характеристика.
//  Упаковка       - ОпределяемыйТип.УпаковкаНоменклатурыБЭД       - значение для инициализации выходного свойства Упаковка.
//
// Возвращаемое значение:
//  Структура - данные, представляющие номенклатуру контрагента информационной базы:
//   * Номенклатура            - ОпределяемыйТип.НоменклатураБЭД, Неопределено               - номенклатура ИБ. Неопределено, если не инициализировано.
//   * Характеристика          - ОпределяемыйТип.ХарактеристикаНоменклатурыБЭД, Неопределено - характеристика номенклатуры ИБ. Неопределено, если не инициализировано.
//   * Упаковка                - ОпределяемыйТип.УпаковкаНоменклатурыБЭД, Неопределено       - упаковка номенклатуры информационной базы. Неопределено, если не инициализировано.
//   * НоменклатураКонтрагента - СправочникСсылка.НоменклатураКонтрагентов                   - ссылка номенклатуры контрагентов.
//
Функция НоваяНоменклатураКонтрагентаИнформационнойБазы(Знач Номенклатура = Неопределено, Знач Характеристика = Неопределено, Знач Упаковка = Неопределено) Экспорт
	
	НоменклатураИБ = Новый Структура;
	НоменклатураИБ.Вставить("Номенклатура"           , Номенклатура);
	НоменклатураИБ.Вставить("Характеристика"         , Характеристика);
	НоменклатураИБ.Вставить("Упаковка"               , Упаковка);
	НоменклатураИБ.Вставить("НоменклатураКонтрагента", ПредопределенноеЗначение("Справочник.НоменклатураКонтрагентов.ПустаяСсылка"));

	Возврат НоменклатураИБ;
	
КонецФункции

// Возвращает набор данных, представляющий номенклатуру контрагента.
//
// Параметры:
//  Владелец      - ОпределяемыйТип.ВладелецНоменклатурыБЭД - значение для инициализации выходного свойства Владелец.
//  Идентификатор - Строка                                  - значение для инициализации выходного свойства Идентификатор.
//
// Возвращаемое значение:
//  Структура - данные, представляющие номенклатуру контрагента:
//   * Владелец                           - Неопределено, ОпределяемыйТип.ВладелецНоменклатурыБЭД, ОпределяемыйТип.Организация - владелец номенклатуры.
//                                                                                                                               Неопределено, если не инициализировано.
//   * Идентификатор                      - Строка - идентификатор записи по комбинации: номенклатура#характеристика#упаковка.
//   * Наименование                       - Строка - наименование номенклатуры.
//   * Характеристика                     - Строка - наименование характеристики номенклатуры.
//   * НаименованиеУпаковки               - Строка - наименование упаковки номенклатуры.
//   * ЕдиницаИзмерения                   - Строка - наименование базовой единицы измерения номенклатуры.
//   * ЕдиницаИзмеренияКод                - Строка - код по ОКЕИ базовой единицы измерения номенклатуры.
//   * Артикул                            - Строка - артикул номенклатуры.
//   * СтавкаНДС                          - Строка - ставка НДС номенклатуры. 
//   * ШтрихкодКомбинации                 - Строка - штрихкод комбинации: номенклатура, характеристика, упаковка.
//   * ШтрихкодыНоменклатуры              - Строка - другие штрихкоды номенклатуры через запятую.
//   * ИдентификаторНоменклатурыСервиса   - Строка - идентификатор в сервисе 1С:Номенклатура.
//   * ИдентификаторХарактеристикиСервиса - Строка - идентификатор характеристики в сервисе 1С:Номенклатура.
//   * ИдентификаторНоменклатуры          - Строка - идентификатор номенклатуры.
//   * ИдентификаторХарактеристики        - Строка - идентификатор характеристики.
//   * ИдентификаторУпаковки              - Строка - идентификатор упаковки.
//   * ИсторияИдентификаторов             - Массив - история версий идентификаторов для данной номенклатуры (служебный).
//   * КоличествоБазовойЕдиницыИзмерения  - Число  - количество базовой единицы измерения (числитель).
//   * КоличествоУпаковок                 - Число  - количество упаковок (знаменатель)
//   * ВариантУказанияНоменклатуры        - ПеречислениеСсылка.ВариантыУказанияНоменклатурыБЭД - значение в чьих терминах указана номенклатура.
//                                                                                               По умолчанию номенклатура контрагента.
//   * НоменклатураКонтрагента            - СправочникСсылка.НоменклатураКонтрагентов          - ссылка номенклатуры контрагентов.
//
Функция НоваяНоменклатураКонтрагента(Знач Владелец = Неопределено, Знач Идентификатор = Неопределено) Экспорт
	
	НоменклатураКонтрагента = Новый Структура;
	НоменклатураКонтрагента.Вставить("Владелец"            , Владелец);
	НоменклатураКонтрагента.Вставить("Идентификатор"       , ?(ЗначениеЗаполнено(Идентификатор), Идентификатор, ""));
	НоменклатураКонтрагента.Вставить("Наименование"        , "");
	НоменклатураКонтрагента.Вставить("Характеристика"      , "");
	НоменклатураКонтрагента.Вставить("НаименованиеУпаковки", "");
	НоменклатураКонтрагента.Вставить("ЕдиницаИзмерения"    , "");
	НоменклатураКонтрагента.Вставить("ЕдиницаИзмеренияКод" , "");
	НоменклатураКонтрагента.Вставить("Артикул"             , "");
	НоменклатураКонтрагента.Вставить("СтавкаНДС"           , "");
	НоменклатураКонтрагента.Вставить("ШтрихкодКомбинации"                , "");
	НоменклатураКонтрагента.Вставить("ШтрихкодыНоменклатуры"             , "");
	НоменклатураКонтрагента.Вставить("ИдентификаторНоменклатурыСервиса"  , "");
	НоменклатураКонтрагента.Вставить("ИдентификаторХарактеристикиСервиса", "");
	НоменклатураКонтрагента.Вставить("ИдентификаторНоменклатуры"         , "");
	НоменклатураКонтрагента.Вставить("ИдентификаторХарактеристики"       , "");
	НоменклатураКонтрагента.Вставить("ИдентификаторУпаковки"             , "");
	НоменклатураКонтрагента.Вставить("ИсторияИдентификаторов"            , Новый Массив);
	НоменклатураКонтрагента.Вставить("КоличествоУпаковок"                , 0);
	НоменклатураКонтрагента.Вставить("КоличествоБазовойЕдиницыИзмерения" , 0);
	НоменклатураКонтрагента.Вставить("НоменклатураКонтрагента"           , 
		ПредопределенноеЗначение("Справочник.НоменклатураКонтрагентов.ПустаяСсылка"));
	НоменклатураКонтрагента.Вставить("ВариантУказанияНоменклатуры"       ,
		ПредопределенноеЗначение("Перечисление.ВариантыУказанияНоменклатурыБЭД.НоменклатураКонтрагента"));

	Возврат НоменклатураКонтрагента;

КонецФункции

// Возвращает структуру свойств номенклатуры ИБ.
//
// Возвращаемое значение:
//  Структура - свойства номенклатуры информационной базы:
//   * ИспользоватьХарактеристики           - Булево - признак использования характеристик. По умолчанию Ложь.
//   * ИспользоватьУпаковки                 - Булево - признак использования упаковок. По умолчанию Ложь.
//   * ОбязательноеЗаполнениеХарактеристики - Булево - признак обязательного заполнения характеристик при их использовании. По умолчанию Истина.
//   * ЕдиницаИзмеренияПоУмолчанию          - ОпределяемыйТип.УпаковкаНоменклатурыБЭД - базовая единица измерения номенклатуры.
//
Функция НовыеСвойстваНоменклатурыИБ() Экспорт
	
	СвойствоНоменклатуры = Новый Структура;
	СвойствоНоменклатуры.Вставить("ИспользоватьХарактеристики"          , Ложь);
	СвойствоНоменклатуры.Вставить("ИспользоватьУпаковки"                , Ложь);
	СвойствоНоменклатуры.Вставить("ОбязательноеЗаполнениеХарактеристики", Истина);
	СвойствоНоменклатуры.Вставить("ЕдиницаИзмеренияПоУмолчанию"         , Неопределено);
	
	Возврат СвойствоНоменклатуры;
	
КонецФункции

// Возвращает структуру свойств упаковки.
//
// Возвращаемое значение:
//  Структура - содержит:
//   * НаименованиеУпаковки                - Строка - признак использования характеристик. По умолчанию Ложь.
//   * НаименованиеБазовойЕдиницыИзмерения - Строка - признак использования упаковок. По умолчанию Ложь.
//   * КодОКЕИБазовойЕдиницыИзмерения      - Строка - признак обязательного заполнения характеристик при их использовании. По умолчанию Истина.
//   * КоличествоБазовойЕдиницыИзмерения   - Число  - при наличии упаковки указывается коэффициент пересчета 1 упаковки на базовую единицу измерения.
//                                                    В случае разупаковки указывается 1.
//   * КоличествоУпаковок                  - Число  - при наличии упаковки указывается 1. В случае разупаковки указывается коэффициент пересчета
//                                                    базовой единицы измерения на упаковку.
//
Функция НовыеСвойстваУпаковки() Экспорт
	
	СвойствоНоменклатуры = Новый Структура;
	СвойствоНоменклатуры.Вставить("НаименованиеУпаковки"               , "");
	СвойствоНоменклатуры.Вставить("НаименованиеБазовойЕдиницыИзмерения", "");
	СвойствоНоменклатуры.Вставить("КодОКЕИБазовойЕдиницыИзмерения"     , "");
	СвойствоНоменклатуры.Вставить("КоличествоБазовойЕдиницыИзмерения"  , 0);
	СвойствоНоменклатуры.Вставить("КоличествоУпаковок"                 , 0);
		
	Возврат СвойствоНоменклатуры;
	
КонецФункции

// Разделяет идентификатор номенклатуры контрагента на части по разделителю #.
//
// Параметры:
//  Идентификатор           - Строка    - идентификатор, который необходимо разбить на части по разделителю #.
//  НоменклатураКонтрагента - Структура - содержит:
//    *ИдентификаторНоменклатуры   - Строка - идентификатор номенклатуры.
//    *ИдентификаторХарактеристики - Строка - идентификатор характеристики.
//    *ИдентификаторУпаковки       - Строка - идентификатор упаковки.
//
Процедура РазделитьИдентификаторНаЧасти(Идентификатор, НоменклатураКонтрагента) Экспорт
	
	ЧастиИдентификаторов = СтрРазделить(Идентификатор, "#", Истина);
	ВсегоЧастей = ЧастиИдентификаторов.Количество();
	
	Если ВсегоЧастей = 3 Тогда
		НоменклатураКонтрагента.ИдентификаторНоменклатуры   = ЧастиИдентификаторов[0];
		НоменклатураКонтрагента.ИдентификаторХарактеристики = ЧастиИдентификаторов[1];
		НоменклатураКонтрагента.ИдентификаторУпаковки       = ЧастиИдентификаторов[2];
	ИначеЕсли ВсегоЧастей > 3 Тогда
		НоменклатураКонтрагента.ИдентификаторНоменклатуры   = ЧастиИдентификаторов[0];
		НоменклатураКонтрагента.ИдентификаторХарактеристики = ЧастиИдентификаторов[1];
		
		ДлинаИдентификатора = СтрДлина(Идентификатор);
		ДлинаЧастиИдентификатора = СтрДлина(ЧастиИдентификаторов[0] + "#" + ЧастиИдентификаторов[1] + "#");
		
		ПоследняяЧастьИдентификатора = Сред(Идентификатор, ДлинаЧастиИдентификатора + 1, ДлинаИдентификатора);
		
		НоменклатураКонтрагента.ИдентификаторУпаковки       = ПоследняяЧастьИдентификатора;
	Иначе
		НоменклатураКонтрагента.ИдентификаторНоменклатуры   = Идентификатор;
		НоменклатураКонтрагента.ИдентификаторХарактеристики = Идентификатор;
		НоменклатураКонтрагента.ИдентификаторУпаковки       = Идентификатор;
	КонецЕсли;
	
	// Приведем длину идентификаторов к длине реквизитов справочника НоменклатураКонтрагентов
	НоменклатураКонтрагента.ИдентификаторНоменклатуры = Лев(НоменклатураКонтрагента.ИдентификаторНоменклатуры, 100);
	НоменклатураКонтрагента.ИдентификаторХарактеристики = Лев(НоменклатураКонтрагента.ИдентификаторХарактеристики, 100);
	НоменклатураКонтрагента.ИдентификаторУпаковки = Лев(НоменклатураКонтрагента.ИдентификаторУпаковки, 100);
	
КонецПроцедуры

// Возвращает идентификатор номенклатуры контрагента собранный из внутренних идентификаторов ссылок по разделителю #. 
//
// Параметры:
//  НоменклатураИБ - см. НоваяНоменклатураИнформационнойБазы
//
// Возвращаемое значение:
//  Строка - идентификатор номенклатуры контрагента.
//
Функция ИдентификаторНоменклатурыКонтрагентаПоНоменклатуреИБ(Знач НоменклатураИБ) Экспорт
	
	ИдНоменклатуры   = ?(ЗначениеЗаполнено(НоменклатураИБ.Номенклатура), НоменклатураИБ.Номенклатура.УникальныйИдентификатор(), "");
	ИдХарактеристики = ?(ЗначениеЗаполнено(НоменклатураИБ.Характеристика), НоменклатураИБ.Характеристика.УникальныйИдентификатор(), "");
	ИдУпаковки       = ?(ЗначениеЗаполнено(НоменклатураИБ.Упаковка), НоменклатураИБ.Упаковка.УникальныйИдентификатор(), "");
	
	Результат = "";
	Если ЗначениеЗаполнено(ИдНоменклатуры) Тогда
		Результат = Строка(ИдНоменклатуры) + "#" + Строка(ИдХарактеристики) + "#" + Строка(ИдУпаковки);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

//++ Локализация

// Возвращает значение варианта указания номенклатуры в терминах организации.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ВариантыУказанияНоменклатурыБЭД
//
Функция ВариантУказанияНоменклатураОрганизации() Экспорт
	
	Возврат ПредопределенноеЗначение("Перечисление.ВариантыУказанияНоменклатурыБЭД.НашаНоменклатура");
	
КонецФункции

// Возвращает значение варианта указания номенклатуры в терминах контрагента.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ВариантыУказанияНоменклатурыБЭД
//
Функция ВариантУказанияНоменклатураКонтрагента() Экспорт
	
	Возврат  ПредопределенноеЗначение("Перечисление.ВариантыУказанияНоменклатурыБЭД.НоменклатураКонтрагента");
	
КонецФункции

//-- Локализация

#КонецОбласти

