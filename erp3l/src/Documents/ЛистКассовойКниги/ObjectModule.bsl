#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Если КассовыеОрдера.Количество() > 0 Тогда
		КассовыеОрдера.Очистить();
	КонецЕсли;
	ИнициализироватьДокумент(Неопределено);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьЗаполнениеТабличнойЧасти(Отказ);
	ПроверитьДублиДокумента(Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Проведен И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		РежимПроведения = РежимПроведенияДокумента.Неоперативный;
	КонецЕсли;
	
	Если Дата <> КонецДня(Дата) Тогда
		Дата = КонецДня(Дата);
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	КассовыеОрдера.Документ КАК Документ,
	|	КассовыеОрдера.Приход КАК Приход,
	|	КассовыеОрдера.Расход КАК Расход
	|	
	|ПОМЕСТИТЬ КассовыеОрдера
	|ИЗ
	|	&КассовыеОрдера КАК КассовыеОрдера
	|;
	|////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(СуммаРеглПриход), 0) КАК СуммаПоступления,
	|	ЕСТЬNULL(СУММА(СуммаРеглРасход), 0) КАК СуммаВыдачи
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваНаличные.Обороты(,, Регистратор) КАК ДенежныеСредства
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		КассовыеОрдера КАК КассовыеОрдера
	|	ПО
	|		КассовыеОрдера.Документ = ДенежныеСредства.Регистратор
	|;
	|////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(КассовыеОрдера.Приход), 0) КАК СуммаПоступления,
	|	ЕСТЬNULL(СУММА(КассовыеОрдера.Расход), 0) КАК СуммаВыдачи
	|	
	|ИЗ
	|	КассовыеОрдера КАК КассовыеОрдера
	|	
	|ГДЕ
	|	КассовыеОрдера.Документ = НЕОПРЕДЕЛЕНО
	|");
	
	Запрос.УстановитьПараметр("КассовыеОрдера", ЭтотОбъект.КассовыеОрдера.Выгрузить(, "Документ, Приход, Расход"));
	
	Результат = Запрос.ВыполнитьПакет();
	ВыборкаОрдеров = Результат[1].Выбрать();
	ВыборкаОрдеров.Следующий();
	СуммаПоступления = ВыборкаОрдеров.СуммаПоступления;
	СуммаВыдачи = ВыборкаОрдеров.СуммаВыдачи;
	
	ВыборкаКурсовыхРазниц = Результат[2].Выбрать();
	ВыборкаКурсовыхРазниц.Следующий();
	СуммаПоступления = СуммаПоступления + ВыборкаКурсовыхРазниц.СуммаПоступления;
	СуммаВыдачи = СуммаВыдачи + ВыборкаКурсовыхРазниц.СуммаВыдачи;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Кассы.Ссылка КАК Касса
	|ПОМЕСТИТЬ Кассы
	|ИЗ
	|	Справочник.Кассы КАК Кассы
	|ГДЕ
	|	Кассы.Владелец = &Организация
	|	И Кассы.КассоваяКнига = &КассоваяКнига
	|;
	|////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДенежныеСредстваНаличныеОстатки.СуммаРеглОстаток КАК СуммаРеглОстаток
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваНаличные.Остатки(
	|		&КонецПредыдущегоДня,
	|		Организация = &Организация
	|		И Касса В (ВЫБРАТЬ Кассы.Касса ИЗ Кассы)) КАК ДенежныеСредстваНаличныеОстатки
	|");
	
	Запрос.УстановитьПараметр("КонецПредыдущегоДня", НачалоДня(Дата));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("КассоваяКнига", КассоваяКнига);
	
	СуммаКонечныйОстаток = Запрос.Выполнить().Выгрузить()[0].СуммаРеглОстаток
		+ СуммаПоступления - СуммаВыдачи;
	
	ЗаполнитьНомераЛистов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализаицияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Ответственный = Пользователи.ТекущийПользователь();
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ПроверитьЗаполнениеТабличнойЧасти(Отказ)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Таблица.НомерСтроки КАК НомерСтроки,
	|	Таблица.Документ КАК Документ
	|
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	&ТаблицаДокумента КАК Таблица
	|ГДЕ
	|	Таблица.Документ <> НЕОПРЕДЕЛЕНО
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ТаблицаДокумента.НомерСтроки) КАК НомерСтроки,
	|	ТаблицаДокумента.Документ КАК Документ
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Документ
	|ИМЕЮЩИЕ 
	|	КОЛИЧЕСТВО (*) > 1
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Документ КАК Документ,
	|	ВЫБОР КОГДА НАЧАЛОПЕРИОДА(ТаблицаДокумента.Документ.Дата, ДЕНЬ) <> НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ) ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК ОтличаетсяДата,
	|	ВЫБОР КОГДА ТаблицаДокумента.Документ.Организация <> &Организация ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК ОтличаетсяОрганизация,
	|	ВЫБОР КОГДА ТаблицаДокумента.Документ.Касса.КассоваяКнига <> &КассоваяКнига ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК ОтличаетсяКассоваяКнига,
	|	НЕ ТаблицаДокумента.Документ.Проведен КАК ДокументНеПроведен
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|");
	ТаблицаДокумента = КассовыеОрдера.Выгрузить(, "НомерСтроки, Документ");
	Запрос.УстановитьПараметр("ТаблицаДокумента", ТаблицаДокумента);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("КассоваяКнига", КассоваяКнига);
	
	Запрос.УстановитьПараметр("Дата", Дата);
	Массив = Запрос.ВыполнитьПакет();
	
	// Массив[0] - временная таблица "ТаблицаДокумента"
	РезультатЗапросаДубли = Массив[1];
	РезультатЗапросаДокументы = Массив[2];
	
	// Проверяем дубли строк в документе.
	Выборка = РезультатЗапросаДубли.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Документ %1 повторяется в табличной части';
				|en = 'Document %1 is duplicated in the tabular section'"),
			Выборка.Документ);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Документы", Выборка.НомерСтроки, "Документ"),
			,
			Отказ);
		
	КонецЦикла;
	
	// Проверяем документы, указанные в табличной части.
	Выборка = РезультатЗапросаДокументы.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ДокументНеПроведен Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Указан не проведенный документ %1';
					|en = 'Unposted document %1 is specified'"),
				Выборка.Документ);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Документы", Выборка.НомерСтроки, "Документ"),
				,
				Отказ);
		КонецЕсли;
	
		// Проверяем соответствие даты документа и даты листа кассовой книги.
		Если Выборка.ОтличаетсяДата Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Дата документа %1 отличается от даты листа кассовой книги %2';
					|en = 'Date of document %1 differs from the date of cash book sheet %2'"),
				Выборка.Документ,
				Формат(Дата, "ДЛФ=Д") );
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Документы", Выборка.НомерСтроки, "Документ"),
				,
				Отказ);
		КонецЕсли;
	
		// Проверяем соответствие организации документа и листа кассовой книги.
		Если Выборка.ОтличаетсяОрганизация Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Организация документа %1 отличается от организации кассовой книги %2';
					|en = 'Company of document %1 differs from cash book company %2'"),
				Выборка.Документ,
				Организация);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Документы", Выборка.НомерСтроки, "Документ"),
				,
				Отказ);
		КонецЕсли;
		
		// Проверяем соответствие кассовой книги кассы документа и листа кассовой книги
		Если Выборка.ОтличаетсяКассоваяКнига Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Кассовая книга документа %1 отличается от кассовой книги %2';
					|en = 'Cash book of document %1 differs from cash book %2'"),
				Выборка.Документ,
				?(ЗначениеЗаполнено(КассоваяКнига), КассоваяКнига, НСтр("ru = '<Основная кассовая книга организации>';
																		|en = '<Main company cash book>'")));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Документы", Выборка.НомерСтроки, "Документ"),
				,
				Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьДублиДокумента(Отказ)
	
	// Проверка дублей документов за день
	ТекстЗапроса = 
	"
	|ВЫБРАТЬ ПЕРВЫЕ 2
	|	ДокументКассоваяКнига.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЛистКассовойКниги КАК ДокументКассоваяКнига
	|ГДЕ
	|	ДокументКассоваяКнига.Ссылка <> &ТекущийДокумент
	|	И ДокументКассоваяКнига.Организация = &Организация
	|	И ДокументКассоваяКнига.КассоваяКнига = &КассоваяКнига
	|	И ДокументКассоваяКнига.Проведен
	|	И НачалоПериода(ДокументКассоваяКнига.Дата, ДЕНЬ) = &ДатаНач
	|";
		
	Запрос = Новый Запрос(ТекстЗапроса);	
	Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("КассоваяКнига", КассоваяКнига);
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Дата));
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'На дату %1  уже существует проведенный документ: %2';
				|en = 'Posted document already exists on date %1: %2'"),
			Дата, Выборка.Ссылка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			"Дата",
			,
			Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьНомераЛистов()
	
	Если КассовыеОрдера.Количество() > 0 Тогда
	
		ТекстЗапроса = " 
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	КассоваяКнигаДокументы.НомерЛиста КАК НомерЛиста,
		|	ДанныеДокумента.Дата КАК Период
		|ИЗ
		|	Документ.ЛистКассовойКниги КАК ДанныеДокумента
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		Документ.ЛистКассовойКниги.КассовыеОрдера КАК КассоваяКнигаДокументы
		|	ПО
		|		ДанныеДокумента.Ссылка = КассоваяКнигаДокументы.Ссылка
		|ГДЕ
		|	ДанныеДокумента.Организация = &Организация
		|	И ДанныеДокумента.КассоваяКнига = &КассоваяКнига
		|	И ДанныеДокумента.Проведен
		|	И КассоваяКнигаДокументы.НомерЛиста <> 0
		|	И НАЧАЛОПЕРИОДА(ДанныеДокумента.Дата, ДЕНЬ) < НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ)
		|	И НАЧАЛОПЕРИОДА(ДанныеДокумента.Дата, ГОД) = НАЧАЛОПЕРИОДА(&Дата, ГОД)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период УБЫВ,
		|	НомерЛиста УБЫВ
		|";
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("КассоваяКнига", КассоваяКнига);
		Запрос.УстановитьПараметр("Дата", Дата);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ПоследнийНомер = Выборка.НомерЛиста;
		Иначе
			ПоследнийНомер = 0;
		КонецЕсли;
		
		НачальныйНомерЛиста = ПоследнийНомер + 1;
		ТекущийНомерЛиста = ПоследнийНомер + 1;
		
		Сч = 0;
		Для Каждого СтрокаТаблицы Из КассовыеОрдера Цикл
			
			Если СтрокаТаблицы.НомерЛиста <> ТекущийНомерЛиста Тогда
				СтрокаТаблицы.НомерЛиста = ТекущийНомерЛиста;
			КонецЕсли;
			
			КонечныйНомерЛиста = ТекущийНомерЛиста;
			
			Сч = Сч + 1;
			Если Сч >= КоличествоДокументовНаЛисте Тогда
				Сч = 0;
				ТекущийНомерЛиста = ТекущийНомерЛиста + 1;
			КонецЕсли;
			
		КонецЦикла;
		
		Если НачальныйНомерЛиста = КонечныйНомерЛиста Тогда
			ТекущиеНомераЛистов = НачальныйНомерЛиста;
		Иначе
			ТекущиеНомераЛистов = Строка(НачальныйНомерЛиста) + "-" + Строка(КонечныйНомерЛиста); 
		КонецЕсли;
		
	Иначе
		ТекущиеНомераЛистов = "";
	КонецЕсли;
		
	Если НомераЛистов <> ТекущиеНомераЛистов Тогда
		НомераЛистов = ТекущиеНомераЛистов;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
