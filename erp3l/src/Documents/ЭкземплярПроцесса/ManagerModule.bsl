#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
// Выполянет запись данных возврата объекта согласования по процессу ЭкземплярПроцессаВход
// на обработку с комментарием ТекстСообщенияВход от имени пользователя ПользовательВход.
// Когда параметр ЭтапПроцессаВход указан, запись будет проиходить только по указанному
// этапу.
Процедура ЗаписатьВРегистрДанныеПоВозвратуОбъекта(ЭкземплярПроцессаВход, ТекстСообщенияВход = "", ПользовательВход = Неопределено, ЭтапПроцессаВход = Неопределено) Экспорт
	Запрос = Новый Запрос;
	
	// Сброс активности у выполняемых этапов процесса.
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВыполнениеПроцессов.ЭтапПроцесса КАК ЭтапПроцесса,
	|	ВыполнениеПроцессов.ДокументПроцесса КАК ДокументПроцесса,
	|	ВыполнениеПроцессов.Комментарий КАК Комментарий,
	|	ВыполнениеПроцессов.Автор КАК Автор,
	|	ВыполнениеПроцессов.Организация КАК Организация,
	|	ВыполнениеПроцессов.Период КАК Период,
	|	ВыполнениеПроцессов.СостояниеЭтапа КАК СостояниеЭтапа,
	|	ВыполнениеПроцессов.ЧислоСогласованныхЭтаповПредшественников КАК ЧислоСогласованныхЭтаповПредшественников,
	|	ВыполнениеПроцессов.Комментарий КАК Комментарий1,
	|	ВыполнениеПроцессов.ОписаниеВерсии КАК ОписаниеВерсии,
	|	ВыполнениеПроцессов.ДатаНачала КАК ДатаНачала,
	|	ВыполнениеПроцессов.ДатаОкончания КАК ДатаОкончания
	|ИЗ
	|	РегистрСведений.ВыполнениеПроцессов КАК ВыполнениеПроцессов
	|ГДЕ
	|	ВыполнениеПроцессов.ДокументПроцесса = &ДокументПроцесса
	|	И ВыполнениеПроцессов.АрхивнаяЗапись = ЛОЖЬ
	|	И ВЫБОР
	|			КОГДА &ЭтапПроцесса = НЕОПРЕДЕЛЕНО
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ВыполнениеПроцессов.ЭтапПроцесса = &ЭтапПроцесса
	|		КОНЕЦ";
	
	МассивСостояний = Новый Массив;
	МассивСостояний.Добавить(Перечисления.СостоянияЭтаповУниверсальныхПроцессов.ВОбработке);
	МассивСостояний.Добавить(Перечисления.СостоянияЭтаповУниверсальныхПроцессов.Завершен);
	
	Запрос.УстановитьПараметр("ДокументПроцесса", ЭкземплярПроцессаВход);
	Запрос.УстановитьПараметр("СписокСогласования", МассивСостояний);
	Запрос.УстановитьПараметр("ЭтапПроцесса", ЭтапПроцессаВход);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НовыйМенеджерЗаписи = РегистрыСведений.ВыполнениеПроцессов.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(НовыйМенеджерЗаписи, Выборка);
		НовыйМенеджерЗаписи.АрхивнаяЗапись = Истина;
		Если Не ЗначениеЗаполнено(НовыйМенеджерЗаписи.ДатаОкончания) Тогда
			НовыйМенеджерЗаписи.ДатаОкончания = ТекущаяДатаСеанса();
		Иначе
			// Не изменяем существующую дату окончания.
		КонецЕсли;	
		НовыйМенеджерЗаписи.Записать(Истина);
		
	КонецЦикла;
	
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВыполнениеПроцессовСрезПоследних.ЭтапПроцесса КАК ЭтапПроцесса,
	|	ВыполнениеПроцессовСрезПоследних.ДокументПроцесса КАК ДокументПроцесса,
	|	ВыполнениеПроцессовСрезПоследних.Комментарий КАК Комментарий,
	|	ВыполнениеПроцессовСрезПоследних.Автор КАК Автор,
	|	ВыполнениеПроцессовСрезПоследних.Организация КАК Организация,
	|	ВыполнениеПроцессовСрезПоследних.ДатаНачала КАК ДатаНачала,
	|	ВыполнениеПроцессовСрезПоследних.ДатаОкончания КАК ДатаОкончания
	|ИЗ
	|	РегистрСведений.ВыполнениеПроцессов.СрезПоследних(, ДокументПроцесса = &ДокументПроцесса) КАК ВыполнениеПроцессовСрезПоследних
	|ГДЕ
	|	ВыполнениеПроцессовСрезПоследних.СостояниеЭтапа В(&СписокСогласования)
	|	И ВЫБОР
	|			КОГДА &ЭтапПроцесса = НЕОПРЕДЕЛЕНО
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ВыполнениеПроцессовСрезПоследних.ЭтапПроцесса = &ЭтапПроцесса
	|		КОНЕЦ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НаборЗаписей = РегистрыСведений.ВыполнениеПроцессов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДокументПроцесса.Значение = ЭкземплярПроцессаВход;
	НаборЗаписей.Отбор.ДокументПроцесса.Использование = Истина;
	ТекущийПользователь = ОбщегоНазначенияУХ.ПолучитьЗначениеПеременной("глТекущийПользователь");
	
	Пока Выборка.Следующий() Цикл
		
		Строка = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(Строка, Выборка);
		Строка.СостояниеЭтапа			 = Перечисления.СостоянияЭтаповУниверсальныхПроцессов.ЗавершенСОшибкой;
		Если ПользовательВход			 = Неопределено Тогда
			Строка.АвторПредставление    = Строка(ТекущийПользователь);
		Иначе
			Строка.АвторПредставление    = Строка(ПользовательВход);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Строка.ДатаОкончания) Тогда
			Строка.ДатаОкончания = ТекущаяДатаСеанса();
		Иначе
			// Не изменяем существующую дату окончания.
		КонецЕсли;	
		Строка.Комментарий          	 = ТекстСообщенияВход;
		Строка.АрхивнаяЗапись			 = Истина;
		Строка.Период					 = ОбщегоНазначенияСерверУХ.ПолучитьОтметкуПоОбъекту(Выборка.ДокументПроцесса);
		
	КонецЦикла;
	
	НаборЗаписей.Записать(Ложь);
	
КонецПроцедуры		// ЗаписатьВРегистрДанныеПоВозвратуОбъекта()

// Возвращает инициатора процесса ПроцессВход.
Функция ВернутьИнициатораПроцесса(ПроцессВход) Экспорт
	ПустойПользователь = Справочники.Пользователи.ПустаяСсылка();
	РезультатФункции = ПустойПользователь;
	Если ЗначениеЗаполнено(ПроцессВход) Тогда
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("КодПараметра", "ИнициаторПроцесса");
		НайденныеСтроки = ПроцессВход.ПараметрыПроцесса.НайтиСтроки(СтруктураПоиска);
		Для Каждого ТекНайденныеСтроки Из НайденныеСтроки Цикл
			РезультатФункции = ТекНайденныеСтроки.ЗначениеПоУмолчанию;		
		КонецЦикла;	
	Иначе
		РезультатФункции = ПустойПользователь;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции		// ВернутьИнициатораПроцесса()

#КонецЕсли	