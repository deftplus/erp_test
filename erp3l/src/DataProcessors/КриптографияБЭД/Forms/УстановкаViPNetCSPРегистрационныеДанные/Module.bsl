#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьРегистрационныеДанные();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ЭлектроннаяПочта)
		И Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ЭлектроннаяПочта) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Некорректно заполнен адрес электронной почты.';
				|en = 'Email address is filled in incorrectly.'"),, "ЭлектроннаяПочта",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		ПараметрыРегистрации = КриптографияБЭДСлужебныйКлиент.НовыеПараметрыРегистрацииПрограммыКриптографии();
		ПараметрыРегистрации.КонтактноеЛицо = СокрЛП(КонтактноеЛицо);
		ПараметрыРегистрации.ЭлектроннаяПочта = СокрЛП(ЭлектроннаяПочта);
		ПараметрыРегистрации.СерийныйНомер = "";
		ПараметрыРегистрации.Продукт = "";
		ПараметрыРегистрации.ВыполнятьКонтрольЦелостности = ВыполнятьКонтрольЦелостности;
		ПараметрыРегистрации.ИмяПрограммы = НСтр("ru = 'VipNet CSP';
												|en = 'VipNet CSP'");
		
		Закрыть(ПараметрыРегистрации);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьРегистрационныеДанные()

	ТекущийПользователь = Пользователи.ТекущийПользователь();
	КонтактноеЛицо = ТекущийПользователь;
	КонтактнаяИнформация = ИнтеграцияБСПБЭД.КонтактнаяИнформацияОбъекта(ТекущийПользователь, "АдресЭлектроннойПочты");
	Если ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(КонтактнаяИнформация.Представление) Тогда
		ЭлектроннаяПочта = КонтактнаяИнформация.Представление;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

