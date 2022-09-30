
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ДанныеЗаполнения.Свойство("Дата",          Дата);
		ДанныеЗаполнения.Свойство("Подразделение", Подразделение);
		ДанныеЗаполнения.Свойство("Смена",         Смена);
		ДанныеЗаполнения.Свойство("Участок",       Участок);
		
		Если ДанныеЗаполнения.Свойство("ЗаполнитьИсполнителейИзПрошлойСмены")
			И ДанныеЗаполнения.ЗаполнитьИсполнителейИзПрошлойСмены Тогда
			
			Запрос = Новый Запрос(
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	СменноеЗаданиеИсполнители.Ссылка КАК Ссылка
				|ПОМЕСТИТЬ ВТСсылка
				|ИЗ
				|	Документ.СменноеЗадание КАК СменноеЗадание
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СменноеЗадание.Исполнители КАК СменноеЗаданиеИсполнители
				|		ПО СменноеЗадание.Ссылка = СменноеЗаданиеИсполнители.Ссылка
				|ГДЕ
				|	СменноеЗадание.Подразделение = &Подразделение
				|	И СменноеЗадание.Смена = &Смена
				|	И СменноеЗадание.Участок = &Участок
				|	И СменноеЗадание.Дата < &Дата
				|	И СменноеЗадание.ПометкаУдаления = ЛОЖЬ
				|
				|УПОРЯДОЧИТЬ ПО
				|	СменноеЗадание.Дата УБЫВ
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	СменноеЗаданиеИсполнители.Исполнитель КАК Исполнитель
				|ИЗ
				|	ВТСсылка КАК ВТСсылка
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СменноеЗадание.Исполнители КАК СменноеЗаданиеИсполнители
				|		ПО ВТСсылка.Ссылка = СменноеЗаданиеИсполнители.Ссылка");
			Запрос.УстановитьПараметр("Подразделение", Подразделение);
			Запрос.УстановитьПараметр("Смена", Смена);
			Запрос.УстановитьПараметр("Дата", Дата);
			Запрос.УстановитьПараметр("Участок", Участок);
			
			Исполнители.Загрузить(Запрос.Выполнить().Выгрузить());
			
		КонецЕсли;
		
	КонецЕсли;
	
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыПодразделения = ПроизводствоСервер.ПараметрыПроизводственногоПодразделения(Подразделение);
	
	Если НЕ ПараметрыПодразделения.ИспользоватьСмены Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Смена");
	КонецЕсли;
	
	Если НЕ ПараметрыПодразделения.ИспользоватьУчастки Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Участок");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДанныеДоИзменения = ДанныеДокументаДоИзменения();
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	ДополнительныеСвойства.Вставить("ДанныеДоИзменения", ДанныеДоИзменения);
	
	// Контроль: отменять проведение можно только в статусе Формируется
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения
		И Статус <> Перечисления.СтатусыСменныхЗаданий.Формируется Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Для выполнения действия документ должен иметь статус ""Формируется"".';
				|en = 'To perform the action, the document must be in the ""Generating"" status.'"),
			ЭтотОбъект,,,
			Отказ);
		
	КонецЕсли;
	
	// Контроль: по сочетанию смена-день-участок должен быть только один документ
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ИСТИНА КАК Поле1
			|ИЗ
			|	Документ.СменноеЗадание КАК СменноеЗадание
			|ГДЕ
			|	СменноеЗадание.Ссылка <> &Ссылка
			|	И СменноеЗадание.Подразделение = &Подразделение
			|	И СменноеЗадание.Смена = &Смена
			|	И СменноеЗадание.Участок = &Участок
			|	И НАЧАЛОПЕРИОДА(СменноеЗадание.Дата, ДЕНЬ) = &Дата
			|	И СменноеЗадание.Проведен");
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
		Запрос.УстановитьПараметр("Смена", Смена);
		Запрос.УстановитьПараметр("Участок", Участок);
		Запрос.УстановитьПараметр("Дата", НачалоДня(Дата));
		
		Если НЕ Запрос.Выполнить().Пустой() Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'В системе уже имеется сменное задание за указанную дату.';
					|en = 'Shift task for the specified date already exists in the system.'"),
				ЭтотОбъект,,,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Контроль: подразделение можно изменять если нет назначенных операций
	Если ДанныеДоИзменения.Подразделение <> Подразделение Тогда
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ИСТИНА КАК Поле1
			|ИЗ
			|	РегистрСведений.ОперацииКСозданиюСменныхЗаданий КАК Регистр
			|ГДЕ
			|	Регистр.СменноеЗадание = &СменноеЗадание
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ ПЕРВЫЕ 1
			|	ИСТИНА
			|ИЗ
			|	Документ.ПроизводственнаяОперация2_2 КАК Документ
			|ГДЕ
			|	Документ.СменноеЗадание = &СменноеЗадание");
		Запрос.УстановитьПараметр("СменноеЗадание", Ссылка);
		
		Если НЕ Запрос.Выполнить().Пустой() Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Имеются операции, назначенные сменному заданию. Изменять подразделение запрещено.';
					|en = 'There are operations assigned to the shift task. You cannot change the business unit.'"),
				ЭтотОбъект,,,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Контроль: статус производственных операций (документ в статусе Формируется)
	Если Статус = Перечисления.СтатусыСменныхЗаданий.Формируется И НЕ ЭтоНовый() Тогда
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ИСТИНА КАК Поле1
			|ИЗ
			|	Документ.ПроизводственнаяОперация2_2 КАК ПроизводственнаяОперация2_2
			|ГДЕ
			|	ПроизводственнаяОперация2_2.СменноеЗадание = &СменноеЗадание
			|	И ПроизводственнаяОперация2_2.Статус <> &Статус
			|	И ПроизводственнаяОперация2_2.Проведен");
		
		Запрос.УстановитьПараметр("СменноеЗадание", Ссылка);
		Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыПроизводственныхОпераций.Создана);
		
		Если НЕ Запрос.Выполнить().Пустой() Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Имеются производственные операции в статусе отличном от ""Создана"".';
					|en = 'There are production operations in the status other than Created.'"),
				ЭтотОбъект,,,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Контроль: статус производственных операций (документ в статусе Закрыто)
	Если Статус = Перечисления.СтатусыСменныхЗаданий.Закрыто И НЕ ЭтоНовый() Тогда
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ИСТИНА КАК ОшибкаСтатус,
			|	ЛОЖЬ КАК ОшибкаПроведение
			|ИЗ
			|	Документ.ПроизводственнаяОперация2_2 КАК ПроизводственнаяОперация2_2
			|ГДЕ
			|	ПроизводственнаяОперация2_2.СменноеЗадание = &СменноеЗадание
			|	И НЕ ПроизводственнаяОперация2_2.Статус В (&Статусы)
			|	И ПроизводственнаяОперация2_2.Проведен
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ ПЕРВЫЕ 1
			|	ЛОЖЬ,
			|	ИСТИНА
			|ИЗ
			|	Документ.ПроизводственнаяОперация2_2 КАК ПроизводственнаяОперация2_2
			|ГДЕ
			|	ПроизводственнаяОперация2_2.СменноеЗадание = &СменноеЗадание
			|	И НЕ ПроизводственнаяОперация2_2.Проведен
			|	И НЕ ПроизводственнаяОперация2_2.ПометкаУдаления");
		
		Запрос.УстановитьПараметр("СменноеЗадание", Ссылка);
			
		Статусы = Новый Массив;
		Статусы.Добавить(Перечисления.СтатусыПроизводственныхОпераций.Выполнена);
		Статусы.Добавить(Перечисления.СтатусыПроизводственныхОпераций.НеВыполнена);
		Статусы.Добавить(Перечисления.СтатусыПроизводственныхОпераций.Пропущена);
		Запрос.УстановитьПараметр("Статусы", Статусы);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ОшибкаСтатус Тогда
				ТекстСообщения = НСтр("ru = 'Имеются производственные операции в статусе отличном от ""Выполнена"", ""Не выполнена"" и ""Пропущена"".';
										|en = 'There are production operations in the status other than ""Performed"", ""Not performed"", and ""Skipped"".'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Имеются непроведенные производственные операции.';
										|en = 'There are unposted production operations.'");
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,,, Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Приведение даты к началу смены
	Если ЭтоНовый() ИЛИ ДанныеДоИзменения.Смена <> Смена ИЛИ ДанныеДоИзменения.Дата <> Дата Тогда
		
		Расписание = КалендарныеГрафики.РасписанияРаботыНаПериод(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Смена),
			НачалоДня(Дата), КонецДня(Дата));
		
		Если Расписание.Количество() > 0 И ЗначениеЗаполнено(Расписание[0].ВремяНачала) Тогда
			Дата = НачалоДня(Дата) + Час(Расписание[0].ВремяНачала)*3600 + Минута(Расписание[0].ВремяНачала)*60;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Обновление связанных данных
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение
		И НЕ ДополнительныеСвойства.ЭтоНовый
		И ДополнительныеСвойства.ДанныеДоИзменения.Дата <> Дата Тогда
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Регистр.Этап КАК Этап
			|ИЗ
			|	РегистрСведений.ОперацииКСозданиюСменныхЗаданий КАК Регистр
			|ГДЕ
			|	Регистр.СменноеЗадание = &СменноеЗадание
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Документ.Этап
			|ИЗ
			|	Документ.ПроизводственнаяОперация2_2 КАК Документ
			|ГДЕ
			|	Документ.СменноеЗадание = &СменноеЗадание
			|	И Документ.Проведен
			|	И Документ.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыПроизводственныхОпераций.НеВыполнена)");
		Запрос.УстановитьПараметр("СменноеЗадание", Ссылка);
		
		Попытка
			
			РегистрыСведений.ОперацииКСозданиюСменныхЗаданий.РассчитатьОперации(
				Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Этап"));
			
		Исключение
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не удалось рассчитать операции к созданию сменных заданий.';
					|en = 'Cannot calculate operations to create shift tasks.'"),
				ЭтотОбъект,,,
				Отказ);
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Попытка
		
		РегистрыСведений.ОперацииКСозданиюСменныхЗаданий.УдалитьОперацииЗадания(Ссылка);
		
	Исключение
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не удалось рассчитать операции к созданию сменных заданий.';
				|en = 'Cannot calculate operations to create shift tasks.'"),
			ЭтотОбъект,,,
			Отказ);
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДокументаДоИзменения()
	
	СоставРеквизитов = "Дата,Подразделение,Смена";
	
	Если НЕ ЭтоНовый() Тогда
		ДанныеДоИзменения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, СоставРеквизитов);
	Иначе
		ДанныеДоИзменения = Новый Структура(СоставРеквизитов);
		ЗаполнитьЗначенияСвойств(ДанныеДоИзменения, ЭтотОбъект);
	КонецЕсли;
	
	Возврат ДанныеДоИзменения;
	
КонецФункции

#КонецОбласти

#КонецЕсли
