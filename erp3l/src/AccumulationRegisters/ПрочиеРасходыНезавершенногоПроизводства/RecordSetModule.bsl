#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		Или РасчетСебестоимостиПрикладныеАлгоритмы.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ РасчетСебестоимостиПрикладныеАлгоритмы.ФормироватьДвиженияРегистровУчетаСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	РасчетСебестоимостиПрикладныеАлгоритмы.СохранитьДвиженияСформированныеРасчетомПартийИСебестоимости(ЭтотОбъект, Замещение);
	
	Если Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства)
		Или ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Затраты.Период,
	|	Затраты.Регистратор,
	|	Затраты.Организация,
	|	Затраты.ЗаказНаПроизводство,
	|	Затраты.КодСтрокиПродукция,
	|	Затраты.Этап,
	|	Затраты.СтатьяКалькуляции,
	|	Затраты.СтатьяРасходов,
	|	Затраты.АналитикаРасходов,
	|	Затраты.ГруппаПродукции,
	|
	|	Затраты.Стоимость,
	|	Затраты.СтоимостьБезНДС,
	|	Затраты.СтоимостьРегл,
	|	Затраты.ПостояннаяРазница,
	|	Затраты.ВременнаяРазница,
	|	Затраты.ДоляСтоимости
	|ПОМЕСТИТЬ ПрочиеРасходыНезавершенногоПроизводстваПередЗаписью
	|ИЗ
	|	РегистрНакопления.ПрочиеРасходыНезавершенногоПроизводства КАК Затраты
	|ГДЕ
	|	Затраты.Регистратор = &Регистратор
	|");
	
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства)
		Или ПланыОбмена.ГлавныйУзел() <> Неопределено
		Или РасчетСебестоимостиПрикладныеАлгоритмы.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ РасчетСебестоимостиПрикладныеАлгоритмы.ФормироватьДвиженияРегистровУчетаСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	Таблица.Период КАК Период,
	|	Таблица.Регистратор КАК Регистратор,
	|	Таблица.Организация КАК Организация,
	|	Таблица.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	Таблица.КодСтрокиПродукция КАК КодСтрокиПродукция,
	|	Таблица.Этап КАК Этап,
	|	Таблица.СтатьяКалькуляции КАК СтатьяКалькуляции,
	|	Таблица.СтатьяРасходов КАК СтатьяРасходов,
	|	Таблица.АналитикаРасходов КАК АналитикаРасходов,
	|	Таблица.ГруппаПродукции КАК ГруппаПродукции,
	|	СУММА(Таблица.Стоимость) КАК СтоимостьИзменение,
	|	СУММА(Таблица.СтоимостьБезНДС) КАК СтоимостьБезНДСИзменение,
	|	СУММА(Таблица.СтоимостьРегл) КАК СтоимостьРеглИзменение,
	|	СУММА(Таблица.ПостояннаяРазница) КАК ПостояннаяРазницаИзменение,
	|	СУММА(Таблица.ВременнаяРазница) КАК ВременнаяРазницаИзменение,
	|	СУММА(Таблица.ДоляСтоимости) КАК ДоляСтоимостиИзменение
	|ПОМЕСТИТЬ ТаблицаИзмененийПрочиеРасходыНезавершенногоПроизводства
	|ИЗ
	|	(ВЫБРАТЬ
	|		Затраты.Период,
	|		Затраты.Регистратор,
	|		Затраты.Организация,
	|		Затраты.ЗаказНаПроизводство,
	|		Затраты.КодСтрокиПродукция,
	|		Затраты.Этап,
	|		Затраты.СтатьяКалькуляции,
	|		Затраты.СтатьяРасходов,
	|		Затраты.АналитикаРасходов,
	|		Затраты.ГруппаПродукции,
	|		Затраты.Стоимость,
	|		Затраты.СтоимостьБезНДС,
	|		Затраты.СтоимостьРегл,
	|		Затраты.ПостояннаяРазница,
	|		Затраты.ВременнаяРазница,
	|		Затраты.ДоляСтоимости
	|	ИЗ
	|		ПрочиеРасходыНезавершенногоПроизводстваПередЗаписью КАК Затраты
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Затраты.Период,
	|		Затраты.Регистратор,
	|		Затраты.Организация,
	|		Затраты.ЗаказНаПроизводство,
	|		Затраты.КодСтрокиПродукция,
	|		Затраты.Этап,
	|		Затраты.СтатьяКалькуляции,
	|		Затраты.СтатьяРасходов,
	|		Затраты.АналитикаРасходов,
	|		Затраты.ГруппаПродукции,
	|		-Затраты.Стоимость,
	|		-Затраты.СтоимостьБезНДС,
	|		-Затраты.СтоимостьРегл,
	|		-Затраты.ПостояннаяРазница,
	|		-Затраты.ВременнаяРазница,
	|		-Затраты.ДоляСтоимости
	|	ИЗ
	|		РегистрНакопления.ПрочиеРасходыНезавершенногоПроизводства КАК Затраты
	|	ГДЕ
	|		Затраты.Регистратор = &Регистратор) КАК Таблица
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.Организация,
	|	Таблица.ЗаказНаПроизводство,
	|	Таблица.КодСтрокиПродукция,
	|	Таблица.Этап,
	|	Таблица.СтатьяКалькуляции,
	|	Таблица.СтатьяРасходов,
	|	Таблица.АналитикаРасходов,
	|	Таблица.ГруппаПродукции
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Стоимость) <> 0
	|	ИЛИ СУММА(Таблица.СтоимостьБезНДС) <> 0
	|	ИЛИ СУММА(Таблица.СтоимостьРегл) <> 0
	|	ИЛИ СУММА(Таблица.ПостояннаяРазница) <> 0
	|	ИЛИ СУММА(Таблица.ВременнаяРазница) <> 0
	|	ИЛИ СУММА(Таблица.ДоляСтоимости) <> 0
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ПрочиеРасходыНезавершенногоПроизводстваПередЗаписью");
	
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ТипЗнч(ЭтотОбъект.Отбор.Регистратор) = Тип("ДокументСсылка.ЗаказПереработчику") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КодСтрокиПродукция");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
