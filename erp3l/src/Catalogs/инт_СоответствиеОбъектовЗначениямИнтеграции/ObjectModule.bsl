// Лопатин. Не корректное определение даты и автора изменений, надо "ловить" интерактивное изменение - в форме элемента.
//Процедура ПередЗаписью(Отказ)
//	Если ЭтотОбъект.Модифицированность() тогда
//		ЭтотОбъект.ДатаИзменения=Текущаядата();
//		ЭтотОбъект.АвторИзменения=ПараметрыСеанса.ТекущийПользователь;
//		
//	КонецЕсли;
//	
//КонецПроцедуры
