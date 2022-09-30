
#Область ОбработкаОсновныхСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		ЭтаФорма,
		"ОстаткиНоменклатурыХарактеристика",
		"Объект.ОстаткиНоменклатуры.ХарактеристикиИспользуются");
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыНоменклатура

&НаКлиенте
Процедура ОстаткиНоменклатурыНоменклатураПриИзменении(Элемент)
	ТекДанные = Элементы.ОстаткиНоменклатуры.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьИзменениеНоменклатуры();
	РассчитатьСуммуТекущейСтроки();
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиНоменклатурыЕдиницаИзмеренияПриИзменении(Элемент)
	ТекДанные = Элементы.ОстаткиНоменклатуры.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьИзменениеЕдиницыИзмерения();
	РассчитатьСуммуТекущейСтроки();
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиНоменклатурыКоличествоПриИзменении(Элемент)
	РассчитатьСуммуТекущейСтроки();
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиНоменклатурыЦенаПриИзменении(Элемент)
	РассчитатьСуммуТекущейСтроки();
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуТекущейСтроки()
	ТекДанные = Элементы.ОстаткиНоменклатуры.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекДанные.Номенклатура) Тогда
		ТекДанные.Сумма = 0;
		возврат;
	КонеЦЕсли;
	
	ТекДанные.Сумма = ТекДанные.Количество * ТекДанные.Цена;
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеНоменклатуры()
	
	ТекСтрока = Элементы.ОстаткиНоменклатуры.ТекущаяСтрока;
	ТекДанные = Объект.ОстаткиНоменклатуры.НайтиПоИдентификатору(ТекСтрока);
	
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекДанные.Номенклатура) Тогда
		ТекДанные.ЕдиницаИзмерения =
			УправлениеЗакупкамиВстраиваниеПереопределяемыйУХ.ПолучитьПустуюЕдиницуИзмерения();
		ТекДанные.Коэффициент = 0;
		ТекДанные.Количество = 0;
		ТекДанные.Цена = 0;
		ТекДанные.Сумма = 0;
		
		Возврат;
	КонеЦЕсли;
	
	Если ЗначениеЗаполнено(ТекДанные.ЕдиницаИзмерения) Тогда
		Коэффициент = ЦентрализованныеЗакупкиУХ.ПолучитьКоэффициентЕдиницыИзмерения(ТекДанные.Номенклатура, ТекДанные.ЕдиницаИзмерения);
		Если Коэффициент = 0 Тогда
			ТекДанные.ЕдиницаИзмерения = ТекДанные.Номенклатура.ЕдиницаИзмерения;
			ТекДанные.Коэффициент = 1;
		КонецЕсли;
	Иначе
		ТекДанные.ЕдиницаИзмерения = ТекДанные.Номенклатура.ЕдиницаИзмерения;
		ТекДанные.Коэффициент = 1;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ТипЦен) Тогда
		ТекДанные.Цена = ЦентрализованныеЗакупкиУХ.ПолучитьЦенуНоменклатуры(
			ТекДанные.Номенклатура, 
			ТекДанные.Характеристика,
			Объект.ТипЦен,
			Объект.Дата,
			Константы.ВалютаУчетаЦентрализованныхЗакупок.Получить());
	Иначе
		ТекДанные.Цена = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеЕдиницыИзмерения()
	
	ТекСтрока = Элементы.ОстаткиНоменклатуры.ТекущаяСтрока;
	ТекДанные = Объект.Номенклатура.НайтиПоИдентификатору(ТекСтрока);
	
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекДанные.Номенклатура) Тогда
		Возврат;
	КонеЦЕсли;
	
	Если ЗначениеЗаполнено(ТекДанные.ЕдиницаИзмерения) Тогда
		Коэффициент = ЦентрализованныеЗакупкиУХ.ПолучитьКоэффициентЕдиницыИзмерения(ТекДанные.Номенклатура, ТекДанные.ЕдиницаИзмерения);
		Если Коэффициент = 0 Тогда
			Коэффициент = 1;
		КонецЕсли;
	Иначе
		Коэффициент = 1;
	КонецЕсли;
	
	КоэффПересчета = ТекДанные.Коэффициент / Коэффициент;
	
	ТекДанные.Коэффициент = Коэффициент;
	ТекДанные.Количество = Окр(ТекДанные.Количество * КоэффПересчета, 2);
	ТекДанные.Цена = Окр(ТекДанные.Цена / КоэффПересчета, 2);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЦеныНаСервере()
	ЦеныНоменклатуры = Новый Соответствие; // Номенклатура -> Характеристика -> Цена
	
	Если НЕ ЗначениеЗаполнено(Объект.ТипЦен) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка_ Из Объект.ОстаткиНоменклатуры Цикл
		Номенклатура_ = Строка_.Номенклатура;
		Характеристика_ = Строка_.Характеристика;
		ПараметрыКэша = ЦентрализованныеЗакупкиКлиентСерверУХ.ПоместитьВМассив2(
			Номенклатура_, 
			Характеристика_);
		Цена_ = ЦентрализованныеЗакупкиКлиентСерверУХ.НайтиЗначениеВКэше(
			ЦеныНоменклатуры,
			ПараметрыКэша);
		Если Цена_ = Неопределено Тогда
			Цена_ = ЦентрализованныеЗакупкиУХ.ПолучитьЦенуНоменклатуры(
				Номенклатура_, 
				Характеристика_,
				Объект.ТипЦен, 
				Объект.Дата,
				Константы.ВалютаУчетаЦентрализованныхЗакупок.Получить());
			ЦентрализованныеЗакупкиКлиентСерверУХ.ДобавитьЗначениеВКэш(
				ЦеныНоменклатуры, 
				ПараметрыКэша,
				Цена_);
			ЦеныНоменклатуры[Номенклатура_] = Цена_;
		КонецЕсли;
		Строка_.Цена = Цена_;
		Строка_.Сумма = Строка_.Количество * Цена_;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЦены(Команда)
	Если НЕ ЗначениеЗаполнено(Объект.ТипЦен) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не указан тип цен.'");
		Сообщение.Поле = "ТипЦен";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЦеныНаСервере();
КонецПроцедуры

	
#КонецОбласти
