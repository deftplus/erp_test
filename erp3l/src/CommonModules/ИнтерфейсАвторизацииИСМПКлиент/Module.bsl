#Область ПрограммныйИнтерфейс

// Запросить новый ключ сессии для авторизации в ИС МП.
// 
// Параметры:
// 	ПараметрыЗапроса        - (См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии).
// 	ОповещениеПриЗавершении - ОписаниеОповещения - Описание оповещения после получения результата.
Процедура ЗапроситьКлючСессии(ПараметрыЗапроса, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	РезультатЗапроса = ИнтерфейсАвторизацииИСМПВызовСервера.ЗапроситьПараметрыАвторизации(ПараметрыЗапроса);
	
	ПараметрыАвторизации = РезультатЗапроса.ПараметрыАвторизации;
	
	Если ПараметрыАвторизации = Неопределено Тогда
		Если ОповещениеПриЗавершении <> Неопределено Тогда
			ВозвращаемоеЗначение = Новый Соответствие;
			ВозвращаемоеЗначение.Вставить(ПараметрыЗапроса.Организация, РезультатЗапроса.ТекстОшибки);
			ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ВозвращаемоеЗначение);
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатЗапроса.ТекстОшибки);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Описание = СтрШаблон(
		НСтр("ru = 'Авторизация в %1 для %2';
			|en = 'Авторизация в %1 для %2'"),
		ПараметрыЗапроса.ПредставлениеСервиса,
		ПараметрыЗапроса.Организация);
	
	Сообщения = Новый Массив;
	Сообщения.Добавить(
		ИнтерфейсАвторизацииИСМПСлужебныйКлиент.РезультатПодписания(
			ПараметрыЗапроса,
			Описание,
			ПараметрыАвторизации));
	
	Контекст = Новый Структура;
	Контекст.Вставить("ПараметрыЗапроса",        ПараметрыЗапроса);
	Контекст.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	ИнтерфейсАвторизацииИСМПСлужебныйКлиент.Подписать(
		Сообщения,
		ПараметрыЗапроса,
		Новый ОписаниеОповещения("ПослеПодписания", ИнтерфейсАвторизацииИСМПСлужебныйКлиент, Контекст));
	
КонецПроцедуры

//Инициализировать структуру параметров запроса в ИС МОТП (ИС МП) для получения ключа сессии.
//
//Параметры:
//   Организация - ОпределяемыйТип.Организация - Организация.
//   ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид продукции (для уточнения сервиса).
//
//Возвращаемое значение:
//   (См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии).
Функция ПараметрыЗапросаКлючаСессии(Организация = Неопределено, ВидПродукции = Неопределено) Экспорт
	
	Если ИнтеграцияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукции) Тогда
		Возврат ИнтерфейсМОТПКлиентСервер.ПараметрыЗапросаКлючаСессии(Организация);
	ИначеЕсли ИнтеграцияИСКлиентСервер.ЭтоПродукцияИСМП(ВидПродукции) Тогда
		Возврат ИнтерфейсИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии(Организация);
	КонецЕсли;
	
	Возврат ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии();
	
КонецФункции

#КонецОбласти