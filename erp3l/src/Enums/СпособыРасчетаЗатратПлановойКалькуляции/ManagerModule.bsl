
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ДетализироватьСтатьиКалькуляции") Тогда
		
		Если Не Параметры.ДетализироватьСтатьиКалькуляции Тогда
			СтандартнаяОбработка = Ложь;
			ДанныеВыбора = Новый СписокЗначений;
			ДанныеВыбора.Добавить(Перечисления.СпособыРасчетаЗатратПлановойКалькуляции.ФиксированнымЗначением);
			ДанныеВыбора.Добавить(Перечисления.СпособыРасчетаЗатратПлановойКалькуляции.ПоФормуле);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти