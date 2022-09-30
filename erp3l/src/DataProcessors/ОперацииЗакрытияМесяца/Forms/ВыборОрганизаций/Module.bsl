
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПериодРегистрации 	= Параметры.ПериодРегистрации;
	ОписаниеОрганизаций = Параметры.ОписаниеОрганизаций;
	
	Если НЕ ЗначениеЗаполнено(ПериодРегистрации) ИЛИ НЕ ЗначениеЗаполнено(ОписаниеОрганизаций) Тогда
		ВызватьИсключение НСтр("ru = 'Некорректный контекст открытия формы';
								|en = 'Incorrect form opening context'");
	КонецЕсли;
	
	ЗаполнитьДеревоОрганизаций();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьОрганизации(Команда)
	
	МассивОрганизаций = Новый Массив;
	ВсеОрганизации = Истина;
	
	Для Каждого ТекущаяОрганизация Из ДеревоОрганизаций.ПолучитьЭлементы() Цикл
		
		Если НЕ ТекущаяОрганизация.Отметка Тогда
			ВсеОрганизации = Ложь;
			Продолжить;
		КонецЕсли;
		
		Если ТекущаяОрганизация.ЭтоГруппа Тогда
			
			Для Каждого ТекущаяОрганизация2 Из ТекущаяОрганизация.ПолучитьЭлементы() Цикл
				МассивОрганизаций.Добавить(ТекущаяОрганизация2.Организация);
			КонецЦикла;
			
		Иначе
			МассивОрганизаций.Добавить(ТекущаяОрганизация.Организация);
		КонецЕсли;
		
	КонецЦикла;
	
	Если МассивОрганизаций.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Необходимо выбрать организации для закрытия месяца.';
																|en = 'Select companies for month-end closing.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
		Возврат;
	КонецЕсли;
	
	Если ВсеОрганизации Тогда
		МассивОрганизаций.Очистить();
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("МассивОрганизаций", МассивОрганизаций);
	Результат.Вставить("ВсеОрганизации", 	ВсеОрганизации);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	СинхронизироватьОтметкиПодчиненныхЭлементов(ДеревоОрганизаций, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеОтметки(Команда)
	
	СинхронизироватьОтметкиПодчиненныхЭлементов(ДеревоОрганизаций, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДеревоОрганизацийОтметкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоОрганизаций.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СинхронизироватьОтметкиПодчиненныхЭлементов(ТекущиеДанные, ТекущиеДанные.Отметка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОрганизацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ДеревоОрганизацийОрганизация Тогда
		
		СтрокаОрганизации = ДеревоОрганизаций.НайтиПоИдентификатору(ВыбраннаяСтрока);
		
		Если СтрокаОрганизации <> Неопределено
		 И ТипЗнч(СтрокаОрганизации.Организация) = Тип("СправочникСсылка.Организации") Тогда
			ПоказатьЗначение(, СтрокаОрганизации.Организация);
	 	КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоОрганизаций()
	
	МассивОрганизаций 	= Параметры.МассивОрганизаций;
	ВсеОрганизации 		= Параметры.ВсеОрганизации;
	
	ДеревоОрганизаций.ПолучитьЭлементы().Очистить();
	
	// Заполним "одиночные" организации.
	Для Каждого ТекущаяОрганизация Из ОписаниеОрганизаций.ОдиночныеОрганизации Цикл
		
		Если ОписаниеОрганизаций.ДоступныеОрганизации.Найти(ТекущаяОрганизация) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ДеревоОрганизаций.ПолучитьЭлементы().Добавить();
		
		НоваяСтрока.Организация 	 = ТекущаяОрганизация;
		НоваяСтрока.Отметка 		 = ВсеОрганизации ИЛИ МассивОрганизаций.Найти(ТекущаяОрганизация) <> Неопределено;
		НоваяСтрока.ИзменениеОтметки = Истина;
		
	КонецЦикла;
	
	// Заполним группы организаций.
	КоличествоГрупп = 0;
	
	Для Каждого ТекущаяГруппа Из ОписаниеОрганизаций.ГруппыОрганизаций Цикл
		
		НоваяГруппа = ДеревоОрганизаций.ПолучитьЭлементы().Добавить();
		
		ЕстьИнтеркампани = Ложь;
		ЕстьОСиНМА       = Ложь;
		ЕстьНедоступные  = Ложь;
		ЕстьОтмеченные   = Ложь;
		ЕстьНеотмеченные = Ложь;
		
		Для Каждого ТекущаяОрганизация Из ТекущаяГруппа Цикл
			
			Если ОписаниеОрганизаций.ДоступныеОрганизации.Найти(ТекущаяОрганизация) = Неопределено Тогда
				ЕстьНедоступные = Истина;
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = НоваяГруппа.ПолучитьЭлементы().Добавить();
			
			НоваяСтрока.Организация 	 = ТекущаяОрганизация;
			НоваяСтрока.Отметка 		 = ВсеОрганизации ИЛИ МассивОрганизаций.Найти(ТекущаяОрганизация) <> Неопределено;
			НоваяСтрока.ИзменениеОтметки = Ложь;
			
			ЕстьИнтеркампани = ЕстьИнтеркампани ИЛИ ОписаниеОрганизаций.ОрганизацииИнтеркампани.Получить(ТекущаяОрганизация) <> Неопределено;
			ЕстьОСиНМА 		 = ЕстьОСиНМА ИЛИ ОписаниеОрганизаций.ОрганизацииОСиНМА.Получить(ТекущаяОрганизация) <> Неопределено;
			
			ЕстьОтмеченные   = ЕстьОтмеченные ИЛИ НоваяСтрока.Отметка;
			ЕстьНеотмеченные = ЕстьНеотмеченные ИЛИ НЕ НоваяСтрока.Отметка;
			
		КонецЦикла;
		
		Если НоваяГруппа.ПолучитьЭлементы().Количество() = 0 Тогда
			// В группе нет доступных организаций
			ДеревоОрганизаций.ПолучитьЭлементы().Удалить(НоваяГруппа);
			Продолжить;
		КонецЕсли;
		
		КоличествоГрупп = КоличествоГрупп + 1;
		НаименованиеГруппы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Группа организаций №%1: %2%3%4%5';
				|en = 'Company group No.%1: %2%3%4%5'", ОбщегоНазначения.КодОсновногоЯзыка()),
			СокрЛП(КоличествоГрупп),
			?(ЕстьИнтеркампани, """" + Обработки.ОперацииЗакрытияМесяца.НазваниеГруппыОрганизацийИнтеркампани() + """", ""),
			?(ЕстьИнтеркампани И ЕстьОСиНМА, " " + НСтр("ru = 'и';
														|en = 'and'", ОбщегоНазначения.КодОсновногоЯзыка()) + " ", ""),
			?(ЕстьОСиНМА, """" + Обработки.ОперацииЗакрытияМесяца.НазваниеГруппыОрганизацийОСиНМА() + """", ""),
			?(ЕстьНедоступные, " (" + НСтр("ru = 'нет прав на все организации группы';
											|en = 'no rights to all group companies'", ОбщегоНазначения.КодОсновногоЯзыка()) + ")", ""));
			
		НоваяГруппа.Организация 	 = СокрЛП(НаименованиеГруппы);
		НоваяГруппа.ЭтоГруппа 		 = Истина;
		НоваяГруппа.Отметка 		 = ЕстьОтмеченные;
		НоваяГруппа.ИзменениеОтметки = Истина;
		НоваяГруппа.ЕстьНедоступные  = ЕстьНедоступные;
		
		Если ЕстьОтмеченные И ЕстьНеотмеченные Тогда
			
			Для Каждого ТекущаяОрганизация Из НоваяГруппа.ПолучитьЭлементы() Цикл
				ТекущаяОрганизация.Отметка = Истина;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Запрет выбора отдельных организаций в группах.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОрганизацийОтметка.Имя);
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоОрганизаций.ИзменениеОтметки");
	ОтборЭлемента.ПравоеЗначение = Ложь;
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	// Выделение группы организаций.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОрганизацийОтметка.Имя);
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОрганизацийОрганизация.Имя);
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоОрганизаций.ЭтоГруппа");
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(Элементы.ДеревоОрганизацийОрганизация.Шрифт, , , Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьОтметкиПодчиненныхЭлементов(ЭлементДерева, Отметка)
	
	Для Каждого ПодчиненныйЭлемент Из ЭлементДерева.ПолучитьЭлементы() Цикл
		
		ПодчиненныйЭлемент.Отметка = Отметка;
		
		Если ПодчиненныйЭлемент.ЭтоГруппа Тогда
			СинхронизироватьОтметкиПодчиненныхЭлементов(ПодчиненныйЭлемент, Отметка);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
