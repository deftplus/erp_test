// Возвращает структуру, содержащую данные для заполнения отчета
// по настройкам регламента.
&НаСервереБезКонтекста
Функция ПолучитьСтруктуруНастроекЗаполненияИзРегламента(ПериодОтчетаВход, СценарийВход, ВерсияРегламентаВход, ОрганизацияВход, ВидОтчетаВход)
	// Инициализация.
	РезультатФункции = Новый Структура;
	ЗначениеПолучено = Ложь;
	НоваяИспользуемаяИб		 = Справочники.ВнешниеИнформационныеБазы.ПустаяСсылка();
	НовоеПравилоОбработки	 = Справочники.ПравилаОбработки.ПустаяСсылка();
	НовыйСпособЗаполнения	 = Перечисления.СпособыФормированияОтчетов.ПустаяСсылка();
	// Получение таблицы настроек.
	Попытка
		ТаблицаПолномочий = УправлениеОтчетамиУХ.ПолучитьТаблицуПолномочий(ПериодОтчетаВход, СценарийВход, ВерсияРегламентаВход, Неопределено, , ОрганизацияВход, , ВидОтчетаВход);
		// Отбор в таблице.
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("ВерсияОрганизационнойСтруктуры",	 ВерсияРегламентаВход);
		СтруктураОтбора.Вставить("ВидОтчета",						 ВидОтчетаВход);
		СтруктураОтбора.Вставить("ДокументБД",						 Справочники.ДокументыБД.НайтиПоНаименованию("НастраиваемыйОтчет"));
		СтруктураОтбора.Вставить("Организация",						 ОрганизацияВход);
		НайденныеСтроки = ТаблицаПолномочий.НайтиСтроки(СтруктураОтбора);
	Исключение
		ТекстСообщения = НСтр("ru = 'При получении таблицы полномочий для вида отчета %ВидОтчета% по периоду %Период% произошли ошибки: %ОписаниеОшибки%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВидОтчета%", Строка(ВидОтчетаВход));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Период%", Строка(ПериодОтчетаВход));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки());
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		НайденныеСтроки = Новый Массив;
	КонецПопытки;
	// Возврат результирующего значения.
	Если НайденныеСтроки.Количество() = 1 Тогда
		ПерваяСтрока = НайденныеСтроки[0];
		Если ЗначениеЗаполнено(ПерваяСтрока.СпособФормированияОтчета) Тогда
			НоваяИспользуемаяИб		 = ПерваяСтрока.ВнешняяИнформационнаяБаза;
			НовоеПравилоОбработки	 = ПерваяСтрока.ПравилоОбработки;
			НовыйСпособЗаполнения	 = ПерваяСтрока.СпособФормированияОтчета;
			ЗначениеПолучено = Истина;
		Иначе
			ТекстСообщения = НСтр("ru = 'В регламенте %Регламент% не указан способ заполнения для отчёта %Отчет%. Операция отменена.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Регламент%", Строка(ВерсияРегламентаВход));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Отчет%", Строка(ВидОтчетаВход));
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
			ЗначениеПолучено = Ложь;
		КонецЕсли;
	Иначе
		ТекстСообщения = НСтр("ru = 'Не удалось получить настройки регламента заполнения отчетности %Регламент%. Операция отменена.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Регламент%", ВерсияРегламентаВход);
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		ЗначениеПолучено = Ложь;
	КонецЕсли;	
	РезультатФункции.Вставить("ИспользуемаяИБ",		 НоваяИспользуемаяИб);
	РезультатФункции.Вставить("ПравилоОбработки",	 НовоеПравилоОбработки);
	РезультатФункции.Вставить("СпособЗаполнения",	 НовыйСпособЗаполнения);
	РезультатФункции.Вставить("ЗначениеПолучено",	 ЗначениеПолучено);
	Возврат РезультатФункции;
КонецФункции


// Управляет доступностью элементов формы, отвечающих за способ 
// заполнения Импорт.
&НаКлиенте
Процедура УстановитьДоступностьСпособовИмпорта()
	// Заблокируем выбор способа импорта, если файл импорта не задан.
	ЕстьФайлИмпорта = ЗначениеЗаполнено(ФайлИмпорта);
	Если НЕ ЕстьФайлИмпорта Тогда
		СпособИмпортирования = УправлениеОтчетамиКлиентУХ.СпособИмпортаОтчетаИзФайла();
		Элементы.СпособИмпортирования.Доступность = Ложь;
	Иначе
		// Оставляем как есть.
	КонецЕсли;
	
	Элементы.ФайлИмпорта.Видимость=ЕстьФайлИмпорта;
	
	// Если способ импортирования не задан явно, по умолчанию установим импорт из файла.
	Если Не ЗначениеЗаполнено(СпособИмпортирования) Тогда
		СпособИмпортирования = УправлениеОтчетамиКлиентУХ.СпособИмпортаОтчетаИзФайла();
	Иначе
		// Значение установлено, не меняем.
	КонецЕсли;
	// Заблокируем выбор файла на диске, если способ импортирования не из файла.
	ЭтоИмпортИзФайла = (СокрЛП(СпособИмпортирования) = УправлениеОтчетамиКлиентУХ.СпособИмпортаОтчетаИзФайла());
	Элементы.ПутьКФайлу.ТолькоПросмотр = НЕ ЭтоИмпортИзФайла;
КонецПроцедуры

// Управляет доступностью элементов формы.
&НаКлиенте
Процедура УправлениеДоступностью()
	УстановитьДоступностьСпособовИмпорта();
КонецПроцедуры

// Управляет составом доступных способов заполнения.
&НаСервере
Процедура УстановитьДоступныеСпособыЗаполнения()
			
	Если НЕ ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда	
		Элементы.ГруппаСтраницаИмпортИзФайла.Видимость = Ложь;
		Элементы.ГруппаСтраницаКонсолидироватьПериметр.Видимость = Ложь;		
		Элементы.ГруппаСтраницаСвернутьПоПроектам.Видимость = Ложь;
	КонецЕсли;
				
	Если НЕ  ВидОтчета.РазделениеПоПроектам Тогда	
		Элементы.ГруппаСтраницаСвернутьПоПроектам.Видимость = Ложь;
	КонецЕсли;
	
	ЭтоКонсолидирующаяОрганизация = УправлениеРабочимиПроцессамиУХ.ОрганизацияЯвляетсяКонсолидирующей(
			Организация, Сценарий, ПериодОтчета);
			
	Элементы.ГруппаСтраницаКонсолидироватьПериметр.Видимость=ЭтоКонсолидирующаяОрганизация;	
	
	Элементы.ГруппаСтраницаЭлиминация.Видимость=Организация.ЭлиминирующаяОрганизация;
	Элементы.ГруппаСтраницаСвернутьПоАналитикам.Видимость = ЗначениеЗаполнено(ВидОтчета.ВидАналитики1);

	Если  РежимМногопериодногоБланка Тогда	
		Элементы.ГруппаСтраницаСвернутьПоПериоду.Видимость = Ложь;
		Элементы.ГруппаСтраницаСвернутьПоПроектам.Видимость = Ложь;
        		
		НовыйМассив = Новый Массив();
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Владелец",ВидОтчета);	
		НовыйМассив.Добавить(НовыйПараметр);
		НовыйПараметр = Новый ПараметрВыбора("Отбор.РежимБланка",2);	
		НовыйМассив.Добавить(НовыйПараметр);

		НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
		
		Элементы.БланкИмпорта.ПараметрыВыбора = НовыеПараметры;	
	Иначе	
		НовыйМассив = Новый Массив();
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Владелец",ВидОтчета);	
		НовыйМассив.Добавить(НовыйПараметр);
		НовыйПараметр = Новый ПараметрВыбора("Отбор.РежимБланка",0);	
		НовыйМассив.Добавить(НовыйПараметр);

		НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
		
		Элементы.БланкИмпорта.ПараметрыВыбора = НовыеПараметры;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Считывание параметров.
	ВерсияРегламента			= Параметры.ВерсияРегламента;
	ВидОтчета					= Параметры.ВидОтчета;
	ИспользуемаяИБ				= Параметры.ИспользуемаяИБ;
	Организация					= Параметры.Организация;
	ПериодичностьСвертки		= Параметры.ПериодичностьСвертки;
	ПериодОтчета				= Параметры.ПериодОтчета;
	ПравилоОбработки			= Параметры.ПравилоОбработки;
	ПравилоПроверки				= Параметры.ПравилоПроверки;
	ПутьКФайлу					= Параметры.ПутьКФайлу;
	СпособЗаполнения			= Параметры.СпособЗаполнения;
	Сценарий					= Параметры.Сценарий;
	ФайлИмпорта					= Параметры.ФайлИмпорта;
	ТипБД						= Параметры.ТипБД;
	БланкИмпорта                = Параметры.БланкИмпорта;
	РежимМногопериодногоБланка	= Параметры.РежимМногопериодногоБланка;
	
	
	Если Не ЗначениеЗаполнено(СпособЗаполнения) ИЛИ (СпособЗаполнения = Перечисления.СпособыФормированияОтчетов.РучноеЗаполнение) Тогда
		СпособЗаполнения = Перечисления.СпособыФормированияОтчетов.АвтоматическиПоПравилуОбработки;
	Иначе
		// Значение выбрано.
	КонецЕсли;
	УстановитьДоступныеСпособыЗаполнения();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеДоступностью();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОтчет(Команда)
	
	УстановитьСпособЗаполнения();
	СтруктураЗакрытия = Новый Структура;
	СтруктураЗакрытия.Вставить("ИспользуемаяИБ",		 ИспользуемаяИБ);
	СтруктураЗакрытия.Вставить("ПериодичностьСвертки",	 ПериодичностьСвертки);
	СтруктураЗакрытия.Вставить("ПравилоОбработки",		 ПравилоОбработки);
	СтруктураЗакрытия.Вставить("ПравилоПроверки",		 ПравилоПроверки);
	СтруктураЗакрытия.Вставить("ПутьКФайлу",			 ПутьКФайлу);
	СтруктураЗакрытия.Вставить("СпособИмпортирования",	 СпособИмпортирования);
	СтруктураЗакрытия.Вставить("СпособЗаполнения",		 СпособЗаполнения);
	СтруктураЗакрытия.Вставить("ФильтрФайловADO",		 ФильтрФайловADO);
	СтруктураЗакрытия.Вставить("БланкИмпорта",		 	 БланкИмпорта);
	
	ЭтаФорма.Закрыть(СтруктураЗакрытия);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНастройкиПоРегламенту(Команда)
	// Получение данных из регламента.
	СтруктураНастроек = ПолучитьСтруктуруНастроекЗаполненияИзРегламента(ПериодОтчета, Сценарий, ВерсияРегламента, Организация, ВидОтчета);
	// Заполнение реквизитов на форме.
	ЗначениеПолучено = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураНастроек, "ЗначениеПолучено", Ложь);
	Если ЗначениеПолучено Тогда
		СпособЗаполнения	 = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураНастроек, "СпособЗаполнения", ПредопределенноеЗначение("Перечисление.СпособыФормированияОтчетов.ПустаяСсылка"));
		ИспользуемаяИБ		 = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураНастроек, "ИспользуемаяИБ", ПредопределенноеЗначение("Справочник.ВнешниеИнформационныеБазы.ПустаяСсылка"));
		ПравилоОбработки	 = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураНастроек, "ПравилоОбработки", ПредопределенноеЗначение("Справочник.ПравилаОбработки.ПустаяСсылка"));
	Иначе
		// Не изменяем настройки.
	КонецЕсли;
	// Обновление интерфейса.
	УправлениеДоступностью();
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаНаДиске_Завершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Если ВыбранноеЗначение.Количество() > 0 Тогда
			ПутьКФайлу = ВыбранноеЗначение[0];
		Иначе
			ПутьКФайлу = "";	// Файлы не выбраны.
		КонецЕсли;
	Иначе
		ПутьКФайлу = "";		// Пользователь отказался.
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ИмяФайла = ""; 
	ПолноеИмяФайла = ""; 
	ФильтрФайловADO = УправлениеОтчетамиУХ.ОпределитьРасширениеФайлаADO(ИспользуемаяИБ);
	Если НЕ ПустаяСтрока(ФильтрФайловADO) Тогда
		СтрокаФильтр = ФильтрФайловADO;
	Иначе
		СтрокаФильтр = Нстр("ru = 'Таблица Excel'") + " (*.xls,*.xlsx)|*.xl*|" + Нстр("ru = 'Табличный документ'") + " (*.mxl)|*.mxl";
	КонецЕсли;
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Заголовок				 = Нстр("ru = 'Выберите файл для импорта'");
	ДиалогВыбораФайла.МножественныйВыбор	 = Ложь;
	ДиалогВыбораФайла.Фильтр				 = СтрокаФильтр;
	СтруктураДополнительныхПараметров = Новый Структура;
	СтруктураДополнительныхПараметров.Вставить("ФильтрФайловADO", ФильтрФайловADO);
	ОписаниеОткрытияФайла = Новый ОписаниеОповещения("ВыборФайлаНаДиске_Завершение", ЭтаФорма, СтруктураДополнительныхПараметров);
	ДиалогВыбораФайла.Показать(ОписаниеОткрытияФайла);
КонецПроцедуры

&НаКлиенте
Процедура СпособИмпортированияПриИзменении(Элемент)
	УправлениеДоступностью();
КонецПроцедуры

&НаСервере
Процедура ПравилоРасчетаПриИзмененииНаСервере()
	
	ТипБД=УправлениеОтчетамиУХ.ОпределитьТипБД(ПравилоОбработки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоРасчетаПриИзменении(Элемент)
	
	ПравилоРасчетаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСпособЗаполнения()
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаСтраницаПоПравилуРасчета" Тогда	
		СпособЗаполнения = Перечисления.СпособыФормированияОтчетов.АвтоматическиПоПравилуОбработки;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаСтраницаИмпортИзФайла" Тогда
		СпособЗаполнения = Перечисления.СпособыФормированияОтчетов.Импорт;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаСтраницаКонсолидироватьПериметр" Тогда
		СпособЗаполнения = Перечисления.СпособыФормированияОтчетов.АвтоматическиКонсолидация;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаСтраницаСвернутьПоАналитикам" Тогда
		СпособЗаполнения = Перечисления.СпособыФормированияОтчетов.АвтоматическиСвернувПоАналитикам;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаСтраницаСвернутьПоПериоду" Тогда
		СпособЗаполнения = Перечисления.СпособыФормированияОтчетов.АвтоматическиСвернувПоПериоду;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаСтраницаСвернутьПоПроектам" Тогда	
		СпособЗаполнения = Перечисления.СпособыФормированияОтчетов.АвтоматическиСвернувПоПроектам;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаСтраницаЭлиминация" Тогда	
		СпособЗаполнения = Перечисления.СпособыФормированияОтчетов.АвтоматическиЭлиминация;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	УстановитьСпособЗаполнения();
КонецПроцедуры
