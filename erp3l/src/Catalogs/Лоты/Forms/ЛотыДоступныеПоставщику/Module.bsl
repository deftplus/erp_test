
#Область ОбработкаОсновныхСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ ПользователиСлужебныйПовтИсп.ЭтоСеансВнешнегоПользователя() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	АккредитацияПоставщиковУХ.УстановитьРеквизитыФормыСпискаДляПоставщика(ЭтаФорма);
	Список.Параметры.УстановитьЗначениеПараметра("АнкетаПоставщика", АнкетаПоставщика);
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
	КонецЕсли;
КонецПроцедуры


#КонецОбласти


#Область ОбработкаСобытийЭлементовФормы


&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Элементы.Список.РежимВыбора;
КонецПроцедуры


#КонецОбласти
