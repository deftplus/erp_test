#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура СоздатьРакурсПоУмолчанию(ВидОтчета) Экспорт
		
	Ракурс = Справочники.ОбластиДанныхВидовОтчетов.СоздатьЭлемент();
	Ракурс.Наименование = Строка(ВидОтчета)+НСтр("ru = ' (все показатели)'");
	Ракурс.ВключатьВсеПоказателиВидаОтчета = Истина;
	Ракурс.РазделятьПоОрганизациям = Истина;
	Ракурс.Владелец = ВидОтчета;	
	Ракурс.Записать();
	
КонецПроцедуры	

#КонецЕсли