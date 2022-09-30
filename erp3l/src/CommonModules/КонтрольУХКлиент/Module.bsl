
#Область ПрограммныйИнтерфейс

Процедура ВыполнитьКонтрольДокументаОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды) Экспорт
	КонтрольУХКлиент.ВыполнитьИнтерактивныйКонтроль(ПараметрыВыполненияКоманды.Форма);
КонецПроцедуры

Процедура ВыполнитьИнтерактивныйКонтроль(Форма) Экспорт
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	РеквизитыЭлементы = КонтрольУХКлиентСервер.ИменаРеквизитовЭлементовКонтроля();
	
	ПараметрыКонтроля = Новый Структура;
	ПараметрыКонтроля.Вставить("УИДФормы",	Форма.УникальныйИдентификатор);
	ПараметрыКонтроля.Вставить("Результат", Форма[РеквизитыЭлементы.ИмяРеквизита]);
	
	КонтрольУХВызовСервера.ВыполнитьИнтерактивныйКонтроль(Объект, ПараметрыКонтроля);
	
	Таблица = Форма[РеквизитыЭлементы.ИмяРеквизита];
	Таблица.Очистить();
	Для Каждого Строка Из ПараметрыКонтроля.Результат Цикл
		ЗаполнитьЗначенияСвойств(Таблица.Добавить(), Строка);
	КонецЦикла;
	
	КонтрольУХКлиентСервер.ОтразитьРезультатыКонтроляНаФорме(Форма, РеквизитыЭлементы, ПараметрыКонтроля);
	
КонецПроцедуры

Процедура ПоказатьРасшифровкуКонтроля(Объект, СтрокаКонтроль) экспорт
	
	Контроль = Новый Структура("ВидКонтроля, АдресРезультата, ТребуетсяПроверка, Результат, РезультатСтрока, ВремяПроверки");
	Контроль.Вставить("Документ", Объект.Ссылка);
	
	ЗаполнитьЗначенияСвойств(Контроль, СтрокаКонтроль);
	Если Контроль.ТребуетсяПроверка = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	РасшифровкаКонтроля = КонтрольУХВызовСервера.СформироватьРасшифровкуКонтроля(Контроль);
	ТипРасшифровки = ТипЗнч(РасшифровкаКонтроля);
	Если ТипРасшифровки = Тип("Структура") Тогда
		Если РасшифровкаКонтроля.Свойство("Действие") Тогда
			Если РасшифровкаКонтроля.Действие = "ОткрытьОтчет" Тогда
				// Выполняем действие: открыть отчет
				ОткрытьФорму(РасшифровкаКонтроля.ИмяОтчета, РасшифровкаКонтроля.ПараметрыОтчета);
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ТипРасшифровки = Тип("ТабличныйДокумент") Тогда
		РасшифровкаКонтроля.ОтображатьСетку = Ложь;
		РасшифровкаКонтроля.ТолькоПросмотр = Истина;
		РасшифровкаКонтроля.ОтображатьЗаголовки = Ложь;
		
		ТекстСообщения = СтрШаблон(НСтр("ru = '%1 документа %2'"), СтрокаКонтроль.ВидКонтроля, Объект.Ссылка);
		
		РасшифровкаКонтроля.Показать(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

