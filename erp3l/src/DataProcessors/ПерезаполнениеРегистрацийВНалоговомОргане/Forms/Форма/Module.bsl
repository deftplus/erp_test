
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	
	ПроверитьИсториюРегистрацийВНалоговомОрганеВФорме(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ИсправляемыеРегистрации.Количество() = 0 Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Не найдено ошибочных записей';
									|en = 'No error entries'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИсправитьРегистрации(Команда)
	
	ИсправитьРегистрацииНаСервере();
	Если ИсправляемыеРегистрации.Количество() = 0 Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Ошибки исправлены';
									|en = 'Errors corrected'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверитьИсториюРегистрацийВНалоговомОрганеВФорме(Отказ = Истина)
	
	ПроверитьИсториюРегистрацийВНалоговомОргане();
	
	Если ИсправляемыеРегистрации.Количество() = 0 И ЗначениеЗаполнено(СтруктурнаяЕдиница) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ПроинициализироватьФорму();
	
КонецПроцедуры

&НаСервере
Процедура ПроинициализироватьФорму();

	Если ИсправляемыеРегистрации.Количество() = 0 Тогда
		ТекущаяСтраница = Элементы.ГруппаСтраницы.ТекущаяСтраница;
	Иначе
		
		Если ИсправляемыеРегистрации.Количество() = 1 Тогда
			
			ТекущаяСтраница = Элементы.ГруппаОднаСтруктурнаяЕдиница;
			
			Если ТипЗнч(ИсправляемыеРегистрации[0].СтруктурнаяЕдиница) = Тип("СправочникСсылка.Организации") Тогда
				ПредставлениеСтруктурнойЕдиницы = НСтр("ru = 'организации';
														|en = 'companies'");
			ИначеЕсли ТипЗнч(ИсправляемыеРегистрации[0].СтруктурнаяЕдиница) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
				ПредставлениеСтруктурнойЕдиницы = НСтр("ru = 'подразделения';
														|en = 'business units'");
			Иначе
				ПредставлениеСтруктурнойЕдиницы = НСтр("ru = 'территории';
														|en = 'areas'");
			КонецЕсли;
			
			
			ТекстИнфонадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В учете обнаружены несоответствия периодов регистраций в налоговом органе периодам истории изменения.
					|Для %1 %2 необходимо произвести восстановление записей о регистрации в налоговом органе, начиная с %3.';
					|en = 'Mismatches of registration periods with tax authority to history change periods were found in accounting.
					|For %1 %2 it is necessary to restore records of registration with the tax authority, starting from %3.'"),
				ПредставлениеСтруктурнойЕдиницы,
				ИсправляемыеРегистрации[0].СтруктурнаяЕдиница,
				Формат(ИсправляемыеРегистрации[0].Период, "ДЛФ=D"));
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"ДекорацияОднаСтруктурнаяЕдиница",
				"Заголовок",
				ТекстИнфонадписи);
				
		Иначе
			ТекущаяСтраница = Элементы.ГруппаНесколькоСтруктурныхЕдиниц;
		КонецЕсли;
		
	КонецЕсли; 
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаСтраницы",
		"ТекущаяСтраница",
		ТекущаяСтраница);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьИсториюРегистрацийВНалоговомОргане()
	
	ИсправляемыеРегистрации.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Обработки.ПерезаполнениеРегистрацийВНалоговомОргане.СоздатьВТПериодыДействияРегистраций(Запрос.МенеджерВременныхТаблиц);
	
	ОписанияРегистровСодержащихРегистрации = ЗарплатаКадры.ОписанияРегистровСодержащихРегистрацииВНалоговомОргане();
	Для каждого ОписаниеРегистра Из ОписанияРегистровСодержащихРегистрации Цикл
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ИсследуемыйРегистр.Период КАК Период,
			|	ИсследуемыйРегистр.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
			|	ИсследуемыйРегистр.Организация КАК Организация,
			|	ИсследуемыйРегистр.Подразделение КАК СтруктурнаяЕдиница
			|ПОМЕСТИТЬ ВТПериодыРегистрацийРегистра
			|ИЗ
			|	&ИсследуемыйРегистр КАК ИсследуемыйРегистр";
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ИсследуемыйРегистр", ОписаниеРегистра.ПолноеИмяРегистра);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИсследуемыйРегистр.Период", ОписаниеРегистра.ПутьКПолюПериод);
		
		Запрос.Выполнить();
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	МИНИМУМ(ПериодыРегистрацийРегистра.Период) КАК Период,
			|	ВЫБОР
			|		КОГДА ПериодыДействияРегистраций.СтруктурнаяЕдиница ЕСТЬ NULL
			|			ТОГДА ПериодыРегистрацийРегистра.Организация
			|		ИНАЧЕ ПериодыРегистрацийРегистра.СтруктурнаяЕдиница
			|	КОНЕЦ КАК СтруктурнаяЕдиница
			|ИЗ
			|	ВТПериодыРегистрацийРегистра КАК ПериодыРегистрацийРегистра
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПериодыДействияРегистраций КАК ПериодыДействияРегистраций
			|		ПО ПериодыРегистрацийРегистра.СтруктурнаяЕдиница = ПериодыДействияРегистраций.СтруктурнаяЕдиница
			|			И (ПериодыРегистрацийРегистра.Период МЕЖДУ ПериодыДействияРегистраций.Период И ВЫБОР
			|				КОГДА ПериодыДействияРегистраций.ПериодПоследующий = ДАТАВРЕМЯ(1, 1, 1)
			|					ТОГДА ДАТАВРЕМЯ(3999, 12, 31)
			|				ИНАЧЕ ПериодыДействияРегистраций.ПериодПоследующий
			|			КОНЕЦ)
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПериодыДействияРегистраций КАК ПериодыДействияРегистрацийОрганизации
			|		ПО ПериодыРегистрацийРегистра.Организация = ПериодыДействияРегистрацийОрганизации.СтруктурнаяЕдиница
			|			И (ПериодыРегистрацийРегистра.Период МЕЖДУ ПериодыДействияРегистрацийОрганизации.Период И ВЫБОР
			|				КОГДА ПериодыДействияРегистрацийОрганизации.ПериодПоследующий = ДАТАВРЕМЯ(1, 1, 1)
			|					ТОГДА ДАТАВРЕМЯ(3999, 12, 31)
			|				ИНАЧЕ ПериодыДействияРегистрацийОрганизации.ПериодПоследующий
			|			КОНЕЦ)
			|ГДЕ
			|	ПериодыРегистрацийРегистра.РегистрацияВНалоговомОргане <> ЕСТЬNULL(ПериодыДействияРегистраций.РегистрацияВНалоговомОргане, ПериодыДействияРегистрацийОрганизации.РегистрацияВНалоговомОргане)
			|
			|СГРУППИРОВАТЬ ПО
			|	ПериодыРегистрацийРегистра.Организация,
			|	ПериодыРегистрацийРегистра.СтруктурнаяЕдиница,
			|	ПериодыДействияРегистраций.СтруктурнаяЕдиница";
			
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				
				СтрокиСтруктурнойЕдиницы = ИсправляемыеРегистрации.НайтиСтроки(Новый Структура("СтруктурнаяЕдиница", Выборка.СтруктурнаяЕдиница));
				Если СтрокиСтруктурнойЕдиницы.Количество() = 0 Тогда
					ЗаполнитьЗначенияСвойств(ИсправляемыеРегистрации.Добавить(), Выборка);
				Иначе
					Если СтрокиСтруктурнойЕдиницы[0].Период > Выборка.Период Тогда
						СтрокиСтруктурнойЕдиницы[0].Период = Выборка.Период;
					КонецЕсли; 
				КонецЕсли; 
				
			КонецЦикла;
			
		КонецЕсли; 
		
		Запрос.Текст =
			"УНИЧТОЖИТЬ ВТПериодыРегистрацийРегистра";
			
		Запрос.Выполнить();
		
	КонецЦикла;
	
	ИсправляемыеРегистрации.Сортировать("СтруктурнаяЕдиница,Период");

КонецПроцедуры

&НаСервере
Процедура ИсправитьРегистрацииНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Обработки.ПерезаполнениеРегистрацийВНалоговомОргане.СоздатьВТПериодыДействияРегистраций(Запрос.МенеджерВременныхТаблиц);
	
	Для каждого СтрокаСтруктурнойЕдиницы Из ИсправляемыеРегистрации Цикл
		
		Запрос.УстановитьПараметр("СтруктурнаяЕдиница", СтрокаСтруктурнойЕдиницы.СтруктурнаяЕдиница);
		Запрос.УстановитьПараметр("Период", СтрокаСтруктурнойЕдиницы.Период);
		
		ОписанияРегистровСодержащихРегистрации = ЗарплатаКадры.ОписанияРегистровСодержащихРегистрацииВНалоговомОргане();
		Для каждого ОписаниеРегистра Из ОписанияРегистровСодержащихРегистрации Цикл
			
			Запрос.Текст =
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
				|	ИсследуемыйРегистр.Период КАК Период,
				|	ИсследуемыйРегистр.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
				|	ИсследуемыйРегистр.Подразделение КАК СтруктурнаяЕдиница,
				|	ИсследуемыйРегистр.Организация КАК Организация,
				|	ИсследуемыйРегистр.Регистратор КАК Регистратор
				|ПОМЕСТИТЬ ВТПериодыРегистрацийРегистра
				|ИЗ
				|	&ИсследуемыйРегистр КАК ИсследуемыйРегистр
				|ГДЕ
				|	ИсследуемыйРегистр.Период >= &Период
				|	И ИсследуемыйРегистр.Подразделение = &СтруктурнаяЕдиница";
			
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ИсследуемыйРегистр", ОписаниеРегистра.ПолноеИмяРегистра);
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИсследуемыйРегистр.Период", ОписаниеРегистра.ПутьКПолюПериод);
			
			Запрос.Выполнить();
			
			Запрос.Текст =
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ПериодыРегистрацийРегистра.Регистратор КАК Регистратор
				|ПОМЕСТИТЬ ВТИсправляемыеРегистраторы
				|ИЗ
				|	ВТПериодыРегистрацийРегистра КАК ПериодыРегистрацийРегистра
				|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПериодыДействияРегистраций КАК ПериодыДействияРегистраций
				|		ПО ПериодыРегистрацийРегистра.СтруктурнаяЕдиница = ПериодыДействияРегистраций.СтруктурнаяЕдиница
				|			И (ПериодыРегистрацийРегистра.Период МЕЖДУ ПериодыДействияРегистраций.Период И ВЫБОР
				|				КОГДА ПериодыДействияРегистраций.ПериодПоследующий = ДАТАВРЕМЯ(1, 1, 1)
				|					ТОГДА ДАТАВРЕМЯ(3999, 12, 31)
				|				ИНАЧЕ ПериодыДействияРегистраций.ПериодПоследующий
				|			КОНЕЦ)
				|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПериодыДействияРегистраций КАК ПериодыДействияРегистрацийОрганизации
				|		ПО ПериодыРегистрацийРегистра.Организация = ПериодыДействияРегистрацийОрганизации.СтруктурнаяЕдиница
				|			И (ПериодыРегистрацийРегистра.Период МЕЖДУ ПериодыДействияРегистрацийОрганизации.Период И ВЫБОР
				|				КОГДА ПериодыДействияРегистрацийОрганизации.ПериодПоследующий = ДАТАВРЕМЯ(1, 1, 1)
				|					ТОГДА ДАТАВРЕМЯ(3999, 12, 31)
				|				ИНАЧЕ ПериодыДействияРегистрацийОрганизации.ПериодПоследующий
				|			КОНЕЦ)
				|ГДЕ
				|	ПериодыРегистрацийРегистра.РегистрацияВНалоговомОргане <> ЕСТЬNULL(ПериодыДействияРегистраций.РегистрацияВНалоговомОргане, ПериодыДействияРегистрацийОрганизации.РегистрацияВНалоговомОргане)";
			
			Запрос.Выполнить();
			
			Запрос.Текст =
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	ИсправляемыйРегистр.Регистратор КАК Регистратор,
				|	ЕСТЬNULL(ПериодыДействияРегистраций.РегистрацияВНалоговомОргане, ПериодыДействияРегистрацийОрганизаций.РегистрацияВНалоговомОргане) КАК РегистрацияВНалоговомОргане,
				|	ИсправляемыйРегистр.*
				|ИЗ
				|	&ИсправляемыйРегистр КАК ИсправляемыйРегистр
				|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПериодыДействияРегистраций КАК ПериодыДействияРегистраций
				|		ПО (ИсправляемыйРегистр.Подразделение = ПериодыДействияРегистраций.СтруктурнаяЕдиница)
				|			И (ПериодыДействияРегистраций.Период <= ИсправляемыйРегистр.Период)
				|			И (ПериодыДействияРегистраций.ПериодПоследующий > ИсправляемыйРегистр.Период ИЛИ ПериодыДействияРегистраций.ПериодПоследующий = ДАТАВРЕМЯ(1, 1, 1))
				|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПериодыДействияРегистраций КАК ПериодыДействияРегистрацийОрганизаций
				|		ПО (ИсправляемыйРегистр.Организация = ПериодыДействияРегистрацийОрганизаций.СтруктурнаяЕдиница)
				|			И (ПериодыДействияРегистрацийОрганизаций.Период <= ИсправляемыйРегистр.Период)
				|			И (ПериодыДействияРегистрацийОрганизаций.ПериодПоследующий > ИсправляемыйРегистр.Период
				|				ИЛИ ПериодыДействияРегистрацийОрганизаций.ПериодПоследующий = ДАТАВРЕМЯ(1, 1, 1))
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТИсправляемыеРегистраторы КАК ИсправляемыеРегистраторы
				|		ПО ИсправляемыйРегистр.Регистратор = ИсправляемыеРегистраторы.Регистратор
				|ИТОГИ ПО
				|	Регистратор";
			
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ИсправляемыйРегистр", ОписаниеРегистра.ПолноеИмяРегистра);
			
			РезультатЗапроса = Запрос.Выполнить();
			Если НЕ РезультатЗапроса.Пустой() Тогда
				
				УстановитьПривилегированныйРежим(Истина);
				
				ВыборкаРегистраторов = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаРегистраторов.Следующий() Цикл
					
					НаборЗаписей = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОписаниеРегистра.ПолноеИмяРегистра).СоздатьНаборЗаписей();
					НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаРегистраторов.Регистратор);
					
					Выборка = ВыборкаРегистраторов.Выбрать();
					Пока Выборка.Следующий() Цикл
						ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
					КонецЦикла;
					
					НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
					НаборЗаписей.ОбменДанными.Загрузка = Истина;
					НаборЗаписей.Записать();
					
				КонецЦикла;
				
				УстановитьПривилегированныйРежим(Ложь);
				
			КонецЕсли;
			
			Запрос.Текст =
				"УНИЧТОЖИТЬ ВТПериодыРегистрацийРегистра
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|УНИЧТОЖИТЬ ВТИсправляемыеРегистраторы";
				
			Запрос.Выполнить();
			
		КонецЦикла;
		
	КонецЦикла;
	
	ПроверитьИсториюРегистрацийВНалоговомОрганеВФорме();
	
КонецПроцедуры

#КонецОбласти
