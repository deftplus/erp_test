#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	АдресВоВременномХранилище = Параметры.АдресВоВременномХранилище;
	
	ПолучитьСчетаФактурыКомиссионеруКОформлению(Параметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		ВыполняетсяЗакрытие = Истина;
		ТекстПредупреждения = НСтр("ru = 'Данные не были перенесены в счет-фактуру. После закрытия, сделанные Вами изменения сохранены не будут.';
									|en = 'Data was not moved to tax invoice. Changes made by you will not be saved after closing.'");
	КонецЕсли;
		
	Если НЕ ВыполняетсяЗакрытие И Модифицированность Тогда
		Отказ = Истина;
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ОбработчикОповещенияВопросПередЗакрытием", ЭтотОбъект), 
			НСтр("ru = 'Данные были изменены. Перенести изменения в документ?';
				|en = 'The data was modified. Migrate the changes to the document?'"), 
			РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент()

	ПеренестиВДокументВыполнить();

КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьПометки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьПометки(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработчикОповещенияВопросПередЗакрытием(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОчиститьСообщения();
		Отказ = Ложь;
		Модифицированность = Ложь;
		Закрыть(ПоместитьВоВременноеХранилищеСервер());
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометки(Значение)
	
	Для каждого Строка Из СчетаФактурыКомиссионеруКОформлению Цикл
		Строка.Пометка = Значение;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСчетаФактурыКомиссионеруКОформлению(Параметры)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Покупатели.Покупатель КАК Покупатель,
	|	Покупатели.НомерСчетаФактуры КАК НомерСчетаФактуры,
	|	ИСТИНА КАК Пометка
	|ПОМЕСТИТЬ Покупатели
	|ИЗ
	|	&Покупатели КАК Покупатели
	|;
	|
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Покупатель,
	|	ВложенныйЗапрос.НомерСчетаФактуры,
	|	МАКСИМУМ(ВложенныйЗапрос.Пометка) КАК Пометка
	|ИЗ
	|	(ВЫБРАТЬ
	|		КОформлению.Покупатель КАК Покупатель,
	|		КОформлению.НомерСчетаФактуры КАК НомерСчетаФактуры,
	|		ЛОЖЬ КАК Пометка
	|	ИЗ
	|		РегистрСведений.СчетаФактурыКомиссионерамКОформлению КАК КОформлению
	|	ГДЕ
	|		КОформлению.ОтчетКомиссионера = &ОтчетКомиссионера
	|		И НАЧАЛОПЕРИОДА(КОформлению.ДатаСчетаФактуры, ДЕНЬ) = &Дата
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Покупатели.Покупатель КАК Покупатель,
	|		Покупатели.НомерСчетаФактуры КАК НомерСчетаФактуры,
	|		ИСТИНА КАК Пометка
	|	ИЗ
	|		Покупатели КАК Покупатели) КАК ВложенныйЗапрос
	|	
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Покупатель,
	|	ВложенныйЗапрос.НомерСчетаФактуры
	|";
	Запрос.УстановитьПараметр("Покупатели",        ПолучитьИзВременногоХранилища(Параметры.АдресВоВременномХранилище));
	Запрос.УстановитьПараметр("Дата",              НачалоДня(Параметры.Дата));
	Запрос.УстановитьПараметр("ОтчетКомиссионера", Параметры.ОтчетКомиссионера);
	
	СчетаФактурыКомиссионеруКОформлению.Загрузить(Запрос.Выполнить().Выгрузить())
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()
	
	// Снятие модифицированности, т.к. перед закрытием признак проверяется.
	Модифицированность = Ложь;
	Закрыть(ПоместитьВоВременноеХранилищеСервер());
	
КонецПроцедуры

&НаСервере
Функция ПоместитьВоВременноеХранилищеСервер()
	
	Возврат ПоместитьВоВременноеХранилище(
				СчетаФактурыКомиссионеруКОформлению.Выгрузить(),
				АдресВоВременномХранилище);
	
КонецФункции

#КонецОбласти

#Область Инициализация

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти
