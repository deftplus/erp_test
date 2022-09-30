
#Область ПрограммныйИнтерфейс

// Устанавливает страницу доставки в зависимости от способа доставки.
//
// Параметры:
//  ЭлементыФормы	 - ВсеЭлементыФормы - элементы формы, в которой устанавливается страница доставки.
//  СпособДоставки	 - ПеречислениеСсылка.СпособыДоставки	 - способ доставки, в зависимости от которого
//  	выбирается страница доставки.
//  ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками	 - Булево - Истина, признак использования заданий
//  	на перевозку для учета доставки перевозчикам.
//  ЭтоРаспоряжениеПоСоглашению - Булево - признак того, что распоряжением является соглашение.
//  ЭтоРаспоряжениеПоДоговору - Булево - признак того, что распоряжением является договор.
//
Процедура УстановитьСтраницуДоставки(ЭлементыФормы,
	СпособДоставки,
	ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками = Неопределено,
	ЭтоРаспоряжениеПоСоглашению = Ложь,
	ЭтоРаспоряжениеПоДоговору = Ложь) Экспорт
	
	Если ЭтоРаспоряжениеПоСоглашению Или ЭтоРаспоряжениеПоДоговору Тогда
		Если ЭлементыФормы.Найти("ГруппаСводнаяИнформацияПоДоставке") <> Неопределено Тогда
			ЭлементыФормы.СтраницыДоставки.ТекущаяСтраница = ЭлементыФормы.ГруппаСводнаяИнформацияПоДоставке;
		КонецЕсли;
		Если ЭлементыФормы.Найти("ГруппаСпособДоставкиПеревозчик") <> Неопределено Тогда
			ЭлементыФормы.ГруппаСпособДоставкиПеревозчик.Видимость = Ложь;
		КонецЕсли;
		Если ЭтоРаспоряжениеПоСоглашению
			И ЭлементыФормы.Найти("ГруппаНадписьНастройкаПараметровДоставки") <> Неопределено Тогда
			ЭлементыФормы.ГруппаНадписьНастройкаПараметровДоставки.ТекущаяСтраница = ЭлементыФормы.ГруппаНадписьНастройкаПараметровДоставкиСоглашение;
		ИначеЕсли Не ЭтоРаспоряжениеПоСоглашению
			И ЭлементыФормы.Найти("ГруппаНадписьНастройкаПараметровДоставки") <> Неопределено Тогда
			ЭлементыФормы.ГруппаНадписьНастройкаПараметровДоставки.ТекущаяСтраница = ЭлементыФормы.ГруппаНадписьНастройкаПараметровДоставкиДоговор;
		КонецЕсли;
	Иначе
		Если ЭлементыФормы.Найти("ГруппаСпособДоставкиПеревозчик") <> Неопределено Тогда
			ЭлементыФормы.ГруппаСпособДоставкиПеревозчик.Видимость = Истина;
		КонецЕсли;
		Если ЭлементыФормы.Найти("СтраницыПеревозчик") <> Неопределено Тогда
			Если СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчика")
				Или СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчикаПоАдресу")
				Или СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчикаДоНашегоСклада")
				Или СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчикаДоПунктаПередачи") Тогда
				ЭлементыФормы.СтраницыПеревозчик.ТекущаяСтраница = ЭлементыФормы.СтраницаПеревозчик;
			Иначе
				ЭлементыФормы.СтраницыПеревозчик.ТекущаяСтраница = ЭлементыФормы.СтраницаПеревозчикПусто;
			КонецЕсли;
		КонецЕсли;
		
		Если (СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.ДоКлиентаКурьером"))
			И (ЭлементыФормы.Найти("СтраницаДоставкаДоПолучателяКурьером") <> Неопределено) Тогда
			ЭлементыФормы.СтраницыПеревозчик.ТекущаяСтраница = ЭлементыФормы.СтраницаКурьер;
		КонецЕсли;
		
		Если (СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.ДоКлиента")
			Или СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.КПолучателюОпределяетСлужбаДоставки"))
			И ЭлементыФормы.Найти("СтраницаДоставкаДоПолучателя") <> Неопределено Тогда
			ЭлементыФормы.СтраницыДоставки.ТекущаяСтраница = ЭлементыФормы.СтраницаДоставкаДоПолучателя;
			
		ИначеЕсли (СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.ДоКлиентаКурьером"))
			И (ЭлементыФормы.Найти("СтраницаДоставкаДоПолучателяКурьером") <> Неопределено) Тогда
			ЭлементыФормы.СтраницыДоставки.ТекущаяСтраница = ЭлементыФормы.СтраницаДоставкаДоПолучателяКурьером;
			
		ИначеЕсли СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчика")
			И ЭлементыФормы.Найти("СтраницаДоставкаПеревозчиком") <> Неопределено Тогда
			ЭлементыФормы.СтраницыДоставки.ТекущаяСтраница = ЭлементыФормы.СтраницаДоставкаПеревозчиком;
			
		ИначеЕсли СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчикаПоАдресу") Тогда
			Если ЭлементыФормы.Найти("СтраницаДоставкаПеревозчикомПоАдресу") <> Неопределено Тогда
				ЭлементыФормы.СтраницыДоставки.ТекущаяСтраница = ЭлементыФормы.СтраницаДоставкаПеревозчикомПоАдресу;
			ИначеЕсли ЭлементыФормы.Найти("СтраницаДоставкаПеревозчиком") <> Неопределено Тогда
				ЭлементыФормы.СтраницыДоставки.ТекущаяСтраница = ЭлементыФормы.СтраницаДоставкаПеревозчиком;
			КонецЕсли;
			
		ИначеЕсли СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.НашимиСиламиСАдресаОтправителя")
			Или СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчикаДоПунктаПередачи")
			Или СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.ОтОтправителяОпределяетСлужбаДоставки") Тогда
			
			ЭлементыФормы.СтраницыДоставки.ТекущаяСтраница = ЭлементыФормы.СтраницаДоставкаНашимиСилами;
			Если СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчикаДоПунктаПередачи") Тогда
				ЭлементыФормы.СтраницыАдресПередачи.ТекущаяСтраница = ЭлементыФормы.СтраницаАдресПеревозчика;
			Иначе
				ЭлементыФормы.СтраницыАдресПередачи.ТекущаяСтраница = ЭлементыФормы.СтраницаАдресПоставщика;
			КонецЕсли;
			
		ИначеЕсли ЭлементыФормы.Найти("СтраницаСамовывоз") <> Неопределено Тогда
			
			ЭлементыФормы.СтраницыДоставки.ТекущаяСтраница = ЭлементыФормы.СтраницаСамовывоз;
			
		ИначеЕсли ЭлементыФормы.Найти("СтраницаДоставкаНеНашимиСилами") <> Неопределено Тогда
			
			ЭлементыФормы.СтраницыДоставки.ТекущаяСтраница = ЭлементыФормы.СтраницаДоставкаНеНашимиСилами;
			
		КонецЕсли;
	КонецЕсли;
	
	ЭлементыФормы.СтраницыДоставки.Видимость = Не ((СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.ОпределяетсяВРаспоряжении"))
		И ЭлементыФормы.Найти("СтраницыДоставки") <> Неопределено);
	
	Если ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками = Неопределено
		Или ЭлементыФормы.Найти("СтраницаДоставка") = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДоставкаИспользуется(СпособДоставки, ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками) Тогда
		ЭлементыФормы.СтраницаДоставка.Картинка = БиблиотекаКартинок.Комментарий;
	Иначе
		ЭлементыФормы.СтраницаДоставка.Картинка = Новый Картинка;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру реквизитов доставки, заполненную пустыми значениями.
//
// Параметры:
//  ДокОбъект	 - ДокументОбъект, ДанныеФормыСтруктура - данные документа-объекта.
// 
// Возвращаемое значение:
//  Структура - реквизиты доставки с пустыми значениями полей.
//
Функция ПолучитьПустуюСтруктуруРеквизитовДоставки(ДокОбъект = Неопределено) Экспорт
	
	РеквизитыДоставки = Новый Структура;
	Если ЭтоРаспоряжениеНаДоставкуНаНашСклад(ДокОбъект) Тогда
		РеквизитыДоставки.Вставить("СпособДоставки", ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПоставщикаДоНашегоСклада"));
	ИначеЕсли ЭтоПоручениеЭкспедитору(ДокОбъект) Тогда
		РеквизитыДоставки.Вставить("СпособДоставки", ПредопределенноеЗначение("Перечисление.СпособыДоставки.ПоручениеЭкспедиторуСоСклада"));
	Иначе
		РеквизитыДоставки.Вставить("СпособДоставки",ПредопределенноеЗначение("Перечисление.СпособыДоставки.Самовывоз"));
	КонецЕсли;
	РеквизитыДоставки.Вставить("СпособДоставкиОбъект",ПредопределенноеЗначение("Перечисление.СпособыДоставки.Самовывоз"));
	РеквизитыДоставки.Вставить("ЗонаДоставки",ПредопределенноеЗначение("Справочник.ЗоныДоставки.ПустаяСсылка"));
	РеквизитыДоставки.Вставить("ВремяДоставкиС",Дата(1,1,1));
	РеквизитыДоставки.Вставить("ВремяДоставкиПо",Дата(1,1,1));
	РеквизитыДоставки.Вставить("ПеревозчикПартнер",ПредопределенноеЗначение("Справочник.Партнеры.ПустаяСсылка"));
	РеквизитыДоставки.Вставить("АдресДоставки","");
	РеквизитыДоставки.Вставить("АдресДоставкиЗначение","");
	РеквизитыДоставки.Вставить("АдресДоставкиПеревозчика","");
	РеквизитыДоставки.Вставить("АдресДоставкиПеревозчикаЗначение","");
	РеквизитыДоставки.Вставить("АдресДоставкиЗначенияПолей","");
	РеквизитыДоставки.Вставить("АдресДоставкиПеревозчикаЗначенияПолей","");
	РеквизитыДоставки.Вставить("ДополнительнаяИнформацияПоДоставке","");
	РеквизитыДоставки.Вставить("ОсобыеУсловияПеревозки",Ложь);
	РеквизитыДоставки.Вставить("ОсобыеУсловияПеревозкиОписание","");
	
	// СборкаИДоставка
	РеквизитыДоставки.Вставить("Курьер",ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка"));
	// Конец СборкаИДоставка
	
	Возврат РеквизитыДоставки;
	
КонецФункции

// Ищет в списке значений элемент-структуру, значение свойства которой равно искомому.
// Если такое значение не найдено, возвращается Неопределено.
//
// Параметры:
//	Список - СписокЗначений - список в котором выполняется поиск;
//	ИмяПоляСтруктуры - Строка - имя искомого свойства структуры;
//	ИскомоеЗначение - Произвольный - значение, которое требуется найти.
//
// Возвращаемое значение:
//	Структура - структура, значения свойств которой совпадает с искомым, если таких несколько, 
//		возвращается первая найденная.
//
Функция НайтиВСпискеСтруктур(Список, ИмяПоляСтруктуры, ИскомоеЗначение) Экспорт
	Перем НайденноеЗначение;
	Для Каждого Элемент Из Список Цикл
		Элемент.Значение.Свойство(ИмяПоляСтруктуры, НайденноеЗначение);
		Если НайденноеЗначение = ИскомоеЗначение Тогда
			Возврат Элемент;
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции

// Очищает списки выбора адресов доставки и реквизиты доставки.
//
// Параметры:
//	ЭлементыФормы - ВсеЭлементыФормы - элементы формы, в которых очищаются списки выбора адресов доставки;
//	ДокОбъект - ДокументОбъект - объект, в котором очищаются реквизиты доставки.
//
Процедура ОчиститьРеквизитыДоставки(ЭлементыФормы, ДокОбъект) Экспорт
	ОчиститьСпискиВыбораАдресовПолучателяОтправителя(ЭлементыФормы);
	Если ЭлементыФормы.Найти("АдресДоставкиПеревозчика") <> Неопределено Тогда
		ЭлементыФормы.АдресДоставкиПеревозчика.СписокВыбора.Очистить();
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ДокОбъект, ПолучитьПустуюСтруктуруРеквизитовДоставки(ДокОбъект));
	Если ЭлементыФормы.Найти("СтраницыДоставки") <> Неопределено Тогда
		УстановитьСтраницуДоставки(ЭлементыФормы, ДокОбъект.СпособДоставки);
	КонецЕсли;
КонецПроцедуры

// Очищает списки выбора адресов доставки.
//
// Параметры:
//	ЭлементыФормы - ВсеЭлементыФормы - элементы формы, в которых очищаются списки выбора адресов доставки.
//
Процедура ОчиститьСпискиВыбораАдресовПолучателяОтправителя(ЭлементыФормы) Экспорт
	
	Если ЭлементыФормы.Найти("АдресДоставкиПолучателя") <> Неопределено Тогда
		ЭлементыФормы.АдресДоставкиПолучателя.СписокВыбора.Очистить();
	КонецЕсли;
	Если ЭлементыФормы.Найти("АдресДоставкиПолучателя1") <> Неопределено Тогда
		ЭлементыФормы.АдресДоставкиПолучателя1.СписокВыбора.Очистить();
	КонецЕсли;
	Если ЭлементыФормы.Найти("АдресДоставкиПолучателя2") <> Неопределено Тогда
		ЭлементыФормы.АдресДоставкиПолучателя2.СписокВыбора.Очистить();
	КонецЕсли;
	Если ЭлементыФормы.Найти("АдресПоставщика") <> Неопределено Тогда
		ЭлементыФормы.АдресПоставщика.СписокВыбора.Очистить();
	КонецЕсли;
	Если ЭлементыФормы.Найти("АдресПункта") <> Неопределено Тогда
		ЭлементыФормы.АдресПункта.СписокВыбора.Очистить();
	КонецЕсли;
	
КонецПроцедуры

// Возвращает список значений. Преобразует в список значений строку полей, разделенных символом перевода строки.
//
// Параметры:
//	СтрокаПолей - Строка - строка, в которой каждое поле начинается с новой строки.
//
// Возвращаемое значение:
//	СписокЗначений - список значений полей.
//
Функция ПреобразоватьСтрокуВСписокПолей(СтрокаПолей) Экспорт
	
	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(СтрокаПолей) Тогда
		Возврат СтрокаПолей; // строка в новом формате, раскладывать в список не нужно
	КонецЕсли;
	
	Результат = Новый СписокЗначений;
	ПоследнийЭлемент = Неопределено;
	
	Для Итерация = 1 По СтрЧислоСтрок(СтрокаПолей) Цикл
		ПолученнаяСтрока = СтрПолучитьСтроку(СтрокаПолей, Итерация);
		Если Лев(ПолученнаяСтрока, 1) = Символы.Таб Тогда
			Если ПоследнийЭлемент <> Неопределено Тогда
				ПоследнийЭлемент.Значение = ПоследнийЭлемент.Значение + Символы.ПС + Сред(ПолученнаяСтрока, 2);
			КонецЕсли;
		Иначе
			ПозицияСимвола = СтрНайти(ПолученнаяСтрока, "=");
			Если ПозицияСимвола <> 0 Тогда
				ПоследнийЭлемент = Результат.Добавить(Сред(ПолученнаяСтрока, ПозицияСимвола + 1), Лев(ПолученнаяСтрока, ПозицияСимвола - 1));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает наименования документов, которые могут являться распоряжениями на доставку.
//
// Возвращаемое значение:
//	Массив из Структура - массив структур с полями:
//		* Имя - Строка - имя документа;
//		* ЭтоЗаказ - Булево - признак документа, который является заказом;
//		* ИмяПоляСклад - Строка - имя поля склад, если оно отличается от "Склад".
//
Функция ОписанияРаспоряженийНаДоставку() Экспорт
	
	Описания = Новый Массив;
	
	//++ НЕ УТ
	Описание = ОписаниеРаспоряженияНаДоставку();
	Описание.Имя               = "ЗаказПереработчику";
	Описание.ЭтоЗаказ          = Истина;
	Описание.ИмяТЧ             = "Материалы";
	Описание.ИмяПоляСклад      = "ТЧ.Склад";
	Описания.Добавить(Описание);
	//-- НЕ УТ
	
	Описание = ОписаниеРаспоряженияНаДоставку();
	Описание.Имя               = "ОтгрузкаТоваровСХранения";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеРаспоряженияНаДоставку();
	Описание.Имя               = "ПередачаТоваровХранителю";
	Описание.ИмяПоляСклад      = "ТЧ.Склад";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеРаспоряженияНаДоставку();
	Описание.Имя               = "ПриемкаТоваровНаХранение";
	Описание.ИмяПоляСклад      = "ТЧ.Склад";
	Описание.ИмяПоляСерия      = "ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)";
	Описания.Добавить(Описание);
	
	//++ НЕ УТКА
	Описание = ОписаниеРаспоряженияНаДоставку();
	Описание.Имя               = "ЗаказДавальца";
	Описание.ЭтоЗаказ          = Истина;
	Описание.ИмяТЧ             = "Продукция";
	Описание.ИмяПоляСклад      = "ТЧ.Склад";
	Описание.ИмяПоляНазначение = "Шапка.Назначение";
	Описания.Добавить(Описание);
	//-- НЕ УТКА
	
	Описание = ОписаниеРаспоряженияНаДоставку();
	Описание.Имя               = "ЗаказКлиента";
	Описание.ЭтоЗаказ          = Истина;
	Описание.ИмяПоляСклад      = "ТЧ.Склад";
	Описание.ИмяПоляНазначение = 
	"ВЫБОР
	|		КОГДА ТЧ.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить)
	|			И ТЧ.Обособленно
	|			И ЕСТЬNULL(Шапка.Назначение.ДвиженияПоСкладскимРегистрам, ЛОЖЬ)
	|			ТОГДА Шапка.Назначение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	КОНЕЦ";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеРаспоряженияНаДоставку();
	Описание.Имя               = "ЗаявкаНаВозвратТоваровОтКлиента";
	Описание.ЭтоЗаказ          = Истина;
	Описание.ИмяТЧ             = "ЗаменяющиеТовары";
	Описание.ИмяПоляНазначение = "Шапка.Назначение";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеРаспоряженияНаДоставку();
	Описание.Имя               = "ЗаказНаПеремещение";
	Описание.ЭтоЗаказ          = Истина;
	Описание.ИмяПоляСклад      = "Шапка.СкладОтправитель";
	Описание.ИмяПоляПолучательОтправитель = "СкладПолучатель";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеРаспоряженияНаДоставку();
	Описание.Имя               = "ПеремещениеТоваров";
	Описание.ИмяПоляСклад      = "Шапка.СкладОтправитель";
	Описание.ИмяПоляПолучательОтправитель = "СкладПолучатель";
	Описание.ИмяПоляНазначение = "ТЧ.НазначениеОтправителя";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеРаспоряженияНаДоставку();
	Описание.Имя               = "РеализацияТоваровУслуг";
	Описание.ИмяПоляСклад      = "ТЧ.Склад";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеРаспоряженияНаДоставку();
	Описание.Имя               = "ВозвратТоваровПоставщику";
	Описания.Добавить(Описание);
	
	Описание = ОписаниеРаспоряженияНаДоставку();
	Описание.Имя               = "ЗаказПоставщику";
	Описание.ЭтоЗаказ          = Истина;
	Описание.ИмяПоляСклад      = "ТЧ.Склад";
	Описание.ИмяПоляСерия      = "ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)";
	Описания.Добавить(Описание);
	Описание = ОписаниеРаспоряженияНаДоставку();
	
	Описание.Имя               = "ПриобретениеТоваровУслуг";
	Описание.ИмяПоляСклад      = "ТЧ.Склад";
	Описание.ИмяПоляСерия      = "ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)";
	Описания.Добавить(Описание);
	
	Возврат Описания;
	
КонецФункции

// Возвращает время без даты.
//
// Параметры:
//  ДатаВремя	 - Дата	 - дата.
// 
// Возвращаемое значение:
//  Дата - время без даты.
//
Функция ВремяБезДаты(ДатаВремя) Экспорт
	Возврат Дата(1,1,1,Час(ДатаВремя),Минута(ДатаВремя),Секунда(ДатаВремя));
КонецФункции

// Возвращает строку со временем доставки в виде "%ВремяС% - %ВремяПо%".
//
// Параметры:
//  ВремяС	 - Дата	 - время начала;
//  ВремяПо	 - Дата	 - время окончания.
// 
// Возвращаемое значение:
//  Строка - представление времени доставки в формате "%ВремяС% - %ВремяПо%".
//
Функция ПредставлениеВремениДоставки(ВремяС, ВремяПо) Экспорт
	
	Если ЗначениеЗаполнено(ВремяПо) Тогда
		Текст = НСтр("ru = '%ВремяС% - %ВремяПо%';
					|en = '%ВремяС% - %ВремяПо%'");
		Текст = СтрЗаменить(Текст, "%ВремяС%", Формат(ВремяС, "ДФ=ЧЧ:мм"));
		Возврат СтрЗаменить(Текст, "%ВремяПо%", Формат(ВремяПо, "ДФ=ЧЧ:мм"));
	Иначе
		Возврат Формат(ВремяС, "ДФ=ЧЧ:мм");
	КонецЕсли;
	
КонецФункции

// Возвращает представление получателя для доставки,
//  если доставка перевозчиком, то представление имеет вид "%Перевозчик% (%ПолучательОтправитель%)".
//
// Параметры:
//  ПолучательОтправитель	 - СправочникСсылка.Партнеры - получатель / отправитель груза;
//  Перевозчик				 - СправочникСсылка.Партнеры - перевозчик;
//  ВидДоставки				 - ПеречислениеСсылка.ВидыДоставки - вид доставки.
// 
// Возвращаемое значение:
//  Строка - представление получателя / отправителя груза.
//
Функция ПредставлениеПолучателяОтправителя(ПолучательОтправитель, Перевозчик, ВидДоставки) Экспорт
	
	Если ЗначениеЗаполнено(Перевозчик) Тогда
		Если ВидДоставки = ПредопределенноеЗначение("Перечисление.ВидыДоставки.СоСклада") Тогда
			Текст = НСтр("ru = '%Перевозчик% (для %ПолучательОтправитель%)';
						|en = '%Перевозчик% (for %ПолучательОтправитель%)'");
		Иначе
			Текст = НСтр("ru = '%Перевозчик% (от %ПолучательОтправитель%)';
						|en = '%Перевозчик% (from %ПолучательОтправитель%)'");
		КонецЕсли;
		Текст = СтрЗаменить(Текст,"%ПолучательОтправитель%",ПолучательОтправитель);
		Возврат СтрЗаменить(Текст,"%Перевозчик%",Перевозчик);
	Иначе
		Возврат Строка(ПолучательОтправитель);
	КонецЕсли;
	
КонецФункции

// Возвращает имя реквизита по элементу управляемой формы, связанном с адресом доставки.
//
// Параметры:
//  Элемент	 - ПолеФормы - элемент формы, связанный с реквизитом "АдресДоставки".
// 
// Возвращаемое значение:
//  Строка - имя реквизита по элементу управляемой формы, связанным с адресом доставки.
//
Функция ПолучитьИмяРеквизитаАдресаДоставки(Элемент) Экспорт
	
	Если СтрНайти(Элемент.Имя, "АдресДоставкиПеревозчика") > 0 Тогда
		ИмяРеквизитаАдреса = "АдресДоставкиПеревозчика";
	Иначе
		ИмяРеквизитаАдреса = "АдресДоставки";
	КонецЕсли;
	
	Возврат ИмяРеквизитаАдреса;
	
КонецФункции

// Проверяет - было ли изменено поле ДополнительнаяИнформацияПоДоставке пользователем.
//
// Параметры:
//	ЭлементыФормы - ВсеЭлементыФормы - элементы формы, в которой производится проверка;
//	ДокОбъект - ДокументОбъект - документ для проверки.
//
// Возвращаемое значение:
//	Булево - Истина - значение поля "ДополнительнаяИнформацияПоДоставке" изменено.
//
Функция ДопИнфоИзмененоПользователем(ЭлементыФормы, ДокОбъект) Экспорт
	
	ДопИнфоИзменено = Ложь;
	ДопИнфо = ДокОбъект.ДополнительнаяИнформацияПоДоставке;
	
	Если Не ЗначениеЗаполнено(ДопИнфо) Тогда
		
		Возврат Ложь;
		
	ИначеЕсли ЭлементыФормы.Найти("АдресПоставщика") <> Неопределено Тогда
		
		ДопИнфоИзменено = Не ДопИнфоЕстьВСпискеВыбораЭлемента(ЭлементыФормы.АдресПоставщика, ДопИнфо);
		
	ИначеЕсли ЭлементыФормы.Найти("АдресПункта") <> Неопределено Тогда
		
		ДопИнфоИзменено = Не ДопИнфоЕстьВСпискеВыбораЭлемента(ЭлементыФормы.АдресПункта, ДопИнфо);
		
	Иначе
		
		ДопИнфоИзменено = Не ДопИнфоЕстьВСпискеВыбораЭлемента(ЭлементыФормы.АдресДоставкиПолучателя, ДопИнфо);
		Если ЭлементыФормы.Найти("АдресДоставкиПолучателя1") <> Неопределено
			И Не ДопИнфоИзменено Тогда
			ДопИнфоИзменено = Не ДопИнфоЕстьВСпискеВыбораЭлемента(ЭлементыФормы.АдресДоставкиПолучателя1, ДопИнфо);
		КонецЕсли;
	КонецЕсли;
		
	Если ЭлементыФормы.Найти("АдресДоставкиПеревозчика") <> Неопределено
		И Не ДопИнфоИзменено Тогда
		ДопИнфоИзменено = Не ДопИнфоЕстьВСпискеВыбораЭлемента(ЭлементыФормы.АдресДоставкиПеревозчика, ДопИнфо);
	КонецЕсли;
	
	Возврат ДопИнфоИзменено;
	
КонецФункции

// Функция - Способы доставки до клиента с нашим участием
//
// Параметры:
//  ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками	 - Булево - значение функциональной опции ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками.
// 
// Возвращаемое значение:
//  Массив - массив способов доставки.
//
Функция СпособыДоставкиДоКлиентаСНашимУчастием(ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками) Экспорт 
	
	СпособыДоставки = Новый Массив;
	
	СпособыДоставки.Добавить(ПредопределенноеЗначение("Перечисление.СпособыДоставки.ДоКлиента"));
	СпособыДоставки.Добавить(ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчикаПоАдресу"));
	СпособыДоставки.Добавить(ПредопределенноеЗначение("Перечисление.СпособыДоставки.КПолучателюОпределяетСлужбаДоставки"));
	
	Если ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками Тогда
		СпособыДоставки.Добавить(ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчика"));
	КонецЕсли;
	
	Возврат СпособыДоставки;
	
КонецФункции

// Рассчитывает недогруз или перегруз транспортного средства по весу и объему,
//	выводит результат в надписи и отображает соответствующую заполненности транспорта картинку.
//
// Параметры:
//  Форма			 - ФормаКлиентскогоПриложения - форма, в которой необходимо вывести надписи
//  ДанныеВесОбъем	 - ДанныеФормыЭлементКоллекции, Неопределено - данные, по которым производится расчет.
//
Процедура ОтобразитьНедогрузПерегруз(Форма,ДанныеВесОбъем) Экспорт
	
	Элементы = Форма.Элементы;
	Если ДанныеВесОбъем <> Неопределено Тогда
		НедогрузВес = Окр(ДанныеВесОбъем.ГрузоподъемностьВЕдПользователя  - ДанныеВесОбъем.Вес);
		НедогрузОбъем = Окр(ДанныеВесОбъем.ВместимостьВЕдПользователя - ДанныеВесОбъем.Объем);
	КонецЕсли;
	
	Шаблон = НСтр("ru = '%Количество% %ЕдиницаИзмерения%';
					|en = '%Количество% %ЕдиницаИзмерения%'");
	
	Если ДанныеВесОбъем = Неопределено
		Или ДанныеВесОбъем.ГрузоподъемностьВЕдПользователя = 0 Тогда
		Форма.НадписьНедогрузВес = "";
		Элементы.ДекорацияВес.Картинка = Новый Картинка;
	ИначеЕсли НедогрузВес >= 0 Тогда
		Текст = СтрЗаменить(Шаблон, "%Количество%", НедогрузВес);
		Текст = СтрЗаменить(Текст, "%ЕдиницаИзмерения%", Форма.ЕдиницаИзмеренияВеса);
		Форма.НадписьНедогрузВес = Новый ФорматированнаяСтрока(Текст,Новый Шрифт(,,Истина),Форма.ЦветЗеленый);
		ЗаполненностьВес = ДанныеВесОбъем.Вес / ДанныеВесОбъем.ГрузоподъемностьВЕдПользователя * 100;
		Если ЗаполненностьВес > 95 Тогда
			Элементы.ДекорацияВес.Картинка = БиблиотекаКартинок.Состояние100Процентов;
		ИначеЕсли ЗаполненностьВес > 45 Тогда
			Элементы.ДекорацияВес.Картинка = БиблиотекаКартинок.Состояние66Процентов;
		ИначеЕсли ЗаполненностьВес > 5 Тогда
			Элементы.ДекорацияВес.Картинка = БиблиотекаКартинок.Состояние33Процента;
		Иначе
			Элементы.ДекорацияВес.Картинка = БиблиотекаКартинок.Состояние0Процентов;
		КонецЕсли;
	Иначе
		Текст = СтрЗаменить(Шаблон, "%Количество%", -НедогрузВес);
		Текст = СтрЗаменить(Текст, "%ЕдиницаИзмерения%", Форма.ЕдиницаИзмеренияВеса);
		Форма.НадписьНедогрузВес = Новый ФорматированнаяСтрока(Текст,Новый Шрифт(,,Истина),Форма.ЦветКрасный);
		Элементы.ДекорацияВес.Картинка = БиблиотекаКартинок.Остановить;
	КонецЕсли;
	
	Если ДанныеВесОбъем = Неопределено
		Или ДанныеВесОбъем.ВместимостьВЕдПользователя = 0 Тогда
		Форма.НадписьНедогрузОбъем = "";
		Элементы.ДекорацияОбъем.Картинка = Новый Картинка;
	ИначеЕсли НедогрузОбъем >= 0 Тогда
		Текст = СтрЗаменить(Шаблон, "%Количество%", НедогрузОбъем); 
		Текст = СтрЗаменить(Текст, "%ЕдиницаИзмерения%", Форма.ЕдиницаИзмеренияОбъема);
		Форма.НадписьНедогрузОбъем = Новый ФорматированнаяСтрока(Текст,Новый Шрифт(,,Истина),Форма.ЦветЗеленый);
		ЗаполненностьОбъем = ДанныеВесОбъем.Объем / ДанныеВесОбъем.ВместимостьВЕдПользователя * 100;
		Если ЗаполненностьОбъем > 95 Тогда
			Элементы.ДекорацияОбъем.Картинка = БиблиотекаКартинок.Состояние100Процентов;
		ИначеЕсли ЗаполненностьОбъем > 45 Тогда
			Элементы.ДекорацияОбъем.Картинка = БиблиотекаКартинок.Состояние66Процентов;
		ИначеЕсли ЗаполненностьОбъем > 5 Тогда
			Элементы.ДекорацияОбъем.Картинка = БиблиотекаКартинок.Состояние33Процента;
		Иначе
			Элементы.ДекорацияОбъем.Картинка = БиблиотекаКартинок.Состояние0Процентов;
		КонецЕсли;
	Иначе
		Текст = СтрЗаменить(Шаблон, "%Количество%", -НедогрузОбъем); 
		Текст = СтрЗаменить(Текст, "%ЕдиницаИзмерения%", Форма.ЕдиницаИзмеренияОбъема);
		Форма.НадписьНедогрузОбъем = Новый ФорматированнаяСтрока(Текст,Новый Шрифт(,,Истина),Форма.ЦветКрасный);
		Элементы.ДекорацияОбъем.Картинка = БиблиотекаКартинок.Остановить;
	КонецЕсли;
	
КонецПроцедуры

// Вычисляет, требуется ли доставка для переданного способа.
//
// Параметры:
//  СпособДоставки	- ПеречислениеСсылка.СпособыДоставки - проверяемый способ доставки.
//	ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками - Булево - значение функциональной опции ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками
// Возвращаемое значение:
//  Булево - требуется доставка или нет.
//
Функция ДоставкаИспользуется(Знач СпособДоставки, Знач ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками = Ложь) Экспорт
	
	СпособыДоставки = ИспользуемыеСпособыДоставки(ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками);
	
	Возврат СпособыДоставки.Найти(СпособДоставки) <> Неопределено;
	
КонецФункции

// Способы доставки, которые могут быть использованы
// 
// Параметры:
//  ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками - Булево - значение функциональной опции ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками.
// 
// Возвращаемое значение:
//   - Массив - 
//
Функция ИспользуемыеСпособыДоставки(Знач ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками = Ложь) Экспорт
	
	СпособыДоставки = Новый Массив;
	
	Если ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками Тогда
		СпособыДоставки.Добавить(ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчикаДоНашегоСклада"));
	КонецЕсли;
	
	СпособыДоставки.Добавить(ПредопределенноеЗначение("Перечисление.СпособыДоставки.ДоКлиента"));
	СпособыДоставки.Добавить(ПредопределенноеЗначение("Перечисление.СпособыДоставки.КПолучателюОпределяетСлужбаДоставки"));
	СпособыДоставки.Добавить(ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчика"));
	СпособыДоставки.Добавить(ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчикаПоАдресу"));
	СпособыДоставки.Добавить(ПредопределенноеЗначение("Перечисление.СпособыДоставки.НашимиСиламиСАдресаОтправителя"));
	СпособыДоставки.Добавить(ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчикаДоПунктаПередачи"));
	СпособыДоставки.Добавить(ПредопределенноеЗначение("Перечисление.СпособыДоставки.ОтОтправителяОпределяетСлужбаДоставки"));
	СпособыДоставки.Добавить(ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчикаДоПунктаПередачи"));
	
	Возврат СпособыДоставки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет список выбора у поля ввода времени доставки.
//
// Параметры:
//	ПолеВводаФормы - ПолеФормы - поле ввода времени доставки
//	Интервал - Число - интервал времени (сек.) между значениями списка выбора (по умолчанию 1 час).
//
Процедура ЗаполнитьСписокВыбораПоляВремени(ПолеВводаФормы, Интервал = 3600) Экспорт
	
	ПолеВводаФормы.СписокВыбора.Очистить();
	
	НачалоРабочегоДня      = '00010101000000';
	ОкончаниеРабочегоДня   = '00010101235959';
	
	ВремяСписка = НачалоРабочегоДня;
	
	Пока ВремяСписка <= ОкончаниеРабочегоДня Цикл
		
		Если НЕ ЗначениеЗаполнено(ВремяСписка) Тогда
			ПолеВводаФормы.СписокВыбора.Добавить(ВремяСписка + 1, "00:00"); // непустое значение
		Иначе
			ПолеВводаФормы.СписокВыбора.Добавить(ВремяСписка, Формат(ВремяСписка,"ДФ=ЧЧ:мм"));
		КонецЕсли;
		
		ВремяСписка = ВремяСписка + Интервал;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ОписаниеРаспоряженияНаДоставку()
	
	Описание = Новый Структура;
	Описание.Вставить("Имя");
	Описание.Вставить("ЭтоЗаказ",          Ложь);
	Описание.Вставить("ИмяТЧ",             "Товары");
	Описание.Вставить("ИмяПоляСклад",      "Шапка.Склад");
	Описание.Вставить("ИмяПоляПолучательОтправитель", "Партнер");
	Описание.Вставить("ИмяПоляНазначение", "ТЧ.Назначение");
	Описание.Вставить("ИмяПоляСерия",      "ТЧ.Серия");
	Возврат Описание;
	
КонецФункции

Функция ЭтоРаспоряжениеНаДоставкуНаНашСклад(Распоряжение) Экспорт
	Если ТипЗнч(Распоряжение) = Тип("ДокументСсылка.ЗаказПоставщику")
		Или ТипЗнч(Распоряжение) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг")
		Или ТипЗнч(Распоряжение) = Тип("ДокументСсылка.ПриемкаТоваровНаХранение")
		Или Распоряжение = "Документ.ПриемкаТоваровНаХранение"
		Или ТипЗнч(Распоряжение) = Тип("СправочникСсылка.СоглашенияСПоставщиками")
		Или ТипЗнч(Распоряжение) = Тип("СправочникСсылка.ДоговорыКонтрагентов")
		Или Распоряжение = "Документ.ЗаказПоставщику"
		Или Распоряжение = "Документ.ПриобретениеТоваровУслуг"
		Или Распоряжение = "Справочник.СоглашенияСПоставщиками"
		Или Распоряжение = "Справочник.ДоговорыКонтрагентов"
		Или (ТипЗнч(Распоряжение) = Тип("ДанныеФормыСтруктура")
			Или ТипЗнч(Распоряжение) = Тип("Структура"))
			И (ТипЗнч(Распоряжение.Ссылка) = Тип("ДокументСсылка.ЗаказПоставщику")
				Или ТипЗнч(Распоряжение.Ссылка) = Тип("ДокументСсылка.ПриемкаТоваровНаХранение")
				Или ТипЗнч(Распоряжение.Ссылка) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг")
				Или ТипЗнч(Распоряжение.Ссылка) = Тип("СправочникСсылка.СоглашенияСПоставщиками")
				Или ТипЗнч(Распоряжение.Ссылка) = Тип("СправочникСсылка.ДоговорыКонтрагентов")) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

Функция ЭтоПоручениеЭкспедитору(Распоряжение) Экспорт
	
	Если ТипЗнч(Распоряжение) = Тип("ДокументСсылка.ПоручениеЭкспедитору")
		Или Распоряжение = "Документ.ПоручениеЭкспедитору"
		Или (ТипЗнч(Распоряжение) = Тип("ДанныеФормыСтруктура")
				Или ТипЗнч(Распоряжение) = Тип("Структура"))
			И (ТипЗнч(Распоряжение.Ссылка) = Тип("ДокументСсылка.ПоручениеЭкспедитору")) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

Функция ДопИнфоЕстьВСпискеВыбораЭлемента(Элемент, ДопИнфо)
	
	Возврат ДоставкаТоваровКлиентСервер.НайтиВСпискеСтруктур(Элемент.СписокВыбора,
			"ДополнительнаяИнформацияПоДоставке",ДопИнфо) <> Неопределено;
	
КонецФункции

#КонецОбласти
