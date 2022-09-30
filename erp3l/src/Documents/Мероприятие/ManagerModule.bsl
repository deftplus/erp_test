#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
// Возвращает необходимость ведения выполнения стадий мероприятий МероприятиеВход до процентов.
// Когда параметр МероприятиеВход, возможно использование ШаблонМероприятияВход. 
Функция ИспользоватьПроцентВыполнения(МероприятиеВход = Неопределено, ШаблонМероприятияВход = Неопределено) Экспорт
	РезультатФункции = Истина;
	ШаблонРабочий = Справочники.ШаблоныМероприятий.ПустаяСсылка();
	Если МероприятиеВход <> Неопределено Тогда
		ШаблонРабочий = МероприятиеВход.ШаблонМероприятия;
	Иначе
		Если ШаблонМероприятияВход <> Неопределено Тогда
			ШаблонРабочий = ШаблонМероприятияВход;
		Иначе
			ШаблонРабочий = Справочники.ШаблоныМероприятий.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	Если ЗначениеЗаполнено(ШаблонРабочий) Тогда
		РезультатФункции = ШаблонРабочий.ИспользоватьПроцентВыполнения;
	Иначе
		РезультатФункции = Истина;
	КонецЕсли;	
	Возврат РезультатФункции;
КонецФункции		// ИспользоватьПроцентВыполнения()	

// Возвращает необходимость ведения затрат для мероприятия МероприятиеВход до процентов.
// Когда параметр МероприятиеВход, возможно использование ШаблонМероприятияВход. 
Функция ИспользоватьКонтрольЗатрат(МероприятиеВход = Неопределено, ШаблонМероприятияВход = Неопределено) Экспорт
	РезультатФункции = Истина;
	ШаблонРабочий = Справочники.ШаблоныМероприятий.ПустаяСсылка();
	Если МероприятиеВход <> Неопределено Тогда
		ШаблонРабочий = МероприятиеВход.ШаблонМероприятия;
	Иначе
		Если ШаблонМероприятияВход <> Неопределено Тогда
			ШаблонРабочий = ШаблонМероприятияВход;
		Иначе
			ШаблонРабочий = Справочники.ШаблоныМероприятий.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	Если ЗначениеЗаполнено(ШаблонРабочий) Тогда
		РезультатФункции = ШаблонРабочий.ИспользоватьКонтрольЗатрат;
	Иначе
		РезультатФункции = Истина;
	КонецЕсли;	
	Возврат РезультатФункции;
КонецФункции		// ИспользоватьКонтрольЗатрат()	                        

// Возвращает последнее мероприятие по контексту КонтекстВход. Когда
// параметр ВидМероприятияВход указан, накладывается дополнительный
// отбор по виду мероприятия.
Функция ПолучитьПоследнееМероприятиеПоКонтексту(КонтекстВход, ВидМероприятияВход = Неопределено) Экспорт
	РезультатФункции = Документы.Мероприятие.ПустаяСсылка();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	Мероприятие.Ссылка КАК Ссылка,
		|	Мероприятие.Дата КАК Дата,
		|	Мероприятие.Контекст КАК Контекст,
		|	Мероприятие.ВидМероприятия КАК ВидМероприятия
		|ИЗ
		|	Документ.Мероприятие КАК Мероприятие
		|ГДЕ
		|	Мероприятие.Контекст = &Контекст
		|	И ВЫБОР
		|			КОГДА &ВидМероприятия = НЕОПРЕДЕЛЕНО
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ Мероприятие.ВидМероприятия = &ВидМероприятия
		|		КОНЕЦ
		|	И НЕ Мероприятие.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата УБЫВ";
	ВидМероприятияРабочий = Неопределено;
	Если ЗначениеЗаполнено(ВидМероприятияВход) Тогда
		ВидМероприятияРабочий = ВидМероприятияВход;
	Иначе
		ВидМероприятияРабочий = Неопределено;
	КонецЕсли;	
	Запрос.УстановитьПараметр("ВидМероприятия", ВидМероприятияРабочий);
	Запрос.УстановитьПараметр("Контекст", КонтекстВход);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		РезультатФункции = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
	Возврат РезультатФункции;
КонецФункции		// ПолучитьПоследнееМероприятиеПоКонтексту()

