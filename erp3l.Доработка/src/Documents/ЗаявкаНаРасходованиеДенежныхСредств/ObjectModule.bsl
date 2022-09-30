
&После("ОбработкаЗаполнения")
Процедура ллл_ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	// +++ 3L, Конилов Д.А. [07.06.2022] Задача ERP1C-112, ERP1C-119
	// Дозаполнение заявок на оплату
	// --- 3L, Конилов Д.А. [07.06.2022] Задача ERP1C-112, ERP1C-119 
	
	
	Если ДанныеЗаполнения.Свойство("ДокументОснование")=ложь тогда
		возврат;
	КонецЕсли;
		
	ТипОснования=типЗнч(ДанныеЗаполнения.ДокументОснование);
	
	Если ТипОснования=тип("ДокументСсылка.ЗаказПоставщику") или ТипОснования=тип("ДокументСсылка.ПриобретениеТоваровУслуг") тогда
		
		для каждого стр из ЭтотОбъект.расшифровкаПлатежа цикл
			Если не Значениезаполнено(стр.ЭлементСтруктурыЗадолженности) тогда
				стр.ЭлементСтруктурыЗадолженности=Перечисления.ЭлементыСтруктурыЗадолженности.ОсновнойДолг;
				
			КонецЕсли;
			
			Если не ЗначениеЗаполнено(стр.Организация) и значениеЗаполнено(ЭтотОбъект.организация) тогда
				стр.Организация=ЭтотОбъект.организация;	
			КонецЕсли;

		КонецЦикла; 
		
		
		Предоплата=ллл_МодульКазначействоОбщегоНазначения.ллл_ОпределитьПредоплатуПоЗаказу(ДанныеЗаполнения.ДокументОснование);
		СуммаНеоплаченныхЗаявок=ллл_МодульКазначействоОбщегоНазначения.ллл_ОпределитьСуммуНеоплаченныхЗаявок(ДанныеЗаполнения.ДокументОснование,неопределено);
		СуммаНепроведенныхЗаявок=ллл_МодульКазначействоОбщегоНазначения.ллл_ОпределитьСуммуНепроведенныхЗаявок(ДанныеЗаполнения.ДокументОснование,неопределено);
		СуммаКОплате=ДанныеЗаполнения.ДокументОснование.СуммаДокумента-Предоплата-СуммаНеоплаченныхЗаявок-СуммаНепроведенныхЗаявок;
		
		
		
		Если ТипОснования=тип("ДокументСсылка.ЗаказПоставщику")	тогда
			Если ЭтотОбъект.расшифровкаПлатежа.Количество()=1 и	не ЗначениеЗаполнено(ЭтотОбъект.расшифровкаПлатежа[0].Сумма) и ЭтотОбъект.Валюта=ЭтотОбъект.Валютаоплаты тогда
				
				ЭтотОбъект.расшифровкаПлатежа[0].Сумма=СуммаКОплате;
				ЭтотОбъект.расшифровкаПлатежа[0].СуммаВзаиморасчетов=СуммаКОплате;
				ЭтотОбъект.СуммаДокумента=СуммаКОплате;
			КонецЕсли;	                                                 
		КонецЕсли; 
		
		Если ТипОснования=тип("ДокументСсылка.ПриобретениеТоваровУслуг")	тогда
			Если ЭтотОбъект.расшифровкаПлатежа.Количество()=1 
				// и	не ЗначениеЗаполнено(ЭтотОбъект.расшифровкаПлатежа[0].Сумма) и ЭтотОбъект.Валюта=ЭтотОбъект.Валютаоплаты 
				// типовой механизм неправильно определяет сумму в случае взаиморасчетов<>руб и валюта оплаты=руб
				// Конилов ERP1C-118
				
				тогда
				СуммаКОплате=ллл_МодульКазначействоОбщегоНазначения.ллл_ОпределениеЗадолженностиПоДокументуПТУ(ДанныеЗаполнения.ДокументОснование).КОплате;
				ЭтотОбъект.расшифровкаПлатежа[0].Сумма=СуммаКОплате;
				ЭтотОбъект.расшифровкаПлатежа[0].СуммаВзаиморасчетов=СуммаКОплате;
				ЭтотОбъект.СуммаДокумента=СуммаКОплате;
			КонецЕсли;	                                                 
		КонецЕсли;

		
		
		Если не ЗначениеЗаполнено(ЭтотОбъект.ЦФО) тогда
			ЭтотОбъект.ЦФО=ЭтотОбъект.организация;	
			
		КонецЕсли;
		
		Если не ЗначениеЗаполнено(ЭтотОбъект.Договор) тогда 
			ЭтотОбъект.Договор=  ДанныеЗаполнения.Договор; 
		КонецЕсли;
		
		Если не ЗначениеЗаполнено(ЭтотОбъект.ДоговорКонтрагентаПолучатель) тогда 
			ЭтотОбъект.ДоговорКонтрагентаПолучатель=  ДанныеЗаполнения.Договор; 
		КонецЕсли;		
		
		Если не ЗначениеЗаполнено(ЭтотОбъект.ДоговорКонтрагента) тогда 
			ЭтотОбъект.ДоговорКонтрагента=  ДанныеЗаполнения.Договор; 
		КонецЕсли;  
		
		Если не ЗначениеЗаполнено(ЭтотОбъект.Договор) тогда 
			ЭтотОбъект.Договор=  ДанныеЗаполнения.Договор; 
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ЭтотОбъект.Договор) Тогда
				ДоговорКонтрагента = ЭтотОбъект.Договор;
				УчетнаяИнформацияПоДоговору = Справочники.ДоговорыКонтрагентов.УчетнаяИнформацияПоДоговору(ДоговорКонтрагента);
				Если ЗначениеЗаполнено(УчетнаяИнформацияПоДоговору) Тогда
					ТекущаяСтрока = ЭтотОбъект.расшифровкаПлатежа[0];
					ЗаполнитьЗначенияСвойств(ТекущаяСтрока, УчетнаяИнформацияПоДоговору);
					
					ЗаполнитьКурсИКратностьВСтрокеРасшифровки(ТекущаяСтрока);
					ДенежныеСРедстваКлиентСервер.РассчитатьСуммуВзаиморасчетовВСтрокеРасшифровки(
						ТекущаяСтрока, ЭтотОбъект.Валюта, Справочники.Валюты.найтиПоНаименованию("руб."));
					
					
					
					УчетнаяИнформацияПоДоговору.Свойство("НаправлениеДеятельности", ЭтотОбъект.НаправлениеДеятельности);
					УчетнаяИнформацияПоДоговору.Свойство("ГруппаФинансовогоУчета", ЭтотОбъект.ГруппаФинансовогоУчета);
				КонецЕсли;
		КонецЕсли;
		
		
		// <<Конилов ERP1C-237
		Если ЭтотОбъект.Валюта=ДанныеЗаполнения.ДокументОснование.Валюта и ЭтотОбъект.СуммаДокумента<>СуммаКОплате тогда 
			
				ТекущаяСтрока = ЭтотОбъект.расшифровкаПлатежа[0];

		    	ТекущаяСтрока.Сумма=СуммаКОплате;
				ТекущаяСтрока.СуммаВзаиморасчетов=СуммаКОплате;
				ЭтотОбъект.СуммаДокумента=СуммаКОплате; 
				ЗаполнитьКурсИКратностьВСтрокеРасшифровки(ТекущаяСтрока);
					ДенежныеСРедстваКлиентСервер.РассчитатьСуммуВзаиморасчетовВСтрокеРасшифровки(
						ТекущаяСтрока, ЭтотОбъект.Валюта, Справочники.Валюты.найтиПоНаименованию("руб."));
				
				
		КонецЕсли;            
		// ERP1C-237>>			
		
	
		СтруктураДействий = Новый Структура("ПересчитатьСуммуНДС", Новый Структура("ЦенаВключаетНДС", Истина));
		ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(ЭтотОбъект.РасшифровкаПлатежа, СтруктураДействий, Неопределено);


		
		
	КонецЕсли; 
	
	
КонецПроцедуры



Процедура ЗаполнитьКурсИКратностьВСтрокеРасшифровки(СтрокаТЧ)
	
	КурсИКратность = ДенежныеСредстваСервер.КурсЧислительИКурсЗнаменательВзаиморасчетов(
		ЭтотОбъект.Валюта, СтрокаТЧ.ВалютаВзаиморасчетов, Справочники.Валюты.найтиПоНаименованию("руб."), ЭтотОбъект.Дата);
	СтрокаТЧ.КурсЧислительВзаиморасчетов = КурсИКратность.КурсЧислитель;
	СтрокаТЧ.КурсЗнаменательВзаиморасчетов = КурсИКратность.КурсЗнаменатель;
	
КонецПроцедуры

&После("ОбработкаУдаленияПроведения")
Процедура ллл_ОбработкаУдаленияПроведения(Отказ)  
	Если не Отказ тогда
	ллл_Согласование.ллл_ОчисткаЭкземпляровПроцессовПоЗаявке(ЭтотОбъект.Ссылка);
	КонецЕсли;
КонецПроцедуры

Процедура ЗаписатьВРежимеЗагрузки() экспорт
	ЭтотОбъект.ОбменДанными.Загрузка=истина;
	ЭтотОбъект.Записать();
	
	ЭтотОбъект.ОбменДанными.Загрузка=ложь;
	
	
	
КонецПроцедуры

&После("ПриКопировании")
Процедура ллл_ПриКопировании(ОбъектКопирования)
	КрайняяДата=Дата(1,1,1);
КонецПроцедуры

&После("ПередЗаписью")
Процедура ллл_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если не Отказ тогда
		
		// Конилов ERP1C-236
		для каждого стр из ЭтотОбъект.РасшифровкаПлатежа цикл
			
			Если не ЗначениеЗаполнено(стр.Партнер) тогда
				   стр.Партнер=ЭтотОбъект.Контрагент.Партнер;
			КонецЕсли;
			
			
		КонецЦикла; 
		
		
		// Конилов. ERP1C-240 При автоматическом проведении самостоятельно устанавливается ЭтоВнутриГрупповоеПеремещение = истина, 
		// если у контрагента есть соответствующая по ИНН и КПП организация. 
		// из-за чего недоступен реквизит Не позднее
		//Сбрасываем обратно для заявок на оплату поставщику, импорта и ввозу из ЕАЭС
		
		ХозОперация=ЭтотОбъект.ХозяйственнаяОперация;
		Если ЗначениеЗаполнено(ХозОперация) тогда                                        
			
			Если ХозОперация=Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту или 
				ХозОперация=Перечисления.ХозяйственныеОперации.ОплатаПоставщику	  или
				
				ХозОперация=Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика или 
				ХозОперация=Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС тогда
				ЭтотОбъект.ЭтоВнутригрупповоеПеремещение=ложь;	
			КонецЕсли;
		КонецЕсли;	
		
		
		
		
	КонецЕсли;	
КонецПроцедуры


