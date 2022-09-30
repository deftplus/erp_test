#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУДЛЯ

Перем ПрошлыйПометкаУдаления;
Перем ПреобразованиеВерсииПериода Экспорт;
Перем СтруктураРеквизитов Экспорт;
Перем КэшПрофилейОрганизаций;
Перем ПолученКопированием Экспорт;

Перем ТребуетсяПроведение;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция определяет набор реквизитов, нельзя изменять пользователю.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Структура, в качестве ключей элементов содержит имена реквизитов.
//
Функция НеИзменяемыеРеквизиты() Экспорт
	
	НеИзменяемыеРеквизиты = Новый Структура;
	Если ЭтоНовый() Тогда
		Возврат НеИзменяемыеРеквизиты;
	КонецЕсли;
	
	ОписаниеОшибки = "";
	Если НЕ Документы.УправлениеПериодомСценария.ПроверитьВозможностьИзмененияПериодаСценария(Ссылка,ОписаниеОшибки) Тогда
		НеИзменяемыеРеквизиты.Вставить("Сценарий");
		НеИзменяемыеРеквизиты.Вставить("ПериодСценария");
		НеИзменяемыеРеквизиты.Вставить("ПериодСценарияОкончание");	
		НеИзменяемыеРеквизиты.Вставить("ВерсияОрганизационнойСтруктуры");
		НеИзменяемыеРеквизиты.Вставить("ПометкаУдаления");
	КонецЕсли;	
			
	Возврат НеИзменяемыеРеквизиты;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ
//

