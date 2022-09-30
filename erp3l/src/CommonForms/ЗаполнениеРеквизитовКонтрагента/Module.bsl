///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтрокаПоиска = Параметры.СтрокаПоиска;
	Если Не ПустаяСтрока(Параметры.Заголовок) Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор") Тогда
		МодульАдресныйКлассификатор = ОбщегоНазначения.ОбщийМодуль("АдресныйКлассификатор");
		ТаблицаРегионов = МодульАдресныйКлассификатор.СубъектыРФ();
		Элементы.Регион.СписокВыбора.Очистить();
		Для каждого СтрокаТаблицы Из ТаблицаРегионов Цикл
			Элементы.Регион.СписокВыбора.Добавить(
				Формат(СтрокаТаблицы.КодСубъектаРФ, "ЧЦ=2; ЧДЦ=; ЧВН="), 
				СтрокаТаблицы.Наименование + " " + СтрокаТаблицы.Сокращение);
		КонецЦикла;
		Элементы.Регион.СписокВыбора.СортироватьПоПредставлению();
	КонецЕсли;
	
	Элементы.Регион.СписокВыбора.Вставить(0, "", НСтр("ru = 'Все регионы';
														|en = 'All regions'"));
	Регион = "";
	
	ВыполняетсяПоиск = ЗначениеЗаполнено(СтрокаПоиска);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВыполняетсяПоиск Тогда
		ПодключитьОбработчикОжидания("НачатьПоискКонтрагентов", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Регион = Настройки["Регион"];
	Если Элементы.Регион.СписокВыбора.НайтиПоЗначению(Регион) = Неопределено Тогда
		Регион = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("НачатьПоискКонтрагентов", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РегионПриИзменении(Элемент)
	
	Если Элементы.Регион.СписокВыбора.НайтиПоЗначению(Регион) = Неопределено Тогда
		Регион = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКонтрагенты

&НаКлиенте
Процедура КонтрагентыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыполнитьВыборКонтрагента();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиКонтрагентов(Команда)
	
	НачатьПоискКонтрагентов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКонтрагента(Команда)
	
	ВыполнитьВыборКонтрагента();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоИНН(СтрокаПоиска)
	
	Результат = ЗначениеЗаполнено(СтрокаПоиска)
		И (СтрДлина(СтрокаПоиска) = 10 ИЛИ СтрДлина(СтрокаПоиска) = 12)
		И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаПоиска);
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура НачатьПоискКонтрагентов()
	
	ОтключитьОбработчикОжидания("НачатьПоискКонтрагентов");
	
	// Для того, чтобы не передавать в серверный контекст
	// заполненный список при последующих вызовах
	Контрагенты.Очистить();
	
	Если Не ПроверитьЗаполнение() Тогда
		ВыполняетсяПоиск = Ложь;
		УправлениеФормой(ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	Если ЭтоИНН(СтрокаПоиска) Тогда
		Адрес = "";
	КонецЕсли;
	
	НачатьПоискНаСервере();
	Если ДлительнаяОперация.Статус = "Выполняется" Тогда
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ДлительныеОперацииКлиент.ОжидатьЗавершение(
			ДлительнаяОперация,
			Новый ОписаниеОповещения("ПриЗавершенииЗадания", ЭтотОбъект),
			ПараметрыОжидания);
		
	Иначе
		
		// Задание завершено
		ПриЗавершенииЗадания(ДлительнаяОперация);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииЗадания(РезультатЗадания, ДополнительныеПараметры = Неопределено) Экспорт
	
	ДлительнаяОперация = РезультатЗадания;
	Результат = ПриЗавершенииЗаданияНаСервере();
	Если ЗначениеЗаполнено(Результат.ОписаниеОшибки) Тогда
		ОбработатьОшибкуПоискаКонтрагента(Результат.ОписаниеОшибки);
	ИначеЕсли Результат.Повторить Тогда
		ПодключитьОбработчикОжидания("НачатьПоискКонтрагентов", 5, Истина);
	ИначеЕсли Результат.КоличествоНайденных > 20 Тогда
		ТекущийЭлемент = Элементы.СтрокаПоиска;
		ПоказатьПредупреждение(, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Показаны первые 20 контрагентов из %1 найденных. Уточните реквизиты для поиска.';
				|en = 'The first 20 counterparties of %1 found are shown. Refine your search criteria. '"), 
			Результат.КоличествоНайденных));
	ИначеЕсли НЕ ПустаяСтрока(СтрокаПоиска) И Результат.КоличествоНайденных = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Ничего не найдено. Уточните реквизиты для поиска.';
										|en = 'No results found. Refine your search criteria.'"));
	ИначеЕсли КоличествоНайденных > 0 Тогда
		ТекущийЭлемент = Элементы.Контрагенты;
		Элементы.Контрагенты.ТекущаяСтрока = Контрагенты[0].ПолучитьИдентификатор();
	Иначе
		ТекущийЭлемент = Элементы.СтрокаПоиска;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОшибкуПоискаКонтрагента(ОписаниеОшибки)
	
	// Обработка ошибок
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		Если ОписаниеОшибки = "НеУказаныПараметрыАутентификации"
			Или ОписаниеОшибки = "НеУказанПароль" Тогда
			Если ИнтернетПоддержкаПользователейКлиент.ДоступноПодключениеИнтернетПоддержки() Тогда
				ТекстВопроса = НСтр("ru = 'Для автоматического заполнения реквизитов контрагентов
					|необходимо подключить Интернет-поддержку пользователей.
					|Подключить Интернет-поддержку?';
					|en = 'To populate counterparty details automatically, 
					|connect to Online user support. 
					|Connect now?'");
				ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержку", ЭтотОбъект);
				ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			Иначе
				ПоказатьПредупреждение(,
					НСтр("ru = 'Для автоматического заполнения реквизитов контрагентов
						|необходимо подключить Интернет-поддержку пользователей.
						|Обратитесь к администратору.';
						|en = 'To populate counterparty details automatically, 
						|connect to Online user support. 
						|Contact administrator.'"));
			КонецЕсли;
		ИначеЕсли ОписаниеОшибки = "Сервис1СКонтрагентНеПодключен" Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ИдентификаторМестаВызова", "zapolnenie_rekvizitov");
			ОткрытьФорму("ОбщаяФорма.Сервис1СКонтрагентНеПодключен", ПараметрыФормы, ЭтотОбъект);
		Иначе
			ПоказатьПредупреждение(, ОписаниеОшибки);
		КонецЕсли;
	ИначеЕсли КоличествоНайденных > Контрагенты.Количество() Тогда
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Найдено слишком много похожих контрагентов (%1). Уточните реквизиты для поиска.';
				|en = 'Too many similar counterparties (%1) are found. Specify the search attributes.'"),
			КоличествоНайденных);
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НачатьПоискНаСервере()
	
	Если ДлительнаяОперация <> Неопределено И ДлительнаяОперация.Статус = "Выполняется" Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
	КонецЕсли;
	
	ВыполняетсяПоиск = Истина;
	УправлениеФормой(ЭтотОбъект);
	
	Контрагенты.Очистить();
	
	ПоискПоИНН = ЭтоИНН(СтрокаПоиска);
	ПоискЮридическогоЛица = (ПоискПоИНН И СтрДлина(СтрокаПоиска) = 10) Или Не ПоискПоИНН;
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(ЭтотОбъект.УникальныйИдентификатор);
	
	Если ПоискПоИНН Тогда
		ПараметрыМетода = Новый Структура;
		ПараметрыМетода.Вставить("ИНН", СтрокаПоиска);
		Если ПоискЮридическогоЛица Тогда
			ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
				"РаботаСКонтрагентами.СведенияОЮридическомЛицеПоИННВФоне",
				ПараметрыМетода,
				ПараметрыВыполненияВФоне);
			ИмяМетодаФоновогоЗадания = "СведенияОЮридическомЛицеПоИНН";
		Иначе
			ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
				"РаботаСКонтрагентами.РеквизитыПредпринимателяПоИННВФоне",
				ПараметрыМетода,
				ПараметрыВыполненияВФоне);
			ИмяМетодаФоновогоЗадания = "РеквизитыПредпринимателяПоИНН";
		КонецЕсли;
	Иначе
		ПараметрыМетода = Новый Структура;
		ПараметрыМетода.Вставить("Наименование", СтрокаПоиска);
		ПараметрыМетода.Вставить("КодРегиона"  , Регион);
		ПараметрыМетода.Вставить("Адрес"       , Адрес);
		ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
				"РаботаСКонтрагентами.ЮридическиеЛицаПоНаименованиюВФоне",
				ПараметрыМетода,
				ПараметрыВыполненияВФоне);
		ИмяМетодаФоновогоЗадания = "ЮридическиеЛицаПоНаименованию";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриЗавершенииЗаданияНаСервере()
	
	Результат = Новый Структура;
	Результат.Вставить("ОписаниеОшибки");
	Результат.Вставить("КоличествоНайденных", 0);
	Результат.Вставить("Повторить"          , Ложь);
	
	Если ТипЗнч(ДлительнаяОперация) <> Тип("Структура") Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		
		РезультатЗадания = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
		Если ЗначениеЗаполнено(РезультатЗадания.ОписаниеОшибки) Тогда
			
			Результат.ОписаниеОшибки = РезультатЗадания.ОписаниеОшибки;
			
		ИначеЕсли ИмяМетодаФоновогоЗадания = "СведенияОЮридическомЛицеПоИНН" Тогда
			
			Если РезультатЗадания.ЕГРЮЛ <> Неопределено Тогда
				НоваяСтрока = Контрагенты.Добавить();
				НоваяСтрока.ИНН = РезультатЗадания.ИНН;
				Если РезультатЗадания.ЕГРЮЛ.ЮридическийАдрес <> Неопределено Тогда
					НоваяСтрока.ЮридическийАдрес = РезультатЗадания.ЕГРЮЛ.ЮридическийАдрес.Представление;
				КонецЕсли;
				НоваяСтрока.Руководитель = ПредставлениеСпискаРуководителей(РезультатЗадания.ЕГРЮЛ.Руководители);
				Результат.КоличествоНайденных = 1;
			КонецЕсли;
			
		ИначеЕсли ИмяМетодаФоновогоЗадания = "РеквизитыПредпринимателяПоИНН" Тогда
			
			НоваяСтрока = Контрагенты.Добавить();
			НоваяСтрока.ИНН = РезультатЗадания.ИНН;
			НоваяСтрока.Наименование = РезультатЗадания.Наименование;
			
			Результат.КоличествоНайденных = 1;
			
		ИначеЕсли ИмяМетодаФоновогоЗадания = "ЮридическиеЛицаПоНаименованию" Тогда
			
			Если РезультатЗадания.ОжиданиеОтвета Тогда
				Результат.Повторить = Истина;
			Иначе
				Для Каждого РеквизитыОрганизации Из РезультатЗадания.РеквизитыОрганизаций Цикл
					НоваяСтрока = Контрагенты.Добавить();
					НоваяСтрока.ИНН = РеквизитыОрганизации.ИНН;
					НоваяСтрока.Наименование = РеквизитыОрганизации.НаименованиеПолное;
					Если РеквизитыОрганизации.ЮридическийАдрес <> Неопределено Тогда
						НоваяСтрока.ЮридическийАдрес = РеквизитыОрганизации.ЮридическийАдрес.Представление;
					КонецЕсли;
					НоваяСтрока.Руководитель = ПредставлениеСпискаРуководителей(РеквизитыОрганизации.Руководители);
				КонецЦикла;
				Результат.КоличествоНайденных = РезультатЗадания.КоличествоНайденных;
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ДлительнаяОперация.Статус = "Ошибка" Тогда
		
		Результат.ОписаниеОшибки = НСтр("ru = 'Ошибка при обращении к сервису.
			|Подробнее см. в журнале регистрации.';
			|en = 'An error occurred while accessing the service.
			|For more information, see the event log.'");
		РаботаСКонтрагентами.ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при поиске контрагентов по наименованию. %1';
					|en = 'An error occurred while searching for counterparties by description. %1'"),
				ДлительнаяОперация.ПодробноеПредставлениеОшибки),
			"Контрагент");
		
	ИначеЕсли ДлительнаяОперация.Статус = "Отменено" Тогда
		
		Результат.ОписаниеОшибки = НСтр("ru = 'Задание отменено администратором.';
										|en = 'Job is canceled by the administrator.'");
		
	КонецЕсли;
	
	Если Не Результат.Повторить Тогда
		ВыполняетсяПоиск = Ложь;
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеСпискаРуководителей(Руководители)
	
	Результат = "";
	Для Каждого ТекущийРуководитель Из Руководители Цикл
		Результат = Результат + ?(ПустаяСтрока(Результат), "", ", ")
			+ ТекущийРуководитель.Представление;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьВыборКонтрагента()

	ТекДанные = Элементы.Контрагенты.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Если Контрагенты.Количество() = 0 Тогда
			ТекстПредупреждения = НСтр("ru = 'Ничего не найдено. Уточните реквизиты и нажмите ""Найти"".';
										|en = 'No results found. Refine your search criteria, and then click ""Search"".'");
			ПоказатьПредупреждение(, ТекстПредупреждения);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекДанные.ИНН) Тогда
		ТекстПредупреждения = НСтр("ru = 'Выберите контрагента, у которого указан ИНН.';
									|en = 'Select a counterparty with the specified TIN. '");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ОповеститьОВыборе(ТекДанные.ИНН);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержку(Ответ, ДопПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержкуЗавершение", ЭтотОбъект, ДопПараметры);
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОписаниеОповещения, ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержкуЗавершение(Результат, ДопПараметры) Экспорт

	Если Результат <> Неопределено Тогда
		НачатьПоискКонтрагентов();
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	ЭтоИНН = ЭтоИНН(Форма.СтрокаПоиска);
	Форма.Элементы.Регион.Доступность = НЕ ЭтоИНН;
	Форма.Элементы.Адрес.Доступность  = НЕ ЭтоИНН;
	Форма.Элементы.КнопкаВыбратьКонтрагента.Видимость = Не Форма.ВыполняетсяПоиск;
	Форма.Элементы.КнопкаВыбратьКонтрагента.Доступность = Форма.Контрагенты.Количество() > 0;
	Если Форма.ВыполняетсяПоиск Тогда
		Форма.Элементы.Страницы.ТекущаяСтраница = Форма.Элементы.СтраницаОжидание;
	Иначе
		Форма.Элементы.Страницы.ТекущаяСтраница = Форма.Элементы.СтраницаРезультат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти