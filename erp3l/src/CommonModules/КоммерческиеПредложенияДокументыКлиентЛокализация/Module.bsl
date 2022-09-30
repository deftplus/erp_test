////////////////////////////////////////////////////////////////////////////////
// Подсистема "Объекты УТ11, КА2, УП2".
// ОбщийМодуль.КоммерческиеПредложенияДокументыКлиентЛокализация.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийИзмененияЭлементовФормы

// См. КоммерческиеПредложенияДокументыКлиентПереопределяемый.ПриИзмененииНоменклатуры.
//
Процедура ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, ТекущийЭлемент, ТребуетсяСерверныйВызов) Экспорт
	
	//++ Локализация
	Если Форма.ИмяФормы = "Документ.КоммерческоеПредложениеПоставщика.Форма.ФормаДокумента" Тогда
		
		КоммерческоеПредложениеПоставщикаПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, ТекущийЭлемент, ТребуетсяСерверныйВызов);
		
	ИначеЕсли Форма.ИмяФормы = "Документ.ЗапросКоммерческихПредложенийПоставщиков.Форма.ФормаДокумента" Тогда
		
		ЗапросКоммерческихПредложенийПоставщиковПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, ТекущийЭлемент,
			ТребуетсяСерверныйВызов);
		
	КонецЕсли;
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область ПодборНоменклатуры

// См. КоммерческиеПредложенияДокументыКлиентПереопределяемый.ВыполнитьПодключаемуюКомандуИнтеграции.
//
Процедура ВыполнитьПодключаемуюКомандуИнтеграции(Команда, Форма, Объект) Экспорт
	
	//++ Локализация
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, Форма, Объект);
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

//++Локализация
#Область СлужебныеПроцедурыИФункции

#Область КоммерческоеПредложениеПоставщика

Процедура ЗапросКоммерческихПредложенийПоставщиковПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, ТекущийЭлемент, ТребуетсяСерверныйВызов)
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу",          ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый",    КоммерческиеПредложенияДокументыКлиентУТ.СтруктураПереопределяемыеДействия(Форма));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);

КонецПроцедуры

Процедура КоммерческоеПредложениеПоставщикаПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, ТекущийЭлемент, ТребуетсяСерверныйВызов)
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу",    ТекущаяСтрока.Характеристика);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
//-- Локализация
