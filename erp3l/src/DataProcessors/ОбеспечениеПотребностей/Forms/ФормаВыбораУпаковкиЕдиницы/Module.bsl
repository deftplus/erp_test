#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") Тогда
		
		Владелец          = Параметры.Отбор.Владелец;
		ВладелецДляОтбора = Неопределено;
		ОбщиеУпаковки     = Неопределено;
		
		Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
			
			Если Владелец.НаборУпаковок = Справочники.НаборыУпаковок.ИндивидуальныйДляНоменклатуры Тогда
				ВладелецДляОтбора = Владелец;
				ОбщиеУпаковки = Ложь;
			Иначе
				ВладелецДляОтбора = Владелец.НаборУпаковок;
				
				Если ЗначениеЗаполнено(ВладелецДляОтбора) Тогда
					ОбщиеУпаковки = Истина;
				Иначе
					ВладелецДляОтбора = Неопределено;
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Владелец) = Тип("СправочникСсылка.НаборыУпаковок") Тогда
			
			Если Владелец <> Справочники.НаборыУпаковок.ИндивидуальныйДляНоменклатуры Тогда
				ВладелецДляОтбора = Владелец;
				ОбщиеУпаковки = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ВладелецДляОтбора = Неопределено Тогда
			
			ТекстЗаголовка = НСтр("ru = 'Для элемента: ""%Владелец%"" использование упаковок не определено';
									|en = 'Packaging units are disabled for the item: %Владелец%'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Владелец%", Строка(Владелец));
			
			АвтоЗаголовок = Ложь;
			Заголовок     = ТекстЗаголовка;
			
			Элементы.Список.ТолькоПросмотр = Истина;
			ЗапретВыбора = Истина;
			
		Иначе
			
			ТекстЗаголовка = НСтр("ru = 'Упаковки (%Владелец%)';
									|en = 'Packaging units (%Владелец%)'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Владелец%", Строка(ВладелецДляОтбора));
			
			АвтоЗаголовок = Ложь;
			Заголовок     = ТекстЗаголовка;
			
		КонецЕсли;
		
		Если ОбщиеУпаковки = Истина Тогда
			Элементы.ДекорацияПредупреждение.Видимость = Истина;
			Элементы.ДекорацияПредупреждение.Заголовок = Элементы.ДекорацияПредупреждение.Заголовок + " """ + Строка(ВладелецДляОтбора) + """";
		Иначе
			Элементы.ДекорацияПредупреждение.Видимость = Ложь;
		КонецЕсли;
		
		Параметры.Отбор.Владелец = ВладелецДляОтбора;
		
		Список.Параметры.УстановитьЗначениеПараметра("ЕдиницыИзмерения", Параметры.ЕдиницыИзмерения);
		
	КонецЕсли;
	
	Если ЗапретВыбора Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовСписка

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборЗначения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыборЗначения();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыборЗначения()
	
	Если ЗапретВыбора Тогда
		ОповеститьОВыборе(Неопределено);
	Иначе
		ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
		ОповеститьОВыборе(ТекущаяСтрока.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти