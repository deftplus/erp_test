
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет настройки начального заполнения элементов
//
// Параметры:
//  Настройки - Структура - настройки заполнения:
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Истина;
	
КонецПроцедуры

// Вызывается при начальном заполнении справочника.
//
// Параметры:
//  КодыЯзыков - Массив - список языков конфигурации. Актуально для мультиязычных конфигураций.
//  Элементы   - ТаблицаЗначений - данные заполнения. Состав колонок соответствует набору реквизитов
//                                 справочника.
//  ТабличныеЧасти - Структура - Ключ - Имя табличной части объекта.
//                               Значение - Выгрузка в таблицу значений пустой табличной части.
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт

	#Область Прочие
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Прочие";
	Элемент.Наименование = "<" + НСтр("ru = 'Прочие';
										|en = 'Other'", ОбщегоНазначения.КодОсновногоЯзыка()) + ">";
	#КонецОбласти

КонецПроцедуры

// Вызывается при начальном заполнении создаваемого элемента.
//
// Параметры:
//  Объект                  - СправочникОбъект.СезонныеГруппыБизнесРегионов - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения.
//  ДополнительныеПараметры - Структура - Дополнительные параметры.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Справочники.СезонныеГруппыБизнесРегионов.ЗаполнитьЭлементыНачальнымиДанными";
	Обработчик.Версия = "11.5.5.51";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("db063bfe-d678-45c8-917a-50f4f47d2846");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.СезонныеГруппыБизнесРегионов.ЗарегистрироватьПредопределенныеЭлементыДляОбновления";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновление наименований предопределенных элементов.
	|До завершения обработки наименования этих элементов в ряде случаев будет отображаться некорректно.';
	|en = 'Updates the names of predefined items.
	|While the update is in progress, names of predefined items might be displayed incorrectly.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Справочники.СезонныеГруппыБизнесРегионов.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Справочники.СезонныеГруппыБизнесРегионов.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Справочники.СезонныеГруппыБизнесРегионов.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "МультиязычностьСервер.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "Любой";

КонецПроцедуры

Процедура ЗарегистрироватьПредопределенныеЭлементыДляОбновления(Параметры) Экспорт
	
	ОбновлениеИнформационнойБазыУТ.ЗарегистрироватьПредопределенныеЭлементыДляОбновления(Параметры, Метаданные.Справочники.СезонныеГруппыБизнесРегионов);
	
КонецПроцедуры

Процедура ЗаполнитьЭлементыНачальнымиДанными(Параметры) Экспорт
	
	ОбновлениеИнформационнойБазыУТ.ЗаполнитьЭлементыНачальнымиДанными(Параметры, Метаданные.Справочники.СезонныеГруппыБизнесРегионов, Ложь, "Наименование");
	
КонецПроцедуры

#КонецОбласти


#КонецЕсли
