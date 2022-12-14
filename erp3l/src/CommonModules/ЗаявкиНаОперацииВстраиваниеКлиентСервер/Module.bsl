#Область ПрограммныйИнтерфейс

#Область УправлениеРеквизитамиОбъектов

//Процедура изменяет структуру реквизитов договора в связи с особенностями решения
Процедура СтруктураРеквизитовДоговораРешения(СтруктураРеквизитов, ДоговорТип) Экспорт
	
	СтруктураРеквизитов.Контрагент = "Владелец";
	// Дополнительные реквизиты договора
	СтруктураРеквизитов.Вставить("РасчетыВУсловныхЕдиницах");
	СтруктураРеквизитов.Вставить("РасчетыВУсловныхЕдиницахВалюта");
	
КонецПроцедуры

// Процедура вносит изменения в описание реквизитов платежной позиции для текущего решения
Процедура СтруктураПараметровПлатежнойПозицииРешения(СтруктураПараметров) экспорт
	
	
КонецПроцедуры

// Процедура вносит изменения в описание доп.реквизитов платежной позиции
Процедура СтруктураДопРеквизитовПлатежнойПозицииРешения(СтруктураРеквизитов, ЭтоТехОперация) экспорт
	
	Если ЭтоТехОперация Тогда
		СтруктураРеквизитов.Вставить("ОрганизацияПолучатель");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти 