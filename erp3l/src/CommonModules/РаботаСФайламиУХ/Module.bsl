///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ МЕХАНИЗМА РАБОТЫ С ФАЙЛАМИ (ХРАНИМЫМИ В КОНФИГУРАЦИИ)
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

// Составляет полное имя файла из имени каталога и имени файла.
//
// Параметры
//  ИмяКаталога  – Строка, содержащая путь к каталогу файла на диске.
//  ИмяФайла     – Строка, содержащая имя файла, без имени каталога.
//
// Возвращаемое значение:
//   Строка – полное имя файла с учетом каталога.
//
Функция ПолучитьИмяФайла(ИмяКаталога, ИмяФайла) Экспорт

	Если Не ПустаяСтрока(ИмяФайла) Тогда
		
		Возврат ИмяКаталога + ?(Прав(ИмяКаталога, 1) = "\", "", "\") + ИмяФайла;	
		
	Иначе
		
		Возврат ИмяКаталога;
		
	КонецЕсли;

КонецФункции // ПолучитьИмяФайла()

// Процедура полное имя файла разбивает на путь в файлу и имя самого файла
//
// Параметры
//  ПолноеИмяФайла  – Строка, содержащая полное имя файла на диске.
//  ИмяКаталога  – Строка, содержащая путь к каталогу файла на диске.
//  ИмяФайла     – Строка, содержащая имя файла, без имени каталога.
//
Процедура ПолучитьКаталогИИмяФайла(Знач ПолноеИмяФайла, ИмяКаталога, ИмяФайла) Экспорт
	
	// находим последний с конца "\" все что до него - это путь, после - имя
	НомерПозиции = СтрДлина(ПолноеИмяФайла);
	Пока НомерПозиции <> 0 Цикл
		
		Если Сред(ПолноеИмяФайла, НомерПозиции, 1) = "\" Тогда
			
			ИмяКаталога = Сред(ПолноеИмяФайла, 1, НомерПозиции - 1);
			ИмяФайла = Сред(ПолноеИмяФайла, НомерПозиции + 1);
			Возврат;
			
		КонецЕсли;
		
		НомерПозиции = НомерПозиции - 1;
		
	КонецЦикла;
	
	// так и не нашли слешей, значит все- это имя файла
	ИмяФайла = ПолноеИмяФайла;
	ИмяКаталога = "";
	
КонецПроцедуры

// Процедура меняет расширение имени переданного файла (сам файл не меняется, меняется колько строка)
//
// Параметры
//  ИмяФайла  – Строка, содержащая полное имя файла на диске.
//  НовоеРасширениеФайла  – Строка, содержащая новое расширение файла.
//
Процедура УстановитьРасширениеФайла(ИмяФайла, Знач НовоеРасширениеФайла) Экспорт
	
	// к расширению точку добавляем
	Если Сред(НовоеРасширениеФайла, 1, 1) <> "." Тогда
		ЗначениеНовогоРасширения = "." + НовоеРасширениеФайла;	
	Иначе
		ЗначениеНовогоРасширения = НовоеРасширениеФайла;	
	КонецЕсли;
	// если не находим точку в текущем имени файла, то просто приписываем к нему новое расширение с конца
	ПозицияТочки = СтрДлина(ИмяФайла);
	Пока ПозицияТочки >= 1 Цикл
		
		Если Сред(ИмяФайла, ПозицияТочки, 1) = "." Тогда
						
			ИмяФайла = Сред(ИмяФайла, 1, ПозицияТочки - 1) + ЗначениеНовогоРасширения;
			Возврат; 
			
		КонецЕсли;
		
		ПозицияТочки = ПозицияТочки - 1;	
	КонецЦикла;
	
	// не нашли точку в имени файла
	ИмяФайла = ИмяФайла + ЗначениеНовогоРасширения;	
	
КонецПроцедуры

// Функция определяет дату последней модификации существующего файла на диске
// Параметры
//  ИмяФайла  – Строка, содержащая полный путь к файла на диске.
//
// Возвращаемое значение:
//   Дата – Дата последней модификации файла
//
Функция ПолучитьДатуФайла(Знач ИмяФайла) Экспорт
	
	Файл = Новый Файл(ИмяФайла);
	Возврат Файл.ПолучитьВремяИзменения();
	
КонецФункции

// Формирует строку фильтра для диалога выбора файла с типами файлов.
//
// Параметры
//  Нет.
//
// Возвращаемое значение:
//   Строка – фильтр по типам файлов для диалога выбора файла.
//
Функция ПолучитьФильтрФайлов()

	СтрокаФильтра = НСтр("ru = 'Все файлы (*.*)|*.*|
                         |	      Документ Microsoft Word (*.doc)|*.doc|
                         |	      Документ Microsoft Excell (*.xls)|*.xls|
                         |	      Документ Microsoft PowerPoint (*.ppt)|*.ppt|
                         |	      Документ Microsoft Visio (*.vsd)|*.vsd|
                         |	      Письмо электронной почты (*.msg)|*.msg|
                         |	      Картинки (*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf)|*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf|
                         |	      Текстовый документ (*.txt)|*.txt|
                         |	      Табличный документ (*.mxl)|*.mxl|'");
	Возврат СтрокаФильтра;

КонецФункции // ПолучитьФильтрФайлов()

// Формирует имя каталога для сохранения/чтения файлов. Для различных типов объектов возможны 
// различные алгоритмы определения каталога.
//
// Параметры
//  ОбъектФайла  – Ссылка на объект данных, для которого прикрепляются файлы.
//
// Возвращаемое значение:
//   Строка – каталог файлов для указанного объекта и пользователя.
//
Функция ПолучитьИмяКаталога() Экспорт

	//// Получим рабочий каталог из свойств пользователя.
	//РабочийКаталог = УправлениеПользователямиУХ.ПолучитьЗначениеПоУмолчанию(ОбщегоНазначенияУХ.ПолучитьЗначениеПеременной("глТекущийПользователь"), "ОсновнойКаталогФайлов");

	//// Если рабочий каталог не указан получим каталог временных файлов прогаммы
	//Если ПустаяСтрока(РабочийКаталог) Тогда
		РабочийКаталог = КаталогВременныхФайлов();
	//КонецЕсли;

	// Так как при различных указаниях рабочего каталога возможно наличие или отсутствие
	// последнего слеша, приведем строку каталога к унифицированному виду - без слеша на конце.
	Если Прав(РабочийКаталог, 1) = "\" Тогда
		РабочийКаталог = Лев(РабочийКаталог, СтрДлина(РабочийКаталог) - 1);
	КонецЕсли;

	Возврат РабочийКаталог;

КонецФункции // ПолучитьИмяКаталога()

// функция возвращает список запрещенных символов в именах файлов
// Возвращаемое значение:
//   Список значений в котором хранится список всех запрещенных символов в именах файлов.
//
Функция ПолучитьСписокЗапрещенныхСимволовВИменахФайлов()
	
	СписокСимволов = Новый СписокЗначений();
	
	СписокСимволов.Добавить("\");
	СписокСимволов.Добавить("/");
	СписокСимволов.Добавить(":");
	СписокСимволов.Добавить("*");
	СписокСимволов.Добавить("&");
	СписокСимволов.Добавить("""");
	СписокСимволов.Добавить("<");
	СписокСимволов.Добавить(">");
	СписокСимволов.Добавить("|");
	
	Возврат СписокСимволов;
	
КонецФункции

// функция формирует имя файла выбрасывая из первоначально предложенного имени все
// запрещенные символы
// Параметры
//  ИмяФайла     – Строка, содержащая имя файла, без каталога.
//
// Возвращаемое значение:
//   Строка – имя файла, которое может быть использовано в файловой системе
//
Функция УдалитьЗапрещенныеСимволыИмени(Знач ИмяФайла) Экспорт

	ИтоговоеИмяФайла = СокрЛП(ИмяФайла);
	
	Если ПустаяСтрока(ИтоговоеИмяФайла) Тогда
		
		Возврат ИтоговоеИмяФайла;
		
	КонецЕсли;
	
	СписокСимволов = ПолучитьСписокЗапрещенныхСимволовВИменахФайлов();
	
	Для Каждого СтрокаЗапретногоСимвола  Из СписокСимволов Цикл
		
		ИтоговоеИмяФайла = СтрЗаменить(ИтоговоеИмяФайла,  СтрокаЗапретногоСимвола.Значение, "");			
		
	КонецЦикла;
	
	Возврат ИтоговоеИмяФайла;

КонецФункции // УдалитьЗапрещенныеСимволыИмени()

// Выделяет из имени файла его расширение (набор символов после последней точки).
//
// Параметры
//  ИмяФайла     – Строка, содержащая имя файла, неважно с именем каталога или без.
//
// Возвращаемое значение:
//   Строка – расширение файла.
//
Функция ПолучитьРасширениеФайла(Знач ИмяФайла) Экспорт
	
	Расширение = ПолучитьЧастьСтрокиОтделеннойСимволом(ИмяФайла, ".");
	Возврат Расширение;
	
КонецФункции

// Выделяет из полного пути к файлу его имя (набор символов после последней \).
//
// Параметры
//  ПутьКФайлу     – Строка, содержащая имя файла, неважно с именем каталога или без.
//
// Возвращаемое значение:
//   Строка – расширение файла.
//
Функция ПолучитьИмяФайлаИзПолногоПути(Знач ПутьКФайлу) Экспорт
	
	ИмяФайла = ПолучитьЧастьСтрокиОтделеннойСимволом(ПутьКФайлу, "\");
	Возврат ИмяФайла;
	
КонецФункции

// функция возвращает часть строки после последнего встреченного символа в строке
Функция ПолучитьЧастьСтрокиОтделеннойСимволом(Знач ИсходнаяСтрока, Знач СимволПоиска)
	
	ПозицияСимвола = СтрДлина(ИсходнаяСтрока);
	Пока ПозицияСимвола >= 1 Цикл
		
		Если Сред(ИсходнаяСтрока, ПозицияСимвола, 1) = СимволПоиска Тогда
						
			Возврат Сред(ИсходнаяСтрока, ПозицияСимвола + 1); 
			
		КонецЕсли;
		
		ПозицияСимвола = ПозицияСимвола - 1;	
	КонецЦикла;

	Возврат "";
  	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ДЛЯ ВЕБ-ПРИЛОЖЕНИЯ
///////////////////////////////////////////////////////////////////////////////

// КоличествоПопыток - 0 - удалять пока не удалятся
Функция УдалитьФайлыАсинхронно(Путь, Маска = Неопределено, КоличествоПопыток = 10) Экспорт
	
	ПРОТОКОЛИРУЕМОЕ_СОБЫТИЕ = "ОбщийМодуль.РаботаСФайламиУХ.УдалитьФайлыАсинхронно";
	
	КлючЗадания = Строка(Новый УникальныйИдентификатор());
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить(Путь);
	ПараметрыЗадания.Добавить(Маска);
	ПараметрыЗадания.Добавить(КоличествоПопыток);
	ПараметрыЗадания.Добавить(КлючЗадания);

	Попытка
		ФоновыеЗадания.Выполнить("РаботаСФайламиУХ.ВыполнитьУдалениеФайлов", ПараметрыЗадания, КлючЗадания);
	Исключение
		Попытка
			УдалитьФайлы(Путь, Маска);
		Исключение
			ТекстСобытия = НСтр("ru = 'Не удалось удалить файл(ы)'");
			ПротоколируемыеСобытияУХ.ДобавитьЗаписьПримечание(ПРОТОКОЛИРУЕМОЕ_СОБЫТИЕ,,, ТекстСобытия , Новый Структура("Путь,Маска", Путь, Маска));
		КонецПопытки;
	КонецПопытки;
	
КонецФункции

#Если Сервер Тогда

// Предполагается, что вызывается только как фоновое задание
Процедура ВыполнитьУдалениеФайлов(Путь, Маска, КоличествоПопыток, КлючЗадания) Экспорт
	
	ТипРегламентноеЗадание = Новый ОписаниеТипов("РегламентноеЗадание");
	
	М = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Ключ,Состояние,РегламентноеЗадание", КлючЗадания, СостояниеФоновогоЗадания.Активно, ТипРегламентноеЗадание.ПривестиЗначение(Неопределено)));
	Если НЕ М.Количество() = 1 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущееЗадание = М[0];
	
	НомерПопытки = 1;
	
	Пока Истина Цикл
		
		Если КоличествоПопыток > 0 Тогда
			Если НомерПопытки > КоличествоПопыток Тогда
				Возврат;
			КонецЕсли;
			НомерПопытки = НомерПопытки + 1;
		КонецЕсли;
		
		Попытка
			УдалитьФайлы(Путь, Маска);
		Исключение
		КонецПопытки;
		
		Возврат;

		Попытка
			ТекущееЗадание.ОжидатьЗавершения(1);
		Исключение
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли

// Копирует файл Источник в файл Приемник с перезаписью. Если Приемник уже существует,
// то он будет перезаписан, если не существует - то создан.
// Параметры
//  Источник - Строка - Обязательный - путь к файлу, который необходимо скопировать
//  Приемник - Строка - Обязательный - путь к файлу, в который необходимо скопировать
// Возвращаемое значение
//  Истина, если копирование удалось, Ложь - иначе.
Функция СкопироватьФайл(Источник, Приемник) Экспорт
	
	ПРОТОКОЛИРУЕМОЕ_СОБЫТИЕ = "ОбщийМодуль.РаботаСФайламиУХ.СкопироватьФайл";
	
	Файл = Новый Файл(Источник);
	
	Если НЕ Файл.Существует() Тогда
		ТекстСообщения = НСтр("ru = 'Файл %Источник% не найден.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Источник%", Строка(Источник));
		ПротоколируемыеСобытияУХ.ДобавитьЗаписьПримечание(ПРОТОКОЛИРУЕМОЕ_СОБЫТИЕ,,, ТекстСообщения, Источник);
		Возврат Ложь;
	ИначеЕсли Файл.ЭтоКаталог() Тогда
		ТекстСообщения = НСтр("ru = 'Путь %Источник% не является путем к файлу.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Источник%", Строка(Источник));	
		ПротоколируемыеСобытияУХ.ДобавитьЗаписьПримечание(ПРОТОКОЛИРУЕМОЕ_СОБЫТИЕ,,, "Путь " + Источник + " не является путем к файлу.", Источник);
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		Scripting_FileSystemObject = Новый COMОбъект("Scripting.FileSystemObject");
		Scripting_FileSystemObject.CopyFile(Источник, Приемник);
	Исключение
		ТекстСообщения = НСтр("ru = 'При копировании файла из %Источник% в %Приемник%. произошла ошибка.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Источник%", Строка(Источник));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Приемник%", Строка(Приемник));
		ПротоколируемыеСобытияУХ.ДобавитьЗаписьПримечание(ПРОТОКОЛИРУЕМОЕ_СОБЫТИЕ,,, ТекстСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;
	КонецПопытки;
		
	Возврат Истина;
	
КонецФункции

// Помещает файл во временное хранилище.
// Параметры
//  ПутьКФайлу - Строка - Обязательный - путь к файлу, который необходимо поместить в хранилище
//  Адрес - Строка - Необязательный - адрес хранилища, по которому поместить файл
// Возвращаемое значение
//  Адрес хранилища, если удалось поместить файл, Неопределено - иначе.
Функция ПоместитьФайлВоВременноеХарнилище(ПутьКФайлу, Знач Адрес = Неопределено) Экспорт
	
	ПРОТОКОЛИРУЕМОЕ_СОБЫТИЕ = "ОбщийМодуль.РаботаСФайламиУХ.ПоместитьФайлВоВременноеХарнилище";
	
	Если Адрес = Неопределено Тогда
		Адрес = ПоместитьВоВременноеХранилище(Неопределено);
	ИначеЕсли НЕ ЭтоАдресВременногоХранилища(Адрес) Тогда
		ТекстСообщения = НСтр("ru = 'Переданный адрес не является адресом временного хранилища.'");
		ПротоколируемыеСобытияУХ.ДобавитьЗаписьПримечание(ПРОТОКОЛИРУЕМОЕ_СОБЫТИЕ,,, ТекстСообщения, Адрес);
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	
	Если НЕ СкопироватьФайл(ПутьКФайлу, ИмяВременногоФайла) Тогда
		ТекстСообщения = НСтр("ru = 'Не удалось скопировать файл.'");
		ПротоколируемыеСобытияУХ.ДобавитьЗаписьПримечание(ПРОТОКОЛИРУЕМОЕ_СОБЫТИЕ,,, ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		Адрес = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяВременногоФайла), Адрес);
	Исключение
		ПротоколируемыеСобытияУХ.ДобавитьЗаписьПримечание(ПРОТОКОЛИРУЕМОЕ_СОБЫТИЕ,,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Адрес = Неопределено;
	КонецПопытки;
	
	УдалитьФайлыАсинхронно(ИмяВременногоФайла);
	
	Возврат Адрес;
	
КонецФункции
