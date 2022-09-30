///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЭтотОбъект.Справочник_Новости_ПустаяСсылка = Справочники.Новости.ПустаяСсылка();

	// Получить таблицу метаданных единожды, чтобы потом передавать ее в форму документа.
	ЭтотОбъект.ТаблицаМетаданных.Загрузить(ОбработкаНовостейПовтИсп.ПолучитьТаблицуМетаданных());

	ПараметрыТекущегоПользователя = ОбработкаНовостейПовтИсп.ПараметрыТекущегоПользователя();

	СкрытьПредупреждениеДекорацияМодельСервисаРазделенныйСеанс = Истина;

	// В конфигурации есть общие реквизиты с разделением и включена ФО РаботаВМоделиСервиса.
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		// Если вошли в область данных, то нельзя пересчитывать служебные данные.
		Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
			ЭтотОбъект.ТолькоПросмотр = Истина;
			СкрытьПредупреждениеДекорацияМодельСервисаРазделенныйСеанс = Ложь;
		КонецЕсли;
		// Если включено разделение данных, и мы зашли в неразделенном сеансе,
		//  то нельзя устанавливать пользовательские свойства новости.
		// Зашли в конфигурацию под пользователем без разделения (и не вошли в область данных).
		Если ИнтернетПоддержкаПользователей.СеансЗапущенБезРазделителей() Тогда
			ПолучитьТекущегоПользователя = Ложь;
			// В этом режиме редактировать новости может только пользователь с ролями АдминистраторСистемы и ПолныеПрава (все локальные ленты новостей).
			лкВариантСпискаЛентНовостей = "Только для администратора"; // Идентификатор.
		Иначе
			ПолучитьТекущегоПользователя = Истина;
			// В этом режиме редактировать новости никто не может.
			лкВариантСпискаЛентНовостей = "Нет";
		КонецЕсли;
	Иначе
		ПолучитьТекущегоПользователя = Истина;
		// В этом режиме редактировать новости может пользователь с ролями АдминистраторСистемы и ПолныеПрава (все локальные ленты новостей)
		//  или пользователь с ролью РедактированиеНовостей.
		лкВариантСпискаЛентНовостей = "Для администратора или редактора новостей"; // Идентификатор.
	КонецЕсли;

	Элементы.ДекорацияМодельСервисаРазделенныйСеанс.Видимость = НЕ СкрытьПредупреждениеДекорацияМодельСервисаРазделенныйСеанс;

	Если ПолучитьТекущегоПользователя = Истина Тогда
		ЭтотОбъект.ПараметрыСеанса_ТекущийПользователь = Пользователи.ТекущийПользователь();
	Иначе
		ЭтотОбъект.ПараметрыСеанса_ТекущийПользователь = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;

	// Получить список локальных лент новостей, в которых можно редактировать новости:
	// - Для пользователя с ролью АдминистрированиеСистемы и ПолныеПрава можно редактировать все ленты новостей,
	//    у которых ЗагруженоССервера = Ложь и ЛокальнаяЛентаНовостей = Истина;
	// - Для пользователей с ролью РедактированиеНовостей можно редактировать только
	//    разрешенные ему ленты новостей (из регистра сведений РазрешенныеДляРедактированияЛентыНовостей).
	Если лкВариантСпискаЛентНовостей = "Только для администратора" Тогда // Идентификатор.
		Если (ПараметрыТекущегоПользователя.ЕстьРольПолныеПрава = Истина)
				И (ПараметрыТекущегоПользователя.ЕстьРольАдминистраторСистемы = Истина) Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = "
				|ВЫБРАТЬ
				|	Спр.Ссылка КАК ЛентаНовостей
				|ИЗ
				|	Справочник.ЛентыНовостей КАК Спр
				|ГДЕ
				|	Спр.ЗагруженоССервера = ЛОЖЬ
				|	И Спр.ЛокальнаяЛентаНовостей = ИСТИНА
				|";
			Результат = Запрос.Выполнить(); // Справочник.Новости.ФормаСпискаДляРедактирования.ПриСозданииНаСервере(), РольПолныеПрава.
			Если НЕ Результат.Пустой() Тогда
				ЭтотОбъект.РазрешенныеДляРедактированияЛентыНовостей.ЗагрузитьЗначения(Результат.Выгрузить(ОбходРезультатаЗапроса.Прямой).ВыгрузитьКолонку("ЛентаНовостей"));
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли лкВариантСпискаЛентНовостей = "Для администратора или редактора новостей" Тогда // Идентификатор.
		Если (ПараметрыТекущегоПользователя.ЕстьРольПолныеПрава = Истина)
				И (ПараметрыТекущегоПользователя.ЕстьРольАдминистраторСистемы = Истина) Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = "
				|ВЫБРАТЬ
				|	Спр.Ссылка КАК ЛентаНовостей
				|ИЗ
				|	Справочник.ЛентыНовостей КАК Спр
				|ГДЕ
				|	Спр.ЗагруженоССервера = ЛОЖЬ
				|	И Спр.ЛокальнаяЛентаНовостей = ИСТИНА
				|";
			Результат = Запрос.Выполнить(); // Справочник.Новости.ФормаСпискаДляРедактирования.ПриСозданииНаСервере(), РольПолныеПрава
			Если НЕ Результат.Пустой() Тогда
				ЭтотОбъект.РазрешенныеДляРедактированияЛентыНовостей.ЗагрузитьЗначения(Результат.Выгрузить(ОбходРезультатаЗапроса.Прямой).ВыгрузитьКолонку("ЛентаНовостей"));
			КонецЕсли;
		ИначеЕсли (ПараметрыТекущегоПользователя.ЕстьРольРедактированиеНовостей = Истина) Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = "
				|ВЫБРАТЬ
				|	Рег.ЛентаНовостей КАК ЛентаНовостей
				|ИЗ
				|	РегистрСведений.РазрешенныеДляРедактированияЛентыНовостей КАК Рег
				|ГДЕ
				|	Рег.Пользователь = &ТекущийПользователь
				|	И Рег.ЛентаНовостей.ЗагруженоССервера = ЛОЖЬ
				|	И Рег.ЛентаНовостей.ЛокальнаяЛентаНовостей = ИСТИНА
				|";
			Запрос.УстановитьПараметр("ТекущийПользователь", ЭтотОбъект.ПараметрыСеанса_ТекущийПользователь);
			Результат = Запрос.Выполнить(); // Справочник.Новости.ФормаСпискаДляРедактирования.ПриСозданииНаСервере(), РольРедактированиеНовостей
			Если НЕ Результат.Пустой() Тогда
				ЭтотОбъект.РазрешенныеДляРедактированияЛентыНовостей.ЗагрузитьЗначения(Результат.Выгрузить(ОбходРезультатаЗапроса.Прямой).ВыгрузитьКолонку("ЛентаНовостей"));
			КонецЕсли;
		КонецЕсли;
	Иначе // Если лкВариантСпискаЛентНовостей = "Нет" Тогда
	КонецЕсли;

	ЭтотОбъект.НеобходимПересчетСлужебныхДанных = Ложь;

	УстановитьУсловноеОформление();

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если ЗавершениеРаботы = Истина Тогда
		// Запрещены серверные вызовы и открытие форм.
		Если ЭтотОбъект.НеобходимПересчетСлужебныхДанных = Истина Тогда
			Отказ = Истина;
			ТекстПредупреждения = НСтр("ru = 'Необходим пересчет служебных данных.
				|Нажмите кнопку [Пересчет служебных данных]
				|или закройте окно вручную, до выхода из программы.';
				|en = 'Recalculate the service data.
				|Click [Service data recalculation] or close the window manually 
				|before exiting the application.'");
		КонецЕсли;
	Иначе
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	Если ЗавершениеРаботы = Истина Тогда
		// Запрещены серверные вызовы и открытие форм.
		// В таком исключительном случае, когда выходят из программы,
		//  можно проигнорировать установку признака прочтенности у новостей.
	Иначе
		Если ЭтотОбъект.НеобходимПересчетСлужебныхДанных = Истина Тогда
			ПересчетСлужебныхДанныхНаСервере();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	ТипСтруктура = Тип("Структура");
	ТипНовость   = Тип("СправочникСсылка.Новости");

	Если ИмяСобытия = "Новости: скопированы все категории" Тогда
		Если ТипЗнч(Параметр) = ТипСтруктура Тогда
			ЗаполнитьБуферОбменаКатегорийСервер(Параметр);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "Новости: после записи новости" Тогда
		Если ТипЗнч(Источник) = ТипНовость Тогда
			ЭтотОбъект.НеобходимПересчетСлужебныхДанных = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Список

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)

	лкТекущаяСтрока = Элементы.НовостиСписок.ТекущаяСтрока;

	Отказ = Истина;

	// Нельзя добавлять новости, если нет ни одной локальной ленты новостей, где можно редактировать новости.
	// Разрешено редактировать все локальные ленты новостей пользователю с ролями АдминистраторСистемы и ПолныеПрава.
	// Разрешено редактировать разрешенные администратором локальные ленты новостей пользователю с ролью РедактированиеНовостей.
	Если ЭтотОбъект.РазрешенныеДляРедактированияЛентыНовостей.Количество()=0 Тогда
		ТекстСообщения = НСтр("ru = 'Нельзя добавлять новости, если нет ни одной локальной ленты новостей, где разрешено редактирование.
			|Пользователю с ролями АдминистраторСистемы и ПолныеПрава можно редактировать все локальные ленты новостей.
			|Пользователю с ролью РедактированиеНовостей можно редактировать разрешенные Администратором локальные ленты новостей.';
			|en = 'You cannot add news if there are no local news feeds where editing is allowed.
			|User with the АдминистраторСистемы and ПолныеПрава roles can edit all local news feeds.
			|User with the РедактированиеНовостей role can edit the local news feeds allowed by Administrator.'");
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	Если Копирование = Истина Тогда
		ПараметрыОткрытия = СформироватьПараметрыОткрытияФормыРедактированияНовости(
			ЭтотОбъект.Справочник_Новости_ПустаяСсылка,
			Копирование,
			лкТекущаяСтрока,
			0); // СтатусНовостиНаСервере = 0 (нет на сервере, т.к. у локальной базы нет соединения с новостным центром)
		ОткрытьФорму(
			"Справочник.Новости.Форма.ФормаДокумента",
			ПараметрыОткрытия,
			ЭтотОбъект,
			лкТекущаяСтрока);
	Иначе
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			ПараметрыОткрытия = СформироватьПараметрыОткрытияФормыРедактированияНовости(
				ЭтотОбъект.Справочник_Новости_ПустаяСсылка,
				Копирование,
				ЭтотОбъект.Справочник_Новости_ПустаяСсылка,
				0); // СтатусНовостиНаСервере = 0 (нет на сервере, т.к. у локальной базы нет соединения с новостным центром)
			ОткрытьФорму(
				"Справочник.Новости.Форма.ФормаДокумента",
				ПараметрыОткрытия,
				ЭтотОбъект,
				лкТекущаяСтрока);
		Иначе // Пустой список - новая база?
			ПараметрыОткрытия = СформироватьПараметрыОткрытияФормыРедактированияНовости(
				ЭтотОбъект.Справочник_Новости_ПустаяСсылка,
				Копирование,
				ЭтотОбъект.Справочник_Новости_ПустаяСсылка,
				0); // Нет на сервере вообще
			ОткрытьФорму(
				"Справочник.Новости.Форма.ФормаДокумента",
				ПараметрыОткрытия,
				ЭтотОбъект,
				лкТекущаяСтрока);
		КонецЕсли;
	КонецЕсли;

	// Оповестить открытую форму о содержимом буфера обмена.
	// Передавать надо список значений со структурами.
	КлючОбъекта = "Документы.Новости.КатегорииПростые";
	ТекущийБуферОбмена = Новый СписокЗначений;
	Для каждого ТекущаяСтрока Из ЭтотОбъект.БуферОбмена_КатегорииПростые Цикл
		СтруктураДанных = ОбработкаНовостейКлиентСервер.ПолучитьОписаниеПолейБуфераОбмена(КлючОбъекта);
		ЗаполнитьЗначенияСвойств(СтруктураДанных, ТекущаяСтрока);
		ТекущийБуферОбмена.Добавить(СтруктураДанных);
	КонецЦикла;
	Оповестить(
		"БуферОбмена: скопировано значение", // Идентификатор.
		ТекущийБуферОбмена,
		Новый Структура("Ссылка, КлючОбъекта", Неопределено, КлючОбъекта));

	КлючОбъекта = "Документы.Новости.КатегорииИнтервалыВерсий";
	ТекущийБуферОбмена = Новый СписокЗначений;
	Для каждого ТекущаяСтрока Из ЭтотОбъект.БуферОбмена_КатегорииИнтервалыВерсий Цикл
		СтруктураДанных = ОбработкаНовостейКлиентСервер.ПолучитьОписаниеПолейБуфераОбмена(КлючОбъекта);
		ЗаполнитьЗначенияСвойств(СтруктураДанных, ТекущаяСтрока);
		ТекущийБуферОбмена.Добавить(СтруктураДанных);
	КонецЦикла;
	Оповестить(
		"БуферОбмена: скопировано значение", // Идентификатор.
		ТекущийБуферОбмена,
		Новый Структура("Ссылка, КлючОбъекта", Неопределено, КлючОбъекта));

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)

	Отказ = Истина;

	// Нельзя редактировать новости, если нет ни одной локальной ленты новостей, где можно редактировать новости.
	// Разрешено редактировать все локальные ленты новостей пользователю с ролями АдминистраторСистемы и ПолныеПрава.
	// Разрешено редактировать разрешенные администратором локальные ленты новостей пользователю с ролью РедактированиеНовостей.
	Если ЭтотОбъект.РазрешенныеДляРедактированияЛентыНовостей.НайтиПоЗначению(Элемент.ТекущиеДанные.ЛентаНовостей) = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Можно изменять новости только в локальной ленте новостей, где разрешено редактирование.
			|Пользователю с ролями АдминистраторСистемы и ПолныеПрава можно редактировать все локальные ленты новостей.
			|Пользователю с ролью РедактированиеНовостей можно редактировать разрешенные Администратором локальные ленты новостей.';
			|en = 'It is allowed to change news only in the local news feed where editing is allowed.
			|User with the АдминистраторСистемы and ПолныеПрава roles can edit all local news feeds.
			|User with the РедактированиеНовостей role can edit the local news feeds allowed by Administrator.'");
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
		// Возврат; // Форма откроется,но будет только для просмотра.
	КонецЕсли;

	лкТекущаяСтрока = Элементы.НовостиСписок.ТекущаяСтрока;

	ПараметрыОткрытия = СформироватьПараметрыОткрытияФормыРедактированияНовости(
		лкТекущаяСтрока, // Ключ
		Ложь, // Копирование
		ЭтотОбъект.Справочник_Новости_ПустаяСсылка, // ЗначениеКопирования
		0); // СтатусНовостиНаСервере = 0 (нет на сервере, т.к. у локальной базы нет соединения с новостным центром)

	ОткрытьФорму(
		"Справочник.Новости.Форма.ФормаДокумента",
		ПараметрыОткрытия,
		ЭтотОбъект,
		лкТекущаяСтрока);

	// Оповестить открытую форму о содержимом буфера обмена.
	// Передавать надо список значений со структурами.
	КлючОбъекта = "Документы.Новости.КатегорииПростые";
	ТекущийБуферОбмена = Новый СписокЗначений;
	Для каждого ТекущаяСтрока Из ЭтотОбъект.БуферОбмена_КатегорииПростые Цикл
		СтруктураДанных = ОбработкаНовостейКлиентСервер.ПолучитьОписаниеПолейБуфераОбмена(КлючОбъекта);
		ЗаполнитьЗначенияСвойств(СтруктураДанных, ТекущаяСтрока);
		ТекущийБуферОбмена.Добавить(СтруктураДанных);
	КонецЦикла;
	Оповестить(
		"БуферОбмена: скопировано значение",
		ТекущийБуферОбмена,
		Новый Структура("Ссылка, КлючОбъекта", Неопределено, КлючОбъекта));

	КлючОбъекта = "Документы.Новости.КатегорииИнтервалыВерсий";
	ТекущийБуферОбмена = Новый СписокЗначений;
	Для каждого ТекущаяСтрока Из ЭтотОбъект.БуферОбмена_КатегорииИнтервалыВерсий Цикл
		СтруктураДанных = ОбработкаНовостейКлиентСервер.ПолучитьОписаниеПолейБуфераОбмена(КлючОбъекта);
		ЗаполнитьЗначенияСвойств(СтруктураДанных, ТекущаяСтрока);
		ТекущийБуферОбмена.Добавить(СтруктураДанных);
	КонецЦикла;
	Оповестить(
		"БуферОбмена: скопировано значение",
		ТекущийБуферОбмена,
		Новый Структура("Ссылка, КлючОбъекта", Неопределено, КлючОбъекта));

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПересчетСлужебныхДанных(Команда)

	ПересчетСлужебныхДанныхНаСервере();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
// Формирует структуру параметров для открытия формы редактирования новости.
//
// Параметры:
//  Ключ                   - СправочникСсылка.Новости;
//  Копирование            - Булево;
//  ЗначениеКопирования    - СправочникСсылка.Новости;
//  СтатусНовостиНаСервере - Число:
//    * 0 - Нет на сервере вообще;
//    * 1 - Есть на сервере, но не опубликована;
//    * 2 - Есть на сервере, опубликована, можно повторно публиковать;
//    * 3 - Есть на сервере, опубликована, нельзя повторно публиковать;
//    * 4 - Все остальное.
//
// Возвращаемое значение:
//   Структура.
//
Функция СформироватьПараметрыОткрытияФормыРедактированияНовости(Ключ, Копирование, ЗначениеКопирования, СтатусНовостиНаСервере)

	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ключ", Ключ);
	ПараметрыОткрытия.Вставить("Копирование", Копирование);
	ПараметрыОткрытия.Вставить("ЗначениеКопирования", ЗначениеКопирования);
	ПараметрыОткрытия.Вставить("СтатусНовостиНаСервере", СтатусНовостиНаСервере);
	ПараметрыОткрытия.Вставить("ТаблицаМетаданных", ЭтотОбъект.ТаблицаМетаданных);
	ПараметрыОткрытия.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	ПараметрыОткрытия.Вставить("БезАвторизации", Истина);
	ПараметрыОткрытия.Вставить("БуферОбмена_КатегорииПростые", ЭтотОбъект.БуферОбмена_КатегорииПростые);
	ПараметрыОткрытия.Вставить("БуферОбмена_КатегорииИнтервалыВерсий", ЭтотОбъект.БуферОбмена_КатегорииИнтервалыВерсий);
	ПараметрыОткрытия.Вставить("РазрешенныеДляРедактированияЛентыНовостей", ЭтотОбъект.РазрешенныеДляРедактированияЛентыНовостей);

	Возврат ПараметрыОткрытия;

КонецФункции

&НаСервере
// Заполняет реквизиты формы БуферОбмена_КатегорииПростые и БуферОбмена_КатегорииИнтервалыВерсий по переданной структуре.
//
// Параметры:
//  БуферыОбмена - Структура - структура с ключами:
//   * БуферОбмена_КатегорииПростые;
//   * БуферОбмена_КатегорииИнтервалыВерсий.
//
Процедура ЗаполнитьБуферОбменаКатегорийСервер(БуферыОбмена)

	Если БуферыОбмена.Свойство("БуферОбмена_КатегорииПростые") Тогда
		ЭтотОбъект.БуферОбмена_КатегорииПростые.Загрузить(БуферыОбмена.БуферОбмена_КатегорииПростые.Выгрузить());
	КонецЕсли;
	Если БуферыОбмена.Свойство("БуферОбмена_КатегорииИнтервалыВерсий") Тогда
		ЭтотОбъект.БуферОбмена_КатегорииИнтервалыВерсий.Загрузить(БуферыОбмена.БуферОбмена_КатегорииИнтервалыВерсий.Выгрузить());
	КонецЕсли;

КонецПроцедуры

// Процедура устанавливает условное оформление в форме.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// 1. Новости из нелокальных лент новостей (которые нельзя редактировать) - серым цветом.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Наименование.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДатаПубликации.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.УИННовости.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЛентаНовостей.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Ссылка.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("НовостиСписок.ЛентаНовостей");
		ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеВСписке;
		ОтборЭлемента.ПравоеЗначение = ЭтотОбъект.РазрешенныеДляРедактированияЛентыНовостей;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);

		// Использование
		Элемент.Использование = Истина;

КонецПроцедуры

// Процедура пересчитывает разные служебные данные, необходимые для корректной работы механизмов подсистемы "Новости":
//  - важность новостей;
//  - привязка к метаданным;
//  - настроенные отборы;
//  - и т.п.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура ПересчетСлужебныхДанныхНаСервере()

	НаименованиеПроцедурыФункции = "ПересчетСлужебныхДанныхНаСервере"; // Идентификатор.

	ЗаписыватьВЖурналРегистрации = Истина;

	КонтекстВыполнения = ОбработкаНовостейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций(); // Этот контекст.
	КонтекстВыполненияВложенный = ОбработкаНовостейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций(); // Контекст "по шагам".
	ОбработкаНовостейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		"Новости.ФормаСпискаДляРедактирования." + НаименованиеПроцедурыФункции, // Идентификатор.
		НСтр("ru = 'Пересчет служебных данных по новостям';
			|en = 'Service data recalculation by news'"));

		УстановитьПривилегированныйРежим(Истина);

			// Удалить неправильные отборы, которые могут помешать проверке общих и пользовательских отборов.
			// В разделенном сеансе будут пересчитаны только пользовательские отборы и общие для области данных.
			ОбработкаНовостей.ОптимизироватьОтборыПоНовостям(КонтекстВыполненияВложенный);

			// Рассчитать заново регистр "РассчитанныеОтборыПоНовостям_РедкоМеняющиеся" для отборов
			//  по новостям по редко меняющимся категориям (версия конфигурации, платформы, продукт).
			ОбработкаНовостей.ПересчитатьОтборыПоНовостям_РедкоМеняющиеся(КонтекстВыполненияВложенный);

			// Рассчитать заново регистр "РассчитанныеОтборыПоНовостям_Общие" для отборов
			//  по новостям, настроенных администратором.
			// Здесь же пересчитаются отборы по всем пользователям - регистр "РассчитанныеОтборыПоНовостям_Пользовательские" для отборов
			//  по новостям, настроенных пользователем.
			// Может работать в модели сервиса.
			ОбработкаНовостей.ПересчитатьОтборыПоНовостям_Общие(КонтекстВыполненияВложенный);

			// Рассчитать заново регистр "РассчитанныеОтборыПоНовостям_ДляОбластиДанных" для отборов
			//  по новостям, настроенных для областей данных.
			// Может работать в модели сервиса.
			ОбработкаНовостей.ПересчитатьОтборыПоНовостям_ДляОбластиДанных(КонтекстВыполненияВложенный);

			// Рассчитывать заново регистр "РассчитанныеОтборыПоНовостям_Пользовательские" для отборов
			//  по новостям, настроенных для пользователей - не нужно,
			//  т.к. он выполняется в ОбработкаНовостей.ПересчитатьОтборыПоНовостям_Общие.

			// Пересчитать регистр "ПериодическиеСвойстваНовостей" - возможно, поменялась важность / актуальность
			//  и другие периодические свойства новостей. Также надо добавить записи для новых новостей.
			ОбработкаНовостей.ОбновлениеПериодическихСвойствНовостей(КонтекстВыполненияВложенный);

			// Пересчитать регистр "ПривязкаНовостейКМетаданным" - возможно, поменялась важность
			//  и другие периодические свойства новостей. Также надо добавить записи для новых новостей.
			ОбработкаНовостей.ОбновлениеПривязокКМетаданным(КонтекстВыполненияВложенный);

		УстановитьПривилегированныйРежим(Ложь);

		ЭтотОбъект.НеобходимПересчетСлужебныхДанных = Ложь;

	ШагВыполнения = ОбработкаНовостейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		0, // Много действий, всегда установлено в 0, надо читать данные по каждому шагу.
		"",
		КонтекстВыполненияВложенный);

	Если ЗаписыватьВЖурналРегистрации = Истина Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Пересчет всех служебных данных по новостям
				|Время начала (мс): %1
				|Время окончания (мс): %2
				|Длительность (мс): %3
				|
				|По шагам:
				|%4';
				|en = 'Recalculate all service data by news
				|Start time (ms): %1
				|End time (ms): %2
				|Duration (ms): %3
				|
				|By steps:
				|%4'")
				+ Символы.ПС,
			ШагВыполнения.ВремяНачала,
			ШагВыполнения.ВремяОкончания,
			ШагВыполнения.ВремяОкончания - ШагВыполнения.ВремяНачала,
			ОбработкаНовостейКлиентСервер.ПредставлениеЗаписиРезультатовВыполненияОпераций(
				КонтекстВыполнения,
				Истина, // ВключаяВложенные
				"ПодробноПоШагам",
				0));

		ОбработкаНовостей.ЗаписатьСообщениеВЖурналРегистрации(
			НСтр("ru = 'БИП:Новости.Сервис и регламент';
				|en = 'ISL:News.Service and regulation'", ОбщегоНазначения.КодОсновногоЯзыка()), // ИмяСобытия.
			НСтр("ru = 'Новости. Сервис и регламент. ПересчетВсехСлужебныхДанныхПоНовостям';
				|en = 'News. Service and regulation. ПересчетВсехСлужебныхДанныхПоНовостям'", ОбщегоНазначения.КодОсновногоЯзыка()), // ИдентификаторШага.
			УровеньЖурналаРегистрации.Информация, // УровеньЖурналаРегистрации.*
			, // ОбъектМетаданных
			(ШагВыполнения.ВремяОкончания - ШагВыполнения.ВремяНачала), // Данные
			ТекстСообщения, // Комментарий
			ОбработкаНовостейПовтИсп.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации

	КонецЕсли;

КонецПроцедуры

#КонецОбласти
