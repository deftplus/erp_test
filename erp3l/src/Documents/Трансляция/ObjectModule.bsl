Перем НеОбрабатыватьПроведение Экспорт;

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ИмяРегистраИсточник=РегистрБухгалтерииИсточник.Наименование;
	
	Если ПометкаУдаления <> Ссылка.ПометкаУдаления 
		И (НаправлениеТрансляции=Перечисления.НаправленияТрансляцииДанных.ПоказателиВПоказатели
		ИЛИ НаправлениеТрансляции=Перечисления.НаправленияТрансляцииДанных.РегистрБухгалтерииВПоказатели) Тогда
		
		Если ПометкаУдаления Тогда
			
			УправлениеОтчетамиУХ.ОчиститьЗначенияПоказателейОтчетов(Ссылка,Отказ);
			
		КонецЕсли;
		
		Если Отказ Тогда
			
			Возврат;
			
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВерсииЗначенийПоказателей.Владелец КАК ОписаниеВерсии
		|ИЗ
		|	Справочник.ВерсииЗначенийПоказателей КАК ВерсииЗначенийПоказателей
		|ГДЕ
		|	ВерсииЗначенийПоказателей.Регистратор = &ТекОперация";
		
		Запрос.УстановитьПараметр("ТекОперация", Ссылка);
		Запрос.УстановитьПараметр("ПометкаУдаления", НЕ ПометкаУдаления);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			Выборка.ОписаниеВерсии.ПолучитьОбъект().УстановитьПометкуУдаления(ПометкаУдаления, Истина);
		КонецЦикла;	
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если ОбменДанными.Загрузка ИЛИ НеОбрабатыватьПроведение Тогда
		Возврат;
	КонецЕсли;
			
	Обработки.КорректировкиЗначенийПоказателей.ОбработкаПроведенияОбъекта(ЭтотОбъект,РежимПроведения,Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если НаправлениеТрансляции=Перечисления.НаправленияТрансляцииДанных.ПоказателиВПоказатели
		ИЛИ НаправлениеТрансляции=Перечисления.НаправленияТрансляцииДанных.РегистрБухгалтерииВПоказатели Тогда
		
		УправлениеОтчетамиУХ.ОчиститьЗначенияПоказателейОтчетов(Ссылка,Отказ);
		
	КонецЕсли;
			
КонецПроцедуры

НеОбрабатыватьПроведение=Ложь;
