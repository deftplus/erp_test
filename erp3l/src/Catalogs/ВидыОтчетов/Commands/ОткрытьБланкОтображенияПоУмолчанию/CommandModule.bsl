
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	БланкОтчета=ПолучитьНастройкиПоУмолчанию(ПараметрКоманды);
	
	Если Не ЗначениеЗаполнено(БланкОтчета) Тогда	
		Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
			
			СтруктураПараметров = Новый Структура("ВидОтчета", ПараметрКоманды);
			ИмяФормы_ = "Обработка.НастройкаСтруктурыОтчета.Форма.ФормаКонструктора";
			ОткрытьФорму(ИмяФормы_,СтруктураПараметров,ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);	
			
		Иначе
			
			ПоказатьПредупреждение(,Нстр("ru = 'Не указан бланк экземпляра отчета по умолчанию.'"));
			
		КонецЕсли;	
	Иначе		
		ОткрытьФорму("Справочник.БланкиОтчетов.ФормаОбъекта", Новый Структура("Ключ", ПолучитьНастройкиПоУмолчанию(ПараметрКоманды)), ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНастройкиПоУмолчанию(ВидОтчета)
	
	Возврат УправлениеОтчетамиУХ.НайтиПараметрОтчета(Перечисления.ЭлементыНастройкиОтчета.БланкДляОтображения, ВидОтчета);
	
КонецФункции