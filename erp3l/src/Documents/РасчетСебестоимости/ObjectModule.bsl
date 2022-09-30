
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	МСФОУХ.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения);
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУХ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.РасчетСебестоимости.ПодготовитьПараметрыПроведения(ДополнительныеСвойства, Отказ);	
		
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеСерверУХ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
			
	Если ДополнительныеСвойства.ДляПроведения.Реквизиты.ФормироватьПроводкиМСФО Тогда
		ПроведениеСерверУХ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);		
	Иначе	
		МСФОВызовСервераУХ.СформироватьДвижения(Движения, ДополнительныеСвойства, Отказ);
	КонецЕсли;	
	
	ПроведениеСерверУХ.ОбработкаПроведения_ЗаписьИКонтроль(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ПроведениеСерверУХ.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	МСФОВызовСервераУХ.ЗаполнитьДатуДокументаПоКонцуПериодаОтчета(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)	
	ПроведениеСерверУХ.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
КонецПроцедуры

#КонецЕсли

