
#Область СлужебныйПрограммныйИнтерфейс

#Область РазборКодаМаркировки

Функция ЭлементКодаМаркировкиСоответствуетОписанию(Значение, ОписаниеЭлементаКМ, СоставКодаМаркировки, ПараметрыОписанияКодаМаркировки) Экспорт
	
	Если ОписаниеЭлементаКМ.Имя = "ШтрихкодАкцизнойМарки" Тогда
		
		ТипШтрихкода = Неопределено;
		Если Не ЭтоШтрихкодАкцизнойМарки(Значение, ТипШтрихкода, ПараметрыОписанияКодаМаркировки) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.PDF417") Тогда
			КодАлкогольнойПродукции = АкцизныеМаркиКлиентСервер.КодКлассификатораНоменклатурыЕГАИС(Значение);
			Если ЗначениеЗаполнено(КодАлкогольнойПродукции) Тогда
				РазборКодаМаркировкиИССлужебныйКлиентСервер.ЗаполнитьСоставКодаМаркировки(
					СоставКодаМаркировки, Новый Структура("Имя", "КодАлкогольнойПродукции"), КодАлкогольнойПродукции);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура ПреобразоватьЗначениеДляЗаполненияСоставаКодаМаркировки(ПараметрыОписанияКодаМаркировки, СоставКодаМаркировки, ОписаниеЭлементаКМ, Значение) Экспорт
	Возврат;
КонецПроцедуры

Функция ЭтоНеФормализованныйКодМаркировки(ПараметрыРазбораКодаМаркировки, Настройки, ДанныеРезультата, РезультатБезФильтра) Экспорт
	
	ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная");
	
	Если Настройки.ДоступныеВидыПродукции.Найти(ВидПродукции) = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ФильтрПоВидуПродукции = ПараметрыРазбораКодаМаркировки.ФильтрПоВидуПродукции;
	
	Если ФильтрПоВидуПродукции.Использовать
		И ФильтрПоВидуПродукции.ВидыПродукции.Найти(ВидПродукции) = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КлассификаторТиповАкцизныхМарок = Настройки.ДополнительныеПараметры.ЕГАИС.КлассификаторТиповАкцизныхМарок;
	
	ТекстОшибки = "";
	СтруктураШтрихкода = АкцизныеМаркиКлиентСервер.РазложитьШтрихкодСНомеромИСерией(ПараметрыРазбораКодаМаркировки.КодМаркировки, ТекстОшибки, КлассификаторТиповАкцизныхМарок);
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ВидыПродукции = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВидПродукции);
	
	ТипШтрихкодаИВидУпаковки = РазборКодаМаркировкиИССлужебныйКлиентСервер.ТипШтрихкодаИВидУпаковки();
	ТипШтрихкодаИВидУпаковки.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.DataMatrix");
	ТипШтрихкодаИВидУпаковки.ВидУпаковки  = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.АкцизнаяМаркаСНомеромИСерией");
	
	СоставКодаМаркировки = РазборКодаМаркировкиЕГАИССлужебныйКлиентСервер.НовыйСоставКодаМаркировки(ТипШтрихкодаИВидУпаковки);
	СоставКодаМаркировки.Вставить("ТипМарки",   СтруктураШтрихкода.ТипМарки);
	СоставКодаМаркировки.Вставить("СерияМарки", СтруктураШтрихкода.СерияМарки);
	СоставКодаМаркировки.Вставить("НомерМарки", СтруктураШтрихкода.НомерМарки);
	
	ДанныеРезультата = РазборКодаМаркировкиИССлужебныйКлиентСервер.НовыйРезультатРазбораКодаМаркировки(ПараметрыРазбораКодаМаркировки.ПользовательскиеПараметры.РасширеннаяДетализация);
	ДанныеРезультата.КодМаркировки        = ПараметрыРазбораКодаМаркировки.КодМаркировки;
	ДанныеРезультата.ТипШтрихкода         = ТипШтрихкодаИВидУпаковки.ТипШтрихкода;
	ДанныеРезультата.ВидУпаковки          = ТипШтрихкодаИВидУпаковки.ВидУпаковки;
	ДанныеРезультата.ВидыПродукции        = ВидыПродукции;
	ДанныеРезультата.СоставКодаМаркировки = СоставКодаМаркировки;
	
	Если ПараметрыРазбораКодаМаркировки.ПользовательскиеПараметры.РасширеннаяДетализация Тогда
		ДанныеРезультата.Детализация.НачинаетсяСоСкобки                = ПараметрыРазбораКодаМаркировки.НачинаетсяСоСкобки;
		ДанныеРезультата.Детализация.СодержитРазделительGS             = ПараметрыРазбораКодаМаркировки.СодержитРазделительGS;
		ДанныеРезультата.Детализация.ЭтоНеФормализованныйКодМаркировки = Истина;
	КонецЕсли;
	
	ДанныеРезультата.ВидыУпаковокПоВидамПродукции[ВидПродукции] =
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипШтрихкодаИВидУпаковки.ВидУпаковки);
	
	НормализованныйКодМаркировки = РазборКодаМаркировкиИССлужебныйКлиентСервер.НормализоватьКодМаркировки(
		ДанныеРезультата, ВидПродукции);
	
	ДанныеРезультата.НормализованныйКодМаркировки = НормализованныйКодМаркировки;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область НастройкиРазбораКодаМаркировки

Функция НовыйСоставКодаМаркировки(ТипШтрихкодаИВидУпаковки) Экспорт
	
	СоставКодаМаркировки = Новый Структура;
	
	Возврат СоставКодаМаркировки;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РазборКодаМаркировки

Функция ЭтоШтрихкодАкцизнойМарки(Штрихкод, ТипШтрихкода, ПараметрыОписанияКодаМаркировки)
	
	// Взято из ШтрихкодированиеЕГАИС.ЭтоШтрихкодАкцизнойМарки(Значение, ТипШтрихкода)
	
	ПроверкаШтрихкодаАкцизнойМарки = ПараметрыОписанияКодаМаркировки.ДополнительныеПараметры.ЕГАИС.ПроверкаШтрихкодаАкцизнойМарки;
	
	Если ПараметрыОписанияКодаМаркировки.МодульКонтекста.ЭтоСервер() Тогда
		
		Если ПроверкаШтрихкодаАкцизнойМарки.Свойство("ОбщийМодульЕГАИС") Тогда
			ОбщийМодульЕГАИС = ПроверкаШтрихкодаАкцизнойМарки.ОбщийМодульЕГАИС;
		Иначе
			ОбщийМодульЕГАИС = ПараметрыОписанияКодаМаркировки.МодульКонтекста.ОбщийМодуль("ШтрихкодированиеЕГАИС");
		КонецЕсли;
		
		Возврат ОбщийМодульЕГАИС.ЭтоШтрихкодАкцизнойМарки(Штрихкод, ТипШтрихкода);
		
	КонецЕсли;
	
	#Если НЕ ВебКлиент Тогда
	
	МодельXML           = ПроверкаШтрихкодаАкцизнойМарки.МодельXML;
	URIПространстваИмен = ПроверкаШтрихкодаАкцизнойМарки.URIПространстваИмен;
	ИмяТипа             = ПроверкаШтрихкодаАкцизнойМарки.ИмяТипа;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(МодельXML);
	
	ОбъектModel = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
	НоваяФабрикаXDTO = Новый ФабрикаXDTO(ОбъектModel);
	
	ТипШтрихкодМарки = НоваяФабрикаXDTO.Тип(URIПространстваИмен, ИмяТипа);
	
	Попытка
		ТипШтрихкодМарки.Проверить(Штрихкод);
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	#КонецЕсли
	
	Если СтрДлина(Штрихкод) = 150 Тогда
		ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.DataMatrix");
	Иначе 
		ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.PDF417");
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецОбласти