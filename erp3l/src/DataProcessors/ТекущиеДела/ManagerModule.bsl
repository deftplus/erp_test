///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает группу для дел, не входящих в разделы командного интерфейса.
//
Функция ПолноеИмя() Экспорт
	
	Настройки = Новый Структура;
	Настройки.Вставить("ЗаголовокПрочихДел");
	ИнтеграцияПодсистемБСП.ПриОпределенииНастроекТекущихДел(Настройки);
	ТекущиеДелаПереопределяемый.ПриОпределенииНастроек(Настройки);
	
	Если ЗначениеЗаполнено(Настройки.ЗаголовокПрочихДел) Тогда
		ЗаголовокПрочихДел = Настройки.ЗаголовокПрочихДел;
	Иначе
		ЗаголовокПрочихДел = НСтр("ru = 'Прочие дела';
									|en = 'Other to-do items'");
	КонецЕсли;
	
	Возврат ЗаголовокПрочихДел;
	
КонецФункции

#КонецОбласти

#КонецЕсли