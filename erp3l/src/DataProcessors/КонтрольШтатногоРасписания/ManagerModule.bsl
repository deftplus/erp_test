#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПроверкаПревышенияКоличестваСтавок(Проверка, ПараметрыПроверки) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаПроблем = ТаблицаРезультатаПроверкиПревышенияКоличестваСтавок();
	Если ТаблицаПроблем.Количество() > 0 Тогда
		
		МодульКонтрольВеденияУчета = ОбщегоНазначения.ОбщийМодуль("КонтрольВеденияУчета");
		
		Регистраторы  = ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаПроблем, "Регистратор", Истина);
		Ответственные = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Регистраторы, "Ответственный");
		
		Для Каждого СтрокаПроблемы Из ТаблицаПроблем Цикл
		
			УточнениеПроблемы = СтрШаблон(
				НСтр("ru = 'Количество занимаемых ставок %1 (%2) превышает свободный остаток (%3)';
					|en = 'Number of occupied positions %1 (%2) exceeds the free balance (%3)'"),
				СтрокаПроблемы.КоличествоСтавок,
				СтрокаПроблемы.ПозицияШтатногоРасписания,
				СтрокаПроблемы.КоличествоСтавок + СтрокаПроблемы.СвободноеКоличествоСтавок);
			
			Проблема = МодульКонтрольВеденияУчета.ОписаниеПроблемы(СтрокаПроблемы.Регистратор, ПараметрыПроверки);
			Проблема.Ответственный = Ответственные.Получить(СтрокаПроблемы.Регистратор);
			Проблема.УточнениеПроблемы = УточнениеПроблемы;
			
			КонтрольВеденияУчетаБЗК.ЗаписатьПроблему(Проблема, ПараметрыПроверки);
		
		КонецЦикла;
		
	КонецЕсли; 
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТаблицаРезультатаПроверкиПревышенияКоличестваСтавок()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗанятостьПозицийШтатногоРасписанияИнтервальный.ДатаНачала КАК ДатаНачала,
		|	ЗанятостьПозицийШтатногоРасписанияИнтервальный.ДатаОкончания КАК ДатаОкончания,
		|	ЗанятостьПозицийШтатногоРасписанияИнтервальный.ПозицияШтатногоРасписания КАК ПозицияШтатногоРасписания,
		|	ЗанятостьПозицийШтатногоРасписанияИнтервальный.ВидЗанятостиПозиции КАК ВидЗанятостиПозиции,
		|	ЗанятостьПозицийШтатногоРасписанияИнтервальный.КоличествоСтавок КАК КоличествоСтавок,
		|	ЗанятостьПозицийШтатногоРасписанияИнтервальный.РегистраторСобытия КАК Регистратор
		|ПОМЕСТИТЬ ВТЗанятостьПозицийШтатногоРасписания
		|ИЗ
		|	РегистрСведений.ЗанятостьПозицийШтатногоРасписанияИнтервальный КАК ЗанятостьПозицийШтатногоРасписанияИнтервальный
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НАЧАЛОПЕРИОДА(ЗанятостьПозицийШтатногоРасписания.ДатаНачала, ДЕНЬ) КАК Период,
		|	ЗанятостьПозицийШтатногоРасписания.ПозицияШтатногоРасписания КАК ПозицияШтатногоРасписания
		|ПОМЕСТИТЬ ВТДатыЗанятияСтавок
		|ИЗ
		|	ВТЗанятостьПозицийШтатногоРасписания КАК ЗанятостьПозицийШтатногоРасписания
		|ГДЕ
		|	ЗанятостьПозицийШтатногоРасписания.ВидЗанятостиПозиции <> ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиПозицийШтатногоРасписания.Свободна)";
	
	Запрос.Выполнить();
	
	ПараметрыПостроения = УправлениеШтатнымРасписанием.ПараметрыПостроенияВТШтатноеРасписаниеПоТаблицеФильтра("ВТДатыЗанятияСтавок");
	УправлениеШтатнымРасписанием.СоздатьВТПозицииШтатногоРасписанияПоВременнойТаблице(
		Запрос.МенеджерВременныхТаблиц, Ложь, ПараметрыПостроения, "КоличествоСтавок, Занято");
		
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ШтатноеРасписание.Период КАК Период,
		|	ШтатноеРасписание.ПозицияШтатногоРасписания КАК ПозицияШтатногоРасписания,
		|	ШтатноеРасписание.КоличествоСтавок - ШтатноеРасписание.Занято КАК СвободноеКоличествоСтавок
		|ПОМЕСТИТЬ ВТПериодыНарушения
		|ИЗ
		|	ВТПозицииШтатногоРасписания КАК ШтатноеРасписание
		|ГДЕ
		|	ШтатноеРасписание.КоличествоСтавок < ШтатноеРасписание.Занято
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПериодыНарушения.Период КАК Период,
		|	ПериодыНарушения.ПозицияШтатногоРасписания КАК ПозицияШтатногоРасписания,
		|	ЗанятостьПозицийШтатногоРасписания.Регистратор КАК Регистратор,
		|	ЗанятостьПозицийШтатногоРасписания.КоличествоСтавок КАК КоличествоСтавок,
		|	ПериодыНарушения.СвободноеКоличествоСтавок КАК СвободноеКоличествоСтавок
		|ИЗ
		|	ВТПериодыНарушения КАК ПериодыНарушения
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЗанятостьПозицийШтатногоРасписания КАК ЗанятостьПозицийШтатногоРасписания
		|		ПО (ПериодыНарушения.Период = НАЧАЛОПЕРИОДА(ЗанятостьПозицийШтатногоРасписания.ДатаНачала, ДЕНЬ))
		|			И ПериодыНарушения.ПозицияШтатногоРасписания = ЗанятостьПозицийШтатногоРасписания.ПозицияШтатногоРасписания
		|ГДЕ
		|	ЗанятостьПозицийШтатногоРасписания.ВидЗанятостиПозиции <> ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиПозицийШтатногоРасписания.Свободна)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период,
		|	ПозицияШтатногоРасписания,
		|	Регистратор";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли