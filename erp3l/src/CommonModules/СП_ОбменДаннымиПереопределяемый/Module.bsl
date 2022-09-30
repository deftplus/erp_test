
#Область ПрограммныйИнтерфейс

// Заполнить загружаемый объект.
// 
// Параметры:
//  ЗагружаемыйОбъект - Объект - загружаемый объект
//  СтруктураОбъекта - Структура - структура загружаемого объекта
//  СписокСвойств - Строка - список обрабатываемых свойств
//  ИсключаяСвойства - Строка - список исключаемых свойств
//
Процедура ЗаполнитьЗагружаемыйОбъект(ЗагружаемыйОбъект, 
	Знач СтруктураОбъекта, СписокСвойств = Неопределено, ИсключаяСвойства = Неопределено) Экспорт
	
	// Процедура заполнения по-умолчанию.
	СП_ОбменДанными.ЗаполнитьЗагружаемыйОбъект(ЗагружаемыйОбъект, СтруктураОбъекта, СписокСвойств, ИсключаяСвойства);
		
КонецПроцедуры

// Определить полное имя объекта метаданных.
// 
// Параметры:
//  ДанныеОбъекта - Структура - данные загружаемого объекта.
// 
// Возвращаемое значение:
// 	Строка - имя объекта метаданных. 
//  
Функция ОпределитьПолноеИмяОбъектаМетаданных(ДанныеОбъекта) Экспорт
	
	// Результат по-умолчанию.
	Возврат ДанныеОбъекта.ПолноеИмя;
	
КонецФункции

// Проверяет выгружаемый объект на соответствие сложному отбору.
// 
// Параметры:
//  Источник - ЛюбаяСсылка - источник регистрации события.
//  ИмяТопика - Строка - имя топика для отправки выгружаемого объекта.
//  СоответствуетОтборуСКД - Булево - признак соответствия отбору СКД.
// 
// Возвращаемое значение:
//  Булево - флаг соответствия программному отбору. По умолчанию равен переменной СоответствуетОтборуСКД.
//
Функция ВыгружаемыйОбъектСоответствуетОтбору(Источник, ИмяТопика, СоответствуетОтборуСКД) Экспорт
	
	Возврат СоответствуетОтборуСКД;
	
КонецФункции

#КонецОбласти
