
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если Не ЗначениеЗаполнено(ПолучитьНастройкиПоУмолчанию(ПараметрКоманды)) Тогда
		 ОбщегоНазначенияУХ.СообщитьОбОшибке(НСтр("ru = 'Не удалось определить бланк импорта по умолчанию!'"));
		 Возврат;
	КонецЕсли;
	ОткрытьФорму("Справочник.БланкиОтчетов.ФормаОбъекта", Новый Структура("Ключ", ПолучитьНастройкиПоУмолчанию(ПараметрКоманды)), ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНастройкиПоУмолчанию(ПравилоОбработки)
	
	Возврат УправлениеОтчетамиУХ.НайтиПараметрОтчета(Перечисления.ЭлементыНастройкиОтчета.БланкДляИмпорта, ПравилоОбработки);
	
КонецФункции