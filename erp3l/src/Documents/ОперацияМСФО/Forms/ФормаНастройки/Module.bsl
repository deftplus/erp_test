
&НаКлиенте
Процедура УстановитьВсеФлажки(Команда)
	
	Если Элементы.ГруппаРегистров.ТекущаяСтраница=Элементы.ГруппаРегистрыНакопления Тогда
		Для Каждого СтрокаРегистра Из СписокРегистровНакопления Цикл
			СтрокаРегистра.Пометка = Истина;
		КонецЦикла;
	Иначе
		Для Каждого СтрокаРегистра Из СписокРегистровСведений Цикл
			СтрокаРегистра.Пометка = Истина;
		КонецЦикла;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеФлажки(Команда)
	
	Если Элементы.ГруппаРегистров.ТекущаяСтраница=Элементы.ГруппаРегистрыНакопления Тогда
		Для Каждого СтрокаРегистра Из СписокРегистровНакопления Цикл
			СтрокаРегистра.Пометка = Ложь;
		КонецЦикла;
	Иначе
		Для Каждого СтрокаРегистра Из СписокРегистровСведений Цикл
			СтрокаРегистра.Пометка = Ложь;
		КонецЦикла;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтандартнуюНастройку(Команда)
	
	СнятьВсеФлажки(Команда);
	Для Каждого СтрокаДвижений Из Регистры Цикл
		Если СтрокаДвижений.ТипРегистра="РегистрНакопления" Тогда
			СтрокаРегистра = СписокРегистровНакопления.НайтиПоЗначению(СтрокаДвижений.Имя);
			СтрокаРегистра.Пометка = СтрокаДвижений.ЕстьДвижения;
		ИначеЕсли СтрокаДвижений.ТипРегистра="РегистрСведений" Тогда
			СтрокаРегистра = СписокРегистровСведений.НайтиПоЗначению(СтрокаДвижений.Имя);
			СтрокаРегистра.Пометка = СтрокаДвижений.ЕстьДвижения;
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНастройку(Команда)
	
	// Сначала удалим те, у которых сняли флажки
	УдаленныеНаборы = "";
	Для Каждого СтрокаТаблицы Из СписокРегистровНакопления Цикл
		Если Не СтрокаТаблицы.Пометка Тогда
			Если ВладелецФормы.Объект.Движения[СтрокаТаблицы.Значение].Количество()>0 Тогда
				УдаленныеНаборы = УдаленныеНаборы + Символы.ПС + " - " + СтрокаТаблицы.Представление;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла; 
	
	Если Не ПустаяСтрока(УдаленныеНаборы) Тогда
		
		ТекстВопроса = НСтр("ru = 'Наборы записей следующих регистров накопления будут удалены: %УдаленныеНаборы% Продолжить?'");
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%УдаленныеНаборы%"    ,  УдаленныеНаборы + Символы.ПС);
		ОтветНаВопрос = Неопределено;

		ДопПараметры = Новый Структура("ТекстВопроса", ТекстВопроса);
		Оповещение = Новый ОписаниеОповещения("Подключаемый_УстановитьНастройку", ЭтотОбъект, ДопПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
		Возврат; 
		
	КонецЕсли; 
	
	// Сначала удалим те, у которых сняли флажки
	УстановитьНастройкуПродолжение();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьНастройку(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ТекстВопроса = ДополнительныеПараметры.ТекстВопроса;    
    
    ОтветНаВопрос = РезультатВопроса;
    Если ОтветНаВопрос <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли; 
    
    УстановитьНастройкуПродолжение();

КонецПроцедуры

&НаКлиенте
Процедура УстановитьНастройкуПродолжение()
    
    УдаленныеНаборы = "";
    Для Каждого СтрокаТаблицы Из СписокРегистровСведений Цикл
		
		Если Не СтрокаТаблицы.Пометка Тогда
            Если ВладелецФормы.Объект.Движения[СтрокаТаблицы.Значение].Количество()>0 Тогда
                УдаленныеНаборы = УдаленныеНаборы + Символы.ПС + " - " + СтрокаТаблицы.Представление;
            КонецЕсли; 
		КонецЕсли;
		
    КонецЦикла; 
    
    Если Не ПустаяСтрока(УдаленныеНаборы) Тогда
		
		ТекстВопроса = НСтр("ru = 'Наборы записей следующих регистров сведений будут удалены: %УдаленныеНаборы% Продолжить?'");
        ТекстВопроса = СтрЗаменить(ТекстВопроса, "%УдаленныеНаборы%", УдаленныеНаборы + Символы.ПС);
		
		Оповещение = Новый ОписаниеОповещения("Подключаемый_ЗаполнитьНастройкуЗакрыть", ЭтотОбъект);		
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
		Возврат;
		
    КонецЕсли; 
        
    ЗаполнитьСписокРегистровЗакрыть();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗаполнитьНастройкуЗакрыть(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ОтветНаВопрос = РезультатВопроса;
    Если ОтветНаВопрос <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли; 
    
    ЗаполнитьСписокРегистровЗакрыть();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокРегистровЗакрыть()
    
    Для Каждого СтрокаРегистра Из СписокРегистровСведений Цикл
        СписокРегистровНакопления.Добавить(СтрокаРегистра.Значение, СтрокаРегистра.Представление, СтрокаРегистра.Пометка);
    КонецЦикла;     
    
    Закрыть(СписокРегистровНакопления);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресВХранилище = Параметры.АдресВХранилище;
	РегистрыВХранилище = ПолучитьИзВременногоХранилища(АдресВХранилище);
	ЗначениеВРеквизитФормы(РегистрыВХранилище, "Регистры"); 
	Для Каждого СтрокаРегистра Из Регистры Цикл
		Если СтрокаРегистра.ТипРегистра="РегистрНакопления" Тогда
			Если СтрокаРегистра.ВидРегистра Тогда
				СписокРегистровНакопления.Добавить(СтрокаРегистра.Имя, СтрокаРегистра.Синоним, СтрокаРегистра.Отображение,БиблиотекаКартинок.РегистрНакопления);
			Иначе
				СписокРегистровНакопления.Добавить(СтрокаРегистра.Имя, СтрокаРегистра.Синоним, СтрокаРегистра.Отображение,БиблиотекаКартинок.РегистрНакопления);
			КонецЕсли;
		ИначеЕсли СтрокаРегистра.ТипРегистра="РегистрСведений" Тогда
			СписокРегистровСведений.Добавить(СтрокаРегистра.Имя, СтрокаРегистра.Синоним, СтрокаРегистра.Отображение,БиблиотекаКартинок.РегистрСведений);
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры
