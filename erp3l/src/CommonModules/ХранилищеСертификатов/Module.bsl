////////////////////////////////////////////////////////////////////////////////
// Подсистема "Хранилище сертификатов".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Добавляет сертификат в хранилище сертификатов.
// 
// Параметры:
//   Сертификат - ДвоичныеДанные - файл сертификата.
//              - Строка - адрес файла сертификата во временном хранилище.
//   ТипХранилища - Строка, ПеречислениеСсылка.ТипХранилищаСертификатов - тип хранилища, в которое необходимо добавить сертификат.
//
Процедура Добавить(Сертификат, ТипХранилища) Экспорт

	Если ТипЗнч(ТипХранилища) = Тип("Строка") Тогда
		ТипХранилища = XMLЗначение(Тип("ПеречислениеСсылка.ТипХранилищаСертификатов"), ТипХранилища);
	КонецЕсли;

	ДобавитьПроверкаВходящихПараметров(Сертификат, ТипХранилища);

	Если ТипЗнч(Сертификат) = Тип("Строка") Тогда
		СертификатДвоичныеДанные = ПолучитьИзВременногоХранилища(Сертификат);
	Иначе
		СертификатДвоичныеДанные = Сертификат;
	КонецЕсли;
		
	СвойстваСертификата = СервисКриптографии.ПолучитьСвойстваСертификата(СертификатДвоичныеДанные);
	
	НаборЗаписей = РегистрыСведений.ХранилищеСертификатов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ТипХранилища.Установить(ТипХранилища);
	НаборЗаписей.Отбор.Идентификатор.Установить(СвойстваСертификата.Идентификатор);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.ТипХранилища  = ТипХранилища;
	НоваяЗапись.Идентификатор = СвойстваСертификата.Идентификатор;	
	НоваяЗапись.ДатаНачала    = СвойстваСертификата.ДатаНачала;
	НоваяЗапись.ДатаОкончания = СвойстваСертификата.ДатаОкончания;
	НоваяЗапись.СерийныйНомер = НРег(СтрЗаменить(СвойстваСертификата.СерийныйНомер, " ", ""));
	НоваяЗапись.Отпечаток     = НРег(СтрЗаменить(СвойстваСертификата.Отпечаток, " ", ""));
	Если СвойстваСертификата.Субъект.Свойство("CN") Тогда
		НоваяЗапись.Наименование  = СвойстваСертификата.Субъект.CN;
	КонецЕсли;

	НоваяЗапись.Сертификат = Новый ХранилищеЗначения(СвойстваСертификата, Новый СжатиеДанных(9));
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Получает сертификаты из хранилища.
// 
// Параметры:
//   ТипХранилища - Строка, ПеречислениеСсылка.ТипХранилищаСертификатов - тип хранилища, из которого необходимо получить
//                                                                сертификаты.
//                                                                Если не заполнено, то будут получены все сертификаты.
//
// Возвращаемое значение:
//	 Массив из ФиксированнаяСтруктура - свойства сертификатов:
//    * Версия - Строка - версия сертификата.
//    * ДатаНачала - Дата - дата начала действия сертификата.
//    * ДатаОкончания - Дата - дата окончания действия сертификата.
//    * Издатель - ФиксированнаяСтруктура - информация об издателе сертификата:
//        ** CN - Строка - commonName 
//        ** O - Строка - organizationName 
//        ** OU - Строка - organizationUnitName 
//        ** C - Строка - countryName 
//        ** ST - Строка - stateOrProvinceName 
//        ** L - Строка - localityName 
//        ** E - Строка - emailAddress 
//        ** SN - Строка - surname 
//        ** GN - Строка - givenName 
//        ** T - Строка - title
//        ** STREET - Строка - streetAddress
//        ** OGRN - Строка - ОГРН
//        ** OGRNIP - Строка - ОГРНИП
//        ** INN - Строка - ИНН (необязательный)
//        ** INNLE - Строка - ИННЮЛ (необязательный)
//        ** SNILS - Строка - СНИЛС
//    * ИспользоватьДляПодписи - Булево - указывает, можно ли использовать данный сертификат для подписи.
//    * ИспользоватьДляШифрования - Булево - указывает, можно ли использовать данный сертификат для шифрования.
//    * Отпечаток - ДвоичныеДанные - содержит данные отпечатка. Вычисляется динамически, по алгоритму SHA-1.
//    * РасширенныеСвойства - ФиксированнаяСтруктура - расширенные свойства сертификата:
//        ** EKU - ФиксированныйМассив из Строка - Enhanced Key Usage.
//    * СерийныйНомер - ДвоичныеДанные - серийный номер сертификата.
//    * Субъект - ФиксированнаяСтруктура - информацию о субъекте сертификата:
//        ** CN - Строка - commonName... и т.д. состав см. Издатель.
//    * Сертификат - ДвоичныеДанные - файл сертификата в кодировке DER.
//    * Идентификатор - Строка - вычисляется по ключевым свойствам Издателя и серийному номеру по алгоритму SHA1.
//                               Используется для идентификации сертификата в сервисе криптографии.
//
Функция Получить(ТипХранилища = Неопределено) Экспорт
		
	Если ТипЗнч(ТипХранилища) = Тип("Строка") Тогда
		ТипХранилища = XMLЗначение(Тип("ПеречислениеСсылка.ТипХранилищаСертификатов"), ТипХранилища);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТипХранилища) Тогда
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
			"ХранилищеСертификатов.Получить", 
			"ТипХранилища",
			ТипХранилища, 
			Новый ОписаниеТипов("ПеречислениеСсылка.ТипХранилищаСертификатов"));
	КонецЕсли;
			
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ХранилищеСертификатов.Сертификат,
	|	ХранилищеСертификатов.ТипХранилища
	|ИЗ
	|	РегистрСведений.ХранилищеСертификатов КАК ХранилищеСертификатов
	|ГДЕ
	|	(НЕ &ИспользоватьОтборПоТипуХранилища
	|			ИЛИ ХранилищеСертификатов.ТипХранилища = &ТипХранилища)";
	Запрос.УстановитьПараметр("ТипХранилища", ТипХранилища);
	Запрос.УстановитьПараметр("ИспользоватьОтборПоТипуХранилища", ЗначениеЗаполнено(ТипХранилища));
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();	
	УстановитьПривилегированныйРежим(Ложь);
	
	Сертификаты = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Сертификаты.Добавить(Выборка.Сертификат.Получить());
	КонецЦикла;
		
	Возврат Сертификаты;
		
КонецФункции

// Выполняет поиска сертификата в хранилище.
//
// Параметры:
//   Сертификат - Структура - ключевые параметры сертификата, используемые для поиска:
//                            Отпечаток или пара СерийныйНомер и Издатель.
//     * Отпечаток - ДвоичныеДанные - отпечаток сертификат.
//                 - Строка - строковое представление отпечатка.
//     * СерийныйНомер - ДвоичныеДанные - серийный номер сертификата.
//                     - Строка - строковое представление серийного номера.
//     * Издатель - Структура - свойства издателя
//                - Строка - строковое представление издателя.
//
// Возвращаемое значение: 
//   Неопределено, ФиксированнаяСтруктура - сертификат не найден или свойства найденного сертификата:
//    * Наименование - Строка - наименование сертификата.
//    * Версия - Строка - версия сертификата.
//    * ДатаНачала - Дата - дата начала действия сертификата.
//    * ДатаОкончания - Дата - дата окончания действия сертификата.
//    * Издатель - ФиксированнаяСтруктура - информация об издателе сертификата:
//        ** CN - Строка - commonName; 
//        ** O - Строка - organizationName; 
//        ** OU - Строка - organizationUnitName; 
//        ** C - Строка - countryName; 
//        ** ST - Строка - stateOrProvinceName; 
//        ** L - Строка - localityName; 
//        ** E - Строка - emailAddress; 
//        ** SN - Строка - surname; 
//        ** GN - Строка - givenName; 
//        ** T - Строка - title;
//        ** STREET - Строка - streetAddress;
//        ** OGRN - Строка - ОГРН;
//        ** OGRNIP - Строка - ОГРНИП;
//        ** INN - Строка -  ИНН (необязательный);
//        ** INNLE - Строка -  ИННЮЛ (необязательный);
//        ** SNILS - Строка - СНИЛС;
//           ...
//    * ИспользоватьДляПодписи - Булево - указывает, можно ли использовать данный сертификат для подписи.
//    * ИспользоватьДляШифрования - Булево - указывает, можно ли использовать данный сертификат для шифрования.
//    * Отпечаток - ДвоичныеДанные - содержит данные отпечатка. Вычисляется динамически, по алгоритму SHA-1.
//    * РасширенныеСвойства - ФиксированнаяСтруктура -  расширенные свойства сертификата:
//        ** EKU - ФиксированныйМассив из Строка - Enhanced Key Usage.
//    * СерийныйНомер - ДвоичныеДанные - серийный номер сертификата.
//    * Субъект - ФиксированнаяСтруктура - информацию о субъекте сертификата. Состав см. Издатель:
//        ** CN - Строка - commonName и т.д...
//    * Сертификат - ДвоичныеДанные - файл сертификата в кодировке DER.
//    * Идентификатор - Строка - вычисляется по ключевым свойствам Издателя и серийному номеру по алгоритму SHA1.
//                               Используется для идентификации сертификата в сервисе криптографии.
//
Функция НайтиСертификат(Сертификат) Экспорт
	
	НайтиСертификатПроверкаВходящихПараметров(Сертификат);
	
	Если Сертификат.Свойство("Отпечаток") Тогда
		Отпечаток = НРег(СтрЗаменить(Сертификат.Отпечаток, " ", ""));
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ХранилищеСертификатов.Сертификат
		|ИЗ
		|	РегистрСведений.ХранилищеСертификатов КАК ХранилищеСертификатов
		|ГДЕ
		|	ХранилищеСертификатов.Отпечаток = &Отпечаток";
		Запрос.УстановитьПараметр("Отпечаток", Отпечаток);
	Иначе
		Если ТипЗнч(Сертификат.Издатель) = Тип("Строка") Тогда
			Издатель = РазобратьСтрокуИздателя(Сертификат.Издатель);
		Иначе
			Издатель = Сертификат.Издатель;
		КонецЕсли;
		
		СписокOID = Новый СписокЗначений;
		Для Каждого КлючЗначение Из Издатель Цикл
			СписокOID.Добавить(КлючЗначение.Значение, КлючЗначение.Ключ);
		КонецЦикла;
		
		Идентификатор = СервисКриптографииСлужебный.ВычислитьИдентификаторСертификата(
			Сертификат.СерийныйНомер, СписокOID);
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ХранилищеСертификатов.Сертификат
		|ИЗ
		|	РегистрСведений.ХранилищеСертификатов КАК ХранилищеСертификатов
		|ГДЕ
		|	ХранилищеСертификатов.Идентификатор = &Идентификатор";
		Запрос.УстановитьПараметр("Идентификатор", Идентификатор);		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Возврат Выборка.Сертификат.Получить();
	КонецЕсли;
	
КонецФункции

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

// Возвращает данные сертификата в кодировке DER
// 
// Параметры:
// 	Сертификат - ДвоичныеДанные - данные сертификата
// 	ПроверочныйСимвол - Строка - 
// Возвращаемое значение:
// 	ДвоичныеДанные - данные сертификата в кодировке DER
// 
Функция СертификатВКодировкеDER(Сертификат, ПроверочныйСимвол = "") Экспорт
	
	ИмяФайла = ПолучитьИмяВременногоФайла("cer");
	Сертификат.Записать(ИмяФайла);
	
	Текст = Новый ТекстовыйДокумент;
	Текст.Прочитать(ИмяФайла);
	СертификатТекст = Текст.ПолучитьТекст();
	
	Попытка
		УдалитьФайлы(ИмяФайла);
	Исключение
		ЗаписьЖурналаРегистрации(
			ИмяСобытияУдалениеФайла(),
			УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
		
	Если СтрНайти(СертификатТекст, "-----BEGIN CERTIFICATE-----") > 0 Тогда
		СертификатТекст = СтрЗаменить(СертификатТекст, "-----BEGIN CERTIFICATE-----" + ПроверочныйСимвол, "");
		СертификатТекст = СтрЗаменить(СертификатТекст, ПроверочныйСимвол + "-----END CERTIFICATE-----", "");
		Возврат Base64Значение(СертификатТекст);
	Иначе		
		Возврат Сертификат;
	КонецЕсли;
	
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции
	
Функция ИмяСобытияУдалениеФайла()
	
	Возврат НСтр("ru = 'Хранилище сертификатов.Удаление файла';
				|en = 'Certificate storage. File deletion'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Процедура НайтиСертификатПроверкаВходящихПараметров(Сертификат)
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"ХранилищеСертификатов.НайтиСертификат", 
		"Сертификат",
		Сертификат, 
		Новый ОписаниеТипов("Структура, ФиксированнаяСтруктура")
	);
	
	Если Сертификат.Свойство("Отпечаток") Тогда
		ТипыСвойствСертификат = Новый Структура;
		ТипыСвойствСертификат.Вставить("Отпечаток", Новый ОписаниеТипов("Строка, ДвоичныеДанные"));
	Иначе
		ТипыСвойствСертификат = Новый Структура;
		ТипыСвойствСертификат.Вставить("СерийныйНомер", Новый ОписаниеТипов("Строка, ДвоичныеДанные"));
		ТипыСвойствСертификат.Вставить("Издатель", Новый ОписаниеТипов("Строка, Структура, ФиксированнаяСтруктура"));
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"ХранилищеСертификатов.НайтиСертификат", 
		"Сертификат",
		Сертификат, 
		Новый ОписаниеТипов("Структура, ФиксированнаяСтруктура"),
		ТипыСвойствСертификат
	);
	
КонецПроцедуры

Функция РазобратьСтрокуИздателя(ИздательСтрокой)
	
	Составляющие = Новый Соответствие;
	
	ПодстрокаДляРазбора = ИздательСтрокой;
	
	ИндексРавно = СтрНайти(ПодстрокаДляРазбора, "=", НаправлениеПоиска.СКонца);
	Пока ИндексРавно Цикл
		Значение = Сред(ПодстрокаДляРазбора, ИндексРавно + 1);
		Если Прав(Значение, 1) = "," Тогда
			СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Значение);
		КонецЕсли;
		
		ПодстрокаДляРазбора = Лев(ПодстрокаДляРазбора, ИндексРавно - 1);
		
		ИндексЗапятая = СтрНайти(ПодстрокаДляРазбора, ",", НаправлениеПоиска.СКонца);
		Если ИндексЗапятая Тогда
			Ключ = Сред(ПодстрокаДляРазбора, ИндексЗапятая + 1);
			ПодстрокаДляРазбора = Лев(ПодстрокаДляРазбора, ИндексЗапятая);
		Иначе
			Ключ = ПодстрокаДляРазбора;	
		КонецЕсли;
		ИндексРавно = СтрНайти(ПодстрокаДляРазбора, "=", НаправлениеПоиска.СКонца);
		
		Составляющие.Вставить(СокрЛП(Ключ), СокрЛП(Значение));
	КонецЦикла;
	
	Возврат Составляющие;	
	
КонецФункции

Процедура ДобавитьПроверкаВходящихПараметров(Сертификат, ТипХранилища)
		
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"ХранилищеСертификатов.Добавить", 
		"Сертификат",
		Сертификат, 
		Новый ОписаниеТипов("ДвоичныеДанные, Строка"));
		
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"ХранилищеСертификатов.Добавить", 
		"ТипХранилища",
		ТипХранилища, 
		Новый ОписаниеТипов("ПеречислениеСсылка.ТипХранилищаСертификатов"));
		
	Если ТипЗнч(Сертификат) = Тип("Строка") Тогда
		ОбщегоНазначенияКлиентСервер.Проверить(
			ЭтоАдресВременногоХранилища(Сертификат),
			НСтр("ru = 'Недопустимое значение параметра Сертификат (указан адрес, который не является адресом временного хранилища)';
				|en = 'Invalid value of the Certificate parameter (specified address is not a temporary storage address)'"), 
			"ХранилищеСертификатов.Добавить");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти