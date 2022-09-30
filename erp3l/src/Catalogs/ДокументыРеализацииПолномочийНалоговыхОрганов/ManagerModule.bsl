#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обработчик обновления БРО 1.0.1.41
//
Процедура ОбновитьДокументыРеализацииПолномочийНалоговыхОрганов() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЦиклыОбмена.Ссылка КАК ЦиклОбменаСсылка,
		|	ЦиклыОбмена.ВнешняяОрганизация КАК ЦиклОбменаВнешняяОрганизация,
		|	ЦиклыОбмена.Организация КАК ЦиклОбменаОрганизация,
		|	ЦиклыОбмена.Предмет КАК Предмет,
		|	ЦиклыОбмена.Предмет.ДатаСообщения КАК ПредметДатаСообщения,
		|	ЦиклыОбмена.Предмет.ДатаОтправки КАК ПредметДатаОтправки,
		|	ЦиклыОбмена.Предмет.Идентификатор КАК ПредметИдентификатор,
		|	ЦиклыОбмена.Предмет.ИдентификаторОснования КАК ПредметИдентификаторОснования,
		|	ЦиклыОбменаДополнительныеПредметы.Предмет КАК ДопПредмет,
		|	СтатусыОтправки.Статус КАК СтатусОтправкиПредмета
		|ИЗ
		|	Справочник.ЦиклыОбмена КАК ЦиклыОбмена
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыОтправки КАК СтатусыОтправки
		|		ПО ЦиклыОбмена.Предмет = СтатусыОтправки.Объект
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЦиклыОбмена.ДополнительныеПредметы КАК ЦиклыОбменаДополнительныеПредметы
		|		ПО (ЦиклыОбменаДополнительныеПредметы.Ссылка = ЦиклыОбмена.Ссылка)
		|ГДЕ
		|	ЦиклыОбмена.Тип = &ТипЦиклаДокумент
		|	И ЦиклыОбмена.Предмет ССЫЛКА Справочник.ДокументыРеализацииПолномочийНалоговыхОрганов
		|ИТОГИ ПО
		|	ЦиклОбменаСсылка,
		|	СтатусОтправкиПредмета";

	Запрос.УстановитьПараметр("ТипЦиклаДокумент", Перечисления.ТипыЦикловОбмена.Документ);
	Запрос.УстановитьПараметр("ТипСодержимогоДокумент", Перечисления.ТипыСодержимогоТранспортногоКонтейнера.Документ);

	Результат = Запрос.Выполнить();
	
	ВыборкаСсылка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	НачатьТранзакцию();
	
	Пока ВыборкаСсылка.Следующий() Цикл
		
		// создаем документ опись входящих документов в ИБ
		ОписьДокументов = Справочники.ОписиВходящихДокументовИзНалоговыхОрганов.СоздатьЭлемент();
		ОписьДокументов.НалоговыйОрган 			= ВыборкаСсылка.ЦиклОбменаВнешняяОрганизация;
		ОписьДокументов.Организация 			= ВыборкаСсылка.ЦиклОбменаОрганизация;
		ОписьДокументов.Идентификатор 			= ВыборкаСсылка.ПредметИдентификатор;
		ОписьДокументов.ИдентификаторОснования 	= ВыборкаСсылка.ПредметИдентификаторОснования;
		ОписьДокументов.ДатаСообщения 			= ВыборкаСсылка.ПредметДатаСообщения;
		ОписьДокументов.ДатаОтправки 			= ВыборкаСсылка.ПредметДатаОтправки;
		
		ОписьДокументов.Наименование = "Опись входящих документов от НО " + ОписьДокументов.НалоговыйОрган + " от " + Формат(ОписьДокументов.ДатаСообщения, "ДЛФ=D");
		
		// начинаем заполнять табличную часть
		// первый предмет
		НоваяСтрока = ОписьДокументов.ВходящиеДокументы.Добавить();
		НоваяСтрока.СсылкаНаОбъект = ВыборкаСсылка.Предмет;
		
		ВыборкаСтатусОтправки = ВыборкаСсылка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Если ВыборкаСтатусОтправки.Следующий() Тогда
			
			СтатусОтправки = ВыборкаСтатусОтправки.СтатусОтправкиПредмета;
			
			ВыборкаДетальныеЗаписи = ВыборкаСтатусОтправки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ДопПредмет) Тогда
					НоваяСтрока = ОписьДокументов.ВходящиеДокументы.Добавить();
					НоваяСтрока.СсылкаНаОбъект = ВыборкаДетальныеЗаписи.ДопПредмет;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
				
		Попытка
			ОписьДокументов.ОбменДанными.Загрузка = Истина;
			ОписьДокументов.Записать();
			
			// скопировать статус отправки с предыдущего предмета
			МенЗап = РегистрыСведений.СтатусыОтправки.СоздатьМенеджерЗаписи();
			МенЗап.Объект = ОписьДокументов.Ссылка;
			МенЗап.Статус = СтатусОтправки;
			МенЗап.Записать(Истина);
			
			// замена предметов цикла обмена  на один предмет - элемент нового справочника
			ЦиклОбменаОбъект = ВыборкаСсылка.ЦиклОбменаСсылка.ПолучитьОбъект();
			ЦиклОбменаОбъект.ДополнительныеПредметы.Очистить();
			ЦиклОбменаОбъект.Предмет = ОписьДокументов.Ссылка;
			
			ЦиклОбменаОбъект.ОбменДанными.Загрузка = Истина;
			
			ЦиклОбменаОбъект.Записать();

		Исключение
			ОтменитьТранзакцию();
			Возврат;
		КонецПопытки;
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
КонецПроцедуры

Функция ДанныеТребованияОПредставленииПоясненийКДекларацииНДС(Требование) Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Если КонтекстЭДОСервер = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат КонтекстЭДОСервер.ДанныеТребованияОПредставленииПоясненийКДекларацииНДС(Требование);
	
КонецФункции

Функция НаименованиеДокументаРеализацииПолномочий(Знач Требование, ПриложенияТребования = Неопределено) Экспорт
	
	Наименование = "";
	ДатаЖалобы   = Формат(Требование.ДатаЖалобы, "ДЛФ=D");
	
	Номер = СокрЛП(СтрЗаменить(Требование.НомерДокумента, "номер", ""));
	Дата  = Формат(Требование.ДатаДокумента, "ДЛФ=D");
	
	Если Требование.ВидДокумента = Перечисления.ВидыНалоговыхДокументов.ТребованиеОПредставленииПоясненийКДекларацииНДС Тогда
		
		Если ВТребованииЕстьXMLФайл(ПриложенияТребования) Тогда
			Наименование = НСтр("ru = 'Требование %Номер% от %Дата% о представлении пояснений к декларации по НДС %ПредставлениеДекларации%';
								|en = 'Требование %Номер% от %Дата% о представлении пояснений к декларации по НДС %ПредставлениеДекларации%'");
			Наименование = СтрЗаменить(Наименование, "%ПредставлениеДекларации%", ПредставлениеДекларации(Требование, ПриложенияТребования));
		Иначе
			Наименование = НСтр("ru = 'Требование %Номер% от %Дата% о представлении пояснений';
								|en = 'Требование %Номер% от %Дата% о представлении пояснений'");
		КонецЕсли;
		
		Наименование = СтрЗаменить(Наименование, "%Номер%", Номер);
		Наименование = СтрЗаменить(Наименование, "%Дата%",  Дата);
		
	ИначеЕсли Требование.ВидДокумента = Перечисления.ВидыНалоговыхДокументов.РешениеПоЖалобе Тогда
		
		Если ЗначениеЗаполнено(Требование.НомерЖалобы) И ЗначениеЗаполнено(Требование.ДатаЖалобы) Тогда
			Наименование = НСтр("ru = 'Решение №%1 от %2 по жалобе №%3 от %4';
								|en = 'Решение №%1 от %2 по жалобе №%3 от %4'");
			Наименование = СтрШаблон(
				Наименование,
				Номер,
				Дата,
				Требование.НомерЖалобы,
				ДатаЖалобы);
		Иначе
				
			Наименование = НСтр("ru = 'Решение №%1 от %2 по жалобе от %3';
								|en = 'Решение №%1 от %2 по жалобе от %3'");
			Наименование = СтрШаблон(
				Наименование,
				Номер,
				Дата,
				ДатаЖалобы);
				
		КонецЕсли;
		
	ИначеЕсли Требование.ВидДокумента = Перечисления.ВидыНалоговыхДокументов.КвитанцияОПрисвоенииРНПТ Тогда
		
		ПредставлениеНомера = ?(НЕ ЗначениеЗаполнено(Номер) ИЛИ СтрДлина(Номер) > 10, "", "№" + Номер);
		ДатаУведомления = Формат(Требование.ДатаУведомления, "ДЛФ=D");
		
		Если ЗначениеЗаполнено(Требование.НомерУведомления) И ЗначениеЗаполнено(Требование.ДатаУведомления) Тогда
			Наименование = НСтр("ru = 'Квитанция о присвоении РНПТ%1 от %2 по уведомлению №%3 от %4';
								|en = 'Квитанция о присвоении РНПТ%1 от %2 по уведомлению №%3 от %4'");
			Наименование = СтрШаблон(
				Наименование,
				?(ПредставлениеНомера = "", "", " " + ПредставлениеНомера),
				Дата,
				Требование.НомерУведомления,
				ДатаУведомления);
			
		Иначе
			Наименование = НСтр("ru = 'Квитанция о присвоении РНПТ%1 от %2 по уведомлению от %3';
								|en = 'Квитанция о присвоении РНПТ%1 от %2 по уведомлению от %3'");
			Наименование = СтрШаблон(
				Наименование,
				?(ПредставлениеНомера = "", "", " " + ПредставлениеНомера),
				Дата,
				ДатаУведомления);
		КонецЕсли;
		
	Иначе
		Наименование = Строка(Требование.ВидДокумента) + " № " + Номер + " от " + Дата;
	КонецЕсли;
	
	Возврат Наименование;
		
КонецФункции

Функция ВТребованииЕстьXMLФайл(ПриложенияТребования)

	Для Каждого Приложение Из ПриложенияТребования Цикл
		Если ВРег(Прав(Приложение.ИмяФайла, 3)) = "XML" Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла; 
	
	Возврат Ложь;

КонецФункции

Функция ПредставлениеДекларации(Знач Требование, ПриложенияТребования = Неопределено) Экспорт
	
	// Добавляем сведения по декларации, если удается их получить
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	СвойстваДекларации = КонтекстЭДОСервер.СвойстваДекларацииИзФайлаТребованияОПредставленииПоясненийКДекларацииНДС(Требование, ПриложенияТребования);
	
	Представление = "";
	Если СвойстваДекларации <> Неопределено Тогда
		
		Представление = НСтр("ru = 'за %Период% %Год% г.%Уточнение%';
							|en = 'за %Период% %Год% г.%Уточнение%'");
		Представление = СтрЗаменить(Представление, "%Период%", НРег(СвойстваДекларации.Период));
		Представление = СтрЗаменить(Представление, "%Год%", СвойстваДекларации.Год);
		
		Если СвойстваДекларации.НомерКорректировки = 0 Тогда
			Уточнение = "";
		Иначе
			Уточнение = НСтр("ru = ' (К/%НомерУточнения%)';
							|en = ' (К/%НомерУточнения%)'");
			Уточнение = СтрЗаменить(Уточнение, "%НомерУточнения%", Строка(СвойстваДекларации.НомерКорректировки));
		КонецЕсли;
		
		Представление = СтрЗаменить(Представление, "%Уточнение%", Уточнение);
		
	КонецЕсли;
	
	Возврат Представление;
		
КонецФункции

// Функция - Возвращает ответы с незавершенным документооборотом и
// 	и ответы с документооборотом, завершенным успешно.
//
// Параметры:
//  Требование	 - ДокументСсылка
// Возвращаемое значение:
//  Массив - ответы
Функция ОтправленныеОтветыНаТребованиеПоясненийКДекларацииНДС(Требование) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоясненияКДекларацииПоНДС.Ссылка
		|ПОМЕСТИТЬ ВсеОтветы
		|ИЗ
		|	Документ.ПоясненияКДекларацииПоНДС КАК ПоясненияКДекларацииПоНДС
		|ГДЕ
		|	ПоясненияКДекларацииПоНДС.Требование = &ТребованиеСсылка
		|	И ПоясненияКДекларацииПоНДС.ПометкаУдаления = ЛОЖЬ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЦиклыОбмена.Ссылка,
		|	ЦиклыОбмена.Предмет
		|ПОМЕСТИТЬ ЦиклыОбменаОтветов
		|ИЗ
		|	Справочник.ЦиклыОбмена КАК ЦиклыОбмена
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВсеОтветы КАК ВсеОтветы
		|		ПО ЦиклыОбмена.Предмет = ВсеОтветы.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЦиклыОбменаОтветов.Предмет КАК Ответ
		|ПОМЕСТИТЬ ОтправленныеОтветы
		|ИЗ
		|	Документ.ТранспортноеСообщение КАК ТранспортноеСообщение
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ЦиклыОбменаОтветов КАК ЦиклыОбменаОтветов
		|		ПО ТранспортноеСообщение.ЦиклОбмена = ЦиклыОбменаОтветов.Ссылка
		|ГДЕ
		|	ТранспортноеСообщение.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыТранспортныхСообщений.ПредставлениеНП)
		|	И ТранспортноеСообщение.ПометкаУдаления = ЛОЖЬ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТранспортноеСообщение.Ссылка КАК ТранспортноеСообщение,
		|	ЦиклыОбменаОтветов.Предмет КАК Ответ,
		|	ТранспортноеСообщение.ПротоколСОшибкой
		|ПОМЕСТИТЬ ТранспортныеСообщенияСРезультатамиПриема
		|ИЗ
		|	Документ.ТранспортноеСообщение КАК ТранспортноеСообщение
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ЦиклыОбменаОтветов КАК ЦиклыОбменаОтветов
		|		ПО ТранспортноеСообщение.ЦиклОбмена = ЦиклыОбменаОтветов.Ссылка
		|ГДЕ
		|	ТранспортноеСообщение.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыТранспортныхСообщений.РезультатПриемаПредставлениеНО)
		|	И ТранспортноеСообщение.ПометкаУдаления = ЛОЖЬ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТранспортныеСообщенияСРезультатамиПриема.Ответ
		|ПОМЕСТИТЬ ОтветыНеПринятые
		|ИЗ
		|	ТранспортныеСообщенияСРезультатамиПриема КАК ТранспортныеСообщенияСРезультатамиПриема
		|ГДЕ
		|	ТранспортныеСообщенияСРезультатамиПриема.ПротоколСОшибкой = ИСТИНА
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТранспортныеСообщенияСРезультатамиПриема.ТранспортноеСообщение,
		|	ТранспортныеСообщенияСРезультатамиПриема.Ответ
		|ПОМЕСТИТЬ ТранспортныеСообщенияУспешноПринятые
		|ИЗ
		|	ТранспортныеСообщенияСРезультатамиПриема КАК ТранспортныеСообщенияСРезультатамиПриема
		|ГДЕ
		|	ТранспортныеСообщенияСРезультатамиПриема.ПротоколСОшибкой = ЛОЖЬ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОтправленныеОтветы.Ответ
		|ПОМЕСТИТЬ ОтправленныеБезОшибочных
		|ИЗ
		|	ОтправленныеОтветы КАК ОтправленныеОтветы
		|ГДЕ
		|	НЕ ОтправленныеОтветы.Ответ В
		|				(ВЫБРАТЬ
		|					ОтветыНеПринятые.Ответ
		|				ИЗ
		|					ОтветыНеПринятые КАК ОтветыНеПринятые)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОтправленныеБезОшибочных.Ответ
		|ИЗ
		|	ОтправленныеБезОшибочных КАК ОтправленныеБезОшибочных
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТранспортныеСообщенияУспешноПринятые.Ответ
		|ИЗ
		|	ТранспортныеСообщенияУспешноПринятые КАК ТранспортныеСообщенияУспешноПринятые";

	Запрос.УстановитьПараметр("ТребованиеСсылка", Требование);

	МассивОтветов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ответ");

	Возврат МассивОтветов;
	
КонецФункции

// Функция - Печатная форма
Функция ПечатнаяФорма(ДокументНО) Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Если КонтекстЭДОСервер = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ДокументНО.ВидДокумента <> Перечисления.ВидыНалоговыхДокументов.КвитанцияОПрисвоенииРНПТ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НаименованиеСобственника = ?(ЗначениеЗаполнено(ДокументНО.НаименованиеСобственника),
		ДокументНО.НаименованиеСобственника, ДокументНО.ФИОСобственника);
	НаименованиеОтправителяУведомления = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
		ДокументНО.Организация,, "НаимЮЛПол").НаимЮЛПол;
	ДатаДоставкиУведомления = ДокументНО.ДатаУведомления;
	ПоследнийЦиклОбмена = ДокументооборотСКОВызовСервера.ПолучитьПоследнийЦиклОбмена(ДокументНО);
	Если ПоследнийЦиклОбмена <> Неопределено Тогда
		СообщенияЦиклаОбмена = КонтекстЭДОСервер.ПолучитьСообщенияЦиклаОбмена(ПоследнийЦиклОбмена,
			Перечисления.ТипыТранспортныхСообщений.ДокументНО);
		Если СообщенияЦиклаОбмена <> Неопределено И СообщенияЦиклаОбмена.Количество() > 0 Тогда
			ДатаДоставкиУведомления = СообщенияЦиклаОбмена[0].ДатаТранспорта;
		КонецЕсли;
	КонецЕсли;
	СтрокиНаименованияОтправителяУведомления = КонтекстЭДОСервер.РазделитьНаименование(
		НаименованиеОтправителяУведомления, 45);
	СтрокиНаименованияСобственника = КонтекстЭДОСервер.РазделитьНаименование(НаименованиеСобственника, 20);
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	// получаем бланк отчета из макета
	Макет = КонтекстЭДОСервер.ПолучитьМакетОбработки("КвитанцияОПрисвоенииРНПТ");
	ОбластьМакета = Макет.ПолучитьОбласть("КвитанцияОПрисвоенииРНПТ");
	
	ОбластьМакета.Параметры.РНПТ = ДокументНО.РНПТ;
	ОбластьМакета.Параметры.ВидУведомления = ДокументНО.ВидУведомления;
	ОбластьМакета.Параметры.ДатаДоставкиУведомления = Формат(ДатаДоставкиУведомления, "ДФ=dd.MM.yyyy");
	ОбластьМакета.Параметры.НаименованиеОтправителяУведомления =
		СтрокиНаименованияОтправителяУведомления.НачалоНаименования;
	ОбластьМакета.Параметры.ОкончаниеНаименованияОтправителяУведомления =
		СтрокиНаименованияОтправителяУведомления.ОкончаниеНаименования;
	ОбластьМакета.Параметры.НомерУведомления = ДокументНО.НомерУведомления;
	ОбластьМакета.Параметры.ДатаУведомления = Формат(ДокументНО.ДатаУведомления, "ДФ=dd.MM.yyyy");
	ОбластьМакета.Параметры.НаименованиеСобственника = СтрокиНаименованияСобственника.НачалоНаименования;
	ОбластьМакета.Параметры.ОкончаниеНаименованияСобственника = СтрокиНаименованияСобственника.ОкончаниеНаименования;
	ОбластьМакета.Параметры.ИННСобственника = ДокументНО.ИННСобственника;
	ОбластьМакета.Параметры.КППСобственника = ДокументНО.КППСобственника;
	
	ТабДокумент.Вывести(ОбластьМакета);
	
	Если ДокументНО.ОшибкиНСП.Количество() > 0 Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокОшибок");
		ТабДокумент.Вывести(ОбластьМакета);
		
		Для каждого ОшибкаНСП Из ДокументНО.ОшибкиНСП Цикл
			ОбластьМакета = Макет.ПолучитьОбласть("ОшибкаНСП");
			Если ЗначениеЗаполнено(ОшибкаНСП.ТекстОшибки) Тогда
				ОбластьМакета.Параметры.ТекстИКодОшибкиНСП = СтрШаблон(
					"%1 (код %2)",
					ОшибкаНСП.ТекстОшибки,
					ОшибкаНСП.КодОшибки);
			Иначе
				ОбластьМакета.Параметры.ТекстИКодОшибкиНСП = СтрШаблон(
					"Код %1",
					ОшибкаНСП.КодОшибки);
			КонецЕсли;
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
	КонецЕсли;
	
	ОбластьМакета = Макет.ПолучитьОбласть("ПодвалКвитанции");
	ТабДокумент.Вывести(ОбластьМакета);
	
	ТипыСообщений = Новый Массив;
	ТипыСообщений.Добавить(Перечисления.ТипыТранспортныхСообщений.ДокументНО);
	КонтекстЭДОСервер.ДобавитьШтампПодписиПодДокументом(
		ДокументНО,
		ТипыСообщений,
		ТабДокумент,
		2,
		Ложь); 
	
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабДокумент;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	// инициализируем контекст ЭДО - модуль обработки
	ТекстСообщения = "";
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДО = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	КонтекстЭДО.ОбработкаПолученияФормы("Справочник", "ДокументыРеализацииПолномочийНалоговыхОрганов", ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
