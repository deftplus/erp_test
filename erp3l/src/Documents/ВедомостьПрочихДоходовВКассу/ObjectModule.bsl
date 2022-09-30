#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ВедомостьПрочихДоходов.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ВедомостьПрочихДоходов.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты)	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ВедомостьПрочихДоходов.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи); 
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ВедомостьПрочихДоходов.ОбработкаПроведения(ЭтотОбъект, Отказ);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыИФункцииЗаполненияДокумента

Функция МожноЗаполнитьВыплаты() Экспорт
	Возврат ВедомостьПрочихДоходов.МожноЗаполнитьВыплаты(ЭтотОбъект)
КонецФункции

Процедура ЗаполнитьВыплаты() Экспорт
	ВедомостьПрочихДоходов.ЗаполнитьВыплаты(ЭтотОбъект);
КонецПроцедуры

Процедура ДополнитьВыплаты(ФизическиеЛица) Экспорт
	ВедомостьПрочихДоходов.ДополнитьВыплаты(ЭтотОбъект, ФизическиеЛица);
КонецПроцедуры

#КонецОбласти

Процедура ЗаполнитьПоТаблицеВыплат(ТаблицаВыплат) Экспорт
	ВедомостьПрочихДоходов.ЗаполнитьПоТаблицеВыплат(ЭтотОбъект, ТаблицаВыплат);
КонецПроцедуры

Процедура ДополнитьПоТаблицеВыплат(ТаблицаВыплат) Экспорт
	ВедомостьПрочихДоходов.ДополнитьПоТаблицеВыплат(ЭтотОбъект, ТаблицаВыплат)
КонецПроцедуры

Процедура ОчиститьСостав() Экспорт
	
	Состав.Очистить();
	Выплаты.Очистить();
	НДФЛ.Очистить();
	Основания.Очистить();
	
КонецПроцедуры	

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли