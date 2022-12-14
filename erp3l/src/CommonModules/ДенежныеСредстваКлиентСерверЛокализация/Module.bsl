
#Область ПрограммныйИнтерфейс

// Проверка корректности банковского счета
//
// Параметры:
//  Номер        - Строка - Номер банковского счета.
//  ВалютныйСчет - Булево - Признак, является ли счет валютным.
//  ТекстОшибки  - Строка - Текст сообщения о найденных ошибках.
//
// Возвращаемое значение:
//  Булево - Истина - контрольный ключ верен, Ложь - контрольный ключ не верен.
//
Функция ПроверитьКорректностьНомераСчета(Знач Номер, ВалютныйСчет = Ложь, ТекстОшибки = "") Экспорт
	
	Результат = Истина;
	
	//++ Локализация
	Номер = СокрЛП(Номер);
	Если ПустаяСтрока(Номер) Тогда
		Возврат Результат;
	КонецЕсли;
	
	ТекстОшибки = "";
	ДлинаНомера = СтрДлина(Номер);
	Если Не ВалютныйСчет И Не (ДлинаНомера = 20 Или ДлинаНомера = 11) Тогда
		ТекстОшибки = ТекстОшибки + ?(ПустаяСтрока(ТекстОшибки), "", " ")
			+ СтрШаблон(НСтр("ru = 'Номер счета должен состоять из 20 или 11 разрядов. Введено %1 разрядов';
							|en = 'Account number should contain 20 or 11 digits. %1 digit is entered'"), ДлинаНомера);
		Результат = Ложь;
	ИначеЕсли ДлинаНомера = 20 И Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Номер) Тогда
		ТекстОшибки = ТекстОшибки + ?(ПустаяСтрока(ТекстОшибки), "", " ")
			+ НСтр("ru = 'В номере банковского счета присутствуют не только цифры.
				|Возможно, номер указан неверно.';
				|en = 'Bank account number contains not only digits.
				|The number may be invalid.'");
		Результат = Ложь;
	КонецЕсли;
	//-- Локализация
	
	Возврат Результат;
	
КонецФункции

// Проверяет, что переданный номер счета является казначейским.
//
// Параметры:
//  НомерСчета - Строка
//  
// Возвращаемое значение:
//  Булево
//
Функция ЭтоКазначейскийСчет(НомерСчета) Экспорт
	
	Результат = Ложь;
	
	//++ Локализация
	НачинаетсяНаНоль = СтрНачинаетсяС(НомерСчета, "0");
	
	КодВалютыРубль = Сред(НомерСчета, 6,3) = "643";
	
	ДлинаНомераСчетаВерна = СтрДлина(НомерСчета) = 20;
	
	Результат = НачинаетсяНаНоль И ДлинаНомераСчетаВерна И КодВалютыРубль;
	//-- Локализация
	
	Возврат Результат;
	
КонецФункции

// Проверяет, что переданный БИК является кодом Территориального органа Федерального казначейства.
//
// Параметры:
//  КодБанка - Строка
//  
// Возвращаемое значение:
//  Булево
//
Функция ЭтоБИКТОФК(КодБанка) Экспорт
	
	Результат = Ложь;
	
	//++ Локализация
	ПервыеЦифрыБИК = Лев(КодБанка, 2);
	
	Результат = СтрДлина(СокрЛП(КодБанка)) = 9
		И (ПервыеЦифрыБИК = "00" Или ПервыеЦифрыБИК = "01" Или ПервыеЦифрыБИК = "02");
	//-- Локализация
	
	Возврат Результат;
	
КонецФункции

// Проверяет, что переданный номер счета является единым казначейским счетом.
//
// Параметры:
//  НомерСчета - Строка
//  
// Возвращаемое значение:
//  Булево
///
Функция ЭтоЕдиныйКазначейскийСчет(НомерСчета) Экспорт
	
	Результат = Ложь;
	
	//++ Локализация
	Результат = Лев(НомерСчета, 5) = "40102";
	//-- Локализация
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
