#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ПачкаДокументовСПВ_2;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыгрузитьФайлыВоВременноеХранилище(Ссылка, УникальныйИдентификатор = Неопределено) Экспорт 
	
	ДанныеФайла = ЗарплатаКадры.ПолучитьДанныеФайла(Ссылка, УникальныйИдентификатор);
	
	ОписаниеВыгруженногоФайла = ПерсонифицированныйУчет.ОписаниеВыгруженногоФайлаОтчетности();
	
	ОписаниеВыгруженногоФайла.Владелец = Ссылка;
	ОписаниеВыгруженногоФайла.АдресВоВременномХранилище = ДанныеФайла.СсылкаНаДвоичныеДанныеФайла;
	ОписаниеВыгруженногоФайла.ИмяФайла = ДанныеФайла.ИмяФайла;
	ОписаниеВыгруженногоФайла.ПроверятьCheckXML = Истина;
	ОписаниеВыгруженногоФайла.ПроверятьCheckUFA = Истина;
	
	ВыгруженныеФайлы = Новый Массив;
	ВыгруженныеФайлы.Добавить(ОписаниеВыгруженногоФайла);
	
	Возврат ВыгруженныеФайлы;
	
КонецФункции

#Область ПроцедурыПолученияДанныхДляЗаполненияИПроведенияДокумента

Функция ДанныеДляЗаполненияДокумента(Организация, ОтчетныйПериод, Сотрудники, ДатаАктуальности = Неопределено) Экспорт	
	ДанныеДляЗаполнения = Новый Структура("Сотрудники, ЗаписиОСтаже");
	
	СписокФизическихЛиц = Новый Массив;	
	
	ТаблицаСотрудников = Новый ТаблицаЗначений;
	ТаблицаСотрудников.Колонки.Добавить("ФизическоеЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	ТаблицаСотрудников.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	Если ДатаАктуальности = Неопределено Тогда
		ДатаАктуальности =  ТекущаяДатаСеанса();
	КонецЕсли;	
	
	Для Каждого СтрокаКоллекции Из Сотрудники Цикл
		СтрокаТаблицы = ТаблицаСотрудников.Добавить();
		СтрокаТаблицы.ФизическоеЛицо = СтрокаКоллекции.Сотрудник;
		СтрокаТаблицы.Период = ?(ЗначениеЗаполнено(СтрокаКоллекции.ДатаСоставления), СтрокаКоллекции.ДатаСоставления, ДатаАктуальности);
		
		СписокФизическихЛиц.Добавить(СтрокаТаблицы.ФизическоеЛицо);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаСотрудников", ТаблицаСотрудников);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаСотрудников.ФизическоеЛицо,
	|	ТаблицаСотрудников.Период
	|ПОМЕСТИТЬ ВТФизическиеЛица
	|ИЗ
	|	&ТаблицаСотрудников КАК ТаблицаСотрудников";
	
	Запрос.Выполнить();
	
	ОкончаниеПериода = ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(ОтчетныйПериод);
	
	УчетСтраховыхВзносов.СформироватьВТДанныеОФактеНачисленияВзносовВПФР(
		Запрос.МенеджерВременныхТаблиц,
		Организация,
		ОтчетныйПериод,
		ОкончаниеПериода);
	
	ОписательВТ = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеФизическихЛиц(
						Запрос.МенеджерВременныхТаблиц,
						"ВТФизическиеЛица");
	
	КадровыйУчет.СоздатьВТКадровыеДанныеФизическихЛиц(
		ОписательВТ,
		Ложь, 
		"Фамилия, Имя, Отчество, СтраховойНомерПФР");	
	
	ПараметрыПолученияСтажа = ПерсонифицированныйУчет.ПараметрыДляСоздатьВТДанныеСтажаПФР();
	ПараметрыПолученияСтажа.ИсточникДанныхОСтаже = ПерсонифицированныйУчет.ВариантыИсточниковДанныхСтажа().ДанныеУчета;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФизическиеЛица.ФизическоеЛицо КАК Сотрудник,
	|	ФизическиеЛица.Период КАК ДатаСоставления,
	|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.Фамилия, """") КАК Фамилия,
	|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.Имя, """") КАК Имя,
	|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.Отчество, """") КАК Отчество,
	|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.СтраховойНомерПФР, """") КАК СтраховойНомерПФР,
	|	ЕСТЬNULL(ДанныеОФактеНачисленияВзносовВПФР.НачисленоНаОПС, ЛОЖЬ) КАК НачисленоНаОПС,
	|	ЕСТЬNULL(ДанныеОФактеНачисленияВзносовВПФР.НачисленоПоДополнительнымТарифам, ЛОЖЬ) КАК НачисленоПоДополнительнымТарифам
	|ИЗ
	|	ВТФизическиеЛица КАК ФизическиеЛица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеФизическихЛиц
	|		ПО ФизическиеЛица.ФизическоеЛицо = КадровыеДанныеФизическихЛиц.ФизическоеЛицо
	|			И ФизическиеЛица.Период = КадровыеДанныеФизическихЛиц.Период
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДанныеОФактеНачисленияВзносов КАК ДанныеОФактеНачисленияВзносовВПФР
	|		ПО ФизическиеЛица.ФизическоеЛицо = ДанныеОФактеНачисленияВзносовВПФР.ФизическоеЛицо";
	
	ДанныеДляЗаполнения.Сотрудники = Запрос.Выполнить().Выгрузить();
	
	ПараметрыОтбораСтажа = ПерсонифицированныйУчет.СтруктураОтбораДанныхДляКвартальнойОтчетности();
	ПараметрыОтбораСтажа.СписокФизическихЛиц = СписокФизическихЛиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ПерсонифицированныйУчет.СоздатьВТДанныеСтажаПФР(
		Запрос.МенеджерВременныхТаблиц, 
		Организация, 
		ОтчетныйПериод, 
		ПараметрыПолученияСтажа, 
		ПараметрыОтбораСтажа);
		
	Запрос.УстановитьПараметр("ТаблицаСотрудников", ТаблицаСотрудников);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаСотрудников.ФизическоеЛицо,
	|	ТаблицаСотрудников.Период
	|ПОМЕСТИТЬ ВТФизическиеЛицаДатыСоставления
	|ИЗ
	|	&ТаблицаСотрудников КАК ТаблицаСотрудников
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаписиСтажаПоДаннымУчета.ФизическоеЛицо КАК Сотрудник,
	|	ЗаписиСтажаПоДаннымУчета.ДатаНачалаПериода,
	|	ВЫБОР
	|		КОГДА ЗаписиСтажаПоДаннымУчета.ДатаОкончанияПериода > ФизическиеЛица.Период
	|			ТОГДА ФизическиеЛица.Период
	|		ИНАЧЕ ЗаписиСтажаПоДаннымУчета.ДатаОкончанияПериода
	|	КОНЕЦ КАК ДатаОкончанияПериода,
	|	ЗаписиСтажаПоДаннымУчета.ТипДоговора,
	|	ЗаписиСтажаПоДаннымУчета.ОсобыеУсловияТруда,
	|	ЗаписиСтажаПоДаннымУчета.КодПозицииСписка,
	|	ЗаписиСтажаПоДаннымУчета.ТретийПараметрИсчисляемогоСтажа,
	|	ЗаписиСтажаПоДаннымУчета.ОснованиеВыслугиЛет,
	|	ЗаписиСтажаПоДаннымУчета.ТерриториальныеУсловия,
	|	ЗаписиСтажаПоДаннымУчета.ПараметрТерриториальныхУсловий,
	|	ЗаписиСтажаПоДаннымУчета.ТретийПараметрВыслугиЛет,
	|	ЗаписиСтажаПоДаннымУчета.ОснованиеИсчисляемогоСтажа,
	|	ЗаписиСтажаПоДаннымУчета.ПервыйПараметрИсчисляемогоСтажа,
	|	ЗаписиСтажаПоДаннымУчета.ВторойПараметрИсчисляемогоСтажа,
	|	ЗаписиСтажаПоДаннымУчета.ПервыйПараметрВыслугиЛет,
	|	ЗаписиСтажаПоДаннымУчета.ВторойПараметрВыслугиЛет,
	|	ЗаписиСтажаПоДаннымУчета.ФиксСтаж
	|ИЗ
	|	ВТФизическиеЛицаДатыСоставления КАК ФизическиеЛица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЗаписиСтажаПоДаннымУчета КАК ЗаписиСтажаПоДаннымУчета
	|		ПО ФизическиеЛица.ФизическоеЛицо = ЗаписиСтажаПоДаннымУчета.ФизическоеЛицо
	|			И ФизическиеЛица.Период >= ЗаписиСтажаПоДаннымУчета.ДатаНачалаПериода";
	
	ДанныеДляЗаполнения.ЗаписиОСтаже = Запрос.Выполнить().Выгрузить();
	
	Возврат ДанныеДляЗаполнения;
	
КонецФункции	

Функция СформироватьЗапросПоЗаписямСтажаДляПечати(МассивСсылок) Экспорт 
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПачкаДокументовСПВ_2Сотрудники.НомерСтроки КАК НомерСтроки,
	|	ПачкаДокументовСПВ_2Сотрудники.Сотрудник,
	|	ПачкаДокументовСПВ_2Сотрудники.СтраховойНомерПФР,
	|	ПачкаДокументовСПВ_2Сотрудники.Фамилия,
	|	ПачкаДокументовСПВ_2Сотрудники.Имя,
	|	ПачкаДокументовСПВ_2Сотрудники.Отчество,
	|	ПачкаДокументовСПВ_2Сотрудники.НачисленоНаОПС,
	|	ПачкаДокументовСПВ_2Сотрудники.НачисленоПоДополнительнымТарифам,
	|	ПачкаДокументовСПВ_2Сотрудники.Ссылка КАК Ссылка,
	|	ПачкаДокументовСПВ_2Сотрудники.ДатаСоставления
	|ПОМЕСТИТЬ ВТСотрудникДокумента
	|ИЗ
	|	Документ.ПачкаДокументовСПВ_2.Сотрудники КАК ПачкаДокументовСПВ_2Сотрудники
	|ГДЕ
	|	ПачкаДокументовСПВ_2Сотрудники.Ссылка В(&МассивСсылок)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаписиОСтаже.НомерОсновнойЗаписи КАК НомерОсновнойЗаписи,
	|	ЗаписиОСтаже.НомерДополнительнойЗаписи КАК НомерДополнительнойЗаписи,
	|	ЗаписиОСтаже.ДатаНачалаПериода,
	|	ЗаписиОСтаже.ДатаОкончанияПериода,
	|	ЗаписиОСтаже.ТерриториальныеУсловия,
	|	ЗаписиОСтаже.ТерриториальныеУсловия.Код КАК ТерриториальныеУсловияКод,
	|	ЗаписиОСтаже.ПараметрТерриториальныхУсловий КАК ПараметрТерриториальныхУсловий,
	|	ЗаписиОСтаже.ОсобыеУсловияТруда,
	|	ЗаписиОСтаже.ОсобыеУсловияТруда.КодДляОтчетности2010 КАК ОсобыеУсловияТрудаКод,
	|	ЗаписиОСтаже.КодПозицииСписка.Код КАК КодПозицииСпискаКод,
	|	ЗаписиОСтаже.ОснованиеИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ОснованиеИсчисляемогоСтажа.Код КАК ОснованиеИсчисляемогоСтажаКод,
	|	ЗаписиОСтаже.ПервыйПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ВторойПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа.Код КАК ТретийПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ОснованиеВыслугиЛет,
	|	ЗаписиОСтаже.ОснованиеВыслугиЛет.КодДляОтчетности2010 КАК ОснованиеВыслугиЛетКод,
	|	ЗаписиОСтаже.ПервыйПараметрВыслугиЛет,
	|	ЗаписиОСтаже.ВторойПараметрВыслугиЛет,
	|	ЗаписиОСтаже.ТретийПараметрВыслугиЛет,
	|	ПачкаДокументовСПВ_2Сотрудники.НомерСтроки КАК НомерСтроки,
	|	ПачкаДокументовСПВ_2Сотрудники.Сотрудник,
	|	ПачкаДокументовСПВ_2Сотрудники.СтраховойНомерПФР,
	|	ПачкаДокументовСПВ_2Сотрудники.Фамилия,
	|	ПачкаДокументовСПВ_2Сотрудники.Имя,
	|	ПачкаДокументовСПВ_2Сотрудники.Отчество,
	|	ПачкаДокументовСПВ_2Сотрудники.НачисленоНаОПС,
	|	ПачкаДокументовСПВ_2Сотрудники.НачисленоПоДополнительнымТарифам,
	|	ПачкаДокументовСПВ_2Сотрудники.Ссылка КАК Ссылка,
	|	ПачкаДокументовСПВ_2Сотрудники.ДатаСоставления
	|ИЗ
	|	ВТСотрудникДокумента КАК ПачкаДокументовСПВ_2Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПачкаДокументовСПВ_2.ЗаписиОСтаже КАК ЗаписиОСтаже
	|		ПО ПачкаДокументовСПВ_2Сотрудники.Сотрудник = ЗаписиОСтаже.Сотрудник
	|			И ПачкаДокументовСПВ_2Сотрудники.Ссылка = ЗаписиОСтаже.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки,
	|	НомерОсновнойЗаписи,
	|	НомерДополнительнойЗаписи";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция СформироватьЗапросПоШапкеДляПечати(МассивСсылок)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	ОписаниеИсточникаДанных = ПерсонифицированныйУчет.ОписаниеИсточникаДанныхДляСоздатьВТСведенияОбОрганизациях();
	ОписаниеИсточникаДанных.ИмяТаблицы = "Документ.ПачкаДокументовСПВ_2";
	ОписаниеИсточникаДанных.ИмяПоляОрганизация = "Организация";
	ОписаниеИсточникаДанных.ИмяПоляПериод = "ОкончаниеОтчетногоПериода";
	ОписаниеИсточникаДанных.СписокСсылок = МассивСсылок;

	ПерсонифицированныйУчет.СоздатьВТСведенияОбОрганизацияхПоОписаниюДокументаИсточникаДанных(Запрос.МенеджерВременныхТаблиц, ОписаниеИсточникаДанных);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПачкаДокументовСПВ_2.Ссылка КАК Ссылка,
	|	ПачкаДокументовСПВ_2.Организация КАК Организация,
	|	СведенияОбОрганизациях.НаименованиеСокращенное КАК НаименованиеОрганизации,
	|	СведенияОбОрганизациях.РегистрационныйНомерПФР КАК РегистрационныйНомерПФР,
	|	СведенияОбОрганизациях.ИНН КАК ИНН,
	|	СведенияОбОрганизациях.КПП КАК КПП,
	|	ПачкаДокументовСПВ_2.КатегорияЗастрахованныхЛиц КАК КатегорияЗастрахованныхЛиц,
	|	ПачкаДокументовСПВ_2.ОтчетныйПериод,
	|	ПачкаДокументовСПВ_2.ОкончаниеОтчетногоПериода,
	|	ПачкаДокументовСПВ_2.ТипСведенийСЗВ,
	|	ПачкаДокументовСПВ_2.КорректируемыйПериод КАК КорректируемыйПериод,
	|	ПачкаДокументовСПВ_2.Руководитель КАК Руководитель,
	|	ПачкаДокументовСПВ_2.ДолжностьРуководителя.Наименование КАК ДолжностьРуководителя,
	|	ПачкаДокументовСПВ_2.Дата,
	|	ПачкаДокументовСПВ_2.НомерПачки,
	|	СведенияОбОрганизациях.КодПоОКПО КАК КодПоОКПО
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.ПачкаДокументовСПВ_2 КАК ПачкаДокументовСПВ_2
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСведенияОбОрганизациях КАК СведенияОбОрганизациях
	|		ПО ПачкаДокументовСПВ_2.Организация = СведенияОбОрганизациях.Организация
	|			И ПачкаДокументовСПВ_2.ОкончаниеОтчетногоПериода = СведенияОбОрганизациях.Период
	|ГДЕ
	|	ПачкаДокументовСПВ_2.Ссылка В(&МассивСсылок)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка,
	|	Руководитель";
	Запрос.Выполнить();
	
	ИменаПолейОтветственныхЛиц = Новый Массив;
	ИменаПолейОтветственныхЛиц.Добавить("Руководитель");
	
	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Ложь, ИменаПолейОтветственныхЛиц, "ВТДанныеДокументов");
		
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПачкаДокументовСПВ_2.Ссылка КАК Ссылка,
	|	ПачкаДокументовСПВ_2.РегистрационныйНомерПФР КАК РегНомерПФР,
	|	ПачкаДокументовСПВ_2.НаименованиеОрганизации КАК НаименованиеОрганизации,
	|	ПачкаДокументовСПВ_2.ИНН КАК ИНН,
	|	ПачкаДокументовСПВ_2.КПП КАК КПП,
	|	ПачкаДокументовСПВ_2.КатегорияЗастрахованныхЛиц КАК КатегорияЗастрахованныхЛиц,
	|	ПачкаДокументовСПВ_2.ОтчетныйПериод,
	|	ПачкаДокументовСПВ_2.ТипСведенийСЗВ,
	|	ПачкаДокументовСПВ_2.КорректируемыйПериод,
	|	ЕСТЬNULL(ВТФИОПоследние.РасшифровкаПодписи, """") КАК Руководитель,
	|	ПачкаДокументовСПВ_2.ДолжностьРуководителя КАК ДолжностьРуководителя,
	|	ПачкаДокументовСПВ_2.Дата,
	|	ПачкаДокументовСПВ_2.НомерПачки,
	|	ПачкаДокументовСПВ_2.КодПоОКПО КАК ОКПО,
	|	ПачкаДокументовСПВ_2.КорректируемыйПериод КАК КорректируемыйПериод1
	|ИЗ
	|	ВТДанныеДокументов КАК ПачкаДокументовСПВ_2
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОПоследние
	|		ПО ПачкаДокументовСПВ_2.Ссылка = ВТФИОПоследние.Ссылка
	|			И ПачкаДокументовСПВ_2.Руководитель = ВТФИОПоследние.ФизическоеЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

#КонецОбласти

#Область ПроцедурыФормированияФайла

Функция СформироватьЗапросПоШапке(Ссылка) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Установим параметры запроса.
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	
	ОписаниеИсточникаДанных = ПерсонифицированныйУчет.ОписаниеИсточникаДанныхДляСоздатьВТСведенияОбОрганизациях();
	ОписаниеИсточникаДанных.ИмяТаблицы = "Документ.ПачкаДокументовСПВ_2";
	ОписаниеИсточникаДанных.ИмяПоляОрганизация = "Организация";
	ОписаниеИсточникаДанных.ИмяПоляПериод = "ОкончаниеОтчетногоПериода";
	ОписаниеИсточникаДанных.СписокСсылок = Ссылка;

	ПерсонифицированныйУчет.СоздатьВТСведенияОбОрганизацияхПоОписаниюДокументаИсточникаДанных(Запрос.МенеджерВременныхТаблиц, ОписаниеИсточникаДанных);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(Застрахованные.НомерСтроки) КАК Количество
	|ПОМЕСТИТЬ ВТИтоги
	|ИЗ
	|	Документ.ПачкаДокументовСПВ_2.Сотрудники КАК Застрахованные
	|ГДЕ
	|	Застрахованные.Ссылка = &ДокументСсылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПачкаДокументовСПВ_2.Ссылка,
	|	ПачкаДокументовСПВ_2.Номер,
	|	ПачкаДокументовСПВ_2.Дата,
	|	ПачкаДокументовСПВ_2.Проведен,
	|	ПачкаДокументовСПВ_2.Организация,
	|	ПачкаДокументовСПВ_2.КатегорияЗастрахованныхЛиц,
	|	ПачкаДокументовСПВ_2.ОтчетныйПериод,
	|	ПачкаДокументовСПВ_2.ТипСведенийСЗВ,
	|	ПачкаДокументовСПВ_2.НомерПачки,
	|	ПачкаДокументовСПВ_2.ДокументПринятВПФР,
	|	ПачкаДокументовСПВ_2.Ответственный,
	|	ПачкаДокументовСПВ_2.ДолжностьРуководителя.Наименование КАК РуководительДолжность,
	|	СведенияОбОрганизациях.Наименование,
	|	СведенияОбОрганизациях.ЮридическоеФизическоеЛицо КАК ЮридическоеФизическоеЛицо,
	|	СведенияОбОрганизациях.ОГРН,
	|	СведенияОбОрганизациях.КодПоОКПО,
	|	СведенияОбОрганизациях.НаименованиеПолное,
	|	СведенияОбОрганизациях.НаименованиеСокращенное,
	|	СведенияОбОрганизациях.РегистрационныйНомерПФР КАК РегистрационныйНомерПФР,
	|	СведенияОбОрганизациях.РайонныйКоэффициент,
	|	СведенияОбОрганизациях.ИНН,
	|	СведенияОбОрганизациях.КПП,
	|	СведенияОбОрганизациях.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ГОД(ПачкаДокументовСПВ_2.ОтчетныйПериод) КАК Год,
	|	СведенияОбОрганизациях.КодПоОКПО КАК ОКПО,
	|	""СПВ-1"" КАК ТипФормДокументов,
	|	ЕСТЬNULL(Итоги.Количество, 0) КАК Количество,
	|	ПачкаДокументовСПВ_2.ИмяФайлаДляПФР,
	|	ПачкаДокументовСПВ_2.КорректируемыйПериод КАК КорректируемыйПериод
	|ИЗ
	|	Документ.ПачкаДокументовСПВ_2 КАК ПачкаДокументовСПВ_2
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСведенияОбОрганизациях КАК СведенияОбОрганизациях
	|		ПО ПачкаДокументовСПВ_2.Организация = СведенияОбОрганизациях.Организация
	|			И ПачкаДокументовСПВ_2.ОкончаниеОтчетногоПериода = СведенияОбОрганизациях.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТИтоги КАК ИТОГИ
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ПачкаДокументовСПВ_2.Ссылка = &ДокументСсылка";

	Возврат Запрос.Выполнить();
	
КонецФункции

Функция СформироватьЗапросПоЗаписямСтажа(Ссылка) Экспорт 
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПачкаДокументовСПВ_2Сотрудники.НомерСтроки КАК НомерСтроки,
	|	ПачкаДокументовСПВ_2Сотрудники.Сотрудник,
	|	ПачкаДокументовСПВ_2Сотрудники.СтраховойНомерПФР,
	|	ПачкаДокументовСПВ_2Сотрудники.Фамилия,
	|	ПачкаДокументовСПВ_2Сотрудники.Имя,
	|	ПачкаДокументовСПВ_2Сотрудники.Отчество,
	|	ПачкаДокументовСПВ_2Сотрудники.НачисленоНаОПС,
	|	ПачкаДокументовСПВ_2Сотрудники.НачисленоПоДополнительнымТарифам,
	|	ПачкаДокументовСПВ_2Сотрудники.ДатаСоставления
	|ПОМЕСТИТЬ ВТСотрудникиДокумента
	|ИЗ
	|	Документ.ПачкаДокументовСПВ_2.Сотрудники КАК ПачкаДокументовСПВ_2Сотрудники
	|ГДЕ
	|	ПачкаДокументовСПВ_2Сотрудники.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаписиОСтаже.НомерОсновнойЗаписи КАК НомерОсновнойЗаписи,
	|	ЗаписиОСтаже.НомерДополнительнойЗаписи КАК НомерДополнительнойЗаписи,
	|	ЗаписиОСтаже.ДатаНачалаПериода,
	|	ЗаписиОСтаже.ДатаОкончанияПериода,
	|	ЗаписиОСтаже.ТерриториальныеУсловия,
	|	ЗаписиОСтаже.ТерриториальныеУсловия.Код,
	|	ЗаписиОСтаже.ПараметрТерриториальныхУсловий КАК ТерриториальныеУсловияСтавка,
	|	ЗаписиОСтаже.ОсобыеУсловияТруда,
	|	ЗаписиОСтаже.ОсобыеУсловияТруда.КодДляОтчетности2010 КАК ОсобыеУсловияТрудаКод,
	|	ЗаписиОСтаже.КодПозицииСписка,
	|	ЗаписиОСтаже.КодПозицииСписка.Код КАК КодПозицииСпискаКод,
	|	ЗаписиОСтаже.ОснованиеИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ОснованиеИсчисляемогоСтажа.Код КАК ОснованиеИсчисляемогоСтажаКод,
	|	ЗаписиОСтаже.ПервыйПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ВторойПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа.Код КАК ТретийПараметрИсчисляемогоСтажаКод,
	|	ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа КАК ТретийПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ОснованиеВыслугиЛет,
	|	ЗаписиОСтаже.ОснованиеВыслугиЛет.КодДляОтчетности2010 КАК ОснованиеВыслугиЛетКод,
	|	ЗаписиОСтаже.ПервыйПараметрВыслугиЛет,
	|	ЗаписиОСтаже.ВторойПараметрВыслугиЛет,
	|	ЗаписиОСтаже.ТретийПараметрВыслугиЛет,
	|	ПачкаДокументовСПВ_2Сотрудники.НомерСтроки КАК НомерСтроки,
	|	ПачкаДокументовСПВ_2Сотрудники.Сотрудник,
	|	ПачкаДокументовСПВ_2Сотрудники.СтраховойНомерПФР,
	|	ПачкаДокументовСПВ_2Сотрудники.Фамилия,
	|	ПачкаДокументовСПВ_2Сотрудники.Имя,
	|	ПачкаДокументовСПВ_2Сотрудники.Отчество,
	|	ПачкаДокументовСПВ_2Сотрудники.НачисленоНаОПС,
	|	ПачкаДокументовСПВ_2Сотрудники.НачисленоПоДополнительнымТарифам,
	|	ПачкаДокументовСПВ_2Сотрудники.ДатаСоставления
	|ИЗ
	|	ВТСотрудникиДокумента КАК ПачкаДокументовСПВ_2Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПачкаДокументовСПВ_2.ЗаписиОСтаже КАК ЗаписиОСтаже
	|		ПО ПачкаДокументовСПВ_2Сотрудники.Сотрудник = ЗаписиОСтаже.Сотрудник
	|			И (ЗаписиОСтаже.Ссылка = &Ссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки,
	|	НомерОсновнойЗаписи,
	|	НомерДополнительнойЗаписи";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура ОбработкаФормированияФайла(Объект) Экспорт
	
	ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапке(Объект.Ссылка).Выбрать();
	РезультатЗапросаПоЗаписямСтажа = СформироватьЗапросПоЗаписямСтажа(Объект.Ссылка).Выбрать();
	
	ВыборкаПоШапкеДокумента.Следующий();
	
	ТекстФайла = ТекстФайла(ВыборкаПоШапкеДокумента, РезультатЗапросаПоЗаписямСтажа);
	
	ЗарплатаКадры.ЗаписатьФайлВАрхив(Объект.Ссылка, ВыборкаПоШапкеДокумента.ИмяФайлаДляПФР, ТекстФайла);
	
КонецПроцедуры

Функция ТекстФайла(ВыборкаПоШапкеДокумента, ВыборкаПоСотрудникам)
	
	ДеревоФорматаXML = ПолучитьОбщийМакет("ФорматПФР70_2010XML");
	ТекстФорматаXML = ДеревоФорматаXML.ПолучитьТекст();
	
	ДеревоФормата = ЗарплатаКадры.ЗагрузитьXMLВДокументDOM(ТекстФорматаXML);

	ДатаЗаполнения 			= ВыборкаПоШапкеДокумента.Дата;
	ТипФормДокументов		= ВыборкаПоШапкеДокумента.ТипФормДокументов;
	НомерПачки				= ВыборкаПоШапкеДокумента.НомерПачки;
	Ссылка					= ВыборкаПоШапкеДокумента.Ссылка;

	// Загружаем формат файла сведений.
	ТипДокументовПачки = "СВЕДЕНИЯ_О_СТРАХОВОМ_СТАЖЕ_ЗЛ_ДЛЯ_УСТАНОВЛЕНИЯ_ПЕНСИИ";
	
	// Создаем начальное дерево
	ДеревоВыгрузки = ЗарплатаКадры.СоздатьДеревоXML();
	УзелПФР = ПерсонифицированныйУчет.УзелФайлаПФР(ДеревоВыгрузки);
	ПерсонифицированныйУчет.ЗаполнитьИмяИЗаголовокФайла(УзелПФР, ДеревоФормата, ВыборкаПоШапкеДокумента.ИмяФайлаДляПФР);
	УзелПачкаВходящихДокументов = ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелПФР, "ПачкаВходящихДокументов", "", );
	
	// Добавляем ветки ПачкаВходящихДокументов и ВходящаяОпись.
	// Добавляем ветку ВХОДЯЩАЯ_ОПИСЬ.
	
	ДанныеВходящейОписи = ЗарплатаКадры.ЗагрузитьФорматНабораЗаписей(ДеревоФормата, "ВХОДЯЩАЯ_ОПИСЬ_ДЛЯ_ОПИСИ");
	
	ДанныеВходящейОписи.НомерВПачке.Значение = 1;
	ДанныеВходящейОписи.НомерПачки.Значение.Основной = Формат(ВыборкаПоШапкеДокумента.НомерПачки, "ЧГ="); 
	ДанныеВходящейОписи.ДатаСоставления.Значение = ВыборкаПоШапкеДокумента.Дата;
	ПерсонифицированныйУчет.ЗаполнитьСоставительПачки(ДанныеВходящейОписи.СоставительПачки.Значение, ВыборкаПоШапкеДокумента); // ОрганизацияЮрФизЛицо, ОрганизацияИНН, ОрганизацияКПП, ОрганизацияОГРН, ОрганизацияНаименованиеОКОПФ, ОрганизацияНаименованиеПолное, ОрганизацияНаименованиеСокращенное
	
	// заполним состав документов
	НаборЗаписейСоставДокументов = ДанныеВходящейОписи.СоставДокументов.Значение;
	НаборЗаписейСоставДокументов.Количество.Значение = 1;
	НаборЗаписейНаличиеДокументов = НаборЗаписейСоставДокументов.НаличиеДокументов.Значение;
	НаборЗаписейНаличиеДокументов.ТипДокумента = ТипДокументовПачки;
	НаборЗаписейНаличиеДокументов.Количество = ВыборкаПоШапкеДокумента.Количество;
	
	ДанныеНабораВходящаяОпись = ОбщегоНазначения.СкопироватьРекурсивно(ДанныеВходящейОписи);
	
	ЗарплатаКадры.ДобавитьИнформациюВДерево(ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелПачкаВходящихДокументов, "ВХОДЯЩАЯ_ОПИСЬ",""), ДанныеВходящейОписи);
	
	ФорматСПВ = ЗарплатаКадры.ЗагрузитьФорматНабораЗаписей(ДеревоФормата, "СПВ_2");
	
	ФорматПризнакНачисленияВзносовОПС = Новый Структура("ПризнакНачисленияВзносовОПС", ОбщегоНазначения.СкопироватьРекурсивно(ФорматСПВ.ПризнакНачисленияВзносовОПС));
	ФорматСПВ.Удалить("ПризнакНачисленияВзносовОПС");
	ФорматПризнакНачисленияВзносовПоДопТарифу = Новый Структура("ПризнакНачисленияВзносовПоДопТарифу", ОбщегоНазначения.СкопироватьРекурсивно(ФорматСПВ.ПризнакНачисленияВзносовПоДопТарифу));
	ФорматСПВ.Удалить("ПризнакНачисленияВзносовПоДопТарифу");
	
	Если ВыборкаПоШапкеДокумента.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ Тогда
		ФорматСПВ.Удалить("КорректируемыйОтчетныйПериод");
	ИначеЕсли ВыборкаПоШапкеДокумента.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ Тогда
		ФорматСПВ.Удалить("СтажевыйПериод");
	КонецЕсли;
	
	Если Не ЗарплатаКадры.ЭтоЮридическоеЛицо(ВыборкаПоШапкеДокумента.Организация) Тогда
		ФорматСПВ.Удалить("КПП");
		ТаблицаПолей = ФорматСПВ.НалоговыйНомер.Поля;
		ТаблицаПолей.Индексы.Добавить("ИмяПоля");
		СтрокаКПП = ТаблицаПолей.Найти("КПП", "ИмяПоля");
		Если СтрокаКПП <> Неопределено Тогда
			ТаблицаПолей.Удалить(СтрокаКПП);
		КонецЕсли;
	КонецЕсли;
	
	// Общие данные пачки - берем их из описи и заполняем одинаково для всех.
	СоставительПачки = ДанныеНабораВходящаяОпись.СоставительПачки.Значение;
	ФорматСПВ.РегистрационныйНомер.Значение = СоставительПачки.РегистрационныйНомер.Значение;
	ФорматСПВ.НаименованиеКраткое.Значение = СоставительПачки.НаименованиеКраткое.Значение;
	ФорматСПВ.НалоговыйНомер.Значение = СоставительПачки.НалоговыйНомер.Значение;
	
	ФорматСПВ.ТипСведений.Значение = Строка(ВыборкаПоШапкеДокумента.ТипСведенийСЗВ);
	Если ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.КатегорияЗастрахованныхЛиц) Тогда 
		ФорматСПВ.КодКатегории.Значение = ОбщегоНазначения.ИмяЗначенияПеречисления(ВыборкаПоШапкеДокумента.КатегорияЗастрахованныхЛиц);
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ФорматСПВ.ОтчетныйПериод.Значение, ПерсонифицированныйУчет.ОписаниеОтчетногоПериодаДляФайла2014(ВыборкаПоШапкеДокумента.ОтчетныйПериод));
	Если  ВыборкаПоШапкеДокумента.ТипСведенийСЗВ <> Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ Тогда
		ЗаполнитьЗначенияСвойств(ФорматСПВ.КорректируемыйОтчетныйПериод.Значение, ПерсонифицированныйУчет.ОписаниеОтчетногоПериодаДляФайла2014(ВыборкаПоШапкеДокумента.КорректируемыйПериод));
	КонецЕсли;
	ФорматСПВ.ДатаЗаполнения.Значение = ВыборкаПоШапкеДокумента.Дата;
	
	Если ВыборкаПоШапкеДокумента.ТипСведенийСЗВ <> Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ Тогда
		ФорматСтажевыйПериод = ФорматСПВ.СтажевыйПериод.Значение;
		ФорматСПВ.СтажевыйПериод.НеВыводитьВФайл = Истина;
	КонецЕсли;
	
	НомерДокументаВПачке = 1;
	Пока ВыборкаПоСотрудникам.СледующийПоЗначениюПоля("НомерСтроки")	Цикл		
		ДанныеШапки = ОбщегоНазначения.СкопироватьРекурсивно(ФорматСПВ);
			
		НомерДокументаВПачке = НомерДокументаВПачке + 1;
		
		Фамилия = СокрЛП(ВыборкаПоСотрудникам.Фамилия);
		Имя = СокрЛП(ВыборкаПоСотрудникам.Имя);
		Отчество = СокрЛП(ВыборкаПоСотрудникам.Отчество);
		
		ДанныеШапки.НомерВПачке.Значение = НомерДокументаВПачке;
		ДанныеШапки.СтраховойНомер.Значение = ВыборкаПоСотрудникам.СтраховойНомерПФР;
		НаборЗаписейФИО = ДанныеШапки.ФИО.Значение;
		НаборЗаписейФИО.Фамилия = ВРег(Фамилия);
		НаборЗаписейФИО.Имя = ВРег(Имя);
		НаборЗаписейФИО.Отчество = ВРег(Отчество);
		
		ДанныеШапки.ДатаСоставленияНа.Значение = ВыборкаПоСотрудникам.ДатаСоставления; 
		
		// Заполнение отменяющей формы завершено.
		Если ВыборкаПоШапкеДокумента.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ Тогда
			ЗарплатаКадры.ДобавитьИнформациюВДерево(ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелПачкаВходящихДокументов, ТипДокументовПачки,""), ДанныеШапки);
			Продолжить;
		КонецЕсли;

		// Выводим стаж
						
		УзелСПВ2 = ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелПачкаВходящихДокументов, ТипДокументовПачки,"");
		ЗарплатаКадры.ДобавитьИнформациюВДерево(УзелСПВ2, ДанныеШапки);

		ПерсонифицированныйУчет.ВписатьЗаписиОСтажеВНаборДанных2014(УзелСПВ2, ФорматСтажевыйПериод, ВыборкаПоСотрудникам);
		
		ФорматПризнакНачисленияВзносовОПС.ПризнакНачисленияВзносовОПС.Значение = ВРег(Формат(ВыборкаПоСотрудникам.НачисленоНаОПС,"БЛ=Нет; БИ=Да"));
		ФорматПризнакНачисленияВзносовПоДопТарифу.ПризнакНачисленияВзносовПоДопТарифу.Значение = ВРег(Формат(ВыборкаПоСотрудникам.НачисленоПоДополнительнымТарифам,"БЛ=Нет; БИ=Да"));
		
		ЗарплатаКадры.ДобавитьИнформациюВДерево(УзелСПВ2, ФорматПризнакНачисленияВзносовОПС);
		ЗарплатаКадры.ДобавитьИнформациюВДерево(УзелСПВ2, ФорматПризнакНачисленияВзносовПоДопТарифу);
	КонецЦикла;
		
	// Преобразуем дерево в строковое описание XML.
	ТекстФайла = ПерсонифицированныйУчет.ПолучитьТекстФайлаИзДереваЗначений(ДеревоВыгрузки);
	Возврат ТекстФайла
	
КонецФункции

#КонецОбласти

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// СПВ-1
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ФормаСПВ_2";
	КомандаПечати.Представление = НСтр("ru = 'СПВ-2';
										|en = 'SPV-2'");
	КомандаПечати.Порядок = 10;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	
	// АДВ-6-3
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ФормаАДВ_6_1";
	КомандаПечати.Представление = НСтр("ru = 'АДВ-6-1';
										|en = 'ADV-6-1'");
	КомандаПечати.Порядок = 20;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	
	// Все формы
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ФормаСПВ_2,ФормаАДВ_6_1";
	КомандаПечати.Представление = НСтр("ru = 'Все формы';
										|en = 'All forms'");
	КомандаПечати.Порядок = 30;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт	
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ФормаСПВ_2") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ФормаСПВ_2", "Форма СПВ-2", СформироватьПечатнуюФормуСПВ_2(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ФормаАДВ_6_1") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ФормаАДВ_6_1", "Форма АДВ-6-1", СформироватьПечатнуюФормуАДВ_6_1(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуСПВ_2(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПачкаДокументовСПВ_2_Форма_СПВ_2";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПачкаДокументовСПВ_2.ПФ_MXL_ФормаСПВ_2");
	
	ВыборкаДокументов = СформироватьЗапросПоШапкеДляПечати(МассивОбъектов).Выбрать();
	
	ВыборкаЗаписейСтажа = СформироватьЗапросПоЗаписямСтажаДляПечати(МассивОбъектов).Выбрать();
	
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьСтрокаВзносы = Макет.ПолучитьОбласть("СтрокаВзносов");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапка  = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтаж   = Макет.ПолучитьОбласть("Стаж");
	
	Пока ВыборкаДокументов.СледующийПоЗначениюПоля("Ссылка") Цикл
		ВыборкаЗаписейСтажа.Сбросить();
		
		СтруктураПоиска = Новый Структура("Ссылка", ВыборкаДокументов.Ссылка);
		
		Если ВыборкаЗаписейСтажа.НайтиСледующий(СтруктураПоиска) Тогда
			ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры, ВыборкаДокументов, "РегНомерПФР, ИНН, КПП, ОКПО");
			
			ОбластьШапка.Параметры.НаименованиеОрганизации = ПерсонифицированныйУчет.СтрокаВОтчет(ВыборкаДокументов.НаименованиеОрганизации);
			
			ОбластьШапка.Параметры.КодКатегории = ПерсонифицированныйУчет.ПолучитьИмяЭлементаПеречисленияПоЗначению(ВыборкаДокументов.КатегорияЗастрахованныхЛиц);
			
			ОтчетныйПериод = ВыборкаДокументов.ОтчетныйПериод;
			КорректируемыйПериод = ВыборкаДокументов.КорректируемыйПериод;
			
			Если Месяц(ОтчетныйПериод) = 10 Тогда
				ОбластьШапка.Параметры.КодОтчетногоПериода = 0;
			Иначе	
				ОбластьШапка.Параметры.КодОтчетногоПериода = Месяц(ОтчетныйПериод) + 2;
			КонецЕсли;	
						
			ОбластьШапка.Параметры.ДатаСоставления = ПерсонифицированныйУчет.ДатаВОтчет(ВыборкаЗаписейСтажа.ДатаСоставления);
			
			ОбластьШапка.Параметры.ОтчетныйГод = Формат(Год(ОтчетныйПериод), "ЧГ=");
			
			ОбластьШапка.Параметры.ЭтоИсходныйДокумент = ВыборкаДокументов.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ;
			ОбластьШапка.Параметры.ЭтоКорректирующийДокумент = ВыборкаДокументов.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.КОРРЕКТИРУЮЩАЯ;
			ОбластьШапка.Параметры.ЭтоОтменяющийДокумент     = ВыборкаДокументов.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ;
			
			Если  ВыборкаДокументов.ТипСведенийСЗВ <> Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ Тогда
				Если Месяц(КорректируемыйПериод) = 10 Тогда
					ОбластьШапка.Параметры.КодКорректируемогоПериода = 0;
				Иначе	
					ОбластьШапка.Параметры.КодКорректируемогоПериода = Месяц(КорректируемыйПериод) + 2;
				КонецЕсли;	
				
				ОбластьШапка.Параметры.ГодКорректируемогоПериода = Формат(Год(КорректируемыйПериод), "ЧГ=");
			КонецЕсли;	
			
			Если ВыборкаЗаписейСтажа.СледующийПоЗначениюПоля("Ссылка") Тогда 
				
				Пока ВыборкаЗаписейСтажа.СледующийПоЗначениюПоля("НомерСтроки") Цикл
					НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
					
					ТабличныйДокумент.Вывести(ОбластьШапка);
					
					ОбластьСтрока.Параметры.Фамилия = ВыборкаЗаписейСтажа.Фамилия;				
					ОбластьСтрока.Параметры.Имя = ВыборкаЗаписейСтажа.Имя;
					ОбластьСтрока.Параметры.Отчество = ВыборкаЗаписейСтажа.Отчество;
					ОбластьСтрока.Параметры.СтраховойНомерПФР = ВыборкаЗаписейСтажа.СтраховойНомерПФР;
					
					ТабличныйДокумент.Вывести(ОбластьСтрока);
					
					Если ЗначениеЗаполнено(ВыборкаЗаписейСтажа.НомерОсновнойЗаписи) Тогда
						НомерСтроки = 0;
						Пока ВыборкаЗаписейСтажа.СледующийПоЗначениюПоля("НомерОсновнойЗаписи") Цикл
							НомерСтроки = НомерСтроки + 1;
							
							ЗаполнитьОбластьСтаж(ВыборкаЗаписейСтажа, ОбластьСтаж, НомерСтроки);
							ТабличныйДокумент.Вывести(ОбластьСтаж);
							
							Пока ВыборкаЗаписейСтажа.СледующийПоЗначениюПоля("НомерДополнительнойЗаписи") Цикл
								Если ВыборкаЗаписейСтажа.НомерДополнительнойЗаписи = 0 Тогда
									Продолжить;
								КонецЕсли;
								
								НомерСтроки = НомерСтроки + 1;
								
								ЗаполнитьОбластьСтаж(ВыборкаЗаписейСтажа, ОбластьСтаж, НомерСтроки);
								ТабличныйДокумент.Вывести(ОбластьСтаж);
								
							КонецЦикла;
							
						КонецЦикла;
					КонецЕсли;
					
					ОбластьСтрокаВзносы.Параметры.НачисленоНаОПС = ВыборкаЗаписейСтажа.НачисленоНаОПС;
					ОбластьСтрокаВзносы.Параметры.НачисленоПоДополнительнымТарифам  = ВыборкаЗаписейСтажа.НачисленоПоДополнительнымТарифам;
							
					ТабличныйДокумент.Вывести(ОбластьСтрокаВзносы);

					ОбластьПодвал.Параметры.Руководитель = ВыборкаДокументов.Руководитель;
					ОбластьПодвал.Параметры.РуководительДолжность = ВыборкаДокументов.ДолжностьРуководителя;
					ОбластьПодвал.Параметры.ДатаСоставленияОписи  = ПерсонифицированныйУчет.ДатаВОтчет(ВыборкаДокументов.Дата);
					
					ТабличныйДокумент.Вывести(ОбластьПодвал);
					
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					
					УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументов.Ссылка);
					
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьОбластьСтаж(ВыборкаЗаписейСтажа, ОбластьСтаж, НомерСтроки)
	
	ОбластьСтаж.Параметры.НомерСтроки = НомерСтроки;
	ОбластьСтаж.Параметры.ДатаНачалаПериода = ВыборкаЗаписейСтажа.ДатаНачалаПериода;
	ОбластьСтаж.Параметры.ДатаОкончанияПериода = ВыборкаЗаписейСтажа.ДатаОкончанияПериода;
	
	ОбластьСтаж.Параметры.ТерриториальныеУсловияКод = ВыборкаЗаписейСтажа.ТерриториальныеУсловияКод;
	ОбластьСтаж.Параметры.ДопТУ = ПерсонифицированныйУчет.ПредставлениеПараметровТерриториальныхУсловий(ВыборкаЗаписейСтажа);
	ОбластьСтаж.Параметры.ОсобыеУсловияТрудаКод = ВыборкаЗаписейСтажа.ОсобыеУсловияТрудаКод;
	ОбластьСтаж.Параметры.КодПозицииСписка = ВыборкаЗаписейСтажа.КодПозицииСпискаКод;
	ОбластьСтаж.Параметры.ОснованиеИТС = ВыборкаЗаписейСтажа.ОснованиеИсчисляемогоСтажаКод;
	ОбластьСтаж.Параметры.ОснованиеВыслуги = ВыборкаЗаписейСтажа.ОснованиеВыслугиЛетКод;
	ОбластьСтаж.Параметры.ДопИТС = ПерсонифицированныйУчет.ПредставлениеПараметровИсчисляемогоТрудовогоСтажа(ВыборкаЗаписейСтажа);
	
	ПерсонифицированныйУчет.ПредставлениеПараметровПенсииЗаВыслугуЛет(ВыборкаЗаписейСтажа, ОбластьСтаж.Параметры.ДопВЛ, ОбластьСтаж.Параметры.ДопВЛСтавка);
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуАДВ_6_1(МассивОбъектов, ОбъектыПечати)
	
	Возврат ПерсонифицированныйУчет.ВывестиОписьАДВ6(МассивОбъектов, ОбъектыПечати, "СПВ_2");
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли