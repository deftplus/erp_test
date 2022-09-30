#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет планы по дефицитам для нескольких периодов
//
Процедура ЗаполнитьПланыПоДефицитуПоПериодам(Параметры, АдресХранилища) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РасчетДефицитовПлановПоЭтапам.Сценарий КАК Сценарий,
	|	РасчетДефицитовПлановПоЭтапам.ВидПлана КАК ВидПлана,
	|	РасчетДефицитовПлановПоЭтапам.ПериодПланирования КАК ПериодПланирования,
	|	КОНЕЦПЕРИОДА(РасчетДефицитовПлановПоЭтапам.ПериодПланирования, МЕСЯЦ) КАК ОкончаниеПериодаПлана
	|ИЗ
	|	РегистрСведений.РасчетДефицитовПлановПоЭтапам КАК РасчетДефицитовПлановПоЭтапам
	|ГДЕ
	|	РасчетДефицитовПлановПоЭтапам.Сценарий = &Сценарий
	|	И РасчетДефицитовПлановПоЭтапам.ВидПлана В(&ВидыПланов)
	|	И РасчетДефицитовПлановПоЭтапам.Пересчитать
	|	И РасчетДефицитовПлановПоЭтапам.ПериодПланирования МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПериодПланирования";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "МЕСЯЦ", Строка(Параметры.Периодичность));
	
	Запрос.УстановитьПараметр("Сценарий", Параметры.Сценарий);
	Запрос.УстановитьПараметр("ВидыПланов", Параметры.ВидыПланов);
	Запрос.УстановитьПараметр("НачалоПериода", Параметры.НачалоПериода);
	Запрос.УстановитьПараметр("ОкончаниеПериода", Параметры.ОкончаниеПериода);
	
	ТаблицаПересчета = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Строка Из ТаблицаПересчета Цикл
		Планирование.ЗаполнитьПланыПоДефициту(Строка.Сценарий, Строка.ВидПлана, Строка.ПериодПланирования, Строка.ОкончаниеПериодаПлана); 
	КонецЦикла;
	
КонецПроцедуры

// Заполняет планы по дефицитам для нескольких периодов
//
Процедура ЗапуститьПересчетДефицитовПоЭтапамПоВсемПериодам(Параметры, АдресХранилища) Экспорт
	
	Планирование.ЗапускВыполненияФоновогоПересчетаДефицитаПоЭтапам(Параметры.Сценарий);
	
КонецПроцедуры



// Запускает пересчет для Помощника Планирования
// 
// Параметры:
// 	Параметры - Структура - где:
// 	*Сценарий - СправочникСсылка.СценарииТоварногоПланирования
// 	*ВидПлана - СправочникСсылка.ВидыПланов
// 	*НачалоПериода - Дата
// 	*ОкончаниеПериода - Дата
// 	АдресХранилища - Строка.
Процедура ПерерасчетПомощникПланирования(Параметры, АдресХранилища) Экспорт
	
	
	Сценарий = Параметры.Сценарий;
	ВидПлана = Параметры.ВидПлана;
	НачалоПериода = Параметры.НачалоПериода;
	ОкончаниеПериода = Параметры.ОкончаниеПериода;
	
	Планирование.ЗаполнитьПланыПоДефициту(Сценарий, ВидПлана, НачалоПериода, ОкончаниеПериода);
	
КонецПроцедуры
#КонецОбласти

#КонецЕсли
