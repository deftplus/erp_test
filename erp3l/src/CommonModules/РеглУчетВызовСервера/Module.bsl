
#Область СлужебныйПрограммныйИнтерфейс

// Проверяет переданные документы на факт отражения в регл. учете при наличии прав на формирование проводок.
//
// Параметры:
//    МассивДокументов - Массив - Документы.
//
// Возвращаемое значение:
//    Массив - Документы, которые не отражены в регл. учете.
//
Функция ПроверитьПраваДоступаОтражениеДокументовВРеглУчете(МассивДокументов) Экспорт
	
	Возврат РеглУчетПроведениеСервер.ПроверитьПраваДоступаОтражениеДокументовВРеглУчете(МассивДокументов);
	
КонецФункции

// Проверяет переданные документы на факт отражения в регл. учете при наличии прав на формирование проводок.
//
// Параметры:
//    МассивДокументов - Массив - Документы.
//
// Возвращаемое значение:
//    Массив - Документы, которые не отражены в регл. учете.
//
Функция ПроверитьПраваДоступаОтражениеДокументовВРеглУчетеРасширенный(МассивДокументов) Экспорт
	
	СоответствиеТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивДокументов);
	
	Для каждого КлючИЗначение Из СоответствиеТипов Цикл
		Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(КлючИЗначение.Ключ);
		ДополнительныеДокументы = Менеджер.ДополнительныеДокументыПечати(КлючИЗначение.Значение);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивДокументов, ДополнительныеДокументы);
	КонецЦикла;
	
	Возврат РеглУчетПроведениеСервер.ПроверитьПраваДоступаОтражениеДокументовВРеглУчете(МассивДокументов);
	
КонецФункции

