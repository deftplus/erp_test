
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// Варианты комплектации определяются только для товаров.
	ВладелецВариантов = Неопределено;
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец", ВладелецВариантов)
		И ЗначениеЗаполнено(ВладелецВариантов) Тогда

		ТипыНоменклатуры = Перечисления.ТипыНоменклатуры;
		ТипВладельца = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВладелецВариантов, "ТипНоменклатуры");
		Если ТипВладельца <> ТипыНоменклатуры.Товар
			И ТипВладельца <> ТипыНоменклатуры.МногооборотнаяТара Тогда
			АвтоЗаголовок = Ложь;
			Заголовок = НСтр("ru = 'Варианты комплектации используются только для товаров';
							|en = 'Kit configurations are used for goods only'");
			Элементы.Список.ТолькоПросмотр = Истина;
		КонецЕсли;
		
		Элементы.Владелец.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.Список.РежимВыбора = (Истина = Параметры.РежимВыбора);
	Элементы.Список.МножественныйВыбор = (Истина = Параметры.МножественныйВыбор);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, 
																   "ВладелецЕдиницаИзмерения", 
                                                                   "Список.Упаковка");

КонецПроцедуры

#КонецОбласти
