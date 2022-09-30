
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = Параметры.ТекстСообщения;
	
	МассивДанных = Новый Массив;
	ДанныеДляЖурналаРегистрации = Параметры.ДанныеДляЖурналаРегистрации;
	Если ТипЗнч(ДанныеДляЖурналаРегистрации) = Тип("Структура") Тогда
		Для Каждого КлючИЗначение Из ДанныеДляЖурналаРегистрации Цикл
			МассивДанных.Добавить(Строка(КлючИЗначение.Ключ) + "=" + Строка(КлючИЗначение.Значение));
		КонецЦикла;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Розничные продажи';
			|en = 'Retail sales'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,,
		Параметры.Данные,
		ТекстСообщения + " " + НСтр("ru = 'Данные';
									|en = 'Data'")+ ":" + СтрСоединить(МассивДанных, ","));
	
КонецПроцедуры
