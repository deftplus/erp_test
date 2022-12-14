//++ Устарело_Производство21
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура рассчитывает и записывает итог запланированных этапов по распоряжению
//  в регистр ГрафикЭтаповПроизводства (в регистр записи пишутся только из этого модуля).
//  Рассчитанные записи записываются под распоряжение.
//  Отрицательные остатки в регистр не пишутся.
//
// Параметры:
//  ПараметрыРасчета			 - Структура		 - Параметры расчета
//  ПорцияДанных				 - ТаблицаЗначений	 - Порция данных
//  ВызовИзОбработчикаОбновления - Булево			 - Признак, если вызов идет из обработчика обновления.
//
Процедура РассчитатьИтогиРегистраГрафикЭтаповПроизводства(ПараметрыРасчета, Знач ПорцияДанных, ВызовИзОбработчикаОбновления = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = "
		|ВЫБРАТЬ
		|	Таблица.Распоряжение                         КАК Распоряжение,
		|	Таблица.КодСтрокиПродукция                   КАК КодСтрокиПродукция,
		|	Таблица.КодСтрокиЭтапыГрафик                 КАК КодСтрокиЭтапыГрафик,
		|	Таблица.Этап                                 КАК Этап,
		|	Таблица.Подразделение                        КАК Подразделение,
		|	МИНИМУМ(Таблица.ПроизводствоНаСтороне)       КАК ПроизводствоНаСтороне,
		|	МИНИМУМ(Таблица.НачалоЭтапа)                 КАК НачалоЭтапа,
		|	СУММА(Таблица.ЗапланированоЗаказом)
		|	 - СУММА(Таблица.ЗапланированоПроизводством)
		|	 - СУММА(Таблица.КВыполнению)
		|	 - СУММА(Таблица.Выполнено)
		|	 - СУММА(Таблица.Брак)                       КАК Запланировано,
		|	СУММА(Таблица.ЗапланированоЗаказом)
		|	 - СУММА(Таблица.КВыполнению)
		|	 - СУММА(Таблица.Выполнено)
		|	 - СУММА(Таблица.Брак)                       КАК КВыполнению
		|
		|ИЗ
		|	РегистрНакопления.ЭтапыПроизводства КАК Таблица
		|
		|ГДЕ
		|	&ОсновнойОтбор
		|	И Таблица.Активность
		|
		|СГРУППИРОВАТЬ ПО
		|	Таблица.Распоряжение,
		|	Таблица.КодСтрокиПродукция,
		|	Таблица.КодСтрокиЭтапыГрафик,
		|	Таблица.Этап,
		|	Таблица.Подразделение
		|
		|УПОРЯДОЧИТЬ ПО
		|	Распоряжение,
		|	КодСтрокиПродукция,
		|	КодСтрокиЭтапыГрафик,
		|	Этап,
		|	Подразделение";
		
	// Определим основной отбор
	
	ТекстТаблицаОтбора = "";
	ТекстОсновнойОтбор = "";
	
	Если ПорцияДанных.Количество() <> 1 Тогда
		
		Запрос.УстановитьПараметр("ПорцияДанных", ПорцияДанных);
		
		Если ПараметрыРасчета.ПоЗаказу Тогда
			
				ТекстТаблицаОтбора = 
					"ВЫБРАТЬ
					|	Т.Распоряжение КАК Распоряжение
					|ПОМЕСТИТЬ ВТ_ПорцияДанных
					|ИЗ
					|	&ПорцияДанных КАК Т
					|;";
					
				ТекстОсновнойОтбор = 
					"(Таблица.Распоряжение)
					|	В	(
					|			ВЫБРАТЬ
					|				Т.Распоряжение КАК Распоряжение
					|			ИЗ
					|				ВТ_ПорцияДанных КАК Т
					|		)
					|";
					
		Иначе
			
			ТекстТаблицаОтбора = 
				"ВЫБРАТЬ
				|	Т.Распоряжение         КАК Распоряжение,
				|	Т.КодСтрокиПродукция   КАК КодСтрокиПродукция,
				|	Т.КодСтрокиЭтапыГрафик КАК КодСтрокиЭтапыГрафик
				|ПОМЕСТИТЬ ВТ_ПорцияДанных
				|ИЗ
				|	&ПорцияДанных КАК Т
				|;";
				
			ТекстОсновнойОтбор = 
				"(Таблица.Распоряжение, КодСтрокиПродукция, КодСтрокиЭтапыГрафик)
				|	В	(
				|			ВЫБРАТЬ
				|				Т.Распоряжение         КАК Распоряжение,
				|				Т.КодСтрокиПродукция   КАК КодСтрокиПродукция,
				|				Т.КодСтрокиЭтапыГрафик КАК КодСтрокиЭтапыГрафик
				|			ИЗ
				|				ВТ_ПорцияДанных КАК Т
				|		)
				|";
				
		КонецЕсли;
		
	Иначе
		
		Запрос.УстановитьПараметр("Распоряжение", ПорцияДанных[0].Распоряжение);
		
		ТекстОсновнойОтбор = "Таблица.Распоряжение = &Распоряжение";
		
		Если НЕ ПараметрыРасчета.ПоЗаказу Тогда
			
			Запрос.УстановитьПараметр("КодСтрокиПродукция", ПорцияДанных[0].КодСтрокиПродукция);
			Запрос.УстановитьПараметр("КодСтрокиЭтапыГрафик", ПорцияДанных[0].КодСтрокиЭтапыГрафик);
			
			ТекстОсновнойОтбор = ТекстОсновнойОтбор + "
				|И Таблица.КодСтрокиПродукция = &КодСтрокиПродукция
				|И Таблица.КодСтрокиЭтапыГрафик = &КодСтрокиЭтапыГрафик";
			
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос.Текст = ТекстТаблицаОтбора + СтрЗаменить(ТекстЗапроса, "&ОсновнойОтбор", ТекстОсновнойОтбор);
	
	РезультатЗапроса     = Запрос.Выполнить();
	ЕстьДанныеДляРасчета = НЕ РезультатЗапроса.Пустой(); 
	
	НаборЗаписей = РегистрыСведений.ГрафикЭтаповПроизводства.СоздатьНаборЗаписей();
	
	// Рассчитаем итоги по графику этапов производства.
	Если ЕстьДанныеДляРасчета Тогда
		
		Если ПараметрыРасчета.ПоЗаказу Тогда
			
			ГрафикЭтапов = НаборЗаписей.ВыгрузитьКолонки();
			ГрафикЭтапов.Индексы.Добавить("КодСтрокиПродукция, КодСтрокиЭтапыГрафик");
			
		КонецЕсли;
		
		Выборка            = РезультатЗапроса.Выбрать();
		ЕстьЗаписиВВыборке = Выборка.Следующий();
		
		Пока ЕстьЗаписиВВыборке Цикл
			
			НаборЗаписей.Отбор.Сбросить();
			
			// Заполнение набора
			Если ПараметрыРасчета.ПоЗаказу Тогда
				
				ТекРаспоряжение = Выборка.Распоряжение;
				
				КлючПорцииДанных = Новый Структура;
				КлючПорцииДанных.Вставить("Распоряжение", ТекРаспоряжение);
				
				НаборЗаписей.Отбор.Распоряжение.Установить(ТекРаспоряжение);
				
				Пока ЕстьЗаписиВВыборке И Выборка.Распоряжение = ТекРаспоряжение Цикл
					
					ДобавитьЗаписьВГрафикЭтапов(ГрафикЭтапов, Выборка);
					
					ЕстьЗаписиВВыборке = Выборка.Следующий();
					
				КонецЦикла;
				
				Если ПараметрыРасчета.ТребуетсяПроверкаГрафика Тогда
					ОтметитьЭтапыТребующиеПерепланирования(ТекРаспоряжение, ГрафикЭтапов);
				КонецЕсли;
				
				НаборЗаписей.Загрузить(ГрафикЭтапов);
				ГрафикЭтапов.Очистить();
				
				ЗаписатьГрафикЭтапов(НаборЗаписей, ТекРаспоряжение, ВызовИзОбработчикаОбновления);
				
			Иначе
				
				КлючПорцииДанных = Новый Структура;
				КлючПорцииДанных.Вставить("Распоряжение", Выборка.Распоряжение);
				КлючПорцииДанных.Вставить("КодСтрокиПродукция", Выборка.КодСтрокиПродукция);
				КлючПорцииДанных.Вставить("КодСтрокиЭтапыГрафик", Выборка.КодСтрокиЭтапыГрафик);
				
				НаборЗаписей.Отбор.Распоряжение.Установить(Выборка.Распоряжение);
				НаборЗаписей.Отбор.КодСтрокиПродукция.Установить(Выборка.КодСтрокиПродукция);
				НаборЗаписей.Отбор.КодСтрокиЭтапыГрафик.Установить(Выборка.КодСтрокиЭтапыГрафик);
				
				ДобавитьЗаписьВГрафикЭтапов(НаборЗаписей, Выборка);
				
				ЗаписатьГрафикЭтапов(НаборЗаписей, Выборка.Распоряжение, ВызовИзОбработчикаОбновления);
				
				Если ПараметрыРасчета.ТребуетсяПроверкаГрафика Тогда
					ЗафиксироватьЭтапыТребующиеПерепланирования(Выборка, ВызовИзОбработчикаОбновления);
				КонецЕсли;
				
				ЕстьЗаписиВВыборке = Выборка.Следующий();
				
			КонецЕсли;
			
			// Из таблицы удаляем отработанные данные
			Для Каждого Строка Из ПорцияДанных.НайтиСтроки(КлючПорцииДанных) Цикл
				
				ПорцияДанных.Удалить(Строка);
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;

	// По неотработанным данным нужно очистить движения.
	Если ПорцияДанных.Количество() > 0 Тогда
		
		Для Каждого КлючЗаписи Из ПорцияДанных Цикл
			
			НаборЗаписей.Отбор.Распоряжение.Установить(КлючЗаписи.Распоряжение);
			
			Если НЕ ПараметрыРасчета.ПоЗаказу Тогда
				НаборЗаписей.Отбор.КодСтрокиПродукция.Установить(КлючЗаписи.КодСтрокиПродукция);
				НаборЗаписей.Отбор.КодСтрокиЭтапыГрафик.Установить(КлючЗаписи.КодСтрокиЭтапыГрафик);
			КонецЕсли;
			
			ЗаписатьГрафикЭтапов(НаборЗаписей, КлючЗаписи.Распоряжение, ВызовИзОбработчикаОбновления);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РасчетИтоговГрафикаЭтаповПроизводства

Процедура ДобавитьЗаписьВГрафикЭтапов(Таблица, Выборка)
	
	Если Выборка.Запланировано > 0 
		ИЛИ Выборка.КВыполнению > 0 Тогда
	
		ЗаполнитьЗначенияСвойств(
			Таблица.Добавить(), 
			Выборка, 
			"Распоряжение,
			|КодСтрокиПродукция,
			|КодСтрокиЭтапыГрафик,
			|
			|Этап,
			|НачалоЭтапа,
			|Подразделение,
			|ПроизводствоНаСтороне,
			|
			|Запланировано,
			|КВыполнению");
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьГрафикЭтапов(НаборЗаписей, Распоряжение, ВызовИзОбработчикаОбновления = Ложь)
	
	// Запись и очистка набора.
	Если ВызовИзОбработчикаОбновления Тогда
		Попытка
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		Исключение
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Распоряжение);
			ВызватьИсключение;
		КонецПопытки;
	Иначе
		НаборЗаписей.Записать(Истина);
	КонецЕсли;
	
	НаборЗаписей.Очистить();

КонецПроцедуры

Процедура ЗафиксироватьЭтапыТребующиеПерепланирования(Выборка, ВызовИзОбработчикаОбновления = Ложь)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТЭтапы.КлючСвязи  КАК КлючСвязи,
		|	ТЭтапы.Количество КАК Количество,
		|
		|	// поиск следующего этапа:
		|	ТЭтапыГрафик.КлючСвязиПродукция КАК КлючСвязиПродукция,
		|
		|	// - в цепочке
		|	ТЭтапыГрафик.НомерСледующегоЭтапа КАК НомерСледующегоЭтапа,
		|	ТЭтапыГрафик.Спецификация         КАК Спецификация,
		|	ТЭтапы.КлючСвязиПолуфабрикат      КАК КлючСвязиПолуфабрикат,
		|
		|	// - производится в процессе
		|	ТЭтапы.КлючСвязиЭтапы КАК КлючСвязиЭтапы
		|
		|ПОМЕСТИТЬ ВТ_ТекущийЭтап
		|ИЗ
		|	Документ.ЗаказНаПроизводство.ЭтапыГрафик КАК ТЭтапыГрафик
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Этапы КАК ТЭтапы
		|		ПО ТЭтапыГрафик.Ссылка = ТЭтапы.Ссылка
		|			И ТЭтапыГрафик.КлючСвязиПродукция = ТЭтапы.КлючСвязиПродукция
		|			И ТЭтапыГрафик.КлючСвязиЭтапы = ТЭтапы.КлючСвязи
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Продукция КАК ТПродукция
		|		ПО ТЭтапыГрафик.Ссылка = ТПродукция.Ссылка
		|			И ТЭтапыГрафик.КлючСвязиПродукция = ТПродукция.КлючСвязи
		|ГДЕ
		|	ТЭтапыГрафик.Ссылка = &Распоряжение
		|	И ТЭтапыГрафик.КодСтроки = &КодСтрокиЭтапыГрафик
		|	И ТПродукция.КодСтроки = &КодСтрокиПродукция
		|	И НЕ (ТЭтапы.ДлительностьЭтапа = 0 
		|			И НЕ ТЭтапы.ПланироватьРаботуВидовРабочихЦентров) 
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СледующиеЭтапы.КлючСвязи  КАК КлючСвязи,
		|	СледующиеЭтапы.Количество КАК Количество
		|ПОМЕСТИТЬ ВТ_СледующиеЭтапы
		|ИЗ
		|	ВТ_ТекущийЭтап КАК ТекущийЭтап
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Этапы КАК СледующиеЭтапы
		|		ПО ТекущийЭтап.КлючСвязиПродукция = СледующиеЭтапы.КлючСвязиПродукция
		|			И (ВЫБОР
		|				КОГДА ТекущийЭтап.НомерСледующегоЭтапа <> 0
		|						И ТекущийЭтап.КлючСвязиПродукция = СледующиеЭтапы.КлючСвязиПродукция
		|						И ТекущийЭтап.НомерСледующегоЭтапа = СледующиеЭтапы.НомерЭтапа
		|						И ТекущийЭтап.Спецификация = СледующиеЭтапы.Спецификация
		|						И ТекущийЭтап.КлючСвязиПолуфабрикат = СледующиеЭтапы.КлючСвязиПолуфабрикат
		|					ТОГДА ИСТИНА
		|				КОГДА ТекущийЭтап.КлючСвязиЭтапы <> &ПустойКлюч
		|						И ТекущийЭтап.КлючСвязиПродукция = СледующиеЭтапы.КлючСвязиПродукция
		|						И ТекущийЭтап.КлючСвязи = СледующиеЭтапы.КлючСвязиЭтапы
		|					ТОГДА ИСТИНА
		|				ИНАЧЕ ЛОЖЬ
		|			КОНЕЦ)
		|ГДЕ
		|	СледующиеЭтапы.Ссылка = &Распоряжение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТекущийЭтап.КлючСвязи  КАК КлючСвязи,
		|	ТекущийЭтап.Количество КАК Количество
		|ИЗ
		|	ВТ_ТекущийЭтап КАК ТекущийЭтап
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СледующиеЭтапы.КлючСвязи  КАК КлючСвязи,
		|	СледующиеЭтапы.Количество КАК Количество
		|ИЗ
		|	ВТ_СледующиеЭтапы КАК СледующиеЭтапы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЭтапыПроизводства.Распоряжение         КАК Распоряжение,
		|	ЭтапыПроизводства.КодСтрокиПродукция   КАК КодСтрокиПродукция,
		|	ЭтапыПроизводства.КодСтрокиЭтапыГрафик КАК КодСтрокиЭтапыГрафик,
		|	ЭтапыПроизводства.Этап                 КАК Этап,
		|	ЭтапыПроизводства.Подразделение        КАК Подразделение,
		|	ЭтапыГрафик.КлючСвязиЭтапы             КАК КлючСвязиЭтапы,
		|	МИНИМУМ(ЭтапыПроизводства.НачалоПредварительногоБуфера) КАК НачалоПредварительногоБуфера,
		|	МАКСИМУМ(ЭтапыПроизводства.ОкончаниеЗавершающегоБуфера) КАК ОкончаниеЗавершающегоБуфера,
		|	МАКСИМУМ(ЭтапыПроизводства.ЗапланированоЗаказом) КАК Количество
		|ИЗ
		|	РегистрНакопления.ЭтапыПроизводства КАК ЭтапыПроизводства
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.ЭтапыГрафик КАК ЭтапыГрафик
		|		ПО ЭтапыПроизводства.Распоряжение = ЭтапыГрафик.Ссылка
		|			И (ЭтапыПроизводства.КодСтрокиПродукция = &КодСтрокиПродукция)
		|			И ЭтапыПроизводства.КодСтрокиЭтапыГрафик = ЭтапыГрафик.КодСтроки
		|ГДЕ
		|	ЭтапыПроизводства.Активность
		|	И ЭтапыПроизводства.Распоряжение = &Распоряжение
		|	И ЭтапыПроизводства.КодСтрокиПродукция = &КодСтрокиПродукция
		|	И (ЭтапыПроизводства.ЗапланированоЗаказом + ЭтапыПроизводства.КВыполнению) > 0
		|	И ЭтапыГрафик.КлючСвязиЭтапы В
		|			(ВЫБРАТЬ
		|				ТекущийЭтап.КлючСвязи
		|			ИЗ
		|				ВТ_ТекущийЭтап КАК ТекущийЭтап
		|		
		|			ОБЪЕДИНИТЬ ВСЕ
		|		
		|			ВЫБРАТЬ
		|				СледующиеЭтапы.КлючСвязи
		|			ИЗ
		|				ВТ_СледующиеЭтапы КАК СледующиеЭтапы)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЭтапыПроизводства.Распоряжение,
		|	ЭтапыПроизводства.КодСтрокиПродукция,
		|	ЭтапыПроизводства.КодСтрокиЭтапыГрафик,
		|	ЭтапыПроизводства.Этап,
		|	ЭтапыПроизводства.Подразделение,
		|	ЭтапыГрафик.КлючСвязиЭтапы
		|
		|УПОРЯДОЧИТЬ ПО
		|	КлючСвязиЭтапы,
		|	ОкончаниеЗавершающегоБуфера");
	
	Запрос.УстановитьПараметр("ПустойКлюч", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
	Запрос.УстановитьПараметр("Распоряжение", Выборка.Распоряжение);
	Запрос.УстановитьПараметр("КодСтрокиПродукция", Выборка.КодСтрокиПродукция);
	Запрос.УстановитьПараметр("КодСтрокиЭтапыГрафик", Выборка.КодСтрокиЭтапыГрафик);

	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаТекущийЭтап    = РезультатЗапроса[2].Выбрать();
	ВыборкаСледующиеЭтапы = РезультатЗапроса[3].Выбрать();
	
	ТаблицаГрафик = РезультатЗапроса[4].Выгрузить();
	ТаблицаГрафик.Индексы.Добавить("КлючСвязиЭтапы");
	
	Пока ВыборкаТекущийЭтап.Следующий() Цикл
		
		ЭтапКоличество = 0;
		
		НаборЗаписей = РегистрыСведений.ГрафикЭтаповПроизводства.СоздатьНаборЗаписей();
		
		НайденныеСтрокиРазмещениеЭтапа = ТаблицаГрафик.НайтиСтроки(Новый Структура("КлючСвязиЭтапы", ВыборкаТекущийЭтап.КлючСвязи));
		ПланированиеПроизводства.СортироватьМассив(НайденныеСтрокиРазмещениеЭтапа, НаправлениеСортировки.Возр, "КодСтрокиЭтапыГрафик");
		
		Для Каждого РазмещениеЭтапа Из НайденныеСтрокиРазмещениеЭтапа Цикл
			
			ЭтапКоличество = ЭтапКоличество + РазмещениеЭтапа.Количество;
			
			Пока ВыборкаСледующиеЭтапы.Следующий() Цикл
				
				СледующийЭтапКоличество = 0;
				
				НайденныеСтрокиРазмещениеСледующегоЭтапа = ТаблицаГрафик.НайтиСтроки(Новый Структура("КлючСвязиЭтапы", ВыборкаСледующиеЭтапы.КлючСвязи));
				ПланированиеПроизводства.СортироватьМассив(НайденныеСтрокиРазмещениеСледующегоЭтапа, НаправлениеСортировки.Возр, "КодСтрокиЭтапыГрафик");
				
				Для Каждого РазмещениеСледующегоЭтапа Из НайденныеСтрокиРазмещениеСледующегоЭтапа Цикл
					
					СледующийЭтапКоличество = СледующийЭтапКоличество + РазмещениеСледующегоЭтапа.Количество;
					
					НаборЗаписей.Отбор.Распоряжение.Установить(РазмещениеСледующегоЭтапа.Распоряжение);
					НаборЗаписей.Отбор.КодСтрокиПродукция.Установить(РазмещениеСледующегоЭтапа.КодСтрокиПродукция);
					НаборЗаписей.Отбор.КодСтрокиЭтапыГрафик.Установить(РазмещениеСледующегоЭтапа.КодСтрокиЭтапыГрафик);
					
					НаборЗаписей.Прочитать();
					
					Если НаборЗаписей.Количество() > 0 Тогда
						
						ТребуетсяПерепланировать = Ложь;
						
						Если СледующийЭтапКоличество >= Цел(ЭтапКоличество * ВыборкаСледующиеЭтапы.Количество / ВыборкаТекущийЭтап.Количество)
							И СледующийЭтапКоличество - РазмещениеСледующегоЭтапа.Количество < Цел(ЭтапКоличество * ВыборкаСледующиеЭтапы.Количество / ВыборкаТекущийЭтап.Количество) Тогда
							
							Если РазмещениеСледующегоЭтапа.НачалоПредварительногоБуфера <= РазмещениеЭтапа.ОкончаниеЗавершающегоБуфера Тогда
								
								ТребуетсяПерепланировать = Истина;
								
							КонецЕсли;
							
						КонецЕсли;
						
						Если НаборЗаписей[0].ТребуетсяПерепланировать = ТребуетсяПерепланировать Тогда
							
							Продолжить;
							
						КонецЕсли;
							
						НаборЗаписей[0].ТребуетсяПерепланировать = ТребуетсяПерепланировать;
							
						ЗаписатьГрафикЭтапов(НаборЗаписей, РазмещениеСледующегоЭтапа.Распоряжение, ВызовИзОбработчикаОбновления);
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтметитьЭтапыТребующиеПерепланирования(ТекРаспоряжение, ГрафикЭтапов)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТЭтапы.КлючСвязи             КАК КлючСвязи,
		|	ТЭтапы.КлючСвязиПродукция    КАК КлючСвязиПродукция,
		|	ТЭтапы.КлючСвязиЭтапы        КАК КлючСвязиЭтапы,
		|	ТЭтапы.КлючСвязиПолуфабрикат КАК КлючСвязиПолуфабрикат,
		|	ТЭтапы.НомерЭтапа            КАК НомерЭтапа,
		|	ТЭтапы.НомерСледующегоЭтапа  КАК НомерСледующегоЭтапа,
		|	ТЭтапы.Спецификация          КАК Спецификация,
		|	(НЕ ТЭтапы.ПланироватьРаботуВидовРабочихЦентров
		|		И ТЭтапы.ДлительностьЭтапа = 0)
		|	                             КАК ЭтапНулевойДлительности,
		|	ТЭтапы.Количество            КАК Количество
		|ИЗ
		|	Документ.ЗаказНаПроизводство.Этапы КАК ТЭтапы
		|ГДЕ
		|	ТЭтапы.Ссылка = &Заказ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Продукция.КлючСвязи                                     КАК КлючСвязиПродукция,
		|	ЭтапыГрафик.КлючСвязиЭтапы                              КАК КлючСвязиЭтапы,
		|	ЭтапыПроизводства.КодСтрокиПродукция                    КАК КодСтрокиПродукция,
		|	ЭтапыПроизводства.КодСтрокиЭтапыГрафик                  КАК КодСтрокиЭтапыГрафик,
		|	МИНИМУМ(ЭтапыПроизводства.НачалоПредварительногоБуфера) КАК НачалоПредварительногоБуфера,
		|	МАКСИМУМ(ЭтапыПроизводства.ОкончаниеЗавершающегоБуфера) КАК ОкончаниеЗавершающегоБуфера,
		|	МАКСИМУМ(ЭтапыПроизводства.ЗапланированоЗаказом)        КАК Количество
		|ИЗ
		|	РегистрНакопления.ЭтапыПроизводства КАК ЭтапыПроизводства
		|
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Продукция КАК Продукция
		|		ПО (Продукция.Ссылка = &Заказ)
		|			И (Продукция.КодСтроки = ЭтапыПроизводства.КодСтрокиПродукция)
		|
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.ЭтапыГрафик КАК ЭтапыГрафик
		|		ПО (ЭтапыГрафик.Ссылка = &Заказ)
		|			И (ЭтапыГрафик.КодСтроки = ЭтапыПроизводства.КодСтрокиЭтапыГрафик)
		|ГДЕ
		|	ЭтапыПроизводства.Активность
		|	И ЭтапыПроизводства.Распоряжение = &Заказ
		|	И (ЭтапыПроизводства.ЗапланированоЗаказом + ЭтапыПроизводства.КВыполнению > 0)
		|
		|СГРУППИРОВАТЬ ПО
		|	Продукция.КлючСвязи,
		|	ЭтапыГрафик.КлючСвязиЭтапы,
		|	ЭтапыПроизводства.КодСтрокиПродукция,
		|	ЭтапыПроизводства.КодСтрокиЭтапыГрафик
		|	
		|УПОРЯДОЧИТЬ ПО
		|	КлючСвязиПродукция,
		|	КлючСвязиЭтапы,
		|	ОкончаниеЗавершающегоБуфера");
	
	Запрос.УстановитьПараметр("Заказ", ТекРаспоряжение);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ТаблицаЭтапы = РезультатЗапроса[0].Выгрузить();
	ТаблицаГрафик = РезультатЗапроса[1].Выгрузить();
	
	ТаблицаЭтапы.Индексы.Добавить("КлючСвязиПродукция, НомерЭтапа, Спецификация, КлючСвязиПолуфабрикат");
	ТаблицаЭтапы.Индексы.Добавить("КлючСвязиПродукция, КлючСвязи");
	
	ТаблицаГрафик.Индексы.Добавить("КлючСвязиПродукция, КлючСвязиЭтапы");
	
	Для Каждого Этап Из ТаблицаЭтапы.НайтиСтроки(Новый Структура("ЭтапНулевойДлительности", Ложь)) Цикл
		
		ЭтапКоличество = 0;
		СледующиеЭтапы = СледующиеЭтапы(ТаблицаЭтапы, Этап);
		
		НайденныеСтрокиРазмещениеЭтапа = ТаблицаГрафик.НайтиСтроки(Новый Структура("КлючСвязиПродукция, КлючСвязиЭтапы", Этап.КлючСвязиПродукция, Этап.КлючСвязи));
		ПланированиеПроизводства.СортироватьМассив(НайденныеСтрокиРазмещениеЭтапа, НаправлениеСортировки.Возр, "КодСтрокиЭтапыГрафик");
		
		Для Каждого РазмещениеЭтапа Из НайденныеСтрокиРазмещениеЭтапа Цикл
			
			ЭтапКоличество = ЭтапКоличество + РазмещениеЭтапа.Количество;
			
			Для Каждого СледующийЭтап Из СледующиеЭтапы Цикл
				
				СледующийЭтапКоличество = 0;
				
				НайденныеСтрокиРазмещениеСледующегоЭтапа = ТаблицаГрафик.НайтиСтроки(Новый Структура("КлючСвязиПродукция, КлючСвязиЭтапы", СледующийЭтап.КлючСвязиПродукция, СледующийЭтап.КлючСвязи));
				ПланированиеПроизводства.СортироватьМассив(НайденныеСтрокиРазмещениеСледующегоЭтапа, НаправлениеСортировки.Возр, "КодСтрокиЭтапыГрафик");
				
				Для Каждого РазмещениеСледующегоЭтапа Из НайденныеСтрокиРазмещениеСледующегоЭтапа Цикл
					
					СледующийЭтапКоличество = СледующийЭтапКоличество + РазмещениеСледующегоЭтапа.Количество;
					
					Если СледующийЭтапКоличество >= Цел(ЭтапКоличество * СледующийЭтап.Количество / Этап.Количество)
						И СледующийЭтапКоличество - РазмещениеСледующегоЭтапа.Количество < Цел(ЭтапКоличество * СледующийЭтап.Количество / Этап.Количество) Тогда
						
						Если РазмещениеСледующегоЭтапа.НачалоПредварительногоБуфера <= РазмещениеЭтапа.ОкончаниеЗавершающегоБуфера Тогда
							
							Для Каждого Запись Из ГрафикЭтапов.НайтиСтроки(Новый Структура("КодСтрокиПродукция, КодСтрокиЭтапыГрафик", РазмещениеСледующегоЭтапа.КодСтрокиПродукция, РазмещениеСледующегоЭтапа.КодСтрокиЭтапыГрафик)) Цикл
								
								Запись.ТребуетсяПерепланировать = Истина;
								
							КонецЦикла;
							
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;

КонецПроцедуры

Функция СледующиеЭтапы(Этапы, Этап)
	
	// Следующий этап не указан и не производятся в процессе
	Если НЕ ЗначениеЗаполнено(Этап.НомерСледующегоЭтапа) И
		НЕ ЗначениеЗаполнено(Этап.КлючСвязиЭтапы) Тогда
		
		Возврат Новый Массив;
		
	КонецЕсли;
	
	// Поиск следующих этапов
	ПараметрыОтбораСледующиеЭтапы = Новый Структура("КлючСвязиПродукция");
	ПараметрыОтбораСледующиеЭтапы.КлючСвязиПродукция = Этап.КлючСвязиПродукция;
	
	Если ЗначениеЗаполнено(Этап.НомерСледующегоЭтапа) Тогда
		
		ПараметрыОтбораСледующиеЭтапы.Вставить("НомерЭтапа", Этап.НомерСледующегоЭтапа);
		ПараметрыОтбораСледующиеЭтапы.Вставить("Спецификация", Этап.Спецификация);
		ПараметрыОтбораСледующиеЭтапы.Вставить("КлючСвязиПолуфабрикат", Этап.КлючСвязиПолуфабрикат);
		
	ИначеЕсли ЗначениеЗаполнено(Этап.КлючСвязиЭтапы) Тогда
		
		ПараметрыОтбораСледующиеЭтапы.Вставить("КлючСвязи", Этап.КлючСвязиЭтапы);
		
	КонецЕсли;
		
	Возврат Этапы.НайтиСтроки(ПараметрыОтбораСледующиеЭтапы);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
//-- Устарело_Производство21