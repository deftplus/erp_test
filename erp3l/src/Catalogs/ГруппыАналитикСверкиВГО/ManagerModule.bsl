#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция ЭтоДопАналитикаСверки(ТипДляЭлиминации) Экспорт
	Если ТипДляЭлиминации = Перечисления.ТипыАналитикЭлиминации.Организация
		ИЛИ ТипДляЭлиминации = Перечисления.ТипыАналитикЭлиминации.Контрагент
		ИЛИ ТипДляЭлиминации = Перечисления.ТипыАналитикЭлиминации.ВалютаВзаиморасчетов Тогда
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции

Функция ПолучитьОписаниеАналитики(ГруппаАналитикВГО, ТипДляЭлиминации) Экспорт
	АналитикиВГО = ГруппаАналитикВГО.Аналитики;
	Возврат АналитикиВГО.Найти(ТипДляЭлиминации, "ТипДляЭлиминации");
КонецФункции


#КонецЕсли