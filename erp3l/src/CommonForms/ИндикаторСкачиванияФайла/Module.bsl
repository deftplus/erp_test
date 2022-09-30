&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ПоясняющийТекст) Тогда 
		ПоясняющийТекст = Параметры.ПоясняющийТекст;
	Иначе
		ПоясняющийТекст = НСтр("ru = 'Загрузка файла...';
								|en = 'Загрузка файла...'");
	КонецЕсли;
	
	Параметры.Свойство("ИдентификаторВладельца", ИдентификаторВладельца);
	ПараметрыЗадания = Параметры.Параметры;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("Подключаемый_НачатьЗагрузкуФайлаСКлиента", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Закрыть_ДлительнаяОперация" И Источник = ИдентификаторВладельца И Открыта() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура Отмена(Команда)
	
	ОтменитьЗадание(ИдентификаторЗадания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_НачатьЗагрузкуФайлаСКлиента()
	
	НачатьЗагрузкуФайла();
	ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()

	Если Не ЗаданиеВыполнено Тогда
		Результат = ЗаданиеВыполненоНаСервере(ИдентификаторЗадания);
		ЗаданиеВыполнено = Результат.ЗаданиеВыполнено;
	КонецЕсли;
	
	Если ЗаданиеВыполнено Тогда
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено", Истина);
		РезультатВыполнения.Вставить("ИдентификаторЗадания", ИдентификаторЗадания);
		РезультатВыполнения.Вставить("АдресХранилища", АдресХранилища);
		РезультатВыполнения.Вставить("АдресХранилищаДополнительный", АдресХранилищаДополнительный);
		
		Закрыть(РезультатВыполнения);
	Иначе
		Элементы.Индикатор.МаксимальноеЗначение = Результат.ВсегоКЗагрузке;
		Индикатор = Результат.Загружено;
		
		Загружено = ОбщегоНазначенияЭДКОКлиентСервер.ТекстовоеПредставлениеРазмераФайла(Результат.Загружено, 1);
		ОсталосьЗагрузить = ОбщегоНазначенияЭДКОКлиентСервер.ТекстовоеПредставлениеРазмераФайла(Результат.ВсегоКЗагрузке, 1);
		Элементы.Индикатор.Подсказка = СтрШаблон(НСтр("ru = 'Загружено %1 из %2';
														|en = 'Загружено %1 из %2'"), Загружено, ОсталосьЗагрузить);
		
		ПараметрыОбработчикаОжидания.ТекущийИнтервал =
			ПараметрыОбработчикаОжидания.ТекущийИнтервал * ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала;
		Если ПараметрыОбработчикаОжидания.ТекущийИнтервал > ПараметрыОбработчикаОжидания.МаксимальныйИнтервал Тогда
			ПараметрыОбработчикаОжидания.ТекущийИнтервал = ПараметрыОбработчикаОжидания.МаксимальныйИнтервал;
		КонецЕсли;
		
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания",
			ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполненоНаСервере(ИдентификаторЗадания)
		
	Возврат ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

// Проверяет состояние фонового задания по переданному идентификатору.
// При аварийном завершении задания вызывает исключение.
//
// Параметры:
//  ИдентификаторЗадания - УникальныйИдентификатор - идентификатор фонового задания. 
//
// Возвращаемое значение:
//  Булево - состояние выполнения задания.
// 
&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(Знач ИдентификаторЗадания) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ЗаданиеВыполнено", Ложь);
	Результат.Вставить("ВсегоКЗагрузке", 0);
	Результат.Вставить("Загружено", 0);
	
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	
	Если Задание <> Неопределено
		И Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Сообщения = Задание.ПолучитьСообщенияПользователю();
		
		Для Каждого Сообщение Из Сообщения Цикл
			Если СтрНачинаетсяС(Сообщение.Текст, "#JSON#:") Тогда
				ЧтениеJSON = Новый ЧтениеJSON;
				ЧтениеJSON.УстановитьСтроку(СтрЗаменить(Сообщение.Текст, "#JSON#:", ""));
				Прогресс = ПрочитатьJSON(ЧтениеJSON);
				ЧтениеJSON.Закрыть();
				
				Результат.Вставить("ВсегоКЗагрузке", Прогресс.ВсегоКЗагрузке);
				Результат.Вставить("Загружено", Прогресс.Загружено);
			КонецЕсли;	
		КонецЦикла;
		
		Возврат Результат;
	КонецЕсли;
	
	ОперацияНеВыполнена = Истина;
	ПоказатьПолныйТекстОшибки = Ложь;
	Если Задание = Неопределено Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Длительные операции.Фоновое задание не найдено';
										|en = 'Длительные операции.Фоновое задание не найдено'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , Строка(ИдентификаторЗадания));
	Иначе
		Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
			ОшибкаЗадания = Задание.ИнформацияОбОшибке;
			Если ОшибкаЗадания <> Неопределено Тогда
				ПоказатьПолныйТекстОшибки = Истина;
			КонецЕсли;
		ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Длительные операции.Фоновое задание отменено администратором';
					|en = 'Длительные операции.Фоновое задание отменено администратором'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				НСтр("ru = 'Задание завершилось с неизвестной ошибкой.';
					|en = 'Задание завершилось с неизвестной ошибкой.'"));
		Иначе
			Результат.ЗаданиеВыполнено = Истина;		
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	
	Если ПоказатьПолныйТекстОшибки Тогда
		ТекстОшибки = КраткоеПредставлениеОшибки(ПолучитьИнформациюОбОшибке(Задание.ИнформацияОбОшибке));
		ВызватьИсключение(ТекстОшибки);
	ИначеЕсли ОперацияНеВыполнена Тогда
		ВызватьИсключение(НСтр("ru = 'Не удалось выполнить данную операцию. 
		                             |Подробности см. в Журнале регистрации.';
		                             |en = 'Не удалось выполнить данную операцию. 
		                             |Подробности см. в Журнале регистрации.'"));
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция НайтиЗаданиеПоИдентификатору(Знач ИдентификаторЗадания)
	
	Если ТипЗнч(ИдентификаторЗадания) = Тип("Строка") Тогда
		ИдентификаторЗадания = Новый УникальныйИдентификатор(ИдентификаторЗадания);
	КонецЕсли;
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	
	Возврат Задание;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьИнформациюОбОшибке(ИнформацияОбОшибке)
	
	Результат = ИнформацияОбОшибке;
	Если ИнформацияОбОшибке <> Неопределено Тогда
		Если ИнформацияОбОшибке.Причина <> Неопределено Тогда
			Результат = ПолучитьИнформациюОбОшибке(ИнформацияОбОшибке.Причина);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьЗадание(ИдентификаторЗадания)
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания) Экспорт
	
	ПараметрыОбработчикаОжидания = Новый Структура;
	ПараметрыОбработчикаОжидания.Вставить("МинимальныйИнтервал", 1);
	ПараметрыОбработчикаОжидания.Вставить("МаксимальныйИнтервал", 4);
	ПараметрыОбработчикаОжидания.Вставить("ТекущийИнтервал", 1);
	ПараметрыОбработчикаОжидания.Вставить("КоэффициентУвеличенияИнтервала", 1.2);
	
КонецПроцедуры

&НаСервере
Процедура НачатьЗагрузкуФайла()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ДополнительныйРезультат = Истина;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Скачивание файла из Интернет';
															|en = 'Скачивание файла из Интернет'");
	
	Результат = ДлительныеОперации.ВыполнитьВФоне(
		"ОперацииСФайламиЭДКОСлужебный.СкачатьФайлНаСервере",
		ПараметрыЗадания,
		ПараметрыВыполнения);
	
	АдресХранилища               = Результат.АдресРезультата;
	ИдентификаторЗадания         = Результат.ИдентификаторЗадания;
	ЗаданиеВыполнено             = Результат.Статус = "Выполнено";
	АдресХранилищаДополнительный = Результат.АдресДополнительногоРезультата;
	
КонецПроцедуры

#КонецОбласти