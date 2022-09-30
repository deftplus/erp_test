
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
						  | СкрытыеРегламентированныеОтчеты.РегламентированныйОтчет КАК Ссылка
						  |ИЗ
						  |	РегистрСведений.СкрытыеРегламентированныеОтчеты КАК СкрытыеРегламентированныеОтчеты");
		
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
		
	Если РезультатЗапроса.Количество() = 0 Тогда
				
		Сообщение = Новый СообщениеПользователю;

		Сообщение.Текст = НСтр("ru = 'Отсутствуют элементы для восстановления.';
								|en = 'Отсутствуют элементы для восстановления.'");

		Сообщение.Сообщить();

		Отказ = Истина;
		
		Возврат;
		
	КонецЕсли;
	            	
	Для Каждого СтрТаблЗнач Из РезультатЗапроса Цикл
		
		Стр = ТаблицаЗначений.Добавить();
		Стр.Ссылка       = СтрТаблЗнач.Ссылка;
		Стр.Код          = СтрТаблЗнач.Ссылка.Код;
		Стр.Наименование = СтрТаблЗнач.Ссылка.Наименование;
		
	КонецЦикла;
					
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаСервере
Процедура УстановитьИлиСнятьФлажки(Флаг)
	
	Для Каждого Стр Из ТаблицаЗначений Цикл
		
		Стр.Пометка = Флаг;
				
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьИлиСнятьФлажки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьИлиСнятьФлажки(Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура Восстановить(Команда)
	
	ВосстановитьСервер();
	
	Закрыть();
		
КонецПроцедуры

&НаСервере
Процедура ВосстановитьСервер()
	
	НачатьТранзакцию();
	
	Для Каждого Стр Из ТаблицаЗначений Цикл
		
		Если Стр.Пометка = Истина Тогда
			
			Попытка
												
				ВыборкаРегистрСведенийСкрытыеРегламентированныеОтчеты = РегистрыСведений.СкрытыеРегламентированныеОтчеты.Выбрать(Новый Структура("РегламентированныйОтчет", Стр.Ссылка));
				
				Пока ВыборкаРегистрСведенийСкрытыеРегламентированныеОтчеты.Следующий() Цикл
					ВыборкаРегистрСведенийСкрытыеРегламентированныеОтчеты.ПолучитьМенеджерЗаписи().Удалить();
				КонецЦикла;
								
			Исключение
								
				Сообщение = Новый СообщениеПользователю;
				
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не удалось удалить ссылку на скрытый отчет из регистра сведений. %1';
																								|en = 'Не удалось удалить ссылку на скрытый отчет из регистра сведений. %1'"), ОписаниеОшибки());
				
				Сообщение.Сообщить();
                         				
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
			
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗначенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗначенийПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти


