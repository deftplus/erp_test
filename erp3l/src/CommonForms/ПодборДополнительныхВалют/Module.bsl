
&НаКлиенте
Процедура ДополнительныеВалютыПометкаПриИзменении(Элемент)
	
	ТекЗапись = ДополнительныеВалюты.НайтиПоИдентификатору(Элементы.ДополнительныеВалюты.ТекущаяСтрока);
	Если НЕ ТекЗапись.Пометка Тогда
		ТекЗапись.Пометка = Истина;
	Иначе
		Для Каждого ЭлементСписка Из ДополнительныеВалюты Цикл
			
			ЭлементСписка.Пометка = (ЭлементСписка.ПолучитьИдентификатор() = Элементы.ДополнительныеВалюты.ТекущаяСтрока);
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если ПроверитьЗаполненностьВалют() Тогда
		ОповеститьОВыборе(Новый ФиксированнаяСтруктура("Периметр, ВидОтчета, ДополнительныеВалюты, ДополнительныеВалютыДляВидаОтчета, ИдентификаторСтроки", Периметр, ВидОтчета, ДополнительныеВалюты, ДополнительныеВалютыДляВидаОтчета, ИдентификаторСтроки));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если ЗначениеЗаполнено(Параметры.ДополнительныеВалюты) Тогда
		
		Для Каждого ТекВалюта ИЗ Параметры.ДополнительныеВалюты Цикл
			
			ДополнительныеВалюты.Добавить(ТекВалюта.Значение,,ТекВалюта.Пометка,ТекВалюта.Картинка);
			
		КонецЦикла;
		
	КонецЕсли;
		
	Если Параметры.ОтображатьПанельВалютВидаОтчета Тогда
		ДополнительныеВалютыДляВидаОтчета = Параметры.ДополнительныеВалютыДляВидаОтчета;
		Элементы.ДополнительныеВалюты.ИзменятьСоставСтрок       = Ложь;
		Элементы.ДополнительныеВалюты.ИзменятьПорядокСтрок      = Ложь;
		Элементы.ДополнительныеВалюты.ТолькоПросмотр            = Истина;
		Элементы.ДополнительныеВалюты.КоманднаяПанель.Видимость = Ложь;
	Иначе
		Элементы.ГруппаВалютыДляКонкретногоВидаОтчета.Видимость = Ложь;
	КонецЕсли;
	
	Периметр             = Параметры.Периметр;
	ИдентификаторСтроки  = Параметры.ИдентификаторСтроки;
	ВидОтчета            = Параметры.ВидОтчета;
	
	ДополнительныеВалюты.СортироватьПоЗначению(НаправлениеСортировки.Возр);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеВалютыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ДополнительныеВалюты.Количество() = 1 Тогда
		
		ДополнительныеВалюты.ЗаполнитьПометки(Истина);
		
	КонецЕсли;
	
	Элемент.ТекущиеДанные.Представление=Элемент.ТекущиеДанные.Значение;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеВалютыПослеУдаления(Элемент)
	
	Если ДополнительныеВалюты.Количество() = 1 Тогда
		
		ДополнительныеВалюты.ЗаполнитьПометки(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполненностьВалют()
	
	Для Каждого Строка Из ДополнительныеВалюты Цикл
		
		Если НЕ ЗначениеЗаполнено(Строка.Значение) Тогда
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = "Пустое поле валюты!";
			СообщениеПользователю.Поле = "ДополнительныеВалюты[" +ДополнительныеВалюты.Индекс(Строка) +  "].ДополнительныеВалютыЗначение";
			СообщениеПользователю.Сообщить();
			Элементы.ДополнительныеВалюты.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

