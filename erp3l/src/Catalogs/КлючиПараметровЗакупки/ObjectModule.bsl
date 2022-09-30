#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Установка значений реквизитов ЗапретИзменения_*
	ПараметрыЗакупки = ПланыВидовХарактеристик.ПараметрыЗакупки.ПолучитьТаблицуНастроекПараметровЗакупки();
	Для Каждого Параметр Из ПараметрыЗакупки Цикл
		ЭтотОбъект["ЗапретИзменения_"+Параметр.ПараметрИмя] = ПроверитьБит(ФлагиВозможностиИзменения, Параметр.ПараметрНомер-1);
	КонецЦикла;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ПередУдалением(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	УдалитьАналитикуКлюча();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Процедура УдалитьАналитикуКлюча()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	*
	|ИЗ
	|	РегистрСведений.АналитикаПараметровЗакупки КАК ДанныеРегистра
	|ГДЕ
	|	ДанныеРегистра.КлючАналитики = &Ключ
	|");
	Запрос.УстановитьПараметр("Ключ", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МенеджерЗаписи = РегистрыСведений.АналитикаПараметровЗакупки.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Удалить();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
