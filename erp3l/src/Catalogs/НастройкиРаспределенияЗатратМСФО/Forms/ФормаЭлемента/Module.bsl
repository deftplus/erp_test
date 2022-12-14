
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();		
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ПодготовитьФормуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЗаполнитьДобавленныеКолонкиТаблиц();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЗагрузитьТаблицей(Команда)
	
	ДопПараметры = Новый Структура("ИмяОбъекта, ИмяТЧ, ИсточникКолонок", 
		"Справочник.НастройкиРаспределенияЗатратМСФО", "БазаРаспределенияПриемника", "ТЧ");
	
	ОписаниеКоманды = Новый Структура("ДополнительныеПараметры", ДопПараметры);
	ПараметрыВыполненияКоманды = Новый Структура("ОписаниеКоманды, Форма", ОписаниеКоманды, ЭтотОбъект);
	
	МСФОКлиентУХ.ЗагрузкаДанных_Подключаемый(Объект.Ссылка, ПараметрыВыполненияКоманды);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетИсточникПриИзменении(Элемент)
	МСФОКлиентСерверУХ.ОбновитьСубконтоСчета(ЭтаФорма, Элемент.Имя, Объект);
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СчетПриемникПриИзменении(Элемент)
	МСФОКлиентСерверУХ.ОбновитьСубконтоСчета(ЭтаФорма, Элемент.Имя, Объект);
КонецПроцедуры

&НаКлиенте
Процедура СпособЗакрытияПриИзменении(Элемент)
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура БазаРаспределенияПриемникаСчетПриИзменении(Элемент)
	ОбновитьСубконтоСчетаСтроки(ЭтаФорма, Элементы.БазаРаспределенияПриемника.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура БазаРаспределенияПриемникаПередНачаломИзменения(Элемент, Отказ)
	ОбновитьСубконтоСчетаСтроки(ЭтаФорма, Элементы.БазаРаспределенияПриемника.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура Запрос_Конструктор(Команда)
	
	Конструктор = Новый КонструкторЗапроса(Объект.Запрос);
	ОповещениеКонструктор = Новый ОписаниеОповещения("Подключаемый_УстановитьТекстЗапроса", ЭтотОбъект);
	Конструктор.Показать(ОповещениеКонструктор);
	
КонецПроцедуры

&НаКлиенте
Процедура Запрос_ПримерДляРБ(Команда)
	Объект.Запрос = ТекстЗапроса_БазаРаспределенияПриемника(Объект.СчетИсточник);
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Способ = Форма.Объект.СпособЗакрытия;
	
	РбРСБУ = Форма.Объект.РегистрУчета = Форма.КэшируемыеЗначения.РбРСБУ;
	
	ГруппаПриемникПростыеОтборы = Ложь;
	ГруппаТаблица = Ложь;
	ГруппаЗапрос = Ложь;
	
	Подсказка = Новый Массив;
		
	Если Способ = ПредопределенноеЗначение("Перечисление.СпособыЗакрытияСчетовЗатрат.ПропорциональноОборотуНсбуДтКт") Тогда
		
		ГруппаПриемникПростыеОтборы = Истина;
		Элементы.ФормаСправочникНастройкиРаспределенияЗатратМСФОАнализСчетаБазыМСФО.Видимость = Истина;

		//Подсказка.Добавить(НСтр("ru = 'База распределения НСБУ: Дт <Счет закрытия(Отбор Счета закрытия)> Кт <Закрываемый счет затрат(Отбор закрываемого счета затрат)>'"));
		//Подсказка.Добавить(НСтр("ru = 'Доля распределения НСБУ: <Сумма базы распределения> / (<Итог по сумме базы распределения> + <сальдо конечное по закрываемому счету затрат>)'"));
		//Подсказка.Добавить(НСтр("ru = 'Проводка: Дт <Счет закрытия(Отбор Счета закрытия)> Кт <Закрываемый счет затрат(Отбор закрываемого счета затрат)> Сумма: <сальдо закрываемого счета затрат> * <Доля распределения>'"));
		//
		
		Если РбРСБУ Тогда
			
			Подсказка.Добавить(НСтр(
			"ru = 'При закрытии будут сделаны проводки закрытия с теми же субконто, которые были в проводках учета. 
	         |При этом, будут проигнорированы субконто проводок, которые не соотвутствуют установленным отборам по счету Дт и 
	         |счету Кт. Сумма проводок закрытия рассчитывается пропорционально сумме проводок учета.'"));
			
		Иначе	
			
			Подсказка.Добавить(НСтр(
			"ru = 'При закрытии будут сделаны проводки с теми же субконто, которые были в оттранслированных проводках НСБУ. 
	         |При этом, будут проигнорированы субконто проводок, которые не соотвутствуют установленным отборам по счету Дт и 
	         |счету Кт. Сумма проводок по МСФО рассчитывается пропорционально сумме проводок НСБУ. Если по НСБУ осталось 
	         |незакрытое сальдо, то и по МСФО часть суммы останется несписанной на закрываемом счете в такой же пропорции: 
	         |отношение списанной и оставшения по НСБУ суммы будет равно отношению списанной и оставшейса по МСФО сумме.'"));
			
		КонецЕсли;
		
	ИначеЕсли Способ = ПредопределенноеЗначение("Перечисление.СпособыЗакрытияСчетовЗатрат.ПропорциональноОборотуНсбуДт") Тогда
		
		ГруппаПриемникПростыеОтборы = Истина;
		Элементы.ФормаСправочникНастройкиРаспределенияЗатратМСФОАнализСчетаБазыМСФО.Видимость = Истина;
		
		Подсказка.Добавить(НСтр("ru = 'База распределения НСБУ: Дт <Счет закрытия(Отбор Счета закрытия)> Кт <Любой счет>'"));
		Подсказка.Добавить(НСтр("ru = 'Доля распределения НСБУ: <Сумма базы распределения> / <Итог по сумме базы распределения>'"));
		Подсказка.Добавить(НСтр("ru = 'Проводка: Дт <Счет закрытия(Отбор Счета закрытия)> Кт <Закрываемый счет затрат(Отбор закрываемого счета затрат)> Сумма: <сальдо закрываемого счета затрат> * <Доля распределения>'"));
		
	ИначеЕсли Способ = ПредопределенноеЗначение("Перечисление.СпособыЗакрытияСчетовЗатрат.ПропорциональноДолямТаблицы") Тогда
		
	 	ГруппаТаблица = Истина;
		Элементы.ФормаСправочникНастройкиРаспределенияЗатратМСФОАнализСчетаБазыМСФО.Видимость = Ложь;
		
		Подсказка.Добавить(НСтр("ru = 'Проводка: Дт <Счет базы распределения> Кт <Закрываемый счет затрат(Отбор закрываемого счета затрат)> Сумма: <сальдо закрываемого счета затрат> * <Доля распределения>'"));
				
	ИначеЕсли Способ = ПредопределенноеЗначение("Перечисление.СпособыЗакрытияСчетовЗатрат.ПропорциональноДолямЗапроса") Тогда
		
		ГруппаЗапрос = Истина;
		Если Не ЗначениеЗаполнено(Форма.Объект.Запрос) Тогда
			Форма.Объект.Запрос = ТекстЗапроса_БазаРаспределенияПриемника(Форма.Объект.СчетИсточник);
			Форма.Модифицированность = Истина;
		КонецЕсли;
		
		Элементы.ФормаСправочникНастройкиРаспределенияЗатратМСФОАнализСчетаБазыМСФО.Видимость = Ложь;
		
		Подсказка.Добавить(НСтр("ru = 'База распределения: Временная таблица с именем <БазаРаспределения(Счет,НаправлениеДеятельности,Подразделение,Субконто1,Субконто2,Субконто3,Доля)>'"));
		Подсказка.Добавить(НСтр("ru = 'Проводка: Дт <Счет базы распределения> Кт <Закрываемый счет затрат(Отбор закрываемого счета)> Сумма: <сальдо закрываемого счета затрат> * <Доля распределения>'"));
		
	КонецЕсли;
	
	Элементы.ГруппаПриемникПростыеОтборы.Видимость	= ГруппаПриемникПростыеОтборы;
	Элементы.ГруппаТаблица.Видимость 				= ГруппаТаблица;
	Элементы.ГруппаЗапрос.Видимость 				= ГруппаЗапрос;
	
	Элементы.ДекорацияОписание.Заголовок 		= СтрСоединить(Подсказка, Символы.ПС);
	Элементы.CписыватьЗатратыНСБУ.Видимость 	= Не РбРСБУ;
	Элементы.СпособЗакрытия.РежимВыбораИзСписка = РбРСБУ;//представления способов для РСБУ
	
	Элементы.СпособЗакрытия.СписокВыбора.Очистить();
	
	Если РбРСБУ Тогда
		
		Форма.Объект.CписыватьЗатратыНСБУ = Истина;//иначе неактуальна настройка
		Форма.Модифицированность = Истина;
		
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(Форма.КэшируемыеЗначения.СпособыРСБУ,
					Элементы.СпособЗакрытия.СписокВыбора);
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьКомпоновщик(ТребуетсяПодготовка = Неопределено)
	
	Если ТребуетсяПодготовка = Неопределено Тогда
		
		СложнаяНастройкаПриемника = ЗначениеЗаполнено(Объект.СхемаРаспределения);
		Если Не СложнаяНастройкаПриемника Тогда
			Возврат;
		КонецЕсли;
		
	ИначеЕсли Не ТребуетсяПодготовка Тогда
		Объект.СхемаРаспределения = "";
		Возврат;
	КонецЕсли;
		
	СхемаСКД = Справочники.НастройкиРаспределенияЗатратМСФО.ПолучитьМакет("ШаблонРаспределения");
	АдресСКД = ПоместитьВоВременноеХранилище(СхемаСКД, УникальныйИдентификатор);
	
	КомпоновщикПриемник.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД));
	КомпоновщикПриемник.РазвернутьАвтоПоля();
	
	Если ЗначениеЗаполнено(Объект.СхемаРаспределения) Тогда
		КомпоновщикПриемник.ЗагрузитьНастройки(ОбщегоНазначения.ЗначениеИзСтрокиXML(Объект.СхемаРаспределения));
	Иначе	
		КомпоновщикПриемник.ЗагрузитьНастройки(СхемаСКД.НастройкиПоУмолчанию);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере(ТекущийОбъект = Неопределено)
	
	КэшируемыеЗначения = Новый Структура;	
	КэшируемыеЗначения.Вставить("ИменаСубконто", Справочники.НастройкиРаспределенияЗатратМСФО.ПолучитьИменаСубконто());
	
	Для каждого ИмяСчета Из КэшируемыеЗначения.ИменаСубконто Цикл		
		Если ИмяСчета.Ключ = "БазаРаспределенияПриемника" Тогда
			
			ЗаполняемыеРеквизитыСтроки = Новый Структура("ИменаСубконто", ИмяСчета.Значение);
			Для каждого СтрокаТаб Из Объект.БазаРаспределенияПриемника Цикл
				МСФОКлиентСерверУХ.ЗаполнитьРасчетныеРеквизитыСтроки(СтрокаТаб, ЗаполняемыеРеквизитыСтроки);
			КонецЦикла;
			МСФОУХ.ДобавитьОформлениеДоступностиСубконто(ЭтотОбъект, ИмяСчета.Значение, "БазаРаспределенияПриемника", Истина);
			 
		Иначе	
			МСФОКлиентСерверУХ.ОбновитьСубконтоСчета(ЭтаФорма, ИмяСчета.Ключ, Объект);
		КонецЕсли;		
	КонецЦикла;
	
	ТекущаяИБ = Справочники.ТипыБазДанных.ТекущаяИБ;
	РбРСБУ = Справочники.РегистрыБухгалтерииБД.НайтиПоНаименованию("Хозрасчетный", Истина,, ТекущаяИБ);
	
	КэшируемыеЗначения.Вставить("РбРСБУ", 					РбРСБУ);
	КэшируемыеЗначения.Вставить("СпособыРСБУ",				Перечисления.СпособыЗакрытияСчетовЗатрат.СпособыРСБУ());
	КэшируемыеЗначения.Вставить("ПланыСчетовПоРегистрам",	МСФОВызовСервераУХ.ПланыСчетовПоРегистрам());
	ЗаполнитьПоПлануСчетов();
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоПлануСчетов()
	
	Если Не ЗначениеЗаполнено(Объект.ПланСчетовБД) Тогда
		Объект.ПланСчетовБД = МСФОВызовСервераУХ.ПланСчетовУП(Неопределено);
	КонецЕсли;
	Объект.РегистрУчета = Справочники.РегистрыБухгалтерииБД.ПолучитьПоПлануСчетовБД(Объект.ПланСчетовБД);
	
	РазделПС = Новый Массив;
	РазделПС.Добавить(ПредопределенноеЗначение("Справочник.РазделыПланаСчетов.НезавершенныеОперации"));
	РазделПС.Добавить(ПредопределенноеЗначение("Справочник.РазделыПланаСчетов.КоммерческиеАдминистративныеРасходы"));
	
	Элементы.СчетИсточник.ПараметрыВыбора = МСФОУХ.ПолучитьПараметрыВыбораСчетаБД(
			Объект.ПланСчетовБД, Ложь, Ложь, Неопределено, Неопределено, Новый ФиксированныйМассив(РазделПС));
	
	Элементы.СчетПриемник.ПараметрыВыбора = МСФОУХ.ПолучитьПараметрыВыбораСчетаБД(
			Объект.ПланСчетовБД, Ложь, Ложь, Неопределено, Неопределено, Неопределено);
	
	Элементы.БазаРаспределенияПриемникаСчет.ПараметрыВыбора = МСФОУХ.ПолучитьПараметрыВыбораСчетаБД(
			Объект.ПланСчетовБД, Ложь, Ложь, Неопределено, Неопределено, Неопределено);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСубконтоСчетаСтроки(Форма, СтрокаТаблицы)

	ТекущаяСтрока = Форма.Объект.БазаРаспределенияПриемника.НайтиПоИдентификатору(Форма.Элементы.БазаРаспределенияПриемника.ТекущаяСтрока);
	МСФОКлиентСерверУХ.ОбновитьСубконтоСчета(Форма, "Счет", ТекущаяСтрока, "БазаРаспределенияПриемника", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрУчетаПриИзменении(Элемент)
	ЗаполнитьПоПлануСчетов();
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()

	ПоляОбъекта = Новый Структура(
		"Субконто1, Субконто2, Субконто3, Подразделение, НаправлениеДеятельности",
		"Субконто1", "Субконто2", "Субконто3", "Подразделение", "НаправлениеДеятельности");
	
	Для каждого Проводка Из Объект.БазаРаспределенияПриемника Цикл
		МСФОКлиентСерверУХ.УстановитьДоступностьСубконто(Проводка.Счет, Проводка, ПоляОбъекта);
	КонецЦикла;
	
КонецПроцедуры

#Область ЗаполнениеДокумента

&НаКлиенте
Процедура Подключаемый_ЗаполнитьДокумент(РезультатВопроса = Неопределено, ДанныеЗаполнения) Экспорт
	
	Если (РезультатВопроса <> Неопределено) И (РезультатВопроса <> КодВозвратаДиалога.Да) Тогда
		Возврат;	
	КонецЕсли;
    
    ЗаполнитьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокумент(ДанныеЗаполнения)

	МСФОВызовСервераУХ.ЗаполнитьПоТаблицеЗагрузки(Объект, ДанныеЗаполнения);

	Модифицированность = Истина;
	
	ПодготовитьФормуНаСервере(Объект);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьТекстЗапроса(Текст = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт

	Если Текст = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	Объект.Запрос = Текст;
	Модифицированность = Истина;

КонецПроцедуры

#КонецОбласти

&НаСервереБезКонтекста
Функция ТекстЗапроса_БазаРаспределенияПриемника(СчетИсточник)
	
	РегистрБухгатерииБД = Справочники.РегистрыБухгалтерииБД.ПолучитьПоПлануСчетовБД(СчетИсточник.Владелец);
	Возврат Документы.РасчетСебестоимости.ТекстЗапроса_БазаРаспределенияПриемника(РегистрБухгатерииБД);

КонецФункции

&НаКлиенте
Процедура ПланСчетовБДПриИзменении(Элемент)

	ЗаполнитьПоПлануСчетов();
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти
