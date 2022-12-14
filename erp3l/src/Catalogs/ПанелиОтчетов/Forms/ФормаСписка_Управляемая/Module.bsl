
&НаКлиенте
Процедура НастройкаОбщегоОтбора(Команда)
	
	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ПанелиОтчетов.Форма.ФормаНастройкиОтборов_Управляемая", Новый Структура("Ключ", ТД.Ссылка));
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьПанель(Команда)
	
	ТД = Элементы.Список.ТекущиеДанные;
	
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ПанелиОтчетов.Форма.ФормаНастройки_Управляемая", Новый Структура("Ключ", ТД.Ссылка));

КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьПанель(Команда)
	
	ТекДанные = Элементы.Список.ТекущаяСтрока;
	Если ТекДанные <> Неопределено Тогда
		ОткрытьФорму("Справочник.ПанелиОтчетов.Форма.ФормаЭлемента_Управляемая", Новый Структура("Ключ", ТекДанные));
	КонецЕсли;
	
КонецПроцедуры
