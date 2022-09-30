#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура СформироватьТК(ДокументОснование, Отказ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	ИменаРеквизиты = "ПериодОтчета";//+Организация, Сценарий, ПланСчетовМСФО, ФункциональнаяВалюта 
	Реквизиты = МСФОУХ.РеквизитыДокумента(Запрос, ИменаРеквизиты, "ПериодСценария", Отказ);
    
	РеквизитыКорректировки = Новый Структура("ДействиеВСледующемПериоде",	Перечисления.ДействияКорректировкиВСледующемПериоде.СтандартныйАлгоритмПовтора);
	
	РеквизитыТК = Новый Структура;
		
	РеквизитыТК.Вставить("Организация", 	Реквизиты.Организация);
	РеквизитыТК.Вставить("Сценарий", 		Реквизиты.Сценарий);
	РеквизитыТК.Вставить("ПериодСценария", 	Реквизиты.ПериодОтчета);
	
	РеквизитыТК.Вставить("Ссылка", 			ДокументОснование);
	РеквизитыТК.Вставить("Период",			ДокументОснование.Дата);
	РеквизитыТК.Вставить("ВидОперации", 	Справочники.ВидыОпераций.НачислениеОперацийПриУрегулировании);
	
	РеквизитыТК.Вставить("ФункциональнаяВалюта",		Реквизиты.ФункциональнаяВалюта);
	РеквизитыТК.Вставить("ПланСчетовМСФО",				Реквизиты.ПланСчетовМСФО);		
	РеквизитыТК.Вставить("ФормироватьПроводкиМСФО",		Реквизиты.ФормироватьПроводкиМСФО);
	РеквизитыТК.Вставить("РеквизитыКорректировки",		РеквизитыКорректировки);
	
	ТрансформационныеКорректировкиУХ.СформироватьКорректировку(РеквизитыТК, Отказ, ДокументОснование.Проводки.Выгрузить());

КонецПроцедуры
	
#КонецЕсли