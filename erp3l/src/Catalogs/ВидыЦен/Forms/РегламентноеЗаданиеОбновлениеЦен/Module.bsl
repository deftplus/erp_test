///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа.
		                             |
		                             |Изменение свойств регламентного задания
		                             |выполняется только администраторами.';
		                             |en = 'Insufficient access rights.
		                             |
		                             |Only administrators can change
		                             |scheduled job settings.'");
	КонецЕсли;
	
	Действие = Параметры.Действие;
	
	Если СтрНайти(", Добавить, Скопировать, Изменить,", ", " + Действие + ",") = 0 Тогда
		
		ВызватьИсключение НСтр("ru = 'Неверные параметры открытия формы ""Регламентное задание"".';
								|en = 'Cannot open the ""Scheduled job"" form. Invalid opening parameters.'");
	КонецЕсли;
	
	Если Действие = "Добавить" Тогда
		
		Расписание = Новый РасписаниеРегламентногоЗадания;
		Задание = Метаданные.РегламентныеЗадания.ОбновлениеЦен;
		
		
		ИмяМетаданных       = Задание.Имя;
		СинонимМетаданных   = Задание.Синоним;
		ИмяМетодаМетаданных = Задание.ИмяМетода;
			
	Иначе
		Задание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(Параметры.Идентификатор);
		
		ЗаполнитьЗначенияСвойств(
			ЭтотОбъект,
			Задание,
			"Ключ,
			|Предопределенное,
			|Использование,
			|Наименование,
			|ИмяПользователя,
			|ИнтервалПовтораПриАварийномЗавершении,
			|КоличествоПовторовПриАварийномЗавершении");
		
		Идентификатор = Строка(Задание.УникальныйИдентификатор);
		Если Задание.Метаданные = Неопределено Тогда
			ИмяМетаданных        = НСтр("ru = '<нет метаданных>';
										|en = '<no metadata>'");
			СинонимМетаданных    = НСтр("ru = '<нет метаданных>';
										|en = '<no metadata>'");
			ИмяМетодаМетаданных  = НСтр("ru = '<нет метаданных>';
										|en = '<no metadata>'");
		Иначе
			ИмяМетаданных        = Задание.Метаданные.Имя;
			СинонимМетаданных    = Задание.Метаданные.Синоним;
			ИмяМетодаМетаданных  = Задание.Метаданные.ИмяМетода;
		КонецЕсли;
		Расписание = Задание.Расписание;
		
		Если Задание.Параметры.Количество() Тогда
			ЗаполнитьРеквизитыПоПараметрам(Задание.Параметры);
		КонецЕсли;
		
		СообщенияПользователюИОписаниеИнформацииОбОшибке = РегламентныеЗаданияСлужебный.СообщенияИОписанияОшибокРегламентногоЗадания(Задание);
	КонецЕсли;
	
	Если Действие <> "Изменить" Тогда
		Идентификатор = НСтр("ru = '<будет создан при записи>';
							|en = '<will be generated automatically>'");
		Использование = Ложь;
		
	КонецЕсли;
	
	Если Действие = "Добавить" Тогда
		Наименование = АвтоНаименование(ЭтотОбъект);
	Иначе
		АвтоНаименование(ЭтотОбъект);
	КонецЕсли;
	
	ОбновитьРеквизитыАвтонаименования();	
	
	// Заполнение списка выбора имени пользователя.
	МассивПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей();
	
	Для каждого Пользователь Из МассивПользователей Цикл
		Элементы.ИмяПользователя.СписокВыбора.Добавить(Пользователь.Имя);
	КонецЦикла;
	
	ВариантОбновленияЦенПриИзмененииНаСервере(ЭтотОбъект);
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Действие = "Добавить" Тогда
		
		ОбновитьЗаголовокФормы();
		УстановитьВидимостьЭлементовФормы();
		
	Иначе
		ОбновитьЗаголовокФормы();
		УстановитьВидимостьЭлементовФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
	ОбновитьАвтонаименование(Модифицированность);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ИндексАвтонаименования = 0;
	НаименованиеИзмененоПользователем = Истина;
	ИспользуетсяАвтоНаименование = Ложь;
	Для Каждого ЭлементСписка Из Элементы.Наименование.СписокВыбора Цикл
		
		Если ЭлементСписка.Значение = Наименование Тогда
			ИспользуетсяАвтоНаименование = Истина;
			НаименованиеИзмененоПользователем = Ложь;
			ИндексАвтонаименования = Элементы.Наименование.СписокВыбора.Индекс(ЭлементСписка);
		КонецЕсли;
		
	КонецЦикла;
		
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОбновленияЦенПриИзменении(Элемент)
	
	ВариантОбновленияЦенПриИзмененииНаСервере(ЭтаФорма);	
	
	ОбновитьАвтонаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыЦенПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОбновитьАвтонаименование();
	
КонецПроцедуры

//&НаКлиенте
//Процедура ВидОбновленияЦенПриИзменении(Элемент)
//	
//	ОбновитьАвтонаименование();
//	
//КонецПроцедуры

&НаКлиенте
Процедура ВидыЦенПослеУдаления(Элемент)
	
	ОбновитьАвтонаименование();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьРегламентноеЗадание();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ЗаписатьИЗакрытьЗавершение();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеВыполнить()

	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	Диалог.Показать(Новый ОписаниеОповещения("ОткрытьРасписаниеЗавершение", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписатьИЗакрытьЗавершение(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ЗаписатьРегламентноеЗадание();
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры



&НаКлиенте
Процедура ОткрытьРасписаниеЗавершение(НовоеРасписание, Контекст) Экспорт

	Если НовоеРасписание <> Неопределено Тогда
		Расписание = НовоеРасписание;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьРегламентноеЗадание()
	
	Если НЕ ЗначениеЗаполнено(ИмяМетаданных) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийИдентификатор = ?(Действие = "Изменить", Идентификатор, Неопределено);
	
	ЗаписатьРегламентноеЗаданиеНаСервере();
	ОбновитьЗаголовокФормы();
	
	Оповестить("Запись_РегламентныеЗадания", ТекущийИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьРегламентноеЗаданиеНаСервере()
	
	Если Действие = "Изменить" Тогда
		Задание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(Идентификатор);
	Иначе
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания[ИмяМетаданных]);
		
		Задание = РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
		
		Идентификатор = Строка(Задание.УникальныйИдентификатор);
		Действие = "Изменить";
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(
		Задание,
		ЭтотОбъект,
		"Ключ, 
		|Наименование,
		|Использование,
		|ИмяПользователя,
		|ИнтервалПовтораПриАварийномЗавершении,
		|КоличествоПовторовПриАварийномЗавершении");
	
	Задание.Расписание = Расписание;
	
	Задание.Параметры.Очистить();
	ТаблицаВидовЦен = Новый ТаблицаЗначений();
	ТаблицаВидовЦен.Колонки.Добавить("ВидЦены", Новый ОписаниеТипов("СправочникСсылка.ВидыЦен"));
	ТаблицаВидовЦен.Колонки.Добавить("ОбнулятьЦены",Новый ОписаниеТипов("Булево"));
	Для Каждого Элемент Из ВидыЦен Цикл
		СтрокаТаблицы = ТаблицаВидовЦен.Добавить();
		СтрокаТаблицы.ВидЦены 		= Элемент.Значение;
		СтрокаТаблицы.ОбнулятьЦены 	= Ложь;
	КонецЦикла;
	
	ПараметрыОбновления = Новый Структура("ВариантОбновленияЦен", ВариантОбновленияЦен);
	
	Задание.Параметры.Добавить(ТаблицаВидовЦен);	
	Задание.Параметры.Добавить(ПараметрыОбновления);
	
	Задание.Записать();
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовокФормы()
	
	Если НЕ ПустаяСтрока(Наименование) Тогда
		Представление = Наименование;
		
	ИначеЕсли НЕ ПустаяСтрока(СинонимМетаданных) Тогда
		Представление = СинонимМетаданных;
	Иначе
		Представление = ИмяМетаданных;
	КонецЕсли;
	
	Если Действие = "Изменить" Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (Регламентное задание)';
																				|en = '%1 (Scheduled job)'"), Представление);
	Иначе
		Заголовок = НСтр("ru = 'Регламентное задание (создание)';
						|en = 'Scheduled job (Create)'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьЭлементовФормы()
	
	Элементы.ГруппаНастройкиВидовЦен.Видимость = Истина; 
	
КонецПроцедуры


&НаКлиентеНаСервереБезКонтекста
Процедура ВариантОбновленияЦенПриИзмененииНаСервере(Форма)
	
	Форма.Элементы.ВидыЦенДляАвтоматическогоОбновления.Доступность = (Форма.ВариантОбновленияЦен<>0);

	Если Форма.ВариантОбновленияЦен=0 и Форма.ВидыЦен.Количество() Тогда
		Форма.ВидыЦен.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПоПараметрам(Параметры)
	
	ВидыЦен.Очистить();
	Если (Параметры.количество()>0) Тогда
		Для Каждого Строка Из Параметры[0] Цикл
			ВидыЦен.Добавить(Строка.ВидЦены);
		КонецЦикла;
		
		ВариантОбновленияЦен = Параметры[1].ВариантОбновленияЦен;
	КонецЕсли;
	
КонецПроцедуры

#Область Прочее
&НаКлиентеНаСервереБезКонтекста
Функция АвтоНаименование(Форма)
	
	Форма.Элементы.Наименование.СписокВыбора.Очистить();
	
	СтрокаНаименования = "";
	
	СтрокаНаименования = НСтр("ru = 'Обновление цен (';
								|en = 'Update prices ('");
	
	Если Форма.ВариантОбновленияЦен = 0 Тогда
		СтрокаНаименования = СтрокаНаименования + НСтр("ru = 'Все)';
														|en = 'All)'");
	ИначеЕсли Форма.ВариантОбновленияЦен = 1 Тогда
		СтрокаНаименования = СтрокаНаименования + НСтр("ru = 'Только выбранные)';
														|en = 'Selected roles only)'");
	ИначеЕсли Форма.ВариантОбновленияЦен = 2 Тогда
		СтрокаНаименования = СтрокаНаименования + НСтр("ru = 'Выбранные и зависимые)';
														|en = 'Selected and dependent)'");
	ИначеЕсли Форма.ВариантОбновленияЦен = 3 Тогда
		СтрокаНаименования = СтрокаНаименования + НСтр("ru = 'Все кроме выбранных)';
														|en = 'All except selected)'");
	КонецЕсли;
	
	ЭтоПервыйЭлементСписка = Истина;
	Для Каждого ВидЦены Из Форма.ВидыЦен Цикл
		СтрокаНаименования = СтрокаНаименования + ?(ЭтоПервыйЭлементСписка," ",", ") + ВидЦены;
		ЭтоПервыйЭлементСписка = Ложь;
	КонецЦикла;
	
	Форма.Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
	
	Если Форма.ИндексАвтонаименования <= Форма.Элементы.Наименование.СписокВыбора.Количество() - 1 Тогда
		Возврат Форма.Элементы.Наименование.СписокВыбора.Получить(Форма.ИндексАвтонаименования).Значение;
	Иначе
		Возврат СтрокаНаименования;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьАвтонаименование(Обновить = Истина)
	
	НаименованиеСтр = АвтоНаименование(ЭтаФорма);
	Если Не ЗначениеЗаполнено(Наименование)
		ИЛИ (Обновить И ИспользуетсяАвтоНаименование И Не НаименованиеИзмененоПользователем) Тогда
		Наименование = НаименованиеСтр;
		ИспользуетсяАвтоНаименование = Истина;
		ОбновитьЗаголовокФормы();
	КонецЕсли;
	
КонецПроцедуры

// Обновить реквизиты автонаименования
//
&НаСервере
Процедура ОбновитьРеквизитыАвтонаименования()
	
	ИндексАвтонаименования = 0;
	НаименованиеИзмененоПользователем = Истина;
	ИспользуетсяАвтоНаименование = Ложь;
	Для Каждого ЭлементСписка Из Элементы.Наименование.СписокВыбора Цикл
		
		Если ЭлементСписка.Значение = ЭтаФорма.Наименование Тогда
			ИспользуетсяАвтоНаименование = Истина;
			НаименованиеИзмененоПользователем = Ложь;
			ИндексАвтонаименования = Элементы.Наименование.СписокВыбора.Индекс(ЭлементСписка);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
#КонецОбласти

#КонецОбласти
