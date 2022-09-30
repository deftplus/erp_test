&НаКлиенте
Процедура ОткрытьКонструкторЗапросаЗавершение(НовыйТекстЗапроса, ДополнительныеПараметры) Экспорт
	Если НовыйТекстЗапроса <> Неопределено Тогда 
		Объект.ТекстЗапроса = НовыйТекстЗапроса;
	Иначе
		// Текст запроса не задан. Не изменяем на форме.
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКонструкторЗапроса(Команда)
	Конструктор = Новый КонструкторЗапроса;
	Конструктор.Текст = Объект.ТекстЗапроса;
	ОповещениеКонструктора = Новый ОписаниеОповещения("ОткрытьКонструкторЗапросаЗавершение", ЭтотОбъект);
	Конструктор.Показать(ОповещениеКонструктора);
КонецПроцедуры
