
#Область СлужебныйПрограммныйИнтерфейс

#Область ДеревоСтатусов

Процедура ПостроитьДеревоСтатусов(ДеревоСтатусов) Экспорт
	
	СтрокаДерева = НоваяСтрокаДереваСтатусов(НСтр("ru = 'В работе';
													|en = 'In progress'"), ДеревоСтатусов, Перечисления.ГруппировкиСтатусовEDI.ВРаботе);
	
	Для Каждого ЭлементМассива Из ДокументыEDIКлиентСервер.МассивСтатусовВРаботе() Цикл
		
		НоваяСтрокаДереваСтатусов(ЭлементМассива, СтрокаДерева, Перечисления.ГруппировкиСтатусовEDI.ВРаботе);
		
	КонецЦикла;
	
	СтрокаДерева = НоваяСтрокаДереваСтатусов(НСтр("ru = 'Отклонения при выполнении';
													|en = 'Variance during execution'"), ДеревоСтатусов, Перечисления.ГруппировкиСтатусовEDI.ОтклоненияПриВыполнении);
	
	Для Каждого ЭлементМассива Из ДокументыEDIКлиентСервер.МассивСтатусовОтклоненияПриВыполнении() Цикл
		
		НоваяСтрокаДереваСтатусов(ЭлементМассива, СтрокаДерева, Перечисления.ГруппировкиСтатусовEDI.ОтклоненияПриВыполнении);
		
	КонецЦикла;
	
	СтрокаДерева = НоваяСтрокаДереваСтатусов(НСтр("ru = 'Архив';
													|en = 'Archive'"), ДеревоСтатусов, Перечисления.ГруппировкиСтатусовEDI.Архив);
	
	Для Каждого ЭлементМассива Из ДокументыEDIКлиентСервер.МассивСтатусовАрхив() Цикл
		
		НоваяСтрокаДереваСтатусов(ЭлементМассива, СтрокаДерева, Перечисления.ГруппировкиСтатусовEDI.Архив);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СохранитьНастройкиВыбранныхСтатусов(Настройки, ДеревоСтатусов) Экспорт
	
	ВыбранныеСтатусы = ДокументыEDIКлиентСервер.ВыбранныеВДеревеСтатусыДокументов(ДеревоСтатусов);
	
	Настройки.Удалить("ДеревоСтатусов");
	Настройки.Вставить("ВыбранныеСтатусы", ВыбранныеСтатусы);
	
КонецПроцедуры

Процедура УстановитьУсловноеОформлениеДеревоСтатусов(ЭтотОбъект, УсловноеОформление) Экспорт
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Выделение цветом даты выполнения если плановая дата выполнения в желтой зоне.';
								|en = 'Highlighting the execution date if the scheduled execution date is in the yellow zone.'");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ДеревоСтатусов");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоСтатусов.Группировка");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ГруппировкиСтатусовEDI.Архив;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

Процедура ЗаполнитьКоличествоВДеревеСтатусов(Форма) Экспорт
	
	ДеревоСтатусов = Форма.ДеревоСтатусов;
	
	Запрос = ДокументыEDIИнтеграция.ЗапросПоЗаполнениюКоличестваВДеревеСтатусов(Форма);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДанныеПоКоличествуДокументов = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
	
		ДанныеПоКоличествуДокументов.Вставить(Выборка.Статус, Выборка.КоличествоДокументов);
	
	КонецЦикла;
	
	Для Каждого РодительскаяСтрока Из ДеревоСтатусов.ПолучитьЭлементы() Цикл
		
		КоличествоДокументовРодитель = 0;
		
		Для Каждого ПодчиненнаяСтрока Из РодительскаяСтрока.ПолучитьЭлементы() Цикл
			
			ПодчиненнаяСтрока.КоличествоДокументов = ДанныеПоКоличествуДокументов.Получить(ПодчиненнаяСтрока.СтатусСсылка);
			
			КоличествоДокументовРодитель = КоличествоДокументовРодитель + ПодчиненнаяСтрока.КоличествоДокументов;
			
		КонецЦикла;
		
		РодительскаяСтрока.КоличествоДокументов = КоличествоДокументовРодитель;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ТаблицаОтбораДокументов

Процедура ЗаполнитьТаблицуОтбораДокументовПродажи(ТаблицаДокументов) Экспорт
	
	ЗаполнитьТаблицуОтбораДокументов(ТаблицаДокументов, Перечисления.КатегорииДокументовEDI.Продажа);
	
КонецПроцедуры

Процедура ЗаполнитьТаблицуОтбораДокументовЗакупки(ТаблицаДокументов) Экспорт
	
	ЗаполнитьТаблицуОтбораДокументов(ТаблицаДокументов, Перечисления.КатегорииДокументовEDI.Закупка);
	
КонецПроцедуры

Процедура УстановитьОтборПоДокументамСтатусам(Форма) Экспорт
	
	ИдентификаторыДокументов = ИдентификаторыВыбранныхТиповДокументов(Форма.ТипыДокументов);
	ВыбранныеСтатусы         = ДокументыEDIКлиентСервер.ВыбранныеВДеревеСтатусыДокументов(Форма.ДеревоСтатусов);
	
	МассивТиповДокументовИСтатусов = МассивХэшСуммИдентификаторовТиповДокументовИСтатусов(
		ИдентификаторыДокументов, 
		ВыбранныеСтатусы);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"ХэшТипаДокументаИСтатуса",
		МассивТиповДокументовИСтатусов,
		ВидСравненияКомпоновкиДанных.ВСписке,
		НСтр("ru = 'Отбор по статусам и документам';
			|en = 'Filter by statuses and documents'"),
		Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	ЗаполнитьКоличествоВДеревеСтатусов(Форма);
	
	Форма.УстановкаОтбораПоСтатусамТипамВыполнялась = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область МассивыИдентификаторовТиповДокументов

Функция МассивХэшСуммИдентификаторовТиповДокументовИСтатусов(ИдентификаторыТиповДокументов, Статусы)Экспорт
	
	Результат = Новый Массив;
	
	Для Каждого ИдентификаторТипаДокумента Из ИдентификаторыТиповДокументов Цикл
		
		Для Каждого СтатусДокумента Из Статусы Цикл
			
			Результат.Добавить(ДокументыEDIИнтеграция.ХэшТипаДокументаИСтатуса(ИдентификаторТипаДокумента, СтатусДокумента));
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция МассивИдентификаторовДокументовЗакупкиИПродажи() Экспорт
	
	МассивДокументов = МассивИдентификаторовДокументовЗакупки();
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивДокументов, МассивИдентификаторовДокументовПродажи());
	
	Возврат МассивДокументов;
	
КонецФункции

Функция МассивИдентификаторовДокументовЗакупки() Экспорт
	
	Возврат ДокументыEDIИнтеграция.МассивИдентификаторовДокументовЗакупки();
	
КонецФункции

Функция МассивИдентификаторовДокументовПродажи() Экспорт
	
	Возврат ДокументыEDIИнтеграция.МассивИдентификаторовДокументовПродажи();
	
КонецФункции

Функция ИдентификаторыВыбранныхТиповДокументов(ТаблицаИдентификаторовДокументов) Экспорт
	
	МассивИдентификаторовДокументов = Новый Массив;
	
	Для Каждого Строка Из ТаблицаИдентификаторовДокументов Цикл
		
		Если Строка.Выбран Тогда
			МассивИдентификаторовДокументов.Добавить(Строка.ИдентификаторыОбъектаМетаданных);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивИдентификаторовДокументов;
	
КонецФункции

#КонецОбласти

#Область РаботаСоСпискомДокументов

Процедура ОбновитьСписокДокументов(Форма) Экспорт
	
	Форма.Элементы.Список.Обновить();
	ЗаполнитьКоличествоВДеревеСтатусов(Форма);
	
КонецПроцедуры

Процедура УстановитьОтборыПриСозданииНаСервере(Форма) Экспорт
	
	УстановитьОтборПоПериоду(Форма);
	
	СтруктураБыстрогоОтбора = Неопределено;
	Форма.Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма.СтруктураБыстрогоОтбора = СтруктураБыстрогоОтбора;
	
	ДокументыEDIКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Форма.Список,
	                                                                       "Менеджер",
	                                                                       Форма.Менеджер,
	                                                                       СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора.Свойство("ВыбранныеСтатусы") Тогда
		ВыбранныеСтатусы = СтруктураБыстрогоОтбора.ВыбранныеСтатусы;
		ДокументыEDIКлиентСервер.УстановитьПометкиДеревоСтатусовСогласноВыбраннымСтатусам(Форма.ДеревоСтатусов, ВыбранныеСтатусы);
	КонецЕсли;
	
	Если СтруктураБыстрогоОтбора.Свойство("ОтборПоСтатусамОтображается") Тогда
		Форма.ОтборПоСтатусамОтображается = СтруктураБыстрогоОтбора.ОтборПоСтатусамОтображается;
	КонецЕсли;
	
	Если СтруктураБыстрогоОтбора.Свойство("ПлановаяДатаПериод") Тогда
		Форма.ПлановаяДатаПериод = СтруктураБыстрогоОтбора.ПлановаяДатаПериод;
	КонецЕсли;
	
	Если СтруктураБыстрогоОтбора.Свойство("ПлановаяДатаОтбор") Тогда
		Форма.ПлановаяДатаОтбор = Форма.Элементы.ПлановаяДата.СписокВыбора.НайтиПоЗначению(СтруктураБыстрогоОтбора.ПлановаяДатаОтбор).Представление;
	КонецЕсли;
	
	УстановитьОтборПоПлановойДате(Форма);
	УстановитьОтборПоДокументамСтатусам(Форма);
	
	ДокументыEDIИнтеграция.ПриУстановкеОтборовПриСозданииНаСервере(Форма);
	
КонецПроцедуры

Процедура УстановитьОтборПоПериоду(Форма) Экспорт
	
	Форма.Список.Параметры.УстановитьЗначениеПараметра("НачалоПериода",
		Форма.Период.ДатаНачала);
	Форма.Список.Параметры.УстановитьЗначениеПараметра("КонецПериода", 
		Форма.Период.ДатаОкончания);
	
КонецПроцедуры

Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Форма, Настройки) Экспорт
	
	ДокументыEDIКлиентСервер.ОтборПоЗначениюСпискаПередЗагрузкойИзНастроек(Форма.Список,
	                                                                           "Менеджер",
	                                                                           Форма.Менеджер,
	                                                                           Форма.СтруктураБыстрогоОтбора, 
	                                                                           Настройки);
	
	Если Не Форма.Параметры.Свойство("СтруктураБыстрогоОтбора")
		Или Форма.Параметры.СтруктураБыстрогоОтбора = Неопределено Тогда
		
		ВыбранныеСтатусы = Настройки.Получить("ВыбранныеСтатусы");
		Если ВыбранныеСтатусы <> Неопределено Тогда
			ДокументыEDIКлиентСервер.УстановитьПометкиДеревоСтатусовСогласноВыбраннымСтатусам(Форма.ДеревоСтатусов, ВыбранныеСтатусы);
		КонецЕсли;
		
		ЗначениеНастройки = Настройки.Получить("ОтборПоСтатусамОтображается");
		Если ЗначениеНастройки <> Неопределено Тогда
			Форма.ОтборПоСтатусамОтображается = ЗначениеНастройки;
			ДокументыEDIКлиентСервер.УправлениеОтображениемПанелиОтбораРеестрДокументов(Форма)
		КонецЕсли;
		
		УстановитьОтборПоДокументамСтатусам(Форма);
		
		ПлановаяДатаПериодНастройки = Настройки.Получить("ПлановаяДатаПериод");
		Если ПлановаяДатаПериодНастройки <> Неопределено Тогда
			Форма.ПлановаяДатаПериод = ПлановаяДатаПериодНастройки;
			УстановитьОтборПоПлановойДате(Форма);
		КонецЕсли;
		
		ПлановаяДатаОтборНастройки = Настройки.Получить("ПлановаяДатаОтбор");
		Если ПлановаяДатаОтборНастройки <> Неопределено Тогда
			Форма.ПлановаяДатаОтбор = ПлановаяДатаОтборНастройки;
		КонецЕсли;
		
	Иначе
		
		Если Настройки.Получить("ОтборПоСтатусамОтображается") <> Неопределено Тогда
			Настройки.Удалить("ОтборПоСтатусамОтображается");
		КонецЕсли;
		
		Если Настройки.Получить("ВыбранныеСтатусы") <> Неопределено Тогда
			Настройки.Удалить("ВыбранныеСтатусы");
		КонецЕсли;
		
		Если Настройки.Получить("ПлановаяДатаОтбор") <> Неопределено Тогда
			Настройки.Удалить("ПлановаяДатаОтбор");
		КонецЕсли;
		
		Если Настройки.Получить("ПлановаяДатаПериод") <> Неопределено Тогда
			Настройки.Удалить("ПлановаяДатаПериод");
		КонецЕсли;
		
	КонецЕсли;
	
	ДокументыEDIИнтеграция.ПередЗагрузкойДанныхИзНастроекНаСервереФормыСписка(Форма, Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ПлановаяДатаПоступления

Процедура ЗаполнитьСписокВыбораПлановаяДата(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	
	Элементы.ПлановаяДата.СписокВыбора.Добавить("Просрочено", НСтр("ru = 'Просрочено';
																	|en = 'Overdue'"));
	Элементы.ПлановаяДата.СписокВыбора.Добавить("Сегодня",    НСтр("ru = 'Сегодня';
																	|en = 'Today'"));
	Элементы.ПлановаяДата.СписокВыбора.Добавить("Завтра",     НСтр("ru = 'Завтра';
																	|en = 'Tomorrow'"));
	Элементы.ПлановаяДата.СписокВыбора.Добавить("ТриДня",     НСтр("ru = 'В ближайшие три дня';
																	|en = 'In the nearest three days'"));
	Элементы.ПлановаяДата.СписокВыбора.Добавить("Неделя",     НСтр("ru = 'В ближайшую неделю';
																	|en = 'In the nearest week'"));
	Элементы.ПлановаяДата.СписокВыбора.Добавить("ПроизвольныйПериод", НСтр("ru = 'Выбрать период....';
																			|en = 'Select period...'"));
	
КонецПроцедуры

Процедура УстановитьОтборПоПлановойДате(Форма) Экспорт

	Список = Форма.Список;
	ПлановаяДатаПериод = Форма.ПлановаяДатаПериод;
	
	ГруппаОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы,
	                                                                        НСтр("ru = 'Отбор по дате поступления';
																				|en = 'Filter by inpayment date'"),
	                                                                        ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	
	Если ПлановаяДатаПериод.ДатаНачала <> Дата(1, 1, 1) Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаОтбора,
			"ДатаВыполнения",
			ВидСравненияКомпоновкиДанных.БольшеИлиРавно,
			ПлановаяДатаПериод.ДатаНачала,
			,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	КонецЕсли;

	Если ПлановаяДатаПериод.ДатаОкончания <> Дата(1, 1, 1) Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаОтбора,
			"ДатаВыполнения",
			ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
			ПлановаяДатаПериод.ДатаОкончания,
			,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ПредставлениеСостояния

// Конструктор данных, необходимых для формирования представления состояния EDI
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * СостояниеПрикладногоОбъекта - ПеречислениеСсылка.СостоянияСоответствияПрикладногоОбъектаДокументуEDI -
// * ТипДокумента - ПеречислениеСсылка.СтатусыЗаказаEDI -
// * ДатаУточнениеСостоянияПоДаннымСтороныУчастника - Дата -
// * УточнениеСостоянияПоДаннымСтороныУчастника - Строка -
// * ДатаТекущегоСтатуса - Дата -
// * СторонаВыполнившаяДействие - ПеречислениеСсылка.СтороныУчастникиСервисаEDI -
// * ПоследнееДействие - ПеречислениеСсылка.ДействияПроцессаЗаказаEDI -
// * ПредыдущийСтатус - ПеречислениеСсылка.СтатусыЗаказаEDI -
// * ТекущийСтатус - ПеречислениеСсылка.СтатусыЗаказаEDI -
//
Функция ДанныеДокументаДляФормированияСостояния() Экспорт
	
	ДанныеДокумента = Новый Структура;
	ДанныеДокумента.Вставить("ТекущийСтатус",                                  Неопределено);
	ДанныеДокумента.Вставить("ПредыдущийСтатус",                               Неопределено);
	ДанныеДокумента.Вставить("ПоследнееДействие",                              Неопределено);
	ДанныеДокумента.Вставить("СторонаВыполнившаяДействие",                     ПредопределенноеЗначение("Перечисление.СтороныУчастникиСервисаEDI.ПустаяСсылка"));
	ДанныеДокумента.Вставить("ДатаТекущегоСтатуса",                            Дата(1, 1, 1));
	ДанныеДокумента.Вставить("УточнениеСостоянияПоДаннымСтороныУчастника",     "");
	ДанныеДокумента.Вставить("ДатаУточнениеСостоянияПоДаннымСтороныУчастника", Дата(1, 1, 1));
	ДанныеДокумента.Вставить("ТипДокумента",                                   Неопределено);
	ДанныеДокумента.Вставить("СостояниеПрикладногоОбъекта",                    Неопределено);
	
	Возврат ДанныеДокумента;
	
КонецФункции

Функция ПредставлениеСостоянияДокумента(ДанныеДокумента) Экспорт
	
	СтрокаСтатус   = "";
	СтрокаДействие = "";
	СтрокаДатаДействия     = "";
	
	СтрокаСтатус       = Строка(ДанныеДокумента.ТекущийСтатус);
	СтрокаДействие     = ПредставлениеДействия(ДанныеДокумента);
	СтрокаДатаДействия = ПредставлениеДатыДействия(ДанныеДокумента);
	
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(СтрокаСтатус);
	МассивСтрок.Добавить(", ");
	МассивСтрок.Добавить(СтрокаДействие);
	МассивСтрок.Добавить(" ");
	МассивСтрок.Добавить(СтрокаДатаДействия);
	
	Возврат СтрСоединить(МассивСтрок);
	
КонецФункции

Функция ПредставлениеДатыДействия(ДанныеДокумента) Экспорт
	
	Если ДанныеДокумента.ДатаУточнениеСостоянияПоДаннымСтороныУчастника > ДанныеДокумента.ДатаТекущегоСтатуса Тогда
		ДатаСобытия = ДанныеДокумента.ДатаУточнениеСостоянияПоДаннымСтороныУчастника;
	Иначе
		ДатаСобытия = ДанныеДокумента.ДатаТекущегоСтатуса;
	КонецЕсли;
	
	Возврат Формат(ДатаСобытия, "ДЛФ=D");
	
КонецФункции

Функция ПредставлениеДействия(ДанныеДокумента) Экспорт
	
	Если ЗначениеЗаполнено(ДанныеДокумента.ДатаУточнениеСостоянияПоДаннымСтороныУчастника)
		И Не ПустаяСтрока(ДанныеДокумента.УточнениеСостоянияПоДаннымСтороныУчастника) Тогда
		
		Возврат НРег(ДанныеДокумента.УточнениеСостоянияПоДаннымСтороныУчастника);
	
	ИначеЕсли ДанныеДокумента.ПоследнееДействие = ПредопределенноеЗначение("Перечисление.ДействияПроцессаЗаказаEDI.Оформлен") Тогда
		
		Возврат ПредставлениеДействияОформлен(ДанныеДокумента);
	
	ИначеЕсли ДанныеДокумента.ПоследнееДействие = ПредопределенноеЗначение("Перечисление.ДействияПроцессаЗаказаEDI.НаправленНаСогласование") Тогда
		
		ПредставлениеДействияНаправленНаСогласование(ДанныеДокумента);
		
	ИначеЕсли ДанныеДокумента.ПоследнееДействие = ПредопределенноеЗначение("Перечисление.ДействияПроцессаЗаказаEDI.Согласовано") Тогда
		
		ПредставлениеДействияСогласовано(ДанныеДокумента);
		
	ИначеЕсли ДанныеДокумента.ПоследнееДействие = ПредопределенноеЗначение("Перечисление.ДействияПроцессаЗаказаEDI.Отменен") Тогда
		
		Возврат ПредставлениеДействияОтмена(ДанныеДокумента);
		
	ИначеЕсли ДанныеДокумента.ПоследнееДействие = ПредопределенноеЗначение("Перечисление.ДействияПроцессаЗаказаEDI.ЗапрошеноИзменение") Тогда
		
		Возврат ПредставлениеДействияЗапрошеноИзменение(ДанныеДокумента);
		
	ИначеЕсли ДанныеДокумента.ПоследнееДействие = ПредопределенноеЗначение("Перечисление.ДействияПроцессаЗаказаEDI.СогласованоИзменение") Тогда
		
		Возврат ПредставлениеДействияСогласованоИзменение(ДанныеДокумента);
		
	ИначеЕсли ДанныеДокумента.ПоследнееДействие = ПредопределенноеЗначение("Перечисление.ДействияПроцессаЗаказаEDI.ОтмеченоВыполнение") Тогда
		
		Возврат ПредставлениеДействияОтмеченоВыполнение(ДанныеДокумента);
		
	ИначеЕсли ДанныеДокумента.ПоследнееДействие = ПредопределенноеЗначение("Перечисление.ДействияПроцессаЗаказаEDI.ВозвращенНаВыполнение") Тогда
		
		Возврат ПредставлениеДействияВозвращенНаВыполнение(ДанныеДокумента);
		
	ИначеЕсли ДанныеДокумента.ПоследнееДействие = ПредопределенноеЗначение("Перечисление.ДействияПроцессаЗаказаEDI.ОтклоненоВыполнение") Тогда
		
		Возврат ПредставлениеДействияОтклоненоВыполнение(ДанныеДокумента);
		
	ИначеЕсли ДанныеДокумента.ПоследнееДействие = ПредопределенноеЗначение("Перечисление.ДействияПроцессаЗаказаEDI.ЗапрошенаОтмена") Тогда
		
		Возврат ПредставлениеДействияЗапрошенаОтмена(ДанныеДокумента);
		
	ИначеЕсли ДанныеДокумента.ПоследнееДействие = ПредопределенноеЗначение("Перечисление.ДействияПроцессаЗаказаEDI.ПодтвержденаОтмена") Тогда
		
		Возврат ПредставлениеДействияПодтвержденаОтмена(ДанныеДокумента);
		
	Иначе
		
		Возврат НРег(Строка(ДанныеДокумента.ПоследнееДействие));
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ДеревоСтатусов

Функция НоваяСтрокаДереваСтатусов(Статус, СтрокаРодитель ,Группировка)
	
	НоваяСтрока  = СтрокаРодитель.ПолучитьЭлементы().Добавить();
	
	Если ТипЗнч(Статус) = Тип("Строка") Тогда
		ПредставлениеСтатуса = Статус;
	Иначе
		ПредставлениеСтатуса = Строка(Статус);
	КонецЕсли;
	
	НоваяСтрока.СтатусПредставление = ПредставлениеСтатуса;
	НоваяСтрока.СтатусСсылка        = Статус;
	НоваяСтрока.Группировка         = Группировка;
	Если Группировка <> Перечисления.ГруппировкиСтатусовEDI.Архив Тогда
		НоваяСтрока.Выбран = Истина;
	КонецЕсли;
	
	Возврат НоваяСтрока;
	
КонецФункции

#КонецОбласти

#Область ТаблицаОтбораДокументов

Процедура ЗаполнитьТаблицуОтбораДокументов(ТаблицаДокументов, КатегорияДокументов)
	
	ДокументыEDIИнтеграция.ЗаполнитьТаблицуОтбораДокументов(ТаблицаДокументов, КатегорияДокументов);
	
КонецПроцедуры

#КонецОбласти

#Область УсловноеОформлениеСпискаРеестрДокументов

Процедура УстановитьУсловноеОформлениеПлановаяДатаВыполнения(Форма, СписокУсловноеОформление) Экспорт
	
	// Выделение цветом плановой даты выполнения в желтой зоне
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Выделение цветом даты выполнения если плановая дата выполнения в желтой зоне.';
								|en = 'Highlighting the execution date if the scheduled execution date is in the yellow zone.'");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ДатаВыполнения");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДатаВыполнения");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Форма.ТекущаяДата;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТекущийСтатус");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеВСписке;
	ОтборЭлемента.ПравоеЗначение = ДокументыEDIКлиентСервер.МассивСтатусовНеСогласовано();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТекущийСтатус");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеВСписке;
	ОтборЭлемента.ПравоеЗначение = ДокументыEDIКлиентСервер.МассивСтатусовАрхив();
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Золотистый);
	
	// Выделение цветом плановой даты выполнения в красной зоне
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Выделение цветом даты выполнения если плановая дата выполнения в красной зоне.';
								|en = 'Highlighting the execution date if the scheduled execution date is in the red zone.'");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ДатаВыполнения");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДатаВыполнения");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = Форма.ТекущаяДата;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТекущийСтатус");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеВСписке;
	ОтборЭлемента.ПравоеЗначение = ДокументыEDIКлиентСервер.МассивСтатусовНеСогласовано();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТекущийСтатус");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеВСписке;
	ОтборЭлемента.ПравоеЗначение = ДокументыEDIКлиентСервер.МассивСтатусовАрхив();
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ТемноКрасный);
	
	// Выделение цветом плановой даты выполнения в зеленой зоне
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Выделение цветом даты выполнения если плановая дата выполнения в зеленой зоне.';
								|en = 'Highlighting the execution date if the scheduled execution date is in the green zone.'");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ДатаВыполнения");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДатаВыполнения");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = Форма.ТекущаяДата;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТекущийСтатус");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеВСписке;
	ОтборЭлемента.ПравоеЗначение = ДокументыEDIКлиентСервер.МассивСтатусовНеСогласовано();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТекущийСтатус");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеВСписке;
	ОтборЭлемента.ПравоеЗначение = ДокументыEDIКлиентСервер.МассивСтатусовАрхив();
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ТусклоОливковый);
	
	// Выделение цветом плановой даты если документ архивный
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Выделение цветом даты выполнения если плановая дата не имеет значения.';
								|en = 'Highlighting the execution date if the scheduled execution date does not matter.'");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ДатаВыполнения");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТекущийСтатус");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = ДокументыEDIКлиентСервер.МассивСтатусовАрхив();
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

Процедура УстановитьУсловноеОформлениеСостояние(Форма, СписокУсловноеОформление, ДобавлятьПостфиксEDI = Ложь) Экспорт

	ИмяЭлементаСостояние         = "Состояние";
	ИмяЭлементаТекущийСтатус     = "ТекущийСтатус";
	ИмяЭлементаПоследнееДействие = "ПоследнееДействие";
	
	Если ДобавлятьПостфиксEDI Тогда
		ИмяЭлементаСостояние         = "СостояниеEDI";
		ИмяЭлементаТекущийСтатус     = "ТекущийСтатусEDI";
		ИмяЭлементаПоследнееДействие = "ПоследнееДействиеEDI";
	КонецЕсли;
	
	// Выделение цветом выполненного документа
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Выделение цветом состояния если документ выполнен.';
								|en = 'Highlighting the status if the document is executed.'");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(ИмяЭлементаСостояние);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ИмяЭлементаСостояние);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыЗаказаEDI.Выполнен;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	// Выделение цветом отмененного документа
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Выделение цветом состояния если документ отменен.';
								|en = 'Highlighting the status if the document is canceled.'");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(ИмяЭлементаСостояние);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ИмяЭлементаТекущийСтатус);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыЗаказаEDI.Отменен;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,,,,Истина));
	
	ДействияОтклоненияПриВыполнении = Новый СписокЗначений;
	ДействияОтклоненияПриВыполнении.ЗагрузитьЗначения(ДокументыEDIКлиентСервер.ДействияОтклоненияПриВыполнении());
	
	// Выделение цветом документа с отклонениями в выполнении
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Выделение цветом документа с отклонениями в выполнении.';
								|en = 'Highlighting a document with performance deviations.'");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(ИмяЭлементаСостояние);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ИмяЭлементаПоследнееДействие);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = ДействияОтклоненияПриВыполнении;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ТемноКрасный);
	
КонецПроцедуры

#КонецОбласти

#Область СравнениеОбъектов

// Сравнивает значения переданных коллекций по указанным свойствам
// Параметры:
//  Коллекция1 - Строка, Структура, ТаблицаЗначений, Массив, Соответствие - первая сравниваемая коллекция.
//  Коллекция2 - Строка, Структура, ТаблицаЗначений, Массив, Соответствие - первая сравниваемая коллекция. 
//  Свойства - Строка - имена свойств, по которым нужно проводить сравнение, имена перечисляются через запятую.
//  
// Возвращаемое значение:
//  Булево - Истина, если структуры равны по значениям переданных свойств.
//
Функция КоллекцииРавны(Коллекция1, Коллекция2, Свойства = Неопределено) Экспорт
	
	ПоВсемСвойствам = Ложь;
	
	Если ТипЗнч(Свойства) = Тип("Строка") Тогда
		МассивСвойств = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Свойства);
	ИначеЕсли Свойства <> Неопределено Тогда 
		МассивСвойств = Свойства;
	Иначе
		ПоВсемСвойствам = Истина;
	КонецЕсли;
	
	Если ПоВсемСвойствам Тогда
		
		Для Каждого КлючЗначение Из Коллекция1 Цикл
			Если ТипЗнч(КлючЗначение.Значение) = Тип("ТаблицаЗначений") Тогда
				Продолжить;
			КонецЕсли;
			Если ТипЗнч(КлючЗначение.Значение) = Тип("Массив")
				И Не МассивыРавны(КлючЗначение.Значение, Коллекция2[КлючЗначение.Ключ]) Тогда
				Возврат Ложь;
			ИначеЕсли (ТипЗнч(КлючЗначение.Значение) = Тип("Структура")
					ИЛИ ТипЗнч(КлючЗначение.Значение) = Тип("Соответствие"))
				И Не КоллекцииРавны(КлючЗначение.Значение, Коллекция2[КлючЗначение.Ключ]) Тогда
				Возврат Ложь;
			ИначеЕсли Не (ТипЗнч(КлючЗначение.Значение) = Тип("Массив")
					ИЛИ ТипЗнч(КлючЗначение.Значение) = Тип("Структура")
					ИЛИ ТипЗнч(КлючЗначение.Значение) = Тип("Соответствие"))
					И Не КлючЗначение.Значение = Коллекция2[КлючЗначение.Ключ] Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		Для Каждого СтрМас Из МассивСвойств Цикл
			Если ТипЗнч(Коллекция1[СтрМас]) = Тип("ТаблицаЗначений") Тогда
				Продолжить;
			КонецЕсли;
			Если ТипЗнч(Коллекция1[СтрМас]) = Тип("Массив")
				И Не МассивыРавны(Коллекция1[СтрМас], Коллекция2[СтрМас]) Тогда
				Возврат Ложь;
			ИначеЕсли (ТипЗнч(Коллекция1[СтрМас]) = Тип("Структура")
					ИЛИ ТипЗнч(Коллекция1[СтрМас]) = Тип("Соответствие"))
				И Не КоллекцииРавны(Коллекция1[СтрМас], Коллекция2[СтрМас]) Тогда
				Возврат Ложь;
			ИначеЕсли Не (ТипЗнч(Коллекция1[СтрМас]) = Тип("Массив")
					ИЛИ ТипЗнч(Коллекция1[СтрМас]) = Тип("Структура")
					ИЛИ ТипЗнч(Коллекция1[СтрМас]) = Тип("Соответствие"))
					И Не Коллекция1[СтрМас] = Коллекция2[СтрМас] Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция МассивыРавны(Массив1, Массив2, ПорядокИмеетЗначения = Истина)
	
	Если Не Массив1.Количество() = Массив2.Количество() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ПорядокИмеетЗначения Тогда
		
		Для Индекс = 0 По Массив1.Количество() - 1 Цикл
			Если Не Массив1[Индекс] = Массив2[Индекс] Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		
		Для Каждого ТекущийЭлемент Из Массив1 Цикл
			Если Массив2.Найти(ТекущийЭлемент) = Неопределено Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область ПредставлениеСостояния

Функция ПредставлениеДействияПодтвержденаОтмена(ДанныеДокумента)
	
	Если ДанныеДокумента.СторонаВыполнившаяДействие = ПредопределенноеЗначение("Перечисление.СтороныУчастникиСервисаEDI.Покупатель") Тогда
		
		Возврат НСтр("ru = 'отмена подтверждена покупателем';
					|en = 'cancelation confirmed by customer'");
		
	Иначе
		
		Возврат НСтр("ru = 'отмена подтверждена продавцом';
					|en = 'cancelation confirmed by seller'");
		
	КонецЕсли;
	
КонецФункции

Функция ПредставлениеДействияОтмена(ДанныеДокумента)
	
	Если ДанныеДокумента.СторонаВыполнившаяДействие = ПредопределенноеЗначение("Перечисление.СтороныУчастникиСервисаEDI.Покупатель") Тогда
		
		Возврат НСтр("ru = 'отменен покупателем';
					|en = 'canceled by customer'");
		
	Иначе
		
		Возврат НСтр("ru = 'отменен продавцом';
					|en = 'canceled by seller'");
		
	КонецЕсли;
	
КонецФункции

Функция ПредставлениеДействияНаправленНаСогласование(ДанныеДокумента)
	
	Если ДанныеДокумента.СторонаВыполнившаяДействие = ПредопределенноеЗначение("Перечисление.СтороныУчастникиСервисаEDI.Покупатель") Тогда
		
		Если ДанныеДокумента.ПредыдущийСтатус = ПредопределенноеЗначение("Перечисление.СтатусыЗаказаEDI.ИзмененияПодтверждаютсяПокупателем") Тогда
			
			Возврат НСтр("ru = 'возвращен с выполнения на согласование покупателем';
						|en = 'returned from execution for approval by customer'");
			
		Иначе
			
			Возврат НСтр("ru = 'направлен на согласование покупателем';
						|en = 'sent for approval by customer'");
			
		КонецЕсли;
		
	Иначе
		
		Если ДанныеДокумента.ПредыдущийСтатус = ПредопределенноеЗначение("Перечисление.СтатусыЗаказаEDI.ИзмененияПодтверждаютсяПоставщиком") Тогда
			
			Возврат НСтр("ru = 'возвращен с выполнения на согласование продавцом';
						|en = 'returned from execution for approval by seller'");
			
		Иначе
			
			Возврат НСтр("ru = 'направлен на согласование продавцом';
						|en = 'sent for approval by customer'");
			
		КонецЕсли;
		
		
	КонецЕсли;
	
КонецФункции

Функция ПредставлениеДействияОформлен(ДанныеДокумента)
	
	Возврат НСтр("ru = 'оформлен покупателем';
				|en = 'registered by customer'");
	
КонецФункции

Функция ПредставлениеДействияСогласовано(ДанныеДокумента)
	
	Если ДанныеДокумента.СторонаВыполнившаяДействие = ПредопределенноеЗначение("Перечисление.СтороныУчастникиСервисаEDI.Покупатель") Тогда
		
		Возврат НСтр("ru = 'согласовано покупателем';
					|en = 'approved by customer'");
		
	Иначе
		
		Возврат НСтр("ru = 'согласовано продавцом';
					|en = 'approved by seller'");
		
	КонецЕсли;
	
КонецФункции

Функция ПредставлениеДействияЗапрошеноИзменение(ДанныеДокумента)
	
	Если ДанныеДокумента.СторонаВыполнившаяДействие = ПредопределенноеЗначение("Перечисление.СтороныУчастникиСервисаEDI.Покупатель") Тогда
		
		Возврат НСтр("ru = 'запрошено изменение покупателем';
					|en = 'change requested by customer'");
		
	Иначе
		
		Возврат НСтр("ru = 'запрошено изменение продавцом';
					|en = 'change requested by seller'");
		
	КонецЕсли;
	
КонецФункции

Функция ПредставлениеДействияСогласованоИзменение(ДанныеДокумента)

	Если ДанныеДокумента.СторонаВыполнившаяДействие = ПредопределенноеЗначение("Перечисление.СтороныУчастникиСервисаEDI.Покупатель") Тогда
		
		Возврат НСтр("ru = 'изменения согласованы покупателем';
					|en = 'changes approved by customer'");
		
	Иначе
		
		Возврат НСтр("ru = 'изменения согласованы продавцом';
					|en = 'changes approved by seller'");
		
	КонецЕсли;

КонецФункции

Функция ПредставлениеДействияОтмеченоВыполнение(ДанныеДокумента)
	
	Возврат НСтр("ru = 'отмечено выполнение поставщиком';
				|en = 'execution canceled by customer'");
	
КонецФункции

Функция ПредставлениеДействияОтклоненоВыполнение(ДанныеДокумента)
	
	Возврат НСтр("ru = 'выполнение подтверждено покупателем';
				|en = 'execution confirmed by customer'");
	
КонецФункции

Функция ПредставлениеДействияВозвращенНаВыполнение(ДанныеДокумента)
	
	Возврат НСтр("ru = 'покупатель не подтвердил выполнение';
				|en = 'customer did not confirm execution'");
	
КонецФункции 

Функция ПредставлениеДействияЗапрошенаОтмена(ДанныеДокумента)

	Если ДанныеДокумента.СторонаВыполнившаяДействие = ПредопределенноеЗначение("Перечисление.СтороныУчастникиСервисаEDI.Покупатель") Тогда
		
		Возврат НСтр("ru = 'запрошена отмена покупателем';
					|en = 'cancelation requested by customer'");
		
	Иначе
		
		Возврат НСтр("ru = 'запрошена отмена продавцом';
					|en = 'cancelation requested by seller'");
		
	КонецЕсли;

КонецФункции

#КонецОбласти

#Область Прочее

Функция МассивПустыхЗначенийПоОписаниюТипа(ОписаниеТипа) Экспорт
	
	МассивПустыхЗначений = Новый Массив;
	
	Для Каждого Тип Из ОписаниеТипа Цикл
		
		Если Не ОбщегоНазначения.ЭтоСсылка(Тип) Тогда
			Продолжить;
		КонецЕсли;
		
		МассивПустыхЗначений.Добавить(ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Метаданные.НайтиПоТипу(Тип).ПолноеИмя()).ПустаяСсылка());
		
	КонецЦикла;
	
	Если МассивПустыхЗначений.Количество() > 1 Тогда
		МассивПустыхЗначений.Добавить(Неопределено);
	КонецЕсли;
	
	Возврат МассивПустыхЗначений;
	
КонецФункции

#КонецОбласти

#КонецОбласти 