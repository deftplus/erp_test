
#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	График.Загрузить(Параметры.Объект.График.Выгрузить());
	ОбновитьИтогТаблицы(ЭтотОбъект);	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_График

&НаКлиенте
Процедура ГрафикПриИзменении(Элемент)
	ОбновитьИтогТаблицы(ЭтотОбъект);
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	Закрыть(АдресТаблицы());
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИтогТаблицы(Форма)
	
	Форма.Итого = Форма.График.Итог("Сумма");
	
КонецПроцедуры

&НаСервере
Функция АдресТаблицы()
	
	Возврат ПоместитьВоВременноеХранилище(График.Выгрузить());
	
КонецФункции

#КонецОбласти
