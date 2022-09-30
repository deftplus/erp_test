  
Процедура ВыполнитьРеструктуризациюБланков(Ссылка,АдресПараметровРеструктуризации) Экспорт
	
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.ВидыОтчетов") Тогда
		
		  Запрос = Новый Запрос;
		  Запрос.Текст = "ВЫБРАТЬ
		  |	ПоказателиОтчетов.Ссылка КАК ПоказательОтчета
		  |ИЗ
		  |	Справочник.ПоказателиОтчетов КАК ПоказателиОтчетов
		  |ГДЕ
		  |	ПоказателиОтчетов.Владелец = &Владелец
		  |	И ПоказателиОтчетов.ПометкаУдаления = ЛОЖЬ";
		  
		  Запрос.УстановитьПараметр("Владелец",Ссылка);
		  
		  Результат = Запрос.Выполнить().Выгрузить();
		  		  
		  оРеструктуризация = Обработки.РестуктуризацияБланковВО.Создать();
		  оРеструктуризация.ИзмененныеПоказатели.Загрузить(Результат);
		  оРеструктуризация.ВыполнитьРеструктуризациюБланков();
		  
	 ИначеЕсли  ТипЗнч(Ссылка) = Тип("СправочникСсылка.ГруппыРаскрытия") Тогда	  
		 
		 
		  ПараметрыРеструктуризации = ПолучитьИзВременногоХранилища(АдресПараметровРеструктуризации);
		 
		  Запрос = Новый Запрос;
		  Запрос.Текст = "ВЫБРАТЬ
		  |	ПоказателиОтчетов.Ссылка КАК ПоказательОтчета
		  |ИЗ
		  |	Справочник.ПоказателиОтчетов КАК ПоказателиОтчетов
		  |ГДЕ
		  |	ПоказателиОтчетов.ГруппаРаскрытия В (&СписокГрупп)
		  |	И ПоказателиОтчетов.ПометкаУдаления = ЛОЖЬ";
		  
		  Запрос.УстановитьПараметр("СписокГрупп",ПараметрыРеструктуризации.ИзменениеРаскрытия.ВыгрузитьКолонку("ЭлементСтруктуры"));
		  
		  Результат = Запрос.Выполнить().Выгрузить();
		  		  
		  оРеструктуризация = Обработки.РестуктуризацияБланковВО.Создать();
		  оРеструктуризация.ИзмененныеПоказатели.Загрузить(Результат);
		  оРеструктуризация.ВыполнитьРеструктуризациюБланков();

	  ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.ПоказателиОтчетов") Тогда	  
		  
		  оРеструктуризация = Обработки.РестуктуризацияБланковВО.Создать();
		  Нстр = оРеструктуризация.ИзмененныеПоказатели.Добавить();
		  Нстр.ПоказательОтчета = Ссылка;
		  оРеструктуризация.ВыполнитьРеструктуризациюБланков();

	  ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.СтрокиОтчетов") Тогда			  
		  
		  ПараметрыРеструктуризации = ПолучитьИзВременногоХранилища(АдресПараметровРеструктуризации);
		 
		  Запрос = Новый Запрос;
		  Запрос.Текст = "ВЫБРАТЬ
		  |	ПоказателиОтчетов.Ссылка КАК ПоказательОтчета
		  |ИЗ
		  |	Справочник.ПоказателиОтчетов КАК ПоказателиОтчетов
		  |ГДЕ
		  |	ПоказателиОтчетов.Строка = &тСтрока
		  |	И ПоказателиОтчетов.ПометкаУдаления = ЛОЖЬ";
		  
		  Запрос.УстановитьПараметр("тСтрока",Ссылка);
		  
		  Результат = Запрос.Выполнить().Выгрузить();
		  		  
		  оРеструктуризация = Обработки.РестуктуризацияБланковВО.Создать();
		  оРеструктуризация.ИзмененныеПоказатели.Загрузить(Результат);
		  оРеструктуризация.ВыполнитьРеструктуризациюБланков();

	  ИначеЕсли ТипЗнч(Ссылка) = Тип("ОбработкаОбъект.НастройкаСтруктурыОтчета")  Тогда	  
		  
		  
		 ПараметрыРеструктуризации = ПолучитьИзВременногоХранилища(АдресПараметровРеструктуризации);
  
		  Запрос = Новый Запрос;
		  Запрос.Текст = "ВЫБРАТЬ
		  |	ПоказателиОтчетов.Ссылка КАК ПоказательОтчета
		  |ИЗ
		  |	Справочник.ПоказателиОтчетов КАК ПоказателиОтчетов
		  |ГДЕ
		  |	ПоказателиОтчетов.Строка В (&Строки)
		  |	И ПоказателиОтчетов.ПометкаУдаления = ЛОЖЬ";
		  
		  Запрос.УстановитьПараметр("Строки",ПараметрыРеструктуризации.ИзменяемыеСтроки);
		  
		  Результат = Запрос.Выполнить().Выгрузить();
		  		  
		  оРеструктуризация = Обработки.РестуктуризацияБланковВО.Создать();
		  оРеструктуризация.ИзмененныеПоказатели.Загрузить(Результат);
		  оРеструктуризация.ВыполнитьРеструктуризациюБланков();
 
		  
	  КонецЕсли;	
	
КонецПроцедуры	  

Процедура ВернутьРисунокПустойТаблицы(ПолеТабличногоДокументаМакет,Заголовок) Экспорт
	
	ПолеТабличногоДокументаМакет.Очистить();
	ПолеТабличногоДокументаМакет.ФиксацияСлева = 0;
	ПолеТабличногоДокументаМакет.ФиксацияСверху = 0;	
	
	Рисунок = ПолеТабличногоДокументаМакет.Рисунки.ДОбавить(ТипРисункаТабличногоДокумента.Прямоугольник);
	Рисунок.Лево = 18;
	Рисунок.Верх = 14;
	Рисунок.Ширина = 160;
	Рисунок.Высота = 28;
	Рисунок.ГраницаСверху = Ложь;
	Рисунок.ГраницаСнизу  = Ложь;
	Рисунок.ГраницаСправа = Ложь;
	Рисунок.ГраницаСлева  = Ложь;
	Рисунок.ЦветФона=Новый Цвет(220,220,220);	
	Рисунок.Имя  = "ШаблонПустойТаблицы";	
	
	Рисунок = ПолеТабличногоДокументаМакет.Рисунки.ДОбавить(ТипРисункаТабличногоДокумента.Текст);
	Рисунок.Лево = 16;
	Рисунок.Верх = 12;
	Рисунок.Ширина = 160;
	Рисунок.Высота = 28;
	Рисунок.ЦветФона=Новый Цвет(155, 194, 230);	
	Рисунок.Шрифт = Новый Шрифт(Рисунок.Шрифт,,12);
	Рисунок.ЦветТекста = Новый Цвет(255,255,255);
	Рисунок.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр; 
	Рисунок.ВертикальноеПоложение = ВертикальноеПоложение.Центр; 
	Рисунок.Текст = Заголовок;
			
КонецПроцедуры	

Процедура ОбновитьКэшОтборовОперандов(ПолетабличногоДокументаМакет,АдресРезультатаРедактирования,МассивОбрабатываемыхИмен,ОбъектАБ,РасшифровкаОперанда) Экспорт
	
	Если ТипЗнч(АдресРезультатаРедактирования) = Тип("ТаблицаЗначений") Тогда
		РасшифровкаОтборов   =  АдресРезультатаРедактирования;
	Иначе
		РасшифровкаОтборов   =  ПолучитьИзВременногоХранилища(АдресРезультатаРедактирования.ОтборыГруппы);
	КонецЕсли;	
	
	Для Каждого Обл Из МассивОбрабатываемыхИмен Цикл
		
		ТекущаяСтрокаОперанда 		= ОбъектАБ.РасшифровкаФормулОбластейПоказателей.НайтиСтроки(Новый Структура("ИмяВФормуле",Обл))[0];
		СохраненнаяГруппаОтборов    = ТекущаяСтрокаОперанда.УидГруппыОтборов;
		//Преобразуем структуру в случае группового редактирования
		СохраненнаяСтрокаОтборов = ОбъектАБ.КэшГруппОтборовПоказателей.НайтиСтроки(Новый Структура("УидГруппыОтборов",СохраненнаяГруппаОтборов))[0];
		ТекущаяСтруктураПоиска = Новый Структура();
		ТекущаяСтруктураПоиска.Вставить("ИндексРегистра",СохраненнаяСтрокаОтборов["ИндексРегистра"]);	
		//Преобразуем отборы в случае группового редактирования
		СохраненныеОтборы = ОбъектАБ.РасшифровкаГруппОтборов.Выгрузить(Новый Структура("УидГруппыОтборов",СохраненнаяГруппаОтборов));
		Для Каждого сОтбор Из СохраненныеОтборы Цикл		
			ТекущийОтбор = РасшифровкаОтборов.НайтиСтроки(Новый Структура("ПолеКод,Использовать",сОтбор.ПолеКод,Истина));
			Если ТекущийОтбор.Количество() = 1 Тогда
				ЗаполнитьЗначенияСвойств(сОтбор,ТекущийОтбор[0]);
			КонецЕсли;	
		КонецЦикла;
		
		тХэшГруппыОтборов = Обработки.АналитическийБланк.ПолучитьХэшПоОтборам(СохраненныеОтборы);
		ТекущаяСтруктураПоиска.Вставить("ХэшГруппыОтборов",тХэшГруппыОтборов);
		
		НайденнаяСтрокаКэша = ОбъектАБ.КэшГруппОтборовПоказателей.НайтиСтроки(ТекущаяСтруктураПоиска);
		
		Если НайденнаяСтрокаКэша.Количество() = 0 Тогда //Создаем новую группу отборов	
			нСтр = ОбъектАБ.КэшГруппОтборовПоказателей.Добавить();
			ЗаполнитьЗначенияСвойств(нСтр,ТекущаяСтруктураПоиска);
			нСтр.УидГруппыОтборов = СтрЗаменить(Строка(Новый УникальныйИдентификатор()),"-","");	
			//Добавляем расшифровку групп отборов
			Для Каждого ТекРасшифровкаОтборов Из СохраненныеОтборы Цикл
				оСтр = ОбъектАБ.РасшифровкаГруппОтборов.Добавить();
				ЗаполнитьЗначенияСвойств(оСтр,ТекРасшифровкаОтборов);
				оСтр.УидГруппыОтборов =  нСтр.УидГруппыОтборов;
			КонецЦикла;		
		Иначе	  
			нСтр = НайденнаяСтрокаКэша[0];	
		КонецЕсли; 	
		
		РасшифровкаОперанда.Вставить("ВидОтчета"		,ТекущаяСтрокаОперанда.ВидОтчета);
		РасшифровкаОперанда.Вставить("ВидОтчетаКод"	,ТекущаяСтрокаОперанда.ВидОтчетаКод);
        РасшифровкаОперанда.Вставить("Ссылка"		,ТекущаяСтрокаОперанда.Показатель);
        РасшифровкаОперанда.Вставить("ПоказательКод"	,ТекущаяСтрокаОперанда.ПоказательКод);
		РасшифровкаОперанда.Вставить("УидГруппыОтборов"	,нСтр.УидГруппыОтборов);

	КонецЦикла;  
	   
КонецПроцедуры	
