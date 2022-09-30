&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьВидимость();
	ВыборОбъектовУХ.ЗаполнитьСписокВыбораИмяТипаОбъекта(Элементы.ИмяТипаОбъекта.СписокВыбора);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ТипЗначенияПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	Если ЗначениеЗаполнено(Объект.ИмяТипаОбъекта) Тогда
		Элементы.ИмяТипаОбъекта.ТолькоПросмотр = Истина;
	Иначе
		// Не требуется блокировка типа.
	КонецЕсли;
	флИспользуетсяДляКвалификацииПоставщиков = Объект.ИспользуетсяДляКвалификацииПоставщиков;
	
	Элементы.ФункциональноеНаправление.Видимость = НЕ флИспользуетсяДляКвалификацииПоставщиков;
	Элементы.Вес.Видимость = НЕ флИспользуетсяДляКвалификацииПоставщиков;
	Элементы.ГруппаМинМакс.Видимость = НЕ флИспользуетсяДляКвалификацииПоставщиков;
	
	Элементы.МножествоЗначений.Видимость = (Объект.СпособВводаЗначения = ПредопределенноеЗначение("Перечисление.СпособыВводаЗначенийКритериев.ВыборИзМножества"));
	Элементы.МножествоЗначенийОценка.Видимость = НЕ флИспользуетсяДляКвалификацииПоставщиков;
	
	ОтборыСписковКлиентСерверУХ.ИзменитьЭлементОтбораСписка(МножествоЗначений, "Владелец", Объект.Ссылка, Истина);
КонецПроцедуры


&НаКлиенте
Процедура МножествоЗначенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Модифицированность Тогда
		Отказ = Истина;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтаФорма, Параметры);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Необходимо записать критерий перед редактированием его значений. Записать?'"),
			РежимДиалогаВопрос.ДаНет, 0);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
    Если Результат = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
	
	Записать();
КонецПроцедуры

&НаКлиенте
Процедура ИспользуетсяДляКвалификацииПоставщиковПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ИмяТипаОбъектаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Объект.ИмяТипаОбъекта = ВыбранноеЗначение;
КонецПроцедуры
