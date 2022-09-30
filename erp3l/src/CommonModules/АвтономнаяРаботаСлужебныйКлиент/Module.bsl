///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Обработчики условных вызовов из БСП

// Проверяет настройку автономного рабочего места и уведомляет об ошибке.
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыКлиента.Свойство("ПерезапуститьПослеНастройкиАвтономногоРабочегоМеста") Тогда
		Параметры.Отказ = Истина;
		Параметры.Перезапустить = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ ПараметрыКлиента.Свойство("ОшибкаПриНастройкеАвтономногоРабочегоМеста") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Отказ = Истина;
	Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
		"ИнтерактивнаяОбработкаПриПроверкеНастройкиАвтономногоРабочегоМеста", ЭтотОбъект);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Обработчики оповещений.

// Предупреждает об ошибке настройки автономного рабочего места.
Процедура ИнтерактивнаяОбработкаПриПроверкеНастройкиАвтономногоРабочегоМеста(Параметры, Неопределен) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	СтандартныеПодсистемыКлиент.ПоказатьПредупреждениеИПродолжить(
		Параметры, ПараметрыКлиента.ОшибкаПриНастройкеАвтономногоРабочегоМеста);
	
КонецПроцедуры

#КонецОбласти
