#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	СтруктураВидовУчета = ПроведениеРасширенныйСервер.СтруктураВидовУчета();
	ПроведениеРасширенныйСервер.ПодготовитьНаборыЗаписейКРегистрацииДвиженийПоВидамУчета(РежимПроведения, Ссылка, СтруктураВидовУчета, Неопределено, Движения, ЭтотОбъект, Отказ);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	РасчетЗарплатыРасширенный.СформироватьДвиженияУдержаний(Движения, Отказ, Организация, КонецМесяца(МесяцНачисления), ДанныеДляПроведения.Удержания, ДанныеДляПроведения.ПоказателиУдержаний);
	ИсполнительныеЛисты.СформироватьУдержанияПоИсполнительнымДокументам(Движения, ДанныеДляПроведения.УдержанияПоИсполнительнымДокументам);
	РасчетЗарплатыРасширенный.СформироватьЗадолженностьПоУдержаниямФизическихЛиц(Движения, ДанныеДляПроведения.ЗадолженностьПоУдержаниям);
	
	// Заполним описание данных для проведения в учете начисленной зарплаты.
	ДанныеДляПроведенияУчетЗарплаты = ОтражениеЗарплатыВУчете.ОписаниеДанныеДляПроведения();
	ДанныеДляПроведенияУчетЗарплаты.Движения 				= Движения;
	ДанныеДляПроведенияУчетЗарплаты.Организация 			= Организация;
	ДанныеДляПроведенияУчетЗарплаты.ПериодРегистрации 		= МесяцНачисления;
	ДанныеДляПроведенияУчетЗарплаты.ПорядокВыплаты 			= Перечисления.ХарактерВыплатыЗарплаты.Зарплата;
	ДанныеДляПроведенияУчетЗарплаты.ОкончательныйРасчет		= Истина;
	
	УчетНачисленнойЗарплаты.ЗарегистрироватьУдержания(ДанныеДляПроведенияУчетЗарплаты, Отказ, ДанныеДляПроведения.УдержанияПоСотрудникам);
	
	// - Регистрация начислений в бухучете.
	ОтражениеЗарплатыВБухучетеРасширенный.ЗарегистрироватьНачисленияУдержания(ДанныеДляПроведенияУчетЗарплаты, Отказ,
		Неопределено, ДанныеДляПроведения.УдержанияПоСотрудникам, Неопределено);
	
	ПроведениеРасширенныйСервер.ЗаписьДвиженийПоУчетам(Движения, СтруктураВидовУчета);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	ДанныеДляПроведения = РасчетЗарплаты.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МесяцНачисления", МесяцНачисления);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОграничениеВзысканийУдержания.Ссылка.МесяцНачисления КАК Период,
	               |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	               |	ОграничениеВзысканийУдержания.Ссылка.Организация.ГоловнаяОрганизация КАК Организация,
	               |	ОграничениеВзысканийУдержания.ФизическоеЛицо КАК ФизическоеЛицо,
	               |	ОграничениеВзысканийУдержания.Удержание КАК Удержание,
	               |	ОграничениеВзысканийУдержания.ДокументОснование КАК ДокументОснование,
	               |	ОграничениеВзысканийУдержания.Задолженность КАК Сумма
	               |ИЗ
	               |	Документ.ОграничениеВзысканий.Удержания КАК ОграничениеВзысканийУдержания
	               |ГДЕ
	               |	ОграничениеВзысканийУдержания.Ссылка = &Ссылка
	               |	И ОграничениеВзысканийУдержания.Задолженность <> 0
	               |	И ОграничениеВзысканийУдержания.Удержание.ЯвляетсяВзысканием";
				   
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеДляПроведения.Вставить("ЗадолженностьПоУдержаниям", РезультатЗапроса.Выгрузить());
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Удержания.Ссылка КАК ДокументСсылка,
	               |	Удержания.Ссылка.Организация.ГоловнаяОрганизация КАК Организация,
	               |	Удержания.ФизическоеЛицо КАК ФизическоеЛицо,
	               |	Удержания.Сотрудник КАК Сотрудник,
	               |	Удержания.Удержание КАК Удержание,
	               |	Удержания.Удержание.КатегорияУдержания КАК КатегорияУдержания,
	               |	Удержания.Результат - Удержания.Рассчитано КАК Сумма,
	               |	Удержания.Результат - Удержания.Рассчитано КАК Результат,
	               |	Удержания.ДокументОснование КАК ДокументОснование,
	               |	Удержания.Получатель КАК Получатель,
	               |	Удержания.ПлатежныйАгент КАК ПлатежныйАгент,
	               |	ВЫБОР
	               |		КОГДА Удержания.Удержание.КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ИсполнительныйЛист)
	               |			ТОГДА Удержания.Получатель
	               |		КОГДА Удержания.Удержание.КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ВознаграждениеПлатежногоАгента)
	               |			ТОГДА Удержания.ПлатежныйАгент
	               |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	               |	КОНЕЦ КАК Контрагент,
	               |	НАЧАЛОПЕРИОДА(Удержания.ДатаНачала, МЕСЯЦ) КАК ПериодДействия,
	               |	Удержания.ДатаНачала КАК ДатаНачала,
	               |	Удержания.ДатаОкончания КАК ДатаОкончания,
	               |	Удержания.ИдентификаторСтрокиВидаРасчета КАК ИдентификаторСтроки,
	               |	ВЫБОР
	               |		КОГДА Удержания.Рассчитано = 0
	               |			ТОГДА 0
	               |		ИНАЧЕ (Удержания.Результат - Удержания.Рассчитано) / Удержания.Рассчитано
	               |	КОНЕЦ КАК Коэффициент,
	               |	ИСТИНА КАК ОграничениеВзыскания,
	               |	ИСТИНА КАК ФиксСторно
	               |ИЗ
	               |	Документ.ОграничениеВзысканий.Удержания КАК Удержания
	               |ГДЕ
	               |	Удержания.Ссылка = &Ссылка
	               |	И Удержания.Результат <> Удержания.Рассчитано";
	
	Запрос.Выполнить();
	
	// Удержания
	ДанныеДляПроведения.Удержания = Запрос.Выполнить().Выгрузить();
	
	ОграниченияВзысканий = ДанныеДляПроведения.Удержания.Скопировать(,
		"ФизическоеЛицо,
		|Удержание,
		|КатегорияУдержания,
		|Сумма,
		|ДокументОснование,
		|Получатель,
		|ПлатежныйАгент,
		|Контрагент,
		|ПериодДействия,
		|ДатаНачала,
		|ДатаОкончания,
		|ИдентификаторСтроки,
		|ОграничениеВзыскания");
	ОграниченияВзысканий.Колонки.Удержание.Имя = "ВидУдержания";
	ОграниченияВзысканий.Колонки.Добавить(
		"Сотрудник", 
		Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ОграниченияВзысканий.Колонки.Добавить(
		"Подразделение",
		Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"));
	ОграниченияВзысканий.Колонки.Добавить(
		"СтатьяФинансирования", 
		Новый ОписаниеТипов("СправочникСсылка.СтатьиФинансированияЗарплата"));
	ОграниченияВзысканий.Колонки.Добавить(
		"СтатьяРасходов",
		Новый ОписаниеТипов("СправочникСсылка.СтатьиРасходовЗарплата"));
	
	ДанныеДляПроведения.УдержанияПоСотрудникам = 
		ОтражениеЗарплатыВУчетеРасширенный.ОграниченияВзысканийПоРабочимМестамИСтатьям(
			Организация, 
			МесяцНачисления, 
			ОграниченияВзысканий, 
			Ссылка);
			
	ДанныеДляПроведения.УдержанияПоСотрудникам.Колонки.Добавить(
		"ВидДоходаИсполнительногоПроизводства", 
		Новый ОписаниеТипов("ПеречислениеСсылка.ВидыДоходовИсполнительногоПроизводства"));
	ДанныеДляПроведения.УдержанияПоСотрудникам.ЗаполнитьЗначения(
		Перечисления.ВидыДоходовИсполнительногоПроизводства.ЗарплатаВознаграждения,
		"ВидДоходаИсполнительногоПроизводства");
			
	// Удержания по исполнительным документам.
	Запрос.УстановитьПараметр("УдержанияСРаспределением", ДанныеДляПроведения.УдержанияПоСотрудникам);
	Запрос.Текст = "ВЫБРАТЬ
	               |	УдержанияСРаспределением.Удержание КАК Удержание,
	               |	УдержанияСРаспределением.СтатьяФинансирования КАК СтатьяФинансирования,
	               |	УдержанияСРаспределением.СтатьяРасходов КАК СтатьяРасходов,
	               |	УдержанияСРаспределением.ДокументОснование КАК ДокументОснование,
	               |	УдержанияСРаспределением.Получатель КАК Получатель,
	               |	УдержанияСРаспределением.ПлатежныйАгент КАК ПлатежныйАгент,
	               |	УдержанияСРаспределением.ОграничениеВзыскания КАК ОграничениеВзыскания,
	               |	УдержанияСРаспределением.ДатаНачала КАК ДатаНачала,
	               |	УдержанияСРаспределением.Сумма КАК Сумма
	               |ПОМЕСТИТЬ ВТУдержанияСРаспределением
	               |ИЗ
	               |	&УдержанияСРаспределением КАК УдержанияСРаспределением
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	УдержанияСРаспределением.СтатьяФинансирования КАК СтатьяФинансирования,
	               |	УдержанияСРаспределением.СтатьяРасходов КАК СтатьяРасходов,
	               |	УдержанияСРаспределением.ДокументОснование КАК ИсполнительныйДокумент,
	               |	УдержанияСРаспределением.Получатель КАК Получатель,
	               |	УдержанияСРаспределением.ПлатежныйАгент КАК ПлатежныйАгент,
	               |	УдержанияСРаспределением.ОграничениеВзыскания КАК ОграничениеВзыскания,
	               |	НАЧАЛОПЕРИОДА(УдержанияСРаспределением.ДатаНачала, МЕСЯЦ) КАК МесяцУдержания,
	               |	СУММА(ВЫБОР
	               |			КОГДА Удержания.КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ИсполнительныйЛист)
	               |				ТОГДА УдержанияСРаспределением.Сумма
	               |			ИНАЧЕ 0
	               |		КОНЕЦ) КАК СуммаУдержания,
	               |	СУММА(ВЫБОР
	               |			КОГДА Удержания.КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ВознаграждениеПлатежногоАгента)
	               |				ТОГДА УдержанияСРаспределением.Сумма
	               |			ИНАЧЕ 0
	               |		КОНЕЦ) КАК СуммаВознагражденияПлатежногоАгента
	               |ИЗ
	               |	ВТУдержанияСРаспределением КАК УдержанияСРаспределением
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовРасчета.Удержания КАК Удержания
	               |		ПО УдержанияСРаспределением.Удержание = Удержания.Ссылка
	               |			И (Удержания.КатегорияУдержания В (ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ИсполнительныйЛист), ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ВознаграждениеПлатежногоАгента)))
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	УдержанияСРаспределением.СтатьяФинансирования,
	               |	УдержанияСРаспределением.СтатьяРасходов,
	               |	УдержанияСРаспределением.ДокументОснование,
	               |	УдержанияСРаспределением.Получатель,
	               |	УдержанияСРаспределением.ПлатежныйАгент,
	               |	УдержанияСРаспределением.ОграничениеВзыскания,
	               |	НАЧАЛОПЕРИОДА(УдержанияСРаспределением.ДатаНачала, МЕСЯЦ)
	               |
	               |ИМЕЮЩИЕ
	               |	(СУММА(ВЫБОР
	               |				КОГДА Удержания.КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ИсполнительныйЛист)
	               |					ТОГДА УдержанияСРаспределением.Сумма
	               |				ИНАЧЕ 0
	               |			КОНЕЦ) <> 0
	               |		ИЛИ СУММА(ВЫБОР
	               |				КОГДА Удержания.КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ВознаграждениеПлатежногоАгента)
	               |					ТОГДА УдержанияСРаспределением.Сумма
	               |				ИНАЧЕ 0
	               |			КОНЕЦ) <> 0)";
		
	РезультатЗапроса = Запрос.Выполнить();
	ДанныеДляПроведения.УдержанияПоИсполнительнымДокументам = РезультатЗапроса.Выгрузить();
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли