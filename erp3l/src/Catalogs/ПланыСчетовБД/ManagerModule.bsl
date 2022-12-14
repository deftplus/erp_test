
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьПланСчетовБД(ИмяПланаСчетов = Неопределено, ТипБД = Неопределено) Экспорт
	
	Если ТипБД = Неопределено Тогда
		ТипБД = Справочники.ТипыБазДанных.ТекущаяИБ;	
	КонецЕсли;
	
	Если ИмяПланаСчетов = Неопределено Тогда
		ИмяПланаСчетов = "МСФО";
	КонецЕсли;	
	
	Возврат Справочники.ПланыСчетовБД.НайтиПоНаименованию(ИмяПланаСчетов, Истина, , ТипБД);
	
КонецФункции

Процедура СкопироватьПодчиненныеСчета(НовыйПланСчетов,ИсходныйПланСчетов,Отказ) Экспорт
	
	Запрос=НОвый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	СчетаБД.Ссылка КАК СчетБД,
	|	ЕСТЬNULL(СчетаБД.Родитель.Код, НЕОПРЕДЕЛЕНО) КАК КодРодителя
	|ИЗ
	|	Справочник.СчетаБД КАК СчетаБД
	|ГДЕ
	|	СчетаБД.Владелец = &ИсходныйПланСчетов
	|
	|УПОРЯДОЧИТЬ ПО
	|	СчетБД ИЕРАРХИЯ";
	
	Запрос.УстановитьПараметр("ИсходныйПланСчетов",ИсходныйПланСчетов);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	НачатьТранзакцию();
	
	Пока Результат.Следующий() Цикл
		
		НовыйСчет=Результат.СчетБД.Скопировать();
		НовыйСчет.Владелец=НовыйПланСчетов;
		
		Если НЕ Результат.КодРодителя=Неопределено Тогда
			
			НовыйСчет.Родитель = Справочники.СчетаБД.НайтиПоКоду(Результат.КодРодителя, , , НовыйПланСчетов);
			
		КонецЕсли;
		
		Попытка
			НовыйСчет.Записать();
		Исключение
			ТекстСообщения = НСтр("ru = 'Не удалось записать элемент справочника %Синоним% с кодом %Код% по причине: %ОписаниеОшибки%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Синоним%", Нстр("ru = 'Счета ИБ'"));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Код%", Строка(НовыйСчет.Код));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", Строка(ОписаниеОшибки()));
			Сообщить(ТекстСообщения, СтатусСообщения.Важное);
			Отказ = Истина;
			ОтменитьТранзакцию();
			Возврат;
		КонецПопытки;
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
			
КонецПроцедуры // СкопироватьПодчиненныеСчета() 

#КонецЕсли
