
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	Если Параметры.Свойство("КлючНазначенияИспользования") 
		И ЗначениеЗаполнено(Параметры.КлючНазначенияИспользования) Тогда
		КлючНазначенияИспользования = Параметры.КлючНазначенияИспользования;
	ИначеЕсли Параметры.Свойство("КлючНазначенияФормы")
		И Не ПустаяСтрока(Параметры.КлючНазначенияФормы) Тогда
		КлючНазначенияИспользования = Параметры.КлючНазначенияФормы;
	Иначе
		КлючНазначенияИспользования = КлючНазначенияФормыПоУмолчанию();
	КонецЕсли;
	
	НавигационнаяСсылка = "e1cib/app/Обработка.ЖурналДокументовАвансовыеОтчеты";
	
	ВосстановитьНастройки(Параметры);
	
	ДоступныеХозяйственныеОперацииИДокументы = Обработки.ЖурналДокументовАвансовыеОтчеты.ИнициализироватьХозяйственныеОперацииИДокументы(
		ОтборХозяйственныеОперации, ОтборТипыДокументов, КлючНазначенияИспользования);
	ХозяйственныеОперацииИДокументы.Загрузить(ДоступныеХозяйственныеОперацииИДокументы);
	НастроитьФормуПоВыбраннымОперациямИДокументам(ДоступныеХозяйственныеОперацииИДокументы);
	
	ИспользуемыеТипыДокументов = ДоступныеХозяйственныеОперацииИДокументы.ВыгрузитьКолонку("ТипДокумента");
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(СписокДокументов);
	
	Если ПроверкаКонтрагентовВызовСервера.ИспользованиеПроверкиВозможно() Тогда
		Элементы.ЕстьОшибкиПроверкиКонтрагентов.Видимость = Истина;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	ИспользуемыеТипыДокументов.Добавить(Тип("ДокументСсылка.Сторно"));
	
	ТекстЗамены = "ВЫБОР
	|	КОГДА РеестрДокументовПереопределяемый.Ссылка ССЫЛКА Документ.ПриобретениеТоваровУслуг
	|		ТОГДА ВЫРАЗИТЬ(РеестрДокументовПереопределяемый.Ссылка КАК Документ.ПриобретениеТоваровУслуг)
	|	КОГДА РеестрДокументовПереопределяемый.Ссылка ССЫЛКА Документ.АвансовыйОтчет
	|		ТОГДА ВЫРАЗИТЬ(РеестрДокументовПереопределяемый.Ссылка КАК Документ.АвансовыйОтчет)
	//++ Локализация
	//++ НЕ УТ
	|	КОГДА РеестрДокументовПереопределяемый.Ссылка ССЫЛКА Документ.ПоступлениеДенежныхДокументов
	|		ТОГДА ВЫРАЗИТЬ(РеестрДокументовПереопределяемый.Ссылка КАК Документ.ПоступлениеДенежныхДокументов)
	//-- НЕ УТ
	//-- Локализация	
	|КОНЕЦ";
	
	СписокДокументов.ТекстЗапроса = СтрЗаменить(СписокДокументов.ТекстЗапроса, "&Ссылка", ТекстЗамены);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов(ИспользуемыеТипыДокументов);
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СписокДокументовКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументов.ПриСозданииНаСервере_ФормаСписка(ЭтотОбъект,Элементы.СписокДокументов, Элементы.СписокДокументовКомментарий);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// ЭлектронноеВзаимодействие.ТорговыеПредложения
	ТорговыеПредложенияКлиент.ОбновитьПодсказкуФормы(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		СохранитьНастройки();
	КонецЕсли;
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_АвансовыйОтчет"
		Или ИмяСобытия = "Запись_ПриобретениеТоваровУслуг"
		//++ НЕ УТ
		Или ИмяСобытия = "Запись_ПоступлениеДенежныхДокументов"
		//-- НЕ УТ
		Или ИмяСобытия = "Проведение_Сторно" Или ИмяСобытия = "Запись_Сторно"
		Тогда
		
		ПриОповещенииОЗаписиОформляемогоДокумента();
	КонецЕсли;
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументовКлиент.ОбработчикОповещенияФормаСписка(ИмяСобытия, ЭтотОбъект, Элементы.СписокДокументов);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодотчетноеЛицоПриИзменении(Элемент)
	
	УстановитьОтборПоПодотчетномуЛицу();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьОтборПоОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформационнаяНадписьОтборОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ДоступныеХозяйственныеОперацииИДокументы", ПоместитьВоВременноеХранилищеХозяйственныеОперацииИДокументы());
	ПараметрыФормы.Вставить("КлючНастроек", КлючНазначенияИспользования);
	ПараметрыФормы.Вставить("КлючФормы", КлючНазначенияФормыПоУмолчанию());
	
	ОткрытьФорму("Справочник.НастройкиХозяйственныхОпераций.Форма.ФормаУстановкиОтбора",
		ПараметрыФормы,,,,, Новый ОписаниеОповещения("УстановитьОтборыПоХозОперациямИДокументам", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборыПоХозОперациямИДокументам(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
		АдресДоступныхХозяйственныхОперацийИДокументов = ВыбранноеЗначение;
		ОтборОперацияТипОбработкаВыбораСервер(АдресДоступныхХозяйственныхОперацийИДокументов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	СтруктураБыстрогоОтбора = Новый Структура;
	СтруктураБыстрогоОтбора.Вставить("Организация", Организация);
	СтруктураБыстрогоОтбора.Вставить("ПодотчетноеЛицо", ПодотчетноеЛицо);
	ПараметрыФормы.Вставить("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", КлючНазначенияФормыПоУмолчанию());
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "СтраницаРаспоряженияНаОформление" Тогда
		// &ЗамерПроизводительности
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
			"Обработка.ЖурналДокументовАвансовыеОтчеты.Команда.АвансовыеОтчетыКОформлению");
		
		ПараметрыФормы.Вставить("ИмяТекущейСтраницы", НавигационнаяСсылкаФорматированнойСтроки);
		НавигационнаяСсылкаФорматированнойСтроки = "Обработка.ЖурналДокументовАвансовыеОтчеты.Форма.АвансовыеОтчетыКОформлению";
	КонецЕсли;
	
	ОткрытьФорму(НавигационнаяСсылкаФорматированнойСтроки, ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДокументов

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Поле.Имя = "СостояниеОригиналаПервичногоДокумента" Или Поле.Имя = "СостояниеОригиналПолучен" Тогда
		// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
		УчетОригиналовПервичныхДокументовКлиент.СписокВыбор(Поле.Имя,ЭтотОбъект,Элементы.СписокДокументов, СтандартнаяОбработка);
		// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
		Возврат;
	КонецЕсли;
		
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПриАктивизацииСтроки(Элемент)
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Элементы.ГруппаСоздатьГенерируемая.ПодчиненныеЭлементы.Количество() <> 0 Тогда 
		Если Копирование Тогда
			ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элемент);
		ИначеЕсли ОтборТипыДокументов.Количество() = 1 И ОтборХозяйственныеОперации.Количество() = 1 Тогда
			ПодчиненныйЭлемент = Элементы.ГруппаСоздатьГенерируемая.ПодчиненныеЭлементы[0]; // ПолеФормы
			СтруктураКоманды = Новый Структура("Имя", ПодчиненныйЭлемент.Имя);
			Подключаемый_СоздатьДокумент(СтруктураКоманды);
		Иначе
			Подключаемый_СоздатьДокументЧерезФормуВыбора(Неопределено);
		КонецЕсли;
	КонецЕсли;
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элемент, Заголовок);
	ОбновитьГиперссылкуКОформлению();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСкопировать(Команда)
	
	ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элементы.СписокДокументов);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОтменаПроведения(Команда)
	
	ОбщегоНазначенияУТКлиент.ОтменаПроведения(Элементы.СписокДокументов, Заголовок);
	ОбновитьГиперссылкуКОформлению();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПровести(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиДокументы(Элементы.СписокДокументов, Заголовок);
	ОбновитьГиперссылкуКОформлению();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокУстановитьСнятьПометкуУдаления(Команда)
	
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элементы.СписокДокументов, Заголовок);
	ОбновитьГиперссылкуКОформлению();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокДокументовПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументов.ПриПолученииДанныхНаСервере(Строки);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СписокДокументов);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СписокДокументов, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокДокументов);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.СписокДокументов);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.СписокДокументов);
	
КонецПроцедуры
// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры
// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

// ЭлектронноеВзаимодействие.ТорговыеПредложения
&НаКлиенте
Процедура Подключаемый_ПодсказкиБизнесСетьНажатие(Команда)
	
	ТорговыеПредложенияКлиент.ОткрытьФормуПодсказок(ЭтаФорма);
	
КонецПроцедуры
// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения

&НаКлиенте
Процедура Подключаемый_СоздатьДокумент(Команда)
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Организация", Организация);
	СтруктураОтбора.Вставить("ПодотчетноеЛицо", ПодотчетноеЛицо);
	ОбщегоНазначенияУТКлиент.СоздатьДокументЧерезКоманду(Команда.Имя, СтруктураОтбора);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СоздатьДокументЧерезФормуВыбора(Команда)
	
	КлючФормы = КлючНазначенияФормыПоУмолчанию();
	АдресХозяйственныеОперацииИДокументы = ПоместитьВоВременноеХранилищеХозяйственныеОперацииИДокументы();
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Организация", Организация);
	СтруктураОтбора.Вставить("ПодотчетноеЛицо", ПодотчетноеЛицо);
	ОбщегоНазначенияУТКлиент.СоздатьДокументЧерезФормуВыбора(
		АдресХозяйственныеОперацииИДокументы, КлючФормы, КлючНазначенияИспользования, СтруктураОтбора);
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУтКлиент.РедактироватьПериод(Период,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Период = ВыбранноеЗначение;
	УстановитьОтборПоПериоду();
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоПодготовленные(Команда)
	
	Элементы.СписокДокументовТолькоПодготовленные.Пометка = Не Элементы.СписокДокументовТолькоПодготовленные.Пометка;
	
	ТолькоПодготовленные = ?(Элементы.СписокДокументовТолькоПодготовленные.Пометка, 1, 0);
	ТолькоПодготовленныеПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрольДенежныхСредств(Команда)
	
	ПараметрыФормы = Новый Структура("Отбор, КлючВарианта, КлючНазначенияИспользования, СформироватьПриОткрытии");
	ПараметрыФормы.СформироватьПриОткрытии = Истина;
	
	ПараметрыФормы.КлючВарианта = "КонтрольДенежныхСредствУПодотчетныхЛиц";
	ПараметрыФормы.КлючНазначенияИспользования = "КонтрольДенежныхСредствУПодотчетныхЛиц";
	
	Отбор = Новый Структура;
	Если ЗначениеЗаполнено(ПодотчетноеЛицо) Тогда
		Отбор.Вставить("ПодотчетноеЛицо", ПодотчетноеЛицо);
	КонецЕсли;
	Если ЗначениеЗаполнено(Организация) Тогда
		Отбор.Вставить("Организация", Организация);
	КонецЕсли;
	ПараметрыФормы.Отбор = Отбор;
	
	ОткрытьФорму("Отчет.КонтрольОперацийСДенежнымиСредствами.Форма", ПараметрыФормы, ЭтаФорма,);
	
КонецПроцедуры

// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
&НаКлиенте
Процедура Подключаемый_ОбновитьКомандыСостоянияОригинала()
	
	ОбновитьКомандыСостоянияОригинала()
   
КонецПроцедуры

&НаСервере
Процедура ОбновитьКомандыСостоянияОригинала()
	
	ДоступныеХозяйственныеОперацииИДокументы = Обработки.ЖурналДокументовАвансовыеОтчеты.ИнициализироватьХозяйственныеОперацииИДокументы(
		ОтборХозяйственныеОперации, ОтборТипыДокументов, КлючНазначенияИспользования);
		
	ИспользуемыеТипыДокументов = ДоступныеХозяйственныеОперацииИДокументы.ВыгрузитьКолонку("ТипДокумента");

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов(ИспользуемыеТипыДокументов);
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СписокДокументовКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
КонецПроцедуры
//Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокДокументовВалюта.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокДокументов.Мультивалютный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Мультивалютный>';
																|en = '<Multicurrency>'"));
	
	//++ НЕ УТ
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокДокументовВалюта.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокДокументов.Валюта");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Мультивалютный>';
																|en = '<Multicurrency>'"));
	//-- НЕ УТ
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокДокументов.Дата", Элементы.СписокДокументовДата.Имя);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция КлючНазначенияФормыПоУмолчанию()
	
	Возврат "АвансовыеОтчеты";
	
КонецФункции

&НаСервере
Процедура НастроитьФормуПоВыбраннымОперациямИДокументам(ТЗХозОперацииИТипыДокументов)
	
	ДанныеРабочегоМеста = ОбщегоНазначенияУТ.ДанныеРабочегоМеста(ТЗХозОперацииИТипыДокументов,
		КлючНазначенияФормыПоУмолчанию(), НСтр("ru = 'Авансовые отчеты';
												|en = 'Expense reports'"));
	
	Заголовок = ДанныеРабочегоМеста.ЗаголовокРабочегоМеста;
	
	УстановитьОтборыДинамическихСписков();
	УстановитьВидимостьДоступность();
	
	ОбщегоНазначенияУТ.СформироватьНадписьОтбор(
		Элементы.ИнформационнаяНадписьОтбор.Заголовок, ХозяйственныеОперацииИДокументы, ОтборТипыДокументов, ОтборХозяйственныеОперации);
	НастроитьКнопкиУправленияДокументами();
	
КонецПроцедуры

&НаСервере
Процедура ОтборОперацияТипОбработкаВыбораСервер(АдресХозяйственныхОперацийИДокументов)
	
	ТЗХозОперацииИТипыДокументов = ПолучитьИзВременногоХранилища(АдресХозяйственныхОперацийИДокументов);
	ХозяйственныеОперацииИДокументы.Загрузить(ТЗХозОперацииИТипыДокументов);
	ОбщегоНазначенияУТ.ЗаполнитьОтборыПоТаблицеХозОперацийИТиповДокументов(ТЗХозОперацииИТипыДокументов, ОтборХозяйственныеОперации, ОтборТипыДокументов);
	НастроитьФормуПоВыбраннымОперациямИДокументам(ТЗХозОперацииИТипыДокументов);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Элементы.Организация.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.СписокДокументовПодразделение.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения");
	Элементы.СписокДокументовСтатус.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыАвансовыхОтчетов");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыДинамическихСписков()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДокументов,
		"ТипСсылки",
		ОтборТипыДокументов,
		ВидСравненияКомпоновкиДанных.ВСписке,,
		Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДокументов,
		"ХозяйственнаяОперация",
		ОтборХозяйственныеОперации,
		ВидСравненияКомпоновкиДанных.ВСписке,,
		Истина);
	
	УстановитьОтборПоОрганизации();
	УстановитьОтборПоПодотчетномуЛицу();
	УстановитьОтборПоПериоду();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоОрганизации()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДокументов,
		"Организация",
		Организация,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Организация));
		
	ОбновитьГиперссылкуКОформлению();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПодотчетномуЛицу()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДокументов,
																			"ПодотчетноеЛицо",
																			ПодотчетноеЛицо,
																			ВидСравненияКомпоновкиДанных.Равно,
																			,
																			ЗначениеЗаполнено(ПодотчетноеЛицо));
	
	ОбновитьГиперссылкуКОформлению();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПериоду()
	
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("НачалоПериода",
		Период.ДатаНачала);
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("КонецПериода", 
		Период.ДатаОкончания);
	
КонецПроцедуры

&НаСервере
Процедура ТолькоПодготовленныеПриИзмененииСервер()

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДокументов,
		"Статус",
		Перечисления.СтатусыАвансовогоОтчета.Подготовлен,
		ВидСравненияКомпоновкиДанных.Равно,,
		ТолькоПодготовленные = 1);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьВоВременноеХранилищеХозяйственныеОперацииИДокументы()
	Возврат ПоместитьВоВременноеХранилище(ХозяйственныеОперацииИДокументы.Выгрузить(), УникальныйИдентификатор);
КонецФункции

&НаСервере
Процедура ПриОповещенииОЗаписиОформляемогоДокумента()
	
	Элементы.СписокДокументов.Обновить();
	ОбновитьГиперссылкуКОформлению();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьГиперссылкуКОформлению()
	
	ПараметрыФормирования = Новый Структура;
	ПараметрыФормирования.Вставить("ПодотчетноеЛицо", ПодотчетноеЛицо);
	ПараметрыФормирования.Вставить("Организация", Организация);
	ПараметрыФормирования.Вставить("ЭтоРасчетГиперссылки", Истина);
	ПараметрыФормирования.Вставить("КлючНазначенияИспользования", КлючНазначенияФормыПоУмолчанию());
	
	КОформлению = ОбщегоНазначенияУТ.СформироватьГиперссылкуКОформлению(ХозяйственныеОперацииИДокументы.Выгрузить(), ПараметрыФормирования);
	Элементы.КОформлению.Видимость = ЗначениеЗаполнено(КОформлению);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьКнопкиУправленияДокументами()
	
	СтруктураПараметров = ОбщегоНазначенияУТ.СтруктураПараметровНастройкиКнопокУправленияДокументами();
	СтруктураПараметров.Форма                                               = ЭтаФорма;
	СтруктураПараметров.ИмяКнопкиСкопировать                                = "СписокСкопировать";
	СтруктураПараметров.ИмяКнопкиСкопироватьКонтекстноеМеню                 = "СписокКонтекстноеМенюСкопировать";
	СтруктураПараметров.ИмяКнопкиИзменить                                   = "СписокИзменить";
	СтруктураПараметров.ИмяКнопкиИзменитьКонтекстноеМеню                    = "СписокКонтекстноеМенюИзменить";
	СтруктураПараметров.ИмяКнопкиПровести                                   = "СписокПровести";
	СтруктураПараметров.ИмяКнопкиПровестиКонтекстноеМеню                    = "СписокКонтекстноеМенюПровести";
	СтруктураПараметров.ИмяКнопкиОтменаПроведения                           = "СписокОтменаПроведения";
	СтруктураПараметров.ИмяКнопкиОтменаПроведенияКонтекстноеМеню            = "СписокКонтекстноеМенюОтменаПроведения";
	СтруктураПараметров.ИмяКнопкиУстановитьПометкуУдаления                  = "СписокУстановитьПометкуУдаления";
	СтруктураПараметров.ИмяКнопкиУстановитьПометкуУдаленияКонтекстноеМеню   = "СписокКонтекстноеМенюУстановитьПометкуУдаления";
	
	ОбщегоНазначенияУТ.НастроитьКнопкиУправленияДокументами(СтруктураПараметров);

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	ИменаСохраняемыхРеквизитов = "
		|ОтборХозяйственныеОперации,
		|ОтборТипыДокументов,
		|ПодотчетноеЛицо,
		|Организация,
		|Период";
	
	Настройки = Новый Структура(ИменаСохраняемыхРеквизитов);
	ЗаполнитьЗначенияСвойств(Настройки, ЭтаФорма);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"Обработка.ЖурналДокументовАвансовыеОтчеты.Форма.ФормаСписка", КлючНазначенияИспользования, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки(Параметры)
	
	Если Параметры.Свойство("СтруктураБыстрогоОтбора") Тогда
		СтруктураБыстрогоОтбора = Параметры.СтруктураБыстрогоОтбора;
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("ПодотчетноеЛицо", ПодотчетноеЛицо);
		СтруктураБыстрогоОтбора.Свойство("Период", Период);
	Иначе
		Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"Обработка.ЖурналДокументовАвансовыеОтчеты.Форма.ФормаСписка", КлючНазначенияИспользования);
		Если ТипЗнч(Настройки) = Тип("Структура") Тогда
			ЗаполнитьЗначенияСвойств(ЭтаФорма, Настройки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти