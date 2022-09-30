


// Генерирует макет шаблона в соответствии с текущими настройками генерации.
//

Функция СформироватьМакет(Вн_ТаблДок, ГруппыРаскрытияСтроки=Неопределено, ГруппыРаскрытияПоказатели=Неопределено, Параметры) Экспорт
	
	Перем ТаблДокЗаголовок;
	Перем ТаблСодержЧасть;
	Перем ТаблРасшифровка;
	
	Если ДописыватьВКонецПредыдущего Тогда
		ТаблДок = Вн_ТаблДок;
	Иначе
		ТаблДок = Новый ТабличныйДокумент;
	КонецЕсли;
	
		
	КэшРаскрытий = Новый ТаблицаЗначений;
	КэшРаскрытий.Колонки.Добавить("КодГруппыРаскрытия");
	КэшРаскрытий.Колонки.Добавить("ТаблДок");
	КэшРаскрытий.Колонки.Добавить("ПозицияПоказателей");
	КэшРаскрытий.Колонки.Добавить("ШиринаТаблицы");
	КэшРаскрытий.Колонки.Добавить("ВысотаШапки");
	КэшРаскрытий.Колонки.Добавить("РаскрытиеСтроки");

	ОсновнойРазмерШрифта = 8;
	Линия1 = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	Линия2 = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2);
	
	ФормироватьМакетыРаскрытия = ФормироватьГруппыРаскрытияПоказатели ИЛИ ФормироватьРаскрытияСтрок;
	
	// выводим раскрытия показателей
	Если ФормироватьМакетыРаскрытия Тогда
		
		МаксимальнаяШиринаТаблицы = 0;
		
		Если ФормироватьГруппыРаскрытияПоказатели Тогда
			
			МассивГруппыПоказателей=ГруппыРаскрытияПоказатели.НайтиСтроки(Новый Структура("Пометка", Истина));
			
			Если ТаблРасшифровка = Неопределено Тогда
				ТаблРасшифровка = Новый ТабличныйДокумент;
			КонецЕсли;
			
			Для Каждого СтрокаГруппыРаскрытия Из МассивГруппыПоказателей Цикл
				ПолученныйДокумент = ВывестиГруппуРаскрытия(ТаблДок, СтрокаГруппыРаскрытия,Ложь);
				Если ПолученныйДокумент <> Неопределено Тогда
					ТаблРасшифровка.Вывести(ПолученныйДокумент);
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		// выводим раскрытия строк
		
		Если ФормироватьРаскрытияСтрок Тогда
			
			МассивГруппыСтроки=ГруппыРаскрытияСтроки.НайтиСтроки(Новый Структура("Пометка", Истина));
			
			Для Каждого СтрокаГруппыРаскрытия Из МассивГруппыСтроки Цикл
				ТекШирина = ВывестиГруппуРаскрытия(ТаблДок, СтрокаГруппыРаскрытия,Истина, КэшРаскрытий); // В кэш помещаются только раскрытия в теле отчета.
				Если ТекШирина > МаксимальнаяШиринаТаблицы Тогда
					МаксимальнаяШиринаТаблицы = ТекШирина;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если КэшРаскрытий.Количество() > 0 Тогда
		
		Для Каждого Строка Из КэшРаскрытий Цикл
			
			ШиринаСдвига = МаксимальнаяШиринаТаблицы - Строка.ШиринаТаблицы;
			
			Если ШиринаСдвига > 0 Тогда
				ОбластьИсточник  = Строка.ТаблДок.Область(1, Строка.ПозицияПоказателей, Строка.ТаблДок.ВысотаТаблицы, Строка.ШиринаТаблицы);
				ОбластьВставки   = Строка.ТаблДок.Область(1, Строка.ПозицияПоказателей + ШиринаСдвига, Строка.ТаблДок.ВысотаТаблицы, Строка.ШиринаТаблицы + ШиринаСдвига);
				Строка.ТаблДок.ВставитьОбласть(ОбластьИсточник, ОбластьВставки, ТипСмещенияТабличногоДокумента.БезСмещения);
				
				Если Строка.ВысотаШапки > 0 Тогда
					ТекОБластьВставки = Строка.ТаблДок.Область(1, Строка.ПозицияПоказателей, Строка.ТаблДок.ВысотаТаблицы - 2, Строка.ПозицияПоказателей + ШиринаСдвига - 1);
					ТекОбластьВставки.Очистить();
					ТекОБластьВставки.Обвести(Линия2, Линия2, Линия2, Линия2);
				КонецЕсли;
				
				ТекОБластьВставки = Строка.ТаблДок.Область(Строка.ТаблДок.ВысотаТаблицы - 1, Строка.ПозицияПоказателей, , Строка.ПозицияПоказателей + ШиринаСдвига - 1);
				ТекОбластьВставки.Очистить();
				ТекОБластьВставки.СодержитЗначение = Ложь;
				ТекОБластьВставки.Обвести(Линия2, Линия2, Линия2, Линия2);
				ТекОбластьВставки.Узор = ТипУзораТабличногоДокумента.Узор3;
				
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	// формируем содержательную часть
	Если ФормироватьСодержательнуюЧасть Тогда
		ТаблСодержЧасть = Новый ТабличныйДокумент;
		ВысотаТаблДокПередФормированием = ТаблДок.ВысотаТаблицы;
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	ПоказателиОтчетов.Код,
		|	ПоказателиОтчетов.ТипЗначения,
		|	СтрокиОтчетов.Ссылка КАК СтрокаСсылка,
		|	ПоказателиОтчетов.Колонка КАК КолонкаСсылка,
		|	СтрокиОтчетов.ПорядковыйНомер КАК ПорядковыйНомерСтроки,
		|	ПоказателиОтчетов.Колонка.ПорядковыйНомер КАК ПорядковыйНомерКолонки,
		|	ПоказателиОтчетов.ГруппаРаскрытия КАК ГруппаРаскрытия
		|ИЗ
		|	Справочник.СтрокиОтчетов КАК СтрокиОтчетов
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПоказателиОтчетов КАК ПоказателиОтчетов
		|		ПО СтрокиОтчетов.Ссылка = ПоказателиОтчетов.Строка
		|ГДЕ
		|	(ПоказателиОтчетов.Ссылка ЕСТЬ NULL 
		|				И СтрокиОтчетов.Владелец = &ВидОтчета
		|			ИЛИ (НЕ ПоказателиОтчетов.ПометкаУдаления)
		|				И ПоказателиОтчетов.Владелец = &ВидОтчета)
		|	И (НЕ СтрокиОтчетов.ПометкаУдаления)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПорядковыйНомерСтроки ИЕРАРХИЯ,
		|	ПорядковыйНомерКолонки");
		Запрос.УстановитьПараметр("ВидОтчета", ВидОтчета);
		РезультатЗапроса = Запрос.Выполнить();
				
		Запрос.Текст = "ВЫБРАТЬ
		|	КолонкиОтчетов.Ссылка КАК КолонкаСсылка
		|ИЗ
		|	Справочник.КолонкиОтчетов КАК КолонкиОтчетов
		|ГДЕ
		|	КолонкиОтчетов.Владелец = &ВидОтчета
		|	И (НЕ КолонкиОтчетов.ПометкаУдаления)
		|
		|УПОРЯДОЧИТЬ ПО
		|	КолонкиОтчетов.ПорядковыйНомер";
							   
		Колонки = Новый СписокЗначений;
		Колонки.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("КолонкаСсылка"));
		Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.Прямой);
			
		ТаблицаПоказателей = РезультатЗапроса.Выгрузить(ОбходРезультатаЗапроса.Прямой);
		ТаблицаПоказателей.Колонки.Добавить("Уровень");
		ТаблицаПоказателей.Колонки.Добавить("Обработан");
		
		МаксУровень = 0;
		
		Для Каждого Пок Из ТаблицаПоказателей Цикл
			Пок.Уровень = ?(Пок.СтрокаСсылка = Справочники.СтрокиОтчетов.ПустаяСсылка(), 0, Пок.СтрокаСсылка.Уровень());
			
			Если Пок.Уровень > МаксУровень Тогда
				МаксУровень = Пок.Уровень;
			КонецЕсли;
			
			Если Пок.КолонкаСсылка=Справочники.КолонкиОтчетов.ПустаяСсылка() Тогда
				
				Сообщить("Для показателя с кодом "+СокрЛП(Пок.Код)+" не удалось определить колонку отчета.
				|Автоматическая установка его связи с макетом невозможна, необходимо выполнить сопоставление вручную.",СтатусСообщения.Важное);
				
				Пок.Обработан=Истина;
			КонецЕсли;
					
		КонецЦикла;
		
		ТаблицаПоказателейСорт = Новый ТаблицаЗначений;
		Для Каждого Колонка Из ТаблицаПоказателей.Колонки Цикл
			ТаблицаПоказателейСорт.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения, Колонка.Заголовок, Колонка.Ширина);
		КонецЦикла;
		Для Каждого Стр Из ТаблицаПоказателей Цикл
			Если Стр.Обработан = Истина Тогда
				Продолжить;
			КонецЕсли;
			НовСтр = ТаблицаПоказателейСорт.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр, Стр);
			Стр.Обработан = Истина;
			Для ИндСтрВнутр = ТаблицаПоказателей.Индекс(Стр) + 1 По ТаблицаПоказателей.Количество() - 1 Цикл
				СтрВнутр = ТаблицаПоказателей.Получить(ИндСтрВнутр);
				Если СтрВнутр.СтрокаСсылка = Стр.СтрокаСсылка Тогда
					НовСтр = ТаблицаПоказателейСорт.Добавить();
					ЗаполнитьЗначенияСвойств(НовСтр, СтрВнутр);
					СтрВнутр.Обработан = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		ТаблицаПоказателей = ТаблицаПоказателейСорт;
		
		ОтступДоКолонок = ?(ВыводитьНаименованияСтрок, 1, 0);
		
		Если ЗначениеЗаполнено(МаксимальнаяШиринаТаблицы) Тогда
			ШиринаСдвига = МаксимальнаяШиринаТаблицы - Колонки.Количество() - ОтступДоКолонок - ОтступПоГоризонтали;
		Иначе
			ШиринаСдвига = 0;
		КонецЕсли;
		
		// выводим заголовки колонок
		Если ВыводитьНаименованияКолонок Тогда
			
			Линия1 = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
			Линия2 = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2);
			
			Если ВыводитьНаименованияСтрок Тогда
				
				ТекОбл                  = ТаблСодержЧасть.Область(1, ОтступПоГоризонтали + 1);
				ПрименитьНастройкуОформления(ТекОбл, "Наименование");
				ТекОбл.СодержитЗначение = Ложь;
				ТекОбл.Шрифт            = Новый Шрифт(ТекОбл.Шрифт, , ОсновнойРазмерШрифта + 2, истина);
				ТекОбл.Текст            = "Статья";
				ТекОбл.Обвести(Линия2, Линия2, Линия2, Линия2);
			КонецЕсли;
			
			Если ШиринаСдвига > 0 Тогда
				ТекОбл = ТаблСодержЧасть.Область(1, ОтступПоГоризонтали + ОтступДоКолонок, , ОтступПоГоризонтали + ОтступДоКолонок + ШиринаСдвига);
				ТекОбл.Очистить();
				ТекОбл.Обвести(Линия2, Линия2, Линия2, Линия2);
				ОтступДоКолонок = ОтступДоКолонок + ШиринаСдвига;
			КонецЕсли;
			
			Для Каждого Колонка Из Колонки Цикл
					
				ТекОбл = ТаблСодержЧасть.Область(1, ОтступПоГоризонтали + ОтступДоКолонок + Колонки.Индекс(Колонка) + 1);
				ПрименитьНастройкуОформления(ТекОбл, "Наименование");
				ТекОбл.Заполнение		= ТипЗаполненияОбластиТабличногоДокумента.Текст;
				ТекОбл.Имя              = "Колонка_" + СокрЛП(Колонка.Значение.Код);
				ТекОбл.Шрифт            = Новый Шрифт(ТекОбл.Шрифт, , ОсновнойРазмерШрифта + 2, истина);
				ТекОбл.Текст			= Колонка.Значение;
				
				ТекОбл.ЦветФона			= ЦветФонаНаименования;
				ТекОбл.РазмещениеТекста	= ТипРазмещенияТекстаТабличногоДокумента.Переносить;
				ТекОбл.Обвести(, , Линия1, Линия2);
				
			КонецЦикла;
			
		КонецЕсли;
			
		// выводим строки
		ИмяСтроки  = "";
		ПослСтрока = -1;
		ТаблСтрока = Неопределено;
		
		Если ГруппироватьПоСтрокам Тогда
			ТаблСодержЧасть.НачатьАвтогруппировкуСтрок();
		КонецЕсли;
		
		
		ТекУровень = 0;
		
		Для Каждого Пок Из ТаблицаПоказателей Цикл
			
			Если ПослСтрока <> Пок.СтрокаСсылка Тогда
				Если ТипЗнч(ТаблСтрока) = Тип("ТабличныйДокумент") Тогда
					
					Если ОтступДоКолонок > 0 Тогда
						ТекОбласть = ТаблСтрока.Область(1,ОтступДоКолонок + ОтступПоГоризонтали, 1 , ОтступДоКолонок + ОтступПоГоризонтали);
						ТекОбласть.Обвести(, , Линия2);
					КонецЕсли;
					
					ОбластьСтроки = ТаблСтрока.Область(1, 1 + ОтступПоГоризонтали, ТаблСтрока.ВысотаТаблицы, ТаблСтрока.ШиринаТаблицы);
					ЛинияОбводки  = ?(ТекУровень = 0 И МаксУровень > 0, Линия2, Линия1);
					
					ОбластьСтроки.Обвести(, ЛинияОбводки, ,ЛинияОбводки);
					
					ОбластьВывода = ТаблСодержЧасть.Вывести(ТаблСтрока, ?(ТипЗнч(ПослСтрока) = Тип("СправочникСсылка.СтрокиОтчетов"), ?(ПослСтрока = Справочники.СтрокиОтчетов.ПустаяСсылка(), 0, ПослСтрока.Уровень()), Неопределено));

					ОбластьВывода.Имя = ИмяСтроки;
					
					ИмяОбласти = СокрЛП(ПослСтрока.ГруппаРаскрытия.Код) + "_" + СокрЛП(ПослСтрока.Код);
					ТекРаскрытие = КэшРаскрытий.Найти(ИмяОбласти, "КодГруппыРаскрытия");
					
					Если ТекРаскрытие <> Неопределено Тогда
						ТаблСодержЧасть.Вывести(ТекРаскрытие.ТаблДок);
					КонецЕсли;
					
				КонецЕсли;
				ПослСтрока = Пок.СтрокаСсылка;
				ТаблСтрока = Новый ТабличныйДокумент;
			КонецЕсли;
			
			
			Если ВыводитьНаименованияСтрок Тогда
				
				ТекОбл					= ТаблСтрока.Область(1, ОтступПоГоризонтали + 1);
				ТекОбл.Заполнение		= ТипЗаполненияОбластиТабличногоДокумента.Текст;
				ТекОбл.Текст			= Пок.СтрокаСсылка;
				
				ТекУровень              = ?(Пок.СтрокаСсылка = Справочники.СтрокиОтчетов.ПустаяСсылка(), 0, Пок.СтрокаСсылка.Уровень());
				ТекОбл.Имя              = "Строка_" + СокрЛП(Пок.СтрокаСсылка.Код);
				ТекОбл.ЦветФона			= ЦветФонаНаименования;
				ТекОбл.РазмещениеТекста	= ТипРазмещенияТекстаТабличногоДокумента.Переносить;
				ТекОбл.АвтоОтступ       = Число(АвтоОтступ);
				ТекОбл.Обвести(,  , Линия2);
				
				ТекОбл.Шрифт        = Новый Шрифт(ТекОбл.Шрифт, ,ОсновнойРазмерШрифта + ?(ТекУровень < 2, 2 - ТекУровень, 0)
												  , ?(ТекУровень < 2, Истина, Ложь));
												  
				ИмяСтроки               = "Область_Строка_" + СокрЛП(Пок.СтрокаСсылка.Код);
				
			КонецЕсли;
		
			Если ПустаяСтрока(Пок.Код) Тогда
				Продолжить;
			КонецЕсли;
			
			Колонка = Колонки.НайтиПоЗначению(Пок.КолонкаСсылка);
			
			ИндексКолонки = Колонки.Индекс(Колонка);
			ТекОбл = ТаблСтрока.Область(1, ОтступПоГоризонтали + ОтступДоКолонок + ИндексКолонки + 1);
			ТекОбл.Имя = СокрЛП(Пок.Код);
			ТекОбл.СодержитЗначение = Истина;
			ТекОбл.Обвести(Линия1, Линия1, Линия1, Линия1);
			ТекОбл.ТипЗначения = УправлениеОтчетамиУХ.ПолучитьОписаниеТиповПоТипуЗначения(Пок.ТипЗначения);
			ПрименитьНастройкуОформления(ТекОбл,"ЗаполняемоеЗначение");
			
			ТекОбл.Обвести(, , Линия1);
			
		КонецЦикла;
		
		Если ПослСтрока <> -1 Тогда
			Если ТипЗнч(ТаблСтрока) = Тип("ТабличныйДокумент") Тогда
				
				Если ОтступДоКолонок > 0 Тогда
					ТекОбласть = ТаблСтрока.Область(1,ОтступДоКолонок + ОтступПоГоризонтали, 1 , ОтступДоКолонок + ОтступПоГоризонтали);
					ТекОбласть.Обвести(, , Линия2);
				КонецЕсли;

				ОбластьСтроки = ТаблСтрока.Область(1, 1 + ОтступПоГоризонтали, ТаблСтрока.ВысотаТаблицы, ТаблСтрока.ШиринаТаблицы);
				ЛинияОбводки  = ?(ТекУровень = 0 И МаксУровень > 0, Линия2, Линия1);
				ОбластьСтроки.Обвести(, ЛинияОбводки, ,ЛинияОбводки);
				ОбластьВывода = ТаблСодержЧасть.Вывести(ТаблСтрока, ?(ТипЗнч(ПослСтрока) = Тип("СправочникСсылка.СтрокиОтчетов"), ПослСтрока.Уровень(), Неопределено));
				ОбластьВывода.Имя = ИмяСтроки;
				
				ИмяОбласти = СокрЛП(ПослСтрока.ГруппаРаскрытия.Код) + "_" + СокрЛП(ПослСтрока.Код);
				ТекРаскрытие = КэшРаскрытий.Найти(ИмяОбласти, "КодГруппыРаскрытия");
					
				Если ТекРаскрытие <> Неопределено Тогда
					ТаблСодержЧасть.Вывести(ТекРаскрытие.ТаблДок);
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
		Если ГруппироватьПоСтрокам Тогда
			ТаблСодержЧасть.ЗакончитьАвтогруппировкуСтрок();
		КонецЕсли;
		
		ОбластьТаблицы = ТаблСодержЧасть.Область(1, 1 + ОтступПоГоризонтали
												 , ТаблСодержЧасть.ВысотаТаблицы 
												 , ТаблСодержЧасть.ШиринаТаблицы);
												 
		ОбластьТаблицы.Обвести(Линия2, Линия2, Линия2, Линия2);

	КонецЕсли;
		
	
	МаксШирина = 1;
	
	Если ТаблСодержЧасть <> Неопределено И ТаблСодержЧасть.ШиринаТаблицы>1 Тогда
		МаксШиринаТаблицы = ТаблСодержЧасть.ШиринаТаблицы;
	Иначе
		МаксШиринаТаблицы=1;
	КонецЕсли;
	
	Если ФормироватьЗаголовок Тогда
		
		ТаблДокЗаголовок = Новый ТабличныйДокумент;
		ОбластьЗаголовок = ТаблДокЗаголовок.Область(1, ОтступПоГоризонтали + 1, 1, ОтступПоГоризонтали +  МаксШиринаТаблицы);
		ОбластьЗаголовок.Объединить();
		ОбластьЗаголовок.СодержитЗначение = Ложь;
		ОбластьЗаголовок.Текст = ШаблонОтчета.Наименование;
		ОбластьЗаголовок.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
		ОбластьЗаголовок.ВертикальноеПоложение = ВертикальноеПоложение.Центр;
		ОбластьЗаголовок.Шрифт = Новый Шрифт(ОбластьЗаголовок.Шрифт, ,ОбластьЗаголовок.Шрифт.Размер + 4, Истина);
		
		
		Шрифт      = Новый Шрифт("Arial", 10, Истина);
		
		ТаблСтрока = Новый ТабличныйДокумент;
		
		
		Если ФормироватьШапку  Тогда
			
			ОбластьЗаголовка = ТаблСтрока.Область(1, 1 + ОтступПоГоризонтали, 1, 1 + ОтступПоГоризонтали);
			ОбластьЗаголовка.СодержитЗначение = Ложь;
			ОбластьЗаголовка.Текст = "Реквизиты отчета:";
			ОбластьЗаголовка.Шрифт = Шрифт;
	
			ТаблДокЗаголовок.Вывести(ТаблСтрока, 1);

			ТаблДокЗаголовок.НачатьГруппуСтрок();
			
			Если Не ФормироватьПараметры Тогда
				ТаблицаПараметров = Параметры.Скопировать(Новый Структура("Предустановленный",Истина), "Наименование, Код");
			Иначе
				ТаблицаПараметров = Параметры.Скопировать(, "Наименование, Код");
			КонецЕсли;
			
			ТаблСтрока = СформироватьПараметры(ТаблицаПараметров, Шрифт);
		
			ТаблДокЗаголовок.Вывести(ТаблСтрока, 2);
		
			ТаблДокЗаголовок.ЗакончитьГруппуСтрок();
		КонецЕсли;
		
		
	КонецЕсли;

	ТаблДуммиДок = Новый ТабличныйДокумент;
	ОблДуммиДок  = ТаблДуммиДок.Область(1, 1, 1, 1);
	ОблДуммиДок.Имя = "Разрыв";
	
	Для Инд = 1 По ОтступПоВертикали Цикл
		
		ТаблДок.Вывести(ТаблДуммиДок);
		
	КонецЦикла;
	
	НуженРазделитель = Ложь;
	
	Если ТаблДокЗаголовок <> Неопределено Тогда

		ТаблДок.Вывести(ТаблДокЗаголовок);
		НуженРазделитель = Истина;
		
	КонецЕсли;

	Если ТаблСодержЧасть <> Неопределено Тогда
		
		Если НуженРазделитель Тогда
			ТаблДок.Вывести(ТаблДуммиДок);
		Иначе
			НуженРазделитель = Истина;
		КонецЕсли;
		
		ТаблДок.Вывести(ТаблСодержЧасть);
		
		ОбластьПервойКолонки = ТаблДок.Область("C" + Строка(1 + ОтступПоГоризонтали));
		ОбластьПервойКолонки.ШиринаКолонки = 50;
	
	КонецЕсли;

	Если ТаблРасшифровка <> Неопределено Тогда
		
		Если НуженРазделитель Тогда
			ТаблДок.Вывести(ТаблДуммиДок);
		Иначе
			НуженРазделитель = Истина;
		КонецЕсли;
		
		ТаблДок.Вывести(ТаблРасшифровка);
		
	КонецЕсли;
	
	ФиктивнаяОбласть = ТаблДок.Области.Найти("Разрыв");
	
	Если ФиктивнаяОбласть <> Неопределено Тогда
		ФиктивнаяОбласть.Имя = "";
	КонецЕсли;
		
	Модифицированность = Истина;
	
	Возврат ТаблДок;
	
