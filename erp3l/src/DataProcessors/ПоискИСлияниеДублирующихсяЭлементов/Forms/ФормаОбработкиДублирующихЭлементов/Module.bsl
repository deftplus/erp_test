
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТабРеквизитыДляПоиска=ПроцедурыПреобразованияДанныхУХ.ПолучитьТаблицуИзМассиваСтруктур(Параметры.ТаблицаРеквизитов);
	
	ЗначениеВРеквизитФормы(ТабРеквизитыДляПоиска,"РеквизитыДляПоиска");
	ИсходныйЭлемент=Параметры.ИсходныйЭлемент;
	ТаблицаАналитики=Параметры.ТаблицаАналитики;
	СписокДублей=Параметры.СписокДублей;
	СпособОбработки=Параметры.СпособОбработки;
	
	ЕстьДанныеПоКодам=(НЕ ТабРеквизитыДляПоиска.Найти("Код","ИмяРеквизита")=Неопределено);
	
	ЗаполнитьТаблицуДанныхДляСлияния();
	
	ОбработкаДубликатовПослеЗамены = 1;
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.ДанныеДляСлиянияСтраница;
		
	Если СпособОбработки=1
		ИЛИ СпособОбработки=4
		ИЛИ СпособОбработки=6 Тогда
		
		Элементы.ДанныеДляСлиянияВыполнитьОбработку.Заголовок="Удалить дублирующие элементы";
		Элементы.ОбработкаДубликатовПослеЗамены.Видимость = Истина;
		
	Иначе
		
		Элементы.ДанныеДляСлиянияВыполнитьОбработку.Заголовок="Выполнить синхронизацию";
		Элементы.ОбработкаДубликатовПослеЗамены.Видимость = Ложь;
		
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуДанныхДляСлияния()
	
	Запрос=Новый Запрос;
	ДанныеДляСлияния.Очистить();
	ДанныеИсходногоОбъекта.Очистить();
	
	//////////////////////////////////////////////////////////////////////////
	// Получим таблицу реквизитов дублирующих объектов	
	Запрос.Текст="ВЫБРАТЬ";
	
	Для Каждого СтрРеквизит ИЗ РеквизитыДляПоиска Цикл
		
		Запрос.Текст=Запрос.Текст+"
		|ТаблицаАналитики."+СтрРеквизит.ИмяРеквизита+" КАК "+СтрРеквизит.ИмяРеквизита+",";
		
	КонецЦикла;
	
	Если ОбщегоНазначенияУХ.ЕстьРеквизитСправочника(СтрЗаменить(ТаблицаАналитики,"Справочник.",""),"НСИ_ВИБ") Тогда
		
		Запрос.Текст=Запрос.Текст+"
		|ТаблицаАналитики.НСИ_ВИБ КАК НСИ_ВИБ,
		|ТаблицаАналитики.НСИ_ТребуетСинхронизации КАК НСИ_ТребуетСинхронизации,";
		
	КонецЕсли;
	
	Запрос.Текст=Запрос.Текст+"
	|ТаблицаАналитики.Ссылка КАК Ссылка,
	|ТаблицаАналитики.ПометкаУдаления КАК ПометкаУдаления
	|ИЗ "+ТаблицаАналитики+" КАК ТаблицаАналитики
	|ГДЕ ТаблицаАналитики.Ссылка В(&СписокДублей)";
	
	Запрос.УстановитьПараметр("СписокДублей",СписокДублей);
	
	ТаблицаДублей=Запрос.Выполнить().Выгрузить();
	
	РеквизитыКДобавлению=Новый Массив;
	РеквизитыКУдалению=Новый Массив;
	
	ШаблонКолонок=РеквизитФормыВЗначение("ДанныеИсходногоОбъекта");
	
	КолонкаЭлемента=ШаблонКолонок.Колонки.ЗначениеРеквизита;
	
	/////////////////////////////////////////////////////////////////////////
	// Получим данные исходного элемента
	
	Запрос.Текст="ВЫБРАТЬ";
	
	Для Каждого СтрРеквизит ИЗ РеквизитыДляПоиска Цикл
		
		Запрос.Текст=Запрос.Текст+"
		|ТаблицаАналитики."+СтрРеквизит.ИмяРеквизита+" КАК "+СтрРеквизит.ИмяРеквизита+",";
		
	КонецЦикла;
	
	Если ОбщегоНазначенияУХ.ЕстьРеквизитСправочника(СтрЗаменить(ТаблицаАналитики,"Справочник.",""),"НСИ_ВИБ") Тогда
		
		Запрос.Текст=Запрос.Текст+"
		|ТаблицаАналитики.НСИ_ВИБ КАК НСИ_ВИБ,
		|ТаблицаАналитики.НСИ_ТребуетСинхронизации КАК НСИ_ТребуетСинхронизации,";
		
	КонецЕсли;

	Запрос.Текст=Запрос.Текст+"
	|ТаблицаАналитики.Ссылка КАК Ссылка,
	|ТаблицаАналитики.ПометкаУдаления КАК ПометкаУдаления
	|ИЗ "+ТаблицаАналитики+" КАК ТаблицаАналитики
	|ГДЕ ТаблицаАналитики.Ссылка=&Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",ИсходныйЭлемент);
	
	Результат=Запрос.Выполнить().Выбрать();	
	Результат.Следующий();
	
	НоваяСтрока=ДанныеИсходногоОбъекта.Добавить();
	НоваяСтрока.ИмяРеквизита="Обрабатывать";
	
	НоваяСтрока=ДанныеИсходногоОбъекта.Добавить();
	НоваяСтрока.ИмяРеквизита="Ссылка";
	НоваяСтрока.ЗначениеРеквизита=Результат.Ссылка;
	
	НоваяСтрока=ДанныеИсходногоОбъекта.Добавить();
	НоваяСтрока.ИмяРеквизита="ПометкаУдаления";
	НоваяСтрока.ЗначениеРеквизита=Результат.ПометкаУдаления;
	
	Если ОбщегоНазначенияУХ.ЕстьРеквизитСправочника(СтрЗаменить(ТаблицаАналитики,"Справочник.",""),"НСИ_ВИБ") Тогда
		
		НоваяСтрока=ДанныеИсходногоОбъекта.Добавить();
		НоваяСтрока.ИмяРеквизита="НСИ_ВИБ";
		НоваяСтрока.ЗначениеРеквизита=Результат.НСИ_ВИБ;
		
		НоваяСтрока=ДанныеИсходногоОбъекта.Добавить();
		НоваяСтрока.ИмяРеквизита="НСИ_ТребуетСинхронизации";
		НоваяСтрока.ЗначениеРеквизита=Результат.НСИ_ТребуетСинхронизации;
		
	КонецЕсли;
	
	Для Каждого СтрРеквизит ИЗ РеквизитыДляПоиска Цикл 
		
		НоваяСтрока=ДанныеИсходногоОбъекта.Добавить();
		НоваяСтрока.ИмяРеквизита=СтрРеквизит.ИмяРеквизита;
		НоваяСтрока.ЗначениеРеквизита=Результат[СтрРеквизит.ИмяРеквизита];
		
	КонецЦикла;
	
	/////////////////////////////////////////////////////////////////////////
	// Создадим шаблон таблицы для слияния
	
	Если ТаблицаКолонокРеквизитов.Количество()>0 Тогда
		
		Для Каждого Колонка ИЗ ТаблицаКолонокРеквизитов Цикл	
					
			РеквизитыКУдалению.Добавить("ДанныеДляСлияния."+Колонка.ИмяКолонки);
			
			ЭтаФорма.Элементы.Удалить(ЭтаФорма.Элементы[Колонка.ИмяКолонки]);
			
		КонецЦикла;
		
		ТаблицаКолонокРеквизитов.Очистить();
				
	КонецЕсли;
	
	// Очистим условное оформление
	КоличествоЭлементов=УсловноеОформление.Элементы.Количество();
		
	Если КоличествоЭлементов>4 Тогда
		
		МассивОформлений=Новый Массив;
		
		Для Индекс=4 ПО КоличествоЭлементов-1 Цикл
			
			МассивОформлений.Добавить(УсловноеОформление.Элементы[Индекс]);
			
		КонецЦикла;
		
		Для Каждого ЭлементОформления ИЗ МассивОформлений Цикл 
			
			УсловноеОформление.Элементы.Удалить(ЭлементОформления);
			
		КонецЦикла;
		
	КонецЕсли;
			
	Индекс=2;
	
	ТипЗначенияКолонки=КолонкаЭлемента.ТипЗначения;
	
	Для Каждого СтрЭлемент ИЗ ТаблицаДублей Цикл
		
		РеквизитыКДобавлению.Добавить(Новый РеквизитФормы("_"+Индекс,
		ТипЗначенияКолонки,
		"ДанныеДляСлияния",
		" ",
		Ложь));
		
		НоваяСтрока=ТаблицаКолонокРеквизитов.Добавить();
		НоваяСтрока.ИмяКолонки="_"+Индекс;
		НоваяСтрока.Ссылка=СтрЭлемент.Ссылка;
			
		Индекс=Индекс+1;
		
	КонецЦикла;
	
	ПоследняяКолонка=Индекс-1;
	
	ИзменитьРеквизиты(РеквизитыКДобавлению,РеквизитыКУдалению);
	
	Элементы.ДанныеДляСлияния.ФиксацияСлева=2;
	
	Индекс=2;
	
	Для Каждого СтрЭлемент ИЗ ТаблицаДублей Цикл
		
		ДобавитьКолонкуТаблицы(Индекс);
		Индекс=Индекс+1;
		
	КонецЦикла;
	
	// Заполним значения реквизитов
	
	Для Каждого СтрРеквизит ИЗ ДанныеИсходногоОбъекта Цикл
		
		НоваяСтрока=ДанныеДляСлияния.Добавить();
		НоваяСтрока.ИмяРеквизита=СтрРеквизит.ИмяРеквизита;
		НоваяСтрока._1=СтрРеквизит.ЗначениеРеквизита;
		
		Индекс=2;
		
		Если НЕ СтрРеквизит.ИмяРеквизита="Обрабатывать" Тогда
			
			МассивДублей=ТаблицаДублей.ВыгрузитьКолонку(СтрРеквизит.ИмяРеквизита);
			
			Для Каждого ЗначениеРеквизита ИЗ МассивДублей Цикл
				
				НоваяСтрока["_"+Индекс]=ЗначениеРеквизита;
				Индекс=Индекс+1;
				
			КонецЦикла;
			
		Иначе
			
			Для Каждого Строка ИЗ ТаблицаДублей Цикл
				
				НоваяСтрока["_"+Индекс]=Истина;
				Индекс=Индекс+1;
				
			КонецЦикла;
			
		КонецЕсли;	
		
	КонецЦикла;
		
КонецПроцедуры // ЗаполнитьТаблицуДанныхДляСлияния()

&НаСервере
Процедура ДобавитьКолонкуТаблицы(Индекс)
	
	ТекИмяКолонки="_"+Индекс;
	
	ЭтаФорма.Элементы.Добавить(ТекИмяКолонки,Тип("ПолеФормы"),ЭтаФорма.Элементы.ДанныеДляСлияния);
	ЭтаФорма.Элементы[ТекИмяКолонки].ПутьКДанным="ДанныеДляСлияния._"+Индекс;
	ЭтаФорма.Элементы[ТекИмяКолонки].Вид=ВидПоляФормы.ПолеВвода;
	ЭтаФорма.Элементы[ТекИмяКолонки].ДоступныеТипы=ТипЗначенияКолонки;
	ЭтаФорма.Элементы[ТекИмяКолонки].ВыбиратьТип=Ложь;
	
	///////////////////////////////////////////////////////////////
	
	ЭлементОформления   = УсловноеОформление.Элементы.Добавить();
	НоваяГруппаОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	НоваяГруппаОтбора.ТипГруппы=ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	НовыйЭлементОтбора  = НоваяГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДанныеДляСлияния._1");
	НовыйЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;
	НовыйЭлементОтбора.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ДанныеДляСлияния."+ТекИмяКолонки);
	НовыйЭлементОтбора.Использование  = Истина;
	
	НовыйЭлементОтбора  = НоваяГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДанныеДляСлияния.ИмяРеквизита");
	НовыйЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;
	НовыйЭлементОтбора.ПравоеЗначение = "Ссылка";
	НовыйЭлементОтбора.Использование  = Истина;
	
	НовыйЭлементОтбора  = НоваяГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДанныеДляСлияния.ИмяРеквизита");
	НовыйЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;
	НовыйЭлементОтбора.ПравоеЗначение = "Код";
	НовыйЭлементОтбора.Использование  = Истина;
	
	НовыйЭлементОтбора  = НоваяГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДанныеДляСлияния.ИмяРеквизита");
	НовыйЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;
	НовыйЭлементОтбора.ПравоеЗначение = "Обрабатывать";
	НовыйЭлементОтбора.Использование  = Истина;
	
	НовыйЭлементОтбора  = НоваяГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДанныеДляСлияния.ИмяРеквизита");
	НовыйЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;
	НовыйЭлементОтбора.ПравоеЗначение = "ПометкаУдаления";
	НовыйЭлементОтбора.Использование  = Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста",WebЦвета.Красный);
	НовоеПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	НовоеПолеОформления.Поле = Новый ПолеКомпоновкиДанных(ТекИмяКолонки);
	НовоеПолеОформления.Использование = истина;
	
	ЭлементОформления.Использование = Истина;
		
КонецПроцедуры // ДобавитьКолонкуТаблицы() 

&НаСервере
Процедура СоздатьНовыйЭлемент()
	
	СтрокаСсылка=ДанныеДляСлияния.НайтиСтроки(Новый Структура("ИмяРеквизита","Ссылка"));
	СсылкаЭлемент=СтрокаСсылка[0]["_1"];
	
	Если Не ЗначениеЗаполнено(СсылкаЭлемент) Тогда
		Возврат;
	КонецЕсли;
		
	СоздатьНовыйЭлемент=Истина;
	
	Если СпособОбработки=1
		ИЛИ СпособОбработки=4
		ИЛИ СпособОбработки=6 Тогда // Создаем новый элемент. Текущий образец перемещается в дубли.
		
		РеквизитыКДобавлению=Новый Массив;
		РеквизитыКУдалению=Новый Массив;
		
		ПоследняяКолонка=ПоследняяКолонка+1;
		
		РеквизитыКДобавлению.Добавить(Новый РеквизитФормы("_"+ПоследняяКолонка,
		ТипЗначенияКолонки,
		"ДанныеДляСлияния",
		?(ЕстьДанныеПоКодам,ИсходныйЭлемент.Код," "),
		Ложь));
		
		НоваяСтрока=ТаблицаКолонокРеквизитов.Добавить();
		НоваяСтрока.ИмяКолонки="_"+ПоследняяКолонка;
		НоваяСтрока.Ссылка=ИсходныйЭлемент;
	
		ИзменитьРеквизиты(РеквизитыКДобавлению,РеквизитыКУдалению);
		ДобавитьКолонкуТаблицы(ПоследняяКолонка);
		
		Для Каждого Строка ИЗ ДанныеДляСлияния Цикл
			
			Строка["_"+ПоследняяКолонка]=Строка._1;
			
			Если Строка.ИмяРеквизита="Обрабатывать" Тогда
				
				Строка["_"+ПоследняяКолонка]=Истина;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
					
	Для Каждого СтрДанные ИЗ ДанныеДляСлияния Цикл
		
		Если СтрДанные.ИмяРеквизита="Код"
			ИЛИ СтрДанные.ИмяРеквизита="Ссылка"
			ИЛИ СтрДанные.ИмяРеквизита="Обрабатывать" Тогда
			
			СтрДанные._1=Неопределено
			
		Иначе
			
			ЗначениеРеквизита=СтрДанные._1;
			ТипЗначения=ТипЗнч(ЗначениеРеквизита);
			
			СтрДанные._1=ОбщегоНазначенияУХ.ПустоеЗначениеТипа(ТипЗначения);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // СоздатьНовыйЭлемент()

&НаСервере

 

&НаСервере
Функция ВыполнитьЗаменуДублей()
		
	Если Не ОбновитьДанныеИсходногоЭлемента() Тогда
		Возврат Ложь;
	Иначе
		
		МассивЭлементов = СписокОбъектовДляОбработки.ВыгрузитьЗначения();
		
		Если ОбработкаДубликатовПослеЗамены = 0 Тогда //Помечаем элементы на удаление
			
			Возврат ОбщегоНазначенияУХ.ВыполнитьЗаменуЭлементов(ИсходныйЭлемент, МассивЭлементов,, ТаблицаОшибочныхЭО);
			
		Иначе //удаляем непосредственно
			
			РезультатЗамены = ОбщегоНазначенияУХ.ВыполнитьЗаменуЭлементов(ИсходныйЭлемент, МассивЭлементов, Ложь, ТаблицаОшибочныхЭО);
			
			Если РезультатЗамены Тогда
				
				НачатьТранзакцию();
				
				Для каждого ЭлементСпр из МассивЭлементов Цикл
					
					Попытка
						ЭлементОбъект = ЭлементСпр.ПолучитьОбъект();
						ЭлементОбъект.ОбменДанными.Загрузка = Истина;
						ЭлементОбъект.Удалить();					
					Исключение
						ОтменитьТранзакцию();
						Возврат Ложь;
					КонецПопытки;
						
				КонецЦикла;				
				
				ЗафиксироватьТранзакцию();				
				
			КонецЕсли;
			
			Возврат РезультатЗамены;	
			
		КонецЕсли;
		
	КонецЕсли;
				
КонецФункции // ВыполнитьЗаменуДублей()

&НаСервере
Функция ОбновитьДанныеИсходногоЭлемента()
	
	Если НЕ (ИзмененИсходныйЭлемент ИЛИ СоздатьНовыйЭлемент) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ДанныеИсходногоОбъекта.Очистить();
	
	Для Каждого СтрРеквизит ИЗ ДанныеДляСлияния Цикл
		
		НоваяСтрока=ДанныеИсходногоОбъекта.Добавить();
		НоваяСтрока.ИмяРеквизита=СтрРеквизит.ИмяРеквизита;
		НоваяСтрока.ЗначениеРеквизита=СтрРеквизит._1;
		
	КонецЦикла;
	
	Если СоздатьНовыйЭлемент Тогда 
		
		ОбъектЭталон=Справочники[СтрЗаменить(ТаблицаАналитики,"Справочник.","")].СоздатьЭлемент();
		ОбъектЭталон.УстановитьНовыйКод();
		
		Если ЗначениеЗаполнено(Владелец) Тогда
			 ОбъектЭталон.Владелец=Владелец;
		КонецЕсли;
	
		ОбъектЭталон.Код = ОбщегоНазначенияУХ.ПолучитьВозможныйКодСправочника(ОбъектЭталон.Код, ОбъектЭталон.Метаданные().ДлинаКода,СтрЗаменить(ТаблицаАналитики,"Справочник.",""), Владелец);
		
	ИначеЕсли ИзмененИсходныйЭлемент Тогда 
		
		ОбъектЭталон=ИсходныйЭлемент.ПолучитьОбъект();
		
	КонецЕсли;
	
	Для Каждого СтрРеквизит ИЗ ДанныеИсходногоОбъекта Цикл
		
		Если СтрРеквизит.ИмяРеквизита="Код" 
			ИЛИ СтрРеквизит.ИмяРеквизита="Ссылка"
			ИЛИ СтрРеквизит.ИмяРеквизита="Обрабатывать" Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ОбъектЭталон[СтрРеквизит.ИмяРеквизита]=СтрРеквизит.ЗначениеРеквизита;
		
	КонецЦикла;
	
	Попытка
		
		ОбъектЭталон.Записать();
		ИсходныйЭлемент=ОбъектЭталон.Ссылка;
		Возврат Истина;
		
	Исключение
		
		ОбщегоНазначенияУХ.СообщитьОбОшибке("Не удалось записать объект "+ОбъектЭталон+"
		|: "+ОписаниеОшибки(),,,СтатусСообщения.Внимание);
		
		Возврат Ложь;
		
	КонецПопытки;
	
КонецФункции // ОбновитьДанныеИсходногоРеквизита()

&НаСервере
Функция ВыполнитьСинхронизацию()
	
	Если Не ОбновитьДанныеИсходногоЭлемента() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначенияУХ.ЕстьРеквизитСправочника(СтрЗаменить(ТаблицаАналитики,"Справочник.",""),"НСИ_ВИБ") Тогда
		
		НачатьТранзакцию();
		
		Для Каждого Элемент ИЗ СписокОбъектовДляОбработки Цикл
			
			ОбъектДубль=Элемент.Значение.ПолучитьОбъект();
			ОбъектДубль.НСИ_ЭталонныйЭлемент=ИсходныйЭлемент;
			ОбъектДубль.ОбменДанными.Загрузка=Истина;
			
			Попытка
				
				ОбъектДубль.Записать();
				
			Исключение
				
				ОбщегоНазначенияУХ.СообщитьОбОшибке("Не удалось записать объект "+ОбъектДубль+"
				|: "+ОписаниеОшибки(),,,СтатусСообщения.Внимание);
				
				ОтменитьТранзакцию();
				Возврат Ложь;
				
			КонецПопытки;
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // ВыполнитьСинхронизацию()

&НаСервере
Процедура ПоменятьДанныеКолонокСервер(КолонкаА,КолонкаВ)
	
	Для Каждого Строка ИЗ ДанныеДляСлияния Цикл
		
		ЗначениеА=Строка[КолонкаА];
		ЗначениеВ=Строка[КолонкаВ];
		
		Строка[КолонкаА]=ЗначениеВ;
		Строка[КолонкаВ]=ЗначениеА;
		
		Если КолонкаА="_1" И Строка.ИмяРеквизита="Обрабатывать" Тогда
			Строка[КолонкаВ]=Истина;
			Строка[КолонкаА]=Неопределено;	
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры // ПоменятьДанныеКолонок() 

 &НаСервере
Функция СохранитьЭлементыСправочников()
	
	НачатьТранзакцию();
	
	Если Не ОбновитьДанныеИсходногоЭлемента() Тогда
		ОтменитьТранзакцию();
		Возврат Ложь;
	КонецЕсли;
	
	ТабСлияние=РеквизитФормыВЗначение("ДанныеДляСлияния");
	
	МассивРеквизиты=ТабСлияние.ВыгрузитьКолонку("ИмяРеквизита");
	
	СтрокаСсылка=ТабСлияние.Найти("Ссылка","ИмяРеквизита");
	
	Для Индекс=2 По ПоследняяКолонка Цикл
		
		СсылкаДубль=СтрокаСсылка["_"+Индекс];
		
		Если СписокОбъектовДляОбработки.НайтиПоЗначению(СсылкаДубль)=Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаСсылка=ТаблицаКолонокРеквизитов.НайтиСтроки(Новый Структура("Ссылка",СсылкаДубль))[0];
		
		Если СтрокаСсылка.ОбъектИзменен Тогда
			
			ОбъектДубль=СтрокаСсылка.Ссылка.ПолучитьОбъект();
			
			МассивЗначенияРеквизитов=ТабСлияние.ВыгрузитьКолонку("_"+Индекс);
			
			Для ИндексРеквизит=0 По МассивРеквизиты.Количество()-1 Цикл
				
				ИмяРеквизита=МассивРеквизиты[ИндексРеквизит];
				
				Если ИмяРеквизита="Ссылка" ИЛИ ИмяРеквизита="Код" ИЛИ ИмяРеквизита="Обрабатывать" Тогда
					
					Продолжить;
					
				КонецЕсли;
				
				ОбъектДубль[ИмяРеквизита]=МассивЗначенияРеквизитов[ИндексРеквизит];
				
			КонецЦикла;
			
			ОбъектДубль.ОбменДанными.Загрузка=Истина;
			
			Попытка
				
				ОбъектДубль.Записать();
				
			Исключение
				
				ОбщегоНазначенияУХ.СообщитьОбОшибке("Не удалось записать объект "+ОбъектДубль+"
				|: "+ОписаниеОшибки(),,,СтатусСообщения.Внимание);
				
				ОтменитьТранзакцию();
				Возврат Ложь;
				
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
	Возврат Истина;
	
КонецФункции // СохранитьЭлементыСправочников()

&НаСервере
Процедура ОпределитьЭталонныйЭлементПоСсылкам()
	
	МассивСсылок=Новый Массив;
	
	Для Каждого Строка ИЗ ТаблицаКолонокРеквизитов Цикл
		
		МассивСсылок.Добавить(Строка.Ссылка);
		
	КонецЦикла;
	
	МассивСсылок.Добавить(ИсходныйЭлемент);
	
	ТаблицаСсылок = НайтиПоСсылкам(МассивСсылок);
	ТаблицаСсылок.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	ТаблицаСсылок.ЗаполнитьЗначения(1,"Количество");
	ТаблицаСсылок.Свернуть("Ссылка", "Количество");
	
	ТаблицаСсылок.Сортировать("Количество Убыв");
	
	Если ТаблицаСсылок.Количество()>0 Тогда
		
		Если НЕ ИсходныйЭлемент=ТаблицаСсылок[0].Ссылка Тогда
			
			// Определяем координаты колонки нового эталонного элемента
			СтрКолонка=ТаблицаКолонокРеквизитов.НайтиСтроки(Новый Структура("Ссылка",ТаблицаСсылок[0].Ссылка))[0];
			СтрКолонка.Ссылка=ИсходныйЭлемент;
			
			ТекФлагИзменения=СтрКолонка.ОбъектИзменен;
			СтрКолонка.ОбъектИзменен=ИзмененИсходныйЭлемент;
			ИзмененИсходныйЭлемент=ТекФлагИзменения;
			
			ИсходныйЭлемент=ТаблицаСсылок[0].Ссылка;	
			ПоменятьДанныеКолонокСервер("_1",СтрКолонка.ИмяКолонки);
			
		КонецЕсли;
		
	Иначе
		
		Сообщить("Ссылки на объекты не найдены.",СтатусСообщения.Информация);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры // ОпределитьЭталонныйЭлемент()
 
/////////////////////////////////////////////////////////

&НаКлиенте
Процедура ПоменятьДанныеКолонокКлиент(КолонкаА,КолонкаВ)
	
	Для Каждого Строка ИЗ ДанныеДляСлияния Цикл
		
		ЗначениеА=Строка[КолонкаА];
		ЗначениеВ=Строка[КолонкаВ];
		
		Строка[КолонкаА]=ЗначениеВ;
		Строка[КолонкаВ]=ЗначениеА;
		
		Если КолонкаА="_1" И Строка.ИмяРеквизита="Обрабатывать" Тогда
			Строка[КолонкаВ]=Истина;
			Строка[КолонкаА]=Неопределено;	
		КонецЕсли;	
		
	КонецЦикла;
		
КонецПроцедуры // ПоменятьДанныеКолонок()

&НаКлиенте
Процедура СоздатьНовыйЭталонныйЭлемент(Команда)
	
	СоздатьНовыйЭлемент();	
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиРеквизитВЭталон(Команда)
	
	ИндексКолонки=Элементы.ДанныеДляСлияния.ПодчиненныеЭлементы.Индекс(Элементы.ДанныеДляСлияния.ТекущийЭлемент);
	
	Если ИндексКолонки<2 
		ИЛИ Элементы.ДанныеДляСлияния.ТекущиеДанные.ИмяРеквизита="Ссылка" 
		ИЛИ  Элементы.ДанныеДляСлияния.ТекущиеДанные.ИмяРеквизита="Код"
		ИЛИ  Элементы.ДанныеДляСлияния.ТекущиеДанные.ИмяРеквизита="Обрабатывать" Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКолонки="_"+ИндексКолонки;
	
	ЗначениеРеквизита=Элементы.ДанныеДляСлияния.ТекущиеДанные[ИмяКолонки];
	
	Элементы.ДанныеДляСлияния.ТекущиеДанные._1=ЗначениеРеквизита;
	ИзмененИсходныйЭлемент=Истина;
		
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВсеРеквизитыВЭталон(Команда)
	
	ИндексКолонки=Элементы.ДанныеДляСлияния.ПодчиненныеЭлементы.Индекс(Элементы.ДанныеДляСлияния.ТекущийЭлемент);
	
	Если ИндексКолонки<2 Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКолонки="_"+ИндексКолонки;
	
	Для Каждого СтрДанные ИЗ ДанныеДляСлияния Цикл
		
		Если СтрДанные.ИмяРеквизита="Ссылка" 
			ИЛИ СтрДанные.ИмяРеквизита="Код"
			ИЛИ СтрДанные.ИмяРеквизита="Обрабатывать" Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ЗначениеРеквизита=СтрДанные[ИмяКолонки];
		
		Если ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
			
			СтрДанные._1=ЗначениеРеквизита;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ИзмененИсходныйЭлемент=Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьСписокОбъектовДляОбработки()
	
	СписокОбъектовДляОбработки.Очистить();
	СтрокаКОбработке=ДанныеДляСлияния.НайтиСтроки(Новый Структура("ИмяРеквизита","Обрабатывать"))[0];
	СтрокаСсылка=ДанныеДляСлияния.НайтиСтроки(Новый Структура("ИмяРеквизита","Ссылка"))[0];
	
	Для Индекс=2 По ПоследняяКолонка Цикл
		
		Если СтрокаКОбработке["_"+Индекс]=Истина Тогда
			
			СписокОбъектовДляОбработки.Добавить(СтрокаСсылка["_"+Индекс]);
			
		КонецЕсли;
		
	КонецЦикла;
				
КонецПроцедуры // ОпределитьСписокОбъектовДляОбработки()
 

&НаКлиенте
Процедура ВыполнитьОбработку(Команда)
	
	ОпределитьСписокОбъектовДляОбработки();
	
	Если СпособОбработки=1
		ИЛИ СпособОбработки=4
		ИЛИ СпособОбработки=6 Тогда
		
		Если ВыполнитьЗаменуДублей() Тогда
			
			Закрыть(Истина);
			
		ИначеЕсли ТаблицаОшибочныхЭО.Количество() > 0 Тогда
			
			Элементы.Страницы.ТекущаяСтраница = Элементы.ПроблемныеОтчеты;			
			
		КонецЕсли;
		
	Иначе
		
		Если ВыполнитьСинхронизацию() Тогда
			
			Закрыть(Истина);
			
		КонецЕсли;
				
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзмененныеОбъекты(Команда)
	
	ОпределитьСписокОбъектовДляОбработки();
	
	Если СохранитьЭлементыСправочников() Тогда
		
		Закрыть(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеДляСлиянияПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	ИндексКолонки=Элементы.ДанныеДляСлияния.ПодчиненныеЭлементы.Индекс(Элементы.ДанныеДляСлияния.ТекущийЭлемент);
	
	Если ИндексКолонки<1 ИЛИ Элементы.ДанныеДляСлияния.ТекущиеДанные.ИмяРеквизита="Ссылка" Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.ДанныеДляСлияния.ТекущиеДанные.ИмяРеквизита="Обрабатывать" Тогда
		
		Если НЕ Элементы.ДанныеДляСлияния.ТекущиеДанные["_"+ИндексКолонки] Тогда
			
			Элементы["_"+ИндексКолонки].ЦветТекста=Новый Цвет(177,177,177);
			
		Иначе
			
			Элементы["_"+ИндексКолонки].ЦветТекста=Новый Цвет(0,0,0);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИндексКолонки=1 Тогда
		
		ИзмененИсходныйЭлемент=Истина;
		
	Иначе
		
		СтрокаСсылка=ДанныеДляСлияния.НайтиСтроки(Новый Структура("ИмяРеквизита","Ссылка"));
		СсылкаДубль=СтрокаСсылка[0]["_"+ИндексКолонки];
		
		СтрокаСсылка=ТаблицаКолонокРеквизитов.НайтиСтроки(Новый Структура("Ссылка",СсылкаДубль))[0];
		СтрокаСсылка.ОбъектИзменен=Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьЭталонныйЭлемент(Команда)
	
	ОпределитьЭталонныйЭлементПоСсылкам();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущийОбразцовым(Команда)
	
	ИндексКолонки=Элементы.ДанныеДляСлияния.ПодчиненныеЭлементы.Индекс(Элементы.ДанныеДляСлияния.ТекущийЭлемент);
	
	Если ИндексКолонки<2 Тогда
		Возврат;
	КонецЕсли;
		
	// Определяем координаты колонки нового эталонного элемента
	СтрКолонка=ТаблицаКолонокРеквизитов.НайтиСтроки(Новый Структура("ИмяКолонки","_"+ИндексКолонки))[0];
	СсылкаДубль=СтрКолонка.Ссылка;
	
	СтрКолонка.Ссылка=ИсходныйЭлемент;
	
	ТекФлагИзменения=СтрКолонка.ОбъектИзменен;
	СтрКолонка.ОбъектИзменен=ИзмененИсходныйЭлемент;
	ИзмененИсходныйЭлемент=ТекФлагИзменения;
	
	ИсходныйЭлемент=СсылкаДубль;	
	ПоменятьДанныеКолонокКлиент("_1",СтрКолонка.ИмяКолонки);
		
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры
