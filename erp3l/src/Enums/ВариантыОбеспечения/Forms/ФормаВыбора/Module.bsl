#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокВариантов.Добавить(Перечисления.ВариантыОбеспечения.Отгрузить);
	СписокВариантов.Добавить(Перечисления.ВариантыОбеспечения.СоСклада);
	
	СписокВариантов.Добавить(Перечисления.ВариантыОбеспечения.Требуется);
	СписокВариантов.Добавить(Перечисления.ВариантыОбеспечения.НеТребуется);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВариантыОбеспеченияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ВыбратьКлиент();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьКлиент();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьКлиент()

	ТекСтрока = Элементы.ВариантыОбеспечения.ТекущиеДанные;
	Если ТекСтрока <> Неопределено Тогда
		ОповеститьОВыборе(ТекСтрока.Значение);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
