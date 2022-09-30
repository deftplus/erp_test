#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ОбработчикОжидания", 3);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗаданиеЗавершено Тогда
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработчикОжидания()
	
	Если Не ЗаданиеВыполняется(Параметры.ИдентификаторЗадания) Тогда
		ЗаданиеЗавершено = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполняется(ИдентификаторЗадания)
	УстановитьПривилегированныйРежим(Истина);
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Возврат Задание <> Неопределено И Задание.Состояние = СостояниеФоновогоЗадания.Активно;
КонецФункции

#КонецОбласти
