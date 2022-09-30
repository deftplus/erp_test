												 
&Вместо("УстановитьАвтораОбъектаПередЗаписью")												 
// Заполняет реквизит Автор нового документа, являющегося источником для подписки УстановитьАвтораОбъекта.
//
// Параметры:
//  Источник - ДокументОбъект - документ с реквизитом Автор
//  Отказ - Булево - признак отказа от записи
//  РежимЗаписи - РежимЗаписиДокумента - текущий режим записи документа
//  РежимПроведения - РежимПроведенияДокумента - текущий режим проведения документа.
//
Процедура ллл_УстановитьАвтораОбъектаПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//Было
	//Если Не ЗначениеЗаполнено(Источник.Ссылка) Тогда
	//	Источник.Автор = Пользователи.АвторизованныйПользователь();
	//КонецЕсли;
	
	//Стало	
	Если Не ЗначениеЗаполнено(Источник.Ссылка) и не ЗначениеЗаполнено(Источник.Автор) Тогда
		Источник.Автор = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
КонецПроцедуры

