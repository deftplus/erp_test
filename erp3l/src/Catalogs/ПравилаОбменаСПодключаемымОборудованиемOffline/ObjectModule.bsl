#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ТипПодключаемогоОборудования = Перечисления.ТипыПодключаемогоОборудования.ККМОфлайн Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЕдиницаИзмеренияВеса");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить(
		"ЗарегистрироватьИзменения",
		НЕ ЭтоНовый()
		И (ЕдиницаИзмеренияВеса <> Ссылка.ЕдиницаИзмеренияВеса));
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.ЗарегистрироватьИзменения Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы,
		|	ПодключаемоеОборудование.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|ГДЕ
		|	ПодключаемоеОборудование.ПравилоОбмена = &ПравилоОбмена
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|");
		
		Запрос.УстановитьПараметр("ПравилоОбмена", Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Метаданные.РегистрыСведений.КодыТоваровПодключаемогоОборудованияOffline);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Склад = ЗначениеНастроекПовтИсп.ПолучитьРозничныйСкладПоУмолчанию(Склад);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
