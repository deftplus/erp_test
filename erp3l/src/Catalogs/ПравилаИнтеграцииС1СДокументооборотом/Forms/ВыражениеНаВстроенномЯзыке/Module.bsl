#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ТипОбъектаДО", ТипОбъектаДО);
	Параметры.Свойство("ТипОбъектаИС", ТипОбъектаИС);
	Параметры.Свойство("ВидДокументаДО", ВидДокументаДО);
	Параметры.Свойство("ВычисляемоеВыражение", ВычисляемоеВыражение);
	Параметры.Свойство("ТипВыражения", ТипВыражения);
	
	ИнструкцияМассив = Новый Массив;
	
	ИнструкцияМассив.Добавить(
		"<html>
		|<style type=""text/css"">
		|	body {
		|		overflow:    auto;
		|		margin-top:  12px;
		|		margin-left: 20px;
		|		font-family: MS Shell Dlg, Microsoft Sans Serif, sans-serif;
		|		font-size:   8pt;}
		|	table {
		|		width:       270px;
		|		font-family: MS Shell Dlg, Microsoft Sans Serif, sans-serif;
		|		font-size:   8pt;}
		|	td {vertical-align: top;}
		|	p {
		|		margin-top: 7px;}
		|</style>
		|<body>");
	
	Если ТипВыражения = "ПравилоВыгрузки" Или ТипВыражения = "ПравилоЗагрузки" Тогда
		
		Заголовок = НСтр("ru = 'Выражение на встроенном языке';
						|en = 'Expression in the script '");
		
		ИнструкцияМассив.Добавить("<p>");
		ИнструкцияМассив.Добавить(
			СтрШаблон(
				НСтр("ru = 'Результат вычисления выражения на встроенном языке 1С:Предприятия
					|должен присваиваться свойству %1 переменной %2.';
					|en = 'Result of the expression calculation in 1C:Enterprise
					|language should be assigned to the %1 property of the %2 variable.'"),
				"<b>Результат</b>",
				"<b>Параметры</b>"));
		ИнструкцияМассив.Добавить(" ");
			
		Если Параметры.ЭтоТаблица Тогда
			ИнструкцияМассив.Добавить(
				СтрШаблон(
					НСтр("ru = 'Для заполнения таблицы результат должен иметь тип %1 с колонками:';
						|en = 'To fill in the table, the result must have the %1 type with the columns:'"),
				"<b>ТаблицаЗначений</b>"));
			ИнструкцияМассив.Добавить("</p><table>");
			
			Если ТипВыражения = "ПравилоВыгрузки" Тогда
				СоответствиеСвойствXDTO = Справочники.ПравилаИнтеграцииС1СДокументооборотом.
					СоответствиеСвойствXDTOиРеквизитовФормыОбъектаДО(ТипОбъектаДО);
				ИмяТаблицы = СтрЗаменить(Параметры.ИмяРеквизитаОбъектаДО, ".rows", "");
				Для Каждого Элемент Из СоответствиеСвойствXDTO[ИмяТаблицы].rows[1] Цикл
					ИнструкцияМассив.Добавить("<tr><td>");
					ИнструкцияМассив.Добавить(Элемент.Значение);
					ИнструкцияМассив.Добавить("</td></tr>");
				КонецЦикла;
			Иначе
				МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ТипОбъектаИС);
				Для Каждого Элемент Из МетаданныеОбъекта.ТабличныеЧасти[Параметры.ИмяРеквизитаОбъектаИС].Реквизиты Цикл
					ИнструкцияМассив.Добавить("<tr><td>");
					ИнструкцияМассив.Добавить(Элемент.Имя);
					ИнструкцияМассив.Добавить("</td></tr>");
				КонецЦикла;
			КонецЕсли;
			
			ИнструкцияМассив.Добавить("</table>");
			
		ИначеЕсли ТипВыражения = "ПравилоВыгрузки" Тогда
			ИнструкцияМассив.Добавить(
				СтрШаблон(
					НСтр("ru = 'Для установки ссылочного значения на стороне 1С:Документооборота
						|свойству %1 следует присвоить строку с названием типа согласно
						|описанию веб-сервиса, а свойству %2 - идентификатор ссылки
						|или имя значения перечисления. Свойству %3 в этом случае присваивается
						|пользовательское представление результата.';
						|en = 'To set the reference value on the 1C:Document Management side, 
						|the %1 property must be assigned a string with the type name according to
						| the description of the web service, and the %2 property must be assigned the reference ID
						| or the name of the enumeration value. In this case, the %3 property is assigned
						| a custom representation of the result.'"),
					"<b>РезультатТип</b>",
					"<b>РезультатID</b>",
					"<b>Результат</b>"));
			
		КонецЕсли;
		
	ИначеЕсли ТипВыражения = "УсловиеПрименимостиПриВыгрузке" Тогда
		
		Заголовок = НСтр("ru = 'Условие применимости правила';
						|en = 'Rule applicability condition'");
		
		ИнструкцияМассив.Добавить("<p>");
		ИнструкцияМассив.Добавить(
			СтрШаблон(
				НСтр("ru = 'Выражение на встроенном языке 1С:Предприятия определяет
					|применимость правила при создании объекта 1С:Документооборота на основании
					|объекта этой конфигурации. Результат вычисления должен присваиваться свойству
					|%1 переменной %2. %3 означает применимость правила,
					|%4 - неприменимость. Выражение проверяется только для правил,
					|подходящих по значениям ключевых реквизитов.
					|%5Значение по умолчанию: %3.';
					|en = 'Expression in 1C:Enterprise language determines
					|the rule applicability when creating a 1C:Document Management object based on
					|this configuration object. The calculation result must be assigned to the 
					|%1 property of the %2 variable. %3 means that the rule is applicable,
					|%4 means the rule is inapplicable. The expression is checked only for the rules
					|that have required values of key attributes.
					|%5Default value: %3.'"),
				"<b>Результат</b>",
				"<b>Параметры</b>",
				"<b>Истина</b>",
				"<b>Ложь</b>",
				"</p><p>"));
		ИнструкцияМассив.Добавить("<p>");
		
	ИначеЕсли ТипВыражения = "УсловиеПрименимостиПриЗагрузке" Тогда
		
		Заголовок = НСтр("ru = 'Условие применимости правила';
						|en = 'Rule applicability condition'");
		
		ИнструкцияМассив.Добавить("<p>");
		ИнструкцияМассив.Добавить(
			СтрШаблон(
				НСтр("ru = 'Выражение на встроенном языке 1С:Предприятия определяет
					|применимость правила при создании объекта этой конфигурации на основании
					|объекта 1С:Документооборота. Результат вычисления должен присваиваться свойству
					|%1 переменной %2. %3 означает применимость правила,
					|%4 - неприменимость. Выражение проверяется только для правил,
					|подходящих по значениям ключевых реквизитов.
					|%5Значение по умолчанию: %3.';
					|en = 'Expression in 1C:Enterprise language determines
					|the rule applicability when creating this configuration object based on a 
					|1C:Document Management object. The calculation result must be assigned to the 
					|%1 property of the %2 variable. %3 means that the rule is applicable,
					|%4 means the rule is inapplicable. The expression is checked only for the rules
					|that have required values of key attributes.
					|%5Default value: %3.'"),
				"<b>Результат</b>",
				"<b>Параметры</b>",
				"<b>Истина</b>",
				"<b>Ложь</b>",
				"</p><p>"));
		ИнструкцияМассив.Добавить("<p>");
		
	КонецЕсли;
	
	ИнструкцияМассив.Добавить("<p>");
	ИнструкцияМассив.Добавить(НСтр("ru = 'К объекту';
									|en = 'To object'"));
	ИнструкцияМассив.Добавить(" ");
	
	Если ТипВыражения = "ПравилоЗагрузки" Или ТипВыражения = "УсловиеПрименимостиПриЗагрузке" Тогда
		ИнструкцияМассив.Добавить(НСтр("ru = '1С:Документооборота';
										|en = '1C:Document Management'"));
		
		ПараметрыЗаполнения = Неопределено;
		Если ВидДокументаДО <> Неопределено Тогда
			ПараметрыЗаполнения = Новый Структура;
			ПараметрыЗаполнения.Вставить("documentType", ВидДокументаДО);
		КонецЕсли;
		
		СоставРеквизитов = Справочники.ПравилаИнтеграцииС1СДокументооборотом.
			ПолучитьРеквизитыОбъектаДО(ТипОбъектаДО, ПараметрыЗаполнения);
	Иначе // ПравилоВыгрузки, УсловиеПрименимостиПриВыгрузке
		ИнструкцияМассив.Добавить(НСтр("ru = 'этой конфигурации';
										|en = 'this configuration'"));
		СоставРеквизитов = Справочники.ПравилаИнтеграцииС1СДокументооборотом.
			ПолучитьРеквизитыОбъектаИС(ТипОбъектаИС);
	КонецЕсли;
	
	ИнструкцияМассив.Добавить(" ");
	ИнструкцияМассив.Добавить(
		СтрШаблон(
			НСтр("ru = 'можно обращаться через свойство %1 переменной %2.
				|Реквизиты источника:';
				|en = 'you can access it using the %1 property of the %2 variable.
				|Source attributes:'"),
			"<b>Источник</b>",
			"<b>Параметры</b>"));
	ИнструкцияМассив.Добавить("</p><table>");
	
	Если (ТипВыражения = "ПравилоЗагрузки" Или ТипВыражения = "УсловиеПрименимостиПриЗагрузке") Тогда
		СоставРеквизитов.Сортировать("ЭтоТаблица, ДопРеквизит, Имя");
	Иначе
		СоставРеквизитов.Сортировать("ЭтоТаблица, ЭтоДополнительныйРеквизитИС, Имя");
	КонецЕсли;
	
	ВыведенЗаголовокДопРеквизитов = Ложь;
	
	Для Каждого СтруктураРеквизита Из СоставРеквизитов Цикл
		
		Если ЗначениеЗаполнено(СтруктураРеквизита.Таблица) Тогда
			Продолжить;
		КонецЕсли;
		
		Если (ТипВыражения = "ПравилоЗагрузки" Или ТипВыражения = "УсловиеПрименимостиПриЗагрузке") Тогда
			ЭтоДопРеквизит = СтруктураРеквизита.ДопРеквизит;
		Иначе
			ЭтоДопРеквизит = СтруктураРеквизита.ЭтоДополнительныйРеквизитИС;
		КонецЕсли;
		
		Если ЭтоДопРеквизит И Не ВыведенЗаголовокДопРеквизитов Тогда
			ИнструкцияМассив.Добавить("<tr><td>");
			ИнструкцияМассив.Добавить("<b>");
			ИнструкцияМассив.Добавить(НСтр("ru = 'Дополнительные реквизиты:';
											|en = 'Additional attributes:'"));
			ИнструкцияМассив.Добавить("</b>");
			ИнструкцияМассив.Добавить("</tr></td>");
			ВыведенЗаголовокДопРеквизитов = Истина;
		КонецЕсли;
		
		Если СтруктураРеквизита.ЭтоТаблица Тогда
			ИнструкцияМассив.Добавить("<tr><td>");
			ИнструкцияМассив.Добавить("<b>");
			ИнструкцияМассив.Добавить(СтруктураРеквизита.Имя);
			ИнструкцияМассив.Добавить("</b></td>");
			
			Если СтруктураРеквизита.Представление <> СтруктураРеквизита.Имя Тогда
				ИнструкцияМассив.Добавить("<td><b>");
				ИнструкцияМассив.Добавить(СтруктураРеквизита.Представление);
				ИнструкцияМассив.Добавить("</b></td>");
			КонецЕсли;
			ИнструкцияМассив.Добавить("</tr>");
			
			РеквизитыТаблицы = СоставРеквизитов.НайтиСтроки(Новый Структура("Таблица", СтруктураРеквизита.Имя));
			Для Каждого РеквизитТаблицы Из РеквизитыТаблицы Цикл
				ИнструкцияМассив.Добавить("<tr><td>");
				ИнструкцияМассив.Добавить(РеквизитТаблицы.Имя);
				ИнструкцияМассив.Добавить("</td>");
				Если РеквизитТаблицы.Представление <> РеквизитТаблицы.Имя Тогда
					ИнструкцияМассив.Добавить("<td>");
					ИнструкцияМассив.Добавить(РеквизитТаблицы.Представление);
					ИнструкцияМассив.Добавить("</td>");
				КонецЕсли;
				ИнструкцияМассив.Добавить("</tr>");
			КонецЦикла;
			Продолжить;
		КонецЕсли;
		
		Если ЭтоДопРеквизит Тогда
			Если (ТипВыражения = "ПравилоЗагрузки" Или ТипВыражения = "УсловиеПрименимостиПриЗагрузке") Тогда
				ИмяРеквизита = СтрШаблон(НСтр("ru = 'УИД: ""%1""';
												|en = 'UID: ""%1"" '"), СтруктураРеквизита.ДопРеквизитID);
			Иначе
				ИмяРеквизита = СтрШаблон(НСтр("ru = 'УИД: ""%1""';
												|en = 'UID: ""%1"" '"), СтруктураРеквизита.Имя);
			КонецЕсли;
		Иначе
			ИмяРеквизита = СтруктураРеквизита.Имя;
		КонецЕсли;
		
		ИнструкцияМассив.Добавить("<tr>");
		Если ТипЗнч(СтруктураРеквизита.Тип) = Тип("СписокЗначений")
				И СтруктураРеквизита.Тип.Количество() > 0
				И Лев(СтруктураРеквизита.Тип[0], 2) = "DM" Тогда
			ИнструкцияМассив.Добавить("<td><a href=""#");
			ИнструкцияМассив.Добавить(СтруктураРеквизита.Тип[0]);
			ИнструкцияМассив.Добавить(""">");
			ИнструкцияМассив.Добавить(ИмяРеквизита);
			ИнструкцияМассив.Добавить("</a></td>");
		Иначе
			ИнструкцияМассив.Добавить("<td>");
			ИнструкцияМассив.Добавить(ИмяРеквизита);
			ИнструкцияМассив.Добавить("</td>");
		КонецЕсли;
		
		Если СтруктураРеквизита.Представление <> ИмяРеквизита Тогда
			ИнструкцияМассив.Добавить("<td>");
			ИнструкцияМассив.Добавить(СтруктураРеквизита.Представление);
			ИнструкцияМассив.Добавить("</td>");
		КонецЕсли;
		
		ИнструкцияМассив.Добавить("</tr>");
		
	КонецЦикла;
	
	ИнструкцияМассив.Добавить("</table>");
	ИнструкцияМассив.Добавить("</body></html>");
	
	Инструкция = СтрСоединить(ИнструкцияМассив);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОчистить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандаОчиститьЗавершение", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Очистить введенное выражение?';
						|en = 'Clear the expression entered?'");
	ИнтеграцияС1СДокументооборотКлиент.ПоказатьВопросДаНет(ОписаниеОповещения, ТекстВопроса);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Закрыть(ВычисляемоеВыражение);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПроверить(Команда)
	
	ОчиститьСообщения();
	ПроверитьВыражениеНаВстроенномЯзыке(ТипВыражения, ВычисляемоеВыражение, ТипОбъектаДО, ТипОбъектаИС);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РеквизитыПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(ДанныеСобытия.HRef) Тогда
		Возврат;
	КонецЕсли;
	
	Позиция = СтрНайти(ДанныеСобытия.HRef, "#", НаправлениеПоиска.СКонца);
	Ссылка = Сред(ДанныеСобытия.HRef, Позиция + 1);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ссылка", Ссылка);
	
	ОткрытьФорму("Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ОписаниеВебСервисов", 
		ПараметрыФормы, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОчиститьЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Закрыть("");
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПроверитьВыражениеНаВстроенномЯзыке(ТипВыражения, ВычисляемоеВыражение, ТипОбъектаДО, ТипОбъектаИС)
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	ОбъектXDTO = ИнтеграцияС1СДокументооборот.ПолучитьНовыйОбъект(Прокси, ТипОбъектаДО);
	
	МенеджерОбъектаИС = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТипОбъектаИС);
	МетаданныеОбъектаИС = Метаданные.НайтиПоПолномуИмени(ТипОбъектаИС);
	Если ОбщегоНазначения.ЭтоСправочник(МетаданныеОбъектаИС)
			Или ОбщегоНазначения.ЭтоПланВидовРасчета(МетаданныеОбъектаИС) Тогда
		ОбъектИС = МенеджерОбъектаИС.СоздатьЭлемент();
	ИначеЕсли ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъектаИС) Тогда
		ОбъектИС = МенеджерОбъектаИС.СоздатьДокумент();
	КонецЕсли;
	ОбъектИС.Заполнить(Неопределено);
	
	Если ТипВыражения = "ПравилоВыгрузки" Тогда
		Справочники.ПравилаИнтеграцииС1СДокументооборотом.ПроверитьВыражениеПравилаВыгрузки(
			ВычисляемоеВыражение,
			ОбъектИС);
		
	ИначеЕсли ТипВыражения = "УсловиеПрименимостиПриВыгрузке" Тогда
		Справочники.ПравилаИнтеграцииС1СДокументооборотом.ПроверитьВыражениеУсловияПрименимостиПриВыгрузке(
			ВычисляемоеВыражение,
			ОбъектИС);
		
	ИначеЕсли ТипВыражения = "ПравилоЗагрузки" Тогда
		Справочники.ПравилаИнтеграцииС1СДокументооборотом.ПроверитьВыражениеПравилаЗагрузки(
			ВычисляемоеВыражение,
			ОбъектXDTO,
			ОбъектИС);
		
	ИначеЕсли ТипВыражения = "УсловиеПрименимостиПриЗагрузке" Тогда
		Справочники.ПравилаИнтеграцииС1СДокументооборотом.ПроверитьВыражениеУсловияПрименимостиПриЗагрузке(
			ВычисляемоеВыражение,
			ОбъектXDTO);
		
	КонецЕсли;
	
	ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Ошибок не обнаружено';
												|en = 'No errors detected'"));
	
КонецПроцедуры

#КонецОбласти