#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Формирует таблицу с составом семьи.
// Члены семьи упорядочиваются по коду степени родства и возрасту и отделяются переносом строки.
//
// Параметры:
//  ФизическоеЛицо	 - СправочникСсылка.ФизическиеЛица - человек, состав семьи которого формируется.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - таблица с колонками
//		Ссылка - СправочникСсылка.РодственникиФизическихЛиц - ссылка на члена семьи,
//		Наименование - Строка - наименование элемента справочника родственников,
//		СтепеньРодства - СправочникСсылка.СтепениРодстваФизическихЛиц - степени родства физических лиц,
//		ДатаРождения - Дата - дата рождения родственника,
//		НаИждивении - Булево - признак того, что родственник находится на иждивении,
//		СкрыватьВТ2 - Булево - признак того, что родственник скрывается из формы Т-2.
//
Функция СоставСемьи(ФизическоеЛицо) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РодственникиФизическихЛиц.Ссылка КАК Ссылка,
		|	РодственникиФизическихЛиц.Наименование КАК Наименование,
		|	РодственникиФизическихЛиц.СтепеньРодства КАК СтепеньРодства,
		|	РодственникиФизическихЛиц.ДатаРождения КАК ДатаРождения,
		|	РодственникиФизическихЛиц.НаИждивении КАК НаИждивении,
		|	РодственникиФизическихЛиц.СкрыватьВТ2 КАК СкрыватьВТ2,
		|	РодственникиФизическихЛиц.НаходитсяПодОпекой КАК НаходитсяПодОпекой,
		|	РодственникиФизическихЛиц.СтепеньРодства.Код КАК СтепеньРодстваКод
		|ИЗ
		|	Справочник.РодственникиФизическихЛиц КАК РодственникиФизическихЛиц
		|ГДЕ
		|	РодственникиФизическихЛиц.Владелец = &ФизическоеЛицо
		|	И НЕ РодственникиФизическихЛиц.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	СтепеньРодстваКод";
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Формирует строку с представлением состава семьи.
//
// Параметры:
//  ФизическоеЛицо	 - СправочникСсылка.ФизическиеЛица - человек, состав семьи которого формируется.
//  ВключатьСкрытыхИзТ2	 - Булево - необязательный, по умолчанию Ложь.
//		Если установлено, то состав семьи будет сформирован с учетом лиц, скрываемых из формы Т-2.
// 
// Возвращаемое значение:
//  Строка - представление состава семьи.
//
// Пример:
//	Муж: Виктор, 51 год
//	Сын: Орлов Александр, 29 лет
//	Дочь: Орлова Мария, 26 лет
//
Функция ПредставлениеСоставаСемьи(ФизическоеЛицо, ВключатьСкрытыхИзТ2 = Ложь) Экспорт
	
	Представление = "";
	
	СоставСемьи = СоставСемьи(ФизическоеЛицо);
	Для Каждого ЧленСемьи Из СоставСемьи Цикл
		Если Не ВключатьСкрытыхИзТ2 И ЧленСемьи.СкрыватьВТ2 Тогда
			Продолжить;
		КонецЕсли;
		Если Не ПустаяСтрока(Представление) Тогда
			Представление = Представление + Символы.ПС;
		КонецЕсли;
		Если ЗначениеЗаполнено(ЧленСемьи.СтепеньРодства) Тогда
			Представление = Представление + Строка(ЧленСемьи.СтепеньРодства) + ": ";
		КонецЕсли;
		Представление = Представление + СокрЛП(Строка(ЧленСемьи.Наименование));
		Если ЗначениеЗаполнено(ЧленСемьи.ДатаРождения) Тогда
			Представление = Представление + ", " + ФизическиеЛицаЗарплатаКадры.ПредставлениеВозраста(ЧленСемьи.ДатаРождения);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Представление;
	
КонецФункции

#Область ОбновлениеИнформационнойБазы

// Заполняет реквизиты Фамилия, Имя, Отчество.
//
// Параметры:
//   ПараметрыОбновления - Структура - Параметры отложенного обновления.
//
Процедура ЗаполнитьФИО(ПараметрыОбновления = Неопределено) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РодственникиФизическихЛиц.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.РодственникиФизическихЛиц КАК РодственникиФизическихЛиц
	|ГДЕ
	|	РодственникиФизическихЛиц.Наименование <> """"
	|	И РодственникиФизическихЛиц.Фамилия = """"";
	ОбработкаЗавершена = Истина;
	
	ОбъектМетаданных = Метаданные.Справочники.РодственникиФизическихЛиц;
	Блокировка = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ОписаниеБлокируемыхДанных(ОбъектМетаданных);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Блокировка.ПоляБлокировки.Ссылка = Выборка.Ссылка;
		Успех = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.НачатьОбновлениеДанных(Блокировка, ПараметрыОбновления);
		Если Не Успех Тогда
			ОбработкаЗавершена = Ложь;
			Продолжить;
		КонецЕсли;
		
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		ФИО = СокрЛП(Объект.Наименование);
		Пока СтрНайти(ФИО, "  ") > 0 Цикл
			ФИО = СтрЗаменить(ФИО, "  ", " ");
		КонецЦикла;
		СтруктураФИО = ФизическиеЛицаКлиентСервер.ЧастиИмени(ФИО);
		Объект.Фамилия  = СтруктураФИО.Фамилия;
		Объект.Имя      = СтруктураФИО.Имя;
		Объект.Отчество = СтруктураФИО.Отчество;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект);
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
	КонецЦикла;
	
	Если ПараметрыОбновления <> Неопределено Тогда
		ПараметрыОбновления.ОбработкаЗавершена = ОбработкаЗавершена;
	КонецЕсли;
КонецПроцедуры

// Заполняет реквизиты СНИЛС, КодСвязи.
//
// Параметры:
//   ПараметрыОбновления - Структура - Параметры отложенного обновления.
//
Процедура ЗаполнитьСНИЛСКодСвязи(ПараметрыОбновления = Неопределено) Экспорт
	ПричиныНетрудоспособности = Новый Массив;
	ПричиныНетрудоспособности.Добавить(Перечисления.ПричиныНетрудоспособности.ПоУходуЗаРебенком);
	ПричиныНетрудоспособности.Добавить(Перечисления.ПричиныНетрудоспособности.ПоУходуЗаВзрослым);
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПричиныНетрудоспособности", ПричиныНетрудоспособности);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Родственники.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТРодственники
	|ИЗ
	|	Справочник.РодственникиФизическихЛиц КАК Родственники
	|ГДЕ
	|	(Родственники.СНИЛС = """"
	|			ИЛИ Родственники.КодСвязи = """")
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	БольничныйЛист.Ссылка КАК Ссылка,
	|	БольничныйЛист.РодственникЗаКоторымОсуществляетсяУход1 КАК РодственникЗаКоторымОсуществляетсяУход1,
	|	БольничныйЛист.РодственникЗаКоторымОсуществляетсяУход2 КАК РодственникЗаКоторымОсуществляетсяУход2,
	|	СведенияОбЭЛН.НомерЛисткаНетрудоспособности КАК НомерЛисткаНетрудоспособности,
	|	СведенияОбЭЛН.ГоловнаяОрганизация КАК ГоловнаяОрганизация
	|ПОМЕСТИТЬ ВТБольничные
	|ИЗ
	|	РегистрСведений.СведенияОбЭЛН КАК СведенияОбЭЛН
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.БольничныйЛист КАК БольничныйЛист
	|		ПО СведенияОбЭЛН.Больничный = БольничныйЛист.Ссылка
	|ГДЕ
	|	СведенияОбЭЛН.ДоступенИсходныйXML
	|	И СведенияОбЭЛН.ПричинаНетрудоспособности В(&ПричиныНетрудоспособности)
	|	И (БольничныйЛист.РодственникЗаКоторымОсуществляетсяУход1 <> ЗНАЧЕНИЕ(Справочник.РодственникиФизическихЛиц.ПустаяСсылка)
	|			ИЛИ БольничныйЛист.РодственникЗаКоторымОсуществляетсяУход2 <> ЗНАЧЕНИЕ(Справочник.РодственникиФизическихЛиц.ПустаяСсылка))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТБольничные.Ссылка КАК Больничный,
	|	ВТБольничные.НомерЛисткаНетрудоспособности КАК НомерЛисткаНетрудоспособности,
	|	ВТБольничные.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ВТРодственники.Ссылка КАК Родственник
	|ПОМЕСТИТЬ ВТРодственникиБольничных
	|ИЗ
	|	ВТРодственники КАК ВТРодственники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТБольничные КАК ВТБольничные
	|		ПО ВТРодственники.Ссылка = ВТБольничные.РодственникЗаКоторымОсуществляетсяУход1
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТБольничные.Ссылка,
	|	ВТБольничные.НомерЛисткаНетрудоспособности,
	|	ВТБольничные.ГоловнаяОрганизация,
	|	ВТРодственники.Ссылка
	|ИЗ
	|	ВТРодственники КАК ВТРодственники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТБольничные КАК ВТБольничные
	|		ПО ВТРодственники.Ссылка = ВТБольничные.РодственникЗаКоторымОсуществляетсяУход2
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТРодственникиБольничных.Родственник КАК Родственник,
	|	ВТРодственникиБольничных.Больничный КАК Больничный,
	|	ВТРодственникиБольничных.НомерЛисткаНетрудоспособности КАК НомерЛисткаНетрудоспособности,
	|	ВТРодственникиБольничных.ГоловнаяОрганизация КАК ГоловнаяОрганизация
	|ИЗ
	|	ВТРодственникиБольничных КАК ВТРодственникиБольничных
	|
	|УПОРЯДОЧИТЬ ПО
	|	Родственник,
	|	НомерЛисткаНетрудоспособности,
	|	ГоловнаяОрганизация,
	|	Больничный";
	ОбработкаЗавершена = Истина;
	
	ОбъектМетаданных = Метаданные.Справочники.РодственникиФизическихЛиц;
	Блокировка = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ОписаниеБлокируемыхДанных(ОбъектМетаданных);
	
	НакопленныеОшибки = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Родственник") Цикл
		Блокировка.ПоляБлокировки.Ссылка = Выборка.Родственник;
		Успех = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.НачатьОбновлениеДанных(Блокировка, ПараметрыОбновления);
		Если Не Успех Тогда
			ОбработкаЗавершена = Ложь;
			Продолжить;
		КонецЕсли;
		
		СНИЛС    = "";
		КодСвязи = "";
		СНИЛСУникален    = Истина;
		КодСвязиУникален = Истина;
		
		Пока Выборка.Следующий() Цикл
			Попытка
				ТекстXML = РегистрыСведений.СведенияОбЭЛН.ИсходныйXML(
					Выборка.НомерЛисткаНетрудоспособности,
					Выборка.ГоловнаяОрганизация);
				СтруктураDOM = СериализацияБЗК.СтруктураDOM(ТекстXML);
				ДанныеЭЛН = ОбменЛисткамиНетрудоспособностиФСС.ДанныеЭЛН(СтруктураDOM);
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				Подробно = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
				Текст = НСтр("ru = 'При заполнении СНИЛС и кода связи родственника ""%1"" из ЭЛН ""%2"" возникла ошибка:%3';
							|en = 'An error occurred when filling in IIAN and relative relationship code ""%1"" from ESLR ""%2"":%3'");
				Текст = СтрШаблон(Текст, Выборка.Родственник, Выборка.НомерЛисткаНетрудоспособности, Символы.ПС + Подробно);
				НакопленныеОшибки.Добавить(Текст);
				Продолжить;
			КонецПопытки;
			ОбменЛисткамиНетрудоспособностиФСС.ЗаполнитьДатыУходаЗаРодственниками(Выборка.Больничный, ДанныеЭЛН);
			Найденные = ДанныеЭЛН.Родственники.НайтиСтроки(Новый Структура("Ссылка", Выборка.Родственник));
			Для Каждого СтрокаТаблицы Из Найденные Цикл
				Если ЗначениеЗаполнено(СтрокаТаблицы.СНИЛС) Тогда
					Если СНИЛС = "" Тогда
						СНИЛС = СтрокаТаблицы.СНИЛС;
					ИначеЕсли СНИЛС <> СтрокаТаблицы.СНИЛС Тогда
						СНИЛСУникален = Ложь;
					КонецЕсли;
				КонецЕсли;
				Если ЗначениеЗаполнено(СтрокаТаблицы.КодСвязи) Тогда
					Если КодСвязи = "" Тогда
						КодСвязи = СтрокаТаблицы.КодСвязи;
					ИначеЕсли КодСвязи <> СтрокаТаблицы.КодСвязи Тогда
						КодСвязиУникален = Ложь;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Попытка
			РодственникОбъект = Выборка.Родственник.ПолучитьОбъект();
			РодственникОбъект.Прочитать();
			Модифицированность = Ложь;
			Если СНИЛСУникален И ЗначениеЗаполнено(СНИЛС) И РодственникОбъект.СНИЛС <> СНИЛС Тогда
				РодственникОбъект.СНИЛС = СНИЛС;
				Модифицированность = Истина;
			КонецЕсли;
			Если КодСвязиУникален И ЗначениеЗаполнено(КодСвязи) И РодственникОбъект.КодСвязи <> КодСвязи Тогда
				РодственникОбъект.КодСвязи = КодСвязи;
				Модифицированность = Истина;
			КонецЕсли;
			Если Модифицированность Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(РодственникОбъект);
			КонецЕсли;
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			Подробно = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
			Текст = НСтр("ru = 'При записи СНИЛС и кода связи родственника ""%1"" из ЭЛН ""%2"" возникла ошибка:%3';
						|en = 'An error occurred when recording IIAN and relative relationship code ""%1"" from ESLR ""%2"":%3'");
			Текст = СтрШаблон(Текст, Выборка.Родственник, Выборка.НомерЛисткаНетрудоспособности, Символы.ПС + Подробно);
			НакопленныеОшибки.Добавить(Текст);
		КонецПопытки;
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
	КонецЦикла;
	
	Если НакопленныеОшибки.Количество() > 0 Тогда
		Подробно = Символы.ПС + Символы.ПС + СтрСоединить(НакопленныеОшибки, Символы.ПС + Символы.ПС);
		ТекстОшибки = НСтр("ru = 'Возникли ошибки (%1):%2';
							|en = 'Errors occurred (%1):%2'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, НакопленныеОшибки.Количество(), Подробно);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если ПараметрыОбновления <> Неопределено Тогда
		ПараметрыОбновления.ОбработкаЗавершена = ОбработкаЗавершена;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
