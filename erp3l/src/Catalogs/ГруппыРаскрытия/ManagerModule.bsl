Функция ЧислоЗаполненныхАналитик(Ссылка) Экспорт
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ГруппыРаскрытия.ВидАналитики1 = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоКорпоративные.ПустаяСсылка)
	|				И ГруппыРаскрытия.Владелец.ВидАналитики1 = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоКорпоративные.ПустаяСсылка)
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ + ВЫБОР
	|		КОГДА ГруппыРаскрытия.ВидАналитики2 = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоКорпоративные.ПустаяСсылка)
	|				И ГруппыРаскрытия.Владелец.ВидАналитики2 = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоКорпоративные.ПустаяСсылка)
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ + ВЫБОР
	|		КОГДА ГруппыРаскрытия.ВидАналитики3 = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоКорпоративные.ПустаяСсылка)
	|				И ГруппыРаскрытия.Владелец.ВидАналитики3 = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоКорпоративные.ПустаяСсылка)
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ + ВЫБОР
	|		КОГДА ГруппыРаскрытия.ВидАналитики4 = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоКорпоративные.ПустаяСсылка)
	|				И ГруппыРаскрытия.Владелец.ВидАналитики4 = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоКорпоративные.ПустаяСсылка)
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ + ВЫБОР
	|		КОГДА ГруппыРаскрытия.ВидАналитики5 = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоКорпоративные.ПустаяСсылка)
	|				И ГруппыРаскрытия.Владелец.ВидАналитики5 = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоКорпоративные.ПустаяСсылка)
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ + ВЫБОР
	|		КОГДА ГруппыРаскрытия.ВидАналитики6 = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоКорпоративные.ПустаяСсылка)
	|				И ГруппыРаскрытия.Владелец.ВидАналитики6 = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоКорпоративные.ПустаяСсылка)
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ЧислоАналитик
	|ИЗ
	|	Справочник.ГруппыРаскрытия КАК ГруппыРаскрытия
	|ГДЕ
	|	ГруппыРаскрытия.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		
		Возврат Результат.ЧислоАналитик;
		
	Иначе
		
		Возврат 0;
		
	КонецЕсли;
		
КонецФункции // ЧислоЗаполненныхАналитик()

Функция ПолучитьГруппуРаскрытияВалюта(Показатель) Экспорт
	
	ГруппаРаскрытия 	= Показатель.ГруппаРаскрытия;
	
	Если ЗначениеЗаполнено(ГруппаРаскрытия) Тогда
		
		ТекущийОбъект=ГруппаРаскрытия.ПолучитьОбъект();
		
	Иначе
		
		ТекущийОбъект=Справочники.ГруппыРаскрытия.СоздатьЭлемент();
		ТекущийОбъект.Владелец=Показатель.Владелец;
		ТекущийОбъект.Наименование	= "Валюта";
		ТекущийОбъект.Код			= ОбщегоНазначенияУХ.ПолучитьВозможныйКодСправочника("Валюта",Метаданные.Справочники.ГруппыРаскрытия.ДлинаКода,"ГруппыРаскрытия",ТекущийОбъект.Владелец);
		
	КонецЕсли;
	
	ТекущийОбъект.Валютная=Истина;
	ТекущийОбъект.ВидАналитикиВалютаДт = ПланыВидовХарактеристик.ВидыСубконтоКорпоративные.СправочникВалюты;
	
	Попытка
		
		ТекущийОбъект.Записать();
		Возврат ТекущийОбъект.Ссылка;
		
	Исключение
		
		СтрокаШаблона = Нстр("ru = 'Не удалось получить валютную группу раскрытия для показателя %1'");
		
		ТекстОшибки = "";
		Если Не ПустаяСтрока(СтрокаШаблона) тогда								
			ТекстОшибки = СтрШаблон(СтрокаШаблона, Показатель.Наименование);
		КонецЕсли;
		
		ПротоколируемыеСобытияВызовСервераУХ.ДобавитьЗаписьОшибка("Справочники.ГруппыРаскрытия.МодульМенеджера",,, ТекстОшибки);
		
		Возврат ТекстОшибки;
		
	КонецПопытки;
	
КонецФункции // ПолучитьГруппуРаскрытияВалюта() 

Функция ПроверитьИдентичностьВидовАналитик(ГруппаРаскрытияНов,ГруппаРаскрытияСтар) Экспорт
	
	Если ТипЗнч(ГруппаРаскрытияСтар)=Тип("СправочникСсылка.ГруппыРаскрытия") 
		И ТипЗнч(ГруппаРаскрытияНов)=Тип("СправочникСсылка.ГруппыРаскрытия") Тогда
		
		Если ЗначениеЗаполнено(ГруппаРаскрытияСтар) И (НЕ ЗначениеЗаполнено(ГруппаРаскрытияНов)) Тогда
			
			Возврат ЛОжь;
			
		КонецЕсли;
				
	КонецЕсли;
		
	Если ГруппаРаскрытияСтар.Валютная Тогда
		
		Если НЕ ГруппаРаскрытияНов.Валютная Тогда
			
			Возврат Ложь;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ГруппаРаскрытияСтар.ВидАналитикиВалютаКт) 
			И (НЕ ЗначениеЗаполнено(ГруппаРаскрытияНов.ВидАналитикиВалютаКт)) Тогда 
			
			Возврат Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	МаксАналитик=?(ПараметрыСеанса.ЧислоДопАналитик<6,6,ПараметрыСеанса.ЧислоДопАналитик);
	
	Для Индекс=1 По МаксАналитик Цикл
		
		Если НЕ ЗначениеЗаполнено(ГруппаРаскрытияСтар["ВидАналитики"+Индекс]) Тогда
			
			Прервать;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ГруппаРаскрытияНов["ВидАналитики"+Индекс]) Тогда
			
			Возврат Ложь;
			
		КонецЕсли;
				
		Если ГруппаРаскрытияСтар["ВидАналитики"+Индекс].ТипЗначения.Типы()[0]=Тип("СправочникСсылка.ПроизвольныйКлассификаторУХ") 			
			И (НЕ ГруппаРаскрытияСтар["ВидАналитики"+Индекс]=ГруппаРаскрытияНов["ВидАналитики"+Индекс]) Тогда
			
			Возврат Ложь;
			
		КонецЕсли;
		
		Если НЕ ГруппаРаскрытияСтар["ВидАналитики"+Индекс].ТипЗначения.Типы()[0]=ГруппаРаскрытияНов["ВидАналитики"+Индекс].ТипЗначения.Типы()[0] Тогда
			
			Возврат Ложь;
			
		КонецЕсли;
				
	КонецЦикла;
	
	Возврат Истина;
			
КонецФункции // ПроверитьИдентичностьВидовАналитик() 

Функция ПроверитьНеобходимостьРеструктуризацииДанныхЭлементСтруктуры(ЭлементСтруктурыНов,ЭлементСтруктурыСтар) Экспорт
	
	// Проверка на изменение типа значения показателя
	Если ТипЗнч(ЭлементСтруктурыНов)=Тип("СправочникОбъект.ПоказателиОтчетов") 
		И (НЕ ЭлементСтруктурыНов.ТипЗначения=ЭлементСтруктурыСтар.ТипЗначения) Тогда
		
		ТекстОшибки=Справочники.ВидыОтчетов.ПроверитьВозможностьИзмененияДанныхПоЗлементуСтруктуры(ЭлементСтруктурыСтар);
		
		СтруктураОтвета=Новый Структура;
		СтруктураОтвета.Вставить("ВидОтчета",					ЭлементСтруктурыНов.Владелец);
		СтруктураОтвета.Вставить("ЭлементСтруктуры",			ЭлементСтруктурыСтар);
		Если Справочники.ВидыОтчетов.ЕстьЗаписиПоЭлементуСтруктуры(ЭлементСтруктурыСтар) Тогда
			СтруктураОтвета.Вставить("ЕстьЗаписиПоЭлементуСтруктуры",Истина);	
		Иначе
			СтруктураОтвета.Вставить("ЕстьЗаписиПоЭлементуСтруктуры",Ложь);
		КонецЕсли;
		
		Если НЕ ПустаяСтрока(ТекстОшибки) Тогда	
			СтруктураОтвета.Вставить("ИзменениеДанныхЗапрещено",ТекстОшибки);	
		Иначе
			
			СтруктураОтвета.Вставить("ТипЗначенияНов",				ЭлементСтруктурыНов.ТипЗначения);
			СтруктураОтвета.Вставить("ИзмененТипЗначенияПоказателя",Истина);
			
		КонецЕсли;	
		
		// Изменение аналитических раскрытий не проверяем, реструктуризация данных невозможна, только очистка.
		Возврат СтруктураОтвета;
		
	КонецЕсли;
	
	ОписаниеРаскрытияНов	= ?(ТипЗнч(ЭлементСтруктурыНов)	=Тип("СправочникОбъект.ГруппыРаскрытия"),ЭлементСтруктурыНов,	ЭлементСтруктурыНов.ГруппаРаскрытия);
	ОписаниеРаскрытияСтар	= ?(ТипЗнч(ЭлементСтруктурыСтар)=Тип("СправочникСсылка.ГруппыРаскрытия"),ЭлементСтруктурыСтар,	ЭлементСтруктурыСтар.ГруппаРаскрытия);
	
	Если ТипЗнч(ОписаниеРаскрытияНов)=Тип("СправочникСсылка.ГруппыРаскрытия") И ТипЗнч(ОписаниеРаскрытияСтар)=Тип("СправочникСсылка.ГруппыРаскрытия") Тогда
		
		Если ОписаниеРаскрытияНов=ОписаниеРаскрытияСтар Тогда
			
			Возврат Неопределено;
			
		ИначеЕсли ТипЗнч(ЭлементСтруктурыНов)=Тип("СправочникОбъект.СтрокиОтчетов") И (НЕ ЗначениеЗаполнено(ОписаниеРаскрытияНов)) Тогда // Убрали группу раскрытия у строки, у показателей остались без изменений
			
			Возврат Неопределено;
			
		КонецЕсли;
		
	КонецЕсли;		
				
	ЕстьИзменениеАналитик=Ложь;
	ВидОтчета=ЭлементСтруктурыСтар.Владелец;
	
	ТаблицаАналитикСтар=Новый ТаблицаЗначений;
	ТаблицаАналитикСтар.Колонки.Добавить("ПорядковыйНомер",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповЧисла(2));
	ТаблицаАналитикСтар.Колонки.Добавить("ВидАналитики",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСсылка("ПланВидовХарактеристикСсылка.ВидыСубконтоКорпоративные"));
	ТаблицаАналитикСтар.Колонки.Добавить("АналитикаВидаОтчета",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповБулево());
	ТаблицаАналитикСтар.Колонки.Добавить("ПорядковыйНомерСтар",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповЧисла(2));
	
	ТаблицаАналитикНов	= ТаблицаАналитикСтар.СкопироватьКолонки(); 
	
	АналитикВидаОтчета=ОбщегоНазначенияУХ.ВернутьКоличествоАналитикНаУровнеОтчета(ВидОтчета);
	
	Для Индекс=АналитикВидаОтчета+1 По ПараметрыСеанса.ЧислоДопАналитик Цикл
		
		Если НЕ (ЗначениеЗаполнено(ОписаниеРаскрытияСтар["ВидАналитики"+Индекс]) ИЛИ ЗначениеЗаполнено(ОписаниеРаскрытияНов["ВидАналитики"+Индекс]))  Тогда
			
			Прервать;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОписаниеРаскрытияСтар["ВидАналитики"+Индекс]) Тогда
			
			НоваяСтрока=ТаблицаАналитикСтар.Добавить();
			НоваяСтрока.ПорядковыйНомер=Индекс;
			НоваяСтрока.ВидАналитики=ОписаниеРаскрытияСтар["ВидАналитики"+Индекс];
			НоваяСтрока.ПорядковыйНомерСтар=Индекс;
			
			Если НЕ ЗначениеЗаполнено(ОписаниеРаскрытияНов["ВидАналитики"+Индекс]) Тогда
				
				ЕстьИзменениеАналитик=Истина;
				Продолжить;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОписаниеРаскрытияНов["ВидАналитики"+Индекс]) Тогда
			
			НоваяСтрока=ТаблицаАналитикНов.Добавить();
			НоваяСтрока.ПорядковыйНомер=Индекс;
			НоваяСтрока.ВидАналитики=ОписаниеРаскрытияНов["ВидАналитики"+Индекс];
			
			Если НЕ ЗначениеЗаполнено(ОписаниеРаскрытияСтар["ВидАналитики"+Индекс]) Тогда
				
				ЕстьИзменениеАналитик= Истина;
				Продолжить;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ОписаниеРаскрытияСтар["ВидАналитики"+Индекс].ТипЗначения.Типы()[0]=Тип("СправочникСсылка.ПроизвольныйКлассификаторУХ") 			
			И (НЕ ОписаниеРаскрытияСтар["ВидАналитики"+Индекс]=ОписаниеРаскрытияНов["ВидАналитики"+Индекс]) Тогда
			
			ЕстьИзменениеАналитик=  Истина;
			
		КонецЕсли;
		
		Если НЕ ОписаниеРаскрытияСтар["ВидАналитики"+Индекс].ТипЗначения.Типы()[0]=ОписаниеРаскрытияНов["ВидАналитики"+Индекс].ТипЗначения.Типы()[0] Тогда
			
			ЕстьИзменениеАналитик=  Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОписаниеРаскрытияСтар.Валютная Тогда
		
		НоваяСтрока=ТаблицаАналитикСтар.Добавить();
		НоваяСтрока.ПорядковыйНомер=-1;
		НоваяСтрока.ПорядковыйНомерСтар=-1;
		НоваяСтрока.ВидАналитики=ОписаниеРаскрытияСтар.ВидАналитикиВалютаДт;
		
		Если НЕ ОписаниеРаскрытияНов.Валютная Тогда
			
			ЕстьИзменениеАналитик=Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОписаниеРаскрытияНов.Валютная Тогда
		
		НоваяСтрока=ТаблицаАналитикНов.Добавить();
		НоваяСтрока.ПорядковыйНомер=-1;
		НоваяСтрока.ПорядковыйНомерСтар=-1;
		НоваяСтрока.ВидАналитики=ОписаниеРаскрытияНов.ВидАналитикиВалютаДт;
		
	КонецЕсли;
	
	Если ЕстьИзменениеАналитик Тогда
				
		Для Каждого Строка ИЗ ТаблицаАналитикНов Цикл
			
			Строка.ПорядковыйНомерСтар=Справочники.ГруппыРаскрытия.ВернутьНомерАналитикиСтар(Строка.ВидАналитики,ТаблицаАналитикСтар,Ложь);
			
		КонецЦикла;
		
		Если АналитикВидаОтчета>0 Тогда
			
			Для Индекс=1 По АналитикВидаОтчета Цикл
				
				АналитикаВидаОтчета=ВидОтчета["ВидАналитики"+Индекс];
				
				НоваяСтрока=ТаблицаАналитикСтар.Добавить();
				НоваяСтрока.ПорядковыйНомер=Индекс;
				НоваяСтрока.ПорядковыйНомерСтар=Индекс;
				НоваяСтрока.ВидАналитики=АналитикаВидаОтчета;
				НоваяСтрока.АналитикаВидаОтчета=Истина;
				
				НоваяСтрока=ТаблицаАналитикНов.Добавить();
				НоваяСтрока.ПорядковыйНомер=Индекс;
				НоваяСтрока.ПорядковыйНомерСтар=Индекс;
				НоваяСтрока.ВидАналитики=АналитикаВидаОтчета;
				НоваяСтрока.АналитикаВидаОтчета=Истина;
				
			КонецЦикла;
			
		КонецЕсли;
		
		ТаблицаАналитикНов.Сортировать("ПорядковыйНомер Возр");
		ТаблицаАналитикСтар.Сортировать("ПорядковыйНомер Возр");
		
		Если НЕ Справочники.ВидыОтчетов.ЕстьЗаписиПоЭлементуСтруктуры(ЭлементСтруктурыСтар) Тогда
			
			Справочники.ВидыОтчетов.СоздатьПротоколИзмененияОперандов(ЭлементСтруктурыСтар,ТаблицаАналитикСтар,ТаблицаАналитикНов);
			
			СтруктураОтвета=Новый Структура;
			СтруктураОтвета.Вставить("ЕстьИзменениеАналитик",Истина);
			СтруктураОтвета.Вставить("ВидОтчета",ВидОтчета);
			СтруктураОтвета.Вставить("ЕстьЗаписиПоЭлементуСтруктуры",Ложь);
			
			Возврат СтруктураОтвета;
			
		КонецЕсли;

		СтруктураОтвета=Новый Структура;
		СтруктураОтвета.Вставить("ЕстьИзменениеАналитик",Истина);
		СтруктураОтвета.Вставить("ВидОтчета",ВидОтчета);
		СтруктураОтвета.Вставить("ЕстьЗаписиПоЭлементуСтруктуры",Истина);

		
		ИзменениеГруппРаскрытия=Новый Соответствие;
		
		ИзменениеГруппРаскрытия.Вставить(ЭлементСтруктурыСтар,Новый Структура("ТаблицаАналитикСтар,ТаблицаАналитикНов,ЕстьЗаписиВРегистрах",ТаблицаАналитикСтар,ТаблицаАналитикНов,Истина));
		
		СтруктураОтвета.Вставить("ИзменениеГруппРаскрытия",ИзменениеГруппРаскрытия);
		
		ТекстОшибки=Справочники.ВидыОтчетов.ПроверитьВозможностьИзмененияДанныхПоЗлементуСтруктуры(ЭлементСтруктурыСтар);
		
		Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
			
			СтруктураОтвета.Вставить("ИзменениеДанныхЗапрещено",ТекстОшибки);
			
		КонецЕсли;
		
		Возврат СтруктураОтвета
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;	
	
КонецФункции // ПроверитьНеобходимостьРеструктуризацииДанныхЭлементСтруктуры()

Процедура УстановитьПризнакПересчетаВалютныхСумм(ГруппаРаскрытия,Валютная,Отказ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПоказателиОтчетов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПоказателиОтчетов КАК ПоказателиОтчетов
	|ГДЕ
	|	ПоказателиОтчетов.ГруппаРаскрытия = &ГруппаРаскрытия
	|	И (ПоказателиОтчетов.ПересчитыватьВалютнуюСумму <> &Валютная
	|	ИЛИ ПоказателиОтчетов.Валютный <> &Валютная)";
	
	Запрос.УстановитьПараметр("ГруппаРаскрытия",ГруппаРаскрытия);
	Запрос.УстановитьПараметр("Валютная",Валютная);
	
	Результат = Запрос.Выполнить().Выбрать();	
	Пока Результат.Следующий() Цикл
		
		СправочникОбъект = Результат.Ссылка.ПолучитьОбъект();
		
		Если Валютная Тогда
			
			Если СправочникОбъект.ЧисловойПоказатель И (НЕ СправочникОбъект.НеФинансовый) Тогда
				
				СправочникОбъект.ПересчитыватьВалютнуюСумму = Истина;
				
			КонецЕсли;
			
		Иначе
			
			СправочникОбъект.ПересчитыватьВалютнуюСумму = Ложь;
			
		КонецЕсли;
		
		Попытка
			
			СправочникОбъект.Записать();
			
		Исключение
			
			СтрокаШаблона = НСтр("ru = 'Ошибка при снятии признака ""Пересчитывать валютную сумму"" у показателя %1'");
			
			Если Не ПустаяСтрока(СтрокаШаблона) тогда
				ОбщегоНазначенияУХ.СообщитьОбОшибке(СтрШаблон(СтрокаШаблона, СправочникОбъект.Наименование), Отказ,, СтатусСообщения.Внимание);
			КонецЕсли;
			
			Отказ = Истина;
			Возврат;
			
		КонецПопытки;
		
	КонецЦикла;	
	
КонецПроцедуры // СброситьПризнакПересчетаВалютныхСумм()


Функция ПолучитьГруппуРаскрытияСПредопределеннымиАналитиками(Показатель,МассивПредопределенныхАналитик) Экспорт
	
	ТекстОшибки="";
	
	СчетБД				= Показатель.СчетБД;
	КоррСчетБД			= Показатель.КоррСчетБД;
	ГруппаРаскрытия 	= Показатель.ГруппаРаскрытия;
	ВидОтчета			= Показатель.Владелец;
	
	АналитикВидаОтчета  = ОбщегоНазначенияУХ.ВернутьКоличествоАналитикНаУровнеОтчета(ВидОтчета);
	НовыхАналитик		= МассивПредопределенныхАналитик.Количество();
	
	Если АналитикВидаОтчета+НовыхАналитик>ПараметрыСеанса.ЧислоДопАналитик Тогда
		
		СтрокаШаблона = Нстр("ru = 'Не удалось добавить предопределенные аналитики в количестве %1: первые %2 аналитик зарезервированы на уровне вида отчета.'");
		
		ТекстОшибки = "";
		Если Не ПустаяСтрока(СтрокаШаблона) тогда								
			ТекстОшибки = СтрШаблон(СтрокаШаблона, НовыхАналитик, АналитикВидаОтчета);
		КонецЕсли;
		
		Возврат ТекстОшибки;
				
	КонецЕсли;
	
	СписокАналитик=Новый СписокЗначений;
			
	Если ЗначениеЗаполнено(ГруппаРаскрытия) Тогда
		
		ЧислоЗаполненныхАналитик=ЧислоЗаполненныхАналитик(ГруппаРаскрытия);
		
		Если АналитикВидаОтчета+ЧислоЗаполненныхАналитик+НовыхАналитик>ПараметрыСеанса.ЧислоДопАналитик Тогда
			
			ТекстОшибки = "";
			
			Если АналитикВидаОтчета > 0 Тогда
				СтрокаШаблона = Нстр("ru = 'Не удалось добавить для группы раскрытия %1 предопределенные аналитики в количестве %2: первые %3 аналитик зарезервированы на уровне вида отчета
				|следующие %4 аналитик уже заполнены в группе раскрытия.'");
				
				Если Не ПустаяСтрока(СтрокаШаблона) тогда								
					ТекстОшибки = СтрШаблон(СтрокаШаблона, ГруппаРаскрытия, НовыхАналитик, АналитикВидаОтчета, Строка(ЧислоЗаполненныхАналитик-АналитикВидаОтчета));
				КонецЕсли;
				
			Иначе
				СтрокаШаблона = Нстр("ru = 'Не удалось добавить для группы раскрытия %1 предопределенные аналитики в количестве %2
				|следующие %3 аналитик уже заполнены в группе раскрытия.'");
				
				Если Не ПустаяСтрока(СтрокаШаблона) тогда								
					ТекстОшибки = СтрШаблон(СтрокаШаблона, ГруппаРаскрытия, НовыхАналитик, Строка(ЧислоЗаполненныхАналитик-АналитикВидаОтчета));
				КонецЕсли;
				
			КонецЕсли;
						
			Возврат ТекстОшибки;
						
		КонецЕсли;

		ТекущийОбъект=ГруппаРаскрытия.ПолучитьОбъект();
				
		Для Индекс=1 По ПараметрыСеанса.ЧислоДопАналитик Цикл
			
			Если ЗначениеЗаполнено(ТекущийОбъект["ВидАналитики"+Индекс]) Тогда
				
				СписокАналитик.Добавить(ТекущийОбъект["ВидАналитики"+Индекс],,ТекущийОбъект["Аналитика"+Индекс+"Обязательна"])
				
			КонецЕсли;
			
		КонецЦикла;
		
		СправочникОбъект=ТекущийОбъект.Скопировать();
		СправочникОбъект.АналитикаВГО=?(ТекущийОбъект.АналитикаВГО>0,(ТекущийОбъект.АналитикаВГО+НовыхАналитик),0);
		
	Иначе
		
		СправочникОбъект=Справочники.ГруппыРаскрытия.СоздатьЭлемент();
		СправочникОбъект.Владелец		= ВидОтчета;
		
	КонецЕсли;
	
	ТекстНаименование="";
			
	Для Индекс=1 ПО НовыхАналитик Цикл
		
		СправочникОбъект["ВидАналитики"	+ (АналитикВидаОтчета+Индекс)]					= МассивПредопределенныхАналитик[Индекс-1];
		СправочникОбъект["Аналитика"	+ (АналитикВидаОтчета+Индекс)+"Обязательна"]	= Истина;
		
		ТекстНаименование=ТекстНаименование+","+СправочникОбъект["ВидАналитики"	+ (АналитикВидаОтчета+Индекс)];
		
	КонецЦикла;
	
	Для Индекс=1 ПО СписокАналитик.Количество() Цикл
		
		ДанныеАналитики=СписокАналитик[Индекс-1];
		
		СправочникОбъект["ВидАналитики"	+ (АналитикВидаОтчета+НовыхАналитик+Индекс)]				= ДанныеАналитики.Значение;
		СправочникОбъект["Аналитика"	+ (АналитикВидаОтчета+НовыхАналитик+Индекс)+"Обязательна"]	= ДанныеАналитики.Пометка;
		
		ТекстНаименование=ТекстНаименование+","+СправочникОбъект["ВидАналитики"	+ (АналитикВидаОтчета+НовыхАналитик+Индекс)];
		
	КонецЦикла;
	
	СправочникОбъект.Наименование	= Сред(ТекстНаименование,2);
	СправочникОбъект.Код			= ОбщегоНазначенияУХ.СформироватьКодНаОснованииНаименования(СправочникОбъект.Наименование,СправочникОбъект.Метаданные().ДлинаКода,"ГруппыРаскрытия",ВидОтчета);
		
	СправочникОбъект.ПодготовитьТаблицуОтображенияПолей(Истина);

	Попытка
		
		СправочникОбъект.Записать();
		Возврат СправочникОбъект.Ссылка;
		
	Исключение
		
		СтрокаШаблона = Нстр("ru = 'Не удалось получить требуемый состав аналитик для группы раскрытия %1'");
		
		ТекстОшибки = "";
		Если Не ПустаяСтрока(СтрокаШаблона) тогда								
			ТекстОшибки = СтрШаблон(СтрокаШаблона, СправочникОбъект.Наименование);
		КонецЕсли;
				
		ПротоколируемыеСобытияВызовСервераУХ.ДобавитьЗаписьОшибка("Справочники.ГруппыРаскрытия.МодульМенеджера",,,ТекстОшибки);
		
		Возврат ТекстОшибки;
		
	КонецПопытки;
		
КонецФункции // ПолучитьГруппуРаскрытияСПредопределеннымиАналитиками()

Функция ВернутьНомерАналитикиСтар(ВидАналитикиНов,ТаблицаАналитикСтар,АналитикаВидаОтчета) Экспорт
	
	МассивАналитик=ТаблицаАналитикСтар.Найтистроки(Новый Структура("АналитикаВидаОтчета",АналитикаВидаОтчета));
		
	// Поиск по одинаковому элементу ПВХ
	
	Для Каждого Строка ИЗ МассивАналитик Цикл
		
		Если Строка.ВидАналитики=ВидАналитикиНов Тогда
			
			Возврат Строка.ПорядковыйНомер;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ТипЗначенияНов=ВидАналитикиНов.ТипЗначения.Типы()[0];
	
	Если НЕ ТипЗначенияНов=Тип("СправочникСсылка.ПроизвольныйКлассификаторУХ") Тогда
		
		// Поиск по одинаковому типу значений
				
		Для Каждого Строка ИЗ МассивАналитик Цикл	
			
			Если Строка.ВидАналитики.ТипЗначения.Типы()[0]=ТипЗначенияНов Тогда
				
				Возврат Строка.ПорядковыйНомер;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат 0;	
	
КонецФункции // ВернутьНомерАналитикиСтар() 

Функция ПолучитьПустуюСтруктуруРаскрытия(ГруппаРаскрытия) Экспорт
	
	СтруктураРаскрытия=Новый Структура;
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	ГруппыРаскрытия.ВидАналитики1 КАК ВидАналитики1,
	|	ГруппыРаскрытия.ВидАналитики2 КАК ВидАналитики2,
	|	ГруппыРаскрытия.ВидАналитики3 КАК ВидАналитики3,
	|	ГруппыРаскрытия.ВидАналитики4 КАК ВидАналитики4,
	|	ГруппыРаскрытия.ВидАналитики5 КАК ВидАналитики5,
	|	ГруппыРаскрытия.ВидАналитики6 КАК ВидАналитики6,
	|	ГруппыРаскрытия.Валютная КАК Валютная
	|ИЗ
	|	Справочник.ГруппыРаскрытия КАК ГруппыРаскрытия
	|ГДЕ
	|	ГруппыРаскрытия.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",ГруппаРаскрытия);
	
	Результат=Запрос.Выполнить().Выбрать();
	Результат.Следующий();
	
	Для Индекс=1 ПО 6 Цикл
		
		Если ЗначениеЗаполнено(Результат["ВидАналитики"+Индекс]) Тогда
			
			СтруктураРаскрытия.Вставить("Аналитика"+Индекс,КэшируемыеПроцедурыУХ.ПолучитьПустоеЗначениеПоВидуАналитики(Результат["ВидАналитики"+Индекс]));
			
		КонецЕсли;
		
	КонецЦикла;
		
	Если Результат.Валютная Тогда
		
		СтруктураРаскрытия.Вставить("АналитикаВалюта",Справочники.Валюты.ПустаяСсылка());
		
	КонецЕсли;
	
	Возврат СтруктураРаскрытия;	
	
КонецФункции // ВернутьПустуюСтруктуруРаскрытия() 

// Возвращает наименование вида аналитики по умолчанию по структуре СтруктураВидовАналитикВход.
Функция СформироватьНаименованиеПоВидамАналитикам(СтруктураВидовАналитикВход, РаскрытиеПоВалютамВход = Ложь) Экспорт
	РезультатФункции = "";
	Для Каждого ТекСтруктураВидовАналитикВход Из СтруктураВидовАналитикВход Цикл
		ТекЗначениеВидаАналитики = ТекСтруктураВидовАналитикВход.Значение;
		Если ЗначениеЗаполнено(ТекЗначениеВидаАналитики) Тогда
			РезультатФункции = РезультатФункции + Строка(ТекЗначениеВидаАналитики);
			РезультатФункции = РезультатФункции + ", ";
		Иначе
			// 	Пропускаем.
		КонецЕсли;
	КонецЦикла;	
	РезультатФункции = Лев(РезультатФункции, СтрДлина(РезультатФункции) - 2);		// Уберём 2 последних служебных символа.
	Если РаскрытиеПоВалютамВход Тогда
		РезультатФункции = РезультатФункции + НСтр("ru = ' (валютная)'");
	Иначе
		// Не добавляем признак.
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции		// СформироватьНаименованиеПоВидамАналитикам()

// Возвращает массив кодов групп раскрытий, сопоставленных виду отчета ВидОтчетаВход.
Функция ПолучитьМассивКодовГруппРаскрытийОтчета(ВидОтчетаВход)
	РезультатФункции = Новый Массив;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ГруппыРаскрытия.Владелец КАК Владелец,
		|	ГруппыРаскрытия.Код КАК Код,
		|	ГруппыРаскрытия.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ГруппыРаскрытия КАК ГруппыРаскрытия
		|ГДЕ
		|	НЕ ГруппыРаскрытия.ПометкаУдаления
		|	И ГруппыРаскрытия.Владелец = &Владелец";
	Запрос.УстановитьПараметр("Владелец", ВидОтчетаВход);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		РезультатФункции.Добавить(СокрЛП(ВыборкаДетальныеЗаписи.Код));
	КонецЦикла;
	РезультатФункции = ОбщегоНазначенияКлиентСервер.СвернутьМассив(РезультатФункции);
	РезультатФункции = ОбщегоНазначенияКлиентСерверУХ.УдалитьПустыеЭлементыМассива(РезультатФункции);
	Возврат РезультатФункции;
КонецФункции		// ПолучитьМассивКодовГруппРаскрытийОтчета()

// Возвращает смещение вида аналитики для аналитик на уровне отчёта для
// вида отчёта ВидОтчетаВход.
Функция ВернутьСмещениеАналитикиВидОтчета(ВидОтчетаВход) Экспорт
	РезультатФункции = 0;
	Если ЗначениеЗаполнено(ВидОтчетаВход.ВидАналитики6) Тогда
		РезультатФункции = 6;
	ИначеЕсли ЗначениеЗаполнено(ВидОтчетаВход.ВидАналитики5) Тогда
		РезультатФункции = 5;		
	ИначеЕсли ЗначениеЗаполнено(ВидОтчетаВход.ВидАналитики4) Тогда
		РезультатФункции = 4;		
	ИначеЕсли ЗначениеЗаполнено(ВидОтчетаВход.ВидАналитики3) Тогда
		РезультатФункции = 3;		
	ИначеЕсли ЗначениеЗаполнено(ВидОтчетаВход.ВидАналитики2) Тогда
		РезультатФункции = 2;		
	ИначеЕсли ЗначениеЗаполнено(ВидОтчетаВход.ВидАналитики1) Тогда
		РезультатФункции = 1;		
	Иначе
		РезультатФункции = 0;		
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции		// ВернутьСмещениеАналитикиВидОтчета()

// Размещает аналитику с номером НомерАналитикиВход из структуры СтруктураВидовАналитикВход
// в объекта справочника СправочникИзм со смещением СмещениеАналитикВход.
Процедура РазместитьАналитику(СправочникИзм, СтруктураВидовАналитикВход, НомерАналитикиВход, СмещениеАналитикВход) Экспорт
	ИсходныйВидАналитики = Неопределено;
	Если НомерАналитикиВход = 1 Тогда
		ИсходныйВидАналитики = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураВидовАналитикВход, "ВидАналитики1", Неопределено);
	ИначеЕсли НомерАналитикиВход = 2 Тогда
		ИсходныйВидАналитики = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураВидовАналитикВход, "ВидАналитики2", Неопределено);
	ИначеЕсли НомерАналитикиВход = 3 Тогда
		ИсходныйВидАналитики = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураВидовАналитикВход, "ВидАналитики3", Неопределено);	
	ИначеЕсли НомерАналитикиВход = 4 Тогда
		ИсходныйВидАналитики = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураВидовАналитикВход, "ВидАналитики4", Неопределено);
	ИначеЕсли НомерАналитикиВход = 5 Тогда
		ИсходныйВидАналитики = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураВидовАналитикВход, "ВидАналитики5", Неопределено);
	ИначеЕсли НомерАналитикиВход = 6 Тогда
		ИсходныйВидАналитики = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураВидовАналитикВход, "ВидАналитики6", Неопределено);
	Иначе
		ТекстСообщения = НСтр("ru = 'Неизвестный номер аналитики: %НомерАналитики%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерАналитики%", Строка(НомерАналитикиВход));
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		ИсходныйВидАналитики = Неопределено;
	КонецЕсли;
	Если ИсходныйВидАналитики <> Неопределено Тогда
		НовыйНомерАналитики = НомерАналитикиВход + СмещениеАналитикВход;
		Если НовыйНомерАналитики = 1 Тогда
			СправочникИзм.ВидАналитики1 = ИсходныйВидАналитики;
		ИначеЕсли НовыйНомерАналитики = 2 Тогда
			СправочникИзм.ВидАналитики2 = ИсходныйВидАналитики;
		ИначеЕсли НовыйНомерАналитики = 3 Тогда
			СправочникИзм.ВидАналитики3 = ИсходныйВидАналитики;
		ИначеЕсли НовыйНомерАналитики = 4 Тогда
			СправочникИзм.ВидАналитики4 = ИсходныйВидАналитики;
		ИначеЕсли НовыйНомерАналитики = 5 Тогда
			СправочникИзм.ВидАналитики5 = ИсходныйВидАналитики;
		ИначеЕсли НовыйНомерАналитики = 6 Тогда
			СправочникИзм.ВидАналитики6 = ИсходныйВидАналитики;
		Иначе
			// Выход за границы. Пропускаем.
		КонецЕсли;
	Иначе
		// Не удалось определить аналитику.
	КонецЕсли;
КонецПроцедуры		// РазместитьАналитику()

// Размещает аналитику ВидАналитикиВход в значении ВидАналитикиИзм, если НомерАналитикиВход
// меньше СмещениеВход.
Процедура ПропуститьАналитикиВидаОтчетаИРазместить(ВидАналитикиВход, НомерАналитикиВход, СмещениеВход, ВидАналитикиИзм)
	Если СмещениеВход < НомерАналитикиВход Тогда
		ВидАналитикиИзм = ВидАналитикиВход;
	Иначе
		// Пропускаем вид аналитики.
	КонецЕсли;
КонецПроцедуры		// ПропуститьАналитикиВидаОтчетаИРазместить()

// Возвращает группу аналитик, принадлежщую виду отчета ВидОтчетаВход, в которой
// виды аналитик соответствуют данным структуры СтруктураВидовАналитикВход. Когда
// такая группа аналитик не найдена - будет создана новая.
Функция ВернутьГруппуАналитикПоВидамАналитик(СтруктураВидовАналитикВход, ВидОтчетаВход, РаскрытиеПоВалютамВход = Ложь) Экспорт
	// Инициализация.
	РезультатФункции = Справочники.ГруппыРаскрытия.ПустаяСсылка();
	ВидАналитики1 = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураВидовАналитикВход, "ВидАналитики1", Неопределено);
	ВидАналитики2 = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураВидовАналитикВход, "ВидАналитики2", Неопределено);
	ВидАналитики3 = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураВидовАналитикВход, "ВидАналитики3", Неопределено);
	ВидАналитики4 = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураВидовАналитикВход, "ВидАналитики4", Неопределено);
	ВидАналитики5 = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураВидовАналитикВход, "ВидАналитики5", Неопределено);
	ВидАналитики6 = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураВидовАналитикВход, "ВидАналитики6", Неопределено);
	// Поиск группы раскрытия с указанными аналитиками в базе данных.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ГруппыРаскрытия.Ссылка КАК Ссылка,
		|	ГруппыРаскрытия.Владелец КАК Владелец,
		|	ГруппыРаскрытия.ВидАналитики1 КАК ВидАналитики1,
		|	ГруппыРаскрытия.ВидАналитики2 КАК ВидАналитики2,
		|	ГруппыРаскрытия.ВидАналитики3 КАК ВидАналитики3,
		|	ГруппыРаскрытия.ВидАналитики4 КАК ВидАналитики4,
		|	ГруппыРаскрытия.ВидАналитики5 КАК ВидАналитики5,
		|	ГруппыРаскрытия.ВидАналитики6 КАК ВидАналитики6,
		|	ГруппыРаскрытия.Валютная КАК Валютная
		|ИЗ
		|	Справочник.ГруппыРаскрытия КАК ГруппыРаскрытия
		|ГДЕ
		|	ВЫБОР
		|			КОГДА &ВидАналитики1 = НЕОПРЕДЕЛЕНО
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ГруппыРаскрытия.ВидАналитики1 = &ВидАналитики1
		|		КОНЕЦ
		|	И ВЫБОР
		|			КОГДА &ВидАналитики2 = НЕОПРЕДЕЛЕНО
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ГруппыРаскрытия.ВидАналитики2 = &ВидАналитики2
		|		КОНЕЦ
		|	И ВЫБОР
		|			КОГДА &ВидАналитики3 = НЕОПРЕДЕЛЕНО
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ГруппыРаскрытия.ВидАналитики3 = &ВидАналитики3
		|		КОНЕЦ
		|	И ВЫБОР
		|			КОГДА &ВидАналитики4 = НЕОПРЕДЕЛЕНО
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ГруппыРаскрытия.ВидАналитики4 = &ВидАналитики4
		|		КОНЕЦ
		|	И ВЫБОР
		|			КОГДА &ВидАналитики5 = НЕОПРЕДЕЛЕНО
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ГруппыРаскрытия.ВидАналитики5 = &ВидАналитики5
		|		КОНЕЦ
		|	И ГруппыРаскрытия.Владелец = &Владелец
		|	И НЕ ГруппыРаскрытия.ПометкаУдаления
		|	И ВЫБОР
		|			КОГДА &ВидАналитики6 = НЕОПРЕДЕЛЕНО
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ГруппыРаскрытия.ВидАналитики6 = &ВидАналитики6
		|		КОНЕЦ
		|	И ГруппыРаскрытия.Валютная = &Валютная";
	Запрос.УстановитьПараметр("Валютная", РаскрытиеПоВалютамВход);
	Запрос.УстановитьПараметр("ВидАналитики1", ВидАналитики1);
	Запрос.УстановитьПараметр("ВидАналитики2", ВидАналитики2);
	Запрос.УстановитьПараметр("ВидАналитики3", ВидАналитики3);
	Запрос.УстановитьПараметр("ВидАналитики4", ВидАналитики4);
	Запрос.УстановитьПараметр("ВидАналитики5", ВидАналитики5);
	Запрос.УстановитьПараметр("ВидАналитики6", ВидАналитики6);
	Запрос.УстановитьПараметр("Владелец", ВидОтчетаВход);
	РезультатЗапроса = Запрос.Выполнить();
	МассивКодовГруппРаскрытий = ПолучитьМассивКодовГруппРаскрытийОтчета(ВидОтчетаВход);
	СмещениеАналитик = ВернутьСмещениеАналитикиВидОтчета(ВидОтчетаВход);
	Если РезультатЗапроса.Пустой() Тогда
		// Группа раскрытия не найдена. Создадим новую.
		Попытка
			НовоеНаименование = СформироватьНаименованиеПоВидамАналитикам(СтруктураВидовАналитикВход, РаскрытиеПоВалютамВход);
			НовыйКод = ОбщегоНазначенияУХ.СформироватьКодНаОснованииНаименования(НовоеНаименование);
			НовыйКод = ПолучитьУникальныйКодСтрокиПоМассиву(НовыйКод, МассивКодовГруппРаскрытий); 
			НовыйСправочник = Справочники.ГруппыРаскрытия.СоздатьЭлемент();	
			НовыйСправочник.Наименование = НовоеНаименование;
			НовыйСправочник.Код = НовыйКод;
			ПропуститьАналитикиВидаОтчетаИРазместить(ВидАналитики1, 1, СмещениеАналитик, НовыйСправочник.ВидАналитики1);
			ПропуститьАналитикиВидаОтчетаИРазместить(ВидАналитики2, 2, СмещениеАналитик, НовыйСправочник.ВидАналитики2);
			ПропуститьАналитикиВидаОтчетаИРазместить(ВидАналитики3, 3, СмещениеАналитик, НовыйСправочник.ВидАналитики3);
			ПропуститьАналитикиВидаОтчетаИРазместить(ВидАналитики4, 4, СмещениеАналитик, НовыйСправочник.ВидАналитики4);
			ПропуститьАналитикиВидаОтчетаИРазместить(ВидАналитики5, 5, СмещениеАналитик, НовыйСправочник.ВидАналитики5);
			ПропуститьАналитикиВидаОтчетаИРазместить(ВидАналитики6, 6, СмещениеАналитик, НовыйСправочник.ВидАналитики6);
			НовыйСправочник.Валютная = РаскрытиеПоВалютамВход;
			НовыйСправочник.Владелец = ВидОтчетаВход;
			НовыйСправочник.Записать();
			РезультатФункции = НовыйСправочник.Ссылка;
		Исключение
			ТекстСообщения = НСтр("ru = 'При создании группы аналитик отчета %ВидОтчета% произошли ошибки: %ОписаниеОшибки%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВидОтчета%", Строка(ВидОтчетаВход));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки());
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
			РезультатФункции = Справочники.ГруппыРаскрытия.ПустаяСсылка();
		КонецПопытки;
	Иначе	
		// Группа раскрытия найдена. Вернём её.
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			РезультатФункции = ВыборкаДетальныеЗаписи.Ссылка;
		КонецЦикла;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции		// ВернутьГруппуАналитикПоВидамАналитик()

Функция ПолучитьУникальныйКодСтрокиПоМассиву(Наименование, МассивКодовВход) Экспорт
	
	ДлинаКодаСтроки = Метаданные.Справочники.СтрокиОтчетов.ДлинаКода;
	
	КодСтроки = ОбщегоНазначенияУХ.СформироватьКодНаОснованииНаименования(Наименование,ДлинаКодаСтроки);
	
	Если МассивКодовВход.Найти(КодСтроки) = Неопределено Тогда
		
		Возврат КодСтроки;
		
	Иначе
		РезультатФункции = ОбщегоНазначенияКлиентСерверУХ.ПреобразоватьКодВУникальный(КодСтроки, МассивКодовВход, ДлинаКодаСтроки);
		Возврат РезультатФункции;
	КонецЕсли;	
	
КонецФункции // ПолучитьУникальныйКодСтрокиПоМассиву()

// Возвращает вид субконто по массиву типов данных МассивТиповВход.
Функция НайтиСубконтоПоИсходнымТипам(МассивТиповВход)
	РезультатФункции = Новый Массив;
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	ВидыСубконтоКорпоративные.Ссылка КАК Ссылка,
	|	ВидыСубконтоКорпоративные.ТипЗначения КАК ТипЗначения
	|ИЗ
	|	ПланВидовХарактеристик.ВидыСубконтоКорпоративные КАК ВидыСубконтоКорпоративные
	|ГДЕ
	|	НЕ ВидыСубконтоКорпоративные.ПометкаУдаления";
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		Для Каждого ИсходныйТип ИЗ МассивТиповВход Цикл
			
			Если Результат.ТипЗначения.СодержитТип(ИсходныйТип) Тогда
				
				РезультатФункции = Результат.Ссылка;
				Прервать;			// Значение найдено.
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	Возврат РезультатФункции;
КонецФункции		// НайтиСубконтоПоИсходнымТипам()

// Преобразует строку описания типов СтрокаТиповВход в массив типов.
Функция ПреобразоватьСтрокуТипов(СтрокаТиповВход)
	РезультатФункции = Новый Массив;
	МассивСтрок = СтрРазделить(СтрокаТиповВход, ";", Ложь);
	Для Каждого ТекМассивСтрок Из МассивСтрок Цикл
		Попытка
			ТекМассивСтрок = СтрЗаменить(ТекМассивСтрок, "Справочник.", "СправочникСсылка.");
			ТекМассивСтрок = СтрЗаменить(ТекМассивСтрок, "Документ.", "ДокументСсылка.");
			ТекМассивСтрок = СтрЗаменить(ТекМассивСтрок, "Перечисление.", "ПеречислениеСсылка.");
			НовыйТип = Тип(ТекМассивСтрок);
			РезультатФункции.Добавить(НовыйТип);
		Исключение
			ТекстСообщения = НСтр("ru = 'Не удалось преобразовать тип %Тип%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Тип%", Строка(ТекМассивСтрок));
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		КонецПопытки;
	КонецЦикла;	
	Возврат РезультатФункции;
КонецФункции		// ПреобразоватьСтрокуТипов()

Функция ПолучитьВидАналитики(ТипБД, СтрокаСубконто, СчетБдВход) Экспорт
	
	Если ТипБД=Справочники.ТипыБазДанных.ТекущаяИБ Тогда
		
		ВидСубконтоСсылка = СтрокаСубконто.ВидСубконтоСсылка;
		Если ЗначениеЗаполнено(ВидСубконтоСсылка) Тогда
			// Вид субконто задан ссылкой.
			Если ВидСубконтоСсылка.Метаданные().Имя = "ВидыСубконтоКорпоративные" Тогда
				
				Возврат ВидСубконтоСсылка;
				
			Иначе
				
				ТипыИсходные = ВидСубконтоСсылка.ТипЗначения.Типы();
				Возврат НайтиСубконтоПоИсходнымТипам(ТипыИсходные);
				
			КонецЕсли;
		Иначе
			// Ссылки на вид субконто нет, получим её из строки типов.
			ТипыИсходные = ПреобразоватьСтрокуТипов(СтрокаСубконто.ТипДанных);
			НовыйВидСубконто = НайтиСубконтоПоИсходнымТипам(ТипыИсходные);
			Возврат НовыйВидСубконто;
		КонецЕсли;
	Иначе
		
		СтрокаАналитики=Новый Структура("ТипМетаДанных,СправочникБД,ТипДанныхПоля,ТипЗначения");
		
		МассивТипов=ОбщегоНазначенияУХ.РазложитьСтрокуВМассивПодстрок(СтрокаСубконто.ТипДанных,";");
		СтрокаТип=МассивТипов[0];
		
		РаботаСПолямиАналитикиУХ.ЗаполнитьПоляТиповРеквизитовБД(СтрокаАналитики,СтрокаТип,ТипБД,Справочники.ТипыБазДанных.ТекущаяИБ);			
		ТекСоответствие=УправлениеОтчетамиУХ.ПолучитьНастройкуСоответствияРеквизитов(ТипБД,,СтрокаАналитики.СправочникБД,СтрокаАналитики.ТипМетаДанных,Истина,Ложь,"ВидСубконто");
			
		Если НЕ ТекСоответствие=Неопределено Тогда
			
			Возврат ТекСоответствие.ИмяОбъектаМетаданных;
			
		Иначе // Ищем соответствие без отбора по типу объекта консолидации
			
			ТекСоответствие=УправлениеОтчетамиУХ.ПолучитьНастройкуСоответствияРеквизитов(ТипБД,,СтрокаАналитики.СправочникБД,СтрокаАналитики.ТипМетаДанных,Истина,Ложь);
			
			Если (НЕ ТекСоответствие=Неопределено) И ЗначениеЗаполнено(ТекСоответствие.ТипОбъектаКонсолидации) И ЗначениеЗаполнено(ТекСоответствие.ИмяОбъектаМетаданных) Тогда
				
				ИсходныйТип=ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСсылка(ТекСоответствие.ТипОбъектаКонсолидации+"Ссылка."+ТекСоответствие.ИмяОбъектаМетаданных);
				
				ТекВидыСубконто=ПланыВидовХарактеристик.ВидыСубконтоКорпоративные.Выбрать();
				
				Пока ТекВидыСубконто.Следующий() Цикл
					
					Если ТекВидыСубконто.ТипЗначения.СодержитТип(ИсходныйТип.Типы()[0]) Тогда
						
						Возврат ТекВидыСубконто.Ссылка;
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;	
						
		КонецЕсли;
		
		СтрокаШаблона = НСтр("ru = '%1, вид субконто: %2, тип значения: %3 не найдена настройка соответствия.'");
		
		Если Не ПустаяСтрока(СтрокаШаблона) тогда
			ОбщегоНазначенияУХ.СообщитьОбОшибке(СтрШаблон(СтрокаШаблона, СчетБдВход, СтрокаСубконто.ВидСубконто, СтрокаСубконто.ТипДанных),,, СтатусСообщения.Информация);
		КонецЕсли;
		
		Возврат Неопределено;
		
	КонецЕсли;		
		
КонецФункции // ПолучитьВидАналитики()
