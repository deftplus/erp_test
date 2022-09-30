
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ПоказательОснования = Параметры.ПоказательОснования;
	
	ПозицияПериода = СтрНайти(СокрЛП(Параметры.ПоказательПериода),".");
	ПозицияГода = СтрНайти(Сред(СокрЛП(Параметры.ПоказательПериода), ПозицияПериода + 1), ".") + ПозицияПериода;

	ПериодичностьНалога = Лев(СокрЛП(Параметры.ПоказательПериода), ПозицияПериода - 1);
	СтрокаНомерПериода = Сред(СокрЛП(Параметры.ПоказательПериода), ПозицияПериода + 1, ПозицияГода - ПозицияПериода - 1);
	СтрокаГодПериода = Сред(СокрЛП(Параметры.ПоказательПериода), ПозицияГода + 1);
	
	Если СтрНайти("ТП, ЗД", ПоказательОснования) > 0 Тогда
		Если СтрДлина(ПериодичностьНалога) = 2
		   И СтрДлина(СтрокаНомерПериода) = 2 
		   И СтрДлина(СтрокаГодПериода) = 4
		   И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ПериодичностьНалога)
		   И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаНомерПериода)
		   И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаГодПериода) Тогда
			ДатаПоказателя = Дата(Число(СтрокаГодПериода), Число(СтрокаНомерПериода), Число(ПериодичностьНалога));
		КонецЕсли;
	КонецЕсли;
	
	НомерПериода = СтрокаНомерПериода;
	ГодПериода = СтрокаГодПериода;
	
	Если Параметры.ПоказательПериода = "0" Тогда
		ПериодичностьНалога = "0";
	ИначеЕсли СтрНайти("МС,КВ,ПЛ,ГД", ПериодичностьНалога) = 0 Тогда
		ПериодичностьНалога = "-";
	КонецЕсли;
	
	УправлениеЭлементамиФормы();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ПериодичностьНалога = "0"
		ИЛИ ПустаяСтрока(ПериодичностьНалога) Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("НомерПериода");
		МассивНепроверяемыхРеквизитов.Добавить("ГодПериода");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаПоказателя");
		
	ИначеЕсли СтрНайти("МС,КВ,ПЛ,ГД", ПериодичностьНалога) > 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаПоказателя");
	
		Если ПериодичностьНалога = "ГД" Тогда
			МассивНепроверяемыхРеквизитов.Добавить("НомерПериода");
		КонецЕсли;
	
	ИначеЕсли ПериодичностьНалога = "-" Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерПериода");
		МассивНепроверяемыхРеквизитов.Добавить("ГодПериода");
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодичностьНалогаПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если ПроверитьЗаполнение() Тогда
	
		Если ПериодичностьНалога = "-" Тогда
			ПоказательПериода = Строка(Формат(ДатаПоказателя,"ДЛФ=D"));
			
		ИначеЕсли ПериодичностьНалога = "0" Тогда
			ПоказательПериода = "0";
			
		Иначе
			ПоказательПериода = ПериодичностьНалога 
				+ "." 
				+ ?(СтрДлина(СокрЛП(НомерПериода)) = 1, "0" + НомерПериода, НомерПериода)
				+ "." 
				+ СтрЗаменить(Строка(ГодПериода), Символы.НПП, "");
				
		КонецЕсли;
		
		Закрыть(ПоказательПериода);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормы()

	Если Не ПустаяСтрока(ПериодичностьНалога)
	   И СтрНайти("МС,КВ,ПЛ,ГД", ПериодичностьНалога) > 0 Тогда
		
		ГодПериодаВидимость = Истина;
		ДатаПоказателяВидимость = Ложь;
		
		Если ПериодичностьНалога = "МС" Тогда
			Если НомерПериода < 1 ИЛИ НомерПериода > 12 Тогда
				НомерПериода = 1;
			КонецЕсли;
			Элементы.НомерПериода.МинимальноеЗначение = 1;
			Элементы.НомерПериода.МаксимальноеЗначение = 12;
			НомерПериодаВидимость = Истина;
			
		ИначеЕсли ПериодичностьНалога = "КВ" Тогда
			Если НомерПериода < 1 ИЛИ НомерПериода > 4 Тогда
				НомерПериода = 1;
			КонецЕсли;
			Элементы.НомерПериода.МинимальноеЗначение = 1;
			Элементы.НомерПериода.МаксимальноеЗначение = 4;
			НомерПериодаВидимость = Истина;
			
		ИначеЕсли ПериодичностьНалога = "ПЛ" Тогда
			Если НомерПериода < 1 ИЛИ НомерПериода > 2 Тогда
				НомерПериода = 1;
			КонецЕсли;
			Элементы.НомерПериода.МинимальноеЗначение = 1;
			Элементы.НомерПериода.МаксимальноеЗначение = 2;
			НомерПериодаВидимость = Истина;
			
		ИначеЕсли ПериодичностьНалога = "ГД" Тогда
			НомерПериода = 0;
			НомерПериодаВидимость = Ложь;
			
		КонецЕсли;
		
		Если ГодПериода = 0 Тогда
			ГодПериода = Год(ТекущаяДатаСеанса());
		КонецЕсли;
		
	ИначеЕсли ПериодичностьНалога = "-" Тогда
		НомерПериодаВидимость = Ложь;
		ГодПериодаВидимость = Ложь;
		ДатаПоказателяВидимость = Истина;
	Иначе
		НомерПериодаВидимость = Ложь;
		ГодПериодаВидимость = Ложь;
		ДатаПоказателяВидимость = Ложь;
	КонецЕсли;
	
	Если Элементы.НомерПериода.Видимость <> НомерПериодаВидимость Тогда
		Элементы.НомерПериода.Видимость = НомерПериодаВидимость;
	КонецЕсли;
	Если Элементы.ГодПериода.Видимость <> ГодПериодаВидимость Тогда
		Элементы.ГодПериода.Видимость = ГодПериодаВидимость;
	КонецЕсли;
	Если Элементы.ДатаПоказателя.Видимость <> ДатаПоказателяВидимость Тогда
		Элементы.ДатаПоказателя.Видимость = ДатаПоказателяВидимость;
	КонецЕсли;
	
КонецПроцедуры



#КонецОбласти

#КонецОбласти
