
&НаКлиенте
Процедура ПереместитьВниз(Команда)
	
	Если ЗначениеЗаполнено(Элементы.Список.ТекущаяСтрока) Тогда
		СместитьОбъект(Элементы.Список.ТекущаяСтрока, 1);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	
	Если ЗначениеЗаполнено(Элементы.Список.ТекущаяСтрока) Тогда
		СместитьОбъект(Элементы.Список.ТекущаяСтрока, -1);
	КонецЕсли;

КонецПроцедуры


&НаСервереБезКонтекста
Процедура СместитьОбъект(Ссылка, Направление)
	
	ТекущийОбъект = Ссылка.ПолучитьОбъект();
	ТекущийОбъект.ИзменитьПорядковыйНомер(Направление);
	
КонецПроцедуры

