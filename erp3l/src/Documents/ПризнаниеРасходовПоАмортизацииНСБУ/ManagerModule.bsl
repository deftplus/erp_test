
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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

#Область ПодготовкаПараметровПроведенияДокумента

Функция ПодготовитьПараметрыПроведения(ДополнительныеСвойства, Отказ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДополнительныеСвойства.ДляПроведения.Ссылка);
	
	Реквизиты = МСФОУХ.РеквизитыДокумента(Запрос, "АлгоритмРСБУ", "ПериодОтчета", Отказ);
	ДополнительныеСвойства.ДляПроведения.Вставить("Реквизиты", Реквизиты);
	Если Отказ Тогда
		Возврат ДополнительныеСвойства;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Организация",	Реквизиты.Организация);
	Запрос.УстановитьПараметр("Сценарий",		Реквизиты.Сценарий);	
	Запрос.УстановитьПараметр("Период",			КонецДня(Реквизиты.Период));	
	Запрос.УстановитьПараметр("ВидыУчета", 		ПредопределенноеЗначение("Перечисление.ВидыУчета.МСФО"));
	Запрос.УстановитьПараметр("ВсеОрганизации", Ложь);
	Запрос.УстановитьПараметр("ФормироватьПроводкиМСФО", 	Реквизиты.ФормироватьПроводкиМСФО);
	
	НомераТаблиц = Новый Структура;
	ТекстЗапроса = Новый Массив;
	
	ТекстЗапроса.Добавить(ТекстЗапроса_ПроводкиСторноНСБУ(НомераТаблиц));
	ТекстЗапроса.Добавить(ТекстЗапроса_ПроводкиНачислениеНСБУ(НомераТаблиц));
	ТекстЗапроса.Добавить(ТекстЗапроса_СтоимостьВНАМСФО(НомераТаблиц));
	
	Запрос.Текст = СтрСоединить(ТекстЗапроса, ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета());
	ПроведениеСерверУХ.ДополнитьТаблицамиИзПакетаЗапросов(ДополнительныеСвойства.ТаблицыДляДвижений, Запрос, НомераТаблиц);
	
КонецФункции

Функция ТекстЗапроса_ПроводкиНачислениеНСБУ(НомераТаблиц)

	НомераТаблиц.Вставить("ПроводкиНачислениеНСБУ", НомераТаблиц.Количество());
	
	Возврат
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.ВНА КАК ВНА,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.ГруппаВНА КАК ГруппаВНА,
	|	ЗНАЧЕНИЕ(Справочник.ВидыОпераций.Трансляция) КАК ВидОперации,
	|	0 КАК СуммаОперацииНСБУ,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.Сумма КАК СуммаОперацииМСФО,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетДтМСФО.СчетСсылка КАК СчетДтМСФО,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетКтМСФО.СчетСсылка КАК СчетКтМСФО,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетДтМСФО КАК СчетДт,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетКтМСФО КАК СчетКт,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетДтСубконто1МСФО КАК СубконтоДт1,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетДтСубконто2МСФО КАК СубконтоДт2,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетДтСубконто3МСФО КАК СубконтоДт3,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетКтСубконто1МСФО КАК СубконтоКт1,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетКтСубконто2МСФО КАК СубконтоКт2,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетКтСубконто3МСФО КАК СубконтоКт3,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.ПодразделениеДт КАК ПодразделениеДт,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.НаправлениеДеятельностиДт КАК НаправлениеДеятельностиДт,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.ПодразделениеКт КАК ПодразделениеКт,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.НаправлениеДеятельностиКт КАК НаправлениеДеятельностиКт
	|ИЗ
	|	Документ.ПризнаниеРасходовПоАмортизацииНСБУ.ВНА КАК ПризнаниеРасходовПоАмортизацииНСБУВНА
	|ГДЕ
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.Ссылка = &Ссылка
	|	И ВЫБОР
	|			КОГДА &ФормироватьПроводкиМСФО
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ НЕ ПризнаниеРасходовПоАмортизацииНСБУВНА.СторнироватьДанныеНСБУ
	|		КОНЕЦ";

КонецФункции

Функция ТекстЗапроса_ПроводкиСторноНСБУ(НомераТаблиц)

	НомераТаблиц.Вставить("ПроводкиСторноНСБУ", НомераТаблиц.Количество());
	
	Возврат
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.ВНА КАК ВНА,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.ГруппаВНА КАК ГруппаВНА,
	|	ЗНАЧЕНИЕ(Справочник.ВидыОпераций.СторноАмортизацииНСБУ) КАК ВидОперации,
	|	0 КАК СуммаОперацииНСБУ,
	|	-ПризнаниеРасходовПоАмортизацииНСБУВНА.Сумма КАК СуммаОперацииМСФО,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетДтМСФО.СчетСсылка КАК СчетДтМСФО,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетКтМСФО.СчетСсылка КАК СчетКтМСФО,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетКтМСФО КАК СчетКт,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетДтМСФО КАК СчетДт,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетДтСубконто1МСФО КАК СубконтоДт1,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетДтСубконто2МСФО КАК СубконтоДт2,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетДтСубконто3МСФО КАК СубконтоДт3,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетКтСубконто1МСФО КАК СубконтоКт1,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетКтСубконто2МСФО КАК СубконтоКт2,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.СчетКтСубконто3МСФО КАК СубконтоКт3,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.ПодразделениеДт КАК ПодразделениеДт,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.НаправлениеДеятельностиДт КАК НаправлениеДеятельностиДт,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.ПодразделениеКт КАК ПодразделениеКт,
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.НаправлениеДеятельностиКт КАК НаправлениеДеятельностиКт
	|ИЗ
	|	Документ.ПризнаниеРасходовПоАмортизацииНСБУ.ВНА КАК ПризнаниеРасходовПоАмортизацииНСБУВНА
	|ГДЕ
	|	ПризнаниеРасходовПоАмортизацииНСБУВНА.Ссылка = &Ссылка";

КонецФункции

Функция ТекстЗапроса_СтоимостьВНАМСФО(НомераТаблиц)

	НомераТаблиц.Вставить("ТаблицаВНА", НомераТаблиц.Количество());
	
	Возврат
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	т.ВНА КАК ВНА,
	|	&Организация КАК Организация,
	|	т.ГруппаВНА КАК ГруппаВНА,
	|	ЗНАЧЕНИЕ(Справочник.ВидыОпераций.НачислениеАмортизации) КАК ВидОперации,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыУчета.НСБУ) КАК ВидУчета,
	|	&Сценарий КАК Сценарий,
	|	0 КАК СуммаВВалютеУчета,
	|	т.Сумма КАК Амортизация,
	|	0 КАК Переоценка,
	|	0 КАК Обесценение,
	|	0 КАК РезервПереоценки,
	|	0 КАК ПереоценкаАмортизации
	|ИЗ
	|	Документ.ПризнаниеРасходовПоАмортизацииНСБУ.ВНА КАК т
	|ГДЕ
	|	т.Ссылка = &Ссылка
	|	И т.Сумма <> 0";

КонецФункции

Процедура СформироватьДвижения(Движения, ДополнительныеСвойства, Отказ) Экспорт
		
	Реквизиты 				= ДополнительныеСвойства.ДляПроведения.Реквизиты;
	ТаблицаВНА 				= ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаВНА;
		
	Если МСФОВНАУХ.ЕстьОшибкиПроведения(ДополнительныеСвойства, Отказ) Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиОтражения = МСФОВНАУХ.ПолучитьНастройкиОтражения();	
	НастройкиОтражения.Вставить("НачисленнаяАмортизацияВНАМСФО", 	Истина);
	МСФОВНАУХ.ОтразитьДвиженияПараметровУчетаВНА(Движения, Реквизиты, ТаблицаВНА, НастройкиОтражения);
	
	//Таблица была развернута по профилям распределения
	ТаблицаВНА.Свернуть("Период,ГруппаВНА,ВНА,ВидОперации,ВидУчета", "Амортизация,РезервПереоценки");
	
	НастройкиОтражения = МСФОВНАУХ.ПолучитьНастройкиОтражения();	
	НастройкиОтражения.Вставить("СтоимостьВНАМСФО", Истина);	
	МСФОВНАУХ.ОтразитьДвиженияПараметровУчетаВНА(Движения, Реквизиты, ТаблицаВНА, НастройкиОтражения);
	
	ТаблицаПроводкиВНА 		= ДополнительныеСвойства.ТаблицыДляДвижений.ПроводкиНачислениеНСБУ;
	Реквизиты.Вставить("ВидОперации", ПредопределенноеЗначение("Справочник.ВидыОпераций.Трансляция"));
	
	МСФОВНАУХ.ОтразитьПроводкиВНА(Движения, Реквизиты, ТаблицаПроводкиВНА, Отказ, Новый Структура("ИспользоватьКлючевыеСубконто", Ложь));
	
	ТаблицаПроводкиВНА 		= ДополнительныеСвойства.ТаблицыДляДвижений.ПроводкиСторноНСБУ;
	Реквизиты.Вставить("ВидОперации", ПредопределенноеЗначение("Справочник.ВидыОпераций.СторноАмортизацииНСБУ"));
	
	МСФОВНАУХ.ОтразитьПроводкиВНА(Движения, Реквизиты, ТаблицаПроводкиВНА, Отказ, Новый Структура("ИспользоватьКлючевыеСубконто", Ложь));
	
КонецПроцедуры

#КонецОбласти

#Область Параметры

Функция ПолучитьИменаСубконто() Экспорт

	Результат = Новый Структура;
	
	Субконто = Новый Соответствие;
	Субконто.Вставить(1, "СчетДтСубконто1НСБУ");
	Субконто.Вставить(2, "СчетДтСубконто2НСБУ");
	Субконто.Вставить(3, "СчетДтСубконто3НСБУ");
	
	Результат.Вставить("СчетДтНСБУ", Субконто);

	Субконто = Новый Соответствие;
	Субконто.Вставить(1, "СчетКтСубконто1НСБУ");
	Субконто.Вставить(2, "СчетКтСубконто2НСБУ");
	Субконто.Вставить(3, "СчетКтСубконто3НСБУ");
	
	Результат.Вставить("СчетКтНСБУ", Субконто);

	Субконто = Новый Соответствие;
	Субконто.Вставить(1, "СчетДтСубконто1МСФО");
	Субконто.Вставить(2, "СчетДтСубконто2МСФО");
	Субконто.Вставить(3, "СчетДтСубконто3МСФО");
	Субконто.Вставить("Подразделение", "ПодразделениеДт");
	Субконто.Вставить("НаправлениеДеятельности", "НаправлениеДеятельностиДт");
		
	Результат.Вставить("СчетДтМСФО", Субконто);

	Субконто = Новый Соответствие;
	Субконто.Вставить(1, "СчетКтСубконто1МСФО");
	Субконто.Вставить(2, "СчетКтСубконто2МСФО");
	Субконто.Вставить(3, "СчетКтСубконто3МСФО");
	Субконто.Вставить("Подразделение", "ПодразделениеКт");
	Субконто.Вставить("НаправлениеДеятельности", "НаправлениеДеятельностиКт");
	
	Результат.Вставить("СчетКтМСФО", Субконто);

	Возврат Результат;
	
КонецФункции

Функция ПолучитьСтруктуруДействий(ДляФормы = Ложь) Экспорт

	ИменаСубконто = ПолучитьИменаСубконто();
	
	ЗаполнитьСубконтоИзТрансляции = Новый Структура;
	ЗаполнитьСубконтоИзТрансляции.Вставить(
			"СчетДтМСФО", 
			Новый Структура("КолонкаСчетИсточник,СубконтоПриемник,СубконтоИсточник", 
							"СчетДтНСБУ", ИменаСубконто.СчетДтМСФО, ИменаСубконто.СчетДтНСБУ)
		);
		
	ЗаполнитьСубконтоИзТрансляции.Вставить(
			"СчетКтМСФО", 
			Новый Структура("КолонкаСчетИсточник,СубконтоПриемник,СубконтоИсточник", 
							"СчетКтНСБУ", ИменаСубконто.СчетКтМСФО, ИменаСубконто.СчетКтНСБУ)
		);	
	
	
	СтруктураДействий = Новый Структура;	
	СтруктураДействий.Вставить("ЗаполнитьСубконтоИзТрансляции",		ЗаполнитьСубконтоИзТрансляции);
	СтруктураДействий.Вставить("ЗаполнитьСчетаМСФОИзТрансляции",	Новый Структура("СчетДтМСФО,СчетКтМСФО", "СчетДтНСБУ", "СчетКтНСБУ"));
		
	Если ДляФормы Тогда		
		СтруктураДействий.Вставить("ЗаполнитьДоступностьПоИменамСубконто", ИменаСубконто);	
	КонецЕсли;
	
	Возврат СтруктураДействий;

КонецФункции

//КоллекцияСтрок - ТабличнаяЧасть,ТаблицаЗначений,ДанныеФормыКоллекция, СтрокаТабличнойЧасти
//Источник - ДокументОбъект, ДанныеФормыСтруктура, УправляемаяФорма
//ПараметрыЗаполнения - Структура(ЗаполнитьРеквизиты = Ложь,  ЗаполнитьНСБУ = Ложь, ЗаполнитьМСФО = Ложь)
Процедура ЗаполнитьСтроки(КоллекцияСтрок, Источник, ПараметрыЗаполненияТЧ = Неопределено) Экспорт
	
	ЗаполняемыеРеквизитыТаблицыФормы = МСФОУХ.ПолучитьЗаполняемыеРеквизитыТаблицыФормы(Источник);	
	
	Для каждого СтрокаДляЗаполнения Из КоллекцияСтрок Цикл
			
		Если ЗаполняемыеРеквизитыТаблицыФормы <> Неопределено Тогда			
			МСФОКлиентСерверУХ.ЗаполнитьРасчетныеРеквизитыСтроки(СтрокаДляЗаполнения, ЗаполняемыеРеквизитыТаблицыФормы);			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры 

Процедура ЗаполнитьЗависимостиРеквизитовДокумента(ФормаДокумента) Экспорт 
	
	ЗависимостиРеквизитов = Новый Массив;
	ФормаДокумента.КэшируемыеЗначения.Вставить("ЗависимостиРеквизитов", ЗависимостиРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

