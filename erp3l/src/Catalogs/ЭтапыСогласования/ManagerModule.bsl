
Процедура ОбновитьЭтапыПредшественники(Ссылка, АдресТабличноеПолеПереходов) Экспорт
	
	Если ЭтоАдресВременногоХранилища(АдресТабличноеПолеПереходов) Тогда
		ТабличноеПолеПерехода = ПолучитьИзВременногоХранилища(АдресТабличноеПолеПереходов);
	Иначе
		Возврат;
	КонецЕсли;
	
	Запрос = Новый ЗАпрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ Ссылка ИЗ Справочник.ЭтапыСогласования.ЭтапыПредшественники
	|ГДЕ Этап = &Этап";
	Запрос.УстановитьПараметр("Этап", Ссылка);
	ТаблицаПоказателей = Запрос.Выполнить().Выгрузить();
	
	МассивЭтаповПоследователей = Новый Массив;
	
	ВернутьРекурсивноВсеСсылкиНаЭтапы(МассивЭтаповПоследователей, ТабличноеПолеПерехода.Строки);
	
	Для Каждого Строка ИЗ ТаблицаПоказателей Цикл
		ЗаписьМассива = МассивЭтаповПоследователей.Найти(Строка.Ссылка);
		Если ЗаписьМассива = Неопределено Тогда
			ТекОбъект = Строка.Ссылка.ПолучитьОбъект();
			УдаляемыеСтроки = ТекОбъект.ЭтапыПредшественники.НайтиСтроки(Новый Структура("Этап", Ссылка));
			Для Каждого Строка Из УдаляемыеСтроки Цикл
				ТекОбъект.ЭтапыПредшественники.Удалить(Строка);
			КонецЦикла;
			ТекОбъект.ОповещатьОбИзменении = Ложь;
			ТекОбъект.Записать();
		Иначе
			МассивЭтаповПоследователей.Удалить(ЗаписьМассива);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Элемент Из МассивЭтаповПоследователей Цикл
		ТекОбъект = Элемент.ПолучитьОбъект();
		ТекОБъект.ЭтапыПредшественники.Добавить().Этап = Ссылка;
		ТекОбъект.ОповещатьОбИзменении = Ложь;
		ТекОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

Процедура ВернутьРекурсивноВсеСсылкиНаЭтапы(Массив, Строки)
	
	Для Каждого Строка ИЗ Строки Цикл
		Если НЕ Строка.ЯвляетсяУсловием Тогда
			Если Строка.УсловиеДействие = Перечисления.ДействияЭтапа.ПерейтиКЭтапу Тогда
				Если ЗначениеЗаполнено(Строка.Значение) Тогда
					Если Массив.Найти(Строка.Значение) = Неопределено Тогда
						Массив.Добавить(Строка.Значение);
					КонеЦЕсли;
				КонецЕсли;
			КонецЕсли;
		Иначе
			Для Каждого Строка_Условия Из Строка.Строки Цикл
				ВернутьРекурсивноВсеСсылкиНаЭтапы(Массив, Строка_Условия.Строки);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
