
&НаСервере
Процедура ОпределитьСостояниеОбъекта(ОбновитьОтветственныхВход = Ложь)
	ОбщийМодульДействияСогласованиеУХСервер = ОбщегоНазначения.ОбщийМодуль("ДействияСогласованиеУХСервер");
	Если ОбщийМодульДействияСогласованиеУХСервер <> Неопределено Тогда
		ОбщийМодульДействияСогласованиеУХСервер.ОпределитьСостояниеЗаявки(ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбъектаПриИзменении_Подключаемый()
	НовоеЗначениеСтатуса = РеквизитСтатусОбъекта(ЭтаФорма);
	ПроверитьСохранениеИзменитьСтатус(НовоеЗначениеСтатуса);	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбъектаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение = РеквизитСтатусОбъекта(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьСохранениеИзменитьСтатус(ВыбранноеЗначение);
КонецПроцедуры

// Проверяет сохранение текущего объекта и изменяет его статус
// НовоеЗначениеСтатусаВход.
&НаКлиенте
Процедура ПроверитьСохранениеИзменитьСтатус(НовоеЗначениеСтатусаВход)
	Если (Объект.Ссылка.Пустая()) ИЛИ (ЭтаФорма.Модифицированность) Тогда
		СтруктураПараметров = Новый Структура("ВыбранноеЗначение", НовоеЗначениеСтатусаВход);
		ОписаниеОповещения = Новый ОписаниеОповещения("СостояниеЗаявкиОбработкаВыбораПродолжение", ЭтотОбъект, СтруктураПараметров);
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
		|Изменение состояния возможно только после записи данных.
		|Данные будут записаны.'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		Возврат;
	КонецЕсли;
	ИзменитьСостояниеЗаявкиКлиент(НовоеЗначениеСтатусаВход);	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеЗаявкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение = РеквизитСостояниеЗаявки(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;

	ПроверитьСохранениеИзменитьСтатус(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение)
	РасширениеПроцессыИСогласованиеКлиентУХ.ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СостояниеЗаявкиОбработкаВыбораПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Записать();
		ИзменитьСостояниеЗаявкиКлиент(Параметры.ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИзменитьСостояниеЗаявки(Ссылка, Состояние)
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("УправлениеПроцессамиСогласованияУХ");
		Возврат Модуль.ПеревестиЗаявкуВПроизвольноеСостояние(Ссылка, Состояние, , , ЭтаФорма);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПринятьКСогласованию_Подключаемый() Экспорт
	РасширениеПроцессыИСогласованиеКлиентУХ.ПринятьКСогласованию(ЭтаФорма, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ИсторияСогласования_Подключаемый() Экспорт
	РасширениеПроцессыИСогласованиеКлиентУХ.ИсторияСогласования(ЭтаФорма, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура СогласоватьДокумент_Подключаемый() Экспорт
	РасширениеПроцессыИСогласованиеКлиентУХ.СогласоватьДокумент(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьСогласование_Подключаемый() Экспорт
	РасширениеПроцессыИСогласованиеКлиентУХ.ОтменитьСогласование(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура МаршрутСогласования_Подключаемый() Экспорт
	РасширениеПроцессыИСогласованиеКлиентУХ.МаршрутСогласования(ЭтаФорма, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииЭлементаОрганизации_Подключаемый(Элемент) Экспорт
	ОпределитьСостояниеОбъекта(Истина);		
	ВыполнитьПредыдущийОбработчикПриИзмененииОрганизации(Элемент);
КонецПроцедуры		// ПриИзмененииЭлементаОрганизации_Подключаемый()

// Возвращает значение реквизита СостояниеЗаявки на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСостояниеЗаявки(ФормаВход)
	Возврат ФормаВход["СостояниеЗаявки"];
КонецФункции

// Возвращает значение реквизита СтатусОбъекта на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСтатусОбъекта(ФормаВход)
	Возврат ФормаВход["СтатусОбъекта"];
КонецФункции

// Возвращает значение реквизита Согласующий на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСогласующий(ФормаВход)
	Возврат ФормаВход["Согласующий"];
КонецФункции

// Выполняет обработчик ПриИзменении, сопоставленный по умолчанию для элемента Элемент
&НаКлиенте
Процедура ВыполнитьПредыдущийОбработчикПриИзмененииОрганизации(Элемент)
	#Если НЕ ВебКлиент Тогда
	ИмяЭлемента = Элемент.Имя;
	Если ЗначениеЗаполнено(ИмяЭлемента) Тогда
		Для Каждого ТекОбработчикиИзмененияОрганизации Из ЭтаФорма["ОбработчикиИзмененияОрганизации"] Цикл
			Если СокрЛП(ТекОбработчикиИзмененияОрганизации.ИмяРеквизита) = СокрЛП(ИмяЭлемента) Тогда
				СтрокаВыполнения = ТекОбработчикиИзмененияОрганизации.ИмяОбработчика + "(Элемент);";
				Выполнить СтрокаВыполнения;
			Иначе
				// Выполняем поиск далее.
			КонецЕсли; 
		КонецЦикла;	
	Иначе
		// Передан пустой элемент.
	КонецЕсли;
	#КонецЕсли
КонецПроцедуры		// ВыполнитьПредыдущийОбработчикПриИзмененииОрганизации()

// Рассчитывает значение поля ПлановыеЗатраты.
&НаСервере
Процедура РассчитатьПлановыеЗатраты()
	Объект.ПлановыеЗатраты = Объект.ПроцентЗатратНаЛиквидациюРиска * Объект.ПрогнозныйУбыток / 100;
КонецПроцедуры		// РассчитатьПлановыеЗатраты()

// Обновляет отображаемы данные на форме.
&НаСервере
Процедура ОбновитьДанныеФормы()
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СписокРеакций.Параметры.УстановитьЗначениеПараметра("РисковоеСобытие", Объект.Ссылка);
	Иначе
		СписокРеакций.Параметры.УстановитьЗначениеПараметра("РисковоеСобытие", Неопределено);
	КонецЕсли;	
КонецПроцедуры		// ОбновитьДанныеФормы()

// Отображает/скрывает предупреждение о превышении лимита.
&НаСервере
Процедура ОпределитьПревышениеЗатрат()
	ОтображатьПредупреждение = Ложь;
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОстатокЗатрат = Документы.РисковоеСобытие.ПолучитьОстатокЗатратНаУстранениеРисковогоСобытия(Объект.Ссылка);
		ОтображатьПредупреждение = (ОстатокЗатрат < 0);
	Иначе
		ОтображатьПредупреждение = Ложь;
	КонецЕсли;	
	Элементы.ГруппаПревышениеЗатрат.Видимость = ОтображатьПредупреждение;
КонецПроцедуры		// ОпределитьПревышениеЗатрат()

// Возвращает типа объекта конфигурации по типу основания рисквого события ТипОснованияВход.
// Когда получить не удалось - будет возвращено Неопределено.
&НаСервереБезКонтекста
Функция ВернутьТипОбъектаПоТипуОснования(ТипОснованияВход)
	РезультатФункции = Неопределено;
	Если ЗначениеЗаполнено(ТипОснованияВход) Тогда
		СправочникБД = ТипОснованияВход.ОбъектБдОснования;
		РезультатФункции = ОбщегоНазначенияСерверУХ.ВернутьТипПоСсылкеБД(СправочникБД);	
	Иначе
		РезультатФункции = Неопределено;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции		// ВернутьТипОбъектаПоТипуОснования()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОпределитьПревышениеЗатрат();
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ДействияСогласованиеУХСервер");
		Модуль.НарисоватьПанельСогласованияИОпределитьСостояниеОбъекта(ЭтаФорма);
	КонецЕсли;	
	ОбновитьДанныеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьРеакцию(Команда)
	ПараметрыФормы = Новый Структура("Основание", Объект.Ссылка);
	ОткрытьФорму("Документ.Мероприятие.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ОбъектСогласован" Тогда
		ОпределитьСостояниеОбъекта();
	ИначеЕсли ИмяСобытия = "ОбъектОтклонен" Тогда
		ОпределитьСостояниеОбъекта();
	ИначеЕсли ИмяСобытия = "МаршрутИнициализирован" Тогда
		ОпределитьСостояниеОбъекта();
	ИначеЕсли ИмяСобытия = "СостояниеЗаявкиПриИзменении" Тогда
		ОпределитьСостояниеОбъекта();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроцентЗатратНаЛиквидациюРискаПриИзменении(Элемент)
	РассчитатьПлановыеЗатраты();
КонецПроцедуры

&НаКлиенте
Процедура ПлановыеЗатратыПриИзменении(Элемент)
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОпределитьПревышениеЗатрат();
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// Ограничим выбор объектом БД из Типа основания.
	Если ЗначениеЗаполнено(Объект.ТипОснования) Тогда
		ТипОбъектаОснования = ВернутьТипОбъектаПоТипуОснования(Объект.ТипОснования);
		Если ТипОбъектаОснования <> Неопределено Тогда
			МассивТипов = Новый Массив;
			МассивТипов.Добавить(ТипОбъектаОснования);
			Элемент.ВыбиратьТип = Ложь;
			Элемент.ОграничениеТипа = Новый ОписаниеТипов(МассивТипов);
		Иначе
			Элемент.ВыбиратьТип = Истина;
			Элемент.ОграничениеТипа = Новый ОписаниеТипов();
		КонецЕсли;
	Иначе
		Элемент.ВыбиратьТип = Истина;
		Элемент.ОграничениеТипа = Новый ОписаниеТипов();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ДиаграммаГанта(Команда)
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("РисковоеСобытие", Объект.Ссылка);
		ОткрытьФорму("Отчет.ИсполнениеСтадийМеропритияДиаграммаГанта.Форма.ФормаОтчета", СтруктураПараметров);
	Иначе
		ТекстСообщения = НСтр("ru = 'Требуется записать объект. Операция отменена.'");
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПрогнозныйУбытокПриИзменении(Элемент)
	РассчитатьПлановыеЗатраты();
КонецПроцедуры

&НаКлиенте
Процедура ЦФОПриИзменении(Элемент)
	#Если ВебКлиент Тогда
	ОпределитьСостояниеОбъекта(Истина);	
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	#Если ВебКлиент Тогда
	ОпределитьСостояниеОбъекта(Истина);	
	#КонецЕсли
КонецПроцедуры
