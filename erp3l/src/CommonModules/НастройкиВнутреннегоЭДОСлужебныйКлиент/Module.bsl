
#Область СлужебныеПроцедурыИФункции

Процедура ОткрытьФормуФормированияУведомленияОбИспользованииПЭП(Организация, СписокПользователей,
	ВладелецФормы = Неопределено) Экспорт
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Организация", Организация);
	ПараметрыОткрытияФормы.Вставить("СписокПользователей", СписокПользователей);
	
	ОткрытьФорму("Обработка.НастройкиВнутреннегоЭДО.Форма.ФормированиеУведомленияОбИспользованииПЭП",
		ПараметрыОткрытияФормы, ВладелецФормы, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ОткрытьФормуФормированияПоложенияОбИспользованииПЭП(Организация, ВладелецФормы = Неопределено) Экспорт

	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Организация", Организация);
	
	ОткрытьФорму("Обработка.НастройкиВнутреннегоЭДО.Форма.ФормированиеПоложенияОбИспользованииПЭП",
		ПараметрыОткрытияФормы, ВладелецФормы, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ОткрытьНастройкиПечатныхФорм(ПараметрыОткрытия, Оповещение) Экспорт

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПечатныеФормы", ПараметрыОткрытия.ПечатныеФормы);
	ПараметрыФормы.Вставить("ПечатнаяФормаПоУмолчанию", ПараметрыОткрытия.ПечатнаяФормаПоУмолчанию);
	ПараметрыФормы.Вставить("ВидЭлектроннойПодписи", ПараметрыОткрытия.ВидЭлектроннойПодписи);
	ПараметрыФормы.Вставить("Организация", ПараметрыОткрытия.Организация);
	ПараметрыФормы.Вставить("РасширенныйРежим", ПараметрыОткрытия.РасширенныйРежим);
	ОткрытьФорму("РегистрСведений.НастройкиВнутреннегоЭДО.Форма.ПечатныеФормы", ПараметрыФормы, , , , , Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

Функция НовыеПараметрыОткрытияНастройкиПечатныхФорм() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Организация");
	Параметры.Вставить("ВидЭлектроннойПодписи");
	Параметры.Вставить("ПечатныеФормы");
	Параметры.Вставить("ПечатнаяФормаПоУмолчанию");
	Параметры.Вставить("РасширенныйРежим");
	
	Возврат Параметры;
	
КонецФункции

Процедура ОповеститьОбИсправленииОшибкиНеустановленнойПоУмолчаниюПечатнойФормы(Организация, ИдентификаторОбъектаУчета) Экспорт
	
	ВидОшибки = ВидОшибкиНеУстановленаПечатнаяФормаПоУмолчаниюВнутреннийЭДО();
	Отбор = Новый Соответствие;
	Отбор.Вставить("ВидОшибки", ВидОшибки);
	Отбор.Вставить("ДополнительныеДанные.Организация", Организация);
	Отбор.Вставить("ДополнительныеДанные.ИдентификаторОбъектаУчета", ИдентификаторОбъектаУчета);
	ОбработкаНеисправностейБЭДКлиент.ОповеститьОбИсправленииОшибок(Отбор);
	
КонецПроцедуры

#Область ОбработкаНеисправностей

// Возвращает вид ошибки, описывающий ситуацию, когда для внутреннего электронного документооборота не 
// установлена печатная форма по умолчанию.
// 
// Возвращаемое значение:
// 	См. ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки
Функция ВидОшибкиНеУстановленаПечатнаяФормаПоУмолчаниюВнутреннийЭДО()
	
	ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки();
	ВидОшибки.Идентификатор = "ВидОшибкиНеУстановленаПечатнаяФормаПоУмолчаниюВнутреннийЭДО";
	ВидОшибки.ЗаголовокПроблемы = НСтр("ru = 'Не удалось сформировать электронный документ';
										|en = 'Cannot generate an electronic document'");
	ВидОшибки.ОписаниеПроблемы = НСтр("ru = 'Не установлена печатная форма по умолчанию';
										|en = 'Default print form is not set'");
	ВидОшибки.ОписаниеРешения = НСтр("ru = '<a href = ""Выберите"">Выберите</a> печатную форму, которую следует использовать по умолчанию';
									|en = '<a href = ""Выберите"">Select</a>a default print form'");
	ВидОшибки.ОбработчикиНажатия.Вставить("Выберите", "НастройкиВнутреннегоЭДОКлиент.ОткрытьОшибкиНастроекВнутреннегоЭДО");
	
	Возврат ВидОшибки;
	
КонецФункции

#КонецОбласти

#КонецОбласти