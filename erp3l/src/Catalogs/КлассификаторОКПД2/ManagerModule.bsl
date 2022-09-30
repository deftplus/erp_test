#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает таблицу ОКПД2 с наложенным фильтром по СтрокаПоиска.
// Строка классификатора ОКПД2 включается в результат, если содержит все слова из СтрокаПоиска.
// 
// Параметры:
//  СтрокаПоиска         - Строка - Фильтр для отбора строк классификатора ОКПД2.
//  КлассификаторОКПД2   - ТаблицаЗначений - Таблица классификатора ОКПД2. Структуру см. в Справочники.КлассификаторОКПД2.ТаблицаКлассификатора().
// 
// Возвращаемое значение:
//  Таблица - Таблица классификатора ОКПД2 с наложенным отбором по СтрокаПоиска с колонками:
//    * Код          - Строка - Код из классификатора ОКПД2
//    * Наименование - Строка - Наименование из классификатора ОКПД2
//    * ИдентификаторРаздела - Число - Идентификатор раздела, к которому относится код.
//
Функция НайтиВКлассификаторе(СтрокаПоиска, КлассификаторОКПД2) Экспорт
	
	СхемаКомпоновки = Справочники.КлассификаторОКПД2.ПолучитьМакет("ОтборОКПД2");
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновки.НастройкиПоУмолчанию);
	
	Отбор = КомпоновщикНастроек.Настройки.Отбор;
	Слова = СтрРазделить(ВРег(СтрЗаменить(СтрокаПоиска, """", "")), " ", Ложь);
	Для Каждого Слово ИЗ Слова Цикл
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Отбор, "ПредставлениеПоиска", СокрЛП(Слово), ВидСравненияКомпоновкиДанных.Содержит);
	КонецЦикла;
	
	НастройкиДляКомпоновкиМакета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновки, НастройкиДляКомпоновкиМакета, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ВнешниеНаборы = Новый Структура("ТаблицаОКПД2", КлассификаторОКПД2);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборы);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	РезультатЗапроса = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Возврат РезультатЗапроса;
	
КонецФункции

// Ищет в справочнике элемент по коду и возвращает ссылку на него.
// Если такого элемента нет, то создает его и заполняет по данным классификатора
//
// Параметры:
//  КодКлассификатора	 - Строка - Код классификатора для поиска
// 
// Возвращаемое значение:
//   - СправочникСсылка.КлассификаторОКПД2Сп
//
Функция НайтиСоздатьПоКоду(КодКлассификатора) Экспорт
	
	КодКлассификатораДляПоиска = СокрЛП(КодКлассификатора);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КодКлассификатора", СокрЛП(КодКлассификатораДляПоиска));
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КлассификаторОКПД2.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КлассификаторОКПД2 КАК КлассификаторОКПД2
	|ГДЕ
	|	КлассификаторОКПД2.Код = &КодКлассификатора
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	НовыйЭлемент = Справочники.КлассификаторОКПД2.СоздатьЭлемент();
	НовыйЭлемент.Код = КодКлассификатораДляПоиска;
	
	ТаблицаКлассификатора = ТаблицаКлассификатора();
	СтрокаПоКоду = ТаблицаКлассификатора.Найти(КодКлассификатораДляПоиска, "Код");
	Если СтрокаПоКоду <> Неопределено Тогда
		НовыйЭлемент.Наименование = СтрокаПоКоду.Наименование;
		НовыйЭлемент.НаименованиеПолное = СтрокаПоКоду.Наименование;
	КонецЕсли;
	
	НовыйЭлемент.Записать();
	
	Возврат НовыйЭлемент.Ссылка;
	
КонецФункции

// Возвращает текст классификатора ОКПД2 в виде строки XML.
// 
// Возвращаемое значение:
//  Строка - Текст классификатора в формате XML.
//
Функция ТекстКлассификатора() Экспорт
	
	Возврат Справочники.КлассификаторОКПД2.ПолучитьМакет("КлассификаторОКПД2").ПолучитьТекст();
	
КонецФункции

// Возвращает таблицу ОКПД2 по группам, которые перечислены в КодыГруппДляЗагрузки.
// 
// Параметры:
//  ТекстКлассификатора  - Строка - Данные классификатора в формате XML. См. Справочники.КлассификаторОКПД2.ТекстКлассификатора().
//  КодыГруппДляЗагрузки - Соответствие - Соответствие кодов групп для загрузки. В соответствии в качестве ключей передаются коды
//                                        групп первого уровня (2 символа), которые нужно загружать. В качестве значения перечисления
//                                        передается идентификатор раздела.
//  ДобавитьДанныеПоиска - Булево - Признак, что в результирующую таблицу нужно добавить данные для поиска.
// 
// Возвращаемое значение:
//  Таблица - Таблица классификатора ОКПД2 с колонками:
//    * Код          - Строка - Код из классификатора ОКПД2.
//    * Наименование - Строка - Наименование из классификатора ОКПД2.
//    * ИдентификаторРаздела - Число - Идентификатор раздела, к которому относится код. Добавляется только в том случае, если ДобавитьДанныеПоиска = Истина.
//    * ПредставлениеПоиска - Строка - Строка для поиска в классификаторе(Код+ВРЕГ(Наименование)). Добавляется только в том случае, если ДобавитьДанныеПоиска = Истина.
//
Функция ТаблицаКлассификатора(Знач ТекстКлассификатора = Неопределено, Знач КодыГруппДляЗагрузки = Неопределено, Знач ДобавитьДанныеПоиска = Ложь) Экспорт
	
	Если ТекстКлассификатора = Неопределено Тогда
		ТекстКлассификатора = ТекстКлассификатора();
	КонецЕсли;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ТекстКлассификатора);
	
	Если Не ЧтениеXML.Прочитать() Тогда
		ВызватьИсключение НСтр("ru = 'Пустой XML';
								|en = 'XML file is empty.'");
	ИначеЕсли ЧтениеXML.Имя <> "КлассификаторОКПД2" Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка в структуре XML';
								|en = 'XML file format error.'");
	КонецЕсли;
	
	ТаблицаКлассификатора = Новый ТаблицаЗначений;
	ТаблицаКлассификатора.Колонки.Добавить("Код",                  Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(12)));
	ТаблицаКлассификатора.Колонки.Добавить("Наименование",         Новый ОписаниеТипов("Строка"));
	Если ДобавитьДанныеПоиска Тогда
		ТаблицаКлассификатора.Колонки.Добавить("ИдентификаторРаздела", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 0)));
		ТаблицаКлассификатора.Колонки.Добавить("ПредставлениеПоиска",  Новый ОписаниеТипов("Строка"));
	КонецЕсли;
	
	ЗагрузитьТаблицуКлассификатора(ЧтениеXML, ТаблицаКлассификатора, КодыГруппДляЗагрузки, ДобавитьДанныеПоиска);
	
	ЧтениеXML.Закрыть();
	
	Возврат ТаблицаКлассификатора;
	
КонецФункции

// Возвращает таблицу для конвертации ОКП в ОКПД2.
//
// Возвращаемое значение:
//	ТаблицаЗначений - Содержит колонки:
//		* КодОКП - Строка - Код ОКП.
//		* КодОКПД2 - Строка - Код ОКПД2.
//
Функция ТаблицаКонвертацииОКП_ОКПД2() Экспорт
	
	ТекстКонвертации = Справочники.КлассификаторОКПД2.ПолучитьМакет("КонвертацияОКП_ОКПД2").ПолучитьТекст();
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ТекстКонвертации);
	
	Если Не ЧтениеXML.Прочитать() Тогда
		ВызватьИсключение НСтр("ru = 'Пустой XML';
								|en = 'XML file is empty.'");
	ИначеЕсли ЧтениеXML.Имя <> "КонвертацияОКП_ОКПД2" Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка в структуре XML';
								|en = 'XML file format error.'");
	КонецЕсли;
	
	ТаблицаКонвертацииОКП_ОКПД2 = Новый ТаблицаЗначений;
	ТаблицаКонвертацииОКП_ОКПД2.Колонки.Добавить("КодОКП",   Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(6)));
	ТаблицаКонвертацииОКП_ОКПД2.Колонки.Добавить("КодОКПД2", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(12)));
	
	ЗагрузитьТаблицуКонвертацииОКП_ОКПД2(ЧтениеXML, ТаблицаКонвертацииОКП_ОКПД2);
	
	ЧтениеXML.Закрыть();
	
	Возврат ТаблицаКонвертацииОКП_ОКПД2;
	
КонецФункции

// Возвращает таблицу разделов ОКПД2.
//
// Возвращаемое значение:
//	ТаблицаЗначений - Содержит колонки:
//		* Наименование - Строка - Название раздела.
//		* КодыГрупп - Строка - Коды групп, входящих в раздел.
//
Функция ТаблицаРазделов() Экспорт
	
	ТаблицаРазделов = Новый ТаблицаЗначений;
	ТаблицаРазделов.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка"));
	ТаблицаРазделов.Колонки.Добавить("КодыГрупп",    Новый ОписаниеТипов("Строка"));
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Продукция сельского, лесного и рыбного хозяйства';
			|en = 'Products of agriculture, forestry and fishery'"),
		"01,02,03");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Полезные ископаемые';
			|en = 'Mineral resources'"),
		"05,06,07,08,09");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Пищевые продукты, напитки, табачные изделия';
			|en = 'Food, drinks, tobacco'"),
		"10,11,12");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Текстиль, одежда, изделия из кожи';
			|en = 'Textile, clothes, articles of leather'"),
		"13,14,15");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Изделия из дерева и бумаги, издательская деятельность';
			|en = 'Articles of wood and paper, publishing activity'"),
		"16,17,18");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Химические и нефтехимические продукты, стекло, керамика и др. минеральные продукты';
			|en = 'Chemical and petrochemical products, glass, ceramics and other mineral products'"),
		"19,20,21,22,23");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Изделия из металла';
			|en = 'Metalwork'"),
		"24,25");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Машины и оборудование';
			|en = 'Machines and equipment'"),
		"26,27,28,33");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Автотранспорт';
			|en = 'Vehicle'"),
		"29,30,45");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Мебель и прочие готовые изделия';
			|en = 'Furniture and other finished products'"),
		"31,32");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Электроэнергия, газ, пар, водоснабжение, рекультивация отходов';
			|en = 'Electricity, gas, steam, water supply, waste recultivation'"),
		"35,36,37,38,39");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Недвижимость и строительные работы';
			|en = 'Real estate and construction works'"),
		"41,42,43,");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Услуги по оптовой и розничной торговле';
			|en = 'Wholesale and retail sale services'"),
		"46,47");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Транспортные и складские услуги';
			|en = 'Transportation and warehouse services'"),
		"49,50,51,52,53");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Услуги общественного питания и гостиницы';
			|en = 'Foodservice and hotels'"),
		"55,56");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Услуги в области информации и связи';
			|en = 'Information and communications services'"),
		"58,59,60,61,62,63");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Финансовые, юридические, бухгалтерские, страховые и др. профессиональные услуги';
			|en = 'Financial, legal, accounting, insurance, and other professional services'"),
		"64,65,66,68,69,70,71,72,73,74,75,77,78,79,80,81,82");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Услуги государственного управления и обеспечения безопасности';
			|en = 'Public administration and security services'"),
		"84,94,99");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Социальные услуги, здравоохранение и образование, развлечения и спорт';
			|en = 'Social services, health care and education, entertainment and sport'"),
		"85,86,87,88,90,91,92,93");
	
	ДобавитьРаздел(ТаблицаРазделов,
		НСтр("ru = 'Прочие услуги';
			|en = 'Other services'"),
		"95,96,97,98");
	
	Возврат ТаблицаРазделов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьРаздел(ТаблицаРазделов, Наименование, КодыГрупп)
	
	Раздел = ТаблицаРазделов.Добавить();
	Раздел.Наименование  = Наименование;
	Раздел.КодыГрупп     = КодыГрупп;
	
КонецПроцедуры

Процедура ЗагрузитьТаблицуКлассификатора(ЧтениеXML, ТаблицаКлассификатора, КодыГруппДляЗагрузки, ЗагружатьДанныеПоиска)
	
	Пока ЧтениеXML.Прочитать() Цикл
		
		ИмяУзла = ЧтениеXML.Имя;
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			Если ИмяУзла = "КлассификаторОКПД2" Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			Если ИмяУзла = "Элемент" Тогда
				
				Код = ЧтениеXML.ПолучитьАтрибут("Код");
				КодГруппы = Лев(Код, 2);
				Если КодыГруппДляЗагрузки <> Неопределено
					И КодыГруппДляЗагрузки.Получить(КодГруппы) = Неопределено Тогда
					
					ЧтениеXML.Пропустить();
					
				Иначе
					
					ТекущаяСтрока = ТаблицаКлассификатора.Добавить();
					ТекущаяСтрока.Код = Код;
					ТекущаяСтрока.Наименование = ЧтениеXML.ПолучитьАтрибут("Наименование");
					Если ЗагружатьДанныеПоиска Тогда
						ТекущаяСтрока.ПредставлениеПоиска = ТекущаяСтрока.Код + " "
							+ ВРег(ТекущаяСтрока.Наименование);
						ИдентификаторРаздела = КодыГруппДляЗагрузки.Получить(КодГруппы);
						Если ИдентификаторРаздела <> Неопределено Тогда
							ТекущаяСтрока.ИдентификаторРаздела = ИдентификаторРаздела;
						Иначе
							ТекущаяСтрока.ИдентификаторРаздела = -1;
						КонецЕсли;
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗагрузитьТаблицуКонвертацииОКП_ОКПД2(ЧтениеXML, ТаблицаКонвертацииОКП_ОКПД2)
	
	Пока ЧтениеXML.Прочитать() Цикл
		
		ИмяУзла = ЧтениеXML.Имя;
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			Если ИмяУзла = "КонвертацияОКП_ОКПД2" Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			Если ИмяУзла = "Элемент" Тогда
				
				ТекущаяСтрока = ТаблицаКонвертацииОКП_ОКПД2.Добавить();
				ТекущаяСтрока.КодОКП   = ЧтениеXML.ПолучитьАтрибут("КодОКП");
				ТекущаяСтрока.КодОКПД2 = ЧтениеXML.ПолучитьАтрибут("КодОКПД2");
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли