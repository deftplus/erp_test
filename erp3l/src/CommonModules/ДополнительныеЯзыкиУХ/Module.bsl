#Область ПрограммныйИнтерфейс

Функция НомерЯзыкаОтчетности() Экспорт
	Возврат ДополнительныеЯзыкиПовтИспУХ.НомерЯзыкаОтчетности();
КонецФункции

#Область ПодпискиНаСобытия

Процедура ОбработкаПолученияПолейПредставленияЯзыкОбработкаПолученияПолейПредставления(Источник, Поля, СтандартнаяОбработка) Экспорт
	
	ОсновнойЯзык = НомерЯзыкаОтчетности();    	
			
	Если ОсновнойЯзык = 0 Тогда
		Возврат;
	КонецЕсли;
		
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Ссылка");//Для мультиязычности БСП
	Поля.Добавить("Наименование");
	Поля.Добавить("Наименование1");
	Поля.Добавить("Наименование2");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставленияЯзыкОбработкаПолученияПредставления(Источник, Данные, Представление, СтандартнаяОбработка) Экспорт
	
	ОсновнойЯзык = НомерЯзыкаОтчетности();
	
	Если ОсновнойЯзык = 0 Тогда
		Возврат;
	КонецЕсли;
		
	Если НЕ Данные.Свойство("Наименование" + ОсновнойЯзык) Тогда
		Возврат;
	КонецЕсли;	
	
	ТекПредставление = Данные["Наименование" + ОсновнойЯзык];
	
	Если Не ЗначениеЗаполнено(ТекПредставление) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Представление = ТекПредставление;
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставленияСтраныМира(Источник, Поля, СтандартнаяОбработка) Экспорт
	
	ОсновнойЯзык = НомерЯзыкаОтчетности();
	
	Если ОсновнойЯзык = 0 Тогда
		Возврат;
	КонецЕсли;

	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Наименование");
	Поля.Добавить("МеждународноеНаименование");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставленияСтраныМира(Источник, Данные, Представление, СтандартнаяОбработка) Экспорт
	
	ОсновнойЯзык = НомерЯзыкаОтчетности();
	Если ОсновнойЯзык = 0 Тогда
		Возврат;
	КонецЕсли;
		
	Если НЕ Данные.Свойство("МеждународноеНаименование") Тогда
		Возврат;
	ИначеЕсли Не ЗначениеЗаполнено(Данные.МеждународноеНаименование) Тогда 
		Возврат;
	КонецЕсли;	
	
	СтандартнаяОбработка = Ложь;
	Представление = Данные.МеждународноеНаименование;
			
КонецПроцедуры

#КонецОбласти

#Область Общее

Функция ПолучитьТаблицуДополнительныхЯзыков() Экспорт
	
	Возврат Константы.ДополнительныеЯзыкиВыводаОтчета.Получить().Получить();
		
КонецФункции // ПолучитьТаблицуДополнительныхЯзыков() 

#КонецОбласти

#Область СправочникПериоды

Процедура ЗаполнитьНаименованияПериодаПередЗаписью(Источник, Отказ) Экспорт
	
	КодыЯзыков = ДополнительныеЯзыкиПовтИспУХ.ПолучитьКодыЯзыков();
	Для каждого ТекЯзык Из КодыЯзыков Цикл
		НовоеНаименование = "Наименование" + ТекЯзык.Ключ;
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Источник, НовоеНаименование) Тогда
			Если Источник[НовоеНаименование] = "" Тогда
				НовоеПредставлениеПериода = ПредставлениеПериода(Источник.ДатаНачала, КонецДня(Источник.ДатаОкончания), "Л=" + ТекЯзык.Значение);
				Источник[НовоеНаименование] = НовоеПредставлениеПериода;
			КонецЕсли;	    	
		Иначе
			ТекстСообщения = НСтр("ru = 'Наименование для языка ""%КодЯзыка%"" в объекте ""%Объект%"" не найдено'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КодЯзыка%", Строка(ТекЯзык.Значение));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Объект%", Строка(Источник));
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьДопЯзыкиПериодов() Экспорт

	КодыЯзыков = ДополнительныеЯзыкиПовтИспУХ.ПолучитьКодыЯзыков();
	Если КодыЯзыков.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Справочники.Периоды.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если НЕ ЗначениеЗаполнено(Выборка.Наименование1) Тогда
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Выборка.ПолучитьОбъект(), Истина, Ложь);		
		КонецЕсли;		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область Транслит

