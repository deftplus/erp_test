#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(Значение) И Значение < '20140101' Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Дата начала применения приказа Минфина России от 12.11.2013 №107н может быть установлена не ранее 01.01.2014 г.';
				|en = 'Commencement date of order of Ministry of Finance of the Russian Federation dated 11/12/2013 No. 107n can be set not earlier than 01/01/2014.'"),
			,
			"ДатаНачалаПримененияПриказа107н",
			"НаборКонстант");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
