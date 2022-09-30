#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если Автонаименование Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Наименование");
	КонецЕсли;
	
	ОбщийПроцентОплаты = ЭтапыОплаты.Итог("ПроцентОплаты");
	Если ОбщийПроцентОплаты <> 100 Тогда 
		
		ТекстОшибки = СтрЗаменить(
			НСтр("ru='Процент платежей по всем этапам ""%1%"" должен равняться ""100%""'"),
			"%1",
			ОбщийПроцентОплаты);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,"Объект.ЭтапыОплаты[0].ПроцентОплаты",,Отказ);
			
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Автонаименование Тогда 
		СформироватьАвтоНаименованиеОбъекта();
	КонецЕсли;
	
	ПроцентАванса = 0;
	СрокОтсрочки = 0;
	СрокАванса = 0;
	СрокОтсрочкиПриведенный = 0;
	СрокАвансаПриведенный = 0;
	
	ЭтапыОплаты.Свернуть("ВариантОплаты,ТипСрока,Срок,БазоваяДата","ПроцентОплаты");
	
	Для Каждого ТекСтрока Из ЭтапыОплаты Цикл
		
		Если ТекСтрока.ВариантОплаты = Перечисления.ВариантыОплаты.Аванс Тогда
			
			ПроцентАванса = ПроцентАванса + ТекСтрока.ПроцентОплаты;
			СрокАванса = Макс(СрокАванса, ТекСтрока.Срок);
			ТекСрокАвансаПриведенный = ТекСтрока.Срок * ?(ТекСтрока.ТипСрока = Перечисления.СпособыРасчетаКоличестваДнейВПериоде.ПоКалендарнымДням, 5/7, 1);
			СрокАвансаПриведенный = Макс(СрокАвансаПриведенный, ТекСрокАвансаПриведенный);
			
		ИначеЕсли ТекСтрока.ВариантОплаты = Перечисления.ВариантыОплаты.Постоплата Тогда
			
			СрокОтсрочки = Макс(СрокОтсрочки, ТекСтрока.Срок);
			ТекСрокОтсрочкиПриведенный = ТекСтрока.Срок * ?(ТекСтрока.ТипСрока = Перечисления.СпособыРасчетаКоличестваДнейВПериоде.ПоКалендарнымДням, 5/7, 1);
			СрокОтсрочкиПриведенный = Макс(СрокОтсрочкиПриведенный, ТекСрокОтсрочкиПриведенный);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СформироватьАвтоНаименованиеОбъекта()
	
	ЭлементыНаименования = Новый Массив;
	
	ШаблонАванс = НСтр("ru = 'Аванс %1%% за %2 %3'");
	ШаблонПостоплата = НСтр("ru = 'Постоплата %1%% через %2 %3'");
	
	Для Каждого ТекСтр Из ЭтапыОплаты Цикл 
		
		Если ТекСтр.ВариантОплаты = Перечисления.ВариантыОплаты.Аванс Тогда
			ТекстШаблона = ШаблонАванс;
		Иначе 
			ТекстШаблона = ШаблонПостоплата;
		КонецЕсли;
		
		ТекстТипСрока = ?(ТекСтр.ТипСрока = Перечисления.СпособыРасчетаКоличестваДнейВПериоде.ПоРабочимДням,НСтр("ru = 'р.д.'"), НСтр("ru = 'к.д.'"));
		
		ЭлементыНаименования.Добавить(СтрШаблон(ТекстШаблона, ТекСтр.ПроцентОплаты, ТекСтр.Срок, ТекстТипСрока));
		
	КонецЦикла;
	
	Наименование = СтрСоединить(ЭлементыНаименования, ", ");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

#КонецЕсли