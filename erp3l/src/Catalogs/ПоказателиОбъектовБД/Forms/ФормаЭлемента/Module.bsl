
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ТипЗначения.Видимость=ЗначениеЗаполнено(Объект.ТипЗначения);
	Элементы.ТабличнаяЧастьБД.Видимость=ЗначениеЗаполнено(Объект.ТабличнаяЧастьБД);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаАналитикПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ=Истина;
	
КонецПроцедуры
