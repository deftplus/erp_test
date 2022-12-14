
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		
		НастраиваемыйОбъект = ТекДанные.НастраиваемыйОбъект;
		
		ЭтоПроизвольныйОтчет	 =  РасширениеБизнесЛогикиУХКлиентСервер.ПроверитьТипЗначения(НастраиваемыйОбъект, "СправочникСсылка.ПроизвольныеОтчеты");
		ЭтоПанельОтчетов		 =  РасширениеБизнесЛогикиУХКлиентСервер.ПроверитьТипЗначения(НастраиваемыйОбъект, "СправочникСсылка.ПанелиОтчетов");
		Если ЭтоПроизвольныйОтчет ИЛИ ЭтоПанельОтчетов Тогда
			
			СтандартнаяОбработка = Ложь;
			ПодменюВыбора = Новый СписокЗначений;
			ПодменюВыбора.Добавить(1, "Открыть элемент с выбранной настройкой");
			ПодменюВыбора.Добавить(2, "Открыть форму настройки");
			РезультатВыбора = Неопределено;
			
			Оповещение = Новый ОписаниеОповещения("СписокВыборЗавершение", ЭтотОбъект, Новый Структура("ТекущаяСтрока", ТекущаяСтрока));
			ПоказатьВыборИзМеню(Оповещение, ПодменюВыбора, Элемент);
			
		Иначе
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	Иначе
		СтандартнаяОбработка = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
    
    ТекущаяСтрока = ДополнительныеПараметры.ТекущаяСтрока;
        
    РезультатВыбора = ВыбранныйЭлемент;
    Если РезультатВыбора <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("Ключ, РежимРедактирования", ТекущаяСтрока, РезультатВыбора.Значение = 2);
		ОткрытьФорму("Справочник.СохраненныеНастройки.ФормаОбъекта", ПараметрыФормы);
    КонецЕсли;
    
КонецПроцедуры

