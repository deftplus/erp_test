#Область ОбработкаОсновныхСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	АккредитацияПоставщиковУХ.ПриСозданииНаСервереФормыВнешнегоПоставщика(ЭтаФорма, Отказ, "Список", "Ссылка", "Ссылка", Истина);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ДатаСреза = Параметры.ДатаСреза;
	Если НЕ ЗначениеЗаполнено(ДатаСреза) Тогда
		ДатаСреза = ТекущаяДатаСеанса();
		Элементы.ДатаСреза.ТолькоПросмотр = Ложь;
	КонецЕсли;
	УстановитьОтборПоДатеСреза();
	Организация = Параметры.Организация;
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Форму выбора аккредитованных поставщиков можно открыть только с указанием Организации.'");
		Сообщение.Сообщить();
		Возврат;
	КонеЦЕсли;
	
	УстановитьОтборПоОрганизации();
КонецПроцедуры


#КонецОбласти

#Область ОбработкаСобытийЭлементовФормы


&НаКлиенте
Процедура ДатаСрезаПриИзменении(Элемент)
	УстановитьОтборПоДатеСреза();
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыНаКлиенте


#КонецОбласти

#Область СлужебныеПроцедурыНаСервере


&НаСервере
Процедура УстановитьОтборПоДатеСреза()
	Список.Параметры.УстановитьЗначениеПараметра("ДатаСреза", ДатаСреза);
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоОрганизации()
	Список.Параметры.УстановитьЗначениеПараметра("Организация", Организация);
КонецПроцедуры


#КонецОбласти






