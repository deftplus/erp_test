Процедура ОбработатьРаспознанныеДанныеМодуль() экспорт
	
	
	
	для каждого стр из ЭтотОбъект.ПрочитаноИРаспознано цикл
		еСЛИ стр.СоздаватьЗаявкуНаОплату тогда
			НаКакуюдатуСоздаватьЗаявку=?(ЗначениеЗаполнено(стр.ДатаОплаты),стр.ДатаОплаты,Текущаядата());		
			УстанавливатьСогласование=ЗначениеЗаполнено(стр.ДатаОплаты);
			
			
			Заявка=неопределено;
			
			
			Если ЗначениеЗаполнено(стр.СопоставленоПТУ) тогда
				Заявка=ллл_СоздатьЗаявкуНаОплатуИмпорт(стр.СопоставленоПТУ,
				НаКакуюдатуСоздаватьЗаявку,стр.СуммаСчетаРуб+стр.СуммаСчетаEUR+стр.СуммаСчетаUSD, УстанавливатьСогласование,стр.НомерСтрокиExcel,стр.СрокОплаты);
			
			иначеЕсли ЗначениеЗаполнено(стр.СопоставленоЗаказПоставщику) тогда
			
				Заявка=ллл_СоздатьЗаявкуНаОплатуИмпорт(стр.СопоставленоЗаказПоставщику,НаКакуюдатуСоздаватьЗаявку,стр.СуммаСчетаРуб+стр.СуммаСчетаEUR+стр.СуммаСчетаUSD, 
				УстанавливатьСогласование,стр.НомерСтрокиExcel,стр.СрокОплаты);			
			
			КонецЕсли;  
			
			
			Если значениеЗаполнено(Заявка) тогда 
				стр.СозданаЗаявкаНаОплату=истина; 
				стр.Заявка=Заявка;
				//если стр.Заявка.Проведен=ложь тогда
				//	стр.Ошибки="Не удалось провести заявку";
				//КонецЕсли;	
			конецЕсли;
				
				Если стр.СоздаватьДокументСписания тогда
					докСписания=СоздатьДокСписания(заявка,НаКакуюдатуСоздаватьЗаявку,стр.НомерСтрокиExcel);	 
					Если значениеЗаполнено(ДокСписания) тогда
						стр.СозданДокументСписания=истина;	
						стр.Списание=докСписания;
						
						
					если докСписания.Проведен=ложь тогда
						стр.Ошибки=стр.Ошибки+" Не удалось провести док. списания";
					КонецЕсли;	
						
						
						
					КонецЕсли;	
				КонецЕсли;	
			
			
		КонецЕсли;	
		
		
		
		
		
	КонеццИКЛА;      
	
	
	
	ДЛЯ КАЖДОГО СТР ИЗ    ЭтотОбъект.ПрочитаноИРаспознано ЦИКЛ
		если значениеЗаполнено(стр.Заявка) и стр.Заявка.Проведен=ложь тогда
			      Об=стр.Заявка.ПолучитьОбъект();
				  попытка
				  Об.Записать(режимЗаписиДокумента.Проведение,РежимПроведенияДокумента.Неоперативный);
				  
			  	  исключение
				  
				   стр.ошибки=описаниеОшибки();
				  КонецПопытки;
				  
			
			
		КонецЕсли;	
		
		
	КонецЦикла;
	
	
	
	
	
	
	
КонецПроцедуры










Функция СоздатьДокСписания(заявка,ДатаОплаты,СтрокаExcel)
	ДокСписание=Документы.СписаниеБезналичныхДенежныхСредств.СоздатьДокумент(); 
	//ДокСписание.ЗаявкаНаРасходованиеДенежныхСредств=Заявка.Ссылка; 
	//ДокСписание.ДокументОснование=Заявка.Ссылка;
	ДокСписание.Видплатежа="электронно";
	ДокСписание.ТипПлатежногоДокумента=Перечисления.ТипыПлатежныхДокументов.ПлатежноеПоручение;
	ЗаполнитьЗначенияСвойств(ДокСписание,Заявка.Ссылка,,"Дата,Номер");
	стрДокСписание=ДокСписание.РасшифровкаПлатежа.Добавить();
	ЗаполнитьЗначенияСвойств(стрДокСписание,Заявка.Ссылка.РасшифровкаПлатежа[0]); 
	стрДокСписание.ЗаявкаНаРасходованиеДенежныхСредств=Заявка.Ссылка;
	стрДокСписание.ЦФО=ДокСписание.Организация;  
	стрДокСписание.СтатьяДвиженияДенежныхСредств  =ДокСписание.СтатьяДвиженияДенежныхСредств; 
	Если ЗначениеЗаполнено(ДатаОплаты) тогда
		ДокСписание.Дата=ДатаОплаты; 	
	иначе
		ДокСписание.Дата=ТекущаяДата(); 	
	КонецЕсли;
	
	
	ДокСписание.ОплатапоЗаявкам=истина;  
	доксПИСАНИЕ.ОчередностьПлатежа=1;
	ДокСписание.УстановитьНовыйНомер(ДокСписание.Организация.Префикс);
	ДокСписание.ДокументОснование=Заявка.Ссылка; 
	ДокСписание.ЗаявкаНаРасходованиеДенежныхСредств=Заявка.Ссылка;
	ДокСПисание.Проведенобанком=истина;
	ДокСписание.ДатаПроведенияБанком=Датаоплаты;           
	ДокСписание.Комментарий="Создано автоматически "+строка(СтрокаExcel);
	
	Запрос=Новый Запрос();
	Запрос.Текст= "
		|ВЫБРАТЬ
		|	РазмещениеЗаявок.ЗаявкаНаОперацию КАК ЗаявкаНаОперацию,
		|	РазмещениеЗаявок.ПриходРасход КАК ПриходРасход,
		|	РазмещениеЗаявок.ИдентификаторПозиции КАК ИдентификаторПозиции,
		|	РазмещениеЗаявок.БанковскийСчетКасса КАК БанковскийСчетКасса,
		|	РазмещениеЗаявок.Контрагент КАК Контрагент,
		|	РазмещениеЗаявок.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
		|	РазмещениеЗаявок.Сумма КАК Сумма,
		|	РазмещениеЗаявок.ФормаОплаты КАК ФормаОплаты,
		|	РазмещениеЗаявок.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
		|	РазмещениеЗаявок.Проведен КАК Проведен,
		|	РазмещениеЗаявок.КурсПлатежа КАК КурсПлатежа,
		|	РазмещениеЗаявок.УдалитьФормаОплаты КАК УдалитьФормаОплаты,
		|	РазмещениеЗаявок.ЗапретИзмененияДаты КАК ЗапретИзмененияДаты,
		|	РазмещениеЗаявок.ВалютаОплаты КАК ВалютаОплаты,
		|	РазмещениеЗаявок.ВидОперацииУХ КАК ВидОперацииУХ,
		|	РазмещениеЗаявок.ДатаИсполнения КАК ДатаИсполнения,
		|	РазмещениеЗаявок.СчетКонтрагента КАК СчетКонтрагента,
		|	РазмещениеЗаявок.ЗапретИзмененияБанковскогоСчетаКассы КАК ЗапретИзмененияБанковскогоСчетаКассы,
		|	РазмещениеЗаявок.ЗапретРазбиенияСлияния КАК ЗапретРазбиенияСлияния,
		|	РазмещениеЗаявок.ИдентификаторВстречнойПозиции КАК ИдентификаторВстречнойПозиции,
		|	РазмещениеЗаявок.КратностьПлатежа КАК КратностьПлатежа,
		|	РазмещениеЗаявок.Организация КАК Организация,
		|	РазмещениеЗаявок.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	РазмещениеЗаявок.Приоритет КАК Приоритет,
		|	РазмещениеЗаявок.БезакцептноеСписание КАК БезакцептноеСписание,
		|	РазмещениеЗаявок.СпособОпределенияКурсаПлатежа КАК СпособОпределенияКурсаПлатежа,
		|	РазмещениеЗаявок.ДатаФиксацииКурсаПлатежа КАК ДатаФиксацииКурсаПлатежа,
		|	РазмещениеЗаявок.КурсПлатежаНеБолее КАК КурсПлатежаНеБолее,
		|	РазмещениеЗаявок.КурсПлатежаНеМенее КАК КурсПлатежаНеМенее,
		|	РазмещениеЗаявок.КурсПлатежаНеМенееВВалютеОплаты КАК КурсПлатежаНеМенееВВалютеОплаты,
		|	РазмещениеЗаявок.КурсПлатежаНеБолееВВалютеОплаты КАК КурсПлатежаНеБолееВВалютеОплаты,
		|	РазмещениеЗаявок.СдвигДатыФиксацииКурсаПлатежа КАК СдвигДатыФиксацииКурсаПлатежа,
		|	РазмещениеЗаявок.КрайняяДата КАК КрайняяДата
		|ИЗ
		|	РегистрСведений.РазмещениеЗаявок КАК РазмещениеЗаявок
		|ГДЕ
		|	РазмещениеЗаявок.ЗаявкаНаОперацию = &ЗаявкаНаОперацию";
		Запрос.УстановитьПараметр("ЗаявкаНаоперацию", Заявка);
		Результат=Запрос.Выполнить();
		Выборка=результат.Выбрать();
		если Выборка.Следующий() тогда
			
			стрДокСписание.КурсЧислительВзаиморасчетов=Выборка.КурсПлатежа;
			стрДокСписание.КурсЗнаменательВзаиморасчетов=Выборка.КратностьПлатежа;
			стрДокСписание.Сумма=стрДокСписание.СуммаВзаиморасчетов*стрДокСписание.КурсЧислительВзаиморасчетов/стрДокСписание.КурсЗнаменательВзаиморасчетов;
	        стрДокСписание.СуммаНДС=стрДокСписание.Сумма*стрДокСПисание.СтавкаНДС.Ставка/(100+ стрДокСПисание.СтавкаНДС.Ставка);
			ДокСписание.СуммаДокумента=стрДокСписание.Сумма;
			ДокСписание.Валюта=Справочники.Валюты.НайтиПоКоду("643");
			ДокСПисание.банковскийСчетКонтрагента=ллл_ПоискЗначений.НайтиБанковскийСчетКонтрагента(ДокСписание.Контрагент,ДокСПисание.Валюта);
			
			
			
		КонецЕсли;
	
	
	

	
	
	ДокСписание.Записать(РежимЗаписиДокумента.Запись);
	
	

	
	попытка

		ДокСписание.Записать(РежимЗаписиДокумента.Проведение);
		
	
	исключение
	
	
	
	КонецПопытки;
	
	возврат(докСписание.Ссылка);
	
КонецФункции




Процедура УбитьУжеСуществующиеЗаявки(Заказ)
	
	Запрос=Новый Запрос();
	Запрос.Текст="ВЫБРАТЬ
	|	ЗаявкаНаРасходованиеДенежныхСредств.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТ_ЗаявкиЗаказа
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК ЗаявкаНаРасходованиеДенежныхСредств
	|ГДЕ
	|	ЗаявкаНаРасходованиеДенежныхСредств.ДокументОснование = &Заказ
	|	И ЗаявкаНаРасходованиеДенежныхСредств.ПометкаУдаления = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписаниеБезналичныхДенежныхСредств.Ссылка КАК Платежка,
	|	СписаниеБезналичныхДенежныхСредств.ЗаявкаНаРасходованиеДенежныхСредств КАК Ссылка
	|ПОМЕСТИТЬ ВТ_ПлатежкиЗаявок
	|ИЗ
	|	Документ.СписаниеБезналичныхДенежныхСредств КАК СписаниеБезналичныхДенежныхСредств
	|ГДЕ
	|	СписаниеБезналичныхДенежныхСредств.ПометкаУдаления = ЛОЖЬ
	|	И СписаниеБезналичныхДенежныхСредств.ЗаявкаНаРасходованиеДенежныхСредств В
	|			(ВЫБРАТЬ
	|				з.Ссылка
	|			ИЗ
	|				ВТ_ЗаявкиЗаказа КАК з)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ЗаявкиЗаказа.Ссылка КАК Ссылка,
	|	ВТ_ПлатежкиЗаявок.Ссылка КАК Ссылка1
	|ИЗ
	|	ВТ_ЗаявкиЗаказа КАК ВТ_ЗаявкиЗаказа
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ПлатежкиЗаявок КАК ВТ_ПлатежкиЗаявок
	|		ПО ВТ_ЗаявкиЗаказа.Ссылка = ВТ_ПлатежкиЗаявок.Ссылка
	|ГДЕ
	|	ВТ_ПлатежкиЗаявок.Ссылка ЕСТЬ NULL";
	
	

	Запрос.УстановитьПараметр("Заказ",Заказ);
	
	Результат=Запрос.Выполнить();
	Выборка=результат.Выбрать();
	пока ВЫборка.Следующий() цикл
		Если не ЗначениеЗаполнено(Выборка.Ссылка) тогда продолжить; конецЕсли;
		Об=ВЫборка.Ссылка.ПолучитьОбъект();
		Об.ПометкаУдаления=истина;
		Об.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		
		Запрос2=Новый Запрос();
		Запрос2.Текст="ВЫБРАТЬ
	 |	ЭкземплярПроцесса.Ссылка КАК Ссылка
	 |ИЗ
	 |	Документ.ЭкземплярПроцесса КАК ЭкземплярПроцесса
	 |ГДЕ
	 |	ЭкземплярПроцесса.ПометкаУдаления = ЛОЖЬ
	 |	И ЭкземплярПроцесса.КлючевойОбъектПроцесса = &заявка";
		Запрос2.УстановитьПараметр("Заявка",Об.Ссылка);
		Результат2=Запрос2.Выполнить();
		Выборка2=Результат2.Выбрать();
		пока ВЫборка2.Следующий() цикл
			Об2=ВЫборка2.Ссылка.ПолучитьОбъект();
			Об2.ПометкаУдаления=истина;
			Об2.Записать(РежимЗаписиДокумента.ОтменаПроведения);
        КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры


Функция ллл_СоздатьЗаявкуНаОплатуИмпорт(Заказ,ДатаПлатежа,СуммаПлатежа,УстанавливатьСогласованность,СтрокаExcel,ЖелаемаяДатаПлатежа)  

   ////попытка
   // Если типЗнч(Заказ)=тип("ДокументСсылка.ЗаказПоставщику") тогда
   // 	ЗаказОбъект=Заказ.ПолучитьОбъект();
   // 	ЗаказОбъект.ОбменДанными.Загрузка=истина; 
   // 	ЗаказОбъект.Согласован=истина;
   // 	ЗаказОбъект.Статус =Перечисления.СтатусыЗаказовПоставщикам.Подтвержден;
   // 	ЗаказОбъект.Записать();
   // 	
   // 
   // КонецЕсли;	
   
   
   

   
    УбитьУжеСуществующиеЗаявки(Заказ);
   
   
   

	Заявка=Документы.ЗаявкаНаРасходованиеДенежныхСредств.СоздатьДокумент();
	Заявка.Заполнить(Заказ);
	Заявка.Комментарий="Создано автоматически "+строка(СтрокаExcel);
	СтавкаНДС=заказ.товары[0].СтавкаНДС;  
	Заявка.СтатьяДвиженияДенежныхСредств=Справочники.СтатьиДвиженияДенежныхСредств.НайтипоНаименованию("21.02_Приобретение товара РФ");		
    Заявка.ЖелательнаяДатаПлатежа=ЖелаемаяДатаПлатежа;

	
	
	
	Если Заказ.Хозяйственнаяоперация=Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту тогда
			ВалютаВзаиморасчетов=Заказ.Валюта;
			ВалютаДокумента=ВалютаВзаиморасчетов;
			Курс=1;
			Кратность=1;
		
		
	иначе	
	
		Если Заявка.Договор.ВалютаВзаиморасчетов<>Заявка.Договор.ОсновнаяВалютаПлатежей тогда
			ВалютаВзаиморасчетов=Заявка.Договор.ВалютаВзаиморасчетов;
			ВалютаДокумента=Справочники.Валюты.НайтиПоКоду("643");
			ТабКурс=РегистрыСведений.КурсыВалют.СрезПоследних(ДатаПлатежа,Новый Структура("Валюта",ВалютаВзаиморасчетов));
			Курс=ТабКурс[0].Курс;
			Кратность=ТабКурс[0].Кратность;
		иначе

			ВалютаВзаиморасчетов=Заявка.Договор.ВалютаВзаиморасчетов;
			ВалютаДокумента=ВалютаВзаиморасчетов;
			Курс=1;
			Кратность=1;
			
		КонецЕсли;	
	
	КонецЕсли;
	
	Заявка.СуммаДокумента=СуммаПлатежа;

	Заявка.Валюта=ВалютаВзаиморасчетов;
	Заявка.ВалютаОплаты=ВалютаДокумента; 
	Заявка.КурсПлатежа=Курс;
	Заявка.КратностьПлатежа=Кратность;
	Заявка.ДатаПлатежа=ДатаПлатежа; 
	Заявка.ЖелательнаяДатаПлатежа=ЖелаемаяДатаПлатежа;
	стр=Заявка.ДополнительныеРеквизиты.Добавить();
	стр.Свойство=ПланыВидовхарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Создано автоматически");
	стр.Значение=истина;
	РасшПлатежа=Заявка.расшифровкаПлатежа[0];
	РасшПлатежа.ВалютаВзаиморасчетов=Заявка.Валюта;
	РасшПлатежа.СуммаВзаиморасчетов=СуммаПлатежа; 
	РасшПлатежа.КурсЧислительВзаиморасчетов=Курс;
	РасшПлатежа.КурсЗнаменательВзаиморасчетов=Кратность;       
	РасшПлатежа.СтатьяДвиженияДенежныхСредств=Справочники.СтатьиДвиженияДенежныхСредств.НайтипоНаименованию("21.02_Приобретение товара РФ");
	Заявка.Внемаршрута=УстанавливатьСогласованность;;               
	Заявка.БанковскийСчетКонтрагента=ллл_ПоискЗначений.НайтиБанковскийСчетКонтрагента(Заявка.Контрагент,Заявка.ВалютаОплаты);
	Заявка.БанковскийСчет=ллл_ПоискЗначений.НайтиБанковскийСчетОрганизации(Заявка.Организация,Заявка.ВалютаОплаты);
	//РасшПлатежа.Сумма=СуммаПлатежа*Курс/Кратность;                                                                 
	Заявка.БанковскийСчетПолучатель  = ллл_ПоискЗначений.НайтиБанковскийСчетКонтрагента(Заявка.Контрагент,Заявка.ВалютаОплаты);
	РасшПлатежа.Сумма=СуммаПлатежа;
	РасшПлатежа.СуммаНДС=СуммаПлатежа/(100+СтавкаНДС.Ставка)*СтавкаНДС.Ставка;
	РасшПлатежа.ЭлементСтруктурыЗадолженности=Перечисления.ЭлементыСтруктурыЗадолженности.ОсновнойДолг;
	РасшПлатежа.Организация=Заявка.Организация;
	Заявка.ЦФО=Заявка.Организация;    
	РасшПлатежа.СтавкаНДС=СтавкаНДС; 
	//Заявка.НазначениеПлатежа="payment to invoice №" + заказ.НомерПоДаннымПоставщика+ 
	//" from " + Формат(Заказ.ДатаПоДаннымПоставщика,"ДФ=""гггг/ММ/дд""");
	
	//Заявка.Записать();   
	_ссылка=Документы.ЗаявкаНаРасходованиеДенежныхСредств.ПолучитьСсылку();
	Заявка.УстановитьСсылкуНового(_ссылка);       
	Заявка.УстановитьНовыйНомер(Заявка.организация.Префикс); 
	Заявка.Дата=Датаплатежа-1; 
	Заявка.НалогообложениеНДС=Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
	Заявка.Приоритет=Справочники.ПриоритетыПлатежей.Неотложно;  


	Заявка.Записать(РежимЗаписиДокумента.Запись); 
	
	попытка
	
	Если  УстанавливатьСогласованность тогда
		Заявка.Статус=Перечисления.СтатусыЗаявокНаРасходованиеДенежныхСредств.Согласована;
		нз=РегистрыСведений.РегистрСостоянийОбъектов.СоздатьНаборЗаписей();
		нз.Отбор.Объект.Установить(_ссылка);
		нз.ПРочитать();
		нз.очистить();
		з=нз.Добавить();
		з.Объект=_ссылка;
		З.пЕРИОД=тЕКУЩАЯдАТА();
		з.СостояниеОбъекта=Перечисления.СостоянияСогласования.Утверждена;
		нз.Записывать=истина; 
		нз.Записать();  
	иначе
		Заявка.Записать(режимЗаписиДокумента.Проведение,РежимПроведенияДокумента.Неоперативный);
		
		
		
		
	КонецЕсли;
	
	исключение
	
	
	КонецПопытки;
	
	
	
	
	Менеджер=ллл_ПоискЗначений.НайтиСоздатьЗаписьПлатежнойПозиции(Заявка.Ссылка);
	Если не ЗначениеЗаполнено(Менеджер.ИдентификаторПозиции) тогда
		Менеджер.ИдентификаторПозиции=Новый УникальныйИдентификатор();
		
	КонецЕсли;
	Менеджер.ЗаявкаНаОперацию=Заявка.Ссылка;
	ЗаполнитьЗначенияСвойств(Менеджер,Заявка.Ссылка); 
	Менеджер.СуммаВзаиморасчетов=СуммаПлатежа;
	Менеджер.ВалютаВзаиморасчетов=заявка.Договор.ВалютаВзаиморасчетов;
	Менеджер.Сумма =Менеджер.СуммаВзаиморасчетов*Курс/Кратность;   
	Менеджер.Датаисполнения=ДатаПлатежа;
	Менеджер.КурсПлатежа=Курс;
	Менеджер.КратностьПлатежа=Кратность;		
	Менеджер.ДатаФиксацииКурсаПлатежа=ДатаПлатежа;
	Менеджер.СчетКонтрагента=Заявка.БанковскийСчетКонтрагента;
	Менеджер.ПРиходРасход=Перечисления.ВидыДвиженийПриходРасход.Расход;  
	Менеджер.ВалютаОплаты=Справочники.Валюты.НайтиПоКоду("643");
	Менеджер.Записать();
  
	//Заявка.Записать(РежимЗаписиДокумента.Проведение);  
	возврат(Заявка.Ссылка);

	//исключение
	//
	//	возврат(неопределено);	
	//КонецПопытки;
КонецФункции    


