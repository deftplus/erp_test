
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Обработка.ДеревоРесурсныхСпецификаций.Команда.ДеревоСпецификации");
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Спецификация", ПараметрКоманды); 
	ПараметрыОткрытия.Вставить("СформироватьПриОткрытии", Истина); 
	ПараметрыОткрытия.Вставить("Заголовок", НСтр("ru = 'Дерево спецификации';
												|en = 'BOM tree'")); 
	ПараметрыОткрытия.Вставить("РежимОтображения", "Спецификация");
	
	ОткрытьФорму("Обработка.ДеревоРесурсныхСпецификаций.Форма", ПараметрыОткрытия, 
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти