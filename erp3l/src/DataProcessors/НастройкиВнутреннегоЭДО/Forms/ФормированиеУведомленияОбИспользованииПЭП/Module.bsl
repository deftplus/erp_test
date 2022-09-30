
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокПользователейПараметр = Неопределено;
	Параметры.Свойство("СписокПользователей", СписокПользователейПараметр); 
	Параметры.Свойство("Организация", Организация); 
	
	Если ЗначениеЗаполнено(СписокПользователейПараметр) Тогда
		СписокПользователей.ЗагрузитьЗначения(СписокПользователейПараметр);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СформироватьЛистОзнакомления(Команда)
		
	УведомленияОбИспользованииПЭП = ШаблонУведомленияОбИспользованииПЭП(Организация, 
		СписокПользователей.ВыгрузитьЗначения());
	
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("УведомленияОбИспользованииПЭП");
	ОписаниеПечатнойФормы = УправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, "УведомленияОбИспользованииПЭП"); 
	ОписаниеПечатнойФормы.ТабличныйДокумент = УведомленияОбИспользованииПЭП;

	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм);
	
	Закрыть();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ШаблонУведомленияОбИспользованииПЭП(Организация, СписокПользователей) Экспорт
	
	Возврат НастройкиВнутреннегоЭДОСлужебный.ШаблонУведомленияОбИспользованииПЭП(Организация, 
		СписокПользователей);
		
КонецФункции

#КонецОбласти
