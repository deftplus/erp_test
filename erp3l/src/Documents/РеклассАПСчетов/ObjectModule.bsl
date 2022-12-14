#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
		
	ПроведениеСерверУХ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.РеклассАПСчетов.ПодготовитьПараметрыПроведения(ДополнительныеСвойства, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеСерверУХ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	МСФОВызовСервераУХ.СформироватьДвижения(Движения, ДополнительныеСвойства, Отказ);
	ПроведениеСерверУХ.ОбработкаПроведения_ЗаписьИКонтроль(ЭтотОбъект, Отказ);
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	ПроведениеСерверУХ.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ПроведениеСерверУХ.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);	
	
	Если ДанныеЗаполнения = Неопределено Тогда 
		
		ИнициализироватьДокумент();
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда 
		
		Если ДанныеЗаполнения.Свойство("ЗаполнитьДокумент") Тогда
			
			Документы.ВосстановлениеВНАИзРасходов.ЗаполнитьДокумент(ЭтотОбъект);
			
		Иначе	
			ИнициализироватьДокумент();
		КонецЕсли;
					
	ИначеЕсли ТипЗнч(Ссылка) = ТипДанныхЗаполнения Тогда
		
		ИнициализироватьДокумент(ДанныеЗаполнения);		
		
	Иначе
		
		ИнициализироватьДокумент();
		
	КонецЕсли;

	
КонецПроцедуры
	
#Область СлужебныеПроцедурыФункции

Процедура ИнициализироватьДокумент(ДокументИсточник = Неопределено)
	
	МСФОУХ.ОбработкаЗаполнения(ЭтотОбъект, ДокументИсточник);
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
