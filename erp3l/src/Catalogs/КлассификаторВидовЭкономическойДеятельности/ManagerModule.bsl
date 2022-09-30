#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Функция читает данные классификатора из макета-источника и возвращает их в виде таблицы значений.
// Макеты хранятся в макетах данного справочника (см. общую форму "ДобавлениеЭлементовВКлассификатор").
//	Параметры:
//		ИмяМакетаСписков - Строка - имя макета, из которого необходимо загружать актуальные данные классификатора.
//	Возвращаемое значение:
//		ТаблицаЗначений - таблица значений, содержащая колонки:
//			Код - Строка - код классификатора;
//			Наименование - Строка - наименование классификатора;
//			Отбор - Булево - признак включения отбора по данной строке.
//
Функция ТаблицаКлассификатора(Знач ИмяМакетаСписков = "Списки2014Кв1") Экспорт
	
	Классификатор = Новый ТаблицаЗначений;
	Классификатор.Колонки.Добавить("Код", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(8)));
	Классификатор.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(150)));
	Классификатор.Колонки.Добавить("Отбор", Новый ОписаниеТипов("Булево")); 
	
		
	Классификатор.Очистить();
	
	// Получаем параметры справочника нужные для корректного чтения классификатора.
	ДлинаКодаСправочника = Метаданные.Справочники.КлассификаторВидовЭкономическойДеятельности.ДлинаКода;
	
	// Получаем полную таблицу элементов классификатора. 
	// В таблице содержатся Код и Наименование, элементов классификатора.
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
		ИспользоватьТаблицуОтбора = Ложь;
		ЭлементыКлассификатораИзМакета = Справочники.Организации.ПолучитьПараметрыФормыВыбораДляКода("ОКВЭД", Дата(1,1,1)).СписокКодов;
		//++ НЕ УТ
	Иначе
		ИспользоватьТаблицуОтбора = Истина;
		ЭлементыКлассификатораИзМакета = ИнтерфейсыВзаимодействияБРО.ПолучитьЗначенияИзСпискаВыбораОтчета(
			"РегламентированныйОтчетСтатистикаФормаП1", 
			ИмяМакетаСписков, 
			"s_okved",
			Ложь,
			ДлинаКодаСправочника);
		//-- НЕ УТ
	КонецЕсли;
			
	// Если классификатор будем строить исходя из таблицы отбора, то нужно ее получить.
	Если ИспользоватьТаблицуОтбора Тогда
		
		ОбластьИсточникОтбора = "pril_okved_51";
		Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
			ЭлементыКлассификатора = Справочники.Организации.ПолучитьПараметрыФормыВыбораДляКода("ОКВЭД", Дата(1,1,1)).СписокКодов;
			//++ НЕ УТ
		Иначе
			ЭлементыКлассификатора = ИнтерфейсыВзаимодействияБРО.ПолучитьЗначенияИзСпискаВыбораОтчета(
				"РегламентированныйОтчетСтатистикаФормаП1", 
				ИмяМакетаСписков, 
				ОбластьИсточникОтбора);
			//-- НЕ УТ
		КонецЕсли;
			
		ЭлементыКлассификатораИзМакета.Индексы.Добавить("Код");
		
	Иначе
		
		ЭлементыКлассификатора = ЭлементыКлассификатораИзМакета;
		
	КонецЕсли;
	
	Если ЭлементыКлассификатора.Количество() = 0 Тогда
		Возврат Классификатор;
	КонецЕсли;
	
	Для Каждого Элемент Из ЭлементыКлассификатора Цикл
		
		НоваяСтрока = Классификатор.Добавить();
		НоваяСтрока.Код   = Элемент.Код;
		НоваяСтрока.Отбор = ИспользоватьТаблицуОтбора; // Если используется таблица отбора, то в ЭлементыКлассификатора только отобранные элементы
		
		Наименование = "";
		Если Не ИспользоватьТаблицуОтбора Тогда
			Наименование = Элемент.Наименование;
		Иначе
			// В таблице отбора содержатся только коды элементов классификатора.
			// ЭлементыКлассификатора - это таблица отбора, а не таблица классификатора.
			// Поэтому наименование нужно подставить из общей таблицы.
			КлассификаторИзМакета = ЭлементыКлассификатораИзМакета.Найти(Элемент.Код, "Код");
			Если КлассификаторИзМакета <> Неопределено Тогда
				Наименование = КлассификаторИзМакета.Наименование;
			КонецЕсли;
		КонецЕсли;
		НоваяСтрока.Наименование = Наименование;
		
	КонецЦикла;
	
	Возврат Классификатор;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
		
	Если Параметры.Свойство("ДанныеКлассификатора") И Параметры.ДанныеКлассификатора
		ИЛИ Не ПолучитьФункциональнуюОпцию("ИспользованиеКлассификаторовНоменклатуры") Тогда 
		
		СтандартнаяОбработка = Ложь;
		
		Параметры.Вставить("ИмяСправочника", "КлассификаторВидовЭкономическойДеятельности");
		
		ВыбраннаяФорма = "ОбщаяФорма.ДобавлениеЭлементовВКлассификатор";
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти