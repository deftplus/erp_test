
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТиповыеОтчетыУХ.ДобавитьОтбор(СписокМероприятий.Отбор, "Контекст", Объект.Ссылка);
	Если Параметры.Ключ.Пустая() Тогда
		Элементы.СписокМероприятий.ТолькоПросмотр = Истина;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ТиповыеОтчетыУХ.ДобавитьОтбор(СписокМероприятий.Отбор, "Контекст", Объект.Ссылка);
	Элементы.СписокМероприятий.ТолькоПросмотр = Ложь;
	
КонецПроцедуры
