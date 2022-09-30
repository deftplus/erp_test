
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьЗарегистрированныеОбъекты();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗарегистрированныеОбъекты

&НаКлиенте
Процедура ЗарегистрированныеОбъектыВыбранПриИзменении(Элемент)
	ТекущаяСтрокаДерева = Элементы.ЗарегистрированныеОбъекты.ТекущиеДанные;
	Для Каждого СтрокаПодчиненногоДерева Из ТекущаяСтрокаДерева.ПолучитьЭлементы() Цикл
		СтрокаПодчиненногоДерева.Выбран = ТекущаяСтрокаДерева.Выбран;	
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗарегистрированныеОбъектыПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ЗарегистрированныеОбъекты.ТекущиеДанные;
	КорневойЭлемент = (Элементы.ЗарегистрированныеОбъекты.ТекущиеДанные.ПолучитьРодителя() = Неопределено);
	
	Элементы.ЗарегистрированныеОбъектыРегистрацияОбъект.Заголовок 
		= ТекущиеДанные.ОбъектКонфигурации;
	 	
	Элементы.ЗарегистрированныеОбъектыРегистрация.Видимость = Не КорневойЭлемент;
	Элементы.ДекорацияОписание.Видимость = КорневойЭлемент;
	Если КорневойЭлемент Тогда
		Элементы.ДекорацияОписание.Заголовок = Описание(ТекущиеДанные.ОбъектКонфигурации,
														ТекущиеДанные.Количество);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ГруппаДобавить

&НаКлиенте
Процедура ДобавитьРегистрациюВсехОбъектов(Команда)
	ДобавитьРегистрациюВсехОбъектовНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьРегистрациюОдногоОбъекта(Команда)
	
	ТекущиеДанные = Элементы.ЗарегистрированныеОбъекты.ТекущиеДанные;
	РодительТекущихДанных = ТекущиеДанные.ПолучитьРодителя();
	
	Если РодительТекущихДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонНаименованияФормы = "%1.ФормаВыбора";
	НаименованиеФормы = СтрШаблон(ШаблонНаименованияФормы, ТекущиеДанные.Тип);
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытияФормы.Вставить("МножественныйВыбор", Истина);
	
	ПараметрыОповещения = Новый Структура("РегистрИзменений, ИдентификаторСтрокиДерева",
										  ТекущиеДанные.РегистрИзменений, ТекущиеДанные.ПолучитьИдентификатор());
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьРегистрациюНаКлиенте", ЭтотОбъект,
												  ПараметрыОповещения);

	ОткрытьФорму(НаименованиеФормы, ПараметрыОткрытияФормы, , , , ,
				 ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьРегистрациюОтбор(Команда)
		
	ТекущиеДанные = Элементы.ЗарегистрированныеОбъекты.ТекущиеДанные;
	РодительТекущихДанных = ТекущиеДанные.ПолучитьРодителя();
	
	Если РодительТекущихДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ПараметрыОткрытияФормы = Новый Структура("ИмяТаблицы", ТекущиеДанные.Тип);
	
	ПараметрыОповещения = Новый Структура("РегистрИзменений, ИдентификаторСтрокиДерева",
										  ТекущиеДанные.РегистрИзменений, ТекущиеДанные.ПолучитьИдентификатор());
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьРегистрациюНаКлиенте", ЭтотОбъект,
												  ПараметрыОповещения);

	ОткрытьФорму("Обработка.РегистрацияОбъектовКПубликацииКабинетСотрудника.Форма.ВыборОбъектовОтбором",
				 ПараметрыОткрытияФормы, , , , ,
				 ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ГруппаУбрать

&НаКлиенте
Процедура УбратьРегистрациюВсехОбъектов(Команда)
	УбратьРегистрациюВсехОбъектовНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура УбратьРегистрациюОдногоОбъекта(Команда)
	
	ВыделенныеСтроки = Элементы.ЗарегистрированныеОбъектыРегистрация.ВыделенныеСтроки;
	ТекущиеДанные = Элементы.ЗарегистрированныеОбъекты.ТекущиеДанные;
	
	МассивОбъектов = Новый Массив;
	Для Каждого НомерСтроки Из ВыделенныеСтроки Цикл
		СсылкаНаОбъект = ТекущиеДанные.Регистрация.НайтиПоИдентификатору(НомерСтроки).Ссылка;
		МассивОбъектов.Добавить(СсылкаНаОбъект);
	КонецЦикла;
	
	УбратьРегистрацию(МассивОбъектов, ТекущиеДанные.РегистрИзменений, ТекущиеДанные.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура УбратьРегистрациюОтбор(Команда)
	
	ТекущиеДанные = Элементы.ЗарегистрированныеОбъекты.ТекущиеДанные;
	РодительТекущихДанных = ТекущиеДанные.ПолучитьРодителя();
	
	Если РодительТекущихДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ПараметрыОткрытияФормы = Новый Структура("ИмяТаблицы", ТекущиеДанные.Тип);
	ПараметрыОповещения = Новый Структура("РегистрИзменений, ИдентификаторСтрокиДерева",
										  ТекущиеДанные.РегистрИзменений, ТекущиеДанные.ПолучитьИдентификатор());
	ОписаниеОповещения = Новый ОписаниеОповещения("УбратьРегистрациюОтборЗавершение", ЭтотОбъект,
												  ПараметрыОповещения);

	ОткрытьФорму("Обработка.РегистрацияОбъектовКПубликацииКабинетСотрудника.Форма.ВыборОбъектовОтбором",
				 ПараметрыОткрытияФормы, , , , ,
				 ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Обновить(Команда)
	ЗаполнитьЗарегистрированныеОбъекты();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеТаблицыЗарегистрированныеОбъекты

&НаСервере
Процедура ЗаполнитьЗарегистрированныеОбъекты()
	ЗначениеВРеквизитФормы(ДеревоЗарегистрированныхОбъектов(), "ЗарегистрированныеОбъекты");
КонецПроцедуры

&НаСервере
Функция ДеревоЗарегистрированныхОбъектов()
	
	ДеревоЗарегистрированныхОбъектов = Новый ДеревоЗначений;
	ДеревоЗарегистрированныхОбъектов.Колонки.Добавить("ОбъектКонфигурации", Новый ОписаниеТипов("Строка"));
	ДеревоЗарегистрированныхОбъектов.Колонки.Добавить("Регистрация", Новый ОписаниеТипов("ТаблицаЗначений"));
	ДеревоЗарегистрированныхОбъектов.Колонки.Добавить("РегистрИзменений", Новый ОписаниеТипов("Строка"));
	ДеревоЗарегистрированныхОбъектов.Колонки.Добавить("КартинкаОбъекта", Новый ОписаниеТипов("Число"));
	ДеревоЗарегистрированныхОбъектов.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	ДеревоЗарегистрированныхОбъектов.Колонки.Добавить("Выбран", Новый ОписаниеТипов("Булево"));
	ДеревоЗарегистрированныхОбъектов.Колонки.Добавить("Тип", Новый ОписаниеТипов("Строка"));
	
	КартинкаСправочник = 3;
	КартинкаБизнесПроцесс = 23;
	
	ДеревоЗарегистрированныхСправочников = ДеревоЗарегистрированныхОбъектов.Строки.Добавить();
	ДеревоЗарегистрированныхСправочников.ОбъектКонфигурации = НСтр("ru = 'Справочники';
																	|en = 'Catalogs'");
	ДеревоЗарегистрированныхСправочников.КартинкаОбъекта = КартинкаСправочник;
	ДеревоЗарегистрированныхСправочников.Количество = 0;
	ДеревоЗарегистрированныхСправочников.РегистрИзменений = "ИзмененияДляСервисаКабинетСотрудника";
	Для Каждого ТипПредмета Из КабинетСотрудникаВнутренний.ТипыОбъектовДляРучнойРегистрации() Цикл
		СтрокаТаблицы = ДобавитьСтрокуЗарегистрированныхОбъектов(ТипПредмета, ДеревоЗарегистрированныхСправочников);
		СтрокаТаблицы.РегистрИзменений = "ИзмененияДляСервисаКабинетСотрудника";
		СтрокаТаблицы.КартинкаОбъекта = КартинкаСправочник;
	КонецЦикла;
	
	ДеревоЗарегистрированныхБизнесПроцессов = ДеревоЗарегистрированныхОбъектов.Строки.Добавить(); 
	ДеревоЗарегистрированныхБизнесПроцессов.ОбъектКонфигурации = НСтр("ru = 'Заявки сотрудников';
																		|en = 'Employee requests'");
	ДеревоЗарегистрированныхБизнесПроцессов.КартинкаОбъекта = КартинкаБизнесПроцесс;
	ДеревоЗарегистрированныхБизнесПроцессов.Количество = 0;
	ДеревоЗарегистрированныхБизнесПроцессов.РегистрИзменений = "ИзмененияЗаявокДляСервисаКабинетСотрудника";
	Для Каждого ТипЗаявки Из Метаданные.ОпределяемыеТипы.ПубликуемыеЗаявкиКабинетСотрудника.Тип.Типы() Цикл
		СтрокаТаблицы = ДобавитьСтрокуЗарегистрированныхОбъектов(ТипЗаявки, ДеревоЗарегистрированныхБизнесПроцессов);
		СтрокаТаблицы.РегистрИзменений = "ИзмененияЗаявокДляСервисаКабинетСотрудника";
		СтрокаТаблицы.КартинкаОбъекта = КартинкаБизнесПроцесс;
	КонецЦикла;
	
	Возврат ДеревоЗарегистрированныхОбъектов;
	
КонецФункции

&НаСервере
Функция ДобавитьСтрокуЗарегистрированныхОбъектов(ТипЗаявки, Дерево)
	
	ТипЗаявкиСсылка = Новый(ТипЗаявки);
	ТипЗаявкиМетаданные = ТипЗаявкиСсылка.Метаданные();
	
	СтрокаВидаОбъекта = Дерево.Строки.Добавить();
	СтрокаВидаОбъекта.ОбъектКонфигурации = ТипЗаявкиМетаданные.Синоним;
	
	Запрос = Новый Запрос();
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОбъектКабинетаСотрудника.Ссылка КАК Ссылка
	               |ИЗ
	               |	#Таблица КАК ОбъектКабинетаСотрудника
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИзмененияДляСервисаКабинетСотрудника КАК ИзмененияДляСервисаКабинетСотрудника
	               |		ПО ОбъектКабинетаСотрудника.Ссылка = ИзмененияДляСервисаКабинетСотрудника.ПредметПубликации
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИзмененияЗаявокДляСервисаКабинетСотрудника КАК ИзмененияЗаявокДляСервисаКабинетСотрудника
	               |		ПО ОбъектКабинетаСотрудника.Ссылка = ИзмененияЗаявокДляСервисаКабинетСотрудника.ПредметПубликации
	               |ГДЕ
	               |	(НЕ ИзмененияДляСервисаКабинетСотрудника.ПредметПубликации ЕСТЬ NULL
	               |			ИЛИ НЕ ИзмененияЗаявокДляСервисаКабинетСотрудника.ПредметПубликации ЕСТЬ NULL)";
	
	ИмяТаблицы = ТипЗаявкиМетаданные.ПолноеИмя();
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Таблица", ИмяТаблицы);
	
	Выгрузка = Запрос.Выполнить().Выгрузить();
	СтрокаВидаОбъекта.Регистрация = Выгрузка;
	СтрокаВидаОбъекта.Количество = Выгрузка.Количество();
	СтрокаВидаОбъекта.Тип = ИмяТаблицы;
	
	Дерево.Количество = Дерево.Количество + СтрокаВидаОбъекта.Количество;
	
	Возврат СтрокаВидаОбъекта;
	
КонецФункции

#КонецОбласти

#Область ДобавлениеРегистрации

&НаСервере
Процедура ДобавитьРегистрациюВсехОбъектовНаСервере()
	
	Для Каждого ГруппаВидовОбъектов Из ЗарегистрированныеОбъекты.ПолучитьЭлементы() Цикл
		
		ВидыОбъектов = ГруппаВидовОбъектов.ПолучитьЭлементы();
		РегистрИзменений = ВидыОбъектов[0].РегистрИзменений;
				
		Для Каждого ВидОбъектов Из ВидыОбъектов Цикл
			
			Если Не ВидОбъектов.Выбран Тогда
				Продолжить;
			КонецЕсли;
			
			ОбъектыДляРегистрации = МассивОбъектов(ВидОбъектов.Тип);
			ДобавитьРегистрацию(ОбъектыДляРегистрации, РегистрИзменений, ВидОбъектов.ПолучитьИдентификатор());
			
		КонецЦикла;
		
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура ДобавитьРегистрацию(МассивОбъектов, НазваниеРегистраИзменений, ИдентификаторСтрокиДерева)
	
	СтрокаДерева = ЗарегистрированныеОбъекты.НайтиПоИдентификатору(ИдентификаторСтрокиДерева); 
	РегистрИзменений = РегистрыСведений[НазваниеРегистраИзменений];
	
	Если НазваниеРегистраИзменений = "ИзмененияДляСервисаКабинетСотрудника" Тогда
		ЭтоФизическиеЛица = (СтрокаДерева.Тип = "Справочник.ФизическиеЛица");
		ОбъектыДляРегистрации = ЗарегистрированыКПубликации(МассивОбъектов, ЭтоФизическиеЛица);
	Иначе
		ОбъектыДляРегистрации = МассивОбъектов;
	КонецЕсли;
	
	Для Каждого ОбъектРегистрации Из ОбъектыДляРегистрации Цикл
		
		Если СтрокаДерева.Регистрация.НайтиСтроки(Новый Структура("Ссылка", ОбъектРегистрации)).Количество() > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		МенеджерЗаписиИзменений = РегистрИзменений.СоздатьМенеджерЗаписи();
		МенеджерЗаписиИзменений.ПредметПубликации = ОбъектРегистрации;
		МенеджерЗаписиИзменений.ВерсияДанных = Строка(Новый УникальныйИдентификатор);
		МенеджерЗаписиИзменений.Записать();
		
		НоваяРегистрация = СтрокаДерева.Регистрация.Добавить();
		НоваяРегистрация.Ссылка = ОбъектРегистрации;
		СтрокаДерева.Количество = СтрокаДерева.Количество + 1;
		
		СтрокаРодитель = СтрокаДерева.ПолучитьРодителя();
		НоваяРегистрацияРодитель = СтрокаРодитель.Регистрация.Добавить();
		НоваяРегистрацияРодитель.Ссылка = ОбъектРегистрации;
		СтрокаРодитель.Количество = СтрокаРодитель.Количество + 1;
		
	КонецЦикла;
	
	ЗарегистрироватьДокументыКЭДО(ОбъектыДляРегистрации, СтрокаДерева.Тип);
			
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьРегистрациюНаКлиенте(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьРегистрацию(Результат, 
						ДополнительныеПараметры.РегистрИзменений,
						ДополнительныеПараметры.ИдентификаторСтрокиДерева);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция МассивОбъектов(ИмяТаблицы)
	
	Запрос = Новый Запрос();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка
	|ИЗ
	|	#ИмяТаблицы КАК Таблица";
	
	ОбъектСправочник = СтрНайти(ИмяТаблицы, "Справочник");
	ОбъектБизнесПроцесс = СтрНайти(ИмяТаблицы, "БизнесПроцесс");
	Если ОбъектСправочник Тогда
		Если СтрНайти(ИмяТаблицы, "ФизическиеЛица") Тогда
			ТекстПроверкиПубликации = "		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ФизическиеЛицаКабинетСотрудника КАК ПубликуемыеОбъекты
			|		ПО ПубликуемыеОбъекты.ФизическоеЛицо = Таблица.Ссылка";
		Иначе
			ТекстПроверкиПубликации = "		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПубликуемыеОбъектыКабинетСотрудника КАК ПубликуемыеОбъекты
			|		ПО ПубликуемыеОбъекты.ОбъектПубликации = Таблица.Ссылка";
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + Символы.ПС + ТекстПроверкиПубликации;
	ИначеЕсли ОбъектБизнесПроцесс Тогда
		Запрос.Текст = Запрос.Текст + Символы.ПС +
		"ГДЕ
		|	Таблица.Выполнено";
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ИмяТаблицы", ИмяТаблицы);
	
	МассивОбъектов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Если ОбъектСправочник Тогда
		МассивОбъектов = КабинетСотрудника.ОбъектыБезОшибокЗаполнения(МассивОбъектов);
	КонецЕсли;
	
	Возврат МассивОбъектов;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗарегистрированыКПубликации(МассивСсылок, ФизическоеЛицо = Ложь)
	
	Запрос = Новый Запрос;
	
	Если ФизическоеЛицо Тогда
		Запрос.Текст = "ВЫБРАТЬ
		               |	ФизическиеЛицаКабинетСотрудника.ФизическоеЛицо КАК Ссылка
		               |ИЗ
		               |	РегистрСведений.ФизическиеЛицаКабинетСотрудника КАК ФизическиеЛицаКабинетСотрудника
		               |ГДЕ
		               |	ФизическиеЛицаКабинетСотрудника.ФизическоеЛицо В (&МассивСсылок)";
	Иначе
		Запрос.Текст = "ВЫБРАТЬ
		               |	ПубликуемыеОбъектыКабинетСотрудника.ОбъектПубликации КАК Ссылка
		               |ИЗ
		               |	РегистрСведений.ПубликуемыеОбъектыКабинетСотрудника КАК ПубликуемыеОбъектыКабинетСотрудника
		               |ГДЕ
		               |	ПубликуемыеОбъектыКабинетСотрудника.ОбъектПубликации В(&МассивСсылок)";
	КонецЕсли;
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	ЗарегистрированыКПубликации = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ШаблонСообщения = НСтр("ru = 'Объект ""%1"" не зарегистрирован к публикации. Объект не является публикуемым.';
							|en = 'The ""%1"" object is not registered for publication. The object is not for publication.'");
	Для Каждого Ссылка Из МассивСсылок Цикл
		Если ЗарегистрированыКПубликации.Найти(Ссылка) = Неопределено Тогда
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(ШаблонСообщения, Ссылка));	
		КонецЕсли;
	КонецЦикла;
	
	ОбъектыБезОшибокЗаполнения = КабинетСотрудника.ОбъектыБезОшибокЗаполнения(ЗарегистрированыКПубликации);
	ШаблонСообщения = НСтр("ru = 'Объект ""%1"" не зарегистрирован к публикации. Есть ошибки заполнения.';
							|en = 'The ""%1"" object is not registered for publication. There are filling errors.'");
	Для Каждого Ссылка Из ЗарегистрированыКПубликации Цикл
		Если ОбъектыБезОшибокЗаполнения.Найти(Ссылка) = Неопределено Тогда
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(ШаблонСообщения, Ссылка));	
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОбъектыБезОшибокЗаполнения;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗарегистрироватьДокументыКЭДО(МассивОбъектов, ИмяТаблицы)
	
	Если СтрНайти(ИмяТаблицы, "ЗаявкаСотрудникаСправка2НДФЛ") Тогда
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ЗаявкаСотрудника.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ВТЗаявкиКОбработке
		|ИЗ
		|	БизнесПроцесс.ЗаявкаСотрудникаСправка2НДФЛ КАК ЗаявкаСотрудника
		|ГДЕ
		|	ЗаявкаСотрудника.Ссылка В(&МассивСсылок)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДокументКадровогоЭДО.Ссылка КАК Ссылка
		|ИЗ
		|	БизнесПроцесс.ЗаявкаСотрудникаСправка2НДФЛ.СправкиНДФЛ КАК СправкиНДФЛ
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЗаявкиКОбработке КАК ЗаявкиКОбработке
		|		ПО СправкиНДФЛ.Ссылка = ЗаявкиКОбработке.Ссылка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ДокументКадровогоЭДО КАК ДокументКадровогоЭДО
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИзмененияДокументовДляСервисаКабинетСотрудника КАК ИзмененияДокументов
		|			ПО ДокументКадровогоЭДО.Ссылка = ИзмененияДокументов.ПубликуемыйДокумент
		|		ПО СправкиНДФЛ.Ссылка = ДокументКадровогоЭДО.ОснованиеДокумента
		|			И (ДокументКадровогоЭДО.КатегорияДокумента = ЗНАЧЕНИЕ(Перечисление.КатегорииДокументовКадровогоЭДО.ЗаявлениеСотрудника))
		|ГДЕ
		|	ИзмененияДокументов.ПубликуемыйДокумент ЕСТЬ NULL";
	ИначеЕсли СтрНайти(ИмяТаблицы, "ЗаявкаСотрудникаСправкаСМестаРаботы") Тогда
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДокументКадровогоЭДО.Ссылка КАК Ссылка
		|ИЗ
		|	#ИмяТаблицы КАК ЗаявкаСотрудника
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ДокументКадровогоЭДО КАК ДокументКадровогоЭДО
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИзмененияДокументовДляСервисаКабинетСотрудника КАК ИзмененияДокументов
		|			ПО (ИзмененияДокументов.ПубликуемыйДокумент = ДокументКадровогоЭДО.Ссылка)
		|		ПО ЗаявкаСотрудника.Ссылка = ДокументКадровогоЭДО.ОснованиеДокумента
		|			И (ДокументКадровогоЭДО.КатегорияДокумента = ЗНАЧЕНИЕ(Перечисление.КатегорииДокументовКадровогоЭДО.ЗаявлениеСотрудника))
		|ГДЕ
		|	ИзмененияДокументов.ПубликуемыйДокумент ЕСТЬ NULL
		|	И ЗаявкаСотрудника.Ссылка В(&МассивСсылок)";
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ИмяТаблицы", ИмяТаблицы);
	Иначе
		 Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивОбъектов);
	Запрос.Текст = ТекстЗапроса;
	ТаблицаИзменений = Запрос.Выполнить().Выгрузить();
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ИзмененияДокументовДляСервисаКабинетСотрудника");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.ИсточникДанных = ТаблицаИзменений;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ПубликуемыйДокумент", "Ссылка");
		Блокировка.Заблокировать();
		
		Для каждого СтрокаТЗ Из ТаблицаИзменений Цикл
			МенеджерЗаписи = РегистрыСведений.ИзмененияДокументовДляСервисаКабинетСотрудника.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ПубликуемыйДокумент = СтрокаТЗ.Ссылка;
			МенеджерЗаписи.ВерсияДанных = Строка(Новый УникальныйИдентификатор);
			МенеджерЗаписи.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СнятиеСРегистрации

&НаСервере 
Процедура УбратьРегистрациюВсехОбъектовНаСервере()
	
	Для Каждого ГруппаВидовОбъектов Из ЗарегистрированныеОбъекты.ПолучитьЭлементы() Цикл
		
		ВидыОбъектов = ГруппаВидовОбъектов.ПолучитьЭлементы();
		РегистрИзменений = ВидыОбъектов[0].РегистрИзменений;
				
		Для Каждого ВидОбъектов Из ВидыОбъектов Цикл
			
			Если Не ВидОбъектов.Выбран Тогда
				Продолжить;
			КонецЕсли;
			
			МассивОбъектов = ВидОбъектов.Регистрация.Выгрузить().ВыгрузитьКолонку("Ссылка");
			УбратьРегистрацию(МассивОбъектов, РегистрИзменений, ВидОбъектов.ПолучитьИдентификатор());
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УбратьРегистрацию(МассивОбъектов, НазваниеРегистраИзменений, ИдентификаторСтрокиДерева)
	
	СтрокаДерева = ЗарегистрированныеОбъекты.НайтиПоИдентификатору(ИдентификаторСтрокиДерева);	
	РегистрИзменений = РегистрыСведений[НазваниеРегистраИзменений];
	
	Для Каждого ОбъектРегистрации Из МассивОбъектов Цикл
		
		МенеджерЗаписиИзменений = РегистрИзменений.СоздатьМенеджерЗаписи();
		МенеджерЗаписиИзменений.ПредметПубликации = ОбъектРегистрации;
		МенеджерЗаписиИзменений.Удалить();
		
		РегистрацияКУдалению = СтрокаДерева.Регистрация.НайтиСтроки(Новый Структура("Ссылка", ОбъектРегистрации));
		Если РегистрацияКУдалению.Количество() > 0 Тогда
			СтрокаДерева.Регистрация.Удалить(РегистрацияКУдалению[0]);
			СтрокаДерева.Количество = СтрокаДерева.Количество - 1;
		КонецЕсли;
		
		СтрокаРодитель = СтрокаДерева.ПолучитьРодителя();
		РегистрацияКУдалению = СтрокаРодитель.Регистрация.НайтиСтроки(Новый Структура("Ссылка", ОбъектРегистрации));
		Если РегистрацияКУдалению.Количество() > 0 Тогда
			СтрокаРодитель.Регистрация.Удалить(РегистрацияКУдалению[0]);
			СтрокаРодитель.Количество = СтрокаРодитель.Количество - 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Если НазваниеРегистраИзменений = "ИзмененияЗаявокДляСервисаКабинетСотрудника" Тогда
		
		Если СтрНайти(СтрокаДерева.Тип, "ЗаявкаСотрудникаСправка2НДФЛ") Тогда
			ТекстЗапроса =
			"ВЫБРАТЬ
			|	ЗаявкаСотрудника.Ссылка КАК Ссылка
			|ПОМЕСТИТЬ ВТЗаявкиКОбработке
			|ИЗ
			|	БизнесПроцесс.ЗаявкаСотрудникаСправка2НДФЛ КАК ЗаявкаСотрудника
			|ГДЕ
			|	ЗаявкаСотрудника.Ссылка В(&МассивСсылок)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ДокументКадровогоЭДО.Ссылка КАК Ссылка
			|ИЗ
			|	БизнесПроцесс.ЗаявкаСотрудникаСправка2НДФЛ.СправкиНДФЛ КАК СправкиНДФЛ
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЗаявкиКОбработке КАК ЗаявкиКОбработке
			|		ПО СправкиНДФЛ.Ссылка = ЗаявкиКОбработке.Ссылка
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ДокументКадровогоЭДО КАК ДокументКадровогоЭДО
			|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИзмененияДокументовДляСервисаКабинетСотрудника КАК ИзмененияДокументов
			|			ПО ДокументКадровогоЭДО.Ссылка = ИзмененияДокументов.ПубликуемыйДокумент
			|		ПО СправкиНДФЛ.Ссылка = ДокументКадровогоЭДО.ОснованиеДокумента
			|			И (ДокументКадровогоЭДО.КатегорияДокумента = ЗНАЧЕНИЕ(Перечисление.КатегорииДокументовКадровогоЭДО.ЗаявлениеСотрудника))";
		ИначеЕсли СтрНайти(СтрокаДерева.Тип, "ЗаявкаСотрудникаСправкаСМестаРаботы") Тогда
			ТекстЗапроса =
			"ВЫБРАТЬ
			|	ДокументКадровогоЭДО.Ссылка КАК Ссылка
			|ИЗ
			|	#ИмяТаблицы КАК ЗаявкаСотрудника
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ДокументКадровогоЭДО КАК ДокументКадровогоЭДО
			|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИзмененияДокументовДляСервисаКабинетСотрудника КАК ИзмененияДокументов
			|			ПО (ИзмененияДокументов.ПубликуемыйДокумент = ДокументКадровогоЭДО.Ссылка)
			|		ПО ЗаявкаСотрудника.Ссылка = ДокументКадровогоЭДО.ОснованиеДокумента
			|			И (ДокументКадровогоЭДО.КатегорияДокумента = ЗНАЧЕНИЕ(Перечисление.КатегорииДокументовКадровогоЭДО.ЗаявлениеСотрудника))
			|ГДЕ
			|	ЗаявкаСотрудника.Ссылка В(&МассивСсылок)";
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ИмяТаблицы", СтрокаДерева.Тип);
		Иначе
			Возврат;
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("МассивСсылок", МассивОбъектов);
		Запрос.Текст = ТекстЗапроса;
		ТаблицаИзменений = Запрос.Выполнить().Выгрузить();
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ИзмененияДокументовДляСервисаКабинетСотрудника");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.ИсточникДанных = ТаблицаИзменений;
			ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ПубликуемыйДокумент", "Ссылка");
			Блокировка.Заблокировать();
			
			Для каждого СтрокаТЗ Из ТаблицаИзменений Цикл
				МенеджерЗаписи = РегистрыСведений.ИзмененияДокументовДляСервисаКабинетСотрудника.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.ПубликуемыйДокумент = СтрокаТЗ.Ссылка;
				МенеджерЗаписи.Удалить();
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура УбратьРегистрациюОтборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УбратьРегистрацию(Результат, 
					  ДополнительныеПараметры.РегистрИзменений,
					  ДополнительныеПараметры.ИдентификаторСтрокиДерева);
	
КонецПроцедуры

#КонецОбласти

&НаКлиентеНаСервереБезКонтекста
Функция Описание(ОбъектКонфигурации, Количество)
	
	ШаблонОписания = НСтр("ru = '%1
								|
								|Зарегистрировано к публикации: %2';
								|en = '%1
								|
								|Registered for publication: %2'");
	
	Описание = СтрШаблон(ШаблонОписания, ОбъектКонфигурации, Количество);
	Возврат Описание;
	
КонецФункции

#КонецОбласти