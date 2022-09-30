#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка." + Метаданные().Имя) Тогда
		
		ИсправлениеДокументов.ЗаполнитьИсправление(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	
	ВзаимозачетЗадолженностиЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
	ИнициализироватьДокумент(ДанныеЗаполнения);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	ДебиторскаяБезРазбиения=Ложь;
	Если ДополнительныеСвойства.Свойство("ДебиторскаяБезРазбиения")
		И ДополнительныеСвойства.ДебиторскаяБезРазбиения Тогда
		ДебиторскаяБезРазбиения = Истина;
	КонецЕсли;
	
	КредиторскаяБезРазбиения=Ложь;
	Если ДополнительныеСвойства.Свойство("КредиторскаяБезРазбиения")
		И ДополнительныеСвойства.КредиторскаяБезРазбиения Тогда
		КредиторскаяБезРазбиения = Истина;
	КонецЕсли;
	
	Документы.ВзаимозачетЗадолженности.ЗаполнитьИменаРеквизитовПоВидуОперации(
		ВидОперации,
		МассивВсехРеквизитов, 
		МассивРеквизитовОперации);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
	
	БартерИлиПроизвольный = ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.Бартер
		ИЛИ ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.Произвольный;
	// Проверим соответствие сумм документа и табличной части.
	Если БартерИлиПроизвольный И ДебиторскаяЗадолженность.Итог("СуммаРегл") <> КредиторскаяЗадолженность.Итог("СуммаРегл") Тогда
		ТекстСообщения = НСтр("ru = 'Сумма регламентированного учета по строкам в табличной части ""Задолженность дебитора"" должна равняться сумме регламентированного учета по строкам в табличной части ""Задолженность перед кредитором""';
								|en = 'Local accounting sum of lines in the Receivable tabular section should be equal to the local accounting sum of lines in the Payable tabular section'");
		ОбщегоНазначения.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			, // Поле
			,
			Отказ);
	КонецЕсли;
	
	// Проверим соответствие сумм документа и табличной части.
	Если БартерИлиПроизвольный И ДебиторскаяЗадолженность.Итог("СуммаУпр") <> КредиторскаяЗадолженность.Итог("СуммаУпр") Тогда
		ТекстСообщения = НСтр("ru = 'Сумма управленческого учета по строкам в табличной части ""Задолженность дебитора"" должна равняться сумме управленческого учета по строкам в табличной части ""Задолженность перед кредитором""';
								|en = 'Management accounting sum of lines in the Receivable tabular section should be equal to the management accounting sum of lines in the Payable tabular section'");
		ОбщегоНазначения.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			, // Поле
			,
			Отказ);
	КонецЕсли;
	
	Если ДебиторскаяБезРазбиения И ДебиторскаяЗадолженность.Количество() > 0 И НЕ ЗначениеЗаполнено(ДебиторскаяЗадолженность[0].ВалютаВзаиморасчетов) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнена Валюта взаиморасчетов Дебиторской задолженности';
								|en = 'Settlements currency for receivables is required'");
		ОбщегоНазначения.СообщитьПользователю(
			ТекстСообщения,
			,
			"Элементы.ДебиторскаяЗадолженность.ТекущиеДанные.ВалютаВзаиморасчетов",
			,
			Отказ);
		МассивНепроверяемыхРеквизитов.Добавить("ДебиторскаяЗадолженность.ВалютаВзаиморасчетов");
	КонецЕсли;
	
	Если КредиторскаяБезРазбиения И КредиторскаяЗадолженность.Количество() > 0 И НЕ ЗначениеЗаполнено(КредиторскаяЗадолженность[0].ВалютаВзаиморасчетов) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнена Валюта взаиморасчетов Кредиторской задолженности';
								|en = 'Settlements currency for payables is required'");
		ОбщегоНазначения.СообщитьПользователю(
			ТекстСообщения,
			,
			"Элементы.КредиторскаяЗадолженность.ТекущиеДанные.ВалютаВзаиморасчетов",
			,
			Отказ);
		МассивНепроверяемыхРеквизитов.Добавить("КредиторскаяЗадолженность.ВалютаВзаиморасчетов");
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.КлиентаМеждуОрганизациями Тогда
		ТекстСообщения = НСтр("ru = 'Устаревшая операция взаимозачета не поддерживается.
		|Необходимо оформить документ с новой операцией ""Перенос аванса клиента между двумя организациями""
		|или ""Перенос долга клиента между двумя организациями""';
		|en = 'The legacy offset transaction is not supported.
		|Generate a document with a new operation ""Transfer customer advance between two companies""
		|or ""Transfer customer debt between two companies""'");
		ОбщегоНазначения.СообщитьПользователю(
			ТекстСообщения,
			,
			"Элементы.ВидОперации",
			,
			Отказ);
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПоставщикаМеждуОрганизациями Тогда
		ТекстСообщения = НСтр("ru = 'Устаревшая операция взаимозачета не поддерживается.
		|Необходимо оформить документ с новой операцией ""Перенос аванса поставщику между двумя организациями""
		|или ""Перенос долга поставщику между двумя организациями""';
		|en = 'The legacy offset transaction is not supported.
		|Generate a document with a new operation ""Transfer advance to vendor between two companies""
		|or ""Transfer debt owed to vendor between two companies""'");
		ОбщегоНазначения.СообщитьПользователю(
			ТекстСообщения,
			,
			"Элементы.ВидОперации",
			,
			Отказ);
	КонецЕсли;
	
	Если НЕ БартерИлиПроизвольный Тогда
		ДтЗадолженность = ДебиторскаяЗадолженность.Выгрузить();
		ДтЗадолженность.Свернуть("ВалютаВзаиморасчетов");
		КтЗадолженность = КредиторскаяЗадолженность.Выгрузить();
		КтЗадолженность.Свернуть("ВалютаВзаиморасчетов");
		Если ДтЗадолженность.Количество() > 0 И КтЗадолженность.Количество() > 0 Тогда
			Если ДтЗадолженность.Количество() > 1 ИЛИ КтЗадолженность.Количество() > 1
				ИЛИ ДтЗадолженность[0].ВалютаВзаиморасчетов <> КтЗадолженность[0].ВалютаВзаиморасчетов Тогда
				ТекстСообщения = НСтр("ru = 'Перенос задолженности между разными валютами взаиморасчетов не поддерживается';
										|en = 'Debt transfer between different settlement currencies is not supported'");
				ОбщегоНазначения.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					, // Поле
					,
					Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносАвансаКлиентаМеждуОрганизациями 
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносАвансаПоставщикуМеждуОрганизациями
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаКлиентаМеждуОрганизациями 
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаПоставщикуМеждуОрганизациями Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ОбъектРасчетовИнтеркампани");
	КонецЕсли;
	
	Если (ТипДебитора <> Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияКлиент
		И ТипДебитора <> Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияПоставщик
		И ТипКредитора <> Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияКлиент
		И ТипКредитора <> Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияПоставщик)
		ИЛИ КонтрагентДебитор = КонтрагентКредитор Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОбъектРасчетовДебиторКредитор");
	КонецЕсли;
	
	Если ТипДебитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияКлиент
		Или ТипДебитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияПоставщик Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДебиторскаяЗадолженность.Партнер");
	КонецЕсли;
	Если ТипКредитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияКлиент
		Или ТипКредитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияПоставщик Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КредиторскаяЗадолженность.Партнер");
	КонецЕсли;
	Если ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаКлиентаОрганизацияКонтрагент
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаКлиентаМеждуКонтрагентами
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаКлиентаМеждуОрганизациями
		ИЛИ НЕ ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДебиторскаяЗадолженность.ДатаПлатежа");
	КонецЕсли;
	Если ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаПоставщикуОрганизацияКонтрагент
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаПоставщикуМеждуКонтрагентами
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаПоставщикуМеждуОрганизациями
		ИЛИ НЕ ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КредиторскаяЗадолженность.ДатаПлатежа");
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ИмяСпискаДт") Тогда
		ПроверитьЗаполнениеТабличнойЧасти("ДебиторскаяЗадолженность", ДополнительныеСвойства.ИмяСпискаДт, МассивНепроверяемыхРеквизитов, Отказ);
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ИмяСпискаКт") Тогда
		ПроверитьЗаполнениеТабличнойЧасти("КредиторскаяЗадолженность", ДополнительныеСвойства.ИмяСпискаКт, МассивНепроверяемыхРеквизитов, Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	СтруктураПредставлений = Документы.ВзаимозачетЗадолженности.ПредставлениеРеквизитовПоВидуОперации(ВидОперации);
	ПроверитьСовпадениеЮрЛиц("КонтрагентДебитор", СтруктураПредставлений.КонтрагентДебитор, Отказ);
	Если МассивНепроверяемыхРеквизитов.Найти("КонтрагентКредитор") = Неопределено Тогда
		ПроверитьСовпадениеЮрЛиц("КонтрагентКредитор", СтруктураПредставлений.КонтрагентКредитор, Отказ);
	КонецЕсли;
	Если МассивНепроверяемыхРеквизитов.Найти("ОрганизацияКредитор") = Неопределено Тогда
		ПроверитьСовпадениеЮрЛиц("ОрганизацияКредитор", СтруктураПредставлений.ОрганизацияКредитор, Отказ);
	КонецЕсли;
	
	ВзаимозачетЗадолженностиЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ИсправлениеДокументов.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если ЗначениеЗаполнено(ВидОперации)
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносАвансаКлиентаМеждуКонтрагентами
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаКлиентаМеждуКонтрагентами
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносАвансаПоставщикуМеждуКонтрагентами
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаПоставщикуМеждуКонтрагентами
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.Бартер
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.Произвольный Тогда
		
		КонтрагентКредитор = КонтрагентДебитор;
		ТипКредитора = ТипДебитора;
		
	ИначеЕсли ЗначениеЗаполнено(ВидОперации)
		И ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.Бартер Тогда
		
		КонтрагентКредитор = КонтрагентДебитор;
		
	КонецЕсли;
		
	Если ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.Бартер
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.Произвольный Тогда
		Источник = ДебиторскаяЗадолженность;
		Приемник = КредиторскаяЗадолженность;
		Если ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносАвансаКлиентаОрганизацияКонтрагент
			ИЛИ ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносАвансаКлиентаМеждуКонтрагентами
			ИЛИ ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносАвансаКлиентаМеждуОрганизациями
			ИЛИ ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаПоставщикуОрганизацияКонтрагент
			ИЛИ ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаПоставщикуМеждуКонтрагентами
			ИЛИ ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаПоставщикуМеждуОрганизациями Тогда
			Источник = КредиторскаяЗадолженность;
			Приемник = ДебиторскаяЗадолженность;
		КонецЕсли;
		Если Приемник.Количество() > 0 Тогда
			Приемник[0].СуммаРегл = Источник.Итог("СуммаРегл");
			Приемник[0].СуммаУпр = Источник.Итог("СуммаУпр");
			
			СуммаРегл = ДебиторскаяЗадолженность.Итог("СуммаРегл");
			СуммаУпр  = ДебиторскаяЗадолженность.Итог("СуммаУпр");
			
			СуммыВзаиморасчетов = ОбщегоНазначенияКлиентСервер.РаспределитьСуммуПропорциональноКоэффициентам(
									Приемник[0].СуммаВзаиморасчетов, 
									Источник.ВыгрузитьКолонку("СуммаРегл"));
			ВалютаРегл = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
			ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
			Для Индекс = 0 По Источник.Количество() - 1 Цикл
				СтрокаИсточника = Источник[Индекс];
				Если Приемник[0].ВалютаВзаиморасчетов = ВалютаРегл Тогда
					СтрокаИсточника.Сумма = СтрокаИсточника.СуммаРегл;
				ИначеЕсли Приемник[0].ВалютаВзаиморасчетов = ВалютаУпр Тогда
					СтрокаИсточника.Сумма = СтрокаИсточника.СуммаУпр;
				Иначе
					СтрокаИсточника.Сумма = СуммыВзаиморасчетов[Индекс];
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	// Заполнение реквизитов в табличных частях.
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ЗаполнитьПоДаннымОбъектовРасчетов(Отказ);
		ЗаполнитьВалютуСуммуДокумента();
		
		ЗаполнитьТипРасчетовВТабличнойЧасти(ДебиторскаяЗадолженность, ТипДебитора);
		ЗаполнитьТипРасчетовВТабличнойЧасти(КредиторскаяЗадолженность, ТипКредитора);
		
		РасчетыМеждуОрганизациямиДебитор =
			ТипДебитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияКлиент
			ИЛИ ТипДебитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияПоставщик;
		
		РасчетыМеждуОрганизациямиКредитор =
			ТипКредитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияКлиент
			ИЛИ ТипКредитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияПоставщик;
		
		Если НЕ РасчетыМеждуОрганизациямиДебитор И ЗначениеЗаполнено(КонтрагентДебитор) Тогда
			ПартнерДебитор = ДенежныеСредстваСервер.ПолучитьПартнераПоКонтрагенту(КонтрагентДебитор);
			ЗаполнитьПартнераВТабличнойЧасти(ДебиторскаяЗадолженность, ПартнерДебитор, РасчетыМеждуОрганизациямиДебитор);
			Если ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.Бартер Тогда
				ЗаполнитьПартнераВТабличнойЧасти(КредиторскаяЗадолженность, ПартнерДебитор, РасчетыМеждуОрганизациямиКредитор);
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ РасчетыМеждуОрганизациямиКредитор И ЗначениеЗаполнено(КонтрагентКредитор) Тогда
			ПартнерКредитор = ДенежныеСредстваСервер.ПолучитьПартнераПоКонтрагенту(КонтрагентКредитор);
			ЗаполнитьПартнераВТабличнойЧасти(КредиторскаяЗадолженность, ПартнерКредитор, РасчетыМеждуОрганизациямиКредитор);
		КонецЕсли;
		
	КонецЕсли;

	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "ДебиторскаяЗадолженность,КредиторскаяЗадолженность");
	
	ВзаимозачетЗадолженностиЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ВзаимозачетЗадолженностиЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "ДебиторскаяЗадолженность,КредиторскаяЗадолженность");
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ВзаимозачетЗадолженностиЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ВзаимозачетЗадолженностиЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или НЕ ДанныеЗаполнения.Свойство("Организация") Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь()
		И Пользователи.РолиДоступны("ДобавлениеИзменениеДокументовКорректировкиЗадолженностиЗачетОплаты") Тогда
		ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносАвансаКлиентаОрганизацияКонтрагент;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ПроверитьСовпадениеЮрЛиц(Реквизит, Представление, Отказ)
	
	ЮрЛицо = ЭтотОбъект[Реквизит];
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ЮрЛицо) И (Организация = ЮрЛицо) Тогда
		Текст = НСтр("ru = 'Организация и %Контрагент% должны различаться.';
					|en = 'Company and %Контрагент% should be different.'");
		Текст = СтрЗаменить(Текст,"%Контрагент%", Представление);
		ОбщегоНазначения.СообщитьПользователю(Текст, ЭтотОбъект, Реквизит,, Отказ);
	КонецЕсли;
КонецПроцедуры

Процедура ЗаполнитьТипРасчетовВТабличнойЧасти(ТабличнаяЧасть, ТипКонтрагента)
	
	Если ЗначениеЗаполнено(ТипКонтрагента) Тогда
		
		Если ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.Бартер Тогда
			
			Если ТабличнаяЧасть = ДебиторскаяЗадолженность Тогда
				ТипРасчетов = Перечисления.ТипыРасчетовСПартнерами.РасчетыСКлиентом;
			Иначе
				ТипРасчетов = Перечисления.ТипыРасчетовСПартнерами.РасчетыСПоставщиком;
			КонецЕсли;
			
		Иначе
			
			Если ТипКонтрагента = Перечисления.ТипыУчастниковВзаимозачета.Клиент
				Или ТипКонтрагента = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияКлиент Тогда
				ТипРасчетов = Перечисления.ТипыРасчетовСПартнерами.РасчетыСКлиентом;
			Иначе
				ТипРасчетов = Перечисления.ТипыРасчетовСПартнерами.РасчетыСПоставщиком;
			КонецЕсли;
			
		КонецЕсли;
		
		Для Каждого СтрокаТаблицы Из ТабличнаяЧасть Цикл
			СтрокаТаблицы.ТипРасчетов = ТипРасчетов;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПартнераВТабличнойЧасти(ОбъектТабличнаяЧасть, ПартнерСсылка, РасчетыМеждуОрганизациями)
	Для Каждого СтрокаТаблицы Из ОбъектТабличнаяЧасть Цикл
		Если РасчетыМеждуОрганизациями Тогда
			СтрокаТаблицы.Партнер = Неопределено;
		ИначеЕсли Не ЗначениеЗаполнено(СтрокаТаблицы.Партнер) Тогда
			СтрокаТаблицы.Партнер = ПартнерСсылка;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьПоДаннымОбъектовРасчетов(Отказ = Ложь) Экспорт

	ТекстыЗапросов = Новый Массив;
	ТекстыЗапросов.Добавить(ТекстЗапросаВременнойТаблицы("ДебиторскаяЗадолженность"));
	ТекстыЗапросов.Добавить(ТекстЗапросаВременнойТаблицы("КредиторскаяЗадолженность"));
	
	ТекстыЗапросов.Добавить(ТекстЗапросаПоТабличнойЧасти("ДебиторскаяЗадолженность"));
	ТекстыЗапросов.Добавить(ТекстЗапросаПоТабличнойЧасти("КредиторскаяЗадолженность"));
	
	ТекстыЗапросов.Добавить(ТекстЗапросаПоРеквизитуДокумента("ОбъектРасчетовИнтеркампани"));
	ТекстыЗапросов.Добавить(ТекстЗапросаПоРеквизитуДокумента("ОбъектРасчетовДтКт"));
	
	ТекстЗапроса = СтрСоединить(ТекстыЗапросов, ОбщегоНазначения.РазделительПакетаЗапросов());
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация));
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета", Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("ДебиторскаяЗадолженность", ДебиторскаяЗадолженность.Выгрузить());
	Запрос.УстановитьПараметр("КредиторскаяЗадолженность", КредиторскаяЗадолженность.Выгрузить());
	Запрос.УстановитьПараметр("ОбъектРасчетовИнтеркампани", ОбъектРасчетовИнтеркампани);
	Запрос.УстановитьПараметр("ОбъектРасчетовДтКт", ОбъектРасчетовДебиторКредитор);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ПроверитьЗеркальныйОбъектРасчетов(ДебиторскаяЗадолженность, РезультатыЗапроса[2].Выгрузить(), Истина, Отказ);
	ПроверитьЗеркальныйОбъектРасчетов(КредиторскаяЗадолженность, РезультатыЗапроса[3].Выгрузить(), Ложь, Отказ);
	
	Интеркампани = РезультатыЗапроса[4].Выгрузить();
	Если Интеркампани.Количество() > 0 Тогда
		ОбъектРасчетовИнтеркампаниЗеркальный = Интеркампани[0].ОбъектРасчетовЗеркальный;
		Если НЕ ЗначениеЗаполнено(ОбъектРасчетовИнтеркампаниЗеркальный) Тогда
			СообщитьЗеркальныйОбъектРасчетовНеЗаполнен(Интеркампани[0], Отказ);
		КонецЕсли;
	КонецЕсли;
	
	ТриОрганизации = 
		(ТипДебитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияКлиент
			ИЛИ ТипДебитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияПоставщик)
		И (ТипКредитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияКлиент
				ИЛИ ТипКредитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияПоставщик);
	
	ДтКт = РезультатыЗапроса[5].Выгрузить();
	Если ТриОрганизации И ДтКт.Количество() > 0 Тогда
		ОбъектРасчетовДебиторКредиторЗеркальный = ДтКт[0].ОбъектРасчетовЗеркальный;
		Если НЕ ЗначениеЗаполнено(ОбъектРасчетовДебиторКредиторЗеркальный) Тогда
			СообщитьЗеркальныйОбъектРасчетовНеЗаполнен(ДтКт[0], Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьВалютуСуммуДокумента()
	
	Дт = ДебиторскаяЗадолженность.Выгрузить();
	Дт.Свернуть("ВалютаВзаиморасчетов","СуммаВзаиморасчетов");
	
	Кт = КредиторскаяЗадолженность.Выгрузить();
	Кт.Свернуть("ВалютаВзаиморасчетов","СуммаВзаиморасчетов");
	
	СуммаДокумента = 0;
	Валюта = Неопределено;
	Если Дт.Количество() = 1 И Кт.Количество() = 1 
		И Дт[0].ВалютаВзаиморасчетов = Кт[0].ВалютаВзаиморасчетов Тогда
			СуммаДокумента = Дт[0].СуммаВзаиморасчетов;
			Валюта = Дт[0].ВалютаВзаиморасчетов;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьЗеркальныйОбъектРасчетов(Задолженность, ДанныеПоЗадолженности, ЭтоДебет, Отказ)
	
	Проверять = 
		ЭтоДебет 
			И (ТипДебитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияКлиент
				ИЛИ ТипДебитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияПоставщик)
		ИЛИ НЕ ЭтоДебет 
			И (ТипКредитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияКлиент
				ИЛИ ТипКредитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияПоставщик);
	
	Задолженность.Очистить();
	Для Каждого Данные Из ДанныеПоЗадолженности Цикл
		НоваяЗапись = Задолженность.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, Данные);
		Если Проверять И НЕ ЗначениеЗаполнено(НоваяЗапись.ОбъектРасчетовЗеркальный) Тогда
			СообщитьЗеркальныйОбъектРасчетовНеЗаполнен(Данные, Отказ);
		КонецЕсли;
	КонецЦикла;
	
Конецпроцедуры

Процедура СообщитьЗеркальныйОбъектРасчетовНеЗаполнен(Данные, Отказ = Ложь)
	
	ТекстСообщения = НСтр("ru = 'Не удалось найти зеркальный объект расчетов для %1.
		|Зеркальный объект расчетов должен быть оформлен от организации ""%2""
		|с номером %3 и датой %4, на ту же сумму в той же валюте.';
		|en = 'Could not find a mirrored AP/AR object for %1.
		|The mirrored AP/AR object must be generated using company ""%2"",
		|with number %3 and date %4, for the same amount in the same currency.'");
	Если Данные.ТипОбъектаРасчетов = Тип("ДокументСсылка.СписаниеБезналичныхДенежныхСредств")
		ИЛИ Данные.ТипОбъектаРасчетов = Тип("ДокументСсылка.ПоступлениеБезналичныхДенежныхСредств") Тогда
		ТекстСообщения = СтрЗаменить(ТекстСообщения, 
							НСтр("ru = 'с номером %3 и датой %4';
								|en = 'with number %3 and date %4'"), 
							НСтр("ru = 'с номером %3 и датой %4 по банку';
								|en = 'with number %3 and date %4 according to bank'"));
	КонецЕсли;
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения,
		Данные.ОбъектРасчетов,
		Данные.ОрганизацияЗеркальная,
		Данные.Номер,
		Формат(Данные.Дата, "ДЛФ=D"));
	
	ОбщегоНазначения.СообщитьПользователю(
		ТекстСообщения,
		ЭтотОбъект,
		, // Поле
		,
		Отказ);
	
КонецПроцедуры

Функция ТекстЗапросаВременнойТаблицы(ИмяТаблицы)
	
	ТекстЗапроса =  
	"ВЫБРАТЬ
	|	ДанныеДокумента.ТипРасчетов                     КАК ТипРасчетов,
	|	ДанныеДокумента.ОбъектРасчетов                  КАК ОбъектРасчетов,
	|	ДанныеДокумента.ОбъектРасчетовЗеркальный        КАК ОбъектРасчетовЗеркальный,
	|
	|	ДанныеДокумента.Партнер                         КАК Партнер,
	|	
	|	ДанныеДокумента.ВалютаВзаиморасчетов            КАК ВалютаВзаиморасчетов,
	|	ДанныеДокумента.СуммаВзаиморасчетов             КАК СуммаВзаиморасчетов,
	|
	|	ДанныеДокумента.Сумма                           КАК Сумма,
	|	ВЫБОР КОГДА ДанныеДокумента.ВалютаВзаиморасчетов = &ВалютаРегламентированногоУчета
	|		ТОГДА ДанныеДокумента.СуммаВзаиморасчетов
	|		ИНАЧЕ ДанныеДокумента.СуммаРегл
	|	КОНЕЦ                                           КАК СуммаРегл,
	|	ВЫБОР КОГДА ДанныеДокумента.ВалютаВзаиморасчетов = &ВалютаУправленческогоУчета
	|		ТОГДА ДанныеДокумента.СуммаВзаиморасчетов
	|		ИНАЧЕ ДанныеДокумента.СуммаУпр
	|	КОНЕЦ                                           КАК СуммаУпр,
	|	
	|	ДанныеДокумента.ИдентификаторСтроки             КАК ИдентификаторСтроки
	|
	|ПОМЕСТИТЬ ВременнаяТаблица
	|ИЗ
	|	&ДебиторскаяЗадолженность КАК ДанныеДокумента";
	
	Если ИмяТаблицы = "КредиторскаяЗадолженность" Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВтДебиторскаяЗадолженность", "ВтКредиторскаяЗадолженность");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ДебиторскаяЗадолженность", "&КредиторскаяЗадолженность");
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВременнаяТаблица", "Вт" + ИмяТаблицы);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаПоТабличнойЧасти(ИмяТаблицы)
	
	ТекстЗапроса =  
	"//ДебиторскаяЗадолженность
	|ВЫБРАТЬ
	|	ДебиторскаяЗадолженность.ТипРасчетов            КАК ТипРасчетов,
	|	ДебиторскаяЗадолженность.ОбъектРасчетов         КАК ОбъектРасчетов,
	|	ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект)             КАК ТипОбъектаРасчетов,
	|	ЗеркальныйОбъектРасчетов.Ссылка                 КАК ОбъектРасчетовЗеркальный,
	|
	|	ДебиторскаяЗадолженность.Партнер                КАК Партнер,
	|	
	|	ДебиторскаяЗадолженность.ВалютаВзаиморасчетов   КАК ВалютаВзаиморасчетов,
	|	ДебиторскаяЗадолженность.СуммаВзаиморасчетов    КАК СуммаВзаиморасчетов,
	|
	|	ДебиторскаяЗадолженность.Сумма                  КАК Сумма,
	|	ДебиторскаяЗадолженность.СуммаРегл              КАК СуммаРегл,
	|	ДебиторскаяЗадолженность.СуммаУпр               КАК СуммаУпр,
	|	
	|	ДебиторскаяЗадолженность.ИдентификаторСтроки    КАК ИдентификаторСтроки,
	|	ОбъектыРасчетов.Организация                     КАК Организация,
	|	ОбъектыРасчетов.Контрагент                      КАК ОрганизацияЗеркальная,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект) = ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств)
	|				ИЛИ ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект) = ТИП(Документ.СписаниеБезналичныхДенежныхСредств)
	|			ТОГДА 
	|				ОбъектыРасчетов.ДатаВходящегоДокумента
	|		ИНАЧЕ 
	|			ОбъектыРасчетов.Дата
	|	КОНЕЦ КАК Дата,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект) = ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств)
	|				ИЛИ ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект) = ТИП(Документ.СписаниеБезналичныхДенежныхСредств)
	|			ТОГДА 
	|				ОбъектыРасчетов.НомерВходящегоДокумента
	|		ИНАЧЕ 
	|			ОбъектыРасчетов.Номер
	|	КОНЕЦ КАК Номер
	|ИЗ
	|	ВременнаяТаблица КАК ДебиторскаяЗадолженность
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ОбъектыРасчетов КАК ОбъектыРасчетов
	|			ПО ОбъектыРасчетов.Ссылка = ДебиторскаяЗадолженность.ОбъектРасчетов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыРасчетов КАК ЗеркальныйОбъектРасчетов
	|			ПО ЗеркальныйОбъектРасчетов.Организация = ОбъектыРасчетов.Контрагент
	|				И ЗеркальныйОбъектРасчетов.ТипРасчетов = 
	|					ВЫБОР КОГДА ОбъектыРасчетов.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетовСПартнерами.РасчетыСКлиентом)
	|						ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыРасчетовСПартнерами.РасчетыСПоставщиком)
	|						ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыРасчетовСПартнерами.РасчетыСКлиентом)
	|					КОНЕЦ
	|				И ВЫБОР
	|					КОГДА ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект) = ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств)
	|						ТОГДА ТИПЗНАЧЕНИЯ(ЗеркальныйОбъектРасчетов.Объект) = ТИП(Документ.СписаниеБезналичныхДенежныхСредств)
	|							И ЗеркальныйОбъектРасчетов.Сумма = ОбъектыРасчетов.Сумма
	|							И ЗеркальныйОбъектРасчетов.ДатаВходящегоДокумента = ОбъектыРасчетов.ДатаВходящегоДокумента
	|							И ЗеркальныйОбъектРасчетов.НомерВходящегоДокумента = ОбъектыРасчетов.НомерВходящегоДокумента
	|							И ЗеркальныйОбъектРасчетов.Валюта = ОбъектыРасчетов.Валюта
	|					КОГДА ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект) = ТИП(Документ.СписаниеБезналичныхДенежныхСредств)
	|						ТОГДА ТИПЗНАЧЕНИЯ(ЗеркальныйОбъектРасчетов.Объект) = ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств)
	|							И ЗеркальныйОбъектРасчетов.Сумма = ОбъектыРасчетов.Сумма
	|							И ЗеркальныйОбъектРасчетов.ДатаВходящегоДокумента = ОбъектыРасчетов.ДатаВходящегоДокумента
	|							И ЗеркальныйОбъектРасчетов.НомерВходящегоДокумента = ОбъектыРасчетов.НомерВходящегоДокумента
	|							И ЗеркальныйОбъектРасчетов.Валюта = ОбъектыРасчетов.Валюта
	|					КОГДА ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект) = ТИП(Документ.ПриходныйКассовыйОрдер)
	|						ТОГДА ТИПЗНАЧЕНИЯ(ЗеркальныйОбъектРасчетов.Объект) = ТИП(Документ.РасходныйКассовыйОрдер)
	|							И ЗеркальныйОбъектРасчетов.Сумма = ОбъектыРасчетов.Сумма
	|							И ЗеркальныйОбъектРасчетов.Дата = ОбъектыРасчетов.Дата
	|							И ЗеркальныйОбъектРасчетов.Номер = ОбъектыРасчетов.Номер
	|							И ЗеркальныйОбъектРасчетов.Валюта = ОбъектыРасчетов.Валюта
	|					КОГДА ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект) = ТИП(Документ.РасходныйКассовыйОрдер)
	|						ТОГДА ТИПЗНАЧЕНИЯ(ЗеркальныйОбъектРасчетов.Объект) = ТИП(Документ.ПриходныйКассовыйОрдер)
	|							И ЗеркальныйОбъектРасчетов.Сумма = ОбъектыРасчетов.Сумма
	|							И ЗеркальныйОбъектРасчетов.Дата = ОбъектыРасчетов.Дата
	|							И ЗеркальныйОбъектРасчетов.Номер = ОбъектыРасчетов.Номер
	|							И ЗеркальныйОбъектРасчетов.Валюта = ОбъектыРасчетов.Валюта
	|					ИНАЧЕ ЗеркальныйОбъектРасчетов.Объект = ОбъектыРасчетов.Объект
	|				КОНЕЦ";
	
	Если ИмяТаблицы = "КредиторскаяЗадолженность" Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВтДебиторскаяЗадолженность", "ВтКредиторскаяЗадолженность");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДебиторскаяЗадолженность", ИмяТаблицы);
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВременнаяТаблица", "Вт" + ИмяТаблицы);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаПоРеквизитуДокумента(ИмяРеквизита)
	
	ТекстЗапроса =  
	"ВЫБРАТЬ
	|	ОбъектыРасчетов.Ссылка              КАК ОбъектРасчетов,
	|	ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект) КАК ТипОбъектаРасчетов,
	|	ЗеркальныеОбъектыРасчетов.Ссылка    КАК ОбъектРасчетовЗеркальный,
	|	ОбъектыРасчетов.Контрагент          КАК ОрганизацияЗеркальная,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект) = ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств)
	|				ИЛИ ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект) = ТИП(Документ.СписаниеБезналичныхДенежныхСредств)
	|			ТОГДА 
	|				ОбъектыРасчетов.ДатаВходящегоДокумента
	|		ИНАЧЕ 
	|			ОбъектыРасчетов.Дата
	|	КОНЕЦ КАК Дата,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект) = ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств)
	|				ИЛИ ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект) = ТИП(Документ.СписаниеБезналичныхДенежныхСредств)
	|			ТОГДА 
	|				ОбъектыРасчетов.НомерВходящегоДокумента
	|		ИНАЧЕ 
	|			ОбъектыРасчетов.Номер
	|	КОНЕЦ КАК Номер
	|ИЗ
	|	Справочник.ОбъектыРасчетов КАК ОбъектыРасчетов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыРасчетов КАК ЗеркальныеОбъектыРасчетов
	|			ПО ЗеркальныеОбъектыРасчетов.Организация = ОбъектыРасчетов.Контрагент
	|				И ЗеркальныеОбъектыРасчетов.Контрагент = ОбъектыРасчетов.Организация
	|				И ЗеркальныеОбъектыРасчетов.ТипРасчетов = 
	|					ВЫБОР КОГДА ОбъектыРасчетов.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетовСПартнерами.РасчетыСКлиентом)
	|						ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыРасчетовСПартнерами.РасчетыСПоставщиком)
	|						ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыРасчетовСПартнерами.РасчетыСКлиентом)
	|					КОНЕЦ
	|				И ВЫБОР
	|					КОГДА ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект) = ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств)
	|						ТОГДА ТИПЗНАЧЕНИЯ(ЗеркальныеОбъектыРасчетов.Объект) = ТИП(Документ.СписаниеБезналичныхДенежныхСредств)
	|							И ЗеркальныеОбъектыРасчетов.Сумма = ОбъектыРасчетов.Сумма
	|							И ЗеркальныеОбъектыРасчетов.ДатаВходящегоДокумента = ОбъектыРасчетов.ДатаВходящегоДокумента
	|							И ЗеркальныеОбъектыРасчетов.НомерВходящегоДокумента = ОбъектыРасчетов.НомерВходящегоДокумента
	|							И ЗеркальныеОбъектыРасчетов.Валюта = ОбъектыРасчетов.Валюта
	|					КОГДА ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект) = ТИП(Документ.СписаниеБезналичныхДенежныхСредств)
	|						ТОГДА ТИПЗНАЧЕНИЯ(ЗеркальныеОбъектыРасчетов.Объект) = ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств)
	|							И ЗеркальныеОбъектыРасчетов.Сумма = ОбъектыРасчетов.Сумма
	|							И ЗеркальныеОбъектыРасчетов.ДатаВходящегоДокумента = ОбъектыРасчетов.ДатаВходящегоДокумента
	|							И ЗеркальныеОбъектыРасчетов.НомерВходящегоДокумента = ОбъектыРасчетов.НомерВходящегоДокумента
	|							И ЗеркальныеОбъектыРасчетов.Валюта = ОбъектыРасчетов.Валюта
	|					КОГДА ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект) = ТИП(Документ.ПриходныйКассовыйОрдер)
	|						ТОГДА ТИПЗНАЧЕНИЯ(ЗеркальныеОбъектыРасчетов.Объект) = ТИП(Документ.РасходныйКассовыйОрдер)
	|							И ЗеркальныеОбъектыРасчетов.Сумма = ОбъектыРасчетов.Сумма
	|							И ЗеркальныеОбъектыРасчетов.Дата = ОбъектыРасчетов.Дата
	|							И ЗеркальныеОбъектыРасчетов.Номер = ОбъектыРасчетов.Номер
	|							И ЗеркальныеОбъектыРасчетов.Валюта = ОбъектыРасчетов.Валюта
	|					КОГДА ТИПЗНАЧЕНИЯ(ОбъектыРасчетов.Объект) = ТИП(Документ.РасходныйКассовыйОрдер)
	|						ТОГДА ТИПЗНАЧЕНИЯ(ЗеркальныеОбъектыРасчетов.Объект) = ТИП(Документ.ПриходныйКассовыйОрдер)
	|							И ЗеркальныеОбъектыРасчетов.Сумма = ОбъектыРасчетов.Сумма
	|							И ЗеркальныеОбъектыРасчетов.Дата = ОбъектыРасчетов.Дата
	|							И ЗеркальныеОбъектыРасчетов.Номер = ОбъектыРасчетов.Номер
	|							И ЗеркальныеОбъектыРасчетов.Валюта = ОбъектыРасчетов.Валюта
	|					ИНАЧЕ ЗеркальныеОбъектыРасчетов.Объект = ОбъектыРасчетов.Объект
	|				КОНЕЦ
	|ГДЕ
	|	ОбъектыРасчетов.Ссылка" + " = &" + ИмяРеквизита;
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ПроверитьЗаполнениеТабличнойЧасти(ИмяТЧ, ИмяСписка, МассивНепроверяемых, Отказ)
	
	Шаблон = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""%3""';
					|en = 'Column ""%1"" in line %2 of list ""%3"" is required'");
	Шаблон = СтрЗаменить(Шаблон,"%3",ИмяСписка);
	Для Каждого Строка Из ЭтотОбъект[ИмяТЧ] Цикл
		Для Каждого Реквизит Из ЭтотОбъект.Метаданные().ТабличныеЧасти[ИмяТЧ].Реквизиты Цикл
			Если Реквизит.ПроверкаЗаполнения = ПроверкаЗаполнения.ВыдаватьОшибку 
				И МассивНепроверяемых.Найти(ИмяТЧ + "." + Реквизит.Имя) = Неопределено Тогда
				Если НЕ ЗначениеЗаполнено(Строка[Реквизит.Имя]) Тогда
					ТекстСообщения = СтрЗаменить(Шаблон,"%1",Реквизит.Синоним);
					ТекстСообщения = СтрЗаменить(ТекстСообщения,"%2",Строка.НомерСтроки);
					ОбщегоНазначения.СообщитьПользователю(
						ТекстСообщения,
						ЭтотОбъект,
						, // Поле
						,
						Отказ);
				КонецЕсли;
				МассивНепроверяемых.Добавить(ИмяТЧ + "." + Реквизит.Имя);
			КонецЕсли;
		КонецЦикла;// по реквизитам табличной части
	КонецЦикла;// по строкам табличной части
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
