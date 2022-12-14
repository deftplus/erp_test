////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы библиотеки УправлениеПредприятием.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область СведенияОБиблиотекеИлиКонфигурации

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
// 
// Параметры:
//  Описание - Структура - сведения о библиотеке:
//
//   * Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   * Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   * ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                    Обработчики обновления таких библиотек должны быть вызваны ранее
//                                    обработчиков обновления данной библиотеки.
//                                    При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                    порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                    в процедуре ПриДобавленииПодсистем общего модуля
//                                    ПодсистемыКонфигурацииПереопределяемый.
//   * РежимВыполненияОтложенныхОбработчиков - Строка - "Последовательно" - отложенные обработчики обновления выполняются
//                                    последовательно в интервале от номера версии информационной базы до номера
//                                    версии конфигурации включительно или "Параллельно" - отложенный обработчик после
//                                    обработки первой порции данных передает управление следующему обработчику, а после
//                                    выполнения последнего обработчика цикл повторяется заново.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "ERPWE";
	Описание.Версия = "2.5.7.366";
	Описание.РежимВыполненияОтложенныхОбработчиков = "Параллельно";
	Описание.ИдентификаторИнтернетПоддержки = "ERPWE";
	
	//++ Локализация
	Описание.Имя                            = "УправлениеПредприятием";
	Описание.ИдентификаторИнтернетПоддержки = "Enterprise20";
	//-- Локализация

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОбновленияИнформационнойБазы

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Документы.ЗаказДавальца.ПриДобавленииОбработчиковОбновления(Обработчики);
//++ Локализация
	Документы.ЗаказНаПроизводство.ПриДобавленииОбработчиковОбновления(Обработчики);
//-- Локализация
	Документы.ЗаказНаПроизводство2_2.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.ЗаказНаРемонт.ПриДобавленииОбработчиковОбновления(Обработчики);
//++ Локализация
	Документы.КорректировкаЗаказаМатериаловВПроизводство.ПриДобавленииОбработчиковОбновления(Обработчики);
//-- Локализация
	Документы.ОперацияМеждународный.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.ОтчетДавальцу.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.РазрешениеНаЗаменуМатериалов.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.РегламентнаяОперацияМеждународныйУчет.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.ЭкземплярФинансовогоОтчета.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.ЭтапПроизводства2_2.ПриДобавленииОбработчиковОбновления(Обработчики);
	ОбновлениеИнформационнойБазыУП.ПриДобавленииОбработчиковОбновленияУП(Обработчики);
	ПланыВидовХарактеристик.ВидыСубконтоМеждународные.ПриДобавленииОбработчиковОбновления(Обработчики);
	ПланыСчетов.Международный.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыБухгалтерии.Международный.ПриДобавленииОбработчиковОбновления(Обработчики);
//++ Локализация
	РегистрыНакопления.ЗаказыНаПроизводствоСпецификации.ПриДобавленииОбработчиковОбновления(Обработчики);
//-- Локализация
	РегистрыНакопления.ПланыЗанятостиВидовРабочихЦентров.ПриДобавленииОбработчиковОбновления(Обработчики);
//++ Локализация
	РегистрыНакопления.ПрослеживаемыеТоварыВСоставеОС.ПриДобавленииОбработчиковОбновления(Обработчики);
//-- Локализация
	РегистрыНакопления.УслугиДавальцуКОформлению.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.АналогиМатериалов.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.ОперацииКСозданиюСменныхЗаданий.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.ОтражениеДокументовВМеждународномУчете.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.ОчередьПроизводственныхОпераций.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.ПланыСчетовМеждународногоУчетаОрганизаций.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.СостоянияЗаказовНаПроизводство.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.СостоянияПлановыхКалькуляций.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.СостоянияЭтаповПроизводства.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.ВидыРемонтов.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.ВидыФинансовыхОтчетов.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.КлассыОбъектовЭксплуатации.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.КомплектыФинансовыхОтчетов.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.МаршрутныеКарты.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.НастройкиФормированияПроводокМеждународногоУчета.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.ПланыСчетовМеждународногоУчета.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.ТиповыеОперацииМеждународныйУчет.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.ШаблоныПроводокДляМеждународногоУчета.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.ЭтапыПроизводства.ПриДобавленииОбработчиковОбновления(Обработчики);

КонецПроцедуры

// Вызывается перед процедурами-обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсия       - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсия          - Строка - версия после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков обновления,
//                                             сгруппированных по номеру версии.
//   ВыводитьОписаниеОбновлений - Булево - (возвращаемое значение) если установить Истина,
//                                то будет выведена форма с описанием обновлений. По умолчанию, Истина.
//   МонопольныйРежим           - Булево - Истина, если обновление выполнялось в монопольном режиме.
//
// Пример обхода выполненных обработчиков обновления:
//
//	Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//		
//		Если Версия.Версия = "*" Тогда
//			// Обработчик, который может выполнятся при каждой смене версии.
//		Иначе
//			// Обработчик, который выполняется для определенной версии.
//		КонецЕсли;
//		
//		Для Каждого Обработчик Из Версия.Строки Цикл
//			...
//		КонецЦикла;
//		
//	КонецЦикла;
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
		
	ОбновлениеИнформационнойБазыУТ.ПослеОбновленияИнформационнойБазы(ПредыдущаяВерсия, ТекущаяВерсия,
		ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим);
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений в программе.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновления всех библиотек и конфигурации.
//           Макет можно дополнить или заменить.
//           См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ПредыдущееИмяКонфигурации = "КомплекснаяАвтоматизация";
	Обработчик.Процедура = "УправлениеСвойствамиСлужебный.СоздатьПредопределенныеНаборыСвойств";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ПредыдущееИмяКонфигурации = "УправлениеТорговлей";
	Обработчик.Процедура = "УправлениеСвойствамиСлужебный.СоздатьПредопределенныеНаборыСвойств";

	Обработчик = Обработчики.Добавить();
	Обработчик.ПредыдущееИмяКонфигурации = "УправлениеТорговлей";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыУП.ОбновлениеУТДоERP";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ПредыдущееИмяКонфигурации = "УправлениеТорговлей";
	Обработчик.Процедура = "Справочники.НастройкиХозяйственныхОпераций.ЗаполнитьПредопределенныеНастройкиХозяйственныхОпераций";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ПредыдущееИмяКонфигурации = "КомплекснаяАвтоматизация";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыУП.ОбновлениеКАДоERP";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ПредыдущееИмяКонфигурации = "КомплекснаяАвтоматизация";
	Обработчик.Процедура = "Справочники.НастройкиХозяйственныхОпераций.ЗаполнитьПредопределенныеНастройкиХозяйственныхОпераций";
	
	ОбновлениеИнформационнойБазыЛокализация.ПриДобавленииОбработчиковПереходаНаУП(Обработчики);
	
КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - 
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует
//        указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, 
	Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
	
	Если ПредыдущееИмяКонфигурации = "УправлениеТорговлей"
	 ИЛИ ПредыдущееИмяКонфигурации = "КомплекснаяАвтоматизация" Тогда
		Параметры.ОчиститьСведенияОПредыдущейКонфигурации = Ложь;
		ОбновлениеИнформационнойБазы.УстановитьВерсиюИБ(ПредыдущееИмяКонфигурации, ПредыдущаяВерсияКонфигурации, Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПереименованныеОбъектыМетаданных

// Заполняет переименования объектов метаданных (подсистемы и роли).
// Подробнее см. ОбщегоНазначенияПереопределяемый.ПриДобавленииПереименованийОбъектовМетаданных().
// 
// Параметры:
//   Итог	- Структура - передается в процедуру подсистемой БазоваяФункциональность.
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	ОписаниеПодсистемы = Новый Структура("Имя, Версия, РежимВыполненияОтложенныхОбработчиков, ИдентификаторИнтернетПоддержки");
	ПриДобавленииПодсистемы(ОписаниеПодсистемы);
	
	//++ НЕ УХ
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.2.1.13",
		"Роль.РазделМеждународныйФинансовыйУчет",
		"Роль.ПодсистемаМеждународныйФинансовыйУчет",
		ОписаниеПодсистемы.Имя);
	//-- НЕ УХ
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.1.1.56",
		"Роль.ДобавлениеИзменениеПричинЗадержекВыполненияМаршрутныхЛистов",
		"Роль.ДобавлениеИзменениеПричинЗадержекВыполненияЭтаповПроизводства",
		ОписаниеПодсистемы.Имя);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.1.1.56",
		"Роль.ЧтениеПричинЗадержекВыполненияМаршрутныхЛистов",
		"Роль.ЧтениеПричинЗадержекВыполненияЭтаповПроизводства",
		ОписаниеПодсистемы.Имя);
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполненияПустойИБ

// Обработчик первого запуска УП (ERP).
//
Процедура ПервыйЗапуск() Экспорт
	
	Справочники.СтатьиКалькуляции.НастроитьСтатьюКалькуляцииПредопределенныхЭлементов();
	Справочники.ПланыСчетовМеждународногоУчета.СоздатьМеждународныйПланСчетовПервыйЗапуск();
	
КонецПроцедуры

Процедура ОбновлениеКАДоERP() Экспорт
	
	Справочники.СтатьиКалькуляции.НастроитьСтатьюКалькуляцииПредопределенныхЭлементов();
	ПроизводствоСервер.УстановитьИспользованиеПараметризацииРесурсныхСпецификаций();
	ПроизводствоСервер.УстановитьОпцииДляРаботыСПроизводственнымиОперациями();
	Константы.ДатаНачалаВеденияУчетаВыработкиПоОперациям.Установить(Дата("19800101"));
	
	ЗначенияКонстант = Новый Структура;
	ЗначенияКонстант.Вставить("КомплекснаяАвтоматизация", Ложь);
	ЗначенияКонстант.Вставить("УправлениеПредприятием", Истина);
	
	Для Каждого КлючИЗначение Из ЗначенияКонстант Цикл
		Константы[КлючИЗначение.Ключ].Установить(КлючИЗначение.Значение);
	КонецЦикла; 
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

Процедура ОбновлениеУТДоERP() Экспорт
	
	ПланыВидовХарактеристик.АналитикиСтатейБюджетов.ЗаполнитьПредопределенныеАналитикиСтатейБюджетов();
	Константы.ЗаполненыДвиженияАктивовПассивов.Установить(Истина);
	Константы.ДатаНачалаВеденияУчетаВыработкиПоОперациям.Установить(Дата("19800101"));
	
	ОбновлениеИнформационнойБазыУТ.ЗаполнитьЗначениеРазделенияПоОбластямДанных();
	
	ЗначенияКонстант = Новый Структура;
	ЗначенияКонстант.Вставить("УправлениеТорговлей", Ложь);
	ЗначенияКонстант.Вставить("УправлениеПредприятием", Истина);
	
	Для Каждого КлючИЗначение Из ЗначенияКонстант Цикл
		Константы[КлючИЗначение.Ключ].Установить(КлючИЗначение.Значение);
	КонецЦикла; 
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновленияУП(Обработчики) Экспорт

#Область ДатаНачалаВеденияУчетаВыработкиПоОперациям_ОбработатьДанныеДляПереходаНаНовуюВерсию

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыУП.ДатаНачалаВеденияУчетаВыработкиПоОперациям_ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.4.32";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("a0dff535-3582-4f7c-be1a-dad6274b75bc");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "ОбновлениеИнформационнойБазыУП.ДатаНачалаВеденияУчетаВыработкиПоОперациям_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет константу ""Использовать корректировки заказа материалов в производство"".';
									|en = 'Fills in ""Use material order adjustments to production"" constant.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыНакопления.ТрудозатратыКОформлению.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Константы.ДатаНачалаВеденияУчетаВыработкиПоОперациям.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Константы.ДатаНачалаВеденияУчетаВыработкиПоОперациям.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");

#КонецОбласти

#Область ИспользоватьАналогиМатериалов_ОбработатьДанныеДляПереходаНаНовуюВерсию

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыУП.ИспользоватьАналогиМатериалов_ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.1.29";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("074e3f0c-63a0-4c13-9c70-5a07cc034113");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "ОбновлениеИнформационнойБазыУП.ИспользоватьАналогиМатериалов_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Устанавливает значение в константе ""Использовать аналоги материалов""';
									|en = 'Sets up the value in the constant ""Use substitutes""'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.РазрешениеНаЗаменуМатериалов.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Константы.ИспользоватьАналогиМатериалов.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Константы.ИспользоватьАналогиМатериалов.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.РазрешениеНаЗаменуМатериалов.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

#КонецОбласти

#Область ИспользоватьМаршрутныеКарты_ОбработатьДанныеДляПереходаНаНовуюВерсию

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыУП.ИспользоватьМаршрутныеКарты_ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.7.4";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("149324d7-9c4f-44ed-aa1d-558899a01a5f");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "ОбновлениеИнформационнойБазыУП.ИспользоватьМаршрутныеКарты_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Устанавливает значение в константе ""Использовать маршрутные карты""';
									|en = 'Sets the value in ""Use route sheets"" constant'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Константы.ИспользоватьМаршрутныеКарты.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Константы.ИспользоватьПроизводство.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Константы.ИспользоватьУправлениеПроизводством.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Константы.ИспользоватьУправлениеПроизводством2_2.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Константы.ХранитьОперацииВРесурсныхСпецификациях.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Константы.ИспользоватьМаршрутныеКарты.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Константы.ИспользоватьМаршрутныеКарты.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");

#КонецОбласти

#Область ИспользоватьПараметризациюРесурсныхСпецификаций_ОбработатьДанныеДляПереходаНаНовуюВерсию

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыУП.ИспользоватьПараметризациюРесурсныхСпецификаций_ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.3.26";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("149324d7-9c4f-44ed-aa1d-559355a01a5f");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "ОбновлениеИнформационнойБазыУП.ИспользоватьПараметризациюРесурсныхСпецификаций_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Устанавливает значение в константе ""Использовать параметризацию ресурсных спецификаций""';
									|en = 'Sets a value in the constant ""Use parameterization of bills of materials""'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Константы.ИспользоватьПроизводство.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Константы.ИспользоватьПараметризациюРесурсныхСпецификаций.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Константы.ИспользоватьПараметризациюРесурсныхСпецификаций.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");

#КонецОбласти

#Область ИспользоватьПараметрыНазначенияСпецификаций_ОбработатьДанныеДляПереходаНаНовуюВерсию

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыУП.ИспользоватьПараметрыНазначенияСпецификаций_ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.1.22";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("3c7821ed-ec77-4280-9822-cb552b40c544");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "ОбновлениеИнформационнойБазыУП.ИспользоватьПараметрыНазначенияСпецификаций_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Анализирует наличие в базе основных спецификаций в разрезе подразделений-диспетчеров, и в случае их присутствия включает использование параметров назначения спецификаций и добавляет туда вид параметра ""подразделение диспетчер""';
									|en = 'Analyzes whether the infobase contains the main specifications broken down by dispatching units and, if any, enables using the specification assignment parameters and adds parameter kind ""dispatching unit""'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Константы.ИспользоватьПараметрыНазначенияСпецификаций.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Константы.ИспользоватьУправлениеПроизводством.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Константы.ИспользоватьУправлениеПроизводством2_2.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыСведений.МоделиФормированияСтоимости.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Константы.ИспользоватьПараметрыНазначенияСпецификаций.ПолноеИмя());
	Изменяемые.Добавить(Метаданные.РегистрыСведений.ПараметрыНазначенияСпецификаций.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Константы.ИспользоватьПараметрыНазначенияСпецификаций.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.РегистрыСведений.ПараметрыНазначенияСпецификаций.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");

#КонецОбласти

#Область ПервыйЗапуск

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыУП.ПервыйЗапуск";
	Обработчик.Версия = "";
	Обработчик.РежимВыполнения = "Монопольно";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Комментарий = "";

#КонецОбласти

#Область ПроводкиМеждународногоУчетаПоДаннымОперативного_ОбработатьДанныеДляПереходаНаНовуюВерсию

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыУП.ПроводкиМеждународногоУчетаПоДаннымОперативного_ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.7.1";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("233295c3-6aff-453c-aaf0-e5bf13a55410");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "ОбновлениеИнформационнойБазыУП.ПроводкиМеждународногоУчетаПоДаннымОперативного_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Устанавливает значение в константе ""Проводки международного учета по данным оперативного""';
									|en = 'Sets the value for the ""Financial accounting entries based on the operational accounting data"" constant'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Константы.НастройкаПроводокПоХозяйственнымОперациям.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Константы.ПроводкиМеждународногоУчетаПоДаннымОперативного.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Константы.ПроводкиМеждународногоУчетаПоДаннымОперативного.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Константы.ПроводкиМеждународногоУчетаПоДаннымОперативного.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");

#КонецОбласти

КонецПроцедуры

#Область УстановкаКонстанты_ИспользоватьПараметризациюРесурсныхСпецификаций

Процедура ИспользоватьПараметризациюРесурсныхСпецификаций_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	// Регистрация не требуется
	Возврат;
	
КонецПроцедуры

Процедура ИспользоватьПараметризациюРесурсныхСпецификаций_ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПроизводствоСервер.УстановитьИспользованиеПараметризацииРесурсныхСпецификаций();
	
	Параметры.ОбработкаЗавершена = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область УстановкаКонстанты_ИспользоватьПараметрыНазначенияСпецификаций

Процедура ИспользоватьПараметрыНазначенияСпецификаций_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	// Регистрация не требуется
	Возврат;
	
КонецПроцедуры

Процедура ИспользоватьПараметрыНазначенияСпецификаций_ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА
	|ИЗ
	|	РегистрСведений.МоделиФормированияСтоимости КАК МоделиФормированияСтоимости,
	|	Константа.ИспользоватьПараметрыНазначенияСпецификаций КАК ИспользоватьПараметрыНазначенияСпецификаций,
	|	Константа.ИспользоватьУправлениеПроизводством КАК ИспользоватьУправлениеПроизводством,
	|	Константа.ИспользоватьУправлениеПроизводством2_2 КАК ИспользоватьУправлениеПроизводством2_2
	|ГДЕ
	|	(ИспользоватьУправлениеПроизводством2_2.Значение
	|		И НЕ МоделиФормированияСтоимости.Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|		И НЕ ИспользоватьПараметрыНазначенияСпецификаций.Значение)
	|	ИЛИ (ИспользоватьУправлениеПроизводством.Значение
	|		И НЕ ИспользоватьПараметрыНазначенияСпецификаций.Значение)
	|";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		
		НачатьТранзакцию();
		Попытка
			
			МенеджерЗначения = Константы.ИспользоватьПараметрыНазначенияСпецификаций.СоздатьМенеджерЗначения();
			МенеджерЗначения.Значение = Истина;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(МенеджерЗначения);
			
			НаборЗаписей = РегистрыСведений.ПараметрыНазначенияСпецификаций.СоздатьНаборЗаписей();
			Запись = НаборЗаписей.Добавить();
			Запись.ВидПараметра = Перечисления.ВидыПараметровНазначенияСпецификаций.ПодразделениеДиспетчер;
			Запись.Приоритет    = 2;
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей,,, Истина);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось включить использование параметров назначения спецификаций по причине: %Причина%';
									|en = 'Cannot enable use of specification assignment parameters. Reason: %Причина%'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,,,
				ТекстСообщения);
				
			Возврат;
			
		КонецПопытки;
		
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область УстановкаКонстанты_ИспользоватьМаршрутныеКарты

Процедура ИспользоватьМаршрутныеКарты_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	// Регистрация не требуется
	Возврат;
	
КонецПроцедуры

Процедура ИспользоватьМаршрутныеКарты_ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА
	|ИЗ
	|	Константа.ИспользоватьПроизводство КАК ИспользоватьПроизводство,
	|	Константа.ИспользоватьУправлениеПроизводством КАК ИспользоватьУправлениеПроизводством,
	|	Константа.ИспользоватьУправлениеПроизводством2_2 КАК ИспользоватьУправлениеПроизводством2_2,
	|	Константа.ИспользоватьМаршрутныеКарты КАК ИспользоватьМаршрутныеКарты,
	|	Константа.ХранитьОперацииВРесурсныхСпецификациях КАК ХранитьОперацииВРесурсныхСпецификациях
	|ГДЕ
	|	(ИспользоватьПроизводство.Значение
	|		ИЛИ ИспользоватьУправлениеПроизводством.Значение
	|		ИЛИ ИспользоватьУправлениеПроизводством2_2.Значение)
	|	И НЕ ИспользоватьМаршрутныеКарты.Значение
	|	И НЕ ХранитьОперацииВРесурсныхСпецификациях.Значение
	|";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		
		НачатьТранзакцию();
		Попытка
			
			МенеджерЗначения = Константы.ИспользоватьМаршрутныеКарты.СоздатьМенеджерЗначения();
			МенеджерЗначения.Значение = Истина;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(МенеджерЗначения);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ШаблонСообщения = НСтр("ru = 'Не удалось включить использование маршрутных карт по причине: %1';
									|en = 'Cannot enable the use of route sheets. Reason: %1'");
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Константы.ИспользоватьМаршрутныеКарты,,
				СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
				
			Возврат;
			
		КонецПопытки;
		
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область УстановкаКонстанты_ИспользоватьАналогиМатериалов

Процедура ИспользоватьАналогиМатериалов_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	// Регистрация не требуется
	Возврат;
	
КонецПроцедуры

Процедура ИспользоватьАналогиМатериалов_ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА
	|ИЗ
	|	Документ.РазрешениеНаЗаменуМатериалов КАК РазрешениеНаЗаменуМатериалов";
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Константа.ИспользоватьАналогиМатериалов");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			МенеджерЗначения = Константы.ИспользоватьАналогиМатериалов.СоздатьМенеджерЗначения();
			МенеджерЗначения.Значение = Истина;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(МенеджерЗначения);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось включить использование аналогов материалов по причине: %1';
									|en = 'Cannot enable use of substitutes. Reason: %1'");
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Константы.ИспользоватьАналогиМатериалов,,
				СтрШаблон(ТекстСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()))
			);
			
			ОбработкаЗавершена = Ложь;
				
		КонецПопытки;
	
	КонецЕсли;
		
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#Область УстановкаКонстанты_ДатаНачалаВеденияУчетаВыработкиПоОперациям

Процедура ДатаНачалаВеденияУчетаВыработкиПоОперациям_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	// Регистрация не требуется
	Возврат;
	
КонецПроцедуры

Процедура ДатаНачалаВеденияУчетаВыработкиПоОперациям_ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА
	|ИЗ
	|	РегистрНакопления.ТрудозатратыКОформлению КАК ТрудозатратыКОформлению
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(ТрудозатратыКОформлению.Распоряжение) = ТИП(Документ.ЭтапПроизводства2_2)";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Константа.ДатаНачалаВеденияУчетаВыработкиПоОперациям");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			МенеджерЗначения = Константы.ДатаНачалаВеденияУчетаВыработкиПоОперациям.СоздатьМенеджерЗначения();
			МенеджерЗначения.Значение = Дата("19800101");
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(МенеджерЗначения);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось включить использование операции как распоряжение для выработки: %1';
									|en = 'Cannot enable use of operation as a reference for output: %1'");
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Константы.ДатаНачалаВеденияУчетаВыработкиПоОперациям,,
				СтрШаблон(ТекстСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()))
			);
			
			ОбработкаЗавершена = Ложь;
				
		КонецПопытки;
	
	КонецЕсли;
		
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#Область УстановкаКонстанты_ПроводкиМеждународногоУчетаПоДаннымОперативного

Процедура ПроводкиМеждународногоУчетаПоДаннымОперативного_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	// Регистрация не требуется
	Возврат;
	
КонецПроцедуры

Процедура ПроводкиМеждународногоУчетаПоДаннымОперативного_ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА
	|ИЗ
	|	Константа.ПроводкиМеждународногоУчетаПоДаннымОперативного КАК ПроводкиМеждународногоУчетаПоДаннымОперативного
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Константа.НастройкаПроводокПоХозяйственнымОперациям КАК НастройкаПроводокПоХозяйственнымОперациям
	|		ПО (НЕ ПроводкиМеждународногоУчетаПоДаннымОперативного.Значение)
	|			И (НастройкаПроводокПоХозяйственнымОперациям.Значение)";
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			Блокировка.Добавить("Константа.ПроводкиМеждународногоУчетаПоДаннымОперативного");
			Блокировка.Заблокировать();
			
			Если Константы.НастройкаПроводокПоХозяйственнымОперациям.Получить() Тогда
				МенеджерЗначения = Константы.ПроводкиМеждународногоУчетаПоДаннымОперативного.СоздатьМенеджерЗначения();
				МенеджерЗначения.Значение = Истина;
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(МенеджерЗначения);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось включить настройку Проводки международного учета по данным оперативного: %1';
									|en = 'Cannot disable ""Financial accounting entries based on the operational accounting data"" option: %1'");
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Константы.ПроводкиМеждународногоУчетаПоДаннымОперативного,,
				СтрШаблон(ТекстСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()))
			);
			
			ОбработкаЗавершена = Ложь;
				
		КонецПопытки;
	
	КонецЕсли;
		
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти
