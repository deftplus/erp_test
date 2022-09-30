
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьУчет2_4 = ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА_2_4();
							
	УстановитьТекстЗапросаСписок();
	
	Список.Параметры.УстановитьЗначениеПараметра("Состояние", Перечисления.СостоянияНМА.ПустаяСсылка());

	Элементы.СтраницыСведения.ТекущаяСтраница = Элементы.СтраницаСведенияНеВыбранНМА;
	
	Если ИспользоватьУчет2_4 Тогда
		
		ВедетсяРегламентированныйУчетВНА = ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА();
		
		Если НЕ ВедетсяРегламентированныйУчетВНА Тогда
			Элементы.СписокСостояниеУпр.Заголовок = НСтр("ru = 'Состояние';
														|en = 'State'");
			Элементы.СписокСостояниеРегл.Видимость = Ложь;
			Элементы.СведенияТаблицаСумм2_4Учет.Видимость = Ложь;
			Элементы.СписокДатаПринятияКУчетуУпр.Заголовок = НСтр("ru = 'Принят к учету';
																	|en = 'Recognized'");
			Элементы.СписокДатаПринятияКУчетуРегл.Видимость = Ложь;
		Иначе
			Элементы.СведенияОстаточнаяСтоимость.Видимость = Ложь;
			Элементы.СведенияНакопленнаяАмортизация.Видимость = Ложь;
			Элементы.СведенияВосстановительнаяСтоимость.Видимость = Ложь;
		КонецЕсли; 
	
	Иначе
		Элементы.СписокСостояниеРегл.Заголовок = НСтр("ru = 'Состояние';
														|en = 'State'");
		Элементы.СписокСостояниеУпр.Видимость = Ложь;
		Элементы.СписокДатаПринятияКУчетуРегл.Заголовок = НСтр("ru = 'Принят к учету';
																|en = 'Recognized'");
		Элементы.СписокДатаПринятияКУчетуУпр.Видимость = Ложь;
	КонецЕсли;
	
	ПоказатьСведения = Ложь;
	ЗаполнитьСвойстваЭлементовСведений();
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.НематериальныеАктивы);
	Элементы.ИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	НематериальныеАктивыЛокализация.ПриСозданииНаСервере_ФормаСпискаСоСведениями(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СохраненноеЗначение = Настройки.Получить("ПоказатьСведения");
	ПоказатьСведения = ?(ЗначениеЗаполнено(СохраненноеЗначение), СохраненноеЗначение, Истина);
	ЗаполнитьСвойстваЭлементовСведений();
	
	УстановитьОтборПоСостоянию(ЭтаФорма);
	
	ОтборОрганизация = Настройки.Получить("ОтборОрганизация");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		ОтборОрганизация,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборОрганизация));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	УстановитьОтборПоСостоянию(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		ОтборОрганизация,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборОрганизация));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// Из-за серверного вызова активизация строки выполняется два раза.
	Если ПредыдущаяТекущаяСтрока <> Элементы.Список.ТекущаяСтрока Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ЗаполнитьСведения", 0.2, Истина);
	КонецЕсли;
	
	ПредыдущаяТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	
КонецПроцедуры

&НаКлиенте
Процедура СведенияПринятКУчетуОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если СтрНайти(НавигационнаяСсылкаФорматированнойСтроки, "#Создать") <> 0 Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура("Основание", Элементы.Список.ТекущаяСтрока);
		ОткрытьФорму("Документ.ПринятиеКУчетуНМА2_4.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли; 
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура Сведения(Команда)
	
	ПоказатьСведения = Не ПоказатьСведения;
	Элементы.ГруппаСведения.Видимость = ПоказатьСведения;
	
	Если ПоказатьСведения Тогда
		Элементы.КнопкаСведения.Заголовок = НСтр("ru = 'Скрыть сведения';
												|en = 'Hide information'");
		ПодключитьОбработчикОжидания("Подключаемый_ЗаполнитьСведения", 0.2, Истина);
	Иначе
		Элементы.КнопкаСведения.Заголовок = НСтр("ru = 'Показать сведения';
												|en = 'Show details'");
	КонецЕсли;
	
КонецПроцедуры

#Область СтандартныеПодсистемы

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

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьТекстЗапросаСписок()

	ТекстЗапроса = НематериальныеАктивыЛокализация.ТекстЗапросаФормыСписка();
	
	Если ТекстЗапроса = Неопределено Тогда
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	СправочникНематериальныеАктивы.Ссылка,
		|	СправочникНематериальныеАктивы.ПометкаУдаления,
		|	СправочникНематериальныеАктивы.Родитель,
		|	СправочникНематериальныеАктивы.ЭтоГруппа,
		|	СправочникНематериальныеАктивы.Код,
		|	СправочникНематериальныеАктивы.Наименование,
		|	СправочникНематериальныеАктивы.НаименованиеПолное,
		|	СправочникНематериальныеАктивы.ВидНМА,
		|	СправочникНематериальныеАктивы.ПрочиеСведения,
		|	СправочникНематериальныеАктивы.ВидОбъектаУчета,
		|	СправочникНематериальныеАктивы.Предопределенный,
		|	СправочникНематериальныеАктивы.ИмяПредопределенныхДанных,
		|	ЕСТЬNULL(МестоУчетаНМА.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация,
		|	ЗНАЧЕНИЕ(Перечисление.СостоянияНМА.НеПринятКУчету) КАК СостояниеРегл,
		|	ЕСТЬNULL(ПорядокУчетаНМАУУ.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияНМА.НеПринятКУчету)) КАК СостояниеУпр,
		|	НЕОПРЕДЕЛЕНО КАК АмортизационнаяГруппа,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаПринятияКУчетуРегл,
		|	ЕСТЬNULL(ПервоначальныеСведенияНМА.ДатаПринятияКУчетуУУ, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаПринятияКУчетуУпр,
		|	ВЫБОР
		|		КОГДА НаличиеФайлов.ЕстьФайлы ЕСТЬ NULL ТОГДА 0
		|		КОГДА НаличиеФайлов.ЕстьФайлы ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ЕстьФайлы
		|ИЗ
		|	Справочник.НематериальныеАктивы КАК СправочникНематериальныеАктивы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаличиеФайлов КАК НаличиеФайлов
		|		ПО СправочникНематериальныеАктивы.Ссылка = НаличиеФайлов.ОбъектСФайлами
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестоУчетаНМА.СрезПоследних КАК МестоУчетаНМА
		|		ПО (МестоУчетаНМА.НематериальныйАктив = СправочникНематериальныеАктивы.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА.СрезПоследних КАК ПервоначальныеСведенияНМА
		|		ПО ПервоначальныеСведенияНМА.НематериальныйАктив = СправочникНематериальныеАктивы.Ссылка
		|			И ПервоначальныеСведенияНМА.Организация = МестоУчетаНМА.Организация
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаНМАУУ.СрезПоследних КАК ПорядокУчетаНМАУУ
		|		ПО (ПорядокУчетаНМАУУ.НематериальныйАктив = МестоУчетаНМА.НематериальныйАктив)
		|			И (ПорядокУчетаНМАУУ.Организация = МестоУчетаНМА.Организация)
		|ГДЕ
		|	(&Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияНМА.ПустаяСсылка)
		|		ИЛИ ЕСТЬNULL(ПорядокУчетаНМАУУ.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияНМА.НеПринятКУчету)) = &Состояние)";
		
	КонецЕсли; 
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвойстваЭлементовСведений()
	
	Элементы.ГруппаСведения.Видимость = ПоказатьСведения;
	Если ПоказатьСведения Тогда
		Элементы.КнопкаСведения.Заголовок = НСтр("ru = 'Скрыть сведения';
												|en = 'Hide information'");
	Иначе
		Элементы.КнопкаСведения.Заголовок = НСтр("ru = 'Показать сведения';
												|en = 'Show details'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаСуммСуммаБУ1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'БУ';
																|en = 'AC'"));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаСуммСуммаНУ1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'НУ';
																|en = 'TA'"));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаСуммСуммаПР1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'ПР';
																|en = 'PD'"));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаСуммСуммаВР1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'ВР';
																|en = 'TD'"));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоСостоянию(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Форма.Список,
		"Состояние",
		Форма.ОтборСостояние);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗаполнитьСведения()

	ЗаполнитьСведения(ЭтаФорма);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСведения(Форма)
	
	Если НЕ Форма.ПоказатьСведения Тогда
		Возврат;
	КонецЕсли;
	
	Элементы = Форма.Элементы;
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	ТекущиеДанные = Неопределено;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекущиеДанные = Элементы.Список.ДанныеСтроки(ТекущаяСтрока);
		Если ТекущиеДанные <> Неопределено И ТекущиеДанные.ЭтоГруппа Тогда
			ТекущиеДанные = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Элементы.СтраницыСведения.ТекущаяСтраница = Элементы.СтраницаСведенияНеВыбранНМА;
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ВидОбъектаУчета = ПредопределенноеЗначение("Перечисление.ВидыОбъектовУчетаНМА.РасходыНаНИОКР") Тогда
		Элементы.ГруппаСведения.Заголовок = НСтр("ru = 'Сведения о расходах на НИОКР';
												|en = 'R&D expense information'");
	Иначе
		Элементы.ГруппаСведения.Заголовок = НСтр("ru = 'Сведения о нематериальном активе';
												|en = 'Intangible asset information'");
	КонецЕсли;
	
	Если Форма.ИспользоватьУчет2_4 Тогда
		
		Элементы.СтраницыСведения.ТекущаяСтраница = Элементы.СтраницаСведения2_4;
		
		Форма.СведенияТаблицаСумм2_4.Очистить();
		ПредставлениеСведений = Неопределено;
		
		ЕстьСуммы = Ложь;
		ТекущаяСтрока = Форма.Элементы.Список.ТекущаяСтрока;
		Сведения2_4 = ПолучитьСведения2_4(ТекущиеДанные.Ссылка);
	
		Для Каждого ЭлМассива Из Сведения2_4.Суммы Цикл
			ЗаполнитьЗначенияСвойств(Форма.СведенияТаблицаСумм2_4.Добавить(), ЭлМассива);
			ЕстьСуммы = ЭлМассива.ВосстановительнаяСтоимость <> 0 
							ИЛИ ЭлМассива.НакопленнаяАмортизация <> 0 
							ИЛИ ЭлМассива.ОстаточнаяСтоимость <> 0 
							ИЛИ ЕстьСуммы;
		КонецЦикла;
		
		Если Сведения2_4.ВалютаУпр = Сведения2_4.ВалютаРегл Тогда
			Элементы.СведенияТаблицаСумм2_4Валюта.Видимость = Ложь;
		КонецЕсли;
		
		Если НЕ Сведения2_4.ВедетсяРегламентированныйУчетВНА
			И Сведения2_4.ВалютаУпр = Сведения2_4.ВалютаРегл Тогда
			Элементы.СведенияТаблицаСумм2_4.Видимость = Ложь;
		КонецЕсли;
		
		ПредставлениеСведений = Сведения2_4.ПредставлениеСведений;
		Если ПредставлениеСведений <> Неопределено Тогда
			
			Элементы.ОбщаяКомандаДокументыПоНематериальномуАктиву.Видимость = ПредставлениеСведений.Период <> '000101010000';
			
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияПринятКУчету1, ПредставлениеСведений.СведенияПринятКУчету1);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияМестоУчетаОрганизация, ПредставлениеСведений.СведенияМестоУчетаОрганизация);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияМестоУчетаПодразделение, ПредставлениеСведений.СведенияМестоУчетаПодразделение);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияСрокИспользования1, ПредставлениеСведений.СведенияСрокИспользования1);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияВосстановительнаяСтоимость, ПредставлениеСведений.СведенияВосстановительнаяСтоимость);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияНакопленнаяАмортизация, ПредставлениеСведений.СведенияНакопленнаяАмортизация);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияОстаточнаяСтоимость, ПредставлениеСведений.СведенияОстаточнаяСтоимость);
			
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияЛиквидационнаяСтоимость, ПредставлениеСведений.СведенияЛиквидационнаяСтоимость);
		Иначе
			
			Элементы.ОбщаяКомандаДокументыПоНематериальномуАктиву.Видимость = Ложь;
			Элементы.СведенияПринятКУчету1.Видимость = Ложь;
			Элементы.СведенияМестоУчетаОрганизация.Видимость = Ложь;
			Элементы.СведенияМестоУчетаПодразделение.Видимость = Ложь;
			Элементы.СведенияСрокИспользования1.Видимость = Ложь;
			Элементы.СведенияВосстановительнаяСтоимость.Видимость = Ложь;
			Элементы.СведенияНакопленнаяАмортизация.Видимость = Ложь;
			Элементы.СведенияОстаточнаяСтоимость.Видимость = Ложь;
			Элементы.СведенияЛиквидационнаяСтоимость.Видимость = Ложь;
			
		КонецЕсли;
		
		Элементы.СведенияПринятКУчету2.Видимость = Ложь;
		Элементы.СведенияАмортизационнаяГруппа.Видимость = Ложь;
		Элементы.СведенияСрокИспользования2.Видимость = Ложь;
		Элементы.СведенияСрокИспользования3.Видимость = Ложь;
		
		Если ТекущиеДанные.ВидОбъектаУчета = ПредопределенноеЗначение("Перечисление.ВидыОбъектовУчетаНМА.РасходыНаНИОКР") Тогда
			Элементы.СведенияТаблицаСумм2_4ВосстановительнаяСтоимость.Заголовок = НСтр("ru = 'Первоначальная
                                                                                        |стоимость';
                                                                                        |en = 'Initial
                                                                                        |cost'");
			Элементы.СведенияТаблицаСумм2_4НакопленнаяАмортизация.Заголовок = НСтр("ru = 'Погашенная
                                                                                    |стоимость';
                                                                                    |en = 'Repaid
                                                                                    |cost'");
		Иначе
			Элементы.СведенияТаблицаСумм2_4ВосстановительнаяСтоимость.Заголовок = НСтр("ru = 'Восстано-
                                                                                        |вительная
                                                                                        |стоимость';
                                                                                        |en = 'Replace-
                                                                                        |ment
                                                                                        |cost'");
			Элементы.СведенияТаблицаСумм2_4НакопленнаяАмортизация.Заголовок = НСтр("ru = 'Накопленная
                                                                                    |амортизация';
                                                                                    |en = 'Accumulated
                                                                                    |depreciation'");
		КонецЕсли; 
		
	Иначе	
		
		Элементы.СтраницыСведения.ТекущаяСтраница = Элементы.СтраницаСведения2_2;
		Сведения2_2 = ПолучитьСведения2_2(Элементы.Список.ТекущаяСтрока);
		
	КонецЕсли;
	
	ВнеоборотныеАктивыКлиентСерверЛокализация.ЗаполнитьСведенияВФормеСпискаНМА(Форма, Сведения2_4, Сведения2_2);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСведения2_2(ВнеоборотныйАктив)
	
	Сведения2_2 = НематериальныеАктивыЛокализация.ПолучитьСведения2_2(ВнеоборотныйАктив);
	
	Возврат Сведения2_2;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСведения2_4(Знач ВнеоборотныйАктив)

	СведенияОбУчете = Справочники.НематериальныеАктивы.СведенияОбУчете(ВнеоборотныйАктив);
	СтоимостьИАмортизация = ВнеоборотныеАктивы.СтоимостьИАмортизацияНМА(ВнеоборотныйАктив);

	МассивСумм = Новый Массив;
	
	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(СведенияОбУчете.Организация);
	
	Сведения2_4 = Новый Структура;
	
	НематериальныеАктивыЛокализация.ДополнитьСведения2_4(
		ВнеоборотныйАктив, СведенияОбУчете, СтоимостьИАмортизация, МассивСумм, Сведения2_4);
	
	ВедетсяРегламентированныйУчетВНА = ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА();
	Сведения2_4.Вставить("ВедетсяРегламентированныйУчетВНА", ВедетсяРегламентированныйУчетВНА);
	Сведения2_4.Вставить("ВалютаУпр", ВалютаУпр);
	Сведения2_4.Вставить("ВалютаРегл", ВалютаРегл);
	
	Если НЕ ВедетсяРегламентированныйУчетВНА
		И ВалютаУпр <> ВалютаРегл Тогда
		
		// БУ
		ДанныеУчета = Новый Структура;
		ДанныеУчета.Вставить("Учет", "БУ");
		ДанныеУчета.Вставить("Валюта", ВалютаРегл);
		ДанныеУчета.Вставить("ВосстановительнаяСтоимость", СтоимостьИАмортизация.СтоимостьРегл);
		ДанныеУчета.Вставить("НакопленнаяАмортизация", СтоимостьИАмортизация.АмортизацияРегл);
		ДанныеУчета.Вставить("ОстаточнаяСтоимость", СтоимостьИАмортизация.СтоимостьРегл - СтоимостьИАмортизация.АмортизацияРегл);
		МассивСумм.Добавить(ДанныеУчета);
		
	КонецЕсли; 
		
	// УУ
	ДанныеУчета = Новый Структура;
	ДанныеУчета.Вставить("Учет", "УУ");
	ДанныеУчета.Вставить("Валюта", ВалютаУпр);
	ДанныеУчета.Вставить("ВосстановительнаяСтоимость", СтоимостьИАмортизация.Стоимость);
	ДанныеУчета.Вставить("НакопленнаяАмортизация", СтоимостьИАмортизация.Амортизация);
	ДанныеУчета.Вставить("ОстаточнаяСтоимость", СтоимостьИАмортизация.Стоимость - СтоимостьИАмортизация.Амортизация);
	МассивСумм.Добавить(ДанныеУчета);
	
	ПредставлениеСведений = Справочники.НематериальныеАктивы.ПредставлениеСведенийОбУчете(СведенияОбУчете, СтоимостьИАмортизация, Ложь);
	
	Сведения2_4.Вставить("ПредставлениеСведений", ПредставлениеСведений);
	Сведения2_4.Вставить("Суммы", МассивСумм);
	
	Возврат Сведения2_4;
	
КонецФункции

#КонецОбласти