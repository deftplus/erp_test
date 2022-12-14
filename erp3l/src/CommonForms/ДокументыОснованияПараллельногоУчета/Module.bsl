
&НаКлиенте
Перем СохранитьПередЗакрытием;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Не Параметры.Свойство("Организация") Тогда // Возврат при получении формы для анализа.
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Организация 				= Параметры.Организация;
	Сценарий 					= Параметры.Сценарий;	
	РежимЗаполненияИсточник 	= Параметры.РежимЗаполнения;
	ТипДокументаИсточника 		= ТипЗнч(Параметры.ИсточникСсылка);
 		
	Если РежимЗаполненияИсточник = Перечисления.РежимЗаполненияВидовУчета.МСФО Тогда //на основе документа с НСБУ
		
		РежимЗаполненияПодбора = Перечисления.РежимЗаполненияВидовУчета.НСБУ;
		ТипыОснований = Новый Массив;
		ТипыОснований.Добавить(ТипДокументаИсточника);
				
	Иначе
		
		РежимЗаполненияПодбора = РежимЗаполненияИсточник;
		ТипыОснований = Отчеты.ЗаполнениеДокументовВНА_ИзБП.Создать().ПолучитьТипыПоВидуДокумента(ТипДокументаИсточника);
		
	КонецЕсли;
	
	ТипыОснований.Добавить(Тип("ДокументСсылка.ВводСведенийВНАМСФО"));
	ТипыОснований.Добавить(Тип("ДокументСсылка.ВводСобытийВНАМСФО"));
	
	ОграничениеТипов = Новый ОписаниеТипов(ТипыОснований);
	Элементы.ДокументыОснованияДокументОснование.ОграничениеТипа = ОграничениеТипов;
	
	ДокументыОснования.Очистить();
	Если Параметры.ДокументыОснования.Количество() Тогда			 
		Для каждого ДокументОснование Из Параметры.ДокументыОснования Цикл
			ТекущееОснование = ОграничениеТипов.ПривестиЗначение(ДокументОснование.Значение);
			Если (ТекущееОснование <> Неопределено) И (Не ТекущееОснование.Пустая()) Тогда
				ДокументыОснования.Добавить().ДокументОснование = ТекущееОснование;
			КонецЕсли;
			 
		 КонецЦикла;	
	КонецЕсли;
	
	//МодификацияКонфигурацииПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, СтандартнаяОбработка, Отказ);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы = Ложь, ТекстПредупреждения = "", СтандартнаяОбработка = Истина)
	
	Если ЗавершениеРаботы <> Ложь Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
		
	Если СохранитьПередЗакрытием = Неопределено Тогда
		
		Отказ = Истина;			
		
		Оповещение = Новый ОписаниеОповещения("Подключаемый_ПередЗакрытием", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Данные были изменены. Сохранить изменения?'"), РежимДиалогаВопрос.ДаНетОтмена, 120, КодВозвратаДиалога.Да);
		
	Иначе
		
		СохранитьПередЗакрытием = Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПередЗакрытием(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ПеренестиДанные(Ложь);
		СохранитьПередЗакрытием = Истина;
				
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		
		СохранитьПередЗакрытием = Ложь;
				
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ПеренестиДанные();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура ПеренестиДанные(Отказ = Ложь)
	
	ОчиститьСообщения();
	
	Основания = Новый СписокЗначений;
	Для Индекс = 0 По ДокументыОснования.Количество() - 1 Цикл
		
		СтрокаТаблицы = ДокументыОснования[Индекс];
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДокументОснование) Тогда
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'В строке %1 не выбран документ.'"), Индекс + 1);
			ПолеСообщения = СтрШаблон("ДокументыОснования[%1].ДокументОснование", Индекс);
			ОбщегоНазначенияКлиентСерверУХ.СообщитьПользователю(ТекстСообщения, , , ПолеСообщения,	Отказ);
				
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.ДокументОснование)	
			И (Основания.НайтиПоЗначению(СтрокаТаблицы.ДокументОснование) <> Неопределено) Тогда
			
			Текст = НСтр("ru = 'В строке %1 повторно указан документ %2.'");
			ТекстСообщения = СтрШаблон(Текст, Индекс + 1, СтрокаТаблицы.ДокументОснование);
			ПолеСообщения = СтрШаблон("ДокументыОснования[%1].ДокументОснование", Индекс);
			ОбщегоНазначенияКлиентСерверУХ.СообщитьПользователю(ТекстСообщения, , , ПолеСообщения,	Отказ);
							
		КонецЕсли; 
		
		Основания.Добавить(СтрокаТаблицы.ДокументОснование);
		
	КонецЦикла;
	
	Если НЕ Отказ Тогда
		Модифицированность = Ложь;
		ОповеститьОВыборе(Основания);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыОснованияДокументОснованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыВыбора = Новый Массив;
	
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Организация", 		Организация));
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Сценарий", 		Сценарий));
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления", 	Ложь));
	//ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Проведен", 		Истина));
	Если ЗначениеЗаполнено(РежимЗаполненияПодбора) Тогда
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.РежимЗаполнения", 	РежимЗаполненияПодбора));
	КонецЕсли;
	
	Элементы.ДокументыОснованияДокументОснование.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

