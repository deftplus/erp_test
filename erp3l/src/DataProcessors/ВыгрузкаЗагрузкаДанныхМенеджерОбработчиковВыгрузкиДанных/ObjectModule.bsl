#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТекущиеОбработчики;

#КонецОбласти
	
#Область СлужебныйПрограммныйИнтерфейс

Процедура ПередВыгрузкойДанных(Контейнер) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПередВыгрузкойДанных", Истина);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПередВыгрузкойДанных(Контейнер);
	КонецЦикла;
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПередВыгрузкойДанных(Контейнер);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПередВыгрузкойДанных(Контейнер);
	
	ВыгрузкаОбластейДанныхДляТехническойПоддержки.ПередВыгрузкойДанных(Контейнер, ТекущиеОбработчики);

КонецПроцедуры

// Вызывается после выгрузки данных.
//
// Параметры:
//  Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//    контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//    к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//
Процедура ПослеВыгрузкиДанных(Контейнер) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПослеВыгрузкиДанных", Истина);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПослеВыгрузкиДанных(Контейнер);
	КонецЦикла;
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПослеВыгрузкиДанных(Контейнер);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПослеВыгрузкиДанных(Контейнер);
	
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПриДобавленииСлужебныхСобытий
//
Процедура ПередВыгрузкойТипа(Контейнер, Сериализатор, ОбъектМетаданных, Отказ) Экспорт
	
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПередВыгрузкойТипа", Истина);
	ОтборОбработчиков.Вставить("ОбъектМетаданных", ОбъектМетаданных);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПередВыгрузкойТипа(Контейнер, Сериализатор, ОбъектМетаданных, Отказ);
	КонецЦикла;
	
КонецПроцедуры

// Вызывается перед выгрузкой объекта.
// см. "ПриРегистрацииОбработчиковВыгрузкиДанных".
//
Процедура ПередВыгрузкойОбъекта(Контейнер, МенеджерВыгрузкиОбъекта, Сериализатор, Объект, Артефакты, Отказ) Экспорт
	
	Если ТипЗнч(Объект) = Тип("УдалениеОбъекта") Тогда
		Возврат;
	КонецЕсли;
	
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПередВыгрузкойОбъекта", Истина);
	ОтборОбработчиков.Вставить("ОбъектМетаданных", Объект.Метаданные());
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		
		Если ОписаниеОбработчика.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_0() Тогда
			
			ОписаниеОбработчика.Обработчик.ПередВыгрузкойОбъекта(Контейнер, Сериализатор, Объект, Артефакты, Отказ);
			
		Иначе
			
			ОписаниеОбработчика.Обработчик.ПередВыгрузкойОбъекта(Контейнер, МенеджерВыгрузкиОбъекта, Сериализатор, Объект, Артефакты, Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Вызывается перед выгрузкой объекта данных.
// см. "ПриРегистрацииОбработчиковВыгрузкиДанных".
//
Процедура ПослеВыгрузкиОбъекта(Контейнер, МенеджерВыгрузкиОбъекта, Сериализатор, Объект, Артефакты) Экспорт
	
	Если ТипЗнч(Объект) = Тип("УдалениеОбъекта") Тогда
		Возврат;
	КонецЕсли;
	
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПослеВыгрузкиОбъекта", Истина);
	ОтборОбработчиков.Вставить("ОбъектМетаданных", Объект.Метаданные());
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		
		Если ОписаниеОбработчика.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_0() Тогда
			
			ОписаниеОбработчика.Обработчик.ПослеВыгрузкиОбъекта(Контейнер, Сериализатор, Объект, Артефакты);
			
		Иначе
			
			ОписаниеОбработчика.Обработчик.ПослеВыгрузкиОбъекта(Контейнер, МенеджерВыгрузкиОбъекта, Сериализатор, Объект, Артефакты);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Выполняет обработчики после выгрузки определенного типа данных.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	Сериализатор - СериализаторXDTO - сериализатор.
//	ОбъектМетаданных - ОбъектМетаданных - объект метаданных.
//
Процедура ПослеВыгрузкиТипа(Контейнер, Сериализатор, ОбъектМетаданных) Экспорт
	
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПослеВыгрузкиТипа", Истина);
	ОтборОбработчиков.Вставить("ОбъектМетаданных", ОбъектМетаданных);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПослеВыгрузкиТипа(Контейнер, Сериализатор, ОбъектМетаданных);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередВыгрузкойХранилищаНастроек(Контейнер, Сериализатор, ИмяХранилищаНастроек, Знач ХранилищеНастроек, Отказ) Экспорт
	
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПередВыгрузкойХранилищаНастроек", Истина);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПередВыгрузкойХранилищаНастроек(Контейнер, Сериализатор, ИмяХранилищаНастроек, ХранилищеНастроек, Отказ);
	КонецЦикла;
	
КонецПроцедуры

// Вполняется перед выгрузкой настроек.
// 
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - 
//	Сериализатор - СериализаторXDTO - сериализатор.
//	ИмяХранилищаНастроек - Строка -
//	КлючНастроек - Строка - см. синтакс-помощник платформы.
//	КлючОбъекта - Строка - см. синтакс-помощник платформы.
//	Настройки - ХранилищеЗначения - 
//	Пользователь - ПользовательИнформационнойБазы - 
//	Представление - Строка - 
// 	Артефакты - Массив Из ОбъектXDTO - дополнительные данные.
// 	Отказ - Булево - признак отказа от обработки.
//
Процедура ПередВыгрузкойНастроек(Контейнер, Сериализатор, ИмяХранилищаНастроек, КлючНастроек, КлючОбъекта, Настройки, Пользователь, Представление, Артефакты, Отказ) Экспорт
	
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПередВыгрузкойНастроек", Истина);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПередВыгрузкойНастроек(
			Контейнер,
			Сериализатор,
			ИмяХранилищаНастроек,
			КлючНастроек,
			КлючОбъекта,
			Настройки,
			Пользователь,
			Представление,
			Артефакты,
			Отказ);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПослеВыгрузкиНастроек(Контейнер, Сериализатор, ИмяХранилищаНастроек, КлючНастроек, КлючОбъекта, Настройки, Пользователь, Представление) Экспорт
	
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПослеВыгрузкиНастроек", Истина);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПослеВыгрузкиНастроек(
			Контейнер,
			Сериализатор,
			ИмяХранилищаНастроек,
			КлючНастроек,
			КлючОбъекта,
			Настройки,
			Пользователь,
			Представление);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПослеВыгрузкиХранилищаНастроек(Контейнер, Сериализатор, ИмяХранилищаНастроек, Знач ХранилищеНастроек) Экспорт
	
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПослеВыгрузкиХранилищаНастроек", Истина);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПослеВыгрузкиХранилищаНастроек(Контейнер, Сериализатор, ИмяХранилищаНастроек, ХранилищеНастроек);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ТекущиеОбработчики = Новый ТаблицаЗначений();

