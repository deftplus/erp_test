
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УсловияХраненияТоваров = Параметры.УсловияХраненияТоваров;
	ОсобыеОтметки = Параметры.ОсобыеОтметки;
	СкладОтветственногоХранения = Параметры.СкладОтветственногоХранения;
	ВидПоклажедержателя = Параметры.ВидПоклажедержателя;
	Поклажедержатель = Параметры.Поклажедержатель;
	СрокОтветственногоХранения = Параметры.СрокОтветственногоХранения;
	ОтветственноеХранениеДоВостребования = Параметры.ОтветственноеХранениеДоВостребования;
	
	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	УстановитьВидимостьДоступностьЭлементовОтветственногоХранения(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если СохранитьПараметры
		И Не ЗавершениеРаботы Тогда
	
		СтруктураПараметров = Новый Структура();
		СтруктураПараметров.Вставить("УсловияХраненияТоваров", УсловияХраненияТоваров);
		СтруктураПараметров.Вставить("ОсобыеОтметки", ОсобыеОтметки);
		СтруктураПараметров.Вставить("СкладОтветственногоХранения", СкладОтветственногоХранения);
		СтруктураПараметров.Вставить("ВидПоклажедержателя", ВидПоклажедержателя);
		СтруктураПараметров.Вставить("Поклажедержатель", Поклажедержатель);
		СтруктураПараметров.Вставить("СрокОтветственногоХранения", СрокОтветственногоХранения);
		СтруктураПараметров.Вставить("ОтветственноеХранениеДоВостребования", ОтветственноеХранениеДоВостребования);
		ОповеститьОВыборе(СтруктураПараметров);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ЗакрытьФормуПринудительно
		И СохранитьПараметры
		И СкладОтветственногоХранения 
		И НЕ ЗначениеЗаполнено(Поклажедержатель)
		И Не ЗавершениеРаботы Тогда
		
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Поле ""Поклажедержатель"" не заполнено.';
																|en = '""Depository"" is required.'"),
			,
			"Поклажедержатель",
			Поклажедержатель,
			Отказ);
			
	КонецЕсли;
	
	Если Не ЗакрытьФормуПринудительно
		И (Модифицированность И Не СохранитьПараметры) Тогда
		
		Отказ = Истина;
		
		Если ЗавершениеРаботы Тогда
			ТекстПредупреждения = НСтр("ru = 'Настройка заполнения условий ответственного хранения будет прервана.';
										|en = 'Configuring population of custody conditions will be stopped.'");
			Возврат;
		КонецЕсли;
		
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.Добавить("Закрыть", НСтр("ru = 'Закрыть';
												|en = 'Close'"));
		СписокКнопок.Добавить("НеЗакрывать", НСтр("ru = 'Не закрывать';
													|en = 'Do not close'"));
		
		ДополнительныеПараметры = Новый Структура;
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПоказатьВопросПередЗакрытиемЗавершение", ЭтотОбъект, ДополнительныеПараметры),
			НСтр("ru = 'Реквизиты были изменены. Закрыть без сохранения реквизитов?';
				|en = 'Details have been changed. Close without saving details?'"),
			СписокКнопок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросПередЗакрытиемЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = "Закрыть" Тогда
		ЗакрытьФормуПринудительно = Истина;
		Закрыть(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДлительностьХраненияПриИзменении(Элемент)
	
	УстановитьВидимостьДоступностьЭлементовОтветственногоХранения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПоклажедержателяПриИзменении(Элемент)
	
	УстановитьВидимостьДоступностьЭлементовОтветственногоХранения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственноеХранениеПриИзменении(Элемент)
	
	УстановитьВидимостьДоступностьЭлементовОтветственногоХранения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПоклажедержателяОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ТолькоПросмотр Тогда
		СохранитьПараметры = Истина;
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьДоступностьЭлементовОтветственногоХранения(Форма)
	
	Если НЕ Форма.ИспользоватьНесколькоОрганизаций Тогда
		Форма.ВидПоклажедержателя = ПредопределенноеЗначение("Перечисление.ВидыПоклажедержателей.СтороннийКонтрагент");
	ИначеЕсли НЕ ЗначениеЗаполнено(Форма.ВидПоклажедержателя) Тогда
		Форма.ВидПоклажедержателя = ПредопределенноеЗначение("Перечисление.ВидыПоклажедержателей.СобственнаяОрганизация");
	КонецЕсли;
	
	ДоступностьЭлементов = Форма.СкладОтветственногоХранения;
	
	Форма.Элементы.ВидПоклажедержателя.Доступность = ДоступностьЭлементов И Форма.ИспользоватьНесколькоОрганизаций;
	Форма.Элементы.Поклажедержатель.Доступность = ДоступностьЭлементов И ЗначениеЗаполнено(Форма.ВидПоклажедержателя);
	Форма.Элементы.ОтветственноеХранениеДоВостребования.Доступность = ДоступностьЭлементов;
	Форма.Элементы.УсловияХраненияТоваров.Доступность = ДоступностьЭлементов;
	Форма.Элементы.ОсобыеОтметки.Доступность = ДоступностьЭлементов;
	
	Форма.Элементы.СрокОтветственногоХранения.Доступность = ДоступностьЭлементов И Не Форма.ОтветственноеХранениеДоВостребования;
	
	МассивТипов = Новый Массив();
	Если Форма.ВидПоклажедержателя = ПредопределенноеЗначение("Перечисление.ВидыПоклажедержателей.СтороннийКонтрагент") Тогда
		МассивТипов.Добавить(Тип("СправочникСсылка.Контрагенты"));
	ИначеЕсли Форма.ВидПоклажедержателя = ПредопределенноеЗначение("Перечисление.ВидыПоклажедержателей.СобственнаяОрганизация") Тогда
		МассивТипов.Добавить(Тип("СправочникСсылка.Организации"));
	КонецЕсли;
	
	ОписаниеТиповПоклажедержателя = Новый ОписаниеТипов(МассивТипов);
	Форма.Элементы.Поклажедержатель.ОграничениеТипа = ОписаниеТиповПоклажедержателя;
	Форма.Поклажедержатель = ОписаниеТиповПоклажедержателя.ПривестиЗначение(Форма.Поклажедержатель);
	
КонецПроцедуры

#КонецОбласти
