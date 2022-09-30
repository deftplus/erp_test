
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не Параметры.ОткрыватьСобственнуюФорму Тогда
		
		Отказ = Истина;
		
		Если НЕ Параметры.Ключ.Пустая() Тогда
			
			Если ТипЗнч(Объект.АналитическаяПанель_Отчет) = Тип("СправочникСсылка.ПанелиОтчетов") Тогда
				ОткрытьФорму("Справочник.ПанелиОтчетов.Форма.ФормаЭлемента_Управляемая", ПодготовитьСтруктуруВызова(), , Истина);
			Иначе
				ОткрытьФорму("Справочник.ПроизвольныеОтчеты.Форма.ФормаОтображенияОтчетаУправляемая", ПодготовитьСтруктуруВызова(), ,Истина);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьСтруктуруВызова()
	
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	Если ТипЗнч(ТекОбъект) = Тип("СправочникСсылка.ПанелиОтчетов") Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(ТекОбъект.НастройкиКомпоновщика.Получить());
		Возврат Новый Структура("Ключ, ВнешниеОтборы", ТекОбъект.АналитическаяПанель_Отчет, КомпоновщикНастроек);
	Иначе
		Возврат Новый Структура("Ключ, СохраненнаяНастройка", ТекОбъект.АналитическаяПанель_Отчет, Объект.СохраненнаяНастройка);
	КонецЕсли;
	
КонецФункции