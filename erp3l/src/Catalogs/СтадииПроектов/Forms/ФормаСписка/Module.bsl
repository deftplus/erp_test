&НаСервереБезКонтекста
Процедура ПереместитьНаСервере(Ссылка, Направление)
		
	Справочники.СтадииПроектов.ПереместитьСтадию(Ссылка, Направление);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьНаКлиенте(Направление)
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекДанные.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ПереместитьНаСервере(ТекДанные.Ссылка, Направление);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	ПереместитьНаКлиенте(-1);
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	ПереместитьНаКлиенте(1);
КонецПроцедуры