
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.УчетнаяЗапись.РежимПароля = НЕ Пользователи.ЭтоПолноправныйПользователь();
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СозданиеНовогоПользователя = Истина;
		Объект.ЭтоГосударственныйВетеринарныйВрач = Истина;
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементоФормы

&НаКлиенте
Процедура ЭтоГосударственныйВетеринарныйВрачПриИзменении(Элемент)
	
	Если НЕ Объект.ЭтоГосударственныйВетеринарныйВрач И СозданиеНовогоПользователя Тогда
		ТекстВопроса = НСтр("ru = 'Ручное создание пользователей ВетИС предусмотрено для государственных ветеринарных врачей.
		                          |Остальных пользователей рекомендуется создавать и связывать с хозяйствующим субъектом.
		                          |Для этого воспользуйтесь командой ""Создать и связать"" в форме хозяйствующего субъекта
		                          |или в списке ""Права доступа пользователей ВетИС"".
		                          |Продолжить создание пользователя ВетИС?';
		                          |en = 'Ручное создание пользователей ВетИС предусмотрено для государственных ветеринарных врачей.
		                          |Остальных пользователей рекомендуется создавать и связывать с хозяйствующим субъектом.
		                          |Для этого воспользуйтесь командой ""Создать и связать"" в форме хозяйствующего субъекта
		                          |или в списке ""Права доступа пользователей ВетИС"".
		                          |Продолжить создание пользователя ВетИС?'");
		
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.Добавить(КодВозвратаДиалога.Да,     "Продолжить");
		СписокКнопок.Добавить(КодВозвратаДиалога.Отмена, "Отмена");
		
		ОповещениеПриОтвете = Новый ОписаниеОповещения("ЭтоГосВетВрачПриИзмененииПриОтветеНаВопрос", ЭтотОбъект);
		
		ПоказатьВопрос(ОповещениеПриОтвете, ТекстВопроса, СписокКнопок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтоГосВетВрачПриИзмененииПриОтветеНаВопрос(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос <> КодВозвратаДиалога.Да Тогда
		Объект.ЭтоГосударственныйВетеринарныйВрач = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
