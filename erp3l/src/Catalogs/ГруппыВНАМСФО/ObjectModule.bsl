
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем ПараметрыКлассовВНА, МодельУчетаВНАКласса;
	
	Если Не ЭтотОбъект.НачислятьАмортизацию Тогда		
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("СчетНакопленнойАмортизации"));
	КонецЕсли;
	
	Если МодельУчетаВНА.Пустая() Тогда
		
		Если Не ДополнительныеСвойства.Свойство("ПараметрыКлассовВНА", ПараметрыКлассовВНА) Тогда
			ПараметрыКлассовВНА = Перечисления.КлассыВНА.ПолучитьПараметры();
		КонецЕсли;
		
		Если ПараметрыКлассовВНА.Получить(КлассВНА).Свойство("МодельУчетаВНА", МодельУчетаВНАКласса) И (МодельУчетаВНАКласса = "НеИспользовать") Тогда
			ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("МодельУчетаВНА"));
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если Не НачислятьАмортизацию Тогда
		ПараметрыУчетаНЗС = ПредопределенноеЗначение("Справочник.ГруппыВНАМСФО.ПустаяСсылка");	
	КонецЕсли;

КонецПроцедуры

