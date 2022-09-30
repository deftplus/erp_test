
#Область ПрограммныйИнтерфейс

// Обработчик дополнительного заполнения кассовой смены.
//
// Параметры:
//  КассоваяСменаОбъект  - ДокументОбъект.КассоваяСмена - Документ кассовая смена
//  СтандартнаяОбработка - Булево - Стандартная обработка
//
Процедура ОбработкаДополнительногоЗаполненияКассовойСмены(КассоваяСменаОбъект) Экспорт
	
	КассоваяСменаОбъект.КассаККМ = Справочники.КассыККМ.КассаККМПоПодключаемомуОборудованияДляРМК(КассоваяСменаОбъект.ФискальноеУстройство);
	
КонецПроцедуры

#КонецОбласти
