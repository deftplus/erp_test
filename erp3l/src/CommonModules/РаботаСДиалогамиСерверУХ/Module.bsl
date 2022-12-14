
Процедура МножественныйПоискПоДеревуЗначений(МассивНайденныхСтрок, ДеревоЗначений, СтруктураПоиска, ТолькоТекущийУровень = Ложь) Экспорт
	
	Если ТипЗнч(МассивНайденныхСтрок) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы = ДеревоЗначений.ПолучитьЭлементы();
	
	Для Каждого Элемент Из Элементы Цикл
		
		ЗначениеНайдено = Истина;
		
		Для Каждого Условие Из СтруктураПоиска Цикл
			Если Элемент[Условие.Ключ] <> Условие.Значение Тогда
				ЗначениеНайдено = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ЗначениеНайдено Тогда
			
			МассивНайденныхСтрок.Добавить(Элемент);
			
		КонецЕсли;
		
		Если НЕ ТолькоТекущийУровень Тогда
			МножественныйПоискПоДеревуЗначений(МассивНайденныхСтрок, Элемент, СтруктураПоиска, ТолькоТекущийУровень);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьЗначениеВКоллекцию(Значение,КоллекцияЗначений) Экспорт
	
	Если (ТипЗнч(КоллекцияЗначений)=Тип("СписокЗначений") И КоллекцияЗначений.НайтиПоЗначению(Значение)=Неопределено)
		ИЛИ  (ТипЗнч(КоллекцияЗначений)=Тип("Массив") И КоллекцияЗначений.Найти(Значение)=Неопределено) Тогда
		
		КоллекцияЗначений.Добавить(Значение);
		
	КонецЕсли;
		
КонецПроцедуры // ДобавитьЗначениеВКоллекцию() 
		
Функция ВернутьСписокЛистов(ИмяФайла) Экспорт
	
	СписокЛистов = Новый СписокЗначений;
	
	Попытка
		Ексел = Новый COMОбъект("Excel.Application");
		РабочаяКнига  = Ексел.Workbooks.Open(ИмяФайла);
		Ексел.Visible = Ложь;
		Для Инд = 1 По РабочаяКнига.Sheets.Count Цикл
			СписокЛистов.Добавить(Инд, РабочаяКнига.Sheets(Инд).Name, РабочаяКнига.Sheets(Инд).ProtectContents);
		КонецЦикла;
		РабочаяКнига.Close(0);
	Исключение
		ТекстыОшибки = Новый Массив;
		ТекстыОшибки.Добавить("Не удалось открыть файл XLS.");
		ТекстыОшибки.Добавить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ТекстыОшибки.Добавить("Возможные причины ошибки описаны в справке к документу ""Экземпляр отчета"" в разделе ""Импорт""");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрСоединить(ТекстыОшибки, Символы.ПС));
	КонецПопытки;
	
	Если Ексел <> Неопределено Тогда
		Ексел.Quit();
		Ексел = Неопределено;
	КонецЕсли;
	
	Возврат СписокЛистов;
	
КонецФункции

// Возвращает номер картинки в коллекции картинок Организации по типу организации 
// (Копия аналогичной модуля РаботаСДиалогами)
Функция ПолучитьКартинкуСтрокПоТипуОрганизации(ТипОрганизации, ПометкаУдаления = Ложь) Экспорт
	
	Если ТипОрганизации = Перечисления.ТипыОрганизационныхЕдиниц.Консолидирующая Тогда
		Результат = 0;
	ИначеЕсли ТипОрганизации = Перечисления.ТипыОрганизационныхЕдиниц.Элиминирующая Тогда
		Результат = 2;
	ИначеЕсли ТипОрганизации = Перечисления.ТипыОрганизационныхЕдиниц.Обычная Тогда
		Результат = 1;
	Иначе                    
		Результат = 10;
	КонецЕсли;
	
	Результат = Результат + ?(ПометкаУдаления = Истина, 3, 0);
	
	Возврат Результат;
	
КонецФункции
