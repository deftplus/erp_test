Перем ЗначениеКопирования Экспорт;

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ШапкаОшибки = "Шаблон процесса: """ + ЭтотОбъект + """ не может быть записан:";
	
	Если ЗначениеЗаполнено(ЗначениеКопирования) Тогда
		Если СкопироватьСвязнуюИнформацию(ЗначениеКопирования, Отказ, ШапкаОшибки) Тогда
			ЗначениеКопирования = Неопределено;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

Функция СкопироватьСвязнуюИнформацию(Источник, Отказ = Ложь, ШапкаОшибки = "") Экспорт
	
	Если Отказ Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Соответствие = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроцессов.Ссылка
	|ИЗ
	|	Справочник.УдалитьЭтапыПроцессов КАК ЭтапыПроцессов
	|ГДЕ
	|	ЭтапыПроцессов.Владелец = &Источник";
	
	Запрос.УстановитьПараметр("Источник", Источник);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НовыйОбъект = Выборка.Ссылка.Скопировать();
		НовыйОбъект.Владелец = Ссылка;
		НовыйОбъект.ЗначениеКопирования = Выборка.Ссылка;
		
		Попытка
			НовыйОбъект.Записать();
		Исключение
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ОписаниеОшибки(), Отказ, ШапкаОшибки);
			Возврат Ложь;
		КонецПопытки; 
		
		Соответствие.Вставить(Выборка.Ссылка, НовыйОбъект);
		
	КонецЦикла;
	
	Для Каждого КлючЗначение Из Соответствие Цикл
		
		Если ЗначениеЗаполнено(КлючЗначение.Ключ.Родитель) Тогда
			КлючЗначение.Значение.Родитель = Соответствие.Получить(КлючЗначение.Ключ.Родитель);
			Попытка
				КлючЗначение.Значение.Записать();
			Исключение
				ОбщегоНазначенияУХ.СообщитьОбОшибке(ОписаниеОшибки(), Отказ, ШапкаОшибки);
				Возврат Ложь;
			КонецПопытки;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции