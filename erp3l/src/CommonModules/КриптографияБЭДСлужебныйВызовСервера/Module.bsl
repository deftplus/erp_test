
#Область СлужебныеПроцедурыИФункции

// Проверяет возможность использования сертификатов пользователя в облачном сервисе.
//
// Возвращаемое значение:
//  Булево - использование сертификатов пользователя в облачном сервисе возможно.
//
Функция ИспользованиеСертификатовОблачногоСервисаВозможно() Экспорт
	
	ИспользованиеВозможно = КриптографияБЭДСлужебный.ИспользованиеСертификатовОблачногоСервисаВозможно();
	
	Возврат ИспользованиеВозможно;
	
КонецФункции

Функция ДоступныеСертификаты(РезультатыПолученияОтпечатков, ОшибкаПолученияОтпечатков = "") Экспорт
	
	ВидОперации = НСтр("ru = 'Получение доступных сертификатов для электронного документооборота';
						|en = 'Receive available certificates for EDI'");
	
	РезультатыПолученияОтпечатков = КриптографияБЭД.ПолучитьОтпечаткиСертификатов(ВидОперации, Неопределено,
		РезультатыПолученияОтпечатков);
	
	КриптографияБЭД.ЕстьОшибкаПолученияОтпечатков(РезультатыПолученияОтпечатков, ОшибкаПолученияОтпечатков);
	
	ОтборСертификатов = КриптографияБЭД.НовыйОтборСертификатов();
	ОтборСертификатов.Отпечатки = "&Отпечатки";
	ЗапросСертификатов = КриптографияБЭД.ЗапросДействующихСертификатов("Сертификаты", ОтборСертификатов);
	
	Запросы = Новый Массив;
	Запросы.Добавить(ЗапросСертификатов);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Сертификаты.Ссылка
	|ИЗ
	|	Сертификаты КАК Сертификаты";
	ИтоговыйЗапрос = ОбщегоНазначенияБЭД.СоединитьЗапросы(Запрос, Запросы);
	
	ИтоговыйЗапрос.УстановитьПараметр("Отпечатки",
		КриптографияБЭД.ПолучитьВсеОтпечаткиСертификатов(РезультатыПолученияОтпечатков));
	РезультатЗапроса = ИтоговыйЗапрос.Выполнить();
	
	Сертификаты = Новый Массив;
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Сертификаты;
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Сертификаты.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
	
	Возврат Сертификаты;
	
КонецФункции

Функция ПолучитьДистрибутивCryptoProCSP(Параметры) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Получение дистрибутива CryptoPro CSP';
															|en = 'Get CryptoPro CSP distribution package'");
	ПараметрыВыполнения.ДополнительныйРезультат = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("КриптографияБЭДСлужебный.ПолучитьДистрибутивCryptoProCSP",
		Параметры, ПараметрыВыполнения);
	
КонецФункции

Функция РезультатПолученияДистрибутиваКриптопровайдера(ДлительнаяОперация, ИдентификаторФормы) Экспорт
	
	Результат = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
	
	ДанныеДистрибутива = Новый Структура;
	Если Результат.ПараметрыДистрибутива <> Неопределено И Результат.ПараметрыДистрибутива.Свойство("Дистрибутив") Тогда
		ДанныеДистрибутива.Вставить("НомерДистрибутива", "");
		ДанныеДистрибутива.Вставить("Версия", Результат.ПараметрыДистрибутива.Версия);
		ДанныеДистрибутива.Вставить("КонтрольнаяСумма", Результат.ПараметрыДистрибутива.КонтрольнаяСумма);
		
		Если Результат.ПараметрыДистрибутива.Свойство("СерийныйНомер") Тогда
			ДанныеДистрибутива.Вставить("СерийныйНомер", Результат.ПараметрыДистрибутива.СерийныйНомер);
		КонецЕсли;
		
		ОписаниеФайлов = Новый Массив;
		Для каждого Файл Из Результат.ПараметрыДистрибутива.Дистрибутив Цикл
			ОписаниеФайлов.Добавить(Новый ОписаниеПередаваемогоФайла(Файл.Имя,
			ПоместитьВоВременноеХранилище(Файл.ДвоичныеДанные, ИдентификаторФормы)));
		КонецЦикла;
		
		ДанныеДистрибутива.Вставить("Дистрибутив", ОписаниеФайлов);
	КонецЕсли;
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ДанныеДистрибутива", ДанныеДистрибутива);
	СтруктураВозврата.Вставить("КонтекстДиагностики", Результат.КонтекстДиагностики);
	
	Возврат СтруктураВозврата;
	
КонецФункции

// Находит существующий или создает новый элемент справочника СертификатыКлючейЭлектроннойПодписиИШифрования.
//
// Параметры:
//  ДвоичныеДанныеСертификата - ДвоичныеДанные - содержимое сертификата
//  Организация - СправочникСсылка.Организации
//  ИнформацияОПрограммеКриптографии - Строка - название криптосредства
//                                - СправочникСсылка.ПрограммыЭлектроннойПодписиИШифрования - ссылка на программу криптографии.
//
// Возвращаемое значение:
//  СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - ссылка на новый сертификат.
//
Функция НайтиСоздатьСертификатЭП(ДвоичныеДанныеСертификата, Организация, ИнформацияОПрограммеКриптографии = Неопределено) Экспорт
	
	Если ТипЗнч(ИнформацияОПрограммеКриптографии) = Тип("Строка")  Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		               |	ПрограммыЭлектроннойПодписиИШифрования.Ссылка
		               |ИЗ
		               |	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК ПрограммыЭлектроннойПодписиИШифрования
		               |ГДЕ
		               |	ПрограммыЭлектроннойПодписиИШифрования.ИмяПрограммы = &НазваниеПрограммыКриптографии";
		Запрос.УстановитьПараметр("НазваниеПрограммыКриптографии", ИнформацияОПрограммеКриптографии);
		УстановитьПривилегированныйРежим(Истина);
		Выборка = Запрос.Выполнить().Выбрать();
		УстановитьПривилегированныйРежим(Ложь);
		Если Выборка.Следующий() Тогда
			Программа = Выборка.Ссылка;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ИнформацияОПрограммеКриптографии) = Тип("СправочникСсылка.ПрограммыЭлектроннойПодписиИШифрования") Тогда
		Программа = ИнформацияОПрограммеКриптографии;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Организация", Организация);
	
	// Если в ИБ уже есть такой сертификат, и в нем заполнена программа криптографии, то не меняем программу,
	// т.к. он могла быть указана правильно вручную.
	СсылкаНаСертификат = ЭлектроннаяПодпись.СсылкаНаСертификат(ДвоичныеДанныеСертификата);
	Если НЕ ЗначениеЗаполнено(СсылкаНаСертификат)
		ИЛИ (ЗначениеЗаполнено(СсылкаНаСертификат)
				И НЕ ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаСертификат, "Программа"))) Тогда
		ДополнительныеПараметры.Вставить("Программа", Программа);
	КонецЕсли;
	
	Возврат ЭлектроннаяПодпись.ЗаписатьСертификатВСправочник(ДвоичныеДанныеСертификата, ДополнительныеПараметры);

КонецФункции

Функция НайтиПрограммыЭлектроннойПодписиИШифрования(ОписанияПрограмм) Экспорт
	
	ИменаПрограмм = Новый Массив;
	Для каждого Описание Из ОписанияПрограмм Цикл
		Если Описание.Установлена Тогда
			ИменаПрограмм.Добавить(Описание.ИмяПрограммы);
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Программы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК Программы
	|ГДЕ
	|	Программы.ИмяПрограммы В(&ИменаПрограмм)";
	Запрос.УстановитьПараметр("ИменаПрограмм", ИменаПрограмм);
	
	НайденныеПрограммы = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НайденныеПрограммы.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат НайденныеПрограммы;
	
КонецФункции

Функция ОписанияПрограммЭлектроннойПодписиИШифрования() Экспорт
	
	Возврат КриптографияБЭД.ОписанияПрограммЭлектроннойПодписиИШифрования();
	
КонецФункции

#КонецОбласти