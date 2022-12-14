
#Область ПрограммныйИнтерфейс
	
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// РАБОТА С ВРЕМЕННЫМИ ТАБЛИЦАМИ ЗАПРОСА

#Область ЗапросИВременныеТаблицы
	
// Функция возвращает структуру, в которой имя временной таблицы находится в ключе, а в занчении содержимое временной таблицы (таблица значений)
Функция СтруктураВТ(Запрос) Экспорт
	
	Рез = Новый Структура;
	
	Для каждого ВТ Из Запрос.МенеджерВременныхТаблиц.Таблицы Цикл
	
		Рез.Вставить(ВТ.ПолноеИмя, ВТ.ПолучитьДанные().Выгрузить());
	
	КонецЦикла; 
	
	Возврат Рез;
	
КонецФункции // СтруктураВТ()

//Процедура помещает таблицу значений в виртуальную таблицу запроса 
Процедура ЗагрузитьТаблицуВоВременнуюТаблицуЗапроса(Запрос, ИмяВТ, Таблица) Экспорт
	
	Если Запрос.МенеджерВременныхТаблиц = неопределено Тогда
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ * ПОМЕСТИТЬ "+ИмяВТ+" ИЗ &Таблица КАК Таблица";
	Запрос.УстановитьПараметр("Таблица", Таблица);
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ВыполнитьЗапрос(ТекстЗапроса, Параметры = неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Если ТипЗнч(Параметры) = Тип("Структура") Тогда
		
		Для Каждого КлючЗначение Из Параметры Цикл
			Запрос.УстановитьПараметр(КлючЗначение.Ключ, КлючЗначение.Значение);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Запрос.Выполнить();
	
КонецФункции

// Формирует пакет запросов и возвращает результат каждого запроса
//
// Параметры:
//	Запрос			- Запрос - запрос, параметры которого предварительно установлены.
//	ТекстыЗапроса	- СписокЗначений - в списке перечислены тексты запросов и их имена.
//	ОбходРезультата - ОбходРезультатаЗапроса - вариант обхода результата запроса.
//	ДобавитьРазделитель - Булево - добавлять разделитель между запросами из ТекстыЗапроса
//	УничтожитьСозданныеВременныеТаблицы - Булево - добавить уничножение временных таблиц, создаваемых в ТекстыЗапроса
//										Для уничтожения таблице должно быть присвоено имя в ТекстыЗапроса
//
// Возвращаемое значение:
//   Структура   - структура в которую помещены полученные таблицы
//
Функция ВыгрузитьРезультатыЗапроса(Запрос,
								 	ТекстыЗапроса,
									ОбходРезультата = Неопределено,
									ДобавитьРазделитель = Ложь,
									УничтожитьСозданныеВременныеТаблицы = Ложь) Экспорт

	Таблицы = Новый Структура;
	
	// Инициализация варианта обхода результата запроса.
	Если ОбходРезультата = Неопределено Тогда
		ОбходРезультата = ОбходРезультатаЗапроса.Прямой;
	КонецЕсли;
	
	ТекстУничтоженияВременныхТаблиц = "";
	
	ТекстИтоговогоЗапроса = "";
	
	// Формирование текст запроса.
	Для Каждого ТекстЗапроса Из ТекстыЗапроса Цикл
		Если ЗначениеЗаполнено(ТекстЗапроса.Представление) Тогда
			ТекстИтоговогоЗапроса = ТекстИтоговогоЗапроса 
							+ ?(ТекстИтоговогоЗапроса <> "", Символы.ПС, "")
							+ "// " + ТекстЗапроса.Представление + Символы.ПС;
		КонецЕсли; 
		ТекстИтоговогоЗапроса = ТекстИтоговогоЗапроса + ТекстЗапроса.Значение;
		
		Если ДобавитьРазделитель Тогда
			ТекстИтоговогоЗапроса = ТекстИтоговогоЗапроса + ТекстРазделителяЗапросовПакета();
		КонецЕсли;
		
		Если УничтожитьСозданныеВременныеТаблицы
			И ЗначениеЗаполнено(ТекстЗапроса.Представление) Тогда
			Если СтрНайти(ВРег(ТекстЗапроса.Значение), "ПОМЕСТИТЬ") <> 0 Тогда
		    	ТекстУничтоженияВременныхТаблиц = ТекстУничтоженияВременныхТаблиц + "
				|УНИЧТОЖИТЬ " + ТекстЗапроса.Представление;
				ТекстУничтоженияВременныхТаблиц = ТекстУничтоженияВременныхТаблиц + ТекстРазделителяЗапросовПакета();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	// Выполнение запроса.
	
	Если ЗначениеЗаполнено(ТекстУничтоженияВременныхТаблиц) Тогда
		ТекстИтоговогоЗапроса = ТекстИтоговогоЗапроса + ТекстУничтоженияВременныхТаблиц;
	КонецЕсли;
	
	Запрос.Текст = ТекстИтоговогоЗапроса;
	Результат = Запрос.ВыполнитьПакет();

	// Помещение результатов запроса в таблицы
	Для Каждого ТекстЗапроса Из ТекстыЗапроса Цикл

		ИмяТаблицы = ТекстЗапроса.Представление;

		Если Не ПустаяСтрока(ИмяТаблицы) Тогда

			Индекс = ТекстыЗапроса.Индекс(ТекстЗапроса);
			Таблицы.Вставить(ИмяТаблицы, Результат[Индекс].Выгрузить(ОбходРезультата));

		КонецЕсли;

	КонецЦикла;

	Возврат Таблицы;
	
КонецФункции

// Функция возвращает разделитель запросов в пакете запросов
Функция ТекстРазделителяЗапросовПакета() Экспорт

	ТекстРазделителя =
	"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";

	Возврат ТекстРазделителя;

КонецФункции

#КонецОбласти 

#Область ЗаменаСсылокПоИнформационнойБазе

// Заменяет ссылки по информационной базе.
//
// Параметры:
//	ПарыЗамены - Соответствие - ключи содержат замещаемых, значения содержат заменители
//	Исключения - Массив - необязателен, значения типа ОбъектМетаданных, в экземплярах которых замены проводить нельзя.
//
Процедура ЗаменитьСсылки(ПарыЗамен, Исключения = Неопределено) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	Английский = Метаданные.СвойстваОбъектов.ВариантВстроенногоЯзыка.Английский;
	ДвиженияССубконтоИмя = ?(Метаданные.ВариантВстроенногоЯзыка = Английский, ".RecordsWithExtDimensions", ".ДвиженияССубконто");
	
	Если Исключения = Неопределено Тогда
		Исключения = Новый Массив;
	КонецЕсли;
	
	// [ссылающийся объект](.Метаданные, .Замены[(.Замещаемое, .Заменитель)], .ТипыЗамещаемых[]).
	ИндексЗамены = ИндексЗамены(ПарыЗамен);
	КешПолей = Новый Соответствие;
	// Обходим индекс и в каждом ключе-объекта полностью замещаем все ссылки, подлежащие замене.
	Для Каждого УзелЗамены Из ИндексЗамены Цикл
		Ссылка = УзелЗамены.Ключ;
		МетаданныеУзла = УзелЗамены.Значение.Метаданные;
		Замены = УзелЗамены.Значение.Замены;
		ТипыЗамещаемых = УзелЗамены.Значение.ТипыЗамещаемых;
		
		Если Исключения.Найти(МетаданныеУзла) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЭтоСсылочныйОбъектМетаданных(МетаданныеУзла) Тогда
			// любой ссылочный объект
			ОбъектДанных = Ссылка.ПолучитьОбъект();
			Если ОбъектДанных <> Неопределено Тогда
				ПолноеИмя = МетаданныеУзла.ПолноеИмя();
				ИменаПолей = ИменаПолейСТипами(КешПолей, ПолноеИмя, ТипыЗамещаемых, "Ссылка, Ref");
				ЗаменитьЗначения(ОбъектДанных, ИменаПолей, Замены);
				// табчасти объекта
				ЗаменитьВТабчастях(
					КешПолей, МетаданныеУзла.ТабличныеЧасти, ОбъектДанных, ПолноеИмя, Замены, ТипыЗамещаемых, Исключения);
				// стандартные табчасти планов
				Если Метаданные.ПланыСчетов.Содержит(МетаданныеУзла) Или Метаданные.ПланыВидовРасчета.Содержит(МетаданныеУзла) Тогда
					ЗаменитьВТабчастях(
						КешПолей, МетаданныеУзла.СтандартныеТабличныеЧасти, ОбъектДанных, ПолноеИмя, Замены, ТипыЗамещаемых, Исключения);
				КонецЕсли;
				// пишем сам объект
				ЗаписатьДанные(ОбъектДанных);
				ОбъектДанных = Неопределено;
			КонецЕсли;
		ИначеЕсли Метаданные.Константы.Содержит(МетаданныеУзла) Тогда
			// значения в константах
			Константа = Константы[МетаданныеУзла.Имя];
			Константа.Установить(НовоеЗначение(Константа.Получить(), Замены));
		ИначеЕсли Метаданные.РегистрыСведений.Содержит(МетаданныеУзла) Тогда
			// необъектные таблицы
			ИменаПолей = ИменаПолейСТипами(КешПолей, МетаданныеУзла.ПолноеИмя(), ТипыЗамещаемых);
			Отборы = ОтборыРегистраСведений(МетаданныеУзла, Ссылка);
			Набор = НаборЗаписей(РегистрыСведений[МетаданныеУзла.Имя], Отборы);
			
			Таблица = Набор.Выгрузить();
			Набор.Очистить();
			ЗаписатьДанные(Набор);

			ЗаменитьЗначения(Таблица[0], ИменаПолей, Замены);
			Для Каждого ИмяПоля Из ИменаПолей Цикл
				Если Не Отборы.Свойство(ИмяПоля) Тогда
					Продолжить;
				КонецЕсли;
				Набор.Отбор[ИмяПоля].Установить(НовоеЗначение(Отборы[ИмяПоля], Замены));
			КонецЦикла;
			Набор.Загрузить(Таблица);
			ЗаписатьДанные(Набор);
		КонецЕсли;
		// обработка движений документа
		Если Метаданные.Документы.Содержит(МетаданныеУзла) Тогда
			Для Каждого Движение Из МетаданныеУзла.Движения Цикл
				ДопТаблица = "";
				Если Исключения.Найти(Движение) <> Неопределено Тогда
					Продолжить;
				КонецЕсли;
				Если Метаданные.РегистрыНакопления.Содержит(Движение) Тогда
					Регистр = РегистрыНакопления[Движение.Имя];
				ИначеЕсли Метаданные.РегистрыСведений.Содержит(Движение) Тогда
					Регистр = РегистрыСведений[Движение.Имя];
				ИначеЕсли Метаданные.РегистрыБухгалтерии.Содержит(Движение) Тогда
					ДопТаблица = ДвиженияССубконтоИмя;
					Регистр = РегистрыБухгалтерии[Движение.Имя];
				ИначеЕсли Метаданные.РегистрыРасчета.Содержит(Движение) Тогда
					Регистр = РегистрыРасчета[Движение.Имя];
				КонецЕсли;
				ЗаменитьВПодчиненномРегистре(КешПолей, Регистр, Ссылка, Движение.ПолноеИмя() + ДопТаблица, Замены, ТипыЗамещаемых);
			КонецЦикла;
			// обработка последовательностей, включающих документ
			Для Каждого Движение Из Метаданные.Последовательности Цикл
				Если Исключения.Найти(Движение) <> Неопределено Тогда
					Продолжить;
				КонецЕсли;
				Если Движение.Документы.Содержит(МетаданныеУзла) Тогда
					ЗаменитьВПодчиненномРегистре(
						КешПолей, Последовательности[Движение.Имя], Ссылка, Движение.ПолноеИмя(), Замены, ТипыЗамещаемых);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Строим соответствие вида [ссылающийся объект](.Метаданные, .Замены[(.Замещаемое, .Заменитель)], .ТипыЗамещаемых[])
// в итоге представляем результаты поиска по ссылкам в индексе с ключом-объектом, содержащим замещаемые ссылки.
Функция ИндексЗамены(ПарыЗамен)
	
	СписокСсылок = Новый Массив;
	Для Каждого Пара Из ПарыЗамен Цикл
		СписокСсылок.Добавить(Пара.Ключ);
	КонецЦикла;
	РезультатыПоиска = НайтиПоСсылкам(СписокСсылок);
	// (.Ссылка: исходная ссылка; .Данные: ссылающийся объект; .Метаданные: метаданные ссылающегося объекта).
	
	ИндексЗамены = Новый Соответствие;
	Для Каждого Результат Из РезультатыПоиска Цикл
		УзелЗамены = ИндексЗамены[Результат.Данные];
		Если Неопределено = УзелЗамены Тогда
			УзелЗамены =
				Новый Структура("Метаданные, Замены, ТипыЗамещаемых", Результат.Метаданные, Новый Массив, Новый Массив);
			ИндексЗамены.Вставить(Результат.Данные, УзелЗамены);
		КонецЕсли;

		УзелЗамены.Замены.Добавить(
			Новый Структура("Замещаемое, Заменитель", Результат.Ссылка, ПарыЗамен[Результат.Ссылка]));

		ТипЗамещаемого = ТипЗнч(Результат.Ссылка);
		Если Неопределено = УзелЗамены.ТипыЗамещаемых.Найти(ТипЗамещаемого) Тогда
			УзелЗамены.ТипыЗамещаемых.Добавить(ТипЗамещаемого);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИндексЗамены;
КонецФункции

Процедура ЗаменитьВТабчастях(КешПолей, ОписанияТабчастей, Объект, ИмяОсновнойТаблицы, Замены, ТипыЗамещаемых, Исключения)
	Для Каждого Описание Из ОписанияТабчастей Цикл
		Если Исключения.Найти(Описание) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ИменаПолей = ИменаПолейСТипами(КешПолей, ИмяОсновнойТаблицы + "." + Описание.Имя, ТипыЗамещаемых, "Ссылка, Ref");
		Для Каждого Табстрока Из Объект[Описание.Имя] Цикл
			ЗаменитьЗначения(Табстрока, ИменаПолей, Замены);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Процедура ЗаменитьВПодчиненномРегистре(КешПолей, МенеджерРегистра, Ссылка, ИмяТаблицыРегистра, Замены, ТипыЗамещаемых)
	ИменаПолей = ИменаПолейСТипами(КешПолей, ИмяТаблицыРегистра, ТипыЗамещаемых, "Регистратор, Recorder");
	Набор = НаборЗаписей(МенеджерРегистра, Новый Структура("Регистратор", Ссылка));
	ЗначениеЗаменено = Ложь;
	Для Каждого Запись Из Набор Цикл
		ЗаменитьЗначения(Запись, ИменаПолей, Замены, ЗначениеЗаменено);
	КонецЦикла;
	ЗаписатьДанные(Набор, ЗначениеЗаменено);
КонецПроцедуры

Функция ИменаПолейСТипами(КешПолейТаблиц, ИмяТаблицы, ТипыДанных, ИменаИсключений = "")
	
	ИменаПолей  = Новый Массив;
	Исключения  = Новый Структура(ИменаИсключений);
	ПоляТаблицы = КешПолейТаблиц.Получить(ИмяТаблицы);
	
	Если ПоляТаблицы = Неопределено Тогда
		
	    ПоляТаблицы = Новый Массив;
		
	    СхемаЗапроса = Новый СхемаЗапроса;
	    СхемаЗапроса.УстановитьТекстЗапроса(
			СтрЗаменить("ВЫБРАТЬ * ИЗ ТаблицаВыборки КАК Т ГДЕ ЛОЖЬ", "ТаблицаВыборки", ИмяТаблицы));
		
		Для Каждого КолонкаЗапроса Из СхемаЗапроса.ПакетЗапросов[0].Колонки Цикл
	        Если ТипЗнч(КолонкаЗапроса) = Тип("КолонкаСхемыЗапроса") Тогда
	            ПоляТаблицы.Добавить(
					Новый Структура("Имя,ТипЗначения", КолонкаЗапроса.Псевдоним, КолонкаЗапроса.ТипЗначения));
	        КонецЕсли; 
	    КонецЦикла;
		
	    КешПолейТаблиц.Вставить(ИмяТаблицы, ПоляТаблицы);
		
	КонецЕсли;
	
	Для Каждого Поле Из ПоляТаблицы Цикл
		
		Если Исключения.Свойство(Поле.Имя) Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ТипДанных Из ТипыДанных Цикл
			Если Поле.ТипЗначения.СодержитТип(ТипДанных) И ИменаПолей.Найти(Поле.Имя) = Неопределено Тогда
				ИменаПолей.Добавить(Поле.Имя);
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
    Возврат ИменаПолей;
	
КонецФункции

Процедура ЗаменитьЗначения(Данные, ИменаПолей, Замены, Заменено = Ложь)
	Для Каждого ИмяПоля Из ИменаПолей Цикл
		НовоеЗначение = НовоеЗначение(Данные[ИмяПоля], Замены);
		Если НовоеЗначение <> Данные[ИмяПоля] Тогда;
			Заменено = Истина;
			Данные[ИмяПоля] = НовоеЗначение;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция НовоеЗначение(СтароеЗначение, Замены)
	Для Каждого Замена Из Замены Цикл
		Если СтароеЗначение = Замена.Замещаемое Тогда
			Возврат Замена.Заменитель;
		КонецЕсли;
	КонецЦикла;
	Возврат СтароеЗначение;
КонецФункции

Процедура ЗаписатьДанные(Данные, Принудительно = Ложь)
	Если Данные.Модифицированность() Или Принудительно Тогда
		Данные.ОбменДанными.Загрузка = Истина;
		Данные.Записать();
	КонецЕсли;
КонецПроцедуры

Функция ОтборыРегистраСведений(МетаданныеРегистра, Запись)
	Отборы = Новый Структура;
	Если МетаданныеРегистра.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
		Отборы.Вставить("Период", Запись.Период);
	КонецЕсли;
	Для Каждого Измерение Из МетаданныеРегистра.Измерения Цикл
		Отборы.Вставить(Измерение.Имя, Запись[Измерение.Имя]);
	КонецЦикла;
	Возврат Отборы;
КонецФункции

Функция НаборЗаписей(МенеджерРегистра, Отборы)
	Набор = МенеджерРегистра.СоздатьНаборЗаписей();
	Для Каждого Отбор Из Отборы Цикл
		Набор.Отбор[Отбор.Ключ].Установить(Отбор.Значение);
	КонецЦикла;
	Набор.Прочитать();
	Возврат Набор;
КонецФункции

Функция ЭтоСсылочныйОбъектМетаданных(ОбъектМетаданных)
	Возврат Метаданные.Справочники.Содержит(ОбъектМетаданных)
		ИЛИ Метаданные.Документы.Содержит(ОбъектМетаданных)
		ИЛИ Метаданные.Перечисления.Содержит(ОбъектМетаданных)
		ИЛИ Метаданные.ПланыВидовХарактеристик.Содержит(ОбъектМетаданных)
		ИЛИ Метаданные.ПланыСчетов.Содержит(ОбъектМетаданных)
		ИЛИ Метаданные.ПланыВидовРасчета.Содержит(ОбъектМетаданных)
		ИЛИ Метаданные.БизнесПроцессы.Содержит(ОбъектМетаданных)
		ИЛИ Метаданные.Задачи.Содержит(ОбъектМетаданных)
		ИЛИ Метаданные.ПланыОбмена.Содержит(ОбъектМетаданных);
КонецФункции

#КонецОбласти

#Область СинхнонизацияКлючей

// Составляет список ключевых реквизитов справочника ключей.
// Если справочнику сопоставлен регистр сведений, используемый для поиска ключа,
// то ключевые реквизиты соответствуют изменениям этого регистра сведений.
//
// Параметры:
//  МетаданныеРегистра	- ОбъектМетаданныхРегистрСведений -
// 
// Возвращаемое значение:
//  Соответствие -
//
Функция КлючевыеРеквизитыСправочникаКлючейПоРегиструСведений(МетаданныеРегистра) Экспорт
	
	Результат = Новый Соответствие;
	
	Для Каждого Измерение Из МетаданныеРегистра.Измерения Цикл
		
		Результат.Вставить(Измерение.Имя);	
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает строку со списком полей регистра сведений ключа через запятую.
// Если справочнику сопоставлен регистр сведений, используемый для поиска ключа,
// то ключевые реквизиты соответствуют изменениям этого регистра сведений.
//
// Параметры:
//  МетаданныеРегистра	- ОбъектМетаданныхРегистрСведений -
// 
// Возвращаемое значение:
//  Строка -
//
Функция ПоляРегистраКЗаполнению(МетаданныеРегистра) Экспорт
	Поля = Новый Массив;
	Для Каждого Измерение Из МетаданныеРегистра.Измерения Цикл
		Поля.Добавить(Измерение.Имя);
	КонецЦикла;
	Возврат СтрСоединить(Поля, ",");
КонецФункции

#КонецОбласти 

// Функция возвращает пустое значение по определяемому типу
Функция ПустоеЗначениеОпределяемогоТипа(ОпределяемыйТип, НомерТипа = 0) Экспорт
	Возврат ПустоеЗначениеОписанияТипа(ОпределяемыйТип.Тип, НомерТипа);
КонецФункции

// Функция возвращает пустое значение по определяемому типу
Функция ПустоеЗначениеОписанияТипа(ОписаниеТипа, НомерТипа = 0) Экспорт
	Возврат Новый (ОписаниеТипа.Типы()[НомерТипа]);
КонецФункции

// Функция возвращает тип из определяемого типа по номеру
Функция ТипОпределяемогоТипа(ОпределяемыйТип, НомерТипа = 0) Экспорт
	Возврат ОпределяемыйТип.Тип.Типы()[НомерТипа];
КонецФункции

Функция СуммаРеквизитаЭлементовКоллекции(Коллекция, ИмяРеквизита) Экспорт
	
	Сумма = 0;
	Для каждого Элемент Из Коллекция Цикл
		Сумма = Сумма + Элемент[ИмяРеквизита];
	КонецЦикла;
	
	Возврат Сумма;
	
КонецФункции

Функция НайтиЭлементКоллекцииПоЗначениюРеквизита(Коллекция, ИмяРеквизита, ЗначениеРеквизита) Экспорт
	
	Для каждого Элемент Из Коллекция Цикл
		Если Элемент[ИмяРеквизита] = ЗначениеРеквизита Тогда
			Возврат Элемент;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
#КонецОбласти
 

