#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
//
// Параметры:
//   Таблица - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	ЗаполнитьНаборыЗначенийДоступаПоУмолчанию(Таблица);	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий бизнес-процесса.

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	Если ДанныеЗаполнения.Свойство("ФизическоеЛицо") Тогда
		Наименование = СтрШаблон(НСтр("ru = 'Справка об остатках отпусков %1';
										|en = 'Remaining leave statement %1'"), Строка(ДанныеЗаполнения.ФизическоеЛицо));
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Автор <> Неопределено И Не Автор.Пустая() Тогда
		АвторСтрокой = Строка(Автор);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ГруппаИсполнителейЗадач = ?(ТипЗнч(Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей"),
		БизнесПроцессыИЗадачиСервер.ГруппаИсполнителейЗадач(Исполнитель, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации),
		Исполнитель);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если НЕ ЭтоНовый() И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Предмет") <> Предмет Тогда
		ИзменитьПредметЗадач();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ДатаЗавершения = '00010101000000';	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий элементов карты маршрута.

// Параметры:
// 	ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка.Задание
// 	ФормируемыеЗадачи - Массив из ЗадачаОбъект
// 	Отказ - Булево
// 
Процедура ВыполнитьПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	Записать();
	
	// Устанавливаем реквизиты адресации и доп. реквизиты для каждой задачи.
	Для каждого Задача Из ФормируемыеЗадачи Цикл
		
		Задача.Автор = Автор;
		Задача.АвторСтрокой = Строка(Автор);
		Если ТипЗнч(Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
			Задача.РольИсполнителя = Исполнитель;
			Задача.ОсновнойОбъектАдресации = ОсновнойОбъектАдресации;
			Задача.ДополнительныйОбъектАдресации = ДополнительныйОбъектАдресации;
			Задача.Исполнитель = Неопределено;
		Иначе	
			Задача.Исполнитель = Исполнитель;
		КонецЕсли;
		Задача.Наименование = НаименованиеЗадачиДляВыполнения();
		Задача.СрокИсполнения = СрокИсполненияЗадачиДляВыполнения();
		Задача.Важность = Важность;
		Задача.Предмет = Предмет;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВыполнитьПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	Если Предмет = Неопределено Или Предмет.Пустая() Тогда
		Возврат;
	КонецЕсли;	
КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	ОтправитьПочтовоеСообщение();
	ДатаЗавершения = БизнесПроцессыИЗадачиСервер.ДатаЗавершенияБизнесПроцесса(Ссылка);
	Выполнено = Истина;
	Записать();	
КонецПроцедуры

Процедура СогласоватьЗаявкуПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	ЗадачаОбъект = Задача.ПолучитьОбъект();
	ЗадачаОбъект.ВыполнитьЗадачу();
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ДоступноВыполнение() Экспорт
	Возврат БизнесПроцессыЗаявокСотрудников.ДоступноВыполнение(ЭтотОбъект, , ФайлыОтвета());	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИзменитьПредметЗадач()

	УстановитьПривилегированныйРежим(Истина);
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Задача.ЗадачаИсполнителя");
		ЭлементБлокировки.УстановитьЗначение("БизнесПроцесс", Ссылка);
		Блокировка.Заблокировать();
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	Задачи.Ссылка КАК Ссылка
			|ИЗ
			|	Задача.ЗадачаИсполнителя КАК Задачи
			|ГДЕ
			|	Задачи.БизнесПроцесс = &БизнесПроцесс");

		Запрос.УстановитьПараметр("БизнесПроцесс", Ссылка);
		ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ЗадачаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект(); // ЗадачаОбъект
			ЗадачаОбъект.Выполнена = Ложь;
			ЗадачаОбъект.Предмет = Предмет;
			// Не выполняем предварительную блокировку данных для редактирования, т.к.
			// Это изменение имеет более высокий приоритет над открытыми формами задач.
			ЗадачаОбъект.Записать();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры 

Функция НаименованиеЗадачиДляВыполнения()
	Возврат Наименование;		
КонецФункции

Функция СрокИсполненияЗадачиДляВыполнения()
	Возврат СрокИсполнения;		
КонецФункции

Процедура ЗаполнитьНаборыЗначенийДоступаПоУмолчанию(Таблица)
	
	// Логика ограничения по умолчанию для
	// - чтения:    Автор ИЛИ Исполнитель (с учетом адресации) ИЛИ Проверяющий (с учетом адресации)
	// - изменения: Автор.
	
	// Если предмет не задан (т.е. бизнес-процесс без основания), тогда предмет не участвует в логике ограничения.
	
	// Чтение, Изменение: набор № 1.
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 1;
	Строка.Чтение          = Истина;
	Строка.Изменение       = Истина;
	Строка.ЗначениеДоступа = Автор;
	
	// Чтение: набор № 2.
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 2;
	Строка.Чтение          = Истина;
	Строка.ЗначениеДоступа = ГруппаИсполнителейЗадач;
	
КонецПроцедуры

Процедура ОтправитьПочтовоеСообщение()
	БизнесПроцессыЗаявокСотрудников.ОтправитьПочтовоеСообщение(ЭтотОбъект,
															   НСтр("ru = 'Справка об остатках отпусков.';
																	|en = 'Remaining leave statement.'"),
															   ФайлыОтвета());
КонецПроцедуры

Функция ФайлыОтвета()
	
	Запрос = Новый Запрос();
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаявкаСотрудникаСправкаОстаткиОтпусковПрисоединенныеФайлы.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ЗаявкаСотрудникаСправкаОстаткиОтпусковПрисоединенныеФайлы КАК ЗаявкаСотрудникаСправкаОстаткиОтпусковПрисоединенныеФайлы
	               |ГДЕ
	               |	ЗаявкаСотрудникаСправкаОстаткиОтпусковПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
	               |	И ЗаявкаСотрудникаСправкаОстаткиОтпусковПрисоединенныеФайлы.ФайлОтвета = ИСТИНА
	               |	И ЗаявкаСотрудникаСправкаОстаткиОтпусковПрисоединенныеФайлы.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("ВладелецФайла", Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли