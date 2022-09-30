///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Задать настройки формы отчета.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения
//         - Неопределено
//   КлючВарианта - Строка
//                - Неопределено
//   Настройки - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.ФормироватьСразу = Истина;
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриОпределенииИспользуемыхТаблиц = Истина;
	
КонецПроцедуры

// См. ОтчетыПереопределяемый.ПриСозданииНаСервере
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Если ЗначениеЗаполнено(Форма.НастройкиОтчета.ВариантСсылка) Тогда
		Форма.НастройкиОтчета.Наименование = Форма.НастройкиОтчета.ВариантСсылка;
	КонецЕсли;
	
	Если Форма.КонтекстВарианта = Метаданные.Справочники.Пользователи.ПолноеИмя() Тогда 
		Если Форма.Параметры.ПараметрКоманды.Количество() > 1 Тогда
			Форма.КлючТекущегоВарианта = "ПраваПользователейНаТаблицы";
			Форма.Параметры.КлючВарианта = "ПраваПользователейНаТаблицы";
		Иначе
			Форма.КлючТекущегоВарианта = "ПраваПользователяНаТаблицы";
			Форма.Параметры.КлючВарианта = "ПраваПользователяНаТаблицы";
		КонецЕсли;
		Форма.ВариантыКонтекста.Очистить();
		Форма.ВариантыКонтекста.Добавить(Форма.КлючТекущегоВарианта);
	КонецЕсли;
	
	Если УправлениеДоступомСлужебный.УпрощенныйИнтерфейсНастройкиПравДоступа() Тогда
		Форма.НастройкиОтчета.СхемаМодифицирована = Истина;
		Схема = ПолучитьИзВременногоХранилища(Форма.НастройкиОтчета.АдресСхемы);
		Поле = Схема.НаборыДанных.ПраваПользователей.Поля.Найти("ГруппаДоступа");
		Поле.Заголовок = НСтр("ru = 'Профиль пользователя';
								|en = 'User profile'");
		Поле.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ПрофилиГруппДоступа");
		Форма.НастройкиОтчета.АдресСхемы = ПоместитьВоВременноеХранилище(Схема, Форма.УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//   Например, если схема отчета зависит от ключа варианта или параметров отчета.
//   Чтобы изменения схемы вступили в силу следует вызывать метод ОтчетыСервер.ПодключитьСхему().
//
// Параметры:
//   Контекст - Произвольный - 
//       Параметры контекста, в котором используется отчет.
//       Используется для передачи в параметрах метода ОтчетыСервер.ПодключитьСхему().
//   КлючСхемы - Строка -
//       Идентификатор текущей схемы компоновщика настроек.
//       По умолчанию не заполнен (это означает что компоновщик инициализирован на основании основной схемы).
//       Используется для оптимизации, чтобы переинициализировать компоновщик как можно реже).
//       Может не использоваться если переинициализация выполняется безусловно.
//   КлючВарианта - Строка
//                - Неопределено -
//       Имя предопределенного или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов для варианта расшифровки или без контекста.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных
//                    - Неопределено -
//       Настройки варианта отчета, которые будут загружены в компоновщик настроек после его инициализации.
//       Неопределено когда настройки варианта не надо загружать (уже загружены ранее).
//   НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных
//                                    - Неопределено -
//       Пользовательские настройки, которые будут загружены в компоновщик настроек после его инициализации.
//       Неопределено когда пользовательские настройки не надо загружать (уже загружены ранее).
//
// Пример:
//  // Компоновщик отчета инициализируется на основании схемы из общих макетов:
//	Если КлючСхемы <> "1" Тогда
//		КлючСхемы = "1";
//		СхемаКД = ПолучитьОбщийМакет("МояОбщаяСхемаКомпоновки");
//		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКД, КлючСхемы);
//	КонецЕсли;
//
//  // Схема зависит от значения параметра, выведенного в пользовательские настройки отчета:
//	Если ТипЗнч(НовыеПользовательскиеНастройкиКД) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
//		ПолноеИмяОбъектаМетаданных = "";
//		Для Каждого ЭлементКД Из НовыеПользовательскиеНастройкиКД.Элементы Цикл
//			Если ТипЗнч(ЭлементКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
//				ИмяПараметра = Строка(ЭлементКД.Параметр);
//				Если ИмяПараметра = "ОбъектМетаданных" Тогда
//					ПолноеИмяОбъектаМетаданных = ЭлементКД.Значение;
//				КонецЕсли;
//			КонецЕсли;
//		КонецЦикла;
//		Если КлючСхемы <> ПолноеИмяОбъектаМетаданных Тогда
//			КлючСхемы = ПолноеИмяОбъектаМетаданных;
//			СхемаКД = Новый СхемаКомпоновкиДанных;
//			// Наполнение схемы...
//			ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКД, КлючСхемы);
//		КонецЕсли;
//	КонецЕсли;
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если КлючСхемы = "1" Тогда
		Возврат;
	КонецЕсли;
	
	КлючСхемы = "1";
	
	Если ТипЗнч(Контекст) = Тип("ФормаКлиентскогоПриложения") И НовыеНастройкиКД <> Неопределено Тогда
		
		РеквизитыФормы = Новый Структура("КонтекстВарианта");
		ЗаполнитьЗначенияСвойств(РеквизитыФормы, Контекст);
		
		Если ЗначениеЗаполнено(РеквизитыФормы.КонтекстВарианта) Тогда
			Если КлючВарианта = "ПраваПользователейНаТаблицу" Тогда
				ОбъектМетаданных = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Контекст.КонтекстВарианта, Ложь);
				Если ЗначениеЗаполнено(ОбъектМетаданных) Тогда
					ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(НовыеНастройкиКД.Отбор, "ОбъектМетаданных", ОбъектМетаданных,
						ВидСравненияКомпоновкиДанных.Равно, , Истина);
				КонецЕсли;
			ИначеЕсли КлючВарианта = "ПраваПользователейНаТаблицы" Или КлючВарианта = "ПраваПользователяНаТаблицы" Тогда
				Если Контекст.Параметры.Свойство("ПараметрКоманды") Тогда
					СписокПользователей = Новый СписокЗначений;
					СписокПользователей.ЗагрузитьЗначения(Контекст.Параметры.ПараметрКоманды);
					УстановитьОтборПоПользователям(НовыеНастройкиКД, СписокПользователей);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Список регистров и других объектов метаданных, по которым формируется отчет.
//   Используется для проверки что отчет может содержать не обновленные данные.
//
// Параметры:
//   КлючВарианта - Строка
//                - Неопределено -
//       Имя предопределенного или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов для варианта расшифровки или без контекста.
//   ИспользуемыеТаблицы - Массив - 
//       Полные имена объектов метаданных (регистров, документов и других таблиц),
//       данные которых выводятся в отчете.
//
// Пример:
//	ИспользуемыеТаблицы.Добавить(Метаданные.Документы._ДемоЗаказПокупателя.ПолноеИмя());
//
Процедура ПриОпределенииИспользуемыхТаблиц(КлючВарианта, ИспользуемыеТаблицы) Экспорт
	
	ИспользуемыеТаблицы.Добавить(Метаданные.РегистрыСведений.ПраваРолей.ПолноеИмя());
	ИспользуемыеТаблицы.Добавить(Метаданные.Справочники.ПрофилиГруппДоступа.ПолноеИмя());
	ИспользуемыеТаблицы.Добавить(Метаданные.Справочники.ГруппыДоступа.ПолноеИмя());
	ИспользуемыеТаблицы.Добавить(Метаданные.РегистрыСведений.СоставыГруппПользователей.ПолноеИмя());
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

// Параметры:
//  ДокументРезультат - ТабличныйДокумент
//  ДанныеРасшифровки - ДанныеРасшифровкиКомпоновкиДанных
//  СтандартнаяОбработка - Булево
//
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиКомпоновщика = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновщика, ДанныеРасшифровки);
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ПраваПользователей", ПраваПользователей());
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных , ДанныеРасшифровки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ГруппаДоступаЗаголовок = НСтр("ru = 'Группа доступа';
									|en = 'Access group'");
	Если УправлениеДоступомСлужебный.УпрощенныйИнтерфейсНастройкиПравДоступа() Тогда
		ГруппаДоступаЗаголовок = НСтр("ru = 'Профиль пользователя';
										|en = 'User profile'");
	КонецЕсли;
	
	КартинкаПросмотр       = БиблиотекаКартинок.Просмотр;
	КартинкаРедактирование = БиблиотекаКартинок.Редактирование;
	КартинкаСоздание       = БиблиотекаКартинок.Создание;
	
	Для НомерСтроки = 1 По ДокументРезультат.ВысотаТаблицы Цикл
		Для НомерКолонки = 1 По ДокументРезультат.ШиринаТаблицы Цикл
			Область = ДокументРезультат.Область(НомерСтроки, НомерКолонки);
			
			Если Область.Текст = "&ГруппаДоступаЗаголовок" Тогда
				Область.Текст = ГруппаДоступаЗаголовок;
			КонецЕсли;
			
			Если ТипЗнч(Область.Расшифровка) <> Тип("ИдентификаторРасшифровкиКомпоновкиДанных") Тогда
				Продолжить;
			КонецЕсли;
			
			ЗначенияПолей = ДанныеРасшифровки.Элементы[Область.Расшифровка].ПолучитьПоля();
			
			ЗначениеПоляПраво = ЗначенияПолей.Найти("Право");
			Если ЗначениеПоляПраво <> Неопределено Тогда
				
				Если ЗначениеПоляПраво.Значение = 1 Тогда
					Область.Картинка = КартинкаПросмотр;
					
				ИначеЕсли ЗначениеПоляПраво.Значение = 2 Тогда
					Область.Картинка = КартинкаРедактирование;
					
				ИначеЕсли ЗначениеПоляПраво.Значение = 3 Тогда
					Область.Картинка = КартинкаСоздание;
				КонецЕсли;
				
			ИначеЕсли ЗначенияПолей.Найти("ПравоПросмотр") <> Неопределено
			        И ЗначенияПолей.Найти("ПравоПросмотр").Значение = Истина Тогда
				
				Область.Картинка = КартинкаПросмотр;
				
			ИначеЕсли ЗначенияПолей.Найти("ПравоРедактирование") <> Неопределено
			        И ЗначенияПолей.Найти("ПравоРедактирование").Значение = Истина Тогда
				
				Область.Картинка = КартинкаРедактирование;
				
			ИначеЕсли ЗначенияПолей.Найти("ПравоИнтерактивноеДобавление") <> Неопределено
			        И ЗначенияПолей.Найти("ПравоИнтерактивноеДобавление").Значение = Истина Тогда
				
				Область.Картинка = КартинкаСоздание;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТаблицыОтчетов()
	
	Результат = ПустаяКоллекцияТаблицОтчетов();
	ОписаниеТиповИдентификатора = ОписаниеТиповИдентификатора();
	
	ВыбранныйОтчет = ВыбранныйОтчет();
	ИспользуемыеТаблицы = Неопределено;
	
	Если ЗначениеЗаполнено(ВыбранныйОтчет)
		И КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("ИспользуемыеТаблицы", ИспользуемыеТаблицы)
		И ИспользуемыеТаблицы <> Неопределено Тогда 
		
		ИдентификаторыОбъектовМетаданных =
			ОбщегоНазначения.ИдентификаторыОбъектовМетаданных(ИспользуемыеТаблицы, Ложь);
		
		Для Каждого Таблица Из ИспользуемыеТаблицы Цикл
			ИдентификаторТаблицы = ИдентификаторыОбъектовМетаданных[Таблица];
			СтрокаТаблицы = Результат.Добавить();
			СтрокаТаблицы.Отчет = ВыбранныйОтчет;
			СтрокаТаблицы.ОбъектМетаданных = ИдентификаторТаблицы;
		КонецЦикла;
		
		Если Не ЗначениеЗаполнено(Результат) Тогда
			СтрокаТаблицы = Результат.Добавить();
			СтрокаТаблицы.Отчет = ВыбранныйОтчет;
			СтрокаТаблицы.ОбъектМетаданных = Неопределено;
		КонецЕсли;
		
		Возврат Результат;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВыбранныйОтчет)
	   И ОписаниеТиповИдентификатора.СодержитТип(ТипЗнч(ВыбранныйОтчет)) Тогда
		
		ОбъектМетаданныхВыбранныйОтчет =
			ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ВыбранныйОтчет, Ложь);
	КонецЕсли;
	
	ТаблицыОтчетов = Новый ТаблицаЗначений;
	ТаблицыОтчетов.Колонки.Добавить("Отчет");
	ТаблицыОтчетов.Колонки.Добавить("ОбъектМетаданных");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
		ВладельцыТаблиц = Новый Соответствие;
		Для Каждого ОбъектМетаданныхОтчет Из Метаданные.Отчеты Цикл
			Если ТипЗнч(ОбъектМетаданныхВыбранныйОтчет) = Тип("ОбъектМетаданных")
			   И ОбъектМетаданныхОтчет <> ОбъектМетаданныхВыбранныйОтчет Тогда
				Продолжить;
			КонецЕсли;
			Если Не ПравоДоступа("Просмотр", ОбъектМетаданныхОтчет) Тогда
				Продолжить;
			КонецЕсли;
			ИспользуемыеТаблицы = МодульВариантыОтчетов.ИспользуемыеТаблицыОтчета(ОбъектМетаданныхОтчет);
			
			Для Каждого ИмяТаблицы Из ИспользуемыеТаблицы Цикл
				ИспользуемаяТаблица = ВладельцыТаблиц[ИмяТаблицы];
				Если ИспользуемаяТаблица = Неопределено Тогда
					ВладелецТаблицы = ИмяТаблицы;
					ЧастиСтроки = СтрРазделить(ВладелецТаблицы, ".", Истина);
					Если ЧастиСтроки.Количество() = 1 Тогда
						Продолжить;
					КонецЕсли;
					Если ЧастиСтроки.Количество() > 2 Тогда
						ВладелецТаблицы = ЧастиСтроки[0] + "." + ЧастиСтроки[1];
					КонецЕсли;
					ВладельцыТаблиц.Вставить(ИмяТаблицы, ВладелецТаблицы);
					ИспользуемаяТаблица = ВладелецТаблицы;
				КонецЕсли;
				
				СтрокаТаблицы = ТаблицыОтчетов.Добавить();
				СтрокаТаблицы.Отчет = ОбъектМетаданныхОтчет.ПолноеИмя();
				СтрокаТаблицы.ОбъектМетаданных = ИспользуемаяТаблица;
			КонецЦикла;
		КонецЦикла;
		ТаблицыОтчетов.Свернуть("Отчет, ОбъектМетаданных");
	КонецЕсли;
	
	ИменаОбъектовМетаданных = ТаблицыОтчетов.ВыгрузитьКолонку("ОбъектМетаданных");
	ОтчетыСТаблицами = Новый Соответствие;
	Для Каждого ОбъектМетаданныхОтчет Из Метаданные.Отчеты Цикл
		Если ТипЗнч(ОбъектМетаданныхВыбранныйОтчет) = Тип("ОбъектМетаданных")
		   И ОбъектМетаданныхОтчет <> ОбъектМетаданныхВыбранныйОтчет Тогда
			Продолжить;
		КонецЕсли;
		ПолноеИмяОтчета = ОбъектМетаданныхОтчет.ПолноеИмя();
		ОтчетыСТаблицами.Вставить(ПолноеИмяОтчета, Ложь);
		ИменаОбъектовМетаданных.Добавить(ПолноеИмяОтчета);
	КонецЦикла;
	
	ИдентификаторыОбъектовМетаданных =
		ОбщегоНазначения.ИдентификаторыОбъектовМетаданных(ИменаОбъектовМетаданных, Ложь);
	
	Для Каждого СтрокаТаблицы Из ТаблицыОтчетов Цикл
		ИдентификаторТаблицы = ИдентификаторыОбъектовМетаданных[СтрокаТаблицы.ОбъектМетаданных];
		Если Не ЗначениеЗаполнено(ИдентификаторТаблицы) Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = Результат.Добавить();
		НоваяСтрока.Отчет            = ИдентификаторыОбъектовМетаданных[СтрокаТаблицы.Отчет];
		НоваяСтрока.ОбъектМетаданных = ИдентификаторТаблицы;
		ОтчетыСТаблицами.Вставить(СтрокаТаблицы.Отчет, Истина);
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из ОтчетыСТаблицами Цикл
		Если КлючИЗначение.Значение Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = Результат.Добавить();
		НоваяСтрока.Отчет = ИдентификаторыОбъектовМетаданных[КлючИЗначение.Ключ];
		НоваяСтрока.ОбъектМетаданных = Неопределено;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ОписаниеТиповИдентификатора()
	
	Возврат Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных,
		|СправочникСсылка.ИдентификаторыОбъектовРасширений");
	
КонецФункции

Функция ПустаяКоллекцияТаблицОтчетов()
	
	ОписаниеТиповИдентификатора = ОписаниеТиповИдентификатора();
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Отчет", ОписаниеТиповИдентификатора);
	Результат.Колонки.Добавить("ОбъектМетаданных", ОписаниеТиповИдентификатора);
	
	Возврат Результат;
	
КонецФункции

Функция ПраваРолейНаОтчеты()
	
	Результат = ПустаяКоллекцияПравРолейНаОтчеты();
	ОписаниеТиповИдентификатора = ОписаниеТиповИдентификатора();
	
	ВыбранныйОтчет = ВыбранныйОтчет();
	
	Если ЗначениеЗаполнено(ВыбранныйОтчет)
	   И ОписаниеТиповИдентификатора.СодержитТип(ТипЗнч(ВыбранныйОтчет)) Тогда
		
		ОбъектМетаданныхВыбранныйОтчет =
			ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ВыбранныйОтчет, Ложь);
	КонецЕсли;
	
	ИменаОбъектовМетаданных = Новый Массив;
	Для Каждого ОбъектМетаданныхРоль Из Метаданные.Роли Цикл
		ИменаОбъектовМетаданных.Добавить(ОбъектМетаданныхРоль.ПолноеИмя());
	КонецЦикла;
	Для Каждого ОбъектМетаданныхОтчет Из Метаданные.Отчеты Цикл
		Если ТипЗнч(ОбъектМетаданныхВыбранныйОтчет) = Тип("ОбъектМетаданных")
		   И ОбъектМетаданныхОтчет <> ОбъектМетаданныхВыбранныйОтчет Тогда
			Продолжить;
		КонецЕсли;
		ИменаОбъектовМетаданных.Добавить(ОбъектМетаданныхОтчет.ПолноеИмя());
	КонецЦикла;
	
	ИдентификаторыОбъектовМетаданных =
		ОбщегоНазначения.ИдентификаторыОбъектовМетаданных(ИменаОбъектовМетаданных, Ложь);
	
	Для Каждого ОбъектМетаданныхОтчет Из Метаданные.Отчеты Цикл
		Если ТипЗнч(ОбъектМетаданныхВыбранныйОтчет) = Тип("ОбъектМетаданных")
		   И ОбъектМетаданныхОтчет <> ОбъектМетаданныхВыбранныйОтчет Тогда
			Продолжить;
		КонецЕсли;
		Для Каждого ОбъектМетаданныхРоль Из Метаданные.Роли Цикл
			Если ПравоДоступа("Просмотр", ОбъектМетаданныхОтчет, ОбъектМетаданныхРоль) Тогда
				СтрокаТаблицы = Результат.Добавить();
				СтрокаТаблицы.Отчет = ИдентификаторыОбъектовМетаданных[ОбъектМетаданныхОтчет.ПолноеИмя()];
				СтрокаТаблицы.Роль  = ИдентификаторыОбъектовМетаданных[ОбъектМетаданныхРоль.ПолноеИмя()];
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПустаяКоллекцияПравРолейНаОтчеты()
	
	ОписаниеТиповИдентификатора = ОписаниеТиповИдентификатора();
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Отчет", ОписаниеТиповИдентификатора);
	Результат.Колонки.Добавить("Роль", ОписаниеТиповИдентификатора);
	
	Возврат Результат;
	
КонецФункции

Функция ПраваПользователей()
	
	ТекстЗапросаОбщий =
	"ВЫБРАТЬ
	|	ПраваРолейРасширений.ОбъектМетаданных КАК ОбъектМетаданных,
	|	ПраваРолейРасширений.Роль КАК Роль,
	|	ПраваРолейРасширений.ПравоПросмотр КАК ПравоПросмотр,
	|	ПраваРолейРасширений.ПравоРедактирование КАК ПравоРедактирование,
	|	ПраваРолейРасширений.ПравоИнтерактивноеДобавление КАК ПравоИнтерактивноеДобавление,
	|	ПраваРолейРасширений.ВидИзмененияСтроки КАК ВидИзмененияСтроки
	|ПОМЕСТИТЬ ПраваРолейРасширений
	|ИЗ
	|	&ПраваРолейРасширений КАК ПраваРолейРасширений
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПраваРолейРасширений.ОбъектМетаданных КАК ОбъектМетаданных,
	|	ПраваРолейРасширений.Роль КАК Роль,
	|	ПраваРолейРасширений.ПравоПросмотр КАК ПравоПросмотр,
	|	ПраваРолейРасширений.ПравоРедактирование КАК ПравоРедактирование,
	|	ПраваРолейРасширений.ПравоИнтерактивноеДобавление КАК ПравоИнтерактивноеДобавление
	|ПОМЕСТИТЬ ПраваРолей
	|ИЗ
	|	ПраваРолейРасширений КАК ПраваРолейРасширений
	|ГДЕ
	|	ПраваРолейРасширений.ВидИзмененияСтроки = 1
	|	И ПраваРолейРасширений.ПравоПросмотр = ИСТИНА
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПраваРолей.ОбъектМетаданных,
	|	ПраваРолей.Роль,
	|	ПраваРолей.ПравоПросмотр,
	|	ПраваРолей.ПравоРедактирование,
	|	ПраваРолей.ПравоИнтерактивноеДобавление
	|ИЗ
	|	РегистрСведений.ПраваРолей КАК ПраваРолей
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПраваРолейРасширений КАК ПраваРолейРасширений
	|		ПО ПраваРолей.ОбъектМетаданных = ПраваРолейРасширений.ОбъектМетаданных
	|			И ПраваРолей.Роль = ПраваРолейРасширений.Роль
	|ГДЕ
	|	ПраваРолейРасширений.ОбъектМетаданных ЕСТЬ NULL
	|	И ПраваРолей.ПравоПросмотр = ИСТИНА
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Роль
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПрофилиГруппДоступаРоли.Ссылка КАК Профиль,
	|	ПраваРолей.ОбъектМетаданных КАК Таблица,
	|	МАКСИМУМ(ПраваРолей.ПравоПросмотр) КАК ПравоПросмотр,
	|	МАКСИМУМ(ПраваРолей.ПравоРедактирование) КАК ПравоРедактирование,
	|	МАКСИМУМ(ПраваРолей.ПравоИнтерактивноеДобавление) КАК ПравоИнтерактивноеДобавление
	|ПОМЕСТИТЬ ПраваПрофилейНаТаблицы
	|ИЗ
	|	ПраваРолей КАК ПраваРолей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПрофилиГруппДоступа.Роли КАК ПрофилиГруппДоступаРоли
	|		ПО ПраваРолей.Роль = ПрофилиГруппДоступаРоли.Роль
	|			И (НЕ ПрофилиГруппДоступаРоли.Ссылка.ПометкаУдаления)
	|ГДЕ
	|	&ОтборПравПоТаблицам
	|
	|СГРУППИРОВАТЬ ПО
	|	ПрофилиГруппДоступаРоли.Ссылка,
	|	ПраваРолей.ОбъектМетаданных
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Таблица";
	
	ТекстЗапросаБезГруппировкиПоОтчетам =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПраваПрофилей.Таблица КАК ОбъектМетаданных,
	|	ВЫБОР
	|		КОГДА &УпрощенныйИнтерфейсНастройкиПравДоступа
	|			ТОГДА ГруппыДоступа.Профиль
	|		ИНАЧЕ ГруппыДоступа.Ссылка
	|	КОНЕЦ КАК ГруппаДоступа,
	|	ПраваПрофилей.ПравоПросмотр КАК ПравоПросмотр,
	|	ПраваПрофилей.ПравоРедактирование КАК ПравоРедактирование,
	|	ПраваПрофилей.ПравоИнтерактивноеДобавление КАК ПравоИнтерактивноеДобавление,
	|	ВЫБОР
	|		КОГДА ПраваПрофилей.ПравоИнтерактивноеДобавление
	|			ТОГДА 3
	|		КОГДА ПраваПрофилей.ПравоРедактирование
	|			ТОГДА 2
	|		КОГДА ПраваПрофилей.ПравоПросмотр
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Право,
	|	СоставыГруппПользователей.Пользователь КАК Пользователь,
	|	СоставыГруппПользователей.Используется КАК ВходВПрограммуРазрешен,
	|	НЕОПРЕДЕЛЕНО КАК Отчет,
	|	0 КАК ПравоОтчета
	|ИЗ
	|	ПраваПрофилейНаТаблицы КАК ПраваПрофилей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа КАК ГруппыДоступа
	|		ПО (ГруппыДоступа.Профиль = ПраваПрофилей.Профиль)
	|			И (НЕ ГруппыДоступа.ПометкаУдаления)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК УчастникиГруппДоступа
	|		ПО (УчастникиГруппДоступа.Ссылка = ГруппыДоступа.Ссылка)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
	|		ПО (СоставыГруппПользователей.ГруппаПользователей = УчастникиГруппДоступа.Пользователь)
	|			И (ТИПЗНАЧЕНИЯ(СоставыГруппПользователей.Пользователь) = ТИП(Справочник.Пользователи))
	|			И (СоставыГруппПользователей.Пользователь <> &ПользовательНеУказан)";
	
	ТекстЗапросаСГруппировкойПоОтчетамДополнение =
	"ВЫБРАТЬ
	|	ПраваРолейНаОтчеты.Отчет КАК Отчет,
	|	ПраваРолейНаОтчеты.Роль КАК Роль
	|ПОМЕСТИТЬ ПраваРолейНаОтчеты
	|ИЗ
	|	&ПраваРолейНаОтчеты КАК ПраваРолейНаОтчеты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПрофилиГруппДоступаРоли.Ссылка КАК Профиль,
	|	ПраваРолейНаОтчеты.Отчет КАК Отчет
	|ПОМЕСТИТЬ ПраваПрофилейНаОтчеты
	|ИЗ
	|	ПраваРолейНаОтчеты КАК ПраваРолейНаОтчеты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПрофилиГруппДоступа.Роли КАК ПрофилиГруппДоступаРоли
	|		ПО ПраваРолейНаОтчеты.Роль = ПрофилиГруппДоступаРоли.Роль
	|			И (НЕ ПрофилиГруппДоступаРоли.Ссылка.ПометкаУдаления)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Отчет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицыОтчетов.Отчет КАК Отчет,
	|	ТаблицыОтчетов.ОбъектМетаданных КАК Таблица
	|ПОМЕСТИТЬ ТаблицыОтчетов
	|ИЗ
	|	&ТаблицыОтчетов КАК ТаблицыОтчетов
	|ГДЕ
	|	&ОтборОтчетовПоТаблицам
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицыОтчетовСПравами.Отчет КАК Отчет,
	|	ТаблицыОтчетовСПравами.Таблица КАК Таблица,
	|	ТаблицыОтчетовСПравами.Профиль КАК Профиль,
	|	МАКСИМУМ(ТаблицыОтчетовСПравами.ПравоОтчета) КАК ПравоОтчета,
	|	МАКСИМУМ(ТаблицыОтчетовСПравами.ПравоПросмотр) КАК ПравоПросмотр,
	|	МАКСИМУМ(ТаблицыОтчетовСПравами.ПравоРедактирование) КАК ПравоРедактирование,
	|	МАКСИМУМ(ТаблицыОтчетовСПравами.ПравоИнтерактивноеДобавление) КАК ПравоИнтерактивноеДобавление
	|ПОМЕСТИТЬ ПраваПрофилей
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицыОтчетов.Отчет КАК Отчет,
	|		ТаблицыОтчетов.Таблица КАК Таблица,
	|		ПраваПрофилейНаОтчеты.Профиль КАК Профиль,
	|		ИСТИНА КАК ПравоОтчета,
	|		ЛОЖЬ КАК ПравоПросмотр,
	|		ЛОЖЬ КАК ПравоРедактирование,
	|		ЛОЖЬ КАК ПравоИнтерактивноеДобавление
	|	ИЗ
	|		ТаблицыОтчетов КАК ТаблицыОтчетов
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПраваПрофилейНаОтчеты КАК ПраваПрофилейНаОтчеты
	|			ПО (ПраваПрофилейНаОтчеты.Отчет = ТаблицыОтчетов.Отчет)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицыОтчетов.Отчет,
	|		ТаблицыОтчетов.Таблица,
	|		ПраваПрофилейНаТаблицы.Профиль,
	|		ЛОЖЬ,
	|		ПраваПрофилейНаТаблицы.ПравоПросмотр,
	|		ПраваПрофилейНаТаблицы.ПравоРедактирование,
	|		ПраваПрофилейНаТаблицы.ПравоИнтерактивноеДобавление
	|	ИЗ
	|		ТаблицыОтчетов КАК ТаблицыОтчетов
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПраваПрофилейНаТаблицы КАК ПраваПрофилейНаТаблицы
	|			ПО (ПраваПрофилейНаТаблицы.Таблица = ТаблицыОтчетов.Таблица)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицыОтчетов.Отчет,
	|		ТаблицыОтчетов.Таблица,
	|		ЗНАЧЕНИЕ(Справочник.ПрофилиГруппДоступа.ПустаяСсылка),
	|		ЛОЖЬ,
	|		ЛОЖЬ,
	|		ЛОЖЬ,
	|		ЛОЖЬ
	|	ИЗ
	|		ТаблицыОтчетов КАК ТаблицыОтчетов
	|	ГДЕ
	|		НЕ ИСТИНА В
	|					(ВЫБРАТЬ ПЕРВЫЕ 1
	|						ИСТИНА
	|					ИЗ
	|						ПраваПрофилейНаОтчеты КАК ПраваПрофилейНаОтчеты
	|					ГДЕ
	|						ПраваПрофилейНаОтчеты.Отчет = ТаблицыОтчетов.Отчет)
	|		И НЕ ИСТИНА В
	|					(ВЫБРАТЬ ПЕРВЫЕ 1
	|						ИСТИНА
	|					ИЗ
	|						ПраваПрофилейНаТаблицы КАК ПраваПрофилейНаТаблицы
	|					ГДЕ
	|						ПраваПрофилейНаТаблицы.Таблица = ТаблицыОтчетов.Таблица)) КАК ТаблицыОтчетовСПравами
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицыОтчетовСПравами.Отчет,
	|	ТаблицыОтчетовСПравами.Таблица,
	|	ТаблицыОтчетовСПравами.Профиль";
	
	ТекстЗапросаСГруппировкойПоОтчетам =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПраваПрофилей.Отчет КАК Отчет,
	|	ВЫБОР
	|		КОГДА ПраваПрофилей.ПравоОтчета
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ПравоОтчета,
	|	ПраваПрофилей.Таблица КАК ОбъектМетаданных,
	|	ВЫБОР
	|		КОГДА &УпрощенныйИнтерфейсНастройкиПравДоступа
	|			ТОГДА ГруппыДоступа.Профиль
	|		ИНАЧЕ ГруппыДоступа.Ссылка
	|	КОНЕЦ КАК ГруппаДоступа,
	|	ПраваПрофилей.ПравоПросмотр КАК ПравоПросмотр,
	|	ПраваПрофилей.ПравоРедактирование КАК ПравоРедактирование,
	|	ПраваПрофилей.ПравоИнтерактивноеДобавление КАК ПравоИнтерактивноеДобавление,
	|	ВЫБОР
	|		КОГДА ПраваПрофилей.ПравоИнтерактивноеДобавление
	|			ТОГДА 3
	|		КОГДА ПраваПрофилей.ПравоРедактирование
	|			ТОГДА 2
	|		КОГДА ПраваПрофилей.ПравоПросмотр
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Право,
	|	СоставыГруппПользователей.Пользователь КАК Пользователь,
	|	СоставыГруппПользователей.Используется КАК ВходВПрограммуРазрешен
	|ПОМЕСТИТЬ ПраваПользователей
	|ИЗ
	|	ПраваПрофилей КАК ПраваПрофилей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа КАК ГруппыДоступа
	|		ПО (ГруппыДоступа.Профиль = ПраваПрофилей.Профиль)
	|			И (НЕ ГруппыДоступа.ПометкаУдаления)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК УчастникиГруппДоступа
	|		ПО (УчастникиГруппДоступа.Ссылка = ГруппыДоступа.Ссылка)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
	|		ПО (СоставыГруппПользователей.ГруппаПользователей = УчастникиГруппДоступа.Пользователь)
	|			И (ТИПЗНАЧЕНИЯ(СоставыГруппПользователей.Пользователь) = ТИП(Справочник.Пользователи))
	|			И (СоставыГруппПользователей.Пользователь <> &ПользовательНеУказан)";
	
	ТекстЗапросаСГруппировкойПоОтчетамКонечный =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПраваПользователей.Пользователь КАК Пользователь,
	|	ПраваПользователей.ВходВПрограммуРазрешен КАК ВходВПрограммуРазрешен
	|ПОМЕСТИТЬ ПользователиСПравами
	|ИЗ
	|	ПраваПользователей КАК ПраваПользователей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПраваПользователей.Отчет КАК Отчет,
	|	ПраваПользователей.ПравоОтчета КАК ПравоОтчета,
	|	ПраваПользователей.ОбъектМетаданных КАК ОбъектМетаданных,
	|	ПраваПользователей.ГруппаДоступа КАК ГруппаДоступа,
	|	ПраваПользователей.ПравоПросмотр КАК ПравоПросмотр,
	|	ПраваПользователей.ПравоРедактирование КАК ПравоРедактирование,
	|	ПраваПользователей.ПравоИнтерактивноеДобавление КАК ПравоИнтерактивноеДобавление,
	|	ПраваПользователей.Право КАК Право,
	|	ПраваПользователей.Пользователь КАК Пользователь,
	|	ПраваПользователей.ВходВПрограммуРазрешен КАК ВходВПрограммуРазрешен
	|ИЗ
	|	ПраваПользователей КАК ПраваПользователей
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицыОтчетов.Отчет,
	|	0,
	|	ТаблицыОтчетов.Таблица,
	|	ВЫБОР
	|		КОГДА &УпрощенныйИнтерфейсНастройкиПравДоступа
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ПрофилиГруппДоступа.ПустаяСсылка)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ГруппыДоступа.ПустаяСсылка)
	|	КОНЕЦ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	0,
	|	ПользователиСПравами.Пользователь,
	|	ПользователиСПравами.ВходВПрограммуРазрешен
	|ИЗ
	|	ТаблицыОтчетов КАК ТаблицыОтчетов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПользователиСПравами КАК ПользователиСПравами
	|		ПО (НЕ ИСТИНА В
	|					(ВЫБРАТЬ ПЕРВЫЕ 1
	|						ИСТИНА
	|					ИЗ
	|						ПраваПользователей КАК ПраваПользователей
	|					ГДЕ
	|						ПраваПользователей.Отчет = ТаблицыОтчетов.Отчет
	|						И ПраваПользователей.ОбъектМетаданных = ТаблицыОтчетов.Таблица
	|						И ПраваПользователей.Пользователь = ПользователиСПравами.Пользователь))";
	
	Запрос = Новый Запрос;
	ВключенаГруппировкаПоОтчетам = ВключенаГруппировкаПоОтчетам();
	
	Если ВключенаГруппировкаПоОтчетам Тогда
		ТекстЗапросаОсновной = ТекстЗапросаСГруппировкойПоОтчетам;
		Запрос.Текст = ТекстЗапросаОбщий + ОбщегоНазначения.РазделительПакетаЗапросов()
			+ ТекстЗапросаСГруппировкойПоОтчетамДополнение;
		Запрос.УстановитьПараметр("ПраваРолейНаОтчеты", ПраваРолейНаОтчеты());
		Запрос.УстановитьПараметр("ТаблицыОтчетов",     ТаблицыОтчетов());
	Иначе
		ТекстЗапросаОсновной = ТекстЗапросаБезГруппировкиПоОтчетам;
		Запрос.Текст = ТекстЗапросаОбщий;
	КонецЕсли;
	
	УпрощенныйИнтерфейс = УправлениеДоступомСлужебный.УпрощенныйИнтерфейсНастройкиПравДоступа();
	Если Не УпрощенныйИнтерфейс Тогда
		ТекстЗапросаОсновной = СтрЗаменить(ТекстЗапросаОсновной,
			"ВЫБРАТЬ РАЗЛИЧНЫЕ", "ВЫБРАТЬ"); // @query-part-1 @query-part-2
	КонецЕсли;
	Запрос.Текст = Запрос.Текст + ОбщегоНазначения.РазделительПакетаЗапросов()
		+ ТекстЗапросаОсновной;

	УстановитьПривилегированныйРежим(Истина);	
	Запрос.УстановитьПараметр("УпрощенныйИнтерфейсНастройкиПравДоступа", УпрощенныйИнтерфейс);
	Запрос.УстановитьПараметр("ПраваРолейРасширений", УправлениеДоступомСлужебный.ПраваРолейРасширений());
	Запрос.УстановитьПараметр("ПользовательНеУказан", Пользователи.СсылкаНеуказанногоПользователя());
	
	ОтборПоТаблицам = ОтборПоТаблицам();
	Если ЗначениеЗаполнено(ОтборПоТаблицам) Тогда
		Запрос.УстановитьПараметр("ВыбранныеТаблицы", ОтборПоТаблицам);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПравПоТаблицам",
			"ПраваРолей.ОбъектМетаданных В (&ВыбранныеТаблицы)");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборОтчетовПоТаблицам",
			"ТаблицыОтчетов.ОбъектМетаданных В (&ВыбранныеТаблицы)");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПравПоТаблицам", "ИСТИНА");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборОтчетовПоТаблицам", "ИСТИНА");
	КонецЕсли;
	
	УсловиеОтбораПоПользователям = "";
	Если ОтборПоВходВПрограммуРазрешен() Тогда
		УсловиеОтбораПоПользователям = "
		|			И СоставыГруппПользователей.Используется";
	КонецЕсли;
	
	ОтборПоПользователям = ОтборПоПользователям();
	Если ЗначениеЗаполнено(ОтборПоПользователям.Значение) И ОтборПоПользователям.БезГрупп Тогда
		Запрос.УстановитьПараметр("ВыбранныеПользователиБезГрупп", ОтборПоПользователям.Значение);
		УсловиеОтбораПоПользователям = УсловиеОтбораПоПользователям + "
			|			И СоставыГруппПользователей.Пользователь В (&ВыбранныеПользователиБезГрупп)";
		
	ИначеЕсли ЗначениеЗаполнено(ОтборПоПользователям.Значение) Тогда
		Запрос.УстановитьПараметр("ВыбранныеПользователиИГруппы", ОтборПоПользователям.Значение);
		УсловиеОтбораПоПользователям = УсловиеОтбораПоПользователям + "
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК ОтборПользователей
			|		ПО (ОтборПользователей.Пользователь = СоставыГруппПользователей.Пользователь)
			|			И (ОтборПользователей.ГруппаПользователей В (&ВыбранныеПользователиИГруппы))";
	КонецЕсли;
	Запрос.Текст = Запрос.Текст + УсловиеОтбораПоПользователям;
	
	Если ВключенаГруппировкаПоОтчетам Тогда
		Запрос.Текст = Запрос.Текст + "
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Отчет,
		|	ОбъектМетаданных,
		|	Пользователь";
		Запрос.Текст = Запрос.Текст + ОбщегоНазначения.РазделительПакетаЗапросов()
			+ ТекстЗапросаСГруппировкойПоОтчетамКонечный;
	КонецЕсли;
	
	Результат = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции

Функция ВключенаГруппировкаПоОтчетам()
	
	СписокПолей = Новый Массив;
	ЗаполнитьСписокПолейГруппировок(КомпоновщикНастроек.ПолучитьНастройки().Структура, СписокПолей);
	
	Возврат СписокПолей.Найти(Новый ПолеКомпоновкиДанных("Отчет")) <> Неопределено;
	
КонецФункции

// Параметры:
//  КоллекцияЭлементов - КоллекцияЭлементовСтруктурыНастроекКомпоновкиДанных
//  СписокПолей - Массив
//
Процедура ЗаполнитьСписокПолейГруппировок(КоллекцияЭлементов, СписокПолей)
	
	Для Каждого Элемент Из КоллекцияЭлементов Цикл
		Если (ТипЗнч(Элемент) = Тип("ГруппировкаКомпоновкиДанных")
			Или ТипЗнч(Элемент) = Тип("ГруппировкаТаблицыКомпоновкиДанных"))
			И Элемент.Использование Тогда
			Для Каждого Поле Из Элемент.ПоляГруппировки.Элементы Цикл
				Если ТипЗнч(Поле) = Тип("ПолеГруппировкиКомпоновкиДанных") Тогда
					Если Поле.Использование Тогда
						СписокПолей.Добавить(Поле.Поле);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			ЗаполнитьСписокПолейГруппировок(Элемент.Структура, СписокПолей);
		ИначеЕсли ТипЗнч(Элемент) = Тип("ТаблицаКомпоновкиДанных") И Элемент.Использование Тогда
			ЗаполнитьСписокПолейГруппировок(Элемент.Строки, СписокПолей);
			ЗаполнитьСписокПолейГруппировок(Элемент.Колонки, СписокПолей);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ВыбранныйОтчет()
	
	ВыбранныеОтчеты = Новый Массив;
	Отбор = КомпоновщикНастроек.ПолучитьНастройки().Отбор;
	Для Каждого Элемент Из Отбор.Элементы Цикл 
		Если Элемент.Использование И Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Отчет") Тогда
			Если Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
				ВыбранныеОтчеты.Добавить(Элемент.ПравоеЗначение);
			Иначе
				Возврат Неопределено;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ВыбранныеОтчеты.Количество() = 1 Тогда
		Возврат ВыбранныеОтчеты[0];
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ОтборПоПользователям()
	
	Результат = Новый Структура;
	Результат.Вставить("БезГрупп", Истина);
	Результат.Вставить("Значение", Неопределено);
	
	ПолеОтбора = КомпоновщикНастроек.ПолучитьНастройки().ПараметрыДанных.Элементы.Найти("Пользователь");
	ЗначениеОтбора = ПолеОтбора.Значение;
	Если Не ПолеОтбора.Использование Или Не ЗначениеЗаполнено(ЗначениеОтбора) Тогда
		Возврат Результат;
	КонецЕсли;
	Результат.Значение = ЗначениеОтбора;
	
	Если ТипЗнч(ЗначениеОтбора) <> Тип("СписокЗначений") Тогда
		ЗначениеОтбора = Новый СписокЗначений;
		ЗначениеОтбора.Добавить(Результат.Значение);
	КонецЕсли;
	
	Для Каждого ЭлементСписка Из ЗначениеОтбора Цикл
		Если ТипЗнч(ЭлементСписка.Значение) = Тип("СправочникСсылка.ГруппыПользователей")
		 Или ТипЗнч(ЭлементСписка.Значение) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") Тогда
			Результат.БезГрупп = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ОтборПоТаблицам()
	
	Отбор = КомпоновщикНастроек.ПолучитьНастройки().Отбор;
	Для Каждого Элемент Из Отбор.Элементы Цикл 
		Если Элемент.Использование И Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбъектМетаданных") Тогда
			Если Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно
			 Или Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
				Возврат Элемент.ПравоеЗначение;
			Иначе
				Возврат Неопределено;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Функция ОтборПоВходВПрограммуРазрешен()
	
	Отбор = КомпоновщикНастроек.ПолучитьНастройки().Отбор;
	
	Для Каждого Элемент Из Отбор.Элементы Цикл 
		Если Элемент.Использование
		   И Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВходВПрограммуРазрешен")
		   И Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно
		   И Элемент.ПравоеЗначение = Истина Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Процедура УстановитьОтборПоПользователям(НовыеНастройкиКД, СписокПользователей)
	
	ИмяПараметра = "Пользователь";
	
	Параметр = НовыеНастройкиКД.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	Если Параметр = Неопределено Тогда
		НовыеНастройкиКД = КомпоновщикНастроек.Настройки;
		Параметр = НовыеНастройкиКД.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	КонецЕсли;
	Параметр.Использование = Истина;
	Параметр.Значение = СписокПользователей;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли