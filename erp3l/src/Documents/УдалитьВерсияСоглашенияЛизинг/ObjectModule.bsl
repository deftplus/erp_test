#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьВычисляемыеРеквизитыПоДаннымДоговора(ДоговорОбъект) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если Не ДополнительныеСвойства.Свойство("ОписаниеГрафика") Тогда
		ОписаниеГрафика = Документы.УдалитьВерсияСоглашенияЛизинг.ОписаниеГрафика();
		ДополнительныеСвойства.Вставить("ОписаниеГрафика", ОписаниеГрафика);
	КонецЕсли;
	
	РаботаСДоговорамиКонтрагентовУХ.ПередЗаписьюВерсииСоглашения(ЭтотОбъект, Отказ, РежимЗаписи);
	
	УдалитьНеиспользуемыеСекцииГрафика();
		
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
			
	ПроведениеСерверУХ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);	
	ПроведениеСерверУХ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);	
	ПроведениеСерверУХ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУХ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	РаботаСДоговорамиКонтрагентовУХ.ПриЗаписиВерсииСоглашения(ЭтотОбъект, Отказ);
		
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)

	// Общая логика для всех договорных документов.
	РаботаСДоговорамиКонтрагентовУХ.ОбработкаЗаполненияВерсииСоглашения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
	ТипЗнчДанныеЗаполнения = ТипЗнч(ДанныеЗаполнения);
			
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	РаботаСДоговорамиКонтрагентовУХ.ПриКопированииВерсииСоглашения(ЭтотОбъект, ОбъектКопирования);
	УИД_ЕИС = "";
	РегистрационныйНомерЕИС = 0;
	НомерДополнительногоСоглашения = 1;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	РаботаСДоговорамиКонтрагентовУХ.ОбработкаПроверкиЗаполненияВерсииСоглашения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
		
	Если ЗначениеЗаполнено(ДатаНачалаДействия) И ЗначениеЗаполнено(ДатаОкончанияДействия)
		И ДатаНачалаДействия > ДатаОкончанияДействия Тогда
	
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Корректность",
			НСтр("ru = 'Срок действия до'"), , , 
			НСтр("ru = 'Срок действия договора должен быть больше или равен дате договора.'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДатаОкончанияДействия", "Объект", Отказ);
		
	КонецЕсли;
		
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУХ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	ВидБюджетаДоговора = Перечисления.ПредназначенияЭлементовСтруктурыОтчета.БюджетДвиженияДенежныхСредств;
	ДополнительныеСвойства.ДляПроведения.Вставить(
		"ПараметрыОперПланирования", ОперативноеПланированиеПовтИспУХ.ПолучитьПараметрыОперПланирования(ВидБюджетаДоговора));
	ДополнительныеСвойства.ДляПроведения.Вставить("КонтролироватьПериодыПланирования", Истина);
	ДополнительныеСвойства.ДляПроведения.Вставить("КонтролироватьПериодыЛимитирования", Ложь);
	
	Документы.УдалитьВерсияСоглашенияЛизинг.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ВыполнятьБюджетирование = РаботаСДоговорамиКонтрагентовУХ.ВыполнятьБюджетирование(РежимИспользованияГрафика);
	Если ВыполнятьБюджетирование Тогда
		КонтрольЛимитовУХ.ВыполнитьПроверкуНаличияПериодов(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;	
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеСерверУХ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РаботаСДоговорамиКонтрагентовУХ.ОтразитьВерсииРасчетов(ДополнительныеСвойства, Движения, Отказ);
	РаботаСДоговорамиКонтрагентовУХ.ОтразитьРасчетыСКонтрагентамиГрафики(ДополнительныеСвойства, Движения, Отказ);
	КонтрольЛимитовУХ.ОтразитьОперативныйПланПоБюджету(ДополнительныеСвойства, Движения, Отказ);
	Если ДополнительныеСвойства.ТаблицыДляДвижений.Свойство("ТаблицаЛимитыПоБюджетам") Тогда
		КонтрольЛимитовУХ.ОтразитьЛимитыПоБюджетам(ДополнительныеСвойства, Движения, Отказ);
	КонецЕсли;
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУХ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУХ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);	
	ПроведениеСерверУХ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

	РаботаСДоговорамиКонтрагентовУХ.ОбновитьПозицииЗаявокПоГрафику(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УдалитьНеиспользуемыеСекцииГрафика()
		
	ОписаниеГрафика = ДополнительныеСвойства.ОписаниеГрафика;
	Если НЕ ЕстьВыкупПредметаЛизинга Тогда
		ФинансовыеИнструментыУХ.УдалитьСтрокиСекцииГрафика(ГрафикРасчетов, ОписаниеГрафика.ВыкупнаяСтоимость);
	КонецЕсли;
	
	Если НЕ ЕстьОбеспечительныйПлатеж Тогда
		ФинансовыеИнструментыУХ.УдалитьСтрокиСекцииГрафика(ГрафикРасчетов, ОписаниеГрафика.ОбеспечительныйПлатеж);
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

#КонецОбласти

#КонецЕсли