#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Адрес				 	= Параметры.Адрес;
	МодельБюджетирования 	= Параметры.МодельБюджетирования;
	
	НастройкиДействия = ПолучитьИзВременногоХранилища(Адрес);
	Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ВосстановитьНастройкиДействия(НастройкиДействия, ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ВидОперации) Тогда
		ВидОперации = Перечисления.ВидыОперацийУстановкиЗначенийНефинансовыхПоказателей.ВводЗначенияПоказателя;
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийУстановкиЗначенийНефинансовыхПоказателей.ВводЗначенийПоШаблону Тогда
		Элементы.СтраницыНастройкиВыбора.ТекущаяСтраница = Элементы.СтраницаШаблон;
		Реквизиты = ПолучитьПоляШапки(ШаблонВвода);
	Иначе
		Элементы.СтраницыНастройкиВыбора.ТекущаяСтраница = Элементы.СтраницаНепосредственно;
		Реквизиты = ПолучитьПоляШапки(НефинансовыйПоказатель);
	КонецЕсли;
	
	Элементы.Сценарий.Видимость		 = Реквизиты.ПоСценариям;
	Элементы.Организация.Видимость	 = Реквизиты.ПоОрганизациям;
	Элементы.Подразделение.Видимость = Реквизиты.ПоПодразделениям;
	
	ВидОперацииВводЗначенийПоШаблону =
		Перечисления.ВидыОперацийУстановкиЗначенийНефинансовыхПоказателей.ВводЗначенийПоШаблону;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийРеквизитовФормы

&НаКлиенте
Процедура НастройкаВводаПриИзменении(Элемент)
	
	Если ВидОперации = ВидОперацииВводЗначенийПоШаблону Тогда
		Реквизиты = ПолучитьПоляШапки(ШаблонВвода);
		Элементы.СтраницыНастройкиВыбора.ТекущаяСтраница = Элементы.СтраницаШаблон;
	Иначе
		Реквизиты = ПолучитьПоляШапки(НефинансовыйПоказатель);
		Элементы.СтраницыНастройкиВыбора.ТекущаяСтраница = Элементы.СтраницаНепосредственно;
	КонецЕсли;
		
	Элементы.Организация.Видимость = Реквизиты.ПоОрганизациям;
	Элементы.Подразделение.Видимость = Реквизиты.ПоПодразделениям;
	Элементы.Сценарий.Видимость = Реквизиты.ПоСценариям;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(СохранитьНастройкиНаСервере());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьПоляШапки(Ссылка)
	
	Возврат Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ПолучитьПоляШапки(Ссылка);
	
КонецФункции

&НаСервере
Функция СохранитьНастройкиНаСервере()
	
	Настройки = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.НастройкиДействия(ЭтаФорма);
	Возврат ПоместитьВоВременноеХранилище(Настройки, Адрес);
	
КонецФункции

#КонецОбласти
