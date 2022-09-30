////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПолеСообщения = Параметры.ТекстПредупреждения;
	Заголовок     = Параметры.Заголовок;
	Параметры.Свойство("ГиперссылкаТекст", ПолеСсылка);
	Если НЕ Элементы.ПолеСообщения.МногострочныйРежим Тогда
		Элементы.ПолеСообщения.Высота = 1;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ГиперссылкаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если НЕ ЗначениеЗаполнено(ПолеСсылка) Тогда
		Возврат;
	КонецЕсли;
	Попытка
		ПерейтиПоНавигационнойСсылке(ПолеСсылка);
	Исключение
		ПоказатьПредупреждение(, НСтр("ru = 'Не удалось перейти по указанной ссылке!';
										|en = 'Не удалось перейти по указанной ссылке!'"));
	КонецПопытки; 
КонецПроцедуры
