
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Период КАК Период,
	|	Таблица.ВидДвижения КАК ВидДвижения,
	|	Таблица.Организация КАК Организация,
	|	Таблица.ОсновноеСредство КАК ОсновноеСредство,
	|	Таблица.Подразделение КАК Подразделение,
	|	Таблица.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|	Таблица.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	Таблица.Амортизация КАК Амортизация,
	|	Таблица.АмортизацияРегл КАК АмортизацияРегл,
	|	Таблица.АмортизацияНУ КАК АмортизацияНУ,
	|	Таблица.АмортизацияПР КАК АмортизацияПР,
	|	Таблица.АмортизацияВР КАК АмортизацияВР,
	|	Таблица.АмортизацияЦФ КАК АмортизацияЦФ,
	|	Таблица.АмортизацияНУЦФ КАК АмортизацияНУЦФ,
	|	Таблица.АмортизацияПРЦФ КАК АмортизацияПРЦФ,
	|	Таблица.АмортизацияВРЦФ КАК АмортизацияВРЦФ,
	|	Таблица.РезервПереоценкиАмортизации КАК РезервПереоценкиАмортизации,
	|	Таблица.РезервПереоценкиАмортизацииРегл КАК РезервПереоценкиАмортизацииРегл
	|ПОМЕСТИТЬ АмортизацияОСПередЗаписью
	|ИЗ
	|	РегистрНакопления.АмортизацияОС КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И (Таблица.Регистратор ССЫЛКА Документ.ВводОстатковВнеоборотныхАктивов2_4
	|		ИЛИ Таблица.Регистратор ССЫЛКА Документ.ПринятиеКУчетуОС2_4
	|		ИЛИ Таблица.Регистратор ССЫЛКА Документ.АмортизацияОС2_4)";
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(ТаблицаИзменений.Период, МЕСЯЦ) КАК Период,
	|	ТаблицаИзменений.Организация КАК Организация,
	|	ТаблицаИзменений.ОсновноеСредство КАК ОсновноеСредство,
	|	ИСТИНА КАК ОтражатьВРеглУчете,
	|	ИСТИНА КАК ОтражатьВУпрУчете,
	|	&Регистратор КАК Документ
	|ПОМЕСТИТЬ АмортизацияОСИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Период КАК Период,
	|		Таблица.ВидДвижения КАК ВидДвижения,
	|		Таблица.Организация КАК Организация,
	|		Таблица.ОсновноеСредство КАК ОсновноеСредство,
	|		Таблица.Подразделение КАК Подразделение,
	|		Таблица.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|		Таблица.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|		Таблица.Амортизация КАК Амортизация,
	|		Таблица.АмортизацияРегл КАК АмортизацияРегл,
	|		Таблица.АмортизацияНУ КАК АмортизацияНУ,
	|		Таблица.АмортизацияПР КАК АмортизацияПР,
	|		Таблица.АмортизацияВР КАК АмортизацияВР,
	|		Таблица.АмортизацияЦФ КАК АмортизацияЦФ,
	|		Таблица.АмортизацияНУЦФ КАК АмортизацияНУЦФ,
	|		Таблица.АмортизацияПРЦФ КАК АмортизацияПРЦФ,
	|		Таблица.АмортизацияВРЦФ КАК АмортизацияВРЦФ,
	|		Таблица.РезервПереоценкиАмортизации КАК РезервПереоценкиАмортизации,
	|		Таблица.РезервПереоценкиАмортизацииРегл КАК РезервПереоценкиАмортизацииРегл
	|	ИЗ
	|		РегистрНакопления.АмортизацияОС КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор
	|		И (Таблица.Регистратор ССЫЛКА Документ.ВводОстатковВнеоборотныхАктивов2_4
	|			ИЛИ Таблица.Регистратор ССЫЛКА Документ.ПринятиеКУчетуОС2_4
	|			ИЛИ Таблица.Регистратор ССЫЛКА Документ.АмортизацияОС2_4)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.Период,
	|		Таблица.ВидДвижения,
	|		Таблица.Организация,
	|		Таблица.ОсновноеСредство,
	|		Таблица.Подразделение,
	|		Таблица.ГруппаФинансовогоУчета,
	|		Таблица.НаправлениеДеятельности,
	|		-Таблица.Амортизация,
	|		-Таблица.АмортизацияРегл,
	|		-Таблица.АмортизацияНУ,
	|		-Таблица.АмортизацияПР,
	|		-Таблица.АмортизацияВР,
	|		-Таблица.АмортизацияЦФ,
	|		-Таблица.АмортизацияНУЦФ,
	|		-Таблица.АмортизацияПРЦФ,
	|		-Таблица.АмортизацияВРЦФ,
	|		-Таблица.РезервПереоценкиАмортизации,
	|		-Таблица.РезервПереоценкиАмортизацииРегл
	|	ИЗ
	|		АмортизацияОСПередЗаписью КАК Таблица) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Период,
	|	ТаблицаИзменений.ВидДвижения,
	|	ТаблицаИзменений.Организация,
	|	ТаблицаИзменений.ОсновноеСредство,
	|	ТаблицаИзменений.Подразделение,
	|	ТаблицаИзменений.ГруппаФинансовогоУчета,
	|	ТаблицаИзменений.НаправлениеДеятельности
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ТаблицаИзменений.Амортизация) <> 0
	|		ИЛИ СУММА(ТаблицаИзменений.АмортизацияРегл) <> 0
	|		ИЛИ СУММА(ТаблицаИзменений.АмортизацияНУ) <> 0
	|		ИЛИ СУММА(ТаблицаИзменений.АмортизацияПР) <> 0
	|		ИЛИ СУММА(ТаблицаИзменений.АмортизацияВР) <> 0
	|		ИЛИ СУММА(ТаблицаИзменений.АмортизацияЦФ) <> 0
	|		ИЛИ СУММА(ТаблицаИзменений.АмортизацияНУЦФ) <> 0
	|		ИЛИ СУММА(ТаблицаИзменений.АмортизацияПРЦФ) <> 0
	|		ИЛИ СУММА(ТаблицаИзменений.АмортизацияВРЦФ) <> 0
	|		ИЛИ СУММА(ТаблицаИзменений.РезервПереоценкиАмортизации) <> 0
	|		ИЛИ СУММА(ТаблицаИзменений.РезервПереоценкиАмортизацииРегл) <> 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ АмортизацияОСПередЗаписью";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Выборка = Запрос.ВыполнитьПакет()[0].Выбрать();
	ПроведениеДокументов.ЗарегистрироватьТаблицуКонтроля(ДополнительныеСвойства,
		"АмортизацияОСИзменение", Выборка.Следующий() И Выборка.Количество > 0);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли