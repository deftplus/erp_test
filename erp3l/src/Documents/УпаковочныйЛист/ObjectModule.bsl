#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказНаПеремещение")
		Или ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПоставщику")
		Или ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПеремещениеТоваров")
		Или ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
		
		Вид = Перечисления.ВидыУпаковочныхЛистов.Входящий;
		
		ЗаполнитьНаОсновании(ДанныеЗаполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если Вид = Перечисления.ВидыУпаковочныхЛистов.Исходящий Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Код");
	КонецЕсли;
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверки.ВыводитьНомераСтрок = Истина;
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ,ПараметрыПроверки);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.УпаковочныйЛист), Отказ);
	УпаковочныеЛистыСервер.ПроверитьЗаполнениеТЧСУпаковочнымиЛистами(ЭтотОбъект, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов, Отказ);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Код) Тогда
		Код = Документы.УпаковочныйЛист.ПолучитьКодНового();
	КонецЕсли;
	
	ВсегоМест = УпаковочныеЛистыСервер.КоличествоМестВТЧ(Товары);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНаОсновании(ДокументОснование)
	
	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Товары.Номенклатура              КАК Номенклатура,
	|	Товары.Характеристика            КАК Характеристика,
	|	Товары.Упаковка                  КАК Упаковка,
	|	Товары.Серия                     КАК Серия,
	|	Товары.СтатусУказанияСерий       КАК СтатусУказанияСерий,
	|	СУММА(Товары.Количество)         КАК Количество,
	|	СУММА(Товары.КоличествоУпаковок) КАК КоличествоУпаковок
	|ИЗ
	|	&ИсточникДанных КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &ДокументОснование
	|	И (Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)
	|		ИЛИ Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.Упаковка,
	|	Товары.Серия,
	|	Товары.СтатусУказанияСерий";
	
	ИсточникДанных = "";
	ИмяТЧ          = "Товары";
	
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаказНаПеремещение") Тогда
		ИсточникДанных = Метаданные.Документы.ЗаказНаПеремещение.ПолноеИмя() + "." + ИмяТЧ;
	ИначеЕсли ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		ИсточникДанных = Метаданные.Документы.ЗаказПоставщику.ПолноеИмя() + "." + ИмяТЧ;
		ТекстЗапроса   = ТекстЗапросаПоОснованиюЗаказПоставщику();
	ИначеЕсли ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
		ИсточникДанных = Метаданные.Документы.ПеремещениеТоваров.ПолноеИмя() + "." + ИмяТЧ;
	Иначе
		ИсточникДанных = Метаданные.Документы.ПриобретениеТоваровУслуг.ПолноеИмя() + "." + ИмяТЧ;
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИсточникДанных", ИсточникДанных);
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Товары.Загрузить(РезультатЗапроса.Выгрузить());
	
КонецПроцедуры

Функция ТекстЗапросаПоОснованиюЗаказПоставщику()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Товары.Номенклатура              КАК Номенклатура,
	|	Товары.Характеристика            КАК Характеристика,
	|	Товары.Упаковка                  КАК Упаковка,
	|	СУММА(Товары.Количество)         КАК Количество,
	|	СУММА(Товары.КоличествоУпаковок) КАК КоличествоУпаковок
	|ИЗ
	|	&ИсточникДанных КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &ДокументОснование
	|	И (Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)
	|		ИЛИ Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.Упаковка";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли