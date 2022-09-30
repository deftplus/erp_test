#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Описание - возвращает описание разделов данных, которые содержит документ
// 
// Возвращаемое значение:
// 	Соответствие - описание разделов данных документов -
//	 *Ключ - Строка - имя раздела. Одно из значений структуры 
//		возвращаемой методом см. МногофункциональныеДокументыБЗККлиентСервер.РазделыДанных
//   *Значение - см. МногофункциональныеДокументыБЗККлиентСервер.НовыйОписаниеРазделаДанных - описание раздела
//
Функция ОписаниеРазделовДанных() Экспорт
	ВсеРазделы = МногофункциональныеДокументыБЗККлиентСервер.РазделыДанных();
	
	ОписаниеРазделовДанных = Новый Соответствие();
	
	ОписаниеРаздела = МногофункциональныеДокументыБЗККлиентСервер.НовыйОписаниеРазделаДанных();
	ОписаниеРазделовДанных.Вставить(ВсеРазделы.КадровыеДанные, ОписаниеРаздела);	
	ОписаниеРаздела.РеквизитСостояние = "Проведен";
	ОписаниеРаздела.РеквизитОтветсвенный = "Ответственный";
	
	ОписаниеРаздела = МногофункциональныеДокументыБЗККлиентСервер.НовыйОписаниеРазделаДанных();
	ОписаниеРазделовДанных.Вставить(ВсеРазделы.ПлановыеНачисления, ОписаниеРаздела);
	ОписаниеРаздела.РеквизитСостояние = "НачисленияУтверждены";	
	ОписаниеРаздела.ТребуетсяУтверждениеПриПроведении = Истина;
	ОписаниеРаздела.СообщениеДокументНеУтвержден =  НСтр("ru = '%1 - документ не утвержден.';
														|en = '%1 - the document is not confirmed.'");
	
	Возврат ОписаниеРазделовДанных;
КонецФункции

// Описание - возвращает структуру со значениями по которым будут проверяться права на разделы документа
// 				 
// Параметры:
//  ДокументОбъект - ДокументОбъект.ИзменениеКвалификационногоРазряда, ДанныеФормыСтруктура - объект или данные формы, 
//					отображающие данные документа, для которого нужно получить данные
//
// Возвращаемое значение:
// 	Структура -  см. НовыйЗначенияДоступа - значения доступа по которым будут проверяться права на документ
//
Функция ЗначенияДоступа(ДокументОбъект) Экспорт
	Возврат МногофункциональныеДокументыБЗК.ЗначенияДоступаПоСоставуДокумента(
		ДокументОбъект, 
		ДокументОбъект.Организация);
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаФизическоеЛицоВШапке();
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.ИзменениеКвалификационногоРазряда);
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ о присвоении разряда.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ПФ_MXL_ПриказОПрисвоенииРазряда";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о присвоении разряда';
										|en = 'Category conferment order'");
	КомандаПечати.Порядок = 10;
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст
//                           ошибки).
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя
//                           области в которой был выведен объект).
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ПриказОПрисвоенииРазряда") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
						КоллекцияПечатныхФорм, 
						"ПФ_MXL_ПриказОПрисвоенииРазряда", 
						НСтр("ru = 'Приказ о присвоении разряда';
							|en = 'Category conferment order'"), 
						ПечатнаяФормаПриказаОПрисвоенииРазряда(МассивОбъектов, ОбъектыПечати), ,
						"Документ.РаботаСверхурочно.ПФ_MXL_ПриказОПрисвоенииРазряда");
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатнаяФормаПриказаОПрисвоенииРазряда(МассивОбъектов, ОбъектыПечати)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПриказОПрисвоенииРазряда";
	
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИзменениеКвалификационногоРазряда.ПФ_MXL_ПриказОПрисвоенииРазряда");
	
	ОбластьШапка 	  = Макет.ПолучитьОбласть("Шапка");
	ОбластьРаботник   = Макет.ПолучитьОбласть("Работник");
	ОбластьПодвал 	  = Макет.ПолучитьОбласть("Подвал");
	
	ДанныеДляПечати = ДанныеДляПечатиПриказаОПрисвоенииРазряда(МассивОбъектов);
	
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	
	Пока ВыборкаПоДокументам.Следующий() Цикл  
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		Параметры = ПолучитьСтруктуруПараметровПриказаОПрисвоенииРазряда();
		КадровыйУчет.ЗаполнитьПараметрыКадровогоПриказа(Параметры, ВыборкаПоДокументам);
		
		Параметры.НомерДок = ЗарплатаКадрыОтчеты.НомерНаПечать(ВыборкаПоДокументам.Номер, ВыборкаПоДокументам.НомерПриказа);
		
		Параметры.ДатаИзменения = Формат(Параметры.ДатаИзменения, "ДЛФ=ДД");
		Параметры.ДатаДок = Формат(Параметры.ДатаДок, "ДЛФ=Д");
		
		Параметры.Должность = СклонениеПредставленийОбъектов.ПросклонятьПредставление(Строка(Параметры.Должность), 3, Параметры.Должность);
		
		ФИОВПадеже = Параметры.ФИОПолные;
		ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(Параметры.ФИОПолные), 3, ФИОВПадеже, ВыборкаПоДокументам.Пол);
		Параметры.ФИОПолные = ФИОВПадеже;		
		
		ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры, Параметры);
		ЗаполнитьЗначенияСвойств(ОбластьРаботник.Параметры, Параметры);
		ЗаполнитьЗначенияСвойств(ОбластьПодвал.Параметры, Параметры);
		
		ОбластьПодвал.Параметры.ФИО = ВыборкаПоДокументам.ФамилияИО;
		
		ТабДокумент.Вывести(ОбластьШапка);
		ТабДокумент.Вывести(ОбластьРаботник);
		ТабДокумент.Вывести(ОбластьПодвал);
		
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоДокументам.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции	

Функция ДанныеДляПечатиПриказаОПрисвоенииРазряда(МассивОбъектов)
	
	// Запрос по шапкам документов.
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИзменениеКвалификационногоРазряда.Ссылка КАК Ссылка,
	|	ИзменениеКвалификационногоРазряда.Дата КАК Дата,
	|	ИзменениеКвалификационногоРазряда.Номер КАК Номер,
	|	ИзменениеКвалификационногоРазряда.Сотрудник КАК Сотрудник,
	|	ИзменениеКвалификационногоРазряда.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ИзменениеКвалификационногоРазряда.РазрядКатегория.НаименованиеПолное КАК Разряд,
	|	ИзменениеКвалификационногоРазряда.ДатаИзменения КАК ДатаИзменения,
	|	ИзменениеКвалификационногоРазряда.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(ИзменениеКвалификационногоРазряда.Организация.НаименованиеПолное, 1, 10) = """"
	|			ТОГДА ИзменениеКвалификационногоРазряда.Организация.Наименование
	|		ИНАЧЕ ИзменениеКвалификационногоРазряда.Организация.НаименованиеПолное
	|	КОНЕЦ КАК НазваниеОрганизации,
	|	ИзменениеКвалификационногоРазряда.Руководитель КАК Руководитель,
	|	ИзменениеКвалификационногоРазряда.ДолжностьРуководителя КАК ДолжностьРуководителя,
	|	ИзменениеКвалификационногоРазряда.НомерПриказа КАК НомерПриказа
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.ИзменениеКвалификационногоРазряда КАК ИзменениеКвалификационногоРазряда
	|ГДЕ
	|	ИзменениеКвалификационногоРазряда.Ссылка В(&МассивОбъектов)";
	
	Запрос.Выполнить();
	
	ИменаПолейОтветственныхЛиц = Новый Массив;
	ИменаПолейОтветственныхЛиц.Добавить("Руководитель");
	
	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Ложь, ИменаПолейОтветственныхЛиц, "ВТДанныеДокументов");
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц, "ВТДанныеДокументов", "Сотрудник,ДатаИзменения");
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Истина, "ФИОПолные, ФамилияИО, Должность, Пол");
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДанныеДокументов.Ссылка КАК Ссылка,
	|	ДанныеДокументов.Номер КАК Номер,
	|	ДанныеДокументов.НомерПриказа КАК НомерПриказа,
	|	ДанныеДокументов.Дата КАК ДатаДок,
	|	ДанныеДокументов.Сотрудник КАК Сотрудник,
	|	ДанныеДокументов.ФизическоеЛицо КАК ФизическоеЛицо,
	|	КадровыеДанныеСотрудников.ФИОПолные КАК ФИОПолные,
	|	КадровыеДанныеСотрудников.ФамилияИО КАК ФамилияИО,
	|	КадровыеДанныеСотрудников.Должность КАК Должность,
	|	КадровыеДанныеСотрудников.Пол КАК Пол,
	|	ДанныеДокументов.Разряд КАК Разряд,
	|	ДанныеДокументов.ДатаИзменения КАК ДатаИзменения,
	|	ДанныеДокументов.Организация КАК Организация,
	|	ДанныеДокументов.НазваниеОрганизации КАК НазваниеОрганизации,
	|	ДанныеДокументов.ДолжностьРуководителя.Наименование КАК ДолжностьРуководителя,
	|	ФИООтветственныхЛиц.РасшифровкаПодписи КАК РуководительРасшифровкаПодписи
	|ИЗ
	|	ВТДанныеДокументов КАК ДанныеДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ФИООтветственныхЛиц
	|		ПО ДанныеДокументов.Руководитель = ФИООтветственныхЛиц.ФизическоеЛицо
	|			И ДанныеДокументов.Ссылка = ФИООтветственныхЛиц.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
	|		ПО ДанныеДокументов.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
	|			И ДанныеДокументов.ДатаИзменения = КадровыеДанныеСотрудников.Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаДок";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеДляПечати = Новый Структура;
	ДанныеДляПечати.Вставить("РезультатПоШапке", РезультатЗапроса);
	
	Возврат ДанныеДляПечати;
	
КонецФункции

Функция ПолучитьСтруктуруПараметровПриказаОПрисвоенииРазряда()
	
	Параметры = КадровыйУчет.ПараметрыКадровогоПриказа();
	
	Параметры.Вставить("Сотрудник");
	Параметры.Вставить("ФИОПолные");
	Параметры.Вставить("Должность");
	Параметры.Вставить("Разряд");
	Параметры.Вставить("ДатаИзменения");
	
	Возврат Параметры;
	
КонецФункции

Функция ДанныеДляПроведенияМероприятияТрудовойДеятельности(СсылкаНаДокумент) Экспорт
	
	ДанныеДляПроведения = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаДокумент);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка КАК Ссылка,
		|	ТаблицаДокумента.Номер КАК Номер,
		|	ТаблицаДокумента.НомерПриказа КАК НомерПриказа,
		|	ТаблицаДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.Сотрудник КАК Сотрудник,
		|	ТаблицаДокумента.ДатаИзменения КАК ДатаМероприятия,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийТрудовойДеятельности.УстановлениеВторойПрофессии) КАК ВидМероприятия,
		|	ТаблицаДокумента.ТрудоваяФункция КАК ТрудоваяФункция,
		|	ТаблицаДокумента.НаименованиеДокумента КАК НаименованиеДокументаОснования,
		|	ТаблицаДокумента.Номер КАК НомерДокументаОснования,
		|	ТаблицаДокумента.Дата КАК ДатаДокументаОснования,
		|	ТаблицаДокумента.ОписаниеДолжностиДляЗаписиОТрудовойДеятельности КАК ОписаниеДолжности,
		|	ТаблицаДокумента.РазрядКатегория КАК РазрядКатегория
		|ИЗ
		|	Документ.ИзменениеКвалификационногоРазряда КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка В(&Ссылка)
		|	И ТаблицаДокумента.ОтразитьВТрудовойКнижке
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		ДвиженияДокумента = Новый Массив;
		ДанныеДляПроведения.Вставить(Выборка.Ссылка, ДвиженияДокумента);
		
		Пока Выборка.Следующий() Цикл
			ДвиженияДокумента.Добавить(ЭлектронныеТрудовыеКнижки.ЗаписьДвиженияМероприятияТрудовойДеятельности(Выборка));
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#КонецОбласти

#КонецЕсли	