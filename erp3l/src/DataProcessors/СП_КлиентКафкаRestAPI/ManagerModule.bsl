#Область ПрограммныйИнтерфейс

// Создать новый объекта клиента Kafka
// 
// Параметры:
//  Брокеры - ТаблицаЗначений - Брокеры
//  ПараметрыКонфигурации - ТаблицаЗначений - Параметры конфигурации
//  Таймаут - Число - Таймаут
// 
// Возвращаемое значение:
//  ОбработкаОбъект.СП_КлиентКафка - Новый объект
//
Функция НовыйОбъект(Брокеры, ПараметрыКонфигурации, Знач Таймаут = 10000) Экспорт

	КлиентКафка = Обработки.СП_КлиентКафкаRestAPI.Создать();
	КлиентКафка.Таймаут = Таймаут;
	КлиентКафка.Брокеры.Загрузить(Брокеры);
	КлиентКафка.ПараметрыКонфигурации.Загрузить(ПараметрыКонфигурации);
	
	Возврат КлиентКафка;
	
КонецФункции

#КонецОбласти