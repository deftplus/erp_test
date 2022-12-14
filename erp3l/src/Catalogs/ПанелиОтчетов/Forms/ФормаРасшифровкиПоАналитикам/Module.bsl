// Вычисляет и выводит значения в подвале таблицы.
&НаСервере
Процедура ОбновитьТекстПодвала()
	// Получение данных для заполнения.
	ИтогЗначениеБаза			 = ТаблицаРасшифровки.Итог("ЗначениеБаза");
	ИтогЗначениеСравнение		 = ТаблицаРасшифровки.Итог("ЗначениеСравнение");
	ИтогРазницаБазаСравнение	 = ТаблицаРасшифровки.Итог("РазницаБазаСравнение");
	ИтогЗначениеПлан			 = ТаблицаРасшифровки.Итог("ЗначениеПлан");
	ИтогРазницаБазаПлан			 = ТаблицаРасшифровки.Итог("РазницаБазаПлан");
	Если ИтогЗначениеСравнение <> 0 Тогда
		ИтогПроцентПред = 100 * ИтогРазницаБазаСравнение / ИтогЗначениеСравнение;
	Иначе
		ИтогПроцентПред = 0;
	КонецЕсли;
	Если ИтогЗначениеПлан <> 0 Тогда
		ИтогПроцентПлан			 = 100 * ИтогРазницаБазаПлан / ИтогЗначениеПлан;
		ИтогПроцентВыполнения	 = ИтогЗначениеБаза / ИтогЗначениеПлан * 100;
	Иначе
		ИтогПроцентПлан			 = 0;
		ИтогПроцентВыполнения	 = 100;
	КонецЕсли;
	// Вывод данных в подвал.
	Элементы.ТаблицаРасшифровкиЗначениеБаза.ТекстПодвала			 = Формат(ИтогЗначениеБаза, "ЧДЦ=2");
	Элементы.ТаблицаРасшифровкиЗначениеСравнение.ТекстПодвала		 = Формат(ИтогЗначениеСравнение, "ЧДЦ=2");
	Элементы.ТаблицаРасшифровкиРазницаБазаСравнение.ТекстПодвала	 = Формат(ИтогРазницаБазаСравнение, "ЧДЦ=2");
	Элементы.ТаблицаРасшифровкиПроцентПред.ТекстПодвала				 = Формат(ИтогПроцентПред, "ЧДЦ=1");
	Элементы.ТаблицаРасшифровкиЗначениеПлан.ТекстПодвала			 = Формат(ИтогЗначениеПлан, "ЧДЦ=2");
	Элементы.ТаблицаРасшифровкиПроцентПлан.ТекстПодвала				 = Формат(ИтогПроцентПлан, "ЧДЦ=1");
	Элементы.ТаблицаРасшифровкиРазницаБазаПлан.ТекстПодвала			 = Формат(ИтогРазницаБазаПлан, "ЧДЦ=2");
	Элементы.ТаблицаРасшифровкиПроцентВыполнения.ТекстПодвала		 = Формат(ИтогПроцентВыполнения, "ЧДЦ=1");	
КонецПроцедуры

// Определяет наличие заполненных данных в строках таблицы ИсходнаяТаблицаВход
// по колнке ИмяКолонкиВход
&НаСервереБезКонтекста
Функция ЕстьДанныеВКолонкеАналитики(ИсходнаяТаблицаВход, ИмяКолонкиВход)
	РезультатФункции = Ложь;
	Попытка
		Для Каждого ТекИсходнаяТаблицаВход Из ИсходнаяТаблицаВход Цикл
			Если ЗначениеЗаполнено(ТекИсходнаяТаблицаВход[ИмяКолонкиВход]) Тогда
				РезультатФункции = Истина;
			Иначе
				// Нет данных. Пропускаем строку.
			КонецЕсли;
		КонецЦикла;	
	Исключение
		ТекстСообщения = НСтр("ru = 'При анализе наличия данных в колоке ""%ИмяКолонки%"" произошли ошибки: %ОписаниеОшибки%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяКолонки%", Строка(ИмяКолонкиВход));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки());
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
	КонецПопытки;
	Возврат РезультатФункции;
КонецФункции		 // ЕстьДанныеВКолонкеАналитики()	

// По переданной таблице во временном хранилище реквизита АдресТаблицы
// добавляет недостающие колонки на форму и заполняет таблицу.
&НаСервере
Процедура ЗаполнитьТаблицуРасшифровки()
	Если ЭтоАдресВременногоХранилища(АдресТаблицы) Тогда
		ИсходнаяТаблица = ПолучитьИзВременногоХранилища(АдресТаблицы);
		ТаблицаРасшифровки.Очистить();
		СписокАналитик.Очистить();
		МассивРеквизитов = Новый Массив;
		СтруктураКолонок = Новый Структура;
		// Добавление колонок-реквизитов формы.
		Для Каждого ТекКолонки Из ИсходнаяТаблица.Колонки Цикл
			ТекИмяКолонки = ТекКолонки.Имя;
			ЭтоЗначениеБаза = (СокрЛП(ТекИмяКолонки) = "ЗначениеБаза");
			ЭтоЗначениеПлан = (СокрЛП(ТекИмяКолонки) = "ЗначениеПлан");
			ЭтоЗначениеСравнение = (СокрЛП(ТекИмяКолонки) = "ЗначениеСравнение");
			Если (НЕ ЭтоЗначениеБаза) И (НЕ ЭтоЗначениеПлан) И (НЕ ЭтоЗначениеСравнение) Тогда
				НаименованиеКолонки = ОбщегоНазначенияКлиентСерверУХ.НаименованиеПоКоду(ТекИмяКолонки);
				РеквизитКолонка = Новый РеквизитФормы(ТекИмяКолонки, ТекКолонки.ТипЗначения, "ТаблицаРасшифровки", НаименованиеКолонки);
				МассивРеквизитов.Добавить(РеквизитКолонка);
				СтруктураКолонок.Вставить(ТекИмяКолонки, РеквизитКолонка);
				СписокАналитик.Добавить(ТекИмяКолонки);
				НоваяСтрокаТаблицаАналитик = ТаблицаВыбранныхАналитик.Добавить();
				ЕстьДанныеПоКолонке = ЕстьДанныеВКолонкеАналитики(ИсходнаяТаблица, ТекИмяКолонки);
				НоваяСтрокаТаблицаАналитик.Использование = ЕстьДанныеПоКолонке;
				НоваяСтрокаТаблицаАналитик.ИмяАналитики = ТекИмяКолонки;
				НоваяСтрокаТаблицаАналитик.ПредставлениеАналитики = НаименованиеКолонки;
			Иначе
				// Такие колонки уже добавлены.
			КонецЕсли;
		КонецЦикла;
		ИзменитьРеквизиты(МассивРеквизитов);
		// Добавление элементов формы.
		Для Каждого ТекКолонки Из ИсходнаяТаблица.Колонки Цикл
			ЭтоЗначениеБаза = (СокрЛП(ТекКолонки.Имя) = "ЗначениеБаза");
			ЭтоЗначениеПлан = (СокрЛП(ТекКолонки.Имя) = "ЗначениеПлан");
			ЭтоЗначениеСравнение = (СокрЛП(ТекКолонки.Имя) = "ЗначениеСравнение");
			Если (НЕ ЭтоЗначениеБаза) И (НЕ ЭтоЗначениеПлан) И (НЕ ЭтоЗначениеСравнение) Тогда
				НовыйЭлемент = Элементы.Добавить("ТаблицаРасшифровки" + ТекКолонки.Имя, Тип("ПолеФормы"), Элементы.ТаблицаРасшифровки);
				НовыйЭлемент.Вид			 = ВидПоляФормы.ПолеВвода;
				НовыйЭлемент.ПутьКДанным	 = "ТаблицаРасшифровки." + ТекКолонки.Имя;
				НовыйЭлемент.ТолькоПросмотр	 = Истина;
				Элементы.Переместить(НовыйЭлемент, Элементы.ТаблицаРасшифровки, Элементы.ТаблицаРасшифровкиСостояние);
			Иначе
				// Такие колонки уже добавлены.
			КонецЕсли;
		КонецЦикла;
		// Заполнение таблицы.
		ИсходнаяТаблица.Сортировать("ЗначениеБаза убыв");
		Для Каждого ТекИсходнаяТаблица Из ИсходнаяТаблица Цикл
			НоваяСтрока = ТаблицаРасшифровки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекИсходнаяТаблица);
			ЗаполнитьРазницуВСтроке(НоваяСтрока, ТекИсходнаяТаблица);
		КонецЦикла;
		АдресТаблицы = ПоместитьВоВременноеХранилище(ИсходнаяТаблица, УникальныйИдентификатор);
		// Вывод данных подвала.
		ОбновитьТекстПодвала();
	Иначе
		ТекстСообщения = НСтр("ru = 'Не удалось получить исходную таблицу расшифровки.'");
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
	КонецЕсли;
КонецПроцедуры

// Заполняет в строке НоваяСтрока данные по отклонениям от плана и 
// сравнительного периода исходя из данных ИсходныеДанныеВход.
&НаСервере
Процедура ЗаполнитьРазницуВСтроке(НоваяСтрока, ИсходныеДанныеВход)
	// Инициализация.
	ТекБаза			 = ИсходныеДанныеВход.ЗначениеБаза;
	ТекПлан			 = ИсходныеДанныеВход.ЗначениеПлан;
	ТекСравнение	 = ИсходныеДанныеВход.ЗначениеСравнение;
	// Абсолютное отклонение.
	НоваяСтрока.РазницаБазаПлан			 = (ТекБаза - ТекПлан);
	НоваяСтрока.РазницаБазаСравнение	 = (ТекБаза - ТекСравнение);
	// Относительное отклонение.
	Если ТекСравнение <> 0 Тогда
		НоваяСтрока.ПроцентСравнение	 = НоваяСтрока.РазницаБазаСравнение / ТекСравнение * 100;
	Иначе
		НоваяСтрока.ПроцентСравнение	 = 0;
	КонецЕсли;
	Если ТекПлан <> 0 Тогда
		НоваяСтрока.ПроцентПлан			 = НоваяСтрока.РазницаБазаПлан / ТекПлан * 100;
		Если Показатель.ТрактовкаПоложительногоОтклонения Тогда
			НоваяСтрока.ПроцентВыполнения	 = ТекБаза / ТекПлан * 100;
		Иначе
			НоваяСтрока.ПроцентВыполнения	 = 200 - ТекБаза / ТекПлан * 100;
		КонецЕсли;
	Иначе
		НоваяСтрока.ПроцентПлан			 = 0;
		НоваяСтрока.ПроцентВыполнения	 = 100;
	КонецЕсли;
	// Картинки строк.
	Если ЗначениеЗаполнено(Показатель) Тогда
		ПорогЗначимостиТренда = Показатель.ПорогЗначимостиТренда;
		ДопустимоеОтклонениеОтПлана = Показатель.ДопустимоеОтклонениеОтПлана;
		ПредельноеОтклонениеОтПлана = Показатель.ПредельноеОтклонениеОтПлана;
		// Динамика.
		Если ТиповыеОтчетыУХ.Абс(НоваяСтрока.ПроцентСравнение) > ПорогЗначимостиТренда Тогда
			Если НоваяСтрока.ПроцентСравнение > 0 Тогда
				НоваяСтрока.Динамика = "▲";
				НоваяСтрока.ИндексДинамики = 1;			// см. условное оформление формы.
			Иначе
				НоваяСтрока.Динамика = "▼";
				НоваяСтрока.ИндексДинамики = 2;
			КонецЕсли;
		Иначе
			НоваяСтрока.Динамика = "►";
			НоваяСтрока.ИндексДинамики = 3;
		КонецЕсли;
		// Состояние.
		Если Показатель.ИспользоватьКоридорЗначений Тогда
			Если БизнесАнализКлиентСерверУХ.ЗначениеПоказателяВКоридореЗначений(Показатель, ТекБаза) Тогда
				НоваяСтрока.Состояние = "●";
				НоваяСтрока.ИндексСостояния = 1;
			Иначе
				НоваяСтрока.Состояние = "■";
				НоваяСтрока.ИндексСостояния = 3;
			КонецЕсли;
		Иначе	
			// Перевернём тренд для отрицательной трактовки.
			Если Показатель.ТрактовкаПоложительногоОтклонения Тогда
				ОтклонениеПриведенное = НоваяСтрока.ПроцентПлан;
			Иначе	
				ОтклонениеПриведенное = - НоваяСтрока.ПроцентПлан;
			КонецЕсли;
			// Обработаем отклонение.
			Если ОтклонениеПриведенное > - ДопустимоеОтклонениеОтПлана Тогда
				НоваяСтрока.Состояние = "●";
				НоваяСтрока.ИндексСостояния = 1;
			ИначеЕсли (ОтклонениеПриведенное <=- ДопустимоеОтклонениеОтПлана) И (ОтклонениеПриведенное > -ПредельноеОтклонениеОтПлана)  Тогда
				НоваяСтрока.Состояние = "◊";
				НоваяСтрока.ИндексСостояния = 2;
			Иначе
				НоваяСтрока.Состояние = "■";
				НоваяСтрока.ИндексСостояния = 3;
			КонецЕсли;
		КонецЕсли;
	Иначе	
		// Показатель не задан. Нельзя определить уровень отклонения. Не выводим картинки. 
	КонецЕсли;
КонецПроцедуры		// ЗаполнитьРазницуВСтроке()

// Возвращает адрес таблицы динамики показателя ПоказательВход по входным данным 
// КонтекстВход, дополнительному отбору СтруктураАналитикСтроки и операнду ИмяОперанда.
&НаСервере
Функция ПолучитьАдресТаблицыДинамики(ПоказательВход, КонтекстВход, СтруктураАналитикСтроки, ИмяОперанда = "")
	РезультатФункции = Справочники.ПанелиОтчетов.ПолучитьАдресТаблицыДинамики(ПоказательВход, КонтекстВход, ИмяОперанда, СтруктураАналитикСтроки);
	Возврат РезультатФункции;
КонецФункции

// Формирует и устанавливает заголовок форме, исходя из данных отчета.
&НаСервере
Процедура СформироватьЗаголовокФормы()
	Если ЗначениеЗаполнено(Показатель.ЕдиницаИзмерения) Тогда
		ЗаголовокФормы = НСтр("ru = '%Показатель% (%ЕдницаИзмерения%) - %ПериодОтчета%'");
		ЗаголовокФормы = СтрЗаменить(ЗаголовокФормы, "%Показатель%", Строка(Показатель));
		ЗаголовокФормы = СтрЗаменить(ЗаголовокФормы, "%ПериодОтчета%", Строка(ПериодОтчета));
		ЗаголовокФормы = СтрЗаменить(ЗаголовокФормы, "%ЕдницаИзмерения%", Строка(Показатель.ЕдиницаИзмерения.КраткоеНаименование));
	Иначе
		ЗаголовокФормы = НСтр("ru = '%Показатель% - %ПериодОтчета%'");
		ЗаголовокФормы = СтрЗаменить(ЗаголовокФормы, "%Показатель%", Строка(Показатель));
		ЗаголовокФормы = СтрЗаменить(ЗаголовокФормы, "%ПериодОтчета%", Строка(ПериодОтчета));
	КонецЕсли;
	ЭтаФорма.Заголовок = ЗаголовокФормы;
КонецПроцедуры		// СформироватьЗаголовокФормы()

// Возвращает массив, содержащий имена невыбранных пользователем колонок аналитик.
&НаСервере
Функция ПолучитьМассивНевыбранныхКолонок()
	РезультатФункции = Новый Массив;
	// Получим невыбранные аналитики.
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Использование", Ложь);
	НайденныеСтроки = ТаблицаВыбранныхАналитик.НайтиСтроки(СтруктураПоиска);
	// Сформируем массив исключений.
	Для Каждого ТекНайденныеСтроки Из НайденныеСтроки Цикл
		РезультатФункции.Добавить(ТекНайденныеСтроки.ИмяАналитики);
	КонецЦикла;
	Возврат РезультатФункции;	
КонецФункции

// Вовзращает копию таблицы ТаблицаВход, свёрнутой по выбранным пользователем
// аналитикам.
&НаСервере
Функция СвернутьПоВыбраннымАналитикам(ТаблицаВход)
	РезультатФункции = ТаблицаВход.Скопировать();
	Попытка
		// Сформируем массив исключений.
		МассивИсключения = ПолучитьМассивНевыбранныхКолонок();	
		// Сформируем массив ресурсов.
		МассивРесурсов = Новый Массив;
		МассивРесурсов.Добавить("ЗначениеБаза");
		МассивРесурсов.Добавить("ЗначениеПлан");
		МассивРесурсов.Добавить("ЗначениеСравнение");
		// Сформируем строки для свёртки и суммирования.
		СтрокаСвертки = "";
		СтрокаСуммирования = "";
		Для Каждого ТекКолонки Из РезультатФункции.Колонки Цикл
			ИмяТекущейКолонки = СокрЛП(ТекКолонки.Имя);
			ЕстьСредиИсключений = (МассивИсключения.Найти(ИмяТекущейКолонки) <> Неопределено);
			ЕстьСредиРесурсов = (МассивРесурсов.Найти(ИмяТекущейКолонки) <> Неопределено);
			Если (НЕ ЕстьСредиИсключений) И (НЕ ЕстьСредиРесурсов) Тогда
				СтрокаСвертки = СтрокаСвертки + ИмяТекущейКолонки + ",";
			Иначе
				// Не добавляем в строку свёртки.
			КонецЕсли;
			Если ЕстьСредиРесурсов Тогда
				СтрокаСуммирования = СтрокаСуммирования + ИмяТекущейКолонки + ",";
			Иначе
				// Не добавляем в строку суммирования.
			КонецЕсли;
		КонецЦикла;
		Если СокрЛП(СтрокаСвертки) <> "" Тогда
			СтрокаСвертки = Лев(СтрокаСвертки, СтрДлина(СтрокаСвертки) - 1);		// Уберём последний разделитель.
		Иначе
			// Пустая строка свёртки. Не требуется убирать разделитель.
		КонецЕсли;
		Если СокрЛП(СтрокаСуммирования) <> "" Тогда
			СтрокаСуммирования = Лев(СтрокаСуммирования, СтрДлина(СтрокаСуммирования) - 1);		// Уберём последний разделитель.
		Иначе
			// Пустая строка суммирования. Не требуется убирать разделитель.
		КонецЕсли;
		// Непосредственная свёртка таблицы и возврат результата.
		РезультатФункции.Свернуть(СтрокаСвертки, СтрокаСуммирования);
	Исключение
		ТекстСообщения = НСтр("ru = 'Произошла ошибка при свёртке исходной таблицы: %ОписаниеОшибки%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки());
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
	КонецПопытки;
	Возврат РезультатФункции;
КонецФункции

// Отображает/скрывает неиспользуемые колонки аналитик в таблице расшифровки
// на форме.
&НаСервере
Процедура СкрытьНеиспользуемыеКолонкиАналитик()
	МассивНевыбранныхКолонок = ПолучитьМассивНевыбранныхКолонок();
	Для Каждого ТекСписокАналитик Из СписокАналитик Цикл
		ИмяЭлемента = "ТаблицаРасшифровки" + ТекСписокАналитик.Значение;
		НайденныйЭлемент = Элементы.Найти(ИмяЭлемента);
		Если НайденныйЭлемент <> Неопределено Тогда
			АналитикаВыбрана = (МассивНевыбранныхКолонок.Найти(ТекСписокАналитик.Значение) = Неопределено);
			НайденныйЭлемент.Видимость = АналитикаВыбрана;
		Иначе
			ТекстСообщения = НСтр("ru = 'Не удалось получить элемент %ИмяЭлемента%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяЭлемента%", Строка(ИмяЭлемента));
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Серверная обёртка команды ОбновитьДанные.
&НаСервере
Процедура ОбновитьДанные_Сервер()
	Если ЭтоАдресВременногоХранилища(АдресТаблицы) Тогда
		ИсходнаяТаблица = ПолучитьИзВременногоХранилища(АдресТаблицы);
		Если ТипЗнч(ИсходнаяТаблица) = Тип("ТаблицаЗначений") Тогда
			ТаблицаСвертка = СвернутьПоВыбраннымАналитикам(ИсходнаяТаблица);
			ТаблицаСвертка.Сортировать("ЗначениеБаза убыв");
			ТаблицаРасшифровки.Очистить();
			Для Каждого ТекТаблицаСвертка Из ТаблицаСвертка Цикл
				НоваяСтрока = ТаблицаРасшифровки.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекТаблицаСвертка);
				ЗаполнитьРазницуВСтроке(НоваяСтрока, ТекТаблицаСвертка);
			КонецЦикла;
			СкрытьНеиспользуемыеКолонкиАналитик();
		Иначе
			ТекстСообщения = НСтр("ru = 'Неизвестный вариант исходной таблицы расшифровки: %Таблица%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Таблица%", Строка(ИсходнаяТаблица));
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		КонецЕсли;
	Иначе
		ТекстСообщения = НСтр("ru = 'Не удалось получить исходную таблицу расшифровки.'");
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
	КонецЕсли;
	УправлениеДоступностью();
КонецПроцедуры		// ОбновитьДанные_Сервер()

// Управляет отображением и доступностью элементов на форме
&НаСервере
Процедура УправлениеДоступностью()
	МассивНевыбранныхКолонок = ПолучитьМассивНевыбранныхКолонок();
	ЕстьНевыбранныеАналитики = (МассивНевыбранныхКолонок.Количество() > 0);
	Элементы.ГруппаУстановленаГруппировка.Видимость = ЕстьНевыбранныеАналитики;
КонецПроцедуры

// Выполняет расшифровку выбранной строке по динамике изменения показателя
// для поля с имененем ИмяПоляВход.
&НаКлиенте
Процедура РасшифроватьПоДинамике(ИмяПоляВход)
	ТекДанные = Элементы.ТаблицаРасшифровки.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		// Определим поля для каждого варианта расшифровки динамики.
		МассивПолейТекущегоПериода = Новый Массив;
		МассивПолейТекущегоПериода.Добавить("ТаблицаРасшифровкиЗначениеБаза");
		МассивПолейСравнительногоПериода = Новый Массив;
		МассивПолейСравнительногоПериода.Добавить("ТаблицаРасшифровкиЗначениеСравнение");
		МассивПолейСравнительногоПериода.Добавить("ТаблицаРасшифровкиРазницаБазаСравнение");
		МассивПолейСравнительногоПериода.Добавить("ТаблицаРасшифровкиПроцентПред");
		МассивПолейПлановогоПериода = Новый Массив;
		МассивПолейПлановогоПериода.Добавить("ТаблицаРасшифровкиЗначениеПлан");
		МассивПолейПлановогоПериода.Добавить("ТаблицаРасшифровкиРазницаБазаПлан");
		МассивПолейПлановогоПериода.Добавить("ТаблицаРасшифровкиПроцентПлан");
		МассивПолейПлановогоПериода.Добавить("ТаблицаРасшифровкиПроцентВыполнения");
		// Выберем необходимый операнд в зависимости от выбранного поля таблицы.
		ВыбранноеИмяОперанда = "";
		Если МассивПолейТекущегоПериода.Найти(ИмяПоляВход) <> Неопределено Тогда
			ВыбранноеИмяОперанда = "ФактическоеЗначениеТекущегоПериода";
		ИначеЕсли МассивПолейСравнительногоПериода.Найти(ИмяПоляВход) <> Неопределено Тогда
			ВыбранноеИмяОперанда = "ФактическоеЗначениеПредыдущегоПериода";
		ИначеЕсли МассивПолейПлановогоПериода.Найти(ИмяПоляВход) <> Неопределено Тогда
			ВыбранноеИмяОперанда = "ПлановоеЗначение";
		Иначе
			ВыбранноеИмяОперанда = "";  		// Неизвестный вариант расшифровки. Оставляем все поля.
		КонецЕсли;
		// Непосредственно отобразим расшифровку динамики.
		СтруктураАналитикСтроки = ПолучитьСтруктуруАналитикПоСтроке(ТекДанные);
		Если СтруктураКонтекста.Количество() > 0 Тогда
			АдресДинамики = ПолучитьАдресТаблицыДинамики(Показатель, СтруктураКонтекста, СтруктураАналитикСтроки, ВыбранноеИмяОперанда);
			ПараметрыФормы = Новый Структура();
			ПараметрыФормы.Вставить("АдресТаблицы", АдресДинамики);
			ПараметрыФормы.Вставить("Показатель", Показатель);
			ПараметрыФормы.Вставить("ИмяОперанда", ВыбранноеИмяОперанда);
			ПараметрыФормы.Вставить("АдресКонтекста", ПоместитьВоВременноеХранилище(СтруктураКонтекста));
			ОткрытьФорму("Справочник.ПанелиОтчетов.Форма.ФормаДинамикиПоказателя", ПараметрыФормы);	
		Иначе
			ТекстСообщения = НСтр("ru = 'Не удалось получить контекст для дополнительной расшифровки. Операция отменена.'");
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		КонецЕсли;
	Иначе
		// Строка не выбрана. Не расшифровываем.
	КонецЕсли;
КонецПроцедуры

// Возвращает структуру, содержащую дополнительные аналитики отбора 
// по строке таблицы СтрокаДанныхВход.
&НаКлиенте
Функция ПолучитьСтруктуруАналитикПоСтроке(СтрокаДанныхВход)
	РезультатФункции = Новый Структура;
	Для Каждого ТекСписокАналитик Из СписокАналитик Цикл
		ЗначениеАналитики = СтрокаДанныхВход[ТекСписокАналитик.Значение];
		РезультатФункции.Вставить(ТекСписокАналитик, ЗначениеАналитики);
	КонецЦикла;
	Возврат РезультатФункции;
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Получение исходных данных.
	Показатель = Параметры.Показатель;
	АдресТаблицы = Параметры.АдресТаблицы;
	ПериодОтчета = Параметры.ПериодОтчета;
	АдресКонтекста = Параметры.АдресКонтекста;
	Если ЭтоАдресВременногоХранилища(АдресКонтекста) Тогда
		СтруктураКонтекста = ПолучитьИзВременногоХранилища(АдресКонтекста);
	Иначе
		СтруктураКонтекста = Новый Структура;
	КонецЕсли;
	// Настройка формы.
	СформироватьЗаголовокФормы();
	// Вывод таблицы.
	ЗаполнитьТаблицуРасшифровки();
	ОбновитьДанные_Сервер();
	УправлениеДоступностью();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРасшифровкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	РасшифроватьПоДинамике(Поле.Имя);
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаДинамика(Команда)
	ИмяТекущегоЭлемента = Элементы.ТаблицаРасшифровки.ТекущийЭлемент.Имя;
	РасшифроватьПоДинамике(ИмяТекущегоЭлемента);
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаОсновная(Команда)
	Операнд = ОбщегоНазначенияУХ.ПолучитьЗначениеРеквизита(Показатель, "ИсточникЗначенияТекущегоПериода");
	СпособПолучения = ОбщегоНазначенияУХ.ПолучитьЗначениеРеквизита(Операнд, "СпособПолучения");
	Если СпособПолучения = ПредопределенноеЗначение("Перечисление.СпособыПолученияОперандов.ВнутренниеДанныеПоказательОтчета") Тогда
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("ОтборПоВалюте", СтруктураКонтекста.ОсновнаяВалюта);
		СтруктураОтбора.Вставить("ОтборПоОрганизации", СтруктураКонтекста.Организация);
		СтруктураОтбора.Вставить("ПериодПланированияОтборОкончание", ПериодОтчета);
		СтруктураОтбора.Вставить("ОтборПоСценарию", СтруктураКонтекста.Сценарий);
		СтруктураОтбора.Вставить("ОтборПоПроекту", СтруктураКонтекста.ОтборПоПроекту);
		АдресХранилищаПеременныхДляРасчета = БизнесАнализВызовСервераУХ.ПолучитьАдресОбъектаРасчетаОперанда(Показатель, Операнд, СтруктураКонтекста, СтруктураОтбора, УникальныйИдентификатор);
		СтруктураОтбора = Новый Структура;
		СтруктураПараметров = Новый Структура;
		ПоказательОтчета = ОбщегоНазначенияУХ.ПолучитьЗначениеРеквизита(Операнд, "ПоказательОтбор");
		СтруктураПараметров.Вставить("ПоказательОтчета", ПоказательОтчета);
		СтруктураПараметров.Вставить("АдресХранилищаПеременныхДляРасчета", АдресХранилищаПеременныхДляРасчета);
		СтруктураПараметров.Вставить("мТекущаяВалюта", СтруктураКонтекста.ОсновнаяВалюта);
		СтруктураПараметров.Вставить("СтруктураОтбора", СтруктураОтбора);
		ОткрытьФорму("Обработка.РасшифровкаРассчитанныхЗначений.Форма",СтруктураПараметров);
	Иначе
		ТекущаяИБ = ПредопределенноеЗначение("Справочник.ВнешниеИнформационныеБазы.ПустаяСсылка");
		ОтборПоВалюте = СтруктураКонтекста.ОсновнаяВалюта;
		Операнд = ОбщегоНазначенияУХ.ПолучитьЗначениеРеквизита(Показатель, "ИсточникЗначенияТекущегоПериода");
		ТиповыеОтчеты_КлиентУХ.ОсновнаяРасшифровка(СтруктураКонтекста, Операнд, Показатель, ТекущаяИБ, ОтборПоВалюте, ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАналитику(Команда)
	ТекДанные = Элементы.ТаблицаРасшифровки.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		Если Элементы.ТаблицаРасшифровки.ТекущийЭлемент <> Неопределено Тогда
			ТекКолонка = Элементы.ТаблицаРасшифровки.ТекущийЭлемент.Имя;
			ТекКолонка = СтрЗаменить(ТекКолонка, "ТаблицаРасшифровки", "");
			ЕстьКолонкаАналитики = ОбщегоназначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекДанные, ТекКолонка);
			Если (СокрЛП(ТекКолонка) <> "") И (ЕстьКолонкаАналитики) Тогда
				ДанныеАналитики = ТекДанные[ТекКолонка];
				Если ЗначениеЗаполнено(ДанныеАналитики) Тогда
					Попытка
						ПоказатьЗначение(, ДанныеАналитики);
					Исключение
						ТекстСообщения = НСтр("ru = 'Не удалось открыть значение %ДанныеАналитики% аналитики %Колонка% по причине: %ОписаниеОшибки%'");
						ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДанныеАналитики%", Строка(ДанныеАналитики));
						ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Колонка%", Строка(ТекКолонка));
						ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки());
						ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
					КонецПопытки;
				Иначе
					ТекстСообщения = НСтр("ru = 'Пустое значение аналитики %ИмяАналитики%. Операция отменена.'");
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяАналитики%", Строка(ТекКолонка));
					ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
				КонецЕсли;
			Иначе
				// Нет такой колонки среди расшифровки. Ничего не делаем.
			КонецЕсли;
		Иначе
			ТекстСообщения = НСтр("ru = 'Элемент не выбран. Операция отменена.'");
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		КонецЕсли;
	Иначе
		ТекстСообщения = НСтр("ru = 'Элемент не выбран. Операция отменена.'");
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтображениеВыбранныхАналитик(Команда)
	Элементы.ТаблицаРасшифровкиОтображениеВыбранныхАналитик.Пометка = Не Элементы.ТаблицаРасшифровкиОтображениеВыбранныхАналитик.Пометка;
	Элементы.ГруппаПравая.Видимость = Элементы.ТаблицаРасшифровкиОтображениеВыбранныхАналитик.Пометка;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанные(Команда)
	ОбновитьДанные_Сервер();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажкиВыбранныеАналитики(Команда)
	Для Каждого ТекТаблицаВыбранныхАналитик Из ТаблицаВыбранныхАналитик Цикл
		ТекТаблицаВыбранныхАналитик.Использование = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажкиВыбранныеАналитики(Команда)
	Для Каждого ТекТаблицаВыбранныхАналитик Из ТаблицаВыбранныхАналитик Цикл
		ТекТаблицаВыбранныхАналитик.Использование = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьГруппировку(Команда)
	Для Каждого ТекТаблицаВыбранныхАналитик Из ТаблицаВыбранныхАналитик Цикл
		ТекТаблицаВыбранныхАналитик.Использование = Истина;
	КонецЦикла;
	ОбновитьДанные_Сервер();
КонецПроцедуры
