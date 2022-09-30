
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Т
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК Т1 
	|	ПО Т.АналитикаУчетаПоПартнерам = Т1.КлючАналитики
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Т1.Организация)
	|	И ЗначениеРазрешено(Т1.Партнер)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.РасчетыСПоставщикамиПланПоставок.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.7.246";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("dfadf3ec-5adb-4a01-b3f3-53fd0ac52206");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.РасчетыСПоставщикамиПланПоставок.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет измерения ""Объект расчетов"".';
									|en = 'Fills in ""AR/AP object"" dimensions.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланПоставок.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Справочники.ОбъектыРасчетов.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланПоставок.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.АктВыполненныхРабот.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ВозвратТоваровМеждуОрганизациями.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ВозвратТоваровОтКлиента.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ВозвратТоваровПоставщику.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ВыкупВозвратнойТарыКлиентом.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ВыкупВозвратнойТарыУПоставщика.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ВыкупПринятыхНаХранениеТоваров.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ВыкупТоваровХранителем.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаказКлиента.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаказПоставщику.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаявкаНаВозвратТоваровОтКлиента.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ОперацияПоПлатежнойКарте.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ОтчетКомиссионера.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ОтчетКомиссионераОСписании.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ОтчетКомитенту.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ОтчетКомитентуОСписании.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ОтчетПоКомиссииМеждуОрганизациями.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ОтчетПоКомиссииМеждуОрганизациямиОСписании.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ПередачаТоваровМеждуОрганизациями.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ПоступлениеБезналичныхДенежныхСредств.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ПриобретениеТоваровУслуг.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ПриобретениеУслугПрочихАктивов.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ПриходныйКассовыйОрдер.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.РасходныйКассовыйОрдер.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.РеализацияТоваровУслуг.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.РеализацияУслугПрочихАктивов.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.СписаниеБезналичныхДенежныхСредств.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.СписаниеПринятыхНаХранениеТоваров.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ТаможеннаяДекларацияИмпорт.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "ОбъектыРасчетовСервер.ПереформироватьНекорректныеОнлайнДвижения";
	НоваяСтрока.Порядок = "До";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Справочники.ДоговорыКонтрагентов.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Справочники.ДоговорыМеждуОрганизациями.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Справочники.Контрагенты.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";
	//++ НЕ УТ
	//++ Локализация
	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ВыбытиеДенежныхДокументов.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ОтчетОператораСистемыПлатон.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ПоступлениеДенежныхДокументов.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";
	//-- Локализация
	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаказПереработчику.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ОтчетПереработчика.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";
	//-- НЕ УТ
	//++ НЕ УТКА
	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаказДавальца.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ОтчетДавальцу.СгенерироватьОбъектыРасчетов";
	НоваяСтрока.Порядок = "После";
	//-- НЕ УТКА

КонецПроцедуры

// Обработчик обновления
// 
// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры = Неопределено) Экспорт
	
	ПолноеИмяРегистра = СоздатьНаборЗаписей().Метаданные().ПолноеИмя();
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Период УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Период УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Регистратор
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщикамиПланПоставок КАК ДанныеРегистра
	|ГДЕ
	|	ДанныеРегистра.ОбъектРасчетов = ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(
		Параметры, 
		Регистраторы,
		ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеРегистра = СоздатьНаборЗаписей().Метаданные();
	ПолноеИмяРегистра = МетаданныеРегистра.ПолноеИмя();
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра);
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ

		|	ВЫБОР
		|		КОГДА ДанныеРегистра.ОбъектРасчетов <> &ОбъектРасчетовПустаяСсылка
		|			ТОГДА ДанныеРегистра.ОбъектРасчетов
		|		ИНАЧЕ ЕСТЬNULL(ОбъектыРасчетов.Ссылка, &ОбъектРасчетовПустаяСсылка)
		|	КОНЕЦ КАК ОбъектРасчетов,
		|	&ДополнительныеПоля КАК ДополнительныеПоля,

		|	ДанныеРегистра.Регистратор КАК Регистратор,
		|	ДанныеРегистра.НомерСтроки,
		|	ДанныеРегистра.УдалитьОбъектРасчетов КАК ИсточникОбъектаРасчетов
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщикамиПланПоставок КАК ДанныеРегистра
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаПоПартнерам КАК Аналитика
		|			ПО ДанныеРегистра.АналитикаУчетаПоПартнерам = Аналитика.Ссылка
		|			
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК Договора
		|			ПО Договора.Ссылка = Аналитика.Договор
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыРасчетов КАК ОбъектыРасчетов
		|			ПО ДанныеРегистра.УдалитьОбъектРасчетов 				= ОбъектыРасчетов.Объект
		|			И ОбъектыРасчетов.ТипРасчетов 							= ЗНАЧЕНИЕ(Перечисление.ТипыРасчетовСПартнерами.РасчетыСПоставщиком)
		|			И ОбъектыРасчетов.Контрагент 							= Аналитика.Контрагент
		|			И ОбъектыРасчетов.Организация							= Аналитика.Организация
		|			И ОбъектыРасчетов.ВалютаВзаиморасчетов 					= ДанныеРегистра.Валюта
		|
		|			И (ВЫБОР
		|				КОГДА ТИПЗНАЧЕНИЯ(ДанныеРегистра.УдалитьОбъектРасчетов) = ТИП(Справочник.ДоговорыКонтрагентов)
		|						И Договора.РазрешенаРаботаСДочернимиПартнерами
		|					ТОГДА Договора.Партнер
		|				ИНАЧЕ Аналитика.Партнер
		|			КОНЕЦ = ОбъектыРасчетов.Партнер) 
		|
		|ГДЕ
		|	ДанныеРегистра.Регистратор В (&Регистраторы)
		|	И НЕ ДанныеРегистра.УдалитьОбъектРасчетов В (&ПустыеЗначенияОбъектовРасчетов)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ДанныеРегистра.ОбъектРасчетов <> &ОбъектРасчетовПустаяСсылка
		|			ТОГДА ДанныеРегистра.ОбъектРасчетов
		|		ИНАЧЕ ЕСТЬNULL(ОбъектыРасчетов.Ссылка, &ОбъектРасчетовПустаяСсылка)
		|	КОНЕЦ КАК ОбъектРасчетов,
		|	&ДополнительныеПоля КАК ДополнительныеПоля,

		|	ДанныеРегистра.Регистратор,
		|	ДанныеРегистра.НомерСтроки,
		|	ДанныеРегистра.АналитикаУчетаПоПартнерам
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщикамиПланПоставок КАК ДанныеРегистра
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаПоПартнерам КАК Аналитика
		|			ПО ДанныеРегистра.АналитикаУчетаПоПартнерам = Аналитика.Ссылка
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыРасчетов КАК ОбъектыРасчетов
		|			ПО ОбъектыРасчетов.ТипРасчетов 				= ЗНАЧЕНИЕ(Перечисление.ТипыРасчетовСПартнерами.РасчетыСПоставщиком)
		|			И ОбъектыРасчетов.Организация 				= Аналитика.Организация
		|			И ОбъектыРасчетов.Контрагент 				= Аналитика.Контрагент
		|			И ОбъектыРасчетов.Договор 					= Аналитика.Договор
		|			И ОбъектыРасчетов.НаправлениеДеятельности 	= Аналитика.НаправлениеДеятельности
		|			И ОбъектыРасчетов.Партнер 					= Аналитика.Партнер
		|			И ОбъектыРасчетов.ВалютаВзаиморасчетов 		= ДанныеРегистра.Валюта
		|			И ОбъектыРасчетов.Объект 					= НЕОПРЕДЕЛЕНО
		|ГДЕ
		|	ДанныеРегистра.Регистратор В (&Регистраторы)
		|	И ДанныеРегистра.УдалитьОбъектРасчетов В (&ПустыеЗначенияОбъектовРасчетов)


		|ИТОГИ ПО
		|	Регистратор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК КоличествоСтрок,
		|	ДанныеРегистра.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщикамиПланПоставок КАК ДанныеРегистра
		|ГДЕ
		|	ДанныеРегистра.Регистратор В (&Регистраторы)
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеРегистра.Регистратор";
		
	Запрос.УстановитьПараметр("ПустыеЗначенияОбъектовРасчетов", ОбъектыРасчетовСервер.ПустыеЗначенияОбъектРасчетов());

	Запрос.УстановитьПараметр("ОбъектРасчетовПустаяСсылка", Справочники.ОбъектыРасчетов.ПустаяСсылка());
	ОбъектыРасчетовСервер.ДополнитьЗапросПрочимиПолями(Запрос, МетаданныеРегистра);
	
	ВсеОбъектыРасчетовСгенерированы = ОбъектыРасчетовСервер.ВсеОбъектыРасчетовСгенерированы(Параметры.Очередь);
	
	Для Каждого ПорцияДанных Из ОбновляемыеДанные Цикл
	
		НачатьТранзакцию();
		
		Попытка
			ОбрабатываемыйДокумент = ПорцияДанных.Регистратор;
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Регистратор", ОбрабатываемыйДокумент);
			Блокировка.Заблокировать();
			
			Запрос.УстановитьПараметр("Регистраторы", ОбрабатываемыйДокумент);
			РезультатЗапроса = Запрос.ВыполнитьПакет();
			
			ВыборкаРегистратор = РезультатЗапроса[0].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			КоличествоСтрок = РезультатЗапроса[1].Выгрузить();
			
			Пока ВыборкаРегистратор.Следующий() Цикл
				ВыборкаДетальныеЗаписи = ВыборкаРегистратор.Выбрать();
				НаборЗаписей = СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаРегистратор.Регистратор);
				ЕстьОшибкаЗапонения = Ложь;
				
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					НоваяСтрокаНабора = НаборЗаписей.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрокаНабора, ВыборкаДетальныеЗаписи);
					Если ВыборкаДетальныеЗаписи.ОбъектРасчетов = Справочники.ОбъектыРасчетов.ПустаяСсылка() Тогда
						Если ОбъектыРасчетовСервер.ЕстьБитыеСсылкиВИсточникеОбъектаРасчетов(ВыборкаДетальныеЗаписи.ИсточникОбъектаРасчетов)
							ИЛИ ОбъектыРасчетовСервер.ЕстьБитыеСсылкиВИсточникеОбъектаРасчетов(ВыборкаДетальныеЗаписи.АналитикаУчетаПоПартнерам) Тогда
							ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Не удалось заполнить объект расчетов наборе записей регистра накопления %1, строка № %2
								|в источнике данных объекта расчетов обнаружена ссылка на несуществующий элемент.';
								|en = 'Cannot fill in an AR/AP object in the set of %1 accumulation register records, line %2
								|a link to a nonexistent item was found in the AR/AP object data source.'"),
								ПолноеИмяРегистра,
								ВыборкаРегистратор.Регистратор);
							ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
								УровеньЖурналаРегистрации.Ошибка,
								МетаданныеРегистра,
								,
								ТекстСообщения);
						Иначе
							Если ОбновлениеИнформационнойБазы.ОбъектОбработан(ВыборкаДетальныеЗаписи.ИсточникОбъектаРасчетов).Обработан Тогда
								Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ИсточникОбъектаРасчетов) Тогда
									ОбъектРасчетов = Неопределено;
									Если Не ТипЗнч(ВыборкаДетальныеЗаписи.ИсточникОбъектаРасчетов) = Тип("СправочникСсылка.КлючиАналитикиУчетаПоПартнерам") Тогда
										ОбъектыРасчетовСервер.ДогенерироватьОбъектыРасчетов(ВыборкаДетальныеЗаписи.ИсточникОбъектаРасчетов);
										
										ДопПараметрыПоиска 						= ОбъектыРасчетовСервер.ДополнительныеКритерииПоиска();
										Аналитика 								= ВыборкаДетальныеЗаписи.АналитикаУчетаПоПартнерам;
										ДопПараметрыПоиска.Контрагент 			= Аналитика.Контрагент;
										ДопПараметрыПоиска.Партнер				= Аналитика.Партнер;
										ДопПараметрыПоиска.ВалютаВзаиморасчетов = ВыборкаДетальныеЗаписи.Валюта;
										ДопПараметрыПоиска.ОбновлениеИБ			= Истина;
										
										ОбъектРасчетов = ОбъектыРасчетовСервер.ПолучитьОбъектРасчетовПоСсылке(
											ВыборкаДетальныеЗаписи.ИсточникОбъектаРасчетов,
											Аналитика.Организация,
											Перечисления.ТипыРасчетовСПартнерами.РасчетыСПоставщиком,
											ДопПараметрыПоиска);
									ИначеЕсли Не ВсеОбъектыРасчетовСгенерированы Тогда 
										ЕстьОшибкаЗапонения = Истина;
										Прервать;
									КонецЕсли;
									
									Если ЗначениеЗаполнено(ОбъектРасчетов) Тогда
										НоваяСтрокаНабора.ОбъектРасчетов = ОбъектРасчетов;
									Иначе
										ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										НСтр("ru = 'Не удалось заполнить объект расчетов наборе записей регистра накопления %1, 
											|по источнику %2.';
											|en = 'Failed to fill in the AR/AP object in the %1 accumulation register record set, 
											|by the %2 source.'"),
											ПолноеИмяРегистра,
											ВыборкаДетальныеЗаписи.ИсточникОбъектаРасчетов);
										ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
											УровеньЖурналаРегистрации.Ошибка,
											МетаданныеРегистра,
											,
											ТекстСообщения);
									КонецЕсли;
								КонецЕсли;
							Иначе
								ЕстьОшибкаЗапонения = Истина;
								Прервать;
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
				
				Если ЕстьОшибкаЗапонения Тогда
					Продолжить;
				КонецЕсли;
				
				ИсходноеКоличествоСтрок = КоличествоСтрок.Найти(ВыборкаРегистратор.Регистратор, "Регистратор").КоличествоСтрок;
				
				Если ИсходноеКоличествоСтрок <> НаборЗаписей.Количество() Тогда
				
					ВызватьИсключение (СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'При обработке набора записей регистра накопления %1 обнаружились дубли строк по регистратору: %2';
							|en = 'When processing the %1 accumulation register record set, duplicate rows were found by recorder: %2'"),
						МетаданныеРегистра.Имя,
						ВыборкаРегистратор.Регистратор));
				
				КонецЕсли;
				
				Если НаборЗаписей.Модифицированность() Тогда
					ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
				Иначе
					ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
				КонецЕсли;
			
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
		
			ОтменитьТранзакцию();
			
			Шаблон = НСтр("ru = 'Не удалось записать данные в регистр %1 , по причине: %2';
							|en = 'Cannot save data to the register %1. Reason: %2'");
			ТекстСообщения = СтрШаблон(Шаблон,
				ПолноеИмяРегистра,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				МетаданныеРегистра,
				,
				ТекстСообщения);
		
		КонецПопытки;
	
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	Если Параметры.ОбработкаЗавершена Тогда
		ОперативныеВзаиморасчетыСервер.ПослеОбновленияРегистровВзаиморасчетов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
