#Область СлужебныйПрограммныйИнтерфейс

Функция ТипОбъектаФормата(Знач ИмяОбъектаФормата, Знач ПространствоИмен) Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПространствоИмен, ИмяОбъектаФормата);
	
КонецФункции

Функция СправочникКонфигурации(Знач ИмяСправочника) Экспорт
	
	СоответствиеСправочников = Новый Соответствие;
	ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьСоответствиеСправочников(СоответствиеСправочников);
	
	ИмяСправочника = СоответствиеСправочников.Получить(ИмяСправочника);
	Если ИмяСправочника = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Метаданные.Справочники.Найти(ИмяСправочника);
	
КонецФункции

#КонецОбласти

