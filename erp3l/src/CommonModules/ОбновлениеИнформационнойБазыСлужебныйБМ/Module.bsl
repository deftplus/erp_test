////////////////////////////////////////////////////////////////////////////////
// Модуль содержит служебные методы обновления общие для
// информационной базы УХ и БП МСФО.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс


// Добавляет новый обработчик заполнения и устанавливает его параметры.
//
// Параметры:
//	Обработчики - таблица обработчиков для добавления нового обработчика.
//		Переменная берется из одноименного аргумента функции
//		ПриДобавленииОбработчиковОбновления(Обработчики).
//	Версия - Строка - номер версии конфигурации, при обновлении на которую
//		должна быть вызвана процедура обновления, указанная в параметре
//		ИмяПроцедуры. В качестве версии можно указывать:
//			- Номер версии конфигурации в формате Р.П.В.С
//			  (Р – старший номер редакции; П – младший номер редакции;
//			   В – номер версии; С – номер сборки);
//			- если в качестве версии указан символ «*», то обработчик
//			  обновления должен выполняться каждый раз при обновлении
//			  информационной базы, независимо от номера версии конфигурации;
//			- если свойство Версия не задано, то должно быть установлено
//			  в Истина свойство НачальноеЗаполнение.
//	ИмяПроцедуры - Строка - полное имя экспортной процедуры, которая
//		будет вызвана для выполнения обновления.
//	НачальноеЗаполнение - Булево – если Истина, то процедура обновления
//		будет вызвана при первом запуске на пустой информационной базе
//		(версия «0.0.0.0»), созданной из файла поставки конфигурации
//		и не содержащей данных. Это обработчики первоначального
//		заполнения базы.
//	РежимВыполнения - Строка ("Монопольно", "Оперативно", "Отложенно").
//	ТолькоБМ - Булево - если Истина, то обработчик будет зарегистрирован
//		только для конфигурации БП МСФО. В противном случае, обработчик
//		будет зарегистрирован вне зависимости от типа конфигурации.
//	ДополнительныеПараметры - Структура|Неопределено - если передать
//		структуру, то поля обработчика будут заполнены в соотвествии
//		со значениями одноименных полей этой структуры.
//
// Возвращает:
//	Таблицу обработчиков с добавленным обработчиком.
//
Функция ДобавитьОбработчикОбновления(
				Обработчики,
				Версия,
				ИмяПроцедуры,
				НачальноеЗаполнение = Ложь,
				РежимВыполнения = "Монопольно",
				ТолькоБМ = Истина,
				ДополнительныеПараметры = Неопределено) Экспорт
										
	флЗарегистрироватьОбработчик = НЕ (ТолькоБМ И ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом());
	флПереходСБП = (Обработчики.Колонки.Найти("ПредыдущееИмяКонфигурации") <> Неопределено);
	Если флПереходСБП Тогда
		флЗарегистрироватьОбработчик = флЗарегистрироватьОбработчик И НачальноеЗаполнение;
	КонецЕсли;
	Если флЗарегистрироватьОбработчик Тогда
		Обработчик = Обработчики.Добавить();
		
		Если флПереходСБП Тогда
			Обработчик.Процедура					= ИмяПроцедуры;
			Обработчик.ПредыдущееИмяКонфигурации	= "БухгалтерияПредприятияКОРП";
		Иначе
			Если ДополнительныеПараметры <> Неопределено Тогда
				ЗаполнитьЗначенияСвойств(Обработчик, ДополнительныеПараметры);
			КонецЕсли;
			
			Обработчик.Версия				= Версия;
			Обработчик.Процедура			= ИмяПроцедуры;
			Обработчик.НачальноеЗаполнение	= НачальноеЗаполнение;
			Обработчик.РежимВыполнения		= РежимВыполнения;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Обработчики;
КонецФункции

#КонецОбласти

#Область ПроцедурыФункцииДляИспользованияВОбработчикахОбновления

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для использования в обработчиках обновления.

// Записывает изменения в переданном объекте.
// Для использования в обработчиках обновления.
//
// Параметры:
//   Данные                            - Произвольный - объект, набор записей или менеджер константы, который
//                                                      необходимо записать.
//   РегистрироватьНаУзлахПлановОбмена - Булево       - включает регистрацию на узлах планов обмена при записи объекта.
//   ВключитьБизнесЛогику              - Булево       - включает бизнес-логику при записи объекта.
//
Процедура ЗаписатьДанные(Знач Данные, Знач РегистрироватьНаУзлахПлановОбмена = Ложь, 
	Знач ВключитьБизнесЛогику = Ложь) Экспорт
	
	Данные.ОбменДанными.Загрузка = Не ВключитьБизнесЛогику;
	Если Не РегистрироватьНаУзлахПлановОбмена Тогда
		Данные.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
		Данные.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
	КонецЕсли;
	
	Данные.Записать();
	
КонецПроцедуры

// Записывает изменения в переданном объекте ссылочного типа.
// Для использования в обработчиках обновления.
//
// Параметры:
//   Объект                            - Произвольный - записываемый объект ссылочного типа. Например, СправочникОбъект.
//   РегистрироватьНаУзлахПлановОбмена - Булево       - включает регистрацию на узлах планов обмена при записи объекта.
//   ВключитьБизнесЛогику              - Булево       - включает бизнес-логику при записи объекта.
//
Процедура ЗаписатьОбъект(Знач Объект, Знач РегистрироватьНаУзлахПлановОбмена = Неопределено, 
	Знач ВключитьБизнесЛогику = Ложь) Экспорт
	
	Если РегистрироватьНаУзлахПлановОбмена = Неопределено И Объект.ЭтоНовый() Тогда
		РегистрироватьНаУзлахПлановОбмена = Истина;
	Иначе
		РегистрироватьНаУзлахПлановОбмена = Ложь;
	КонецЕсли;
	
	Объект.ОбменДанными.Загрузка = Не ВключитьБизнесЛогику;
	Если Не РегистрироватьНаУзлахПлановОбмена Тогда
		Объект.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
		Объект.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
	КонецЕсли;
	
	Объект.Записать();
	
КонецПроцедуры

Процедура ПровестиДокумент(Данные, ТекстНачалаОшибки = "", ЗаписатьЕслиНеУдалосьПровести = Истина, ОтказЕслиНеПроведен = Ложь, ОтказЕслиНеЗаписан = Ложь) Экспорт

	Попытка				
		Данные.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		ОбщегоНазначенияУХ.СообщитьОбОшибке(СтрШаблон(ТекстНачалаОшибки + "Не удалось провести документ <%1>: " + ОписаниеОшибки(), Данные), ОтказЕслиНеПроведен);
	КонецПопытки;
	
	Если Не ОтказЕслиНеПроведен Тогда
		Возврат;
	ИначеЕсли Не ЗаписатьЕслиНеУдалосьПровести Тогда
		
	КонецЕсли;	
		
	Попытка
		Данные.Проведен = Ложь;
		Данные.Записать(РежимЗаписиДокумента.Запись);
	Исключение
		ОбщегоНазначенияУХ.СообщитьОбОшибке(СтрШаблон(ТекстНачалаОшибки + "Не удалось записать документ <%1>: " + ОписаниеОшибки(), Данные), ОтказЕслиНеЗаписан);
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти