
////////////////////////////////////////////////////////////////////////////////
// ОУП: Процедуры подсистемы оперативного учета производства
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ПооперационноеПланирование

// Выполняет обработку расшифровки интервала диаграммы Ганта, содержащего данные о параллельной
//  загрузке рабочего центра.
//
// Параметры:
//  Владелец			 - ФормаКлиентскогоПриложения	 - форма, в которой выполнена расшифровка.
//  ПараметрыФормы		 - Структура		 - параметры выбранного интервала.
//  СтандартнаяОбработка - Булево			 - флаг стандартной обработки расшифровки.
//
Процедура ОбработкаРасшифровкиИнтервалаСПараллельнойЗагрузкой(Знач Владелец, Знач ПараметрыФормы, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму(
		"Отчет.ДиаграммаПооперационногоРасписания2_2.Форма.РасшифровкаПараллельнойЗагрузки",
		ПараметрыФормы,
		Владелец,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Определяет имя события, которое используется для оповещения об изменении пооперационного расписания.
//
// Возвращаемое значение:
//  Строка - имя события.
//
Функция ИмяСобытияИзменениеПооперационногоРасписания() Экспорт
	
	Возврат "РасчетПооперационногоРасписанияПроизводства";
	
КонецФункции

#КонецОбласти

#КонецОбласти
