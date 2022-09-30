
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИсходящийНомер) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	МАКСИМУМ(ПисьмоОбменСБанками.ИсходящийНомер) КАК ИсходящийНомер
		|ИЗ
		|	Документ.ПисьмоОбменСБанками КАК ПисьмоОбменСБанками
		|ГДЕ
		|	ПисьмоОбменСБанками.Организация = &Организация
		|	И ПисьмоОбменСБанками.Банк = &Банк";
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("Банк", Банк);
		Результат = Запрос.Выполнить().Выбрать();
		Если Результат.Следующий() И ЗначениеЗаполнено(Результат.ИсходящийНомер) Тогда
			ИсходящийНомер = Результат.ИсходящийНомер + 1;
		Иначе
			ИсходящийНомер = 1;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИдентификаторПереписки) Тогда
		ИдентификаторПереписки = Новый УникальныйИдентификатор
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторИсходногоПисьма)
		И ТипЗнч(Основание) = Тип("ДокументСсылка.ПисьмоОбменСБанками") Тогда
		ИдентификаторИсходногоПисьма = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "Идентификатор");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		Идентификатор = Новый УникальныйИдентификатор
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Статус <> Перечисления.СтатусыОбменСБанками.Черновик Тогда
		НаименованиеЗадания = НСтр("ru = '1С:ДиректБанк: Блокировка присоединенных файлов письма.';
									|en = '1C:DirectBank: Locking attached message files.'");
		Параметры = Новый Массив;
		Параметры.Добавить(Ссылка);
		ФоновыеЗадания.Выполнить(
			"ОбменСБанкамиСлужебный.ЗаблокироватьПрисоединенныеФайлыПисьма", Параметры, , НаименованиеЗадания);
	КонецЕсли;

КонецПроцедуры


#КонецОбласти

#КонецЕсли