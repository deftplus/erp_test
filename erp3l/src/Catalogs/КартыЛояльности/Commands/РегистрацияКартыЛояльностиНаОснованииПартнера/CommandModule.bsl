
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = Новый Структура("Режим, Партнер");
	ПараметрыОткрытия.Режим   = "РегистрацияНовойКартыЛояльности";
	ПараметрыОткрытия.Партнер = ПараметрКоманды;
	
	ОткрытьФорму("Справочник.КартыЛояльности.Форма.ПомощникРегистрации", ПараметрыОткрытия, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
