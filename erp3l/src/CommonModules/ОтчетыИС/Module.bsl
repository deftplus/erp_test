#Область ПрограммныйИнтерфейс

//Инициализирует СКД переопределяемым текстом запроса
//
//Параметры:
//   Источник - ОтчетОбъект - инициализируемый отчет.
//   Форма - УправляемаяФорма, Неопределено - форма отчета.
Процедура ИнициализироватьСхемуКомпоновки(Источник, Форма = Неопределено) Экспорт
	
	ТекстЗапроса = Источник.СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос;
	
	ТекстПоиска = Источник.ПереопределяемаяЧасть();
	ТекстЗамены = Неопределено;
	ОтчетыИСПереопределяемый.ПриПереопределенииТекстаЗапроса(ТекстЗамены, Источник);
	
	Если Не(ТекстЗамены = Неопределено) Тогда
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ТекстПоиска, ТекстЗамены);
		Источник.СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос = ТекстЗапроса;
		
		Если Не(Форма = Неопределено) Тогда
			Форма.НастройкиОтчета.СхемаМодифицирована = Истина;
			Форма.НастройкиОтчета.АдресСхемы = ПоместитьВоВременноеХранилище(Источник.СхемаКомпоновкиДанных, Форма.УникальныйИдентификатор);
			Форма.Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Источник.СхемаКомпоновкиДанных));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

//Переопределяемая область данных прикладных документов отчетов о расхождениях при оформлении
//
//Возвращаемое значение:
//   Строка - типовая часть запроса, которую требуется переопределять
//
Функция ШаблонПолученияДанныхПрикладныхДокументов() Экспорт
	
	Возврат
	"ВЫБРАТЬ
	|	""Переопределяемый"" КАК Ссылка,
	|	&ПустаяНоменклатура КАК Номенклатура,
	|	&ПустаяХарактеристика КАК Характеристика,
	|	&ПустаяСерия КАК Серия,
	|	0 КАК Количество
	|ПОМЕСТИТЬ ТоварыНакладной
	|;
	|
	|";
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает значение параметра компоновки данных
//
// Параметры:
//	ОбъектНастройки - НастройкиКомпоновкиДанных, ПользовательскиеНастройкиКомпоновкиДанных, КомпоновщикНастроекКомпоновкиДанных, 
//		НастройкиВложенногоОбъектаКомпоновкиДанных, ДанныеРасшифровкиКомпоновкиДанных, КоллекцияЗначенийПараметровКомпоновкиДанных,
//		ОформлениеКомпоновкиДанных - Объект настройки.
//	Параметр - Строка, ПараметрКомпоновкиДанных - поле или имя поля, для которого нужно вернуть параметр.
//
// Возвращаемое значение:
//	ЗначениеПараметраНастроекКомпоновкиДанных - Неопределено, если параметр не найден.
//
Функция ПолучитьПараметр(ОбъектНастройки, Параметр) Экспорт
	
	ЗначениеПараметра = Неопределено;
	ПолеПараметр = ?(ТипЗнч(Параметр) = Тип("Строка"), Новый ПараметрКомпоновкиДанных(Параметр), Параметр);
	
	Если ТипЗнч(ОбъектНастройки) = Тип("НастройкиКомпоновкиДанных") Тогда
		ЗначениеПараметра = ОбъектНастройки.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
	ИначеЕсли ТипЗнч(ОбъектНастройки) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
		Для Каждого ЭлементНастройки Из ОбъектНастройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И ЭлементНастройки.Параметр = ПолеПараметр Тогда
				ЗначениеПараметра = ЭлементНастройки;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ОбъектНастройки) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Для Каждого ЭлементНастройки Из ОбъектНастройки.ПользовательскиеНастройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И ЭлементНастройки.Параметр = ПолеПараметр Тогда
				ЗначениеПараметра = ЭлементНастройки;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ЗначениеПараметра = Неопределено Тогда
			ЗначениеПараметра = ОбъектНастройки.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
		КонецЕсли;
		Если ЗначениеПараметра = Неопределено Тогда
			ЗначениеПараметра = ОбъектНастройки.ФиксированныеНастройки.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
		КонецЕсли;
	ИначеЕсли ТипЗнч(ОбъектНастройки) = Тип("НастройкиВложенногоОбъектаКомпоновкиДанных") Тогда
		ЗначениеПараметра = ОбъектНастройки.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
	ИначеЕсли ТипЗнч(ОбъектНастройки) = Тип("ДанныеРасшифровкиКомпоновкиДанных") Тогда
		ЗначениеПараметра = ОбъектНастройки.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
	ИначеЕсли ТипЗнч(ОбъектНастройки) = Тип("КоллекцияЗначенийПараметровКомпоновкиДанных") Тогда
		ЗначениеПараметра = ОбъектНастройки.Найти(ПолеПараметр);
	ИначеЕсли ТипЗнч(ОбъектНастройки) = Тип("ОформлениеКомпоновкиДанных") Тогда
		ЗначениеПараметра = ОбъектНастройки.НайтиЗначениеПараметра(ПолеПараметр);
	КонецЕсли;
	
	Возврат ЗначениеПараметра;
	
КонецФункции

// Устанавливает параметр настроек компоновки данных
//
// Параметры:
//	Настройки - НастройкиКомпоновкиДанных, ПользовательскиеНастройкиКомпоновкиДанных,
//		КомпоновщикНастроекКомпоновкиДанных - настройки КД, для которых требуется установить параметры
//	Параметр - Строка, ПараметрКомпоновкиДанных - параметр, который требуется установить
//	Значение - Произвольный - значение, которое требуется установить
//	Использование - Булево - признак использования параметра КД.
//
// Возвращаемое значение:
//	ЗначениеПараметраНастроекКомпоновкиДанных - установленный параметр настроек КД. Неопределено, если параметр на найден.
//
Функция УстановитьПараметр(Настройки, Параметр, Значение, Использование = Истина, Недоступный = Ложь) Экспорт
	
	ЗначениеПараметра = ПолучитьПараметр(Настройки, Параметр);
	
	Если ЗначениеПараметра <> Неопределено Тогда
		ЗначениеПараметра.Значение		= Значение;
		ЗначениеПараметра.Использование	= Использование;
		Если Недоступный Тогда
			ЗначениеПараметра.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЗначениеПараметра;
	
КонецФункции

#КонецОбласти