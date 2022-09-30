#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область Команды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	Возврат;
КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	Возврат;
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	Возврат;
КонецПроцедуры

// Возвращает структуру параметров, заданных в настройках открытия формы.
//
// Возвращаемое значение:
//  Структура
//
Функция ПолучитьНастройкиПользователя() Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	НастройкиОткрытияФормПриНачалеРаботыСистемы.Параметры КАК Параметры
		|ИЗ
		|	РегистрСведений.НастройкиОткрытияФормПриНачалеРаботыСистемы КАК НастройкиОткрытияФормПриНачалеРаботыСистемы
		|ГДЕ
		|	НастройкиОткрытияФормПриНачалеРаботыСистемы.Пользователь = &Пользователь
		|	И НастройкиОткрытияФормПриНачалеРаботыСистемы.ОткрываемаяФорма = &ОткрываемаяФорма");
	
	Запрос.УстановитьПараметр("ОткрываемаяФорма",
		Перечисления.ФормыОткрываемыеПриНачалеРаботыСистемы.РабочееМестоВыполнениеОпераций);
	
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		Возврат Результат.Параметры.Получить();
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
