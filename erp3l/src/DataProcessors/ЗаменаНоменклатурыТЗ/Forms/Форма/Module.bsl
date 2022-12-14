
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры.ТаблицаНоменклатуры) = Тип("ДанныеФормыДерево") Тогда
		
		ТаблицаНоменклатуры.Очистить();
		ПервыйУровень = Параметры.ТаблицаНоменклатуры.ПолучитьЭлементы();
		Для Каждого Строка_ Из ПервыйУровень Цикл
			НоваяСтрока_ = ТаблицаНоменклатуры.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока_, Строка_);
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Параметры.ТаблицаНоменклатуры) = Тип("ДанныеФормыКоллекция") Тогда
		
		ТаблицаНоменклатуры.Загрузить(Параметры.ТаблицаНоменклатуры.Выгрузить());
		
	Иначе
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Таб.Номенклатура КАК Номенклатура,
		|	Таб.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	Таб.Характеристика КАК Характеристика,
		|	Таб.Коэффициент КАК Коэффициент,
		|	Таб.Количество КАК Количество,
		|	Таб.Сумма КАК Сумма
		|ПОМЕСТИТЬ ТаблицаНоменклатуры
		|ИЗ
		|	&Таблица КАК Таб
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаНоменклатуры.Номенклатура КАК Номенклатура,
		|	ТаблицаНоменклатуры.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ТаблицаНоменклатуры.Характеристика КАК Характеристика,
		|	ТаблицаНоменклатуры.Коэффициент КАК Коэффициент,
		|	ТаблицаНоменклатуры.Количество КАК Количество,
		|	ТаблицаНоменклатуры.Сумма КАК Сумма,
		|	Номенклатура1.ТоварнаяКатегория КАК ТоварнаяКатегория
		|ИЗ
		|	ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаЗаменыНоменклатуры КАК НастройкаЗаменыНоменклатуры
		|		ПО ТаблицаНоменклатуры.Номенклатура = НастройкаЗаменыНоменклатуры.НоменклатураИсточник
		|			И ТаблицаНоменклатуры.ЕдиницаИзмерения = НастройкаЗаменыНоменклатуры.ЕдиницаИзмеренияИсточник
		|			И ТаблицаНоменклатуры.Характеристика = НастройкаЗаменыНоменклатуры.ХарактеристикаИсточник
		|			И (НастройкаЗаменыНоменклатуры.СпособЗамены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаменыНоменклатуры.Аналоги))
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура1
		|		ПО ТаблицаНоменклатуры.Номенклатура = Номенклатура1.Ссылка";
	
	Запрос.УстановитьПараметр("Таблица", ТаблицаНоменклатуры.Выгрузить());
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаНоменклатуры.Загрузить(РезультатЗапроса.Выгрузить());
	
	РасчетЦенИРазниц();
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		ЭтаФорма,
		"ТаблицаНоменклатурыХарактеристика",
		"ТаблицаНоменклатуры.ХарактеристикиИспользуются");
		
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		ЭтаФорма,
		"ТаблицаНоменклатурыХарактеристикаЗамены",
		"ТаблицаНоменклатуры.ХарактеристикиИспользуются");
		
	флРежимВыбораАналогов = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьОтборАналогов(Неопределено, Неопределено, Неопределено, 0, 0);
	УстановитьВидимость();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПоКатегорииПриИзменении(Элемент)
	Элементы.ТоварнаяКатегория.Доступность = ОтборПоКатегории;
	УправлениеОтбором();
КонецПроцедуры

&НаКлиенте
Процедура ТоварнаяКатегорияПриИзменении(Элемент)
	УправлениеОтбором();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура АналогиНоменклатурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ТекНоменклатура = Элементы.ТаблицаНоменклатуры.ТекущиеДанные;
	Если ТекНоменклатура = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекАанлог = Элементы.АналогиНоменклатуры.ТекущиеДанные;
	Если ТекАанлог = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекНоменклатура.НоменклатураЗамены = ТекАанлог.НоменклатураПриемник;
	ТекНоменклатура.ХарактеристикаЗамены = ТекАанлог.ХарактеристикаПриемник;
	ТекНоменклатура.ЕдиницаИзмеренияЗамены = ТекАанлог.ЕдиницаИзмеренияПриемник;
	ТекНоменклатура.КоэффициентЗамены = ТекАанлог.Коэффициент;
	ТекНоменклатура.ЦенаАналог = ТекАанлог.Цена;
	РасчетЦенИРазниц();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНоменклатурыПриАктивизацииСтроки(Элемент)
	ТекДанные = Элементы.ТаблицаНоменклатуры.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		УстановитьОтборАналогов(Неопределено, Неопределено, Неопределено, 0, 0);
		Возврат;
	КонецЕсли;
	
	УстановитьОтборАналогов(ТекДанные.Номенклатура, ТекДанные.Характеристика, ТекДанные.ЕдиницаИзмерения, ТекДанные.Сумма, ТекДанные.Цена);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНоменклатурыНоменклатураЗаменыПриИзменении(Элемент)
	ТекДанные = Элементы.ТаблицаНоменклатуры.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеДляПолучения = Новый Массив;
	СтрокаРеквизитов = "Имя,Формула,Операнды";
	
	Если ЗначениеЗаполнено(ТекДанные.НоменклатураЗамены) Тогда
		ОписаниеЗначения = Новый Структура(СтрокаРеквизитов);
		ОписаниеЗначения.Имя = "ЕдиницаИзмерения";
		ОписаниеЗначения.Формула = "ОписаниеЗначения.Операнды.Номенклатура.ЕдиницаИзмерения";
		ОписаниеЗначения.Операнды = Новый Структура("Номенклатура", ТекДанные.НоменклатураЗамены);
		ДанныеДляПолучения.Добавить(ОписаниеЗначения);
		
		ОписаниеЗначения = Новый Структура(СтрокаРеквизитов);
		ОписаниеЗначения.Имя = "Коэффициент";
		ОписаниеЗначения.Формула = "ЦентрализованныеЗакупкиУХ.ПолучитьКоэффициентЕдиницыИзмерения(ОписаниеЗначения.Операнды.Номенклатура, ОписаниеЗначения.Операнды.Характеристика, ЗначенияДанных.ЕдиницаИзмерения)";
		ОписаниеЗначения.Операнды = Новый Структура("Номенклатура, Характеристика", 
			ТекДанные.НоменклатураЗамены,
			ТекДанные.ХарактеристикаЗамены);
		ДанныеДляПолучения.Добавить(ОписаниеЗначения);
		
		ЗначенияДанных = ЦентрализованныеЗакупкиВызовСервераУХ.ПолучитьДанныеНаСервере(ДанныеДляПолучения);
		ТекДанные.ЕдиницаИзмеренияЗамены = ЗначенияДанных.ЕдиницаИзмерения;
		ТекДанные.КоэффициентЗамены = ЗначенияДанных.Коэффициент;
		
	Иначе
		ТекДанные.ЕдиницаИзмеренияЗамены = неопределено;
		ТекДанные.КоэффициентЗамены = 0;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаменитьНаУнификаты(Команда)
	ЗаменитьНаУнификатыНаСервере()
КонецПроцедуры

&НаСервере
Процедура ЗаменитьНаУнификатыНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТабИсходная_.НомерСтроки КАК НомерСтроки,
		|	ТабИсходная_.Номенклатура КАК Номенклатура,
		|	ТабИсходная_.Характеристика КАК Характеристика,
		|	ТабИсходная_.Коэффициент КАК Коэффициент,
		|	ТабИсходная_.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ТабИсходная_.НоменклатураЗамены КАК НоменклатураЗамены,
		|	ТабИсходная_.ХарактеристикаЗамены КАК ХарактеристикаЗамены,
		|	ТабИсходная_.КоэффициентЗамены КАК КоэффициентЗамены,
		|	ТабИсходная_.ЕдиницаИзмеренияЗамены КАК ЕдиницаИзмеренияЗамены
		|ПОМЕСТИТЬ ТабИсходная
		|ИЗ
		|	&ТабИсходная КАК ТабИсходная_
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТабИсходная.НомерСтроки КАК НомерСтроки,
		|	ТабИсходная.Номенклатура КАК Номенклатура,
		|	ТабИсходная.Характеристика КАК Характеристика,
		|	ТабИсходная.Коэффициент КАК Коэффициент,
		|	ТабИсходная.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ЕСТЬNULL(НастройкаЗаменыНоменклатуры.НоменклатураПриемник, ТабИсходная.НоменклатураЗамены) КАК НоменклатураЗамены,
		|	ЕСТЬNULL(НастройкаЗаменыНоменклатуры.ХарактеристикаПриемник, ТабИсходная.ХарактеристикаЗамены) КАК ХарактеристикаЗамены,
		|	ЕСТЬNULL(НастройкаЗаменыНоменклатуры.ЕдиницаИзмеренияПриемник, ТабИсходная.ЕдиницаИзмеренияЗамены) КАК ЕдиницаИзмеренияЗамены,
		|	ЕСТЬNULL(НастройкаЗаменыНоменклатуры.Коэффициент, ТабИсходная.КоэффициентЗамены) КАК КоэффициентЗамены
		|ИЗ
		|	ТабИсходная КАК ТабИсходная
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаЗаменыНоменклатуры КАК НастройкаЗаменыНоменклатуры
		|		ПО ТабИсходная.Номенклатура = НастройкаЗаменыНоменклатуры.НоменклатураИсточник
		|			И ТабИсходная.Характеристика = НастройкаЗаменыНоменклатуры.ХарактеристикаИсточник
		|			И ТабИсходная.ЕдиницаИзмерения = НастройкаЗаменыНоменклатуры.ЕдиницаИзмеренияИсточник
		|			И (НастройкаЗаменыНоменклатуры.СпособЗамены = &СпособЗамены)";
	
	Запрос.УстановитьПараметр("ТабИсходная", ТаблицаНоменклатуры.Выгрузить());
	Запрос.УстановитьПараметр("СпособЗамены", Перечисления.СпособыЗаменыНоменклатуры.Унификат);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаНоменклатуры.Загрузить(РезультатЗапроса.Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура РежимВыбораАналогов(Команда)
	флРежимВыбораАналогов  = НЕ Элементы.ТаблицаНоменклатурыРежимВыбораАналогов.Пометка;
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	Закрыть(ТаблицаНоменклатуры);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимость()
	Элементы.ТаблицаНоменклатурыРежимВыбораАналогов.Пометка = флРежимВыбораАналогов;
	Элементы.АналогиНоменклатуры.Видимость = флРежимВыбораАналогов;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборАналогов(НоменклатураИсточник, ХарактеристикаИсточник, ЕдИзмИсточник, Сумма, Цена)
	ОтборыСписковКлиентСерверУХ.ИзменитьЭлементОтбораСписка(АналогиНоменклатуры, "НоменклатураИсточник", НоменклатураИсточник, Истина);
	ОтборыСписковКлиентСерверУХ.ИзменитьЭлементОтбораСписка(АналогиНоменклатуры, "ХарактеристикаИсточник", ХарактеристикаИсточник, Истина);
	ОтборыСписковКлиентСерверУХ.ИзменитьЭлементОтбораСписка(АналогиНоменклатуры, "ЕдиницаИзмеренияИсточник", ЕдИзмИсточник, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(АналогиНоменклатуры, "Сумма", Сумма, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(АналогиНоменклатуры, "Цена", Цена, Истина); 
	Элементы.АналогиНоменклатуры.Обновить();
КонецПроцедуры

&НаСервере
Процедура РасчетЦенИРазниц()
	Для каждого Стр Из ТаблицаНоменклатуры Цикл
		Если Стр.Количество <> 0 Тогда 
			Стр.Цена = Стр.Сумма / Стр.Количество;
		КонецЕсли;
		Если ЗначениеЗаполнено(Стр.НоменклатураЗамены) Тогда 
			Стр.СуммаАналог = Стр.ЦенаАналог * Стр.Количество;
			Стр.Экономия = Стр.Сумма - Стр.СуммаАналог;
			Стр.ЭкономияЦена = Стр.Цена - Стр.ЦенаАналог;
		Иначе
			Стр.ЦенаАналог = 0;
			Стр.СуммаАналог = 0;
			Стр.Экономия = 0;
			Стр.ЭкономияЦена = 0;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура УправлениеОтбором()
	Если ОтборПоКатегории Тогда
		Элементы.ТаблицаНоменклатуры.ОтборСтрок = Новый ФиксированнаяСтруктура("ТоварнаяКатегория", ТоварнаяКатегория);
	Иначе
		Элементы.ТаблицаНоменклатуры.ОтборСтрок = Неопределено;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

