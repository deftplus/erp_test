
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция ПолучитьПоСтроке(СтрокаПоиска = "", ЗначениеПоУмолчанию = Неопределено) Экспорт

	Если ЗначениеЗаполнено(СокрЛП(СтрокаПоиска)) Тогда
		
		Попытка
		    Возврат Перечисления.ТипыЗначенийПоказателейОтчетов[СокрЛП(СтрокаПоиска)];
		Исключение
			Возврат ?(ЗначениеПоУмолчанию = Неопределено, ПредопределенноеЗначение("Перечисление.ТипыЗначенийПоказателейОтчетов.Число"), ЗначениеПоУмолчанию); 
		КонецПопытки;
		
	Иначе		
		Возврат ?(ЗначениеПоУмолчанию = Неопределено, ПредопределенноеЗначение("Перечисление.ТипыЗначенийПоказателейОтчетов.Число"), ЗначениеПоУмолчанию);
	КонецЕсли;

КонецФункции

#КонецЕсли