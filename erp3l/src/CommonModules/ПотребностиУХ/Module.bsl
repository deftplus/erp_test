
#Область ПрограммныйИнтерфейс

// Процедура добавляет и заполняет следующие поля коллекции: АналитикаНоменклатуры, АналитикаПотребностей, АналитикаСтруктуры
Процедура ВыполнитьКлючеваниеКоллекцииПотребностей(ТаблицаДанных) экспорт
	
	// Если колонка НомерСтроки есть, то принимаем, что она корректно заполнена(номером строки по порядку)
	Если ТаблицаДанных.Колонки.Найти("НомерСтроки") = неопределено Тогда
		ТаблицаДанных.Колонки.Добавить("НомерСтроки", ОбщегоНазначения.ОписаниеТипаЧисло(10, 0));
		Поз = 1;
		Для Каждого Строка Из ТаблицаДанных Цикл
			Строка.НомерСтроки = Поз;
			Поз = Поз + 1;
		КонецЦикла;
	КонецЕсли;
	
	Если ТаблицаДанных.Колонки.Найти("АналитикаНоменклатуры") = неопределено Тогда
		ТаблицаДанных.Колонки.Добавить("АналитикаНоменклатуры", Новый ОписаниеТипов("СправочникСсылка.КлючиАналитикиПланированияНоменклатуры"));
	КонецЕсли;
	
	Если ТаблицаДанных.Колонки.Найти("АналитикаПотребностей") = неопределено Тогда
		ТаблицаДанных.Колонки.Добавить("АналитикаПотребностей", Новый ОписаниеТипов("СправочникСсылка.КлючиАналитикиПланированияПотребностей"));
	КонецЕсли;
	
	Если ТаблицаДанных.Колонки.Найти("АналитикаСтруктуры") = неопределено Тогда
		ТаблицаДанных.Колонки.Добавить("АналитикаСтруктуры", Новый ОписаниеТипов("СправочникСсылка.КлючиАналитикиПланированияСтруктуры"));
	КонецЕсли;
	
	// КлючиАналитикиПланированияНоменклатуры
	ИменаПолей = РегистрыСведений.АналитикаПланированияНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
	ИменаПолей.ИсходнаяНоменклатура = "";  // ИсходнаяНоменклатура отсутствует. Будет писаться пустое значение
	
	Если ТаблицаДанных.Колонки.Найти("ЕдиницаИзмерения") = неопределено Тогда
		ИменаПолей.ЕдиницаИзмерения = ""; // 
	ИначеЕсли ТаблицаДанных.Колонки.Найти("Коэффициент ") = неопределено Тогда
		ИменаПолей.Коэффициент = "";
	КонецЕсли;
	РегистрыСведений.АналитикаПланированияНоменклатуры.ЗаполнитьВКоллекции(ТаблицаДанных, ИменаПолей);
	
	// КлючиАналитикиПланированияПотребностей
	ИменаПолей = РегистрыСведений.АналитикаПланированияПотребностей.ИменаПолейКоллекцииПоУмолчанию();
	ИменаПолей.АналитикаПланированияПотребностей = "АналитикаПотребностей";
	РегистрыСведений.АналитикаПланированияПотребностей.ЗаполнитьВКоллекции(ТаблицаДанных, ИменаПолей);
	
	// КлючиАналитикиПланированияСтруктуры
	ИменаПолей = РегистрыСведений.АналитикаПланированияСтруктуры.ИменаПолейКоллекцииПоУмолчанию();
	ИменаПолей.АналитикаПланированияСтруктуры = "АналитикаСтруктуры";
	// В потребностях обычно отсутствует ЦФО, хотя это поле необходимо для корректного формирования ключа
	Если ТаблицаДанных.Колонки.Найти("ЦФО") = неопределено Тогда
		ИменаПолей.ЦФО = "";  // ЦФО отсутствует. Будет писаться пустое значение
	КонецЕсли;
	
	РегистрыСведений.АналитикаПланированияСтруктуры.ЗаполнитьВКоллекции(ТаблицаДанных, ИменаПолей);
	
КонецПроцедуры

Процедура УстановитьУсловноеОформлениеДереваПараметровЗакупки(Форма, ИмяРеквизитаДерева) экспорт
	
	// Ограничение: имя реквизита дерева должно совпадать с именем элемента формы
	
	// Не отображать Свойство для детальных строк
	Элемент = Форма.УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяРеквизитаДерева+"Свойство");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяРеквизитаДерева + ".ДетальнаяЗапись");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	
	// Для групповых строк шрифт жирный
	Элемент = Форма.УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяРеквизитаДерева+"АналитикаПотребности");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяРеквизитаДерева+"АналитикаСтруктуры");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяРеквизитаДерева+"АналитикаНоменклатуры");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяРеквизитаДерева+"Свойство");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяРеквизитаДерева+"Значение");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяРеквизитаДерева + ".ДетальнаяЗапись");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,Истина));
	
	// Для групповых строк с НЕвозможностью изменения значения
	Элемент = Форма.УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяРеквизитаДерева+"Значение");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяРеквизитаДерева + ".ДетальнаяЗапись");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяРеквизитаДерева + ".ЗапретИзменения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", Новый Цвет(253, 246, 195));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	// Для групповых строк С возможностью изменения значения
	Элемент = Форма.УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяРеквизитаДерева+"Значение");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяРеквизитаДерева + ".ДетальнаяЗапись");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяРеквизитаДерева + ".ЗапретИзменения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", Новый Цвет(204, 255, 204));
	
	// Для детальных строк сбрасываем обязательность заполнения и устанавливаем только просмотр
	Элемент = Форма.УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяРеквизитаДерева+"Значение");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяРеквизитаДерева + ".ДетальнаяЗапись");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
КонецПроцедуры

Функция ПустойУИД() экспорт
	Возврат Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
КонецФункции

#КонецОбласти 
