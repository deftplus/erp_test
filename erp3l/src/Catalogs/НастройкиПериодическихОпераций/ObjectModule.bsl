
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения)=Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		ДоговорКонтрагента = ДанныеЗаполнения;
		
		ДатаНачала = ДанныеЗаполнения.Дата;
		ИмяРеквизитаСрокДействия = ДоговорыКонтрагентовВстраиваниеУХКлиентСервер.ИмяРеквизитаСрокДействияДоговора(
			Тип("СправочникСсылка.ДоговорыКонтрагентов"));
			
		ДатаОкончания=ДанныеЗаполнения[ИмяРеквизитаСрокДействия];
		
		Бессрочный=НЕ ЗначениеЗаполнено(ДатаОкончания);
		
		Валюта=ДанныеЗаполнения.ВалютаВзаиморасчетов;
		
		Дата=?(ЗначениеЗаполнено(ДанныеЗаполнения.ДатаПодписания),ДанныеЗаполнения.ДатаПодписания,ТекущаяДата());
		
		Наименование=ДанныеЗаполнения.Наименование;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения)=Тип("СправочникСсылка.НастройкиПериодическихОпераций") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДанныеЗаполнения,,"ВерсияДанных,Владелец");
		НастройкаОснование=ДанныеЗаполнения;
		
	КонецЕсли;
	
КонецПроцедуры
