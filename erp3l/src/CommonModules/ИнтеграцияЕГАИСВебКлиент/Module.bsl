#Если ВебКлиент Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Начинает формирование HTTP-запроса в УТМ на веб-клиенте.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, которая будет вызвана после формирования запроса,
//  НастройкаОбмена         - Структура          - настройка обмена с УТМ,
//  ДанныеЗапроса           - Структура          - структура данных запроса,
//  ОтображатьСообщения     - Булево             - если Истина, то пользователю будут отображены сообщения с ошибками,
//  ПредложитьУстановить    - Булево             - предлагать устанавливать и обновлять компоненту.
//
Процедура НачатьФормированиеHTTPЗапроса(ОповещениеПриЗавершении, НастройкаОбмена, ДанныеЗапроса, ОтображатьСообщения,
	ПредложитьУстановить = Истина) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	Контекст.Вставить("НастройкаОбмена"        , НастройкаОбмена);
	Контекст.Вставить("ОтображатьСообщения"    , ОтображатьСообщения);
	Контекст.Вставить("ДанныеЗапроса"          , ДанныеЗапроса);
	Контекст.Вставить("ПредложитьУстановить"   , ПредложитьУстановить);
	
	ПараметрыПодключения = ОбщегоНазначенияКлиент.ПараметрыПодключенияКомпоненты();
	ПараметрыПодключения.ПредложитьУстановить = ПредложитьУстановить;
	ПараметрыПодключения.ИдентификаторыСозданияОбъектов.Добавить("HTTPRequester");
	ПараметрыПодключения.ТекстПояснения = НСтр("ru = 'Для обмена с УТМ в веб-клиенте требуется
	                                         |внешняя компонента HTTP-запросов.';
	                                         |en = 'Для обмена с УТМ в веб-клиенте требуется
	                                         |внешняя компонента HTTP-запросов.'");
	
	ОбщегоНазначенияКлиент.ПодключитьКомпонентуИзМакета(
		Новый ОписаниеОповещения("ФормированиеHTTPЗапроса_ПослеПодключенияКомпоненты", ЭтотОбъект, Контекст),
		"HTTPЗапросыNative",
		"ОбщийМакет.КомпонентаHTTPЗапросов",
		ПараметрыПодключения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Вызывается после подключения компоненты перед формированием HTTP-запроса.
//
Процедура ФормированиеHTTPЗапроса_ПослеПодключенияКомпоненты(Результат, Контекст) Экспорт
	
	Если Результат.Подключено Тогда
		
		ОбъектКомпоненты = Результат.ПодключаемыйМодуль["HTTPRequester"];
		
		НастройкаПроксиСервера = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().НастройкиПроксиСервера;
		
		Контекст.Вставить("ОбъектКомпоненты", ОбъектКомпоненты);
		
		Если НастройкаПроксиСервера <> Неопределено И НЕ ПустаяСтрока(НастройкаПроксиСервера.Сервер) Тогда
			ОбъектКомпоненты.НачатьВызовУстановитьПараметрыПрокси(
				Новый ОписаниеОповещения("ФормированиеHTTPЗапроса_ПослеУстановкиПараметровПрокси", ЭтотОбъект, Контекст),
				"HTTP",
				НастройкаПроксиСервера.Сервер,
				НастройкаПроксиСервера.Порт,
				НастройкаПроксиСервера.Пользователь,
				НастройкаПроксиСервера.Пароль);
		Иначе
			ФормированиеHTTPЗапроса_ПослеУстановкиПараметровПрокси(Истина, Неопределено, Контекст);
		КонецЕсли;
		
	Иначе
		Если НЕ ПустаяСтрока(Результат.ОписаниеОшибки) Тогда
			ТекстОшибки = НСтр("ru = 'Ошибка при подключении компоненты HTTP-запросов:';
								|en = 'Ошибка при подключении компоненты HTTP-запросов:'");
			ТекстОшибки = ТекстОшибки + Символы.ПС + Результат.ОписаниеОшибки;
		Иначе
			ТекстОшибки = НСтр("ru = 'Операция невозможна. Требуется установка компоненты HTTP-запросов.';
								|en = 'Операция невозможна. Требуется установка компоненты HTTP-запросов.'");
		КонецЕсли;
		ИнтеграцияЕГАИСВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

// Начинает отправку HTTP-запроса через внешнюю компоненту.
//
Процедура ФормированиеHTTPЗапроса_ПослеУстановкиПараметровПрокси(РезультатВыполнения, Параметры, Контекст) Экспорт
	
	Если НЕ РезультатВыполнения Тогда
		ТекстОшибки = НСтр("ru = 'Ошибка установки настроек прокси-сервера.';
							|en = 'Ошибка установки настроек прокси-сервера.'");
		ИнтеграцияЕГАИСВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ОбъектКомпоненты = Контекст.ОбъектКомпоненты;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ФормированиеHTTPЗапроса_Завершение", ЭтотОбъект, Контекст);
	
	Заголовки = "";
	Для Каждого Заголовок Из Контекст.ДанныеЗапроса.Заголовки Цикл
		Если НЕ ПустаяСтрока(Заголовки) Тогда
			Заголовки = Заголовки + Символы.ПС;
		КонецЕсли;
		
		Заголовки = Заголовки + Заголовок.Ключ + ": " + Заголовок.Значение;
	КонецЦикла;
	
	АдресЗапроса = "http://" + Контекст.НастройкаОбмена.АдресУТМ + ":" + Формат(Контекст.НастройкаОбмена.ПортУТМ, "ЧГ=0");
	АдресЗапроса = АдресЗапроса + ?(Лев(Контекст.ДанныеЗапроса.АдресЗапроса, 1) = "/", "", "/");
	АдресЗапроса = АдресЗапроса + Контекст.ДанныеЗапроса.АдресЗапроса;
	
	Контекст.Вставить("АдресЗапроса", АдресЗапроса);
	
	Если Контекст.ДанныеЗапроса.ТипЗапроса = "GET" Тогда
		ОбъектКомпоненты.НачатьВызовExtendedGET(ОповещениеПриЗавершении, АдресЗапроса, Заголовки, Контекст.НастройкаОбмена.Таймаут, "", "");
	ИначеЕсли Контекст.ДанныеЗапроса.ТипЗапроса = "POST" Тогда
		ОбъектКомпоненты.НачатьВызовExtendedPOST(ОповещениеПриЗавершении, АдресЗапроса, Контекст.ДанныеЗапроса.ТелоЗапроса, Заголовки, Контекст.НастройкаОбмена.Таймаут, "", "");
	ИначеЕсли Контекст.ДанныеЗапроса.ТипЗапроса = "DELETE" Тогда
		ОбъектКомпоненты.НачатьВызовExtendedDELETE(ОповещениеПриЗавершении, АдресЗапроса, Заголовки, Контекст.НастройкаОбмена.Таймаут, "");
	Иначе
		ТекстОшибки = НСтр("ru = 'Неверный тип HTTP-запроса.';
							|en = 'Неверный тип HTTP-запроса.'");
		ИнтеграцияЕГАИСВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает результат выполнения HTTP-запроса.
//
Процедура ФормированиеHTTPЗапроса_Завершение(КодСостояния, Параметры, Контекст) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("КодСостояния");
	ВозвращаемоеЗначение.Вставить("Заголовки");
	ВозвращаемоеЗначение.Вставить("ТекстОтвета");
	ВозвращаемоеЗначение.Вставить("ТекстОшибки");
	
	ТекстОтвета    = "";
	ТекстОшибки    = "";
	
	Если Контекст.ДанныеЗапроса.ТипЗапроса = "GET" Тогда
		ТекстОтвета = Параметры[3];
		ТекстОшибки = Параметры[4];
	ИначеЕсли Контекст.ДанныеЗапроса.ТипЗапроса = "POST" Тогда
		ТекстОтвета = Параметры[4];
		ТекстОшибки = Параметры[5];
	ИначеЕсли Контекст.ДанныеЗапроса.ТипЗапроса = "DELETE" Тогда
		ТекстОшибки = Параметры[3];
	КонецЕсли;
	
	ВозвращаемоеЗначение.ТекстОшибки  = ТекстОшибки;
	ВозвращаемоеЗначение.КодСостояния = КодСостояния;
	ВозвращаемоеЗначение.ТекстОтвета  = ТекстОтвета;
	
	ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, ВозвращаемоеЗначение);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли