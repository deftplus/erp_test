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

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	ВедомостьНаВыплатуЗарплаты.ДобавитьКомандыПечатиПриВыплатеНаКарточки(КомандыПечати);
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - Массив - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати - СписокЗначений - значение - ссылка на объект;
//                                   представление - имя области, в которой был выведен объект (выходной параметр);
//  ПараметрыВывода - Структура - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	ВедомостьНаВыплатуЗарплаты.ПечатьПриВыплатеНаКарточки(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

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

// Возвращает описание состава документа.
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
//
Функция ОписаниеСоставаОбъекта() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ВедомостьНаВыплатуЗарплатыВБанк;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

// ЗарплатаКадры.ОграничениеИспользованияДокументов
// АПК:299-выкл Используемость методов служебного API не контролируется

Функция ПредставлениеПометкиОграничения() Экспорт
	Возврат ВедомостьНаВыплатуЗарплаты.ПредставлениеПометкиОграниченияПриВыплатеНаКарточки();
КонецФункции

Функция ОперацияОграниченияДокумента() Экспорт
	Возврат ВедомостьНаВыплатуЗарплаты.ОперацияОграниченияДокументаПриВыплатеНаКарточки();
КонецФункции

// АПК:299-вкл
// Конец ЗарплатаКадры.ОграничениеИспользованияДокументов

Функция ДанныеВедомостиДляПечати(Ссылка) Экспорт
	Возврат ВедомостьНаВыплатуЗарплаты.ДанныеДляПечати(Ссылка)	
КонецФункции

// Возвращает структуру, используемую для заполнения документа.
Функция ДанныеЗаполненияНезачисленнымиСтроками() Экспорт
	ДанныеЗаполненияНезачисленнымиСтроками = Новый Структура;
	ДанныеЗаполненияНезачисленнымиСтроками.Вставить("ЭтоДанныеЗаполненияНезачисленнымиСтроками");
	ДанныеЗаполненияНезачисленнымиСтроками.Вставить("Ведомость", Документы.ВедомостьНаВыплатуЗарплатыВБанк.ПустаяСсылка());
	ДанныеЗаполненияНезачисленнымиСтроками.Вставить("Физлица", Новый Массив);
	Возврат ДанныеЗаполненияНезачисленнымиСтроками
КонецФункции

Функция ЭтоДанныеЗаполненияНезачисленнымиСтроками(ДанныеЗаполнения) Экспорт
	Возврат ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ЭтоДанныеЗаполненияНезачисленнымиСтроками")
КонецФункции

// Возвращает структуру документа, используемую для формирования файла обмена, печатного документа.
//
Функция ДанныеЗаполненияВедомости() Экспорт
	
	ДанныеЗаполнения = Новый Структура();
	ДанныеЗаполнения.Вставить("Документ", Документы.ВедомостьНаВыплатуЗарплатыВБанк.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("НомерДокумента", "");
	ДанныеЗаполнения.Вставить("ДатаДокумента", Дата("00010101"));
	ДанныеЗаполнения.Вставить("НомерРеестра", "");
	ДанныеЗаполнения.Вставить("ВидДоходаИсполнительногоПроизводства", Перечисления.ВидыДоходовИсполнительногоПроизводства.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("ПериодРегистрации", Дата("00010101"));
	ДанныеЗаполнения.Вставить("ПолноеНаименованиеОрганизации", "");
	ДанныеЗаполнения.Вставить("ИННОрганизации", "");
	ДанныеЗаполнения.Вставить("КодПоОКПО", "");
	ДанныеЗаполнения.Вставить("Организация", Справочники.Организации.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("Подразделение", Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("ЗарплатныйПроект", Справочники.ЗарплатныеПроекты.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("НомерДоговора", "");
	ДанныеЗаполнения.Вставить("ДатаДоговора", Дата("00010101"));
	ДанныеЗаполнения.Вставить("НомерРасчетногоСчетаОрганизации", "");
	ДанныеЗаполнения.Вставить("ОтделениеБанка", "");
	ДанныеЗаполнения.Вставить("ИспользоватьЭлектронныйДокументооборотСБанком", Ложь);
	ДанныеЗаполнения.Вставить("БИКБанка", "");
	ДанныеЗаполнения.Вставить("ФорматФайла", Перечисления.ФорматыФайловОбменаПоЗарплатномуПроекту.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("КодировкаФайла", Перечисления.КодировкаФайловОбменаПоЗарплатномуПроекту.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("ВидЗачисления", "01");
	ДанныеЗаполнения.Вставить("КоличествоЗаписей", 0);
	ДанныеЗаполнения.Вставить("СуммаИтого", 0);
	ДанныеЗаполнения.Вставить("СуммаПоДокументу", 0);
	ДанныеЗаполнения.Вставить("ИдПервичногоДокумента", "");
	ДанныеЗаполнения.Вставить("НомерПлатежногоПоручения", "");
	ДанныеЗаполнения.Вставить("ДатаПлатежногоПоручения", Дата("00010101"));
	ДанныеЗаполнения.Вставить("ДатаФормирования", Дата("00010101"));
	ДанныеЗаполнения.Вставить("ИмяФайла", "");
	ДанныеЗаполнения.Вставить("ДанныеРеестра", "");
	ДанныеЗаполнения.Вставить("Руководитель", "");
	ДанныеЗаполнения.Вставить("РуководительДолжность", "");
	ДанныеЗаполнения.Вставить("ГлавныйБухгалтер", "");
	ДанныеЗаполнения.Вставить("ГлавныйБухгалтерДолжность", "");
	ДанныеЗаполнения.Вставить("Бухгалтер", "");
	ДанныеЗаполнения.Вставить("БухгалтерДолжность", "");
	
	ДанныеЗаполнения.Вставить("Сотрудники", Новый Массив);
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

// Возвращает структуру строки документа, используемую для формирования файла обмена, печатного документа.
//
Функция ДанныеЗаполненияСтрокиВедомости() Экспорт
	
	ДанныеЗаполнения = Новый Структура();
	ДанныеЗаполнения.Вставить("ФизическоеЛицо", Справочники.ФизическиеЛица.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("НомерСтроки", 0);
	ДанныеЗаполнения.Вставить("Фамилия", "");
	ДанныеЗаполнения.Вставить("Имя", "");
	ДанныеЗаполнения.Вставить("Отчество", "");
	ДанныеЗаполнения.Вставить("НомерЛицевогоСчета", "");
	ДанныеЗаполнения.Вставить("СуммаКВыплате", 0);
	ДанныеЗаполнения.Вставить("ВзысканнаяСумма", 0);
	ДанныеЗаполнения.Вставить("ОтделениеБанка", "");
	ДанныеЗаполнения.Вставить("ФилиалОтделенияБанка", "");
	ДанныеЗаполнения.Вставить("КодВалюты", "");
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

// Получает данные документа.
//
// Параметры:
//		МассивДокументов - Массив ссылок на документы, по которым требуется получить данные.
//		ДатаПолученияДанных - дата формирования файла.
//		ПлатежныйДокумент - Ссылка на платежный документ, в который входят ведомости.
//
// Возвращаемое значение:
//		Соответствие - где Ключ - ссылка на документ, Значение - структура документа.
//
Функция ДанныеВедомостиНаВыплатуЗарплатыВБанк(МассивДокументов, ДатаПолученияДанных = Неопределено, ПлатежныйДокумент = Неопределено, ТолькоПроведенные = Истина) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	Запрос.УстановитьПараметр("ДатаПолученияДанных", ДатаПолученияДанных);
	Запрос.УстановитьПараметр("ТолькоПроведенные", ТолькоПроведенные);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Ведомость.Ссылка КАК Документ,
	|	Ведомость.Номер КАК НомерДокумента,
	|	Ведомость.Дата КАК ДатаДокумента,
	|	Ведомость.НомерРеестра КАК НомерРеестра,
	|	Ведомость.ВидДоходаИсполнительногоПроизводства КАК ВидДоходаИсполнительногоПроизводства,
	|	Ведомость.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА &ДатаПолученияДанных = НЕОПРЕДЕЛЕНО
	|			ТОГДА Ведомость.Дата
	|		ИНАЧЕ &ДатаПолученияДанных
	|	КОНЕЦ КАК Период,
	|	ВедомостьСостав.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВедомостьСостав.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
	|	ВедомостьСостав.ВзысканнаяСумма КАК ВзысканнаяСумма,
	|	МИНИМУМ(ВедомостьСостав.НомерСтроки) КАК НомерСтроки,
	|	СУММА(ВедомостьЗарплата.КВыплате) КАК СуммаКВыплате,
	|	ЗарплатныеПроекты.ОтделениеБанка КАК ОтделениеБанка,
	|	ЗарплатныеПроекты.ФилиалОтделенияБанка КАК ФилиалОтделенияБанка,
	|	ЗарплатныеПроекты.Валюта.Код КАК КодВалюты
	|ПОМЕСТИТЬ ВТСписокФизическихЛиц
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк КАК Ведомость
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВедомостьНаВыплатуЗарплатыВБанк.Зарплата КАК ВедомостьЗарплата
	|		ПО Ведомость.Ссылка = ВедомостьЗарплата.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВедомостьНаВыплатуЗарплатыВБанк.Состав КАК ВедомостьСостав
	|		ПО (ВедомостьЗарплата.Ссылка = ВедомостьСостав.Ссылка)
	|			И (ВедомостьЗарплата.ИдентификаторСтроки = ВедомостьСостав.ИдентификаторСтроки)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗарплатныеПроекты КАК ЗарплатныеПроекты
	|		ПО Ведомость.ЗарплатныйПроект = ЗарплатныеПроекты.Ссылка
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ТолькоПроведенные
	|				ТОГДА Ведомость.Проведен
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И Ведомость.Ссылка В(&МассивДокументов)
	|
	|СГРУППИРОВАТЬ ПО
	|	Ведомость.Ссылка,
	|	Ведомость.Номер,
	|	Ведомость.Дата,
	|	Ведомость.Организация,
	|	ВЫБОР
	|		КОГДА &ДатаПолученияДанных = НЕОПРЕДЕЛЕНО
	|			ТОГДА Ведомость.Дата
	|		ИНАЧЕ &ДатаПолученияДанных
	|	КОНЕЦ,
	|	ВедомостьСостав.ФизическоеЛицо,
	|	ВедомостьСостав.НомерЛицевогоСчета,
	|	ВедомостьСостав.ВзысканнаяСумма,
	|	ЗарплатныеПроекты.ОтделениеБанка,
	|	ЗарплатныеПроекты.ФилиалОтделенияБанка,
	|	ЗарплатныеПроекты.Валюта.Код,
	|	Ведомость.НомерРеестра,
	|	Ведомость.ВидДоходаИсполнительногоПроизводства";
	Запрос.Выполнить();
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеФизическихЛиц(Запрос.МенеджерВременныхТаблиц, "ВТСписокФизическихЛиц");
	КадровыйУчет.СоздатьВТКадровыеДанныеФизическихЛиц(ОписательВременныхТаблиц, Истина, "Фамилия,Имя,Отчество");
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокФизическихЛиц.Документ КАК Документ,
	|	СписокФизическихЛиц.НомерДокумента КАК НомерДокумента,
	|	СписокФизическихЛиц.ДатаДокумента КАК ДатаДокумента,
	|	СписокФизическихЛиц.НомерРеестра КАК НомерРеестра,
	|	СписокФизическихЛиц.ВидДоходаИсполнительногоПроизводства КАК ВидДоходаИсполнительногоПроизводства,
	|	СписокФизическихЛиц.Организация КАК Организация,
	|	СписокФизическихЛиц.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СписокФизическихЛиц.НомерСтроки КАК НомерСтроки,
	|	КадровыеДанныеФизическихЛиц.Фамилия КАК Фамилия,
	|	КадровыеДанныеФизическихЛиц.Имя КАК Имя,
	|	КадровыеДанныеФизическихЛиц.Отчество КАК Отчество,
	|	СписокФизическихЛиц.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
	|	СписокФизическихЛиц.ВзысканнаяСумма КАК ВзысканнаяСумма,
	|	СписокФизическихЛиц.СуммаКВыплате КАК СуммаКВыплате,
	|	СписокФизическихЛиц.ОтделениеБанка КАК ОтделениеБанка,
	|	СписокФизическихЛиц.ФилиалОтделенияБанка КАК ФилиалОтделенияБанка,
	|	СписокФизическихЛиц.КодВалюты КАК КодВалюты
	|ПОМЕСТИТЬ ВТДанныеСтрокДокументов
	|ИЗ
	|	ВТСписокФизическихЛиц КАК СписокФизическихЛиц
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеФизическихЛиц
	|		ПО СписокФизическихЛиц.ФизическоеЛицо = КадровыеДанныеФизическихЛиц.ФизическоеЛицо
	|			И СписокФизическихЛиц.Период = КадровыеДанныеФизическихЛиц.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТКадровыеДанныеФизическихЛиц
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВедомостьНаВыплатуЗарплатыВБанк.Ссылка КАК Ссылка,
	|	ВедомостьНаВыплатуЗарплатыВБанк.Номер КАК НомерДокумента,
	|	ВедомостьНаВыплатуЗарплатыВБанк.Дата КАК Дата,
	|	ВедомостьНаВыплатуЗарплатыВБанк.НомерРеестра КАК НомерРеестра,
	|	ВедомостьНаВыплатуЗарплатыВБанк.ВидДоходаИсполнительногоПроизводства КАК ВидДоходаИсполнительногоПроизводства,
	|	ВедомостьНаВыплатуЗарплатыВБанк.ПериодРегистрации КАК ПериодРегистрации,
	|	Организации.Ссылка КАК Организация,
	|	ВЫБОР
	|		КОГДА Организации.НаименованиеПолное ПОДОБНО """"
	|			ТОГДА Организации.Наименование
	|		ИНАЧЕ Организации.НаименованиеПолное
	|	КОНЕЦ КАК ПолноеНаименованиеОрганизации,
	|	Организации.ИНН КАК ИННОрганизации,
	|	Организации.КодПоОКПО КАК КодПоОКПО,
	|	ЗарплатныеПроекты.Ссылка КАК ЗарплатныйПроект,
	|	ЗарплатныеПроекты.НомерДоговора КАК НомерДоговора,
	|	ЗарплатныеПроекты.ДатаДоговора КАК ДатаДоговора,
	|	ЗарплатныеПроекты.ОтделениеБанка КАК ОтделениеБанка,
	|	ЕСТЬNULL(ЗарплатныеПроекты.ИспользоватьЭлектронныйДокументооборотСБанком, ЛОЖЬ) КАК ИспользоватьЭлектронныйДокументооборотСБанком,
	|	КлассификаторБанков.Код КАК БИКБанка,
	|	ЗарплатныеПроекты.РасчетныйСчет КАК НомерРасчетногоСчетаОрганизации,
	|	ЗарплатныеПроекты.ФорматФайла КАК ФорматФайла,
	|	ЗарплатныеПроекты.КодировкаФайла КАК КодировкаФайла,
	|	ИтоговыеДанныеПоВедомости.КоличествоЗаписей КАК КоличествоЗаписей,
	|	ИтоговыеДанныеПоВедомости.СуммаИтого КАК СуммаИтого,
	|	ВедомостьНаВыплатуЗарплатыВБанк.СуммаПоДокументу КАК СуммаПоДокументу,
	|	ВедомостьНаВыплатуЗарплатыВБанк.Руководитель КАК Руководитель,
	|	ВедомостьНаВыплатуЗарплатыВБанк.ДолжностьРуководителя.Наименование КАК РуководительДолжность,
	|	ВедомостьНаВыплатуЗарплатыВБанк.ГлавныйБухгалтер КАК ГлавныйБухгалтер,
	|	ВедомостьНаВыплатуЗарплатыВБанк.ДолжностьГлавногоБухгалтера КАК ГлавныйБухгалтерДолжность,
	|	ВедомостьНаВыплатуЗарплатыВБанк.Бухгалтер КАК Бухгалтер,
	|	ВедомостьНаВыплатуЗарплатыВБанк.ДолжностьБухгалтера КАК БухгалтерДолжность
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк КАК ВедомостьНаВыплатуЗарплатыВБанк
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО ВедомостьНаВыплатуЗарплатыВБанк.Организация = Организации.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗарплатныеПроекты КАК ЗарплатныеПроекты
	|		ПО ВедомостьНаВыплатуЗарплатыВБанк.ЗарплатныйПроект = ЗарплатныеПроекты.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанков КАК КлассификаторБанков
	|		ПО (ЗарплатныеПроекты.Банк = КлассификаторБанков.Ссылка)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ДанныеВедомостейДляОплатыЧерезБанк.Ссылка КАК Ведомость,
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеВедомостейДляОплатыЧерезБанк.Сотрудник.ФизическоеЛицо) КАК КоличествоЗаписей,
	|			СУММА(ДанныеВедомостейДляОплатыЧерезБанк.КВыплате + ДанныеВедомостейДляОплатыЧерезБанк.КомпенсацияЗаЗадержкуЗарплаты) КАК СуммаИтого
	|		ИЗ
	|			Документ.ВедомостьНаВыплатуЗарплатыВБанк.Зарплата КАК ДанныеВедомостейДляОплатыЧерезБанк
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ДанныеВедомостейДляОплатыЧерезБанк.Ссылка) КАК ИтоговыеДанныеПоВедомости
	|		ПО ВедомостьНаВыплатуЗарплатыВБанк.Ссылка = ИтоговыеДанныеПоВедомости.Ведомость
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ТолькоПроведенные
	|				ТОГДА ВедомостьНаВыплатуЗарплатыВБанк.Проведен
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И ВедомостьНаВыплатуЗарплатыВБанк.Ссылка В(&МассивДокументов)";
	Запрос.Выполнить();
	
	ИменаПолейОтветственныхЛиц = Новый Массив;
	ИменаПолейОтветственныхЛиц.Добавить("Руководитель");
	ИменаПолейОтветственныхЛиц.Добавить("ГлавныйБухгалтер");
	ИменаПолейОтветственныхЛиц.Добавить("Бухгалтер");
	
	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Истина, ИменаПолейОтветственныхЛиц, "ВТДанныеДокументов");
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка КАК Документ,
	|	ДанныеДокументов.НомерДокумента КАК НомерДокумента,
	|	ДанныеДокументов.Дата КАК ДатаДокумента,
	|	ДанныеДокументов.НомерРеестра КАК НомерРеестра,
	|	ДанныеДокументов.ВидДоходаИсполнительногоПроизводства КАК ВидДоходаИсполнительногоПроизводства,
	|	ДанныеДокументов.ПериодРегистрации КАК ПериодРегистрации,
	|	ДанныеДокументов.Организация КАК Организация,
	|	ДанныеДокументов.ПолноеНаименованиеОрганизации КАК ПолноеНаименованиеОрганизации,
	|	ДанныеДокументов.ИННОрганизации КАК ИННОрганизации,
	|	ДанныеДокументов.КодПоОКПО КАК КодПоОКПО,
	|	ДанныеДокументов.ЗарплатныйПроект КАК ЗарплатныйПроект,
	|	ДанныеДокументов.НомерДоговора КАК НомерДоговора,
	|	ДанныеДокументов.ДатаДоговора КАК ДатаДоговора,
	|	ДанныеДокументов.ОтделениеБанка КАК ОтделениеБанка,
	|	ДанныеДокументов.ИспользоватьЭлектронныйДокументооборотСБанком КАК ИспользоватьЭлектронныйДокументооборотСБанком,
	|	ДанныеДокументов.БИКБанка КАК БИКБанка,
	|	ДанныеДокументов.НомерРасчетногоСчетаОрганизации КАК НомерРасчетногоСчетаОрганизации,
	|	ДанныеДокументов.ФорматФайла КАК ФорматФайла,
	|	ДанныеДокументов.КодировкаФайла КАК КодировкаФайла,
	|	ДанныеДокументов.КоличествоЗаписей КАК КоличествоЗаписей,
	|	ДанныеДокументов.СуммаИтого КАК СуммаИтого,
	|	ДанныеДокументов.СуммаПоДокументу КАК СуммаПоДокументу,
	|	ЕСТЬNULL(ВТФИОРуководителейПоследние.РасшифровкаПодписи, """") КАК Руководитель,
	|	ДанныеДокументов.РуководительДолжность КАК РуководительДолжность,
	|	ЕСТЬNULL(ВТФИОГлавБухПоследние.РасшифровкаПодписи, """") КАК ГлавныйБухгалтер,
	|	ДанныеДокументов.ГлавныйБухгалтерДолжность КАК ГлавныйБухгалтерДолжность,
	|	ЕСТЬNULL(ВТФИОБухгалтерПоследние.РасшифровкаПодписи, """") КАК Бухгалтер,
	|	ДанныеДокументов.БухгалтерДолжность КАК БухгалтерДолжность
	|ИЗ
	|	ВТДанныеДокументов КАК ДанныеДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОРуководителейПоследние
	|		ПО ДанныеДокументов.Ссылка = ВТФИОРуководителейПоследние.Ссылка
	|			И ДанныеДокументов.Руководитель = ВТФИОРуководителейПоследние.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОГлавБухПоследние
	|		ПО ДанныеДокументов.Ссылка = ВТФИОГлавБухПоследние.Ссылка
	|			И ДанныеДокументов.ГлавныйБухгалтер = ВТФИОГлавБухПоследние.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОБухгалтерПоследние
	|		ПО ДанныеДокументов.Ссылка = ВТФИОБухгалтерПоследние.Ссылка
	|			И ДанныеДокументов.Бухгалтер = ВТФИОБухгалтерПоследние.ФизическоеЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеДокументов.Организация,
	|	НАЧАЛОПЕРИОДА(ДанныеДокументов.Дата, ГОД),
	|	ДанныеДокументов.НомерДокумента,
	|	ДанныеДокументов.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеСтрокДокументов.Документ КАК Документ,
	|	ДанныеСтрокДокументов.НомерДокумента КАК НомерДокумента,
	|	ДанныеСтрокДокументов.ДатаДокумента КАК ДатаДокумента,
	|	ДанныеСтрокДокументов.НомерРеестра КАК НомерРеестра,
	|	ДанныеСтрокДокументов.ВидДоходаИсполнительногоПроизводства КАК ВидДоходаИсполнительногоПроизводства,
	|	ДанныеСтрокДокументов.Организация КАК Организация,
	|	ДанныеСтрокДокументов.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ДанныеСтрокДокументов.Фамилия КАК Фамилия,
	|	ДанныеСтрокДокументов.Имя КАК Имя,
	|	ДанныеСтрокДокументов.Отчество КАК Отчество,
	|	ДанныеСтрокДокументов.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
	|	ДанныеСтрокДокументов.ВзысканнаяСумма КАК ВзысканнаяСумма,
	|	ДанныеСтрокДокументов.СуммаКВыплате КАК СуммаКВыплате,
	|	ДанныеСтрокДокументов.ОтделениеБанка КАК ОтделениеБанка,
	|	ДанныеСтрокДокументов.ФилиалОтделенияБанка КАК ФилиалОтделенияБанка,
	|	ДанныеСтрокДокументов.КодВалюты КАК КодВалюты
	|ИЗ
	|	ВТДанныеСтрокДокументов КАК ДанныеСтрокДокументов
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеСтрокДокументов.Организация,
	|	НАЧАЛОПЕРИОДА(ДанныеСтрокДокументов.ДатаДокумента, ГОД),
	|	ДанныеСтрокДокументов.НомерДокумента,
	|	ДанныеСтрокДокументов.Документ,
	|	ДанныеСтрокДокументов.НомерСтроки";
	
	РеквизитыПлатежногоДокумента = Неопределено;
	Если ПлатежныйДокумент <> Неопределено Тогда 
		
		РеквизитыПлатежногоДокумента = Новый Структура;
		РеквизитыПлатежногоДокумента.Вставить("ПлатежныйДокумент", ПлатежныйДокумент);
		РеквизитыПлатежногоДокумента.Вставить("Номер",             "");     
		РеквизитыПлатежногоДокумента.Вставить("Дата",              Дата("00010101")); 
		РеквизитыПлатежногоДокумента.Вставить("Организация",       Неопределено);
		
		Выборка = 
			РегистрыСведений.РеквизитыПлатежныхДокументовПеречисленияЗарплаты.Выбрать(
				Новый Структура("ПлатежныйДокумент", ПлатежныйДокумент));
		
		Если Выборка.Следующий() Тогда 
			ЗаполнитьЗначенияСвойств(РеквизитыПлатежногоДокумента, Выборка);
		КонецЕсли;
		
	КонецЕсли;
	
	ГодыВыгрузки = Новый Массив;
	СоответствиеДокументов = Новый Соответствие;
	Если РеквизитыПлатежногоДокумента <> Неопределено Тогда 
		ГодыВыгрузки.Добавить(Год(РеквизитыПлатежногоДокумента.Дата));
	КонецЕсли;
	Для Каждого ДокументСсылка Из МассивДокументов Цикл 
		ДанныеДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, "Дата, Номер, Организация, НомерРеестра");
		Если РеквизитыПлатежногоДокумента = Неопределено Тогда 
			ГодВыгрузки = Год(ДанныеДокумента.Дата);
			Если ГодыВыгрузки.Найти(ГодВыгрузки) = Неопределено Тогда 
				ГодыВыгрузки.Добавить(ГодВыгрузки);
			КонецЕсли;
		КонецЕсли;
		СоответствиеДокументов.Вставить(ДокументСсылка, ДанныеДокумента);
	КонецЦикла;
	НомераРеестров = ОбменСБанкамиПоЗарплатнымПроектам.НомераРеестровДокументов(СоответствиеДокументов, ГодыВыгрузки, РеквизитыПлатежногоДокумента);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	КоличествоЗаписей = 0;
	СуммаИтого = 0;
	ДанныеДокументов = Новый Соответствие;
	ВыборкаДокументов = РезультатыЗапроса[РезультатыЗапроса.ВГраница()-1].Выбрать();
	ВыборкаСтрокДокументов = РезультатыЗапроса[РезультатыЗапроса.ВГраница()].Выбрать();
	Пока ВыборкаДокументов.Следующий() Цикл
		
		ДанныеДокумента = ДанныеЗаполненияВедомости();
		ЗаполнитьЗначенияСвойств(ДанныеДокумента, ВыборкаДокументов);
		
		КоличествоЗаписей = КоличествоЗаписей + ВыборкаДокументов.КоличествоЗаписей;
		СуммаИтого = СуммаИтого + ВыборкаДокументов.СуммаИтого;
		
		ДанныеДокумента.ДатаФормирования = ?(ДатаПолученияДанных = Неопределено, ДанныеДокумента.ДатаДокумента, ДатаПолученияДанных);
		Если ПлатежныйДокумент <> Неопределено Тогда
			ДанныеДокумента.ИдПервичногоДокумента = ПлатежныйДокумент.УникальныйИдентификатор();
			ДанныеДокумента.НомерПлатежногоПоручения = Прав(РеквизитыПлатежногоДокумента.Номер, 6);
			ДанныеДокумента.ДатаПлатежногоПоручения = РеквизитыПлатежногоДокумента.Дата;
			ДанныеДокумента.ДатаДокумента = РеквизитыПлатежногоДокумента.Дата;
			ДанныеДокумента.КоличествоЗаписей = КоличествоЗаписей;
			ДанныеДокумента.СуммаИтого = СуммаИтого;
			ДанныеДокумента.ДанныеРеестра = НомераРеестров[ПлатежныйДокумент];
			НомерРеестра = СтрЗаменить(ДанныеДокумента.ДанныеРеестра.НомерРеестра, Символы.НПП, "");
			ДанныеДокумента.НомерРеестра = НомерРеестра;
			НомерРеестра = Прав(СтроковыеФункцииКлиентСервер.ДополнитьСтроку(НомерРеестра, 3), 3);
			ДанныеДокумента.ИмяФайла = ОбменСБанкамиПоЗарплатнымПроектам.ИмяФайлаОбменаСБанкамиПоЗарплатнымПроектам(ПлатежныйДокумент, ДанныеДокумента.ОтделениеБанка, НомерРеестра, "z");
		Иначе
			ДанныеДокумента.ИдПервичногоДокумента = ДанныеДокумента.Документ.УникальныйИдентификатор();
			ДанныеДокумента.ДанныеРеестра = НомераРеестров[ДанныеДокумента.Документ];
			НомерРеестра = СтрЗаменить(ДанныеДокумента.ДанныеРеестра.НомерРеестра, Символы.НПП, "");
			ДанныеДокумента.НомерРеестра = НомерРеестра;
			НомерРеестра = Прав(СтроковыеФункцииКлиентСервер.ДополнитьСтроку(НомерРеестра, 3), 3);
			НомерРеестра = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(НомерРеестра, 3);
			ДанныеДокумента.ИмяФайла = ОбменСБанкамиПоЗарплатнымПроектам.ИмяФайлаОбменаСБанкамиПоЗарплатнымПроектам(ДанныеДокумента.Документ, ДанныеДокумента.ОтделениеБанка, НомерРеестра, "z");
		КонецЕсли;
		ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ЗаполнитьДанныеОплатыВедомостей(
			ДанныеДокумента.Документ, ДанныеДокумента.НомерПлатежногоПоручения, ДанныеДокумента.ДатаПлатежногоПоручения, ПлатежныйДокумент);
		
		ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ОпределитьДанныеШапкиДокументаДляПолученияТекстаФайла(
			ДанныеДокумента, ДанныеДокумента.Документ, ?(ДатаПолученияДанных = Неопределено, ДанныеДокумента.ДатаДокумента, ДатаПолученияДанных));
		
		ВыборкаСтрокДокументов.Сбросить();
		Пока ВыборкаСтрокДокументов.НайтиСледующий(ВыборкаДокументов.Документ, "Документ") Цикл
			ДанныеСтрокиДокумента = ДанныеЗаполненияСтрокиВедомости();
			ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ДополнитьКолонкиДанныхСтрокДокументов(ДанныеСтрокиДокумента);
			ЗаполнитьЗначенияСвойств(ДанныеСтрокиДокумента, ВыборкаСтрокДокументов);
			
			ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ЗаполнитьКолонкиДанныхСтрокДокумента(ДанныеСтрокиДокумента);
			ДанныеДокумента.Сотрудники.Добавить(ДанныеСтрокиДокумента);
			ДанныеДокумента.Сотрудники[ДанныеДокумента.Сотрудники.Количество()-1].НомерСтроки = ДанныеДокумента.Сотрудники.Количество();
			Если ДанныеДокумента.ИспользоватьЭлектронныйДокументооборотСБанком И СтрДлина(ДанныеСтрокиДокумента.НомерЛицевогоСчета) <> 20 Тогда
				СообщениеОбОшибке = СтрШаблон(
						НСтр("ru = 'По ведомости в банк №%1 от %2г. в строке №%3 у сотрудника %4 лицевой счет менее 20 цифр.
							     |Если номер действительно не удовлетворяет этому требованию, возможно,
							     |банк не поддерживает обмен по типовому стандарту - следует обратиться в банк';
							     |en = 'Personal account of employee %4 in line No. %3 is less than 20 digits under the paysheet to bank No.%1 dated %2. 
							     |If the number does not meet the requirement, 
							     |the bank may not support exchange using a typical standard. Contact the bank.'"), 
						ДанныеДокумента.НомерДокумента, 
						Формат(ДанныеДокумента.ДатаДокумента, "ДЛФ=D"),
						ДанныеСтрокиДокумента.НомерСтроки,
						ДанныеСтрокиДокумента.ФизическоеЛицо);
				ОбщегоНазначения.СообщитьПользователю(
					СообщениеОбОшибке, 
					ДанныеДокумента.Документ,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Состав", ДанныеСтрокиДокумента.НомерСтроки, "НомерЛицевогоСчета"));
			КонецЕсли;
		КонецЦикла;
		ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ОпределитьДанныеСтрокДокументовДляПолученияТекстаФайла(
			ДанныеДокумента, 
			?(ДатаПолученияДанных = Неопределено, ДанныеДокумента.ДатаДокумента, ДатаПолученияДанных));
		
		Если ПлатежныйДокумент <> Неопределено Тогда
			ДанныеДокумента.Документ = ПлатежныйДокумент;
			ДанныеПлатежногоДокумента = ДанныеДокументов.Получить(ПлатежныйДокумент);
			Если ДанныеПлатежногоДокумента <> Неопределено Тогда
				Для Каждого СтруктураСтроки Из ДанныеПлатежногоДокумента.Сотрудники Цикл
					НайденнаяСтрокаПоФизическомуЛицу = Неопределено;
					Для каждого СтруктураСтрокиДокумента Из ДанныеДокумента.Сотрудники Цикл
						Если СтруктураСтрокиДокумента.ФизическоеЛицо = СтруктураСтроки.ФизическоеЛицо
							И СтруктураСтрокиДокумента.НомерЛицевогоСчета = СтруктураСтроки.НомерЛицевогоСчета Тогда
							НайденнаяСтрокаПоФизическомуЛицу = СтруктураСтрокиДокумента;
							Прервать;
						КонецЕсли
					КонецЦикла;
					Если НайденнаяСтрокаПоФизическомуЛицу = Неопределено Тогда
						ДанныеДокумента.Сотрудники.Добавить(СтруктураСтроки);
						ДанныеДокумента.Сотрудники[ДанныеДокумента.Сотрудники.Количество()-1].НомерСтроки = ДанныеДокумента.Сотрудники.Количество();
					Иначе
						НайденнаяСтрокаПоФизическомуЛицу.СуммаКВыплате   = НайденнаяСтрокаПоФизическомуЛицу.СуммаКВыплате   + СтруктураСтроки.СуммаКВыплате;
						НайденнаяСтрокаПоФизическомуЛицу.ВзысканнаяСумма = НайденнаяСтрокаПоФизическомуЛицу.ВзысканнаяСумма + СтруктураСтроки.ВзысканнаяСумма;
					КонецЕсли;
				КонецЦикла;
				ДанныеДокумента.КоличествоЗаписей = ДанныеДокумента.Сотрудники.Количество();
			КонецЕсли;
		КонецЕсли;
		ДанныеДокументов.Вставить(ДанныеДокумента.Документ, ДанныеДокумента);
		
	КонецЦикла;
	
	Возврат ДанныеДокументов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВидМестаВыплаты(Ведомость = Неопределено) Экспорт
	Возврат Перечисления.ВидыМестВыплатыЗарплаты.ЗарплатныйПроект
КонецФункции

Функция ТекстЗапросаДанныеДляОплаты(ИмяПараметраВедомости = "Ведомости", ИмяПараметраФизическиеЛица = "ФизическиеЛица") Экспорт
	Возврат 
		ВедомостьНаВыплатуЗарплаты.ТекстЗапросаДанныеДляОплатыБезналично(		
			Метаданные.Документы.ВедомостьНаВыплатуЗарплатыВБанк.ПолноеИмя(), 
			ИмяПараметраВедомости, ИмяПараметраФизическиеЛица);
КонецФункции	

// Возвращает соответствие физических лиц номерам лицевых счетов.
//
// Параметры:
//		Ведомости - массив ссылок на документы.
//		ЛицевыеСчета - массив с номерами лицевых счетов, для которых требуется найти физических лиц.
//
// Возвращаемое значение:
//		Соответствие, где ключ - это номер лицевого счета, значение - физическое лицо.
//
Функция ФизическиеЛицаЛицевыхСчетов(Ведомости, ЛицевыеСчета) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ведомости",    Ведомости);
	Запрос.УстановитьПараметр("ЛицевыеСчета", ЛицевыеСчета);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВедомостьСостав.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
	|	ВедомостьСостав.ФизическоеЛицо КАК ФизическоеЛицо
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.Состав КАК ВедомостьСостав
	|ГДЕ
	|	ВедомостьСостав.Ссылка В(&Ведомости)
	|	И ВедомостьСостав.НомерЛицевогоСчета В(&ЛицевыеСчета)";
	
	ФизическиеЛицаЛицевыхСчетов = Новый Соответствие;
	Выборка =  Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ФизическиеЛицаЛицевыхСчетов.Вставить(Выборка.НомерЛицевогоСчета, Выборка.ФизическоеЛицо);
	КонецЦикла;
	
	Возврат ФизическиеЛицаЛицевыхСчетов;
	
КонецФункции

#Область Печать

Функция ПечатьСпискаПеречисленийПоДокументам(МассивОбъектов, ОбъектыПечати, ПлатежныйДокумент = Неопределено) Экспорт
	
	ТабличныйДокумент = ПечатьСписокПеречислений(
		МассивОбъектов,
		ОбъектыПечати,
		ДанныеВедомостиНаВыплатуЗарплатыВБанк(МассивОбъектов, , ПлатежныйДокумент, Ложь));
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьСпискаПеречисленийПоXML(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабличныйДокумент = ПечатьСписокПеречислений(МассивОбъектов, ОбъектыПечати,
		ОбменСБанкамиПоЗарплатнымПроектам.ДанныеСпискаПеречисленийПоXML(МассивОбъектов));
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьСписокПеречислений(МассивОбъектов, ОбъектыПечати, ДанныеДляПечати)
	
	ПутьКМакету = "ОбщийМакет.ПФ_MXL_СписокПеречисленийНаЛицевыеСчета";
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВедомостьНаВыплатуЗарплатыВБанк_СписокПеречислений";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы(ПутьКМакету);
	
	ДанныеПечати = УправлениеПечатьюБЗК.ПараметрыОбластейСтандартногоМакета(ПутьКМакету);
	
	ПервыйДокумент = Истина;
	
	Для Каждого ДанныеДокументаДляПечати Из ДанныеДляПечати Цикл
		
		ДанныеДокумента = ДанныеДокументаДляПечати.Значение;
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подсчитываем количество страниц документа - для корректного разбиения на страницы.
		ВсегоСтрокДокумента = ДанныеДокумента.Сотрудники.Количество();
		
		ОбластьМакетаШапкаДокумента  = Макет.ПолучитьОбласть("ШапкаДокумента");
		ОбластьМакетаШапка           = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакетаСтрока          = Макет.ПолучитьОбласть("Строка");
		ОбластьМакетаИтогПоСтранице  = Макет.ПолучитьОбласть("ИтогПоЛисту");
		ОбластьМакетаПодвалДокумента = Макет.ПолучитьОбласть("Подвал");
		
		// Массив с двумя строками - для разбиения на страницы.
		ВыводимыеОбласти = Новый Массив();
		ВыводимыеОбласти.Добавить(ОбластьМакетаСтрока);
		ВыводимыеОбласти.Добавить(ОбластьМакетаИтогПоСтранице);
		
		// выводим данные о документе
		Если ЗначениеЗаполнено(ДанныеДокумента.ЗарплатныйПроект) И ЗначениеЗаполнено(ДанныеДокумента.НомерРеестра) Тогда
			ДанныеПечати.ШапкаДокумента.НомерРеестра = ДанныеДокумента.НомерРеестра;
		Иначе                                 	
			ДанныеПечати.ШапкаДокумента.НомерРеестра = 
				ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(
					ДанныеДокумента.НомерДокумента, 
					Истина, Истина);
		КонецЕсли;	
		ДанныеПечати.ШапкаДокумента.Дата          = Формат(ДанныеДокумента.ДатаДокумента, "ДЛФ=D");
		ДанныеПечати.ШапкаДокумента.Организация   = СокрЛП(ДанныеДокумента.ПолноеНаименованиеОрганизации);
		ДанныеПечати.ШапкаДокумента.КодВидаДохода = ВидыДоходовИсполнительногоПроизводстваКлиентСервер.КодВидаДохода(
		                                            	ДанныеДокумента.ВидДоходаИсполнительногоПроизводства);
		ОбластьМакетаШапкаДокумента.Параметры.Заполнить(ДанныеПечати.ШапкаДокумента);
		
		ТабличныйДокумент.Вывести(ОбластьМакетаШапкаДокумента);
		ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
		
		ВыведеноСтраниц = 1; 
		ВыведеноСтрок   = 0; 
		ИтогоНаСтранице = 0; 
		Итого           = 0;
		ВзысканоНаСтранице = 0;
		ВзысканоВсего      = 0;
		
		// Выводим данные по строкам документа.
		Для Каждого ДанныеДляПечатиСтроки Из ДанныеДокумента.Сотрудники Цикл
			
			ДанныеПечати.Строка.НомерСтроки = ДанныеДляПечатиСтроки.НомерСтроки;
			ДанныеПечати.Строка.НомерЛицевогоСчета = ДанныеДляПечатиСтроки.НомерЛицевогоСчета;
			ДанныеПечати.Строка.Физлицо = 
				СтрШаблон(
					НСтр("ru = '%1 %2 %3';
						|en = '%1 %2 %3'"), 
					ДанныеДляПечатиСтроки.Фамилия, 
					ДанныеДляПечатиСтроки.Имя, 
					ДанныеДляПечатиСтроки.Отчество);
			ДанныеПечати.Строка.Сумма    = ДанныеДляПечатиСтроки.СуммаКВыплате;
			ДанныеПечати.Строка.Взыскано = ДанныеДляПечатиСтроки.ВзысканнаяСумма;
			
			ОбластьМакетаСтрока.Параметры.Заполнить(ДанныеПечати.Строка);
			
			// разбиение на страницы
			ВыведеноСтрок = ВыведеноСтрок + 1;
			
			// Проверим, уместится ли строка на странице или надо открывать новую страницу.
			ВывестиПодвалЛиста = Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ВыводимыеОбласти);
			Если Не ВывестиПодвалЛиста И ВыведеноСтрок = ВсегоСтрокДокумента Тогда
				ВыводимыеОбласти.Добавить(ОбластьМакетаПодвалДокумента);
				ВывестиПодвалЛиста = Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ВыводимыеОбласти);
			КонецЕсли;
			Если ВывестиПодвалЛиста Тогда
				
				ОбщегоНазначенияБЗККлиентСервер.УстановитьЗначениеСвойства(
					ОбластьМакетаИтогПоСтранице.Параметры, "ИтогоНаСтранице",   ИтогоНаСтранице); 
				ОбщегоНазначенияБЗККлиентСервер.УстановитьЗначениеСвойства(
					ОбластьМакетаИтогПоСтранице.Параметры, "ВзысканоНаСтранице", ВзысканоНаСтранице); 
				
				ТабличныйДокумент.Вывести(ОбластьМакетаИтогПоСтранице);
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
				
				ВыведеноСтраниц = ВыведеноСтраниц + 1;
				ИтогоНаСтранице    = 0;
				ВзысканоНаСтранице = 0;
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакетаСтрока);
			
			ИтогоНаСтранице = ИтогоНаСтранице + ДанныеДляПечатиСтроки.СуммаКВыплате;
			Итого           = Итого +           ДанныеДляПечатиСтроки.СуммаКВыплате;
			ВзысканоНаСтранице = ВзысканоНаСтранице + ДанныеДляПечатиСтроки.ВзысканнаяСумма;
			ВзысканоВсего      = ВзысканоВсего +      ДанныеДляПечатиСтроки.ВзысканнаяСумма;
			
		КонецЦикла;
		
		Если ВыведеноСтрок > 0 Тогда 
			ОбщегоНазначенияБЗККлиентСервер.УстановитьЗначениеСвойства(
				ОбластьМакетаИтогПоСтранице.Параметры, "ИтогоНаСтранице", ИтогоНаСтранице); 
			ОбщегоНазначенияБЗККлиентСервер.УстановитьЗначениеСвойства(
				ОбластьМакетаИтогПоСтранице.Параметры, "ВзысканоНаСтранице", ВзысканоНаСтранице); 
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ДанныеПечати.Подвал, ДанныеДокумента);
		ДанныеПечати.Подвал.Итого         = Итого;
		ДанныеПечати.Подвал.ВзысканоВсего = ВзысканоВсего;
		ОбластьМакетаПодвалДокумента.Параметры.Заполнить(ДанныеПечати.Подвал);
		
		// дополняем пустыми строками до конца страницы
		ОбщегоНазначенияБЗК.ОчиститьПараметрыТабличногоДокумента(ОбластьМакетаСтрока);
		ОбластиКонцаСтраницы = Новый Массив();
		ОбластиКонцаСтраницы.Добавить(ОбластьМакетаИтогПоСтранице);
		ОбластиКонцаСтраницы.Добавить(ОбластьМакетаПодвалДокумента);
		ОбщегоНазначенияБЗК.ДополнитьСтраницуТабличногоДокумента(ТабличныйДокумент, ОбластьМакетаСтрока, ОбластиКонцаСтраницы);  
		
		ТабличныйДокумент.Вывести(ОбластьМакетаИтогПоСтранице);
		ТабличныйДокумент.Вывести(ОбластьМакетаПодвалДокумента);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеДокумента.Документ);
		
	КонецЦикла; // по документам
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Возвращает данные шапки документов для печати.
//
// Параметры: 
//  Ведомости - Массив - документы, данные которых возвращаются (ДокументСсылка.ВедомостьНаВыплатуЗарплатыВБанк).
//
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса 
//
Функция ВыборкаДляПечатиШапки(Ведомости) Экспорт
	Возврат ВедомостьНаВыплатуЗарплаты.ВыборкаДляПечатиШапкиПриВыплатеБезналично(
		Метаданные.Документы.ВедомостьНаВыплатуЗарплатыВБанк.ПолноеИмя(), 
		Ведомости)
КонецФункции
	
// Формирует запрос по табличной части документа.
//
// Параметры: 
//  Ведомости - массив ДокументСсылка.ВедомостьНаВыплатуЗарплатыВБанк.
//
// Возвращаемое значение:
//  Выборка из результата запроса.
//
Функция ВыборкаДляПечатиТаблицы(Ведомости) Экспорт
	Возврат ВедомостьНаВыплатуЗарплаты.ВыборкаДляПечатиТаблицы(
		Метаданные.Документы.ВедомостьНаВыплатуЗарплатыВБанк.ПолноеИмя(), 
		Ведомости)
КонецФункции

#КонецОбласти

#Область ФормированиеФайлаОбменаСБанками

// Формирует и прикрепляет файл обмена к документам с помощью подсистемы "Файлы".
//
// Параметры:
//		СтруктураПараметровДляФормированияФайла - Структура - должна содержать значения:
//			МассивДокументов - Массив ссылок на документы, по которым требуется сформировать файл.
//			МассивОписанийФайлов - Массив описаний сформированных файлов.
//
Процедура ВыгрузитьФайлыОбменаСБанком(СтруктураПараметровДляФормированияФайла) Экспорт
	
	ОбменСБанкамиПоЗарплатнымПроектам.ВыгрузитьФайлыОбменаСБанкомПоВедомости(СтруктураПараметровДляФормированияФайла);
	
КонецПроцедуры

#КонецОбласти

#Область ДанныеДляЗаполнения

Функция ПараметрыЗаполненияПоОбъекту(Объект) Экспорт
	ПараметрыЗаполнения = ВедомостьНаВыплатуЗарплаты.ПараметрыЗаполненияПоОбъекту(Объект);
	ПараметрыЗаполнения.ОписаниеОперации.ВидДохода             = Объект.ВидДоходаИсполнительногоПроизводства;
	ПараметрыЗаполнения.ОтборСотрудников.МестоВыплаты.Вид      = Перечисления.ВидыМестВыплатыЗарплаты.ЗарплатныйПроект;
	ПараметрыЗаполнения.ОтборСотрудников.МестоВыплаты.Значение = Объект.ЗарплатныйПроект;
	Возврат ПараметрыЗаполнения
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Процедура ОчиститьВидыДоходовИсполнительногоПроизводства(ПараметрыОбновления = Неопределено) Экспорт
	ВедомостьНаВыплатуЗарплаты.ОчиститьВидыДоходовИсполнительногоПроизводстваЗарплаты(
		Метаданные.Документы.ВедомостьНаВыплатуЗарплатыВБанк,
		ПараметрыОбновления);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли