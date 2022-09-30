
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

#Область ПредставлениеВерсии

Функция СформироватьПредставлениеВерсии(ПараметрыВыполнения) Экспорт
	
	Если ПараметрыВыполнения.ТипДокумента = Перечисления.ТипыДокументовEDI.ЗаказПоставщику Тогда
		
		ПараметрыПолученияПечатнойФормы = ИнтеграцияССервисомEDIСлужебный.НовыйПараметрыПолученияПечатнойФормыЗаказаПоставщику();
		
		ПараметрыПолученияПечатнойФормы.Организация            = ПараметрыВыполнения.Организация;
		ПараметрыПолученияПечатнойФормы.ИдентификаторВСервисе  = ПараметрыВыполнения.Документ;
		ПараметрыПолученияПечатнойФормы.ИдентификаторВерсии    = ПараметрыВыполнения.Версия;
		
		ОтветСервиса = ИнтеграцияССервисомEDIСлужебный.ПечатнаяФормаЗаказаПоставщику(ПараметрыПолученияПечатнойФормы);
		
	ИначеЕсли ПараметрыВыполнения.ТипДокумента = Перечисления.ТипыДокументовEDI.ЗаказКлиента Тогда
		
		ПараметрыПолученияПечатнойФормы = ИнтеграцияССервисомEDIСлужебный.НовыйПараметрыПолученияПечатнойФормыЗаказаКлиента();
		
		ПараметрыПолученияПечатнойФормы.Организация            = ПараметрыВыполнения.Организация;
		ПараметрыПолученияПечатнойФормы.ИдентификаторВСервисе  = ПараметрыВыполнения.Документ;
		ПараметрыПолученияПечатнойФормы.ИдентификаторВерсии    = ПараметрыВыполнения.Версия;
		
		ОтветСервиса = ИнтеграцияССервисомEDIСлужебный.ПечатнаяФормаЗаказаКлиента(ПараметрыПолученияПечатнойФормы);
		
	КонецЕсли;
	
	Если ОтветСервиса.Ошибка Тогда
		ВызватьИсключение(ОтветСервиса.ТекстОшибки);
	КонецЕсли;
	
	Возврат ОтветСервиса.Данные;
	
КонецФункции

#КонецОбласти

#Область СравнениеВерсий

Функция СформироватьСравнениеВерсий(ПараметрыВыполнения) Экспорт
	
	Если ПараметрыВыполнения.ТипДокумента = Перечисления.ТипыДокументовEDI.ЗаказПоставщику Тогда
		
		ПараметрыПолученияПечатнойФормы = ИнтеграцияССервисомEDIСлужебный.НовыйПараметрыСравненияВерсийЗаказаПоставщику();
		
		ПараметрыПолученияПечатнойФормы.Организация            = ПараметрыВыполнения.Организация;
		ПараметрыПолученияПечатнойФормы.ИдентификаторВСервисе  = ПараметрыВыполнения.Документ;
		ПараметрыПолученияПечатнойФормы.ИдентификаторВерсии1   = ПараметрыВыполнения.Версия;
		ПараметрыПолученияПечатнойФормы.ИдентификаторВерсии2   = ПараметрыВыполнения.ВерсияДляСравнения;
		
		ОтветСервиса = ИнтеграцияССервисомEDIСлужебный.ПечатнаяФормаСравненияВерсийЗаказаПоставщику(ПараметрыПолученияПечатнойФормы);
		
	ИначеЕсли ПараметрыВыполнения.ТипДокумента = Перечисления.ТипыДокументовEDI.ЗаказКлиента Тогда
		
		ПараметрыПолученияПечатнойФормы = ИнтеграцияССервисомEDIСлужебный.НовыйПараметрыСравненияВерсийЗаказаКлиента();
		
		ПараметрыПолученияПечатнойФормы.Организация            = ПараметрыВыполнения.Организация;
		ПараметрыПолученияПечатнойФормы.ИдентификаторВСервисе  = ПараметрыВыполнения.Документ;
		ПараметрыПолученияПечатнойФормы.ИдентификаторВерсии1   = ПараметрыВыполнения.Версия;      
		ПараметрыПолученияПечатнойФормы.ИдентификаторВерсии2   = ПараметрыВыполнения.ВерсияДляСравнения;
		
		ОтветСервиса = ИнтеграцияССервисомEDIСлужебный.ПечатнаяФормаСравненияВерсийЗаказаКлиента(ПараметрыПолученияПечатнойФормы);
		
	КонецЕсли;
	
	Если ОтветСервиса.Ошибка Тогда
		ВызватьИсключение(ОтветСервиса.ТекстОшибки);
	КонецЕсли;
	
	Возврат ОтветСервиса.Данные;
	
КонецФункции

#КонецОбласти

#Область СписокВерсий

Функция СформироватьСписокВерсий(ПараметрыФормирования) Экспорт 
	
	ДанныеВерсий = РаботаСВерсиямиEDIСервер.ПолучитьВерсииДокумента(ПараметрыФормирования.Организация,
		ПараметрыФормирования.ТипДокумента, ПараметрыФормирования.Документ);
	
	ДанныеОтвета = Новый Структура;
	ДанныеОтвета.Вставить("ДанныеВерсий"       , ДанныеВерсий);
	
	Если ПараметрыФормирования.ТипДокумента = Перечисления.ТипыДокументовEDI.ЗаказПоставщику Тогда
		
		ПараметрыКоманды = ИнтеграцияССервисомEDIСлужебный.НовыйПараметрыПолученияСтатусаЗаказаПоставщику();
		
		ПараметрыКоманды.Организация            = ПараметрыФормирования.Организация;
		ПараметрыКоманды.ИдентификаторВСервисе  = ПараметрыФормирования.Документ;
		
		СтатусЗаказа = ИнтеграцияССервисомEDIСлужебный.СтатусЗаказаПоставщику(ПараметрыКоманды);
		
		Если Не СтатусЗаказа.Ошибка Тогда
			АктуальнаяВерсия               = СтатусЗаказа.Данные.СогласованнаяВерсияПокупателя;
			ПрисланнаяНаСогласованиеВерсия = СтатусЗаказа.Данные.СогласованнаяВерсияПоставщика;
			ДействиеОтменитьЗаказ          = ПолучитьДоступноеДействие(СтатусЗаказа, 
				Перечисления.КомандыПроцессаЗаказаEDI.ОтменитьЗаказПоставщику);
			ДействиеСогласоватьЗаказ       = ПолучитьДоступноеДействие(СтатусЗаказа, 
				Перечисления.КомандыПроцессаЗаказаEDI.СогласоватьВерсиюПоставщика);
		КонецЕсли;
		
	ИначеЕсли ПараметрыФормирования.ТипДокумента = Перечисления.ТипыДокументовEDI.ЗаказКлиента Тогда
		
		ПараметрыКоманды = ИнтеграцияССервисомEDIСлужебный.НовыйПараметрыПолученияСтатусаЗаказаКлиента();
		
		ПараметрыКоманды.Организация            = ПараметрыФормирования.Организация;
		ПараметрыКоманды.ИдентификаторВСервисе  = ПараметрыФормирования.Документ;
		
		СтатусЗаказа = ИнтеграцияССервисомEDIСлужебный.СтатусЗаказаКлиента(ПараметрыКоманды);
		
		Если Не СтатусЗаказа.Ошибка Тогда
			АктуальнаяВерсия               = СтатусЗаказа.Данные.СогласованнаяВерсияПокупателя;
			ПрисланнаяНаСогласованиеВерсия = СтатусЗаказа.Данные.СогласованнаяВерсияПоставщика;
			ДействиеОтменитьЗаказ          = ПолучитьДоступноеДействие(СтатусЗаказа, 
				Перечисления.КомандыПроцессаЗаказаEDI.ОтменитьЗаказКлиента);
			ДействиеСогласоватьЗаказ       = ПолучитьДоступноеДействие(СтатусЗаказа, 
				Перечисления.КомандыПроцессаЗаказаEDI.СогласоватьВерсиюПокупателя);
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеОтвета.Вставить("АктуальнаяВерсия"                 , АктуальнаяВерсия);
	ДанныеОтвета.Вставить("ПрисланнаяНаСогласованиеВерсия"   , ПрисланнаяНаСогласованиеВерсия);
	ДанныеОтвета.Вставить("ДействиеОтменитьЗаказ"            , ДействиеОтменитьЗаказ);
	ДанныеОтвета.Вставить("ДействиеСогласоватьЗаказ"         , ДействиеСогласоватьЗаказ);
	
	Возврат ДанныеОтвета;
	
КонецФункции

#КонецОбласти

#Область ПолучениеВерсийДокумента

Процедура ПолучитьВерсииДокумента(ПараметрыВыполнения, АдресРезультата) Экспорт
	
	ТаблицаВерсийДокумента = РаботаСВерсиямиEDIСервер.ПолучитьВерсииДокумента(ПараметрыВыполнения.Организация, 
		ПараметрыВыполнения.ТипДокумента, ПараметрыВыполнения.Документ);
	
	ПоместитьВоВременноеХранилище(ТаблицаВерсийДокумента, АдресРезультата)
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДоступноеДействие(СтатусЗаказа, Действие)
	
	ДанныеКоманды = СтатусЗаказа.Данные.Команды[Действие];
	
	Если ДанныеКоманды = Неопределено Тогда
		Возврат Перечисления.КомандыПроцессаЗаказаEDI.ПустаяСсылка();
	Иначе
		Возврат Действие;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли
