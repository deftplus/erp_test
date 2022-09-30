#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДатаНачала			= Неопределено;
	ДатаОкончания		= Неопределено;
	ОтметитьОрганизации	= Неопределено;
	
	Параметры.Свойство("Склад",					Склад);
	Параметры.Свойство("ДатаНачала",			ДатаНачала);
	Параметры.Свойство("ДатаОкончания",			ДатаОкончания);
	Параметры.Свойство("ОтметитьОрганизации",	ОтметитьОрганизации);
	
	Если ЗначениеЗаполнено(ДатаНачала)
		И ЗначениеЗаполнено(ДатаОкончания) Тогда
		
		ПериодИнвентаризации.ДатаНачала		= ДатаНачала;
		ПериодИнвентаризации.ДатаОкончания	= ДатаОкончания;
		
	КонецЕсли;
	
	Склад				= ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	ОтметитьОрганизации = ?(ТипЗнч(ОтметитьОрганизации) = Тип("Массив"), ОтметитьОрганизации, Новый Массив);
	
	ИспользоватьНесколькоОрганизаций		= ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	ИспользоватьУправленческуюОрганизацию	= Константы.ИспользоватьУправленческуюОрганизацию.Получить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаТаблицаОрганизаций();
	
	Запрос.УстановитьПараметр("ОтметитьОрганизации",					ОтметитьОрганизации);
	Запрос.УстановитьПараметр("ИспользоватьУправленческуюОрганизацию",	ИспользоватьУправленческуюОрганизацию);
	Запрос.УстановитьПараметр("Склад",									Склад);
	Запрос.УстановитьПараметр("ДатаНачала",								ПериодИнвентаризации.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания",							ПериодИнвентаризации.ДатаОкончания);
	
	РезультатЗапроса	= Запрос.ВыполнитьПакетСПромежуточнымиДанными();
	СписокОрганизаций	= РезультатЗапроса[0].Выгрузить().ВыгрузитьКолонку("Организация");
	
	ТаблицаОрганизаций.Загрузить(РезультатЗапроса[РезультатЗапроса.ВГраница()].Выгрузить());
	
	Если ИспользоватьНесколькоОрганизаций Тогда
		Элементы.СтраницыОрганизации.ТекущаяСтраница = Элементы.СтраницаНесколькоОрганизаций;
	Иначе
		Элементы.СтраницыОрганизации.ТекущаяСтраница = Элементы.СтраницаОднаОрганизация;
		
		Если СписокОрганизаций.Количество() = 0 Тогда
			Отказ		= Истина;
			ТекстОшибки	= НСтр("ru = 'Невозможно сформировать инвентаризационную опись, т.к. в настройках программы не введены сведения об организации.';
									|en = 'Cannot generate a physical inventory sheet as the company information is not entered in the application settings.'");
			
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		Если ТаблицаОрганизаций.Количество() > 0
			И ТаблицаОрганизаций[0].Требуется Тогда
			
			Элементы.СтраницыПотребностьФормированияОписей.ТекущаяСтраница = Элементы.СтраницаОписиФормироватьНужно;
			
		Иначе
			Элементы.СтраницыПотребностьФормированияОписей.ТекущаяСтраница = Элементы.СтраницаОписиФормироватьНеНужно;
		КонецЕсли;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодИнвентаризацииПриИзменении(Элемент)
	
	ПериодИнвентаризацииПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОписи

&НаКлиенте
Процедура ОписиПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Назад(Команда)
	
	Оповещение		= Новый ОписаниеОповещения("НазадЗавершение", ЭтаФорма);
	ТекстВопроса	= НСтр("ru = 'При возврате на предыдущий шаг сформированные инвентаризационные описи будут удалены. Продолжить?';
							|en = 'Generated physical inventory sheets will be removed if you return to the previous step. Continue?'");
	
	СписокКнопок = Новый СписокЗначений;
	СписокКнопок.Добавить("Удалить",	НСтр("ru = 'Удалить';
											|en = 'Delete'"));
	СписокКнопок.Добавить("Отмена",		НСтр("ru = 'Отмена';
												|en = 'Cancel'"));
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, СписокКнопок, , "Отмена");
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	ОчиститьСообщения();
	
	ЕстьОшибки = Ложь;
	
	Если Не ЗначениеЗаполнено(ПериодИнвентаризации.ДатаНачала)
		Или Не ЗначениеЗаполнено(ПериодИнвентаризации.ДатаОкончания) Тогда
		
		ЕстьОшибки	= Истина;
		ТекстОшибки	= НСтр("ru = 'Заполните период инвентаризации.';
								|en = 'Fill in physical inventory count period.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПериодИнвентаризации");
		
	КонецЕсли;
	
	Если ПериодИнвентаризации.ДатаНачала > ПериодИнвентаризации.ДатаОкончания Тогда
		ЕстьОшибки	= Истина;
		ТекстОшибки	= НСтр("ru = 'Заполните корректно период инвентаризации.';
								|en = 'Fill in physical inventory count period correctly.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПериодИнвентаризации");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Склад) Тогда
		ЕстьОшибки	= Истина;
		ТекстОшибки	= НСтр("ru = 'Заполните Склад.';
								|en = 'Fill in Warehouse.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "Склад");
	КонецЕсли;
	
	Если ИспользоватьНесколькоОрганизаций Тогда
		
		ОтборПоиска				= Новый Структура("Отметка", Истина);
		ОтмеченныеОрганизации	= ТаблицаОрганизаций.НайтиСтроки(ОтборПоиска);
		
		Если ОтмеченныеОрганизации.Количество() = 0 Тогда
			ЕстьОшибки	= Истина;
			ТекстОшибки	= НСтр("ru = 'Выберите одну или несколько организаций, по которым необходимо создать инвентаризационные описи.';
									|en = 'Select one or several companies for which physical inventory sheets should be created.'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ТаблицаОрганизаций", "Объект");
		КонецЕсли;
		
	ИначеЕсли ТаблицаОрганизаций.Количество() = 0 Тогда
		
		ЕстьОшибки = Истина;
		ТекстОшибки = НСтр("ru = 'Нет складских актов в указанном периоде, по которым не сформированы описи, поэтому нет потребности в формировании описи.';
							|en = 'There are no warehouse acts in the specified period for which sheets were not generated, thus there is no need to generate an sheet.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		
	Иначе
		ТаблицаОрганизаций[0].Отметка = Истина;
	КонецЕсли;
	
	Если ЕстьОшибки Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьОшибки = ЕстьОшибки 
				Или Не ДалееСервер();
	
	Если ЕстьОшибки Тогда
		Возврат;
	Иначе
		ОчиститьСообщения();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	Закрыть(СписокСозданныхОписей.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметкуСоВсех(Команда)
	
	Для Каждого Строка Из ТаблицаОрганизаций Цикл
		Строка.Отметка = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	Для Каждого Строка Из ТаблицаОрганизаций Цикл
		Строка.Отметка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОрганизацииПоУмолчанию(Команда)
	
	Для каждого СтрТабл Из ТаблицаОрганизаций Цикл
		СтрТабл.Отметка = СтрТабл.Требуется;
	КонецЦикла;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Описи);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Описи, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Описи);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Описи);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ДалееСервер()
	
	СозданныеДокументы = СоздатьДокументыСервер();
	СписокСозданныхОписей.ЗагрузитьЗначения(СозданныеДокументы);
	
	Описи.Отбор.Элементы.Очистить();
	ЭлементОтбора = Описи.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.ПравоеЗначение = СозданныеДокументы;
	ЭлементОтбора.Использование = Истина;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраница2;
	Элементы.КнопкаГотово.КнопкаПоУмолчанию = Истина;
		
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция СоздатьДокументыСервер()
	
	СозданныеДокументы = Новый Массив;
	
	Для Каждого СтрТабл Из ТаблицаОрганизаций Цикл
		
		Если Не СтрТабл.Отметка Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеЗаполнения = Новый Структура;
		ДанныеЗаполнения.Вставить("ДатаНачала",		ПериодИнвентаризации.ДатаНачала);
		ДанныеЗаполнения.Вставить("ДатаОкончания",	ПериодИнвентаризации.ДатаОкончания);
		ДанныеЗаполнения.Вставить("Склад",			Склад);
		ДанныеЗаполнения.Вставить("Организация",	СтрТабл.Организация);
		
		ДокументОбъект = Документы.ИнвентаризационнаяОпись.СоздатьДокумент();
		ДокументОбъект.Заполнить(ДанныеЗаполнения);
		ДокументОбъект.Дата = ПериодИнвентаризации.ДатаОкончания;
		
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		СозданныеДокументы.Добавить(ДокументОбъект.Ссылка);
		
	КонецЦикла;
	
	Возврат СозданныеДокументы;
	
КонецФункции

&НаКлиенте
Процедура НазадЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = Неопределено
		Или Ответ = "Отмена" Тогда
		
		Возврат;
		
	КонецЕсли;
	
	УдалитьДокументыСервер(СписокСозданныхОписей.ВыгрузитьЗначения());
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница	= Элементы.ГруппаСтраница1;
	Элементы.КнопкаДалее.КнопкаПоУмолчанию	= Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьДокументыСервер(СписокСозданныхОписей)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого ДокументСсылка Из СписокСозданныхОписей Цикл
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
		
		ДокументОбъект.Удалить();
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПериодИнвентаризацииПриИзмененииСервер()
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаТаблицаОрганизаций(Ложь);
	
	Запрос.УстановитьПараметр("ТаблицаОрганизаций",	ТаблицаОрганизаций.Выгрузить());
	Запрос.УстановитьПараметр("Склад",				Склад);
	Запрос.УстановитьПараметр("ДатаНачала",			ПериодИнвентаризации.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания",		ПериодИнвентаризации.ДатаОкончания);
	
	ТаблицаОрганизаций.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Функция ТекстЗапросаТаблицаОрганизаций(ИнициализацияТаблицыОрганизаций = Истина)
	
	Если ИнициализацияТаблицыОрганизаций Тогда
		
		ТекстЗапросаВТОрганизаций = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Организации.Ссылка КАК Организация,
		|	ВЫБОР
		|		КОГДА Организации.Ссылка В(&ОтметитьОрганизации)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Отметка
		|ПОМЕСТИТЬ ТаблицаОрганизаций
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	(Не &ИспользоватьУправленческуюОрганизацию
		|			И НЕ Организации.Предопределенный
		|		ИЛИ &ИспользоватьУправленческуюОрганизацию)";
		
	Иначе
		
		ТекстЗапросаВТОрганизаций =
		"ВЫБРАТЬ
		|	ТаблицаОрганизаций.Организация	КАК Организация,
		|	ТаблицаОрганизаций.Отметка		КАК Отметка
		|ПОМЕСТИТЬ ТаблицаОрганизаций
		|ИЗ
		|	&ТаблицаОрганизаций КАК ТаблицаОрганизаций";
		
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапросаВТОрганизаций + ОбщегоНазначенияУТ.РазделительЗапросовВПакете() +
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Дата, ДЕНЬ)	КАК Дата,
	|	ВложенныйЗапрос.Организация					КАК Организация
	|ПОМЕСТИТЬ ОрганизацииИзАктов
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОприходованиеИзлишковТоваров.Дата			КАК Дата,
	|		ОприходованиеИзлишковТоваров.Организация	КАК Организация
	|	ИЗ
	|		Документ.ОприходованиеИзлишковТоваров КАК ОприходованиеИзлишковТоваров
	|	ГДЕ
	|		ОприходованиеИзлишковТоваров.Проведен
	|		И ОприходованиеИзлишковТоваров.Склад = &Склад
	|		И ОприходованиеИзлишковТоваров.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПересортицаТоваров.Дата			КАК Дата,
	|		ПересортицаТоваров.Организация	КАК Организация
	|	ИЗ
	|		Документ.ПересортицаТоваров КАК ПересортицаТоваров
	|	ГДЕ
	|		ПересортицаТоваров.Проведен
	|		И ПересортицаТоваров.Склад = &Склад
	|		И ПересортицаТоваров.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПорчаТоваров.Дата			КАК Дата,
	|		ПорчаТоваров.Организация	КАК Организация
	|	ИЗ
	|		Документ.ПорчаТоваров КАК ПорчаТоваров
	|	ГДЕ
	|		ПорчаТоваров.Проведен
	|		И ПорчаТоваров.Склад = &Склад
	|		И ПорчаТоваров.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СписаниеНедостачТоваров.Дата		КАК Дата,
	|		СписаниеНедостачТоваров.Организация	КАК Организация
	|	ИЗ
	|		Документ.СписаниеНедостачТоваров КАК СписаниеНедостачТоваров
	|	ГДЕ
	|		СписаниеНедостачТоваров.Проведен
	|		И СписаниеНедостачТоваров.Склад = &Склад
	|		И СписаниеНедостачТоваров.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания) КАК ВложенныйЗапрос
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаОрганизаций.Организация	КАК Организация,
	|	ТаблицаОрганизаций.Отметка		КАК Отметка,
	|	ВЫБОР
	|		КОГДА ОрганизацииИзАктов.Организация ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ							КАК Требуется
	|ИЗ
	|	ТаблицаОрганизаций КАК ТаблицаОрганизаций
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОрганизацииИзАктов КАК ОрганизацииИзАктов
	|		ПО ТаблицаОрганизаций.Организация = ОрганизацииИзАктов.Организация
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИнвентаризационнаяОпись КАК ИнвентаризационнаяОпись
	|		ПО ИнвентаризационнаяОпись.Проведен
	|			И ОрганизацииИзАктов.Организация = ИнвентаризационнаяОпись.Организация
	|			И ИнвентаризационнаяОпись.Склад = &Склад
	|			И ОрганизацииИзАктов.Дата МЕЖДУ ИнвентаризационнаяОпись.ДатаНачала И ИнвентаризационнаяОпись.ДатаОкончания
	|
	|ГДЕ
	|	ИнвентаризационнаяОпись.Ссылка ЕСТЬ NULL
	|
	|УПОРЯДОЧИТЬ ПО
	|	Отметка УБЫВ,
	|	ТаблицаОрганизаций.Организация";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти
