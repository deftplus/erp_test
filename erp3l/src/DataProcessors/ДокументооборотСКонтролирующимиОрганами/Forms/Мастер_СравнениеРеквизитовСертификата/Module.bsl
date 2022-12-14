
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТипЗаявления               = Параметры.ТипЗаявления;
	ЭтоВторичное               = ТипЗаявления = Перечисления.ТипыЗаявленияАбонентаСпецоператораСвязи.Изменение;
	СертификатДляПодписания    = Параметры.СертификатДляПодписания;
	СпособПолученияСертификата = Параметры.АдресТаблицыСравненияРеквизитов;
	ИспользоватьСуществующий   = ОбработкаЗаявленийАбонентаКлиентСервер.ИспользоватьСуществующий(Параметры);
	ПредставлениеСертификата   = ДокументооборотСКОКлиентСервер.ПредставлениеСертификата(СертификатДляПодписания);
	
	ТаблицаЗначенийСравненияРеквизитов = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыСравненияРеквизитов);
	ЗначениеВРеквизитФормы(ТаблицаЗначенийСравненияРеквизитов, "ТаблицаСравненияРеквизитов");
	
	Элементы.ТаблицаСравненияРеквизитов.ТекущаяСтрока = -1;
	
	ИзменитьОформлениеФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстПоясненияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КриптографияЭДКОКлиент.ПоказатьСертификат(СертификатДляПодписания);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаменитьЗначения(Команда)
	
	Если АвтоматическоеИсправлениеНевозможно Тогда
		Закрыть();
	Иначе
		Закрыть(НСтр("ru = 'Взять из сертификата';
					|en = 'Take from the certificate'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВБумажномВиде(Команда)
	
	Закрыть(НСтр("ru = 'В бумажном виде';
				|en = 'In paper form'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЭлектронноеПодписаниеНевозможно()
	
	ЭлектронноеПодписаниеНевозможно = Ложь;
	
	Для каждого СтрокаТаблицы Из ТаблицаСравненияРеквизитов Цикл
		
		Если СтрокаТаблицы.Различается Тогда
			
			Если СтрокаТаблицы.Наименование = НСтр("ru = 'Страна';
													|en = 'Country'") Тогда
			
				ЭлектронноеПодписаниеНевозможно = Истина;
				Прервать;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЭлектронноеПодписаниеНевозможно;
	
КонецФункции

&НаСервере
Функция АвтоматическоеИсправлениеНевозможно()
	
	АвтоматическоеИсправлениеНевозможно = Ложь;
	
	Если ИспользоватьСуществующий Тогда
		АвтоматическоеИсправлениеНевозможно = Истина;
	Иначе
	
		Для каждого СтрокаТаблицы Из ТаблицаСравненияРеквизитов Цикл
			
			Если СтрокаТаблицы.Различается Тогда
				
				Если СтрокаТаблицы.Наименование = НСтр("ru = 'Регион';
														|en = 'State'")
					ИЛИ СтрокаТаблицы.Наименование = НСтр("ru = 'Страна';
															|en = 'Country'")
					ИЛИ СтрокаТаблицы.Наименование = НСтр("ru = 'Фамилия владелеца';
															|en = 'Owner last name'")
					ИЛИ СтрокаТаблицы.Наименование = НСтр("ru = 'Имя Отчество';
															|en = 'Name Patronymic'") Тогда
				
					АвтоматическоеИсправлениеНевозможно = Истина;
					Прервать;
					
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат АвтоматическоеИсправлениеНевозможно;
	
КонецФункции

&НаСервере
Процедура ИзменитьОформлениеФормы()
	
	ЭлектронноеПодписаниеНевозможно 	= ЭлектронноеПодписаниеНевозможно();
	АвтоматическоеИсправлениеНевозможно = АвтоматическоеИсправлениеНевозможно();
	
	Подстрока1 = НСтр("ru = 'Некоторые реквизиты сертификата ';
						|en = 'Some attributes of the certificate'");
	
	Если ИспользоватьСуществующий Тогда
		Подстрока2 = Новый ФорматированнаяСтрока(ПредставлениеСертификата,,,,"Сертификат");
		Подстрока3 = НСтр("ru = ' отличаются от указанных в заявлении. ';
							|en = ' differ from those specified in the application.'");
		Подстрока4 = НСтр("ru = 'Перечисленные ниже реквизиты должны совпадать в заявлении и в сертификате.';
							|en = 'The attributes listed below must be the same in the application and in the certificate.'");
	Иначе
		Подстрока2 = Новый ФорматированнаяСтрока(ПредставлениеСертификата,,,,"Сертификат");
		Подстрока3 = НСтр("ru = ' отличаются от указанных в заявлении. ';
							|en = ' differ from those specified in the application.'");
		Подстрока4 = НСтр("ru = 'Чтобы воспользоваться возможностью электронного подписания заявления в нем должны быть указаны такие же реквизиты, как и в сертификате.';
							|en = 'To be able to sign the application digitally, specify the same attributes in it as in the certificate.'");
	КонецЕсли;
	
	Если ИспользоватьСуществующий Тогда
		
		// Нужно исправлять вручную
		Элементы.ФормаЗаменитьЗначения.Заголовок = НСтр("ru = 'Вернуться к заявлению для исправления';
														|en = 'Return to application for change'");
		Элементы.ФормаВБумажномВиде.Видимость 	 = Ложь;
		
	ИначеЕсли ЭлектронноеПодписаниеНевозможно ИЛИ ЭтоВторичное Тогда
		
		// Бумажное подписание невозможно
		Элементы.ФормаЗаменитьЗначения.Видимость 	  = Ложь;
		Элементы.ФормаВБумажномВиде.КнопкаПоУмолчанию = Истина;
		
		Подстрока4 = НСтр("ru = 'В этом случае подписание электронной подписью недоступно, возможно оформление подключения только в бумажном виде.';
							|en = 'In this case, digital signing is unavailable, connection can be registered only in paper form.'");
		
	ИначеЕсли АвтоматическоеИсправлениеНевозможно Тогда
		
		// Нужно исправлять вручную
		Элементы.ФормаЗаменитьЗначения.Заголовок = НСтр("ru = 'Вернуться к заявлению для исправления';
														|en = 'Return to application for change'");
		
	КонецЕсли;
	
	Элементы.ТекстПояснения.Заголовок = Новый ФорматированнаяСтрока(
		Подстрока1,
		Подстрока2,
		Подстрока3,
		Подстрока4);

КонецПроцедуры

#КонецОбласти


