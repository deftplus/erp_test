
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьИменаСтраниц();
	
	ИнтеграцияИСПереопределяемый.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	ВетеринарноСопроводительныйДокумент = Параметры.ВетеринарноСопроводительныйДокумент;
	Если ЗначениеЗаполнено(ВетеринарноСопроводительныйДокумент) Тогда
		
		РеквизитыЗаписиЖурнала = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВетеринарноСопроводительныйДокумент, "Идентификатор, Продукция");
		ЭтоЖивыеЖивотные = ИнтеграцияВЕТИСВызовСервера.ПродукцияПринадлежитТипуЖивыеЖивотные(РеквизитыЗаписиЖурнала.Продукция);
		Если ЭтоЖивыеЖивотные Тогда
			Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
		Иначе
			Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		КонецЕсли;
		Элементы.СтраницаИммунизации.Видимость = ЭтоЖивыеЖивотные;
		
	КонецЕсли;
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[0]];
	
	УстановитьТекущуюСтраницуНавигации(ЭтотОбъект);
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	ЦветПроблема    = ЦветаСтиля.ЦветТекстаПроблемаГосИС;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	КомандаДалее(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтраницыФормы  = Элементы.ГруппаСтраницы;
	ИндексСтраницы = ИменаСтраниц.Найти(СтраницыФормы.ТекущаяСтраница.Имя);
	
	Если ИменаСтраниц[ИндексСтраницы + 1] = "СтраницаЗапросОшибка" И ПустаяСтрока(ТекстОшибка) Тогда
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы + 2]];
	Иначе
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы + 1]];
	КонецЕсли;
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	СтраницыФормы  = Элементы.ГруппаСтраницы;
	ИндексСтраницы = ИменаСтраниц.Найти(СтраницыФормы.ТекущаяСтраница.Имя);
	
	Если ИменаСтраниц[ИндексСтраницы - 1] = "СтраницаЗапросОшибка" И ПустаяСтрока(ТекстОшибка) Тогда
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы - 2]];
	Иначе
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы - 1]];
	КонецЕсли;
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВНачало(Команда)
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[0]];
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьИсходящееСообщение") Тогда
		
		ПоказатьЗначение(, ИсходящееСообщение);
		
	ИначеЕсли СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьВходящееСообщение") Тогда
		
		ПоказатьЗначение(, ВходящееСообщение);
		
	Иначе
		
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	УстановитьТекущуюСтраницуНавигации(ЭтотОбъект);
	
	Если ТекущаяСтраница = Элемент.ПодчиненныеЭлементы.СтраницаЗапросОжидание Тогда
		ВыполнениеЗаявкиВЕТИСНачало();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВыполнениеЗаявокВЕТИС_API

&НаСервере
Функция ВыполнениеЗаявкиВЕТИСНачалоНаСервере()
	
	ИсходящееСообщение = Неопределено;
	ВходящееСообщение  = Неопределено;
	
	РезультатОбмена = ИнтеграцияВЕТИС.ПодготовитьЗапросНаОбновлениеВетеринарноСопроводительногоДокумента(
		ВетеринарноСопроводительныйДокумент, УникальныйИдентификатор, ТекстОшибка);
	
	Возврат РезультатОбмена;
	
КонецФункции

&НаКлиенте
Процедура ВыполнениеЗаявкиВЕТИСНачало()
	
	РезультатОбмена = ВыполнениеЗаявкиВЕТИСНачалоНаСервере();
	
	Если РезультатОбмена = Неопределено Тогда
		ПоказатьОшибкуОбмена(ТекстОшибка);
		Возврат;
	КонецЕсли;
	
	ОбработатьРезультатОбменаСВЕТИС(РезультатОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатОбменаСВЕТИС(РезультатОбмена)
	
	Если РезультатОбмена.Ожидать <> Неопределено Тогда
		
		Для Каждого СтрокаТЧ Из РезультатОбмена.Изменения Цикл
			
			ИсходящееСообщение = СтрокаТЧ.ИсходящееСообщение;
			
		КонецЦикла;
		
		СформироватьТекстОжидание();
		
	КонецЕсли;
	
	ИнтеграцияВЕТИСКлиент.ОбработатьРезультатОбмена(РезультатОбмена, ЭтотОбъект,, ОповещениеПриЗавершенииОбмена(), Ложь);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()
	
	ИнтеграцияВЕТИСКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект,, ОповещениеПриЗавершенииОбмена(), Ложь);
	
КонецПроцедуры

