
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура("ТипОснованияАктаОРасхождении",
		ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.ПриемкаТоваровНаХранение"));
	
	ОткрытьФорму("Документ.АктОРасхожденияхПослеПриемки.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		"ПриемкаТоваровНаХранение",
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);

КонецПроцедуры

#КонецОбласти
