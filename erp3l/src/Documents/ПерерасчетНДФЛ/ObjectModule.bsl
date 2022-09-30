#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ДанныеДляПроведения = ПолучитьДанныеДляПроведения();
	
	УчетНДФЛ.СформироватьНалогиВычеты(Движения, Отказ, Организация, КонецМесяца(МесяцПерерасчета), ДанныеДляПроведения.НалогиВычеты, , , Дата(НалоговыйПериод + 1, 1, 1));
	
	// Заполним описание данных для проведения в учете начисленной зарплаты.
	ДанныеДляПроведенияУчетЗарплаты = ОтражениеЗарплатыВУчете.ОписаниеДанныеДляПроведения();
	ДанныеДляПроведенияУчетЗарплаты.Движения 				= Движения;
	ДанныеДляПроведенияУчетЗарплаты.Организация 			= Организация;
	ДанныеДляПроведенияУчетЗарплаты.ПериодРегистрации 		= МесяцПерерасчета;
	ДанныеДляПроведенияУчетЗарплаты.ПорядокВыплаты 			= Перечисления.ХарактерВыплатыЗарплаты.Зарплата;
	ДанныеДляПроведенияУчетЗарплаты.ОкончательныйРасчет 	= Истина;

	УчетНачисленнойЗарплаты.ПодготовитьДанныеНДФЛКРегистрации(ДанныеДляПроведения.РезультатыРасчетаНДФЛ, Организация, КонецМесяца(МесяцПерерасчета));
	УчетНачисленнойЗарплаты.ЗарегистрироватьПерерасчетНДФЛ(ДанныеДляПроведенияУчетЗарплаты, Отказ, ДанныеДляПроведения.РезультатыРасчетаНДФЛ, ДанныеДляПроведения.КорректировкиВыплаты);
	
	ДанныеДляПроведения = ОтражениеЗарплатыВУчете.НоваяСтруктураРезультатыРасчетаЗарплаты();
	ДанныеДляПроведения.НачисленияУдержания = Движения.НачисленияУдержанияПоСотрудникам.Выгрузить();
	СтрокаСписокТаблиц = "НачисленныйНДФЛ";
	ОтражениеЗарплатыВБухучете.СформироватьДвиженияПоДокументу(Движения, Отказ, Организация, НачалоМесяца(МесяцПерерасчета), ДанныеДляПроведения, СтрокаСписокТаблиц);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого СтрокаСотрудника Из Сотрудники Цикл
		
		СуммаВычетовНаДетейИИмущественных = ПримененныеВычетыНаДетейИИмущественные.Выгрузить(
			Новый Структура("ИдентификаторСтрокиНДФЛ", СтрокаСотрудника.ИдентификаторСтрокиНДФЛ), "РазмерВычета").Итог("РазмерВычета");
		
			Если СтрокаСотрудника.НалогПоСтавке09 * СтрокаСотрудника.НалогПоСтавке09 
				+ СтрокаСотрудника.НалогПоСтавке13 * СтрокаСотрудника.НалогПоСтавке13 
				+ СтрокаСотрудника.НалогСПревышенияПоСтавке13 * СтрокаСотрудника.НалогСПревышенияПоСтавке13 
				+ СтрокаСотрудника.НалогПоСтавке35 * СтрокаСотрудника.НалогПоСтавке35
				+ СтрокаСотрудника.ЗачтеноАвансовыхПлатежейПоСтавке09 * СтрокаСотрудника.ЗачтеноАвансовыхПлатежейПоСтавке09
				+ СтрокаСотрудника.ЗачтеноАвансовыхПлатежейПоСтавке13 * СтрокаСотрудника.ЗачтеноАвансовыхПлатежейПоСтавке13
				+ СтрокаСотрудника.ЗачтеноАвансовыхПлатежейСПревышенияПоСтавке13 * СтрокаСотрудника.ЗачтеноАвансовыхПлатежейСПревышенияПоСтавке13
				+ СтрокаСотрудника.ЗачтеноАвансовыхПлатежейПоСтавке35 * СтрокаСотрудника.ЗачтеноАвансовыхПлатежейПоСтавке35
				+ СтрокаСотрудника.ПримененныйВычетЛичный * СтрокаСотрудника.ПримененныйВычетЛичный
				+ СтрокаСотрудника.ПримененныйВычетЛичныйКЗачетуВозврату * СтрокаСотрудника.ПримененныйВычетЛичныйКЗачетуВозврату
				+ СуммаВычетовНаДетейИИмущественных * СуммаВычетовНаДетейИИмущественных = 0 Тогда
			
			НалогКЗачетуВозврату = 0;
			НайденныеСтроки = КорректировкиВыплаты.НайтиСтроки(Новый Структура("ФизическоеЛицо", СтрокаСотрудника.Сотрудник));
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				НалогКЗачетуВозврату = НалогКЗачетуВозврату + НайденнаяСтрока.КорректировкаВыплаты;
			КонецЦикла;
			
			Если НалогКЗачетуВозврату = 0 Тогда
				СообщениеОбОшибке = СтрШаблон(
					НСтр("ru = 'В строке №%1 не указаны суммы перерасчета налога.';
						|en = 'Tax recalculation amount is not specified in line No. %1.'"), 
					СтрокаСотрудника.НомерСтроки);
				ОбщегоНазначения.СообщитьПользователю(СообщениеОбОшибке,,,,Отказ);
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДанныеДляПроведения()
	
	СписокФизическихЛиц = Неопределено;
	Если ДополнительныеСвойства.Свойство("ФизическиеЛица")
		И ДополнительныеСвойства.ФизическиеЛица.Количество() > 0 Тогда
		
		СписокФизическихЛиц = ДополнительныеСвойства.ФизическиеЛица;
		ОтборПоФизическимЛицам = Истина;
		
	Иначе
		ОтборПоФизическимЛицам = Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПерерасчетНДФЛСотрудники.Ссылка КАК Ссылка,
	|	ПерерасчетНДФЛСотрудники.НомерСтроки КАК НомерСтроки,
	|	ПерерасчетНДФЛСотрудники.ОбособленноеПодразделение КАК Подразделение,
	|	ПерерасчетНДФЛСотрудники.Сотрудник КАК ФизическоеЛицо,
	|	ПерерасчетНДФЛСотрудники.МесяцНалоговогоПериода КАК МесяцНалоговогоПериода,
	|	ПерерасчетНДФЛСотрудники.КатегорияДохода КАК КатегорияДохода,
	|	ПерерасчетНДФЛСотрудники.НалогПоСтавке09 КАК НалогПоСтавке09,
	|	ПерерасчетНДФЛСотрудники.НалогПоСтавке13 КАК НалогПоСтавке13,
	|	ПерерасчетНДФЛСотрудники.НалогПоСтавке35 КАК НалогПоСтавке35,
	|	ПерерасчетНДФЛСотрудники.НалогПоСтавке13 КАК Налог,
	|	ПерерасчетНДФЛСотрудники.ПримененныйВычетЛичный КАК ПримененныйВычетЛичный,
	|	ПерерасчетНДФЛСотрудники.ПримененныйВычетЛичныйКодВычета КАК ПримененныйВычетЛичныйКодВычета,
	|	ПерерасчетНДФЛСотрудники.ПримененныйВычетЛичныйКЗачетуВозврату КАК ПримененныйВычетЛичныйКЗачетуВозврату,
	|	ПерерасчетНДФЛСотрудники.ПримененныйВычетЛичныйКЗачетуВозвратуКодВычета КАК ПримененныйВычетЛичныйКЗачетуВозвратуКодВычета,
	|	ПерерасчетНДФЛСотрудники.ИдентификаторСтрокиНДФЛ КАК ИдентификаторСтрокиНДФЛ,
	|	ПерерасчетНДФЛСотрудники.ЗачтеноАвансовыхПлатежейПоСтавке09 КАК ЗачтеноАвансовыхПлатежейПоСтавке09,
	|	ПерерасчетНДФЛСотрудники.ЗачтеноАвансовыхПлатежейПоСтавке13 КАК ЗачтеноАвансовыхПлатежейПоСтавке13,
	|	ПерерасчетНДФЛСотрудники.ЗачтеноАвансовыхПлатежейПоСтавке13 КАК ЗачтеноАвансовыхПлатежей,
	|	ПерерасчетНДФЛСотрудники.ЗачтеноАвансовыхПлатежейПоСтавке35 КАК ЗачтеноАвансовыхПлатежейПоСтавке35,
	|	ПерерасчетНДФЛСотрудники.НалогСПревышенияПоСтавке13 КАК НалогСПревышенияПоСтавке13,
	|	ПерерасчетНДФЛСотрудники.НалогСПревышенияПоСтавке13 КАК НалогСПревышения,
	|	ПерерасчетНДФЛСотрудники.ЗачтеноАвансовыхПлатежейСПревышенияПоСтавке13 КАК ЗачтеноАвансовыхПлатежейСПревышения,
	|	ПерерасчетНДФЛСотрудники.ЗачтеноАвансовыхПлатежейСПревышенияПоСтавке13 КАК ЗачтеноАвансовыхПлатежейСПревышенияПоСтавке13
	|ПОМЕСТИТЬ ВТСтрокиДокумента
	|ИЗ
	|	Документ.ПерерасчетНДФЛ.Сотрудники КАК ПерерасчетНДФЛСотрудники
	|ГДЕ
	|	ПерерасчетНДФЛСотрудники.Ссылка = &Ссылка
	|	И ПерерасчетНДФЛСотрудники.Сотрудник В(&ФизическиеЛица)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтрокиДокумента.Подразделение КАК Подразделение,
	|	СтрокиДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СтрокиДокумента.МесяцНалоговогоПериода КАК МесяцНалоговогоПериода,
	|	СтрокиДокумента.НалогПоСтавке09 КАК НалогПоСтавке09,
	|	СтрокиДокумента.НалогПоСтавке35 КАК НалогПоСтавке35,
	|	СтрокиДокумента.ЗачтеноАвансовыхПлатежейПоСтавке09 КАК ЗачтеноАвансовыхПлатежейПоСтавке09,
	|	СтрокиДокумента.ЗачтеноАвансовыхПлатежейПоСтавке35 КАК ЗачтеноАвансовыхПлатежейПоСтавке35,
	|	СтрокиДокумента.ИдентификаторСтрокиНДФЛ КАК ИдентификаторСтроки
	|ИЗ
	|	ВТСтрокиДокумента КАК СтрокиДокумента
	|ГДЕ
	|	(СтрокиДокумента.НалогПоСтавке35 <> 0
	|			ИЛИ СтрокиДокумента.НалогПоСтавке09 <> 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка) КАК Сотрудник,
	|	ДанныеДокумента.ВидУдержания КАК ВидУдержания,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиФинансированияЗарплата.ПустаяСсылка) КАК СтатьяФинансирования,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиРасходовЗарплата.ПустаяСсылка) КАК СтатьяРасходов,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыДоходовИсполнительногоПроизводства.ПустаяСсылка) КАК ВидДоходаИсполнительногоПроизводства,
	|	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ДанныеДокумента.МесяцНалоговогоПериода КАК МесяцНалоговогоПериода,
	|	ДанныеДокумента.КатегорияДохода КАК КатегорияДохода,
	|	СУММА(ДанныеДокумента.Сумма) КАК Сумма
	|ИЗ
	|	(ВЫБРАТЬ
	|		СтрокиДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
	|		ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛ) КАК ВидУдержания,
	|		СтрокиДокумента.МесяцНалоговогоПериода КАК МесяцНалоговогоПериода,
	|		СтрокиДокумента.КатегорияДохода КАК КатегорияДохода,
	|		СтрокиДокумента.Подразделение КАК Подразделение,
	|		СтрокиДокумента.НалогПоСтавке13 - СтрокиДокумента.ЗачтеноАвансовыхПлатежейПоСтавке13 КАК Сумма
	|	ИЗ
	|		ВТСтрокиДокумента КАК СтрокиДокумента
	|	ГДЕ
	|		СтрокиДокумента.НалогПоСтавке13 - СтрокиДокумента.ЗачтеноАвансовыхПлатежейПоСтавке13 <> 0
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СтрокиДокумента.ФизическоеЛицо,
	|		ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛСПревышения),
	|		СтрокиДокумента.МесяцНалоговогоПериода,
	|		СтрокиДокумента.КатегорияДохода,
	|		СтрокиДокумента.Подразделение,
	|		СтрокиДокумента.НалогСПревышенияПоСтавке13 - СтрокиДокумента.ЗачтеноАвансовыхПлатежейСПревышенияПоСтавке13
	|	ИЗ
	|		ВТСтрокиДокумента КАК СтрокиДокумента
	|	ГДЕ
	|		СтрокиДокумента.НалогСПревышенияПоСтавке13 - СтрокиДокумента.ЗачтеноАвансовыхПлатежейПоСтавке13 <> 0
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СтрокиДокумента.ФизическоеЛицо,
	|		ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛ),
	|		СтрокиДокумента.МесяцНалоговогоПериода,
	|		СтрокиДокумента.КатегорияДохода,
	|		СтрокиДокумента.Подразделение,
	|		СтрокиДокумента.НалогПоСтавке09 - СтрокиДокумента.ЗачтеноАвансовыхПлатежейПоСтавке09
	|	ИЗ
	|		ВТСтрокиДокумента КАК СтрокиДокумента
	|	ГДЕ
	|		СтрокиДокумента.НалогПоСтавке09 - СтрокиДокумента.ЗачтеноАвансовыхПлатежейПоСтавке09 <> 0
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СтрокиДокумента.ФизическоеЛицо,
	|		ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛ),
	|		СтрокиДокумента.МесяцНалоговогоПериода,
	|		СтрокиДокумента.КатегорияДохода,
	|		СтрокиДокумента.Подразделение,
	|		СтрокиДокумента.НалогПоСтавке35 - СтрокиДокумента.ЗачтеноАвансовыхПлатежейПоСтавке35
	|	ИЗ
	|		ВТСтрокиДокумента КАК СтрокиДокумента
	|	ГДЕ
	|		СтрокиДокумента.НалогПоСтавке35 - СтрокиДокумента.ЗачтеноАвансовыхПлатежейПоСтавке35 <> 0) КАК ДанныеДокумента
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокумента.ФизическоеЛицо,
	|	ДанныеДокумента.МесяцНалоговогоПериода,
	|	ДанныеДокумента.КатегорияДохода,
	|	ДанныеДокумента.Подразделение,
	|	ДанныеДокумента.ВидУдержания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка) КАК Сотрудник,
	|	ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиФинансированияЗарплата.ПустаяСсылка) КАК СтатьяФинансирования,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиРасходовЗарплата.ПустаяСсылка) КАК СтатьяРасходов,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыДоходовИсполнительногоПроизводства.ПустаяСсылка) КАК ВидДоходаИсполнительногоПроизводства,
	|	ПерерасчетНДФЛКорректировкиВыплаты.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ПерерасчетНДФЛКорректировкиВыплаты.КорректировкаВыплаты КАК КорректировкаВыплаты
	|ИЗ
	|	Документ.ПерерасчетНДФЛ.КорректировкиВыплаты КАК ПерерасчетНДФЛКорректировкиВыплаты
	|ГДЕ
	|	ПерерасчетНДФЛКорректировкиВыплаты.Ссылка = &Ссылка
	|	И ПерерасчетНДФЛКорректировкиВыплаты.ФизическоеЛицо В(&ФизическиеЛица)";
	
	Если ОтборПоФизическимЛицам Тогда
		Запрос.УстановитьПараметр("ФизическиеЛица", СписокФизическихЛиц);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ПерерасчетНДФЛСотрудники.Сотрудник В(&ФизическиеЛица)", "");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ПерерасчетНДФЛКорректировкиВыплаты.ФизическоеЛицо В(&ФизическиеЛица)", "");
	КонецЕсли;
	
	Результаты = Запрос.ВыполнитьПакет();
	
	ОписаниеТаблиц = Новый Структура("ИмяТаблицыСНалогами,ИмяТаблицыСВычетами", "ВТСтрокиДокумента", "Документ.ПерерасчетНДФЛ.ПримененныеВычетыНаДетейИИмущественные");
	НалогиВычеты = УчетНДФЛ.ДанныеДокументаОНалогеПоОсновнойСтавкеИВычетах(Ссылка, ОписаниеТаблиц, Запрос.МенеджерВременныхТаблиц);
	Если Не Результаты[1].Пустой() Тогда
		НалогиВычеты.Колонки.Добавить("НалогПоСтавке09", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(13, 0)));
		НалогиВычеты.Колонки.Добавить("НалогПоСтавке35", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(13, 0)));
		НалогиВычеты.Колонки.Добавить("ЗачтеноАвансовыхПлатежейПоСтавке09", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(13, 0)));
		НалогиВычеты.Колонки.Добавить("ЗачтеноАвансовыхПлатежейПоСтавке35", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(13, 0)));
		НалогиВычеты.Индексы.Добавить("ИдентификаторСтроки");
		Выборка = Результаты[1].Выбрать();
		СтруктураПоиска = Новый Структура;
		Пока Выборка.Следующий() Цикл
			СтруктураПоиска.Вставить("ИдентификаторСтроки", Выборка.ИдентификаторСтроки);
			МассивСтрок = НалогиВычеты.НайтиСтроки(СтруктураПоиска);
			Для каждого Строка Из МассивСтрок Цикл
				ЗаполнитьЗначенияСвойств(Строка, Выборка);
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	ДанныеДляПроведения = Новый Структура;
	ДанныеДляПроведения.Вставить("НалогиВычеты", 			НалогиВычеты);
	ДанныеДляПроведения.Вставить("РезультатыРасчетаНДФЛ", 	Результаты[2].Выгрузить());
	ДанныеДляПроведения.Вставить("КорректировкиВыплаты",  	Результаты[3].Выгрузить());
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли