#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	//
	СтандартнаяОбработка = Ложь;
	
	Если Параметры.Свойство("ВидБюджета") Тогда
		
		Если Параметры.Свойство("ДоступныеОперацииНаДату") Тогда
			ДоступныеОперацииНаДату = Параметры.ДоступныеОперацииНаДату;
		Иначе
			ДоступныеОперацииНаДату = ТекущаяДатаСеанса();
		КонецЕсли;
		
		ДанныеВыбора = ОперативноеПланированиеПовтИспУХ.ДоступныеОперацииОперПлана(Параметры.ВидБюджета, ДоступныеОперацииНаДату);
	Иначе
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить(Перечисления.ВидыОперацийОперативныйПлан.Планирование);
		ДанныеВыбора.Добавить(Перечисления.ВидыОперацийОперативныйПлан.ВводЛимитов);
		ДанныеВыбора.Добавить(Перечисления.ВидыОперацийОперативныйПлан.Резервирование);
		Если ОперативноеПланированиеПовтИспУХ.ИспользуетсяОдновременноеПланированиеИЛимитирование() Тогда
			ДанныеВыбора.Добавить(Перечисления.ВидыОперацийОперативныйПлан.ПланированиеИРезервирование);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли 

