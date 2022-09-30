////////////////////////////////////////////////////////////////////////////////
// Общий модуль ИнтеграцияТорговыеПредложенияКлиент
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область РегистрацияОрганизаций

Функция ОрганизацияНеПодключенаТрубуетсяПовторноеПодключение(Организация) Экспорт
	Возврат БизнесСетьКлиент.ОрганизацияНеПодключенаТрубуетсяПовторноеПодключение(Организация);
КонецФункции

Процедура ОткрытьФормуПодключенияОрганизации(
	Организация, Владелец = Неопределено, ОписаниеОповещенияОЗакрытии = Неопределено) Экспорт
	БизнесСетьКлиент.ОткрытьФормуПодключенияОрганизации(Организация, Владелец, ОписаниеОповещенияОЗакрытии);
КонецПроцедуры

Процедура ОткрытьФормуПодключенияОрганизацииСПроверкойПодключения(
	Организация, Владелец = Неопределено, ОписаниеОповещенияОЗакрытии = Неопределено, Результат = Ложь) Экспорт
	
	БизнесСетьКлиент.ОткрытьФормуПодключенияОрганизацииСПроверкойПодключения(
		Организация, Владелец, ОписаниеОповещенияОЗакрытии, Результат);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