// Возвращает актуальную выполняемую стадию мероприятия МероприятиеВход.
Функция ПолучитьАктуальнуюСтадиюМероприятия(МероприятиеВход) Экспорт
	ПустаяСтадия = Справочники.СтадииМероприятий.ПустаяСсылка();
	РезультатФункции = ПустаяСтадия;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	АктуальныеСтадииМероприятийСрезПоследних.Мероприятие КАК Мероприятие,
		|	АктуальныеСтадииМероприятийСрезПоследних.Стадия КАК Стадия
		|ИЗ
		|	РегистрСведений.АктуальныеСтадииМероприятий.СрезПоследних КАК АктуальныеСтадииМероприятийСрезПоследних
		|ГДЕ
		|	АктуальныеСтадииМероприятийСрезПоследних.Мероприятие = &Мероприятие";
	Запрос.УстановитьПараметр("Мероприятие", МероприятиеВход);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		РезультатФункции = ВыборкаДетальныеЗаписи.Стадия;
	КонецЦикла;
	Возврат РезультатФункции;
КонецФункции		// ПолучитьАктуальнуюСтадиюМероприятия()

// Возвращает структуру, содержащую дату начала, дату окончания и длительность 
// стадии СтадияВход в мероприятии МероприятиеВход.
Функция ПолучитьДанныеСтадииМероприятия(МероприятиеВход, СтадияВход) Экспорт
	// Инициализация.
	РезультатФункции = Новый Структура;
	РезультатФункции.Вставить("Стадия", Справочники.СтадииМероприятий.ПустаяСсылка());
	РезультатФункции.Вставить("ДатаНачала", Дата(1, 1, 1));
	РезультатФункции.Вставить("ДатаОкончания", Дата(1, 1, 1));
	РезультатФункции.Вставить("Длительность", 0);
	// Получим данные из таблицы стадий.
	Если ЗначениеЗаполнено(СтадияВход) Тогда
		ТаблицаСтадий = МероприятиеВход.Стадии.Выгрузить();
		СтадияНайдена = Ложь;
		Для Каждого ТекТаблицаСтадий Из ТаблицаСтадий Цикл
			Если ТекТаблицаСтадий.Действие = СтадияВход Тогда
				РезультатФункции.Вставить("Стадия", ТекТаблицаСтадий.Действие);
				РезультатФункции.Вставить("ДатаНачала", ТекТаблицаСтадий.ДатаИзменения);
				РезультатФункции.Вставить("Длительность", ТекТаблицаСтадий.ФактическаяДлительность);
				СтадияНайдена = Истина;
			Иначе
				Если СтадияНайдена Тогда
					РезультатФункции.Вставить("ДатаОкончания", ТекТаблицаСтадий.ДатаИзменения);
				Иначе
					// Выполняем далее.
				КонецЕсли;	
			КонецЕсли;
		КонецЦикла;	
		// Дозаполним данные последней стадии.
		ЕстьДатаНачала		 = ЗначениеЗаполнено(РезультатФункции.ДатаНачала);
		ЕстьДатаОкончания	 = ЗначениеЗаполнено(РезультатФункции.ДатаОкончания);
		Если (ЕстьДатаНачала) И (НЕ ЕстьДатаОкончания) Тогда
			ВеличинаСдвига = РезультатФункции.Длительность*24*60*60;
			РезультатФункции.ДатаОкончания = РезультатФункции.ДатаНачала + ВеличинаСдвига;
		Иначе
			// Дополнительные вычисления не требуются.
		КонецЕсли;	
	Иначе
		РезультатФункции.Вставить("Стадия", Справочники.СтадииМероприятий.ПустаяСсылка());
		РезультатФункции.Вставить("ДатаНачала", Дата(1, 1, 1));
		РезультатФункции.Вставить("ДатаОкончания", Дата(1, 1, 1));
		РезультатФункции.Вставить("Длительность", 0);
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции		// ПолучитьДанныеСтадииМероприятия()

// Возвращает данные стадии с видом даты ВидДатыВход по мероприятию 
// закупочной процедуры МероприятиеВход.
Функция ПолучитьДанныеСтадииПоВидуДаты(МероприятиеВход, ВидДатыВход) Экспорт
	РезультатФункции = Новый Структура;
	НоваяСтадия = Справочники.СтадииМероприятий.ПустаяСсылка();
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() И ЗначениеЗаполнено(МероприятиеВход.Контекст) Тогда
		ТипКонтекст = "СправочникСсылка.ЗакупочныеПроцедуры";
		Если ТипЗнч(МероприятиеВход.Контекст) = Тип(ТипКонтекст) Тогда
			СпособВыбораПоставщика = МероприятиеВход.Контекст.СпособВыбораПоставщика;
			НоваяСтадия = Справочники.СтадииМероприятий.ВернутьСтадиюДатыЗакупочнойПроцедуры(СпособВыбораПоставщика, ВидДатыВход);
		Иначе
			НоваяСтадия = Справочники.СтадииМероприятий.ПустаяСсылка();
		КонецЕсли;	
	Иначе
		НоваяСтадия = Справочники.СтадииМероприятий.ПустаяСсылка();
	КонецЕсли;
	РезультатФункции = ПолучитьДанныеСтадииМероприятия(МероприятиеВход, НоваяСтадия);
	Возврат РезультатФункции;
КонецФункции		// ПолучитьДанныеСтадииПоВидуДаты()

// Отправляет задачу ответственному ОтветственныйВход за мероприятие МероприятиеВход. 
// Возвращает успешность выполнения операции.
Функция ОтправитьЗадачуОтветственномуЗаМероприятие(МероприятиеВход, ОтветственныйВход = Неопределено) Экспорт
	РезультатФункции = Истина;
	Попытка
		Если ЗначениеЗаполнено(МероприятиеВход) Тогда
			// Определение ответственного.
			ОтветственныйРабочий = Справочники.Пользователи.ПустаяСсылка();
			Если ОтветственныйВход <> Неопределено Тогда
				ОтветственныйРабочий = ОтветственныйВход;
			Иначе
				ОтветственныйРабочий = МероприятиеВход.Ответственный;
			КонецЕсли;
			// Отправка задачи.
			Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() И ЗначениеЗаполнено(ОтветственныйРабочий) Тогда
				// Создание задачи.
				Имя = "Задачи";
				ЗадачаОбъект = Справочники[Имя].СоздатьЭлемент();
				ЗадачаОбъект.СвязанныйОбъект = МероприятиеВход;
				ЗадачаОбъект.Записать();
				Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
					Модуль = ОбщегоНазначения.ОбщийМодуль("МодульРегламентныхЗаданийУХ");
					Модуль.СоздатьЗадачу(ЗадачаОбъект, ОтветственныйРабочий, Неопределено, Неопределено, Неопределено);
				КонецЕсли;					
				Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда 
					// Отправка уведомления с задачей.
					ВидыСобытийОповещений = "Справочник.ВидыСобытийОповещений.ВыполнениеОперацииПоМероприятию";
					ВидСобытия = ПредопределенноеЗначение(ВидыСобытийОповещений);
					СписокРассылки = Новый Массив;
					СписокРассылки.Добавить(ОтветственныйРабочий);
					СтруктураДополнительныхПараметров = Новый Структура;
					Модуль = ОбщегоНазначения.ОбщийМодуль("МодульУправленияОповещениямиУХ");
					РезультатФункции = Модуль.ОповеститьПользователей(ВидСобытия, , МероприятиеВход, СписокРассылки, СтруктураДополнительныхПараметров, ЗадачаОбъект.Ссылка);
				КонецЕсли;		
			Иначе
				ТекстСообщения = НСтр("ru = 'В мероприятии %Мероприятие% не указан ответственный. Отправка отменена.'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Мероприятие%", Строка(МероприятиеВход));
				ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
				РезультатФункции = Ложь;
			КонецЕсли;
		Иначе
			ТекстСообщения = НСтр("ru = 'Не удалось отправить задачу ответственному за мероприятие - мероприятие не указано'");
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
			РезультатФункции = Ложь;
		КонецЕсли;
	Исключение
		ТекстСообщения = НСтр("ru = 'При отправке задачу ответственному за мероприятие %Мероприятие% возникли ошибки: %ОписаниеОшибки%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Мероприятие%", Строка(МероприятиеВход));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки());
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		РезультатФункции = Ложь;
	КонецПопытки;
	Возврат РезультатФункции;
КонецФункции		// ОтправитьЗадачуОтветственномуЗаМероприятие()

#КонецЕсли
