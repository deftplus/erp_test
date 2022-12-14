////////////////////////////////////////////////////////////////////////////////
// Модуль содержит клиент-серверные методы бизнес-логики валютного контроля
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

// Функция возвращает сумму импортного контракта, по превышении которой требуется постановка его на учет
// согласно инструкции 181-И.
//
// Параметры:
//  Дата - 	Дата - Дата, на которую необходимо определение суммы.
// 
// Возвращаемое значение:
//  Число - Величина рублевого эквивалента суммы контракта.
//
Функция СуммаДляПостановкиНаУчетИмпортногоКонтракта(Дата = Неопределено) Экспорт
	// Согласно действующей инструкции, 3 млн. руб.
	Возврат 3000000;
	
КонецФункции

// Функция возвращает сумму экспортного контракта, по превышении которой требуется постановка его на учет
// согласно инструкции 181-И
//
// Параметры:
//  Дата - 	Дата - Дата, на которую необходимо определение суммы.
// 
// Возвращаемое значение:
//  Число - Величина рублевого эквивалента суммы контракта.
//
Функция СуммаДляПостановкиНаУчетЭкспортногоКонтракта(Дата = Неопределено) Экспорт
	// Согласно действующей инструкции, 6 млн. руб.
	Возврат 6000000;
	
КонецФункции

Функция ДатаВступленияВСилуИнструкции181И() Экспорт
	
	Возврат Дата(2018,03,01);
	
КонецФункции

Функция СуммаДляПостановкиНаУчетПоВидуДоговора(ВидДоговораУХ, Дата = Неопределено) Экспорт
	
	Если УправлениеДоговорамиУХКлиентСерверПовтИсп.ЭтоДоговорСПокупателем(ВидДоговораУХ)
		ИЛИ ВидДоговораУХ = ПредопределенноеЗначение("Справочник.ВидыДоговоровКонтрагентовУХ.РазмещениеСредств") Тогда
		
		Возврат СуммаДляПостановкиНаУчетЭкспортногоКонтракта(Дата);
	Иначе
		Возврат СуммаДляПостановкиНаУчетИмпортногоКонтракта(Дата);
		
	КонецЕсли;
	
КонецФункции


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
