
#Область ПрограммныйИнтерфейс
	
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// В процедуре определяются возможные связи аналитик статей бюджетов
//
// Параметры:
//  ПараметрыСвязейАналитик  - Соответствие - соответствие <Тип> - (Структура: <"ИмяРеквизита"> - <ТипРеквизита>)
//                 
Процедура ПараметрыСвязейАналитик(ПараметрыСвязейАналитик) Экспорт

	//// Пример добавления связей
	//ДопСвязи = Новый Структура;
	//ДопСвязи.Вставить("Организация", Тип("СправочникСсылка.Организации"));
	//ДопСвязи.Вставить("Контрагент", Тип("СправочникСсылка.Контрагенты"));
	//ДопСвязи.Вставить("ВидДоговораУХ", Тип("СправочникСсылка.ВидДоговораУХ"));
	//ДопСвязи.Вставить("ВалютаВзаиморасчетов", Тип("СправочникСсылка.Валюты"));
	//
	//ПараметрыСвязейАналитик.Вставить(Тип("СправочникСсылка.ДоговорыКонтрагентов"), ДопСвязи);
	
КонецПроцедуры // ПараметрыСвязейАналитик()

#КонецОбласти

