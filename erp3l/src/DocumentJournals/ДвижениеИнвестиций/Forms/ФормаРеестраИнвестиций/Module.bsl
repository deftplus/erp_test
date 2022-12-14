
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОтображатьКИК = Истина;
	ОтображатьМСФО = Истина;
	ДатаРеестра = ТекущаяДата();
	СценарийМСФО = Константы.СценарийМСФО.Получить();
	СценарийКИК = Константы.СценарийОтчетностиКИК.Получить();
	СценарийПлан = Справочники.Сценарии.План;
	УстановтьПараметрыСписка();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеВидимостью();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтображатьМСФОПриИзменении(Элемент)
	УправлениеВидимостью();
КонецПроцедуры

&НаКлиенте
Процедура ДатаРеестраПриИзменении(Элемент)
	УстановтьПараметрыСписка()
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРеестр

&НаКлиенте
Процедура РеестрВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущаяСтрока = Элемент.ДанныеСтроки(ВыбраннаяСтрока);
	ЭтоМСФО = Ложь;
	ЭтоКИК = Ложь;
	Если Элемент.ТекущийЭлемент.Имя = "СписокПрямаяДоля" ИЛИ Элемент.ТекущийЭлемент.Имя = "СписокЭффективнаяДоля" ИЛИ Элемент.ТекущийЭлемент.Имя = "СписокОтношениеКГруппе" Тогда
		ЭтоМСФО = Истина;
		Если ТекущаяСтрока.ПрямаяДоля = 0 И ТекущаяСтрока.ЭффективнаяДоля <> 0 Тогда
			СообщениеОбОтсутствииПрямыхДолей();
			Возврат;
		КонецЕсли;
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "СписокПрямаяДоляКИК" ИЛИ Элемент.ТекущийЭлемент.Имя = "СписокЭффективнаяДоляКИК" ИЛИ Элемент.ТекущийЭлемент.Имя = "СписокСтатусИностраннойКомпании" Тогда
		ЭтоКИК = Истина;
		Если ТекущаяСтрока.ПрямаяДоляКИК = 0 И ТекущаяСтрока.ЭффективнаяДоляКИК <> 0 Тогда
			СообщениеОбОтсутствииПрямыхДолей();
			Возврат;
		КонецЕсли;
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "СписокПрямаяДоляПлан" ИЛИ Элемент.ТекущийЭлемент.Имя = "СписокЭффективнаяДоляПлан" ИЛИ Элемент.ТекущийЭлемент.Имя = "СписокСтатусИностраннойКомпанииПлан" ИЛИ Элемент.ТекущийЭлемент.Имя = "СписокОтношениеКГруппеПлан" Тогда
		// это план
		Если ТекущаяСтрока.ПрямаяДоляПлан = 0 И ТекущаяСтрока.ЭффективнаяДоляПлан <> 0 Тогда
			СообщениеОбОтсутствииПрямыхДолей();
			Возврат;
		КонецЕсли;
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "СписокИнвестор" ИЛИ Элемент.ТекущийЭлемент.Имя = "СписокОбъектИнвестирования" Тогда
		// это всё
		ЭтоМСФО = Истина;
		ЭтоКИК = Истина;
		Если ТекущаяСтрока.ПрямаяДоляПлан = 0 И ТекущаяСтрока.ЭффективнаяДоляПлан <> 0 Тогда
			СообщениеОбОтсутствииПрямыхДолей();
			Возврат;
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;
	
	Документ = ПолучитьСсылкуНаОдинДокумент(ТекущаяСтрока.Инвестор, ТекущаяСтрока.ОбъектИнвестирования, ЭтоМСФО, ЭтоКИК);
	Если Документ = Неопределено Тогда
		Отбор = Новый Структура;
		Отбор.Вставить("Организация", ТекущаяСтрока.Инвестор);
		Отбор.Вставить("ОбъектИнвестирования", ТекущаяСтрока.ОбъектИнвестирования);
		ПараметрыЖурнала = Новый Структура;
		ПараметрыЖурнала.Вставить("Отбор", Отбор);
		ОткрытьФорму("ЖурналДокументов.ДвижениеИнвестиций.Форма.ФормаСписка", ПараметрыЖурнала);
	Иначе
		ПоказатьЗначение(, Документ);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сценарии(Команда)
	ВидимостьПараметров = НЕ ВидимостьПараметров;
	УправлениеВидимостью();
КонецПроцедуры

&НаКлиенте
Процедура ВыбытиеИнвестиций(Команда)
	Если Элементы.Реестр.ТекущиеДанные <> Неопределено Тогда
		ПараметрыДокумента = Новый Структура("Организация, ОбъектИнвестирования", Элементы.Реестр.ТекущиеДанные.Инвестор, Элементы.Реестр.ТекущиеДанные.ОбъектИнвестирования);
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ПараметрыДокумента);
		ОткрытьФорму("Документ.ВыбытиеИнвестиций.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоступлениеИнвестиций(Команда)
	Если Элементы.Реестр.ТекущиеДанные <> Неопределено Тогда
		ПараметрыДокумента = Новый Структура("Организация, ОбъектИнвестирования", Элементы.Реестр.ТекущиеДанные.Инвестор, Элементы.Реестр.ТекущиеДанные.ОбъектИнвестирования);
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ПараметрыДокумента);
		ОткрытьФорму("Документ.ПоступлениеИнвестиций.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СтруктураВладения(Команда)
	ПараметрыФормы = Новый Структура("ОформлениеИнвестор, ОформлениеОбъектИнвестирования, СформироватьПриОткрытии", Элементы.Реестр.ТекущиеДанные.Инвестор, Элементы.Реестр.ТекущиеДанные.ОбъектИнвестирования, Истина);
	ОткрытьФорму("Обработка.СтруктураВладения.Форма", ПараметрыФормы, ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УправлениеВидимостью()
	Элементы.СписокГруппаМСФО.Видимость = ОтображатьМСФО;
	Элементы.СписокГруппаКИК.Видимость = ОтображатьКИК;
	Элементы.СписокГруппаПлан.Видимость = ОтображатьПлан;
	Элементы.Сценарии.Пометка = ВидимостьПараметров;	
	Элементы.Группа2.Видимость = ВидимостьПараметров;
КонецПроцедуры

&НаСервере
Процедура УстановтьПараметрыСписка()
	Реестр.Параметры.УстановитьЗначениеПараметра("ДатаСреза", КонецДня(ДатаРеестра));
	Реестр.Параметры.УстановитьЗначениеПараметра("СценарийМСФО", Константы.СценарийМСФО.Получить());
	Реестр.Параметры.УстановитьЗначениеПараметра("СценарийКИК", Константы.СценарийОтчетностиКИК.Получить());
	Реестр.Параметры.УстановитьЗначениеПараметра("СценарийПлан", Справочники.Сценарии.План);
	Элементы.Реестр.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура СообщениеОбОтсутствииПрямыхДолей()
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Для данного инвестора и объекта инвестирования отсутствует прямая доля участия (нет документов инвестиций).
														|Для просмотра косвенных долей рекомендуется отчет ""Структура владения""");
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСсылкуНаОдинДокумент(Инвестор, ОбъектИнвестирования, ЭтоМСФО, ЭтоКИК)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДвижениеИнвестиций.Ссылка,
		|	1 КАК Порядок
		|ИЗ
		|	ЖурналДокументов.ДвижениеИнвестиций КАК ДвижениеИнвестиций
		|ГДЕ
		|	ДвижениеИнвестиций.Организация = &Инвестор
		|	И ДвижениеИнвестиций.ОбъектИнвестирования = &ОбъектИнвестирования
		|	И ДвижениеИнвестиций.Проведен
		|	И ВЫБОР
		|			КОГДА &ЭтоМСФО
		|					И НЕ &ЭтоКИК
		|				ТОГДА ДвижениеИнвестиций.МСФОУчет
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ДвижениеИнвестиций.Ссылка,
		|	2
		|ИЗ
		|	ЖурналДокументов.ДвижениеИнвестиций КАК ДвижениеИнвестиций
		|ГДЕ
		|	ДвижениеИнвестиций.Организация = &Инвестор
		|	И ДвижениеИнвестиций.ОбъектИнвестирования = &ОбъектИнвестирования
		|	И ДвижениеИнвестиций.Проведен
		|	И ВЫБОР
		|			КОГДА &ЭтоКИК
		|					И НЕ &ЭтоМСФО
		|				ТОГДА ДвижениеИнвестиций.НалоговыйУчет
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ДвижениеИнвестиций.Ссылка,
		|	3
		|ИЗ
		|	ЖурналДокументов.ДвижениеИнвестиций КАК ДвижениеИнвестиций
		|ГДЕ
		|	ДвижениеИнвестиций.Организация = &Инвестор
		|	И ДвижениеИнвестиций.ОбъектИнвестирования = &ОбъектИнвестирования
		|	И ДвижениеИнвестиций.Проведен
		|	И ВЫБОР
		|			КОГДА &ЭтоКИК
		|					И &ЭтоМСФО
		|				ТОГДА ДвижениеИнвестиций.МСФОУчет
		|						И ДвижениеИнвестиций.НалоговыйУчет
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ДвижениеИнвестиций.Ссылка,
		|	4
		|ИЗ
		|	ЖурналДокументов.ДвижениеИнвестиций КАК ДвижениеИнвестиций
		|ГДЕ
		|	ДвижениеИнвестиций.Организация = &Инвестор
		|	И ДвижениеИнвестиций.ОбъектИнвестирования = &ОбъектИнвестирования
		|	И ДвижениеИнвестиций.Проведен
		|	И ВЫБОР
		|			КОГДА НЕ &ЭтоКИК
		|					И НЕ &ЭтоМСФО
		|				ТОГДА НЕ ДвижениеИнвестиций.МСФОУчет
		|						И НЕ ДвижениеИнвестиций.НалоговыйУчет
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок";
	
	Запрос.УстановитьПараметр("Инвестор", Инвестор);
	Запрос.УстановитьПараметр("ОбъектИнвестирования", ОбъектИнвестирования);
	Запрос.УстановитьПараметр("ЭтоМСФО", ЭтоМСФО);
	Запрос.УстановитьПараметр("ЭтоКИК", ЭтоКИК);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() = 1 Тогда
		ВыборкаДетальныеЗаписи.Следующий();
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
