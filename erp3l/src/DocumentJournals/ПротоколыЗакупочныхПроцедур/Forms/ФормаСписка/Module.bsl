
#Область ОбработкаОсновныхСобытийФормы
#КонецОбласти


#Область ОбработкаСобытийЭлементовФормы


&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	УстановитьДоступностьКнопокДляТекущейСтроки();
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыНаКлиенте


&НаКлиенте
Процедура УстановитьДоступностьКнопокДляТекущейСтроки()
	ТекДанные = Элементы.Список.ТекущиеДанные;
	флЭтоУспешныйПротоколВыбораПобедителей = Ложь;
	Если ТекДанные <> Неопределено Тогда
		ЭтоПротокВыбораПобедителей = (ТекДанные.Тип = Тип("ДокументСсылка.ПротоколВыбораПобедителей"));
		Если (ЭтоПротокВыбораПобедителей) И (ТекДанные.Проведен) Тогда
			флЭтоУспешныйПротоколВыбораПобедителей = ((ТекДанные.ТоргиСостоялись) И (НЕ ТекДанные.ПринятоРешениеОПереторжке));
		Иначе
			флЭтоУспешныйПротоколВыбораПобедителей = Ложь;
		КонецЕсли;	
	Иначе
		флЭтоУспешныйПротоколВыбораПобедителей = Ложь;
	КонецЕсли;
	
	НовыйЗаголовок = НСтр("ru = 'Управление договорами закупки'");
	Если флЭтоУспешныйПротоколВыбораПобедителей Тогда
		НовыйЗаголовок = НСтр("ru = 'Управление договорами закупки'");
	Иначе
		НовыйЗаголовок = НСтр("ru = 'Ввод договора недоступен'");
	КонецЕсли;
	Элементы.ФормаОбработкаФормированиеДоговоровСПобедителямиТорговУправлениеДоговорамиЗакупки.Заголовок = НовыйЗаголовок;
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыНаСервере
#КонецОбласти
