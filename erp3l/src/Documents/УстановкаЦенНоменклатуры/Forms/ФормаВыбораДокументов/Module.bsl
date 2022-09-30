
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Период = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("УстановкаЦенНоменклатурыФормаВыбораДокументов", "ПериодОтбораДокументов");
	
	Если Период.ДатаОкончания = Дата(1, 1, 1) Тогда
		Период.Вариант = ВариантСтандартногоПериода.Месяц;
	КонецЕсли;
	
	ОбновитьСписокДокументовСервер();

КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкиСервер(ПериодОтбора)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("УстановкаЦенНоменклатурыФормаВыбораДокументов", "ПериодОтбораДокументов", ПериодОтбора);

КонецПроцедуры

&НаКлиенте
Процедура ПериодВариантПриИзменении(Элемент)
	
	СохранитьНастройкиСервер(Период);
	
КонецПроцедуры

&НаКлиенте
Процедура Завершить(Команда)
	
	МассивДокументов = ВыбранныеДокументыСервер();
	Закрыть(МассивДокументов);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокДокументовСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокДокументовСервер()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УстановкаЦен.Ссылка        КАК Ссылка,
	|	УстановкаЦен.Номер         КАК Номер,
	|	УстановкаЦен.Дата          КАК Дата,
	|	УстановкаЦен.Комментарий   КАК Комментарий,
	|	УстановкаЦен.Статус        КАК Статус,
	|	УстановкаЦен.Ответственный КАК Ответственный,
	|	УстановкаЦен.Проведен      КАК Проведен,
	|	УстановкаЦен.МаркетинговоеМероприятие КАК МаркетинговоеМероприятие
	|ИЗ
	|	Документ.УстановкаЦенНоменклатуры КАК УстановкаЦен
	|ГДЕ
	|	УстановкаЦен.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ,
	|	Номер УБЫВ
	|");
	
	Запрос.УстановитьПараметр("ДатаНачала",    Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", Период.ДатаОкончания);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТаблицаДокументов.Очистить();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ТаблицаДокументов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ВыбранныеДокументыСервер()
	
	Отбор = Новый Структура("Выбран", Истина);
	НайденныеСтроки = ТаблицаДокументов.НайтиСтроки(Отбор);
	МассивДокументов = ТаблицаДокументов.Выгрузить(НайденныеСтроки, "Ссылка").ВыгрузитьКолонку("Ссылка");
	Возврат МассивДокументов;
	
КонецФункции