Функция ПолучитьТаблицуДанныхПроизвольногоЗапросаВИБ(КонтекстОтчета,СтрЗапрос) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,КонтекстОтчета);
		МассивПараметров.Вставить(1,СтрЗапрос);
		
		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьТаблицуДанныхПроизвольногоЗапросаВИБ",МассивПараметров);	
		
	КонецЕсли;
		
КонецФункции // ПолучитьТаблицуДанныхПроизвольногоЗапросаВИБ()

Функция ПолучитьТаблицуДанныхРегистраБухгалтерииВИБ(КонтекстОтчета,СтрЗапрос) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,КонтекстОтчета);
		МассивПараметров.Вставить(1,СтрЗапрос);

		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьТаблицуДанныхРегистраБухгалтерииВИБ",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // ПолучитьТаблицуДанныхРегистраБухгалтерииВИБ()

Процедура ПолучитьДанныеРегистраБухгалтерииВИБ(ОбъектРасчета,СтрЗапрос) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,ОбъектРасчета);
		МассивПараметров.Вставить(1,СтрЗапрос);
		
		ВыполнитьМетодИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьДанныеРегистраБухгалтерииВИБ",МассивПараметров);	
		
	КонецЕсли;
	
КонецПроцедуры // ПолучитьДанныеРегистраБухгалтерииВИБ()

Функция ПолучитьТаблицуДанныхРегистраНакопленияВИБ(КонтекстОтчета,СтрЗапрос) Экспорт

	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,КонтекстОтчета);
		МассивПараметров.Вставить(1,СтрЗапрос);

		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьТаблицуДанныхРегистраНакопленияВИБ",МассивПараметров);	
				
	КонецЕсли;
	
КонецФункции // ПолучитьТаблицуДанныхРегистраНакопленияВИБ() 

Процедура ПолучитьДанныеРегистраНакопленияВИБ(ОбъектРасчета,СтрЗапрос) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,ОбъектРасчета);
		МассивПараметров.Вставить(1,СтрЗапрос);
		
		ВыполнитьМетодИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьДанныеРегистраНакопленияВИБ",МассивПараметров);	
		
	КонецЕсли;
	
КонецПроцедуры //ПолучитьДанныеРегистраБухгалтерииВИБ()

Функция ПолучитьТаблицуДанныхРегистраБухгалтерииВИБ_77(КонтекстОтчета,СтрЗапрос) Экспорт

	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,КонтекстОтчета);
		МассивПараметров.Вставить(1,СтрЗапрос);

		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьТаблицуДанныхРегистраБухгалтерииВИБ_77",МассивПараметров);	
				
	КонецЕсли;
	
КонецФункции // ПолучитьТаблицуДанныхРегистраБухгалтерииВИБ_77()

Процедура ПолучитьДанныеРегистраБухгалтерииВИБ77(ОбъектРасчета,СтрЗапрос) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,ОбъектРасчета);
		МассивПараметров.Вставить(1,СтрЗапрос);
		
		ВыполнитьМетодИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьДанныеРегистраБухгалтерииВИБ77",МассивПараметров);	
		
	КонецЕсли;
	
КонецПроцедуры // ПолучитьДанныеРегистраБухгалтерииВИБ77()

Функция ПолучитьТаблицуДанныхРегистраНакопленияВИБ_77(КонтекстОтчета,СтрЗапрос) Экспорт

	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,КонтекстОтчета);
		МассивПараметров.Вставить(1,СтрЗапрос);

		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьТаблицуДанныхРегистраНакопленияВИБ_77",МассивПараметров);	
				
	КонецЕсли;
	
КонецФункции // ПолучитьТаблицуДанныхРегистраНакопленияВИБ_77()

Процедура ПолучитьДанныеРегистраНакопленияВИБ77(ОбъектРасчета,СтрЗапрос) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,ОбъектРасчета);
		МассивПараметров.Вставить(1,СтрЗапрос);
		
		ВыполнитьМетодИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьДанныеРегистраНакопленияВИБ77",МассивПараметров);	
		
	КонецЕсли;
	
КонецПроцедуры // ПолучитьДанныеРегистраНакопленияВИБ77()

Функция ПолучитьТаблицуДанныхADO(КонтекстОтчета,СтрЗапрос) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,КонтекстОтчета);
		МассивПараметров.Вставить(1,СтрЗапрос);

		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьТаблицуДанныхADO",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // ПолучитьТаблицуДанныхADO()

Процедура ПолучитьДанныеЗапросаПоADO(ОбъектРасчета,СтрЗапрос) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,ОбъектРасчета);
		МассивПараметров.Вставить(1,СтрЗапрос);
		
		ВыполнитьМетодИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьДанныеЗапросаПоADO",МассивПараметров);	
		
	КонецЕсли;
	
КонецПроцедуры // ПолучитьДанныеЗапросаПоADO()

Функция ПолучитьТаблицуДанныхОбъектаВИБ(КонтекстОтчета,СтрЗапрос) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,КонтекстОтчета);
		МассивПараметров.Вставить(1,СтрЗапрос);

		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьТаблицуДанныхОбъектаВИБ",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // ПолучитьТаблицуДанныхОбъектаВИБ()

Функция ПодготовитьСтруктуруЗапроса(КонтекстОтчета,СтрЗапрос,ПроизвольныйЗапрос=Ложь) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,КонтекстОтчета);
		МассивПараметров.Вставить(1,СтрЗапрос);
		МассивПараметров.Вставить(2,ПроизвольныйЗапрос);

		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПодготовитьСтруктуруЗапроса",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // ПодготовитьСтруктуруЗапроса()

Функция ПолучитьТаблицуДанныхПоЗапросу(СтруктураЗапроса) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,СтруктураЗапроса);

		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьТаблицуДанныхПоЗапросу",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // ПолучитьТаблицуДанныхПоЗапросу()

Функция ТрансформироватьВнешниеДанные(ЗНАЧ КонтекстОтчета,ТаблицаДанных,ПравилаИспользованияПолей) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,КонтекстОтчета);
		МассивПараметров.Вставить(1,ТаблицаДанных);
		МассивПараметров.Вставить(2,ПравилаИспользованияПолей);

		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ТрансформироватьВнешниеДанные",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // ТрансформироватьВнешниеДанные()

Функция НастроитьОбъектЗапрос(СтруктураЗапроса, НужнаПроверка = Ложь, ИспользованиеWS = Ложь, Прокси = Неопределено) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,СтруктураЗапроса);
		МассивПараметров.Вставить(1,НужнаПроверка);
		МассивПараметров.Вставить(2,ИспользованиеWS);
		МассивПараметров.Вставить(3,Прокси);

		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.НастроитьОбъектЗапрос",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // НастроитьОбъектЗапрос()

Функция ПолучитьОтборИзВИБ(ВИБ, База, СправочникБД, Отбор) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,ВИБ);
		МассивПараметров.Вставить(1,База);
		МассивПараметров.Вставить(2,СправочникБД);
		МассивПараметров.Вставить(3,Отбор);

		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьОтборИзВИБ",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // ПолучитьОтборИзВИБ()

Функция ПолучитьСтруктуруОтбора(ДанныеСправочника,МассивОтбора,ИспользуемаяИБ) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,ДанныеСправочника);
		МассивПараметров.Вставить(1,МассивОтбора);
		МассивПараметров.Вставить(2,ИспользуемаяИБ);

		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьСтруктуруОтбора",МассивПараметров);	
				
	КонецЕсли;
	
	
	
КонецФункции // ПолучитьСтруктуруОтбора()

Функция ADO_ПодготовитьТаблицуПолейДляЗапроса(ПравилаИспользованияПолей) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,ПравилаИспользованияПолей);
		
		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ADO_ПодготовитьТаблицуПолейДляЗапроса",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // ADO_ПодготовитьТаблицуПолейДляЗапроса()

Функция ПолучитьСсылкуПОСтрокеUUID(База,ТипОбъектаМетаданных,ИмяОбъектаМетаданных,СтрокаUUID) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,База);
		МассивПараметров.Вставить(1,ТипОбъектаМетаданных);
		МассивПараметров.Вставить(2,ИмяОбъектаМетаданных);
		МассивПараметров.Вставить(3,СтрокаUUID);
		
		Возврат РезультатФункцииИнтеграции("РаботаСОбъектамиМетаданныхВнешнийУХ.ПолучитьСсылкуПОСтрокеUUID",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // ПолучитьСсылкуПОСтрокеUUID()

Функция ПолучитьСоединение(ВИБ, ТипПодключения, КлючСоединения = Неопределено) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,ВИБ);
		МассивПараметров.Вставить(1,ТипПодключения);
		МассивПараметров.Вставить(2,КлючСоединения);
	
		Возврат РезультатФункцииИнтеграции("УправлениеСоединениямиВИБУХ.ПолучитьСоединение",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // ПолучитьСоединение()

Процедура ПолучитьСоединениеВИБ(ОбъектРасчета)Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,ОбъектРасчета);
		
		ВыполнитьМетодИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьСоединениеВИБ",МассивПараметров);	
		
	КонецЕсли;
	
КонецПроцедуры // ПолучитьСоединениеВИБ()

Функция ЗаполнитьДеревоЗначенийДляСправочникаВИБ(Параметры) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,Параметры);
			
		Возврат РезультатФункцииИнтеграции("УправлениеСоединениямиВИБУХ.ЗаполнитьДеревоЗначенийДляСправочникаВИБ",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // ПолучитьСоединение()

Функция ЗаполнитьДеревоЗначенийДляПеречисленияВИБ(Параметры) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,Параметры);
			
		Возврат РезультатФункцииИнтеграции("УправлениеСоединениямиВИБУХ.ЗаполнитьДеревоЗначенийДляПеречисленияВИБ",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // ПолучитьСоединение()

Функция ПолучитьРабочуюТаблицуВычисленияПараметров(ТаблицаВычисленияПараметров) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,ТаблицаВычисленияПараметров);
			
		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьРабочуюТаблицуВычисленияПараметров",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // ПолучитьРабочуюТаблицуВычисленияПараметров()

Функция ПолучитьРабочуюТаблицуВычисленияПараметровADO(ТаблицаВычисленияПараметров) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,ТаблицаВычисленияПараметров);
			
		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьРабочуюТаблицуВычисленияПараметровADO",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // ПолучитьРабочуюТаблицуВычисленияПараметров()

Функция ПодготовитьТаблицуПолейДляЗапроса(ПравилаИспользованияПолей,ДанныеСчетов77=Ложь,ВыгрузкаДанных=Ложь,ПолучатьПредставление=Ложь)  Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,ПравилаИспользованияПолей);
		МассивПараметров.Вставить(1,ДанныеСчетов77);
		МассивПараметров.Вставить(2,ВыгрузкаДанных);
		МассивПараметров.Вставить(3,ПолучатьПредставление);

			
		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПодготовитьТаблицуПолейДляЗапроса",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // ПодготовитьТаблицуПолейДляЗапроса()

Функция ПолучитьТекстПеречисленияИЗВИБ(База,ЗначениеПеречисления,Использование77=Ложь)  Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,База);
		МассивПараметров.Вставить(1,ЗначениеПеречисления);
		МассивПараметров.Вставить(2,Использование77);
			
		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьТекстПеречисленияИЗВИБ",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // ПодготовитьТаблицуПолейДляЗапроса()

Процедура ADO_СформироватьРезультирующиеСтрокиПолейДляИмпорта(Ссылка)Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,Ссылка);
		
		ВыполнитьМетодИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ADO_СформироватьРезультирующиеСтрокиПолейДляИмпорта",МассивПараметров);	
		
	КонецЕсли;
	
КонецПроцедуры // ADO_СформироватьРезультирующиеСтрокиПолейДляИмпорта()

Процедура СформироватьРезультирующиеСтрокиПолейДляИмпорта(Ссылка)Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,Ссылка);
		
		ВыполнитьМетодИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.СформироватьРезультирующиеСтрокиПолейДляИмпорта",МассивПараметров);	
		
	КонецЕсли;
	
КонецПроцедуры // СформироватьРезультирующиеСтрокиПолейДляИмпорта()

Процедура ИзменитьЗначенияДляОтчетовПоВнутригрупповымОперациям(ОбъектРасчета,ДеревоОтчетов) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,ОбъектРасчета);
		МассивПараметров.Вставить(1,ДеревоОтчетов);
		
		ВыполнитьМетодИнтеграции("ДвиженияБюджетированиеУХ.ИзменитьЗначенияДляОтчетовПоВнутригрупповымОперациям",МассивПараметров);	
		
	КонецЕсли;
	
КонецПроцедуры // ИзменитьЗначенияДляОтчетовПоВнутригрупповымОперациям()

Процедура РассчитатьЗависимыеЭкземплярыОтчетов(Ссылка,МассивЭкземпляров) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,Ссылка);
		МассивПараметров.Вставить(1,МассивЭкземпляров);
		
		ВыполнитьМетодИнтеграции("ДвиженияБюджетированиеУХ.РассчитатьЗависимыеЭкземплярыОтчетов",МассивПараметров);	
		
	КонецЕсли;
	
КонецПроцедуры // РассчитатьЗависимыеЭкземплярыОтчетов()

Процедура РассчитатьПоказателиЭффективности(Сценарий,Проект) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,Сценарий);
		МассивПараметров.Вставить(1,Проект);
		
		ВыполнитьМетодИнтеграции("ДвиженияБюджетированиеУХ.РассчитатьПоказателиЭффективности",МассивПараметров);	
		
	КонецЕсли;
	
КонецПроцедуры // РассчитатьПоказателиЭффективности()

Процедура ЗаполнитьАналитикуРегистраПоРаскрытию(РабочийОбъект,ВидБюджета,СтрокаЗаписи,СтрокаПоказатель,СтрокаРаскрытия) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,РабочийОбъект);
		МассивПараметров.Вставить(1,ВидБюджета);
		МассивПараметров.Вставить(2,СтрокаЗаписи);
		МассивПараметров.Вставить(3,СтрокаПоказатель);
		МассивПараметров.Вставить(4,СтрокаРаскрытия);

		ВыполнитьМетодИнтеграции("ДвиженияБюджетированиеУХ.ЗаполнитьАналитикуРегистраПоРаскрытию",МассивПараметров);	
		
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьАналитикуРегистраПоРаскрытию()

Функция ЭтоЛимитирующийЭкземплярОтчета(Ссылка)Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,Ссылка);
		
		Возврат РезультатФункцииИнтеграции("ДвиженияБюджетированиеУХ.ЭтоЛимитирующийЭкземплярОтчета",МассивПараметров);	
		
	КонецЕсли;
	
КонецФункции // ЭтоЛимитирующийЭкземплярОтчета()

Функция РассчитатьЗависимыеПоказателиОтчетов(ОбъектРасчета,СтруктураКлючевыхРеквизитов,ТрассировкаРасчета=Ложь,ПересчитыватьТекущие=Истина) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,ОбъектРасчета);
		МассивПараметров.Вставить(1,СтруктураКлючевыхРеквизитов);
		МассивПараметров.Вставить(2,ТрассировкаРасчета);
		МассивПараметров.Вставить(3,ПересчитыватьТекущие);
			
		Возврат РезультатФункцииИнтеграции("ДвиженияБюджетированиеУХ.РассчитатьЗависимыеПоказателиОтчетов",МассивПараметров);	
				
	КонецЕсли;
		
КонецФункции // РассчитатьЗависимыеПоказателиОтчетов()

Функция ПолучитьНастройкуСоответствияРеквизитов(ТипБД,СправочникКонсолидации,СправочникБД,ТипМетаДанных,ПервыйЭлемент=Истина,СоздаватьОбъект=Ложь,ТипОбъектаКонсолидации="") Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,ТипБД);
		МассивПараметров.Вставить(1,СправочникКонсолидации);
		МассивПараметров.Вставить(2,СправочникБД);
		МассивПараметров.Вставить(3,ТипМетаДанных);
		МассивПараметров.Вставить(4,ПервыйЭлемент);
		МассивПараметров.Вставить(5,СоздаватьОбъект);
		МассивПараметров.Вставить(6,ТипОбъектаКонсолидации);
		
		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьНастройкуСоответствияРеквизитов",МассивПараметров);
		
	КонецЕсли;
	
КонецФункции // ПолучитьНастройкуСоответствияРеквизитов()

Функция ПолучитьТаблицуСоответствий(ТипБД,ТипЗначения) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		
		МассивПараметров=Новый Массив;
		МассивПараметров.Вставить(0,ТипБД);
		МассивПараметров.Вставить(1,ТипЗначения);
				
		Возврат РезультатФункцииИнтеграции("ИнтеграцияСВнешнимиСистемамиУХ.ПолучитьТаблицуСоответствий",МассивПараметров);
		
	КонецЕсли;
	
		
КонецФункции // ПолучитьТаблицуСоответствий()

////////////////////////////////////////////////////////////////////////////////////////\

Процедура ВыполнитьМетодИнтеграции(ИмяМетода, Параметры = Неопределено,ТекСоединениеВИБ=Неопределено) Экспорт
	
	ПараметрыСтрока = "";
	
	Если Параметры <> Неопределено И Параметры.Количество() > 0 Тогда
		Для Индекс = 0 По Параметры.ВГраница() Цикл 
			ПараметрыСтрока = ПараметрыСтрока + "Параметры[" + Индекс + "],";
		КонецЦикла;
		ПараметрыСтрока = Сред(ПараметрыСтрока, 1, СтрДлина(ПараметрыСтрока) - 1);
	КонецЕсли;
	
	Выполнить ?(ТекСоединениеВИБ=Неопределено,"","ТекСоединениеВИБ.")+ИмяМетода + "(" + ПараметрыСтрока + ")";
	
КонецПроцедуры // ВыполнитьМетодИнтеграции()

Функция РезультатФункцииИнтеграции(ИмяМетода, Параметры = Неопределено,ТекСоединениеВИБ=Неопределено) Экспорт
	
	Перем Результат;
	
	ПараметрыСтрока = "";
	
	Если Параметры <> Неопределено И Параметры.Количество() > 0 Тогда
		Для Индекс = 0 По Параметры.ВГраница() Цикл 
			ПараметрыСтрока = ПараметрыСтрока + "Параметры[" + Индекс + "],";
		КонецЦикла;
		ПараметрыСтрока = Сред(ПараметрыСтрока, 1, СтрДлина(ПараметрыСтрока) - 1);
	КонецЕсли;
	
	Выполнить "Результат="+?(ТекСоединениеВИБ=Неопределено,"","ТекСоединениеВИБ.")+ИмяМетода + "(" + ПараметрыСтрока + ")";

	Возврат Результат;
	
КонецФункции // ВычислитьФункциюИнтеграции() 
