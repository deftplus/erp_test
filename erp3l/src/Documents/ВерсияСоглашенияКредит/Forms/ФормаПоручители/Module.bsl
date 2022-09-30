#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Поручители.Загрузить(Параметры.Поручители.Выгрузить());
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Сохранить(Команда)	
		
	МассивПоручителей = Новый Массив;
	ОбщегоНазначенияКлиентСерверУХ.ЗаполнитьМассивИзТаблицы(МассивПоручителей, Поручители, "Поручитель");
	Закрыть(МассивПоручителей);
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийПоручители
&НаКлиенте
Процедура ПоручителиПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если НЕ (НоваяСтрока И ОтменаРедактирования) Тогда

		ТекущиеДанные = Элементы.Поручители.ТекущиеДанные;
		Если ЗначениеЗаполнено(ТекущиеДанные.Поручитель) Тогда
			
			ТекущаяСтрока = Поручители.НайтиПоИдентификатору(Элементы.Поручители.ТекущаяСтрока);
			Для каждого Строка Из Поручители Цикл
				Если Строка.Поручитель = ТекущиеДанные.Поручитель И Строка <> ТекущаяСтрока Тогда
					ОбщегоНазначенияКлиент.СообщитьПользователю(
						Нстр("ru = 'Уже выбран данный поручитель'"),,
						СтрШаблон("Поручители[%1]", Поручители.Индекс(Строка)),,
						Отказ);
										
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоручителиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТекущиеДанные = Элементы.Поручители.ТекущиеДанные;
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.Поручитель) Тогда
		ТекущаяСтрока = Поручители.НайтиПоИдентификатору(Элементы.Поручители.ТекущаяСтрока);
		Поручители.Удалить(ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти