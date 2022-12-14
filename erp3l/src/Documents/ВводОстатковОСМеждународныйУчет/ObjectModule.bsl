#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ДанныеЗаполненияТип = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполненияТип = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
	ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатковОСМеждународныйУчет.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Ложь, Отказ);
	
	Если ПорядокУчета<>Перечисления.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НачислятьАмортизацию Тогда
		
		НепроверяемыеРеквизиты.Добавить("МетодНачисленияАмортизации");
		НепроверяемыеРеквизиты.Добавить("СрокИспользования");
		НепроверяемыеРеквизиты.Добавить("ПоказательНаработки");
		НепроверяемыеРеквизиты.Добавить("ОбъемНаработки");
		НепроверяемыеРеквизиты.Добавить("КоэффициентУскорения");
		
		НепроверяемыеРеквизиты.Добавить("СтатьяРасходов");
		НепроверяемыеРеквизиты.Добавить("АналитикаРасходов");
		
		Если НакопленнаяАмортизация = 0 И НакопленнаяАмортизацияПредставления = 0 Тогда
			НепроверяемыеРеквизиты.Добавить("СчетАмортизации");
		КонецЕсли;
		
	КонецЕсли;
	
	Если МетодНачисленияАмортизации<>Перечисления.СпособыНачисленияАмортизацииОС.УменьшаемогоОстатка Тогда
		НепроверяемыеРеквизиты.Добавить("КоэффициентУскорения");
	КонецЕсли;
	
	Если МетодНачисленияАмортизации=Перечисления.СпособыНачисленияАмортизацииОС.ПропорциональноОбъемуПродукции Тогда
		НепроверяемыеРеквизиты.Добавить("СрокИспользования");
	Иначе
		НепроверяемыеРеквизиты.Добавить("ПоказательНаработки");
		НепроверяемыеРеквизиты.Добавить("ОбъемНаработки");
	КонецЕсли;
	
	Если НепроверяемыеРеквизиты.Найти("СтатьяРасходов") = Неопределено Тогда
		ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатковОСМеждународныйУчет.ПараметрыВыбораСтатейИАналитик();
		ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если МетодНачисленияАмортизации<>Перечисления.СпособыНачисленияАмортизацииОС.УменьшаемогоОстатка Тогда
		КоэффициентУскорения = 1;
	КонецЕсли;
	
	Если МетодНачисленияАмортизации<>Перечисления.СпособыНачисленияАмортизацииОС.ПропорциональноОбъемуПродукции Тогда
		ПоказательНаработки = Неопределено;
		ОбъемНаработки = 0;
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатковОСМеждународныйУчет.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли