#Область ПрограммныйИнтерфейс

// Получает список версий документа из сервиса EDI
// 
// Параметры:
// 	ТаблицаВерсийДокумента - см. РаботаСВерсиямиEDIСервер.НовыйТаблицаВерсий 
// 	Организация            - ОпределяемыйТип.ОрганизацияEDI       - организация документа
// 	ТипДокумента           - ПеречислениеСсылка.ТипыДокументовEDI - тип документа сервиса
// 	Документ               - Строка                               - идентификатор документа сервиса
Процедура ПриЗаполненииВерсийДокумента(ТаблицаВерсийДокумента, Организация, ТипДокумента, Документ) Экспорт
	
	ТребуетсяЗагружатьДанные = Истина;
	ПоложениеКурсора         = Неопределено;
	
	Пока ТребуетсяЗагружатьДанные Цикл
		
		Страница = ПолучитьСтраницуВерсийДокумента(Организация, ТипДокумента, Документ, ПоложениеКурсора);
		
		Если Страница.Ошибка Тогда
			Прервать;
		КонецЕсли;
		
		Для каждого СтрокаВерсии Из Страница.Данные.Список Цикл
			
			Если ПустаяСтрока(СтрокаВерсии.ИдентификаторВерсии) Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = ТаблицаВерсийДокумента.Добавить();
			
			НоваяСтрока.Дата                = СтрокаВерсии.ДатаСтатуса;
			НоваяСтрока.ИдентификаторВерсии = СтрокаВерсии.ИдентификаторВерсии;
			
			Если НоваяСтрока.ИдентификаторВерсии = РаботаСВерсиямиEDIСервер.ИдентификаторТекущейРевизииСервиса() Тогда
				НоваяСтрока.Состояние       = РаботаСВерсиямиEDIСервер.ПредставлениеСостоянияТекущаяРевизия();
			Иначе
				НоваяСтрока.Состояние       = СтрШаблон("%1, %2", СтрокаВерсии.Действие, СтрокаВерсии.Статус);
			КонецЕсли;
			
			Если СтрокаВерсии.СторонаВыполнившаяДействие = Перечисления.СтороныУчастникиСервисаEDI.Поставщик
				И ТипДокумента = Перечисления.ТипыДокументовEDI.ЗаказПоставщику Тогда
				НоваяСтрока.ПредставлениеАвтора = НСтр("ru = 'Поставщик';
														|en = 'Supplier'");
			ИначеЕсли СтрокаВерсии.СторонаВыполнившаяДействие = Перечисления.СтороныУчастникиСервисаEDI.Покупатель
				И ТипДокумента = Перечисления.ТипыДокументовEDI.ЗаказКлиента Тогда
				НоваяСтрока.ПредставлениеАвтора = НСтр("ru = 'Покупатель';
														|en = 'Customer'");
			Иначе
				НоваяСтрока.ПредставлениеАвтора = НСтр("ru = 'Мы';
														|en = 'We'");
			КонецЕсли;
			
			НоваяСтрока.ПредставлениеВерсии = СтрокаВерсии.ПредставлениеВерсии;
			
		КонецЦикла;
		
		ПоложениеКурсора = Страница.Данные.Страницы.СледующаяСтраница;
		
		Если Не ЗначениеЗаполнено(ПоложениеКурсора) Тогда
			ТребуетсяЗагружатьДанные = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтраницуВерсийДокумента(Организация, ТипДокумента, Документ, ПоложениеКурсора)
	
	Если ТипДокумента = Перечисления.ТипыДокументовEDI.ЗаказПоставщику Тогда
		
		ПараметрыЗапроса = ИнтеграцияССервисомEDIСлужебный.НовыйПараметрыПолученияПротоколаИзмененияЗаказаПоставщику();
		
		ПараметрыЗапроса.Организация           = Организация;
		ПараметрыЗапроса.ИдентификаторВСервисе = Документ;
		
		Если Не ПоложениеКурсора = Неопределено Тогда
			ПараметрыЗапроса.ПоложениеКурсора = ПоложениеКурсора;
		КонецЕсли;
		
		ОтветСервиса = ИнтеграцияССервисомEDIСлужебный.ПротоколИзмененийЗаказаПоставщику(ПараметрыЗапроса);
		
	ИначеЕсли ТипДокумента = Перечисления.ТипыДокументовEDI.ЗаказКлиента Тогда
		
		ПараметрыЗапроса = ИнтеграцияССервисомEDIСлужебный.НовыйПараметрыПолученияПротоколаИзмененияЗаказаКлиента();
		
		ПараметрыЗапроса.Организация           = Организация;
		ПараметрыЗапроса.ИдентификаторВСервисе = Документ;
		
		Если Не ПоложениеКурсора = Неопределено Тогда
			ПараметрыЗапроса.ПоложениеКурсора = ПоложениеКурсора;
		КонецЕсли;
		
		ОтветСервиса = ИнтеграцияССервисомEDIСлужебный.ПротоколИзмененийЗаказаКлиента(ПараметрыЗапроса);
		
	КонецЕсли;
	
	Возврат ОтветСервиса;
	
КонецФункции

#КонецОбласти
