#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Возвращает структуру данных весов по критерию выбора КритерийВход.
Функция ПолучитьДанныеКритерияВыбораПоУмолчанию(КритерийВход) Экспорт
	РезультатФункции = Новый Структура;
	РезультатФункции.Вставить("Вес",					 КритерийВход.Вес);
	РезультатФункции.Вставить("МаксимальноеЗначение",	 КритерийВход.МаксимальноеЗначение);
	РезультатФункции.Вставить("МинимальноеЗначение",	 КритерийВход.МинимальноеЗначение);
	Возврат РезультатФункции;	
КонецФункции		// ПолучитьДанныеКритерияВыбораПоУмолчанию()	

#КонецЕсли