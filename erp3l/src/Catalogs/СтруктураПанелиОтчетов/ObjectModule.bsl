
Процедура ИзменитьПорядковыйНомер(Направление) Экспорт
	
	ТекущийНомер    = ПорядковыйНомер;
	СписокКодов   = Новый СписокЗначений;

	СтруктураПанелиОтчетов  = Справочники.СтруктураПанелиОтчетов;
	ВыборкаСтроки = СтруктураПанелиОтчетов.Выбрать(Родитель, Владелец, , "ПорядковыйНомер Убыв");

	Пока ВыборкаСтроки.Следующий() Цикл
		СписокКодов.Добавить(ВыборкаСтроки.ПорядковыйНомер);
	КонецЦикла;

	
	Если СписокКодов.Количество() < 2  Тогда
		// На данном уровне имеется только один элемент или группа справочника.
		// Игнорируем действие пользователя.

		Возврат;
	КонецЕсли; 

	ПорядковыйНомер = СписокКодов.Индекс(СписокКодов.НайтиПоЗначению(ТекущийНомер));

	Если (ПорядковыйНомер = 0) И (Направление < 0) Тогда

		// Попытка перемещения первого по порядку элемента вверх.
		ИндексЭлементаЗамены = СписокКодов.Количество() - 1;
	
	ИначеЕсли (ПорядковыйНомер = СписокКодов.Количество() - 1) И (Направление > 0) Тогда

		// Попытка перемещения последнего по порядку элемента вниз.
		ИндексЭлементаЗамены = 0;

	Иначе

		// в иных случаях
		ИндексЭлементаЗамены = ПорядковыйНомер + Направление;

	КонецЕсли;

	КодЭлементаЗамены     = СписокКодов.Получить(ИндексЭлементаЗамены).Значение;
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	СтруктураПанелиОтчетов.Ссылка
	             |ИЗ
	             |	Справочник.СтруктураПанелиОтчетов КАК СтруктураПанелиОтчетов
	             |ГДЕ
	             |	СтруктураПанелиОтчетов.Владелец = &Владелец
	             |	И СтруктураПанелиОтчетов.Родитель = &Родитель
	             |	И СтруктураПанелиОтчетов.ПорядковыйНомер = &ПорядковыйНомер";
				 
	Запрос.УстановитьПараметр("Владелец",Владелец);
	Запрос.УстановитьПараметр("Родитель",Родитель);
	Запрос.УстановитьПараметр("ПорядковыйНомер",КодЭлементаЗамены);

	Результат=Запрос.Выполнить().Выбрать();
		
	Если Результат.Следующий() Тогда
		
		Попытка
			
			// Открываем транзакцию
			НачатьТранзакцию();
			
			// Промежуточная запись текущего элемента с уникальным кодом
			ЭтотОбъект.ПорядковыйНомер=10000000;
			ЭтотОбъект.Записать();
						
			// записываем соседний элемент с кодом текущего
			ЭлементЗамены= Результат.Ссылка.ПолучитьОбъект();
			ПредыдущийКод=КодЭлементаЗамены;
			ЭлементЗамены.ПорядковыйНомер = ТекущийНомер;
			ЭлементЗамены.Записать();
			
			// записываем текущий элемент с кодом соседнего
			ЭтотОбъект.ПорядковыйНомер = ПредыдущийКод;
			ЭтотОбъект.Записать();
			
			// Завершаем транзакцию
			ЗафиксироватьТранзакцию();
			
		Исключение
			СообщениеПользователю = Новый СообщениеПользователю;
			
			СтрокаШаблона = Нстр("ru = 'Не удалось записать элемент справочника:
			|%1'");
			
			Если Не ПустаяСтрока(СтрокаШаблона) тогда	
				СообщениеПользователю.Текст = СтрШаблон(СтрокаШаблона, ОписаниеОшибки());
			КонецЕсли;
			
			СообщениеПользователю.Сообщить();
			Возврат;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	
	Если Ссылка.Пустая() Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ Первые 1
		|	СтруктураПанелиОтчетов.ПорядковыйНомер КАК ПорядковыйНомер
		|ИЗ
		|	Справочник.СтруктураПанелиОтчетов КАК СтруктураПанелиОтчетов
		|ГДЕ
		|	СтруктураПанелиОтчетов.Владелец = &Владелец
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПорядковыйНомер УБЫВ";
		Запрос.УстановитьПараметр("Владелец", Владелец);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ПорядковыйНомер = Выборка.ПорядковыйНомер + 1;
		Иначе
			ПорядковыйНомер = 0;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
