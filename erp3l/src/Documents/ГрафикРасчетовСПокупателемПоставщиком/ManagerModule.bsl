
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт
	
	ПолноеИмяДокумента = ОбщегоНазначения.ИмяТаблицыПоСсылке(ДокументСсылка);
	ИмяДокумента = СтрРазделить(ПолноеИмяДокумента, ".")[1];
	
	ИмяРегистраВерсий = "ВерсииРасчетов";
	ИмяРегистраГрафика = "РасчетыСКонтрагентамиГрафики";
	
	ТаблицыДляДвижений = Новый Структура;		
	ДополнительныеСвойства = Новый Структура;
	НомераТаблиц = Новый Структура;
	
	// реквизиты документа.
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента();	
	Запрос.УстановитьПараметр("ВидыДоговоровСПоставщиком", РаботаСДоговорамиКонтрагентовУХКлиентСервер.ВидыДоговоровСПоставщиком());
	Реквизиты = ПолучениеДанныхУчетнойСистемыПереопределяемыйУХ.СтрокаТаблицыЗначенийВСтруктуру(Запрос.Выполнить().Выгрузить()[0]);

	ДополнительныеСвойства.Вставить("Реквизиты", Реквизиты);
	
	Если Отказ Тогда
		Возврат ДополнительныеСвойства;
	КонецЕсли;
	
	Для Каждого ТекРеквизит Из Реквизиты Цикл
		Запрос.УстановитьПараметр(ТекРеквизит.Ключ, ТекРеквизит.Значение);
	КонецЦикла;
	
	Запрос.Текст = 
	ТекстЗапросаДатыАктуальности(НомераТаблиц, ИмяРегистраВерсий) 
	+ ПолучениеДанныхУчетнойСистемыПереопределяемыйУХ.ТекстРазделителяЗапросовПакета()	
	+ ТекстЗапросаГрафикРасчетов(НомераТаблиц, ИмяРегистраГрафика);
	
	Результат = Запрос.ВыполнитьПакет();

	Для Каждого НомерТаблицы Из НомераТаблиц Цикл
		Если СтрНачинаетсяС(НомерТаблицы.Ключ, "_") Тогда			
			Продолжить;
		КонецЕсли;
		ТаблицыДляДвижений.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;
			
	ДополнительныеСвойства.Вставить("ТаблицыДляДвижений", ТаблицыДляДвижений);
	
	Возврат ДополнительныеСвойства;

КонецФункции

Функция ОписаниеГрафика(ВидДоговора = Неопределено) Экспорт
	
	Результат = Новый Структура;
	
	СекцияТело = ФинансовыеИнструментыФормыКлиентСервер.ОписаниеСекцииГрафика();
	СекцияТело.Имя = "ОсновнойДолг";
	СекцияТело.КолонкаПриход = "СуммаНачисление";
	СекцияТело.КолонкаРасход = "СуммаОплата";
	СекцияТело.КолонкаРасходДДС = Истина;	
	СекцияТело.КолонкаОстаток = "СуммаЗадолженность";
	СекцияТело.КолонкаПриходПредставление = "Начисление";
	СекцияТело.КолонкаРасходПредставление = "Оплата";
	
	Результат.Вставить(СекцияТело.Имя,        СекцияТело);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц = Неопределено)

	Если НомераТаблиц <> Неопределено Тогда
		НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());	
	КонецЕсли;	
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Ссылка,
	|	Реквизиты.ДоговорКонтрагента.ВидДоговораУХ КАК ВидДоговораУХ,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.ОбъектРасчетов КАК ОбъектРасчетов,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.ДоговорКонтрагента.Контрагент КАК Контрагент,
	|	Реквизиты.ДоговорКонтрагента.СтатьяДвиженияДенежныхСредств КАК СтатьяОплаты,
	|	Реквизиты.ДоговорКонтрагента.ОсновнаяСтатьяИсполнение КАК СтатьяНачисления,
	|	Реквизиты.ВалютаДокумента КАК Валюта,
	|	ВЫБОР
	|		КОГДА Реквизиты.ДоговорКонтрагента.ВидДоговораУХ В (&ВидыДоговоровСПоставщиком)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийПриходРасход.Расход)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийПриходРасход.Приход)
	|	КОНЕЦ КАК ПриходРасход
	|ИЗ
	|	Документ.ГрафикРасчетовСПокупателемПоставщиком КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаДатыАктуальности(НомераТаблиц, ИмяТаблицы)

	НомераТаблиц.Вставить(ИмяТаблицы, НомераТаблиц.Количество());
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВерсияФИ.Дата КАК Период,
	|	ВерсияФИ.ОбъектРасчетов КАК ПредметГрафика,
	|	ВерсияФИ.Организация КАК Организация,	
	|	Ложь КАК ОпорныйГрафик	
	|ИЗ
	|	Документ.ГрафикРасчетовСПокупателемПоставщиком КАК ВерсияФИ
	|ГДЕ
	|	ВерсияФИ.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаГрафикРасчетов(НомераТаблиц, ИмяТаблицы)

	НомераТаблиц.Вставить(ИмяТаблицы, НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА &ПриходРасход = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийПриходРасход.Приход)
	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	КОНЕЦ КАК ВидДвижения,
	|	&Ссылка КАК ВерсияГрафика,
	|	&ОбъектРасчетов КАК ПредметГрафика,
	|	График.Дата КАК Период,
	|	&СтатьяНачисления КАК СтатьяБюджета,
	|	&ПриходРасход КАК ПриходРасход,
	|	График.СуммаНачисление КАК Сумма,
	|	&Валюта КАК Валюта,
	|	&Организация КАК Организация,
	|	&Контрагент КАК Контрагент,
	|	ЗНАЧЕНИЕ(Перечисление.ЭлементыСтруктурыЗадолженности.ОсновнойДолг) КАК ЭлементСтруктурыЗадолженности,
	|	График.Ссылка.ДоговорКонтрагента.ВидДоговораУХ КАК ВидДоговораУХ
	|ИЗ
	|	Документ.ГрафикРасчетовСПокупателемПоставщиком.График КАК График
	|ГДЕ
	|	График.Ссылка = &Ссылка
	|	И График.СуммаНачисление <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА &ПриходРасход = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийПриходРасход.Приход)
	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	КОНЕЦ,
	|	&Ссылка,
	|	&ОбъектРасчетов,
	|	График.Дата,
	|	&СтатьяОплаты,
	|	&ПриходРасход,
	|	График.СуммаОплата,
	|	&Валюта,
	|	&Организация,
	|	&Контрагент,
	|	ЗНАЧЕНИЕ(Перечисление.ЭлементыСтруктурыЗадолженности.ОсновнойДолг),
	|	График.Ссылка.ДоговорКонтрагента.ВидДоговораУХ
	|ИЗ
	|	Документ.ГрафикРасчетовСПокупателемПоставщиком.График КАК График
	|ГДЕ
	|	График.Ссылка = &Ссылка
	|	И График.СуммаОплата <> 0";
	
	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти

#КонецЕсли