// Выполняет попытку отражения документов в регл. учете
//
// Параметры:
//	Документы - Массив - документы, которые необходимо отразить в регл. учете
//	ВыполнитьПересчеты - Булево - Признак, что перед отражением документа необходимо выполнить отражение в учете НДС и распределение взаиморасчетов.
//
// Возвращаемое значение:
//	Массив - Не отраженные в регл. учете документы.
//
Функция ОтразитьДокументыВРеглУчете(МассивДокументов, ВыполнитьПересчеты = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат РеглУчетПроведениеСервер.ОтразитьДокументыВРеглУчете(МассивДокументов, ВыполнитьПересчеты);
	
КонецФункции

Процедура ОбработкаПолученияДанныхВыбораПланСчетовХозрасчетный(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	Параметры.Отбор.Вставить("Ссылка", ПланыСчетов.Хозрасчетный.СчетаДляВыбора(Параметры));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Вызывается из модуля РеглУчетКлиент для отчета "СверкаДанныхБУиОУ".
//
Функция ПараметрыРасшифровки(АналитикаСтроки) Экспорт
	
	ПоляОтбора = Новый Соответствие;
	ПоляОтбора.Вставить(Новый ПолеКомпоновкиДанных("СчетБУ")		, АналитикаСтроки.СчетБУ);
	ПоляОтбора.Вставить(Новый ПолеКомпоновкиДанных("Подразделение")	, АналитикаСтроки.Подразделение);
	ПоляОтбора.Вставить(Новый ПолеКомпоновкиДанных("Аналитика1")	, АналитикаСтроки.Субконто1);
	ПоляОтбора.Вставить(Новый ПолеКомпоновкиДанных("Аналитика2")	, АналитикаСтроки.Субконто2);
	
	ПоляОтбораОтклонений = Новый Соответствие;
	ПоляОтбораОтклонений.Вставить(Новый ПолеКомпоновкиДанных("НачОткл")		, Истина);
	ПоляОтбораОтклонений.Вставить(Новый ПолеКомпоновкиДанных("КонОткл")		, Ложь);
	ПоляОтбораОтклонений.Вставить(Новый ПолеКомпоновкиДанных("ПриходОткл")	, Ложь);
	ПоляОтбораОтклонений.Вставить(Новый ПолеКомпоновкиДанных("РасходОткл")	, Истина);
	
	ПараметрыДанных = Новый Соответствие;
	ПараметрыДанных.Вставить(Новый ПараметрКомпоновкиДанных("ПериодОтчета")				, АналитикаСтроки.ПериодОтчета);
	ПараметрыДанных.Вставить(Новый ПараметрКомпоновкиДанных("ПредставлениеСчетовПоКоду"), Истина);
	ПараметрыДанных.Вставить(Новый ПараметрКомпоновкиДанных("Организация")				, АналитикаСтроки.Организация);
	ПараметрыДанных.Вставить(Новый ПараметрКомпоновкиДанных("РазделУчета")				, АналитикаСтроки.РазделУчета);

	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	
	ВариантНастройки = Отчеты.СверкаДанныхОУиБУ.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных").ВариантыНастроек.СверкаПоРегистраторам;
	
	Для каждого ЭлементОтбора Из ВариантНастройки.Настройки.Отбор.Элементы Цикл
		
		ГруппаОтбораОтклонений = Неопределено;
		Для каждого ПолеОтбора Из ПоляОтбора Цикл
			Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
				НовыйЭлемент = ПользовательскиеНастройки.Элементы.Добавить(ТипЗнч(ЭлементОтбора));
				ЗаполнитьЗначенияСвойств(НовыйЭлемент, ЭлементОтбора, "ИдентификаторПользовательскойНастройки,РежимОтображения");
				НовыйЭлемент.Использование = АналитикаСтроки.ПоказатьТолькоОтклонения;
				ГруппаОтбораОтклонений = НовыйЭлемент;
			КонецЕсли;
		КонецЦикла;
		
		Для каждого ПолеОтбора Из ПоляОтбораОтклонений Цикл
			Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") 
					И ЭлементОтбора.ЛевоеЗначение = ПолеОтбора.Ключ Тогда
				ДобавитьЭлементКомпоновкиДанных(ПользовательскиеНастройки, ЭлементОтбора, ПолеОтбора.Значение, , ГруппаОтбораОтклонений.Использование, ГруппаОтбораОтклонений);
			КонецЕсли;
		КонецЦикла;
		
		Для каждого ПолеОтбора Из ПоляОтбора Цикл
			Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") 
					И ЭлементОтбора.ЛевоеЗначение = ПолеОтбора.Ключ Тогда
				ДобавитьЭлементКомпоновкиДанных(ПользовательскиеНастройки, ЭлементОтбора, ПолеОтбора.Значение);
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	Для каждого ЭлементПараметрДанных Из ВариантНастройки.Настройки.ПараметрыДанных.Элементы Цикл
		Для каждого ПараметрДанных Из ПараметрыДанных Цикл
			Если ЭлементПараметрДанных.Параметр = ПараметрДанных.Ключ Тогда
				ДобавитьЭлементКомпоновкиДанных(ПользовательскиеНастройки, ЭлементПараметрДанных, ПараметрДанных.Значение, "Значение");
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ПользовательскиеНастройки;
	
КонецФункции

// Вызывается из модуля РеглУчетКлиент для отчета "СверкаДанныхБУиОУ".
//
Функция ПолучитьПараметрыРасшифровки(Адрес, ИндексТекущегоЭлемента) Экспорт
	
	ПараметрыРасшифровки = Новый Структура;
	ПоляРасшифровки = Новый Массив;
	
	ДанныеРасшифровкиОтчета = ПолучитьИзВременногоХранилища(Адрес);
	Если ДанныеРасшифровкиОтчета <> Неопределено Тогда 
	
		ПоляЭлементаРасшифровки = ДанныеРасшифровкиОтчета.Элементы[ИндексТекущегоЭлемента].ПолучитьПоля();

		Для каждого ПолеРасшифровки Из ПоляЭлементаРасшифровки Цикл
			ПоляРасшифровки.Добавить(ПолеРасшифровки.Поле);
		КонецЦикла;
		
	КонецЕсли;
	
	ПараметрыРасшифровки.Вставить("ПоляРасшифровки", ПоляРасшифровки);
	ПараметрыРасшифровки.Вставить("АналитикаСтроки", ПолучитьАналитикуСтрокиСверки(ДанныеРасшифровкиОтчета, ИндексТекущегоЭлемента));
	
	Возврат ПараметрыРасшифровки;
	
КонецФункции

// Вызывается из модуля РеглУчетКлиент для отчета "АнализРасходовПриУСН".
// 
// Параметры:
//	Расшифровка - Расшифровка - Расшифровка отчета
//	АдресДанныхРасшифровки - Строка - Адрес временного хранилища данных расшифровки
//	КомпоновщикНастроек - КомпоновщикНастроек - Компоновщик настроек отчета.
//
// Возвращаемое значение:
//	ПараметрыРасшифровки - Структура - Параметры расшифровки. 
//									   Если особая расшифровка не требуется, то возвращает Неопределено.
//
Функция ПараметрыРасшифровкиАнализаРасходовПриУСН(Расшифровка, АдресДанныхРасшифровки, КомпоновщикНастроек, КлючТекущегоВарианта) Экспорт
	
	Если КлючТекущегоВарианта = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыРасшифровки = Неопределено;
	
	ИмяВариантаРасшифровки = КлючТекущегоВарианта + "Расшифровка"; 
	
	ДанныеРасшифровки = ПолучитьИзВременногоХранилища(АдресДанныхРасшифровки);
	
	ПоляГруппировки = Новый Структура;
	ОтчетыУТВызовСервераПереопределяемый.ПолучитьЗначенияПолей(ПоляГруппировки, ДанныеРасшифровки.Элементы, Расшифровка);
	
	Если НЕ ПоляГруппировки.Свойство("ДокументВозникновенияРасходов") И НЕ ПоляГруппировки.Свойство("Партия") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДоступныеПоляОтбора = Новый Структура;
	ДоступныеПоляОтбора.Вставить("ДокументВозникновенияРасходов");
	ДоступныеПоляОтбора.Вставить("СтатьяРасходов");
	ДоступныеПоляОтбора.Вставить("ВидРасходов");
	ДоступныеПоляОтбора.Вставить("ЭлементРасходов");	
	ДоступныеПоляОтбора.Вставить("Партия");
	
	КомпоновщикНастроекРасшифровки = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(КомпоновщикНастроекРасшифровки.ФиксированныеНастройки.Отбор, ДанныеРасшифровки.Настройки.Отбор, Ложь);
	ЗаполнитьЗначенияСвойств(ДоступныеПоляОтбора, ПоляГруппировки);
	
	Для каждого Поле Из ДоступныеПоляОтбора Цикл
		Если Поле.Значение <> Неопределено Тогда
			КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(КомпоновщикНастроекРасшифровки.ФиксированныеНастройки.Отбор, Поле.Ключ, Поле.Значение); 
		КонецЕсли;
	КонецЦикла;
	
	Период = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек.ПользовательскиеНастройки, "Период").Значение; 
	
	ПериодНачалаРасшифровкиПоРегистратору = КомпоновщикНастроекРасшифровки.ФиксированныеНастройки.ПараметрыДанных.Элементы.Добавить();
	ПериодНачалаРасшифровкиПоРегистратору.Параметр = Новый ПараметрКомпоновкиДанных("ПериодНачалаРасшифровкиПоРегистратору");
	ПериодНачалаРасшифровкиПоРегистратору.Значение = Период.ДатаНачала;
	ПериодНачалаРасшифровкиПоРегистратору.Использование = Истина;
	
	ПериодРасшифровки = КомпоновщикНастроекРасшифровки.ФиксированныеНастройки.ПараметрыДанных.Элементы.Добавить();
	ПериодРасшифровки.Параметр = Новый ПараметрКомпоновкиДанных("Период");
	ПериодРасшифровки.Значение = Новый СтандартныйПериод(Дата('00010101'), Период.ДатаОкончания);;
	ПериодРасшифровки.Использование = Истина;
	
	ПараметрыРасшифровки = Новый Структура;
	ПараметрыРасшифровки.Вставить("КлючВарианта", ИмяВариантаРасшифровки);
	ПараметрыРасшифровки.Вставить("КлючПользовательскихНастроек", ИмяВариантаРасшифровки);
	ПараметрыРасшифровки.Вставить("ФиксированныеНастройки", КомпоновщикНастроекРасшифровки.ФиксированныеНастройки);
	ПараметрыРасшифровки.Вставить("СформироватьПриОткрытии", Истина);
	
	Возврат ПараметрыРасшифровки;
	
КонецФункции

Функция ПолучитьАналитикуСтрокиСверки(ДанныеРасшифровки, ИндексТекущегоЭлемента)
	
	АналитикаСтрокиСверки = Новый Структура("НачалоПериода, КонецПериода,
				| РазделУчета, СчетБУ, Организация, Подразделение, Субконто1, Субконто2, Субконто3");
	
	АналитикаСтрокиСверки.РазделУчета   = ПолучитьЗначениеПоляРасшифровки(
	                                         ДанныеРасшифровки, "РазделУчета", ИндексТекущегоЭлемента);
	АналитикаСтрокиСверки.СчетБУ        = ПолучитьЗначениеПоляРасшифровки(
	                                         ДанныеРасшифровки, "СчетБУ", ИндексТекущегоЭлемента);
	АналитикаСтрокиСверки.Организация   = ПолучитьЗначениеПоляРасшифровки(
	                                         ДанныеРасшифровки, "Организация", ИндексТекущегоЭлемента);
	АналитикаСтрокиСверки.Подразделение = ПолучитьЗначениеПоляРасшифровки(
	                                         ДанныеРасшифровки, "Подразделение", ИндексТекущегоЭлемента);
	АналитикаСтрокиСверки.Субконто1     = ПолучитьЗначениеПоляРасшифровки(
	                                         ДанныеРасшифровки, "Аналитика1", ИндексТекущегоЭлемента, "Организация");
	АналитикаСтрокиСверки.Субконто2     = ПолучитьЗначениеПоляРасшифровки(
	                                         ДанныеРасшифровки, "Аналитика2", ИндексТекущегоЭлемента, "Организация");
	
	Возврат АналитикаСтрокиСверки;
	
КонецФункции

Процедура ДобавитьЭлементКомпоновкиДанных(ПользовательскиеНастройки, Элемент, Значение, Назначение = "ПравоеЗначение", Использование = Истина, Родитель = Неопределено)
	
	Если ЗначениеЗаполнено(Значение) Тогда
		НовыйЭлемент = ПользовательскиеНастройки.Элементы.Добавить(ТипЗнч(Элемент));
		Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			ЗаполнитьЗначенияСвойств(НовыйЭлемент, Элемент, "ИдентификаторПользовательскойНастройки,РежимОтображения");
		Иначе
			ЗаполнитьЗначенияСвойств(НовыйЭлемент, Элемент, "ВидСравнения,ИдентификаторПользовательскойНастройки,РежимОтображения");
		КонецЕсли;
		НовыйЭлемент[Назначение] = Значение;
		НовыйЭлемент.Использование = Использование;
		Если Родитель <> Неопределено Тогда 
			НовыйЭлемент.Родитель = Родитель;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьЗначениеПоляРасшифровки(ДанныеРасшифровки, ИмяПоля, Знач НачальныйИндекс, ПоследняяКолонка = "") Экспорт
	
	Индекс = Число(НачальныйИндекс);
	Результат = Неопределено;
	Пока Индекс >= 0 Цикл
		
		ЭлементРасшифровки = ДанныеРасшифровки.Элементы[Индекс];
		Если ТипЗнч(ЭлементРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
			Поля = ЭлементРасшифровки.ПолучитьПоля();
			ЗначениеПоля = Поля.Найти(ИмяПоля);
			Если ЗначениеПоля <> Неопределено Тогда
				Результат = ЗначениеПоля.Значение;
				Прервать;
			КонецЕсли;
			
			// конец строки
			Если НЕ ПустаяСтрока(ПоследняяКолонка) Тогда
				ЗначениеПоля = Поля.Найти(ПоследняяКолонка);
				Если ЗначениеПоля <> Неопределено Тогда
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Индекс = Индекс - 1;
		
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

#КонецОбласти

