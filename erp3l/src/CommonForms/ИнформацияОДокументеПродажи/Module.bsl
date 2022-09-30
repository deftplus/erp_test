#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РеквизитОплаченИспользуется = Параметры.Свойство("Оплачен");
	
	СписокСвойств = "ВидПервичногоДокумента, НаименованиеПервичногоДокумента,
		| НомерПервичногоДокумента, ДатаПервичногоДокумента, Организация, ПервичныйДокумент";
	Если РеквизитОплаченИспользуется Тогда
		СписокСвойств = СписокСвойств + ", Оплачен";
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, СписокСвойств);
	
	ТипыДокументПродажиИСМП.ЗагрузитьЗначения(Метаданные.ОпределяемыеТипы.ДокументПродажиИСМП.Тип.Типы());
	ТипыОснованиеОтгрузкаТоваровИСМП.ЗагрузитьЗначения(Метаданные.ОпределяемыеТипы.ОснованиеОтгрузкаТоваровИСМП.Тип.Типы());
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
	Элементы.Оплачен.Видимость = РеквизитОплаченИспользуется;
	Элементы.ВидПервичногоДокумента.СписокВыбора.ЗагрузитьЗначения(
		Параметры.ДоступныеВидыПервичныхДокументов.ВыгрузитьЗначения());
	
	СброситьРазмерыИПоложениеОкна();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Отказ = Ложь;
	ПроверитьЗаполнениеРеквизитов(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Оплачен",                          Оплачен);
	Результат.Вставить("ВидПервичногоДокумента",           ВидПервичногоДокумента);
	Результат.Вставить("НаименованиеПервичногоДокумента",  НаименованиеПервичногоДокумента);
	Результат.Вставить("НомерПервичногоДокумента",         НомерПервичногоДокумента);
	Результат.Вставить("ДатаПервичногоДокумента",          ДатаПервичногоДокумента);
	Результат.Вставить("ПредставлениеПервичногоДокумента", ИнтеграцияИСМПКлиентСервер.ПредставлениеПервичногоДокумента(Результат));
	Результат.Вставить("ПервичныйДокумент",                ПервичныйДокумент);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВидПервичногоДокументаПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "ВидПервичногоДокумента");
	
	Если ВидПервичногоДокумента <> ПредопределенноеЗначение("Перечисление.ВидыПервичныхДокументовИСМП.Прочее") Тогда
		НаименованиеПервичногоДокумента = "";
	КонецЕсли;
	
	ПервичныйДокумент = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПервичныйДокументПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ПервичныйДокумент) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеПервичногоДокумента = ДанныеПервичногоДокумента(ПервичныйДокумент);
	ДатаПервичногоДокумента   = ДанныеПервичногоДокумента.Дата;
	НомерПервичногоДокумента  = ДанныеПервичногоДокумента.Номер;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ДанныеПервичногоДокумента(ПервичныйДокумент)
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПервичныйДокумент, "Номер, Дата");
	
КонецФункции

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	
	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить("Документ.ВозвратВОборотИСМП.Форма.ЗаполнениеПервичногоДокумента", "", ИмяПользователя);
	КонецЕсли;
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполнениеРеквизитов(Отказ)
	
	ОчиститьСообщения();
	
	ШаблонСообщения = Нстр("ru = 'Поле ""%1"" не заполнено';
							|en = 'Поле ""%1"" не заполнено'");
	
	Если Не ЗначениеЗаполнено(ВидПервичногоДокумента) Тогда
		ТекстСообщения = СтрШаблон(ШаблонСообщения, "Вид первичного документа");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"ВидПервичногоДокумента",,Отказ);
	КонецЕсли;
	
	Если ВидПервичногоДокумента = ПредопределенноеЗначение("Перечисление.ВидыПервичныхДокументовИСМП.Прочее")
		И Не ЗначениеЗаполнено(НаименованиеПервичногоДокумента) Тогда
		ТекстСообщения = СтрШаблон(ШаблонСообщения, "Наименование первичного документа");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"НаименованиеПервичногоДокумента",,Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НомерПервичногоДокумента) Тогда
		ТекстСообщения = СтрШаблон(ШаблонСообщения, "Номер первичного документа");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"НомерПервичногоДокумента",,Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаПервичногоДокумента) Тогда
		ТекстСообщения = СтрШаблон(ШаблонСообщения, "Дата первичного документа");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"ДатаПервичногоДокумента",,Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")
	
	Элементы = Форма.Элементы;
	
	Инициализация = ПустаяСтрока(СписокРеквизитов);
	
	ЭтоКассовыйЧек = Форма.ВидПервичногоДокумента = ПредопределенноеЗначение("Перечисление.ВидыПервичныхДокументовИСМП.КассовыйЧек");
	ЭтоПрочее      = Форма.ВидПервичногоДокумента = ПредопределенноеЗначение("Перечисление.ВидыПервичныхДокументовИСМП.Прочее");
	ЭтоУПД         = Форма.ВидПервичногоДокумента = ПредопределенноеЗначение("Перечисление.ВидыПервичныхДокументовИСМП.УПД");
	ЭтоРеализация  = Не ЭтоКассовыйЧек И Не ЭтоПрочее;
	
	Если Инициализация Тогда
		
		СобытияФормИСМПКлиентСервер.УправлениеДоступностьюЭлементовФормы(Форма);
	
		СвязьПоОрганизации = Новый СвязьПараметраВыбора("Отбор.Организация", "Организация");
		СвязиПервичногоДокумента = Новый Массив();
		СвязиПервичногоДокумента.Добавить(СвязьПоОрганизации);
		Элементы.ПервичныйДокумент.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПервичногоДокумента);
		
	КонецЕсли;
	
	Если Не ЭтоПрочее Тогда
		
		ДоступныеТипыПервичногоДокумента = Новый Массив();
		
		Для Каждого ДоступныйТип Из Форма.ТипыДокументПродажиИСМП Цикл
			
			ЭтоОптовыйДокумент = Форма.ТипыОснованиеОтгрузкаТоваровИСМП.НайтиПоЗначению(ДоступныйТип.Значение) <> Неопределено;
			Если ЭтоРеализация И ЭтоОптовыйДокумент 
				Или ЭтоКассовыйЧек И Не ЭтоОптовыйДокумент Тогда
				ДоступныеТипыПервичногоДокумента.Добавить(ДоступныйТип.Значение);
			КонецЕсли;
			
		КонецЦикла;
		
		Если ДоступныеТипыПервичногоДокумента.Количество() > 0 Тогда
			Элементы.ПервичныйДокумент.ОграничениеТипа = Новый ОписаниеТипов(ДоступныеТипыПервичногоДокумента);
		КонецЕсли;
			
	КонецЕсли;
	
	Элементы.ПервичныйДокумент.Видимость       = Не ЭтоПрочее;
	Элементы.ПервичныйДокумент.Доступность     = Не ЭтоУПД;
	Элементы.НаименованиеПервичногоДокумента.Видимость = ЭтоПрочее;
	
КонецПроцедуры

#КонецОбласти