
Процедура ПередЗаписью(Отказ)
	// Заполним значения Назначение и ИмяРодителя по умолчанию.
	НетНазначения = НЕ ЗначениеЗаполнено(Назначение);
	НетИмениРодителя = НЕ ЗначениеЗаполнено(ИмяРодителя);
	Если НетНазначения И НетИмениРодителя Тогда
		Если Ссылка = Справочники.ВариантыЗаполненияШаблонов.НастройкиПроцессаВыбораПоКомиссии Тогда
			Назначение = Перечисления.НазначенияШаблонов.Справочник;
			ИмяРодителя = "НастройкиПроцессаВыбора";
		ИначеЕсли Ссылка = Справочники.ВариантыЗаполненияШаблонов.НастройкиПроцессаВыбораПоЭтапамИКритериям Тогда
			Назначение = Перечисления.НазначенияШаблонов.Справочник;
			ИмяРодителя = "НастройкиПроцессаВыбора";
		ИначеЕсли Ссылка = Справочники.ВариантыЗаполненияШаблонов.НастройкиПроцессаВыбораПолный Тогда
			Назначение = Перечисления.НазначенияШаблонов.Справочник;
			ИмяРодителя = "НастройкиПроцессаВыбора";
		Иначе
			// Неизвестный вариант. Не заполняем.
		КонецЕсли;
	Иначе
		// Реквизиты уже заполнены.
	КонецЕсли;
КонецПроцедуры
