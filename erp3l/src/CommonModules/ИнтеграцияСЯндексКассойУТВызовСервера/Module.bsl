
Функция ДанныеЭквайераПоУмолчанию() Экспорт
	
	Возврат Справочники.НастройкиЯндексКассы.ДанныеЭквайераПоУмолчанию(ТекущаяДатаСеанса());
		
КонецФункции

Функция НачатьЗагрузкуОперацийПоЯндексКассе(Знач ПараметрыЗагрузки) Экспорт
	
	ДлительнаяОперация = ИнтеграцияСЯндексКассойУТ.НачатьЗагрузкуОперацийПоЯндексКассе(ПараметрыЗагрузки);
	
	Возврат ДлительнаяОперация;
	
КонецФункции
