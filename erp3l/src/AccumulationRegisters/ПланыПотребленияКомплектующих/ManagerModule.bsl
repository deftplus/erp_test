#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Склад)
	|	И ЗначениеРазрешено(Сценарий)
	|	И ЗначениеРазрешено(ВидПлана)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.ПланыПотребленияКомплектующих.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.3.10";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("24aab2e0-70e4-4024-b86a-6faf17f4feab");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.ПланыПотребленияКомплектующих.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновляет движения документа ""Планы сборки (разборки)"" по регистру накопления ""Планы потребления комплектующих"":
	| - заполняет ресурс ""Количество"" в соответствии с признаками ""Замещен"" и ""Замещен к заказу""
	| - заполняет измерение ""Вид плана"".';
	|en = 'Updates records in the ""Assembly (disassembly) schedules"" for the ""Components consumption plan"" accumulation register:
	| - fills in the ""Quantity"" resource according to the ""Substituted"" and ""Substituted to order"" flags
	| - fills in the ""Plan profile"" dimension.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.ПланСборкиРазборки.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.ПланыПотребленияКомплектующих.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ПланСборкиРазборки.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

КонецПроцедуры

// Процедура регистрации данных для обработчика обновления ОбработатьДанныеДляПереходаНаВерсию.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.ПланСборкиРазборки";
	ПолноеИмяРегистра = "РегистрНакопления.ПланыСборкиРазборки";
	ИмяРегистра       = "ПланыСборкиРазборки";
	
	ТекстЗапроса = Документы.ПланСборкиРазборки.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
		ТекстЗапроса, ПолноеИмяРегистра, ПолноеИмяДокумента);
	
	Запрос = Новый Запрос;
	Запрос.Текст = Документы.ПланСборкиРазборки.ТекстЗапросаДанныеКОбработке();
	
	ЗапросПакет = Запрос.ВыполнитьПакет();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Регистраторы, ЗапросПакет[4].Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	ПолноеИмяРегистра = "РегистрНакопления.ПланыПотребленияКомплектующих";
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(
		Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.ПланСборкиРазборки";
	
	ПолноеИмяРегистра = "РегистрНакопления.ПланыПотребленияКомплектующих";
	МетаданныеРегистра = Метаданные.РегистрыНакопления.ПланыПотребленияКомплектующих;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ПланыПотребленияКомплектующих.Период КАК Период,
	|	ПланыПотребленияКомплектующих.Регистратор КАК Регистратор,
	|	ПланыПотребленияКомплектующих.НомерСтроки КАК НомерСтроки,
	|	ПланыПотребленияКомплектующих.Активность КАК Активность,
	|	ПланыПотребленияКомплектующих.Сценарий КАК Сценарий,
	|	ПланыПотребленияКомплектующих.Статус КАК Статус,
	|	ПланыПотребленияКомплектующих.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ПланыПотребленияКомплектующих.Номенклатура КАК Номенклатура,
	|	ПланыПотребленияКомплектующих.Характеристика КАК Характеристика,
	|	ПланыПотребленияКомплектующих.Склад КАК Склад,
	|	ПланыПотребленияКомплектующих.ПланСборкиРазборки КАК ПланСборкиРазборки,
	|	ПланыПотребленияКомплектующих.ДатаВыпуска КАК ДатаВыпуска,
	|	ВЫБОР ПланыПотребленияКомплектующих.Регистратор.Периодичность
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланыПотребленияКомплектующих.ДатаВыпуска, НЕДЕЛЯ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланыПотребленияКомплектующих.ДатаВыпуска, ДЕКАДА)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланыПотребленияКомплектующих.ДатаВыпуска, МЕСЯЦ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланыПотребленияКомплектующих.ДатаВыпуска, КВАРТАЛ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланыПотребленияКомплектующих.ДатаВыпуска, ПОЛУГОДИЕ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланыПотребленияКомплектующих.ДатаВыпуска, ГОД)
	|		ИНАЧЕ ПланыПотребленияКомплектующих.ДатаВыпуска
	|	КОНЕЦ КАК ПериодДатыВыпуска,
	|	ПланыПотребленияКомплектующих.Назначение КАК Назначение,
	|	ПланыПотребленияКомплектующих.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА ПланыПотребленияКомплектующих.КЗаказу <> 0
	|			ТОГДА ПланыПотребленияКомплектующих.КЗаказу
	|		КОГДА ПланыПотребленияКомплектующих.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Утвержден)
	|			ТОГДА ПланыПотребленияКомплектующих.Количество
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КЗаказу,
	|	ПланыПотребленияКомплектующих.ВариантКомплектации КАК ВариантКомплектации,
	|	ПланыПотребленияКомплектующих.Регистратор.ВидПлана КАК ВидПлана
	|ПОМЕСТИТЬ ПланыПотребленияКомплектующих
	|ИЗ
	|	РегистрНакопления.ПланыПотребленияКомплектующих КАК ПланыПотребленияКомплектующих
	|ГДЕ
	|	ПланыПотребленияКомплектующих.Регистратор = &Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещениеПланов.ЗамещенныйПериод КАК ЗамещенныйПериод
	|ПОМЕСТИТЬ ЗамещенныеПериоды
	|ИЗ
	|	РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов
	|ГДЕ
	|	ЗамещениеПланов.ЗамещенныйПлан = &Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПланыПотребленияКомплектующих.Период КАК Период,
	|	ПланыПотребленияКомплектующих.Регистратор КАК Регистратор,
	|	ПланыПотребленияКомплектующих.НомерСтроки КАК НомерСтроки,
	|	ПланыПотребленияКомплектующих.Активность КАК Активность,
	|	ПланыПотребленияКомплектующих.Сценарий КАК Сценарий,
	|	ПланыПотребленияКомплектующих.Статус КАК Статус,
	|	ПланыПотребленияКомплектующих.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ПланыПотребленияКомплектующих.Номенклатура КАК Номенклатура,
	|	ПланыПотребленияКомплектующих.Характеристика КАК Характеристика,
	|	ПланыПотребленияКомплектующих.Склад КАК Склад,
	|	ПланыПотребленияКомплектующих.ПланСборкиРазборки КАК ПланСборкиРазборки,
	|	ПланыПотребленияКомплектующих.ДатаВыпуска КАК ДатаВыпуска,
	|	ПланыПотребленияКомплектующих.ПериодДатыВыпуска КАК ПериодДатыВыпуска,
	|	ПланыПотребленияКомплектующих.Назначение КАК Назначение,
	|	ПланыПотребленияКомплектующих.Количество КАК Количество,
	|	ПланыПотребленияКомплектующих.КЗаказу КАК КЗаказу,
	|	ПланыПотребленияКомплектующих.ВариантКомплектации КАК ВариантКомплектации,
	|	ПланыПотребленияКомплектующих.ВидПлана КАК ВидПлана
	|ИЗ
	|	ПланыПотребленияКомплектующих КАК ПланыПотребленияКомплектующих
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЗамещенныеПериоды КАК ЗамещенныеПериоды
	|		ПО ПланыПотребленияКомплектующих.ПериодДатыВыпуска = ЗамещенныеПериоды.ЗамещенныйПериод
	|ГДЕ
	|	ЗамещенныеПериоды.ЗамещенныйПериод ЕСТЬ NULL
	|	И ПланыПотребленияКомплектующих.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Отменен)";
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьРегистраторыРегистраДляОбработки(Параметры.Очередь, Неопределено, ПолноеИмяРегистра);
	Пока Выборка.Следующий() Цикл
		
		Регистратор = Выборка.Регистратор;
		
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяДокумента);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗамещениеПланов");
			ЭлементБлокировки.УстановитьЗначение("ЗамещенныйПлан", Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			Запрос = Новый Запрос(ТекстЗапроса);
			Запрос.УстановитьПараметр("Регистратор", Регистратор);
			
			Набор = РегистрыНакопления.ПланыПотребленияКомплектующих.СоздатьНаборЗаписей();
			Набор.Отбор.Регистратор.Установить(Регистратор);
			
			Результат = Запрос.Выполнить().Выгрузить();
			Набор.Загрузить(Результат);
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать документ: %Регистратор% по причине: %Причина%';
									|en = 'Cannot process document: %Регистратор%. Reason: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Регистратор%", Регистратор);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
				Регистратор.Метаданные(), ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
