
#Область ОбработчикиСобытийПолейФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.ПолноеНаименование) 
		И НЕ ПустаяСтрока(Объект.Наименование) Тогда
		Объект.ПолноеНаименование = Объект.Наименование;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
