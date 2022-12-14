#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Валюта = Параметры.Валюта;
	БанковскийСчетКасса = Параметры.БанковскийСчетКасса;
	ФормаОплаты = Параметры.ФормаОплаты;
	ПриходРасход = Параметры.ПриходРасход;
	
	АдресПлатежейВХранилище = Параметры.АдресПлатежейВХранилище;
	
	ЗаполнитьТаблицуЗаявок();
	СформироватьЗаголовокФормыПодбора(Заголовок, Параметры.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РассчитатьСуммуПлатежей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не ВыполняетсяЗакрытие И Модифицированность Тогда
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект),
			НСтр("ru = 'Данные были изменены. Перенести изменения в документ?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполняетсяЗакрытие = Истина;
		Модифицированность = Ложь;
		ПеренестиЗаявкиВДокумент();
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТаблицаЗаявокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ТаблицаЗаявок.ТекущиеДанные <> Неопределено Тогда
		Если Поле.Имя = "ТаблицаЗаявокПредставлениеЗаявки" Тогда
			ПоказатьЗначение(Неопределено, Элементы.ТаблицаЗаявок.ТекущиеДанные.ЗаявкаНаРасходованиеДенежныхСредств);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗаявокПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РассчитатьСуммуПлатежей();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьСтроки(Команда)
	
	ВыбратьВсеЗаявкиНаСервере(Истина);
	РассчитатьСуммуПлатежей();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтроки(Команда)
	
	ВыбратьВсеЗаявкиНаСервере(Ложь);
	РассчитатьСуммуПлатежей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ПеренестиЗаявкиВДокумент();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаЗаявокПредставлениеЗаявки.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаЗаявок.ЗаявкаНаРасходованиеДенежныхСредств");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ГиперссылкаЦвет);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаЗаявок.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаЗаявок.ПрисутствуетВДокументе");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Gray);
	
КонецПроцедуры

