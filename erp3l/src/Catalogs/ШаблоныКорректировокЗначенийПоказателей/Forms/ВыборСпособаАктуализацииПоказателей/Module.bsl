
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ВидОтчета) Тогда
		
		ЭтотОбъект.Заголовок = Нстр("ru = 'Актуализация показателей вида отчета '") + Параметры.ВидОтчета;
		
	Иначе
		
		ЭтотОбъект.Заголовок = Нстр("ru = 'Выбор способв актуализации поазателей'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВернутьСпособАктуализации(Команда)
	
	  Закрыть(ДействияПриАктуализации);
	
КонецПроцедуры
