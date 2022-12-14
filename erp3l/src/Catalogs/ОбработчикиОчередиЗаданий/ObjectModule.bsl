#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Использование = Истина;
	Расписание = Новый ХранилищеЗначения(Справочники.ОбработчикиОчередиЗаданий.РасписаниеПоУмолчанию());
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Авто = Ложь;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьВозможностьИзменения();
	
	Проверка = Методы.Выгрузить(, "Метод");
	Проверка.Свернуть("Метод");
	Если Проверка.Количество() <> Методы.Количество() Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Обнаружены дубли методов';
													|en = 'Method duplicates are found'"), , "Методы", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьВозможностьИзменения();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьВозможностьИзменения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьВозможностьИзменения()
	
	Если Авто Тогда
		ВызватьИсключение НСтр("ru = 'Редактирование этой настройки выполняется только в Менеджере сервиса';
								|en = 'This setting is edited in the Service Manager only'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

