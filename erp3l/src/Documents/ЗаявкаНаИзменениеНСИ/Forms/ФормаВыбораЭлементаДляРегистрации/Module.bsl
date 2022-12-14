
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ Ссылка
	|ИЗ "+СокрЛП(Параметры.ТаблицаАналитики)+" КАК Справочник
	|ГДЕ Справочник.НСИ_НеАктивный ";
	
	Если ЗначениеЗаполнено(Параметры.Владелец) Тогда
		
		Запрос.Текст=Запрос.Текст+"
		|И Справочник.Владелец=&Владелец";
		
		Запрос.УстановитьПараметр("Владелец",Параметры.Владелец);
		
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Запрос.Выполнить().Выгрузить(),"ТаблицаЭлементов");
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЭлементовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Закрыть(Элементы.ТаблицаЭлементов.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
	
	ТекДанные = Элементы.ТаблицаЭлементов.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		Закрыть(ТекДанные.Ссылка);
	Иначе
		ТекстСообщения = НСтр("ru = 'Элемент не выбран. Операция отменена.'");
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры
