#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	Если НЕ ЭтоГруппа Тогда
		СерийныйНомер="";
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроверитьВозможностьЗаписи(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьВозможностьЗаписи(Отказ)
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МобильныеКомпьютеры.Ссылка
	|ИЗ
	|	Справочник.МобильныеКомпьютеры КАК МобильныеКомпьютеры
	|ГДЕ
	|	МобильныеКомпьютеры.СерийныйНомер = &СерийныйНомер
	|	И МобильныеКомпьютеры.Ссылка <> &Ссылка"
	;
	
	Запрос = Новый Запрос();
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("СерийныйНомер", СерийныйНомер);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ТекстСообщения = НСтр("ru = 'Мобильный компьютер с указанным серийным номером уже имеется в справочнике';
								|en = 'Mobile computer with the specified serial number already exists in the catalog'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "СерийныйНомер",, Отказ);
	КонецЕсли;
	
КонецПроцедуры
	
#КонецОбласти

#КонецЕсли