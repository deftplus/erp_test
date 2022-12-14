Перем ТаблицаРеквизитовДляПоиска Экспорт;
Перем ТаблицаИсходныхЭлементов Экспорт;
Перем ТаблицаДублирующихЭлементов Экспорт;
Перем ТаблицаАналитики Экспорт;
Перем ЕстьРеквизитыНСИ Экспорт;
Перем ЗапросРеквизиты;
Перем ВариантПоиска Экспорт;
Перем УчитыватьНезаполненные Экспорт;

Процедура ВыполнитьПоискДублей() Экспорт
		
	ЗапросРеквизиты=Новый Запрос;	
			
	// Получаем исходные данные для поиска
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ";
	
	Для Каждого СтрРеквизит ИЗ ТаблицаРеквизитовДляПоиска Цикл
		
		Если Не СтрРеквизит.Отображать Тогда
			Продолжить;
		КонецЕсли;
		
		Запрос.Текст=Запрос.Текст+"
		|ТаблицаАналитики."+СтрРеквизит.ИмяРеквизита+ " КАК "+СтрРеквизит.ИмяРеквизита+",";
		
	КонецЦикла;
	
	Запрос.Текст=Запрос.Текст+"
	|ТаблицаАналитики.Ссылка КАК Ссылка
	|ИЗ "+ТаблицаАналитики+" КАК ТаблицаАналитики
	|ГДЕ ИСТИНА //НЕ ТаблицаАналитики.ПометкаУдаления";
	
	Если ТаблицаАналитики="Справочник.ПроизвольныйКлассификаторУХ" Тогда
		
		Запрос.Текст = Запрос.Текст + "
		|И ТаблицаАналитики.Владелец=&Владелец";
		Запрос.УстановитьПараметр("Владелец", ИмяОбъектаМетаданных);
		
	КонецЕсли;
	
	Если СпособОбработки<4 Тогда
		
		Запрос.Текст=Запрос.Текст+"
		|И ТаблицаАналитики.Ссылка=&Ссылка";
		Запрос.УстановитьПараметр("Ссылка",ЭлементДляПоиска);
		
	ИначеЕсли СпособОбработки<=5 Тогда
		
		Если ЕстьРеквизитыНСИ Тогда
			
			Запрос.Текст=Запрос.Текст+"
			|И (НЕ ТаблицаАналитики.НСИ_ТребуетСинхронизации)";
			
		КонецЕсли;
		
	ИначеЕсли СпособОбработки=6 Тогда
		
		Если ЕстьРеквизитыНСИ Тогда
			
			Запрос.Текст=Запрос.Текст+"
			|И ТаблицаАналитики.НСИ_ТребуетСинхронизации";
			
		КонецЕсли;
			
	КонецЕсли;
		
	ТаблицаИсходныхЭлементов=Запрос.Выполнить().Выгрузить();
	ТаблицаДублирующихЭлементов=ТаблицаИсходныхЭлементов.СкопироватьКолонки();
	
	ТаблицаИсходныхЭлементов.Колонки.Добавить("КоличествоДублей",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповЧисла(4));
	ТаблицаДублирующихЭлементов.Колонки.Добавить("ИсходныйЭлемент",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСсылка(СтрЗаменить(ТаблицаАналитики,"Справочник.","СправочникСсылка.")));
	
	Если НЕ (СпособОбработки=1 ИЛИ СпособОбработки=4) Тогда
		
		ТаблицаДублирующихЭлементов.Колонки.Добавить("НСИ_ЭталонныйЭлемент",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСсылка(СтрЗаменить(ТаблицаАналитики,"Справочник.","СправочникСсылка.")));
		ТаблицаДублирующихЭлементов.Колонки.Добавить("НСИ_ВИБ",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСсылка("СправочникСсылка.ВнешниеИнформационныеБазы"));
		
	КонецЕсли;	
	
	Для Каждого СтрЭлемент ИЗ ТаблицаИсходныхЭлементов Цикл
		
		//Проверим - есть ли текущий элемент в списке уже найденных дублей?
		//если есть, то нет смысла по нему проводить аналогичную проверку, т.к. результаты в итоговом списке задублируются
		Строка = ТаблицаДублирующихЭлементов.Найти(СтрЭлемент.Ссылка, "Ссылка");
		Если Строка = Неопределено Тогда
			
			Если ВариантПоиска="И" Тогда
				
				НайтиДублирующиеЭлементыПоИ(СтрЭлемент);
				
			Иначе
			
			НайтиДублирующиеЭлементыПоИли(СтрЭлемент);
			
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Объекты, по которым не найдено дублирующих, убираем из списка
	
	МассивУникальных=ТаблицаИсходныхЭлементов.НайтиСтроки(Новый Структура("КоличествоДублей",0));
	
	Для Каждого Строка ИЗ МассивУникальных Цикл
		
		ТаблицаИсходныхЭлементов.Удалить(Строка);
		
	КонецЦикла;	
		
	ТаблицаИсходныхЭлементов.Сортировать("КоличествоДублей Убыв");	
		
КонецПроцедуры // ВыполнитьПоискДублей() 

Процедура НайтиДублирующиеЭлементыПоИли(СтрЭлемент)
	
	ЗапросРеквизиты.МенеджерВременныхТаблиц=Новый МенеджерВременныхТаблиц;
	
	ТекущаяЦенность=1;
	ШагЦенности=1/ТаблицаРеквизитовДляПоиска.Количество();
	
	ТекстЗапросаРеквизиты="";
	ТекстОбъединение="";
	ПервыйЭлемент=Истина;
	
	Для Каждого СтрРеквизит ИЗ ТаблицаРеквизитовДляПоиска Цикл
		
		Если (Не СтрРеквизит.Отображать) 
			ИЛИ СтрРеквизит.СпособПоиска="" 
			ИЛИ (НЕ (ЗначениеЗаполнено(СтрЭлемент[СтрРеквизит.ИмяРеквизита]) ИЛИ УчитыватьНезаполненные))Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрРеквизит.СпособПоиска="Значение" ИЛИ СтрРеквизит.СпособПоиска="Вхождение" Тогда
			
			ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
			|ВЫБРАТЬ
			|ТаблицаАналитики_"+СтрРеквизит.ИмяРеквизита+".Ссылка КАК Ссылка,
			|&Важность_"+СтрРеквизит.ИмяРеквизита+" КАК Важность
			|ПОМЕСТИТЬ ТаблицаАналитики_"+СтрРеквизит.ИмяРеквизита+"
			|ИЗ "+ТаблицаАналитики+" КАК ТаблицаАналитики_"+СтрРеквизит.ИмяРеквизита+"
			|ГДЕ ИСТИНА //(НЕ ТаблицаАналитики_"+СтрРеквизит.ИмяРеквизита+".ПометкаУдаления)";
			
			ЗапросРеквизиты.УстановитьПараметр("Важность_"+СтрРеквизит.ИмяРеквизита,ТекущаяЦенность);	
			
			Если СтрРеквизит.СпособПоиска="Значение" Тогда
				
				ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
				|И ТаблицаАналитики_"+СтрРеквизит.ИмяРеквизита+"."+СтрРеквизит.ИмяРеквизита+" = &"+СтрРеквизит.ИмяРеквизита+"
				|И НЕ ТаблицаАналитики_"+СтрРеквизит.ИмяРеквизита+".Ссылка=&ИсходныйЭлемент";
				
				ЗапросРеквизиты.УстановитьПараметр(СтрРеквизит.ИмяРеквизита,СтрЭлемент[СтрРеквизит.ИмяРеквизита]);
				
			Иначе
				
				ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
				|И ТаблицаАналитики_"+СтрРеквизит.ИмяРеквизита+"."+СтрРеквизит.ИмяРеквизита+" ПОДОБНО &"+СтрРеквизит.ИмяРеквизита+"
				|И НЕ ТаблицаАналитики_"+СтрРеквизит.ИмяРеквизита+".Ссылка=&ИсходныйЭлемент";
				
				Если СпособОбработки<4 Тогда
					
					ЗапросРеквизиты.УстановитьПараметр(СтрРеквизит.ИмяРеквизита,СтрРеквизит.УточнениеСпособаПоиска+"%");
					
				Иначе
					
					ЗапросРеквизиты.УстановитьПараметр(СтрРеквизит.ИмяРеквизита,""+СтрЭлемент[СтрРеквизит.ИмяРеквизита]+"%");
					
				КонецЕсли;
				
			КонецЕсли;
			
			Если ЕстьРеквизитыНСИ Тогда
				
				Если СпособОбработки=1 ИЛИ СпособОбработки=4 Тогда
					ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
					|И (НЕ ТаблицаАналитики_"+СтрРеквизит.ИмяРеквизита+".НСИ_ТребуетСинхронизации)";
				Иначе
					ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
					|И ТаблицаАналитики_"+СтрРеквизит.ИмяРеквизита+".НСИ_ТребуетСинхронизации";
				КонецЕсли;
				
			КонецЕсли;
					
			ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
			|;";
			
		Иначе
			
			МассивВариантов=Новый Массив;
			
			Для Каждого СтрСпособ ИЗ СтрРеквизит.СписокНастройки Цикл
				
				Если СтрСпособ.Пометка Тогда
					
					МассивВариантов.Добавить(СтрСпособ.Значение);
					
				КонецЕсли;
				
			КонецЦикла;
			
			Если МассивВариантов.Количество()>0 Тогда
				
				ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
				|ВЫБРАТЬ Первые 50
				|ТаблицаАналитики_"+СтрРеквизит.ИмяРеквизита+".Ссылка,
				|ТаблицаАналитики_"+СтрРеквизит.ИмяРеквизита+".Важность
				|ПОМЕСТИТЬ ТаблицаАналитики_"+СтрРеквизит.ИмяРеквизита+"
				|ИЗ &ТаблицаАналитики_"+СтрРеквизит.ИмяРеквизита+" КАК ТаблицаАналитики_"+СтрРеквизит.ИмяРеквизита;
				
				ЗапросРеквизиты.УстановитьПараметр("ТаблицаАналитики_"+СтрРеквизит.ИмяРеквизита,ПолучитьТаблицуПолнотекстовогоПоиска(МассивВариантов,СтрРеквизит.ИмяРеквизита,""+СтрЭлемент[СтрРеквизит.ИмяРеквизита],СтрЭлемент.Ссылка));
				
				ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
				|;";
				
			КонецЕсли;
			
		КонецЕсли;
		
		ТекущаяЦенность=ТекущаяЦенность-ШагЦенности;
		
		ТекстОбъединение=ТекстОбъединение+"
		|ОБЪЕДИНИТЬ ВСЕ
		|ВЫБРАТЬ
		|Ссылка,
		|Важность
		|ИЗ ТаблицаАналитики_"+СтрРеквизит.ИмяРеквизита; 
		
	КонецЦикла;
	
	Если ТекстОбъединение="" Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСумма="ВЫБРАТЬ Первые 50
	|Ссылка,
	|Сумма(Важность)
	|Поместить ТабСсылкиСвод
	|ИЗ
	|("+Сред(ТекстОбъединение,16)+") КАК ТабСуммирование
	|Сгруппировать ПО Ссылка
	|УПОРЯДОЧИТЬ ПО Сумма(Важность) УБЫВ";
	
	ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
	|//////////////////////////////////////////////////////////////
	|"+ТекстСумма+"
	|;
	|////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ";
	
	Для Каждого СтрРеквизит ИЗ ТаблицаРеквизитовДляПоиска Цикл
		
		Если Не СтрРеквизит.Отображать Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
		|ТаблицаАналитики."+СтрРеквизит.ИмяРеквизита+ " КАК "+СтрРеквизит.ИмяРеквизита+",";
		
	КонецЦикла;
	
	ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
	|ТаблицаАналитики.Ссылка КАК Ссылка,
	|&ИсходныйЭлемент КАК ИсходныйЭлемент,";
		
	Если НЕ (СпособОбработки=1 ИЛИ СпособОбработки=4) Тогда
		
		ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
		|ТаблицаАналитики.НСИ_ЭталонныйЭлемент,";
		
		ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
		|ТаблицаАналитики.НСИ_ВИБ,";
	
	КонецЕсли;
	
	ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
	|ТабСсылкиСвод.Важность
	|ИЗ "+ТаблицаАналитики+" КАК ТаблицаАналитики";
		
	ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТабСсылкиСвод КАК ТабСсылкиСвод
	|ПО ТаблицаАналитики.Ссылка=ТабСсылкиСвод.Ссылка";
	
	Если ЕстьРеквизитыНСИ Тогда
		
		Если СпособОбработки=1 ИЛИ СпособОбработки=4 Тогда
			
			ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
			|ГДЕ (НЕ ТаблицаАналитики.НСИ_ТребуетСинхронизации)";
			
		Иначе
			
			ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
			|ГДЕ ТаблицаАналитики.НСИ_ТребуетСинхронизации";
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТаблицаАналитики="Справочник.ПроизвольныйКлассификаторУХ" Тогда
		
		ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+" И ТаблицаАналитики.Владелец=&Владелец";
		ЗапросРеквизиты.УстановитьПараметр("Владелец",ИмяОбъектаМетаданных);
		
	КонецЕсли;
	
	ЗапросРеквизиты.Текст=ТекстЗапросаРеквизиты;
	
	ЗапросРеквизиты.УстановитьПараметр("ИсходныйЭлемент",СтрЭлемент.Ссылка);	
		
	ТекТаблицаДублей=ЗапросРеквизиты.Выполнить().Выгрузить();
			
	СтрЭлемент.КоличествоДублей=ТекТаблицаДублей.Количество();	
	ОбщегоНазначенияУХ.ЗагрузитьВТаблицуЗначений(ТекТаблицаДублей,ТаблицаДублирующихЭлементов);
					
КонецПроцедуры // НайтиДублирующиеЭлементы(СтрЭлемент)

Процедура НайтиДублирующиеЭлементыПоИ(СтрЭлемент)
	
	ЗапросРеквизиты.МенеджерВременныхТаблиц=Новый МенеджерВременныхТаблиц;
		
	ТекстЗапросаРеквизиты="ВЫБРАТЬ Первые 50
	|Ссылка,
	|1 КАК ВАжность
	|Поместить ТабСсылкиСвод
	|ИЗ
	|"+ТаблицаАналитики+" КАК ТаблицаАналитики
	|ГДЕ НЕ ТаблицаАналитики.Ссылка=&ИсходныйЭлемент";
	
	Если ЕстьРеквизитыНСИ Тогда
		
		Если СпособОбработки=1 ИЛИ СпособОбработки=4 Тогда
			ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
			|И (НЕ ТаблицаАналитики.НСИ_ТребуетСинхронизации)";
		Иначе
			ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
			|И ТаблицаАналитики.НСИ_ТребуетСинхронизации";
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого СтрРеквизит ИЗ ТаблицаРеквизитовДляПоиска Цикл
		
		Если (Не СтрРеквизит.Отображать) 
			ИЛИ СтрРеквизит.СпособПоиска="" 
			ИЛИ (НЕ (ЗначениеЗаполнено(СтрЭлемент[СтрРеквизит.ИмяРеквизита]) ИЛИ УчитыватьНезаполненные))Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрРеквизит.СпособПоиска="Значение" ИЛИ СтрРеквизит.СпособПоиска="Вхождение" Тогда	
			
			Если СтрРеквизит.СпособПоиска="Значение" Тогда
				
				ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
				|И ТаблицаАналитики."+СтрРеквизит.ИмяРеквизита+" = &"+СтрРеквизит.ИмяРеквизита;
								
				ЗапросРеквизиты.УстановитьПараметр(СтрРеквизит.ИмяРеквизита,СтрЭлемент[СтрРеквизит.ИмяРеквизита]);
				
			Иначе
				
				ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
				|И ТаблицаАналитики."+СтрРеквизит.ИмяРеквизита+" ПОДОБНО &"+СтрРеквизит.ИмяРеквизита;
				
				Если СпособОбработки<4 Тогда
					
					ЗапросРеквизиты.УстановитьПараметр(СтрРеквизит.ИмяРеквизита,СтрРеквизит.УточнениеСпособаПоиска+"%");
					
				Иначе
					
					ЗапросРеквизиты.УстановитьПараметр(СтрРеквизит.ИмяРеквизита,""+СтрЭлемент[СтрРеквизит.ИмяРеквизита]+"%");
					
				КонецЕсли;
				
			КонецЕсли;
						
		Иначе
			
			МассивВариантов=Новый Массив;
			
			Для Каждого СтрСпособ ИЗ СтрРеквизит.СписокНастройки Цикл
				
				Если СтрСпособ.Пометка Тогда
					
					МассивВариантов.Добавить(СтрСпособ.Значение);
					
				КонецЕсли;
				
			КонецЦикла;
			
			Если МассивВариантов.Количество()>0 Тогда
				
				ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
				|И ТаблицаАналитики.Ссылка В (&МассивПолноТекстовогоПоиска)";
				
				ТаблицаПолнотекстовогоПоиска=ПолучитьТаблицуПолнотекстовогоПоиска(МассивВариантов,СтрРеквизит.ИмяРеквизита,""+СтрЭлемент[СтрРеквизит.ИмяРеквизита],СтрЭлемент.Ссылка);
				ЗапросРеквизиты.УстановитьПараметр("МассивПолноТекстовогоПоиска",ТаблицаПолнотекстовогоПоиска.ВыгрузитьКолонку("Ссылка"));
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
			
	ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
	|;
	|////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ";
	
	Для Каждого СтрРеквизит ИЗ ТаблицаРеквизитовДляПоиска Цикл
		
		Если Не СтрРеквизит.Отображать Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
		|ТаблицаАналитики."+СтрРеквизит.ИмяРеквизита+ " КАК "+СтрРеквизит.ИмяРеквизита+",";
		
	КонецЦикла;
	
	ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
	|ТаблицаАналитики.Ссылка КАК Ссылка,
	|&ИсходныйЭлемент КАК ИсходныйЭлемент,";
		
	Если НЕ (СпособОбработки=1 ИЛИ СпособОбработки=4) Тогда
		
		ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
		|ТаблицаАналитики.НСИ_ЭталонныйЭлемент,";
		
		ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
		|ТаблицаАналитики.НСИ_ВИБ,";
	
	КонецЕсли;
	
	ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
	|ТабСсылкиСвод.Важность
	|ИЗ "+ТаблицаАналитики+" КАК ТаблицаАналитики";
		
	ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТабСсылкиСвод КАК ТабСсылкиСвод
	|ПО ТаблицаАналитики.Ссылка=ТабСсылкиСвод.Ссылка";
	
	Если ЕстьРеквизитыНСИ Тогда
		
		Если СпособОбработки=1 ИЛИ СпособОбработки=4 Тогда
			
			ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
			|ГДЕ (НЕ ТаблицаАналитики.НСИ_ТребуетСинхронизации)";
			
		Иначе
			
			ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+"
			|ГДЕ ТаблицаАналитики.НСИ_ТребуетСинхронизации";
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТаблицаАналитики="Справочник.ПроизвольныйКлассификаторУХ" Тогда
		
		ТекстЗапросаРеквизиты=ТекстЗапросаРеквизиты+" И ТаблицаАналитики.Владелец=&Владелец";
		ЗапросРеквизиты.УстановитьПараметр("Владелец",ИмяОбъектаМетаданных);
		
	КонецЕсли;
	
	ЗапросРеквизиты.Текст=ТекстЗапросаРеквизиты;
	
	ЗапросРеквизиты.УстановитьПараметр("ИсходныйЭлемент",СтрЭлемент.Ссылка);	
		
	ТекТаблицаДублей=ЗапросРеквизиты.Выполнить().Выгрузить();
			
	СтрЭлемент.КоличествоДублей=ТекТаблицаДублей.Количество();	
	ОбщегоНазначенияУХ.ЗагрузитьВТаблицуЗначений(ТекТаблицаДублей,ТаблицаДублирующихЭлементов);
					
КонецПроцедуры // НайтиДублирующиеЭлементы(СтрЭлемент)

Функция ПолучитьТаблицуПолнотекстовогоПоиска(МассивВариантов, ИмяРеквизита, ТекстДляПоиска, ИсходныйЭлемент)
	
	ТекстДляПоиска=СтрЗаменить(ТекстДляПоиска,"""","");
	
	ТекТаблицаПоиска=Новый ТаблицаЗначений;
	ТекТаблицаПоиска.Колонки.Добавить("Ссылка",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСсылка(СтрЗаменить(ТаблицаАналитики,"Справочник.","СправочникСсылка.")));
	ТектаблицаПоиска.Колонки.Добавить("Важность",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповЧисла(2));
	
	Если ПустаяСтрока(ТекстДляПоиска) Тогда
		Возврат ТектаблицаПоиска;
	КонецЕсли;
		
	ТекОбъектМД=Метаданные.Справочники[СтрЗаменить(ТаблицаАналитики,"Справочник.","")];
	
	МассивОтбор=Новый Массив;
	МассивОтбор.Добавить(ТекОбъектМД);
	
	МассивСлов=ОбщегоНазначенияУХ.РазложитьСтрокуВМассивПодстрок(ТекстДляПоиска," ");
		
	ТекущаяЦенность=1;
	ШагЦенности=1/МассивВариантов.Количество();
	
	Для Каждого ВариантПоиска ИЗ МассивВариантов Цикл
		
		Если ВариантПоиска="ТочноеСовпадение" Тогда
			
			СтрокаПоиска=""""+ТекстДляПоиска+"""";
			
		ИначеЕсли ВариантПоиска="ВсеСлова" Тогда
			
			СтрокаПоиска=ТекстДляПоиска;
			
		ИначеЕсли ВариантПоиска="ХотяБыОдно" Тогда
			
			ТекСтрока="";
			
			Для Каждого СловоПоиска ИЗ МассивСлов Цикл
				
				ТекСтрока=ТекСтрока+" ИЛИ "+СловоПоиска;
				
			КонецЦикла;
			
			СтрокаПоиска=Сред(ТекСтрока,6);
			
		ИначеЕсли ВариантПоиска="НечеткийПоиск" Тогда
			
			ТекСтрока="";
			
			Для Каждого СловоПоиска ИЗ МассивСлов Цикл
				
				ТекСтрока=ТекСтрока+" #"+СловоПоиска;
				
			КонецЦикла;
			
			СтрокаПоиска=Сред(ТекСтрока,2);
			
		ИначеЕсли ВариантПоиска="ПоискСинонимов" Тогда
			
			ТекСтрока="";
			
			Для Каждого СловоПоиска ИЗ МассивСлов Цикл
				
				ТекСтрока=ТекСтрока+" !"+СловоПоиска;
				
			КонецЦикла;
			
			СтрокаПоиска=Сред(ТекСтрока,2);
			
		КонецЕсли;
				
		СписокПоиска=ПолнотекстовыйПоиск.СоздатьСписок(СтрокаПоиска,50);
		СписокПоиска.ОбластьПоиска=МассивОтбор;
		СписокПоиска.ПолучатьОписание=Истина;
		СписокПоиска.ИспользованиеМетаданных = ИспользованиеМетаданныхПолнотекстовогоПоиска.НеИспользовать;
		
		Попытка
			
			СписокПоиска.ПерваяЧасть();
			
			Для Каждого СтрРезультат ИЗ СписокПоиска Цикл
				
				Если СтрРезультат.Значение=ИсходныйЭлемент ИЛИ (НЕ СтрРезультат.Метаданные=ТекОбъектМД) 
					//ИЛИ СтрРезультат.Значение.ПометкаУдаления
					Тогда
					
					Продолжить;
					
				КонецЕсли;
				
				РеквизитОбъекта=Лев(СтрРезультат.Описание, СтрНайти(СтрРезультат.Описание,":")-1);
				
				Если Не РеквизитОбъекта=ИмяРеквизита Тогда
					
					Продолжить;
					
				КонецЕсли;
				
				Если ЕстьРеквизитыНСИ Тогда
					
					Если СпособОбработки=1 ИЛИ СпособОбработки=4 Тогда
						Если СтрРезультат.Значение.НСИ_ТребуетСинхронизации Тогда
							Продолжить;
						КонецЕсли;
					Иначе
						Если НЕ СтрРезультат.Значение.НСИ_ТребуетСинхронизации Тогда
							Продолжить;
						КонецЕсли;	
					КонецЕсли;
					
				КонецЕсли;
				
				НоваяСтрока=ТекТаблицаПоиска.Добавить();
				НоваяСтрока.Ссылка=СтрРезультат.Значение;
				НоваяСтрока.Важность=ТекущаяЦенность;
				
			КонецЦикла;
			
		Исключение
			
		КонецПопытки;
		
		ТекущаяЦенность=ТекущаяЦенность-ШагЦенности;
		
	КонецЦикла;
	
	ТекТаблицаПоиска.Свернуть("Ссылка","Важность");
	ТекТаблицаПоиска.Сортировать("Важность УБЫВ");
	
	Возврат ТекТаблицаПоиска; 
	
КонецФункции // ПолучитьТаблицуПолнотекстовогоПоиска() 

