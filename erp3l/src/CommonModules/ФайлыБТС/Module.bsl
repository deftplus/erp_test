#Область СлужебныйПрограммныйИнтерфейс

// Возвращает общий каталог временных файлов, который доступен между сеансами.
//
// Возвращаемое значение:
//   Строка - полный путь к каталогу.
//
Функция ОбщийКаталогВременныхФайлов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначения.ЭтоLinuxСервер() Тогда
		ОбщийВременныйКаталог = Константы.КаталогОбменаФайламиВМоделиСервисаLinux.Получить();
	Иначе
		ОбщийВременныйКаталог = Константы.КаталогОбменаФайламиВМоделиСервиса.Получить();
	КонецЕсли;
	
	Если ПустаяСтрока(ОбщийВременныйКаталог) Тогда
		ОбщийВременныйКаталог = СокрЛП(КаталогВременныхФайлов());
	Иначе
		ОбщийВременныйКаталог = СокрЛП(ОбщийВременныйКаталог);
	КонецЕсли;
	
	Если Не СтрЗаканчиваетсяНа(ОбщийВременныйКаталог, ПолучитьРазделительПути()) Тогда
		ОбщийВременныйКаталог = ОбщийВременныйКаталог + ПолучитьРазделительПути();
	КонецЕсли;
	
	Возврат ОбщийВременныйКаталог;
	
КонецФункции

// Имя временного файла в общем каталоге.
// 
// Параметры: 
//  Расширение - Строка - Расширение
// 
// Возвращаемое значение: 
//  Строка - имя временного файла в общем каталоге.
Функция ИмяВременногоФайлаВОбщемКаталоге(Знач Расширение = Неопределено) Экспорт
	
	КаталогВременныхФайлов = ОбщийКаталогВременныхФайлов();
	
	Если НРег(КаталогВременныхФайлов) = НРег(КаталогВременныхФайлов()) Тогда
		Возврат ПолучитьИмяВременногоФайла(Расширение);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Расширение) Тогда
		Расширение = ".tmp";
	ИначеЕсли НЕ СтрНачинаетсяС(Расширение, ".") Тогда
		Расширение = "." + Расширение;
	КонецЕсли;
	
	Возврат КаталогВременныхФайлов + Строка(Новый УникальныйИдентификатор()) + Расширение;
	
КонецФункции

// Параметры:
// 	Расширение - Неопределено, Строка - расширение файла.
// 	
// Возвращаемое значение:
// 	Структура:
// 	* Имя - Строка 
// 	* ПутьWindows - Строка
// 	* ПутьLinux - Строка
// 
Функция СвойстваНовогоВременногоФайла(Знач Расширение = Неопределено) Экспорт
	
	Результат = Новый Структура("Имя, ПутьWindows, ПутьLinux");
	
	ОбъектФС = Новый Файл(ИмяВременногоФайлаВОбщемКаталоге(Расширение));
	Результат.Имя = ОбъектФС.Имя;
	
	ЭтоLinux = ОбщегоНазначения.ЭтоLinuxСервер();
	Результат.ПутьWindows = КаталогОбменаИзКонстанты(Метаданные.Константы.КаталогОбменаФайламиВМоделиСервиса.Имя, НЕ ЭтоLinux, "\");
	Результат.ПутьLinux = КаталогОбменаИзКонстанты(Метаданные.Константы.КаталогОбменаФайламиВМоделиСервисаLinux.Имя, ЭтоLinux, "/");
	
	Возврат Результат;
	
КонецФункции

// Полное имя файла в сеансе.
// 
// Параметры: 
//  Имя - Строка
//  ПутьWindows - Строка
//  ПутьLinux - Строка
// 
// Возвращаемое значение: 
//  Строка - полное имя файла в сеансе.
Функция ПолноеИмяФайлаВСеансе(Имя, ПутьWindows, ПутьLinux) Экспорт
	
	Если ОбщегоНазначения.ЭтоLinuxСервер() Тогда
		Путь = ПутьLinux;
	Иначе
		Путь = ПутьWindows;
	КонецЕсли;
	
	Если ПустаяСтрока(Путь) Тогда
		Путь = КаталогВременныхФайлов();
	КонецЕсли;
	
	Разделитель = ПолучитьРазделительПути();
	Если Не СтрЗаканчиваетсяНа(Путь, Разделитель) Тогда
		Путь = Путь + Разделитель;
	КонецЕсли;
	
	Возврат Путь + Имя;
	
КонецФункции

Процедура УдалитьФайлыВПопытке(ИмяФайла, ИмяСобытияЖР = Неопределено) Экспорт
	
	Попытка
		
		УдалитьФайлы(ИмяФайла);
		
	Исключение
		
		Если ИмяСобытияЖР = Неопределено Тогда
			ИмяСобытияЖР = НСтр("ru = 'Удаление файла';
								|en = 'Deleteing file'", ОбщегоНазначения.КодОсновногоЯзыка());
		КонецЕсли;
		КомментарийСобытияЖР = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР, УровеньЖурналаРегистрации.Ошибка, , , КомментарийСобытияЖР);
		
	КонецПопытки;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КаталогОбменаИзКонстанты(ИмяКонстанты, ПоУмолчаниюКаталогВременныхФайлов, Разделитель)

	УстановитьПривилегированныйРежим(Истина);
	КаталогОбмена = СокрЛП(Константы[ИмяКонстанты].Получить());
	
	Если ПустаяСтрока(КаталогОбмена) И ПоУмолчаниюКаталогВременныхФайлов Тогда
		КаталогОбмена = КаталогВременныхФайлов();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КаталогОбмена) И Не СтрЗаканчиваетсяНа(КаталогОбмена, Разделитель) Тогда
		КаталогОбмена = КаталогОбмена + Разделитель;
	КонецЕсли;
	
	Возврат КаталогОбмена;

КонецФункции

#КонецОбласти