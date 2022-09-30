//++ Устарело_Производство21
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		
		Возврат;
		
	КонецЕсли;

	ИгнорироватьОграниченияДоступностиМатериалов          = Параметры.ИгнорироватьОграниченияДоступностиМатериалов;
	ИгнорироватьОграниченияДоступностиВидовРабочихЦентров = Параметры.ИгнорироватьОграниченияДоступностиВидовРабочихЦентров;
	НаПустойЗавод                                         = Параметры.НаПустойЗавод;
	ЗадействоватьРезервДоступности                        = Параметры.ЗадействоватьРезервДоступности;
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ИгнорироватьОграниченияДоступностиВидовРабочихЦентровПриИзменении(Элемент)
	
	Если ИгнорироватьОграниченияДоступностиВидовРабочихЦентров
		И ЗадействоватьРезервДоступности Тогда
		
		ЗадействоватьРезервДоступности = Ложь;
		
	КонецЕсли;
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Рассчитать(Команда)
	
	ПараметрыРасчета = Новый Структура;
	ПараметрыРасчета.Вставить("ИгнорироватьОграниченияДоступностиМатериалов", ИгнорироватьОграниченияДоступностиМатериалов);
	ПараметрыРасчета.Вставить("ИгнорироватьОграниченияДоступностиВидовРабочихЦентров", ИгнорироватьОграниченияДоступностиВидовРабочихЦентров);
	ПараметрыРасчета.Вставить("НаПустойЗавод", НаПустойЗавод);
	ПараметрыРасчета.Вставить("ЗадействоватьРезервДоступности", ЗадействоватьРезервДоступности);
	
	ВыбранноеДействие = Новый Структура;
	ВыбранноеДействие.Вставить("Действие", "РассчитатьГрафикВыпускаПродукции");
	ВыбранноеДействие.Вставить("ПараметрыРасчета", ПараметрыРасчета);
	
	ОповеститьОВыборе(ВыбранноеДействие);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)
	
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("ЗадействоватьРезервДоступности");
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Форма.Элементы,
																		МассивЭлементов, 
																		"ТолькоПросмотр", 
																		Форма.ИгнорироватьОграниченияДоступностиВидовРабочихЦентров);
																		
КонецПроцедуры

#КонецОбласти
//-- Устарело_Производство21