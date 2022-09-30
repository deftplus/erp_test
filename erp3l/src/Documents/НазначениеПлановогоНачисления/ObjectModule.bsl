#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИСотрудникам(ЭтотОбъект, Таблица, "Организация", "Сотрудники.Сотрудник");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ЗарплатаКадрыРасширенный.ИнициализироватьОтложеннуюРегистрациюВторичныхДанныхПоДвижениямДокумента(Движения);
	
	ДанныеДляПроведения = ПолучитьДанныеДляПроведения();
	
	ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(Движения, ДанныеДляПроведения.СотрудникиДаты, Ссылка);
	
	СтруктураПлановыхНачислений = Новый Структура;
	СтруктураПлановыхНачислений.Вставить("ДанныеОПлановыхНачислениях", ДанныеДляПроведения.ПлановыеНачисления);
	СтруктураПлановыхНачислений.Вставить("ЗначенияПоказателей", ДанныеДляПроведения.ЗначенияПоказателей);
	
	РасчетЗарплаты.СформироватьДвиженияПлановыхНачислений(ЭтотОбъект, Движения, СтруктураПлановыхНачислений); 
	
	ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетПлановыхНачислений(Движения, ДанныеДляПроведения.ОтражениеВБухучете);
	
	УчетСреднегоЗаработка.ЗарегистрироватьДанныеКоэффициентовИндексации(Движения, ДанныеДляПроведения.КоэффициентыИндексации);
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба.РасчетДенежногоСодержания") Тогда		
		Модуль = ОбщегоНазначения.ОбщийМодуль("РасчетДенежногоСодержания");
		Модуль.ЗарегистрироватьКоэффициентыИндексацииДенежногоСодержания(Движения, ДанныеДляПроведения.КоэффициентыИндексацииДенежногоСодержания);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаНазначения, "Объект.ДатаНазначения", Отказ, НСтр("ru = 'Дата назначения';
																										|en = 'Assignment date'"), , , Ложь);
	
	Если ЗначениеЗаполнено(ДатаОкончания)
		И ДатаОкончания < ДатаНазначения Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Дата окончания должна быть больше даты изменения';
				|en = 'End date must be greater than the change date'"),
			Ссылка,
			"ДатаОкончания",
			"Объект",
			Отказ)
		
	КонецЕсли;
	
	ИндексСтроки = 0;
	Для каждого СтрокаСотрудника Из Сотрудники Цикл
		
		Если ЗначениеЗаполнено(СтрокаСотрудника.ДатаОкончания)
		И СтрокаСотрудника.ДатаОкончания < СтрокаСотрудника.ДатаНазначения Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Дата окончания должна быть больше даты изменения';
					|en = 'End date must be greater than the change date'"),
				Ссылка,
				"Сотрудники[" + ИндексСтроки + "].ДатаОкончания",
				"Объект",
				Отказ)
			
		КонецЕсли;
		
		ИндексСтроки = ИндексСтроки + 1;
		
	КонецЦикла;
	
	Документы.ИзменениеПлановыхНачислений.ПроверитьПересечениеПериодовДействия(
		ЭтотОбъект, "Сотрудники", "Сотрудник", "ДатаНазначения", "ДатаОкончания", Отказ);
	
	УстановитьПривилегированныйРежим(Истина);
	
	КадровыйУчет.ПроверитьРаботающихСотрудниковТабличнойЧастиДокумента(ЭтотОбъект, "Сотрудники", "ДатаНазначения", "ДатаНазначения", Отказ);
	
	Если ЗначениеЗаполнено(Начисление) Тогда
		
		ИнформацияОВидеРасчета = ЗарплатаКадрыРасширенныйПовтИсп.ПолучитьИнформациюОВидеРасчета(Начисление);
		Если Не ИнформацияОВидеРасчета.ПоддерживаетНесколькоПлановыхНачислений Тогда
			
			СотрудникиПериоды = Сотрудники.Выгрузить(, "НомерСтроки,Сотрудник,ДатаНазначения");
			СотрудникиПериоды.Колонки.Добавить("Начисление", Новый ОписаниеТипов("ПланВидовРасчетаСсылка.Начисления"));
			
			СотрудникиПериоды.ЗаполнитьЗначения(Начисление, "Начисление");
			
			Запрос = Новый Запрос;
			Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
			
			Запрос.УстановитьПараметр("СотрудникиПериоды", СотрудникиПериоды);
			
			Запрос.Текст =
				"ВЫБРАТЬ
				|	СотрудникиПериоды.НомерСтроки,
				|	СотрудникиПериоды.ДатаНазначения КАК Период,
				|	СотрудникиПериоды.Сотрудник,
				|	СотрудникиПериоды.Начисление
				|ПОМЕСТИТЬ ВТСотрудникиПериоды
				|ИЗ
				|	&СотрудникиПериоды КАК СотрудникиПериоды";
			
			Запрос.Выполнить();
			
			ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистраСрез();
			ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
				ПараметрыПостроения.Отборы, "Регистратор", "<>", Ссылка);
			
			ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
				"ПлановыеНачисления",
				Запрос.МенеджерВременныхТаблиц,
				Истина,
				ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
					"ВТСотрудникиПериоды", "Сотрудник,Начисление"),
				ПараметрыПостроения);
			
			Запрос.Текст =
				"ВЫБРАТЬ
				|	СотрудникиПериоды.НомерСтроки КАК НомерСтроки,
				|	ПРЕДСТАВЛЕНИЕ(СотрудникиПериоды.Сотрудник) КАК СотрудникПредставление,
				|	ПРЕДСТАВЛЕНИЕ(ПлановыеНачисления.Начисление) КАК НачислениеПредставление,
				|	ПРЕДСТАВЛЕНИЕ(ПлановыеНачисления.Регистратор) КАК РегистраторПредставление
				|ИЗ
				|	ВТСотрудникиПериоды КАК СотрудникиПериоды
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПлановыеНачисленияСрезПоследних КАК ПлановыеНачисления
				|		ПО СотрудникиПериоды.Период = ПлановыеНачисления.Период
				|			И СотрудникиПериоды.Сотрудник = ПлановыеНачисления.Сотрудник
				|			И СотрудникиПериоды.Начисление = ПлановыеНачисления.Начисление
				|			И (ПлановыеНачисления.Используется)
				|
				|УПОРЯДОЧИТЬ ПО
				|	НомерСтроки";
			
			РезультатЗапроса = Запрос.Выполнить();
			Если Не РезультатЗапроса.Пустой() Тогда
				
				Выборка = РезультатЗапроса.Выбрать();
				Пока Выборка.Следующий() Цикл
					
					ТекстСообщения = НСтр("ru = 'Сотруднику %1 ранее назначено начисление ""%2"" документом %3';
											|en = 'The ""%1"" employee was assigned an accrual of ""%2"" by the ""%3"" document'");
					ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.СотрудникПредставление, Выборка.НачислениеПредставление, Выборка.РегистраторПредставление);
					
					ОбщегоНазначения.СообщитьПользователю(
						ТекстСообщения,
						Ссылка,
						"Сотрудники[" + Формат(Выборка.НомерСтроки - 1, "ЧГ=") + "].Сотрудник",
						"Объект",
						Отказ);
					
				КонецЦикла;
				
			КонецЕсли;
			
			
		КонецЕсли;
		
		
		Если ИнформацияОВидеРасчета.Рассчитывается Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст =
				"ВЫБРАТЬ
				|	НачисленияПоказатели.Показатель КАК Показатель,
				|	НачисленияПоказатели.Показатель.Идентификатор КАК Идентификатор,
				|	НачисленияПоказатели.Показатель.ДопускаетсяНулевоеЗначение КАК ДопускаетсяНулевоеЗначение
				|ИЗ
				|	ПланВидовРасчета.Начисления.Показатели КАК НачисленияПоказатели
				|ГДЕ
				|	НачисленияПоказатели.ЗапрашиватьПриВводе
				|	И НЕ НачисленияПоказатели.Показатель.ДопускаетсяНулевоеЗначение
				|	И НачисленияПоказатели.Ссылка = &Начисление";
			
			Запрос.УстановитьПараметр("Начисление", Начисление);
			
			ДанныеПоказателей = Запрос.Выполнить().Выгрузить();
			Для Каждого СтрокаСотрудники Из Сотрудники Цикл
				
				СтруктураПоиска = Новый Структура("ИдентификаторСтрокиСотрудника,Показатель");
				СтруктураПоиска.ИдентификаторСтрокиСотрудника = СтрокаСотрудники.ИдентификаторСтрокиСотрудника;
				Для каждого СтрокаДанныхПоказателей Из ДанныеПоказателей Цикл
					
					ЗначениеЗаполнено = Ложь;
					
					СтруктураПоиска.Показатель = СтрокаДанныхПоказателей.Показатель;
					СтрокиПоказателей = ПоказателиСотрудников.НайтиСтроки(СтруктураПоиска);
					Для каждого СтрокаПоказателей Из СтрокиПоказателей Цикл
						
						Если СтрокаПоказателей.Значение > 0 Тогда
							ЗначениеЗаполнено = Истина;
						КонецЕсли;
						
					КонецЦикла;
					
					Если Не ЗначениеЗаполнено Тогда
						
						ОбщегоНазначения.СообщитьПользователю(
							НСтр("ru = 'Значение не заполнено';
								|en = 'Value is not filled in'"),
							Ссылка,
							"Сотрудники[" + Формат(СтрокаСотрудники.НомерСтроки - 1, "ЧГ=") + "]." + СтрокаДанныхПоказателей.Идентификатор,
							"Объект",
							Отказ);
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЦикла;
			
		Иначе
			
			Для Каждого СтрокаСотрудники Из Сотрудники Цикл
				
				Если СтрокаСотрудники.Размер = 0 Тогда
					
					ОбщегоНазначения.СообщитьПользователю(
						НСтр("ru = 'Значение не заполнено';
							|en = 'Value is not filled in'"),
						Ссылка,
						"Сотрудники[" + Формат(СтрокаСотрудники.НомерСтроки - 1, "ЧГ=") + "].а" + СтрЗаменить(Начисление.УникальныйИдентификатор(), "-", ""),
						"Объект",
						Отказ);
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ТаблицаНачислений = РасчетЗарплатыРасширенный.ПустаяТаблицаПлановыхНачислений();
	Для Каждого Строка Из Сотрудники Цикл 
		
		НоваяСтрока 			= ТаблицаНачислений.Добавить();
		НоваяСтрока.Сотрудник 	= Строка.Сотрудник;
		НоваяСтрока.Период 		= ДатаНазначения;
		НоваяСтрока.Начисление 	= Начисление;
		НоваяСтрока.Действие 	= Перечисления.ДействияСНачислениямиИУдержаниями.Утвердить;
		НоваяСтрока.НомерСтроки = Строка.НомерСтроки;
		
	КонецЦикла;
	
	РасчетЗарплатыРасширенный.ПроверитьМножественностьОплатыВремени(ТаблицаНачислений, Ссылка, Отказ);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает данные для формирования движений.
// Возвращает Структуру с полями.
//		ПлановыеНачисления - данные, необходимые для формирования истории плановых начислений.
//		(см. РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений)
//		ЗначенияПоказателей (см. там же).
//
Функция ПолучитьДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДатаОкончания", ?(ЗначениеЗаполнено(ДатаОкончания), КонецДня(ДатаОкончания) + 1, ДатаОкончания));
	
	// Подготовка данных для проведения.
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НазначениеПлановогоНачисленияСотрудники.ДатаНазначения КАК ДатаСобытия,
	|	ВЫБОР
	|		КОГДА НазначениеПлановогоНачисленияСотрудники.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(НазначениеПлановогоНачисленияСотрудники.ДатаОкончания, ДЕНЬ, 1)
	|	КОНЕЦ КАК ДействуетДо,
	|	НазначениеПлановогоНачисленияСотрудники.Сотрудник КАК Сотрудник,
	|	НазначениеПлановогоНачисленияСотрудники.Ссылка.Начисление КАК Начисление,
	|	ВЫБОР
	|		КОГДА НазначениеПлановогоНачисленияСотрудники.Ссылка.Начисление.ПоддерживаетНесколькоПлановыхНачислений
	|			ТОГДА НазначениеПлановогоНачисленияСотрудники.Ссылка
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ДокументОснование,
	|	ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Утвердить) КАК Действие,
	|	ИСТИНА КАК Используется,
	|	ЛОЖЬ КАК ИспользуетсяПоОкончании,
	|	НазначениеПлановогоНачисленияСотрудники.Размер КАК Размер,
	|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Сотрудники.ГоловнаяОрганизация КАК ГоловнаяОрганизация
	|ИЗ
	|	Документ.НазначениеПлановогоНачисления.Сотрудники КАК НазначениеПлановогоНачисленияСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
	|		ПО НазначениеПлановогоНачисленияСотрудники.Сотрудник = Сотрудники.Ссылка
	|ГДЕ
	|	НазначениеПлановогоНачисленияСотрудники.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НазначениеПлановогоНачисленияСотрудники.Ссылка.Организация КАК Организация,
	|	НазначениеПлановогоНачисленияСотрудники.Сотрудник КАК Сотрудник,
	|	НазначениеПлановогоНачисленияСотрудники.ДатаНазначения КАК ДатаСобытия,
	|	ВЫБОР
	|		КОГДА НазначениеПлановогоНачисленияСотрудники.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(НазначениеПлановогоНачисленияСотрудники.ДатаОкончания, ДЕНЬ, 1)
	|	КОНЕЦ КАК ДействуетДо,
	|	ВЫБОР
	|		КОГДА НазначениеПлановогоНачисленияСотрудники.Ссылка.Начисление.ПоддерживаетНесколькоПлановыхНачислений
	|			ТОГДА НазначениеПлановогоНачисленияСотрудники.Ссылка
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ДокументОснование,
	|	ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Утвердить) КАК Действие,
	|	ПоказателиСотрудников.Показатель КАК Показатель,
	|	ПоказателиСотрудников.Значение КАК Значение,
	|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо
	|ИЗ
	|	Документ.НазначениеПлановогоНачисления.Сотрудники КАК НазначениеПлановогоНачисленияСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.НазначениеПлановогоНачисления.ПоказателиСотрудников КАК ПоказателиСотрудников
	|		ПО НазначениеПлановогоНачисленияСотрудники.Ссылка = ПоказателиСотрудников.Ссылка
	|			И НазначениеПлановогоНачисленияСотрудники.ИдентификаторСтрокиСотрудника = ПоказателиСотрудников.ИдентификаторСтрокиСотрудника
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
	|		ПО НазначениеПлановогоНачисленияСотрудники.Сотрудник = Сотрудники.Ссылка
	|ГДЕ
	|	ПоказателиСотрудников.Ссылка = &Ссылка
	|	И ПоказателиСотрудников.Показатель <> ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НазначениеПлановогоНачисленияСотрудники.Сотрудник КАК Сотрудник,
	|	НазначениеПлановогоНачисленияСотрудники.ДатаНазначения КАК ДатаСобытия,
	|	ВЫБОР
	|		КОГДА НазначениеПлановогоНачисленияСотрудники.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(НазначениеПлановогоНачисленияСотрудники.ДатаОкончания, ДЕНЬ, 1)
	|	КОНЕЦ КАК ДействуетДо,
	|	НазначениеПлановогоНачисленияСотрудники.СовокупнаяТарифнаяСтавка КАК Значение,
	|	ВЫБОР
	|		КОГДА НазначениеПлановогоНачисленияСотрудники.СовокупнаяТарифнаяСтавка = 0
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыТарифныхСтавок.ПустаяСсылка)
	|		ИНАЧЕ НазначениеПлановогоНачисленияСотрудники.ВидТарифнойСтавки
	|	КОНЕЦ КАК ВидТарифнойСтавки,
	|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо
	|ИЗ
	|	Документ.НазначениеПлановогоНачисления.Сотрудники КАК НазначениеПлановогоНачисленияСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
	|		ПО НазначениеПлановогоНачисленияСотрудники.Сотрудник = Сотрудники.Ссылка
	|ГДЕ
	|	НазначениеПлановогоНачисленияСотрудники.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НазначениеПлановогоНачисленияСотрудники.ДатаНазначения КАК ДатаСобытия,
	|	НазначениеПлановогоНачисленияСотрудники.Сотрудник КАК Сотрудник
	|ИЗ
	|	Документ.НазначениеПлановогоНачисления.Сотрудники КАК НазначениеПлановогоНачисленияСотрудники
	|ГДЕ
	|	НазначениеПлановогоНачисленияСотрудники.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокумента.ДатаНазначения КАК Период,
	|	ДанныеДокумента.Сотрудник КАК Сотрудник,
	|	ДанныеДокумента.Ссылка.Организация КАК Организация,
	|	ДанныеДокумента.Ссылка.Начисление КАК Начисление,
	|	ДанныеДокумента.Ссылка.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
	|	ДанныеДокумента.Ссылка.СтатьяФинансирования КАК СтатьяФинансирования,
	|	ДанныеДокумента.Ссылка.СтатьяРасходов КАК СтатьяРасходов,
	|	ДанныеДокумента.Ссылка.ОтношениеКЕНВД КАК ОтношениеКЕНВД,
	|	ДанныеДокумента.ДатаОкончания КАК ДействуетДо,
	|	ИСТИНА КАК Используется,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Ссылка.Начисление.ПоддерживаетНесколькоПлановыхНачислений
	|			ТОГДА ДанныеДокумента.Ссылка
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ДокументОснование
	|ИЗ
	|	Документ.НазначениеПлановогоНачисления.Сотрудники КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И (ДанныеДокумента.Ссылка.СпособОтраженияЗарплатыВБухучете <> ЗНАЧЕНИЕ(Справочник.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка)
	|			ИЛИ ДанныеДокумента.Ссылка.СтатьяФинансирования <> ЗНАЧЕНИЕ(Справочник.СтатьиФинансированияЗарплата.ПустаяСсылка)
	|			ИЛИ ДанныеДокумента.Ссылка.СтатьяРасходов <> ЗНАЧЕНИЕ(Справочник.СтатьиРасходовЗарплата.ПустаяСсылка)
	|			ИЛИ ДанныеДокумента.Ссылка.ОтношениеКЕНВД <> ЗНАЧЕНИЕ(Перечисление.ОтношениеКЕНВДЗатратНаЗарплату.ПустаяСсылка))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокумента.ДатаНазначения КАК Период,
	|	ДанныеДокумента.Сотрудник КАК Сотрудник,
	|	ДанныеДокумента.КоэффициентИндексации КАК Коэффициент
	|ИЗ
	|	Документ.НазначениеПлановогоНачисления.Сотрудники КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.Ссылка.УчитыватьКакИндексациюЗаработка";
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ДанныеДляПроведения = Новый Структура; 
	
	// Первый набор данных для проведения - таблица для формирования плановых начислений.
	ПлановыеНачисления = РезультатыЗапроса[0].Выгрузить();
	ДанныеДляПроведения.Вставить("ПлановыеНачисления", ПлановыеНачисления);
	
	// Второй набор данных для проведения - таблица для формирования значений показателей.
	ЗначенияПоказателей = РезультатыЗапроса[1].Выгрузить();
	ДанныеДляПроведения.Вставить("ЗначенияПоказателей", ЗначенияПоказателей);
	
	// Третий набор данных для проведения - таблица для формирования значений совокупных тарифных ставок.
	ДанныеСовокупныхТарифныхСтавок = РезультатыЗапроса[2].Выгрузить();
	ДанныеДляПроведения.Вставить("ДанныеСовокупныхТарифныхСтавок", ДанныеСовокупныхТарифныхСтавок);
	
	// Четвертый набор данных для проведения - таблица для формирования времени регистрации документа.
	СотрудникиДаты = РезультатыЗапроса[3].Выгрузить();
	ДанныеДляПроведения.Вставить("СотрудникиДаты", СотрудникиДаты);
	
	// Набор данных для проведения - таблица для формирования отражения в бухучете.
	ОтражениеВБухучете = РезультатыЗапроса[4].Выгрузить();
	ДанныеДляПроведения.Вставить("ОтражениеВБухучете", ОтражениеВБухучете);
	
	// Набор данных для проведения - таблица для формирования коэффициентов индексации.
	КоэффициентыИндексации = РезультатыЗапроса[5].Выгрузить();
	ДанныеДляПроведения.Вставить("КоэффициентыИндексации", КоэффициентыИндексации);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба.РасчетДенежногоСодержания") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("РасчетДенежногоСодержания");
		КоэффициентыИндексацииДокумента = Модуль.ПолучитьТаблицуИндексацииДокумента(Ссылка, "ДатаНазначения", "Сотрудники");
		КоэффициентыИндексацииДенежногоСодержания = Модуль.ТаблицаКоэффициентовИндексацииДенежногоСодержанияСотрудников(КоэффициентыИндексацииДокумента);
		ДанныеДляПроведения.Вставить("КоэффициентыИндексацииДенежногоСодержания", КоэффициентыИндексацииДенежногоСодержания);
	КонецЕсли;

	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли