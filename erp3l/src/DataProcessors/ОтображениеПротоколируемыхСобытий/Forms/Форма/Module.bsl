
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПоказатьТехническуюИнформацию = Параметры.ПоказатьТехническуюИнформацию;
	
	Если ТипЗнч(Параметры.МассивПротоколируемыхОбъектов)=Тип("ФиксированныйМассив") ИЛИ
		 ТипЗнч(Параметры.МассивПротоколируемыхОбъектов)=Тип("Массив") Тогда
		МассивПротоколируемыхОбъектов = Новый ФиксированныйМассив(Параметры.МассивПротоколируемыхОбъектов);
	КонецЕсли;
	
	СформироватьПротоколыНаСервере();
	
КонецПроцедуры

&НаСервере
Функция СформироватьПротоколыПоМассиву()
	
	ПолеТабличногоДокумента.Очистить();
	МассивПротоколов=Новый Соответствие;
	
	Если ТипЗнч(МассивПротоколируемыхОбъектов)=Тип("ФиксированныйМассив") Тогда
		
		ТаблицаПротоколов=Справочники.ПротоколируемыеСобытия.ПолучитьМассивПротоколов(МассивПротоколируемыхОбъектов, ПоказатьТехническуюИнформацию);
			
		Для Каждого СтрПротокол ИЗ ТаблицаПротоколов Цикл
			
			ПолеТабличногоДокумента.Вывести(СтрПротокол.ТабДокумент);
			МассивПротоколов.Вставить(СтрПротокол.Организация,СтрПротокол.ТабДокумент);
			
		КонецЦикла;		
		
	КонецЕсли;
	
	СоответствиеОбъектовПротоколов = Новый ФиксированноеСоответствие(МассивПротоколов);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьНастройкуСоответствия(ТаблицаАналитики,ТипБД)
	
	
КонецФункции // ПолучитьНастройкуСоответствия()

&НаСервере
Процедура СформироватьПротоколыНаСервере()
	
	Если ТипЗнч(Параметры.КонтекстПротокола)=Тип("Структура")ИЛИ ТипЗнч(Параметры.КонтекстПротокола)=Тип("ФиксированнаяСтруктура") Тогда
		
		СтруктураПараметров=Новый Структура;
		
		Для Каждого КлючИЗначение ИЗ Параметры.КонтекстПротокола Цикл
		
		Если ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда
			
			СтруктураПараметров.Вставить(КлючИЗначение.Ключ,КлючИЗначение.Значение);
			
		КонецЕсли;
		
		КонтекстПротокола=Новый ФиксированнаяСтруктура(СтруктураПараметров);
		
	КонецЦикла; 
		
		СформироватьПротоколПоЖурналу();
		
	ИначеЕсли СтрДлина(Параметры.АдресТаблицыСобытий)>0 Тогда
		
		СформироватьПротоколПоТаблицеСобытий();
		
	Иначе 
		
		СформироватьПротоколыПоМассиву();
		
	КонецЕсли;

КонецПроцедуры // СформироватьПротоколыНаСервере() 	

&НаКлиенте
Процедура ТехническаяИнформация(Команда)
	
	ПоказатьТехническуюИнформацию = НЕ ПоказатьТехническуюИнформацию;
	СформироватьПротоколыНаСервере();
	Элементы.ФормаТехническаяИнформация.Заголовок = ?(ПоказатьТехническуюИнформацию, "Показать сокращенный протокол", "Показать полный протокол");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьХранимыйФайл(ВерсияХранимогоФайла)
	
	Возврат ВерсияХранимогоФайла.ВладелецФайла; 
	
КонецФункции // ПолучитьХранимыйФайл() 

&НаКлиенте
Процедура ПолеТабличногоДокументаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Расшифровка)=Тип("Структура") Тогда
		
		СтандартнаяОбработка=Ложь;
		
		Если Расшифровка.Свойство("ИмяФайла") Тогда
			
			ХранимыеФайлыКлиентУХ.ОткрытьФайлНаДиске(Расшифровка.ИмяФайла);
						
		ИначеЕсли Расшифровка.Свойство("ВерсияХранимогоФайла") Тогда
			
			 ХранимыеФайлыКлиентУХ.ОткрытьХранимыйФайлДляЧтения(ПолучитьХранимыйФайл(Расшифровка.ВерсияХранимогоФайла),,Расшифровка.ВерсияХранимогоФайла)
				
		ИначеЕсли Расшифровка.Свойство("ВидОтчета") Тогда
			
			Если ТипЗнч(Расшифровка.ОбъектДанных)=Тип("СправочникСсылка.ПоказателиОтчетов") Тогда
				
				СтруктураПараметров=Новый Структура;
				СтруктураПараметров.Вставить("НазначениеРасчетов",Расшифровка.ПравилоОбработки);
				СтруктураПараметров.Вставить("ПотребительРасчета",Расшифровка.ОбъектДанных);
				СтруктураПараметров.Вставить("СпособИспользования",ПредопределенноеЗначение("Перечисление.СпособыИспользованияОперандов.ДляФормулРасчета"));
				
				ОткрытьФорму("ОбщаяФорма.ФормаНастройкиФормулРасчета",СтруктураПараметров);
				
			ИначеЕсли ТипЗнч(Расшифровка.ОбъектДанных)=Тип("Строка") Тогда
				
				НастройкаСоответствия=ПолучитьНастройкуСоответствия(Расшифровка.ОбъектДанных,Расшифровка.ТипБД);
				
				Если Не НастройкаСоответствия=Неопределено Тогда
					
					ОткрытьФорму("Справочник.СоответствиеВнешнимИБ.ФормаОбъекта",Новый Структура("Ключ",НастройкаСоответствия));
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
				
КонецПроцедуры

&НаСервере
Процедура СформироватьПротоколПоТаблицеСобытий()
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ * Поместить ПротоколируемыеСобытияЗаписи ИЗ &ТаблицаСобытий КАК ТаблицаСобытий
	|;
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ПротоколируемыеСобытияЗаписи.Событие КАК СТРОКА(500)) КАК Событие,
	|	ВЫРАЗИТЬ(ПротоколируемыеСобытияЗаписи.Сообщение КАК СТРОКА(500)) КАК Сообщение,
	|	ПротоколируемыеСобытияЗаписи.ТипЗаписи,
	|	ВЫРАЗИТЬ(ПротоколируемыеСобытияЗаписи.ТехническаяИнформацияСтрокаВнутр КАК СТРОКА(1024)) КАК ТехническаяИнформация,
	|	ВЫБОР
	|		КОГДА ПротоколируемыеСобытияЗаписи.ТипЗаписи = ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПротоколируемыхСобытий.ОШИБКА)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Ошибка,
	|	ПротоколируемыеСобытияЗаписи.ОбъектДанных,
	|	ТИПЗНАЧЕНИЯ(ПротоколируемыеСобытияЗаписи.ОбъектДанных) КАК ТипОбъекта,
	|	ПротоколируемыеСобытияЗаписи.ОбъектМетаданных
	|ИЗ
	|	ПротоколируемыеСобытияЗаписи КАК ПротоколируемыеСобытияЗаписи
	|
	|УПОРЯДОЧИТЬ ПО
	|Ошибка УБЫВ
	|ИТОГИ ПО
	|	Ошибка";
	
	Запрос.УстановитьПараметр("ТаблицаСобытий",ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыСобытий));
	
	Результат=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Ошибка");
	ПолеТабличногоДокумента.Очистить();
	
	ВывестиДанныеПоСобытиям(Результат,Ложь);
				
КонецПроцедуры //  СформироватьПротоколПоМассиву()

