#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Ссылка = Параметры.Ссылка;
	Дата = Параметры.Дата;
	Организация = Параметры.Организация;
	Партнер = Параметры.Партнер;
	Контрагент = Параметры.Контрагент;
	Договор = Параметры.Договор;
	ВалютаДокумента = Параметры.Валюта;
	ВалютаВзаиморасчетов = Параметры.ВалютаВзаиморасчетов;
	Курс = Параметры.Курс;
	Кратность = Параметры.Кратность;
	ХозяйственнаяОперация = Параметры.ХозяйственнаяОперация;
	ЕстьАвансированиеВыкупнойСтоимости = Параметры.ЕстьАвансированиеВыкупнойСтоимости;
	АдресЗачетАвансов = Параметры.АдресЗачетАвансов;
	ВалютаРегл = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	
	КоэффициентПересчета = КоэффициентПоКурсуИКратности(
		ВалютаДокумента,
		ВалютаВзаиморасчетов,
		Курс,
		Кратность,
		ВалютаРегл);
		
	СуммаВзаиморасчетов = Параметры.СуммаДокумента * КоэффициентПересчета;

	ЗачетАвансовИсходная = ПолучитьИзВременногоХранилища(АдресЗачетАвансов);
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ЗачетАвансовИсходная, ЗачетАвансов);
	
	Элементы.ЗачетАвансовТипПлатежа.Видимость = (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ДосрочныйВыкупАрендованныхОС);
	Элементы.ЗачетАвансовСуммаВзаиморасчетов.Видимость = (ВалютаДокумента <> ВалютаВзаиморасчетов);
	
	Если ЗначениеЗаполнено(ВалютаДокумента) Тогда
		Элементы.ЗачетАвансовСумма.Заголовок = СтрШаблон(НСтр("ru = 'Сумма (%1)';
																|en = 'Amount (%1)'"), Строка(ВалютаДокумента));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВалютаВзаиморасчетов) Тогда
		Элементы.ЗачетАвансовСуммаВзаиморасчетов.Заголовок = СтрШаблон(НСтр("ru = 'Сумма взаиморасчетов (%1)';
																			|en = 'AR/AP amount (%1)'"), Строка(ВалютаВзаиморасчетов));
	КонецЕсли;
	
	ОбновитьИтоги(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗачетАвансовСуммаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ЗачетАвансов.ТекущиеДанные;
	
	КоэффициентПересчета = КоэффициентПоКурсуИКратности(
		ВалютаДокумента,
		ВалютаВзаиморасчетов,
		Курс,
		Кратность,
		ВалютаРегл);
	
	ТекущиеДанные.СуммаВзаиморасчетов = ТекущиеДанные.Сумма * КоэффициентПересчета;
	
	ОбновитьИтоги(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗачетАвансов

&НаКлиенте
Процедура ЗачетАвансовПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И НЕ Копирование Тогда
			
		ТекущиеДанные = Элементы.ЗачетАвансов.ТекущиеДанные;
		
		ТекущиеДанные.ТипПлатежа = 
			?(ЕстьАвансированиеВыкупнойСтоимости,
				ПредопределенноеЗначение("Перечисление.ТипыПлатежейПоАренде.ВыкупнаяСтоимостьАванс"),
				ПредопределенноеЗначение("Перечисление.ТипыПлатежейПоАренде.УслугаПоАренде"));
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗачетАвансовПослеУдаления(Элемент)
	
	ОбновитьИтоги(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗачетАвансовРасчетныйДокументНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Организация);
	ПараметрыФормы.Вставить("Контрагент", Контрагент);
	ПараметрыФормы.Вставить("Договор", Договор);
	
	ТекущиеДанные = Элементы.ЗачетАвансов.ТекущиеДанные;
	ТипПлатежаПоАренде = ?(ЗначениеЗаполнено(ТекущиеДанные.ТипПлатежа), 
							ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТекущиеДанные.ТипПлатежа), 
							ДоступныеТипПлатежейПоАренде(ХозяйственнаяОперация)); 
	ПараметрыФормы.Вставить("ТипПлатежаПоАренде", ТипПлатежаПоАренде);

	ОткрытьФорму("Справочник.ДоговорыАренды.Форма.ВыборРасчетногоДокумента", ПараметрыФормы, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ЗачетАвансовРасчетныйДокументОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтрокаТаблицы = Элементы.ЗачетАвансов.ТекущиеДанные;
		СтрокаТаблицы.ТипПлатежа = ВыбранноеЗначение.ТипПлатежа;
		СтрокаТаблицы.РасчетныйДокумент = ВыбранноеЗначение.РасчетныйДокумент;
		Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьЗачетАвансов(Команда)
	ЗаполнитьЗачетАвансовНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)

	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;

	РезультатЗакрытия = Новый Структура;
	ПоместитьВоВременноеХранилищеЗачетАвансов();
	
	Закрыть(РезультатЗакрытия);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьЗачетАвансовНаСервере()
	
	ЗачетАвансов.Очистить();
	ВсегоЗачтено = 0;
	
	Если СуммаВзаиморасчетов = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	АналитикаУчетаПоПартнерам.КлючАналитики
	|ПОМЕСТИТЬ АналитикаУчетаПоПартнерам
	|ИЗ
	|	РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам
	|ГДЕ
	|	АналитикаУчетаПоПартнерам.Организация = &Организация
	|	И АналитикаУчетаПоПартнерам.Партнер = &Партнер
	|	И АналитикаУчетаПоПартнерам.Контрагент = &Контрагент
	|	И АналитикаУчетаПоПартнерам.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	КлючАналитики
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА РасчетыОстатки.ТипСуммы = ЗНАЧЕНИЕ(Перечисление.ТипыПлатежейПоАренде.ВыкупнаяСтоимостьАванс)
	|			ТОГДА 0
	|		ИНАЧЕ 100
	|	КОНЕЦ КАК Приоритет,
	|	РасчетыОстатки.ТипСуммы КАК ТипПлатежа,
	|	РасчетыОстатки.РасчетныйДокумент КАК РасчетныйДокумент,
	|
	|	ВЫБОР
	|		КОГДА &ВалютаДокумента <> &ВалютаВзаиморасчетов
	|				И &КоэффициентПересчетаВВалютуВзаиморасчетов = 0
	|			ТОГДА 0
	|		КОГДА &ВалютаДокумента <> &ВалютаВзаиморасчетов
	|				И &КоэффициентПересчетаВВалютуВзаиморасчетов <> 0
	|			ТОГДА ВЫРАЗИТЬ(РасчетыОстатки.СуммаОстаток / &КоэффициентПересчетаВВалютуВзаиморасчетов КАК ЧИСЛО (31, 2))
	|		ИНАЧЕ РасчетыОстатки.СуммаОстаток
	|	КОНЕЦ КАК Сумма,
	|
	|	РасчетыОстатки.СуммаОстаток КАК СуммаВзаиморасчетов
	|ИЗ
	|	РегистрНакопления.РасчетыПоФинансовымИнструментам.Остатки(
	|		&ПериодГраница, 
	|		ТипСуммы В (&ТипПлатежаПоАренде)
	|			И Договор = &Договор
	|			И АналитикаУчетаПоПартнерам В (ВЫБРАТЬ Т.КлючАналитики ИЗ АналитикаУчетаПоПартнерам КАК Т)) КАК РасчетыОстатки
	|ГДЕ
	|	РасчетыОстатки.СуммаОстаток > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет,
	|	ТипПлатежа,
	|	РасчетныйДокумент,
	|	СуммаВзаиморасчетов";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ПериодГраница", Новый Граница(Новый МоментВремени(Дата, Ссылка), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Партнер", Партнер);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("ВалютаДокумента", ВалютаДокумента);
	Запрос.УстановитьПараметр("ВалютаВзаиморасчетов", ВалютаВзаиморасчетов);
	Запрос.УстановитьПараметр("ТипПлатежаПоАренде", ДоступныеТипПлатежейПоАренде(ХозяйственнаяОперация));
	
	Коэффициенты = РаботаСКурсамивалютУТ.ПолучитьКоэффициентыПересчетаВалюты(
		ВалютаДокумента, ВалютаВзаиморасчетов, Дата, Организация);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуВзаиморасчетов",  Коэффициенты.КоэффициентПересчетаВВалютуВзаиморасчетов);
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	СуммаВзаиморасчетовОстаток = СуммаВзаиморасчетов;
	
	КоэффициентПересчета = КоэффициентПоКурсуИКратности(
		ВалютаДокумента,
		ВалютаВзаиморасчетов,
		Курс,
		Кратность,
		ВалютаРегл);
		
	Пока Выборка.Следующий() Цикл
		
		ДанныеСтроки = ЗачетАвансов.Добавить();
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, Выборка);
		
		Если ДанныеСтроки.СуммаВзаиморасчетов > СуммаВзаиморасчетовОстаток Тогда
			ДанныеСтроки.Сумма = ?(КоэффициентПересчета <> 0, СуммаВзаиморасчетовОстаток / КоэффициентПересчета, 0);
			ДанныеСтроки.СуммаВзаиморасчетов = СуммаВзаиморасчетовОстаток;
		КонецЕсли;
		
		Если ДанныеСтроки.ТипПлатежа <> Перечисления.ТипыПлатежейПоАренде.ОбеспечительныйПлатеж
			И ДанныеСтроки.ТипПлатежа <> Перечисления.ТипыПлатежейПоАренде.ВыкупнаяСтоимостьАванс Тогда
			ДанныеСтроки.РасчетныйДокумент = Неопределено;
		КонецЕсли;
		
		СуммаВзаиморасчетовОстаток = СуммаВзаиморасчетовОстаток - ДанныеСтроки.СуммаВзаиморасчетов;
		
		Если СуммаВзаиморасчетовОстаток = 0 Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	ОбновитьИтоги(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	#Область ЗачетАвансовРасчетныйДокумент_НеТребуется
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗачетАвансовРасчетныйДокумент.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗачетАвансов.ТипПлатежа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	
	СписокПлатежей = Новый СписокЗначений();
	СписокПлатежей.Добавить(Перечисления.ТипыПлатежейПоАренде.ОбеспечительныйПлатеж);
	СписокПлатежей.Добавить(Перечисления.ТипыПлатежейПоАренде.ВыкупнаяСтоимостьАванс);
	ОтборЭлемента.ПравоеЗначение = СписокПлатежей;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Не требуется>';
																|en = '<Not needed>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	#КонецОбласти
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДоступныеТипПлатежейПоАренде(ХозяйственнаяОперация)

	ТипПлатежаПоАренде = Новый Массив;
	ТипПлатежаПоАренде.Добавить(ПредопределенноеЗначение("Перечисление.ТипыПлатежейПоАренде.ВыкупнаяСтоимостьАванс"));
	
	Если ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ДосрочныйВыкупАрендованныхОС") Тогда
		ТипПлатежаПоАренде.Добавить(ПредопределенноеЗначение("Перечисление.ТипыПлатежейПоАренде.УслугаПоАренде"));
		ТипПлатежаПоАренде.Добавить(ПредопределенноеЗначение("Перечисление.ТипыПлатежейПоАренде.ОбеспечительныйПлатеж"));
	КонецЕсли;
	
	Возврат ТипПлатежаПоАренде;
	
КонецФункции

&НаСервере
Процедура ПоместитьВоВременноеХранилищеЗачетАвансов()
	
	ПоместитьВоВременноеХранилище(ЗачетАвансов.Выгрузить(), АдресЗачетАвансов);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИтоги(Форма)
	
	ВсегоЗачтено = Форма.ЗачетАвансов.Итог("Сумма");
	
	Форма.ВсегоЗачтено = ВсегоЗачтено;
	 
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция КоэффициентПоКурсуИКратности(Валюта, ВалютаВзаиморасчетов, Курс, Кратность, ВалютаРегламентированногоУчета)
		
	Если Курс = 0 Или Кратность = 0 Тогда
		Возврат 0;
	ИначеЕсли Валюта = ВалютаВзаиморасчетов Тогда
		Возврат 1;
	ИначеЕсли НЕ ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета
			И Валюта = ВалютаРегламентированногоУчета Тогда
		Возврат Кратность / Курс;
	Иначе
		Возврат Курс * Кратность;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
