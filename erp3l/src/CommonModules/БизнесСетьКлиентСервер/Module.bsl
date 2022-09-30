////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-сеть".
// ОбщийМодуль.БизнесСетьКлиентСервер.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Конвертирует дату из формата UnixTime в тип Дата.
//
// Параметры:
//   Источник - Число - число в формате UnixTime, например 1405955187848899.
//
// Возвращаемое значение:
//   Дата - значение даты.
//
Функция ДатаИзUnixTime(Источник) Экспорт
	
	Возврат МестноеВремя(Дата(1970, 1, 1, 0 ,0, 0) + Источник / 1000)
	
КонецФункции

// Описание идентификации организации контрагентов в сервисе 1С:Бизнес-сеть.
// 
// Возвращаемое значение:
//  Структура - параметры идентификации организации и контрагентов.
//   * Ссылка - СправочникСсылка - ссылка на организацию или контрагента.
//   * ИНН - Строка - ИНН.
//   * КПП - Строка - КПП.
//   * ЭтоОрганизация - Булево - является организацией.
//   * ЭтоКонтрагент - Булево - является контрагентом (по умолчанию).
//
Функция ОписаниеИдентификацииОрганизацииКонтрагентов() Экспорт
	
	Значение = Новый Структура;
	Значение.Вставить("Ссылка", Неопределено);
	Значение.Вставить("ИНН", "");
	Значение.Вставить("КПП", "");
	Значение.Вставить("ЭтоОрганизация", Ложь);
	Значение.Вставить("ЭтоКонтрагент",  Ложь);
	Значение.Вставить("Организация",    Неопределено);
	
	Возврат Значение;
	
КонецФункции

// Добавление текстового блока Подробности см. в журнале регистрации.
//
Функция ПодробностиВЖурналеРегистрации() Экспорт

	Возврат Символы.ПС + НСтр("ru = 'Подробности см. в журнале регистрации.';
								|en = 'See the event log for details.'");

КонецФункции

// Ссылка на промо сайт ЭДО без электронной подписи.
//
// Возвращаемое значение:
//   Строка - Гиперссылка.
//
Функция ГиперссылкаНаПромоСайтЭДО() Экспорт 
	
	Возврат "https://1cbn.ru/edo.html"; 
	
КонецФункции

// Ссылка на промо сайт 1С:Торговая площадка.
//
// Возвращаемое значение:
//   Строка - Гиперссылка.
//
Функция ГиперссылкаНаПромоСайтТорговаяПлощадка() Экспорт
	
	Возврат "https://1cbn.ru/trading.html"; 
	
КонецФункции

// Статусы документов.
// 
// Возвращаемое значение:
//  Структура - строковые представления с ключами:
//    * Новый - строка - новый документ.
//    * Отправлен - строка - отправлен документ.
//    * Доставлен - строка - документ доставлен.
//    * Загружен - строка - документ загружен.
//    * Отклонен - строка - документ отклонен.
//
Функция Статусы() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Новый",     НСтр("ru = 'Новый';
										|en = 'New'"));
	Результат.Вставить("Отправлен", НСтр("ru = 'Отправлен';
										|en = 'Sent'"));
	Результат.Вставить("Доставлен", НСтр("ru = 'Доставлен';
										|en = 'Delivered'"));
	Результат.Вставить("Загружен",  НСтр("ru = 'Загружен';
										|en = 'Imported'"));
	Результат.Вставить("Отклонен",  НСтр("ru = 'Отклонен';
										|en = 'Rejected'"));
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИмяКомандыПодбораДокументовИзСервиса() Экспорт
	
	Возврат "ПодобратьДокументыИзСервисаБизнесСеть";
	
КонецФункции

Функция ИмяРеквизитаОперацииПодбораДокументовИзСервиса() Экспорт
	
	Возврат "ОбновлениеДанныхДокументовСервисаБизнесСеть";
	
КонецФункции

Функция ИмяРеквизитаВидаДокументаСервиса() Экспорт
	
	Возврат "ВидДокументаСервисаБизнесСеть";
	
КонецФункции

Функция ИмяРеквизитаИспользоватьОбменБизнесСеть() Экспорт
	
	Возврат "ИспользоватьОбменБизнесСеть";
	
КонецФункции

#Область QRКоды

Функция ДанныеДокументаДляПолученияQRКода(Знач СсылкаНаДокумент = Неопределено, Знач Организация = Неопределено) Экспорт
	
	ДанныеДокумента = Новый Структура;
	ДанныеДокумента.Вставить("СсылкаНаДокумент", СсылкаНаДокумент);
	ДанныеДокумента.Вставить("Организация"     , Организация);

	Возврат ДанныеДокумента;
	
КонецФункции

#КонецОбласти

#КонецОбласти