#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИдентификаторДокументооборота = "";
	ЗаполнитьОтветственного();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		ЗаполнитьОтветственного();
	КонецЕсли;
	
	Если Не ЭтоНовый()
		И ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления") Тогда
		ДополнительныеСвойства.Вставить("УстановкаПометкиУдаления", Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеСвойства, "УстановкаПометкиУдаления", Ложь) Тогда
		ЭлектронныеДокументыЭДО.ПриУстановкеПометкиУдаленияДокумента(Ссылка, ПометкаУдаления, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЭлектронныеДокументыЭДО.ПередУдалениемДокумента(Ссылка, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Если Не ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	
	ИспользуетсяНесколькоОрганизаций = ОбщегоНазначенияБЭД.ИспользуетсяНесколькоОрганизаций();
	Если Не ИспользуетсяНесколькоОрганизаций И НЕ ЗначениеЗаполнено(Организация) Тогда
		Организация = ОбщегоНазначенияБЭД.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьОтветственного()
	
	Ответственный = ИнтеграцияЭДО.ОтветственныйПоДокументуЭДО(Организация, Контрагент, ДоговорКонтрагента);
	
КонецПроцедуры

#КонецОбласти

#Иначе
	
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
							|en = 'Invalid object call on the client.'");
	
#КонецЕсли