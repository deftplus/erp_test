
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);	
	
	Если ДанныеЗаполнения = Неопределено Тогда 
		
		ИнициализироватьДокумент();
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда 
		
		Если ДанныеЗаполнения.Свойство("СтруктураДействий") Тогда 
			
			Документы.ВводВНАВЭксплуатациюМСФО.ЗаполнитьСтроки(ЭтотОбъект.ВНА, ЭтотОбъект, ДанныеЗаполнения.СтруктураДействий);
		
		ИначеЕсли ДанныеЗаполнения.Свойство("ИсточникЗаполнения") 
			И ДанныеЗаполнения.ИсточникЗаполнения = "ДанныеНСБУ" Тогда
			
			ЗаполнитьИзПодсистемыНСБУ(Неопределено);
			
		ИначеЕсли ДанныеЗаполнения.Свойство("АдресТаблицы") Тогда
			
			МСФОВызовСервераУХ.ЗаполнитьПоТаблицеЗагрузки(ЭтотОбъект, ДанныеЗаполнения);
			
		ИначеЕсли ДанныеЗаполнения.Свойство("ИсточникЗаполнения")
			И ДанныеЗаполнения.ИсточникЗаполнения = "ДокументыОснования" Тогда
			
			ЗаполнитьПоОснованиям(ДокументыОснования.ВыгрузитьКолонку("ДокументОснование"));
			
		Иначе
			
			ИнициализироватьДокумент();
			
		КонецЕсли;	
		
	ИначеЕсли ТипЗнч(Ссылка) = ТипДанныхЗаполнения Тогда
		
		ИнициализироватьДокумент(ДанныеЗаполнения);
		ЗаполнитьПоОснованиям(ДанныеЗаполнения, Истина);
		
	ИначеЕсли Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		
		ЗаполнитьПоОснованиям(ДанныеЗаполнения);
		
	Иначе
		
		ИнициализироватьДокумент();
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	НепроверяемыеРеквизиты = Новый Массив;
	НепроверяемыеРеквизиты.Добавить("ВНА.СпособНачисленияАмортизацииМСФО");
	НепроверяемыеРеквизиты.Добавить("ВНА.СрокПолезногоИспользованияМСФО");
	НепроверяемыеРеквизиты.Добавить("ВНА.КоэффициентУскоренияМСФО");
	НепроверяемыеРеквизиты.Добавить("ВНА.ОбъемВыработкиМСФО");
	НепроверяемыеРеквизиты.Добавить("ВНА.ПараметрВыработкиМСФО");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	МСФОВНАВызовСервераУХ.ОбновитьПроверяемыеРеквизитыТаблицыПоРежимуЗаполнения(ПроверяемыеРеквизиты, ЭтотОбъект, "ВНА");
	// Проверим заполнение полей СПИ в таб части.
	// -Определим режим заполнения.
	ЕстьРежимМСФО = Ложь;
	ТекРежим = ЭтотОбъект.РежимЗаполнения;
	Если ТекРежим = Перечисления.РежимЗаполненияВидовУчета.НСБУ Тогда
		ЕстьРежимМСФО = Ложь;
	ИначеЕсли ТекРежим = Перечисления.РежимЗаполненияВидовУчета.МСФО Тогда
		ЕстьРежимМСФО = Истина;
	ИначеЕсли ТекРежим = Перечисления.РежимЗаполненияВидовУчета.НСБУИМСФО Тогда
		ЕстьРежимМСФО = Истина;
	ИначеЕсли ТекРежим = Перечисления.РежимЗаполненияВидовУчета.ПустаяСсылка() Тогда
		ЕстьРежимМСФО = Ложь;
	Иначе
		ЕстьРежимМСФО = Ложь;
		ТекстСообщения = НСтр("ru = 'Неизвестный режим заполнения видов учёта: %Режим%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Режим%", Строка(ТекРежим));
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
	КонецЕсли;
	
	// -Проверим таб части на заполнение СПИ.
	Если Не ЕстьРежимМСФО Тогда
		Возврат; // Не проверяем СПИ в части МСФО.
	КонецЕсли;
	
	СпособНачисленияПропорционально = Перечисления.СпособыНачисленияАмортизацииВНА.ПропорциональноОбъемуПродукции;	
	Для Каждого ТекВНА Из ЭтотОбъект.ВНА Цикл
		
		Если Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекВНА.ГруппаВНА, "НачислятьАмортизацию") Тогда 
			Продолжить;
		ИначеЕсли ТекВНА.СпособНачисленияАмортизацииМСФО.Пустая() Тогда
			
			Отказ = Истина;
			ТекстСообщения = НСтр("ru = 'Для ВНА %ВНА% не указан <Способ начисления амортизации (МСФО)>. Операция отменена.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВНА%", Строка(ТекВНА.ВНА));
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
			Продолжить;
			
		КонецЕсли;
		
		НачислениеПропорционально = (ТекВНА.СпособНачисленияАмортизацииМСФО = СпособНачисленияПропорционально);
		Если (НЕ НачислениеПропорционально) И (НЕ ЗначениеЗаполнено(ТекВНА.СрокПолезногоИспользованияМСФО)) Тогда
			
			Отказ = Истина;
			ТекстСообщения = НСтр("ru = 'Для ВНА %ВНА% не указан срок полезного использования по МСФО. Операция отменена.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВНА%", Строка(ТекВНА.ВНА));
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
			
		ИначеЕсли НачислениеПропорционально Тогда 
			
			Если Не ЗначениеЗаполнено(ТекВНА.ОбъемВыработкиМСФО) Тогда
				
				Отказ = Истина;
				ТекстСообщения = НСтр("ru = 'Для ВНА %ВНА% не указан объем выработки по МСФО. Операция отменена.'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВНА%", Строка(ТекВНА.ВНА));
				ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
				
			КонецЕсли;
			
			Если ТекВНА.ПараметрВыработкиМСФО.Пустая() Тогда
				
				Отказ = Истина;
				ТекстСообщения = НСтр("ru = 'Для ВНА %ВНА% не указан параметр выработки по МСФО. Операция отменена.'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВНА%", Строка(ТекВНА.ВНА));
				ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
				
			КонецЕсли;
						
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
		
	ПроведениеСерверУХ.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУХ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	ПараметрыПроведения = Документы.ВводВНАВЭксплуатациюМСФО.ПодготовитьПараметрыПроведения(ДополнительныеСвойства, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Документы.ВводВНАВЭксплуатациюМСФО.СформироватьДвижения(Движения, ДополнительныеСвойства, Отказ);
	
	ПроведениеСерверУХ.ОбработкаПроведения_ЗаписьИКонтроль(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)	
	ПроведениеСерверУХ.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыФункции

Процедура ИнициализироватьДокумент(ДокументИсточник = Неопределено)
	
	Если ДокументИсточник <> Неопределено Тогда
		
		СвойстваЗаполнения = "Организация,Сценарий,КлассВНА";
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДокументИсточник, СвойстваЗаполнения);
		ЭтотОбъект.РежимЗаполнения = Перечисления.РежимЗаполненияВидовУчета.МСФО;
		
	КонецЕсли;
	
	МСФОУХ.ОбработкаЗаполнения(ЭтотОбъект, ДокументИсточник, РежимЗаполнения);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЗаполнения

Процедура ЗаполнитьПоОснованиям(МассивДокументыОснования, ЗаполнитьДокумент = Ложь)
	
	Если ЭтотОбъект.РежимЗаполнения = ПредопределенноеЗначение("Перечисление.РежимЗаполненияВидовУчета.МСФО") Тогда
	
		Если ЗаполнитьДокумент Тогда
			МСФОВызовСервераУХ.ЗаполнитьКонтекстПоОснованиям(ЭтотОбъект, МассивДокументыОснования);
		КонецЕсли;
		
		МСФОВызовСервераУХ.ЗаполнитьДокументИзРежимаНСБУ(
								ЭтотОбъект, 
								МассивДокументыОснования, 
								"ВНА");
								
	Иначе
		ЗаполнитьИзПодсистемыНСБУ(МассивДокументыОснования);
	КонецЕсли;	
		
КонецПроцедуры

Процедура ЗаполнитьИзПодсистемыНСБУ(ДокументыОснованияИсточник = Неопределено)
	
	ПараметрыЗаполнения = МСФОКлиентСерверУХ.ПолучитьПараметрыЗаполнения(ЭтотОбъект, ДокументыОснованияИсточник);
	ИсточникЗаполнения = МСФОВНАУХ.ПолучитьДанные_ВводВЭксплуатациюВНА(ПараметрыЗаполнения);
	
	ЭтотОбъект.ВНА.Загрузить(ИсточникЗаполнения.ВНА);
	ЭтотОбъект.ДокументыОснования.Загрузить(ИсточникЗаполнения.ДокументыОснования);
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли