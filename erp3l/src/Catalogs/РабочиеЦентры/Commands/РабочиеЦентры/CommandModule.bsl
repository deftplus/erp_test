
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Отбор = Новый Структура("ВидРабочегоЦентра", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	
	ОткрытьФорму("Справочник.РабочиеЦентры.Форма.ФормаСписка", 
				ПараметрыФормы, 
				ПараметрыВыполненияКоманды.Источник, 
				ПараметрыВыполненияКоманды.Уникальность, 
				ПараметрыВыполненияКоманды.Окно, 
				ПараметрыВыполненияКоманды.НавигационнаяСсылка);
				
КонецПроцедуры

#КонецОбласти