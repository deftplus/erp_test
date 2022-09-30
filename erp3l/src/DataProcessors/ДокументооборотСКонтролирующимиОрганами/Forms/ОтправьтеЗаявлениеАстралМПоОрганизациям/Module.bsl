&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	Для каждого Строка Из Параметры.Организации Цикл
			
		НоваяСтрока = Организации.Добавить();
		НоваяСтрока.Организация = Строка.Организация;
		НоваяСтрока.Отпечаток   = Строка.Отпечаток;
		
		ЗаявлениеИСтатус = КонтекстЭДОСервер.ЗаявлениеИСтатусПоОтпечатку(Строка.Отпечаток);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЗаявлениеИСтатус);

	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если НЕ ТипЗнч(Источник) = Тип("ДокументСсылка.ЗаявлениеАбонентаСпецоператораСвязи") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоЗавершениеОтправки = 
		ИмяСобытия = "Завершение отправки" 
		ИЛИ ИмяСобытия = "Завершение отправки заявления";
		
	Если ЭтоЗавершениеОтправки Тогда
		
		Организация = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ЗначениеРеквизитаОбъекта(Источник, "Организация");
		ОбновитьСтатусЗаявленияПоОрганизации(Организация);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнформацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	КонтекстЭДОКлиент.ПоказатьПолноеПредупреждениеОбАстралМ(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТаблицыФормы

&НаКлиенте
Процедура ОрганизацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Организации.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		Если Поле.Имя = "ОрганизацииСтатус" Тогда
			
			КонтекстЭДОКлиент.ОткрытьЗаявлениеНаПереизданиеСертификатаАстралМ(ЭтотОбъект, ТекущиеДанные);
			
		Иначе
			
			ПоказатьЗначение(, ТекущиеДанные.Организация);
				
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отложить(Команда)
	
	КонтекстЭДОКлиент.ОтложитьПоказПредупрежденияАстралМ(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусЗаявленияПоОрганизации(Организация)
	
	Для каждого Строка Из Организации Цикл
		Если Строка.Организация = Организация Тогда
			
			ЗаявлениеИСтатус = КонтекстЭДОКлиент.ЗаявлениеИСтатусПоОтпечатку(Строка.Отпечаток);
			ЗаполнитьЗначенияСвойств(Строка, ЗаявлениеИСтатус);
			
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

