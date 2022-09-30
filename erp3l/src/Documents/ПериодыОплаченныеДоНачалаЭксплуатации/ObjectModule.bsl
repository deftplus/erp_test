#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.ПериодыОплаченныеДоНачалаЭксплуатации.ПровестиПоУчетам(Ссылка, РежимПроведения, Отказ, Неопределено, Движения, ЭтотОбъект, ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Начисления", Начисления.Выгрузить());
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НачисленияСотрудники.Сотрудник,
		|	НачисленияСотрудники.НомерСтроки,
		|	НачисленияСотрудники.ДатаНачала,
		|	НачисленияСотрудники.ДатаОкончания
		|ПОМЕСТИТЬ ВТОплаченныеПериодыСотрудников
		|ИЗ
		|	&Начисления КАК НачисленияСотрудники
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПериодыСотрудников.Сотрудник,
		|	ПериодыСотрудников.НомерСтроки
		|ПОМЕСТИТЬ ВТСтрокиСНекорректноЗаполненнымПериодом
		|ИЗ
		|	ВТОплаченныеПериодыСотрудников КАК ПериодыСотрудников
		|ГДЕ
		|	ПериодыСотрудников.ДатаНачала > ПериодыСотрудников.ДатаОкончания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПериодыСотрудников.Сотрудник,
		|	МАКСИМУМ(ПериодыСотрудниковДругие.НомерСтроки) КАК НомерСтроки
		|ПОМЕСТИТЬ ВТПересекаютсяПериоды
		|ИЗ
		|	ВТОплаченныеПериодыСотрудников КАК ПериодыСотрудников
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОплаченныеПериодыСотрудников КАК ПериодыСотрудниковДругие
		|		ПО ПериодыСотрудников.Сотрудник = ПериодыСотрудниковДругие.Сотрудник
		|			И ПериодыСотрудников.НомерСтроки <> ПериодыСотрудниковДругие.НомерСтроки
		|			И ПериодыСотрудников.ДатаОкончания >= ПериодыСотрудниковДругие.ДатаНачала
		|			И ПериодыСотрудников.ДатаОкончания <= ПериодыСотрудниковДругие.ДатаОкончания
		|
		|СГРУППИРОВАТЬ ПО
		|	ПериодыСотрудников.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПересекаютсяПериоды.Сотрудник,
		|	ПересекаютсяПериоды.НомерСтроки КАК НомерСтроки,
		|	ИСТИНА КАК ПересекаютсяПериоды,
		|	ЛОЖЬ КАК НекорректныйПериодПредоставления
		|ПОМЕСТИТЬ ВТСводный
		|ИЗ
		|	ВТПересекаютсяПериоды КАК ПересекаютсяПериоды
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОплаченныеПериодыСотрудников КАК ПериодыСотрудников
		|		ПО ПересекаютсяПериоды.НомерСтроки = ПериодыСотрудников.НомерСтроки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СтрокиСНекорректноЗаполненнымПериодом.Сотрудник,
		|	СтрокиСНекорректноЗаполненнымПериодом.НомерСтроки,
		|	ЛОЖЬ,
		|	ИСТИНА
		|ИЗ
		|	ВТСтрокиСНекорректноЗаполненнымПериодом КАК СтрокиСНекорректноЗаполненнымПериодом
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОплаченныеПериодыСотрудников КАК ПериодыСотрудников
		|		ПО СтрокиСНекорректноЗаполненнымПериодом.НомерСтроки = ПериодыСотрудников.НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Сводный.Сотрудник,
		|	Сводный.НомерСтроки КАК НомерСтроки,
		|	МАКСИМУМ(Сводный.ПересекаютсяПериоды) КАК ПересекаютсяПериоды,
		|	МАКСИМУМ(Сводный.НекорректныйПериодПредоставления) КАК НекорректныйПериодПредоставления
		|ИЗ
		|	ВТСводный КАК Сводный
		|
		|СГРУППИРОВАТЬ ПО
		|	Сводный.Сотрудник,
		|	Сводный.НомерСтроки
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ТекстСообщения = "";
			
			Если Выборка.НекорректныйПериодПредоставления Тогда
				ТекстСообщения = ?(ПустаяСтрока(ТекстСообщения), "", ТекстСообщения +", ")
					+ НСтр("ru = 'некорректно задан период';
							|en = 'period is specified incorrectly'");
			КонецЕсли; 
			
			Если Выборка.ПересекаютсяПериоды Тогда
				ТекстСообщения = ?(ПустаяСтрока(ТекстСообщения), "", ТекстСообщения +", ")
					+ НСтр("ru = 'пересекается периоды';
							|en = 'overlaps periods'");
			КонецЕсли; 
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'По сотруднику %1:';
					|en = 'By employee %1:'"), Выборка.Сотрудник) + " " + ТекстСообщения;
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,,
				"Начисления[" + (Выборка.НомерСтроки - 1) + "].Сотрудник",
				"Объект",
				Отказ);
			
		КонецЦикла;
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли