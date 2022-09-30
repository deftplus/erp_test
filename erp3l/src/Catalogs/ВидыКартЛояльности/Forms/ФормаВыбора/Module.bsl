
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	УстановитьНедоступныеОтборыИзПараметров(Параметры.Отбор);
	
КонецПроцедуры

#КонецОбласти
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Процедура устанавливает отборы, переданные в структуре. Отборы недоступны для изменения.
//
// Параметры:
//	СтруктураОтбора - Структура - Ключ: имя поля компоновки данных, Значение: значение отбора.
//
&НаСервере
Процедура УстановитьНедоступныеОтборыИзПараметров(СтруктураОтбора)
	
	Для Каждого ЭлементОтбора Из СтруктураОтбора Цикл
		
		Если ЭлементОтбора.Ключ = "КонтролироватьДатуОкончания" Тогда
			
			ГруппаИли = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
			    Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы, "ДатаОкончанияДействия",
			    ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			    ГруппаИли,
			    "ДатаОкончанияДействия", 
			    ТекущаяДатаСеанса(),
			    ВидСравненияКомпоновкиДанных.Больше);
			   
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			    ГруппаИли,
			    "ДатаОкончанияДействия", 
			    Дата(1, 1, 1),
			    ВидСравненияКомпоновкиДанных.Равно);
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
