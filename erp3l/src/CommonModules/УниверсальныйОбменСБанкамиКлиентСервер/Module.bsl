#Область ПрограммныйИнтерфейс

Процедура СообщитьПользователю(
		Знач ТекстСообщенияПользователю,
		Знач ИдентификаторНазначения  = "") Экспорт
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Если ЗначениеЗаполнено(ИдентификаторНазначения) Тогда
		Сообщение.ИдентификаторНазначения  = ИдентификаторНазначения;
	КонецЕсли;
	Сообщение.Сообщить();

КонецПроцедуры

Функция ЧислоИПредметИсчисления(
		Число,
		ПараметрыПредметаИсчисления1,
		ПараметрыПредметаИсчисления2,
		ПараметрыПредметаИсчисления3,
		Род,
		БезЧисла = Ложь) Экспорт
		
	ФорматнаяСтрока = "Л = ru_RU";
	
	ПараметрыПредметаИсчисления = "%1,%2,%3,%4,,,,,0";
	ПараметрыПредметаИсчисления = СтрШаблон(
		ПараметрыПредметаИсчисления,
		ПараметрыПредметаИсчисления1,
		ПараметрыПредметаИсчисления2,
		ПараметрыПредметаИсчисления3,
		Род);
		
	ЧислоСтрокойИПредметИсчисления = НРег(ЧислоПрописью(Число, ФорматнаяСтрока, ПараметрыПредметаИсчисления));
	
	ЧислоПрописью = ЧислоСтрокойИПредметИсчисления;
	ЧислоПрописью = СтрЗаменить(ЧислоПрописью, ПараметрыПредметаИсчисления3, "");
	ЧислоПрописью = СтрЗаменить(ЧислоПрописью, ПараметрыПредметаИсчисления2, "");
	ЧислоПрописью = СтрЗаменить(ЧислоПрописью, ПараметрыПредметаИсчисления1, "");
	
	Если БезЧисла Тогда
		ЧислоЦифройИПредметИсчисления = СтрЗаменить(ЧислоСтрокойИПредметИсчисления, ЧислоПрописью, "");
	Иначе
		ЧислоЦифройИПредметИсчисления = Строка(Число) + " " + СтрЗаменить(ЧислоСтрокойИПредметИсчисления, ЧислоПрописью, "");
	КонецЕсли;
	
	Возврат ЧислоЦифройИПредметИсчисления;
	
КонецФункции

// Сравнить две строки версий.
//
// Параметры:
//  СтрокаВерсии1  - Строка - номер версии в формате РР.{П|ПП}
//  СтрокаВерсии2  - Строка - второй сравниваемый номер версии.
//
// Возвращаемое значение:
//   Число   - больше 0, если СтрокаВерсии1 > СтрокаВерсии2; 0, если версии равны.
//
Функция СравнитьВерсии(Знач СтрокаВерсии1, Знач СтрокаВерсии2) Экспорт
	
	Строка1 = ?(ПустаяСтрока(СтрокаВерсии1), "0.0", СтрокаВерсии1);
	Строка2 = ?(ПустаяСтрока(СтрокаВерсии2), "0.0", СтрокаВерсии2);
	Версия1 = СтрРазделить(Строка1, ".");
	Если Версия1.Количество() <> 2 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неправильный формат параметра СтрокаВерсии1: %1';
				|en = 'Invalid format of СтрокаВерсии1 parameter: %1.'"), СтрокаВерсии1);
	КонецЕсли;
	Версия2 = СтрРазделить(Строка2, ".");
	Если Версия2.Количество() <> 2 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	    	НСтр("ru = 'Неправильный формат параметра СтрокаВерсии2: %1';
				|en = 'Invalid format of СтрокаВерсии2 parameter: %1.'"), СтрокаВерсии2);
	КонецЕсли;
	
	Результат = 0;
	Для Разряд = 0 По 1 Цикл
		Результат = Число(Версия1[Разряд]) - Число(Версия2[Разряд]);
		Если Результат <> 0 Тогда
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Сравнить два идентификатора семейств.
//
// Параметры:
//  Семейство  - Строка - идентификатор семейства.
//  ДопустимыеСемейства  - Строка - список допустимых семейств.
//
// Возвращаемое значение:
//   Булево   - Ложь, если Семейство не является допустимым; Истина, если семейство допустимо.
//
Функция ПринадлежитСемействуКонфигураций(Знач Семейство, Знач ДопустимыеСемейства) Экспорт
	
	СписокСемейств = СтрРазделить(ДопустимыеСемейства, ";");
	Возврат (СписокСемейств.Найти(Семейство) <> Неопределено);
	
КонецФункции

// Возвращает суффикс имени файла архива при переносе клиент-сервер
// Суффикс добавляется к исходному имени файла
// 
// Возвращаемое значение:
// 	Строка - суффикс имени
Функция СуффиксИмениФайлаАрхива() Экспорт
	
	Возврат ".zip";
	
КонецФункции

// Возвращает суффикс имени файла подписи при переносе клиент-сервер
// Суффикс добавляется к исходному имени файла
//
// Возвращаемое значение:
// 	Строка - суффикс имени
Функция СуффиксИмениФайлаПодписи() Экспорт
	
	Возврат ".sign";
	
КонецФункции

// Возвращает суффикс имени зашифрованного файла при переносе клиент-сервер
//
// Возвращаемое значение:
// 	Строка - суффикс имени
Функция СуффиксИмениФайлаПослеШифрования() Экспорт
	
	Возврат ".encrypted";
	
КонецФункции

// Возвращает суффикс имени расшифрованного файла при переносе клиент-сервер
//
// Возвращаемое значение:
// 	Строка - суффикс имени
Функция СуффиксИмениФайлаПослеРасшифровки() Экспорт
	
	Возврат ".decrypted";
	
КонецФункции

Функция СтуктураДанныхСертификатаВСтроку(Структура) Экспорт
	
	Результат = "";
	МассивСтрок = Новый Массив;
	Для каждого КлючЗначение Из Структура Цикл
		МассивСтрок.Добавить(СтрШаблон("%1=%2;", КлючЗначение.Ключ, КлючЗначение.Значение));
	КонецЦикла;
	Результат = СтрСоединить(МассивСтрок);
	
	Возврат Результат;
	
КонецФункции

Функция НовыйИдентификатор() Экспорт
	
	Возврат НРег(СтрЗаменить(Новый УникальныйИдентификатор, "-", ""));
	
КонецФункции

Функция УникальнаяСтрока(ИсходнаяУникальнаяСтрока, МаксимальнаяДлина) Экспорт
	
	Если СтрДлина(ИсходнаяУникальнаяСтрока) > МаксимальнаяДлина Тогда
		ЗавершающийИдентификатор = НовыйИдентификатор();
		ДлинаИдентификатора = СтрДлина(ЗавершающийИдентификатор);
		Возврат Лев(ИсходнаяУникальнаяСтрока, МаксимальнаяДлина - ДлинаИдентификатора) + ЗавершающийИдентификатор;
	Иначе
		Возврат ИсходнаяУникальнаяСтрока;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьИнформациюОбОшибке(ИнформацияОбОшибке) Экспорт
	
	Результат = ИнформацияОбОшибке;
	Если ИнформацияОбОшибке <> Неопределено Тогда
		Если ИнформацияОбОшибке.Причина <> Неопределено Тогда
			Результат = ПолучитьИнформациюОбОшибке(ИнформацияОбОшибке.Причина);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Заполняет структуру отбора сертификата по умолчанию.
// Разработчики сервисов могут дополнять структуру произвольными полями. Используется в функции СертификатСоответствуетОтбору .
//
// Параметры:
//   Сервис - ПеречислениеСсылка.СервисОбменаСБанками - сервис для проверки сертификата.
//   Организация - СправочникСсылка.Организация - организация для проверки сертификата.
// Возвращаемое значение:
//   Структура - структура с полями:
//     * Организация         - СправочникСсылка.Организация - организация для проверки сертификата.
//     * Сервис              - ПеречислениеСсылка.СервисОбменаСБанками - сервис для проверки сертификата.
//     * Дата                - Дата - дата проверки срока действия сертификата.
//     * ПредставлениеОтбора - Строка - строковое представление отбора.
Функция ПараметрыОтбораСертификата(Сервис, Организация, Дата = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Организация", Организация);
	Результат.Вставить("Сервис", Сервис);
	Результат.Вставить("ПредставлениеОтбора", "");// Строковое представление отбора.
	
	Если Дата = Неопределено Тогда
		Результат.Вставить("Дата", УниверсальныйОбменСБанкамиВызовСервера.ТекущаяДатаНаСервере());
	Иначе
		Результат.Вставить("Дата", Дата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверка, что данный сертификат подходит под условия.
//
// Параметры:
//  Сертификат   - Строка - отпечаток сертификата.
//  ПараметрыОтбора - Структура - должна содержать по меньшей мере ключи Сервис и Организация.
//
// Возвращаемое значение:
//   Структура   - см. РезультатФункцийСоответствияОтбору()
//
Функция СертификатСоответствуетОтбору(Сертификат, ПараметрыОтбора) Экспорт
	
	Результат = РезультатФункцийСоответствияОтбору();
	
	Если ПараметрыОтбора = Неопределено Тогда
		// Если параметры не заданы считаем, что сертификат прошел проверку.
		Возврат Результат;
	КонецЕсли;
	
	// Обязательные параметры Сервис, Организация.
	ИмяСервиса = ОбщегоНазначенияБПВызовСервера.ИмяЗначенияПеречисления(ПараметрыОтбора.Сервис);
	Если ИмяСервиса = "ФинансоваяОтчетность" Тогда
		ИмяМодуляПроверки = "ФинОтчетностьВБанкиКлиентСервер";
	ИначеЕсли ИмяСервиса = "ЗаявкиНаКредит" Тогда
		ИмяМодуляПроверки = "ЗаявкиНаКредитКлиентСервер";
	КонецЕсли;
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		МодульПроверки = ОбщегоНазначения.ОбщийМодуль(ИмяМодуляПроверки);
	#Иначе
		МодульПроверки = ОбщегоНазначенияКлиент.ОбщийМодуль(ИмяМодуляПроверки);
	#КонецЕсли
	
	Если МодульПроверки <> Неопределено Тогда
		МодульПроверки.СертификатСоответствуетОтбору(Сертификат, ПараметрыОтбора, Результат);
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

Процедура СертификатСоответствуетОтборуПоИНН(ДанныеСубъекта, ЭтоЮрЛицо, ПараметрыОтбора, Результат) Экспорт
	Перем ИНН;

	Если Не ПараметрыОтбора.Свойство("ИНН", ИНН) Тогда
		Возврат;
	КонецЕсли;
	
	// ИНН организации.
	ИНН = СокрЛП(ИНН);
	ДлинаИНН = СтрДлина(ИНН);
	// В реквизите ИНН сертификата могут быть впереди стоящие 0, сравниваем без их учета.
	Результат.ПризнакСоответствия = Не (ЭтоЮрЛицо И ДлинаИНН <> 10 Или Не ЭтоЮрЛицо И ДлинаИНН <> 12)
										И СтрНайти(ДанныеСубъекта.ИНН, ИНН) <> 0;
	Если Результат.ПризнакСоответствия Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоЮрЛицо Тогда
		Результат.СообщениеДляПользователя = СтрШаблон(
			НСтр("ru = 'ИНН сертификата (%1) не совпадает с ИНН организации (%2)';
				|en = 'Certificate TIN (%1) differs from the company TIN (%2)'"),
				ДанныеСубъекта.ИНН, ИНН);
	Иначе
		Результат.СообщениеДляПользователя = СтрШаблон(
			НСтр("ru = 'ИНН сертификата (%1) не совпадает с ИНН предпринимателя (%2)';
				|en = 'Certificate TIN (%1) differs from the entrepreneur TIN (%2)'"),
				ДанныеСубъекта.ИНН, ИНН);
	КонецЕсли;
	
КонецПроцедуры

Функция РезультатФункцийСоответствияОтбору() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ПризнакСоответствия", Истина);
	Результат.Вставить("СообщениеДляПользователя", "");
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру данных субъекта на основании данных сертификата криптографии.
Функция ДанныеСубъектаСертификата(Сертификат) Экспорт
	
	ДанныеСубъектаИзСертификата = Сертификат.Субъект;
	
	СвойстваРезультат = Новый Структура();
	СвойстваРезультат.Вставить("Имя",              "");
	СвойстваРезультат.Вставить("Организация",      "");
	СвойстваРезультат.Вставить("Подразделение",    "");
	СвойстваРезультат.Вставить("ЭлектроннаяПочта", "");
	СвойстваРезультат.Вставить("Должность",        "");
	СвойстваРезультат.Вставить("ИНН",              "");
	СвойстваРезультат.Вставить("СНИЛС",            "");
	
	// ФИО
	Если ДанныеСубъектаИзСертификата.Свойство("SN") И ДанныеСубъектаИзСертификата.Свойство("GN") Тогда
		ФИО = ДанныеСубъектаИзСертификата["SN"] + " " + ДанныеСубъектаИзСертификата["GN"];
	ИначеЕсли ДанныеСубъектаИзСертификата.Свойство("CN") Тогда
		// У ПФРовских сертификатов поля с ФИО не заполнены.
		ФИО = ДанныеСубъектаИзСертификата["CN"];
	Иначе
		ФИО = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("Имя", ФИО);

	// Организация
	Если ДанныеСубъектаИзСертификата.Свойство("O") Тогда
		Организация = ДанныеСубъектаИзСертификата["O"];
	Иначе
		Организация = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("Организация", Организация);
	
	// Подразделение
	Если ДанныеСубъектаИзСертификата.Свойство("OU") Тогда
		Подразделение = ДанныеСубъектаИзСертификата["OU"];
	Иначе
		Подразделение = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("Подразделение", Подразделение);
	
	// ЭлектроннаяПочта
	Если ДанныеСубъектаИзСертификата.Свойство("E") Тогда
		ЭлектроннаяПочта = ДанныеСубъектаИзСертификата["E"];
	Иначе
		ЭлектроннаяПочта = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("ЭлектроннаяПочта", ЭлектроннаяПочта);

	// Должность
	Если ДанныеСубъектаИзСертификата.Свойство("T") Тогда
		Должность = ДанныеСубъектаИзСертификата["T"];
	Иначе
		Должность = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("Должность", Должность);
	
	// ИНН
	СвойстваРезультат.Вставить("ИНН", ИННСубъектаСертификата(ДанныеСубъектаИзСертификата));
	
	// СНИЛС
	Если ДанныеСубъектаИзСертификата.Свойство("OID1_2_643_100_3") Тогда
		СНИЛС = ДанныеСубъектаИзСертификата["OID1_2_643_100_3"];
	ИначеЕсли ДанныеСубъектаИзСертификата.Свойство("SNILS") Тогда
		СНИЛС = ДанныеСубъектаИзСертификата["SNILS"];
	Иначе
		СНИЛС = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("СНИЛС", СНИЛС);

	Возврат СвойстваРезультат;

КонецФункции

// Возвращает значение ИНН для субъекта сертификата.
// Стандартные объектные идентификаторы атрибутов сертификата описаны в Приказе ФСБ России от 27.12.2011 N 795.
//
// Параметры:
//	Субъект - Структура, ФиксированнаяСтруктура - Содержит данные субъекта сертификата.
//
// Возвращаемое значение:
//	Строка - ИНН субъекта сертификата.
//
Функция ИННСубъектаСертификата(Субъект) Экспорт

	Если Субъект.Свойство("OID1_2_643_100_4") Тогда
		// OID ИНН юридического лица c 01.09.2021.
	    ИНН = Субъект["OID1_2_643_100_4"];

	ИначеЕсли Субъект.Свойство("OID1_2_643_3_131_1_1") Тогда
		// OID ИНН физического лица, до 01.09.2021 использовался также и для юридического лица.
		ИНН = Субъект["OID1_2_643_3_131_1_1"];

	ИначеЕсли Субъект.Свойство("INNLE") Тогда
		// Артибут ИНН юридического лица c 01.09.2021.
		ИНН = Субъект["INNLE"];

	ИначеЕсли Субъект.Свойство("INN") Тогда
		// Атрибут ИНН физического лица, до 01.09.2021 использовался также и для юридического лица.
		ИНН = Субъект["INN"];

	Иначе
		ИНН = "";
	КонецЕсли;

	Если СтрДлина(ИНН) = 12 И Лев(ИНН, 2) = "00" Тогда
		ИНН = Прав(ИНН, 10);
	КонецЕсли; 
	
	Возврат ИНН;

КонецФункции

#Область СостоянияДокументооборота

Функция СостояниеДокументооборотаНачат() Экспорт
	
	Возврат ПредопределенноеЗначение("Перечисление.СостоянияДокументооборотаОбменаСБанками.Начат");
	
КонецФункции

Функция СостояниеДокументооборотаНеНачат() Экспорт
	
	Возврат ПредопределенноеЗначение("Перечисление.СостоянияДокументооборотаОбменаСБанками.НеНачат");
	
КонецФункции

Функция СостояниеДокументооборотаПоложительныйРезультат() Экспорт
	
	Возврат ПредопределенноеЗначение("Перечисление.СостоянияДокументооборотаОбменаСБанками.ПоложительныйРезультат");
	
КонецФункции

Функция СостояниеДокументооборотаОтрицательныйРезультат() Экспорт
	
	Возврат ПредопределенноеЗначение("Перечисление.СостоянияДокументооборотаОбменаСБанками.ОтрицательныйРезультат");
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция НайтиГруппуСобытий(ДанныеГрупп, Идентификатор) Экспорт
	
	Группа = ДанныеГрупп.Словарь.Получить(Идентификатор);
	Возврат Группа;
	
КонецФункции

Функция ОпределитьКоличествоНовых(СтрокиДерева, ДанныеГрупп) Экспорт
	
	КоличествоСобытийПоГруппам = Новый Соответствие;
	СтрокиПоГруппам = Новый Соответствие;
	
	Для каждого Группа Из ДанныеГрупп.Коллекция Цикл
		Если Группа.ПодсчетКоличестваНовыхСобытий Тогда
			КоличествоСобытийПоГруппам.Вставить(Группа.Идентификатор, 0);
		КонецЕсли;
	КонецЦикла;

	КоличествоНовых = 0;
	
	КоличествоЗавершенныеОтправки = 0;
	
	СтрокаБлокЗавершенныеОтправки = Неопределено;
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		Группа = НайтиГруппуСобытий(ДанныеГрупп, СтрокаДерева.Группа);
		Если Группа = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если Группа.ПодсчетКоличестваНовыхСобытий Тогда 
			Если СтрокаДерева.ЭтоЗаголовокБлока Тогда
				СтрокиПоГруппам.Вставить(Группа.Идентификатор, СтрокаДерева);
			ИначеЕсли СтрокаДерева.НеПрочитано Тогда
				КоличествоСобытий = КоличествоСобытийПоГруппам.Получить(Группа.Идентификатор);
				КоличествоСобытийПоГруппам.Вставить(Группа.Идентификатор, КоличествоСобытий + 1);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	КоличествоНовых = 0;
	Для каждого КлючЗначение Из КоличествоСобытийПоГруппам Цикл
		КоличествоНовыхПоГруппе = КлючЗначение.Значение;
		КоличествоНовых = КоличествоНовых + КоличествоНовыхПоГруппе;
		Строка = СтрокиПоГруппам.Получить(КлючЗначение.Ключ);
		Группа = НайтиГруппуСобытий(ДанныеГрупп, КлючЗначение.Ключ);
		Если Строка <> Неопределено Тогда
			Если КоличествоНовыхПоГруппе = 0 Тогда
				Строка.ЗаголовокБлока = Группа.Представление;
			Иначе
				Строка.ЗаголовокБлока = СтрШаблон(
					Группа.ШаблонНеНулевогоКоличестваСобытий,
					КоличествоНовыхПоГруппе);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат КоличествоНовых;
	
КонецФункции

// Возвращает имя файла внутри архива с документом.
// Параметры:
//   ИсходноеИмяФайла - Строка - Исходное имя файла документа.
// Возвращаемое значение:
//   Строка - имя файла внутри архива.
Функция ИмяФайлаВнутриАрхиваДокумента(ИсходноеИмяФайла) Экспорт
	
	Возврат "file";
	
КонецФункции

Функция НаименованиеСертификата(СертификатКриптографии) Экспорт
	
	Если СертификатКриптографии.Субъект.Свойство("CN") Тогда
		Наименование = СертификатКриптографии.Субъект.CN;
	ИначеЕсли СертификатКриптографии.Субъект.Свойство("O") Тогда
		Наименование = СертификатКриптографии.Субъект.O;
	ИначеЕсли СертификатКриптографии.Субъект.Свойство("E") Тогда 
		Наименование = СертификатКриптографии.Субъект.E;
	Иначе
		Наименование = "Сертификат";
	КонецЕсли; 
	
	Возврат СокрЛП(Наименование);
	
КонецФункции

Функция СертификатКриптографииВСтуктуру(СертификатКриптографии) Экспорт
	
	ОписаниеСертификата = Новый Структура;
	ОписаниеСертификата.Вставить("Версия");
	ОписаниеСертификата.Вставить("ДатаНачала");
	ОписаниеСертификата.Вставить("ДатаОкончания");
	ОписаниеСертификата.Вставить("Издатель");
	ОписаниеСертификата.Вставить("ИспользоватьДляПодписи");
	ОписаниеСертификата.Вставить("ИспользоватьДляШифрования");
	ОписаниеСертификата.Вставить("ОткрытыйКлюч");
	ОписаниеСертификата.Вставить("Отпечаток");
	ОписаниеСертификата.Вставить("РасширенныеСвойства");
	ОписаниеСертификата.Вставить("СерийныйНомер");
	ОписаниеСертификата.Вставить("Субъект");
	
	ОписаниеСертификата.Вставить("Наименование", НаименованиеСертификата(СертификатКриптографии));
	
	ЗаполнитьЗначенияСвойств(ОписаниеСертификата, СертификатКриптографии);
	
	Возврат ОписаниеСертификата;
	
КонецФункции

Процедура ВывестиОшибку(
	Знач ТекстСообщения,
	Знач КлючДанных = Неопределено,
	Знач Поле = "",
	Знач ПутьКДанным = "",
	Отказ = Ложь
	) Экспорт
	
	Если ЗначениеЗаполнено(КлючДанных)
		ИЛИ ЗначениеЗаполнено(Поле) 
		ИЛИ ЗначениеЗаполнено(ПутьКДанным)
		ИЛИ Отказ <> Ложь Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, КлючДанных, Поле, ПутьКДанным, Отказ);
	Иначе
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

Функция ЗаменитьНечитаемыеСимволы(ИсходнаяСтрока, ЗаменятьНа = "_") Экспорт
	
	СтрокаПослеЗамены = ИсходнаяСтрока;
	
	ДлинаСтроки = СтрДлина(ИсходнаяСтрока);
	Для Индекс = 1 По ДлинаСтроки Цикл
		ТекущийСимвол = Сред(ИсходнаяСтрока, Индекс, 1);
		Если КодСимвола(ТекущийСимвол) < 32 Тогда
			СтрокаПослеЗамены = СтрЗаменить(СтрокаПослеЗамены, ТекущийСимвол, ЗаменятьНа);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрокаПослеЗамены;
	
КонецФункции

// Возвращает список криптопровайдеров, поддерживаемых 1С-Отчетностью.
//
// Возвращаемое значение:
//	ФиксированныйМассив - массив с описаниями криптопровайдеров.
//  * Имя - Строка - имя криптопровайдера.
//  * Тип - Число  - тип криптопровайдера.
//  * Путь - Строка - путь к модулю криптопровайдера в nix-системах.
//  * Представление - Строка - представление криптопровайдера для отображение в интерфейсе.
//
Функция ПоддерживаемыеКриптопровайдеры() Экспорт
	
	СписокКриптопровайдеров = Новый Массив;
	СписокКриптопровайдеров.Добавить(КриптопровайдерCryptoPro());
	СписокКриптопровайдеров.Добавить(КриптопровайдерViPNet());
	
	Возврат Новый ФиксированныйМассив(СписокКриптопровайдеров);
	
КонецФункции

// Возвращает описание криптопровайдера облачного криптопровайдера.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура - описание криптопровайдера.
//  * Имя - Строка - имя криптопровайдера.
//  * Тип - Число  - тип криптопровайдера.
//  * Путь - Строка - путь к модулю криптопровайдера в nix-системах.
//  * Представление - Строка - представление криптопровайдера для отображение в интерфейсе.
//
Функция КриптопровайдерОблачныйКриптопровайдер() Экспорт
	
	Свойства = Новый Структура();
	Свойства.Вставить("Имя", 			"Облачный криптопровайдер");
	Свойства.Вставить("Путь", 			"");
	Свойства.Вставить("Тип", 			0);
	Свойства.Вставить("Представление", 	"Облачный криптопровайдер");
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

// Возвращает основной используемый отечественный криптографический алгоритм.
//
Функция АлгоритмПоУмолчанию() Экспорт
	
	Возврат "GOST R 34.10-2012-256";
	
КонецФункции

Функция ПоддерживаемыеАлгоритмы() Экспорт
	
	МассивАлгоритмов = Новый Массив;
	
	ОсновнойАлгоритм = АлгоритмПоУмолчанию();
	
	Если ОсновнойАлгоритм = "GOST R 34.10-2012-256" Тогда
		МассивАлгоритмов.Добавить("GOST R 34.10-2012-256");
		МассивАлгоритмов.Добавить("GOST R 34.10-2012-512");
		МассивАлгоритмов.Добавить("GOST R 34.10-2001");
		
	ИначеЕсли ОсновнойАлгоритм = "GOST R 34.10-2012-512" Тогда
		МассивАлгоритмов.Добавить("GOST R 34.10-2012-512");
		МассивАлгоритмов.Добавить("GOST R 34.10-2012-256");
		МассивАлгоритмов.Добавить("GOST R 34.10-2001");
		
	Иначе
		МассивАлгоритмов.Добавить("GOST R 34.10-2001");
		МассивАлгоритмов.Добавить("GOST R 34.10-2012-256");
		МассивАлгоритмов.Добавить("GOST R 34.10-2012-512");
	КонецЕсли;
	
	Возврат МассивАлгоритмов;
	
КонецФункции

// Возвращает описание криптопровайдера CryptoPro CSP.
//
// Параметры:
//  Алгоритм    - Строка       - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512",
//                               при значении "" или Неопределено возвращается массив свойств криптопровайдеров всех алгоритмов
//                               и классов защиты.
//  ЭтоLinux    - Булево.
//              - Неопределено - при пустых значениях Алгоритм или КлассЗащиты возвращаются массив свойств криптопровайдеров
//                               для каждой операционной системы, иначе возвращаются свойства криптопровайдера для текущей.
//  КлассЗащиты - Число        - 1, 2 или 3,
//                               при значении 0 или Неопределено возвращается массив свойств криптопровайдеров всех классов защиты.
//  Путь        - Строка       - путь модуля криптографии в nix-системах.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура или ФиксированныйМассив из ФиксированнаяСтруктура (при Алгоритм = Неопределено) - описание криптопровайдера.
//    * Имя                 - Строка - имя криптопровайдера.
//    * Тип                 - Число  - тип криптопровайдера.
//    * Путь                - Строка - путь к модулю криптопровайдера в nix-системах.
//    * Представление       - Строка - представление типа криптопровайдера для отображения в интерфейсе.
//    * ТипКриптопровайдера - Перечисления.ТипыКриптоПровайдеров.CryptoPro.
//    * Алгоритм            - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512".
//    * Поддерживается      - Булево - Истина.
//
Функция КриптопровайдерCryptoPro(
		Алгоритм = "GOST R 34.10-2012-256",
		ЭтоLinux = Неопределено,
		КлассЗащиты = 1,
		Путь = "") Экспорт
	
	Если НЕ ЗначениеЗаполнено(Алгоритм) ИЛИ НЕ ЗначениеЗаполнено(КлассЗащиты) Тогда
		МассивСвойств = Новый Массив;
		
		Если ЗначениеЗаполнено(Алгоритм) Тогда
			МассивАлгоритмов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Алгоритм);
		Иначе
			МассивАлгоритмов = ПоддерживаемыеАлгоритмы();
		КонецЕсли;
		
		ВариантыПоддержкиLinux = Новый Массив;
		Если ЭтоLinux = Неопределено Тогда
			ВариантыПоддержкиLinux.Добавить(Истина);
			ВариантыПоддержкиLinux.Добавить(Ложь);
		Иначе
			ВариантыПоддержкиLinux.Добавить(ЭтоLinux);
		КонецЕсли;
		
		Для каждого ПроверяемыйАлгоритм Из МассивАлгоритмов Цикл
			Для каждого ЭтоКриптопровайдерLinux из ВариантыПоддержкиLinux Цикл
				ПроверяемыйКлассЗащиты = 1;
				Свойства = КриптопровайдерCryptoPro(
					ПроверяемыйАлгоритм,
					ЭтоКриптопровайдерLinux,
					ПроверяемыйКлассЗащиты,
					Путь);
				МассивСвойств.Добавить(Свойства);
			КонецЦикла;
		КонецЦикла;
		
		Возврат Новый ФиксированныйМассив(МассивСвойств);
	КонецЕсли;
	
	ЭтоКриптопровайдерLinux = ЭтоLinux;
	Если ЭтоКриптопровайдерLinux = Неопределено Тогда
		#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
			ЭтоКриптопровайдерLinux = ОбщегоНазначения.ЭтоLinuxКлиент();
		#Иначе
			ЭтоКриптопровайдерLinux = ОбщегоНазначенияКлиент.ЭтоLinuxКлиент();
		#КонецЕсли
	КонецЕсли;
	
	Если Алгоритм = "GOST R 34.10-2012-256" Тогда
		Если ЭтоКриптопровайдерLinux И КлассЗащиты > 1 Тогда
			ИмяКриптопровайдера = СтрШаблон(
				"Crypto-Pro GOST R 34.10-2012 KC%1 CSP",
				Строка(КлассЗащиты));
			
		Иначе
			ИмяКриптопровайдера = "Crypto-Pro GOST R 34.10-2012 Cryptographic Service Provider";
		КонецЕсли;
		
		ТипКриптопровайдера 		= 80;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2012-256";
		
	ИначеЕсли Алгоритм = "GOST R 34.10-2012-512" Тогда
		Если ЭтоКриптопровайдерLinux И КлассЗащиты > 1 Тогда
			ИмяКриптопровайдера = СтрШаблон(
				"Crypto-Pro GOST R 34.10-2012 KC%1 Strong CSP",
				Строка(КлассЗащиты));
			
		Иначе
			ИмяКриптопровайдера = "Crypto-Pro GOST R 34.10-2012 Strong Cryptographic Service Provider";
		КонецЕсли;
		
		ТипКриптопровайдера 		= 81;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2012-512";
		
	Иначе // Алгоритм "GOST R 34.10-2001"
		Если ЭтоКриптопровайдерLinux И КлассЗащиты > 1 Тогда
			ИмяКриптопровайдера = СтрШаблон(
				"Crypto-Pro GOST R 34.10-2001 KC%1 CSP",
				Строка(КлассЗащиты));
			
		Иначе
			ИмяКриптопровайдера = "Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider";
		КонецЕсли;
		
		ТипКриптопровайдера 		= 75;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2001";
	КонецЕсли;
	
	Свойства = Новый Структура();
	Свойства.Вставить("Имя", 					ИмяКриптопровайдера);
	Свойства.Вставить("Путь", 					Путь);
	Свойства.Вставить("Тип", 					ТипКриптопровайдера);
	Свойства.Вставить("ТипКриптопровайдера", 	ПредопределенноеЗначение("Перечисление.ТипыКриптоПровайдеровОбменаСБанками.CryptoPro"));
	Свойства.Вставить("Представление", 			"CryptoPro CSP");
	Свойства.Вставить("Алгоритм", 				АлгоритмКриптопровайдера);
	Свойства.Вставить("Поддерживается", 		Истина);
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

Функция ИдентификаторПрограммыКриптографии(Описание) Экспорт
	
	Шаблон = "%1_%2_%3";
	Возврат СтрШаблон(Шаблон,
		Описание.Имя,
		Описание.Тип,
		Описание.Алгоритм);
	
КонецФункции

// Возвращает описание криптопровайдера ViPNet CSP.
//
// Параметры:
//  Алгоритм - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512".
//                      при значении "" или Неопределено возвращается массив свойств криптопровайдеров всех алгоритмов.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура или ФиксированныйМассив из ФиксированнаяСтруктура (при Алгоритм = Неопределено) - описание криптопровайдера.
//    * Имя                 - Строка - имя криптопровайдера.
//    * Тип                 - Число  - тип криптопровайдера.
//    * Путь                - Строка - путь к модулю криптопровайдера в nix-системах.
//    * Представление       - Строка - представление типа криптопровайдера для отображения в интерфейсе.
//    * ТипКриптопровайдера - Перечисления.ТипыКриптоПровайдеров.VipNet.
//    * Алгоритм            - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512".
//    * Поддерживается      - Булево - Истина.
//
Функция КриптопровайдерViPNet(Алгоритм = "GOST R 34.10-2012-256") Экспорт
	
	Если НЕ ЗначениеЗаполнено(Алгоритм) Тогда
		МассивСвойств = Новый Массив;
		МассивАлгоритмов = ПоддерживаемыеАлгоритмы();
		
		Для каждого ПроверяемыйАлгоритм Из МассивАлгоритмов Цикл
			Свойства = КриптопровайдерViPNet(ПроверяемыйАлгоритм);
			МассивСвойств.Добавить(Свойства);
		КонецЦикла;
		
		Возврат Новый ФиксированныйМассив(МассивСвойств);
	КонецЕсли;
	
	Если Алгоритм = "GOST R 34.10-2012-256" Тогда
		ИмяКриптопровайдера 		= "Infotecs GOST 2012/512 Cryptographic Service Provider";
		ТипКриптопровайдера 		= 77;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2012-256";
		
	ИначеЕсли Алгоритм = "GOST R 34.10-2012-512" Тогда
		ИмяКриптопровайдера 		= "Infotecs GOST 2012/1024 Cryptographic Service Provider";
		ТипКриптопровайдера 		= 78;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2012-512";
		
	Иначе // Алгоритм "GOST R 34.10-2001"
		ИмяКриптопровайдера 		= "Infotecs Cryptographic Service Provider";
		ТипКриптопровайдера			= 2;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2001";
	КонецЕсли;
	
	Свойства = Новый Структура();
	Свойства.Вставить("Имя", 					ИмяКриптопровайдера);
	Свойства.Вставить("Путь", 					"");
	Свойства.Вставить("Тип", 					ТипКриптопровайдера);
	Свойства.Вставить("ТипКриптопровайдера", 	ПредопределенноеЗначение("Перечисление.ТипыКриптоПровайдеровОбменаСБанками.VipNet"));
	Свойства.Вставить("Представление", 			"ViPNet CSP");
	Свойства.Вставить("Алгоритм", 				АлгоритмКриптопровайдера);
	Свойства.Вставить("Поддерживается", 		Истина);
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

// Возвращает описание криптопровайдера Microsoft Base Cryptographic Provider v1.0.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура - описание криптопровайдера.
//    * Имя                 - Строка - имя криптопровайдера.
//    * Тип                 - Число  - тип криптопровайдера.
//    * Путь                - Строка - путь к модулю криптопровайдера в *nix-системах.
//    * Представление       - Строка - представление типа криптопровайдера для отображения в интерфейсе.
//    * ТипКриптопровайдера - Строка - "MSRSA".
//    * Алгоритм            - Строка - "RSA".
//    * Поддерживается      - Булево - Ложь.
//
Функция КриптопровайдерMicrosoftBaseCryptographicProvider() Экспорт
	
	Свойства = Новый Структура();
	Свойства.Вставить("Имя", 					"Microsoft Base Cryptographic Provider v1.0");
	Свойства.Вставить("Путь", 					"");
	Свойства.Вставить("Тип", 					1);
	Свойства.Вставить("Представление", 			"Microsoft Base Cryptographic Provider v1.0");
	Свойства.Вставить("ТипКриптопровайдера", 	"MSRSA");
	Свойства.Вставить("Алгоритм", 				"RSA");
	Свойства.Вставить("Поддерживается", 		Ложь);
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

Функция ДвоичныеДанныеВСтроку(Данные) Экспорт
	
	Возврат НРег(ПолучитьHexСтрокуИзДвоичныхДанных(Данные));
	
КонецФункции

Функция СобытиеЖурналаРегистрации(ВариантСобытия = "") Экспорт
	
	ИмяСобытия = НСтр("ru = 'Универсальный обмен с банками';
						|en = 'Universal bank exchange'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	Если Не ПустаяСтрока(ВариантСобытия) Тогда
		ИмяСобытия = ИмяСобытия + "." + ВариантСобытия;
	КонецЕсли;

	Возврат ИмяСобытия;
	
КонецФункции

// Преобразует данные владельца сертификата криптографии в структуру с заданными полями.
// Принимает на вход поле Субъект сертификата криптографии.
Функция ДанныеВладельцаСертификата(Знач Владелец) Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("Имя",              "");
	Результат.Вставить("Организация",      "");
	Результат.Вставить("Подразделение",    "");
	Результат.Вставить("ЭлектроннаяПочта", "");
	Результат.Вставить("Должность",        "");
	Результат.Вставить("ИНН",              "");
	Результат.Вставить("СНИЛС",            "");
	
	// ФИО
	Если Владелец.Свойство("SN") И Владелец.Свойство("GN") Тогда
		ФИО = Владелец["SN"] + " " + Владелец["GN"];
	ИначеЕсли Владелец.Свойство("CN") Тогда
		// У ПФРовских сертификатов поля с ФИО не заполнены.
		ФИО = Владелец["CN"];
	Иначе
		ФИО = "";
	КонецЕсли;
	
	Результат.Вставить("Имя", ФИО);

	// Организация
	Если Владелец.Свойство("O") Тогда
		Организация = Владелец["O"];
	Иначе
		Организация = "";
	КонецЕсли;
	
	Результат.Вставить("Организация", Организация);
	
	// Подразделение
	Если Владелец.Свойство("OU") Тогда
		Подразделение = Владелец["OU"];
	Иначе
		Подразделение = "";
	КонецЕсли;
	
	Результат.Вставить("Подразделение", Подразделение);
	
	// ЭлектроннаяПочта
	Если Владелец.Свойство("E") Тогда
		ЭлектроннаяПочта = Владелец["E"];
	Иначе
		ЭлектроннаяПочта = "";
	КонецЕсли;
	
	Результат.Вставить("ЭлектроннаяПочта", ЭлектроннаяПочта);	

	// Должность
	Если Владелец.Свойство("T") Тогда
		Должность = Владелец["T"];
	Иначе
		Должность = "";
	КонецЕсли;
	
	Результат.Вставить("Должность", Должность);
	
	// ИНН
	Результат.Вставить("ИНН", ИННСубъектаСертификата(Владелец));
	
	// СНИЛС
	Если Владелец.Свойство("OID1_2_643_100_3") Тогда
		СНИЛС = Владелец["OID1_2_643_100_3"];
	Иначе
		СНИЛС = "";
	КонецЕсли;
	
	Результат.Вставить("СНИЛС", СНИЛС);

	Возврат Результат;

КонецФункции

#КонецОбласти
