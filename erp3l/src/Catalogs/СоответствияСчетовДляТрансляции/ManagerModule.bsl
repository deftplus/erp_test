Процедура ИзменитьОбъектПоПараметрам(СтруктураПараметров) Экспорт
	
	Если НЕ ЗначениеЗаполнено(СтруктураПараметров.Ссылка) Тогда
		
		Запрос=Новый Запрос;
		Запрос.Текст="ВЫБРАТЬ
		|	СоответствияСчетовДляТрансляции.Ссылка
		|ИЗ
		|	Справочник.СоответствияСчетовДляТрансляции КАК СоответствияСчетовДляТрансляции
		|ГДЕ
		|	СоответствияСчетовДляТрансляции.СчетИсточник = &СчетИсточник
		|	И СоответствияСчетовДляТрансляции.КоррСчетИсточник = &КоррСчетИсточник
		|	И СоответствияСчетовДляТрансляции.СчетПриемник = &СчетПриемник
		|	И СоответствияСчетовДляТрансляции.ИдентификаторСоответствия = &ИдентификаторСоответствия
		|	И СоответствияСчетовДляТрансляции.Владелец = &Владелец";
		
		Запрос.УстановитьПараметр("СчетИсточник",	СтруктураПараметров.СчетИсточник);
		Запрос.УстановитьПараметр("КоррСчетИсточник",СтруктураПараметров.КоррСчетИсточник);
		Запрос.УстановитьПараметр("СчетПриемник",	СтруктураПараметров.СчетПриемник);
		Запрос.УстановитьПараметр("ИдентификаторСоответствия",	СтруктураПараметров.ИдентификаторСоответствия);
		Запрос.УстановитьПараметр("Владелец",		СтруктураПараметров.Владелец);
		
		Результат=Запрос.Выполнить().Выбрать();
		
		Если Результат.Следующий() Тогда
			
			СправочникОбъект=Результат.Ссылка.ПолучитьОбъект();
			
		Иначе
			
			СправочникОбъект=Справочники.СоответствияСчетовДляТрансляции.СоздатьЭлемент();	
			
			ЗаполнитьЗначенияСвойств(СправочникОбъект,СтруктураПараметров);
						
			СправочникОбъект.Наименование=СтрШаблон(Нстр("ru = 'Трансляция со счета %1 в счет %2'"), СтруктураПараметров.СчетИсточник, 
				СтруктураПараметров.СчетПриемник);
			
		КонецЕсли;
		
	Иначе
		
		СправочникОбъект=СтруктураПараметров.Ссылка.ПолучитьОбъект();
		
	КонецЕсли;
				
	СправочникОбъект.ГруппаРаскрытия=Справочники.ВидыОтчетов.ПолучитьГруппуРаскрытияДляСчета(СправочникОбъект.Владелец,СправочникОбъект.СчетПриемник,,Перечисления.ВидыБухгалтерскихИтогов.ДО);
			
	Попытка
		СправочникОбъект.Записать();
		СтруктураПараметров.Вставить("Ссылка",СправочникОбъект.Ссылка);
	Исключение
		ОбщегоНазначенияУХ.СообщитьОбОшибке(СтрШаблон(Нстр("ru = 'Не удалось обработать соответствие %1: %2'"), 
			СправочникОбъект.Наименование, ОписаниеОшибки()),,,СтатусСообщения.Важное);
	КонецПопытки;
	
КонецПроцедуры // ИзменитьОбъектПоПараметрам()

Процедура ИзменитьОбъектПоПараметрамРегистр(СтруктураПараметров) Экспорт
	
	Если НЕ ЗначениеЗаполнено(СтруктураПараметров.Ссылка) Тогда
		
		Запрос=Новый Запрос;
		Запрос.Текст="ВЫБРАТЬ
		|	СоответствияСчетовДляТрансляции.Ссылка
		|ИЗ
		|	Справочник.СоответствияСчетовДляТрансляции КАК СоответствияСчетовДляТрансляции
		|ГДЕ
		|	СоответствияСчетовДляТрансляции.ОбъектУчетаИсточник = &ОбъектУчетаИсточник
		|	И СоответствияСчетовДляТрансляции.ОбъектНастройки = &ОбъектНастройки
		|	И СоответствияСчетовДляТрансляции.КоррОбъектУчетаИсточник = &КоррОбъектУчетаИсточник
		|	И СоответствияСчетовДляТрансляции.КоррОбъектНастройки = &КоррОбъектНастройки
		|	И СоответствияСчетовДляТрансляции.СчетПриемник = &СчетПриемник
		|	И СоответствияСчетовДляТрансляции.ИдентификаторСоответствия = &ИдентификаторСоответствия
		|	И СоответствияСчетовДляТрансляции.Владелец = &Владелец";
		
		Запрос.УстановитьПараметр("ОбъектУчетаИсточник",	СтруктураПараметров.ОбъектУчетаИсточник);
		Запрос.УстановитьПараметр("ОбъектНастройки",		СтруктураПараметров.ОбъектНастройки); 
		Запрос.УстановитьПараметр("КоррОбъектУчетаИсточник",СтруктураПараметров.КоррОбъектУчетаИсточник);
		Запрос.УстановитьПараметр("КоррОбъектНастройки",	СтруктураПараметров.КоррОбъектНастройки);
		Запрос.УстановитьПараметр("СчетПриемник",			СтруктураПараметров.СчетПриемник);
		Запрос.УстановитьПараметр("ИдентификаторСоответствия",	СтруктураПараметров.ИдентификаторСоответствия);
		Запрос.УстановитьПараметр("Владелец",				СтруктураПараметров.Владелец);
		
		Результат=Запрос.Выполнить().Выбрать();
		
		Если Результат.Следующий() Тогда
			
			СправочникОбъект=Результат.Ссылка.ПолучитьОбъект();
			
		Иначе
			
			СправочникОбъект=Справочники.СоответствияСчетовДляТрансляции.СоздатьЭлемент();	
			
			ЗаполнитьЗначенияСвойств(СправочникОбъект,СтруктураПараметров);
			
			Если ЗначениеЗаполнено(СтруктураПараметров.ОбъектНастройки) Тогда
				
				СправочникОбъект.Наименование=СтрШаблон(Нстр("ru = 'Трансляция объекта учета %1 в счет %2 по настройке %3\'"), СтруктураПараметров.ОбъектУчетаИсточник, 
				СтруктураПараметров.СчетПриемник,
				СтруктураПараметров.ОбъектНастройки);
				
			Иначе
			
			СправочникОбъект.Наименование=СтрШаблон(Нстр("ru = 'Трансляция объекта учета %1 в счет %2'"), СтруктураПараметров.ОбъектУчетаИсточник, 
				СтруктураПараметров.СчетПриемник);
				
			КонецЕсли;	
			
		КонецЕсли;
		
	Иначе
		
		СправочникОбъект=СтруктураПараметров.Ссылка.ПолучитьОбъект();
		
	КонецЕсли;
				
	СправочникОбъект.ГруппаРаскрытия=Справочники.ВидыОтчетов.ПолучитьГруппуРаскрытияДляСчета(СправочникОбъект.Владелец,СправочникОбъект.СчетПриемник,,Перечисления.ВидыБухгалтерскихИтогов.ДО);
			
	Попытка
		СправочникОбъект.Записать();
		СтруктураПараметров.Вставить("Ссылка",СправочникОбъект.Ссылка);
	Исключение
		ОбщегоНазначенияУХ.СообщитьОбОшибке(СтрШаблон(Нстр("ru = 'Не удалось обработать соответствие %1: %2'"), 
			СправочникОбъект.Наименование, ОписаниеОшибки()),,,СтатусСообщения.Важное);
	КонецПопытки;
	
КонецПроцедуры // ИзменитьОбъектПоПараметрам()

Функция ВернутьНастройкуСоответствия(ШаблонТрансляции,СчетИсточник,КоррСчетИсточник,СчетПриемник,ИдентификаторСоответствия) Экспорт
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	СоответствияСчетовДляТрансляции.Ссылка
	|ИЗ
	|	Справочник.СоответствияСчетовДляТрансляции КАК СоответствияСчетовДляТрансляции
	|ГДЕ
	|	СоответствияСчетовДляТрансляции.Владелец = &Владелец
	|	И СоответствияСчетовДляТрансляции.СчетИсточник = &СчетИсточник
	|	И СоответствияСчетовДляТрансляции.СчетПриемник = &СчетПриемник
	|	И СоответствияСчетовДляТрансляции.КоррСчетИсточник = &КоррСчетИсточник
	|	И СоответствияСчетовДляТрансляции.ИдентификаторСоответствия = &ИдентификаторСоответствия";
	
	Запрос.УстановитьПараметр("СчетИсточник"	,СчетИсточник);
	Запрос.УстановитьПараметр("СчетПриемник"	,СчетПриемник);
	Запрос.УстановитьПараметр("КоррСчетИсточник",КоррСчетИсточник);
	Запрос.УстановитьПараметр("Владелец"		,ШаблонТрансляции);
	Запрос.УстановитьПараметр("ИдентификаторСоответствия",ИдентификаторСоответствия);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		
		Возврат Результат.Ссылка;
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	
КонецФункции // ВернутьНастройкуСоответствия()

Процедура ОбновитьАналитикуСоответствия(СчетПриемник) Экспорт
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	СоответствияСчетовДляТрансляции.Ссылка
	|ИЗ
	|	Справочник.СоответствияСчетовДляТрансляции КАК СоответствияСчетовДляТрансляции
	|ГДЕ
	|	СоответствияСчетовДляТрансляции.СчетПриемник = &СчетПриемник";
	
	Запрос.УстановитьПараметр("СчетПриемник",СчетПриемник);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		СправочникОбъект=Результат.Ссылка.ПолучитьОбъект();
		СправочникОбъект.ГруппаРаскрытия=Справочники.ВидыОтчетов.ПолучитьГруппуРаскрытияДляСчета(СправочникОбъект.Владелец,СправочникОбъект.СчетПриемник,,Перечисления.ВидыБухгалтерскихИтогов.ДО);
		СправочникОбъект.ОбменДанными.Загрузка=Истина;
		
		Попытка
			СправочникОбъект.Записать();
		Исключение
			ОбщегоНазначенияУХ.СообщитьОбОшибке(СтрШаблон(Нстр("ru = 'Не удалось обработать соответствие счетов для трансляции%1 шаблона %2:
			|%3'"), СправочникОбъект.Наименование, СправочникОбъект.Владалец, 
			ОписаниеОшибки()),,,СтатусСообщения.Важное);
		КонецПопытки;
		
	КонецЦикла;
			
КонецПроцедуры // ОбновитьАналитикуСоответствия()