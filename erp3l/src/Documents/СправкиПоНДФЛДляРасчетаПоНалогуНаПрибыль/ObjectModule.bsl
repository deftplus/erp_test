#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	НалоговыйПериодДата = Дата(?(НалоговыйПериод <= 0, 1, НалоговыйПериод), 12, 31);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьЗапросПоСтрокамДокументаДляПроверки(Сотрудники)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаСотрудников", Сотрудники);
	Запрос.УстановитьПараметр("НалоговыйПериод", НалоговыйПериод);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.НомерСтроки,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.Сотрудник,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИНН,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.НомерСправки,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.Ставка,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.Фамилия,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.Имя,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.Отчество,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.Адрес,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ВидДокумента,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.СерияДокумента,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.НомерДокумента,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.Гражданство,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ДатаРождения,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.СтатусНалогоплательщика,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.АдресЗарубежом,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОбщаяСуммаДоходаПоСтавке13,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОблагаемаяСуммаДоходаПоСтавке13,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИсчисленоПоСтавке13,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.УдержаноПоСтавке13,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ЗадолженностьПоСтавке13,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИзлишнеУдержаноПоСтавке13,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ПеречисленоПоСтавке13,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОбщаяСуммаДоходаПоСтавке30,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОблагаемаяСуммаДоходаПоСтавке30,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИсчисленоПоСтавке30,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.УдержаноПоСтавке30,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ЗадолженностьПоСтавке30,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИзлишнеУдержаноПоСтавке30,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ПеречисленоПоСтавке30,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОбщаяСуммаДоходаПоСтавке9,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОблагаемаяСуммаДоходаПоСтавке9,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИсчисленоПоСтавке9,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.УдержаноПоСтавке9,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ЗадолженностьПоСтавке9,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИзлишнеУдержаноПоСтавке9,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ПеречисленоПоСтавке9,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОбщаяСуммаДоходаПоСтавке15,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОблагаемаяСуммаДоходаПоСтавке15,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИсчисленоПоСтавке15,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.УдержаноПоСтавке15,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ЗадолженностьПоСтавке15,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИзлишнеУдержаноПоСтавке15,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ПеречисленоПоСтавке15,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОбщаяСуммаДоходаПоСтавке35,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОблагаемаяСуммаДоходаПоСтавке35,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИсчисленоПоСтавке35,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.УдержаноПоСтавке35,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ЗадолженностьПоСтавке35,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИзлишнеУдержаноПоСтавке35,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ПеречисленоПоСтавке35,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОбщаяСуммаДоходаПоСтавке5,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОблагаемаяСуммаДоходаПоСтавке5,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИсчисленоПоСтавке5,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.УдержаноПоСтавке5,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ЗадолженностьПоСтавке5,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИзлишнеУдержаноПоСтавке5,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ПеречисленоПоСтавке5,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОбщаяСуммаДоходаПоСтавке10,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОблагаемаяСуммаДоходаПоСтавке10,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИсчисленоПоСтавке10,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.УдержаноПоСтавке10,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ЗадолженностьПоСтавке10,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИзлишнеУдержаноПоСтавке10,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ПеречисленоПоСтавке10,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОбщаяСуммаДоходаПоСтавке3,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОблагаемаяСуммаДоходаПоСтавке3,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИсчисленоПоСтавке3,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.УдержаноПоСтавке3,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ЗадолженностьПоСтавке3,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИзлишнеУдержаноПоСтавке3,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ПеречисленоПоСтавке3,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОбщаяСуммаДоходаПоСтавке6,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОблагаемаяСуммаДоходаПоСтавке6,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИсчисленоПоСтавке6,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.УдержаноПоСтавке6,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ЗадолженностьПоСтавке6,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИзлишнеУдержаноПоСтавке6,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ПеречисленоПоСтавке6,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОбщаяСуммаДоходаПоСтавке7,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОблагаемаяСуммаДоходаПоСтавке7,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИсчисленоПоСтавке7,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.УдержаноПоСтавке7,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ЗадолженностьПоСтавке7,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИзлишнеУдержаноПоСтавке7,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ПеречисленоПоСтавке7,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОбщаяСуммаДоходаПоСтавке12,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ОблагаемаяСуммаДоходаПоСтавке12,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИсчисленоПоСтавке12,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.УдержаноПоСтавке12,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ЗадолженностьПоСтавке12,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ИзлишнеУдержаноПоСтавке12,
	|	СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль.ПеречисленоПоСтавке12
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	&ТаблицаСотрудников КАК СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиДублиНомеров.НомерСтроки
	|ПОМЕСТИТЬ ВТДублиНомеровСправок
	|ИЗ
	|	ВТСотрудники КАК Сотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСотрудники КАК СотрудникиДублиНомеров
	|		ПО Сотрудники.НомерСтроки < СотрудникиДублиНомеров.НомерСтроки
	|			И Сотрудники.НомерСправки = СотрудникиДублиНомеров.НомерСправки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиДублиДанных.НомерСтроки
	|ПОМЕСТИТЬ ВТДублиДанныхСправок
	|ИЗ
	|	ВТСотрудники КАК Сотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСотрудники КАК СотрудникиДублиДанных
	|		ПО Сотрудники.НомерСтроки < СотрудникиДублиДанных.НомерСтроки
	|			И Сотрудники.Сотрудник = СотрудникиДублиДанных.Сотрудник
	|			И Сотрудники.Ставка = СотрудникиДублиДанных.Ставка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ДублиНомеровСправок.НомерСтроки ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЕстьПовторяющиесяНомераСправок,
	|	ВЫБОР
	|		КОГДА ДублиДанныхСправок.НомерСтроки ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЕстьПовторяющиесяДанныеСправок,
	|	Сотрудники.НомерСтроки КАК НомерСтроки,
	|	&НалоговыйПериод КАК НалоговыйПериод,
	|	Сотрудники.Сотрудник,
	|	Сотрудники.ИНН,
	|	Сотрудники.НомерСправки,
	|	Сотрудники.Ставка,
	|	Сотрудники.Фамилия,
	|	Сотрудники.Имя,
	|	Сотрудники.Отчество,
	|	Сотрудники.Адрес,
	|	Сотрудники.ВидДокумента,
	|	Сотрудники.СерияДокумента,
	|	Сотрудники.НомерДокумента,
	|	Сотрудники.Гражданство,
	|	Сотрудники.ДатаРождения,
	|	Сотрудники.СтатусНалогоплательщика,
	|	Сотрудники.АдресЗарубежом,
	|	Сотрудники.ОбщаяСуммаДоходаПоСтавке13,
	|	Сотрудники.ОблагаемаяСуммаДоходаПоСтавке13,
	|	Сотрудники.ИсчисленоПоСтавке13,
	|	Сотрудники.УдержаноПоСтавке13,
	|	Сотрудники.ЗадолженностьПоСтавке13,
	|	Сотрудники.ИзлишнеУдержаноПоСтавке13,
	|	Сотрудники.ПеречисленоПоСтавке13,
	|	Сотрудники.ОбщаяСуммаДоходаПоСтавке30,
	|	Сотрудники.ОблагаемаяСуммаДоходаПоСтавке30,
	|	Сотрудники.ИсчисленоПоСтавке30,
	|	Сотрудники.УдержаноПоСтавке30,
	|	Сотрудники.ЗадолженностьПоСтавке30,
	|	Сотрудники.ИзлишнеУдержаноПоСтавке30,
	|	Сотрудники.ПеречисленоПоСтавке30,
	|	Сотрудники.ОбщаяСуммаДоходаПоСтавке9,
	|	Сотрудники.ОблагаемаяСуммаДоходаПоСтавке9,
	|	Сотрудники.ИсчисленоПоСтавке9,
	|	Сотрудники.УдержаноПоСтавке9,
	|	Сотрудники.ЗадолженностьПоСтавке9,
	|	Сотрудники.ИзлишнеУдержаноПоСтавке9,
	|	Сотрудники.ПеречисленоПоСтавке9,
	|	Сотрудники.ОбщаяСуммаДоходаПоСтавке15,
	|	Сотрудники.ОблагаемаяСуммаДоходаПоСтавке15,
	|	Сотрудники.ИсчисленоПоСтавке15,
	|	Сотрудники.УдержаноПоСтавке15,
	|	Сотрудники.ЗадолженностьПоСтавке15,
	|	Сотрудники.ИзлишнеУдержаноПоСтавке15,
	|	Сотрудники.ПеречисленоПоСтавке15,
	|	Сотрудники.ОбщаяСуммаДоходаПоСтавке35,
	|	Сотрудники.ОблагаемаяСуммаДоходаПоСтавке35,
	|	Сотрудники.ИсчисленоПоСтавке35,
	|	Сотрудники.УдержаноПоСтавке35,
	|	Сотрудники.ЗадолженностьПоСтавке35,
	|	Сотрудники.ИзлишнеУдержаноПоСтавке35,
	|	Сотрудники.ПеречисленоПоСтавке35,
	|	Сотрудники.ОбщаяСуммаДоходаПоСтавке5,
	|	Сотрудники.ОблагаемаяСуммаДоходаПоСтавке5,
	|	Сотрудники.ИсчисленоПоСтавке5,
	|	Сотрудники.УдержаноПоСтавке5,
	|	Сотрудники.ЗадолженностьПоСтавке5,
	|	Сотрудники.ИзлишнеУдержаноПоСтавке5,
	|	Сотрудники.ПеречисленоПоСтавке5,
	|	Сотрудники.ОбщаяСуммаДоходаПоСтавке10,
	|	Сотрудники.ОблагаемаяСуммаДоходаПоСтавке10,
	|	Сотрудники.ИсчисленоПоСтавке10,
	|	Сотрудники.УдержаноПоСтавке10,
	|	Сотрудники.ЗадолженностьПоСтавке10,
	|	Сотрудники.ИзлишнеУдержаноПоСтавке10,
	|	Сотрудники.ПеречисленоПоСтавке10,
	|	Сотрудники.ОбщаяСуммаДоходаПоСтавке3,
	|	Сотрудники.ОблагаемаяСуммаДоходаПоСтавке3,
	|	Сотрудники.ИсчисленоПоСтавке3,
	|	Сотрудники.УдержаноПоСтавке3,
	|	Сотрудники.ЗадолженностьПоСтавке3,
	|	Сотрудники.ИзлишнеУдержаноПоСтавке3,
	|	Сотрудники.ПеречисленоПоСтавке3,
	|	Сотрудники.ОбщаяСуммаДоходаПоСтавке6,
	|	Сотрудники.ОблагаемаяСуммаДоходаПоСтавке6,
	|	Сотрудники.ИсчисленоПоСтавке6,
	|	Сотрудники.УдержаноПоСтавке6,
	|	Сотрудники.ЗадолженностьПоСтавке6,
	|	Сотрудники.ИзлишнеУдержаноПоСтавке6,
	|	Сотрудники.ПеречисленоПоСтавке6,
	|	Сотрудники.ОбщаяСуммаДоходаПоСтавке7,
	|	Сотрудники.ОблагаемаяСуммаДоходаПоСтавке7,
	|	Сотрудники.ИсчисленоПоСтавке7,
	|	Сотрудники.УдержаноПоСтавке7,
	|	Сотрудники.ЗадолженностьПоСтавке7,
	|	Сотрудники.ИзлишнеУдержаноПоСтавке7,
	|	Сотрудники.ПеречисленоПоСтавке7,
	|	Сотрудники.ОбщаяСуммаДоходаПоСтавке12,
	|	Сотрудники.ОблагаемаяСуммаДоходаПоСтавке12,
	|	Сотрудники.ИсчисленоПоСтавке12,
	|	Сотрудники.УдержаноПоСтавке12,
	|	Сотрудники.ЗадолженностьПоСтавке12,
	|	Сотрудники.ИзлишнеУдержаноПоСтавке12,
	|	Сотрудники.ПеречисленоПоСтавке12,
	|	ФизическиеЛица.Наименование КАК СотрудникНаименование,
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(Сотрудники.Ставка)
	|ИЗ
	|	ВТСотрудники КАК Сотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
	|		ПО Сотрудники.Сотрудник = ФизическиеЛица.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДублиНомеровСправок КАК ДублиНомеровСправок
	|		ПО Сотрудники.НомерСтроки = ДублиНомеровСправок.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДублиДанныхСправок КАК ДублиДанныхСправок
	|		ПО Сотрудники.НомерСтроки = ДублиДанныхСправок.НомерСтроки
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура ПроверитьДанныеДокумента(Отказ) Экспорт
		
	СоответствиеСтавокДоходов = УчетНДФЛ.СоответствиеДоходовСтавкам();
		
	ВыборкаСотрудниковДляПроверки = СформироватьЗапросПоСтрокамДокументаДляПроверки(Сотрудники.Выгрузить()).Выбрать();
	Если ЗначениеЗаполнено(Организация) Тогда
		СтруктураДанныхНА = УчетНДФЛ.СправкиНДФЛДанныеНалоговогоАгента(Организация, НалоговыйПериод, Справочники.РегистрацииВНалоговомОргане.ПустаяСсылка(), Дата, "", Справочники.Должности.ПустаяСсылка(), Неопределено);	
		УчетНДФЛ.СправкиНДФЛПроверитьДанныеНалоговогоАгента(
			ЭтотОбъект, 
			СтруктураДанныхНА, 
			Перечисления.ПорядокФормированияСправкиОДоходахФизическогоЛица.Сводно,
			Отказ);
	КонецЕсли;	
	
	Пока ВыборкаСотрудниковДляПроверки.СледующийПоЗначениюПоля("НомерСтроки") Цикл
		
		ПараметрыПроверкиДанныхФизическихЛиц = Документы.СправкаНДФЛ.ПараметрыПроверкиДанныхФизическихЛиц();
		ПараметрыПроверкиДанныхФизическихЛиц.Ссылка						= Ссылка;
		ПараметрыПроверкиДанныхФизическихЛиц.ПроверяемыеДанные 			= ВыборкаСотрудниковДляПроверки;
		ПараметрыПроверкиДанныхФизическихЛиц.ДатаДокумента				= Дата;
		ПараметрыПроверкиДанныхФизическихЛиц.ПутьКДаннымФизическогоЛица = "Сотрудники";
		ПараметрыПроверкиДанныхФизическихЛиц.НомерСтроки 				= ВыборкаСотрудниковДляПроверки.НомерСтроки;
		ПараметрыПроверкиДанныхФизическихЛиц.ПроверятьАдрес				= НалоговыйПериод<2019;
		
		Документы.СправкаНДФЛ.ПроверитьДанныеФизическогоЛица(ПараметрыПроверкиДанныхФизическихЛиц, Отказ);
		Если ВыборкаСотрудниковДляПроверки.ЕстьПовторяющиесяНомераСправок Тогда
			ПутьКДанным = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Сотрудники", ВыборкаСотрудниковДляПроверки.НомерСтроки, "НомерСправки");
			
			ТекстСообщения = НСтр("ru = 'Номер справки был введен в документе ранее';
									|en = 'Номер справки был введен в документе ранее'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка,  ПутьКДанным, ,Отказ); 	
		КонецЕсли;
		
		Если ВыборкаСотрудниковДляПроверки.ЕстьПовторяющиесяДанныеСправок Тогда
			ПутьКДанным = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Сотрудники", ВыборкаСотрудниковДляПроверки.НомерСтроки, "Сотрудник");
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Данные по ставке %1 были введены в документе ранее';
					|en = 'Данные по ставке %1 были введены в документе ранее'"), 
				ВыборкаСотрудниковДляПроверки.СтавкаПредставление);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, ПутьКДанным, ,Отказ);   
		КонецЕсли;
		
		СтруктураОтбора = Новый Структура("НомерСправки", ВыборкаСотрудниковДляПроверки.НомерСправки);
	
		Доходы = СведенияОДоходах.Выгрузить(СтруктураОтбора);
		Вычеты = СведенияОВычетах.Выгрузить(СтруктураОтбора);

		НачалоСообщения = СтрШаблон(
			НСтр("ru = 'Получатель дохода %1, справка № %2:';
				|en = 'Получатель дохода %1, справка № %2:'"), 
			ВыборкаСотрудниковДляПроверки.СотрудникНаименование, 
			ВыборкаСотрудниковДляПроверки.НомерСправки) + " ";
		
		ПутьКДаннымСотрудника = "Сотрудники[" + Формат(ВыборкаСотрудниковДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=") + "]";
		
		УчетНДФЛ.СправкиНДФЛПроверитьДанныеОДоходахНалогахВычетах(
			Ссылка,
			Дата,
			ВыборкаСотрудниковДляПроверки,
			ПутьКДаннымСотрудника,
			Доходы,
			Вычеты,
			СоответствиеСтавокДоходов,
			НачалоСообщения,
			Отказ,
			Истина);
			
	КонецЦикла;		
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли