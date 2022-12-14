#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ОбработкаПроведения(Отказ, Режим)
	
	СтатусУтверждения = УправлениеПроцессамиСогласованияУХ.ВернутьСтатусОбъекта(Ссылка);
	Если СтатусУтверждения = Перечисления.СостоянияСогласования.Утверждена И РешениеПоДокументу Тогда
		Движения.АккредитованыеПоставщики.Записывать = Истина;
		Движения.СостоянияАккредитованныхПоставщиков.Записывать = Истина;
	
		Движение = Движения.АккредитованыеПоставщики.Добавить();
		Движение.Период = Дата;
		Движение.Организация = Организация;
		Движение.Контрагент = АнкетаПоставщика.Контрагент;
		Движение.АнкетаПоставщика = АнкетаПоставщика;
		Движение.ДатаОкончания = ДатаОтзываАккредитации;
		Движение.ДатаНачала = ДатаОтзываАккредитации;
		Движение.Состояние = Перечисления.СостоянияАккредитацииПоставщиков.НеАккредитован;
		
		// Записываем общее состояние в целом по холдингу
		АккредитацияПоставщиковУХ.ДобавитьДвижениеСостояниеАккредитацииПоставщика(
			Движения.СостоянияАккредитованныхПоставщиков,
			АнкетаПоставщика,
			Дата,
			Организация,
			Ложь,
			ДатаОтзываАккредитации);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Отбор_ = Новый Соответствие;
	Отбор_.Вставить("Ссылка", Новый Структура("Значение,ВидСравнения", Ссылка, "<>"));
	ДругойДокумент = АккредитацияПоставщиковУХ.ПолучитьДокументыАккредитации(
		"ОтзывАккредитации",
		Организация,
		АнкетаПоставщика,
		ДатаОтзываАккредитации,
		Отбор_);
	
	Если ЗначениеЗаполнено(ДругойДокумент) Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтрШаблон(Нстр("ru = 'Уже введен отзыв аккредитации поставщика ""%1"" с %2'"), АнкетаПоставщика, 
			ДатаОтзываАккредитации);
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	флНеАккредитован = Истина;
	ДанныеАккредитации = АккредитацияПоставщиковУХ.ПолучитьДанныеАккредитацииПоставщика(Организация, АнкетаПоставщика, Дата);
	Если ДанныеАккредитации <> Неопределено Тогда
		флНеАккредитован = ДанныеАккредитации.Состояние <> Перечисления.СостоянияАккредитацииПоставщиков.Аккредитован;
	КонецЕсли;
	Если флНеАккредитован И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтрШаблон(Нстр("ru = 'Поставщик ""%1"" не аккредитован на дату документа (%2)'"), АнкетаПоставщика, Дата);
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		ТипЗаполнения = ТипЗнч(ДанныеЗаполнения);
		
		Если ТипЗаполнения = Тип("Структура") Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
			
		Иначе
			Если НЕ ЦентрализованныеЗакупкиУХ.ОбъектУтвержден(ДанныеЗаполнения.Ссылка) Тогда
				ВызватьИсключение Нстр("ru = 'Ввод на основании можно делать только на основании утвержденного объекта!'");
			КонецЕсли;
			Если Документы.ТипВсеСсылки().СодержитТип(ТипЗаполнения) Тогда
				Если НЕ ДанныеЗаполнения.Проведен Тогда
					ВызватьИсключение Нстр("ru = 'Ввод на основании можно делать только на основании проведенного документа!'");
				КонецЕсли;
				Если ТипЗаполнения = Тип("ДокументСсылка.АккредитацияПоставщика") И
					ДанныеЗаполнения.РешениеПоДокументу <> Перечисления.ВидыРешенийПоДокументуАккредитации.ПоложительноеРешение Тогда
					ВызватьИсключение Нстр("ru = 'Ввод на основании можно делать только на основании Аккредитации с положительным решением!'");
				КонецЕсли;
			КонецЕсли;
			
			Если ТипЗаполнения = Тип("СправочникСсылка.АнкетыПоставщиков") Тогда
				АнкетаПоставщика = ДанныеЗаполнения;
			ИначеЕсли ТипЗаполнения = Тип("ДокументСсылка.АккредитацияПоставщика") Тогда
				АнкетаПоставщика = ДанныеЗаполнения.АнкетаПоставщика;
				Организация = ДанныеЗаполнения.Организация;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
		
	ЭтоВнешнийПользователь = ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя();
	
	Если ЭтоВнешнийПользователь Тогда
		ТекущийПользователь = Пользователи.АвторизованныйПользователь();
		АнкетаПоставщика = ТекущийПользователь.ОбъектАвторизации;
		Если НЕ ЗначениеЗаполнено(АнкетаПоставщика) Тогда
			ВызватьИсключение Нстр("ru = 'Не удалось определить анкету поставщика для текущего пользователя!'");
		КонецЕсли;
		
	Иначе
		Если НЕ ЗначениеЗаполнено(Ответственный) Тогда
			Ответственный = Пользователи.ТекущийПользователь();
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаОтзываАккредитации) Тогда
		ДатаОтсчета = Дата;
		Если НЕ ЗначениеЗаполнено(ДатаОтсчета) Тогда
			ДатаОтсчета = ТекущаяДатаСеанса();
		КонецЕсли;
		ДатаОтзываАккредитации = ДобавитьМесяц(ДатаОтсчета, 1);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АнкетаПоставщика) Тогда
		Если ЗначениеЗаполнено(Организация) Тогда
			ДанныеАккредитации = АккредитацияПоставщиковУХ.ПолучитьДанныеАккредитацииПоставщика(Организация, АнкетаПоставщика, Дата);
			флАккредитован = (ДанныеАккредитации <> Неопределено)
				И ДанныеАккредитации.Состояние = Перечисления.СостоянияАккредитацииПоставщиков.Аккредитован;
		Иначе
			ДанныеАккредитации = АккредитацияПоставщиковУХ.ПолучитьОписаниеСтатусаАккредитацииПоставщика(АнкетаПоставщика, Дата);
			флАккредитован = ДанныеАккредитации.Аккредитован;
		КонецЕсли;
		Если НЕ флАккредитован Тогда
			ВызватьИсключение СтрШаблон(Нстр("ru = 'Поставщик ""%1"" не аккредитован.'"), АнкетаПоставщика);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если РешениеПоДокументу Тогда
		ПроверяемыеРеквизиты.Добавить("ОбоснованиеРешения");
	КонецЕсли;
КонецПроцедуры

#КонецЕсли
