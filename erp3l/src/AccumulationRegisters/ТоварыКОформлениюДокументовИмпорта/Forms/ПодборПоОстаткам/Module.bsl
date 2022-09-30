
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "Организация, Поставщик, Дата, АдресВХранилище, Склад");
	
	ЗаполнитьТовары();
	НастроитьЭлементыФормы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ЗаполнитьТовары();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТоваровКоличествоПриИзменении(Элемент)
	Товар = Элементы.Товары.ТекущиеДанные;
	Товар.Выбран = (Товар.Количество <> 0);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()

	ПоместитьВХранилище();
	Закрыть(КодВозвратаДиалога.OK);
	
	ОповеститьОВыборе(АдресВХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтрокиВыполнить()
	ВыделенныеТовары = РаботаСТабличнымиЧастямиКлиентСервер.ЭлементыКоллекции(Товары, Элементы.Товары.ВыделенныеСтроки);
	Для Каждого Товар Из ВыделенныеТовары Цикл
		Товар.Выбран = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтрокиВыполнить()
	ВыделенныеТовары = РаботаСТабличнымиЧастямиКлиентСервер.ЭлементыКоллекции(Товары, Элементы.Товары.ВыделенныеСтроки);
	Для Каждого Товар Из ВыделенныеТовары Цикл
		Товар.Выбран = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ЗаполнитьТовары();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Товары.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Выбран");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.RosyBrown);

КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормы()
	Элементы.Склад.Видимость = ЗначениеЗаполнено(Склад);
	Элементы.ТоварыСклад.Видимость = Не Элементы.Склад.Видимость;
КонецПроцедуры

#Область Прочее

&НаСервере
Процедура ПоместитьВХранилище() 
	ТоварыВХранилище =
		Товары.Выгрузить(
			Новый Структура("Выбран", Истина),
			"Выбран, Номенклатура, Характеристика, Серия, Склад, ДокументПоступления, ЗакупкаПодДеятельность, ХозяйственнаяОперация, Количество, КоличествоУпаковок, Упаковка");
	Для Каждого СтрокаТаблицы Из ТоварыВХранилище Цикл
		СтрокаТаблицы.КоличествоУпаковок = СтрокаТаблицы.Количество;
	КонецЦикла;
	ПоместитьВоВременноеХранилище(ТоварыВХранилище, АдресВХранилище);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТовары()
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Серия КАК Серия,
	|	Товары.Склад КАК Склад,
	|	Товары.ДокументПоступления КАК ДокументПоступления,
	|	Товары.Количество КАК Количество
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НаДату.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	НаДату.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	НаДату.АналитикаУчетаНоменклатуры.СкладскаяТерритория КАК Склад,
	|	НаДату.АналитикаУчетаНоменклатуры.Серия КАК Серия,
	|	НаСейчас.ДокументПоступления КАК ДокументПоступления,
	|	СУММА(НаСейчас.КоличествоОстаток) КАК КоличествоОстаток
	|ПОМЕСТИТЬ КОформлению
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюДокументовИмпорта.Остатки(
	|			&Граница,
	|			Организация = &Организация
	|				И Поставщик = &Поставщик
	|				И ТипДокументаИмпорта = &ТипДокументаИмпорта
	|				И (АналитикаУчетаНоменклатуры.СкладскаяТерритория = &Склад
	|					ИЛИ &ВсеСклады)) КАК НаДату
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКОформлениюДокументовИмпорта.Остатки(
	|				,
	|				Организация = &Организация
	|					И Поставщик = &Поставщик
	|					И ТипДокументаИмпорта = &ТипДокументаИмпорта
	|					И (АналитикаУчетаНоменклатуры.СкладскаяТерритория = &Склад
	|						ИЛИ &ВсеСклады)) КАК НаСейчас
	|		ПО НаДату.АналитикаУчетаНоменклатуры = НаСейчас.АналитикаУчетаНоменклатуры
	|			И НаДату.ВидЗапасов = НаСейчас.ВидЗапасов
	|ГДЕ
	|	НаСейчас.КоличествоОстаток > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	НаДату.АналитикаУчетаНоменклатуры.Номенклатура,
	|	НаДату.АналитикаУчетаНоменклатуры.Характеристика,
	|	НаДату.АналитикаУчетаНоменклатуры.СкладскаяТерритория,
	|	НаСейчас.ДокументПоступления,
	|	НаДату.АналитикаУчетаНоменклатуры.Серия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Товары.Количество > 0
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Выбран,
	|	КОформлению.Номенклатура КАК Номенклатура,
	|	КОформлению.Характеристика КАК Характеристика,
	|	КОформлению.Серия КАК Серия,
	|	КОформлению.Склад КАК Склад,
	|	КОформлению.ДокументПоступления КАК ДокументПоступления,
	|	КОформлению.ДокументПоступления.ЗакупкаПодДеятельность КАК ЗакупкаПодДеятельность,
	|	КОформлению.ДокументПоступления.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	КОформлению.КоличествоОстаток КАК КоличествоОстаток,
	|	ЕСТЬNULL(Товары.Количество, 0) КАК Количество,
	|	КОформлению.Номенклатура.ЕдиницаИзмерения КАК Упаковка
	|ИЗ
	|	КОформлению КАК КОформлению
	|		ЛЕВОЕ СОЕДИНЕНИЕ Товары КАК Товары
	|		ПО КОформлению.Номенклатура = Товары.Номенклатура
	|			И КОформлению.Характеристика = Товары.Характеристика
	|			И КОформлению.Серия = Товары.Серия
	|			И КОформлению.Склад = Товары.Склад
	|			И КОформлению.ДокументПоступления = Товары.ДокументПоступления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия,
	|	Склад,
	|	ЗакупкаПодДеятельность,
	|	ХозяйственнаяОперация,
	|	ДокументПоступления");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Поставщик", Поставщик);
	Запрос.УстановитьПараметр("ТипДокументаИмпорта", УчетПрослеживаемыхТоваровЛокализация.ИдентификаторТаможеннаяДекларацияИмпорт());
	
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("ВсеСклады", Не ЗначениеЗаполнено(Склад));
	Граница = Новый Граница(?(ЗначениеЗаполнено(Дата), КонецДня(Дата), ТекущаяДатаСеанса()), ВидГраницы.Включая);
	Запрос.УстановитьПараметр("Граница", Граница);
	
	Если Товары.Количество() > 0 Тогда
		ПараметрТовары =
			Товары.Выгрузить(Новый Структура("Выбран", Истина), "Выбран, Номенклатура, Характеристика, Серия, Склад, Количество, ДокументПоступления, Упаковка");
	Иначе
		ПараметрТовары = ПолучитьИзВременногоХранилища(АдресВХранилище); // ТаблицаЗначений, ТабличнаяЧасть
		ПараметрТовары.Свернуть("Номенклатура, Характеристика, Серия, Склад, ДокументПоступления", "Количество");
	КонецЕсли;
	Запрос.УстановитьПараметр("Товары", ПараметрТовары);
	
	Товары.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры

#КонецОбласти

#КонецОбласти
