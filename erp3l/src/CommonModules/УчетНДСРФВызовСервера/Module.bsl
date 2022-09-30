
#Область ПрограммныйИнтерфейс

// Получение элемента справочника СтавкиНДС по перечислению СтавкиНДС
//
// Параметры:
//	ПеречислениеСтавкаНДС - ПеречислениеСсылка.СтавкиНДС - Значение ставки НДС.
//	ТипНалогообложенияНДС - ПеречислениеСсылка.ТипыНалогообложенияНДС - Налогообложение НДС, в рамках которого нужно найти ставку. 
//	                                                       Если Неопределено, то ставка получается по налогообложению ПродажаОблагаетсяНДС
// Возвращаемое значение:
//	СправочникСсылка.СтавкиНДС - Соответствующая перечислению ставка НДС.
//
Функция СтавкаНДСПоЗначениюПеречисления(ПеречислениеСтавкаНДС, ТипНалогообложенияНДС = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СтавкиНДС.Ссылка КАК СтавкаНДС
		|ИЗ
		|	Справочник.СтавкиНДС.ТипыНалогообложенияНДС КАК СтавкиНДС
		|ГДЕ
		|	СтавкиНДС.Ссылка.ПеречислениеСтавкаНДС = &ПеречислениеСтавкаНДС
		|	И СтавкиНДС.ТипНалогообложенияНДС = &ТипНалогообложенияНДС
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	СтавкиНДС.Ссылка КАК СтавкаНДС
		|ИЗ
		|	Справочник.СтавкиНДС КАК СтавкиНДС
		|ГДЕ
		|	СтавкиНДС.ПеречислениеСтавкаНДС = &ПеречислениеСтавкаНДС
		|	И &НалогообложениеНеУказано";
	
	Запрос.УстановитьПараметр("ПеречислениеСтавкаНДС", ПеречислениеСтавкаНДС);
	Если ТипНалогообложенияНДС = Неопределено Тогда
		Запрос.УстановитьПараметр("ТипНалогообложенияНДС", Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС);
		Запрос.УстановитьПараметр("НалогообложениеНеУказано", Истина);
	Иначе
		Запрос.УстановитьПараметр("ТипНалогообложенияНДС", ТипНалогообложенияНДС);
		Запрос.УстановитьПараметр("НалогообложениеНеУказано", Ложь);
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.СтавкаНДС
	КонецЕсли;
	
	Возврат Справочники.СтавкиНДС.ПустаяСсылка();
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция СчетФактураПолученныйПоОснованию(ПараметрыРегистрации) Экспорт
	
	Результат = Неопределено;
	Если ПараметрыРегистрации.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя Тогда
		СчетаФактуры = Документы.СчетФактураПолученныйНалоговыйАгент.СчетаФактурыПоОснованию(ПараметрыРегистрации.Ссылка, ПараметрыРегистрации.Организация, Неопределено, Ложь);
	Иначе
		СчетаФактуры = Документы.СчетФактураПолученный.СчетаФактурыПоОснованию(ПараметрыРегистрации.Ссылка, ПараметрыРегистрации.Организация, Неопределено, Ложь);
	КонецЕсли;
	Если СчетаФактуры.Количество() > 0 Тогда
		Результат = СчетаФактуры[0].Ссылка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ИнойДокументПодтвержденияНДСПоОснованию(ПараметрыРегистрации) Экспорт
	
	Результат = Неопределено;
	СчетаФактуры = Документы.ИнойДокументПодтвержденияНДС.СчетаФактурыПоОснованию(ПараметрыРегистрации.Ссылка, ПараметрыРегистрации.Организация, Неопределено, Ложь);
	Если СчетаФактуры.Количество() > 0 Тогда
		Результат = СчетаФактуры[0].Ссылка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ЗаявлениеОВвозеТоваровПоОснованию(ДокументОснование, Организация) Экспорт
	
	Результат = Неопределено;
	ЗаявленияОВвозеТоваров = Документы.ЗаявлениеОВвозеТоваров.ЗаявленияОВвозеТоваровПоОснованию(ДокументОснование, Организация, Ложь);
	Если ЗаявленияОВвозеТоваров.Количество() > 0 Тогда
		Результат = ЗаявленияОВвозеТоваров[0].Ссылка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СчетФактураВыданныйПоОснованию(ДокументОснование, Организация) Экспорт
	
	Результат = Неопределено;
	ПараметрыОтбора = Новый Структура("Организация", Организация);
	ПараметрыОтбора.Вставить("Перевыставленный", Ложь);
	СчетаФактуры = Документы.СчетФактураВыданный.СчетаФактурыПоОснованию(ДокументОснование, ПараметрыОтбора, Неопределено, Ложь);
	Если СчетаФактуры.Количество() > 0 Тогда
		Результат = СчетаФактуры[0].Ссылка;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

Функция СчетФактураКомиссионеруПоОснованию(ДокументОснование, Организация) Экспорт
	
	Результат = Неопределено;
	СчетаФактуры = Документы.СчетФактураКомиссионеру.СчетаФактурыПоОснованию(ДокументОснование, Организация);
	Если СчетаФактуры.Количество() > 0 Тогда
		Результат = СчетаФактуры[0].Ссылка;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

Функция СтруктураРеквизитовДляОбработки(ДокументСсылка) Экспорт 
	
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.СчетФактураВыданный") Тогда
	
		СтруктураРеквизитов = Документы.СчетФактураВыданный.ПараметрыЗаполненияПоСчетуФактуре(ДокументСсылка);
	
	ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
		
		СтруктураРеквизитов = Документы.СчетФактураПолученный.ПараметрыЗаполненияПоСчетуФактуре(ДокументСсылка);
		
	ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.СчетФактураПолученныйНалоговыйАгент") Тогда
		
		СтруктураРеквизитов = Документы.СчетФактураПолученныйНалоговыйАгент.ПараметрыЗаполненияПоСчетуФактуре(ДокументСсылка);
		
	КонецЕсли;
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

Функция СчетаФактурыПоТоварамВПути(Параметры) Экспорт
	
	Возврат Документы.СчетФактураПолученныйНалоговыйАгент.СчетаФактурыПоТоварамВПути(Параметры).ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Перезаполняет таблицу документов-оснований в счете-фактуре, перепроводит документ в закрытом периоде с 
// выборочной регистрацией по регл учету.
// 
// Параметры:
// 	СчетФактура - ДокументСсылка.СчетФактураПолученныйНалоговыйАгент -ранее зарегистрированный счет-фактура по товарам в пути 
// 	ДокументПриобретения - Массив,ДокументСсылка.ПриобретениеТоваровУслуг - документ отражения перехода права собственности
//
Процедура ОтразитьПолучениеТовараСОбратнымОбложениемНДС(СчетФактура, ДокументПриобретения) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаОснований.ДокументОснование КАК ДокументОснование
	|ИЗ
	|	Документ.СчетФактураПолученныйНалоговыйАгент.ДокументыОснования КАК ТаблицаОснований
	|ГДЕ
	|	ТаблицаОснований.Ссылка <> &Ссылка
	|	И ТаблицаОснований.ДокументОснование В(&СписокОснований)
	|	И ТаблицаОснований.Ссылка.Проведен
	|");
	
	Запрос.УстановитьПараметр("Ссылка", СчетФактура);
	Запрос.УстановитьПараметр("СписокОснований", ДокументПриобретения);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	Выборка = Результат.Выбрать();
	Отказ = Ложь;
	Пока Выборка.Следующий() Цикл
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для документа %1 уже введен счет-фактура';
				|en = 'Tax invoice is already posted for document %1'"),
			Выборка.ДокументОснование);
		ОбщегоНазначения.СообщитьПользователю(Текст, Выборка.ДокументОснование,,,Отказ);
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировки = Блокировка.Добавить("Документ.СчетФактураПолученныйНалоговыйАгент");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", СчетФактура);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.НДСПредъявленный.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ПартииПрочихРасходов.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ПартииНДСКРаспределению.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		//++ НЕ УТ
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОтражениеДокументовВРеглУчете.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		ЭлементБлокировки = Блокировка.Добавить("РегистрБухгалтерии.Хозрасчетный.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		//-- НЕ УТ
		
		Блокировка.Заблокировать();
		
		ОбъектСФ = СчетФактура.ПолучитьОбъект();
		ОбъектСФ.ДокументыОснования.Очистить();
		Если ТипЗнч(ДокументПриобретения) = Тип("Массив") Тогда
			Для Каждого ДокументОснование Из ДокументПриобретения Цикл
				СтрокаОснований = ОбъектСФ.ДокументыОснования.Добавить();
				СтрокаОснований.ДокументОснование = ДокументОснование;
			КонецЦикла;
		Иначе
			ОбъектСФ.ДокументыОснования.Добавить().ДокументОснование = ДокументПриобретения;
		КонецЕсли;
		ОбъектСФ.ЗаполнитьПараметрыСчетаФактурыПоОснованию();
		ОбъектСФ.ДополнительныеСвойства.Вставить("ПроверкаДатыЗапретаИзменения", Ложь);
		ОбъектСФ.ДополнительныеСвойства.Вставить("ПроверкаДокументов_Отключить", Истина);
		ОбъектСФ.Записать();
		
		ДополнительныеСвойства = Новый Структура;
		ДополнительныеСвойства.Вставить("ТаблицыДляДвижений", Новый Структура);
		
		Движения = Новый Структура;
		
		НДСПредъявленный = РегистрыНакопления.НДСПредъявленный.СоздатьНаборЗаписей();
		НДСПредъявленный.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("НДСПредъявленный", НДСПредъявленный);
		
		ПартииПрочихРасходов = РегистрыНакопления.ПартииПрочихРасходов.СоздатьНаборЗаписей();
		ПартииПрочихРасходов.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("ПартииПрочихРасходов", ПартииПрочихРасходов);
		
		ПартииНДСКРаспределению = РегистрыНакопления.ПартииНДСКРаспределению.СоздатьНаборЗаписей();
		ПартииНДСКРаспределению.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("ПартииНДСКРаспределению", ПартииНДСКРаспределению);
		
		//++ НЕ УТ
		ОтражениеДокументовВРеглУчете = РегистрыСведений.ОтражениеДокументовВРеглУчете.СоздатьНаборЗаписей();
		ОтражениеДокументовВРеглУчете.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("ОтражениеДокументовВРеглУчете", ОтражениеДокументовВРеглУчете);
		
		Хозрасчетный = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей();
		Хозрасчетный.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("Хозрасчетный", Хозрасчетный);
		//-- НЕ УТ
		
		Регистры = Новый Структура;
		Регистры.Вставить("НДСПредъявленный");
		Регистры.Вставить("ПартииПрочихРасходов");
		Регистры.Вставить("ПартииНДСКРаспределению");
		//++ НЕ УТ
		Регистры.Вставить("ОтражениеДокументовВРеглУчете");
		//-- НЕ УТ
		
		ТаблицыДляДвижений = ПроведениеДокументов.ДанныеДокументаДляПроведения(СчетФактура, Регистры);
		
		УчетНДСУП.ОтразитьДвижения(ТаблицыДляДвижений, Движения, Ложь);
		ДоходыИРасходыСервер.ОтразитьДвижения(ТаблицыДляДвижений, Движения, Ложь);
		
		//++ НЕ УТ
		ТаблицаВыборочнойРегистрации = РеглУчетПроведениеСервер.ТаблицаВыборочнойРегистрацииКОтражению();
		РеглУчетПроведениеСервер.ДобавитьПараметрыВыборочнойРегистрацииКОтражениюВРеглУчете(
			ТаблицаВыборочнойРегистрации,
			ОбъектСФ.Организация,
			ОбъектСФ.ДатаПереходаПраваСобственности);
		Если ЗначениеЗаполнено(ТаблицаВыборочнойРегистрации) Тогда
			ТаблицыДляДвижений.Вставить("ТаблицаВыборочнойРегистрацииКОтражению", ТаблицаВыборочнойРегистрации);
		КонецЕсли;
		
		РеглУчетПроведениеСервер.ОтразитьДвижения(ТаблицыДляДвижений, Движения, Ложь);
		//-- НЕ УТ
		
		//++ НЕ УТКА
		МеждународныйУчетПроведениеСервер.ОтразитьДвижения(ТаблицыДляДвижений, Движения, Ложь);
		//-- НЕ УТКА
		
		Документ = ПроведениеДокументов.ЭмуляцияДокумента(СчетФактура, ОбъектСФ.Дата);
		МенеджерВТ = Новый МенеджерВременныхТаблиц;
		Для Каждого Движение Из Движения Цикл
			ПроведениеДокументов.УстановитьДопСвойстваРегистра(Движение.Значение, Документ, МенеджерВТ);
			Движение.Значение.Записать();
		КонецЦикла;
		ПроведениеДокументов.СформироватьЗаданияНаОтложенныеДвижения(Документ, МенеджерВТ);
		
		//++ НЕ УТКА
		Документ = Новый Структура("Ссылка, Движения, Дата", СчетФактура, Движения, ОбъектСФ.Дата);
		МеждународныйУчетПроведениеСервер.ЗарегистрироватьКОтражению(Документ, Новый Структура, Движения, Ложь);
		//-- НЕ УТКА
			
		РегистрыСведений.ТребуетсяОформлениеСчетаФактуры.ОбновитьСостояние(
			СчетФактура,
			ОбъектСФ.ДокументыОснования.ВыгрузитьКолонку("ДокументОснование"));
	
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Не удалось выполнить отражение в учете документа ""%1"" по причине: %2';
					|en = 'Cannot record ""%1"" document in accounting. Reason: %2'"),
				СчетФактура,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение ТекстСообщения;
	КонецПопытки
	
КонецПроцедуры

// Очищает документы-основания в счете-фактуре полученном (налоговый агент), перепроводит документ в закрытом периоде с 
// выборочной регистрацией по регл учету.
// 
// Параметры:
// 	СчетФактура - ДокументСсылка.СчетФактураПолученныйНалоговыйАгент -ранее зарегистрированный счет-фактура по товарам в пути. 
//
Процедура ОчиститьДокументПриобретенияВСчетеФактуреПолученномНалоговогоАгента(СчетФактура) Экспорт
	
	Если СчетФактура.Корректировочный Или СчетФактура.Исправление Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировки = Блокировка.Добавить("Документ.СчетФактураПолученныйНалоговыйАгент");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", СчетФактура);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.НДСПредъявленный.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ПартииПрочихРасходов.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ПартииНДСКРаспределению.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		//++ НЕ УТ
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОтражениеДокументовВРеглУчете.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		ЭлементБлокировки = Блокировка.Добавить("РегистрБухгалтерии.Хозрасчетный.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		//-- НЕ УТ
		
		Блокировка.Заблокировать();
		
		ОбъектСФ = СчетФактура.ПолучитьОбъект();
		ДокументыОснования = ОбъектСФ.ДокументыОснования.ВыгрузитьКолонку("ДокументОснование");
		ДатаПереходаПраваСобственности = ОбъектСФ.ДатаПереходаПраваСобственности;
		Для Каждого СтрокаОснований Из ОбъектСФ.ДокументыОснования Цикл
			СтрокаОснований.ДокументОснование = Неопределено;
		КонецЦикла;
		ОбъектСФ.ДатаПереходаПраваСобственности = Дата(1,1,1);
		ОбъектСФ.ДополнительныеСвойства.Вставить("ПроверкаДатыЗапретаИзменения", Ложь);
		ОбъектСФ.ДополнительныеСвойства.Вставить("ПроверкаДокументов_Отключить", Истина);
		ОбъектСФ.Записать();
		
		ДополнительныеСвойства = Новый Структура;
		ДополнительныеСвойства.Вставить("ТаблицыДляДвижений", Новый Структура);
		
		Движения = Новый Структура;
		
		НДСПредъявленный = РегистрыНакопления.НДСПредъявленный.СоздатьНаборЗаписей();
		НДСПредъявленный.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("НДСПредъявленный", НДСПредъявленный);
		
		ПартииПрочихРасходов = РегистрыНакопления.ПартииПрочихРасходов.СоздатьНаборЗаписей();
		ПартииПрочихРасходов.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("ПартииПрочихРасходов", ПартииПрочихРасходов);
		
		ПартииНДСКРаспределению = РегистрыНакопления.ПартииНДСКРаспределению.СоздатьНаборЗаписей();
		ПартииНДСКРаспределению.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("ПартииНДСКРаспределению", ПартииНДСКРаспределению);
		
		//++ НЕ УТ
		ОтражениеДокументовВРеглУчете = РегистрыСведений.ОтражениеДокументовВРеглУчете.СоздатьНаборЗаписей();
		ОтражениеДокументовВРеглУчете.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("ОтражениеДокументовВРеглУчете", ОтражениеДокументовВРеглУчете);
		
		Хозрасчетный = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей();
		Хозрасчетный.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("Хозрасчетный", Хозрасчетный);
		//-- НЕ УТ
		
		Регистры = Новый Структура;
		Регистры.Вставить("НДСПредъявленный");
		Регистры.Вставить("ПартииПрочихРасходов");
		Регистры.Вставить("ПартииНДСКРаспределению");
		//++ НЕ УТ
		Регистры.Вставить("ОтражениеДокументовВРеглУчете");
		//-- НЕ УТ
		
		ТаблицыДляДвижений = ПроведениеДокументов.ДанныеДокументаДляПроведения(СчетФактура, Регистры);
		
		УчетНДСУП.ОтразитьДвижения(ТаблицыДляДвижений, Движения, Ложь);
		ДоходыИРасходыСервер.ОтразитьДвижения(ТаблицыДляДвижений, Движения, Ложь);
		
		//++ НЕ УТ
		ТаблицаВыборочнойРегистрации = РеглУчетПроведениеСервер.ТаблицаВыборочнойРегистрацииКОтражению();
		РеглУчетПроведениеСервер.ДобавитьПараметрыВыборочнойРегистрацииКОтражениюВРеглУчете(
			ТаблицаВыборочнойРегистрации,
			ОбъектСФ.Организация,
			ОбъектСФ.ДатаПереходаПраваСобственности);
		Если ЗначениеЗаполнено(ТаблицаВыборочнойРегистрации) Тогда
			ТаблицыДляДвижений.Вставить("ТаблицаВыборочнойРегистрацииКОтражению", ТаблицаВыборочнойРегистрации);
		КонецЕсли;
		
		РеглУчетПроведениеСервер.ОтразитьДвижения(ТаблицыДляДвижений, Движения, Ложь);
		//-- НЕ УТ
		
		//++ НЕ УТКА
		МеждународныйУчетПроведениеСервер.ОтразитьДвижения(ТаблицыДляДвижений, Движения, Ложь);
		//-- НЕ УТКА
		
		Документ = ПроведениеДокументов.ЭмуляцияДокумента(СчетФактура, ОбъектСФ.Дата);
		МенеджерВТ = Новый МенеджерВременныхТаблиц;
		Для Каждого Движение Из Движения Цикл
			ПроведениеДокументов.УстановитьДопСвойстваРегистра(Движение.Значение, Документ, МенеджерВТ);
			Движение.Значение.Записать();
		КонецЦикла;
		ПроведениеДокументов.СформироватьЗаданияНаОтложенныеДвижения(Документ, МенеджерВТ);
		
		//++ НЕ УТКА
		Документ = Новый Структура("Ссылка, Движения, Дата", СчетФактура, Движения, ОбъектСФ.Дата);
		МеждународныйУчетПроведениеСервер.ЗарегистрироватьКОтражению(Документ, Новый Структура, Движения, Ложь);
		//-- НЕ УТКА
			
		РегистрыСведений.ТребуетсяОформлениеСчетаФактуры.ОбновитьСостояние(
			СчетФактура,
			ДокументыОснования);
	
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Не удалось выполнить отражение в учете документа ""%1"" по причине: %2';
					|en = 'Cannot record ""%1"" document in accounting. Reason: %2'"),
				СчетФактура,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение ТекстСообщения;
	КонецПопытки
	
КонецПроцедуры

#КонецОбласти