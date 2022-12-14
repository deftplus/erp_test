#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область ПрограммныйИнтерфейс

Функция ПолучитьТаблицуГрафикаОпераций(НастройкаОбъект) Экспорт
	
	ТаблицаГрафика=НастройкаОбъект.ГрафикиОпераций.ВыгрузитьКолонки();
	ТекущаяЗадолженность=0;
		
	// Добавляем в таблицу разовые операции
	
	МассивРазовыхОпераций=НастройкаОбъект.ПериодическиеОперации.НайтиСтроки(Новый Структура("ИспользованиеЗначения",Перечисления.СпособыИспользованияЗначенияПериодическойОперации.РазоваяОперация));
	
	Для Каждого Строка ИЗ МассивРазовыхОпераций Цикл
		
		НоваяСтрока=ТаблицаГрафика.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка);
		
		НоваяСтрока.СуммаОперации	=Строка.Значение;
		НоваяСтрока.ДатаОперации	=Строка.ДатаНачала;
		
		ТекущаяЗадолженность=?(Строка.ПриходРасход=Перечисления.ВидыДвиженийПриходРасход.Приход,ТекущаяЗадолженность+НоваяСтрока.СуммаОперации,ТекущаяЗадолженность-НоваяСтрока.СуммаОперации);	
		
		НоваяСтрока.ТекущаяЗадолженность=ОбщегоНазначенияУХ.ЗначениеПоМодулю(ТекущаяЗадолженность);
		
	КонецЦикла;
	
	// Добавляем в таблицу периодические операции
	
	МассивПериодическихОпераций=НастройкаОбъект.ПериодическиеОперации.НайтиСтроки(Новый Структура("ИспользованиеЗначения",Перечисления.СпособыИспользованияЗначенияПериодическойОперации.ПериодическаяОперация));
	
	Для Каждого СтрокаОперации ИЗ МассивПериодическихОпераций Цикл
		
		ГрафикОпераций=ПолучитьГрафикПериодическихОпераций(СтрокаОперации.ДатаНачала,СтрокаОперации.ДатаОкончания,СтрокаОперации.СпособРасчета,НастройкаОбъект.Календарь);
		
		Для Каждого СтрокаГрафика ИЗ ГрафикОпераций Цикл
			
			НоваяСтрока=ТаблицаГрафика.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаОперации);
			
			НоваяСтрока.СуммаОперации	= СтрокаГрафика.Доля*СтрокаОперации.Значение;
			НоваяСтрока.ДатаОперации	= СтрокаГрафика.ДатаОперации;
			
			ТекущаяЗадолженность=?(СтрокаОперации.ПриходРасход=Перечисления.ВидыДвиженийПриходРасход.Приход,ТекущаяЗадолженность+НоваяСтрока.СуммаОперации,ТекущаяЗадолженность-НоваяСтрока.СуммаОперации);
			
		КонецЦикла;
		                                             
	КонецЦикла;
	
	ТаблицаГрафика.Сортировать("ДатаОперации");
	
	// Добавляем в таблицу расчетные операции
	
	МассивПериодическихОпераций=НастройкаОбъект.ПериодическиеОперации.НайтиСтроки(Новый Структура("ИспользованиеЗначения",Перечисления.СпособыИспользованияЗначенияПериодическойОперации.БазаДляРасчетаПериодическихОпераций));
	
	Для Каждого СтрокаОперации ИЗ МассивПериодическихОпераций Цикл
		
		ГрафикОпераций=ПолучитьГрафикПериодическихОпераций(СтрокаОперации.ДатаНачала,СтрокаОперации.ДатаОкончания,СтрокаОперации.СпособРасчета.СпособРасчетаГрафикаОпераций,НастройкаОбъект.Календарь);
		ГрафикОпераций.Колонки.Добавить("Ставка",			ОбщегоНазначенияУХ.ПолучитьОписаниеТиповЧисла(18,5));
		ГрафикОпераций.Колонки.Добавить("ДатаНачала",		ОбщегоНазначенияУХ.ПолучитьОписаниеТиповДаты(ЧастиДаты.Дата));
		ГрафикОпераций.Колонки.Добавить("ДатаОкончания",	ОбщегоНазначенияУХ.ПолучитьОписаниеТиповДаты(ЧастиДаты.Дата));
		ГрафикОпераций.Колонки.Добавить("Продолжительность",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповЧисла(10));
		ГрафикОпераций.Колонки.Добавить("БазаДляРасчета",	ОбщегоНазначенияУХ.ПолучитьОписаниеТиповЧисла(18,5));
		ГрафикОпераций.Колонки.Добавить("СуммаОперации",	ОбщегоНазначенияУХ.ПолучитьОписаниеТиповЧисла(18,5));
		ГрафикОпераций.Колонки.Добавить("СпособРасчета");
		
		ГрафикОпераций.ЗаполнитьЗначения(СтрокаОперации.СпособРасчета,"СпособРасчета");
		
		Для Каждого СтрокаДвижение ИЗ ТаблицаГрафика Цикл
			
			Если НЕ (СтрокаДвижение.ДатаОперации=СтрокаОперации.ДатаНачала ИЛИ СтрокаДвижение.ДатаОперации=СтрокаОперации.ДатаОкончания) Тогда
				
				НоваяСтрока=ГрафикОпераций.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаДвижение);
				НоваяСтрока.Доля=1;
				
			КонецЕсли;
			
		КонецЦикла;		
		
		ГрафикОпераций.Сортировать("ДатаОперации");
		
		Для Индекс=0 ПО ГрафикОпераций.Количество()-1  Цикл
			
			СтрокаГрафика=ГрафикОпераций[Индекс];
			
			Если Индекс=0 Тогда
				
				СтрокаГрафика.ДатаНачала		= СтрокаОперации.ДатаНачала;
				СтрокаГрафика.ДатаОкончания		= ОбщегоНазначенияУХ.ДатаКонцаПериода(СтрокаГрафика.ДатаОперации,СтрокаОперации.СпособРасчета.СпособРасчетаГрафикаОпераций.Периодичность);
					
			ИначеЕсли СтрокаГрафика.ДатаОперации>СтрокаОперации.ДатаОкончания Тогда
				
				СтрокаГрафика.ДатаОперации=СтрокаОперации.ДатаОкончания;
				СтрокаГрафика.ДатаНачала		= ОбщегоНазначенияУХ.ДатаНачалаПериода(СтрокаГрафика.ДатаОперации,СтрокаОперации.СпособРасчета.СпособРасчетаГрафикаОпераций.Периодичность);
				СтрокаГрафика.ДатаОкончания		= СтрокаОперации.ДатаОкончания;
				
			ИначеЕсли НЕ СтрокаГрафика.СпособРасчета=СтрокаОперации.СпособРасчета Тогда
				
				СтрокаГрафика.ДатаНачала		= ОбщегоНазначенияУХ.ДатаНачалаПериода(СтрокаГрафика.ДатаОперации,СтрокаОперации.СпособРасчета.СпособРасчетаГрафикаОпераций.Периодичность);
				СтрокаГрафика.ДатаОкончания		= СтрокаГрафика.ДатаОперации;
									
			Иначе
				
				СтрокаГрафика.ДатаНачала		= ОбщегоНазначенияУХ.ДатаНачалаПериода(СтрокаГрафика.ДатаОперации,СтрокаОперации.СпособРасчета.СпособРасчетаГрафикаОпераций.Периодичность);
				СтрокаГрафика.ДатаОкончания		= ОбщегоНазначенияУХ.ДатаКонцаПериода(СтрокаГрафика.ДатаОперации,СтрокаОперации.СпособРасчета.СпособРасчетаГрафикаОпераций.Периодичность);
								
			КонецЕсли;
			
			Если СтрокаОперации.СпособРасчета.СпособРасчетаГрафикаОпераций.СпособРасчетаКоличестваДней=Перечисления.СпособыРасчетаКоличестваДнейВПериоде.ПоКалендарнымДням Тогда
				
				СтрокаГрафика.Продолжительность=ЧислоКалендарныхДней(СтрокаГрафика.ДатаНачала-24*3600,СтрокаГрафика.ДатаОкончания,НастройкаОбъект.Календарь);
				
			Иначе
				
				СтрокаГрафика.Продолжительность=ЧислоРабочихДней(СтрокаГрафика.ДатаНачала-24*3600,СтрокаГрафика.ДатаОкончания,НастройкаОбъект.Календарь);
				
			КонецЕсли;
			
			ЗаполнитьСтрокуПериодическойОперации(НастройкаОбъект,СтрокаГрафика,ТаблицаГрафика,СтрокаОперации,ГрафикОпераций.Индекс(СтрокаГрафика)+1);
			
		КонецЦикла;
			
		Для Каждого СтрокаГрафика ИЗ ГрафикОпераций Цикл
			
			НоваяСтрока=ТаблицаГрафика.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаОперации);
			ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаГрафика,,"СпособРасчета");
						
		КонецЦикла;
		                                             
	КонецЦикла;	
	
	ТаблицаГрафика.Сортировать("ДатаОперации");
	
	Возврат ТаблицаГрафика;
	
КонецФункции // ПолучитьТаблицуГрафикаОпераций() 

Функция ЧислоДнейГода(ДатаГода,СпособРасчетаДней)
	
	Если СпособРасчетаДней=Справочники.СпособыРасчетаДнейПериодическихОпераций.Год360Месяц30
		ИЛИ СпособРасчетаДней=Справочники.СпособыРасчетаДнейПериодическихОпераций.Год360МесяцФакт Тогда
		
		Возврат 360;
		
	ИначеЕсли СпособРасчетаДней.ПоФактуГод 
		ИЛИ СпособРасчетаДней=Справочники.СпособыРасчетаДнейПериодическихОпераций.ГодФактМесяц30
		ИЛИ СпособРасчетаДней=Справочники.СпособыРасчетаДнейПериодическихОпераций.ГодФактМесяцФакт Тогда
		
		Возврат ОбщегоНазначенияКлиентСерверУХ.РазностьДатВДнях(КонецГода(ДатаГода),НачалоГода(ДатаГода));
		
	Иначе 
		
		Возврат ?(СпособРасчетаДней.ДнейВГоду=0,365,СпособРасчетаДней.ДнейВГоду);
		
	КонецЕсли;
		
КонецФункции // ЧислоДнейГода() 

Функция ПолучитьЗначениеПлавающейСтавки(ДатаРасчета,Параметр,ДоговорКонтрагента,Валюта) Экспорт
	
	Запрос=Новый Запрос;
	
	ТекстОтбора="ПараметрДляРасчета = &ПараметрДляРасчета";
	
	Если Параметр.РазделениеПоДоговорам Тогда
		
		ТекстОтбора=ТекстОтбора+" И ДоговорКонтрагента=&ДоговорКонтрагента";
		Запрос.УстановитьПараметр("ДоговорКонтрагента",ДоговорКонтрагента);
		
	КонецЕсли;
	
	Если Параметр.РазделениеПоВалютам Тогда
		
		ТекстОтбора=ТекстОтбора+" И Валюта=&Валюта";
		Запрос.УстановитьПараметр("Валюта",Валюта);
		
	КонецЕсли;
	
	Запрос.Текст="ВЫБРАТЬ
	|	ЗначенияПараметровДляРасчетаПериодическихОперацийСрезПоследних.ЗначениеПараметра
	|ИЗ
	|	РегистрСведений.ЗначенияПараметровДляРасчетаПериодическихОпераций.СрезПоследних(&ДатаРасчета,"+ТекстОтбора+") КАК ЗначенияПараметровДляРасчетаПериодическихОперацийСрезПоследних";
	
	Запрос.УстановитьПараметр("ДатаРасчета",ДатаРасчета);
	Запрос.УстановитьПараметр("ПараметрДляРасчета",Параметр);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		
		Возврат Результат.ЗначениеПараметра;
		
	Иначе
		
		Возврат 0;
		
	КонецЕсли;
		
КонецФункции // ПолучитьЗначениеПлавающейСтавки()
	

Функция ПолучитьГрафикПериодическихОпераций(ДатаНачала,ДатаОкончания,СпособРасчетаГрафика,ПроизводственныйКалендарь) Экспорт
	
	ТаблицаГрафика=Новый ТаблицаЗначений;
	ТаблицаГрафика.Колонки.Добавить("ДатаОперации",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповДаты(ЧастиДаты.Дата));
	ТаблицаГрафика.Колонки.Добавить("Доля",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповЧисла(8,5));
	
	КонецНулевогоПериода=ОбщегоНазначенияУХ.ДатаКонцаПериода(ДатаНачала,СпособРасчетаГрафика.Периодичность);
	НачалоПервогоПериода=КонецНулевогоПериода+24*3600;
	
	Если СпособРасчетаГрафика.СпособРасчетаДатыПервойОперации=Перечисления.СпособыРасчетаДатыПервойПоследнейОперации.ОтДатыНачалаДействия Тогда
		
		НоваяСтрока=ТаблицаГрафика.Добавить();
		
		ДатаОперацииРасчет=ОпределитьДатуОперацииПоДатеВПериоде(ДатаНачала,СпособРасчетаГрафика,ПроизводственныйКалендарь);
		
		НоваяСтрока.ДатаОперации=?(ДатаОперацииРасчет>=ДатаНачала,ДатаОперацииРасчет,ДатаНачала);
		НоваяСтрока.Доля=ОпределитьДолюОперации(ДатаНачала,КонецНулевогоПериода,СпособРасчетаГрафика,ПроизводственныйКалендарь);
		
	Иначе
		
		НоваяСтрока=ТаблицаГрафика.Добавить();
		НоваяСтрока.ДатаОперации=ОпределитьДатуОперацииПоДатеВПериоде(НачалоПервогоПериода,СпособРасчетаГрафика,ПроизводственныйКалендарь);
		НоваяСтрока.Доля=1;
		
	КонецЕсли;
	
	КонецПоследнегоПериода=ОбщегоНазначенияУХ.ДатаКонцаПериода(ДатаОкончания,СпособРасчетаГрафика.Периодичность);
	
	Если СпособРасчетаГрафика.СпособРасчетаДатыПоследнейОперации=Перечисления.СпособыРасчетаДатыПервойПоследнейОперации.ОтДатыОкончанияДействия Тогда
		
		НоваяСтрока=ТаблицаГрафика.Добавить();
		
		ДатаОперацииРасчет=ОпределитьДатуОперацииПоДатеВПериоде(ДатаОкончания,СпособРасчетаГрафика,ПроизводственныйКалендарь);
		
		НоваяСтрока.ДатаОперации=?(ДатаОперацииРасчет<=ДатаОкончания,ДатаОперацииРасчет,ДатаОкончания);
		НоваяСтрока.Доля=1-ОпределитьДолюОперации(ДатаОкончания,КонецПоследнегоПериода,СпособРасчетаГрафика,ПроизводственныйКалендарь);
		
	Иначе
		
		НоваяСтрока=ТаблицаГрафика.Добавить();
		НоваяСтрока.ДатаОперации=ОпределитьДатуОперацииПоДатеВПериоде(КонецПоследнегоПериода,СпособРасчетаГрафика,ПроизводственныйКалендарь);
		НоваяСтрока.Доля=1;
		
	КонецЕсли;
	
	ДатаОперации=ОбщегоНазначенияУХ.ДобавитьИнтервал(ДатаНачала,СпособРасчетаГрафика.Периодичность,1);
	ДатаПоследнейОперации=НоваяСтрока.ДатаОперации;
	
	Пока Истина Цикл
		
		ТекДатаОперации=ОпределитьДатуОперацииПоДатеВПериоде(ДатаОперации,СпособРасчетаГрафика,ПроизводственныйКалендарь);
		
		Если ТекДатаОперации>=ДатаПоследнейОперации Тогда
			
			Прервать;
			
		КонецЕсли;
		
		Если ТаблицаГрафика.Найти(ТекДатаОперации,"ДатаОперации")=Неопределено Тогда
			
			НоваяСтрока=ТаблицаГрафика.Добавить();
			НоваяСтрока.ДатаОперации=ТекДатаОперации;		
			НоваяСтрока.Доля=1;
			
		КонецЕсли;
		
		ДатаОперации=ОбщегоНазначенияУХ.ДобавитьИнтервал(ДатаОперации,СпособРасчетаГрафика.Периодичность,1);
		
	КонецЦикла;
	
	ТаблицаГрафика.Сортировать("ДатаОперации");	
	
	Возврат ТаблицаГрафика;	
	
КонецФункции // ПолучитьГрафикПериодическихОпераций()

Функция ОпределитьДатуОперацииПоДатеВПериоде(ДатаВПериоде,СпособРасчетаГрафика,ПроизводственныйКалендарь) Экспорт
	
	Если СпособРасчетаГрафика.СпособОпределенияДатыОперации=Перечисления.СпособыОпределенияДатыОперацииПоПериоду.НачалоПериода Тогда
		
		ДатаОперации=ОбщегоНазначенияУХ.ДобавитьИнтервал(ОбщегоНазначенияУХ.ДатаНачалаПериода(ДатаВПериоде,СпособРасчетаГрафика.Периодичность),СпособРасчетаГрафика.ПериодичностьСдвигаПериодов,СпособРасчетаГрафика.СдвигПериодов);
		
	ИначеЕсли СпособРасчетаГрафика.СпособОпределенияДатыОперации=Перечисления.СпособыОпределенияДатыОперацииПоПериоду.НачалоСледующегоПериода Тогда
		
		ДатаОперации=ОбщегоНазначенияУХ.ДобавитьИнтервал(ОбщегоНазначенияУХ.ДатаКонцаПериода(ДатаВПериоде,СпособРасчетаГрафика.Периодичность)+24*3600,СпособРасчетаГрафика.ПериодичностьСдвигаПериодов,СпособРасчетаГрафика.СдвигПериодов);
		
	ИначеЕсли СпособРасчетаГрафика.СпособОпределенияДатыОперации=Перечисления.СпособыОпределенияДатыОперацииПоПериоду.ОкончаниеПериода Тогда
		
		ДатаОперации= ОбщегоНазначенияУХ.ДобавитьИнтервал(ОбщегоНазначенияУХ.ДатаКонцаПериода(ДатаВПериоде,СпособРасчетаГрафика.Периодичность),СпособРасчетаГрафика.ПериодичностьСдвигаПериодов,СпособРасчетаГрафика.СдвигПериодов);
		
	Иначе
		
		ДатаОперации= ДатаВПериоде;
		
	КонецЕсли;	
	
	Возврат НачалоДня(ПолучитьРабочийДень(ДатаОперации,СпособРасчетаГрафика.СпособПереносаОперацийСНеРабочегоДня,ПроизводственныйКалендарь));
		
КонецФункции // ОпределитьДатуОперацииПоДатеВПериоде()

Функция ОпределитьДолюОперации(ДатаВПериоде,ДатаКонцаПериода,СпособРасчетаГрафика,ПроизводственныйКалендарь) Экспорт
	
	Если СпособРасчетаГрафика.СпособРасчетаКоличестваДней=Перечисления.СпособыРасчетаКоличестваДнейВПериоде.ПоКалендарнымДням Тогда
		
		Возврат ЧислоКалендарныхДней(ДатаВПериоде,ДатаКонцаПериода,ПроизводственныйКалендарь)/ЧислоКалендарныхДней(ОбщегоНазначенияУХ.ДатаНачалаПериода(ДатаВПериоде,СпособРасчетаГрафика.Периодичность),ДатаКонцаПериода,ПроизводственныйКалендарь);
		
	Иначе
		
		Возврат ЧислоРабочихДней(ДатаВПериоде,ДатаКонцаПериода,ПроизводственныйКалендарь)/ЧислоРабочихДней(ОбщегоНазначенияУХ.ДатаНачалаПериода(ДатаВПериоде,СпособРасчетаГрафика.Периодичность),ДатаКонцаПериода,ПроизводственныйКалендарь);
		
	КонецЕсли;
	
КонецФункции // ОпределитьДолюОперации() 
	
	
Функция ПолучитьРабочийДень(ДатаОперации,СпособПереносаОпераций,ПроизводственныйКалендарь) Экспорт
	
	Если СпособПереносаОпераций=Перечисления.СпособыПереносаОперацийСНерабочегоДня.НеПереносить Тогда
		
		Возврат ДатаОперации;
		
	Иначе
		
		Возврат ОпределитьРабочуюДату(ДатаОперации,0,ПроизводственныйКалендарь,?(СпособПереносаОпераций=Перечисления.СпособыПереносаОперацийСНерабочегоДня.ПредыдущийРабочийДень,"<=",">="));
		
	КонецЕсли;
			
КонецФункции // ПолучитьРабочийДень()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСтрокуПериодическойОперации(НастройкаОбъект,СтрокаГрафика,ТаблицаГрафика,СтрокаОперации,НомерПериода)
	
	СтавкаДляРасчета=0;
	
	Если СтрокаОперации.СпособРасчета.ТипСтавки=Перечисления.ТипыСтавокДляРасчетаПериодическихОпераций.Фиксированная Тогда
		
		СтавкаДляРасчета=СтрокаОперации.СпособРасчета.Ставка;
		
	ИначеЕсли СтрокаОперации.СпособРасчета.ТипСтавки=Перечисления.ТипыСтавокДляРасчетаПериодическихОпераций.Дифференцированная Тогда
		
		ТаблицаСтавок=СтрокаОперации.СпособРасчета.ДифференцированныеСтавки.Выгрузить();
		ТаблицаСтавок.Сортировать("НомерПериода Убыв");
		
		Для Каждого Строка ИЗ ТаблицаСтавок Цикл
			
			Если Строка.НомерПериода<=НомерПериода Тогда
				
				СтавкаДляРасчета=Строка.ЗначениеПараметра;
				Прервать
				
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли СтрокаОперации.СпособРасчета.ТипСтавки=Перечисления.ТипыСтавокДляРасчетаПериодическихОпераций.Плавающая Тогда
		
		СтавкаДляРасчета=ПолучитьЗначениеПлавающейСтавки(СтрокаГрафика.ДатаОперации,СтрокаОперации.СпособРасчета.ПараметрДляРасчетаПлавающейСтавки,НастройкаОбъект.ДоговорКонтрагента,СтрокаОперации.Валюта);
		
	КонецЕсли;
	
	СтрокаГрафика.Ставка=СтавкаДляРасчета;
	СтавкаДляРасчета=СтавкаДляРасчета/?(СтрокаОперации.СпособРасчета.СтавкаАбсолютноеЗначение=1,1,100)*СтрокаГрафика.Продолжительность/ЧислоДнейГода(СтрокаГрафика.ДатаОкончания,СтрокаОперации.СпособРасчета.СпособРасчетаДней);
	
	Если СтрокаОперации.СпособРасчета.СпособРасчетаБазы=Перечисления.БазыДляРасчетаЗначенийПериодическихОпераций.ФиксированноеЗначение Тогда
		
		СтрокаГрафика.БазаДляРасчета=СтрокаОперации.Значение;
	   	СтрокаГрафика.СуммаОперации=СтрокаГрафика.БазаДляРасчета*СтавкаДляРасчета*СтрокаГрафика.Доля;
		Возврат;
		
	ИначеЕсли СтрокаОперации.СпособРасчета.СпособРасчетаБазы=Перечисления.БазыДляРасчетаЗначенийПериодическихОпераций.ОтСуммыСоглашения Тогда
		
		СтрокаГрафика.БазаДляРасчета=НастройкаОбъект.СуммаЛимита;
	   	СтрокаГрафика.СуммаОперации=СтрокаГрафика.БазаДляРасчета*СтавкаДляРасчета*СтрокаГрафика.Доля;
		Возврат;
		
	КонецЕсли;
	
	ТаблицаГрафика.Сортировать("ДатаОперации Убыв");
	
	Для Каждого Строка ИЗ ТаблицаГрафика Цикл
		
		Если Строка.ДатаОперации<=СтрокаГрафика.ДатаОперации И Строка.ТекущаяЗадолженность>0 Тогда
			
			Если СтрокаОперации.СпособРасчета.СпособРасчетаБазы=Перечисления.БазыДляРасчетаЗначенийПериодическихОпераций.ОтВыбранногоЛимита
				ИЛИ СтрокаОперации.СпособРасчета.СпособРасчетаБазы=Перечисления.БазыДляРасчетаЗначенийПериодическихОпераций.ОтОстаткаОсновногоДолга
				ИЛИ СтрокаОперации.СпособРасчета.СпособРасчетаБазы=Перечисления.БазыДляРасчетаЗначенийПериодическихОпераций.ОтСуммыОбщейЗадолженности Тогда
				
				СтрокаГрафика.БазаДляРасчета=Строка.ТекущаяЗадолженность;
				СтрокаГрафика.СуммаОперации=СтрокаГрафика.БазаДляРасчета*СтавкаДляРасчета*СтрокаГрафика.Доля;
				
			ИначеЕсли СтрокаОперации.СпособРасчета.СпособРасчетаБазы=Перечисления.БазыДляРасчетаЗначенийПериодическихОпераций.ОтНевыбранногоЛимита
				ИЛИ СтрокаОперации.СпособРасчета.СпособРасчетаБазы=Перечисления.БазыДляРасчетаЗначенийПериодическихОпераций.ОтСвободногоОстаткаЛимита Тогда
				
				СтрокаГрафика.БазаДляРасчета=НастройкаОбъект.СуммаЛимита-Строка.ТекущаяЗадолженность;
				
				Если СтрокаГрафика.БазаДляРасчета>0 Тогда
					
					СтрокаГрафика.СуммаОперации=СтрокаГрафика.БазаДляРасчета*СтавкаДляРасчета*СтрокаГрафика.Доля;
					
				КонецЕсли;
				
			КонецЕсли;
			
			Возврат;
			
		КонецЕсли;
		
	КонецЦикла;			
	
КонецПроцедуры // ЗаполнитьСтрокуПериодическойОперации()

// Функция возвращает число рабочих дней между заданными датами по регламентированному производственному календарю
//
//Параметры:
// ДатаНач      - начальная дата
// ДатаКон      - конечная дата
//
Функция ЧислоРабочихДней(ДатаНач, ДатаКон,ЗНАЧ ПроизводственныйКалендарь)
	
	Запрос = Новый  Запрос;
	
	Если НЕ ЗначениеЗаполнено(ПроизводственныйКалендарь) Тогда
		
		ПроизводственныйКалендарь=Константы.ПроизводственныйКалендарьПоУмолчанию.Получить();
		
	КонецЕсли;
	
	Если ДатаНач>ДатаКон Тогда
		
		Коэффициент=-1;	
		Запрос.УстановитьПараметр("ДатаНач",             ДатаКон);
		Запрос.УстановитьПараметр("ДатаКон",             ДатаНач);
		
	Иначе
		
		Коэффициент=1;
		Запрос.УстановитьПараметр("ДатаНач",             ДатаНач);
		Запрос.УстановитьПараметр("ДатаКон",             ДатаКон);
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("РабочийДень",         Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий);
	Запрос.УстановитьПараметр("ПредпраздничныйДень", Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный);
	Запрос.УстановитьПараметр("ПроизводственныйКалендарь",ПроизводственныйКалендарь);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(ВЫБОР
	|				КОГДА ДанныеПроизводственногоКалендаря.ВидДня = &РабочийДень
	|						ИЛИ ДанныеПроизводственногоКалендаря.ВидДня = &ПредпраздничныйДень
	|					ТОГДА 1
	|				ИНАЧЕ 0
	|			КОНЕЦ), 0) КАК ЧислоРабочихДней
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
	|ГДЕ
	|	ДанныеПроизводственногоКалендаря.Дата МЕЖДУ &ДатаНач И &ДатаКон
	|	И ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь = &ПроизводственныйКалендарь";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат (Выборка.ЧислоРабочихДней-1)*Коэффициент;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции

// Функция возвращает число календарных дней между заданными датами по регламентированному производственному календарю
//
//Параметры:
// ДатаНач      - начальная дата
// ДатаКон      - конечная дата
//
Функция ЧислоКалендарныхДней(ДатаНач, ДатаКон,ЗНАЧ ПроизводственныйКалендарь)
	
	Запрос = Новый  Запрос;
	
	Если НЕ ЗначениеЗаполнено(ПроизводственныйКалендарь) Тогда
		
		ПроизводственныйКалендарь=Константы.ПроизводственныйКалендарьПоУмолчанию.Получить();
		
	КонецЕсли;
	
	Если ДатаНач>ДатаКон Тогда
		
		Коэффициент=-1;	
		Запрос.УстановитьПараметр("ДатаНач",             ДатаКон);
		Запрос.УстановитьПараметр("ДатаКон",             ДатаНач);
		
	Иначе
		
		Коэффициент=1;
		Запрос.УстановитьПараметр("ДатаНач",             ДатаНач);
		Запрос.УстановитьПараметр("ДатаКон",             ДатаКон);
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ПроизводственныйКалендарь",ПроизводственныйКалендарь);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеПроизводственногоКалендаря.Дата) КАК Дата
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
	|ГДЕ
	|	ДанныеПроизводственногоКалендаря.Дата МЕЖДУ &ДатаНач И &ДатаКон
	|	И ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь = &ПроизводственныйКалендарь";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат (Выборка.Дата-1)*Коэффициент;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции

// Функция возвращает дату отстоящую на заданное количество рабочих дней от начальной в соответствии с
//регламентированным производственным календарем
//
//Параметры:
// ДатаНач      - начальная дата
// ЧислоДней    - количество рабочих дней, на которое искомая дата должна отстоять от начальной
//
Функция ОпределитьРабочуюДату(ДатаНач, ЧислоДней,Знач ПроизводственныйКалендарь,ТекстСмещения="")
	
	Если НЕ ЗначениеЗаполнено(ПроизводственныйКалендарь) Тогда
		
		ПроизводственныйКалендарь=Константы.ПроизводственныйКалендарьПоУмолчанию.Получить();
		
	КонецЕсли;
	
	Если ТекстСмещения="" Тогда
		
		ТекстСмещения=">=";
		
	КонецЕсли;
	
	Запрос = Новый  Запрос;
	Запрос.УстановитьПараметр("ДатаНач",             		ДатаНач);
	Запрос.УстановитьПараметр("ЧислоДней",           		ЧислоДней);
	Запрос.УстановитьПараметр("РабочийДень",         		Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий);
	Запрос.УстановитьПараметр("ПредпраздничныйДень", 		Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный);
	Запрос.УстановитьПараметр("ПроизводственныйКалендарь", 	ПроизводственныйКалендарь);
	
	Если ЧислоДней > 0 Тогда
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ " + ЧислоДней + "
		|	ДанныеПроизводственногоКалендаря.Дата
		|ИЗ
		|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
		|ГДЕ ДанныеПроизводственногоКалендаря.Дата > &ДатаНач
		|	 И (ДанныеПроизводственногоКалендаря.ВидДня = &РабочийДень
		|      ИЛИ ДанныеПроизводственногоКалендаря.ВидДня = &ПредпраздничныйДень)
		|	И ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь = &ПроизводственныйКалендарь
		|УПОРЯДОЧИТЬ ПО
		|	Дата
		|";
		
	ИначеЕсли ЧислоДней=0 Тогда // Определяем первый рабочий день; если исходная дата - рабочий день, возвращаем его
		
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ДанныеПроизводственногоКалендаря.Дата
		|ИЗ
		|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
		|ГДЕ
		|	ДанныеПроизводственногоКалендаря.Дата"+ТекстСмещения+" &ДатаНач
		|	И (ДанныеПроизводственногоКалендаря.ВидДня = &РабочийДень
		|			ИЛИ ДанныеПроизводственногоКалендаря.ВидДня = &ПредпраздничныйДень)
		|	И ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь = &ПроизводственныйКалендарь
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДанныеПроизводственногоКалендаря.Дата УБЫВ";
		
		Если ТекстСмещения = ">=" Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, " УБЫВ", "");
		КонецЕсли;
	Иначе
		
		ЧислоДней = -ЧислоДней;
		
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ " + ЧислоДней + "
		|	ДанныеПроизводственногоКалендаря.Дата
		|ИЗ
		|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
		|ГДЕ ДанныеПроизводственногоКалендаря.Дата< &ДатаНач
		|	 И (ДанныеПроизводственногоКалендаря.ВидДня = &РабочийДень
		|      ИЛИ ДанныеПроизводственногоКалендаря.ВидДня = &ПредпраздничныйДень)
		|	И ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь = &ПроизводственныйКалендарь
		|УПОРЯДОЧИТЬ ПО
		|	Дата УБЫВ
		|";
		
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество()>0 Тогда
		Пока Выборка.Следующий() Цикл
			ТекДата = Выборка.Дата;
		КонецЦикла;
		Возврат ТекДата;
	КонецЕсли;
	
	Возврат ДатаНач;
	
КонецФункции
	
#КонецОбласти
#КонецЕсли
