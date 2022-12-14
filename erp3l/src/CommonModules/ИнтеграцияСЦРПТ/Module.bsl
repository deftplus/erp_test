///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ИнтеграцияСЦРПТ".
// ОбщийМодуль.ИнтеграцияСЦРПТ.
//
// Серверные процедуры и функции для работы с сервисом обмена данными с ЦРПТ:
//  - создание нового идентификатора соединения;
//  - обработки событий подсистем Библиотеки стандартных подсистем.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает идентификатор соединения ЦРПТ на основании переданного запроса.
//
// Параметры:
//  ПараметрыЗапросаJSON - Строка - запрос для отправки в сервис ЦРПТ;
//  ЗаголовкиЗапроса - Соответствие - содержит заголовки, которые необходимо отправить в ЦРПТ;
//  ПараметрыURL - Соответствие - содержит параметры запроса, которые необходимо отправить в ЦРПТ;
//  ДанныеБиблиотеки - Структура - содержит идентификатор библиотеки и версию библиотеки,
//                     от имени которой формируется запрос:
//   *Идентификатор - Строка - идентификатор библиотеки;
//   *Версия - Строка - версия библиотеки.
//
// Возвращаемое значение:
//  Структура - результат создания получения идентификатора соединения:
//    *ДанныеОтвета - Соответствие, Неопределено - ответ ЦРПТ преобразованный методом ПрочитатьJSON.
//                    Может быть возвращено значение Неопределено, если в процессе получения были ошибки;
//    *КодОшибки - Строка - строковый код возникшей ошибки, который
//                  может быть обработан вызывающим методом:
//                    - <Пустая строка> - создание нового заказа выполнено успешно;
//                    - "НеверныйФорматЗапроса" - передан некорректный запрос
//                      на получение идентификатора соединения;
//                    - "НеверныйЛогинИлиПароль" - неверный логин или пароль или параметры
//                      подключения к Порталу 1С:ИТС;
//                    - "ПревышеноКоличествоПопыток" - превышено количество попыток
//                      обращения к сервису с некорректным логином и паролем;
//                    - "ОшибкаПодключения" - ошибка при подключении к сервису;
//                    - "ОшибкаСервиса" - внутренняя ошибка сервиса;
//                    - "НеизвестнаяОшибка" - при получении информации возникла
//                      неизвестная (не обрабатываемая) ошибка;
//    *СообщениеОбОшибке  - Строка, ФорматированнаяСтрока - сообщение об ошибке для пользователя.
//
Функция ИдентификаторСоединения(
		ПараметрыЗапросаJSON,
		ЗаголовкиЗапроса,
		ПараметрыURL,
		ДанныеБиблиотеки) Экспорт
	
	ЗаписатьИнформациюВЖурналРегистрации(
		НСтр("ru = 'Начало получения идентификатора соединения ЦРПТ.';
			|en = 'CRPT connection ID receiving started.'"),
		Ложь);
	
	РезультатОперации = Новый Структура;
	РезультатОперации.Вставить("ДанныеОтвета",      Неопределено);
	РезультатОперации.Вставить("КодОшибки",         "");
	РезультатОперации.Вставить("СообщениеОбОшибке", "");
	
	URLОперации = URLОперацииСервиса("/connections/register");
	РезультатИПП = ДанныеАутентификации(URLОперации);
	
	Если РезультатИПП.Ошибка Тогда
		РезультатОперации.КодОшибки = КодОшибкиНеверныйЛогинИлиПароль();
		РезультатОперации.СообщениеОбОшибке = РезультатИПП.ИнформацияОбОшибке;
		Возврат РезультатОперации;
	КонецЕсли;
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type",  "application/json");
	Заголовки.Вставить("Authorization", РезультатИПП.Аутентификация);
	Заголовки.Вставить("X-Correlation-ID", Строка(Новый УникальныйИдентификатор));
	
	ПараметрыЗапросаСервис = connections_register(
		ПараметрыЗапросаJSON,
		ЗаголовкиЗапроса,
		ПараметрыURL,
		ДанныеБиблиотеки);
	
	ПараметрыОтправки = Новый Структура;
	ПараметрыОтправки.Вставить("Метод"                   , "POST");
	ПараметрыОтправки.Вставить("ФорматОтвета"            , 1);
	ПараметрыОтправки.Вставить("Заголовки"               , Заголовки);
	ПараметрыОтправки.Вставить("ДанныеДляОбработки"      , ПараметрыЗапросаСервис);
	ПараметрыОтправки.Вставить("ФорматДанныхДляОбработки", 1);
	ПараметрыОтправки.Вставить("НастройкиПрокси"         , ПолучениеФайловИзИнтернета.НастройкиПроксиНаСервере());
	ПараметрыОтправки.Вставить("Таймаут"                 , 30);
	
	// Вызов операции сервиса.
	РезультатОтправки = ИнтернетПоддержкаПользователей.ЗагрузитьСодержимоеИзИнтернет(
		URLОперации,
		,
		,
		ПараметрыОтправки);
	
	Если Не ПустаяСтрока(РезультатОтправки.КодОшибки) Тогда
		
		РезультатОперации.КодОшибки         = ПереопределитьКодОшибкиСервиса(РезультатОтправки.КодСостояния);
		РезультатОперации.СообщениеОбОшибке = ПереопределитьСообщениеПользователю(
			РезультатОперации.КодОшибки,
			РезультатОтправки.Содержимое);
		
		ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось получить идентификатор соединения.
					|
					|%1
					|
					|Техническая информация об ошибке:
					|При получении идентификатора соединения сервис вернул ошибку.
					|URL: %2
					|Код ошибки: %3
					|Подробная информация:
					|%4';
					|en = 'Cannot receive the connection ID.
					|
					|%1
					|
					|Technical information about the error:
					|When receiving the connection ID, the service returned an error.
					|URL: %2
					|Error code: %3
					|Details:
					|%4'"),
				Строка(РезультатОперации.СообщениеОбОшибке),
				URLОперации,
				РезультатОтправки.КодОшибки,
				РезультатОтправки.ИнформацияОбОшибке);
		
		ЗаписатьИнформациюВЖурналРегистрации(
			ИнформацияОбОшибке,
			Истина);
		
		Возврат РезультатОперации;
		
	КонецЕсли;
	
	ЧтениеОтвета = Новый ЧтениеJSON;
	ЧтениеОтвета.УстановитьСтроку(РезультатОтправки.Содержимое);
	ОтветШлюза = ПрочитатьJSON(
		ЧтениеОтвета,
		Истина);
	
	РезультатОперации.ДанныеОтвета= ОтветШлюза.Получить("crptResponse");
	ЗаписатьИнформациюВЖурналРегистрации(
		НСтр("ru = 'Завершено получение идентификатора соединения ЦРПТ.';
			|en = 'CRPT connection ID is received.'"),
		Ложь);
	
	Возврат РезультатОперации;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ИнтеграцияСБиблиотекойСтандартныхПодсистем

// См. РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам.
//
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	НовыеРазрешения = Новый Массив;
	
	Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
		"HTTPS",
		ХостСервисаОбменаДанными(),
		443,
		НСтр("ru = 'Сервис интеграции с ЦРПТ (ru)';
			|en = 'Integration with CRPT service (ru)'"));
	НовыеРазрешения.Добавить(Разрешение);
	
	ЗапросыРазрешений.Добавить(РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(НовыеРазрешения));
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВызовОпераций

// Формирует параметры запроса для операции
// /api/program1c/connections/register.
//
Функция connections_register(
		ПараметрыЗапросаJSON,
		ЗаголовкиЗапроса,
		ПараметрыURL,
		ДанныеБиблиотеки)
	
	ЗаписьДанныхСообщения = Новый ЗаписьJSON;
	ЗаписьДанныхСообщения.УстановитьСтроку();
	
	ЗаписьДанныхСообщения.ЗаписатьНачалоОбъекта();
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("crptRequest");
	ЗаписьДанныхСообщения.ЗаписатьНачалоОбъекта();
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("headers");
	ЗаписьДанныхСообщения.ЗаписатьНачалоОбъекта();
	
	Для Каждого КлючЗначение Из ЗаголовкиЗапроса Цикл
		ЗаписьДанныхСообщения.ЗаписатьИмяСвойства(КлючЗначение.Ключ);
		ЗаписьДанныхСообщения.ЗаписатьЗначение(КлючЗначение.Значение);
	КонецЦикла;
	
	ЗаписьДанныхСообщения.ЗаписатьКонецОбъекта();
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("queryParameters");
	ЗаписьДанныхСообщения.ЗаписатьНачалоОбъекта();
	
	Для Каждого КлючЗначение Из ПараметрыURL Цикл
		ЗаписьДанныхСообщения.ЗаписатьИмяСвойства(КлючЗначение.Ключ);
		ЗаписьДанныхСообщения.ЗаписатьЗначение(КлючЗначение.Значение);
	КонецЦикла;
	
	ЗаписьДанныхСообщения.ЗаписатьКонецОбъекта();
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("bodyBase64");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(Base64ИзСтроки(ПараметрыЗапросаJSON));
	
	ЗаписьДанныхСообщения.ЗаписатьКонецОбъекта();
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("clientInfo");
	ЗаписьДанныхСообщения.ЗаписатьНачалоОбъекта();
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("programNick");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(ИнтернетПоддержкаПользователей.ИмяПрограммы());
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("libraryId");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(ДанныеБиблиотеки.Идентификатор);
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("libraryVersion");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(ДанныеБиблиотеки.Версия);
	
	ЗаписьДанныхСообщения.ЗаписатьКонецОбъекта();
	
	ЗаписьДанныхСообщения.ЗаписатьКонецОбъекта();
	
	Возврат ЗаписьДанныхСообщения.Закрыть();
	
КонецФункции

// Возвращает логин и пароль Интернет-поддержки или тикет аутентификации.
//
// Параметры:
//  URLОперации -Строка - URL операции, для которой получаются данные аутентификации.
//
// Возвращаемое значение:
//  Структура - структура, содержащая результаты определения параметров
//              аутентификации пользователя Интернет-поддержки:
//    *Аутентификация - Строка - заголовок аутентификации пользователя Интернет-поддержки;
//    *ИнформацияОбОшибке   - Строка    - информация об ошибке для пользователя.
//    *Ошибка               - Строка    - признак наличия ошибки.
//
Функция ДанныеАутентификации(URLОперации)
	
	Результат = Новый Структура;
	Результат.Вставить("Аутентификация",       "");
	Результат.Вставить("ИнформацияОбОшибке",   "");
	Результат.Вставить("Ошибка",               Ложь);
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		МодульИнтернетПоддержкаПользователейВМоделиСервиса =
			ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователейВМоделиСервиса");
		РезультатПолученияТикета =
			МодульИнтернетПоддержкаПользователейВМоделиСервиса.ТикетАутентификацииНаПорталеПоддержки(
				URLОперации);
		
		Если ПустаяСтрока(РезультатПолученияТикета.КодОшибки) Тогда
			Результат.Аутентификация = "Bearer " + РезультатПолученияТикета.Тикет;
		Иначе
			Результат.Ошибка = Истина;
			Результат.ИнформацияОбОшибке =
				НСтр("ru = 'Ошибка аутентификации в сервисе.
					|Подробнее см. в журнале регистрации.';
					|en = 'Authentication error in the service.
					|For more information, see the event log.'");
			ПодробнаяИнформацияОбОшибке =
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось вызвать операцию %1.
						|Не удалось выполнить аутентификацию.
						|%2';
						|en = 'Cannot call operation %1.
						|Cannot authenticate.
						|%2'"),
					URLОперации,
					РезультатПолученияТикета.ИнформацияОбОшибке);
			ЗаписатьИнформациюВЖурналРегистрации(
				ПодробнаяИнформацияОбОшибке,
				Истина);
		КонецЕсли;
	Иначе
		УстановитьПривилегированныйРежим(Истина);
		ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		УстановитьПривилегированныйРежим(Ложь);
		Если ДанныеАутентификации = Неопределено Тогда
			Результат.Ошибка             = Истина;
			Результат.ИнформацияОбОшибке =
				НСтр("ru = 'Для работы с сервисом интеграции с ЦРПТ необходимо подключить Интернет-поддержку пользователей.';
					|en = 'You need to enable online user support to use integration with CRPT service.'");
			ЗаписатьИнформациюВЖурналРегистрации(
				Результат.ИнформацияОбОшибке);
		КонецЕсли;
		
		Результат.Аутентификация = "Basic " + Base64ИзСтроки(ДанныеАутентификации.Логин + ":" + ДанныеАутентификации.Пароль);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Определяет URL для вызова сервиса интеграции с ЦРПТ.
//
// Параметры:
//  Операция  - Строка - путь к ресурсу.
//
// Возвращаемое значение:
//  Строка - URL операции.
//
Функция URLОперацииСервиса(Операция)
	
	Возврат "https://"
		+ ХостСервисаОбменаДанными()
		+ "/public/api/program1c"
		+ Операция;
	
КонецФункции

// Определяет хост для вызова сервиса обмена данными с ЦРПТ.
//
// Возвращаемое значение:
//  Строка - хост подключения.
//
Функция ХостСервисаОбменаДанными()
	
	
	Возврат "products-marking-crpt.1c.ru";
	
КонецФункции

#КонецОбласти

#Область ОбработкаОшибок

// Определяет по коду состояния тип ошибки сервиса.
//
// Параметры:
//  КодСостояния - Число - код состояния ответа сервиса.
//
// Возвращаемое значение:
//  Строка - код ошибки сервиса.
//
Функция ПереопределитьКодОшибкиСервиса(КодСостояния)
	
	Если ПустаяСтрока(КодСостояния) Тогда
		Возврат "";
	КонецЕсли;
	
	Если КодСостояния = 200 Тогда
		Возврат "";
	ИначеЕсли КодСостояния = 401 Тогда
		Возврат КодОшибкиНеверныйЛогинИлиПароль();
	ИначеЕсли КодСостояния = 400 Или КодСостояния = 422 Тогда
		Возврат КодОшибкиНеверныйФорматЗапроса();
	ИначеЕсли КодСостояния = 429 Тогда
		Возврат КодОшибкиПревышеноКоличествоПопыток();
	ИначеЕсли КодСостояния = 500 Тогда
		Возврат КодОшибкиОшибкаСервиса();
	ИначеЕсли КодСостояния = 0
		Или КодСостояния = 503 Тогда
		Возврат КодОшибкиОшибкаПодключения();
	Иначе
		Возврат КодОшибкиНеизвестнаяОшибка();
	КонецЕсли;
	
КонецФункции

// Определяет по коду ошибки сообщение пользователю.
//
// Параметры:
//  КодОшибки - Строка - ошибка сервиса см. функцию
//              ИнтеграцияСЦРПТ.ПереопределитьКодОшибкиСервиса.
//  ТелоJSON  - Строка - содержимое ответа сервиса.
//
// Возвращаемое значение:
//  Строка - сообщение пользователю.
//
Функция ПереопределитьСообщениеПользователю(КодОшибки, ТелоJSON = "") Экспорт
	
	КодОшибкиСервиса = "";
	Если ЗначениеЗаполнено(ТелоJSON) Тогда
		КодОшибкиСервиса = ОпределитьКодОшибкиСервиса(ТелоJSON);
	КонецЕсли;
	
	Если КодОшибки = КодОшибкиНеверныйФорматЗапроса() И КодОшибкиСервиса = "BAD_REQUEST" Тогда
		Возврат НСтр("ru = 'Неверный набор параметров или формат запроса к сервису Портала 1С:ИТС.';
					|en = 'Incorrect parameter set or format of the request to 1C:ITS Portal service.'");
	ИначеЕсли КодОшибки = КодОшибкиНеверныйФорматЗапроса() И КодОшибкиСервиса = "REGISTRATION_KEY_NOT_FOUND" Тогда
		Возврат НСтр("ru = 'Неверный идентификатор или версия библиотеки. Ключ регистрации не обнаружен.';
					|en = 'Incorrect library ID or version. Registration key is not found.'");
	ИначеЕсли КодОшибки = КодОшибкиНеверныйФорматЗапроса() И КодОшибкиСервиса = "UNKNOWN_PROGRAM" Тогда
		Возврат НСтр("ru = 'Программа по идентификатору не найдена. Обратитесь к администратору.';
					|en = 'Cannot find an application by the ID. Contact the administrator.'");
	ИначеЕсли КодОшибки = КодОшибкиНеверныйФорматЗапроса() Тогда
		Возврат НСтр("ru = 'Неверный набор параметров или формат запроса. Обратитесь к администратору';
					|en = 'Invalid parameter set or request format. Contact the administrator'");
	КонецЕсли;
	
	Если КодОшибки = КодОшибкиНеверныйЛогинИлиПароль() И КодОшибкиСервиса = "UNAUTHORIZED" Тогда
		Возврат НСтр("ru = 'Ошибка авторизации на Портале 1С:ИТС.';
					|en = 'An error occurred while authorizing on 1C:ITS Portal.'");
	ИначеЕсли КодОшибки = КодОшибкиНеверныйЛогинИлиПароль() Тогда
			Возврат НСтр("ru = 'Ошибка авторизации. Обратитесь к администратору.';
						|en = 'Authorization error. Contact the administrator.'");
	КонецЕсли;
	
	Если КодОшибки = КодОшибкиПревышеноКоличествоПопыток() Тогда
		Возврат НСтр("ru = 'Превышено количество попыток обращения к сервису 1С с не верными данными авторизации.';
					|en = 'You exceeded the number of attempts to contact 1C service with incorrect authorization data.'")
			+ " "
			+ НСтр("ru = 'Проверьте правильность данных авторизации и повторите попытку через 30 минут.';
					|en = 'Check if the authorization data is correct and try again in 30 minutes.'");
	КонецЕсли;
	
	Если КодОшибки = КодОшибкиОшибкаПодключения() Тогда
		Возврат НСтр("ru = 'Не удалось подключиться к сервису Портала 1С:ИТС. Сервис временно недоступен.
			|Повторите попытку подключения позже.';
			|en = 'Cannot connect to 1C:ITS Portal service. The service is temporarily unavailable.
			|Try again later.'");
	КонецЕсли;
	
	Если КодОшибки = КодОшибкиОшибкаСервиса() И КодОшибкиСервиса = "BACKEND_CALL_ERROR" Тогда
		Возврат НСтр("ru = 'Неизвестная ошибка при вызове сервиса ЦРПТ.';
					|en = 'An unknown error occurred when calling CRPT service.'");
	ИначеЕсли КодОшибки = КодОшибкиОшибкаСервиса() И КодОшибкиСервиса = "BACKEND_API_ERROR" Тогда
		Возврат НСтр("ru = 'Сервис ЦРПТ вернул ошибку.';
					|en = 'CRPT service returned an error.'");
	ИначеЕсли КодОшибки = КодОшибкиОшибкаСервиса() И КодОшибкиСервиса = "BACKEND_UNDECODEABLE_RESPONSE" Тогда
		Возврат НСтр("ru = 'Ответ сервиса ЦРПТ не поддается расшифровке.';
					|en = 'Cannot decrypt CRPT service response.'");
	ИначеЕсли КодОшибки = КодОшибкиОшибкаСервиса() Тогда
		Возврат НСтр("ru = 'Ошибка работы с сервисом интеграции с платежными системами.';
					|en = 'An error occurred upon working with the service of integration with payment systems.'");
	КонецЕсли;
	
	Возврат НСтр("ru = 'Неизвестная ошибка при подключении к сервису.';
				|en = 'An unknown error occurred while connecting to the service.'");
	
КонецФункции

// Производит чтение кода ошибки сервиса из тела ответа.
//
// Параметры:
//  ТелоJSON - Строка - тело ответа сервиса.
//
// Возвращаемое значение:
//  Строка - код ошибки сервиса.
//
Функция ОпределитьКодОшибкиСервиса(ТелоJSON) Экспорт
	
	// Ответ сервиса:
	//
	//{
	//  "type": "string",
	//  "title": "string",
	//  "status": 400,
	//  "detail": "string",
	//  "instance": "string"
	//}
	
	// Определение ошибки выполняется через попытку, т.к. в случае ошибки сервиса
	// есть вероятность получить не формализованное сообщение.
	Попытка
		ЧтениеОтвета = Новый ЧтениеJSON;
		ЧтениеОтвета.УстановитьСтроку(ТелоJSON);
		Результат = ПрочитатьJSON(ЧтениеОтвета);
		Возврат Результат.type;
	Исключение
		Возврат "";
	КонецПопытки;
	
КонецФункции

// Возвращает код ошибки "НеверныйЛогинИлиПароль".
//
// Возвращаемое значение:
//  Строка - код ошибки.
//
Функция КодОшибкиНеверныйЛогинИлиПароль()
	
	Возврат "НеверныйЛогинИлиПароль";
	
КонецФункции

// Возвращает код ошибки "НеизвестнаяОшибка".
//
// Возвращаемое значение:
//  Строка - код ошибки.
//
Функция КодОшибкиНеизвестнаяОшибка()
	
	Возврат "НеизвестнаяОшибка";
	
КонецФункции

// Возвращает код ошибки "НеверныйФорматЗапроса".
//
// Возвращаемое значение:
//  Строка - код ошибки.
//
Функция КодОшибкиНеверныйФорматЗапроса()
	
	Возврат "НеверныйФорматЗапроса";
	
КонецФункции

// Возвращает код ошибки "ОшибкаСервиса".
//
// Возвращаемое значение:
//  Строка - код ошибки.
//
Функция КодОшибкиОшибкаСервиса()
	
	Возврат "ОшибкаСервиса";
	
КонецФункции

// Возвращает код ошибки "ОшибкаПодключения".
//
// Возвращаемое значение:
//  Строка - код ошибки.
//
Функция КодОшибкиОшибкаПодключения()
	
	Возврат "ОшибкаПодключения";
	
КонецФункции

// Возвращает код ошибки "ПревышеноКоличествоПопыток".
//
// Возвращаемое значение:
//  Строка - код ошибки.
//
Функция КодОшибкиПревышеноКоличествоПопыток()
	
	Возврат "ПревышеноКоличествоПопыток";
	
КонецФункции

#КонецОбласти

#Область ПрочиеСлужебныеПроцедурыФункции

// Добавляет запись в журнал регистрации.
//
// Параметры:
//  СообщениеОбОшибке - Строка - комментарий к записи журнала регистрации;
//  Ошибка - Булево - если истина будет установлен уровень журнала регистрации "Ошибка".
//
Процедура ЗаписатьИнформациюВЖурналРегистрации(
		СообщениеОбОшибке,
		Ошибка = Истина)
	
	УровеньЖР = ?(Ошибка, УровеньЖурналаРегистрации.Ошибка, УровеньЖурналаРегистрации.Информация);
	
	ЗаписьЖурналаРегистрации(
		ИмяСобытияЖурналаРегистрации(),
		УровеньЖР,
		,
		,
		Лев(СообщениеОбОшибке, 5120));
	
КонецПроцедуры

// Возвращает имя события для журнала регистрации, которое используется
// для записи событий загрузки данных из внешних систем.
//
// Возвращаемое значение:
//  Строка - имя события.
//
Функция ИмяСобытияЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Интеграция с ЦРПТ';
				|en = 'Integration with CRPT'",
		ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

// Формирует строку Base64 из обычной строки
//
// Параметры:
//  Значение  - Строка - преобразует строку в Base64.
//
// Возвращаемое значение:
//  Строка - результат преобразования.
//
Функция Base64ИзСтроки(Значение)
	
	Результат = Base64Строка(ПолучитьДвоичныеДанныеИзСтроки(Значение));
	Результат = СтрЗаменить(Результат, Символы.ПС, "");
	Результат = СтрЗаменить(Результат, Символы.ВК, "");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти
