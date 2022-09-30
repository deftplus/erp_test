
#Область СлужебныеПроцедурыИФункции

#Область АктОРасхождениях

Процедура ЗаполнитьЗаказИСкладВСтроке(СтрокаТаблицыТовары, ДокументыОснования, ЭтоАктОРасхожденияПослеОтгрузки) Экспорт
	
	ИменаРеквизитовАкта = РасхожденияКлиентСервер.ИменаРеквизитовВЗависимостиОтТипаАкта(ЭтоАктОРасхожденияПослеОтгрузки);

	НайденныеСтроки = ДокументыОснования.НайтиСтроки(Новый Структура("Реализация", СтрокаТаблицыТовары[ИменаРеквизитовАкта.Основание]));
	Если НайденныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НайденнаяСтрока = НайденныеСтроки[0];
	
	Если Не ЗначениеЗаполнено(СтрокаТаблицыТовары[ИменаРеквизитовАкта.Заказ]) Тогда
		Если НайденнаяСтрока.ЗаказыОснования.Количество() = 1 Тогда
			СтрокаТаблицыТовары[ИменаРеквизитовАкта.Заказ] = НайденнаяСтрока.ЗаказыОснования.Получить(0).Значение;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтрокаТаблицыТовары.Склад) Тогда
		Если НайденнаяСтрока.СкладыОснования.Количество() = 1 Тогда
			СтрокаТаблицыТовары.Склад = НайденнаяСтрока.СкладыОснования.Получить(0).Значение;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтрокаТаблицыТовары.Назначение) Тогда
		СтрокаТаблицыТовары.Назначение = НайденнаяСтрока.Назначение;
	КонецЕсли;

КонецПроцедуры

// Добавляет стуркутуру действий над строкой табличной части действия, требуемые при изменении количества упаковок
// 
// Параметры:
// 	СтруктураДействий - Структура - структура выполняемых действий над строкой табличной части.
// 	Объект            - ДокументОбъект.АктОРасхожденияхПослеОтгрузки - документ, в котором изменяется количество упаковок.
Процедура ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, Объект) Экспорт
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);
	
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуРасхождения");
	Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.АктОРасхожденияхПослеОтгрузки") Тогда
		СтруктураДействий.Вставить("ПересчитатьРасхожденияПослеОтгрузки");
	Иначе
		СтруктураДействий.Вставить("ПересчитатьРасхожденияПослеПриемки");
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументОснованиеВСтроке(СтрокаТаблицыТовары, ДокументыОснования, ЭтоАктОРасхожденияПослеОтгрузки) Экспорт
	
	ИменаРеквизитовАкта = РасхожденияКлиентСервер.ИменаРеквизитовВЗависимостиОтТипаАкта(ЭтоАктОРасхожденияПослеОтгрузки);

	Если Не СтрокаТаблицыТовары[ИменаРеквизитовАкта.ЗаполненоПоОснованию] И Не ЗначениеЗаполнено(СтрокаТаблицыТовары[ИменаРеквизитовАкта.Основание]) Тогда
		Если ДокументыОснования.Количество() = 1 Тогда
			СтрокаТаблицыТовары[ИменаРеквизитовАкта.Основание] = ДокументыОснования[0].Реализация;
			УстановитьПризнакДокументОснованиеПоЗаказу(СтрокаТаблицыТовары, ДокументыОснования[0], ЭтоАктОРасхожденияПослеОтгрузки);
			ЗаполнитьЗаказИСкладВСтроке(СтрокаТаблицыТовары, ДокументыОснования, ЭтоАктОРасхожденияПослеОтгрузки);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьПризнакДокументОснованиеПоЗаказу(СтрокаТаблицыТовары, СтрокаДокументыОснования, ЭтоАктОРасхожденияПослеОтгрузки) Экспорт
	
	ИменаРеквизитовАкта = РасхожденияКлиентСервер.ИменаРеквизитовВЗависимостиОтТипаАкта(ЭтоАктОРасхожденияПослеОтгрузки);
	
	СтрокаТаблицыТовары[ИменаРеквизитовАкта.ОснованиеПоЗаказам] = (СтрокаДокументыОснования.ЗаказыОснования.Количество() > 0);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура УстановитьОтборСпискаПоКонтактномуЛицу(Форма) Экспорт

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
	                                Форма.Список, "КонтактноеЛицо", Форма.КонтактноеЛицоОтбор,
	                                ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Форма.КонтактноеЛицоОтбор));

КонецПроцедуры

// Процедура рассчитывает комиссионное вознаграждение.
//
// Параметры
//  Объект  - ДанныеФормыСтруктура - документ, для которого рассчитывается вознаграждение.
//
Процедура РассчитатьСуммуВознаграждения(Объект) Экспорт
	
	Для Каждого СтрокаТоваров Из Объект.Товары Цикл
		
		Если Объект.СпособРасчетаВознаграждения = 
			   ПредопределенноеЗначение("Перечисление.СпособыРасчетаКомиссионногоВознаграждения.ПроцентОтРазностиСуммыПродажиИСуммыКомитента") Тогда
			СтрокаТоваров.СуммаВознаграждения = (СтрокаТоваров.СуммаПродажи - СтрокаТоваров.СуммаСНДС) * Объект.ПроцентВознаграждения / 100;
			
		ИначеЕсли Объект.СпособРасчетаВознаграждения = 
			   ПредопределенноеЗначение("Перечисление.СпособыРасчетаКомиссионногоВознаграждения.ПроцентОтСуммыПродажи") Тогда
			СтрокаТоваров.СуммаВознаграждения = СтрокаТоваров.СуммаПродажи * Объект.ПроцентВознаграждения / 100;
			
		Иначе
			СтрокаТоваров.СуммаВознаграждения = 0;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Объект.СуммаВознаграждения = Объект.Товары.Итог("СуммаВознаграждения");
	
	СуммаНДС = ЦенообразованиеКлиентСервер.РассчитатьСуммуНДС(Объект.СуммаВознаграждения, Объект.СтавкаНДСВознаграждения);
	Объект.СуммаНДСВознаграждения = Окр(СуммаНДС, 2, РежимОкругления.Окр15как20);
	
КонецПроцедуры

// Получает хозяйственную операцию договора по хозяйственной операции заявки на возврат.
//
// Параметры
//  ХозяйственнаяОперация  - ПеречислениеСсылка.ХозяйственныеОперации - операция заявки на возврат.
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ХозяйственныеОперации - операция договора.
//
Функция ХозяйственнаяОперацияДоговора(ХозяйственнаяОперация) Экспорт
	
	Если ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОтРозничногоПокупателя") Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияВРозницу");
	ИначеЕсли ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратТоваровОтКлиента") Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияКлиенту");
	ИначеЕсли ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОтКомиссионера") Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию");
	ИначеЕсли ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОтХранителя") Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи");
	Иначе
		Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПустаяСсылка");
	КонецЕсли;
	
КонецФункции

// Получает хозяйственную операцию соглашения по хозяйственной операции документа заявка на возврат и возврат товаров от клиента.
//
// Параметры
//  ХозяйственнаяОперация  - ПеречислениеСсылка.ХозяйственныеОперации - хозяйственная операция документа.
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ХозяйственныеОперации - операция соглашения.
//
Функция ХозяйственнаяОперацияСоглашения(ХозяйственнаяОперация) Экспорт
	
	Если ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОтРозничногоПокупателя") Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияКлиенту");
	ИначеЕсли ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратТоваровОтКлиента") Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияКлиенту");
	ИначеЕсли ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОтКомиссионера") Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию");
	ИначеЕсли ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОтХранителя") Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи");
	Иначе
		Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПустаяСсылка");
	КонецЕсли;
	
КонецФункции

// Добавляет общие действия для обычной формы и формы самообслуживания документа Заявка на возврат товаров от клиента.
//
// Параметры
//  СтруктураДействий  - Структура - структура, в которую добавляются действия
//  Объект  - ДокументОбъект.ЗаявкаНаВозвратТоваровОтКлиента - документ, в котором выполняются действия.
//
Процедура ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковокВозвращаемыеТоварыОбщее(СтруктураДействий, Объект) Экспорт
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму");
	
КонецПроцедуры

// Добавляет действия при изменении количества упаковок для обычной формы и формы самообслуживания документа Отчет комиссионера.
//
// Параметры
//  СтруктураДействий  - Структура - структура, в которую добавляются действия
//  Объект  - ДокументОбъект.ОтчетКомиссионера - документ, в котором выполняются действия.
//
Процедура ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковокОтчетКомиссионера(СтруктураДействий, Объект) Экспорт
	
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС",  ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект));
	СтруктураДействий.Вставить("ПересчитатьСумму");
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", Новый Структура("ЦенаВключаетНДС", Объект.ЦенаВключаетНДС));
	СтруктураДействий.Вставить("ПересчитатьСуммуПродажи");
	СтруктураДействий.Вставить("ПересчитатьСуммуПродажиНДС");
	СтруктураДействий.Вставить("ОчиститьСуммуВознаграждения");
	
КонецПроцедуры



// Описание
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма, в которой выполняется действия
// 	ЮрФизЛицо - ПеречислениеСсылка.ЮрФизЛицо - 
//
Процедура УправлениеСтраницамиЮрФизЛицоПриИзменении(Форма, ЮрФизЛицо) Экспорт
	
	Если ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо") Тогда
		Форма.Элементы.СтраницыНаименованиеПолноеКомпанияЧастноеЛицо.ТекущаяСтраница = Форма.Элементы.СтраницаНаименованиеПолноеЧастноеЛицо;
	Иначе
		Форма.Элементы.СтраницыНаименованиеПолноеКомпанияЧастноеЛицо.ТекущаяСтраница = Форма.Элементы.СтраницаНаименованиеПолноеКомпания;
	КонецЕсли;
	
	ЭлементФормыПол          = Форма.Элементы.Пол; // ПолеФормы
	ЭлементФормыДатаРождения = Форма.Элементы.ДатаРождения; // ПолеФормы 
	
	ЭлементФормыПол.Доступность          = (ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо"));
	ЭлементФормыДатаРождения.Доступность = (ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо"));

КонецПроцедуры

#КонецОбласти

#КонецОбласти
