
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура АктивныеРасчетыПередУдалением(Элемент, Отказ)
	
	Если Элементы.АктивныеРасчеты.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	УдалитьЗаписиРасчета(Элементы.АктивныеРасчеты.ТекущиеДанные.ИдентификаторРасчета);
	
	Элементы.АктивныеРасчеты.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УдалитьЗаписиРасчета(ИдентификаторРасчета)
	
	РегистрыСведений.ВыполнениеОперацийЗакрытияМесяца.УстановитьПризнакОкончанияРасчета(ИдентификаторРасчета);
	
КонецПроцедуры

#КонецОбласти
