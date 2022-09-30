#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если Не ДополнительныеСвойства.Свойство("НеЗаполнятьТабличнуюЧасть") Тогда
		Товары.Очистить();
		ШтрихкодыУпаковок.Очистить();
	КонецЕсли;
	
	ИнтеграцияИСМППереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
	ЗаполнитьОбъектПоСтатистике();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияИСПереопределяемый.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	Если ВидПервичногоДокумента <> Перечисления.ВидыПервичныхДокументовИСМП.Прочее Тогда
		НепроверяемыеРеквизиты.Добавить("НаименованиеПервичногоДокумента");
	КонецЕсли;

	Если Операция = Перечисления.ВидыОперацийИСМП.ВыводИзОборотаЭкспортЗаПределыСтранЕАЭС 
		Или Операция = Перечисления.ВидыОперацийИСМП.ВыводИзОборотаУтратаПовреждениеТовара Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.Цена");
		НепроверяемыеРеквизиты.Добавить("Товары.Сумма");
		НепроверяемыеРеквизиты.Добавить("Товары.СтавкаНДС");
	КонецЕсли;
	
	Если Операция <> Перечисления.ВидыОперацийИСМП.ВыводИзОборотаЭкспортВСтраныЕАЭС Тогда
		НепроверяемыеРеквизиты.Добавить("СтранаНазначения");
	КонецЕсли;
	
	Если ИнтеграцияИСПовтИсп.ЭтоПродукцияИСМП(ВидПродукции) Тогда
		НепроверяемыеРеквизиты.Добавить("АдресПлощадкиСтрокой");
	КонецЕсли;
	
	Если ИнтеграцияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукции) Тогда
		ПроверитьЗаполнениеАдреса(Отказ)
	КонецЕсли;
	
	ИнтеграцияИСМППереопределяемый.ПриОпределенииОбработкиПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	ИнтеграцияИСМПСлужебный.ПроверитьЗаполнениеШтрихкодовУпаковок(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияИСМП.ЗаписатьСтатусДокументаИСМППоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование   = Неопределено;
	ИдентификаторЗаявки = Неопределено;
	СтранаНазначения    = Неопределено;
	ШтрихкодыУпаковок.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаЗаполнения

Процедура ЗаполнитьОбъектПоСтатистике()
	
	ДанныеСтатистики = ЗаполнениеОбъектовПоСтатистикеИСМП.ДанныеЗаполненияВыводаИзОборотаИСМП(Организация);
	
	Для Каждого КлючИЗначение Из ДанныеСтатистики Цикл
		ЗаполнениеОбъектовПоСтатистикеИСМП.ЗаполнитьПустойРеквизит(ЭтотОбъект, ДанныеСтатистики, КлючИЗначение.Ключ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаПроверкиЗаполнения

Процедура ПроверитьЗаполнениеАдреса(Отказ)
	
	ДанныеСтраны = УправлениеКонтактнойИнформацией.СтранаАдресаКонтактнойИнформации(АдресПлощадки);
	
	Если ДанныеСтраны.Ссылка = ПредопределенноеЗначение("Справочник.СтраныМира.Россия") Тогда
		
		ДанныеКИ         = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВJSON(АдресПлощадки);
		СведенияОбАдресе = РаботаСАдресами.СведенияОбАдресе(ДанныеКИ);
		
		Если Не ЗначениеЗаполнено(СведенияОбАдресе.Индекс) Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнен Индекс в адресе';
									|en = 'Не заполнен Индекс в адресе'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "АдресПлощадкиСтрокой",, Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СведенияОбАдресе.КодРегиона) Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнен Код региона в адресе';
									|en = 'Не заполнен Код региона в адресе'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "АдресПлощадкиСтрокой",, Отказ);
		КонецЕсли;
		
	Иначе
		
		Если Не ЗначениеЗаполнено(ДанныеСтраны.Код) Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнен Код страны в адресе';
									|en = 'Не заполнен Код страны в адресе'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "АдресПлощадкиСтрокой",, Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(АдресПлощадкиСтрокой) Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнен адрес';
									|en = 'Не заполнен адрес'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "АдресПлощадкиСтрокой",, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли