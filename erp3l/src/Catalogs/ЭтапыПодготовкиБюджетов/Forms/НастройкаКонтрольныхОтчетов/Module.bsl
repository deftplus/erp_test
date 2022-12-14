#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Адрес = Параметры.Адрес;
	ЭтапПодготовкиБюджетов = Параметры.ЭтапПодготовкиБюджетов;
	МодельБюджетирования = Параметры.МодельБюджетирования;
	
	ПараметрыОпций = Новый Структура("МодельБюджетирования", МодельБюджетирования);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыОпций);
	
	НастройкиКонтрольныхОтчетов.Загрузить(ПолучитьИзВременногоХранилища(Адрес));
	Для каждого Строка Из НастройкиКонтрольныхОтчетов Цикл
		ЗаполнитьДоступностьВыбораНастроекВСтроке(Строка.ПолучитьИдентификатор());
	КонецЦикла;
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НомерСтроки = 0;
	Для каждого Строка Из НастройкиКонтрольныхОтчетов Цикл
		НомерСтроки = НомерСтроки + 1;
		Если Не ЗначениеЗаполнено(Строка.ВидБюджета) Тогда
			ТекстСообщения = НСтр("ru = 'В строке %1 не указан Вид бюджета';
									|en = 'No budget profile is specified in line %1'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НомерСтроки), , , , Отказ); 
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Строка.Сценарий) И Строка.ДоступенВыборСценария Тогда
			ТекстСообщения = НСтр("ru = 'В строке %1 не указан Сценарий';
									|en = 'Scenario is not specified in line %1'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НомерСтроки), , , , Отказ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КонтрольныеОтчетыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока <> Неопределено Тогда
		
		ТекущаяСтрока = НастройкиКонтрольныхОтчетов.НайтиПоИдентификатору(ВыбраннаяСтрока);
		
		Если Поле.Имя = "КонтрольныеОтчетыПредставлениеОрганизации" Тогда
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ИзменениеОтбораПоОрганизациям", ЭтотОбъект);
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ТипЗначения", Новый ОписаниеТипов("СправочникСсылка.Организации"));
			ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Отбор по организациям';
														|en = 'Filter by companies'"));
			ПараметрыФормы.Вставить("Значения", ТекущаяСтрока.Организации.ВыгрузитьЗначения());
			ОткрытьФорму("ОбщаяФорма.РедактированиеСпискаЗначений", ПараметрыФормы, , , , , ОписаниеОповещения);
			                                                                          
		ИначеЕсли Поле.Имя = "КонтрольныеОтчетыПредставлениеПодразделения" Тогда
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ИзменениеОтбораПоПодразделениям", ЭтотОбъект);
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ТипЗначения", Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия"));
			ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Отбор по подразделениям';
														|en = 'Filter by business units'"));
			ПараметрыФормы.Вставить("Значения", ТекущаяСтрока.Подразделения.ВыгрузитьЗначения());
			ОткрытьФорму("ОбщаяФорма.РедактированиеСпискаЗначений", ПараметрыФормы, , , , , ОписаниеОповещения);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрольныеОтчетыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.ДанныеКУтверждению = Истина;
		Элемент.ТекущиеДанные.ДанныеВПодготовке = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрольныеОтчетыВидБюджетаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.КонтрольныеОтчеты.ТекущаяСтрока;
	ЗаполнитьДоступностьВыбораНастроекВСтроке(ТекущаяСтрока);
	
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
Процедура ЗаполнитьДоступностьВыбораНастроекВСтроке(ИдентификаторСтроки) 
	
	Строка = НастройкиКонтрольныхОтчетов.НайтиПоИдентификатору(ИдентификаторСтроки);
	ПараметрыДоступностиОтборов = Отчеты.БюджетныйОтчет.ПараметрыДоступностиОтборов(Строка.ВидБюджета);
	ЗаполнитьЗначенияСвойств(Строка, ПараметрыДоступностиОтборов);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КонтрольныеОтчетыПредставлениеОрганизации.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиКонтрольныхОтчетов.ПредставлениеОрганизации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Настроить';
																|en = 'Customize'"));
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КонтрольныеОтчетыПредставлениеПодразделения.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиКонтрольныхОтчетов.ПредставлениеПодразделения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Настроить';
																|en = 'Customize'"));
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КонтрольныеОтчетыСценарий.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиКонтрольныхОтчетов.ДоступенВыборСценария");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Установлен в виде бюджета>';
																|en = '<Set as a budget>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КонтрольныеОтчетыПредставлениеОрганизации.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиКонтрольныхОтчетов.ДоступенВыборОрганизации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Установлен в виде бюджета>';
																|en = '<Set as a budget>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КонтрольныеОтчетыПредставлениеПодразделения.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиКонтрольныхОтчетов.ДоступенВыборПодразделения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Установлен в виде бюджета>';
																|en = '<Set as a budget>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

&НаСервере
Функция СохранитьНастройкиНаСервере()
	
	Возврат ПоместитьВоВременноеХранилище(НастройкиКонтрольныхОтчетов.Выгрузить(), Адрес);
	
КонецФункции

&НаКлиенте
Процедура ИзменениеОтбораПоОрганизациям(Организации, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Организации) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Элементы.КонтрольныеОтчеты.ТекущиеДанные;
	ТекущаяСтрока.Организации.ЗагрузитьЗначения(Организации);
	Если ТекущаяСтрока.Организации.Количество() > 0 Тогда
		ТекущаяСтрока.ПредставлениеОрганизации = Строка(ТекущаяСтрока.Организации);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеОтбораПоПодразделениям(Подразделения, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Подразделения) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Элементы.КонтрольныеОтчеты.ТекущиеДанные;
	ТекущаяСтрока.Подразделения.ЗагрузитьЗначения(Подразделения);
	Если ТекущаяСтрока.Подразделения.Количество() > 0 Тогда
		ТекущаяСтрока.ПредставлениеПодразделения = Строка(ТекущаяСтрока.Подразделения);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти