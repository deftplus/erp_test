
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.ОтобратьПериметрыСверки Тогда
		ОтборыСписковКлиентСерверУХ.ИзменитьЭлементОтбораСписка(Список, "ВерсияОрганизационнойСтруктуры.ШаблонСверкиВГО", Неопределено, Истина, ВидСравненияКомпоновкиДанных.Заполнено);
	КонецЕсли;
КонецПроцедуры
