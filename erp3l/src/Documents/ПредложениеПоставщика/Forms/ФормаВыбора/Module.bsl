
#Область ОбработкаОсновныхСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	АккредитацияПоставщиковУХ.ПриСозданииНаСервереФормыВнешнегоПоставщика(ЭтаФорма, Отказ, "Список",,, Истина);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры


#КонецОбласти

#Область ОбработкаСобытийЭлементовФормы


#КонецОбласти

#Область СлужебныеПроцедурыНаКлиенте


#КонецОбласти

#Область СлужебныеПроцедурыНаСервере


#КонецОбласти
