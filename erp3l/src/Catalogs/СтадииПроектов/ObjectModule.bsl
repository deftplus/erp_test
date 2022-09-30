Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ (ЭтоГруппа ИЛИ ЗначениеЗаполнено(Родитель)) Тогда
		ОбщегоНазначенияУХ.СообщитьОбОшибке("Стадия должна быть отнесена к группе.",Отказ,,СтатусСообщения.Важное);
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
			Порядок = Справочники.СтадииПроектов.МаксимальныйПорядокГруппы(Родитель) + 10;
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(Родитель) Тогда
		Родитель = Справочники.СтадииПроектов.ПустаяСсылка();
		
	КонецЕсли;
	
КонецПроцедуры

