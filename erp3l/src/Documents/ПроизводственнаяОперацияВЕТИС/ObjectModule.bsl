#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияВЕТИСПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
	МассивПродукции = Товары.Выгрузить(,"Продукция").ВыгрузитьКолонку("Продукция");
	СоответствиеТипЖивыеЖивотные = ИнтеграцияВЕТИСВызовСервера.ПродукцияПринадлежитТипуЖивыеЖивотные(МассивПродукции);
	Для каждого СтрокаТабличнойЧасти Из Товары Цикл
		Если СоответствиеТипЖивыеЖивотные[СтрокаТабличнойЧасти.Продукция] = Истина Тогда
			ИнтеграцияВЕТИСКлиентСервер.СброситьЗначенияПоСтрокеСЖивымиЖивотными(СтрокаТабличнойЧасти);
		КонецЕсли;
	КонецЦикла;
	
	Документы.ПроизводственнаяОперацияВЕТИС.ЗаполнитьДанныеЭкспертизыПоСтатистикеПользователя(ЭтотОбъект);
	Документы.ПроизводственнаяОперацияВЕТИС.ЗаполнитьСрокиГодностиПоСтатистикеПродукции(ЭтотОбъект);
	Документы.ПроизводственнаяОперацияВЕТИС.ЗаполнитьУпаковкиПоСтатистикеПродукции(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ИнтеграцияИС.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ПроизводственнаяОперацияВЕТИС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ИнтеграцияИС.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ИнтеграцияИСПереопределяемый.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	ИнтеграцияВЕТИС.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения, "ДвиженияСерийТоваров");
	
	ИнтеграцияИС.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ИнтеграцияВЕТИСПереопределяемый.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	ИнтеграцияИС.ОчиститьДополнительныеСвойстваДляПроведения(ЭтотОбъект.ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ВыполнятьПроверкиРеквизитовВетИС = Истина;
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ТекущееСостояние = РегистрыСведений.СтатусыДокументовВЕТИС.ТекущееСостояние(Ссылка);
		КонечныеСтатусы = Документы.ПроизводственнаяОперацияВЕТИС.КонечныеСтатусы(Ложь);
		Если КонечныеСтатусы.Найти(ТекущееСостояние.Статус) <> Неопределено Тогда
			ВыполнятьПроверкиРеквизитовВетИС = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ВыполнятьПроверкиРеквизитовВетИС Тогда
		
		ПроверитьЗаполнениеТабличнойЧастиТовары(Отказ);
		
		ПроверитьСоответствиеПродукцииСырья(Отказ);
		
		ПроверитьЗаполнениеТабличнойЧастиТехнологическийПроцесс(Отказ);
		
		Если Товары.Итог("КоличествоВЕТИС") = 0
			И Сырье.Итог("КоличествоВЕТИС") = 0
			И Не ЗавершениеПроизводственнойТранзакции Тогда
			
			ТекстСообщения = НСтр("ru = 'Количество продукции и сырья нулевое, нет данных для передачи.';
									|en = 'Количество продукции и сырья нулевое, нет данных для передачи.'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,,,
				Отказ);
			
		КонецЕсли;
		
	Иначе
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ИдентификаторПартии");
		МассивНепроверяемыхРеквизитов.Добавить("Сырье.КоличествоВЕТИС");
		
	КонецЕсли;
	
	ИнтеграцияВЕТИС.ПроверитьЗаполнениеКоличества(ЭтотОбъект, Отказ, МассивНепроверяемыхРеквизитов);
	ИнтеграцияВЕТИС.ПроверитьЗаполнениеКоличества(ЭтотОбъект, Отказ, МассивНепроверяемыхРеквизитов, "Сырье");
	
	ИнтеграцияВЕТИСПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Идентификатор) Тогда
		Идентификатор = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияВЕТИС.ЗаписатьСоответствиеНоменклатуры(ЭтотОбъект);
	ИнтеграцияВЕТИС.ЗаписатьСоответствиеНоменклатуры(ЭтотОбъект,"Сырье");
	
	ИнтеграцияВЕТИС.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияВЕТИС.ЗаписатьСтатусДокументаВЕТИСПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование = Неопределено;
	Идентификатор     = "";
	
	Если Товары.Количество() > 0 Тогда
		Товары.ЗагрузитьКолонку(Новый Массив(Товары.Количество()), "ЗаписьСкладскогоЖурнала");
		Товары.ЗагрузитьКолонку(Новый Массив(Товары.Количество()), "ВетеринарноСопроводительныйДокумент");
	КонецЕсли;
	
	Если Сырье.Количество() > 0 Тогда
		Сырье.ЗагрузитьКолонку(Новый Массив(Сырье.Количество()), "ЗаписьСкладскогоЖурнала");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьЗаполнениеТабличнойЧастиТовары(Отказ)
	
	ЗаполнениеДокументовВЕТИС.ПроверитьЗаполнениеДатыПроизводстваСрокаГодности(ЭтотОбъект, "Товары", Отказ);
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеТабличнойЧастиТехнологическийПроцесс(Отказ)
	
	ШаблонСообщения = НСтр("ru = 'Дата окончания операции не должна быть меньше даты начала (строка %1, список ""Технологический процесс"")';
							|en = 'Дата окончания операции не должна быть меньше даты начала (строка %1, список ""Технологический процесс"")'");
	
	Для каждого Строка Из ТехнологическийПроцесс Цикл
		Если ЗначениеЗаполнено(Строка.ДатаОперацииНачалоПериода)
			И ЗначениеЗаполнено(Строка.ДатаОперацииКонецПериода)
			И Строка.ДатаОперацииНачалоПериода > Строка.ДатаОперацииКонецПериода Тогда
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ТехнологическийПроцесс", Строка.НомерСтроки, "ДатаОперацииКонецПериода");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(ШаблонСообщения, Строка.НомерСтроки),
				ЭтотОбъект, 
				Поле,,
				Отказ);
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьСоответствиеПродукцииСырья(Отказ)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Т.Продукция КАК Продукция,
	|	Т.Сырье КАК Сырье
	|ПОМЕСТИТЬ ВТТаблицаСоответствия
	|ИЗ
	|	&ТаблицаСоответствия КАК Т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Т.НомерСтроки КАК НомерСтроки,
	|	Т.Продукция КАК Продукция
	|ПОМЕСТИТЬ ВТТовары
	|ИЗ
	|	&Товары КАК Т
	|ГДЕ
	|	НЕ Т.Продукция = ЗНАЧЕНИЕ(Справочник.ПродукцияВЕТИС.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПродукцияВЕТИС.ТипПродукции КАК ТипПродукции
	|ПОМЕСТИТЬ ВТСырье
	|ИЗ
	|	Справочник.ПродукцияВЕТИС КАК ПродукцияВЕТИС
	|ГДЕ
	|	ПродукцияВЕТИС.Ссылка В(&Сырье)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТТовары.НомерСтроки КАК НомерСтроки,
	|	ПродукцияВЕТИС.ТипПродукции.Представление КАК ТипПродукцииПредставление,
	|	ВТСырье.ТипПродукции.Представление КАК ТипСырьяПредставление
	|ИЗ
	|	ВТТовары КАК ВТТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСырье КАК ВТСырье
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПродукцияВЕТИС КАК ПродукцияВЕТИС
	|		ПО ВТТовары.Продукция = ПродукцияВЕТИС.Ссылка
	|ГДЕ
	|	НЕ (ПродукцияВЕТИС.ТипПродукции, ВТСырье.ТипПродукции) В
	|				(ВЫБРАТЬ
	|					ВТТаблицаСоответствия.Продукция КАК Продукция,
	|					ВТТаблицаСоответствия.Сырье КАК Сырье
	|				ИЗ
	|					ВТТаблицаСоответствия КАК ВТТаблицаСоответствия)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Товары", Товары);
	Запрос.УстановитьПараметр("Сырье" , Сырье.ВыгрузитьКолонку("Продукция"));
	Запрос.УстановитьПараметр("ТаблицаСоответствия", ТаблицаСоответствияПродукцииСырья());
	
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		ШаблонСообщения = НСтр("ru = 'Продукция с типом ""%1"" не может производиться из сырья с типом ""%2"" (Строка %3)';
								|en = 'Продукция с типом ""%1"" не может производиться из сырья с типом ""%2"" (Строка %3)'");
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", Выборка.НомерСтроки, "Продукция");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(ШаблонСообщения, Выборка.ТипПродукцииПредставление, Выборка.ТипСырьяПредставление, Выборка.НомерСтроки),
				ЭтотОбъект,
				Поле,,
				Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ТаблицаСоответствияПродукцииСырья()
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Продукция", Новый ОписаниеТипов("СправочникСсылка.ПродукцияВЕТИС"));
	Результат.Колонки.Добавить("Сырье", Новый ОписаниеТипов("СправочникСсылка.ПродукцияВЕТИС"));
	
	Менеджер = Справочники.ПродукцияВЕТИС;
	
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.МясоИМясопродукты,        Менеджер.МясоИМясопродукты);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.МясоИМясопродукты,        Менеджер.ЖивыеЖивотные);
	
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.КормаИКормовыеДобавки,    Менеджер.МясоИМясопродукты);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.КормаИКормовыеДобавки,    Менеджер.КормаИКормовыеДобавки);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.КормаИКормовыеДобавки,    Менеджер.ЖивыеЖивотные);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.КормаИКормовыеДобавки,    Менеджер.НепищевыеПродуктыИДругое);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.КормаИКормовыеДобавки,    Менеджер.РыбаИМорепродукты);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.КормаИКормовыеДобавки,    Менеджер.ПродукцияНеТребующаяРазрешения);
	
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.ЖивыеЖивотные,            Менеджер.ЖивыеЖивотные);
	
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.ЛекарственныеСредства,    Менеджер.КормаИКормовыеДобавки);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.ЛекарственныеСредства,    Менеджер.ЖивыеЖивотные);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.ЛекарственныеСредства,    Менеджер.ЛекарственныеСредства);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.ЛекарственныеСредства,    Менеджер.НепищевыеПродуктыИДругое);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.ЛекарственныеСредства,    Менеджер.ПродукцияНеТребующаяРазрешения);
	
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.ПищевыеПродукты,          Менеджер.МясоИМясопродукты);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.ПищевыеПродукты,          Менеджер.ПищевыеПродукты);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.ПищевыеПродукты,          Менеджер.НепищевыеПродуктыИДругое);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.ПищевыеПродукты,          Менеджер.РыбаИМорепродукты);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.ПищевыеПродукты,          Менеджер.ПродукцияНеТребующаяРазрешения);
	
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.НепищевыеПродуктыИДругое, Менеджер.МясоИМясопродукты);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.НепищевыеПродуктыИДругое, Менеджер.КормаИКормовыеДобавки);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.НепищевыеПродуктыИДругое, Менеджер.ЖивыеЖивотные);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.НепищевыеПродуктыИДругое, Менеджер.ЛекарственныеСредства);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.НепищевыеПродуктыИДругое, Менеджер.ПищевыеПродукты);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.НепищевыеПродуктыИДругое, Менеджер.НепищевыеПродуктыИДругое);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.НепищевыеПродуктыИДругое, Менеджер.РыбаИМорепродукты);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.НепищевыеПродуктыИДругое, Менеджер.ПродукцияНеТребующаяРазрешения);
	
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.РыбаИМорепродукты,        Менеджер.ЖивыеЖивотные);
	НоваяСтрокаПродукцияСырье(Результат, Менеджер.РыбаИМорепродукты,        Менеджер.РыбаИМорепродукты);
	
	Возврат Результат;
	
КонецФункции

Процедура НоваяСтрокаПродукцияСырье(Таблица, Продукция, Сырье)
	
	НоваяСтрока = Таблица.Добавить();
	
	НоваяСтрока.Продукция = Продукция;
	НоваяСтрока.Сырье     = Сырье;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
