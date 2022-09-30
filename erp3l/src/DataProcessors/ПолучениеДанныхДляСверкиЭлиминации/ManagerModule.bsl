#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
///////////////////////////////////////////////////////////////////////////////
// Функции предназначены для получения данных сверки и элиминации из базы
// минуя интерфейс источников данных.
///////////////////////////////////////////////////////////////////////////////


#Область ВнешниеФункцииМодуля


// Возвращает таблицу раскрытия показателя для заданных
//  периода и сценария. В таблицу раскрытия, кроме "стандартных" данных
//  добавляются данные описанные в группе аналитик сверки ВГО.
//  В текущей версии значения доп. колонок читаются и интерпретирются
//  "вручную" в обход механизма источников данных ввиду невозможности
//  решить с их помощью данную задачу.
//
// Параметры:
//	ПараметрыЭлиминации - Структура - параметры для получения данных.
//		Поля:
//			- Организация, 
//			- Сценарий, 
//			- ВидОтчета, 
//			- ПериодОтчета
//			- РазделВГО.
//  ИсточникДанных - СправочникСсылка.ИсточникиДанных - источник данных
//		с описанием правил получения значений группы раскрытия ВГО.
// 
// Возвращаемое значение:
//   - ТаблицаЗначений
//
Функция ПолучитьРасширеннуюТаблицуРаскрытияПоказателя(
										ПараметрыЭлиминации,
										ИсточникДанных,
										ПоказательОтчета) Экспорт
	ТЗначенийПоказателей = 
		ПересчетПоказателейУХ.ПолучитьТаблицуРаскрытияПоПараметрам(
			ПараметрыЭлиминации.Организация, 
			ПараметрыЭлиминации.Сценарий, 
			ПоказательОтчета.Владелец, 
			ПараметрыЭлиминации.ПериодОтчета,
			,
			,
			,
			,
			ПоказательОтчета);
	ГруппаРаскрытияВГО = ПараметрыЭлиминации.РазделВГО.ГруппаРаскрытия;
	ДобавитьКолонкиГруппыРаскрытияВГОВТаблицу(
		ТЗначенийПоказателей, 
		ГруппаРаскрытияВГО);
	ЗаполнитьДанныеДляВГОВТаблице(
		ТЗначенийПоказателей, 
		ПараметрыЭлиминации,
		ИсточникДанных,
		ГруппаРаскрытияВГО,
		ПоказательОтчета);
	Возврат ТЗначенийПоказателей;
КонецФункции

// Получить значение аналитики элиминации из данных источника.
//
// Параметры:
//	ПараметрыЭлиминации - Структура - параметры для
//		получения экземпляра отчета, в случае, если получение данных
//		подразумевает обращение к контексту экземпляра.
//		Поля:
//			- Организация, 
//			- Сценарий, 
//			- ПериодОтчета.
//	ИсточникДанных - СправочникСсылка.ИсточникиДанных - источник данных
//		с настройками получения аналитик для группы аналитик ВГО.
//	ПоказательОтчета - СправочникСсылка.ПоказателиОтчетов - показатель
//		для которого получаем данные.
//	ГруппаАналитикВГО - СправочникСсылка.ГруппыАналитикСверкиВГО -
//		описывает аналитики для сверки и элиминации.
//  СтрокаДанных - СтрокаТаблицыЗначений - набор значений аналитик группы
//		раскрытия по источнику данных.
//  ТипАналитики - ПеречислениеСсылка.ТипыАналитикЭлиминации - тип
//		аналитики элиминации.
// 
// Возвращаемое значение:
//   - Любая ссылка. В зависимости от типа значения аналитики.
//
Функция ПолучитьЗначениеАналитикиЭлиминацииИзДанныхИсточника(
												ПараметрыЭлиминации,
												ИсточникДанных,
												ПоказательОтчета,
												ГруппаАналитикВГО,
												СтрокаДанных, 
												ТипАналитики) Экспорт
	ОписаниеАналитики = 
		Справочники.ГруппыАналитикСверкиВГО.ПолучитьОписаниеАналитики(
			ГруппаАналитикВГО, 
			ТипАналитики);														
	ИмяАналитики = ОписаниеАналитики.Имя;
	Правило = ПолучитьПравилоЗаполненияАналитики(
		ИсточникДанных, 
		ИмяАналитики);
	Если Правило.СпособЗаполнения = 
			Перечисления.СпособыЗаполненияПолейИсточника.ФиксированноеЗначение Тогда
		Возврат Правило.ФиксированноеЗначение;
	ИначеЕсли Правило.СпособЗаполнения = 
			Перечисления.СпособыЗаполненияПолейИсточника.ПолеИсходнойТаблицы Тогда
		Если Лев(Правило.Поле, 6) = "Версия" Тогда
			Версия = 
				ПолучитьПоследнююВерсиюЗначенияПоказателя(
					ПараметрыЭлиминации.Сценарий,
					ПараметрыЭлиминации.ПериодОтчета,
					ПараметрыЭлиминации.Организация,
					ПоказательОтчета);
			Если ЗначениеЗаполнено(Версия) Тогда
				Возврат ОбщегоНазначения.ВычислитьВБезопасномРежиме(
					"Параметры." + Сред(Правило.Поле, 8),
					Версия);
			КонецЕсли;
		Иначе
			Возврат ОбщегоНазначения.ВычислитьВБезопасномРежиме(
				"Параметры." + Правило.Поле,
				СтрокаДанных);
		КонецЕсли;
	КонецЕсли;
	Возврат ОписаниеАналитики.ВидАналитики.ТипЗначения.ПривестиЗначение();
КонецФункции


#КонецОбласти


#Область ВнутренниеФункцииМодуля


// Если колонка уже есть в таблице создает новую с префиксом "ВГО_".
//
Процедура ДобавитьКолонкиГруппыРаскрытияВГОВТаблицу(
											Таблица, 
											ГруппаРаскрытияВГО)
	Колонки = Таблица.Колонки;
	ТаблицаАналитик = ГруппаРаскрытияВГО.Аналитики;
	Для Каждого СтрокаАналитики Из ТаблицаАналитик Цикл
		Если СтрокаАналитики.ТипДляЭлиминации 
				<> Перечисления.ТипыАналитикЭлиминации.ТолькоСверка Тогда
			Имя = СтрокаАналитики.Имя;
			Колонка = Колонки.Найти(Имя);
			Если Колонка <> Неопределено Тогда
				Имя = "ВГО_" + Имя;
			КонецЕсли;
			Колонка = Колонки.Добавить(Имя, СтрокаАналитики.ВидАналитики.ТипЗначения);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция ПолучитьИмяКолонкиВГО(ИмяРеквизитаРаскрытияВГО, Колонки)
	Колонка = Колонки.Найти("ВГО_" + ИмяРеквизитаРаскрытияВГО);
	Если Колонка = Неопределено Тогда
		Колонка = Колонки.Найти(ИмяРеквизитаРаскрытияВГО)
	КонецЕсли;
	Если Колонка <> Неопределено Тогда
		Возврат Колонка.Имя;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Процедура ЗаполнитьДанныеДляВГОВТаблице(Таблица, 
										ПараметрыЭлиминации,
										ИсточникДанных,
										ГруппаРаскрытияВГО,
										ПоказательОтчета)
	Колонки = Таблица.Колонки;
	ТаблицаАналитик = ГруппаРаскрытияВГО.Аналитики;
	Версия = Неопределено;
	Для Каждого СтрокаАналитики Из ТаблицаАналитик Цикл
		Если СтрокаАналитики.ТипДляЭлиминации 
				<> Перечисления.ТипыАналитикЭлиминации.ТолькоСверка Тогда
			ИмяАналитики = СтрокаАналитики.Имя;
			ИмяКолонки = ПолучитьИмяКолонкиВГО(ИмяАналитики, Колонки);
			Правило = ПолучитьПравилоЗаполненияАналитики(
				ИсточникДанных, 
				ИмяАналитики);
			Если Правило.СпособЗаполнения = 
					Перечисления.СпособыЗаполненияПолейИсточника.ФиксированноеЗначение Тогда
				Таблица.ЗаполнитьЗначения(Правило.ФиксированноеЗначение, ИмяКолонки);	
			ИначеЕсли Правило.СпособЗаполнения = 
					Перечисления.СпособыЗаполненияПолейИсточника.ПолеИсходнойТаблицы Тогда
				Если Лев(Правило.Поле, 6) = "Версия" Тогда
					Если Версия = Неопределено Тогда
						Версия = ПолучитьПоследнююВерсиюЗначенияПоказателя(
							ПараметрыЭлиминации.Сценарий,
							ПараметрыЭлиминации.ПериодОтчета,
							ПараметрыЭлиминации.Организация,
							ПоказательОтчета);
					КонецЕсли;
					Если ЗначениеЗаполнено(Версия) Тогда
						Значение = ОбщегоНазначения.ВычислитьВБезопасномРежиме(
							"Параметры." + Сред(Правило.Поле, 8),
							Версия);
						Таблица.ЗаполнитьЗначения(Значение, ИмяКолонки);
					КонецЕсли;
				Иначе
					ВычислитьКолонкуТаблицыПоСтрокам(
						Таблица, 
						ИмяКолонки, 
						Правило.Поле);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;									
КонецПроцедуры

Процедура ВычислитьКолонкуТаблицыПоСтрокам(Таблица, 
										   ИмяКолонки, 
										   ФормулаВычисления)
	СтрокаВычисления = "
		|Для Каждого СтрокаЗначения Из Параметры Цикл
		|	СтрокаЗначения." + ИмяКолонки + " = 
		|		СтрокаЗначения." + ФормулаВычисления + ";
		|КонецЦикла;";
	ОбщегоНазначения.ВыполнитьВБезопасномРежиме(СтрокаВычисления, Таблица);
КонецПроцедуры

Функция ПолучитьПоследнююВерсиюЗначенияПоказателя(Сценарий,
												  ПериодОтчета,
												  Организация,
												  ПоказательОтчета)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ЗначенияПоказателейОтчетовСинтетика.Версия КАК Версия
		|ИЗ
		|	РегистрСведений.ЗначенияПоказателейОтчетовСинтетика КАК ЗначенияПоказателейОтчетовСинтетика
		|ГДЕ
		|	ЗначенияПоказателейОтчетовСинтетика.Показатель = &Показатель
		|	И ЗначенияПоказателейОтчетовСинтетика.Версия.Организация = &Организация
		|	И ЗначенияПоказателейОтчетовСинтетика.Версия.ПериодОтчета = &ПериодОтчета
		|	И ЗначенияПоказателейОтчетовСинтетика.Версия.Сценарий = &Сценарий
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗначенияПоказателейОтчетовСинтетика.ДатаИзмененияMs УБЫВ";
	Запрос.УстановитьПараметр("Показатель", ПоказательОтчета);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ПериодОтчета", ПериодОтчета);
	Запрос.УстановитьПараметр("Сценарий", Сценарий);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Если ВыборкаДетальныеЗаписи.Следующий() 
			И ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Версия) Тогда
		Возврат ВыборкаДетальныеЗаписи.Версия;
	КонецЕсли;
	Возврат Справочники.ВерсииЗначенийПоказателей.ПустаяСсылка();
КонецФункции

Функция ПолучитьПравилоЗаполненияАналитики(ИсточникДанных, ИмяАналитики)
	Правила = ИсточникДанных.ПравилаИспользованияПолейЗапроса;
	Возврат Правила.Найти(ИмяАналитики, "КодАналитики");
КонецФункции


#КонецОбласти


#КонецЕсли