#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Собирает структуру из текстов запросов для дальнейшей проверки даты запрета.
// 
// Параметры:
// 	Запрос - Запрос - Запрос по проверке даты запрета, можно установить параметры
// Возвращаемое значение:
// 	Структура - см. ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов
Функция ТекстЗапросаКонтрольДатыЗапрета(Запрос) Экспорт
	ИмяРегистра = Метаданные.РегистрыНакопления.ДенежныеДокументы.Имя;
	ИмяТаблицыИзменений = "ДвиженияДенежныеДокументыИзменение"; 
	СтруктураТекстовЗапросов = ПроведениеДокументов.ШаблонТекстЗапросаКонтрольДатыЗапрета(Запрос, 
		ИмяРегистра, 
		ИмяТаблицыИзменений, 
		"ФинансовыйКонтур");
	Возврат СтруктураТекстовЗапросов

КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Подразделение)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

//++ НЕ УТКА

// Заполняет параметры отражения движений регистра в финансовом учете
//
// Возвращаемое значение:
// 	см. МеждународныйУчетПоДаннымОстаточныхФинансовыхРегистров.ПараметрыОтраженияДвиженийВФинансовомУчете
//
Функция ПараметрыОтраженияДвиженийВФинансовомУчете() Экспорт
	
	ПараметрыОтражения = МеждународныйУчетПоДаннымОстаточныхФинансовыхРегистров.ПараметрыОтраженияДвиженийВФинансовомУчете();
	ПараметрыОтражения.ПутьКДаннымПодразделение = "Подразделение";
	ПараметрыОтражения.ПутьКДаннымМестоУчета = "Подразделение";
	ПараметрыОтражения.ПутьКДаннымВалюта = "ДенежныйДокумент.Валюта";
	ПараметрыОтражения.РесурсыУпр.Добавить("СуммаУпр");
	ПараметрыОтражения.РесурсыРегл.Добавить("СуммаРегл");
	ПараметрыОтражения.РесурсыВал.Добавить("Сумма");
	ПараметрыОтражения.РесурсыКоличество.Добавить("Количество");
	
	МетаданныеРегистра = СоздатьНаборЗаписей().Метаданные();
	МеждународныйУчетПоДаннымОстаточныхФинансовыхРегистров.ЗаполнитьПараметрыОтраженияПоМетаданнымРегистра(ПараметрыОтражения, МетаданныеРегистра);
	
	Возврат ПараметрыОтражения;
	
КонецФункции

//-- НЕ УТКА

#КонецОбласти

#КонецОбласти

#КонецЕсли