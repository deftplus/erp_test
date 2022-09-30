#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область ОбработчикиСобытий	
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Документы.ИсполнениеКовенантов.ОчиститьНеиспользуемыеРеквизитыДокумента(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУХ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ИсполнениеКовенантов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУХ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	РаботаСДоговорамиКонтрагентовУХ.ОтразитьСостояниеИсполненияКовенантов(ДополнительныеСвойства, Движения, Отказ);
	РаботаСДоговорамиКонтрагентовУХ.ОтразитьНарушенияУсловийДоговора(Ссылка, ДополнительныеСвойства, Отказ);
	РаботаСДоговорамиКонтрагентовУХ.ОтразитьСтатусыПроверкиКовенантов(Ссылка, ДополнительныеСвойства, Отказ);
	РаботаСДоговорамиКонтрагентовУХ.ВыключитьНапоминанияОПросрочкеКовенантов(ДополнительныеСвойства, Отказ);
	
	ПроведениеСерверУХ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУХ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
			
	ПроведениеСерверУХ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);	
	ПроведениеСерверУХ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);	
	ПроведениеСерверУХ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	РаботаСДоговорамиКонтрагентовУХ.УдалитьНарушенияУсловийДоговора(Ссылка, Отказ);
	РаботаСДоговорамиКонтрагентовУХ.УдалитьСтатусыПроверкиКовенантов(Ссылка, Отказ);
	ПроведениеСерверУХ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Ковенанты.РеакцияБанкаНаНарушение");
	МассивНепроверяемыхРеквизитов.Добавить("Ковенанты.Вейвер");
	
	ПроверитьУникальностьДокумента(Отказ);
	ПроверитьЗаполнениеПлановойДаты(Отказ);
	ПроверитьЗаполнениеРеакцииБанкаНарушение(Отказ);
	ПроверитьЗаполнениеВейвера(Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеРеакцииБанкаНарушение(Отказ)
	
	Для каждого Строка Из Ковенанты Цикл
		Если Строка.СтатусИсполнения = Перечисления.СтатусыИсполненияКовентантов.Нарушен 
			И НЕ ЗначениеЗаполнено(Строка.РеакцияБанкаНаНарушение) Тогда
			
			ИндексСтроки = Ковенанты.Индекс(Строка);
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(Нстр("ru = 'Не указана реакция банка на нарушение ковенанта в строке %1'"), ИндексСтроки + 1),
				ЭтотОбъект,
				СтрШаблон("Ковенанты[%1].РеакцияБанкаНаНарушение", ИндексСтроки),
				, // Путь к данным
				Отказ		
			);
				
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ПроверитьЗаполнениеВейвера(Отказ)
	
	Для каждого Строка Из Ковенанты Цикл
		Если Строка.СтатусИсполнения = Перечисления.СтатусыИсполненияКовентантов.Нарушен
			И Строка.РеакцияБанкаНаНарушение = Перечисления.РеакцииБанковНаНарушенияКовенантов.Вейвер
			И НЕ ЗначениеЗаполнено(Строка.Вейвер) Тогда
			
			ИндексСтроки = Ковенанты.Индекс(Строка);
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(Нстр("ru = 'Не указан файл вейвера банка на нарушение ковенанта в строке %1'"), ИндексСтроки + 1),
				ЭтотОбъект,
				СтрШаблон("Ковенанты[%1].Вейвер", ИндексСтроки),
				, // Путь к данным
				Отказ		
			);
				
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры	

Процедура ПроверитьУникальностьДокумента(Отказ)
		
	Документ = Документы.ИсполнениеКовенантов.ДокументПоДоговору(ДоговорКонтрагента, ПлановаяДата, Дата, Ссылка);
	
	Если ЗначениеЗаполнено(Документ) Тогда
		
		Если ЗначениеЗаполнено(ПлановаяДата) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(Нстр("ru = 'Уже введен документ: %1, по договору: %2, на плановую дату: %3'"),
					Документ, 
					ДоговорКонтрагента, 
					Формат(ПлановаяДата, "ДЛФ=D")),
				ЭтотОбъект,
				"ПлановаяДата",
				, // Путь к данным
				Отказ);
			
		Иначе
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(Нстр("ru = 'Уже введен документ: %1, по договору: %2, на дату: %3'"),
					Документ, 
					ДоговорКонтрагента, 
					Формат(Дата, "ДЛФ=D")),
				ЭтотОбъект,
				"Дата",
				, // Путь к данным
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры	

Процедура ПроверитьЗаполнениеПлановойДаты(Отказ)
	
	Если ЗначениеЗаполнено(ЭтотОбъект.ПлановаяДата)
		И ЭтотОбъект.ПлановаяДата > ЭтотОбъект.Дата Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
				Нстр("ru = 'Плановая дата не может быть больше даты документа'"),
				ЭтотОбъект,
				"ПлановаяДата",
				, // Путь к данным
				Отказ);
			
		Возврат;
		
	КонецЕсли;
	
	АктуальнаяВерсияСоглашения = РегистрыСведений.ВерсииРасчетов.ПолучитьАктуальнуюВерсиюФинансовогоИнструмента(ДоговорКонтрагента, Дата);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ЭтотОбъект.ДоговорКонтрагента);
	Запрос.УстановитьПараметр("ВерсияСоглашения", АктуальнаяВерсияСоглашения);
	Запрос.УстановитьПараметр("Дата", ЭтотОбъект.Дата);
	Запрос.УстановитьПараметр("ПлановаяДата", ЭтотОбъект.ПлановаяДата);
	Запрос.УстановитьПараметр("КовенантыДокумента", ЭтотОбъект.Ковенанты.Выгрузить());
	Запрос.УстановитьПараметр("Документ", ЭтотОбъект.Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КовенантыДокумента.Ковенант КАК Ковенант,
	|	КовенантыДокумента.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ВТ_КовенантыДокумента
	|ИЗ
	|	&КовенантыДокумента КАК КовенантыДокумента
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ковенант
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_КовенантыДокумента.Ковенант КАК Ковенант,
	|	МАКСИМУМ(ЕСТЬNULL(ВерсияСоглашенияКредитКовенанты.Периодичность, НЕОПРЕДЕЛЕНО)) КАК Периодичность,
	|	ВЫБОР
	|		КОГДА ВерсияСоглашенияКредитКовенанты.Ковенант ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЕстьКовенантВСоглашении,
	|	ВТ_КовенантыДокумента.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ Вт_Ковенанты
	|ИЗ
	|	ВТ_КовенантыДокумента КАК ВТ_КовенантыДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВерсияСоглашенияКредит.Ковенанты КАК ВерсияСоглашенияКредитКовенанты
	|		ПО (ВерсияСоглашенияКредитКовенанты.Ссылка = &ВерсияСоглашения)
	|			И ВТ_КовенантыДокумента.Ковенант = ВерсияСоглашенияКредитКовенанты.Ковенант
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_КовенантыДокумента.Ковенант,
	|	ВЫБОР
	|		КОГДА ВерсияСоглашенияКредитКовенанты.Ковенант ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ,
	|	ВТ_КовенантыДокумента.НомерСтроки
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ковенант
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Вт_Ковенанты.Ковенант КАК Ковенант,
	|	Вт_Ковенанты.НомерСтроки КАК НомерСтроки,
	|	Вт_Ковенанты.Периодичность КАК Периодичность,
	|	Вт_Ковенанты.ЕстьКовенантВСоглашении КАК ЕстьКовенантВСоглашении,
	|	ВЫБОР
	|		КОГДА СтатусыПроверкиКовенантов.ПлановаяДата ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК НайденаПлановаяДата
	|ИЗ
	|	Вт_Ковенанты КАК Вт_Ковенанты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыПроверкиКовенантов КАК СтатусыПроверкиКовенантов
	|		ПО (СтатусыПроверкиКовенантов.Документ = &ВерсияСоглашения)
	|			И Вт_Ковенанты.Ковенант = СтатусыПроверкиКовенантов.Ковенант
	|			И (СтатусыПроверкиКовенантов.ПлановаяДата = &ПлановаяДата)";
		
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ПутьКРеквизиту = СтрШаблон("Ковенанты[%1].Ковенант", Формат(Выборка.НомерСтроки - 1, "ЧН=0; ЧГ="));
		
		Если НЕ Выборка.ЕстьКовенантВСоглашении Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(Нстр("ru = 'Не найден ковенант: %1, строка: %2 в версии соглашения: %3'"),
						Выборка.Ковенант,
						Выборка.НомерСтроки,
						АктуальнаяВерсияСоглашения),
				ЭтотОбъект,
				ПутьКРеквизиту,
				, // Путь к данным
				Отказ
			);
			
			Продолжить;
			
		КонецЕсли;
		
		Если НЕ Выборка.НайденаПлановаяДата 
			И ЗначениеЗаполнено(Выборка.Периодичность) 
			И Выборка.Периодичность <> Перечисления.ПериодичностьКовенантов.Непериодический Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(Нстр("ru = 'Не корректно указана плановая дата для ковенанта: %1 в строке: %2'"),
						Выборка.Ковенант,
						Выборка.НомерСтроки),
				ЭтотОбъект,
				ПутьКРеквизиту,
				, // Путь к данным
				Отказ
			);
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры	

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	 Ответственный = Пользователи.ТекущийПользователь();
КонецПроцедуры
#КонецОбласти
#КонецЕсли