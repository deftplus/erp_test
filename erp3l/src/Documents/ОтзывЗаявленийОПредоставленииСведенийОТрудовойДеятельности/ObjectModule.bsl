#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ФизическиеЛицаЗаявления = Новый Соответствие;
	Для Каждого СтрокаСотрудника Из Сотрудники Цикл
		
		Если ЗначениеЗаполнено(СтрокаСотрудника.Сотрудник) И ЗначениеЗаполнено(СтрокаСотрудника.Заявление) Тогда
			
			ЗаявленияФизическогоЛица = ФизическиеЛицаЗаявления.Получить(СтрокаСотрудника.Сотрудник);
			Если ЗаявленияФизическогоЛица = Неопределено Тогда
				ЗаявленияФизическогоЛица = Новый Соответствие;
				ФизическиеЛицаЗаявления.Вставить(СтрокаСотрудника.Сотрудник, ЗаявленияФизическогоЛица);
			КонецЕсли;
			
			ИзвестнаяСтрока = ЗаявленияФизическогоЛица.Получить(СтрокаСотрудника.Заявление);
			Если ИзвестнаяСтрока = Неопределено Тогда
				ЗаявленияФизическогоЛица.Вставить(СтрокаСотрудника.Заявление, СтрокаСотрудника);
			Иначе
				
				ТекстСообщения = СтрШаблон(
					НСтр("ru = 'Для сотрудника %1 в строке %2 уже добавлено заявление %3 для отмены';
						|en = 'For employee %1 in line %2 the application %3 for cancelling is already added'"),
					ИзвестнаяСтрока.Сотрудник,
					ИзвестнаяСтрока.НомерСтроки,
					ИзвестнаяСтрока.Заявление);
				
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка,
					"Объект.Сотрудники[" + (СтрокаСотрудника.НомерСтроки - 1) + "].Заявление", , Отказ);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = Документы.ОтзывЗаявленийОПредоставленииСведенийОТрудовойДеятельности.ДанныеДляПроведенияДокумента(Ссылка);
	ЭлектронныеТрудовыеКнижки.СформироватьДвиженияЗаявленийОВеденииТрудовыхКнижекОтозванные(
		Движения.ЗаявленияОВеденииТрудовыхКнижекОтозванные, ДанныеДляПроведения.ЗаявленияОВеденииТрудовыхКнижекОтозванные);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ТаблицаОтбора = Сотрудники.Выгрузить(, "НомерСтроки,Сотрудник,Заявление");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ТаблицаОтбора", ТаблицаОтбора);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаОтбора.НомерСтроки КАК НомерСтроки,
		|	&Организация КАК Организация,
		|	ТаблицаОтбора.Сотрудник КАК ФизическоеЛицо,
		|	ТаблицаОтбора.Заявление КАК Заявление
		|ПОМЕСТИТЬ ВТТаблицаОтбора
		|ИЗ
		|	&ТаблицаОтбора КАК ТаблицаОтбора
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаОтбора.НомерСтроки КАК НомерСтроки,
		|	ТаблицаОтбора.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ТаблицаОтбора.Заявление КАК Заявление,
		|	ЗаявленияОВеденииТрудовыхКнижекПереданные.Регистратор КАК Регистратор
		|ИЗ
		|	ВТТаблицаОтбора КАК ТаблицаОтбора
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗаявленияОВеденииТрудовыхКнижекПереданные КАК ЗаявленияОВеденииТрудовыхКнижекПереданные
		|		ПО ТаблицаОтбора.Организация = ЗаявленияОВеденииТрудовыхКнижекПереданные.Организация
		|			И ТаблицаОтбора.ФизическоеЛицо = ЗаявленияОВеденииТрудовыхКнижекПереданные.ФизическоеЛицо
		|			И ТаблицаОтбора.Заявление = ЗаявленияОВеденииТрудовыхКнижекПереданные.Заявление
		|			И (ЗаявленияОВеденииТрудовыхКнижекПереданные.Отозвано)
		|ГДЕ
		|	НЕ ЗаявленияОВеденииТрудовыхКнижекПереданные.Регистратор ЕСТЬ NULL
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'По сотруднику %1 заявление %2 передано в ПФР документом %3.';
				|en = 'For employee %1 the application %2 has already been handed over to PF in document %3.'"),
			Выборка.ФизическоеЛицо,
			Выборка.Заявление,
			Выборка.Регистратор);
		
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка,
				"Объект.Сотрудники[" + (Выборка.НомерСтроки - 1) + "].Заявление", , Отказ);
			
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли