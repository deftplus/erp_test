
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	
	Организация = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка");
	Если ЗначениеЗаполнено(ПараметрыВыполненияКоманды.Источник.Организация) Тогда
		Организация = ПараметрыВыполненияКоманды.Источник.Организация;
	Иначе
		ПутьКДаннымОтбора = ПараметрыВыполненияКоманды.Источник.Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
		НастройкиОтбораПоОрганизации = ПутьКДаннымОтбора.Найти("Организация");
		Если НастройкиОтбораПоОрганизации <> Неопределено И НастройкиОтбораПоОрганизации.Использование Тогда
			Организация = НастройкиОтбораПоОрганизации.ПравоеЗначение;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Организация", Организация);
	
	ОткрытьФорму("Справочник.ТорговыеТочки.Форма.ФормаЭлемента", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

