
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьДоступностьНастроек();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьКластеры(Команда)
	
	ОткрытьФорму("Справочник.СП_Кластеры.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗаданияОбмена(Команда)
	
	ОткрытьФорму("Справочник.СП_ЗаданияОбмена.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОбъектыОбмена(Команда)
	
	ОткрытьФорму("Справочник.СП_ОбъектыОбмена.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСхемыДанных(Команда)
	
	ОткрытьФорму("Справочник.СП_СхемыДанных.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКафкаКоннекторПриИзменении(Элемент)
	
	ИспользоватьКафкаКоннекторПриИзмененииНаСервере();
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИспользоватьКафкаКоннекторПриИзмененииНаСервере()
	
	Константы.СП_ИспользоватьКафкаКоннектор.Установить(НаборКонстант.СП_ИспользоватьКафкаКоннектор);
	
	УстановитьДоступностьНастроек();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьНастроек()
	
	Элементы.СписокНастроек.Доступность = НаборКонстант.СП_ИспользоватьКафкаКоннектор;
	
КонецПроцедуры

#КонецОбласти
