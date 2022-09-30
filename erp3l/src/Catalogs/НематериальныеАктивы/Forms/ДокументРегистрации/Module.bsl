
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДокументРегистрацииНаименование = Параметры.ДокументРегистрацииНаименование;
	ДокументРегистрацииДата = Параметры.ДокументРегистрацииДата;
	ДокументРегистрацииНомер = Параметры.ДокументРегистрацииНомер;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ ЗначениеЗаполнено(ДокументРегистрацииНаименование)
		И НЕ ЗначениеЗаполнено(ДокументРегистрацииДата)
		И НЕ ЗначениеЗаполнено(ДокументРегистрацииНомер) Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ДокументРегистрацииНаименование");
		МассивНепроверяемыхРеквизитов.Добавить("ДокументРегистрацииДата");
		МассивНепроверяемыхРеквизитов.Добавить("ДокументРегистрацииНомер");
	КонецЕсли; 
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СведенияОДокументе = Новый Структура;
	СведенияОДокументе.Вставить("ДокументРегистрацииНаименование", ДокументРегистрацииНаименование);
	СведенияОДокументе.Вставить("ДокументРегистрацииДата", ДокументРегистрацииДата);
	СведенияОДокументе.Вставить("ДокументРегистрацииНомер", ДокументРегистрацииНомер);
	
	Закрыть(СведенияОДокументе);
	
КонецПроцедуры

#КонецОбласти
