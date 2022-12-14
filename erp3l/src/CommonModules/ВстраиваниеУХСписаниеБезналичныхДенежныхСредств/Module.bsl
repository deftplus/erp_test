#Область СобытияМодуляФормы

#Область ФормаДокумента

#Область СтандартныеОбработчики

// Нетиповое событие документа. Вызывается перед исполнением основного кода.
Процедура ПриЧтенииСозданииНаСервере(Форма, НастройкиПолей, ЗависимостиПолей) Экспорт
	
	// Создаем необходимые реквизиты
	СоздатьРеквизитыФормыДокумента(Форма);
	
	// 
	СоздатьЭлементыФормыДокумента(Форма, НастройкиПолей, ЗависимостиПолей);
	
	ЗаполнитьПервоначальныеИдентификаторыПозиций(Форма);
	ОбновитьЗаголовокГруппыНомераГТД(Форма);
	ВстраиваниеУХСписаниеБезналичныхДенежныхСредствКлиентСервер.ОбновитьВсеПечатныеРеквизитыВал(Форма);
	
КонецПроцедуры

Процедура ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	
	//
	АналитикиСтатейБюджетовУХ.ЗаполнитьРеквизитыАналитикВсехСтатей(Форма);
	
	//
	ЗаполнитьПервоначальныеИдентификаторыПозиций(Форма);
	
КонецПроцедуры

Процедура ХозяйственнаяОперацияПриИзменении(Форма) Экспорт
	
	ЗаполнитьЭлементСтруктурыЗадолженностиПоУмолчанию(Форма.Объект);
	АналитикиСтатейБюджетовУХ.ЗаполнитьРеквизитыАналитикВсехСтатей(Форма);
	
	УстановитьПараметрыЭлементовСтруктурыЗадолженности(Форма);
	
КонецПроцедуры

Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	ЗаполнитьТипСуммыКредитаДепозита(Объект);
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов) Экспорт
	
	МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.ЗаявкаНаРасходованиеДенежныхСредств");
	
	// используем реквизит ЭлементСтруктурыЗадолженности вместо типового
	МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.ТипСуммыКредитаДепозита");
	Если МассивНепроверяемыхРеквизитов.Найти("РасшифровкаПлатежа") <> Неопределено Тогда	
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.ЭлементСтруктурыЗадолженности");
	КонецЕсли;
	
	
КонецПроцедуры

Процедура РасшифровкаПлатежаДоговорКредитаДепозитаПриИзменении(Форма, ТекущаяСтрока) Экспорт
	Объект = Форма.Объект;
	ЗаполнитьСтрокуРасшифровкиПоДоговору(ТекущаяСтрока.ДоговорКредитаДепозита, Объект.Ссылка, ТекущаяСтрока);
КонецПроцедуры

Процедура РасшифровкаПлатежаДоговорАрендыПриИзменении(Форма, ТекущаяСтрока) Экспорт
	Объект = Форма.Объект;
	ЗаполнитьСтрокуРасшифровкиПоДоговору(ТекущаяСтрока.ДоговорАренды, Объект.Ссылка, ТекущаяСтрока);
КонецПроцедуры

Процедура РасшифровкаПлатежаОбъектРасчетовПриИзменении(Форма, ТекущаяСтрока) Экспорт
	Объект = Форма.Объект;
	Договор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущаяСтрока.ОбъектРасчетов, "Договор");
	ЗаполнитьСтрокуРасшифровкиПоДоговору(Договор, Объект.Ссылка, ТекущаяСтрока);
КонецПроцедуры	

Процедура ПриИзмененииДоговора(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	ЗаполнитьЭлементСтруктурыЗадолженностиПоДоговору(Объект.РасшифровкаПлатежа, Объект.Договор, Объект.Ссылка);	
	АналитикиСтатейБюджетовУХ.ЗаполнитьРеквизитыАналитикВсехСтатей(Форма);
	
КонецПроцедуры


#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьРеквизитыФормыДокумента(Форма)
	
	Если ФормыУХ.ЭлементыФормыУХУжеСозданы(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	//
	Реквизиты = Новый Массив;
	//
	Реквизиты.Добавить(Новый РеквизитФормы("ПервоначальныеИдентификаторыПозиций", Новый ОписаниеТипов("Неопределено")));
	
	// валютный контроль
	Реквизиты.Добавить(Новый РеквизитФормы("РеквизитыПлательщикаВал", Новый ОписаниеТипов("Строка")));
	Реквизиты.Добавить(Новый РеквизитФормы("РеквизитыПолучателяВал", Новый ОписаниеТипов("Строка")));
	Реквизиты.Добавить(Новый РеквизитФормы("РеквизитыБанкаПлательщикаВал", Новый ОписаниеТипов("Строка")));
	Реквизиты.Добавить(Новый РеквизитФормы("РеквизитыБанкаПолучателяВал", Новый ОписаниеТипов("Строка")));
	Реквизиты.Добавить(Новый РеквизитФормы("РеквизитыБанкаПосредникаВал", Новый ОписаниеТипов("Строка")));
	
	Форма.ИзменитьРеквизиты(Реквизиты);
	
КонецПроцедуры

Функция ПолучитьПараметрыЭлементовПоУмолчанию()
	
	//
	ПараметрыПоляВвода = Новый Структура;
	
	//
	ПараметрыПоляВвода28 = Новый Структура;
	ПараметрыПоляВвода28.Вставить("ПоложениеЗаголовка", 	ПоложениеЗаголовкаЭлементаФормы.Лево);
	ПараметрыПоляВвода28.Вставить("АвтоМаксимальнаяШирина",	Ложь);
	ПараметрыПоляВвода28.Вставить("МаксимальнаяШирина",		28);
	
	//
	ПараметрыПоляФлажка = Новый Структура;
	ПараметрыПоляФлажка.Вставить("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Право);
	
	// Вертикальная группа
	ПараметрыВертикаль = Новый Структура;
	ПараметрыВертикаль.Вставить("ОтображатьЗаголовок",	Ложь);
	ПараметрыВертикаль.Вставить("Группировка",			ГруппировкаПодчиненныхЭлементовФормы.Вертикальная);
	ПараметрыВертикаль.Вставить("Объединенная",			Истина);
	ПараметрыВертикаль.Вставить("Отображение",			ОтображениеОбычнойГруппы.Нет);
	
	// Параметры элементов, которые можно использовать в формах
	ПараметрыЭлементов = Новый Структура;
	ПараметрыЭлементов.Вставить("ПолеФлажка",	ПараметрыПоляФлажка);
	ПараметрыЭлементов.Вставить("ПолеВвода",	ПараметрыПоляВвода);
	ПараметрыЭлементов.Вставить("ПолеВвода28",	ПараметрыПоляВвода28);
	ПараметрыЭлементов.Вставить("ГруппаВ",		ПараметрыВертикаль);
	
	Возврат ПараметрыЭлементов;
	
КонецФункции

Процедура СоздатьЭлементыФормыДокумента(Форма, Настройки, ЗависимостиПолей) 
	
	Если ФормыУХ.ЭлементыФормыУХУжеСозданы(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	//
	ФормыУХ.ЭлементыФормыУХДобавлены(Форма);
	
	//
	ПараметрыЭлементов = ПолучитьПараметрыЭлементовПоУмолчанию();
	
	СоздатьЭлементыАналитикиСтатей(Форма, Настройки, ПараметрыЭлементов);
	
	// Реквизиты шапки: ЦФО, Проект, ДокументПланирования.
	
	// ЦФО
	ФормыУХ.СоздатьПолеФормы(
		Элементы, 
		"ЦФО",
		НСтр("ru = 'ЦФО'"), 
		"Объект.ЦФО",
		ВидПоляФормы.ПолеВвода,
		Элементы.ГруппаДополнительныеРеквизитыШапки, 
		, 
		ПараметрыЭлементов.ПолеВвода);	
		
	// Проект
	ФормыУХ.СоздатьПолеФормы(
		Элементы, 
		"Проект",
		НСтр("ru = 'Проект'"), 
		"Объект.Проект",
		ВидПоляФормы.ПолеВвода,
		Элементы.ГруппаДополнительныеРеквизитыШапки, 
		, 
		ПараметрыЭлементов.ПолеВвода);	
		
	// ДокументПланирования
	События = Новый Структура("ПриИзменении, ОбработкаВыбора",
								"Подключаемый_ПриИзмененииДокПланирования", 
								"Подключаемый_ОбработкаВыбораДокументПланирования");
	ФормыУХ.СоздатьПолеФормы(
		Элементы, 
		"ДокументПланирования",
		НСтр("ru = 'Документ планирования'"), 
		"Объект.ДокументПланирования",
		ВидПоляФормы.ПолеВвода,
		Элементы.ГруппаДополнительныеРеквизитыШапки, 
		, 
		ПараметрыЭлементов.ПолеВвода,
		События);	
		
	ФормыУХ.СоздатьПолеФормы(
		Элементы, 
		"БанковскийСчетСписанияКомиссииУХ",
		НСтр("ru = 'Счет списания комиссии'"), 
		"Объект.БанковскийСчетСписанияКомиссии",
		ВидПоляФормы.ПолеВвода,
		Элементы.ГруппаВалютныйПлатеж, 
		Элементы.КодыИнструкцийБанку, 
		ПараметрыЭлементов.ПолеВвода28);	
		
	Элементы.ТипКомиссииЗаПеревод.УстановитьДействие("ПриИзменении", "Подключаемый_ТипКомиссииЗаПереводПриИзменении");	
		
	#Область РеквизитыРасшифровки

	Куда1 = Элементы.РасшифровкаБезРазбиенияПодразделение;
	Куда  = Элементы.РасшифровкаПлатежаПодразделение;

	// ЦФО 
	События = Новый Структура("ПриИзменении", "Подключаемый_ПриИзмененииЦФО");
	ФормыУХ.СоздатьПолеФормы(Элементы, "РасшифровкаБезРазбиенияЦФО",, "Элементы.РасшифровкаПлатежа.ТекущиеДанные.ЦФО",,		
			Куда1.Родитель, Куда1, ПараметрыЭлементов.ПолеВвода, События);
	ФормыУХ.СоздатьПолеФормы(Элементы, "РасшифровкаПлатежаЦФО",, "Объект.РасшифровкаПлатежа.ЦФО",,		
			Куда.Родитель, Куда, ПараметрыЭлементов.ПолеВвода28, События);
			
	// Проект
	События = Новый Структура("ПриИзменении", "Подключаемый_ПриИзмененииПроекта");
	ФормыУХ.СоздатьПолеФормы(Элементы, "РасшифровкаБезРазбиенияПроект",, "Элементы.РасшифровкаПлатежа.ТекущиеДанные.Проект",,	
			Куда1.Родитель, Куда1, ПараметрыЭлементов.ПолеВвода, События);
	ФормыУХ.СоздатьПолеФормы(Элементы, "РасшифровкаПлатежаПроект",, "Объект.РасшифровкаПлатежа.Проект",,	
			Куда.Родитель, Куда, ПараметрыЭлементов.ПолеВвода28, События);
			
	//ДокументПланирования
	События = Новый Структура("ПриИзменении, ОбработкаВыбора",
								"Подключаемый_ПриИзмененииДокПланирования", 
								"Подключаемый_ОбработкаВыбораДокументПланирования");
	Куда1 = Элементы.РасшифровкаБезРазбиенияЗаявкаНаРасходованиеДенежныхСредств;
	Куда  = Элементы.РасшифровкаПлатежаЗаявкаНаРасходованиеДенежныхСредств;
	ФормыУХ.СоздатьПолеФормы(Элементы, "РасшифровкаБезРазбиенияДокументПланирования",, "Элементы.РасшифровкаПлатежа.ТекущиеДанные.ДокументПланирования",,	
			Куда1.Родитель, Куда1, ПараметрыЭлементов.ПолеВвода, События);
	ФормыУХ.СоздатьПолеФормы(Элементы, "РасшифровкаПлатежаДокументПланирования",, "Объект.РасшифровкаПлатежа.ДокументПланирования",,
			Куда.Родитель, Куда, ПараметрыЭлементов.ПолеВвода28, События);
			
	// Элемент структуры задолженности
	Элемент = ФормыУХ.СоздатьПолеФормы(Элементы, "РасшифровкаПлатежаЭлементСтруктурыЗадолженности",, 
		"Объект.РасшифровкаПлатежа.ЭлементСтруктурыЗадолженности",, Элементы.РасшифровкаПлатежа, 
		Элементы.РасшифровкаПлатежаТипСуммыКредитаДепозита,,
		Новый Структура("ПриИзменении", "Подключаемый_РасшифровкаПлатежаЭлементСтруктурыЗадолженностиПриИзменении"));
	
	Элемент = ФормыУХ.СоздатьПолеФормы(Элементы, "РасшифровкаБезРазбиенияЭлементСтруктурыЗадолженности",, 
		"Объект.РасшифровкаПлатежа.ЭлементСтруктурыЗадолженности",, Элементы.РасшифровкаБезРазбиения, 
		Элементы.РасшифровкаБезРазбиенияТипСуммыКредитаДепозита, ПараметрыЭлементов.ПолеВвода,
		Новый Структура("ПриИзменении", "Подключаемый_РасшифровкаПлатежаЭлементСтруктурыЗадолженностиПриИзменении"));
		
	УстановитьПараметрыЭлементовСтруктурыЗадолженности(Форма); 		
			
	#КонецОбласти 	

	#Область КнопкиЗаполнения
	
	//
	Группа = ФормыУХ.СоздатьГруппуФормы(Элементы, "ДокументыПланирования", НСтр("ru = 'Документы планирования'"), ВидГруппыФормы.ГруппаКнопок, Элементы.РасшифровкаПлатежаКоманднаяПанель);
	
	ИмяКоманды = "ПодборЗаявок";
	ФормыУХ.СоздатьКоманду(Форма, ИмяКоманды, НСтр("ru = 'Подбор заявок'"), "Подключаемый_ПодборЗаявок", БиблиотекаКартинок.СоздатьЭлементСписка);
	ФормыУХ.СоздатьКнопкуФормы(Элементы, "РасшифровкаПлатежаПодборЗаявок", , ИмяКоманды, ВидКнопкиФормы.КнопкаКоманднойПанели, Группа);
	
	//
	Элементы.РасшифровкаПлатежа.УстановитьДействие("ОбработкаВыбора", "Подключаемый_РасшифровкаПлатежаОбработкаВыбора");
		
	#КонецОбласти
	
	#Область ВалютныйКонтроль
	ФормыУХ.СоздатьПолеФормы(
		Элементы, 
		"ВидСообщенияISO20022",
		НСтр("ru = 'Вид сообщения ISO20022'"), 
		"Объект.ВидСообщенияISO20022",
		ВидПоляФормы.ПолеВвода,
		Элементы.СтраницаВалютныйКонтроль, 
		, 
		ПараметрыЭлементов.ПолеВвода28);
		
	ФормыУХ.СоздатьПолеФормы(
		Элементы, 
		"СуммаОбязательнойПродажи",
		НСтр("ru = 'Сумма обязательной продажи'"), 
		"Объект.СуммаОбязательнойПродажи",
		ВидПоляФормы.ПолеВвода,
		Элементы.СтраницаВалютныйКонтроль, 
		, 
		ПараметрыЭлементов.ПолеВвода28);
		
	ФормыУХ.СоздатьПолеФормы(
		Элементы, 
		"ОжидаемыйСрок",
		НСтр("ru = 'Ожидаемый срок'"), 
		"Объект.ОжидаемыйСрок",
		ВидПоляФормы.ПолеВвода,
		Элементы.СтраницаВалютныйКонтроль, 
		, 
		ПараметрыЭлементов.ПолеВвода28);
		
	// номера таможенных деклараций
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Поведение", ПоведениеОбычнойГруппы.Свертываемая);
	СтруктураПараметров.Вставить("ОтображениеУправления", ОтображениеУправленияОбычнойГруппы.Картинка);
	
	ГруппаНомера = ФормыУХ.СоздатьГруппуФормы(Элементы, 
		"ГруппаНомераГТД", 
		НСтр("ru = 'Номера таможенных делараций'"), 
		ВидГруппыФормы.ОбычнаяГруппа, 
		Элементы.СтраницаВалютныйКонтроль,,СтруктураПараметров);
		
	ГруппаНомера.Скрыть(); // свернута по умолчанию	
		
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Нет);
	События = Новый Структура;
	События.Вставить("ПриИзменении", "Подключаемый_НомераГТДПриИзменении"); 
	ТаблицаНомера = ФормыУХ.СоздатьТаблицуФормы(Элементы, 
		"НомераГТД", 
		Нстр("ru = 'Номера ГТД'"), 
		"Объект.НомераГТД", 
		ГруппаНомера,, 
		СтруктураПараметров, 
		События);	
		
	ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"НомераГТДНомерСтроки",
		НСтр("ru = 'N'"),
		"Объект.НомераГТД.НомерСтроки",
		,
		ТаблицаНомера);
		
	ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"НомераГТДНомерГТД",
		НСтр("ru = 'Номер ТД'"),
		"Объект.НомераГТД.НомерГТД",
		,
		ТаблицаНомера);	
		
	// Печатные реквизиты
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Поведение", ПоведениеОбычнойГруппы.Свертываемая);
	СтруктураПараметров.Вставить("ОтображениеУправления", ОтображениеУправленияОбычнойГруппы.Картинка);
	
	ГруппаПечРеквизиты = ФормыУХ.СоздатьГруппуФормы(Элементы, 
		"ГруппаПечатныеРеквизиты", 
		НСтр("ru = 'Печатные реквизиты'"), 
		ВидГруппыФормы.ОбычнаяГруппа, 
		Элементы.СтраницаВалютныйКонтроль,,СтруктураПараметров);
		
	ГруппаПечРеквизиты.Скрыть(); // свернута по умолчанию
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Гиперссылка", Истина);
	События = Новый Структура("Нажатие", "Подключаемый_РеквизитыПлательщикаВалНажатие");
	ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"РеквизитыПлательщикаВал",
		НСтр("ru = 'Плательщика'"),
		"РеквизитыПлательщикаВал",
		ВидПоляФормы.ПолеНадписи,
		ГруппаПечРеквизиты,,
		СтруктураПараметров,
		События);
		
	События = Новый Структура("Нажатие", "Подключаемый_РеквизитыПолучателяВалНажатие");
	ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"РеквизитыПолучателяВал",
		НСтр("ru = 'Получателя'"),
		"РеквизитыПолучателяВал",
		ВидПоляФормы.ПолеНадписи,
		ГруппаПечРеквизиты,,
		СтруктураПараметров,
		События);
		
	События = Новый Структура("Нажатие", "Подключаемый_РеквизитыБанкаПлательщикаВалНажатие");
	ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"РеквизитыБанкаПлательщикаВал",
		НСтр("ru = 'Банка плательщика'"),
		"РеквизитыБанкаПлательщикаВал",
		ВидПоляФормы.ПолеНадписи,
		ГруппаПечРеквизиты,,
		СтруктураПараметров,
		События);
		
	События = Новый Структура("Нажатие", "Подключаемый_РеквизитыБанкаПолучателяВалНажатие");
	ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"РеквизитыБанкаПолучателяВал",
		НСтр("ru = 'Банка получателя'"),
		"РеквизитыБанкаПолучателяВал",
		ВидПоляФормы.ПолеНадписи,
		ГруппаПечРеквизиты,,
		СтруктураПараметров,
		События);
		
	События = Новый Структура("Нажатие", "Подключаемый_РеквизитыБанкаПосредникаВалНажатие");
	ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"РеквизитыБанкаПосредникаВал",
		НСтр("ru = 'Банка-посредника'"),
		"РеквизитыБанкаПосредникаВал",
		ВидПоляФормы.ПолеНадписи,
		ГруппаПечРеквизиты,,
		СтруктураПараметров,
		События);		
	
	#КонецОбласти

КонецПроцедуры

Процедура СоздатьЭлементыАналитикиСтатей(Форма, Настройки, ПараметрыЭлементов)
	
	Элементы = Форма.Элементы;
	
	// Статьи бюджетов
	МассивОписанийСтатей = Новый Массив;
	АналитикиСтатейБюджетовУХ.СтатьяИАналитикиТаблицыЗначенийРеквизитаФормыВТаблицеФормы(МассивОписанийСтатей,
		"Объект.РасшифровкаПлатежа", "РасшифровкаПлатежа",
		"СтатьяДвиженияДенежныхСредств", "РасшифровкаПлатежаСтатьяДвиженияДенежныхСредств",
		"Аналитика%1", "РасшифровкаПлатежаАналитика%1",
		ФормыУХ.РазместитьПередЭлементомСтрокой(Элементы.РасшифровкаПлатежаПодразделение)
	);
	АналитикиСтатейБюджетовУХ.СтатьяИАналитикиТаблицыЗначенийРеквизитаФормыВПоляхФормы(МассивОписанийСтатей,
		"Объект.РасшифровкаПлатежа", "РасшифровкаПлатежа",
		"СтатьяДвиженияДенежныхСредств", "РасшифровкаБезРазбиенияСтатьяДвиженияДенежныхСредств",
		"Аналитика%1", "РасшифровкаБезРазбиенияАналитика%1",
		ФормыУХ.РазместитьПередЭлементомСтрокой(Элементы.РасшифровкаБезРазбиенияПодразделение)
	);
	АналитикиСтатейБюджетовУХ.СтатьяИАналитикиОбъектаВПоляхФормы(МассивОписанийСтатей,
		"СтатьяДвиженияДенежныхСредств", "СтатьяДвиженияДенежныхСредств",
		"Аналитика%1", "АналитикаШапка%1",
		ФормыУХ.РазместитьПередЭлементомСтрокой(Элементы.РаспоряжениеНаПеремещениеДенежныхСредств)
	);
	
	// Создать элементы формы для статей бюджетов и их аналитик
	АналитикиСтатейБюджетовУХ.СоздатьСтатьиБюджетовИАналитики(Форма, МассивОписанийСтатей, ПараметрыЭлементов.ПолеВвода);
	
	// Добавить видимость аналитик из расшифровки
	Настройка = ФормыУХ.ПолучитьНастройкиПоля(Настройки, "РасшифровкаБезРазбиенияСтатьяДвиженияДенежныхСредств", "Видимость")[0];
	ПараметрыСтатьиРасшифровка = МассивОписанийСтатей[0];
	
	// Без расшифровки
	ОписаниеСтатьи = ПараметрыСтатьиРасшифровка.ЭлементыФормы["РасшифровкаБезРазбиенияСтатьяДвиженияДенежныхСредств"];
	Для Каждого ЭлементСтатья Из ОписаниеСтатьи.ЭлементыАналитики Цикл
		Настройка.Поля.Добавить(ЭлементСтатья.ИмяЭлемента);
	КонецЦикла;
	
	// Расшифровка платежа
	ОписаниеСтатьи = ПараметрыСтатьиРасшифровка.ЭлементыФормы["РасшифровкаПлатежаСтатьяДвиженияДенежныхСредств"];
	Для Каждого ЭлементСтатья Из ОписаниеСтатьи.ЭлементыАналитики Цикл
		Настройка.Поля.Добавить(ЭлементСтатья.ИмяРодителя+"."+ЭлементСтатья.ИмяРеквизита);
	КонецЦикла;
	
	Элементы.ГруппаСтраницы.РастягиватьПоГоризонтали = Истина;
	
