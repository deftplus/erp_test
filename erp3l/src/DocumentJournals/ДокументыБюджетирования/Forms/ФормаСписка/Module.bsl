
#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СинонимыПолей = Новый Структура("ДоговорКонтрагента", "Договор");
	УправлениеФормойУХ.УстановитьПредставлениеОтбора(ЭтотОбъект,,,,,СинонимыПолей);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
