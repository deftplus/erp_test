#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область Команды

// Заполняет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  Массив - Список команд.
//
Функция ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании) Экспорт

	СписокКоманд = Новый Массив;
	
	Возврат СписокКоманд;
	
КонецФункции

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
