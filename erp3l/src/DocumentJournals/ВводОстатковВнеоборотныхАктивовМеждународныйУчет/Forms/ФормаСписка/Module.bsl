
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить("СправочникСсылка.НематериальныеАктивы", "ДокументСсылка.ВводОстатковНМАМеждународныйУчет");
	Соответствие.Вставить("СправочникСсылка.ОбъектыЭксплуатации", "ДокументСсылка.ВводОстатковОСМеждународныйУчет");
	СоответствиеТипов = Новый ФиксированноеСоответствие(Соответствие);
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Организация", ОтборОрганизация);
		СтруктураБыстрогоОтбора.Свойство("Подразделение", ОтборПодразделение);
		СтруктураБыстрогоОтбора.Свойство("ТипАктива", ОтборТипАктива);
		СтруктураБыстрогоОтбора.Свойство("Актив", ОтборАктив);
	КонецЕсли;
	
	Элементы.ОтборАктив.ТолькоПросмотр = Истина;
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Организация", ОтборОрганизация, ЗначениеЗаполнено(ОтборОрганизация));
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Подразделение", ОтборПодразделение, ЗначениеЗаполнено(ОтборПодразделение));
	Если ЗначениеЗаполнено(ОтборТипАктива) Тогда
		Элементы.ОтборАктив.ТолькоПросмотр = Ложь;
		Элементы.ОтборАктив.ОграничениеТипа = Новый ОписаниеТипов(ОтборТипАктива);
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Тип", Тип(СоответствиеТипов[ОтборТипАктива]), Истина);
	КонецЕсли;
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Актив", ОтборАктив, ЗначениеЗаполнено(ОтборАктив));
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Элементы.ОтборАктив.ТолькоПросмотр = Истина;
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Организация", ОтборОрганизация, ЗначениеЗаполнено(ОтборОрганизация));
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Подразделение", ОтборПодразделение, ЗначениеЗаполнено(ОтборПодразделение));
	Если ЗначениеЗаполнено(ОтборТипАктива) Тогда
		Элементы.ОтборАктив.ТолькоПросмотр = Ложь;
		Элементы.ОтборАктив.ОграничениеТипа = Новый ОписаниеТипов(ОтборТипАктива);
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Тип", Тип(СоответствиеТипов[ОтборТипАктива]), Истина);
	КонецЕсли;
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Актив", ОтборАктив, ЗначениеЗаполнено(ОтборАктив));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Организация", ОтборОрганизация, ЗначениеЗаполнено(ОтборОрганизация));
КонецПроцедуры

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Подразделение", ОтборПодразделение, ЗначениеЗаполнено(ОтборПодразделение));
КонецПроцедуры

&НаКлиенте
Процедура ОтборТипАктиваПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ОтборТипАктива) Тогда
		Элементы.ОтборАктив.ТолькоПросмотр = Ложь;
		Элементы.ОтборАктив.ОграничениеТипа = Новый ОписаниеТипов(ОтборТипАктива);
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Тип", Тип(СоответствиеТипов[ОтборТипАктива]), Истина);
	Иначе
		ОтборАктив = Неопределено;
		Элементы.ОтборАктив.ТолькоПросмотр = Истина;
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Тип", Неопределено, Ложь);
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Актив", Неопределено, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборАктивПриИзменении(Элемент)
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Актив", ОтборАктив, ЗначениеЗаполнено(ОтборАктив));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьОстаткиНМА(Команда)
	
	ОткрытьФорму("Документ.ВводОстатковНМАМеждународныйУчет.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", УстановленныйБыстрыйОтборСтруктурой()));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОстаткиОС(Команда)
	
	ОткрытьФорму("Документ.ВводОстатковОСМеждународныйУчет.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", УстановленныйБыстрыйОтборСтруктурой()));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

&НаКлиенте
Функция УстановленныйБыстрыйОтборСтруктурой()
	
	СтруктураПоОтбору = Новый Структура;
	Если ЗначениеЗаполнено(ОтборОрганизация) Тогда
		СтруктураПоОтбору.Вставить("Организация", ОтборОрганизация);
	КонецЕсли;
	Если ЗначениеЗаполнено(ОтборПодразделение) Тогда
		СтруктураПоОтбору.Вставить("Подразделение", ОтборПодразделение);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборАктив) Тогда
		СтруктураПоОтбору.Вставить("ОсновноеСредство", ОтборАктив);
		СтруктураПоОтбору.Вставить("НематериальныйАктив", ОтборАктив);
	КонецЕсли;
	
	Возврат СтруктураПоОтбору;
	
КонецФункции

#КонецОбласти