Функция ПолучитьИспользованиеДопЯзыков(ОтборМетаданныеПолноеИмя = Неопределено) Экспорт
	
	Таб = Новый ТаблицаЗначений;
	Таб.Колонки.Добавить("Наименование");
	Таб.Колонки.Добавить("ТребуетсяПредставление");
	Таб.Колонки.Добавить("ТребуетсяАвтоТранслит");
	Таб.Колонки.Добавить("Использование");
	
	Имена = Новый Структура("Наименование1,Наименование2,ПолученияПолей,Представления,ЗаполнитьПередЗаписью",
			Метаданные.ОбщиеРеквизиты.Наименование1.Состав,
			Метаданные.ОбщиеРеквизиты.Наименование2.Состав,
			Метаданные.ПодпискиНаСобытия.ОбработкаПолученияПолейПредставленияДопЯзык.Источник.Типы(),
			Метаданные.ПодпискиНаСобытия.ОбработкаПолученияПредставленияДопЯзык.Источник.Типы(),
			Метаданные.ПодпискиНаСобытия.ЗаполнитьНаименованияНаДопЯзыкахПередЗаписью.Источник.Типы()
		);
		
		
	ИспользоватьРеквизит = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать;
	Итоги = Новый Массив;						
	Для Каждого ТекИмя Из Имена Цикл
		
		Если ОтборМетаданныеПолноеИмя = Неопределено Тогда
			КоллекцияТипов = ТекИмя.Значение;
		Иначе 
			КоллекцияТипов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОтборМетаданныеПолноеИмя);
		КонецЕсли;
		
		Для Каждого ТекТип Из КоллекцияТипов Цикл
			
			ИспользованиеМД = 1;
			Если ОтборМетаданныеПолноеИмя <> Неопределено Тогда
				
				ПолноеИмяМД = ТекТип;
				Если ТипЗнч(ТекИмя.Значение) = Тип("СоставОбщегоРеквизита") Тогда
					ЭлементСостава = ТекИмя.Значение.Найти(Метаданные.НайтиПоПолномуИмени(ТекТип));
					ИспользованиеМД = ?((ЭлементСостава = Неопределено) Или (ЭлементСостава.Использование <> ИспользоватьРеквизит), 0, 1);
				Иначе 
					
					ИспользованиеМД = 0;
					
					ОбъектМД = Метаданные.НайтиПоПолномуИмени(ТекТип);					
					Если (ОбъектМД <> Неопределено) Тогда
						Если ТекИмя.Значение.Найти(Тип("СправочникОбъект." + ОбъектМД.Имя)) <> Неопределено Тогда
							ИспользованиеМД = 1;
						ИначеЕсли ТекИмя.Значение.Найти(Тип("СправочникМенеджер." + ОбъектМД.Имя)) <> Неопределено Тогда
							ИспользованиеМД = 1;
						КонецЕсли;						
					КонецЕсли;
					
				КонецЕсли;
				
			ИначеЕсли ТипЗнч(ТекТип) = Тип("Тип") Тогда	
				ПолноеИмяМД = Метаданные.НайтиПоТипу(ТекТип).ПолноеИмя();
			ИначеЕсли ТекТип.Использование = ИспользоватьРеквизит Тогда
				ПолноеИмяМД = ТекТип.Метаданные.ПолноеИмя();
			Иначе 
				Продолжить;
			КонецЕсли;
			
			Стр = Таб.Добавить();
			Стр.Использование = ИспользованиеМД;
			Стр.Наименование = ПолноеИмяМД;
						
		КонецЦикла;
		
		Таб.Колонки.Использование.Имя = ТекИмя.Ключ;
		Итоги.Добавить(ТекИмя.Ключ);
		Таб.Колонки.Добавить("Использование");
		
	КонецЦикла;							
	
	Таб.Свернуть("Наименование", СтрСоединить(Итоги, ","));
	
	Возврат Таб;

КонецФункции

Процедура ЗаполнитьНаименованияНаДопЯзыкахПередЗаписью(Источник, Отказ) Экспорт
	
	КодыЯзыков = ДополнительныеЯзыкиПовтИспУХ.ПолучитьКодыЯзыков();
	Если КодыЯзыков.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеЯзыкиПовтИспУХ.ТребуетсяТранслит(Новый (ТипЗнч(Источник.Ссылка))) Тогда
		Возврат;
	КонецЕсли;

	СтрокаТранслитом = СтроковыеФункцииКлиентСервер.СтрокаЛатиницей(Источник.Наименование);
	Для каждого ТекЯзык Из КодыЯзыков Цикл
		Если Источник["Наименование" + ТекЯзык.Ключ] = "" Тогда
			Источник["Наименование" + ТекЯзык.Ключ] = СтрокаТранслитом;
		КонецЕсли;	    	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ВидыОтчетовБланки

Функция ПолучитьЗаголовкиНаименование() Экспорт
	
	СтруктураНаименование=Новый Структура;	
		
	СтруктураНаименование.Вставить("Наименование",Нстр("ru = 'Наименование';en = 'Name'")+" ("+Метаданные.ОсновнойЯзык.КодЯзыка+")");
	ТаблицаЯзыков=ПолучитьТаблицуДополнительныхЯзыков();
	
	Для Каждого Строка ИЗ ТаблицаЯзыков Цикл
		
		СтруктураНаименование.Вставить("Наименование"+Строка.ПорядковыйНомер,Нстр("ru = 'Наименование';en = 'Name'")+" ("+Строка.КодЯзыка+")");
		
	КонецЦикла;
	
	Возврат СтруктураНаименование;
	
КонецФункции // ПолучитьЗаголовкиНаименование()

Процедура УстановитьЗаголовкиДопЯзыков(Форма) Экспорт
	
	МассивРеквизитов=Новый Массив;
	МассивРеквизитов.Добавить("Наименование");
	МассивРеквизитов.Добавить("Наименование1");
	МассивРеквизитов.Добавить("Наименование2");
		
	СтруктураЗаголовков=ПолучитьЗаголовкиНаименование();
	
	Для Каждого Реквизит ИЗ МассивРеквизитов Цикл
		
		Если СтруктураЗаголовков.Свойство(Реквизит) Тогда
			
			Форма.Элементы[Реквизит].Заголовок=СтруктураЗаголовков[Реквизит];
			
		Иначе
			
			Форма.Элементы[Реквизит].Видимость=Ложь;
			
		КонецЕсли;
		
	КонецЦикла;	
	
	
КонецПроцедуры // УстановитьЗаголовкиДопЯзыков() 

Процедура ПеревестиТекстыОбластей(ТабДок,НомерИсходногоЯзыка,НомерНовогоЯзыка,ВидОтчета=Неопределено,ТекТаблицаЯзыков=Неопределено) Экспорт
	
	Если НомерНовогоЯзыка=НомерИсходногоЯзыка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВидОтчета) Тогда
		
		Результат=ПолучитьРезультатЗапросаСУчетомРеквизитов(ТабДок,НомерИсходногоЯзыка,НомерНовогоЯзыка,ВидОтчета,ТекТаблицаЯзыков);
		
	Иначе
		
		Результат=ПолучитьРезультатЗапросаБезУчетаРеквизитов(ТабДок,НомерИсходногоЯзыка,НомерНовогоЯзыка,ТекТаблицаЯзыков);
		
	КонецЕсли;
					
	Пока Результат.Следующий() Цикл
		
		Если ПустаяСтрока(Результат.НаименованиеНовое) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Если НЕ ПустаяСтрока(Результат.ИмяОбласти) Тогда
			
			ТекОбласть=ТабДок.Области.Найти(Результат.ИмяОбласти);
			Если  ТекОбласть.Расшифровка = Неопределено  Тогда		
				ТекОбласть.Текст=Результат.НаименованиеНовое;
			КонецЕсли;	
		Иначе
			
			ТекОбласть=ТабДок.НайтиТекст(Результат.НаименованиеИсходное);
			
			Пока ТекОбласть<>Неопределено Цикл	
				Если  ТекОбласть.Расшифровка = Неопределено  Тогда 
					ТекОбласть.Текст=Результат.НаименованиеНовое;
				КонецЕсли;		
				ТекОбласть=ТабДок.НайтиТекст(Результат.НаименованиеИсходное,ТекОбласть);		
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
					
КонецПроцедуры // ПеревестиТекстыОбластей() 

Функция ПолучитьРезультатЗапросаСУчетомРеквизитов(ТабДок,НомерИсходногоЯзыка,НомерНовогоЯзыка,ВидОтчета,ТекТаблицаЯзыков=Неопределено)
	
	НаименованиеНовое		= "Наименование"	+?(НомерНовогоЯзыка=0,"",	НомерНовогоЯзыка);	
	НаименованиеИсходное	= "Наименование"	+?(НомерИсходногоЯзыка=0,"",НомерИсходногоЯзыка);
	
	ТабНаименованиеРеквизит=Новый ТаблицаЗначений;
	ТабНаименованиеРеквизит.Колонки.Добавить("ИмяОбласти",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСтроки(30));
	ТабНаименованиеРеквизит.Колонки.Добавить("НаименованиеНовое",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСтроки(500));
	
	ТекстыОбластей=Новый ТаблицаЗначений;
	ТекстыОбластей.Колонки.Добавить("НаименованиеИсходное",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСтроки(500));
	
	ТекстыОбластейРеквизит=Новый ТаблицаЗначений;  // Тексты областей, связанных со строками и колонками
	ТекстыОбластейРеквизит.Колонки.Добавить("ИмяОбласти",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСтроки(30));
	ТекстыОбластейРеквизит.Колонки.Добавить("НаименованиеИсходное",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСтроки(500));
	
	Для НомСтр=1 По ТабДок.ВысотаТаблицы Цикл
		
		Для НомКол=1 ПО ТабДок.ШиринаТаблицы Цикл
			
			ТекОбласть=ТабДок.Область(НомСтр,НомКол,НомСтр,НомКол);
			
			Если ПустаяСтрока(ТекОбласть.Текст) ИЛИ ТекОбласть.СодержитЗначение Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			Если СтрНайти(ТекОбласть.Имя,"Строка_") ИЛИ СтрНайти(ТекОбласть.Имя,"Колонка_") ИЛИ ТипЗнч(ТекОбласть.Расшифровка) = Тип("Структура")  Тогда
				
				НоваяСтрока=ТекстыОбластейРеквизит.Добавить();
				НоваяСтрока.ИмяОбласти			= ТекОбласть.Имя;
				НоваяСтрока.НаименованиеИсходное= ТекОбласть.Текст;
				
			Иначе	
								
				НоваяСтрока						= ТекстыОбластей.Добавить();
				НоваяСтрока.НаименованиеИсходное= ТекОбласть.Текст;
				
			КонецЕсли;
				
		КонецЦикла;
		
	КонецЦикла;
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	""Строка_"" + СтрокиОтчетов.Код КАК ИмяОбласти,
	|	СтрокиОтчетов."+НаименованиеНовое+" КАК НаименованиеНовое
	|ИЗ
	|	Справочник.СтрокиОтчетов КАК СтрокиОтчетов
	|ГДЕ
	|	НЕ СтрокиОтчетов.ПометкаУдаления
	|	И СтрокиОтчетов.Владелец = &ВидОтчета
	|	И НЕ СтрокиОтчетов."+НаименованиеНовое+" = """"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Колонка_"" + КолонкиОтчетов.Код,
	|	КолонкиОтчетов."+НаименованиеНовое+"
	|ИЗ
	|	Справочник.КолонкиОтчетов КАК КолонкиОтчетов
	|ГДЕ
	|	НЕ КолонкиОтчетов.ПометкаУдаления
	|	И КолонкиОтчетов.Владелец = &ВидОтчета
	|	И НЕ КолонкиОтчетов."+НаименованиеНовое+" = """"";
	
	Запрос.УстановитьПараметр("ВидОтчета",ВидОтчета);
	Результат=Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		НоваяСтрока=ТабНаименованиеРеквизит.Добавить();
		НоваяСтрока.ИмяОбласти=СокрЛП(Результат.ИмяОбласти);
		НоваяСтрока.НаименованиеНовое=Результат.НаименованиеНовое;
		
	КонецЦикла;
	
	Запрос.Текст="ВЫБРАТЬ
	|	ТабНаименованиеРеквизит.ИмяОбласти КАК ИмяОбласти,
	|	ТабНаименованиеРеквизит.НаименованиеНовое КАК НаименованиеНовое
	|ПОМЕСТИТЬ ТабНаименованиеРеквизит
	|ИЗ
	|	&ТабНаименованиеРеквизит КАК ТабНаименованиеРеквизит
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТабНаименованиеРеквизит.ИмяОбласти
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекстыОбластейРеквизит.ИмяОбласти КАК ИмяОбласти,
	|	ТекстыОбластейРеквизит.НаименованиеИсходное КАК НаименованиеИсходное
	|ПОМЕСТИТЬ ТекстыОбластейРеквизит
	|ИЗ
	|	&ТекстыОбластейРеквизит КАК ТекстыОбластейРеквизит
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТекстыОбластейРеквизит.ИмяОбласти
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекстыОбластей.НаименованиеИсходное КАК НаименованиеИсходное
	|ПОМЕСТИТЬ ТекстыОбластей
	|ИЗ
	|	&ТекстыОбластей КАК ТекстыОбластей
	|;
	|";
	
	Если НЕ ТекТаблицаЯзыков=Неопределено Тогда
		
		Запрос.Текст=Запрос.Текст+"
		
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТекТаблицаЯзыков."+НаименованиеИсходное+" КАК НаименованиеИсходное,
		|	ТекТаблицаЯзыков."+НаименованиеНовое+" КАК НаименованиеНовое
		|ПОМЕСТИТЬ ТекущийСловарь
		|ИЗ
		|	&ТекТаблицаЯзыков КАК ТекТаблицаЯзыков
		|;";
		
		Запрос.УстановитьПараметр("ТекТаблицаЯзыков",ТекТаблицаЯзыков);
		
	Иначе
		
		Запрос.Текст=Запрос.Текст+"
		
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТекстыНаДополнительныхЯзыках."+НаименованиеИсходное+" КАК НаименованиеИсходное,
		|	ТекстыНаДополнительныхЯзыках."+НаименованиеНовое+" КАК НаименованиеНовое
		|ПОМЕСТИТЬ ТекущийСловарь
		|ИЗ
		|	РегистрСведений.ТекстыНаДополнительныхЯзыках КАК ТекстыНаДополнительныхЯзыках
		|;";
		
	КонецЕсли;
	
	Запрос.Текст=Запрос.Текст+"
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекстыОбластейРеквизит.ИмяОбласти КАК ИмяОбласти,
	|	ТекстыОбластейРеквизит.НаименованиеИсходное КАК НаименованиеИсходное,
	|	ВЫБОР
	|		КОГДА ТабНаименованиеРеквизит.НаименованиеНовое ЕСТЬ NULL
	|			ТОГДА ЕСТЬNULL(ТекущийСловарь.НаименованиеНовое, """")
	|		ИНАЧЕ ТабНаименованиеРеквизит.НаименованиеНовое
	|	КОНЕЦ КАК НаименованиеНовое
	|ИЗ
	|	ТекстыОбластейРеквизит КАК ТекстыОбластейРеквизит
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТабНаименованиеРеквизит КАК ТабНаименованиеРеквизит
	|		ПО ТекстыОбластейРеквизит.ИмяОбласти = ТабНаименованиеРеквизит.ИмяОбласти
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТекущийСловарь КАК ТекущийСловарь
	|		ПО ТекстыОбластейРеквизит.НаименованиеИсходное = ТекущийСловарь.НаименованиеИсходное
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ Различные
	|	"""",
	|	ТекстыОбластей.НаименованиеИсходное,
	|	ЕСТЬNULL(ТекущийСловарь.НаименованиеНовое, """")
	|ИЗ
	|	ТекстыОбластей КАК ТекстыОбластей 
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТекущийСловарь КАК ТекущийСловарь
	|		ПО ТекстыОбластей.НаименованиеИсходное = ТекущийСловарь.НаименованиеИсходное";
	
	Запрос.УстановитьПараметр("ТабНаименованиеРеквизит",ТабНаименованиеРеквизит);
	Запрос.УстановитьПараметр("ТекстыОбластейРеквизит",	ТекстыОбластейРеквизит);
	Запрос.УстановитьПараметр("ТекстыОбластей",			ТекстыОбластей);

	Результат=Запрос.Выполнить().Выбрать();
	
	Возврат Результат;
		
КонецФункции // ПолучитьРезультатЗапросаСУчетомРеквизитов()

Функция ПолучитьРезультатЗапросаБезУчетаРеквизитов(ТабДок,НомерИсходногоЯзыка,НомерНовогоЯзыка,ТекТаблицаЯзыков=Неопределено) Экспорт
	
	НаименованиеНовое		= "Наименование"	+?(НомерНовогоЯзыка=0,"",	НомерНовогоЯзыка);	
	НаименованиеИсходное	= "Наименование"	+?(НомерИсходногоЯзыка=0,"",НомерИсходногоЯзыка);
		
	ТекстыОбластей=Новый ТаблицаЗначений;
	ТекстыОбластей.Колонки.Добавить("НаименованиеИсходное",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСтроки(500));
	
	Для НомСтр=1 По ТабДок.ВысотаТаблицы Цикл
		
		Для НомКол=1 ПО ТабДок.ШиринаТаблицы Цикл
			
			ТекОбласть=ТабДок.Область(НомСтр,НомКол,НомСтр,НомКол);
			
			Если ПустаяСтрока(ТекОбласть.Текст) ИЛИ ТекОбласть.СодержитЗначение ИЛИ ТипЗнч(ТекОбласть.Расшифровка) = Тип("Структура")  Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			НоваяСтрока						= ТекстыОбластей.Добавить();
			НоваяСтрока.НаименованиеИсходное= ТекОбласть.Текст;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Запрос=Новый Запрос;
	
	Запрос.Текст="ВЫБРАТЬ
	|	ТекстыОбластей.НаименованиеИсходное КАК НаименованиеИсходное
	|ПОМЕСТИТЬ ТекстыОбластей
	|ИЗ
	|	&ТекстыОбластей КАК ТекстыОбластей";
	
	Если НЕ ТекТаблицаЯзыков=Неопределено Тогда
		
		Запрос.Текст=Запрос.Текст+"
		
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТекТаблицаЯзыков."+НаименованиеИсходное+" КАК НаименованиеИсходное,
		|	ТекТаблицаЯзыков."+НаименованиеНовое+" КАК НаименованиеНовое
		|ПОМЕСТИТЬ ТекущийСловарь
		|ИЗ
		|	&ТекТаблицаЯзыков КАК ТекТаблицаЯзыков
		|;";
		
		Запрос.УстановитьПараметр("ТекТаблицаЯзыков",ТекТаблицаЯзыков);
		
	Иначе
		
		Запрос.Текст=Запрос.Текст+"
		
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТекстыНаДополнительныхЯзыках."+НаименованиеИсходное+" КАК НаименованиеИсходное,
		|	ТекстыНаДополнительныхЯзыках."+НаименованиеНовое+" КАК НаименованиеНовое
		|ПОМЕСТИТЬ ТекущийСловарь
		|ИЗ
		|	РегистрСведений.ТекстыНаДополнительныхЯзыках КАК ТекстыНаДополнительныхЯзыках
		|;";
		
	КонецЕсли;
	
	Запрос.Текст=Запрос.Текст+"
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ Различные
	|	"""" КАК ИмяОбласти,
	|	ТекстыОбластей.НаименованиеИсходное,
	|	ЕСТЬNULL(ТекущийСловарь.НаименованиеНовое, """")
	|ИЗ
	|	ТекстыОбластей КАК ТекстыОбластей 
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТекущийСловарь КАК ТекущийСловарь
	|		ПО ТекстыОбластей.НаименованиеИсходное = ТекущийСловарь.НаименованиеИсходное";
	
	Запрос.УстановитьПараметр("ТекстыОбластей",			ТекстыОбластей);

	Результат=Запрос.Выполнить().Выбрать();
	
	Возврат Результат;
		
КонецФункции // ПолучитьРезультатЗапросаСУчетомРеквизитов()

Функция ЗагрузитьТаблицуТекстовИзExcel(АдресХранилища, ИмяЛиста, Расширение) Экспорт
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Расширение);
	
	Попытка
		
		ПолучитьИзВременногоХранилища(АдресХранилища).Записать(ИмяВременногоФайла);
		Excel_Настройки = Неопределено;
		ExcelApplication = ОбщегоНазначенияMicrosoftExcelКлиентСерверУХ.Создать(Excel_Настройки);
		
		Если ExcelApplication = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'Не удалось создать COM-объект Microsoft Excel.'");
		КонецЕсли;
		
		Workbook = ExcelApplication.Workbooks.Open(ИмяВременногоФайла);
		
		Если ПустаяСтрока(ИмяЛиста) Тогда
			Если Workbook.Sheets.Count = 1 Тогда
				Sheet = Workbook.Sheets(1);
			Иначе
				ВызватьИсключение НСтр("ru = 'Не указано имя листа файла Microsoft Excel'");
			КонецЕсли;
		Иначе
			Sheet = Workbook.Sheets(ИмяЛиста);
		КонецЕсли;
		
		ВсегоКолонок = Sheet.UsedRange.Column + Sheet.UsedRange.Columns.Count - 1;
		ВсегоСтрок = Sheet.UsedRange.Row + Sheet.UsedRange.Rows.Count - 1;
		
		ТаблицаДанных=Новый ТаблицаЗначений;		
		
		Для Индекс=(Sheet.UsedRange.Column) ПО ВсегоКолонок Цикл
			
			ИмяКолонки=Sheet.Cells(Sheet.UsedRange.Row, Индекс).Text;
			
			ТаблицаДанных.Колонки.Добавить(ИмяКолонки,ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСтроки(500));
			
		КонецЦикла;
		
		Если ТаблицаДанных.Колонки.Найти("Наименование")=Неопределено Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Не удалось определить колонку наименования на основном языке. Она должна иметь заголовок ""Наименование""!'");
			Сообщение.Сообщить();
			
			Возврат Неопределено;
			
		КонецЕсли;
		
		МассивДанных=Sheet.Range(Sheet.Cells(Sheet.UsedRange.Row+1, Sheet.UsedRange.Column),Sheet.Cells(ВсегоСтрок,ВсегоКолонок)).Value.Unload();
		
		Для НомСтр=1 ПО МассивДанных[0].Количество() Цикл
			
			НоваяСтрока=ТаблицаДанных.Добавить();
			
		КонецЦикла;
		
		Для НомКол=0 ПО МассивДанных.Количество()-1 Цикл
			
			ТаблицаДанных.ЗагрузитьКолонку(МассивДанных[НомКол],НомКол);
			
		КонецЦикла;
			
	Исключение
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не удалось загрузить данные из файла: !'"+ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Сообщение.Сообщить();
		
		Возврат Неопределено;
		
	КонецПопытки;
	
	ОбщегоНазначенияMicrosoftExcelКлиентСерверУХ.Закрыть(ExcelApplication, Excel_Настройки);
	
	Sheet 		= Неопределено; 
	Workbook 	= Неопределено;
	
	Попытка
		РаботаСФайламиУХ.УдалитьФайлыАсинхронно(ИмяВременногоФайла);
	Исключение
	КонецПопытки;
	
	Возврат ТаблицаДанных;
		
КонецФункции // ДанныеИмпортироватьНаСервере()

Процедура ЗаписатьДанныеВРегистрТекстов(ТаблицаДанных) Экспорт
	
	МассивРеквизитоа=Новый Массив;
	
	Для Каждого Колонка ИЗ ТаблицаДанных.Колонки Цикл
		
		Если Колонка.Имя="Наименование1" ИЛИ Колонка.Имя="Наименование2"  Тогда
			
			МассивРеквизитоа.Добавить(Колонка.Имя);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого СтрокаТекст ИЗ ТаблицаДанных Цикл
		
		НаборЗаписей=РегистрыСведений.ТекстыНаДополнительныхЯзыках.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Наименование.Установить(СтрокаТекст.Наименование);
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество()=1 Тогда
			
			СтрокаЗаписи=НаборЗаписей[0];
			
		Иначе
			
			СтрокаЗаписи=НаборЗаписей.Добавить();
			СтрокаЗаписи.Наименование=СтрокаТекст.Наименование;
			
		КонецЕсли;
		
		Для Каждого Реквизит ИЗ МассивРеквизитоа Цикл
			
			СтрокаЗаписи[Реквизит]=СтрокаТекст[Реквизит];
			
		КонецЦикла;
		
		НаборЗаписей.Записать(Истина);
		
	КонецЦикла;	
	
КонецПроцедуры // ЗаписатьДанныеВРегистрТекстов()

Процедура ЗаполнитьПредставленияНаДопЯзыках(ТабДопЯзыки, Наименование) Экспорт
	ТабДопЯзыки = ПолучитьПредставленияНаДопЯзыках(Наименование);
КонецПроцедуры

Функция ПолучитьПредставленияНаДопЯзыках(Наименование) Экспорт
	
	СтруктураДопЯзыков=Новый Структура("Наименование1,Наименование2");
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	ТекстыНаДополнительныхЯзыках.Наименование1 КАК Наименование1,
	|	ТекстыНаДополнительныхЯзыках.Наименование2 КАК Наименование2
	|ИЗ
	|	РегистрСведений.ТекстыНаДополнительныхЯзыках КАК ТекстыНаДополнительныхЯзыках
	|ГДЕ
	|	ТекстыНаДополнительныхЯзыках.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Наименование",Наименование);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(СтруктураДопЯзыков,Результат);
		
	КонецЕсли;
	
	Возврат СтруктураДопЯзыков;
		
КонецФункции // ПолучитьПредставленияНаДопЯзыках() 

Функция ПолучитьУникальныеИменаОбластей(ВидОтчета=Неопределено) Экспорт
	
	ТаблицаОбластей=Новый ТаблицаЗначений;
	ТаблицаОбластей.Колонки.Добавить("Наименование",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСтроки(500));
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	БланкиОтчетов.Макет КАК Макет
	|ИЗ
	|	Справочник.БланкиОтчетов КАК БланкиОтчетов
	|ГДЕ
	|	БланкиОтчетов.Мультиязычный";
	
	Если ЗначениеЗаполнено(ВидОтчета) Тогда
		
		Запрос.Текст=Запрос.Текст+"
		|И БланкиОтчетов.Владелец=&ВидОтчета";
		
		Запрос.УстановитьПараметр("ВидОтчета",ВидОтчета);
		
	КонецЕсли;
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		ТабДок=Результат.Макет.Получить();
		
		Если НЕ ТипЗнч(ТабДок)=Тип("ТабличныйДокумент") Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Для НомСтр=1 По ТабДок.ВысотаТаблицы Цикл
			
			Для НомКол=1 ПО ТабДок.ШиринаТаблицы Цикл
				
				ТекОбласть=ТабДок.Область(НомСтр,НомКол,НомСтр,НомКол);
				
				Если ПустаяСтрока(ТекОбласть.Текст) ИЛИ ТекОбласть.СодержитЗначение Тогда
					
					Продолжить;
					
				КонецЕсли;
				
				НоваяСтрока	= ТаблицаОбластей.Добавить();
				НоваяСтрока.Наименование= ТекОбласть.Текст;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ТаблицаОбластей.Свернуть("Наименование");
	
	Возврат ТаблицаОбластей;	
	
КонецФункции // ПолучитьУникальныеИменаОбластей() 

#КонецОбласти

#Область ОсновнойЯзыкНаФорме

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт

	Элементы = Форма.Элементы;
	
	Пользователь = Пользователи.СвойстваПользователяИБ(Форма.Объект.ИдентификаторПользователяИБ);
	Если Пользователь = Неопределено Тогда
	    ОсновнойЯзыкУХ = 0;
	Иначе	
		ОсновнойЯзыкУХ = ОбщегоНазначенияУХ.ПолучитьЗначениеПоУмолчанию("ОсновнойЯзык", Пользователь.Имя);
	КонецЕсли;
	
	ТаблицаЯзыков = ОбщегоНазначенияУХ.ПолучитьЗначениеПеременной("глТаблицаЯзыков");

	Если ТаблицаЯзыков.Найти(ОсновнойЯзыкУХ, "ПорядковыйНомер") = Неопределено Тогда
		ОсновнойЯзыкУХ = 0;
	КонецЕсли;
	
	Элементы.ОсновнойЯзыкУХ.СписокВыбора.Очистить();
	Элементы.ОсновнойЯзыкУХ.СписокВыбора.Добавить(0, "Основной язык");
	Для Каждого Строка Из ТаблицаЯзыков Цикл
		Элементы.ОсновнойЯзыкУХ.СписокВыбора.Добавить(Строка.ПорядковыйНомер, Строка.НаименованиеЯзыка);
	КонецЦикла;
	
	Элементы.ОсновнойЯзыкУХ.ТолькоПросмотр = (Элементы.ОсновнойЯзыкУХ.СписокВыбора.Количество() < 2); 
	
	Форма.ОсновнойЯзыкУХ = ОсновнойЯзыкУХ;

КонецПроцедуры

Процедура ПриЗаписиНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт

	ОбщегоНазначенияУХ.УстановитьЗначениеПоУмолчанию("ОсновнойЯзык", Форма.ОсновнойЯзыкУХ, ТекущийОбъект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

