#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = Новый Структура();
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ВидТарифнойСетки", ПредопределенноеЗначение("Перечисление.ВидыТарифныхСеток.Тариф"));	
	ПараметрыОткрытия.Вставить("Отбор", СтруктураОтбора);
	
	ОткрытьФорму("Документ.УтверждениеТарифнойСетки.ФормаСписка", 
		ПараметрыОткрытия, 
		ПараметрыВыполненияКоманды.Источник,
		,
		ПараметрыВыполненияКоманды.Окно);
		
КонецПроцедуры

#КонецОбласти