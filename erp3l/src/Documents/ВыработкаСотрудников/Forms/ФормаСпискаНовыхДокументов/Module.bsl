#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СозданныеДокументы = ПрочитатьДанныеИзБезопасногоХранилища();
	
	Если Не ЗначениеЗаполнено(СозданныеДокументы) Тогда
		Отказ = Истина;
		ВызватьИсключение НСтр("ru = 'Произошла исключительная ситуация при создании документов.';
								|en = 'An exception is thrown when generating documents.'");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Ссылка",
		СозданныеДокументы,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);
	
	Если Параметры.Свойство("СписокОшибок") Тогда
		Для Каждого ТекОшибка Из Параметры.СписокОшибок Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекОшибка.ТекстОшибки,
			ТекОшибка.Документ);
		КонецЦикла;
	КонецЕсли;
	
	СклонениеСлова = ОбщегоНазначенияУТКлиентСервер.СклонениеСлова(
		СозданныеДокументы.Количество(),
		НСтр("ru = 'документ';
			|en = 'document'"),
		НСтр("ru = 'документа';
			|en = 'document'"),
		НСтр("ru = 'документов';
			|en = 'documents'"),
		"м");
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Заголовок,
		НСтр("ru = 'Оформление выработки сотрудников';
			|en = 'Register timesheets charge'"),
		СозданныеДокументы.Количество(),
		СклонениеСлова);
	
	ОбъектыМетаданных = Новый Массив;
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ВыработкаСотрудников);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = ОбъектыМетаданных;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ВыполняетсяЗакрытие И ДокументыНеОбработаны() Тогда
		
		Отказ = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтаФорма);
		
		ЗаголовокВопроса = "";
		ТекстВопроса = НСтр("ru = 'В списке присутствуют непроведенные, непомеченные на удаление документы. Продолжить?';
							|en = 'There are unposted documents and documents unmarked for deletion in the list. Continue?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,, ЗаголовокВопроса)
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	УдалитьДокументы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовСтраницыОформлено

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОписаниеОповещение = Новый ОписаниеОповещения("ОбновитьДанныеСписка", ЭтаФорма);
		ПоказатьЗначение(ОписаниеОповещение, Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовИзменить(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(Неопределено, ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовУстановитьПометкуУдаления(Команда)
	
	ВыделенныеСтрокиСписка = Элементы.Список.ВыделенныеСтроки;
	
	Если ВыделенныеСтрокиСписка.Количество() <> 0 Тогда
		
		ВыделенныеСтроки = Новый Массив; // Массив из ДокументСсылка.ВыработкаСотрудников
		
		Для Каждого ТекСтрока Из ВыделенныеСтрокиСписка Цикл
			ВыделенныеСтроки.Добавить(Элементы.Список.ДанныеСтроки(ТекСтрока).Ссылка);
		КонецЦикла;
		
		ЕстьПомеченныеНаУдаление = ЕстьПомеченныеНаУдаление(ВыделенныеСтроки);
		
		Если ВыделенныеСтроки.Количество() = 1 Тогда
			Документ = ВыделенныеСтроки[0];
			ТекстВопроса = ?(ЕстьПомеченныеНаУдаление, НСтр("ru = 'Снять с ""%1"" пометку на удаление?';
															|en = 'Clear mark for deletion for ""%1""?'"),
			НСтр("ru = 'Пометить ""%1"" на удаление?';
				|en = 'Mark ""%1"" for deletion?'"));
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, Документ);
		Иначе
			ТекстВопроса = ?(ЕстьПомеченныеНаУдаление, НСтр("ru = 'Снять с выделенных элементов пометку на удаление?';
															|en = 'Unmark selected items for deletion?'"),
			НСтр("ru = 'Пометить выделенные элементы на удаление?';
				|en = 'Mark the selected items for deletion?'"));
		КонецЕсли;
		
		СписокОтветов = Новый СписокЗначений;
		СписокОтветов.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Да';
															|en = 'Yes'"));
		СписокОтветов.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Нет';
															|en = 'No'"));
		
		ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьПометкуУдаленияЗавершение", 
			ЭтотОбъект, 
			Новый Структура("ВыделенныеСтроки, УстановкаПометкиУдаления", ВыделенныеСтроки, НЕ ЕстьПомеченныеНаУдаление)), 
			ТекстВопроса, 
			СписокОтветов);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовОтменаПроведения(Команда)
	
	ОчиститьСообщения();
	
	ВыделенныеСтроки = Новый Массив; // Массив из ДокументСсылка.ВыработкаСотрудников
		
	Для Каждого ТекСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		ВыделенныеСтроки.Добавить(Элементы.Список.ДанныеСтроки(ТекСтрока).Ссылка);
	КонецЦикла;
	
	РезультатПроведения = ПровестиДокументы(ВыделенныеСтроки, Ложь);
	
	ДокументыДляОбработки = РезультатПроведения.ДокументыДляОбработки;
	НеОбработанныеДокументы = РезультатПроведения.НепроведенныеДокументы;
	
	ОповеститьПользователяОПроведенииДокументов(ДокументыДляОбработки, НеОбработанныеДокументы, Ложь);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПровести(Команда)
	
	ОчиститьСообщения();
	
	ВыделенныеСтроки = Новый Массив; // Массив из ДокументСсылка.ВыработкаСотрудников
	
	Для Каждого ТекСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		ВыделенныеСтроки.Добавить(Элементы.Список.ДанныеСтроки(ТекСтрока).Ссылка);
	КонецЦикла;
	
	РезультатПроведения = ПровестиДокументы(ВыделенныеСтроки, Истина);
	
	ДокументыДляОбработки = РезультатПроведения.ДокументыДляОбработки;
	НеОбработанныеДокументы = РезультатПроведения.НепроведенныеДокументы;
	
	ОповеститьПользователяОПроведенииДокументов(ДокументыДляОбработки, НеОбработанныеДокументы, Истина);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПрочитатьДанныеИзБезопасногоХранилища()
	Владелец = Пользователи.АвторизованныйПользователь();
	УстановитьПривилегированныйРежим(Истина);
	ЗащищенныеДанные = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "ФормаСозданияВыработкиСотрудников");
	УстановитьПривилегированныйРежим(Ложь);
	Возврат ЗащищенныеДанные
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтаФорма, "Список.Дата", "Дата");

КонецПроцедуры

// Проводит документы
// 
// Параметры:
// 	ВыделенныеСтроки - Массив из ДокументСсылка.ВыработкаСотрудников - массив документов
// 	Проведение - Булево - флаг проведения
// Возвращаемое значение:
// 	Структура - Описание:
// * НепроведенныеДокументы - Массив из Структура:
// ** Ссылка - ДокументСсылка.ВыработкаСотрудников
// ** ОписаниеОшибки - Строка
// * ДокументыДляОбработки - Массив
//
&НаСервере
Функция ПровестиДокументы(ВыделенныеСтроки, Проведение = Истина)
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ДокументыДляОбработки");
	СтруктураВозврата.Вставить("НепроведенныеДокументы");
	
	НепроведенныеДокументы = Новый Массив();
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		СтруктураВозврата.ДокументыДляОбработки = Новый Массив();
		СтруктураВозврата.НепроведенныеДокументы = Новый Массив();
		Возврат СтруктураВозврата;
	КонецЕсли;
	
	ДокументыДляОбработки = ОбщегоНазначенияУТВызовСервера.СсылкиДокументовДинамическогоСписка(ВыделенныеСтроки);
	
	Если Проведение Тогда
		НепроведенныеДокументы = ОбщегоНазначения.ПровестиДокументы(ДокументыДляОбработки);
	Иначе
		Для Каждого ТекСтрока Из ВыделенныеСтроки Цикл
			
			НачатьТранзакцию();
			Попытка
				
				Блокировка = Новый БлокировкаДанных;
				
				ЭлементБлокировки = Блокировка.Добавить("Документ.ВыработкаСотрудников");
				ЭлементБлокировки.УстановитьЗначение("Ссылка", ТекСтрока);
				ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
				
				Блокировка.Заблокировать();
				ДокументОбъект = ТекСтрока.ПолучитьОбъект();
				ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
				ЗафиксироватьТранзакцию();
				
			Исключение
				
				ОтменитьТранзакцию();
				КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Оформление выработки сотрудников';
						|en = 'Register timesheets charge'", КодОсновногоЯзыка)
						+ "." + НСтр("ru = 'Проведение документов';
									|en = 'Document posting'", КодОсновногоЯзыка),
					УровеньЖурналаРегистрации.Ошибка,,
					ТекСтрока,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
				ПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
				
				ОписаниеОшибки = Новый Структура;
				ОписаниеОшибки.Вставить("Ссылка", ТекСтрока);
				ОписаниеОшибки.Вставить("ОписаниеОшибки", ПредставлениеОшибки);
				
				НепроведенныеДокументы.Добавить(ОписаниеОшибки);
				
			КонецПопытки;
			
		КонецЦикла;
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
	СтруктураВозврата.Вставить("ДокументыДляОбработки", ДокументыДляОбработки);
	СтруктураВозврата.Вставить("НепроведенныеДокументы", НепроведенныеДокументы);
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаСервере
Процедура УдалитьДокументы()
	
	СозданныеДокументы = ПрочитатьДанныеИзБезопасногоХранилища();
	
	Если Не ЗначениеЗаполнено(СозданныеДокументы) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДД.Ссылка
		|ИЗ
		|	Документ.ВыработкаСотрудников КАК ДД
		|ГДЕ
		|	ДД.Ссылка В(&ВыделенныеСтроки)
		|	И ДД.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ВыделенныеСтроки", СозданныеДокументы);
	Выборка = Запрос.Выполнить().Выбрать();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить("Документ.ВыработкаСотрудников");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ДокументОбъект.Удалить();
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Оформление выработки сотрудников';
					|en = 'Register timesheets charge'", КодОсновногоЯзыка)
					+ "." + НСтр("ru = 'Удаление документов';
								|en = 'Remove documents'", КодОсновногоЯзыка),
				УровеньЖурналаРегистрации.Ошибка,,
				Выборка.Ссылка,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ПредставлениеОшибки, Выборка.Ссылка);
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьПользователяОПроведенииДокументов(ДокументыДляОбработки, ДанныеОНеОбработанныхДокументах, Проведение)
	
	НеОбработанныеДокументы = Новый Массив;
	
	ШаблонСообщения = ?(Проведение, 
		НСтр("ru = 'Документ %1 не проведен: %2';
			|en = 'Document %1 is not posted: %2'"),
		НСтр("ru = 'Документ %1 не удалось сделать непроведенным: %2';
			|en = 'Cannot make document %1 unposted: %2'"));
	
	Для Каждого ИнформацияОДокументе Из ДанныеОНеОбработанныхДокументах Цикл
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
				Строка(ИнформацияОДокументе.Ссылка),
				ИнформацияОДокументе.ОписаниеОшибки),
			ИнформацияОДокументе.Ссылка);
		
		НеОбработанныеДокументы.Добавить(ИнформацияОДокументе.Ссылка);
	КонецЦикла;
	
	Если НеОбработанныеДокументы.Количество() > 0 Тогда
		ТекстДиалога = ?(Проведение, 
				НСтр("ru = 'Не удалось провести один или несколько документов.';
					|en = 'Cannot post one or several documents.'"),
				НСтр("ru = 'Не удалось сделать непроведенным один или несколько документов.';
					|en = 'Cannot make one or several documents unposted.'"));

		ПоказатьПредупреждение(, ТекстДиалога);
	КонецЕсли;

	ОбработанныеДокументы = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ДокументыДляОбработки, НеОбработанныеДокументы);
	
	Если ОбработанныеДокументы.Количество() > 0 Тогда
		
		Если ДокументыДляОбработки.Количество() > 1 Тогда
			Документ = Заголовок;
			ТекстОповещения = НСтр("ru = 'Изменение (%КоличествоДокументов%)';
									|en = 'Change (%КоличествоДокументов%)'");
			ТекстОповещения = СтрЗаменить(ТекстОповещения, "%КоличествоДокументов%", ОбработанныеДокументы.Количество());
			ДействиеПриНажатии = "";
		Иначе
			Документ = ДокументыДляОбработки[0];
			ТекстОповещения = НСтр("ru = 'Изменение';
									|en = 'Update'");
			ДействиеПриНажатии = ПолучитьНавигационнуюСсылку(Документ);
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(ТекстОповещения, ДействиеПриНажатии, Строка(Документ),
			БиблиотекаКартинок.Информация32);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ЕстьПомеченныеНаУдаление(ВыделенныеСтроки)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ДД.Ссылка
		|ИЗ
		|	Документ.ВыработкаСотрудников КАК ДД
		|ГДЕ
		|	ДД.Ссылка В(&ВыделенныеСтроки)
		|	И ДД.ПометкаУдаления";
		
	Запрос.УстановитьПараметр("ВыделенныеСтроки", ВыделенныеСтроки);
	Результат = Запрос.Выполнить();
	
	Возврат Не Результат.Пустой();
	
КонецФункции

&НаКлиенте
Процедура УстановитьПометкуУдаленияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		МассивСсылок = ДополнительныеПараметры.ВыделенныеСтроки;
		ПометитьНаУдаление = ДополнительныеПараметры.УстановкаПометкиУдаления;
		
		УстановитьПометкуУдаленияЗавершениеСервер(ДополнительныеПараметры);
		
		Если МассивСсылок.Количество() > 1 Тогда
			Документ = МассивСсылок[0];
			ТекстОповещения = ?(Не ПометитьНаУдаление, 
				НСтр("ru = 'Пометка удаления снята (%КоличествоДокументов%)';
					|en = 'Deletion mark is cleared (%КоличествоДокументов%)'"),
				НСтр("ru = 'Пометка удаления установлена (%КоличествоДокументов%)';
					|en = 'Deletion mark is set (%КоличествоДокументов%)'"));
			ТекстОповещения = СтрЗаменить(ТекстОповещения, "%КоличествоДокументов%", МассивСсылок.Количество());
			ДействиеПриНажатии = "";
		Иначе
			Документ = МассивСсылок[0];
			ТекстОповещения = ?(Не ПометитьНаУдаление,
				НСтр("ru = 'Пометка удаления снята';
					|en = 'Deletion mark is cleared'"),
				НСтр("ru = 'Пометка удаления установлена';
					|en = 'Deletion mark is set'"));
			ДействиеПриНажатии = ПолучитьНавигационнуюСсылку(Документ);
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(ТекстОповещения, ДействиеПриНажатии, Строка(Документ),
			БиблиотекаКартинок.Информация32);
			
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПометкуУдаленияЗавершениеСервер(ДополнительныеПараметры)
	
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	ПометитьНаУдаление = ДополнительныеПараметры.УстановкаПометкиУдаления;
	
	Для Каждого ТекСтрока Из ВыделенныеСтроки Цикл
		
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить("Документ.ВыработкаСотрудников");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ТекСтрока);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			// Запись только тех объектов, значение пометки которых меняется
			Если ПометитьНаУдаление И НЕ ТекСтрока.ПометкаУдаления
				ИЛИ НЕ ПометитьНаУдаление И ТекСтрока.ПометкаУдаления Тогда
				ДокументОбъект = ТекСтрока.ПолучитьОбъект();
				ДокументОбъект.УстановитьПометкуУдаления(ПометитьНаУдаление)
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Оформление выработки сотрудников';
					|en = 'Register timesheets charge'", КодОсновногоЯзыка)
					+ "." + НСтр("ru = 'Установка пометки на удаление';
								|en = 'Set marks for deletion'", КодОсновногоЯзыка),
				УровеньЖурналаРегистрации.Ошибка,,
				ТекСтрока,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ПредставлениеОшибки, ТекСтрока);
		КонецПопытки;
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДокументыНеОбработаны()
	
	СозданныеДокументы = ПрочитатьДанныеИзБезопасногоХранилища();
	
	Если Не ЗначениеЗаполнено(СозданныеДокументы) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для Каждого ТекДокумент Из СозданныеДокументы Цикл
		
		Если Не ТекДокумент.Проведен И Не ТекДокумент.ПометкаУдаления Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьДанныеСписка() Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти
