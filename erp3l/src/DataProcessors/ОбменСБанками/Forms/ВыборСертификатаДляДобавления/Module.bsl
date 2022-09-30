#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДанныеВыбораСсылка = ПоместитьВоВременноеХранилище(Параметры.ДанныеВыбора, УникальныйИдентификатор);
	
	Элементы.СтраницыСертификата.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	Для Каждого КлючЗначение Из Параметры.ДанныеВыбора Цикл
		Элементы.Сертификат.СписокВыбора.Добавить(КлючЗначение.Ключ, КлючЗначение.Значение.Псевдоним);
	КонецЦикла;
	
	Элементы.Сертификат.СписокВыбора.СортироватьПоПредставлению();
	
	Если Параметры.ДанныеВыбора.Количество() = 1 Тогда
		Для Каждого КлючЗначение Из Параметры.ДанныеВыбора Цикл
			Элементы.ПарольОдин.АктивизироватьПоУмолчанию = Истина;
			Элементы.СтраницыСертификата.ТекущаяСтраница = Элементы.ОдинСертификат;
			Сертификат = КлючЗначение.Ключ;
			ПредставлениеСертификата = КлючЗначение.Значение.Псевдоним;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СертификатПриИзменении(Элемент)
	
	ДанныеСертификатов = ПолучитьИзВременногоХранилища(ДанныеВыбораСсылка);
	СтруктураСертификата = ДанныеСертификатов.Получить(Сертификат);
	Элементы.ПарольНесколько.Доступность = СтруктураСертификата.ТребуетсяПароль;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Ок(Команда)
	
	Если Не ЗначениеЗаполнено(Сертификат) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Выберите ключ';
														|en = 'Select a key'"), , "Сертификат");
		Возврат;
	КонецЕсли;
	ДанныеСертификата = ПолучитьИзВременногоХранилища(ДанныеВыбораСсылка);
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Отпечаток", Сертификат);
	СтруктураСертификата = ДанныеСертификата.Получить(Сертификат);
	СтруктураВозврата.Вставить("СертификатBase64", СтруктураСертификата.СертификатBase64);
	СтруктураВозврата.Вставить("Пароль", Пароль);
	СтруктураВозврата.Вставить("ТребуетсяПароль", СтруктураСертификата.ТребуетсяПароль);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

#КонецОбласти
