#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьОперациюМСФОПоСторнируемомуДокументу(СторнируемыйДокументСсылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ОперацияМСФО.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ОперацияМСФО КАК ОперацияМСФО
	|ГДЕ
	|	ОперацияМСФО.СторнируемыйДокумент = &СторнируемыйДокумент
	|	И НЕ ОперацияМСФО.ПометкаУдаления";

	Запрос.УстановитьПараметр("СторнируемыйДокумент", СторнируемыйДокументСсылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Документы.ОперацияМСФО.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

/////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Формирует печатную форму 
// платежного поручения
//
// Параметры:
//  ТабДок - табличный документ
//
Функция ПечатьБухгалтерскаяСправка(МассивОбъектов, ОбъектыПечати) Экспорт
	
	//ТабДокумент = Новый ТабличныйДокумент;
	//ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОперацияБух_БухгалтерскаяСправка";
	//// Зададим параметры макета по умолчанию.
	//ТабДокумент.ПолеСверху              = 10;
	//ТабДокумент.ПолеСлева               = 0;
	//ТабДокумент.ПолеСнизу               = 0;
	//ТабДокумент.ПолеСправа              = 0;
	//ТабДокумент.РазмерКолонтитулаСверху = 10;
	//ТабДокумент.ОриентацияСтраницы      = ОриентацияСтраницы.Ландшафт;
	//
	//Запрос = Новый Запрос();
	//Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	//Запрос.Текст = "ВЫБРАТЬ
	//|	ХозрасчетныйДвиженияССубконто.НомерСтроки КАК НомерСтроки,
	//|	ХозрасчетныйДвиженияССубконто.СчетДт,
	//|	ХозрасчетныйДвиженияССубконто.ПодразделениеДт,
	//|	ХозрасчетныйДвиженияССубконто.СубконтоДт1,
	//|	ХозрасчетныйДвиженияССубконто.СубконтоДт2,
	//|	ХозрасчетныйДвиженияССубконто.СубконтоДт3,
	//|	ХозрасчетныйДвиженияССубконто.СчетКт,
	//|	ХозрасчетныйДвиженияССубконто.ПодразделениеКт,
	//|	ХозрасчетныйДвиженияССубконто.СубконтоКт1,
	//|	ХозрасчетныйДвиженияССубконто.СубконтоКт2,
	//|	ХозрасчетныйДвиженияССубконто.СубконтоКт3,
	//|	ХозрасчетныйДвиженияССубконто.Организация,
	//|	ХозрасчетныйДвиженияССубконто.ВалютаДт,
	//|	ХозрасчетныйДвиженияССубконто.ВалютаКт,
	//|	ХозрасчетныйДвиженияССубконто.Сумма,
	//|	ХозрасчетныйДвиженияССубконто.ВалютнаяСуммаДт,
	//|	ХозрасчетныйДвиженияССубконто.ВалютнаяСуммаКт,
	//|	ХозрасчетныйДвиженияССубконто.КоличествоДт,
	//|	ХозрасчетныйДвиженияССубконто.КоличествоКт,
	//|	ХозрасчетныйДвиженияССубконто.Содержание,
	//|	ХозрасчетныйДвиженияССубконто.Регистратор
	//|ПОМЕСТИТЬ ВТХозрасчетный
	//|ИЗ
	//|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(, , Регистратор В (&МассивОбъектов), , ) КАК ХозрасчетныйДвиженияССубконто
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	ОперацияБух.Ссылка КАК Ссылка,
	//|	ОперацияБух.Номер,
	//|	ОперацияБух.Ответственный,
	//|	ОперацияБух.Дата,
	//|	ВТХозрасчетный.НомерСтроки КАК НомерСтроки,
	//|	ВТХозрасчетный.СчетДт,
	//|	ВТХозрасчетный.ПодразделениеДт,
	//|	ВТХозрасчетный.СубконтоДт1,
	//|	ВТХозрасчетный.СубконтоДт2,
	//|	ВТХозрасчетный.СубконтоДт3,
	//|	ВТХозрасчетный.СчетКт,
	//|	ВТХозрасчетный.ПодразделениеКт,
	//|	ВТХозрасчетный.СубконтоКт1,
	//|	ВТХозрасчетный.СубконтоКт2,
	//|	ВТХозрасчетный.СубконтоКт3,
	//|	ВТХозрасчетный.Организация КАК Организация,
	//|	ВТХозрасчетный.ВалютаДт,
	//|	ВТХозрасчетный.ВалютаКт,
	//|	ВТХозрасчетный.Сумма,
	//|	ВТХозрасчетный.ВалютнаяСуммаДт,
	//|	ВТХозрасчетный.ВалютнаяСуммаКт,
	//|	ВТХозрасчетный.КоличествоДт,
	//|	ВТХозрасчетный.КоличествоКт,
	//|	ВТХозрасчетный.Содержание КАК Содержание
	//|ИЗ
	//|	Документ.ОперацияБух КАК ОперацияБух
	//|		ЛЕВОЕ СОЕДИНЕНИЕ ВТХозрасчетный КАК ВТХозрасчетный
	//|		ПО ОперацияБух.Ссылка = ВТХозрасчетный.Регистратор
	//|ГДЕ
	//|	ОперацияБух.Ссылка В(&МассивОбъектов)
	//|
	//|УПОРЯДОЧИТЬ ПО
	//|	ОперацияБух.Дата,
	//|	ОперацияБух.Ссылка,
	//|	НомерСтроки";
	//
	//ВыборкаДвижений = Запрос.Выполнить().Выбрать();
	//
	//ПервыйДокумент = Истина;
	//
	//Пока ВыборкаДвижений.СледующийПоЗначениюПоля("Ссылка") Цикл
	//	
	//	ЕстьОшибки = Ложь;	

	//	Если Не ПервыйДокумент Тогда
	//		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	//	КонецЕсли;
	//	ПервыйДокумент = Ложь;
	//	// Запомним номер строки, с которой начали выводить текущий документ.
	//	НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
	//	
	//	  //Макет = УправлениеПечатью.ПолучитьМакет("Документ.ОперацияБух.БухгалтерскаяСправка");
	//	// Получаем области макета для вывода в табличный документ.
	//	//ШапкаДокумента   = Макет.ПолучитьОбласть("Шапка");
	//	//ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	//	//СтрокаТаблицы    = Макет.ПолучитьОбласть("СтрокаТаблицы");
	//	//ПодвалТаблицы    = Макет.ПолучитьОбласть("ПодвалТаблицы");
	//	//ПодвалДокумента  = Макет.ПолучитьОбласть("Подвал");
	//			
	//	//// Выведем шапку документа.
	//	//СведенияОбОрганизации = БухгалтерскийУчетВызовСервераПереопределяемый.СведенияОЮрФизЛице(ВыборкаДвижений.Организация, ВыборкаДвижений.Дата);
	//	
	//	//ШапкаДокумента.Параметры.Организация    = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации);
	//	//ШапкаДокумента.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаДвижений.Номер, Истина, Истина);
	//	ШапкаДокумента.Параметры.ДатаДокумента  = Формат(ВыборкаДвижений.Дата, "ДЛФ=D");
	//	ШапкаДокумента.Параметры.Содержание     = ВыборкаДвижений.Содержание;
	//	
	//	ТабДокумент.Вывести(ШапкаДокумента);
	//	
	//	// Выведем заголовок таблицы.
	//	ТабДокумент.Вывести(ЗаголовокТаблицы);
	//	
	//	// Выведем строки документа.
	//	Пока ВыборкаДвижений.Следующий() Цикл
	//		
	//		СтрокаТаблицы.Параметры.Заполнить(ВыборкаДвижений);
	//		
	//		АналитикаДт = Строка(ВыборкаДвижений.СубконтоДт1) + Символы.ПС
	//					+ Строка(ВыборкаДвижений.СубконтоДт2) + Символы.ПС
	//					+ Строка(ВыборкаДвижений.СубконтоДт3);
	//					
	//		АналитикаКт = Строка(ВыборкаДвижений.СубконтоКт1) + Символы.ПС
	//					+ Строка(ВыборкаДвижений.СубконтоКт2) + Символы.ПС
	//					+ Строка(ВыборкаДвижений.СубконтоКт3);
	//					
	//		СтрокаТаблицы.Параметры.АналитикаДт = АналитикаДт;
	//		СтрокаТаблицы.Параметры.АналитикаКт = АналитикаКт;
	//									 
	//		// Проверим, помещается ли строка с подвалом.
	//		СтрокаСПодвалом = Новый Массив;
	//		СтрокаСПодвалом.Добавить(СтрокаТаблицы);
	//		СтрокаСПодвалом.Добавить(ПодвалТаблицы);
	//		СтрокаСПодвалом.Добавить(ПодвалДокумента);
	//		
	//		//Если НЕ ОбщегоНазначенияБПВызовСервера.ПроверитьВыводТабличногоДокумента(ТабДокумент, СтрокаСПодвалом) Тогда
	//		//	
	//		//	// Выведем подвал таблицы.
	//		//	ТабДокумент.Вывести(ПодвалТаблицы);
	//		//		
	//		//	// Выведем разрыв страницы.
	//		//	ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();

	//		//	// Выведем заголовок таблицы.
	//		//	ТабДокумент.Вывести(ЗаголовокТаблицы);
	//		//	
	//		//КонецЕсли;
	//		
	//		ТабДокумент.Вывести(СтрокаТаблицы);
	//		
	//	КонецЦикла;
	//	
	//	// Выведем подвал таблицы.
	//	ТабДокумент.Вывести(ПодвалТаблицы);
	//	
	//	// Выведем подвал документа.
	//	
	//	ТабДокумент.Вывести(ПодвалДокумента);
	//	
	//	
	//	// В табличном документе зададим имя области, в которую был 
	//	// выведен объект. Нужно для возможности печати покомплектно.
	//	//УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
	//	//	НомерСтрокиНачало, ОбъектыПечати, ВыборкаДвижений.Ссылка);

	//КонецЦикла;

	//Возврат ТабДокумент;

КонецФункции // ПечатьПлатежногоПоручения()

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм,
					ОбъектыПечати, ПараметрыВывода) Экспорт
	
	//// Устанавливаем признак доступности печати покомплектно.
	//ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	//
	//// Проверяем, нужно ли для макета ПлатежноеПоручение формировать табличный документ.
	//Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "БухгалтерскаяСправка") Тогда

	//	// Формируем табличный документ и добавляем его в коллекцию печатных форм.
	//	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
	//		"БухгалтерскаяСправка", "Бухгалтерская справка", ПечатьБухгалтерскаяСправка(МассивОбъектов, ОбъектыПечати));
	//													 
	//КонецЕсли;
		
КонецПроцедуры
	
#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли