
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаОсновныхСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекущийПользователь = Пользователи.АвторизованныйПользователь();
	ЭтоВнешнийПользователь = ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя();
	
	СтараяОрганизация = Объект.Организация;
	
	#Область УниверсальныеПроцессыСогласование
	АккредитацияПоставщиковУХ.ИнициализироватьПодсистемуСогласованияПоВнешнемуПоставщику(
		ЭтаФорма);
	#КонецОбласти
	
	Элементы.Организация.СписокВыбора.ЗагрузитьЗначения(
		АккредитацияПоставщиковУХ.ОрганизацииТребующиеАккредитациюПоставщиков(Объект.Дата));
		
	АккредитацияПоставщиковУХ.УстановитьПредставлениеСтатусаАккредитацииНаФорме(
		ЭтаФорма, Объект.Организация, Объект.АнкетаПоставщика, Объект.Дата);
	УстановитьОформлениеФормыВнешнегоПоставщика();
	УстановитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	#Область УниверсальныеПроцессыСогласование
		Если ИмяСобытия = "ОбъектСогласован" ИЛИ ИмяСобытия = "ОбъектОтклонен" ИЛИ ИмяСобытия = "МаршрутИнициализирован" ИЛИ ИмяСобытия = "СостояниеЗаявкиПриИзменении" Тогда
			ОпределитьСостояниеОбъекта();
			УстановитьОформлениеФормы();
		КонецЕсли;
	#КонецОбласти
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьОформлениеФормы();
КонецПроцедуры


#КонецОбласти

#Область ОбработкаСобытийЭлементовФормы


&НаКлиенте
Процедура ОповеститьПоставщикаОРешении(Команда)
	Если Модифицированность Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Необходимо записать документ перед отправкой оповещения.'");
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	АккредитацияПоставщиковВызовСервераУХ.ОповеститьПоставщикаОРешенииПоОбъекту(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Если СтараяОрганизация <> Объект.Организация Тогда
		ОбработатьИзменениеКлючевыхРеквизитовНаСервере();
		СтараяОрганизация = Объект.Организация;
		#Если ВебКлиент Тогда
			ОпределитьСостояниеОбъекта(Истина);	
		#КонецЕсли
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоставщикПриИзменении(Элемент)
	ОбработатьИзменениеКлючевыхРеквизитовНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура РешениеПоДокументуПриИзменении(Элемент)
	УстановитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНаСогласование(Команда)
	АккредитацияПоставщиковКлиентУХ.ОтправитьНаСогласование(ЭтаФорма);
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыНаКлиенте


#КонецОбласти

#Область СлужебныеПроцедурыНаСервере


&НаСервере
Процедура УстановитьОформлениеФормы()
	ТекСтатус = РеквизитСтатусОбъекта(ЭтаФорма);
	флЧерновик = (ТекСтатус = Перечисления.СостоянияСогласования.Черновик) ИЛИ НЕ ЗначениеЗаполнено(ТекСтатус);
	флУтвержденаИлиОтменена = (ТекСтатус = Перечисления.СостоянияСогласования.Утверждена) ИЛИ
		(ТекСтатус = Перечисления.СостоянияСогласования.Отклонена);
			
	Элементы.ФормаОповеститьПоставщикаОРешении.Видимость = НЕ ЭтоВнешнийПользователь И флУтвержденаИлиОтменена И Объект.Проведен;
КонецПроцедуры

// Вызывается один раз при создании формы.
// Устанавливает свойства элементов формы в зависимости
// от того обыйный или внешний пользователь ее открыл.
//
&НаСервере
Процедура УстановитьОформлениеФормыВнешнегоПоставщика() Экспорт
	ТекСтатус = РеквизитСтатусОбъекта(ЭтаФорма);
	флЧерновик = (ТекСтатус = Перечисления.СостоянияСогласования.Черновик) ИЛИ НЕ ЗначениеЗаполнено(ТекСтатус);
	
	АккредитацияПоставщиковУХ.УстановитьОбщееОформлениеФормыЭлементаВнешнегоПоставщика(
			ЭтаФорма, флЧерновик, Истина, Ложь, Истина, "АнкетаПоставщика");
	Элементы.ДатаОтзываАккредитации.ТолькоПросмотр = НЕ ЭтоВнешнийПользователь;		
	Элементы.ДокументАккредитации.ТолькоПросмотр = НЕ ЭтоВнешнийПользователь;
	Элементы.РешениеПоДокументу.Видимость = НЕ ЭтоВнешнийПользователь;
	Элементы.ОбоснованиеРешения.Видимость = НЕ ЭтоВнешнийПользователь;
	Элементы.Организация.КнопкаОткрытия = НЕ ЭтоВнешнийПользователь;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПовторнуюАккредитацию()
	Если ЗначениеЗаполнено(Объект.АнкетаПоставщика) И ЗначениеЗаполнено(Объект.Организация) Тогда
		Отбор_ = Новый Соответствие;
		Отбор_.Вставить("Ссылка", Новый Структура("Значение,ВидСравнения", Объект.Ссылка, "<>"));
		ПредыдущаяАккредитация_ = АккредитацияПоставщиковУХ.ПолучитьДокументыАккредитации(
				"АккредитацияПоставщика", Объект.Организация, Объект.АнкетаПоставщика, Объект.Дата, Отбор_);
		Если ЗначениеЗаполнено(ПредыдущаяАккредитация_) Тогда
			Объект.ДокументАккредитации = ПредыдущаяАккредитация_;
		Иначе
			Объект.ДокументАккредитации = Документы.АккредитацияПоставщика.ПустаяСсылка();
		КонецЕсли;
	Иначе
		Объект.ДокументАккредитации = Документы.АккредитацияПоставщика.ПустаяСсылка();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеКлючевыхРеквизитовНаСервере()
	ЗаполнитьПовторнуюАккредитацию();
	АккредитацияПоставщиковУХ.УстановитьПредставлениеСтатусаАккредитацииНаФорме(
		ЭтаФорма, Объект.Организация, Объект.АнкетаПоставщика, Объект.Дата);
	УстановитьОформлениеФормы();
КонецПроцедуры


#КонецОбласти


#Область УниверсальныеПроцессыСогласование

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

&НаКлиенте
Процедура СостояниеЗаявкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	Если ВыбранноеЗначение = РеквизитСостояниеЗаявки(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;

	Если Объект.Ссылка.Пустая() Тогда
		
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
	
	Возврат УправлениеПроцессамиСогласованияУХ.ПеревестиЗаявкуВПроизвольноеСостояние(Ссылка, Состояние,,,ЭтаФорма);
	
КонецФункции

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

#КонецОбласти


#Область ПереопределеноУниверсальныеПроцессыСогласование


&НаСервере
Процедура ОпределитьСостояниеОбъекта(ОбновитьОтветственныхВход = Ложь)
	Если ЭтоВнешнийПользователь Тогда
		СостояниеЗаявки = УправлениеПроцессамиСогласованияУХ.ВернутьТекущееСостояние(Объект.Ссылка);
		СтатусОбъекта = УправлениеПроцессамиСогласованияУХ.ВернутьСтатусОбъекта(Объект.Ссылка);
	Иначе
		ДействияСогласованиеУХСервер.ОпределитьСостояниеЗаявки(ЭтаФорма, ОбновитьОтветственныхВход);
	КонецЕсли;
КонецПроцедуры


#КонецОбласти

