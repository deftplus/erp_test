#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет команду создания объекта.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  Неопределено, СтрокаТаблицыЗначений - Добавить команду создать на основании
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Обработки.СправочноеРазмещениеНоменклатуры) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Обработчик = "СозданиеНаОснованииУТКлиент.ОпределитьСправочноеРазмещениеПоЯчейкам";
		КомандаСоздатьНаОсновании.Идентификатор = "ОпределитьСправочноеРазмещениеПоЯчейкам";
		КомандаСоздатьНаОсновании.Представление = НСтр("ru = 'Размещение номенклатуры по ячейкам (справочно)';
														|en = 'Put-away — Dummy bins'");
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьАдресноеХранениеСправочно";
		
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецЕсли