
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ.
//

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СтруктураНастроек = Неопределено;
	
	Если Настройки["НастройкиЦвета"] <> Неопределено Тогда
		СтруктураНастроек = Настройки["НастройкиЦвета"].Получить();
	КонецЕсли;
	
	Если СтруктураНастроек = Неопределено Тогда
		
		Объект.Цвет_Корректно      = Новый Цвет(192, 220, 192);
		Объект.Цвет_Превышение     = Новый Цвет(255, 228, 225);
		Объект.Цвет_НеполныеДанные = Новый Цвет(255, 255, 255);
		
	Иначе
		
		Если СтруктураНастроек.Свойство("Цвет_Корректно") И (НЕ СтруктураНастроек.Цвет_Корректно=Новый Цвет(0,0,0)) Тогда
			Объект.Цвет_Корректно=СтруктураНастроек.Цвет_Корректно;
		Иначе
			Объект.Цвет_Корректно      = Новый Цвет(192, 220, 192);
		КонецЕсли;
		
		Если СтруктураНастроек.Свойство("Цвет_Превышение") И (НЕ СтруктураНастроек.Цвет_Превышение=Новый Цвет(0,0,0)) Тогда
			Объект.Цвет_Превышение=СтруктураНастроек.Цвет_Превышение;
		Иначе
			Объект.Цвет_Превышение     = Новый Цвет(255, 228, 225);
		КонецЕсли;
		
		Если СтруктураНастроек.Свойство("Цвет_НеполныеДанные") И (НЕ СтруктураНастроек.Цвет_НеполныеДанные=Новый Цвет(0,0,0)) Тогда
			Объект.Цвет_НеполныеДанные=СтруктураНастроек.Цвет_НеполныеДанные;
		Иначе
			Объект.Цвет_НеполныеДанные = Новый Цвет(255, 255, 255);
		КонецЕсли;
		
	КонецЕсли;
	
	ИзменитьНастройкиОтображения();
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СписокПояснение.Добавить("НастройкаСверки"
							, НСтр("ru = 'Выберите основные параметры для сверки внутригрупповых операций'"));
	СписокПояснение.Добавить("РезультатыСверки", НСтр("ru = 'Детальная информация по результатам сверки ВГО.'"));
	
	ЗаполнитьСписокМеню();
	ОбновитьСписокКонсолидационныхГрупп();

КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("Цвет_Корректно"     , Объект.Цвет_Корректно);
	СтруктураНастроек.Вставить("Цвет_Превышение"    , Объект.Цвет_Превышение);
	СтруктураНастроек.Вставить("Цвет_НеполныеДанные", Объект.Цвет_НеполныеДанные);
	Настройки.Вставить("НастройкиЦвета", Новый ХранилищеЗначения(СтруктураНастроек));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "НовыеПараметры" Тогда
		
		Объект.АбсолютноеПредставление = Параметр.АбсолютноеПредставление;
		Объект.Цвет_Корректно          = Параметр.Цвет_Корректно;
		Объект.Цвет_Превышение         = Параметр.Цвет_Превышение;
		Объект.Цвет_НеполныеДанные     = Параметр.Цвет_НеполныеДанные;
		ИзменитьНастройкиОтображения();
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// КОМАНДЫ ФОРМЫ.
//
&НаКлиенте
Процедура Сверить(Команда)
	
	Если Объект.Период.Пустая() Тогда
		
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = НСтр("ru = 'Поле ""Период"" должно быть заполнено'");
		СообщениеПользователю.ПутьКДанным = "Период";
		СообщениеПользователю.Сообщить();
		Возврат;
		
	КонецЕсли;
	
	Если Объект.Сценарий.Пустая() Тогда
		
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = НСтр("ru = 'Поле ""Сценарий"" должно быть заполнено'");
		СообщениеПользователю.ПутьКДанным = "Сценарий";
		СообщениеПользователю.Сообщить();
		Возврат;
		
	КонецЕсли;
	
	Если Объект.Валюта.Пустая() Тогда
		
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = НСтр("ru = 'Поле ""Валюта"" должно быть заполнено'");
		СообщениеПользователю.ПутьКДанным = "Валюта";
		СообщениеПользователю.Сообщить();
		Возврат;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.КонсолидационнаяГруппа) Тогда
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = НСтр("ru = 'Поле ""Консолидационная группа"" должно быть заполнено'");
		СообщениеПользователю.ПутьКДанным = "КонсолидационнаяГруппа";
		СообщениеПользователю.Сообщить();
		Возврат;
	КонецЕсли;
	
	ВыполнитьСверку();
	
	СделатьАктивнымЭлементСписка("РезультатыСверки");
	
КонецПроцедуры

&НаКлиенте
Процедура Отчет(Команда)
	
	ОткрытьФорму("Обработка.СверкаВГО.Форма.ФормаОтчета_Управляемая", Новый Структура("ТаблДок", СформироватьОтчет()));
	
КонецПроцедуры

&НаКлиенте
Процедура Настройки(Команда)
	
	ОткрытьФорму("Обработка.СверкаВГО.Форма.ФормаНастроек_Управляемая", Новый Структура("АбсолютноеПредставление, Цвет_Корректно, Цвет_Превышение, Цвет_НеполныеДанные"
																					, Объект.АбсолютноеПредставление
																					, Объект.Цвет_Корректно
																					, Объект.Цвет_Превышение
																					, Объект.Цвет_НеполныеДанные));
	
КонецПроцедуры

&НаКлиенте
Процедура СверкаПоАналитикам(Команда)
	
	Если Элементы.ТаблицаСверкиПоказателей.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	АдресРаскрытия = ПолучитьРаскрытиеПоАналитикам(Элементы.ТаблицаСверкиПоказателей.ТекущаяСтрока);
	Если АдресРаскрытия <> Неопределено Тогда
		
		ТД = Элементы.ТаблицаСверкиПоказателей.ДанныеСтроки(Элементы.ТаблицаСверкиПоказателей.ТекущаяСтрока);
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ОрганизацияБазис", ТД.ОрганизацияБазис);
		ПараметрыФормы.Вставить("ОрганизацияСравнение", ТД.ОрганизацияСравнение);
		ПараметрыФормы.Вставить("ПоказательБазис", ТД.ПоказательБазис);
		ПараметрыФормы.Вставить("ПоказательСравнение", ТД.Показатель.Сравнение);
		ПараметрыФормы.Вставить("АдресТаблицы", АдресРаскрытия);
		
		ОткрытьФорму("Обработка.СверкаВГО.Форма.ФормаРаскрытияПоАналитикам_Управляемая", ПараметрыФормы, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПоРезультатамСверки(Команда)
	
	Элементы.ТабличноеПолеСверкиВидовОтчетовСортировкаПоРезультатамСверки.Пометка = НЕ Элементы.ТабличноеПолеСверкиВидовОтчетовСортировкаПоРезультатамСверки.Пометка;
	ОтборПоПризнакуРасхождения_ВидыОтчетов = Элементы.ТабличноеПолеСверкиВидовОтчетовСортировкаПоРезультатамСверки.Пометка;
	
КонецПроцедуры

&НаКлиенте
Процедура Расшифровать(Команда)
	
	Перем ЭкземплярОтчета;
	Перем МассивПоказателей;
	Перем СтруктураОтбора;
	Если ПодготовитьВызовРасшифровки(ЭкземплярОтчета, МассивПоказателей, СтруктураОтбора) Тогда
		ФормаДокумента = ПолучитьФорму("Документ.НастраиваемыйОтчет.ФормаОбъекта", Новый Структура("Ключ, МассивПоказателей, СтруктураОтбора", ЭкземплярОтчета, МассивПоказателей, СтруктураОтбора));
		ФормаДокумента.Открыть();
		#Если ТолстыйКлиентОбычноеПриложение Тогда
			ФормаДокумента.ВыделитьОбластиПоказателей(МассивПоказателей);
			ФормаДокумента.ВывестиРаскрытиеПоАналитикам(СтруктураОтбора);
		#Иначе
			ФормаДокумента.ОткрытьФормуРаскрытияПоАналитике(МассивПоказателей[0], СтруктураОтбора);
		#КонецЕсли
	КонецЕсли;
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////

&НаСервере
Функция ПодготовитьВызовРасшифровки(ЭкземплярОтчета, Вн_МассивПоказателей, СтруктураРасшифровки)
	
	Если НЕ ЭтоАдресВременногоХранилища(АдресТаблицыСоответствияПоказателей) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТС = Элементы.ТаблицаСверкиПоказателей.ТекущаяСтрока;
	
	Если ТС = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТаблицаСоответствийПоказателей = ПолучитьИзВременногоХранилища(АдресТаблицыСоответствияПоказателей);
	
	ТД         = ТаблицаСверкиПоказателей.НайтиПоИдентификатору(ТС);
	ИмяКолонки = Элементы.ТаблицаСверкиПоказателей.ТекущийЭлемент.Имя;
	
	ПоказательБазис     = ТД.ПоказательБазис;
	ПоказательСравнение = ТД.ПоказательСравнение;
	
	ТекСтроки = ТаблицаСоответствийПоказателей.НайтиСтроки(НОвый Структура("ПоказательБазис, ПоказательСравнение", ПоказательБазис, ПоказательСравнение));
	
	Если ТекСтроки.Количество() = 0 Тогда
		ТекСтроки = ТаблицаСоответствийПоказателей.НайтиСтроки(НОвый Структура("ПоказательСравнение, ПоказательБазис", ПоказательБазис, ПоказательСравнение));
		Если ТекСтроки.Количество() = 0 Тогда
			Возврат Ложь;
		Иначе
			АналитикаБазис = ТекСтроки[0].АналитикаВГО_Базис;
			АналитикаСравнение = ТекСтроки[0].АналитикаВГО_Сравнение;
		КонецЕсли;
	Иначе
		АналитикаБазис = ТекСтроки[0].АналитикаВГО_Сравнение;
		АналитикаСравнение = ТекСтроки[0].АналитикаВГО_Базис;
	КонецЕсли;

	
	СтруктураРасшифровки = Новый Структура;
	
	МассивПоказателей = новый Массив;
	Если СтрНайти(ИмяКолонки, "Базис") <> 0 Тогда
		Если ЗначениеЗаполнено(ТД.ЭкземплярОтчетаБазис) Тогда
			ЭкземплярОтчета = ТД.ЭкземплярОтчетаБазис;
			МассивПоказателей.Добавить(СокрЛП(ТД.ПоказательБазис.Код));
			СтруктураРасшифровки.Вставить("Аналитика" + АналитикаСравнение, Новый Структура("ВидСравнения, Значение", ВидСравнения.Равно, ТД.ОрганизацияСравнение));
		КонецЕсли;
	ИначеЕсли СтрНайти(ИмяКолонки, "Сравнение") <> 0 Тогда
		Если ЗначениеЗаполнено(ТД.ЭкземплярОтчетаСравнение) Тогда
			ЭкземплярОтчета = ТД.ЭкземплярОтчетаСравнение;
			МассивПоказателей.Добавить(СокрЛП(ТД.ПоказательСравнение.Код));
			СтруктураРасшифровки.Вставить("Аналитика" + АналитикаБазис, Новый Структура("ВидСравнения, Значение", ВидСравнения.Равно, ТД.ОрганизацияБазис));
		КонецЕсли;
	КонецЕсли;
	
	Вн_МассивПоказателей = Новый ФиксированныйМассив(МассивПоказателей);
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ОбновитьСписокКонсолидационныхГрупп()
	
	КонсолидационнаяГруппа = Объект.КонсолидационнаяГруппа;
	Объект.КонсолидационнаяГруппа = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Сценарий", Объект.Сценарий);
	Запрос.УстановитьПараметр("ПериодСценария", Объект.Период);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтруктураГруппы.ОрганизационнаяЕдиницаРодитель
	|ИЗ
	|	Справочник.ВерсииРегламентовПодготовкиОтчетности.СтруктураГруппы КАК СтруктураГруппы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыПериодовСценариев КАК СтатусыПериодовСценариев
	|		ПО СтруктураГруппы.Ссылка = СтатусыПериодовСценариев.ВерсияРегламента
	|			И (СтатусыПериодовСценариев.Сценарии = &Сценарий)
	|			И (СтатусыПериодовСценариев.Периоды = &ПериодСценария)";
	
	Элементы.КонсолидационнаяГруппа.СписокВыбора.Очистить();
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Элементы.КонсолидационнаяГруппа.СписокВыбора.Добавить(Выборка.ОрганизационнаяЕдиницаРодитель);
		Если Выборка.ОрганизационнаяЕдиницаРодитель = КонсолидационнаяГруппа Тогда
			Объект.КонсолидационнаяГруппа = КонсолидационнаяГруппа;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(Объект.КонсолидационнаяГруппа) И Элементы.КонсолидационнаяГруппа.СписокВыбора.Количество() Тогда
		Объект.КонсолидационнаяГруппа = Элементы.КонсолидационнаяГруппа.СписокВыбора[0].Значение;
	КонецЕсли;
	
	ПриИзмененииКонсолидационнойГруппы();
		
КонецПроцедуры

&НаСервере
Процедура ВыполнитьСверку()
		
	ТабличноеПолеПериметровСервер=РеквизитФормыВЗначение("ТабличноеПолеПериметров");
	ТабличноеПолеПериметровСервер.Очистить();
	
	Для Каждого ТекОрганизация ИЗ СписокОрганизаций Цикл
		
		НоваяСтрока=ТабличноеПолеПериметровСервер.Добавить();
		НоваяСтрока.Организация=ТекОрганизация.Значение;
		
	КонецЦикла;
			
	СброситьПризнакРасхождения(ТабличноеПолеПериметровСервер);
	
	ТекОбработка = РеквизитФормыВЗначение("Объект");
	ТекОбработка.Инициализация(ТабличноеПолеПериметровСервер,СписокОрганизаций,АдресТаблицыСоответствияПоказателей, УникальныйИдентификатор);
	ЗначениеВРеквизитФормы(ТекОбработка, "Объект");
	Если ТабличноеПолеСверкиВидовОтчетов.Количество() > 0 Тогда
		Элементы.ТабличноеПолеСверкиВидовОтчетов.ТекущаяСтрока = ТабличноеПолеСверкиВидовОтчетов[0].ПолучитьИдентификатор();
		УстановитьОтборПоОрганизациям();
	КонецЕсли;
	
	Для Каждого Строка Из ТабличноеПолеПериметровСервер Цикл
		УстановитьРезультатСверки(Строка);
	КонецЦикла;
	
	УстановитьОтборНаТаблицуВидовОтчетов();
	ЗначениеВРеквизитФормы(ТабличноеПолеПериметровСервер, "ТабличноеПолеПериметров");
	
КонецПроцедуры

&НаСервере
Процедура СброситьПризнакРасхождения(Строки)
	
	Для Каждого Строка Из Строки Цикл
		Строка.ПризнакРасхождения = -1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРезультатСверки(Строка)
	
	
	Если Строка.ПризнакРасхождения = 3 Тогда
		
		Строка.ПредставлениеСверки = НСтр("ru = 'Неполные данные'");
		
	ИначеЕсли Строка.ПризнакРасхождения = 2 Тогда
		
		Строка.ПредставлениеСверки = НСтр("ru = 'Превышение'");
		
	Иначе
		
		Строка.ПредставлениеСверки = ?(Строка.ПризнакРасхождения = -1, НСтр("ru = 'Нет внутригрупповых операций'"), "ОК");
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ТабличноеПолеПериметров.Очистить();
	
	Если Объект.Период.Пустая() ИЛИ Объект.Сценарий.Пустая() Тогда
		Возврат;
	Иначе
		ОбновитьСписокКонсолидационныхГрупп();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СценарийПриИзменении(Элемент)
	
	ТабличноеПолеПериметров.Очистить();
	
	Если Объект.Период.Пустая() ИЛИ Объект.Сценарий.Пустая() Тогда
		Возврат;
	Иначе
		ОбновитьСписокКонсолидационныхГрупп();
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// РАБОТА С МЕНЮ
//
&НаКлиенте
Процедура ЗаполнитьСписокМеню()
	
	СписокМеню.Очистить();
	СписокМеню.Добавить("НастройкаСверки", НСтр("ru = '1. Настройка сверки'"), Истина);
	СписокМеню.Добавить("РезультатыСверки", НСтр("ru = '2. Результаты сверки'"), Ложь);
	СделатьАктивнымЭлементСписка("НастройкаСверки");
	
КонецПроцедуры

&НаКлиенте
Процедура СделатьАктивнымЭлементСписка(Идентификатор)
	
	СписокМеню.ЗаполнитьПометки(Ложь);
	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда 
		ТекЭлемент = СписокМеню.НайтиПоЗначению(Идентификатор);
		Элементы.СписокМеню.ТекущаяСтрока = ТекЭлемент.ПолучитьИдентификатор();
	Иначе
		ТекЭлемент = СписокМеню.НайтиПоИдентификатору(Идентификатор);
	КонецЕсли;
	ТекЭлемент.Пометка = Истина;
	Элементы.КоманднаяПанельМастер.ТекущаяСтраница = Элементы[ТекЭлемент.Значение];
	УстановитьТекстПодсказки(ТекЭлемент.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекстПодсказки(ИмяСтраницы)
	
	ТекстПояснение = СписокПояснение.НайтиПоЗначению(ИмяСтраницы).Представление;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// УПРАВЛЕНИЕ ВЫВОДОМ РЕЗУЛЬТАТОВ СВЕРКИ.
//

&НаСервере
Процедура УстановитьОтборНаТаблицуВидовОтчетов()
	
	ПостроительЗапросаОрганизация = Новый ПостроительЗапроса;
	ПостроительЗапросаОрганизация.ИсточникДанных = Новый ОписаниеИсточникаДанных(Объект.ТаблицаСверкиОрганизаций.Выгрузить());
	ПостроительЗапросаОрганизация.ЗаполнитьНастройки();
	ПостроительЗапросаОрганизация.Отбор.Добавить("ОрганизацияБазис");
	ПостроительЗапросаОрганизация.Отбор.Добавить("ОрганизацияСравнение");
	ПостроительЗапросаОрганизация.Отбор.Добавить("КорректныеДанные");
	ПостроительЗапросаОрганизация.Отбор.Добавить("Превышение");
	ПостроительЗапросаОрганизация.Отбор.Добавить("НЕполныеДанные");
	ПостроительЗапросаОрганизация.Отбор.Добавить("НомерСтроки");
		
	Вн_ТабличноеПолеПериметров = РеквизитФормыВЗначение("ТабличноеПолеПериметров");
		
	МассивОрганизаций=СписокОрганизаций.ВыгрузитьЗначения();
	
	Если МассивОрганизаций.Количество() > 0 Тогда
		
		ПостроительЗапросаОрганизация.Отбор.Сбросить();
		
		ОтборПоБазису = ПостроительЗапросаОрганизация.Отбор.ОрганизацияБазис;
		ОтборПоБазису.ВидСравнения = ВидСравнения.ВСписке;
		ОтборПоБазису.Значение = СписокОрганизаций;
		
		ОтборПоСравнению = ПостроительЗапросаОрганизация.Отбор.ОрганизацияСравнение;
		ОтборПоСравнению.ВидСравнения = ВидСравнения.ВСписке;
		ОтборПоСравнению.Значение     = СписокОрганизаций;
		
		НовыйОтбор = ПостроительЗапросаОрганизация.Отбор.КорректныеДанные;		
		
		Если КорректныеДанные Тогда
			НовыйОтбор.ВидСравнения  = ВидСравнения.Равно;
			НовыйОтбор.Значение      = Ложь;
			НовыйОтбор.Использование = Истина;
		Иначе
			НовыйОтбор.Использование = Ложь;
		КонецЕсли;
		
		НовыйОтбор = ПостроительЗапросаОрганизация.Отбор.Превышение;
		
		Если ПревышениеПорогаСущественности Тогда
			НовыйОтбор.ВидСравнения  = ВидСравнения.Равно;
			НовыйОтбор.Значение      = Ложь;
			НовыйОтбор.Использование = Истина;
		Иначе
			НовыйОтбор.Использование = Ложь;
		КонецЕсли;
		
		НовыйОтбор = ПостроительЗапросаОрганизация.Отбор.НеполныеДанные;
		
		Если НеполныеДанные Тогда
			НовыйОтбор.ВидСравнения  = ВидСравнения.Равно;
			НовыйОтбор.Значение      = Ложь;
			НовыйОтбор.Использование = Истина;
		Иначе
			НовыйОтбор.Использование = Ложь;
		КонецЕсли;
		
		СписокНомеровИсключений = Новый СписокЗначений;
		СписокНомеровИсключений.ЗагрузитьЗначения(ПостроительЗапросаОрганизация.Результат.Выгрузить().ВыгрузитьКолонку("НомерСтроки"));
		
		ПостроительЗапросаОрганизация.Отбор.Сбросить();
		
		ПостроительЗапросаОрганизация.Отбор.НомерСтроки.ВидСравнения = ВидСравнения.НеВСписке;
		ПостроительЗапросаОрганизация.Отбор.НомерСтроки.Значение = СписокНомеровИсключений;
		ПостроительЗапросаОрганизация.Отбор.НомерСтроки.ИСпользование = Истина;
		
		ОтборПоБазису.Использование    = Истина;
		ОтборПоСравнению.Использование = Ложь;
		
		ПостроительЗапросаОрганизация.Выполнить();
		Вн_ТабличноеПолеСверкиВидовОтчетов = ПостроительЗапросаОрганизация.Результат.Выгрузить();
		
		ОтборПоБазису.Использование    = Ложь;
		ОтборПоСравнению.Использование = Истина;
		
		ПостроительЗапросаОрганизация.Выполнить();
		ВремТаблица = ПостроительЗапросаОрганизация.Результат.Выгрузить();
		
		Для Каждого Строка Из ВремТаблица Цикл
			Если Вн_ТабличноеПолеСверкиВидовОтчетов.НайтиСтроки(Новый Структура("ОрганизацияБазис, ОрганизацияСравнение", Строка.ОрганизацияБазис, Строка.ОрганизацияСравнение)).Количество() = 0 Тогда
				ЗаполнитьЗначенияСвойств(Вн_ТабличноеПолеСверкиВидовОтчетов.Добавить(), Строка);
			КонецЕсли;
		КонецЦикла;
		
		ЗначениеВРеквизитФормы(Вн_ТабличноеПолеСверкиВидовОтчетов, "ТабличноеПолеСверкиВидовОтчетов");
		Если ТабличноеПолеСверкиВидовОтчетов.Количество() > 0 Тогда
			
			Элементы.ТабличноеПолеСверкиВидовОтчетов.ТекущаяСтрока = ТабличноеПолеСверкиВидовОтчетов[0].ПолучитьИдентификатор();
			
		КонецЕсли;
	КонецЕсли;
	
	УстановитьОтборПоОрганизациям();
	
	НеобходимоНаложениеОтбора = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоОрганизациям()
	ТекущаяСтрока = Элементы.ТабличноеПолеСверкиВидовОтчетов.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		ТаблицаСверкиПоказателей.Очистить();
		Возврат;
	КонецЕсли;
	
	ТД = ТабличноеПолеСверкиВидовОтчетов.НайтиПоИдентификатору(ТекущаяСтрока);
	
	Если ТД = Неопределено Тогда
		ТаблицаСверкиПоказателей.Очистить();
		Возврат;
	КонецЕсли;
	
	ПостроительЗапросаПоказатели = Новый ПостроительЗапроса;
	ПостроительЗапросаПоказатели.ИсточникДанных = Новый ОписаниеИсточникаДанных(Объект.ТаблицаСверки.Выгрузить());
	ПостроительЗапросаПоказатели.ЗаполнитьНастройки();
	ПостроительЗапросаПоказатели.Отбор.Добавить("ОрганизацияБазис");
	ПостроительЗапросаПоказатели.Отбор.Добавить("ОрганизацияСравнение");
	ПостроительЗапросаПоказатели.Отбор.Добавить("ПризнакРасхождения");

	ПостроительЗапросаПоказатели.Отбор.Сбросить();
	
	ОтборПоБазису               = ПостроительЗапросаПоказатели.Отбор.ОрганизацияБазис;
	ОтборПоБазису.Значение      = ТД.ОрганизацияБазис;
	ОтборПоБазису.Использование = Истина;
	
	
	ОтборПоСравнению               = ПостроительЗапросаПоказатели.Отбор.ОрганизацияСравнение;
	ОтборПоСравнению.Значение      = ТД.ОрганизацияСравнение;
	ОтборПоСравнению.Использование = Истина;
	
	СписокОтборов = Новый СписокЗначений;
	
	Если КорректныеДанные Тогда
		СписокОтборов.Добавить(0);
	КонецЕсли;
	
	Если ПревышениеПорогаСущественности Тогда
		СписокОтборов.Добавить(2);
	КонецЕсли;
	
	Если НеполныеДанные Тогда
		СписокОтборов.Добавить(3);
	КонецЕсли;
	
	Отбор = ПостроительЗапросаПоказатели.Отбор.ПризнакРасхождения;
	Отбор.ВидСравнения = ВидСравнения.ВСписке;
	Отбор.Значение     = СписокОтборов;
	Отбор.ИСпользование = Истина;
	
	ПостроительЗапросаПоказатели.Порядок.Очистить();
	
	Если ОтборПоПризнакуРасхождения_ВидыОтчетов Тогда
		ПостроительЗапросаПоказатели.Порядок.Добавить("ПризнакРасхождения", , , НаправлениеСортировки.Убыв);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураСортировкиПоказатели) Тогда
		Для Каждого КлючИЗначение Из СтруктураСортировкиПоказатели Цикл
			ПостроительЗапросаПоказатели.Порядок.Добавить(КлючИЗначение.Ключ, , , ?(КлючИЗначение.Значение = "УБЫВ", НаправлениеСортировки.Убыв, НаправлениеСортировки.Возр));
		КонецЦикла;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ПостроительЗапросаПоказатели.Результат.Выгрузить(), "ТаблицаСверкиПоказателей");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////



&НаСервере
Функция ПолучитьРаскрытиеПоАналитикам(ИдентификаторСтроки)
	
	Если ПустаяСтрока(АдресТаблицыСоответствияПоказателей) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТД = ТаблицаСверкиПоказателей.НайтиПоИдентификатору(ИдентификаторСтроки);
	ТекОбработка = РеквизитФормыВЗначение("Объект");
	ТЗ = Новый ТаблицаЗначений;
	ТекОбработка.ПолучитьРаскрытиеПоАналитикам(ТД, ТЗ, АдресТаблицыСоответствияПоказателей);
	
	Если ТЗ.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат ПоместитьВоВременноеХранилище(ТЗ, УникальныйИдентификатор);
	КонецЕсли;
	
КонецФункции


&НаКлиенте
Процедура КорректныеДанныеПриИзменении(Элемент)
	
	УстановитьОтборНаТаблицуВидовОтчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура НеполныеДанныеПриИзменении(Элемент)
	
	УстановитьОтборНаТаблицуВидовОтчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПревышениеПорогаСущественностиПриИзменении(Элемент)
	
	УстановитьОтборНаТаблицуВидовОтчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличноеПолеСверкиВидовОтчетовПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("УстановитьОтборПоОрганизациямНаКлиенте", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоОрганизациямНаКлиенте()
	УстановитьОтборПоОрганизациям();
КонецПроцедуры

&НаСервере
Процедура ИзменитьНастройкиОтображения()
	
	ПолеПризнакРасхождения_Периметр   = Новый ПолеКомпоновкиДанных("ТабличноеПолеПериметров.ПризнакРасхождения");
	ПолеПризнакРасхождения_ВидОтчета  = Новый ПолеКомпоновкиДанных("ТабличноеПолеСверкиВидовОтчетов.ПризнакРасхождения");
	ПолеПризнакРасхождения_Показатель = Новый ПолеКомпоновкиДанных("ТаблицаСверкиПоказателей.ПризнакРасхождения");
	
	ЭлементыНастройки = ЭтаФорма.УсловноеОформление.Элементы;
	Для Каждого Элемент Из ЭлементыНастройки Цикл
		Для Каждого ЭлементОтбора Из Элемент.Отбор.Элементы Цикл
			Если ЭлементОтбора.ЛевоеЗначение = ПолеПризнакРасхождения_Периметр
			 ИЛИ ЭлементОтбора.ЛевоеЗначение = ПолеПризнакРасхождения_ВидОтчета
			 ИЛИ ЭлементОтбора.ЛевоеЗначение = ПолеПризнакРасхождения_Показатель Тогда
				ПравоеЗначение = ЭлементОтбора.ПравоеЗначение;
				Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ?(ПравоеЗначение = 2, Объект.Цвет_Превышение, ?(ПравоеЗначение = 3, Объект.Цвет_НеполныеДанные, Объект.Цвет_Корректно)));
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если Объект.АбсолютноеПредставление Тогда
		Элементы.ПорогСущественности.Заголовок = НСтр("ru = 'Порог существенности'");
	Иначе
		Элементы.ПорогСущественности.Заголовок = НСтр("ru = 'Порог существенности(%)'");
	КонецЕсли;
	
	Элементы.ТаблицаСверкиПоказателейРасхождениеАбсолютное.Видимость           = Объект.АбсолютноеПредставление;
	Элементы.ТаблицаСверкиПоказателейРасхождениеОтносительное.Видимость        = НЕ Объект.АбсолютноеПредставление;
	Элементы.ТабличноеПолеСверкиВидовОтчетовРасхождениеАбсолютное.Видимость    = Объект.АбсолютноеПредставление;
	Элементы.ТабличноеПолеСверкиВидовОтчетовРасхождениеОтносительное.Видимость = НЕ Объект.АбсолютноеПредставление;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокМенюПриАктивизацииСтроки(Элемент)
	
	СделатьАктивнымЭлементСписка(Элементы.СписокМеню.ТекущаяСтрока);
	
КонецПроцедуры

&НаСервере
Функция СформироватьОтчет()
	
	Макет = Обработки.СверкаВГО.ПолучитьМакет("Макет");
	ТаблДок = Новый ТабличныйДокумент;
	
	ТаблДок.Вывести(Макет.ПолучитьОбласть("ЗаголовокОтчета"));
	ТаблДок.НачатьГруппуСтрок();
	
	ОбластьЗаголовка = Макет.ПолучитьОбласть("Заголовок");
	ОбластьЗаголовка.Параметры.Заполнить(Объект);
	ОбластьЗаголовка.Параметры.Заполнить(ЭтаФорма);
		
	ОбластьПропуск   = Макет.ПолучитьОбласть("Пропуск");
	
	ТаблДок.Вывести(ОбластьЗаголовка);
	ТаблДок.Вывести(ОбластьПропуск);
	
	Если ЗначениеЗаполнено(СписокПериметров) Тогда
		ТаблДок.Вывести(Макет.ПолучитьОбласть("ПериметрыЗаголовок"));
		
		ОбластьДанных = Макет.ПолучитьОбласть("ПериметрыДанные");
		
		Для Каждого Строка Из СписокПериметров Цикл
			ОбластьДанных.параметры.Периметр = Строка.Значение;
			ТаблДок.Вывести(ОбластьДанных);
		КонецЦикла;
	КонецЕсли;
	
	ТаблДок.Вывести(ОбластьПропуск);
	
	Если ЗначениеЗаполнено(СписокОрганизаций) Тогда
		ТаблДок.Вывести(Макет.ПолучитьОбласть("ОрганизацииОтборЗаголовок"));
		
		ОбластьДанных = Макет.ПолучитьОбласть("ОрганизацииОтборДанные");
		
		Для Каждого Строка Из СписокОрганизаций Цикл
			ОбластьДанных.параметры.Организация = Строка.Значение;
			ТаблДок.Вывести(ОбластьДанных);
		КонецЦикла;
		
	КонецЕсли;
	
	ТаблДок.ЗакончитьГруппуСтрок();
	
	ТаблДок.Вывести(ОбластьПропуск);
	
	ОбластьОрганизации = Макет.ПолучитьОбласть("ОрганизацииДанные");
	ОбластьПоказатели  = Макет.ПолучитьОбласть("ПоказателиДанные");
	
	Для Каждого Строка Из ТабличноеПолеСверкиВидовОтчетов Цикл
		
		ОбластьОрганизации.Параметры.Заполнить(Строка);
		ОбластьОрганизации.Параметры.Расхождение = ?(Объект.АбсолютноеПредставление, Формат(Строка.РасхождениеАбсолютное,"ЧЦ=15; ЧДЦ=2; ЧН=0"), Формат(Строка.РасхождениеОтносительное, "ЧЦ=5; ЧДЦ=0; ЧН=0") + "%");
		ТаблДок.Вывести(ОбластьОрганизации);
		ТаблДок.НачатьГруппуСтрок();
		
		Если КорректныеДанные Тогда
		
			НайденныеСтроки = Объект.ТаблицаСверки.НайтиСтроки(Новый Структура("ОрганизацияБазис, ОрганизацияСравнение, ПризнакРасхождения", Строка.ОрганизацияБазис, Строка.ОрганизацияСравнение, 3));
			ВывестиДанные(ТаблДок, НайденныеСтроки, ОбластьПоказатели, Объект.Цвет_НеполныеДанные);
			
		КонецЕсли;
		
		Если ПревышениеПорогаСущественности Тогда
		
			НайденныеСтроки = Объект.ТаблицаСверки.НайтиСтроки(Новый Структура("ОрганизацияБазис, ОрганизацияСравнение, ПризнакРасхождения", Строка.ОрганизацияБазис, Строка.ОрганизацияСравнение, 2));
			ВывестиДанные(ТаблДок, НайденныеСтроки, ОбластьПоказатели, Объект.Цвет_Превышение);
			
		КонецЕсли;
		
		Если НеполныеДанные Тогда
		
			НайденныеСтроки = Объект.ТаблицаСверки.НайтиСтроки(Новый Структура("ОрганизацияБазис, ОрганизацияСравнение, ПризнакРасхождения", Строка.ОрганизацияБазис, Строка.ОрганизацияСравнение, 0));
			ВывестиДанные(ТаблДок, НайденныеСтроки, ОбластьПоказатели, Объект.Цвет_Корректно);
		КонецЕсли;
		
		
		ТаблДок.ЗакончитьГруппуСтрок();
		
	КонецЦикла;
	
	Возврат ТаблДок;
	
КонецФункции

&НаСервере
Процедура ВывестиДанные(ТаблДок, НайденныеСтроки, ОбластьПоказатели, ЦветФона)
	
	ЧислоСтрок   = НайденныеСтроки.Количество();
	ПерваяСтрока = -1;
	Для Каждого СтрокаПок Из НайденныеСтроки Цикл
		ОбластьПоказатели.Параметры.Заполнить(СтрокаПок);
		ОбластьПоказатели.Параметры.Расхождение = ?(Объект.АбсолютноеПредставление, Формат(СтрокаПок.РасхождениеАбсолютное,"ЧЦ=15; ЧДЦ=2; ЧН=0"), Формат(СтрокаПок.РасхождениеОтносительное, "ЧЦ=5; ЧДЦ=0; ЧН=0") + "%");
		ОбластьВывода = ТаблДок.Вывести(ОбластьПоказатели);
		Если ПерваяСтрока = -1 Тогда
			ПерваяСтрока = ОбластьВывода.Верх;
		КонецЕсли;
	КонецЦикла;
	
	Если ПерваяСтрока <> -1 Тогда
		ТаблДок.Область(ПерваяСтрока, 1 , ПерваяСтрока + ЧислоСтрок * 2, 3).ЦветФона = ЦветФона;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработкаРасшифровки()
	
	Перем ЭО;
	
	ТаблицаСоответствийПоказателей = ПолучитьИзВременногоХранилища(АдресТаблицыСоответствияПоказателей);
	Если НЕ ЗначениеЗаполнено(ТаблицаСоответствийПоказателей) Тогда
		ОбщегоНазначенияУХ.СообщитьОбОшибке(НСтр("ru = 'Ошибка при расшифровке показателей. Попробуйте провести сверку еще раз'"));
		Возврат Неопределено;
	КонецЕсли;
	
	ТД         = ТаблицаСверкиПоказателей.НайтиПоИдентификатору(Элементы.ТаблицаСверкиПоказателей.ТекущаяСтрока);
	ИмяКолонки = Элементы.ТаблицаСверкиПоказателей.ТекущийЭлемент.Имя;
	
	ПоказательБазис     = ТД.ПоказательБазис;
	ПоказательСравнение = ТД.ПоказательСравнение;
	
	ТекСтроки = ТаблицаСоответствийПоказателей.НайтиСтроки(НОвый Структура("ПоказательБазис, ПоказательСравнение", ПоказательБазис, ПоказательСравнение));
	
	Если ТекСтроки.Количество() = 0 Тогда
		ТекСтроки = ТаблицаСоответствийПоказателей.НайтиСтроки(НОвый Структура("ПоказательСравнение, ПоказательБазис", ПоказательБазис, ПоказательСравнение));
		Если ТекСтроки.Количество() = 0 Тогда
			Возврат Неопределено;
		Иначе
			АналитикаБазис = ТекСтроки[0].АналитикаВГО_Базис;
			АналитикаСравнение = ТекСтроки[0].АналитикаВГО_Сравнение;
		КонецЕсли;
	Иначе
		АналитикаБазис = ТекСтроки[0].АналитикаВГО_Сравнение;
		АналитикаСравнение = ТекСтроки[0].АналитикаВГО_Базис;
	КонецЕсли;

	
	СтруктураРасшифровки = Новый Структура;
	
	МассивПоказателей = новый Массив;
	Если СтрНайти(ИмяКолонки, "Базис") <> 0 Тогда
		Если ЗначениеЗаполнено(ТД.ЭкземплярОтчетаБазис) Тогда
			ЭО = ТД.ЭкземплярОтчетаБазис;
			МассивПоказателей.Добавить(СокрЛП(ТД.ПоказательБазис.Код));
			СтруктураРасшифровки.Вставить("Аналитика" + АналитикаСравнение, Новый Структура("ВидСравнения, Значение", ВидСравнения.Равно, ТД.ОрганизацияСравнение));
		КонецЕсли;
	ИначеЕсли СтрНайти(ИмяКолонки, "Сравнение") <> 0 Тогда
		Если ЗначениеЗаполнено(ТД.ЭкземплярОтчетаСравнение) Тогда
			ЭО = ТД.ЭкземплярОтчетаСравнение;
			МассивПоказателей.Добавить(СокрЛП(ТД.ПоказательСравнение.Код));
			СтруктураРасшифровки.Вставить("Аналитика" + АналитикаБазис, Новый Структура("ВидСравнения, Значение", ВидСравнения.Равно, ТД.ОрганизацияБазис));
		КонецЕсли;
	КонецЕсли;
	
	Возврат Новый Структура("Ключ, МассивПоказателей, НастройкаРаскрытияПоАналитикам", ЭО, Новый ФиксированныйМассив(МассивПоказателей), Новый ФиксированнаяСтруктура(СтруктураРасшифровки));
	
КонецФункции

&НаКлиенте
Процедура КонсолидационнаяГруппаПриИзменении(Элемент)
	
	ПриИзмененииКонсолидационнойГруппы();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииКонсолидационнойГруппы()
	
	ОрганизацияСтар=Объект.ОрганизацияБазис;
	КонтрагентСтар=Объект.ОрганизацияСравнение;
	СписокОрганизаций.Очистить();
	
	Запрос=Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтруктураГруппы.ОрганизационнаяЕдиница
	|ИЗ
	|	Справочник.ВерсииРегламентовПодготовкиОтчетности.СтруктураГруппы КАК СтруктураГруппы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыПериодовСценариев КАК СтатусыПериодовСценариев
	|		ПО СтруктураГруппы.Ссылка = СтатусыПериодовСценариев.ВерсияРегламента
	|			И (СтатусыПериодовСценариев.Сценарии = &Сценарий)
	|			И (СтатусыПериодовСценариев.Периоды = &ПериодСценария)
	|ГДЕ
	|	СтруктураГруппы.ОрганизационнаяЕдиницаРодитель = &ОрганизационнаяЕдиницаРодитель
	|	И СтруктураГруппы.ОрганизационнаяЕдиница.ТипОрганизации = ЗНАЧЕНИЕ(Перечисление.ТипыОрганизационныхЕдиниц.Обычная)";
	
	Запрос.УстановитьПараметр("ОрганизационнаяЕдиницаРодитель", Объект.КонсолидационнаяГруппа);
	Запрос.УстановитьПараметр("Сценарий", Объект.Сценарий);
	Запрос.УстановитьПараметр("ПериодСценария", Объект.Период);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокОрганизаций.Добавить(Выборка.ОрганизационнаяЕдиница);		
	КонецЦикла;
	
	Если СписокОрганизаций.Количество() Тогда
		
		Если ЗначениеЗаполнено(ОрганизацияСтар) И (НЕ СписокОрганизаций.НайтиПоЗначению(ОрганизацияСтар)=Неопределено) Тогда
			
			Объект.ОрганизацияБазис=ОрганизацияСтар;
			
		Иначе
			
			Объект.ОрганизацияБазис="";
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(КонтрагентСтар) И (НЕ СписокОрганизаций.НайтиПоЗначению(КонтрагентСтар)=Неопределено) Тогда
			
			Объект.ОрганизацияСравнение=КонтрагентСтар;
			
		Иначе
			
			Объект.ОрганизацияСравнение="";
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ОрганизацияБазисНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;
	
	Если Не ЗначениеЗаполнено(Объект.КонсолидационнаяГруппа) Тогда
		Сообщить(НСтр("ru = 'Не выбрана консолидационная группа для сверки'"), СтатусСообщения.Внимание);
		Возврат;		
	КонецЕсли;
	
	СтруктураПараметров=Новый Структура;	
	СтруктураПараметров.Вставить("ОтборыВСписке",Новый Структура("Ссылка",СписокОрганизаций.ВыгрузитьЗначения()));		
	
	ОткрытьФорму("Справочник.Организации.ФормаВыбора",СтруктураПараметров,Элемент);	
	
КонецПроцедуры


