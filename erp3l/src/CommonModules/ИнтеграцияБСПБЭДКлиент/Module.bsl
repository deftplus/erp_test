
#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму редактирования адреса
// 
// Параметры:
// 	ПредставлениеАдреса - Строка - представление адреса.
// 	ЗначениеПолейАдреса - Строка - строка JSON или XML контактной информации, соответствующая XDTO-пакету КонтактнаяИнформация.
// 	Оповещение - ОписаниеОповещения - обработчик оповещения, который будет вызван после закрытия формы.
Процедура НачатьРедактированиеАдреса(ПредставлениеАдреса, ЗначениеПолейАдреса = "",
	Оповещение = Неопределено) Экспорт
	
	ТипАдрес = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес");
	
	ДанныеКонтактнойИнформации = ИнтеграцияБСПБЭДСлужебныйВызовСервера.ДанныеКонтактнойИнформацииПоПредставлению(
		ПредставлениеАдреса, ТипАдрес);
	
	Если ЗначениеПолейАдреса = "" Тогда
		ЗначениеПолейАдреса = ДанныеКонтактнойИнформации.Значение;
	КонецЕсли;
	
	ДанныеКонтактнойИнформации.ПараметрыВида.РедактированиеТолькоВДиалоге = Истина;
	ДанныеКонтактнойИнформации.ПараметрыВида.ОбязательноеЗаполнение = Истина;
	ДанныеКонтактнойИнформации.ПараметрыВида.Наименование = НСтр("ru = 'Юридический адрес организации';
																|en = 'Company legal address'");
	ДанныеКонтактнойИнформации.ПараметрыВида.НастройкиПроверки.ПроверятьКорректность = Ложь;
	
	ПараметрыОткрытия = УправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
		ДанныеКонтактнойИнформации.ПараметрыВида, ЗначениеПолейАдреса, ПредставлениеАдреса,, ТипАдрес);
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, , Оповещение);
	
КонецПроцедуры

// Открывает переданный сертификат на просмотр.
// 
// Параметры:
// 	АдресДанныхСертификата - адрес во временном хранилища, в котором лежит сертификат.
Процедура ПоказатьСертификат(АдресДанныхСертификата) Экспорт
	
	СтруктураСертификата = ИнтеграцияБСПБЭДСлужебныйВызовСервера.СвойстваСертификата(АдресДанныхСертификата);
	
	Если СтруктураСертификата <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("СтруктураСертификата, Отпечаток, АдресСертификата",
			СтруктураСертификата, СтруктураСертификата.Отпечаток, АдресДанныхСертификата);
		ОткрытьФорму("ОбщаяФорма.Сертификат", ПараметрыФормы);
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Сертификат не найден';
														|en = 'Certificate is not found'"));
	КонецЕсли;
	
КонецПроцедуры

// Возвращает имя события, по которому БСП оповещает о записи сертификата.
// 
// Возвращаемое значение:
// 	Строка - имя события.
Функция ИмяСобытияЗаписьСертификата() Экспорт
	
	Возврат "Запись_СертификатыКлючейЭлектроннойПодписиИШифрования";
	
КонецФункции

Процедура ПодключитьОбсуждения(ОписаниеЗавершения) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеЗавершения", ОписаниеЗавершения);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПодключенияОбсуждений", ИнтеграцияБСПБЭДСлужебныйКлиент, ДополнительныеПараметры);
	
	МодульОбсужденияСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбсужденияСлужебныйКлиент");
	МодульОбсужденияСлужебныйКлиент.ПоказатьПодключение(ОписаниеОповещения);
	
КонецПроцедуры

// Конструктор параметров для метода см. ОткрытьФормуВыбораФайловИзОбщегоХранилища
// 
// Возвращаемое значение:
// 	Структура - имя события:
//	* ЗакрыватьПриВыборе - Булево - признак закрытия формы после выбора файла.
//	* МножественныйВыбор - Булево - признак доступности множественного выбора файла.
//	
Функция НовыеПараметрыВыбораФайловИзОбщегоХранилища() экспорт

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор", Ложь);
	
	Возврат ПараметрыФормы;
	
КонецФункции

// Открывает форму выбора файлов из общего хранилища.
// 
// Параметры:
// 	Параметры - См. НовыеПараметрыВыбораФайловИзОбщегоХранилища
// 	Оповещение - обработчик оповещения, который будет вызван после выбора файлов. В качестве результата может быть передано:
// 	  * Неопределено - пользователь отказался от выбора
// 	  * СправочникСсылка.Файлы - ссылка на выбранный файл
// 	  * Массив - массив из выбранных файлов в случае множественного выбора.
//
Процедура ОткрытьФормуВыбораФайловИзОбщегоХранилища(Параметры, Оповещение) Экспорт
	
	ТекстПредупреждения = "";
	Если НЕ ИнтеграцияБСПБЭДСлужебныйВызовСервера.ЕстьДоступКХранилищуФайлов(ТекстПредупреждения) Тогда
		ПоказатьПредупреждение( ,ТекстПредупреждения);
		Возврат;
	КонецЕсли;

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Параметры.ЗакрыватьПриВыборе);
	ПараметрыФормы.Вставить("МножественныйВыбор", Параметры.МножественныйВыбор);
		
	ОткрытьФорму("Справочник.Файлы.ФормаВыбора", ПараметрыФормы,,,,, Оповещение);
	
КонецПроцедуры

#Область ЭлектроннаяПодпись

// Предлагает пользователю выбрать подписи для сохранения вместе с данными объекта.
//
// Общий подход к обработке значений свойств с типом ОписаниеОповещения в параметре ОписаниеДанных.
//  При выполнении обработки оповещения в нее передается структура параметров, в которой всегда есть
//  свойство "Оповещение" типа ОписаниеОповещения, обработку которого нужно выполнить для продолжения.
//  Кроме того, в структуре всегда есть свойство ОписаниеДанных, полученное при вызове процедуры.
//  При вызове оповещения в качестве значения должна передаваться структура. Если в процессе асинхронного
//  выполнения возникает ошибка, тогда в эту структуру нужно вставить свойство ОписаниеОшибки типа Строка.
// 
// Параметры:
//  ОписаниеДанных - Структура:
//    * ЗаголовокДанных     - Строка - заголовок элемента данных, например Файл.
//    * ПоказатьКомментарий - Булево - (необязательный) - разрешает ввод комментария в форме
//                              добавления подписей. Если не указан, значит Ложь.
//    * Представление      - Ссылка
//                         - Строка - (необязательный), если не указан, тогда
//                                представление вычисляется по значению свойства Объект.
//    * Объект             - Ссылка - ссылка на объект с табличной частью ЭлектронныеПодписи,
//                              из которой нужно получить список подписей.
//    * --// --             - Строка - адрес временного хранилища массива подписей с составом свойств,
//                              как возвращает процедура ДобавитьПодписьИзФайла.
//    * Данные             - ОписаниеОповещения - обработчик сохранения данных и получения полного имени
//                              файла с путем (после его сохранения), возвращаемое в свойстве ПолноеИмяФайла
//                              типа Строка для сохранения электронных подписей (см. выше общий подход).
//                              Если расширение для работы с файлами не подключено, то нужно вернуть
//                              имя файла без пути.
//                              Если свойство не будет вставлено или заполнено - это считается отказом
//                              от продолжения и будет вызвана ОбработкаРезультата с результатом Ложь.
//
//                              Для пакетного запроса разрешений у пользователя веб-клиента на сохранение файла данных
//                              и подписей, нужно вставить параметр ОбработкаЗапросаРазрешений типа ОписаниеОповещения.
//                              В процедуру будет передана Структура с параметрами:
//                              * Вызовы               - Массив - с описанием вызовов для сохранения подписей.
//                              * ОбработкаПродолжения - ОписаниеОповещения - оповещение, которое нужно выполнить
//                                                       после запроса разрешений, - параметры процедуры как у
//                                                       оповещения для метода НачатьЗапросРазрешенияПользователя.
//                                                       Если разрешение не получено, значит все отменено.
//
//  ОбработкаРезультата - ОписаниеОповещения - необязательный параметр.
//     В результат передается параметр:
//     * Булево - Истина, если все прошло успешно.
//
Процедура СохранитьДанныеВместеСПодписью(ОписаниеДанных, ОбработкаРезультата = Неопределено) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОписаниеДанных", ОписаниеДанных);
	Контекст.Вставить("ОбработкаРезультата", ОбработкаРезультата);
	
	ПерсональныеНастройки = ЭлектроннаяПодписьКлиент.ПерсональныеНастройки();
	СохранятьВсеПодписи = ПерсональныеНастройки.ДействияПриСохраненииСЭП = "СохранятьВсеПодписи";
	СохранятьСертификатВместеСПодписью = ПерсональныеНастройки.СохранятьСертификатВместеСПодписью;
	
	СерверныеПараметры = Новый Структура;
	СерверныеПараметры.Вставить("ЗаголовокДанных",     НСтр("ru = 'Данные';
															|en = 'Data'"));
	СерверныеПараметры.Вставить("ПоказатьКомментарий", Ложь);
	ЗаполнитьЗначенияСвойств(СерверныеПараметры, ОписаниеДанных);
	
	Контекст.Вставить("СохранятьСертификатВместеСПодписью", СохранятьСертификатВместеСПодписью);
	
	СерверныеПараметры.Вставить("СохранятьВсеПодписи", СохранятьВсеПодписи);
	СерверныеПараметры.Вставить("Объект", ОписаниеДанных.Объект);
	
	КлиентскиеПараметры = Новый Структура;
	КлиентскиеПараметры.Вставить("ОписаниеДанных", ОписаниеДанных);
	ЭлектроннаяПодписьСлужебныйКлиент.НастроитьПредставлениеДанных(КлиентскиеПараметры, СерверныеПараметры);
	
	ИмяФормы = "ОбщаяФорма.СохранениеВместеСЭлектроннойПодписью";
	
	ФормаСохранения = ОткрытьФорму(ИмяФормы, СерверныеПараметры,,,,,
		Новый ОписаниеОповещения("СохранитьДанныеВместеСПодписьюПослеВыбораПодписей", ЭтотОбъект, Контекст));
	
	Завершить = Ложь;
	Контекст.Вставить("Форма", ФормаСохранения);
	
	Если ФормаСохранения = Неопределено Тогда
		Завершить = Истина;
	Иначе
		ФормаСохранения.КлиентскиеПараметры = КлиентскиеПараметры;
		
		Если СохранятьВсеПодписи Тогда
			СохранитьДанныеВместеСПодписьюПослеВыбораПодписей(ФормаСохранения.ТаблицаПодписей, Контекст);
			Возврат;
			
		ИначеЕсли Не ФормаСохранения.Открыта() Тогда
			Завершить = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Завершить И Контекст.ОбработкаРезультата <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОбработкаРезультата, Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью.
Процедура СохранитьДанныеВместеСПодписьюПослеВыбораПодписей(ДанныеВозвратаФормы, Контекст) Экспорт
	
	Если ТипЗнч(ДанныеВозвратаФормы) <> Тип("ДанныеФормыКоллекция")
		И ТипЗнч(ДанныеВозвратаФормы) <> Тип("Структура") Тогда
		Если Контекст.ОбработкаРезультата <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(Контекст.ОбработкаРезультата, Ложь);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеВозвратаФормы) = Тип("ДанныеФормыКоллекция") Тогда
		Контекст.Вставить("КоллекцияПодписей", ДанныеВозвратаФормы);
	Иначе	
		Контекст.Вставить("КоллекцияПодписей", ДанныеВозвратаФормы.КоллекцияПодписей);
		Контекст.Вставить("СохранятьВизуализациюСоШтампомЭП", ДанныеВозвратаФормы.СохранятьВизуализациюСоШтампомЭП);
	КонецЕсли;	
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("ОписаниеДанных", Контекст.ОписаниеДанных);
	ПараметрыВыполнения.Вставить("Оповещение", Новый ОписаниеОповещения(
		"СохранитьДанныеВместеСПодписьюПослеСохраненияФайлаДанных", ЭтотОбъект, Контекст));
	
	Попытка
		ВыполнитьОбработкуОповещения(Контекст.ОписаниеДанных.Данные, ПараметрыВыполнения);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		СохранитьДанныеВместеСПодписьюПослеСохраненияФайлаДанных(
			Новый Структура("ОписаниеОшибки", КраткоеПредставлениеОшибки(ИнформацияОбОшибке)), Контекст);
	КонецПопытки;
	
КонецПроцедуры

// Продолжение процедуры ЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью.
Процедура СохранитьДанныеВместеСПодписьюПослеСохраненияФайлаДанных(Результат, Контекст) Экспорт
	
	Если Результат.Свойство("ОписаниеОшибки") Тогда
		Ошибка = Новый Структура("ОписаниеОшибки",
			НСтр("ru = 'При записи файла возникла ошибка:';
				|en = 'An error occurred when writing file:'") + Символы.ПС + Результат.ОписаниеОшибки);
		
		ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
			НСтр("ru = 'Не удалось сохранить подписи вместе с файлом';
				|en = 'Cannot save signatures with the file'"), "", Ошибка, Новый Структура);
		Возврат;
		
	ИначеЕсли Не Результат.Свойство("ПолноеИмяФайла")
		Или ТипЗнч(Результат.ПолноеИмяФайла) <> Тип("Строка")
		Или ПустаяСтрока(Результат.ПолноеИмяФайла) Тогда
		
		Если Контекст.ОбработкаРезультата <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(Контекст.ОбработкаРезультата, Ложь);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Результат.Свойство("ОбработкаЗапросаРазрешений") Тогда
		Контекст.Вставить("ОбработкаЗапросаРазрешений", Результат.ОбработкаЗапросаРазрешений);
	КонецЕсли;
	
	Контекст.Вставить("ПолноеИмяФайла", Результат.ПолноеИмяФайла);
	Контекст.Вставить("СоставИмениФайлаДанных",
		ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(Контекст.ПолноеИмяФайла));
		
	Если Результат.Свойство("ПолноеИмяФайлаВизуализации") Тогда
		Контекст.Вставить("СоставИмениФайлаДанныхВизуализации",
			ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(Результат.ПолноеИмяФайлаВизуализации));
	КонецЕсли;	
		
	Если ЗначениеЗаполнено(Контекст.СоставИмениФайлаДанных.Путь) Тогда
		ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Новый ОписаниеОповещения(
			"СохранитьДанныеВместеСПодписьюПослеПодключенияРасширенияРаботыСФайлами", ЭтотОбъект, Контекст));
	Иначе
		СохранитьДанныеВместеСПодписьюПослеПодключенияРасширенияРаботыСФайлами(Ложь, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью.
Процедура СохранитьДанныеВместеСПодписьюПослеПодключенияРасширенияРаботыСФайлами(Подключено, Контекст) Экспорт
	
	Контекст.Вставить("Подключено", Подключено);
	
	Контекст.Вставить("РасширениеДляФайловПодписи",
		ЭлектроннаяПодписьКлиент.ПерсональныеНастройки().РасширениеДляФайловПодписи);
	
	Если Контекст.Подключено Тогда
		Контекст.Вставить("ПолучаемыеФайлы", Новый Массив);
		Контекст.Вставить("ПутьКФайлам", ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
			Контекст.СоставИмениФайлаДанных.Путь));
	КонецЕсли;
	
	Контекст.Вставить("ИменаФайлов", Новый Соответствие);
	Контекст.ИменаФайлов.Вставить(Контекст.СоставИмениФайлаДанных.Имя, Истина);
	
	Контекст.Вставить("Индекс", -1);
	
	СохранитьДанныеВместеСПодписьюЦиклНачало(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью.
Процедура СохранитьДанныеВместеСПодписьюЦиклНачало(Контекст)
	
	Если Контекст.КоллекцияПодписей.Количество() <= Контекст.Индекс + 1 Тогда
		СохранитьДанныеВместеСПодписьюПослеЦикла(Контекст);
		Возврат;
	КонецЕсли;
	Контекст.Индекс = Контекст.Индекс + 1;
	Контекст.Вставить("ОписаниеПодписи", Контекст.КоллекцияПодписей[Контекст.Индекс]);
	
	Если Не Контекст.ОписаниеПодписи.Пометка Тогда
		СохранитьДанныеВместеСПодписьюЦиклНачало(Контекст);
		Возврат;
	КонецЕсли;
	
	Контекст.Вставить("ИмяФайлаПодписи", Контекст.ОписаниеПодписи.ИмяФайлаПодписи);
	
	Если ПустаяСтрока(Контекст.ИмяФайлаПодписи) Тогда 
		Контекст.ИмяФайлаПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.ИмяФайлаПодписи(Контекст.СоставИмениФайлаДанных.ИмяБезРасширения,
			Строка(Контекст.ОписаниеПодписи.КомуВыданСертификат), Контекст.РасширениеДляФайловПодписи);
	Иначе
		Контекст.ИмяФайлаПодписи = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(Контекст.ИмяФайлаПодписи);
	КонецЕсли;
	
	СоставИмениФайлаПодписи = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(Контекст.ИмяФайлаПодписи);
	Контекст.Вставить("ИмяФайлаПодписиБезРасширения", СоставИмениФайлаПодписи.ИмяБезРасширения);
	
	Контекст.Вставить("Счетчик", 1);
	
	СохранитьДанныеВместеСПодписьюЦиклВнутреннийЦиклНачало(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью.
Процедура СохранитьДанныеВместеСПодписьюЦиклВнутреннийЦиклНачало(Контекст)
	
	Контекст.Счетчик = Контекст.Счетчик + 1;
	
	Если Контекст.Подключено Тогда
		Контекст.Вставить("ПолноеИмяФайлаПодписи", Контекст.ПутьКФайлам + Контекст.ИмяФайлаПодписи);
	Иначе
		Контекст.Вставить("ПолноеИмяФайлаПодписи", Контекст.ИмяФайлаПодписи);
	КонецЕсли;
	
	Если Контекст.ИменаФайлов[Контекст.ИмяФайлаПодписи] <> Неопределено Тогда
		СохранитьДанныеВместеСПодписьюЦиклВнутреннийЦиклПослеПроверкиСуществованияФайла(Истина, Контекст);
		
	ИначеЕсли Контекст.Подключено Тогда
		Файл = Новый Файл(Контекст.ПолноеИмяФайлаПодписи);
		Файл.НачатьПроверкуСуществования(Новый ОписаниеОповещения(
			"СохранитьДанныеВместеСПодписьюЦиклВнутреннийЦиклПослеПроверкиСуществованияФайла", ЭтотОбъект, Контекст));
	Иначе
		СохранитьДанныеВместеСПодписьюЦиклВнутреннийЦиклПослеПроверкиСуществованияФайла(Ложь, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью.
Процедура СохранитьДанныеВместеСПодписьюЦиклВнутреннийЦиклПослеПроверкиСуществованияФайла(Существует, Контекст) Экспорт
	
	Если Не Существует Тогда
		СохранитьДанныеВместеСПодписьюЦиклПослеВнутреннегоЦикла(Контекст);
		Возврат;
	КонецЕсли;
	
	Контекст.ИмяФайлаПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.ИмяФайлаПодписи(Контекст.ИмяФайлаПодписиБезРасширения,
		"(" + Строка(Контекст.Счетчик) + ")", Контекст.РасширениеДляФайловПодписи, Ложь);
	
	СохранитьДанныеВместеСПодписьюЦиклВнутреннийЦиклНачало(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью.
Процедура СохранитьДанныеВместеСПодписьюЦиклПослеВнутреннегоЦикла(Контекст)
	
	СоставИмениФайлаПодписи = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(Контекст.ПолноеИмяФайлаПодписи);
	Контекст.ИменаФайлов.Вставить(СоставИмениФайлаПодписи.Имя, Ложь);
	
	Если Контекст.Подключено Тогда
		Описание = Новый ОписаниеПередаваемогоФайла(СоставИмениФайлаПодписи.Имя, Контекст.ОписаниеПодписи.АдресПодписи);
		Контекст.ПолучаемыеФайлы.Добавить(Описание);
		СохранитьДанныеВместеСПодписьюЦиклПослеСохраненияПодписи(Неопределено, Контекст);
	Иначе
		// Сохранение Файла из базы данных на диск.
		ФайловаяСистемаКлиент.СохранитьФайл(
			Новый ОписаниеОповещения("СохранитьДанныеВместеСПодписьюЦиклПослеСохраненияПодписи", ЭтотОбъект, Контекст),
			Контекст.ОписаниеПодписи.АдресПодписи, СоставИмениФайлаПодписи.Имя);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью.
Процедура СохранитьДанныеВместеСПодписьюЦиклПослеСохраненияПодписи(Результат, Контекст) Экспорт
	
	Если Контекст.СохранятьСертификатВместеСПодписью Тогда
		СохранитьДанныеСертификатаВместеСПодписьюЦиклНачало(Контекст);
	Иначе
		СохранитьДанныеВместеСПодписьюЦиклНачало(Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью.
Процедура СохранитьДанныеСертификатаВместеСПодписьюЦиклВнутреннийЦиклНачало(Контекст)
	
	Если Контекст.Подключено Тогда
		Контекст.Вставить("ПолноеИмяФайлаСертификата", Контекст.ПутьКФайлам + Контекст.ИмяФайлаСертификата);
	Иначе
		Контекст.Вставить("ПолноеИмяФайлаСертификата", Контекст.ИмяФайлаСертификата);
	КонецЕсли;
	
	Если Контекст.ИменаФайлов[Контекст.ИмяФайлаСертификата] <> Неопределено Тогда
		СохранитьДанныеСертификатаВместеСПодписьюЦиклВнутреннийЦиклПослеПроверкиСуществованияФайла(Истина, Контекст);
		
	ИначеЕсли Контекст.Подключено Тогда
		Файл = Новый Файл(Контекст.ПолноеИмяФайлаСертификата);
		Файл.НачатьПроверкуСуществования(Новый ОписаниеОповещения(
			"СохранитьДанныеСертификатаВместеСПодписьюЦиклВнутреннийЦиклПослеПроверкиСуществованияФайла", ЭтотОбъект, Контекст));
	Иначе
		СохранитьДанныеСертификатаВместеСПодписьюЦиклВнутреннийЦиклПослеПроверкиСуществованияФайла(Ложь, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью.
Процедура СохранитьДанныеСертификатаВместеСПодписьюЦиклВнутреннийЦиклПослеПроверкиСуществованияФайла(Существует, Контекст) Экспорт
	
	Если Не Существует Тогда
		СохранитьДанныеСертификатаВместеСПодписьюЦиклПослеВнутреннегоЦикла(Контекст);
		Возврат;
	КонецЕсли;
	
	Контекст.ИмяФайлаСертификата = ЭлектроннаяПодписьСлужебныйКлиентСервер.ИмяФайлаСертификата(Контекст.ИмяФайлаСертификатаБезРасширения,
		"(" + Строка(Контекст.Счетчик) + ")", Контекст.ОписаниеПодписи.РасширениеСертификата, Ложь);
	
	СохранитьДанныеСертификатаВместеСПодписьюЦиклВнутреннийЦиклНачало(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью.
Процедура СохранитьДанныеСертификатаВместеСПодписьюЦиклНачало(Контекст)
	
	Контекст.Вставить("ИмяФайлаСертификата", "");
	
	Контекст.ИмяФайлаСертификата = ЭлектроннаяПодписьСлужебныйКлиентСервер.ИмяФайлаСертификата(Контекст.СоставИмениФайлаДанных.ИмяБезРасширения,
		Строка(Контекст.ОписаниеПодписи.КомуВыданСертификат), Контекст.ОписаниеПодписи.РасширениеСертификата);
	
	СоставИмениФайлаСертификата  = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(Контекст.ИмяФайлаСертификата);
	Контекст.Вставить("ИмяФайлаСертификатаБезРасширения", СоставИмениФайлаСертификата.ИмяБезРасширения);
	
	СохранитьДанныеСертификатаВместеСПодписьюЦиклВнутреннийЦиклНачало(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью.
Процедура СохранитьДанныеСертификатаВместеСПодписьюЦиклПослеВнутреннегоЦикла(Контекст)
	
	СоставИмениФайлаСертификата = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(Контекст.ПолноеИмяФайлаСертификата);
	Контекст.ИменаФайлов.Вставить(СоставИмениФайлаСертификата.Имя, Ложь);
	
	Если Контекст.Подключено Тогда
		Описание = Новый ОписаниеПередаваемогоФайла(СоставИмениФайлаСертификата.Имя, Контекст.ОписаниеПодписи.АдресСертификата);
		Контекст.ПолучаемыеФайлы.Добавить(Описание);
		СохранитьДанныеВместеСПодписьюЦиклНачало(Контекст);
	Иначе
		// Сохранение Файла из базы данных на диск.
		ФайловаяСистемаКлиент.СохранитьФайл(
			Новый ОписаниеОповещения("СохранитьДанныеСертификатаВместеСПодписьюЦиклПослеСохраненияСертификата", ЭтотОбъект, Контекст),
			Контекст.ОписаниеПодписи.АдресСертификата, СоставИмениФайлаСертификата.Имя);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью.
Процедура СохранитьДанныеСертификатаВместеСПодписьюЦиклПослеСохраненияСертификата(Результат, Контекст) Экспорт
	
	СохранитьДанныеВместеСПодписьюЦиклНачало(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью.
Процедура СохранитьДанныеВместеСПодписьюПослеЦикла(Контекст)
	
	Если Не Контекст.Подключено Тогда
		Если Контекст.ОбработкаРезультата <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(Контекст.ОбработкаРезультата, Истина);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	// Сохранение Файла из базы данных на диск.
	Если Контекст.ПолучаемыеФайлы.Количество() > 0 Тогда
		Контекст.Вставить("ПолучаемыеФайлы", Контекст.ПолучаемыеФайлы);
		
		Вызовы = Новый Массив;
		Вызов = Новый Массив;
		Вызов.Добавить("НачатьПолучениеФайлов");
		Вызов.Добавить(Контекст.ПолучаемыеФайлы);
		Вызов.Добавить(Контекст.ПутьКФайлам);
		Вызов.Добавить(Ложь);
		Вызовы.Добавить(Вызов);
		
		ОбработкаПродолжения = Новый ОписаниеОповещения(
			"СохранитьДанныеВместеСПодписьюПослеПолученияРазрешений", ЭтотОбъект, Контекст);
		
		Если Контекст.Свойство("ОбработкаЗапросаРазрешений") Тогда
			ПараметрыВыполнения = Новый Структура;
			ПараметрыВыполнения.Вставить("Вызовы", Вызовы);
			ПараметрыВыполнения.Вставить("ОбработкаПродолжения", ОбработкаПродолжения);
			ВыполнитьОбработкуОповещения(Контекст.ОбработкаЗапросаРазрешений, ПараметрыВыполнения);
		Иначе
			НачатьЗапросРазрешенияПользователя(ОбработкаПродолжения, Вызовы);
		КонецЕсли;
	Иначе
		СохранитьДанныеВместеСПодписьюПослеПолученияРазрешений(Ложь, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью.
Процедура СохранитьДанныеВместеСПодписьюПослеПолученияРазрешений(РазрешенияПолучены, Контекст) Экспорт
	
	Если Не РазрешенияПолучены
	   И Контекст.ПолучаемыеФайлы.Количество() > 0
	   И Контекст.Свойство("ОбработкаЗапросаРазрешений") Тогда
		
		// Файл данных не был получен - отчет не требуется.
		Если Контекст.ОбработкаРезультата <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(Контекст.ОбработкаРезультата, Ложь);
		КонецЕсли;
		
	ИначеЕсли РазрешенияПолучены Тогда
		
		ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайлов();
		ПараметрыСохранения.Диалог.Каталог = Контекст.ПутьКФайлам;
		ФайловаяСистемаКлиент.СохранитьФайлы(Новый ОписаниеОповещения(
			"СохранитьДанныеВместеСПодписьюПослеПолученияФайлов", ЭтотОбъект, Контекст), 
			Контекст.ПолучаемыеФайлы, ПараметрыСохранения);		
	Иначе
		СохранитьДанныеВместеСПодписьюПослеПолученияФайлов(Неопределено, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью.
//
// Параметры:
//   ПолученныеФайлы - Массив из ОписаниеПередаваемогоФайла
//
Процедура СохранитьДанныеВместеСПодписьюПослеПолученияФайлов(ПолученныеФайлы, Контекст) Экспорт
	
	ИменаПолученныхФайлов = Новый Соответствие;
	ИменаПолученныхФайлов.Вставить(Контекст.СоставИмениФайлаДанных.Имя, Истина);
	Если Контекст.Свойство("СоставИмениФайлаДанныхВизуализации") Тогда
		ИменаПолученныхФайлов.Вставить(Контекст.СоставИмениФайлаДанныхВизуализации.Имя, Истина);
	КонецЕсли;	
	
	Если ТипЗнч(ПолученныеФайлы) = Тип("Массив") Тогда
		Для каждого ПолученныйФайл Из ПолученныеФайлы Цикл
			СоставИмениФайлаПодписи = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПолученныйФайл.Имя);
			ИменаПолученныхФайлов.Вставить(СоставИмениФайлаПодписи.Имя, Истина);
		КонецЦикла;
	КонецЕсли;
	
	Текст = НСтр("ru = 'Папка с файлами:';
				|en = 'Folder with files:'") + Символы.ПС
		+ Контекст.ПутьКФайлам + Символы.ПС + Символы.ПС
		+ НСтр("ru = 'Файлы:';
				|en = 'Files:'") + Символы.ПС;
	
	Для Каждого КлючИЗначение Из ИменаПолученныхФайлов Цикл
		Текст = Текст + КлючИЗначение.Ключ + Символы.ПС;
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Текст", Текст);
	ПараметрыФормы.Вставить("КаталогСФайлами", Контекст.СоставИмениФайлаДанных.Путь);
	
	ОткрытьФорму("ОбщаяФорма.ОтчетОСохраненииФайловЭлектронныхПодписей", ПараметрыФормы,,,,,
		Новый ОписаниеОповещения("СохранитьДанныеВместеСПодписьюПослеЗакрытияОтчета", ЭтотОбъект, Контекст));
	
КонецПроцедуры

// Продолжение процедуры ЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью.
Процедура СохранитьДанныеВместеСПодписьюПослеЗакрытияОтчета(Результат, Контекст) Экспорт
	
	Если Контекст.ОбработкаРезультата <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОбработкаРезультата, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти