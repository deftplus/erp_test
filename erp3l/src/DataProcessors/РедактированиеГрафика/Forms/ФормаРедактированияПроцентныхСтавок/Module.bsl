&НаСервере
Функция ПолучитьВозвращаемоеЗначение()
	Возврат ПоместитьВоВременноеХранилище(ПроцентныеСтавки.Выгрузить())
КонецФункции

&НаКлиенте
Процедура КомандаОК(Команда)
	Закрыть(ПолучитьВозвращаемоеЗначение());
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	ПроцентныеСтавки.Загрузить(Параметры.ИсходныеДанные.ПроцентныеСтавки.Выгрузить());
	ПлавающаяСтавка = (Параметры.ИсходныеДанные.ТипПроцентнойСтавки = Перечисления.ТипыСтавокДляРасчетаПериодическихОпераций.Плавающая);
	Если НЕ ПлавающаяСтавка Тогда
		
		Элементы.ПроцентныеСтавкиПлавающаяЧасть.Видимость = Ложь;
		Элементы.ПроцентныеСтавкиФиксированнаяЧасть.Видимость = Ложь;
		
	КонецЕсли;
	
	Если Не ПроцентныеСтавки.Количество() Тогда
		ПерваяСтавка = ПроцентныеСтавки.Добавить();
		Если ТипЗнч(Параметры.ИсходныеДанные.Ссылка) = Тип("ДокументСсылка.ВерсияГрафикаЦеннойБумаги") Тогда
			ПерваяСтавка.Дата = Параметры.ДополнительныеДанные.ДатаНачалаДействия;
		Иначе
			ПерваяСтавка.Дата = Параметры.ИсходныеДанные.ДатаНачалаДействия;
				
		КонецЕсли;
		
		ПерваяСтавка.ПроцентнаяСтавка = Параметры.ИсходныеДанные.ПроцентнаяСтавка;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПроцентныеСтавкиПлавающаяЧастьПриИзменении(Элемент)
	ПолучитьРезультирующуюСтавку(Элементы.ПроцентныеСтавки.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ПроцентныеСтавкиФиксированнаяЧастьПриИзменении(Элемент)
	ПолучитьРезультирующуюСтавку(Элементы.ПроцентныеСтавки.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ПроцентныеСтавкиПроцентнаяСтавкаПриИзменении(Элемент)
	
	СтрокаДанные = Элементы.ПроцентныеСтавки.ТекущиеДанные;
	СтрокаДанные.ПлавающаяЧасть = СтрокаДанные.ПроцентнаяСтавка - СтрокаДанные.ФиксированнаяЧасть;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПолучитьРезультирующуюСтавку(СтрокаДанные)
	СтрокаДанные.ПроцентнаяСтавка = СтрокаДанные.ФиксированнаяЧасть + СтрокаДанные.ПлавающаяЧасть;
КонецПроцедуры
