#Область ПрограммныйИнтерфейс
// Функция - ЦФО, Проект по документу планирования
//
// Параметры:
//  ДокументПланирования - ОпределяемыйТип.ДокументПланированияСписанияДС 
// 
// Возвращаемое значение:
//   - Структура - ЦФО, Проект
//
Функция ЦФОПроектПоДокументуПланирования(ДокументПланирования) Экспорт
	
	Результат = Новый Структура("ЦФО, Проект");
	
	Если НЕ ЗначениеЗаполнено(ДокументПланирования) Тогда
		Возврат Результат;
	КонецЕсли;
	
	МетДокумента = ДокументПланирования.Метаданные();
	
	СтруктураРеквизитов = Новый Структура;
	
	// ЦФО
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ОсновнойЦФО", МетДокумента) Тогда
		СтруктураРеквизитов.Вставить("ЦФО", "ОсновнойЦФО");
	ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("ЦФО", МетДокумента) Тогда
		СтруктураРеквизитов.Вставить("ЦФО");
	КонецЕсли;
	
	// Проект
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ОсновнойПроект", МетДокумента) Тогда
		СтруктураРеквизитов.Вставить("Проект", "ОсновнойПроект");
	ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("Проект", МетДокумента) Тогда
		СтруктураРеквизитов.Вставить("Проект");
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(СтруктураРеквизитов) Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументПланирования, СтруктураРеквизитов);
		ЗаполнитьЗначенияСвойств(Результат, ЗначенияРеквизитов);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти