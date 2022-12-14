

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") И ТипЗнч(Параметры.Отбор) = Тип("Структура") 
		И Параметры.Отбор.Свойство("ТипБД") Тогда 
		
		ТипВнешнейИБ = Параметры.Отбор.ТипБД;
			
	КонецЕсли;
	
	УстановитьОтборПоТипуВИБ(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТипВнешнейИБПриИзменении(Элемент)
	УстановитьОтборПоТипуВИБ(ЭтаФорма);	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортироватьДанные(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура("ИмпортДанных", Истина);
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ПараметрыОткрытияФормы.Вставить("ВнешняяИнформационнаяБаза", ТекущаяСтрока.Ссылка);
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ОбменНСИ.Форма", ПараметрыОткрытияФормы);	
	
КонецПроцедуры

#КонецОбласти


#Область ВспомогательныеПроцедурыФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоТипуВИБ(Форма)
	
	ИспользоватьОтбор = НЕ Форма.ТипВнешнейИБ.Пустая();
	ОбщегоНазначенияКлиентСерверУХ.УстановитьЭлементОтбора(Форма.Список.Отбор, "ТипБД", Форма.ТипВнешнейИБ,,,ИспользоватьОтбор);
		
КонецПроцедуры

#КонецОбласти


