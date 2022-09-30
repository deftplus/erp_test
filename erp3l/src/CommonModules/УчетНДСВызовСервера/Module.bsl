#Область СлужебныйПрограммныйИнтерфейс

// См. Перечисления.ВариантыРасширенногоПервогоНалоговогоПериода.БлижайшийНалоговыйПериод.
Функция БлижайшийНалоговыйПериодСервер(Организация, Период) Экспорт
	
	Возврат УчетНДСПереопределяемый.БлижайшийНалоговыйПериод(
		Организация,
		Период);
	
КонецФункции

Функция ПолучитьИдентификаторМакетаРасшифровкиДекларацииПоНДС(Знач ПараметрыОтчета, Знач Показатель, ПользовательскиеНастройки) Экспорт
	
	ИдентификаторМакета = "";
	
	ТаблицаРасшифровок = ПолучитьИзВременногоХранилища(ПараметрыОтчета.АдресВременногоХранилищаРасшифровки);
	
	Если ТипЗнч(ТаблицаРасшифровок) = Тип("ТаблицаЗначений") Тогда
		
		НомерТекущейСтраницы = 0;
		
		ПараметрыОтчета.Свойство("НомерТекущейСтраницы", НомерТекущейСтраницы);
		
		Если НомерТекущейСтраницы = Неопределено ИЛИ НомерТекущейСтраницы = 0 Тогда
			ИмяПоказателя = Показатель;
		Иначе
			ИмяПоказателя = Показатель + "_" + НомерТекущейСтраницы;
		КонецЕсли;
		
		Расшифровка = ТаблицаРасшифровок.Найти(ИмяПоказателя,"ИмяПоказателя");
		
		Если Расшифровка <> Неопределено Тогда
			
			ДополнительныеПараметры = Расшифровка.ДополнительныеПараметры;
			
			ИдентификаторМакета = ДополнительныеПараметры.ИдентификаторМакета;
			
			Если ИдентификаторМакета = "ОткрытьОбъект" Тогда
				
				ДополнительныеПараметры.Свойство("Объект", ИдентификаторМакета);
				
			Иначе
				
				ДополнительныеПараметры.Свойство("ПользовательскиеНастройки", ПользовательскиеНастройки);
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Возврат ИдентификаторМакета;
	
КонецФункции  

#КонецОбласти
