#Область ОписаниеПеременных

&НаКлиенте
Перем ОтветПередЗаписью;

#КонецОбласти

#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда     
		Возврат;
	КонецЕсли;

	ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();

	#Если Не ВебКлиент Тогда
	Объект.ИмяКомпьютера = ИмяКомпьютера();
	#КонецЕсли
	
	Элементы.Оборудование.Доступность = ЗначениеЗаполнено(Объект.Ссылка); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПустаяСтрока(Объект.Код) Тогда
		Объект.Код = МенеджерОборудованияКлиентСервер.ИдентификаторКлиентаДляРабочегоМеста();
	КонецЕсли;
	
	МенеджерОборудованияКлиентСервер.ЗаполнитьНаименованиеРабочегоМеста(Объект, ТекущийПользователь);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Место = ТекущийОбъект.Ссылка;
	
	СписокУстройств = МенеджерОборудованияВызовСервера.ОборудованиеПоПараметрам( , , Место);
	Для Каждого Элемент Из СписокУстройств Цикл
		Если Элемент.РабочееМесто = Место Тогда
			ЛокальноеОборудование.Добавить(Элемент.Ссылка,Элемент.Наименование, Ложь, ПолучитьКартинку(Элемент.ТипОборудования, 16));
		КонецЕсли;
	КонецЦикла
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ПроверкаУникальностиПоИдентификаторуКлиента(Объект.Ссылка, Объект.Код) Тогда
		Отказ = Истина;
		Текст = НСтр("ru = 'Ошибка сохранение рабочего места.
					|Рабочее место с таким идентификатором клиента уже существует.';
					|en = 'An error occurred when saving the workplace.
					|The workplace with such client ID already exists.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(Текст);
		Возврат;
	КонецЕсли;
	
	Если Не ПроверкаУникальностиПоНаименованию(Объект.Ссылка, Объект.Наименование)Тогда
		Если ОтветПередЗаписью <> Истина Тогда
			Отказ = Истина;
			Текст = НСтр("ru = 'Указано неуникальное наименование рабочего места.
						|Возможно в дальнейшем это затруднит идентификацию и выбор рабочего места.
						|Рекомендуется указывать уникальное наименование рабочих мест.
						|Продолжить сохранение с указанным наименованием?';
						|en = 'The workplace name is not unique.
						|It might cause identification issues.
						|Specify a unique name of the workplace.
						|Do you want to continue with the specified name anyway?'");
			Оповещение = Новый ОписаниеОповещения("ПередЗаписьюЗавершение", ЭтотОбъект);
			ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОтветПередЗаписью = Истина;
		Записать();
	КонецЕсли;  
	
КонецПроцедуры 
   
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если Объект.Код = МенеджерОборудованияКлиентСервер.ИдентификаторКлиентаДляРабочегоМеста() Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	МенеджерОборудованияКлиентСервер.ЗаполнитьНаименованиеРабочегоМеста(Объект, ТекущийПользователь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПроверкаУникальностиПоНаименованию(Ссылка, Наименование)
	
	Результат = Истина;
	
	Если Не ПустаяСтрока(Наименование) Тогда
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|    1
		|ИЗ
		|    Справочник.РабочиеМеста КАК РабочиеМеста
		|ГДЕ
		|    РабочиеМеста.Наименование = &Наименование
		|    И РабочиеМеста.Ссылка <> &Ссылка
		|");
		Запрос.УстановитьПараметр("Наименование", Наименование);
		Запрос.УстановитьПараметр("Ссылка"      , Ссылка);
		Результат = Запрос.Выполнить().Пустой();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПроверкаУникальностиПоИдентификаторуКлиента(Ссылка, ИдентификаторКлиента)
	
	Результат = Истина;
	
	Если Не ПустаяСтрока(ИдентификаторКлиента) Тогда
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|    1
		|ИЗ
		|    Справочник.РабочиеМеста КАК РабочиеМеста
		|ГДЕ
		|    РабочиеМеста.Код = &Код
		|    И РабочиеМеста.Ссылка <> &Ссылка
		|");
		Запрос.УстановитьПараметр("Код"    , ИдентификаторКлиента);
		Запрос.УстановитьПараметр("Ссылка" , Ссылка);
		Результат = Запрос.Выполнить().Пустой();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьКартинку(ТипОборудования, Размер)

	Попытка // Может прийти пустая ссылка или неопределено, может не быть картинки.
		МетаОбъект  = ТипОборудования.Метаданные();
		Индекс      = Перечисления.ТипыПодключаемогоОборудования.Индекс(ТипОборудования);
		ОбъектМетаданных = МетаОбъект.ЗначенияПеречисления[Индекс]; //ОбъектМетаданных - 
		ИмяКартинки = ОбъектМетаданных.Имя;
		ИмяКартинки = "ПодключаемоеОборудование" + ИмяКартинки + Размер;
		Картинка = БиблиотекаКартинок[ИмяКартинки];
	Исключение
		Картинка = Неопределено;
	КонецПопытки;

	Возврат Картинка;

КонецФункции

#КонецОбласти