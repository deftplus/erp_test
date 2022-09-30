#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет строку с результатом согласования рецензента в тч РезультатыСогласования.
//
// Параметры:
//	ТочкаМаршрута         - ТочкаМаршрутаБизнесПроцессаСсылка.СогласованиеЦенНоменклатуры - 
//	Рецензент             - СправочникСсылка.Пользователи - исполнитель задачи по согласованию
//	РезультатСогласования - ПеречислениеСсылка.РезультатыСогласования - 
//	Комментарий           - Строка - комментарий рецензента
//	ДатаИсполнения        - Дата - дата выполнения задачи по согласованию рецензентом.
//
Процедура ДобавитьРезультатСогласования(Знач ТочкаМаршрута,
	                                    Знач Рецензент,
	                                    Знач РезультатСогласования,
	                                    Знач Комментарий,
	                                    Знач ДатаИсполнения) Экспорт
	
	НоваяСтрока                       = РезультатыСогласования.Добавить();
	НоваяСтрока.ТочкаМаршрута         = ТочкаМаршрута;
	НоваяСтрока.Рецензент             = Рецензент;
	НоваяСтрока.РезультатСогласования = РезультатСогласования;
	НоваяСтрока.Комментарий           = Комментарий;
	НоваяСтрока.ДатаСогласования      = ДатаИсполнения;
	
	Если БизнесПроцессы.СогласованиеЦенНоменклатуры.ИспользуетсяВерсионированиеПредмета(Предмет.Метаданные().ПолноеИмя()) Тогда
		НоваяСтрока.НомерВерсии = БизнесПроцессы.СогласованиеЦенНоменклатуры.НомерПоследнейВерсииПредмета(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом
// Параметры:
//    Таблица - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	// Логика ограничения:
	// Чтение:    Без ограничения.
	// Изменение: Не используется.
	
	// Чтение, Изменение: набор №0.
	Строка = Таблица.Добавить();
	Строка.ЗначениеДоступа = Перечисления.ДополнительныеЗначенияДоступа.ДоступРазрешен;
	
КонецПроцедуры 

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Дата согласования должна быть не меньше даты документа
	Если ЗначениеЗаполнено(ДатаСогласования) И ДатаСогласования < НачалоДня(Дата) Тогда
		
		ТекстОшибки = НСтр("ru = 'Дата согласования должна быть не меньше даты бизнес-процесса %Дата%';
							|en = 'Approval date must not be earlier than the business process date %Дата%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Дата%", Формат(Дата,"ДЛФ=DD"));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ДатаСогласования",
			,
			Отказ);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Предмет) Тогда
	
		Запрос = Новый Запрос("
			|ВЫБРАТЬ
			|	ВЫБОР
			|		КОГДА
			|			ДокументПредмет.Проведен И ДокументПредмет.Согласован
			|		ТОГДА
			|			ИСТИНА
			|		ИНАЧЕ
			|			ЛОЖЬ
			|	КОНЕЦ КАК ЕстьОшибкиСогласован,
			|	ДокументПредмет.ПометкаУдаления КАК ПометкаУдаления,
			|	ДокументПредмет.Ссылка КАК Предмет
			|ИЗ
			|	Документ.УстановкаЦенНоменклатуры КАК ДокументПредмет
			|ГДЕ
			|	ДокументПредмет.Ссылка = &Предмет
			|");
			
		Запрос.УстановитьПараметр("Предмет", Предмет);
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		// Документ уже согласован или помечен на удаление - нет смысла начинать согласование.
		Если Выборка.ЕстьОшибкиСогласован Тогда
			
			ТекстОшибки = НСтр("ru = 'Документ %Предмет% не нуждается в согласовании';
								|en = 'Document %Предмет% does not require approval'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%", Выборка.Предмет);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"Предмет",
				,
				Отказ);
			
		ИначеЕсли Выборка.ПометкаУдаления Тогда
			
			ТекстОшибки = НСтр("ru = 'Документ %Предмет% не может быть согласован, т.к. помечен на удаление';
								|en = 'Document %Предмет% cannot be approved because it is marked for deletion'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%", Выборка.Предмет);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"Предмет",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.УстановкаЦенНоменклатуры") Тогда
		ЗаполнитьБизнесПроцессНаОснованииУстановкиЦенНоменклатуры(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьБизнесПроцесс();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДатаНачала            = Дата(1,1,1);
	ДатаОкончания         = Дата(1,1,1);
	РезультатСогласования = Перечисления.РезультатыСогласования.ПустаяСсылка();
	
	РезультатыСогласования.Очистить();
	
	ИнициализироватьБизнесПроцесс();
	
КонецПроцедуры

Процедура СтартПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаНачала = ТекущаяДатаСеанса();
	
	Если НЕ ОбщегоНазначенияУТ.ПроверитьСогласующегоБизнесПроцесс(Справочники.РолиИсполнителей.СогласующийУстановкиЦенНоменклатуры) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан %РольСогласующего%';
								|en = '%РольСогласующего% is not specified'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%РольСогласующего%", Справочники.РолиИсполнителей.СогласующийУстановкиЦенНоменклатуры);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаЗавершения = ТекущаяДатаСеанса();
	
КонецПроцедуры

Процедура ОбработкаРезультатовСогласованияОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПредметОбъект = Предмет.ПолучитьОбъект();
	
	// Документ уже согласован - ничего делать не требуется
	Если Не ПредметОбъект.ПометкаУдаления И Не (ПредметОбъект.Проведен И ПредметОбъект.Согласован) Тогда
		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Предмет);
		Исключение
			
			ТекстОшибки = НСтр("ru = 'В ходе обработки результатов согласования не удалось заблокировать %Предмет%. %ОписаниеОшибки%';
								|en = 'Cannot lock %Предмет% while processing approval results. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%",        Предмет);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ВызватьИсключение ТекстОшибки;
			
		КонецПопытки;
		
		ПредметОбъект.Согласован = Истина;
		ПредметОбъект.Статус = Перечисления.СтатусыУстановокЦенНоменклатуры.Согласован;
		
		Попытка
		
			ПредметОбъект.Записать(РежимЗаписиДокумента.Проведение);
			РазблокироватьДанныеДляРедактирования(Предмет);
			
		Исключение
			
			РазблокироватьДанныеДляРедактирования(Предмет);
			
			ТекстОшибки = НСтр("ru = 'Не удалось записать %Предмет%. %ОписаниеОшибки%';
								|en = 'Cannot save %Предмет%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%",        Предмет);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ВызватьИсключение ТекстОшибки;
			
		КонецПопытки
		
	КонецЕсли;
		
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ДокументСогласованПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = (РезультатСогласования = Перечисления.РезультатыСогласования.Согласовано);
	
КонецПроцедуры

Процедура ОзнакомитьсяСРезультатамиПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = СоздатьЗадачу(ТочкаМаршрутаБизнесПроцесса);
	Задача.Исполнитель = Автор;
	ФормируемыеЗадачи.Добавить(Задача);
	
КонецПроцедуры

Процедура СогласоватьУстановкуЦенНоменклатурыПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = СоздатьЗадачу(ТочкаМаршрутаБизнесПроцесса);
	ФормируемыеЗадачи.Добавить(Задача);
	
КонецПроцедуры

Процедура ОзнакомитьсяСРезультатамиОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	Результат = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Функция СоздатьЗадачу(Знач ТочкаМаршрутаБизнесПроцесса)
	
	Задача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
	
	Задача.Дата                          = ТекущаяДатаСеанса();
	Задача.Автор                         = Автор;
	Задача.Наименование                  = ТочкаМаршрутаБизнесПроцесса.НаименованиеЗадачи;
	Задача.Описание                      = Наименование;
	Задача.Предмет                       = Предмет;
	Задача.Важность                      = Важность;
	Задача.РольИсполнителя               = ТочкаМаршрутаБизнесПроцесса.РольИсполнителя;
	Задача.ОсновнойОбъектАдресации       = ТочкаМаршрутаБизнесПроцесса.ОсновнойОбъектАдресации;
	Задача.ДополнительныйОбъектАдресации = ТочкаМаршрутаБизнесПроцесса.ДополнительныйОбъектАдресации;
	Задача.БизнесПроцесс                 = Ссылка;
	Задача.СрокИсполнения                = ДатаСогласования;
	Задача.ТочкаМаршрута                 = ТочкаМаршрутаБизнесПроцесса;
	
	Возврат Задача;
	
КонецФункции

Процедура ЗаполнитьБизнесПроцессНаОснованииУстановкиЦенНоменклатуры(ДокументОснование)
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	УстановкаЦенНоменклатуры.Ссылка КАК Предмет,
		|	ВЫБОР
		|		КОГДА
		|			УстановкаЦенНоменклатуры.Проведен И УстановкаЦенНоменклатуры.Согласован
		|		ТОГДА
		|			ИСТИНА
		|		ИНАЧЕ
		|			ЛОЖЬ
		|	КОНЕЦ КАК ЕстьОшибкиСогласован,
		|	УстановкаЦенНоменклатуры.ПометкаУдаления КАК ПометкаУдаления
		|ИЗ
		|	Документ.УстановкаЦенНоменклатуры КАК УстановкаЦенНоменклатуры
		|ГДЕ
		|	УстановкаЦенНоменклатуры.Ссылка = &ДокументОснование
		|");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
		// Документ уже согласован или помечен на удаление - нет смысла начинать согласование.
		Если Выборка.ЕстьОшибкиСогласован Тогда
			
			ТекстОшибки = НСтр("ru = 'Документ %Предмет% не нуждается в согласовании';
								|en = 'Document %Предмет% does not require approval'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%", Выборка.Предмет);
			
			ВызватьИсключение ТекстОшибки;
			
		ИначеЕсли Выборка.ПометкаУдаления Тогда
			
			ТекстОшибки = НСтр("ru = 'Документ %Предмет% не может быть согласован, т.к. помечен на удаление';
								|en = 'Document %Предмет% cannot be approved because it is marked for deletion'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%", Выборка.Предмет);
			
			ВызватьИсключение ТекстОшибки;
			
		КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Предмет") Тогда
		
		ТипПредмета = ТипЗнч(ДанныеЗаполнения.Предмет);
		
		Если ТипПредмета = Тип("ДокументСсылка.УстановкаЦенНоменклатуры") Тогда
			ЗаполнитьБизнесПроцессНаОснованииУстановкиЦенНоменклатуры(ДанныеЗаполнения.Предмет);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьБизнесПроцесс()
	
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
