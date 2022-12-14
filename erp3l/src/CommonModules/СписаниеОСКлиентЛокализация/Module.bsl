////////////////////////////////////////////////////////////////////////////////
// Процедуры, используемые для локализации документа "Списание ОС".
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ПослеЗаписи(Объект) Экспорт

	//++ Локализация
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) 
		И ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ИнвентаризацияОС") Тогда
		
		Оповестить("ЗаписьДокументаНаОснованииИнвентаризации",, Объект.Ссылка);
	КонецЕсли;
	
	//-- Локализация	
	
КонецПроцедуры

Процедура ПрослеживаемыеТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование) Экспорт
	
	//++ Локализация
	
	Если НоваяСтрока И НЕ Копирование Тогда
		Элемент.ТекущиеДанные.КодОперацииВыбытия = ПредопределенноеЗначение("Справочник.КодыОперацийПрослеживаемости.ЗахоронениеОбезвреживаниеУтилизацияТовара");
	КонецЕсли;
	
	//-- Локализация
	
КонецПроцедуры
 
#КонецОбласти
