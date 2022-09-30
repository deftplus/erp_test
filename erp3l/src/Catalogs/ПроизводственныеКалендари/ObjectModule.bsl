///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ПроверитьИспользованиеБазовогоКалендаря(Отказ);
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КалендарныеГрафики.ОбновитьИспользованиеНесколькихПроизводственныхКалендарей();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьИспользованиеБазовогоКалендаря(Отказ)
	
	Если Ссылка.Пустая() Или Не ЗначениеЗаполнено(БазовыйКалендарь) Тогда
		Возврат;
	КонецЕсли;
	
	// Запрещаем ссылку на самого себя.
	Если Ссылка = БазовыйКалендарь Тогда
		ТекстСообщения = НСтр("ru = 'В качестве базового не может быть выбран тот же самый календарь.';
								|en = 'Cannot select a calendar as a source for itself.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , "Объект.БазовыйКалендарь", Отказ);
		Возврат;
	КонецЕсли;
	
	// Если календарь уже является базовым для какого-то другого календаря, 
	// то запрещаем заполнить базовый, чтобы избежать циклических зависимостей.
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Календарь", Ссылка);
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Ссылка
		|ИЗ
		|	Справочник.ПроизводственныеКалендари КАК ПроизводственныеКалендари
		|ГДЕ
		|	ПроизводственныеКалендари.БазовыйКалендарь = &Календарь";
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Календарь уже является базовым для календаря «%1» и не может зависеть от другого.';
			|en = 'The calendar is a source for ""%1."" It cannot depend on another calendar.'"),
		Выборка.Ссылка);
	ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Выборка.Ссылка, , "Объект.БазовыйКалендарь", Отказ);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли