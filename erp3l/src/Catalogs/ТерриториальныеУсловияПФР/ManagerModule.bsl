#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

// Возвращает реквизиты справочника, которые образуют естественный ключ для элементов справочника.
//
// Возвращаемое значение:
//  Массив из Строка - имена реквизитов, образующих естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Код");
	
	Возврат Результат;
	
КонецФункции

// Конец ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ДанныеВыбораБЗК.ЗаполнитьДляКлассификатораСПорядкомПоКоду(
		Справочники.ТерриториальныеУсловияПФР,
		ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
	Если ДанныеВыбора <> Неопределено Тогда
		
		Если Параметры.Свойство("ВыбиратьТерриторииСОсобымиКлиматическимиУсловиями") Тогда
			
			ВыбиратьТерриторииСОсобымиКлиматическимиУсловиями = Параметры.ВыбиратьТерриторииСОсобымиКлиматическимиУсловиями;
			Если НЕ ВыбиратьТерриторииСОсобымиКлиматическимиУсловиями Тогда
				
				Для Каждого Территория Из СписокТерриторийСОсобымиКлиматическимиУсловиями() Цикл
					ЭлементПрочиеТерритории = ДанныеВыбора.НайтиПоЗначению(Территория.Значение);
					Если ЭлементПрочиеТерритории <> Неопределено Тогда
						ДанныеВыбора.Удалить(ЭлементПрочиеТерритории);
					КонецЕсли;
				КонецЦикла;
				
			КонецЕсли;
			
		Иначе
			ЭлементПрочиеТерритории = ДанныеВыбора.НайтиПоЗначению(ПредопределенноеЗначение("Справочник.ТерриториальныеУсловияПФР.ПРОЧ"));
			Если ЭлементПрочиеТерритории <> Неопределено Тогда
				ДанныеВыбора.Удалить(ЭлементПрочиеТерритории);
			КонецЕсли; 
		КонецЕсли; 
		
		Если Параметры.Свойство("ВыбиратьЗаграничныеТерритории") Тогда
			Если Не Параметры.ВыбиратьЗаграничныеТерритории = Истина Тогда
				ЭлементПрочиеТерритории = ДанныеВыбора.НайтиПоЗначению(ПредопределенноеЗначение("Справочник.ТерриториальныеУсловияПФР.ЗАГР"));
				Если ЭлементПрочиеТерритории <> Неопределено Тогда
					ДанныеВыбора.Удалить(ЭлементПрочиеТерритории);
				КонецЕсли;
			КонецЕсли;
		Иначе
			ЭлементПрочиеТерритории = ДанныеВыбора.НайтиПоЗначению(ПредопределенноеЗначение("Справочник.ТерриториальныеУсловияПФР.ЗАГР"));
			Если ЭлементПрочиеТерритории <> Неопределено Тогда
				ДанныеВыбора.Удалить(ЭлементПрочиеТерритории);
			КонецЕсли;
		КонецЕсли;
		
		Если Параметры.Свойство("ВыбиратьТерриторииВСельскойМестности") Тогда
			Если Не Параметры.ВыбиратьЗаграничныеТерритории = Истина Тогда
				ЭлементПрочиеТерритории = ДанныеВыбора.НайтиПоЗначению(ПредопределенноеЗначение("Справочник.ТерриториальныеУсловияПФР.СЕЛО"));
				Если ЭлементПрочиеТерритории <> Неопределено Тогда
					ДанныеВыбора.Удалить(ЭлементПрочиеТерритории);
				КонецЕсли;
			КонецЕсли;
		Иначе
			ЭлементПрочиеТерритории = ДанныеВыбора.НайтиПоЗначению(ПредопределенноеЗначение("Справочник.ТерриториальныеУсловияПФР.СЕЛО"));
			Если ЭлементПрочиеТерритории <> Неопределено Тогда
				ДанныеВыбора.Удалить(ЭлементПрочиеТерритории);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция СписокТерриторийСОсобымиКлиматическимиУсловиями() Экспорт
	
	СписокТерриторий = СписокСеверныхТерриториальныхУсловий();
	СписокТерриторий.Добавить(ПредопределенноеЗначение("Справочник.ТерриториальныеУсловияПФР.ПРОЧ"));
	
	Возврат СписокТерриторий;
	
КонецФункции

Функция СписокСеверныхТерриториальныхУсловий() Экспорт
	
	СписокТерриторий = Новый СписокЗначений;
	СписокТерриторий.Добавить(ПредопределенноеЗначение("Справочник.ТерриториальныеУсловияПФР.МКС"));
	СписокТерриторий.Добавить(ПредопределенноеЗначение("Справочник.ТерриториальныеУсловияПФР.МКСР"));
	СписокТерриторий.Добавить(ПредопределенноеЗначение("Справочник.ТерриториальныеУсловияПФР.РКС"));
	СписокТерриторий.Добавить(ПредопределенноеЗначение("Справочник.ТерриториальныеУсловияПФР.РКСМ"));
	
	Возврат СписокТерриторий;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НачальноеЗаполнение() Экспорт
	
	ОписаниеЭлемента = ОписаниеЭлемента();
	ОписаниеЭлемента.ИмяПредопределенныхДанных = "МКС";
	ОписаниеЭлемента.Код = ОписаниеЭлемента.ИмяПредопределенныхДанных;
	ОписаниеЭлемента.Наименование = "Местность, приравненная к районам Крайнего Севера";
	СоздатьЭлементПоОписанию(ОписаниеЭлемента);
	
	ОписаниеЭлемента = ОписаниеЭлемента();
	ОписаниеЭлемента.ИмяПредопределенныхДанных = "МКСР";
	ОписаниеЭлемента.Код = ОписаниеЭлемента.ИмяПредопределенныхДанных;
	ОписаниеЭлемента.Наименование = "Местность, приравненная к районам Крайнего Севера, до 2002 г. относившаяся к районам Крайнего Севера";
	СоздатьЭлементПоОписанию(ОписаниеЭлемента);
	
	ОписаниеЭлемента = ОписаниеЭлемента();
	ОписаниеЭлемента.ИмяПредопределенныхДанных = "ПРОЧ";
	ОписаниеЭлемента.Код = ОписаниеЭлемента.ИмяПредопределенныхДанных;
	ОписаниеЭлемента.Наименование = "Прочие территории с особыми климатическими условиями";
	СоздатьЭлементПоОписанию(ОписаниеЭлемента);
	
	ОписаниеЭлемента = ОписаниеЭлемента();
	ОписаниеЭлемента.ИмяПредопределенныхДанных = "РКС";
	ОписаниеЭлемента.Код = ОписаниеЭлемента.ИмяПредопределенныхДанных;
	ОписаниеЭлемента.Наименование = "Район Крайнего Севера";
	СоздатьЭлементПоОписанию(ОписаниеЭлемента);
	
	ОписаниеЭлемента = ОписаниеЭлемента();
	ОписаниеЭлемента.ИмяПредопределенныхДанных = "РКСМ";
	ОписаниеЭлемента.Код = ОписаниеЭлемента.ИмяПредопределенныхДанных;
	ОписаниеЭлемента.Наименование = "Район Крайнего Севера, до 2002 г. являвшийся местностью, приравненной к районам Крайнего Севера";
	СоздатьЭлементПоОписанию(ОписаниеЭлемента);
	
	ОписаниеЭлемента = ОписаниеЭлемента();
	ОписаниеЭлемента.Код = "Ч31";
	ОписаниеЭлемента.Наименование = "Работа в зоне отчуждения";
	СоздатьЭлементПоОписанию(ОписаниеЭлемента);
	
	ОписаниеЭлемента = ОписаниеЭлемента();
	ОписаниеЭлемента.Код = "Ч33";
	ОписаниеЭлемента.Наименование = "Постоянное проживание (работа) на территории зоны проживания с правом на отселение";
	СоздатьЭлементПоОписанию(ОписаниеЭлемента);
	
	ОписаниеЭлемента = ОписаниеЭлемента();
	ОписаниеЭлемента.Код = "Ч34";
	ОписаниеЭлемента.Наименование = "Постоянное проживание (работа) на территории зоны проживания с льг. социально-экономическим статусом";
	СоздатьЭлементПоОписанию(ОписаниеЭлемента);
	
	ОписаниеЭлемента = ОписаниеЭлемента();
	ОписаниеЭлемента.Код = "Ч35";
	ОписаниеЭлемента.Наименование = "Постоянное проживание (работа) в зоне отселения до переселения в другие районы";
	СоздатьЭлементПоОписанию(ОписаниеЭлемента);
	
	ОписаниеЭлемента = ОписаниеЭлемента();
	ОписаниеЭлемента.Код = "Ч36";
	ОписаниеЭлемента.Наименование = "Работа в зоне отселения (по фактической продолжительности)";
	СоздатьЭлементПоОписанию(ОписаниеЭлемента);
	
	ОписаниеЭлемента = ОписаниеЭлемента();
	ОписаниеЭлемента.ИмяПредопределенныхДанных = "ЗАГР";
	ОписаниеЭлемента.Код = ОписаниеЭлемента.ИмяПредопределенныхДанных;
	ОписаниеЭлемента.Наименование = "Территория за пределами РФ";
	СоздатьЭлементПоОписанию(ОписаниеЭлемента);
	
КонецПроцедуры

Функция ОписаниеЭлемента()
	Возврат Новый Структура("ИмяПредопределенныхДанных, Код, Наименование");	
КонецФункции	

Процедура СоздатьЭлементПоОписанию(ОписаниеЭлемента)
	
	Если ЗначениеЗаполнено(ОписаниеЭлемента.ИмяПредопределенныхДанных) Тогда
		
		СсылкаПредопределенного = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ТерриториальныеУсловияПФР." + ОписаниеЭлемента.ИмяПредопределенныхДанных);
		Если ЗначениеЗаполнено(СсылкаПредопределенного) Тогда
			Элемент = СсылкаПредопределенного.ПолучитьОбъект();
		Иначе
			Элемент = СоздатьЭлемент();
			Элемент.ИмяПредопределенныхДанных = ОписаниеЭлемента.ИмяПредопределенныхДанных;
		КонецЕсли;
		
	Иначе
		
		СсылкаНаОбъект = НайтиПоКоду(ОписаниеЭлемента.Код); 
		Если ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
			Элемент = СсылкаНаОбъект.ПолучитьОбъект();
		Иначе
			Элемент = СоздатьЭлемент();
		КонецЕсли;
		
	КонецЕсли; 
	
	ЗаполнитьЗначенияСвойств(Элемент, ОписаниеЭлемента);
	Элемент.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
	Элемент.Записать();
	
КонецПроцедуры	

#КонецОбласти

#КонецЕсли

