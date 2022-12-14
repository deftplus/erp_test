#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПроверитьКлючПериода(Параметры) Экспорт

	 Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ
	                |	КлючиШкалы.Ссылка
	                |ИЗ
	                |	Справочник.КлючиШкалы КАК КлючиШкалы
	                |ГДЕ
	                |	КлючиШкалы.Периодичность = &Периодичность
	                |	И КлючиШкалы.ИтогиПоКварталам = &ИтогиПоКварталам
	                |	И КлючиШкалы.ИтогиПоГодам = &ИтогиПоГодам
	                |	И КлючиШкалы.ИтогиПоПолугодиям = &ИтогиПоПолугодиям
	                |	И КлючиШкалы.ИтогиПоМесяцам = &ИтогиПоМесяцам
	                |	И КлючиШкалы.ИтогиПоНеделям = &ИтогиПоНеделям
	                |	И КлючиШкалы.Сдвиг = &Сдвиг";
	 
	 Запрос.УстановитьПараметр("Периодичность",Параметры.Периодичность);
	 Запрос.УстановитьПараметр("ИтогиПоКварталам",Параметры.ИтогиПоКварталам);
     Запрос.УстановитьПараметр("ИтогиПоГодам",Параметры.ИтогиПоГодам);
	 Запрос.УстановитьПараметр("ИтогиПоМесяцам",Параметры.ИтогиПоМесяцам);
	 Запрос.УстановитьПараметр("ИтогиПоНеделям",Параметры.ИтогиПоНеделям);
	 Запрос.УстановитьПараметр("ИтогиПоПолугодиям",Параметры.ИтогиПоПолугодиям);
	 Запрос.УстановитьПараметр("Сдвиг",Параметры.Сдвиг);
	 
	 Результат = Запрос.Выполнить();
	 Выборка = Результат.Выбрать();
	 
	 Если  Выборка.Следующий() Тогда
	     Возврат Выборка.Ссылка;
	 Иначе	
		 НовыйКлючШкалы = Справочники.КлючиШкалы.СоздатьЭлемент();
		 ЗаполнитьЗначенияСвойств(НовыйКлючШкалы,Параметры); 
		 НовыйКлючШкалы.Записать();
		 Возврат НовыйКлючШкалы.Ссылка;
	 КонецЕсли;
	 	
КонецФункции

Функция ЗаполнитьШкалуПериода(КлючПериода,ДатаНачала,ДатаОкончания) 
	
	Периодичность = КлючПериода.Периодичность;
	Параметры =  КлючПериода;
	СдвигМесяцев =      КлючПериода.Сдвиг;
	
	
	ТзПериодов = Новый ТаблицаЗначений;
	Массив = Новый Массив;
	Массив.Добавить(Тип("Дата"));
	
	ТзПериодов.Колонки.Добавить("ДатаНачалаПериода",Новый ОписаниеТипов(Массив));
	Массив = Новый Массив;
	Массив.Добавить(Тип("ПеречислениеСсылка.Периодичность"));
	
	ТзПериодов.Колонки.Добавить("Периодичность",Новый ОписаниеТипов(Массив));

	
	Если Периодичность = Перечисления.Периодичность.Месяц Тогда
		ПервыйМесяц = НачалоМесяца(ДатаНачала);
		ПоследнийМесяц = НачалоМесяца(ДатаОкончания);
		Пока ПервыйМесяц<=ПоследнийМесяц Цикл
			
			НовыйПериод = ТзПериодов.Добавить();
			НовыйПериод.ДатаНачалаПериода = ДобавитьМесяц(ПервыйМесяц,СдвигМесяцев);
			НовыйПериод.Периодичность = Периодичность;
			
			ПервыйМесяц = ДобавитьМесяц(ПервыйМесяц,1);
			
		КонецЦикла;
	КонецЕсли;	
	
	Если Периодичность = Перечисления.Периодичность.Год Тогда
		ПервыйМесяц = НачалоГода(ДатаНачала);
		ПоследнийМесяц = НачалоГода(ДатаОкончания);
		Пока ПервыйМесяц<=ПоследнийМесяц Цикл
			
			НовыйПериод = ТзПериодов.Добавить();
			НовыйПериод.ДатаНачалаПериода = ДобавитьМесяц(ПервыйМесяц,СдвигМесяцев);
			НовыйПериод.Периодичность = Периодичность;
			ПервыйМесяц = ДобавитьМесяц(ПервыйМесяц,12);
			
		КонецЦикла;
	КонецЕсли;	

    Если Периодичность = Перечисления.Периодичность.Квартал Тогда
		ПервыйМесяц = НачалоКвартала(ДатаНачала);
		ПоследнийМесяц = НачалоКвартала(ДатаОкончания);
		Пока ПервыйМесяц<=ПоследнийМесяц Цикл
			
			НовыйПериод = ТзПериодов.Добавить();
			НовыйПериод.ДатаНачалаПериода = ДобавитьМесяц(ПервыйМесяц,СдвигМесяцев);
			НовыйПериод.Периодичность = Периодичность;
			ПервыйМесяц = ДобавитьМесяц(ПервыйМесяц,3);
			
		КонецЦикла;
	КонецЕсли;		
	
	 Если Периодичность = Перечисления.Периодичность.Неделя Тогда
		ПервыйМесяц = НачалоНедели(ДатаНачала);
		ПоследнийМесяц = НачалоНедели(ДатаОкончания);
		Пока ПервыйМесяц<=ПоследнийМесяц Цикл
			
			НовыйПериод = ТзПериодов.Добавить();
			НовыйПериод.ДатаНачалаПериода = ДобавитьМесяц(ПервыйМесяц,СдвигМесяцев);
			НовыйПериод.Периодичность = Периодичность;
			ПервыйМесяц = ПервыйМесяц+604800;
			
		КонецЦикла;
	КонецЕсли;		
	
	 Если Периодичность = Перечисления.Периодичность.День Тогда
		ПервыйМесяц = НачалоДня(ДатаНачала);
		ПоследнийМесяц = НачалоДня(ДатаОкончания);
		Пока ПервыйМесяц<=ПоследнийМесяц Цикл
			
			НовыйПериод = ТзПериодов.Добавить();
			НовыйПериод.ДатаНачалаПериода = ДобавитьМесяц(ПервыйМесяц,СдвигМесяцев);
			НовыйПериод.Периодичность = Периодичность;
			ПервыйМесяц = ПервыйМесяц+86400;
			
		КонецЦикла;
	КонецЕсли;		
	
	Если Параметры.ИтогиПоГодам И НЕ Периодичность = Перечисления.Периодичность.Год Тогда
		
		ПервыйМесяц = НачалоГода(ДатаНачала);
		ПоследнийМесяц = НачалоГода(ДатаОкончания);
		Пока ПервыйМесяц<=ПоследнийМесяц Цикл
			
			НовыйПериод = ТзПериодов.Добавить();
			НовыйПериод.ДатаНачалаПериода = ДобавитьМесяц(ПервыйМесяц,СдвигМесяцев);
			НовыйПериод.Периодичность = Перечисления.Периодичность.Год;
			
			ПервыйМесяц = НачалоГода(ДобавитьМесяц(ПервыйМесяц,12));
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Параметры.ИтогиПоПолугодиям И НЕ Периодичность = Перечисления.Периодичность.Полугодие Тогда
		
		ПервыйМесяц = НачалоКвартала(ДатаНачала);
		Если Месяц(ДатаНачала)<6 Тогда
			ПервыйМесяц = НачалоГода(ДатаНачала);
		Иначе
			ПервыйМесяц = ДобавитьМесяц(НачалоГода(ДатаНачала),6);
		КонецЕсли;
		
		Если Месяц(ДатаОкончания)<6 Тогда
			ПоследнийМесяц = НачалоГода(ДатаОкончания);
		Иначе
			ПоследнийМесяц = ДобавитьМесяц(НачалоГода(ДатаОкончания),6);
		КонецЕсли;
		
		Пока ПервыйМесяц<=ПоследнийМесяц Цикл
			
			НовыйПериод = ТзПериодов.Добавить();
			НовыйПериод.ДатаНачалаПериода = ДобавитьМесяц(ПервыйМесяц,СдвигМесяцев);
			НовыйПериод.Периодичность = Перечисления.Периодичность.Полугодие;
			ПервыйМесяц = (ДобавитьМесяц(ПервыйМесяц,6));
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Параметры.ИтогиПоКварталам И НЕ Периодичность = Перечисления.Периодичность.Квартал Тогда		
		ПервыйМесяц = НачалоКвартала(ДатаНачала);
		ПоследнийМесяц = НачалоКвартала(ДатаОкончания);
		Пока ПервыйМесяц<=ПоследнийМесяц Цикл
			
			НовыйПериод = ТзПериодов.Добавить();
			НовыйПериод.ДатаНачалаПериода = ДобавитьМесяц(ПервыйМесяц,СдвигМесяцев);
			НовыйПериод.Периодичность = Перечисления.Периодичность.Квартал;
			
			ПервыйМесяц = НачалоКвартала(ДобавитьМесяц(ПервыйМесяц,3));
			
		КонецЦикла;		
	КонецЕсли;
		
	Если Параметры.ИтогиПоМесяцам И НЕ Периодичность = Перечисления.Периодичность.Месяц Тогда	
		ПервыйМесяц = НачалоМесяца(ДатаНачала);
		ПоследнийМесяц = НачалоМесяца(ДатаОкончания);
		Пока ПервыйМесяц<=ПоследнийМесяц Цикл			
			НовыйПериод = ТзПериодов.Добавить();
			НовыйПериод.ДатаНачалаПериода = ДобавитьМесяц(ПервыйМесяц,СдвигМесяцев);
			НовыйПериод.Периодичность = Перечисления.Периодичность.Месяц;
			
			ПервыйМесяц = ДобавитьМесяц(ПервыйМесяц,1);		
		КонецЦикла;	
	КонецЕсли;

	Возврат ТзПериодов;	
	
КонецФункции

Процедура ЗаполнитьПериоды(КлючПериода,ДатаНачала,ДатаОкончания) Экспорт
	
	ТзПериодов = ЗаполнитьШкалуПериода(КлючПериода,ДатаНачала,ДатаОкончания);
		
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТЗПериоды.ДатаНачалаПериода,
	               |	ТЗПериоды.Периодичность
	               |ПОМЕСТИТЬ ВремПериоды
	               |ИЗ
	               |	&ТЗПериоды КАК ТЗПериоды
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВремПериоды.ДатаНачалаПериода,
	               |	ВремПериоды.Периодичность,
	               |	ШкалыПериодов.Ссылка,
	               |	Периоды.Ссылка КАК ОсновнойПериод
	               |ПОМЕСТИТЬ ВремСуществующиеПериоды
	               |ИЗ
	               |	ВремПериоды КАК ВремПериоды
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ШкалыПериодов КАК ШкалыПериодов
	               |		ПО ВремПериоды.ДатаНачалаПериода = ШкалыПериодов.ДатаНачала
	               |			И ВремПериоды.Периодичность = ШкалыПериодов.Периодичность
	               |			И (ШкалыПериодов.Владелец = &КлючПериода)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Периоды КАК Периоды
	               |		ПО ВремПериоды.ДатаНачалаПериода = Периоды.ДатаНачала
	               |			И ВремПериоды.Периодичность = Периоды.Периодичность И Периоды.Произвольный = ЛОЖЬ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВремСуществующиеПериоды.ДатаНачалаПериода,
	               |	ВремСуществующиеПериоды.Периодичность,
	               |	ВремСуществующиеПериоды.Ссылка,
	               |	ВремСуществующиеПериоды.ОсновнойПериод
	               |ИЗ
	               |	ВремСуществующиеПериоды КАК ВремСуществующиеПериоды
	               |ГДЕ
	               |	ВремСуществующиеПериоды.Ссылка ЕСТЬ NULL ";
	
	Запрос.УстановитьПараметр("КлючПериода",КлючПериода);
	Запрос.УстановитьПараметр("ТЗПериоды",ТзПериодов);

	НеСуществующиеПериоды = Запрос.Выполнить().Выгрузить();			   
	
	СоздатьПериоды(НеСуществующиеПериоды,КлючПериода,КлючПериода.Периодичность);
	
КонецПроцедуры

Процедура СоздатьПериоды(НеСуществующиеПериоды,КлючПериода,Периодичность)

	СдвигМесяцев = КлючПериода.Сдвиг;
	
	//Создаем периоды, начиная с самого верхнего уровня.
	ПериодыГод = НеСуществующиеПериоды.НайтиСтроки(Новый Структура("Периодичность",Перечисления.Периодичность.Год));
	Для Каждого Период ИЗ ПериодыГод Цикл 
		нПериод = Справочники.ШкалыПериодов.СоздатьЭлемент();
		
		нПериод.ДатаНачала = Период.ДатаНачалаПериода;
		нПериод.ДатаОкончания = КонецДня(ДобавитьМесяц(Период.ДатаНачалаПериода,12)-1);
		нПериод.Периодичность = Период.Периодичность;
		нПериод.Владелец = КлючПериода;
		нПериод.Наименование  = ПредставлениеПериода(нПериод.ДатаНачала, нПериод.ДатаОкончания);
		нПериод.СвязанныйПериод = ЗаполнитьСВязанныйПериод(Период.ОсновнойПериод,нПериод,СдвигМесяцев);
		нПериод.Записать();
		
	КонецЦикла;
	ПериодыПолгода = НеСуществующиеПериоды.НайтиСтроки(Новый Структура("Периодичность",Перечисления.Периодичность.Полугодие));
	Для Каждого Период ИЗ ПериодыПолгода Цикл 
		нПериод = Справочники.ШкалыПериодов.СоздатьЭлемент();
		нПериод.Наименование = "";
		нПериод.ДатаНачала = Период.ДатаНачалаПериода;
		нПериод.ДатаОкончания = КонецДня(ДобавитьМесяц(Период.ДатаНачалаПериода,6)-1);
			
		нПериод.Периодичность = Период.Периодичность;
		нПериод.Владелец = КлючПериода;
		
		Если Месяц(нПериод.ДатаНачала) = 1 Тогда 
			нПериод.Наименование  = "1 Полугодие "+ПредставлениеПериода(НачалоГода(нПериод.ДатаНачала), НачалоГода(нПериод.ДатаОкончания));
			нПериод.КраткоеНаименование  = "2 Полугодие";
		Иначе
			нПериод.Наименование  = "2 Полугодие "+ПредставлениеПериода(НачалоГода(нПериод.ДатаНачала), НачалоГода(нПериод.ДатаОкончания));
			нПериод.КраткоеНаименование  = "2 Полугодие";
		КонецЕсли;
		
		НПериод.Родитель = НайтиПериодРодитель(КлючПериода,нПериод.ДатаНачала,нПериод.ДатаОкончания,Период.Периодичность);
		нПериод.СвязанныйПериод = ЗаполнитьСВязанныйПериод(Период.ОсновнойПериод,нПериод,СдвигМесяцев);
		нПериод.Записать();	
	КонецЦикла;
	ПериодыКварталы = НеСуществующиеПериоды.НайтиСтроки(Новый Структура("Периодичность",Перечисления.Периодичность.Квартал));
	Для Каждого Период ИЗ ПериодыКварталы Цикл 
		нПериод = Справочники.ШкалыПериодов.СоздатьЭлемент();
		нПериод.ДатаНачала = Период.ДатаНачалаПериода;
		нПериод.ДатаОкончания = КонецДня(ДобавитьМесяц(Период.ДатаНачалаПериода,3)-1);
		нПериод.Периодичность = Период.Периодичность;
		нПериод.Владелец = КлючПериода;
		нПериод.Наименование  = ПредставлениеПериода(нПериод.ДатаНачала, нПериод.ДатаОкончания);
		нПериод.КраткоеНаименование  = Лев(нПериод.Наименование,9);
		НПериод.Родитель = НайтиПериодРодитель(КлючПериода,нПериод.ДатаНачала,нПериод.ДатаОкончания,Период.Периодичность);
		нПериод.СвязанныйПериод = ЗаполнитьСВязанныйПериод(Период.ОсновнойПериод,нПериод,СдвигМесяцев);
		нПериод.Записать();
	КонецЦикла;
	ПериодыМесяцы = НеСуществующиеПериоды.НайтиСтроки(Новый Структура("Периодичность",Перечисления.Периодичность.Месяц));
	Для Каждого Период ИЗ ПериодыМесяцы Цикл 
		нПериод = Справочники.ШкалыПериодов.СоздатьЭлемент();
		нПериод.ДатаНачала = Период.ДатаНачалаПериода;
		нПериод.ДатаОкончания = КонецДня(ДобавитьМесяц(Период.ДатаНачалаПериода,1)-1);
		нПериод.Периодичность = Период.Периодичность;
		нПериод.Владелец = КлючПериода;
		нПериод.Наименование  = ПредставлениеПериода(нПериод.ДатаНачала, нПериод.ДатаОкончания);
		нПериод.КраткоеНаименование  = Лев(нПериод.Наименование,3);
		НПериод.Родитель = НайтиПериодРодитель(КлючПериода,нПериод.ДатаНачала,нПериод.ДатаОкончания,Период.Периодичность);
		нПериод.СвязанныйПериод = ЗаполнитьСВязанныйПериод(Период.ОсновнойПериод,нПериод);
		нПериод.Записать();
	КонецЦикла;
		
	ПериодыНедели = НеСуществующиеПериоды.НайтиСтроки(Новый Структура("Периодичность",Перечисления.Периодичность.Неделя));
	Для Каждого Период ИЗ ПериодыНедели Цикл 
		нПериод = Справочники.ШкалыПериодов.СоздатьЭлемент();
		нПериод.ДатаНачала = Период.ДатаНачалаПериода;
		нПериод.ДатаОкончания = КонецДня(Период.ДатаНачалаПериода+604799);
		нПериод.Периодичность = Период.Периодичность;
		нПериод.Владелец = КлючПериода;
		нПериод.Наименование  = ПредставлениеПериода(нПериод.ДатаНачала, нПериод.ДатаОкончания);
		НПериод.Родитель = НайтиПериодРодитель(КлючПериода,нПериод.ДатаНачала,нПериод.ДатаОкончания,Период.Периодичность);
		нПериод.СвязанныйПериод = ЗаполнитьСВязанныйПериод(Период.ОсновнойПериод,нПериод);
		нПериод.Записать();
	КонецЦикла;
    ПериодыДни = НеСуществующиеПериоды.НайтиСтроки(Новый Структура("Периодичность",Перечисления.Периодичность.День));
	Для Каждого Период ИЗ ПериодыДни Цикл 
		нПериод = Справочники.ШкалыПериодов.СоздатьЭлемент();
		нПериод.ДатаНачала = Период.ДатаНачалаПериода;
		нПериод.ДатаОкончания = КонецДня(Период.ДатаНачалаПериода+86399);
		нПериод.Периодичность = Период.Периодичность;
		нПериод.Владелец = КлючПериода;
		нПериод.Наименование  = ПредставлениеПериода(нПериод.ДатаНачала, нПериод.ДатаОкончания);
		нПериод.КраткоеНаименование  = Лев(нПериод.Наименование,2);
		НПериод.Родитель = НайтиПериодРодитель(КлючПериода,нПериод.ДатаНачала,нПериод.ДатаОкончания,Период.Периодичность);
		нПериод.СвязанныйПериод = ЗаполнитьСВязанныйПериод(Период.ОсновнойПериод,нПериод);
		нПериод.Записать();
	КонецЦикла;

	
КонецПроцедуры

Функция НайтиПериодРодитель(КлючПериода,ДатаНачала,ДатаОкончания,Периодичность)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ШкалыПериодов.Ссылка
	|ИЗ
	|	Справочник.ШкалыПериодов КАК ШкалыПериодов
	|ГДЕ
	|	ШкалыПериодов.Периодичность = &ПериодичностьРодителя
	|	И (ШкалыПериодов.ДатаОкончания >= &ДатаНачала И  ШкалыПериодов.ДатаНачала <=&ДатаОкончания )
	|	И ШкалыПериодов.Владелец = &Владелец";
	
	
	ПериодичностьРодителя = Неопределено;
	Если Периодичность = Перечисления.Периодичность.Полугодие Тогда			   
		Если КлючПериода.ИтогиПоГодам Тогда
			ПериодичностьРодителя = Перечисления.Периодичность.Год;
		КонецЕсли;
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		Если  КлючПериода.ИтогиПоПолугодиям Тогда
			ПериодичностьРодителя = Перечисления.Периодичность.Полугодие;
		ИначеЕсли КлючПериода.ИтогиПоГодам Тогда
			ПериодичностьРодителя = Перечисления.Периодичность.Год;
		КонецЕсли;
	ИначеЕсли Периодичность = Перечисления.Периодичность.Месяц Тогда
		Если  КлючПериода.ИтогиПоКварталам Тогда
			ПериодичностьРодителя = Перечисления.Периодичность.Квартал;
		ИначеЕсли КлючПериода.ИтогиПоПолугодиям Тогда
			ПериодичностьРодителя = Перечисления.Периодичность.Полугодие;
		ИначеЕсли КлючПериода.ИтогиПоГодам Тогда
			ПериодичностьРодителя = Перечисления.Периодичность.Год;
		КонецЕсли;	
		
	ИначеЕсли Периодичность = Перечисления.Периодичность.Неделя Тогда
		Если  КлючПериода.ИтогиПоМесяцам Тогда
			ПериодичностьРодителя = Перечисления.Периодичность.Месяц;
		ИначеЕсли  КлючПериода.ИтогиПоКварталам Тогда
			ПериодичностьРодителя = Перечисления.Периодичность.Квартал;
		ИначеЕсли КлючПериода.ИтогиПоПолугодиям Тогда
			ПериодичностьРодителя = Перечисления.Периодичность.Полугодие;
		ИначеЕсли КлючПериода.ИтогиПоГодам Тогда
			ПериодичностьРодителя = Перечисления.Периодичность.Год;
		КонецЕсли;	
		
	ИначеЕсли Периодичность = Перечисления.Периодичность.День Тогда
		Если  КлючПериода.ИтогиПоНеделям Тогда
			ПериодичностьРодителя = Перечисления.Периодичность.Неделя;
		ИначеЕсли  КлючПериода.ИтогиПоМесяцам Тогда
			ПериодичностьРодителя = Перечисления.Периодичность.Месяц;
		ИначеЕсли  КлючПериода.ИтогиПоКварталам Тогда
			ПериодичностьРодителя = Перечисления.Периодичность.Квартал;
		ИначеЕсли КлючПериода.ИтогиПоПолугодиям Тогда
			ПериодичностьРодителя = Перечисления.Периодичность.Полугодие;
		ИначеЕсли КлючПериода.ИтогиПоГодам Тогда
			ПериодичностьРодителя = Перечисления.Периодичность.Год;
		КонецЕсли;		
	КонецЕсли;
	
	СдвигМесяцев = 0;
	
	Запрос.УстановитьПараметр("ПериодичностьРодителя",ПериодичностьРодителя);
	Запрос.УстановитьПараметр("Владелец",КлючПериода);
	Запрос.УстановитьПараметр("ДатаНачала",ДобавитьМесяц(ДатаНачала,СдвигМесяцев));
	Запрос.УстановитьПараметр("ДатаОкончания",ДобавитьМесяц(ДатаОкончания,СдвигМесяцев));

	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Возврат Выборка.Ссылка;
		
	КонецЦикла;
	
	Возврат Справочники.ШкалыПериодов.ПустаяСсылка();
	
КонецФункции

Функция ЗаполнитьСвязанныйПериод(ОсновнойПериод,НовыйПериод,СдвигМесяцев=0) Экспорт
	
	Если ЗначениеЗаполнено(ОсновнойПериод) Тогда
	     Возврат ОсновнойПериод;	 
	Иначе	 
		нПериод = Справочники.Периоды.СоздатьЭлемент();
		нПериод.ДатаНачала = НовыйПериод.ДатаНачала;
		нПериод.ДатаОкончания = НовыйПериод.ДатаОкончания;
		нПериод.Периодичность = НовыйПериод.Периодичность;
		Если СдвигМесяцев = 0 Тогда
			нПериод.Произвольный = Ложь;
		Иначе
			нПериод.Произвольный = Истина;
		КонецЕсли;	
		нПериод.Записать();
		Возврат нПериод.Ссылка;
	КонецЕсли;
	
КонецФункции	

#КонецЕсли