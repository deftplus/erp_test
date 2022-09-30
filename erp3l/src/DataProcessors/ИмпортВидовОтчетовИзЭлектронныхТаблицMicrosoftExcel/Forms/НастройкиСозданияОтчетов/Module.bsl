
&НаКлиенте
Процедура ПрименитьИЗакрыть(Команда)
	
	Если НЕ ТипБД = ТипБД_ Тогда
		Оповестить(ИмяФормы, Новый Структура("ТипБД", ТипБД), ВладелецФормы);
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ТипБД) Тогда
		ТипБД = Справочники.ТипыБазДанных.ПолучитьСсылку(ПолучитьИзВременногоХранилища(Параметры.ТипБД)[0][0]);
		Если ТипБД.ПолучитьОбъект() = Неопределено Тогда
			ТипБД = Неопределено;
		КонецЕсли;
		ТипБД_ = ТипБД;
	КонецЕсли;
	
КонецПроцедуры
