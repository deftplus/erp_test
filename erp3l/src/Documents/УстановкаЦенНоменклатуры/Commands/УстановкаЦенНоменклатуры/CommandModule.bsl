
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОткрытьФорму(
		"Документ.УстановкаЦенНоменклатуры.Форма.ФормаДокумента",
		Новый Структура("Основание", ПараметрКоманды),
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры