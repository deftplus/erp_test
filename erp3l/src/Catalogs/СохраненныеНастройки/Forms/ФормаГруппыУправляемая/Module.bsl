
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ЗначениеЗаполнено(ТекущийОбъект.Владелец) Тогда
		ТекущийОбъект.Владелец = ОбщегоНазначенияУХ.ПолучитьЗначениеПеременной("глТекущийПользователь");
	КонецЕсли;

КонецПроцедуры
