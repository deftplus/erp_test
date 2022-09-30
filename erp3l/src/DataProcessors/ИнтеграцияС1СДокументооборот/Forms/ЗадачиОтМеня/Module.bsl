#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервереФормРазмещаемыхНаРабочемСтоле(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Автообновление = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ИнтеграцияС1СДокументооборот", "Автообновление", Истина);
	ПериодАвтообновления = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ИнтеграцияС1СДокументооборот", "ПериодАвтообновления", 60);
	КаталогДляСохраненияДанных = ИнтеграцияС1СДокументооборотВызовСервера.ЛокальныйКаталогФайлов();
	
	Элементы.ГруппаОсновная.Доступность = Ложь;
	Элементы.Автообновление.Доступность = Ложь;
	
	УстановитьОформлениеЗадач(УсловноеОформление);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ДокументооборотЗадача" И Источник = ЭтотОбъект Тогда
		ОбновитьСписокЗадачЧастично();
		РазвернутьГруппыЗадач();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПроверитьПодключение();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияНастройкиАвторизацииНажатие(Элемент)
	
	Оповещение = Новый ОписаниеОповещения("ДекорацияНастройкиАвторизацииНажатиеЗавершение", ЭтотОбъект);
	ИмяФормыПараметров = "Обработка.ИнтеграцияС1СДокументооборот.Форма.АвторизацияВ1СДокументооборот";
	
	ОткрытьФорму(ИмяФормыПараметров,, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкиАвторизацииНажатиеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбработатьФормуСогласноВерсииСервиса();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗадачи

&НаКлиенте
Процедура ЗадачиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Задача = Элементы.Задачи.ТекущиеДанные;
	Если Задача <> Неопределено Тогда
		Если Не Задача.Группировка Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ID", Задача.ЗадачаID);
			ПараметрыФормы.Вставить("type", Задача.ЗадачаТип);
			ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.Задача", 
				ПараметрыФормы, ЭтотОбъект, Задача.ЗадачаID);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)

	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиПередУдалением(Элемент, Отказ)

	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	Задача = Элементы.Задачи.ТекущиеДанные;
	Если Задача <> Неопределено Тогда
		Если Не Задача.Группировка Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ID", Задача.ЗадачаID);
			ПараметрыФормы.Вставить("type", Задача.ЗадачаТип);
			ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.Задача",
				ПараметрыФормы, ЭтотОбъект, Задача.ЗадачаID);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	Модифицированность = Ложь;
	ОбновитьСписокЗадачНаСервере();
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗадачу(Команда)
	
	Модифицированность = Ложь;
	
	ТекущиеДанные = Элементы.Задачи.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли ТекущиеДанные.Группировка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(
		ТекущиеДанные.ЗадачаТип, ТекущиеДанные.ЗадачаID, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПредмет(Команда)
	
	Модифицированность = Ложь;
	
	ТекущиеДанные = Элементы.Задачи.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли ТекущиеДанные.Группировка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(
		ТекущиеДанные.ПредметТип,
		ТекущиеДанные.ПредметID,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПроцесс(Команда)
	
	Модифицированность = Ложь;
	
	ТекущиеДанные = Элементы.Задачи.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли ТекущиеДанные.Группировка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(
		ТекущиеДанные.ПроцессТип,
		ТекущиеДанные.ПроцессID,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПроцесс(Команда)
	
	Модифицированность = Ложь;
	Оповещение = Новый ОписаниеОповещения("СоздатьПроцессЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотКлиент.СоздатьБизнесПроцесс(,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПисьмо(Команда)

	Модифицированность = Ложь;
	
	ТекущиеДанные = Элементы.Задачи.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли ТекущиеДанные.Группировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Предмет", Новый Структура);
	
	ПараметрыФормы.Предмет.Вставить("name", ТекущиеДанные.Задача);
	ПараметрыФормы.Предмет.Вставить("ID", ТекущиеДанные.ЗадачаID);
	ПараметрыФормы.Предмет.Вставить("type", ТекущиеДанные.ЗадачаТип);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ИсходящееПисьмо", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоВажности(Команда)
	
	СгруппироватьПоКолонке("ВажностьСтрокой");
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоТочкеМаршрута(Команда)
	
	СгруппироватьПоКолонке("ТочкаМаршрута");
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоАвтору(Команда)
	
	СгруппироватьПоКолонке("Автор");
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоПредмету(Команда)
	
	СгруппироватьПоКолонке("Предмет");
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоИсполнителю(Команда)
	
	СгруппироватьПоКолонке("Исполнитель");
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоБезГруппировки(Команда)
	
	СгруппироватьПоКолонке("");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьПроцессЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	ОбновитьСписокЗадачЧастично();
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьГруппыЗадач()
	
	ЭлементыДерева = Задачи.ПолучитьЭлементы();
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		Если ЭлементДерева.Группировка Тогда
			Элементы.Задачи.Развернуть(ЭлементДерева.ПолучитьИдентификатор(), Ложь);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоКолонке(ИмяКолонки)
	
	Модифицированность = Ложь;
	СгруппироватьПоКолонкеНаСервере(ИмяКолонки);
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаСервере
Процедура СгруппироватьПоКолонкеНаСервере(РежимГруппировки)
	
	Если Не ЗначениеЗаполнено(ТаблицаЗадачСсылка) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяЗадача = Элементы.Задачи.ТекущаяСтрока;
	Если ТекущаяЗадача <> Неопределено Тогда
		СтрокаТекущейЗадачи = Задачи.НайтиПоИдентификатору(ТекущаяЗадача);
		Если СтрокаТекущейЗадачи = Неопределено Тогда
			ТекущаяЗадача = Неопределено;
		Иначе
			ТекущаяЗадача = СтрокаТекущейЗадачи.ЗадачаID;
		КонецЕсли;
	КонецЕсли;
	
	Дерево = РеквизитФормыВЗначение("Задачи");
	
	ТаблицаЗадач = ПолучитьИзВременногоХранилища(ТаблицаЗадачСсылка); // ТаблицаЗначений
	
	Дерево.Строки.Очистить();
	
	Если ЗначениеЗаполнено(РежимГруппировки) Тогда
		ТаблицаГруппировок = ТаблицаЗадач.Скопировать();
		ТаблицаГруппировок.Свернуть(РежимГруппировки);
		Для Каждого СтрокаГруппировки Из ТаблицаГруппировок Цикл
			СтрокаДерева = Дерево.Строки.Добавить();
			СтрокаДерева.Задача = СтрокаГруппировки[РежимГруппировки];
			СтрокаДерева.КартинкаЗадачи = 2;
			СтрокаДерева.Важность = 1;
			СтрокаДерева.Группировка = Истина;
			СтрокиГруппировки = ТаблицаЗадач.НайтиСтроки(Новый Структура(РежимГруппировки,
				СтрокаГруппировки[РежимГруппировки]));
			Для Каждого Строка Из СтрокиГруппировки Цикл
				СтрокаЭлемента = СтрокаДерева.Строки.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаЭлемента,Строка);
			КонецЦикла;
			СтрокаДерева.Строки.Сортировать("СрокИсполнения УБЫВ, Задача");
		КонецЦикла;
		Элементы.Задачи.Отображение = ОтображениеТаблицы.Дерево;
		Дерево.Строки.Сортировать("Задача");
	Иначе
		Для Каждого Строка Из ТаблицаЗадач Цикл
			СтрокаДерева = Дерево.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДерева,Строка);
		КонецЦикла;
		Элементы.Задачи.Отображение = ОтображениеТаблицы.Список;
		Дерево.Строки.Сортировать("СрокИсполнения УБЫВ, Задача");
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Дерево, "Задачи");
	УстановитьТекущуюСтроку(ТекущаяЗадача);

КонецПроцедуры

&НаСервере
Процедура УстановитьТекущуюСтроку(ЗадачаID) 

	Если ЗначениеЗаполнено(ЗадачаID) Тогда
		Если Элементы.Задачи.Отображение = ОтображениеТаблицы.Список Тогда
			СтрокиЗадачи = Задачи.ПолучитьЭлементы();
			Для Каждого СтрокаЗадачи Из СтрокиЗадачи Цикл
				Если СтрокаЗадачи.ЗадачаID = ЗадачаID Тогда
					Элементы.Задачи.ТекущаяСтрока = СтрокаЗадачи.ПолучитьИдентификатор();
					Прервать;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Для Каждого ГруппаДерева Из Задачи.ПолучитьЭлементы() Цикл
				СтрокиЗадачи = ГруппаДерева.ПолучитьЭлементы();
				Для Каждого СтрокаЗадачи Из СтрокиЗадачи Цикл
					Если СтрокаЗадачи.ЗадачаID = ЗадачаID Тогда
						Элементы.Задачи.ТекущаяСтрока = СтрокаЗадачи.ПолучитьИдентификатор();
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключение()
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПроверитьПодключениеЗавершение", ЭтотОбъект, Неопределено);
	ИнтеграцияС1СДокументооборотКлиент.ПроверитьПодключение(
		ОписаниеОповещения, ЭтотОбъект, "ПроверитьПодключение");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбработатьФормуСогласноВерсииСервиса();
		Если ВерсияСервиса <> "0.0.0.0" Тогда
			РазвернутьГруппыЗадач();
			#Если Не ВебКлиент Тогда
			Если ДоступенФункционалЗадачиОтМеня Тогда
				Элементы.Автообновление.Доступность = Истина;
				Если Автообновление Тогда
					ПодключитьОбработчикОжидания("Автообновление", ПериодАвтообновления);
				КонецЕсли;
			КонецЕсли;
			#КонецЕсли
		КонецЕсли;
	Иначе // не удалось подключиться к ДО
		ОбработатьФормуСогласноВерсииСервиса();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьФормуСогласноВерсииСервиса()
	
	Заголовок = НСтр("ru = 'Документооборот: задачи от меня';
					|en = 'Data interchange: tasks from me'");
	
	ВерсияСервиса = ИнтеграцияС1СДокументооборот.ВерсияСервиса();
	
	Если ПустаяСтрока(ВерсияСервиса) Тогда // идет подключение
		
		Элементы.ГруппаСтраницыПодключения.ТекущаяСтраница
			= Элементы.ГруппаСтраницаОжидание;
		
	Иначе
		
		Элементы.ГруппаСтраницыПодключения.ТекущаяСтраница
			= Элементы.ГруппаСтраницаОсновная;
		
		Если ВерсияСервиса = "0.0.0.0" Тогда
		
			Элементы.ГруппаФункционалНеПоддерживается.Видимость = Истина;
			Элементы.ГруппаПроверкаАвторизации.Видимость = Истина;
			Элементы.ДекорацияФункционалНеПоддерживается.Заголовок = НСтр("ru = 'Нет доступа к 1С:Документообороту.';
																			|en = 'No access to 1C:Document Management.'");
				
		Иначе // сервис доступен
			
			Элементы.ГруппаПроверкаАвторизации.Видимость = Ложь;
			Элементы.ГруппаФункционалНеПоддерживается.Видимость = Ложь;
			
			// задачи
			Если ИнтеграцияС1СДокументооборот.ДоступенФункционалВерсииСервиса("1.3.2.3") Тогда
				Элементы.ГруппаОсновная.Доступность = Истина;
				ДоступенФункционалЗадачиОтМеня = Истина;
				ОбновитьСписокЗадачНаСервере();
			Иначе
				Элементы.ГруппаОсновная.Доступность = Ложь;
				ДоступенФункционалЗадачиОтМеня = Ложь;
				Обработки.ИнтеграцияС1СДокументооборот.ОбработатьФормуПриНедоступностиФункционалаВерсииСервиса(ЭтотОбъект);
			КонецЕсли;
			Если Не ИнтеграцияС1СДокументооборот.ДоступенФункционалВерсииСервиса("1.2.8.1.CORP") Тогда
				Элементы.СоздатьПисьмо.Видимость = Ложь;
			КонецЕсли;
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОформлениеЗадач(УсловноеОформление)

	// Установка оформления для непринятых задач.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Задачи.ПринятаКИсполнению");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Задачи.Группировка");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Задачи.Выполнена");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Font");
	ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.ШрифтНеПринятыеКИсполнениюЗадачи.Значение;
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОбластиОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОбластиОформления.Поле = Новый ПолеКомпоновкиДанных("ЗадачиЗадача");
	
	// Установка оформления для просроченных задач.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Задачи.СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Задачи.СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ЭлементОтбораДанных.ПравоеЗначение = НачалоДня(ТекущаяДатаСеанса());
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Задачи.Выполнена");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.ПросроченныеДанныеЦвет.Значение;
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОбластиОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОбластиОформления.Поле = Новый ПолеКомпоновкиДанных("ЗадачиСрокИсполнения");
	
КонецПроцедуры

&НаКлиенте
Процедура Автообновление()
	
	ОбновитьСписокЗадачНаСервере();
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаАвтообновления()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Автообновление", Автообновление);
	ПараметрыФормы.Вставить("ПериодАвтообновления", ПериодАвтообновления);
	
	Оповещение = Новый ОписаниеОповещения("НастройкаАвтообновленияЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.НастройкаАвтообновления",
		ПараметрыФормы, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаАвтообновленияЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Автообновление = Результат.Автообновление;
	ПериодАвтообновления = Результат.ПериодАвтообновления;
	
	ОтключитьОбработчикОжидания("Автообновление");
	
	МассивСтруктур = Новый Массив;
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ИнтеграцияС1СДокументооборот");
	Элемент.Вставить("Настройка", "Автообновление");
	Элемент.Вставить("Значение", Автообновление);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ИнтеграцияС1СДокументооборот");
	Элемент.Вставить("Настройка", "ПериодАвтообновления");
	Элемент.Вставить("Значение", ПериодАвтообновления);
	МассивСтруктур.Добавить(Элемент);
	
	ИнтеграцияС1СДокументооборотКлиент.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
	
	Если Автообновление Тогда
		ПодключитьОбработчикОжидания("Автообновление", ПериодАвтообновления);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокЗадачЧастично()
	
	ОбновитьСписокЗадачЧастичноНаСервере();
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗадачи(Прокси, Выполненные)
	
	СписокУсловий = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListQuery");
	УсловияОтбора = СписокУсловий.conditions; // СписокXDTO
	
	Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "author";
	Условие.value = "";
	УсловияОтбора.Добавить(Условие);
	
	Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "withExecuted";
	Условие.value = Выполненные;
	УсловияОтбора.Добавить(Условие);
	
	Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "withDelayed";
	Условие.value = Ложь;
	УсловияОтбора.Добавить(Условие);
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetObjectListRequest");
	Запрос.type = "DMBusinessProcessTask";
	Запрос.query = СписокУсловий;
	
	Ответ = ИнтеграцияС1СДокументооборот.ВыполнитьЗапрос(Прокси, Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
	Возврат Ответ.items;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокЗадач(ЗадачиXDTO)
	
	ТекущаяЗадача = Элементы.Задачи.ТекущаяСтрока;
	Если ТекущаяЗадача <> Неопределено Тогда
		СтрокаТекущейЗадачи = Задачи.НайтиПоИдентификатору(ТекущаяЗадача);
		Если СтрокаТекущейЗадачи = Неопределено Тогда
			ТекущаяЗадача = Неопределено;
		Иначе
			ТекущаяЗадача = СтрокаТекущейЗадачи.ЗадачаID;
		КонецЕсли;
	КонецЕсли;
	
	Дерево = РеквизитФормыВЗначение("Задачи"); // ДеревоЗначений
	
	ТаблицаЗадач = Новый ТаблицаЗначений;
	Для Каждого Колонка Из Дерево.Колонки Цикл
		ТаблицаЗадач.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения);
	КонецЦикла;
	
	Для Каждого ЗадачаXDTO Из ЗадачиXDTO Цикл
		СтрокаЗадачи = ТаблицаЗадач.Добавить();
		ЗаполнитьСтрокуЗадачиXDTO(СтрокаЗадачи, ЗадачаXDTO.object);
	КонецЦикла;
	Дерево.Строки.Очистить();
	
	Если ЗначениеЗаполнено(РежимГруппировки) Тогда
		Элементы.Задачи.Отображение = ОтображениеТаблицы.Дерево;
		ТаблицаГруппировок = ТаблицаЗадач.Скопировать();
		ТаблицаГруппировок.Свернуть(РежимГруппировки);
		Для Каждого СтрокаГруппировки Из ТаблицаГруппировок Цикл
			СтрокаДерева = Дерево.Строки.Добавить();
			СтрокаДерева.Задача = СтрокаГруппировки[РежимГруппировки];
			СтрокаДерева.КартинкаЗадачи = 2;
			СтрокаДерева.Важность = 1;
			СтрокаДерева.Группировка = Истина;
			СтрокиГруппировки = ТаблицаЗадач.НайтиСтроки(Новый Структура(РежимГруппировки,
				СтрокаГруппировки[РежимГруппировки]));
			Для Каждого Строка Из СтрокиГруппировки Цикл
				СтрокаЭлемента = СтрокаДерева.Строки.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаЭлемента,Строка);
				СтрокаДерева.Строки.Сортировать("СрокИсполнения УБЫВ, Задача");
			КонецЦикла;
		КонецЦикла;
		Дерево.Строки.Сортировать("Задача");
	Иначе
		Элементы.Задачи.Отображение = ОтображениеТаблицы.Список;
		Для Каждого Строка Из ТаблицаЗадач Цикл
			СтрокаДерева = Дерево.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДерева,Строка);
		КонецЦикла;
		Дерево.Строки.Сортировать("СрокИсполнения УБЫВ, Задача");
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Дерево, "Задачи");
	
	ТаблицаЗадачСсылка = ПоместитьВоВременноеХранилище(ТаблицаЗадач, УникальныйИдентификатор);
	
	УстановитьТекущуюСтроку(ТекущаяЗадача);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтрокуЗадачиXDTO(СтрокаЗадачи, ЗадачаXDTO)
	
	Важность = 1;
	Если ЗадачаXDTO.importance.objectID.ID = "Низкая" Тогда //@NON-NLS-1
		Важность = 0;
	ИначеЕсли ЗадачаXDTO.importance.objectID.ID = "Обычная" Тогда //@NON-NLS-1
		Важность = 1;
	ИначеЕсли ЗадачаXDTO.importance.objectID.ID = "Высокая" Тогда //@NON-NLS-1
		Важность = 2;
	КонецЕсли;
	
	СтрокаЗадачи.Важность = Важность;
	СтрокаЗадачи.ВажностьСтрокой = ЗадачаXDTO.importance.name;
	СтрокаЗадачи.КартинкаЗадачи = ?(ЗадачаXDTO.executed,1,0);
	СтрокаЗадачи.Описание = ЗадачаXDTO.description;
	СтрокаЗадачи.Выполнена = ЗадачаXDTO.executed;
	СтрокаЗадачи.ТочкаМаршрута = ЗадачаXDTO.businessProcessStep;
	СтрокаЗадачи.СрокИсполнения = ЗадачаXDTO.dueDate;
	СтрокаЗадачи.Записана = ЗадачаXDTO.beginDate;
	СтрокаЗадачи.Автор = ЗадачаXDTO.author.name;
	СтрокаЗадачи.ПринятаКИсполнению = ЗадачаXDTO.accepted;
	
	ИсполнительXDTO = ЗадачаXDTO.performer;
	Если ИсполнительXDTO.Установлено("user") Тогда
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,
			ИсполнительXDTO.user,"Исполнитель")
	ИначеЕсли ИсполнительXDTO.Установлено("role") Тогда
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,
			ИсполнительXDTO.role,"Исполнитель")
	КонецЕсли;
	
	ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,ЗадачаXDTO.parentBusinessProcess,"Процесс");
	ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,ЗадачаXDTO.target,"Предмет");
	ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,ЗадачаXDTO,"Задача");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗадачНаСервере()

	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	ЗадачиXDTO = ПолучитьЗадачи(Прокси, Ложь);
	ЗаполнитьСписокЗадач(ЗадачиXDTO);

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗадачЧастичноНаСервере()

	Если Не ЗначениеЗаполнено(ТаблицаЗадачСсылка) Тогда
		ОбновитьСписокЗадачНаСервере();
		Возврат;
	КонецЕсли;
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	ЗадачиXDTO = ПолучитьЗадачи(Прокси, Ложь);
	ТаблицаЗадач = ПолучитьИзВременногоХранилища(ТаблицаЗадачСсылка); // ТаблицаЗначений
	ЗадачиКУдалению = ТаблицаЗадач.ВыгрузитьКолонку("ЗадачаID");
	
	Для Каждого ЗадачаXDTO Из ЗадачиXDTO Цикл
		СтрокиЗадач = ТаблицаЗадач.НайтиСтроки(Новый Структура("ЗадачаID",ЗадачаXDTO.object.objectID.ID));
		Если СтрокиЗадач.Количество() > 0 Тогда
			СтрокаЗадачи = СтрокиЗадач[0];
			ЗадачиКУдалению.Удалить(ЗадачиКУдалению.Найти(ЗадачаXDTO.object.objectID.ID));
		Иначе
			СтрокаЗадачи = ТаблицаЗадач.Добавить();
		КонецЕсли;
		ЗаполнитьСтрокуЗадачиXDTO(СтрокаЗадачи,ЗадачаXDTO.object);
	КонецЦикла;
	
	Для Каждого УдаляемаяЗадача Из ЗадачиКУдалению Цикл
		СтрокиЗадач = ТаблицаЗадач.НайтиСтроки(Новый Структура("ЗадачаID",УдаляемаяЗадача));
		Если СтрокиЗадач.Количество() > 0 Тогда
			ТаблицаЗадач.Удалить(СтрокиЗадач[0]);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаЗадачСсылка = ПоместитьВоВременноеХранилище(ТаблицаЗадач, УникальныйИдентификатор);
	СгруппироватьПоКолонкеНаСервере(РежимГруппировки);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОбъектныйРеквизит(Приемник, Источник, ИмяРеквизита)

	Если Источник <> Неопределено Тогда
		Приемник[ИмяРеквизита] = Источник.name;
		Приемник[ИмяРеквизита + "ID"] = Источник.objectID.ID;
		Приемник[ИмяРеквизита + "Тип"] = Источник.objectID.type;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти