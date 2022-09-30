////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеПереопределяемый: общий механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет соответствие функциональных опций библиотеки и прикладного решения,
// в случае различий в наименовании.
//
// Параметры:
//  СоответствиеФО - Соответствие - список функциональных опций.
//
Процедура ПолучитьСоответствиеФункциональныхОпций(СоответствиеФО) Экспорт
	
	//++ НЕ ГОСИС
	ЭлектронноеВзаимодействиеУТ.ПолучитьСоответствиеФункциональныхОпций(СоответствиеФО);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Определяет соответствие справочников библиотеки и прикладного решения.
//
// Параметры:
//  СоответствиеСправочников - Соответствие - список справочников.
//
// Пример:
//    СоответствиеСправочников.Вставить("Организации",                 "Организации");
//    СоответствиеСправочников.Вставить("Контрагенты",                 "Контрагенты");
//    СоответствиеСправочников.Вставить("ДоговорыКонтрагентов",        "ДоговорыКонтрагентов");
//    СоответствиеСправочников.Вставить("Номенклатура",                "Номенклатура");
//    СоответствиеСправочников.Вставить("ЕдиницыИзмерения",            "ЕдиницыИзмерения");
//    СоответствиеСправочников.Вставить("Валюты",                      "Валюты");
//    СоответствиеСправочников.Вставить("Банки",                       "КлассификаторБанков");
//    СоответствиеСправочников.Вставить("БанковскиеСчетаОрганизаций",  "БанковскиеСчета");
//    СоответствиеСправочников.Вставить("БанковскиеСчетаКонтрагентов", "БанковскиеСчета");
//    СоответствиеСправочников.Вставить("УпаковкиНоменклатуры",        "ЕдиницыИзмерения");
//    СоответствиеСправочников.Вставить("ФизическиеЛица",              "ФизическиеЛица");
//    СоответствиеСправочников.Вставить("Партнеры",                    "Партнеры");
//    СоответствиеСправочников.Вставить("ХарактеристикиНоменклатуры",  "ХарактеристикиНоменклатуры");
//
Процедура ПолучитьСоответствиеСправочников(СоответствиеСправочников) Экспорт
	
	//++ НЕ ГОСИС
	ЭлектронноеВзаимодействиеУТ.ПолучитьСоответствиеСправочников(СоответствиеСправочников);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// В процедуре формируется соответствие для сопоставления имен переменных библиотеки,
// наименованиям объектов и реквизитов метаданных прикладного решения.
// Если в прикладном решении есть документы, на основании которых формируется ЭД,
// причем названия реквизитов данных документов отличаются от общепринятых "Организация", "Контрагент", "СуммаДокумента", "Номер", "Дата",
// то для этих реквизитов необходимо добавить в соответствие записи виде:
// Ключ = "ДокументВМетаданных.ОбщепринятоеНазваниеРеквизита", Значение - "ДокументВМетаданных.ДругоеНазваниеРеквизита".
// Например:
//  СоответствиеРеквизитовОбъекта.Вставить("МЗ_Покупка.Организация", "МЗ_Покупка.Учреждение");
//  СоответствиеРеквизитовОбъекта.Вставить("МЗ_Покупка.Контрагент",  "МЗ_Покупка.Грузоотправитель");
//  СоответствиеРеквизитовОбъекта.Вставить("СчетФактураВыданный.СуммаДокумента",  "СчетФактураВыданный.Основание.СуммаДокумента");
// 
// Для подсистемы БизнесСеть обязательно определение следующих полей:
//   "ИННКонтрагента"
//   "КППКонтрагента"
//   "НаименованиеКонтрагента"
//   "НаименованиеОрганизации"
//   "ИННОрганизации"
//   "КППОрганизации"
//   "СокращенноеНаименованиеОрганизации"
// Для подсистемы ОбменСКонтрагентами обязательно определение следующих полей: 
//   "НаименованиеКонтрагентаДляСообщенияПользователю"
//   "НаименованиеКонтрагента"
//   "ВнешнийКодКонтрагента"
//   "ВладелецДоговораКонтрагента"
//   "ПартнерКонтрагента"
//   "ИННКонтрагента"
//   "КППКонтрагента"
//   "НаименованиеОрганизации"
//   "СокращенноеНаименованиеОрганизации"
//   "ИННОрганизации"
//   "КППОрганизации"
//   "ОГРНОрганизации"
// Для подсистемы ОбменССайтами обязательно определение следующих полей:
// 	 "ИННОрганизации"
//   "КППОрганизации"
//   "НаименованиеОрганизации"
//   "ПолноеНаименованиеОрганизации"
//   "ЮридическоеФизическоеЛицо"
// Для подсистемы ОбменСБанками требуется определение следующих полей:
//   "ИННОрганизации" (обязательное)
//   "Банк.БИК" (обязательное)
//   "Банк.Наименование" (обязательное)
//   "Банк.Город" (обязательное)
//   "БанковскийСчетОрганизации.Организация" (обязательное, если есть в метаданных)
//   "БанковскийСчетОрганизации.Банк" (обязательное, если есть в метаданных)
//   "БанковскийСчетОрганизации.НомерСчета" (обязательное, если есть в метаданных)
//   "ПлатежноеПоручениеВМетаданных" (необязательное)
//   "БанковскийСчетОрганизации.Закрыт" (необязательное)
//   "СокращенноеНаименованиеОрганизации" (необязательное)
//   "ПлатежноеПоручение.СчетОрганизации" (обязательное для писем)
//   "ПлатежноеПоручение.Организация" (обязательное для писем)
//
// Параметры:
//  СоответствиеРеквизитовОбъекта - Соответствие - содержит:
//    * Ключ - Строка - имя переменной, используемой в коде библиотеки;
//    * Значение - Строка - наименование объекта метаданных или реквизита объекта в прикладном решении.
//
Процедура ПолучитьСоответствиеНаименованийОбъектовМДИРеквизитов(СоответствиеРеквизитовОбъекта) Экспорт
	
	//++ НЕ ГОСИС
	ЭлектронноеВзаимодействиеУТ.ПолучитьСоответствиеНаименованийОбъектовМДИРеквизитов(СоответствиеРеквизитовОбъекта);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Находит ссылку на объект ИБ по типу, ИД и дополнительным реквизитам.
// 
// Параметры:
//  ТипОбъекта - Строка - идентификатор типа объекта, который необходимо найти;
//  Результат - ЛюбаяСсылка - ссылка на найденный объект.
//  ИдОбъекта - Строка - идентификатор объекта заданного типа;
//  ДополнительныеРеквизиты - Структура - набор дополнительных полей объекта для поиска;
//
Процедура НайтиСсылкуНаОбъект(ТипОбъекта, Результат, ИдОбъекта = "", ДополнительныеРеквизиты = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	ЭлектронноеВзаимодействиеУТ.НайтиСсылкуНаОбъект(ТипОбъекта, Результат, ИдОбъекта, ДополнительныеРеквизиты);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Получает печатный номер документа.
//
// Параметры:
//  СсылкаНаОбъект - ДокументСсылка - ссылка на документ информационной базы.
//  Результат - Строка - номер документа.
//
Процедура ПолучитьПечатныйНомерДокумента(СсылкаНаОбъект, Результат) Экспорт
	
	//++ НЕ ГОСИС
	Результат = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(СсылкаНаОбъект.Номер, Истина, Истина);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Проверяет, готовность документов ИБ для формирования ЭД, и удаляет из массива не готовые документы.
//
// Параметры:
//  ДокументыМассив - Массив - ссылки на документы, которые должны быть проверены перед формированием ЭД.
//  БезЭлектроннойПодписи - Булево - обозначает использование электронной подписи при обмене документами.
//                          Истина - обмен происходит в рамках подсистемы ЭлектронноеВзаимодействие.БизнесСеть
//                          Ложь - обмен происходит в рамках подсистемы ЭлектронноеВзаимодействие.ОбменСКонтрагентами
//
Процедура ПроверитьГотовностьИсточников(ДокументыМассив, БезЭлектроннойПодписи = Ложь) Экспорт
	
	//++ НЕ ГОСИС
	ЭлектронноеВзаимодействиеУТ.ПроверитьГотовностьИсточников(ДокументыМассив, БезЭлектроннойПодписи);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Получает данные о юридическом (физическом) лице по ссылке.
//
// Параметры:
//  ЮрФизЛицо - СправочникСсылка - ссылка на элемент справочника, по которому получаются данные.
//  Сведения - см. ЭлектронноеВзаимодействие.СтруктураДанныхЮрФизЛица
//
Процедура ПолучитьДанныеЮрФизЛица(ЮрФизЛицо, Сведения) Экспорт
	
	//++ НЕ ГОСИС
	Сведения = ЭлектронноеВзаимодействиеУТ.ПолучитьДанныеЮрФизЛица(ЮрФизЛицо);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Возвращает текстовое описание организации по параметрам.
//
// Параметры:
//  СведенияОрганизации - Структура - См. ПолучитьДанныеЮрФизЛица 
//  Результат           - Строка - описание организации.
//  Список              - Строка - список параметров организации, которые нужно включить в описание. Если пустой, должно 
//                        формироваться наиболее полное представление.
//
Процедура ОписаниеОрганизации(СведенияОрганизации, Результат, Список = "") Экспорт
	
	//++ НЕ ГОСИС
	Результат = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОрганизации, Список);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Проверяет наличие прав на открытие журнала регистрации.
//
// Параметры:
//  Результат - Булево - если пользователь имеет право на открытие журнала регистрации,
//                       в этой переменной должна быть установлена Истина.
//
Процедура ЕстьПравоОткрытияЖурналаРегистрации(Результат) Экспорт
	
	//++ НЕ ГОСИС
	Результат = Пользователи.ЭтоПолноправныйПользователь(, , Ложь);
	//-- НЕ ГОСИС
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с электронными документами

// Выполняется перед записью учетного объекта - владельца электронного документа, который может служить основанием для 
// исходящего электронного документа в случае, если существует действующая настройка отправки, соответствующая параметрам,
// указанным в объекте учета.
//
// Параметры:
//  Объект - ДокументОбъект - прикладной объект, запись которого инициировала вызов метода. Входной параметр.
//  ИзменилисьКлючевыеРеквизиты - Булево - признак изменения данных, влияющих на формирование электронного документа. Выходной параметр.
//                                         Если Истина, то текущая версия электронного документа становится неактуальной. 
//                                         По умолчанию для нового документа Истина, иначе Ложь.
//                                         Не используется для внутренних электронных документов
//  СостояниеЭлектронногоДокумента - ПеречислениеСсылка - состояние текущей версии электронного документа.
//                                   Входной параметр. Может быть использован для анализа текущего этапа обработки электронного документа. 
//                                   Позволяет описать зависимости заполнения выходных параметров от факта создания, подписания или отправки ЭД контрагенту.
//                                   Не передается для внутренних электронных документов
//  ПодлежитОбменуЭД - Булево - признак участия документа в ЭДО. Выходной параметр. По умолчанию Истина.
//                              При установке в Ложь прикладной объект не будет отображаться как требующий создания электронного документа (например, раздел "Создать" в текущих делах ЭДО). 
//                              Если ЭД уже был создан, то он становиться неактуальным.
//                              Не используется для внутренних электронных документов
//  ТребуетсяКонтрольАктуальности - Булево - Необходимо указать, требуется ли запустить встроенную проверку актуальности 
//                                           сформированных электронных документов. Проверка может быть ресурсозатратной.
//                                           Рекомендуется ее отключать, если проводятся операции, заведомо не приводящие
//                                           к потере актуальности электронных документов. По умолчанию Истина.
//                                           Только для внутренних электронных документов. Выходной параметр.
//  Отказ - Булево - если установить Истина, то владелец электронного документа записан не будет. Выходной параметр. По умолчанию Ложь.
//
// Пример:
//  1. Необходимо сделать существующий ЭД неактуальным, чтобы пользователь создал новый. Для этого:
//   * Присвоить параметру  ИзменилисьКлючевыеРеквизиты значение Истина.
//  2. Необходимо отказать пользователю во внесении изменений в документ, если уже есть существующий ЭД. Для этого:
//   * Проверить параметр СостояниеЭлектронногоДокумента на неравенство значению НеСформирован.
//   * Присвоить параметру  Отказ значение Истина.
//   * (необязательно) Присвоить параметру  ИзменилисьКлючевыеРеквизиты значение Истина. 
//     В этом случае пользователь дополнительно получит сообщение: "Существует электронный документ. Изменение ключевых реквизитов документа запрещено.".
//  3. Необходимо исключить прикладной объект из возможных оснований для ЭД. Например, если известно, что он выставлен в бумажном виде, и ЭД не требуется. 
//     Существующий ЭД сделать неактуальным и не отображать прикладной документ в разделе "Создать" обработки "Текущие дела ЭДО". Для этого:
//   * Присвоить параметру  ПодлежитОбменуЭД значение Ложь.
//
Процедура ПередЗаписьюВладельцаЭлектронногоДокумента(Объект, ИзменилисьКлючевыеРеквизиты, Знач СостояниеЭлектронногоДокумента, 
	ПодлежитОбменуЭД, ТребуетсяКонтрольАктуальности, Отказ) Экспорт
	
	//++ НЕ ГОСИС
	ЭлектронноеВзаимодействиеУТ.ПередЗаписьюВладельцаЭлектронногоДокумента(Объект, ИзменилисьКлючевыеРеквизиты, СостояниеЭлектронногоДокумента, 
			ПодлежитОбменуЭД, ТребуетсяКонтрольАктуальности, Отказ);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#Область СобытияПодсистемы

// Выполняется при создании формы подсистемы, допускающей изменение.
// Позволяет изменить реквизиты, команды и элементы формы.
// Вызывается для форм со следующим назначением (см. параметр Контекст.Назначение):
// "СопоставлениеНоменклатуры"
// Для добавленных элементов возможно подключение обработчиков событий методом УстановитьДействие.
// Список подключаемых действий в формате <Событие>-<Имя подключаемого метода>-<Имя метода с реализацией>:
// ПриИзменении                  - Подключаемый_ЭлементПриИзменении                  - ЭлементФормыПодсистемыПриИзменении
// НачалоВыбора                  - Подключаемый_ЭлементНачалоВыбора                  - ЭлементФормыПодсистемыНачалоВыбора
// НачалоВыбораИзСписка          - Подключаемый_ЭлементНачалоВыбораИзСписка          - ЭлементФормыПодсистемыНачалоВыбораИзСписка
// Очистка                       - Подключаемый_ЭлементОчистка                       - ЭлементФормыПодсистемыОчистка
// Создание                      - Подключаемый_ЭлементСоздание                      - ЭлементФормыПодсистемыСоздание
// ОбработкаВыбора               - Подключаемый_ЭлементОбработкаВыбора               - ЭлементФормыПодсистемыОбработкаВыбора
// ИзменениеТекстаРедактирования - Подключаемый_ЭлементИзменениеТекстаРедактирования - ЭлементФормыПодсистемыИзменениеТекстаРедактирования
// АвтоПодбор                    - Подключаемый_ЭлементАвтоПодбор                    - ЭлементФормыПодсистемыАвтоПодбор
// ОкончаниеВводаТекста          - Подключаемый_ЭлементОкончаниеВводаТекста          - ЭлементФормыПодсистемыОкончаниеВводаТекста
// Нажатие                       - Подключаемый_ЭлементНажатие                       - ЭлементФормыПодсистемыНажатие
// ОбработкаНавигационнойСсылки  - Подключаемый_ЭлементОбработкаНавигационнойСсылки  - ЭлементФормыПодсистемыОбработкаНавигационнойСсылки
// ДействиеКоманды               - Подключаемый_КомандаДействие                      - КомандаФормыПодсистемыДействие
// Методы с реализацией находятся в модуле ОбменСКонтрагентамиКлиентПереопределяемый.
//
// Параметры:
//  Контекст - ФиксированнаяСтруктура - контекст создания формы:
//   * Назначение - Строка - назначение формы.
//   * Форма - ФормаКлиентскогоПриложения - форма для изменения.
//   * Префикс - Строка - префикс имен для новых реквизитов, команд и элементов формы.
//  Отказ - Булево - аналогичен параметру обработчика события "ПриСозданииНаСервер" управляемой формы.
//  СтандартнаяОбработка - Булево - аналогичен параметру обработчика события "ПриСозданииНаСервер" управляемой формы.
//
// Пример:
//  Если Контекст.Назначение = "СопоставлениеНоменклатуры" Тогда
//  	Контекст.Форма.Элементы.Добавить(Префикс + "ИмяНовогоЭлемент",...);
//  	Контекст.Форма.Команды.Добавить(Префикс + "ИмяНовойКоманды");
//  	....
//  КонецЕсли;
//
Процедура ПриСозданииФормыПодсистемы(Контекст, Отказ, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

