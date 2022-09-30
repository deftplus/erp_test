
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтотОбъект);
	
	ЕстьПравоВывод = ПравоДоступа("Вывод", Метаданные);
	Элементы.ФормаЗагрузитьИзФайла.Видимость = ЕстьПравоВывод;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);
	ИначеЕсли ИмяСобытия = "Запись_РеестрСчетовФактурПоставщика" 
		И НЕ Параметр.РежимСверки Тогда
		Элементы.Список.ТекущаяСтрока = Источник;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
	
	ОткрытьФорму("Документ.РеестрСчетовФактурПоставщика.Форма.ЗагрузкаИзФайла", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СверитьДанные(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Не выбран реестр счетов-фактур поставщика для сверки.';
								|en = 'Supplier tax invoice registry is not selected for reconciliation.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Контрагент",      ТекущиеДанные.Контрагент);
	ПараметрыФормы.Вставить("Организация",     ТекущиеДанные.Организация);
	ПараметрыФормы.Вставить("НалоговыйПериод", ТекущиеДанные.НалоговыйПериод);
	ОткрытьФорму("Обработка.СверкаДанныхУчетаНДС.Форма", ПараметрыФормы, , Новый УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

