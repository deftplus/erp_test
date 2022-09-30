///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает диалог группового изменения реквизитов для выбранных в списке объектов.
//
// Параметры:
//  СписокЭлемент  - ТаблицаФормы
//                 - Массив из ЛюбаяСсылка - элемент формы со списком.
//  СписокРеквизит - ДинамическийСписок - реквизит формы со списком.
//
Процедура ИзменитьВыделенные(СписокЭлемент, Знач СписокРеквизит = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура("МассивОбъектов", Новый Массив);
	Если ТипЗнч(СписокЭлемент) = Тип("Массив") Тогда
		
		ПараметрыФормы.МассивОбъектов = СписокЭлемент;
		
	Иначе
		
		Если СписокРеквизит = Неопределено Тогда
			
			Форма = СписокЭлемент.Родитель;
			Пока ТипЗнч(Форма) <> Тип("ФормаКлиентскогоПриложения") Цикл
				Форма = Форма.Родитель;
			КонецЦикла;
			
			Попытка
				СписокРеквизит = Форма.Список;
			Исключение
				СписокРеквизит = Неопределено;
			КонецПопытки;
			
		КонецЕсли;
		
		ВыделенныеСтроки = СписокЭлемент.ВыделенныеСтроки;
		
		Если ТипЗнч(СписокРеквизит) = Тип("ДинамическийСписок") Тогда
			ПараметрыФормы.Вставить("КомпоновщикНастроек", СписокРеквизит.КомпоновщикНастроек);
		КонецЕсли;
		
		Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
			Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				Продолжить;
			КонецЕсли;
			
			ТекущаяСтрока = СписокЭлемент.ДанныеСтроки(ВыделеннаяСтрока);
			Если ТекущаяСтрока <> Неопределено И ЗначениеЗаполнено(ТекущаяСтрока.Ссылка) Тогда
				ПараметрыФормы.МассивОбъектов.Добавить(ТекущаяСтрока.Ссылка);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	НачатьИзменениеВыделенных(ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Параметры:
//   МассивСсылок - Массив из ЛюбаяСсылка - ссылки выбранных объектов, для которых выполняется команда.
//   ПараметрыВыполнения - см. ПодключаемыеКомандыКлиент.ПараметрыВыполненияКоманды
//
Процедура ОбработчикКоманды(Знач МассивСсылок, Знач ПараметрыВыполнения) Экспорт
	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("МассивОбъектов", МассивСсылок);
	НачатьИзменениеВыделенных(ПараметрыКоманды);
КонецПроцедуры

Процедура НачатьИзменениеВыделенныхСОповещением(ПараметрыГрупповогоИзменения, ОписаниеОповещения) Экспорт
	
	Если ПараметрыГрупповогоИзменения.МассивОбъектов.Количество() = 0 Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта.';
										|en = 'Cannot run the command for the object.'"));
		
	Иначе
		
		ОткрытьФорму("Обработка.ГрупповоеИзменениеРеквизитов.Форма", ПараметрыГрупповогоИзменения,,,,, ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  ПараметрыГрупповогоИзменения - Структура:
//    * МассивОбъектов - Массив из ЛюбаяСсылка
//    * КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных
//
Процедура НачатьИзменениеВыделенных(ПараметрыГрупповогоИзменения)
	
	Если ПараметрыГрупповогоИзменения.МассивОбъектов.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта.';
										|en = 'Cannot execute the command for the object.'"));
	Иначе
		ОткрытьФорму("Обработка.ГрупповоеИзменениеРеквизитов.Форма", ПараметрыГрупповогоИзменения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
