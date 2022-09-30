//++ Устарело_Производство21
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает настройки по списку материалов
//
// Параметры:
//  Параметры		- Структура - содержит параметры
//  АдресХранилища	- Строка - адрес хранилища в которое будут помещены настройки.
//
Процедура ПрочитатьНастройкиПоСпискуМатериалов(Параметры, АдресХранилища) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	СписокНоменклатуры.Характеристика КАК Характеристика
	|ПОМЕСТИТЬ СписокНоменклатуры
	|ИЗ
	|	&СписокНоменклатуры КАК СписокНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	ВЫБОР
	|		КОГДА Таблица.Характеристика <> ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НастройкаХарактеристики,
	|	ЕСТЬNULL(НастройкаПередачиХарактеристика.ОснованиеДляПолучения, ЗНАЧЕНИЕ(Перечисление.ОснованияДляПолученияМатериаловВПроизводстве.ПустаяСсылка)) КАК ОснованиеДляПолучения,
	|	ЕСТЬNULL(НастройкаПередачиХарактеристика.Склад, ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)) КАК Склад,
	|	ВЫБОР
	|		КОГДА НЕ НастройкаПередачиХарактеристика.Подразделение ЕСТЬ NULL 
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СпособыНастройкиПередачиМатериаловВПроизводство.НастраиваетсяИндивидуально)
	|		КОГДА НЕ НастройкаПередачиНоменклатура.Подразделение ЕСТЬ NULL 
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СпособыНастройкиПередачиМатериаловВПроизводство.ОпределяетсяНастройкойДляНоменклатуры)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СпособыНастройкиПередачиМатериаловВПроизводство.ОпределяетсяНастройкойДляПодразделения)
	|	КОНЕЦ КАК СпособНастройки
	|ИЗ
	|	СписокНоменклатуры КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаПередачиМатериаловВПроизводство КАК НастройкаПередачиХарактеристика
	|		ПО (НастройкаПередачиХарактеристика.Подразделение = &Подразделение)
	|			И Таблица.Номенклатура = НастройкаПередачиХарактеристика.Номенклатура
	|			И Таблица.Характеристика = НастройкаПередачиХарактеристика.Характеристика
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаПередачиМатериаловВПроизводство КАК НастройкаПередачиНоменклатура
	|		ПО (НастройкаПередачиНоменклатура.Подразделение = &Подразделение)
	|			И (НастройкаПередачиНоменклатура.Номенклатура = Таблица.Номенклатура)
	|			И (НастройкаПередачиНоменклатура.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаПередачиМатериаловВПроизводство КАК НастройкаПередачиПодразделение
	|		ПО (НастройкаПередачиПодразделение.Подразделение = &Подразделение)
	|			И (НастройкаПередачиПодразделение.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка))
	|			И (НастройкаПередачиПодразделение.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))";
	
	Запрос.УстановитьПараметр("СписокНоменклатуры", Параметры.СписокНоменклатуры);
	Запрос.УстановитьПараметр("Подразделение",      Параметры.Подразделение);
	
	РезультатРасчета = Запрос.Выполнить().Выгрузить();
	
	ДанныеХранилища = Новый Структура;
	ДанныеХранилища.Вставить("РезультатРасчета", РезультатРасчета);
	
	ПоместитьВоВременноеХранилище(ДанныеХранилища, АдресХранилища);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
//-- Устарело_Производство21