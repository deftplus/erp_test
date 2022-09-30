////////////////////////////////////////////////////////////////////////////////
// Электронный документооборот с ФСС.
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

// Получение от веб-сервису ФСС и расшифровка, проверка подписи листка нетрудоспособности.
//
// Параметры:
//  ВыполняемоеОповещение       - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат                            - Структура:
//      * ПодписьВалидна                     - Булево - результат проверки подписи.
//      * АдресРасшифрованногоОтветаSOAP     - Строка - адрес во временном хранилище незашифрованного ответа SOAP от веб-сервиса ФСС.
//                                         - Неопределено - при ошибке.
//
//  ЗапросДляПолученияЭЛН - Структура:
//    * Организация             - СправочникСсылка.Организации - организация, сертификатом которой для ФСС подписывать.
///   * РегистрационныйНомерФСС - Строка - регистрационный номер организации в ФСС.
//    * ТекстXML                - Строка - XML запроса SOAP операции с листком нетрудоспособности без подписи.
//
Процедура ПолучитьДанныеЭЛНИзФСС(ВыполняемоеОповещение, ЗапросДляПолученияЭЛН) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", 	ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("ЗапросДляПолученияЭЛН", 	ЗапросДляПолученияЭЛН);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПолучитьДанныеЭЛНИзФССПослеПолученияКонтекста",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент,
		ДополнительныеПараметры);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

// Подписание, шифрование, отправка на веб-сервису ФСС реестра электронных листков нетрудоспособности и получение результатов.
//
// Параметры:
//  ВыполняемоеОповещение   - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат                            - Структура:
//      * ПодписьВалидна                     - Булево - результат проверки подписи.
//      * АдресРасшифрованногоОтветаSOAP     - Строка - адрес во временном хранилище незашифрованного ответа SOAP от веб-сервиса ФСС.
//                                         - Неопределено - при ошибке.
//
//  ВыгрузкаРеестраДанныхЭЛН - Структура:
//    * Организация             - СправочникСсылка.Организации - организация, сертификатом которой для ФСС подписывать.
//    * РегистрационныйНомерФСС - Строка - регистрационный номер организации в ФСС.
//    * ТекстXML                - Строка - XML выгрузки реестра ЭЛН.
//
Процедура ОтправитьВыгрузкуРеестраДанныхЭЛНВСервисФСС(
		ВыполняемоеОповещение,
		ВыгрузкаРеестраДанныхЭЛН) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", 		ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("ВыгрузкаРеестраДанныхЭЛН", 	ВыгрузкаРеестраДанныхЭЛН);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОтправитьВыгрузкуРеестраДанныхЭЛНВСервисФССПослеПолученияКонтекста",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент,
		ДополнительныеПараметры);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

// Устарела. Используется в составе ОтправитьВыгрузкуРеестраДанныхЭЛНВСервисФСС.
// Получение адреса подписанного, зашифрованного запроса к веб-сервису ФСС для отправки реестра листков нетрудоспособности.
//
// Параметры:
//  ВыполняемоеОповещение   - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат               - Строка - адрес во временном хранилище подписанного или подписанного и зашифрованного запроса SOAP
//                                       к веб-сервису ФСС.
//                              Неопределено - при ошибке.
//
//  ОрганизацияСсылка       - СправочникСсылка.Организации - организация, сертификатом которой для ФСС подписывать.
//
//  РегистрационныйНомерФСС - Строка - регистрационный номер ФСС.
//
//  ВыгрузкаЭЛН             - Строка - XML выгрузки ЭЛН.
//
//  ЗашифроватьSOAP         - Булево - если Истина, запрос будет подписан и зашифрован, иначе только подписан.
//
Процедура АдресПодписанногоSOAPЗагрузкиЭЛНВФСС(
		ВыполняемоеОповещение,
		ОрганизацияСсылка,
		РегистрационныйНомерФСС,
		ВыгрузкаЭЛН,
		ЗашифроватьSOAP = Истина) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", 	ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("ОрганизацияСсылка", 		ОрганизацияСсылка);
	ДополнительныеПараметры.Вставить("РегистрационныйНомерФСС", РегистрационныйНомерФСС);
	ДополнительныеПараметры.Вставить("ВыгрузкаЭЛН", 			ВыгрузкаЭЛН);
	ДополнительныеПараметры.Вставить("ЗашифроватьSOAP", 		ЗашифроватьSOAP);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"АдресПодписанногоSOAPЗагрузкиЭЛНВФССПослеПолученияКонтекста",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент,
		ДополнительныеПараметры);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

// Устарела. Используется в составе ПолучитьДанныеЭЛНИзФСС.
// Получение адреса подписанного, зашифрованного запроса к веб-сервису ФСС для выполнения операции с листком нетрудоспособности
// (получения ЭЛН, прекращения действия ЭЛН).
//
// Параметры:
//  ВыполняемоеОповещение       - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат                   - Строка - адрес во временном хранилище подписанного или подписанного и зашифрованного запроса SOAP
//                                           к веб-сервису ФСС.
//                                  Неопределено - при ошибке.
//
//  ОрганизацияСсылка           - СправочникСсылка.Организации - организация, сертификатом которой для ФСС подписывать.
//
//  ВыгрузкаЗапросаОперацииСЭЛН - Строка - XML запроса SOAP операции с листком нетрудоспособности без подписи.
//
//  ЗашифроватьSOAP             - Булево - если Истина, запрос будет подписан и зашифрован, иначе только подписан.
//
Процедура АдресПодписанногоSOAPОперацииСЭЛНВФСС(
		ВыполняемоеОповещение,
		ВыгрузкаЗапросаОперацииСЭЛН,
		ЗашифроватьSOAP = Истина) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", 			ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("ВыгрузкаЗапросаОперацииСЭЛН", 	ВыгрузкаЗапросаОперацииСЭЛН);
	ДополнительныеПараметры.Вставить("ЗашифроватьSOAP", 				ЗашифроватьSOAP);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"АдресПодписанногоSOAPОперацииСЭЛНВФССПослеПолученияКонтекста",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент,
		ДополнительныеПараметры);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

// Устарела. Используется в составе ПолучитьДанныеЭЛНИзФСС и ОтправитьВыгрузкуРеестраДанныхЭЛНВСервисФСС.
// Получение адреса расшифрованного ответа веб-сервиса ФСС на запрос операции с листком нетрудоспособности, а также результатов
// проверки подписи ответа.
//
// Параметры:
//  ВыполняемоеОповещение                - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат                            - Структура:
//      * ПодписьВалидна                     - Булево - результат проверки подписи.
//      * АдресРасшифрованногоОтветаSOAP     - Строка - адрес во временном хранилище незашифрованного ответа SOAP от веб-сервиса ФСС.
//                                         - Неопределено - при ошибке.
//
//  ОрганизацияСсылка                    - СправочникСсылка.Организации - организация, сертификатом которой для ФСС расшифровывать.
//
//  АдресПодписанногоОтветаSOAP          - Строка - адрес во временном хранилище SOAP подписанного или подписанного и зашифрованного
//                                                  ответа SOAP от веб-сервиса ФСС.
//
//  РасшифроватьSOAP                     - Булево - если Истина, будет выполнена дешифрация и проверка подписи, иначе только проверка
//                                                  подписи.
//
Процедура ПроверитьПодписьSOAPОтветаЭЛНВФСС(
		ВыполняемоеОповещение,
		ОрганизацияСсылка,
		АдресПодписанногоОтветаSOAP,
		РасшифроватьSOAP = Истина) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", 			ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("ОрганизацияСсылка", 				ОрганизацияСсылка);
	ДополнительныеПараметры.Вставить("АдресПодписанногоОтветаSOAP", 	АдресПодписанногоОтветаSOAP);
	ДополнительныеПараметры.Вставить("РасшифроватьSOAP", 				РасшифроватьSOAP);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПроверитьПодписьSOAPОтветаЭЛНВФССПослеПолученияКонтекста",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент,
		ДополнительныеПараметры);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#Область СЭДОФСС

// Получает данные входящих сообщений СЭДО ФСС.
// Параметры:
//  ОповещениеОбратногоВызова       - ОписаниеОповещения - описание процедуры, принимающей результат:
//    Результат                     -  Структура:
//      * БылиОшибки           - Булево - если Истина, то при выполнении операции возникали ошибки.
//      * ОшибкиПоОрганизациям - Соответствие - возвращаются массивы описаний ошибок в разрезе по организациям.
//      * ДанныеСообщенийПоОрганизациям - Соответствие - ключ соответствия организация, значение - массив структур с полями:
//        * Идентификатор          - Строка - идентификатор сообщения.
//        * Тип                    - Число  - тип сообщения согласно спецификации.
//        * Получатель             - Строка - идентификатор получателя.
//        * ТребуетсяПодтверждение - Булево - требуется подтверждение о прочтении сообщения.
//        * Содержимое             - Строка - текстовое содержимое сообщения.
//        * Новое                  - Булево - признак того, что это это новое сообщение, данные которого ещё не были загружены.
//      * РезультатыПоОрганизациям - Соответствие - ключ соответствия организация, значение - массив структур с полями:
//        * Выполнено            - Булево - признак успешного выполнения операции.
//        * ОписаниеОшибки       - Строка - содержит описание ошибки в случае, если Выполнено установлено в Ложь.
//        * ДанныеСообщения      - Структура - см. описание структуры ДанныеСообщенийПоОрганизациям.
//        * Идентификатор        - Строка - идентификатор сообщения.
//  Организации - Массив - массив организаций, по которым нужно получить сообщения.
//
Процедура ПолучитьВходящиеСообщенияСЭДОФСС(ОповещениеОбратногоВызова,
		Организации) Экспорт
		
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеОбратногоВызова", ОповещениеОбратногоВызова);
	ДополнительныеПараметры.Вставить("Организации", Организации);
		
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПолучитьВходящиеСообщенияСЭДОФССПослеПолученияКонтекста",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент,
		ДополнительныеПараметры);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

// Получает список входящих сообщений для организаций-страхователей с сервера СЭДО ФСС.
//
// Параметры:
//  ОповещениеОбратногоВызова       - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат                            - Структура:
//      * Выполнено         - Булево - признак успешного выполнения операции.
//      * ОписаниеОшибки    - Строка - содержит описание ошибки в случае, если Выполнено установлено в Ложь.
//      * ДанныеСообщенийПоОрганизациям   - Соответствие - соответствие организаций данным сообщений.
//        * Ключ     - СправочникСсылка.Организации - организация, для который были получены данные сообщений. 
//        * Значение - Массив - массив структур с данными сообщений:
//          * Идентификатор          - Строка - идентификатор сообщения.
//          * Тип                    - Число  - тип сообщения согласно спецификации.
//          * Получатель             - Строка - идентификатор получателя.
//          * ТребуетсяПодтверждение - Булево - требуется подтверждение о прочтении сообщения.
//          * Новое                  - Булево - признак того, что это новое сообщение, данные которого ещё не были загружены.
//  Организации     - Массив - список организаций, для которых будет запрошен список сообщений.
//  ДатаСообщений  - Дата - дата, за которую будет возвращен список входящих сообщений.
//
Процедура ПолучитьМетаданныеВходящихСообщенийСЭДО(ОповещениеОбратногоВызова,
		Организации,
		ДатаСообщений = Неопределено) Экспорт
		
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеОбратногоВызова", ОповещениеОбратногоВызова);
	ДополнительныеПараметры.Вставить("Организации", Организации);
	ДополнительныеПараметры.Вставить("ДатаСообщений", ДатаСообщений);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"МетаданныеВходящихСообщенийСЭДОФССПослеПолученияКонтекста",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент,
		ДополнительныеПараметры);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

// Получает содержимое входящих сообщений для страхователя с сервера СЭДО ФСС.
//
// Параметры:
//  ОповещениеОбратногоВызова       - ОписаниеОповещения - описание процедуры, принимающей результат:
//    Результат  - Структура:
//      * БылиОшибки           - Булево - если Истина, то при выполнении операции возникали ошибки.
//      * Ошибки               - Массив - содержит описание ошибки в случае, если Выполнено установлено в Ложь.
//      * ДанныеСообщений   - Массив - массив структур с данными сообщений:
//          * Идентификатор          - Строка - идентификатор сообщения.
//          * Тип                    - Число - тип сообщения согласно спецификации.
//          * Получатель             - Строка - идентификатор получателя.
//          * Содержимое             - Строка - текстовое содержимое сообщения.
//          * ТребуетсяПодтверждение - Булево - требуется подтверждение о прочтении сообщения.
//      * РезультатыПолучения    - Массив - массив структур с полями:
//          * Выполнено            - Булево - признак успешного выполнения операции.
//          * ОписаниеОшибки       - Строка - содержит описание ошибки в случае, если Выполнено установлено в Ложь.
//          * ДанныеСообщения      - Структура - см. описание структуры ДанныеСообщений.
//          * Идентификатор        - Строка - идентификатор сообщения.
//  Организация             - СправочникСсылка.Организации - организация страхователь.
//  Идентификаторы          - Массив - массив строковых идентификаторов сообщений, которые требуется получить.
//
Процедура ПолучитьСообщенияСЭДО(ОповещениеОбратногоВызова,
		Организация,
		Идентификаторы) Экспорт
		
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеОбратногоВызова", ОповещениеОбратногоВызова);
	ДополнительныеПараметры.Вставить("Организация", Организация);
	ДополнительныеПараметры.Вставить("Идентификаторы", Идентификаторы);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПолучитьСообщенияСЭДОФССПослеПолученияКонтекста",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент,
		ДополнительныеПараметры);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

// Подписывает сотрудников на уведомления об изменении статусов ЭЛН в ФСС.
// Параметры:
//  ОповещениеОбратногоВызова       - ОписаниеОповещения - описание процедуры, принимающей результат:
//    Результат                     -  Структура:
//      * БылиОшибки           - Булево - если Истина, то при выполнении операции возникали ошибки.
//      * Ошибки               - Массив - содержит описания ошибок.
//      * РезультатыОперации   - Соответствие - результаты операции в разрезе организаций. Поля значения:
//         * Выполнено            - Булево - признак успешного выполнения операции.
//         * ОписаниеОшибки       - Строка - содержит описание ошибки в случае, если Выполнено установлено в Ложь.
//         * ИдентификаторЗапроса - Строка - идентификатор отправленного запроса.
//  СНИЛСыСотрудниковОрганизаций - Соответствие - СНИЛСы сотрудников в разрезе организаций.
//    * Ключ     - СправочникСсылка.Организации - организация.
//    * Значение - Массив - массив строк со СНИЛС сотрудников, значения СНИЛС должны содержать только цифры.
//  ПринудительноОткрепить - Булево - признак принудительно открепления сотрудников от предыдущего работодателя.
//
Процедура ПодписатьСотрудниковОрганизацийНаУведомленияПоЭЛН(ОповещениеОбратногоВызова,
		СНИЛСыСотрудниковОрганизаций,
		ПринудительноОткрепить = Истина) Экспорт

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеОбратногоВызова", ОповещениеОбратногоВызова);
	ДополнительныеПараметры.Вставить("СНИЛСыСотрудниковОрганизаций", СНИЛСыСотрудниковОрганизаций);
	ДополнительныеПараметры.Вставить("ПринудительноОткрепить", ПринудительноОткрепить);
	ДополнительныеПараметры.Вставить("Операция",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ВидОперацииСЭДОФССПодписать());
	ДополнительныеПараметры.Вставить("ТипСобытия",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ТипСобытияСЭДОФССИзменениеСостоянияЭЛН());
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПодписатьОтписатьСписокСНИСЛСЭДОФССПослеПолученияКонтекста",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент,
		ДополнительныеПараметры);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

// Отписывает сотрудников от уведомлений об изменении статусов ЭЛН в ФСС.
// Параметры:
//  ОповещениеОбратногоВызова       - ОписаниеОповещения - описание процедуры, принимающей результат:
//    Результат                     -  Структура:
//      * БылиОшибки           - Булево - если Истина, то при выполнении операции возникали ошибки.
//      * Ошибки               - Массив - содержит описания ошибок.
//      * РезультатыОперации   - Соответствие - результаты операции в разрезе организаций. Поля значения:
//         * Выполнено            - Булево - признак успешного выполнения операции.
//         * ОписаниеОшибки       - Строка - содержит описание ошибки в случае, если Выполнено установлено в Ложь.
//         * ИдентификаторЗапроса - Строка - идентификатор отправленного запроса.
//  СНИЛСыСотрудниковОрганизаций - Соответствие - СНИЛСы сотрудников в разрезе организаций.
//    * Ключ     - СправочникСсылка.Организации - организация.
//    * Значение - Массив - массив строк со СНИЛС сотрудников, значения СНИЛС должны содержать только цифры.
//
Процедура ОтписатьСотрудниковОрганизацийОтУведомленийПоЭЛН(ОповещениеОбратногоВызова,
		СНИЛСыСотрудниковОрганизаций) Экспорт

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеОбратногоВызова", ОповещениеОбратногоВызова);
	ДополнительныеПараметры.Вставить("СНИЛСыСотрудниковОрганизаций", СНИЛСыСотрудниковОрганизаций);
	ДополнительныеПараметры.Вставить("ПринудительноОткрепить", Ложь);
	ДополнительныеПараметры.Вставить("Операция",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ВидОперацииСЭДОФССОтписать());
	ДополнительныеПараметры.Вставить("ТипСобытия",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ТипСобытияСЭДОФССИзменениеСостоянияЭЛН());
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПодписатьОтписатьСписокСНИСЛСЭДОФССПослеПолученияКонтекста",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент,
		ДополнительныеПараметры);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

// Подписывает страхователя на уведомления об изменения статусов ЭЛН в ФСС.
// Для получения уведомлений требуется также подписка сотрудников (см. ПодписатьСотрудниковНаУведомленияПоЭЛН).
// Параметры:
//  ОповещениеОбратногоВызова       - ОписаниеОповещения - описание процедуры, принимающей результат:
//    Результат                     -  Структура:
//      * Выполнено            - Булево - признак успешного выполнения операции.
//      * ОписаниеОшибки       - Строка - содержит описание ошибки в случае, если Выполнено установлено в Ложь.
//      * ИдентификаторЗапроса - Строка - идентификатор отправленного запроса.
//  Организация             - СправочникСсылка.Организации - организация страхователь.
//
Процедура ПодписатьСтрахователяНаУведомленияПоЭЛН(ОповещениеОбратногоВызова,
		Организация) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеОбратногоВызова", ОповещениеОбратногоВызова);
	ДополнительныеПараметры.Вставить("Организация", Организация);
	ДополнительныеПараметры.Вставить("Операция",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ВидОперацииСЭДОФССПодписать());
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПодписатьОтписатьСтрахователяСЭДОФССПослеПолученияКонтекста",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент,
		ДополнительныеПараметры);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

// Отписывает страхователя от уведомлений об изменении статусов ЭЛН в ФСС.
// Параметры:
//  ОповещениеОбратногоВызова       - ОписаниеОповещения - описание процедуры, принимающей результат:
//    Результат                     -  Структура:
//      * Выполнено            - Булево - признак успешного выполнения операции.
//      * ОписаниеОшибки       - Строка - содержит описание ошибки в случае, если Выполнено установлено в Ложь.
//      * ИдентификаторЗапроса - Строка - идентификатор отправленного запроса.
//  Организация             - СправочникСсылка.Организации - организация страхователь.
//
Процедура ОтписатьСтрахователяОтУведомленийПоЭЛН(ОповещениеОбратногоВызова,
		Организация) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеОбратногоВызова", ОповещениеОбратногоВызова);
	ДополнительныеПараметры.Вставить("Организация", Организация);
	ДополнительныеПараметры.Вставить("Операция", "Отписать");
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПодписатьОтписатьСтрахователяСЭДОФССПослеПолученияКонтекста",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент,
		ДополнительныеПараметры);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

// Отправляет подтверждение о получении сообщений на сервер СЭДО ФСС.
//
// Параметры:
//  ОповещениеОбратногоВызова       - ОписаниеОповещения - описание процедуры, принимающей результат:
//    Результат  - Структура:
//      * Выполнено           - Булево - признак успешного выполнения операции.
//      * ОписаниеОшибки      - Строка - содержит описание ошибки в случае, если Выполнено установлено в Ложь.
//      * ИдентификаторЗапроса - Строка - идентификатор отправленного запроса.
//  Организация             - СправочникСсылка.Организации - организация страхователь.
//  ИдентификаторыСообщений  - Массив, Строка, УникальныйИдентификатор - идентификаторы сообщений, на которые будет отправлено подтверждение.
//  ПослеОтправкиПолучитьВходящие - Булево - если Истина, то после отправки подтверждений будут получены входящие сообщения.
//
Процедура ОтправитьПодтверждениеОПолученииСообщенийСЭДО(ОповещениеОбратногоВызова,
		Организация,
		ИдентификаторыСообщений,
		ПослеОтправкиПолучитьВходящие = Ложь) Экспорт
		
	Если ТипЗнч(ИдентификаторыСообщений) <> Тип("Массив") Тогда
		Идентификаторы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ИдентификаторыСообщений);
	Иначе
		Идентификаторы = ИдентификаторыСообщений;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеОбратногоВызова", ОповещениеОбратногоВызова);
	ДополнительныеПараметры.Вставить("Организация", Организация);
	ДополнительныеПараметры.Вставить("ИдентификаторыСообщений", Идентификаторы);
	ДополнительныеПараметры.Вставить("ПослеОтправкиПолучитьВходящие", ПослеОтправкиПолучитьВходящие);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПодтверждениеПрочтенияСообщенийСЭДОФССПослеПолученияКонтекста",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент,
		ДополнительныеПараметры);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

// Отправляет произвольное сообщение на сервер СЭДО ФСС.
//
// Параметры:
//  ОповещениеОбратногоВызова - ОписаниеОповещения - описание процедуры, принимающей результат:
//    Результат                    - Структура:
//      * Выполнено            - Булево - признак успешного выполнения операции.
//      * ОписаниеОшибки       - Строка - содержит описание ошибки в случае, если Выполнено установлено в Ложь.
//      * ИдентификаторЗапроса - Строка - идентификатор отправленного запроса.
//  ПараметрыСообщения             - Структура - параметры отправки сообщения со структурой, как формируется функцией
//                                               "ЭлектронныйДокументооборотСФСС.ПараметрыОтправитьСообщениеСЭДО"
//  ЗадаватьВопросОТестовомСервере - Булево    - показывать вопрос, если установлен тестовый режим,
//                                               по умолчанию Истина, в случае серии вызовов для непервого вызова
//                                               стоит задавать Ложь.
//
Процедура ОтправитьСообщениеСЭДО(
		ОповещениеОбратногоВызова,
		ПараметрыСообщения,
		ЗадаватьВопросОТестовомСервере = Истина) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеОбратногоВызова", 		ОповещениеОбратногоВызова);
	ДополнительныеПараметры.Вставить("ПараметрыСообщения", 				ПараметрыСообщения);
	ДополнительныеПараметры.Вставить("ЗадаватьВопросОТестовомСервере", 	ЗадаватьВопросОТестовомСервере);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОтправитьСообщениеСЭДОФССПослеПолученияКонтекста",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент,
		ДополнительныеПараметры);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти