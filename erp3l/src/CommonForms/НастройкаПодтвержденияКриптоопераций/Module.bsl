#Область ОписаниеПеременных

&НаКлиенте
Перем ПрограммноеЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЦиклКриптооперации	= Истина;
	Сертификат 			= Параметры.Сертификат;
	СвойствоСертификата	= ЭлектроннаяПодписьВМоделиСервиса.СвойстваРасшифрованияПодписанияСертификата(Сертификат);
	
	Если Параметры.Свойство("СпособПодтвержденияКриптоопераций") Тогда
		СпособПодтвержденияКриптоопераций = Параметры.СпособПодтвержденияКриптоопераций;
	Иначе
		СпособПодтвержденияКриптоопераций = СвойствоСертификата.СпособПодтвержденияКриптоопераций;
	КонецЕсли;
	
	Если Параметры.Свойство("ЦиклКриптооперации") Тогда
		ЦиклКриптооперации = Параметры.ЦиклКриптооперации;
	КонецЕсли;
	
	ОтпечатокСертификата = ЭлектроннаяПодписьВМоделиСервиса.НайтиСертификатПоИдентификатору(Сертификат);
	
	Если Не ЗначениеЗаполнено(СпособПодтвержденияКриптоопераций) Тогда
		СпособПодтвержденияКриптоопераций = Перечисления.СпособыПодтвержденияКриптоопераций.СессионныйТокен;
	КонецЕсли;	
	
	НачальноеЗначениеСпособаПодтвержденияКриптооперации = СпособПодтвержденияКриптоопераций;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПрограммноеЗакрытие	= Ложь;
	Элементы.СпособПодтвержденияКриптоопераций.Подсказка = 
			ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ПолучитьОписаниеСпособовПодтвержденияКриптоопераций();
	ОбновитьОтображениеСертификата();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ПрограммноеЗакрытие <> Истина Тогда
		ПрограммноеЗакрытие = Истина;
		Отказ = Истина;
		
		ЗакрытьОткрытую(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособПодтвержденияКриптооперацийПриИзменении(Элемент)
	
	ШагАвторизации = 4;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьОткрытую(ПараметрыФормы)
	
	ПрограммноеЗакрытие = Истина;
	
	Если ПараметрыФормы = Неопределено Тогда
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("СпособПодтвержденияКриптоопераций", НачальноеЗначениеСпособаПодтвержденияКриптооперации);
		ПараметрыФормы.Вставить("Выполнено", Ложь);
		ПараметрыФормы.Вставить("Состояние", "ПродолжитьПолучениеМаркераБезопасности");
	КонецЕсли;
	
	Если Открыта() Тогда 
		Закрыть(ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подтвердить(Команда)
	
	Если СпособПодтвержденияКриптоопераций = ПредопределенноеЗначение("Перечисление.СпособыПодтвержденияКриптоопераций.ДолговременныйТокен") 
		и СпособПодтвержденияКриптоопераций <> НачальноеЗначениеСпособаПодтвержденияКриптооперации Тогда
		НовоеОповещение = ОписаниеОповещенияОЗакрытии;
		ОписаниеОповещенияОЗакрытии = Неопределено;
		ЗакрытьОткрытую(Неопределено);
		
		ЭлектроннаяПодписьВМоделиСервисаКлиент.ОтключитьПодтвержденияКриптоопераций(Сертификат, НовоеОповещение);
	Иначе	
		ОтразитьИзмененияСервер();
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СпособПодтвержденияКриптоопераций", СпособПодтвержденияКриптоопераций);
		ПараметрыФормы.Вставить("Выполнено", Истина);
		ПараметрыФормы.Вставить("Состояние", "ПродолжитьПолучениеМаркераБезопасности");
		
		ЗакрытьОткрытую(ПараметрыФормы);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолноеПредставлениеСертификата(ОтпечатокСертификата)
	
	Результат					= "ОтпечатокСертификата";
	ИщемСертификат				= Новый Структура("Отпечаток", ОтпечатокСертификата);
	ДанныеСертификата		    = ХранилищеСертификатов.НайтиСертификат(ИщемСертификат);
	СвойстваСертификата			= Новый Структура("ДатаНачала, ДатаОкончания, Наименование");
	
	Попытка
		ЗаполнитьЗначенияСвойств(СвойстваСертификата, ДанныеСертификата);
	
		СертификатДействителенС 	= СвойстваСертификата.ДатаНачала;
		СертификатДействителенПо 	= СвойстваСертификата.ДатаОкончания;
		
		Если ТипЗнч(СертификатДействителенС) = Тип("Строка") Тогда 
			СертификатДействителенС = СтрЗаменить(СертификатДействителенС, Символ(10), "");
		КонецЕсли;
			
		Если ТипЗнч(СертификатДействителенПо) = Тип("Строка") Тогда 
			СертификатДействителенПо = СтрЗаменить(СертификатДействителенПо, Символ(10), "");
		КонецЕсли;
		
		Результат = СокрЛП(ДанныеСертификата.Наименование) + " (" + СертификатДействителенС + " - " + СертификатДействителенПо + ")";
	Исключение
		
	КонецПопытки;	
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьОтображениеСертификата()
	
	ПредставлениеСертификата = ПолноеПредставлениеСертификата(ОтпечатокСертификата);

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСообщение(ТекстСообщения, Ожидать = Ложь, ЭтоОшибка = Ложь)
	
	Элементы.Пояснение.Заголовок = ТекстСообщения;
	Если ЭтоОшибка Тогда 
		Элементы.Пояснение.ЦветТекста = WebЦвета.Красный;
	Иначе
		Элементы.Пояснение.ЦветТекста = Новый Цвет;
	КонецЕсли;	
	
	Если Элементы.ИндикаторДлительнойОперации.Видимость <> Ожидать Тогда
		Элементы.ИндикаторДлительнойОперации.Видимость = Ожидать;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьНастройкиПолученияВременныхПаролейПослеВыполнения(Результат, ВходящийКонтекст) Экспорт
	
	Результат = СервисКриптографииСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(Результат);
	
	Если Результат.Выполнено Тогда
		НастройкиТелефона   = Результат.РезультатВыполнения;
		Получатель 			= НастройкиТелефона.Телефон;
		ПоказатьСообщение("", Ложь);
		УправлениеФормой(ЭтотОбъект);
		
	Иначе	
		ПоказатьСообщение(НСтр("ru = 'Сервис отправки SMS-сообщений временно недоступен. Повторите попытку позже.';
								|en = 'SMS service is temporarily unavailable. Try again later.'"), , Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	// показать текущий телефон
	Элементы.ИзменитьПолучателя.Заголовок = НСтр("ru = 'Изменить номер';
												|en = 'Change number'");
	Элементы.Подтвердить.Доступность = Форма.ШагАвторизации = 4;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПолучателя(Команда)
	
	Если ЦиклКриптооперации Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Состояние", "ИзменениеНастроекПолученияВременныхПаролей");
		ПараметрыФормы.Вставить("Сертификат", Сертификат);
		
		ЗакрытьОткрытую(ПараметрыФормы);
		
	Иначе
		ЗакрытьОткрытую(Неопределено);
		ЭлектроннаяПодписьВМоделиСервисаКлиент.ИзменитьНастройкиПолученияВременныхПаролей(Сертификат);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ОтразитьИзмененияСервер()
	
	ЭлектроннаяПодписьВМоделиСервиса.НастроитьИспользованиеДолговременногоТокена(СпособПодтвержденияКриптоопераций, Сертификат);
	
КонецПроцедуры	

#КонецОбласти