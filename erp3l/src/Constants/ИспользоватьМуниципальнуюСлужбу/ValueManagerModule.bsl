#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПередЗаписью(Отказ)
	
	ПодсистемаСуществует = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба");
	Если Не ПодсистемаСуществует Тогда
		Если Значение Тогда
			ВызватьИсключение НСтр("ru = 'Нельзя установить значение ИспользоватьМуниципальнуюСлужбу';
									|en = 'You cannot set value ИспользоватьМуниципальнуюСлужбу'");
		КонецЕсли;
	КонецЕсли;
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПодсистемаСуществует Тогда
		ИспользоватьГосударственнуюСлужбу = Константы.ИспользоватьГосударственнуюСлужбу.Получить();
		Если Значение И ИспользоватьГосударственнуюСлужбу Тогда
			ВызватьИсключение НСтр("ru = 'В программе уже ведется расчет денежного содержания Государственных служащих, не допускается использовать одновременно расчет денежного содержания Государственных и Муниципальных служащих';
									|en = 'Monetary pay of Public service employees is already being calculated in the application, you cannot use monetary pay calculation of Public service employees and Municipal employees simultaneously'");	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	// Подключаемые Характеристики
	ИсточникиХарактеристик = Новый Массив;
	ИсточникиХарактеристик.Добавить("СтрокиОтчетностиРасходовИЧисленностиРаботниковГосударственныхОрганов");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		
		ИсточникиХарактеристик.Добавить("СвойстваДолжностейГосударственнойСлужбы");
		ИсточникиХарактеристик.Добавить("СвойстваНачисленийГосударственныхСлужащих");

		Если Не Значение Тогда
			Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
			Модуль.СброситьРасчетСохраняемогоДенежногоСодержания();
		КонецЕсли;
	КонецЕсли;
	
	ПодключаемыеХарактеристикиЗарплатаКадры.ОбновитьНаборыПодключаемыхХарактеристик(Значение, ИсточникиХарактеристик);
	
КонецПроцедуры

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли