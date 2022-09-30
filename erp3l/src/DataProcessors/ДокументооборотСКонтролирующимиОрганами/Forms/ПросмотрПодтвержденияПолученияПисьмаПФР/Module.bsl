&НаСервере
Перем КонтекстЭДОСервер Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// инициализируем контекст ЭДО - модуль обработки
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	Заголовок = "Подтверждение получения " + Параметры.ИмяФайла;
	
	// считываем текст из файла уведомления
	Попытка
		ПутьКФайлу = ПолучитьИмяВременногоФайла();
		ПолучитьИзВременногоХранилища(Параметры.ПодтверждениеПолучения).Записать(ПутьКФайлу);
		ЧтениеТекста = Новый ЧтениеТекста;
		КонтекстЭДОСервер.ЧтениеТекстаОткрытьНаСервере(ЧтениеТекста, ПутьКФайлу);
		СтрокаXML = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();
		ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ПутьКФайлу); // xml-файл
	Исключение
		Отказ = Истина;
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка чтения содержимого подтверждения из файла: %1';
				|en = 'An error occurred while reading confirmation content from file: %1'"), Символы.ПС + Символы.ПС + ИнформацияОбОшибке().Описание);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецПопытки;
	
	// загружаем XML из строки в дерево
	ДеревоXML = КонтекстЭДОСервер.ЗагрузитьСтрокуXMLВДеревоЗначений(СтрокаXML);
	Если ДеревоXML = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// определяем дату-время получения
	УзлыДатаВремяПолучения = ДеревоXML.Строки.НайтиСтроки(Новый Структура("Имя, Тип", "датаВремяПолучения", "Э"), Истина);
	Если УзлыДатаВремяПолучения.Количество() = 0 Тогда
		ДатаВремяПолучения = "";
	Иначе
		ДатаВремяПолучения = Формат(ДатаВремяИзСтрокиXML(УзлыДатаВремяПолучения[0].Значение), "ДЛФ=DDT; ДП=-");
	КонецЕсли;
	
	ЦиклОбмена = Параметры.ЦиклОбмена;
	ФорматДокументооборота = Параметры.ЦиклОбмена.ФорматДокументооборота;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПечатьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	РезультатНастройки = Новый Структура("ПодтверждениеПолученияПисьмаПФР, ФорматДокументооборота", Истина, ФорматДокументооборота);
	КонтекстЭДОКлиент.СформироватьИПоказатьПечатныеДокументы(ЦиклОбмена, РезультатНастройки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДатаВремяИзСтрокиXML(ЗначениеСтр)
	
	Попытка
		Возврат XMLЗначение(Тип("Дата"), ЗначениеСтр);
	Исключение
		Возврат '00010101';
	КонецПопытки;
	
КонецФункции

#КонецОбласти