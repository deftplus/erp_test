
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ИспользоватьКоличество = Параметры.ИспользоватьКоличество;
	ВидНоменклатуры = Параметры.ВидНоменклатуры;
	
	КоличествоСерийДляЗаполнения = Параметры.КоличествоСерий;
	
	Если ИспользоватьКоличество Тогда
		Элементы.ГруппаВКаждойСерии.Видимость = Истина;
		ЕдиницаИзмеренияСтр = Параметры.ЕдиницаИзмеренияСтр;
		Элементы.ВКаждойСерииРазноеКоличество.СписокВыбора[0].Представление = Элементы.ВКаждойСерииРазноеКоличество.СписокВыбора[0].Представление + " " + ЕдиницаИзмеренияСтр;
		ВКаждойСерии = Параметры.ВКаждойСерии;
		Элементы.ГруппаКоличествоВКаждой.Доступность = (ВКаждойСерии = 1);
		ТекущийЭлемент = ?(ВКаждойСерии = 1, Элементы.ВКаждойСерииКоличество, Элементы.КоличествоСерий);
	Иначе
		КоличествоСерий = Параметры.КоличествоСерий;
		Элементы.ГруппаВКаждойСерии.Видимость = Ложь;
		ТекущийЭлемент = Элементы.КоличествоСерий;
	КонецЕсли;	
	
	УправлениеЭлементами(ЭтаФорма);
	
	СерияОбъект = Справочники.СерииНоменклатуры.СоздатьЭлемент();
	СерияОбъект.ВидНоменклатуры = ВидНоменклатуры;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", СерияОбъект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВКаждойСерииПриИзменении(Элемент)
	
	УправлениеЭлементами(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВКаждойСерииРазноеКоличествоПриИзменении(Элемент)
	
	УправлениеЭлементами(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособНумерацииСерийПриИзменении(Элемент)
	
	УправлениеЭлементами(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВсемиНомерамиИзДиапазонаПриИзменении(Элемент)
	
	УправлениеЭлементами(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГенерацияПоПорядкуПриИзменении(Элемент)
	
	УправлениеЭлементами(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГенерацияИзДиапазонаПриИзменении(Элемент)
	
	УправлениеЭлементами(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВКаждойСерииКоличествоПриИзменении(Элемент)
	
	Если СпособНумерацииСерий = 0 И КоличествоСерийДляЗаполнения <> 0 И ВКаждойСерииКоличество <> 0 Тогда
		 КоличествоСерий = КоличествоСерийДляЗаполнения / ВКаждойСерииКоличество;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	
	Если (СпособНумерацииСерий = 1 ИЛИ ОграничениеГенерацииНомеров = 1)
	 И (КонечныйНомер < НачальныйНомер ИЛИ НачальныйНомер = 0 ИЛИ КонечныйНомер = 0) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Неверно задан диапазон номеров серий.';
																|en = 'Batch number range is specified incorrectly.'"),, "НачальныйНомер");
		Возврат;
	КонецЕсли;
	
	Если СпособНумерацииСерий = 0 И НЕ ЗначениеЗаполнено(КоличествоСерий) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указано количество серий.';
																|en = 'Batch quantity is not specified.'"),, "КоличествоСерий");
		Возврат;
	КонецЕсли;
	
	Если СпособНумерацииСерий = 0 И ОграничениеГенерацииНомеров = 1
	 И КоличествоСерий > (КонечныйНомер - НачальныйНомер + 1) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Количество номеров серий превышает размер диапазона.';
																|en = 'Quantity of batch numbers exceeds the range size.'"),, "КоличествоСерий");
		Возврат;
	КонецЕсли;
	
	Если ИспользоватьКоличество И ВКаждойСерии = 1 И НЕ ЗначениеЗаполнено(ВКаждойСерииКоличество) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указано количество номенклатуры в серии.';
																|en = 'Number of items in batch is not specified.'"),, "ВКаждойСерииКоличество");
		Возврат;
	КонецЕсли;
	
	СтруктураВозврата = Новый Структура("
		|СпособНумерацииСерий,
		|КоличествоСерий,
		|НачальныйНомер,
		|КонечныйНомер,
		|ОграничениеГенерацииНомеров,
		|ВКаждойСерии");
	ЗаполнитьЗначенияСвойств(СтруктураВозврата, ЭтаФорма);
	
	Если Элементы.ГруппаВКаждойСерии.Видимость Тогда
		СтруктураВозврата.Вставить("ВКаждойСерииКоличество", ВКаждойСерииКоличество);
	Иначе 
		СтруктураВозврата.Вставить("ВКаждойСерииКоличество", 1);
	КонецЕсли;	
	
	ПолучитьДополнительныеРеквизиты(СтруктураВозврата);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект, ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементами(Форма)
	
	Форма.Элементы.ГруппаКоличествоСерий.Доступность = (Форма.СпособНумерацииСерий = 0);
	Форма.Элементы.ГруппаНастройкиГенерации.Доступность = (Форма.СпособНумерацииСерий = 0);
	Форма.Элементы.ГруппаДиапазонНомеров.Доступность = (Форма.СпособНумерацииСерий = 1);
	Форма.Элементы.ГруппаДиапазонНомеров2.Доступность = (Форма.ОграничениеГенерацииНомеров = 1);
	
	Форма.Элементы.ГруппаКоличествоВКаждой.Доступность = (Форма.ВКаждойСерии = 1);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьДополнительныеРеквизиты(СтруктураВозврата)
	
	СерияОбъект = Справочники.СерииНоменклатуры.СоздатьЭлемент();
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, СерияОбъект);
	
	ДополнительныеРеквизиты = Новый Массив;
	Для Каждого ТекСтр Из СерияОбъект.ДополнительныеРеквизиты Цикл
		ДополнительныеРеквизиты.Добавить(
			Новый ФиксированнаяСтруктура("Свойство, Значение, ТекстоваяСтрока", ТекСтр.Свойство, ТекСтр.Значение, ТекСтр.ТекстоваяСтрока));
	КонецЦикла;
	
	СтруктураВозврата.Вставить("ДополнительныеРеквизиты", Новый ФиксированныйМассив(ДополнительныеРеквизиты));
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти
