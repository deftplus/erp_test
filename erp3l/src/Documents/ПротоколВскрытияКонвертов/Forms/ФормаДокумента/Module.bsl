
#Область ОбработкаОсновныхСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СтараяЗакупочнаяПроцедура = Объект.ЗакупочнаяПроцедура;
	УстановитьРеквизитыФормыПоЗакупке();
	ДополнитьТаблицуПредложенийПоставщиковНаСервере();
	НарисоватьПанельСогласованияИОпределитьСостояниеОбъекта();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьОформлениеФормы();
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ДополнитьТаблицуПредложенийПоставщиковНаСервере();
КонецПроцедуры


#КонецОбласти


#Область ОбработкаСобытийЭлементовФормы


&НаКлиенте
Процедура КомандаРедактироватьУИД(Команда)
	ЦентрализованныеЗакупкиКлиентУХ.РедактироватьУИДОбъекта(Объект, НСтр("ru = 'Введите УИД объекта'"));
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьСтандартныйУИД(Команда)
	ЦентрализованныеЗакупкиКлиентУХ.УстановитьСтандартныйУИД(Объект);
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДелегатОбновитьСтроку = Новый ОписаниеОповещения("УстановитьКомментарий", ЭтаФорма);
	ПоказатьВводСтроки(ДелегатОбновитьСтроку, Объект.Комментарий, "Комментарий",, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОтмененПриИзменении(Элемент)
	УстановитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ЗакупочнаяПроцедураПриИзменении(Элемент)
	Если СтараяЗакупочнаяПроцедура <> Объект.ЗакупочнаяПроцедура Тогда
		ЗакупкаПриИзмененииНаСервере();
		УстановитьОформлениеФормы();
		СтараяЗакупочнаяПроцедура = Объект.ЗакупочнаяПроцедура;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредложенияПоставщиков(Команда)
	ДополнитьТаблицуПредложенийПоставщиковНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПредложенияПоставщиковПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("УстановитьОтборТребованийПоПредложениюПоставщика", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПредложенияПоставщиковПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПоставщикиПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПредложенияПоставщиковВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекДанные = Элементы.ПредложенияПоставщиков.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ИмяПоля = Поле.Имя;
	Если ИмяПоля = "ПредложенияПоставщиковПредложениеПоставщика"
			ИЛИ ИмяПоля = "ПредложенияПоставщиковПредложениеПоставщикаКонтрагент" Тогда
		ОткрытьПредложениеПоставщика(ТекДанные.ПредложениеПоставщика);
	ИначеЕсли ИмяПоля = "ПредложенияПоставщиковПредложениеПоставщикаЛот" Тогда
		ПоказатьЗначение(, ТекДанные.Лот);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СведенияОПредоставленныхДокументахПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПредложенияПоставщиковПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ОбъектСогласован" Тогда
		ОпределитьСостояниеОбъекта();
	ИначеЕсли ИмяСобытия = "ОбъектОтклонен" Тогда
		ОпределитьСостояниеОбъекта();
	ИначеЕсли ИмяСобытия = "МаршрутИнициализирован" Тогда
		ОпределитьСостояниеОбъекта();
	ИначеЕсли ИмяСобытия = "СостояниеЗаявкиПриИзменении" Тогда
		ОпределитьСостояниеОбъекта();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждениеЗаполненияУсловий_Завершение(Результат, ДополнительныеПараметры) Экспорт
    Если Результат = КодВозвратаДиалога.Да Тогда
        ЗаполнитьПредложения_Сервер(Истина);
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
        // Пользователь отказался. Ничего не делаем.
    Иначе
		// Неизвестный вариант. Пропускаем.
	КонецЕсли;
КонецПроцедуры		// ПодтверждениеЗаполненияУсловий_Завершение()

&НаКлиенте
Процедура ЗаполнитьПредложения(Команда)
	Если Объект.ПредложенияПоставщиков.Количество() = 0 Тогда
		ЗаполнитьПредложения_Сервер(Истина);
	Иначе
		СтруктураПараметров = Новый Структура;
		ТекстВопроса = НСтр("ru = 'В таблице предложений есть заполненные данные. Продолжить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПодтверждениеЗаполненияУсловий_Завершение", ЭтаФорма, СтруктураПараметров);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыНаКлиенте

&НаКлиенте
Процедура ОткрытьПредложениеПоставщика(ПредложениеПоставщика) Экспорт
	Если ЗначениеЗаполнено(ПредложениеПоставщика) Тогда
			ДопПараметры = Новый Структура("Ключ", ПредложениеПоставщика);
			ОткрытьФорму("Документ.ПредложениеПоставщика.ФормаОбъекта", ДопПараметры, ЭтаФорма);
		КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКомментарий(Результат, ДопПараметры) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда
		ОБъект.Комментарий = СокрЛП(Результат);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПричинуОтказа(Результат, ДопПараметры) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда
		Объект.ПричинаПризнанияТорговНесостоявшимися = СокрЛП(Результат);
	Иначе
		Объект.ТоргиСостоялись = Истина;
	КонецЕсли;
	
	УстановитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОформлениеФормы()
	Элементы.РезультатРаботыКомиссии.Видимость =
			НЕ Объект.Отменен;
	Элементы.ПричинаОтмены.Видимость = Объект.Отменен;
	Элементы.ГруппаЕИС.Видимость = ЭтоФЗ223;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборТребованийПоПредложениюПоставщика()
	ТекДанные = Элементы.ПредложенияПоставщиков.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Элементы.СведенияОПредоставленныхДокументах.ОтборСтрок = 
		Новый ФиксированнаяСтруктура("ПредложениеПоставщика", ТекДанные.ПредложениеПоставщика);
КонецПроцедуры

&НаКлиенте
Процедура ЛотПриИзменении(Элемент)
	ДополнитьТаблицуПредложенийПоставщиковНаСервере();
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыНаСервере


&НаСервере
Функция ТекущееПредложениеПоставщика()
	ПредложениеПоставщика = Документы.ПредложениеПоставщика.ПустаяСсылка();
	ТекСтрока = Элементы.ПредложенияПоставщиков.ТекущаяСтрока;
	Если ТекСтрока <> Неопределено Тогда
		СтрокаТЧ = Объект.ПредложенияПоставщиков.НайтиПоИдентификатору(ТекСтрока);
		Если СтрокаТЧ <> Неопределено Тогда
			ПредложениеПоставщика = СтрокаТЧ.ПредложениеПоставщика;
		КонецЕсли;
	КонецЕсли;
	Возврат ПредложениеПоставщика;
КонецФункции

&НаСервере
Процедура УстановитьТекущееПредложениеПоставщика(ПредложениеПоставщика)
	мСтрокиПредложения = Объект.ПредложенияПоставщиков.НайтиСтроки(
		Новый Структура("ПредложениеПоставщика", ПредложениеПоставщика));
	ТекСтрока = Неопределено;
	Если мСтрокиПредложения.Количество() > 0 Тогда
		ТекСтрока = мСтрокиПредложения[0].ПолучитьИдентификатор()
	ИначеЕсли Объект.ПредложенияПоставщиков.Количество() > 0 Тогда
		ТекСтрока = Объект.ПредложенияПоставщиков[0].ПолучитьИдентификатор();
	КонецЕсли;
	Элементы.ПредложенияПоставщиков.ТекущаяСтрока = ТекСтрока;
КонецПроцедуры

// Заполняем ТЧ ПредложенияПоставщиков.
//
&НаСервере
Процедура ДополнитьТаблицуПредложенийПоставщиковНаСервере()
	Если НЕ ЗначениеЗаполнено(Объект.ЗакупочнаяПроцедура) Тогда
		Возврат;
	КонецЕсли;
	ТекущееПредложение = ТекущееПредложениеПоставщика();
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьПредложениямиПоставщиковПоУмолчанию();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	ЗаполнитьДопРеквизитыТаблицыПредложенийПоставщиков();
	Объект.ПредложенияПоставщиков.Сортировать("Лот");
	УстановитьТекущееПредложениеПоставщика(ТекущееПредложение);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДопРеквизитыТаблицыПредложенийПоставщиков()
	Для Каждого СтрокаПредложения Из Объект.ПредложенияПоставщиков Цикл
		ЗаполнитьДопРеквизитыСтрокиТаблицыПредложенияПоставщиков(СтрокаПредложения);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДопРеквизитыСтрокиТаблицыПредложенияПоставщиков(СтрокаПредложения)
	Если ЗначениеЗаполнено(СтрокаПредложения.ПредложениеПоставщика) Тогда
		РеквизитыПредложения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			СтрокаПредложения.ПредложениеПоставщика,
			"Лот, Контрагент");
		СтрокаПредложения.Лот = РеквизитыПредложения.Лот;
		СтрокаПредложения.Поставщик = РеквизитыПредложения.Контрагент;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗакупкаПриИзмененииНаСервере()
	Объект.ПредложенияПоставщиков.Очистить();
	Объект.СведенияОПредоставленныхДокументах.Очистить();
	УстановитьРеквизитыФормыПоЗакупке();
	ДополнитьТаблицуПредложенийПоставщиковНаСервере();
КонецПроцедуры

&НаСервере
Процедура УстановитьРеквизитыФормыПоЗакупке()
	Если ЗначениеЗаполнено(Объект.ЗакупочнаяПроцедура) Тогда
		ЭтоФЗ223 = Справочники.ЗакупочныеПроцедуры.ЭтоФЗ223(Объект.ЗакупочнаяПроцедура);
	Иначе
		ЭтоФЗ223 = Ложь;
	КонецЕсли;
КонецПроцедуры

// Серверная обёртка команды ЗаполнитьПредложения. Параметр ОчищатьСуществующиеВход
// определяет, нужно ли очистить существующие данные.
&НаСервере
Процедура ЗаполнитьПредложения_Сервер(ОчищатьСуществующиеВход)
	// Очистка сущетвующих данных.
	Если ОчищатьСуществующиеВход Тогда
		Объект.ПредложенияПоставщиков.Очистить();
		Объект.СведенияОПредоставленныхДокументах.Очистить();
	Иначе
		// Не требуется очистка.
	КонецЕсли;
	// Добавление новых данных.
	ТекущееПредложение = ТекущееПредложениеПоставщика();
	мПредложений = Документы.ПредложениеПоставщика.ПолучитьДопущенныеКУчастиюВЗакупке(Объект.ЗакупочнаяПроцедура);
	Для Каждого ПредложениеПоставщика Из мПредложений Цикл
		Документы.ПротоколВскрытияКонвертов.ДобавитьСтрокуПредложенияПоставщика(
			Объект.ЗакупочнаяПроцедура,
			Объект.ПредложенияПоставщиков,
			Объект.СведенияОПредоставленныхДокументах,
			ПредложениеПоставщика,
			Ложь);
	КонецЦикла;
	ЗаполнитьДопРеквизитыТаблицыПредложенийПоставщиков();
	Объект.ПредложенияПоставщиков.Сортировать("Лот");
	УстановитьТекущееПредложениеПоставщика(ТекущееПредложение);
КонецПроцедуры		// ЗаполнитьПредложения_Сервер()

#КонецОбласти


#Область УниверсальныеПроцессыСогласование

&НаСервере
Процедура ОпределитьСостояниеОбъекта()
	ДействияСогласованиеУХСервер.ОпределитьСостояниеЗаявки(ЭтаФорма);
КонецПроцедуры

// Выводит на форму панель согасования и устанавливает обработчики событий
// для элементов панели.
&НаСервере
Процедура НарисоватьПанельСогласованияИОпределитьСостояниеОбъекта()
	МодульСогласованияДокументовУХ.НарисоватьПанельСогласования(Элементы, ЭтаФорма);
	ЭтаФорма.Команды["ПринятьКСогласованию"].Действие	 = "ПринятьКСогласованию_Подключаемый";
	ЭтаФорма.Команды["ИсторияСогласования"].Действие	 = "ИсторияСогласования_Подключаемый";
	ЭтаФорма.Команды["СогласоватьДокумент"].Действие	 = "СогласоватьДокумент_Подключаемый";
	ЭтаФорма.Команды["ОтменитьСогласование"].Действие	 = "ОтменитьСогласование_Подключаемый";
	ЭтаФорма.Команды["МаршрутСогласования"].Действие	 = "МаршрутСогласования_Подключаемый";
	ОпределитьСостояниеОбъекта();
	ЭлементСтатусОбъекта = Элементы.Найти("СтатусОбъекта");
	Если ЭлементСтатусОбъекта <> Неопределено Тогда
		Если ЭлементСтатусОбъекта.Вид = ВидПоляФормы.ПолеВвода Тогда
			ЭлементСтатусОбъекта.УстановитьДействие("ОбработкаВыбора", "СтатусОбъектаОбработкаВыбора"); 
		Иначе
			// В прочих случаях не устанавливаем обработчик выбора.
		КонецЕсли;
	Иначе
		// Нет элемента Статус объекта.
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбъектаПриИзменении_Подключаемый()
	НовоеЗначениеСтатуса = РеквизитСтатусОбъекта(ЭтаФорма);
	ПроверитьСохранениеИзменитьСтатус(НовоеЗначениеСтатуса);	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбъектаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение = РеквизитСтатусОбъекта(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьСохранениеИзменитьСтатус(ВыбранноеЗначение);
КонецПроцедуры

// Проверяет сохранение текущего объекта и изменяет его статус
// НовоеЗначениеСтатусаВход.
&НаКлиенте
Процедура ПроверитьСохранениеИзменитьСтатус(НовоеЗначениеСтатусаВход)
	Если (Объект.Ссылка.Пустая()) ИЛИ (ЭтаФорма.Модифицированность) Тогда
		СтруктураПараметров = Новый Структура("ВыбранноеЗначение", НовоеЗначениеСтатусаВход);
		ОписаниеОповещения = Новый ОписаниеОповещения("СостояниеЗаявкиОбработкаВыбораПродолжение", ЭтотОбъект, СтруктураПараметров);
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
		|Изменение состояния возможно только после записи данных.
		|Данные будут записаны.'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		Возврат;
	КонецЕсли;
	ИзменитьСостояниеЗаявкиКлиент(НовоеЗначениеСтатусаВход);	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеЗаявкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение = РеквизитСостояниеЗаявки(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;

	ПроверитьСохранениеИзменитьСтатус(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение)
	ДействияСогласованиеУХКлиент.ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СостояниеЗаявкиОбработкаВыбораПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Записать();
		ИзменитьСостояниеЗаявкиКлиент(Параметры.ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИзменитьСостояниеЗаявки(Ссылка, Состояние)
	
	Возврат УправлениеПроцессамиСогласованияУХ.ПеревестиЗаявкуВПроизвольноеСостояние(Ссылка, Состояние, , , ЭтаФорма);
	
КонецФункции

&НаКлиенте
Процедура ПринятьКСогласованию_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.ПринятьКСогласованию(ЭтаФорма, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ИсторияСогласования_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.ИсторияСогласования(ЭтаФорма, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура СогласоватьДокумент_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.СогласоватьДокумент(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьСогласование_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.ОтменитьСогласование(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура МаршрутСогласования_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.МаршрутСогласования(ЭтаФорма, Объект.Ссылка);
КонецПроцедуры

// Возвращает значение реквизита СостояниеЗаявки на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСостояниеЗаявки(ФормаВход)
	Возврат ФормаВход["СостояниеЗаявки"];
КонецФункции

// Возвращает значение реквизита СтатусОбъекта на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСтатусОбъекта(ФормаВход)
	Возврат ФормаВход["СтатусОбъекта"];
КонецФункции

// Возвращает значение реквизита Согласующий на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСогласующий(ФормаВход)
	Возврат ФормаВход["Согласующий"];
КонецФункции


#КонецОбласти