ТекущиеОбработчики.Колонки.Добавить("ОбъектМетаданных");
ТекущиеОбработчики.Колонки.Добавить("Обработчик");
ТекущиеОбработчики.Колонки.Добавить("Версия", Новый ОписаниеТипов("Строка"));

ТекущиеОбработчики.Колонки.Добавить("ПередВыгрузкойДанных", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПослеВыгрузкиДанных", Новый ОписаниеТипов("Булево"));

ТекущиеОбработчики.Колонки.Добавить("ПередВыгрузкойТипа", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПередВыгрузкойОбъекта", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПослеВыгрузкиОбъекта", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПослеВыгрузкиТипа", Новый ОписаниеТипов("Булево"));

ТекущиеОбработчики.Колонки.Добавить("ПередВыгрузкойХранилищаНастроек", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПередВыгрузкойНастроек", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПослеВыгрузкиНастроек", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПослеВыгрузкиХранилищаНастроек", Новый ОписаниеТипов("Булево"));

// Интегрированные обработчики
ВыгрузкаЗагрузкаНеразделенныхДанных.ПриРегистрацииОбработчиковВыгрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаПредопределенныхДанных.ПриРегистрацииОбработчиковВыгрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаНеразделенныхПредопределенныхДанных.ПриРегистрацииОбработчиковВыгрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаСовместноРазделенныхДанных.ПриРегистрацииОбработчиковВыгрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаИзбранногоРаботыПользователей.ПриРегистрацииОбработчиковВыгрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаДанныхХранилищЗначений.ПриРегистрацииОбработчиковВыгрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаУзловПлановОбменов.ПриРегистрацииОбработчиковВыгрузкиДанных(ТекущиеОбработчики);

// Обработчики событий библиотек
ИнтеграцияПодсистемБТС.ПриРегистрацииОбработчиковВыгрузкиДанных(ТекущиеОбработчики);

// Переопределяемая процедура
ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриРегистрацииОбработчиковВыгрузкиДанных(ТекущиеОбработчики);

// Обеспечение обратной совместимости
Для Каждого Строка Из ТекущиеОбработчики Цикл
	Если ПустаяСтрока(Строка.Версия) Тогда
		Строка.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_0();
	КонецЕсли;
КонецЦикла;

#КонецОбласти

#КонецЕсли

