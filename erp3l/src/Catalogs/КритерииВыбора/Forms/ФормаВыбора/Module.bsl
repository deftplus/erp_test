// Выставляет отбор по имени типа объекта на форме.
&НаКлиенте
Процедура УстановитьОтборПоИмениТипаОбъекта()
	Если ЗначениеЗаполнено(ОтборИмяТипаОбъекта) Тогда
		ОбщегоНазначенияКлиентСерверУХ.УстановитьЭлементОтбора(Список.Отбор, "ИмяТипаОбъекта", ОтборИмяТипаОбъекта, ВидСравненияКомпоновкиДанных.Равно, , Истина);
	Иначе	
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ИмяТипаОбъекта");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОтборИмяТипаОбъекта = Параметры.ИмяТипаОбъекта;
	Если Параметры.ЗапретитьИзмененияТипаОбъекта Тогда
		Элементы.ОтборИмяТипаОбъекта.ТолькоПросмотр = Истина;
	Иначе
		// Не блокируем реквизит.
	КонецЕсли;
	ВыборОбъектовУХ.ЗаполнитьСписокВыбораИмяТипаОбъекта(Элементы.ОтборИмяТипаОбъекта.СписокВыбора);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьОтборПоИмениТипаОбъекта();
КонецПроцедуры

&НаКлиенте
Процедура ОтборИмяТипаОбъектаПриИзменении(Элемент)
	УстановитьОтборПоИмениТипаОбъекта();
КонецПроцедуры

&НаКлиенте
Процедура ОтборИмяТипаОбъектаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОтборИмяТипаОбъекта = ВыбранноеЗначение;
КонецПроцедуры

&НаКлиенте
Процедура ОтборИмяТипаОбъектаОчистка(Элемент, СтандартнаяОбработка)
	ОтборИмяТипаОбъекта = "";
КонецПроцедуры
