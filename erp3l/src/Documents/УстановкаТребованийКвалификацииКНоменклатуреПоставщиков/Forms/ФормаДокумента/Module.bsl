#Область ОбработкаОсновныхСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	#Область УниверсальныеПроцессыСогласование
		ДействияСогласованиеУХСервер.НарисоватьПанельСогласованияИОпределитьСостояниеОбъекта(ЭтаФорма);
	#КонецОбласти
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	#Область УниверсальныеПроцессыСогласование
	Если ИмяСобытия = "ОбъектСогласован" ИЛИ ИмяСобытия = "ОбъектОтклонен" ИЛИ ИмяСобытия = "МаршрутИнициализирован" ИЛИ ИмяСобытия = "СостояниеЗаявкиПриИзменении" Тогда
		ОпределитьСостояниеОбъекта();
	ИначеЕсли ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		Если МодульУправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
			ОбновитьЭлементыДополнительныхРеквизитов();
			МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	#КонецОбласти
КонецПроцедуры


#КонецОбласти


#Область ОбработкаСобытийЭлементовФормы
// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("ДоговорОбъект"));

КонецПроцедуры

&НаКлиенте
Процедура ТребованияТребованиеКПоставщикуПриИзменении(Элемент)
	ТекДанные = Элементы.Требования.ТекущиеДанные;
	ЗаполнитьСтрокуТребованияКПоставщикам(ТекДанные);
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыНаКлиенте


&НаКлиенте
Процедура ЗаполнитьСтрокуТребованияКПоставщикам(СтрокаТребования)
	Если СтрокаТребования = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыТребования = ПолучитьРеквизитыТребованияКПоставщикам(СтрокаТребования.ТребованиеКПоставщику);
	ЗаполнитьЗначенияСвойств(СтрокаТребования, РеквизитыТребования);
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыНаСервере


&НаСервереБезКонтекста
Функция ПолучитьРеквизитыТребованияКПоставщикам(ТребованиеКПоставщику)
	РеквизитыТребования = Новый Структура;
	РеквизитыТребования.Вставить("Критерий", Справочники.КритерииВыбора.ПустаяСсылка());
	РеквизитыТребования.Вставить("ТребованиеКДокументу", Справочники.ТребованияКСоставуДокументов.ПустаяСсылка());
	
	Если ЗначениеЗаполнено(ТребованиеКПоставщику) Тогда
		ЗаполнитьЗначенияСвойств(РеквизитыТребования, ТребованиеКПоставщику);
	КонецЕсли;
	Возврат РеквизитыТребования;
КонецФункции


#КонецОбласти


#Область УниверсальныеПроцессыСогласование

&НаСервере
Процедура ОпределитьСостояниеОбъекта(ОбновитьОтветственныхВход = Ложь)
	ДействияСогласованиеУХСервер.ОпределитьСостояниеЗаявки(ЭтаФорма, ОбновитьОтветственныхВход);
КонецПроцедуры

&НаКлиенте
Процедура СостояниеЗаявкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	Если ВыбранноеЗначение = РеквизитСостояниеЗаявки(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;

	Если Объект.Ссылка.Пустая() ИЛИ ЭтаФорма.Модифицированность Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("СостояниеЗаявкиОбработкаВыбораПродолжение", ЭтотОбъект, Новый Структура("ВыбранноеЗначение", ВыбранноеЗначение));
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
			|Изменение состояния возможно только после записи данных.
			|Данные будут записаны.'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
		Возврат;
	КонецЕсли;
	
	ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение); 
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение)
	ДействияСогласованиеУХКлиент.ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение, ЭтаФорма);
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
	
	Возврат УправлениеПроцессамиСогласованияУХ.ПеревестиЗаявкуВПроизвольноеСостояние(Ссылка, Состояние, , , ЭтаФорма);
	
КонецФункции

&НаКлиенте
Процедура СтатусОбъектаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	Если ВыбранноеЗначение = РеквизитСостояниеЗаявки(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;

	Если Объект.Ссылка.Пустая() ИЛИ ЭтаФорма.Модифицированность Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("СостояниеЗаявкиОбработкаВыбораПродолжение", ЭтотОбъект, Новый Структура("ВыбранноеЗначение", ВыбранноеЗначение));
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
			|Изменение состояния возможно только после записи данных.
			|Данные будут записаны.'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
		Возврат;
	КонецЕсли;
	
	ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение); 

КонецПроцедуры

// Выводит на форму панель согасования и устанавливает обработчики событий
// для элементов панели.
&НаСервере
Процедура НарисоватьПанельСогласованияИОпределитьСостояниеОбъекта()
	МодульСогласованияДокументовУХ.НарисоватьПанельСогласования(Элементы, ЭтаФорма);
	ЭтаФорма.Команды["ПринятьКСогласованию"].Действие	 = "ПринятьКСогласованию_Подключаемый";
	ЭтаФорма.Команды["ИсторияСогласования"].Действие	 = "ИсторияСогласования_Подключаемый";
	ЭтаФорма.Команды["СогласоватьДокумент"].Действие	 = "СогласоватьДокумент_Подключаемый";
	ЭтаФорма.Команды["ОтменитьСогласование"].Действие	 = "ОтменитьСогласование_Подключаемый";
	ЭтаФорма.Команды["МаршрутСогласования"].Действие	 = "МаршрутСогласования_Подключаемый";
	ОпределитьСостояниеОбъекта();
	ЭлементСтатусОбъекта = Элементы.Найти("СтатусОбъекта");
	Если ЭлементСтатусОбъекта <> Неопределено Тогда
		Если ЭлементСтатусОбъекта.Вид = ВидПоляФормы.ПолеВвода Тогда
			ЭлементСтатусОбъекта.УстановитьДействие("ОбработкаВыбора", "СтатусОбъектаОбработкаВыбора"); 
		Иначе
			// В прочих случаях не устанавливаем обработчик выбора.
		КонецЕсли;
	Иначе
		// Нет элемента Статус объекта.
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКСогласованию_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.ПринятьКСогласованию(ЭтаФорма, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ИсторияСогласования_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.ИсторияСогласования(ЭтаФорма, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура СогласоватьДокумент_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.СогласоватьДокумент(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьСогласование_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.ОтменитьСогласование(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура МаршрутСогласования_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.МаршрутСогласования(ЭтаФорма, Объект.Ссылка);
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

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	#Если ВебКлиент Тогда
	ОпределитьСостояниеОбъекта(Истина);	
	#КонецЕсли
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
		МодульДатыЗапретаИзменения = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзменения");
		МодульДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры


#КонецОбласти 
