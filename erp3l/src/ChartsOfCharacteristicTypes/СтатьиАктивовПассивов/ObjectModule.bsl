#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("АктивПассив") Тогда
		АктивПассив = ДанныеЗаполнения.АктивПассив;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		БезАналитики = ТипЗначения = Новый ОписаниеТипов("ПеречислениеСсылка.СтатьиБезАналитики");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЧтенииПредставленийНаСервере() Экспорт
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииПредставленийНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

#КонецОбласти

#КонецЕсли
