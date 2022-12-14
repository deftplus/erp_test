
#Область ПрограммныйИнтерфейс

//++ НЕ УТ

// Функция убирает из текста сообщения служебную информацию.
//
// Параметры:
//  ТекстСообщения - Строка - Исходный текст сообщения.
//
// Возвращаемое значение:
//   Строка - Текст сообщения без служебной информации.
//
Функция СформироватьТекстСообщения(Знач ТекстСообщения) Экспорт

	НачалоСлужебногоСообщения    = СтрНайти(ТекстСообщения, "{");
	ОкончаниеСлужебногоСообщения = СтрНайти(ТекстСообщения, "}:");

	Если ОкончаниеСлужебногоСообщения > 0
		И НачалоСлужебногоСообщения > 0
		И НачалоСлужебногоСообщения < ОкончаниеСлужебногоСообщения Тогда

		ТекстСообщения = Лев(ТекстСообщения, (НачалоСлужебногоСообщения - 1))
			+ Сред(ТекстСообщения, (ОкончаниеСлужебногоСообщения + 2));

	КонецЕсли;

	Возврат СокрЛП(ТекстСообщения);

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// МАТЕМАТИКА

// Предназначена для получения пустого значения заданного типа:
//	примитивного, или ссылочного.
//
// Параметры:
//	ЗаданныйТип - Тип - Тип, пустое значение которого нужно получить.
//
// Возвращаемое значение:
//	Произвольный - Пустое значение указанного типа.
//
Функция ПустоеЗначениеТипа(ЗаданныйТип) Экспорт

	Если ЗаданныйТип = Тип("Число") Тогда
		Возврат 0;

	ИначеЕсли ЗаданныйТип = Тип("Строка") Тогда
		Возврат "";

	ИначеЕсли ЗаданныйТип = Тип("Дата") Тогда
		Возврат '00010101000000';

	ИначеЕсли ЗаданныйТип = Тип("Булево") Тогда
		Возврат Ложь;

	Иначе
		Возврат Новый (ЗаданныйТип);

	КонецЕсли;

КонецФункции // ПустоеЗначениеТипа();

// Функция проверяет, что две переданные даты находятся между разными элементами 
// упорядоченного массива.
//
// Параметры:
//	Дата1 - Дата - Первая проверяемая дата.
//  Дата2 - Дата - Вторая проверяемая дата.
//	ИнтервалДат - Массив - Упорядоченный массив дат, каждый элемент которого определяет
//							новую границу интервала.
//
// Возвращаемое значение:
//	Булево - Истина, если даты принадлежат разным интервалам.
//
Функция ДатыПринадлежатРазнымИнтервалам(Знач Дата1, Знач Дата2, ИнтервалДат) Экспорт

	Результат = Ложь;

	Индекс1 = -1;
	
	Индекс2 = -1;
	
	Дата1 = НачалоДня(Дата1);
	Дата2 = НачалоДня(Дата2);
	
	ВГраницаИнтервалаДат = ИнтервалДат.ВГраница();
	Для ТекИндекс = 0 По ВГраницаИнтервалаДат Цикл
		ДатаИнтервала = НачалоДня(ИнтервалДат[ТекИндекс]);
	
		Если ДатаИнтервала <= Дата1 Тогда
			Индекс1 = ТекИндекс;
		КонецЕсли;
		
		Если ДатаИнтервала <= Дата2 Тогда
			Индекс2 = ТекИндекс;
		КонецЕсли;
		
	КонецЦикла;

	Если Индекс1 <> Индекс2 Тогда
		Результат = Истина;
	Иначе
		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ФУНКЦИОНАЛЬНЫМИ ОПЦИЯМИ

// Процедура устанавливает функциональные опции формы.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма, в которой требуется установить функциональные опции.
//	Организация - СправочникСсылка.Организации - Ссылка на организацию.
//	Период - Дата - Дата установки периодических опций.
//
Процедура УстановитьПараметрОрганизацияФункциональныхОпцийФормы(Форма, Организация, Период = Неопределено) Экспорт

	ПараметрыФО = Новый Структура();
	ПараметрыФО.Вставить("Организация", Организация);
	Если Период <> Неопределено Тогда
		ПараметрыФО.Вставить("Период", НачалоМесяца(Период));
		// Приводим к началу месяца для того, чтобы сократить пространство кэшируемых значений.
		// Параметр "Организация" используется в функциональных опциях, привязанных к регистрам сведений с периодичностью
		// Месяц или реже.
	КонецЕсли;
	
	Форма.УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

// Процедура устанавливает функциональные опции формы документа.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма, в которой требуется установить функциональные опции.
//
Процедура УстановитьПараметрыФункциональныхОпцийФормыДокумента(Форма) Экспорт
	
	УстановитьПараметрОрганизацияФункциональныхОпцийФормы(Форма, Форма.Объект.Организация, Форма.Объект.Дата);
	
КонецПроцедуры

// Функция возвращает новую структуру параметров учета.
//
// Возвращаемое значение:
//	Структура - Новая структура параметров учета.
//
Функция СтруктураПараметровУчета() Экспорт

	ПараметрыУчета = Новый Структура(
		"ВестиПартионныйУчет,
		|СкладскойУчет,
		|ИспользоватьОборотнуюНоменклатуру,
		|РазделятьПоСтавкамНДС,
		|ВестиУчетПоСтатьямДДС,
		|ВестиУчетПоРаботникам,
		|УчетЗарплатыИКадровВоВнешнейПрограмме,
		|КадровыйУчет");

	Возврат ПараметрыУчета;

КонецФункции

//-- НЕ УТ

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС ПОЛЯ ВЫБОРА ОРГАНИЗАЦИИ С ОБОСОБЛЕННЫМИ ПОДРАЗДЕЛЕНИЯМИ
//

// Устанавливает значение поля организации.
//
// Параметры:
//	ПолеОрганизация - РеквизитФормы - Реквизит формы, в котором нужно установить значение.
//	Организация - СправочникСсылка.Организации - Организация, для которой нужно установить реквизит.
//	ВключатьОбособленныеПодразделения - Булево - Признак, что нужно включать обособленные подразделения.
//
Процедура УстановитьЗначениеПолеОрганизация(ПолеОрганизация, Организация, ВключатьОбособленныеПодразделения) Экспорт
	
	Ключ = СтрЗаменить(Строка(ВключатьОбособленныеПодразделения) + Организация.УникальныйИдентификатор(), "-", "");
	ПолеОрганизация = Ключ;
	
КонецПроцедуры

// Устанавливает значения выбранных реквизитов при отказе от выбора значения (выборе пустого значения).
//
// Параметры:
//	ПолеОрганизация - РеквизитФормы - Реквизит формы, в котором нужно установить значение.
//	Организация - СправочникСсылка.Организации - Организация, для которой нужно установить реквизит.
//	ВключатьОбособленныеПодразделения - Булево - Признак, что нужно включать обособленные подразделения.
//
Процедура ОбработкаОтменыВыбораОрганизации(ПолеОрганизация, Организация, ВключатьОбособленныеПодразделения) Экспорт
	
	Если ЗначениеЗаполнено(ПолеОрганизация) Тогда 
		Возврат;
	КонецЕсли;
	
	Организация                       = Неопределено;
	ВключатьОбособленныеПодразделения = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СТРОКОВЫЕ ФУНКЦИИ

// Капитализирует строку - приводит к принятому в полных предложениях написанию:
// первый символ в верхнем регистре, остальные - без изменения.
// Например:
//  "это тест"      -> "Это тест"
//  "тест Тьюринга" -> "Тест Тьюринга"
//  "/test.txt"     -> "/test.txt"
//
// Параметры:
//  ИсходнаяСтрока - Строка - строка, текст полного предложения.
// 
// Возвращаемое значение:
//  Строка - капитализированная строка.
//
Функция КапитализироватьСтроку(ИсходнаяСтрока) Экспорт
	Возврат ВРег(Лев(ИсходнаяСтрока, 1)) + Сред(ИсходнаяСтрока, 2);
КонецФункции

// Декапитализирует строку - изменяет регистр первого символа с верхнего на нижний.
// первый символ в нижнем регистре, остальные - без изменения.
// Например:
//  "Это тест"      -> "это тест"
//  "тест Тьюринга" -> "тест Тьюринга"
//  "/test.txt"     -> "/test.txt"
//
// Параметры:
//  ИсходнаяСтрока - Строка - строка, текст полного предложения.
// 
// Возвращаемое значение:
//  Строка - декапитализированная строка.
//
Функция ДекапитализироватьСтроку(ИсходнаяСтрока) Экспорт
	Возврат НРег(Лев(ИсходнаяСтрока, 1)) + Сред(ИсходнаяСтрока, 2);
КонецФункции

// Функция возвращает строку, которая содержит только цифры из исходной строки.
//
// Параметры:
//	ИсходнаяСтрока - Строка - Исходная строка.
//
// Возвращаемое значение:
//	Строка - Строка, содержащая только цифры.
//
Функция ОставитьВСтрокеТолькоЦифры(ИсходнаяСтрока) Экспорт
	
	СтрокаРезультат = "";
	
	Для а = 1 По СтрДлина(ИсходнаяСтрока) Цикл
		ТекущийСимвол = Сред(ИсходнаяСтрока, а, 1);
		КодСимвола = КодСимвола(ТекущийСимвол);
		Если КодСимвола >= 48 И КодСимвола <= 57 Тогда
			СтрокаРезультат = СтрокаРезультат + ТекущийСимвол;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрокаРезультат;
	
КонецФункции

// Функция возвращает истину, если в переданной строке содержатся одни нули.
//
// Параметры:
//	Строка - Строка - анализируемая строка.
//
// Возвращаемое значение:
//	Булево - Если, если в переданной строке есть только 0, в противном случае - ложь.
//
Функция ТолькоНулиВСтроке(Строка) Экспорт
	
	ЗначащиеСимволы = СокрЛП(СтрЗаменить(Строка, "0", ""));
	Возврат ПустаяСтрока(ЗначащиеСимволы);
	
КонецФункции

// Возвращает разницу между двумя датами.
// Аналогично функции языка запросов игнорирует младшие части дат,
// которые меньше, чем параметр Периодичность.
//
// Например:
//	РазностьДат('2019-12-31', '2020-01-01', Перечисления.Периодичность.Год) = 1
//	РазностьДат('2019-08-24', '2020-05-17', Перечисления.Периодичность.Месяц) = 9
//
// Параметры:
//   ДатаНачала - Дата - начальная дата периода
//   ДатаОкончания - Дата - конечная дата периода
//   Периодичность - ПеречислениеСсылка.Периодичность - вариант расчета разности дат.
//
// Возвращаемое значение:
//   Число - количество между двумя датами.
//
Функция РазностьДат(ДатаНачала, ДатаОкончания, Периодичность) Экспорт
	
	Разность = 0;
	
	День = 24 * 60 * 60; // Количество секунд в дне
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		Разность = Год(ДатаОкончания) - Год(ДатаНачала);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		Разность =
			?(Месяц(ДатаОкончания) > 6, 2, 1) - ?(Месяц(ДатаНачала) > 6, 2, 1) + 2 * (Год(ДатаОкончания) - Год(ДатаНачала));
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		Разность = Цел(Месяц(НачалоКвартала(ДатаОкончания)) / 3) - Цел(Месяц(НачалоКвартала(ДатаНачала)) / 3)
			+ 4 * (Год(ДатаОкончания) - Год(ДатаНачала));
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		Разность = Месяц(ДатаОкончания) - Месяц(ДатаНачала) + 12 * (Год(ДатаОкончания) - Год(ДатаНачала));
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		Разность = Цел((ДатаОкончания - ДатаНачала) / (10 * День));
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		Разность =
			Цел((НачалоНедели(ДатаОкончания) - НачалоНедели(ДатаНачала)) / (7 * День));
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		Разность = (ДатаОкончания - ДатаНачала) / День;
		
	КонецЕсли;
	
	Возврат Разность;
	
КонецФункции

Функция СинонимИзИмени(ИмяРеквизита) Экспорт
	
	ДопустимыеАббревиатуры = Новый Массив;
	ДопустимыеАббревиатуры.Добавить("ИНН");
	ДопустимыеАббревиатуры.Добавить("КПП");
	ДопустимыеАббревиатуры.Добавить("НДС");
	
	СловаСинонима = Новый Массив;
	
	УровниИмени = СтрРазделить(ИмяРеквизита, ".", Истина);
	Для каждого УровеньИмени Из УровниИмени Цикл
	
		ИмяВНижнемРегистре = НРег(УровеньИмени);
		
		ДлинаИмени = СтрДлина(УровеньИмени);
		НачалоСлова = 1;
		Для НомерСимвола = 2 По ДлинаИмени Цикл
			
			Если Сред(УровеньИмени, НомерСимвола, 1) = Сред(ИмяВНижнемРегистре, НомерСимвола, 1) Тогда
				Продолжить;
			КонецЕсли;
			
			Если НачалоСлова = 1 Тогда
				
				СловаСинонима.Добавить(Сред(УровеньИмени, НачалоСлова, НомерСимвола - НачалоСлова));
				
			Иначе
				
				СловоСинонима = Сред(ИмяВНижнемРегистре, НачалоСлова, НомерСимвола - НачалоСлова);
				// Аббревиатуры в синонимах полей.
				Если НомерСимвола - НачалоСлова = 1 Тогда
					
					ПроверяемыеСимволы = Сред(УровеньИмени, НомерСимвола - 2);
					Для Каждого Аббревиатура Из ДопустимыеАббревиатуры Цикл
						Если СтрНачинаетсяС(ПроверяемыеСимволы, Аббревиатура) Тогда
							СловаСинонима[СловаСинонима.ВГраница()] = Сред(ПроверяемыеСимволы, 1, СтрДлина(Аббревиатура));
							СловоСинонима = "";
							Прервать;
						КонецЕсли;
					КонецЦикла;
					
				КонецЕсли;
				Если ПустаяСтрока(СловоСинонима) Тогда
					НомерСимвола = НомерСимвола + 1;
				Иначе
					СловаСинонима.Добавить(СловоСинонима);
				КонецЕсли;

			КонецЕсли;
			НачалоСлова = НомерСимвола;
			
		КонецЦикла;
		Если НачалоСлова = 1 Тогда
			СловаСинонима.Добавить(УровеньИмени);
		Иначе
			СловаСинонима.Добавить(Сред(ИмяВНижнемРегистре, НачалоСлова));
		КонецЕсли;
		СловаСинонима.Добавить(".");
		
	КонецЦикла;
	СловаСинонима.Удалить(СловаСинонима.ВГраница());
	
	Возврат КапитализироватьСтроку(СтрСоединить(СловаСинонима, " "));
	
КонецФункции

// Возвращает количество полных (целых) лет между двумя датами.
//
// Например:
//	КоличествоЦелыхЛет('2019-12-31', '2020-01-01') = 0
//
// Параметры:
//   ДатаНачала - Дата - начальная дата периода
//   ДатаОкончания - Дата - конечная дата периода
//
// Возвращаемое значение:
//	Число - количество полных (целых) лет.
//
Функция КоличествоЦелыхЛет(ДатаНачала, ДатаОкончания) Экспорт

	Если НЕ ЗначениеЗаполнено(ДатаНачала)
		ИЛИ НЕ ЗначениеЗаполнено(ДатаОкончания)
		ИЛИ ДатаОкончания <= ДатаНачала Тогда
		Возврат 0;
	КонецЕсли;
	
	Результат = Год(ДатаОкончания) - Год(ДатаНачала);
	
	Месяц1 = Месяц(ДатаНачала);
	Месяц2 = Месяц(ДатаОкончания);
	
	Если Месяц1 > Месяц2 Тогда
		Результат = Результат - 1;
	ИначеЕсли Месяц1 = Месяц2 
		И День(ДатаНачала) > День(ДатаОкончания) Тогда
		Результат = Результат - 1;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Возвращает количество полных (целых) месяцев между двумя датами.
//
// Например:
//	КоличествоЦелыхМесяцев('2019-08-24', '2020-05-17') = 8
//
// Параметры:
//   ДатаНачала - Дата - начальная дата периода
//   ДатаОкончания - Дата - конечная дата периода
//
// Возвращаемое значение:
//	Число - количество полных (целых) месяцев.
//
Функция КоличествоЦелыхМесяцев(ДатаНачала, ДатаОкончания) Экспорт

	Если НЕ ЗначениеЗаполнено(ДатаНачала)
		ИЛИ НЕ ЗначениеЗаполнено(ДатаОкончания)
		ИЛИ ДатаОкончания <= ДатаНачала Тогда
		Возврат 0;
	КонецЕсли;

	Результат = (Год(ДатаОкончания) - Год(ДатаНачала)) * 12 + (Месяц(ДатаОкончания) - Месяц(ДатаНачала));

	Если День(ДатаНачала) > День(ДатаОкончания) Тогда
		Результат = Результат - 1;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Возвращает номер квартала, которому принадлежит переданная дата.
//
// Параметры:
//   Дата - Дата - дата, для которой необходимо вычислить номер квартала
//
// Возвращаемое значение:
//   Число - номер квартала
//
Функция НомерКвартала(Дата) Экспорт
	
	Возврат Месяц(КонецКвартала(Дата)) / 3;
	
КонецФункции

// Дополняет URL параметрами (элемент query rfc 3986)
//
// Параметры:
//  URL          - Строка - URL без элементов query и fragment (без символов ? и #)
//  ПараметрыURL - Массив - имена и значения параметров в виде "key=value".
//                          Они будут включены в URL с разделителями &
// 
// Возвращаемое значение:
//  Строка - дополненный URL
//
Функция ДополнитьURLПараметрами(URL, ПараметрыURL) Экспорт
	
	Если Не ЗначениеЗаполнено(ПараметрыURL) Тогда
		Возврат URL;
	КонецЕсли;
	
	ПараметрыURLСтрокой = СтрСоединить(ПараметрыURL, "&");
	Возврат СтрШаблон("%1?%2", URL, ПараметрыURLСтрокой);
	
КонецФункции

// Параметры UTM (Urchin Tracking Module) для материалов на its.1c.ru
// 
// Возвращаемое значение:
//  Массив из Строка - каждый элемент - имя и значение параметра, разделенные символом "="
//
Функция ИТС_ПараметрыUTM() Экспорт
	
	ПараметрыURL = Новый Массив;
	ПараметрыURL.Добавить("utm_medium=prog");
	ПараметрыURL.Добавить("utm_source=bp30");
	Возврат ПараметрыURL;
	
КонецФункции


#КонецОбласти

#Область УстаревшийПрограммныйИнтерфейс

// Устарела. Следует использовать ОбщегоНазначения.ОписаниеТипаСтрока
// Служебная функция, предназначенная для получения описания типов строки, заданной длины.
//
// Параметры:
//  ДлинаСтроки - число, длина строки.
//
// Возвращаемое значение:
//  ОписаниеТипов - для строки указанной длины.
//
Функция ПолучитьОписаниеТиповСтроки(ДлинаСтроки) Экспорт

	Массив = Новый Массив;
	Массив.Добавить(Тип("Строка"));

	КвалификаторСтроки = Новый КвалификаторыСтроки(ДлинаСтроки, ДопустимаяДлина.Переменная);

	Возврат Новый ОписаниеТипов(Массив, , КвалификаторСтроки);

КонецФункции // ПолучитьОписаниеТиповСтроки()

// Устарела. Следует использовать ОбщегоНазначения.ОписаниеТипаЧисло.
// Служебная функция, предназначенная для получения описания типов числа, заданной разрядности.
//
// Параметры:
//  Разрядность 			- число, разряд числа.
//  РазрядностьДробнойЧасти - число, разряд дробной части.
//  ЗнакЧисла				- ДопустимыйЗнак, знак числа.
//
// Возвращаемое значение:
//  ОписаниеТипов - для числа указанной разрядности.
//
Функция ПолучитьОписаниеТиповЧисла(Разрядность, РазрядностьДробнойЧасти = 0, ЗнакЧисла = Неопределено) Экспорт

	Если ЗнакЧисла = Неопределено Тогда
		КвалификаторЧисла = Новый КвалификаторыЧисла(Разрядность, РазрядностьДробнойЧасти);
	Иначе
		КвалификаторЧисла = Новый КвалификаторыЧисла(Разрядность, РазрядностьДробнойЧасти, ЗнакЧисла);
	КонецЕсли;

	Возврат Новый ОписаниеТипов("Число", КвалификаторЧисла);

КонецФункции // ПолучитьОписаниеТиповЧисла()

// Устарела. Следует использовать ОбщегоНазначения.ОписаниеТипаДата.
// Служебная функция, предназначенная для получения описания типов даты.
//
// Параметры:
//  ЧастиДаты - системное перечисление ЧастиДаты.
//
// Возвращаемое значение:
//	ОписаниеТипов - Описание типов даты.
//
Функция ПолучитьОписаниеТиповДаты(ЧастиДаты) Экспорт

	Массив = Новый Массив;
	Массив.Добавить(Тип("Дата"));

	КвалификаторДаты = Новый КвалификаторыДаты(ЧастиДаты);

	Возврат Новый ОписаниеТипов(Массив, , , КвалификаторДаты);

КонецФункции // ПолучитьОписаниеТиповДаты()

// Устарела. Следует использовать ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения
// Формирует текст сообщения, подставляя значения
// параметров в шаблоны сообщений.
//
// Параметры
//  ВидПоля       - Строка - может принимать значения:
//                  Поле, Колонка, Список.
//  ВидСообщения  - Строка - может принимать значения:
//                  Заполнение, Корректность.
//  Параметр1     - Строка - имя поля.
//  Параметр2     - Строка - номер строки.
//  Параметр3     - Строка - имя списка.
//  Параметр4     - Строка - текст сообщения о некорректности заполнения.
//
// Возвращаемое значение:
//   Строка - Текст сообщения.
//
Функция ПолучитьТекстСообщения(ВидПоля = "Поле", ВидСообщения = "Заполнение",
	Параметр1 = "", Параметр2 = "",	Параметр3 = "", Параметр4 = "") Экспорт

	ТекстСообщения = "";

	Если ВРег(ВидПоля) = "ПОЛЕ" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru = 'Поле ""%1"" не заполнено';
							|en = 'Field ""%1"" is blank'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru = 'Поле ""%1"" заполнено некорректно.
                           |
                           |%4';
                           |en = 'The ""%1"" field is populated incorrectly.
                           |
                           |%4'");
		КонецЕсли;
	ИначеЕсли ВРег(ВидПоля) = "КОЛОНКА" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""%3""';
							|en = 'Column ""%1"" in line #%2, list ""%3"" cannot be empty.'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru = 'Некорректно заполнена колонка ""%1"" в строке %2 списка ""%3"".
                           |
                           |%4';
                           |en = 'Column ""%1"" in line %2 of the ""%3"" list is filled in incorrectly.
                           |
                           |%4'");
		КонецЕсли;
	ИначеЕсли ВРег(ВидПоля) = "СПИСОК" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru = 'Не введено ни одной строки в список ""%3""';
							|en = 'The list ""%3"" is blank.'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru = 'Некорректно заполнен список ""%3"".
                           |
                           |%4';
                           |en = 'The ""%3"" list is filled in incorrectly.
                           |
                           |%4'");
		КонецЕсли;
	КонецЕсли;

	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Параметр1, Параметр2, Параметр3, Параметр4);

КонецФункции // ПолучитьТекстСообщения()

//++ НЕ УТ

// Устарела. См. ОбщегоНазначенияКлиентСервер.РаспределитьСуммуПропорциональноКоэффициентам().
// Функция выполняет пропорциональное распределение суммы в соответствии
// с заданными коэффициентами распределения.
//
// Параметры:
//		ИсхСумма - Число - Распределяемая сумма.
//		МассивКоэф - Массив - Массив коэффициентов распределения.
//		Точность - Число - Точность округления при распределении. Необязателен.
//
//	Возвращаемое значение:
//		МассивСумм - Массив - Массив размерностью равный массиву коэффициентов, содержит
//			суммы в соответствии с весом коэффициента (из массива коэффициентов)
//          В случае если распределить не удалось (сумма = 0, кол-во коэф. = 0,
//          или суммарный вес коэф. = 0), тогда возвращается значение Неопределено.
//
Функция РаспределитьПропорционально(Знач ИсхСумма, МассивКоэф, Знач Точность = 2) Экспорт

	Возврат ОбщегоНазначенияКлиентСервер.РаспределитьСуммуПропорциональноКоэффициентам(
				ИсхСумма, МассивКоэф, Точность);

КонецФункции // РаспределитьПропорционально()

//-- НЕ УТ

#КонецОбласти
