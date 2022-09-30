#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ РасчетСебестоимостиПрикладныеАлгоритмы.ФормироватьДвиженияРегистровУчетаСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства)
		Или ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ПартионныйУчетВключен",
		РасчетСебестоимостиПовтИсп.ПартионныйУчетВключен(
			НачалоМесяца(ДополнительныеСвойства.ДатаРегистратора)));
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Партии.Период                     КАК Период,
	|	Партии.Регистратор                КАК Регистратор,
	|	Партии.Организация                КАК Организация,
	|	Партии.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Партии.ДокументПоступления        КАК ДокументПоступления,
	|	Партии.ВидЗапасов                 КАК ВидЗапасов,
	|	Партии.АналитикаУчетаПартий       КАК АналитикаУчетаПартий,
	|	Партии.ДокументПередачиНаКомиссию КАК ДокументПередачиНаКомиссию,
	|
	|	Партии.Количество        КАК Количество,
	|	Партии.Стоимость         КАК Стоимость,
	|	Партии.СтоимостьБезНДС   КАК СтоимостьБезНДС,
	|	Партии.СтоимостьРегл     КАК СтоимостьРегл,
	|	Партии.НДСРегл           КАК НДСРегл,
	|	Партии.ПостояннаяРазница КАК ПостояннаяРазница,
	|	Партии.ВременнаяРазница  КАК ВременнаяРазница,
	|
	|	Партии.Номенклатура                  КАК Номенклатура,
	|	Партии.Характеристика                КАК Характеристика,
	|	Партии.НалогообложениеНДС            КАК НалогообложениеНДС,
	|	Партии.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|	Партии.КорАналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры
	|ПОМЕСТИТЬ ПартииПередЗаписью
	|ИЗ
	|	РегистрНакопления.ПартииТоваровПереданныеНаКомиссию КАК Партии
	|ГДЕ
	|	Партии.Регистратор = &Регистратор
	|	И &ПартионныйУчетВключен
	|");
	
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ПартионныйУчетВключен", ДополнительныеСвойства.ПартионныйУчетВключен);
	
	Запрос.Выполнить();

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства)
		Или ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ РасчетСебестоимостиПрикладныеАлгоритмы.ФормироватьДвиженияРегистровУчетаСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	Таблица.Период КАК Период,
	|	Таблица.Регистратор КАК Регистратор,
	|	Таблица.Организация КАК Организация,
	|	Таблица.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Таблица.ДокументПоступления КАК ДокументПоступления,
	|	Таблица.ВидЗапасов КАК ВидЗапасов,
	|	Таблица.АналитикаУчетаПартий КАК АналитикаУчетаПартий,
	|	Таблица.ДокументПередачиНаКомиссию КАК ДокументПередачиНаКомиссию,
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	Таблица.НалогообложениеНДС КАК НалогообложениеНДС,
	|	Таблица.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	Таблица.КорАналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры,
	|	СУММА(Таблица.Количество) КАК КоличествоИзменение,
	|	СУММА(Таблица.Стоимость) КАК СтоимостьИзменение,
	|	СУММА(Таблица.СтоимостьБезНДС) КАК СтоимостьБезНДСИзменение,
	|	СУММА(Таблица.СтоимостьРегл) КАК СтоимостьРеглИзменение,
	|	СУММА(Таблица.НДСРегл) КАК НДСРеглИзменение,
	|	СУММА(Таблица.ПостояннаяРазница) КАК ПостояннаяРазницаИзменение,
	|	СУММА(Таблица.ВременнаяРазница) КАК ВременнаяРазницаИзменение
	|ПОМЕСТИТЬ ТаблицаИзмененийПартииТоваровПереданныеНаКомиссию
	|ИЗ
	|	(ВЫБРАТЬ
	|		Партии.Период КАК Период,
	|		Партии.Регистратор КАК Регистратор,
	|		Партии.Организация КАК Организация,
	|		Партии.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		Партии.ДокументПоступления КАК ДокументПоступления,
	|		Партии.ВидЗапасов КАК ВидЗапасов,
	|		Партии.АналитикаУчетаПартий КАК АналитикаУчетаПартий,
	|		Партии.ДокументПередачиНаКомиссию КАК ДокументПередачиНаКомиссию,
	|		Партии.Количество КАК Количество,
	|		Партии.Стоимость КАК Стоимость,
	|		Партии.СтоимостьБезНДС КАК СтоимостьБезНДС,
	|		Партии.СтоимостьРегл КАК СтоимостьРегл,
	|		Партии.НДСРегл КАК НДСРегл,
	|		Партии.ПостояннаяРазница КАК ПостояннаяРазница,
	|		Партии.ВременнаяРазница КАК ВременнаяРазница,
	|		Партии.Номенклатура КАК Номенклатура,
	|		Партии.Характеристика КАК Характеристика,
	|		Партии.НалогообложениеНДС КАК НалогообложениеНДС,
	|		Партии.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|		Партии.КорАналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры
	|	ИЗ
	|		ПартииПередЗаписью КАК Партии
	|	ГДЕ
	|		&ПартионныйУчетВключен
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Партии.Период КАК Период,
	|		Партии.Регистратор КАК Регистратор,
	|		Партии.Организация КАК Организация,
	|		Партии.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		Партии.ДокументПоступления КАК ДокументПоступления,
	|		Партии.ВидЗапасов КАК ВидЗапасов,
	|		Партии.АналитикаУчетаПартий КАК АналитикаУчетаПартий,
	|		Партии.ДокументПередачиНаКомиссию КАК ДокументПередачиНаКомиссию,
	|		-Партии.Количество КАК Количество,
	|		-Партии.Стоимость КАК Стоимость,
	|		-Партии.СтоимостьБезНДС КАК СтоимостьБезНДС,
	|		-Партии.СтоимостьРегл КАК СтоимостьРегл,
	|		-Партии.НДСРегл КАК НДСРегл,
	|		-Партии.ПостояннаяРазница КАК ПостояннаяРазница,
	|		-Партии.ВременнаяРазница КАК ВременнаяРазница,
	|		Партии.Номенклатура КАК Номенклатура,
	|		Партии.Характеристика КАК Характеристика,
	|		Партии.НалогообложениеНДС КАК НалогообложениеНДС,
	|		Партии.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|		Партии.КорАналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры
	|	ИЗ
	|		РегистрНакопления.ПартииТоваровПереданныеНаКомиссию КАК Партии
	|	ГДЕ
	|		Партии.Регистратор = &Регистратор
	|		И &ПартионныйУчетВключен) КАК Таблица
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.Организация,
	|	Таблица.АналитикаУчетаНоменклатуры,
	|	Таблица.ДокументПоступления,
	|	Таблица.ВидЗапасов,
	|	Таблица.АналитикаУчетаПартий,
	|	Таблица.ДокументПередачиНаКомиссию,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	Таблица.НалогообложениеНДС,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.КорАналитикаУчетаНоменклатуры
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Количество) <> 0
	|	ИЛИ СУММА(Таблица.Стоимость) <> 0
	|	ИЛИ СУММА(Таблица.СтоимостьБезНДС) <> 0
	|	ИЛИ СУММА(Таблица.СтоимостьРегл) <> 0
	|	ИЛИ СУММА(Таблица.НДСРегл) <> 0
	|	ИЛИ СУММА(Таблица.ПостояннаяРазница) <> 0
	|	ИЛИ СУММА(Таблица.ВременнаяРазница) <> 0
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ПартииПередЗаписью");
	
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ПартионныйУчетВключен", ДополнительныеСвойства.ПартионныйУчетВключен);
	
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
