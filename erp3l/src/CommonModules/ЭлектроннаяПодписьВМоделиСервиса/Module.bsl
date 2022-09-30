////////////////////////////////////////////////////////////////////////////////
// Подсистема "Электронная подпись в модели сервиса".
//  
////////////////////////////////////////////////////////////////////////////////


#Область ПрограммныйИнтерфейс

// Возможность использования электронной подписи в модели сервиса.
// 
// Возвращаемое значение: 
//  Булево
Функция ИспользованиеВозможно() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьЭлектроннуюПодписьВМоделиСервиса");
	
КонецФункции

// Возможность использованиея долговременного токена.
// 
// Возвращаемое значение: 
//  Булево
Функция ДолговременныйТокенИспользованиеВозможно() Экспорт
	
	Результат = Ложь;
 
	ИмяПодсистемы = "РегламентированнаяОтчетность";
	Если ОбщегоНазначения.ПодсистемаСуществует(ИмяПодсистемы) Тогда
		ВерсияПодсистемы = ОбновлениеИнформационнойБазы.ВерсияИБ(ИмяПодсистемы);
		Попытка
			Результат = ВерсияПодсистемы > "1.1.14.01";
		Исключение
		КонецПопытки;	
	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции

// Возвращает настройки сертификата: использование долговременного токена и его значение
//
// Параметры:
//   Сертификат - Структура, Строка - содержит свойства сертификата, наличие свойства "Идентификатор" обязательно.
//
// Возвращаемое значение:
//   Структура - состоит из полей:
//   * СпособПодтвержденияКриптоОпераций - Произвольный -
//   * Токен - Произвольный -
//   * Идентификатор - Произвольный -
//   * Отпечаток - Произвольный -
//
Функция СвойстваРасшифрованияПодписанияСертификата(Сертификат) Экспорт
	
	Результат = ЭлектроннаяПодписьВМоделиСервисаСлужебный.СвойстваРасшифрованияПодписанияСертификата(Сертификат);
	
	Возврат Результат;
	
КонецФункции

// Удаляет настройки для использования долговременного токена
//
// Параметры:
//   Сертификат - Структура - поля:
//					* Идентификатор - Строка - обязательно.
//	 		    - Строка - содержит свойства сертификата, наличие свойства "Идентификатор" обязательно.
//
Процедура УдалитьСвойстваРасшифрованияПодписания(Сертификат) Экспорт
	
	ЭлектроннаяПодписьВМоделиСервисаСлужебный.УдалитьСвойстваРасшифрованияПодписания(Сертификат);
	
КонецПроцедуры

// Сохраняет настройки для использования долговременного токена
//
// Параметры:
//	Сертификат - Структура - поля:
//					* Идентификатор - Строка - обязательно.
//	 		   - Строка - содержит свойства сертификата, наличие свойства "Идентификатор" обязательно.
//
Процедура УстановитьСвойстваРасшифрованияПодписания(Сертификат) Экспорт
	
	ЭлектроннаяПодписьВМоделиСервисаСлужебный.УстановитьСвойстваРасшифрованияПодписания(Сертификат);
	
КонецПроцедуры

Процедура НастроитьИспользованиеДолговременногоТокена(СпособПодтвержденияКриптоопераций, Сертификат) Экспорт
	
	ЭлектроннаяПодписьВМоделиСервисаСлужебный.НастроитьИспользованиеДолговременногоТокена(СпособПодтвержденияКриптоопераций, Сертификат);
	
КонецПроцедуры

// Найти сертификат по идентификатору
// 
// Параметры:
//  Сертификат - Произвольный
// 
// Возвращаемое значение:
//  ДвоичныеДанные - Найти сертификат по идентификатору.
Функция НайтиСертификатПоИдентификатору(Сертификат) Экспорт
	
	Результат = ЭлектроннаяПодписьВМоделиСервисаСлужебный.НайтиСертификатПоИдентификатору(Сертификат);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Вызывается при установке параметров сеанса.
//
// Параметры:
//  ИменаПараметровСеанса - Массив, Неопределено - имена параметров сеанса.
//
Процедура ПриУстановкеПараметровСеанса(ИменаПараметровСеанса) Экспорт
	
	Если ИменаПараметровСеанса <> Неопределено 
		И ИменаПараметровСеанса.Найти("МаркерыБезопасности") <> Неопределено Тогда
		ПараметрыСеанса.МаркерыБезопасности = Новый ФиксированноеСоответствие(Новый Соответствие);		
	КонецЕсли;
	
КонецПроцедуры	

// Формирует список параметров ИБ.
//
// Параметры:
//	ТаблицаПараметров - см. РаботаВМоделиСервиса.ПараметрыИБ
//
Процедура ПриЗаполненииТаблицыПараметровИБ(Знач ТаблицаПараметров) Экспорт
		
	РаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "ИспользоватьЭлектроннуюПодписьВМоделиСервиса");
	РаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "АдресСервисаПодключенияЭлектроннойПодписиВМоделиСервиса");
	РаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "АдресКриптосервиса");	
	
	СтрокаПараметра = ТаблицаПараметров.Добавить();
	СтрокаПараметра.Имя = "ИмяПользователяСервисаПодключенияЭлектроннойПодписиВМоделиСервиса";
	СтрокаПараметра.Описание = "ИмяПользователяСервисаПодключенияЭлектроннойПодписиВМоделиСервиса";
	СтрокаПараметра.Тип = Новый ОписаниеТипов("Строка");
	
	СтрокаПараметра = ТаблицаПараметров.Добавить();
	СтрокаПараметра.Имя = "ПарольПользователяСервисаПодключенияЭлектроннойПодписиВМоделиСервиса";
	СтрокаПараметра.Описание = "ПарольПользователяСервисаПодключенияЭлектроннойПодписиВМоделиСервиса";
	СтрокаПараметра.Тип = Новый ОписаниеТипов("Строка");
	
КонецПроцедуры

// Вызывается перед попыткой записи значений параметров ИБ в одноименные
// константы.
//
// Параметры:
// ЗначенияПараметров - Структура - значения параметров которые требуется установить.
// В случае если значение параметра устанавливается в данной процедуре из структуры
// необходимо удалить соответствующую пару КлючИЗначение.
//
Процедура ПриУстановкеЗначенийПараметровИБ(Знач ЗначенияПараметров) Экспорт
	
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Константа.АдресСервисаПодключенияЭлектроннойПодписиВМоделиСервиса");
	Если ЗначенияПараметров.Свойство("ИмяПользователяСервисаПодключенияЭлектроннойПодписиВМоделиСервиса") Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, ЗначенияПараметров.ИмяПользователяСервисаПодключенияЭлектроннойПодписиВМоделиСервиса, "Логин");
		УстановитьПривилегированныйРежим(Ложь);
		ЗначенияПараметров.Удалить("ИмяПользователяСервисаПодключенияЭлектроннойПодписиВМоделиСервиса");
	КонецЕсли;
	
	Если ЗначенияПараметров.Свойство("ПарольПользователяСервисаПодключенияЭлектроннойПодписиВМоделиСервиса") Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, ЗначенияПараметров.ПарольПользователяСервисаПодключенияЭлектроннойПодписиВМоделиСервиса, "Пароль");
		УстановитьПривилегированныйРежим(Ложь);
		ЗначенияПараметров.Удалить("ПарольПользователяСервисаПодключенияЭлектроннойПодписиВМоделиСервиса");
	КонецЕсли;
	
КонецПроцедуры

// Заполняет структуру массивами поддерживаемых версий всех подлежащих версионированию программных интерфейсов,
// используя в качестве ключей имена программных интерфейсов.
// Обеспечивает функциональность Web-сервиса InterfaceVersion.
// При внедрении надо поменять тело процедуры так, чтобы она возвращала актуальные наборы версий (см. пример.ниже).
//
// Параметры:
// СтруктураПоддерживаемыхВерсий - Структура - в которой:
//  Ключ - Имя программного интерфейса,
//  Значение - Массив Из Строка - поддерживаемые версии программного интерфейса.
//
// Пример реализации:
//
//  // СервисПередачиФайлов
//  МассивВерсий = Новый Массив;
//  МассивВерсий.Добавить("1.0.1.1");
//  МассивВерсий.Добавить("1.0.2.1");
//  СтруктураПоддерживаемыхВерсий.Вставить("СервисПередачиФайлов", МассивВерсий);
//  // Конец СервисПередачиФайлов
//
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(СтруктураПоддерживаемыхВерсий) Экспорт
	
	МассивВерсий = Новый Массив;
	МассивВерсий.Добавить("1.0.1.1");
	СтруктураПоддерживаемыхВерсий.Вставить("ЭлектроннаяПодписьВМоделиСервиса", МассивВерсий);	
	
КонецПроцедуры

// Возвращает структуру параметров, необходимых для работы клиентского кода
// при запуске конфигурации, т.е. в обработчиках событий
// - ПередНачаломРаботыСистемы,
// - ПриНачалеРаботыСистемы.
//
// Важно: при запуске недопустимо использовать команды сброса кэша
// повторно используемых модулей, иначе запуск может привести
// к непредсказуемым ошибкам и лишним серверным вызовам.
//
// Параметры:
//   Параметры - Структура - (возвращаемое значение) структура параметров работы клиента при запуске.
//
// Пример реализации:
//   Для установки параметров работы клиента можно использовать шаблон:
//
//     Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
//
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	
	Параметры.Вставить("ИспользованиеЭлектроннойПодписиВМоделиСервисаВозможно", ИспользованиеВозможно());
	
КонецПроцедуры

// Устанавливает соединение с сервером Интернета по протоколу http(s).
//
// Параметры:
//  ПараметрыСоединения - Структура - дополнительные параметры для "тонкой" настройки:
//    * Схема - Строка - значение константы "http"
//    * Хост - Строка - 
//    * Порт - Число -  
//    * Логин - Строка - 
//    * Пароль - Строка - 
//    * Таймаут - Число - определяет время ожидания осуществляемого соединения и операций, в секундах.
//
// Возвращаемое значение:
//	HTTPСоединение - соединение.
Функция СоединениеССерверомИнтернета(ПараметрыСоединения) Экспорт

	Прокси = ПолучениеФайловИзИнтернета.ПолучитьПрокси(ПараметрыСоединения.Схема);
	
	Таймаут = 30;
	Если ПараметрыСоединения.Свойство("Таймаут") Тогда
		Таймаут = ПараметрыСоединения.Таймаут;
	КонецЕсли;
	
	Попытка
		СертификатыУЦ = Новый СертификатыУдостоверяющихЦентровОС;
		
		Соединение = Новый HTTPСоединение(
			ПараметрыСоединения.Хост,
			ПараметрыСоединения.Порт,
			ПараметрыСоединения.Логин,
			ПараметрыСоединения.Пароль, 
			Прокси,
			Таймаут,
			?(НРег(ПараметрыСоединения.Схема) = "http", Неопределено, Новый ЗащищенноеСоединениеOpenSSL(, СертификатыУЦ)));
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();	
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронная подпись в модели сервиса.Соединение с сервером интернета';
				|en = 'Electronic signature in SaaS. Connection to online server'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Соединение;
	
КонецФункции

// Преобразует строку в формате JSON в структуру. 
//
// Параметры:
//  СтрокаJSON              - Строка - строка в формате JSON.
//  ПараметрыПреобразования - Структура - дополнительные параметры для настройки преобразования:
//    * ИменаСвойствДляВосстановления - Массив, ФиксированныйМассив - список свойств, 
//                                      которые необходимо преобразовать из Base64 в двоичные данные.
// Возвращаемое значение:
//	Структура:
//	 * Поле - Произвольный - произвольный набор полей.
//
Функция JsonВСтруктуру(СтрокаJSON, ПараметрыПреобразования = Неопределено) Экспорт
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
	
	Если ТипЗнч(ПараметрыПреобразования) = Тип("Структура")
		И ПараметрыПреобразования.Свойство("ИменаСвойствДляВосстановления")
		И ЗначениеЗаполнено(ПараметрыПреобразования.ИменаСвойствДляВосстановления) Тогда
		Объект = ПрочитатьJSON(
			ЧтениеJSON,,,, 
			"ПреобразоватьBase64ВДвоичныеДанные", 
			ЭлектроннаяПодписьВМоделиСервиса, 
			ПараметрыПреобразования,
			ПараметрыПреобразования.ИменаСвойствДляВосстановления);
	Иначе
		Объект = ПрочитатьJSON(ЧтениеJSON);
	КонецЕсли;
	
	ЧтениеJSON.Закрыть();
	
	Возврат Объект;
	
КонецФункции

// Преобразует структура в строку JSON. Двоичные данные преобразуются в строки Base64.
//
// Параметры:
//  Объект - Структура - которую необходимо преобразовать в строку JSON.
//  ПараметрыПреобразования - Структура - Дополнительные параметры, которые будут переданы в функцию восстановления значений.
//
// Возвращаемое значение:
//	Строка - в формате JSON.
//
Функция СтруктураВJSON(Объект, ПараметрыПреобразования = Неопределено) Экспорт
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(
		ЗаписьJSON, 
		Объект,, 
		"ПреобразоватьДвоичныеДанныеВBase64", 
		ЭлектроннаяПодписьВМоделиСервиса, 
		ПараметрыПреобразования);
	
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

Процедура ВызватьСтандартноеИсключение() Экспорт
	
	ВызватьИсключение(НСтр("ru = 'Сервис временно недоступен. Обратитесь в службу поддержки или повторите попытку позже.';
							|en = 'The service is temporarily unavailable. Contact the technical support or try again later.'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РаботаСJson

// Служебная функция, предназначенная для использования в объекте ЗаписатьJSON
// Служит функцией преобразования двоичных данных в base64 и содержит обязательные 
// для такого случая параметры.
// 
// Параметры: 
// 	Свойство 				- Строка - в параметр передается имя свойства, если выполняется запись структуры или соответствия
// 	Значение 				- Произвольный - ожидается тип ДвоичныеДанные
// 	ДополнительныеПараметры - Структура - дополнительные параметры, которые указаны в вызове метода ЗаписатьJSON:
//   * ЗаменятьДвоичныеДанные - Булево - заменяет двоичные данные
// 	Отказ - Булево	- отказ от записи свойства
// 
// Возвращаемое значение: 
//  Строка
//
Функция ПреобразоватьДвоичныеДанныеВBase64(Свойство, Значение, ДополнительныеПараметры, Отказ) Экспорт
	
	Если ТипЗнч(Значение) = Тип("ДвоичныеДанные") Тогда
		Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
			И ДополнительныеПараметры.Свойство("ЗаменятьДвоичныеДанные")
			И ДополнительныеПараметры.ЗаменятьДвоичныеДанные Тогда
			Возврат Значение.Размер();
		Иначе
			Возврат Base64Строка(Значение);
		КонецЕсли;
	КонецЕсли;
		
КонецФункции

// Служебная функция, предназначенная для использования в объекте ПрочитатьJSON
// Служит функцией восстановления строки base64 в ДвоичныеДанные и содержит обязательные 
// для такого случая параметры.
// 
// Параметры: 
//	Свойство 				- Строка - указывается только при чтении объектов JSON,
//	Значение 				- Произвольный - значение допустимого для сериализации типа
//	ДополнительныеПараметры - Произвольный - содержит дополнительные параметры 
// 
// Возвращаемое значение: 
//  ДвоичныеДанные
//
Функция ПреобразоватьBase64ВДвоичныеДанные(Свойство, Значение, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Значение) = Тип("Строка") Тогда
		Возврат Base64Значение(Значение);
	ИначеЕсли ТипЗнч(Значение) = Тип("Массив") Тогда
		Для Индекс = 0 По Значение.ВГраница() Цикл
			Значение[Индекс] = Base64Значение(Значение[Индекс]);	
		КонецЦикла;
		Возврат Значение;
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

#КонецОбласти

#КонецОбласти
