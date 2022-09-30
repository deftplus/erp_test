
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Контрагент = Параметры.Контрагент;
	ЭлектроннаяПочта = Параметры.ЭлектроннаяПочта;
	
	Если Не ЗначениеЗаполнено(ЭлектроннаяПочта) Тогда
		ЭлектроннаяПочта = "";
		ОбменСКонтрагентамиПереопределяемый.АдресЭлектроннойПочтыКонтрагента(Контрагент, ЭлектроннаяПочта);
	КонецЕсли;
	
	ЗарегистрированныеОрганизации = БизнесСеть.ЗарегистрированныеОрганизации();
	Элементы.Организация.СписокВыбора.ЗагрузитьЗначения(ЗарегистрированныеОрганизации);
	Если ЗарегистрированныеОрганизации.Количество() = 1 Тогда
		Организация = ЗарегистрированныеОрганизации[0];
	КонецЕсли;
	
	ИспользоватьНесколькоОрганизаций = ОбщегоНазначенияБЭД.ИспользуетсяНесколькоОрганизаций();
	Если НЕ ИспользоватьНесколькоОрганизаций Тогда
		Элементы.Отправитель.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьПриглашение(Команда)
	
	ОчиститьСообщения();
	ОтправитьПриглашенияЧерезБизнесСеть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПриглашенияЧерезБизнесСеть()
	
	Отказ = Ложь;
	БизнесСетьВызовСервера.ОтправитьПриглашениеКонтрагенту(Организация, Контрагент, ЭлектроннаяПочта, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТекстОповещения= НСтр("ru = 'Отправка приглашения';
							|en = 'Send invitation'");
	ТекстПояснения = НСтр("ru = 'Отправлено приглашение контрагенту %1';
							|en = 'Invitation was sent to counterparty %1'");
	ТекстПояснения = СтрШаблон(ТекстПояснения, Контрагент);
	ПоказатьОповещениеПользователя(ТекстОповещения, , ТекстПояснения, БиблиотекаКартинок.БизнесСеть);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

