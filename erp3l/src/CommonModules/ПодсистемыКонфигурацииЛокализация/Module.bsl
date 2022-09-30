
#Область ПрограммныйИнтерфейс

// Определяет список модулей библиотек и конфигурации, которые предоставляют
// основные сведения о себе: имя, версия, список обработчиков обновления
// а также зависимости от других библиотек.
//
// Состав обязательных процедур такого модуля см. в общем модуле ОбновлениеИнформационнойБазыБСП
// (область ПрограммныйИнтерфейс).
// При этом сам модуль Библиотеки стандартных подсистем ОбновлениеИнформационнойБазыБСП
// не требуется явно добавлять в массив МодулиПодсистем.
//
// Параметры:
//  МодулиПодсистем - Массив - имена серверных общих модулей библиотек и конфигурации.
//                             Например: "ОбновлениеИнформационнойБазыБРО" - библиотека,
//                                       "ОбновлениеИнформационнойБазыБП"  - конфигурация.
//                    
Процедура ПриДобавленииПодсистем(МодулиПодсистем) Экспорт
	
	//++ Локализация
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыБЭД");
	
	//++ НЕ ГОСИС
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыБИД");
	//-- НЕ ГОСИС
	
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыЕГАИС");
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыГИСМ");
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыВЕТИС");
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыИСМП");
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыГосИС");
	
	//++ НЕ ГОСИС
	//++ НЕ УТ
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыБРО");
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый");
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыЗарплатаКадрыРасширенный");
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыБП");
	//-- НЕ УТ
	//-- НЕ ГОСИС
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти