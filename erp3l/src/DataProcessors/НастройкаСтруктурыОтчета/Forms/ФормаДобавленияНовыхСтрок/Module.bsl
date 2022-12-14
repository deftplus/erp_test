
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СоздаватьПоказатели = Истина;
	
	НазначениеВидаОтчета = Параметры.ВидОтчета.Предназначение;
	
	Элементы.НовыеСтрокиПодобор_ДДС.Видимость = НазначениеВидаОтчета 	= Перечисления.ПредназначенияЭлементовСтруктурыОтчета.БюджетДвиженияДенежныхСредств;
	Элементы.НовыеСтрокиСтатьиДДС.Видимость   = НазначениеВидаОтчета 	= Перечисления.ПредназначенияЭлементовСтруктурыОтчета.БюджетДвиженияДенежныхСредств;
	
	Элементы.НовыеСтрокиПодбор_БДР.Видимость = НазначениеВидаОтчета 	= Перечисления.ПредназначенияЭлементовСтруктурыОтчета.БюджетДоходовИРасходов;
	Элементы.НовыеСтрокиСтатьиБДР.Видимость   = НазначениеВидаОтчета 	= Перечисления.ПредназначенияЭлементовСтруктурыОтчета.БюджетДоходовИРасходов;
	
   	Элементы.НовыеСтрокиПодбор_Счета.Видимость = НазначениеВидаОтчета  = Перечисления.ПредназначенияЭлементовСтруктурыОтчета.ОборотноСальдоваяВедомость;
	Элементы.НовыеСтрокиСчета.Видимость   	   = НазначениеВидаОтчета  = Перечисления.ПредназначенияЭлементовСтруктурыОтчета.ОборотноСальдоваяВедомость;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("НовыеСтроки",НовыеСтроки);
	ПараметрыЗакрытия.Вставить("СоздаватьПоказатели",СоздаватьПоказатели);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
		
КонецПроцедуры

&НаКлиенте
Процедура ВставитьИзБуфера(Команда)
	
	ОбъектКопирования = Новый COMОбъект("htmlfile");
	ДанныеБуфера =ОбъектКопирования.ParentWindow.ClipboardData.GETdata("Text");
	МассивСтрок = Новый Массив;
    МассивЗначений = Новый Массив;		
	Если КодСимвола(Прав(ДанныеБуфера,1)) = 10 И КодСимвола(Прав(ДанныеБуфера,2)) = 13 Тогда	
		 ДанныеБуфера = Лев(ДанныеБуфера,СтрДлина(ДанныеБуфера)-2);	
	КонецЕсли;	
	
	РазобратьДанныеБУфера(ДанныеБуфера,МассивСтрок,МассивЗначений);
	
	Для Каждого Стр Из МассивЗначений Цикл
		
		Если Стр.Количество()>0 Тогда
			
			 Нстр = НовыеСтроки.Добавить();
			 Нстр.Наименование = Стр[0];
			
		КонецЕсли;	
		
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура РазобратьДанныеБуфера(ДанныеБуфера,МассивСтрок,МассивЗначений)
		     	
	МассивСтрок = СтроковыеФункцииКлиентСерверУХ.РазложитьСтрокуВМассивПодстрок(ДанныеБуфера,Символ(13));	
	Для Каждого Стр Из МассивСтрок Цикл
		Если Лев(Стр,1) = Символ(10) Тогда
			МассивЗначенийСтроки =  СтроковыеФункцииКлиентСерверУХ.РазложитьСтрокуВМассивПодстрок(Прав(Стр,СтрДлина(Стр)-1),"	");
		Иначе
			МассивЗначенийСтроки =  СтроковыеФункцииКлиентСерверУХ.РазложитьСтрокуВМассивПодстрок(Стр,"	");
		КонецЕсли;
		МассивЗначений.Добавить(МассивЗначенийСтроки);
	КонецЦикла;
		 		
КонецПроцедуры	

&НаКлиенте
Процедура ПодборСтатейДДСЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено  Или Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Стр Из Результат Цикл
		
		нСтр 				= НовыеСтроки.Добавить();
		нСтр.СтатьиДДС  	= Стр;
		нСтр.Наименование 	= Строка(Стр);
		
	КонецЦикла;	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборСтатейБДРЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено  Или Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Стр Из Результат Цикл
		
		нСтр 				= НовыеСтроки.Добавить();
		нСтр.СтатьиБДР  	= Стр;
		нСтр.Наименование 	= Строка(Стр);
		
	КонецЦикла;	

	
КонецПроцедуры

&НаКлиенте
Процедура ПодборСчетовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено  Или Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Результат) =  Тип("СправочникСсылка.СчетаБД") Тогда
		нСтр 				= НовыеСтроки.Добавить();
		нСтр.Счета  		= Результат;
		нСтр.Наименование 	= Строка(Результат);		
	Иначе		
		
		Для Каждого Стр Из Результат Цикл	
			нСтр 				= НовыеСтроки.Добавить();
			нСтр.Счета  		= Стр;
			нСтр.Наименование 	= Строка(Стр);	
		КонецЦикла;	
		
	КонецЕсли;
	
КонецПроцедуры



&НаКлиенте
Процедура Подбор_ДДС(Команда)
	
	СтруктураПараметров=Новый Структура;
	
	СтруктураПараметров.Вставить("РежимВыбора",Истина);
	СтруктураПараметров.Вставить("МножественныйВыбор",Истина);
	СтруктураПараметров.Вставить("ЗакрыватьПриВыборе",Истина);
	
	Оповещение 		= Новый ОписаниеОповещения("ПодборСтатейДДСЗавершение", ЭтаФорма);
	
	ОткрытьФорму("Справочник.СтатьиДвиженияДенежныхСредств.ФормаВыбора",СтруктураПараметров,ЭтаФорма,,,,Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура Подбор_БДР(Команда)
	
	СтруктураПараметров=Новый Структура;
	
	СтруктураПараметров.Вставить("РежимВыбора",Истина);
	СтруктураПараметров.Вставить("МножественныйВыбор",Истина);
	СтруктураПараметров.Вставить("ЗакрыватьПриВыборе",Истина);
	
	Оповещение 		= Новый ОписаниеОповещения("ПодборСтатейБДРЗавершение", ЭтаФорма);
	
	ОткрытьФорму("Справочник.СтатьиДоходовИРасходов.ФормаВыбора",СтруктураПараметров,ЭтаФорма,,,,Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура Подбор_Счета(Команда)
	
	СтруктураПараметров=Новый Структура;
	
	СтруктураПараметров.Вставить("РежимВыбора",Истина);
	СтруктураПараметров.Вставить("МножественныйВыбор",Истина);
	СтруктураПараметров.Вставить("ЗакрыватьПриВыборе",Истина);
	
	Оповещение 		= Новый ОписаниеОповещения("ПодборСчетовЗавершение", ЭтаФорма);
	
	ОткрытьФорму("Справочник.СчетаБД.ФормаВыбора",СтруктураПараметров,ЭтаФорма,,,,Оповещение);

КонецПроцедуры
