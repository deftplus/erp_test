#Область ПрограммныйИнтерфейс
	
Процедура СуммаВзаиморасчетовПриИзменении(Форма, Элемент) Экспорт
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	ТекДанные = Элементы.ТаблицаДвижений.ТекущиеДанные;
		
	Если Объект.КурсПлатежа <> 0 И Объект.КратностьПлатежа <> 0 Тогда
		ТекДанные.Сумма = ТекДанные.СуммаВзаиморасчетов * Объект.КурсПлатежа / Объект.КратностьПлатежа;
	КонецЕсли;
	
КонецПроцедуры

Процедура РазбитьСтроку(ТабличнаяЧасть, ТаблицаФормы, ИмяРеквизита = "Сумма", ТекстВводаНовогоЗначения = "", ТекстПредупреждения = "") Экспорт
	
	ИсходнаяСтрока = ТаблицаФормы.ТекущиеДанные;
	
	Если ИсходнаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметровПереноса = Новый Структура;
	СтруктураПараметровПереноса.Вставить("ТабличнаяЧасть", ТабличнаяЧасть);
	СтруктураПараметровПереноса.Вставить("ТаблицаФормы", ТаблицаФормы);
	СтруктураПараметровПереноса.Вставить("ИмяРеквизита", ИмяРеквизита);
	СтруктураПараметровПереноса.Вставить("ИсходнаяСтрока", ИсходнаяСтрока);
	
	СтруктураПараметровПереноса.Вставить("ТекстПредупреждения", 
		?(ПустаяСтрока(ТекстПредупреждения), 
			НСтр("ru = 'Сумма к переносу не должна превышать сумму исходной строки.'"), 
			ТекстПредупреждения));
	
	Если ИсходнаяСтрока[ИмяРеквизита] = 0 Тогда
		// Возможен единственный вариант.
		ДобавитьСтрокуРазбиения(0, СтруктураПараметровПереноса);
	Иначе
		ЗаголовокВводаНовогоЗначения =  ?(ПустаяСтрока(ТекстВводаНовогоЗначения), 
			НСтр("ru = 'Введите сумму к переносу в новую строку.'"), 
			ТекстВводаНовогоЗначения);
		ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьСтрокуРазбиения", ЭтотОбъект, СтруктураПараметровПереноса);	
		ПоказатьВводЧисла(ОписаниеОповещения, ИсходнаяСтрока[ИмяРеквизита], ЗаголовокВводаНовогоЗначения, 15, 2);
	КонецЕсли;
	
	
КонецПроцедуры


#Область ОбработчикиОповещения

Процедура ВыборПозицииФормированиеПлатежногоПоручения(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("УникальныйИдентификатор") Тогда
		ОткрытьФорму(Параметры.ИмяОбъектаМетаданных + ".ФормаОбъекта", Новый Структура("Основание", Результат))
	ИначеЕсли ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("ВводНаОснованииПлатежнойПозиции") И  Результат.ВводНаОснованииПлатежнойПозиции = Истина Тогда
		ОткрытьФорму(Параметры.ИмяОбъектаМетаданных + ".ФормаОбъекта", Новый Структура("Основание", Результат.Основание))
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийДокументовДДС

Процедура ПриИзмененииСтатьиДвиженияДенежныхСредств(Форма, Элемент, ПостфиксАналитик = "") Экспорт
	
	ДенежныеСредстваВстраиваниеУХКлиент.ПриИзмененииСтатьиДвиженияДенежныхСредств(Форма, Элемент, ПостфиксАналитик);
	
КонецПроцедуры

Процедура РасшифровкаПлатежаПередНачаломИзменения(Форма, Элемент, Отказ, ИмяТабличнойЧасти = "РасшифровкаПлатежа") Экспорт
	
	ИдСтроки = Элемент.ТекущаяСтрока;
	Если ИдСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицы = Форма.Объект[ИмяТабличнойЧасти].НайтиПоИдентификатору(ИдСтроки);
	
	ПоляФормы = Новый Массив;
	Для Индекс = 1 По АналитикиСтатейБюджетовУХКлиентСервер.КоличествоАналитикСтатьи() Цикл
		ПоляФормы.Добавить(Форма.Элементы[Элемент.Имя + "АналитикаБДДС" + Индекс]);
	КонецЦикла;
	ОперативноеПланированиеФормыУХКлиентСервер.УправлениеЭлементамиДополнительныхАналитик(СтрокаТаблицы, ПоляФормы);
	
	ОперативноеПланированиеФормыУХКлиентСервер.ИзменитьПараметрыВыбораАналитик(СтрокаТаблицы, СтрокаТаблицы,ПоляФормы);
	
КонецПроцедуры

Процедура ПриИзмененииАналитикиБюджетирования(Форма, НомерАналитики, Элемент, ПостфиксАналитик = "") Экспорт
	
	ЭтоТаблица = ТипЗнч(Форма.ТекущийЭлемент) = Тип("ТаблицаФормы");
	
	ПоляФормы = Новый Массив;
	
	Если ЭтоТаблица Тогда
		
		ИдСтроки = Форма.ТекущийЭлемент.ТекущаяСтрока;
		Если ИдСтроки = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ДанныеРасшифровки = Форма.Объект.РасшифровкаПлатежа.НайтиПоИдентификатору(ИдСтроки);
		ИсточникТипов = ДанныеРасшифровки;
		Для Сч = 1 По АналитикиСтатейБюджетовУХКлиентСервер.КоличествоАналитикСтатьи() Цикл
			ПоляФормы.Добавить(Форма.Элементы[Форма.ТекущийЭлемент.Имя + "АналитикаБДДС" + Сч]);
		КонецЦикла;
		
	Иначе
		
		Для Сч = 1 По АналитикиСтатейБюджетовУХКлиентСервер.КоличествоАналитикСтатьи() Цикл
			ПоляФормы.Добавить(Форма.Элементы["АналитикаБДДС" + Сч + ПостфиксАналитик]);
		КонецЦикла;
		
		ДанныеРасшифровки = Форма.Объект;
				
		ИсточникТипов = Форма;
	КонецЕсли;
	
	Если ДанныеРасшифровки <> Неопределено Тогда
		ОперативноеПланированиеФормыУХКлиентСервер.ИзменитьПараметрыВыбораАналитик(ДанныеРасшифровки, ИсточникТипов, ПоляФормы);
		ОчиститьСвязанныеАналитики(ДанныеРасшифровки, ИсточникТипов, НомерАналитики);
	Иначе
		// Пропускаем.
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаВыбораДокументаПланирования(Форма, Элемент, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт
	ДенежныеСредстваВстраиваниеУХКлиент.ОбработкаВыбораДокументаПланирования(Форма, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОчиститьСвязанныеАналитики(ИсточникДанных, ИсточникТиповЗначений, НомерАналитики)
	
	ЗначениеАналитики = ИсточникДанных["АналитикаБДДС" + НомерАналитики];
	
	Для Сч = 1 по АналитикиСтатейБюджетовУХКлиентСервер.КоличествоАналитикСтатьи() Цикл
		
		Если Сч = НомерАналитики Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеТиповВладельца = ИсточникТиповЗначений["ВидАналитики" + Сч + "ТипыВладельца"];
		
		Если ЗначениеЗаполнено(ОписаниеТиповВладельца) Тогда
			
			Если ОписаниеТиповВладельца.СодержитТип(ТипЗнч(ЗначениеАналитики)) Тогда
				
				ИсточникДанных["АналитикаБДДС" + Сч] = Неопределено;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	
КонецПроцедуры

Процедура ДобавитьСтрокуРазбиения(Результат, ПараметрыПереноса) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат < 0 Тогда
		
		ПоказатьПредупреждение(,НСтр("ru = 'Необходимо ввести положительное значение.'"));
		Возврат;
		
	КонецЕсли;
	
	ИсходнаяСтрока = ПараметрыПереноса.ИсходнаяСтрока;
	ТаблицаФормы = ПараметрыПереноса.ТаблицаФормы;
	ТабличнаяЧасть =  ПараметрыПереноса.ТабличнаяЧасть;
	ИмяРеквизита = ПараметрыПереноса.ИмяРеквизита;
	
	Если ИсходнаяСтрока[ИмяРеквизита] < Результат Тогда
		ПоказатьПредупреждение(,ПараметрыПереноса.ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ИндексСтроки = ТабличнаяЧасть.Индекс(ИсходнаяСтрока);
	НоваяСтрока = ТабличнаяЧасть.Вставить(ИндексСтроки + 1);
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ИсходнаяСтрока);
	НоваяСтрока[ИмяРеквизита] = Результат;
	ИсходнаяСтрока[ИмяРеквизита] = ИсходнаяСтрока[ИмяРеквизита] - Результат;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ИсходнаяСтрока, "СуммаНДС") Тогда
		ОперативноеПланированиеФормыУХКлиентСервер.ПересчитатьСуммуНДС(ИсходнаяСтрока);
		ОперативноеПланированиеФормыУХКлиентСервер.ПересчитатьСуммуНДС(НоваяСтрока);
	КонецЕсли;
	
	ТаблицаФормы.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	
КонецПроцедуры

#КонецОбласти