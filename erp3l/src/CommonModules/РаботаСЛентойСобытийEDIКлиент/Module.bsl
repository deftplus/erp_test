#Область СлужебныйПрограммныйИнтерфейс

#Область ОткрытиеФорм

Процедура ОткрытьФормуЛентыСобытий(ПараметрыОткрытияФормы = Неопределено, ФормаВладелец = Неопределено, ОписаниеОповещения = Неопределено) Экспорт
	
	Если ФормаВладелец = Неопределено Тогда
		РежимОткрытия = РежимОткрытияОкнаФормы.Независимый;
	Иначе
		РежимОткрытия = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Обработка.СервисEDI.Форма.ЛентаСобытий.Открыть");
	
	ОткрытьФорму("Обработка.СервисEDI.Форма.ЛентаСобытий", ПараметрыОткрытияФормы, ФормаВладелец, , , ,
		ОписаниеОповещения, РежимОткрытия);
	
КонецПроцедуры

#КонецОбласти

#Область ПараметрыОткрытияФорм

Функция НовыйПараметрыОткрытияФормыЛентыСобытий() Экспорт
	
	ПараметрыОткрытияФормы = Новый Структура;
	
	ПараметрыОткрытияФормы.Вставить("Период"             , Неопределено);
	ПараметрыОткрытияФормы.Вставить("Организация"        , Неопределено);
	ПараметрыОткрытияФормы.Вставить("КатегорияДокументов", ПредопределенноеЗначение("Перечисление.КатегорииДокументовEDI.ПустаяСсылка"));
	ПараметрыОткрытияФормы.Вставить("НаправлениеСобытий" , ПредопределенноеЗначение("Перечисление.НаправленияСобытийEDI.ПустаяСсылка"));
	ПараметрыОткрытияФормы.Вставить("Менеджер"           , Неопределено);
	
	Возврат ПараметрыОткрытияФормы;
	
КонецФункции

#КонецОбласти

#КонецОбласти