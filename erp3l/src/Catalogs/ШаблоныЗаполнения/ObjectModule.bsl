#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Заполняет в шаблон ОбъектЗаполненияВход значение стандартного реквизита НаименованиеРеквизитаВход 
// из ОбъектРодительВход в случае его наличия.
Процедура ЗаполнитьСтандартныйРеквизитОбъектаВШалон(ОбъектРодительВход, ОбъектЗаполненияВход, НаименованиеРеквизитаВход)
	Если ОбщегоназначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ОбъектРодительВход, НаименованиеРеквизитаВход) Тогда
		НоваяСтрокаРеквизиты = ОбъектЗаполненияВход.РеквизитыШаблона.Добавить();
		НоваяСтрокаРеквизиты.НаименованиеРеквизита	 = НаименованиеРеквизитаВход;
		НоваяСтрокаРеквизиты.ЗначениеРеквизита		 = ОбъектРодитель[НаименованиеРеквизитаВход];
		НоваяСтрокаРеквизиты.ТабличнаяЧасть			 = "";
		НоваяСтрокаРеквизиты.НомерСтрокиТаблицы		 = 0;
	Иначе
		// Такого реквизита нет. Ничего не делаем.
	КонецЕсли;
КонецПроцедуры

// Выполняет заполнение текущего шаблона по данным объекта ОбъектРодитель. А также присваивает 
// ему наименование НаименованиеШаблона.
Процедура ЗаполнитьИзОбъекта(НаименованиеШаблона, ОбъектРодитель, СписокРеквизитовВход = Неопределено, СписокТабличныхЧастейВход = Неопределено, АналитикаОтобраВход = Неопределено, ВариантЗаполненияВход = Неопределено) Экспорт
	// Заполним основные реквизиты шаблона.
	Если ОбъектРодитель = Неопределено Тогда
		Возврат;		// Нет данных для заполнения.
	Иначе
		// Выполняем далее.
	КонецЕсли;
	Если ВариантЗаполненияВход = Неопределено Тогда
		ВариантЗаполненияРабочий = Справочники.ВариантыЗаполненияШаблонов.ПустаяСсылка();
	Иначе
		ВариантЗаполненияРабочий = ВариантЗаполненияВход;
	КонецЕсли;
	МетаданныеОбъекта = ОбъектРодитель.Метаданные();
	ЭтотОбъект.Наименование				 = НаименованиеШаблона;
	ЭтотОбъект.ОбъектРодитель			 = ОбъектРодитель;
	ЭтотОбъект.ИмяРодителя				 = МетаданныеОбъекта.Имя;
	ЭтотОбъект.АналитикаОтбора			 = АналитикаОтобраВход;
	ЭтотОбъект.ВариантЗаполненияШаблона	 = ВариантЗаполненияРабочий;
	// Назначение шаблона.
	Если ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта) Тогда
		НазначениеШаблона = Перечисления.НазначенияШаблонов.Документ;
	ИначеЕсли ОбщегоНазначения.ЭтоСправочник(МетаданныеОбъекта) Тогда	
		НазначениеШаблона = Перечисления.НазначенияШаблонов.Справочник;
	Иначе
		НазначениеШаблона = Перечисления.НазначенияШаблонов.ПустаяСсылка();
	КонецЕсли;
	ЭтотОбъект.Назначение = НазначениеШаблона;	
	// Заполним реквизиты объекта.
	ТаблицаРеквизитов = УправлениеШаблонамиЗаполненияУХ.ПолучитьТаблицуРеквизитовОбъекта(ОбъектРодитель);
	ЕстьСписокРеквизитов = (СписокРеквизитовВход <> Неопределено);
	Для Каждого ТекТаблицаРеквизитов Из ТаблицаРеквизитов Цикл
		МожноДобавлять = Истина;
		Если ЕстьСписокРеквизитов Тогда
			МожноДобавлять = (СписокРеквизитовВход.НайтиПоЗначению(ТекТаблицаРеквизитов.НаименованиеРеквизита) <> Неопределено);
		Иначе
			МожноДобавлять = Истина;  // Списка нет. Заполняем все реквизиты.
		КонецЕсли;
		Если МожноДобавлять Тогда
			НоваяСтрокаРеквизиты = РеквизитыШаблона.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаРеквизиты, ТекТаблицаРеквизитов);
		Иначе
			Продолжить;	
		КонецЕсли;
	КонецЦикла;
	// Заполним табличные части.
	ТаблицаТабличныхЧастей = УправлениеШаблонамиЗаполненияУХ.ПолучитьТаблицуТабличныхЧастейОбъекта(ОбъектРодитель);
	ЕстьСписокТабличныхЧастей = (СписокТабличныхЧастейВход <> Неопределено);
	Для Каждого ТекТаблицаТабличныхЧастей Из ТаблицаТабличныхЧастей Цикл
		Если ЕстьСписокТабличныхЧастей Тогда
			МожноДобавлять = (СписокТабличныхЧастейВход.НайтиПоЗначению(ТекТаблицаТабличныхЧастей.ТабличнаяЧасть) <> Неопределено);	
		Иначе
			МожноДобавлять = Истина;
			// Списка нет. Добавляем все табличные части.
		КонецЕсли;
		Если МожноДобавлять Тогда
			НоваяСтрокаРеквизиты = РеквизитыШаблона.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаРеквизиты, ТекТаблицаТабличныхЧастей);
		Иначе
			Продолжить;	
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Наименование = Справочники.ШаблоныЗаполнения.ПолучитьНаименованиеШаблонаПоУмолчанию(ОбъектРодитель);
КонецПроцедуры

#КонецЕсли

