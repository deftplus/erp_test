Перем Используется77; // Признак использования обращения к ВИБ на платформе 7.7
Перем ТекСоединениеВИБ Экспорт; // Текущее соединение с внешней информационной базой
Перем ПланВидовХарактеристикБД;
Перем ТекущаяИБ;
Перем мОписаниеТиповСтрока;
Перем мОписаниеТиповБулево;
Перем мОписаниеТиповТЗ;
Перем мОписаниеТиповСписокЗначений;
Перем ТаблицаРеквизитовКонсолидации;
Перем ТаблицаРеквизитовВИБ;
Перем ТекТаблицаСинхронизации;

Процедура ЗаполнитьРеквизитыОбъекта(Кэш = Неопределено, ЕстьИзменения = Истина) Экспорт
	
	Если Не ПроверитьНаименование() Тогда		
		Возврат;	
	КонецЕсли;
	
	ТекущаяИБ = (Владелец = Справочники.ТипыБазДанных.ТекущаяИБ);
	
	Если Не ТекущаяИБ Тогда
		
		Если ТекСоединениеВИБ = Неопределено Тогда
			
			ТекСоединениеВИБ = ОбщегоНазначенияУХ.ПолучитьСоединениеСВИБПоУмолчанию(Владелец, 1);
			
			Если ТекСоединениеВИБ = Неопределено Тогда
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ТекСоединениеВИБ = Обработки.РаботаСМетаданнымиУХ.Создать();
		
	КонецЕсли;
	
	РеквизитыДоОбновления = Реквизиты.Выгрузить();
	
	СтруктураОписания = ОбщегоНазначенияУХ.ПолучитьСтруктуруОписанияПланаВидовХарактеристикБД(
		Наименование, ТекСоединениеВИБ, Кэш);
	
	Если СтруктураОписания.Свойство("ТекстОшибки") Тогда
		
		ОбщегоНазначенияУХ.СообщитьОбОшибке(СтруктураОписания.ТекстОшибки, Истина,, СтатусСообщения.Внимание);
		Возврат;
		
	КонецЕсли;
	
	ОбщегоНазначенияУХ.ЗаполнитьИзмененныеРеквизиты(ЭтотОбъект, СтруктураОписания, "Реквизиты", ЕстьИзменения);
	
	ТабНовыеРеквизиты = ЭтотОбъект.Реквизиты.ВыгрузитьКолонки();
	Для Каждого СтрРеквизит ИЗ СтруктураОписания.Реквизиты Цикл
		
		НоваяСтрока = ТабНовыеРеквизиты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрРеквизит,, "Использование");
		
		Если ЗначениеЗаполнено(СтрРеквизит.Использование) Тогда	
			НоваяСтрока.Использование = Перечисления.ИспользованиеРеквизита[СтрРеквизит.Использование];		
		КонецЕсли;	
	КонецЦикла;
	
	ОбщегоНазначенияУХ.ЗагрузитьИзмененнуюТабЧасть(ЭтотОбъект.Реквизиты, ТабНовыеРеквизиты, ЕстьИзменения);
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
						
		ОбщегоНазначенияУХ.ОбновитьОписаниеТабличнойЧастиБД(ТекСоединениеВИБ, Ссылка, 
			Новый Структура("ТипОбъектаМетаданных, ИмяОбъектаМетаданных", "ChartsOfCharacteristicTypes", Наименование),
			,
			Кэш);
								
	КонецЕсли;
			
КонецПроцедуры // ЗаполнитьРеквизитыОбъекта()
	
Функция ПроверитьНаименование()
	
	ЕстьОшибки=Ложь;
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		
		ОбщегоНазначенияУХ.СообщитьОбОшибке(Нстр("ru = 'Для обрабатываемого плана видов характеристик внешней информационной базы не указано наименование.'"),ЕстьОшибки,,СтатусСообщения.Внимание);
		
	КонецЕсли;
	
	Возврат НЕ ЕстьОшибки;
			
КонецФункции // ПроверитьНаименование()

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	Иначе	
		Отказ = НЕ ПроверитьНаименование();
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		
		СоздаватьПриНеудачномПоискеПриИмпорте=Ложь;
		ОбновлятьРеквизитыПриИмпорте=Ложь;
		
	КонецЕсли;
		
	
КонецПроцедуры

Функция Использование77() Экспорт
		
	Если Используется77 = Неопределено Тогда
		Используется77 = (Владелец.ВерсияПлатформы = Перечисления.ПлатформыВнешнихИнформационныхБаз.Предприятие77);	
	КонецЕсли;
	
	Возврат Используется77;
	
КонецФункции

Процедура ПриЗаписи(Отказ)
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры