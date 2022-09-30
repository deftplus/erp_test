#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПоказательБюджетов = Параметры.ПоказательБюджетов;
	ТипПравил = Перечисления.ТипПравилаПолученияФактическихДанныхБюджетирования.ФактическиеДанные;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПоказательБюджетов", ПоказательБюджетов);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипПравилПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПравилаПолученияФактаПоПоказателямБюджетов.Ссылка КАК Ссылка,
		|	ПравилаПолученияФактаПоПоказателямБюджетов.КомпоновщикНастроек КАК КомпоновщикНастроек
		|ИЗ
		|	Справочник.ПравилаПолученияФактаПоПоказателямБюджетов КАК ПравилаПолученияФактаПоПоказателямБюджетов
		|ГДЕ
		|	ПравилаПолученияФактаПоПоказателямБюджетов.Ссылка В(&Правила)";
	
	Запрос.УстановитьПараметр("Правила", Строки.ПолучитьКлючи());
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	НастройкаПоПравилу = Новый Соответствие();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НастройкаПоПравилу.Вставить(ВыборкаДетальныеЗаписи.Ссылка, ВыборкаДетальныеЗаписи.КомпоновщикНастроек.Получить());
	КонецЦикла;
	
	Для Каждого Строка Из Строки Цикл
		СКДПоПравилу = ИсточникиДанныхСервер.СхемаКомпоновкиДанныхПравила(Строка.Ключ);
		Если СКДПоПравилу <> Неопределено Тогда 
			КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных();
			КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКДПоПравилу));
			
			ДополнительныйОтбор = НастройкаПоправилу.Получить(Строка.Ключ);
			Если ДополнительныйОтбор <> Неопределено Тогда 
				КомпоновщикНастроек.ЗагрузитьНастройки(ДополнительныйОтбор);
				Строка.Значение.Данные.ПредставлениеОтбора = Строка(КомпоновщикНастроек.Настройки.Отбор);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ПараметрыОткрытия = Новый Структура;
	Если Копирование Тогда
		ПараметрыОткрытия.Вставить("ЗначениеКопирования", Элементы.Список.ТекущиеДанные.Ссылка);
	Иначе
		ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", Новый Структура("ПоказательБюджетов, ТипПравила", ПоказательБюджетов, ТипПравил));
	КонецЕсли;
	ОткрытьФорму("Справочник.ПравилаПолученияФактаПоПоказателямБюджетов.Форма.ФормаОбъекта", ПараметрыОткрытия, ЭтаФорма,,,,,
																		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление() 
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПланСчетовМеждународногоУчета.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.РазделИсточникаДанных");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.РазделыИсточниковДанныхБюджетирования.МеждународныйУчет;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПланСчетовМеждународногоУчета.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ПланСчетовМеждународногоУчета");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	//
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	Если Не ЗначениеЗаполнено(ТипПравил) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ТипПравила");
	Иначе
		СписокТиповПравила = Новый СписокЗначений;
		СписокТиповПравила.Добавить(Перечисления.ТипПравилаПолученияФактическихДанныхБюджетирования.ИсполнениеБюджетаИФактическиеДанные);
		
		СписокТиповПравила.Добавить(ТипПравил);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
																				"ТипПравила", СписокТиповПравила,
																				ВидСравненияКомпоновкиДанных.ВСписке, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
