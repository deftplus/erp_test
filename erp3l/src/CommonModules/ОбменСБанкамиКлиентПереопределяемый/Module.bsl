////////////////////////////////////////////////////////////////////////////////
// ОбменСБанкамиКлиентПереопределяемый: механизм обмена электронными документами с банками.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму разбора банковской выписки.
//
// Параметры:
//   СообщениеОбмена - ДокументСсылка.СообщениеОбменСБанками - сообщение с выпиской банка.
//
Процедура РазобратьВыпискуБанка(СообщениеОбмена) Экспорт
	
	//++ НЕ ГОСИС
	ДенежныеСредстваВызовСервераЛокализация.РазобратьВыпискуБанка(СообщениеОбмена);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Событие возникает при формировании электронных документов.
// Если для какого-либо объекта невозможно формирование электронного документа,
// тогда нужно присвоить СтандартнаяОбработка = Ложь.
// (например, в ЗУП есть документ ВедомостьНаВыплатуЗарплатыВБанк,
// который может быть отправлен в банк только для вида "ПоЗарплатномуПроекту")
//   Затем можно реализовать следующие сценарии обработки данной ситуации
//    1. Вывести сообщение
//    2. Вывести подробную инструкцию в отдельном окне, в котором описан порядок обработки таких документов.
//    3. Запустить помощник, который позволит создать "правильные" документы для отправки в банк.
//   Итоговый массив (сокращенный и дополненный) вернуть через ОбработчикОповещения.
//
// Параметры:
//  ОбработчикОповещения - ОписаниеОповещения - Обработчик, который нужно вызвать, если СтандартнаяОбработка = Ложь;
//     * Результат - Массив - массив ссылок на объекты, для которых возможно формирование электронных документов.
//                            Может быть дополнен новыми документами.
//  МассивДокументов - Массив - Массив ссылок на документы, для которых пользователь собирается сформировать
//                              электронные документы для отправки в банк.
//  ПараметрыВыполненияКоманды - см. ПодключаемыеКомандыКлиент.ПараметрыВыполненияКоманды
//  СтандартнаяОбработка - Булево - необходимо присвоить Ложь, если в МассивДокументов есть документы,
//                                  для которых не формируются электронные документы.
//
Процедура ПриФормированииЭлектронныхДокументов(
	ОбработчикОповещения,
	МассивДокументов,
	ПараметрыВыполненияКоманды,
	СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#КонецОбласти