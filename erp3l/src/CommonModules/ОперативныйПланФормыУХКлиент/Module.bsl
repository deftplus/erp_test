
#Область ПрограммныйИнтерфейс

Процедура ОбщийОбработчикНачалаВыбораАналитик(Элемент, ДанныеВыбора, СтандартнаяОбработка, ОписаниеКТ, Форма) экспорт
	
	Если СтрНайти(Элемент.Имя, "ЕдиницаИзмерения") > 0 Тогда
		
		НачалоВыбора_ЕдиницаИзмерения(Элемент, ДанныеВыбора, СтандартнаяОбработка, ОписаниеКТ, Форма);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура удаляет помеченные строки кросс-таблицы
Процедура УдалитьОтмеченныеСтрокиКТ(ОписаниеКТ, Форма) экспорт
	
	ЭлементКроссТаблица = Форма.Элементы[ОписаниеКТ.Элементы.КроссТаблица];
	
	ДанныеКТ = Форма[ОписаниеКТ.Реквизиты.КроссТаблица];
	АктивныеПериоды = КроссТаблицыУХКлиентСервер.ПолучитьАктивныеПериоды(ОписаниеКТ, Форма);
	
	МассивСтрокКУдалению = Новый Массив;
	
	// Удаляем строки
	Для каждого ИдентификаторСтроки Из ЭлементКроссТаблица.ВыделенныеСтроки Цикл
		
		//
		СтрокаКТ = ДанныеКТ.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если СтрокаКТ = неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если ОписаниеКТ.ЗапрещеноУдалятьСтрокиКТ И ВСтрокеЕстьИсходныеЗначения(ОписаниеКТ, АктивныеПериоды, СтрокаКТ) Тогда
			Продолжить;
		КонецЕсли;
		
		//
		МассивСтрокКУдалению.Добавить(СтрокаКТ);
		
	КонецЦикла; 
	
	Для каждого СтрокаКТ Из МассивСтрокКУдалению Цикл
		ДанныеКТ.Удалить(СтрокаКТ);
	КонецЦикла; 
	
КонецПроцедуры

// Процедура проверяет возможность удаления строки расшифровки и в случае невозможности устанавливает Отказ = Истина
Процедура ПроверитьВозможностьУдаленияСтрокиРасшифровки(ОписаниеКТ, Форма, СтрокаРасшифровки, Отказ) экспорт
	
	Если СтрокаРасшифровки = неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ОписаниеКТ.Схема.Показатели.Свойство("Исходное") Тогда
		Возврат ;
	КонецЕсли;
	
	ОписаниеПоказателя = ОписаниеКТ.Схема.Показатели.Исходное;
	
	//
	МассивПрефиксов = Новый Массив;
	Для Каждого КлючЗначение Из ОписаниеКТ.Схема.Поля Цикл
		
		ОписаниеПоля = КлючЗначение.Значение;
		Если ОписаниеПоля.ИмяПоказателя <> ОписаниеПоказателя.Имя Тогда
			Продолжить;
		КонецЕсли;
		
		МассивПрефиксов.Добавить(ОписаниеПоля.ИмяРеквизитаТЧ);
		
	КонецЦикла;
	
	//
	Для Каждого ПрефиксРеквизитаКолонки Из МассивПрефиксов Цикл
		Если ЗначениеЗаполнено(СтрокаРасшифровки[ПрефиксРеквизитаКолонки]) Тогда
			Отказ = Истина;
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//
Процедура НачалоВыбора_ЕдиницаИзмерения(Элемент, ДанныеВыбора, СтандартнаяОбработка, ОписаниеКТ, Форма)
	
	СтандартнаяОбработка = Ложь;
	
	Аналитики = ОписаниеКТ.Схема.Аналитики;
	ИмяАналитики = "Номенклатура";
	Если Аналитики.мШапка.Найти(ИмяАналитики) <> неопределено Тогда
		ТекДанные = Форма.Объект;
		Форма.СтарыйКоэффициент = ТекДанные.Коэффициент;
	ИначеЕсли Аналитики.мСтрока.Найти(ИмяАналитики) <> неопределено Тогда
		ТекДанные = Форма.Элементы[ОписаниеКТ.Элементы.КроссТаблица].ТекущиеДанные;
		ТекДанные.СтарыйКоэффициент = ТекДанные.Коэффициент;
	ИначеЕсли Аналитики.мРасшифровка.Найти(ИмяАналитики) <> неопределено Тогда
		ТекДанные = Форма.Элементы[ОписаниеКТ.Элементы.КроссТаблица].ТекущиеДанные;
		ТекДанные.СтарыйКоэффициент = ТекДанные.Коэффициент;
	КонецЕсли;
	
	ВстраиваниеОПККлиентПереопределяемый.ОбработчикЕдиницаИзмеренияНачалоВыбора(ТекДанные, ДанныеВыбора);
	
КонецПроцедуры

// Функция определяет наличие заполненных исходных значений ресурсов
Функция ВСтрокеЕстьИсходныеЗначения(ОписаниеКТ, АктивныеПериоды, СтрокаКТ)
	
	Если НЕ ОписаниеКТ.Схема.Показатели.Свойство("Исходное") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ОписаниеПоказателя = ОписаниеКТ.Схема.Показатели.Исходное;
	
	//
	МассивПрефиксов = Новый Массив;
	Для Каждого КлючЗначение Из ОписаниеКТ.Схема.Поля Цикл
		
		ОписаниеПоля = КлючЗначение.Значение;
		Если ОписаниеПоля.ИмяПоказателя <> ОписаниеПоказателя.Имя Тогда
			Продолжить;
		КонецЕсли;
		
		МассивПрефиксов.Добавить(ОписаниеПоля.ПрефиксРеквизитаКолонки);
		
	КонецЦикла;
	
	//
	Результат = Ложь;
	Для каждого Период Из АктивныеПериоды Цикл
		
		Для Каждого ПрефиксРеквизитаКолонки Из МассивПрефиксов Цикл
			
			Результат = Результат ИЛИ ЗначениеЗаполнено(СтрокаКТ[ПрефиксРеквизитаКолонки + Период.ИмяКолонки]);
			Если Результат Тогда
				Прервать;
			КонецЕсли; 
			
		КонецЦикла;
		
		Если Результат Тогда
			Прервать;
		КонецЕсли; 
		
	КонецЦикла; 
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти


