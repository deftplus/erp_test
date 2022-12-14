
#Область ОбработкаСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗакрыватьПриВыборе = Ложь;
	ЗаполнитьРеквизитыФормыИзПараметров(Параметры);
	ОбновитьКоэффициентПересчетаВалюты();
	УстановитьОтборСписка();
КонецПроцедуры


#КонецОбласти


#Область ОбработкаСобытийЭлементовФормы


&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОповеститьОВыборе(Элементы.Список.ДанныеСтроки(ВыбраннаяСтрока));
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыНаСервере


&НаСервере
Процедура ЗаполнитьРеквизитыФормыИзПараметров(Параметры)
	ВалютаДокумента = Параметры.ВалютаДокумента;
	Если НЕ ЗначениеЗаполнено(ВалютаДокумента)
			И ЗначениеЗаполнено(Параметры.Договор) Тогда
		ВалютаДокумента = Параметры.Договор.ВалютаВзаиморасчетов;
	Иначе
		ВалютаДокумента = 
			Константы.ВалютаУчетаЦентрализованныхЗакупок.Получить();
	КонецЕсли;
	Если ЗначениеЗаполнено(Параметры.Дата) Тогда
		ДатаОтбор = Параметры.Дата;
	Иначе
		ДатаОтбор = ТекущаяДатаСеанса();
	КонецЕсли;
	Ссылка = Параметры.Ссылка;
	Договор = Параметры.Договор;
	МестоПоставки = Параметры.МестоПоставки;
КонецПроцедуры

&НаСервере
Процедура ОбновитьКоэффициентПересчетаВалюты()
	ОписаниеКоэффициента = 
		ЦентрализованныеЗакупкиУХ.ПолучитьКоэффициентПересчетаВалют(
		    Константы.ВалютаУчетаЦентрализованныхЗакупок.Получить(),
			ВалютаДокумента, 
			ДатаОтбор);
	Коэффициент = ОписаниеКоэффициента.Коэффициент;
	Кратность = ОписаниеКоэффициента.Кратность;
КонецПроцедуры
&НаСервере
Процедура УстановитьОтборСписка()
	Если ЗначениеЗаполнено(Параметры.Ссылка) Тогда
		МоментВремени = Ссылка.МоментВремени();
	Иначе
		МоментВремени = ДатаОтбор;
	КонецЕсли;
	Список.Параметры.УстановитьЗначениеПараметра(
			"Момент",
			Новый Граница(МоментВремени, ВидГраницы.Исключая));
	Список.Параметры.УстановитьЗначениеПараметра(
		"Договор", 	Договор);
	Список.Параметры.УстановитьЗначениеПараметра(
		"МестоПоставки", 
		МестоПоставки);
	Список.Параметры.УстановитьЗначениеПараметра(
		"КоэффициентПересчетаВалюты",
		Коэффициент);
	Список.Параметры.УстановитьЗначениеПараметра(
		"Кратность",
		Кратность);
	Элементы.Список.Обновить();
КонецПроцедуры

#КонецОбласти