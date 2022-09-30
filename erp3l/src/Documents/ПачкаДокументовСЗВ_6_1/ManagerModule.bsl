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
	
	МетаданныеДокумента = Метаданные.Документы.ПачкаДокументовСЗВ_6_1;
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

Функция ПолучитьСтруктуруПроверяемыхДанных() Экспорт
	Возврат ПерсонифицированныйУчет.ДокументыСЗВПолучитьСтруктуруПроверяемыхДанных();
КонецФункции

Функция ПолучитьПредставленияПроверяемыхРеквизитов() Экспорт
	Возврат ПерсонифицированныйУчет.ПолучитьПредставленияПроверяемыхРеквизитов();
КонецФункции

Функция ПолучитьСоответствиеРеквизитовФормеОбъекта(ДанныеДляПроверки) Экспорт
	Возврат ПерсонифицированныйУчет.ДокументыСЗВПолучитьСоответствиеРеквизитовФормеОбъекта();
КонецФункции

Функция ПолучитьСоответствиеРеквизитовПутиВФормеОбъекта() Экспорт
	
	СоответствиеРеквизитовПутиВФормеОбъекта = ПерсонифицированныйУчет.ПолучитьСоответствиеРеквизитовПутиВФормеОбъекта();
	СоответствиеРеквизитовПутиВФормеОбъекта.Вставить("АдресДляИнформирования", "");
	
	Возврат СоответствиеРеквизитовПутиВФормеОбъекта;
	
КонецФункции

Функция ПолучитьСоответствиеПроверяемыхРеквизитовОткрываемымОбъектам(ДокументСсылка, ДанныеДляПроверки) Экспорт
	Возврат Новый Структура;
КонецФункции

#Область ПроцедурыПолученияДанныхДляЗаполненияИПроведенияДокумента

Функция СформироватьЗапросПоЗаписямСтажаДляПечати(МассивСсылок) Экспорт 
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПачкаДокументовСЗВ_6_1Сотрудники.НомерСтроки КАК НомерСтроки,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Сотрудник,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.АдресДляИнформирования,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.СтраховойНомерПФР,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Фамилия,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Имя,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Отчество,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.НачисленоСтраховая,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.УплаченоСтраховая,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.НачисленоНакопительная,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.УплаченоНакопительная,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.ДоначисленоСтраховая,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.ДоначисленоНакопительная,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Ссылка КАК Ссылка,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.АдресДляИнформированияПредставление
	|ПОМЕСТИТЬ ВТСотрудникиДокумента
	|ИЗ
	|	Документ.ПачкаДокументовСЗВ_6_1.Сотрудники КАК ПачкаДокументовСЗВ_6_1Сотрудники
	|ГДЕ
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Ссылка В(&МассивСсылок)
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
	|	ЗаписиОСтаже.ОсобыеУсловияТруда.Код КАК ОсобыеУсловияТрудаКод,
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
	|	ПачкаДокументовСЗВ_6_1Сотрудники.НомерСтроки КАК НомерСтроки,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Сотрудник,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.АдресДляИнформирования,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.СтраховойНомерПФР,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Фамилия,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Имя,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Отчество,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.НачисленоСтраховая,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.УплаченоСтраховая,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.НачисленоНакопительная,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.УплаченоНакопительная,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.ДоначисленоСтраховая,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.ДоначисленоНакопительная,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Ссылка КАК Ссылка,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.АдресДляИнформированияПредставление
	|ИЗ
	|	ВТСотрудникиДокумента КАК ПачкаДокументовСЗВ_6_1Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПачкаДокументовСЗВ_6_1.ЗаписиОСтаже КАК ЗаписиОСтаже
	|		ПО ПачкаДокументовСЗВ_6_1Сотрудники.Сотрудник = ЗаписиОСтаже.Сотрудник
	|			И ПачкаДокументовСЗВ_6_1Сотрудники.Ссылка = ЗаписиОСтаже.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки,
	|	НомерОсновнойЗаписи,
	|	НомерДополнительнойЗаписи";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция СформироватьЗапросПоСпискуЗастрахованныхЛицДляПечати(МассивСсылок)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Фамилия,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Имя,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Отчество,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Ссылка КАК Ссылка,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.НомерСтроки КАК НомерСтроки,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.СтраховойНомерПФР
	|ИЗ
	|	Документ.ПачкаДокументовСЗВ_6_1.Сотрудники КАК ПачкаДокументовСЗВ_6_1Сотрудники
	|ГДЕ
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Ссылка В(&МассивСсылок)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция СформироватьЗапросПоШапкеДляПечати(МассивСсылок)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	ОписаниеИсточникаДанных = ПерсонифицированныйУчет.ОписаниеИсточникаДанныхДляСоздатьВТСведенияОбОрганизациях();
	ОписаниеИсточникаДанных.ИмяТаблицы = "Документ.ПачкаДокументовСЗВ_6_1";
	ОписаниеИсточникаДанных.ИмяПоляОрганизация = "Организация";
	ОписаниеИсточникаДанных.ИмяПоляПериод = "ОкончаниеОтчетногоПериода";
	ОписаниеИсточникаДанных.СписокСсылок = МассивСсылок;

	ПерсонифицированныйУчет.СоздатьВТСведенияОбОрганизацияхПоОписаниюДокументаИсточникаДанных(Запрос.МенеджерВременныхТаблиц, ОписаниеИсточникаДанных);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПачкаДокументовСЗВ_6_1.Ссылка КАК Ссылка,
	|	ПачкаДокументовСЗВ_6_1.Организация КАК Организация,
	|	СведенияОбОрганизациях.НаименованиеСокращенное КАК НаименованиеОрганизации,
	|	СведенияОбОрганизациях.РегистрационныйНомерПФР КАК РегистрационныйНомерПФР,
	|	СведенияОбОрганизациях.ИНН КАК ИНН,
	|	СведенияОбОрганизациях.КПП КАК КПП,
	|	ПачкаДокументовСЗВ_6_1.КатегорияЗастрахованныхЛиц КАК КатегорияЗастрахованныхЛиц,
	|	ПачкаДокументовСЗВ_6_1.ОтчетныйПериод,
	|	ПачкаДокументовСЗВ_6_1.ОкончаниеОтчетногоПериода,
	|	ПачкаДокументовСЗВ_6_1.ТипСведенийСЗВ,
	|	ПачкаДокументовСЗВ_6_1.КорректируемыйПериод,
	|	ПачкаДокументовСЗВ_6_1.Руководитель КАК Руководитель,
	|	ПачкаДокументовСЗВ_6_1.ДолжностьРуководителя.Наименование КАК ДолжностьРуководителя,
	|	ПачкаДокументовСЗВ_6_1.Дата,
	|	ПачкаДокументовСЗВ_6_1.НомерПачки,
	|	СведенияОбОрганизациях.КодПоОКПО КАК КодПоОКПО
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.ПачкаДокументовСЗВ_6_1 КАК ПачкаДокументовСЗВ_6_1
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСведенияОбОрганизациях КАК СведенияОбОрганизациях
	|		ПО ПачкаДокументовСЗВ_6_1.Организация = СведенияОбОрганизациях.Организация
	|			И ПачкаДокументовСЗВ_6_1.ОкончаниеОтчетногоПериода = СведенияОбОрганизациях.Период
	|ГДЕ
	|	ПачкаДокументовСЗВ_6_1.Ссылка В(&МассивСсылок)
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
	|	ПачкаДокументовСЗВ_6_1.Ссылка КАК Ссылка,
	|	ПачкаДокументовСЗВ_6_1.РегистрационныйНомерПФР КАК РегНомерПФР,
	|	ПачкаДокументовСЗВ_6_1.НаименованиеОрганизации КАК НаименованиеОрганизации,
	|	ПачкаДокументовСЗВ_6_1.ИНН КАК ИНН,
	|	ПачкаДокументовСЗВ_6_1.КПП КАК КПП,
	|	ПачкаДокументовСЗВ_6_1.КодПоОКПО КАК ОКПО,
	|	ПачкаДокументовСЗВ_6_1.КатегорияЗастрахованныхЛиц КАК КатегорияЗастрахованныхЛиц,
	|	ПачкаДокументовСЗВ_6_1.ОтчетныйПериод,
	|	ПачкаДокументовСЗВ_6_1.ТипСведенийСЗВ,
	|	ПачкаДокументовСЗВ_6_1.КорректируемыйПериод,
	|	ЕСТЬNULL(ВТФИОПоследние.РасшифровкаПодписи, """") КАК Руководитель,
	|	ПачкаДокументовСЗВ_6_1.ДолжностьРуководителя КАК ДолжностьРуководителя,
	|	ПачкаДокументовСЗВ_6_1.Дата,
	|	ПачкаДокументовСЗВ_6_1.НомерПачки
	|ИЗ
	|	ВТДанныеДокументов КАК ПачкаДокументовСЗВ_6_1
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОПоследние
	|		ПО ПачкаДокументовСЗВ_6_1.Ссылка = ВТФИОПоследние.Ссылка
	|			И ПачкаДокументовСЗВ_6_1.Руководитель = ВТФИОПоследние.ФизическоеЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция СформироватьЗапросПоШапкеДляАДВ_3(МассивОбъектов) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Установим параметры запроса.
	Запрос.УстановитьПараметр("МассивСсылок", МассивОбъектов);
	
	ОписаниеИсточникаДанных = ПерсонифицированныйУчет.ОписаниеИсточникаДанныхДляСоздатьВТСведенияОбОрганизациях();
	ОписаниеИсточникаДанных.ИмяТаблицы = "Документ.ПачкаДокументовСЗВ_6_1";
	ОписаниеИсточникаДанных.ИмяПоляОрганизация = "Организация";
	ОписаниеИсточникаДанных.ИмяПоляПериод = "ОкончаниеОтчетногоПериода";
	ОписаниеИсточникаДанных.СписокСсылок = МассивОбъектов;

	ПерсонифицированныйУчет.СоздатьВТСведенияОбОрганизацияхПоОписаниюДокументаИсточникаДанных(Запрос.МенеджерВременныхТаблиц, ОписаниеИсточникаДанных);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(Застрахованные.НачисленоСтраховая) КАК НачисленоСтраховая,
	|	СУММА(Застрахованные.УплаченоСтраховая) КАК УплаченоСтраховая,
	|	СУММА(Застрахованные.НачисленоНакопительная) КАК НачисленоНакопительная,
	|	СУММА(Застрахованные.УплаченоНакопительная) КАК УплаченоНакопительная,
	|	КОЛИЧЕСТВО(Застрахованные.НомерСтроки) КАК Количество,
	|	Застрахованные.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТИтоги
	|ИЗ
	|	Документ.ПачкаДокументовСЗВ_6_1.Сотрудники КАК Застрахованные
	|ГДЕ
	|	Застрахованные.Ссылка В(&МассивСсылок)
	|
	|СГРУППИРОВАТЬ ПО
	|	Застрахованные.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПачкаДокументовСЗВ_6_1.Ссылка КАК Ссылка,
	|	ПачкаДокументовСЗВ_6_1.Номер,
	|	ПачкаДокументовСЗВ_6_1.Дата КАК Дата,
	|	ПачкаДокументовСЗВ_6_1.КатегорияЗастрахованныхЛиц,
	|	ПачкаДокументовСЗВ_6_1.ОтчетныйПериод,
	|	ПачкаДокументовСЗВ_6_1.ОкончаниеОтчетногоПериода КАК ОкончаниеОтчетногоПериода,
	|	ПачкаДокументовСЗВ_6_1.ТипСведенийСЗВ,
	|	ПачкаДокументовСЗВ_6_1.НомерПачки,
	|	ПачкаДокументовСЗВ_6_1.ДолжностьРуководителя.Наименование КАК РуководительДолжность,
	|	СведенияОбОрганизациях.НаименованиеСокращенное КАК НаименованиеОрганизации,
	|	ПачкаДокументовСЗВ_6_1.Организация КАК Организация,
	|	СведенияОбОрганизациях.РегистрационныйНомерПФР КАК РегистрационныйНомерПФР,
	|	СведенияОбОрганизациях.ИНН КАК ИНН,
	|	СведенияОбОрганизациях.КПП КАК КПП,
	|	ГОД(ПачкаДокументовСЗВ_6_1.ОтчетныйПериод) КАК Год,
	|	ПачкаДокументовСЗВ_6_1.КорректируемыйПериод КАК КорректируемыйПериод,
	|	ПачкаДокументовСЗВ_6_1.Руководитель КАК Руководитель,
	|	СведенияОбОрганизациях.КодПоОКПО КАК КодПоОКПО
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.ПачкаДокументовСЗВ_6_1 КАК ПачкаДокументовСЗВ_6_1
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСведенияОбОрганизациях КАК СведенияОбОрганизациях
	|		ПО ПачкаДокументовСЗВ_6_1.Организация = СведенияОбОрганизациях.Организация
	|			И ПачкаДокументовСЗВ_6_1.ОкончаниеОтчетногоПериода = СведенияОбОрганизациях.Период
	|ГДЕ
	|	ПачкаДокументовСЗВ_6_1.Ссылка В(&МассивСсылок)
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
	|	ПачкаДокументовСЗВ_6_1.Ссылка КАК Ссылка,
	|	ПачкаДокументовСЗВ_6_1.Номер,
	|	ПачкаДокументовСЗВ_6_1.Дата КАК Дата,
	|	ПачкаДокументовСЗВ_6_1.КатегорияЗастрахованныхЛиц,
	|	ПачкаДокументовСЗВ_6_1.ОтчетныйПериод,
	|	ПачкаДокументовСЗВ_6_1.ТипСведенийСЗВ,
	|	ПачкаДокументовСЗВ_6_1.НомерПачки,
	|	ПачкаДокументовСЗВ_6_1.РуководительДолжность КАК РуководительДолжность,
	|	ПачкаДокументовСЗВ_6_1.НаименованиеОрганизации КАК НаименованиеОрганизации,
	|	ПачкаДокументовСЗВ_6_1.РегистрационныйНомерПФР КАК РегНомерПФР,
	|	ПачкаДокументовСЗВ_6_1.ИНН КАК ИНН,
	|	ПачкаДокументовСЗВ_6_1.КПП КАК КПП,
	|	ПачкаДокументовСЗВ_6_1.КодПоОКПО КАК КодПоОКПО,
	|	ПачкаДокументовСЗВ_6_1.Год КАК Год,
	|	""СЗВ-6-1"" КАК ТипФормДокументов,
	|	ЕСТЬNULL(ИтогиПоВзносам.НачисленоСтраховая, 0) КАК НачисленоСтраховая,
	|	ЕСТЬNULL(ИтогиПоВзносам.УплаченоСтраховая, 0) КАК УплаченоСтраховая,
	|	ЕСТЬNULL(ИтогиПоВзносам.НачисленоНакопительная, 0) КАК НачисленоНакопительная,
	|	ЕСТЬNULL(ИтогиПоВзносам.УплаченоНакопительная, 0) КАК УплаченоНакопительная,
	|	ЕСТЬNULL(ИтогиПоВзносам.Количество, 0) КАК Количество,
	|	ПачкаДокументовСЗВ_6_1.КорректируемыйПериод КАК КорректируемыйПериод,
	|	ЕСТЬNULL(ВТФИОПоследние.РасшифровкаПодписи, """") КАК Руководитель
	|ИЗ
	|	ВТДанныеДокументов КАК ПачкаДокументовСЗВ_6_1
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТИтоги КАК ИтогиПоВзносам
	|		ПО ПачкаДокументовСЗВ_6_1.Ссылка = ИтогиПоВзносам.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОПоследние
	|		ПО ПачкаДокументовСЗВ_6_1.Ссылка = ВТФИОПоследние.Ссылка
	|			И ПачкаДокументовСЗВ_6_1.Руководитель = ВТФИОПоследние.ФизическоеЛицо
	|ГДЕ
	|	ПачкаДокументовСЗВ_6_1.Ссылка В(&МассивСсылок)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

#КонецОбласти

#Область ДляОбеспеченияФормированияВыходногоФайла

// Формирует запрос по шапке документа.
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШапке(Ссылка) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Установим параметры запроса.
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	
	ОписаниеИсточникаДанных = ПерсонифицированныйУчет.ОписаниеИсточникаДанныхДляСоздатьВТСведенияОбОрганизациях();
	ОписаниеИсточникаДанных.ИмяТаблицы = "Документ.ПачкаДокументовСЗВ_6_1";
	ОписаниеИсточникаДанных.ИмяПоляОрганизация = "Организация";
	ОписаниеИсточникаДанных.ИмяПоляПериод = "ОкончаниеОтчетногоПериода";
	ОписаниеИсточникаДанных.СписокСсылок = Ссылка;

	ПерсонифицированныйУчет.СоздатьВТСведенияОбОрганизацияхПоОписаниюДокументаИсточникаДанных(Запрос.МенеджерВременныхТаблиц, ОписаниеИсточникаДанных);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(Застрахованные.НачисленоСтраховая) КАК НачисленоСтраховая,
	|	СУММА(Застрахованные.УплаченоСтраховая) КАК УплаченоСтраховая,
	|	СУММА(Застрахованные.НачисленоНакопительная) КАК НачисленоНакопительная,
	|	СУММА(Застрахованные.УплаченоНакопительная) КАК УплаченоНакопительная,
	|	КОЛИЧЕСТВО(Застрахованные.НомерСтроки) КАК Количество
	|ПОМЕСТИТЬ ВТИтоги
	|ИЗ
	|	Документ.ПачкаДокументовСЗВ_6_1.Сотрудники КАК Застрахованные
	|ГДЕ
	|	Застрахованные.Ссылка = &ДокументСсылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПачкаДокументовСЗВ_6_1.Ссылка,
	|	ПачкаДокументовСЗВ_6_1.Номер,
	|	ПачкаДокументовСЗВ_6_1.Дата,
	|	ПачкаДокументовСЗВ_6_1.Проведен,
	|	ПачкаДокументовСЗВ_6_1.Организация,
	|	ПачкаДокументовСЗВ_6_1.КатегорияЗастрахованныхЛиц,
	|	ПачкаДокументовСЗВ_6_1.ОтчетныйПериод,
	|	ПачкаДокументовСЗВ_6_1.ТипСведенийСЗВ,
	|	ВЫБОР
	|		КОГДА ПачкаДокументовСЗВ_6_1.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|		ИНАЧЕ ПачкаДокументовСЗВ_6_1.КорректируемыйПериод
	|	КОНЕЦ КАК КорректируемыйПериод,
	|	ПачкаДокументовСЗВ_6_1.НомерПачки,
	|	ПачкаДокументовСЗВ_6_1.ДокументПринятВПФР,
	|	ПачкаДокументовСЗВ_6_1.Ответственный,
	|	ПачкаДокументовСЗВ_6_1.ДолжностьРуководителя.Наименование КАК РуководительДолжность,
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
	|	ГОД(ПачкаДокументовСЗВ_6_1.ОтчетныйПериод) КАК Год,
	|	СведенияОбОрганизациях.КодПоОКПО КАК ОКПО,
	|	""СЗВ-6-1"" КАК ТипФормДокументов,
	|	ЕСТЬNULL(ИтогиПоВзносам.НачисленоСтраховая, 0) КАК НачисленоСтраховая,
	|	ЕСТЬNULL(ИтогиПоВзносам.УплаченоСтраховая, 0) КАК УплаченоСтраховая,
	|	ЕСТЬNULL(ИтогиПоВзносам.НачисленоНакопительная, 0) КАК НачисленоНакопительная,
	|	ЕСТЬNULL(ИтогиПоВзносам.УплаченоНакопительная, 0) КАК УплаченоНакопительная,
	|	ЕСТЬNULL(ИтогиПоВзносам.Количество, 0) КАК Количество,
	|	ПачкаДокументовСЗВ_6_1.ИмяФайлаДляПФР
	|ИЗ
	|	Документ.ПачкаДокументовСЗВ_6_1 КАК ПачкаДокументовСЗВ_6_1
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСведенияОбОрганизациях КАК СведенияОбОрганизациях
	|		ПО ПачкаДокументовСЗВ_6_1.Организация = СведенияОбОрганизациях.Организация
	|			И ПачкаДокументовСЗВ_6_1.ОкончаниеОтчетногоПериода = СведенияОбОрганизациях.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТИтоги КАК ИтогиПоВзносам
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ПачкаДокументовСЗВ_6_1.Ссылка = &ДокументСсылка";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция СформироватьЗапросПоЗаписямСтажа(Ссылка) Экспорт 
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПачкаДокументовСЗВ_6_1Сотрудники.НомерСтроки КАК НомерСтроки,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Сотрудник,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.АдресДляИнформирования,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.СтраховойНомерПФР,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Фамилия,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Имя,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Отчество,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.НачисленоСтраховая,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.УплаченоСтраховая,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.НачисленоНакопительная,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.УплаченоНакопительная,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.ДоначисленоСтраховая,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.ДоначисленоНакопительная
	|ПОМЕСТИТЬ ВТДанныеСотрудников
	|ИЗ
	|	Документ.ПачкаДокументовСЗВ_6_1.Сотрудники КАК ПачкаДокументовСЗВ_6_1Сотрудники
	|ГДЕ
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Ссылка = &Ссылка
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
	|	ЗаписиОСтаже.ПараметрТерриториальныхУсловий КАК ТерриториальныеУсловияСтавка,
	|	ЗаписиОСтаже.ОсобыеУсловияТруда,
	|	ЗаписиОСтаже.ОсобыеУсловияТруда.КодДляОтчетности2010 КАК ОсобыеУсловияТрудаКод,
	|	ЗаписиОСтаже.КодПозицииСписка,
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
	|	ПачкаДокументовСЗВ_6_1Сотрудники.НомерСтроки КАК НомерСтроки,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Сотрудник,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.АдресДляИнформирования,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.СтраховойНомерПФР,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Фамилия,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Имя,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.Отчество,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.НачисленоСтраховая,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.УплаченоСтраховая,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.НачисленоНакопительная,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.УплаченоНакопительная,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.ДоначисленоСтраховая,
	|	ПачкаДокументовСЗВ_6_1Сотрудники.ДоначисленоНакопительная
	|ИЗ
	|	ВТДанныеСотрудников КАК ПачкаДокументовСЗВ_6_1Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПачкаДокументовСЗВ_6_1.ЗаписиОСтаже КАК ЗаписиОСтаже
	|		ПО ПачкаДокументовСЗВ_6_1Сотрудники.Сотрудник = ЗаписиОСтаже.Сотрудник
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
	РезультатЗапросаПоЗаписямСтажа = СформироватьЗапросПоЗаписямСтажа(Объект.Ссылка);
	
	ВыборкаПоШапкеДокумента.Следующий();
	
	ТекстФайла = ПерсонифицированныйУчет.ФайлСведенийОВзносахИСтаже(ВыборкаПоШапкеДокумента, РезультатЗапросаПоЗаписямСтажа, ВыборкаПоШапкеДокумента.Количество);
	
	ЗарплатаКадры.ЗаписатьФайлВАрхив(Объект.Ссылка, ВыборкаПоШапкеДокумента.ИмяФайлаДляПФР, ТекстФайла);
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// СЗВ-6-1
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ФормаСЗВ_6_1";
	КомандаПечати.Представление = НСтр("ru = 'СЗВ-6-1';
										|en = 'SZV-6-1'");
	КомандаПечати.Порядок = 10;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	// АДВ-6-3
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ФормаАДВ_6_3";
	КомандаПечати.Представление = НСтр("ru = 'АДВ-6-3';
										|en = 'ADV-6-3'");
	КомандаПечати.Порядок = 20;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	
	// Список застрахованных лиц
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "СписокЗастрахованныхЛиц";
	КомандаПечати.Представление = НСтр("ru = 'Список застрахованных лиц';
										|en = 'Insured person list'");
	КомандаПечати.Порядок = 30;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	
	// Все формы
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ФормаСЗВ_6_1,ФормаАДВ_6_3,СписокЗастрахованныхЛиц";
	КомандаПечати.Представление = НСтр("ru = 'Все формы';
										|en = 'All forms'");
	КомандаПечати.Порядок = 40;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ФормаСЗВ_6_1") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ФормаСЗВ_6_1", "Форма СЗВ-6-1", СформироватьПечатнуюФормуСЗВ_6_1(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СписокЗастрахованныхЛиц") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СписокЗастрахованныхЛиц", "Список застрахованных лиц", СформироватьПечатнуюФормуСписокЗастрахованныхЛиц(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ФормаАДВ_6_3") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ФормаАДВ_6_3", "Форма АДВ-6-3", СформироватьПечатнуюФормуАДВ_6_3(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция ТабличныеДокументыФормСЗВ_6_1(МассивОбъектов, ОбъектыПечати = Неопределено, ВыводитьОпись = Ложь, ДатаПодписи = Неопределено) Экспорт
	Результат = Новый Массив;
		
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПачкаДокументовСЗВ_6_1.ПФ_MXL_ФормаСЗВ_6_1");
	
	ВыборкаДокументов = СформироватьЗапросПоШапкеДляПечати(МассивОбъектов).Выбрать();
	
	ВыборкаЗаписейСтажа = СформироватьЗапросПоЗаписямСтажаДляПечати(МассивОбъектов).Выбрать();
	
	ОбластьСтрока    = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал    = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапка     = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапкаСтаж = Макет.ПолучитьОбласть("ШапкаСтаж");
	ОбластьСтаж      = Макет.ПолучитьОбласть("Стаж");
	
	Если ВыводитьОпись Тогда
		ВыборкаПоШапкеДокументаДляОписи = СформироватьЗапросПоШапкеДляАДВ_3(МассивОбъектов).Выбрать();
		ТабличныеДокументыОписей = ПерсонифицированныйУчет.ТабличныеДокументыОписейАДВ6_3(ОбъектыПечати, ВыборкаПоШапкеДокументаДляОписи, "СЗВ_6_1", ДатаПодписи);
	КонецЕсли;	
	
	Пока ВыборкаДокументов.СледующийПоЗначениюПоля("Ссылка") Цикл
		ТабличныйДокумент = Новый ТабличныйДокумент;
		
		Если ВыводитьОпись Тогда
			ТабличныйДокументОписи = ТабличныеДокументыОписей[ВыборкаДокументов.Ссылка];
			
			Если ТабличныеДокументыОписей <> Неопределено Тогда
				ТабличныйДокумент.Вывести(ТабличныйДокументОписи);
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
		КонецЕсли;	
		
		ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПачкаДокументовСЗВ_6_1_Форма_СЗВ_6_1";

		Справочники.КомплектыОтчетностиПерсУчета.ДобавитьТабличныйДокументВКоллекциюПечатаемыхОбъектов(Результат, ТабличныйДокумент, ВыборкаДокументов);
		
		ВыборкаЗаписейСтажа.Сбросить();
		
		СтруктураПоиска = Новый Структура("Ссылка", ВыборкаДокументов.Ссылка);
		
		Если ВыборкаЗаписейСтажа.НайтиСледующий(СтруктураПоиска) Тогда
			ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры, ВыборкаДокументов, "РегНомерПФР, ИНН, КПП, ОКПО");
			
			ОбластьШапка.Параметры.НаименованиеОрганизации = ПерсонифицированныйУчет.СтрокаВОтчет(ВыборкаДокументов.НаименованиеОрганизации);
			
			ОбластьШапка.Параметры.КодКатегории = ПерсонифицированныйУчет.ПолучитьИмяЭлементаПеречисленияПоЗначению(ВыборкаДокументов.КатегорияЗастрахованныхЛиц);
			
			ОтчетныйПериод = ВыборкаДокументов.ОтчетныйПериод;
			КорректируемыйПериод = ВыборкаДокументов.КорректируемыйПериод;
			
			Если Год(ОтчетныйПериод) >= 2011 Тогда
				ОбластьШапка.Параметры.ЭтоКварталОтчетногоГода   = Месяц(ОтчетныйПериод) = 1;
				ОбластьШапка.Параметры.ЭтоПолугодиеОтчетногоГода = Месяц(ОтчетныйПериод) = 4;
				ОбластьШапка.Параметры.Это9МесяцевОтчетногоГода  = Месяц(ОтчетныйПериод) = 7;
				ОбластьШапка.Параметры.ЭтоВесьОтчетныйГод        = Месяц(ОтчетныйПериод) = 10;
			Иначе
				ОбластьШапка.Параметры.ЭтоПолугодие2010 = Месяц(ОтчетныйПериод) = 1;
				ОбластьШапка.Параметры.Это2010год = Месяц(ОтчетныйПериод) = 7;
			КонецЕсли;
			
			ОбластьШапка.Параметры.ОтчетныйГод = Формат(Год(ОтчетныйПериод), "ЧГ=");
			
			Если ВыборкаДокументов.ТипСведенийСЗВ <> Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ Тогда 
				Если Год(КорректируемыйПериод) >= 2011 Тогда 
					ОбластьШапка.Параметры.ЭтоКварталКорректируемогоГода   = Месяц(КорректируемыйПериод) = 1;
					ОбластьШапка.Параметры.ЭтоПолугодиеКорректируемогоГода = Месяц(КорректируемыйПериод) = 4;
					ОбластьШапка.Параметры.Это9МесяцевКорректируемогоГода  = Месяц(КорректируемыйПериод) = 7;
					ОбластьШапка.Параметры.ЭтоВесьКорректируемыйГод        = Месяц(КорректируемыйПериод) = 10;
				Иначе
					ОбластьШапка.Параметры.ЭтоПолугодиеКорректируемогоГода = Месяц(КорректируемыйПериод) = 1;	
					ОбластьШапка.Параметры.ЭтоВесьКорректируемыйГод        = Месяц(КорректируемыйПериод) = 7;
					
					ОбластьШапка.Параметры.ЭтоКварталКорректируемогоГода = Ложь;
					ОбластьШапка.Параметры.Это9МесяцевКорректируемогоГода = Ложь;
				КонецЕсли;	
							
				ОбластьШапка.Параметры.ЭтоКорректирующийДокумент = ВыборкаДокументов.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.КОРРЕКТИРУЮЩАЯ;
				ОбластьШапка.Параметры.ЭтоОтменяющийДокумент     = ВыборкаДокументов.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ;
				
				ОбластьШапка.Параметры.КорректируемыйГод = Формат(Год(КорректируемыйПериод), "ЧГ=");
			Иначе
				ОбластьШапка.Параметры.ЭтоИсходныйДокумент = Истина;
			КонецЕсли;
			
			Если ВыборкаЗаписейСтажа.СледующийПоЗначениюПоля("Ссылка") Тогда 
				КоличествоЗастрахованныхЛиц = 0;
				Пока ВыборкаЗаписейСтажа.СледующийПоЗначениюПоля("НомерСтроки") Цикл
					КоличествоЗастрахованныхЛиц = КоличествоЗастрахованныхЛиц + 1;
					
					НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
					
					ТабличныйДокумент.Вывести(ОбластьШапка);
					
					ОбластьСтрока.Параметры.ФИО = ПерсонифицированныйУчет.СтрокаВОтчет(ВыборкаЗаписейСтажа.Фамилия + " " + ВыборкаЗаписейСтажа.Имя + " " + ВыборкаЗаписейСтажа.Отчество);
					ОбластьСтрока.Параметры.СтраховойНомерПФР = ВыборкаЗаписейСтажа.СтраховойНомерПФР;
					ОбластьСтрока.Параметры.Адрес             = ПерсонифицированныйУчет.СтрокаВОтчет(ВыборкаЗаписейСтажа.АдресДляИнформированияПредставление);
					
					Если ВыборкаДокументов.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ Тогда 
						ОбластьСтрока.Параметры.НачисленоНакопительная = 0;
						ОбластьСтрока.Параметры.УплаченоНакопительная  = 0;
						ОбластьСтрока.Параметры.НачисленоСтраховая     = 0;
						ОбластьСтрока.Параметры.УплаченоСтраховая      = 0;
					Иначе	
						ОбластьСтрока.Параметры.НачисленоНакопительная = ВыборкаЗаписейСтажа.НачисленоНакопительная;
						ОбластьСтрока.Параметры.УплаченоНакопительная  = ВыборкаЗаписейСтажа.УплаченоНакопительная;
						ОбластьСтрока.Параметры.НачисленоСтраховая     = ВыборкаЗаписейСтажа.НачисленоСтраховая;
						ОбластьСтрока.Параметры.УплаченоСтраховая      = ВыборкаЗаписейСтажа.УплаченоСтраховая;
					КонецЕсли;
					
					ТабличныйДокумент.Вывести(ОбластьСтрока);
					
					Если  ВыборкаДокументов.ТипСведенийСЗВ <> Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ Тогда
						ТабличныйДокумент.Вывести(ОбластьШапкаСтаж);
					КонецЕсли;
					
					Если ЗначениеЗаполнено(ВыборкаЗаписейСтажа.НомерОсновнойЗаписи) Тогда
						
						НомерСтроки = 0;
						Пока ВыборкаЗаписейСтажа.СледующийПоЗначениюПоля("НомерОсновнойЗаписи") Цикл
							НомерСтроки = НомерСтроки + 1;
							
							ЗаполнитьОбластьСтаж(ВыборкаЗаписейСтажа, ОбластьСтаж, НомерСтроки);	
							Если  ВыборкаДокументов.ТипСведенийСЗВ <> Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ Тогда
								ТабличныйДокумент.Вывести(ОбластьСтаж);
							КонецЕсли;
							
							Пока ВыборкаЗаписейСтажа.СледующийПоЗначениюПоля("НомерДополнительнойЗаписи") Цикл
								Если ВыборкаЗаписейСтажа.НомерДополнительнойЗаписи = 0 Тогда
									Продолжить;
								КонецЕсли;
								
								НомерСтроки = НомерСтроки + 1;
								
								ЗаполнитьОбластьСтаж(ВыборкаЗаписейСтажа, ОбластьСтаж, НомерСтроки);
								
								Если  ВыборкаДокументов.ТипСведенийСЗВ <> Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ Тогда
									ТабличныйДокумент.Вывести(ОбластьСтаж);
								КонецЕсли;
								
							КонецЦикла;
							
						КонецЦикла;
					КонецЕсли;
					
					ОбластьПодвал.Параметры.Руководитель = ВыборкаДокументов.Руководитель;
					ОбластьПодвал.Параметры.РуководительДолжность = ВыборкаДокументов.ДолжностьРуководителя;
					
					Если ЗначениеЗаполнено(ДатаПодписи) Тогда
						ОбластьПодвал.Параметры.ДатаСоставленияОписи = 	ПерсонифицированныйУчет.ДатаВОтчет(ДатаПодписи);	
					Иначе							
						ОбластьПодвал.Параметры.ДатаСоставленияОписи  = ПерсонифицированныйУчет.ДатаВОтчет(ВыборкаДокументов.Дата);
					КонецЕсли;	
					
					ТабличныйДокумент.Вывести(ОбластьПодвал);
					
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					
					Если ОбъектыПечати <> Неопределено Тогда
						УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументов.Ссылка);
					КонецЕсли;	
					
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
		
КонецФункции	

Функция СформироватьПечатнуюФормуСЗВ_6_1(МассивОбъектов, ОбъектыПечати) Экспорт
	КоллекцияПечатаемыхОбъектов = ТабличныеДокументыФормСЗВ_6_1(МассивОбъектов, ОбъектыПечати);
	ТабличныйДокумент = Справочники.КомплектыОтчетностиПерсУчета.ОбъединитьТабличныеДокументы(КоллекцияПечатаемыхОбъектов);	
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	Возврат ТабличныйДокумент;
КонецФункции

Функция СформироватьПечатнуюФормуСписокЗастрахованныхЛиц(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПачкаДокументовСЗВ_6_1_СписокЗастрахованныхЛиц";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПачкаДокументовСЗВ_6_1.ПФ_MXL_СписокЗастрахованныхЛиц");
	
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапка  = Макет.ПолучитьОбласть("Шапка");
	ОбластьПовторятьПриПечати   = Макет.ПолучитьОбласть("ПовторятьПриПечати");
	
	ВыборкаДокументов = СформироватьЗапросПоШапкеДляПечати(МассивОбъектов).Выбрать();
	
	ВыборкаПоЗЛ = СформироватьЗапросПоСпискуЗастрахованныхЛицДляПечати(МассивОбъектов).Выбрать();
	
	Пока ВыборкаДокументов.СледующийПоЗначениюПоля("Ссылка") Цикл
		ВыборкаПоЗЛ.Сбросить();
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		СтруктураПоиска = Новый Структура("Ссылка", ВыборкаДокументов.Ссылка);
		
		ОбластьШапка.Параметры.РегистрационныйНомерПФР = ВыборкаДокументов.РегНомерПФР;
		ОбластьШапка.Параметры.НаименованиеСокращенное = ПерсонифицированныйУчет.СтрокаВОтчет(ВыборкаДокументов.НаименованиеОрганизации);
		ОбластьШапка.Параметры.РасчетныйПериод = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(ВыборкаДокументов.ОтчетныйПериод);
		ОбластьШапка.Параметры.НомерПачкиРаботодателя = ВыборкаДокументов.НомерПачки;
		
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		Если ВыборкаПоЗЛ.НайтиСледующий(СтруктураПоиска) Тогда
			Если ВыборкаПоЗЛ.СледующийПоЗначениюПоля("Ссылка") Тогда
				Пока ВыборкаПоЗЛ.СледующийПоЗначениюПоля("НомерСтроки") Цикл
					ОбластьСтрока.Параметры.НомерСтроки = ВыборкаПоЗЛ.НомерСтроки;
					ОбластьСтрока.Параметры.СтраховойНомерПФР = ВыборкаПоЗЛ.СтраховойНомерПФР;
					ОбластьСтрока.Параметры.ФИО = ПерсонифицированныйУчет.СтрокаВОтчет(ВыборкаПоЗЛ.Фамилия + " " + ВыборкаПоЗЛ.Имя + " " + ВыборкаПоЗЛ.Отчество);
					
					ТабличныйДокумент.Вывести(ОбластьСтрока);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		ОбластьПодвал.Параметры.Руководитель = ВыборкаДокументов.Руководитель;
		ОбластьПодвал.Параметры.РуководительДолжность = ВыборкаДокументов.ДолжностьРуководителя;
		ОбластьПодвал.Параметры.ДатаСоставленияОписи  = ПерсонифицированныйУчет.ДатаВОтчет(ВыборкаДокументов.Дата);
		
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументов.Ссылка);
	КонецЦикла;
	
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция СформироватьПечатнуюФормуАДВ_6_3(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапкеДляАДВ_3(МассивОбъектов).Выбрать();
	
	Возврат ПерсонифицированныйУчет.ВывестиОписьАДВ6_3(ОбъектыПечати, ВыборкаПоШапкеДокумента, "СЗВ_6_1");
	
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

#КонецОбласти

#КонецОбласти

#КонецЕсли