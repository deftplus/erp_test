#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
			
	Если ЭтоАдресВременногоХранилища(Параметры.АдресКэшВидовСубконто) Тогда
		ЗначениеВРеквизитФормы(ПолучитьИзВременногоХранилища(Параметры.АдресКэшВидовСубконто), "КэшВидовСубконто");
	КонецЕсли;
	
	ТекстПроцедуры = ПолучитьИзВременногоХранилища(Параметры.АдресТекстПроцедуры);			
	Параметры.Свойство("ШаблонПроцесса" , ШаблонПроцесса);	
	ОбновитьДеревоОтборов();

	ТаблицаСохраненныхДоступныхПараметров = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицаДоступныхПараметров);
    Для Каждого тПараметр из ТаблицаДоступныхПараметров Цикл
	    СохраненныйПараметр = ТаблицаСохраненныхДоступныхПараметров.НайтиСтроки(Новый Структура("ИмяПараметра,Потребитель",тПараметр.ИмяПараметра,тПараметр.Потребитель)); 
		Если СохраненныйПараметр.Количество()=1 Тогда
			 тПараметр.ЗначениеПараметра = СохраненныйПараметр[0].ЗначениеПараметра;
			 тПараметр.ТипОтбораПараметра = СохраненныйПараметр[0].ТипОтбораПараметра;
		Иначе	
			 тПараметр.ТипОтбораПараметра = "Значение";
		КонецЕсли;	
	КонецЦикла;
			
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы


&НаКлиенте
Процедура ДеревоОтборовНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ТекСтр = ДеревоОтборов.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение[0]);
	Если НЕ ТекСтр = Неопределено Тогда
		//СтрокаОтбора = ДеревоОтборов.НайтиПоИдентификатору(Т<%Параметры.Организация%>екСтр);
		Если ТекСтр.ТипПоля = "ПолеРесурса" Тогда
			СтандартнаяОбработка = Ложь;            
			Возврат;
		КонецЕсли;                
	Иначе
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	Если ТекСтр.ТипПоля = "Функция" Тогда
		ПараметрыПеретаскивания.Значение = СтрЗаменить(ТекСтр.Элемент,"()","(СтруктураПараметров)");
	Иначе	
		ПараметрыПеретаскивания.Значение = СтрЗаменить(ТекСтр.ПолныйПуть,"Параметры","СтруктураПараметров");
    КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура Применить(Команда)
	
	ОповеститьОВыборе(СохранитьНастройкиВХранилище(ВладелецФормы.УникальныйИдентификатор));
	
КонецПроцедуры

#КонецОбласти


////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ.
//

&НаСервере
Функция СохранитьНастройкиВХранилище(ИдентификаторФормыВладельца)
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("АдресТекстаПроцедуры",ПоместитьВоВременноеХранилище(ТекстПроцедуры, ИдентификаторФормыВладельца));
    СтруктураВозврата.Вставить("АдресПараметров",ПоместитьВоВременноеХранилище(РеквизитФормыВЗначение("ТаблицаДоступныхПараметров"), ИдентификаторФормыВладельца));

	Возврат СтруктураВозврата;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ МОДИФИКАЦИИ/ДОБАВЛЕНИЯ/УДАЛЕНИЯ ВЕТВЕЙ УСЛОВНОГО ПЕРЕХОДА.
//


&НаКлиенте
Процедура ДеревоОтборовПередРазворачиванием(Элемент, Строка, Отказ)
	
	ПередРазворачиваниемСтрокиДереваПолейОтборов(Элемент, Строка, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередРазворачиваниемСтрокиДереваПолейОтборов(Элемент, Строка, Отказ)
	
	СтрокаРазворота=Элемент.ДанныеСтроки(Строка);
	
	Если СтрокаРазворота.ТипПоля <> "Параметры"  Тогда
		 Возврат;
	КонецЕсли;
	
	Если СтрокаРазворота.ПолучитьЭлементы().Количество()>0 И (НЕ ПустаяСтрока(СтрокаРазворота.ПолучитьЭлементы()[0].ПолеБД)) Тогда // Уже разворачивали эту строку
		Возврат;
	КонецЕсли;
		
	СтруктураСтрока=СформироватьСтруктуруСтрокиБД(СтрокаРазворота);

	ПередРазворачиваниемСтрокиРеквизитовАналитики(СтруктураСтрока);	
	СтрокаРазворота.ПолучитьЭлементы().Очистить();
	
	Для Каждого СтрокаКДобавлению ИЗ ДеревоОтборовКэш.ПолучитьЭлементы() Цикл
		
		НоваяСтрока=СтрокаРазворота.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаКДобавлению);
		
		Если СтрокаКДобавлению.ПолучитьЭлементы().Количество()>0 Тогда
			
			ДобавитьПодчиненныеСтроки(СтрокаКДобавлению.ПолучитьЭлементы(),НоваяСтрока);
			
		КонецЕсли;
		
	КонецЦикла;	
	
КонецПроцедуры // ПередРазворачиваниемСтрокиДереваПолейИсточника() 
 

&НаКлиенте
Функция СформироватьСтруктуруСтрокиБД(ДанныеСтрокиАналитики)
	
	СтрокаБД=Новый Структура;
	СтрокаБД.Вставить("СправочникБД",				ДанныеСтрокиАналитики.СправочникБД);
	СтрокаБД.Вставить("ПолеБД",						ДанныеСтрокиАналитики.ПолеБД);
	СтрокаБД.Вставить("ТипЗначения",				ДанныеСтрокиАналитики.ТипЗначения);	
	СтрокаБД.Вставить("ТипДанныхПоля",				ДанныеСтрокиАналитики.ТипДанныхПоля);
	СтрокаБД.Вставить("ТипМетаДанных",				ДанныеСтрокиАналитики.ТипМетаДанных);
	СтрокаБД.Вставить("ПолныйПуть",				    ДанныеСтрокиАналитики.ПолныйПуть);
	
	Возврат СтрокаБД;
	
КонецФункции // СформироватьСтруктуруСтрокиВИБ()

&НаКлиенте
Процедура ДобавитьПодчиненныеСтроки(Строка,ЭлементКоллекции)
	
	Для Каждого СтрокаКДобавлению ИЗ Строка Цикл
		
		НоваяСтрока=ЭлементКоллекции.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаКДобавлению);
		
		Если СтрокаКДобавлению.ПолучитьЭлементы().Количество()>0 Тогда
			
			ДобавитьПодчиненныеСтроки(СтрокаКДобавлению.ПолучитьЭлементы(),НоваяСтрока);
			
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры // ДобавитьПодчиненныеСтроки 

&НаСервере
Процедура ПередРазворачиваниемСтрокиРеквизитовАналитики(СтруктураСтрока) 
	
	Если  СтруктураСтрока.ТипМетаДанных = "Справочник" Тогда
		ОбъектБД = Справочники.СправочникиБД.НайтиПоНаименованию(СтруктураСтрока.СправочникБД,,,Справочники.ТипыБазДанных.ТекущаяИБ);	
	ИначеЕсли СтруктураСтрока.ТипМетаДанных = "Документ" Тогда
		ОбъектБД = Справочники.ДокументыБД.НайтиПоНаименованию(СтруктураСтрока.СправочникБД,,,Справочники.ТипыБазДанных.ТекущаяИБ);		
	КонецЕсли;
	
	Если  ОбъектБД = Неопределено Тогда
	      Возврат;
	КонецЕсли;

	СтрокиКДобавлению = "";
	ДеревоОтборов_ = РеквизитФормыВЗначение("ДеревоОтборовКэш");
	ДеревоОтборов_.Строки.Очистить();
	
			  
	Для Каждого СтрРеквизит ИЗ ОбъектБД.Реквизиты Цикл
			
			СтрокаПоказателей                 	= ДеревоОтборов_.Строки.Добавить();
			СтрокаПоказателей.ПолеБД         	= СтрРеквизит.Имя;
			СтрокаПоказателей.НаименованиеБД 	= СтрРеквизит.Синоним;
			СтрокаПоказателей.ТипПоля 	= "Параметры";
			СтрокаПоказателей.Элемент = СтрРеквизит.Синоним;
			СтрокаПоказателей.ПолныйПуть = СтруктураСтрока.ПолныйПуть+"."+СтрРеквизит.Имя;
			СтрокаПоказателей.ИндексКартинки =10;
			
			Если СтрРеквизит.Имя="Ссылка" Тогда
				
				Если ТипЗнч(ОбъектБД)=Тип("СправочникСсылка.ДокументыБД") ИЛИ ТипЗнч(ОбъектБД)=Тип("СправочникСсылка.СправочникиБД") Тогда
					
					РаботаСПолямиАналитикиУХ.ЗаполнитьПоляТиповРеквизитовБД(СтрокаПоказателей,?(ТипЗнч(ОбъектБД)=Тип("СправочникСсылка.СправочникиБД"),"Справочник","Документ")+"."+ОбъектБД.Наименование,Справочники.ТипыБазДанных.ТекущаяИБ);
					
				КонецЕсли;
				
			Иначе
				
				РаботаСПолямиАналитикиУХ.ЗаполнитьПоляТиповРеквизитовБД(СтрокаПоказателей, СтрРеквизит.ТипДанных,Справочники.ТипыБазДанных.ТекущаяИБ);
				
			КонецЕсли;
			
			Если (СтрокаПоказателей.ТипМетаДанных="Справочник" ИЛИ СтрокаПоказателей.ТипМетаДанных="Документ" ИЛИ СтрокаПоказателей.ТипЗначения.Количество()>1)  Тогда 
				// Добавим строку для дальнейшего раскрытия
				
				НоваяСтрока=СтрокаПоказателей.Строки.Добавить();
				НоваяСтрока.ИндексКартинки =10;
				
			КонецЕсли;
		
		КонецЦикла;	
        ЗначениеВРеквизитФормы(ДеревоОтборов_,"ДеревоОтборовКэш");
		
КонецПроцедуры // ПередРазворачиваниемСтрокиРеквизитовАналитики()

&НаКлиенте
Процедура ДеревоОтборовПриАктивизацииСтроки(Элемент)
	
	ТаблицаДоступныхПараметровКеш.Очистить();
	ТекПараметры = ТаблицаДоступныхПараметров.НайтиСтроки(Новый Структура("Потребитель",Элемент.ТекущиеДанные.Элемент));
	Для Каждого текПараметр Из ТекПараметры Цикл
		НовыйПараметр = ТаблицаДоступныхПараметровКеш.Добавить();
		НовыйПараметр.ИмяПараметра = текПараметр.ИмяПараметра;
		ЗаполнитьЗначенияСвойств(НовыйПараметр,текПараметр);	
		
		
			
			//Если НЕ текПараметр.ТипЗначения[0].Значение = "Произвольный" Тогда
			//	Тип = текПараметр.ТипЗначения[0].Значение; 
			//	Если Найти(текПараметр.ТипЗначения[0].Значение,"Справочник")>0 И  Найти(текПараметр.ТипЗначения[0].Значение,"СправочникСсылка")=0 Тогда
			//		Тип = СтрЗАменить(текПараметр.ТипЗначения[0].Значение,"Справочник","СправочникСсылка");
			//	КонецЕсли;
			//	ОписаниеТипов = Новый ОписаниеТипов (Тип);
			//	ТекЗначение = ОписаниеТипов.ПривестиЗначение(НовыйПараметр.ЗначениеПараметра);
			//	НовыйПараметр.ЗначениеПараметра = ТекЗначение;
			//КонецЕсли;
				
	КонецЦикла;
	
	Если  Элемент.ТекущиеДанные.ТипПоля = "Функция" Тогда
		  ПолучитьПараметрыФункции(Элемент.ТекущиеДанные.Элемент);
	КонецЕсли;	
		
	Если  Элемент.ТекущиеДанные.ТипПоля = "Источник" Тогда
		  ПолучитьПараметрыФункции(Элемент.ТекущиеДанные.Элемент);
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ПолучитьПараметрыФункции(ИмяФункции)
	
	Если ИмяФункции = "ОстаткиДенежныхСредствВКассе()"Тогда
		НП = ТаблицаДоступныхПараметров.Добавить();
		НП.ИмяПараметра = "Организация";
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ТаблицаДоступныхПараметровПриИзменении(Элемент)
	
	дПараметры = ТаблицаДоступныхПараметров.НайтиСтроки(Новый Структура("ИмяПараметра,Потребитель",Элемент.ТекущиеДанные.ИмяПараметра,Элемент.ТекущиеДанные.Потребитель));
	дПараметры[0].ЗначениеПараметра = Элемент.ТекущиеДанные.ЗначениеПараметра;
	дПараметры[0].ТипОтбораПараметра = Элемент.ТекущиеДанные.ТипОтбораПараметра;	
		
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДоступныхПараметровТипОтбораПараметраПриИзменении(Элемент)
	Если  Элементы.ТаблицаДоступныхПараметров.ТекущиеДанные.ТипОтбораПараметра = "Значение" Тогда
		Тип = Элементы.ТаблицаДоступныхПараметров.ТекущиеДанные.ТипЗначения[0].Значение; 
		Если СтрНайти(Тип,"Справочник")>0 И  СтрНайти(Тип,"СправочникСсылка")=0 Тогда
			Тип = СтрЗАменить(Тип,"Справочник","СправочникСсылка");
		КонецЕсли;
		Если НЕ Тип = "Произвольный" Тогда
			Элементы.ТаблицаДоступныхПараметровЗначениеПараметра.ОграничениеТипа = Новый ОписаниеТипов (Тип);
		КонецЕсли;
		
		Элементы.ТаблицаДоступныхПараметровЗначениеПараметра.РежимВыбораИзСписка = Ложь;
        Элементы.ТаблицаДоступныхПараметровЗначениеПараметра.СписокВыбора.Очистить();

	Иначе	
		Элементы.ТаблицаДоступныхПараметровЗначениеПараметра.ОграничениеТипа = Новый ОписаниеТипов ("Строка");
		Элементы.ТаблицаДоступныхПараметровЗначениеПараметра.РежимВыбораИзСписка = Истина;
        Элементы.ТаблицаДоступныхПараметровЗначениеПараметра.СписокВыбора.Очистить();
		Для Каждого кПар из КэшПараметров Цикл
			Элементы.ТаблицаДоступныхПараметровЗначениеПараметра.СписокВыбора.Добавить(кПар.Элемент);
		КонецЦикла;

	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИсточникДанных(Команда)
	
	СтруктураПараметров = Новый Структура;
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ПотребительРасчета",ШаблонПроцесса);
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ПараметрыЗаполнения);
	Оповещение = Новый ОписаниеОповещения("ПолучениеНовогоИсточника", ЭтаФорма);		
	ФормаИД = ОткрытьФорму("Справочник.ИсточникиДанныхДляРасчетов.Форма.ФормаЭлемента",СтруктураПараметров 
	,,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 	
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсточникДанных(Команда)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ", Элементы.ДеревоОтборов.ТекущиеДанные.ИсточникСсылка);
	Оповещение = Новый ОписаниеОповещения("ПолучениеНовогоИсточника", ЭтаФорма);		
	ФормаИД = ОткрытьФорму("Справочник.ИсточникиДанныхДляРасчетов.Форма.ФормаЭлемента",СтруктураПараметров 
	,,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтборовПриАктивизацииЯчейки(Элемент)
	
	Если НЕ Элемент.ТекущиеДанные = Неопределено Тогда
		Элементы.ДеревоОтборовДобавитьИсточникДанных.Доступность = Элемент.ТекущиеДанные.Элемент = Нстр("ru = 'Доступные источники'");	
		Элементы.ДеревоОтборовОткрытьИсточникДанных.Доступность = Элемент.ТекущиеДанные.ТипПоля = "Источник";
	КонецЕсли;
	
КонецПроцедуры
	
&НаКлиенте
Процедура ПолучениеНовогоИсточника(Результат, ДополнительныеПараметры) Экспорт
	
	ПоказатьОповещениеПользователя(,, Нстр("ru = 'Обновление таблицы данных'"), БиблиотекаКартинок.ДлительнаяОперация48);
	ОбновитьДеревоОтборов();
	ЭлементыДерева = ДеревоОтборов.ПолучитьЭлементы();
    Для каждого ЭлементДерева Из ЭлементыДерева Цикл
        Элементы.ДеревоОтборов.Развернуть(ЭлементДерева.ПолучитьИдентификатор());
    КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоОтборов()
	
	ДеревоОтборов_ = РеквизитФормыВЗначение("ДеревоОтборов");	
    ДеревоОтборов_.Строки.Очистить();	
	ДеревоОтборов_=Справочники.ШаблоныУниверсальныхПроцессов.СформироватьДеревоКонтекстаПроцесса(ШаблонПроцесса,ДеревоОтборов_,
	Новый Структура("Реквизиты,Функции"),ТаблицаДоступныхПараметров);
	ЗначениеВРеквизитФормы(ДеревоОтборов_,"ДеревоОтборов");

	Для Каждого дПарамтер Из  ДеревоОтборов_.Строки[0].Строки Цикл
		нПараметр = КэшПараметров.Добавить();
		ЗаполнитьЗначенияСвойств(нПараметр,дПарамтер);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДоступныхПараметровЗначениеПараметраНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если   Элементы.ТаблицаДоступныхПараметров.ТекущиеДанные.ТипОтбораПараметра = "Значение" Тогда
		Тип = Элементы.ТаблицаДоступныхПараметров.ТекущиеДанные.ТипЗначения[0].Значение; 
		Если СтрНайти(Тип,"Справочник")>0 И СтрНайти(Тип,"СправочникСсылка")=0 Тогда
			Тип = СтрЗАменить(Тип,"Справочник","СправочникСсылка");
		КонецЕсли;
		Если НЕ Тип = "Произвольный" Тогда
			Элемент.ОграничениеТипа = Новый ОписаниеТипов (Тип);
			
		КонецЕсли;
		Элемент.РежимВыбораИзСписка = Ложь;
		Элемент.СписокВыбора.Очистить();
	Иначе	
		Элемент.ОграничениеТипа = Новый ОписаниеТипов ("Строка");
		Элемент.РежимВыбораИзСписка = Истина;		
		Элемент.СписокВыбора.Очистить();
		Для Каждого кПар из КэшПараметров Цикл
			Элемент.СписокВыбора.Добавить(кПар.Элемент);
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДоступныхПараметровЗначениеПараметраНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	Элемент.СписокВыбора.Очистить();
	Для Каждого кПар из КэшПараметров Цикл
		Элемент.СписокВыбора.Добавить(кПар.Элемент);
	КонецЦикла;
	
КонецПроцедуры



