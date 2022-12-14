#Область ПрограммныйИнтерфейс

// Функция возвращает дату, которая отличается указанной даты на количество дней,
// входящих в указанный график.
//
// Параметры:
//	ГрафикРаботы	- график (или производственный календарь), который необходимо использовать, 
//		тип СправочникСсылка.ПроизводственныеКалендари, либо массив соответствующих элементов.
//	ДатаОт			- дата, от которой нужно рассчитать количество дней, тип Дата.
//	КоличествоДней	- количество дней, на которые нужно увеличить либо уменьшить дату начала, тип Число.
//	ВызыватьИсключение - булево, если Истина вызывается исключение в случае незаполненного графика.
//  ДопустимыеДниНедели - массив допустимых дней недели (число дня в неделе) на которые можно перемещать дату (используется в платежном каленндаре для платежных дней недели) (реализовано только для производственного календаря)
//
// Возвращаемое значение
//	Дата			- дата, увеличенная на количество дней, входящих в график.
//	Если выбранный график не заполнен, и ВызыватьИсключение = Ложь, возвращается Неопределено.
//
Функция ПолучитьДатуПоКалендарю(Знач ГрафикРаботы, Знач ДатаОт, Знач КоличествоДней, ВызыватьИсключение = Истина, ДопустимыеДниНедели = Неопределено) Экспорт
	
	Если КоличествоДней >= 0 И ТипЗнч(ГрафикРаботы) = Тип("СправочникСсылка.ПроизводственныеКалендари") Тогда
		// Это стандартный случай, поддерживаемый БСП. Вызовем стандартную функцию.
		Возврат ДатаПоКалендарю(ГрафикРаботы, ДатаОт, КоличествоДней, ВызыватьИсключение, ДопустимыеДниНедели);
	КонецЕсли;
	
	ДатаОт = НачалоДня(ДатаОт);
	
	Если КоличествоДней = 0 Тогда
		Возврат ДатаОт;
	КонецЕсли;
	
	Если ДопустимыеДниНедели = Неопределено Тогда
		ДопустимыеДниНедели = ВсеПлатежныеДниНедели();
	КонецЕсли;
		
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Даты.Дата КАК Дата
	|ИЗ
	|	(ВЫБРАТЬ ПЕРВЫЕ %КОЛИЧЕСТВОДНЕЙ%
	|		КалендарныеГрафики.Дата КАК Дата
	|	ИЗ
	|		РегистрСведений.ДанныеПроизводственногоКалендаря КАК КалендарныеГрафики
	|	ГДЕ
	|		КалендарныеГрафики.ПроизводственныйКалендарь В (&ГрафикРаботы)
	|		И КалендарныеГрафики.ВидДня В (ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий), ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный))
	|		И ДЕНЬНЕДЕЛИ(КалендарныеГрафики.Дата) В (&ДопустимыеДниНедели)
	|		И КалендарныеГрафики.Дата %ЗНАКСРАВНЕНИЯ% &Дата 
	|	//%ГРУППИРОВКА%
	|	
	|	УПОРЯДОЧИТЬ ПО
	|		Дата //%ПОРЯДОКСОРТИРОВКИВНУТРЕННИЙ%
	|	) КАК Даты
	|
	|УПОРЯДОЧИТЬ ПО
	|	Даты.Дата //%ПОРЯДОКСОРТИРОВКИВНЕШНИЙ%";
	
	Если ТипЗнч(ГрафикРаботы) = Тип("Массив") Тогда
		ТекстГруппировки = 
		"СГРУППИРОВАТЬ ПО
		|		КалендарныеГрафики.Дата
		|	ИМЕЮЩИЕ
		|		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ КалендарныеГрафики.ПроизводственныйКалендарь) = " + ГрафикРаботы.Количество();
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "//%ГРУППИРОВКА%", ТекстГруппировки);
	КонецЕсли;
	
	Если КоличествоДней > 0 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ЗНАКСРАВНЕНИЯ%", " > ");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "//%ПОРЯДОКСОРТИРОВКИВНЕШНИЙ%", "УБЫВ");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ЗНАКСРАВНЕНИЯ%", " < ");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "//%ПОРЯДОКСОРТИРОВКИВНУТРЕННИЙ%", "УБЫВ");
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%КОЛИЧЕСТВОДНЕЙ%", ?(КоличествоДней>0, КоличествоДней, -КоличествоДней));
	
	Запрос.УстановитьПараметр("ГрафикРаботы", ГрафикРаботы);
	Запрос.УстановитьПараметр("Дата", ДатаОт);
	Запрос.УстановитьПараметр("ДопустимыеДниНедели", ДопустимыеДниНедели);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Дата;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция БлижайшийРабочийДеньДо(знач ГрафикРаботы, знач ДатаОт, знач ДатаДо, знач ДопустимыеДниНедели = Неопределено) Экспорт
	
	Если ДопустимыеДниНедели = Неопределено Тогда
		ДопустимыеДниНедели = ВсеПлатежныеДниНедели();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕстьNULL(МАКСИМУМ(КалендарныеГрафики.Дата), Неопределено) КАК ДатаГрафика
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.ПроизводственныйКалендарь = &ГрафикРаботы
	|	И КалендарныеГрафики.ВидДня В (ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий), ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный))
	|	И КалендарныеГрафики.Дата МЕЖДУ &ДатаОт И &ДатаДо
	|	И ДЕНЬНЕДЕЛИ(КалендарныеГрафики.Дата) В (&ДопустимыеДниНедели)";
	
	Запрос.УстановитьПараметр("ГрафикРаботы", ГрафикРаботы);
	Запрос.УстановитьПараметр("ДатаОт", ДатаОт);
	Запрос.УстановитьПараметр("ДатаДо", ДатаДо);
	Запрос.УстановитьПараметр("ДопустимыеДниНедели", ДопустимыеДниНедели);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ДатаГрафика;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция БлижайшийРабочийДень(Знач ПроизводственныйКалендарь, ДатаОперации, Знач СпособПереносаОпераций) Экспорт
	
	РезультатФункции = ДатаОперации;
	
	Если ЗначениеЗаполнено(СпособПереносаОпераций) И СпособПереносаОпераций <> Перечисления.СпособыПереносаОперацийСНерабочегоДня.НеПереносить Тогда
		
		Если НЕ ЗначениеЗаполнено(ПроизводственныйКалендарь) Тогда
			ПроизводственныйКалендарь = Константы.ПроизводственныйКалендарьПоУмолчанию.Получить();
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ДанныеПроизводственногоКалендаря.Дата КАК Дата
			|ИЗ
			|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
			|ГДЕ
			|	ДанныеПроизводственногоКалендаря.Дата <= &ДатаНач
			|	И ДанныеПроизводственногоКалендаря.ВидДня В (ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий), ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный))
			|	И ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь В (&ПроизводственныйКалендарь)
			|   СГРУППИРОВАТЬ ПО
			|		ДанныеПроизводственногоКалендаря.Дата
			|	ИМЕЮЩИЕ
			|		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь) = &КоличествоКалендарей
			|УПОРЯДОЧИТЬ ПО
			|	ДанныеПроизводственногоКалендаря.Дата УБЫВ";
		
		Если СпособПереносаОпераций = Перечисления.СпособыПереносаОперацийСНерабочегоДня.СледующийРабочийДень
			ИЛИ СпособПереносаОпераций = Перечисления.СпособыПереносаОперацийСНерабочегоДня.СледующийРабочийДеньВПериоде Тогда
				
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "<=", ">=");
			Запрос.Текст = СтрЗаменить(Запрос.Текст, " УБЫВ", "");
			
		КонецЕсли;
		
		Запрос.УстановитьПараметр("ДатаНач", ДатаОперации);
		Запрос.УстановитьПараметр("ПроизводственныйКалендарь", ПроизводственныйКалендарь);
		Если ТипЗнч(ПроизводственныйКалендарь) = Тип("СправочникСсылка.ПроизводственныеКалендари") Тогда
			
			КоличествоКалендарей = 1;
		Иначе
			КоличествоКалендарей = ПроизводственныйКалендарь.Количество();
			
		КонецЕсли;
		Запрос.УстановитьПараметр("КоличествоКалендарей", КоличествоКалендарей);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			РезультатФункции = Выборка.Дата;
			
			Если СпособПереносаОпераций = Перечисления.СпособыПереносаОперацийСНерабочегоДня.СледующийРабочийДеньВПериоде
				ИЛИ СпособПереносаОпераций = Перечисления.СпособыПереносаОперацийСНерабочегоДня.ПредыдущийРабочийДеньВПериоде Тогда
				
				Если Месяц(РезультатФункции) <> Месяц(ДатаОперации) Тогда
					РезультатФункции = ДатаОперации;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат РезультатФункции;
	
КонецФункции // ПолучитьРабочийДень()

// Возвращает дату, которая отличается указанной даты ДатаОт на количество дней,
// входящих в указанный график или производственный календарь ГрафикРаботы.
//
// Параметры:
//	 ГрафикРаботы	- СправочникСсылка.Календари, СправочникСсылка.ПроизводственныеКалендари - график или 
//                    производственный календарь, который необходимо использовать для расчета даты.
//	 ДатаОт			- Дата - дата, от которой нужно рассчитать количество дней.
//	 КоличествоДней	- Число - количество дней, на которые нужно увеличить дату начала.
//	 ВызыватьИсключение - Булево - если Истина, вызвать исключение в случае незаполненного графика.
//   ДопустимыеДниНедели - массив допустимых дней недели (число дня в неделе) на которые можно перемещать дату (используется в платежном календаре для платежных дней недели) (реализовано только для производственного календаря)
//
// Возвращаемое значение:
//	 Дата, Неопределено - дата, увеличенная на количество дней, входящих в график.
//	                      Если выбранный график не заполнен, и ВызыватьИсключение = Ложь, возвращается Неопределено.
//
Функция ДатаПоКалендарю(Знач ГрафикРаботы, Знач ДатаОт, Знач КоличествоДней, ВызыватьИсключение = Истина, ДопустимыеДниНедели = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ГрафикРаботы) Тогда
		Если ВызыватьИсключение Тогда
			ВызватьИсключение НСтр("ru = 'Не указан график работы или производственный календарь.'");
		КонецЕсли;
		Возврат Неопределено;
	КонецЕсли;
	
	ДатаОт = НачалоДня(ДатаОт);
	
	Если КоличествоДней = 0 Тогда
		Возврат ДатаОт;
	КонецЕсли;
	
	МассивДней = Новый Массив;
	МассивДней.Добавить(КоличествоДней);
	
	МассивДат = ДатыПоКалендарю(ГрафикРаботы, ДатаОт, МассивДней, , ВызыватьИсключение, ДопустимыеДниНедели);
	
	Возврат ?(МассивДат <> Неопределено, МассивДат[0], Неопределено);
	
КонецФункции

Функция ВсеПлатежныеДниНедели()
	
	ДопустимыеДниНедели = Новый Массив;
	
	Для НомерДня = 1 По 7 Цикл
		ДопустимыеДниНедели.Добавить(НомерДня); // все дни недели допустимы
	КонецЦикла;
	
	Возврат ДопустимыеДниНедели;
	
КонецФункции

// Возвращает даты, которые отличаются от указанной даты ДатаОт на количество дней,
// входящих в указанный график ГрафикРаботы.
//
// Параметры:
//	 ГрафикРаботы	- СправочникСсылка.Календари, СправочникСсылка.ПроизводственныеКалендари - график или 
//                    производственный календарь, который необходимо использовать для расчета дат.
//	 ДатаОт			- Дата - дата, от которой нужно рассчитать количество дней.
//	 МассивДней		- Массив - количество дней (Число), на которые нужно увеличить дату начала.
//	 РассчитыватьСледующуюДатуОтПредыдущей	- Булево - нужно ли рассчитывать следующую дату от предыдущей или
//											           все даты рассчитываются от переданной даты.
//	 ВызыватьИсключение - Булево - если Истина, вызвать исключение в случае незаполненного графика.
//   ДопустимыеДниНедели - массив допустимых дней недели (число дня в неделе) на которые можно перемещать дату (используется в платежном календаре для платежных дней недели) (реализовано только для производственного календаря)
//
// Возвращаемое значение:
//	 Неопределено, Массив - массив дат, увеличенных на количество дней, входящих в график,
//	                        Если график ГрафикРаботы не заполнен, и ВызыватьИсключение = Ложь, возвращается Неопределено.
//
Функция ДатыПоКалендарю(Знач ГрафикРаботы, Знач ДатаОт, Знач МассивДней, Знач РассчитыватьСледующуюДатуОтПредыдущей = Ложь, ВызыватьИсключение = Истина, ДопустимыеДниНедели = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ГрафикРаботы) Тогда
		Если ВызыватьИсключение Тогда
			ВызватьИсключение НСтр("ru = 'Не указан график работы или производственный календарь.'");
		КонецЕсли;
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(ГрафикРаботы) <> Тип("СправочникСсылка.ПроизводственныеКалендари") Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрафикиРаботы") Тогда
			МодульГрафикиРаботы = ОбщегоНазначения.ОбщийМодуль("ГрафикиРаботы");
			Возврат МодульГрафикиРаботы.ДатыПоГрафику(
				ГрафикРаботы, ДатаОт, МассивДней, РассчитыватьСледующуюДатуОтПредыдущей, ВызыватьИсключение);
		КонецЕсли;
	КонецЕсли;
	
	Если ДопустимыеДниНедели = Неопределено Тогда
		ДопустимыеДниНедели = ВсеПлатежныеДниНедели();
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТПриращениеДней(МенеджерВременныхТаблиц, МассивДней, РассчитыватьСледующуюДатуОтПредыдущей);
	
	// Алгоритм работает следующим образом:
	// Получаем все дни календаря, следующие после даты отсчета.
	// Для каждого из таких дней рассчитываем количество дней, включенных в график с даты отсчета.
	// Отбираем рассчитанное таким образом количество по таблице приращения дней.
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	// в график добавлена ДатаОт без учета недель, чтобы если заявка попадает на не платежный день при перемещении на один день вперед она попадала на ближайший платежный день (иначе через один попадает)
	
	// По производственному календарю.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КалендарныеГрафики.Дата КАК ДатаГрафика
	|ПОМЕСТИТЬ ВТПоследующиеДатыГрафика
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Дата >= &ДатаОт
	|	И КалендарныеГрафики.ПроизводственныйКалендарь = &ГрафикРаботы
	|	И КалендарныеГрафики.ВидДня В (ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий), ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный))
	|	И ДЕНЬНЕДЕЛИ(КалендарныеГрафики.Дата) В (&ДопустимыеДниНедели)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	КалендарныеГрафики.Дата
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Дата = &ДатаОт
	|	И КалендарныеГрафики.ПроизводственныйКалендарь = &ГрафикРаботы
	|	И КалендарныеГрафики.ВидДня В (ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий), ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоследующиеДатыГрафика.ДатаГрафика КАК ДатаГрафика,
	|	КОЛИЧЕСТВО(КалендарныеГрафики.ДатаГрафика) - 1 КАК КоличествоДнейВключенныхВГрафик
	|ПОМЕСТИТЬ ВТПоследующиеДатыГрафикаСКоличествомДней
	|ИЗ
	|	ВТПоследующиеДатыГрафика КАК ПоследующиеДатыГрафика
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПоследующиеДатыГрафика КАК КалендарныеГрафики
	|		ПО (КалендарныеГрафики.ДатаГрафика <= ПоследующиеДатыГрафика.ДатаГрафика)
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоследующиеДатыГрафика.ДатаГрафика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПриращениеДней.ИндексСтроки КАК ИндексСтроки,
	|	ЕСТЬNULL(ПоследующиеДни.ДатаГрафика, НЕОПРЕДЕЛЕНО) КАК ДатаПоКалендарю
	|ИЗ
	|	ВТПриращениеДней КАК ПриращениеДней
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоследующиеДатыГрафикаСКоличествомДней КАК ПоследующиеДни
	|		ПО ПриращениеДней.КоличествоДней = ПоследующиеДни.КоличествоДнейВключенныхВГрафик
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПриращениеДней.ИндексСтроки";
	
	Запрос.УстановитьПараметр("ДатаОт", НачалоДня(ДатаОт));
	Запрос.УстановитьПараметр("ГрафикРаботы", ГрафикРаботы);
	Запрос.УстановитьПараметр("ДопустимыеДниНедели", ДопустимыеДниНедели);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	МассивДат = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ДатаПоКалендарю = Неопределено Тогда
			СообщениеОбОшибке = НСтр("ru = 'Производственный календарь «%1» не заполнен с даты %2 на указанное количество рабочих дней.'");
			Если ВызыватьИсключение Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ГрафикРаботы, Формат(ДатаОт, "ДЛФ=D"));
			Иначе
				Возврат Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		МассивДат.Добавить(Выборка.ДатаПоКалендарю);
	КонецЦикла;
	
	Возврат МассивДат;
	
КонецФункции

// Создает временную таблицу ВТПриращениеДней, в которой для каждого элемента из МассивДней 
// формируется строка с индексом элемента и значением - количеством дней.
// 
// Параметры:
//	- МенеджерВременныхТаблиц,
//	- МассивДней - массив, количество дней,
//	- РассчитыватьСледующуюДатуОтПредыдущей - необязательный, по умолчанию Ложь.
//
Процедура СоздатьВТПриращениеДней(МенеджерВременныхТаблиц, Знач МассивДней, Знач РассчитыватьСледующуюДатуОтПредыдущей = Ложь) Экспорт
	
	ПриращениеДней = Новый ТаблицаЗначений;
	ПриращениеДней.Колонки.Добавить("ИндексСтроки", Новый ОписаниеТипов("Число"));
	ПриращениеДней.Колонки.Добавить("КоличествоДней", Новый ОписаниеТипов("Число"));
	
	КоличествоДней = 0;
	НомерСтроки = 0;
	Для Каждого СтрокаДней Из МассивДней Цикл
		КоличествоДней = КоличествоДней + СтрокаДней;
		
		Строка = ПриращениеДней.Добавить();
		Строка.ИндексСтроки			= НомерСтроки;
		Если РассчитыватьСледующуюДатуОтПредыдущей Тогда
			Строка.КоличествоДней	= КоличествоДней;
		Иначе
			Строка.КоличествоДней	= СтрокаДней;
		КонецЕсли;
			
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПриращениеДней.ИндексСтроки,
	|	ПриращениеДней.КоличествоДней
	|ПОМЕСТИТЬ ВТПриращениеДней
	|ИЗ
	|	&ПриращениеДней КАК ПриращениеДней";
	
	Запрос.УстановитьПараметр("ПриращениеДней",	ПриращениеДней);
	
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти
