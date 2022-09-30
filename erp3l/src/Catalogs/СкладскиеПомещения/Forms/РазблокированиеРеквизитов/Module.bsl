
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	РазрешитьРедактированиеВладелец                            = Истина;
	РазрешитьРедактированиеИспользоватьАдресноеХранение        = Истина;
	РазрешитьРедактированиеДатаНачалаАдресногоХраненияОстатков = Истина;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)

	Результат = Новый Массив;
	
	Если РазрешитьРедактированиеИспользоватьАдресноеХранение Тогда
		Результат.Добавить("НастройкаАдресногоХранения");
	КонецЕсли;

	Если РазрешитьРедактированиеВладелец Тогда
		Результат.Добавить("Владелец");
	КонецЕсли;
	
	Если РазрешитьРедактированиеДатаНачалаАдресногоХраненияОстатков Тогда
		Результат.Добавить("ДатаНачалаАдресногоХраненияОстатков");
	КонецЕсли;
	
	Закрыть(Результат);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
