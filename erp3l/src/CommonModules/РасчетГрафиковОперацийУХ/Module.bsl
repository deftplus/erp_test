////////////////////////////////////////////////////////////////////////////////
// Модуль содержит процедуры и функции, необходимые для расчета графиков платежей по условиям оплаты.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область РасчетГрафика

Функция ПолучитьОпорныйГрафикПоРасчетномуДокументу(Знач ДокументОснование, Знач УсловиеОплаты, Знач ПроизводственныйКалендарь = Неопределено, ТолькоПостоплата = Истина) Экспорт 
	
	Результат = Новый ТаблицаЗначений();
	Результат.Колонки.Добавить("Дата", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	Результат.Колонки.Добавить("Сумма", РаботаСКурсамиВалют.ОписаниеТипаДенежногоПоля());
	Результат.Колонки.Добавить("ВариантОплаты", Новый ОписаниеТипов("ПеречислениеСсылка.ВариантыОплаты"));
	
	Если ПроизводственныйКалендарь = Неопределено Тогда 
		
		ВерсияСоглашения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "ДоговорКонтрагента.ВерсияСоглашения");
		ПроизводственныйКалендарь = РаботаСДоговорамиКонтрагентовУХ.ПолучитьПроизводственныеКалендари(ВерсияСоглашения);
		
		Если Не ЗначениеЗаполнено(ПроизводственныйКалендарь) Тогда
			ПроизводственныйКалендарь = Константы.ПроизводственныйКалендарьПоУмолчанию.Получить();
		КонецЕсли;
		
	КонецЕсли;
	
	АлгоритмыБазовыхДат = УсловиеОплаты.ЭтапыОплаты.Выгрузить(,"БазоваяДата");
	АлгоритмыБазовыхДат.Свернуть("БазоваяДата");
	БазовыеДаты = ПолучитьБазовыеДаты(АлгоритмыБазовыхДат.ВыгрузитьКолонку("БазоваяДата"), ДокументОснование);
	БазоваяСумма = БазоваяСумма(ДокументОснование);
	
	Для Каждого ЭтапОплаты Из УсловиеОплаты.ЭтапыОплаты Цикл 
		
		Если ТолькоПостоплата И ЭтапОплаты.ВариантОплаты <> Перечисления.ВариантыОплаты.Постоплата Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаГрафика = Результат.Добавить();
		СтрокаГрафика.Дата = ДатаОплаты(БазовыеДаты[ЭтапОплаты.БазоваяДата], ЭтапОплаты, ПроизводственныйКалендарь);
		СтрокаГрафика.Сумма = БазоваяСумма * ЭтапОплаты.ПроцентОплаты / 100;
		СтрокаГрафика.ВариантОплаты = ЭтапОплаты.ВариантОплаты;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция РассчитатьГрафикПоУсловиюОплаты(Знач УсловиеОплаты, Знач ДатаОтсчета, Знач ОбщаяСумма, Знач ПроизводственныйКалендарь = Неопределено, Знач ОтДатыНачисления = Истина, Знач ПозицияПлатежа = 0, Знач ТолькоПостоплата = Ложь) Экспорт
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Дата", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	Результат.Колонки.Добавить("СуммаНачисление", РаботаСКурсамиВалют.ОписаниеТипаДенежногоПоля());
	Результат.Колонки.Добавить("СуммаОплата", РаботаСКурсамиВалют.ОписаниеТипаДенежногоПоля());
	
	Если НЕ ЗначениеЗаполнено(УсловиеОплаты) Тогда 
		// Расчет невозможен.
		Возврат Результат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПроизводственныйКалендарь) Тогда 
		ПроизводственныйКалендарь = Константы.ПроизводственныйКалендарьПоУмолчанию.Получить();
	КонецЕсли;
	
	Если ОтДатыНачисления Тогда
		ДатаНачисления = ДатаОтсчета;
	Иначе
		// Определим дату начисления.
		КоличествоУсловий = УсловиеОплаты.ЭтапыОплаты.Количество();
		Если (КоличествоУсловий = 0) Или (ПозицияПлатежа > УсловиеОплаты.ЭтапыОплаты.Количество()-1) Тогда
			
			// Нет такой позиции.
			Возврат Результат;
			
		КонецЕсли;
		
		ИсходныйЭтапОплаты = УсловиеОплаты.ЭтапыОплаты[ПозицияПлатежа];
		
		Если ИсходныйЭтапОплаты.ВариантОплаты = Перечисления.ВариантыОплаты.Аванс Тогда
			ДатаНачисления = ДатаОтБазовойДатыСоСдвигом(ДатаОтсчета, ИсходныйЭтапОплаты.Срок, ИсходныйЭтапОплаты.ТипСрока, ПроизводственныйКалендарь);
		Иначе
			ДатаНачисления = ДатаОтсчета;
		КонецЕсли;
		
	КонецЕсли;
	
	// Добавим в график начисление.
	ОперацияНачисления = Результат.Добавить();
	ОперацияНачисления.Дата = ДатаНачисления;
	ОперацияНачисления.СуммаНачисление = ОбщаяСумма;
	
	Для Каждого ЭтапОплаты Из УсловиеОплаты.ЭтапыОплаты Цикл
		
		Если ОтДатыНачисления И ЭтапОплаты.ВариантОплаты = Перечисления.ВариантыОплаты.Аванс И ТолькоПостоплата Тогда
			Продолжить;
		ИначеЕсли НЕ ОтДатыНачисления И УсловиеОплаты.ЭтапыОплаты.Индекс(ЭтапОплаты) < ПозицияПлатежа Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяОплата = Результат.Добавить();
		
		НоваяОплата.Дата = ДатаОплаты(ДатаНачисления, ЭтапОплаты, ПроизводственныйКалендарь);
		
		НоваяОплата.СуммаОплата = ОбщаяСумма * ЭтапОплаты.ПроцентОплаты / 100;
		
	КонецЦикла;
	
	Результат.Сортировать("Дата");
	
	Возврат Результат;
	
КонецФункции

Функция ДатаОтБазовойДатыСоСдвигом(БазоваяДата, КоличествоДней, Знач ТипСрока, ПроизводственныйКалендарь = Неопределено) Экспорт
	
	Если ТипСрока = Перечисления.СпособыРасчетаКоличестваДнейВПериоде.ПоКалендарнымДням Тогда 
		ДатаРезультат = БазоваяДата + КоличествоДней * 24*60*60;
	Иначе 
		ДатаРезультат = КалендарныеГрафикиУХ.ПолучитьДатуПоКалендарю(
			ПроизводственныйКалендарь, 
			БазоваяДата,
			КоличествоДней);
	КонецЕсли;
	
	Возврат ДатаРезультат;
	
	
КонецФункции

Функция ПолучитьГрафикЭтаповОплаты(Знач ОбщаяСумма, Знач БазоваяДата, Знач УсловиеОплаты, Знач ПроизводственныйКалендарь = Неопределено, ТолькоПостоплата = Ложь) Экспорт
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Дата", ,ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	Результат.Колонки.Добавить("Сумма",, РаботаСКурсамиВалют.ОписаниеТипаДенежногоПоля());
	
	Если ОбщаяСумма = 0 Или Не ЗначениеЗаполнено(УсловиеОплаты) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если ПроизводственныйКалендарь = Неопределено Тогда
		ПроизводственныйКалендарь = Константы.ПроизводственныйКалендарьПоУмолчанию.Получить();
	КонецЕсли;
	
	МассивКоэффициентов = УсловиеОплаты.ЭтапыОплаты.ВыгрузитьКолонку("ПроцентОплаты");
	РаспределенныеСуммы = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(ОбщаяСумма, МассивКоэффициентов);
	
	Для Каждого ЭтапОплаты Из УсловиеОплаты.ЭтапыОплаты Цикл
		
		Если ТолькоПостоплата И ЭтапОплаты.ВариантОплаты = Перечисления.ВариантыОплаты.Аванс Тогда
			Продолжить;
		КонецЕсли;
		
		ИндексЭтапа = УсловиеОплаты.ЭтапыОплаты.Индекс(ЭтапОплаты);
		
		НоваяОплата = Результат.Добавить();
		НоваяОплата.Дата = ДатаОплаты(БазоваяДата, ЭтапОплаты, ПроизводственныйКалендарь);
		НоваяОплата.Сумма = РаспределенныеСуммы[ИндексЭтапа];
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьДатуНачисленияПоДатеПервойОперации(ДатаПервойОперации, УсловиеОплаты, ПроизводственныйКалендарь = Неопределено) Экспорт
	
	Если Не УсловиеОплаты.ЭтапыОплаты.Количество() Тогда
		Возврат ДатаПервойОперации;
	КонецЕсли;
	
	ИсходныйЭтапОплаты = УсловиеОплаты.ЭтапыОплаты[0];
	
	Если ИсходныйЭтапОплаты.ВариантОплаты = Перечисления.ВариантыОплаты.Аванс Тогда
		ДатаНачисления = ДатаОтБазовойДатыСоСдвигом(ДатаПервойОперации, ИсходныйЭтапОплаты.Срок, ИсходныйЭтапОплаты.ТипСрока, ПроизводственныйКалендарь);
	Иначе
		ДатаНачисления = ДатаПервойОперации;
	КонецЕсли;
	
	Возврат ДатаНачисления;
	
КонецФункции

Функция ГрафикиРасчетаСовпадают(ТабГрафика1, ТабГрафика2) Экспорт

	Если Тип(ТабГрафика1) = Тип("ТаблицаЗначений") Тогда
		Таб1 = ТабГрафика1.Скопировать();
	Иначе
		Таб1 = ТабГрафика1.Выгрузить();
	КонецЕсли;
	
	Если Тип(ТабГрафика2) = Тип("ТаблицаЗначений") Тогда
		Таб2 = ТабГрафика2.Скопировать();
	Иначе
		Таб2 = ТабГрафика2.Выгрузить();
	КонецЕсли;
	
	Если Таб1.Колонки.Найти("ИдентификаторПозицииГрафика") <> Неопределено Тогда
		Таб1.Колонки.Удалить("ИдентификаторПозицииГрафика");
	КонецЕсли;
	
	Если Таб2.Колонки.Найти("ИдентификаторПозицииГрафика") <> Неопределено Тогда
		Таб2.Колонки.Удалить("ИдентификаторПозицииГрафика");
	КонецЕсли;

	Возврат ОбщегоНазначения.ДанныеСовпадают(Таб1, Таб2);
	
КонецФункции

#КонецОбласти

// Процедура формирует документы "Заявка на операцию" на основании графика оплаты.
// Возвращаемое значение:
//  Массив - Перечень сформированных заявок на оплату.
Функция СформироватьЗаявкиПоГрафикуОплаты(ОбъектыРасчетов = Неопределено, Знач ДатаНачала = Неопределено, Знач ДатаОкончания = Неопределено, Начисления = Истина ) Экспорт 
	
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	
	Интервал = Константы.СрокАвтоОтправкиЗаявокНаСогласование.Получить();
	МаксДатаОтправкиНаСогласование = КонецДня(ТекущаяДатаСеанса + 86400 * Интервал);
	
	Если Не ЗначениеЗаполнено(ДатаНачала)Тогда
		ДатаНачала = НачалоДня(ТекущаяДатаСеанса);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаОкончания) Тогда
		ДатаОкончания =  КонецДня(ТекущаяДатаСеанса + 86400 * Константы.ГоризонтФормированияЗаявокПоГрафикам.Получить());
	КонецЕсли;
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	Если ОбъектыРасчетов = Неопределено Тогда
		// Сформируем список потенциальных объектов расчетов.
		Запрос.Текст = ДоговорыКонтрагентовВстраиваниеУХ.ТекстЗапросаВсеОбъектыРасчетов();
		
	Иначе
		// 
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВерсииРасчетовСрезПоследних.ПредметГрафика КАК ПредметГрафика,
		|	ВерсииРасчетовСрезПоследних.Регистратор КАК Регистратор
		|ПОМЕСТИТЬ ВТ_Сделки
		|ИЗ
		|	РегистрСведений.ВерсииРасчетов.СрезПоследних(,ПредметГрафика В (&ОбъектыРасчетов)) КАК ВерсииРасчетовСрезПоследних";
		
		Запрос.УстановитьПараметр("ОбъектыРасчетов", ОбъектыРасчетов);
		
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета() + 
		"ВЫБРАТЬ
		|	ГрафикиРасчетов.Организация КАК Организация,
		|	ГрафикиРасчетов.Контрагент КАК Контрагент,
		|	ГрафикиРасчетов.ПредметГрафика КАК ОбъектРасчетов,
		|	ГрафикиРасчетов.СтатьяБюджета КАК СтатьяДвиженияДенежныхСредств,
		|	ГрафикиРасчетов.Период КАК Дата,
		|	ГрафикиРасчетов.ПриходРасход КАК ПриходРасход,
		|	СУММА(ГрафикиРасчетов.Сумма) КАК СуммаГрафик,
		|	ЕСТЬNULL(ГрафикиРасчетов.Операция.ВидОперацииУХ, ВЫБОР
		|			КОГДА ГрафикиРасчетов.ПриходРасход = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийПриходРасход.Расход)
		|				ТОГДА ВЫРАЗИТЬ(ГрафикиРасчетов.ПредметГрафика КАК Справочник.ДоговорыКонтрагентов).ВидДоговораУХ.ВидОперацииУХСписание
		|			ИНАЧЕ ВЫРАЗИТЬ(ГрафикиРасчетов.ПредметГрафика КАК Справочник.ДоговорыКонтрагентов).ВидДоговораУХ.ВидОперацииУХПоступление
		|		КОНЕЦ) КАК ВидОперацииУХ,
		|	ЕСТЬNULL(ГрафикиРасчетов.ВерсияГрафика.БезакцептноеСписание, ЛОЖЬ) КАК БезакцептноеСписание,
		|	ГрафикиРасчетов.Аналитика1 КАК Аналитика1,
		|	ГрафикиРасчетов.Аналитика2 КАК Аналитика2,
		|	ГрафикиРасчетов.Аналитика3 КАК Аналитика3,
		|	ГрафикиРасчетов.Аналитика4 КАК Аналитика4,
		|	ГрафикиРасчетов.Аналитика5 КАК Аналитика5,
		|	ГрафикиРасчетов.Аналитика6 КАК Аналитика6,
		|	ГрафикиРасчетов.ЦФО КАК ЦФО,
		|	ГрафикиРасчетов.Проект КАК Проект,
		|	ГрафикиРасчетов.СчетОрганизации КАК СчетОрганизации,
		|	ГрафикиРасчетов.СчетКонтрагента КАК СчетКонтрагента,
		|	ГрафикиРасчетов.ЭлементСтруктурыЗадолженности КАК ЭлементСтруктурыЗадолженности,
		|	ГрафикиРасчетов.ВидБюджета КАК ВидБюджета
		|ПОМЕСТИТЬ ВТ_Графики
		|ИЗ
		|	РегистрНакопления.РасчетыСКонтрагентамиГрафики КАК ГрафикиРасчетов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Сделки КАК ВТ_Сделки
		|		ПО ГрафикиРасчетов.Регистратор = ВТ_Сделки.Регистратор
		|			И (ГрафикиРасчетов.СтатьяБюджета ССЫЛКА Справочник.СтатьиДвиженияДенежныхСредств
		|			ИЛИ ГрафикиРасчетов.СтатьяБюджета ССЫЛКА Справочник.СтатьиДоходовИРасходов
		|			ИЛИ ГрафикиРасчетов.СтатьяБюджета ССЫЛКА Справочник.СтатьиДвиженияРесурсов)
		|			И (ГрафикиРасчетов.Период МЕЖДУ &ДатаНачала И &ДатаОкончания)
		|
		|СГРУППИРОВАТЬ ПО
		|	ГрафикиРасчетов.Организация,
		|	ГрафикиРасчетов.Контрагент,
		|	ГрафикиРасчетов.ВидБюджета,
		|	ГрафикиРасчетов.ПредметГрафика,
		|	ГрафикиРасчетов.СтатьяБюджета,
		|	ГрафикиРасчетов.Период,
		|	ГрафикиРасчетов.ПриходРасход,
		|	ЕСТЬNULL(ГрафикиРасчетов.Операция.ВидОперацииУХ, ВЫБОР
		|			КОГДА ГрафикиРасчетов.ПриходРасход = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийПриходРасход.Расход)
		|				ТОГДА ВЫРАЗИТЬ(ГрафикиРасчетов.ПредметГрафика КАК Справочник.ДоговорыКонтрагентов).ВидДоговораУХ.ВидОперацииУХСписание
		|			ИНАЧЕ ВЫРАЗИТЬ(ГрафикиРасчетов.ПредметГрафика КАК Справочник.ДоговорыКонтрагентов).ВидДоговораУХ.ВидОперацииУХПоступление
		|		КОНЕЦ),
		|	ЕСТЬNULL(ГрафикиРасчетов.ВерсияГрафика.БезакцептноеСписание, ЛОЖЬ),
		|	ГрафикиРасчетов.Аналитика1,
		|	ГрафикиРасчетов.Аналитика2,
		|	ГрафикиРасчетов.Аналитика3,
		|	ГрафикиРасчетов.Аналитика4,
		|	ГрафикиРасчетов.Аналитика5,
		|	ГрафикиРасчетов.Аналитика6,
		|	ГрафикиРасчетов.ЦФО,
		|	ГрафикиРасчетов.Проект,
		|	ГрафикиРасчетов.СчетОрганизации,
		|	ГрафикиРасчетов.СчетКонтрагента,
		|	ГрафикиРасчетов.ЭлементСтруктурыЗадолженности
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РазмещениеЗаявок.ЗаявкаНаОперацию КАК ЗаявкаНаОперацию, 
		//++ УХ_ЕРПУХ	
		|	ЕСТЬNULL(РазмещениеЗаявок.ЗаявкаНаОперацию.Договор, РазмещениеЗаявок.ЗаявкаНаОперацию.ОбъектРасчетов) КАК ОбъектРасчетов,
		//-- УХ_ЕРПУХ	
		|	ДвиженияБюджетированияПоПозициям.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
		|	РазмещениеЗаявок.ДатаИсполнения КАК Дата,
		|	РазмещениеЗаявок.ПриходРасход КАК ПриходРасход,
		|	ДвиженияБюджетированияПоПозициям.Сумма КАК СуммаПоДокументам,
		|	РегистрСостоянийОбъектовСрезПоследних.СостояниеОбъекта КАК СостояниеОбъекта,
		|	ДвиженияБюджетированияПоПозициям.Аналитика1 КАК Аналитика1,
		|	ДвиженияБюджетированияПоПозициям.Аналитика2 КАК Аналитика2,
		|	ДвиженияБюджетированияПоПозициям.Аналитика3 КАК Аналитика3,
		|	ДвиженияБюджетированияПоПозициям.Аналитика4 КАК Аналитика4,
		|	ДвиженияБюджетированияПоПозициям.Аналитика5 КАК Аналитика5,
		|	ДвиженияБюджетированияПоПозициям.Аналитика6 КАК Аналитика6,
		|	ДвиженияБюджетированияПоПозициям.ЦФО КАК ЦФО,
		|	ДвиженияБюджетированияПоПозициям.Проект КАК Проект,
		|	РазмещениеЗаявок.СчетКонтрагента КАК СчетКонтрагента,
		|	РазмещениеЗаявок.БанковскийСчетКасса КАК СчетОрганизации,
		|	ДвиженияБюджетированияПоПозициям.ЭлементСтруктурыЗадолженности КАК ЭлементСтруктурыЗадолженности
		|ПОМЕСТИТЬ ВТ_Исполнение
		|ИЗ
		|	РегистрСведений.РазмещениеЗаявок КАК РазмещениеЗаявок
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДвиженияБюджетированияПоПозициям КАК ДвиженияБюджетированияПоПозициям
		|		ПО РазмещениеЗаявок.ИдентификаторПозиции = ДвиженияБюджетированияПоПозициям.ИдентификаторПозиции
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияИсполненияДокументовПланирования.СрезПоследних КАК СостоянияИсполненияДокументовПланированияСрезПоследних
		|		ПО РазмещениеЗаявок.ИдентификаторПозиции = СостоянияИсполненияДокументовПланированияСрезПоследних.ИдентификаторПозиции
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РегистрСостоянийОбъектов.СрезПоследних КАК РегистрСостоянийОбъектовСрезПоследних
		|		ПО РазмещениеЗаявок.ЗаявкаНаОперацию = РегистрСостоянийОбъектовСрезПоследних.Объект
		|ГДЕ
		//++ УХ_ЕРПУХ	
		|	ЕСТЬNULL(РазмещениеЗаявок.ЗаявкаНаОперацию.Договор, РазмещениеЗаявок.ЗаявкаНаОперацию.ОбъектРасчетов) В
		//-- УХ_ЕРПУХ	
		|			(ВЫБРАТЬ
		|				ВТ_Сделки.ПредметГрафика
		|			ИЗ
		|				ВТ_Сделки КАК ВТ_Сделки)
		|	И ЕСТЬNULL(СостоянияИсполненияДокументовПланированияСрезПоследних.СостояниеИсполнения, ЗНАЧЕНИЕ(Перечисление.СостоянияИсполненияЗаявки.НеОбработана)) В (ЗНАЧЕНИЕ(Перечисление.СостоянияИсполненияЗаявки.НеОбработана), ЗНАЧЕНИЕ(Перечисление.СостоянияИсполненияЗаявки.ВключенаВРеестрПлатежей), ЗНАЧЕНИЕ(Перечисление.СостоянияИсполненияЗаявки.НаИсполнении))
		|	И РазмещениеЗаявок.ЗаявкаНаОперацию.Проведен
		|	И РазмещениеЗаявок.ЗаявкаНаОперацию.ЭтоОперацияПоГрафику
		|	И РазмещениеЗаявок.ДатаИсполнения МЕЖДУ &ДатаНачала И &ДатаОкончания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Графики.ОбъектРасчетов КАК ОбъектРасчетов,
		|	ВТ_Графики.Организация КАК Организация,
		|	ВТ_Графики.Контрагент КАК Контрагент,
		|	ВТ_Графики.СтатьяДвиженияДенежныхСредств КАК СтатьяБюджета,
		|	ВТ_Графики.Дата КАК ДатаНачала,
		|	ВТ_Графики.Дата КАК ЖелательнаяДатаПлатежа,
		|	ВТ_Графики.Дата КАК КрайняяДата,
		|	ВТ_Графики.ПриходРасход КАК ПриходРасход,
		|	ВТ_Графики.СуммаГрафик - ЕСТЬNULL(Исполнение.СуммаПоДокументам, 0) КАК СуммаДокумента,
		|	ВТ_Графики.ВидОперацииУХ КАК ВидОперацииУХ,
		|	ВТ_Графики.ВидБюджета КАК ВидБюджета,
		|	ВТ_Графики.БезакцептноеСписание КАК БезакцептноеСписание,
		|	ИСТИНА КАК ЭтоОперацияПоГрафику,
		|	ВТ_Графики.Аналитика1 КАК Аналитика1,
		|	ВТ_Графики.Аналитика2 КАК Аналитика2,
		|	ВТ_Графики.Аналитика3 КАК Аналитика3,
		|	ВТ_Графики.Аналитика4 КАК Аналитика4,
		|	ВТ_Графики.Аналитика5 КАК Аналитика5,
		|	ВТ_Графики.Аналитика6 КАК Аналитика6,
		|	ВТ_Графики.ЦФО КАК ЦФО,
		|	ВТ_Графики.Проект КАК Проект,
		|   ВТ_Графики.ЭлементСтруктурыЗадолженности КАК ЭлементСтруктурыЗадолженности,
