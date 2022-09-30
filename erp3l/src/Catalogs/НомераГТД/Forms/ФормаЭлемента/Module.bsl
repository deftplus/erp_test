
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОповеститьОВыборе(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ПриЧтенииСозданииНаСервере();
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Заголовок = НСтр("ru = 'Номер таможенной декларации';
					|en = 'Customs declaration number'");
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	Элементы.РНПТ.Видимость = УчетПрослеживаемыхТоваровЛокализация.ИспользоватьУчетПрослеживаемыхИмпортныхТоваров(Дата(1, 1, 1));
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры


#КонецОбласти
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КодИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	ТекущийТекстНомераДекларации = Текст;
	ПодключитьОбработчикОжидания("Подключаемый_ВывестиИнформациюОбОшибкахВНомере", 0.1, Истина);

КонецПроцедуры

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	ТекущийТекстНомераДекларации = Объект.Код;
	КодПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура РНПТПриИзменении(Элемент)
	
	ТекущийТекстНомераДекларации = Объект.Код;
	КодПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	КорректныйПериод = ЗакупкиСервер.КорректныйПериодВводаДокументовНомераТаможеннойДекларации();
	
	НачалоКорректногоПериода = КорректныйПериод.НачалоКорректногоПериода;
	КонецКорректногоПериода  = КорректныйПериод.КонецКорректногоПериода;
	
	ТекущийТекстНомераДекларации = Объект.Код;
	
	ОбновитьИнформациюОбОшибкахВНомере(ТекущийТекстНомераДекларации, 
								   НачалоКорректногоПериода, 
								   КонецКорректногоПериода, 
								   Элементы.ОшибкаВНомереТаможеннойДекларации);

	ОбновитьЭлементыФормы();

КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыФормы()
	
	СформироватьПредставлениеНомераТД();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеНомераТД()
	
	ТаможеннаяДекларация = "";
	Если ПравоДоступа("Просмотр", Метаданные.Документы.ТаможеннаяДекларацияИмпорт) Тогда
		Если Не Объект.СтранаВвозаНеРФ И ЗначениеЗаполнено(Объект.РегистрационныйНомер) Тогда
			ТаможеннаяДекларацияСсылка = Документы.ТаможеннаяДекларацияИмпорт.НайтиПоРеквизиту("НомерДекларации", Объект.РегистрационныйНомер);
			Если Не ТаможеннаяДекларацияСсылка.Пустая() Тогда
				ТаможеннаяДекларация = ПолучитьНавигационнуюСсылку(ТаможеннаяДекларацияСсылка);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.РегистрационныйНомер) И ЗначениеЗаполнено(ТаможеннаяДекларация) Тогда
		Часть1 = Новый ФорматированнаяСтрока(НСтр("ru = 'Зарегистрирована декларация:';
													|en = 'Registered declaration:'") + " ");
		Часть2 = Новый ФорматированнаяСтрока(Объект.РегистрационныйНомер,,,,ТаможеннаяДекларация);
		Элементы.ПредставлениеНомераТД.Заголовок = Новый ФорматированнаяСтрока(Часть1, Часть2);
		Элементы.ПредставлениеНомераТД.Видимость = Истина;
	Иначе
		Элементы.ПредставлениеНомераТД.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КодПриИзмененииНаСервере()
	
	Если Объект.РНПТ Тогда
		Объект.РегистрационныйНомер = ТекущийТекстНомераДекларации;
	Иначе
		Реквизиты = Справочники.НомераГТД.РегистрационныйНомерИСтранаВвоза(ТекущийТекстНомераДекларации);
		ЗаполнитьЗначенияСвойств(Объект, Реквизиты, "РегистрационныйНомер,СтранаВвозаНеРФ,ПорядковыйНомерТовара");
	КонецЕсли;
	
	ОбновитьИнформациюОбОшибкахВНомере(ТекущийТекстНомераДекларации, 
									   НачалоКорректногоПериода, 
									   КонецКорректногоПериода, 
									   Элементы.ОшибкаВНомереТаможеннойДекларации);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВывестиИнформациюОбОшибкахВНомере()
	
	ОбновитьИнформациюОбОшибкахВНомере(ТекущийТекстНомераДекларации, 
									   НачалоКорректногоПериода, 
									   КонецКорректногоПериода, 
									   Элементы.ОшибкаВНомереТаможеннойДекларации);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИнформациюОбОшибкахВНомере(ТекущийТекстНомераДекларации, 
											 НачалоКорректногоПериода, 
											 КонецКорректногоПериода, 
											 ЭлементОшибкаВНомереТаможеннойДекларации)

	КодОшибки = ЗакупкиКлиентСервер.ПроверитьКорректностьНомераТаможеннойДекларации(
		ТекущийТекстНомераДекларации, НачалоКорректногоПериода, КонецКорректногоПериода);
		
	ЭлементОшибкаВНомереТаможеннойДекларации.Заголовок = ЗакупкиКлиентСервер.ТекстОшибкиВНомереТаможеннойДекларации(КодОшибки);
	ЭлементОшибкаВНомереТаможеннойДекларации.Видимость = (Не КодОшибки = 0);

КонецПроцедуры
 

#КонецОбласти