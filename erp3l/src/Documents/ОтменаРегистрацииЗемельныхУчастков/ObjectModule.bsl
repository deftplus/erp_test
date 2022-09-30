#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("ДокументСсылка.ОбъединениеОС") Тогда
		ЗаполнитьНаОснованииОбъединенияОС(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.РазукомплектацияОС") Тогда
		ЗаполнитьНаОснованииРазукомплектацииОС(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьРегистрацию(Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.ОтменаРегистрацииЗемельныхУчастков.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(
		НСтр("ru = 'Отмена регистрации земельных участков';
			|en = 'Cancel land lot registration'"));
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииОбъединенияОС(Основание)

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.ОтражатьВРеглУчете КАК ОтражатьВРеглУчете,
	|	ДанныеДокумента.Организация КАК Организация
	|ИЗ
	|	Документ.ОбъединениеОС КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Основание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ТаблицаОС.Ссылка.Организация КАК Организация
	|ПОМЕСТИТЬ ТаблицаОС
	|ИЗ
	|	Документ.ОбъединениеОС.ОС КАК ТаблицаОС
	|ГДЕ
	|	ТаблицаОС.Ссылка = &Основание
	|	И ТаблицаОС.ОсновноеСредство <> ЗНАЧЕНИЕ(Справочник.ОбъектыЭксплуатации.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство
	|ИЗ
	|	Документ.ОбъединениеОС.ОС КАК ТаблицаОС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РегистрацияЗемельныхУчастков.СрезПоследних(
	|				&Дата,
	|				(ОсновноеСредство, Организация) В
	|					(ВЫБРАТЬ
	|						ТаблицаОС.ОсновноеСредство,
	|						ТаблицаОС.Организация
	|					ИЗ
	|						ТаблицаОС)) КАК Регистрация
	|		ПО (Регистрация.ОсновноеСредство = ТаблицаОС.ОсновноеСредство)
	|ГДЕ
	|	ТаблицаОС.Ссылка = &Основание
	|	И ЕСТЬNULL(Регистрация.ВидЗаписи, НЕОПРЕДЕЛЕНО) = ЗНАЧЕНИЕ(Перечисление.ВидЗаписиОРегистрации.Регистрация)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Основание", Основание);
	Запрос.УстановитьПараметр("Дата", ?(Дата <> '000101010000', Дата, ТекущаяДатаСеанса()));
	
	Пакет = Запрос.ВыполнитьПакет();
	
	Если Пакет[Пакет.ВГраница()].Пустой() Тогда
		ВызватьИсключение НСтр("ru = 'Отмена регистрации не доступна, т.к. основные средства не зарегистрированы как земельные участки';
								|en = 'Cancellation of registration is not available, because the fixed assets are not registered as land'");
	КонецЕсли;
	
	Выборка = Пакет[0].Выбрать();
	Выборка.Следующий();
	
	Если НЕ Выборка.ОтражатьВРеглУчете Тогда
		ВызватьИсключение НСтр("ru = 'Отмена регистрации не доступна, т.к. документ не отражен в регл. учете';
								|en = 'Cancellation of registration is not available, because the document is not recorded in compl. accounting'");
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
	Таблица = Пакет[Пакет.ВГраница()].Выгрузить();
	ОС.Загрузить(Таблица);
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииРазукомплектацииОС(Основание)

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Регистрация.Организация КАК Организация,
	|	Регистрация.ОсновноеСредство КАК ОсновноеСредство
	|ИЗ
	|	РегистрСведений.РегистрацияЗемельныхУчастков.СрезПоследних(
	|			&Дата,
	|			(ОсновноеСредство, Организация) В
	|				(ВЫБРАТЬ
	|					ТаблицаОС.ОсновноеСредство,
	|					ТаблицаОС.Организация
	|				ИЗ
	|					Документ.РазукомплектацияОС КАК ТаблицаОС
	|				ГДЕ
	|					ТаблицаОС.Ссылка = &Основание)) КАК Регистрация
	|ГДЕ
	|	ЕСТЬNULL(Регистрация.ВидЗаписи, НЕОПРЕДЕЛЕНО) = ЗНАЧЕНИЕ(Перечисление.ВидЗаписиОРегистрации.Регистрация)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Основание", Основание);
	Запрос.УстановитьПараметр("Дата", ?(Дата <> '000101010000', Дата, ТекущаяДатаСеанса()));
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		ВызватьИсключение НСтр("ru = 'Отмена регистрации не доступна, т.к. основное средство не зарегистрировано как земельный участок';
								|en = 'Cancellation of registration is not available, because the fixed asset is not registered as land'");
	КонецЕсли;
	
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "ОтражатьВРеглУчете") Тогда
		ВызватьИсключение НСтр("ru = 'Отмена регистрации не доступна, т.к. документ не отражен в регл. учете';
								|en = 'Cancellation of registration is not available, because the document is not recorded in compl. accounting'");
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
	НоваяСтрока = ОС.Добавить();
	НоваяСтрока.ОсновноеСредство = Выборка.ОсновноеСредство;
	
КонецПроцедуры


Процедура ПроверитьРегистрацию(Отказ)

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство
	|ПОМЕСТИТЬ ТаблицаОС
	|ИЗ
	|	&ТаблицаОС КАК ТаблицаОС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки,
	|	ВЫРАЗИТЬ(ТаблицаОС.ОсновноеСредство КАК Справочник.ОбъектыЭксплуатации).Представление КАК ОсновноеСредствоПредставление
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РегистрацияЗемельныхУчастков.СрезПоследних(
	|				&Дата,
	|				Организация = &Организация
	|					И Регистратор <> &Регистратор
	|					И ОсновноеСредство В
	|						(ВЫБРАТЬ
	|							ТаблицаОС.ОсновноеСредство
	|						ИЗ
	|							ТаблицаОС)) КАК Регистрация
	|		ПО (Регистрация.ОсновноеСредство = ТаблицаОС.ОсновноеСредство)
	|ГДЕ
	|	ЕСТЬNULL(Регистрация.ВидЗаписи, НЕОПРЕДЕЛЕНО) <> ЗНАЧЕНИЕ(Перечисление.ВидЗаписиОРегистрации.Регистрация)
	|	И ТаблицаОС.ОсновноеСредство <> ЗНАЧЕНИЕ(Справочник.ОбъектыЭксплуатации.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ТаблицаОС", ОС.Выгрузить());
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Путь = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", Выборка.НомерСтроки, "ОсновноеСредство");
	
		ТекстСообщения = НСтр("ru = 'Для основного средства ""%1"" отсутствует регистрация на %2';
								|en = 'No registration on %2 for the asset ""%1""'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.ОсновноеСредствоПредставление, Формат(Дата, "ДЛФ=D"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Путь,, Отказ);
	
	КонецЦикла;
	
КонецПроцедуры
 
#КонецОбласти

#КонецЕсли
