// Изменяет заголовок формы.
&НаСервере
Процедура УстановитьЗаголовокФормы()
	НовыйЗаголовок = НСтр("ru = 'Настройка области %ТипОбласти%'");
	Если ВидПроизвольногоОтчета = 3 Тогда
		НовыйЗаголовок = СтрЗаменить(НовыйЗаголовок, "%ТипОбласти%", НСтр("ru = '(Монитор ключевых показателей)'"));
	ИначеЕсли ВидПроизвольногоОтчета = 5 Тогда
		НовыйЗаголовок = СтрЗаменить(НовыйЗаголовок, "%ТипОбласти%", НСтр("ru = '(Зависимая область)'"));
	ИначеЕсли ВидПроизвольногоОтчета = 6 Тогда
		НовыйЗаголовок = СтрЗаменить(НовыйЗаголовок, "%ТипОбласти%", НСтр("ru = '(Зависимая область)'"));
	ИначеЕсли ВидПроизвольногоОтчета = 2 Тогда
		НовыйЗаголовок = СтрЗаменить(НовыйЗаголовок, "%ТипОбласти%", НСтр("ru = '(Отчет)'"));
	ИначеЕсли ВидПроизвольногоОтчета = 77 Тогда
		НовыйЗаголовок = СтрЗаменить(НовыйЗаголовок, "%ТипОбласти%", НСтр("ru = '(Диаграмма Ганта)'"));	
	ИначеЕсли ВидПроизвольногоОтчета = 7 Тогда
		НовыйЗаголовок = СтрЗаменить(НовыйЗаголовок, "%ТипОбласти%", НСтр("ru = '(Сводная таблица)'"));		
	Иначе
		НовыйЗаголовок = СтрЗаменить(НовыйЗаголовок, "%ТипОбласти%", "");		
	КонецЕсли;
	ЭтаФорма.Заголовок = НовыйЗаголовок;
КонецПроцедуры		// УстановитьЗаголовокФормы()

// Изменяет видимость и доступность элементов формы.
&НаСервере
Процедура УправлениеВидимостью()
	// Реквизиты отображения виджетов.
	ОтображениеВВидеВиджетов = (ОтображениеМонитора = Перечисления.СпособОтображенияМонитораКлючевыхПоказателей.ВВидеВиджетов);
	Элементы.КоличествоКолонокВиджетов.Видимость = ОтображениеВВидеВиджетов;
	Элементы.СкрыватьЛоготипПоказателей.Видимость = ОтображениеВВидеВиджетов;
	// Фиксированные отборы сводной таблицы.
	ЭтоСводнаяТаблица = (ТипЗнч(УниверсальныйОтчет) = Тип("СправочникСсылка.БланкиОтчетов"));
	Элементы.ГруппаОтборЭкзеплярОтчета.Видимость = ЭтоСводнаяТаблица;
	// Реквизиты области диаграммы.
	ОтображениеВВидеДиаграммы = (ОтображениеМонитора = Перечисления.СпособОтображенияМонитораКлючевыхПоказателей.ВВидеДиаграммы);
	Элементы.ТипОбластиДиаграммы.Видимость = ОтображениеВВидеДиаграммы;
	Элементы.ВариантРазмещенияЛегендыДиаграммы2.Видимость = ОтображениеВВидеДиаграммы;
	// Заголовок формы.
	УстановитьЗаголовокФормы();
КонецПроцедуры

// В массиве МассивКолонокВход заменяет наименования аналитики ИсходноеНаименованиеАналитикиВход на 
// НовоеНаименованиеАналитикиВход.
&НаСервереБезКонтекста
Функция ПереименоватьАналитикуВМассиве(МассивКолонокВход, ИсходноеНаименованиеАналитикиВход, НовоеНаименованиеАналитикиВход)
	РезультатФункции = Новый Массив;
	Если СокрЛП(НовоеНаименованиеАналитикиВход) <> "" Тогда
		Для Каждого ТекМассивКолонокВход Из МассивКолонокВход Цикл
			НовыйЭлемент = "";
			Если СокрЛП(ТекМассивКолонокВход) = СокрЛП(ИсходноеНаименованиеАналитикиВход) Тогда
				НовыйЭлемент = НовоеНаименованиеАналитикиВход + " (" + ИсходноеНаименованиеАналитикиВход + ")";
			Иначе
				НовыйЭлемент = ТекМассивКолонокВход;
			КонецЕсли;
			РезультатФункции.Добавить(НовыйЭлемент);
		КонецЦикла;
	Иначе
		РезультатФункции = МассивКолонокВход;			// Передано пустое новое наименование. Не заменяем.
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции
	
// В массиве МассивКолонокВход заменяет представления колонок аналитик согласно видам аналитик.
&НаСервереБезКонтекста
Процедура ЗаменитьНаименованияАналитик(МассивКолонокВход, ПоказательВход)
	Если МассивКолонокВход.Найти("Аналитика1") <> Неопределено Тогда
		Если ПоказательВход.ИсточникЗначенияПериодаСравнения.СпособПолучения = Перечисления.СпособыПолученияОперандов.ВнутренниеДанныеПоказательОтчета Тогда
			ПоказательОтбор = ПоказательВход.ИсточникЗначенияТекущегоПериода.ПоказательОтбор;
			Если ЗначениеЗаполнено(ПоказательОтбор) Тогда
				ГруппаРаскрытия = ПоказательОтбор.ГруппаРаскрытия;
				Если ЗначениеЗаполнено(ГруппаРаскрытия) Тогда
					НаименованиеАналитики1 = ГруппаРаскрытия.ВидАналитики1.Наименование;
					НаименованиеАналитики2 = ГруппаРаскрытия.ВидАналитики2.Наименование;
					НаименованиеАналитики3 = ГруппаРаскрытия.ВидАналитики3.Наименование;
					НаименованиеАналитики4 = ГруппаРаскрытия.ВидАналитики4.Наименование;
					НаименованиеАналитики5 = ГруппаРаскрытия.ВидАналитики5.Наименование;
					НаименованиеАналитики6 = ГруппаРаскрытия.ВидАналитики6.Наименование;
					МассивКолонокВход = ПереименоватьАналитикуВМассиве(МассивКолонокВход, "Аналитика1", НаименованиеАналитики1);
					МассивКолонокВход = ПереименоватьАналитикуВМассиве(МассивКолонокВход, "Аналитика2", НаименованиеАналитики2);
					МассивКолонокВход = ПереименоватьАналитикуВМассиве(МассивКолонокВход, "Аналитика3", НаименованиеАналитики3);
					МассивКолонокВход = ПереименоватьАналитикуВМассиве(МассивКолонокВход, "Аналитика4", НаименованиеАналитики4);
					МассивКолонокВход = ПереименоватьАналитикуВМассиве(МассивКолонокВход, "Аналитика5", НаименованиеАналитики5);
					МассивКолонокВход = ПереименоватьАналитикуВМассиве(МассивКолонокВход, "Аналитика6", НаименованиеАналитики6);
				Иначе
					// Нет группы раскрытия.
				КонецЕсли;
			Иначе
				// Ссылается на пустой показатель отчета. Ничего не делаем.
			КонецЕсли;
		Иначе
			// Данные получаются не из показателя отчета. Не заменяем.
		КонецЕсли;
	Иначе
		// Нет аналитик. Не заменяем ничего в массиве.
	КонецЕсли;
КонецПроцедуры

// Возвращает массив, содержащий представления колонок текущей области.
&НаСервереБезКонтекста
Функция ПолучитьМассивКолонокТекущейОбласти(ИдентификаторОбластиВход)
	// Получим источник данных для проверки.
	РезультатФункции = Новый Массив;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПанелиОтчетовСостав.ИдентификаторОбласти,
		|	ПанелиОтчетовСостав.УниверсальныйОтчет
		|ИЗ
		|	Справочник.ПанелиОтчетов.Состав КАК ПанелиОтчетовСостав
		|ГДЕ
		|	ПанелиОтчетовСостав.ИдентификаторОбласти = &ИдентификаторОбласти";
	Запрос.УстановитьПараметр("ИдентификаторОбласти", ИдентификаторОбластиВход);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Монитор = Справочники.ПроизвольныеОтчеты.ПустаяСсылка();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Монитор = ВыборкаДетальныеЗаписи.УниверсальныйОтчет;
	КонецЦикла;
	Если ЗначениеЗаполнено(Монитор) Тогда
		Если Монитор.ИсточникиДанных.Количество() > 0 Тогда
			ПерваяСтрокаИсточники = Монитор.ИсточникиДанных[0];
			Если ЗначениеЗаполнено(ПерваяСтрокаИсточники.ИсточникДанных) Тогда
				// Заполним параметры по умолчанию.
				ТекущийМесяцПериод = ОбщегоНазначенияУХ.ПолучитьПериодПоДате(ТекущаяДатаСеанса(), Перечисления.Периодичность.Месяц);
				ВалютаРегл = ОбщегоНазначенияПовтИспУХ.ПолучитьВалютуУправленческогоУчета();
				Контекст = Новый Структура;
				Контекст.Вставить("АнализЧувствительности",		 Ложь);
				Контекст.Вставить("БазовыйПериод",				 ТекущийМесяцПериод);
				Контекст.Вставить("БазовыйСценарий",			 Справочники.Сценарии.Факт);
				Контекст.Вставить("ИспользуемаяИБ",				 Справочники.ВнешниеИнформационныеБазы.ПустаяСсылка());
				Контекст.Вставить("Организация",				 Справочники.Организации.ПустаяСсылка());
				Контекст.Вставить("ОсновнаяВалюта",				 ВалютаРегл);
				Контекст.Вставить("ОтборПоПроекту",				 Справочники.Проекты.ПустаяСсылка());
				Контекст.Вставить("ПериодОтчета",				 ТекущийМесяцПериод);
				Контекст.Вставить("ПериодПрогноз",				 ТекущийМесяцПериод);
				Контекст.Вставить("ПериодСравнения",			 ТекущийМесяцПериод);
				Контекст.Вставить("ПлановыйСценарий",			 Справочники.Сценарии.План);
				Контекст.Вставить("Сценарий",					 Справочники.Сценарии.Факт);
				Контекст.Вставить("УправляемыйРежим",			 Истина);
				Контекст.Вставить("ЧтениеНеактуальныхЗаписей",	 Истина);
				// Получим таблицу данных по источнику.
				Показатель = ПерваяСтрокаИсточники.ИсточникДанных;
				АдресТаблицыРасшифровки = Справочники.ПанелиОтчетов.ПолучитьАдресТаблицыРасшифровкиПоАналитикам(Показатель, Контекст, Истина);
				Если ЭтоАдресВременногоХранилища(АдресТаблицыРасшифровки) Тогда
					ТаблицаДанных = ПолучитьИзВременногоХранилища(АдресТаблицыРасшифровки);
					// Вернем массив колонок таблицы.
					Для Каждого ТекКолонки Из ТаблицаДанных.Колонки Цикл
						РезультатФункции.Добавить(ТекКолонки.Имя);
					КонецЦикла;
					ЗаменитьНаименованияАналитик(РезультатФункции, Показатель);
				Иначе
					ТекстСообщения = НСтр("ru = 'Не удалось таблицу расшифровки. Операция отменена.'");
					ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
				КонецЕсли;
			Иначе
				ТекстСообщения = НСтр("ru = 'Не удалось получить показатель монитора ключевых показателей. Операция отменена.'");
				ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
			КонецЕсли;
		Иначе
			ТекстСообщения = НСтр("ru = 'В мониторе ключевых показателей отсутствуют целевые показатели. Операция отменена.'");
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		КонецЕсли;
	Иначе
		ТекстСообщения = НСтр("ru = 'Не удалось получить целевой монитор ключевых показателей для извлечения данных колонок. Операция отменена.'");
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

// Выставляет пустые значения для полей отборов на форме.
&НаСервере
Процедура ОчиститьПоляОтборов()
	ОтборПериодОтчетаНачало		 = Справочники.Периоды.ПустаяСсылка();
	ОтборПериодОтчетаОкончание	 = Справочники.Периоды.ПустаяСсылка();
	ОтборОрганизация			 = Справочники.Организации.ПустаяСсылка();
	ОтборСценарий				 = Справочники.Сценарии.ПустаяСсылка();
	ОтборВалюта					 = Справочники.Валюты.ПустаяСсылка();
	ОтборПроект					 = Справочники.Проекты.ПустаяСсылка();
КонецПроцедуры

// Переносит отборы из структуры данных ДанныеВход в поля на форме.
&НаСервере
Процедура СчитатьОтборыИзДанных(ДанныеВход)
	Если ДанныеВход.Свойство("ФиксированныйОтбор") Тогда
		ОтборСписок = ДанныеВход.ФиксированныйОтбор;
		Если ОтборСписок.Количество() > 0 Тогда
			ОтборКомпоновки = ОтборСписок[0].Значение.Получить();
			Если ОтборКомпоновки <> Неопределено Тогда
				Если ТипЗнч(ОтборКомпоновки) = Тип("Соответствие") Тогда
					ОчиститьПоляОтборов();
				Иначе
					Для Каждого ТекЭлементы Из ОтборКомпоновки.Элементы Цикл
						Если ТекЭлементы.Использование Тогда
							Если ТекЭлементы.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Валюта") Тогда
								ОтборВалюта = ТекЭлементы.ПравоеЗначение;
							ИначеЕсли ТекЭлементы.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПериодОтчетаНачало") Тогда
								ОтборПериодОтчетаНачало = ТекЭлементы.ПравоеЗначение;
							ИначеЕсли ТекЭлементы.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПериодОтчетаОкончание") Тогда
								ОтборПериодОтчетаОкончание = ТекЭлементы.ПравоеЗначение;	
							ИначеЕсли ТекЭлементы.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация") Тогда
								ОтборОрганизация = ТекЭлементы.ПравоеЗначение;	
							ИначеЕсли ТекЭлементы.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Проект") Тогда
								ОтборПроект = ТекЭлементы.ПравоеЗначение;	
							ИначеЕсли ТекЭлементы.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сценарий") Тогда
								ОтборСценарий = ТекЭлементы.ПравоеЗначение;	
							Иначе
								// Неизвестное поле. Выполняем поиск далее.
							КонецЕсли;	
						Иначе
							// Элемент отбора не используется. Выполняем поиск далее.
						КонецЕсли;
					КонецЦикла;	
				КонецЕсли;
			Иначе
				ОчиститьПоляОтборов();
			КонецЕсли;	
		Иначе
			ОчиститьПоляОтборов();
		КонецЕсли;
	Иначе
		ОчиститьПоляОтборов();
	КонецЕсли;
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Данные = Параметры.Данные;
	Если НЕ ЗначениеЗаполнено(Данные) Тогда
		Отказ = истина;
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("СписокРасшифровываемыхОбластей", СписокРасшифровываемыхОбластей);
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Данные);
	ТекЗначение = СписокРасшифровываемыхОбластей.НайтиПоЗначению(РасшифровываемаяОбласть);
	ОбластьВладелец = ?(ТекЗначение = Неопределено, "", ТекЗначение.Представление);

	Если ТекЗначение <> Неопределено Тогда
		ИспользуетсяМКП = ТекЗначение.Пометка;
	КонецЕсли;
	
	Элементы.Группа_ВидЗависимойОбласти.Видимость = ЗависимаяОбласть;
	
	
	Если ЗависимаяОбласть И ВидПроизвольногоОтчета < 5 Тогда
		
		ВидПроизвольногоОтчета = 2; // Ставим по умолчанию - аналитический отчет в виде таблицы для корректного отображения выбора типа зависимой области.
		
	КонецЕсли;
	
	Если ВидПроизвольногоОтчета = 3 Тогда
		Элементы.ГруппаВладелец.Видимость = ЗначениеЗаполнено(РасшифровываемаяОбласть);
		Элементы.Группа_СтраницыНастройки.ТекущаяСтраница = Элементы.МониторКлючевыхПоказателей;
	ИначеЕсли ВидПроизвольногоОтчета = 5 Тогда
		Элементы.ОбластьВладелец.Доступность = Истина;
		Элементы.ОбластьВладелец.ТолькоПросмотр = Ложь;

		
		Если НЕ ЗначениеЗаполнено(РасшифровываемаяОбласть) И Параметры.СписокРасшифровываемыхОбластей.Количество() = 1 Тогда
			
			ОбластьВладелец         = Параметры.СписокРасшифровываемыхОбластей[0].Представление;
			РасшифровываемаяОбласть = Параметры.СписокРасшифровываемыхОбластей[0].Значение;
			ИспользуетсяМКП = Параметры.СписокРасшифровываемыхОбластей[0].Пометка;
			Если ИспользуетсяМКП Тогда
				Область                 = Нстр("ru = 'Динамика показателя'");
			КонецЕсли;
			
		КонецЕсли;
		
		Элементы.Группа_СтраницыНастройки.ТекущаяСтраница = Элементы.ДинамикаПоказателя;
		Элементы.ОтображениеРасшифровки_ДП.СписокВыбора.Добавить(Перечисления.ОтображениеРасшифровки.ВВидеТаблицы);
		Элементы.ОтображениеРасшифровки_ДП.СписокВыбора.Добавить(Перечисления.ОтображениеРасшифровки.ЛинейныйГрафик);
		Элементы.ОтображениеРасшифровки_ДП.СписокВыбора.Добавить(Перечисления.ОтображениеРасшифровки.Гистограмма);
		
		Элементы.ОтображениеРасшифровки_СП.СписокВыбора.Добавить(Перечисления.ОтображениеРасшифровки.ВВидеТаблицы);
		Элементы.ОтображениеРасшифровки_СП.СписокВыбора.Добавить(Перечисления.ОтображениеРасшифровки.КруговаяДиаграмма);
		Элементы.ОтображениеРасшифровки_СП.СписокВыбора.Добавить(Перечисления.ОтображениеРасшифровки.Гистограмма);
		
	ИначеЕсли ВидПроизвольногоОтчета = 6 Тогда
		Элементы.Группа_ВидЗависимойОбласти.Видимость = Истина;
		Элементы.ОбластьВладелец.Доступность = Истина;
		Элементы.ОбластьВладелец.ТолькоПросмотр = Ложь;
		
		Если НЕ ЗначениеЗаполнено(РасшифровываемаяОбласть) И Параметры.СписокРасшифровываемыхОбластей.Количество() = 1 Тогда
			
			ОбластьВладелец         = Параметры.СписокРасшифровываемыхОбластей[0].Представление;
			РасшифровываемаяОбласть = Параметры.СписокРасшифровываемыхОбластей[0].Значение;
			Область                 = Нстр("ru = 'Структура показателя'");
		КонецЕсли;
		
		Элементы.Группа_СтраницыНастройки.ТекущаяСтраница = Элементы.СтруктураПоказателя;
		Элементы.ОтображениеРасшифровки_СП.СписокВыбора.Добавить(Перечисления.ОтображениеРасшифровки.ВВидеТаблицы);
		Элементы.ОтображениеРасшифровки_СП.СписокВыбора.Добавить(Перечисления.ОтображениеРасшифровки.КруговаяДиаграмма);
		Элементы.ОтображениеРасшифровки_СП.СписокВыбора.Добавить(Перечисления.ОтображениеРасшифровки.Гистограмма);
		Элементы.ОтображениеРасшифровки_ДП.СписокВыбора.Добавить(Перечисления.ОтображениеРасшифровки.ВВидеТаблицы);
		Элементы.ОтображениеРасшифровки_ДП.СписокВыбора.Добавить(Перечисления.ОтображениеРасшифровки.ЛинейныйГрафик);
		Элементы.ОтображениеРасшифровки_ДП.СписокВыбора.Добавить(Перечисления.ОтображениеРасшифровки.Гистограмма);
		
	Иначе
		Элементы.ГруппаВладелец.Видимость = ЗначениеЗаполнено(РасшифровываемаяОбласть);
		Элементы.Группа_СтраницыНастройки.ТекущаяСтраница = Элементы.АналитическийОтчет;
		СчитатьОтборыИзДанных(Данные);
	КонецЕсли;
	
	УправлениеВидимостью();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокОсновныхОбластей()
	
	Элементы.ОбластьВладелец.СписокВыбора.Очистить();
	Если СписокРасшифровываемыхОбластей.Количество() > 0 Тогда
		Для Каждого ЭлементСписка Из СписокРасшифровываемыхОбластей Цикл
			Если ВидПроизвольногоОтчета <5 ИЛИ ЭлементСписка.Пометка Тогда
				Элементы.ОбластьВладелец.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление, ЭлементСписка.Пометка);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	
	СтруктураВызова = Новый Структура;
	
	Если ПустаяСтрока(Область) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не задано имя области'"));
		Возврат;
	КонецЕсли;
	
	Если ЗависимаяОбласть И НЕ ЗначениеЗаполнено(РасшифровываемаяОбласть) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбран отчет для расшифровки'"));
		Возврат;
	КонецЕсли;
	
	СтруктураВызова.Вставить("ВариантРазмещенияЛегендыДиаграммы"				, ВариантРазмещенияЛегендыДиаграммы);
	СтруктураВызова.Вставить("НомерАналитики"									, НомерАналитики);
	СтруктураВызова.Вставить("СохраненнаяНастройка"								, СохраненнаяНастройка);
	СтруктураВызова.Вставить("ОтображениеМонитора"								, ОтображениеМонитора);
	СтруктураВызова.Вставить("КоличествоКолонокВиджетов"						, КоличествоКолонокВиджетов);
	СтруктураВызова.Вставить("КоличествоПериодовДляОтображения"					, КоличествоПериодовДляОтображения);
	СтруктураВызова.Вставить("КоличествоСтолбцовДиаграммы"						, КоличествоСтолбцовДиаграммы);
	СтруктураВызова.Вставить("СкрыватьЛоготипПоказателей"						, СкрыватьЛоготипПоказателей);
	СтруктураВызова.Вставить("СкрыватьЗаголовокПринадлежностиЗависимойОбласти"	, СкрыватьЗаголовокПринадлежностиЗависимойОбласти);
	СтруктураВызова.Вставить("СкрыватьЗаголовокПоказателяЗависимойОбласти"		, СкрыватьЗаголовокПоказателяЗависимойОбласти);
	СтруктураВызова.Вставить("Область"											, Область);
	СтруктураВызова.Вставить("ОтображениеРасшифровки"							, ОтображениеРасшифровки);
	СтруктураВызова.Вставить("РасшифровываемаяОбласть"							, РасшифровываемаяОбласть);
	Если ВидПроизвольногоОтчета < 5 Тогда
		СтруктураВызова.Вставить("ВидПроизвольногоОтчета"						, ОпределитьВидПроизвольногоОтчета(УниверсальныйОтчет));
	Иначе
		СтруктураВызова.Вставить("ВидПроизвольногоОтчета"						, ВидПроизвольногоОтчета);
	КонецЕсли;
	НовыйУниверсальныйОтчет = БизнесАнализКлиентУХ.ПолучитьУниверсальныйОтчетПоВидуОтчета(СтруктураВызова.ВидПроизвольногоОтчета);
	Если ЗначениеЗаполнено(НовыйУниверсальныйОтчет) Тогда
		СтруктураВызова.Вставить("УниверсальныйОтчет"							, НовыйУниверсальныйОтчет);
	Иначе	
		СтруктураВызова.Вставить("УниверсальныйОтчет"							, УниверсальныйОтчет);
	КонецЕсли;
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ПериодОтчетаНачало",		 ОтборПериодОтчетаНачало);
	СтруктураОтбора.Вставить("ПериодОтчетаОкончание",	 ОтборПериодОтчетаОкончание);
	СтруктураОтбора.Вставить("Организация",				 ОтборОрганизация);
	СтруктураОтбора.Вставить("Сценарий",				 ОтборСценарий);
	СтруктураОтбора.Вставить("Валюта",					 ОтборВалюта);
	СтруктураОтбора.Вставить("Проект",					 ОтборПроект);
	СтруктураВызова.Вставить("ТипОбластиДиаграммы",		 ТипОбластиДиаграммы);
	СтруктураВызова.Вставить("ФиксированныйОтбор",		 СтруктураОтбора);
	Закрыть(СтруктураВызова);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОпределитьВидПроизвольногоОтчета(ТекущийОтчет)
	
	Возврат Справочники.ПанелиОтчетов.ОпределитьВидПроизвольногоОтчетаДляОтображения(ТекущийОтчет);
	
КонецФункции

&НаКлиенте
Процедура УстановитьВидимостьПолей()
	
	Элементы.ДинамикаПоказателя.Доступность     = ИспользуетсяМКП;
	Элементы.СтруктураПоказателя.Доступность    = ИспользуетсяМКП;
	Элементы.ВидПроизвольногоОтчета.Доступность = ИспользуетсяМКП;
	
	Если Не ИспользуетсяМКП И ВидПроизвольногоОтчета >=5 Тогда
		ВидПроизвольногоОтчета = 2;
		Элементы.Группа_СтраницыНастройки.ТекущаяСтраница = Элементы.АналитическийОтчет;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбластьВладелецНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокВыбора = Новый СписокЗначений;
	
	СтандартнаяОбработка = Ложь;
	Элементы.ОбластьВладелец.СписокВыбора.Очистить();
	Если СписокРасшифровываемыхОбластей.Количество() > 0 Тогда
		Для Каждого ЭлементСписка Из СписокРасшифровываемыхОбластей Цикл
			Если ВидПроизвольногоОтчета <5 ИЛИ ЭлементСписка.Пометка Тогда
				СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление, ЭлементСписка.Пометка);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	РезультатВыбора = Неопределено;

	Оповещение = Новый ОписаниеОповещения("ОбластьВладелецНачалоВыбораЗавершение", ЭтотОбъект);
	ПоказатьВыборИзСписка(Оповещение, СписокВыбора, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбластьВладелецНачалоВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
    
    РезультатВыбора = ВыбранныйЭлемент;
    Если РезультатВыбора <> Неопределено Тогда
        ОбластьВладелец = РезультатВыбора.Представление;
        РасшифровываемаяОбласть = РезультатВыбора.Значение;
        ИспользуетсяМКП = РезультатВыбора.Пометка;
		// Установим наименвоание зависимой области по умолчанию.
		Если СокрЛП(Область) = "" Тогда
			Область = ОбластьВладелец + "_" + НСтр("ru = 'Зависимая'");
		Иначе
			// Наименование уже задано, не изменяем.
		КонецЕсли;
        УстановитьВидимостьПолей();
    КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ВидПроизвольногоОтчетаПриИзменении(Элемент)
	
	Если ВидПроизвольногоОтчета = 5 Тогда
		Элементы.Группа_СтраницыНастройки.ТекущаяСтраница = Элементы.ДинамикаПоказателя;
		
		ЭлементСписка = СписокРасшифровываемыхОбластей.НайтиПоЗначению(РасшифровываемаяОбласть);
		Если ЭлементСписка = Неопределено ИЛИ НЕ ЭлементСписка.Пометка Тогда
			РасшифровываемаяОбласть = Неопределено;
			ОбластьВладелец         = "";
		КонецЕсли;
		
	ИначеЕсли ВидПроизвольногоОтчета = 6 Тогда
		Элементы.Группа_СтраницыНастройки.ТекущаяСтраница = Элементы.СтруктураПоказателя;
		ЭлементСписка = СписокРасшифровываемыхОбластей.НайтиПоЗначению(РасшифровываемаяОбласть);
		Если ЭлементСписка = Неопределено ИЛИ НЕ ЭлементСписка.Пометка Тогда
			РасшифровываемаяОбласть = Неопределено;
			ОбластьВладелец         = "";
		КонецЕсли;
		
	Иначе
		Элементы.Группа_СтраницыНастройки.ТекущаяСтраница = Элементы.АналитическийОтчет;
	КонецЕсли;
	
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимостьПолей();
	
КонецПроцедуры


&НаКлиенте
Процедура СпособОтображенияПриИзменении(Элемент)
	УправлениеВидимостью();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИменаАналитик(Команда)
	Попытка
		// Получим массив наименований колонок.
		МассивКолонок = ПолучитьМассивКолонокТекущейОбласти(РасшифровываемаяОбласть);
		// Заполним полученные наименования в список выбора аналитик.
		Если МассивКолонок.Количество() > 0 Тогда
			Счетчик = 0;
			Для Каждого ТекМассивКолонок Из МассивКолонок Цикл
				Если Счетчик < 10 Тогда				// В списке 10 аналитик.
					ТекЭлементСпискаВыбора = Элементы.Аналитика.СписокВыбора[Счетчик];
					НовоеПредставлениеАналитики = ОбщегоНазначенияКлиентСерверУХ.НаименованиеПоКоду(ТекМассивКолонок);
					ТекЭлементСпискаВыбора.Представление = НовоеПредставлениеАналитики;
				Иначе
					Прервать;						// Достигнут конец списка.
				КонецЕсли;
				Счетчик = Счетчик + 1;
			КонецЦикла;	
		Иначе
			ТекстСообщения = НСтр("ru = 'Не удалось получить колонки для таблицы. Операция отменена.'");
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		КонецЕсли;
	Исключение
		ТекстСообщения = НСтр("ru = 'При заполнении имен аналитик произошла ошибка: %ОписаниеОшибки%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки());
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);		
	КонецПопытки;
КонецПроцедуры