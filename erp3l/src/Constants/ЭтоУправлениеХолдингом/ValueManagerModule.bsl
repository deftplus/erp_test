
Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	// Для конфигурации БМ изменим константу УчетПоСценариям.
	Попытка
		Если ЭтотОбъект.Значение = Ложь Тогда
			УчетПоСценариям = Константы.УчетПоСценариям.Получить();
			Если УчетПоСценариям Тогда
				МенеджерКонстанты = Константы.УчетПоСценариям.СоздатьМенеджерЗначения();
				МенеджерКонстанты.Значение = Ложь;
				МенеджерКонстанты.Записать();
			Иначе
				// Учет по сценариям отключен. Не Изменяем.
			КонецЕсли;
		Иначе
			// Не изменяем значение константы УчетПоСценариям.
		КонецЕсли;
	Исключение
		ТекстСообщения = НСтр("ru = 'Возникли ошибки при установке константы ЭтоУправлениеХолдингом: %ОписаниеОшибки%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки());
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
	КонецПопытки;
КонецПроцедуры
