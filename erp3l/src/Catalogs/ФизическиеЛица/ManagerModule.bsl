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
	
	ЗащитаПерсональныхДанных.ДобавитьКомандуПечатиСогласияНаОбработкуПерсональныхДанных(КомандыПечати);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Т
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Т1
	|	ПО Т1.ФизическоеЛицо = Т.Ссылка
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЭтоГруппа
	|	ИЛИ ЗначениеРазрешено(Т.Ссылка)
	|	ИЛИ ЭтоАвторизованныйПользователь(Т1.Ссылка)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("ВыборГруппИЭлементов")
		Или Не ЗначениеЗаполнено(Параметры.ВыборГруппИЭлементов) Тогда
		
		ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.ГруппыИЭлементы;
		
	Иначе
		ВыборГруппИЭлементов = Параметры.ВыборГруппИЭлементов;
	КонецЕсли;
	
	Если ВыборГруппИЭлементов <> ИспользованиеГруппИЭлементов.Группы Тогда
		ФизическиеЛицаЗарплатаКадрыВнутренний.ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	ФизическиеЛицаЗарплатаКадрыВнутренний.ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиПравилРегистрации

Процедура ЗарегистрироватьИзмененияПриОбработке(ИмяПланаОбмена, ПРО, Объект, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Выгрузка) Экспорт
	СинхронизацияДанныхЗарплатаКадры.ОграничитьРегистрациюОбъектаОтборомПоФизическимЛицам(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Объект, Объект.Ссылка);
КонецПроцедуры

Процедура ЗарегистрироватьИзмененияПриОбработкеДоп(ИмяПланаОбмена, ПРО, Объект, Ссылка, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш) Экспорт
	СинхронизацияДанныхЗарплатаКадры.ОграничитьРегистрациюОбъектаОтборомПоФизическимЛицам(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Объект, Ссылка);
КонецПроцедуры

#КонецОбласти

Процедура ПодготовитьОбновлениеЗависимыхДанныхПриОбменеПередЗаписью(Объект) Экспорт
	
	Если Объект.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	
	ИменаРеквизитов = ОбщегоНазначения.ВыгрузитьКолонку(Метаданные.Справочники.ФизическиеЛица.Реквизиты, "Имя");
	ПрежниеЗначения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Ссылка, СтрСоединить(ИменаРеквизитов, ","));
	
	Объект.ДополнительныеСвойства.Вставить("ПрежниеЗначения", ПрежниеЗначения);
	
	ФизическиеЛицаЗарплатаКадры.ЗапомнитьРеквизитыПрежнегоСостоянияОбъекта(Объект);
	
КонецПроцедуры

Процедура ПодготовитьОбновлениеЗависимыхДанныхПриОбменеПриЗаписи(Объект) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ПоискФизическихЛиц") Тогда
		МодульПоискФизическихЛиц = ОбщегоНазначения.ОбщийМодуль("ПоискФизическихЛиц");
		МодульПоискФизическихЛиц.ЗаполнитьДанныеПоискаФизическогоЛица(Объект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШаблоныСообщений

Процедура ПриПодготовкеШаблонаСообщения(РеквизитыОбъектаНазначения, Вложения, ДополнительныеПараметры) Экспорт
	ИзменитьРеквизитыШаблонаСообщения(РеквизитыОбъектаНазначения);
КонецПроцедуры

Процедура ПриФормированииСообщения(Сообщение, Предмет, ПараметрыШаблона) Экспорт
	
	ПросклонятьЗначенияРеквизитовВСообщении(Предмет, Сообщение.ЗначенияРеквизитов);
	
КонецПроцедуры

Процедура ПриЗаполненииТелефоновПолучателейВСообщении(ПолучателиSMS, ПредметСообщения) Экспорт
	
КонецПроцедуры

Процедура ПриЗаполненииПочтыПолучателейВСообщении(Получатели, Предмет) Экспорт
	
КонецПроцедуры

// Переопределяет список доступных полей в шаблоне.
//
// Параметры:
//  РеквизитыОбъектаНазначения	 - ДеревоЗначений - список реквизитов шаблона.
//         ** Имя            - Строка - Уникальное имя общего реквизита.
//         ** Представление  - Строка - Представление общего реквизита.
//         ** Тип            - Тип    - Тип реквизита. По умолчанию строка.
//         ** Подсказка      - Строка - Расширенная информация о реквизите.
//         ** Формат         - Строка - Формат вывода значения для чисел, дат, строк и булевых значений.
//
Процедура ИзменитьРеквизитыШаблонаСообщения(Знач РеквизитыОбъектаНазначения)
	
	РеквизитыОбъектаНазначения.Очистить();
	
	// Дата рождения.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ДатаРождения";           // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Дата рождения';
									|en = 'Date of birth'");
	НоваяСтрока.Тип = Тип("Дата");
	НоваяСтрока.Формат = "ДЛФ=D";
	
	// Пол.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.Пол";                    // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Пол';
									|en = 'Gender'");
	НоваяСтрока.Тип = Тип("ПеречислениеСсылка.ПолФизическогоЛица");
	
	// ИНН.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ИНН";                    // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'ИНН';
									|en = 'TIN'");
	НоваяСтрока.Тип = Тип("Строка");
	
	// СНИЛС.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();  
	НоваяСтрока.Имя = "ФизическиеЛица.СтраховойНомерПФР";      // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'СНИЛС';
									|en = 'IIAN'");
	НоваяСтрока.Тип = Тип("Строка");
	
	// Место рождения.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();       
	НоваяСтрока.Имя = "ФизическиеЛица.МестоРождения";          // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Место рождения';
									|en = 'Birthplace'");
	НоваяСтрока.Тип = Тип("Строка");
	
	// ФИО.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ФИО";                    // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'ФИО';
									|en = 'Full name'");
	НоваяСтрока.Тип = Тип("Строка");
	
	// Фамилия.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.Фамилия";                // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Фамилия';
									|en = 'Last name'");
	НоваяСтрока.Тип = Тип("Строка");
	
	// Имя.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.Имя";                    // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Имя';
									|en = 'Name'");
	НоваяСтрока.Тип = Тип("Строка");
	
	// Отчество.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.Отчество";               // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Отчество';
									|en = 'Middle name'");
	НоваяСтрока.Тип = Тип("Строка");
	
	// Инициалы имени.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.Инициалы";              // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Инициалы имени, отчества';
									|en = 'Name, middle name initials'");
	НоваяСтрока.Тип = Тип("Строка");
	
	// Наименование.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.Наименование";           // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Наименование';
									|en = 'Name'");
	НоваяСтрока.Тип = Тип("Строка");
	
	// Внешняя ссылка на объект.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ВнешняяСсылкаНаОбъект";  // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Ссылка на ""Физические лица""';
									|en = 'Reference to ""Individuals""'");
	НоваяСтрока.Тип = Тип("Строка");
	
	// Email.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.Email";                  // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Email';
									|en = 'Email'");
	НоваяСтрока.Тип = Тип("Строка");
	
	// Мобильный телефон.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.Мобильный телефон";      // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Мобильный телефон';
									|en = 'Cell phone'");
	НоваяСтрока.Тип = Тип("Строка");
	
	// Домашний телефон.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.Домашний телефон";       // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Домашний телефон';
									|en = 'Home phone'");
	НоваяСтрока.Тип = Тип("Строка");
	
	// Рабочий телефон.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.Рабочий телефон";        // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Рабочий телефон';
									|en = 'Work phone'");
	НоваяСтрока.Тип = Тип("Строка");
	
	// Адрес по прописке.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();       
	НоваяСтрока.Имя = "ФизическиеЛица.Адрес по прописке";      // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Адрес по прописке';
									|en = 'Registration address '");
	НоваяСтрока.Тип = Тип("Строка");

	// Адрес места проживания.
	НоваяСтрока = РеквизитыОбъектаНазначения.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.Адрес места проживания"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Адрес места проживания';
									|en = 'Place of residence address '");
	НоваяСтрока.Тип = Тип("Строка");
	
	ДобавитьРеквизитыСклоненияФИО(РеквизитыОбъектаНазначения);
	
КонецПроцедуры

Процедура ПросклонятьЗначенияРеквизитовВСообщении(Получатель, ЗначенияРеквизитов)
	
	Если Не ТипЗнч(Получатель) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Возврат;
	КонецЕсли;

	ПросклонятьЧастиИмени(ЗначенияРеквизитов, Получатель, 2, "Родительный"); // АПК:1297 Не локализуется, идентификатор реквизита
	ПросклонятьЧастиИмени(ЗначенияРеквизитов, Получатель, 3, "Дательный"); // АПК:1297 Не локализуется, идентификатор реквизита
	ПросклонятьЧастиИмени(ЗначенияРеквизитов, Получатель, 4, "Винительный"); // АПК:1297 Не локализуется, идентификатор реквизита
	ПросклонятьЧастиИмени(ЗначенияРеквизитов, Получатель, 5, "Творительный"); // АПК:1297 Не локализуется, идентификатор реквизита
	ПросклонятьЧастиИмени(ЗначенияРеквизитов, Получатель, 6, "Предложный"); // АПК:1297 Не локализуется, идентификатор реквизита
	
КонецПроцедуры

Процедура ПросклонятьЧастиИмени(ЗначенияРеквизитов, ФизическоеЛицо, ИдентификаторПадежа, ИмяПадежа)
	
	ГруппаФИОСклонение = ЗначенияРеквизитов["ФИОСклонение"]; // АПК:1297 Не локализуется, идентификатор реквизита
	ГруппаФамилияСклонение = ЗначенияРеквизитов["ФамилияСклонение"]; // АПК:1297 Не локализуется, идентификатор реквизита
	ГруппаИмяСклонение = ЗначенияРеквизитов["ИмяСклонение"]; // АПК:1297 Не локализуется, идентификатор реквизита
	ГруппаОтчествоСклонение = ЗначенияРеквизитов["ОтчествоСклонение"]; // АПК:1297 Не локализуется, идентификатор реквизита
	
	ФИОСклонение = "";
	Если ФизическиеЛицаЗарплатаКадры.Просклонять(ФизическоеЛицо.ФИО, ИдентификаторПадежа, ФИОСклонение, ФизическоеЛицо.Пол) Тогда
		ЧастиИмени = ФизическиеЛицаКлиентСервер.ЧастиИмени(ФИОСклонение);
		ЗаполнитьРезультатСклонения(ГруппаФИОСклонение, СтрШаблон("ФИО%1Падеж", ИмяПадежа), ФИОСклонение); // АПК:1297 Не локализуется, идентификатор реквизита
		ЗаполнитьРезультатСклонения(ГруппаФамилияСклонение, СтрШаблон("Фамилия%1Падеж", ИмяПадежа), ЧастиИмени.Фамилия); // АПК:1297 Не локализуется, идентификатор реквизита
		ЗаполнитьРезультатСклонения(ГруппаИмяСклонение, СтрШаблон("Имя%1Падеж", ИмяПадежа), ЧастиИмени.Имя); // АПК:1297 Не локализуется, идентификатор реквизита
		ЗаполнитьРезультатСклонения(ГруппаОтчествоСклонение, СтрШаблон("Отчество%1Падеж", ИмяПадежа), ЧастиИмени.Отчество); // АПК:1297 Не локализуется, идентификатор реквизита
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьРезультатСклонения(ГруппаРеквизита, ИмяРеквизита, ЗначениеРеквизита)
	
	Если Не ГруппаРеквизита = Неопределено Тогда
		Если Не ГруппаРеквизита[ИмяРеквизита] = Неопределено Тогда
			ГруппаРеквизита[ИмяРеквизита] = ЗначениеРеквизита;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьРеквизитыСклоненияФИО(РеквизитыОбъектаНазначения)
	
	//ФИО.
	ГруппаРеквизитов = РеквизитыОбъектаНазначения.Добавить();
	ГруппаРеквизитов.Имя = НСтр("ru = 'ФизическиеЛица.ФИОСклонение';
								|en = 'ФизическиеЛица.ФИОСклонение'"); // АПК:1297 Не локализуется, идентификатор реквизита
	ГруппаРеквизитов.Представление = НСтр("ru = 'ФИО (склонение)';
											|en = 'Full name (inflection)'");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ФИОСклонение.ФИОРодительныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'ФИО (родительный падеж)';
									|en = 'Full name (genitive case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ФИОСклонение.ФИОДательныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'ФИО (дательный падеж)';
									|en = 'Full name (dative case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ФИОСклонение.ФИОВинительныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'ФИО (винительный падеж)';
									|en = 'Full name (accusative case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ФИОСклонение.ФИОТворительныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'ФИО (творительный падеж)';
									|en = 'Full name (instrumental case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ФИОСклонение.ФИОПредложныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'ФИО (предложный падеж)';
									|en = 'Full name (prepositional case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	// Фамилия.
	ГруппаРеквизитов = РеквизитыОбъектаНазначения.Добавить();
	ГруппаРеквизитов.Имя = НСтр("ru = 'ФизическиеЛица.ФамилияСклонение';
								|en = 'ФизическиеЛица.ФамилияСклонение'"); // АПК:1297 Не локализуется, идентификатор реквизита
	ГруппаРеквизитов.Представление = НСтр("ru = 'Фамилия (склонение)';
											|en = 'Last name (inflection)'");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ФамилияСклонение.ФамилияРодительныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Фамилия (родительный падеж)';
									|en = 'Last name (genitive case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ФамилияСклонение.ФамилияДательныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Фамилия (дательный падеж)';
									|en = 'Last name (dative case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ФамилияСклонение.ФамилияВинительныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Фамилия (винительный падеж)';
									|en = 'Last name (accusative case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ФамилияСклонение.ФамилияТворительныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Фамилия (творительный падеж)';
									|en = 'Last name (instrumental case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ФамилияСклонение.ФамилияПредложныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Фамилия (предложный падеж)';
									|en = 'Last name (accusative case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	// Имя.
	
	ГруппаРеквизитов = РеквизитыОбъектаНазначения.Добавить();
	ГруппаРеквизитов.Имя = НСтр("ru = 'ФизическиеЛица.ИмяСклонение';
								|en = 'ФизическиеЛица.ИмяСклонение'"); // АПК:1297 Не локализуется, идентификатор реквизита
	ГруппаРеквизитов.Представление = НСтр("ru = 'Имя (склонение)';
											|en = 'First name (inflection)'");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ИмяСклонение.ИмяРодительныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Имя (родительный падеж)';
									|en = 'First name (genitive case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ИмяСклонение.ИмяДательныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Имя (дательный падеж)';
									|en = 'First name (dative case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ИмяСклонение.ИмяВинительныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Имя (винительный падеж)';
									|en = 'First name (accusative case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ИмяСклонение.ИмяТворительныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Имя (творительный падеж)';
									|en = 'First name (instrumental case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ИмяСклонение.ИмяПредложныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Имя (предложный падеж)';
									|en = 'First name (prepositional case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	// Отчество.
	
	ГруппаРеквизитов = РеквизитыОбъектаНазначения.Добавить();
	ГруппаРеквизитов.Имя = НСтр("ru = 'ФизическиеЛица.ОтчествоСклонение';
								|en = 'ФизическиеЛица.ОтчествоСклонение'"); // АПК:1297 Не локализуется, идентификатор реквизита
	ГруппаРеквизитов.Представление = НСтр("ru = 'Отчество (склонение)';
											|en = 'Patronymic (inflection)'");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ОтчествоСклонение.ОтчествоРодительныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Отчество (родительный падеж)';
									|en = 'Patronymic (genitive case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ОтчествоСклонение.ОтчествоДательныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Отчество (дательный падеж)';
									|en = 'Patronymic (dative case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ОтчествоСклонение.ОтчествоВинительныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Отчество (винительный падеж)';
									|en = 'Patronymic (accusative case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ОтчествоСклонение.ОтчествоТворительныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Отчество (творительный падеж)';
									|en = 'Patronymic (instrumental case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
	НоваяСтрока = ГруппаРеквизитов.Строки.Добавить();
	НоваяСтрока.Имя = "ФизическиеЛица.ОтчествоСклонение.ОтчествоПредложныйПадеж"; // АПК:1297 Не локализуется, идентификатор реквизита
	НоваяСтрока.Представление = НСтр("ru = 'Отчество (предложный падеж)';
									|en = 'Patronymic (prepositional case)'");
	НоваяСтрока.Тип = Тип("Строка");
	
КонецПроцедуры

#КонецОбласти

Процедура ЗаполнитьИнициалы(ПараметрыОбновления = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
		|	ФизическиеЛица.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|ГДЕ
		|	ФизическиеЛица.Инициалы = """"
		|	И ФизическиеЛица.Имя <> """"";
	
	Если ПараметрыОбновления = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1000","");
	КонецЕсли;
	
	// АПК:1328-выкл Блокировку выполнит ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных
	Выборка = Запрос.Выполнить().Выбрать();
	// АПК:1328-вкл
	
	Если Выборка.Количество() = 0 Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбработчик(ПараметрыОбновления);
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПродолжитьОбработчик(ПараметрыОбновления);
	
	Пока Выборка.Следующий() Цикл
		
		Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
			ПараметрыОбновления, "Справочник.ФизическиеЛица", "Ссылка", Выборка.Ссылка) Тогда
			Продолжить;
		КонецЕсли;
		
		ФизическоеЛицоОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ФизическоеЛицоОбъект.Инициалы = ФизическиеЛицаЗарплатаКадрыКлиентСервер.ИнициалыПоИмениОтчеству(
			ФизическоеЛицоОбъект.Имя, ФизическоеЛицоОбъект.Отчество);
		
		// АПК:1327-выкл Блокировка выполнена ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ФизическоеЛицоОбъект);
		// АПК:1327-вкл
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

