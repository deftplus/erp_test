
&НаКлиенте
Перем ВыбранныеСтроки;


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
   	Область = Параметры.Область;

	Если ЗначениеЗаполнено(Параметры.ОбластьРодитель) Тогда	
		 ОбластьРодитель = Параметры.ОбластьРодитель;
		 
		 ОбластьРодительОбъект = ОбластьРодитель.ПолучитьОбъект();
		 
		 ОбластьРодительОбъект.ПолучитьВыбранныеПоказатели(ПоказателиРодителя);
	
	КонецЕсли;	
		
	ВыбранныеСтроки = Параметры.СписокСтрок.ВыгрузитьЗначения();
	ВыбранныеПоказатели.ЗагрузитьЗначения(Параметры.СписокСтрок.ВыгрузитьЗначения());
	Организация = Параметры.Организация;
	Проект = Параметры.Проект;
	ВидОтчета = Параметры.ВидОтчета;
	
	ОбщегоНазначенияКлиентСерверУХ.УстановитьЭлементОтбора(СтрокиСписок.Отбор,"Владелец",ВидОтчета,ВидСравненияКомпоновкиДанных.Равно,,Истина);
	
	СоздатьТаблицуПоказателей();
	 
	 
КонецПроцедуры


Процедура  СоздатьТаблицуПоказателей()
	
	СТ = РеквизитФормыВЗначение("ОбъектСТ");
	СТ.РежимДиаграммы = Ложь;
	СТ.ВариантОтображенияРесурсов = "ПоБланкам";
	СТ.НазначениеТаблицы = Перечисления.НазначенияИспользованияСводнойТаблицы.ВыборПоказателей;	
	СТ.ВидОтчета = ВидОтчета;
	
	//ТаблицыИнтерфейса = ПолучитьИзВременногоХранилища(ОбъектСТ.АдресТаблицИнтерфейса);
	//СтруктураФильтровИтог = ПолучитьИзВременногоХранилища(ОбъектСТ.АдресСтруктураФильтров);	
		
	СтруктураПараметров = Новый Структура;
    СтруктураПараметров.Вставить("Область",Область);

	
	СтатусВыполнения = СТ.ПолучитьИтоговыйМакетОтбораПоказателей(ПолеТабличногоДокументаМакет,СтруктураПараметров);
			
	ЗначениеВРеквизитФормы(СТ,"ОбъектСТ");
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПоказателиОтчетов.Ссылка,
	|	ПоказателиОтчетов.Колонка,
	|	ПоказателиОтчетов.Строка
	|ИЗ
	|	Справочник.ПоказателиОтчетов КАК ПоказателиОтчетов
	|ГДЕ
	|	ПоказателиОтчетов.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец",ВидОтчета);
	
	ТзПоказателейАдрес = ПоместитьВоВременноеХранилище(Запрос.Выполнить().Выгрузить(),Новый УникальныйИдентификатор);
			
	
	
КонецПроцедуры	

&НаКлиенте
Процедура ВидОтчетаПриИзменении(Элемент)
	
	СоздатьТаблицуПоказателей();
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометки(Команда)
	
	Для Каждого Стр Из Элементы.ПоказателиСписок.ВыделенныеСтроки Цикл
		
		мИндекс = ВыбранныеСтроки.Найти(Стр);
		Если НЕ мИндекс=Неопределено Тогда 
			ВыбранныеСтроки.Удалить(мИндекс);
		КонецЕсли;
	КонецЦикла;	
	
	
	 СтрокиСписок.Параметры.УстановитьЗначениеПараметра("ВыбранныеПоказатели",ВыбранныеСтроки);

	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Закрыть(ВыбранныеСтроки);
	
КонецПроцедуры

Функция ПодготовитьСтруктуруПараметров()
	
	
	
	
КонецФункции	

&НаКлиенте
Процедура Пометить(Команда)
	
	
	Для Каждого Стр Из Элементы.ПоказателиСписок.ВыделенныеСтроки Цикл
		
		мИндекс = ВыбранныеСтроки.Найти(Стр);
		Если мИндекс=Неопределено Тогда 
			ВыбранныеСтроки.Добавить(Стр);
		КонецЕсли;
		
	КонецЦикла;	


	
	 СтрокиСписок.Параметры.УстановитьЗначениеПараметра("ВыбранныеПоказатели",ВыбранныеСтроки);
	
КонецПроцедуры

Процедура ПометитьСервер(Верх,Низ,Лево,Право)  
	
		
	
	ДанныеРасшифровки 	 = ПолучитьИзВременногоХранилища(ОбъектСТ.АдресХранилищаДанныеРасшифровки);
	ТзПоказателей		 = ПолучитьИзВременногоХранилища(ТзПоказателейАдрес);
	
	Для Стр = Верх По Низ Цикл
		
		Для Кол = Лево По Право Цикл
			
			
			СтруктураПолей = Новый Структура;
	        СтруктураПолей.Вставить("СтрокаОтчета");
			СтруктураПолей.Вставить("Колонка");
			СтруктураПолей.Вставить("Показатель");
			
			ТекОбласть =  ПолеТабличногоДокументаМакет.Область(Стр,Кол,Стр,Кол);
			СводнаяТаблицаУХ.ПолучитьРасшифровкуГруппировок(ДанныеРасшифровки.Элементы[ТекОбласть.Расшифровка],СтруктураПолей);
			
			Показатель = ТзПоказателей.НайтиСтроки(Новый Структура("Строка,Колонка",СтруктураПолей.СтрокаОтчета,СтруктураПолей.Колонка));
			
			ВыбранныеПоказатели.Добавить(Показатель[0].Ссылка);
			
		КонецЦикла;
		
		
	КонецЦикла;
		
КонецПроцедуры  

&НаКлиенте
Процедура ПоказателиСписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ПоказателиСписокИспользованТекущей" Тогда
		СтандартнаяОбработка = Ложь;
		Если Элемент.ТекущиеДанные.ИспользованДругими Тогда
			 Возврат;
		КонецЕсли;	
		
		мИндекс = ВыбранныеСтроки.Найти(ВыбраннаяСтрока);
		Если мИндекс=Неопределено Тогда
			ВыбранныеСтроки.Добавить(ВыбраннаяСтрока);       
		Иначе    
			ВыбранныеСтроки.Удалить(мИндекс);
		КонецЕсли;
	КонецЕсли;	
	
	 СтрокиСписок.Параметры.УстановитьЗначениеПараметра("ВыбранныеПоказатели",ВыбранныеСтроки);


КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВыбранныеСтроки = ВыбранныеПоказатели.ВыгрузитьЗначения();

    СтрокиСписок.Параметры.УстановитьЗначениеПараметра("ВыбранныеПоказатели",ВыбранныеСтроки);
    СтрокиСписок.Параметры.УстановитьЗначениеПараметра("Организация",Организация);
	СтрокиСписок.Параметры.УстановитьЗначениеПараметра("Проект",Проект);
	СтрокиСписок.Параметры.УстановитьЗначениеПараметра("ТекущаяОбласть",Область);
		
КонецПроцедуры
  
  
