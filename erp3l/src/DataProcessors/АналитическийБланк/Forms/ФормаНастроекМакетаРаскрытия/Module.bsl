
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТипМакета 						= Параметры.ТипОбласти;	
	ТабДокОбластиАдрес 				= Параметры.ТабДокОбластиАдрес;
	ТзРашифровкаОтборов				= ПолучитьИзВременногоХранилища(Параметры.ТзРашифровкаОтборовАдрес);		
	ТзДоступныеАналитики		   	= ПолучитьИзВременногоХранилища(Параметры.ТзДоступныеАналитикиАдрес);	
	ТзВложенныхОбластей             = ПолучитьИзВременногоХранилища(Параметры.ТзВложенныхОбластейАдрес);

	ТабДокОбразец.Вывести(ПолучитьИзВременногоХранилища(ТабДокОбластиАдрес));
	
	НачальнаяКоордината = 0;
	тУзелДерева = ДеревоСтруктуры;
	
	тУзелДерева 							= ДеревоСтруктуры.ПолучитьЭлементы().Добавить();
	тУзелДерева.АналитикаПредставление     = Нстр("ru = 'Структура аналитик макета'");
	
	Для Каждого тОбласть Из ТзВложенныхОбластей Цикл		
		Если тОбласть.НачальнаяКоордината>НачальнаяКоордината Тогда		
			тУзелДерева = тУзелДерева.ПолучитьЭлементы().Добавить();		
		КонецЕсли;		
		
		СтруктураАналитик = ЗначениеИзСтрокиВнутр(тОбласть.СтруктураАналитик);
		тСтруктураАналитик	    = Новый Структура;
						
		Для Каждого СтрАналитика Из СтруктураАналитик Цикл	
			
			ТзСвойствАналитики 		= СтруктураАналитик.СкопироватьКолонки();
	
			нСвойствоАналитики = ТзСвойствАналитики.Добавить();
			ЗаполнитьЗначенияСвойств(нСвойствоАналитики,СтрАналитика);
			тСтруктураАналитик.Вставить(СтрАналитика.АналитикаКод,ТзСвойствАналитики);		
			ДоступнаяАналитика = ТзДоступныеАналитики.НайтиСтроки(Новый Структура("АналитикаКод",СтрАналитика.АналитикаКод))[0];
			ДоступнаяАналитика.АналитикаСортировка = СтрАналитика.АналитикаСортировка;	
						
		КонецЦикла;	
		
		тУзелДерева.АналитикаПредставление 				= ПолучитьПредставлениеГруппировкиСервер(тСтруктураАналитик);
		тУзелДерева.ИмяОбласти			   			  	= тОбласть.ИмяОбласти;
		тУзелДерева.СтруктураАналитикСтрока			   	= ЗначениеВСтрокуВнутр(тСтруктураАналитик);

	КонецЦикла;	
	
	ТзДоступныеАналитикиАдрес = ЗначениеВСтрокуВнутр(ТзДоступныеАналитики);
	
	Для Каждого СтрОтбор Из  ТзРашифровкаОтборов Цикл	
		нСтр  = ПараметрыОтбора.Добавить();
		ЗаполнитьЗначенияСвойств(Нстр,СтрОтбор);
		ТекСубконто =  ПланыВидовХарактеристик.ВидыСубконтоКорпоративные.НайтиПоКоду(СтрОтбор.ПолеКод);
		Если ЗначениеЗаполнено(ТекСубконто) Тогда
			нСтр.ПолеСсылка  = ТекСубконто;
		КонецЕсли;	
		
		нСтр.ЗначениеОтбора = ?(НЕ ЗначениеЗаполнено(СтрОтбор.ЗначениеОтбораСтрока),"",ЗначениеИзСтрокиВнутр(СтрОтбор.ЗначениеОтбораСтрока));	
		нСтр.ОтборПредставление = АналитическийБланкГенерацияМакетаУХСервер.ПолучитьПредставлениеОтбора(СтрОтбор.Отбор);
		нСтр.ПолеПредставление 	= АналитическийБланкГенерацияМакетаУХСервер.ПолучитьПредставлениеПоля(СтрОтбор.Поле);
			
	КонецЦикла;
		
	ОбновитьДоступныеОтборыИСортировки();
		
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	
	Закрыть(ПодготовитьСтруктуруПараметров());  
		
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтруктурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗАполнено(Элемент.ТекущиеДанные.СтруктураАналитикСтрока) Тогда
		 Возврат;
	КонецЕсли;	
	
	СтандартнаяОбработка = Ложь;
		
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДоступныеАналитикиСтрока"	,ТзДоступныеАналитикиАдрес);
	СтруктураПараметров.Вставить("ТекущиеАналитикиГруппы"	,Элемент.ТекущиеДанные.СтруктураАналитикСтрока);

	Оповещение = Новый ОписаниеОповещения("ФормаРедактированияСоставаГруппировкиЗавершение", ЭтаФорма);
	ОткрытьФорму("Обработка.АналитическийБланк.Форма.ФормаРедактированияСоставаГруппировки",СтруктураПараметров,,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтруктурыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДоступныеАналитикиСтрока",ТзДоступныеАналитикиАдрес);
	
	Оповещение = Новый ОписаниеОповещения("ФормаВыбораРеквизитовЗавершение", ЭтаФорма);
	ОткрытьФорму("Обработка.АналитическийБланк.Форма.ФормаВыбораРеквизитов",СтруктураПараметров,,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаРедактированияСоставаГруппировкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено  Или Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;	
	
	ТекЭлДерева = ДеревоСтруктуры.НайтиПоИдентификатору(Элементы.ДеревоСтруктуры.ТекущаяСтрока);
	ТекЭлДерева.АналитикаПредставление 		             = ПолучитьПредставлениеГруппировки(Результат.СтруктураАналитикСтрока);
	ТекЭлДерева.СтруктураАналитикСтрока					 = Результат.СтруктураАналитикСтрока;		
	//ТекЭлДерева.ИерархияАналитикСтрока					 = Результат.ИерархияАналитикСтрока;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПредставлениеГруппировки(СтруктураАналитикСтрока)
	
	СтруктураАналитик = ЗначениеИзСтрокиВнутр(СтруктураАналитикСтрока);
	
	ПолеПредставление = "";
	
	Для Каждого Стр Из СтруктураАналитик Цикл		
		
		тИерархия         = Стр.Значение[0].ИерархииАналитики;
		ПолеИерархия      = "";
		
		Если ЗначениеЗаполнено(тИерархия) И НЕ тИерархия = ПредопределенноеЗначение("ТипГруппировкиКомпоновкиДанных.Элементы") Тогда
			 ПолеИерархия = "("+Строка(тИерархия)+")";
		КонецЕсли;	
		
		ПолеПредставление = ПолеПредставление+Стр.Значение[0].АналитикаПредставление+ПолеИерархия+",";
				
	КонецЦикла;	

	ПолеПредставление = Лев(ПолеПредставление,СтрДлина(ПолеПредставление)-1);
	
	Возврат ПолеПредставление;
		
КонецФункции	

&НаСервереБезКонтекста
Функция ПолучитьПредставлениеГруппировкиСервер(СтруктураАналитик)
	
	ПолеПредставление = "";
	
	Для Каждого Стр Из СтруктураАналитик Цикл		
			
		ПолеИерархия      = "";
		
		Если НЕ Стр.Значение[0].Владелец().Колонки.Найти("ИерархииАналитики") = Неопределено Тогда
			тИерархия         = Стр.Значение[0].ИерархииАналитики;
		Иначе	 
			тИерархия  = "";
		КонецЕсли;	
	
		Если ЗначениеЗаполнено(тИерархия) И НЕ тИерархия = ПредопределенноеЗначение("ТипГруппировкиКомпоновкиДанных.Элементы") Тогда
			 ПолеИерархия = "("+Строка(тИерархия)+")";
		КонецЕсли;	
		
		ПолеПредставление = ПолеПредставление+Стр.Значение[0].АналитикаПредставление+ПолеИерархия+",";
				
	КонецЦикла;	

	ПолеПредставление = Лев(ПолеПредставление,СтрДлина(ПолеПредставление)-1);
	
	Возврат ПолеПредставление;
		
КонецФункции

&НаКлиенте
Процедура ФормаВыбораРеквизитовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено  Или Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;	
			
	Если Элементы.ДеревоСтруктуры.ТекущиеДанные = Неопределено Тогда	
		 НэлДерева = ДеревоСтруктуры.ПолучитьЭлементы().Добавить();
		 НэлДерева.АналитикаПредставление 		 			 = Результат.ПолеПредставление;
		 НэлДерева.СтруктураАналитикСтрока					 = Результат.СтруктураАналитикСтрока;	 
	Иначе	
		 ТекЭлДерева = ДеревоСтруктуры.НайтиПоИдентификатору(Элементы.ДеревоСтруктуры.ТекущаяСтрока);
		 НэлДерева   = ТекЭлДерева.ПолучитьЭлементы().Добавить();
		 НэлДерева.АналитикаПредставление 		             = Результат.ПолеПредставление;
		 НэлДерева.СтруктураАналитикСтрока					 = Результат.СтруктураАналитикСтрока;		
		 Элементы.ДеревоСтруктуры.Развернуть(ТекЭлДерева.ПолучитьИдентификатор(),Истина);
	КонецЕсли;	
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступныеОтборыИСортировки();
	
	ТзДоступныеАналитики 			= ЗначениеИзСтрокиВнутр(ТзДоступныеАналитикиАдрес);
	ВыбранныеАналитики              = Новый Структура;
	ПолучитьПоляГруппировокРекурсивно(ТзДоступныеАналитики,ДеревоСтруктуры.ПолучитьЭлементы(),ВыбранныеАналитики);
	
	МассивУдаляемыхОтборов = Новый Массив;
	Для Каждого СтрОтбор Из ПараметрыОтбора Цикл
		Если НЕ ВыбранныеАналитики.Свойство(СтрОтбор.ПолеКод) Тогда	
			 МассивУдаляемыхОтборов.Добавить(СтрОтбор);
		КонецЕсли;	
	КонецЦикла;	
	Для Каждого СтрОтбор Из МассивУдаляемыхОтборов Цикл
		ПараметрыОтбора.Удалить(СтрОтбор);
	КонецЦикла;	
	
	ИнициализироватьПоляСкд(ВыбранныеАналитики);
	
КонецПроцедуры

&НаСервере
Процедура  ПолучитьПоляГруппировокРекурсивно(ТзДоступныеАналитики,ТекущийУровень,ВыбранныеАналитики)
	
	Для Каждого Стр Из ТекущийУровень Цикл	
		
		Если Стр.АналитикаПредставление = Нстр("ru = 'Структура аналитик макета'") Тогда
			ПолучитьПоляГруппировокРекурсивно(ТзДоступныеАналитики,Стр.ПолучитьЭлементы(),ВыбранныеАналитики);
			Продолжить;
		КонецЕсли;	
		
		ВыбранныеАналитикиУровня =  ЗначениеИзСтрокиВнутр(Стр.СтруктураАналитикСтрока);
		Для Каждого ПолеАналитики Из ВыбранныеАналитикиУровня Цикл
			
			ВыбранныеАналитики.Вставить(ПолеАналитики.Ключ);
			
			Если ПолеАналитики.Ключ = "ПериодОтчета" Тогда 
				Если ПараметрыОтбора.НайтиСтроки(Новый Структура("ПолеКод","ПериодС")).Количество() = 1 Тогда	
					ВыбранныеАналитики.Вставить("ПериодС");
					ВыбранныеАналитики.Вставить("ПериодПо");
					Продолжить;
				КонецЕсли;
			Иначе	
				Если ПараметрыОтбора.НайтиСтроки(Новый Структура("ПолеКод",ПолеАналитики.Ключ)).Количество() = 1 Тогда	
					Продолжить;
				КонецЕсли;	
			КонецЕсли;
			
			нДоступныйЭлементы = ТзДоступныеАналитики.НайтиСтроки(Новый Структура("АналитикаКод",ПолеАналитики.Ключ));
			Если нДоступныйЭлементы.Количество() = 1 Тогда
				НовыйОтбор = ПараметрыОтбора.Добавить();
				НовыйОтбор.Использовать = Истина;
				НовыйОтбор.Поле 				= нДоступныйЭлементы[0].АналитикаПредставление;
				НовыйОтбор.ПолеКод 				= нДоступныйЭлементы[0].АналитикаКод;
				ТекСубконто =  ПланыВидовХарактеристик.ВидыСубконтоКорпоративные.НайтиПоКоду(НовыйОтбор.ПолеКод);
				Если ЗначениеЗаполнено(ТекСубконто) Тогда
					НовыйОтбор.ПолеСсылка  = ТекСубконто;
				КонецЕсли;	
				НовыйОтбор.ТипЗначенияСтрока    = нДоступныйЭлементы[0].АналитикаТипСтрока;
				Если НовыйОтбор.ПолеКод = "Организация" Тогда
					НовыйОтбор.Отбор =  Нстр("ru = 'Организация отчета'");	
					НовыйОтбор.ПорядокОтбора = 4;
				ИначеЕсли НовыйОтбор.ПолеКод = "Проект" Тогда
					НовыйОтбор.Отбор =  Нстр("ru = 'Проект отчета'");
					НовыйОтбор.ПорядокОтбора = 5;
				ИначеЕсли НовыйОтбор.ПолеКод = "Сценарий" Тогда
					НовыйОтбор.Отбор =  Нстр("ru = 'Сценарий отчета'");
					НовыйОтбор.ПорядокОтбора = 3;
				ИначеЕсли НовыйОтбор.ПолеКод = "ПериодОтчета" Тогда
					НовыйОтбор.ПолеКод = "ПериодС";
					НовыйОтбор.Отбор 		=  Нстр("ru = 'Период начала отчета'");
					НовыйОтбор.Поле 		= Нстр("ru = 'Период начала отбора'");
					НовыйОтбор.ПорядокОтбора = 1;
					НовыйОтбор = ПараметрыОтбора.Добавить();
					НовыйОтбор.Использовать = Истина;
					НовыйОтбор.Поле 				= нДоступныйЭлементы[0].АналитикаПредставление;
					НовыйОтбор.ПолеКод 				= "ПериодПо";
					НовыйОтбор.Поле 				= Нстр("ru = 'Период окончания отбора'");
					НовыйОтбор.ТипЗначенияСтрока    = нДоступныйЭлементы[0].АналитикаТипСтрока;
					НовыйОтбор.Отбор 		=  Нстр("ru = 'Период окончания отчета'");
					ВыбранныеАналитики.Вставить("ПериодС");
					ВыбранныеАналитики.Вставить("ПериодПо");	
					НовыйОтбор.ПорядокОтбора = 2;
				Иначе	
					НовыйОтбор.Отбор =  Нстр("ru = 'Отбор не производится'");
					НовыйОтбор.ПорядокОтбора = 99;
				КонецЕсли;	
				
				НовыйОтбор.ОтборПредставление 	= НовыйОтбор.Отбор;
				НовыйОтбор.ПолеПредставление 	= НовыйОтбор.Поле;

				
			КонецЕсли;			
		КонецЦикла;
		
		ПолучитьПоляГруппировокРекурсивно(ТзДоступныеАналитики,Стр.ПолучитьЭлементы(),ВыбранныеАналитики);
		
	КонецЦикла;
			
КонецПроцедуры	

&НаКлиенте
Процедура ПараметрыОтбораОтборПредставлениеПриИзменении(Элемент)
	
	АналитическийБланкУХКлиент.ПараметрыОтбораОтборПриИзменении(Элемент,Элементы);

КонецПроцедуры

&НаКлиенте
Процедура ПараметрыОтбораОтборПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	АналитическийБланкУХКлиент.ЗаполнитьСписокТиповОтбора(Элементы.ПараметрыОтбораОтбор.СписокВыбора,Элемент.СписокВыбора,Элементы.ПараметрыОтбора.ТекущиеДанные,Ложь,ПоддерживаетИерархию(Элементы.ПараметрыОтбора.ТекущиеДанные.ТипЗначенияСтрока));

КонецПроцедуры


&НаКлиенте
Процедура ПараметрыОтбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	АналитическийБланкУХКлиент.ПараметрыОтбораВыбор(Элементы,Элемент,СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтруктурыПриИзменении(Элемент)
	
	ОбновитьДоступныеОтборыИСортировки();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьПоляСкд(ВыбранныеАналитики)
	
	МакетСкд = ПолучитьОбщийМакет("МакетНастройкиОтборов");	
	МакетСкд.НаборыДанных[0].Поля.Очистить();
	КомпоновщикНастроек.Настройки.Порядок.Элементы.Очистить();		
	ТзДоступныеАналитики 			= ЗначениеИзСтрокиВнутр(ТзДоступныеАналитикиАдрес);
	
	Для Каждого ДоступнаяАналитика Из ТзДоступныеАналитики Цикл	
		Если ДоступнаяАналитика.АналитикаКод = "ПериодОтчета" Тогда
			 Продолжить;
		КонецЕсли;		
		ИмяДляПоиска = "";
		
		АналитическийБланкУХСервер.ДобавитьОписаниеПоляСКД(ДоступнаяАналитика.АналитикаКод,ДоступнаяАналитика.АналитикаПредставление,ДоступнаяАналитика.АналитикаТипСтрока,МакетСкд);
				
	КонецЦикла;	
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(МакетСКД, УникальныйИдентификатор)));
	
	Для Каждого ДоступнаяАналитика Из ТзДоступныеАналитики Цикл 		
		Если ДоступнаяАналитика.АналитикаКод = "ПериодОтчета" Тогда
			Продолжить;
		КонецЕсли;	
		
		Если НЕ ВыбранныеАналитики.Свойство(ДоступнаяАналитика.АналитикаКод) Тогда
			 Продолжить;
		КонецЕсли;		
		ЭлПорядка		 = КомпоновщикНастроек.Настройки.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));	
		ЭлПорядка.Поле  = Новый ПолеКомпоновкиДанных(ДоступнаяАналитика.АналитикаСортировка);
		ЭлПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	КонецЦикла;	
		
КонецПроцедуры	

&НаСервере
Функция ПодготовитьСтруктуруПараметров() 
		
	СтруктураСортировки = Новый Структура;	
	Для Каждого ЭлПорядка Из КомпоновщикНастроек.Настройки.Порядок.Элементы Цикл 
		ПозицияПервойТочки = СтрНайти(ЭлПорядка.Поле,".");
		ПолеКод = Лев(ЭлПорядка.Поле,ПозицияПервойТочки-1);
		СтруктураСортировки.Вставить(ПолеКод,ЭлПорядка.Поле);
	КонецЦикла;	
	
	ОбновитьДоступныеОтборыИСортировки();
		
	Для Каждого Стр Из ПараметрыОтбора Цикл	
		Стр.ЗначениеОтбораСтрока 		=  ЗначениеВСтрокуВнутр(Стр.ЗначениеОтбора);
		Стр.ЗначениеДляПроверкиСтрока	=  ЗначениеВСтрокуВнутр(Стр.ЗначениеДляПроверки);		
	КонецЦикла;	   
		
	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("СтруктураАналитикАдрес",	ПоместитьВоВременноеХранилище(РеквизитформыВЗначение("ДеревоСтруктуры"),Новый УникальныйИдентификатор() ));
	СтруктураОтвета.Вставить("ПараметрыОтбораАдрес",	ПоместитьВоВременноеХранилище(РеквизитформыВЗначение("ПараметрыОтбора"),Новый УникальныйИдентификатор() ));
	СтруктураОтвета.Вставить("СортировкиАдрес",			ПоместитьВоВременноеХранилище(СтруктураСортировки,Новый УникальныйИдентификатор() ));
	СтруктураОтвета.Вставить("МакетГруппировок",		ПоместитьВоВременноеХранилище(ТабДокОбразец,Новый УникальныйИдентификатор() ));

	Возврат СтруктураОтвета;
	
КонецФункции

&НаКлиенте
Процедура ПоменятьГруппировкиМестами(Команда)
	
	ЗаменяемыйЭлемент1 			= ДеревоСтруктуры.НайтиПоИдентификатору(Элементы.ДеревоСтруктуры.ВыделенныеСтроки[0]); 	  
	Аналитика1         			= ЗаменяемыйЭлемент1.АналитикаПредставление;
	АналитикаСтруктура1         = ЗаменяемыйЭлемент1.СтруктураАналитикСтрока;
	ИмяОбласти1                 = ЗаменяемыйЭлемент1.ИмяОбласти;
	
	ЗаменяемыйЭлемент2 = ДеревоСтруктуры.НайтиПоИдентификатору(Элементы.ДеревоСтруктуры.ВыделенныеСтроки[1]);
	
	Аналитика2         			= ЗаменяемыйЭлемент2.АналитикаПредставление;
	АналитикаСтруктура2         = ЗаменяемыйЭлемент2.СтруктураАналитикСтрока;
	ИмяОбласти2                 = ЗаменяемыйЭлемент2.ИмяОбласти;
	
	ЗаменяемыйЭлемент1.АналитикаПредставление  =  Аналитика2;
	ЗаменяемыйЭлемент1.СтруктураАналитикСтрока =  АналитикаСтруктура2;
	ЗаменяемыйЭлемент1.ИмяОбласти 			   =  ИмяОбласти2;
	
	ЗаменяемыйЭлемент2.АналитикаПредставление  =  Аналитика1;
	ЗаменяемыйЭлемент2.СтруктураАналитикСтрока =  АналитикаСтруктура1;
	ЗаменяемыйЭлемент2.ИмяОбласти 			   =  ИмяОбласти1;

	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтруктурыПриАктивизацииСтроки(Элемент)
		
	Элементы.ДеревоСтруктурыПоменятьГруппировки.Доступность =  Элемент.ВыделенныеСтроки.Количество()=2;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтруктурыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
		
	СтрокаПриемник = ДеревоСтруктуры.НайтиПоИдентификатору(Строка);
	СтрокаИсточник = ДеревоСтруктуры.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение[0]);
	
	Если СтрокаИсточник.АналитикаПредставление = Нстр("ru = 'Структура аналитик макета'") Тогда
	     Возврат;
	КонецЕсли;
	
	РодительИсточника = СтрокаИсточник.ПолучитьРодителя().ПолучитьИдентификатор(); 
		
	Если РодительИсточника = Строка Тогда
		 Возврат;
	Иначе		
		
		нСтрока =  СтрокаПриемник.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(нСтрока,СтрокаИсточник);
		
		Элементы.ДеревоСтруктуры.Развернуть(СтрокаПриемник.ПолучитьИдентификатор(),Истина);
		
		ПеренестиВложенныеЭлементыРекурсивно(нСтрока,СтрокаИсточник);
		
		
		СтрокаИсточник.ПолучитьРодителя().ПолучитьЭлементы().Удалить(СтрокаИсточник);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВложенныеЭлементыРекурсивно(нСтрока, СтрокаИсточник)
	
	Для Каждого Стр Из  СтрокаИсточник.ПолучитьЭлементы() Цикл
		новаяСтрока =  нСтрока.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(новаяСтрока,Стр);
		Элементы.ДеревоСтруктуры.Развернуть(нСтрока.ПолучитьИдентификатор(),Истина);

		ПеренестиВложенныеЭлементыРекурсивно(новаяСтрока, Стр);

	КонецЦикла;	
		
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтруктурыПередУдалением(Элемент, Отказ)
	
	 Если Элемент.ТекущиеДанные.АналитикаПредставление = Нстр("ru = 'Структура аналитик макета'") Тогда
	     Отказ = Истина;
	 КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция  ПоддерживаетИерархию(ТипСтрока)
	
	ТипСсылки = СтрРазделить(ТипСтрока,"|");
	
	Для Каждого ТипСтрока_ Из ТипСсылки Цикл
		
		ТипСсылка = Новый(ТипСтрока_);
		
		Если Лев(ТипСтрока_,10) = "Справочник" И  ТипСсылка.Метаданные().Иерархический  Тогда		
			Возврат Истина			
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат Ложь;
		
КонецФункции
	

