#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПроверкаЗадвоенностиФизическихЛиц(Проверка, ПараметрыПроверки) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = РезультатПроверкиЗадвоенностиФизическихЛиц();
	Если Не Результат.Пустой() Тогда
		
		МодульКонтрольВеденияУчета = ОбщегоНазначения.ОбщийМодуль("КонтрольВеденияУчета");
		
		Выборка = Результат.Выбрать();
		Пока Выборка.СледующийПоЗначениюПоля("ОбластьПоиска") Цикл
			
			Пока Выборка.СледующийПоЗначениюПоля("Значение") Цикл
				
				ДополнительнаяИнформация = СтрШаблон("%1: %2", Выборка.ОбластьПоиска, Выборка.Значение);
				Пока Выборка.СледующийПоЗначениюПоля("ФизическоеЛицо") Цикл
					
					Проблема = МодульКонтрольВеденияУчета.ОписаниеПроблемы(Выборка.Сотрудник, ПараметрыПроверки);
					Проблема.УточнениеПроблемы = НСтр("ru = 'Найдены люди с такими же данными';
														|en = 'People with the same data found'") + " (" + ДополнительнаяИнформация + ")";
					КонтрольВеденияУчетаБЗК.ЗаписатьПроблему(Проблема, ПараметрыПроверки);
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ПроверкаКадровогоПереводаСотрудниковВДекрете(Проверка, ПараметрыПроверки) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийРасчетныйМесяц = ЗарплатаКадрыБазовый.РасчетныйМесяц(ТекущаяДатаСеанса());

	УстановитьПривилегированныйРежим(Истина);
	Результат = РезультатПроверкиКадровогоПереводаСотрудниковВДекрете(ТекущийРасчетныйМесяц);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Результат.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СостояниеСотрудника Из Результат Цикл 
		МодульКонтрольВеденияУчета = ОбщегоНазначения.ОбщийМодуль("КонтрольВеденияУчета");
		Проблема = МодульКонтрольВеденияУчета.ОписаниеПроблемы(СостояниеСотрудника.Сотрудник, ПараметрыПроверки);
		Проблема.ВажностьПроблемы = Перечисления["ВажностьПроблемыУчета"].Предупреждение;
		Проблема.УточнениеПроблемы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'На сотрудника, находящегося в отпуске по уходу за ребенком, оформлен кадровый перевод в этом расчетном месяце (%1).';
				|en = 'An employee who is on child care leave has been assigned a staff transfer in this settlement month (%1).'"),
			ЗарплатаКадрыКлиентСервер.ПолучитьПредставлениеМесяца(ТекущийРасчетныйМесяц));
		УстановитьПривилегированныйРежим(Истина);
		КонтрольВеденияУчетаБЗК.ЗаписатьПроблему(Проблема, ПараметрыПроверки);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РезультатПроверкиЗадвоенностиФизическихЛиц()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	КадровыйУчетРасширенный.СоздатьВТЗадублированныеФизическиеЛица(Запрос.МенеджерВременныхТаблиц);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗадублированныеФизическиеЛица.ОбластьПоиска КАК ОбластьПоиска,
		|	ЗадублированныеФизическиеЛица.Значение КАК Значение,
		|	ЗадублированныеФизическиеЛица.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Сотрудники.Ссылка КАК Сотрудник
		|ИЗ
		|	ВТЗадублированныеФизическиеЛица КАК ЗадублированныеФизическиеЛица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
		|		ПО ЗадублированныеФизическиеЛица.ФизическоеЛицо = Сотрудники.ФизическоеЛицо
		|
		|УПОРЯДОЧИТЬ ПО
		|	ОбластьПоиска,
		|	Значение,
		|	ФизическоеЛицо,
		|	Сотрудник";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;
	
КонецФункции

Функция РезультатПроверкиКадровогоПереводаСотрудниковВДекрете(ТекущийРасчетныйМесяц)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийРасчетныйМесяц", ТекущийРасчетныйМесяц);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КадровыйПеревод.Сотрудник КАК Сотрудник
		|ИЗ
		|	Документ.КадровыйПеревод КАК КадровыйПеревод
		|ГДЕ
		|	НАЧАЛОПЕРИОДА(КадровыйПеревод.ДатаНачала, МЕСЯЦ) = &ТекущийРасчетныйМесяц
		|	И КадровыйПеревод.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Сотрудник";
	
	МассивСотрудников = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Сотрудник");
	РезультатЗапроса = СостоянияСотрудников.СостоянияСотрудников(
		МассивСотрудников, Перечисления.СостоянияСотрудника.ОтпускПоУходуЗаРебенком, ТекущийРасчетныйМесяц);
	
	Возврат РезультатЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли