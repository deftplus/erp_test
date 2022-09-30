#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ТаблицаЗначений") Тогда
		
		ЗаполнитьПоТаблице(ДанныеЗаполнения);
		
	ИначеЕсли ОбщегоНазначения.ВидОбъектаПоТипу(ТипЗнч(ДанныеЗаполнения)) = "Документ" Тогда
		
		ОбщегоНазначения.МенеджерОбъектаПоСсылке(ДанныеЗаполнения).ЗаполнитьПоОснованию(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	НастройкиПолей = Документы.СправкаОПодтверждающихДокументах.НастройкиПолейФормы();
	
	ДополнительныеРеквизиты = Новый Структура;
	ДополнительныеРеквизиты.Вставить("ДокументОперацииЗаполнен", Истина);
	
	СвойстваЭлементов = ДенежныеСредстваКлиентСервер.СвойстваЭлементовФормы(ЭтотОбъект, НастройкиПолей,,, ДополнительныеРеквизиты);
	ДенежныеСредстваСервер.ОтключитьПроверкуЗаполненияРеквизитовОбъекта(СвойстваЭлементов, НепроверяемыеРеквизиты);
	ЭтотОбъект.ДополнительныеСвойства.Вставить("СвойстваЭлементов", СвойстваЭлементов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	ПодтверждающиеДокументыБезРазбиения = Ложь;
	Если ДополнительныеСвойства.Свойство("ПодтверждающиеДокументыБезРазбиения")
		И ДополнительныеСвойства.ПодтверждающиеДокументыБезРазбиения Тогда
		ПодтверждающиеДокументыБезРазбиения = Истина;
	КонецЕсли;
	
	Если ПодтверждающиеДокументыБезРазбиения Тогда
		ДенежныеСредстваСервер.ПроверитьЗаполнениеРасшифровкиБезРазбиения(
			ЭтотОбъект, ПроверяемыеРеквизиты, "ПодтверждающиеДокументы", "ПодтверждающиеДокументыБезРазбиения", Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(ДатаСправки) Тогда
		ДатаСправки = Дата;
	КонецЕсли;
	
	Если ЭтотОбъект.ДополнительныеСвойства.Свойство("СвойстваЭлементов") Тогда
		ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизитыОбъекта(ЭтотОбъект, ЭтотОбъект.ДополнительныеСвойства.СвойстваЭлементов);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Корректировка = Ложь;
	КорректируемаяСправка = Неопределено;
	НомерКорректировки = 0;
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	#Область УХ_Встраивание
	// Регистр СведенияВалютногоКонтроляУчетныхДокументов
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СведенияВалютногоКонтроляУчетныхДокументовСрезПоследних.Регистратор КАК СуществующаяСправка,
	|	СведенияВалютногоКонтроляУчетныхДокументовСрезПоследних.ДокументРасчетов КАК ДокументРасчетов
	|ИЗ
	|	Документ.СправкаОПодтверждающихДокументах.ПодтверждающиеДокументы КАК СправкаОПодтверждающихДокументахПодтверждающиеДокументы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СведенияВалютногоКонтроляУчетныхДокументов.СрезПоследних КАК СведенияВалютногоКонтроляУчетныхДокументовСрезПоследних
	|		ПО СправкаОПодтверждающихДокументахПодтверждающиеДокументы.ПодтверждающийДокумент = СведенияВалютногоКонтроляУчетныхДокументовСрезПоследних.ДокументРасчетов
	|			И (НЕ СведенияВалютногоКонтроляУчетныхДокументовСрезПоследних.Регистратор В (&Ссылка, &ДокументОснование))
	|ГДЕ
	|	СправкаОПодтверждающихДокументахПодтверждающиеДокументы.Ссылка = &Ссылка
	|	И СведенияВалютногоКонтроляУчетныхДокументовСрезПоследних.ДокументРасчетов <> Неопределено";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ОбщегоНазначенияУХ.СообщитьОбОшибке(
		СтрШаблон(
		НСтр("ru = 'Документ %1 указан в СПД %2 В проведении документа отказано.'"), 
		Выборка.ДокументРасчетов, 
		Выборка.СуществующаяСправка),
		Отказ,,
		СтатусСообщения.Важное);
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Движения.СведенияВалютногоКонтроляУчетныхДокументов.Записывать = Истина;
	Для Каждого ТекСтрока Из ПодтверждающиеДокументы Цикл
		Если Не ЗначениеЗаполнено(ТекСтрока.ПодтверждающийДокумент) Тогда
			Возврат;
		КонецЕсли;
		
		НовоеДвижение = Движения.СведенияВалютногоКонтроляУчетныхДокументов.Добавить();
		НовоеДвижение.Период = Дата;
		НовоеДвижение.ДокументРасчетов = ТекСтрока.ПодтверждающийДокумент;
		НовоеДвижение.СрокРепатриации = ТекСтрока.ОжидаемыйСрок;
		НовоеДвижение.СуммаДокументаРасчетов = ТекСтрока.СуммаДокумента;
		
	КонецЦикла;
	
	// Напоминание.
	СоздатьНапоминаниеПроверитьОжидаемыеСрокиСПД();
	#КонецОбласти
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоТаблице(ТаблицаДокументов)
	
	Если ТаблицаДокументов.Количество() Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ТаблицаДокументов[0]);
		
		Для каждого СтрокаТаблицы Из ТаблицаДокументов Цикл
			ЗаполнитьЗначенияСвойств(ПодтверждающиеДокументы.Добавить(), СтрокаТаблицы);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	Ответственный = Пользователи.ТекущийПользователь();
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область УХ_Встраивание
// Генерирует напоминание о необходимости проверить ожидаемые сроки 
// в документе Справка о валютных операциях.
Процедура СоздатьНапоминаниеПроверитьОжидаемыеСрокиСПД()
	// Непосредственная отправка напоминаний.
	ВидСобытияПроверитьОжидаемыеСрокиСПД = Справочники.ВидыСобытийОповещений.Напоминание_ПроверитьОжидаемыеСрокиСПД;
	СтруктураНастроек = МодульУправленияОповещениямиУХ.ПолучитьНастройкиОповещенийПоВидуСобытия(ВидСобытияПроверитьОжидаемыеСрокиСПД);
	Если СтруктураНастроек.Количество() > 0 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	&Организация КАК Организация,
		|	&ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	СУММА(РасчетыСКонтрагентамиПоДокументамОстатки.СуммаОстаток) КАК СуммаОстаток,
		|	СправкаОПодтверждающихДокументахПодтверждающиеДокументы.ПодтверждающийДокумент КАК ПодтверждающийДокумент,
		|	СправкаОПодтверждающихДокументахПодтверждающиеДокументы.ОжидаемыйСрок КАК ОжидаемыйСрок,
		|	&Ответственный КАК Ответственный
		|ПОМЕСТИТЬ ВТ_ДанныеРасчетов
		|ИЗ
		|	Документ.СправкаОПодтверждающихДокументах.ПодтверждающиеДокументы КАК СправкаОПодтверждающихДокументахПодтверждающиеДокументы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКонтрагентамиПоДокументам.Остатки(
		|				,
		|				Организация = &Организация
		|					И ДоговорКонтрагента = &ДоговорКонтрагента) КАК РасчетыСКонтрагентамиПоДокументамОстатки
		|		ПО (СправкаОПодтверждающихДокументахПодтверждающиеДокументы.ОжидаемыйСрок <> &ПустаяДата)
		|			И (РасчетыСКонтрагентамиПоДокументамОстатки.ДокументРасчетов = СправкаОПодтверждающихДокументахПодтверждающиеДокументы.ПодтверждающийДокумент)
		|ГДЕ
		|	СправкаОПодтверждающихДокументахПодтверждающиеДокументы.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	СправкаОПодтверждающихДокументахПодтверждающиеДокументы.ПодтверждающийДокумент,
		|	СправкаОПодтверждающихДокументахПодтверждающиеДокументы.ОжидаемыйСрок
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_ДанныеРасчетов.ОжидаемыйСрок КАК ОжидаемыйСрок,
		|	ВТ_ДанныеРасчетов.Ответственный КАК Ответственный
		|ИЗ
		|	ВТ_ДанныеРасчетов КАК ВТ_ДанныеРасчетов
		|ГДЕ
		|	ВТ_ДанныеРасчетов.СуммаОстаток <> 0";
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("ДоговорКонтрагента", Договор);
		Запрос.УстановитьПараметр("Ответственный", Ответственный);
		Запрос.УстановитьПараметр("ПустаяДата", Дата(1, 1, 1));
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ПользовательАдресат = ВыборкаДетальныеЗаписи.Ответственный;
			ДатаФормированияСПД = ВыборкаДетальныеЗаписи.ОжидаемыйСрок;
			СтруктураНапоминание = МодульУправленияОповещениямиУХ.СоздатьСтруктуруНапоминанияПоУмолчанию(СтруктураНастроек, ПользовательАдресат, ДатаФормированияСПД, Ссылка);
			МодульУправленияОповещениямиУХ.ДобавитьНапоминаниеПользователяСЗадачей(СтруктураНапоминание);
		КонецЦикла;
	Иначе
		// Не настроек по данному оповещению. Не отправляем.
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#КонецЕсли