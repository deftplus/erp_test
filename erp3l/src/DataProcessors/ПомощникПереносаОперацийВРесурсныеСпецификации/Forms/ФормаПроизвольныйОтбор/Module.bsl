
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьМаршрутныеКарты") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ИнициализироватьКомпоновщикНастроек(Параметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект),
			НСтр("ru = 'Данные были изменены. Сохранить изменения?';
				|en = 'The data has changed. Do you want to save the changes?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	ЗавершитьРедактирование();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьКомпоновщикНастроек(Параметры)
	
	Схема      = Обработки.ПомощникПереносаОперацийВРесурсныеСпецификации.ПолучитьМакет("МакетКомпоновкиДляПроизвольныхОтборов");
	АдресСхемы = ПоместитьВоВременноеХранилище(Схема, УникальныйИдентификатор);
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	Если ЗначениеЗаполнено(Параметры.НастройкиКомпоновки) Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(Параметры.НастройкиКомпоновки);
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	КонецЕсли;
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование()
	
	Результат = ЗавершитьРедактированиеНаСервере();
	
	Если Результат <> Неопределено Тогда
		
		Модифицированность = Ложь;
		
		Закрыть(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗавершитьРедактированиеНаСервере()
	
	Возврат КомпоновщикНастроек.ПолучитьНастройки();
	
КонецФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗавершитьРедактирование();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти