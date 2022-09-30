
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	 НастройкиПолейСводнойТаблицы.Загрузить(ПолучитьИзВременногоХранилища(Параметры.НастройкиПолейСводнойТаблицыАдрес));
	 
	 АналитикаПоле = НастройкиПолейСводнойТаблицы[0].Поле;
	 
	 ЭтаФорма.Заголовок =  ЭтаФорма.Заголовок +" ("+ Строка(АналитикаПоле)+")";
	 
	 Элементы.ГруппаИерархия.ТекущаяСтраница = Элементы.ГруппаИерахияНеПоддерживается;
	 	 
	 МассивТипов = Новый Массив;
	 Для Каждого СтрТип Из АналитикаПоле.ТипЗначения.Типы() Цикл
		 МассивТипов.Добавить(СтрТип);
	 КонецЦикла;		 
	 
	 Если АналитикаПоле = Перечисления.ПостоянныеПоляСводнойТаблицы.Организация Тогда
	     Элементы.ГруппаИерархия.ТекущаяСтраница = Элементы.ГруппаНастройкаИерархии;
	 ИначеЕсли АналитикаПоле = Перечисления.ПостоянныеПоляСводнойТаблицы.Проект Тогда	 
	     Элементы.ГруппаИерархия.ТекущаяСтраница = Элементы.ГруппаНастройкаИерархии;
	 ИначеЕсли АналитикаПоле.ТипЗначения.Типы().Количество() = 1 Тогда;	 
	     Если Справочники.ТипВсеСсылки().СодержитТип(АналитикаПоле.ТипЗначения.Типы()[0]) Тогда	  
	    	 Если АналитикаПоле.ТипЗначения.ПривестиЗначение().Метаданные().Иерархический ТОгда	 
	   		 Если АналитикаПоле.ТипЗначения.ПривестиЗначение().Метаданные().ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов
	    			 ИЛИ АналитикаПоле.ТипЗначения.ПривестиЗначение().Метаданные().ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияЭлементов Тогда 	 
	     				Элементы.ГруппаИерархия.ТекущаяСтраница = Элементы.ГруппаНастройкаИерархии;
	    		 КонецЕсли;	  
	    	 КонецЕсли; 	 
	     КонецЕсли;	 
	 КонецЕсли;	 
	  	 	  
	 СКДТекущегоПоля = ПолучитьОбщийМакет("МакетНастройкиОтборов");
	 
	 НП =  СКДТекущегоПоля.НаборыДанных[0].Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
	 НП.Заголовок			= АналитикаПоле.Наименование;
	 НП.ПутьКДанным 		= АналитикаПоле.Код;
	 НП.ТипЗначения 		= Новый ОписаниеТипов(МассивТипов);
	 НП.Поле 				= АналитикаПоле.Код;
	 
	 СКДТекущегоПоляАдрес = ПоместитьВоВременноеХранилище(СКДТекущегоПоля, УникальныйИдентификатор);
	 
	 НастройкиКД.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКДТекущегоПоляАдрес));
	 
	 НастройкиУпрядочивания            = ЗначениеИзСтрокиВнутр(НастройкиПолейСводнойТаблицы[0].ВыражениеУпорядочиванияСКДСтрока);
	 
	 Для Каждого СтрПрядок Из НастройкиУпрядочивания.Элементы Цикл
	 	ЭлементПорядка 					= НастройкиКД.Настройки.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ЗаполнитьЗначенияСвойств(ЭлементПорядка,СтрПрядок); 
	 КонецЦикла;
	 
	 УстановитьВидимостьДоступностьЭлементов();

КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
		
	НастройкиПолейСводнойТаблицы[0].ВыражениеУпорядочивания  = Элементы.НастройкиКДНастройкиПорядок.ТекстРедактирования;
	
	ПрименитьИзмененияСервер();
	                   
	Закрыть(Новый Структура("НастройкиПолейСводнойТаблицыАдрес",НастройкиПолейСводнойТаблицыАдрес));
	
КонецПроцедуры

&НаСервере
Процедура ПрименитьИзмененияСервер()
					
	тНастройкиПолейСводнойТаблицы = НастройкиПолейСводнойТаблицы.Выгрузить();
	
	тНастройкиПолейСводнойТаблицы[0].ВыражениеУпорядочиванияСКДСтрока =  ЗначениеВСтрокуВнутр(НастройкиКД.Настройки.Порядок);
	
	НастройкиПолейСводнойТаблицыАдрес = ПоместитьВоВременноеХранилище(тНастройкиПолейСводнойТаблицы, Новый УникальныйИдентификатор);
	
КонецПроцедуры	

&НаКлиенте
Процедура КонструкторВыраженияПредставленияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	 
	Если  Результат = Неопределено ИЛИ Результат = КодВозвратаДиалога.Отмена Тогда
		  Возврат;
	КонецЕсли;	
	
	НастройкиПолейСводнойТаблицы[0].ВыражениеПредставления = Результат;	
		
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПредставленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Параметры_ = Новый Структура("СКДТекущегоПоляАдрес,АналитикаСубконто,ТекущееПредставление",СКДТекущегоПоляАдрес,НастройкиПолейСводнойТаблицы[0].Поле,Элементы.СтрокаПредставления.ТекстРедактирования);	
	Оповещение = Новый ОписаниеОповещения("КонструкторВыраженияПредставленияЗавершение", ЭтаФорма);	
	ОткрытьФорму("Обработка.АналитическийБланкСводнаяТаблица.Форма.ФормаКонструктораВыраженияПредставления", 
	Параметры_,,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 		

КонецПроцедуры

&НаКлиенте
Процедура ПоддерживатьИерархию1ПриИзменении(Элемент)
	
	УстановитьВидимостьДоступностьЭлементов()

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Элементы.ГруппаНастройкиИерархии.Видимость = НастройкиПолейСводнойТаблицы[0].ВыводитьИерархиюЭлементов;
	
КонецПроцедуры




