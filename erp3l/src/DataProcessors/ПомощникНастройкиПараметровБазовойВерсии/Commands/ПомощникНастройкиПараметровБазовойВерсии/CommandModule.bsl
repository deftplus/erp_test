
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	// Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура("ЭтоЗапускИзКомандногоИнтерфейса", Истина);
	ОткрытьФорму("Обработка.ПомощникНастройкиПараметровБазовойВерсии.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ЭтотОбъект, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

#КонецОбласти

