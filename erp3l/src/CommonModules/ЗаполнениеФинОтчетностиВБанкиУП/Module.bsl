
#Область ПрограммныйИнтерфейс

//++ НЕ УТ

#Область СистемыНалогообложения

// Подготавливает временную таблицу, в которой перечислены системы налогообложения, которые применялись в организациях
// в течение периода.
//
// Параметры:
//   Субъекты    - Массив из СправочникСсылка.Организации - организации, описания систем налогообложения которых нужно подготовить.
//   НачалоПериода - Дата - начало анализируемого периода.
//   КонецПериода - Дата - конец анализируемого периода.
//   ОписанияСистемНалогообложения - МенеджерВременныхТаблиц - после выполнения процедуры должен содержать
//                                    таблицу ВТ_НастройкиСистемыНалогообложения, имеющую следующие колонки:
//     * Период - Дата - начало действия параметров налогообложения.
//     * Субъект - СправочникСсылка.Организации - для кого действуют параметры.
//     * СистемаНалогообложения - ПеречислениеСсылка.СистемыНалогообложения - набор параметров налогообложения.
//     * ПрименяетсяУСНДоходы, ПрименяетсяУСНДоходыМинусРасходы, ПрименяетсяУСНПатент - Булево - флаги вариантов применения УСН.
//     * ПрименяетсяНалогНаПрофессиональныйДоход - флаг учетной политики для самозанятых.
//     * ПлательщикЕНВД, ПлательщикТорговогоСбора - дополнительные флаги учетной политики.
//
Процедура ПодготовитьОписанияСистемНалогообложения(Субъекты, НачалоПериода, КонецПериода, ОписанияСистемНалогообложения) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = ОписанияСистемНалогообложения;
	Запрос.УстановитьПараметр("Субъекты",      Субъекты);
	Запрос.УстановитьПараметр("ДатаНачала",    НачалоПериода);
	Запрос.УстановитьПараметр("ДатаОкончания", КонецПериода);

	// Для организаций настройки системы налогообложения берем из базы данных.
	// Для контрагентов, отчетность которых была загружена из другой базы,
	// настройки системы налогообложения также загружаются в одноименную табличную часть документа, выбираем из нее.
	// При выгрузке из другой базы настройки системы налогообложения выгружаются как срез последних на дату первого отчетного периода
	// и движения за период всех отчетов.
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&ДатаНачала КАК НачалоПериода,
	|	НастройкиСистемыНалогообложения.Организация КАК Организация,
	|	НастройкиСистемыНалогообложения.СистемаНалогообложения КАК СистемаНалогообложения,
	|	НастройкиСистемыНалогообложения.ПрименяетсяЕНВД КАК ПрименяетсяЕНВД,
	|	НастройкиСистемыНалогообложения.ПрименяетсяПСН КАК ПрименяетсяПСН
	|ПОМЕСТИТЬ ВТНастройкиСистемыНалогообложения_Предварительная
	|ИЗ
	|	РегистрСведений.НастройкиСистемыНалогообложения.СрезПоследних(&ДатаНачала, Организация В (&Субъекты)) КАК
	|		НастройкиСистемыНалогообложения
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НастройкиСистемыНалогообложения.Период,
	|	НастройкиСистемыНалогообложения.Организация,
	|	НастройкиСистемыНалогообложения.СистемаНалогообложения,
	|	НастройкиСистемыНалогообложения.ПрименяетсяЕНВД,
	|	НастройкиСистемыНалогообложения.ПрименяетсяПСН
	|ИЗ
	|	РегистрСведений.НастройкиСистемыНалогообложения КАК НастройкиСистемыНалогообложения
	|ГДЕ
	|	НастройкиСистемыНалогообложения.Организация В (&Субъекты)
	|	И НастройкиСистемыНалогообложения.Период > &ДатаНачала
	|	И НастройкиСистемыНалогообложения.Период <= &ДатаОкончания
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущиеДанные.Организация КАК Организация,
	|	ТекущиеДанные.НачалоПериода КАК НачалоПериода,
	|	КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(МИНИМУМ(ЕСТЬNULL(БудущиеДанные.НачалоПериода, &ДатаОкончания)), СЕКУНДА, -1), ДЕНЬ) КАК ОкончаниеПериода,
	|	ТекущиеДанные.СистемаНалогообложения КАК СистемаНалогообложения,
	|	ТекущиеДанные.ПрименяетсяЕНВД КАК ПрименяетсяЕНВД,
	|	ТекущиеДанные.ПрименяетсяПСН КАК ПрименяетсяПСН
	|ПОМЕСТИТЬ ВТНастройкиСистемыНалогообложения
	|ИЗ
	|	ВТНастройкиСистемыНалогообложения_Предварительная КАК ТекущиеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНастройкиСистемыНалогообложения_Предварительная КАК БудущиеДанные
	|		ПО ТекущиеДанные.Организация = БудущиеДанные.Организация
	|		И ТекущиеДанные.НачалоПериода < БудущиеДанные.НачалоПериода
	|СГРУППИРОВАТЬ ПО
	|	ТекущиеДанные.Организация,
	|	ТекущиеДанные.НачалоПериода,
	|	ТекущиеДанные.СистемаНалогообложения,
	|	ТекущиеДанные.ПрименяетсяЕНВД,
	|	ТекущиеДанные.ПрименяетсяПСН
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТНастройкиСистемыНалогообложения_Предварительная
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&ДатаНачала КАК НачалоПериода,
	|	НастройкиУчетаУСН.Организация КАК Организация,
	|	НастройкиУчетаУСН.ОбъектНалогообложенияУСН = ЗНАЧЕНИЕ(Перечисление.ОбъектыНалогообложенияПоУСН.Доходы) КАК
	|		ПрименяетсяУСНДоходы,
	|	НастройкиУчетаУСН.ОбъектНалогообложенияУСН = ЗНАЧЕНИЕ(Перечисление.ОбъектыНалогообложенияПоУСН.ДоходыМинусРасходы) КАК
	|		ПрименяетсяУСНДоходыМинусРасходы
	|ПОМЕСТИТЬ ВТНастройкиУчетаУСН_Предварительная
	|ИЗ
	|	РегистрСведений.НастройкиУчетаУСН.СрезПоследних(&ДатаНачала, Организация В (&Субъекты)) КАК НастройкиУчетаУСН
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НастройкиУчетаУСН.Период,
	|	НастройкиУчетаУСН.Организация,
	|	НастройкиУчетаУСН.ОбъектНалогообложенияУСН = ЗНАЧЕНИЕ(Перечисление.ОбъектыНалогообложенияПоУСН.Доходы),
	|	НастройкиУчетаУСН.ОбъектНалогообложенияУСН = ЗНАЧЕНИЕ(Перечисление.ОбъектыНалогообложенияПоУСН.ДоходыМинусРасходы)
	|ИЗ
	|	РегистрСведений.НастройкиУчетаУСН КАК НастройкиУчетаУСН
	|ГДЕ
	|	НастройкиУчетаУСН.Организация В (&Субъекты)
	|	И НастройкиУчетаУСН.Период > &ДатаНачала
	|	И НастройкиУчетаУСН.Период <= &ДатаОкончания
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущиеДанные.Организация КАК Организация,
	|	ТекущиеДанные.НачалоПериода КАК НачалоПериода,
	|	КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(МИНИМУМ(ЕСТЬNULL(БудущиеДанные.НачалоПериода, &ДатаОкончания)), СЕКУНДА, -1), ДЕНЬ) КАК ОкончаниеПериода,
	|	ТекущиеДанные.ПрименяетсяУСНДоходы КАК ПрименяетсяУСНДоходы,
	|	ТекущиеДанные.ПрименяетсяУСНДоходыМинусРасходы КАК ПрименяетсяУСНДоходыМинусРасходы
	|ПОМЕСТИТЬ ВТНастройкиУчетаУСН
	|ИЗ
	|	ВТНастройкиУчетаУСН_Предварительная КАК ТекущиеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНастройкиУчетаУСН_Предварительная КАК БудущиеДанные
	|		ПО ТекущиеДанные.Организация = БудущиеДанные.Организация
	|		И ТекущиеДанные.НачалоПериода < БудущиеДанные.НачалоПериода
	|СГРУППИРОВАТЬ ПО
	|	ТекущиеДанные.Организация,
	|	ТекущиеДанные.НачалоПериода,
	|	ТекущиеДанные.ПрименяетсяУСНДоходы,
	|	ТекущиеДанные.ПрименяетсяУСНДоходыМинусРасходы
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТНастройкиУчетаУСН_Предварительная
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&ДатаНачала КАК НачалоПериода,
	|	ПараметрыТорговыхТочек.Организация КАК Организация,
	|	ИСТИНА КАК ПлательщикТорговогоСбора
	|ПОМЕСТИТЬ ВТПараметрыТорговыхТочек_Предварительная
	|ИЗ
	|	РегистрСведений.ПараметрыТорговыхТочек.СрезПоследних(&ДатаНачала, Организация В (&Субъекты)) КАК
	|		ПараметрыТорговыхТочек
	|ГДЕ
	|	ПараметрыТорговыхТочек.ВидОперации <> ЗНАЧЕНИЕ(Перечисление.ВидыОперацийТорговыеТочки.СнятиеСУчета)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПараметрыТорговыхТочек.Период,
	|	ПараметрыТорговыхТочек.Организация,
	|	ИСТИНА
	|ИЗ
	|	РегистрСведений.ПараметрыТорговыхТочек КАК ПараметрыТорговыхТочек
	|ГДЕ
	|	ПараметрыТорговыхТочек.Организация В (&Субъекты)
	|	И ПараметрыТорговыхТочек.Период > &ДатаНачала
	|	И ПараметрыТорговыхТочек.Период <= &ДатаОкончания
	|	И ПараметрыТорговыхТочек.ВидОперации <> ЗНАЧЕНИЕ(Перечисление.ВидыОперацийТорговыеТочки.СнятиеСУчета)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущиеДанные.Организация КАК Организация,
	|	ТекущиеДанные.НачалоПериода КАК НачалоПериода,
	|	КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(МИНИМУМ(ЕСТЬNULL(БудущиеДанные.НачалоПериода, &ДатаОкончания)), СЕКУНДА, -1), ДЕНЬ) КАК ОкончаниеПериода,
	|	ТекущиеДанные.ПлательщикТорговогоСбора КАК ПлательщикТорговогоСбора
	|ПОМЕСТИТЬ ВТПараметрыТорговыхТочек
	|ИЗ
	|	ВТПараметрыТорговыхТочек_Предварительная КАК ТекущиеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПараметрыТорговыхТочек_Предварительная КАК БудущиеДанные
	|		ПО ТекущиеДанные.Организация = БудущиеДанные.Организация
	|		И ТекущиеДанные.НачалоПериода < БудущиеДанные.НачалоПериода
	|СГРУППИРОВАТЬ ПО
	|	ТекущиеДанные.Организация,
	|	ТекущиеДанные.НачалоПериода,
	|	ТекущиеДанные.ПлательщикТорговогоСбора
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТПараметрыТорговыхТочек_Предварительная
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкиСистемыНалогообложения.НачалоПериода КАК Период,
	|	НастройкиСистемыНалогообложения.Организация КАК Субъект,
	|	НастройкиСистемыНалогообложения.СистемаНалогообложения КАК СистемаНалогообложения,
	|	ЕСТЬNULL(НастройкиУчетаУСН.ПрименяетсяУСНДоходы, ЛОЖЬ) КАК ПрименяетсяУСНДоходы,
	|	ЕСТЬNULL(НастройкиУчетаУСН.ПрименяетсяУСНДоходыМинусРасходы, ЛОЖЬ) КАК ПрименяетсяУСНДоходыМинусРасходы,
	|	НастройкиСистемыНалогообложения.ПрименяетсяЕНВД КАК ПлательщикЕНВД,
	|	НастройкиСистемыНалогообложения.ПрименяетсяПСН КАК ПрименяетсяУСНПатент,
	|	ЕСТЬNULL(ПараметрыТорговыхТочек.ПлательщикТорговогоСбора, ЛОЖЬ) КАК ПлательщикТорговогоСбора,
	|	ЛОЖЬ КАК ПрименяетсяНалогНаПрофессиональныйДоход
	|ПОМЕСТИТЬ ВТ_НастройкиСистемыНалогообложения
	|ИЗ
	|	ВТНастройкиСистемыНалогообложения КАК НастройкиСистемыНалогообложения
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНастройкиУчетаУСН КАК НастройкиУчетаУСН
	|		ПО НастройкиСистемыНалогообложения.Организация = НастройкиУчетаУСН.Организация
	|		И (НастройкиУчетаУСН.НачалоПериода <= НастройкиСистемыНалогообложения.НачалоПериода)
	|		И (НастройкиУчетаУСН.ОкончаниеПериода > НастройкиСистемыНалогообложения.НачалоПериода)
	|		И
	|			(НастройкиСистемыНалогообложения.СистемаНалогообложения = ЗНАЧЕНИЕ(Перечисление.СистемыНалогообложения.Упрощенная))
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПараметрыТорговыхТочек КАК ПараметрыТорговыхТочек
	|		ПО НастройкиСистемыНалогообложения.Организация = ПараметрыТорговыхТочек.Организация
	|		И (ПараметрыТорговыхТочек.НачалоПериода <= НастройкиСистемыНалогообложения.НачалоПериода)
	|		И (НастройкиУчетаУСН.ОкончаниеПериода > НастройкиСистемыНалогообложения.НачалоПериода)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	НастройкиСистемыНалогообложения.НачалоПериода,
	|	НастройкиСистемыНалогообложения.Организация,
	|	НастройкиСистемыНалогообложения.СистемаНалогообложения,
	|	НастройкиУчетаУСН.ПрименяетсяУСНДоходы,
	|	НастройкиУчетаУСН.ПрименяетсяУСНДоходыМинусРасходы,
	|	НастройкиСистемыНалогообложения.ПрименяетсяЕНВД,
	|	НастройкиСистемыНалогообложения.ПрименяетсяПСН,
	|	ЕСТЬNULL(ПараметрыТорговыхТочек.ПлательщикТорговогоСбора, ЛОЖЬ),
	|	ЛОЖЬ
	|ИЗ
	|	ВТНастройкиУчетаУСН КАК НастройкиУчетаУСН
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТНастройкиСистемыНалогообложения КАК НастройкиСистемыНалогообложения
	|		ПО (НастройкиСистемыНалогообложения.Организация = НастройкиУчетаУСН.Организация)
	|		И (НастройкиСистемыНалогообложения.НачалоПериода <= НастройкиУчетаУСН.НачалоПериода)
	|		И (НастройкиСистемыНалогообложения.ОкончаниеПериода > НастройкиУчетаУСН.НачалоПериода)
	|		И
	|			(НастройкиСистемыНалогообложения.СистемаНалогообложения = ЗНАЧЕНИЕ(Перечисление.СистемыНалогообложения.Упрощенная))
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПараметрыТорговыхТочек КАК ПараметрыТорговыхТочек
	|		ПО НастройкиУчетаУСН.Организация = ПараметрыТорговыхТочек.Организация
	|		И (ПараметрыТорговыхТочек.НачалоПериода <= НастройкиУчетаУСН.НачалоПериода)
	|		И (НастройкиУчетаУСН.ОкончаниеПериода > НастройкиУчетаУСН.НачалоПериода)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТНастройкиСистемыНалогообложения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТНастройкиУчетаУСН
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТПараметрыТорговыхТочек";

	Запрос.Выполнить();

КонецПроцедуры

// Проверяет, являлся ли ИП плательщиком НДФЛ.
//
// Параметры:
//  Организация - СправочникСсылка.Организации - проверяемая организация.
//  НачалоПериода - Дата - начало анализируемого периода.
//  КонецПериода - Дата - конец анализируемого периода.
//
// Возвращаемое значение:
//   Булево      - Истина, если ИП хотя бы часть указанного периода был плательщиком НДФЛ.
//
Функция ПлательщикНДФЛЗаПериод(Организация, НачалоПериода, КонецПериода) Экспорт
	
	МассивИспользуемыхСистем = УчетнаяПолитикаПереопределяемый.ЗначенияРесурсаУчетнойПолитикиЗаПериод(
		"СистемаНалогообложения", Организация, НачалоПериода, КонецПериода);
	Возврат МассивИспользуемыхСистем.Найти(Перечисления.СистемыНалогообложения.Общая) <> Неопределено;
	
КонецФункции

// Подготовливает список применявшихся патентов.
//
// Параметры:
//   Организация - СправочникСсылка.Организации - проверяемая организация.
//   НачалоПериода - Дата - начало анализируемого периода.
//   КонецПериода - Дата - конец анализируемого периода.
//
// Возвращаемое значение:
//   ТаблицаЗначений - содержит колонки:
//    * Ссылка - СправочникСсылка.Патенты - ссылка на патент;
//    * Наименование - Строка(50) - наименование патента в программе;
//    * ДатаНачала - Дата - день начала срока действия патента;
//    * ДатаОкончания - Дата - день окончания срока действия патента;
//    * ПотенциальноВозможныйГодовойДоход - Число - потенциальный годовой доход по патенту. Далее не используется.
//
Функция ПатентыОрганизацииЗаПериод(Организация, НачалоПериода, КонецПериода) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДатаНачала", НачалоПериода);
	Запрос.УстановитьПараметр("ДатаОкончания", КонецПериода);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Патенты.Ссылка КАК Ссылка,
	|	Патенты.Наименование КАК Наименование,
	|	Патенты.ДатаНачала КАК ДатаНачала,
	|	Патенты.ДатаОкончания КАК ДатаОкончания,
	|	0 КАК ПотенциальноВозможныйГодовойДоход
	|ИЗ
	|	Справочник.Патенты КАК Патенты
	|ГДЕ
	|	Патенты.Владелец = &Организация
	|	И НЕ Патенты.ПометкаУдаления
	|	И Патенты.ДатаНачала <= &ДатаОкончания
	|	И Патенты.ДатаОкончания >= &ДатаНачала";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#Область СпискиОбъектов

// Подготавливает список из наименований банков для использования в интерфейсе.
//
// Параметры:
//   Субъекты    - Массив из СправочникСсылка.Организации, СправочникСсылка.Контрагенты - владельцы счетов.
//   ИсключаемыеБИК - Массив из Строка - БИК банков, счета которых не должны включаться в список.
//
// Возвращаемое значение:
//   ТаблицаЗначений - список наименований банков, в которых открыты счета у субъектов.
//		* НаименованиеБанка - представление счета.
//
Функция БанковскиеСчета(Субъекты, ИсключаемыеБИК) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Субъекты",       Субъекты);
	Запрос.УстановитьПараметр("ИсключаемыеБИК", ИсключаемыеБИК);

	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	БанковскиеСчета.НаименованиеБанка КАК НаименованиеБанка
	|ИЗ
	|	ВТ_БанковскиеСчетаПереопределяемый КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.Счет.Владелец В(&Субъекты)
	|	И НЕ БанковскиеСчета.БИКБанка В (&ИсключаемыеБИК)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НаименованиеБанка";
	
	ЗаполнениеОтчетностиВБанкиПереопределяемый.ДополнитьТекстЗапросаПоВременнымТаблицам(Запрос);
	
	УстановитьПривилегированныйРежим(Истина);

	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Подготавливает список касс организации для использования в интерфейсе.
//
// Параметры:
//   Субъекты    - Массив из СправочникСсылка.Организации, СправочникСсылка.Контрагенты - структурные подразделения, входящие в группу.
//   НачалоПериода - Дата - начало периода, в который счет является действующим.
//   КонецПериода - Дата - конец периода, в который счет является действующим.
//   ПараметрыОтбора - Структура - содержит дополнительные параметры для подбора касс.
//
// Возвращаемое значение:
//   ТаблицаЗначений - список касс с их свойствами:
//     * Организация - СправочникСсылка.Организации - основная организация.
//     * ОрганизацияНаименование - Строка - наименование организации.
//     * Подразделение - СправочникСсылка - обособленное подразделение.
//     * ПодразделениеНаименование - Строка - наименование обособленного подразделения.
//     * ПлатежныйАгент - Булево - признак, что касса относится к платежному агенту.
//
Функция Кассы(Субъекты, НачалоПериода, КонецПериода, ПараметрыОтбора) Экспорт

	СчетаКассы = Новый Массив;
	СчетаКассы.Добавить(ПланыСчетов.Хозрасчетный.КассаОрганизации);    // 50.01
	СчетаКассы.Добавить(ПланыСчетов.Хозрасчетный.КассаОрганизацииВал); // 50.21
	СчетаКассы = БухгалтерскийУчет.СформироватьМассивСубсчетов(СчетаКассы);
	
	СчетаКассыПлатежногоАгента = БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.КассаПлатежногоАгента); // 50.04
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",    ПараметрыОтбора.Субъект);
	Запрос.УстановитьПараметр("Субъекты",       Субъекты);
	Запрос.УстановитьПараметр("ДатаНачала",     НачалоПериода);
	Запрос.УстановитьПараметр("ДатаОкончания",  КонецДня(КонецПериода));
	Запрос.УстановитьПараметр("СчетаКассы",     СчетаКассы);
	Запрос.УстановитьПараметр("СчетаКассыПлатежногоАгента", СчетаКассыПлатежногоАгента);
	
	Запрос.Текст = БухгалтерскийУчетПереопределяемый.ТекстЗапросаРегистрацииПодразделенийВНалоговомОргане(
		"Субъекты", "ВТ_ФлагиОбособленноеПодразделение") +
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Хозрасчетный.Организация КАК Организация,
	|	Хозрасчетный.Организация.Наименование КАК ОрганизацияНаименование,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ФлагиОбособленноеПодразделение.ОбособленноеПодразделение, ЛОЖЬ)
	|			ТОГДА Хозрасчетный.Подразделение
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК Подразделение,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ФлагиОбособленноеПодразделение.ОбособленноеПодразделение, ЛОЖЬ)
	|			ТОГДА Хозрасчетный.Подразделение.Наименование
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК ПодразделениеНаименование,
	|	ВЫБОР
	|		КОГДА Хозрасчетный.Счет В (&СчетаКассыПлатежногоАгента)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПлатежныйАгент,
	|	ВЫБОР
	|		КОГДА Хозрасчетный.Организация = &Организация
	|			ТОГДА 1
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК ПорядокСортировкиОрганизаций,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ФлагиОбособленноеПодразделение.ОбособленноеПодразделение, ЛОЖЬ)
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ПорядокСортировкиПодразделений,
	|	СУММА(Хозрасчетный.СуммаНачальныйОстаток) КАК СуммаНачальныйОстаток,
	|	СУММА(Хозрасчетный.СуммаОборотДт) КАК СуммаОборотДт,
	|	СУММА(Хозрасчетный.СуммаОборотКт) КАК СуммаОборотКт,
	|	СУММА(Хозрасчетный.СуммаКонечныйОстаток) КАК СуммаКонечныйОстаток
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(&ДатаНачала, &ДатаОкончания, , , Счет В (&СчетаКассы, &СчетаКассыПлатежногоАгента), , Организация В (&Субъекты)) КАК Хозрасчетный
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ФлагиОбособленноеПодразделение КАК ФлагиОбособленноеПодразделение
	|		ПО Хозрасчетный.Подразделение = ФлагиОбособленноеПодразделение.Подразделение
	|
	|СГРУППИРОВАТЬ ПО
	|	Хозрасчетный.Организация,
	|	Хозрасчетный.Организация.Наименование,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ФлагиОбособленноеПодразделение.ОбособленноеПодразделение, ЛОЖЬ)
	|			ТОГДА Хозрасчетный.Подразделение
	|		ИНАЧЕ NULL
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ФлагиОбособленноеПодразделение.ОбособленноеПодразделение, ЛОЖЬ)
	|			ТОГДА Хозрасчетный.Подразделение.Наименование
	|		ИНАЧЕ NULL
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА Хозрасчетный.Счет В (&СчетаКассыПлатежногоАгента)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ФлагиОбособленноеПодразделение.ОбособленноеПодразделение, ЛОЖЬ)
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПорядокСортировкиОрганизаций,
	|	ОрганизацияНаименование,
	|	ПорядокСортировкиПодразделений,
	|	ПодразделениеНаименование,
	|	ПлатежныйАгент";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Подготавливает список налоговых органов, в которых зарегистрированы подразделения организации, для использования в интерфейсе.
//
// Параметры:
//   Субъекты    - Массив из СправочникСсылка.Организации - структурные подразделения, входящие в группу.
//   НачалоПериода - Дата - начало периода, в который счет является действующим.
//   КонецПериода - Дата - конец периода, в который счет является действующим.
//   ПараметрыОтбора - Структура - содержит дополнительные параметры для подбора касс.
//
// Возвращаемое значение:
//   СписокЗначений - содержит:
//     * Значение - СправочникСсылка.РегистрацииВНалоговомОргане - налоговый орган.
//     * Представление - Строка - наименование налогового органа.
//
Функция НалоговыеОрганы(Субъекты, НачалоПериода, КонецПериода) Экспорт
	
	СписокНалоговыхОрганов = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Субъекты", Субъекты);
	Запрос.Текст = БухгалтерскийУчетПереопределяемый.ТекстЗапросаРегистрацииПодразделенийВНалоговомОргане("Субъекты", "");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.РегистрацияВНалоговомОргане)
		   И СписокНалоговыхОрганов.НайтиПоЗначению(Выборка.РегистрацияВНалоговомОргане) = Неопределено Тогда
			СписокНалоговыхОрганов.Добавить(Выборка.РегистрацияВНалоговомОргане, Строка(Выборка.РегистрацияВНалоговомОргане));
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СписокНалоговыхОрганов;
	
КонецФункции

// По переданным реквизитам подбирает организацию. Если организацию подобрать не удалось, то контрагента.
//
// Параметры:
//  ИНН          - Строка - налоговый идентификатор.
//  КПП          - Строка - налоговый идентификатор организации.
//
// Возвращаемое значение:
//   СправочникСсылка.Организации, СправочникСсылка.Контрагенты - возвращаемый параметр. Приоритет у организации.
//
Функция СсылкаНаОбъектПоИННКПП(ИНН, КПП) Экспорт
	Перем СубъектСсылка;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИНН", ИНН);
	Запрос.УстановитьПараметр("КПП", КПП);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Выборка.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Организации КАК Выборка
	|ГДЕ
	|	Выборка.ИНН = &ИНН
	|	И &УсловиеПоКПП
	|	И НЕ Выборка.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Выборка.Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Выборка
	|ГДЕ
	|	Выборка.ИНН = &ИНН
	|	И &УсловиеПоКПП
	|	И НЕ Выборка.ПометкаУдаления";
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"И &УсловиеПоКПП",
		?(ЗначениеЗаполнено(КПП), "И Выборка.КПП = &КПП", ""));
		
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СубъектСсылка = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат СубъектСсылка;
	
КонецФункции

#КонецОбласти

#Область ОтчетыНаОсновеБСП

// Для переданного отчета подбирает вариант настроек по-умолчанию для включения в пакет отчетов.
//
// Параметры:
//  ИдентификаторОтчета - Строка - имя объекта метаданных-отчета в конфигурации.
//
// Возвращаемое значение:
//  Строка - имя варианта отчета, всегда доступного в конфигурации.
// 
Функция ИмяВариантаПоУмолчанию(ИдентификаторОтчета) Экспорт
	Перем ИмяВарианта;
	
	Если ИдентификаторОтчета = "ВедомостьПоОС2_4" Тогда
		
		ИмяВарианта = "ВедомостьПоОС_БУ";
		
	ИначеЕсли ИдентификаторОтчета = "ВыручкаИСебестоимостьПродаж" Тогда
		
		ИмяВарианта = "ПродажиОрганизацийПоКонтрагентам";
		
	КонецЕсли;
	
	Возврат ИмяВарианта;
	
КонецФункции

// Без открытия формы формирует табличный документ отчета.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ЗаполнениеФинОтчетностиВБанки.ПараметрыОтчетаВедомостьАмортизацииОС()
//  ПараметрыЗаполнения - Структура - см. модуль менеджера документа ФинОтчетВБанк, процедура ЗаполнитьОтчетыВФоне()
//
// Возвращаемое значение:
//  Структура - см. БухгалтерскиеОтчетыВызовСервера.РезультатФормированияОтчета()
//
Функция ПодготовитьОтчет(ПараметрыОтчета, ПараметрыЗаполнения) Экспорт
	
	ОтчетыНаБазеПодсистемыБСП = Новый Массив;
	ОтчетыНаБазеПодсистемыБСП.Добавить("ВыручкаИСебестоимостьПродаж"); // ВаловаяПрибыль
	ОтчетыНаБазеПодсистемыБСП.Добавить("ВедомостьПоОС2_4");            // ВедомостьАмортизацииОС
	
	Если ОтчетыНаБазеПодсистемыБСП.Найти(ПараметрыОтчета.ИдентификаторОтчета) <> Неопределено Тогда
		РезультатФормированияОтчета = ЗаполнениеФинОтчетностиВБанки.ПодготовитьОтчетБСП(ПараметрыОтчета, ПараметрыЗаполнения);
	Иначе
		РезультатФормированияОтчета = ЗаполнениеФинОтчетностиВБанки.ПодготовитьОтчетБП(ПараметрыОтчета, ПараметрыЗаполнения);
	КонецЕсли;

	Возврат РезультатФормированияОтчета;

КонецФункции

// Формирует печатную форму "Кассовая книга".
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ЗаполнениеФинОтчетностиВБанки.ПараметрыОтчетаКассоваяКнига()
//  ТипФайла     - Строка - имя значения ТипФайлаПакетаОтображаемыхДокументов. 
//
// Возвращаемое значение:
//   Структура - см. ЗаполнениеФинОтчетностиВБанки.НовыйВозвращаемыеПараметры()
//
Функция СформироватьОтчетКассоваяКнига(ПараметрыОтчета, ТипФайла) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЛистКассовойКниги.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЛистКассовойКниги КАК ЛистКассовойКниги
	|ГДЕ
	|	ЛистКассовойКниги.Организация = &Организация
	|	И ЛистКассовойКниги.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И ЛистКассовойКниги.Проведен");
	Запрос.УстановитьПараметр("Организация",   ПараметрыОтчета.Организация);
	Запрос.УстановитьПараметр("НачалоПериода", ПараметрыОтчета.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",  КонецДня(ПараметрыОтчета.КонецПериода));
	МассивОбъектов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	Если МассивОбъектов.Количество() = 0 Тогда
		
		ПодготовленныйПакет = ЗаполнениеФинОтчетностиВБанки.НовыйВозвращаемыеПараметры();
		ПодготовленныйПакет.Выполнено = Истина;
		ПодготовленныйПакет.Результат = Новый ТабличныйДокумент;
		ПодготовленныйПакет.Результат.Область(2,2).Текст = НСтр("ru = 'Не найдены документы «Кассовые книги» за период';
																|en = '""Cash books"" documents for the period are not found'");
		ПодготовленныйПакет.Результат.Область(3,2).Текст = НСтр("ru = 'Если кассовых операций за период не было, то выберите пункт ""Данные отсутствуют"" вместо заполнения отчета.';
																|en = 'Select ""No data"" instead of filling the report if there were no cash transactions for the period.'");
		ПодготовленныйПакет.СписокСформированныхЛистов.Добавить(ПодготовленныйПакет.Результат);
		Возврат ПодготовленныйПакет;
		
	КонецЕсли;
	
	ИменаМакетов = Новый Массив;
	ИменаМакетов.Добавить("Обложка");
	ИменаМакетов.Добавить("ЛистКассовойКниги");
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ДополнитьКомплектВнешнимиПечатнымиФормами", Ложь);
	
	Результат = УправлениеПечатью.СформироватьПечатныеФормы(
		"Документ.ЛистКассовойКниги", ИменаМакетов, МассивОбъектов, ПараметрыПечати);
	
	СписокСформированныхЛистов = Новый СписокЗначений;
	Для Каждого РазделДляПечати Из Результат.КоллекцияПечатныхФорм Цикл
		СписокСформированныхЛистов.Добавить(РазделДляПечати.ТабличныйДокумент, РазделДляПечати.СинонимМакета);
	КонецЦикла;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Кассовая книга%1 %2';
																			|en = 'Cash book%1 %2'"),
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода),
		БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(ПараметрыОтчета.Организация));
	
	ПараметрыПакета = Новый Структура;
	ПараметрыПакета.Вставить("Заголовок",                  Заголовок);
	ПараметрыПакета.Вставить("СписокСформированныхЛистов", СписокСформированныхЛистов);
	ПараметрыПакета.Вставить("Расширение",                 НРег(ТипФайла));
	ПараметрыПакета.Вставить("ТипФайла",                   ТипФайлаПакетаОтображаемыхДокументов[ТипФайла]);
	ПодготовленныйПакет = ЗаполнениеФинОтчетностиВБанки.ПодготовитьДвоичныеДанныеПакетаОтображаемыхДокументов(ПараметрыПакета);
	
	Возврат ПодготовленныйПакет;
	
КонецФункции

#КонецОбласти

//-- НЕ УТ

#КонецОбласти