//++ УХ_ЕРПУХ		
		|	ВТ_Графики.СчетОрганизации КАК БанковскийСчет,
		|	ВТ_Графики.СчетКонтрагента КАК БанковскийСчетКонтрагента
//-- УХ_ЕРПУХ			
		|ИЗ
		|	ВТ_Графики КАК ВТ_Графики
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ВТ_Исполнение.ОбъектРасчетов КАК ОбъектРасчетов,
		|			ВТ_Исполнение.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
		|			ВТ_Исполнение.Дата КАК Дата,
		|			ВТ_Исполнение.ПриходРасход КАК ПриходРасход,
		|			СУММА(ВТ_Исполнение.СуммаПоДокументам) КАК СуммаПоДокументам,
		|			ВТ_Исполнение.Аналитика1 КАК Аналитика1,
		|			ВТ_Исполнение.Аналитика2 КАК Аналитика2,
		|			ВТ_Исполнение.Аналитика3 КАК Аналитика3,
		|			ВТ_Исполнение.Аналитика4 КАК Аналитика4,
		|			ВТ_Исполнение.Аналитика5 КАК Аналитика5,
		|			ВТ_Исполнение.Аналитика6 КАК Аналитика6,
		|			ВТ_Исполнение.ЦФО КАК ЦФО,
		|			ВТ_Исполнение.Проект КАК Проект,
		|			ВТ_Исполнение.СчетКонтрагента КАК СчетКонтрагента,
		|			ВТ_Исполнение.СчетОрганизации КАК СчетОрганизации,
		|			ВТ_Исполнение.ЭлементСтруктурыЗадолженности КАК ЭлементСтруктурыЗадолженности
		|		ИЗ
		|			ВТ_Исполнение КАК ВТ_Исполнение
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ВТ_Исполнение.ОбъектРасчетов,
		|			ВТ_Исполнение.СтатьяДвиженияДенежныхСредств,
		|			ВТ_Исполнение.Дата,
		|			ВТ_Исполнение.ПриходРасход,
		|			ВТ_Исполнение.Аналитика1,
		|			ВТ_Исполнение.Аналитика2,
		|			ВТ_Исполнение.Аналитика3,
		|			ВТ_Исполнение.Аналитика4,
		|			ВТ_Исполнение.Аналитика5,
		|			ВТ_Исполнение.Аналитика6,
		|			ВТ_Исполнение.ЦФО,
		|			ВТ_Исполнение.Проект,
		|			ВТ_Исполнение.СчетКонтрагента,
		|			ВТ_Исполнение.СчетОрганизации,
		|			ВТ_Исполнение.ЭлементСтруктурыЗадолженности) КАК Исполнение
		|		ПО ВТ_Графики.ОбъектРасчетов = Исполнение.ОбъектРасчетов
		|			И ВТ_Графики.СтатьяДвиженияДенежныхСредств = Исполнение.СтатьяДвиженияДенежныхСредств
		|			И ВТ_Графики.Дата = Исполнение.Дата
		|			И ВТ_Графики.ПриходРасход = Исполнение.ПриходРасход
		|			И ВТ_Графики.Аналитика1 = Исполнение.Аналитика1
		|			И ВТ_Графики.Аналитика2 = Исполнение.Аналитика2
		|			И ВТ_Графики.Аналитика3 = Исполнение.Аналитика3
		|			И ВТ_Графики.Аналитика4 = Исполнение.Аналитика4
		|			И ВТ_Графики.Аналитика5 = Исполнение.Аналитика5
		|			И ВТ_Графики.Аналитика6 = Исполнение.Аналитика6
		|			И ВТ_Графики.ЦФО = Исполнение.ЦФО
		|			И ВТ_Графики.Проект = Исполнение.Проект
		|			И (ВЫБОР
		|				КОГДА ЕСТЬNULL(ВТ_Графики.СчетОрганизации, ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаОрганизаций.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаОрганизаций.ПустаяСсылка)
		|					ТОГДА ИСТИНА
		|				ИНАЧЕ ВТ_Графики.СчетОрганизации = Исполнение.СчетОрганизации
		|			КОНЕЦ)
		|			И (ВЫБОР
		|				КОГДА ЕСТЬNULL(ВТ_Графики.СчетКонтрагента, ЗНАЧЕНИЕ(Справочник.БанковскиеКартыКонтрагентов.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаОрганизаций.ПустаяСсылка)
		|					ТОГДА ИСТИНА
		|				ИНАЧЕ ВТ_Графики.СчетКонтрагента = Исполнение.СчетКонтрагента
		|			КОНЕЦ)      	
		|			И ВТ_Графики.ЭлементСтруктурыЗадолженности = Исполнение.ЭлементСтруктурыЗадолженности
		|ГДЕ
		|	ВТ_Графики.СуммаГрафик - ЕСТЬNULL(Исполнение.СуммаПоДокументам, 0) > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Исполнение.ЗаявкаНаОперацию КАК ЗаявкаНаОперацию
		|ИЗ
		|	ВТ_Исполнение КАК ВТ_Исполнение
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Графики КАК ВТ_Графики
		|		ПО ВТ_Исполнение.ОбъектРасчетов = ВТ_Графики.ОбъектРасчетов
		|			И ВТ_Исполнение.СтатьяДвиженияДенежныхСредств = ВТ_Графики.СтатьяДвиженияДенежныхСредств
		|			И ВТ_Исполнение.Дата = ВТ_Графики.Дата
		|			И ВТ_Исполнение.ПриходРасход = ВТ_Графики.ПриходРасход
		|			И ВТ_Исполнение.Аналитика1 = ВТ_Графики.Аналитика1
		|			И ВТ_Исполнение.Аналитика2 = ВТ_Графики.Аналитика2
		|			И ВТ_Исполнение.Аналитика3 = ВТ_Графики.Аналитика3
		|			И ВТ_Исполнение.Аналитика4 = ВТ_Графики.Аналитика4
		|			И ВТ_Исполнение.Аналитика5 = ВТ_Графики.Аналитика5
		|			И ВТ_Исполнение.Аналитика6 = ВТ_Графики.Аналитика6
		|			И ВТ_Исполнение.ЦФО = ВТ_Графики.ЦФО
		|			И ВТ_Исполнение.Проект = ВТ_Графики.Проект
		|			И (ВЫБОР
		|				КОГДА ЕСТЬNULL(ВТ_Графики.СчетОрганизации, ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаОрганизаций.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаОрганизаций.ПустаяСсылка)
		|					ТОГДА ИСТИНА
		|				ИНАЧЕ ВТ_Графики.СчетОрганизации = ВТ_Исполнение.СчетОрганизации
		|			КОНЕЦ)
		|			И (ВЫБОР
		|				КОГДА ЕСТЬNULL(ВТ_Графики.СчетКонтрагента, ЗНАЧЕНИЕ(Справочник.БанковскиеКартыКонтрагентов.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаОрганизаций.ПустаяСсылка)
		|					ТОГДА ИСТИНА
		|				ИНАЧЕ ВТ_Графики.СчетКонтрагента = ВТ_Исполнение.СчетКонтрагента
		|			КОНЕЦ)
		|			И ВТ_Исполнение.ЭлементСтруктурыЗадолженности = ВТ_Графики.ЭлементСтруктурыЗадолженности
		|ГДЕ
		|	ВТ_Графики.СуммаГрафик ЕСТЬ NULL";

	Запрос.УстановитьПараметр("ДатаНачала", 	ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", 	ДатаОкончания);
	
	РезультатЗапроса 	= Запрос.ВыполнитьПакет();
	КоличествоЭлементов = РезультатЗапроса.Количество();
	
	ИмяСобытияЖР = НСтр("ru = 'Формирование заявок по графикам оплат'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	ЗаявкиКОтменеПроведения = РезультатЗапроса[КоличествоЭлементов - 1].Выгрузить().ВыгрузитьКолонку("ЗаявкаНаОперацию");
	Для Каждого Заявка Из ЗаявкиКОтменеПроведения Цикл
		Попытка
			Заявка.ПолучитьОбъект().Записать(РежимЗаписиДокумента.ОтменаПроведения);
		Исключение
			ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ИмяСобытияЖР, УровеньЖурналаРегистрации.Ошибка,,Заявка, ОписаниеОшибки);
			ОбщегоНазначения.СообщитьПользователю(Нстр("ru = 'Не удалось отменить проведение заявки на оплату:'") 
				+ Символы.ПС + ОписаниеОшибки);
		КонецПопытки	
	КонецЦикла;
	
	ДанныеДляСозданияЗаявок 	= РезультатЗапроса[КоличествоЭлементов - 2].Выгрузить();
	
	ИмяРеквизитаЖелаемаяДата	= "ДатаНачала";

	Для Каждого ТекСтрока из ДанныеДляСозданияЗаявок Цикл
		
		МенеджерДокументаБДДС 		= ЗаявкиНаОперации.ПолучитьМенеджерЗаявки(Перечисления.ПредназначенияЭлементовСтруктурыОтчета.БюджетДвиженияДенежныхСредств, ТекСтрока.ПриходРасход);
		МенеджерДокументаБДР	 	= ЗаявкиНаОперации.ПолучитьМенеджерЗаявки(Перечисления.ПредназначенияЭлементовСтруктурыОтчета.БюджетДоходовИРасходов, ТекСтрока.ПриходРасход);
		
		Попытка
			Если ТекСтрока.ВидБюджета = ПланыВидовХарактеристик.ВидыБюджетов.БюджетДвиженияДенежныхСредств Тогда
				
				ДокументОбъект 		= МенеджерДокументаБДДС.СоздатьДокумент();
				СтруктураЗаполнения = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТекСтрока);
				ДокументОбъект.Заполнить(СтруктураЗаполнения);
				Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДокументОбъект,ИмяРеквизитаЖелаемаяДата) Тогда
					Если ДокументОбъект[ИмяРеквизитаЖелаемаяДата] > МаксДатаОтправкиНаСогласование Тогда
						ДокументОбъект.ДополнительныеСвойства.Вставить("НеОтправлятьНаСогласованиеПриПроведении", Истина);
					КонецЕсли;
					
				Иначе
					Если ДокументОбъект.ЖелательнаяДатаПлатежа > МаксДатаОтправкиНаСогласование Тогда
						ДокументОбъект.ДополнительныеСвойства.Вставить("НеОтправлятьНаСогласованиеПриПроведении", Истина);
					КонецЕсли;
				КонецЕсли;
				Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДокументОбъект, "ЭтоОперацияПоГрафику") Тогда
					ДокументОбъект.ЭтоОперацияПоГрафику = Истина;				
				КонецЕсли;
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
				Результат.Добавить(ДокументОбъект.Ссылка);
			КонецЕсли; 
			
		Исключение
			ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ИмяСобытияЖР, УровеньЖурналаРегистрации.Ошибка,,,ОписаниеОшибки);
			ОбщегоНазначения.СообщитьПользователю(Нстр("ru = 'Не удалось провести заявку на оплату:'") 
			+ Символы.ПС + ОписаниеОшибки);
			
		КонецПопытки;
		
		Попытка
			Если ТекСтрока.ВидБюджета <> ПланыВидовХарактеристик.ВидыБюджетов.БюджетДвиженияДенежныхСредств
				 И 	Начисления Тогда
				
				ДокументОбъект 		= МенеджерДокументаБДР.СоздатьДокумент();
				СтруктураЗаполнения = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТекСтрока);
				ДокументОбъект.Заполнить(СтруктураЗаполнения);
				Если ДокументОбъект[ИмяРеквизитаЖелаемаяДата] > МаксДатаОтправкиНаСогласование Тогда
					ДокументОбъект.ДополнительныеСвойства.Вставить("НеОтправлятьНаСогласованиеПриПроведении", Истина);
				КонецЕсли; 
				Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДокументОбъект, "ЭтоОперацияПоГрафику") Тогда
					ДокументОбъект.ЭтоОперацияПоГрафику = Истина;				
				КонецЕсли;
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
				Результат.Добавить(ДокументОбъект.Ссылка);
			КонецЕсли; 
		Исключение
			ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ИмяСобытияЖР, УровеньЖурналаРегистрации.Ошибка,,,ОписаниеОшибки);
			ОбщегоНазначения.СообщитьПользователю(Нстр("ru = 'Не удалось провести заявку на оплату:'") 
			+ Символы.ПС + ОписаниеОшибки);

		КонецПопытки;	
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция РаспределитьПланНаФактГрафикаНакладной(ИсхПланГрафика, ИсхФактГрафика, знач ДатаНакладной, Знач ДатаАктуализации) Экспорт
	
	ДатаНакладной = НачалоДня(ДатаНакладной);
	ДатаАктуализации = НачалоДня(ДатаАктуализации);
	
	ПланГрафика = ИсхПланГрафика.Скопировать();
	ПланГрафика.Колонки.Добавить("Распределено", ОбщегоНазначения.ОписаниеТипаЧисло(15, 2));
	ПланГрафика.Сортировать("Дата");
	
	НовыйГрафик = ИсхФактГрафика.Скопировать();
	НовыйГрафик.Колонки.Добавить("Распределено", ОбщегоНазначения.ОписаниеТипаЧисло(15, 2));
	НовыйГрафик.Сортировать("Дата");
	
	//* дата начала внесения корректировок в график 
	// - ближайшая к текущей дате плановая пост оплата,
	// 	 аванс не корректируем, считаем что если произошла отгрузка, то значит аванс достаточен
	ДатаНачалаКорректировки = Дата(1, 1, 1);
	Для каждого СтрокаПлан Из ПланГрафика Цикл
	
		Если СтрокаПлан.Дата >= ДатаНакладной 
			И СтрокаПлан.Дата >= ДатаАктуализации Тогда
			
			ДатаНачалаКорректировки = СтрокаПлан.Дата;
			Прервать;
		КонецЕсли;		
	КонецЦикла;
		
	Если НЕ ЗначениеЗаполнено(ДатаНачалаКорректировки) Тогда
		ДатаНачалаКорректировки = ДатаАктуализации;
	КонецЕсли;
	
	//* распределение плановых оплат на факт
	Для каждого СтрокаПлан Из ПланГрафика Цикл
			
		Если СтрокаПлан.Сумма <= 0 Тогда
			Продолжить; // некорректные данные
		КонецЕсли;
		
		Для каждого СтрокаФакт Из НовыйГрафик Цикл
			Если СтрокаФакт.ЭлементСтруктурыЗадолженности = СтрокаПлан.ЭлементСтруктурыЗадолженности
				И СтрокаФакт.КолонкаСекции = СтрокаПлан.КолонкаСекции Тогда
					
				Остаток = (СтрокаФакт.Сумма - СтрокаФакт.Распределено);
				Если Остаток > 0 Тогда
					Распределено = Мин(Остаток, СтрокаПлан.Сумма - СтрокаПлан.Распределено);
					СтрокаФакт.Распределено = СтрокаФакт.Распределено + Распределено;
					СтрокаПлан.Распределено = СтрокаПлан.Распределено + Распределено;
				КонецЕсли;
				
				Если СтрокаПлан.Распределено = СтрокаПлан.Сумма Тогда
					Прервать;
				КонецЕсли;			
			КонецЕсли;
		КонецЦикла;
		
		Если СтрокаПлан.Распределено < СтрокаПлан.Сумма Тогда
					
			Распределено = (СтрокаПлан.Сумма - СтрокаПлан.Распределено);
			НоваяСтрока = НовыйГрафик.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаПлан);
			НоваяСтрока.Дата = ?(СтрокаПлан.Дата >= ДатаНачалаКорректировки, СтрокаПлан.Дата, ДатаНачалаКорректировки);
			НоваяСтрока.Сумма = Распределено;
			НоваяСтрока.СуммаРасчет = Распределено;
			НоваяСтрока.Распределено = Распределено;		
		КонецЕсли;			
	КонецЦикла;
	
	// свертка строк
	НовыйГрафик.Колонки.Удалить("НомерСтроки");
	НовыйГрафик.Колонки.Удалить("Распределено");
	НовыйГрафик.ЗаполнитьЗначения(Неопределено, "ИдентификаторПозицииГрафика"); // пересоздадим потом
	ОбщегоНазначенияУХ.СвернутьПоИзмерениям(НовыйГрафик,, "Сумма, СуммаРасчет, СуммаКорректировка");
	
	Для каждого СтрокаГрафика ИЗ НовыйГрафик Цикл
		СтрокаГрафика.ИдентификаторПозицииГрафика = Новый УникальныйИдентификатор;
	КонецЦикла;
	
	НовыйГрафик.Сортировать("Дата");
	
	Возврат НовыйГрафик;
		
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьБазовыеДаты(Знач АлгоритмыБазовыхДат, Знач ДокументОснование)
	
	Результат = Новый Соответствие;
	Для Каждого Алгоритм Из АлгоритмыБазовыхДат Цикл 
		Результат.Вставить(Алгоритм, БазоваяДатаПоАлгоритму(Алгоритм, ДокументОснование));
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Функция возвращает базовую дату по заданному алгоритму на основании некоторых входных данных.
//
// Параметры:
//  Алгоритм			 - СправочникСсылка.АлгоритмыОпределенияБазовойДаты	 - Определяет способ вычисления даты.
//  ДанныеДляРасчетов	 - Произвольный	 - Данные, необходимые для вычисления даты.
// Возвращаемое значение:
//  Дата - Базовая дата.
Функция БазоваяДатаПоАлгоритму(Знач Алгоритм, Знач ДанныеДляРасчетов)
	
	БазоваяДата = Дата(1,1,1);
	Если Алгоритм = Справочники.АлгоритмыОпределенияБазовойДаты.ДатаРасчетногоДокумента Тогда 
		БазоваяДата = ДатаРасчетногоДокумента(ДанныеДляРасчетов);
	ИначеЕсли Алгоритм = Справочники.АлгоритмыОпределенияБазовойДаты.ДатаВходящегоДокумента Тогда
		БазоваяДата = ДатаВходящегоДокумента(ДанныеДляРасчетов);
	КонецЕсли;
	
	РасчетГрафиковОперацийПереопределяемыйУХ.БазоваяДатаПоАлгоритму(БазоваяДата, Алгоритм, ДанныеДляРасчетов);
	
	Возврат БазоваяДата;
	
КонецФункции

Функция ДатаРасчетногоДокумента(ДанныеДляРасчетов)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеДляРасчетов, "Дата");
		
КонецФункции

Функция ДатаВходящегоДокумента(ДанныеДляРасчетов)
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ДатаВходящегоДокумента", ДанныеДляРасчетов.Метаданные()) Тогда 
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеДляРасчетов, "ДатаВходящегоДокумента");
	Иначе 
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеДляРасчетов, "Дата"); 
	КонецЕсли;
	
КонецФункции

Функция ДатаОплаты(БазоваяДата, ЭтапОплаты, ПроизводственныйКалендарь)
	
	КоличествоДней = ЭтапОплаты.Срок;
	
	Если ЭтапОплаты.ВариантОплаты = Перечисления.ВариантыОплаты.Аванс Тогда 
		КоличествоДней = -КоличествоДней;
	КонецЕсли;
	
	Возврат ДатаОтБазовойДатыСоСдвигом(БазоваяДата, КоличествоДней, ЭтапОплаты.ТипСрока, ПроизводственныйКалендарь);
	
КонецФункции

Функция БазоваяСумма(ДанныеДляРасчетов)
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаДокумента", ДанныеДляРасчетов.Метаданные()) Тогда 
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеДляРасчетов, "СуммаДокумента");
	Иначе 
		Возврат 0;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
