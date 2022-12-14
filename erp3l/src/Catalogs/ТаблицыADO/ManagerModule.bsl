#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбновитьТаблицыADO(ТипБД) Экспорт
	
	Если ТипЗнч(ТипБД) <> Тип("СправочникСсылка.ТипыБазДанных") ИЛИ НЕ ЗначениеЗаполнено(ТипБД) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТипБД.ВИБПоУмолчанию) Тогда
		
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = СтрШаблон(Нстр("ru = 'Для типа внешней информационной базы %1 не задана внешняя информационная база по умолчанию'"), 
			ТипБД);
		СообщениеПользователю.Сообщить();
		Возврат;
		
	КонецЕсли;
	
	Если ТипБД.ВИБПоУмолчанию.ТипХранилищаДанныхADO=Перечисления.ТипыХранилищДанныхADO.XLS
		ИЛИ ТипБД.ВИБПоУмолчанию.ТипХранилищаДанныхADO=Перечисления.ТипыХранилищДанныхADO.MSAccess Тогда
				
		НайденныеФайлы=НайтиФайлы(ТипБД.ВИБПоУмолчанию.ЭталонныйКаталог,?(ТипБД.ВИБПоУмолчанию.ТипХранилищаДанныхADO=Перечисления.ТипыХранилищДанныхADO.XLS,"*.xl*","*.mdb"));
		
		Для Каждого Файл ИЗ НайденныеФайлы Цикл
			
			СтрокаСоединения=УправлениеСоединениямиВИБУХ.ПолучитьСтрокуСоединенияADO(ТипБД.ВИБПоУмолчанию,Файл.ПолноеИмя);
			ПолучитьТаблицыИзСоединения(ТипБД,СтрокаСоединения,Файл.Имя, Ложь);
			
		КонецЦикла;
		
	Иначе
		
		СтрокаСоединения = ТипБД.ВИБПоУмолчанию.СтрокаПодключения;
		ПолучитьТаблицыИзСоединения(ТипБД,СтрокаСоединения);
		
	КонецЕсли;
			
КонецПроцедуры

Процедура ПолучитьТаблицыИзСоединения(ТипБД,СтрокаСоединения,ИмяФайла="", УдалятьТаблицы = Истина) Экспорт
	
	ПРОТОКОЛИРУЕМОЕ_СОБЫТИЕ = "Справочник.ТаблицыADO.МодульМенеджера.ПолучитьТаблицыИзСоединения";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицыADO.Ссылка,
	|	ТаблицыADO.Имя,
	|	ЛОЖЬ КАК Существует
	|ИЗ
	|	Справочник.ТаблицыADO КАК ТаблицыADO
	|ГДЕ
	|	ТаблицыADO.Владелец = &ТипБД";
	Запрос.УстановитьПараметр("ТипБД", ТипБД);
	
	Если Не ПустаяСтрока(ИмяФайла) Тогда
		
		Запрос.Текст=Запрос.Текст+"
		|И ТаблицыADO.ИмяФайла=&ИмяФайла";
		
		Запрос.УстановитьПараметр("ИмяФайла",ИмяФайла);
		
	КонецЕсли;
	
	ТекущиеТаблицы = Запрос.Выполнить().Выгрузить();
	ТекущиеТаблицы.Индексы.Добавить("Имя");
	
	Отказ = Ложь;
	СтруктураТаблиц = УправлениеСоединениямиВИБУХ.ПолучитьСтруктуруADO(СтрокаСоединения);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Таблица Из СтруктураТаблиц Цикл
		
		ТекущаяТаблица = ТекущиеТаблицы.Найти(Таблица.Имя, "Имя");
		
		Если ТекущаяТаблица = Неопределено Тогда
			
			ОбъектТекущейТаблицы 				= Справочники.ТаблицыADO.СоздатьЭлемент();
			ОбъектТекущейТаблицы.Владелец 		= ТипБД;
			ОбъектТекущейТаблицы.Имя      		= Таблица.Имя;
			ОбъектТекущейТаблицы.Наименование 	= Таблица.Имя;
			ОбъектТекущейТаблицы.ИмяФайла 		= ИмяФайла;
			
			Попытка
				
				ОбъектТекущейТаблицы.Записать();
				НоваяСтрока = ТекущиеТаблицы.Добавить();
				НоваяСтрока.Имя = Таблица.Имя;
				НоваяСтрока.Ссылка = ОбъектТекущейТаблицы.Ссылка;
				НоваяСтрока.Существует=Истина;
				
			Исключение
				ПротоколируемыеСобытияВызовСервераУХ.ДобавитьЗаписьОшибка(ПРОТОКОЛИРУЕМОЕ_СОБЫТИЕ,,, Нстр("ru = 'Системная ошибка. Подробности в полном протоколе.'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
			
		Иначе
			
			ТекущаяТаблица.Существует = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
		
	Для Каждого Таблица Из СтруктураТаблиц Цикл
		
		ТекущаяТаблица = ТекущиеТаблицы.Найти(Таблица.Имя, "Имя");
		
		ТаблицаОбъект = ТекущаяТаблица.Ссылка.ПолучитьОбъект();
		
		ТаблицаОбъект.Реквизиты.Очистить();
		Для Каждого ПолеТаблицы Из Таблица.Колонки Цикл
			
			РеквизитТаблицы = ТаблицаОбъект.Реквизиты.Добавить();
			РеквизитТаблицы.Имя = ПолеТаблицы.Имя;
			РеквизитТаблицы.ВнутреннееПредставление = ПолеТаблицы.ВнутреннееПредставление;
			РеквизитТаблицы.ТипЗначения = ПолеТаблицы.ОписаниеТипов;
			
		КонецЦикла;
		
		ТаблицаОбъект.СвязанныеТаблицы.Очистить();
		Для Каждого Связь Из Таблица.Связи Цикл
			
			СвязаннаяТаблица = ТекущиеТаблицы.Найти(Связь.СвязаннаяТаблица, "Имя");
			
			НоваяСвязь = ТаблицаОбъект.СвязанныеТаблицы.Добавить();
			НоваяСвязь.СвязаннаяТаблица = СвязаннаяТаблица.Ссылка;
			НоваяСвязь.ПолеТекущейТаблицы = Связь.КолонкаТекущейТаблицы;
			НоваяСвязь.ПолеСвязаннойТаблицы = Связь.КолонкаСвязаннойТаблицы;
			
		КонецЦикла;
		
		Попытка
			ТаблицаОбъект.Записать();
		Исключение
			ПротоколируемыеСобытияУХ.ДобавитьЗаписьОшибка(ПРОТОКОЛИРУЕМОЕ_СОБЫТИЕ,,, Нстр("ru = 'Системная ошибка. Подробности в полном протоколе.'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	КонецЦикла;
	
	Если УдалятьТаблицы Тогда
		
		ТаблицыКУдалению=ТекущиеТаблицы.НайтиСтроки(Новый Структура("Существует",Ложь));
		
		Для Каждого Строка ИЗ ТаблицыКУдалению Цикл
			
			ТаблицаОбъект=Строка.Ссылка.ПолучитьОбъект();
			ТаблицаОбъект.ПометкаУдаления=Истина;
			ТаблицаОбъект.Записать();
			
		КонецЦикла;	
		
	КонецЕсли;
		
КонецПроцедуры

Функция ЗаменитьИмяТаблицыADO(Ссылка,СтароеИмя,НовоеИмя) Экспорт
	
	// Обрабатываем источники данных для расчетов
	
	НачатьТранзакцию();
	ПротоколируемыеСобытияУХ.Начать(Новый Структура("Ссылка",Ссылка));
	
	ЕстьОшибки=Ложь;
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	ИсточникиДанныхДляРасчетов.Ссылка
	|ИЗ
	|	Справочник.ИсточникиДанныхДляРасчетов КАК ИсточникиДанныхДляРасчетов
	|ГДЕ
	|	ИсточникиДанныхДляРасчетов.ТаблицаADO = &ТаблицаADO";
				 
	Запрос.УстановитьПараметр("ТаблицаADO",Ссылка);
	
	МассивПравил=Новый Массив;
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		СправочникОбъект=Результат.Ссылка.ПолучитьОбъект();
		
		СправочникОбъект.Наименование=СтрЗаменить(СправочникОбъект.Наименование,СтароеИмя,НовоеИмя);
		
		Для Каждого Строка ИЗ СправочникОбъект.ПравилаИспользованияПолейЗапроса Цикл
			
			Строка.ТаблицаАналитикиВИБ=СтрЗаменить(Строка.ТаблицаАналитикиВИБ,СтароеИмя,НовоеИмя);
			
			Если СтрНайти(Строка.КодАналитики,"Аналитика")>0 Тогда
				
				Строка.Поле		= СтрЗаменить(Строка.Поле,СтароеИмя,НовоеИмя);
				Строка.Синоним	= СтрЗаменить(Строка.Синоним,СтароеИмя,НовоеИмя);
				
			КонецЕсли;
			
		КонецЦикла;
		
		Для Каждого Строка ИЗ СправочникОбъект.ПравилаВычисленияПараметровЗапроса Цикл
			
			Строка.ТаблицаАналитикиВИБ=СтрЗаменить(Строка.ТаблицаАналитикиВИБ,СтароеИмя,НовоеИмя);
			
		КонецЦикла;
		
		СтруктураЗначенийИнтерфейс=СправочникОбъект.НастройкиОперандаИнтерфейс.Получить();
		
		Если ТипЗнч(СтруктураЗначенийИнтерфейс)=Тип("Структура") Тогда
			
			СправочникОбъект.НастройкиОперандаИнтерфейс=ОбновитьНастройкиИнтерфейса(СтруктураЗначенийИнтерфейс,СтароеИмя,НовоеИмя);
			
		КонецЕсли;
		
		Попытка
			
			СправочникОбъект.Записать();
			
			Если ТипЗнч(СправочникОбъект.НазначениеРасчетов)=Тип("СправочникСсылка.ПравилаОбработки") 
				И МассивПравил.Найти(СправочникОбъект.НазначениеРасчетов)=Неопределено Тогда
				
				МассивПравил.Добавить(СправочникОбъект.НазначениеРасчетов);
				
			КонецЕсли;
			
		Исключение
			
			ПротоколируемыеСобытияУХ.ДобавитьЗаписьОшибка("Справочник.ТаблицыADO.МодульМенеджера.ЗаменитьИмяТаблицыADO.1",,,СтрШаблон(Нстр("ru = 'Не удалось обновить источник данных %1 показателя 
			|%2 виды отчета %3, правило обработки %4.'"), 
			СправочникОбъект.Наименование, 
			СправочникОбъект.ПотребительРасчета, 
			СправочникОбъект.ПотребительРасчета.Владелец, 
			СправочникОбъект.НазначениеРасчетов), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЕстьОшибки=Истина;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Запрос.Текст="ВЫБРАТЬ
	|	СоответствиеПолейДляОбменаВИБ.Ссылка
	|ИЗ
	|	Справочник.СоответствиеПолейДляОбменаВИБ КАК СоответствиеПолейДляОбменаВИБ
	|ГДЕ
	|	СоответствиеПолейДляОбменаВИБ.Владелец.ОписаниеОбъектаВИБ = &ОписаниеОбъектаВИБ";
	
	Запрос.УстановитьПараметр("ОписаниеОбъектаВИБ",Ссылка);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		СправочникОбъект=Результат.Ссылка.ПолучитьОбъект();
				
		Для Каждого Строка ИЗ СправочникОбъект.ТаблицаПолейДляИмпорта Цикл
			
			Строка.ТаблицаАналитикиВИБ=СтрЗаменить(Строка.ТаблицаАналитикиВИБ,СтароеИмя,НовоеИмя);
			
		КонецЦикла;
		
		Попытка
			
			СправочникОбъект.Записать();
						
		Исключение
			
			ПротоколируемыеСобытияУХ.ДобавитьЗаписьОшибка("Справочник.ТаблицыADO.МодульМенеджера.ЗаменитьИмяТаблицыADO.2",,,СтрШаблон(Нстр("ru = 'Не удалось обновить настройку соответствия %1.'"), 
				СправочникОбъект.Владелец.Наименование), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЕстьОшибки=Истина;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Запрос.Текст="ВЫБРАТЬ
	|	СоответствиеВнешнимИБ.Ссылка
	|ИЗ
	|	Справочник.СоответствиеВнешнимИБ КАК СоответствиеВнешнимИБ
	|ГДЕ
	|	СоответствиеВнешнимИБ.ОписаниеОбъектаВИБ = &ОписаниеОбъектаВИБ";
	
	Запрос.УстановитьПараметр("ОписаниеОбъектаВИБ",Ссылка);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		СправочникОбъект=Результат.Ссылка.ПолучитьОбъект();
		СправочникОбъект.Наименование=СправочникОбъект.ТипОбъектаКонсолидации+"."+СправочникОбъект.ИмяОбъектаМетаданных+" -> "+СправочникОбъект.ТипОбъектаВИБ+"."+НовоеИмя;
		
		СправочникОбъект.ОбменДанными.Загрузка=Истина;
		
		Попытка
			
			СправочникОбъект.Записать();
						
		Исключение
			
			ПротоколируемыеСобытияУХ.ДобавитьЗаписьОшибка("Справочник.ТаблицыADO.МодульМенеджера.ЗаменитьИмяТаблицыADO.3",,,СтрШаблон(Нстр("ru = 'Не удалось обновить настройку соответствия %1.'"), 
				СправочникОбъект.Владелец.Наименование), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		КонецПопытки;
		
	КонецЦикла;

	Если НЕ ЕстьОшибки Тогда
		
		Для Каждого Правило ИЗ МассивПравил Цикл
			
			УправлениеОтчетамиУХ.СформироватьДанныеРегистраПараметрическихНастроек(Правило);
			
		КонецЦикла;
		
		ПротоколируемыеСобытияУХ.Отменить();
		ЗафиксироватьТранзакцию();
		Возврат Истина;
		
	Иначе
		
		ПротоколируемыеСобытияУХ.Завершить(,,,,Ложь);
		ОтменитьТранзакцию();
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции // ЗаменитьИмяТаблицыADO()
	
Функция ОбновитьНастройкиИнтерфейса(СтруктураЗначенийИнтерфейс,СтароеИмя,НовоеИмя)
	
	Для Каждого Строка ИЗ СтруктураЗначенийИнтерфейс.ТабПравилаВычисленияПараметров Цикл
		
		Строка.ТаблицаАналитикиВИБ=СтрЗаменить(Строка.ТаблицаАналитикиВИБ,СтароеИмя,НовоеИмя);
		
	КонецЦикла;
	
	Если НЕ СтруктураЗначенийИнтерфейс.мТаблицаПоказателейБД.Колонки.Найти("ТаблицаADO")=Неопределено Тогда
		
		Для Каждого Строка ИЗ СтруктураЗначенийИнтерфейс.мТаблицаПоказателейБД Цикл
			
			Строка.ТаблицаADO=СтрЗаменить(Строка.ТаблицаADO,СтароеИмя,НовоеИмя);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если НЕ СтруктураЗначенийИнтерфейс.ТабличноеПолеИзмеренийБД.Колонки.Найти("ТаблицаADO")=Неопределено Тогда
		
		Для Каждого Строка ИЗ СтруктураЗначенийИнтерфейс.ТабличноеПолеИзмеренийБД.Строки Цикл
			
			Строка.ТаблицаADO=СтрЗаменить(Строка.ТаблицаADO,СтароеИмя,НовоеИмя);
			
			ОбновитьПодчиненныеСтроки(Строка.Строки,СтароеИмя,НовоеИмя);
			
		КонецЦикла;
		
	КонецЕсли;
		
	Возврат Новый ХранилищеЗначения(СтруктураЗначенийИнтерфейс);
	
КонецФункции // ОбновитьНастройкиИнтерфейса()

Процедура ОбновитьПодчиненныеСтроки(Строки,СтароеИмя,НовоеИмя)
	
	Для Каждого Строка ИЗ Строки Цикл
		
		  Строка.ТаблицаADO=СтрЗаменить(Строка.ТаблицаADO,СтароеИмя,НовоеИмя);
		  
		  ОбновитьПодчиненныеСтроки(Строка.Строки,СтароеИмя,НовоеИмя);
		  
	КонецЦикла;
	
КонецПроцедуры // ОбновитьПодчиненныеСтроки() 
	
#КонецЕсли