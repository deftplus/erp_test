
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗначениеКопирования = Параметры.ЗначениеКопирования;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ЗначениеКопирования) Тогда
		
		Ответ = Неопределено;
		
		Оповещение = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, "Скопировать этапы процессов из шаблона-источника?", РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        ЗначениеКопирования = Неопределено;
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ЗначениеКопирования = ЗначениеКопирования;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗначениеКопирования = ТекущийОбъект.ЗначениеКопирования;
	
КонецПроцедуры



