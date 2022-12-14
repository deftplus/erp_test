
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

// Обновляет отображаемы данные на форме.
&НаСервере
Процедура ОбновитьДанныеФормы()
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СписокМероприятий.Параметры.УстановитьЗначениеПараметра("Контекст", Объект.Ссылка);
		СписокШаблоныРеакцииНаИнцидент.Параметры.УстановитьЗначениеПараметра("Контекст", Объект.Ссылка); 
		СписокШаблоныПредупредительныхМер.Параметры.УстановитьЗначениеПараметра("Контекст", Объект.Ссылка); 
		НовыйОтбор = КонтрольныеПроцедуры.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Контекст");
		НовыйОтбор.ПравоеЗначение = Объект.Ссылка;
		НовыйОтбор.Использование = Истина;
	Иначе
		СписокМероприятий.Параметры.УстановитьЗначениеПараметра("Контекст", Неопределено);
		СписокШаблоныРеакцииНаИнцидент.Параметры.УстановитьЗначениеПараметра("Контекст", Неопределено); 
		СписокШаблоныПредупредительныхМер.Параметры.УстановитьЗначениеПараметра("Контекст", Неопределено); 
	КонецЕсли;	
КонецПроцедуры		// ОбновитьДанныеФормы()

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
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбновитьДанныеФормы();
	ЗаполнитьСпискиВыбораНМ();
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ДействияСогласованиеУХСервер");
		Модуль.НарисоватьПанельСогласованияИОпределитьСостояниеОбъекта(ЭтаФорма);
	КонецЕсли;
	УправлениеДоступностью();
КонецПроцедуры

&НаСервере
Процедура УправлениеДоступностью()
	Элементы.НаправлениеРиска.Видимость = Объект.УчитываетсяВНалоговомМониторинге;
	Элементы.КодНалога.Видимость = Объект.УчитываетсяВНалоговомМониторинге;
	Элементы.ГруппаКодНалога.Видимость = Объект.УчитываетсяВНалоговомМониторинге;
//	Элементы.ОКВЭД.Доступность = Объект.УчитываетсяВНалоговомМониторинге;
	Элементы.Категория.Видимость = Объект.УчитываетсяВНалоговомМониторинге;
	Элементы.ГруппаОписаниеОКВЭД2.Видимость = Объект.УчитываетсяВНалоговомМониторинге;
	Элементы.ОбластьРиска.Видимость = Объект.УчитываетсяВНалоговомМониторинге;
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
	ИначеЕсли ИмяСобытия = "ОбновитьСписокШаблоновМероприятий" Тогда
		Элементы.СписокШаблоныПредупредительныхМер.Обновить();
		Элементы.СписокШаблоныРеакцииНаИнцидент.Обновить();
		Элементы.КонтрольныеПроцедуры.Обновить();
	КонецЕсли;
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
Процедура КодОКВЭД2ПриИзменении(Элемент)
	Если НЕ ЭтоЕРПУХ() Тогда
		Объект.КодОКВЭД2 = СтрЗаменить(СокрЛП(Объект.КодОКВЭД2), ",", ".");
		ОКВЭД2 = ОбщегоНазначенияБПВызовСервера.ПолучитьКлассификатор("ОКВЭД2");
		Объект.НаименованиеОКВЭД2 = ОКВЭД2.Получить(Объект.КодОКВЭД2);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КодОКВЭД2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ЭтоЕРПУХ() Тогда
		ВстраиваниеУХКлиент.НачалоВыбора_Организации(Элемент, ДанныеВыбора, СтандартнаяОбработка, ЭтаФорма);
	Иначе
		СтандартнаяОбработка = Ложь;
		ВыбратьКодИзКлассификатора();
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоЕРПУХ()
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ИзмененныеОбъектыЕХ");
КонецФункции

&НаКлиенте
Процедура ВыбратьКодИзКлассификатора()
 
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъекта",      "Справочник");
	ПараметрыФормы.Вставить("НазваниеОбъекта", "Организации");
	ПараметрыФормы.Вставить("НазваниеМакета",  "ОКВЭД2");
	ПараметрыФормы.Вставить("ТекущийПериод",   ТекущаяДата());
	ИмяРеквизитаКод = "КодОКВЭД2";
	ПараметрыФормы.Вставить("ТекущийКод",      Объект[ИмяРеквизитаКод]);
	//ПараметрыФормы.Вставить("Комментарий",     Комментарий);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяКлассификатора", "ОКВЭД2");
	ДополнительныеПараметры.Вставить("ИмяРеквизитаКод",   "КодОКВЭД2");
	ДополнительныеПараметры.Вставить("ИмяРеквизитаНаименование", "НаименованиеОКВЭД2");
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыбратьКодИзКлассификатораЗавершение", 
		ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораКода", ПараметрыФормы,,,,, ОповещениеОЗакрытии);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКодИзКлассификатораЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	ВыбранныйКод = РезультатЗакрытия;	
	
	Если ВыбранныйКод <> Неопределено Тогда
		
		Модифицированность = Истина;
		
		Объект[ДопПараметры.ИмяРеквизитаКод] = ВыбранныйКод;
		
		Объект[ДопПараметры.ИмяРеквизитаНаименование] = НаименованиеПоКлассификатору(
			ДопПараметры.ИмяКлассификатора, ВыбранныйКод);
			
		Если ДопПараметры.ИмяРеквизитаКод = "КодОКВЭД" Тогда
			ПодсказкаОКВЭД2 = "";
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НаименованиеПоКлассификатору(Знач ИмяКлассификатора, Знач КодПоКлассификатору)

	Модуль = ОбщегоНазначения.ОбщийМодуль("ОбщегоНазначенияБПВызовСервера");
	Классификатор = Модуль.ПолучитьКлассификатор(ИмяКлассификатора);
	
	Возврат Классификатор.Получить(КодПоКлассификатору);

КонецФункции

&НаКлиенте
Процедура ЦельНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Объект.Проекция) Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура;
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("Проекция", Объект.Проекция);
		ПараметрыФормы.Вставить("Отбор", СтруктураОтбора);
		Имя = "Справочник.Цели.ФормаВыбора";
		ОткрытьФорму(Имя, ПараметрыФормы, Элементы.Цель);
	Иначе
		СтандартнаяОбработка = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьШаблонРеакцииНаРиск(Команда)
	ПараметрыФормы = Новый Структура;
	СтруктураЗаполнения = Новый Структура;
	СтруктураЗаполнения.Вставить("ВидМероприятия", ПредопределенноеЗначение("Перечисление.ВидыМероприятий.РеакцияНаРиск"));
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", СтруктураЗаполнения);
	ПараметрыФормы.Вставить("Принадлежность", Объект.Ссылка);
	ОткрытьФорму("Справочник.ШаблоныМероприятий.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьШаблонПредупредительныхМер(Команда)
	ПараметрыФормы = Новый Структура;
	СтруктураЗаполнения = Новый Структура;
	СтруктураЗаполнения.Вставить("ВидМероприятия", ПредопределенноеЗначение("Перечисление.ВидыМероприятий.КонтрольноеМероприятие"));
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", СтруктураЗаполнения);
	ПараметрыФормы.Вставить("Принадлежность", Объект.Ссылка);
	ОткрытьФорму("Справочник.ШаблоныМероприятий.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	#Если ВебКлиент Тогда
	ОпределитьСостояниеОбъекта(Истина);	
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ЦФОПриИзменении(Элемент)
	#Если ВебКлиент Тогда
	ОпределитьСостояниеОбъекта(Истина);	
	#КонецЕсли
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбораНМ()
	НалоговыйМониторинг.ЗаполнитьСпискиВыбораВЭлементахУправления(Элементы.НаправлениеРиска, "РегламентированноеУведомлениеРискиОрганизацииНалоговыйМониторинг", "СпискиВыбора2020_1", "СписокНапрРиск");
	НалоговыйМониторинг.ЗаполнитьСпискиВыбораВЭлементахУправления(Элементы.КодНалога, "РегламентированноеУведомлениеРискиОрганизацииНалоговыйМониторинг", "СпискиВыбора2020_1", "СписокКодНалог");
	НалоговыйМониторинг.ЗаполнитьСпискиВыбораВЭлементахУправления(Элементы.Категория, "РегламентированноеУведомлениеРискиОрганизацииНалоговыйМониторинг", "СпискиВыбора2020_1", "СписокКатегорРиск");
	НалоговыйМониторинг.ЗаполнитьСпискиВыбораВЭлементахУправления(Элементы.ОбластьРиска, "РегламентированноеУведомлениеРискиОрганизацииНалоговыйМониторинг", "СпискиВыбора2020_1", "СписокОблРиск");
КонецПроцедуры

&НаКлиенте
Процедура УчитываетсяВНалоговомМониторингеПриИзменении(Элемент)
	УправлениеДоступностью();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗначение(Команда)
	Если Не ЗначениеЗаполнено(Объект.Ущерб) Тогда
		Объект.Ущерб = ПолучитьКатегорииУщерба(Объект.ОценкаПоследствий);
	КонецЕсли;
	УровеньИзБазы = ПолучитьДанныеУровняРиска(Объект.Вероятность, Объект.Ущерб);
	Если ЗначениеЗаполнено(УровеньИзБазы) Тогда
		Объект.УровеньРиска = УровеньИзБазы;
	ИначеЕсли Команда <> Неопределено Тогда
		Сообщить(НСтр("ru = 'Для выбранной комбинации вероятности и ущерба уровень риска не задан'"));
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКатегорииУщерба(Ущерб)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КатегорииУщерба.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.КатегорииУщерба КАК КатегорииУщерба
		|ГДЕ
		|	КатегорииУщерба.МинимальныйУщерб <= &Ущерб
		|	И КатегорииУщерба.МаксимальныйУщерб >= &Ущерб
		|	И КатегорииУщерба.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Ущерб", Ущерб);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
	
КонецФункции
	
&НаСервереБезКонтекста
Функция ПолучитьДанныеУровняРиска(Вероятность, Ущерб)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УстановкаУровняРиска.УровеньРиска КАК УровеньРиска
		|ИЗ
		|	РегистрСведений.УстановкаУровняРиска КАК УстановкаУровняРиска
		|ГДЕ
		|	УстановкаУровняРиска.Вероятность = &Вероятность
		|	И УстановкаУровняРиска.Ущерб = &Ущерб";
	
	Запрос.УстановитьПараметр("Вероятность", Вероятность);
	Запрос.УстановитьПараметр("Ущерб", Ущерб);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.УровеньРиска;
	КонецЕсли;

КонецФункции

&НаКлиенте
Процедура УщербПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.Ущерб) И ЗначениеЗаполнено(Объект.Вероятность) И НЕ ЗначениеЗаполнено(Объект.УровеньРиска) Тогда
		ОбновитьЗначение(Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВероятностьПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.Ущерб) И ЗначениеЗаполнено(Объект.Вероятность) И НЕ ЗначениеЗаполнено(Объект.УровеньРиска) Тогда
		ОбновитьЗначение(Неопределено);
	КонецЕсли;
КонецПроцедуры

//Обязательный обработчик событий EPR
&НаКлиенте
Процедура ПродолжитьВыполнениеКомандыЛокализации(ИмяКоманды, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры
