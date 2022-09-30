#Область СлужебныйПрограммныйИнтерфейс

// Выводит предупреждение с кратким текстом и кнопкой для просмотра подробных сведений.
//
// Параметры:
//   КраткийТекст   - Строка - Текст предупреждения.
//   ПодробныйТекст - Строка - Подробный текст, который выводится по нажатию на кнопку "Подробнее".
//                             Если не указан, то кнопка для просмотра подробных сведений тоже не выводится.
//   Заголовок      - Строка - Заголовок предупреждения.
//                             Если не указан, то выводится стандартный заголовок предупреждений 1С:Предприятия.
//
Процедура Предупредить(КраткийТекст, ПодробныйТекст = "", Заголовок = "") Экспорт
	Контекст = Новый Структура("Заголовок, ПодробныйТекст", Заголовок, ПодробныйТекст);
	
	Кнопки = Новый СписокЗначений;
	Если ЗначениеЗаполнено(ПодробныйТекст) И ПодробныйТекст <> КраткийТекст Тогда
		Кнопки.Добавить("Подробнее", НСтр("ru = 'Подробнее';
											|en = 'Details'"));
	КонецЕсли;
	Кнопки.Добавить(0, НСтр("ru = 'Закрыть';
							|en = 'Close'"));
	
	Обработчик = Новый ОписаниеОповещения("ПоказатьТекстЗавершение", ЭтотОбъект, Контекст);
	ПоказатьВопрос(Обработчик, КраткийТекст, Кнопки, , 0, Заголовок);
КонецПроцедуры

// Выводит многострочный текст с возможностью копирования в буфер обмена.
//
// Параметры:
//   ПодробныйТекст - Строка   - Текст для отображения.
//   Заголовок      - Строка   - Заголовок диалога.
//   Картинка       - Картинка - Картинка диалога.
//
Процедура ПоказатьПодробности(ПодробныйТекст, Заголовок = "", Картинка = Неопределено) Экспорт
	НастройкиДиалога = Новый Структура;
	НастройкиДиалога.Вставить("ПредлагатьБольшеНеЗадаватьЭтотВопрос", Ложь);
	НастройкиДиалога.Вставить("Картинка", Картинка);
	НастройкиДиалога.Вставить("ПоказыватьКартинку", Ложь);
	НастройкиДиалога.Вставить("МожноКопировать", Истина);
	НастройкиДиалога.Вставить("КнопкаПоУмолчанию", 0);
	НастройкиДиалога.Вставить("ВыделятьКнопкуПоУмолчанию", Ложь);
	НастройкиДиалога.Вставить("Заголовок", Заголовок);
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить(0, НСтр("ru = 'Закрыть';
							|en = 'Close'"));
	
	Обработчик = Новый ОписаниеОповещения("ПоказатьТекстЗавершение", ЭтотОбъект, Неопределено);
	СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(Обработчик, ПодробныйТекст, Кнопки, НастройкиДиалога);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Продолжение процедур ПоказатьКраткийТекст и ПоказатьПодробныйТекст.
Процедура ПоказатьТекстЗавершение(Ответ, Контекст) Экспорт
	Если Ответ = "Подробнее" Тогда
		ПоказатьПодробности(Контекст.ПодробныйТекст, ?(ЗначениеЗаполнено(Контекст.Заголовок), Контекст.Заголовок, НСтр("ru = 'Подробнее';
																														|en = 'Details'")));
	КонецЕсли;
КонецПроцедуры

#КонецОбласти