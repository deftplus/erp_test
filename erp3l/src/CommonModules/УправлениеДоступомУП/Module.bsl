
#Область ПрограммныйИнтерфейс

// Заполняет массив структур, которые будут использованы для начального заполнения и восстановления начального заполнения профилей.
//
// Параметры:
//  ОписанияПрофилей - Массив из см. УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа
//  ПараметрыОбновления - Структура:
//   * ОбновлятьИзмененныеПрофили - Булево - начальное значение Истина.
//   * ЗапретитьИзменениеПрофилей - Булево - начальное значение Истина.
//       Если установить Ложь, тогда поставляемые профили можно не только просматривать, но и редактировать.
//   * ОбновлятьГруппыДоступа     - Булево - начальное значение Истина.
//   * ОбновлятьГруппыДоступаСУстаревшимиНастройками - Булево - начальное значение Ложь.
//       Если установить Истина, то настройки значений, выполненные администратором для
//       вида доступа, который был удален из профиля, будут также удалены из групп доступа.
Процедура ЗаполнитьПоставляемыеПрофилиГруппДоступа(ОписанияПрофилей, ПараметрыОбновления) Экспорт

	УправлениеРемонтами.ЗаполнитьПоставляемыеПрофилиГруппДоступа(ОписанияПрофилей, ПараметрыОбновления);
	
#Область Описание_профилей_Учет_производства
	ДобавитьПрофильГлавногоДиспетчера(ОписанияПрофилей);
	ДобавитьПрофильМенеджераПроизводства(ОписанияПрофилей);
	ДобавитьПрофильМенеджераПоПереработкеДавальческогоСырья(ОписанияПрофилей);
#КонецОбласти
	
//++ НЕ УХ
#Область Создать_профиля_МеждународныйУчет
	ДобавитьПрофильАналитикМеждународногоУчета(ОписанияПрофилей);
	ДобавитьПрофильБухгалтерМеждународногоУчета(ОписанияПрофилей);
	ДобавитьПрофильПользовательОтчетностиМеждународногоУчета(ОписанияПрофилей);
#КонецОбласти
//-- НЕ УХ
	
	УправлениеДоступомЛокализация.ДополнитьПоставляемыеПрофилиГруппДоступа(ОписанияПрофилей, ПараметрыОбновления);

КонецПроцедуры

// Дополняет профиль обязательными ролями.
// 
// Параметры:
// 	ОписаниеПрофиля - см. УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа
Процедура ДополнитьПрофильОбязательнымиРолями(ОписаниеПрофиля) Экспорт
	
	УправлениеДоступомКА.ДополнитьПрофильОбязательнымиРолями(ОписаниеПрофиля);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//++ НЕ УХ
#Область МеждународныйУчет

Процедура ДобавитьПрофильАналитикМеждународногоУчета(ОписанияПрофилей)
	
	// Профиль "Аналитик международного учета (дополнительный)".
	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Имя           = "АналитикМеждународногоУчета";
	ОписаниеПрофиля.Идентификатор = "a710f198-2e62-4a11-9b0e-40b79ca97aec";
	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Аналитик международного учета (дополнительный)';
										|en = 'Financial accounting analyst (additional)'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеГруппФинансовогоУчета");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеГруппАналитическогоУчетаНоменклатуры");
	ОписаниеПрофиля.Роли.Добавить("ПодсистемаМеждународныйФинансовыйУчет");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеНастройкаМеждународногоУчета");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеМеждународныйУчет");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНастроекСчетовУчетаПрочихОпераций");
	
	УправлениеДоступомЛокализация.ДополнитьПрофильАналитикМеждународногоУчета(ОписаниеПрофиля);
	
	// Виды доступа.
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации", "ВначалеВсеРазрешены");
	
	// Описание поставляемого профиля.
	ОписаниеПрофиля.Описание = НСтр("ru = 'Дополнительный профиль, назначаемый пользователям для выполнения задач:
						|1. Настройка международного учета.
						|2. Настройка отражения документов в международном учете.
						|3. Получение отчетов по данным международного учета.';
						|en = 'Additional profile assigned to users to perform the following tasks:
						|1. Configure financial accounting.
						|2. Configure financial accounting posting.
						|3. Receive reports on financial accounting data.'");
	
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
	
КонецПроцедуры

Процедура ДобавитьПрофильБухгалтерМеждународногоУчета(ОписанияПрофилей)
	
	// Профиль "Бухгалтер международного учета".
	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Имя           = "БухгалтерМеждународногоУчета";
	ОписаниеПрофиля.Идентификатор = "55e653bc-b975-48bc-beb5-aa97125cd1ff";
	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Бухгалтер международного учета';
										|en = 'Financial accounting accountant'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	УправлениеДоступомУТ.ДополнитьПрофильОбязательнымиРолями(ОписаниеПрофиля);
	УправлениеДоступомУТ.ДобавитьРолиБухгалтераРеглУчетаНаЧтение(ОписаниеПрофиля);
	
	// Видимые подсистемы КИ
	ОписаниеПрофиля.Роли.Добавить("ПодсистемаМеждународныйФинансовыйУчет");
	
	// Международный учет
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеМеждународныйУчет");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНастройкаМеждународногоУчета");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНастроекСчетовУчетаПрочихОпераций");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОбработкиОперацииЗакрытияМесяца");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрОтчетаАнализКорреспонденцийОперативногоУчета");
	
	УправлениеДоступомЛокализация.ДополнитьПрофильБухгалтерМеждународногоУчета(ОписаниеПрофиля);
	
	// Виды доступа.
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации", "ВначалеВсеРазрешены");
	
	// Описание поставляемого профиля.
	ОписаниеПрофиля.Описание = НСтр("ru = 'Под профилем выполняются задачи:
						|1. Ведение международного учета.
						|2. Получение отчетов по данным международного учета.';
						|en = 'The following tasks are performed under the profile:
						|1. Financial accounting.
						|2. Receipt of reports according to the financial accounting data.'");
	
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
	
КонецПроцедуры

Процедура ДобавитьПрофильПользовательОтчетностиМеждународногоУчета(ОписанияПрофилей)
	
	// Профиль "Пользователь отчетности международного учета (дополнительный)".
	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Имя           = "ПользовательОтчетностиМеждународногоУчета";
	ОписаниеПрофиля.Идентификатор = "8d2d58eb-0619-4bb9-8f8d-119e01c112ad";
	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Пользователь отчетности международного учета (дополнительный)';
										|en = 'User of financial accounting reporting (additional)'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	ОписаниеПрофиля.Роли.Добавить("ПодсистемаМеждународныйФинансовыйУчет");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеМеждународныйУчет");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНастройкаМеждународногоУчета");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНастроекСчетовУчетаПрочихОпераций");
	
	УправлениеДоступомЛокализация.ДополнитьПрофильПользовательОтчетностиМеждународногоУчета(ОписаниеПрофиля);
	
	// Виды доступа.
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации", "ВначалеВсеРазрешены");
	
	// Описание поставляемого профиля.
	ОписаниеПрофиля.Описание = НСтр("ru = 'Дополнительный профиль, назначаемый пользователям для получения отчетов по данным международного учета.';
									|en = 'Additional profile assigned to users for receipt of reports on financial accounting data.'");
	
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
	
КонецПроцедуры

#КонецОбласти
//-- НЕ УХ

#Область Учет_производства

Процедура ДобавитьПрофильГлавногоДиспетчера(ОписанияПрофилей)
	
	// Описание для заполнения профиля "Главный диспетчер производства".
	// Профиль "Главный диспетчер производства".
	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Имя           = "ГлавныйДиспетчер";
	ОписаниеПрофиля.Идентификатор = "90a9321f-a088-47f1-afd4-47b8f052ebc1";
	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Главный диспетчер производства';
										|en = 'Chief production scheduler'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	ДополнитьПрофильОбязательнымиРолями(ОписаниеПрофиля);
	
	// Роли к элементарным функциям.
	
	УправлениеДоступомКА.ДобавитьРолиЛокальногоДиспетчера(ОписаниеПрофиля);
	
	ОписаниеПрофиля.Роли.Добавить("УправлениеОчередьюЗаказовНаПроизводство");
	ОписаниеПрофиля.Роли.Добавить("ПланированиеГрафикаПроизводства2_2");
	
	// Справочники, чтение.
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКасс");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСоглашенийСПоставщиками");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСоглашенийСКлиентами");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЦенНоменклатуры");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНоменклатурыПартнеров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПартийПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНоменклатурыКонтрагентовБЭД");
	
	// Документы, чтение.
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковВзаиморасчетов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковДенежныхСредств");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковОПродажахЗаПрошлыеПериоды");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковПоФинансовымИнструментам");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковПрочиеРасходы");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковПрочихАктивовПассивов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковРасчетовПоЭквайрингу");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковСПодотчетниками");

	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВыработкиСотрудников");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТранспортныхНакладных");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовКлиентовЗаявокНаВозвратТоваровОтКлиента");
	//++ Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовНаПроизводство");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПеремещенияМатериаловВПроизводстве");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеМаршрутныхЛистовПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВыпускаПродукции");
	//-- Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПлановыхКалькуляций");
	
	// Документы, добавление.
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеАктаВыполненныхВнутреннихРабот");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеЗаказовНаПроизводство2_2");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеУпаковочныхЛистов");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПлановыхКалькуляций");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПроизводстваБезЗаказов");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеРазрешенийНаЗаменуМатериалов");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеРаспределенияВозвратныхОтходов");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеРаспределенияПроизводственныхЗатрат");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеРаспределенияПрочихЗатрат");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеКорректировокНазначенияТоваров");
	ОписаниеПрофиля.Роли.Добавить("ДополнительныеОперацииКорректировкиНазначенияТоваров");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеНормативовЗатрат");
	//++ Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеЗаказовНаПроизводство");
	//-- Устарело_Производство21
	
	// Справочники, добавление изменение.
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеВидовРаботСотрудников");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеРесурсныхСпецификаций");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеСтруктурыРабочихЦентров");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеКалендарей");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеНазначений");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПриоритетов");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПроизводственныхУчастков");
	
	// Регистры, добавление изменение.
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеРасценокРаботСотрудников");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеОсновныхМаршрутныхКарт");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеТехнологическихПроцессов");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеМоделейФормированияСтоимости");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеГрафикаЭтаповПроизводства2_2");
	
	// Регистры, чтение.
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковДоступныхТоваров");
	//++ Локализация
	//-- Локализация
	//++ Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСостоянийОбеспеченияМаршрутныхЛистов");
	//-- Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСостоянияЗаказовКлиента");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЦенПартнеров");
	//++ Локализация
	//-- Локализация
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТрудозатратНезавершенногоПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТоваровОрганизаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПрочихДоходовРасходов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковЗаказовПоставщикам");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДоступностиВидовРабочихЦентров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСебестоимостиТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНастроекРаспределенияПостатейныхРасходов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПроизводственныхЗатрат");
	//++ Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЭтаповПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРаспоряженийНаВыпускПродукции");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРасписанияРабочихЦентров");
	//-- Устарело_Производство21
	
	// Регистры расширенной аналитики управленческого учета
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВыручкиОтПродаж");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДвиженийНоменклатураКонтрагент");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДвиженийНоменклатураДоходыРасходы");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДвиженийНоменклатураНоменклатура");
	
	// Обработки, отчеты.
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДоступностиДляГрафикаПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ОтчетыГлавногоДиспетчера");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрОтчетаОстаткиИДоступностьТоваров");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОбработкиЖурналДокументовВнутреннегоТовародвижения");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОбеспечениеПотребностей");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеФормированиеЗаказовМатериаловПоПотребностям");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОформленияПроизводстваБезЗаказов");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеДереваРесурсныхСпецификаций");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрОтчетовПлановойПотребности");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрОтчетаТоварыСИстекающимиСертификатами");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрОтчетовГрафикПроизводстваЭтапов");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрЖурналаРегистрации");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрКомандыСостояниеОбеспеченияЗаказов");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОбработкиСостояниеОбеспеченияЗаказов");
	//++ Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеРедактированиеСпецификацииСтрокиЗаказа");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеДиспетчированияГрафикаПроизводства");
	//-- Устарело_Производство21
	
	// Планирование
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПлановПродаж");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОбработкиФормированиеЗаказовНаПроизводствоПоПлану");
	
	// КИ
	ОписаниеПрофиля.Роли.Добавить("ПодсистемаПроизводство");
	ОписаниеПрофиля.Роли.Добавить("РазделПроизводствоПроизводствоНаСтороне");
	ОписаниеПрофиля.Роли.Добавить("ПодсистемаБюджетированиеИПланирование");
	
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации","ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("Подразделения", "ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("Склады", "ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ГруппыНоменклатуры", "ВначалеВсеРазрешены");
	
	УправлениеДоступомЛокализация.ДобавитьРолиГлавногоДиспетчера(ОписаниеПрофиля);
	
	ОписаниеПрофиля.Описание = НСтр("ru = 'Зона ответственности - производственные заказы в совокупности,
											|управление всеми производственными циклами в целом.
											|Под профилем выполняются задачи:
											|1. формирование очереди заказов на производство;
											|2. формирование графика выполнения заказов;
											|3. корректировка производственных этапов и потребностей в ресурсах по заказу;
											|4. формирование графика потребности в ресурсах и анализ обеспечения производства ТМЦ;
											|5. анализ состояния и загрузки оборудования;
											|6. управление глобальными отклонениями,оперативное диспетчирование графика производства;
											|7. формирование ресурсных спецификаций с учетом партий запуска;
											|8. контроль за оформлением заказов по оказанию межцеховых услуг;
											|9. контроль выполнения взаимных требований и претензий подразделений предприятия.';
											|en = 'Area of responsibility – production orders in total,
											|all production cycles management in total.
											|Tasks completed by the account:
											|1. Schedule production order queue
											|2. Schedule order fulfillment
											|3. Adjust production stages and resource demands by orders
											|4. Schedule resource demands and performing inventory fulfillment analysis
											|5. Analyze equipment state and load
											|6. Global variance management, operational production scheduling
											|7. Develop resource BOMs considering starting lots
											|8. Control registration of intershop service orders
											|9. Control fulfillment of mutual requirements and complaints of company business units.'");
	
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
	
КонецПроцедуры

Процедура ДобавитьПрофильМенеджераПроизводства(ОписанияПрофилей)
	
	// Профиль "Менеджер производства".
	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Имя           = "МенеджерПроизводства";
	ОписаниеПрофиля.Идентификатор = "a90d907c-a823-454b-8bc0-5e5f1807c835";
	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Менеджер производства';
										|en = 'Production manager'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	ДополнитьПрофильОбязательнымиРолями(ОписаниеПрофиля);
	
	// Справочники, чтение.
	ОписаниеПрофиля.Роли.Добавить("ЧтениеИнформацииПоНоменклатуре");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеШаблоновЭтикетокИЦенников");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеПроизводстваВПанелиНавигацииНоменклатуры");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНазначений");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНормативноСправочнойИнформации");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОрганизацийИБанковскихСчетовОрганизаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКасс");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеМаршрутныхКарт");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТехнологическихПроцессов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСтруктурыРабочихЦентров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВидовРаботСотрудников");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКалендарей");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеАссортимента");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПриоритетов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПричинЗадержекВыполненияЭтаповПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПричинОтменыПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПричинОтменыЗаказовПоставщикам");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПроизводственныхУчастков");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПартийПроизводства");
	
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОбъектовЭксплуатации");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКлассовОбъектовЭксплуатации");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВидовРемонтов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОбщихВидовРемонтов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДефектов");
	
	// Справочники, добавление изменение.
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеБригад");
	
	// Регистры, чтение.
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВыполненныхРаботСотрудников");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРасценокРаботСотрудников");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТрудозатратПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНастроекРаспределенияЗатрат");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСтатейКалькуляции");	
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРесурсныхСпецификаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВыпускаПродукцииРегистр");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОсновныхМаршрутныхКарт");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеМоделейФормированияСтоимости");
	//++ Локализация
	//-- Локализация
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПроизводственныхЗатрат");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПартийПроизводственныхЗатрат");
	//++ Локализация
	//-- Локализация
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковМатериаловИРаботВПроизводстве");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗначенийПоказателейДляРаспределенияРасходов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПрочихДоходовРасходов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЦенНоменклатуры");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДоступностиВидовРабочихЦентров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСостоянийДоставки");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСостоянияЗаказовКлиента");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковЗаказовНаВнутреннееПотребление");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковЗаказовНаПеремещение");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковЗаказовНаСборку");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковЗаказовМатериаловВПроизводство");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковДоступныхТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковТоваровКПоступлению");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковТоваровНаСкладах");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРемонтовРабочихЦентров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковТоваровКОтгрузке");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПродукцииИПолуфабрикатовВПроизводстве");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеГрафикаЭтаповПроизводства2_2");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеАналоговМатериалов");
	//++ Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЭтаповПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРаспоряженийНаВыпускПродукции");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПотреблениеМатериаловИУслугВПроизводстве");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПооперационногоРасписания");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовНаПроизводствоТрудозатраты");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовНаПроизводствоСпецификации");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеГрафикаПроизводства");
	//-- Устарело_Производство21
	
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСебестоимостиТоваров");
	// Регистры расширенной аналитики управленческого учета
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВыручкиОтПродаж");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДвиженийНоменклатураКонтрагент");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДвиженийНоменклатураДоходыРасходы");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДвиженийНоменклатураНоменклатура");
	
	// Документы, чтение.
	ОписаниеПрофиля.Роли.Добавить("ЧтениеАктаВыполненныхВнутреннихРабот");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДокументовПоПереработкеДавальческогоСырья");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДвиженийПродукцииИМатериалов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПеремещенийТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСборокТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовНаРемонт");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТранспортныхНакладных");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовНаПроизводство2_2");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЭтаповПроизводства2_2");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПроизводстваБезЗаказов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСменныхЗаданий");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовМатериаловВПроизводство");
	//++ Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовНаПроизводство");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПередачМатериаловВПроизводство");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВозвратовМатериаловИзПроизводства");
	//-- Устарело_Производство21

	// Документы, добавление.
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеВыработкиСотрудников");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеУпаковочныхЛистов");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПроизводственныхОпераций2_2");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДвиженийПродукцииИМатериалов");
	//++ Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ИзменениеМаршрутныхЛистовПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеВыпускаПродукции");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПеремещенияМатериаловВПроизводстве");
	//-- Устарело_Производство21
	
	// Обработки, отчеты.
	ОписаниеПрофиля.Роли.Добавить("ОтчетыМенеджераПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОбработкиЖурналДокументовВнутреннегоТовародвижения");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОбработкиЖурналДокументовПереработки");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеПараметрыОбеспеченияПотребностей");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрОтчетаТоварыСИстекающимиСертификатами");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОбработкиСостояниеОбеспеченияЗаказов");
	//++ Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ПросмотрОтчетовПоВыполнениюМаршрутныхЛистов");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрОтчетовОЗагрузкеРабочихЦентров");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеВыполненияОпераций");
	//-- Устарело_Производство21	
	
	// Регистры, добавление изменение.
	//++ Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНастроекПередачиМатериаловВПроизводство");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПооперационногоРасписания");
	//-- Устарело_Производство21
	
	// Формы.
	//++ Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеВыполнениеМаршрутныхЛистов");
	//-- Устарело_Производство21
	
	// КИ.
	ОписаниеПрофиля.Роли.Добавить("ПодсистемаПроизводство");
	
	ОписаниеПрофиля.ВидыДоступа.Добавить("Подразделения", "ВначалеВсеРазрешены");
	
	УправлениеДоступомЛокализация.ДобавитьРолиМенеджераПроизводства(ОписаниеПрофиля);
	
	// Описание поставляемого профиля.
	ОписаниеПрофиля.Описание = НСтр("ru = 'Зона ответственности - один или несколько производственных участков.
											|Под профилем выполняются задачи:
											|1. оформление выпуска продукции и работ;
											|2. получение материалов в производстве;
											|3. оформление выработки сотрудников по выполненным работам;
											|4. отражение хода выполнения пооперационного расписания производства.';
											|en = 'Area of responsibility – one or several production sites.
											|Tasks completed by the account:
											|1. Register product and labor release
											|2. Receive materials in production;
											|3. Register timesheets charge by performed works
											|4. Record progress of production operation timetable.'");
	
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
	
КонецПроцедуры

Процедура ДобавитьПрофильМенеджераПоПереработкеДавальческогоСырья(ОписанияПрофилей)
	
	// Профиль "Менеджер по переработке давальческого сырья".
	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Имя           = "МенеджерПоПереработкеДавальческогоСырья";
	ОписаниеПрофиля.Идентификатор = "7387da79-e932-11e2-a832-c86000df10d3";
	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Менеджер по переработке давальческого сырья';
										|en = 'Provided material processing officer'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	ДополнитьПрофильОбязательнымиРолями(ОписаниеПрофиля);
	
	///////////////////////////////////////////////////////////////////////
	// Базовые права.
	ОписаниеПрофиля.Роли.Добавить("БазовыеПраваУТ");
	
	///////////////////////////////////////////////////////////////////////
	// Справочники, чтение.
	
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНазначений");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКалендарей");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеАссортимента");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеМаршрутныхКарт");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТехнологическихПроцессов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСоглашенийСКлиентами");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСоглашенийСПоставщиками");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДоговоровКонтрагентов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеИнформацииПоПартнерам");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеИнформацииПоНоменклатуре");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеШаблоновЭтикетокИЦенников");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеПроизводстваВПанелиНавигацииНоменклатуры");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНормативноСправочнойИнформации");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПодключаемогоОборудованияOffline");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОрганизацийИБанковскихСчетовОрганизаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКасс");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВидовРаботСотрудников");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНоменклатурыПартнеров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРесурсныхСпецификаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСтатейКалькуляции");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСтруктурыРабочихЦентров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПроизводственныхУчастков");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПриоритетов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПричинОтменыЗаказовКлиентов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПричинОтменыЗаказовПоставщикам");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНоменклатурыКонтрагентовБЭД");
	
	///////////////////////////////////////////////////////////////////////
	// Справочники, добавление изменение.
	
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеТранспортныхСредств");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДоговоровКонтрагентов");
	ОписаниеПрофиля.Роли.Добавить("ИзменениеСкладскойИнформацииПоНоменклатуре");
	ОписаниеПрофиля.Роли.Добавить("РегистрацияШтрихкодовНоменклатуры");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеНазначений");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеСделок");
	
	///////////////////////////////////////////////////////////////////////
	// Регистры, чтение.
	
	//++ Локализация
	//-- Локализация
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЦенНоменклатуры");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТоваровОрганизаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРасчетовСКлиентами");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРасчетовСПоставщиками");	
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковТоваровНаСкладах");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковДоступныхТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковЗаказовПоставщикам");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковТоваровКОтгрузке");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковТоваровКПоступлению");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковДенежныхСредствКРасходу");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТоваровКОформлениюДокументовИмпорта");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеАссортимента");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСостоянийДоставки");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСостоянияЗаказовКлиента");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеМоделейФормированияСтоимости");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОсновныхМаршрутныхКарт");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковЗаказовКлиентовЗаявокНаВозврат");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовПоставщикам");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеАналоговМатериалов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТоваровКОформлениюДокументовИмпорта");
	//++ Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПотреблениеМатериаловИУслугВПроизводстве");
	//-- Устарело_Производство21
	
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСебестоимостиТоваров");
	// Регистры расширенной аналитики управленческого учета
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВыручкиОтПродаж");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДвиженийНоменклатураКонтрагент");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДвиженийНоменклатураДоходыРасходы");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДвиженийНоменклатураНоменклатура");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПроизводственныхЗатрат");
	
	///////////////////////////////////////////////////////////////////////
	// Документы, чтение.
	
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаданийНаПеревозку");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковВзаиморасчетов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковДенежныхСредств");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковОПродажахЗаПрошлыеПериоды");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковПоФинансовымИнструментам");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковПрочиеРасходы");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковПрочихАктивовПассивов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковРасчетовПоЭквайрингу");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковСПодотчетниками");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатковТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКассовыхОрдеров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОтчетовКомитенту");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОтчетовКомиссионеров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПеремещенийТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДвиженийПродукцииИМатериалов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСборокТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПрочихОприходованийТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОперацийПоПлатежнойКарте");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОтчетовОРозничныхПродажах");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДокументовКорректировкиЗадолженности");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДокументовСписанияПоступленияБезналичныхДС");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДокументовПередачиТоваровМеждуОрганизациями");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДокументовПоПереработкеДавальческогоСырья");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКорректировокОбособленногоУчетаЗапасов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРеализацийУслугПрочихАктивов"); 
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаданийНаПеревозку");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеУпаковочныхЛистов");
	//++ Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПередачМатериаловВПроизводство");
	//-- Устарело_Производство21
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОперацийСПодарочнымиСертификатами");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЧековККМ");
	
	///////////////////////////////////////////////////////////////////////
	// Документы, добавление изменение.
	
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеВозвратовДавальцам");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеВыкуповВозвратнойТарыКлиентами");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеЗаказовДавальцев");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеОтчетовДавальцам");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПередачДавальцам");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПоступленийОтДавальцев");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеТранспортныхНакладных");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеРасходныхОрдеровНаТовары");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДокументовКорректировкиЗадолженностиЗачетОплаты");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПорученийЭкспедиторам");
	ОписаниеПрофиля.Роли.Добавить("ЗачетОплаты");
	
	///////////////////////////////////////////////////////////////////////
	// Обработки, отчеты.
	
	ОписаниеПрофиля.Роли.Добавить("ОтчетыПроизводстваИзДавальческогоСырья");
	ОписаниеПрофиля.Роли.Добавить("ОтчетыМенеджераПоПродажам");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрОтчетаОстаткиИДоступностьТоваров");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрОтчетаСостояниеВыполненияДокумента");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрОтчетаТоварыСИстекающимиСертификатами");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрЭтаповОплатыКлиентом");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОбработкиЖурналДокументовВнутреннегоТовародвижения");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОбработкиЖурналДокументовПереработки");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеУправлениеПеремещениемОбособленныхТоваров");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрКомандыСостояниеОбеспеченияЗаказов");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОбработкиПечатьЭтикетокИЦенников");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеОбработкиСостояниеОбеспеченияЗаказов");
	
	///////////////////////////////////////////////////////////////////////
	// Видимые подсистемы КИ
	
	ОписаниеПрофиля.Роли.Добавить("РазделЗакупки");
	ОписаниеПрофиля.Роли.Добавить("РазделПродажи");
	ОписаниеПрофиля.Роли.Добавить("ПодсистемаСклад");
	ОписаниеПрофиля.Роли.Добавить("РазделПродажиПриемВПереработку");
	ОписаниеПрофиля.Роли.Добавить("РазделНормативноСправочнаяИнформация");
	
	///////////////////////////////////////////////////////////////////////
	// Виды доступа
	
	ОписаниеПрофиля.ВидыДоступа.Добавить("ВидыЦен",									"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ГруппыПартнеров",							"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ГруппыФизическихЛиц",						"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ГруппыНоменклатуры",						"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации",								"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("Склады",									"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ВидыЦен",									"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("Подразделения",							"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ВидыОперацийВзаимозачетаЗадолженности", 	"ВначалеВсеРазрешены");
	
	///////////////////////////////////////////////////////////////////////
	// Дополнительные права.
	
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеНастройкиПечатиОбъектов");
	ОписаниеПрофиля.Роли.Добавить("СохранениеНастроекПечатиОбъектовПоУмолчанию");
	ОписаниеПрофиля.Роли.Добавить("ИзменениеКурсаВДокументахПродажи");
	
	ОписаниеПрофиля.Роли.Добавить("ОтклонениеОтУсловийПродаж");
	
	УправлениеДоступомЛокализация.ДобавитьРолиМенеджераПоПереработкеДавальческогоСырья(ОписаниеПрофиля);
	
	///////////////////////////////////////////////////////////////////////
	// Описание поставляемого профиля.
	
	ОписаниеПрофиля.Описание =
		НСтр("ru = 'Под профилем выполняются задачи:
					|1. Оформление заказов давальцев;
					|2. Отражения поступлений от давальцев и передач давальцам;
					|3. Оформление отчетов давальцам о выполнении услуг по переработке.';
					|en = 'The following tasks are completed under the profile:
					|1. Registration of material provider orders
					|2. Recording of receipts from material providers and transfers to material providers
					|3. Registration of reports to material providers on provision of the processing services.'");
	
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти