
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает виды операций помощника регистрации сертификатов.
// 
// Возвращаемое значение:
// 	Структура:
// * Отправка - Строка
// * Подписание - Строка
// * РегистрацияНепривязанныхСертификатов - Строка
// * Прочее - Строка
Функция ОперацииПомощникаРегистрацииСертификатов() Экспорт
	
	Операции = Новый Структура;
	Операции.Вставить("Отправка", "Отправка");
	Операции.Вставить("Подписание", "Подписание");
	Операции.Вставить("РегистрацияНепривязанныхСертификатов", "РегистрацияНепривязанныхСертификатов");
	Операции.Вставить("Прочее", "Прочее");
	
	Возврат Операции;
	
КонецФункции

// Возвращает параметры регистрации сертификатов.
// 
// Возвращаемое значение:
// 	Структура:
// * Операция - Строка - представление текущей операции, возможные значения: "Подписание", "Отправка" или "Прочее"
// * Данные - Строка - Массив из Структура - ключи структуры - колонки таблицы значений
//            см. СинхронизацияЭДО.НоваяТаблицаУчетныхЗаписейБезСертификатов. Используется при виде операции "Подписание".
// * УчетныеЗаписи - Массив из Строка - учетные записи, у которых нет валидных сертификатов.
//                                      Используется при виде операции "Отправка" или "Прочее".
// * Сертификаты - Массив из СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
Функция НовыеПараметрыРегистрацииСертификатов() Экспорт
	
	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("Операция", "");
	ПараметрыРегистрации.Вставить("Данные", Новый Массив);
	ПараметрыРегистрации.Вставить("УчетныеЗаписи", Новый Массив);
	ПараметрыРегистрации.Вставить("Сертификаты", Новый Массив);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

// Возвращает описание учетной записи.
// 
// Возвращаемое значение:
// 	Структура:
// * Организация - ОпределяемыйТип.Организация
// * АдресОрганизации - Строка
// * АдресОрганизацииЗначение - Строка
// * Наименование - Строка
// * СпособОбмена - ПеречислениеСсылка.СпособыОбменаЭД
// * Идентификатор - Строка
// * Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
// * Оператор - Строка
// * КодНалоговогоОргана - Строка
// * Назначение - Строка
// * ПодробноеОписание - Строка
// * ПринятыУсловияИспользования - Булево
// * ПараметрыУведомлений - см. СервисЭДОКлиентСервер.НовыеПараметрыУведомлений
Функция НовоеОписаниеУчетнойЗаписи() Экспорт
	
	Данные = Новый Структура;
	Данные.Вставить("Организация", Неопределено);
	Данные.Вставить("АдресОрганизации", "");
	Данные.Вставить("АдресОрганизацииЗначение", "");
	Данные.Вставить("Наименование", "");
	Данные.Вставить("СпособОбмена", ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ПустаяСсылка"));
	Данные.Вставить("Идентификатор", "");
	Данные.Вставить("Сертификат", ПредопределенноеЗначение("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.ПустаяСсылка"));
	Данные.Вставить("Оператор", "");
	Данные.Вставить("КодНалоговогоОргана", "");
	Данные.Вставить("Назначение", "");
	Данные.Вставить("ПодробноеОписание", "");
	Данные.Вставить("ПринятыУсловияИспользования", Ложь);
	Данные.Вставить("ПараметрыУведомлений", СервисЭДОКлиентСервер.НовыеПараметрыУведомлений());
	
	Возврат Данные;
	
КонецФункции

#Область РаботаСОперациямиЭДО

// Возвращает описание операции подключения ЭДО.
//
// Параметры:
//  Параметры - Структура,Неопределено - см. НовыеПараметрыПодключенияЭДО. 
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура - описание операции ЭДО. См. НоваяОперацияЭДО.
//
Функция НоваяОперацияПодключенияЭДО(Знач Параметры = Неопределено) Экспорт
	
	НовыеПараметры = НовыеПараметрыПодключенияЭДО();
	Если ТипЗнч(Параметры) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(НовыеПараметры, Параметры);
	КонецЕсли;
	
	НовыеСлужебныеПараметры = НовыеСлужебныеПараметрыПодключенияЭДО();
	
	Результат = Новый Структура;
	Результат.Вставить("НомерЗаявки"                   , "");
	Результат.Вставить("ИдентификаторЭДО"              , "");
	Результат.Вставить("УчетнаяЗапись"                 , "");
	Результат.Вставить("ОбновленыПараметрыУведомлений" , Ложь);
	Результат.Вставить("ОбновленыДанныеАбонента"       , Ложь);
	
	Операция = НоваяОперацияЭДО("ПодключениеЭДО", НовыеПараметры, Результат, НовыеСлужебныеПараметры);
	
	Возврат Операция;
	
КонецФункции

// Возвращает описание операции обновления сертификата.
//
// Параметры:
//  Параметры - Структура,Неопределено - см. НовыеПараметрыОбновленияСертификата. 
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура - описание операции ЭДО. См. НоваяОперацияЭДО.
//
Функция НоваяОперацияОбновленияСертификата(Знач Параметры = Неопределено) Экспорт
	
	НовыеПараметры = НовыеПараметрыОбновленияСертификата();
	Если ТипЗнч(Параметры) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(НовыеПараметры, Параметры);
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("НовыйСертификат");
	
	Операция = НоваяОперацияЭДО("ОбновлениеСертификата", НовыеПараметры, Результат);
	
	Возврат Операция;
	
КонецФункции

// Возвращает структуру для определения параметров подключения ЭДО.
//
// Параметры:
//
// Возвращаемое значение:
//  Структура - параметры операции подключения ЭДО:
//   * Организация - ОпределяемыйТип.Организация - организация, которую следует подключить к ЭДО.
//   * АдресОрганизации - Строка - адрес организации.
//   * КодНалоговогоОргана - Строка - код налоговой инспекции, в которой зарегистрирована организация.
//   * Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - сертификат для регистрации у оператора ЭДО.
//   * ОператорЭДО - Строка - код оператора ЭДО.
//   * СпособОбменаЭД - ПеречислениеСсылка.СпособыОбменаЭД - способ обмена электронными документам.
//   * НаименованиеУчетнойЗаписи - Строка - наименование учетной записи.
//   * НазначениеУчетнойЗаписи - Строка - назначение учетной записи.
//   * ОписаниеУчетнойЗаписи - Строка - описание учетной записи.
//   * ПринятыУсловияИспользования - Булево - признак принятия условий использования сервиса.
//   * УведомлятьОСобытиях - Булево - признак необходимости отправки уведомлений на электронную почту.
//   * ЭлектроннаяПочтаДляУведомлений - Строка - электронная почта для уведомлений.
//   * УведомлятьОНовыхПриглашениях - Булево - признак необходимости отправки уведомлений о новых приглашениях.
//   * УведомлятьОбОтветахНаПриглашения - Булево - признак необходимости отправки уведомлений об ответах на приглашения.
//   * УведомлятьОНовыхДокументах - Булево - признак необходимости отправки уведомлений о новых документах.
//   * УведомлятьОНеОбработанныхДокументах - Булево - признак необходимости отправки уведомлений о не обработанных документах.
//   * УведомлятьОбОкончанииСрокаДействияСертификата - Булево - признак необходимости отправки уведомлений об окончании действия сертификата.
//
Функция НовыеПараметрыПодключенияЭДО() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Организация");
	Параметры.Вставить("АдресОрганизации", "");
	Параметры.Вставить("АдресОрганизацииЗначение", "");
	Параметры.Вставить("КодНалоговогоОргана", "");
	Параметры.Вставить("Сертификат");
	Параметры.Вставить("ОператорЭДО", "");
	Параметры.Вставить("СпособОбменаЭД");
	Параметры.Вставить("НаименованиеУчетнойЗаписи", "");
	Параметры.Вставить("НазначениеУчетнойЗаписи", "");
	Параметры.Вставить("ОписаниеУчетнойЗаписи", "");
	Параметры.Вставить("ПринятыУсловияИспользования", Ложь);
	Параметры.Вставить("УведомлятьОСобытиях", Ложь);
	Параметры.Вставить("ЭлектроннаяПочтаДляУведомлений", "");
	Параметры.Вставить("УведомлятьОНовыхПриглашениях", Ложь);
	Параметры.Вставить("УведомлятьОбОтветахНаПриглашения", Ложь);
	Параметры.Вставить("УведомлятьОНовыхДокументах", Ложь);
	Параметры.Вставить("УведомлятьОНеОбработанныхДокументах", Ложь);
	Параметры.Вставить("УведомлятьОбОкончанииСрокаДействияСертификата", Ложь);
	
	Возврат Параметры;
	
КонецФункции

// Возвращает структуру для определения параметров обновления сертификата.
//
// Параметры:
//
// Возвращаемое значение:
//  Структура - параметры операции подключения ЭДО:
//   * Организация - ОпределяемыйТип.Организация - организация, для которой выполняется обновление сертификата.
//   * Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - сертификат, который будет обновлен (заменен).
//   * НовыйСертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - сертификат, который будет добавлен в учетные записи ЭДО.
//
Функция НовыеПараметрыОбновленияСертификата() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Организация");
	Параметры.Вставить("Сертификат");
	Параметры.Вставить("НовыйСертификат");
	
	Возврат Параметры;
	
КонецФункции

// Возвращает признак корректности (заполненности) параметров операции подключения ЭДО.
//
// Параметры:
//  ОперацияЭДО - Структура - операция ЭДО. См. НоваяОперацияПодключенияЭДО.
//
// Возвращаемое значение:
//  Булево - параметры операции корректны (заполнены).
//
Функция ОперацияПодключенияЭДОКорректна(Знач ОперацияЭДО) Экспорт
	
	Результат = Истина;
	
	Параметры = ОперацияЭДО.Параметры;
	
	Если Не ЗначениеЗаполнено(Параметры.Организация) Тогда
		Результат = Ложь;
	ИначеЕсли Не ЗначениеЗаполнено(Параметры.АдресОрганизации) Тогда
		Результат = Ложь;
	ИначеЕсли Не ЗначениеЗаполнено(Параметры.КодНалоговогоОргана) Тогда
		Результат = Ложь;
	ИначеЕсли Параметры.УведомлятьОСобытиях И Не ЗначениеЗаполнено(Параметры.ЭлектроннаяПочтаДляУведомлений) Тогда
		Результат = Ложь;
	ИначеЕсли Не Параметры.ПринятыУсловияИспользования Тогда
		Результат = Ложь;
	ИначеЕсли Не ЗначениеЗаполнено(Параметры.ОператорЭДО) Тогда
		Результат = Ложь;
	ИначеЕсли Не ЗначениеЗаполнено(Параметры.СпособОбменаЭД) Тогда
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак корректности (заполненности) параметров операции обновления сертификата.
//
// Параметры:
//  ОперацияЭДО - Структура - операция ЭДО. См. НоваяОперацияОбновленияСертификата.
//
// Возвращаемое значение:
//  Булево - параметры операции корректны (заполнены).
//
Функция ОперацияОбновленияСертификатаКорректна(Знач ОперацияЭДО) Экспорт
	
	Результат = Истина;
	
	Параметры = ОперацияЭДО.Параметры;
	
	Если Не ЗначениеЗаполнено(Параметры.Организация) Тогда
		Результат = Ложь;
	ИначеЕсли Не ЗначениеЗаполнено(Параметры.Сертификат) Тогда
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РаботаСОперациямиЭДО

// Возвращает новую операцию ЭДО.
//
// Параметры:
//  Действие           - Строка - действие выполняемое операцией.
//  Параметры          - Произвольный - параметры операции. См. НовыеПараметрыПодключенияЭДО
//  Результат          - Произвольный - результат выполнения операции.
//  СлужебныеПараметры - Произвольный - служебные параметры операции.См. НовыеСлужебныеПараметрыПодключенияЭДО
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура - описание операции ЭДО:
//   * Действие           - Строка - действие выполняемое операцией.
//   * Параметры          - Произвольный - параметры операции.
//   * Результат          - Произвольный - результат выполнения операции.
//   * СлужебныеПараметры - Произвольный - служебные параметры операции.
//
Функция НоваяОперацияЭДО(Знач Действие, Знач Параметры = Неопределено, Знач Результат = Неопределено,
		Знач СлужебныеПараметры = Неопределено)
	
	Операция = Новый Структура;
	Операция.Вставить("Действие"           , Действие);
	Операция.Вставить("Параметры"          , Параметры);
	Операция.Вставить("Результат"          , Результат);
	Операция.Вставить("СлужебныеПараметры" , СлужебныеПараметры);
	
	Возврат Новый ФиксированнаяСтруктура(Операция);
	
КонецФункции

// Возвращает структуру для определения служебных параметров при подключении ЭДО.
//
// Параметры:
//
// Возвращаемое значение:
//  Структура - параметры операции подключения ЭДО:
//   * КонтекстДиагностики                 - Строка - контекст ошибки во время подключения.
//   * ПаролиСертификатов                 - см. КриптографияБЭД.НовыеПаролиСертификатов
//   * ОткрыватьФормуДлительнойОперации - Булево - признак открытия формы длительной операции
//
Функция НовыеСлужебныеПараметрыПодключенияЭДО()
	
	Параметры = Новый Структура;
	Параметры.Вставить("КонтекстДиагностики"             , "");
	Параметры.Вставить("ПаролиСертификатов"              , Неопределено);
	Параметры.Вставить("ОткрыватьФормуДлительнойОперации", Истина);
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти

#КонецОбласти