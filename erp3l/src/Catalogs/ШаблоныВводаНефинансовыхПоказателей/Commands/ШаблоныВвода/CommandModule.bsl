
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("Показатель", ПараметрКоманды);
	ОткрытьФорму("Справочник.ШаблоныВводаНефинансовыхПоказателей.Форма.ФормаШаблоныНефинансовогоПоказателя", 
						ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, 
						ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, 
						ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры
