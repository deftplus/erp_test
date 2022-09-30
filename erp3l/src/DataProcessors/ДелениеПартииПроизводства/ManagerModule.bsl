
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняет заданное действие с партией производства (деление, сокращение, увеличение, отмена).
// 
// Параметры:
// 	Параметры - Структура - состав полей аналогичен реквизитам и табличным частям обработки ДелениеПартийПроизводства.
// 	АдресХранилища - Строка - адрес хранилища, в которое будет помещен результат.
//
Процедура ВыполнитьДействиеВФоне(Параметры, АдресХранилища) Экспорт
	
	Результат = Неопределено;
	
	Попытка
		
		Если Параметры.Действие = 0 Тогда // Сократить (увеличить)
			
			РазмерПартии = Документы.ЭтапПроизводства2_2.НовыйРазмерПартии(
				Параметры.Партии[0].КоличествоПартии,
				Параметры.Партии[0].КоличествоУпаковокПартии,
				Параметры.Партии[0].УпаковкаПартии);
			
			Результат = Документы.ЭтапПроизводства2_2.ИзменитьРазмерПартии(
				Параметры,
				РазмерПартии,
				Параметры.Этап,
				НЕ Параметры.Партии[0].ЗаполнитьПоСпецификации,
				Параметры.ИдентификаторФормы);
			
		ИначеЕсли Параметры.Действие = 1 Тогда // Отменить
			
			Результат = Документы.ЭтапПроизводства2_2.ОтменитьПартию(
				Параметры,
				Параметры.Этап,
				Параметры.Партии,
				Параметры.Серии,
				ПараметрыВыпуска(Параметры),
				Параметры.ИдентификаторФормы);
			
		ИначеЕсли Параметры.Действие = 2
			И Параметры.Этап.Пустая() Тогда // Разделить (с начала цепочки)
			
			Партии = Новый Массив;
			Для каждого Строка Из Параметры.Партии Цикл
				Партии.Добавить(
					Документы.ЭтапПроизводства2_2.НовыйРазмерПартии(
						Строка.КоличествоПартии,
						Строка.КоличествоУпаковокПартии,
						Строка.УпаковкаПартии));
			КонецЦикла;
			
			Результат = Документы.ЭтапПроизводства2_2.РазделитьПартию(
				Параметры,
				Партии,
				Параметры.ИдентификаторФормы);
			
		Иначе // Разделить (после этапа) И Продолжить
			
			Результат = Документы.ЭтапПроизводства2_2.РазделитьПартиюПослеЭтапа(
				Параметры,
				Параметры.Этап,
				Параметры.Партии,
				Параметры.Серии,
				ПараметрыВыпуска(Параметры),
				Параметры.ИдентификаторФормы);
			
		КонецЕсли;
		
	Исключение
		
		Сообщения = Новый Массив;
		Сообщения.Добавить(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		Результат = Новый Структура("Отказ, Сообщения", Истина, Сообщения);
		
	КонецПопытки;
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
	
КонецПроцедуры

// Имена реквизитов, от значений которых зависят параметры указания серий
//
//	Возвращаемое значение:
//		Строка - имена реквизитов, перечисленные через запятую.
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе
//
// Параметры:
//  Объект	 - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
// 
// Возвращаемое значение:
//  Структура - Состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	НастройкиПроизводства = ПроизводствоСервер.ИспользованиеСерийВПроизводстве22();
		
	ПараметрыУказанияСерий = НоменклатураКлиентСервер.ПараметрыУказанияСерий();
	ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Обработка.ДелениеПартииПроизводства";
	
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("Назначение");
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("Получатель");
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("Произведено");
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("ДатаПроизводства");
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("ИндексПартии");
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("Подразделение");
	
	ПараметрыУказанияСерий.ИмяПоляСклад = "Получатель";
	ПараметрыУказанияСерий.ИмяТЧТовары = "Партии";
	ПараметрыУказанияСерий.ИмяТЧСерии = "Серии";
	
	ПараметрыУказанияСерий.УчитыватьСебестоимостьПоСериям =
		ПолучитьФункциональнуюОпцию("УчитыватьСебестоимостьПоСериямСклад", Новый Структура())
		ИЛИ НастройкиПроизводства.УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры  =
		ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатурыСклад", Новый Структура())
		ИЛИ НастройкиПроизводства.ИспользоватьСерииНоменклатуры;
	
	ПараметрыУказанияСерий.СерииПриПланированииОтгрузкиУказываютсяВТЧСерии = Истина;
	
	ПараметрыУказанияСерий.СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.ПриемкаПродукцииИзПроизводства);
	
	ПараметрыУказанияСерий.ИменаПолейДополнительные.Добавить("Произведено");
	ПараметрыУказанияСерий.ИменаПолейДополнительные.Добавить("Отменено");
	
	ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта = "ТекущиеДанные";
	
	ПараметрыУказанияСерий.ЭтоНакладная = Истина;
	
	ПараметрыУказанияСерий.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерий");
	ПараметрыУказанияСерий.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерийОтправитель");
	ПараметрыУказанияСерий.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерийПолучатель");
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//	Параметры:
//		ПараметрыУказанияСерий - Структура - состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий
//	Возвращаемое значение:
//		Строка - текст запроса.
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	Возврат
		"ВЫБРАТЬ
		|	Товары.Номенклатура КАК Номенклатура,
		|	Товары.Характеристика КАК Характеристика,
		|	Товары.Назначение КАК Назначение,
		|	Товары.Серия КАК Серия,
		|	Товары.Получатель КАК Получатель,
		|	Товары.Произведено КАК Произведено,
		|	Товары.ДатаПроизводства КАК ДатаПроизводства,
		|	Товары.ИндексПартии КАК ИндексПартии,
		|	Товары.Подразделение КАК Подразделение,
		|	Товары.Количество КАК Количество,
		|	Товары.Отменено КАК Отменено,
		|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий,
		|	Товары.СтатусУказанияСерийОтправитель КАК СтатусУказанияСерийОтправитель,
		|	Товары.СтатусУказанияСерийПолучатель КАК СтатусУказанияСерийПолучатель,
		|	Товары.НомерСтроки КАК НомерСтроки
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	&Товары КАК Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.Номенклатура КАК Номенклатура,
		|	Товары.Характеристика КАК Характеристика,
		|	Товары.Назначение КАК Назначение,
		|	Товары.Серия КАК Серия,
		|	Товары.Получатель КАК Получатель,
		|	Товары.Произведено КАК Произведено,
		|	Товары.ДатаПроизводства КАК ДатаПроизводства,
		|	Товары.ИндексПартии КАК ИндексПартии,
		|	Товары.Подразделение КАК Подразделение,
		|	СУММА(Товары.Количество) КАК Количество
		|ПОМЕСТИТЬ ТоварыДляЗапроса
		|ИЗ
		|	Товары КАК Товары
		|ГДЕ
		|	НЕ Товары.Отменено
		|
		|СГРУППИРОВАТЬ ПО
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	Товары.Назначение,
		|	Товары.Серия,
		|	Товары.Получатель,
		|	Товары.Произведено,
		|	Товары.ДатаПроизводства,
		|	Товары.ИндексПартии,
		|	Товары.Подразделение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Серии.Номенклатура КАК Номенклатура,
		|	Серии.Характеристика КАК Характеристика,
		|	Серии.Назначение КАК Назначение,
		|	Серии.Получатель КАК Получатель,
		|	Серии.Произведено КАК Произведено,
		|	Серии.ДатаПроизводства КАК ДатаПроизводства,
		|	Серии.ИндексПартии КАК ИндексПартии,
		|	Серии.Подразделение КАК Подразделение,
		|	Серии.Количество КАК Количество
		|ПОМЕСТИТЬ Серии
		|ИЗ
		|	&Серии КАК Серии
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Серии.Номенклатура КАК Номенклатура,
		|	Серии.Характеристика КАК Характеристика,
		|	Серии.Назначение КАК Назначение,
		|	Серии.Получатель КАК Получатель,
		|	Серии.Произведено КАК Произведено,
		|	Серии.ДатаПроизводства КАК ДатаПроизводства,
		|	Серии.ИндексПартии КАК ИндексПартии,
		|	Серии.Подразделение КАК Подразделение,
		|	СУММА(Серии.Количество) КАК Количество
		|ПОМЕСТИТЬ СерииДляЗапроса
		|ИЗ
		|	Серии КАК Серии
		|
		|СГРУППИРОВАТЬ ПО
		|	Серии.Номенклатура,
		|	Серии.Характеристика,
		|	Серии.Назначение,
		|	Серии.Получатель,
		|	Серии.Произведено,
		|	Серии.ДатаПроизводства,
		|	Серии.ИндексПартии,
		|	Серии.Подразделение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.НомерСтроки КАК НомерСтроки,
		|	ВЫБОР
		|		КОГДА Товары.Отменено
		|				ИЛИ ВидыНоменклатуры.ПолитикаУчетаСерий ЕСТЬ NULL
		|			ТОГДА 0
		|		КОГДА ВидыНоменклатуры.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
		|			ТОГДА ВЫБОР
		|					КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|						ТОГДА 14
		|					КОГДА НЕ Товары.Произведено
		|						ТОГДА 15
		|					ИНАЧЕ 13
		|				КОНЕЦ
		|		КОГДА ВидыНоменклатуры.ПолитикаУчетаСерий.УказыватьПриПроизводствеПродукции
		|			ТОГДА ВЫБОР
		|					КОГДА ТоварыДляЗапроса.Количество = ЕСТЬNULL(СерииДляЗапроса.Количество, 0)
		|							И ТоварыДляЗапроса.Количество > 0
		|						ТОГДА 2
		|					КОГДА НЕ ТоварыДляЗапроса.Произведено
		|							И ЕСТЬNULL(СерииДляЗапроса.Количество, 0) = 0
		|						ТОГДА 21
		|					ИНАЧЕ 1
		|				КОНЕЦ
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК СтатусУказанияСерий
		|ПОМЕСТИТЬ СтатусыОтправитель
		|ИЗ
		|	Товары КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыДляЗапроса КАК ТоварыДляЗапроса
		|		ПО Товары.Номенклатура = ТоварыДляЗапроса.Номенклатура
		|			И Товары.Характеристика = ТоварыДляЗапроса.Характеристика
		|			И Товары.Назначение = ТоварыДляЗапроса.Назначение
		|			И Товары.Получатель = ТоварыДляЗапроса.Получатель
		|			И Товары.Произведено = ТоварыДляЗапроса.Произведено
		|			И Товары.ДатаПроизводства = ТоварыДляЗапроса.ДатаПроизводства
		|			И Товары.ИндексПартии = ТоварыДляЗапроса.ИндексПартии
		|			И Товары.Подразделение = ТоварыДляЗапроса.Подразделение
		|		ЛЕВОЕ СОЕДИНЕНИЕ СерииДляЗапроса КАК СерииДляЗапроса
		|		ПО Товары.Номенклатура = СерииДляЗапроса.Номенклатура
		|			И Товары.Характеристика = СерииДляЗапроса.Характеристика
		|			И Товары.Назначение = СерииДляЗапроса.Назначение
		|			И Товары.Получатель = СерииДляЗапроса.Получатель
		|			И Товары.Произведено = СерииДляЗапроса.Произведено
		|			И Товары.ДатаПроизводства = СерииДляЗапроса.ДатаПроизводства
		|			И Товары.ИндексПартии = СерииДляЗапроса.ИндексПартии
		|			И Товары.Подразделение = СерииДляЗапроса.Подразделение
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
		|		ПО Товары.Номенклатура = СправочникНоменклатура.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
		|		ПО (СправочникНоменклатура.ВидНоменклатуры = ВидыНоменклатуры.Ссылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.НомерСтроки КАК НомерСтроки,
		|	ВЫБОР
		|		КОГДА Товары.Отменено
		|				ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL
		|				ИЛИ НЕ Склады.ЦеховаяКладовая
		|				ИЛИ Склады.Подразделение <> Товары.Подразделение
		|			ТОГДА 0
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
		|			ТОГДА ВЫБОР
		|					КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|						ТОГДА 14
		|					КОГДА НЕ Товары.Произведено
		|						ТОГДА 15
		|					ИНАЧЕ 13
		|				КОНЕЦ
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтгрузки
		|			ТОГДА ВЫБОР
		|					КОГДА ТоварыДляЗапроса.Количество = ЕСТЬNULL(СерииДляЗапроса.Количество, 0)
		|							И ТоварыДляЗапроса.Количество > 0
		|						ТОГДА 10
		|					КОГДА НЕ ТоварыДляЗапроса.Произведено
		|							И ЕСТЬNULL(СерииДляЗапроса.Количество, 0) = 0
		|						ТОГДА 11
		|					ИНАЧЕ 9
		|				КОНЕЦ
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтбора
		|			ТОГДА ВЫБОР
		|					КОГДА ТоварыДляЗапроса.Количество = ЕСТЬNULL(СерииДляЗапроса.Количество, 0)
		|							И ТоварыДляЗапроса.Количество > 0
		|						ТОГДА 8
		|					КОГДА НЕ ТоварыДляЗапроса.Произведено
		|							И ЕСТЬNULL(СерииДляЗапроса.Количество, 0) = 0
		|						ТОГДА 27
		|					ИНАЧЕ 7
		|				КОНЕЦ
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемке
		|				И ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемкеПродукцииИзПроизводства
		|			ТОГДА ВЫБОР
		|					КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьОстаткиСерий
		|						ТОГДА ВЫБОР
		|								КОГДА ТоварыДляЗапроса.Количество = ЕСТЬNULL(СерииДляЗапроса.Количество, 0)
		|										И ТоварыДляЗапроса.Количество > 0
		|									ТОГДА 4
		|								КОГДА НЕ ТоварыДляЗапроса.Произведено
		|										И ЕСТЬNULL(СерииДляЗапроса.Количество, 0) = 0
		|									ТОГДА 23
		|								ИНАЧЕ 3
		|							КОНЕЦ
		|					ИНАЧЕ ВЫБОР
		|							КОГДА ТоварыДляЗапроса.Количество = ЕСТЬNULL(СерииДляЗапроса.Количество, 0)
		|									И ТоварыДляЗапроса.Количество > 0
		|								ТОГДА 2
		|							КОГДА НЕ ТоварыДляЗапроса.Произведено
		|									И ЕСТЬNULL(СерииДляЗапроса.Количество, 0) = 0
		|								ТОГДА 21
		|							ИНАЧЕ 1
		|						КОНЕЦ
		|				КОНЕЦ
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК СтатусУказанияСерий
		|ПОМЕСТИТЬ СтатусыПолучатель
		|ИЗ
		|	Товары КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыДляЗапроса КАК ТоварыДляЗапроса
		|		ПО Товары.Номенклатура = ТоварыДляЗапроса.Номенклатура
		|			И Товары.Характеристика = ТоварыДляЗапроса.Характеристика
		|			И Товары.Назначение = ТоварыДляЗапроса.Назначение
		|			И Товары.Получатель = ТоварыДляЗапроса.Получатель
		|			И Товары.Произведено = ТоварыДляЗапроса.Произведено
		|			И Товары.ДатаПроизводства = ТоварыДляЗапроса.ДатаПроизводства
		|			И Товары.ИндексПартии = ТоварыДляЗапроса.ИндексПартии
		|			И Товары.Подразделение = ТоварыДляЗапроса.Подразделение
		|		ЛЕВОЕ СОЕДИНЕНИЕ СерииДляЗапроса КАК СерииДляЗапроса
		|		ПО Товары.Номенклатура = СерииДляЗапроса.Номенклатура
		|			И Товары.Характеристика = СерииДляЗапроса.Характеристика
		|			И Товары.Назначение = СерииДляЗапроса.Назначение
		|			И Товары.Получатель = СерииДляЗапроса.Получатель
		|			И Товары.Произведено = СерииДляЗапроса.Произведено
		|			И Товары.ДатаПроизводства = СерииДляЗапроса.ДатаПроизводства
		|			И Товары.ИндексПартии = СерииДляЗапроса.ИндексПартии
		|			И Товары.Подразделение = СерииДляЗапроса.Подразделение
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
		|		ПО Товары.Получатель = Склады.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
		|		ПО Товары.Номенклатура = СправочникНоменклатура.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
		|		ПО Товары.Получатель = ПолитикиУчетаСерий.Склад
		|			И (СправочникНоменклатура.ВидНоменклатуры = ПолитикиУчетаСерий.Ссылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.НомерСтроки КАК НомерСтроки,
		|	СтатусыОтправитель.СтатусУказанияСерий КАК СтатусУказанияСерийОтправитель,
		|	СтатусыПолучатель.СтатусУказанияСерий КАК СтатусУказанияСерийПолучатель,
		|	ВЫБОР
		|		КОГДА СтатусыОтправитель.СтатусУказанияСерий В (13, 14, 15)
		|			ТОГДА СтатусыОтправитель.СтатусУказанияСерий
		|		КОГДА СтатусыПолучатель.СтатусУказанияСерий <> 0
		|			ТОГДА СтатусыПолучатель.СтатусУказанияСерий
		|		ИНАЧЕ СтатусыОтправитель.СтатусУказанияСерий
		|	КОНЕЦ КАК СтатусУказанияСерий
		|ИЗ
		|	Товары КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ СтатусыОтправитель КАК СтатусыОтправитель
		|		ПО Товары.НомерСтроки = СтатусыОтправитель.НомерСтроки
		|		ЛЕВОЕ СОЕДИНЕНИЕ СтатусыПолучатель КАК СтатусыПолучатель
		|		ПО Товары.НомерСтроки = СтатусыПолучатель.НомерСтроки
		|ГДЕ
		|	(СтатусыОтправитель.СтатусУказанияСерий <> Товары.СтатусУказанияСерийОтправитель
		|			ИЛИ СтатусыПолучатель.СтатусУказанияСерий <> Товары.СтатусУказанияСерийПолучатель
		|			ИЛИ ВЫБОР
		|				КОГДА СтатусыОтправитель.СтатусУказанияСерий В (13, 14, 15)
		|					ТОГДА СтатусыОтправитель.СтатусУказанияСерий
		|				КОГДА СтатусыПолучатель.СтатусУказанияСерий <> 0
		|					ТОГДА СтатусыПолучатель.СтатусУказанияСерий
		|				ИНАЧЕ СтатусыОтправитель.СтатусУказанияСерий
		|			КОНЕЦ <> Товары.СтатусУказанияСерий)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Товары.НомерСтроки";
	
КонецФункции

// Возвращает параметры распределения затрат на выходные изделия.
//
// Параметры:
//  СпособРаспределенияЗатратНаВыходныеИзделия	 - ПеречислениеСсылка.СпособыРаспределенияЗатратНаВыходныеИзделия - способ распределения затрат на выходные изделия.
// 
// Возвращаемое значение:
//  Структура - параметры, уточняющие особенности распределения затрат на выходные изделия.
//
Функция ПараметрыРаспределенияЗатрат(СпособРаспределенияЗатратНаВыходныеИзделия) Экспорт
	
	ПараметрыРаспределенияЗатрат = ПроизводствоКлиентСервер.ПараметрыРаспределенияЗатратНаВыходныеИзделия(
		"Партии",
		СпособРаспределенияЗатратНаВыходныеИзделия);
	
	ПараметрыРаспределенияЗатрат.РассчитыватьПолеДоляСтоимостиПроцент = Истина;
	ПараметрыРаспределенияЗатрат.РассчитыватьПризнакЕстьОшибкиЗаполнения = Истина;
	ПараметрыРаспределенияЗатрат.РассчитыватьПризнакДоляСтоимостиОбязательна = Истина;
	
	ПараметрыРаспределенияЗатрат.ПоляСвязи = "Номенклатура,Характеристика,ИндексПартии";
	
	Возврат ПараметрыРаспределенияЗатрат;
	
КонецФункции

Функция ПараметрыРедактированияЭтапа() Экспорт

	ПараметрыРедактированияЭтапа = УправлениеПроизводством.ПараметрыРедактированияЭтапа("Обработка");
	Возврат ПараметрыРедактированияЭтапа;

КонецФункции

// Возвращает параметры выбора статей в документе.
// 
// Возвращаемое значение:
//  Массив, Структура - См. ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики
//
Функция ПараметрыВыбораСтатейИАналитик(Объект) Экспорт
	
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	
	ПараметрыВыбора.ПутьКДанным         = "Объект.Партии";
	ПараметрыВыбора.Статья              = "СтатьяРасходов";
	ПараметрыВыбора.ТипСтатьи           = "ТипСтатьи";
	ПараметрыВыбора.ЗначениеПоУмолчанию = ПланыВидовХарактеристик.СтатьиРасходов.ПустаяСсылка();
	
	ПараметрыВыбора.ДоступностьПоОперации = НЕ
		(Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПроизводствоИзДавальческогоСырья);
	
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов   = "АналитикаРасходов";
	УправлениеПроизводством.ЗаполнитьОтборСтатейРасходов(ПараметрыВыбора.ОтборСтатейРасходов);
	
	ПараметрыВыбора.ВыборСтатьиАктивовПассивов = Истина;
	ПараметрыВыбора.АналитикаАктивовПассивов   = "АналитикаАктивовПассивов";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("ПартииСтатьяРасходов");
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("СтатьяРасходов");
	
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("ПартииАналитикаРасходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("АналитикаРасходов");
	
	ПараметрыВыбора.ЭлементыФормы.АналитикаАктивовПассивов.Добавить("ПартииАналитикаАктивовПассивов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаАктивовПассивов.Добавить("АналитикаАктивовПассивов");
	
	ПараметрыВыбора.УсловияДоступностиСтатьиВСтроках.Вставить("СписатьНаРасходы", Истина);
	
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПараметрыВыбора);
	
КонецФункции

// Возвращает параметры настройки счетов учета в документе.
//  
// Возвращаемое значение:
//  Массив из см. НастройкаСчетовУчетаСервер.ПараметрыНастройки
//
Функция ПараметрыНастройкиСчетовУчета() Экспорт
	
	ПараметрыНастройки = НастройкаСчетовУчетаСервер.ПараметрыНастройки();
	ПараметрыНастройки.ДоступностьПоОперации	= Истина;
	ПараметрыНастройки.ПутьКДанным				= "Объект.Партии";
	ПараметрыНастройки.ТипСтатьи				= "ТипСтатьи";
	
	ПараметрыНастройки.ЭлементыФормы.Добавить("ПартииПредставлениеОтраженияОперации");
	
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПараметрыНастройки);
	
КонецФункции

// Инициализирует параметры, обслуживающие выбор назначений в формах обработки.
// 
//  Возвращаемое значение:
//  Структура - структура параметров, см. Справочники.Назначения.МакетФормыВыбораНазначений().
//
Функция МакетФормыВыбораНазначений() Экспорт
	
	МакетФормы = Справочники.Назначения.МакетФормыВыбораНазначений();
	
	ШаблонНазначения = Справочники.Назначения.ДобавитьШаблонНазначений(МакетФормы, "Объект.Партии.Назначение");
	ШаблонНазначения.НаправлениеДеятельности  = "Объект.НаправлениеДеятельности";
	ШаблонНазначения.ТипыНазначений.Очистить();
	ШаблонНазначения.ТипыНазначений.Добавить(Перечисления.ТипыНазначений.Собственное);
	ШаблонНазначения.ВидимыеОтборыНаФорме.Вставить("НаправлениеДеятельности", НСтр("ru = 'Только назначения направления деятельности ""%1""';
																					|en = 'The ""%1"" line of business assignments only'"));
	
	// Потребности в выпущенной продукции на складе.
	ОписаниеКолонок = Справочники.Назначения.ДобавитьОписаниеКолонок(МакетФормы, "ОбеспечениеЗаказов", Истина, "Объект.Партии.Назначение");
	ОписаниеКолонок.Колонки.НайтиПоЗначению("Потребность").Пометка = Истина;
	ОписаниеКолонок.УсловиеИспользования = "Объект.Партии.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)";
	
	ОписаниеКолонок.ПутиКДанным.Номенклатура     = "Объект.Партии.Номенклатура";
	ОписаниеКолонок.ПутиКДанным.Характеристика   = "Объект.Партии.Характеристика";
	ОписаниеКолонок.ПутиКДанным.Склад            = "Объект.Партии.Получатель";
	ОписаниеКолонок.ПутиКДанным.Регистратор      = "Объект.Этап";
	
	// Потребности в производимых работах в подразделении-получателе.
	ОписаниеКолонок = Справочники.Назначения.ДобавитьОписаниеКолонок(МакетФормы, "ОбеспечениеЗаказовРаботами", Истина, "Объект.Партии.Назначение");
	ОписаниеКолонок.Колонки.НайтиПоЗначению("Потребность").Пометка = Истина;
	ОписаниеКолонок.УсловиеИспользования = "Объект.Партии.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)";
	
	ОписаниеКолонок.ПутиКДанным.Номенклатура     = "Объект.Партии.Номенклатура";
	ОписаниеКолонок.ПутиКДанным.Характеристика   = "Объект.Партии.Характеристика";
	ОписаниеКолонок.ПутиКДанным.Подразделение    = "Объект.Партии.Получатель";
	ОписаниеКолонок.ПутиКДанным.Регистратор      = "Объект.Этап";
	
	// Потребности в продукции на всех складах.
	ОписаниеКолонок = Справочники.Назначения.ДобавитьОписаниеКолонок(МакетФормы, "ОбеспечениеЗаказовВсеСклады", Истина, "Объект.Партии.Назначение");
	ОписаниеКолонок.Колонки.НайтиПоЗначению("Потребность").Пометка = Истина;
	ОписаниеКолонок.УсловиеИспользования = "Объект.Партии.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)";
	
	ОписаниеКолонок.ПутиКДанным.Номенклатура     = "Объект.Партии.Номенклатура";
	ОписаниеКолонок.ПутиКДанным.Характеристика   = "Объект.Партии.Характеристика";
	ОписаниеКолонок.ПутиКДанным.Регистратор      = "Объект.Этап";
	
	Возврат МакетФормы;
	
КонецФункции

// Имена реквизитов, от значений которых зависят параметры выбора спецификаций.
//
//	Возвращаемое значение:
//		Строка - имена реквизитов, перечисленные через запятую.
//
Функция ИменаРеквизитовДляЗаполненияПараметровВыбораСпецификаций() Экспорт
	
	Возврат "ТипПроизводственногоПроцесса";
	
КонецФункции

// Возвращает параметры выбора спецификаций для формирования партий.
//
// Параметры:
//   Объект - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров выбора спецификаций.
//
// Возвращаемое значение:
//   Структура - Структура, переопределяющая умолчания, заданные в функции УправлениеДаннымиОбИзделияхКлиентСервер.ПараметрыВыбораСпецификаций().
//
Функция ПараметрыВыбораСпецификаций(Объект) Экспорт
	
	ПараметрыВыбораСпецификаций = УправлениеДаннымиОбИзделияхКлиентСервер.ПараметрыВыбораСпецификаций();
	ПараметрыВыбораСпецификаций.ДоступныеТипы.Добавить(Объект.ТипПроизводственногоПроцесса);
	ПараметрыВыбораСпецификаций.ДоступныеСтатусы.Добавить(Перечисления.СтатусыСпецификаций.Действует);
	
	СвязиПараметровВыбора = Новый Структура(УправлениеДаннымиОбИзделияхКлиентСервер.ПоляСтруктурыДанныхОбИзделииДляВыбораСпецификации());
	СвязиПараметровВыбора.Номенклатура   = "Объект.ОсновноеИзделиеНоменклатура";
	СвязиПараметровВыбора.Характеристика = "Объект.ОсновноеИзделиеХарактеристика";
	СвязиПараметровВыбора.ПодразделениеДиспетчер  = "Объект.ПодразделениеДиспетчер";
	
	ПараметрыВыбораСпецификаций.СвязиПараметровВыбора.Вставить("Элементы.Партии.ТекущиеДанные.ПродолжитьСпецификация", СвязиПараметровВыбора);
	ПараметрыВыбораСпецификаций.СвязиПараметровВыбора.Вставить("Объект.Партии.ПродолжитьСпецификация", СвязиПараметровВыбора);
	
	Возврат ПараметрыВыбораСпецификаций;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыВыпуска(Параметры)
	
	ПараметрыВыпуска = Новый Структура;
	ПараметрыВыпуска.Вставить("СоздатьЭтап", Параметры.СоздатьЭтап);
	ПараметрыВыпуска.Вставить(
		"СпособРаспределенияЗатратНаВыходныеИзделия",
		Параметры.СпособРаспределенияЗатратНаВыходныеИзделия);
		
	Возврат ПараметрыВыпуска;
	
КонецФункции

#КонецОбласти

#КонецЕсли