КонецФункции

Функция СформироватьПараметры(ТаблицаЗначений, Шрифт, КолвоЗаписейВКолонке = 8, РасстояниеМеждуКолонками = 2)
	
	ТекТаблДок = Новый ТабличныйДокумент;
	
	Если ТипЗнч(ТаблицаЗначений) = Тип("ТаблицаЗначений") Тогда
		ТекИндекс = 0;
		ГорПоложение  = 1;
		ВертПоложение = 1;
		ШрифтНаименования = Новый Шрифт(Шрифт, , 8, Истина);
		Шрифт             = Новый Шрифт(Шрифт, , 8, Ложь);
			
		Для Каждого Строка Из ТаблицаЗначений Цикл
			
			
			ОблНаименование	= ТекТаблДок.Область(1 + ВертПоложение + 1, ОтступПоГоризонтали + ГорПоложение);
			
			ОблНаименование.СодержитЗначение		= Истина;
			ОблНаименование.Имя					    = Строка[1];
			ОблНаименование.Параметр                = Строка[1];
			ОблНаименование.ЦветФона				= ЦветФонаОбластиПараметра;
			ОблНаименование.РазмещениеТекста		= ТипРазмещенияТекстаТабличногоДокумента.Переносить;
			ОблНаименование.Шрифт                   = Шрифт;
						
			ОблНаименование	= ТекТаблДок.Область(1 + ВертПоложение, ОтступПоГоризонтали + ГорПоложение);
			ОблНаименование.СодержитЗначение		= Ложь;
			ОблНаименование.Текст				    = Строка[0];
			ОблНаименование.ЦветФона				= ЦветФонаНаименования;
			ОблНаименование.РазмещениеТекста		= ТипРазмещенияТекстаТабличногоДокумента.Переносить;
			ОблНаименование.Шрифт                   = ШрифтНаименования;     			
			
			ВертПоложение = ВертПоложение + 2;
			
			Если ВертПоложение >  КолВоЗаписейВКолонке Тогда
				ГорПоложение  = ГорПоложение + РасстояниеМеждуКолонками + 1;
				ВертПоложение = 1;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТекТаблДок;
	
