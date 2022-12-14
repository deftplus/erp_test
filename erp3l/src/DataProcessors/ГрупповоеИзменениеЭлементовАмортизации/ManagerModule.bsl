#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область ЗагрузкаИзФайлаВТЧ

// Переопределяет параметры загрузки данных из файла.
//
// Параметры:
//  Параметры - Структура:
//   * ИмяМакетаСШаблоном - Строка - наименование макета. Например, "ЗагрузкаИзФайла".
//   * ИмяТабличнойЧасти - Строка - Полное имя табличной части. Например, "Документ._ДемоСчетНаОплатуПокупателю.ТабличнаяЧасть.Товары"
//   * ОбязательныеКолонки - Массив из Строка - наименования обязательных для заполнения колонок.
//   * ТипДанныхКолонки - Соответствие из КлючИЗначение:
//      * Ключ - Строка - имя колонки;
//      * Значение - ОписаниеТипов - тип колонки загружаемых данных.
//   * ДополнительныеПараметры - Структура
//
Процедура УстановитьПараметрыЗагрузкиИзФайлаВТЧ(Параметры) Экспорт

КонецПроцедуры

// Производит сопоставление данных, загружаемых в табличную часть ПолноеИмяТабличнойЧасти,
// с данными в ИБ, и заполняет параметры АдресТаблицыСопоставления и СписокНеоднозначностей.
// 
// Параметры:
// 	АдресЗагружаемыхДанных- Строка - адрес временного хранилища с таблицей значений, в которой
//                                   находятся загруженные данные из файла.
// 	АдресТаблицыСопоставления - Строка - адрес временного хранилища с пустой таблицей значений,
//                                       являющейся копией табличной части документа, 
//                                       которую необходимо заполнить из таблицы АдресЗагружаемыхДанных.
// 	СписокНеоднозначностей - ТаблицаЗначений - состоит из:
//  * Идентификатор - Число - идентификатор
//  * Колонка - Строка - имя колонки
// 	ПолноеИмяТабличнойЧасти - Строка - полное имя табличной части
// 	ДополнительныеПараметры - Структура - дополнительные параметры, переданные из формы-источнике.
//
Процедура СопоставитьЗагружаемыеДанные(АдресЗагружаемыхДанных, АдресТаблицыСопоставления, СписокНеоднозначностей, ПолноеИмяТабличнойЧасти, ДополнительныеПараметры) Экспорт
	
	ОсновныеСредства = ПолучитьИзВременногоХранилища(АдресТаблицыСопоставления); // ТаблицаЗначений
	ЗагружаемыеДанные = ПолучитьИзВременногоХранилища(АдресЗагружаемыхДанных); // ТаблицаЗначений
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ДанныеДляСопоставления.ИнвентарныйНомер КАК СТРОКА(15)) КАК ИнвентарныйНомер,
		|	ДанныеДляСопоставления.ОсновноеСредство КАК ОсновноеСредство,
		|	ДанныеДляСопоставления.Идентификатор КАК Идентификатор
		|ПОМЕСТИТЬ ДанныеДляСопоставления
		|ИЗ
		|	&ДанныеДляСопоставления КАК ДанныеДляСопоставления
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ИнвентарныйНомер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОбъектыЭксплуатации.Ссылка КАК Ссылка,
		|	ОбъектыЭксплуатации.Ссылка.ИнвентарныйНомер КАК ИнвентарныйНомер,
		|	ДанныеДляСопоставления.Идентификатор КАК Идентификатор
		|ПОМЕСТИТЬ СопоставленнаяНоменклатураПоИнвентарномуНомеру
		|ИЗ
		|	ДанныеДляСопоставления КАК ДанныеДляСопоставления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ОбъектыЭксплуатации КАК ОбъектыЭксплуатации
		|		ПО (ОбъектыЭксплуатации.Ссылка.ИнвентарныйНомер = ДанныеДляСопоставления.ИнвентарныйНомер)
		|		И (ДанныеДляСопоставления.ИнвентарныйНомер <> """")
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Идентификатор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеДляСопоставления.ОсновноеСредство КАК ОсновноеСредство,
		|	ДанныеДляСопоставления.Идентификатор КАК Идентификатор
		|ПОМЕСТИТЬ ДанныеДляСопоставленияПоНаименованию
		|ИЗ
		|	ДанныеДляСопоставления КАК ДанныеДляСопоставления
		|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленнаяНоменклатураПоИнвентарномуНомеру КАК СопоставленнаяНоменклатураПоИнвентарномуНомеру
		|		ПО ДанныеДляСопоставления.Идентификатор = СопоставленнаяНоменклатураПоИнвентарномуНомеру.Идентификатор
		|ГДЕ
		|	СопоставленнаяНоменклатураПоИнвентарномуНомеру.Идентификатор ЕСТЬ NULL
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Идентификатор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ОбъектыЭксплуатации.Ссылка) КАК Ссылка,
		|	ДанныеДляСопоставленияПоНаименованию.Идентификатор КАК Идентификатор,
		|	КОЛИЧЕСТВО(ДанныеДляСопоставленияПоНаименованию.Идентификатор) КАК Количество
		|ИЗ
		|	ДанныеДляСопоставленияПоНаименованию КАК ДанныеДляСопоставленияПоНаименованию
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ОбъектыЭксплуатации КАК ОбъектыЭксплуатации
		|		ПО (ОбъектыЭксплуатации.Наименование = (ВЫРАЗИТЬ(ДанныеДляСопоставленияПоНаименованию.ОсновноеСредство КАК
		|			СТРОКА(500))))
		|СГРУППИРОВАТЬ ПО
		|	ДанныеДляСопоставленияПоНаименованию.Идентификатор
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	МАКСИМУМ(СопоставленнаяНоменклатураПоИнвентарномуНомеру.Ссылка),
		|	СопоставленнаяНоменклатураПоИнвентарномуНомеру.Идентификатор,
		|	КОЛИЧЕСТВО(СопоставленнаяНоменклатураПоИнвентарномуНомеру.Идентификатор)
		|ИЗ
		|	СопоставленнаяНоменклатураПоИнвентарномуНомеру КАК СопоставленнаяНоменклатураПоИнвентарномуНомеру
		|СГРУППИРОВАТЬ ПО
		|	СопоставленнаяНоменклатураПоИнвентарномуНомеру.Идентификатор";

	Запрос.УстановитьПараметр("ДанныеДляСопоставления", ЗагружаемыеДанные);
	РезультатыЗапросов = Запрос.ВыполнитьПакет(); // Массив из РезультатЗапроса
	
	ТаблицаОС = РезультатыЗапросов[3].Выгрузить(); // ТаблицаЗначений

	Для каждого СтрокаТаблицы Из ЗагружаемыеДанные Цикл
		
		ОС = ОсновныеСредства.Добавить();
		ОС.Идентификатор = СтрокаТаблицы.Идентификатор;
		ОС.СрокИспользованияБУ = СтрокаТаблицы.СрокИспользованияБУ;
		ОС.СрокИспользованияУУ = СтрокаТаблицы.СрокИспользованияУУ;
		ОС.ОбъемНаработки = СтрокаТаблицы.ОбъемНаработки;
		ОС.ЛиквидационнаяСтоимостьРегл = СтрокаТаблицы.ЛиквидационнаяСтоимостьРегл;
		ОС.ЛиквидационнаяСтоимость = СтрокаТаблицы.ЛиквидационнаяСтоимость;
		
		СтрокаОС = ТаблицаОС.Найти(СтрокаТаблицы.Идентификатор, "Идентификатор");
		Если СтрокаОС <> Неопределено Тогда 
			Если СтрокаОС.Количество = 1 Тогда 
				ОС.ОсновноеСредство = СтрокаОС.Ссылка;
				ОС.ИнвентарныйНомер = СтрокаТаблицы.ИнвентарныйНомер;
			ИначеЕсли СтрокаОС.Количество > 1 Тогда
				ЗаписьОНеоднозначности = СписокНеоднозначностей.Добавить();
				ЗаписьОНеоднозначности.Идентификатор = СтрокаТаблицы.Идентификатор;
				ЗаписьОНеоднозначности.Колонка = "ОсновноеСредство";
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ОсновныеСредства, АдресТаблицыСопоставления);
	
КонецПроцедуры

#КонецОбласти

// Возвращает параметры выбора статей и аналитик.
// 
// Возвращаемое значение:
//	См. ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики
//
Функция ПараметрыВыбораСтатейИАналитик() Экспорт
	
	ПараметрыВыбораСтатьиИАналитики = Новый Массив;
	
	// СтатьяРасходов
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "Объект";
	ПараметрыВыбора.Статья = "СтатьяРасходов";
	ПараметрыВыбора.ТипСтатьи = "СтатьяРасходовТипСтатьи";
	ПараметрыВыбора.ДоступностьПоОперации = Неопределено;
	
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаРасходов";
	
	ПараметрыВыбора.ВыборСтатьиАктивовПассивов = Истина;
	ПараметрыВыбора.АналитикаАктивовПассивов = "АналитикаАктивовПассивов";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("СтатьяРасходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("АналитикаРасходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаАктивовПассивов.Добавить("АналитикаАктивовПассивов");
	
	ПараметрыВыбораСтатьиИАналитики.Добавить(ПараметрыВыбора);
	
	// СтатьяДоходов
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "Объект";
	ПараметрыВыбора.Статья = "СтатьяДоходов";
	ПараметрыВыбора.ТипСтатьи = "СтатьяДоходовТипСтатьи";
	ПараметрыВыбора.ДоступностьПоОперации = Неопределено;
	
	ПараметрыВыбора.ВыборСтатьиДоходов = Истина;
	ПараметрыВыбора.АналитикаДоходов = "АналитикаДоходов";

	ПараметрыВыбора.ВыборСтатьиАктивовПассивов = Истина;
	ПараметрыВыбора.АналитикаАктивовПассивов = "АналитикаАктивовПассивовДоходы";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("СтатьяДоходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаДоходов.Добавить("АналитикаДоходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаАктивовПассивов.Добавить("АналитикаАктивовПассивовДоходы");
	
	ПараметрыВыбораСтатьиИАналитики.Добавить(ПараметрыВыбора);
	
	Возврат ПараметрыВыбораСтатьиИАналитики;
	
КонецФункции

// Возвращает параметры настройки счетов учета.
//  
// Возвращаемое значение:
//	См. НастройкаСчетовУчетаСервер.ПараметрыНастройки
//
Функция ПараметрыНастройкиСчетовУчета() Экспорт
	
	МассивПараметров = Новый Массив();
	
	#Область НастройкаПредставлениеОтраженияРасходовВРеглУчете
	ПараметрыНастройки = НастройкаСчетовУчетаСервер.ПараметрыНастройки();
	ПараметрыНастройки.ПутьКДанным = "Объект";
	ПараметрыНастройки.НастройкаСчетовУчета = "НастройкаСчетовУчета";
	ПараметрыНастройки.СтатьяАктивовПассивов = "СтатьяРасходов";
	ПараметрыНастройки.АналитикаАктивовПассивов = "АналитикаАктивовПассивов";
	ПараметрыНастройки.Представление = "ПредставлениеОтраженияРасходовВРеглУчете";
	ПараметрыНастройки.ТипСтатьи     = "СтатьяРасходовТипСтатьи";
	
	ПараметрыНастройки.Организация = "Объект.Организация";

	ПараметрыНастройки.ЭлементыФормы.Добавить("ПредставлениеОтраженияРасходовВРеглУчете");
	МассивПараметров.Добавить(ПараметрыНастройки);
	#КонецОбласти
	
		
	#Область НастройкаПредставлениеОтраженияРасходовВРеглУчете
	ПараметрыНастройки = НастройкаСчетовУчетаСервер.ПараметрыНастройки();
	ПараметрыНастройки.ПутьКДанным = "Объект";
	ПараметрыНастройки.НастройкаСчетовУчета = "НастройкаСчетовУчетаДоходы";
	ПараметрыНастройки.СтатьяАктивовПассивов = "СтатьяДоходов";
	ПараметрыНастройки.АналитикаАктивовПассивов = "АналитикаАктивовПассивовДоходы";
	ПараметрыНастройки.Представление = "ПредставлениеОтраженияДоходовВРеглУчете";
	ПараметрыНастройки.ТипСтатьи     = "СтатьяДоходовТипСтатьи";

	ПараметрыНастройки.Организация = "Объект.Организация";

	ПараметрыНастройки.ЭлементыФормы.Добавить("ПредставлениеОтраженияДоходовВРеглУчете");
	МассивПараметров.Добавить(ПараметрыНастройки);
	#КонецОбласти
	
	Возврат МассивПараметров;
	
КонецФункции

#КонецОбласти

#КонецЕсли