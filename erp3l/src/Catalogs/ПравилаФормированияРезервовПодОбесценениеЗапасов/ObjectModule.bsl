#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Ответственный = Пользователи.ТекущийПользователь();
	Владелец = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Владелец);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Ответственный = Пользователи.ТекущийПользователь();
	ВерсияНастроекОтбора = 0;
КонецПроцедуры

#КонецОбласти

#КонецЕсли