
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АккредитацияПоставщиковУХ.ПриСозданииНаСервереФормыКонтрагентаВнешнегоПоставщика(ЭтаФорма, Отказ, "Список",, "Контрагент", Истина);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры
