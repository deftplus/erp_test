#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция ОпределитьВидПроизвольногоОтчетаДляОтображения(ТекущийОтчет) Экспорт
	
	Если ТипЗнч(ТекущийОтчет) = Тип("СправочникСсылка.ПроизвольныеОтчеты") Тогда
		Если ТекущийОтчет.ВидПроизвольногоОтчета = 1 Тогда
			Возврат 3;
		ИНачеЕсли ТекущийОтчет.ПредставлениеЭлементаОтчета = Перечисления.ПредставленияЭлементовОтчетов.Диаграмма Тогда
			Возврат 4;
		Иначе
			Возврат 2;
		КонецЕсли;
		
	ИначеЕсли ТекущийОтчет = Перечисления.ВидыРасшифровокПоказателяМКП.ДинамикаПоказателя Тогда
		Возврат 5;
	ИначеЕсли ТекущийОтчет = Перечисления.ВидыРасшифровокПоказателяМКП.СтруктураПоказателя Тогда
		Возврат 6;
	КонецЕсли;
	
КонецФункции

// Возвращает начальный период внешних данных Контекст показателя монитора 
// ключевых показателей в зависимости от операнда ИмяОперанда.
Функция ОпределитьНачальныйПериодКонтекстаПоказателя(Контекст, ИмяОперанда = "")
	РезультатФункции = Контекст.БазовыйПериод;	
	Если ИмяОперанда = "ФактическоеЗначениеТекущегоПериода" Тогда
		РезультатФункции = Контекст.БазовыйПериод;
	ИначеЕсли ИмяОперанда = "ФактическоеЗначениеПредыдущегоПериода" Тогда	
		РезультатФункции = Контекст.ПериодСравнения;	
	ИначеЕсли ИмяОперанда = "ПлановоеЗначение" Тогда	
		РезультатФункции = Контекст.БазовыйПериод;	
	Иначе
		РезультатФункции = Контекст.БазовыйПериод;	
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

// Возвращает для показателя Показатель монитора ключевых показателей массив, в котором
// содержатся периоды отображения динамики изменения значений показателя со начальными
// параметрами Контекст по операнду ИмяОперанда. Когда параметр ГраницыИзКонтекстаВход,
// то периоды будут принадлежать периодам отбора из Контекст.
Функция ПолучитьМассивПериодовДинамики(Показатель, Контекст, ИмяОперанда = "", ГраницыИзКонтекстаВход = Ложь) Экспорт
	РезультатФункции = Новый Массив;
	Если ЗначениеЗаполнено(Показатель.ПеродичностьОтображенияДинамики) Тогда
		ПериодичностьДинамикиРабочая = Показатель.ПеродичностьОтображенияДинамики;
	Иначе	
		ПериодичностьДинамикиРабочая = Перечисления.Периодичность.Месяц;	// По умолчанию выводим помесячно.
	КонецЕсли;
	Если ГраницыИзКонтекстаВход Тогда
		// Определим начальные и конечные даты периодов.
		ПериодТекущийМесяц = ОбщегоНазначенияУХ.глОтносительныйПериодПоДате(ТекущаяДатаСеанса(), Перечисления.Периодичность.Месяц, 0);
		ПериодНачало = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Контекст, "ПериодНачало", ПериодТекущийМесяц);
		ПериодОкончание = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Контекст, "ПериодОкончание", ПериодТекущийМесяц);
		ДатаНачалаГраницы = ПериодНачало.ДатаНачала;
		ДатаОкончанияГраницы = ПериодОкончание.ДатаОкончания;
		// Получим периоды, лежащие между начальными и конечными датами.
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	Периоды.Ссылка КАК Ссылка,
		|	Периоды.ДатаНачала КАК ДатаНачала,
		|	Периоды.ДатаОкончания КАК ДатаОкончания,
		|	Периоды.Периодичность КАК Периодичность
		|ИЗ
		|	Справочник.Периоды КАК Периоды
		|ГДЕ
		|	Периоды.ДатаНачала >= &ДатаНачала
		|	И Периоды.ДатаОкончания <= &ДатаОкончания
		|	И Периоды.Периодичность = &Периодичность
		|	И НЕ Периоды.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачала";
		Запрос.УстановитьПараметр("ДатаНачала", ДатаНачалаГраницы);
		Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончанияГраницы);
		Запрос.УстановитьПараметр("Периодичность", ПериодичностьДинамикиРабочая);
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			РезультатФункции.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
	Иначе
		// Определение начального периода.
		НачальныйПериод = ОпределитьНачальныйПериодКонтекстаПоказателя(Контекст, ИмяОперанда);
		// Определение настроек отображения динамики.
		Если ЗначениеЗаполнено(Показатель.ГлубинаОтображенияДинамики) Тогда
			ГлубинаДинамикиРабочая = Показатель.ГлубинаОтображенияДинамики;
		Иначе	
			ГлубинаДинамикиРабочая = 5;			// По умолчанию 5 периодов.
		КонецЕсли;
		// Сформируем массив периодам по полученным настройкам.
		НачальнаяДата = НачальныйПериод.ДатаНачала;
		Для Счетчик = 1 По ГлубинаДинамикиРабочая Цикл
			НовыйПериод = ОбщегоНазначенияУХ.глОтносительныйПериодПоДате(НачальнаяДата, ПериодичностьДинамикиРабочая, -Счетчик);
			Если ЗначениеЗаполнено(НовыйПериод) Тогда
				РезультатФункции.Добавить(НовыйПериод);
			Иначе
				// Нет такого перирода. Не выводим данные.
			КонецЕсли;
		КонецЦикла;
		РезультатФункции.Добавить(НачальныйПериод);
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции		// ПолучитьМассивПериодовДинамики()

// Возвращает таблицу значений предыдущего периода относительно текущего ТекущийПериодВход 
// для показателя ПоказательВход по контексту КонтекстВход.
Функция ПолучитьТаблицуПредыдущегоПериода(ПоказательВход, ТекущийПериодВход, КонтекстВход)
	НовыйКонтекст = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(КонтекстВход);
	ПериодичностьРабочая = Перечисления.Периодичность.Месяц;
	Если ЗначениеЗаполнено(ПоказательВход.ПеродичностьОтображенияДинамики) Тогда
		ПериодичностьРабочая = ПоказательВход.ПеродичностьОтображенияДинамики;
	Иначе
		Если ЗначениеЗаполнено(КонтекстВход.ПериодОтчета) Тогда
			Если ЗначениеЗаполнено(КонтекстВход.ПериодОтчета.Периодичность) Тогда
				ПериодичностьРабочая = КонтекстВход.ПериодОтчета.Периодичность;
			Иначе
				ПериодичностьРабочая = Перечисления.Периодичность.Месяц;
			КонецЕсли;
		Иначе
			ПериодичностьРабочая = Перечисления.Периодичность.Месяц;
		КонецЕсли;
	КонецЕсли;
	НовыйПериод = ОбщегоНазначенияУХ.глОтносительныйПериодПоДате(ТекущийПериодВход.ДатаНачала, ПериодичностьРабочая, -1);
	НовыйКонтекст.БазовыйПериод = НовыйПериод;
	СтруктураТаблицы = ТиповыеОтчетыУХ.ПолучитьСтруктуруОтветаТаблицПоказателяМКП(ПоказательВход, НовыйКонтекст, "ФактическоеЗначениеТекущегоПериода");		
	Возврат СтруктураТаблицы.БАЗА_Таблица;
КонецФункции

// Возвращает копию таблицы ИсходнаяТаблицаВход, в которую добавлены колонки по ключам
// структуры СтруктураВход.
Функция ДобавитьНедостающиеКолонкиИзСтруктуры(ИсходнаяТаблицаВход, СтруктураВход)
	РезультатФункции = ИсходнаяТаблицаВход.Скопировать();
	Для Каждого ТекСтруктураВход Из СтруктураВход Цикл
		Если РезультатФункции.Колонки.Найти(ТекСтруктураВход.Ключ) = Неопределено Тогда
			НаименованиеКолонки = ТекСтруктураВход.Ключ;
			РезультатФункции.Колонки.Добавить(НаименованиеКолонки);
		Иначе
			Продолжить;			// Уже есть такая колонка.
		КонецЕсли;
	КонецЦикла;
	Возврат РезультатФункции;
КонецФункции

// Возвращает копию таблицы ИсходнаяТаблицаВход, отобранную по 
// структуре СтруктураДополнительногоОтбораВход.
Функция УстановитьДополнительныйОтбор(ИсходнаяТаблицаВход, СтруктураДополнительногоОтбораВход)
	РезультатФункции = ИсходнаяТаблицаВход.СкопироватьКолонки();
	//СтруктураОтбораРабочая = ВыбратьСтруктуруОтбораПоКолонкамТаблицы(ИсходнаяТаблицаВход, СтруктураДополнительногоОтбораВход);
	ТаблицаРабочая = ДобавитьНедостающиеКолонкиИзСтруктуры(ИсходнаяТаблицаВход, СтруктураДополнительногоОтбораВход);
	Если СтруктураДополнительногоОтбораВход.Количество() > 0 Тогда
		РезультатФункции = ТаблицаРабочая.СкопироватьКолонки();
		НайденныеСтроки = ТаблицаРабочая.НайтиСтроки(СтруктураДополнительногоОтбораВход);
		Для Каждого ТекНайденныеСтроки Из НайденныеСтроки Цикл
			НоваяСтрока = РезультатФункции.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекНайденныеСтроки);
		КонецЦикла;
	Иначе
		РезультатФункции = ТаблицаРабочая.Скопировать();		// Пустой отбор. Просто вернём копию таблицы.
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

// Возвращает адрес таблицы динамики измнения показателя Показатель по 
// параметрам Контекст и для значения ИмяОперанда. Когда задана структура
// СтруктураДополнительногоОтбораВход - будет наложен соответственный отбор.
Функция ПолучитьАдресТаблицыДинамики(Показатель, Контекст, ИмяОперанда = "", СтруктураДополнительногоОтбораВход = Неопределено) Экспорт
	// Инициализация.
	РезультатФункции = "";
	ТаблицаДинамики = Новый ТаблицаЗначений;
	ТаблицаДинамики.Колонки.Добавить("Период");
	ТаблицаДинамики.Колонки.Добавить("Значение");
	ТаблицаДинамики.Колонки.Добавить("ЗначениеПлан");
	ТаблицаДинамики.Колонки.Добавить("ОтклонениеПред");
	ТаблицаДинамики.Колонки.Добавить("ОтклонениеПлан");
	НовыйКонтекст = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(Контекст); 
	СпособРасчета = Показатель.СпособРасчетаИтоговогоЗначения;
	// Получение массива периодов.
	МассивПериодов = ПолучитьМассивПериодовДинамики(Показатель, Контекст, ИмяОперанда, Истина);
	Для Каждого ТекМассивПериодов Из МассивПериодов Цикл
		// Получение исходных таблиц по периодам.
		НовыйКонтекст.БазовыйПериод = ТекМассивПериодов;
		СтруктураТаблицы = БизнесАнализСерверУХ.ПолучитьСтруктуруОтветаТаблицПоказателяМКП(Показатель, НовыйКонтекст, "");	
		ТаблицаБаза			 = СтруктураТаблицы.БАЗА_Таблица;
		ТаблицаПлан			 = СтруктураТаблицы.План_Таблица;
		ТаблицаСравнение	 = СтруктураТаблицы.Сравнение_Таблица;
		ТаблицаПред			 = ПолучитьТаблицуПредыдущегоПериода(Показатель, ТекМассивПериодов, НовыйКонтекст);
		// Наложим дополнительный отбор.
		Если ЗначениеЗаполнено(СтруктураДополнительногоОтбораВход) Тогда
			ТаблицаБаза			 = УстановитьДополнительныйОтбор(ТаблицаБаза, СтруктураДополнительногоОтбораВход);
			ТаблицаПлан			 = УстановитьДополнительныйОтбор(ТаблицаПлан, СтруктураДополнительногоОтбораВход);
			ТаблицаСравнение	 = УстановитьДополнительныйОтбор(ТаблицаСравнение, СтруктураДополнительногоОтбораВход);
			ТаблицаПред			 = УстановитьДополнительныйОтбор(ТаблицаПред, СтруктураДополнительногоОтбораВход);
		Иначе
			// Не задан дополнительный отбор. Оставляем как есть.
		КонецЕсли;
		// Получим итоговые данные по таблицам.
		ИтогЗначение	 = БизнесАнализСерверУХ.РассчитатьИтогПоТаблицеПоказателя(ТаблицаБаза, СпособРасчета);
		ИтогПлан		 = БизнесАнализСерверУХ.РассчитатьИтогПоТаблицеПоказателя(ТаблицаПлан, СпособРасчета);
		ИтогСравненение	 = БизнесАнализСерверУХ.РассчитатьИтогПоТаблицеПоказателя(ТаблицаСравнение, СпособРасчета);
		ИтогПред		 = БизнесАнализСерверУХ.РассчитатьИтогПоТаблицеПоказателя(ТаблицаПред, СпособРасчета);
		// Добавление данных в таблицу динамики.
		НоваяСтрока = ТаблицаДинамики.Добавить();
		НоваяСтрока.Период			 = ТекМассивПериодов;
		НоваяСтрока.Значение		 = ИтогЗначение;
		НоваяСтрока.ЗначениеПлан	 = ИтогПлан;
		НоваяСтрока.ОтклонениеПред	 = ИтогЗначение - ИтогПред;
		НоваяСтрока.ОтклонениеПлан	 = ИтогЗначение - ИтогПлан;
	КонецЦикла;
	// Свертка и вывод результата.
	ТаблицаДинамики.Свернуть("Период", "Значение, ЗначениеПлан, ОтклонениеПред, ОтклонениеПлан");
	РезультатФункции = ПоместитьВоВременноеХранилище(ТаблицаДинамики);
	Возврат РезультатФункции;
КонецФункции

// Возвращает адрес таблицы расшифровки по аналитикам показателя Показатель по 
// параметрам Контекст. Когда параметр ИсключатьНезначимыеВход - Истина, в таблицу
// не будут включены служебные поля.
Функция ПолучитьАдресТаблицыРасшифровкиПоАналитикам(Показатель, Контекст, ИсключатьНезначимыеВход = Ложь) Экспорт
	// Инициализация.
	РезультатФункции = "";
	СтруктураТаблицы = БизнесАнализСерверУХ.ПолучитьСтруктуруОтветаТаблицПоказателяМКП(Показатель, Контекст);	
	ТаблицаБаза			 = СтруктураТаблицы.БАЗА_Таблица;	
	ТаблицаПлан			 = СтруктураТаблицы.План_Таблица;	
	ТаблицаСравнение	 = СтруктураТаблицы.Сравнение_Таблица;
	// Отберем колонки таблицы сравнения.
	МассивКолонок = Новый Массив;
	МассивКолонок = ОбщегоНазначенияСерверУХ.ДобавитьВМассивКолонкиТаблицы(МассивКолонок, ТаблицаБаза);   		// Приведем аналитики всех таблиц к аналитикам базовой таблицы.
	МассивКолонок = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивКолонок);
	// Сформируем таблицу расшифровки.
	ТаблицаРезультат = Новый ТаблицаЗначений;
	Для Каждого ТекМассивКолонок Из МассивКолонок Цикл
		ТаблицаРезультат.Колонки.Добавить(ТекМассивКолонок);
	КонецЦикла;
	ТаблицаРезультат.Колонки.Добавить("ЗначениеБаза");
	ТаблицаРезультат.Колонки.Добавить("ЗначениеПлан");
	ТаблицаРезультат.Колонки.Добавить("ЗначениеСравнение");
	// Заполним таблицу расшифровки.
	Для Каждого ТекТаблицаБаза Из ТаблицаБаза Цикл
		НоваяСтрока = ТаблицаРезультат.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекТаблицаБаза);
		НоваяСтрока.ЗначениеБаза		 = ТекТаблицаБаза.Значение;
		НоваяСтрока.ЗначениеСравнение	 = 0;
		НоваяСтрока.ЗначениеПлан		 = 0;
	КонецЦикла;
	Для Каждого ТекТаблицаСравнение Из ТаблицаСравнение Цикл
		НоваяСтрока = ТаблицаРезультат.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекТаблицаСравнение);
		НоваяСтрока.ЗначениеБаза		 = 0;
		НоваяСтрока.ЗначениеСравнение	 = ТекТаблицаСравнение.Значение;
		НоваяСтрока.ЗначениеПлан		 = 0;
	КонецЦикла;
	Для Каждого ТекТаблицаПлан Из ТаблицаПлан Цикл
		НоваяСтрока = ТаблицаРезультат.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекТаблицаПлан);
		НоваяСтрока.ЗначениеБаза		 = 0;
		НоваяСтрока.ЗначениеСравнение	 = 0;
		НоваяСтрока.ЗначениеПлан		 = ТекТаблицаПлан.Значение;
	КонецЦикла;
	// Свернём таблицу расшифровки.
	СтрокаСвертки = "";
	МассивИсключения = Новый Массив;
	МассивИсключения.Добавить("Значение");
	Если ИсключатьНезначимыеВход Тогда
		МассивИсключения.Добавить("ИтогПоПоказателю");
		МассивИсключения.Добавить("Показатель");
	Иначе
		// Не исключаем данные поля.
	КонецЕсли;
	Для Каждого ТекМассивКолонок Из МассивКолонок Цикл
		КолонкаЯвляетсяИсключением = (МассивИсключения.Найти(СокрЛП(ТекМассивКолонок)) <> Неопределено);
		Если НЕ КолонкаЯвляетсяИсключением Тогда
			СтрокаСвертки = СтрокаСвертки + ТекМассивКолонок + ",";
		Иначе
			Продолжить;		// Не добавляем эти поля, т.к. они не несут смысловой нагрузки.
		КонецЕсли;
	КонецЦикла;
	ТаблицаРезультат.Свернуть(СтрокаСвертки, "ЗначениеБаза,ЗначениеПлан,ЗначениеСравнение");
	РезультатФункции = ПоместитьВоВременноеХранилище(ТаблицаРезультат);
	Возврат РезультатФункции;
КонецФункции
#КонецЕсли