&НаКлиенте
Функция ОповещениеПриЗавершенииОбмена()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияРезультатОбработкиЗаявки", ЭтотОбъект);
	
	Возврат ОписаниеОповещения;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьВетеринарныеМероприятия(ДополнительныеДанные)
	
	Для Каждого СтрокаТЧ Из ДополнительныеДанные.immunization Цикл
		
		ЗаписьОбИсследовании = Иммунизация.Добавить();
		ЗаписьОбИсследовании.ТипИммунизации = ИнтеграцияВЕТИСПовтИсп.ТипВетеринарногоМероприятия(СтрокаТЧ.type);
		
		Если СтрокаТЧ.disease <> Неопределено Тогда
			ЗаписьОбИсследовании.НаименованиеБолезниПаразита = СтрокаТЧ.disease.name;
		КонецЕсли;
		
		ЗаписьОбИсследовании.ДатаПроведенияИммунизацииОбработки = СтрокаТЧ.actualDateTime;
		
		Если СтрокаТЧ.medicinalDrug <> Неопределено Тогда
			ЗаписьОбИсследовании.НазваниеИПроизводительВакциныПрепарата = СтрокаТЧ.medicinalDrug.name;
			ЗаписьОбИсследовании.НомерСерииВакциныПрепарата             = СтрокаТЧ.medicinalDrug.series;
		КонецЕсли;
		
		Если СтрокаТЧ.effectiveBeforeDate <> Неопределено Тогда
			ЗаписьОбИсследовании.ДатаОкончанияДействияВакциныПрепарата = СтрокаТЧ.effectiveBeforeDate;
		КонецЕсли;
	
		Если СтрокаТЧ.notes <> Неопределено Тогда
			ЗаписьОбИсследовании.ДополнительныеСведения = СтрокаТЧ.notes;
		КонецЕсли;
		
		ЗаписьОбИсследовании.Идентификатор = СтрокаТЧ.ID;
		
	КонецЦикла;
	
	Для Каждого СтрокаТЧ Из ДополнительныеДанные.laboratoryResearch Цикл
		
		ЗаписьОбИсследовании = ЛабораторныеИсследования.Добавить();
		
		Для Каждого СвязанныйДокумент Из СтрокаТЧ.referencedDocument Цикл
			ЗаписьОбИсследовании.НомерАктаОтбораПроб = СвязанныйДокумент.issueNumber;
			ЗаписьОбИсследовании.ДатаОтбораПроб      = СвязанныйДокумент.issueDate;
		КонецЦикла;
		
		Если СтрокаТЧ.operator <> Неопределено Тогда
			ЗаписьОбИсследовании.НаименованиеЛаборатории = СтрокаТЧ.operator.name;
		КонецЕсли;
		Если СтрокаТЧ.indicator <> Неопределено Тогда
			ЗаписьОбИсследовании.НаименованиеПоказателя = СтрокаТЧ.indicator.name;
			ЗаписьОбИсследовании.ТипПоказателя          = "Показатель";
		КонецЕсли;
		Если СтрокаТЧ.disease <> Неопределено Тогда
			ЗаписьОбИсследовании.НаименованиеПоказателя = СтрокаТЧ.disease.name;
			ЗаписьОбИсследовании.ТипПоказателя          = "Болезнь";
		КонецЕсли;
		
		ЗаписьОбИсследовании.ДатаПолученияРезультата = СтрокаТЧ.actualDateTime;
		
		Если СтрокаТЧ.method <> Неопределено Тогда
			ЗаписьОбИсследовании.МетодИсследования = СтрокаТЧ.method;
		КонецЕсли;
		
		Если СтрокаТЧ.expertiseID <> Неопределено Тогда
			ЗаписьОбИсследовании.НомерЭкспертизы = СтрокаТЧ.expertiseID;
		КонецЕсли;
		Если СтрокаТЧ.conclusion <> Неопределено Тогда
			ЗаписьОбИсследовании.Заключение = СтрокаТЧ.conclusion;
		КонецЕсли;
		Если СтрокаТЧ.notes <> Неопределено Тогда
			ЗаписьОбИсследовании.ДополнительныеСведения = СтрокаТЧ.notes;
		КонецЕсли;
		
		ЗаписьОбИсследовании.РезультатИсследования = ИнтеграцияВЕТИСПовтИсп.РезультатЛабораторныхИсследований(СтрокаТЧ.result);
		ЗаписьОбИсследовании.Идентификатор         = СтрокаТЧ.ID;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияРезультатОбработкиЗаявки(Изменения, ДополнительныеПараметры) Экспорт
	
	ПоказатьРезультатЗагрузки = Ложь;
	
	КоличествоОшибок   = 0;
	КоличествоОбъектов = 0;
	ТекстОшибки        = "";
	Для Каждого ЭлементДанных Из Изменения Цикл
		Если ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ЗапросВСД") Тогда
			
			ВходящееСообщение       = ЭлементДанных.ВходящееСообщение;
			ТекстОшибки             = ЭлементДанных.ТекстОшибки;
			
			Если ЗначениеЗаполнено(ЭлементДанных.Объект) Тогда
				КоличествоОбъектов = КоличествоОбъектов + 1;
			КонецЕсли;
			Если ЗначениеЗаполнено(ЭлементДанных.ТекстОшибки) Тогда
				КоличествоОшибок = КоличествоОшибок + 1;
			КонецЕсли;
			
		ИначеЕсли ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросВСД") Тогда
			
			ВходящееСообщение       = ЭлементДанных.ВходящееСообщение;
			ТекстОшибки             = ЭлементДанных.ТекстОшибки;
			
			Если ЗначениеЗаполнено(ЭлементДанных.Объект) Тогда
				КоличествоОбъектов = КоличествоОбъектов + 1;
			КонецЕсли;
			Если ЗначениеЗаполнено(ЭлементДанных.ТекстОшибки) Тогда
				КоличествоОшибок = КоличествоОшибок + 1;
			КонецЕсли;
			
			ПоказатьРезультатЗагрузки = Истина;
			
			ЛабораторныеИсследования.Очистить();
			Иммунизация.Очистить();
			
			Если ЭлементДанных.ДополнительныеДанные <> Неопределено Тогда
				ЗагрузитьВетеринарныеМероприятия(ЭлементДанных.ДополнительныеДанные);
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		
		ПоказатьОшибкуОбмена(ТекстОшибки);
		
	ИначеЕсли ПоказатьРезультатЗагрузки Тогда
		
		СтраницыФормы = Элементы.ГруппаСтраницы;
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросРезультат;
		
		ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеИнтерфейсом

&НаКлиенте
Процедура СформироватьТекстОжидание()
	
	Строки = Новый Массив();
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Запрос';
													|en = 'Запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящееСообщение"));
	Строки.Добавить(" ");
	
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ветеринарно-сопроводительного документа по идентификатору';
													|en = 'ветеринарно-сопроводительного документа по идентификатору'")));

	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'передан в ВетИС.';
													|en = 'передан в ВетИС.'")));
	
	Строки.Добавить(Символы.ПС);
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Получение ответа от сервера может занять продолжительное время.';
													|en = 'Получение ответа от сервера может занять продолжительное время.'")));
	
	ТекстОжидание = Новый ФорматированнаяСтрока(Строки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОшибкуОбмена(ТекстОшибки)
	
	Строки = Новый Массив();
	
	Если ЗначениеЗаполнено(ИсходящееСообщение) Тогда
		Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Запрос';
														|en = 'Запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящееСообщение"));
	Иначе 
		Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Запрос';
														|en = 'Запрос'")));
	КонецЕсли;
	
	Строки.Добавить(" ");
	
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ветеринарно-сопроводительного документа по идентификатору';
													|en = 'ветеринарно-сопроводительного документа по идентификатору'")));
	
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'завершился с';
													|en = 'завершился с'")));
	Строки.Добавить(" ");
	
	Если ЗначениеЗаполнено(ВходящееСообщение) Тогда
		Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ошибкой';
														|en = 'ошибкой'"),, ЦветГиперссылки,, "ОткрытьВходящееСообщение"));
	Иначе 
		Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ошибкой';
														|en = 'ошибкой'")));
	КонецЕсли;
	
	Строки.Добавить(":");
	Строки.Добавить(Символы.ПС);
	
	Строки.Добавить(Новый ФорматированнаяСтрока(ТекстОшибки,, ЦветПроблема));
	
	ТекстОшибка = Новый ФорматированнаяСтрока(Строки);
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросОшибка;
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИменаСтраниц()
	
	СтраницыФормы = Новый Массив();
	
	СтраницыФормы.Добавить("СтраницаИсходныеДанные");
	СтраницыФормы.Добавить("СтраницаЗапросОжидание");
	СтраницыФормы.Добавить("СтраницаЗапросОшибка");
	СтраницыФормы.Добавить("СтраницаЗапросРезультат");
	
	ИменаСтраниц = Новый ФиксированныйМассив(СтраницыФормы);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекущуюСтраницуНавигации(Форма)
	
	СтраницыФормы     = Форма.Элементы.ГруппаСтраницы;
	СтраницыНавигации = Форма.Элементы.Навигация;
	
	ИндексСтраницы    = Форма.ИменаСтраниц.Найти(СтраницыФормы.ТекущаяСтраница.Имя);
	КоличествоСтраниц = Форма.ИменаСтраниц.Количество();
	
	Если ИндексСтраницы = 0 Тогда
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияНачало;
		Форма.Элементы.НачалоДалее.КнопкаПоУмолчанию = Истина;
	ИначеЕсли ИндексСтраницы = (КоличествоСтраниц - 1) Тогда
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияОкончание;
		Форма.Элементы.ОкончаниеЗакрыть.КнопкаПоУмолчанию = Истина;
	ИначеЕсли СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросОшибка Тогда
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияОшибка;
		Форма.Элементы.ОшибкаНазад.КнопкаПоУмолчанию = Истина;
	Иначе
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияПродолжение;
		Если НЕ Форма.Элементы.ПродолжениеДалее.КнопкаПоУмолчанию Тогда
			Форма.Элементы.ПродолжениеДалее.КнопкаПоУмолчанию = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросОжидание Тогда
		СтраницыНавигации.Доступность = Ложь;
	Иначе
		СтраницыНавигации.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
