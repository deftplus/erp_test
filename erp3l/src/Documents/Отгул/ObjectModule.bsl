#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИСотрудникам(ЭтотОбъект, Таблица, "Организация", "Сотрудник");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

// В качестве данных заполнения может принимать структуру с полями.
//		Ссылка
//		Действие
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
				ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, 
												ДанныеЗаполнения.Ссылка, 
												, 
												"Начисления,НачисленияПерерасчет,НачисленияПерерасчетНулевыеСторно,
												|Показатели,РаспределениеРезультатовНачислений");
			
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
		ИначеЕсли ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "ЗаполнитьПоПараметрамЗаполнения" Тогда
			ЗаполнитьПоПараметрамЗаполнения(ДанныеЗаполнения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.Отгул.ПровестиПоУчетам(Ссылка, РежимПроведения, Отказ, Неопределено, Движения, ЭтотОбъект, ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОтсутствиеВТечениеЧастиСмены Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаНачала");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаОкончания");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "КоличествоДнейОтгула");
		
		ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаОтсутствия, "Объект.ДатаОтсутствия", Отказ, НСтр("ru = 'Дата отгула';
																											|en = 'Date off date'"), , , Ложь);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "КоличествоЧасовОтгула");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаОтсутствия");
		
		ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаНачала, "Объект.ДатаНачала", Отказ, НСтр("ru = 'Дата начала';
																									|en = 'Start date'"), , , Ложь);
		
	КонецЕсли;
	
	ПраваНаДокумент = ЗарплатаКадрыРасширенный.ПраваНаМногофункциональныйДокумент(ЭтотОбъект);
	
	Если ОтсутствиеВТечениеЧастиСмены Тогда
				
		ДанныеОВремениДляПроверки = Документы.Отгул.ДанныеОВремени(ЭтотОбъект);
		ОшибкиВводаВремени = УчетРабочегоВремениРасширенный.ПроверитьРегистрациюВнутрисменногоВремени(Ссылка, ДанныеОВремениДляПроверки, ПериодРегистрации);
		
		Ошибки = Новый Соответствие;
		Для Каждого ОписаниеОшибки Из ОшибкиВводаВремени Цикл				
			
			УчетРабочегоВремениРасширенный.ДобавитьОшибкуПоСотруднику(Ошибки, ОписаниеОшибки.Сотрудник, ОписаниеОшибки.ТекстОшибки, "", ОписаниеОшибки.Документ);		
			
		КонецЦикла;	

		УчетРабочегоВремениРасширенный.ВывестиОшибкиПоСотрудникам(Ошибки, Отказ);
	КонецЕсли;		
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
		
		Если Не ЗначениеЗаполнено(ВидРасчета) 
			И Не ПолучитьФункциональнуюОпцию("ВыбиратьВидНачисленияОтгул") Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				Документы.Отгул.ТекстСообщенияНеЗаполненВидРасчета(ОтсутствиеВТечениеЧастиСмены),
			Ссылка,
			,
			,
			Отказ);
		КонецЕсли;
		
		Если ПерерасчетВыполнен Тогда 
			
			// Проверка корректности распределения по источникам финансирования
			ИменаТаблицРаспределяемыхПоСтатьямФинансирования = "Начисления,НачисленияПерерасчет";
			
			ОтражениеЗарплатыВБухучетеРасширенный.ПроверитьРезультатыРаспределенияНачисленийУдержанийОбъекта(
				ЭтотОбъект, ИменаТаблицРаспределяемыхПоСтатьямФинансирования, Отказ);
			
			// Проверка корректности распределения по территориям и условиям труда
			ИменаТаблицРаспределенияПоТерриториямУсловиямТруда = "Начисления,НачисленияПерерасчет";
			
			РасчетЗарплатыРасширенный.ПроверитьРаспределениеПоТерриториямУсловиямТрудаДокумента(
				ЭтотОбъект, ИменаТаблицРаспределенияПоТерриториямУсловиямТруда, Отказ);
			
			ПроверитьПериодДействияНачислений(Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОсвобождатьСтавку Тогда
		УправлениеШтатнымРасписанием.ПроверитьВозможностьПроведенияВременногоОсвобожденияСтавок(
			Ссылка, Проведен, Сотрудник, ДатаНачала, ДатаОкончания, Отказ, ИсправленныйДокумент);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если ОсвобождатьСтавку Тогда
		УправлениеШтатнымРасписанием.ПроверитьВозможностьОтменыПроведения(Ссылка, Сотрудник, ДатаНачала, ДатаОкончания, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеПериода = ЗарплатаКадрыРасширенный.ПредставлениеПериодаРасчетногоДокумента(ДатаНачала, ДатаОкончания);
	
	РасчетЗарплатыРасширенный.ЗаполнитьИсходныйДокумент(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	РасчетЗарплатыРасширенный.ЗаполнитьИсходныйДокументПриКопировании(ЭтотОбъект, ОбъектКопирования.Ссылка);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПериодДействияНачислений(Отказ)
	ПараметрыПроверкиПериодаДействия = РасчетЗарплатыРасширенный.ПараметрыПроверкиПериодаДействия();
	ПараметрыПроверкиПериодаДействия.Ссылка = Ссылка;
	ПроверяемыеКоллекции = Новый Массив;
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("НачисленияПерерасчет", НСтр("ru = 'Перерасчет прошлого периода';
																																	|en = 'Recalculation of the last period'")));
	РасчетЗарплатыРасширенный.ПроверитьПериодДействияВКоллекцияхНачислений(ЭтотОбъект, ПараметрыПроверкиПериодаДействия, ПроверяемыеКоллекции, Отказ);
КонецПроцедуры

Процедура ЗаполнитьПоПараметрамЗаполнения(ДанныеЗаполнения)
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	
	ЗаполняемыеЗначения = Новый Структура(
		"ПериодРегистрации, 
		|Ответственный");
	ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения, ТекущаяДатаСеанса());
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗаполняемыеЗначения);	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли