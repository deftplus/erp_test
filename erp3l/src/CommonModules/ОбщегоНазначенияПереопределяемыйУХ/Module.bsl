////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНАЯ ПРОЦЕДУРА СООБЩЕНИЯ ОБ ОШИБКЕ ПРИ ОШИБКЕ ОТКРЫТИЯ ФАЙЛА XLS.
//

Процедура СообщитьОбОшибкеОткрытияФайлаXLS(ТекстОшибки = Неопределено) Экспорт
	
	СообщениеПользователю = Новый СообщениеПользователю;
	СообщениеПользователю.Текст = СтрШаблон(Нстр("ru = 'Не удалось открыть файл XLS.
	|%1
	|Возможные причины ошибки описаны в справке к документу ""Экземпляр отчета"" в разделе ""Импорт""'"), 
	?(ТекстОшибки = Неопределено, "", ТекстОшибки));
	СообщениеПользователю.Сообщить();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ПОЧТОВЫМИ УВЕДОМЛЕНИЯМИ

Функция ПолучитьСсылкуНаОбъектПочта(УчетнаяЗапись, ТихийРежим = Ложь) Экспорт
	
	УчетнаяЗапись = РаботаСПочтовымиСообщениями.СистемнаяУчетнаяЗапись();
	
	Если НЕ РаботаСПочтовымиСообщениями.УчетнаяЗаписьНастроена(УчетнаяЗапись,Истина,Ложь) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Профиль = УправлениеЭлектроннойПочтойУХ.ПолучитьИнтернетПочтовыйПрофиль(УчетнаяЗапись);
	Почта   = Новый ИнтернетПочта;
	
	Попытка
		Почта.Подключиться(Профиль);
	Исключение
		
		Если НЕ ТихийРежим Тогда
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			СообщениеПользователю.Сообщить();
			Возврат Неопределено;
		КонецЕсли;
		
	КонецПопытки;
	
	Возврат Почта;
	
КонецФункции

Процедура ОтправитьПисьмаИзРегистра() Экспорт
	
	Перем УчетнаяЗапись;
	
	Почта   = ПолучитьСсылкуНаОбъектПочта(УчетнаяЗапись, Истина);
	
	Если Почта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УведомленияПоЭлектроннойПочте.Источник,
	|	УведомленияПоЭлектроннойПочте.ДатаСоздания,
	|	УведомленияПоЭлектроннойПочте.Письмо,
	|	УведомленияПоЭлектроннойПочте.ИдентификаторПисьма
	|ИЗ
	|	РегистрСведений.УведомленияПоЭлектроннойПочте КАК УведомленияПоЭлектроннойПочте
	|ГДЕ
	|	УведомленияПоЭлектроннойПочте.ДатаОтправки = ДАТАВРЕМЯ(1, 1, 1)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			Письмо = Выборка.Письмо.Получить();
			Письмо.Кодировка = "utf-8";
			Письмо.Отправитель = УчетнаяЗапись.АдресЭлектроннойПочты;
			Почта.Послать(Письмо);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ИнформацияОбОшибке.Описание);
			Продолжить;
		КонецПопытки;
		
		НоваяЗапись = РегистрыСведений.УведомленияПоЭлектроннойПочте.СоздатьМенеджерЗаписи();
		НоваяЗапись.Источник			 = Выборка.Источник;
		НоваяЗапись.ДатаСоздания		 = Выборка.ДатаСоздания;
		НоваяЗапись.ИдентификаторПисьма	 = Выборка.ИдентификаторПисьма;
		НоваяЗапись.Письмо				 = Новый ХранилищеЗначения(Письмо, Новый СжатиеДанных());
		НоваяЗапись.ДатаОтправки		 = ТекущаяДата();
		
		НоваяЗапись.Записать();
	КонецЦикла;
	
	Почта.Отключиться();
	
КонецПроцедуры

Функция ЗаполнитьВалютуОперацииМСФОПоСубконтоДоговор(ЗначениеВалютыВСтроке, ПараметрыДокумента) Экспорт
	Договор = Неопределено;
	Счет = Неопределено;
	Если НЕ ПараметрыДокумента.Свойство("ДоговорКонтрагента", Договор) Тогда
		Возврат Неопределено;
	КонецЕсли;
	Если НЕ ПараметрыДокумента.Свойство("СчетУчета", Счет) Тогда
		Возврат Неопределено;
	КонецЕсли;
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Счет, "Валютный") Тогда
		Валюта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ВалютаВзаиморасчетов");
		Возврат Валюта;
	КонецЕсли;
КонецФункции