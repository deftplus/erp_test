#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка,,"НачисленияПерерасчет");
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
			НачисленияПерерасчет.Очистить();
			Для Каждого СтрокаНачисления Из Начисления Цикл
				СтрокаПерерасчета = НачисленияПерерасчет.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаПерерасчета, СтрокаНачисления);
				СтрокаПерерасчета.Сторно = Истина;
				СтрокаПерерасчета.СторнируемыйДокумент = ДанныеЗаполнения.Ссылка;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.ПризПодарок.ПровестиПоУчетам(Ссылка, РежимПроведения, Отказ, Неопределено, Движения, ЭтотОбъект, ДополнительныеСвойства);
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Удержано = Начисления.Итог("СуммаНДФЛ") + НачисленияПерерасчет.Итог("СуммаНДФЛ");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеДляБухучета = Документы.ПризПодарок.ДанныеДляБухучетаЗарплатыПервичныхДокументов(ЭтотОбъект);
	ОтражениеЗарплатыВБухучетеРасширенный.ЗарегистрироватьБухучетЗарплатыПервичныхДокументов(ДанныеДляБухучета);
	
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаПолученияДохода, "Объект.ДатаПолученияДохода", Отказ, НСтр("ru = 'Дата выдачи';
																													|en = 'Date of issue'"), , , Ложь);
	
	ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИсправленныйДокумент = Неопределено;
	НачисленияПерерасчет.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли