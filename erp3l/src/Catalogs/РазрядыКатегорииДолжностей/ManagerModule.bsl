
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	КадровыйУчетРасширенныйВызовСервера.ОбработкаПолученияДанныхВыбораСправочникаРазрядыКатегорииДолжностей(ДанныеВыбора, Параметры, СтандартнаяОбработка);		
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

Процедура НачальноеЗаполнение() Экспорт
	
	КлассификаторТаблица = Новый ТаблицаЗначений;
	КлассификаторТаблица.Колонки.Добавить("Наименование");
	
	ЭтоРаботаВХозрасчетнойОрганизации = ЗарплатаКадрыРасширенный.ЗначениеРаботаВХозрасчетнойОрганизации();
	
	Если ЭтоРаботаВХозрасчетнойОрганизации=Неопределено Или Не ЭтоРаботаВХозрасчетнойОрганизации Тогда
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = '1 квалификационный уровень';
														|en = '1 qualification level'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = '2 квалификационный уровень';
														|en = '2 qualification level'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = '3 квалификационный уровень';
														|en = '3 qualification level'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = '4 квалификационный уровень';
														|en = '4 qualification level'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = '5 квалификационный уровень';
														|en = '5 qualification level'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = '6 квалификационный уровень';
														|en = '6 qualification level'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = '7 квалификационный уровень';
														|en = '7 qualification level'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Первая квалификационная категория';
														|en = 'The first qualification category'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Вторая квалификационная категория';
														|en = 'The second qualification category'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Высшая квалификационная категория';
														|en = 'Highest qualification category'");
		
	КонецЕсли;
	
	Если ЭтоРаботаВХозрасчетнойОрганизации=Неопределено Или ЭтоРаботаВХозрасчетнойОрганизации Тогда
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = '1 разряд (категория)';
														|en = '1 category'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = '2 разряд (категория)';
														|en = '2 category'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = '3 разряд (категория)';
														|en = '3 category'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = '4 разряд (категория)';
														|en = '4 category'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = '5 разряд (категория)';
														|en = '5 category'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = '6 разряд (категория)';
														|en = '6 category'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = '7 разряд (категория)';
														|en = '7 category'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru = '8 разряд (категория)';
														|en = '8 category'");
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РазрядыКатегорииДолжностей.Наименование
	|ИЗ
	|	Справочник.РазрядыКатегорииДолжностей КАК РазрядыКатегорииДолжностей";
	
	ТаблицаСуществующих = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаКлассификатора Из КлассификаторТаблица Цикл
		Если ТаблицаСуществующих.Найти(СтрокаКлассификатора.Наименование,"Наименование")  = Неопределено Тогда
			СправочникОбъект = Справочники.РазрядыКатегорииДолжностей.СоздатьЭлемент();
			ЗаполнитьЗначенияСвойств(СправочникОбъект, СтрокаКлассификатора);
			СправочникОбъект.Записать();
		КонецЕсли;
	КонецЦикла;
	
	ЗаполнитьРеквизитДопУпорядочивания();
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитДопУпорядочивания() 
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	РазрядыКатегорииДолжностей.Ссылка
	               |ИЗ
	               |	Справочник.РазрядыКатегорииДолжностей КАК РазрядыКатегорииДолжностей
	               |ГДЕ
	               |	РазрядыКатегорииДолжностей.РеквизитДопУпорядочивания = 0
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	РазрядыКатегорииДолжностей.Наименование";
				   
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда 
		Возврат;
	КонецЕсли;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	МАКСИМУМ(РазрядыКатегорииДолжностей.РеквизитДопУпорядочивания) КАК ТекущееМаксимальноеЗначение
	               |ИЗ
	               |	Справочник.РазрядыКатегорииДолжностей КАК РазрядыКатегорииДолжностей";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	ТекущееМаксимальноеЗначение = Выборка.ТекущееМаксимальноеЗначение;
	
	Сч = 1;
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.РеквизитДопУпорядочивания = ТекущееМаксимальноеЗначение + Сч;
		Объект.ОбменДанными.Загрузка = Истина;
		Объект.Записать();
		
		Сч = Сч + 1;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
