
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ИнициализацияФормыПриСозданииНаСервере();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ДанныеКорректны = ЭтапыЗаполненыКорректно();
	Если ДанныеКорректны Тогда
		
		Результат = РезультатЗакрытияФормы();
		Закрыть(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализацияФормыПриСозданииНаСервере()
	
	Подразделение = Параметры.Подразделение;
	Распоряжения.ЗагрузитьЗначения(Параметры.Распоряжения);
	
	Если ЗначениеЗаполнено(Распоряжения) Тогда 
		СвязьПодразделение = Новый СвязьПараметраВыбора("Отбор.Подразделение", "Подразделение");
		СвязьРаспоряжения = Новый СвязьПараметраВыбора("Отбор.Распоряжение", "Распоряжения");
		НовыйМассив = Новый Массив();
		НовыйМассив.Добавить(СвязьПодразделение);
		НовыйМассив.Добавить(СвязьРаспоряжения);
		НовыеСвязи = Новый ФиксированныйМассив(НовыйМассив);
		Элементы.СписокЭтаповЭтап.СвязиПараметровВыбора = НовыеСвязи;
	КонецЕсли;
	
	Для Каждого Этап Из Параметры.Этапы Цикл
		
		СтрокаЗначений = СписокЭтапов.Добавить();
		СтрокаЗначений.Этап = Этап;
		
	КонецЦикла;		
	
КонецПроцедуры

&НаКлиенте
Функция ЭтапыЗаполненыКорректно()
	
	Результат = Истина;
	Ошибки = Неопределено;
	
	Для Каждого Строка Из СписокЭтапов Цикл
		Если Не ЗначениеЗаполнено(Строка.Этап) Тогда
			
			Результат = Ложь;
			
			ИмяПоля = НСтр("ru = 'Этап производства';
							|en = 'Production stage'");
			НомерСтроки = СписокЭтапов.Индекс(Строка);
			ТекстОшибки = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", ИмяПоля, НомерСтроки);
			
			Поле = "СписокЭтапов[%1].Этап";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, ТекстОшибки, Неопределено, НомерСтроки);
			
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция РезультатЗакрытияФормы()
	
	Результат = Новый Массив;
	Для Каждого Строка Из СписокЭтапов Цикл
		Если Результат.Найти(Строка.Этап) = Неопределено Тогда
			Результат.Добавить(Строка.Этап);
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции


#КонецОбласти
