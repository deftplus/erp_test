#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ИсправлениеДокументов.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатковПрочиеРасходы.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "ПрочиеРасходы");
	
	ВводОстатковЛокализация.ВводОстатковПрочиеРасходыПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	ВводОстатковЛокализация.ВводОстатковПрочиеРасходыОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	ВводОстатковЛокализация.ВводОстатковПрочиеРасходыОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ОтражатьВОперативномУчете 
		И Не ОтражатьСебестоимость
		И Не ОтражатьВБУиНУ
		И Не ОтражатьВУУ Тогда
		
		ТекстСообщения = НСтр("ru = 'Операция должна отражаться в одном из учетов';
								|en = 'The operation must be recorded in one of accounting types'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , 
			"Объект.ОтражатьВОперативномУчете", , Отказ);
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковПрочихРасходов Тогда
		Для Каждого Строка Из ПрочиеРасходы Цикл
			Если Строка.Сумма = 0 И Строка.СуммаБезНДС = 0 И Строка.СуммаРегл = 0 
			 И Строка.НДСРегл = 0 И Строка.СуммаВР = 0 И Строка.СуммаПР = 0 Тогда
				ТекстОшибки = НСтр("ru = 'Не указаны суммы в строке %НомерСтроки% табличной части';
									|en = 'Amounts in row %НомерСтроки% of the table are not specified'");
				ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", Строка.НомерСтроки);
				ОбщегоНазначения.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПрочиеРасходы", Строка.НомерСтроки, "НомерСтроки"),
					,
					Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("ВидДеятельностиНДС");
	
	Если (Не ОтражатьВОперативномУчете И Не ОтражатьСебестоимость) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Валюта");
	КонецЕсли;
	
	Если НЕ ОтражатьВОперативномУчете  Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеРасходы.Сумма");
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеРасходы.СтавкаНДС");
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатковПрочиеРасходы.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	
	ИсправлениеДокументов.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ВводОстатковЛокализация.ВводОстатковПрочиеРасходыОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка." + Метаданные().Имя) Тогда
		
		ИсправлениеДокументов.ЗаполнитьИсправление(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	
	ВводОстатковЛокализация.ВводОстатковПрочиеРасходыОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
	ПараметрыЗаполнения = Документы.ВводОстатковПрочиеРасходы.ИнициализироватьПараметрыВидовДеятельностиНДС(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьВидДеятельностиНДС(ВидДеятельностиНДС, ПараметрыЗаполнения);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатковПрочиеРасходы.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "ПрочиеРасходы");
	
	ИсправлениеДокументов.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	ВводОстатковЛокализация.ВводОстатковПрочиеРасходыПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ВводОстатковЛокализация.ВводОстатковПрочиеРасходыПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("ХозяйственнаяОперация") Тогда
			ХозяйственнаяОперация = ДанныеЗаполнения.ХозяйственнаяОперация;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Комментарий") Тогда
			Комментарий = ДанныеЗаполнения.Комментарий;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ЗначениеКопирования") Тогда
			ВводОстатковСервер.ЗаполнитьЗначенияПоСтаромуВводуОстатков(ЭтотОбъект, ДанныеЗаполнения.ЗначениеКопирования);
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыЗаполнения = Документы.ВводОстатковПрочиеРасходы.ИнициализироватьПараметрыВидовДеятельностиНДС(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьВидДеятельностиНДС(ВидДеятельностиНДС, ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
