
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьСтраницыСессийОбмена();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавлениеРеквизитов(Сообщение, ДобавляемыеРеквизиты)
	
	Если Не ЗначениеЗаполнено(Сообщение) Тогда
		Возврат;
	КонецЕсли;
	
	Идентификатор = СтрЗаменить(Сообщение.УникальныйИдентификатор(), "-", "");
	
	Реквизит = Новый РеквизитФормы("Сообщение" + Идентификатор, Новый ОписаниеТипов("СправочникСсылка.ЕГАИСПрисоединенныеФайлы"), "", НСтр("ru = 'Сообщение';
																																			|en = 'Сообщение'"));
	ДобавляемыеРеквизиты.Добавить(Реквизит);
	
	Реквизит = Новый РеквизитФормы("ДатаСоздания" + Идентификатор, Новый ОписаниеТипов("Дата"), "", НСтр("ru = 'Дата запроса';
																										|en = 'Дата запроса'"));
	ДобавляемыеРеквизиты.Добавить(Реквизит);
	
	Реквизит = Новый РеквизитФормы("ТекстXML" + Идентификатор, Новый ОписаниеТипов("Строка"), "", НСтр("ru = 'Текст XML';
																										|en = 'Текст XML'"));
	ДобавляемыеРеквизиты.Добавить(Реквизит);
	
КонецПроцедуры

&НаСервере
Функция ДобавитьСтраницу(ИмяСтраницы, Заголовок, Родитель, Идентификатор)
	
	ИмяЭлемента = ИмяСтраницы + Идентификатор;
	Элемент = Элементы.Найти(ИмяЭлемента);
	Если Элемент = Неопределено Тогда
		Элемент = Элементы.Добавить(ИмяЭлемента, Тип("ГруппаФормы"), Родитель);
		Элемент.Вид       = ВидГруппыФормы.Страница;
		Элемент.Заголовок = Заголовок;
	КонецЕсли;
	
	Возврат Элемент;
	
КонецФункции

&НаСервере
Функция ДобавитьПолеТекстовогоДокумента(ИмяРеквизита, Значение, Страница, Идентификатор)
	
	ИмяРеквизита = ИмяРеквизита + Идентификатор;
	ЭтотОбъект[ИмяРеквизита] = Значение;
	
	Элемент = Элементы.Найти(ИмяРеквизита);
	Если Элемент = Неопределено Тогда
		Элемент = Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), Страница);
		Элемент.ПутьКДанным        = ИмяРеквизита;
		Элемент.Вид                = ВидПоляФормы.ПолеТекстовогоДокумента;
		Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	КонецЕсли;
	
	Возврат Элемент;
	
КонецФункции

&НаСервере
Функция ДобавитьПолеВвода(ИмяРеквизита, Заголовок, Значение, Страница, Идентификатор)
	
	ИмяРеквизита = ИмяРеквизита + Идентификатор;
	ЭтотОбъект[ИмяРеквизита] = Значение;
	
	Элемент = Элементы.Найти(ИмяРеквизита);
	Если Элемент = Неопределено Тогда
		Элемент = Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), Страница);
		Элемент.ПутьКДанным        = ИмяРеквизита;
		Элемент.Заголовок          = Заголовок;
		Элемент.Вид                = ВидПоляФормы.ПолеВвода;
		Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
	КонецЕсли;
	
	Возврат Элемент;
	
КонецФункции

&НаСервере
Процедура ДобавлениеЭлементов(СтрокаТЧ, РеквизитыСообщений)
	
	Если Не ЗначениеЗаполнено(СтрокаТЧ.Сообщение) Тогда
		Возврат;
	КонецЕсли;
	
	Идентификатор = СтрЗаменить(СтрокаТЧ.Сообщение.УникальныйИдентификатор(), "-", "");
	
	ИмяЭлемента = "Страница" + Идентификатор;
	Страница = Элементы.Найти(ИмяЭлемента);
	Если Страница = Неопределено Тогда
		Страница = Элементы.Добавить(ИмяЭлемента, Тип("ГруппаФормы"), Элементы.Страницы);
		Страница.Вид = ВидГруппыФормы.Страница;
	КонецЕсли;
	
	Страница.Заголовок = СтрокаТЧ.Заголовок;
	Страница.Подсказка = СтрокаТЧ.Подсказка;
	
	Если СтрокаТЧ.ТипСообщения = Перечисления.ТипыЗапросовИС.Входящий Тогда
		Страница.Картинка = БиблиотекаКартинок.ВходящийЗапросГосИС;
	ИначеЕсли СтрокаТЧ.ТипСообщения = Перечисления.ТипыЗапросовИС.Исходящий Тогда
		Страница.Картинка = БиблиотекаКартинок.ИсходящийЗапросГосИС;
	КонецЕсли;
	
	ИмяЭлемента = "Страницы" + Идентификатор;
	ВложенныеСтраницы = Элементы.Найти(ИмяЭлемента);
	Если ВложенныеСтраницы = Неопределено Тогда
		ВложенныеСтраницы = Элементы.Добавить(ИмяЭлемента, Тип("ГруппаФормы"), Страница);
		ВложенныеСтраницы.Вид = ВидГруппыФормы.Страницы;
		ВложенныеСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСнизу;
	КонецЕсли;

	СтраницаТекстXML  = ДобавитьСтраницу("СтраницаТекстXML",  НСтр("ru = 'Текст XML';
																	|en = 'Текст XML'"),  ВложенныеСтраницы, Идентификатор);
	СтраницаПрочее    = ДобавитьСтраницу("СтраницаПрочее",    НСтр("ru = 'Прочее';
																	|en = 'Прочее'"),     ВложенныеСтраницы, Идентификатор);
	
	Тексты = ТекстыСообщения(СтрокаТЧ.Сообщение);
	
	ДобавитьПолеТекстовогоДокумента("ТекстXML",  Тексты.XML, СтраницаТекстXML, Идентификатор);
	
	РеквизитыСообщения = РеквизитыСообщений.Найти(СтрокаТЧ.Сообщение, "Ссылка");
	
	ДобавитьПолеВвода("Сообщение",    НСтр("ru = 'Сообщение';
											|en = 'Сообщение'"),     РеквизитыСообщения.Ссылка,       СтраницаПрочее, Идентификатор);
	ДобавитьПолеВвода("ДатаСоздания", НСтр("ru = 'Дата создания';
											|en = 'Дата создания'"), РеквизитыСообщения.ДатаСоздания, СтраницаПрочее, Идентификатор);
	
КонецПроцедуры

&НаСервере
Функция АнализСообщенийПередачиДанных(Сообщение, Операция = Неопределено)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЕГАИСПрисоединенныеФайлы.Документ           КАК Документ,
	|	ЕГАИСПрисоединенныеФайлы.Ссылка             КАК Ссылка,
	|	ЕГАИСПрисоединенныеФайлы.ТипСообщения       КАК ТипСообщения,
	|	ЕГАИСПрисоединенныеФайлы.Операция           КАК Операция,
	|	ЕГАИСПрисоединенныеФайлы.СообщениеОснование КАК СообщениеОснование,
	|	ЕГАИСПрисоединенныеФайлы.СтатусОбработки    КАК СтатусОбработки,
	|	ЕГАИСПрисоединенныеФайлы.ДатаСоздания       КАК ДатаСоздания
	|ПОМЕСТИТЬ Сообщения
	|ИЗ
	|	Справочник.ЕГАИСПрисоединенныеФайлы КАК ЕГАИСПрисоединенныеФайлы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЕГАИСПрисоединенныеФайлы КАК ФайлОснование
	|		ПО ФайлОснование.Документ = ЕГАИСПрисоединенныеФайлы.Документ
	|ГДЕ
	|	ФайлОснование.Ссылка = &ФайлОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сообщения.Документ                                          КАК Документ,
	|
	|	Сообщения.Ссылка                                            КАК Запрос,
	|	Сообщения.Операция                                          КАК ЗапросОперация,
	|	Сообщения.ТипСообщения                                      КАК ЗапросТипСообщения,
	|	Сообщения.ДатаСоздания                                      КАК ЗапросДатаСоздания,
	|
	|	ЕСТЬNULL(ОтветНаПередачуДанных.Ссылка, &ПустаяСсылка)            КАК ОтветНаЗапрос,
	|	ЕСТЬNULL(ОтветНаПередачуДанных.Операция, &ПустаяОперация)        КАК ОтветНаЗапросОперация,
	|	ЕСТЬNULL(ОтветНаПередачуДанных.ДатаСоздания, ДатаВремя(1,1,1))   КАК ОтветНаЗапросДатаСоздания,
	|	ЕСТЬNULL(ОтветНаПередачуДанных.ТипСообщения, Неопределено)       КАК ОтветНаЗапросТипСообщения,
	|	ЕСТЬNULL(ОтветНаПередачуДанных.СтатусОбработки, Неопределено)    КАК ОтветНаЗапросСтатусОбработки,
	|
	|	ЕСТЬNULL(КвитанцияПолученЕГАИС.Ссылка, &ПустаяСсылка)            КАК КвитанцияПолученЕГАИС,
	|	ЕСТЬNULL(КвитанцияПолученЕГАИС.Операция, &ПустаяОперация)        КАК КвитанцияПолученЕГАИСОперация,
	|	ЕСТЬNULL(КвитанцияПолученЕГАИС.ДатаСоздания, ДатаВремя(1,1,1))   КАК КвитанцияПолученЕГАИСДатаСоздания,
	|	ЕСТЬNULL(КвитанцияПолученЕГАИС.ТипСообщения, Неопределено)       КАК КвитанцияПолученЕГАИСТипСообщения,
	|	ЕСТЬNULL(КвитанцияПолученЕГАИС.СтатусОбработки, Неопределено)    КАК КвитанцияПолученЕГАИССостояниеОбработки,
	|
	|	ЕСТЬNULL(КвитанцияПроведенЕГАИС.Ссылка, &ПустаяСсылка)           КАК КвитанцияПроведенЕГАИС,
	|	ЕСТЬNULL(КвитанцияПроведенЕГАИС.Операция, &ПустаяОперация)       КАК КвитанцияПроведенЕГАИСОперация,
	|	ЕСТЬNULL(КвитанцияПроведенЕГАИС.ДатаСоздания, ДатаВремя(1,1,1))  КАК КвитанцияПроведенЕГАИСДатаСоздания,
	|	ЕСТЬNULL(КвитанцияПроведенЕГАИС.ТипСообщения, Неопределено)      КАК КвитанцияПроведенЕГАИСТипСообщения,
	|	ЕСТЬNULL(КвитанцияПроведенЕГАИС.СтатусОбработки, Неопределено)   КАК КвитанцияПроведенЕГАИССостояниеОбработки
	|ИЗ
	|	Сообщения КАК Сообщения
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Сообщения КАК ОтветНаПередачуДанных
	|		ПО Сообщения.Ссылка = ОтветНаПередачуДанных.СообщениеОснование
	|		И (Сообщения.Операция = ОтветНаПередачуДанных.Операция)
	|		И (ОтветНаПередачуДанных.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Входящий))
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Сообщения КАК КвитанцияПолученЕГАИС
	|		ПО Сообщения.Ссылка = КвитанцияПолученЕГАИС.СообщениеОснование
	|		И (КвитанцияПолученЕГАИС.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Входящий))
	|		И (КвитанцияПолученЕГАИС.Операция В(&КвитанцияПолученЕГАИС))
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Сообщения КАК КвитанцияПроведенЕГАИС
	|		ПО Сообщения.Ссылка = КвитанцияПроведенЕГАИС.СообщениеОснование
	|		И (КвитанцияПроведенЕГАИС.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Входящий))
	|		И (КвитанцияПроведенЕГАИС.Операция В(&КвитанцияПроведенЕГАИС))
	|ГДЕ
	|	Сообщения.СообщениеОснование = &ПустаяСсылка
	|	И ( ЕСТЬNULL(Сообщения.Ссылка, &ПустаяСсылка)               = &ФайлОснование
	|	ИЛИ ЕСТЬNULL(ОтветНаПередачуДанных.Ссылка,   &ПустаяСсылка) = &ФайлОснование
	|	ИЛИ ЕСТЬNULL(КвитанцияПолученЕГАИС.Ссылка,   &ПустаяСсылка) = &ФайлОснование
	|	ИЛИ ЕСТЬNULL(КвитанцияПроведенЕГАИС.Ссылка,  &ПустаяСсылка) = &ФайлОснование)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	*
	|ИЗ
	|	Сообщения
	|");
	
	Запрос.УстановитьПараметр("КвитанцияПроведенЕГАИС", Перечисления.ВидыДокументовЕГАИС.КвитанцияПроведенЕГАИС);
	Запрос.УстановитьПараметр("КвитанцияПолученЕГАИС",  Перечисления.ВидыДокументовЕГАИС.КвитанцияПолученЕГАИС);
	
	Запрос.УстановитьПараметр("ФайлОснование",  Сообщение);
	Запрос.УстановитьПараметр("ПустаяОперация", Перечисления.ВидыДокументовЕГАИС.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяСсылка",   Справочники.ЕГАИСПрисоединенныеФайлы.ПустаяСсылка());
	
	Результат = Запрос.ВыполнитьПакет();
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ПоследовательностьСообщений", ПоследовательностьСообщенийПередачиДанных(Результат[1].Выгрузить()));
	ВозвращаемоеЗначение.Вставить("РеквизитыСообщений",          Результат[2].Выгрузить());
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

&НаСервере
Функция ПоследовательностьСообщенийПередачиДанных(Данные)
	
	Колонки = Новый Массив;
	
	Колонка = Новый Структура;
	Колонка.Вставить("Приоритет",    1);
	Колонка.Вставить("Имя",          "Запрос");
	Колонки.Добавить(Колонка);
	
	Колонка = Новый Структура;
	Колонка.Вставить("Приоритет",    2);
	Колонка.Вставить("Имя",          "ОтветНаЗапрос");
	Колонки.Добавить(Колонка);
	
	Колонка = Новый Структура;
	Колонка.Вставить("Приоритет",    3);
	Колонка.Вставить("Имя",          "КвитанцияПолученЕГАИС");
	Колонки.Добавить(Колонка);
	
	Колонка = Новый Структура;
	Колонка.Вставить("Приоритет",    4);
	Колонка.Вставить("Имя",          "КвитанцияПроведенЕГАИС");
	Колонки.Добавить(Колонка);
	
	ПоследовательностьСообщений = Новый ТаблицаЗначений;
	ПоследовательностьСообщений.Колонки.Добавить("Сообщение");
	ПоследовательностьСообщений.Колонки.Добавить("ДатаСоздания");
	ПоследовательностьСообщений.Колонки.Добавить("Приоритет");
	ПоследовательностьСообщений.Колонки.Добавить("Заголовок");
	ПоследовательностьСообщений.Колонки.Добавить("Подсказка");
	ПоследовательностьСообщений.Колонки.Добавить("ТипСообщения");
	
	ОперацииПередачиДанных = Новый Массив;
	Для Каждого КлючИЗначение Из ИнтеграцияЕГАИС.КатегорииОпераций().ПередачаДанных Цикл
		ОперацииПередачиДанных.Добавить(КлючИЗначение.Ключ);
	КонецЦикла;
	
	Для Каждого СтрокаТЧ Из Данные Цикл
		Для Каждого Колонка Из Колонки Цикл
			Если ПоследовательностьСообщений.Найти(СтрокаТЧ[Колонка.Имя]) = Неопределено Тогда
				
				Если Не ЗначениеЗаполнено(СтрокаТЧ[Колонка.Имя]) Тогда
					Продолжить;
				КонецЕсли;
				
				Операция = СтрокаТЧ[Колонка.Имя + "Операция"];
				
				НоваяСтрока = ПоследовательностьСообщений.Добавить();
				НоваяСтрока.Сообщение    = СтрокаТЧ[Колонка.Имя];
				НоваяСтрока.ДатаСоздания = СтрокаТЧ[Колонка.Имя + "ДатаСоздания"];
				НоваяСтрока.ТипСообщения = СтрокаТЧ[Колонка.Имя + "ТипСообщения"];
				НоваяСтрока.Приоритет    = Колонка.Приоритет;
				
				Если Операция = Перечисления.ВидыДокументовЕГАИС.КвитанцияПроведенЕГАИС Тогда
					НоваяСтрока.Заголовок = НСтр("ru = 'Квитанция ЕГАИС';
												|en = 'Квитанция ЕГАИС'");
					НоваяСтрока.Подсказка = Операция;
				ИначеЕсли Операция = Перечисления.ВидыДокументовЕГАИС.КвитанцияПолученЕГАИС Тогда
					НоваяСтрока.Заголовок = НСтр("ru = 'Квитанция ЕГАИС';
												|en = 'Квитанция ЕГАИС'");
					НоваяСтрока.Подсказка = Операция;
				ИначеЕсли НоваяСтрока.ТипСообщения = Перечисления.ТипыЗапросовИС.Входящий
					И ОперацииПередачиДанных.Найти(Операция) <> Неопределено Тогда
					НоваяСтрока.Заголовок = НСтр("ru = 'Квитанция УТМ';
												|en = 'Квитанция УТМ'");
					НоваяСтрока.Подсказка = Операция;
				ИначеЕсли Операция = Перечисления.ВидыДокументовЕГАИС.УведомлениеОРегистрацииДвиженияАктаПостановкиНаБаланс Тогда
					НоваяСтрока.Заголовок = НСтр("ru = 'Уведомление о регистрации';
												|en = 'Уведомление о регистрации'");
					НоваяСтрока.Подсказка = Операция;
				ИначеЕсли Операция = Перечисления.ВидыДокументовЕГАИС.УведомлениеОРегистрацииДвиженияТТН Тогда
					НоваяСтрока.Заголовок = НСтр("ru = 'Уведомление о регистрации';
												|en = 'Уведомление о регистрации'");
					НоваяСтрока.Подсказка = Операция;
				Иначе
					НоваяСтрока.Заголовок = Операция;
					НоваяСтрока.Подсказка = Операция;
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ПоследовательностьСообщений.Сортировать("ДатаСоздания Возр,Приоритет Возр");
	
	Возврат ПоследовательностьСообщений;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСтраницыСессийОбмена()
	
	Результат = АнализСообщенийПередачиДанных(Объект.Ссылка);

	ДобавляемыеРеквизиты = Новый Массив;
	УдаляемыеРеквизиты = Новый Массив;
	
	РеквизитыФормы = ПолучитьРеквизиты();
	Для Каждого Реквизит Из РеквизитыФормы Цикл
		Если Реквизит.Имя <> "Объект" Тогда
			УдаляемыеРеквизиты.Добавить(Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Если УдаляемыеРеквизиты.Количество() > 0 Тогда
		ИзменитьРеквизиты(, УдаляемыеРеквизиты);
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из Результат.ПоследовательностьСообщений Цикл
		ДобавлениеРеквизитов(СтрокаТЧ.Сообщение, ДобавляемыеРеквизиты);
	КонецЦикла;
	
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	Для Каждого СтрокаТЧ Из Результат.ПоследовательностьСообщений Цикл
		ДобавлениеЭлементов(СтрокаТЧ, Результат.РеквизитыСообщений);
	КонецЦикла;
	
	ИдентификаторПоследнейСтраницы = СтрЗаменить(Результат.ПоследовательностьСообщений[Результат.ПоследовательностьСообщений.Количество() - 1].Сообщение.УникальныйИдентификатор(), "-", "");
	ПоследняяСтраница = Элементы.Найти("Страница" + ИдентификаторПоследнейСтраницы);
	Элементы.Страницы.ТекущаяСтраница = ПоследняяСтраница;
	
КонецПроцедуры

&НаСервере
Функция ТекстыСообщения(Сообщение)
	
	Если Не ЗначениеЗаполнено(Сообщение) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстСообщенияXML = ИнтеграцияИС.ТекстСообщенияXMLИзПротокола(Сообщение);
	
	Попытка
		ФорматированныйТекстСообщенияXML = ИнтеграцияИС.ФорматироватьXMLСПараметрами(ТекстСообщенияXML, ИнтеграцияИС.ПараметрыФорматированияXML(Истина, "  "));
	Исключение
		ФорматированныйТекстСообщенияXML = ТекстСообщенияXML;
	КонецПопытки;
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("XML", ФорматированныйТекстСообщенияXML);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти