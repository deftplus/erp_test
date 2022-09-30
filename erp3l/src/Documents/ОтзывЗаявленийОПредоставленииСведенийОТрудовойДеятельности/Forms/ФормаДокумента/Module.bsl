
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗапрашиваемыеЗначенияПервоначальногоЗаполнения());
		ПриПолученииДанныхНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудники

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	
	СотрудникиСотрудникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "СотрудникиДокументПередачи" Тогда
		
		СтандартнаяОбработка = ЛожЬ;
		ПоказатьЗначение(, Элементы.Сотрудники.ТекущиеДанные.ДокументПередачи);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ОбработатьВыбранныхСотрудников(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередУдалением(Элемент, Отказ)
	
	Для Каждого ИдентификаторВыделеннойСтроки Из Элементы.Сотрудники.ВыделенныеСтроки Цикл
		
		ДанныеСтроки = Объект.Сотрудники.НайтиПоИдентификатору(ИдентификаторВыделеннойСтроки);
		Если ДанныеСтроки <> Неопределено И ЗначениеЗаполнено(ДанныеСтроки.ДокументПередачи) Тогда
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'В строке %1 заявление сотрудника %2 уже передавалось в ПФР.';
					|en = 'In line %1 application from employee %2 has already been handed over to PF.'"),
				ДанныеСтроки.НомерСтроки,
				ДанныеСтроки.Сотрудник);
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, ,
				"Объект.Сотрудники[" + (ДанныеСтроки.НомерСтроки - 1) + "].ДокументПередачи", , Отказ);
			
		КонецЕсли;
		
	КонецЦикла
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подбор(Команда)
	
	СтруктураОтбора = Новый Структура;
	
	КадровыйУчетКлиент.ВыбратьФизическихЛицОрганизации(
		Элементы.Сотрудники,
		Объект.Организация,
		Истина,
		,
		АдресСпискаПодобранныхФизическихЛиц());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаСервереБезКонтекста
Функция ЗапрашиваемыеЗначенияПервоначальногоЗаполнения()
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	ЗапрашиваемыеЗначения.Вставить("Ответственный", "Объект.Ответственный");
	
	Возврат ЗапрашиваемыеЗначения;
	
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Объект.Сотрудники.Очистить();
	
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхФизическихЛиц()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ПоказыватьДокументыПередачи = ЗаполнитьПринятостьВПФР();
	
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеЭлементовФормы(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"СотрудникиДокументПередачи",
		"Видимость",
		Форма.ПоказыватьДокументыПередачи);
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьПринятостьВПФР()
	
	Возврат УстановитьДокументыПередачи(Объект.Сотрудники,
		ДанныеЗаявлений(Объект.Организация, Объект.Сотрудники));
	
КонецФункции

&НаСервере
Функция УстановитьДокументыПередачи(СтрокиСотрудников, ДанныеОПереданныхЗаявлениях)
	
	ДокументыПередачиУстанавливались = Ложь;
	
	Если ДанныеОПереданныхЗаявлениях <> Неопределено Тогда
		
		Для Каждого СтрокаСотрудника Из СтрокиСотрудников Цикл
			
			СтруктураПоиска = Новый Структура("Сотрудник,Заявление");
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаСотрудника);
			
			НайденныеСведения = ДанныеОПереданныхЗаявлениях.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСведения.Количество() Тогда
				
				СтрокаСотрудника.ВидЗаявления = НайденныеСведения[0].ВидЗаявления;
				Если ЗначениеЗаполнено(НайденныеСведения[0].ДокументПередачи) Тогда
					СтрокаСотрудника.ДокументПередачи = НайденныеСведения[0].ДокументПередачи;
					ДокументыПередачиУстанавливались = Истина;
				Иначе
					СтрокаСотрудника.ДокументПередачи = Неопределено;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ДокументыПередачиУстанавливались;
	
КонецФункции

&НаСервере
Функция ДанныеЗаявлений(Организация, СтрокиСотрудников)
	
	ТаблицаОтбора = Новый ТаблицаЗначений;
	ТаблицаОтбора.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаОтбора.Колонки.Добавить("ФизическоеЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	ТаблицаОтбора.Колонки.Добавить("Заявление", Метаданные.ОпределяемыеТипы.ЗаявлениеОВеденииТрудовойКнижки.Тип);
	
	Для Каждого СтрокаСотрудников Из СтрокиСотрудников Цикл
		Если Не ЗначениеЗаполнено(СтрокаСотрудников.Сотрудник)
			Или Не ЗначениеЗаполнено(СтрокаСотрудников.Заявление) Тогда
			
			Продолжить;
		КонецЕсли;
		
		СтрокаТаблицы = ТаблицаОтбора.Добавить();
		СтрокаТаблицы.Организация = Организация;
		СтрокаТаблицы.ФизическоеЛицо = СтрокаСотрудников.Сотрудник;
		СтрокаТаблицы.Заявление = СтрокаСотрудников.Заявление;
		
	КонецЦикла;
	
	Если ТаблицаОтбора.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаОтбора", ТаблицаОтбора);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаОтбора.Организация КАК Организация,
		|	ТаблицаОтбора.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ТаблицаОтбора.Заявление КАК Заявление
		|ПОМЕСТИТЬ ВТТаблицаОтбора
		|ИЗ
		|	&ТаблицаОтбора КАК ТаблицаОтбора
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗаявленияОВеденииТрудовыхКнижек.ФизическоеЛицо КАК Сотрудник,
		|	ЗаявленияОВеденииТрудовыхКнижек.Заявление КАК Заявление,
		|	ЗаявленияОВеденииТрудовыхКнижек.ВидЗаявления КАК ВидЗаявления,
		|	ЗаявленияОВеденииТрудовыхКнижекПереданные.Регистратор КАК ДокументПередачи
		|ИЗ
		|	РегистрСведений.ЗаявленияОВеденииТрудовыхКнижек КАК ЗаявленияОВеденииТрудовыхКнижек
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТТаблицаОтбора КАК ТаблицаОтбора
		|		ПО ЗаявленияОВеденииТрудовыхКнижек.Организация = ТаблицаОтбора.Организация
		|			И ЗаявленияОВеденииТрудовыхКнижек.ФизическоеЛицо = ТаблицаОтбора.ФизическоеЛицо
		|			И ЗаявленияОВеденииТрудовыхКнижек.Заявление = ТаблицаОтбора.Заявление
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗаявленияОВеденииТрудовыхКнижекПереданные КАК ЗаявленияОВеденииТрудовыхКнижекПереданные
		|		ПО ЗаявленияОВеденииТрудовыхКнижек.Организация = ЗаявленияОВеденииТрудовыхКнижекПереданные.Организация
		|			И ЗаявленияОВеденииТрудовыхКнижек.ФизическоеЛицо = ЗаявленияОВеденииТрудовыхКнижекПереданные.ФизическоеЛицо
		|			И ЗаявленияОВеденииТрудовыхКнижек.Заявление = ЗаявленияОВеденииТрудовыхКнижекПереданные.Заявление
		|			И (ЗаявленияОВеденииТрудовыхКнижекПереданные.Отозвано)";
	
	ДанныеОПереданныхЗаявлениях = Запрос.Выполнить().Выгрузить();
	ДанныеОПереданныхЗаявлениях.Индексы.Добавить("Сотрудник,Заявление");
	
	Возврат ДанныеОПереданныхЗаявлениях;
	
КонецФункции

&НаСервере
Процедура ОбработатьВыбранныхСотрудников(ВыбранныеФизическиеЛица)
	
	ДобавленныеСтроки = Новый Массив;
	Для Каждого ФизическоеЛицо Из ВыбранныеФизическиеЛица Цикл
		
		СтрокаСотрудника = Объект.Сотрудники.Добавить();
		СтрокаСотрудника.Сотрудник = ФизическоеЛицо;
		ДобавленныеСтроки.Добавить(СтрокаСотрудника);
		
	КонецЦикла;
	
	ПодобратьЗаявленияВСтрокиСотрудников(ДобавленныеСтроки);
	
КонецПроцедуры

&НаСервере
Процедура СотрудникиСотрудникПриИзмененииНаСервере()
	
	ДанныеСтроки = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
	ДанныеСтроки.Заявление = Неопределено;
	
	Если ДанныеСтроки <> Неопределено Тогда
		ПодобратьЗаявленияВСтрокиСотрудников(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеСтроки));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодобратьЗаявленияВСтрокиСотрудников(СтрокиСотрудников)
	
	ФизическиеЛица = Новый Массив;
	Для Каждого СтрокаСотрудника Из СтрокиСотрудников Цикл
		
		Если ЗначениеЗаполнено(СтрокаСотрудника.Сотрудник) Тогда
			ФизическиеЛица.Добавить(СтрокаСотрудника.Сотрудник);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ФизическиеЛица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗаявленияСотрудников = ЭлектронныеТрудовыеКнижки.ЗаявленияСотрудниковОВеденииТрудовыхКнижек(Истина, Объект.Организация, Объект.Дата, ФизическиеЛица, Объект.Ссылка);
	ЗаявленияСотрудников.Индексы.Добавить("ФизическоеЛицо");
	
	Для Каждого СтрокаСотрудника Из СтрокиСотрудников Цикл
		
		СтрокиЗаявления = ЗаявленияСотрудников.НайтиСтроки(Новый Структура("ФизическоеЛицо", СтрокаСотрудника.Сотрудник));
		Для Каждого СтрокаЗаявления Из СтрокиЗаявления Цикл
			Если СтрокаЗаявления.ТекущееЗаявление Тогда
				СтрокаСотрудника.Заявление = СтрокаЗаявления.Заявление;
				СтрокаСотрудника.ВидЗаявления = СтрокаЗаявления.ВидЗаявления;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Использование = Истина;
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование		= Истина;
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("Объект.Сотрудники.ДокументПередачи");
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.Заполнено;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	ОформляемоеПоле =  ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("СотрудникиНомерСтроки");
	ОформляемоеПоле.Использование = Истина;
	
	ОформляемоеПоле =  ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("СотрудникиСотрудник");
	ОформляемоеПоле.Использование = Истина;
	
	ОформляемоеПоле =  ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("СотрудникиЗаявление");
	ОформляемоеПоле.Использование = Истина;
	
	ОформляемоеПоле =  ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("СотрудникиВидЗаявления");
	ОформляемоеПоле.Использование = Истина;
	
КонецПроцедуры

#КонецОбласти
