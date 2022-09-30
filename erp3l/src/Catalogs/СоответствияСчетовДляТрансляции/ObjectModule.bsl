Перем ОбновитьПометкуУдаленияДляПодчиненных;

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПометкаУдаления=Ссылка.ПометкаУдаления Тогда
		ОбновитьПометкуУдаленияДляПодчиненных=Истина;
	КонецЕсли;
		
	Если НЕ ЗначениеЗаполнено(ГруппаРаскрытия) Тогда
		
		Если НеТранслировать Тогда
			
			Наименование=СтрШаблон(Нстр("ru = 'Исключение трансляции счета %1'"), СчетИсточник);
			
		Иначе
			
			Наименование=СтрШаблон(Нстр("ru = 'Трансляция со счета %1 в счет %2'"), СчетИсточник, СчетПриемник);	
			
		КонецЕсли;
			
		ГруппаРаскрытия = Справочники.ВидыОтчетов.ПолучитьГруппуРаскрытияДляСчета(Владелец, СчетПриемник, Неопределено, Перечисления.ВидыБухгалтерскихИтогов.ДО);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Код) Тогда
		
		Код=ОбщегоНазначенияУХ.ПолучитьВозможныйКодСправочника(СокрЛП(ОбщегоНазначенияУХ.ВернутьАлфавитноЦифровоеПредставление("И_"+СокрЛП(СчетИсточник.Код)+"_П_"+СокрЛП(СчетПриемник.Код)+"_КС_"+СокрЛП(КоррСчетИсточник.Код))),Метаданные.Справочники.СоответствияСчетовДляТрансляции.ДлинаКода,"СоответствияСчетовДляТрансляции",Владелец);
		
	КонецЕсли;
			
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбновитьПометкуУдаленияДляПодчиненных Тогда
		
		ОбщегоНазначенияУХ.ПометитьСправочникПоРеквизиту("ИсточникиДанныхДляРасчетов","ПотребительРасчета",Ссылка,ПометкаУдаления,Отказ);

	КонецЕсли;	
		
КонецПроцедуры

ОбновитьПометкуУдаленияДляПодчиненных=Ложь;


