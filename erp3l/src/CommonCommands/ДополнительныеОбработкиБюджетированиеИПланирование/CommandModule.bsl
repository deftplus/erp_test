&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ИмяПодсистемыПланирования = ПланированиеКлиентСервер.ИмяПодсистемыПланирования();
	
	ДополнительныеОтчетыИОбработкиКлиент.ОткрытьФормуКомандДополнительныхОтчетовИОбработок(
			ПараметрКоманды,
			ПараметрыВыполненияКоманды,
			ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка(),
			ИмяПодсистемыПланирования);
			
КонецПроцедуры