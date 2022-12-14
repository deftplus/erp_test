
////////////////////////////////////////////////////////////////////////////////
// Клиентские процедуры общего назначения

// Устарела. Следует использовать платформенный метод ПоказатьПредупреждение
Процедура ПоказатьПредупреждениеУниверсально(ТекстПредупреждения, Заголовок = Неопределено, Оповещение = Неопределено) Экспорт
		
		ПоказатьПредупреждение(Оповещение, ТекстПредупреждения, 60, Заголовок);

КонецПроцедуры

#Область Интеграция_с_БСП

// Показывает диалог выбора файлов и помещает выбранные файлы во временное хранилище.
//  Совмещает работу методов глобального метода НачатьПомещениеФайла и ПоместитьФайлы,
//  возвращая идентичный результат вне зависимости от того, подключено расширение работы с файлами, или нет.
//
// Параметры:
//   ОбработчикЗавершения  - ОписаниеОповещения - Описание процедуры, принимающей результат выбора.
//   ИдентификаторФормы    - УникальныйИдентификатор - Уникальный идентификатор формы, из которой выполняется
//                                                     размещение файла.
//   НачальноеИмяФайла     - Строка - Полный путь и имя файла, которые будут предложены пользователю в начале выбора.
//   ПараметрыДиалога      - Структура, Неопределено - См. свойства ДиалогВыбораФайла в синтакс-помощнике.
//       Используется в случае, если удалось подключить расширение работы с файлами.
//
// Значение первого параметра, возвращаемого в ОбработчикРезультата:
//   ПомещенныеФайлы - Результат выбора.
//       * - Неопределено - Пользователь отказался от выбора.
//       * - Массив из ОписаниеПереданногоФайла, Структура - Пользователь выбрал файл.
//           ** Имя      - Строка - Полное имя выбранного файла.
//           ** Хранение - Строка - Адрес во временном хранилище, по которому размещен файл.
//
// Ограничения:
//   Используется только для интерактивного выбора в диалоге.
//   Не используется для выбора каталогов - эта опция не поддерживается веб-клиентом.
//   Не поддерживается множественный выбор в веб-клиенте, если не установлено расширение работы с файлами.
//   Не поддерживается передача адреса временного хранилища.
//
Процедура ПоказатьПомещениеФайла(ОбработчикЗавершения, ИдентификаторФормы, НачальноеИмяФайла, ПараметрыДиалога) Экспорт
	
	АдресВоВременномХранилище = "";
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	Режим = РежимДиалогаВыбораФайла.Открытие;
	Диалог = Новый ДиалогВыбораФайла(Режим);
	Диалог.Заголовок = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыДиалога, "Заголовок", "");
	Диалог.Фильтр = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыДиалога, "Фильтр", "");
	ПараметрыЗагрузки.Вставить("Интерактивно", Истина);
	ПараметрыЗагрузки.Вставить("Диалог", Диалог);
	ПараметрыЗагрузки.Вставить("ИдентификаторФормы", ИдентификаторФормы);
	ФайловаяСистемаКлиент.ЗагрузитьФайл(ОбработчикЗавершения, ПараметрыЗагрузки, НачальноеИмяФайла, АдресВоВременномХранилище);	

КонецПроцедуры

// Предлагает пользователю установить расширение работы с файлами в веб-клиенте.
//
// Предназначена для использования в начале участков кода, в которых ведется работа с файлами.
// Например:
//
//    Оповещение = Новый ОписаниеОповещения("ПечатьДокументаЗавершение", ЭтотОбъект);
//    ТекстСообщения = НСтр("ru = 'Для печати документа необходимо установить расширение работы с файлами.'");
//    ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение, ТекстСообщения);
//
//    Процедура ПечатьДокументаЗавершение(РасширениеПодключено, ДополнительныеПараметры) Экспорт
//      Если РасширениеПодключено Тогда
//        // код печати документа, рассчитывающий на то, что расширение подключено.
//        // ...
//      Иначе
//        // код печати документа, который работает без подключенного расширения.
//        // ...
//      КонецЕсли;
//
// Параметры:
//   ОписаниеОповещенияОЗакрытии    - ОписаниеОповещения - описание процедуры,
//                                    которая будет вызвана после закрытия формы со следующими параметрами:
//                                      РасширениеПодключено    - Булево - Истина, если расширение было подключено.
//                                      ДополнительныеПараметры - Произвольный - параметры, заданные в
//                                                                               ОписаниеОповещенияОЗакрытии.
//   ТекстПредложения                - Строка - текст сообщения. Если не указан, то выводится текст по умолчанию.
//   ВозможноПродолжениеБезУстановки - Булево - если Истина, будет показана кнопка ПродолжитьБезУстановки,
//                                              если Ложь, будет показана кнопка Отмена.
//
Процедура ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещенияОЗакрытии, ТекстПредложения = "", 
	ВозможноПродолжениеБезУстановки = Истина) Экспорт

	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(
							ОписаниеОповещенияОЗакрытии, ТекстПредложения, ВозможноПродолжениеБезУстановки);
	
КонецПроцедуры

#КонецОбласти

#Область РедактированиеМногострочногоТекста

////////////////////////////////////////////////////////////////////////////////
// Функции для обработки действий пользователя в процессе редактирования
// многострочного текста, например комментария в документах

// Открывает форму редактирования многострочного комментария модально
//
// Параметры:
// МногострочныйТекст      - Строка - произвольный текст, который необходимо отредактировать
// РезультатРедактирования - Строка - переменная, в которую будет помещен результат редактирования
// Модифицированность       - Строка - флаг модифицированности формы
//
Процедура ОткрытьФормуРедактированияКомментария(Форма, Знач МногострочныйТекст, РезультатРедактирования,
	Модифицированность = Ложь) Экспорт
	
	ОткрытьФормуРедактированияМногострочногоТекста(Форма, МногострочныйТекст, РезультатРедактирования, Модифицированность, 
		НСтр("ru='Комментарий'"));
	
КонецПроцедуры
	
// Открывает форму редактирования произвольного многострочного текста модально
//
// Параметры:
// МногострочныйТекст      - Строка - произвольный текст, который необходимо отредактировать
// РезультатРедактирования - Строка - реквизит формы, в которую будет помещен результат редактирования
//	можно адресовать реквизиты через точку, а также обращаться к строкам коллекций через [].
//	ИСКЛЮЧЕНИЕ: "Комментарий" - всегда будет развернут в "Объект.Комментарий".
//	Примеры:
//		"ТекстКомменатрия"
//		"Объект.Комментарий"
//		"Объект.ТаблицаСКомментарием[3].Комментарий"
// Модифицированность       - Строка - флаг модифицированности формы
// Заголовок               - Строка - текст, который необходимо отобразить в заголовке формы
//
Процедура ОткрытьФормуРедактированияМногострочногоТекста(Форма, Знач МногострочныйТекст, РезультатРедактирования, Модифицированность = Ложь, 
		Знач Заголовок = Неопределено) Экспорт
	
	Заголовок = ?(Заголовок = Неопределено, "", Заголовок);
	ДопПараметры = Новый Структура("Форма,ИмяРеквизита,МногострочныйТекст", Форма, РезультатРедактирования);
	ОписаниеОповещения = Новый ОписаниеОповещения("Подключаемый_УстановитьТекст", ОбщегоНазначенияКлиентУХ, ДопПараметры);
	ПоказатьВводСтроки(ОписаниеОповещения, МногострочныйТекст, Заголовок,, Истина);
	
КонецПроцедуры

Процедура Подключаемый_УстановитьТекст(ТекстКомментария, ПараметрыОповещения = Неопределено) Экспорт

	Если ТекстКомментария = Неопределено Тогда
	    Возврат;
	КонецЕсли;
	
	РеквизитФормы = ПараметрыОповещения.Форма;
	ИмяРеквизита = ПараметрыОповещения.ИмяРеквизита;
	Если ИмяРеквизита = "Комментарий" Тогда
		ИмяРеквизита = "Объект.Комментарий";		
	КонецЕсли;
		
	ПутьКРеквизитуФормы = СтрРазделить(ИмяРеквизита, ".");
	
	Если (РеквизитФормы <> Неопределено) И Не ПустаяСтрока(ИмяРеквизита) Тогда
		
		УстановитьЗнчениеРеквизитаПоПолномуПути(РеквизитФормы, ИмяРеквизита, ТекстКомментария);
		
		Если Не ПараметрыОповещения.Форма.Модифицированность Тогда
			ПараметрыОповещения.Форма.Модифицированность = Истина;
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

// Проходит полный путь к реквизиту объекта через точки и устанавливает его в новое значение.
//
// Возвращает:
//	Неопределено - если не получилось найти реквизит.
//	ПроизвольноеЗначение - значение найднного реквизита.
//
Процедура УстановитьЗнчениеРеквизитаПоПолномуПути(Знач Объект, ПолныйПутьКРеквизиту, НовоеЗначение) Экспорт
	ОписаниеРеквизита = ПолучитьРеквизитПоПолномуПути(Объект, ПолныйПутьКРеквизиту);
	Если ОписаниеРеквизита = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОписаниеРеквизита.Объект[ОписаниеРеквизита.ИмяРеквизита] = НовоеЗначение;
КонецПроцедуры

// Проходит полный путь к реквизиту объекта через точки и возвращает его значение.
//
// Возвращает:
//	Неопределено - если не получилось найти реквизит.
//	ПроизвольноеЗначение - значение найднного реквизита.
//
Функция ПолучитьЗнчениеРеквизитаПоПолномуПути(Знач Объект, ПолныйПутьКРеквизиту) Экспорт
	ОписаниеРеквизита = ПолучитьРеквизитПоПолномуПути(Объект, ПолныйПутьКРеквизиту);
	Если ОписаниеРеквизита = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат ОписаниеРеквизита.Объект[ОписаниеРеквизита.ИмяРеквизита];		
КонецФункции

// Проходит полный путь к реквизиту объекта через точки и возвращает пару
// (Предпоследний объект в цепочке, Имя реквизита в предпоследнем объекте).
//
// Параметры:
//	Объект - любой объект 1С позволяющий обратиться к значению через [].
//	ПолныйПутьКРеквизиту - Строка, путь к реквизиту начиная но не включая Объект. Например, "НоменклатураПоставщиков.Поставщик".
//		Может включать "." (обращение к реквизиту реквизита) и "[]" (обращение к строке табличной части объекта по индексу строки).
//
// Возвращает:
//	Неопределено - если не получилось найти реквизит.
//	Структура:
//		Объект - объект содержащий реквизит.
//		ИмяРеквизита - имя реквизита для доступа в Объекте.
//
Функция ПолучитьРеквизитПоПолномуПути(Знач Объект, ПолныйПутьКРеквизиту) Экспорт
	Если Объект = Неопределено ИЛИ ПустаяСтрока(ПолныйПутьКРеквизиту) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	мПутьКРеквизиту = СтрРазделить(ПолныйПутьКРеквизиту, ".");
	КоличествоШаговВПути = мПутьКРеквизиту.Количество();
	Если КоличествоШаговВПути > 1 Тогда
		Для Индекс = 0 По КоличествоШаговВПути - 2 Цикл
			ИмяПодреквизита = мПутьКРеквизиту[Индекс];
			ИндексСкобки = СтрНайти(ИмяПодреквизита, "[");
			Если ИндексСкобки = 0 Тогда
				Объект = Объект[ИмяПодреквизита];
			Иначе
				ИмяТаблицы = Лев(ИмяПодреквизита, ИндексСкобки-1);
				ИндексСтроки = Число(Сред(ИмяПодреквизита, ИндексСкобки+1, СтрДлина(ИмяПодреквизита)-ИндексСкобки-1));
				Объект = Объект[ИмяТаблицы][ИндексСтроки];
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Новый Структура("Объект,ИмяРеквизита", Объект, мПутьКРеквизиту[КоличествоШаговВПути - 1]);		
КонецФункции


#КонецОбласти

#Область ОбработчикиСобытий


Процедура ПередНачаломРаботыСистемы() Экспорт
	
КонецПроцедуры

// Выполняется при старте системы.
Процедура ПриНачалеРаботыСистемы() Экспорт
	Если ОбщегоНазначенияУХ.ВключеныНапоминанияПользователя() Тогда
		ВключитьНапоминания();
	Иначе
		// У текущего пользователя не включены напоминания о событиях.
	КонецЕсли;
КонецПроцедуры


#КонецОбласти

// Запускает периодическую проверку напоминаний
Процедура ВключитьНапоминания() Экспорт
	РасширениеПроцессыИСогласованиеКлиентУХ.ЗапуститьПроверкуТекущихНапоминаний();	
КонецПроцедуры

// Функция ищет вхождение в переданную строку значений из списка значений
//
// Параметры
//  Строка - исходная строка для поиска
//  ПодстрокиПоиска - список значений с коллекцией подстрок для поиска
//  СтрокаПоиска - элемент, в который возвращается найденное значение строки подпоиска
//
// Возвращаемое значение:
//  Наименьшая позиция найденного значения
//
Функция ПоискПервойПодстроки(Строка,ПодстрокиПоиска,СтрокаПоиска)
	
	Результат = 0;
	
	Для каждого Подстрока из ПодстрокиПоиска Цикл
		Нашли = СтрНайти(Строка,Подстрока.Значение);
		Если Нашли > 0 Тогда
			Если Результат=0 ИЛИ Нашли < Результат Тогда
				Результат = Нашли;
				СтрокаПоиска = Подстрока.Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Функция возвращает по переданному тексту строку
// в формате HTML с выделенными ссылками на ресурсы www
//
// Параметры
//  ТекстПисьма - текстовая строка
//
// Возвращаемое значение:
//  Текст в формате HTML
//
Функция ВернутьТекстПисьмаВФорматеHTML(ТекстПисьма) Экспорт
	Перем СтрокаПоиска;
	
	Текст = ТекстПисьма;
	ТекстПоиска = Текст;
	
	СмещениеВТексте = 0;
	
	ПодстрокиПоиска = Новый СписокЗначений;
	ПодстрокиПоиска.Добавить("http://");
	ПодстрокиПоиска.Добавить("www.");
	ПодстрокиПоиска.Добавить("mailto:");

	ПозицияПризнакаСсылки = ПоискПервойПодстроки(ТекстПоиска,ПодстрокиПоиска,СтрокаПоиска);

	// пробежимся по всем найденным ссылкам
	Пока ПозицияПризнакаСсылки>0 Цикл
		
		НачалоСсылки = ПозицияПризнакаСсылки;
		
		// найдем последний символ ссылки
		КонецСсылки = НачалоСсылки+СтрДлина(СтрокаПоиска)-1;
		Для а=КонецСсылки+1 по СтрДлина(ТекстПоиска) Цикл
			ТекСимвол = Сред(ТекстПоиска,а,1);
			Если КодСимвола(ТекСимвол) < 33 ИЛИ КодСимвола(ТекСимвол)>127 ИЛИ КодСимвола(ТекСимвол)=91 ИЛИ КодСимвола(ТекСимвол)=93 Тогда
				Прервать;
			КонецЕсли;
			КонецСсылки = а;
		КонецЦикла;
		
		Если КонецСсылки > НачалоСсылки+СтрДлина(СтрокаПоиска)-1 Тогда
			
			ТекстСсылки   = Сред(ТекстПоиска,НачалоСсылки,КонецСсылки-НачалоСсылки+1);
			ТекстСсылкиHTML = "<a href="""+?(СтрокаПоиска="www.","http://","")+ТекстСсылки+""">"+ТекстСсылки+"</a>";
			
			ТекстДоСсылки = Лев(Текст,НачалоСсылки+СмещениеВТексте-1);
			ТекстПослеСсылки = Прав(Текст,СтрДлина(Текст)-(КонецСсылки+СмещениеВТексте));
			
			Текст = ТекстДоСсылки + ТекстСсылкиHTML + ТекстПослеСсылки;
			
			СмещениеВТексте = СмещениеВТексте + КонецСсылки + (СтрДлина(ТекстСсылкиHTML)-СтрДлина(ТекстСсылки));

		Иначе
			
			СмещениеВТексте = СмещениеВТексте + КонецСсылки;
			
		КонецЕсли;
		
		ТекстПоиска = Прав(ТекстПоиска,СтрДлина(ТекстПоиска)-КонецСсылки);
		
		ПозицияПризнакаСсылки = ПоискПервойПодстроки(ТекстПоиска,ПодстрокиПоиска,СтрокаПоиска);
		
	КонецЦикла;
	
	Текст = СтрЗаменить(Текст, Символы.ПС, "<BR>");
	
	ТекстВформатеHTML = "<HTML>        
	|<HEAD>
	|<META http-equiv=Content-Type content=""text/html; charset=utf-8"">
	|<META content=""MSHTML 6.00.2800.1400"" name=GENERATOR>
	|<STYLE>
	|body
	|{
	|	font-size:15px;
	|	font-family:Arial,Helvetica,Sans-Serif;
	|}
	|a
	|{	
	|	font-size:15px;
	|	font-family:Arial,Helvetica,Sans-Serif;
	|}
	|</STYLE>
	|</HEAD>
	|<BODY scroll=""auto"">" + Текст + "</BODY>
	|</HTML>";
	Возврат ТекстВформатеHTML;
	
КонецФункции
