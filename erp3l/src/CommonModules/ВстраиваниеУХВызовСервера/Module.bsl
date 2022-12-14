#Область ПрограммныйИнтерфейс

#Область Справочник_ДоговорыКонтрагентов

Процедура ДоговорыКонтрагентовОбработкаПолученияФормы(Источник, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		
		ОбработкаПолученияФормыОбъектаДоговора(Источник, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
		
	ИначеЕсли ВидФормы = "ФормаСписка" Или ВидФормы = "ФормаВыбора" Тогда
		
		ОбработкаПолученияФормыСпискаВыбораДоговора(Источник, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
		
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ОбработкаПолученияФормыОбъектаДоговора(Источник, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВидДоговораУХ = Неопределено;
	
	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
		
		ТекущаяВерсияСоглашения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Ключ, "ВерсияСоглашения");
		
		Если ЗначениеЗаполнено(ТекущаяВерсияСоглашения) Тогда
			// Подобрали соответствующую версию соглашения.
			// Придется открыть служебную форму-прослойку, а уже из нее открывать нужный документ.
			// В противном случае можем получить проблемы с проверкой уникальности.
			ВыбраннаяФорма =  Метаданные.Справочники.ДоговорыКонтрагентов.Формы.ФормаОткрытияВерсииСоглашения;
			Параметры.Вставить("ВерсияСоглашения", ТекущаяВерсияСоглашения);
			Возврат;
		Иначе
			// открываем стандартную форму договора с гиперссылкой создания версии соглашения
			СтандартнаяОбработка = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	Если Параметры.Свойство("ВидДоговораУХ") Тогда 
		ВидДоговораУХ = Параметры.ВидДоговораУХ;		
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(ВидДоговораУХ) И Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ПараметрыЗначенияКопирования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.ЗначениеКопирования, "ВидДоговораУХ,ВерсияСоглашения");
		ВидДоговораУХ = ПараметрыЗначенияКопирования.ВидДоговораУХ;
		// Подменим значение копирования.
		Параметры.ЗначениеКопирования = ПараметрыЗначенияКопирования.ВерсияСоглашения;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидДоговораУХ) И Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("ВидДоговораУХ") Тогда
		ВидДоговораУХ = Параметры.Отбор.ВидДоговораУХ;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВидДоговораУХ) Тогда
		Если Параметры.Свойство("ЗначенияЗаполнения") 
			И ТипЗнч(Параметры.ЗначенияЗаполнения) = Тип("Структура") Тогда
			
			Если Параметры.ЗначенияЗаполнения.Свойство("ВстречныйДоговор")
				И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения.ВстречныйДоговор) Тогда
				ВидДоговораУХ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ЗначенияЗаполнения.ВстречныйДоговор, "ВидДоговораУХ");
			ИначеЕсли Параметры.ЗначенияЗаполнения.Свойство("БазовыйДоговор")
				И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения.БазовыйДоговор) Тогда
				ВидДоговораУХ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ЗначенияЗаполнения.БазовыйДоговор, "ВидДоговораУХ");
			ИначеЕсли Параметры.ЗначенияЗаполнения.Свойство("ВидДоговораУХ") Тогда
				ТипВидДоговора = ТипЗнч(Параметры.ЗначенияЗаполнения.ВидДоговораУХ);
				Если ТипВидДоговора = Тип("СправочникСсылка.ВидыДоговоровКонтрагентовУХ") Тогда
					ВидДоговораУХ = Параметры.ЗначенияЗаполнения.ВидДоговораУХ;
				ИначеЕсли (ТипВидДоговора = Тип("Массив") ИЛИ ТипВидДоговора = Тип("ФиксированныйМассив"))
					 И Параметры.ЗначенияЗаполнения.ВидДоговораУХ.Количество() = 1 Тогда
					ВидДоговораУХ = Параметры.ЗначенияЗаполнения.ВидДоговораУХ[0];
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидДоговораУХ) ИЛИ ТипЗнч(ВидДоговораУХ) <> Тип("СправочникСсылка.ВидыДоговоровКонтрагентовУХ") Тогда
		
		ТипСправочникаДоговора = Источник.ПустаяСсылка().Метаданные().Имя;
		
		// Получим все подходящие виды договоров
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 2
		|	ВидыДоговоровКонтрагентовУХ.Ссылка КАК ВидДоговораУХ
		|ИЗ
		|	Справочник.ВидыДоговоровКонтрагентовУХ КАК ВидыДоговоровКонтрагентовУХ
		|ГДЕ
		|	НЕ ВидыДоговоровКонтрагентовУХ.ЭтоГруппа
		|	И НЕ ВидыДоговоровКонтрагентовУХ.ПометкаУдаления
		|	И ВидыДоговоровКонтрагентовУХ.ТипСправочникаДоговора = &ТипСправочникаДоговора";
		Запрос.УстановитьПараметр("ТипСправочникаДоговора", ТипСправочникаДоговора);
		ВидыДоговоров = Запрос.Выполнить().Выгрузить();
		Если ВидыДоговоров.Количество() = 1 Тогда
			ВидДоговораУХ = ВидыДоговоров[0].ВидДоговораУХ
	
		Иначе
			ВыбраннаяФорма = Метаданные.Справочники.ДоговорыКонтрагентов.Формы.ФормаВыбораВидаДоговора;
			// Добавим фильтр по виду справочника.
			Если Не Параметры.Свойство("Отбор") Тогда
				Параметры.Вставить("Отбор", Новый Структура);
			КонецЕсли;
			
			Параметры.Отбор.Вставить(
				"ТипСправочникаДоговора",
				ТипСправочникаДоговора);
		КонецЕсли;
	КонецЕсли;
			
	Если ЗначениеЗаполнено(ВидДоговораУХ) Тогда
		
		Если Не Параметры.Свойство("ЗначенияЗаполнения") Тогда
			Параметры.Вставить("ЗначенияЗаполнения", Новый Структура);
		КонецЕсли;
		
		Если Не Параметры.ЗначенияЗаполнения.Свойство("ВидДоговораУХ") Тогда
			Параметры.ЗначенияЗаполнения.Вставить("ВидДоговораУХ", ВидДоговораУХ);
		КонецЕсли;
		
		ИмяДокумента = УправлениеДоговорамиУХВызовСервераПовтИсп.ПолучитьИмяДокументаПоВидуДоговора(ВидДоговораУХ);
		Если ЗначениеЗаполнено(ИмяДокумента) Тогда
			ВыбраннаяФорма = Метаданные.Документы[ИмяДокумента].ОсновнаяФормаОбъекта;
		Иначе
			ВызватьИсключение НСтр("ru = 'Невозможно определить тип версии соглашения.'");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПолученияФормыСпискаВыбораДоговора(Источник, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") Тогда
		
		Отбор = Параметры.Отбор;
		
		Если Отбор.Свойство("Владелец") И Не Отбор.Свойство("Контрагент") Тогда
			
			//в случае выбора в субконто в связке со статьей доходов, владельцем может выступать ПВХ, 
			//в таком случае отбор не устанавливаем			
			Если ТипЗнч(Отбор.Владелец) = Тип("СправочникСсылка.Контрагенты")
				Или ТипЗнч(Отбор.Владелец) = Тип("СправочникСсылка.Партнеры") Тогда
			
				Отбор.Вставить("Контрагент", Отбор.Владелец);
				Отбор.Удалить("Владелец");
			
			КонецЕсли;

		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Получить договор контрагента ВГО по договору организации.
//
// Параметры:
//  Договор - СправочникСсылка.ДоговорыКонтрагентов - ссылка на договор организации.
// 
// Возвращаемое значение:
//  СправочникСсылка.ДоговорыКонтрагентов - договор соответствующий реквизитами
//		договору контрагента из исходного договора.
//   Если не подходящий договор не найден, то возвращает пустую ссылку.
//
Функция ПолучитьДоговорКонтрагентаВГО(Договор) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Договор) Тогда
		Возврат Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СвязанныеДоговоры.СвязанныйДоговор КАК СвязанныйДоговор
	|ПОМЕСТИТЬ втСвязи
	|ИЗ
	|	РегистрСведений.СвязанныеДоговоры КАК СвязанныеДоговоры
	|ГДЕ
	|	СвязанныеДоговоры.БазовыйДоговор = &Договор
	|	И СвязанныеДоговоры.ВидСвязи.Внутригрупповой
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	т.СвязанныйДоговор КАК СвязанныйДоговор
	|ИЗ
	|	втСвязи КАК т
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВозвращаемыйДоговор.Ссылка
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ИсходныйДоговор
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ВозвращаемыйДоговор
	|		ПО ИсходныйДоговор.Контрагент.ОрганизационнаяЕдиница = ВозвращаемыйДоговор.Организация
	|			И ИсходныйДоговор.Организация = ВозвращаемыйДоговор.Контрагент.ОрганизационнаяЕдиница
	|			И (НЕ ВозвращаемыйДоговор.ПометкаУдаления)
	|			И (НЕ ИсходныйДоговор.ПометкаУдаления)
	|			И ИсходныйДоговор.ВалютаВзаиморасчетов = ВозвращаемыйДоговор.ВалютаВзаиморасчетов
	|			И ИсходныйДоговор.ДатаНачалаДействия = ВозвращаемыйДоговор.ДатаНачалаДействия
	|			И ИсходныйДоговор.ДатаОкончанияДействия = ВозвращаемыйДоговор.ДатаОкончанияДействия
	|			И ИсходныйДоговор.Номер = ВозвращаемыйДоговор.Номер
	|			И (ИсходныйДоговор.Ссылка = &Договор)
	|			И (НЕ ИСТИНА В
	|					(ВЫБРАТЬ
	|						ИСТИНА
	|					ИЗ
	|						втСвязи КАК т))");
	
	Запрос.УстановитьПараметр("Договор", Договор);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить().Получить(0).Получить(0);
		
КонецФункции

#КонецОбласти

#Область ОбъектыРасчетов
Процедура ОбъектыРасчетовОбработкаПолученияФормы(Источник, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	// открываем вместо формы договора, форму версии соглашения
	Если ВыбраннаяФорма = "Справочник.ДоговорыКонтрагентов.Форма.ФормаЭлемента"
		ИЛИ ВыбраннаяФорма = "Справочник.ДоговорыКредитовИДепозитов.Форма.ФормаЭлемента" Тогда
		
		ОбработкаПолученияФормыОбъектаДоговора(Источник, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

Функция ПолучитьПТУ(РТУ) Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПоступлениеТоваровУслуг.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг КАК ПоступлениеТоваровУслуг
	|ГДЕ
	|	ПоступлениеТоваровУслуг.ДокументОснование = &ДокументОснование");
	Запрос.УстановитьПараметр("ДокументОснование", РТУ);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ТипПТУ = ВстраиваниеУХ.ТипДокументСсылкаПоступлениеТоваровУслуг();
		Возврат Новый (ТипПТУ);//пустая ссылка 
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить().Получить(0).Получить(0);
	
КонецФункции

Функция ЕстьУчетнаяПолитика(Организация, ДатаСреза = Неопределено) Экспорт	
	Возврат РегистрыСведений.УчетнаяПолитикаБухУчета.ПолучитьПоследнее(ДатаСреза, Новый Структура("Организация", Организация)).Количество() > 0;
КонецФункции

Функция ПолучитьСчетВзаиморасчетов(Договор, РольСчета = Неопределено) Экспорт
	
	Роль = ?(РольСчета = Неопределено, "РасчетыСПоставщиком", РольСчета);
	
	ИмяРеквизита = ?(Роль = "РасчетыСПоставщиком", "РасчетыСПоставщиками", "РасчетыСКлиентами");  
	
	РазделыУчета = РегистрыСведений.ПорядокОтраженияНаСчетахУчета.РазделыУчетаПоАналитикеУчета(Договор.ГруппаФинансовогоУчета);
	ПараметрыНастройкиСчетовУчета = НастройкаСчетовУчетаСервер.ПараметрыНастройкиСчетовУчета(РазделыУчета);
	
	СчетаУчета = Новый Массив;
	Субконто = Новый Массив;
	
	Для каждого НастройкаРаздела Из ПараметрыНастройкиСчетовУчета.НастройкиРазделов Цикл
		СчетаРаздела = ОбщегоНазначенияКлиентСервер.ОтмеченныеЭлементы(НастройкаРаздела.Значение.СчетаУчета);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СчетаУчета, СчетаРаздела, Истина);
		СубконтоРаздела = ОбщегоНазначенияКлиентСервер.ОтмеченныеЭлементы(НастройкаРаздела.Значение.Субконто);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Субконто, СубконтоРаздела, Истина);
	КонецЦикла;
	
	ЗначенияСчетов = РегистрыСведений.ПорядокОтраженияНаСчетахУчета.СтруктураЗначенийПоАналитикеУчета(
		Договор.ГруппаФинансовогоУчета, СчетаУчета);
		
	ИмяСчета = "СчетУчета_" + ИмяРеквизита;	
	Возврат ?(ЗначенияСчетов.Свойство(ИмяСчета), ЗначенияСчетов[ИмяСчета], ПланыСчетов.Хозрасчетный.ПустаяСсылка());
	
КонецФункции

Функция ВсеТипыСвязанныхСубконто() Экспорт
		
	СвязанныеСубконто = Новый Соответствие;
	
	ТипыСубконто = Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов");
	ТипыСубконто = Новый ОписаниеТипов(ТипыСубконто, Документы.ТипВсеСсылки().Типы());
	СвязанныеСубконто.Вставить("Контрагент", ТипыСубконто);
	
	ТипыСубконто = Документы.ТипВсеСсылки();
	СвязанныеСубконто.Вставить("ДоговорКонтрагента", ТипыСубконто);
	
	ТипыСубконто = Документы.ТипВсеСсылки();
	СвязанныеСубконто.Вставить("Номенклатура", ТипыСубконто);
	
	СвязанныеСубконто.Вставить("Организация", Новый ОписаниеТипов(Документы.ТипВсеСсылки(), 
		"СправочникСсылка.БанковскиеСчетаОрганизаций, СправочникСсылка.ПодразделенияОрганизаций,
		|СправочникСсылка.ДоговорыКонтрагентов, СправочникСсылка.ДоговорыКредитовИДепозитов, СправочникСсылка.ДоговорыАренды,
		|СправочникСсылка.ДоговорыМеждуОрганизациями, СправочникСсылка.РегистрацииВНалоговомОргане"));
	
	Возврат СвязанныеСубконто;
	
КонецФункции

// Функция возвращает значение ставки НДС.
//
// Параметры:
//  СтавкаНДС - ПеречислениеСсылка.СтавкиНДС;
//  ПрименяютсяСтавки4и2 - Неопределено - не учитыватся. Нужен для совместимости
//		с подсистемой учета НДС 1С: Бухгалтерии.
//
// Возвращаемое значение:
//  Число - значение ставки.
//
Функция ПолучитьСтавкуНДС(СтавкаНДС, ПрименяютсяСтавки4и2=Неопределено) Экспорт
	РезультатФункции = Справочники.СтавкиНДС.ПустаяСсылка();
	Если ТипЗнч(СтавкаНДС) = Тип("ПеречислениеСсылка.СтавкиНДС") Тогда
		РезультатФункции = УчетНДСЛокализация.СтавкаНДСПоПеречислению(СтавкаНДС);
	ИначеЕсли ТипЗнч(СтавкаНДС) = Тип("СправочникСсылка.СтавкиНДС") Тогда
		РезультатФункции = СтавкаНДС;
	Иначе
		РезультатФункции = УчетНДСЛокализация.СтавкаНДСПоПеречислению(СтавкаНДС);
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

#КонецОбласти