&НаСервере
Процедура ВыбратьВсеЗаявкиНаСервере(ЗначениеВыбора = Истина)
	
	Для Каждого СтрокаТаблицы Из ТаблицаЗаявок.НайтиСтроки(Новый Структура("СтрокаВыбрана", Не ЗначениеВыбора)) Цикл
		
		СтрокаТаблицы.СтрокаВыбрана = ЗначениеВыбора;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьЗаявкиВХранилище()
	
	//АдресЗаявокВХранилище = ПоместитьВоВременноеХранилище(
	//	ТаблицаЗаявок.Выгрузить(Новый Структура("СтрокаВыбрана", Истина),
	//	"ДокументПланирования, ИдентификаторПозиции, ПриходРасход")
	//);
	//
	//Возврат АдресЗаявокВХранилище;
	
	// Формирование таблицы для возврата в документ
	ТаблицаВыбранныхЗаявок = ТаблицаЗаявок.Выгрузить(Новый Структура("СтрокаВыбрана", Истина));
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("ДокументОснование", ТаблицаВыбранныхЗаявок.ВыгрузитьКолонку("ДокументПланирования"));
	ДанныеЗаполнения.Вставить("БанковскийСчетКасса", БанковскийСчетКасса);
	ДанныеЗаполнения.Вставить("Сумма", 0);
	
	//
	ИменаРеквизитов = "ДокументПланирования, ИдентификаторПозиции, ПриходРасход";
	ПлатПозиции = ТаблицаВыбранныхЗаявок.Скопировать(, ИменаРеквизитов);
	ПлатПозиции.Свернуть(ИменаРеквизитов, "");
	ДанныеЗаполнения.Вставить("ИдентификаторПозиции",ПлатПозиции);
	
	//
	Данные = ТаблицаЗаявок.Выгрузить();
	Данные.Очистить();
	ЗаявкиНаОперацииВстраивание.ЗаполнитьДокументПоЗаявкамНаРасходованиеДенежныхСредств(ДанныеЗаполнения, Данные, ФормаОплаты);
	
	//ТаблицаВыбранныхЗаявок = Данные.Выгрузить();
	//Данные.Колонки.Добавить("ОснованиеПлатежа");
	//Данные.ЗагрузитьКолонку(Данные.ВыгрузитьКолонку("Заказ"), "ОснованиеПлатежа");
	
	АдресЗаявокВХранилище = ПоместитьВоВременноеХранилище(Данные);
	
	Возврат АдресЗаявокВХранилище;
	
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуЗаявок()
	
	ДанныеОтбора = Новый Структура(
		"Контрагент,
		|БанковскийСчетПолучатель,
		|КассаПолучатель,
		|ПодотчетноеЛицо,
		|Организация,
		|ХозяйственнаяОперация,
		|ХозяйственнаяОперацияПоЗарплате,
		|Валюта,
		|ФормаОплаты,
		|БанковскийСчетКасса,
		|Ссылка,
		|Дата,
		|ПриходРасход,
		|ПервоначальныеИдентификаторыПозиций");
	
	ЗаполнитьЗначенияСвойств(ДанныеОтбора, Параметры);
	
	ПлатежныеПозиции.ЗаполнитьПоОстаткамПлатежныхПозиций(ДанныеОтбора, ТаблицаЗаявок);
	
	УстановитьПризнакиПрисутствияСтрокиВДокументе(ТаблицаЗаявок);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПризнакиПрисутствияСтрокиВДокументе(ТаблицаЗаявок)
	
	Если ЭтоАдресВременногоХранилища(АдресПлатежейВХранилище) Тогда
		
		СтруктураПоиска = Новый Структура("ИдентификаторПозиции");
		
		РасшифровкаПлатежа = ПолучитьИзВременногоХранилища(АдресПлатежейВХранилище);
		
		Для каждого СтрокаПлатежа Из ТаблицаЗаявок Цикл
			
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаПлатежа);
			
			Строки = РасшифровкаПлатежа.НайтиСтроки(СтруктураПоиска);
			Если Строки.Количество() Тогда
				СтрокаПлатежа.ПрисутствуетВДокументе = Истина;
			КонецЕсли;
			
			//СтрокаПлатежа.СтрокаВыбрана = Не СтрокаПлатежа.ПрисутствуетВДокументе;
			СтрокаПлатежа.СтрокаВыбрана = СтрокаПлатежа.ПрисутствуетВДокументе;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиЗаявкиВДокумент()
	
	// Снятие модифицированности, т.к. перед закрытием признак проверяется
	Модифицированность = Ложь;
	АдресЗаявокВХранилище = ПоместитьЗаявкиВХранилище();
	Закрыть();
	ОповеститьОВыборе(Новый Структура("АдресЗаявокВХранилище", АдресЗаявокВХранилище));
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуПлатежей()
	
	СуммаПлатежей = 0;
	Для Каждого СтрокаТаблицы Из ТаблицаЗаявок Цикл
		Если СтрокаТаблицы.СтрокаВыбрана Тогда
			СуммаПлатежей = СуммаПлатежей + СтрокаТаблицы.Сумма;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Формирует заголовок формы подбора, состоящий из заголовка формы и представления документа.
//
// Параметры:
//  Заголовок	 - Строка		 - заголовок формы,
//  Документ	 - ДокументСсылка	 - ссылка на документ, из которого открывается подбор.
// 
// Возвращаемое значение:
//  Строка - заголовок формы подбора.
//
Функция СформироватьЗаголовокФормыПодбора(Заголовок, Документ) Экспорт
	
	Если Документ = Неопределено Тогда
		Возврат Заголовок;
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(Документ) Тогда
		
		Заголовок = Заголовок + ": " + Документ;
		
	Иначе
		
		ТекстДокумент = НСтр("ru='%1 (новый)'");
		ТекстДокумент = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстДокумент, Документ.Метаданные().Синоним);
		
		Заголовок = Заголовок + ": " + ТекстДокумент;
		
	КонецЕсли;
	
	Возврат Заголовок;
	
КонецФункции

#КонецОбласти

ВыполняетсяЗакрытие = Ложь;

