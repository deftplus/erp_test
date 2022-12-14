#Область СобытияМодуляФормы

// нетиповое событие документа. Вызывается перед исполнением основного кода
Процедура ПриЧтенииСозданииНаСервере(Форма) Экспорт
	
	// 
	СоздатьРеквизитыФормыДокумента(Форма);
	СоздатьЭлементыФормыДокумента(Форма);
	
КонецПроцедуры

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) экспорт
	
КонецПроцедуры

Процедура ПриУстановкеВидимости(Форма) Экспорт
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции
	
Процедура СоздатьРеквизитыФормыДокумента(Форма)
	
	Если ФормыУХ.ЭлементыФормыУХУжеСозданы(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	//
	Реквизиты = Новый Массив;
	Реквизиты.Добавить(
		Новый РеквизитФормы(
			"РежимФормированияПотребностейПланомЗакупок",
			Новый ОписаниеТипов("ПеречислениеСсылка.РежимыФормированияПотребностейПланомЗакупок")
		)
	);
	Форма.ИзменитьРеквизиты(Реквизиты);
	
КонецПроцедуры

Процедура СоздатьЭлементыФормыДокумента(Форма) 
	
	//
	ВстраиваниеУХ.ЭлементыФормыУХДобавлены(Форма);
	
КонецПроцедуры

#КонецОбласти 

#КонецОбласти 

#Область СобытияМодуляОбъекта

#Область СлужебныеПроцедурыИФункции
	//
#КонецОбласти 

#КонецОбласти 

#Область МодульМенеджера
//
#Область СлужебныеПроцедурыИФункции
	//	
#КонецОбласти 

#КонецОбласти 