КонецПроцедуры

Процедура ЗаполнитьПервоначальныеИдентификаторыПозиций(Форма)
	Массив = Форма.Объект.РасшифровкаПлатежа.Выгрузить(, "ИдентификаторПозиции").ВыгрузитьКолонку("ИдентификаторПозиции");
	Форма.ПервоначальныеИдентификаторыПозиций = Новый ФиксированныйМассив(Массив);
КонецПроцедуры

Процедура УстановитьПараметрыЭлементовСтруктурыЗадолженности(Форма) Экспорт
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
		
	МассивВсехРеквизитов = Новый Массив; МассивРеквизитовОперации = Новый Массив;
	Документы.СписаниеБезналичныхДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(Объект, 
		МассивВсехРеквизитов, МассивРеквизитовОперации);
		
	МассивСвязей = Новый Массив;
	МассивПараметровВыбора = Новый Массив;
	
	Если МассивРеквизитовОперации.Найти("Договор") <> Неопределено Тогда
		МассивСвязей.Добавить(Новый СвязьПараметраВыбора("ДоговорКонтрагента", "Объект.Договор"));
	ИначеЕсли МассивРеквизитовОперации.Найти("РасшифровкаПлатежа.ДоговорКредитаДепозита") <> Неопределено Тогда
		МассивСвязей.Добавить(Новый СвязьПараметраВыбора("ДоговорКонтрагента", 
			"Элементы.РасшифровкаПлатежа.ТекущиеДанные.ДоговорКредитаДепозита"));
	ИначеЕсли МассивРеквизитовОперации.Найти("РасшифровкаПлатежа.ДоговорАренды") <> Неопределено Тогда
		МассивСвязей.Добавить(Новый СвязьПараметраВыбора("ДоговорКонтрагента", 
			"Элементы.РасшифровкаПлатежа.ТекущиеДанные.ДоговорАренды"));
	Иначе
		МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("ДоговорКонтрагента", Неопределено));
	КонецЕсли;
	
	Если МассивРеквизитовОперации.Найти("РасшифровкаПлатежа.ОбъектРасчетов") <> Неопределено Тогда
		МассивСвязей.Добавить(Новый СвязьПараметраВыбора("ОбъектРасчетов", 
			"Элементы.РасшифровкаПлатежа.ТекущиеДанные.ОбъектРасчетов"));
	КонецЕсли;
	
	МассивСвязей.Добавить(Новый СвязьПараметраВыбора("Ссылка", "Объект.Ссылка"));
		
	Элементы.РасшифровкаПлатежаЭлементСтруктурыЗадолженности.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивСвязей);
	Элементы.РасшифровкаПлатежаЭлементСтруктурыЗадолженности.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
	
	Элементы.РасшифровкаБезРазбиенияЭлементСтруктурыЗадолженности.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивСвязей);
	Элементы.РасшифровкаБезРазбиенияЭлементСтруктурыЗадолженности.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
	
КонецПроцедуры

Функция ДоговорСтрокиРасшифровки(Строка, Объект, МассивРеквизитовОперации)
	
	Если МассивРеквизитовОперации.Найти("РасшифровкаПлатежа.ОбъектРасчетов") <> Неопределено
		И ЗначениеЗаполнено(Строка.ОбъектРасчетов) Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Строка.ОбъектРасчетов, "Договор");
	КонецЕсли;
		
	Если МассивРеквизитовОперации.Найти("Договор") <> Неопределено Тогда
		Возврат Объект.Договор;
	ИначеЕсли МассивРеквизитовОперации.Найти("РасшифровкаПлатежа.ДоговорКредитаДепозита") <> Неопределено Тогда
		Возврат Строка.ДоговорКредитаДепозита;
	ИначеЕсли МассивРеквизитовОперации.Найти("РасшифровкаПлатежа.ДоговорАренды") <> Неопределено Тогда
		Возврат Строка.ДоговорАренды;
	КонецЕсли;

	Возврат Неопределено;
	  
КонецФункции

Процедура ЗаполнитьЭлементСтруктурыЗадолженностиПоУмолчанию(Объект)
	
	МассивВсехРеквизитов = Новый Массив; МассивРеквизитовОперации = Новый Массив;
	Документы.СписаниеБезналичныхДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(Объект, 
		МассивВсехРеквизитов, МассивРеквизитовОперации);
	
	Для каждого Строка ИЗ Объект.РасшифровкаПлатежа Цикл
		
		Договор = ДоговорСтрокиРасшифровки(Строка, Объект, МассивРеквизитовОперации);
		МассивЭлементов = ЗаявкиНаОперацииВызовСервера.ЭлементыСтруктурыЗадолженностиПоДоговору(Договор, Объект.Ссылка);
		Если МассивЭлементов.Количество() >= 1 Тогда 
			ЭлементСтруктурыЗадолженности = МассивЭлементов[0];
		Иначе
			ЭлементСтруктурыЗадолженности = Неопределено;
		КонецЕсли;
		
		Строка.ЭлементСтруктурыЗадолженности = ЭлементСтруктурыЗадолженности;
		
		СтатьяДДС = ЗаявкиНаОперацииВызовСервера.СтатьяДДСПоЭлементуСтруктурыЗадолженности(Договор, 
			ЭлементСтруктурыЗадолженности, ПредопределенноеЗначение("Перечисление.ВидыДвиженийПриходРасход.Расход"));
			
		Если ЗначениеЗаполнено(СтатьяДДС) Тогда
			Строка.СтатьяДвиженияДенежныхСредств = СтатьяДДС;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьЭлементСтруктурыЗадолженностиПоДоговору(РасшифровкаПлатежа, Договор, Ссылка)
	
	МассивЭлементов = ЗаявкиНаОперацииВызовСервера.ЭлементыСтруктурыЗадолженностиПоДоговору(Договор, Ссылка);
	Если МассивЭлементов.Количество() >= 1 Тогда 
		ЭлементСтруктурыЗадолженности = МассивЭлементов[0];
	Иначе
		ЭлементСтруктурыЗадолженности = Неопределено;
	КонецЕсли;
	
	СтатьяДДС = ЗаявкиНаОперацииВызовСервера.СтатьяДДСПоЭлементуСтруктурыЗадолженности(Договор, 
		ЭлементСтруктурыЗадолженности, ПредопределенноеЗначение("Перечисление.ВидыДвиженийПриходРасход.Расход"));
	
	Для каждого Строка ИЗ РасшифровкаПлатежа Цикл
		Строка.ЭлементСтруктурыЗадолженности = ЭлементСтруктурыЗадолженности;
		Если ЗначениеЗаполнено(СтатьяДДС) Тогда
			Строка.СтатьяДвиженияДенежныхСредств = СтатьяДДС;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьСтрокуРасшифровкиПоДоговору(Договор, Ссылка, Строка)
	
	МассивЭлементов = ЗаявкиНаОперацииВызовСервера.ЭлементыСтруктурыЗадолженностиПоДоговору(Договор, Ссылка);
	Если МассивЭлементов.Количество() >= 1 Тогда 
		ЭлементСтруктурыЗадолженности = МассивЭлементов[0];
	Иначе
		ЭлементСтруктурыЗадолженности = Неопределено;
	КонецЕсли;
	
	СтатьяДДС = ЗаявкиНаОперацииВызовСервера.СтатьяДДСПоЭлементуСтруктурыЗадолженности(Договор, 
		ЭлементСтруктурыЗадолженности, ПредопределенноеЗначение("Перечисление.ВидыДвиженийПриходРасход.Расход"));
	
	Строка.ЭлементСтруктурыЗадолженности = ЭлементСтруктурыЗадолженности;
	Если ЗначениеЗаполнено(СтатьяДДС) Тогда
		Строка.СтатьяДвиженияДенежныхСредств = СтатьяДДС;
	КонецЕсли;
	
КонецПроцедуры

Функция СтатьяДДСПоЭлементуСтруктурыЗадолженности(ЭлементСтруктурыЗадолженности, Строка, Объект) Экспорт
	
	МассивВсехРеквизитов = Новый Массив; МассивРеквизитовОперации = Новый Массив;
	Документы.СписаниеБезналичныхДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(Объект, 
		МассивВсехРеквизитов, МассивРеквизитовОперации);
			
	Договор = ДоговорСтрокиРасшифровки(Строка, Объект, МассивРеквизитовОперации);	
	СтатьяДДС = ЗаявкиНаОперацииВызовСервера.СтатьяДДСПоЭлементуСтруктурыЗадолженности(Договор, 
		ЭлементСтруктурыЗадолженности, ПредопределенноеЗначение("Перечисление.ВидыДвиженийПриходРасход.Расход"));
		
	Возврат СтатьяДДС;
	
КонецФункции

Процедура ЗаполнитьТипСуммыКредитаДепозита(Объект)
	
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	
	Документы.СписаниеБезналичныхДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		Объект, МассивВсехРеквизитов, МассивРеквизитовОперации);
		
	Если МассивРеквизитовОперации.Найти("РасшифровкаПлатежа.ТипСуммыКредитаДепозита") <> Неопределено Тогда
		
		Для каждого Строка ИЗ Объект.РасшифровкаПлатежа Цикл
			Строка.ТипСуммыКредитаДепозита = ЗаявкиНаОперацииКлиентСервер.ТипСуммыКредитаДепозитаПоЭлементуСтруктурыЗадолженности(
				Строка.ЭлементСтруктурыЗадолженности);
		КонецЦикла;
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ПроверитьВозможностьПроведенияДокумента(Объект,ИспользованныеПозиции)

	//Проверяем наличие документа,изменившего состояние платежной позиции
	Если Объект.Проведен Тогда
		
		МассивСостояниеИсполнения = Новый Массив;
		Если ТипЗнч(Объект) = Тип("ДокументОбъект.РеестрПлатежей")  Тогда
			МассивСостояниеИсполнения.Добавить(Перечисления.СостоянияИсполненияЗаявки.НеОбработана);
		Иначе 
			МассивСостояниеИсполнения.Добавить(Перечисления.СостоянияИсполненияЗаявки.НеОбработана);
			МассивСостояниеИсполнения.Добавить(Перечисления.СостоянияИсполненияЗаявки.ВключенаВРеестрПлатежей);
		КонецЕсли; 
		
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("СостояниеИсполнения", МассивСостояниеИсполнения);
	
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВТ_ИспользованныеПозиции.ДокументПланирования КАК ДокументПланирования,
		|	ВТ_ИспользованныеПозиции.ИдентификаторПозиции КАК ИдентификаторПозиции
		|ПОМЕСТИТЬ ВТ_ИспользованныеПозиции
		|ИЗ
		|	&ИспользованныеПозиции КАК ВТ_ИспользованныеПозиции
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СостоянияИсполнения.ДокументИзменившийСостояние КАК ДокументИзменившийСостояние,
		|	ВТ_ИспользованныеПозиции.ИдентификаторПозиции КАК ИдентификаторПозиции
		|ИЗ
		|	ВТ_ИспользованныеПозиции КАК ВТ_ИспользованныеПозиции
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияИсполненияДокументовПланирования.СрезПоследних КАК СостоянияИсполнения
		|		ПО ВТ_ИспользованныеПозиции.ДокументПланирования = СостоянияИсполнения.ДокументПланирования
		|			И ВТ_ИспользованныеПозиции.ИдентификаторПозиции = СостоянияИсполнения.ИдентификаторПозиции
		|ГДЕ
		|	НЕ СостоянияИсполнения.СостояниеИсполнения В (&СостояниеИсполнения)
		|	И НЕ СостоянияИсполнения.ДокументИзменившийСостояние = &ДокументИзменившийСостояние";
		
		СсылкаНаОбъект =  Объект.Ссылка;
		
		Запрос.УстановитьПараметр("ИспользованныеПозиции", 			ИспользованныеПозиции);
		Запрос.УстановитьПараметр("ДокументИзменившийСостояние",	СсылкаНаОбъект);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		ПричинаИсключения = "";
		
		Пока Выборка.Следующий() Цикл
			ПричинаИсключения = ПричинаИсключения + СтрШаблон(НСтр("ru = 'По платежной позиции уже создан документ %1'"),Выборка.ДокументИзменившийСостояние)+Символы.ПС;	
		КонецЦикла;
		
		ПричинаИсключения = Лев(ПричинаИсключения,СтрДлина(ПричинаИсключения)-1);
		
		Если ЗначениеЗаполнено(ПричинаИсключения) тогда
			
			ВызватьИсключение ПричинаИсключения;
			
		КонецЕсли;
		
	КонецЕсли;	
	

КонецПроцедуры

Процедура ИнициализироватьДокумент(Объект, ДанныеЗаполнения) Экспорт

	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") тогда
		
		Если ДанныеЗаполнения.Свойство("КурсПлатежа") И ЗначениеЗаполнено(ДанныеЗаполнения.КурсПлатежа)
			И ДанныеЗаполнения.Свойство("КратностьПлатежа") И ЗначениеЗаполнено(ДанныеЗаполнения.КратностьПлатежа) тогда

			Для каждого СтрокаТЧ Из Объект.РасшифровкаПлатежа Цикл
					СтрокаТЧ.КурсЧислительВзаиморасчетов 		= ДанныеЗаполнения.КурсПлатежа;
					СтрокаТЧ.КурсЗнаменательВзаиморасчетов	 	= ДанныеЗаполнения.КратностьПлатежа;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти 

#Область ПрограммныйИнтрефейс
Процедура ОбновитьЗаголовокГруппыНомераГТД(Форма) Экспорт
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	Элементы.ГруппаНомераГТД.Заголовок = СтрШаблон(НСтр("ru = 'Номера таможенных деклараций (%1)'"), Объект.НомераГТД.Количество());
КонецПроцедуры

Процедура УстановитьПечатныеРеквизитыВал(Форма, СсылкаИсточник, СтрокаЗамены) Экспорт
	
	Объект = Форма.Объект;
	М = ВстраиваниеУХСписаниеБезналичныхДенежныхСредствКлиентСервер;
	
	Если ЗначениеЗаполнено(СсылкаИсточник) Тогда
		
		Реквизиты = Новый Структура("Наименование1, АдресМеждународный, ГородСтранаМеждународный");
		Если СтрокаЗамены = "БанкаПосредника" Тогда
			// банковский счет организации		
			РучноеИзменениеРеквизитов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаИсточник, "РучноеИзменениеРеквизитовБанкаДляРасчетов");
			Если РучноеИзменениеРеквизитов Тогда
				Реквизиты.Наименование1 = "НаименованиеБанкаДляРасчетовМеждународное";
				Реквизиты.АдресМеждународный = "АдресБанкаДляРасчетовМеждународный";
				Реквизиты.ГородСтранаМеждународный = "ГородБанкаДляРасчетовМеждународный";
			Иначе
				Реквизиты.Наименование1 = "БанкДляРасчетов.МеждународноеНаименование";
				Реквизиты.АдресМеждународный = "БанкДляРасчетов.АдресМеждународный";
				Реквизиты.ГородСтранаМеждународный = "БанкДляРасчетов.ГородМеждународный";
			КонецЕсли;
			
		ИначеЕсли СтрокаЗамены = "БанкаПлательщика" ИЛИ СтрокаЗамены = "БанкаПолучателя" Тогда
			// Банковский счет организации или контрагента
			РучноеИзменениеРеквизитов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаИсточник, "РучноеИзменениеРеквизитовБанка");
			Если РучноеИзменениеРеквизитов Тогда
				Реквизиты.Наименование1 = "НаименованиеБанкаМеждународное";
				Реквизиты.АдресМеждународный = "АдресБанкаМеждународный";
				Реквизиты.ГородСтранаМеждународный = "ГородБанкаМеждународный";
			Иначе
				Реквизиты.Наименование1 = "Банк.МеждународноеНаименование";
				Реквизиты.АдресМеждународный = "Банк.АдресМеждународный";
				Реквизиты.ГородСтранаМеждународный = "Банк.ГородМеждународный";
			КонецЕсли;				
			
		КонецЕсли;
		
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СсылкаИсточник, Реквизиты);
		Объект[М.РеквизитНаименованиеВал(СтрокаЗамены)] = СтруктураРеквизитов.Наименование1;
		Объект[М.РеквизитАдресВал(СтрокаЗамены)] = СтруктураРеквизитов.АдресМеждународный;
		Объект[М.РеквизитГородСтранаВал(СтрокаЗамены)] = СтруктураРеквизитов.ГородСтранаМеждународный;
	Иначе		
		Объект[М.РеквизитНаименованиеВал(СтрокаЗамены)] = "";
		Объект[М.РеквизитАдресВал(СтрокаЗамены)] = "";
		Объект[М.РеквизитГородСтранаВал(СтрокаЗамены)] = "";
	КонецЕсли;
	
	М.ОбновитьПечатныеРеквизитыВал(Форма, СтрокаЗамены);
	
КонецПроцедуры
#КонецОбласти

#КонецОбласти 

#КонецОбласти 

#Область МодульОбъекта

Процедура ПриЗаписи(Объект, Отказ) экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	МассивВсехРеквизитов 		= Новый Массив;
	МассивРеквизитовОперации 	= Новый Массив;
	Документы.СписаниеБезналичныхДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		Объект, МассивВсехРеквизитов, МассивРеквизитовОперации);
	
	ЕстьРасшифровка = (МассивРеквизитовОперации.Найти("РасшифровкаПлатежа") <> Неопределено);
	ИменаРеквизитов = "ДокументПланирования,ИдентификаторПозиции";
	
	ИспользованныеПозиции = Объект.РасшифровкаПлатежа.Выгрузить(, ИменаРеквизитов);
	Если НЕ ЕстьРасшифровка Тогда
		ИспользованныеПозиции.Очистить();
		ЗаполнитьЗначенияСвойств(ИспользованныеПозиции.Добавить(), Объект, ИменаРеквизитов);
	КонецЕсли;
	
	ИндексСтроки = ИспользованныеПозиции.Количество()-1;
	Пока ИндексСтроки >= 0  Цикл
	
		Если НЕ ЗначениеЗаполнено(ИспользованныеПозиции[ИндексСтроки].ИдентификаторПозиции) Тогда
			ИспользованныеПозиции.Удалить(ИндексСтроки);	
		КонецЕсли; 
		
		ИндексСтроки = ИндексСтроки - 1;
		
	КонецЦикла; 
	
	ПроверитьВозможностьПроведенияДокумента(Объект,ИспользованныеПозиции);
	
	// Записать состояния плаженой позиции 
	ДенежныеСредстваВстраиваниеУХ.ЗаписатьСостояниеИспользованныхПлатежныхПозиций(Объект, ИспользованныеПозиции);
	
КонецПроцедуры

#КонецОбласти 

#Область МодульМенеджера

// Определяет свойства полей формы в зависимости от данных
//
// Возвращаемое значение:
//    ТаблицаЗначений - таблица с колонками Поля, Условие, Свойства.
//
Функция НастройкиПолейФормы(Настройки) Экспорт
	
	// Статья доступна и для операций распоряжения
	Настройка = ФормыУХ.ПолучитьНастройкиПоля(Настройки, "СтатьяДвиженияДенежныхСредств", "Видимость")[0];
	ГруппаИЛИ = Настройка.Условие.Элементы[0];
	ФормыУХ.НовыйОтбор(ГруппаИЛИ, "ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет);
	ФормыУХ.НовыйОтбор(ГруппаИЛИ, "ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.СнятиеНаличныхДенежныхСредств);
	
	// Кнопки заполнения ERP теперь не работают
	Элемент = Настройки.Добавить();
	//Элемент.Поля.Добавить("РасшифровкаПлатежаПодборПоОстаткам");
	Элемент.Поля.Добавить("РасшифровкаПлатежаПодобратьИзЗаявок");
	ФормыУХ.НовыйОтбор(Элемент.Условие, "Дополнительно.Истина", Ложь,,);
	Элемент.Свойства.Вставить("Видимость");
	
	// ЦФО, Проект, ДокументПланирования в шапке
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ЦФО");
	Элемент.Поля.Добавить("Проект");
	Элемент.Поля.Добавить("ДокументПланирования");
	
	Финансы = ФинансоваяОтчетностьСервер;
	
	ГруппаИли = ФормыУХ.НовыйОтбор(Элемент.Условие,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	ФормыУХ.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет);
	ФормыУХ.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.СнятиеНаличныхДенежныхСредств);
	
	ГруппаИ1 = ФормыУХ.НовыйОтбор(ГруппаИли,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИ1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	ФормыУХ.НовыйОтбор(ГруппаИ1, "ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ВыдачаЗаймаСотруднику);
	ФормыУХ.НовыйОтбор(ГруппаИ1, "Дополнительно.ИспользоватьНачислениеЗарплатыУТ", Ложь);
	
	ГруппаИ2 = ФормыУХ.НовыйОтбор(ГруппаИли,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИ2.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	ФормыУХ.НовыйОтбор(ГруппаИ2, "ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыПоЗарплатномуПроекту);
	ФормыУХ.НовыйОтбор(ГруппаИ2, "Дополнительно.ИспользоватьНачислениеЗарплатыУТ", Ложь);
	
	ГруппаИ2 = ФормыУХ.НовыйОтбор(ГруппаИли,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИ2.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	ФормыУХ.НовыйОтбор(ГруппаИ2, "ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыНаЛицевыеСчета);
	ФормыУХ.НовыйОтбор(ГруппаИ2, "Дополнительно.ИспользоватьНачислениеЗарплатыУТ", Ложь);
	
	Элемент.Свойства.Вставить("Видимость");
	
	// банковский счет комиссия
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("БанковскийСчетСписанияКомиссииУХ");
	ГруппаИли = ФормыУХ.НовыйОтбор(Элемент.Условие,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	ФормыУХ.НовыйОтбор(ГруппаИли, "ТипКомиссииЗаПеревод", Перечисления.ТипыКомиссииЗаБанковскиеПереводы.SHA);
	ФормыУХ.НовыйОтбор(ГруппаИли, "ТипКомиссииЗаПеревод", Перечисления.ТипыКомиссииЗаБанковскиеПереводы.OUR);
	Элемент.Свойства.Вставить("Видимость");
	
	// вместо типа суммы кредита и депозита используем наш реквизит ЭлементСтруктурыЗадолженности
	Элементы  = ФормыУХ.ПолучитьНастройкиПоля(Настройки, "РасшифровкаПлатежа.ТипСуммыКредитаДепозита", "Видимость");
	Для каждого Элемент Из Элементы Цикл
		Элемент.Условие.Элементы.Очистить();
		ФормыУХ.НовыйОтбор(Элемент.Условие, "Дополнительно.Истина", Ложь);
	КонецЦикла;
	
КонецФункции

#КонецОбласти 
