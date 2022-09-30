#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	УстановитьЗаголовкиДекораций();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)

	Закрыть(Истина);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИспользованиеОбъекта(Команда)
	
	ЗапретРедактированияРеквизитовОбъектовУТКлиент.ПроверитьИспользованиеОбъекта(
		ЭтаФорма,
		ПараметрыОбработчикаОжидания,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура УстановитьЗаголовкиДекораций()
	
	ИспользуетсяПроизводство21 = ПроизводствоСервер.ИспользуетсяПроизводство21();
	ИспользуетсяПроизводство22 = ПроизводствоСервер.ИспользуетсяПроизводство22();
	
	// ПояснениеИзделияМатериалыТрудозатраты
	Если ИспользуетсяПроизводство22 И ИспользуетсяПроизводство21 Тогда
		ТекстЗаголовка = НСтр("ru = 'Ресурсные спецификации, маршрутные листы и этапы производства станут некорректными.';
								|en = 'Bills of materials, operation sheets, and production stages will become invalid.'");
	ИначеЕсли ИспользуетсяПроизводство22 Тогда
		ТекстЗаголовка = НСтр("ru = 'Ресурсные спецификации и этапы производства станут некорректными.';
								|en = 'Bills of materials and production stages will be incorrect.'");
	Иначе
		ТекстЗаголовка = НСтр("ru = 'Ресурсные спецификации и маршрутные листы станут некорректными.';
								|en = 'Bills of materials and operation sheets will become invalid.'");
	КонецЕсли;
	Элементы.ПояснениеИзделияМатериалыТрудозатраты.Заголовок = ТекстЗаголовка;
	
	// ПояснениеОперации
	Если ИспользуетсяПроизводство22 И ИспользуетсяПроизводство21 Тогда
		ТекстЗаголовка = НСтр("ru = 'Маршрутные листы и этапы производства станут некорректными.';
								|en = 'Operation sheets and production stages will become invalid.'");
	ИначеЕсли ИспользуетсяПроизводство22 Тогда
		ТекстЗаголовка = НСтр("ru = 'Этапы производства станут некорректными.';
								|en = 'Production stages will be incorrect.'");
	Иначе
		ТекстЗаголовка = НСтр("ru = 'Маршрутные листы станут некорректными.';
								|en = 'Operation sheets will become invalid.'");
	КонецЕсли;
	Элементы.ПояснениеОперации.Заголовок = ТекстЗаголовка;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	ЗапретРедактированияРеквизитовОбъектовУТКлиент.ПроверитьВыполнениеЗадания(
		ЭтаФорма,
		ФормаДлительнойОперации,
		ПараметрыОбработчикаОжидания);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
