#Область СлужебныйПрограммныйИнтерфейс

// Возвращает список команд ЭДО для указанной формы.
//
// Параметры:
//  Форма - УправляемаяФорма, Строка - форма или полное имя формы, для которой необходимо получить список команд ЭДО;
//  НаправлениеЭД - ПеречислениеСсылка.НаправленияЭДО - направление документа, для которого выполняется команда;
//  ТолькоВМенюЕще - Булево - если Истина, то команда будет размещена только в меню Еще.
//
// Возвращаемое значение:
//  ТаблицаЗначений - описание см. ПодключаемыеКомандыЭДОСлужебный.СоздатьКоллекциюКомандЭДО.
//
Функция КомандыЭДОФормы(Форма, НаправлениеЭД, ТолькоВМенюЕще) Экспорт
	
	Возврат ПодключаемыеКомандыЭДОСлужебный.КомандыЭДОФормы(Форма, НаправлениеЭД, ТолькоВМенюЕще);
	
КонецФункции

#КонецОбласти