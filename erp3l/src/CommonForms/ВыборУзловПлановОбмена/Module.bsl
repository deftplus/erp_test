///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Форма выбора для полей типа "узел плана обмена".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Обработка стандартных параметров.
	Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
		РежимПодбора = Истина;
		Если Параметры.Свойство("МножественныйВыбор") И Параметры.МножественныйВыбор = Истина Тогда
			МножественныйВыбор = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Подготовка списка используемых планов обмена.
	Если ТипЗнч(Параметры.ПланыОбменаДляВыбора) = Тип("Массив") Тогда
		Для каждого Элемент Из Параметры.ПланыОбменаДляВыбора Цикл
			Если ТипЗнч(Элемент) = Тип("Строка") Тогда
				// Поиск плана обмена по имени.
				ДобавитьИспользуемыйПланОбмена(Метаданные.НайтиПоПолномуИмени(Элемент));
				ДобавитьИспользуемыйПланОбмена(Метаданные.НайтиПоПолномуИмени("ПланОбмена." + Элемент));
				//
			ИначеЕсли ТипЗнч(Элемент) = Тип("Тип") Тогда
				// Поиск плана обмена по заданному типу.
				ДобавитьИспользуемыйПланОбмена(Метаданные.НайтиПоТипу(Элемент));
			Иначе
				// Поиск плана обмена по типу заданного узла.
				ДобавитьИспользуемыйПланОбмена(Метаданные.НайтиПоТипу(ТипЗнч(Элемент)));
			КонецЕсли;
		КонецЦикла;
	Иначе
		// Все планы обмена участвуют в выборе.
		Для каждого ОбъектМетаданных Из Метаданные.ПланыОбмена Цикл
			ДобавитьИспользуемыйПланОбмена(ОбъектМетаданных);
		КонецЦикла;
	КонецЕсли;
	
	УзлыПлановОбмена.Сортировать("ПланОбменаПредставление Возр");
	
	Если РежимПодбора Тогда
		Заголовок = НСтр("ru = 'Подбор узлов планов обмена';
						|en = 'Select exchange plan nodes'");
	КонецЕсли;
	Если МножественныйВыбор Тогда
		Элементы.УзлыПлановОбмена.РежимВыделения = РежимВыделенияТаблицы.Множественный;
	КонецЕсли;
	
	ТекущаяСтрока = Неопределено;
	Параметры.Свойство("ТекущаяСтрока", ТекущаяСтрока);
	
	НайденныеСтроки = УзлыПлановОбмена.НайтиСтроки(Новый Структура("Узел", ТекущаяСтрока));
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		Элементы.УзлыПлановОбмена.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУзлыПлановОбмена

&НаКлиенте
Процедура УзлыПлановОбменаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если МножественныйВыбор Тогда
		ЗначениеВыбора = Новый Массив;
		ЗначениеВыбора.Добавить(УзлыПлановОбмена.НайтиПоИдентификатору(ВыбраннаяСтрока).Узел);
		ОповеститьОВыборе(ЗначениеВыбора);
	Иначе
		ОповеститьОВыборе(УзлыПлановОбмена.НайтиПоИдентификатору(ВыбраннаяСтрока).Узел);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если МножественныйВыбор Тогда
		ЗначениеВыбора = Новый Массив;
		Для Каждого ВыделеннаяСтрока Из Элементы.УзлыПлановОбмена.ВыделенныеСтроки Цикл
			ЗначениеВыбора.Добавить(УзлыПлановОбмена.НайтиПоИдентификатору(ВыделеннаяСтрока).Узел)
		КонецЦикла;
		ОповеститьОВыборе(ЗначениеВыбора);
	Иначе
		ТекущиеДанные = Элементы.УзлыПлановОбмена.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Узел не выбран.';
											|en = 'No nodes are selected.'"));
		Иначе
			ОповеститьОВыборе(ТекущиеДанные.Узел);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьИспользуемыйПланОбмена(ОбъектМетаданных)
	
	Если ОбъектМетаданных = Неопределено
		ИЛИ НЕ Метаданные.ПланыОбмена.Содержит(ОбъектМетаданных) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Чтение", ОбъектМетаданных) Тогда
		Возврат;
	КонецЕсли;
	
	ПланОбмена = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя()).ПустаяСсылка();
	
	// Заполнение узлов используемых планов обмена.
	Если Параметры.ВыбиратьВсеУзлы Тогда
		НоваяСтрока = УзлыПлановОбмена.Добавить();
		НоваяСтрока.ПланОбмена              = ПланОбмена;
		НоваяСтрока.ПланОбменаПредставление = ОбъектМетаданных.Синоним;
		НоваяСтрока.Узел                    = ПланОбмена;
		НоваяСтрока.УзелПредставление       = НСтр("ru = '<Все информационные базы>';
													|en = '<All infobases>'");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаПланаОбмена.Ссылка,
	|	ТаблицаПланаОбмена.Представление КАК Представление
	|ИЗ
	|	&ТаблицаПланаОбмена КАК ТаблицаПланаОбмена
	|ГДЕ
	|	НЕ ТаблицаПланаОбмена.ЭтотУзел
	|
	|УПОРЯДОЧИТЬ ПО
	|	Представление";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТаблицаПланаОбмена", ОбъектМетаданных.ПолноеИмя());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = УзлыПлановОбмена.Добавить();
		НоваяСтрока.ПланОбмена              = ПланОбмена;
		НоваяСтрока.ПланОбменаПредставление = ОбъектМетаданных.Синоним;
		НоваяСтрока.Узел                    = Выборка.Ссылка;
		НоваяСтрока.УзелПредставление       = Выборка.Представление;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