&НаСервере
Процедура СформироватьПротоколПоЖурналу()
	
	Макет 						= Обработки.ОтображениеПротоколируемыхСобытий.ПолучитьМакет("Макет");
	
	ОбластьКлючевогоРеквизита	= Макет.ПолучитьОбласть("ОбластьКлючевогоРеквизита");
	ОбластьСсылка				= Макет.ПолучитьОбласть("ОбластьСсылка");
	ОбластьРазделитель			= Макет.ПолучитьОбласть("ОбластьРазделитель");
	ОбластьИмяФайла				= Макет.ПолучитьОбласть("ОбластьФайл");
	
	ПолеТабличногоДокумента.Очистить();
	
	Для Каждого КлючИЗначение ИЗ КонтекстПротокола Цикл
		
		ОбластьКлючевогоРеквизита.Параметры.ИмяРеквизита		= КэшируемыеПроцедурыУХ.ПолучитьСинонимКлючевогоРеквизита(КлючИЗначение.Ключ);
		ОбластьКлючевогоРеквизита.Параметры.ЗначениеРеквизита	= КлючИЗначение.Значение;
			
		ПолеТабличногоДокумента.Вывести(ОбластьКлючевогоРеквизита);
		
	КонецЦикла;
		
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ 
	|	ВЫРАЗИТЬ(ПротоколируемыеСобытияЗаписи.Событие КАК СТРОКА(500)) КАК Событие,
	|	ВЫРАЗИТЬ(ПротоколируемыеСобытияЗаписи.Сообщение КАК СТРОКА(500)) КАК Сообщение,
	|	ПротоколируемыеСобытияЗаписи.ТипЗаписи,
	|	ВЫРАЗИТЬ(ПротоколируемыеСобытияЗаписи.ТехническаяИнформацияСтрокаВнутр КАК СТРОКА(500)) КАК ТехническаяИнформация,
	|	ВЫБОР
	|		КОГДА ПротоколируемыеСобытияЗаписи.ТипЗаписи = ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПротоколируемыхСобытий.ОШИБКА)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Ошибка,
	|	ПротоколируемыеСобытияЗаписи.ОбъектДанных,
	|	ПротоколируемыеСобытияЗаписи.ВидОтчета,
	|	ПротоколируемыеСобытияЗаписи.ПравилоОбработки,
	|	ПротоколируемыеСобытияЗаписи.ИспользуемаяИБ,
	|	ПротоколируемыеСобытияЗаписи.ИспользуемаяИБ.ТипБД КАК ТипБД,
	|	ТИПЗНАЧЕНИЯ(ПротоколируемыеСобытияЗаписи.ОбъектДанных) КАК ТипОбъекта,
	|	ПротоколируемыеСобытияЗаписи.ОбъектМетаданных
	|ИЗ
	|	РегистрСведений.ЖурналПротоколируемыхСобытий КАК ПротоколируемыеСобытияЗаписи";
	
	Если КонтекстПротокола.Количество()>0 Тогда
		
		ТекстОтбор="";	
		
		Для Каждого КлючИЗначение ИЗ КонтекстПротокола Цикл
			
			ТекстОтбор=ТекстОтбор+" И ПротоколируемыеСобытияЗаписи."+КлючИЗначение.Ключ+"=&"+КлючИЗначение.Ключ;
			Запрос.УстановитьПараметр(КлючИЗначение.Ключ,КлючИЗначение.Значение);
			
		КонецЦикла;
		
		Запрос.Текст=Запрос.Текст+"
		|ГДЕ "+Сред(ТекстОтбор,3);
		
	КонецЕсли;
	
	Запрос.Текст=Запрос.Текст+"
	|
	|УПОРЯДОЧИТЬ ПО
	|Ошибка УБЫВ
	|ИТОГИ ПО
	|	Ошибка";
		
	Результат=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Ошибка");
	ПолеТабличногоДокумента.Очистить();
	
	ВывестиДанныеПоСобытиям(Результат);
				
КонецПроцедуры //  СформироватьПротоколПоМассиву()

&НаСервере
Процедура ВывестиДанныеПоСобытиям(Результат,ВыводитьРеквизиты=Истина) 
	
	Макет 						= Обработки.ОтображениеПротоколируемыхСобытий.ПолучитьМакет("Макет");	
	ОбластьКомментарий			= Макет.ПолучитьОбласть("ОбластьКомментарий");
	ОбластьРазделитель			= Макет.ПолучитьОбласть("ОбластьРазделитель");
	ОбластьКлючевогоРеквизита	= Макет.ПолучитьОбласть("ОбластьКлючевогоРеквизита");
	
	СтруктураМакетов=Новый Структура;
	СтруктураМакетов.Вставить("ОбластьТипЗаписиОшибка",		Макет.ПолучитьОбласть("ОбластьТипЗаписиОшибка"));
	СтруктураМакетов.Вставить("ОбластьТипЗаписиДоп",		Макет.ПолучитьОбласть("ОбластьТипЗаписиДоп"));
	СтруктураМакетов.Вставить("ОбластьКлючевогоРеквизита",	Макет.ПолучитьОбласть("ОбластьКлючевогоРеквизита"));

	
	Если ПоказатьТехническуюИнформацию Тогда
		
		СтруктураМакетов.Вставить("ОбластьЗаписиОшибка",Макет.ПолучитьОбласть("ОбластьЗаписиОшибка|Полный"));
		СтруктураМакетов.Вставить("ОбластьЗаписиДоп",	Макет.ПолучитьОбласть("ОбластьЗаписиДоп|Полный"));
		
	Иначе
		
		СтруктураМакетов.Вставить("ОбластьЗаписиОшибка",Макет.ПолучитьОбласть("ОбластьЗаписиОшибка|Сокращенный"));
		СтруктураМакетов.Вставить("ОбластьЗаписиДоп",	Макет.ПолучитьОбласть("ОбластьЗаписиДоп|Сокращенный"));
		
	КонецЕсли;
	
	ТабДок=ПолеТабличногоДокумента;
	
	Пока Результат.Следующий() Цикл
		
		ТабДок.Вывести(?(Результат.Ошибка,СтруктураМакетов.ОбластьТипЗаписиОшибка,СтруктураМакетов.ОбластьТипЗаписиДоп));
		
		ТабДок.НачатьГруппуСтрок(,Результат.Ошибка);
		
		ДетальныеЗаписи=Результат.Выбрать();
				
		Пока ДетальныеЗаписи.Следующий() Цикл
			
			Если ДетальныеЗаписи.Событие="УправлениеХолдингом.ДублированиеДанныхПриСинхронизации" Тогда
				
				СтруктураМакетов.ОбластьЗаписиОшибка.Параметры.Сообщение=ДетальныеЗаписи.Сообщение;
				ТабДок.Вывести(СтруктураМакетов.ОбластьЗаписиОшибка);
				
				Если ПоказатьТехническуюИнформацию Тогда
					
					ТабДок.НачатьГруппуСтрок(,Ложь);
					
					СоответствиеТаблицДублей=ЗначениеИзСтрокиВнутр(ДетальныеЗаписи.ТехническаяИнформация);
					Линия1 = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
					
					Для Каждого КлючИЗначение ИЗ СоответствиеТаблицДублей Цикл
						
						СтруктураМакетов.ОбластьКлючевогоРеквизита.Параметры.ИмяРеквизита			= "Настройка соответствия:";
						СтруктураМакетов.ОбластьКлючевогоРеквизита.Параметры.ЗначениеРеквизита		= КлючИЗначение.Ключ;
						СтруктураМакетов.ОбластьКлючевогоРеквизита.Параметры.ЗначениеРасшифровки	= КлючИЗначение.Ключ;
						
						ТабДок.Вывести(СтруктураМакетов.ОбластьКлючевогоРеквизита);
						
						СтруктураМакетов.ОбластьКлючевогоРеквизита.Параметры.ИмяРеквизита			= "Дублирующиеся строки";
						СтруктураМакетов.ОбластьКлючевогоРеквизита.Параметры.ЗначениеРеквизита		= "";
						СтруктураМакетов.ОбластьКлючевогоРеквизита.Параметры.ЗначениеРасшифровки	= "";
						
						ТабДок.Вывести(СтруктураМакетов.ОбластьКлючевогоРеквизита);
											
						ПостроительОтчета=Новый ПостроительОтчета;
						ТабличныйДокумент=Новый ТабличныйДокумент;
												
						ИсточникДанных=Новый ОписаниеИсточникаДанных(КлючИЗначение.Значение);
						
						ПостроительОтчета.ИсточникДанных=ИсточникДанных;
									
						ПостроительОтчета.ВыводитьЗаголовокОтчета=Ложь;
						Линия=Новый Линия(ТипЛинииРисункаТабличногоДокумента.Сплошная,1);
						
						ПостроительОтчета.Вывести(ТабличныйДокумент);
						
						ТабличныйДокумент.Область(2,2, ТабличныйДокумент.ВысотаТаблицы-2, ТабличныйДокумент.ШиринаТаблицы).Обвести(Линия,Линия,Линия,Линия);
									
						ТабДок.Вывести(ТабличныйДокумент);
						
					КонецЦикла;
					
					ТабДок.ЗакончитьГруппуСтрок();
					
				КонецЕсли;
				
			Иначе
			
			ОбластьЗаписи=?(Результат.Ошибка,СтруктураМакетов.ОбластьЗаписиОшибка,СтруктураМакетов.ОбластьЗаписиДоп);
			ЗаполнитьЗначенияСвойств(ОбластьЗаписи.Параметры,ДетальныеЗаписи);
			
			Если ЗначениеЗаполнено(ДетальныеЗаписи.ОбъектДанных) Тогда
				
				СтруктураПараметров=Новый Структура;
				СтруктураПараметров.Вставить("ОбъектДанных",	ДетальныеЗаписи.ОбъектДанных);
				СтруктураПараметров.Вставить("ОбъектМетаданных",ДетальныеЗаписи.ОбъектМетаданных);

				Если ВыводитьРеквизиты И ЗначениеЗаполнено(ДетальныеЗаписи.ВидОтчета) Тогда
					
					СтруктураПараметров.Вставить("ВидОтчета",		ДетальныеЗаписи.ВидОтчета);
					СтруктураПараметров.Вставить("ПравилоОбработки",ДетальныеЗаписи.ПравилоОбработки);
					СтруктураПараметров.Вставить("ТипБД",			ДетальныеЗаписи.ТипБД);
					
				КонецЕсли;
				
				ОбластьЗаписи.Параметры.ДанныеРасчета=СтруктураПараметров;
				
			КонецЕсли;
			
			ТабДок.Вывести(ОбластьЗаписи);
			
			КонецЕсли;
			
		КонецЦикла;
		
		ТабДок.ЗакончитьГруппуСтрок();
			
	КонецЦикла;	
	
КонецПроцедуры // ВывестиДанныеПоСобытиям() 
