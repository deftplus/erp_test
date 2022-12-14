
&НаКлиенте
Процедура Выбрать(Команда)
	
	 ВыборЭлемента();	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МакетСкд = ПолучитьОбщийМакет("МакетНастройкиОтборов");	
	МакетСкд.НаборыДанных[0].Поля.Очистить();
	
	ДоступныеАналитики = ЗначениеИзСтрокиВнутр(Параметры.ДоступныеАналитикиСтрока);
	
	Для Каждого ДоступнаяАналитика Из ДоступныеАналитики Цикл
		
		ИмяДляПоиска = "";
		ДобавитьОписаниеПоляСКД(ДоступнаяАналитика.АналитикаКод,ДоступнаяАналитика.АналитикаПредставление,ДоступнаяАналитика.АналитикаТипСтрока,МакетСкд); 	 
		
	КонецЦикла;	
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(МакетСКД, УникальныйИдентификатор)));
		
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиПорядокДоступныеПоляПорядкаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыборЭлемента();

КонецПроцедуры

&НаКлиенте
Процедура ВыборЭлемента()
	
	СтрокаОтбора = КомпоновщикНастроек.Настройки.Порядок.ДоступныеПоляПорядка.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроекНастройкиПорядокДоступныеПоляПорядка.ТекущаяСтрока);		
	Закрыть(Новый Структура("Поле,СтруктураАналитикСтрока,ПолеПредставление",СтрокаОтбора.Поле,ПолучитьСтруктуруГруппировки(СтрокаОтбора.Поле,СтрокаОтбора.Заголовок),ПреобразоватьПредставление(СтрокаОтбора.Поле,СтрокаОтбора.Заголовок)))
				
КонецПроцедуры

Процедура ДобавитьОписаниеПоляСКД(ИмяПоля,СинонимПоля,ТипДанных,МакетСкд)
	
	НовоеПоле = МакетСкд.НаборыДанных[0].Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));	
	НовоеПоле.Поле = ИмяПоля;
	НовоеПоле.Заголовок = СинонимПоля;
	НовоеПоле.ПутьКДанным = ИмяПоля;
	
	МассивТипов = Новый Массив;
	МассивПриведенныхТипов = Новый Массив();
	
	МассивТипов=СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТипДанных, "|");
	Для Каждого Эл Из МассивТипов Цикл
		
		ПриведенныйТип = Тип(Эл);         
		МассивПриведенныхТипов.Добавить(ПриведенныйТип);
		
	КонецЦикла;
	
	НовоеПоле.ТипЗначения = Новый ОписаниеТипов(МассивПриведенныхТипов);		
	
КонецПроцедуры

Функция ПолучитьСтруктуруГруппировки(ИсходнаяСтрока,ИсходнаяСтрокаПредставление)
	
	СтруктураГруппировки 	= Новый Структура();
	
	ТзСвойствАналитики 		= Обработки.АналитическийБланк.ПолучитьОписаниеТаблицыНастроекАналитик();
	
	нСвойствоАналитики = ТзСвойствАналитики.Добавить();
	нСвойствоАналитики.АналитикаПредставление = ИсходнаяСтрокаПредставление;
		
	СтруктураГруппировки.Вставить(СтрЗаменить(ИсходнаяСтрока,".",""),ТзСвойствАналитики);
	
	Возврат ЗначениеВСтрокуВнутр(СтруктураГруппировки);
	
КонецФункции	



Функция ПреобразоватьПредставление(ИсходнаяСтрока,ИсходнаяСтрокаПредставление)
	
	ПозицияПервойТочки 		= СтрНайти(ИсходнаяСтрока,".");
	
	Если ПозицияПервойТочки = 0 Тогда
		Возврат ИсходнаяСтрокаПредставление;
	Иначе	 
		ИмяПоляЗначение                 = Лев(ИсходнаяСтрока,ПозицияПервойТочки-1);
		ПозицияПервойТочкиПредставление = СтрНайти(ИсходнаяСтрокаПредставление,".");
		ИмяПоляПредставление            = Лев(ИсходнаяСтрокаПредставление,ПозицияПервойТочкиПредставление-1);
				
		Возврат СтрЗаменить(ИсходнаяСтрока,ИмяПоляЗначение,ИмяПоляПредставление);
		
	КонецЕсли;
	
КонецФункции	