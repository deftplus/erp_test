
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	Если Владелец.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнено поле <Организация>", Ссылка, , , Отказ);
	КонецЕсли;

КонецПроцедуры

#КонецЕсли


