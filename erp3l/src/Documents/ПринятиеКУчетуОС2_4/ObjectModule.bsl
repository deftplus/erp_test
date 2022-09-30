
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокументПередЗаполнением();
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		ЗаполнитьНаОснованииОбъектаЭксплуатации(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыСтроительства") Тогда
		ЗаполнитьНаОснованииОбъектаСтроительства(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ДоговорыАренды") Тогда
		ЗаполнитьНаОснованииДоговораАренды(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПринятиеКУчетуОС2_4") Тогда
		ЗаполнитьНаОснованииПринятияКУчету(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаключениеДоговораАренды") Тогда
		ЗаполнитьНаОснованииЗаключенияДоговораАренды(ДанныеЗаполнения);
	КонецЕсли;
	
	ПринятиеКУчетуОСЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);

	ПараметрыВыбораСтатейИАналитик = Документы.ПринятиеКУчетуОС2_4.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Комментарий = "";
	ДокументОснование = Неопределено;
	ДокументНаОсновании = Ложь;
	ДокументВДругомУчете = Неопределено;
	
	ИнициализироватьДокументПередЗаполнением();
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "ОС");
	
	ПринятиеКУчетуОСЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Истина, Отказ);

	ВспомогательныеРеквизиты = ВспомогательныеРеквизиты();
	ПараметрыРеквизитовОбъекта = 
		ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ПринятиеКУчетуОС(ЭтотОбъект, ВспомогательныеРеквизиты);
	ОбщегоНазначенияУТ.ОтключитьПроверкуЗаполненияРеквизитовОбъекта(ПараметрыРеквизитовОбъекта, МассивНепроверяемыхРеквизитов);
	
	ПроверитьРеквизитыШапки(Отказ);
	ПроверитьОсновныеСредства(МассивНепроверяемыхРеквизитов, Отказ);
	ПроверитьРеквизитыОтражениеРасходов(ПараметрыРеквизитовОбъекта, ПроверяемыеРеквизиты, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ПринятиеКУчетуОСЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ВспомогательныеРеквизиты);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если Не Отказ И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ЗаблокироватьДанные();
		ВнеоборотныеАктивыСлужебный.ПроверитьВозможностьПринятияКУчетуОС(ЭтотОбъект, Отказ);
		ПроверитьПринятиеКУчетуПоДоговоруАренды(Отказ);
	КонецЕсли;
	
	ЗаполнитьРеквизитыПередЗаписью();
	
	ПараметрыВыбораСтатейИАналитик = Документы.ПринятиеКУчетуОС2_4.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "ОС");
	
	ПринятиеКУчетуОСЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ПринятиеКУчетуОСЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ПринятиеКУчетуОСЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ПринятиеКУчетуОСЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Заполнение

Процедура ИнициализироватьДокументПередЗаполнением()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	Если НЕ ЗначениеЗаполнено(ГруппаФинансовогоУчета) Тогда
		ГруппаФинансовогоУчета = Справочники.ГруппыФинансовогоУчетаВнеоборотныхАктивов.ЗначениеПоУмолчанию(Перечисления.ВидыВнеоборотныхАктивов.ОсновноеСредство);
	КонецЕсли; 
	
	ОтражатьВУпрУчете = Истина;
	ОтражатьВРеглУчете = Истина;
	ОтражатьВБУ = Истина;
	ОтражатьВНУ = Истина;
	
	ПараметрыУчетаПоОрганизации = УчетНДСУП.ПараметрыУчетаПоОрганизации(Организация, Дата);
	НалогообложениеНДС = ПараметрыУчетаПоОрганизации.ОсновнойВидДеятельностиНДСЗакупки;
	
	ВнеоборотныеАктивыКлиентСервер.ПриИзмененииРеквизитов_ПринятиеКУчетуОС(
		ЭтотОбъект, 
		ВспомогательныеРеквизиты(), 
		"Организация,ОтражатьВУпрУчете,ОтражатьВРеглУчете");
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Основание)

	Если Основание.Свойство("Дата") Тогда
		Дата = Основание.Дата;
	КонецЕсли;
	
	Если Основание.Свойство("Организация")
		И ЗначениеЗаполнено(Основание.Организация) Тогда
		Организация = Основание.Организация;
	КонецЕсли;

	Если Основание.Свойство("ОсновноеСредство") Тогда
		ЗаполнитьНаОснованииОбъектаЭксплуатации(Основание.ОсновноеСредство);
	ИначеЕсли Основание.Свойство("ОбъектСтроительства") Тогда
		ЗаполнитьНаОснованииОбъектаСтроительства(Основание.ОбъектСтроительства);
	КонецЕсли; 
	
	ПринятиеКУчетуОСЛокализация.ЗаполнитьДокументПоОтбору(ЭтотОбъект, Основание);
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииОбъектаЭксплуатации(ОсновноеСредство)
	
	Если НЕ ЗначениеЗаполнено(ОсновноеСредство) Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоСписокОС = (ТипЗнч(ОсновноеСредство) = Тип("Массив"));
	
	Если НЕ ЭтоСписокОС Тогда
		
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОсновноеСредство, "ЭтоГруппа");
		
		Если РеквизитыОснования.ЭтоГруппа Тогда
			
			ТекстСообщения = НСтр("ru = 'Принятие к учету ОС на основании группы ОС невозможен.
				|Выберите ОС. Для раскрытия группы используйте клавиши Ctrl и стрелку вниз.';
				|en = 'Cannot recognize fixed assets based on fixed assets group.
				|Select fixed assets. To expand the group, press Ctrl+Down.'");
			ВызватьИсключение(ТекстСообщения);
			
		КонецЕсли;
		
		ПервоначальныеСведения = Справочники.ОбъектыЭксплуатации.ПервоначальныеСведения(ОсновноеСредство, Дата);
		Если ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюБУ) 
			И (НЕ ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюНУ)
				ИЛИ НЕ ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюУУ))
			И (ТипЗнч(ПервоначальныеСведения.ДокументВводаВЭксплуатациюБУ) = Тип("ДокументСсылка.ПринятиеКУчетуОС2_4")
				ИЛИ ТипЗнч(ПервоначальныеСведения.ДокументВводаВЭксплуатациюБУ) = Тип("ДокументСсылка.ВводОстатковВнеоборотныхАктивов2_4")) Тогда
	
			Если ТипЗнч(ПервоначальныеСведения.ДокументВводаВЭксплуатациюБУ) = Тип("ДокументСсылка.ПринятиеКУчетуОС2_4") Тогда
				ЗаполнитьНаОснованииПринятияКУчету(ПервоначальныеСведения.ДокументВводаВЭксплуатациюБУ, ОсновноеСредство);
			Иначе
				ЗаполнитьНаОснованииВводаОстатков(ПервоначальныеСведения.ДокументВводаВЭксплуатациюБУ, ОсновноеСредство);
			КонецЕсли;
		
			Возврат;
			
		ИначеЕсли ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюНУ) 
			И (НЕ ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюБУ)
				ИЛИ НЕ ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюУУ))
			И (ТипЗнч(ПервоначальныеСведения.ДокументВводаВЭксплуатациюБУ) = Тип("ДокументСсылка.ПринятиеКУчетуОС2_4")
				ИЛИ ТипЗнч(ПервоначальныеСведения.ДокументВводаВЭксплуатациюБУ) = Тип("ДокументСсылка.ВводОстатковВнеоборотныхАктивов2_4")) Тогда
				
			Если ТипЗнч(ПервоначальныеСведения.ДокументВводаВЭксплуатациюНУ) = Тип("ДокументСсылка.ПринятиеКУчетуОС2_4") Тогда
				ЗаполнитьНаОснованииПринятияКУчету(ПервоначальныеСведения.ДокументВводаВЭксплуатациюНУ, ОсновноеСредство);
			Иначе
				ЗаполнитьНаОснованииВводаОстатков(ПервоначальныеСведения.ДокументВводаВЭксплуатациюНУ, ОсновноеСредство);
			КонецЕсли;
			
			Возврат;
			
		ИначеЕсли ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюУУ) 
			И (НЕ ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюБУ)
				ИЛИ НЕ ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюНУ))
			И (ТипЗнч(ПервоначальныеСведения.ДокументВводаВЭксплуатациюУУ) = Тип("ДокументСсылка.ПринятиеКУчетуОС2_4")
				ИЛИ ТипЗнч(ПервоначальныеСведения.ДокументВводаВЭксплуатациюУУ) = Тип("ДокументСсылка.ВводОстатковВнеоборотныхАктивов2_4")) Тогда
				
			Если ТипЗнч(ПервоначальныеСведения.ДокументВводаВЭксплуатациюУУ) = Тип("ДокументСсылка.ПринятиеКУчетуОС2_4") Тогда
				ЗаполнитьНаОснованииПринятияКУчету(ПервоначальныеСведения.ДокументВводаВЭксплуатациюУУ, ОсновноеСредство);
			Иначе
				ЗаполнитьНаОснованииВводаОстатков(ПервоначальныеСведения.ДокументВводаВЭксплуатациюУУ, ОсновноеСредство);
			КонецЕсли;
			
			Возврат;
			
		ИначеЕсли ПервоначальныеСведения.СостояниеУУ = Перечисления.СостоянияОС.ПринятоКУчету
					И ПервоначальныеСведения.СостояниеБУ = Перечисления.СостоянияОС.ПринятоКУчету
					И ПервоначальныеСведения.СостояниеНУ = Перечисления.СостоянияОС.ПринятоКУчету
				ИЛИ ПервоначальныеСведения.СостояниеУУ = Перечисления.СостоянияОС.ПринятоКЗабалансовомуУчету
				ИЛИ ПервоначальныеСведения.СостояниеБУ = Перечисления.СостоянияОС.ПринятоКЗабалансовомуУчету
				ИЛИ ПервоначальныеСведения.СостояниеУУ = Перечисления.СостоянияОС.ПринятоКУчету
					И НЕ ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА() Тогда
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Основное средство ""%1"" уже принято к учету.';
											|en = 'The ""%1"" fixed asset is already recognized.'"), Строка(ОсновноеСредство));
			ВызватьИсключение ТекстСообщения;
			
		КонецЕсли; 
	

		СтрокаТабличнойЧасти = ОС.Добавить();
		СтрокаТабличнойЧасти.ОсновноеСредство = ОсновноеСредство;
		
	Иначе
		Для Каждого ЭлементМассива Из ОсновноеСредство Цикл
			СтрокаТабличнойЧасти = ОС.Добавить();
			СтрокаТабличнойЧасти.ОсновноеСредство = ЭлементМассива;
		КонецЦикла;
	КонецЕсли;
	
	Документы.ПринятиеКУчетуОС2_4.ЗаполнитьСтоимость(ЭтотОбъект);
	
	ПринятиеКУчетуОСЛокализация.ЗаполнитьНаОснованииОбъектаЭксплуатации(ЭтотОбъект, ОсновноеСредство);
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииОбъектаСтроительства(ОбъектСтроительстваОснование)

	Если НЕ ЗначениеЗаполнено(ОбъектСтроительстваОснование) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектСтроительстваОснование, "ЭтоГруппа") Тогда
		
		ТекстСообщения = НСтр("ru = 'Принятие к учету ОС на основании группы объектов строительства невозможен.
			|Выберите объект строительства. Для раскрытия группы используйте клавиши Ctrl и стрелку внизю';
			|en = 'Cannot recognize fixed assets based on assets under construction group.
			|Select an asset under construction. To expand the group, press Ctrl+Down'");
		ВызватьИсключение(ТекстСообщения);
		
	КонецЕсли;
	
	ВидАналитикиКапитализацииРасходов = Перечисления.ВидыАналитикиКапитализацииРасходов.ОбъектСтроительства;
	ОбъектСтроительства = ОбъектСтроительстваОснование;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииПринятияКУчету(Основание, ОсновноеСредство = Неопределено)

	ОснованиеОбъект = Основание.ПолучитьОбъект();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ОснованиеОбъект,, "Номер,Дата,ВерсияДанных,Ответственный,ПометкаУдаления,Проведен");
	
	ДокументВДругомУчете = Основание;
	
	Если НЕ ЗначениеЗаполнено(ОсновноеСредство) Тогда
		Для каждого СтрокаОснования Из ОснованиеОбъект.ОС Цикл
			СтрокаТабличнойЧасти = ОС.Добавить();
			СтрокаТабличнойЧасти.ОсновноеСредство = СтрокаОснования.ОсновноеСредство;
		КонецЦикла; 
		ОС.Загрузить(ОснованиеОбъект.ОС.Выгрузить());
	Иначе
		СтрокаТабличнойЧасти = ОС.Добавить();
		СтрокаТабличнойЧасти.ОсновноеСредство = ОсновноеСредство;
	КонецЕсли; 
	
	Если ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА() Тогда
		ОтражатьВБУ = НЕ ОснованиеОбъект.ОтражатьВБУ;
		ОтражатьВНУ = НЕ ОснованиеОбъект.ОтражатьВНУ;
		ОтражатьВУпрУчете = НЕ ОснованиеОбъект.ОтражатьВУпрУчете;
	Иначе	
		ОтражатьВУпрУчете = Истина;
		ОтражатьВБУ = Истина;
		ОтражатьВНУ = Истина;
	КонецЕсли;
	
	ОтражатьВРеглУчете = ОтражатьВБУ ИЛИ ОтражатьВНУ;
	
	Документы.ПринятиеКУчетуОС2_4.ЗаполнитьСтоимость(ЭтотОбъект);
	
	ПринятиеКУчетуОСЛокализация.ЗаполнитьНаОснованииПринятияКУчетуИлиВводаОстатков(ЭтотОбъект, Основание);
	
	ОчиститьНеиспользуемыеРеквизиты();
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииВводаОстатков(Основание, ОсновноеСредство)

	ОснованиеОбъект = Основание.ПолучитьОбъект();
	
	СтрокаОС = ОснованиеОбъект.ОС.Найти(ОсновноеСредство, "ОсновноеСредство");
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ОснованиеОбъект,, "Номер,Дата,ВерсияДанных,Ответственный,ПометкаУдаления,Проведен,ХозяйственнаяОперация");
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтрокаОС);
	
	ДокументВДругомУчете = Основание;
	
	СтрокаТабличнойЧасти = ОС.Добавить();
	СтрокаТабличнойЧасти.ОсновноеСредство = ОсновноеСредство;
	
	Если ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА() Тогда
		
		Если ОснованиеОбъект.ОтражатьВРеглУчете 
			И НЕ ОснованиеОбъект.ОтражатьВУпрУчете Тогда
			ОтражатьВРеглУчете = Ложь;
			ОтражатьВБУ = Ложь;
			ОтражатьВНУ = Ложь;
			ОтражатьВУпрУчете  = Истина;
		Иначе
			ОтражатьВРеглУчете = Истина;
			ОтражатьВБУ = Истина;
			ОтражатьВНУ = Истина;
			ОтражатьВУпрУчете  = Ложь;
		КонецЕсли;
		 
	Иначе	
		ОтражатьВРеглУчете = Истина;
		ОтражатьВУпрУчете  = Истина;
		ОтражатьВБУ = Истина;
		ОтражатьВНУ = Истина;
	КонецЕсли;
	
	Документы.ПринятиеКУчетуОС2_4.ЗаполнитьСтоимость(ЭтотОбъект);
	
	ПринятиеКУчетуОСЛокализация.ЗаполнитьНаОснованииПринятияКУчетуИлиВводаОстатков(ЭтотОбъект, Основание);
	
	ОчиститьНеиспользуемыеРеквизиты();
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииДоговораАренды(Основание)
	
	Если НЕ ЗначениеЗаполнено(Основание) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	УсловияДоговоровАренды.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрСведений.УсловияДоговоровАренды.СрезПервых(, Договор = &Основание) КАК УсловияДоговоровАренды
	|ГДЕ
	|	УсловияДоговоровАренды.Регистратор ССЫЛКА Документ.ЗаключениеДоговораАренды";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Основание", Основание);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'Не оформлено заключение договора, принятие к учету недоступно';
								|en = 'The contract signing has not been registered, recognition is not available'");
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьНаОснованииЗаключенияДоговораАренды(Выборка.Регистратор);
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииЗаключенияДоговораАренды(Основание)
	
	Если Не ЗначениеЗаполнено(Основание) Тогда
		Возврат;
	КонецЕсли;

	ТекстОшибки = Документы.ПринятиеКУчетуОС2_4.ЗаполнитьНаОснованииЗаключенияДоговораАренды(ЭтотОбъект, Основание);
	
	Если ТекстОшибки <> Неопределено Тогда
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаЗаполнения

Процедура ПроверитьРеквизитыШапки(Отказ)

	ПринятиеКУчетуОСЛокализация.ПроверитьРеквизитыШапки(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПроверитьОсновныеСредства(МассивНепроверяемыхРеквизитов, Отказ)

	ВедетсяРегламентированныйУчетВНА = ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА();
	
	ВнеоборотныеАктивы.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", "ОсновноеСредство", Отказ);
	ВнеоборотныеАктивыСлужебный.ПроверитьРеквизитыОСПриПринятииКУчету(ЭтотОбъект, "ОС", Отказ);
	
	Если ВедетсяРегламентированныйУчетВНА Тогда
		ШаблонСообщенияЛиквидационнаяСтоимость = НСтр("ru = 'Ликвидационная стоимость в строке %1 должна быть меньше стоимости по упр. учету';
														|en = 'Residual value in line %1 must be less than the cost in man. accounting'");
	Иначе
		ШаблонСообщенияЛиквидационнаяСтоимость = НСтр("ru = 'Ликвидационная стоимость в строке %1 должна быть меньше стоимости в валюте упр. учета';
														|en = 'Residual value in line %1 must be less than the cost in the currency of man. accounting'");
	КонецЕсли; 
	
	ПроверятьСтоимостьБУ = (МассивНепроверяемыхРеквизитов.Найти("ОС.СтоимостьБУ") = Неопределено);
	ПроверятьСтоимостьУУ = (МассивНепроверяемыхРеквизитов.Найти("ОС.СтоимостьУУ") = Неопределено);
	
	ПредставлениеРеквизитов = Документы.ПринятиеКУчетуОС2_4.ПредставлениеРеквизитов(Организация);
	
	ШаблонСообщения = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""Основные средства""';
							|en = 'The ""%1"" column in %2 line of the ""Fixed assets"" list is not filled in'");
	
	Для каждого ДанныеСтроки Из ОС Цикл
		
		НомерСтроки = Формат(ДанныеСтроки.НомерСтроки, "ЧГ=");
		
		Если ПроверятьСтоимостьБУ
			И ДанныеСтроки.СтоимостьБУ = 0 Тогда
			
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ПредставлениеРеквизитов.Получить("ОС.СтоимостьБУ"), НомерСтроки);
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "СтоимостьБУ");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
		КонецЕсли;
		
		Если ПроверятьСтоимостьУУ
			И ДанныеСтроки.СтоимостьУУ = 0 Тогда
			
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ПредставлениеРеквизитов.Получить("ОС.СтоимостьУУ"), НомерСтроки);
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "СтоимостьУУ");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
		КонецЕсли;
		
		Если ДанныеСтроки.ЛиквидационнаяСтоимость >= ДанныеСтроки.СтоимостьУУ 
			И ДанныеСтроки.СтоимостьУУ <> 0
			И ОтражатьВУпрУчете Тогда
			
			ТекстСообщения = СтрШаблон(ШаблонСообщенияЛиквидационнаяСтоимость, НомерСтроки);
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "ЛиквидационнаяСтоимость");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
			
		КонецЕсли;
		
	КонецЦикла; 
	
	МассивНепроверяемыхРеквизитов.Добавить("ОС.СтоимостьБУ");
	МассивНепроверяемыхРеквизитов.Добавить("ОС.СтоимостьУУ");
	
КонецПроцедуры

Процедура ПроверитьРеквизитыОтражениеРасходов(ПараметрыРеквизитовОбъекта, ПроверяемыеРеквизиты, Отказ)

	ПараметрыВыбораСтатейИАналитик = Документы.ПринятиеКУчетуОС2_4.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ПроверитьПринятиеКУчетуПоДоговоруАренды(Отказ)

	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ПринятиеКУчетуПредметовАренды Тогда
		Возврат;
	КонецЕсли;
	
	СписокОС = Новый Массив;
	Для Каждого ДанныеСтроки Из ОС Цикл
		Если ЗначениеЗаполнено(ДанныеСтроки.ОсновноеСредство) Тогда
			СписокОС.Добавить(ДанныеСтроки.ОсновноеСредство);
		КонецЕсли;
	КонецЦикла;
	
	Если СписокОС.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(АрендованныеОС.Период) КАК Дата
	|ИЗ
	|	РегистрСведений.АрендованныеОС КАК АрендованныеОС
	|ГДЕ
	|	АрендованныеОС.ОсновноеСредство В(&СписокОС)
	|	И АрендованныеОС.Период >= &Дата
	|	И АрендованныеОС.Активность
	|	И АрендованныеОС.Регистратор ССЫЛКА Документ.ЗаключениеДоговораАренды
	|
	|ИМЕЮЩИЕ
	|	ЕСТЬNULL(МАКСИМУМ(АрендованныеОС.Период), ДАТАВРЕМЯ(1, 1, 1)) <> ДАТАВРЕМЯ(1, 1, 1)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОбъектыЭксплуатации.Ссылка КАК Ссылка,
	|	ОбъектыЭксплуатации.Представление КАК Представление
	|ИЗ
	|	Справочник.ОбъектыЭксплуатации КАК ОбъектыЭксплуатации
	|ГДЕ
	|	ОбъектыЭксплуатации.Ссылка В (&СписокОС)
	|	И НЕ ОбъектыЭксплуатации.Ссылка В (
	|		ВЫБРАТЬ
	|			АрендованныеОС.ОсновноеСредство
	|		ИЗ
	|			РегистрСведений.АрендованныеОС.СрезПоследних(&Дата, Регистратор <> &Ссылка И ОсновноеСредство В (&СписокОС)) КАК АрендованныеОС
	|		ГДЕ
	|			АрендованныеОС.Состояние В (
	|				ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ЗаключенДоговорАренды),
	|				ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ВАренде))
	|			И (АрендованныеОС.Договор = &Договор 
	|				ИЛИ &Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыАренды.ПустаяСсылка)))";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("СписокОС", СписокОС);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Выборка = Результат[Результат.ВГраница()-1].Выбрать();
	Если Выборка.Следующий() Тогда
		ТекстСообщения = НСтр("ru = 'Дата принятия к учету должна быть позже даты заключения договора аренды %1';
								|en = 'The recognition date must be later than the lease contract signing date %1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.Дата);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Дата",, Отказ); 
	КонецЕсли;	
	
	Выборка = Результат[Результат.ВГраница()].Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеСтроки = ОС.Найти(Выборка.Ссылка, "ОсновноеСредство");
		ТекстСообщения = НСтр("ru = 'Основное средство ""%1"" не указано при заключении договора аренды';
								|en = 'Fixed asset ""%1"" is not specified when signing a lease contract'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.Представление);
		Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "ОсновноеСредство");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
	КонецЦикла;	

	ПринятиеКУчетуОСЛокализация.ПроверитьПринятиеКУчетуПоДоговоруАрендыПередЗаписью(ЭтотОбъект, Отказ);
		
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ЗаблокироватьДанные()

	Блокировка = Новый БлокировкаДанных;
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.АрендованныеОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ОС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.МестонахождениеОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ОС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
	
	Блокировка.Заблокировать(); 
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПередЗаписью()

	ОчиститьНеиспользуемыеРеквизиты();
	
	Если ОтражатьВУпрУчете И ОтражатьВРеглУчете Тогда
		ДокументВДругомУчете = Неопределено;
	КонецЕсли;
	
	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	
	Для каждого ДанныеСтроки Из ОС Цикл
		
		Если НЕ ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА()
			И ВалютаУпр = ВалютаРегл Тогда
		
			ДанныеСтроки.СтоимостьУУ = ДанныеСтроки.СтоимостьБУ;
		
		КонецЕсли; 
	
		Если ВалютаУпр = ВалютаРегл Тогда
			ДанныеСтроки.ЛиквидационнаяСтоимость = ДанныеСтроки.ЛиквидационнаяСтоимостьРегл;
		КонецЕсли;
		
	КонецЦикла; 
	
КонецПроцедуры

Процедура ОчиститьНеиспользуемыеРеквизиты()
	
	ВспомогательныеРеквизиты = ВспомогательныеРеквизиты();
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ПринятиеКУчетуОС(ЭтотОбъект, ВспомогательныеРеквизиты);
	ОбщегоНазначенияУТКлиентСервер.ОчиститьНеиспользуемыеРеквизиты(ЭтотОбъект, ПараметрыРеквизитовОбъекта, "ОС,ЦелевоеФинансирование");

КонецПроцедуры

Функция ВспомогательныеРеквизиты()
	
	ВспомогательныеРеквизиты = Новый Структура;
	ВспомогательныеРеквизиты.Вставить("ИспользоватьРеглУчет", РеглУчетСервер.ВедетсяРеглУчет(Дата));
	ВспомогательныеРеквизиты.Вставить("ИспользоватьОбъектыСтроительства", ПолучитьФункциональнуюОпцию("ИспользоватьОбъектыСтроительства"));
	ВспомогательныеРеквизиты.Вставить("ОтражатьВРеглУчете", ОтражатьВРеглУчете);
	ВспомогательныеРеквизиты.Вставить("ОтражатьВУпрУчете", ОтражатьВУпрУчете);
	ВспомогательныеРеквизиты.Вставить("ОтражатьВБУ", ОтражатьВБУ);
	ВспомогательныеРеквизиты.Вставить("ОтражатьВНУ", ОтражатьВНУ);
	ВспомогательныеРеквизиты.Вставить("ВедетсяРегламентированныйУчетВНА", ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА());
	ВспомогательныеРеквизиты.Вставить("ПлательщикНалогаНаПрибыль", Ложь);
	ВспомогательныеРеквизиты.Вставить("ПрименяетсяУСНДоходыМинусРасходы", Ложь);

	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	ВспомогательныеРеквизиты.Вставить("ВалютыСовпадают", ВалютаУпр = ВалютаРегл);
	
	ВспомогательныеРеквизиты.Вставить(
		"ЕстьУчетСебестоимости", 
		РасчетСебестоимостиПовтИсп.ФормироватьДвиженияПоРегистрамСебестоимости(Дата, Ложь));
	
	ПринятиеКУчетуОСЛокализация.ДополнитьВспомогательныеРеквизиты(ЭтотОбъект, ВспомогательныеРеквизиты);
	
	Возврат ВспомогательныеРеквизиты;

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
