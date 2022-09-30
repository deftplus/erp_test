///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ОбработкаНовостейПовтИсп.РазрешенаРаботаСНовостями() <> Истина Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	// В конфигурации есть общие реквизиты с разделением и включена ФО РаботаВМоделиСервиса.
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		// Если включено разделение данных, то редактировать новостные ленты можно только из неразделенного сеанса.
		// Зашли в конфигурацию под пользователем без разделения (и не вошли в область данных).
		Если ИнтернетПоддержкаПользователей.СеансЗапущенБезРазделителей() Тогда
			ЭтотОбъект.ТолькоПросмотр = Ложь;
		Иначе
			ЭтотОбъект.ТолькоПросмотр = Истина;
			Элементы.ЛентыНовостейГруппаПолучитьНовости.Видимость = Ложь;
			Элементы.ФормаКомандаОбновитьССервера.Видимость = Ложь;
		КонецЕсли;
	Иначе
		ЭтотОбъект.ТолькоПросмотр = Ложь;
	КонецЕсли;

	ЭтотОбъект.РольДоступнаАдминистратор = ОбработкаНовостейПовтИсп.ЭтоАдминистратор();

	Если ОбработкаНовостейПовтИсп.РазрешенаРаботаСНовостямиЧерезИнтернет() = Истина Тогда
		Элементы.ДекорацияРежимРаботыСНовостямиЧерезИнтернет_ОбновлениеЛентНовостей.Видимость = Ложь;
	КонецЕсли;

	Если Параметры.Свойство("ОткрытаИзОбработки_УправлениеНовостями") Тогда
		ЭтотОбъект.ОткрытаИзОбработки_УправлениеНовостями = Параметры.ОткрытаИзОбработки_УправлениеНовостями;
	Иначе
		ЭтотОбъект.ОткрытаИзОбработки_УправлениеНовостями = Ложь;
	КонецЕсли;

	ОбновитьИнформационныеСтроки();

	УстановитьУсловноеОформление();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "Новости. Обновились данные классификаторов новостей с сервера 1С" Тогда // Идентификатор.
		Элементы.Список.Обновить();
		ОбновитьИнформационныеСтроки();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОбновитьССервера(Команда)

	ОткрытьФорму(
		"Обработка.УправлениеНовостями.Форма.ФормаНастроекНовостей",
		Новый Структура("ТекущаяСтраница", "СтраницаОбновленияСтандартныхСписков"),
		ЭтотОбъект,
		"");

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияТребуетсяОбновлениеССервераОбработкаНавигационнойСсылки(
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка)

	Если ВРег(НавигационнаяСсылкаФорматированнойСтроки) = ВРег("Update") Тогда

		СтандартнаяОбработка = Ложь;

		ДекорацияТребуетсяОбновлениеССервераОбработкаНавигационнойСсылкиСервер();

		ОбновитьИнформационныеСтроки();

		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Обновление завершено';
				|en = 'Update completed'"),
			,
			НСтр("ru = 'Обновление данных, а также последующая оптимизация загруженных данных завершены';
				|en = 'Data is updated, the imported data is optimized'"));

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаЗагрузитьНовости(Команда)

	Если Команда.Имя = "КомандаЗагрузитьНовостиПоВсемЛентамНовостей" Тогда
		ОбработкаНовостейВызовСервера.ПолучитьИОбработатьНовостиПоЛентамНовостей(Новый Массив, Неопределено);
		Элементы.Список.Обновить();
		Оповестить(
			"Новости. Загружены новости",
			,
			ЭтотОбъект.УникальныйИдентификатор);
	ИначеЕсли Команда.Имя = "КомандаЗагрузитьНовостиПоВыделеннымЛентамНовостей" Тогда
		МассивВыделенныхЛентНовостей = Новый Массив;
		Для каждого ТекущаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
			МассивВыделенныхЛентНовостей.Добавить(Элементы.Список.ДанныеСтроки(ТекущаяСтрока).Ссылка);
		КонецЦикла;
		ОбработкаНовостейВызовСервера.ПолучитьИОбработатьНовостиПоЛентамНовостей(МассивВыделенныхЛентНовостей, Неопределено);
		Элементы.Список.Обновить();
		Оповестить(
			"Новости. Загружены новости",
			,
			ЭтотОбъект.УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура обновляет все информационные надписи.
//
// Параметры:
//  Нет.
//
Процедура ОбновитьИнформационныеСтроки()

	// Проверка необходимости обновления и вывод сообщения в декорации. Начало.

	ТребуетсяОбновление = Ложь;

	Запись = РегистрыСведений.ДатыОбновленияСтандартныхСписковНовостей.СоздатьМенеджерЗаписи();
	Запись.Список = "Список лент новостей"; // Идентификатор.
	Запись.Прочитать(); // Только чтение, без последующей записи.

	ЭтотОбъект.ТекущаяВерсияНаКлиенте = Запись.ТекущаяВерсияНаКлиенте; // Для обновления без показа формы управления новостями.
	ЭтотОбъект.ТекущаяВерсияНаСервере = Запись.ТекущаяВерсияНаСервере; // Для обновления без показа формы управления новостями.

	Если Запись.Выбран() Тогда
		Если Запись.ТекущаяВерсияНаКлиенте >= Запись.ТекущаяВерсияНаСервере Тогда
			ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Данные актуальны и соответствуют данным с сервера от %1.';
					|en = 'Data is relevant and corresponds to the data from the server from %1.'"),
				Формат(Запись.ТекущаяВерсияНаСервере, "ДЛФ=DT"));
			ТребуетсяОбновление = Ложь;
		Иначе // Устарели
			Если Запись.ТекущаяВерсияНаКлиенте = '00010101' Тогда
				ТекстНадписи = НСтр("ru = 'Данные никогда не обновлялись с сервера,
					|а на сервере уже версия от %2.';
					|en = 'Data has never been updated from the server.
					|The version on the server is dated %2.'");
			Иначе
				ТекстНадписи = НСтр("ru = 'Последний раз данные обновлялись с сервера %1,
					|а на сервере уже версия от %2.';
					|en = 'Last time the data was updated from the server was %1 and on the server the version is from %2.
					|'");
			КонецЕсли;
			ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстНадписи,
				Формат(Запись.ТекущаяВерсияНаКлиенте, "ДЛФ=DT"),
				Формат(Запись.ТекущаяВерсияНаСервере, "ДЛФ=DT"));
			ТребуетсяОбновление = Истина;
		КонецЕсли;
	Иначе
		ТекстНадписи = НСтр("ru = 'Данные никогда не обновлялись с сервера.';
							|en = 'Data has never been updated from the server.'");
		ТребуетсяОбновление = Истина;
	КонецЕсли;

	Если ПолучитьФункциональнуюОпцию("РазрешенаРаботаСНовостямиЧерезИнтернет") = Истина Тогда
		Если (ЭтотОбъект.РольДоступнаАдминистратор = Истина) Тогда
			// Если эта форма открыта из формы обработки "Управление новостями", то
			//  не давать снова открывать форму обработки.
			Если ЭтотОбъект.ОткрытаИзОбработки_УправлениеНовостями = Истина Тогда
				Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок = ТекстНадписи;
				Если ТребуетсяОбновление = Истина Тогда
					Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
				Иначе
					Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветМикротекста;
				КонецЕсли;
			Иначе
				Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок   = Новый ФорматированнаяСтрока(
					ТекстНадписи,
					" ",
					Новый ФорматированнаяСтрока(
						НСтр("ru = 'Проверить обновления';
							|en = 'Check for updates'"),
						,
						ЦветаСтиля.ГиперссылкаЦвет,
						,
						"Update"),
					"."); // Завершающие предложение точки не должны попадать в гиперссылки.
			КонецЕсли;
		Иначе
			Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок   = ТекстНадписи;
			Если ТребуетсяОбновление = Истина Тогда
				Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
			Иначе
				Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветМикротекста;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	// Проверка необходимости обновления и вывод сообщения в декорации. Конец.

КонецПроцедуры

&НаСервере
// Процедура запускает обновление лент новостей.
//
// Параметры:
//  Нет.
//
Процедура ДекорацияТребуетсяОбновлениеССервераОбработкаНавигационнойСсылкиСервер()

	НаименованиеПроцедурыФункции = "Справочник.ЛентыНовостей.ФормаСписка.ДекорацияТребуетсяОбновлениеССервераОбработкаНавигационнойСсылкиСервер"; // Идентификатор.
	КонтекстВыполнения = ОбработкаНовостейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций(); // Этот контекст.
	ЗаписыватьВЖурналРегистрации = Истина;
	КодРезультата = 0;
	ОписаниеРезультата = "";
	КонтекстВыполненияВложенный = ОбработкаНовостейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций(); // Контекст "по шагам".
	ОбработкаНовостейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		НаименованиеПроцедурыФункции, // Идентификатор.
		НСтр("ru = 'Обновление классификаторов (вручную)';
			|en = 'Update classifiers (manually)'"));

		Обработки.УправлениеНовостями.ОбновитьСтандартныйСписокССервера(
			"Список лент новостей", // Идентификатор.
			ЭтотОбъект.ТекущаяВерсияНаКлиенте,
			Неопределено,
			КонтекстВыполненияВложенный);

		// После обновления лент новостей могли измениться наборы доступных для отбора категорий.
		// Удалить неправильные отборы, которые могут помешать проверке общих и пользовательских отборов.
		// В разделенном сеансе будут пересчитаны только пользовательские отборы и общие для области данных.
		ОбработкаНовостей.ОптимизироватьОтборыПоНовостям(КонтекстВыполненияВложенный);

	ШагВыполнения = ОбработкаНовостейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата, // Много действий, всегда установлено в 0, надо читать данные по каждому шагу.
		ОписаниеРезультата,
		КонтекстВыполненияВложенный);

	Если ЗаписыватьВЖурналРегистрации = Истина Тогда

		ОбработкаНовостей.ЗаписатьСообщениеВЖурналРегистрации(
			НСтр("ru = 'БИП:Новости.Загрузка классификаторов';
				|en = 'ISL:News.Classifier import'", ОбщегоНазначения.КодОсновногоЯзыка()), // ИмяСобытия.
			НСтр("ru = 'Новости. Загрузка классификаторов';
				|en = 'News. Import classifiers'", ОбщегоНазначения.КодОсновногоЯзыка()), // ИдентификаторШага.
			?(КодРезультата > 0,
				УровеньЖурналаРегистрации.Ошибка,
				УровеньЖурналаРегистрации.Информация), // УровеньЖурналаРегистрации.*
			, // ОбъектМетаданных
			(ШагВыполнения.ВремяОкончания - ШагВыполнения.ВремяНачала), // Данные
			ОбработкаНовостей.КомментарийДляЖурналаРегистрации(
				НаименованиеПроцедурыФункции,
				ШагВыполнения,
				КонтекстВыполнения,
				"Простой"), // Комментарий
			ОбработкаНовостейПовтИсп.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации

	КонецЕсли;

КонецПроцедуры

// Процедура устанавливает условное оформление в форме.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// 1. Частота обновления = 0 (обновлять вручную), и это НЕ локальная лента новостей.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЧастотаОбновления.Имя);

		// Отбор
		ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЧастотаОбновления");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 0;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЛокальнаяЛентаНовостей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Обновлять только вручную';
																	|en = 'Update only manually'"));

		// Использование
		Элемент.Использование = Истина;

	// 2. Частота обновления = 1 (Ежедневно), и это НЕ локальная лента новостей.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЧастотаОбновления.Имя);

		// Отбор
		ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЧастотаОбновления");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 1;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЛокальнаяЛентаНовостей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Ежедневно';
																	|en = 'Daily'"));

		// Использование
		Элемент.Использование = Истина;

	// 3. Частота обновления = 2 (Ежечасно), и это НЕ локальная лента новостей.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЧастотаОбновления.Имя);

		// Отбор
		ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЧастотаОбновления");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 2;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЛокальнаяЛентаНовостей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Ежечасно';
																	|en = 'Every hour'"));

		// Использование
		Элемент.Использование = Истина;

	// 4. Частота обновления = 3 (Каждые 15 минут), и это НЕ локальная лента новостей.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЧастотаОбновления.Имя);

		// Отбор
		ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЧастотаОбновления");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 3;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЛокальнаяЛентаНовостей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Каждые 15 минут';
																	|en = 'Every 15 minutes'"));

		// Использование
		Элемент.Использование = Истина;

	// 5. Частота обновления = 4 (Каждую минуту), и это НЕ локальная лента новостей.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЧастотаОбновления.Имя);

		// Отбор
		ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЧастотаОбновления");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 4;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЛокальнаяЛентаНовостей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Каждую минуту';
																	|en = 'Every minute'"));

		// Использование
		Элемент.Использование = Истина;

	// 6. Частота обновления = не требуется, т.к. это локальная лента новостей
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЧастотаОбновления.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЛокальнаяЛентаНовостей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Не требуется';
																	|en = 'Not required'"));

		// Использование
		Элемент.Использование = Истина;

	// 7. Убрать колонки "Протокол", "Сайт", "ИмяФайла" если лента локальная.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Протокол.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Сайт.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИмяФайла.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЛокальнаяЛентаНовостей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

		// Использование
		Элемент.Использование = Истина;

КонецПроцедуры

#КонецОбласти

