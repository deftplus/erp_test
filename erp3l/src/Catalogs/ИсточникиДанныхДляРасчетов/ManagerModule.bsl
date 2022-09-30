#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбновитьАналитикиИсточниковДанных(ГруппаРаскрытия=Неопределено,ПоказательОтчета=Неопределено,Отказ) Экспорт
	
	// Обновляем источники данных, связанные по реквизиту "ПоказательОтбор"
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	ИсточникиДанныхДляРасчетов.Ссылка
	|ИЗ
	|	Справочник.ИсточникиДанныхДляРасчетов КАК ИсточникиДанныхДляРасчетов
	|ГДЕ";
	
	МассивПравилКОбновлению=Новый Массив;
	
	Если НЕ ГруппаРаскрытия=Неопределено Тогда
		
		Запрос.Текст=Запрос.Текст+"	
		|	ИсточникиДанныхДляРасчетов.ПоказательОтбор.ГруппаРаскрытия = &ГруппаРаскрытия";
		
		Запрос.УстановитьПараметр("ГруппаРаскрытия",ГруппаРаскрытия);
		
	Иначе
		
		Запрос.Текст=Запрос.Текст+"	
		|	ИсточникиДанныхДляРасчетов.ПоказательОтбор = &ПоказательОтчета";
		
		Запрос.УстановитьПараметр("ПоказательОтчета",ПоказательОтчета);
		
	КонецЕсли;
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		ИсточникОбъект=Результат.Ссылка.ПолучитьОбъект();
		
		ИсточникОбъект.ЗаполнитьТаблицуСоответствияПоУмолчанию	=Истина;
		ИсточникОбъект.ЗаполнитьТаблицуОтбораПоУмолчанию		=Истина;
		
		ИсточникОбъект.ПравилаИспользованияПолейЗапроса.Очистить();
		
		МассивСтрокАналитики=Новый Массив;
		
		Для Каждого Строка ИЗ ИсточникОбъект.ТаблицаПараметровОтбораБД Цикл
			
			Если СтрНайти(Строка.ПолеБД,"Версия.")=0 Тогда
				
				МассивСтрокАналитики.Добавить(Строка);
				
			КонецЕсли;
			
		КонецЦикла;
		
		Для Каждого СтрАналитика ИЗ МассивСтрокАналитики Цикл
			
			ИсточникОбъект.ТаблицаПараметровОтбораБД.Удалить(СтрАналитика);
			
		КонецЦикла;
					
		ИсточникОбъект.ПодготовитьТаблицыСопоставленийИОтборов();
		ИсточникОбъект.мМодифицированность=Истина;
		ИсточникОбъект.СохранитьНастройкиОперанда();
		
		Попытка
			
			ИсточникОбъект.Записать();
			
			Если МассивПравилКОбновлению.Найти(ИсточникОбъект.НазначениеРасчетов)=Неопределено Тогда
				
				МассивПравилКОбновлению.Добавить(ИсточникОбъект.НазначениеРасчетов);
				
			КонецЕсли;
					
		Исключение
			
			ШаблонСообщения = Нстр("ru = 'Не удалось обновить настройки источника данных %1 для расчетов показателя %2, 
			|правило обработки: %3
			|вид отчета: %4
			|%5'");
			
			Если Не ПустаяСтрока(ШаблонСообщения) тогда								
				ОбщегоНазначенияУХ.СообщитьОбОшибке(СтрШаблон(ШаблонСообщения, 
				ИсточникОбъект.Наименование, ИсточникОбъект.ПотребительРасчета, 
				ИсточникОбъект.НазначениеРасчетов, ИсточникОбъект.ПотребительРасчета.Владелец, 
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())),,, СтатусСообщения.Внимание);
			КонецЕсли;
			
			Отказ=Истина;
			Возврат;
			
		КонецПопытки;
		
	КонецЦикла;
	
	// Обновляем источники данных, связанные по реквизиту "ПотребительРасчета"
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	ИсточникиДанныхДляРасчетов.Ссылка
	|ИЗ
	|	Справочник.ИсточникиДанныхДляРасчетов КАК ИсточникиДанныхДляРасчетов
	|ГДЕ";
	
	МассивПравилКОбновлению=Новый Массив;
	
	Если НЕ ГруппаРаскрытия=Неопределено Тогда
		
		Запрос.Текст=Запрос.Текст+"	
		|	ИсточникиДанныхДляРасчетов.ПотребительРасчета.ГруппаРаскрытия = &ГруппаРаскрытия";
		
		Запрос.УстановитьПараметр("ГруппаРаскрытия",ГруппаРаскрытия);
		
	Иначе
		
		Запрос.Текст=Запрос.Текст+"	
		|	ИсточникиДанныхДляРасчетов.ПотребительРасчета = &ПоказательОтчета";
		
		Запрос.УстановитьПараметр("ПоказательОтчета",ПоказательОтчета);
		
	КонецЕсли;
	
	Результат=Запрос.Выполнить().Выбрать();
	
	ЕстьОшибки=Ложь;
	
	Пока Результат.Следующий() Цикл
		
		ИсточникОбъект=Результат.Ссылка.ПолучитьОбъект();
		
		ИсточникОбъект.ЗаполнитьТаблицуСоответствияПоУмолчанию	=Истина;
		ИсточникОбъект.ПравилаИспользованияПолейЗапроса.Очистить();
				
		ИсточникОбъект.ПодготовитьТаблицыСопоставленийИОтборов();
		ИсточникОбъект.мМодифицированность=Истина;
		ИсточникОбъект.СохранитьНастройкиОперанда();
		
		Попытка
			
			ИсточникОбъект.Записать();
			
			Если МассивПравилКОбновлению.Найти(ИсточникОбъект.НазначениеРасчетов)=Неопределено Тогда
				
				МассивПравилКОбновлению.Добавить(ИсточникОбъект.НазначениеРасчетов);
				
			КонецЕсли;
					
		Исключение
			
			ШаблонСообщения = Нстр("ru = 'Не удалось обновить настройки источника данных %1 для расчетов показателя %2, 
			|правило обработки: %3
			|вид отчета: %4
			|%5'");
			
			Если Не ПустаяСтрока(ШаблонСообщения) тогда								
				ОбщегоНазначенияУХ.СообщитьОбОшибке(СтрШаблон(ШаблонСообщения, 
				ИсточникОбъект.Наименование, ИсточникОбъект.ПотребительРасчета, 
				ИсточникОбъект.НазначениеРасчетов, ИсточникОбъект.ПотребительРасчета.Владелец, 
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())),,, СтатусСообщения.Внимание);
			КонецЕсли;
						
			Отказ=Истина;
			Возврат;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Для Каждого Правило ИЗ МассивПравилКОбновлению Цикл
		
		УправлениеОтчетамиУХ.ОчиститьЗаписиРегистраПараметрическихНастроек(Правило);
		
	КонецЦикла;
				
КонецПроцедуры // ОбновитьАналитикиИсточниковДанных() 

Функция ПолучитьВозможныйКодИсточникаДанных(ПроектКода, НазначениеРасчетов) Экспорт

	Если ПустаяСтрока(ПроектКода) Тогда
		
		Возврат "";
		
	КонецЕсли;
	
	ДлинаКода=Метаданные.Справочники.ИсточникиДанныхДляРасчетов.ДлинаКода;
		
	Если СтрДлина(СокрЛП(ПроектКода)) - ДлинаКода < -2 Тогда
		ТекПрефикс2 = СокрЛП(ПроектКода);
		ТекПрефикс3 = СокрЛП(ПроектКода);
	Иначе
		ТекПрефикс2 = Лев(СокрЛП(ПроектКода), ДлинаКода - 2);
		ТекПрефикс3 = Лев(СокрЛП(ПроектКода), ДлинаКода - 3);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	ТекСправочник.Код КАК Код,
	|	ВЫБОР
	|		КОГДА ТекСправочник.Код ПОДОБНО &Префикс3
	|			ТОГДА 3
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК РазрядностьНомера
	|ИЗ
	|	Справочник.ИсточникиДанныхДляРасчетов КАК ТекСправочник
	|ГДЕ
	|	ТекСправочник.НазначениеРасчетов = &НазначениеРасчетов
	|	И (ТекСправочник.Код ПОДОБНО &Префикс2
	|			ИЛИ ТекСправочник.Код ПОДОБНО &Префикс3)
	|
	|УПОРЯДОЧИТЬ ПО
	|	РазрядностьНомера УБЫВ,
	|	Код УБЫВ";
	
	Запрос.УстановитьПараметр("НазначениеРасчетов",НазначениеРасчетов);
	Запрос.УстановитьПараметр("Префикс2" , ТекПрефикс2 + "[0-9][0-9]%");
	Запрос.УстановитьПараметр("Префикс3" , ТекПрефикс3 + "[0-9][0-9][0-9]%");
	
	Запрос.Текст=ТекстЗапроса;
	
	Результат= Запрос.Выполнить().Выбрать();
	
	Если НЕ Результат.Следующий() Тогда
		Код = ТекПрефикс2 + "01";
		Возврат Код;
	КонецЕсли;
	
	МаксЗапись  = Результат.Код;
	
	Если ЗначениеЗаполнено(МаксЗапись) Тогда
		
		ТекРазрядностьНомера=Результат.РазрядностьНомера;
		МаксЗапись    = СокрЛП(МаксЗапись);
		ЧисловаяЧасть = Прав(МаксЗапись, ТекРазрядностьНомера);
		
		Попытка
			МаксЗначение = Число(ЧисловаяЧасть);
			
			НовоеЗначение=МаксЗначение+1;
			Если НовоеЗначение>=100 И ТекРазрядностьНомера=2 Тогда
				
				ТекРазрядностьНомера=3;
				Возврат ПолучитьВозможныйКодИсточникаДанных(Лев(МаксЗапись, СтрДлина(МаксЗапись) - ТекРазрядностьНомера), НазначениеРасчетов);
				
			КонецЕсли;
			
			Код = Лев(МаксЗапись, СтрДлина(МаксЗапись) - ТекРазрядностьНомера) + Формат(НовоеЗначение, "ЧЦ="+ТекРазрядностьНомера+"; ЧВН=");
		Исключение
			Код = Лев(МаксЗапись, СтрДлина(МаксЗапись) - ТекРазрядностьНомера) + ?(ТекРазрядностьНомера=2,"01","001");
		КонецПопытки;
		
	Иначе
		
		Код = ТекПрефикс2 + "01";
		
	КонецЕсли;
	
	Возврат Код;
	
КонецФункции // ПолучитьВозможныйКодСправочника()

Функция РедактированиеНазначенияРасчетов(НазначениеРасчетов) Экспорт
	
	Возврат
	НЕ Константы.ПроверятьУтверждениеНастроекОтчетов.Получить()
	Или НЕ ОбщегоНазначенияУХ.ЕстьРеквизитОбъекта("Утверждено", НазначениеРасчетов) 
	Или НЕ НазначениеРасчетов.Утверждено;
	
КонецФункции

Функция ПолучитьИсточникДляЗаполненияИзмерений(НазначениеРасчетов,РегистрИсточник,РегистрПриемник) Экспорт
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	ИсточникиДанныхДляРасчетов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ИсточникиДанныхДляРасчетов КАК ИсточникиДанныхДляРасчетов
	|ГДЕ
	|	ИсточникиДанныхДляРасчетов.НазначениеРасчетов = &НазначениеРасчетов
	|	И ИсточникиДанныхДляРасчетов.ПотребительРасчета = &ПотребительРасчета
	|	И ИсточникиДанныхДляРасчетов.РегистрБД = &РегистрБД
	|	И НЕ ИсточникиДанныхДляРасчетов.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("НазначениеРасчетов",	НазначениеРасчетов);
	Запрос.УстановитьПараметр("ПотребительРасчета",	РегистрПриемник);
	Запрос.УстановитьПараметр("РегистрБД",			РегистрИсточник);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		
		Возврат Результат.Ссылка;
		
	КонецЕсли;
	
	ТипБД=РегистрИсточник.Владелец;
	
	СправочникОбъект=Справочники.ИсточникиДанныхДляРасчетов.СоздатьЭлемент();
	СправочникОбъект.НазначениеРасчетов=НазначениеРасчетов;
	СправочникОбъект.ПотребительРасчета=РегистрПриемник;
	СправочникОбъект.СпособПолучения=?(ТипБД=Справочники.ТипыБазДанных.ТекущаяИБ,Перечисления.СпособыПолученияОперандов.ВнутренниеДанныеРегистрБухгалтерии,Перечисления.СпособыПолученияОперандов.ВнешниеДанныеРегистрБухгалтерии);
	СправочникОбъект.ТипБД=ТипБД;
	СправочникОбъект.РегистрБД=РегистрИсточник;
	СправочникОбъект.СпособИспользования=Перечисления.СпособыИспользованияОперандов.ДляЗаполненияОбъектовБД;
	СправочникОбъект.ТипБДПриемник=Справочники.ТипыБазДанных.ТекущаяИБ;
	СправочникОбъект.ПодготовитьТаблицыСопоставленийИОтборов();
	СправочникОбъект.СохранитьНастройкиОперанда();
	СправочникОбъект.Записать();
	
	Возврат СправочникОбъект.Ссылка;
		
КонецФункции // ПолучитьИсточникДляЗаполненияИзмерений()

Процедура ЗаполнитьПредопределенныеРасчетныеКритерииДляОценкиПредложений() Экспорт
	
	ИсточникДанных = Справочники.ИсточникиДанныхДляРасчетов.ПроцентОтМаксимальнойЦены.ПолучитьОбъект();
	ИсточникДанных.СпособПолучения = Перечисления.СпособыПолученияОперандов.ВнутренниеДанныеПроизвольныйЗапрос;
	ИсточникДанных.СпособИспользования = Перечисления.СпособыИспользованияОперандов.ДляАналитическихОтчетов;
	ИсточникДанных.ТипБД = Справочники.ТипыБазДанных.ТекущаяИБ;
	ИсточникДанных.ТипЗначения = Перечисления.ТипыЗначенийПоказателейОтчетов.Число;
	ИсточникДанных.ТекстОтбора = " ОбъектОценки=&ПараметрИсточника1";
	ИсточникДанных.ДополнительноеПредставление = "Пр: =Значение";
	ИсточникДанных.ТекстЗапросаМодуля = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПредложениеПоставщика.Лот КАК Лот
	|ПОМЕСТИТЬ Лоты
	|ИЗ
	|	Документ.ПредложениеПоставщика КАК ПредложениеПоставщика
	|ГДЕ
	|	ПредложениеПоставщика.Ссылка = &ОбъектОценки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СУММА(УсловияПредложенийПоставщиков.Сумма) КАК ЗначениеДляОценки,
	|	УсловияПредложенийПоставщиков.Регистратор КАК Регистратор
	|ПОМЕСТИТЬ СуммыПоПредложениям
	|ИЗ
	|	РегистрСведений.УсловияПредложенийПоставщиков КАК УсловияПредложенийПоставщиков
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Лоты КАК Лоты
	|		ПО (Лоты.Лот = УсловияПредложенийПоставщиков.Лот)
	|
	|СГРУППИРОВАТЬ ПО
	|	УсловияПредложенийПоставщиков.Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(СуммыПоПредложениям.ЗначениеДляОценки) КАК ЗначениеДляОценки
	|ПОМЕСТИТЬ МаксимальнаяСуммаПредложения
	|ИЗ
	|	СуммыПоПредложениям КАК СуммыПоПредложениям
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	100 - (СуммыПоПредложениям.ЗначениеДляОценки / МаксимальнаяСуммаПредложения.ЗначениеДляОценки)*100 КАК Значение
	|ИЗ
	|	СуммыПоПредложениям КАК СуммыПоПредложениям,
	|	МаксимальнаяСуммаПредложения КАК МаксимальнаяСуммаПредложения
	|ГДЕ
	|	СуммыПоПредложениям.Регистратор = &ОбъектОценки";
	Если ИсточникДанных.ПравилаИспользованияПолейЗапроса.Количество() = 0 Тогда
		Правила = ИсточникДанных.ПравилаИспользованияПолейЗапроса.Добавить();
		Правила.Поле = "Значение";
		Правила.Синоним = "Значение";
		Правила.КодАналитики = "Значение";
	КонецЕсли;
	Если ИсточникДанных.ТаблицаПараметровОтбораБД.Количество() = 0 Тогда
		ТаблицаПараметров = ИсточникДанных.ТаблицаПараметровОтбораБД.Добавить();
		ТаблицаПараметров.ПолеБД = "ОбъектОценки";
		ТаблицаПараметров.НаименованиеБД = "ОбъектОценки";
		ТаблицаПараметров.СпособВычисленияПараметра = Перечисления.СпособыВычисленияПараметровОперандов.ФункцияНаВстроенномЯзыкеЗначение;
		ТаблицаПараметров.ТипРасчета = "Функция";
		ТаблицаПараметров.ИмяПараметра = "ОбъектОценки";
	КонецЕсли;
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ИсточникДанных);
	
	
	ИсточникДанных = Справочники.ИсточникиДанныхДляРасчетов.ЦенаПоПредложению.ПолучитьОбъект();
	ИсточникДанных.СпособПолучения = Перечисления.СпособыПолученияОперандов.ВнутренниеДанныеПроизвольныйЗапрос;
	ИсточникДанных.СпособИспользования = Перечисления.СпособыИспользованияОперандов.ДляАналитическихОтчетов;
	ИсточникДанных.ТипБД = Справочники.ТипыБазДанных.ТекущаяИБ;
	ИсточникДанных.ТипЗначения = Перечисления.ТипыЗначенийПоказателейОтчетов.Число;
	ИсточникДанных.ТекстОтбора = " ОбъектОценки=&ПараметрИсточника1";
	ИсточникДанных.ДополнительноеПредставление = "Пр: =Значение";
	ИсточникДанных.ТекстЗапросаМодуля = "ВЫБРАТЬ
	|	СУММА(УсловияПредложенийПоставщиков.Сумма) КАК Значение
	|ИЗ
	|	РегистрСведений.УсловияПредложенийПоставщиков КАК УсловияПредложенийПоставщиков
	|ГДЕ
	|	УсловияПредложенийПоставщиков.Регистратор = &ОбъектОценки";
	Если ИсточникДанных.ПравилаИспользованияПолейЗапроса.Количество() = 0 Тогда
		Правила = ИсточникДанных.ПравилаИспользованияПолейЗапроса.Добавить();
		Правила.Поле = "Значение";
		Правила.Синоним = "Значение";
		Правила.КодАналитики = "Значение";
	КонецЕсли;
	Если ИсточникДанных.ТаблицаПараметровОтбораБД.Количество() = 0 Тогда
		ТаблицаПараметров = ИсточникДанных.ТаблицаПараметровОтбораБД.Добавить();
		ТаблицаПараметров.ПолеБД = "ОбъектОценки";
		ТаблицаПараметров.НаименованиеБД = "ОбъектОценки";
		ТаблицаПараметров.СпособВычисленияПараметра = Перечисления.СпособыВычисленияПараметровОперандов.ФункцияНаВстроенномЯзыкеЗначение;
		ТаблицаПараметров.ТипРасчета = "Функция";
		ТаблицаПараметров.ИмяПараметра = "ОбъектОценки";
	КонецЕсли;
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ИсточникДанных);
	
	ИсточникДанных = Справочники.ИсточникиДанныхДляРасчетов.СрокПоставки.ПолучитьОбъект();
	ИсточникДанных.СпособПолучения = Перечисления.СпособыПолученияОперандов.ВнутренниеДанныеПроизвольныйЗапрос;
	ИсточникДанных.СпособИспользования = Перечисления.СпособыИспользованияОперандов.ДляАналитическихОтчетов;
	ИсточникДанных.ТипБД = Справочники.ТипыБазДанных.ТекущаяИБ;
	ИсточникДанных.ТипЗначения = Перечисления.ТипыЗначенийПоказателейОтчетов.Число;
	ИсточникДанных.ТекстОтбора = " ОбъектОценки=&ПараметрИсточника1";
	ИсточникДанных.ДополнительноеПредставление = "Пр: =Значение";
	ИсточникДанных.ТекстЗапросаМодуля = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПредложениеПоставщика.СрокПоставки КАК Значение
	|ИЗ
	|	Документ.ПредложениеПоставщика КАК ПредложениеПоставщика
	|ГДЕ
	|	ПредложениеПоставщика.Ссылка = &ОбъектОценки";
	Если ИсточникДанных.ПравилаИспользованияПолейЗапроса.Количество() = 0 Тогда
		Правила = ИсточникДанных.ПравилаИспользованияПолейЗапроса.Добавить();
		Правила.Поле = "Значение";
		Правила.Синоним = "Значение";
		Правила.КодАналитики = "Значение";
	КонецЕсли;
	Если ИсточникДанных.ТаблицаПараметровОтбораБД.Количество() = 0 Тогда
		ТаблицаПараметров = ИсточникДанных.ТаблицаПараметровОтбораБД.Добавить();
		ТаблицаПараметров.ПолеБД = "ОбъектОценки";
		ТаблицаПараметров.НаименованиеБД = "ОбъектОценки";
		ТаблицаПараметров.СпособВычисленияПараметра = Перечисления.СпособыВычисленияПараметровОперандов.ФункцияНаВстроенномЯзыкеЗначение;
		ТаблицаПараметров.ТипРасчета = "Функция";
		ТаблицаПараметров.ИмяПараметра = "ОбъектОценки";
	КонецЕсли;
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ИсточникДанных);
		
КонецПроцедуры	

Функция ПолучитьМассивСпособовВычисленияВнеКонтекста() Экспорт
	
	МассивСпособов=Новый Массив;
	МассивСпособов.Добавить(Перечисления.СпособыВычисленияПараметровОперандов.Больше);
	МассивСпособов.Добавить(Перечисления.СпособыВычисленияПараметровОперандов.БольшеИлиРавно);
	МассивСпособов.Добавить(Перечисления.СпособыВычисленияПараметровОперандов.ГруппаИ);
	МассивСпособов.Добавить(Перечисления.СпособыВычисленияПараметровОперандов.ГруппаИЛИ);
	МассивСпособов.Добавить(Перечисления.СпособыВычисленияПараметровОперандов.ГруппаНЕ);
	МассивСпособов.Добавить(Перечисления.СпособыВычисленияПараметровОперандов.Меньше);
	МассивСпособов.Добавить(Перечисления.СпособыВычисленияПараметровОперандов.МеньшеИлиРавно);
	МассивСпособов.Добавить(Перечисления.СпособыВычисленияПараметровОперандов.НеВСпискеПоИерархии);
	МассивСпособов.Добавить(Перечисления.СпособыВычисленияПараметровОперандов.НеВСпискеФиксированныхЗначений);
	МассивСпособов.Добавить(Перечисления.СпособыВычисленияПараметровОперандов.НеРавноФиксированномуЗначению);
	МассивСпособов.Добавить(Перечисления.СпособыВычисленияПараметровОперандов.СписокПоИерархии);
	МассивСпособов.Добавить(Перечисления.СпособыВычисленияПараметровОперандов.СписокТиповЗначений);
	МассивСпособов.Добавить(Перечисления.СпособыВычисленияПараметровОперандов.СписокФиксированныхЗначений);
	МассивСпособов.Добавить(Перечисления.СпособыВычисленияПараметровОперандов.ФиксированноеЗначение);
	МассивСпособов.Добавить(Перечисления.СпособыВычисленияПараметровОперандов.ФункцияНаВстроенномЯзыкеЗначение);
	МассивСпособов.Добавить(Перечисления.СпособыВычисленияПараметровОперандов.ФункцияНаВстроенномЯзыкеСписокЗначений);

	Возврат МассивСпособов;
	
КонецФункции // ПолучитьМассивСпособовВычисленияПоКонтексту() 
	
	
	


#КонецЕсли