Функция ПодготовитьТаблицуЗначенийЗаполненияУниверсальныйПроцесс() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&Период КАК Период,
	|	&Сценарий КАК Сценарий,
	|	&ПериодСценария КАК ПериодСценария,
	|	ОрганизационныеЕдиницыЭтаповПроцессов.ОрганизационнаяЕдиница КАК Организация,
	|	ОрганизационныеЕдиницыЭтаповПроцессов.ЭтапПроцесса КАК ЭтапПроцесса,
	|	ЗНАЧЕНИЕ(Перечисление.СостоянияЭтаповПроцессов.Запланирован) КАК СостояниеЭтапа,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаНачала,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаОкончания,
	|	ОрганизационныеЕдиницыЭтаповПроцессов.Ответственный КАК ОтветственныйЗаЭтап
	|ИЗ
	|	РегистрСведений.ОрганизационныеЕдиницыЭтаповПроцессов КАК ОрганизационныеЕдиницыЭтаповПроцессов
	|ГДЕ
	|	ОрганизационныеЕдиницыЭтаповПроцессов.ВерсияРегламентаПодготовкиОтчетности = &ВерсияРегламентаПодготовкиОтчетности
	|	И ОрганизационныеЕдиницыЭтаповПроцессов.ЭтапПроцесса.ТипЭтапа = ЗНАЧЕНИЕ(Перечисление.ТипыЭтаповУниверсальныхПроцессов.ЭтапПроцессаПодготовкиОтчетности)
	|	И НЕ ОрганизационныеЕдиницыЭтаповПроцессов.ЭтапПроцесса.ПометкаУдаления
	|	И ОрганизационныеЕдиницыЭтаповПроцессов.ЭтапПроцесса.Владелец = &ШаблонПроцесса";
	ШаблонРегламента = РасширениеПроцессыИСогласованиеУХ.ПолучитьПустойШаблон();
	РасширениеБизнесЛогикиУХ.УправлениеПериодом_ОпределитьСвязанныйШаблон(ВерсияОрганизационнойСтруктуры, ШаблонРегламента);
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("Сценарий", Сценарий);
	Запрос.УстановитьПараметр("ПериодСценария", ПериодСценария);
	Запрос.УстановитьПараметр("ВерсияРегламентаПодготовкиОтчетности", ВерсияОрганизационнойСтруктуры);
	Запрос.УстановитьПараметр("ШаблонПроцесса", ШаблонРегламента);
	
	ДвиженияСостоянияВыполненияПроцессов = Запрос.Выполнить().Выгрузить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ОрганизационныеЕдиницыЭтаповПроцессов.ЭтапПроцесса КАК ЭтапПроцесса,
	|	ОрганизационныеЕдиницыЭтаповПроцессов.ЭтапПроцесса.ДлительностьПлановая КАК ДлительностьДней
	|ПОМЕСТИТЬ ЭтапыПроцесса
	|ИЗ
	|	РегистрСведений.ОрганизационныеЕдиницыЭтаповПроцессов КАК ОрганизационныеЕдиницыЭтаповПроцессов
	|ГДЕ
	|	ОрганизационныеЕдиницыЭтаповПроцессов.ВерсияРегламентаПодготовкиОтчетности = &ВерсияРегламентаПодготовкиОтчетности
	|	И НЕ ОрганизационныеЕдиницыЭтаповПроцессов.ЭтапПроцесса.ПометкаУдаления
	|	И ОрганизационныеЕдиницыЭтаповПроцессов.ЭтапПроцесса.Владелец = &ШаблонПроцесса
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЭтапыУниверсальныхПроцессов.Ссылка,
	|	0
	|ИЗ
	|	Справочник.ЭтапыУниверсальныхПроцессов КАК ЭтапыУниверсальныхПроцессов
	|ГДЕ
	|	НЕ ЭтапыУниверсальныхПроцессов.ПометкаУдаления
	|	И ЭтапыУниверсальныхПроцессов.Владелец = &ШаблонПроцесса
	|	И ЭтапыУниверсальныхПроцессов.ТипЭтапа <> ЗНАЧЕНИЕ(Перечисление.ТипыЭтаповУниверсальныхПроцессов.ЭтапПроцессаПодготовкиОтчетности)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЭтапПроцесса
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭтапыПроцессовЭтапыПредшественники.Ссылка КАК ЭтапПроцесса,
	|	ЭтапыПроцессовЭтапыПредшественники.Этап КАК ЭтапПредшественник
	|ПОМЕСТИТЬ ЭтапыПредшественники
	|ИЗ
	|	ЭтапыПроцесса КАК ЭтапыПроцесса
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЭтапыУниверсальныхПроцессов.ЭтапыПредшественники КАК ЭтапыПроцессовЭтапыПредшественники
	|		ПО ЭтапыПроцесса.ЭтапПроцесса = ЭтапыПроцессовЭтапыПредшественники.Ссылка
	|ГДЕ
	|	ЭтапыПроцессовЭтапыПредшественники.Этап В
	|			(ВЫБРАТЬ
	|				Т.ЭтапПроцесса
	|			ИЗ
	|				ЭтапыПроцесса КАК Т)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЭтапПроцесса
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭтапыПроцесса.ЭтапПроцесса КАК ЭтапПроцесса,
	|	ЭтапыПроцесса.ДлительностьДней КАК ДлительностьПлановая,
	|	ЕСТЬNULL(ЭтапыПредшественники.ЭтапПредшественник, ЗНАЧЕНИЕ(Справочник.ЭтапыУниверсальныхПроцессов.ПустаяСсылка)) КАК ЭтапПредшественник
	|ИЗ
	|	ЭтапыПроцесса КАК ЭтапыПроцесса
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЭтапыПредшественники КАК ЭтапыПредшественники
	|		ПО ЭтапыПроцесса.ЭтапПроцесса = ЭтапыПредшественники.ЭтапПроцесса
	|ИТОГИ
	|	МАКСИМУМ(ДлительностьПлановая)
	|ПО
	|	ЭтапПроцесса";
	Запрос.УстановитьПараметр("ШаблонПроцесса", ШаблонРегламента);
	Запрос.УстановитьПараметр("ВерсияРегламентаПодготовкиОтчетности", ВерсияОрганизационнойСтруктуры);
	ДеревоЭтапов = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	ДлительностьЭтапов = Новый Соответствие;
	Пока ДлительностьЭтапов.Количество() < ДеревоЭтапов.Строки.Количество() Цикл
		
		ПосчитаноЭтапов = ДлительностьЭтапов.Количество();
		
		Для Каждого СтрокаЭтапа Из ДеревоЭтапов.Строки Цикл
			Если НЕ ДлительностьЭтапов.Получить(СтрокаЭтапа.ЭтапПроцесса) = Неопределено Тогда 
				Продолжить;
			Иначе
				ДлительностьПредыдущих = 0;
				Для Каждого СтрокаЭтапаПредшественника Из СтрокаЭтапа.Строки Цикл
					Если НЕ ЗначениеЗаполнено(СтрокаЭтапаПредшественника.ЭтапПредшественник) Тогда
						Продолжить;
					КонецЕсли;
					ДлительностьЭтапаПредшественника = ДлительностьЭтапов.Получить(СтрокаЭтапаПредшественника.ЭтапПредшественник);
					Если ДлительностьЭтапаПредшественника = Неопределено Тогда
						ДлительностьПредыдущих = Неопределено;
						Прервать;
					ИначеЕсли ДлительностьЭтапаПредшественника.Окончание > ДлительностьПредыдущих Тогда
						ДлительностьПредыдущих = ДлительностьЭтапаПредшественника.Окончание;
					КонецЕсли;
				КонецЦикла;
				Если НЕ ДлительностьПредыдущих = Неопределено Тогда
					СтруктураДлительности = Новый Структура;
					СтруктураДлительности.Вставить("Начало", ДлительностьПредыдущих);
					СтруктураДлительности.Вставить("Окончание", СтрокаЭтапа.ДлительностьПлановая + ДлительностьПредыдущих);
					ДлительностьЭтапов.Вставить(СтрокаЭтапа.ЭтапПроцесса, СтруктураДлительности);
				КонецЕсли; 
			КонецЕсли;
		КонецЦикла;
		
		Если ПосчитаноЭтапов = ДлительностьЭтапов.Количество() Тогда
			ДлительностьЭтапов = Неопределено;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если НЕ ДлительностьЭтапов = Неопределено Тогда
		Для Каждого Строка Из ДвиженияСостоянияВыполненияПроцессов Цикл
			СтруктураДлительности = ДлительностьЭтапов.Получить(Строка.ЭтапПроцесса);
			Если СтруктураДлительности <> Неопределено Тогда
				Строка.ДатаНачала = ДатаНачалаПроцесса + СтруктураДлительности.Начало*60*60;
				Строка.ДатаОкончания = ДатаНачалаПроцесса + СтруктураДлительности.Окончание*60*60;
			Иначе
				Строка.ДатаНачала = ДатаНачалаПроцесса;
				Строка.ДатаОкончания = ДатаНачалаПроцесса;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ДвиженияСостоянияВыполненияПроцессов;
	
КонецФункции

Функция ПроверитьНаличиеДругихДокументовДляДанногоПериодаИСценария(Отказ,ШапкаОшибки) Экспорт
		
	    //Проверяем, что не существует документа УОП:
		//1. пересекающегося с текущим диапазоном
		//2. где дата окончания периода не совпадает с датой начала текущего (если заполнена)
		//3. где дата начала периода не совпалает с датой окончания текущего (если заполнена)
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	УправлениеПериодомСценария.Ссылка КАК Ссылка,
		|	УправлениеПериодомСценария.ТекущаяПериодичность КАК ТекущаяПериодичность
		|ИЗ
		|	Документ.УправлениеПериодомСценария КАК УправлениеПериодомСценария
		|ГДЕ
		|	УправлениеПериодомСценария.Сценарий = &Сценарий
		|	И НЕ УправлениеПериодомСценария.Ссылка = &Ссылка
		|	И УправлениеПериодомСценария.ПериодСценария.ДатаНачала <= &ДатаОкончания
		|	И УправлениеПериодомСценария.ПериодСценария.ДатаОкончания >= &ДатаНачала
		|	И УправлениеПериодомСценария.ПометкаУдаления = ЛОЖЬ
		|	И УправлениеПериодомСценария.ТекущаяПериодичность = &ТекущаяПериодичность";
		
		Запрос.УстановитьПараметр("Сценарий",       Сценарий);
		Запрос.УстановитьПараметр("Ссылка",         Ссылка);
		Запрос.УстановитьПараметр("ДатаНачала",ПериодСценария.ДатаНачала);
		Запрос.УстановитьПараметр("ДатаОкончания",ПериодСценарияОкончание.ДатаНачала);
		Запрос.УстановитьПараметр("ТекущаяПериодичность",ТекущаяПериодичность);
		
		Если Не  Запрос.Выполнить().Пустой() Тогда
			ОбщегоНазначенияУХ.СообщитьОбОшибке(НСтр("ru = ' Уже существует другой документ с пересекающимся периодом '"), Отказ, ШапкаОшибки);
		КонецЕсли;

		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	УправлениеПериодомСценария.Ссылка КАК Ссылка,
		|	УправлениеПериодомСценария.ПериодСценария КАК ПериодСценария,
		|	УправлениеПериодомСценария.ПериодСценарияОкончание КАК ПериодСценарияОкончание,
		|	УправлениеПериодомСценария.ТекущаяПериодичность КАК ТекущаяПериодичность
		|ИЗ
		|	Документ.УправлениеПериодомСценария КАК УправлениеПериодомСценария
		|ГДЕ
		|	УправлениеПериодомСценария.Сценарий = &Сценарий
		|	И НЕ УправлениеПериодомСценария.Ссылка = &Ссылка
		|	И УправлениеПериодомСценария.ПериодСценария.ДатаНачала >= &ДатаОкончания
		|	И УправлениеПериодомСценария.ПометкаУдаления = ЛОЖЬ
		|	И УправлениеПериодомСценария.ТекущаяПериодичность = &ТекущаяПериодичность
		|
		|УПОРЯДОЧИТЬ ПО
		|	УправлениеПериодомСценария.ПериодСценария.ДатаНачала";
				
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	УправлениеПериодомСценария.Ссылка КАК Ссылка,
		|	УправлениеПериодомСценария.ПериодСценария КАК ПериодСценария,
		|	УправлениеПериодомСценария.ПериодСценарияОкончание КАК ПериодСценарияОкончание,
		|	УправлениеПериодомСценария.ТекущаяПериодичность КАК ТекущаяПериодичность
		|ИЗ
		|	Документ.УправлениеПериодомСценария КАК УправлениеПериодомСценария
		|ГДЕ
		|	УправлениеПериодомСценария.Сценарий = &Сценарий
		|	И НЕ УправлениеПериодомСценария.Ссылка = &Ссылка
		|	И УправлениеПериодомСценария.ПериодСценарияОкончание.ДатаНачала <= &ДатаНачала
		|	И УправлениеПериодомСценария.ПометкаУдаления = ЛОЖЬ
		|	И УправлениеПериодомСценария.ТекущаяПериодичность = &ТекущаяПериодичность
		|
		|УПОРЯДОЧИТЬ ПО
		|	УправлениеПериодомСценария.ПериодСценарияОкончание.ДатаНачала УБЫВ";
	
	    Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

Процедура ЗаполнитьДанныеНаОснованииВерсииОрганизационнойСтруктуры() Экспорт
	
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ, ВЫЗЫВАЕМЫЕ ИЗ ОБРАБОТЧИКОВ

Процедура ЗаполнитьДвиженияДокументаУниверсальныйПроцесс(Отказ, ШапкаОшибки)
	
	
	ЭкземплярПроцесса = Неопределено;
	ШаблонПроцесса = Неопределено;
	РасширениеБизнесЛогикиУХ.УправлениеПериодом_ОпределитьСвязанныйШаблон(Ссылка.ВерсияОрганизационнойСтруктуры,ШаблонПроцесса);
	ПроцессЗапущен = Ложь;
	РасширениеБизнесЛогикиУХ.УправлениеПериодом_ПроцессЗапущен(Ссылка,ПроцессЗапущен);

	ДвиженияСостоянияВыполненияПроцессов = ПодготовитьТаблицуЗначенийЗаполненияУниверсальныйПроцесс();
	Если ДвиженияСостоянияВыполненияПроцессов = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	Иначе
	   РасширениеПроцессыИСогласованиеУХ.СоздатьНаборЗаписейСостоянияВыполненияПроцессовУправлениеПериодами(ПериодСценария, Сценарий, ДвиженияСостоянияВыполненияПроцессов);
   КонецЕсли;

	Если Не ПроцессЗапущен Тогда			
		РасширениеБизнесЛогикиУХ.УправлениеПериодом_ИнициализироватьПроцесс(ШаблонПроцесса,Ссылка,ЭкземплярПроцесса);	
	КонецЕсли;	
	
КонецПроцедуры 
 
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ОБЪЕКТА

// Процедура - обработчик события объекта "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ШапкаОшибки = НСтр("ru = '%Объект% не может быть записан:'");
	ШапкаОшибки = СтрЗаменить(ШапкаОшибки, "%Объект%", Строка(ЭтотОбъект));
	
	
	Если НЕ  ЗначениеЗаполнено(ПериодСценарияОкончание) Тогда		
		ПериодСценарияОкончание 	= ПериодСценария;		 		
	КонецЕсли;
	
	
	Если ЗначениеЗаполнено(ПериодСценария) Тогда
		ТекущаяПериодичность = ПериодСценария.Периодичность;
	КонецЕсли;
		
	Если Не ЗначениеЗаполнено(ТекущаяПериодичность) Тогда
		ОбщегоНазначенияУХ.СообщитьОбОшибке(НСтр("ru = ' - не заполнено значение обязательного реквизита ""Периодичность""!'"), Отказ, ШапкаОшибки);
	КонецЕсли;
	
	ШапкаОшибкиОшибкиИзмененияКлючевыхРеквизитов = "";
	Если НЕ Документы.УправлениеПериодомСценария.ПроверитьВозможностьИзмененияПериодаСценария(Ссылка,ШапкаОшибкиОшибкиИзмененияКлючевыхРеквизитов) Тогда		
		ОбщегоНазначенияУХ.ПроверитьНеИзменяемыеРеквизиты(ЭтотОбъект, Отказ, ШапкаОшибкиОшибкиИзмененияКлючевыхРеквизитов);	
	КонецЕсли;		
	
	РежимСкользящегоПлана = ЭтотОбъект.Сценарий.РежимПланирования = Перечисления.РежимыПланирования.СкользящееПланирование;
	
	Если РежимСкользящегоПлана И ВерсияОрганизационнойСтруктуры.ИспользоватьПроцесс тогда
		
		СтрокаШаблона = Нстр("ru = ' - в сценарии ""%1"" установлен режим планирования ""%2"". В Регламенте ""%3"" нельзя использовать процесс!'");
		
		Если ЗначениеЗаполнено(СтрокаШаблона) тогда 
			ОбщегоНазначенияУХ.СообщитьОбОшибке(СтрШаблон(СтрокаШаблона, 
				Сценарий, Перечисления.РежимыПланирования.СкользящееПланирование, ВерсияОрганизационнойСтруктуры), Отказ, ШапкаОшибки);
		КонецЕсли;
		
		Отказ = Истина;
		
	КонецЕсли;
	
	Если Отказ Тогда
		 Возврат;
	КонецЕсли;	
	
	//Если Не ЗначениеЗаполнено(ГраницаАктуализации) И РежимСкользящегоПлана Тогда
	//	 ГраницаАктуализации = ПериодСценария;
	//КонецЕсли;	
	
	Если Не РежимСкользящегоПлана Тогда
		Если ЭтотОбъект.Сценарий <> ЭтотОбъект.Ссылка.Сценарий 
			ИЛИ  ЭтотОбъект.ПериодСценария <> ЭтотОбъект.Ссылка.ПериодСценария 
			ИЛИ  ЭтотОбъект.ПериодСценарияОкончание <> ЭтотОбъект.Ссылка.ПериодСценарияОкончание
			ИЛИ  ЭтотОбъект.ВерсияОрганизационнойСтруктуры <> ЭтотОбъект.Ссылка.ВерсияОрганизационнойСтруктуры Тогда
			Документы.УправлениеПериодомСценария.ОчиститьБлокировкуПериодов(Ссылка);
		КонецЕсли;	
	КонецЕсли;
	// Запрет запуска процесса, если не указан шаблон.
	ШаблонПроцесса = Неопределено;
	РасширениеБизнесЛогикиУХ.УправлениеПериодом_ОпределитьСвязанныйШаблон(Ссылка.ВерсияОрганизационнойСтруктуры,ШаблонПроцесса);
	Если ШаблонПроцесса = Неопределено Тогда
		ЗапускатьПроцесс = Ложь;
	Иначе
		// Шаблон указан. Не изменяем флаг запуска процесса.
	КонецЕсли;

	Если ЗапускатьПроцесс Тогда
		
		Если НЕ ЗначениеЗаполнено(ДатаНачалаПроцесса) Тогда
			ОбщегоНазначенияУХ.СообщитьОбОшибке(НСтр("ru = '- не заполнено значение обязательного реквизита ""Дата начала процесса""!'"), Отказ, ШапкаОшибки);
		КонецЕсли;
		
		Если (ЭтоНовый() ИЛИ НЕ Ссылка.ЗапускатьПроцесс) И ПериодЗакрыт Тогда
			ОбщегоНазначенияУХ.СообщитьОбОшибке(НСтр("ru = ' - период закрыт. Запуск процесса невозможен'"), Отказ, ШапкаОшибки);
		КонецЕсли;
		
	КонецЕсли;
	
	ПроверитьНаличиеДругихДокументовДляДанногоПериодаИСценария(Отказ,ШапкаОшибки); 
	
	Если НЕ ПометкаУдаления Тогда
		Если УстанавливатьЛимиты Тогда
			ПараметрыУОП = Новый Структура("ТекущаяПериодичность, ВерсияОрганизационнойСтруктуры, ВидыОтчетовДляУстановкиЛимитов, ПериодСценария, ПериодСценарияОкончание");
			ЗаполнитьЗначенияСвойств(ПараметрыУОП, ЭтотОбъект);
			ПараметрыУОП.ВидыОтчетовДляУстановкиЛимитов = ЭтотОбъект.ВидыОтчетовДляУстановкиЛимитов.Выгрузить();
			РезультатВозможнаУстановкаЛимитов = УстановкаЛимитовУХ.ВозможнаУстановкаЛимитовИзУОП(ПараметрыУОП);
			Если Не РезультатВозможнаУстановкаЛимитов.ВозможнаУстановка Тогда
				ОбщегоНазначенияУХ.СообщитьОбОшибке(ЭтотОбъект, Отказ, РезультатВозможнаУстановкаЛимитов.ТекстОшибки);
			КонецЕсли;
		Иначе
			Если УстановкаЛимитовУХ.УстановленыЛимитыПоУОП(Ссылка) Тогда
				ТекстСообщения = Нстр("ru = 'По некоторым экземплярам УОП лимиты уже установлены.
				|Необходимо отменить установку лимитов и после чего повторить попытку изменения необходимости установки лимитов УОП.'");
				ОбщегоНазначенияУХ.СообщитьОбОшибке(ЭтотОбъект, Отказ, ТекстСообщения);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
		
	Если Не ЗначениеЗаполнено(ПериодСценарияОкончание) Тогда
		ОбщегоНазначенияУХ.СообщитьОбОшибке(НСтр("ru = ' - Не выбран период окончания действия документа. Запись документа невозможна'"), Отказ, ШапкаОшибки);
	КонецЕсли;
	Если НЕ ТекущаяПериодичность = ПериодСценарияОкончание.Периодичность ИЛИ НЕ ТекущаяПериодичность = ПериодСценария.Периодичность Тогда
		ОбщегоНазначенияУХ.СообщитьОбОшибке(НСтр("ru = ' - Не совпадают периодичности сценария и периодов действия документа. Запись документа невозможна'"), Отказ, ШапкаОшибки);
	КонецЕсли;	 
	Если ПериодСценарияОкончание.ДатаНачала < ПериодСценария.ДатаНачала Тогда
		ОбщегоНазначенияУХ.СообщитьОбОшибке(НСтр("ru = ' - Период окончания не может быть меньше периода начала действия документа. Запись документа невозможна'"), Отказ, ШапкаОшибки);
	КонецЕсли;	 
	
	ПрошлыйПометкаУдаления = Ссылка.ПометкаУдаления;
	
	ТребуетсяПроведение=НЕ Ссылка.Проведен;
	
	Если ПометкаУдаления Тогда		
		Документы.УправлениеПериодомСценария.ОчиститьБлокировкуПериодов(Ссылка);		 
	Иначе	 
		Если ПериодЗакрыт И (НЕ Ссылка.ПериодЗакрыт)  Тогда	
			Попытка	
				Документы.УправлениеПериодомСценария.ВыполнитьРегламентЗакрытияПериода(Ссылка);			
			Исключение	
				Отказ = Истина;		
			КонецПопытки;			
		КонецЕсли;		 
	КонецЕсли;	
	
КонецПроцедуры

// Процедура - обработчик события объекта "ПриЗаписи".
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаШаблона = Нстр("ru = '%1 не может быть записан:'");
	
	ШапкаОшибки = "";
	Если ЗначениеЗаполнено(СтрокаШаблона) тогда 				
		ШапкаОшибки = СтрШаблон(СтрокаШаблона, ЭтотОбъект);
	КонецЕсли;
		
	ЗаполнитьНастройкиПодПериодов();	
	
	Если ЗапускатьПроцесс И НЕ (ПометкаУдаления ИЛИ ПериодЗакрыт) Тогда
	
		ЗаполнитьДвиженияДокументаУниверсальныйПроцесс(Отказ, ШапкаОшибки);
			
	КонецЕсли;
	
	Документы.УправлениеПериодомСценария.ЗаполнитьПериодическиеКурсыПоУмолчанию(ЭтотОбъект);
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ПолученКопированием  = Истина;
	ЗапускатьПроцесс     = Ложь;
	ПериодЗакрыт         = Ложь;
	Пользователь         = ОбщегоНазначенияУХ.ПолучитьЗначениеПеременной("глТекущийПользователь");
	ЭкземплярПроцесса	 = РасширениеПроцессыИСогласованиеУХ.ПолучитьПустойЭкземплярПроцесса();
	
КонецПроцедуры

Процедура ОткрытьСледующийПериод() Экспорт
	
	Если РежимСкользящегоПлана Тогда
		ОткрытьСледующийПериодСкользящееПланирование();
	Иначе	
		ОткрытьСледующийПериодФиксированныйГоризонт();
	КонецЕсли;	
			
КонецПроцедуры // ОткрытьСледующийПериод() 

Процедура ОткрытьПредыдущийПериод() Экспорт
	
	ОткрытьПредыдущийПериодСкользящееПланирование();
					
КонецПроцедуры // ОткрытьСледующийПериод() 

Процедура СоздатьСледующйДокументПериодичностьНеОпределена(НовыйПериод,НовыйПериодОкончание)
	
	Запрос=Новый Запрос;
	
	// Определим документ управления периодом сценария для нового периода и, при необходимости, создадим его
	
	Запрос.Текст=
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	УправлениеПериодомСценария.Ссылка КАК УправлениеПериодом,
	|	УправлениеПериодомСценария.ЗапускатьПроцесс КАК ЗапускатьПроцесс,
	|	УправлениеПериодомСценария.ВерсияОрганизационнойСтруктуры.ШаблонПроцесса КАК ШаблонПроцесса
	|ИЗ
	|	Документ.УправлениеПериодомСценария КАК УправлениеПериодомСценария
	|ГДЕ
	|	УправлениеПериодомСценария.Сценарий = &СценарийПлан
	|	И УправлениеПериодомСценария.ПериодСценария = &НовыйПериод";
	
	Запрос.УстановитьПараметр("НовыйПериод",НовыйПериод);
	Запрос.УстановитьПараметр("СценарийПлан",Сценарий);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		
		Если ЗначениеЗаполнено(Результат.УправлениеПериодом) Тогда
			
			Если (НЕ Результат.ЗапускатьПроцесс) И (ЗапускатьПроцесс) Тогда
				
				// Запустим процесс подготовки бюджетов
				
				УправлениеПериодом=Результат.УправлениеПериодом.ПолучитьОбъект();
				
				Если УправлениеПериодом.ВерсияОрганизационнойСтруктуры = Справочники.ВерсииРегламентовПодготовкиОтчетности.ПустаяСсылка() Тогда
					
					УправлениеПериодом.ДатаНачалаПроцесса=УправлениеОтчетамиУХ.ПолучитьДатуСоСмещением(ДатаНачалаПроцесса, НовыйПериод.Периодичность, 1);					
					УправлениеПериодом.ВерсияОрганизационнойСтруктуры.Загрузить(ВерсияОрганизационнойСтруктуры);
					
				КонецЕсли;
				
				УправлениеПериодом.ЗапускатьПроцесс=Истина;
			
				Попытка
					
					УправлениеПериодом.Записать(РежимЗаписиДокумента.Запись);
					
				Исключение
					
					СтрокаШаблона = Нстр("ru = 'Не удалось записать документ ""Управление периодом сценария для следующего периода"".
					|%1'");
					
					Если ЗначениеЗаполнено(СтрокаШаблона) тогда 				
						Сообщить(СтрШаблон(СтрокаШаблона, ОписаниеОшибки()), СтатусСообщения.Внимание);
					КонецЕсли;
					
					Возврат;
					
				КонецПопытки;
				
			КонецЕсли;
			
			НовыйПериодСценарий=Результат.УправлениеПериодом;
			
		Иначе
			
			// Создадим новый документ "Управление периодом сценария"
			НовыйПериодСценарий=УправлениеРабочимиПроцессамиУХ.ОпределитьДокументУправленияПериодомСценария(Сценарий,НовыйПериод,Ссылка);
			Если  НовыйПериодСценарий=Неопределено Тогда
				ПериодОткрыт=Ложь;
				Возврат;
			КонецЕсли;
			
		КонецЕсли;			
		
	Иначе
		
		// Создадим новый документ "Управление периодом сценария"
		НовыйПериодСценарий=УправлениеРабочимиПроцессамиУХ.ОпределитьДокументУправленияПериодомСценария(Сценарий,НовыйПериод,Ссылка);
		Если НовыйПериодСценарий=Неопределено Тогда
			ПериодОткрыт=Ложь;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура СоздатьСледующйДокументПериодичностьОпределена(НовыйПериод,НовыйПериодОкончание)

	Запрос=Новый Запрос;
	
	// Определим документ управления периодом сценария для нового периода и, при необходимости, создадим его
	
	Запрос.Текст=
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	УправлениеПериодомСценария.Ссылка КАК УправлениеПериодом,
	|	УправлениеПериодомСценария.ЗапускатьПроцесс КАК ЗапускатьПроцесс,
	|	УправлениеПериодомСценария.ВерсияОрганизационнойСтруктуры.ШаблонПроцесса КАК ШаблонПроцесса
	|ИЗ
	|	Документ.УправлениеПериодомСценария КАК УправлениеПериодомСценария
	|ГДЕ
	|	УправлениеПериодомСценария.Сценарий = &СценарийПлан
	|	И УправлениеПериодомСценария.ПериодСценария = &НовыйПериод";
	
	Запрос.УстановитьПараметр("НовыйПериод",ПериодСценарияОкончание);
	Запрос.УстановитьПараметр("СценарийПлан",Сценарий);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		
		Если ЗначениеЗаполнено(Результат.УправлениеПериодом) Тогда
			
			Если (НЕ Результат.ЗапускатьПроцесс) И (ЗапускатьПроцесс) Тогда
				
				// Запустим процесс подготовки бюджетов
				
				УправлениеПериодом=Результат.УправлениеПериодом.ПолучитьОбъект();
				
				Если УправлениеПериодом.ВерсияОрганизационнойСтруктуры = Справочники.ВерсииРегламентовПодготовкиОтчетности.ПустаяСсылка() Тогда
					
					УправлениеПериодом.ДатаНачалаПроцесса=УправлениеОтчетамиУХ.ПолучитьДатуСоСмещением(ДатаНачалаПроцесса, НовыйПериод.Периодичность, 1);					
					УправлениеПериодом.ВерсияОрганизационнойСтруктуры.Загрузить(ВерсияОрганизационнойСтруктуры);
					
				КонецЕсли;
				
				УправлениеПериодом.ЗапускатьПроцесс=Истина;
			
				Попытка
					
					УправлениеПериодом.Записать(РежимЗаписиДокумента.Запись);
					
				Исключение
					
					СтрокаШаблона = Нстр("ru = 'Не удалось записать документ ""Управление периодом сценария для следующего периода"".
					|%1'");
					
					Если ЗначениеЗаполнено(СтрокаШаблона) тогда 				
						Сообщить(СтрШаблон(СтрокаШаблона, ОписаниеОшибки()), СтатусСообщения.Внимание);
					КонецЕсли;
										
					Возврат;
					
				КонецПопытки;
				
			КонецЕсли;
			
			НовыйПериодСценарий=Результат.УправлениеПериодом;
			
		Иначе
			
			// Создадим новый документ "Управление периодом сценария"
			НовыйПериодСценарий=УправлениеРабочимиПроцессамиУХ.ОпределитьДокументУправленияПериодомСценария(Сценарий,НовыйПериод,Ссылка,НовыйПериодОкончание);
			Если  НовыйПериодСценарий=Неопределено Тогда
				ПериодОткрыт=Ложь;
				Возврат;
			КонецЕсли;
			
		КонецЕсли;			
		
	Иначе
		
		// Создадим новый документ "Управление периодом сценария"
		НовыйПериодСценарий=УправлениеРабочимиПроцессамиУХ.ОпределитьДокументУправленияПериодомСценария(Сценарий,НовыйПериод,Ссылка,НовыйПериодОкончание);
		Если НовыйПериодСценарий=Неопределено Тогда
			ПериодОткрыт=Ложь;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьСвойстваПериодов() Экспорт
	
	//Если ЗначениеЗаполнено(Сценарий.Периодичность) Тогда
	//	 ТекущаяПериодичность = Сценарий.Периодичность; 
	//Иначе			 
	//	Если ЗначениеЗаполнено(ПериодСценария) Тогда
	//		ТекущаяПериодичность = ПериодСценария.Периодичность;
	//	КонецЕсли;
	//КонецЕсли;	
	
КонецПроцедуры	

Процедура ЗаполнитьНастройкиПодПериодов() Экспорт
	
	Если Не ПометкаУдаления Тогда
		
		тПериодыОрганизацииПолныйСрез = УправлениеОтчетамиУХ.ПолучитьАналитикиТекущегоГоризонта(Ссылка,ПериодСценария,ПериодСценарияОкончание,Сценарий,ВерсияОрганизационнойСтруктуры,ПериодЗакрыт);	
				
		НаборЗаписей = РегистрыСведений.СтатусыПериодовСценариев.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Сценарии.Установить(Сценарий);
		
		ТЗПериодов = тПериодыОрганизацииПолныйСрез.Скопировать();
		ТЗПериодов.Свернуть("Периоды");
		
		Для Каждого ПериодСценарияСтрока ИЗ ТЗПериодов Цикл
			
			НаборЗаписей.Отбор.Периоды.Установить(ПериодСценарияСтрока.Периоды);
			НаборЗаписей.Прочитать();
			НаборЗаписей.Загрузить(тПериодыОрганизацииПолныйСрез.Скопировать(Новый Структура("Периоды",ПериодСценарияСтрока.Периоды)));
			НаборЗаписей.Записать(Истина);		
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьСледующийПериодСкользящееПланирование()
	
	ШагСкользящегоПлана = 1;
	
	Если Не ЗначениеЗаполнено(ГраницаАктуализации) Тогда
		 ГраницаАктуализации = ПериодСценария;
	КонецЕсли;	
	
	ГраницаАктуализацииДоИзменения 	= ГраницаАктуализации;
	//
	//ГраницаАктуализации 			= УправлениеОтчетамиУХ.ПолучитьСледующийПериод(ГраницаАктуализации,ШагСкользящегоПлана);
	
	ПериодСценарияОкончание 			= УправлениеОтчетамиУХ.ПолучитьСледующийПериод(ПериодСценарияОкончание,ШагСкользящегоПлана);

	//Открываем периоды после границы
	тПериодыОрганизацииПолныйСрез 		= УправлениеОтчетамиУХ.ПолучитьАналитикиТекущегоГоризонта(Ссылка,ГраницаАктуализацииДоИзменения,ПериодСценарияОкончание,Сценарий,ВерсияОрганизационнойСтруктуры,Ложь);	
	
	НаборЗаписей = РегистрыСведений.СтатусыПериодовСценариев.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Сценарии.Установить(Сценарий);
	
	ТЗПериодов = тПериодыОрганизацииПолныйСрез.Скопировать();
	ТЗПериодов.Свернуть("Периоды");
	
	Для Каждого СтрПериод Из тПериодыОрганизацииПолныйСрез Цикл
		СтрПериод.СтатусБлокировки = 0;
	КонецЦикла;	
	
	
	Для Каждого ПериодСценарияСтрока ИЗ ТЗПериодов Цикл
		
		НаборЗаписей.Отбор.Периоды.Установить(ПериодСценарияСтрока.Периоды);
		НаборЗаписей.Прочитать();
		НаборЗаписей.Загрузить(тПериодыОрганизацииПолныйСрез.Скопировать(Новый Структура("Периоды",ПериодСценарияСтрока.Периоды)));
		НаборЗаписей.Записать(Истина);		
		
	КонецЦикла;

	//Закрываем периоды до границы
	тПериодыОрганизацииПолныйСрез 		= УправлениеОтчетамиУХ.ПолучитьАналитикиТекущегоГоризонта(Ссылка,ПериодСценария,ГраницаАктуализацииДоИзменения,Сценарий,ВерсияОрганизационнойСтруктуры,Истина);	

	НаборЗаписей = РегистрыСведений.СтатусыПериодовСценариев.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Сценарии.Установить(Сценарий);
	
	ТЗПериодов = тПериодыОрганизацииПолныйСрез.Скопировать();
	ТЗПериодов.Свернуть("Периоды");
	
	Для Каждого СтрПериод Из тПериодыОрганизацииПолныйСрез Цикл
		СтрПериод.СтатусБлокировки = 1;
	КонецЦикла;	

	Для Каждого ПериодСценарияСтрока ИЗ ТЗПериодов Цикл
		
		НаборЗаписей.Отбор.Периоды.Установить(ПериодСценарияСтрока.Периоды);
		НаборЗаписей.Прочитать();
		НаборЗаписей.Загрузить(тПериодыОрганизацииПолныйСрез.Скопировать(Новый Структура("Периоды",ПериодСценарияСтрока.Периоды)));
		НаборЗаписей.Записать(Истина);		
		
	КонецЦикла;
	
	Записать();
	
КонецПроцедуры	

Процедура ОткрытьПредыдущийПериодСкользящееПланирование()
	
	ШагСкользящегоПлана = 1;
	
	Если Не ЗначениеЗаполнено(ГраницаАктуализации) Тогда
		 ГраницаАктуализации = ПериодСценария;
	КонецЕсли;	
	
	ГраницаАктуализацииДоИзменения = ГраницаАктуализации;
	
	ГраницаАктуализации = УправлениеОтчетамиУХ.ПолучитьСледующийПериод(ГраницаАктуализации,-1*ШагСкользящегоПлана);
	
	Если ГраницаАктуализации.ДатаНачала < ПериодСценария.ДатаНачала Тогда
		ГраницаАктуализации = Справочники.Периоды.ПустаяСсылка();
	Иначе	 
		ПериодСценарияОкончание  = УправлениеОтчетамиУХ.ПолучитьСледующийПериод(ПериодСценарияОкончание,-1*ШагСкользящегоПлана);
	КонецЕсли;	
	
	//Открываем периоды после границы
	тПериодыОрганизацииПолныйСрез 		= УправлениеОтчетамиУХ.ПолучитьАналитикиТекущегоГоризонта(Ссылка,ГраницаАктуализацииДоИзменения,ПериодСценарияОкончание,Сценарий,ВерсияОрганизационнойСтруктуры,Ложь);	
	
	НаборЗаписей = РегистрыСведений.СтатусыПериодовСценариев.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Сценарии.Установить(Сценарий);
	
	ТЗПериодов = тПериодыОрганизацииПолныйСрез.Скопировать();
	ТЗПериодов.Свернуть("Периоды");
	
	Для Каждого СтрПериод Из тПериодыОрганизацииПолныйСрез Цикл
		СтрПериод.СтатусБлокировки = 0;
	КонецЦикла;	
	
	Для Каждого ПериодСценарияСтрока ИЗ ТЗПериодов Цикл
		
		НаборЗаписей.Отбор.Периоды.Установить(ПериодСценарияСтрока.Периоды);
		НаборЗаписей.Прочитать();
		НаборЗаписей.Загрузить(тПериодыОрганизацииПолныйСрез.Скопировать(Новый Структура("Периоды",ПериодСценарияСтрока.Периоды)));
		НаборЗаписей.Записать(Истина);		
		
	КонецЦикла;

	//Закрываем периоды до границы
	тПериодыОрганизацииПолныйСрез 		= УправлениеОтчетамиУХ.ПолучитьАналитикиТекущегоГоризонта(Ссылка,ПериодСценария,ГраницаАктуализации,Сценарий,ВерсияОрганизационнойСтруктуры,Истина);	
	
	НаборЗаписей = РегистрыСведений.СтатусыПериодовСценариев.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Сценарии.Установить(Сценарий);
	
	ТЗПериодов = тПериодыОрганизацииПолныйСрез.Скопировать();
	ТЗПериодов.Свернуть("Периоды");
	
	Для Каждого СтрПериод Из тПериодыОрганизацииПолныйСрез Цикл
		СтрПериод.СтатусБлокировки = 1;
	КонецЦикла;	

	Для Каждого ПериодСценарияСтрока ИЗ ТЗПериодов Цикл
		
		НаборЗаписей.Отбор.Периоды.Установить(ПериодСценарияСтрока.Периоды);
		НаборЗаписей.Прочитать();
		НаборЗаписей.Загрузить(тПериодыОрганизацииПолныйСрез.Скопировать(Новый Структура("Периоды",ПериодСценарияСтрока.Периоды)));
		НаборЗаписей.Записать(Истина);		
		
	КонецЦикла;
	
	Записать();
	
КонецПроцедуры	

Процедура ОткрытьСледующийПериодФиксированныйГоризонт()
	
	ПериодОткрыт=Истина;
	
	ПериодОтчета=ПериодСценария;
	
	// Определим следующий период планирования
	КоличествоПодпериодов =  УправлениеОтчетамиУХ.ПолучитьСмещениеПоИнтервалуПериодов(ПериодСценария,ПериодСценарияОкончание);
		
	НовыйПериод= УправлениеОтчетамиУХ.ПолучитьСледующийПериод(ПериодСценария,КоличествоПодпериодов);
	НовыйПериодОкончание= УправлениеОтчетамиУХ.ПолучитьСледующийПериод(ПериодСценарияОкончание,КоличествоПодпериодов);
		
	Если НЕ ЗначениеЗаполнено(НовыйПериод) Тогда
		Сообщить(НСтр("ru = 'Не удалось определить следующий период. Проверьте наличие соответствующего
		|элемента справочника ""Периоды"".'"), СтатусСообщения.Внимание);	
		ПериодОткрыт=Ложь;
		Возврат;	
	КонецЕсли;
	
	
	Запрос=Новый Запрос;
	
	// Определим документ управления периодом сценария для нового периода и, при необходимости, создадим его
	
	Запрос.Текст=
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	УправлениеПериодомСценария.Ссылка КАК УправлениеПериодом,
	|	УправлениеПериодомСценария.ЗапускатьПроцесс КАК ЗапускатьПроцесс,
	|	УправлениеПериодомСценария.ВерсияОрганизационнойСтруктуры.ШаблонПроцесса КАК ШаблонПроцесса
	|ИЗ
	|	Документ.УправлениеПериодомСценария КАК УправлениеПериодомСценария
	|ГДЕ
	|	УправлениеПериодомСценария.Сценарий = &Сценарий
	|	И УправлениеПериодомСценария.ПериодСценария = &НовыйПериод
	|	И УправлениеПериодомСценария.ПериодСценарияОкончание = &ПериодСценарияОкончание";

	
	Запрос.УстановитьПараметр("НовыйПериод",НовыйПериод);
	Запрос.УстановитьПараметр("ПериодСценарияОкончание",НовыйПериодОкончание);
	Запрос.УстановитьПараметр("Сценарий",Сценарий);

	
	Результат=Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		
		Если ЗначениеЗаполнено(Результат.УправлениеПериодом) Тогда
			
			СтрокаШаблона = Нстр("ru = 'Документ Управление отчетным периодом по сценарию %1 за период %2-%3 уже создан.'");
			
			Если ЗначениеЗаполнено(СтрокаШаблона) тогда		
				Сообщить(СтрШаблон(СтрокаШаблона, Сценарий, НовыйПериод, НовыйПериодОкончание));
			КонецЕсли;
			
			ПериодОткрыт=Истина;
			
			Возврат;
			
		КонецЕсли;	
		
	Иначе	
		
		Попытка
			
			НовыйДокумент=Ссылка.Скопировать();
			НовыйДокумент.Дата=ТекущаяДата();
			НовыйДокумент.УстановитьНовыйНомер();	
			НовыйДокумент.ПериодСценария=НовыйПериод;
			НовыйДокумент.ПериодСценарияОкончание=НовыйПериодОкончание;
			НовыйДокумент.Записать();
			
			СтрокаШаблона = Нстр("ru = 'Документ Управление отчетным периодом по сценарию %1 за период %2-%3 успешно создан.'");
			
			Если ЗначениеЗаполнено(СтрокаШаблона) тогда				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон(СтрокаШаблона, Сценарий, НовыйПериод, НовыйПериодОкончание));
			КонецЕсли;
						
		Исключение
		
		КонецПопытки;
		
	КонецЕсли;		
		
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// РАЗДЕЛ ОСНОВНОЙ ПРОГРАММЫ

СтруктураРеквизитов = Новый Структура();

СтруктураРеквизитов.Вставить("ПометкаУдаления", Нстр("ru = 'Пометка удаления'"));
СтруктураРеквизитов.Вставить("Дата",            Нстр("ru = 'Дата документа'"));
СтруктураРеквизитов.Вставить("Номер",           Нстр("ru = 'Номер документа'"));
СтруктураРеквизитов.Вставить("Сценарий",        Нстр("ru = 'Сценарий'"));
СтруктураРеквизитов.Вставить("ПериодСценария",  Нстр("ru = 'Период сценария'"));
СтруктураРеквизитов.Вставить("ПериодСценарияОкончание",  Нстр("ru = 'Период сценария окончание'"));
СтруктураРеквизитов.Вставить("ВерсияОрганизационнойСтруктуры", Нстр("ru = 'Регламент'"));
СтруктураРеквизитов.Вставить("ДатаНачалаПроцесса", Нстр("ru = 'Дата начала процесса'"));
СтруктураРеквизитов.Вставить("ЗапускатьПроцесс", Нстр("ru = 'Запускать процесс'"));


ПрошлыйПометкаУдаления=Ложь;

#КонецЕсли


