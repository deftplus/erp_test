
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ТипЗначения = Тип("Строка") Тогда
		
		Заголовок = НСтр("ru = 'Установите значение отбора';
						|en = 'Set filter value'");
		Элементы.СтраницыВидовОтборов.ТекущаяСтраница = Элементы.СтраницаВводаСтроки;
		ЗначениеВыбораСтрока = Параметры.ЗначениеОтбора;
		Элементы.ЗначениеВыбораСтрока.ПодсказкаВвода = Параметры.ПодсказкаВвода;
		
	ИначеЕсли Параметры.ТипЗначения = Тип("СписокЗначений") Тогда
		
		Заголовок = НСтр("ru = 'Установите значение отбора';
						|en = 'Set filter value'");
		Элементы.СтраницыВидовОтборов.ТекущаяСтраница = Элементы.СтраницаВводаСтроки;
		ЗначениеВыбораСтрока = Параметры.ЗначениеОтбора;
		
		Элементы.ЗначениеВыбораСтрока.РежимВыбораИзСписка     = Истина;
		Элементы.ЗначениеВыбораСтрока.КнопкаВыпадающегоСписка = Истина;
		
		Элементы.ЗначениеВыбораСтрока.СписокВыбора.Очистить();
		Для Каждого ЭлементСписка Из Параметры.СписокСтрокОтбора Цикл
			Элементы.ЗначениеВыбораСтрока.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
		КонецЦикла;
		
	Иначе
		
		Заголовок = НСтр("ru = 'Установите интервал значений отбора';
						|en = 'Set filter value interval'");
		Элементы.СтраницыВидовОтборов.ТекущаяСтраница = Элементы.СтраницаВводаИнтервала;
		
		Если Параметры.ТипЗначения = Тип("Дата") Тогда
			Элементы.СтраницыТиповИнтервалов.ТекущаяСтраница = Элементы.СтраницаТипаДата;
			ЗначениеДатаОт           = Параметры.ЗначениеОт;
			ЗначениеДатаДо           = Параметры.ЗначениеДо;
			ТипЗначенияДата          = Истина;
			
			Если ЗначениеЗаполнено(Параметры.МинимальноеЗначение) Тогда
				МинимальноеЗначениеДата  = ПрочитатьДатуJSON(Параметры.МинимальноеЗначение, ФорматДатыJSON.ISO);
			КонецЕсли;
			Если ЗначениеЗаполнено(Параметры.МаксимальноеЗначение) Тогда
				МаксимальноеЗначениеДата = ПрочитатьДатуJSON(Параметры.МаксимальноеЗначение, ФорматДатыJSON.ISO);
			КонецЕсли;
			
			Параметры.МаксимальноеЗначение = Формат(МаксимальноеЗначениеДата, "ДЛФ=ДД");
			Параметры.МинимальноеЗначение  = Формат(МинимальноеЗначениеДата, "ДЛФ=ДД");
			
			Если ЗначениеЗаполнено(Параметры.МинимальноеЗначение)
				ИЛИ ЗначениеЗаполнено(Параметры.МаксимальноеЗначение) Тогда
				
				Элементы.ДекорацияМинЗначДата.Заголовок = НСтр("ru = 'Минимальное значение:';
																|en = 'Minimum value:'") + " "
					+ ?(ЗначениеЗаполнено(Параметры.МинимальноеЗначение), Параметры.МинимальноеЗначение, "   " + НСтр("ru = 'не задано';
																														|en = 'not specified'"));
				Элементы.ДекорацияМаксЗначДата.Заголовок = НСтр("ru = 'Максимальное значение:';
																|en = 'Maximum value:'") + " "
					+ ?(ЗначениеЗаполнено(Параметры.МаксимальноеЗначение), Параметры.МаксимальноеЗначение, "   " + НСтр("ru = 'не задано';
																														|en = 'not specified'"));
			КонецЕсли;
			
		Иначе
			Элементы.СтраницыТиповИнтервалов.ТекущаяСтраница = Элементы.СтраницаТипаЧисло;
			ЗначениеЧислоОт           = Параметры.ЗначениеОт;
			ЗначениеЧислоДо           = Параметры.ЗначениеДо;
			МаксимальноеЗначениеЧисло = Параметры.МаксимальноеЗначение;
			МинимальноеЗначениеЧисло  = Параметры.МинимальноеЗначение;
			
			Если ЗначениеЗаполнено(Параметры.МинимальноеЗначение)
				ИЛИ ЗначениеЗаполнено(Параметры.МаксимальноеЗначение) Тогда
				
				Элементы.ДекорацияМинЗнач.Заголовок = НСтр("ru = 'Минимальное значение:';
															|en = 'Minimum value:'") + " "
					+ ?(ЗначениеЗаполнено(Параметры.МинимальноеЗначение), Параметры.МинимальноеЗначение, НСтр("ru = 'не задано';
																												|en = 'not specified'"));
				Элементы.ДекорацияМаксЗнач.Заголовок = НСтр("ru = 'Максимальное значение:';
															|en = 'Maximum value:'") + " "
					+ ?(ЗначениеЗаполнено(Параметры.МаксимальноеЗначение), Параметры.МаксимальноеЗначение, НСтр("ru = 'не задано';
																												|en = 'not specified'"));
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ИмяРеквизита = Параметры.ИмяРеквизита;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если Элементы.СтраницыВидовОтборов.ТекущаяСтраница = Элементы.СтраницаВводаИнтервала Тогда
		
		НеверныйИнтервал = Ложь;
		
		СтруктураВозврата = Новый Структура("ИнтервалОт, ИнтервалДо");
		
		Если ТипЗначенияДата Тогда
			СтруктураВозврата.ИнтервалОт = ЗначениеДатаОт;
			СтруктураВозврата.ИнтервалДо = ЗначениеДатаДо;
			
			МаксимальноеЗначениеДатаЗаполнено = ЗначениеЗаполнено(МаксимальноеЗначениеДата);
			МинимальноеЗначениеДатаЗаполнено  = ЗначениеЗаполнено(МинимальноеЗначениеДата);
			ЗначениеДатаДоЗаполнено = ЗначениеЗаполнено(ЗначениеДатаДо);
			ЗначениеДатаОтЗаполнено = ЗначениеЗаполнено(ЗначениеДатаОт);
			
			НеверныйИнтервал = (ЗначениеДатаОт > ЗначениеДатаДо)И ЗначениеДатаДоЗаполнено;
			
			Если МаксимальноеЗначениеДатаЗаполнено И (ЗначениеДатаДоЗаполнено ИЛИ ЗначениеДатаОтЗаполнено) Тогда
				НеверныйИнтервал = НеверныйИнтервал
					ИЛИ (ЗначениеДатаДо > МаксимальноеЗначениеДата)
					ИЛИ (ЗначениеДатаОт > МаксимальноеЗначениеДата);
			КонецЕсли;
			
			Если МинимальноеЗначениеДатаЗаполнено Тогда
				НеверныйИнтервал = НеверныйИнтервал
					ИЛИ (ЗначениеДатаОт < МинимальноеЗначениеДата) И ЗначениеДатаОтЗаполнено
					ИЛИ (ЗначениеДатаДо < МинимальноеЗначениеДата) И ЗначениеДатаДоЗаполнено;
			КонецЕсли;
			
		Иначе
			СтруктураВозврата.ИнтервалОт = ЗначениеЧислоОт;
			СтруктураВозврата.ИнтервалДо = ЗначениеЧислоДо;
			
			МаксимальноеЗначениеЧислоЗаполнено = ЗначениеЗаполнено(МаксимальноеЗначениеЧисло);
			МинимальноеЗначениеЧислоЗаполнено  = ЗначениеЗаполнено(МинимальноеЗначениеЧисло);
			ЗначениеЧислоДоЗаполнено = ЗначениеЗаполнено(ЗначениеЧислоДо);
			ЗначениеЧислоОтЗаполнено = ЗначениеЗаполнено(ЗначениеЧислоОт);
			
			НеверныйИнтервал = (ЗначениеЧислоОт > ЗначениеЧислоДо) И ЗначениеЧислоДоЗаполнено;
			
			Если МаксимальноеЗначениеЧислоЗаполнено И (ЗначениеЧислоОтЗаполнено ИЛИ ЗначениеЧислоДоЗаполнено) Тогда
				НеверныйИнтервал = НеверныйИнтервал
					ИЛИ (ЗначениеЧислоДо > МаксимальноеЗначениеЧисло)
					ИЛИ (ЗначениеЧислоОт > МаксимальноеЗначениеЧисло);
			Иначе
				НеверныйИнтервал = НеверныйИнтервал ИЛИ ЗначениеЧислоДо < 0;
			КонецЕсли;
			
			Если МинимальноеЗначениеЧислоЗаполнено Тогда
				НеверныйИнтервал = НеверныйИнтервал
					ИЛИ (ЗначениеЧислоОт < МинимальноеЗначениеЧисло) И ЗначениеЧислоОтЗаполнено
					ИЛИ (ЗначениеЧислоДо < МинимальноеЗначениеЧисло) И ЗначениеЧислоДоЗаполнено;
			Иначе
				НеверныйИнтервал = НеверныйИнтервал ИЛИ ЗначениеЧислоОт < 0;
			КонецЕсли;
			
		КонецЕсли;
		
		Если НеверныйИнтервал Тогда
			ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Указан неверный диапазон значений';
														|en = 'Invalid value range specified'"));
			Возврат;
		КонецЕсли;
		
	Иначе
		
		СтруктураВозврата = Новый Структура("ЗначениеОтбора", ЗначениеВыбораСтрока);
		
	КонецЕсли;
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	РедактироватьПериод(ЭтаФорма,
		Новый Структура("ДатаНачала, ДатаОкончания", "ЗначениеДатаОт", "ЗначениеДатаДо"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура позволяет установить период через стандартный диалог выбора периода
//
// Параметры:
//  Объект                - Произвольный - Объект в котором устанавливается значения периода
//  ПараметрыПериода      - Структура - структура со свойствами "ДатаНачала", "ДатаОкончания" и в значениях имена полей
//                              объекта, для свойства "Вариант" - значение варианта стандартного периода.
//  ОповещениеПослеВыбора - ОписаниеОповещения - Описание оповещение которое выполняется после установки периода. 
//                              Может быть установлена пост-обработка в месте вызова после выбора периода.
&НаКлиенте
Процедура РедактироватьПериод(Объект, ПараметрыПериода = Неопределено, ОповещениеПослеВыбора = Неопределено)
	
	Если ПараметрыПериода = Неопределено Тогда
		ПараметрыПериода = Новый Структура("ДатаНачала, ДатаОкончания", "ДатаНачала", "ДатаОкончания");
	КонецЕсли;
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Если ПараметрыПериода.Свойство("ДатаНачала") Тогда
		Диалог.Период.ДатаНачала = Объект[ПараметрыПериода.ДатаНачала];
	КонецЕсли; 
	Если ПараметрыПериода.Свойство("ДатаОкончания") Тогда
		Диалог.Период.ДатаОкончания = Объект[ПараметрыПериода.ДатаОкончания];
	КонецЕсли; 
	Если ПараметрыПериода.Свойство("Вариант") Тогда
		Диалог.Период.Вариант = ПараметрыПериода.Вариант;
	КонецЕсли; 
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект",           Объект);
	ДополнительныеПараметры.Вставить("ПараметрыПериода", ПараметрыПериода);
	Если ОповещениеПослеВыбора <> Неопределено Тогда
		ДополнительныеПараметры.Вставить("ОповещениеПослеВыбора", ОповещениеПослеВыбора);
	КонецЕсли; 
	
	Оповещение = Новый ОписаниеОповещения(
		"РедактироватьПериодЗавершение",
		ЭтотОбъект,
		ДополнительныеПараметры);
	
	Диалог.Показать(Оповещение);

КонецПроцедуры

// Процедура завершения для РедактироватьПериод()
// см. подробней для процедуры РедактироватьПериод().
&НаКлиенте
Процедура РедактироватьПериодЗавершение(Период, ДополнительныеПараметры) Экспорт 

	ПараметрыПериода = ДополнительныеПараметры.ПараметрыПериода;
	Объект           = ДополнительныеПараметры.Объект;
	Если Период <> Неопределено Тогда
		Если ПараметрыПериода.Свойство("ДатаНачала") Тогда
			Объект[ПараметрыПериода.ДатаНачала]= Период.ДатаНачала;
		КонецЕсли; 
		Если ПараметрыПериода.Свойство("ДатаОкончания") Тогда
			Объект[ПараметрыПериода.ДатаОкончания]= Период.ДатаОкончания;
		КонецЕсли; 
		Если ПараметрыПериода.Свойство("Вариант") Тогда
			Объект[ПараметрыПериода.Вариант]= Период.Вариант;
		КонецЕсли;
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("ОповещениеПослеВыбора") Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыбора, Период);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


