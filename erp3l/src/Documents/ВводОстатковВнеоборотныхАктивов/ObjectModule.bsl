#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковВзаиморасчетовПоДоговорамАренды Тогда
		ТаблицаКопирования = РасчетыПоДоговорамАренды.Выгрузить();
		ТаблицаКопирования.ЗаполнитьЗначения(Неопределено, "ДокументАванса");
		РасчетыПоДоговорамАренды.Загрузить(ТаблицаКопирования);
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Запрос = Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	(ВЫРАЗИТЬ(НМАДанныеДокумента.НомерСтроки КАК ЧИСЛО)) - 1 КАК ИндексСтроки,
	|	ВЫРАЗИТЬ(НМАДанныеДокумента.НематериальныйАктив КАК Справочник.НематериальныеАктивы) КАК НематериальныйАктив,
	|	ВЫРАЗИТЬ(НМАДанныеДокумента.НачислятьАмортизациюНУ КАК БУЛЕВО) КАК НачислятьАмортизациюНУ,
	|	ВЫРАЗИТЬ(НМАДанныеДокумента.ПорядокСписанияНИОКРНаРасходыНУ КАК Перечисление.ПорядокСписанияНИОКРНУ) КАК ПорядокСписанияНИОКРНаРасходыНУ
	|ПОМЕСТИТЬ НМАДанныеДокумента
	|ИЗ
	|	&НМАДанныеДокумента КАК НМАДанныеДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НМАДанныеДокумента.ИндексСтроки КАК ИндексСтроки,
	|	НЕ НМАДанныеДокумента.НачислятьАмортизациюНУ КАК НачислятьАмортизациюНУ
	|ИЗ
	|	НМАДанныеДокумента КАК НМАДанныеДокумента
	|ГДЕ
	|	НМАДанныеДокумента.НематериальныйАктив.ВидОбъектаУчета = ЗНАЧЕНИЕ(Перечисление.ВидыОбъектовУчетаНМА.РасходыНаНИОКР)
	|	И ВЫБОР
	|			КОГДА НМАДанныеДокумента.ПорядокСписанияНИОКРНаРасходыНУ = ЗНАЧЕНИЕ(Перечисление.ПорядокСписанияНИОКРНУ.Равномерно)
	|				ТОГДА НЕ НМАДанныеДокумента.НачислятьАмортизациюНУ
	|			ИНАЧЕ НМАДанныеДокумента.НачислятьАмортизациюНУ
	|		КОНЕЦ";
	Запрос.УстановитьПараметр("НМАДанныеДокумента", НМА.Выгрузить(, "НомерСтроки, НематериальныйАктив, НачислятьАмортизациюНУ, ПорядокСписанияНИОКРНаРасходыНУ"));
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			НМА[Выборка.ИндексСтроки].НачислятьАмортизациюНУ = Выборка.НачислятьАмортизациюНУ;
		КонецЦикла;
	КонецЕсли;
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковОсновныхСредств
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковПереданныхВАрендуОС
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковАрендованныхОСЗаБалансом
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковАрендованныхОСНаБалансе
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковПереданныхВАрендуПредметовЛизингаНаБалансе
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковПредметовЛизингаЗаБалансом Тогда
		
		ОС.Очистить();
	Иначе
		Для Каждого Строка Из ОС Цикл
			ОчиститьНеИспользуемыеРеквизитыОС(Строка);
		КонецЦикла;
	КонецЕсли;
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковНМАиРасходовНаНИОКР Тогда
		НМА.Очистить();
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковВзаиморасчетовПоДоговорамАренды Тогда
		ЗаполнитьЗависимыеРеквизитыРасчетовПоДоговорамЛизинга();
		СоздатьУдалитьДокументыАвансовПередЗаписью();
	Иначе
		РасчетыПоДоговорамАренды.Очистить();
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	

	ПараметрыУчетнойПолитики = НастройкиНалоговУчетныхПолитикПовтИсп.ДействующиеПараметрыНалоговУчетныхПолитик("НастройкиУчетаНДС",
			Организация,
			Дата);
	РаздельныйУчетВНАПоНалогообложениюНДС = ПараметрыУчетнойПолитики <> Неопределено И ПараметрыУчетнойПолитики.РаздельныйУчетВНАПоНалогообложениюНДС;
	
	Если НЕ РаздельныйУчетВНАПоНалогообложениюНДС
		И (ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковОсновныхСредств
			Или ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковАрендованныхОСНаБалансе) Тогда
			
		ПараметрыУчетаПоОрганизации = УчетНДСУП.ПараметрыУчетаПоОрганизации(Организация, Дата);
		
		ЗначенияЗаполнения.Вставить("ВариантРаздельногоУчетаНДС", Перечисления.ВариантыРаздельногоУчетаНДС.ИзДокумента);
		ЗначенияЗаполнения.Вставить("НалогообложениеНДС", ПараметрыУчетаПоОрганизации.ОсновнойВидДеятельностиНДСЗакупки);
		
	КонецЕсли;
	
	Для Каждого Строка Из ОС Цикл
		Если ЗначенияЗаполнения.Количество() <> 0 Тогда
			ЗаполнитьЗначенияСвойств(Строка, ЗначенияЗаполнения);
		КонецЕсли;
		
		Если Строка.ПорядокУчетаБУ <> Перечисления.ПорядокПогашенияСтоимостиОС.НачислениеАмортизации Тогда
			
			Строка.МетодНачисленияАмортизацииБУ = Неопределено;
			Строка.КоэффициентУскоренияБУ = 0;
			Если Строка.ПорядокУчетаБУ <> Перечисления.ПорядокПогашенияСтоимостиОС.НачислениеИзносаПоЕНАОФ Тогда
				Строка.НачислятьАмортизациюБУ = Ложь;
				Строка.СрокИспользованияБУ = 0;
				Строка.КоэффициентАмортизацииБУ = 0;
			КонецЕсли;
			
			Строка.СтатьяРасходовАмортизации = Неопределено;
			Строка.АналитикаРасходовАмортизации = Неопределено;
			Строка.ПередаватьРасходыВДругуюОрганизацию = Ложь;
			Строка.ОрганизацияПолучательРасходов = Неопределено;
			Строка.СчетПередачиРасходов = Неопределено;
			
		КонецЕсли;
		
		Если Строка.ПорядокУчетаНУ <> Перечисления.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.НачислениеАмортизации Тогда
			Строка.НачислятьАмортизациюНУ = Ложь;
			
			Строка.СтатьяРасходовАмортизационнойПремии = Неопределено;
			Строка.АналитикаРасходовАмортизационнойПремии = Неопределено;
			Строка.ВключитьАмортизационнуюПремиюВСоставРасходов = Ложь;
			Строка.СуммаКапитальныхВложенийВключаемыхВРасходыНУ = 0;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковВзаиморасчетовПоДоговорамАренды Тогда
		СоздатьУдалитьДокументыАвансовПриЗаписи();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Ложь, Отказ);
	
	МассивНепроверяемыхРеквизитов.Добавить("РасчетыПоДоговорамАренды.СуммаРегл");
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковАрендованныхОСЗаБалансом
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковПредметовЛизингаЗаБалансом Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОС.Контрагент");
	КонецЕсли;
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковПредметовЛизингаЗаБалансом Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОС.Договор");
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковОсновныхСредств
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковПереданныхВАрендуОС
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковПереданныхВАрендуОС
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАрендованныхОСНаБалансе
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковПереданныхВАрендуПредметовЛизингаНаБалансе
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковПредметовЛизингаЗаБалансом Тогда
		
		ВнеоборотныеАктивы.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", "ОсновноеСредство", Отказ);
		
		ПроверкаТабличнойЧастиОС(Отказ);
		
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ОС");
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковНМАиРасходовНаНИОКР Тогда
		
		ВнеоборотныеАктивы.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "НМА", "НематериальныйАктив", Отказ);
		
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("НМА");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("РасчетыПоДоговорамАренды.СуммаРегл");
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковВзаиморасчетовПоДоговорамАренды Тогда
		ПроверкаТабличнойЧастиРасчетовПоДоговорамЛизинга(Отказ);
		
		МассивНепроверяемыхРеквизитов.Добавить("Подразделение");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыПоДоговорамАренды");
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатковВнеоборотныхАктивов.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	Если Не Отказ Тогда
		РеглУчетПроведениеСервер.ОтразитьДокумент(Новый Структура("Ссылка, Дата, Организация", Ссылка, Дата));
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
КонецПроцедуры

Процедура ПроверкаТабличнойЧастиОС(Отказ)
	
	Для Каждого Строка Из ОС Цикл 
		
		Если Строка.ПорядокУчетаНУ = Перечисления.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.ВключениеВРасходыПриПринятииКУчету  Тогда
			
			// Запрет некоторых движений если ОС списано при принятии
			Если Строка.НачислятьАмортизациюНУ Тогда
				Отказ = Истина;
				СтрокаСообщение = НСтр("ru = '(НУ) по ОС не может начисляться амортизация, если оно списано на затраты при принятии к учету';
										|en = '(TA) FA depreciation cannot be accrued if it is written off as expenses on recognition'");
				ОбщегоНазначения.СообщитьПользователю(СтрокаСообщение);
				Прервать;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Строка.НакопленнаяАмортизацияНУ) Тогда
				Отказ = Истина;
				СтрокаСообщение = НСтр("ru = '(НУ) накопленная амортизация по ОС должна быть равна 0, если оно списано на затраты при принятии к учету';
										|en = '(TA) accumulated FA depreciation should be equal to 0 if it is written off as costs on recognition'");
				ОбщегоНазначения.СообщитьПользователю(СтрокаСообщение);
				Прервать;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Строка.ТекущаяСтоимостьНУ) Тогда
				Отказ = Истина;
				СтрокаСообщение = НСтр("ru = '(НУ) текущая стоимость ОС должна быть равна 0, если оно списано на затраты при принятии к учету';
										|en = '(TA) current FA value should be equal to 0 if it is written off as costs on recognition'");
				ОбщегоНазначения.СообщитьПользователю(СтрокаСообщение);
				Прервать;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверкаТабличнойЧастиРасчетовПоДоговорамЛизинга(Отказ)
	
	РеквизитыДоговоров = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(РасчетыПоДоговорамАренды.ВыгрузитьКолонку("Договор"), "ВалютаВзаиморасчетов");
	
	ВалютаРегУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	
	Для Каждого Строка Из РасчетыПоДоговорамАренды Цикл
		
		Если РеквизитыДоговоров.Получить(Строка.Договор).ВалютаВзаиморасчетов = ВалютаРегУчета Тогда
			Строка.СуммаРегл = Строка.Сумма;
		ИначеЕсли Не ЗначениеЗаполнено(Строка.СуммаРегл) Тогда
			ТекстОшибки = НСтр("ru = 'Не заполнено поле ""Сумма (регл.)"" в строке %НомерСтроки% списка ""Расчеты по договорам лизинга""';
								|en = '""Amount (compl.)"" in line %НомерСтроки% of list ""Lease agreement settlements"" is required'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", Строка.НомерСтроки);
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("РасчетыПоДоговорамАренды", Строка.НомерСтроки, "СуммаРегл"),
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьЗависимыеРеквизитыРасчетовПоДоговорамЛизинга()
	
	ВалютаРегл = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	ВалютыДоговоров = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(
		РасчетыПоДоговорамАренды.ВыгрузитьКолонку("Договор"),
		"ВалютаВзаиморасчетов");
	ВалютыДоговоров.Вставить(Справочники.ДоговорыАренды.ПустаяСсылка(), ВалютаРегл);
	
	Для Каждого Строка Из РасчетыПоДоговорамАренды Цикл
		Если ВалютыДоговоров[Строка] = ВалютаРегл Тогда
			Строка.СуммаРегл = Строка.Сумма;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьУдалитьДокументыАвансовПередЗаписью()
	
	СвойстваДокумента = ПроведениеДокументов.СвойстваДокумента(ЭтотОбъект);
	
	Если СвойстваДокумента.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗначенияРеквизитов = Новый Структура;
	ЗначенияРеквизитов.Вставить("Организация", Организация);
	ЗначенияРеквизитов.Вставить("Дата", Дата);
	ЗначенияРеквизитов.Вставить("ДатаПроведенияБанком", Дата);
	ЗначенияРеквизитов.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ОплатаАрендодателю);
	ЗначенияРеквизитов.Вставить("ТипПлатежаПоАренде", Перечисления.ТипыПлатежейПоАренде.ОбеспечительныйПлатеж);
	ЗначенияРеквизитов.Вставить("ПроведеноБанком", Истина);
	
	Запрос = Новый Запрос;
	Для Каждого КлючИЗначение Из ЗначенияРеквизитов Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("ВалютаРегл", ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация));
	Запрос.УстановитьПараметр("УдалитьСозданные", (СвойстваДокумента.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения));
	Запрос.УстановитьПараметр("ТаблицаДокумента", РасчетыПоДоговорамАренды.Выгрузить(, "НомерСтроки, Контрагент, Договор, Сумма, СуммаРегл, ТипЗадолженности, ДокументАванса"));
	#Область ТекстЗапроса
	Запрос.Текст =
	"ВЫБРАТЬ
	|	(ВЫРАЗИТЬ(Т.НомерСтроки КАК ЧИСЛО)) - 1 КАК ИндексСтроки,
	|	ВЫРАЗИТЬ(Т.Контрагент КАК Справочник.Контрагенты) КАК Контрагент,
	|	ВЫРАЗИТЬ(Т.Договор КАК Справочник.ДоговорыАренды) КАК Договор,
	|	ВЫРАЗИТЬ(Т.ТипЗадолженности КАК Перечисление.ТипыПлатежейПоАренде) КАК ТипЗадолженности,
	|	ВЫРАЗИТЬ(Т.Сумма КАК ЧИСЛО) КАК Сумма,
	|	ВЫРАЗИТЬ(Т.СуммаРегл КАК ЧИСЛО) КАК СуммаРегл,
	|	ВЫРАЗИТЬ(Т.ДокументАванса КАК Документ.СписаниеБезналичныхДенежныхСредств) КАК ДокументАванса
	|ПОМЕСТИТЬ втТаблицаДокумента
	|ИЗ
	|	&ТаблицаДокумента КАК Т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписаниеБезналичныхДенежныхСредств.Ссылка КАК Ссылка
	|ИЗ
	|	втТаблицаДокумента КАК втТаблицаДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СписаниеБезналичныхДенежныхСредств КАК СписаниеБезналичныхДенежныхСредств
	|		ПО втТаблицаДокумента.ДокументАванса = СписаниеБезналичныхДенежныхСредств.Ссылка
	|ГДЕ
	|	НЕ СписаниеБезналичныхДенежныхСредств.ПометкаУдаления
	|	И (&УдалитьСозданные
	|			ИЛИ втТаблицаДокумента.ТипЗадолженности <> ЗНАЧЕНИЕ(Перечисление.ТипыПлатежейПоАренде.ОбеспечительныйПлатеж))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СписаниеБезналичныхДенежныхСредств.Ссылка
	|ИЗ
	|	Документ.ВводОстатковВнеоборотныхАктивов.РасчетыПоДоговорамАренды КАК Т
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СписаниеБезналичныхДенежныхСредств КАК СписаниеБезналичныхДенежныхСредств
	|		ПО Т.ДокументАванса = СписаниеБезналичныхДенежныхСредств.Ссылка
	|ГДЕ
	|	Т.Ссылка = &Ссылка
	|	И НЕ Т.ДокументАванса В
	|				(ВЫБРАТЬ
	|					втТаблицаДокумента.ДокументАванса
	|				ИЗ
	|					втТаблицаДокумента КАК втТаблицаДокумента)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втТаблицаДокумента.ИндексСтроки,
	|	втТаблицаДокумента.Контрагент,
	|	втТаблицаДокумента.Договор,
	|	втТаблицаДокумента.Сумма,
	|	втТаблицаДокумента.СуммаРегл,
	|	втТаблицаДокумента.ДокументАванса,
	|	ВЫБОР
	|		КОГДА втТаблицаДокумента.Договор.ВалютаВзаиморасчетов = &ВалютаРегл
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ДоговорВВалютеРегл,
	|	втТаблицаДокумента.Договор.ВалютаВзаиморасчетов КАК Валюта
	|ПОМЕСТИТЬ втЗначимыеСтроки
	|ИЗ
	|	втТаблицаДокумента КАК втТаблицаДокумента
	|ГДЕ
	|	втТаблицаДокумента.ТипЗадолженности = ЗНАЧЕНИЕ(Перечисление.ТипыПлатежейПоАренде.ОбеспечительныйПлатеж)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Дата,
	|	Операция.Контрагент КАК Контрагент,
	|	Операция.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	Операция.Организация КАК Организация,
	|	Операция.СуммаДокумента КАК СуммаДокумента,
	|	Операция.Валюта КАК Валюта,
	|	ТабличнаяЧасть.Договор КАК Договор,
	|	ТабличнаяЧасть.ТипПлатежаПоАренде КАК ТипПлатежаПоАренде,
	|	ТабличнаяЧасть.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	СуммыДокументовВВалютахУчета.СуммаБезНДСРегл КАК СуммаБезНДСРегл,
	|	Операция.Проведен КАК Проведен,
	|	Операция.ПроведеноБанком КАК ПроведеноБанком,
	|	Операция.ПометкаУдаления КАК ПометкаУдаления
	|ПОМЕСТИТЬ втДанныеДокументов
	|ИЗ
	|	втЗначимыеСтроки КАК втЗначимыеСтроки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СписаниеБезналичныхДенежныхСредств КАК Операция
	|		ПО втЗначимыеСтроки.ДокументАванса = Операция.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СписаниеБезналичныхДенежныхСредств.РасшифровкаПлатежа КАК ТабличнаяЧасть
	|		ПО втЗначимыеСтроки.ДокументАванса = ТабличнаяЧасть.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СуммыДокументовВВалютахУчета КАК СуммыДокументовВВалютахУчета
	|		ПО (НЕ втЗначимыеСтроки.ДоговорВВалютеРегл)
	|			И (ТабличнаяЧасть.Ссылка = СуммыДокументовВВалютахУчета.Регистратор)
	|			И (ТабличнаяЧасть.ИдентификаторСтроки = СуммыДокументовВВалютахУчета.ИдентификаторСтроки)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА втДанныеДокументов.Ссылка ЕСТЬ NULL 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СоздатьДокумент,
	|	втЗначимыеСтроки.ДокументАванса КАК ДокументАванса,
	|	втЗначимыеСтроки.Контрагент КАК Контрагент,
	|	втЗначимыеСтроки.Договор КАК Договор,
	|	втЗначимыеСтроки.ДоговорВВалютеРегл КАК ДоговорВВалютеРегл,
	|	втЗначимыеСтроки.Валюта КАК Валюта,
	|	втЗначимыеСтроки.Сумма КАК СуммаДокумента,
	|	втЗначимыеСтроки.Сумма КАК Сумма,
	|	втЗначимыеСтроки.Сумма КАК СуммаВзаиморасчетов,
	|	втЗначимыеСтроки.Валюта КАК ВалютаВзаиморасчетов,
	|	ИСТИНА КАК ПроведеноБанком,
	|	&Дата КАК Период,
	|	втЗначимыеСтроки.Сумма КАК СуммаБезНДС,
	|	втЗначимыеСтроки.СуммаРегл КАК СуммаБезНДСРегл,
	|	втЗначимыеСтроки.ИндексСтроки
	|ИЗ
	|	втЗначимыеСтроки КАК втЗначимыеСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ втДанныеДокументов КАК втДанныеДокументов
	|		ПО втЗначимыеСтроки.ДокументАванса = втДанныеДокументов.Ссылка
	|ГДЕ
	|	(втДанныеДокументов.Ссылка ЕСТЬ NULL 
	|			ИЛИ НЕ втДанныеДокументов.Проведен
	|			ИЛИ втДанныеДокументов.ПометкаУдаления
	|			ИЛИ втДанныеДокументов.Дата <> &Дата
	|			ИЛИ втДанныеДокументов.ХозяйственнаяОперация <> &ХозяйственнаяОперация
	|			ИЛИ втДанныеДокументов.Организация <> &Организация
	|			ИЛИ втДанныеДокументов.ПроведеноБанком <> &ПроведеноБанком
	|			ИЛИ втДанныеДокументов.Контрагент <> втЗначимыеСтроки.Контрагент
	|			ИЛИ втДанныеДокументов.Договор <> втЗначимыеСтроки.Договор
	|			ИЛИ втДанныеДокументов.Валюта <> втЗначимыеСтроки.Валюта
	|			ИЛИ втДанныеДокументов.СуммаДокумента <> втЗначимыеСтроки.Сумма
	|			ИЛИ втДанныеДокументов.СуммаБезНДСРегл <> втЗначимыеСтроки.СуммаРегл
	|			ИЛИ втДанныеДокументов.ТипПлатежаПоАренде <> &ТипПлатежаПоАренде)";
	#КонецОбласти
	
	ПоляДокументаАванса = "СоздатьДокумент, ДокументАванса,
	|Организация, Дата, ДатаПроведенияБанком, Период, ХозяйственнаяОперация, ТипПлатежаПоАренде, ПроведеноБанком,
	|Контрагент, Договор, ДоговорВВалютеРегл, Валюта, ВалютаВзаиморасчетов,
	|СуммаДокумента, Сумма, СуммаБезНДС, СуммаБезНДСРегл, СуммаВзаиморасчетов,
	|Комментарий";
	
	Пакет = Запрос.ВыполнитьПакет();
	
	// Удаление не используемых документов аванса
	Выборка = Пакет[1].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		// Пометить на удаление документ аванса
		ОбъектДокумента = Выборка.Ссылка.ПолучитьОбъект();
		ОбъектДокумента.ПометкаУдаления = Истина;
		ОбъектДокумента.Проведен = Ложь;
		ОбъектДокумента.Записать(РежимЗаписиДокумента.Запись);
		
		// Стереть записи в регистре сумм в валюте регл. учета
		НаборЗаписей = РегистрыСведений.СуммыДокументовВВалютахУчета.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Ссылка);
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
	МассивОбновляемыхДокументов = Новый Массив;
	Выборка = Пакет[4].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		РеквизитыДокументаАванса = Новый Структура(ПоляДокументаАванса);
		ЗаполнитьЗначенияСвойств(РеквизитыДокументаАванса, ЗначенияРеквизитов);
		ЗаполнитьЗначенияСвойств(РеквизитыДокументаАванса, Выборка);
		
		Если Выборка.СоздатьДокумент Тогда
			РеквизитыДокументаАванса.ДокументАванса = Документы.СписаниеБезналичныхДенежныхСредств.ПолучитьСсылку();
			РасчетыПоДоговорамАренды[Выборка.ИндексСтроки].ДокументАванса = РеквизитыДокументаАванса.ДокументАванса;
		КонецЕсли;
		
		МассивОбновляемыхДокументов.Добавить(РеквизитыДокументаАванса);
		
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("МассивОбновляемыхДокументов", МассивОбновляемыхДокументов);
	
