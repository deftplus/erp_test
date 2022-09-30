#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру для инициализации бизнес-процесса.
//	Возвращаемое значение:
//		Структура - структура используемая при создании заявки сотрудника.
Функция СтруктураИнициализацииЗаявки() Экспорт
	
	СтруктураИнициализации = БизнесПроцессыЗаявокСотрудников.СтруктураИнициализацииЗаявки();
	СтруктураИнициализации.Вставить("Организация",							Справочники.Организации.ПустаяСсылка());
	СтруктураИнициализации.Вставить("КомментарийСотрудника",				"");
	СтруктураИнициализации.Вставить("ДатаНачалаОтпуска",					Дата(1, 1, 1, 0, 0, 0));
	СтруктураИнициализации.Вставить("ДатаОкончанияОтпуска",					Дата(1, 1, 1, 0, 0, 0));
	СтруктураИнициализации.Вставить("ЗаСвойСчет",	 						Ложь);
	СтруктураИнициализации.Вставить("УчебныйОтпуск",						Ложь);
	СтруктураИнициализации.Вставить("КоличествоДнейКомпенсации",			0);
	СтруктураИнициализации.Вставить("Сотрудник",							Справочники.Сотрудники.ПустаяСсылка());
	СтруктураИнициализации.Вставить("ИдентификаторЭлектронногоДокумента",	"");
	
	Возврат СтруктураИнициализации
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив Из Строка -
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	Результат = Новый Массив;
	Результат.Добавить("Автор");
	Результат.Добавить("Важность");
	Результат.Добавить("Исполнитель");
	Результат.Добавить("ПроверитьВыполнение");
	Результат.Добавить("Проверяющий");
	Результат.Добавить("СрокИсполнения");
	Результат.Добавить("СрокПроверки");
	Возврат Результат;	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.БизнесПроцессыИЗадачи

// Получить структуру с описанием формы выполнения задачи.
// Вызывается при открытии формы выполнения задачи.
//
// Параметры:
//   ЗадачаСсылка                - ЗадачаСсылка.ЗадачаИсполнителя - задача.
//   ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка - точка маршрута.
//
// Возвращаемое значение:
//   Структура   - структуру с описанием формы выполнения задачи.
//                 Ключ "ИмяФормы" содержит имя формы, передаваемое в метод контекста ОткрытьФорму(). 
//                 Ключ "ПараметрыФормы" содержит параметры формы. 
//
Функция ФормаВыполненияЗадачи(ЗадачаСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("ПараметрыФормы", Новый Структура("Ключ", ЗадачаСсылка));
	Результат.Вставить("ИмяФормы", "БизнесПроцесс.ЗаявкаСотрудникаОтпуск.Форма.Действие" + ТочкаМаршрутаБизнесПроцесса.Имя);
	Возврат Результат;	
КонецФункции

// Вызывается при перенаправлении задачи.
//
// Параметры:
//   ЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - перенаправляемая задача.
//   НоваяЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - задача для нового исполнителя.
//
Процедура ПриПеренаправленииЗадачи(ЗадачаСсылка, НоваяЗадачаСсылка) Экспорт
	// АПК:1327-выкл Блокировка бизнес-процесса установлена ранее
	// в вызывающей функции БизнесПроцессыИЗадачиВызовСервера.ПеренаправитьЗадачи.
	БизнесПроцессОбъект = ЗадачаСсылка.БизнесПроцесс.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(БизнесПроцессОбъект.Ссылка);
	БизнесПроцессОбъект.РезультатВыполнения = РезультатВыполненияПриПеренаправлении(ЗадачаСсылка) 
		+ БизнесПроцессОбъект.РезультатВыполнения;
	УстановитьПривилегированныйРежим(Истина);
	БизнесПроцессОбъект.Записать();
	// АПК:1327-вкл	
КонецПроцедуры

// Вызывается при выполнении задачи из формы списка.
//
// Параметры:
//   ЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - задача.
//   БизнесПроцессСсылка - БизнесПроцессСсылка - бизнес-процесс, по которому сформирована задача ЗадачаСсылка.
//   ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка - точка маршрута.
//
Процедура ОбработкаВыполненияПоУмолчанию(ЗадачаСсылка, БизнесПроцессСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт
	БизнесПроцессыЗаявокСотрудников.ОбработкаВыполненияПоУмолчанию(ЗадачаСсылка,
																   БизнесПроцессСсылка,
																   ТочкаМаршрутаБизнесПроцесса);	
КонецПроцедуры	

// Конец СтандартныеПодсистемы.БизнесПроцессыИЗадачи

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Задание
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
	|ПО
	|	ИсполнителиЗадач.РольИсполнителя = Задание.Исполнитель
	|	И ИсполнителиЗадач.ОсновнойОбъектАдресации = Задание.ОсновнойОбъектАдресации
	|	И ИсполнителиЗадач.ДополнительныйОбъектАдресации = Задание.ДополнительныйОбъектАдресации
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсполнителиЗадач КАК ПроверяющиеЗадач
	|ПО
	|	ПроверяющиеЗадач.РольИсполнителя = Задание.Проверяющий
	|	И ПроверяющиеЗадач.ОсновнойОбъектАдресации = Задание.ОсновнойОбъектАдресацииПроверяющий
	|	И ПроверяющиеЗадач.ДополнительныйОбъектАдресации = Задание.ДополнительныйОбъектАдресацииПроверяющий
	|;
	|РазрешитьЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Автор)
	|	ИЛИ ЗначениеРазрешено(Исполнитель КРОМЕ Справочник.РолиИсполнителей)
	|	ИЛИ ЗначениеРазрешено(ИсполнителиЗадач.Исполнитель)
	|	ИЛИ ЗначениеРазрешено(Проверяющий КРОМЕ Справочник.РолиИсполнителей)
	|	ИЛИ ЗначениеРазрешено(ПроверяющиеЗадач.Исполнитель)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Автор)";	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульСозданиеНаОсновании = ОбщегоНазначения.ОбщийМодуль("СозданиеНаОсновании");
		Команда = МодульСозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.БизнесПроцессы.Задание);
		Если Команда <> Неопределено Тогда
			Команда.ФункциональныеОпции = "ИспользоватьБизнесПроцессыИЗадачи";
		КонецЕсли;
		Возврат Команда;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Устанавливает состояние элементов формы задачи.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - где:
//   * Элементы - ВсеЭлементыФормы - где:
//    ** Предмет - РасширениеПоляФормыДляПоляНадписи - 
// 
Процедура УстановитьСостояниеЭлементовФормыЗадачи(Форма) Экспорт
	
	Если Форма.Элементы.Найти("РезультатВыполнения") <> Неопределено 
		И Форма.Элементы.Найти("ИсторияВыполнения") <> Неопределено Тогда
			Форма.Элементы.ИсторияВыполнения.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Форма.ЗаданиеРезультатВыполнения);
	КонецЕсли;
	
	Форма.Элементы.Предмет.Гиперссылка = Форма.Объект.Предмет <> Неопределено И НЕ Форма.Объект.Предмет.Пустая();
	Форма.ПредметСтрокой = ОбщегоНазначения.ПредметСтрокой(Форма.Объект.Предмет);	
	
КонецПроцедуры

Функция РезультатВыполненияПриПеренаправлении(Знач ЗадачаСсылка)
	
	СтрокаФормат = "%1, %2 " + НСтр("ru = 'перенаправил(а) задачу';
									|en = 'redirected the task'") + ":
		|%3
		|";
	
	Комментарий = СокрЛП(ЗадачаСсылка.РезультатВыполнения);
	Комментарий = ?(ПустаяСтрока(Комментарий), "", Комментарий + Символы.ПС);
	Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаФормат, ЗадачаСсылка.ДатаИсполнения, ЗадачаСсылка.Исполнитель, Комментарий);
	Возврат Результат;

КонецФункции

#Область ОбработчикиОбновленияИнформационнойБазы

Процедура ОбновлениеДляИспользованияКЭДО(ПараметрыОбновления = Неопределено) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьБизнесПроцессыЗаявокСотрудников") Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
		Возврат;
	КонецЕсли;
	
	РезультатЗапроса = БизнесПроцессыЗаявокСотрудников.РезультатЗапросаЗаявокОбновлениеДляИспользованияКЭДО("БизнесПроцесс.ЗаявкаСотрудникаОтпуск");
	Если РезультатЗапроса.Пустой() Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
		Возврат;
	КонецЕсли;
	
	ТаблицаЗаявок = РезультатЗапроса.Выгрузить();
	ОрганизацииФизическихЛиц = 
		БизнесПроцессыЗаявокСотрудников.ОрганизацииФизическихЛицОбновлениеДляИспользованияКЭДО(
			ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаЗаявок, "ФизическоеЛицо", Истина));
	
	ОбработкаЗавершена = Истина;
	Для Каждого СтрокаТЗ Из ТаблицаЗаявок Цикл
		
		Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления,
																							 "БизнесПроцесс.ЗаявкаСотрудникаОтпуск",
																							 "Ссылка",
																							 СтрокаТЗ.Ссылка) Тогда
			ОбработкаЗавершена = Ложь;
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаТЗ.Организация) Тогда
			ЗаявкаОбъект = СтрокаТЗ.Ссылка.ПолучитьОбъект();
			ЗаявкаОбъект.Организация = ОрганизацииФизическихЛиц[СтрокаТЗ.ФизическоеЛицо];
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ЗаявкаОбъект);
			СтрокаТЗ.Организация = ЗаявкаОбъект.Организация;
		КонецЕсли;
		БизнесПроцессыЗаявокСотрудников.СоздатьИЗаписатьДокументКЭДООбновление(СтрокаТЗ);
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
		
	КонецЦикла;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", ОбработкаЗавершена);
	
КонецПроцедуры

Процедура ПеренестиПрисоединенныеФайлыВложений(ПараметрыОбновления = Неопределено) Экспорт
	БизнесПроцессыЗаявокСотрудников.ПеренестиПрисоединенныеФайлыВложений("БизнесПроцесс.ЗаявкаСотрудникаОтпуск",
																		 ПараметрыОбновления);	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли