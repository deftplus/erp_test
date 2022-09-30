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
	
	МеханизмыДокумента.Добавить("РеестрДокументов");
	МеханизмыДокумента.Добавить("ТМЦВЭксплуатации");
	
КонецПроцедуры

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
		
		ЗаполнитьПараметрыИнициализации(Запрос, Документ);
		
		НаработкиТМЦВЭксплуатации(ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры);
		
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

#КонецОбласти

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Добавляет команду создания документа "Регистрация наработок ТМЦ в эксплуатации".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.НаработкаТМЦВЭксплуатации) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.НаработкаТМЦВЭксплуатации.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.НаработкаТМЦВЭксплуатации);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
	

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

#Область Прочее

// Заполняет условное оформление списка
//
// Параметры:
// 		Список - ДинамическийСписок - Реквизит динамического списка формы.
//
Процедура УстановитьУсловноеОформлениеСписка(Список) Экспорт
	
	Элемент = Список.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Тип");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тип");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Тип("ДокументСсылка.НаработкаТМЦВЭксплуатации");
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Регистрация наработок';
																|en = 'Running time value registration'"));
	
КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Подразделение)";

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
	
	ПолноеИмяДокумента = "Документ.НаработкаТМЦВЭксплуатации";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	
	ВЗапросеЕстьИсточник = Истина;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.';
								|en = 'In document %ПолноеИмяДокумента%, adaptation of request for generating records of register %ИмяРегистра% is not implemented.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
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

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеШапки.Дата КАК Период,
	|	ДанныеШапки.Номер КАК Номер,
	|	ДанныеШапки.Организация КАК Организация,
	|	ДанныеШапки.Подразделение КАК Подразделение
	|ИЗ
	|	Документ.НаработкаТМЦВЭксплуатации КАК ДанныеШапки
	|ГДЕ
	|	ДанныеШапки.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период", Реквизиты.Период);
	Запрос.УстановитьПараметр("Организация", Реквизиты.Организация);
	Запрос.УстановитьПараметр("Подразделение", Реквизиты.Подразделение);
	
	ЗначенияПараметровПроведения = ЗначенияПараметровПроведения(Реквизиты);
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла; 
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)

	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.НаработкаТМЦВЭксплуатации"));
	ЗначенияПараметровПроведения.Вставить("НазваниеДокумента", НСтр("ru = 'Регистрация наработок ТМЦ в эксплуатации';
																	|en = 'Registration of inventory running time in operation'"));
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.НаработкаТМЦВЭксплуатации);
	
	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли; 
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Процедура НаработкиТМЦВЭксплуатации(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "НаработкиТМЦВЭксплуатации";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = 
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	
	|	ТабличнаяЧасть.ИнвентарныйНомер КАК ИнвентарныйНомер,
	|	ТабличнаяЧасть.ТекущееЗначение КАК Значение,
	|	ТабличнаяЧасть.ПредельныйОбъем КАК ПредельныйОбъем
	|ИЗ
	|	Документ.НаработкаТМЦВЭксплуатации.Наработки КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Дата КАК ДатаДокументаИБ,
	|	ДанныеДокумента.Номер КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных КАК ТипСсылки,
	|	ДанныеДокумента.Организация КАК Организация,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО КАК НаправлениеДеятельности,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ДанныеДокумента.Ответственный КАК Ответственный,
	|	ДанныеДокумента.Комментарий КАК Комментарий,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
	|	ЛОЖЬ КАК ДополнительнаяЗапись,
	|	ДанныеДокумента.Дата КАК ДатаПервичногоДокумента,
	|	ЛОЖЬ КАК СторноИсправление,
	|	НЕОПРЕДЕЛЕНО КАК СторнируемыйДокумент,
	|	НЕОПРЕДЕЛЕНО КАК ИсправляемыйДокумент,
	|	&НомерНаПечать КАК НомерПервичногоДокумента,
	|	НЕОПРЕДЕЛЕНО КАК Приоритет
	|ИЗ
	|	Документ.НаработкаТМЦВЭксплуатации КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Документы.НаработкаТМЦВЭксплуатации.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.7.273";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("78408ff9-96dd-4c5f-a5b5-6b11873e3062");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Документы.НаработкаТМЦВЭксплуатации.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновляет документы ""Наработка ТМЦ в эксплуатации"":
	|- заполняет новый реквизит ""Инв. №"" в табличной части';
	|en = 'Updates the ""Asset activity of inventory in operation"" documents:
	|- fills in the new ""Inv. No."" attribute in the table'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.НаработкаТМЦВЭксплуатации.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Справочники.ПартииТМЦВЭксплуатации.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Документы.НаработкаТМЦВЭксплуатации.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Документы.НаработкаТМЦВЭксплуатации.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Справочники.ПартииТМЦВЭксплуатации.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

КонецПроцедуры

// Регистрирует данные к обработке при переходе на новую версию.
// 
// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = "Документ.НаработкаТМЦВЭксплуатации";
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Ссылка.Дата УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Ссылка");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТабличнаяЧасть.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.НаработкаТМЦВЭксплуатации.Наработки КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.ИнвентарныйНомер = """"
	|	И ТабличнаяЧасть.УдалитьПартияТМЦВЭксплуатации.УдалитьИнвентарныйНомер <> """"";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Документ.НаработкаТМЦВЭксплуатации";
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;

	ЧитаемыеДанные = Новый Массив;
	ЧитаемыеДанные.Добавить("Справочник.ПартииТМЦВЭксплуатации");
	ДополнительныеПараметрыПроцедуры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
	ДополнительныеПараметрыПроцедуры.ИмяВременнойТаблицы = "ВТЗаблокированныеДанные";
	ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуЗаблокированныхДляЧтенияИИзмененияСсылок(
			Параметры.Очередь, 
			ЧитаемыеДанные, 
			МенеджерВременныхТаблиц, 
			ДополнительныеПараметрыПроцедуры);

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаДанных.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТДляОбработки
	|ИЗ
	|	&ТаблицаОбновляемыхДанных КАК ТаблицаДанных
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТДляОбработки.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТЗаблокированныеСсылки
	|ИЗ
	|	ВТДляОбработки КАК ВТДляОбработки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.НаработкаТМЦВЭксплуатации.Наработки КАК ТабличнаяЧасть
	|		ПО (ТабличнаяЧасть.Ссылка = ВТДляОбработки.Ссылка)
	|ГДЕ
	|	ТабличнаяЧасть.УдалитьПартияТМЦВЭксплуатации В
	|			(ВЫБРАТЬ
	|				ВТЗаблокированныеДанные.Ссылка
	|			ИЗ
	|				ВТЗаблокированныеДанные КАК ВТЗаблокированныеДанные)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТДляОбработки.Ссылка КАК Ссылка
	|ИЗ
	|	ВТДляОбработки КАК ВТДляОбработки
	|ГДЕ
	|	НЕ ВТДляОбработки.Ссылка В
	|				(ВЫБРАТЬ
	|					ВТЗаблокированныеСсылки.Ссылка
	|				ИЗ
	|					ВТЗаблокированныеСсылки КАК ВТЗаблокированныеСсылки)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаОбновляемыхДанных", ОбновляемыеДанные);
	Результат = Запрос.Выполнить();
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	
	Выборка = Результат.Выбрать();
 	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект(); // ДокументОбъект.НаработкаТМЦВЭксплуатации
			Если ДокументОбъект = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
				ЗафиксироватьТранзакцию();
 				Продолжить;
			КонецЕсли;
			
			СписокПартий = Новый Массив;
			Для Каждого ДанныеСтроки Из ДокументОбъект.Наработки Цикл
				Если ЗначениеЗаполнено(ДанныеСтроки.УдалитьПартияТМЦВЭксплуатации) Тогда
					СписокПартий.Добавить(ДанныеСтроки.УдалитьПартияТМЦВЭксплуатации);
				КонецЕсли;
			КонецЦикла;
			
			Если СписокПартий.Количество() <> 0 Тогда
				
				РеквизитыПартий = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(
					СписокПартий, "УдалитьИнвентарныйНомер");
				
				Для Каждого ДанныеСтроки Из ДокументОбъект.Наработки Цикл
					
					Если ЗначениеЗаполнено(ДанныеСтроки.УдалитьПартияТМЦВЭксплуатации)
						И НЕ ЗначениеЗаполнено(ДанныеСтроки.ИнвентарныйНомер) Тогда
					
						СвойстваПартии = РеквизитыПартий.Получить(ДанныеСтроки.УдалитьПартияТМЦВЭксплуатации);
						Если ДанныеСтроки.ИнвентарныйНомер <> СвойстваПартии.УдалитьИнвентарныйНомер Тогда
							ДанныеСтроки.ИнвентарныйНомер = СвойстваПартии.УдалитьИнвентарныйНомер;
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
			Если ДокументОбъект.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ДокументОбъект.Ссылка);
			КонецЕсли;
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;

			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Выборка.Ссылка);
			
		КонецПопытки;
		
	КонецЦикла;
	
 	ВнеоборотныеАктивыСлужебный.ПроверитьВыполнениеОбработчика(
 		ПроблемныхОбъектов, 
 		ОбъектовОбработано, 
 		ПолноеИмяОбъекта);
 		
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры
 
#КонецОбласти

#КонецОбласти

#КонецЕсли
