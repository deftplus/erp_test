#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Проверяет, наличие в массиве складских операций типа "Приемка".
//
// Параметры:
//	СкладскиеОперации - Массив - массив значений складских операций.
//
// Возвращаемое значение:
//	Булево - Истина, среди элементов массив есть складская операция типа "Примка".
//
Функция ЕстьПриемка(СкладскиеОперации) Экспорт
	
	Возврат СкладыКлиентСервер.ЕстьПриемка(СкладскиеОперации);
	
КонецФункции

// Возвращает массив значений складских операций типа "Приемка"
//
// Возвращаемое значение:
//	Массив - массив значений складских операций.
//
Функция СкладскиеОперацииПриемки() Экспорт
	
	Возврат СкладыКлиентСервер.СкладскиеОперацииПриемки();
	
КонецФункции

// Проверяет, наличие в массиве складских операций типа "Отгрузка".
//
// Параметры:
//	СкладскиеОперации - Массив - массив значений складских операций.
//
// Возвращаемое значение:
//	Булево - Истина, среди элементов массив есть складская операция типа "Отгрузка".
//
Функция ЕстьОтгрузка(СкладскиеОперации) Экспорт
	
	Возврат СкладыКлиентСервер.ЕстьОтгрузка(СкладскиеОперации);
	
КонецФункции

// Возвращает массив значений складских операций типа "Отгрузка"
//
// Возвращаемое значение:
//	Массив - массив значений складских операций.
//
Функция СкладскиеОперацииОтгрузки() Экспорт
	
	Возврат СкладыКлиентСервер.СкладскиеОперацииОтгрузки();

КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		МассивИсключаемыхЗначений = Новый Массив;
		МассивИсключаемыхЗначений.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ПриемкаПродукцииИзПроизводства"));
		
		ОбщегоНазначенияУТВызовСервера.ДоступныеДляВыбораЗначенияПеречисления(
			"СкладскиеОперации",
			ДанныеВыбора,
			Параметры,
			МассивИсключаемыхЗначений);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


