
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ОтборПериодСценария) Тогда
		
		СписокСценариев=УправлениеОтчетамиУХ.ПолучитьСписокПериодовСценариев(,Параметры.ОтборПериодСценария);
		ОтборыСписковКлиентСерверУХ.ИзменитьЭлементОтбораСписка(Список, "Ссылка", СписокСценариев, Истина,ВидСравненияКомпоновкиДанных.ВСписке);
		
		Элементы.Список.Отображение=ОтображениеТаблицы.Список;
		
	КонецЕсли;
	
	//
	УправлениеФормойУХ.УстановитьПредставлениеОтбора(ЭтотОбъект, , Метаданные.Справочники.СтатьиДвиженияДенежныхСредств);
	
КонецПроцедуры