КонецФункции

// Функция выводит группу раскрытия в макет
//
Функция ВывестиГруппуРаскрытия(ТаблДок, СтрокаГруппыРаскрытия, СтрокаОтчета, КэшГруппыРаскрытия = Неопределено);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "";
	
	Если СтрокаГруппыРаскрытия.ГруппаРаскрытия.Валютная Тогда
		
		Если БланкДляОтображения Тогда
			
			Запрос.Текст = Запрос.Текст +
			"ВЫБРАТЬ
			|	ГруппыРаскрытия.Код КАК КодГруппыРаскрытия,
			|	""АналитикаВалюта"" КАК ИндексАналитики,
			|	ВидыСубконто.Наименование КАК НаименованиеАналитики,
			|	""Наименование"" КАК СинонимРеквизита,
			|	1 КАК НомерСтрокиРеквизита,
			|	ВидыСубконто.ТипЗначения КАК ТипЗначенияАналитики,
			|	NULL КАК НаименованиеСтроки,
			|	NULL КАК ТипЗначенияПоказателя,
			|	NULL КАК НеФинансовый,
			|	NULL КАК СтрокаПорядковыйНомер,
			|	NULL КАК КолонкаПорядковыйНомер
			|ИЗ
			|	Справочник.ГруппыРаскрытия КАК ГруппыРаскрытия
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.ВидыСубконтоКорпоративные КАК ВидыСубконто
			|		ПО ГруппыРаскрытия.ВидАналитикиВалютаДт = ВидыСубконто.Ссылка
			|ГДЕ
			|	ГруппыРаскрытия.Ссылка = &ГруппаРаскрытия";
			
			Запрос.Текст = Запрос.Текст + " ОБЪЕДИНИТЬ ВСЕ ";
		
		Иначе
			
			Запрос.Текст = Запрос.Текст +
			"ВЫБРАТЬ
			|	ПравилаОтображенияПолей.Ссылка.Код КАК КодГруппыРаскрытия,
			|	""АналитикаВалюта"" КАК ИндексАналитики,
			|	ПравилаОтображенияПолей.ВидАналитики.Наименование КАК НаименованиеАналитики,
			|	ПравилаОтображенияПолей.Синоним КАК СинонимРеквизита,
			|	ПравилаОтображенияПолей.Поле КАК ПолеРеквизита,
			|	ПравилаОтображенияПолей.НомерСтроки КАК НомерСтрокиРеквизита,
			|	ПравилаОтображенияПолей.ИмяКолонки КАК ИмяКолонкиРеквизита,
			|	ПравилаОтображенияПолей.ВидАналитики.ТипЗначения КАК ТипЗначенияАналитики,
			|   NULL КАК НаименованиеСтроки,
			|	NULL КАК ТипЗначенияПоказателя,
			|	NULL КАК НеФинансовый,
			|   NULL КАК СтрокаПорядковыйНомер,
			|	NULL КАК КолонкаПорядковыйНомер
			|ИЗ
			|	Справочник.ГруппыРаскрытия.ПравилаОтображенияПолей КАК ПравилаОтображенияПолей
			|ГДЕ
			|	ПравилаОтображенияПолей.Ссылка = &ГруппаРаскрытия
			|	И (НЕ ПравилаОтображенияПолей.Ссылочное)
			|	И ПравилаОтображенияПолей.КодАналитики=&КодАналитикиВалюта";
			
			Запрос.УстановитьПараметр("КодАналитикиВалюта","АналитикаВалюта");
			
			Запрос.Текст = Запрос.Текст + " ОБЪЕДИНИТЬ ВСЕ ";

		КонецЕсли;	
		
	КонецЕсли;
	
	Для к = 1 По ПараметрыСеанса.ЧислоДопАналитик  Цикл
		
		Если БланкДляОтображения Тогда
			
			Запрос.Текст = Запрос.Текст +
			"ВЫБРАТЬ
			|	ГруппыРаскрытия.Код КАК КодГруппыРаскрытия,
			|	""Аналитика" + к + """ КАК ИндексАналитики,
			|	ВидыСубконто.Наименование КАК НаименованиеАналитики,
			|	""Наименование"" КАК СинонимРеквизита,
			|	1 КАК НомерСтрокиРеквизита,
			|	ВидыСубконто.ТипЗначения КАК ТипЗначенияАналитики,
			|   NULL КАК НаименованиеСтроки,
			|	NULL КАК ТипЗначенияПоказателя,
			|	NULL КАК НеФинансовый,
			|   NULL КАК СтрокаПорядковыйНомер,
			|	NULL КАК КолонкаПорядковыйНомер
			|ИЗ
			|	Справочник.ГруппыРаскрытия КАК ГруппыРаскрытия
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.ВидыСубконтоКорпоративные КАК ВидыСубконто
			|		ПО ГруппыРаскрытия.ВидАналитики" + к + " = ВидыСубконто.Ссылка
			|ГДЕ
			|	ГруппыРаскрытия.Ссылка = &ГруппаРаскрытия ";
			Если ВидОтчета.Метаданные().Реквизиты.Найти("ВидАналитики" + к) <> Неопределено Тогда
				Запрос.Текст = Запрос.Текст + "	И ГруппыРаскрытия.Владелец.ВидАналитики" + к + " = &ПустаяАналитика ";
			КонецЕсли;
			Запрос.Текст = Запрос.Текст + " ОБЪЕДИНИТЬ ВСЕ ";
		
		Иначе
			
			Запрос.Текст = Запрос.Текст +
			"ВЫБРАТЬ
			|	ПравилаОтображенияПолей.Ссылка.Код КАК КодГруппыРаскрытия,
			|	""Аналитика" + к + """ КАК ИндексАналитики,
			|	ПравилаОтображенияПолей.ВидАналитики.Наименование КАК НаименованиеАналитики,
			|	ПравилаОтображенияПолей.Синоним КАК СинонимРеквизита,
			|	ПравилаОтображенияПолей.Поле КАК ПолеРеквизита,
			|	ПравилаОтображенияПолей.НомерСтроки КАК НомерСтрокиРеквизита,
			|	ПравилаОтображенияПолей.ИмяКолонки КАК ИмяКолонкиРеквизита,
			|	ПравилаОтображенияПолей.ВидАналитики.ТипЗначения КАК ТипЗначенияАналитики,
			|   NULL КАК НаименованиеСтроки,
			|	NULL КАК ТипЗначенияПоказателя,
			|	NULL КАК НеФинансовый,
			|   NULL КАК СтрокаПорядковыйНомер,
			|	NULL КАК КолонкаПорядковыйНомер
			|ИЗ
			|	Справочник.ГруппыРаскрытия.ПравилаОтображенияПолей КАК ПравилаОтображенияПолей
			|ГДЕ
			|	ПравилаОтображенияПолей.Ссылка = &ГруппаРаскрытия
			|	И (НЕ ПравилаОтображенияПолей.Ссылочное)
			|	И ПравилаОтображенияПолей.КодАналитики=&КодАналитики"+к;
			
			Запрос.УстановитьПараметр("КодАналитики"+к,"Аналитика"+к);
			Если ВидОтчета.Метаданные().Реквизиты.Найти("ВидАналитики" + к) <> Неопределено Тогда
				Запрос.Текст = Запрос.Текст + "	И ПравилаОтображенияПолей.Ссылка.Владелец.ВидАналитики" + к + " = &ПустаяАналитика ";
			КонецЕсли;
			Запрос.Текст = Запрос.Текст + " ОБЪЕДИНИТЬ ВСЕ ";

		КонецЕсли;
		
	КонецЦикла; 

	Запрос.Текст = Запрос.Текст +
	"ВЫБРАТЬ
	|	ГруппыРаскрытия.Код,
	|	""Показатель"" КАК Поле1,
	|	ПоказателиОтчетов.Наименование,
	|	ПоказателиОтчетов.Код КАК Код1,
	|	0 КАК НомерСтрокиРеквизита,
	|	NULL КАК Поле2,
	|	NULL КАК Поле3,
	|	NULL КАК Поле4,
	|	ПоказателиОтчетов.Строка.Наименование,
	|	ПоказателиОтчетов.ТипЗначения,
	|	ПоказателиОтчетов.НеФинансовый,
	|	ПоказателиОтчетов.Строка.ПорядковыйНомер КАК СтрокаПорядковыйНомер,
	|	ПоказателиОтчетов.Колонка.ПорядковыйНомер КАК КолонкаПорядковыйНомер
	|ИЗ
	|	Справочник.ПоказателиОтчетов КАК ПоказателиОтчетов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыРаскрытия КАК ГруппыРаскрытия
	|		ПО ПоказателиОтчетов.ГруппаРаскрытия = ГруппыРаскрытия.Ссылка
	|ГДЕ
	|	ПоказателиОтчетов.Владелец = &ВидОтчета
	|	И (НЕ ПоказателиОтчетов.ПометкаУдаления)
	|	И ПоказателиОтчетов.ГруппаРаскрытия = &ГруппаРаскрытия";
	
	Если СтрокаОтчета Тогда
		
		Запрос.Текст = Запрос.Текст +"
		|И ПоказателиОтчетов.Строка=&Строка";
		
		Запрос.УстановитьПараметр("Строка",СтрокаГруппыРаскрытия.СтрокаОтчета);
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ВидОтчета", ВидОтчета);
	
	Запрос.Текст = Запрос.Текст +"	
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИндексАналитики,
	|   СтрокаПорядковыйНомер,
	|	КолонкаПорядковыйНомер";
	Запрос.УстановитьПараметр("ГруппаРаскрытия", СтрокаГруппыРаскрытия.ГруппаРаскрытия);
	Запрос.УстановитьПараметр("ПустаяАналитика", ПланыВидовХарактеристик.ВидыСубконтоКорпоративные.ПустаяСсылка());
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Отказ = Ложь;
	Пока Выборка.Следующий() Цикл
		Если Не Выборка.ИндексАналитики = "Показатель" и Выборка.СинонимРеквизита = Null и Не Метаданные.НайтиПоТипу(Выборка.ТипЗначенияАналитики.Типы()[0]) = Неопределено Тогда
			ОбщегоНазначенияУХ.СообщитьОбОшибке(" ошибка вывода группы раскрытия """ + СокрЛП(Выборка.КодГруппыРаскрытия) + """: по аналитике """ + Выборка.НаименованиеАналитики + """ не определен состав реквизитов для вывода в макет!" , Отказ);
		КонецЕсли;
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	КодГруппыРаскрытия = СокрЛП(СтрокаГруппыРаскрытия.ГруппаРаскрытия.Код)+?(СтрокаОтчета,"_"+СокрЛП(СтрокаГруппыРаскрытия.СтрокаОтчета.Код),"");
		
	// удалим существующие области
	Область = ТаблДок.Области.Найти(КодГруппыРаскрытия + "_Шапка");
	Если Не Область = Неопределено и Область.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки Тогда
		ТаблДок.УдалитьОбласть(Область, ТипСмещенияТабличногоДокумента.ПоГоризонтали);
	КонецЕсли;
	
	Область = ТаблДок.Области.Найти(КодГруппыРаскрытия);
	Если Не Область = Неопределено и Область.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки Тогда
		ТаблДок.УдалитьОбласть(Область, ТипСмещенияТабличногоДокумента.ПоГоризонтали);
	КонецЕсли;
	
	Область = ТаблДок.Области.Найти(КодГруппыРаскрытия + "_Подвал");
	Если Не Область = Неопределено и Область.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки Тогда
		ТаблДок.УдалитьОбласть(Область, ТипСмещенияТабличногоДокумента.ПоГоризонтали);
	КонецЕсли;
	

	ТаблРасшифровка = Новый ТабличныйДокумент;

	ТаблСтрока = Новый ТабличныйДокумент;
	ТаблСтрока.Область(1,1).Текст = "";
	
	Если НЕ (СтрокаОтчета) Тогда
		ТаблСтрока.Область(2,1).Текст = "";
	КонецЕсли;
	
	Если НЕ (СтрокаОтчета) ИЛИ СтрокаГруппыРаскрытия.ФормироватьШапку Тогда
		
		ОбластьШапка=ТаблРасшифровка.Вывести(ТаблСтрока);	
		ОбластьШапка.Имя = КодГруппыРаскрытия + "_Шапка";
		
		Если НЕ СтрокаОтчета Тогда
			ТаблРасшифровка.НачатьГруппуСтрок();
		КонецЕсли;
		
		СтрокШапки = 1;
		
	Иначе
		
		СтрокШапки = 0;
		
	КонецЕсли;
	
	ТаблСтрока = Новый ТабличныйДокумент;
	ТаблСтрока.Область(1,1).Текст = "";
	
	ОбластьГруппа=ТаблРасшифровка.Вывести(ТаблСтрока);	
	ОбластьГруппа.Имя = КодГруппыРаскрытия;
	
	Если НЕ СтрокаОтчета И СтрокаГруппыРаскрытия.ФормироватьШапку Тогда
		ТаблРасшифровка.ЗакончитьГруппуСтрок();
	КонецЕсли;
	
	ТаблСтрока = Новый ТабличныйДокумент;
	ТаблСтрока.Область(1,1).Текст = "";
	ОбластьПодвал=ТаблРасшифровка.Вывести(ТаблСтрока);
	
	ОбластьПодвал.Имя = КодГруппыРаскрытия + "_Подвал";
	
	НомерКолонки = ОтступПоГоризонтали + 1;
	
	СписокКолонок = РезультатЗапроса.Выгрузить().Скопировать(Новый Структура("ИндексАналитики", "Показатель"), "КолонкаПорядковыйНомер");
	СписокКолонок.Свернуть("КолонкаПорядковыйНомер");
	
	ОднаКолонка = СписокКолонок.Количество() <= 1;
	
	Линия1 = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	Линия2 = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2);
	
	НачалоДиапазона = 0;
	КонецДиапазона  = 0;
	ТекВидАналитики = Неопределено;
	
	ПозицияПоказателей = Неопределено;
	
	Пока Выборка.Следующий() Цикл
		
		Если СтрокШапки>0 Тогда // Выводим шапку макета
			
			Если Выборка.ИндексАналитики = "Показатель" Тогда
					
				ТекстЯчейки = ?(ОднаКолонка, Выборка.НаименованиеСтроки, Выборка.НаименованиеАналитики);
				ИмяШапки    = КодГруппыРаскрытия+"_Показатель_"+?(Выборка.СинонимРеквизита = Null, "", "_" + СокрЛП(Выборка.СинонимРеквизита))+"_Шапка";
				
				Если НЕ СтрокаОтчета Тогда
					ТекОбл      = ТаблРасшифровка.Область(1, НомерКолонки, 2, НомерКолонки);
					ТекОбл.Объединить();
				Иначе
					ТекОбл      = ТаблРасшифровка.Область(1, НомерКолонки, 1, НомерКолонки);
				КонецЕсли;

			Иначе
				
				ТекстЯчейки = Выборка.НаименованиеАналитики;
				ИмяШапки=КодГруппыРаскрытия+"_" + ?(Выборка.СинонимРеквизита = Null, "",Выборка.СинонимРеквизита)+"_Шапка";
				
				Если НЕ СтрокаОтчета Тогда
					ТекОбл = ТаблРасшифровка.Область(1, НомерКолонки);
					ТекОбл.Текст = Выборка.НаименованиеАналитики;
					ТекОбл = ТаблРасшифровка.Область(2, НомерКолонки);
					ТекстЯчейки = ?(Выборка.ИмяКолонкиРеквизита = Null, "", " " + Выборка.ИмяКолонкиРеквизита);
				Иначе
					ТекОбл = ТаблРасшифровка.Область(1, НомерКолонки, 1, НомерКолонки);
					ТекстЯчейки = Выборка.ИмяКолонкиРеквизита;
				КонецЕсли;

			КонецЕсли;
			
			Если НЕ СтрокаОтчета Тогда
				Если ТекВидАналитики <> Выборка.НаименованиеАналитики Тогда
					КонецДиапазона  = НомерКолонки - 1;
					Если НачалоДиапазона <> 0 И КонецДиапазона > НачалоДиапазона Тогда
						
						ТекОблОбъединения = ТаблРасшифровка.Область(1, НачалоДиапазона, 1, КонецДиапазона);
						ТекОблОбъединения.Объединить();
						ТекОблОбъединения.ЦветФона = ЦветФонаНаименования;
						ТекОблОбъединения.РазмещениеТекста        = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
						ТекОблОбъединения.ВертикальноеПоложение   = ВертикальноеПоложение.Центр;
						ТекОблОбъединения.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
						ТекОблОбъединения.АвтоОтступ              = Число(АвтоОтступ);
						ТекОблОбъединения.Обвести(, , , Линия1);
						
						ТекОблОбъединения = ТаблРасшифровка.Область(1, НачалоДиапазона, ?(СтрокаОтчета, 2, 3), КонецДиапазона);
						ТекОблОбъединения.Обвести(Линия2, Линия2, Линия2, Линия2);
						
					КонецЕсли;
					
					НачалоДиапазона = ?(Выборка.ИндексАналитики = "Показатель", 0, НомерКолонки);
					ТекВидАналитики = Выборка.НаименованиеАналитики;
				КонецЕсли;
			КонецЕсли;
			//ТекОбл                         = ТаблРасшифровка.Область(1, НомерКолонки);
			ТекОбл.Заполнение              = ТипЗаполненияОбластиТабличногоДокумента.Текст;
			ТекОбл.Текст                   = ТекстЯчейки;
			ТекОбл.ЦветФона                = ЦветФонаНаименования;
			ТекОбл.РазмещениеТекста        = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
			ТекОбл.ВертикальноеПоложение   = ВертикальноеПоложение.Центр;
			ТекОбл.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
			ТекОбл.АвтоОтступ              = Число(АвтоОтступ);
			
			Если СтрокаОтчета Тогда
				ТекОбл.Имя					   = ИмяШапки;
			КонецЕсли;
			
			ТекОбл.Обвести(, , Линия1, Линия2);
			
		КонецЕсли; // Конец вывода шапки макета
		
		ТекОбл = ТаблРасшифровка.Область(?(НЕ (СтрокаОтчета) И СтрокаГруппыРаскрытия.ФормироватьШапку, 2+СтрокШапки, 1+СтрокШапки), НомерКолонки);
		ТекОбл.СодержитЗначение = Истина;
		ТекОбл.Обвести(, , Линия1);
		
		Если Выборка.ИндексАналитики = "Показатель" Тогда
			
			Если ПозицияПоказателей = Неопределено Тогда
				ПозицияПоказателей = НомерКолонки;
			КонецЕсли;
			
			ТекОбл.Имя = КодГруппыРаскрытия + "_Показатель_" + ?(Выборка.СинонимРеквизита = Null, "",СокрЛП(Выборка.СинонимРеквизита));
			ТекОбл.ТипЗначения = УправлениеОтчетамиУХ.ПолучитьОписаниеТиповПоТипуЗначения(Выборка.ТипЗначенияПоказателя);
			
		Иначе
			
			ТекОбл.Имя = КодГруппыРаскрытия + "_" + ?(Выборка.СинонимРеквизита = Null, "",Выборка.СинонимРеквизита);
			ТекОбл.ТипЗначения = ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСтроки(255);
			
		КонецЕсли;
		
		ПрименитьНастройкуОформления(ТекОбл,"ЗаполняемоеЗначение");
		
		Если Выборка.ИндексАналитики = "Показатель" и Не Выборка.НеФинансовый Тогда
			
			ТекОбл = Неопределено;
				ИмяОбласти = КодГруппыРаскрытия + "_" + СокрЛП(Выборка.СинонимРеквизита) + "_СУММА";
				Область = ТаблРасшифровка.Области.Найти(ИмяОбласти);
				Если Область = Неопределено Тогда
					ТекОбл = ТаблРасшифровка.Область(?(НЕ (СтрокаОтчета) И СтрокаГруппыРаскрытия.ФормироватьШапку, 3 + СтрокШапки, 2 + СтрокШапки), НомерКолонки);
					ТекОбл.Имя = ИмяОбласти;
					ТекОбл.СодержитЗначение = Истина;
					ТекОбл.ТипЗначения = УправлениеОтчетамиУХ.ПолучитьОписаниеТиповПоТипуЗначения(Перечисления.ТипыЗначенийПоказателейОтчетов.Число);
					ТекОбл.Шрифт = Новый Шрифт(,,Истина);
					НомерКолонки = ТекОбл.Право + 1;
				КонецЕсли;
		Иначе
			НомерКолонки = ТекОбл.Право + 1;
		КонецЕсли; 
		
	КонецЦикла;
	
	Если НЕ СтрокаОтчета Тогда
		КонецДиапазона = НомерКолонки - 1;
		Если НачалоДиапазона <> 0 И КонецДиапазона > НачалоДиапазона И СтрокШапки>0 Тогда
			ТекОбл = ТаблРасшифровка.Область(1, НачалоДиапазона, 1, КонецДиапазона);
			ТекОбл.Объединить();
			ТекОбл.ЦветФона = ЦветФонаНаименования;
			ТекОбл.РазмещениеТекста        = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
			ТекОбл.ВертикальноеПоложение   = ВертикальноеПоложение.Центр;
			ТекОбл.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
			ТекОбл.АвтоОтступ              = Число(АвтоОтступ);
			ТекОбл.Обвести(, , , Линия1);
			
			ТекОбл = ТаблРасшифровка.Область(1, НачалоДиапазона, 3, КонецДиапазона);
			ТекОбл.Обвести(Линия2, Линия2, Линия1, Линия1);
		КонецЕсли;
	КонецЕсли;
	ОбластьОбводки = ТаблРасшифровка.Область(1, 1 + ОтступПоГоризонтали, ?(НЕ (СтрокаОтчета) И СтрокаГруппыРаскрытия.ФормироватьШапку, 2+СтрокШапки, 1+СтрокШапки), ТаблРасшифровка.ШиринаТаблицы);
	ОбластьОбводки.Обвести(Линия2, Линия2, Линия2, Линия2);
	
	Если КэшГруппыРаскрытия <> Неопределено Тогда
		
		НоваяСтрока = КэшГруппыРаскрытия.Добавить();
		НоваяСтрока.КодГруппыРаскрытия = КодГруппыРаскрытия;
		НоваяСтрока.ТаблДок            = ТаблРасшифровка;
		НоваяСтрока.ШиринаТаблицы      = ТаблРасшифровка.ШиринаТаблицы;
		НоваяСтрока.ПозицияПоказателей = ПозицияПоказателей;
		НоваяСтрока.ВысотаШапки        = СтрокШапки;
		Возврат НоваяСтрока.ШиринаТаблицы;
		
	Иначе
		
		Возврат ТаблРасшифровка;
		
	КонецЕсли;
	
КонецФункции

// Функция возвращает тип реквизита для типа значения аналитики
//
Функция ПолучитьТипРеквизитаАналитики(ТипЗначенияАналитики, ИмяРеквизита)
	
	Если ИмяРеквизита = Null Тогда
		Возврат ТипЗначенияАналитики;
	КонецЕсли;
	
	Если Перечисления.ТипВсеСсылки().СодержитТип(ТипЗначенияАналитики.Типы()[0]) Тогда
		
		Возврат ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСтроки(100);
		
	КонецЕсли;
	
	МетаданныеТипа = Метаданные.НайтиПоТипу(ТипЗначенияАналитики.Типы()[0]);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	_Таблица." + ИмяРеквизита + " КАК Колонка
	|ИЗ
	|	" + МетаданныеТипа.ПолноеИмя() + " КАК _Таблица
	|ГДЕ
	|	ЛОЖЬ"
	);
	Возврат Новый ОписаниеТипов(Запрос.Выполнить().Колонки.Колонка.ТипЗначения,,"Null");
	
КонецФункции // ()

// Изменяет цвет фона области Обл в зависимости от типа показателя, с которым она связана.
//
Процедура ПрименитьНастройкуОформления(Обл, ТипОбласти) Экспорт
	
	Попытка
		Если ТипОбласти = "Наименование" Тогда
			Обл.ЦветФона = ЦветФонаНаименования;
		ИначеЕсли ТипОбласти = "Параметр" Тогда
			Обл.ЦветФона = ЦветФонаОбластиПараметра;
		ИначеЕсли ТипОбласти = "ЗаполняемоеЗначение" Тогда
			Обл.ЦветФона = ЦветФонаОбластиЗаполняемогоПоказателя;
		ИначеЕсли ТипОбласти = "ВычисляемоеЗначение" Тогда
			Обл.ЦветФона = ЦветФонаОбластиВычисляемогоПоказателя;
		КонецЕсли;
	Исключение
		
    КонецПопытки;
	
КонецПроцедуры
