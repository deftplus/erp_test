///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ПодключениеСервисовСопровожденияГлобальный.
//
// Глобальные процедуры и функции подключения тестовых периодов.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Проверка обработки запросов на подключение тестовых периодов.
//
Процедура ПодключениеТестовыхПериодов_ПроверитьСостояниеЗапроса() Экспорт
	
	ПодключениеСервисовСопровожденияКлиент.ПроверитьСостояниеЗапроса();
	
КонецПроцедуры

#КонецОбласти
