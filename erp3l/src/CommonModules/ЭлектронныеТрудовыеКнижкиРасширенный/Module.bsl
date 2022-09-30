#Область СлужебныйПрограммныйИнтерфейс

// ЗарплатаКадрыРасширеннаяПодсистемы.ИсправленияДокументов

Процедура ПриИсправленииТрудовойДеятельности(ИсправленныйДокумент) Экспорт
	
	МетаданныеДокумента = ИсправленныйДокумент.Метаданные();
	Если МетаданныеДокумента.Движения.Содержит(Метаданные.РегистрыСведений.МероприятияТрудовойДеятельности) Тогда
		
		НаборЗаписей = РегистрыСведений.МероприятияТрудовойДеятельности.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(ИсправленныйДокумент);
		НаборЗаписей.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтменитьИсправлениеТрудовойДеятельности(Источник, Отказ) Экспорт
	
	ОтменитьИсправлениеДокумента(Источник.ИсправленныйДокумент, Источник);
	
КонецПроцедуры

Процедура ОтменитьИсправлениеДокумента(ИсправленныйДокумент, Источник) Экспорт
	
	Если ЗначениеЗаполнено(ИсправленныйДокумент) Тогда
		
		МетаданныеДокумента = ИсправленныйДокумент.Метаданные();
		Если МетаданныеДокумента.Движения.Содержит(Метаданные.РегистрыСведений.МероприятияТрудовойДеятельности) Тогда
			
			// Необходимо очистить движения исправляющего документа, что бы восстановить идентификаторы мероприятий
			Если Источник.Движения.Найти("МероприятияТрудовойДеятельности") <> Неопределено Тогда
				Источник.Движения.МероприятияТрудовойДеятельности.Записать();
			КонецЕсли;
			
			МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МетаданныеДокумента.ПолноеИмя());
			МероприятияТрудовойДеятельности = МенеджерДокумента.ДанныеДляПроведенияМероприятияТрудовойДеятельности(
				ИсправленныйДокумент).Получить(ИсправленныйДокумент);
			
			НаборЗаписей = РегистрыСведений.МероприятияТрудовойДеятельности.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(ИсправленныйДокумент);
			
			МенеджерДокумента.СформироватьДвиженияМероприятийТрудовойДеятельности(
				НаборЗаписей, МероприятияТрудовойДеятельности);
			
			НаборЗаписей.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаполненииДокументаИсправления(ДокументИсправление, ИсправляемыйДокумент) Экспорт
	
	МетаданныеДокумента = ДокументИсправление.Метаданные();
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("НомерПриказа", МетаданныеДокумента) Тогда
		РеквизитыИсправления = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ИсправляемыйДокумент, "Номер,НомерПриказа");
		ДокументИсправление.НомерПриказа = ЗарплатаКадрыОтчеты.НомерНаПечать(РеквизитыИсправления.Номер, РеквизитыИсправления.НомерПриказа);
	КонецЕсли;
	
КонецПроцедуры

// Конец ЗарплатаКадрыРасширеннаяПодсистемы.ИсправленияДокументов

Функция РазрядКатегорияВидимость() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьРазрядыКатегорииКлассыДолжностейИПрофессийВШтатномРасписании")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьКвалификационнуюНадбавку")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьТарифныеСеткиПриРасчетеЗарплатыХозрасчет");
	
КонецФункции

Функция КодПоРееструДолжностейВидимость() Экспорт
	
	Возврат ПерсонифицированныйУчетРасширенный.ИспользоватьЗамещениеГосударственныхМуниципальныхДолжностей();
	
КонецФункции

Процедура УстановитьОтборПараметровПолученияСотрудниковОрганизации(ПараметрыПолучения) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		
		МодульГосударственнаяСлужба = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		МодульГосударственнаяСлужба.УстановитьОтборПараметровПолученияСотрудниковОрганизации
			(ПараметрыПолучения);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ИменаКадровыхДанныхСотрудниковДляНачалаУчета() Экспорт
	
	Возврат ЭлектронныеТрудовыеКнижкиБазовый.ИменаКадровыхДанныхСотрудниковДляНачалаУчета() + ",РазрядКатегория";
	
КонецФункции

Процедура ДополнитьМероприятияЭТКДаннымиРеестраКадровыхПриказов(ДанныеСотрудниковБезМероприятий) Экспорт
	
	Сотрудники = Новый Массив;
	Для Каждого ДанныеСотрудника Из ДанныеСотрудниковБезМероприятий Цикл
		
		Если Не ЗначениеЗаполнено(ДанныеСотрудника.ВидМероприятия) Тогда
			Сотрудники.Добавить(ДанныеСотрудника.СотрудникЗаписи);
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("НаименованиеДокументаОснования", ЭлектронныеТрудовыеКнижки.НаименованиеДокументаОснования());
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	Запрос.УстановитьПараметр("ВидыДоговоров", Перечисления.ВидыДоговоровССотрудниками.ВидыДоговоровВоеннойСлужбы());
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	РеестрКадровыхПриказов.Сотрудник КАК СотрудникЗаписи,
		|	РеестрКадровыхПриказов.ФизическоеЛицо КАК Сотрудник,
		|	РеестрКадровыхПриказов.Организация КАК Организация,
		|	РеестрКадровыхПриказов.ДокументОснование КАК ДокументОснование,
		|	РеестрКадровыхПриказов.Дата КАК ДатаМероприятия,
		|	РеестрКадровыхПриказов.ВидДоговора КАК ВидДоговора,
		|	РеестрКадровыхПриказов.ВидСобытия КАК ВидСобытия,
		|	РеестрКадровыхПриказов.ДатаПриказа КАК ДатаДокументаОснования,
		|	РеестрКадровыхПриказов.НомерПриказа КАК НомерДокументаОснования
		|ПОМЕСТИТЬ ВТРеестрКадровыхПриказов
		|ИЗ
		|	РегистрСведений.РеестрКадровыхПриказов КАК РеестрКадровыхПриказов
		|ГДЕ
		|	РеестрКадровыхПриказов.Сотрудник В(&Сотрудники)
		|	И РеестрКадровыхПриказов.Дата < ДАТАВРЕМЯ(2020, 1, 1)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РеестрКадровыхПриказов.СотрудникЗаписи КАК СотрудникЗаписи,
		|	МАКСИМУМ(РеестрКадровыхПриказов.ДатаМероприятия) КАК ДатаМероприятия
		|ПОМЕСТИТЬ ВТПоследниеДатыМероприятий
		|ИЗ
		|	ВТРеестрКадровыхПриказов КАК РеестрКадровыхПриказов
		|
		|СГРУППИРОВАТЬ ПО
		|	РеестрКадровыхПриказов.СотрудникЗаписи
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РеестрКадровыхПриказов.СотрудникЗаписи КАК СотрудникЗаписи,
		|	РеестрКадровыхПриказов.ДатаМероприятия КАК ДатаМероприятия,
		|	ВЫБОР
		|		КОГДА РеестрКадровыхПриказов.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Прием)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийТрудовойДеятельности.Прием)
		|		КОГДА РеестрКадровыхПриказов.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Перемещение)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийТрудовойДеятельности.Перевод)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийТрудовойДеятельности.ПустаяСсылка)
		|	КОНЕЦ КАК ВидМероприятия,
		|	&НаименованиеДокументаОснования КАК НаименованиеДокументаОснования,
		|	РеестрКадровыхПриказов.ДатаДокументаОснования КАК ДатаДокументаОснования,
		|	РеестрКадровыхПриказов.НомерДокументаОснования КАК НомерДокументаОснования
		|ИЗ
		|	ВТПоследниеДатыМероприятий КАК ПоследниеДатыМероприятий
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТРеестрКадровыхПриказов КАК РеестрКадровыхПриказов
		|		ПО ПоследниеДатыМероприятий.СотрудникЗаписи = РеестрКадровыхПриказов.СотрудникЗаписи
		|			И ПоследниеДатыМероприятий.ДатаМероприятия = РеестрКадровыхПриказов.ДатаМероприятия
		|ГДЕ
		|	НЕ РеестрКадровыхПриказов.ВидДоговора В (&ВидыДоговоров)";
	
	ДанныеРеестра = Запрос.Выполнить().Выгрузить();
	Для Каждого ДанныеСотрудника Из ДанныеСотрудниковБезМероприятий Цикл
		
		СтрокаРеестра = ДанныеРеестра.Найти(ДанныеСотрудника.СотрудникЗаписи, "СотрудникЗаписи");
		Если СтрокаРеестра <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ДанныеСотрудника, СтрокаРеестра);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УточнитьЗапросПолученияДанныхНаНачалоУчета(Запрос) Экспорт
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&РазрядКатегория", "СотрудникиОрганизации.РазрядКатегория");
	
КонецПроцедуры

Процедура УстановитьВидимостьПолейОтраженияТрудовойДеятельностиВоеннослужащих(УправляемаяФорма) Экспорт
	
	ОтражениеТрудовойДеятельностиГруппаВидимость = Ложь;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		МодульГосударственнаяСлужба = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		ОтражениеТрудовойДеятельностиГруппаВидимость = МодульГосударственнаяСлужба.ОтражатьТрудовуюДеятельностьВоеннослужащих();
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"ОтражениеТрудовойДеятельностиГруппа",
		"Видимость",
		ОтражениеТрудовойДеятельностиГруппаВидимость);
	
КонецПроцедуры

Функция КодДолжностиПоРееструГосударственнойСлужбы(Должность) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		
		МодульГосударственнаяСлужба = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		Возврат МодульГосударственнаяСлужба.КодДолжностиПоРееструГосударственнойСлужбы(Должность);
		
	КонецЕсли;
	
	Возврат ЭлектронныеТрудовыеКнижкиБазовый.КодДолжностиПоРееструГосударственнойСлужбы(Должность);
	
КонецФункции

Процедура ДополнитьЗапросПолучениемРазрядовКатегорийПозицийШтатногоРасписания(Запрос, РазрядКатегорияВДанныхДокументов) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении") Тогда
		
		Если Не РазрядКатегорияВДанныхДокументов
			Или Не ПолучитьФункциональнуюОпцию("ИспользоватьТарифныеСеткиПриРасчетеЗарплаты")
				И ПолучитьФункциональнуюОпцию("ИспользоватьРазрядыКатегорииКлассыДолжностейИПрофессийВШтатномРасписании") Тогда
			
			ПараметрыПостроения = УправлениеШтатнымРасписанием.ПараметрыПостроенияВТШтатноеРасписаниеПоТаблицеФильтра(
				"ВТДанныеДокументов", "ДатаМероприятия", "ДолжностьПоШтатномуРасписанию");
			
			УправлениеШтатнымРасписанием.СоздатьВТШтатноеРасписание(
				Запрос.МенеджерВременныхТаблиц, Истина, ПараметрыПостроения, "РазрядКатегория");
			
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "ДанныеДокументов.РазрядКатегория", "ШтатноеРасписание.РазрядКатегория");
			
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВТДанныеДокументов КАК ДанныеДокументов",
			"ВТДанныеДокументов КАК ДанныеДокументов
				|ЛЕВОЕ СОЕДИНЕНИЕ ВТШтатноеРасписание КАК ШтатноеРасписание
				|ПО ДанныеДокументов.ДатаМероприятия = ШтатноеРасписание.Период
				|	И ДанныеДокументов.ДолжностьПоШтатномуРасписанию = ШтатноеРасписание.ПозицияШтатногоРасписания");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция МероприятияСотрудникаДо2020Года(Сотрудник, Организация) Экспорт
	
	ДанныеСотрудника = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ПараметрыПолучения = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолучения.Организация = Организация;
	ПараметрыПолучения.НачалоПериода = ЭлектронныеТрудовыеКнижки.ДатаНачалаУчета() - 1;
	ПараметрыПолучения.ОкончаниеПериода = ПараметрыПолучения.НачалоПериода;
	ПараметрыПолучения.КадровыеДанные = ЭлектронныеТрудовыеКнижки.ИменаКадровыхДанныхСотрудниковДляНачалаУчета();
	ПараметрыПолучения.СписокФизическихЛиц = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник);
	
	ЭлектронныеТрудовыеКнижки.УстановитьОтборПараметровПолученияСотрудниковОрганизации(ПараметрыПолучения);
	
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, ПараметрыПолучения);
	
	ПараметрыПостроения = КадровыйУчетРасширенный.ПараметрыПостроенияВТРеестрКадровыхПриказовПоВременнойТаблице();
	ПараметрыПостроения.ИмяВТОтборовСотрудников = "ВТСотрудникиОрганизации";
	ПараметрыПостроения.ИмяПоляДатаНачала = "ДатаПриема";
	ПараметрыПостроения.ИмяПоляДатаОкончания = "Период";
	
	КадровыйУчетРасширенный.СоздатьВТРеестрКадровыхПриказов(Запрос.МенеджерВременныхТаблиц, Истина, ПараметрыПостроения);
	
	Запрос.УстановитьПараметр("ДатаНачалаУчета", ЭлектронныеТрудовыеКнижки.ДатаНачалаУчета());
	Запрос.УстановитьПараметр("НаименованиеДокументаОснования", ЭлектронныеТрудовыеКнижки.НаименованиеДокументаОснования());
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СотрудникиОрганизации.Сотрудник КАК СотрудникЗаписи,
		|	СотрудникиОрганизации.ФизическоеЛицо КАК Сотрудник,
		|	РеестрКадровыхПриказов.Подразделение КАК Подразделение,
		|	РеестрКадровыхПриказов.Должность КАК Должность,
		|	ВЫБОР
		|		КОГДА СотрудникиОрганизации.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ОсновноеМестоРаботы)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЯвляетсяСовместителем,
		|	ВЫБОР
		|		КОГДА РеестрКадровыхПриказов.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Прием)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийТрудовойДеятельности.Прием)
		|		КОГДА РеестрКадровыхПриказов.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Перемещение)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийТрудовойДеятельности.Перевод)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийТрудовойДеятельности.ПустаяСсылка)
		|	КОНЕЦ КАК ВидМероприятия,
		|	РеестрКадровыхПриказов.Период КАК ДатаМероприятия,
		|	&НаименованиеДокументаОснования КАК НаименованиеДокументаОснования,
		|	РеестрКадровыхПриказов.ДатаПриказа КАК ДатаДокументаОснования,
		|	РеестрКадровыхПриказов.НомерПриказа КАК НомерДокументаОснования,
		|	РеестрКадровыхПриказов.Разряд КАК РазрядКатегория,
		|	РеестрКадровыхПриказов.Регистратор КАК Регистратор
		|ИЗ
		|	ВТСотрудникиОрганизации КАК СотрудникиОрганизации
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТРеестрКадровыхПриказов КАК РеестрКадровыхПриказов
		|		ПО СотрудникиОрганизации.ФизическоеЛицо = РеестрКадровыхПриказов.ФизическоеЛицо
		|			И СотрудникиОрганизации.Сотрудник = РеестрКадровыхПриказов.Сотрудник
		|			И (РеестрКадровыхПриказов.ВидСобытия В (ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Прием), ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Перемещение)))
		|ГДЕ
		|	СотрудникиОрганизации.ВидСобытия <> ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
		|	И СотрудникиОрганизации.ДатаПриема < &ДатаНачалаУчета
		|	И (СотрудникиОрганизации.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1)
		|			ИЛИ СотрудникиОрганизации.ДатаУвольнения >= &ДатаНачалаУчета)
		|
		|УПОРЯДОЧИТЬ ПО
		|	СотрудникиОрганизации.ФИОПолные,
		|	ЯвляетсяСовместителем";
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеРеестра = Запрос.Выполнить().Выгрузить();
	РеквизитыПриказов = КадровыйУчетРасширенный.РеквизитыКадровыхПриказов(ДанныеРеестра.ВыгрузитьКолонку("Регистратор"));
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Для Каждого ДанныеЗаписи Из ДанныеРеестра Цикл
		
		ДанныеМероприятияСотрудника = ЭлектронныеТрудовыеКнижки.ПустаяСтруктураЗаписиОТрудовойДеятельности();
		ЗаполнитьЗначенияСвойств(ДанныеМероприятияСотрудника, ДанныеЗаписи);
		
		Если ДанныеМероприятияСотрудника.ВидМероприятия = Перечисления.ВидыМероприятийТрудовойДеятельности.Прием Тогда
			ДанныеМероприятияСотрудника.НаименованиеДокументаОснования = ЭлектронныеТрудовыеКнижки.НаименованиеДокументаПоВидуДокументаСобытия(Организация, "ПриемНаРаботу");
		ИначеЕсли ДанныеМероприятияСотрудника.ВидМероприятия = Перечисления.ВидыМероприятийТрудовойДеятельности.Перевод Тогда
			ДанныеМероприятияСотрудника.НаименованиеДокументаОснования = ЭлектронныеТрудовыеКнижки.НаименованиеДокументаПоВидуДокументаСобытия(Организация, "КадровыйПеревод");
		КонецЕсли;
		
		Если ДанныеМероприятияСотрудника.НомерДокументаОснования = Неопределено Тогда
			
			РеквизитыПриказа = РеквизитыПриказов.Получить(ДанныеЗаписи.Регистратор);
			Если РеквизитыПриказа <> Неопределено Тогда
				ДанныеМероприятияСотрудника.НомерДокументаОснования = ЗарплатаКадрыОтчеты.НомерНаПечать(РеквизитыПриказа.Номер, РеквизитыПриказа.НомерПриказа);
				ДанныеМероприятияСотрудника.ДатаДокументаОснования = РеквизитыПриказа.Дата;
			КонецЕсли;
			
		КонецЕсли;
		
		ДанныеСотрудника.Добавить(ДанныеМероприятияСотрудника);
		
	КонецЦикла;
	
	Возврат ДанныеСотрудника;
	
КонецФункции

Процедура ДобавитьКомандыРассылкиЗаявленияОПредоставленииСведенийОТрудовойДеятельности(Команды) Экспорт
	
	Команда = Команды.Добавить();
	Команда.ТипПараметра = Новый ОписаниеТипов("ДокументСсылка.ЗаявленияОПредоставленииСведенийОТрудовойДеятельности");
	Команда.Представление = НСтр("ru = 'Рассылка заявлений';
								|en = 'Application distribution'");
	Команда.ПечатныеФормы = РассылкаДокументовКлиентСервер.НоваяПечатнаяФорма();
	Команда.ПечатныеФормы.Идентификатор = Документы.ЗаявленияОПредоставленииСведенийОТрудовойДеятельности.ИдентификаторКомандыПечатиЗаявления();
	Команда.ПечатныеФормы.ОбработчикПолученияДанных = 
		"Документы.ЗаявленияОПредоставленииСведенийОТрудовойДеятельности.ДанныеДляПечати";
	Команда.ПечатныеФормы.ДополнительныеПараметры.Вставить("РеквизитыДетализации", "ФизическоеЛицо");
	Команда.ТемаПисьма = НСтр("ru = 'Заявления о предоставлении сведений о трудовой деятельности';
								|en = 'Application for the provision of labor activity information'");
	Команда.ТекстПисьма = Документы.ЗаявленияОПредоставленииСведенийОТрудовойДеятельности.ПолучитьМакет("ТекстПисьмаРассылкиДокументов").ПолучитьТекст();
	
КонецПроцедуры

Функция ПредставлениеРазрядаКатегории(РазрядКатегория) Экспорт
	
	Если ТипЗнч(РазрядКатегория) = Тип("СправочникСсылка.РазрядыКатегорииДолжностей") Тогда
		
		НаименованиеПолное = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РазрядКатегория, "НаименованиеПолное");
		Если Не ПустаяСтрока(НаименованиеПолное) Тогда
			Возврат СокрЛП(НаименованиеПолное);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ЭлектронныеТрудовыеКнижкиБазовый.ПредставлениеРазрядаКатегории(РазрядКатегория);
	
КонецФункции

Процедура ЗаполнитьКодыТрудовыхФункцийПоДолжностям(ПараметрыОбновления) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Если ПараметрыОбновления = Неопределено Тогда
		МассивОбновленных = Новый Массив;
	Иначе
		
		Если ПараметрыОбновления.Свойство("МассивОбновленных") Тогда
			МассивОбновленных = ПараметрыОбновления.МассивОбновленных;
		Иначе
			МассивОбновленных = Новый Массив;
			ПараметрыОбновления.Вставить("МассивОбновленных", МассивОбновленных);
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("МассивОбновленных", МассивОбновленных);
	
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1000
		|	Должности.ТрудоваяФункция КАК ТрудоваяФункция
		|ПОМЕСТИТЬ ВТТрудовыеФункцииДолжностей
		|ИЗ
		|	Справочник.Должности КАК Должности
		|ГДЕ
		|	Должности.ТрудоваяФункция <> ЗНАЧЕНИЕ(Справочник.ТрудовыеФункции.ПустаяСсылка)
		|	И НЕ Должности.ТрудоваяФункция В (&МассивОбновленных)
		|	И (Должности.ОКПДТРКод <> """"
		|			ИЛИ Должности.ОКПДТРКЧ <> """"
		|			ИЛИ Должности.ОКПДТРКатегория <> """"
		|			ИЛИ Должности.ОКЗКод <> """")";
	
	Если ПараметрыОбновления = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1000","");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не ЗарплатаКадры.ВТСодержитСтроки(Запрос.МенеджерВременныхТаблиц, "ВТТрудовыеФункцииДолжностей") Тогда
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(
			ПараметрыОбновления, "ОбработкаЗавершена", Истина);
		
		Возврат;
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(
		ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТрудовыеФункцииДолжностей.ТрудоваяФункция КАК ТрудоваяФункция,
		|	МАКСИМУМ(Должности.ОКПДТРКод) КАК ОКПДТРКодМаксимум,
		|	МАКСИМУМ(Должности.ОКПДТРКЧ) КАК ОКПДТРКЧМаксимум,
		|	МАКСИМУМ(Должности.ОКПДТРКатегория) КАК ОКПДТРКатегорияМаксимум,
		|	МАКСИМУМ(Должности.ОКЗКод) КАК ОКЗКодМаксимум,
		|	МИНИМУМ(Должности.ОКПДТРКод) КАК ОКПДТРКодМинимум,
		|	МИНИМУМ(Должности.ОКПДТРКЧ) КАК ОКПДТРКЧМинимум,
		|	МИНИМУМ(Должности.ОКПДТРКатегория) КАК ОКПДТРКатегорияМинимум,
		|	МИНИМУМ(Должности.ОКЗКод) КАК ОКЗКодМинимум
		|ИЗ
		|	ВТТрудовыеФункцииДолжностей КАК ТрудовыеФункцииДолжностей
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Должности КАК Должности
		|		ПО ТрудовыеФункцииДолжностей.ТрудоваяФункция = Должности.ТрудоваяФункция
		|
		|СГРУППИРОВАТЬ ПО
		|	ТрудовыеФункцииДолжностей.ТрудоваяФункция";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		МассивОбновленных.Добавить(Выборка.ТрудоваяФункция);
		
		Если Выборка.ОКПДТРКодМаксимум <> Выборка.ОКПДТРКодМинимум
			Или Выборка.ОКПДТРКЧМаксимум <> Выборка.ОКПДТРКЧМинимум
			Или Выборка.ОКПДТРКатегорияМаксимум <> Выборка.ОКПДТРКатегорияМинимум
			Или Выборка.ОКЗКодМаксимум <> Выборка.ОКЗКодМинимум Тогда
			
			Продолжить;
		КонецЕсли;
		
		Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
			ПараметрыОбновления, "Справочник.ТрудовыеФункции", "Ссылка", Выборка.ТрудоваяФункция) Тогда
			
			Продолжить;
		КонецЕсли;
		
		ОбъектСправочника = Выборка.ТрудоваяФункция.ПолучитьОбъект();
		
		ОбъектСправочника.ОКПДТРКод       = Выборка.ОКПДТРКодМаксимум;
		ОбъектСправочника.ОКПДТРКЧ        = Выборка.ОКПДТРКЧМаксимум;
		ОбъектСправочника.ОКПДТРКатегория = Выборка.ОКПДТРКатегорияМаксимум;
		
		Если ЗначениеЗаполнено(Выборка.ОКЗКодМаксимум) Тогда
			ОбъектСправочника.КодПоОКЗ = Справочники.КлассификаторЗанятий.НайтиПоКоду(Выборка.ОКЗКодМаксимум);
		КонецЕсли;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектСправочника);
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеТрудовойФункцииВДолжности(ДолжностьОбъект, Отказ) Экспорт
	
	Если ЗначениеЗаполнено(ДолжностьОбъект.ТрудоваяФункция) Тогда
		
		РеквизитыТрудовойФункции = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДолжностьОбъект.ТрудоваяФункция, "ОКПДТРКод,ОКПДТРКЧ,ОКПДТРКатегория,КодПоОКЗ");
		Если РеквизитыТрудовойФункции.ОКПДТРКод <> ДолжностьОбъект.ОКПДТРКод И ЗначениеЗаполнено(ДолжностьОбъект.ОКПДТРКод)
			Или РеквизитыТрудовойФункции.ОКПДТРКЧ <> ДолжностьОбъект.ОКПДТРКЧ И ЗначениеЗаполнено(ДолжностьОбъект.ОКПДТРКЧ)
			Или РеквизитыТрудовойФункции.ОКПДТРКатегория <> ДолжностьОбъект.ОКПДТРКатегория И ЗначениеЗаполнено(ДолжностьОбъект.ОКПДТРКатегория)
			Или Строка(РеквизитыТрудовойФункции.КодПоОКЗ) <> ДолжностьОбъект.ОКЗКод И ЗначениеЗаполнено(ДолжностьОбъект.ОКЗКод) Тогда
			
			ТекстСообщения = НСтр("ru = 'Коды ОКПДТР и ОКЗ должности не соответствуют кодам трудовой функции';
									|en = 'The job title RNCPWEPTC and ACO codes do not correspond to the labor function codes'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ДолжностьОбъект.Ссылка, "ТрудоваяФункция", "Объект", Отказ);
			
		КонецЕсли;
		
	Иначе
		
		Если ЗначениеЗаполнено(ДолжностьОбъект.ОКПДТРКод)
			Или ЗначениеЗаполнено(ДолжностьОбъект.ОКПДТРКЧ)
			Или ЗначениеЗаполнено(ДолжностьОбъект.ОКПДТРКатегория)
			Или ЗначениеЗаполнено(ДолжностьОбъект.ОКЗКод) Тогда
			
			ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Трудовая функция""';
									|en = '""Labor function"" is not filled in'",);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ДолжностьОбъект.Ссылка, "ТрудоваяФункция", "Объект", Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьТипыОснованийУвольненияДляРегистрацииМероприятийТрудовойДеятельности(СписокОснований) Экспорт
	
	ЭлектронныеТрудовыеКнижкиБазовый.ЗаполнитьТипыОснованийУвольненияДляРегистрацииМероприятийТрудовойДеятельности(СписокОснований);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		МодульГосударственнаяСлужба = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		МодульГосударственнаяСлужба.ЗаполнитьТипыОснованийУвольненияДляРегистрацииМероприятийТрудовойДеятельности(СписокОснований);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеКодаОКЗТрудовойФункцииСписочногоДокумента(Объект, ИмяТабличнойЧасти, ИмяРеквизитаДатаМероприятия, Отказ, ПроверитьОтражениеВТрудовойКнижке = Истина) Экспорт
	
	Для Каждого СтрокаТабличнойЧасти Из Объект[ИмяТабличнойЧасти] Цикл
		
		Если ПроверитьОтражениеВТрудовойКнижке И Не СтрокаТабличнойЧасти.ОтразитьВТрудовойКнижке Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрокаТабличнойЧасти[ИмяРеквизитаДатаМероприятия] >= '20210701' Тогда
			
			ПутьКПолю = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧРГ=; ЧН=") + "].";
			Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.ТрудоваяФункция) Тогда
				
				КодПоОКЗ = ЭлектронныеТрудовыеКнижкиПовтИсп.КодПоОКЗТрудовойФункции(СтрокаТабличнойЧасти.ТрудоваяФункция);
				Если Не ЗначениеЗаполнено(КодПоОКЗ) Тогда
				
					ТекстСообщения = СтрШаблон(
						НСтр("ru = 'В строке %1, у выбранной трудовой функции (%2) не заполнено, поле ""Код по ОКЗ""';
							|en = 'The ""ACO code"" field of the selected labor function (%2) in the %1 line is not filled in'"),
						СтрокаТабличнойЧасти.НомерСтроки,
						СтрокаТабличнойЧасти.ТрудоваяФункция);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, ПутьКПолю + "Сотрудник", "Объект", Отказ);
					
				КонецЕсли;
				
			Иначе
				
				ТекстСообщения = СтрШаблон(
					НСтр("ru = 'В строке %1, поле ""Трудовая функция"" не заполнено';
						|en = 'The ""Labor function"" field in the %1 line is not filled in'"),
					СтрокаТабличнойЧасти.НомерСтроки);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, ПутьКПолю + "Сотрудник", "Объект", Отказ);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьВТабличнойЧастиЗаполнениеКодаОКЗТрудовойФункции(Объект, ИмяТабличнойЧасти, ИмяРеквизитаДатаМероприятия, Отказ, ПроверитьОтражениеВТрудовойКнижке = Истина) Экспорт
	
	СсылкаНаОбъект = Объект.Ссылка;
	Для Каждого СтрокаТабличнойЧасти Из Объект[ИмяТабличнойЧасти] Цикл
		
		ПутьКПолю = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧРГ=; ЧН=") + "].";
		
		Если ПроверитьОтражениеВТрудовойКнижке И Не СтрокаТабличнойЧасти.ОтразитьВТрудовойКнижке Тогда
			Возврат;
		КонецЕсли;
		
		Если СтрокаТабличнойЧасти[ИмяРеквизитаДатаМероприятия] >= '20210701' Тогда
			
			Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.ТрудоваяФункция) Тогда
				
				КодПоОКЗ = ЭлектронныеТрудовыеКнижкиПовтИсп.КодПоОКЗТрудовойФункции(СтрокаТабличнойЧасти.ТрудоваяФункция);
				Если Не ЗначениеЗаполнено(КодПоОКЗ) Тогда
				
					ТекстСообщения = СтрШаблон(
						НСтр("ru = 'У выбранной трудовой функции (%1) не заполнено поле ""Код по ОКЗ""';
							|en = 'The ""ACO code"" field of the selected labor function (%1) is not filled in'"),
						СтрокаТабличнойЧасти.ТрудоваяФункция);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, СсылкаНаОбъект, ПутьКПолю + "Сотрудник", "Объект", Отказ);
					
				КонецЕсли;
				
			Иначе
				
				ТекстСообщения = НСтр("ru = 'Поле ""Трудовая функция"" не заполнено';
										|en = 'The ""Labor function"" field is not filled in'");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, СсылкаНаОбъект, ПутьКПолю + "Сотрудник", "Объект", Отказ);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ИменаКадровыхДанныхДляФормированияМероприятий() Экспорт
	
	ИменаКадровыхДанных = ЭлектронныеТрудовыеКнижкиБазовый.ИменаКадровыхДанныхДляФормированияМероприятий();
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеТерритории") Тогда
		ИменаКадровыхДанных = ИменаКадровыхДанных + ",Территория";
	КонецЕсли;
	Возврат ИменаКадровыхДанных;
	
КонецФункции

Процедура ДополнитьСведениямиОТерриториальныхУсловиях(ДанныеМероприятия, ПараметрыФормирования, КадровыеДанныеСотрудников) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеТерритории")
		И ДанныеМероприятия.ОтразитьТерриториальныеУсловияПоТерриторииВыполненияРабот Тогда
		
		СтруктурнаяЕдиница = ДанныеМероприятия.Территория;
		Если ПараметрыФормирования.ПолучатьИсточникДанныхОТерриториальныхУсловиях Тогда
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("Сотрудник", ДанныеМероприятия.Сотрудник);
			СтруктураПоиска.Вставить("Период", ДанныеМероприятия.ДатаМероприятия);
			
			КадровыеДанныеСотрудника = КадровыеДанныеСотрудников.НайтиСтроки(СтруктураПоиска);
			Если КадровыеДанныеСотрудника.Количество() > 0 Тогда
				СтруктурнаяЕдиница = КадровыеДанныеСотрудника[0].Территория;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтруктурнаяЕдиница) Тогда
			ДанныеМероприятия.ТерриториальныеУсловия = ЭлектронныеТрудовыеКнижкиПовтИсп.ТерриториальныеУсловияПФР(
				ДанныеМероприятия.ДатаМероприятия, ДанныеМероприятия.Организация, СтруктурнаяЕдиница);
		Иначе
			ДанныеМероприятия.ТерриториальныеУсловия = Неопределено;
		КонецЕсли;
	Иначе
		ЭлектронныеТрудовыеКнижкиБазовый.ДополнитьСведениямиОТерриториальныхУсловиях(ДанныеМероприятия, ПараметрыФормирования, КадровыеДанныеСотрудников)
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
