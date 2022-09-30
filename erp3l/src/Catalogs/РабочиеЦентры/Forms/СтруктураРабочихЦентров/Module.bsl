
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗагрузитьНастройки();
	
	Если НЕ Параметры.Подразделение.Пустая() Тогда
		Подразделение = Параметры.Подразделение;
	КонецЕсли;
	Если Параметры.РедактироватьУчастки Тогда
		РежимРаботыПоУчасткам = Истина;
	КонецЕсли;
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.РабочиеЦентры);
	Элементы.РабочиеЦентрыИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.РабочиеЦентрыКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	ВидыРабочихЦентровПерваяАктивизация = Истина;
	УчасткиПерваяАктивизация = Истина;
	
	ЗаполнитьПоПодразделению(ЭтаФорма);
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов("СправочникСсылка.РабочиеЦентры");
	ПараметрыРазмещения.КоманднаяПанель = Элементы.РабочиеЦентры.КоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_РабочиеЦентры" Тогда
		// Обновим счетчик количества РЦ
		Элементы.ВидыРабочихЦентров.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	СохранитьНастройки(ЭтотОбъект);
	
	ЗаполнитьПоПодразделению(ЭтаФорма);
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "Подразделение,РежимРаботыПоУчасткам");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаголовокВедущийСписокОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	РежимРаботыПоУчасткам = НЕ РежимРаботыПоУчасткам;
	
	СохранитьНастройки(ЭтотОбъект);
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "РежимРаботыПоУчасткам");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыРабочихЦентров

&НаКлиенте
Процедура ВидыРабочихЦентровПриАктивизацииСтроки(Элемент)
	
	Если ОтборПоВидуУчастку Тогда
		
		Если ВидыРабочихЦентровПерваяАктивизация Тогда
			НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "ВидыРабочихЦентров");
		Иначе
			ПодключитьОбработчикОжидания("ВидыРабочихЦентровПриАктивизацииСтрокиОтложенно", 0.2, Истина);
		КонецЕсли;
		
	КонецЕсли; 
	
	ВидыРабочихЦентровПерваяАктивизация = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыРабочихЦентровПриАктивизацииСтрокиОтложенно()
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "ВидыРабочихЦентров");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУчастки

&НаКлиенте
Процедура УчасткиПриАктивизацииСтроки(Элемент)
	
	Если ОтборПоВидуУчастку Тогда
		
		Если УчасткиПерваяАктивизация Тогда
			НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "Участки");
		Иначе
			ПодключитьОбработчикОжидания("УчасткиПриАктивизацииСтрокиОтложенно", 0.2, Истина);
		КонецЕсли;
		
	КонецЕсли; 
	
	УчасткиПерваяАктивизация = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура УчасткиПриАктивизацииСтрокиОтложенно()
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "Участки");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРабочиеЦентры

&НаКлиенте
Процедура РабочиеЦентрыПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура РабочиеЦентрыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа)
	
	Если ЭтоГруппа ИЛИ Копирование Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	
	Если РежимРаботыПоУчасткам Тогда
		
		ТекущаяСтрока = Элементы.Участки.ТекущаяСтрока;
		Если ОтборПоВидуУчастку И ТекущаяСтрока <> Неопределено Тогда
			
			Если ТипЗнч(ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				ЗначенияЗаполнения.Вставить("Подразделение", ТекущаяСтрока.Ключ);
			Иначе
				ЗначенияЗаполнения.Вставить("Участок", ТекущаяСтрока);
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ТекущаяСтрока = Элементы.ВидыРабочихЦентров.ТекущаяСтрока;
		Если ОтборПоВидуУчастку	И ТекущаяСтрока <> Неопределено Тогда
			ЗначенияЗаполнения.Вставить("ВидРабочегоЦентра", ТекущаяСтрока);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначенияЗаполнения.Количество() = 0 И НЕ Подразделение.Пустая() Тогда
		ЗначенияЗаполнения.Вставить("Подразделение", Подразделение);
	КонецЕсли;
	
	Если ЗначенияЗаполнения.Количество() > 0 Тогда
		
		Отказ = Истина;
		
		ОткрытьФорму("Справочник.РабочиеЦентры.ФормаОбъекта",
			Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения));
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РабочиеЦентрыПриЗагрузкеПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "РабочиеЦентры_ПользовательскиеНастройки");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.РабочиеЦентры);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.РабочиеЦентры, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.РабочиеЦентры);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОтборПоВиду(Команда)
	
	ОтборПоВидуУчастку = НЕ ОтборПоВидуУчастку;
	
	СохранитьНастройки(ЭтотОбъект);
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "ОтборПоВидуУчастку,ВидыРабочихЦентров");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоУчастку(Команда)
	
	ОтборПоВидуУчастку = НЕ ОтборПоВидуУчастку;
	
	СохранитьНастройки(ЭтотОбъект);
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "ОтборПоВидуУчастку,Участки");
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.РабочиеЦентры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьПоПодразделению(Форма)
	
	ПараметрыФО = Новый Структура(
		"Подразделение",
		?(ЗначениеЗаполнено(Форма.Подразделение), Форма.Подразделение, Неопределено));
	
	Форма.УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
	Форма.ЕстьУчастки = Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьПроизводственныеУчастки");
	
	Если НЕ Форма.ЕстьУчастки И Форма.РежимРаботыПоУчасткам Тогда
		
		Форма.РежимРаботыПоУчасткам = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")
	
	Элементы = Форма.Элементы;
	
	Инициализация = ПустаяСтрока(СписокРеквизитов);
	СтруктураРеквизитов = Новый Структура(СписокРеквизитов);
	
	// Настройка по режиму работы - виды РЦ/участки
	Если СтруктураРеквизитов.Свойство("РежимРаботыПоУчасткам")
		ИЛИ Инициализация Тогда
		
		Элементы.РабочиеЦентрыОтборПоВиду.Видимость = НЕ Форма.РежимРаботыПоУчасткам;
		Элементы.РабочиеЦентрыОтборПоУчастку.Видимость = Форма.РежимРаботыПоУчасткам;
		
		Элементы.СтраницыВедущийСписок.ТекущаяСтраница = ?(Форма.РежимРаботыПоУчасткам,
			Элементы.СтраницаУчастки,
			Элементы.СтраницаВидыРабочихЦентров);
		
		МассивСтрок = Новый Массив;
		
		Если Форма.ЕстьУчастки Тогда
			
			Если Форма.РежимРаботыПоУчасткам Тогда
				МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Участки';
																		|en = 'Areas'")));
			Иначе
				МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Участки';
																		|en = 'Areas'"),,,,"#Участки"));
			КонецЕсли;
			
			МассивСтрок.Добавить("  ");
			
		КонецЕсли;
		
		Если Форма.РежимРаботыПоУчасткам Тогда
			МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Виды рабочих центров';
																	|en = 'Work center types'"),,,,"#ВидыРЦ"));
		Иначе
			МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Виды рабочих центров';
																	|en = 'Work center types'")));
		КонецЕсли;
	
		Форма.ЗаголовокВедущийСписок = Новый ФорматированнаяСтрока(МассивСтрок);
		
	КонецЕсли;
	
	// Отбор по виду РЦ
	Если СтруктураРеквизитов.Свойство("ВидыРабочихЦентров")
		ИЛИ СтруктураРеквизитов.Свойство("РежимРаботыПоУчасткам") Тогда
		
		ЗначениеОтбора = ?(Элементы.ВидыРабочихЦентров.ТекущаяСтрока <> Неопределено,
			Элементы.ВидыРабочихЦентров.ТекущаяСтрока,
			ПредопределенноеЗначение("Справочник.ВидыРабочихЦентров.ПустаяСсылка"));
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.РабочиеЦентры, 
			"ВидРабочегоЦентра",
			ЗначениеОтбора,
			ВидСравненияКомпоновкиДанных.ВИерархии,
			, 
			Форма.ОтборПоВидуУчастку И НЕ Форма.РежимРаботыПоУчасткам);
		
	КонецЕсли;
	
	// Отбор по участку
	Если СтруктураРеквизитов.Свойство("Участки")
		ИЛИ СтруктураРеквизитов.Свойство("РежимРаботыПоУчасткам") Тогда
		
		УстановитьОтбор = Ложь;
		ЗначениеОтбора = Неопределено;
		
		Если ТипЗнч(Элементы.Участки.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			
			УстановитьОтбор = Истина;
			
			ЗначениеОтбора = ?(Элементы.Участки.ТекущаяСтрока <> Неопределено,
				Элементы.Участки.ТекущаяСтрока,
				ПредопределенноеЗначение("Справочник.ПроизводственныеУчастки.ПустаяСсылка"));
			
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.РабочиеЦентры, 
			"Участок",
			ЗначениеОтбора, 
			ВидСравненияКомпоновкиДанных.Равно,
			,
			УстановитьОтбор И Форма.ОтборПоВидуУчастку И Форма.РежимРаботыПоУчасткам);
		
	КонецЕсли;
	
	// Отбор рабочих центров по подразделению (в тч отбор по группировочной строке)
	Если СтруктураРеквизитов.Свойство("Подразделение")
		ИЛИ СтруктураРеквизитов.Свойство("Участки")
		ИЛИ СтруктураРеквизитов.Свойство("РежимРаботыПоУчасткам") Тогда
		
		УстановитьОтбор = Ложь;
		ЗначениеОтбора = Неопределено;
		
		Если ЗначениеЗаполнено(Форма.Подразделение) Тогда
			
			УстановитьОтбор = Истина;
			ЗначениеОтбора = Форма.Подразделение;
			
		ИначеЕсли Форма.ОтборПоВидуУчастку
			И Форма.РежимРаботыПоУчасткам
			И ТипЗнч(Элементы.Участки.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			
			УстановитьОтбор = Истина;
			ЗначениеОтбора = Элементы.Участки.ТекущаяСтрока.Ключ;
			
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.РабочиеЦентры, 
			"ВидРабочегоЦентра.Подразделение", 
			ЗначениеОтбора,
			ВидСравненияКомпоновкиДанных.Равно,
			, 
			УстановитьОтбор);
		
	КонецЕсли;
	
	// Отбор рабочих центров по подразделению (инициализация)
	Если Инициализация Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.РабочиеЦентры, 
			"ВидРабочегоЦентра.Подразделение", 
			Форма.Подразделение, 
			ВидСравненияКомпоновкиДанных.Равно,
			, 
			ЗначениеЗаполнено(Форма.Подразделение));
			
	КонецЕсли;
	
	// Отбор по подразделению
	Если СтруктураРеквизитов.Свойство("Подразделение")
		ИЛИ Инициализация Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.ВидыРабочихЦентров, 
			"Подразделение", 
			Форма.Подразделение, 
			ВидСравненияКомпоновкиДанных.Равно,
			, 
			ЗначениеЗаполнено(Форма.Подразделение));
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.Участки, 
			"Владелец", 
			Форма.Подразделение, 
			ВидСравненияКомпоновкиДанных.Равно,
			, 
			ЗначениеЗаполнено(Форма.Подразделение));
		
	КонецЕсли;
	
	// Отображение списка РЦ
	Если СтруктураРеквизитов.Свойство("ОтборПоВидуУчастку")
		ИЛИ СтруктураРеквизитов.Свойство("Подразделение")
		ИЛИ СтруктураРеквизитов.Свойство("РабочиеЦентры_ПользовательскиеНастройки")
		ИЛИ Инициализация Тогда
		
		Если Форма.ОтборПоВидуУчастку ИЛИ НЕ Форма.Подразделение.Пустая() Тогда
			
			// Включили отбор
			Если Форма.ОтображениеСпискаРабочихЦентров = Неопределено
				ИЛИ СтруктураРеквизитов.Свойство("РабочиеЦентры_ПользовательскиеНастройки") Тогда
				
				Форма.ОтображениеСпискаРабочихЦентров = Элементы.РабочиеЦентры.Отображение;
				
			КонецЕсли;
			
			Если Элементы.РабочиеЦентры.Отображение <> ОтображениеТаблицы.Список Тогда
				
				Элементы.РабочиеЦентры.Отображение = ОтображениеТаблицы.Список;
				
			КонецЕсли;
			
		ИначеЕсли Форма.ОтображениеСпискаРабочихЦентров <> Неопределено Тогда
			
			// Отключили отбор
			Элементы.РабочиеЦентры.Отображение = Форма.ОтображениеСпискаРабочихЦентров;
			ОтображениеСпискаРабочихЦентров = Неопределено;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Пометка кнопок ОтборПоВидуУчастку
	Если СтруктураРеквизитов.Свойство("ОтборПоВидуУчастку") 
		ИЛИ Инициализация Тогда
		
		Элементы.РабочиеЦентрыОтборПоВиду.Пометка = Форма.ОтборПоВидуУчастку;
		Элементы.РабочиеЦентрыОтборПоУчастку.Пометка = Форма.ОтборПоВидуУчастку;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройки()
	
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"Справочник.РабочиеЦентры.СтруктураРабочихЦентров",
		Неопределено);
	
	Если ТипЗнч(Настройки) = Тип("Структура") Тогда
		
		Настройки.Свойство("Подразделение",         Подразделение);
		Настройки.Свойство("ОтборПоВидуУчастку",    ОтборПоВидуУчастку);
		Настройки.Свойство("РежимРаботыПоУчасткам", РежимРаботыПоУчасткам);
		
	Иначе
		
		// Настройки не сохранялись, установка значений по умолчанию
		ОтборПоВидуУчастку = Истина;
		РежимРаботыПоУчасткам = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СохранитьНастройки(Форма)
	
	Настройки = Новый Структура;
	
	Настройки.Вставить("Подразделение",         Форма.Подразделение);
	Настройки.Вставить("ОтборПоВидуУчастку",    Форма.ОтборПоВидуУчастку);
	Настройки.Вставить("РежимРаботыПоУчасткам", Форма.РежимРаботыПоУчасткам);
	
	ЗаписатьНастройкиВХранилище(Настройки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьНастройкиВХранилище(Настройки)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"Справочник.РабочиеЦентры.СтруктураРабочихЦентров",
		Неопределено,
		Настройки);
	
КонецПроцедуры

#КонецОбласти
