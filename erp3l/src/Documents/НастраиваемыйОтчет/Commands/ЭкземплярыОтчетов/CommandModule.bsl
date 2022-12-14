
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Отбор", ПолучитьОтборСписка(ПараметрКоманды));
	
	ОткрытьФорму("Документ.НастраиваемыйОтчет.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, Истина, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьОтборСписка(Знач ПараметрКоманды)
	
	Отбор = Новый Структура;
	
	Если Не ЗначениеЗаполнено(ПараметрКоманды) Тогда
		Возврат Отбор; 
	КонецЕсли;
	
	ТипПараметра = ТипЗнч(ПараметрКоманды[0]);
	
	Если ТипПараметра = Тип("СправочникСсылка.Организации") Тогда
		Отбор.Вставить("Организация", ПараметрКоманды);
	ИначеЕсли ТипПараметра = Тип("СправочникСсылка.Периоды") Тогда
		Отбор.Вставить("ПериодОтчета", ПараметрКоманды);
	ИначеЕсли ТипПараметра = Тип("СправочникСсылка.Сценарии") Тогда
		Отбор.Вставить("Сценарий", ПараметрКоманды);
	ИначеЕсли ТипПараметра = Тип("СправочникСсылка.ВидыОтчетов") Тогда
		Отбор.Вставить("ВидОтчета", ПараметрКоманды);
	ИначеЕсли ТипПараметра = Тип("СправочникСсылка.БланкиОтчетов") Тогда
		Отбор.Вставить("ШаблонОтчета", ПараметрКоманды);
	ИначеЕсли ТипПараметра = Тип("СправочникСсылка.ХранимыеФайлыОрганизаций") Тогда
		Отбор.Вставить("ФайлИмпорта", ПараметрКоманды);
	ИначеЕсли ТипПараметра = Тип("СправочникСсылка.ПравилаОбработки") Тогда
		Отбор.Вставить("ПравилоОбработки", ПараметрКоманды);
	ИначеЕсли ТипПараметра = Тип("СправочникСсылка.ВнешниеИнформационныеБазы") Тогда
		Отбор.Вставить("ИспользуемаяИБ", ПараметрКоманды);
	ИначеЕсли ТипПараметра = Тип("СправочникСсылка.ПравилаПроверки") Тогда
		Отбор.Вставить("ПравилоПроверки", ПараметрКоманды);
	ИначеЕсли ТипПараметра = Тип("СправочникСсылка.Проекты") Тогда
		Отбор.Вставить("Проект", ПараметрКоманды);
	КонецЕсли;
	
	Возврат Отбор;
	
КонецФункции

