#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	      
Процедура ПриЗаписи(Отказ)
	
				 	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	
КонецПроцедуры

Процедура ПолучитьВыбранныеПоказатели(Строки) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	НастройкиСоставаОбластейВидовОтчетов.СтрокаОтчета КАК СтрокаОтчета 
	|ИЗ
	|	РегистрСведений.НастройкиСоставаОбластейВидовОтчетов КАК НастройкиСоставаОбластейВидовОтчетов
	|ГДЕ
	|	НастройкиСоставаОбластейВидовОтчетов.КлючОбласти = &Область";
	
	Запрос.УстановитьПараметр("Область",Ссылка);
	
	Строки.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("СтрокаОтчета"));
			
КонецПроцедуры	

Процедура ПередЗаписью(Отказ)
	
	Если ЭтоГруппа Тогда
		 Возврат;
	КонецЕсли;	
		
	Если ВключатьВсеПоказателиВидаОтчета Тогда
		
		Запрос=Новый Запрос;
		Запрос.Текст="ВЫБРАТЬ
		             |	ОбластиДанныхВидовОтчетов.Ссылка
		             |ИЗ
		             |	Справочник.ОбластиДанныхВидовОтчетов КАК ОбластиДанныхВидовОтчетов
		             |ГДЕ
		             |	ОбластиДанныхВидовОтчетов.Владелец = &Владелец
		             |	И ОбластиДанныхВидовОтчетов.Ссылка <> &Ссылка";
		
		Запрос.УстановитьПараметр("Владелец",				Владелец);
		Запрос.УстановитьПараметр("Ссылка",					Ссылка);
	
		Результат=Запрос.Выполнить().Выбрать();
		
		Если Результат.Количество()>0 Тогда
			
			СтрокаШаблона = НСтр("ru = 'Ошибка сохранения элемента: %1 Нельзя записать ракурс с признаком включения всех строк, при наличии других ракурсов!'");
			
			Если Не ПустаяСтрока(СтрокаШаблона) тогда				
				ОбщегоНазначенияУХ.СообщитьОбОшибке(СтрШаблон(СтрокаШаблона, Наименование));
			КонецЕсли;
			
			Отказ = Истина;
			
		КонецЕсли;
		
	Иначе	
		
		Запрос=Новый Запрос;
		Запрос.Текст="ВЫБРАТЬ
		             |	ОбластиДанныхВидовОтчетов.Ссылка
		             |ИЗ
		             |	Справочник.ОбластиДанныхВидовОтчетов КАК ОбластиДанныхВидовОтчетов
		             |ГДЕ
		             |	ОбластиДанныхВидовОтчетов.Владелец = &Владелец
		             |	И ОбластиДанныхВидовОтчетов.ВключатьВсеПоказателиВидаОтчета = ИСТИНА
		             |	И ОбластиДанныхВидовОтчетов.Ссылка <> &Ссылка";
		
		Запрос.УстановитьПараметр("Владелец",				Владелец);
		Запрос.УстановитьПараметр("Ссылка",					Ссылка);

		Результат=Запрос.Выполнить().Выбрать();
		
		Если Результат.Количество()>0 Тогда
			
			СтрокаШаблона = НСтр("ru = 'Ошибка сохранения элемента: %1 Нельзя записать новый элемент, при наличии  ракурса с признаком включения всех строк!'");
			
			Если Не ПустаяСтрока(СтрокаШаблона) тогда				
				ОбщегоНазначенияУХ.СообщитьОбОшибке(СтрШаблон(СтрокаШаблона, Наименование));
			КонецЕсли;
						
			Отказ = Истина;
			
		КонецЕсли;

		
	КонецЕсли;	
		
КонецПроцедуры

#КонецЕсли