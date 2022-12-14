
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);	
	
	Если ДанныеЗаполнения = Неопределено Тогда 
		
		ИнициализироватьДокумент(ДанныеЗаполнения);
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда 
		
		Если ДанныеЗаполнения.Свойство("СтруктураДействий") Тогда 
					
		Иначе 
			ИнициализироватьДокумент(ДанныеЗаполнения);			
		КонецЕсли;
		
	Иначе
		
		ИнициализироватьДокумент(ДанныеЗаполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент(ОбъектКопирования);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)	
	ПроведениеСерверУХ.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУХ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.НачислениеАмортизацииВНАМСФО.ПодготовитьПараметрыПроведения(ДополнительныеСвойства, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеСерверУХ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);	
	Документы.НачислениеАмортизацииВНАМСФО.СформироватьДвижения(Движения, ДополнительныеСвойства, Отказ);
	ПроведениеСерверУХ.ОбработкаПроведения_ЗаписьИКонтроль(ЭтотОбъект, Отказ);	
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ПроведениеСерверУХ.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	МСФОУХ.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения);
	ПериодОтчета = ОбщегоНазначенияУХ.ПолучитьПериодПоДате(Дата, Перечисления.Периодичность.Месяц);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЗаполнения

Процедура ЗаполнитьПоДокументамОснованиям(ДокументОснование)
	МСФОВызовСервераУХ.ЗаполнитьДокументИзРежимаНСБУ(ЭтотОбъект, ДокументОснование);
КонецПроцедуры

#КонецОбласти

#КонецЕсли

