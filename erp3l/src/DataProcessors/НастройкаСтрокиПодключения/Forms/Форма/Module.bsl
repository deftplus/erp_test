////////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ.
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("СтрокаПодключения", СтрокаПодключения);
	ИзменитьЗаголовкиПолей();
	
	Если ЗначениеЗаполнено(СтрокаПодключения) Тогда
		
		ЗаполнитьРеквизитыПровайдера(Истина);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.OLEDBПровайдер.СписокВыбора.Очистить();
	Для Каждого Элемент Из СписокПровайдеров Цикл
		Элементы.OLEDBПровайдер.СписокВыбора.Добавить(Элемент.Значение, Элемент.Представление);
	КонецЦикла;
	
	СопоставитьПолныеИПростыеНастройки();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ФУКНЦИИ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ.
//

&НаКлиенте
Процедура OLEDBПровайдерНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СписокПровайдеров.Количество() = 0 Тогда
		Состояние("Заполнение списка провайдеров OLE DB");
		ЗаполнитьСписокПровайдеров();
		Состояние();
	КонецЕсли;
	
	ДанныеВыбора = СписокПровайдеров;
	
КонецПроцедуры

&НаКлиенте
Процедура OLEDBПровайдерПриИзменении(Элемент)
	
	ЗаполнитьРеквизитыПровайдера();
	СопоставитьПолныеИПростыеНастройки();
	ИзменитьЗаголовкиПолей();
	СформироватьСтрокуПодключения();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокПровайдеров(Команда)
	
	Состояние("Заполнение списка провайдеров OLE DB");
	ЗаполнитьСписокПровайдеров();
	Состояние();
	
КонецПроцедуры

&НаКлиенте
Процедура СерверПриИзменении(Элемент)
	УстановитьЗначениеНастройки("Data Source", Сервер);
	СформироватьСтрокуПодключения();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАвторизациюWindowsПриИзменении(Элемент)
	УстановитьЗначениеНастройки("Integrated Security", ?(ИспользоватьАвторизациюWindows = 1, "SSPI", ""));
	Если ИспользоватьАвторизациюWindows Тогда
		УстановитьЗначениеНастройки("User Id", "");
		УстановитьЗначениеНастройки("Password", "");
	КонецЕсли;
	
	Элементы.ИмяПользователя.Доступность = НЕ ИспользоватьАвторизациюWindows;
	Элементы.Пароль.Доступность          = НЕ ИспользоватьАвторизациюWindows;
	
	СформироватьСтрокуПодключения();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяПользователяПриИзменении(Элемент)
	УстановитьЗначениеНастройки("User ID", ИмяПользователя);
	СформироватьСтрокуПодключения();
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	УстановитьЗначениеНастройки("Password", Пароль);	
	СформироватьСтрокуПодключения();
КонецПроцедуры

&НаКлиенте
Процедура ТипИспользуемогоФайлаПриИзменении(Элемент)
	
	УстановитьЗначениеНастройки("Extended Properties", ТипИспользуемогоФайла + ?(ПустаяСтрока(ТипИспользуемогоФайла) ИЛИ ПустаяСтрока(ДополнительныеНастройки) ,"", ";") + ДополнительныеНастройки);
	Сервер = "";
	СформироватьСтрокуПодключения();
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеНастройкиПриИзменении(Элемент)
	УстановитьЗначениеНастройки("Extended Properties", ТипИспользуемогоФайла + ?(ПустаяСтрока(ТипИспользуемогоФайла) ИЛИ ПустаяСтрока(ДополнительныеНастройки) ,"", ";") + ДополнительныеНастройки);
	СформироватьСтрокуПодключения();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПриИзменении(Элемент)
	УстановитьЗначениеНастройки("Initial Catalog", Таблица);
	СформироватьСтрокуПодключения();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекПриИзменении(Элемент)
	
	СопоставитьПолныеИПростыеНастройки();
	СформироватьСтрокуПодключения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключение(Команда)
	
	Перем ИнформацияОПодключении, СписокТаблиц;
	ПроверитьПодключение_Сервер(ИнформацияОПодключении, СписокТаблиц);
	
	Элементы.Таблица.СписокВыбора.ЗагрузитьЗначения(СписокТаблиц.ВыгрузитьЗначения());
	
	ПоказатьПредупреждение(, ИнформацияОПодключении);
	
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	ОповеститьОВыборе(СтрокаПодключения);
КонецПроцедуры

&НаКлиенте
Процедура СерверНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РежимДиалога = ?(ТипИспользуемогоФайла = "dBase IV", РежимДиалогаВыбораФайла.ВыборКаталога, РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла                = Новый ДиалогВыбораФайла(РежимДиалога);
	ДиалогВыбораФайла.Фильтр         = ВернутьМаскуДиалогаВыбораФайла();
	
	Если ТипИспользуемогоФайла = "dBase IV" Тогда
		ДиалогВыбораФайла.Каталог = Сервер;
	Иначе
		ДиалогВыбораФайла.ПолноеИмяФайла = Сервер;
	КонецЕсли;

	ДиалогВыбораФайла.Показать(Новый ОписаниеОповещения("СерверНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("ДиалогВыбораФайла, РежимДиалога", ДиалогВыбораФайла, РежимДиалога)));

КонецПроцедуры

&НаКлиенте
Процедура СерверНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
    
    ДиалогВыбораФайла = ДополнительныеПараметры.ДиалогВыбораФайла;
    РежимДиалога = ДополнительныеПараметры.РежимДиалога;
    
    
    Если (ВыбранныеФайлы <> Неопределено) Тогда
        
        Если РежимДиалога = РежимДиалогаВыбораФайла.Открытие Тогда
            Сервер = ДиалогВыбораФайла.ПолноеИмяФайла;
        Иначе
            Сервер = ДиалогВыбораФайла.Каталог;
        КонецЕсли;
        
        УстановитьЗначениеНастройки("Data Source", Сервер);
        СформироватьСтрокуПодключения();
        
    КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ.
//

&НаКлиенте
Функция ВернутьМаскуДиалогаВыбораФайла()
	
	Если ТипИспользуемогоФайла = "dBase IV" Тогда
		Возврат "Файл Fox Pro (*.dbf)|*.dbf";
	ИначеЕсли ТипИспользуемогоФайла = "Excel 8.0" Тогда
		Возврат "Файл Microsoft Excel (*.xls)|*.xls";
	Иначе
		Возврат "Файл Microsoft Access (*.mdb)|*.mdb|Все файлы|*.*";
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция СформироватьСтрокуПодключения()
	
	Если ЗначениеЗаполнено(OLEDBПровайдер) Тогда
		Connect=Новый ComОбъект("ADODB.Connection");
		Connect.Provider=OLEDBПровайдер;
		Для Каждого Строка Из ТаблицаНастроек Цикл
			Если ЗначениеЗаполнено(Строка.ЗначениеРеквизита) Тогда
				Connect.Properties(Строка.ИмяРеквизита).Value = Строка.ЗначениеРеквизита;
			КонецЕсли;
		КонецЦикла;
		СтрокаПодключения = Connect.ConnectionString;
		Connect = Неопределено;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ПроверитьПодключение_Сервер(ИнформацияОПодключении, СписокТаблиц = Неопределено)
	
	Перем РезультатПолученияТаблиц, Отказ;
	РезультатПолученияТаблиц = УправлениеСоединениямиВИБУХ.ВернутьСписокТаблицИсточника(СтрокаПодключения, Отказ, ИнформацияОПодключении);
	
	СписокТаблиц = РезультатПолученияТаблиц.СписокТаблиц;
	
	Если ИнформацияОПодключении = Неопределено Тогда
		
		// возможно подключение кэшировано
		ИнформацияОПодключении = РезультатПолученияТаблиц.СообщениеОбОшибке;
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПровайдера(ИспользоватьСтрокуПодключения = Ложь)
	
	ТаблицаНастроек.Очистить();
	
	Попытка
		Connect=Новый ComОбъект("ADODB.Connection");
	Исключение
		ОбщегоНазначенияУХ.СообщитьОбОшибке(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	
	Если ИспользоватьСтрокуПодключения Тогда
		Попытка
			Connect.ConnectionString = СтрокаПодключения;
		Исключение
			ОбщегоНазначенияУХ.СообщитьОбОшибке(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат;
		КонецПопытки;
		
		OLEDBПровайдер           = Connect.Provider;
	ИначеЕсли ЗначениеЗаполнено(OLEDBПровайдер) Тогда
		Попытка
			Connect.Provider=OLEDBПровайдер;
		Исключение
			ОбщегоНазначенияУХ.СообщитьОбОшибке(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	Иначе
		Возврат;
	КонецЕсли;
	
	Для Каждого Реквизит Из Connect.Properties Цикл
		
		НоваяСтрока = ТаблицаНастроек.Добавить();
		НоваяСтрока.ИмяРеквизита = Реквизит.Name;
		НоваяСтрока.ЗначениеРеквизита = Реквизит.Value;
		Аттрибуты = Реквизит.Attributes;
		ПроверитьАттрибут(НоваяСтрока.ДоступноДляЗаписи, Аттрибуты, 1024);
		ПроверитьАттрибут(НоваяСтрока.ДоступноДляЧтения, Аттрибуты, 512);
		ПроверитьАттрибут(НоваяСтрока.ОпциональноеПоле, Аттрибуты, 2);
		ПроверитьАттрибут(НоваяСтрока.ОбязательноеПоле, Аттрибуты, 1);
		
	КонецЦикла;
	Connect = Неопределено;
	
КонецПроцедуры

Процедура ПроверитьАттрибут(ПолеТаблицы, Аттрибуты, ЗначениеПроверки)
	
	Если Аттрибуты >=ЗначениеПроверки Тогда
		ПолеТаблицы = Истина;
		Аттрибуты = Аттрибуты - ЗначениеПроверки;
	Иначе
		ПолеТаблицы = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПровайдеров()
	
	УправлениеСоединениямиВИБУХ.ПолучитьСписокПровайдеров(СписокПровайдеров);
	Элементы.OLEDBПровайдер.СписокВыбора.Очистить();
	Для Каждого Элемент Из СписокПровайдеров Цикл
		Элементы.OLEDBПровайдер.СписокВыбора.Добавить(Элемент.Значение, Элемент.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СопоставитьПолныеИПростыеНастройки()
	
	ПроверитьНаличиеИЗначениеПоляНастройки("Data Source"         , "Сервер", "Сервер");
	ПроверитьНаличиеИЗначениеПоляНастройки("User ID"             , "ИмяПользователя", "ИмяПользователя");
	ПроверитьНаличиеИЗначениеПоляНастройки("Password"           , "Пароль", "Пароль");
	ПроверитьНаличиеИЗначениеПоляНастройки("Initial Catalog"    , "Таблица", "Таблица");
	ПроверитьНаличиеИЗначениеПоляНастройки("Integrated Security", "ИспользоватьАвторизациюWindows", "ИспользоватьАвторизациюWindows");
	
	Если Элементы.ИспользоватьАвторизациюWindows.Доступность Тогда
		
		Элементы.ИмяПользователя.Доступность = НЕ ИспользоватьАвторизациюWindows;
		Элементы.Пароль.Доступность          = НЕ ИспользоватьАвторизациюWindows;
		
	КонецЕсли;
	
	СтрокиДопНастроек = ТаблицаНастроек.НайтиСтроки(Новый Структура("ИмяРеквизита", "Extended Properties"));
	
	
	Если СтрокиДопНастроек.Количество() = 0 Тогда
		ДополнительныеНастройки = "";
		ТипИспользуемогоФайла   = "";
		Элементы.ДополнительныеНастройки.Доступность = Ложь;
		Элементы.ТипИспользуемогоФайла.Доступность   = Ложь;
	Иначе
		
		ЗначениеДополнительнойНастройки = СтрокиДопНастроек[0].ЗначениеРеквизита;
		ЗначениеТипИспользуемогоФайла   = "";
		Для Каждого Элемент Из Элементы.ТипИспользуемогоФайла.СписокВыбора Цикл
			
			Поз = СтрНайти(ЗначениеДополнительнойНастройки, Элемент.Значение);
			Если Поз <> 0 Тогда
				
				ДанныеЗаполнены = Истина;
				ЗначениеТипИспользуемогоФайла = Элемент.Значение;
				Поз2 = СтрНайти(Сред(ЗначениеДополнительнойНастройки, Поз), ";");
				Если Поз2 = 0 Тогда
					ЗначениеДополнительнойНастройки = СтрЗаменить(ЗначениеДополнительнойНастройки, Сред(ЗначениеДополнительнойНастройки, Поз), "");
				Иначе
					ЗначениеДополнительнойНастройки = СтрЗаменить(ЗначениеДополнительнойНастройки, Сред(ЗначениеДополнительнойНастройки, Поз, Поз2), "");
				КонецЕсли;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		ДополнительныеНастройки = ЗначениеДополнительнойНастройки;
		ТипИспользуемогоФайла   = ЗначениеТипИспользуемогоФайла;
		
		Если СтрЧислоВхождений(OLEDBПровайдер, "Microsoft.Jet") > 0 Тогда
			Элементы.ТипИспользуемогоФайла.Доступность = Истина;
			Элементы.Сервер.КнопкаВыбора              = Истина;
		Иначе
			ТипИспользуемогоФайла = "";
			Элементы.ТипИспользуемогоФайла.Доступность = Ложь;
			Элементы.Сервер.КнопкаВыбора              = Ложь;
		КонецЕсли;

		Элементы.ДополнительныеНастройки.Доступность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьЗаголовкиПолей()
	
	Если СтрЧислоВхождений(OLEDBПровайдер, "SQLOLEDB") > 0 Тогда
		Элементы.ГруппаСервер.Заголовок = "Сервер";
		Элементы.ГруппаТаблица.Заголовок = "Таблица";
	ИначеЕсли СтрЧислоВхождений(OLEDBПровайдер, "Microsoft.Jet") > 0 Тогда 
		Элементы.ГруппаСервер.Заголовок = "Имя файла";
	Иначе
		Элементы.ГруппаСервер.Заголовок  = "Источник данных";
		Элементы.ГруппаТаблица.Заголовок = "Начальный каталог";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНаличиеИЗначениеПоляНастройки(ИмяПоля, ИмяРеквизита, ИмяЭлементаФормы)
	
	НайденныеСтроки = ТаблицаНастроек.НайтиСтроки(Новый Структура("ИмяРеквизита", ИмяПоля));
	Если НайденныеСтроки.Количество() = 0 Тогда
		Элементы[ИмяЭлементаФормы].Доступность = Ложь;
	Иначе
		Элементы[ИмяЭлементаФормы].Доступность = Истина;
		ЭтаФорма[ИмяРеквизита] = ?(ИмяПоля = "Integrated Security", ?(НайденныеСтроки[0].ЗначениеРеквизита = "SSPI", 1, 0), НайденныеСтроки[0].ЗначениеРеквизита);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗначениеНастройки(ИмяПоля, Значение)
	
	НайденныеСтроки = ТаблицаНастроек.НайтиСтроки(Новый Структура("ИмяРеквизита", ИмяПоля));
	Если НайденныеСтроки.Количество() > 0 Тогда
		
		НайденныеСтроки[0].ЗначениеРеквизита = Значение;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьСохранятьПарольПриИзменении(Элемент)
	УстановитьЗначениеНастройки("Persist Security Info", Истина);
	СформироватьСтрокуПодключения();	
КонецПроцедуры

