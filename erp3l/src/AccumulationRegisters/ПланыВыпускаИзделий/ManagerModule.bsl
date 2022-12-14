#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ПодразделениеДиспетчер)
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
	Обработчик.Процедура = "РегистрыНакопления.ПланыВыпускаИзделий.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.3.10";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("22a55d4c-12b1-4a05-a3b7-e58aecfca81f");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.ПланыВыпускаИзделий.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Изменяет регистратор движений у записей, принадлежащих планам с расчетом потребностей в материалах (видах РЦ, трудозатратах). Вместо документа ""План производства"" устанавливается ""Регистратор плана производства"".
	|Изменяет значение в измерении ""Тип выпуска"" - вместо ""(не использовать) Полуфабрикат"" устанавливается ""Основной"".
	|Заполняет измерение ""Вид плана""
	|Отменяет движения в статусе ""Отменен""';
	|en = 'Changes the movements recorder in records belonging to the plans with calculation of material demand (Work center types, labor costs). ""Production plan recorder"" is set instead of the ""Production plan"" document.
	|Changes the value in the ""Release type"" dimension - instead ""(do not use) Semi-Finished Product"", the ""Main"" is set.
	|Fills in the ""Plan profile"" dimension
	|Cancels movements in the ""Canceled"" status'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.РегистраторПланаПроизводства.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.ПланыВыпускаИзделий.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.ПланыВыпускаИзделий.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ПланПроизводства.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПланыВыпускаИзделий.Регистратор КАК Ссылка
		|ИЗ
		|	РегистрНакопления.ПланыВыпускаИзделий КАК ПланыВыпускаИзделий
		|ГДЕ
		|	(ПланыВыпускаИзделий.Регистратор ССЫЛКА Документ.ПланПроизводства
		|	И ПланыВыпускаИзделий.Сценарий.ИспользоватьДляПланированияМатериалов)
		|	ИЛИ ПланыВыпускаИзделий.ВидПлана = ЗНАЧЕНИЕ(Справочник.ВидыПланов.ПустаяСсылка)
		|	ИЛИ ПланыВыпускаИзделий.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Отменен)
		|	ИЛИ (ПланыВыпускаИзделий.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Утвержден)
		|	И ПланыВыпускаИзделий.Количество <> 0
		|	И ПланыВыпускаИзделий.КЗаказу = 0)");
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрНакопления.ПланыВыпускаИзделий";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(
		Параметры,
		Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"),
		ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	ПолноеИмяРегистра = "РегистрНакопления.ПланыВыпускаИзделий";
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьРегистраторыРегистраДляОбработки(
		Параметры.Очередь,
		,
		ПолноеИмяРегистра);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПланыВыпускаИзделий.Период КАК Период,
		|	ПланыВыпускаИзделий.НомерСтроки КАК НомерСтроки,
		|	ПланыВыпускаИзделий.Активность КАК Активность,
		|	ПланыВыпускаИзделий.Сценарий КАК Сценарий,
		|	ПланыВыпускаИзделий.Статус КАК Статус,
		|	ПланыВыпускаИзделий.Номенклатура КАК Номенклатура,
		|	ПланыВыпускаИзделий.Характеристика КАК Характеристика,
		|	ПланыВыпускаИзделий.Назначение КАК Назначение,
		|	ПланыВыпускаИзделий.ПодразделениеДиспетчер КАК ПодразделениеДиспетчер,
		|	ПланыВыпускаИзделий.ПодразделениеИсполнитель КАК ПодразделениеИсполнитель,
		|	ПланыВыпускаИзделий.ПланПроизводства КАК ПланПроизводства,
		|	ПланыВыпускаИзделий.Спецификация КАК Спецификация,
		|	ВЫБОР
		|		КОГДА ПланыВыпускаИзделий.ТипВыпуска = ЗНАЧЕНИЕ(Перечисление.ТипыВыпусковПлановПроизводства.УдалитьПолуфабрикат)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыВыпусковПлановПроизводства.Основной)
		|		ИНАЧЕ ПланыВыпускаИзделий.ТипВыпуска
		|	КОНЕЦ КАК ТипВыпуска,
		|	ПланыВыпускаИзделий.ДатаПроизводства КАК ДатаПроизводства,
		|	ПланыВыпускаИзделий.СпецификацияПродукции КАК СпецификацияПродукции,
		|	ПланыВыпускаИзделий.НазначениеПродукции КАК НазначениеПродукции,
		|	ПланыВыпускаИзделий.НоменклатураПродукции КАК НоменклатураПродукции,
		|	ПланыВыпускаИзделий.ХарактеристикаПродукции КАК ХарактеристикаПродукции,
		|	ПланыВыпускаИзделий.РазделительРасчета КАК РазделительРасчета,
		|	ПланыВыпускаИзделий.Количество КАК Количество,
		|	ВЫБОР
		|		КОГДА ПланыВыпускаИзделий.КЗаказу <> 0
		|			ТОГДА ПланыВыпускаИзделий.КЗаказу
		|		КОГДА ПланыВыпускаИзделий.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Утвержден)
		|			ТОГДА ПланыВыпускаИзделий.Количество
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК КЗаказу,
		|	ПланыВыпускаИзделий.КоличествоНаЕдиницуПродукции КАК КоличествоНаЕдиницуПродукции,
		|	ПланПроизводстваДокумент.ВидПлана КАК ВидПлана
		|ИЗ
		|	РегистрНакопления.ПланыВыпускаИзделий КАК ПланыВыпускаИзделий
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПланПроизводства КАК ПланПроизводстваДокумент
		|		ПО ПланыВыпускаИзделий.ПланПроизводства = ПланПроизводстваДокумент.Ссылка
		|ГДЕ
		|	ПланыВыпускаИзделий.Регистратор = &Регистратор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	РегистраторПланаПроизводства.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.РегистраторПланаПроизводства КАК РегистраторПланаПроизводства
		|ГДЕ
		|	РегистраторПланаПроизводства.ПланПроизводства = &Регистратор
		|	И РегистраторПланаПроизводства.Проведен
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ДокументПланПроизводства.Статус КАК Статус
		|ИЗ
		|	Документ.ПланПроизводства КАК ДокументПланПроизводства
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РегистраторПланаПроизводства КАК РегистраторПланаПроизводства
		|		ПО РегистраторПланаПроизводства.ПланПроизводства = ДокументПланПроизводства.Ссылка
		|ГДЕ
		|	(ДокументПланПроизводства.Ссылка = &Регистратор
		|			ИЛИ РегистраторПланаПроизводства.Ссылка = &Регистратор)");
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Выборка.Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			ЭлементБлокировки = Блокировка.Добавить("Документ.РегистраторПланаПроизводства");
			Если ТипЗнч(Выборка.Регистратор) = Тип("ДокументСсылка.ПланПроизводства") Тогда
				ЭлементБлокировки.УстановитьЗначение("ПланПроизводства", Выборка.Регистратор);
			Иначе
				ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Регистратор);
			КонецЕсли;
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			
			Блокировка.Заблокировать();
			
			Запрос.УстановитьПараметр("Регистратор", Выборка.Регистратор);
			МассивРезультатов = Запрос.ВыполнитьПакет();
			
			ВыборкаСтатус = МассивРезультатов[2].Выбрать();
			
			Если ВыборкаСтатус.Следующий() 
				И ВыборкаСтатус.Статус = Перечисления.СтатусыПланов.Отменен Тогда
				
				НаборЗаписейСтарый = РегистрыНакопления.ПланыВыпускаИзделий.СоздатьНаборЗаписей();
				НаборЗаписейСтарый.Отбор.Регистратор.Установить(Выборка.Регистратор);
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписейСтарый);
				
			ИначеЕсли Не МассивРезультатов[0].Пустой()
				И Не МассивРезультатов[1].Пустой() Тогда
				
				НаборЗаписейНовый = РегистрыНакопления.ПланыВыпускаИзделий.СоздатьНаборЗаписей();
				НаборЗаписейНовый.Отбор.Регистратор.Установить(МассивРезультатов[1].Выгрузить()[0].Ссылка);
				НаборЗаписейНовый.Загрузить(МассивРезультатов[0].Выгрузить());
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписейНовый);
				
				НаборЗаписейСтарый = РегистрыНакопления.ПланыВыпускаИзделий.СоздатьНаборЗаписей();
				НаборЗаписейСтарый.Отбор.Регистратор.Установить(Выборка.Регистратор);
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписейСтарый);
				
			ИначеЕсли Не МассивРезультатов[0].Пустой() Тогда
				
				НаборЗаписейНовый = РегистрыНакопления.ПланыВыпускаИзделий.СоздатьНаборЗаписей();
				НаборЗаписейНовый.Отбор.Регистратор.Установить(Выборка.Регистратор);
				НаборЗаписейНовый.Загрузить(МассивРезультатов[0].Выгрузить());
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписейНовый);
				
			Иначе
				
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Регистратор, ДополнительныеПараметры);
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Выборка.Регистратор);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли	
