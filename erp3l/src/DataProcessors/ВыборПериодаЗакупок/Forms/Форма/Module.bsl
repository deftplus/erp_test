
#Область ОбработкаОсновныхСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Отказ = Истина;
	УстановитьОформлениеФормы();
КонецПроцедуры


#КонецОбласти

#Область ОбработкаСобытийЭлементовФормы


#КонецОбласти

#Область СлужебныеПроцедурыНаКлиенте


#КонецОбласти

#Область СлужебныеПроцедурыНаСервере


&НаСервере
Процедура УстановитьОформлениеФормы()
	ЦентрализованныеЗакупкиУХ.УстановитьПараметрВыбораПериодичностьЗакупок(
		Элементы.ПериодЗакупок);
	Элементы.ГруппаПериоды.Видимость = Объект.Инновационный;
	Элементы.ПериодЗакупок.Видимость = НЕ Объект.Инновационный;
КонецПроцедуры


#КонецОбласти