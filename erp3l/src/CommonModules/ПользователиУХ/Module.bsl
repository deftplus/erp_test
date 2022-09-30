
// Функция АвторизованныйПользователь возвращает
// текущего пользователя сеанса.
// 
// Возвращаемое значение:
//  СправочникСсылка.Пользователи, СправочникСсылка.ВнешниеПользователи.
// 
Функция АвторизованныйПользователь() Экспорт
	
	Возврат Пользователи.АвторизованныйПользователь();
	
КонецФункции

// Получить свободное имя пользователя ИБ, которое не использовано
// в именах пользователей ИБ связанных, либо со справочником Пользователи,
// либо со справочником ВнешниеПользователи.
//
// Параметры:
//  ПрефиксИмени - Строка - начало имени пользователя. К нему может
//		добавляться числовой индекс. Если найти свободное имя пользователя
//		в формате ПрефиксИмени[1-999] не удалось, то будет сгененрировано
//		строковое представление уникального идентификатора.
// 
// Возвращаемое значение:
//   Строка - имя пользователя ИБ, которое можно привязать к справочнику
//		Пользователи, или ВнешниеПользователи.
//
Функция ПолучитьСвободноеИмяПользователяИБ(ПрефиксИмени) Экспорт
	Имя = ПрефиксИмени;
	Номер = 1;
	Пока Номер < 1000 Цикл
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(Имя);
		Если ПользовательИБ = Неопределено Тогда
			Возврат Имя;
		КонецЕсли;
		
		Если НЕ Пользователи.ПользовательИБЗанят(ПользовательИБ) Тогда
			Возврат Имя;
		КонецЕсли;
		
		Имя = ПрефиксИмени + Номер;
		Номер = Номер + 1;
	КонецЦикла;
	
	Возврат Строка(Новый УникальныйИдентификатор);
КонецФункции
