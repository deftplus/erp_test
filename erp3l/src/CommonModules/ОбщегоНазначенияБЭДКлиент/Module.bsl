
#Область СлужебныйПрограммныйИнтерфейс

Процедура ВыполнитьПроверкуПроведенияДокументов(ДокументыМассив, ОбработкаПродолжения, ФормаИсточник = Неопределено) Экспорт
	
	СтандартнаяОбработка = Истина;
	ЭлектронноеВзаимодействиеКлиентПереопределяемый.ВыполнитьПроверкуПроведенияДокументов(
		ДокументыМассив, ОбработкаПродолжения, ФормаИсточник, СтандартнаяОбработка);
		
	Если СтандартнаяОбработка = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	ДокументыТребующиеПроведение = ОбщегоНазначенияВызовСервера.ПроверитьПроведенностьДокументов(ДокументыМассив);
	КоличествоНепроведенныхДокументов = ДокументыТребующиеПроведение.Количество();
	
	Если КоличествоНепроведенныхДокументов > 0 Тогда
		
		Если КоличествоНепроведенныхДокументов = 1 Тогда
			ТекстВопроса = НСтр("ru = 'Для того чтобы сформировать электронную версию документа, его необходимо предварительно провести.
										|Выполнить проведение документа и продолжить?';
										|en = 'To generate an electronic document version, post it.
										|Do you want to post the document and continue?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Для того чтобы сформировать электронные версии документов, их необходимо предварительно провести.
										|Выполнить проведение документов и продолжить?';
										|en = 'To generate electronic document versions, post them.
										|Do you want to post the documents and continue?'");
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОбработкаПродолжения", ОбработкаПродолжения);
		ДополнительныеПараметры.Вставить("ДокументыТребующиеПроведение", ДокументыТребующиеПроведение);
		ДополнительныеПараметры.Вставить("ФормаИсточник", ФормаИсточник);
		ДополнительныеПараметры.Вставить("ДокументыМассив", ДокументыМассив);
		Обработчик = Новый ОписаниеОповещения("ВыполнитьПроверкуПроведенияДокументовПродолжить", ОбщегоНазначенияБЭДСлужебныйКлиент, ДополнительныеПараметры);
		
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ВыполнитьОбработкуОповещения(ОбработкаПродолжения, ДокументыМассив);
	КонецЕсли;
	
КонецПроцедуры

// Получает массив ссылок на объекты по параметру команды.
//
// Параметры:
//  ПараметрКоманды - выделенные строки таблицы формы.
//
// Возвращаемое значение:
//  МассивСсылок - если передан в параметр массив, то возвращает его же, если переданы выделенные строки табличного поля,
//                 преобразует их в массив.
//  Неопределено - если передана пустая ссылка.
//
Функция МассивПараметров(ПараметрКоманды) Экспорт
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		Если ТипЗнч(ПараметрКоманды) = Тип("ВыделенныеСтрокиТабличногоПоля") Тогда
			МассивСсылок = Новый Массив;
			Для Каждого Элемент Из ПараметрКоманды Цикл
				МассивСсылок.Добавить(Элемент);
			КонецЦикла;
			
			Возврат МассивСсылок;
		КонецЕсли;
	#КонецЕсли
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		Если ПараметрКоманды.Количество() = 0 Тогда
			Возврат Неопределено;
		КонецЕсли;
		МассивСсылок = ПараметрКоманды;
	Иначе // пришла единичная ссылка на объект
		Если НЕ ЗначениеЗаполнено(ПараметрКоманды) Тогда
			Возврат Неопределено;
		КонецЕсли;
		МассивСсылок = Новый Массив;
		МассивСсылок.Добавить(ПараметрКоманды);
	КонецЕсли;
	
	Возврат МассивСсылок;
	
КонецФункции

// Копирует в буфер обмена операционной системы указанный текст. Не работает в режиме веб-клиента и мобильного клиента.
// 
// Параметры:
// 	Текст - Строка - текст, который нужно скопировать.
// 	ТекстОповещения - Строка - текст, который нужно вывести в оповещении после успешного копирования.
Процедура СкопироватьВБуферОбмена(Текст, ТекстОповещения) Экспорт

#Если Не ВебКлиент И Не МобильныйКлиент Тогда
	
	Попытка
		ОбъектЗапись = Новый COMОбъект("htmlfile");
		ОбъектЗапись.ParentWindow.ClipboardData.Setdata("Text", Текст);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Успешно';
											|en = 'Done'"),
				, ТекстОповещения);
	Исключение
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Возникла ошибка при копировании в буфер обмена.
				|Воспользуйтесь комбинацией клавиш Ctrl+C.';
				|en = 'An error occurred while copying to the clipboard. 
				|Press Ctrl+C.'"));
	КонецПопытки;
	
#КонецЕсли

КонецПроцедуры

// Возвращает имя события оповещения, сгенерированного с помощью см. ОбщегоНазначенияКлиент.ОповеститьОбИзмененииОбъекта
// 
// Параметры:
// 	Источник - ЛюбаяСсылка,
//             РегистрСведенийКлючЗаписи,
//             РегистрНакопленияКлючЗаписи,
//             РегистрБухгалтерииКлючЗаписи,
//             РегистрРасчетаКлючЗаписи - ссылка измененного объекта или ключ измененной записи регистра, об изменении 
//                                        которой(го) необходимо уведомить динамические списки и формы.
// Возвращаемое значение:
// 	Строка - имя события. Может быть использовано для определения события в событии ОбработкаОповещения.
Функция ИмяСобытияИзмененияОбъекта(Источник) Экспорт
	Возврат "Запись_" + ОбщегоНазначенияБЭДСлужебныйКлиент.ИмяОбъектаМетаданных(ТипЗнч(Источник));
КонецФункции

// Возвращает ключ записи регистра сведений.
// 
// Параметры:
// 	Тип - Тип - тип регистра сведений, ключ записи которого нужно создать.
// 	ЗначенияКлюча - Структура:
// 	 * Ключ - Строка - имя измерения
// 	 * Значение - Произвольный - значение измерения
// Возвращаемое значение:
// 	Произвольный
Функция КлючЗаписиРегистраСведений(Тип, ЗначенияКлюча) Экспорт
	
	ПараметрыЗаписи = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ЗначенияКлюча);
	КлючЗаписи = Новый(Тип, ПараметрыЗаписи);
	
	Возврат КлючЗаписи;
	
КонецФункции

// Запускает форму подключения к системе "Взаимодействия".
// 
Процедура ПодключитьСистемуВзаимодействия() Экспорт
	
	НавигационнаяСсылка = "e1cib/command/Обработка.РегистрацияВСистемеВзаимодействия.Команда.РегистрацияВзаимодействий";
	ПерейтиПоНавигационнойСсылке(НавигационнаяСсылка);
	
КонецПроцедуры

// Открывает диалог настройки регламентного задания и записывает регламентное задание с измененным расписанием.
// 
// Параметры:
// 	ИмяЗадания - Строка - имя задания в метаданных.
// 	Оповещение - ОписаниеОповещения - обработчик оповещения, который будет вызван после редактирования расписания.
//
Процедура НастроитьРасписаниеРегламентногоЗадания(ИмяЗадания, Оповещение = Неопределено) Экспорт
	
	Расписание = ОбщегоНазначенияБЭДСлужебныйВызовСервера.ПолучитьПараметрРегламентногоЗадания(ИмяЗадания, "Расписание",
		Новый РасписаниеРегламентногоЗадания);
	
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	
	Контекст = Новый Структура;
	Контекст.Вставить("ИмяЗадания", ИмяЗадания);
	Контекст.Вставить("Оповещение", Оповещение);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ОбщегоНазначенияБЭДСлужебныйКлиент, Контекст);
	ДиалогРасписания.Показать(ОписаниеОповещения);
	
КонецПроцедуры

#Область ВводСтроки

// Вызывает диалог для ввода строки.
//
// Параметры:
//  ОписаниеОповещенияОЗавершении - ОписаниеОповещения - Содержит описание процедуры, которая будет вызвана после
//                                  закрытия окна ввода строки со следующими параметрами:
//    * РезультатВвода - Строка - введенное значение строки или Неопределено, если пользователь отказался от ввода.
//    * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта ОписаниеОповещения.
//  Параметры - см. ПараметрыВводаСтроки
//
Процедура ПоказатьВводСтрокиБЭД(ОписаниеОповещенияОЗавершении, Параметры) Экспорт
	
	ОткрытьФорму("Обработка.ОбщегоНазначенияБЭД.Форма.ВводСтроки", Параметры, , , , , ОписаниеОповещенияОЗавершении);
	
КонецПроцедуры

// Конструктор параметра Параметры, см. ПоказатьВводСтрокиБЭД
// 
// Возвращаемое значение:
// 	Структура:
// * ОбработчикПолученияПредставлений - Строка - полный путь к методу, вычисляющему представление данных. Метод должен
// 		содержать один параметр, в который будет передано значение параметра Данные.  
// * ПредставлениеДанных - Строка - если задан, будет использоваться для отображения на форме гиперссылки на данные.
// * Данные - Массив - если указан, в из формы ввода строки можно будет перейти к данным. Элементами могут являться
//		любые типы, которые можно отобразить на форме. 
// * НазваниеКнопкиПоУмолчанию - Строка - название будет присвоено кнопке ОК.
// * КомментарийОбязательностиВвода - Строка - если указан, будет отображен пользователю при попытке ввода пустого
// 		значения и значении параметра Обязательность = Истина.
// * Обязательность - Булево - в значении Истина будет запрещен ввод пустой строки.
// * Многострочность - Булево - признак использования многострочной строки.
// * ЗаголовокФормы - Строка - заголовок для формы ввода.
Функция ПараметрыВводаСтроки() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ЗаголовокФормы", "");
	Параметры.Вставить("Многострочность", Ложь);
	Параметры.Вставить("Обязательность", Ложь);
	Параметры.Вставить("КомментарийОбязательностиВвода", "");
	Параметры.Вставить("НазваниеКнопкиПоУмолчанию", "");
	Параметры.Вставить("Данные", Неопределено);
	Параметры.Вставить("ПредставлениеДанных", "");
	Параметры.Вставить("ОбработчикПолученияПредставлений", "");
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти

#Область ВводПароля

// Открывает форму ввода пароля.
// 
// Параметры:
// 	ПараметрыВвода - Структура - параметры показа формы:
// 	 * Заголовок - Строка - заголовок формы.
// 	 * Подсказка - Строка - если задана, будет использована как подсказка поля ввода пароля.
// 	 * ИспользоватьЗапоминание - Булево - если Истина, будет выведена опция запоминания пароля.
// 	 * ПодсказкаЗапоминания - Строка - если задана, будет использована как подсказка у опции запоминания пароля.
// 	ОбработкаПродолжения - ОбработчикОповещения - обработчик, который будет вызван после закрытия формы ввода пароля.
Процедура ПоказатьВводПароля(Знач ПараметрыВвода, Знач ОбработкаПродолжения) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", "");
	ПараметрыФормы.Вставить("Подсказка", "");
	ПараметрыФормы.Вставить("ИспользоватьЗапоминание", Ложь);
	ПараметрыФормы.Вставить("ПодсказкаЗапоминания", "");
	ЗаполнитьЗначенияСвойств(ПараметрыФормы, ПараметрыВвода);
	
	ОткрытьФорму("Обработка.ОбщегоНазначенияБЭД.Форма.ВводПароля", ПараметрыФормы,,,,, ОбработкаПродолжения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область КонструкторФормул

// Открывает конструктор формул.
// 
// Параметры:
// 	ПараметрыКонструктора - см. НовыеПараметрыКонструктораФормул.
// 	Оповещение - ОписаниеОповещения - обработчик, который будет вызван по закрытии формы конструктора.
// 	ВладелецФормы - ФормаКлиентскогоПриложения - форма-владелец.
Процедура ОткрытьКонструкторФормул(ПараметрыКонструктора, Оповещение, ВладелецФормы) Экспорт
	
	ОткрытьФорму("Обработка.ОбщегоНазначенияБЭД.Форма.КонструкторФормул", ПараметрыКонструктора, ВладелецФормы,,,, Оповещение);
	
КонецПроцедуры

// Конструктор параметров метода см. ОткрытьКонструкторФормул
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * Формула - Строка - формула.
// * АдресНабораОперандов - Строка - адрес временного хранилища, в которое помещен запрос, который будет использован для
//                                   компоновщика операндов.
Функция НовыеПараметрыКонструктораФормул() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("АдресНабораОперандов", "");
	Параметры.Вставить("Формула", "");
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти

#Область Оповещения

// Проверяет, что переданное имя события соответствует изменению переданного объекта.
// 
// Параметры:
// 	Объект - ЛюбаяСсылка
// 	       - см. ОбъектыСобытияИзменениеОбъекта
// 	ИмяСобытия - Строка - имя события, переданное в обработку оповещения.
// Возвращаемое значение:
// 	Булево - Истина, если указанное событие является событием изменения объекта.
Функция ЭтоСобытиеИзменениеОбъекта(Объект, ИмяСобытия) Экспорт
	
	Если ТипЗнч(Объект) = Тип("Строка") И Объект = ОбъектыСобытияИзменениеОбъекта().НаборКонстант Тогда
		ИмяСобытияИзменение = "Запись_НаборКонстант";
	Иначе
		ИмяСобытияИзменение = ИмяСобытияИзмененияОбъекта(Объект);
	КонецЕсли;
	
	Возврат ИмяСобытияИзменение = ИмяСобытия;
	
КонецФункции

// Получает набор объектов, которые не могут быть представлены ссылкой.
// 
// Возвращаемое значение:
// 	Структура - Описание:
//  * НаборКонстант - Строка - набор констант.
Функция ОбъектыСобытияИзменениеОбъекта() Экспорт
	
	Объекты = Новый Структура;
	Объекты.Вставить("НаборКонстант", "НаборКонстант");
	
	Возврат Объекты;
	
КонецФункции

#КонецОбласти

#Область ОткрытиеФормы

// Блокирует открытие формы на мобильном клиенте
//
// Параметры:
//  Отказ - Булево - если используется мобильный клиент, то параметр устанавливается в значение Истина.
//
Процедура ЗаблокироватьОткрытиеФормыНаМобильномКлиенте(Отказ) Экспорт
	
	#Если МобильныйКлиент Тогда
		ТекстСообщения = НСтр("ru = 'Функциональность в мобильном клиенте пока недоступна. Воспользуйтесь веб-клиентом или тонким клиентом';
								|en = 'Functionality in the mobile client is not yet available. Use the web client or thin client'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	#КонецЕсли
	
КонецПроцедуры

// Возвращает параметры открытия формы, см. ОткрытьФормуБЭД.
// 
// Возвращаемое значение:
// 	Структура:
// * Владелец - Произвольный - см. одноименный параметр метода ОткрытьФорму
// * Уникальность - Произвольный - см. одноименный параметр метода ОткрытьФорму
// * Окно - ОкноКлиентскогоПриложения - см. одноименный параметр метода ОткрытьФорму
// * НавигационнаяСсылка - Строка, Неопределено - см. одноименный параметр метода ОткрытьФорму
// * ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - см. одноименный параметр метода ОткрытьФорму
// * РежимОткрытияОкна - РежимОткрытияОкнаФормы - см. одноименный параметр метода ОткрытьФорму
Функция НовыеПараметрыОткрытияФормы() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Владелец");
	Параметры.Вставить("Уникальность");
	Параметры.Вставить("Окно");
	Параметры.Вставить("НавигационнаяСсылка", Неопределено);
	Параметры.Вставить("ОписаниеОповещенияОЗакрытии");
	Параметры.Вставить("РежимОткрытияОкна", Неопределено);
	
	Возврат Параметры;
	
КонецФункции

// Открывает форму.
// 
// Параметры:
// 	ИмяФормы - Строка
// 	ПараметрыФормы - Структура - см. параметр "Параметры" метода ОткрытьФорму
// 	ПараметрыОткрытияФормы - ПараметрыВыполненияКоманды
//                         - см. НовыеПараметрыОткрытияФормы
// 	ВыполнятьЗамерВремени - Булево - выполнять замер времени открытия формы
Процедура ОткрытьФормуБЭД(ИмяФормы, ПараметрыФормы = Неопределено, ПараметрыОткрытияФормы = Неопределено,
	ВыполнятьЗамерВремени = Ложь) Экспорт
	
	СлужебныеПараметрыОткрытияФормы = НовыеПараметрыОткрытияФормы();
	
	Если ТипЗнч(ПараметрыОткрытияФормы) = Тип("ПараметрыВыполненияКоманды") Тогда
		ЗаполнитьЗначенияСвойств(СлужебныеПараметрыОткрытияФормы, ПараметрыОткрытияФормы);
		СлужебныеПараметрыОткрытияФормы.Владелец = ПараметрыОткрытияФормы.Источник;
	ИначеЕсли ТипЗнч(ПараметрыОткрытияФормы) = Тип("Структура") Тогда 
		ЗаполнитьЗначенияСвойств(СлужебныеПараметрыОткрытияФормы, ПараметрыОткрытияФормы);
	КонецЕсли;
	
	Если ВыполнятьЗамерВремени Тогда
		ИмяОперации = СтрШаблон("%1.ОткрытиеФормы", ИмяФормы);
		ОценкаПроизводительностиКлиент.ЗамерВремени(ИмяОперации);
	КонецЕсли;
	
	ОткрытьФорму(ИмяФормы, ПараметрыФормы,
		СлужебныеПараметрыОткрытияФормы.Владелец,
		СлужебныеПараметрыОткрытияФормы.Уникальность,
		СлужебныеПараметрыОткрытияФормы.Окно,
		СлужебныеПараметрыОткрытияФормы.НавигационнаяСсылка,
		СлужебныеПараметрыОткрытияФормы.ОписаниеОповещенияОЗакрытии,
		СлужебныеПараметрыОткрытияФормы.РежимОткрытияОкна);
	
КонецПроцедуры

#КонецОбласти

#Область АсинхронныйЦикл

// Стартует асинхронный цикл
// 
// Параметры:
// 	ОбработчикЗавершения - ОписаниеОповещения - обработчик, который нужно вызывать после окончания асинхронного цикла.
// 	Данные - Произвольный - данные, которые нужно передавать между обработчиками.
// 	Обработчики - Массив из ОписаниеОповещения - набор обработчиков, которые нужно выполнять на каждой итерации цикла.
// 	Контекст - Структура - переменная для передачи контекста в асинхронном цикле. Используется для передачи служебных
// 		свойств.Может быть использована для передачи произвольных данных, необходимых для выполнения алгоритма.
Процедура АсинхронныйЦиклНачать(ОбработчикЗавершения, Данные, Обработчики, Контекст) Экспорт
	
	Если Данные = Неопределено Тогда
		Данные = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Неопределено);
	КонецЕсли;
	КонтекстЦикла = Новый Структура;
	КонтекстЦикла.Вставить("ОбработчикЗавершения", ОбработчикЗавершения);
	КонтекстЦикла.Вставить("Данные", Данные);
	КонтекстЦикла.Вставить("Обработчики", Обработчики);
	КонтекстЦикла.Вставить("СчетчикДанных", 0);
	КонтекстЦикла.Вставить("СчетчикОбработчиков", 0);
	КонтекстЦикла.Вставить("ТекущийУровеньВложенности", 0);
	
	Если Контекст.Свойство("АсинхронныйЦикл") Тогда
		ТекущийАсинхронныйЦикл = ОбщегоНазначенияБЭДСлужебныйКлиент.АсинхронныйЦиклТекущийЦикл(Контекст);
		ТекущийАсинхронныйЦикл.Вставить("АсинхронныйЦикл", КонтекстЦикла);
		Контекст.АсинхронныйЦикл.ТекущийУровеньВложенности = Контекст.АсинхронныйЦикл.ТекущийУровеньВложенности + 1;
	Иначе 
		Контекст.Вставить("АсинхронныйЦикл", КонтекстЦикла);
	КонецЕсли;
	
	ОбщегоНазначенияБЭДСлужебныйКлиент.АсинхронныйЦиклНачало(Контекст);
	
КонецПроцедуры

// Вызывает следующий по очереди обработчик асинхронного цикла.
// 
// Параметры:
// 	Результат - Произвольный - значение, которое будет передано обработчику в качестве первого параметра.
// 	Контекст - Структура - описание параметра см. АсинхронныйЦиклНачать
Процедура АсинхронныйЦиклВыполнитьСледующийОбработчик(Результат, Контекст) Экспорт
	
	ТекущийАсинхронныйЦикл = ОбщегоНазначенияБЭДСлужебныйКлиент.АсинхронныйЦиклТекущийЦикл(Контекст);
	ТекущийАсинхронныйЦикл.СчетчикОбработчиков = ТекущийАсинхронныйЦикл.СчетчикОбработчиков + 1;
	ОбщегоНазначенияБЭДСлужебныйКлиент.АсинхронныйЦиклНачало(Контекст, Результат);
	
КонецПроцедуры

// Получает описание оповещения перехода к следующему обработчику. Может быть использовано, когда необходимо прервать
// асинхронный цикл, например, для запроса данных у пользователя.
// 
// Параметры:
// 	Контекст - Структура - описание параметра см. АсинхронныйЦиклНачать.
// Возвращаемое значение:
// 	ОписаниеОповещения - описание оповещения перехода к следующему обработчику.
Функция АсинхронныйЦиклСледующийОбработчик(Контекст) Экспорт
	
	НовыйОбработчик = Новый ОписаниеОповещения("АсинхронныйЦиклВыполнитьСледующийОбработчик", ЭтотОбъект, Контекст);
	Возврат НовыйОбработчик;
	
КонецФункции

// Возвращает элемент данных, который обрабатывается в цикле в текущей его итерации.
// 
// Параметры:
// 	Контекст - Структура - описание параметра см. АсинхронныйЦиклНачать.
// Возвращаемое значение:
// 	Произвольный - элемент данных.
Функция АсинхронныйЦиклТекущийЭлементДанных(Контекст) Экспорт
	 
	ТекущийАсинхронныйЦикл = ОбщегоНазначенияБЭДСлужебныйКлиент.АсинхронныйЦиклТекущийЦикл(Контекст);
	Возврат ТекущийАсинхронныйЦикл.Данные[ТекущийАсинхронныйЦикл.СчетчикДанных];
	
КонецФункции

#КОнецОбласти

#КонецОбласти
