Перем НужнаИнициализация;
Перем СбросОтчетов;

Процедура ВозвратОтчетаНаДоработку(ТекстСообщения) Экспорт
	
	Запрос = Новый Запрос;
	
	// Сброс активности у выполняемых этапов процесса.
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СогласованиеОтчетов.ЭтапСогласования,
	|	СогласованиеОтчетов.ДокументСогласования,
	|	СогласованиеОтчетов.Комментарий,
	|	СогласованиеОтчетов.Автор,
	|	СогласованиеОтчетов.Организация,
	|	СогласованиеОтчетов.Период,
	|	СогласованиеОтчетов.СостояниеСогласования,
	|	СогласованиеОтчетов.ЧислоСогласованныхЭтаповПредшественников,
	|	СогласованиеОтчетов.Комментарий КАК Комментарий1,
	|	СогласованиеОтчетов.ОписаниеВерсии
	|ИЗ
	|	РегистрСведений.СогласованиеОтчетов КАК СогласованиеОтчетов
	|ГДЕ
	|	СогласованиеОтчетов.ДокументСогласования = &ДокументСогласования
	|	И СогласованиеОтчетов.АрхивнаяЗапись = ЛОЖЬ";
	
	МассивСостояний = Новый Массив;
	МассивСостояний.Добавить(Перечисления.СостоянияОтчетов.Выполняется);
	МассивСостояний.Добавить(Перечисления.СостоянияОтчетов.Подготовлен);
	МассивСостояний.Добавить(Перечисления.СостоянияОтчетов.Утвержден);
	
	Запрос.УстановитьПараметр("ДокументСогласования", Ссылка);
	Запрос.УстановитьПараметр("СписокСогласования", МассивСостояний);

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НовыйМенеджерЗаписи = РегистрыСведений.СогласованиеОтчетов.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(НовыйМенеджерЗаписи, Выборка);
		НовыйМенеджерЗаписи.АрхивнаяЗапись = Истина;
		НовыйМенеджерЗаписи.Записать(Истина);
		
	КонецЦикла;

	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СогласованиеОтчетовСрезПоследних.ЭтапСогласования,
	|	СогласованиеОтчетовСрезПоследних.ДокументСогласования,
	|	СогласованиеОтчетовСрезПоследних.Комментарий,
	|	СогласованиеОтчетовСрезПоследних.Автор,
	|	СогласованиеОтчетовСрезПоследних.Организация
	|ИЗ
	|	РегистрСведений.СогласованиеОтчетов.СрезПоследних(, ДокументСогласования = &ДокументСогласования) КАК СогласованиеОтчетовСрезПоследних
	|ГДЕ
	|	СогласованиеОтчетовСрезПоследних.СостояниеСогласования В(&СписокСогласования)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НаборЗаписей = РегистрыСведений.СогласованиеОтчетов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДокументСогласования.Значение = Ссылка;
	НаборЗаписей.Отбор.ДокументСогласования.Использование = Истина;
	ТекущийПользователь = ОбщегоНазначенияУХ.ПолучитьЗначениеПеременной("глТекущийПользователь");
	
	Пока Выборка.Следующий() Цикл
		
		Строка = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(Строка, Выборка);
		Строка.СостояниеСогласования = Перечисления.СостоянияОтчетов.Возвращен;
		Строка.Автор                 = ТекущийПользователь;
		Строка.Комментарий           = ТекстСообщения;
		Строка.АрхивнаяЗапись = Истина;
		Строка.Период         = ОбщегоНазначенияСерверУХ.ПолучитьОтметкуПоОбъекту(Выборка.ДокументСогласования);
		
	КонецЦикла;
	
	НаборЗаписей.Записать(Ложь);
	
	СостояниеВыполнения = Перечисления.СостоянияОтчетов.Возвращен;
	СбросОтчетов = Истина;
	Записать();
	
	Если ЗначениеЗаполнено(СогласованиеРодитель) Тогда
		ОбъектРодитель = СогласованиеРодитель.ПолучитьОбъект();
		ОбъектРодитель.ВозвратОтчетаНаДоработку(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

Процедура УтвердитьОтчет(ТекстСообщения) Экспорт
	
	// Сброс активности у выполняемых этапов процесса.
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СогласованиеОтчетов.ЭтапСогласования,
	|	СогласованиеОтчетов.ДокументСогласования,
	|	СогласованиеОтчетов.Комментарий,
	|	СогласованиеОтчетов.Автор,
	|	СогласованиеОтчетов.Организация,
	|	СогласованиеОтчетов.Период,
	|	СогласованиеОтчетов.СостояниеСогласования,
	|	СогласованиеОтчетов.ЧислоСогласованныхЭтаповПредшественников,
	|	СогласованиеОтчетов.Комментарий КАК Комментарий1,
	|	СогласованиеОтчетов.ОписаниеВерсии
	|ИЗ
	|	РегистрСведений.СогласованиеОтчетов КАК СогласованиеОтчетов
	|ГДЕ
	|	СогласованиеОтчетов.ДокументСогласования = &ДокументСогласования
	|	И СогласованиеОтчетов.АрхивнаяЗапись = ЛОЖЬ";
	
	МассивСостояний = Новый Массив;
	МассивСостояний.Добавить(Перечисления.СостоянияОтчетов.Выполняется);
	МассивСостояний.Добавить(Перечисления.СостоянияОтчетов.Подготовлен);
	МассивСостояний.Добавить(Перечисления.СостоянияОтчетов.Возвращен);
	
	Запрос.УстановитьПараметр("ДокументСогласования", Ссылка);
	Запрос.УстановитьПараметр("СписокСогласования", МассивСостояний);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НовыйМенеджерЗаписи = РегистрыСведений.СогласованиеОтчетов.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(НовыйМенеджерЗаписи, Выборка);
		НовыйМенеджерЗаписи.Активность = Ложь;
		НовыйМенеджерЗаписи.Записать(Истина);
		
	КонецЦикла;
	

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СогласованиеОтчетовСрезПоследних.ЭтапСогласования,
	|	СогласованиеОтчетовСрезПоследних.ДокументСогласования,
	|	СогласованиеОтчетовСрезПоследних.Комментарий,
	|	СогласованиеОтчетовСрезПоследних.Автор,
	|	СогласованиеОтчетовСрезПоследних.Организация
	|ИЗ
	|	РегистрСведений.СогласованиеОтчетов.СрезПоследних(, ДокументСогласования = &ДокументСогласования) КАК СогласованиеОтчетовСрезПоследних
	|ГДЕ
	|	СогласованиеОтчетовСрезПоследних.СостояниеСогласования В(&СписокСогласования)";
	
	МассивСостояний = Новый Массив;
	МассивСостояний.Добавить(Перечисления.СостоянияОтчетов.Выполняется);
	МассивСостояний.Добавить(Перечисления.СостоянияОтчетов.Подготовлен);
	МассивСостояний.Добавить(Перечисления.СостоянияОтчетов.Возвращен);
	
	Запрос.УстановитьПараметр("ДокументСогласования", Ссылка);
	Запрос.УстановитьПараметр("СписокСогласования", МассивСостояний);
	Выборка = Запрос.Выполнить().Выбрать();
	
	НаборЗаписей = РегистрыСведений.СогласованиеОтчетов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДокументСогласования.Значение = Ссылка;
	НаборЗаписей.Отбор.ДокументСогласования.Использование = Истина;
	ТекущийПользователь = ОбщегоНазначенияУХ.ПолучитьЗначениеПеременной("глТекущийПользователь");
	
	Пока Выборка.Следующий() Цикл
		
		Строка = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(Строка, Выборка);
		Строка.СостояниеСогласования = Перечисления.СостоянияОтчетов.Утвержден;
		Строка.Автор                 = ТекущийПользователь;
		Строка.Комментарий           = ТекстСообщения;
		Строка.АрхивнаяЗапись = Истина;
		Строка.Период         = ОбщегоНазначенияСерверУХ.ПолучитьОтметкуПоОбъекту(Выборка.ДокументСогласования);
		
	КонецЦикла;
	
	НаборЗаписей.Записать(Ложь);
	
	СостояниеВыполнения = Перечисления.СостоянияОтчетов.Утвержден;
	СбросОтчетов = Истина;
	Записать();
	
	Если ЗначениеЗаполнено(СогласованиеРодитель) Тогда
		ОбъектРодитель = СогласованиеРодитель.ПолучитьОбъект();
		ОбъектРодитель.УтвердитьОтчет(ТекстСообщения);
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если НЕ ЭтоНовый() Тогда
		
		Если СостояниеВыполнения = Перечисления.СостоянияОтчетов.Возвращен Тогда
		
			НаборЗаписей = РегистрыСведений.СогласованиеОтчетов.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ДокументСогласования.Значение      = Ссылка;
			НаборЗаписей.Отбор.ДокументСогласования.Использование = Истина;
			НаборЗаписей.Прочитать();
			
			Для Каждого Запись Из НаборЗаписей Цикл
				
				Запись.СостояниеСогласования = Перечисления.СостоянияОтчетов.Возвращен;
				
				Если Запись.ЭтапСогласования.ТипЭтапа = Перечисления.ТипыЭтаповСогласования.ДочернийМаршрут Тогда
					ДокументСогласования = МодульСогласованияДокументовУХ.ОпределитьДокументСогласованияДляЭтапаСогласования(Запись.ЭтапСогласования.ДочернийМаршрут, Запись.ЭтапСогласования);
					Если ДокументСогласования.СостояниеВыполнения <> Перечисления.СостоянияОтчетов.Возвращен Тогда
						Попытка
							ДокументСогласованияОбъект =  ДокументСогласования.ПолучитьОбъект();
							ДокументСогласованияОбъект.СостояниеВыполнения = Перечисления.СостоянияОтчетов.Возвращен;
							ДокументСогласованияОбъект.Записать();
						Исключение
							ОбщегоНазначенияУХ.СообщитьОбОшибке("Ошибка при отмене дочернего процесса: " + Запись.ЭтапСогласования.ДочернийМаршрут + " этапа согласования: " + Запись.ЭтапСогласования);
							Отказ = Истина;
						КонецПопытки;
					КонецЕсли;
				КонецЕсли;
				
			КонецЦикла;
			
			НаборЗаписей.Записать(Истина);
			
		КонецЕсли;
		
		НужнаИнициализация = Ложь;
	Иначе
		НужнаИнициализация = Истина;
	КонецЕсли;
	
КонецПроцедуры


Процедура ПередУдалением(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	НаборЗаписей = РегистрыСведений.СогласованиеОтчетов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДокументСогласования.Значение      = Ссылка;
	НаборЗаписей.Отбор.ДокументСогласования.Использование = Истина;
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры
