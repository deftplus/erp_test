Перем Используется77; // Признак использования обращения к ВИБ на платформе 7.7
Перем ТекСоединениеВИБ Экспорт; // Текущее соединение с внешней информационной базой
Перем СправочникБД;
Перем ТекущаяИБ;
Перем мОписаниеТиповСтрока;
Перем мОписаниеТиповБулево;
Перем мОписаниеТиповТЗ;
Перем мОписаниеТиповСписокЗначений;

Процедура ЗаполнитьРеквизитыОбъекта(Кэш = Неопределено, ЕстьИзменения = Истина) Экспорт
	
	Если Не ПроверитьНаименование() Тогда	
		Возврат;	
	КонецЕсли;
	
	ТекущаяИБ = (Владелец = Справочники.ТипыБазДанных.ТекущаяИБ);
	
	Если НЕ ТекущаяИБ Тогда
		
		Если ТекСоединениеВИБ=Неопределено Тогда
			
			ТекСоединениеВИБ = ОбщегоНазначенияУХ.ПолучитьСоединениеСВИБПоУмолчанию(Владелец, 1);
			
			Если ТекСоединениеВИБ = Неопределено Тогда			
				Возврат;			
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ТекСоединениеВИБ=Обработки.РаботаСМетаданнымиУХ.Создать();
		
	КонецЕсли;
	
	СтруктураОписания = ОбщегоНазначенияУХ.ПолучитьСтруктуруОписанияПеречисленияБД(
		Наименование, ТекСоединениеВИБ, Использование77(), Кэш);
	
	Если СтруктураОписания.Свойство("ТекстОшибки") Тогда		
		ОбщегоНазначенияУХ.СообщитьОбОшибке(СтруктураОписания.ТекстОшибки,Истина,,СтатусСообщения.Внимание);
		Возврат;		
	КонецЕсли;
	
	ОбщегоНазначенияУХ.ЗаполнитьИзмененныеРеквизиты(ЭтотОбъект, СтруктураОписания, "Реквизиты", ЕстьИзменения);
	
	ТабНовыеРеквизиты = ЭтотОбъект.Реквизиты.ВыгрузитьКолонки();
	Для Каждого СтрРеквизит ИЗ СтруктураОписания.Реквизиты Цикл		
		НоваяСтрока = ТабНовыеРеквизиты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрРеквизит);
	КонецЦикла;
	
	ОбщегоНазначенияУХ.ЗагрузитьИзмененнуюТабЧасть(ЭтотОбъект.Реквизиты, ТабНовыеРеквизиты, ЕстьИзменения);
	
КонецПроцедуры // ЗаполнитьРеквизитыОбъекта()
	
Функция ПроверитьНаименование()
	
	ЕстьОшибки=Ложь;
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		
		ОбщегоНазначенияУХ.СообщитьОбОшибке(Нстр("ru = 'Для обрабатываемого перечисления информационной базы не указано наименование.'"),ЕстьОшибки,,СтатусСообщения.Внимание);
		
	КонецЕсли;
	
	Возврат НЕ ЕстьОшибки;
			
КонецФункции // ПроверитьНаименование()

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	Иначе	
		Отказ = НЕ ПроверитьНаименование();
	КонецЕсли;
		
КонецПроцедуры

Функция Использование77() Экспорт
		
	Если Используется77 = Неопределено Тогда
		Используется77 = (Владелец.ВерсияПлатформы = Перечисления.ПлатформыВнешнихИнформационныхБаз.Предприятие77);	
	КонецЕсли;
	
	Возврат Используется77;
	
КонецФункции