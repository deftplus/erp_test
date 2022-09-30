#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначения.ЗаполнитьКоллекциюЭлементовДереваДанныхФормы(
		ДеревоОбъектовУчета.ПолучитьЭлементы(),
		Перечисления.ОбъектыБухгалтерскогоУчета.ДеревоОбъектовУчета());
	
	Для каждого Группа Из ДеревоОбъектовУчета.ПолучитьЭлементы() Цикл
		Для каждого СтрокаОбъектУчета Из Группа.ПолучитьЭлементы() Цикл
			Если СтрокаОбъектУчета.ОбъектУчета = Параметры.ТекущаяСтрока Тогда
				Элементы.ДеревоОбъектовУчета.ТекущаяСтрока = СтрокаОбъектУчета.ПолучитьИдентификатор();
			КонецЕсли;
			МетаданныеРегистра = Метаданные.РегистрыНакопления.Найти(СтрокаОбъектУчета.ИсточникДанных);
			Если МетаданныеРегистра <> Неопределено Тогда
				СтрокаОбъектУчета.ИсточникДанныхПредставление = МетаданныеРегистра.Синоним;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыДеревоОбъектовУчета

&НаКлиенте
Процедура ДеревоОбъектовУчетаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = ДеревоОбъектовУчета.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ОповеститьОВыборе(ТекущиеДанные.ОбъектУчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовУчетаВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ТекущиеДанные = ДеревоОбъектовУчета.НайтиПоИдентификатору(Значение);
	Если ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ОповеститьОВыборе(ТекущиеДанные.ОбъектУчета);

КонецПроцедуры

#КонецОбласти
