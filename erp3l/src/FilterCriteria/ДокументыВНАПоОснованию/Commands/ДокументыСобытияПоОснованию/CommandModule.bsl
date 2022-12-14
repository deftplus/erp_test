
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды.Количество() = 0 Тогда
		Возврат;	
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ПараметрОтборПоЗначению,Значение", ПараметрКоманды[0], ПараметрКоманды[0]);
	
	ОткрытьФорму("КритерийОтбора.ДокументыВНАПоОснованию.ФормаСписка", 
					ПараметрыФормы, 
					ПараметрыВыполненияКоманды, 
					ПараметрыВыполненияКоманды.Уникальность, 
					ПараметрыВыполненияКоманды.Окно, 
					ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
