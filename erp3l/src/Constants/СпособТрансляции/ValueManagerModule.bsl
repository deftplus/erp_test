
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Значение=Перечисления.СпособыТрансляции.ПоДокументамОбработка
		ИЛИ ЭтотОбъект.Значение=Перечисления.СпособыТрансляции.ПоДокументамФоновоеЗадание
		ИЛИ ЭтотОбъект.Значение=Перечисления.СпособыТрансляции.ПоДокументамПриПроведении Тогда
		
		Константы.ПодокументнаяТрансляция.Установить(Истина);
		
	Иначе
		
		Константы.ПодокументнаяТрансляция.Установить(Ложь);
		
	КонецЕсли;
		
КонецПроцедуры
