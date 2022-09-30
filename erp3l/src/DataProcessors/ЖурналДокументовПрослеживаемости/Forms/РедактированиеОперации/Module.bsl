
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ДанныеОперации);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	Если Модифицированность Тогда
		ЗначенияРеквизитов = Новый Структура;
		ЗначенияРеквизитов.Вставить("Контрагент", Контрагент);
		ЗначенияРеквизитов.Вставить("КодОперации", КодОперации);
		ЗначенияРеквизитов.Вставить("ОтражениеВОтчетности", ОтражениеВОтчетности);
		ЗначенияРеквизитов.Вставить("ТипДокументаВПрослеживаемости", ВидДокумента);
		Закрыть(ЗначенияРеквизитов);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
