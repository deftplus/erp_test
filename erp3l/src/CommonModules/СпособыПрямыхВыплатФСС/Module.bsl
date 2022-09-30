#Область СлужебныйПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
//
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия          = "3.1.17.86";
	Обработчик.РежимВыполнения = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ОсновнойРежимВыполненияОбновления();
	Обработчик.Идентификатор   = Новый УникальныйИдентификатор("ff192df3-54f1-11eb-80e9-4cedfb43b11a");
	Обработчик.Процедура       = "СпособыПрямыхВыплатФСС.ПеренестиБанковскиеКартыВНастройки";
	Обработчик.Комментарий     = НСтр("ru = 'Заполнение банковских карт в настройках прямых выплат.';
										|en = 'Filling in bank cards in the direct payments settings.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия          = "3.1.17.86";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор   = Новый УникальныйИдентификатор("bfda1724-66d0-11eb-80ec-4cedfb43b11a");
	Обработчик.Процедура       = "СпособыПрямыхВыплатФСС.РассчитатьПодробности";
	Обработчик.Комментарий     = НСтр("ru = 'Расчет представлений настроек прямых выплат.';
										|en = 'Calculation of direct payment settings presentations.'");
	
КонецПроцедуры

Процедура ПеренестиБанковскиеКартыВНастройки(ПараметрыОбновления = Неопределено) Экспорт
	ОбработкаЗавершена = Истина;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачала", НачалоГода(ДобавитьМесяц(ТекущаяДатаСеанса(), -12*5)));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявлениеСотрудникаНаВыплатуПособия.Ссылка КАК Ссылка,
	|	ЗаявлениеСотрудникаНаВыплатуПособия.Дата КАК Дата,
	|	ЗаявлениеСотрудникаНаВыплатуПособия.Организация КАК Организация,
	|	ЗаявлениеСотрудникаНаВыплатуПособия.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЗаявлениеСотрудникаНаВыплатуПособия.КартаМИР КАК КартаМИР,
	|	Организации.ГоловнаяОрганизация КАК ГоловнаяОрганизация
	|ПОМЕСТИТЬ ВТВсеЗаявления
	|ИЗ
	|	Документ.ЗаявлениеСотрудникаНаВыплатуПособия КАК ЗаявлениеСотрудникаНаВыплатуПособия
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО ЗаявлениеСотрудникаНаВыплатуПособия.Организация = Организации.Ссылка
	|ГДЕ
	|	ЗаявлениеСотрудникаНаВыплатуПособия.Дата >= &ДатаНачала
	|	И ЗаявлениеСотрудникаНаВыплатуПособия.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТВсеЗаявления.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ВТВсеЗаявления.ФизическоеЛицо КАК ФизическоеЛицо,
	|	МАКСИМУМ(ВТВсеЗаявления.Дата) КАК МаксимальнаяДата
	|ПОМЕСТИТЬ ВТМаксимальныеДаты
	|ИЗ
	|	ВТВсеЗаявления КАК ВТВсеЗаявления
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТВсеЗаявления.ГоловнаяОрганизация,
	|	ВТВсеЗаявления.ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТВсеЗаявления.Ссылка КАК Ссылка,
	|	ВТВсеЗаявления.Дата КАК Дата,
	|	ВТВсеЗаявления.Организация КАК Организация,
	|	ВТВсеЗаявления.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВТВсеЗаявления.КартаМИР КАК КартаМИР,
	|	ВТВсеЗаявления.ГоловнаяОрганизация КАК ГоловнаяОрганизация
	|ИЗ
	|	ВТВсеЗаявления КАК ВТВсеЗаявления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТМаксимальныеДаты КАК ВТМаксимальныеДаты
	|		ПО ВТВсеЗаявления.ГоловнаяОрганизация = ВТМаксимальныеДаты.ГоловнаяОрганизация
	|			И ВТВсеЗаявления.ФизическоеЛицо = ВТМаксимальныеДаты.ФизическоеЛицо
	|			И ВТВсеЗаявления.Дата = ВТМаксимальныеДаты.МаксимальнаяДата
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.БанковскиеКартыКонтрагентов КАК БанковскиеКартыКонтрагентов
	|		ПО ВТВсеЗаявления.КартаМИР = БанковскиеКартыКонтрагентов.Ссылка
	|ГДЕ
	|	БанковскиеКартыКонтрагентов.ЭтоНациональныйПлатежныйИнструмент
	|	И БанковскиеКартыКонтрагентов.ВАрхиве = ЛОЖЬ";
	
	МенеджерРегистра = РегистрыСведений.НастройкиПрямыхВыплатФСССотрудников;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		МенеджерЗаписи = МенеджерРегистра.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ГоловнаяОрганизация              = Выборка.ГоловнаяОрганизация;
		МенеджерЗаписи.ФизическоеЛицо                   = Выборка.ФизическоеЛицо;
		МенеджерЗаписи.ОпределятьПоОрганизации          = Ложь;
		МенеджерЗаписи.ОпределятьПоОсновномуМестуРаботы = Ложь;
		МенеджерЗаписи.Значение                         = Выборка.КартаМИР;
		
		Если Не МенеджерРегистра.ЗаписатьМенеджерЗаписи(МенеджерЗаписи) Тогда
			ОбработкаЗавершена = Ложь; // Регистр заблокирован, требуется повторная обработка.
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПараметрыОбновления <> Неопределено Тогда
		ПараметрыОбновления.ОбработкаЗавершена = ОбработкаЗавершена;
	КонецЕсли;
КонецПроцедуры

Процедура РассчитатьПодробности(ПараметрыОбновления = Неопределено) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Организации.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления";
	
	МенеджерРегистра = РегистрыСведений.НастройкиПрямыхВыплатФСССотрудниковПодробности;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МенеджерРегистра.РассчитатьСпособыОпределяемыеАвтоматически(Выборка.Ссылка);
	КонецЦикла;
	
	Если ПараметрыОбновления <> Неопределено Тогда
		ПараметрыОбновления.ОбработкаЗавершена = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	Списки.Вставить(Метаданные.РегистрыСведений.НастройкиПрямыхВыплатФССОрганизаций, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.НастройкиПрямыхВыплатФСССотрудников, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.НастройкиПрямыхВыплатФСССотрудниковПодробности, Истина);
	
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных.
Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт
	
	Описание = Описание + "
	|РегистрСведений.НастройкиПрямыхВыплатФССОрганизаций.Чтение.Организации
	|РегистрСведений.НастройкиПрямыхВыплатФССОрганизаций.Изменение.Организации
	|РегистрСведений.НастройкиПрямыхВыплатФСССотрудников.Чтение.ГруппыФизическихЛиц
	|РегистрСведений.НастройкиПрямыхВыплатФСССотрудников.Чтение.Организации
	|РегистрСведений.НастройкиПрямыхВыплатФСССотрудников.Изменение.ГруппыФизическихЛиц
	|РегистрСведений.НастройкиПрямыхВыплатФСССотрудников.Изменение.Организации
	|РегистрСведений.НастройкиПрямыхВыплатФСССотрудниковПодробности.Чтение.ГруппыФизическихЛиц
	|РегистрСведений.НастройкиПрямыхВыплатФСССотрудниковПодробности.Чтение.Организации
	|РегистрСведений.НастройкиПрямыхВыплатФСССотрудниковПодробности.Изменение.ГруппыФизическихЛиц
	|РегистрСведений.НастройкиПрямыхВыплатФСССотрудниковПодробности.Изменение.Организации";
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция НастройкиСотрудников(Знач Организация, Знач ФизическиеЛица, Знач ДатаНачалаСобытия) Экспорт
	ТаблицаРезультат = ПустаяТаблицаНастроекСотрудников();
	
	Если ТипЗнч(ФизическиеЛица) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		ФизическиеЛица = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическиеЛица);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаНачалаСобытия) Тогда
		ДатаНачалаСобытия = ТекущаяДатаСеанса();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Организация);
	НастройкиФизическихЛиц = НастройкиФизическихЛиц(ФизическиеЛица);
	БанковскиеРеквизиты = ТаблицаЗарплатныхПроектовИБанковскихСчетов(ФизическиеЛица);
	УстановитьПривилегированныйРежим(Ложь);
	
	// Чтение настроек физических лиц, подготовка строк таблицы результатов.
	ФильтрНастроекФизическихЛиц = Новый Структура("ФизическоеЛицо, ГоловнаяОрганизация");
	ФильтрНастроекФизическихЛиц.ГоловнаяОрганизация = ГоловнаяОрганизация;
	ОставшиесяФизическиеЛица = Новый Массив;
	Для Каждого ФизическоеЛицо Из ФизическиеЛица Цикл
		СтрокаРезультат = ТаблицаРезультат.Добавить();
		СтрокаРезультат.ФизическоеЛицо = ФизическоеЛицо;
		// Чтение настроек физического лица.
		ФильтрНастроекФизическихЛиц.ФизическоеЛицо = ФизическоеЛицо;
		Найденные = НастройкиФизическихЛиц.НайтиСтроки(ФильтрНастроекФизическихЛиц);
		Если Найденные.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(СтрокаРезультат, Найденные[0]);
		Иначе
			СтрокаРезультат.ОпределятьПоОрганизации = Истина;
		КонецЕсли;
		// Настройки сотрудника взаимоисключающие.
		Если СтрокаРезультат.ОпределятьПоОрганизации Тогда
			СтрокаРезультат.ОпределятьАвтоматически = Истина;
			СтрокаРезультат.ОпределятьПоОсновномуМестуРаботы = Ложь; // Он считывается позже - из настроек организации.
			СтрокаРезультат.Значение = Неопределено;
		ИначеЕсли СтрокаРезультат.ОпределятьПоОсновномуМестуРаботы Тогда
			СтрокаРезультат.ОпределятьАвтоматически = Истина;
			СтрокаРезультат.Значение = Неопределено;
		ИначеЕсли Не ЗначениеЗаполнено(СтрокаРезультат.Значение) Тогда
			СтрокаРезультат.Значение = Неопределено;
		Иначе
			НайтиИЗаполнитьБанковскиеРеквизитыСтрокиРезультата(СтрокаРезультат, БанковскиеРеквизиты);
		КонецЕсли;
		СтрокаРезультат.ТипЗначения = ТипЗнч(СтрокаРезультат.Значение);
	КонецЦикла;
	
	// Определение банковских реквизитов по организации, заполнение флажка ОпределятьПоОсновномуМестуРаботы.
	НайденныеСтрокиРезультат = ТаблицаРезультат.НайтиСтроки(Новый Структура("ОпределятьПоОрганизации", Истина));
	Если НайденныеСтрокиРезультат.Количество() > 0 Тогда
		// Получение настроек организации.
		НастройкиОрганизации = РегистрыСведений.НастройкиПрямыхВыплатФССОрганизаций.Прочитать(Организация);
		ПриАвтозаполненииНастроекФизическихЛицПоОрганизации(
			НастройкиОрганизации,
			НайденныеСтрокиРезультат,
			БанковскиеРеквизиты,
			Ложь);
	КонецЕсли;
	
	// Определение банковских реквизитов по основному месту работы.
	ФильтрАвтозаполняемых = Новый Структура;
	ФильтрАвтозаполняемых.Вставить("ОпределятьПоОсновномуМестуРаботы", Истина);
	ФильтрАвтозаполняемых.Вставить("ОпределеноАвтоматически", Ложь);
	НайденныеСтрокиРезультат = ТаблицаРезультат.НайтиСтроки(ФильтрАвтозаполняемых);
	Если НайденныеСтрокиРезультат.Количество() > 0 Тогда
		НайденныеФизическиеЛица = КоллекцииБЗК.УникальныеЗначенияКолонкиСФильтром(
			ТаблицаРезультат,
			ФильтрАвтозаполняемых,
			"ФизическоеЛицо");
		ОсновныеМестаРаботыФизическихЛиц = ОсновныеМестаРаботыФизическихЛиц(НайденныеФизическиеЛица);
		// Удаление уже обработанных строк.
		СтрокиКУдалению = ОсновныеМестаРаботыФизическихЛиц.НайтиСтроки(Новый Структура("Организация", Организация));
		Для Каждого СтрокаТаблицы Из СтрокиКУдалению Цикл
			ОсновныеМестаРаботыФизическихЛиц.Удалить(СтрокаТаблицы);
		КонецЦикла;
		// Чтение настроек физических лиц по основному месту работы.
		ОсновныеГоловныеОрганизации = КоллекцииБЗК.УникальныеЗначенияКолонки(
			ОсновныеМестаРаботыФизическихЛиц,
			"ГоловнаяОрганизация");
		Для Каждого ОсновнаяГоловнаяОрганизация Из ОсновныеГоловныеОрганизации Цикл
			Фильтр = Новый Структура("ГоловнаяОрганизация", ОсновнаяГоловнаяОрганизация);
			НайденныеОсновныеМестаРаботыФизическихЛиц = ОсновныеМестаРаботыФизическихЛиц.НайтиСтроки(Фильтр);
			Для Каждого ОсновноеМестоРаботы Из НайденныеОсновныеМестаРаботыФизическихЛиц Цикл
				// Поиск строки результата и проверка что строка результата еще не заполнена.
				СтрокаРезультат = ТаблицаРезультат.Найти(ОсновноеМестоРаботы.ФизическоеЛицо, "ФизическоеЛицо");
				Если Не СтрокаРезультат.ОпределятьПоОсновномуМестуРаботы Или СтрокаРезультат.ОпределеноАвтоматически Тогда
					Продолжить;
				КонецЕсли;
				// Получение настройки сотрудника по основному месту работы.
				Фильтр.Вставить("ФизическоеЛицо", ОсновноеМестоРаботы.ФизическоеЛицо);
				НастройкиСотрудникаПоОсновномуМестуРаботы = НастройкиФизическихЛиц.НайтиСтроки(Фильтр);
				Если НастройкиСотрудникаПоОсновномуМестуРаботы.Количество() > 0 Тогда
					НастройкаСотрудникаПоОсновномуМестуРаботы = НастройкиСотрудникаПоОсновномуМестуРаботы[0];
					Если Не НастройкаСотрудникаПоОсновномуМестуРаботы.ОпределятьПоОрганизации
						И Не НастройкаСотрудникаПоОсновномуМестуРаботы.ОпределятьПоОсновномуМестуРаботы
						И ЗначениеЗаполнено(НастройкаСотрудникаПоОсновномуМестуРаботы.Значение) Тогда
						
						СтрокаРезультат.Значение    = НастройкаСотрудникаПоОсновномуМестуРаботы.Значение;
						СтрокаРезультат.ТипЗначения = ТипЗнч(СтрокаРезультат.Значение);
						СтрокаРезультат.ОпределеноАвтоматически                   = Истина;
						СтрокаРезультат.ОпределеноПоОсновномуМестуРаботы          = Истина;
						СтрокаРезультат.ОрганизацияПоОсновномуМестуРаботы         = ОсновноеМестоРаботы.Организация;
						СтрокаРезультат.ГоловнаяОрганизацияПоОсновномуМестуРаботы = ОсновнаяГоловнаяОрганизация;
						НайтиИЗаполнитьБанковскиеРеквизитыСтрокиРезультата(СтрокаРезультат, БанковскиеРеквизиты);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		// Определение банковских реквизитов по основному месту работы.
		ОсновныеОрганизации = КоллекцииБЗК.УникальныеЗначенияКолонки(ОсновныеМестаРаботыФизическихЛиц, "Организация");
		НастройкиОсновныхОрганизаций = НастройкиПрямыхВыплатОрганизаций(ОсновныеОрганизации);
		Для Каждого НастройкиОсновнойОрганизации Из НастройкиОсновныхОрганизаций Цикл
			НайденныеСтрокиРезультат = ТаблицаРезультат.НайтиСтроки(ФильтрАвтозаполняемых);
			ПриАвтозаполненииНастроекФизическихЛицПоОрганизации(
				НастройкиОсновнойОрганизации,
				НайденныеСтрокиРезультат,
				БанковскиеРеквизиты,
				Истина);
		КонецЦикла;
	КонецЕсли;
	
	// Умолчание.
	Фильтр = Новый Структура;
	Фильтр.Вставить("ОпределятьАвтоматически", Истина);
	Фильтр.Вставить("ОпределеноАвтоматически", Ложь);
	Найденные = ТаблицаРезультат.НайтиСтроки(Фильтр);
	Если Найденные.Количество() > 0 Тогда
		Значение = КадровыйУчет.ВидКонтактнойИнформацииАдресМестаПроживанияФизическогоЛица();
		Для Каждого СтрокаРезультат Из Найденные Цикл
			СтрокаРезультат.ОпределеноАвтоматически = Истина;
			СтрокаРезультат.Значение = Значение;
			СтрокаРезультат.ТипЗначения = ТипЗнч(СтрокаРезультат.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ТаблицаРезультат", ТаблицаРезультат);
	Результат.Вставить("ГоловнаяОрганизация", ГоловнаяОрганизация);
	Результат.Вставить("НастройкиФизическихЛиц", НастройкиФизическихЛиц);
	Результат.Вставить("БанковскиеРеквизиты", БанковскиеРеквизиты);
	
	Возврат Результат;
КонецФункции

Процедура НайтиИЗаполнитьБанковскиеРеквизитыСтрокиРезультата(СтрокаРезультат, БанковскиеРеквизиты)
	Фильтр = Новый Структура("Значение, ФизическоеЛицо");
	Фильтр.Значение       = СтрокаРезультат.Значение;
	Фильтр.ФизическоеЛицо = СтрокаРезультат.ФизическоеЛицо;
	Найденные = БанковскиеРеквизиты.НайтиСтроки(Фильтр);
	Для Каждого СтрокаРеквизитов Из Найденные Цикл
		Если ЗначениеЗаполнено(СтрокаРеквизитов.Банк)
			И ЗначениеЗаполнено(СтрокаРеквизитов.НомерСчета) Тогда
			ЗаполнитьБанковскиеРеквизитыСтрокиРезультата(СтрокаРезультат, СтрокаРеквизитов, БанковскиеРеквизиты);
			Прервать;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьБанковскиеРеквизитыСтрокиРезультата(СтрокаРезультат, СтрокаРеквизитов, БанковскиеРеквизиты)
	ЗаполнитьЗначенияСвойств(СтрокаРезультат, СтрокаРеквизитов, "НомерСчета, Банк, НаименованиеБанка, БИК, КоррСчет");
	// В зарплатных проектах на данный момент нет возможности уточнить БИК отделения банка,
	//   в котором открыт счет конкретного сотрудника (физического лица).
	//   Бывает что зарплатный проект открыт в одном отделении банка (что отражено в реквизите "Банк" проекта),
	//   а счета сотрудников открыты в других отделениях банка.
	//   Банку для перечисления средств нужны только номера счетов, БИКи своих отделений он сам знает.
	//   Таким образом, в настройках выплаты зарплаты нет нужды хранить БИК банков отдельных сотрудников.
	//   И нет смысла разбивать зарплатные проекты по числу отделений банков сотрудников,
	//   поскольку в этом случае увеличится количество зарплатных ведомостей (усложнится работа бухгалтера).
	// Однако есть возможность создать банковский счет и указать в нем соответствующее отделение банка.
	//   Связь между банковским счетом и лицевым счетом - по владельцу (физическому лицу) и номеру счета.
	Если ТипЗнч(СтрокаРезультат.Значение) = Тип("СправочникСсылка.ЗарплатныеПроекты") Тогда
		ФильтрРеквизитов = Новый Структура("НомерСчета, ФизическоеЛицо, ПометкаУдаления");
		ФильтрРеквизитов.НомерСчета      = СтрокаРезультат.НомерСчета;
		ФильтрРеквизитов.ФизическоеЛицо  = СтрокаРезультат.ФизическоеЛицо;
		ФильтрРеквизитов.ПометкаУдаления = Ложь;
		Найденные = БанковскиеРеквизиты.НайтиСтроки(ФильтрРеквизитов);
		Для Каждого СпособВыплаты Из Найденные Цикл
			Если ТипЗнч(СпособВыплаты.Значение) = Тип("СправочникСсылка.ЗарплатныеПроекты")
				Или Не ЗначениеЗаполнено(СпособВыплаты.Банк)
				Или Не ЗначениеЗаполнено(СпособВыплаты.БИК) Тогда
				Продолжить;
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(СтрокаРезультат, СпособВыплаты, "Банк, НаименованиеБанка, БИК, КоррСчет");
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура ЗаполнитьСведенияОбАдресах(НастройкиСотрудников) Экспорт
	
	// Поиск строк для заполнения контактной информации.
	Фильтр = Новый Структура;
	Фильтр.Вставить("ТипЗначения", Тип("СправочникСсылка.ВидыКонтактнойИнформации"));
	ЗаполняемыеСтроки = НастройкиСотрудников.НайтиСтроки(Фильтр);
	Если ЗаполняемыеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Получение контактной информации.
	Копия = НастройкиСотрудников.Скопировать(ЗаполняемыеСтроки, "Значение, ФизическоеЛицо");
	ВладельцыКИ = Копия.ВыгрузитьКолонку("ФизическоеЛицо");
	Копия.Свернуть("Значение");
	ВидыКИ = Копия.ВыгрузитьКолонку("Значение");
	ТаблицаКИ = КонтактнаяИнформацияБЗК.КонтактнаяИнформацияОбъектов(ВладельцыКИ, , ВидыКИ);
	
	// Заполнение контактной информации.
	Для Каждого СтрокаРезультат Из ЗаполняемыеСтроки Цикл
		СтрокаКИ = КонтактнаяИнформацияБЗК.НайтиКонтактнуюИнформацию(
			ТаблицаКИ,
			СтрокаРезультат.ФизическоеЛицо,
			СтрокаРезультат.Значение);
		Если СтрокаКИ <> Неопределено Тогда
			СтрокаРезультат.ЗначениеАдреса      = СтрокаКИ.Значение;
			СтрокаРезультат.ПредставлениеАдреса = СтрокаКИ.Представление;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПредставлениеСпособаВыплаты(СтрокаРезультат) Экспорт
	Если СтрокаРезультат.Значение = Неопределено
		Или ТипЗнч(СтрокаРезультат.Значение) = Тип("СправочникСсылка.БанковскиеКартыКонтрагентов") Тогда
		Возврат "";
	КонецЕсли;
	
	Если ТипЗнч(СтрокаРезультат.Значение) = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
		Если ЗначениеЗаполнено(СтрокаРезультат.ПредставлениеАдреса) Тогда
			Возврат СтрокаРезультат.ПредставлениеАдреса;
		Иначе
			Возврат НСтр("ru = 'Адрес не заполнен';
						|en = 'Address is not filled in'");
		КонецЕсли;
	Иначе // Зарплатный проект или банковский счет.
		Если ЗначениеЗаполнено(СтрокаРезультат.НомерСчета) Тогда
			Возврат СтрШаблон(НСтр("ru = 'Счет № %1 в банке %2';
									|en = 'Account No. %1 with bank %2'"), СтрокаРезультат.НомерСчета, СтрокаРезультат.Банк);
		ИначеЕсли ЗначениеЗаполнено(СтрокаРезультат.Значение) Тогда
			Возврат НСтр("ru = 'Номер счета не указан';
						|en = 'Account number is not specified'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат "";
КонецФункции

Функция НастройкиФизическихЛиц(ФизическиеЛица)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеРегистра.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ДанныеРегистра.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ДанныеРегистра.ОпределятьПоОрганизации КАК ОпределятьПоОрганизации,
	|	ДанныеРегистра.ОпределятьПоОсновномуМестуРаботы КАК ОпределятьПоОсновномуМестуРаботы,
	|	ДанныеРегистра.Значение КАК Значение,
	|	ДанныеРегистра.ДатаИзменения КАК ДатаИзменения,
	|	ДанныеРегистра.Ответственный КАК Ответственный
	|ИЗ
	|	РегистрСведений.НастройкиПрямыхВыплатФСССотрудников КАК ДанныеРегистра
	|ГДЕ
	|	ДанныеРегистра.ФизическоеЛицо В(&ФизическиеЛица)";
	Запрос.УстановитьПараметр("ФизическиеЛица", ФизическиеЛица);
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

Функция ТаблицаЗарплатныхПроектовИБанковскихСчетов(ФизическиеЛица) Экспорт
	БанковскиеРеквизиты = Неопределено;
	СпособыПрямыхВыплатФССВнутренний.ПриОпределенииЗарплатныхПроектовИБанковскихСчетов(
		ФизическиеЛица,
		БанковскиеРеквизиты);
	Если БанковскиеРеквизиты <> Неопределено Тогда
		Возврат БанковскиеРеквизиты;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗарплатныеПроекты.Ссылка КАК Значение,
	|	ЗарплатныеПроекты.Представление КАК ПредставлениеЗначения,
	|	ЗарплатныеПроекты.ПометкаУдаления КАК ПометкаУдаления,
	|	ЗарплатныеПроекты.Банк КАК Банк,
	|	КлассификаторБанков.Наименование КАК НаименованиеБанка,
	|	КлассификаторБанков.Код КАК БИК,
	|	КлассификаторБанков.КоррСчет КАК КоррСчет,
	|	ЛицевыеСчета.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЛицевыеСчета.Организация КАК Организация,
	|	ЛицевыеСчета.НомерЛицевогоСчета КАК НомерСчета,
	|	ЛицевыеСчета.ДатаОткрытияЛицевогоСчета КАК ДатаОткрытияСчета,
	|	Организации.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ИСТИНА КАК ЯвляетсяМестомВыплатыЗарплаты
	|ИЗ
	|	РегистрСведений.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам КАК ЛицевыеСчета
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЗарплатныеПроекты КАК ЗарплатныеПроекты
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанков КАК КлассификаторБанков
	|			ПО ЗарплатныеПроекты.Банк = КлассификаторБанков.Ссылка
	|		ПО ЛицевыеСчета.ЗарплатныйПроект = ЗарплатныеПроекты.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО ЛицевыеСчета.Организация = Организации.Ссылка
	|ГДЕ
	|	ЛицевыеСчета.ФизическоеЛицо В(&ФизическиеЛица)";
	Запрос.УстановитьПараметр("ФизическиеЛица", ФизическиеЛица);
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

Функция ОсновныеМестаРаботыФизическихЛиц(ФизическиеЛица) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОсновныеСотрудникиФизическихЛиц.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	КадроваяИсторияСотрудниковИнтервальный.Организация КАК Организация,
	|	ОсновныеСотрудникиФизическихЛиц.ФизическоеЛицо КАК ФизическоеЛицо
	|ИЗ
	|	РегистрСведений.ОсновныеСотрудникиФизическихЛиц КАК ОсновныеСотрудникиФизическихЛиц
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК КадроваяИсторияСотрудниковИнтервальный
	|		ПО ОсновныеСотрудникиФизическихЛиц.Сотрудник = КадроваяИсторияСотрудниковИнтервальный.Сотрудник
	|			И (КадроваяИсторияСотрудниковИнтервальный.ДатаНачала В
	|				(ВЫБРАТЬ
	|					МАКСИМУМ(Т.ДатаНачала)
	|				ИЗ
	|					РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК Т
	|				ГДЕ
	|					ОсновныеСотрудникиФизическихЛиц.Сотрудник = Т.Сотрудник
	|					И ОсновныеСотрудникиФизическихЛиц.ДатаОкончания МЕЖДУ Т.ДатаНачала И Т.ДатаОкончания))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВидыЗанятостиСотрудниковИнтервальный КАК ВидыЗанятостиСотрудниковИнтервальный
	|		ПО ОсновныеСотрудникиФизическихЛиц.Сотрудник = ВидыЗанятостиСотрудниковИнтервальный.Сотрудник
	|			И (ВидыЗанятостиСотрудниковИнтервальный.ДатаНачала В
	|				(ВЫБРАТЬ
	|					МАКСИМУМ(Т.ДатаНачала)
	|				ИЗ
	|					РегистрСведений.ВидыЗанятостиСотрудниковИнтервальный КАК Т
	|				ГДЕ
	|					ОсновныеСотрудникиФизическихЛиц.Сотрудник = Т.Сотрудник
	|					И ОсновныеСотрудникиФизическихЛиц.ДатаОкончания МЕЖДУ Т.ДатаНачала И Т.ДатаОкончания))
	|ГДЕ
	|	ОсновныеСотрудникиФизическихЛиц.ФизическоеЛицо В(&ФизическиеЛица)
	|	И ОсновныеСотрудникиФизическихЛиц.ДатаОкончания = &МаксимальноеНачалоДня
	|	И ВидыЗанятостиСотрудниковИнтервальный.ВидЗанятости = &ОсновноеМестоРаботы";
	
	Запрос.УстановитьПараметр("ФизическиеЛица",        ФизическиеЛица);
	Запрос.УстановитьПараметр("МаксимальноеНачалоДня", '39991231000000');
	Запрос.УстановитьПараметр("ОсновноеМестоРаботы",   Перечисления.ВидыЗанятости.ОсновноеМестоРаботы);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Возврат Таблица;
КонецФункции

Функция СотрудникиОрганизации(Организация) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОсновныеСотрудникиФизическихЛиц.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ОсновныеСотрудникиФизическихЛиц.Сотрудник КАК Сотрудник,
	|	ОсновныеСотрудникиФизическихЛиц.ФизическоеЛицо КАК ФизическоеЛицо,
	|	КадроваяИсторияСотрудниковИнтервальный.Организация КАК Организация,
	|	КадроваяИсторияСотрудниковИнтервальный.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.ОсновныеСотрудникиФизическихЛиц КАК ОсновныеСотрудникиФизическихЛиц
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК КадроваяИсторияСотрудниковИнтервальный
	|		ПО ОсновныеСотрудникиФизическихЛиц.Сотрудник = КадроваяИсторияСотрудниковИнтервальный.Сотрудник
	|			И (КадроваяИсторияСотрудниковИнтервальный.ДатаНачала В
	|				(ВЫБРАТЬ
	|					МАКСИМУМ(Т.ДатаНачала)
	|				ИЗ
	|					РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК Т
	|				ГДЕ
	|					ОсновныеСотрудникиФизическихЛиц.Сотрудник = Т.Сотрудник
	|					И ОсновныеСотрудникиФизическихЛиц.ДатаОкончания МЕЖДУ Т.ДатаНачала И Т.ДатаОкончания))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВидыЗанятостиСотрудниковИнтервальный КАК ВидыЗанятостиСотрудниковИнтервальный
	|		ПО ОсновныеСотрудникиФизическихЛиц.Сотрудник = ВидыЗанятостиСотрудниковИнтервальный.Сотрудник
	|			И (ВидыЗанятостиСотрудниковИнтервальный.ДатаНачала В
	|				(ВЫБРАТЬ
	|					МАКСИМУМ(Т.ДатаНачала)
	|				ИЗ
	|					РегистрСведений.ВидыЗанятостиСотрудниковИнтервальный КАК Т
	|				ГДЕ
	|					ОсновныеСотрудникиФизическихЛиц.Сотрудник = Т.Сотрудник
	|					И ОсновныеСотрудникиФизическихЛиц.ДатаОкончания МЕЖДУ Т.ДатаНачала И Т.ДатаОкончания))
	|ГДЕ
	|	ОсновныеСотрудникиФизическихЛиц.ДатаОкончания = &МаксимальноеНачалоДня
	|	И КадроваяИсторияСотрудниковИнтервальный.Организация = &Организация
	|	И ВидыЗанятостиСотрудниковИнтервальный.ВидЗанятости <> &ВнутреннееСовместительство
	|	И ВидыЗанятостиСотрудниковИнтервальный.ВидЗанятости <> &Подработка
	|	И ВидыЗанятостиСотрудниковИнтервальный.ВидЗанятости <> &ПустойВидЗанятости";
	
	Запрос.УстановитьПараметр("Организация",                Организация);
	Запрос.УстановитьПараметр("МаксимальноеНачалоДня",      '39991231000000');
	Запрос.УстановитьПараметр("ВнутреннееСовместительство", Перечисления.ВидыЗанятости.ВнутреннееСовместительство);
	Запрос.УстановитьПараметр("Подработка",                 Перечисления.ВидыЗанятости.Подработка);
	Запрос.УстановитьПараметр("ПустойВидЗанятости",         Перечисления.ВидыЗанятости.ПустаяСсылка());
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Возврат Таблица;
КонецФункции

Функция ОрганизацииФизическихЛиц(ФизическиеЛица) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОсновныеСотрудникиФизическихЛиц.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ОсновныеСотрудникиФизическихЛиц.Сотрудник КАК Сотрудник,
	|	ОсновныеСотрудникиФизическихЛиц.ФизическоеЛицо КАК ФизическоеЛицо,
	|	КадроваяИсторияСотрудниковИнтервальный.Организация КАК Организация,
	|	КадроваяИсторияСотрудниковИнтервальный.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.ОсновныеСотрудникиФизическихЛиц КАК ОсновныеСотрудникиФизическихЛиц
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК КадроваяИсторияСотрудниковИнтервальный
	|		ПО ОсновныеСотрудникиФизическихЛиц.Сотрудник = КадроваяИсторияСотрудниковИнтервальный.Сотрудник
	|			И (КадроваяИсторияСотрудниковИнтервальный.ДатаНачала В
	|				(ВЫБРАТЬ
	|					МАКСИМУМ(Т.ДатаНачала)
	|				ИЗ
	|					РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК Т
	|				ГДЕ
	|					ОсновныеСотрудникиФизическихЛиц.Сотрудник = Т.Сотрудник
	|					И ОсновныеСотрудникиФизическихЛиц.ДатаОкончания МЕЖДУ Т.ДатаНачала И Т.ДатаОкончания))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВидыЗанятостиСотрудниковИнтервальный КАК ВидыЗанятостиСотрудниковИнтервальный
	|		ПО ОсновныеСотрудникиФизическихЛиц.Сотрудник = ВидыЗанятостиСотрудниковИнтервальный.Сотрудник
	|			И (ВидыЗанятостиСотрудниковИнтервальный.ДатаНачала В
	|				(ВЫБРАТЬ
	|					МАКСИМУМ(Т.ДатаНачала)
	|				ИЗ
	|					РегистрСведений.ВидыЗанятостиСотрудниковИнтервальный КАК Т
	|				ГДЕ
	|					ОсновныеСотрудникиФизическихЛиц.Сотрудник = Т.Сотрудник
	|					И ОсновныеСотрудникиФизическихЛиц.ДатаОкончания МЕЖДУ Т.ДатаНачала И Т.ДатаОкончания))
	|ГДЕ
	|	ОсновныеСотрудникиФизическихЛиц.ДатаОкончания = &МаксимальноеНачалоДня
	|	И КадроваяИсторияСотрудниковИнтервальный.ФизическоеЛицо В (&ФизическиеЛица)
	|	И ВидыЗанятостиСотрудниковИнтервальный.ВидЗанятости <> &ВнутреннееСовместительство
	|	И ВидыЗанятостиСотрудниковИнтервальный.ВидЗанятости <> &Подработка
	|	И ВидыЗанятостиСотрудниковИнтервальный.ВидЗанятости <> &ПустойВидЗанятости";
	
	Запрос.УстановитьПараметр("ФизическиеЛица",             ФизическиеЛица);
	Запрос.УстановитьПараметр("МаксимальноеНачалоДня",      '39991231000000');
	Запрос.УстановитьПараметр("ВнутреннееСовместительство", Перечисления.ВидыЗанятости.ВнутреннееСовместительство);
	Запрос.УстановитьПараметр("Подработка",                 Перечисления.ВидыЗанятости.Подработка);
	Запрос.УстановитьПараметр("ПустойВидЗанятости",         Перечисления.ВидыЗанятости.ПустаяСсылка());
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Возврат Таблица;
КонецФункции

Функция НастройкиПрямыхВыплатОрганизаций(Организации)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	Организации.Ссылка КАК Организация,
	|	ЕСТЬNULL(ДанныеРегистра.ИспользоватьЗарплатныйПроект, ЛОЖЬ) КАК ИспользоватьЗарплатныйПроект,
	|	ЕСТЬNULL(ДанныеРегистра.ЗарплатныйПроект, НЕОПРЕДЕЛЕНО) КАК ЗарплатныйПроект,
	|	ЕСТЬNULL(ДанныеРегистра.ИспользоватьЗарплатныйБанковскийСчет, ИСТИНА) КАК ИспользоватьЗарплатныйБанковскийСчет,
	|	ЕСТЬNULL(ДанныеРегистра.ИспользоватьОсновноеМестоРаботы, ИСТИНА) КАК ИспользоватьОсновноеМестоРаботы
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиПрямыхВыплатФССОрганизаций КАК ДанныеРегистра
	|		ПО (ДанныеРегистра.Организация = Организации.Ссылка)
	|ГДЕ
	|	Организации.Ссылка В(&Организации)";
	Запрос.УстановитьПараметр("Организации", Организации);
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

// Определение банковских реквизитов по организации, заполнение флажка ОпределятьПоОсновномуМестуРаботы.
Процедура ПриАвтозаполненииНастроекФизическихЛицПоОрганизации(НастройкиОрганизации, НайденныеСтрокиРезультат,
		БанковскиеРеквизиты, ЭтоНастройкиСовместителяПоОсновномуМестуРаботы)
	// Подготовка фильтров для поиска зарплатных проектов.
	ИспользоватьФильтр1 = НастройкиОрганизации.ИспользоватьЗарплатныйПроект
		И ЗначениеЗаполнено(НастройкиОрганизации.ЗарплатныйПроект);
	Если ИспользоватьФильтр1 Тогда
		Фильтр1 = Новый Структура("Организация, Значение, ФизическоеЛицо");
		Фильтр1.Организация = НастройкиОрганизации.Организация;
		Фильтр1.Значение    = НастройкиОрганизации.ЗарплатныйПроект;
	КонецЕсли;
	ИспользоватьФильтр2 = НастройкиОрганизации.ИспользоватьЗарплатныйБанковскийСчет;
	Если ИспользоватьФильтр2 Тогда
		Фильтр2 = Новый Структура("Организация, ЯвляетсяМестомВыплатыЗарплаты, ФизическоеЛицо");
		Фильтр2.Организация = НастройкиОрганизации.Организация;
		Фильтр2.ЯвляетсяМестомВыплатыЗарплаты = Истина;
	КонецЕсли;
	// Обход сотрудников.
	Для Каждого СтрокаРезультат Из НайденныеСтрокиРезультат Цикл
		// Поиск зарплатных проектов.
		Если ИспользоватьФильтр1 Тогда
			Фильтр1.ФизическоеЛицо = СтрокаРезультат.ФизическоеЛицо;
			Найденные = БанковскиеРеквизиты.НайтиСтроки(Фильтр1);
		Иначе
			Найденные = Новый Массив;
		КонецЕсли;
		Если ИспользоватьФильтр2 Тогда
			Фильтр2.ФизическоеЛицо = СтрокаРезультат.ФизическоеЛицо;
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
				Найденные,
				БанковскиеРеквизиты.НайтиСтроки(Фильтр2));
		КонецЕсли;
		Для Каждого СтрокаРеквизитов Из Найденные Цикл
			Если ЗначениеЗаполнено(СтрокаРеквизитов.Банк)
				И ЗначениеЗаполнено(СтрокаРеквизитов.НомерСчета) Тогда
				СтрокаРезультат.Значение    = СтрокаРеквизитов.Значение;
				СтрокаРезультат.ТипЗначения = ТипЗнч(СтрокаРезультат.Значение);
				ЗаполнитьБанковскиеРеквизитыСтрокиРезультата(СтрокаРезультат, СтрокаРеквизитов, БанковскиеРеквизиты);
				Если ЭтоНастройкиСовместителяПоОсновномуМестуРаботы Тогда
					СтрокаРезультат.ОпределеноПоОсновномуМестуРаботы          = Истина;
					СтрокаРезультат.ОрганизацияПоОсновномуМестуРаботы         = НастройкиОрганизации.Организация;
					СтрокаРезультат.ГоловнаяОрганизацияПоОсновномуМестуРаботы = НастройкиОрганизации.ГоловнаяОрганизация;
				Иначе
					СтрокаРезультат.ОпределеноПоОрганизации = Истина;
				КонецЕсли;
				СтрокаРезультат.ОпределеноАвтоматически = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		// Если не получилось - будет определено по основному месту работы.
		Если Не ЭтоНастройкиСовместителяПоОсновномуМестуРаботы
			И Не СтрокаРезультат.ОпределеноПоОрганизации Тогда
			СтрокаРезультат.ОпределятьПоОсновномуМестуРаботы = НастройкиОрганизации.ИспользоватьОсновноеМестоРаботы;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция ПустаяТаблицаНастроекСотрудников()
	МетаданныеРегистра = Метаданные.РегистрыСведений.НастройкиПрямыхВыплатФСССотрудников;
	ОписаниеТиповБулево      = Новый ОписаниеТипов("Булево");
	ОписаниеТиповСтрока      = Новый ОписаниеТипов("Строка");
	ОписаниеТиповОрганизация = Новый ОписаниеТипов("СправочникСсылка.Организации");
	
	Таблица = Новый ТаблицаЗначений;
	// Данные регистра.
	Таблица.Колонки.Добавить("ГоловнаяОрганизация",  МетаданныеРегистра.Измерения.ГоловнаяОрганизация.Тип);
	Таблица.Колонки.Добавить("ФизическоеЛицо",       МетаданныеРегистра.Измерения.ФизическоеЛицо.Тип);
	Таблица.Колонки.Добавить("ДатаИзменения",        МетаданныеРегистра.Реквизиты.ДатаИзменения.Тип);
	Таблица.Колонки.Добавить("Ответственный",        МетаданныеРегистра.Реквизиты.Ответственный.Тип);
	Таблица.Колонки.Добавить("Значение",             МетаданныеРегистра.Ресурсы.Значение.Тип);
	// Кэш по данным регистра.
	Таблица.Колонки.Добавить("ТипЗначения", Новый ОписаниеТипов("Тип"));
	// Автоопределение по текущему месту работы.
	Таблица.Колонки.Добавить("ОпределятьПоОрганизации", ОписаниеТиповБулево);
	Таблица.Колонки.Добавить("ОпределеноПоОрганизации", ОписаниеТиповБулево);
	Таблица.Колонки.Добавить("Организация",             ОписаниеТиповОрганизация);
	// Автоопределение по основному месту работы.
	Таблица.Колонки.Добавить("ОпределятьПоОсновномуМестуРаботы",          ОписаниеТиповБулево);
	Таблица.Колонки.Добавить("ОпределеноПоОсновномуМестуРаботы",          ОписаниеТиповБулево);
	Таблица.Колонки.Добавить("ОрганизацияПоОсновномуМестуРаботы",         ОписаниеТиповОрганизация);
	Таблица.Колонки.Добавить("ГоловнаяОрганизацияПоОсновномуМестуРаботы", ОписаниеТиповОрганизация);
	// Кэш автоопределения.
	Таблица.Колонки.Добавить("ОпределятьАвтоматически", ОписаниеТиповБулево);
	Таблица.Колонки.Добавить("ОпределеноАвтоматически", ОписаниеТиповБулево);
	// Реквизиты счета.
	Таблица.Колонки.Добавить("НомерСчета",        Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(20)));
	Таблица.Колонки.Добавить("Банк",              Новый ОписаниеТипов("СправочникСсылка.КлассификаторБанков"));
	Таблица.Колонки.Добавить("НаименованиеБанка", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(256)));
	Таблица.Колонки.Добавить("БИК",               Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(9)));
	Таблица.Колонки.Добавить("КоррСчет",          Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(20)));
	// Реквизиты адреса.
	Таблица.Колонки.Добавить("ЗначениеАдреса",      ОписаниеТиповСтрока);
	Таблица.Колонки.Добавить("ПредставлениеАдреса", ОписаниеТиповСтрока);
	
	Возврат Таблица;
КонецФункции

Функция ТипыСпособовПрямыхВыплат() Экспорт
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("ИмяТипа");
	Результат.Колонки.Добавить("Заголовок");
	Результат.Колонки.Добавить("СпособВыплатыПособия");
	Результат.Колонки.Добавить("Тип");
	
	ОписаниеСпособа = Результат.Добавить();
	ОписаниеСпособа.ИмяТипа   = "СправочникСсылка.БанковскиеКартыКонтрагентов";
	ОписаниеСпособа.Заголовок = НСтр("ru = 'На карту МИР';
									|en = 'To MIR card'");
	ОписаниеСпособа.СпособВыплатыПособия = Перечисления.СпособыВыплатыПособия.НаКартуМИР;
	
	ОписаниеСпособа = Результат.Добавить();
	ОписаниеСпособа.ИмяТипа   = "СправочникСсылка.ЗарплатныеПроекты";
	ОписаниеСпособа.Заголовок = НСтр("ru = 'На счет зарплатного проекта';
									|en = 'To the payroll card program account'");
	ОписаниеСпособа.СпособВыплатыПособия = Перечисления.СпособыВыплатыПособия.ЧерезБанк;
	
	ОписаниеСпособа = Результат.Добавить();
	ОписаниеСпособа.ИмяТипа   = "СправочникСсылка.ВидыКонтактнойИнформации";
	ОписаниеСпособа.Заголовок = НСтр("ru = 'Почтовым переводом';
									|en = 'As a postal order'");
	ОписаниеСпособа.СпособВыплатыПособия = Перечисления.СпособыВыплатыПособия.ПочтовымПереводом;
	
	СпособыПрямыхВыплатФССВнутренний.ПриОпределенииСпособовПрямыхВыплат(Результат);
	
	Найденные = Результат.НайтиСтроки(Новый Структура("Тип", Неопределено));
	Для Каждого ОписаниеСпособа Из Найденные Цикл
		ОписаниеСпособа.Тип = Тип(ОписаниеСпособа.ИмяТипа);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Функция КоррСчетБанка(Банк, БИК) Экспорт
	Если ЗначениеЗаполнено(Банк) Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Банк, "КоррСчет");
	КонецЕсли;
	Если ЗначениеЗаполнено(БИК) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	КлассификаторБанков.КоррСчет КАК КоррСчет
		|ИЗ
		|	Справочник.КлассификаторБанков КАК КлассификаторБанков
		|ГДЕ
		|	КлассификаторБанков.Код = &БИК";
		Запрос.УстановитьПараметр("БИК", БИК);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Возврат Выборка.КоррСчет
		КонецЕсли;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Процедура ЗаписатьОшибку(ОбъектМетаданных, ОбъектДанных, ТекстОшибки) Экспорт
	ЗаписьЖурналаРегистрации(
		ИмяСобытияЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Ошибка,
		ОбъектМетаданных,
		ОбъектДанных,
		ТекстОшибки);
	СообщенияБЗК.СообщитьОПроблеме(ТекстОшибки, ОбъектДанных);
КонецПроцедуры

// Возвращает строковую константу для формирования сообщений журнала регистрации.
//
// Возвращаемое значение:
//   Строка - текст события журнала регистрации.
//
Функция ИмяСобытияЖурналаРегистрации()
	Возврат НСтр("ru = 'ФСС. Настройки прямых выплат';
				|en = 'SSF. Direct payment settings'", ОбщегоНазначения.КодОсновногоЯзыка());
КонецФункции

#КонецОбласти
