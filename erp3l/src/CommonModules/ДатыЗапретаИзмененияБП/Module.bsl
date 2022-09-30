////////////////////////////////////////////////////////////////////////////////
// Подсистема "Даты запрета изменения".
// Настройка переопределяемого модуля в конфигурации "Демо: БСП".
// 
// Реализация процедур и функций модуля ДатыЗапретаИзмененияПереопределяемый
// для поддержки библиотечного подхода разработки.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет изменить работу интерфейса при встраивании.
//
// Параметры:
//  НастройкиРаботыИнтерфейса - Структура - содержит свойство:
//   * ИспользоватьВнешнихПользователей - Булево - (начальное значение Ложь),
//     если установить Истина, тогда даты запрета можно будет настраивать для внешних пользователей.
//
Процедура НастройкаИнтерфейса(Знач НастройкиРаботыИнтерфейса) Экспорт
	
	НастройкиРаботыИнтерфейса.ИспользоватьВнешнихПользователей = Ложь;
	
КонецПроцедуры

// Позволяет задать таблицы и поля объектов для проверки запрета изменения данных.
// Для добавления нового источника в ИсточникиДанных см. ДатыЗапретаИзменения.ДобавитьСтроку.
//
// Вызывается из процедуры ИзменениеЗапрещено общего модуля ДатыЗапретаИзменения,
// используемой в подписке на событие ПередЗаписью объекта для проверки наличия
// запретов и отказа от изменений запрещенного объекта.
//
// Параметры:
//  ИсточникиДанных - ТаблицаЗначений - с колонками:
//   * Таблица     - Строка - полное имя объекта метаданных,
//                   например, Метаданные.Документы.ПриходнаяНакладная.ПолноеИмя().
//   * ПолеДаты    - Строка - имя реквизита объекта или табличной части,
//                   например "Дата", "Товары.ДатаОтгрузки".
//   * Раздел      - Строка - имя раздела дат запрета, указанного в
//                   процедуре ПриЗаполненииРазделовДатЗапретаИзменения (см. выше).
//   * ПолеОбъекта - Строка - имя реквизита объекта или реквизита табличной части,
//                   например "Организация", "Товары.Склад".
//
Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(Знач ИсточникиДанных) Экспорт
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОперацияБух"                                                     , "Дата" , "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ФормированиеЗаписейРаздела7ДекларацииНДС"                        , "Дата" , "БухгалтерскийУчет", "Организация");
	
КонецПроцедуры

#КонецОбласти