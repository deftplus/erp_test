
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьСведения = Ложь;
	ЗаполнитьСвойстваЭлементовСведений();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	//++ НЕ УТКА
	УстановитьТекстЗапроса();
	//-- НЕ УТКА
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СохраненноеЗначение = Настройки.Получить("ПоказатьСведения");
	ПоказатьСведения = ?(ЗначениеЗаполнено(СохраненноеЗначение), СохраненноеЗначение, Истина);
	ЗаполнитьСвойстваЭлементовСведений();
	
	ОтборСостояние = Настройки.Получить("ОтборСостояние");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Состояние",
		ОтборСостояние,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборСостояние));
	
	ОтборОрганизация = Настройки.Получить("ОтборОрганизация");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		ОтборОрганизация,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборОрганизация));
	
	ОтборПодразделение = Настройки.Получить("ОтборПодразделение");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Подразделение",
		ОтборПодразделение,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборПодразделение));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Состояние",
		ОтборСостояние,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборСостояние));
	
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
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Подразделение",
		ОтборПодразделение,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборПодразделение));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ЗаполнитьСведения", 0.2, Истина);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сведения(Команда)
	
	ПоказатьСведения = Не ПоказатьСведения;
	Элементы.ГруппаСведения.Видимость = ПоказатьСведения;
	
	Если ПоказатьСведения Тогда
		Элементы.КнопкаСведения.Заголовок = НСтр("ru = 'Скрыть сведения';
												|en = 'Hide information'");
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

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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

&НаКлиенте
Процедура ЗаполнитьСведения()
	
	Если ПоказатьСведения Тогда
		
		СведенияТаблицаСумм.Очистить();
		
		Если Элементы.Список.ВыделенныеСтроки.Количество() <> 0 Тогда
			ДанныеСтроки = Элементы.Список.ТекущиеДанные;
			Массив = ПолучитьСведения(ДанныеСтроки.Ссылка, ДанныеСтроки.Организация, ДанныеСтроки.СчетУчета, ДанныеСтроки.СчетАмортизации);
			Для Каждого ЭлементМассива Из Массив Цикл
				ЗаполнитьЗначенияСвойств(СведенияТаблицаСумм.Добавить(), ЭлементМассива);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСведения(ВнеоборотныйАктив, Организация, СчетУчета, СчетАмортизации)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗначенияПоУмолчанию = Новый Структура;
	ЗначенияПоУмолчанию.Вставить("Стоимость", 0);
	ЗначенияПоУмолчанию.Вставить("СтоимостьПредставления", 0);
	ЗначенияПоУмолчанию.Вставить("Амортизация", 0);
	ЗначенияПоУмолчанию.Вставить("АмортизацияПредставления", 0);
	ЗначенияПоУмолчанию.Вставить("ВалютаФункциональная", Неопределено);
	ЗначенияПоУмолчанию.Вставить("ВалютаПредставления", Неопределено);
	
	//++ НЕ УТКА
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	&Организация КАК Организация,
		|	ЕСТЬNULL(Стоимость.СуммаОстаток, 0) КАК Стоимость,
		|	ЕСТЬNULL(Стоимость.СуммаПредставленияОстаток, 0) КАК СтоимостьПредставления,
		|	-ЕСТЬNULL(Амортизация.СуммаОстаток, 0) КАК Амортизация,
		|	-ЕСТЬNULL(Амортизация.СуммаПредставленияОстаток, 0) КАК АмортизацияПредставления
		|ИЗ
		|	РегистрБухгалтерии.Международный.Остатки(, Счет В (&СчетаУчета),, ПланСчетов = &ПланСчетов
		|				И Организация = &Организация
		|				И Субконто1 В (&ВнеоборотныйАктив)) КАК Стоимость
		|		ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Международный.Остатки(, Счет В (&СчетаАмортизации),, ПланСчетов = &ПланСчетов
		|					И Организация = &Организация
		|					И Субконто1 В (&ВнеоборотныйАктив)) КАК Амортизация
		|		ПО Стоимость.Субконто1 = Амортизация.Субконто1"
	);
	Запрос.УстановитьПараметр("ПланСчетов", Справочники.ПланыСчетовМеждународногоУчета.Международный);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВнеоборотныйАктив", ВнеоборотныйАктив);
	Запрос.УстановитьПараметр("СчетаУчета", СчетУчета);
	Запрос.УстановитьПараметр("СчетаАмортизации", СчетАмортизации);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(ЗначенияПоУмолчанию, Выборка);
	КонецЕсли;
	
	ВалютыУчета = МеждународныйУчетСерверПовтИсп.УчетныеВалюты(
				Справочники.ПланыСчетовМеждународногоУчета.Международный, Организация);
	ЗначенияПоУмолчанию.ВалютаФункциональная = ВалютыУчета.Функциональная;
	ЗначенияПоУмолчанию.ВалютаПредставления = ВалютыУчета.Представления;
	//-- НЕ УТКА
	
	Поля = "Представление, Сумма, СуммаПредставления, ВалютаФункциональная, ВалютаПредставления";
	
	Массив = Новый Массив;
	
	Строка = Новый Структура(Поля);
	Строка.Представление = НСтр("ru = 'Первоначальная стоимость:';
								|en = 'Initial cost:'");
	Строка.Сумма = ЗначенияПоУмолчанию.Стоимость;
	Строка.СуммаПредставления = ЗначенияПоУмолчанию.СтоимостьПредставления;
	Строка.ВалютаФункциональная = ЗначенияПоУмолчанию.ВалютаФункциональная;
	Строка.ВалютаПредставления = ЗначенияПоУмолчанию.ВалютаПредставления;
	Массив.Добавить(Строка);
	
	Строка = Новый Структура(Поля);
	Строка.Представление = НСтр("ru = 'Накопленная амортизация:';
								|en = 'Accumulated depreciation:'");
	Строка.Сумма = ЗначенияПоУмолчанию.Амортизация;
	Строка.СуммаПредставления = ЗначенияПоУмолчанию.АмортизацияПредставления;
	Строка.ВалютаФункциональная = ЗначенияПоУмолчанию.ВалютаФункциональная;
	Строка.ВалютаПредставления = ЗначенияПоУмолчанию.ВалютаПредставления;
	Массив.Добавить(Строка);
	
	Строка = Новый Структура(Поля);
	Строка.Представление = НСтр("ru = 'Остаточная стоимость:';
								|en = 'Residual value:'");
	Строка.Сумма = ЗначенияПоУмолчанию.Стоимость-ЗначенияПоУмолчанию.Амортизация;
	Строка.СуммаПредставления = ЗначенияПоУмолчанию.СтоимостьПредставления-ЗначенияПоУмолчанию.АмортизацияПредставления;
	Строка.ВалютаФункциональная = ЗначенияПоУмолчанию.ВалютаФункциональная;
	Строка.ВалютаПредставления = ЗначенияПоУмолчанию.ВалютаПредставления;
	Массив.Добавить(Строка);
	
	Возврат Массив;
	
КонецФункции

//++ НЕ УТКА

&НаСервере
Процедура УстановитьТекстЗапроса()

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	СправочникОбъектыЭксплуатации.Ссылка,
	|	СправочникОбъектыЭксплуатации.ПометкаУдаления,
	|	СправочникОбъектыЭксплуатации.Родитель,
	|	СправочникОбъектыЭксплуатации.ЭтоГруппа,
	|	СправочникОбъектыЭксплуатации.Код,
	|	СправочникОбъектыЭксплуатации.Наименование,
	|	СправочникОбъектыЭксплуатации.НаименованиеПолное,
	|	СправочникОбъектыЭксплуатации.Изготовитель,
	|	СправочникОбъектыЭксплуатации.ЗаводскойНомер,
	|	СправочникОбъектыЭксплуатации.НомерПаспорта,
	|	СправочникОбъектыЭксплуатации.ДатаВыпуска,
	|	СправочникОбъектыЭксплуатации.Комментарий,
	|	СправочникОбъектыЭксплуатации.Расположение,
	|	СправочникОбъектыЭксплуатации.Модель,
	|	СправочникОбъектыЭксплуатации.СерийныйНомер,
	|	СправочникОбъектыЭксплуатации.Предопределенный,
	|	СправочникОбъектыЭксплуатации.ИмяПредопределенныхДанных,
	|	СправочникОбъектыЭксплуатации.Статус,
	|	ЕСТЬNULL(ПорядокУчетаОСБУ.СостояниеБУ, ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету)) КАК СостояниеБУ,
	|	ЕСТЬNULL(МестонахождениеОС.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК ОрганизацияБУ,
	|	ЕСТЬNULL(СостоянияОСМФУ.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету)) КАК Состояние,
	|	ЕСТЬNULL(СостоянияОСМФУ.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация,
	|	СправочникОбъектыЭксплуатации.ГруппаОСМеждународныйУчет КАК ГруппаОСМеждународныйУчет,
	|	СостоянияОСМФУ.СчетУчета КАК СчетУчета,
	|	СостоянияОСМФУ.МетодНачисленияАмортизации КАК МетодНачисленияАмортизации,
	|	СостоянияОСМФУ.ПорядокУчета КАК ПорядокУчета,
	|	СостоянияОСМФУ.СчетАмортизации КАК СчетАмортизации,
	|	ЕСТЬNULL(СостоянияПринятОСМФУ.Период, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) КАК ДатаПринятияКУчету,
	|	СостоянияОСМФУ.ЛиквидационнаяСтоимость КАК ЛиквидационнаяСтоимость,
	|	ЕСТЬNULL(СостоянияОСМФУ.Подразделение, ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)) КАК Подразделение
	|ИЗ
	|	Справочник.ОбъектыЭксплуатации КАК СправочникОбъектыЭксплуатации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСредстваМеждународныйУчет.СрезПоследних(, ) КАК СостоянияОСМФУ
	|		ПО (СостоянияОСМФУ.ОсновноеСредство = СправочникОбъектыЭксплуатации.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСредстваМеждународныйУчет.СрезПоследних(, Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКУчету)) КАК СостоянияПринятОСМФУ
	|		ПО (СостоянияПринятОСМФУ.ОсновноеСредство = СправочникОбъектыЭксплуатации.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних КАК МестонахождениеОС
	|		ПО СправочникОбъектыЭксплуатации.Ссылка = МестонахождениеОС.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаОСБУ.СрезПоследних КАК ПорядокУчетаОСБУ
	|		ПО (МестонахождениеОС.ОсновноеСредство = ПорядокУчетаОСБУ.ОсновноеСредство)
	|			И (МестонахождениеОС.Организация = ПорядокУчетаОСБУ.Организация)";

	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
КонецПроцедуры

//-- НЕ УТКА
#КонецОбласти