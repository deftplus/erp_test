#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ЗарплатаКадрыРасширенный.ИнициализироватьОтложеннуюРегистрациюВторичныхДанныхПоДвижениямДокумента(Движения);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(Движения, ДанныеДляПроведения.СотрудникиДаты, Ссылка);
	
	РазрядыКатегорииДолжностей.СформироватьДвиженияРазрядовКатегорийСотрудников(Движения, ДанныеДляПроведения.РазрядыКатегорииСотрудников);
	
	Если НачисленияУтверждены Тогда
		
		СтруктураПлановыхНачислений = Новый Структура;
		СтруктураПлановыхНачислений.Вставить("ДанныеОПлановыхНачислениях", ДанныеДляПроведения.ПлановыеНачисления);
		СтруктураПлановыхНачислений.Вставить("ЗначенияПоказателей", ДанныеДляПроведения.ЗначенияПоказателейНачислений);
		
		РасчетЗарплаты.СформироватьДвиженияПлановыхНачислений(ЭтотОбъект, Движения, СтруктураПлановыхНачислений);
		
		УчетСреднегоЗаработка.ЗарегистрироватьДанныеКоэффициентовИндексации(Движения, ДанныеДляПроведения.КоэффициентыИндексации);
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба.РасчетДенежногоСодержания") Тогда		
			Модуль = ОбщегоНазначения.ОбщийМодуль("РасчетДенежногоСодержания");
			Модуль.ЗарегистрироватьКоэффициентыИндексацииДенежногоСодержания(Движения, ДанныеДляПроведения.КоэффициентыИндексацииДенежногоСодержания);
		КонецЕсли;
		
	КонецЕсли; 
	
	ПараметрыФормирования = ЭлектронныеТрудовыеКнижки.ПараметрыФормированияДвиженийМероприятийТрудовойДеятельности();
	ПараметрыФормирования.ДополнитьСведениямиОЗанятости = Истина;
	ПараметрыФормирования.ДополнитьСведениямиОДолжности = Истина;
	ПараметрыФормирования.ПолучатьИсточникДанныхОТерриториальныхУсловиях = Истина;
	ПараметрыФормирования.ДополнитьСведениямиОТерриториальныхУсловиях = Истина;
	ПараметрыФормирования.ДополнитьСведениямиОКодахПоОКЗ = Истина;
	
	ЭлектронныеТрудовыеКнижки.СформироватьДвиженияМероприятийТрудовойДеятельности(
		Движения.МероприятияТрудовойДеятельности,
		ДанныеДляПроведения.МероприятияТрудовойДеятельности,
		ПараметрыФормирования);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаИзменения, "Объект.ДатаИзменения", Отказ, НСтр("ru = 'Дата изменения';
																										|en = 'Change date'"), , , Ложь);
	ЭлектронныеТрудовыеКнижки.ПроверитьЗаполнениеКодаОКЗТрудовойФункции(ЭтотОбъект, "ДатаИзменения", Отказ);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	ДанныеДляПроведения = Новый Структура; 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Если НачисленияУтверждены Тогда
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Начисления.Ссылка.ДатаИзменения КАК ДатаСобытия,
			|	Начисления.Ссылка.Сотрудник КАК Сотрудник,
			|	Начисления.Начисление КАК Начисление,
			|	Начисления.Ссылка.ФизическоеЛицо КАК ФизическоеЛицо,
			|	Начисления.Ссылка.Сотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
			|	Начисления.ДокументОснование КАК ДокументОснование,
			|	ИСТИНА КАК Используется,
			|	Начисления.Размер КАК Размер
			|ИЗ
			|	Документ.ИзменениеКвалификационногоРазряда.Начисления КАК Начисления
			|ГДЕ
			|	Начисления.Ссылка = &Ссылка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ИзменениеКвалификационногоРазрядаНачисления.ДокументОснование,
			|	НачисленияПоказатели.Показатель
			|ПОМЕСТИТЬ ВТПоказателиНачисленийДокумента
			|ИЗ
			|	Документ.ИзменениеКвалификационногоРазряда.Начисления КАК ИзменениеКвалификационногоРазрядаНачисления
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовРасчета.Начисления.Показатели КАК НачисленияПоказатели
			|		ПО ИзменениеКвалификационногоРазрядаНачисления.Начисление = НачисленияПоказатели.Ссылка
			|			И (ИзменениеКвалификационногоРазрядаНачисления.Ссылка = &Ссылка)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ИзменениеКвалификационногоРазряда.ДатаИзменения КАК ДатаСобытия,
			|	ИзменениеКвалификационногоРазряда.Организация КАК Организация,
			|	ИзменениеКвалификационногоРазряда.Сотрудник КАК Сотрудник,
			|	ИзменениеКвалификационногоРазряда.ФизическоеЛицо КАК ФизическоеЛицо,
			|	ИзменениеКвалификационногоРазряда.Показатель КАК Показатель,
			|	ПоказателиНачисленийДокумента.ДокументОснование КАК ДокументОснование,
			|	ИзменениеКвалификационногоРазряда.ЗначениеПоказателя КАК Значение
			|ИЗ
			|	Документ.ИзменениеКвалификационногоРазряда КАК ИзменениеКвалификационногоРазряда
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиНачисленийДокумента КАК ПоказателиНачисленийДокумента
			|		ПО ИзменениеКвалификационногоРазряда.Показатель = ПоказателиНачисленийДокумента.Показатель
			|			И (ИзменениеКвалификационногоРазряда.Ссылка = &Ссылка)
			|			И (ИзменениеКвалификационногоРазряда.Показатель <> ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.ПустаяСсылка))
			|ГДЕ
			|	ИзменениеКвалификационногоРазряда.Ссылка = &Ссылка
			|	И ИзменениеКвалификационногоРазряда.Показатель <> ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.ПустаяСсылка)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ИзменениеКвалификационногоРазряда.ДатаИзменения КАК ДатаСобытия,
			|	ИзменениеКвалификационногоРазряда.Сотрудник КАК Сотрудник,
			|	ИзменениеКвалификационногоРазряда.ФизическоеЛицо КАК ФизическоеЛицо,
			|	ИзменениеКвалификационногоРазряда.СовокупнаяТарифнаяСтавка КАК Значение,
			|	ВЫБОР
			|		КОГДА ИзменениеКвалификационногоРазряда.СовокупнаяТарифнаяСтавка = 0
			|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыТарифныхСтавок.ПустаяСсылка)
			|		ИНАЧЕ ИзменениеКвалификационногоРазряда.ВидТарифнойСтавки
			|	КОНЕЦ КАК ВидТарифнойСтавки,
			|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
			|ИЗ
			|	Документ.ИзменениеКвалификационногоРазряда КАК ИзменениеКвалификационногоРазряда
			|ГДЕ
			|	ИзменениеКвалификационногоРазряда.Ссылка = &Ссылка";
		РезультатыЗапроса = Запрос.ВыполнитьПакет();
		
		ПлановыеНачисления = РезультатыЗапроса[0].Выгрузить();
		ДанныеДляПроведения.Вставить("ПлановыеНачисления", ПлановыеНачисления);
		
		ЗначенияПоказателей = РезультатыЗапроса[2].Выгрузить();
		ДанныеДляПроведения.Вставить("ЗначенияПоказателейНачислений", ЗначенияПоказателей);
		
		ДанныеСовокупныхТарифныхСтавок = РезультатыЗапроса[3].Выгрузить();
		ДанныеДляПроведения.Вставить("ДанныеСовокупныхТарифныхСтавок", ДанныеСовокупныхТарифныхСтавок);
		
	КонецЕсли;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИзменениеКвалификационногоРазряда.ДатаИзменения КАК ДатаСобытия,
		|	ИзменениеКвалификационногоРазряда.Сотрудник КАК Сотрудник,
		|	ИзменениеКвалификационногоРазряда.РазрядКатегория КАК РазрядКатегория,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
		|ИЗ
		|	Документ.ИзменениеКвалификационногоРазряда КАК ИзменениеКвалификационногоРазряда
		|ГДЕ
		|	ИзменениеКвалификационногоРазряда.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИзменениеКвалификационногоРазряда.ДатаИзменения КАК ДатаСобытия,
		|	ИзменениеКвалификационногоРазряда.Сотрудник КАК Сотрудник
		|ИЗ
		|	Документ.ИзменениеКвалификационногоРазряда КАК ИзменениеКвалификационногоРазряда
		|ГДЕ
		|	ИзменениеКвалификационногоРазряда.Ссылка = &Ссылка";
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	РазрядыКатегорииСотрудников = РезультатыЗапроса[0].Выгрузить();
	ДанныеДляПроведения.Вставить("РазрядыКатегорииСотрудников", РазрядыКатегорииСотрудников);
	
	СотрудникиДаты = РезультатыЗапроса[1].Выгрузить();
	ДанныеДляПроведения.Вставить("СотрудникиДаты", СотрудникиДаты);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИзменениеКвалификационногоРазряда.ДатаИзменения КАК Период,
		|	ИзменениеКвалификационногоРазряда.Сотрудник КАК Сотрудник,
		|	ИзменениеКвалификационногоРазряда.КоэффициентИндексации КАК Коэффициент
		|ИЗ
		|	Документ.ИзменениеКвалификационногоРазряда КАК ИзменениеКвалификационногоРазряда
		|ГДЕ
		|	ИзменениеКвалификационногоРазряда.Ссылка = &Ссылка
		|	И ИзменениеКвалификационногоРазряда.УчитыватьКакИндексациюЗаработка";
	
	КоэффициентыИндексации = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("КоэффициентыИндексации", КоэффициентыИндексации);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба.РасчетДенежногоСодержания") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("РасчетДенежногоСодержания");
		КоэффициентыИндексацииДокумента = Модуль.ПолучитьТаблицуИндексацииДокумента(Ссылка);
		КоэффициентыИндексацииДенежногоСодержания = Модуль.ТаблицаКоэффициентовИндексацииДенежногоСодержанияСотрудников(КоэффициентыИндексацииДокумента);
		ДанныеДляПроведения.Вставить("КоэффициентыИндексацииДенежногоСодержания", КоэффициентыИндексацииДенежногоСодержания);
	КонецЕсли;
	
	ДанныеДляПроведения.Вставить("МероприятияТрудовойДеятельности",
		Документы.ИзменениеКвалификационногоРазряда.ДанныеДляПроведенияМероприятияТрудовойДеятельности(Ссылка).Получить(Ссылка));
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли