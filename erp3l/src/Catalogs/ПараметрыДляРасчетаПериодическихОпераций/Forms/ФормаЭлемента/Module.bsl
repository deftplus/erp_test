
&НаКлиенте
Процедура ПроизводныйПриИзменении(Элемент)
	
	Элементы.ГруппаРасчетПараметра.Видимость=Объект.Производный;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ГруппаРасчетПараметра.Видимость=Объект.Производный;
	
КонецПроцедуры
