
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПланСчетов = Справочники.ПланыСчетовБД.НайтиПоНаименованию("МСФО", Истина, Справочники.ПланыСчетовБД.ПустаяСсылка(), Справочники.ТипыБазДанных.ТекущаяИБ);
	
КонецПроцедуры
