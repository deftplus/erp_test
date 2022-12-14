
#Область ПрограммныйИнтерфейс

Процедура ВыполнитьКомандуКТ(Команда, Форма) экспорт
	
	МенеджерКТ = МенеджерКроссТаблицФормы(Форма);
	
	Если МенеджерКТ = неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Для каждого КлючЗначение Из МенеджерКТ Цикл
		
		ОписаниеКТ = КлючЗначение.Значение;
		Если ОписаниеКТ.Свойство("Версия") = Ложь Тогда
			Продолжить;
		КонецЕсли; 
		
		Если ОписаниеКТ.Команды.Свойство(Команда.Имя) Тогда
			
			ОписаниеКоманды = ОписаниеКТ.Команды[Команда.Имя];
			
			Если ОписаниеКоманды.ИмяДействия = "УправлениеРасшифровкой" Тогда
				УправлениеРасшифровкой(ОписаниеКТ, ОписаниеКоманды, Форма);
			КонецЕсли;
			
			Прервать;
		КонецЕсли;
		
		// Поиск команды обработки включения/выключения видимости колонки
		Для каждого КлючЗначениеРесурс Из ОписаниеКТ.Схема.Ресурсы Цикл
			
			ОписаниеРесурса = КлючЗначениеРесурс.Значение;
			УправлениеВидимостью = ОписаниеРесурса.УправлениеВидимостью;
			
			Если УправлениеВидимостью.Использовать = Истина И УправлениеВидимостью.ИмяКоманды = Команда.Имя Тогда
				// Выполнить команду управления видимостью ресурса
				ИзменитьВидимостьКолонкиРесурса(Форма, ОписаниеКТ, ОписаниеРесурса);
				
				Прервать;
				
			КонецЕсли; 
		
		КонецЦикла; 
		
		// Поиск команды обработки включения/выключения видимости колонки
		Для каждого КлючЗначениеПоказатель Из ОписаниеКТ.Схема.Показатели Цикл
			
			ОписаниеПоказателя = КлючЗначениеПоказатель.Значение;
			УправлениеВидимостью = ОписаниеПоказателя.УправлениеВидимостью;
			
			Если УправлениеВидимостью.Использовать = Истина И УправлениеВидимостью.ИмяКоманды = Команда.Имя Тогда
				// Выполнить команду управления видимостью ресурса
				ИзменитьВидимостьКолонкиПоказателя(Форма, ОписаниеКТ, ОписаниеПоказателя);
				Прервать;
				
			КонецЕсли; 
		
		КонецЦикла; 
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ИзменитьВидимостьКолонкиРесурса(Форма, ОписаниеКТ, ОписаниеРесурса) экспорт
	
	ИмяЭлемента = ОписаниеРесурса.УправлениеВидимостью.ИмяЭлемента;
	
	Элемент = Форма.Элементы[ИмяЭлемента];
	
	// Если попытка отключить последний ресурс, то ничего не делаем
	Если ЭтоОтключениеПоследнейКнопкиВГруппе(Элемент, Элемент.Родитель) Тогда
		Возврат;
	КонецЕсли; 
	
	ВидимостьКолонкиКТ = НЕ Форма.Элементы[ИмяЭлемента].Пометка;
	
	КроссТаблицыУХКлиентСервер.УстановитьВидимостьКолонкиРесурса(Форма, ОписаниеКТ, ОписаниеРесурса, ВидимостьКолонкиКТ);
	
КонецПроцедуры

Процедура ИзменитьВидимостьКолонкиПоказателя(Форма, ОписаниеКТ, ОписаниеПоказателя) экспорт
	
	ИмяЭлемента = ОписаниеПоказателя.УправлениеВидимостью.ИмяЭлемента;
	
	Элемент = Форма.Элементы[ИмяЭлемента];
	
	// Если попытка отключить последний ресурс, то ничего не делаем
	Если ЭтоОтключениеПоследнейКнопкиВГруппе(Элемент, Элемент.Родитель) Тогда
		Возврат;
	КонецЕсли; 
	
	ВидимостьКолонкиКТ = НЕ Форма.Элементы[ИмяЭлемента].Пометка;
	
	КроссТаблицыУХКлиентСервер.УстановитьВидимостьКолонкиПоказателя(Форма, ОписаниеКТ, ОписаниеПоказателя, ВидимостьКолонкиКТ);
	
КонецПроцедуры

Функция Ресурс(СтрокаКТ, ПериодКТ, ПрефиксРесурса) экспорт
	
	Возврат СтрокаКТ[ПрефиксРесурса + ПериодКТ.ИмяКолонки];
	
КонецФункции

// Процедура устанавливает минимальные значения для колонок ресурсов Изменение, равное Исходному значению
Процедура УстановитьМинимальныеЗначенияДляЭлементовИзменение(ОписаниеКТ, Форма, ЭлементТаблицы) экспорт
	
	ТекущиеДанные = ЭлементТаблицы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы = Форма.Элементы;
	
	ТаблицаПериодов = Форма[ОписаниеКТ.Реквизиты.Периоды];
	
	АктивныеПериоды = ТаблицаПериодов.НайтиСтроки(Новый Структура("Активная", Истина));
	Если АктивныеПериоды.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	//
	Если ОписаниеКТ.ЕстьРасшифровка Тогда
		ИдентификаторСтроки = Форма.Элементы[ОписаниеКТ.Элементы.Расшифровка].ТекущаяСтрока;
		Если ИдентификаторСтроки = неопределено Тогда
			ТекущиеДанныеРасшифровки = неопределено;
		Иначе
			ТекущиеДанныеРасшифровки = Форма[ОписаниеКТ.Реквизиты.Расшифровка].НайтиПоИдентификатору(ИдентификаторСтроки);
		КонецЕсли;
	КонецЕсли;
		
	ПоказательИсх = ОписаниеКТ.Схема.Показатели.Исходное;
	ПоказательИзм = ОписаниеКТ.Схема.Показатели.Изменение;
	ПоказательРез = ОписаниеКТ.Схема.Показатели.Результат;
	
	Для Каждого КлючЗначениеРесурса Из ОписаниеКТ.Схема.Ресурсы Цикл
		
		Для Каждого Период Из АктивныеПериоды Цикл
		
			ОписаниеРесурса = КлючЗначениеРесурса.Значение;
			
			ИмяРеквизитаИсходное = ОписаниеРесурса.Имя+ПоказательИсх.Имя+"_"+Период.ИмяКолонки;
			ИсходноеЗначение = ТекущиеДанные[ИмяРеквизитаИсходное];
			
			// Ограничение значения Изменение
			ИмяЭлемента = ОписаниеКТ.Элементы.КроссТаблица+ОписаниеРесурса.Имя+ПоказательИзм.Имя+"_"+Период.ИмяКолонки;
			Элемент = Элементы[ИмяЭлемента];
			Если ОписаниеКТ.Схема.ЭтоПереносМеждуДокументамиРезервирования Тогда
				Элемент.МинимальноеЗначение = неопределено;
				Элемент.МаксимальноеЗначение = ИсходноеЗначение;
			Иначе
				Элемент.МинимальноеЗначение = -ИсходноеЗначение;
				Элемент.МаксимальноеЗначение = неопределено;
			КонецЕсли;
			
			// Ограничение значения Результат
			ИмяЭлемента = ОписаниеКТ.Элементы.КроссТаблица+ОписаниеРесурса.Имя+ПоказательРез.Имя+"_"+Период.ИмяКолонки;
			Элемент = Элементы[ИмяЭлемента];
			Если ОписаниеКТ.Схема.ЭтоПереносМеждуДокументамиРезервирования Тогда
				Элемент.МаксимальноеЗначение = ИсходноеЗначение;
			Иначе
				Элемент.МаксимальноеЗначение = неопределено;
			КонецЕсли;
			
			//
			Если ОписаниеКТ.ЕстьРасшифровка И ТекущиеДанныеРасшифровки <> неопределено Тогда
				
				ИмяРеквизита = ОписаниеРесурса.Имя+ПоказательИсх.Имя;
				ИсходноеЗначение = ТекущиеДанныеРасшифровки[ИмяРеквизита];
				
				// Ограничение значения Изменение
				ИмяЭлемента = ОписаниеКТ.Элементы.КроссТаблица+ОписаниеКТ.ПрефиксыЭлементов.ИзмерениеРасшифровки+ОписаниеРесурса.Имя+ПоказательИзм.Имя;
				Элемент = Элементы[ИмяЭлемента];
				Если ОписаниеКТ.Схема.ЭтоПереносМеждуДокументамиРезервирования Тогда
					Элемент.МинимальноеЗначение = неопределено;
					Элемент.МаксимальноеЗначение = ИсходноеЗначение;
				Иначе
					Элемент.МинимальноеЗначение = -ИсходноеЗначение;
					Элемент.МаксимальноеЗначение = неопределено;
				КонецЕсли;
				
				// Ограничение значения Результат
				ИмяЭлемента = ОписаниеКТ.Элементы.КроссТаблица+ОписаниеКТ.ПрефиксыЭлементов.ИзмерениеРасшифровки+ОписаниеРесурса.Имя+ПоказательРез.Имя;
				Элемент = Элементы[ИмяЭлемента];
				Если ОписаниеКТ.Схема.ЭтоПереносМеждуДокументамиРезервирования Тогда
					Элемент.МаксимальноеЗначение = ИсходноеЗначение;
				Иначе
					Элемент.МаксимальноеЗначение = неопределено;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьМинимальныеЗначенияДляЭкспрессРасшифровки(ОписаниеКТ, Форма, Элемент) экспорт
	
	Элементы = Форма.Элементы;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено ИЛИ НЕ ОписаниеКТ.ЕстьРасшифровка Тогда
		Возврат;
	КонецЕсли;
	
	ПоказательИсх = ОписаниеКТ.Схема.Показатели.Исходное;
	ПоказательИзм = ОписаниеКТ.Схема.Показатели.Изменение;
	ПоказательРез = ОписаниеКТ.Схема.Показатели.Результат;
	
	Для Каждого КлючЗначениеРесурса Из ОписаниеКТ.Схема.Ресурсы Цикл
		
		ОписаниеРесурса = КлючЗначениеРесурса.Значение;
		
		ИсходноеЗначение = ТекущиеДанные[ОписаниеРесурса.Имя+ПоказательИсх.Имя];
		
		// Ограничение значения Изменение
		Элемент = Элементы[ОписаниеКТ.Элементы.Расшифровка+"_"+ОписаниеРесурса.Имя+ПоказательИзм.Имя];
		Если ОписаниеКТ.Схема.ЭтоПереносМеждуДокументамиРезервирования Тогда
			Элемент.МинимальноеЗначение = неопределено;
			Элемент.МаксимальноеЗначение = ИсходноеЗначение;
		Иначе
			Элемент.МинимальноеЗначение = -ИсходноеЗначение;
			Элемент.МаксимальноеЗначение = неопределено;
		КонецЕсли;
				
		// Ограничение значения Результат
		Элемент = Элементы[ОписаниеКТ.Элементы.Расшифровка+"_"+ОписаниеРесурса.Имя];
		Если ОписаниеКТ.Схема.ЭтоПереносМеждуДокументамиРезервирования Тогда
			Элемент.МаксимальноеЗначение = ИсходноеЗначение;
		Иначе
			Элемент.МаксимальноеЗначение = неопределено;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция СтрокаПовторяетУжеСуществующуюСтрокуКроссТаблицы(ОписаниеКТ, Форма, ИдентификаторСтроки) экспорт
	
	ДанныеКТ = Форма[ОписаниеКТ.Реквизиты.КроссТаблица];
	
	ТекущиеДанные = ДанныеКТ.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	РеквизитыПоиска = ОписаниеКТ.Схема.Аналитики.Строка;
	Если СтрНайти(РеквизитыПоиска, "Номенклатура") > 0 
		И ОписаниеКТ.Схема.Ресурсы.Свойство("Количество") Тогда
		РеквизитыПоиска = РеквизитыПоиска + ", ЕдиницаИзмерения";
	КонецЕсли;
	
	СтруктураПоиска = Новый Структура(РеквизитыПоиска);
	
	ЗаполнитьЗначенияСвойств(СтруктураПоиска, ТекущиеДанные, РеквизитыПоиска);
	
	//
	Строки = ДанныеКТ.НайтиСтроки(СтруктураПоиска);
	
	Возврат Строки.Количество()>1;

КонецФункции // СтрокаПовторяетУжеСуществующуюСтрокуКроссТаблицы(ОписаниеКТ, ТекущиеДанные)

Функция СтрокаРасшифровкиПовторяетУжеСуществующуюСтрокуКроссТаблицы(ОписаниеКТ, Форма, ИдентификаторСтроки) экспорт
	
	ДанныеРасшифровки = Форма[ОписаниеКТ.Реквизиты.Расшифровка];
	
	ТекущиеДанные = ДанныеРасшифровки.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	РеквизитыПоиска = ОписаниеКТ.Схема.Аналитики.Расшифровка;
	Если СтрНайти(РеквизитыПоиска, "Номенклатура") > 0 Тогда
		РеквизитыПоиска = РеквизитыПоиска + ", ЕдиницаИзмерения";
	КонецЕсли;
	
	СтруктураПоиска = Новый Структура(РеквизитыПоиска);
	ЗаполнитьЗначенияСвойств(СтруктураПоиска, ТекущиеДанные, РеквизитыПоиска);
	СтруктураПоиска.Вставить("ИДСтроки", ТекущиеДанные.ИДСтроки);
	СтруктураПоиска.Вставить("ИДПериода", ТекущиеДанные.ИДПериода);
	
	//
	Строки = ДанныеРасшифровки.НайтиСтроки(СтруктураПоиска);
	
	Возврат Строки.Количество()>1;

КонецФункции // СтрокаПовторяетУжеСуществующуюСтрокуКроссТаблицы(ОписаниеКТ, ТекущиеДанные)

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Функция МенеджерКроссТаблицФормы(Форма)

	Возврат Форма.КроссТаблицыФормы;

КонецФункции // МенеджерКроссТаблицФормы()
 
Функция ЭтоОтключениеПоследнейКнопкиВГруппе(ЭтаКнопка, ГруппаКнопок)

	ТекущаяКнопкаВключена = ЭтаКнопка.Пометка;
	
	Если ТекущаяКнопкаВключена = Ложь Тогда
	
		Возврат Ложь;
	
	КонецЕсли;
	
	ВсеОстальныеКнопкиВыключены = Истина;
	
	Для каждого ТекущаяКнопка Из ГруппаКнопок.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(ТекущаяКнопка) <> Тип("КнопкаФормы") Тогда
			Продолжить;
		КонецЕсли; 
		
		Если ТекущаяКнопка.Имя = ЭтаКнопка.Имя Тогда
			Продолжить;
		КонецЕсли; 
		
		Если ТекущаяКнопка.Пометка = Истина Тогда
		
			ВсеОстальныеКнопкиВыключены = Ложь;
			Прервать;
		
		КонецЕсли; 
		
	КонецЦикла; 
	
	Возврат ВсеОстальныеКнопкиВыключены;

КонецФункции // ЭтоОтключениеПоследнейКнопкиВГруппе(()

Функция ПолучитьОписаниеПериодаПоИмениЭлемента(ТаблицаПериодов, ИмяЭлемента) Экспорт
	
	ИДПериода = Прав(СокрЛП(ИмяЭлемента), 36);
	
	Строки = ТаблицаПериодов.НайтиСтроки(Новый Структура("ИмяКолонки", ИДПериода));
	
	Если Строки.Количество() = 0 Тогда
		Возврат неопределено;
	Иначе
		Возврат Строки[0];
	КонецЕсли;
	
КонецФункции

Процедура УправлениеРасшифровкой(ОписаниеКТ, ОписаниеКоманды, Форма)
	
	Элементы = Форма.Элементы;
	
	КнопкаКТ = Элементы[ОписаниеКоманды.ДопСвойства.ИмяКнопкиКТ];
	КнопкаКТРасшифровка = Элементы[ОписаниеКоманды.ДопСвойства.ИмяКнопкиКТРасшифровка];
	КнопкаРасшифровки = Элементы[ОписаниеКоманды.ДопСвойства.ИмяКнопкиРасшифровки];
	ЭлементВладелецКТ = Элементы[ОписаниеКоманды.ДопСвойства.ГруппаРазмещения];
	
	// Варианты РежимЭкспрессРасшифровки
	// - 2 состояния (внизу, выключена);
	// - 3 состояния (справа, внизу, выключена)
	Если ОписаниеКТ.РежимЭкспрессРасшифровки = 2 Тогда
		// 2 состояния (Внизу и выключена)
		Если КнопкаКТ.Пометка = Ложь Тогда
			// Расшифровка видна и расположена справа
			КнопкаКТ.Видимость = Истина;
			КнопкаКТ.Пометка = Истина;
			ЭлементВладелецКТ.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
			КнопкаКТ.Заголовок = НСтр("ru = 'Расшифровка [Х]'");
			
			КнопкаРасшифровки.Видимость = Ложь;
			КнопкаКТРасшифровка.Видимость = Истина;
			
		Иначе
			// Расшифровка не видна
			КнопкаКТ.Видимость = Истина;
			КнопкаКТ.Пометка = Ложь;
			КнопкаКТ.Заголовок = НСтр("ru = 'Расшифровка [↓]'");
			
			КнопкаРасшифровки.Видимость = Ложь;
			
			КнопкаКТРасшифровка.Видимость = Истина;
			
		КонецЕсли;
	Иначе
		// 3 состояния (Справа, внизу и выключена)
		Если КнопкаКТ.Пометка = Ложь Тогда
			// Расшифровка видна и расположена справа
			КнопкаКТ.Видимость = Ложь;
			КнопкаКТ.Пометка = Истина;
			ЭлементВладелецКТ.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
			КнопкаКТ.Заголовок = НСтр("ru = 'Расшифровка [↓]'");
			
			КнопкаРасшифровки.Видимость = Истина;
			КнопкаКТРасшифровка.Видимость = Ложь;
			
		ИначеЕсли ЭлементВладелецКТ.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная Тогда
			// Расшифровка видна и расположена внизу
			КнопкаКТ.Видимость = Истина;
			КнопкаКТ.Пометка = Истина;
			ЭлементВладелецКТ.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
			КнопкаКТ.Заголовок = НСтр("ru = 'Расшифровка [Х]'");
			
			КнопкаРасшифровки.Видимость = Ложь;
			КнопкаКТРасшифровка.Видимость = Ложь;
			
		Иначе
			// Расшифровка не видна
			КнопкаКТ.Видимость = Истина;
			КнопкаКТ.Пометка = Ложь;
			КнопкаКТ.Заголовок = НСтр("ru = 'Расшифровка [→]'");
			
			КнопкаРасшифровки.Видимость = Ложь;
			
			КнопкаКТРасшифровка.Видимость = Истина;
			
		КонецЕсли;
	КонецЕсли;
	
	//
	КнопкаРасшифровки.Заголовок = КнопкаКТ.Заголовок;
	КнопкаРасшифровки.Пометка = КнопкаКТ.Пометка;
	
	Элементы[ОписаниеКоманды.ДопСвойства.ИмяЭлементаРасшифровка].Видимость = КнопкаКТ.Пометка;

КонецПроцедуры

#КонецОбласти 

