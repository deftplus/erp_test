
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП.
//
// Возвращаемое значение:
//	Массив - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Завершен");
	Возврат Результат;
	
КонецФункции

#Область ПодключаемыеКоманды

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Команда = Отчеты.СтруктураЗатратНаКапитализацию.ДобавитьКомандуОтчета(КомандыОтчетов);
	Если Команда <> Неопределено Тогда
		Команда.ВидимостьВФормах = "ФормаЭлемента, ФормаСписка";
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли