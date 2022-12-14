
&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Объект.Агенты.Очистить();
	Объект.ЗаводыИзготовители.Очистить();
	Объект.ПрочитаноИРаспознано.Очистить();
	
	
	СтандартнаяОбработка=ложь;
	Объект.ИмяФайла=ллл_РаботаСExcelКлиент.ВыбратьФайлExcel();
	
	ws=ллл_РаботаСExcelКлиент.ПолучитьАктивныйЛистЕксель(Объект.ИмяФайла);
	Если не типЗнч(ws)=тип("COMОбъект") тогда
		С=Новый СообщениеПользователю();
		С.Текст="Не удалось прочитать объект Excel";
		С.Поле="ИмяФайла";
		С.Сообщить();
		возврат;
	КонецЕсли;	
	
	_ТекущаяСтрока=3;
	
	Пока ЗначениеЗаполнено(ws.cells(_ТекущаяСтрока,2).value) 
		//и 		_ТекущаяСтрока<100 
		цикл
		
		Если не ЗначениеЗаполнено(ws.Cells(_ТекущаяСтрока,10).value) тогда
			_ТекущаяСтрока=_ТекущаяСтрока+1;
			продолжить;
		КонецЕсли;
		
		стр=Объект.ПрочитаноИРаспознано.Добавить();
		стр.ДатаОтправкиНАТП=ВернутьДату(ws.Cells(_ТекущаяСтрока,10).value);		
		стр.НомерСтрокиExcel=_ТекущаяСтрока;
		стр.Агент=ws.Cells(_ТекущаяСтрока,6).value;
		стр.Контрагент=ws.Cells(_ТекущаяСтрока,5).Value;
		стр.СуммаВUSD=ВернутьЧисло(ws.Cells(_ТекущаяСтрока,7).Value);
		стр.СуммаВАльтернативнойВалюте=ВернутьЧисло(ws.Cells(_ТекущаяСтрока,8).Value);
		стр.Валюта=ВернутьВалютуПоКоду(ws.Cells(_ТекущаяСтрока,9).Value);
		стр.ДатаПолученияПоставщиком=ВернутьДату(ws.Cells(_ТекущаяСтрока,13).Value);		
		стр.ИнвойсНаНАТП=ws.Cells(_ТекущаяСтрока,19).Value;
		стр.КомментарийExcel=ws.Cells(_ТекущаяСтрока,3).Value;
		ИнвойсКРаспознанию=стр.ИнвойсНаНАТП;
		
		Если ЗначениеЗаполнено(ИнвойсКРаспознанию) тогда
			МассивИнвойсов=МассивРаспознанныхНомеровИнвойсов(ИнвойсКРаспознанию);                                 
			Если МассивИнвойсов.Количество()=1 тогда
				стр.ИнвойсРазделено=МассивИнвойсов[0];
			иначеЕсли МассивИнвойсов.Количество()>0 тогда
				стр.ИнвойсРазделено=МассивИнвойсов[0];
				для Счетчик=1 по МассивИнвойсов.КОличество()-1 цикл
					новСтр=Объект.ПрочитаноИРаспознано.Добавить();
					заполнитьЗначенияСвойств(новстр,стр,,"ИнвойсРазделено,СуммаВUSD, СуммаВАльтернативнойВалюте");
					новСтр.ИнвойсРазделено=МассивИнвойсов[Счетчик];
					
				КонецЦикла;	
				
			иначе	стр.ИнвойсРазделено="";
				
				
			КонецЕсли;	
				
			
		КонецЕсли;
		
			
		
		
		
		
		_ТекущаяСтрока=_ТекущаяСтрока+1;	
	КонецЦикла;	

	ws=неопределено;
	Элементы.ПрочитаноИРаспознано.Обновить();
	АгентыИЗаводы();
	
КонецПроцедуры  


&НаСервере 
Процедура АгентыИЗаводы()
	_Об=РеквизитФормыВЗначение("Объект");
	_Об.ОбработатьАгентовИЗаводы(); 
	ЗначениеВРеквизитФормы(_Об,"Объект");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВернутьВалютуПоКоду(КодВалюты)  
	   // вал=Справочники.Валюты.НайтиПоКоду(КодВалюты);
	   // если не значениеЗаполнено(вал) тогда
	   // 	вал=Справочники.Валюты.НайтиПоНаименованию(КодВалюты);	
	   // КонецЕсли;	
	   // 	
	   //возврат(вал);  
	   
	   Запрос=Новый Запрос();
	   Запрос.Текст="ВЫБРАТЬ
	                |	Валюты.Ссылка КАК Ссылка
	                |ИЗ
	                |	Справочник.Валюты КАК Валюты
	                |ГДЕ
	                |	(Валюты.Наименование = &Наименование
	                |			ИЛИ Валюты.Код = &Наименование
	                |				И Валюты.ПометкаУдаления = ЛОЖЬ)";
	   Запрос.УстановитьПараметр("Наименование",КодВалюты);
	   Результат=Запрос.Выполнить();
	   Выборка=Результат.Выбрать();
	   Если Выборка.Следующий() тогда
		   Возврат(Выборка.Ссылка);
		   
	   иначе	   
		   
		   Возврат(Справочники.Валюты.Пустаяссылка());
	   КонецЕсли;
	   
	
КонецФункции	

&НаСервереБезКонтекста
Функция МассивРаспознанныхНомеровИнвойсов(знач ТекстКРаспознанию)
	ТекстКРаспознанию=стрЗаменить(ТекстКРаспознанию,Символы.НПП,"");
	ТекстКРаспознанию=стрЗаменить(ТекстКРаспознанию,"инв."," ");
	ТекстКРаспознанию=стрЗаменить(ТекстКРаспознанию,"Инв."," ");
	ТекстКРаспознанию=стрЗаменить(ТекстКРаспознанию,"ИНВ."," ");
	ТекстКРаспознанию=стрЗаменить(ТекстКРаспознанию,"инв"," ");
	ТекстКРаспознанию=стрЗаменить(ТекстКРаспознанию,"Инв"," ");
	ТекстКРаспознанию=стрЗаменить(ТекстКРаспознанию,"№"," ");
	ТекстКРаспознанию=стрЗаменить(ТекстКРаспознанию,"от"," ");
	//ТекстКРаспознанию=стрЗаменить(ТекстКРаспознанию,"аванс"," ");
	//ТекстКРаспознанию=стрЗаменить(ТекстКРаспознанию,"предоплата"," ");
	//ТекстКРаспознанию=стрЗаменить(ТекстКРаспознанию,"частичная"," ");
	//ТекстКРаспознанию=стрЗаменить(ТекстКРаспознанию," ","");
	
	Мас=СтрРазделить(ТекстКРаспознанию,",",ложь);
	вГраница=мас.Количество()-1;
	
	Для Счетчик=0 по вГраница цикл
		
		Если стрНайти(мас[вграница-счетчик],"%")>0 тогда
			мас.Удалить(вграница-счетчик);	
			
		
		
	иначе
		мас[вграница-счетчик]=сокрЛП(мас[вграница-счетчик]); 
		КонецЕсли;
		
	КонецЦикла;	
	
	
	возврат(мас);
	

	
	
	
	
	
	
	
	
	
	
	
	
КонецФункции	


&НаСерверебезКонтекста
Функция ВернутьДату(входящееЗначение)
	Если типЗнч(входящееЗначение)=тип("Дата") тогда
		возврат(ВходящееЗначение);
	КонецЕсли;	

	Если типЗнч(ВходящееЗначение)=тип("Строка") тогда
		
		СтруктураПроверкиНаДату=инт_JSONОбмен.ЭтоДата(входящееЗначение);	
		Если СтруктураПроверкиНаДату.ЭтоДата тогда
			возврат(СтруктураПроверкиНаДату.ЗначениеДаты);
		иначе
			возврат('00010101');
			
		КонецЕсли;	
	КонецЕсли;	
	
	возврат('00010101');
	
КонецФункции


&НаСерверебезКонтекста
Функция ВернутьЧисло(знач входящееЗначение)
	Если типЗнч(входящееЗначение)=тип("Число") тогда
		возврат(ВходящееЗначение);
	КонецЕсли;	

	Если типЗнч(ВходящееЗначение)=тип("Строка") тогда
		
		ВходящееЗначение=стрЗаменить(ВходящееЗначение,",",".");
		ВходящееЗначение=стрЗаменить(ВходящееЗначение," ","");
		СтруктураПроверкиНаЧисло=инт_JSONОбмен.ЭтоЧисло(входящееЗначение);	
		Если СтруктураПроверкиНаЧисло.ЭтоЧисло тогда
			возврат(СтруктураПроверкиНаЧисло.ЧисловоеЗначение);
		иначе
			возврат(0);
			
		КонецЕсли;	
	КонецЕсли;	
	
	возврат(0);
	
КонецФункции

&НаСервере
Процедура РаспознатьИнвойсыНаСервере()
	_Объект=РеквизитФормыВЗначение("Объект");
	_Объект.РаспознатьИнвойсыМодуль();
	ЗначениеВРеквизитФормы(_Объект,"Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура РаспознатьИнвойсы(Команда)
	РаспознатьИнвойсыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗаводыИзготовителиПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	//ИндтекСтрока=Элементы.ЗаводыИзготовители.ТекущаяСтрока;
	//ТекСтрока=Объект.ЗаводыИзготовители.НайтиПоИдентификатору(ИндтекСтрока);
	ЗаводыИзготовителиПередОкончаниемРедактированиянаСервере();	
		
		
	
КонецПроцедуры


&НаСервере
Процедура ЗаводыИзготовителиПередОкончаниемРедактированиянаСервере()
	
	текСТрока=Объект.ЗаводыИзготовители.НайтиПоИдентификатору(Элементы.ЗаводыИзготовители.ТекущаяСтрока);

	
	если значениеЗаполнено(текСТрока.КонтрагентСопоставлено) тогда
			ЭтоНеРезидент=?(текСТрока.КонтрагентСопоставлено.ЮрФизЛицо=Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент,истина,ложь);  
			Если ЭтоНеРезидент тогда
				для каждого стр из текСТрока.КонтрагентСопоставлено.ДополнительныеРеквизиты цикл
					Если стр.Свойство.Имя="Резидент" и стр.Значение=истина тогда
						ЭтоНеРезидент=ложь;
						прервать;
						
					КонецЕсли;	
					
				КонецЦикла;
			КонецЕсли;	
			текСТрока.ПроверкаПройдена=ЭтоНеРезидент;
			Если текстРОка.ПроверкаПройдена тогда
				текстрока.результатПроверки="";
			КонецЕсли;
	КонецЕсли;

	Если текСТрока.ПроверкаПройдена тогда
		
				
		для каждого стр2 из Объект.ПрочитаноИРаспознано цикл
			Если стр2.Контрагент<>текСТрока.КонтрагентExcel тогда
				продолжить;
			КонецЕсли;
			
			Если значениеЗаполнено(стр2.Агент) тогда
				продолжить;
			конецЕсли;
			
			_Дог=ллл_ПоискЗначений.НайтиДоговор(Справочники.Организации.НайтиПоКоду("000000001"),текСТрока.КонтрагентСопоставлено,Справочники.Валюты.НайтиПоНаименованию("USD"));
			Если не значениезаполнено(_Дог) тогда
				текСТрока.ПроверкаПройдена=ложь;
				текСТрока.результатПроверки="не найден договор в валюте";
				прервать;
			КонецЕсли;	
			
			
		КонецЦикла;	
		
		
		
		
	иначе	
		
		 текСТрока.результатПроверки="Контрагент не указан как иностранный";
		
		
	КонецЕсли;
	
	
	
КонецПроцедуры	

&НаКлиенте
Процедура АгентыПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	АгентыПередОкончаниемРедактированиянаСервере();
КонецПроцедуры


&НаСервере
Процедура АгентыПередОкончаниемРедактированиянаСервере()
	текСТрока=Объект.Агенты.НайтиПоИдентификатору(Элементы.Агенты.ТекущаяСтрока);
	
	Если значениеЗаполнено(текстрока.АгентСопоставлено) тогда
		орг=ллл_ПоискЗначений.НайтиОрганизациюПоИННиКПП(текстрока.АгентСопоставлено.ИНН,текстрока.АгентСопоставлено.КПП);
		Если не Значениезаполнено(орг) тогда
			текСтрока.РезультатПроверки="Не найдена соответствующая организация";				
			
		иначе
			текСТрока.ПроверкаПройдена=истина;
			текСтрока.РезультатПроверки="";
			для каждого стр2 из Объект.ПрочитаноИРаспознано цикл
				если тексТРОКА.АгентExcel=СТР2.Агент ТОГДА
					
					Дог=ллл_ПоискЗначений.НайтиДоговор(орг,ВернутьКонтрагентЗаводПоСтрокеExcel(стр2.Контрагент),Справочники.Валюты.НайтиПоНаименованию("USD"));
					Если не ЗначениеЗаполнено(Дог) тогда                                        
						текСтрока.РезультатПроверки="Не найден договор между агентом и заводом";				
						текСТрока.ПроверкаПройдена=ложь;

						прервать;
					КонецЕсли;	
					
					Дог=ллл_ПоискЗначений.НайтиДоговор(Справочники.Организации.НайтиПоКоду("000000001"),текстрока.АгентСопоставлено,Справочники.Валюты.НайтиПоНаименованию("USD"));
					Если не ЗначениеЗаполнено(Дог) тогда                                        
						текСтрока.РезультатПроверки="Не найден договор между НАТП и агентом";				
						текСТрока.ПроверкаПройдена=ложь;

					прервать;
						
					КонецЕсли;
					
				кОНЕЦеСЛИ;	
				
				
			КонецЦикла;	
			
			
			
		КонецЕсли;	
		
		
	КонецЕсли;	
	
	
	
КонецПРоцедуры 


&НаСервере 
Функция ВернутьКонтрагентЗаводПоСтрокеExcel(КонтрагентExcel)
	для каждого стр из Объект.ЗаводыИзготовители цикл
		если стр.КонтрагентExcel=КонтрагентExcel тогда
			возврат(стр.КонтрагентСопоставлено);	
			
		КонецЕсли;	
		
	КонецЦикла;	
	
	возврат(Справочники.Контрагенты.ПустаяСсылка());
	
конецФункции	

&НаСервере
Процедура РаспределитьСуммыМультинвойсныхПлатежейНаСервере()

	_Объект=РеквизитФормыВЗначение("Объект");
	_Объект.РаспределитьСуммыМультинвойсныхПлатежейМодуль();
	ЗначениеВРеквизитФормы(_Объект,"Объект");

КонецПроцедуры

&НаКлиенте
Процедура РаспределитьСуммыМультинвойсныхПлатежей(Команда)
	РаспределитьСуммыМультинвойсныхПлатежейНаСервере();
КонецПроцедуры

&НаСервере
Процедура ИтоговаяПроверкаНаСервере()
	_Объект=РеквизитФормыВЗначение("Объект");
	_Объект.ИтоговаяПроверкаМодуль();
	ЗначениеВРеквизитФормы(_Объект,"Объект");
КонецПроцедуры

&НаКлиенте
Процедура ИтоговаяПроверка(Команда)
	ИтоговаяПроверкаНаСервере();
КонецПроцедуры

&НаСервере
Процедура СоздатьЗаказыНаСервере()
	_Об=РеквизитФормыВЗначение("Объект");
	_Об.СоздатьЗаказыМодуль();
	ЗначениеВреквизитФормы(_Об,"Объект");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаказы(Команда)
	СоздатьЗаказыНаСервере();
КонецПроцедуры

&НаСервере
Процедура СоздатьСписанияНаСервере()
	_Об=РеквизитФормыВЗначение("Объект");
	_Об.СоздатьСписанияМодуль();
	ЗначениеВреквизитФормы(_Об,"Объект");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСписания(Команда)
	СоздатьСписанияНаСервере();
КонецПроцедуры
