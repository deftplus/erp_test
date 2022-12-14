
Процедура ПередЗаписью(Отказ)
	
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;

	
	Если ЗначениеЗаполнено(Бланк) И ОсновнойВариант Тогда
		
		   Запрос = Новый Запрос;
		   Запрос.Текст = "ВЫБРАТЬ
		                  |	ВариантыСводныхТаблиц.Ссылка КАК Ссылка
		                  |ИЗ
		                  |	Справочник.ВариантыСводныхТаблиц КАК ВариантыСводныхТаблиц
		                  |ГДЕ
		                  |	ВариантыСводныхТаблиц.ОсновнойВариант = ИСТИНА
		                  |	И ВариантыСводныхТаблиц.Ссылка <> &Ссылка
		                  |	И ВариантыСводныхТаблиц.Бланк = &Бланк";
		   
		   Запрос.УстановитьПараметр("Ссылка",Ссылка);
		   Запрос.УстановитьПараметр("Бланк",Бланк);

		   
		   Результат = Запрос.Выполнить();
		   Выборка = Результат.Выбрать();
		   
		   Пока Выборка.Следующий() Цикл
			   
			   ТекстСообщения = НСтр("ru = 'Для бланка  ""%Бланк%"" уже существует основной вариант настройки сводной таблицы. Операция отменена.'");
			   ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Бланк%", Строка(Бланк));
			   ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
			   
			   Отказ = Истина;
			   
		   КонецЦикла;
		   
	КонецЕсли;	
		
КонецПроцедуры
