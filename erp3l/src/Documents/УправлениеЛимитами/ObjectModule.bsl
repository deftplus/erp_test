#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения <> Тип("Структура") Тогда
		ПараметрДанныеЗаполнения = ДанныеЗаполнения;
		ДанныеЗаполнения = Новый Структура;
	КонецЕсли;
	
	Если ТипДанныхЗаполнения = Тип("ТаблицаЗначений") Тогда
		Данные.Загрузить(ПараметрДанныеЗаполнения);
	ИначеЕсли ДанныеЗаполнения.Свойство("Данные") Тогда
		ТипДанных = ТипЗнч(ДанныеЗаполнения.Данные);
		Если ТипДанных = Тип("ТаблицаЗначений") Тогда
			Данные.Загрузить(ДанныеЗаполнения.Данные);
		ИначеЕсли ТипДанных = Тип("Массив") Тогда
			Для Каждого Строка Из ДанныеЗаполнения.Данные Цикл
				ЗаполнитьЗначенияСвойств(Данные.Добавить(), Строка, "ВидБюджета, ЦФО, Проект, ПериодЛимитирования, УОП, Сценарий");
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ДанныеЗаполнения.Свойство("Ответственный") Тогда
		ДанныеЗаполнения.Вставить("Ответственный", Пользователи.ТекущийПользователь());
	КонецЕсли;
	
	Если НЕ ДанныеЗаполнения.Свойство("Дата") Тогда
		ДанныеЗаполнения.Вставить("Дата", ТекущаяДатаСеанса());
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если ВидОперации <> Перечисления.ВидыОперацийУправлениеЛимитами.УстановкаЛимитовПоИсточнику Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Данные.УОП");
		МассивНепроверяемыхРеквизитов.Добавить("Данные.Сценарий");
	КонецЕсли;
	
	// Удаляем
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ПроверитьДублированиеСтрок(Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверОПК.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.УправлениеЛимитами.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	// Подготовка наборов записей
	ПроведениеСерверОПК.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	// Движения по регистрам
	Документы.УправлениеЛимитами.ОтразитьСостояниеПериодовЛимитирования(ДополнительныеСвойства, Движения, Отказ);
	Документы.УправлениеЛимитами.ОтразитьСостояниеУстановки(ДополнительныеСвойства, Движения, Отказ);
	Документы.УправлениеЛимитами.ОтразитьЛимитыПоБюджетам(ДополнительныеСвойства, Движения, Отказ);
	
	УстановитьАктуальностьЛимитов(ДополнительныеСвойства);
	
	// Контроль результатов проведения.
	ПроведениеСерверОПК.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСерверОПК.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если Документы.УправлениеЛимитами.ПоследующиеДокументы(Ссылка).Количество() > 0 Тогда
		
		ШаблонСообщения = НСтр("ru = 'Существуют документы, установившие лимиты после текущего документа (%1). Отмена проведения невозможна.'");
		ОбщегоНазначения.СообщитьПользователю(СтрШаблон(ШаблонСообщения, Ссылка),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	УдалитьАктуальностьЛимитовПоДокументу(Ссылка);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Очистка лишних реквизитов
	Если ВидОперации <> Перечисления.ВидыОперацийУправлениеЛимитами.УстановкаЛимитовПоИсточнику Тогда
		
		Для Каждого Строка Из Данные Цикл
			Строка.УОП = Документы.УправлениеПериодомСценария.ПустаяСсылка();
			Строка.Сценарий = Справочники.Сценарии.ПустаяСсылка();
		КонецЦикла;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ЭтоНовый") Тогда
		Документы.УправлениеЛимитами.ЗаполнитьЗначенияПоказателейИПараметрыЛимитирования(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьАктуальностьЛимитов(ДополнительныеСвойства)
	
	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаАктуальностьУстановленныхЛимитов;
	
	УдалитьАктуальностьЛимитовПоДокументу(Ссылка);
	Если ВидОперации = Перечисления.ВидыОперацийУправлениеЛимитами.УстановкаЛимитовПоИсточнику Тогда
		Для Каждого СтрокаАктуальности Из Таблица Цикл
			МЗ = РегистрыСведений.АктуальностьУстановленныхЛимитов.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МЗ, СтрокаАктуальности);
			МЗ.Записать();
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьАктуальностьЛимитовПоДокументу(Документ);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АктуальностьУстановленныхЛимитов.Период КАК Период,
	|	АктуальностьУстановленныхЛимитов.Организация КАК Организация,
	|	АктуальностьУстановленныхЛимитов.ВидОтчета КАК ВидОтчета,
	|	АктуальностьУстановленныхЛимитов.Область КАК Область,
	|	АктуальностьУстановленныхЛимитов.Проект КАК Проект,
	|	АктуальностьУстановленныхЛимитов.УОП КАК УОП,
	|	АктуальностьУстановленныхЛимитов.Предназначение КАК Предназначение,
	|	АктуальностьУстановленныхЛимитов.Актуальность КАК Актуальность,
	|	АктуальностьУстановленныхЛимитов.Документ КАК Документ,
	|	АктуальностьУстановленныхЛимитов.Пользователь КАК Пользователь
	|ИЗ
	|	РегистрСведений.АктуальностьУстановленныхЛимитов КАК АктуальностьУстановленныхЛимитов
	|ГДЕ
	|	АктуальностьУстановленныхЛимитов.Документ = &Документ";
	
	Запрос.УстановитьПараметр("Документ", Документ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МЗ = РегистрыСведений.АктуальностьУстановленныхЛимитов.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МЗ, Выборка);
		МЗ.Удалить();
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьДублированиеСтрок(Отказ)
	
	// Проверка наличия дублей
	ШаблонПутиПоля = "Объект.Данные[%1]";
	ИменаРеквизитов = "ЦФО, Проект, ПериодЛимитирования";
	ТаблицаДанных = Данные.Выгрузить();
	ЦФОПроектПериод = ТаблицаДанных.Скопировать(, ИменаРеквизитов);
	ЦФОПроектПериод.Свернуть(ИменаРеквизитов, "");
	
	ШаблонСообщения = НСтр("ru = 'Значения строки %1 совпадают со значениями  одной или нескольких других строк. Устраните дублирование данных и повторите операцию.'");
	
	СтруктураПоиска = Новый Структура(ИменаРеквизитов);
	Для Каждого Строка Из ЦФОПроектПериод Цикл
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, Строка);
		
		СтрокиДанных = ТаблицаДанных.НайтиСтроки(СтруктураПоиска);
		Если СтрокиДанных.Количество() >1 Тогда
			Для Каждого СтрокаДанных Из СтрокиДанных Цикл
				ПутьКПолю = СтрШаблон(ШаблонПутиПоля, СтрокаДанных.НомерСтроки-1);
				ОбщегоНазначения.СообщитьПользователю(СтрШаблон(ШаблонСообщения, СтрокаДанных.НомерСтроки), , ПутьКПолю+".Сценарий", , Отказ);
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

