
#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьПараметрыБюджетов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПараметрыОперативногоПланирования.ВидБюджета КАК ВидБюджета,
	|	ПараметрыОперативногоПланирования.Использовать КАК Использовать,
	|	ПараметрыОперативногоПланирования.ВидБюджета.ТипЗначения КАК ТипЗначения
	|ИЗ
	|	РегистрСведений.ПараметрыОперативногоПланирования КАК ПараметрыОперативногоПланирования";
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(Запрос.Выполнить().Выгрузить());
	
КонецФункции

#КонецОбласти

