///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Отправляет SMS через SMS4B.
//
// Параметры:
//  НомераПолучателей - Массив - номера получателей в формате +7ХХХХХХХХХХ;
//  Текст 			  - Строка - текст сообщения, длиной не более 480 символов;
//  ИмяОтправителя 	  - Строка - имя отправителя, которое будет отображаться вместо номера входящего SMS;
//  Логин			  - Строка - логин пользователя услуги отправки sms;
//  Пароль			  - Строка - пароль пользователя услуги отправки sms.
//
// Возвращаемое значение:
//   см. ОтправкаSMS.ОтправитьSMS.
//
Функция ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя, Логин, Пароль) Экспорт
	
	Результат = Новый Структура("ОтправленныеСообщения,ОписаниеОшибки", Новый Массив, "");
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("Login", Логин);
	ПараметрыЗапроса.Вставить("Password", Пароль);
	ПараметрыЗапроса.Вставить("Source", ИмяОтправителя);
	ПараметрыЗапроса.Вставить("Text", Текст);
	
	Для Каждого НомерПолучателя Из НомераПолучателей Цикл
		ПараметрыЗапроса.Вставить("Phone", ФорматироватьНомер(НомерПолучателя));
		РезультатЗапроса = ВыполнитьЗапрос("SendTXT", ПараметрыЗапроса);
		
		Если СтрДлина(РезультатЗапроса) = 20 Тогда
			ОтправленноеСообщение = Новый Структура("НомерПолучателя,ИдентификаторСообщения", НомерПолучателя, РезультатЗапроса);
			Результат.ОтправленныеСообщения.Добавить(ОтправленноеСообщение);
		Иначе
			Результат.ОписаниеОшибки = Результат.ОписаниеОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'SMS на номер %1 не отправлено';
					|en = 'Couldn''t send message to %1'"), НомерПолучателя) + ": " + ОписаниеОшибкиОтправки(РезультатЗапроса) + Символы.ПС;
		КонецЕсли;
	КонецЦикла;
	
	Результат.ОписаниеОшибки = СокрП(Результат.ОписаниеОшибки);
	Если Не ПустаяСтрока(Результат.ОписаниеОшибки) Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS';
										|en = 'Text messaging'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , Результат.ОписаниеОшибки);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает текстовое представление статуса доставки сообщения.
//
// Параметры:
//  ИдентификаторСообщения - Строка - идентификатор, присвоенный sms при отправке.
//  НастройкиОтправкиSMS   - см. ОтправкаSMS.НастройкиОтправкиSMS.
//
// Возвращаемое значение:
//   см. ОтправкаSMS.СтатусДоставки.
//
Функция СтатусДоставки(ИдентификаторСообщения, НастройкиОтправкиSMS) Экспорт
	
	Логин = НастройкиОтправкиSMS.Логин;
	Пароль = НастройкиОтправкиSMS.Пароль;
	
	// Подготовка параметров запроса.
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("Login", Логин);
	ПараметрыЗапроса.Вставить("Password", Пароль);
	ПараметрыЗапроса.Вставить("MessageId", ИдентификаторСообщения);
	
	// отправка запроса
	КодСостояния = ВыполнитьЗапрос("StatusTXT", ПараметрыЗапроса);
	Если ПустаяСтрока(КодСостояния) Тогда
		Возврат "Ошибка";
	КонецЕсли;
	
	Результат = СтатусДоставкиSMS(КодСостояния);
	Если Результат = "Ошибка" Тогда
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
			"ru = 'Не удалось получить статус доставки SMS (id: ""%3""):
			|%1 (код ошибки: %2)';
			|en = 'Getting delivery status for SMS message with ID %3 failed with error code %2.
			|Details: %1'"), ОписаниеОшибкиПолученияСтатуса(КодСостояния), КодСостояния, ИдентификаторСообщения);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS';
										|en = 'Text messaging'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СтатусДоставкиSMS(Знач КодСостояния)
	СоответствиеСтатусов = Новый Соответствие;
	СоответствиеСтатусов.Вставить("-21", "НеОтправлялось");
	СоответствиеСтатусов.Вставить("-22", "НеОтправлялось");
	
	Если ПустаяСтрока(КодСостояния) Или СтрНачинаетсяС(КодСостояния, "-") 
		Или Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(КодСостояния) Тогда
			Результат = СоответствиеСтатусов[НРег(КодСостояния)];
			Возврат ?(Результат = Неопределено, "Ошибка", Результат);
	КонецЕсли;
	
	КодСостояния = Число(КодСостояния);
	
	ВсегоФрагментов = КодСостояния % 256;
	ОтправленоФрагментов = Цел(КодСостояния / 256) % 256;
	ОкончательныйСтатус = КодСостояния >= 256*256;
	
	Если ОкончательныйСтатус Тогда
		Если ВсегоФрагментов = 0 Или ВсегоФрагментов > ОтправленоФрагментов Тогда
			Результат = "НеДоставлено";
		Иначе
			Результат = "Доставлено";
		КонецЕсли;
	Иначе
		Если ВсегоФрагментов = 0 Или ВсегоФрагментов > ОтправленоФрагментов Тогда
			Результат = "Отправляется";
		Иначе
			Результат = "Отправлено";
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ОписанияОшибок()
	ОписанияОшибок = Новый Соответствие;
	
	ОписанияОшибок.Вставить("0", НСтр("ru = 'Превышен предел открытых сессий.';
										|en = 'Open session limit exceeded.'"));
	ОписанияОшибок.Вставить("-1", НСтр("ru = 'Неверный логин или пароль.';
										|en = 'Invalid credentials.'"));
	ОписанияОшибок.Вставить("-10", НСтр("ru = 'Отказ сервиса.';
										|en = 'Service failed.'"));
	ОписанияОшибок.Вставить("-20", НСтр("ru = 'Сбой сеанса связи.';
										|en = 'Session failed.'"));
	ОписанияОшибок.Вставить("-21", НСтр("ru = 'Сообщение не идентифицировано.';
										|en = 'Message ID not found.'"));
	ОписанияОшибок.Вставить("-22", НСтр("ru = 'Неверный идентификатор сообщения.';
										|en = 'Invalid message ID.'"));
	ОписанияОшибок.Вставить("-29", НСтр("ru = 'Отвергнуто спам-фильтром.';
										|en = 'Rejected by anti-spam filter.'"));
	ОписанияОшибок.Вставить("-30", НСтр("ru = 'Неверная кодировка сообщения.';
										|en = 'Invalid encoding.'"));
	ОписанияОшибок.Вставить("-31", НСтр("ru = 'Неразрешенная зона тарификации.';
										|en = 'Unsupported tariff zone.'"));
	ОписанияОшибок.Вставить("-50", НСтр("ru = 'Неверный отправитель.';
										|en = 'Invalid sender.'"));
	ОписанияОшибок.Вставить("-51", НСтр("ru = 'Неразрешенный получатель.';
										|en = 'Restricted recipient.'"));
	ОписанияОшибок.Вставить("-52", НСтр("ru = 'Недостаточно средств на счете.';
										|en = 'Insufficient funds.'"));
	ОписанияОшибок.Вставить("-53", НСтр("ru = 'Незарегистрированный отправитель.';
										|en = 'Unregistered sender.'"));
	ОписанияОшибок.Вставить("-65", НСтр("ru = 'Необходимы гарантии отправителя, обратитесь в техподдержку.';
										|en = 'Sender assurance required. Please contact the support.'"));
	ОписанияОшибок.Вставить("-66", НСтр("ru = 'Не задан отправитель.';
										|en = 'Sender required.'"));
	ОписанияОшибок.Вставить("-68", НСтр("ru = 'Аккаунт заблокирован.';
										|en = 'Account blocked.'"));
	
	Возврат ОписанияОшибок;
КонецФункции

Функция ОписаниеОшибкиОтправки(КодОшибки)
	ОписанияОшибок = ОписанияОшибок();
	ТекстСообщения = ОписанияОшибок[КодОшибки];
	Если ТекстСообщения = Неопределено Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Код ошибки: ""%1"".';
				|en = 'Error code: %1.'"), КодОшибки);
	КонецЕсли;
	Возврат ТекстСообщения;
КонецФункции

Функция ОписаниеОшибкиПолученияСтатуса(КодОшибки)
	ОписанияОшибок =ОписанияОшибок();
	ТекстСообщения = ОписанияОшибок[КодОшибки];
	Если ТекстСообщения = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Отказ выполнения операции';
								|en = 'Operation failed'");
	КонецЕсли;
	Возврат ТекстСообщения;
КонецФункции

Функция ВыполнитьЗапрос(ИмяМетода, ПараметрыЗапроса)
	
	HTTPЗапрос = ОтправкаSMS.ПодготовитьHTTPЗапрос("/ws/s1c.asmx/" + ИмяМетода, ПараметрыЗапроса);
	HTTPОтвет = Неопределено;
	
	Попытка
		Соединение = Новый HTTPСоединение("sms4b.ru",,,, 
			ПолучениеФайловИзИнтернета.ПолучитьПрокси("https"),
			60, 
			ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение());
			
		HTTPОтвет = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS';
										|en = 'Text messaging'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Результат = "";
	Если HTTPОтвет <> Неопределено Тогда
		Если HTTPОтвет.КодСостояния <> 200 Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Запрос ""%1"" не выполнен. Код состояния: %2.';
					|en = 'Request failed: %1. Status code: %2.'"), ИмяМетода, HTTPОтвет.КодСостояния) + Символы.ПС
				+ HTTPОтвет.ПолучитьТелоКакСтроку();
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS';
											|en = 'Text messaging'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, , , ТекстОшибки);
		КонецЕсли;
		
		ТекстОтвета = HTTPОтвет.ПолучитьТелоКакСтроку();
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(ТекстОтвета);
		ЧтениеXML.Прочитать();
		Если ЧтениеXML.Имя = "string" Тогда
			Если ЧтениеXML.Прочитать() Тогда
				Результат = ЧтениеXML.Значение;
			КонецЕсли;
		КонецЕсли;
		ЧтениеXML.Закрыть();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ФорматироватьНомер(Номер)
	Результат = "";
	ДопустимыеСимволы = "1234567890";
	Для Позиция = 1 По СтрДлина(Номер) Цикл
		Символ = Сред(Номер,Позиция,1);
		Если СтрНайти(ДопустимыеСимволы, Символ) > 0 Тогда
			Результат = Результат + Символ;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Возвращает список разрешений для отправки SMS с использованием всех доступных провайдеров.
//
// Возвращаемое значение:
//  Массив
//
Функция Разрешения() Экспорт
	
	Протокол = "HTTPS";
	Адрес = "sms4b.ru";
	Порт = Неопределено;
	Описание = НСтр("ru = 'Отправка SMS через ""SMS4B"".';
					|en = 'Text messaging via SMS4B.'");
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Разрешения = Новый Массив;
	Разрешения.Добавить(
		МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(Протокол, Адрес, Порт, Описание));
	
	Возврат Разрешения;
КонецФункции

Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	Настройки.АдресОписанияУслугиВИнтернете = "http://sms4b.ru";
	
КонецПроцедуры

#КонецОбласти

