
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Владелец") И ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
		
		ТипБД=Параметры.Отбор.Владелец;
		
		Если ТипБД.ВерсияПлатформы=Перечисления.ПлатформыВнешнихИнформационныхБаз.ADO Тогда
			
			ОбщегоНазначенияУХ.СообщитьОбОшибке(Нстр("ru = 'Для выбранного типа информационной базы доступны только таблицы ADO'"), Отказ,, СтатусСообщения.Информация);
			Возврат;
			
		КонецЕсли;
		
		ОбновитьОтборПоВладельцу();
		
		Элементы.ТипБД.Доступность=Ложь;
		
	Иначе
		
				
		Элементы.ТипБД.Доступность=Истина;
		ТипБД=Справочники.ТипыБазДанных.ТекущаяИБ;
		ОбновитьОтборПоВладельцу();
		
		Если Параметры.Свойство("Контролируемые") Тогда
			
			Элементы.ТипБД.Доступность=Ложь;
			ОбщегоНазначенияКлиентСерверУХ.УстановитьЭлементОтбора(Список.Отбор,"Контролируемый",Истина,ВидСравненияКомпоновкиДанных.Равно,,Истина);
			Элементы.ГруппаСтраницы.ОтображениеСтраниц=ОтображениеСтраницФормы.Нет;
			
		КонецЕсли;
	
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтборПоВладельцу()
	
	ОбщегоНазначенияКлиентСерверУХ.УстановитьЭлементОтбора(Список.Отбор,"Владелец",ТипБД,ВидСравненияКомпоновкиДанных.Равно,,Истина);
	
	ВозможенОбменНСИ=НЕ (ТипБД=Справочники.ТипыБазДанных.ТекущаяИБ ИЛИ ТипБД.ВерсияПлатформы=Перечисления.ПлатформыВнешнихИнформационныхБаз.Предприятие77);
	
	Элементы.СписокИмпортироватьДанные.Видимость=ВозможенОбменНСИ;
	
	Если ТипБД=Справочники.ТипыБазДанных.ТекущаяИБ Тогда
		
		Элементы.СписокЗагрузитьИЗВИБ.Заголовок=Нстр("ru = 'Обновить по данным текущей ИБ'");
		
	Иначе
		
		Элементы.СписокЗагрузитьИЗВИБ.Заголовок=Нстр("ru = 'Обновить по данным внешней ИБ'");
		
	КонецЕсли;
	
	Если ТипБД=Справочники.ТипыБазДанных.ТекущаяИБ Тогда
		
		Заголовок=Нстр("ru = 'Справочники текущей информационной базы'");
		Элементы.Соответствие.Видимость=Ложь;
		Элементы.СинхронизацияПоGUID.Видимость=Ложь;
		Элементы.Ссылка.Заголовок=Нстр("ru = 'Справочник текущей ИБ'");
		
		Элементы.СписокОткрытьСправочникБД.Видимость=Истина;
		
		Элементы.ЦентрализованныйКлассификатор.Видимость=Истина;
		Элементы.Контролируемый.Видимость=Истина;
		Элементы.Согласуется.Видимость=Истина;

		Элементы.ГруппаСтраницы.ОтображениеСтраниц=ОтображениеСтраницФормы.ЗакладкиСверху;
		
	Иначе
		
		Заголовок=Нстр("ru = 'Справочники внешней информационной базы'");
		Элементы.Соответствие.Видимость=Истина;
		Элементы.СинхронизацияПоGUID.Видимость=Истина;
		Элементы.Ссылка.Заголовок=Нстр("ru = 'Справочник внешней ИБ'");
		Элементы.ЦентрализованныйКлассификатор.Видимость=Ложь;
		Элементы.Контролируемый.Видимость=Ложь;
		Элементы.Согласуется.Видимость=Ложь;
		
		Элементы.СоздаватьПриНеудачномПоискеПриИмпорте.Заголовок=Нстр("ru = 'Создавать при неудачном поиске при экспорте'");
		Элементы.ОбновлятьРеквизитыПриИмпорте.Заголовок			=Нстр("ru = 'Обновлять реквизиты при экспорте'");
		
		Элементы.СписокОткрытьСправочникБД.Видимость=Ложь;
		
		Элементы.ГруппаСтраницы.ОтображениеСтраниц=ОтображениеСтраницФормы.Нет;
		
	КонецЕсли;
			
КонецПроцедуры // ОбновитьОтборПоВладельцу() 

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокСправочников(ТипБД)
	
	ОбщегоНазначенияУХ.ЗаполнитьСписокСправочниковБД(ТипБД);
		
КонецПроцедуры // ЗаполнитьСписокСправочников()

// Отключает пользовательские настройки списка, если они пересекаются с фиксированными.
&НаКлиенте
Процедура ОтключитьПересекающиесяПользовательскиеНастройки()
	// Инициализация.
	ПолеКонтролируемый = Новый ПолеКомпоновкиДанных("Контролируемый");
	// Поиск фиксированных настроек.
	ФиксированныйОтбор = Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы;	
	ЕстьОтборКонтролируемыйСправочник = Ложь;
	Для Каждого ТекФиксированныйОтбор Из ФиксированныйОтбор Цикл
		Если ТекФиксированныйОтбор.ЛевоеЗначение = ПолеКонтролируемый Тогда
			ЕстьОтборКонтролируемыйСправочник = Истина;
		Иначе
			Продолжить;					// Другое поле отбора. Выполняем поиск далее.
		КонецЕсли;
	КонецЦикла;
	// Сброс пользовательских настроек.
	Если ЕстьОтборКонтролируемыйСправочник Тогда
		ИспользуемыеПользовательскиеНастройки = Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
		Для Каждого ТекИспользуемыеПользовательскиеНастройки Из ИспользуемыеПользовательскиеНастройки Цикл
			Если ТипЗнч(ТекИспользуемыеПользовательскиеНастройки) = Тип("ОтборКомпоновкиДанных") Тогда
				ПользовательскийОтбор = ТекИспользуемыеПользовательскиеНастройки.Элементы;
				Для Каждого ТекПользовательскийОтбор Из ПользовательскийОтбор Цикл
					Если ТекПользовательскийОтбор.ЛевоеЗначение = ПолеКонтролируемый Тогда
						ТекПользовательскийОтбор.Использование = Ложь;
					Иначе
						Продолжить;		// Другое поле отбора. Выполняем поиск далее.
					КонецЕсли;
				КонецЦикла;
			Иначе
				Продолжить;				// Не отбор. Выполняем поиск далее.
			КонецЕсли;
		КонецЦикла;
	Иначе
		// Настройки не пересекаются, ничего не делаем.
	КонецЕсли;
КонецПроцедуры

/////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;
	
	Если Поле.Имя="Соответствие" Тогда
		
		СтандартнаяОбработка=Ложь;
		
		ТекСоответствие=Элементы.Список.ТекущиеДанные.Соответствие;
		
		Если НЕ ЗначениеЗаполнено(ТекСоответствие) Тогда
			
			СтруктураСоответствие=Новый Структура;
			СтруктураСоответствие.Вставить("ОписаниеОбъектаВИБ",Элементы.Список.ТекущиеДанные.Ссылка);
			СтруктураСоответствие.Вставить("Владелец",ТипБД);
			СтруктураСоответствие.Вставить("ТипОбъектаВИБ","Справочник");
			
			ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", СтруктураСоответствие);
			Оповещение = Новый ОписаниеОповещения("Подключаемый_ОбновитьСписок", ЭтотОбъект);
			ОткрытьФорму("Справочник.СоответствиеВнешнимИБ.ФормаОбъекта", 
						ПараметрыФормы, ЭтаФорма,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		Иначе

			ОткрытьФорму("Справочник.СоответствиеВнешнимИБ.ФормаОбъекта",Новый Структура("Ключ",ТекСоответствие));
			
		КонецЕсли;
		
	Иначе
		
		ОткрытьФорму("Справочник.СправочникиБД.ФормаОбъекта",Новый Структура("Ключ",Элементы.Список.ТекущиеДанные.Ссылка));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьСписок(Результат, ДополнительныеПараметры) Экспорт
    
    Элементы.Список.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИЗВИБ(Команда)
	
	Если НЕ ЗначениеЗаполнено(ТипБД) Тогда
		
		ПоказатьПредупреждение(, Нстр("ru = 'Не указан тип внешней информационной базы.'"));
		Возврат;
		
	Иначе
		
		ЗаполнитьСписокСправочников(ТипБД);
		Элементы.Список.Обновить();
		
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ТипБДПриИзменении(Элемент)
	
	ОбновитьОтборПоВладельцу();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортироватьДанные(Команда)
	
	Если Элементы.Список.ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.Список.ТекущиеДанные.СинхронизацияПоGUID Тогда
		
		ПоказатьПредупреждение(, Нстр("ru = 'Настройка соответствия выполняется по внутренним идентификаторам.
		|Выгрузка и загрузка элементов НСИ невозможна.'"));
		
		Возврат;
		
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ОбменНСИ.Форма.Форма",Новый Структура("НастройкаСоответствия,ИмпортДанных,ВыгрузкаДанных",Элементы.Список.ТекущиеДанные.Соответствие,Истина,Истина),,Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьДанные(Команда)
	
	Если Элементы.Список.ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ОбменНСИ.Форма.Форма",Новый Структура("НастройкаСоответствия,ВыгрузкаДанных",Элементы.Список.ТекущиеДанные.Соответствие,Истина));
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьФлажки(ИмяРеквизита,ЗначениеФлажка)
	
	СправочникиБД=Справочники.СправочникиБД.Выбрать();
	
	Пока СправочникиБД.Следующий() Цикл
		
		СправочникОбъект=СправочникиБД.ПолучитьОбъект();
		СправочникОбъект[ИмяРеквизита]=ЗначениеФлажка;
		
		Попытка
			СправочникОбъект.Записать();
		Исключение
			
		КонецПопытки;
		
	КонецЦикла;
				
КонецПроцедуры // ОбновитьФлажки()

&НаСервереБезКонтекста
Функция ПолучитьНаименованиеСправочника(Ссылка)
	
	 Возврат Ссылка.Наименование;
	
КонецФункции // ПолучитьНаименованиеСправочника() 

&НаКлиенте
Процедура УстановитьФлажки(Команда)

	ОбновитьФлажки(Элементы.Список.ТекущийЭлемент.Имя,Истина);
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	ОбновитьФлажки(Элементы.Список.ТекущийЭлемент.Имя,Ложь);
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииПоля(Элемент)
	
	Если Элемент.ТекущийЭлемент.Имя="СоздаватьПриНеудачномПоискеПриИмпорте" ИЛИ Элемент.ТекущийЭлемент.Имя="ОбновлятьРеквизитыПриИмпорте" Тогда
		
		Элементы.СписокУстановитьФлажки.Доступность=Истина;
		Элементы.СписокСнятьФлажки.Доступность=Истина;
				
	Иначе
		
		Элементы.СписокУстановитьФлажки.Доступность=Ложь;
		Элементы.СписокСнятьФлажки.Доступность=Ложь;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОтключитьПересекающиесяПользовательскиеНастройки();	
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникБД(Команда)
	
	Если Элементы.Список.ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Справочник."+ПолучитьНаименованиеСправочника(Элементы.Список.ТекущиеДанные.Ссылка)+".ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеОтсутствующие(Команда)
	ОбщегоНазначенияУХ.ПометитьНаУдалениеОтсутствующие("Справочник.СправочникиБД");
	Элементы.Список.Обновить();
КонецПроцедуры
