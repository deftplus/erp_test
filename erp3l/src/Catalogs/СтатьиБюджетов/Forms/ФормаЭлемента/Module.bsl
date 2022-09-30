
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если Объект.Ссылка.Пустая() Тогда
		ЕдиницаИзмеренияОпределяетсяАналитикой = Объект.ЕдиницаИзмеренияОпределяетсяАналитикой;
		ВалютаОпределяетсяАналитикой = Объект.ВалютаОпределяетсяАналитикой;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	УправлениеФормой(ЭтаФорма);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_СтатьиБюджетов", , Объект.Ссылка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	ЕдиницаИзмеренияОпределяетсяАналитикой = Объект.ЕдиницаИзмеренияОпределяетсяАналитикой;
	ВалютаОпределяетсяАналитикой = Объект.ВалютаОпределяетсяАналитикой;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидАналитикиПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	УстановитьСвязанныеПараметры();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ПараметрыПроцедуры = ОбщегоНазначенияУТКлиент.ПараметрыРазрешенияРедактированияРеквизитовОбъекта();
	ПараметрыПроцедуры.ОповещениеОРазблокировке = Новый ОписаниеОповещения("РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма, ПараметрыПроцедуры);
	
КонецПроцедуры

&НаКлиенте
Процедура УчетПоКоличествуПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УчетПоВалютеПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределятьЕдиницуИзмеренияПриИзменении(Элемент)
	
	Если ЕдиницаИзмеренияОпределяетсяАналитикой Тогда
		Объект.ЕдиницаИзмерения = ПредопределенноеЗначение("Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка");
	Иначе
		Объект.АналитикаЕдиницыИзмерения = Неопределено;
	КонецЕсли;
	
	Объект.ЕдиницаИзмеренияОпределяетсяАналитикой = ЕдиницаИзмеренияОпределяетсяАналитикой;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаОпределяетсяАналитикойПриИзменении(Элемент)
	
	Если Не ВалютаОпределяетсяАналитикой Тогда
		Объект.АналитикаВалюты = Неопределено;
	КонецЕсли;
	
	Объект.ВалютаОпределяетсяАналитикой = ВалютаОпределяетсяАналитикой;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	ЭлементыФормы = Форма.Элементы;
	
	Если НЕ ЭлементыФормы.УчитыватьПоКоличеству.ТолькоПросмотр Тогда
		ДоступностьКоличества = Форма.Объект.УчитыватьПоКоличеству;
		ЭлементыФормы.ЕдиницаИзмеренияОпределяетсяАналитикой.Доступность = ДоступностьКоличества;
		ЭлементыФормы.УказаннаяЕдиницаИзмерения.Доступность = ДоступностьКоличества;
		ОпределятьЕдиницуИзмерения = Форма.ЕдиницаИзмеренияОпределяетсяАналитикой;
		
		ЭлементыФормы.ЕдиницаИзмерения.Доступность = ДоступностьКоличества И НЕ ОпределятьЕдиницуИзмерения;
		ЭлементыФормы.АналитикаЕдиницыИзмерения.Доступность = ДоступностьКоличества И ОпределятьЕдиницуИзмерения;
	Иначе
		ЭлементыФормы.ЕдиницаИзмеренияОпределяетсяАналитикой.Доступность = Ложь;
		ЭлементыФормы.УказаннаяЕдиницаИзмерения.Доступность = Ложь;
		ЭлементыФормы.ЕдиницаИзмерения.Доступность = Ложь;
		ЭлементыФормы.АналитикаЕдиницыИзмерения.Доступность = Ложь;
	КонецЕсли;
	
	Если НЕ ЭлементыФормы.УчитыватьПоВалюте.ТолькоПросмотр Тогда
		ДоступностьВалюты = Форма.Объект.УчитыватьПоВалюте;
		ЭлементыФормы.ВалютаОпределяетсяАналитикой.Доступность = ДоступностьВалюты;
		ЭлементыФормы.ВалютаУказываетсяВВидеБюджета.Доступность = ДоступностьВалюты;
		ВалютаОпределяетсяАналитикой = Форма.ВалютаОпределяетсяАналитикой;
		ЭлементыФормы.АналитикаВалюты.Доступность = ДоступностьВалюты И ВалютаОпределяетсяАналитикой;
	Иначе
		ЭлементыФормы.ВалютаОпределяетсяАналитикой.Доступность = Ложь;
		ЭлементыФормы.ВалютаУказываетсяВВидеБюджета.Доступность = Ложь;
		ЭлементыФормы.АналитикаВалюты.Доступность = Ложь;
	КонецЕсли;
	
	Массив = Новый Массив;
	Для Сч = 1 По 6 Цикл
		Массив.Добавить(Форма.Объект["ВидАналитики" + Сч]);
	КонецЦикла;
	
	ПараметрыВыбора = Форма.Элементы.АналитикаЕдиницыИзмерения.ПараметрыВыбора;
	МассивВыбора = Новый Массив(ПараметрыВыбора);
	МассивВыбора[1] = 
		Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(Массив));
	Форма.Элементы.АналитикаЕдиницыИзмерения.ПараметрыВыбора = Новый ФиксированныйМассив(МассивВыбора);
	
	ПараметрыВыбора = Форма.Элементы.АналитикаВалюты.ПараметрыВыбора;
	МассивВыбора = Новый Массив(ПараметрыВыбора);
	МассивВыбора[1] = 
		Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(Массив));
	Форма.Элементы.АналитикаВалюты.ПараметрыВыбора = Новый ФиксированныйМассив(МассивВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСвязанныеПараметры()
	
	Массив = Новый Массив;
	Для Сч = 1 По 6 Цикл
		Массив.Добавить(Объект["ВидАналитики" + Сч]);
	КонецЦикла;
	
	Если Массив.Найти(Объект.АналитикаВалюты) = Неопределено Тогда
		Объект.АналитикаВалюты = Неопределено;
	КонецЕсли;
	
	Если Массив.Найти(Объект.АналитикаЕдиницыИзмерения) = Неопределено Тогда
		Объект.АналитикаЕдиницыИзмерения = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
