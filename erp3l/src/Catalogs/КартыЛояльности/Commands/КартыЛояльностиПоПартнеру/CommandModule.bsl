
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Отбор = Новый Структура("Партнер", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	
	ОткрытьФорму("Справочник.КартыЛояльности.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
