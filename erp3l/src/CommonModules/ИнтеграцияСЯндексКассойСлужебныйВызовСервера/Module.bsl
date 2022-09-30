////////////////////////////////////////////////////////////////////////////////
// ИнтеграцияСЯндексКассойСлужебныйВызовСервера: механизм интеграции с Яндекс.Кассой.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Проверяет, что введены логин и пароль интернет поддержки. 
//
// Возвращаемое значение:
//  Булево - признак того, что интернет поддержка пользователя подключена.
//
Функция ДанныеИнтернетПоддержкиУказаны() Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	ЕстьДанныеАутентификации = ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ЕстьДанныеАутентификации;
	
КонецФункции

Процедура ПредопределенныеШаблоныСообщений(ПредопределенныеШаблоныСообщений) Экспорт
	
	ИнтеграцияСЯндексКассойПереопределяемый.ПредопределенныеШаблоныСообщений(ПредопределенныеШаблоныСообщений);
	
КонецПроцедуры

#КонецОбласти
