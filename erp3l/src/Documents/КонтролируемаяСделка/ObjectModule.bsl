#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Если ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УведомлениеОКонтролируемойСделке) Тогда
		Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УведомлениеОКонтролируемойСделке, "Организация");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Если Не ЗначениеЗаполнено(Валюта) Тогда
			Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если Не СделкаСовершенаЧерезКомиссионера Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Комиссионер");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если НЕ РедактироватьСуммыСделок Тогда
		Если ТипСделки = Перечисления.ТипыКонтролируемыхСделок.ПолученДоход Тогда 
			СуммаДоходов  = Сделки.Итог("Стоимость");
			СуммаРасходов = 0;
		ИначеЕсли ТипСделки = Перечисления.ТипыКонтролируемыхСделок.ОсуществленРасход Тогда 
			СуммаДоходов  = 0;
			СуммаРасходов = Сделки.Итог("Стоимость");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли