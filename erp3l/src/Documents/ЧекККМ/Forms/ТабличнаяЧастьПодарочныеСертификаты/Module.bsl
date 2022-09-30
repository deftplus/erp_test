
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	Доплатить = Параметры.Доплатить;
	Валюта = Параметры.Валюта;
	Организация = Параметры.Организация;
	АдресВХранилищеТовары = Параметры.АдресВХранилищеТовары;
	ТекущаяДата = ТекущаяДатаСеанса();
	
	ТаблицаПодарочныеСертификаты = ПолучитьИзВременногоХранилища(Параметры.АдресВХранилище); // ТаблицаЗначений
	ОбщегоНазначенияУТ.ПронумероватьТаблицуЗначений(ТаблицаПодарочныеСертификаты, "Индекс");
	ТаблицаПодарочныеСертификаты.Колонки.Добавить("Остаток", ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаПодарочныеСертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ТаблицаПодарочныеСертификаты.Индекс КАК Индекс
	|ПОМЕСТИТЬ ТаблицаПодарочныеСертификаты
	|ИЗ
	|	&ТаблицаПодарочныеСертификаты КАК ТаблицаПодарочныеСертификаты
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|	
	|ВЫБРАТЬ
	|	ТаблицаПодарочныеСертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ТаблицаПодарочныеСертификаты.Индекс КАК Индекс,
	|	ЕСТЬNULL(ИсторияПодарочныхСертификатов.Статус, ЗНАЧЕНИЕ(Перечисление.СтатусыПодарочныхСертификатов.НеАктивирован)) КАК Статус,
	|
	|	ЕСТЬNULL(АктивацияПодарочныхСертификатов.Период, &Дата) КАК ДатаНачалаДействия,
	|	ВЫБОР
	|		КОГДА ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.День)
	|			ТОГДА ДОБАВИТЬКДАТЕ(ЕСТЬNULL(АктивацияПодарочныхСертификатов.Период, &Дата), ДЕНЬ, ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.КоличествоПериодовДействия)
	|		КОГДА ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|			ТОГДА ДОБАВИТЬКДАТЕ(ЕСТЬNULL(АктивацияПодарочныхСертификатов.Период, &Дата), НЕДЕЛЯ, ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.КоличествоПериодовДействия)
	|		КОГДА ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|			ТОГДА ДОБАВИТЬКДАТЕ(ЕСТЬNULL(АктивацияПодарочныхСертификатов.Период, &Дата), МЕСЯЦ, ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.КоличествоПериодовДействия)
	|		КОГДА ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|			ТОГДА ДОБАВИТЬКДАТЕ(ЕСТЬNULL(АктивацияПодарочныхСертификатов.Период, &Дата), КВАРТАЛ, ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.КоличествоПериодовДействия)
	|		КОГДА ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|			ТОГДА ДОБАВИТЬКДАТЕ(ЕСТЬNULL(АктивацияПодарочныхСертификатов.Период, &Дата), ГОД, ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.КоличествоПериодовДействия)
	|		КОГДА ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|			ТОГДА ДОБАВИТЬКДАТЕ(ЕСТЬNULL(АктивацияПодарочныхСертификатов.Период, &Дата), ДЕКАДА, ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.КоличествоПериодовДействия)
	|		КОГДА ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|			ТОГДА ДОБАВИТЬКДАТЕ(ЕСТЬNULL(АктивацияПодарочныхСертификатов.Период, &Дата), ПОЛУГОДИЕ, ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.КоличествоПериодовДействия)
	|		ИНАЧЕ ЕСТЬNULL(АктивацияПодарочныхСертификатов.Период, &Дата)
	|	КОНЕЦ КАК ДатаОкончанияДействия,
	
	|	(ПодарочныеСертификатыОстатки.СуммаОстаток
	|	* ВЫБОР
	|		КОГДА &Валюта <> ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.Валюта
	|			ТОГДА ВЫБОР
	|					КОГДА ЕСТЬNULL(КурсыВалютыСертификаты.КурсЗнаменатель, 0) > 0
	|						И ЕСТЬNULL(КурсыВалютыСертификаты.КурсЧислитель, 0) > 0
	|						И ЕСТЬNULL(КурсыВалюты.КурсЗнаменатель, 0) > 0
	|						И ЕСТЬNULL(КурсыВалюты.КурсЧислитель, 0) > 0
	|					ТОГДА 
	|						(КурсыВалютыСертификаты.КурсЧислитель * КурсыВалюты.КурсЗнаменатель)
	|						/ (КурсыВалюты.КурсЧислитель * КурсыВалютыСертификаты.КурсЗнаменатель)
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|		ИНАЧЕ 1
	|	КОНЕЦ) КАК Остаток
	|ИЗ
	|	ТаблицаПодарочныеСертификаты КАК ТаблицаПодарочныеСертификаты
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПодарочныеСертификаты.Остатки(&Дата, ПодарочныйСертификат В (ВЫБРАТЬ Т.ПодарочныйСертификат ИЗ ТаблицаПодарочныеСертификаты КАК Т)) КАК ПодарочныеСертификатыОстатки
	|	ПО ПодарочныеСертификатыОстатки.ПодарочныйСертификат = ТаблицаПодарочныеСертификаты.ПодарочныйСертификат
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияПодарочныхСертификатов КАК АктивацияПодарочныхСертификатов
	|	ПО ТаблицаПодарочныеСертификаты.ПодарочныйСертификат = АктивацияПодарочныхСертификатов.ПодарочныйСертификат
	|		И (АктивацияПодарочныхСертификатов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПодарочныхСертификатов.Активирован))
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияПодарочныхСертификатов.СрезПоследних(&Дата, ПодарочныйСертификат В (ВЫБРАТЬ Т.ПодарочныйСертификат ИЗ ТаблицаПодарочныеСертификаты КАК Т)) КАК ИсторияПодарочныхСертификатов
	|	ПО ИсторияПодарочныхСертификатов.ПодарочныйСертификат = ТаблицаПодарочныеСертификаты.ПодарочныйСертификат
	|	
	|	// Определим курс валюты документа.
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата, Валюта = &Валюта И БазоваяВалюта = &БазоваяВалюта) КАК КурсыВалюты
	|	ПО
	|		ИСТИНА
	|		
	|	// Определим курс валюты взаиморасчетов.
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата, БазоваяВалюта = &БазоваяВалюта) КАК КурсыВалютыСертификаты
	|	ПО
	|		ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.Валюта = КурсыВалютыСертификаты.Валюта
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаПодарочныеСертификаты.Индекс
	|;
	|");
	
	Запрос.Параметры.Вставить("ТаблицаПодарочныеСертификаты", ТаблицаПодарочныеСертификаты);
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("БазоваяВалюта", ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация));
	
	ПодарочныеСертификаты.Загрузить(ТаблицаПодарочныеСертификаты);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокиТаблицы = ПодарочныеСертификаты.НайтиСтроки(Новый Структура("Индекс",Выборка.Индекс));
		Если СтрокиТаблицы.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(СтрокиТаблицы[0], Выборка, ,"Индекс");
		КонецЕсли;
		
	КонецЦикла;
	
	СуммаОплаты = 0;
	Для Каждого СтрокаТЧ Из ПодарочныеСертификаты Цикл
		СуммаОплаты = СуммаОплаты + СтрокаТЧ.Сумма;
	КонецЦикла;
	
	ОсталосьДоплатить = Доплатить;
	
	Элементы.ПодарочныеСертификатыСумма.Заголовок   = Элементы.ПодарочныеСертификатыСумма.Заголовок + " " + "(" + Валюта + ")";
	Элементы.ПодарочныеСертификатыОстаток.Заголовок = Элементы.ПодарочныеСертификатыОстаток.Заголовок + " " + "(" + Валюта + ")";
	Элементы.ГруппаИтого.Заголовок = Элементы.ГруппаИтого.Заголовок + " " + "(" + Валюта + ")";

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.ГруппаИтого.ЦветФона = Новый Цвет();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода,СчитывательМагнитныхКарт");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОчиститьСообщения();
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
		ИначеЕсли ИмяСобытия ="TracksData" Тогда
			ОбработатьДанныеСчитывателяМагнитныхКарт(Параметр);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "СчитанПодарочныйСертификат"
		И Параметр.ФормаВладелец = УникальныйИдентификатор Тогда
		
		ОбработатьПодарочныйСертификат(Параметр.ПодарочныйСертификат);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодарочныеСертификаты

&НаКлиенте
Процедура ПодарочныеСертификатыСуммаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПодарочныеСертификаты.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока.Сумма = Мин(ТекущаяСтрока.Сумма, ТекущаяСтрока.Остаток);
	
	СуммаОплаты = ПодарочныеСертификаты.Итог("Сумма");
	ОсталосьДоплатить = Доплатить - СуммаОплаты;
	Если СуммаОплаты > Доплатить Тогда
		ТекущаяСтрока.Сумма = ТекущаяСтрока.Сумма + ОсталосьДоплатить;
		ОсталосьДоплатить = 0;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПодарочныеСертификатыПередУдалением(Элемент, Отказ)
	
	ДанныеКУдалению = Элементы.ПодарочныеСертификаты.ТекущиеДанные;
	ДельтаИзменения = ДанныеКУдалению.Сумма;
	СуммаОплаты = СуммаОплаты - ДельтаИзменения;
	
	ОсталосьДоплатить = ОсталосьДоплатить + ДельтаИзменения;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодарочныеСертификатыПодарочныйСертификатПриИзменении(Элемент)
	
	ПодарочныйСертификат = Элементы.ПодарочныеСертификаты.ТекущиеДанные.ПодарочныйСертификат;
	ОбработатьПодарочныйСертификат(ПодарочныйСертификат, Элементы.ПодарочныеСертификаты.ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	
	ПроверитьОплатуПоСегментам(Отказ);
	
	ПроверитьДублиСтрокВТабличнойЧасти(Отказ);
	
	Для Каждого СтрокаТЧ Из ПодарочныеСертификаты Цикл
		
		Если СтрокаТЧ.Остаток < СтрокаТЧ.Сумма И СтрокаТЧ.Сумма > 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Сумма оплаты превышает остаток денежных средств на сертификате ""%1"" в строке %2';
						|en = 'The payment amount exceeds the balance on certificate ""%1"" in line %2'"),
					СтрокаТЧ.ПодарочныйСертификат, ПодарочныеСертификаты.Индекс(СтрокаТЧ) + 1),
				Неопределено,
				,
				,
				Отказ);
		КонецЕсли;
		
		Если СтрокаТЧ.Сумма = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнено поле ""Сумма"" в строке %1';
						|en = '""Amount"" in line %1 is not filled in'"),
					ПодарочныеСертификаты.Индекс(СтрокаТЧ) + 1),
				Неопределено,
				,
				,
				Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаТЧ.ПодарочныйСертификат) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнено поле ""Подарочный сертификат"" в строке %1';
						|en = '""Gift card"" in line %1 is not filled in'"),
					ПодарочныеСертификаты.Индекс(СтрокаТЧ) + 1),
				Неопределено,
				"ПодарочныеСертификаты["+ПодарочныеСертификаты.Индекс(СтрокаТЧ)+"].ПодарочныйСертификат",
				,
				Отказ);
		КонецЕсли;
		
		Если СтрокаТЧ.Статус <> ПредопределенноеЗначение("Перечисление.СтатусыПодарочныхСертификатов.НеАктивирован")
			И СтрокаТЧ.ДатаОкончанияДействия < ТекущаяДата И ЗначениеЗаполнено(СтрокаТЧ.ПодарочныйСертификат) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Подарочный сертификат в строке %1 просрочен. Дата окончания действия %2.';
						|en = 'Gift card in line %1 has overdue. Validity expiration date %2.'"),
					ПодарочныеСертификаты.Индекс(СтрокаТЧ) + 1, Формат(СтрокаТЧ.ДатаОкончанияДействия, "ДЛФ=D")),
				Неопределено,
				"ПодарочныеСертификаты["+ПодарочныеСертификаты.Индекс(СтрокаТЧ)+"].ПодарочныйСертификат",
				,
				Отказ);
		КонецЕсли;
	
		Если СтрокаТЧ.Статус <> ПредопределенноеЗначение("Перечисление.СтатусыПодарочныхСертификатов.ЧастичноПогашен")
			И СтрокаТЧ.Статус <> ПредопределенноеЗначение("Перечисление.СтатусыПодарочныхСертификатов.Активирован") И ЗначениеЗаполнено(СтрокаТЧ.ПодарочныйСертификат) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Подарочный сертификат в строке %1 не может быть использован для оплаты. Статус сертификата ""%2"".';
						|en = 'Gift card in line %1 cannot be used for payment. Status of the certificate is ""%2"".'"),
					ПодарочныеСертификаты.Индекс(СтрокаТЧ) + 1, СтрокаТЧ.Статус),
				Неопределено,
				"ПодарочныеСертификаты["+ПодарочныеСертификаты.Индекс(СтрокаТЧ)+"].ПодарочныйСертификат",
				,
				Отказ);
		КонецЕсли;
		
	КонецЦикла;

	Если Не Отказ Тогда
		Закрыть(ПоместитьТабличнуюЧастьПодарочныеСертификатыВХранилище(ЭтаФорма.ВладелецФормы.УникальныйИдентификатор));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СчитатьПодарочныйСертификат(Команда)
	
	ОчиститьСообщения();
	
	ОткрытьФорму(
		"Справочник.ПодарочныеСертификаты.Форма.СчитываниеПодарочногоСертификата",
		Новый Структура("НеИспользоватьРучнойВвод", Ложь),
		ЭтаФорма,
		ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодарочныеСертификаты.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПодарочныеСертификаты.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.СтатусыПодарочныхСертификатов.Активирован);
	СписокЗначений.Добавить(Перечисления.СтатусыПодарочныхСертификатов.ЧастичноПогашен);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПодарочныеСертификаты.ДатаОкончанияДействия");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ТекущаяДата");

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПодарочныеСертификаты.Остаток");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЗакрытыйДокумент);

КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Если Не ШтрихкодированиеНоменклатурыКлиент.ШтрихкодыВалидны(ДанныеШтрихкодов) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеШтрихкодов) = Тип("Массив") Тогда
		МассивШтрихкодов = ДанныеШтрихкодов;
	Иначе
		МассивШтрихкодов = Новый Массив;
		МассивШтрихкодов.Добавить(ДанныеШтрихкодов);
	КонецЕсли;
	
	ПодарочныеСертификатыКлиент.ОбработатьПолученныйКодНаКлиенте(
		ЭтаФорма,
		МассивШтрихкодов[0].Штрихкод,
		ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеСчитывателяМагнитныхКарт(Данные)
	
	ПодарочныеСертификатыКлиент.ОбработатьПолученныйКодНаКлиенте(
		ЭтаФорма,
		Данные,
		ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод"));
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Функция ПоместитьТабличнуюЧастьПодарочныеСертификатыВХранилище(Идентификатор)
	
	Возврат ПоместитьВоВременноеХранилище(ПодарочныеСертификаты.Выгрузить(), Идентификатор);
	
КонецФункции

&НаСервере
Процедура ОбработатьПодарочныйСертификат(ПодарочныйСертификат, ИдентификаторСтроки = Неопределено)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ПодарочныеСертификатыОстатки.СуммаОстаток, 0)
	|	* ВЫБОР
	|		КОГДА &Валюта <> ПодарочныеСертификаты.Владелец.Валюта
	|			ТОГДА ВЫБОР
	|					КОГДА ЕСТЬNULL(КурсыВалютыСертификаты.КурсЗнаменатель, 0) > 0
	|						И ЕСТЬNULL(КурсыВалютыСертификаты.КурсЧислитель, 0) > 0
	|						И ЕСТЬNULL(КурсыВалюты.КурсЗнаменатель, 0) > 0
	|						И ЕСТЬNULL(КурсыВалюты.КурсЧислитель, 0) > 0
	|					ТОГДА 
	|						(КурсыВалютыСертификаты.КурсЧислитель * КурсыВалюты.КурсЗнаменатель)
	|						/ (КурсыВалюты.КурсЧислитель * КурсыВалютыСертификаты.КурсЗнаменатель)
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Остаток
	|ИЗ
	|	Справочник.ПодарочныеСертификаты КАК ПодарочныеСертификаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПодарочныеСертификаты.Остатки(&Дата, ПодарочныйСертификат = &Ссылка) КАК ПодарочныеСертификатыОстатки
	|		ПО ПодарочныеСертификатыОстатки.ПодарочныйСертификат = ПодарочныеСертификаты.Ссылка
	|	
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата, БазоваяВалюта = &БазоваяВалюта) КАК КурсыВалютыСертификаты
	|ПО 
	|	ПодарочныеСертификаты.Владелец.Валюта = КурсыВалютыСертификаты.Валюта
	|	И ПодарочныеСертификаты.Ссылка = &Ссылка
	|	
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата, Валюта = &Валюта И БазоваяВалюта = &БазоваяВалюта) КАК КурсыВалюты
	|	ПО ИСТИНА
	|	
	|ГДЕ
	|	ПодарочныеСертификаты.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", ПодарочныйСертификат);
	Запрос.УстановитьПараметр("Дата",   ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("БазоваяВалюта", ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация));
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	СуммаОплаты = 0;
	Для Каждого СтрокаТЧ Из ПодарочныеСертификаты Цикл
		Если СтрокаТЧ.ПодарочныйСертификат <> ПодарочныйСертификат Тогда
			СуммаОплаты = СуммаОплаты + СтрокаТЧ.Сумма;
		КонецЕсли;
	КонецЦикла;
	
	ОсталосьДоплатить = Доплатить - СуммаОплаты;
	
	Если Выборка.Следующий() Тогда
		
		Если ИдентификаторСтроки = Неопределено Тогда
			
			НайденныеСтроки = ПодарочныеСертификаты.НайтиСтроки(Новый Структура("ПодарочныйСертификат", ПодарочныйСертификат));
			Если НайденныеСтроки.Количество() = 0 Тогда
				НайденнаяСтрока = ПодарочныеСертификаты.Добавить();
			Иначе
				НайденнаяСтрока = НайденныеСтроки[0];
			КонецЕсли;
			
		Иначе
			НайденнаяСтрока = ПодарочныеСертификаты.НайтиПоИдентификатору(ИдентификаторСтроки);
		КонецЕсли;
		
		Данные = ПодарочныеСертификатыВызовСервера.ПолучитьДанныеПодарочногоСертификата(ПодарочныйСертификат);
		
		НайденнаяСтрока.ПодарочныйСертификат  = ПодарочныйСертификат;
		НайденнаяСтрока.Остаток               = Выборка.Остаток;
		НайденнаяСтрока.Сумма                 = Мин(ОсталосьДоплатить, Выборка.Остаток);
		НайденнаяСтрока.Статус                = Данные.Статус;
		НайденнаяСтрока.ДатаНачалаДействия    = Данные.ДатаНачалаДействия;
		НайденнаяСтрока.ДатаОкончанияДействия = Данные.ДатаОкончанияДействия;
		
		СуммаОплаты = СуммаОплаты + НайденнаяСтрока.Сумма;
		
		ОсталосьДоплатить =  ОсталосьДоплатить - НайденнаяСтрока.Сумма;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьДублиСтрокВТабличнойЧасти(Отказ)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ 
	|ТаблицаПроверки.НомерСтроки, 
	|ТаблицаПроверки.ПодарочныйСертификат
	|	ПОМЕСТИТЬ ТаблицаПроверки
	|ИЗ
	|	&ТаблицаПроверки КАК ТаблицаПроверки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ТаблицаПроверки.НомерСтроки) КАК НомерСтроки,
	|	СУММА(1) КАК КоличествоДублей,
	|	ТаблицаПроверки.ПодарочныйСертификат
	|ПОМЕСТИТЬ ДублирующиесяСтроки
	|ИЗ
	|	ТаблицаПроверки КАК ТаблицаПроверки
	|
	|СГРУППИРОВАТЬ ПО 
	|	ТаблицаПроверки.ПодарочныйСертификат
	|
	|ИМЕЮЩИЕ
	|	СУММА(1) > 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПроверки.НомерСтроки,
	|	ДублирующиесяСтроки.НомерСтроки КАК ПерваяСтрока
	|ИЗ
	|	ТаблицаПроверки КАК ТаблицаПроверки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДублирующиесяСтроки КАК ДублирующиесяСтроки
	|		ПО ТаблицаПроверки.НомерСтроки <> ДублирующиесяСтроки.НомерСтроки 
	|	И ТаблицаПроверки.ПодарочныйСертификат = ДублирующиесяСтроки.ПодарочныйСертификат");
	
	Таблица = ПодарочныеСертификаты.Выгрузить(,"ПодарочныйСертификат");
	ОбщегоНазначенияУТ.ПронумероватьТаблицуЗначений(Таблица, "НомерСтроки");
	
	Запрос.УстановитьПараметр("ТаблицаПроверки", Таблица);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ТекстСообщения = НСтр("ru = 'Данные в строке %НомерСтроки% списка ""Подарочные сертификаты"" совпадают с данными в строке %ПерваяСтрока% по значению поля ""Подарочный сертификат"".';
								|en = 'Data in line %НомерСтроки% of list ""Gift cards"" matches the data in line %ПерваяСтрока% by value of field ""Gift card"".'");
		ТекстСообщения =  СтрЗаменить(ТекстСообщения, "%НомерСтроки%", Выборка.НомерСтроки + 1);
		ТекстСообщения =  СтрЗаменить(ТекстСообщения, "%ПерваяСтрока%", Выборка.ПерваяСтрока + 1);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			Неопределено,
			"ПодарочныеСертификаты["+Выборка.НомерСтроки+"].ПодарочныйСертификат",
			,
			Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьОплатуПоСегментам(Отказ)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Сумма КАК Сумма
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПодарочныеСертификаты.НомерСтроки КАК НомерСтроки,
	|	ТаблицаПодарочныеСертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ТаблицаПодарочныеСертификаты.Сумма КАК Сумма,
	|	ТаблицаПодарочныеСертификаты.Остаток КАК Остаток
	|ПОМЕСТИТЬ ТаблицаПодарочныеСертификаты
	|ИЗ
	|	&ТаблицаПодарочныеСертификаты КАК ТаблицаПодарочныеСертификаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Сегмент КАК Сегмент,
	|	СУММА(Товары.Сумма) КАК Сумма
	|ПОМЕСТИТЬ СуммыПоСегментам
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаТовары.Номенклатура КАК Номенклатура,
	|		ТаблицаТовары.Характеристика КАК Характеристика,
	|		ТаблицаТовары.Сумма КАК Сумма,
	|		НоменклатураСегмента.Сегмент КАК Сегмент
	|	ИЗ
	|		ТаблицаТовары КАК ТаблицаТовары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураСегмента КАК НоменклатураСегмента
	|			ПО ТаблицаТовары.Номенклатура = НоменклатураСегмента.Номенклатура
	|				И ТаблицаТовары.Характеристика = НоменклатураСегмента.Характеристика
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаТовары.Номенклатура,
	|		ТаблицаТовары.Характеристика,
	|		ТаблицаТовары.Сумма,
	|		ЗНАЧЕНИЕ(Справочник.СегментыНоменклатуры.ПустаяСсылка)
	|	ИЗ
	|		ТаблицаТовары КАК ТаблицаТовары
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураСегмента КАК НоменклатураСегмента
	|			ПО ТаблицаТовары.Номенклатура = НоменклатураСегмента.Номенклатура
	|				И ТаблицаТовары.Характеристика = НоменклатураСегмента.Характеристика) КАК Товары
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Сегмент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Сегмент КАК Сегмент,
	|	СУММА(Таблица.СуммаОплаты) КАК СуммаОплаты,
	|	СУММА(Таблица.Сумма) КАК Сумма,
	|	СУММА(Таблица.Остаток) КАК Остаток
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.СегментНоменклатуры КАК Сегмент,
	|		0 КАК Сумма,
	|		СУММА(ТаблицаПодарочныеСертификаты.Сумма) КАК СуммаОплаты,
	|		СУММА(ТаблицаПодарочныеСертификаты.Остаток) КАК Остаток
	|	ИЗ
	|		ТаблицаПодарочныеСертификаты КАК ТаблицаПодарочныеСертификаты
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.СегментНоменклатуры
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СуммыПоСегментам.Сегмент,
	|		СуммыПоСегментам.Сумма,
	|		0,
	|		0
	|	ИЗ
	|		СуммыПоСегментам КАК СуммыПоСегментам) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Сегмент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПодарочныеСертификаты.НомерСтроки КАК НомерСтрокиТаблицы,
	|	ТаблицаПодарочныеСертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец КАК ВидПодарочногоСертификата,
	|	ТаблицаПодарочныеСертификаты.ПодарочныйСертификат.Владелец.СегментНоменклатуры КАК Сегмент
	|ИЗ
	|	ТаблицаПодарочныеСертификаты КАК ТаблицаПодарочныеСертификаты");
	
	ТаблицаПодарочныеСертификаты = ПодарочныеСертификаты.Выгрузить(,"ПодарочныйСертификат,Сумма,Остаток");
	ОбщегоНазначенияУТ.ПронумероватьТаблицуЗначений(ТаблицаПодарочныеСертификаты, "НомерСтроки");
	
	Запрос.УстановитьПараметр("ТаблицаПодарочныеСертификаты", ТаблицаПодарочныеСертификаты);
	Запрос.УстановитьПараметр("ТаблицаТовары", ПолучитьИзВременногоХранилища(АдресВХранилищеТовары));
	
	РезультатыЗапросов = Запрос.ВыполнитьПакет();
	
	Выборка = РезультатыЗапросов[3].Выбрать();
	ТаблицаСертификатыИВиды = РезультатыЗапросов[4].Выгрузить();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.СуммаОплаты > 0 И Выборка.Сумма = 0 Тогда
			
			СтрокиПодарочныхСертификатов = ТаблицаСертификатыИВиды.НайтиСтроки(Новый Структура("Сегмент",Выборка.Сегмент));
			
			Для Каждого СтрокаТЧ Из СтрокиПодарочныхСертификатов Цикл
			
				ТекстСообщения = НСтр("ru = 'Сертификаты вида ""%ВидПодарочногоСертификата%"" предназначены
				                            |только для оплаты номенклатурных позиций из сегмента ""%Сегмент%"". Оплата данного чека такими сертификатами невозможна.';
				                            |en = 'Certificates of kind ""%ВидПодарочногоСертификата%"" are intended 
				                            |to pay only for product items of segment ""%Сегмент%"". You cannot pay this receipt with these certificates.'");
				ТекстСообщения =  СтрЗаменить(ТекстСообщения, "%ВидПодарочногоСертификата%", ТаблицаСертификатыИВиды.Найти(Выборка.Сегмент, "Сегмент").ВидПодарочногоСертификата);
				ТекстСообщения =  СтрЗаменить(ТекстСообщения, "%Сегмент%", Выборка.Сегмент);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					Неопределено,
					"ПодарочныеСертификаты["+СтрокаТЧ.НомерСтрокиТаблицы+"].ПодарочныйСертификат",
					,
					Отказ);
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если Выборка.СуммаОплаты > 0 И Выборка.Сумма > 0 И Выборка.Сумма < Выборка.СуммаОплаты Тогда
			
			ВидыПодарочныхСертификатов = Новый Массив;
			Для Каждого СтрокаТЧ Из ТаблицаСертификатыИВиды.НайтиСтроки(Новый Структура("Сегмент",Выборка.Сегмент)) Цикл
				ПредставлениеВида = """" + СтрокаТЧ.ВидПодарочногоСертификата + """";
				Если ВидыПодарочныхСертификатов.Найти(ПредставлениеВида) = Неопределено Тогда
					ВидыПодарочныхСертификатов.Добавить(ПредставлениеВида);
				КонецЕсли;
			КонецЦикла;
			
			СтрокиПодарочныхСертификатов = ТаблицаСертификатыИВиды.НайтиСтроки(Новый Структура("Сегмент",Выборка.Сегмент));
			Для Каждого СтрокаТЧ Из СтрокиПодарочныхСертификатов Цикл
			
				ТекстСообщения = НСтр("ru = 'Сертификаты вида %ВидПодарочногоСертификата% предназначены
				                            |только для оплаты номенклатурных позиций из сегмента ""%Сегмент%"". Данными сертификатами можно оплатить только %Сумма% %Валюта%.';
				                            |en = 'Certificates of kind ""%ВидПодарочногоСертификата%"" are intended 
				                            |to pay only for product items of segment ""%Сегмент%"". With these certificates, you can pay only %Сумма% %Валюта%.'");
				ТекстСообщения =  СтрЗаменить(ТекстСообщения, "%ВидПодарочногоСертификата%", СтрСоединить(ВидыПодарочныхСертификатов, ","));
				ТекстСообщения =  СтрЗаменить(ТекстСообщения, "%Сегмент%", Выборка.Сегмент);
				ТекстСообщения =  СтрЗаменить(ТекстСообщения, "%Сумма%", Выборка.Сумма);
				ТекстСообщения =  СтрЗаменить(ТекстСообщения, "%Валюта%", Валюта);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					Неопределено,
					"ПодарочныеСертификаты["+СтрокаТЧ.НомерСтрокиТаблицы+"].ПодарочныйСертификат",
					,
					Отказ);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодарочныеСертификатыПодарочныйСертификатНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	МассивОтбора = Новый Массив();
	МассивОтбора.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыПодарочныхСертификатов.ЧастичноПогашен"));
	МассивОтбора.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыПодарочныхСертификатов.Активирован"));
	
	СтруктураОтбора     = Новый Структура("Статус", МассивОтбора);
	СтруктураПараметров = Новый Структура("Отбор", СтруктураОтбора);   	    
	
	ОткрытьФорму("Справочник.ПодарочныеСертификаты.ФормаВыбора", СтруктураПараметров, ЭтаФорма,,,, 
	                         Новый ОписаниеОповещения("ПодарочныеСертификатыПодарочныйСертификатНачалоВыбораЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПодарочныеСертификатыПодарочныйСертификатНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	ВыбранныйСертификат = Результат;
	Если ВыбранныйСертификат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ПодарочныеСертификаты.ТекущиеДанные;  	
	Если ТекущиеДанные <> Неопределено Тогда   		
		ТекущиеДанные.ПодарочныйСертификат = ВыбранныйСертификат;
		ОбработатьПодарочныйСертификат(ВыбранныйСертификат, Элементы.ПодарочныеСертификаты.ТекущаяСтрока);  
	КонецЕсли; 	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
