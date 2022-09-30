#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияГИСМПереопределяемый.ОбработкаЗаполненияУведомленияОВвозеИзЕАЭСГИСМ(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоНовый() И ЗначениеЗаполнено(Основание) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	СтатусыИнформированияГИСМ.ТекущееУведомление
		|ИЗ
		|	РегистрСведений.СтатусыИнформированияГИСМ КАК СтатусыИнформированияГИСМ
		|ГДЕ
		|	СтатусыИнформированияГИСМ.Документ = &Основание
		|	И НЕ СтатусыИнформированияГИСМ.Статус В (
		|		ЗНАЧЕНИЕ(Перечисление.СтатусыИнформированияГИСМ.ОтклоненоГИСМ)
		|		)
		|	И НЕ СтатусыИнформированияГИСМ.ТекущееУведомление = ЗНАЧЕНИЕ(Документ.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.ПустаяСсылка)
		|	И  СтатусыИнформированияГИСМ.ТекущееУведомление <> НЕОПРЕДЕЛЕНО ";
		
		Запрос.УстановитьПараметр("Основание", Основание);
		
		Результат = Запрос.Выполнить();
		
		Если Не Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			
			ТекстОшибки = НСтр("ru = 'Для документа %1 уже существует текущая %2.';
								|en = 'Для документа %1 уже существует текущая %2.'");
				ТекстОшибки =  СтрШаблон(ТекстОшибки, Основание, Выборка.ТекущееУведомление);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					,
					,
					Отказ);
			
				КонецЕсли;
				
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	НомераКиЗ.Очистить();
	Основание = Неопределено;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		ДополнительныеСвойства.Вставить("ЗаписьНового", Истина);
	КонецЕсли;
	
	ИнтеграцияИСПереопределяемый.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли