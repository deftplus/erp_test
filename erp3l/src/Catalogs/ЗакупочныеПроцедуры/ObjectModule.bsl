#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	

#Область ОбработчикиСобытийОбъекта


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	ТипЗначенияЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ТипЗначенияЗаполнения = Тип("Структура")
			ИЛИ ТипЗначенияЗаполнения = Тип("Соответствие")
			ИЛИ ТипЗначенияЗаполнения = Тип("ФиксированнаяСтруктура")
			ИЛИ ТипЗначенияЗаполнения = Тип("ФиксированноеСоответствие")
			ИЛИ ТипЗначенияЗаполнения = Тип("ДокументСсылка.СтрокаПланаЗакупок") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		ЭтотОбъект.УстановитьНовыйКод();   
		ТекстНаименования = НСтр("ru = 'Закупочная процедура №%Код%'");
		ТекстНаименования = СтрЗаменить(ТекстНаименования, "%Код%", Строка(ЭтотОбъект.Код));
		ЭтотОбъект.Наименование = ТекстНаименования;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ВалютаДокумента) Тогда
		ВалютаДокумента = Константы.ВалютаУчетаЦентрализованныхЗакупок.Получить();
	КонецЕсли;
	Справочники.ЗакупочныеПроцедуры.УстановитьРеквизитыДляЕдинственногоПоставщика(
		ЭтотОбъект);
	#Область ШаблоныЗаполнения
	// Заполнение по шаблону.
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ШаблоныЗаполнения") Тогда
		УправлениеШаблонамиЗаполненияУХ.ЗаполнитьИзШаблона(ДанныеЗаполнения, ЭтотОбъект);
	КонецЕсли;
	#КонецОбласти
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ПроверитьСообщитьЗаполненыКонтрагентыУчастникиЗакрытойЗакупки(Отказ);	
	МассивНепроверяемыхРеквизитов = Новый Массив();	
	Если Справочники.ЗакупочныеПроцедуры.ЭтоФЗ223(ЭтотОбъект) Тогда
		ПроверяемыеРеквизиты.Добавить("ПорядокФормированияЦеныДоговора");
	КонецЕсли;
	Если НЕ СовместнаяЗакупка Тогда
		ПроверяемыеРеквизиты.Добавить("ОрганизацияДляЗаключенияДоговора");
	КонецЕсли;
	Если Перечисления.СпособыВыбораПоставщика.ЭтоАукцион(СпособВыбораПоставщика) Тогда
		ПроверяемыеРеквизиты.Добавить("ВнешняяСистемаДляПроведенияАукциона");
	КонецЕсли;
	Если НеУчитыватьПриРасчетеДолиЗакупокУСМП Тогда
		ПроверяемыеРеквизиты.Добавить("КатегорияЗакупкиДляИсключенияИзГОЗ");
	КонецЕсли;
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	ПроверитьСовпадениеКритериевЛотов(Отказ);
	// Проверим установку флага Электронная закупка.
	СпособВЭлектроннойФорме = ЦентрализованныеЗакупкиКлиентСерверУХ.ЭтоСпособВЭлектроннойФорме(СпособВыбораПоставщика);
	Если ((СпособВЭлектроннойФорме) И (НЕ ВЭлектроннойФорме)) Тогда
		ТекстСообщения = НСтр("ru = 'Для способа закупки ""%СпособЗакупки%"" обязательно проведение торгов в электронной форме. Запись отменена.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СпособЗакупки%", Строка(СпособВыбораПоставщика));
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		Отказ = Истина;
	Иначе
		// Проверка пройдена успешно.
	КонецЕсли;
	
	Если ВЭлектроннойФорме Тогда
		ПроверяемыеРеквизиты.Добавить("СпособСозданияДоговора");
	КонецЕсли;
	
	//Проверка соглашения
	Если ЗначениеЗаполнено(Соглашение) Тогда
		ПроверкаСоглашения(Отказ);
	КонецЕсли;
	//Проверка соглашения

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Ответственный = Пользователи.ТекущийПользователь();
	УИД_ЕИС = "";
	РегистрационныйНомер = 0;
	ПриказОНазначенииЗакупочнойКомиссии = Неопределено;
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ЦентрализованныеЗакупкиУХ.ОбъектУтвержден(Ссылка) Тогда
		ЗаписатьРегистрСведенийУчастникиЗакрытыхЗакупок();
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Если (Этотобъект.ПометкаУдаления) И (НЕ Ссылка.ПометкаУдаления) Тогда
		// Пометим на удаление подчинённое меропритие при установке пометки
		// удаления на эту закупочную процедуру.
		ПометитьНаУдалениеПодчиненноеМероприятие(Отказ);
	КонецЕсли; 
	// Обновление способа публикации в зависимости от флага электронной закупки.
	СпособЗаполнен = ЗначениеЗаполнено(СпособПубликации);
	ЭтоСпособНеЭлектронно = (СпособПубликации = Перечисления.СпособПубликацииЗакупки.Неэлектронно);
	ЭтоСпособЭлектронно = (СпособПубликации = Перечисления.СпособПубликацииЗакупки.НаЭТП ИЛИ СпособПубликации = Перечисления.СпособПубликацииЗакупки.ПоЭлектроннойПочте);
	Если (ВЭлектроннойФорме) И (ЭтоСпособНеЭлектронно ИЛИ НЕ СпособЗаполнен) Тогда
		СпособПубликации = Перечисления.СпособПубликацииЗакупки.НаЭТП;
	ИначеЕсли (НЕ ВЭлектроннойФорме) И ((НЕ ЭтоСпособЭлектронно) ИЛИ (НЕ СпособЗаполнен)) Тогда
		СпособПубликации = Перечисления.СпособПубликацииЗакупки.Неэлектронно;
	Иначе
		// Значение флага установлено корректно.
	КонецЕсли;
	ПроверитьНаличиеМероприятияУтвержденнойЗакупки(Отказ);	
КонецПроцедуры


#КонецОбласти


#Область ВнешнийПрограмныйИнтерфейс


Процедура ЗаполнитьТребованияПоставщиковДокументов() Экспорт
	ТребуетсяКвалификационныйОтбор =
			ПроверитьТребуетсяКвалификационныйОтбор();
	ЗаполнитьТребованияКПоставщикам();
	ЗаполнитьТребованияКДокументамПоТребованиямКПоставщикам();
КонецПроцедуры

// Установить данные квалификации поставщиков по лотам.
//
Процедура ЗаполнитьТребованияКПоставщикам() Экспорт
	Если ТребуетсяКвалификационныйОтбор Тогда
		// Добавление общих требований.
		НоваяДатаКвалификационногоОтбора = 
			Справочники.ЗакупочныеПроцедуры.ДатаПроверкиКвалификационногоОтбора(
				ЭтотОбъект);
		ТаблицаОбщихТребований = АккредитацияПоставщиковУХ.ПолучитьОбщиеТребования(
			НоваяДатаКвалификационногоОтбора, ОрганизаторЗакупки);
		ТребованияКПоставщикам.Загрузить(ТаблицаОбщихТребований);
		// Добавление требований из лотов.
		ДобавитьТребованияКПоставщикамИзЛотов();
		// Добавление требований из запросов на проведение закупки.
		ДобавитьТребованияКПоставщикамИзЗапросовНаПроведениеЗакупки();
	Иначе
		ТребованияКПоставщикам.Очистить();
	КонецЕсли;
КонецПроцедуры


#КонецОбласти


#Область ВнутреннийПрограмныйИнтерфейс


// Проверить, нужен ли  квалификационный отбор по лотам закупки.
//
Функция ПроверитьТребуетсяКвалификационныйОтбор()
	мЛоты = Справочники.ЗакупочныеПроцедуры.ПолучитьЛотыЗакупочнойПроцедуры(
		Ссылка,
		Истина);
	ДатаПроверки =
		Справочники.ЗакупочныеПроцедуры.ДатаПроверкиКвалификационногоОтбора(
			ЭтотОбъект);
	Для Каждого Лот Из мЛоты Цикл
		Если Справочники.ЗакупочныеПроцедуры.ПроверитьТребуетсяКвалификационныйОтборПоЛоту(
				Лот,
				ДатаПроверки) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
КонецФункции

Процедура ДобавитьТребованияКПоставщикамИзЛотов()
	Если ТребуетсяКвалификационныйОтбор Тогда
		ТребованияПоНоменклатуре = 
			АккредитацияПоставщиковУХ.ПолучитьТребованияПоНоменклатуре(
				ЭтотОбъект);
		ТребованияКПоставщикам.Загрузить( 
			АккредитацияПоставщиковУХ.ОбъединитьТребованияКПоставщикам(
				ТребованияКПоставщикам.Выгрузить(),
				ТребованияПоНоменклатуре));
	КонецЕсли;
КонецПроцедуры

// Возвращает таблицу значений, содержащую требования к поставщикам, описанных
// в связанных с закупочной процедурой ЗакупочнаяПроцедураВход запросов
// на проведение закупки.
Функция ПолучитьТребованияКПоставщикамИзЗапросовНаПроведениеЗакупки(
												ЗакупочнаяПроцедураВход)
	РезультатФункции = Новый ТаблицаЗначений;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Лоты.Ссылка КАК Ссылка,
		|	Лоты.Владелец КАК Владелец,
		|	Лоты.СтрокаПланаЗакупок КАК СтрокаПланаЗакупок
		|ПОМЕСТИТЬ ВТ_СтрокиПланаЗакупок
		|ИЗ
		|	Справочник.Лоты КАК Лоты
		|ГДЕ
		|	НЕ Лоты.ПометкаУдаления
		|	И Лоты.Владелец = &ЗакупочнаяПроцедура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ЗапросНаПроведениеЗакупкиТребованияКПоставщикам.ТребованиеКПоставщику КАК ТребованиеКПоставщику,
		|	ЗапросНаПроведениеЗакупкиТребованияКПоставщикам.Критерий КАК Критерий,
		|	ЗапросНаПроведениеЗакупкиТребованияКПоставщикам.ТребованиеКДокументу КАК ТребованиеКДокументу,
		|	ЗапросНаПроведениеЗакупкиТребованияКПоставщикам.Ссылка КАК Ссылка,
		|	ВТ_СтрокиПланаЗакупок.СтрокаПланаЗакупок КАК СтрокаПланаЗакупок
		|ИЗ
		|	ВТ_СтрокиПланаЗакупок КАК ВТ_СтрокиПланаЗакупок
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОбоснованиеТребованийКЗакупочнойПроцедуре.ТребованияКПоставщикам КАК ЗапросНаПроведениеЗакупкиТребованияКПоставщикам
		|		ПО ВТ_СтрокиПланаЗакупок.СтрокаПланаЗакупок = ЗапросНаПроведениеЗакупкиТребованияКПоставщикам.Ссылка.ДокументОснование
		|ГДЕ
		|	НЕ ЗапросНаПроведениеЗакупкиТребованияКПоставщикам.Ссылка.ПометкаУдаления
		|	И ЗапросНаПроведениеЗакупкиТребованияКПоставщикам.Ссылка.Проведен";
	Запрос.УстановитьПараметр("ЗакупочнаяПроцедура", ЗакупочнаяПроцедураВход);
	РезультатЗапроса = Запрос.Выполнить();
	РезультатФункции = РезультатЗапроса.Выгрузить();
	Возврат РезультатФункции;
КонецФункции		// ПолучитьТребованияКПоставщикамИзЗапросовНаПроведениеЗакупки()

// Добавляет в текущую закупку требования к поставщикам из связанных запросов
// на проведение закупки.
Процедура ДобавитьТребованияКПоставщикамИзЗапросовНаПроведениеЗакупки()
	// Получим таблицу требований из запросов на проведение закупки.
	НоваяТаблицаТребований = ПолучитьТребованияКПоставщикамИзЗапросовНаПроведениеЗакупки(Ссылка);
	// Объединим с существующими требованиями.
	НоваяТаблицаТребований.Колонки.Добавить("ИзШаблона", ОбщегоНазначенияУХ.ПолучитьОписаниеТиповБулево());
	НоваяТаблицаТребований.Колонки.Добавить("ТребованиеАккредитации", ОбщегоНазначенияУХ.ПолучитьОписаниеТиповБулево());
	НоваяТаблицаТребований.ЗаполнитьЗначения(Ложь, "ИзШаблона, ТребованиеАккредитации");
	ВыгрузкаСуществующихТребований = ТребованияКПоставщикам.Выгрузить();
	ОбъединеннаяТаблица = АккредитацияПоставщиковУХ.ОбъединитьТребованияКПоставщикам(НоваяТаблицаТребований, ВыгрузкаСуществующихТребований);
	// Загрузим полученную таблицу.
	ТребованияКПоставщикам.Загрузить(ОбъединеннаяТаблица);
КонецПроцедуры		// ДобавитьТребованияКПоставщикамИзЗапросовНаПроведениеЗакупки()

// Вызывать в транзакции!
// Устанавливает пометку на удаление для мероприятия, подчинённого текущему.
Процедура ПометитьНаУдалениеПодчиненноеМероприятие(Отказ)
	Если НЕ ТранзакцияАктивна() Тогда
		ВызватьИсключение НСтр("ru='Функция удаления данных мероприятия,"
			+ " подчиненного закупочной процедуре, вызвана вне транзакции!'");
	КонецЕсли;
	МероприятиеСсылка =
		Документы.Мероприятие.ПолучитьПоследнееМероприятиеПоКонтексту(
			Ссылка, Перечисления.ВидыМероприятий.ЗакупочнаяПроцедура);
	Если ЗначениеЗаполнено(МероприятиеСсылка)
			И НЕ МероприятиеСсылка.ПометкаУдаления Тогда
		Попытка
			ОчиститьРегистрАктуальныхСтадийМероприятия(МероприятиеСсылка);
			ПометитьМероприятиеНаУдаление(МероприятиеСсылка);
		Исключение
			СообщитьОбОшибкеУдаленияМероприятия(
				МероприятиеСсылка, ОписаниеОшибки());
			Отказ = Истина;
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры

Процедура ОчиститьРегистрАктуальныхСтадийМероприятия(МероприятиеСсылка)
	НаборЗаписей =
		РегистрыСведений.АктуальныеСтадииМероприятий.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Мероприятие.Установить(МероприятиеСсылка); 
	НаборЗаписей.Очистить();
	НаборЗаписей.Записать(); 
КонецПроцедуры
		
Процедура ПометитьМероприятиеНаУдаление(МероприятиеСсылка)
	МероприятиеОбъект = МероприятиеСсылка.ПолучитьОбъект();
	МероприятиеОбъект.ПометкаУдаления = Истина;
	МероприятиеОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
КонецПроцедуры

Процедура СообщитьОбОшибкеУдаленияМероприятия(МероприятиеСсылка, ОписаниеОшибки)
	ТекстСообщения = СтрШаблон(НСтр(
		"ru = 'При установке пометки на удаление для мероприятия ""%1"" произошла ошибка: %2. Операция отменена.'"),
		МероприятиеСсылка,
		ОписаниеОшибки);
	ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
КонецПроцедуры
				
Процедура ЗаполнитьТребованияКДокументамПоТребованиямКПоставщикам()
	Если ТребуетсяКвалификационныйОтбор Тогда
		ТребованияКСоставуДокументов.ЗагрузитьКолонку(
			ТребованияКПоставщикам.ВыгрузитьКолонку(
				"ТребованиеКДокументу"),
			"Требование");
	Иначе
		ТребованияКСоставуДокументов.Очистить();
	КонецЕсли;
КонецПроцедуры

Процедура ЗаписатьРегистрСведенийУчастникиЗакрытыхЗакупок()
	НаборЗаписей =
		РегистрыСведений.УчастникиЗакупок.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ЗакупочнаяПроцедура.Установить(Ссылка);
	Для Каждого СтрокаУчастника Из УчастникиЗакупки Цикл
		Если СтрокаУчастника.ПодтвердилУчастие Тогда
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.ЗакупочнаяПроцедура = Ссылка;
			НоваяЗапись.Участник = СтрокаУчастника.Участник;
		КонецЕсли;
	КонецЦикла;
	НаборЗаписей.Записать();
КонецПроцедуры

Процедура ПроверитьНаличиеМероприятияУтвержденнойЗакупки(Отказ)
	Если  ЦентрализованныеЗакупкиУХ.ОбъектУтвержден(Ссылка) Тогда
		Мероприятие =  Документы.Мероприятие.ПолучитьПоследнееМероприятиеПоКонтексту(Ссылка,  Перечисления.ВидыМероприятий.ЗакупочнаяПроцедура);	
		Если Не ЗначениеЗаполнено(Мероприятие) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Не создана стадия закупочной процедуры'");
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры	

// Проверяет, что среди лотов текущей закупочной процедуры совпадают все методы
// оценки поставщиков.
Процедура ПроверитьСовпадениеКритериевЛотов(Отказ)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	Лоты.Ссылка КАК Ссылка,
		|	Лоты.МетодОценкиПредложенийПоставщиков КАК МетодОценкиПредложенийПоставщиков
		|ИЗ
		|	Справочник.Лоты КАК Лоты
		|ГДЕ
		|	Лоты.Владелец = &Владелец
		|	И НЕ Лоты.ПометкаУдаления";
	Запрос.УстановитьПараметр("Владелец", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	Выгрузка = РезультатЗапроса.Выгрузить();
	МассивМетодов = Выгрузка.ВыгрузитьКолонку("МетодОценкиПредложенийПоставщиков");
	МассивМетодов = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивМетодов);
	МассивМетодов = ОбщегоНазначенияКлиентСерверУХ.УдалитьПустыеЭлементыМассива(МассивМетодов);
	Если МассивМетодов.Количество() > 1 Тогда
		ТекстСообщения = НСтр("ru = 'Среди лотов указаны разные методы оценки поставщиков. Запись отменена.'");
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		Отказ = Истина;
	Иначе
		// Проверка пройдена успешно.
	КонецЕсли;
КонецПроцедуры		// ПроверитьСовпадениеКритериевЛотов()

Процедура ПроверитьСообщитьЗаполненыКонтрагентыУчастникиЗакрытойЗакупки(Отказ)
	
	Если НЕ ЦентрализованныеЗакупкиУХ.ОбъектУтвержден(Ссылка) Тогда 
		Отказ = Ложь; 
		Возврат; 
	КонецЕсли;
	
	Структура =  Справочники.ЗакупочныеПроцедуры.УказанКонтрагентУчастникаЗакупки(ЭтотОбъект);
	Если Структура.Ответ = Истина Тогда
		Сообщение = Новый СообщениеПользователю;
		ТекстСообщения = СтрШаблон(НСтр("ru = 'В анкете участника %1 необходимо указать контрагента'"),
		Структура.Анкеты);
		Сообщение.Текст = ТекстСообщения;
		Сообщение.ПутьКДанным = "Объект.УчастникиЗакупки";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверкаСоглашения(Отказ)
	
	Если Соглашение.ЭтапыГрафикаОплаты.Количество() = 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Не заполнены этапы графика оплаты соглашения'");
		Сообщение.ПутьКДанным = "Объект.Соглашение";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	Если Не Соглашение.ИспользуютсяДоговорыКонтрагентов Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Не установлено требования указания договора в соглашении'");
		Сообщение.ПутьКДанным = "Объект.Соглашение";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	Если Соглашение.Валюта <> ВалютаДокумента Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Различается валюта закупочной процедура и валюта соглашения'");
		Сообщение.ПутьКДанным = "Объект.Соглашение";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти


#КонецЕсли
