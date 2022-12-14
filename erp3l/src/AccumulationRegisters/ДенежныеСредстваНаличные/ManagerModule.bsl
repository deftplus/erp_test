#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Собирает структуру из текстов запросов для дальнейшей проверки даты запрета.
// 
// Параметры:
// 	Запрос - Запрос - Запрос по проверке даты запрета, можно установить параметры
// Возвращаемое значение:
// 	Структура - см. ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов
Функция ТекстЗапросаКонтрольДатыЗапрета(Запрос) Экспорт
	ИмяРегистра = Метаданные.РегистрыНакопления.ДенежныеСредстваНаличные.Имя;
	ИмяТаблицыИзменений = "ТаблицаИзмененийДенежныеСредстваНаличные"; 
	СтруктураТекстовЗапросов = ПроведениеДокументов.ШаблонТекстЗапросаКонтрольДатыЗапрета(Запрос, 
		ИмяРегистра, 
		ИмяТаблицыИзменений, 
		"ФинансовыйКонтур");
	Возврат СтруктураТекстовЗапросов

КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Касса)
	|	И ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

//++ НЕ УТКА

// Заполняет параметры отражения движений регистра в финансовом учете
//
// Возвращаемое значение:
// 	см. МеждународныйУчетПоДаннымОстаточныхФинансовыхРегистров.ПараметрыОтраженияДвиженийВФинансовомУчете
//
Функция ПараметрыОтраженияДвиженийВФинансовомУчете() Экспорт
	
	ПараметрыОтражения = МеждународныйУчетПоДаннымОстаточныхФинансовыхРегистров.ПараметрыОтраженияДвиженийВФинансовомУчете();
	ПараметрыОтражения.ПутьКДаннымОбъектНастройки = "Касса.ГруппаФинансовогоУчета";
	ПараметрыОтражения.ПутьКДаннымНаправлениеДеятельности = "Касса.НаправлениеДеятельности";
	ПараметрыОтражения.ПутьКДаннымПодразделение = "Касса.Подразделение";
	ПараметрыОтражения.ПутьКДаннымМестоУчета = "Касса";
	ПараметрыОтражения.ПутьКДаннымВалюта = "Касса.ВалютаДенежныхСредств";
	ПараметрыОтражения.РесурсыУпр.Добавить("СуммаУпр");
	ПараметрыОтражения.РесурсыРегл.Добавить("СуммаРегл");
	ПараметрыОтражения.РесурсыВал.Добавить("Сумма");
	
	МетаданныеРегистра = СоздатьНаборЗаписей().Метаданные();
	МеждународныйУчетПоДаннымОстаточныхФинансовыхРегистров.ЗаполнитьПараметрыОтраженияПоМетаданнымРегистра(ПараметрыОтражения, МетаданныеРегистра);
	
	Возврат ПараметрыОтражения;
	
КонецФункции

//-- НЕ УТКА

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.ДенежныеСредстваНаличные.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.5.32";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("09f685ad-fe4d-4da1-89ef-381073257d63");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.ДенежныеСредстваНаличные.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет реквизит ""Объект расчетов"".';
									|en = 'Fills in ""AR/AP object"" attribute.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыНакопления.ДенежныеСредстваНаличные.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Справочники.ОбъектыРасчетов.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.ДенежныеСредстваНаличные.ПолноеИмя());
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
	|	РегистрНакопления.ДенежныеСредстваНаличные КАК ДанныеРегистра
	|ГДЕ
	|	ДанныеРегистра.ОбъектРасчетов = ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка)
	|		И НЕ ДанныеРегистра.УдалитьЗаказ В (&ПустыеЗначенияОбъектовРасчета)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ПустыеЗначенияОбъектовРасчета", ОбъектыРасчетовСервер.ПустыеЗначенияОбъектРасчетов());
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
	|		ИНАЧЕ ЕСТЬNULL(ОбъектыРасчетовКлиент.Ссылка, ЕСТЬNULL(ОбъектыРасчетовПоставщик.Ссылка,
	|			&ОбъектРасчетовПустаяСсылка))
	|	КОНЕЦ КАК ОбъектРасчетов,
	|	&ДополнительныеПоля КАК ДополнительныеПоля,
	|	ДанныеРегистра.НомерСтроки КАК НомерСтроки,
	|	ДанныеРегистра.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваНаличные КАК ДанныеРегистра
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыРасчетов КАК ОбъектыРасчетовКлиент
	|			ПО ДанныеРегистра.УдалитьЗаказ = ОбъектыРасчетовКлиент.Объект
	|			И ОбъектыРасчетовКлиент.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетовСПартнерами.РасчетыСКлиентом)
	|			И ОбъектыРасчетовКлиент.Организация.ГоловнаяОрганизация = ДанныеРегистра.АналитикаУчетаПоПартнерам.Организация.ГоловнаяОрганизация
	|			И ОбъектыРасчетовКлиент.Партнер = ДанныеРегистра.АналитикаУчетаПоПартнерам.Партнер
	|			И ОбъектыРасчетовКлиент.Контрагент = ДанныеРегистра.АналитикаУчетаПоПартнерам.Контрагент
	|			И НЕ ДанныеРегистра.УдалитьЗаказ В (&ПустыеЗначенияОбъектовРасчетов)
	|			И ДанныеРегистра.УдалитьЗаказ ССЫЛКА Документ.ЗаказКлиента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыРасчетов КАК ОбъектыРасчетовПоставщик
	|			ПО ДанныеРегистра.УдалитьЗаказ = ОбъектыРасчетовПоставщик.Объект
	|			И ОбъектыРасчетовПоставщик.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетовСПартнерами.РасчетыСПоставщиком)
	|			И ОбъектыРасчетовПоставщик.Организация.ГоловнаяОрганизация = ДанныеРегистра.АналитикаУчетаПоПартнерам.Организация.ГоловнаяОрганизация
	|			И ОбъектыРасчетовКлиент.Партнер = ДанныеРегистра.АналитикаУчетаПоПартнерам.Партнер
	|			И ОбъектыРасчетовКлиент.Контрагент = ДанныеРегистра.АналитикаУчетаПоПартнерам.Контрагент
	|			И НЕ ДанныеРегистра.УдалитьЗаказ В (&ПустыеЗначенияОбъектовРасчетов)
	|			И ДанныеРегистра.УдалитьЗаказ ССЫЛКА Документ.ЗаказПоставщику
	|ГДЕ
	|	ДанныеРегистра.Регистратор В (&Регистраторы)
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор";
	
	Запрос.УстановитьПараметр("ПустыеЗначенияОбъектовРасчетов", ОбъектыРасчетовСервер.ПустыеЗначенияОбъектРасчетов());
	Запрос.УстановитьПараметр("ОбъектРасчетовПустаяСсылка", Справочники.ОбъектыРасчетов.ПустаяСсылка());
	ОбъектыРасчетовСервер.ДополнитьЗапросПрочимиПолями(Запрос, МетаданныеРегистра);
	
	ПорцииДляОбработки = ОбъектыРасчетовСервер.ПорцииДанныхДляОбработки(ОбновляемыеДанные);
	
	ВсеОбъектыРасчетовСгенерированы = ОбъектыРасчетовСервер.ВсеОбъектыРасчетовСгенерированы(Параметры.Очередь);
	
	Для Каждого ПорцияДанных Из ПорцииДляОбработки Цикл
	
		НачатьТранзакцию();
		
		Попытка
		
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.ИсточникДанных = ПорцияДанных;
			ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Регистратор", "Регистратор");
			Блокировка.Заблокировать();
			
			Запрос.УстановитьПараметр("Регистраторы", ПорцияДанных.ВыгрузитьКолонку("Регистратор"));
			РезультатЗапроса = Запрос.Выполнить();
			
			ВыборкаРегистратор = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Если Не ВсеОбъектыРасчетовСгенерированы Тогда
				ВсеОбъектыРасчетовСгенерированы = ОбъектыРасчетовСервер.ВсеОбъектыРасчетовСгенерированы(Параметры.Очередь);
			КонецЕсли;
			
			Пока ВыборкаРегистратор.Следующий() Цикл
				ВыборкаДетальныеЗаписи = ВыборкаРегистратор.Выбрать();
				НаборЗаписей = СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаРегистратор.Регистратор);
				ЕстьОшибкаЗапонения = Ложь;
				
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					НоваяСтрокаНабора = НаборЗаписей.Добавить();
					Если ВыборкаДетальныеЗаписи.ОбъектРасчетов = Справочники.ОбъектыРасчетов.ПустаяСсылка()
						И ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.УдалитьЗаказ) Тогда
						Если Не ВсеОбъектыРасчетовСгенерированы Тогда
							ЕстьОшибкаЗапонения = Истина;
							Прервать;
						Иначе
							ВызватьИсключение (СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'Не удалось заполнить объект расчетов в регистре накопления: %1 по источнику данных %2';
									|en = 'Cannot fill in the AR/AP object in the accumulation register: %1 by data source %2'"),
								ПолноеИмяРегистра,
								ВыборкаДетальныеЗаписи.УдалитьЗаказ));
						КонецЕсли;
					КонецЕсли;
					
					ЗаполнитьЗначенияСвойств(НоваяСтрокаНабора, ВыборкаДетальныеЗаписи);
				КонецЦикла;
				
				Если ЕстьОшибкаЗапонения Тогда
					Продолжить;
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
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеРегистра,
				,
				ТекстСообщения);
		
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
