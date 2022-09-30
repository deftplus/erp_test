
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не СервисДоставки.ПравоРаботыССервисомДоставки(Истина) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ТипГрузоперевозки", ТипГрузоперевозки);
	
	Если НЕ ЗначениеЗаполнено(ТипГрузоперевозки) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не выбран тип грузоперевозки';
													|en = 'Cargo transportation type is not selected'"));
		Отказ = Истина;
		Возврат;
	ИначеЕсли НЕ СервисДоставки.ТипГрузоперевозкиДоступен(ТипГрузоперевозки) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Выбранный тип грузоперевозки не доступен';
													|en = 'The selected cargo transportation type is not available'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	НастроитьФормуПоТипуГрузоперевозки();
	
	ДоступнаОтправкаЗаказовНаДоставку = СервисДоставки.ПравоОтправкиЗаказовНаДоставкуПеревозчику();
	
	Если Не ДоступнаОтправкаЗаказовНаДоставку Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Недостаточно прав для работы с настройками.
			|Должна быть доступна роль ""Отправка заказов на доставку перевозчику""';
			|en = 'Insufficient rights for working with settings.
			|""Sending orders for delivery to carrier"" role is required'"));
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДанныеСервиса();
	ЗаполнитьСпискиВыбора();
	ЗаполнитьДанныеПоУмолчанию();
	
	СервисДоставкиПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимостьДоступность();
	СформироватьПредставлениеВремениОтгрузки();
	СформироватьПредставлениеВремениДоставки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РазмерГабаритПриИзменении(Элемент)
	
	ПриИзмененииГабарита(ЭтотОбъект, ПостфиксЭлемента(Элемент));
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОтгрузкиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуВыбораВремениИДаты(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОтгрузкиОчистка(Элемент, СтандартнаяОбработка)
	
	ВремяОтгрузкиС = Неопределено;
	ВремяОтгрузкиПо =  Неопределено;
	ВремяОтгрузкиОбедС = Неопределено;
	ВремяОтгрузкиОбедПо = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяДоставкиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуВыбораВремениИДаты(2);
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяДоставкиОчистка(Элемент, СтандартнаяОбработка)
	
	ВремяДоставкиС = Неопределено;
	ВремяДоставкиПо =  Неопределено;
	ВремяДоставкиОбедС = Неопределено;
	ВремяДоставкиОбедПо = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура СпособОпределенияКонтактногоЛицаПриИзменении(Элемент)
	
	Если СпособОпределенияКонтактногоЛица <> 2 Тогда
		КонтактноеЛицо = Неопределено;
	КонецЕсли;
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	ТекстОшибки = "";
	Отказ = Ложь;
	
	Если Модифицированность Тогда
		
		Если Не Отказ Тогда
			ЗаписатьНастройкиПоУмолчанию(Отказ, ТекстОшибки);
		КонецЕсли;
		
		Если Не Отказ Тогда
			Модифицированность = Ложь;
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитовФормы

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииГабарита(Форма, ПостФикс)
	
	Форма["Объем" + ПостФикс] = 
		Форма["Длина" + ПостФикс] * Форма["Ширина" + ПостФикс] * Форма["Высота" + ПостФикс]/1000000;
	
КонецПроцедуры

#КонецОбласти

#Область ОрганизацияБизнесСети

&НаСервереБезКонтекста
Функция ОрганизацииБизнесСетиНаСервере()
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(СервисДоставкиСлужебный.ОрганизацииБизнесСети());
	
КонецФункции

&НаСервере
Процедура СписокОрганизацийБизнесСети()
	
	СписокОрганизаций = Элементы.Организация.СписокВыбора;
	СписокОрганизаций.Очистить();
	ОрганизацииБизнесСети = ОрганизацииБизнесСетиНаСервере();
	Для Каждого Строка Из ОрганизацииБизнесСети Цикл
		СписокОрганизаций.Добавить(Строка.Организация, Строка.Наименование);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьДанныеСервиса()
	
	СписокОрганизацийБизнесСети();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеПоУмолчанию()
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	НастройкиДоставки.НаименованиеПараметра КАК НаименованиеПараметра,
	               |	НастройкиДоставки.Значение КАК Значение,
	               |	НастройкиДоставки.ЗначениеХранилищеЗначения КАК ЗначениеХранилищеЗначения
	               |ИЗ
	               |	РегистрСведений.НастройкиОбщиеСервисДоставки КАК НастройкиДоставки
	               |ГДЕ
	               |	НастройкиДоставки.ТипГрузоперевозки = &ТипГрузоперевозки";
	
	Запрос.УстановитьПараметр("ТипГрузоперевозки", ТипГрузоперевозки);
	ДанныеПоУмолчанию = Запрос.Выполнить().Выбрать();
	
	Пока ДанныеПоУмолчанию.Следующий() Цикл
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ЭтотОбъект, 
																		ДанныеПоУмолчанию.НаименованиеПараметра) Тогда
							
			Значение = Неопределено;
			
			Если ЗначениеЗаполнено(ДанныеПоУмолчанию.Значение) Тогда
				Значение = ДанныеПоУмолчанию.Значение;
			ИначеЕсли ЗначениеЗаполнено(ДанныеПоУмолчанию.ЗначениеХранилищеЗначения) Тогда 
				Значение = ДанныеПоУмолчанию.ЗначениеХранилищеЗначения.Получить();
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Значение) Тогда
				ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(ЭтотОбъект, 
																			ДанныеПоУмолчанию.НаименованиеПараметра, 
																			Значение);
			КонецЕсли;
																		
		КонецЕсли;
		
	КонецЦикла;
	
	ПриИзмененииГабарита(ЭтотОбъект, "ЕдиницыТовара");
	ПриИзмененииГабарита(ЭтотОбъект, "ГрузовогоМеста");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьДоступность();
	
	Элементы.КонтактноеЛицо.Доступность = (СпособОпределенияКонтактногоЛица = 2);
	
КонецПроцедуры

#Область ЗаписьНастроек

&НаСервере
Процедура ЗаписатьНастройкиПоУмолчанию(Отказ, ТекстОшибки)
	
	Попытка
		
		НаборЗаписей = РегистрыСведений.НастройкиОбщиеСервисДоставки.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.ТипГрузоперевозки.Установить(ТипГрузоперевозки);
		
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ОрганизацияБизнесСети");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ВесЕдиницыТовара");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ВысотаЕдиницыТовара");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ДлинаЕдиницыТовара");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ШиринаЕдиницыТовара");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ВесГрузовогоМеста");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ВысотаГрузовогоМеста");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ДлинаГрузовогоМеста");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ШиринаГрузовогоМеста");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ВремяДоставкиОбедПо");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ВремяДоставкиОбедС");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ВремяДоставкиПо");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ВремяДоставкиС");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ВремяОтгрузкиОбедПо");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ВремяОтгрузкиОбедС");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ВремяОтгрузкиПо");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ВремяОтгрузкиС");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "КонтактноеЛицо");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "СпособОпределенияКонтактногоЛица");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "СпособДоставки");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "СпособОтгрузки");
		ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, "ЗаказчикРоль");
		
		НаборЗаписей.Записать(Истина);
		
	Исключение
		
		Отказ = Истина;
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбора()
	
	СписокВыбора = Элементы.СпособОпределенияКонтактногоЛица.СписокВыбора;
	СписокВыбора.Очистить();
	СписокВыбора.Добавить(1, НСтр("ru = 'Указывать вручную';
									|en = 'Specify manually'"));
	СписокВыбора.Добавить(2, НСтр("ru = 'Ответственный за доставку';
									|en = 'Person responsible for delivery'"));
	
	СервисДоставкиПереопределяемый.ЗаполнитьСписокВыбораСпособаОпределенияКонтактногоЛица(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗаписьЗначенияПоУмолчанию(НаборЗаписей, НаименованиеПараметра)
	
	Если ЗначениеЗаполнено(ЭтотОбъект[НаименованиеПараметра]) Тогда
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.НаименованиеПараметра = НаименованиеПараметра;
		НоваяЗапись.ТипГрузоперевозки = НаборЗаписей.Отбор.ТипГрузоперевозки.Значение;
		
		Если ТипЗнч(ЭтотОбъект[НаименованиеПараметра]) = Тип("СписокЗначений") Тогда
			НоваяЗапись.ЗначениеХранилищеЗначения = Новый ХранилищеЗначения(ЭтотОбъект[НаименованиеПараметра]);
			НоваяЗапись.Значение = Неопределено;
		Иначе
			НоваяЗапись.Значение = ЭтотОбъект[НаименованиеПараметра];
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиентеНаСервереБезКонтекста
Функция ПостфиксЭлемента(Элемент)
	
	Если СтрНайти(Элемент.Имя, "ЕдиницыТовара") > 0 Тогда
		Возврат "ЕдиницыТовара";
	Иначе
		Возврат "ГрузовогоМеста";
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура НастроитьФормуПоТипуГрузоперевозки()
	
	Если ТипГрузоперевозки = 1 Тогда
		Заголовок = НСтр("ru = '1C:Доставка: Общие настройки';
						|en = '1C:Delivery: Common settings'");
	Иначе
		Заголовок = НСтр("ru = '1C:Курьер: Общие настройки';
						|en = '1C:Courier: Common settings'");
	КонецЕсли;
	
КонецПроцедуры

#Область ВремяОтгрузки

&НаКлиенте
Процедура ОткрытьФормуВыбораВремениИДаты(ВариантВыбораВремени)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьВыборДатыВремени", ЭтаФорма);
	
	ПараметрыОткрытияФормы = Новый Структура;
	
	Если ВариантВыбораВремени = 1 Тогда
		
		ПараметрыОткрытияФормы.Вставить("ВремяРаботыС", ВремяОтгрузкиС);
		ПараметрыОткрытияФормы.Вставить("ВремяРаботыПо", ВремяОтгрузкиПо);
		ПараметрыОткрытияФормы.Вставить("ВремяОбедС", ВремяОтгрузкиОбедС);  
		ПараметрыОткрытияФормы.Вставить("ВремяОбедПо", ВремяОтгрузкиОбедПо);
		ПараметрыОткрытияФормы.Вставить("ВариантВыбораВремени", 1);
		
	ИначеЕсли ВариантВыбораВремени = 2 Тогда
		
		ПараметрыОткрытияФормы.Вставить("ВремяРаботыС", ВремяДоставкиС);
		ПараметрыОткрытияФормы.Вставить("ВремяРаботыПо", ВремяДоставкиПо);
		ПараметрыОткрытияФормы.Вставить("ВремяОбедС", ВремяДоставкиОбедС);  
		ПараметрыОткрытияФормы.Вставить("ВремяОбедПо", ВремяДоставкиОбедПо);
		ПараметрыОткрытияФормы.Вставить("ВариантВыбораВремени", 2);
			
	КонецЕсли;
	
	ПараметрыОткрытияФормы.Вставить("ТипГрузоперевозки", ТипГрузоперевозки);
	
	ОткрытьФорму(
		"Обработка.СервисДоставки.Форма.ВыборВремениПередачиГруза",
		ПараметрыОткрытияФормы,
		ЭтаФорма,,,,ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборДатыВремени(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	ВариантВыбораВремени = 0;
	Если Результат.Свойство("ВариантВыбораВремени", ВариантВыбораВремени) Тогда 
		Если ВариантВыбораВремени = 1 Тогда
			
			Результат.Свойство("ВремяРаботыС", ВремяОтгрузкиС);
			Результат.Свойство("ВремяРаботыПо", ВремяОтгрузкиПо);
			Результат.Свойство("ВремяОбедС", ВремяОтгрузкиОбедС);
			Результат.Свойство("ВремяОбедПо", ВремяОтгрузкиОбедПо);
			
			СформироватьПредставлениеВремениОтгрузки();
			
		ИначеЕсли ВариантВыбораВремени = 2 Тогда

			Результат.Свойство("ВремяРаботыС", ВремяДоставкиС);
			Результат.Свойство("ВремяРаботыПо", ВремяДоставкиПо);
			Результат.Свойство("ВремяОбедС", ВремяДоставкиОбедС);
			Результат.Свойство("ВремяОбедПо", ВремяДоставкиОбедПо);
			
			СформироватьПредставлениеВремениДоставки();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПредставлениеВремениОтгрузки()
	
	ВремяОтгрузкиПредставление = ПредставлениеДатыВремени(ВремяОтгрузкиС, 
									ВремяОтгрузкиПо, 
									ВремяОтгрузкиОбедС, 
									ВремяОтгрузкиОбедПо, 1);
									
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПредставлениеВремениДоставки()
	
	ВремяДоставкиПредставление = ПредставлениеДатыВремени(ВремяДоставкиС, 
									ВремяДоставкиПо, 
									ВремяДоставкиОбедС, 
									ВремяДоставкиОбедПо, 2);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеДатыВремени(ВремяРаботыС, ВремяРаботыПо, ВремяОбедС, ВремяОбедПо, Режим)
	
	СтрокаПредставления = "";
	
	Если ЗначениеЗаполнено(ВремяРаботыС) ИЛИ ЗначениеЗаполнено(ВремяРаботыПо) Тогда
		СтрокаПредставления = СтрокаПредставления + Формат(ВремяРаботыС, "ДФ=HH:mm; ДП=00:00")
			+ "-" + Формат(ВремяРаботыПо, "ДФ=HH:mm");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВремяОбедС) ИЛИ ЗначениеЗаполнено(ВремяОбедПо) Тогда
		СтрокаПредставления = СтрокаПредставления + " (обед " + Формат(ВремяОбедС, "ДФ=HH:mm; ДП=00:00")
			+ "-" + Формат(ВремяОбедПо, "ДФ=HH:mm") + ")";
	КонецЕсли;
	
	Возврат СтрокаПредставления;
	
КонецФункции

#КонецОбласти

#КонецОбласти
