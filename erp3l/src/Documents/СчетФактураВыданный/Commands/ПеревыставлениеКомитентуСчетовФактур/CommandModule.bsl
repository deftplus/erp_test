#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	//++ Локализация
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.СчетФактураВыданный.Команда.ПеревыставлениеКомитентуСчетовФактур");
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ОтображатьСтраницуКОформлению", Истина);

	ОткрытьФорму("Документ.СчетФактураВыданный.Форма.ФормаРабочееМестоДляОформленияСчетовФактурКомитенту", ПараметрыФормы	
		,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
	//-- Локализация
КонецПроцедуры

#КонецОбласти

