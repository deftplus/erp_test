&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтруктураРеквизитовШаблона = Справочники.Лоты.ПолучитьРеквизитыШаблонаЛотаВСтруктуре();
	ИменаКлючевыхПолей = ЦентрализованныеЗакупкиКлиентСерверУХ.ИменаКлючевыхПолейКроссТаблицыПотребностей();
	
	НастройкаЗонтичнойЗакупки();

	СтруктураЦветФона = Новый Структура("ЦветФона", WebЦвета.Роса);
	ЦентрализованныеЗакупкиВызовСервераУХ.ВыделитьЭлементыФормы(
	ЭтаФорма, СтруктураРеквизитовШаблона, СтруктураЦветФона);
 
	КонтенкстКроссТаблицы = ЦентрализованныеЗакупкиУХ.ПолучитьТиповойКонтекстКроссТаблицыПотребностей(
	"ПериодыЗакупок", "ПотребностиВНоменклатуреПоПериодам",	
	"ПотребностиВНоменклатуреПоПериодам", ИменаКлючевыхПолей);
	

	ЦентрализованныеЗакупкиУХ.ИнициализироватьКроссТаблицуПотребностей(
	ЭтаФорма, "ПараметрыКроссТаблицыПотребностей", КонтенкстКроссТаблицы);
	
КонецПроцедуры

&НаСервере
Процедура НастройкаЗонтичнойЗакупки()
	
	Если Объект.ВидЗакупки <> Перечисления.ВидЛотовойЗакупки.Зонтичная Тогда
		Возврат;
	КонецЕсли;	
	Элементы.МестоПоЗонтичнойЗакупке.Видимость = Истина;
	МестоПобедителя = 1;
	Пока МестоПобедителя <= Объект.КоличествоПобедителейЗонтичнойЗакупки Цикл
		Элементы.МестоПоЗонтичнойЗакупке.СписокВыбора.Вставить(МестоПобедителя-1,МестоПобедителя);//Добавить(МестоПобедителя);	
		МестоПобедителя = МестоПобедителя+1;
	КонецЦикла;
	МестоПоЗонтичнойЗакупке = 1;
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеКроссТаблицы(Контекст) Экспорт

КонецПроцедуры

&НаСервере
Процедура СкопироватьВКроссТаблицу(Контекст) Экспорт
	Если НЕ ЗначениеЗаполнено(Объект.ПериодЗакупок) Тогда
		Возврат;
	КонеЦЕсли;
	
	Номенклатура = "Номенклатура";
	ЗонтичнаяНоменклатура = "УсловияРаспределенияЗонтичнойЗакупки";
	ПотребностиВНоменклатуреПоПериодам.Очистить();
	РезультатЗапроса = ПолучитьРезультатЗапросаТЧНоменклатурыПоПериодам(
	?(Объект.ВидЗакупки <> Перечисления.ВидЛотовойЗакупки.Зонтичная,Объект[Номенклатура],Объект[ЗонтичнаяНоменклатура]),
	ЭтаФорма[Контекст.ИмяТаблицыПериодов],
	Контекст.ИменаКлючевыхПолейКроссТаблицы);		
	
	ДозаполнитьТаблицуПотребностейИзРезультатаЗапроса(
	РезультатЗапроса); 
	
КонецПроцедуры

&НаСервере
Процедура ДозаполнитьТаблицуПотребностейИзРезультатаЗапроса(РезультатЗапроса)
	ЦентрализованныеЗакупкиУХ.ДозаполнитьТаблицуПотребностейИзРезультатаЗапроса(
		ПотребностиВНоменклатуреПоПериодам,
		РезультатЗапроса,
		ЭтаФорма.ПараметрыКроссТаблицыПотребностей.ИменаКлючевыхПолейКроссТаблицы);
	ЦентрализованныеЗакупкиКлиентСерверУХ.ПересчитатьИтоговыеПоказателиКроссТаблицы(
		ПотребностиВНоменклатуреПоПериодам,
		ЭтаФорма.ПериодыЗакупок,
		Объект.ЦенаВключаетНДС);	
	ОбновитьСуммуДокументаИзКроссТаблицы(ЭтаФорма);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСуммуДокументаИзКроссТаблицы(Форма)
	//Форма.ИтогоСуммаПоНоменклатуре =
	//	Форма.ПотребностиВНоменклатуреПоПериодам.Итог("Сумма");
	//Форма.Объект.СуммаЛота = Форма.ИтогоСуммаПоНоменклатуре;
	//Форма.Объект.СуммаНДС =
	//	Форма.ПотребностиВНоменклатуреПоПериодам.Итог("СуммаНДС");
	//РассчитатьВеличинуОбеспеченияЗаявки(Форма.Объект);
	//РассчитатьВеличинуОбеспеченияДоговора(Форма.Объект);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьВеличинуОбеспеченияДоговора(Объект)
	Объект.ВеличинаОбеспеченияДоговора = Объект.СуммаЛота * 
		Объект.ПроцентОтСуммыЗаявкиОбеспеченияДоговора / 100;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьВеличинуОбеспеченияЗаявки(Объект)
	Объект.ВеличинаОбеспеченияЗаявки = Объект.СуммаЛота *
		Объект.ПроцентОтСуммыЛотаОбеспеченияЗаявки / 100;
КонецПроцедуры

&НаСервере
Функция ПолучитьРезультатЗапросаТЧНоменклатурыПоПериодам(
									ТЧНоменклатура,
									ПериодыЗакупок,
									ИменаКлючевыхПолейКроссТаблицы)
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТабПериодов.Период КАК Период,
		|	ТабПериодов.Активная КАК Активная,
		|	ТабПериодов.ИмяКолонки КАК ИмяКолонки
		|ПОМЕСТИТЬ ТабПериодов
		|ИЗ
		|	&ТаблицаПериодов КАК ТабПериодов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТЧНоменклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ТЧНоменклатура.Количество КАК Количество,
		|	ТЧНоменклатура.Коэффициент КАК Коэффициент,
		|	ТЧНоменклатура.Менеджер КАК Менеджер,
		|	ТЧНоменклатура.МестоПоставки КАК МестоПоставки,
		|	ТЧНоменклатура.Номенклатура КАК Номенклатура,
		|	ТЧНоменклатура.Характеристика КАК Характеристика,
		|	ТЧНоменклатура.Организация КАК Организация,
		|	ТЧНоменклатура.ПериодПотребности КАК ПериодПотребности,
		|	ТЧНоменклатура.Приоритет КАК Приоритет,
		|	ТЧНоменклатура.Проект КАК Проект,
		|	ТЧНоменклатура.СтавкаНДС КАК СтавкаНДС,
		|	ТЧНоменклатура.Сумма КАК Сумма,
		|	ТЧНоменклатура.СуммаНДС КАК СуммаНДС,
		|	ТЧНоменклатура.Цена КАК Цена,
		|	ТЧНоменклатура.ДоговорСПокупателем КАК ДоговорСПокупателем
		|ПОМЕСТИТЬ ТЧНоменклатура
		|ИЗ
		|	&ПараметрТЧНоменклатура КАК ТЧНоменклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТЧНоменклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ТЧНоменклатура.Количество КАК Количество,
		|	ТЧНоменклатура.Коэффициент КАК Коэффициент,
		|	ТЧНоменклатура.Менеджер КАК Менеджер,
		|	ТЧНоменклатура.МестоПоставки КАК МестоПоставки,
		|	ТЧНоменклатура.Номенклатура КАК Номенклатура,
		|	ТЧНоменклатура.Характеристика КАК Характеристика,
		|	ВЫБОР
		|		КОГДА ТЧНоменклатура.Номенклатура ССЫЛКА Справочник.Номенклатура
		|			ТОГДА ВЫБОР
		|					КОГДА ВЫРАЗИТЬ(ТЧНоменклатура.Номенклатура КАК Справочник.Номенклатура).ИспользованиеХарактеристик ЕСТЬ NULL
		|						ТОГДА ЛОЖЬ
		|					ИНАЧЕ ВЫБОР
		|							КОГДА ВЫРАЗИТЬ(ТЧНоменклатура.Номенклатура КАК Справочник.Номенклатура).ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать)
		|								ТОГДА ЛОЖЬ
		|							ИНАЧЕ ВЫБОР
		|									КОГДА ВЫРАЗИТЬ(ТЧНоменклатура.Номенклатура КАК Справочник.Номенклатура).ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ПустаяСсылка)
		|										ТОГДА ЛОЖЬ
		|									ИНАЧЕ ИСТИНА
		|								КОНЕЦ
		|						КОНЕЦ
		|				КОНЕЦ
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ХарактеристикиИспользуются,
		|	ТЧНоменклатура.Организация КАК Организация,
		|	ТЧНоменклатура.ПериодПотребности КАК ПериодПотребности,
		|	ТЧНоменклатура.Приоритет КАК Приоритет,
		|	ТЧНоменклатура.Проект КАК Проект,
		|	ТЧНоменклатура.ДоговорСПокупателем КАК ДоговорСПокупателем,
		|	ТЧНоменклатура.СтавкаНДС КАК СтавкаНДС,
		|	ТЧНоменклатура.Сумма КАК Сумма,
		|	ТЧНоменклатура.СуммаНДС КАК СуммаНДС,
		|	ТЧНоменклатура.Цена КАК Цена,
		|	ВЫБОР
		|		КОГДА ТЧНоменклатура.Номенклатура ССЫЛКА Справочник.Номенклатура
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЭтоКатегорияНоменклатуры,
		|	ТабПериодов.ИмяКолонки КАК ИмяКолонки,
		|	0 КАК НомерСтроки
		|ИЗ
		|	ТЧНоменклатура КАК ТЧНоменклатура
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТабПериодов КАК ТабПериодов
		|		ПО ТЧНоменклатура.ПериодПотребности = ТабПериодов.Период
		|			И (ТабПериодов.Активная)";
	Запрос.Текст = Запрос.Текст + "УПОРЯДОЧИТЬ ПО "
		+ ИменаКлючевыхПолейКроссТаблицы;
	Запрос.УстановитьПараметр("ТаблицаПериодов",
		ПериодыЗакупок.Выгрузить());
	Запрос.УстановитьПараметр("ПараметрТЧНоменклатура",
		?(Объект.ВидЗакупки <> Перечисления.ВидЛотовойЗакупки.Зонтичная,ТЧНоменклатура.Выгрузить(),
		ТЧНоменклатура.Выгрузить(Новый Структура("МестоПобедителя",МестоПоЗонтичнойЗакупке))));
	Возврат Запрос.Выполнить();
КонецФункции

&НаСервере
Процедура ЗаполнитьОбъектДляКроссТаблицыПотребностей(Контекст, ОбъектДляЗаполнения) Экспорт
	ОбъектДляЗаполнения.Периодичность =	ЦентрализованныеЗакупкиУХ.ПолучитьПериодичностьЗакупок();								
	ЗаполнитьЗначенияСвойств(ОбъектДляЗаполнения, Объект);
	ОбъектДляЗаполнения.ДатаНачала = Объект.ПериодЗакупок.ДатаНачала;
	ОбъектДляЗаполнения.ДатаОкончания = Объект.ПериодЗакупок.ДатаОкончания;
	Если НЕ ЗначениеЗаполнено(ОбъектДляЗаполнения.ДатаКурса) Тогда
		ОбъектДляЗаполнения.ДатаКурса = Объект.ДатаНачалаПериодаПоставки;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ОбъектДляЗаполнения.ДатаКурса) Тогда
		ОбъектДляЗаполнения.ДатаКурса = ТекущаяДатаСеанса();
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура СоздатьДоговорПоПозициямЛота(Команда)
	
	//Форма = ПолучитьФорму("Документ.ВерсияСоглашенияКоммерческийДоговор.Форма.ФормаДокумента");
	//ДанныеФормы = Форма.Объект; 
	//ЗаполнитьДокументНаСервере(ДанныеФормы); 
	//КопироватьДанныеФормы(ДанныеФормы, Форма.Объект); 
	//Форма.Открыть();
	Структура = ЗаполнитьДокументНаСервере();
	Структура.ЗначенияЗаполнения.Вставить("Номенклатура",объект.номенклатура);
	Структура.ЗначенияЗаполнения.Вставить("Лот",объект.ссылка);
	
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаОбъекта", Структура);


КонецПроцедуры


&НаСервере
Функция ЗаполнитьДокументНаСервере()
	
	//Договор = ДанныеФормыВЗначение(ДанныеФормы, Тип("ДокументОбъект.ВерсияСоглашенияКоммерческийДоговор")); 
	//Договор = Документы.ВерсияСоглашенияКоммерческийДоговор.СоздатьДокумент();
	//Договор.Номенклатура.Загрузить(Объект.Номенклатура.Выгрузить());
	//Договор.ВидСоглашения = Перечисления.ВидыСоглашений.ДоговорСУсловием;
	//Договор.ВидДоговораУХ = Справочники.ВидыДоговоровКонтрагентовУХ.СПоставщиком;
	//Договор.ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов;
	//Договор.Организация = Объект.ОрганизацияДляЗаключенияДоговора;
	//ЗначениеВДанныеФормы(Договор,ДанныеФормы);
	
	ЗначенияЗаполнения = Новый Структура();
	ЗначенияЗаполнения.Вставить("ВидДоговораУХ",  Справочники.ВидыДоговоровКонтрагентовУХ.СПоставщиком);
 
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ",                Неопределено);
	СтруктураПараметров.Вставить("ЗначенияЗаполнения",  ЗначенияЗаполнения);
	//СтруктураПараметров.Вставить("Номенклатура",  Объект.Номенклатура.Выгрузить());
	
	Возврат СтруктураПараметров;
	//Модифицированность = Ложь;
	
КонецФункции	

&НаСервере
Процедура ПерезаполнитьПотребностиПоЗонтичнойЗакупке()
	
	ИменаКлючевыхПолей = ЦентрализованныеЗакупкиКлиентСерверУХ.ИменаКлючевыхПолейКроссТаблицыПотребностей();
	КонтенкстКроссТаблицы = ЦентрализованныеЗакупкиУХ.ПолучитьТиповойКонтекстКроссТаблицыПотребностей(
	"ПериодыЗакупок", "ПотребностиВНоменклатуреПоПериодам",	
	"ПотребностиВНоменклатуреПоПериодам", ИменаКлючевыхПолей);

	ЗонтичнаяНоменклатура = "УсловияРаспределенияЗонтичнойЗакупки";
	ПотребностиВНоменклатуреПоПериодам.Очистить();
	РезультатЗапроса = ПолучитьРезультатЗапросаТЧНоменклатурыПоПериодам(
	Объект[ЗонтичнаяНоменклатура],
	ЭтаФорма[КонтенкстКроссТаблицы.ИмяТаблицыПериодов],
	ИменаКлючевыхПолей);		
	
	ДозаполнитьТаблицуПотребностейИзРезультатаЗапроса(
	РезультатЗапроса); 
	
КонецПроцедуры

&НаКлиенте
Процедура МестоПоЗонтичнойЗакупкеПриИзменении(Элемент)
	ПерезаполнитьПотребностиПоЗонтичнойЗакупке()
КонецПроцедуры


&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
КонецПроцедуры

