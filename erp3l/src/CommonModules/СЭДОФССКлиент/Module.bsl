#Область ПрограммныйИнтерфейс

// Открывает форму настроек организации в части социального ЭДО.
//
// Параметры:
//   Организация - СправочникСсылка.Организации - Организация, для которой необходимо показать настройки.
//
Процедура ОткрытьНастройкиОрганизации(Организация) Экспорт
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат;
	КонецЕсли;
	Страхователи = СЭДОФССВызовСервера.СтрахователиОрганизаций(Организация);
	Если Страхователи.Количество() <> 1 Тогда
		Возврат;
	КонецЕсли;
	Страхователь = Страхователи[0];
	// АПК:278-выкл Базовые подсистемы могут условно вызывать расширенные.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыРасширеннаяПодсистемы.ПособияСоциальногоСтрахования") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("СЭДОФССРасширенныйКлиент");
		Модуль.ОткрытьНастройкиПолученияУведомленийОбЭЛН(Страхователь);
	Иначе
		ВызватьИсключение НСтр("ru = 'В программе отсутствует возможность получения сообщений ФСС об изменении состояний ЭЛН.';
								|en = 'The application cannot receive SSF messages about ESLR status changes.'");
	КонецЕсли;
	// АПК:278-вкл
КонецПроцедуры

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

#Область ИменаСобытийШироковещательныхОповещений

// Возвращает имя оповещения форм, вызываемого после получения сообщений СЭДО от ФСС.
//
// Возвращаемое значение:
//   Строка
//
Функция ИмяСобытияПослеПолученияСообщенийОтФСС() Экспорт
	Возврат "ПослеПолученияСообщенийСЭДОФСС";
КонецФункции

// Возвращает имя оповещения форм, вызываемого после отправки подтверждения получения документов СЭДО ФСС.
//
// Возвращаемое значение:
//   Строка
//
Функция ИмяСобытияПослеОтправкиПодтвержденияПолучения() Экспорт
	Возврат "ПослеОтправкиПодтвержденияПолученияСообщенийСЭДОФСС";
КонецФункции

#КонецОбласти

#Область Обмен

// Получает сообщения ФСС.
//   После получения вызывается событие с именем, возвращаемым функцией ИмяСобытияПослеПолученияСообщенийОтФСС().
//
// Параметры:
//   Организации - Неопределено, Массив из СправочникСсылка.Организации
//
Процедура ПолучитьСообщенияИзФСС(Организации = Неопределено, Форма = Неопределено) Экспорт
	ПрочитатьОрганизациюИзДанныхФормы(Организации, Форма);
	Страхователи = СЭДОФССВызовСервера.СтрахователиОрганизаций(Организации);
	Обработчик = Новый ОписаниеОповещения("ПослеПолученияСообщенийИзФСС", ЭтотОбъект);
	ЭлектронныйДокументооборотСФССКлиент.ПолучитьВходящиеСообщенияСЭДОФСС(Обработчик, Страхователи);
КонецПроцедуры

// Получает сообщения ФСС за период.
//   После получения вызывается событие с именем, возвращаемым функцией ИмяСобытияПослеПолученияСообщенийОтФСС().
//
// Параметры:
//   Организация - Неопределено, СправочникСсылка.Организации
//
Процедура ОткрытьФормуПолученияСообщенийЗаПериод(Организация = Неопределено, Форма = Неопределено) Экспорт
	ПрочитатьОрганизациюИзДанныхФормы(Организация, Форма);
	ПараметрыФормы = Новый Структура("Организация", Организация);
	НеИскатьФорму = Истина;
	ОткрытьФорму("Обработка.ОбщиеФормыСЭДОФСС.Форма.ПолучениеСообщенийЗаПериод", ПараметрыФормы, , НеИскатьФорму);
КонецПроцедуры

// Получает указанные сообщения ФСС.
//   После получения вызывается событие с именем, возвращаемым функцией ИмяСобытияПослеПолученияСообщенийОтФСС().
//
// Параметры:
//   ИдентификаторыСообщенийСтрахователей - Соответствие - Соообщения в разрезе страхователей:
//       * Ключ - СправочникСсылка.Организации - Страхователь
//       * Значение - Массив из Строка - Идентификаторы сообщений
//
Процедура ПовторноПолучитьСообщенияИзФСС(ИдентификаторыСообщенийСтрахователей) Экспорт
	Страхователи = Новый Массив;
	Для Каждого КлючИЗначение Из ИдентификаторыСообщенийСтрахователей Цикл
		Страхователи.Добавить(КлючИЗначение.Ключ);
	КонецЦикла;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Страхователи", Страхователи);
	Контекст.Вставить("ИдентификаторыСообщений", ИдентификаторыСообщенийСтрахователей);
	Контекст.Вставить("ТекущийИндекс", -1);
	Контекст.Вставить("Страхователь", Неопределено);
	Контекст.Вставить("ВГраница", Страхователи.ВГраница());
	Контекст.Вставить("Кратко", Новый Массив);
	Контекст.Вставить("Подробно", Новый Массив);
	Контекст.Вставить("ВозниклаОшибка", Ложь);
	
	ПродолжитьПовторноеПолучениеСообщенийИзФСС(Неопределено, Контекст);
КонецПроцедуры

// Отправляет подтверждения получения документов СЭДО ФСС.
//   После отправки вызывается событие с именем, возвращаемым функцией ИмяСобытияПослеОтправкиПодтвержденияПолучения().
//
// Параметры:
//   МассивСсылок - Массив из ДокументСсылка - У документов должны быть реквизиты:
//       * Страхователь - СправочникСсылка.Организации - Страхователь, получивший документ.
//       * ИдентификаторСообщения - Строка - Идентификатор входящего сообщения СЭДО.
//
Процедура ОтправитьПодтверждениеПолучения(МассивСсылок) Экспорт
	Если МассивСсылок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	Если МассивСсылок.Количество() > 1 Тогда
		Список = Новый СписокЗначений;
		Список.ЗагрузитьЗначения(МассивСсылок);
		Список.ЗаполнитьПометки(Истина);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Отмеченные", Список);
		ПараметрыФормы.Вставить("ЗначенияДляВыбора", Список);
		ПараметрыФормы.Вставить("ЗначенияДляВыбораЗаполнены", Истина);
		ПараметрыФормы.Вставить("ОграничиватьВыборУказаннымиЗначениями", Истина);
		ПараметрыФормы.Вставить("Представление", НСтр("ru = 'Отправка подтверждения получения в ФСС';
														|en = 'Sending confirmation of receipt to SSF'"));
		
		Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		Обработчик = Новый ОписаниеОповещения("ОтправитьПодтверждениеПолученияЗавершениеВыбора", ЭтотОбъект);
		
		ОткрытьФорму("ОбщаяФорма.ВводЗначенийСпискомСФлажками", ПараметрыФормы, ЭтотОбъект, , , , Обработчик, Режим);
	Иначе
		ОтправитьПодтверждениеПолученияВыбранных(МассивСсылок);
	КонецЕсли;
КонецПроцедуры

// Отправляет документы в ФСС.
//
// Параметры:
//   МассивСсылок - Массив - Массив ссылок документов СЭДО, которые необходимо отправить в ФСС.
//
Процедура ОтправитьДокументы(МассивСсылок) Экспорт
	Количество = МассивСсылок.Количество();
	Если Количество = 0 Тогда
		Возврат;
	ИначеЕсли Количество <= 8 Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Иначе
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
	КонецЕсли;
	ПараметрыФормы = Новый Структура("МассивСсылок", МассивСсылок);
	ОткрытьФорму("Обработка.ОбщиеФормыСЭДОФСС.Форма.ОтправкаДокументов", ПараметрыФормы, , , , , , РежимОткрытияОкна);
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область ПолучитьСообщенияИзФСС

Процедура ПослеПолученияСообщенийИзФСС(Результат, ПустойПараметр) Экспорт
	Если Результат.ОшибкиПоОрганизациям.Количество() > 0 Тогда
		ТекстыОшибок = Новый Массив;
		Для Каждого КлючИЗначение Из Результат.ОшибкиПоОрганизациям Цикл
			Текст = Строка(КлючИЗначение.Ключ) + ":" + Символы.ПС + СтрСоединить(КлючИЗначение.Значение, Символы.ПС);
			ТекстыОшибок.Добавить(Текст);
		КонецЦикла;
		ИнформированиеПользователяКлиент.ПоказатьПодробности(
			СтрСоединить(ТекстыОшибок, Символы.ПС + Символы.ПС + "----------" + Символы.ПС + Символы.ПС),
			НСтр("ru = 'Информация об ошибке';
				|en = 'Error details'"),
			БиблиотекаКартинок.Предупреждение32);
	КонецЕсли;
	Оповестить(ИмяСобытияПослеПолученияСообщенийОтФСС(), Результат);
КонецПроцедуры

Процедура ПрочитатьОрганизациюИзДанныхФормы(Организация, Форма)
	Если Организация <> Неопределено Или Форма = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Организация = ОбщегоНазначенияБЗККлиентСервер.ЗначениеСвойства(Форма, "Организация");
	Если Организация = Неопределено Тогда
		Организация = ОбщегоНазначенияБЗККлиентСервер.ЗначениеСвойства(Форма, "Объект.Организация");
	КонецЕсли;
	Если Организация = Неопределено Тогда
		Организация = ОбщегоНазначенияБЗККлиентСервер.ЗначениеСвойства(Форма, "Объект.ГоловнаяОрганизация");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ПовторноПолучитьСообщенияИзФСС

Процедура ПродолжитьПовторноеПолучениеСообщенийИзФСС(Результат, Контекст) Экспорт
	
	// Обработка результатов получения пакета сообщений очередного страхователя.
	Если Контекст.Страхователь <> Неопределено Тогда
		КоличествоОшибок = 0;
		Ошибки = Новый Массив;
		Если Результат <> Неопределено Тогда
			Для Каждого РезультатПолучения Из Результат.РезультатыПолучения Цикл
				Если ЗначениеЗаполнено(РезультатПолучения.ОписаниеОшибки) Тогда
					КоличествоОшибок = КоличествоОшибок + 1;
					Ошибки.Добавить(РезультатПолучения.ОписаниеОшибки);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		КоличествоСообщений = Контекст.ИдентификаторыСообщений[Контекст.Страхователь].Количество();
		Если КоличествоОшибок = 0 Тогда
			Если КоличествоСообщений = 0 Тогда
				КраткиеИтоги = НСтр("ru = 'Нет сообщений';
									|en = 'No messages'");
			Иначе
				КраткиеИтоги = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
					НСтр("ru = ';Успешно получено %1 сообщение;;Успешно получено %1 сообщения;Успешно получено %1 сообщений;';
						|en = ';Successfully received %1 message;;Successfully received %1 messages;Successfully received %1 messages;'"),
					КоличествоСообщений);
			КонецЕсли;
			Подробности = "";
		Иначе
			Контекст.ВозниклаОшибка = Истина;
			КраткиеИтоги = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
				НСтр("ru = ';%1 ошибка;;%1 ошибки;%1 ошибок;';
					|en = ';%1 error;;%1 errors;%1 errors;'"),
				КоличествоОшибок);
			Подробности = Символы.ПС + СтрСоединить(Ошибки, Символы.ПС);
		КонецЕсли;
		ЗаголовокСообщения = Строка(Контекст.Страхователь) + ": " + КраткиеИтоги;
		Контекст.Кратко.Добавить(ЗаголовокСообщения);
		Контекст.Подробно.Добавить(ЗаголовокСообщения + Подробности);
	КонецЕсли;
	
	// Переход к следующему сообщению.
	Контекст.ТекущийИндекс = Контекст.ТекущийИндекс + 1;
	
	// Возврат результата если сообщение уже отправлено.
	Если Контекст.ТекущийИндекс > Контекст.ВГраница Тогда
		ИнформированиеПользователяКлиент.Предупредить(
			СтрСоединить(Контекст.Кратко, Символы.ПС),
			СтрСоединить(Контекст.Подробно, Символы.ПС + Символы.ПС + "----------" + Символы.ПС + Символы.ПС),
			?(Контекст.ВозниклаОшибка, НСтр("ru = 'Информация об ошибке';
											|en = 'Error details'"), НСтр("ru = 'Результаты получения сообщений';
																				|en = 'Messages receiving results'")));
		Оповестить(ИмяСобытияПослеПолученияСообщенийОтФСС(), Результат);
		Возврат;
	КонецЕсли;
	
	// Отправка подтверждения получения сообщения.
	Контекст.Страхователь = Контекст.Страхователи[Контекст.ТекущийИндекс];
	Идентификаторы = Контекст.ИдентификаторыСообщений[Контекст.Страхователь];
	Если Идентификаторы.Количество() = 0 Тогда
		ПродолжитьПовторноеПолучениеСообщенийИзФСС(Неопределено, Контекст);
	Иначе
		Обработчик = Новый ОписаниеОповещения("ПродолжитьПовторноеПолучениеСообщенийИзФСС", ЭтотОбъект, Контекст);
		ЭлектронныйДокументооборотСФССКлиент.ПолучитьСообщенияСЭДО(Обработчик, Контекст.Страхователь, Идентификаторы);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОтправитьПодтверждениеПолучения

Процедура ОтправитьПодтверждениеПолученияЗавершениеВыбора(СписокСсылок, ПустойПараметр) Экспорт
	Если ТипЗнч(СписокСсылок) <> Тип("СписокЗначений") Тогда
		Возврат;
	КонецЕсли;
	МассивСсылок = Новый Массив;
	Для Каждого ЭлементСписка Из СписокСсылок Цикл
		Если ЭлементСписка.Пометка И МассивСсылок.Найти(ЭлементСписка.Значение) = Неопределено Тогда
			МассивСсылок.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	ОтправитьПодтверждениеПолученияВыбранных(МассивСсылок);
КонецПроцедуры

Процедура ОтправитьПодтверждениеПолученияВыбранных(МассивСсылок, Обработчик = Неопределено, ОшибкиВФормеПредупреждения = Истина) Экспорт
	Контекст = СЭДОФССВызовСервера.КонтекстОтправкиПодтвержденияПолучения(МассивСсылок);
	Контекст.Вставить("МассивСсылок", МассивСсылок);
	Контекст.Вставить("ТекущийИндекс", -1);
	Контекст.Вставить("ВГраница", Контекст.Страхователи.ВГраница());
	Контекст.Вставить("ТекстыОшибок", Новый Массив);
	Контекст.Вставить("Обработчик", Обработчик);
	Контекст.Вставить("ОшибкиВФормеПредупреждения", ОшибкиВФормеПредупреждения);
	
	ПродолжитьОтправкуПодтверждениеПолучения(Неопределено, Контекст);
КонецПроцедуры

Процедура ПродолжитьОтправкуПодтверждениеПолучения(РезультатОтправки, Контекст) Экспорт
	// Чтение результатов отправки.
	Если РезультатОтправки <> Неопределено Тогда
		Если ЗначениеЗаполнено(РезультатОтправки.ОписаниеОшибки) Тогда
			Контекст.ТекстыОшибок.Добавить(РезультатОтправки.ОписаниеОшибки);
		КонецЕсли;
	КонецЕсли;
	
	// Переход к следующему сообщению.
	Контекст.ТекущийИндекс = Контекст.ТекущийИндекс + 1;
	
	// Возврат результата если сообщение уже отправлено.
	Если Контекст.ТекущийИндекс > Контекст.ВГраница Тогда
		Успех = (Контекст.ТекстыОшибок.Количество() = 0);
		Если Не Успех Тогда
			Если Контекст.ВГраница = 0 Тогда
				Заголовок = НСтр("ru = 'Ошибки отправки подтверждения получения';
								|en = 'Errors occurred when sending receipt confirmation'");
			Иначе
				Заголовок = НСтр("ru = 'Ошибки отправки подтверждений получения';
								|en = 'Errors occurred when sending receipt confirmations'");
			КонецЕсли;
			Подробности = СтрСоединить(Контекст.ТекстыОшибок, Символы.ПС + Символы.ПС + "----------" + Символы.ПС + Символы.ПС);
			Ошибка = Новый Структура("Заголовок, Подробности", Заголовок, Подробности);
			Если Контекст.ОшибкиВФормеПредупреждения Тогда
				ПоказатьОшибкиОтправкиПодтвержденияПолучения(Ошибка);
			Иначе
				Если Контекст.ВГраница = 0 Тогда
					Текст = СтрШаблон(НСтр("ru = 'Подтверждение получения %1';
											|en = 'Receipt confirmation %1'"), Контекст.МассивСсылок[0]);
				Иначе
					Текст = СтрШаблон(НСтр("ru = 'Подтверждения получения (%1)';
											|en = 'Receipt confirmation (%1)'"), Контекст.ВГраница + 1);
				КонецЕсли;
				Если Контекст.ТекстыОшибок.Количество() = 1 Тогда
					Пояснение = НСтр("ru = 'Возникла ошибка';
									|en = 'An error occurred'");
				Иначе
					Пояснение = СтрШаблон(НСтр("ru = 'Возникли ошибки (%1)';
												|en = 'Errors occurred (%1)'"), Контекст.ТекстыОшибок.Количество());
				КонецЕсли;
				Обработчик = Новый ОписаниеОповещения("ПоказатьОшибкиОтправкиПодтвержденияПолучения", ЭтотОбъект, Ошибка);
				ПоказатьОповещениеПользователя(Текст, Обработчик, Пояснение, БиблиотекаКартинок.Предупреждение32);
			КонецЕсли;
		КонецЕсли;
		
		Если Контекст.Обработчик <> Неопределено Тогда
			Результат = Новый Структура("Успех, ТекстыОшибок", Успех, Контекст.ТекстыОшибок);
			ВыполнитьОбработкуОповещения(Контекст.Обработчик, Результат);
		КонецЕсли;
		Оповестить(ИмяСобытияПослеОтправкиПодтвержденияПолучения(), Контекст);
		Возврат;
	КонецЕсли;
	
	// Отправка подтверждения получения сообщения.
	Страхователь = Контекст.Страхователи[Контекст.ТекущийИндекс];
	Обработчик = Новый ОписаниеОповещения("ПродолжитьОтправкуПодтверждениеПолучения", ЭтотОбъект, Контекст);
	ЭлектронныйДокументооборотСФССКлиент.ОтправитьПодтверждениеОПолученииСообщенийСЭДО(
		Обработчик,
		Страхователь,
		Контекст.ИдентификаторыСообщенийСтрахователей[Страхователь]);
КонецПроцедуры

Процедура ПоказатьОшибкиОтправкиПодтвержденияПолучения(Ошибка) Экспорт
	ИнформированиеПользователяКлиент.ПоказатьПодробности(
		Ошибка.Подробности,
		Ошибка.Заголовок,
		БиблиотекаКартинок.Предупреждение32);
КонецПроцедуры

#КонецОбласти

#Область ИсходящиеДокументы

Процедура ПоказатьXMLИсходящихДокументов(МассивСсылок) Экспорт
	Контекст = СЭДОФССВызовСервера.КонтекстПросмотраXMLИсходящихДокументов(МассивСсылок);
	
	Если ЗначениеЗаполнено(Контекст.ТекстXML) Тогда
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.УстановитьТекст(Контекст.ТекстXML);
		ТекстовыйДокумент.Показать(Контекст.ИмяФайлаБезРасширения, Контекст.ИмяФайлаСРасширением);
	КонецЕсли;
	
	Если Контекст.Ошибка Тогда
		ИнформированиеПользователяКлиент.Предупредить(Контекст.Кратко, Контекст.Подробно);
	КонецЕсли;
КонецПроцедуры

Процедура СохранитьФайлИсходящихДокументов(МассивСсылок) Экспорт
	Контекст = СЭДОФССВызовСервера.КонтекстСохраненияФайловИсходящихДокументов(МассивСсылок);
	
	Обработчик = Новый ОписаниеОповещения("ПослеСохраненияФайлаИсходящихДокументов", ЭтотОбъект);
	
	Если Контекст.СохраняемыеФайлы.Количество() = 1 Тогда
		
		СохраняемыйФайл = Контекст.СохраняемыеФайлы[0];
		
		ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
		ПараметрыСохранения.Диалог.Заголовок = НСтр("ru = 'Выберите файл для сохранения документа СЭДО';
													|en = 'Select file to save the EDI document'");
		ПараметрыСохранения.Диалог.Фильтр    = НСтр("ru = 'Файлы XML (*.xml)|*.xml|Все файлы (*.*)|*';
													|en = 'XML files (*.xml)|*.xml|All files (*.*)|*'");
		ПараметрыСохранения.ТекстПредложения = НСтр("ru = 'Для сохранения файла рекомендуется установить расширение для веб-клиента 1С:Предприятие.';
													|en = 'To save the file, install 1C:Enterprise web client extension.'");
		
		ФайловаяСистемаКлиент.СохранитьФайл(Обработчик, СохраняемыйФайл.Хранение, СохраняемыйФайл.Имя, ПараметрыСохранения);
		
	ИначеЕсли Контекст.СохраняемыеФайлы.Количество() > 1 Тогда
		
		ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайлов();
		ПараметрыСохранения.Диалог.Заголовок = НСтр("ru = 'Каталог для сохранения документов СЭДО';
													|en = 'Directory for saving EDI documents'");
		ПараметрыСохранения.ТекстПредложения = НСтр("ru = 'Для сохранения файлов рекомендуется установить расширение для веб-клиента 1С:Предприятие.';
													|en = 'To save files, install 1C:Enterprise web client extension.'");
		
		ФайловаяСистемаКлиент.СохранитьФайлы(Обработчик, Контекст.СохраняемыеФайлы, ПараметрыСохранения);
		
	КонецЕсли;
	
	Если Контекст.Ошибка Тогда
		ИнформированиеПользователяКлиент.Предупредить(Контекст.Кратко, Контекст.Подробно);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеСохраненияФайлаИсходящихДокументов(ПолученныеФайлы, ПустойПараметр) Экспорт
	Если Не ЗначениеЗаполнено(ПолученныеФайлы) Тогда
		Возврат;
	КонецЕсли;
	
	ПолноеИмя = ПолученныеФайлы[0].ПолноеИмя;
	Если ПустаяСтрока(ПолноеИмя) Тогда
		Обработчик = Неопределено;
	Иначе
		Обработчик = Новый ОписаниеОповещения("ОткрытьПроводник", ФайловаяСистемаКлиент, ПолноеИмя);
	КонецЕсли;
	
	Количество = ПолученныеФайлы.Количество();
	Если Количество > 1 Тогда
		Заголовок = Неопределено;
		Текст = СтрШаблон(НСтр("ru = 'Файлы (%1) сохранены';
								|en = 'Files (%1) are saved'"), Количество);
	Иначе
		Заголовок = НСтр("ru = 'Файл сохранен';
						|en = 'File is saved'");
		Текст = ПолученныеФайлы[0].Имя;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(Заголовок, Обработчик, Текст, БиблиотекаКартинок.Успешно32);
КонецПроцедуры

#КонецОбласти

Процедура ПоказатьТекстXML(Идентификатор) Экспорт
	ТекстXML = СЭДОФССВызовСервера.ТекстXML(Идентификатор);
	Если Не ЗначениеЗаполнено(ТекстXML) Тогда
		ПоказатьОповещениеПользователя(
			,
			,
			НСтр("ru = 'Сообщение не найдено или недоступно по правам';
				|en = 'The message is not found or it is unavailable due to insufficient rights'"),
			БиблиотекаКартинок.Информация32);
		Возврат;
	КонецЕсли;
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(ТекстXML);
	ТекстовыйДокумент.ИспользуемоеИмяФайла = Идентификатор + ".xml";
	ТекстовыйДокумент.Показать(ТекстовыйДокумент.ИспользуемоеИмяФайла, ТекстовыйДокумент.ИспользуемоеИмяФайла);
КонецПроцедуры

#КонецОбласти
