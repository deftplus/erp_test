

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АктОРасхождениях", ПараметрКоманды);
	ОткрытьФорму("Обработка.РаботаСАктамиРасхождений.Форма.ОформляемыеДокументы",
	             ПараметрыФормы,
	             ПараметрыВыполненияКоманды.Источник,
	             ПараметрыВыполненияКоманды.Уникальность);
	
КонецПроцедуры

#КонецОбласти
