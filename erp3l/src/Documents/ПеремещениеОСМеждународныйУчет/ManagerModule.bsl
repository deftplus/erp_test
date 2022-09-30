#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	МеханизмыДокумента.Добавить("МеждународныйУчет");
	МеханизмыДокумента.Добавить("ОсновныеСредства");
	МеханизмыДокумента.Добавить("ОсновныеСредстваПоМСФО");
	МеханизмыДокумента.Добавить("РеестрДокументов");
	МеханизмыДокумента.Добавить("СебестоимостьИПартионныйУчет");
	МеханизмыДокумента.Добавить("УчетДоходовРасходов");
	МеханизмыДокумента.Добавить("УчетПрочихАктивовПассивов");
	
КонецПроцедуры

#КонецОбласти

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Добавляет команду создания документа "Перемещение ОС (международный учет)".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ПеремещениеОСМеждународныйУчет)
		И ПолучитьФункциональнуюОпцию("ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет") Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ПеремещениеОСМеждународныйУчет.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ПеремещениеОСМеждународныйУчет);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ОтображатьВнеоборотныеАктивыМеждународныйУчет2_2";
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт

	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.ПеремещениеОСМеждународныйУчет";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	
	ВЗапросеЕстьИсточник = Истина;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "";
		ВЗапросеЕстьИсточник = Ложь;
		
	ИначеЕсли ИмяРегистра = "ДокументыПоОС" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаДокументыПоОС(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.';
								|en = 'In document %ПолноеИмяДокумента%, adaptation of request for generating records of register %ИмяРегистра% is not implemented.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов"
		ИЛИ ИмяРегистра = "ДокументыПоОС" Тогда
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ВЗапросеЕстьИсточник,
										ПереопределениеРасчетаПараметров);
	Иначе	
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ПереопределениеРасчетаПараметров);
	КонецЕсли; 

	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  Структура - коллекция элементов:
//     * Таблица<ИмяРегистра> - ТаблицаЗначений - таблица данных для отражения в регистр.
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Запрос			= Новый Запрос;
	ТекстыЗапроса	= Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		////////////////////////////////////////////////////////////////////////////
		// Создадим запрос инициализации движений
		
		ЗаполнитьПараметрыИнициализации(Запрос, Документ);
		
		////////////////////////////////////////////////////////////////////////////
		// Сформируем текст запроса
		
		МеждународныйУчетВнеоборотныеАктивы.ОтражениеДокументовВМеждународномУчете(ТекстыЗапроса, Регистры);
		МеждународныйУчетВнеоборотныеАктивы.ПрочиеРасходы(ТекстыЗапроса, Регистры);
		МеждународныйУчетВнеоборотныеАктивы.ПартииПрочихРасходов(ТекстыЗапроса, Регистры);
		МеждународныйУчетВнеоборотныеАктивы.ПрочиеАктивыПассивы(ТекстыЗапроса, Регистры);
		МеждународныйУчетВнеоборотныеАктивы.Международный(ТекстыЗапроса, Регистры, Международный(ТекстыЗапроса, Регистры));
		ОсновныеСредстваМеждународныйУчет(ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаДокументыПоОС(Запрос, ТекстыЗапроса, Регистры);
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.ПометкаУдаления,
	|	ДанныеДокумента.Проведен,
	|	ДанныеДокумента.Комментарий,
	|	ДанныеДокумента.Ответственный,
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ДанныеДокумента.ПодразделениеПолучатель КАК ПодразделениеПолучатель,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства) КАК ВидСубконтоОбъектаАмортизации,
	|	ДанныеДокумента.ОсновныеСредства.(
	|		ОсновноеСредство
	|	)
	|ИЗ
	|	Документ.ПеремещениеОСМеждународныйУчет КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	ОсновныеСредства = Реквизиты.ОсновныеСредства.Выгрузить().ВыгрузитьКолонку("ОсновноеСредство");
	
	Если НачалоДня(Реквизиты.Период) = НачалоМесяца(Реквизиты.Период) Тогда
		ТаблицаАмортизационныеРасходы = МеждународныйУчетВнеоборотныеАктивы.ТаблицаАмортизационныхРасходов();
	Иначе
		ТаблицаАмортизационныеРасходы = МеждународныйУчетВнеоборотныеАктивы.АмортизационныеРасходыПоОС(
			Реквизиты.Период,
			Реквизиты.Организация,
			ОсновныеСредства);
	КонецЕсли;
	ОшибкиШаблоновПроводок = МеждународныйУчетВнеоборотныеАктивы.ОшибкиЗаполненияШаблоновПроводокАмортизации(
		Реквизиты.Период,
		Реквизиты.Организация,
		ТаблицаАмортизационныеРасходы.ВыгрузитьКолонку("СтатьяРасходов"));
	
	Если ОшибкиШаблоновПроводок <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(ОшибкиШаблоновПроводок);
		ВызватьИсключение НСтр("ru = 'Требуется настроить счета расходов амортизации в шаблоне проводок для операции ""Амортизация внеоборотных активов""';
								|en = 'Set depreciation expense accounts in a posting template for the ""Capital asset depreciation"" transaction'");
	КонецЕсли;
	
	МеждународныйУчетВнеоборотныеАктивы.ИнициализироватьПараметрыЗапросаПриОтраженииАмортизации(Запрос);
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("НачалоМесяца", НачалоМесяца(Реквизиты.Период));
	Запрос.УстановитьПараметр("Граница", Новый Граница(Реквизиты.Период, ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("ТаблицаАмортизации", ТаблицаАмортизационныеРасходы);
	Запрос.УстановитьПараметр("ОсновныеСредства", ОсновныеСредства);
	
	ЗначенияПараметровПроведения = ЗначенияПараметровПроведения(Реквизиты);
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)

	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ПеремещениеОСМеждународныйУчет"));
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПеремещениеОС);

	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли; 
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Процедура ВременнаяТаблицаОбъектыДокумента(ТекстыЗапроса)
	
	ИмяТаблицы = "ТаблицаДокумента";
	
	Если ПроведениеДокументов.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица ВТ ТаблицаДокумента
	|"+
	"ВЫБРАТЬ
	|	ДанныеДокумента.ОсновноеСредство,
	|	Состояния.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	Состояния.Состояние,
	|	Состояния.СчетУчета,
	|	Состояния.ИнвентарныйНомер,
	|	Состояния.ВидАктива,
	|	Состояния.ЛиквидационнаяСтоимость,
	|	Состояния.ЛиквидационнаяСтоимостьПредставления,
	|	Состояния.ПорядокУчета,
	|	Состояния.МетодНачисленияАмортизации,
	|	Состояния.СчетАмортизации,
	|	Состояния.СрокИспользования,
	|	Состояния.ПоказательНаработки,
	|	Состояния.ОбъемНаработки,
	|	Состояния.КоэффициентУскорения,
	|	Состояния.СтатьяРасходов,
	|	Состояния.АналитикаРасходов
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	Документ.ПеремещениеОСМеждународныйУчет.ОсновныеСредства КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСредстваМеждународныйУчет.СрезПоследних(
	|			&Граница,
	|			ОсновноеСредство В (&ОсновныеСредства)
	|				И Регистратор <> &Ссылка) КАК Состояния
	|		ПО ДанныеДокумента.ОсновноеСредство = Состояния.ОсновноеСредство
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы);
	
КонецПроцедуры

Процедура ОсновныеСредстваМеждународныйУчет(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОсновныеСредстваМеждународныйУчет";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаОбъектыДокумента(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица ОсновныеСредстваМеждународныйУчет
	|"+
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	
	|	ТаблицаДокумента.ОсновноеСредство КАК ОсновноеСредство,
	|	ТаблицаДокумента.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	
	|	&Организация КАК Организация,
	|	&ПодразделениеПолучатель КАК Подразделение,
	|	ТаблицаДокумента.Состояние,
	|	ТаблицаДокумента.ИнвентарныйНомер,
	|	ТаблицаДокумента.СчетУчета,
	|	ТаблицаДокумента.ВидАктива,
	|	ТаблицаДокумента.ЛиквидационнаяСтоимость,
	|	ТаблицаДокумента.ЛиквидационнаяСтоимостьПредставления,
	|	ТаблицаДокумента.ПорядокУчета,
	|	ТаблицаДокумента.МетодНачисленияАмортизации,
	|	ТаблицаДокумента.СчетАмортизации,
	|	ТаблицаДокумента.СрокИспользования,
	|	ТаблицаДокумента.ПоказательНаработки,
	|	ТаблицаДокумента.ОбъемНаработки,
	|	ТаблицаДокумента.КоэффициентУскорения,
	|	ТаблицаДокумента.СтатьяРасходов,
	|	ТаблицаДокумента.АналитикаРасходов
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра);
	
КонецПроцедуры

Функция Международный(ТекстыЗапроса, Регистры)
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений("Международный", Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ВременнаяТаблицаОбъектыДокумента(ТекстыЗапроса);
	МеждународныйУчетВнеоборотныеАктивы.ВременнаяТаблицаНачисленнаяАмортизация(ТекстыЗапроса);
	
	Возврат
	"ВЫБРАТЬ // Перенос стоимости объекта со старого подразделения на новое В рамках одного счета учета
	|	&Период КАК Период,
	|	&Ссылка КАК Регистратор,
	|
	|	ЗНАЧЕНИЕ(Справочник.ПланыСчетовМеждународногоУчета.Международный) КАК ПланСчетов,
	|	&Организация КАК Организация,
	|	
	|	&ПодразделениеПолучатель КАК ПодразделениеДт,
	|	СтрокиДокумента.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	СтрокиДокумента.СчетУчета КАК СчетДт,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства) КАК ВидСубконтоДт1,
	|	СтрокиДокумента.ОсновноеСредство КАК СубконтоДт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоДт3,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	&Подразделение КАК ПодразделениеКт,
	|	СтрокиДокумента.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	СтрокиДокумента.СчетУчета КАК СчетКт,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства) КАК ВидСубконтоКт1,
	|	СтрокиДокумента.ОсновноеСредство КАК СубконтоКт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоКт3,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	
	|	ЕСТЬNULL(ДанныеСчетУчета.СуммаОстаток,0) КАК Сумма,
	|	ЕСТЬNULL(ДанныеСчетУчета.СуммаПредставленияОстаток,0) КАК СуммаПредставления,
	|	0 КАК ВалютнаяСумма,
	|	
	|	НЕОПРЕДЕЛЕНО КАК Содержание,
	|	НЕОПРЕДЕЛЕНО КАК ШаблонПроводки,
	|	НЕОПРЕДЕЛЕНО КАК ТипПроводки
	|ИЗ
	|	ТаблицаДокумента КАК СтрокиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Международный.Остатки(
	|				&Граница,
	|				Счет В
	|					(ВЫБРАТЬ
	|						ТаблицаДокумента.СчетУчета
	|					ИЗ
	|						ТаблицаДокумента),
	|				,
	|				(Организация, Подразделение, Субконто1) В
	|						(ВЫБРАТЬ
	|							&Организация, &Подразделение, ТаблицаДокумента.ОсновноеСредство
	|						ИЗ
	|							ТаблицаДокумента)) КАК ДанныеСчетУчета
	|		ПО СтрокиДокумента.ОсновноеСредство = ДанныеСчетУчета.Субконто1
	|			И СтрокиДокумента.СчетУчета = ДанныеСчетУчета.Счет
	|ГДЕ
	|	НЕ ДанныеСчетУчета.Счет ЕСТЬ NULL
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ // Перенос начисленной амортизации со старого подразделения на новое в рамках одного счета амортизации
	|	&Период КАК Период,
	|	&Ссылка КАК Регистратор,
	|	
	|	ЗНАЧЕНИЕ(Справочник.ПланыСчетовМеждународногоУчета.Международный) КАК ПланСчетов,
	|	&Организация КАК Организация,
	|	
	|	&Подразделение КАК ПодразделениеДт,
	|	СтрокиДокумента.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	СтрокиДокумента.СчетАмортизации КАК СчетДт,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства) КАК ВидСубконтоДт1,
	|	СтрокиДокумента.ОсновноеСредство КАК СубконтоДт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоДт3,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	&ПодразделениеПолучатель КАК ПодразделениеКт,
	|	СтрокиДокумента.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	СтрокиДокумента.СчетАмортизации КАК СчетКт,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства) КАК ВидСубконтоКт1,
	|	СтрокиДокумента.ОсновноеСредство КАК СубконтоКт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоКт3,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	
	|	ЕСТЬNULL(-ДанныеСчетАмортизации.СуммаОстаток,0) + ЕСТЬNULL(ТаблицаАмортизации.Сумма, 0) КАК Сумма,
	|	ЕСТЬNULL(-ДанныеСчетАмортизации.СуммаПредставленияОстаток,0) + ЕСТЬNULL(ТаблицаАмортизации.СуммаПредставления, 0) КАК СуммаПредставления,
	|	0 КАК ВалютнаяСумма,
	|	
	|	НЕОПРЕДЕЛЕНО КАК Содержание,
	|	НЕОПРЕДЕЛЕНО КАК ШаблонПроводки,
	|	НЕОПРЕДЕЛЕНО КАК ТипПроводки
	|ИЗ
	|	ТаблицаДокумента КАК СтрокиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Международный.Остатки(
	|				&Граница,
	|				Счет В
	|					(ВЫБРАТЬ
	|						ТаблицаДокумента.СчетАмортизации
	|					ИЗ
	|						ТаблицаДокумента),
	|				,
	|				(Организация, Подразделение, Субконто1) В
	|						(ВЫБРАТЬ
	|							&Организация, &Подразделение, ТаблицаДокумента.ОсновноеСредство
	|						ИЗ
	|							ТаблицаДокумента)) КАК ДанныеСчетАмортизации
	|		ПО СтрокиДокумента.ОсновноеСредство = ДанныеСчетАмортизации.Субконто1
	|			И СтрокиДокумента.СчетАмортизации = ДанныеСчетАмортизации.Счет
	|		ЛЕВОЕ СОЕДИНЕНИЕ втНачисленнаяАмортизация КАК ТаблицаАмортизации
	|		ПО СтрокиДокумента.ОсновноеСредство = ТаблицаАмортизации.ОбъектУчета
	|ГДЕ
	|	НЕ (ДанныеСчетАмортизации.Счет ЕСТЬ NULL И ТаблицаАмортизации.ОбъектУчета ЕСТЬ NULL)";
	
КонецФункции

Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Ссылка                                 КАК Ссылка,
	|	&Период                                 КАК ДатаДокументаИБ,
	|	&Номер                                  КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	&Организация                            КАК Организация,
	|	&Подразделение                          КАК Подразделение,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&Ответственный                          КАК Ответственный,
	|	&Комментарий                            КАК Комментарий,
	|	&Проведен                               КАК Проведен,
	|	&ПометкаУдаления                        КАК ПометкаУдаления,
	|	ЛОЖЬ                                    КАК ДополнительнаяЗапись,
	|	&Период                                 КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать                          КАК НомерПервичногоДокумента,
	|	ЛОЖЬ                                    КАК СторноИсправление,
	|	НЕОПРЕДЕЛЕНО                            КАК СторнируемыйДокумент,
	|	НЕОПРЕДЕЛЕНО                            КАК ИсправляемыйДокумент,
	|	&Период                                 КАК ДатаОтраженияВУчете,
	|	НЕОПРЕДЕЛЕНО                            КАК Приоритет";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДокументыПоОС(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДокументыПоОС";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ТаблицаОС.НомерСтроки-1, 0)    КАК НомерЗаписи,
	|	&Ссылка                                 КАК Ссылка,
	|	&Период                                 КАК Дата,
	|	&Организация                            КАК Организация,
	|	&Подразделение                          КАК Подразделение,
	|	&Проведен                               КАК Проведен,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	ЛОЖЬ                                    КАК ОтражатьВРеглУчете,
	|	ЛОЖЬ                                    КАК ОтражатьВУпрУчете,
	|	ТаблицаОС.ОсновноеСредство              КАК ОсновноеСредство
	|ИЗ
	|	Документ.ПеремещениеОСМеждународныйУчет КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПеремещениеОСМеждународныйУчет.ОсновныеСредства КАК ТаблицаОС
	|		ПО ДанныеДокумента.Ссылка = ТаблицаОС.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область БлокировкаПриОбновленииИБ

Процедура ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ПредставлениеОперации) Экспорт
	
	ВходящиеДанные = Новый Соответствие;
	
	ВходящиеДанные.Вставить(Метаданные.Документы.ПринятиеКУчетуНМАМеждународныйУчет);
	ВходящиеДанные.Вставить(Метаданные.РегистрыБухгалтерии.Международный);
	ВходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ВыработкаНМА);
	ВходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ПрочиеРасходы);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.НаработкиОбъектовЭксплуатации);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.НематериальныеАктивыМеждународныйУчет);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.ОсновныеСредстваМеждународныйУчет);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.ПравилаОтраженияВМеждународномУчете);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.ПравилаУточненияСчетовВМеждународномУчете);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.ПланыСчетовМеждународногоУчетаОрганизаций);
	
	ЗакрытиеМесяцаСервер.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ВходящиеДанные, ПредставлениеОперации);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
