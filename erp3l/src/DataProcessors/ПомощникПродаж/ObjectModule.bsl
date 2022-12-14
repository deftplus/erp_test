
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПоместитьСуммыПоЗаказамВоВременноеХранилище() Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Товары.СуммаСНДС           КАК Сумма,
	|	Товары.Номенклатура        КАК Номенклатура
	|ПОМЕСТИТЬ ВТТовары
	|ИЗ &Таблица КАК Товары
	|;
	|ВЫБРАТЬ 
	|	Неопределено                                     КАК Заказ,
	|	Ложь                                             КАК СверхЗаказа,
	|	СУММА(ВложенныйЗапрос.СуммаПлатежа)              КАК СуммаПлатежа,
	|	0                                                КАК СуммаВзаиморасчетов,
	|	СУММА(ВложенныйЗапрос.СуммаЗалогаЗаТару)         КАК СуммаЗалогаЗаТару,
	|	0                                                КАК СуммаВзаиморасчетовПоТаре
	|ИЗ (ВЫБРАТЬ
	|		ВЫБОР
	|			КОГДА Товары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|					ИЛИ НЕ &ВернутьМногооборотнуюТару
	|				ТОГДА Товары.Сумма
	|			ИНАЧЕ 0 
	|		КОНЕЦ                             КАК СуммаПлатежа,
	|		ВЫБОР 
	|			КОГДА Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|				И &ТребуетсяЗалогЗаТару
	|				ТОГДА Товары.Сумма
	|			ИНАЧЕ 0 
	|		КОНЕЦ                            КАК СуммаЗалогаЗаТару
	|	ИЗ ВТТовары КАК Товары) КАК ВложенныйЗапрос
	|;";
	
	Запрос.УстановитьПараметр("ВернутьМногооборотнуюТару", ВернутьМногооборотнуюТару);
	Запрос.УстановитьПараметр("ТребуетсяЗалогЗаТару", ТребуетсяЗалогЗаТару);
	Запрос.УстановитьПараметр("Таблица", Товары);
	
	Возврат ПоместитьВоВременноеХранилище(Запрос.Выполнить().Выгрузить(), Новый УникальныйИдентификатор());
	
КонецФункции

#КонецОбласти

#Область Инициализация

Если ПолучитьФункциональнуюОпцию("ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи") Тогда
	СоздаватьПередачуТоваровХранителю = Истина;
	ПечататьПередачуТоваровХранителю  = Истина;
КонецЕсли;

Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов") Тогда
	СоздаватьЗаказКлиента = Истина;
	ПечататьЗаказКлиента = Истина;
КонецЕсли;

Если ПолучитьФункциональнуюОпцию("ИспользоватьСчетаНаОплатуКлиентам") Тогда
	СоздаватьСчетНаОплату = Истина;
	ПечататьСчетНаОплату = Истина;
КонецЕсли;

СоздаватьЗаявкуНаВозвратТоваровОтКлиентов = Ложь;
СоздаватьДокументПродажи = Истина;
СтатусЗаказаКлиента = Перечисления.СтатусыЗаказовКлиентов.НеСогласован;
СтатусЗаявкиНаВозвратТоваровОтКлиентов = Перечисления.СтатусыЗаявокНаВозвратТоваровОтКлиентов.КВозврату;
СтатусРеализацииТоваровУслуг = Перечисления.СтатусыРеализацийТоваровУслуг.Отгружено;

ПечататьРеализациюТоваровУслуг = Истина;
ПечататьАктВыполненныхРабот = Истина;
ПечататьЗаявкуНаВозвратТоваровОтКлиентов = Ложь;

СпособДоставки = Перечисления.СпособыДоставки.Самовывоз;
СпособПрогнозированияПродаж = Перечисления.СпособыПрогнозированияПродаж.ПоСтатистикеПродаж;
ЗаполнятьТоварыПоСоглашению = Ложь;
ПериодСбораСтатистики = 30;

Если ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента") Тогда
	ВариантОбеспечения = Перечисления.ВариантыОбеспечения.Требуется;
Иначе
	ВариантОбеспечения = Перечисления.ВариантыОбеспечения.НеТребуется;
КонецЕсли;

Продажи.ПриИнициализацииПомощникаПродаж(ЭтотОбъект);

//++ Локализация
ПечататьСчетФактуру = Истина;
//-- Локализация
#КонецОбласти

#КонецЕсли