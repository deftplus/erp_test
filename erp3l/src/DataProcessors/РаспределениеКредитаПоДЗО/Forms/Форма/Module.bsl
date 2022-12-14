#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьСписокВыбораКонтрагентов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура КредитПриИзменении(Элемент)
	ПриИзмененииДоговораНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ПриИзмененииДоговораНаСервере()
	
	Объект.ВерсияКредит = РаботаСДоговорамиКонтрагентовУХ.ДействующаяВерсияСоглашения(Объект.Кредит);
	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ВерсияКредит, Новый Структура("СуммаКредита,ВалютаКредита","Сумма", "ВалютаВзаиморасчетов"));
	ЗаполнитьЗначенияСвойств(Объект, РеквизитыДоговора);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСписокВыбораКонтрагентов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = ДенежныеСредстваВстраиваниеУХ.ТекстЗапросаСписокВыбораКонтрагента();	
	РезультатЗапроса = Запрос.Выполнить();
	Элементы.ПолучателиЗаймовПолучатель.СписокВыбора.ЗагрузитьЗначения(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

&НаСервере
Процедура СформироватьЗаймыНаСервере()
	
	Если Объект.ПолучателиЗаймов.Итог("СуммаЗайма") > Объект.СуммаКредита Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Сумма к выдаче превышает сумму кредита.'"));
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекСтрока Из Объект.ПолучателиЗаймов Цикл
		
		Если Не ЗначениеЗаполнено(ТекСтрока.Получатель) ИЛИ НЕ ЗначениеЗаполнено(ТекСтрока.ДоговорЗайма) Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураЗаполнения = Новый Структура;
		СтруктураЗаполнения.Вставить("Дата", ТекущаяДата());
		СтруктураЗаполнения.Вставить("ДатаНачалаДействия", ТекСтрока.ДатаВыдачи);
		СтруктураЗаполнения.Вставить("ДатаОкончанияДействия", ТекСтрока.ДатаВозврата);
		СтруктураЗаполнения.Вставить("Сумма", ТекСтрока.СуммаЗайма);
		СтруктураЗаполнения.Вставить("ДоговорКонтрагента", ТекСтрока.ДоговорЗайма);
		
		ДокЗаем = Документы.ВерсияСоглашенияКредит.СоздатьДокумент();
		ДокЗаем.ДополнительныеСвойства.Вставить("НеОбновлятьФакт", Истина);
		ДокЗаем.Заполнить(СтруктураЗаполнения);
		ДокЗаем.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗаймы(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		СформироватьЗаймыНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
