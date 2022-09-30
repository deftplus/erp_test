
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИмяГрафика = Параметры.ИмяГрафика;
	УникальныйИдентификаторВладельца = Параметры.УникальныйИдентификаторВладельца;
	ЕстьОбеспечительныйПлатеж = Параметры.ЕстьОбеспечительныйПлатеж И ИмяГрафика <> "ГрафикНачисленияПроцентов";
	ЕстьВыкупПредметовАренды = Параметры.ЕстьВыкупПредметовАренды И ИмяГрафика <> "ГрафикНачисленияПроцентов";
	
	ИнициализироватьФорму();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ПоказатьПодтверждениеЗакрытияФормыЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы,, ТекстПредупреждения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьГрафик(Команда)
	
	ВыполнитьЗагрузкуГрафика();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьЗагрузкуГрафика()
	
	АдресГрафика = ЗагрузитьГрафикСервер();
	
	Если АдресГрафика = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Загрузка графика завершена';
										|en = 'Schedule import complete'"),,, БиблиотекаКартинок.Информация32);

	Закрыть(АдресГрафика);
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьГрафикСервер()
	
	ПараметрыЗагрузки = ПараметрыЗагрузки();
	
	НомерСтроки = 2;
	СтроковыйНомер = Формат(НомерСтроки, "ЧН=0; ЧГ=0");
	ПоляЗагрузки = ПараметрыЗагрузки.Поля;
	ЗаполненаДата = ЗначениеЗаполнено(ТабличныйДокумент.Область("R" + СтроковыйНомер + ПоляЗагрузки.Дата).Текст);
	
	ЗагруженоБезОшибок = Истина;
	
	Если ИмяГрафика = "ГрафикОплатУслуг" Тогда
		ЗаписиГрафика = РегистрыСведений.ГрафикОплатУслугПоАренде.СоздатьНаборЗаписей();
	ИначеЕсли ИмяГрафика = "ГрафикНачисленияУслуг" Тогда
		ЗаписиГрафика = РегистрыСведений.ГрафикНачисленияУслугПоАренде.СоздатьНаборЗаписей();
	ИначеЕсли ИмяГрафика = "ГрафикНачисленияПроцентов" Тогда
		ЗаписиГрафика = РегистрыСведений.ГрафикНачисленияПроцентовПоАренде.СоздатьНаборЗаписей();
	Иначе
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Неизвестный график %1';
										|en = 'Unknown schedule %1'"), ИмяГрафика);
	КонецЕсли;
	
	Пока ЗаполненаДата Цикл
		
		ДанныеСтроки = Неопределено;
		Попытка

			ДанныеСтроки = Новый Структура;
			Для Каждого Поле Из ПоляЗагрузки Цикл
				
				ТекстЗначения = ТабличныйДокумент.Область("R" + СтроковыйНомер + Поле.Значение).Текст;
				Если Поле.Ключ = "Дата" Тогда
					ЗначениеПоля = ТекстВДату(ТекстЗначения, СтроковыйНомер, Поле.Ключ);
				Иначе
					ЗначениеПоля = ТекстВЧисло(ТекстЗначения, СтроковыйНомер, Поле.Ключ);
				КонецЕсли;
				ДанныеСтроки.Вставить(Поле.Ключ, ЗначениеПоля);
				
			КонецЦикла;
			
		Исключение
			ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
		Если ЗначениеЗаполнено(ДанныеСтроки) Тогда

			ВсеПоляЗаполнены = ЗначениеЗаполнено(ДанныеСтроки.Дата);
			Если ВсеПоляЗаполнены Тогда
				СуммаПолей = 0;
				Для Каждого Поле Из ПараметрыЗагрузки.ПоляКонтроля Цикл
					СуммаПолей = СуммаПолей + ДанныеСтроки[Поле];
				КонецЦикла;
				Если СуммаПолей = 0 Тогда
					ВсеПоляЗаполнены = Ложь;
					ЗагруженоБезОшибок = Ложь;
					ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось загрузить строку %1, т.к. не заполнены суммы';
													|en = 'Cannot import line %1 because amounts are not filled in'"), СтроковыйНомер);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
				КонецЕсли;
			КонецЕсли;
			
			Если ВсеПоляЗаполнены Тогда
				НоваяЗапись = ЗаписиГрафика.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяЗапись, ДанныеСтроки);
			КонецЕсли;
			
		КонецЕсли;
		
		НомерСтроки = НомерСтроки + 1;
		СтроковыйНомер = Формат(НомерСтроки, "ЧН=0; ЧГ=0");
		
		Попытка
			ЗаполненаДата = ЗначениеЗаполнено(ТабличныйДокумент.Область("R" + СтроковыйНомер + ПоляЗагрузки.Дата).Текст);
		Исключение
			ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	КонецЦикла;
	
	Если ЗагруженоБезОшибок Тогда
		АдресГрафика = ПоместитьВоВременноеХранилище(ЗаписиГрафика.Выгрузить(), УникальныйИдентификаторВладельца);
	Иначе
		АдресГрафика = Неопределено;
	КонецЕсли;
	
	Возврат АдресГрафика;
	
КонецФункции

&НаСервере
Функция ПараметрыЗагрузки()
	
	ПараметрыЗагрузки = Новый Структура;
	ПоляЗагрузки = Новый Структура("Дата", "C1");
	 
	Если ИмяГрафика = "ГрафикНачисленияПроцентов" Тогда
		ПоляЗагрузки.Вставить("Проценты", "C2");
	Иначе
		ПоляЗагрузки.Вставить("УслугаПоАренде", "C2");
	КонецЕсли;
	
	Если ЕстьОбеспечительныйПлатеж Тогда
		ПоляЗагрузки.Вставить("ОбеспечительныйПлатеж", "C3");
	КонецЕсли;
	
	Если ЕстьВыкупПредметовАренды Тогда
		ПоляЗагрузки.Вставить("ВыкупнаяСтоимость", "C4");
	КонецЕсли;
	
	ПараметрыЗагрузки.Вставить("Поля", ПоляЗагрузки);
	
	//
	МассивПолей = Новый Массив;
	
	Если ИмяГрафика = "ГрафикНачисленияПроцентов" Тогда
		МассивПолей.Добавить("Проценты");
	Иначе
		МассивПолей.Добавить("УслугаПоАренде");
	КонецЕсли;
	
	Если ЕстьОбеспечительныйПлатеж Тогда
		МассивПолей.Добавить("ОбеспечительныйПлатеж");
	КонецЕсли;
	
	Если ЕстьВыкупПредметовАренды Тогда
		МассивПолей.Добавить("ВыкупнаяСтоимость");
	КонецЕсли;
	
	ПараметрыЗагрузки.Вставить("ПоляКонтроля", МассивПолей);
	
	Возврат ПараметрыЗагрузки;
	
КонецФункции

&НаСервере
Процедура ИнициализироватьФорму()
	
	ПараметрыЗагрузки = Новый Структура;
	Если ИмяГрафика = "ГрафикНачисленияУслуг" Тогда
		Заголовок = НСтр("ru = 'Загрузка графика начислений';
						|en = 'Import accrual schedule'");
	ИначеЕсли ИмяГрафика = "ГрафикОплатУслуг" Тогда
		Заголовок = НСтр("ru = 'Загрузка графика оплат';
						|en = 'Import payment schedule'");
	ИначеЕсли ИмяГрафика = "ГрафикНачисленияПроцентов" Тогда
		Заголовок = НСтр("ru = 'Загрузка графика процентов';
						|en = 'Importing interest schedule'");
	КонецЕсли;
	
	МакетШаблона = Справочники.ДоговорыАренды.ПолучитьМакет("МакетЗагрузкиГрафиков");
	
	ТабличныйДокумент.Очистить();
	
	ОбластьКолонки = МакетШаблона.ПолучитьОбласть("УслугаПоАренде");
	
	Если ИмяГрафика = "ГрафикНачисленияУслуг" Тогда
		ОбластьКолонки.Параметры.Заголовок = НСтр("ru = 'Услуга по аренде';
													|en = 'Lease service'");
	ИначеЕсли ИмяГрафика = "ГрафикОплатУслуг" Тогда
		ОбластьКолонки.Параметры.Заголовок = НСтр("ru = 'Сумма оплаты услуг по аренде';
													|en = 'Amount of payment for lease services'");
	ИначеЕсли ИмяГрафика = "ГрафикНачисленияПроцентов" Тогда
		ОбластьКолонки.Параметры.Заголовок = НСтр("ru = 'Сумма процентов';
													|en = 'Interest amount'")
	КонецЕсли;
	
	ТабличныйДокумент.Присоединить(ОбластьКолонки);
	
	Если ЕстьОбеспечительныйПлатеж Тогда
		
		ОбластьКолонки = МакетШаблона.ПолучитьОбласть("ОбеспечительныйПлатеж");
		
		ОбластьКолонки.Параметры.Заголовок =
			?(ИмяГрафика = "ГрафикНачисленияУслуг",
				НСтр("ru = 'Сумма зачета обеспечительного платежа';
					|en = 'Security deposit offset amount'"),
				НСтр("ru = 'Сумма обеспечительного платежа';
					|en = 'Security deposit amount'"));
				 
		ТабличныйДокумент.Присоединить(ОбластьКолонки);
	
	КонецЕсли;
	
	Если ЕстьВыкупПредметовАренды Тогда
		
		ОбластьКолонки = МакетШаблона.ПолучитьОбласть("ВыкупнаяСтоимость");
		ОбластьКолонки.Параметры.Заголовок =
			?(ИмяГрафика = "ГрафикНачисленияУслуг",
				НСтр("ru = 'Сумма выкупа предметов аренды';
					|en = 'Amount of lease objects redemption'"),
				НСтр("ru = 'Выкупная стоимость';
					|en = 'Redemption cost'"));	
	
		ТабличныйДокумент.Присоединить(ОбластьКолонки);
	
	КонецЕсли;
	
	ТабличныйДокумент.ФиксацияСверху = 1;
	
КонецПроцедуры

&НаСервере
Процедура СообщитьОбОшибкеПреобразования(НомерСтроки, ИмяКолонки, СтроковоеЗначение)
	
	ШаблонТекста = НСтр("ru = 'Строка №%1 колонка ""%2"" - ошибка преобразования значения ""%3""
		|Строка не загружена.';
		|en = 'Conversion error for value ""%3""
		| in column ""%2"" of line %1. The line is not imported.'");
	Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, НомерСтроки, ИмяКолонки, СтроковоеЗначение);
	ОбщегоНазначения.СообщитьПользователю(Текст);
	
КонецПроцедуры

&НаСервере
Функция ТекстВДату(Знач СтроковоеЗначение, НомерСтроки, ИмяКолонки, Разделитель = ".")
	
	Цифры = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтроковоеЗначение,Разделитель);
	
	Попытка
		Результат = ?(СтрДлина(Цифры[2]) = 2, "20" + Цифры[2], Цифры[2])
			+ Формат(Цифры[1], "ЧЦ=2; ЧВН=;")
			+ Формат(Цифры[0], "ЧЦ=2; ЧВН=;");
		Результат = Дата(Результат);
	Исключение
		СообщитьОбОшибкеПреобразования(НомерСтроки, ИмяКолонки, СтроковоеЗначение);
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ТекстВЧисло(СтроковоеЗначение, НомерСтроки, ИмяКолонки)
	
	Если ПустаяСтрока(СтроковоеЗначение) ИЛИ СтроковоеЗначение = Неопределено Тогда
		Возврат 0;
	КонецЕсли;
	
	Попытка
		Результат = Число(СтрЗаменить(СтроковоеЗначение," ",""));
	Исключение
		СообщитьОбОшибкеПреобразования(НомерСтроки, ИмяКолонки, СтроковоеЗначение);
	КонецПопытки;
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьПодтверждениеЗакрытияФормыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполнитьЗагрузкуГрафика();
	
КонецПроцедуры

#КонецОбласти