КонецПроцедуры

Процедура СоздатьУдалитьДокументыАвансовПриЗаписи()
	
	Если ПроведениеДокументов.СвойстваДокумента(ЭтотОбъект).РежимЗаписи = РежимЗаписиДокумента.Запись
		Или Не ДополнительныеСвойства.Свойство("МассивОбновляемыхДокументов") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	КомментарийДокументаАванса = НСтр("ru = 'Создан автоматически при вводе начальных остатков взаиморасчетов по договору лизинга документом ""%1"". Используется для формирования счетов-фактур на аванс по обеспечительному платежу.';
										|en = 'Created automatically while entering start balance of mutual settlements under the lease agreement with the ""%1"" document. Used to generate advance payment tax invoices of a security payment.'");
	КомментарийДокументаАванса = СтрШаблон(КомментарийДокументаАванса, ЭтотОбъект.Ссылка);
	
	Для Каждого ОписаниеДокумента Из ДополнительныеСвойства.МассивОбновляемыхДокументов Цикл
		
		ОбъектДокумента = Неопределено;
		Если ОписаниеДокумента.СоздатьДокумент Тогда
			ОбъектДокумента = Документы.СписаниеБезналичныхДенежныхСредств.СоздатьДокумент();
			ОбъектДокумента.УстановитьСсылкуНового(ОписаниеДокумента.ДокументАванса);
		Иначе
			ОбъектДокумента = ОписаниеДокумента.ДокументАванса.ПолучитьОбъект();
			
		КонецЕсли;
		
		ОбъектДокумента.Проведен = Истина;
		ОбъектДокумента.ПометкаУдаления = Ложь;
		ЗаполнитьЗначенияСвойств(ОбъектДокумента, ОписаниеДокумента);
		
		ОбъектДокумента.РасшифровкаПлатежа.Очистить();
		СтрокаРасшифровки = ОбъектДокумента.РасшифровкаПлатежа.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, ОписаниеДокумента);
		СтрокаРасшифровки.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
		
		ОбъектДокумента.Комментарий = КомментарийДокументаАванса;
		
		ОбъектДокумента.Записать(РежимЗаписиДокумента.Запись);
		
		НаборЗаписей = РегистрыСведений.СуммыДокументовВВалютахУчета.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(ОбъектДокумента.Ссылка);
		Если Не ОписаниеДокумента.ДоговорВВалютеРегл Тогда
			СтрокаНабора = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНабора, ОписаниеДокумента);
			СтрокаНабора.Регистратор = ОбъектДокумента.Ссылка;
		КонецЕсли;
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОчиститьНеИспользуемыеРеквизитыОС(Описание)
	
	Если Не Описание.ПрименениеЦелевогоФинансирования Тогда
		Описание.СчетУчетаЦФ = Неопределено;
		Описание.СчетАмортизацииЦФ = Неопределено;
		Описание.СтатьяДоходов = Неопределено;
		Описание.АналитикаДоходов = Неопределено;
		
		Описание.ТекущаяСтоимостьБУЦФ = 0;
		Описание.ТекущаяСтоимостьНУЦФ = 0;
		Описание.ТекущаяСтоимостьПРЦФ = 0;
		
		Описание.НакопленнаяАмортизацияБУЦФ = 0;
		Описание.НакопленнаяАмортизацияНУЦФ = 0;
		Описание.НакопленнаяАмортизацияПРЦФ = 0;
	КонецЕсли;
	
	Если Описание.ПорядокУчетаБУ = Перечисления.ПорядокПогашенияСтоимостиОС.СтоимостьНеПогашается
		И Описание.ПорядокУчетаНУ = Перечисления.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.СтоимостьНеВключаетсяВРасходы Тогда
		
		Описание.СчетАмортизации = Неопределено;
		
		Описание.НакопленнаяАмортизацияБУ = 0;
		Описание.НакопленнаяАмортизацияНУ = 0;
		Описание.НакопленнаяАмортизацияПР = 0;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли