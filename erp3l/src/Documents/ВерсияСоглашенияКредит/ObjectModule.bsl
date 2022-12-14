
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПараметрыРасчетаСекции(ИмяСекции, ОписаниеГрафика) Экспорт
	
	Результат = ФинансоваяМатематикаКлиентСервер.СтруктураПараметровРасчетаПроцентов();
	
	Если ИмяСекции = "Проценты" Тогда
		Результат.ДатаНачала = ДатаНачалаДействия;
		Результат.ДатаОкончания = ДатаОкончанияДействия;
		Результат.ПравилоПереноса = ПереносДатСНерабочихДней;
		Результат.ИзменятьПроцентныйПериод = ИзменяетсяДлительностьПроцентногоПериодаПриПереносе;
		Результат.ПроизводственныйКалендарь = ПроизводственныеКалендари.ВыгрузитьКолонку("ПроизводственныйКалендарь");
		Результат.ПериодичностьУплаты = ПериодичностьУплатыПроцентов;
		Результат.ПериодичностьНачисленияПроцентов = ?(НачислениеПроцентовНаОтчетныеДаты, 
															ПериодичностьНачисленияПроцентов, 
															Перечисления.Периодичность.ПустаяСсылка());
		Результат.ДатаОтсчетаПроцентныхПериодов = ДатаОтсчетаПроцентныхПериодов;
		Результат.ДатаНачалаДействия = ДатаНачалаДействия;
		Результат.ДатаПервогоПогашения = ДатаОкончанияПервогоПроцентногоПериода;
		Результат.ТочкаОтсчетаСдвигаДатыУплаты = ТочкаОтсчетаСдвигаДатыУплаты;
		Результат.СдвигДатыУплаты = СдвигДатыУплатыПроцентов;
		Результат.ВидДнейСдвигаУплаты = ВидДнейСдвигаУплаты;
		Результат.ТипПроцентнойСтавки = ТипПроцентнойСтавки;
		Результат.ТочкаОтсчетаДатыФиксацииСтавки = ТочкаОтсчетаДатыФиксацииСтавки;
		Результат.СдвигДатыФиксацииСтавки = СдвигДатыФиксацииСтавки;
		Результат.ПроцентнаяСтавка = ПроцентнаяСтавка;
		Результат.ИндикативнаяСтавка = ИндикативнаяСтавка;
		Результат.ПлавающаяСтавкаМинимум = ПлавающаяСтавкаМинимум;
		Результат.ПлавающаяСтавкаМаксимум = ПлавающаяСтавкаМаксимум;
		Результат.РучноеУправлениеИзменениямиСтавки = РучноеУправлениеИзменениямиСтавки;
		Результат.ПроцентныеСтавки = ПроцентныеСтавки.Выгрузить();
		Результат.ВыплачиватьПроцентыПериодически = ВыплачиватьПроцентыПериодически;
		Результат.ВыплачиватьПроцентыВДатыПогашенияТела = ВыплачиватьПроцентыВДатыПогашенияТела;
		Результат.НачислениеПроцентовНаКрайниеДаты = НачислениеПроцентовНаКрайниеДаты;
		Результат.ОперацииИзмененияБазы = ФинансовыеИнструментыУХ.ТаблицаИзмененияБазыИзГрафика(ГрафикРасчетов, ОписаниеГрафика);
		Результат.ДатаПервойВыборки = ?(Результат.ОперацииИзмененияБазы.Количество(), Результат.ОперацииИзмененияБазы[0].Дата, ДатаНачалаДействия);
		Результат.БазаДляРасчетаПроцентов = БазаДляРасчетаПроцентов;
		Результат.ГраницаФактическихДанных = ГраницаФактическихДанных;
		
		// Проанализируем график в части факта.
		Результат.ДатаПоследнегоНачисления = ФинансовыеИнструментыУХ.ДатаПоследнегоНачисленияСекцииГрафика(ГрафикРасчетов, ОписаниеГрафика["Проценты"], ГраницаФактическихДанных);		
		Результат.СуммаНакопленнойЗадолженности = ФинансовыеИнструментыУХ.ОстатокЗадолженностиСекцииГрафика(ГрафикРасчетов, ОписаниеГрафика["Проценты"], ГраницаФактическихДанных);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПересчитатьСекциюГрафика(ИмяСекции, ОписаниеГрафика, ОперацииГрафика, ДопПараметры, Отказ = Ложь) Экспорт
	
	Если ИмяСекции = "ОсновнойДолг" Тогда
		ФинансовыеИнструментыУХ.НачальноеЗаполнениеОсновногоДолга(ЭтотОбъект, ИмяСекции, ОписаниеГрафика, ОперацииГрафика);
	ИначеЕсли ИмяСекции = "Проценты" Тогда
		ФинансовыеИнструментыУХ.ПересчитатьСекциюГрафика(ЭтотОбъект, ИмяСекции, ОписаниеГрафика, ОперацииГрафика, ДопПараметры, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьВычисляемыеРеквизитыПоДаннымДоговора(ДоговорОбъект) Экспорт
	
	Если Не ЗначениеЗаполнено(ДатаНачалаДействия) Тогда
		ДатаНачалаДействия = ДоговорОбъект.ДатаПервогоТранша;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда
		ДатаОкончанияДействия = ДоговорОбъект.ДатаПоследнегоПлатежа;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Сумма) Тогда
		Сумма = ДоговорОбъект.СуммаТраншей;
	КонецЕсли;
	
КонецПроцедуры	

// Возвращает информацию о доступности платежей по 275-ФЗ
//
// Параметры:
//	Договор - СправочникСсылка.ДоговорыКредитовИДепозитов - Договор, данные по которому требуется получить.
//
// Возвращаемое значание:
//	Булево
//
Функция ДоступныПлатежиПо275ФЗ() Экспорт
	
	Если Не ЗначениеЗаполнено(БанковскийСчет) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ОтдельныйСчетГОЗ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БанковскийСчет, "ОтдельныйСчетГОЗ");
	
	Возврат ОтдельныйСчетГОЗ
		И (ВидДоговораУХ = Справочники.ВидыДоговоровКонтрагентовУХ.Кредит);
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	РаботаСДоговорамиКонтрагентовУХ.ПередЗаписьюВерсииСоглашения(ЭтотОбъект, Отказ, РежимЗаписи);
	
	Если РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		ДатаПредыдущейВерсии = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "Дата");
		Если Дата <= ДатаПредыдущейВерсии Тогда
			ТекстОшибки = НСтр("ru = 'Документ не может иметь дату ранее даты предыдущей версии %1'");
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(ТекстОшибки, ДатаПредыдущейВерсии),,,,Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ДоговорыКонтрагентовФормыУХКлиентСервер.ДоступенВыборПоручителей(ВидДоговораУХ) Тогда
		ЭтотОбъект.Поручители.Очистить();
	КонецЕсли;
	
	Если НЕ ДоговорыКонтрагентовФормыУХКлиентСервер.ДоступнаРеструктуризацияКредита(ВидДоговораУХ) Тогда
		ЭтотОбъект.Реструктуризован = Ложь;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ОписаниеГрафика") Тогда
		ОписаниеГрафика = ДополнительныеСвойства.ОписаниеГрафика;
	Иначе
		ОписаниеГрафика = Документы.ВерсияСоглашенияКредит.ОписаниеГрафика(ВидДоговораУХ);
		ДополнительныеСвойства.Вставить("ОписаниеГрафика", ОписаниеГрафика);
	КонецЕсли;
	
	// Проверка несовпадения сумм. Критичная.
	ШаблонСообщенияОбОшибке = Нстр("ru = 'Не совпадают итоговые суммы колонок графика ""%1"" и ""%2"".'");
	Для Каждого СекцияГрафика Из ОписаниеГрафика Цикл
		
		ОписаниеСекции = СекцияГрафика.Значение;
		Если Не ФинансовыеИнструментыУХ.СекцияГрафикаЗамкнута(ГрафикРасчетов, ОписаниеСекции) Тогда
			ТекстОшибки = СтрШаблон(ШаблонСообщенияОбОшибке, ОписаниеСекции.КолонкаПриходПредставление, ОписаниеСекции.КолонкаРасходПредставление);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,,,Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
	// Превышение суммы по графику над суммой соглашения
	Если ВидСоглашения = Перечисления.ВидыСоглашений.ДоговорСУсловием Тогда
		
		Если ЭтоКредитнаяЛиния И ВозобновляемыйЛимит Тогда
			МаксимумЗадолженности = ФинансовыеИнструментыУХ.МаксимальнаяСуммаЗадолженностиСекцииГрафика(ГрафикРасчетов,
																	Перечисления.ЭлементыСтруктурыЗадолженности.ОсновнойДолг);
			Если МаксимумЗадолженности > ЭтотОбъект.Сумма Тогда
				ТекстОшибки = СтрШаблон(НСтр("ru = 'Величина задолженности по графику %1 %3 превышает сумму договора %2 %3'"),
					МаксимумЗадолженности,
					ЭтотОбъект.Сумма,
					ВалютаВзаиморасчетов);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,,,Отказ);			
			КонецЕсли;

		Иначе
			ОбщаяСуммаПолучение = ФинансовыеИнструментыУХ.ОбщаяСуммаКолонкиСекции(ГрафикРасчетов,
				Перечисления.ЭлементыСтруктурыЗадолженности.ОсновнойДолг, Перечисления.ВидыДвиженийПриходРасход.Приход);
			Если ОбщаяСуммаПолучение > ЭтотОбъект.Сумма Тогда
				ТекстОшибки = СтрШаблон(НСтр("ru = 'Сумма полученнного кредита по графику %1 %3 превышает сумму договора %2 %3'"),
					ОбщаяСуммаПолучение,
					ЭтотОбъект.Сумма,
					ВалютаВзаиморасчетов);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,,,Отказ);			
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Проверка действующих ограничений.
	СтруктураОграничений = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеСвойства, "Ограничения");
	Если Не ЗначениеЗаполнено(СтруктураОграничений) Тогда
		Если ЗначениеЗаполнено(БазовыйДоговор) Тогда
			СтруктураОграничений = Документы.ВерсияСоглашенияКредит.ПолучитьОграниченияПоРамочномуСоглашению(БазовыйДоговор, 
				ДоговорКонтрагента, ДатаНачалаДействия);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураОграничений) Тогда
		
		// 1. Сумма сделки
		Если Сумма < СтруктураОграничений.МинимальнаяСуммаСделки Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Привлечение средств возможно в размере не менее %1 %3, текущая сумма сделки %2 %3'"), СтруктураОграничений.МинимальнаяСуммаСделки, Сумма, ВалютаВзаиморасчетов);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,,,Отказ);
		КонецЕсли;
		
		Если Сумма > СтруктураОграничений.МаксимальнаяСуммаСделки И СтруктураОграничений.МаксимальнаяСуммаСделки <> 0 Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Привлечение средств возможно в размере не более %1 %3, текущая сумма сделки %2 %3'"), СтруктураОграничений.МаксимальнаяСуммаСделки, Сумма, ВалютаВзаиморасчетов);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,,,Отказ);
		КонецЕсли;
		
		// 2. Срок сделки - ограничение.
		СрокСделки = Цел((ДатаОкончанияДействия - ДатаНачалаДействия)/86400 + 1);
		
		Если СрокСделки < СтруктураОграничений.МинимальныйСрок Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Привлечение средств возможно на срок не менее %1, текущий срок сделки %2'"),
				СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(СтруктураОграничений.МинимальныйСрок, НСтр("ru = 'день,дня,дней'")),
				СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(СрокСделки, НСтр("ru = 'день,дня,дней'")));
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,,,Отказ);
		КонецЕсли;
		
		Если СрокСделки > СтруктураОграничений.МаксимальныйСрок И СтруктураОграничений.МаксимальныйСрок <> 0 Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Привлечение средств возможно на срок не более %1, текущий срок сделки %2'"),
				СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(СтруктураОграничений.МаксимальныйСрок, НСтр("ru = 'день,дня,дней'")),
				СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(СрокСделки, НСтр("ru = 'день,дня,дней'")));
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,,,Отказ);
		КонецЕсли;
		
		// 3. Проанализируем период доступности.
		СтруктураПоискаОперацийПолучения = Новый Структура(
			"ЭлементСтруктурыЗадолженности, КолонкаСекции", 
			Перечисления.ЭлементыСтруктурыЗадолженности.ОсновнойДолг, 
			Перечисления.ВидыДвиженийПриходРасход.Приход);
			
		ОперацииПолучения = ГрафикРасчетов.НайтиСтроки(СтруктураПоискаОперацийПолучения);
		Для Каждого ТекСтрокаГрафика Из ОперацииПолучения Цикл
			Если ТекСтрокаГрафика.Дата < СтруктураОграничений.ДатаНачалаДоступности Тогда
				ТекстОшибки = СтрШаблон(НСтр("ru = 'Дата привлечения средств %1 наступает раньше даты начала периода доступности %2.'"),
					Формат(ТекСтрокаГрафика.Дата, "ДЛФ=D"),
					Формат(СтруктураОграничений.ДатаНачалаДоступности, "ДЛФ=D"));
					ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,,,Отказ);
			КонецЕсли;
				
			Если ТекСтрокаГрафика.Дата > СтруктураОграничений.ДатаОкончанияДоступности И СтруктураОграничений.ДатаОкончанияДоступности > Дата(1,1,1) Тогда
				ТекстОшибки = СтрШаблон(НСтр("ru = 'Дата привлечения средств %1 наступает позднее даты окончания периода доступности %2.'"),
					Формат(ТекСтрокаГрафика.Дата, "ДЛФ=D"),
					Формат(СтруктураОграничений.ДатаОкончанияДоступности, "ДЛФ=D"));
					ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,,,Отказ);
			КонецЕсли;
		КонецЦикла;
		
		// 4. Проанализируем сумму лимита.
		Если НЕ СтруктураОграничений.ВозобновляемыйЛимит Тогда
			ОбщаяСуммаПолучение = ФинансовыеИнструментыУХ.ОбщаяСуммаКолонкиСекции(ГрафикРасчетов,
																				Перечисления.ЭлементыСтруктурыЗадолженности.ОсновнойДолг, 
																				Перечисления.ВидыДвиженийПриходРасход.Приход);
			ОстатокЛимита = СтруктураОграничений.СвободныйОстатокЛимита - ОбщаяСуммаПолучение;
		Иначе
			МаксимумЗадолженности = ФинансовыеИнструментыУХ.МаксимальнаяСуммаЗадолженностиСекцииГрафика(ГрафикРасчетов,
																				Перечисления.ЭлементыСтруктурыЗадолженности.ОсновнойДолг);
			ОстатокЛимита = СтруктураОграничений.СвободныйОстатокЛимита - МаксимумЗадолженности;
		КонецЕсли;
		
		Если ОстатокЛимита < 0 Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Лимит по рамочному соглашению превышен на %1 %2.'"),
				-ОстатокЛимита,
				ВалютаВзаиморасчетов);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,,,Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСДоговорамиКонтрагентовУХ.ПриЗаписиВерсииСоглашения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУХ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	ВидБюджетаДоговора = Перечисления.ПредназначенияЭлементовСтруктурыОтчета.БюджетДвиженияДенежныхСредств;
	ДополнительныеСвойства.ДляПроведения.Вставить(
		"ПараметрыОперПланирования", ОперативноеПланированиеПовтИспУХ.ПолучитьПараметрыОперПланирования(ВидБюджетаДоговора));
	
	ДополнительныеСвойства.ДляПроведения.Вставить("КонтролироватьПериодыПланирования", Истина);
	ДополнительныеСвойства.ДляПроведения.Вставить("КонтролироватьПериодыЛимитирования", Ложь);
	
	Документы.ВерсияСоглашенияКредит.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
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
	//
	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСерверУХ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУХ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);	
	ПроведениеСерверУХ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	// Зеркалирование внутригрупповых операций.
	РаботаСДоговорамиКонтрагентовУХ.СинхронизироватьВнутригрупповыеВерсииСоглашения(Ссылка, ДополнительныеСвойства);
	
	РаботаСДоговорамиКонтрагентовУХ.ОбновитьПозицииЗаявокПоГрафику(ЭтотОбъект);
	
	РаботаСДоговорамиКонтрагентовУХ.ОтразитьНапоминанияОПроверкеКовенантов(Ссылка, ДоговорКонтрагента, ДополнительныеСвойства, Отказ);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	АктуальнаяВерсияСоглашения = РегистрыСведений.ВерсииРасчетов.ПолучитьАктуальнуюВерсиюФинансовогоИнструмента(ДоговорКонтрагента);
	
	ПроведениеСерверУХ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);	
	ПроведениеСерверУХ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	РаботаСДоговорамиКонтрагентовУХ.УдалитьПроверкиКовенантов(Ссылка, ДоговорКонтрагента, Отказ);
	
	ПроведениеСерверУХ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУХ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

	Если НЕ Отказ Тогда
		
		Если АктуальнаяВерсияСоглашения = ЭтотОбъект.Ссылка Тогда		
			НоваяАктуальнаяВерсияСоглашения = РегистрыСведений.ВерсииРасчетов.ПолучитьАктуальнуюВерсиюФинансовогоИнструмента(
				ДоговорКонтрагента);
			Если ЗначениеЗаполнено(НоваяАктуальнаяВерсияСоглашения) Тогда
				// отменили проведение актуальной версии соглашения,
				// восстановливаем напоминания от новой актуальной версии
				РаботаСДоговорамиКонтрагентовУХ.ДобавитьНапоминанияОПроверкеСтатусовКовенантов(НоваяАктуальнаяВерсияСоглашения);
			КонецЕсли;
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	// Общая логика для всех договорных документов.
	РаботаСДоговорамиКонтрагентовУХ.ОбработкаЗаполненияВерсииСоглашения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
	Если ВидДоговораУХ = Справочники.ВидыДоговоровКонтрагентовУХ.Овердрафт Тогда
		ВозобновляемыйЛимит = Истина;
	КонецЕсли;
	
	ЭтоРамочныйДоговор = (ВидСоглашения = Перечисления.ВидыСоглашений.РамочныйДоговор);
	
	Если ЭтоРамочныйДоговор Тогда
		
		ЭтоКредитнаяЛиния = Истина;
		
	КонецЕсли;
	
	РаботаСДоговорамиКонтрагентовУХКлиентСервер.ЗаполнитьДатуОтсчетаПроверкиКовенантов(ЭтотОбъект, ДатаНачалаДействия); 
	
	Если ВидСоглашения = Перечисления.ВидыСоглашений.Спецификация Тогда 

		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеЗаполнения, "СуммаТраншей")
		      И ЗначениеЗаполнено(ДанныеЗаполнения.СуммаТраншей) Тогда
             	Сумма = ДанныеЗаполнения.СуммаТраншей;
        Иначе
				Результат = Документы.ВерсияСоглашенияКредит.ПолучитьОграниченияПоРамочномуСоглашению(БазовыйДоговор, Ссылка, ДатаНачалаДействия);
				Сумма = Результат.СвободныйОстатокЛимита;

		КонецЕсли;
	КонецЕсли;	
	
	Если НЕ ГрафикРасчетов.Количество() 
		И Не ЭтоРамочныйДоговор
		И Сумма > 0 Тогда
		
		СтруктураДействий = Новый Структура;
		Секции = Новый Массив;
		Секции.Добавить("ОсновнойДолг");
		Секции.Добавить("Проценты");
		СтруктураДействий.Вставить("Пересчитать", Новый Структура("СекцииГрафика", Секции));
		ОписаниеГрафика = Документы.ВерсияСоглашенияКредит.ОписаниеГрафика(ВидДоговораУХ);
		ОперацииГрафика = РаботаСДоговорамиКонтрагентовУХ.ОперацииГрафика(ОписаниеГрафика, ЭтотОбъект);
		ФинансовыеИнструментыУХ.ПересчетГрафика(ЭтотОбъект, 0, ОписаниеГрафика, ОперацииГрафика, СтруктураДействий);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	РаботаСДоговорамиКонтрагентовУХ.ОбработкаПроверкиЗаполненияВерсииСоглашения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	ПроверитьЗаполнениеКовенантов(ПроверяемыеРеквизиты, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	РаботаСДоговорамиКонтрагентовУХ.ПриКопированииВерсииСоглашения(ЭтотОбъект, ОбъектКопирования);
	ЭтотОбъект.Ковенанты.Очистить();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

Процедура ПроверитьЗаполнениеКовенантов(ПроверяемыеРеквизиты, Отказ)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ЗначениеЗаполнено(Ковенанты) Тогда
		Если ДатаОтсчетаПроверкиКовенантов < ДатаНачалаДействия ИЛИ ДатаОтсчетаПроверкиКовенантов > ДатаОкончанияДействия Тогда
			ОбщегоНазначения.СообщитьПользователю(
				Нстр("ru = 'Дата начала отсчета проверки ковенантов должна входить в период действия договора'"),
				ЭтотОбъект,
				"ДатаОтсчетаПроверкиКовенантов",
				, // Путь к данным
				Отказ
			);	
		КонецЕсли;
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ДатаНачалаДействия");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаОкончанияДействия");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаОтсчетаПроверкиКовенантов");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры	
#КонецОбласти
#КонецЕсли
