
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем БезусловноеУдаление Экспорт;
Перем ВыполнитьПереносДанныхПометкаУдаления;

Процедура ПередУдалением(Отказ)
			
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
		
	Если НЕ БезусловноеУдаление Тогда
		
		Отказ=НЕ Справочники.ВерсииЗначенийПоказателей.УдалитьЗаписиВерсии(Ссылка);
				
	КонецЕсли;
			
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) И НЕ ПометкаУдаления=Ссылка.ПометкаУдаления Тогда
		ВыполнитьПереносДанныхПометкаУдаления=Истина;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ВыполнитьПереносДанныхПометкаУдаления Тогда
		
		Справочники.ВерсииЗначенийПоказателей.ВыполнитьПереносЗаписейРегистров(Ссылка,
				?(ПометкаУдаления,"ЗначенияПоказателейОтчетов","ЗначенияПоказателейМоделирование"),
				?(ПометкаУдаления,"ЗначенияПоказателейМоделирование","ЗначенияПоказателейОтчетов"),
				Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

	
БезусловноеУдаление = Ложь;
ВыполнитьПереносДанныхПометкаУдаления=Ложь;

#КонецЕсли
