#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Обработка.ПомощникПоУчетуНДС.Команда.ПомощникПоУчетуНДС");
	
	ОткрытьФорму("Обработка.ПомощникПоУчетуНДС.Форма.Форма",
			,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти

