#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Отказ ИЛИ ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ВидУчетаЗаполнен = Ложь;
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		
		МассивВидовУчетаДляУдаления = Новый Массив;
		
		ВидыУчета = Новый Массив;
		ВидыУчета.Добавить("Расходы");
		ВидыУчета.Добавить("Доходы");
	
		Для каждого ВидУчета Из ВидыУчета Цикл
			ИспользоватьВидУчета = Ложь;
			Если ДанныеЗаполнения.Свойство(ВидУчета, ИспользоватьВидУчета) Тогда
				Если ИспользоватьВидУчета Тогда
					ВидУчетаЗаполнен = Истина;
					Прервать;
				Иначе
					МассивВидовУчетаДляУдаления.Добавить(ВидУчета);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если МассивВидовУчетаДляУдаления.Количество() Тогда
			ДоступныеВидыУчета = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ВидыУчета, МассивВидовУчетаДляУдаления);
			Если ДоступныеВидыУчета.Количество() Тогда
				ЭтотОбъект[ДоступныеВидыУчета.Получить(0)] = Истина;
				ВидУчетаЗаполнен = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЭтоГруппа И НЕ ВидУчетаЗаполнен Тогда
		Расходы = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли