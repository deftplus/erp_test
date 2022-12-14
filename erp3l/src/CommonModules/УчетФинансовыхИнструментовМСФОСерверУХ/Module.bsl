
#Область ФинансовыеРасчеты

Функция ПолучитьПроцентСущественностиФИ() Экспорт 
	
	Возврат 0.1;
	
КонецФункции

#КонецОбласти

#Область ЗаполнениеГрафика

Функция ПолучитьПараметрыРасчета(ПараметрыУчетаФИ) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	т.ПрименятьПоправкуПоСправедливойСтоимости КАК ПрименятьПоправкуПоСправедливойСтоимости,
	|	т.ПризнаниеПроцентовМСФО КАК ПризнаниеПроцентовМСФО,
	|	т.ВидСтавкиРасчетаПроцентов КАК ВидСтавкиРасчетаПроцентов,
	|	т.Задолженность КАК Задолженность,
	|	т.Лизинг КАК Лизинг,
	|	ПРЕДСТАВЛЕНИЕ(т.ВидСтавкиРасчетаПроцентов) КАК ВидСтавкиРасчетаПроцентовПредставление,
	|	т.АктивОбязательство = ЗНАЧЕНИЕ(Перечисление.АктивОбязательствоОбъектовФинансовогоХарактера.Актив) КАК ЭтоАктив,
	|	т.ВозвратПоГрафику КАК ВозвратПоГрафику,
	|	т.ПорядокУчетаДисконта КАК ПорядокУчетаДисконта
	|ИЗ
	|	Справочник.ВидыОбъектовФинансовогоХарактера КАК т
	|ГДЕ
	|	т.Ссылка В
	|			(ВЫБРАТЬ ПЕРВЫЕ 1
	|				т.ВидОбъектаФинансовогоХарактера
	|			ИЗ
	|				Справочник.ПараметрыУчетаФинансовыхИнструментовМСФО КАК т
	|			ГДЕ
	|				т.Ссылка = &Ссылка)");
	
	Запрос.УстановитьПараметр("Ссылка", ПараметрыУчетаФИ);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		
		Результат = Новый Структура;
		Для каждого Колонка Из РезультатЗапроса.Колонки Цикл
			Результат.Вставить(Колонка.Имя, Колонка.ТипЗначения.ПривестиЗначение(Ложь));
		КонецЦикла;
		
		Возврат Результат;
		
	Иначе 
			
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		Возврат ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Выборка);
		
	КонецЕсли;
		
КонецФункции

Функция ПолучитьПараметрыПредыдущегГрафика(ДанныеГрафика) Экспорт

	Документ = ДанныеГрафика.Документ;
	
	ДатаИзмененияГрафика = Макс(ДанныеГрафика.СтрокаФИ.ДатаПризнания, Документ.ПериодОтчета.ДатаНачала);
	
	Запрос = Новый Запрос(ТекстЗапросаПредыдущийГрафик());
	
	Запрос.УстановитьПараметр("ГраницаДоДокумента", 	МСФОВызовСервераУХ.ПолучитьГраницуДоДокумента(Документ.Дата, Документ.Ссылка));
	Запрос.УстановитьПараметр("Ссылка", 				Документ.Ссылка);
	Запрос.УстановитьПараметр("Организация", 			Документ.Организация);
	Запрос.УстановитьПараметр("Сценарий", 				Документ.Сценарий);
	Запрос.УстановитьПараметр("ФИ", 					ДанныеГрафика.СтрокаФИ.ФИ);
	Запрос.УстановитьПараметр("ДатаИзмененияГрафика", 	ДатаИзмененияГрафика);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат Новый Структура;
		
	Иначе 
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Выборка);
		
	КонецЕсли;
	
КонецФункции

Функция ТекстЗапросаПредыдущийГрафик()

	Возврат
	"ВЫБРАТЬ
	|	СведенияОФИСрезПоследних.ФИ КАК ФИ,
	|	СведенияОФИСрезПоследних.Регистратор КАК ВерсияФИ,
	|	СведенияОФИСрезПоследних.ПараметрыУчетаФИ КАК ПараметрыУчетаФИ,
	|	СведенияОФИСрезПоследних.ДатаПризнания КАК ДатаПризнания,
	|	СведенияОФИСрезПоследних.ЧистаяПриведеннаяСтоимость КАК ЧистаяПриведеннаяСтоимость,
	|	СведенияОФИСрезПоследних.ЭффективнаяПроцентнаяСтавка КАК ЭффективнаяПроцентнаяСтавка,
	|	СведенияОФИСрезПоследних.РыночнаяПроцентнаяСтавка КАК РыночнаяПроцентнаяСтавка,
	|	СведенияОФИСрезПоследних.РыночнаяПроцентнаяСтавка КАК ПроцентнаяСтавкаПоДоговоруНСБУ
	|ПОМЕСТИТЬ втВерсииФИ
	|ИЗ
	|	РегистрСведений.СведенияОФИ.СрезПоследних(
	|			&ГраницаДоДокумента,
	|			ФИ В (&ФИ)
	|				И Организация = &Организация
	|				И Сценарий = &Сценарий
	|				И Регистратор <> &Ссылка) КАК СведенияОФИСрезПоследних
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВерсияФИ,
	|	ФИ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГрафикиФИ.Регистратор КАК Регистратор,
	|	ГрафикиФИ.ФИ КАК ФИ,
	|	МАКСИМУМ(ГрафикиФИ.Период) КАК ДатаОперации
	|ПОМЕСТИТЬ втПоследниеОперации
	|ИЗ
	|	РегистрСведений.ГрафикиФИ КАК ГрафикиФИ
	|ГДЕ
	|	(ГрафикиФИ.Регистратор, ГрафикиФИ.ФИ) В
	|			(ВЫБРАТЬ
	|				т.ВерсияФИ,
	|				т.ФИ
	|			ИЗ
	|				втВерсииФИ КАК т)
	|	И ГрафикиФИ.Период < &ДатаИзмененияГрафика
	|
	|СГРУППИРОВАТЬ ПО
	|	ГрафикиФИ.Регистратор,
	|	ГрафикиФИ.ФИ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Регистратор,
	|	ДатаОперации,
	|	ФИ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГрафикиФИ.ОсновнойДолг_Задолженность + ГрафикиФИ.Проценты_Задолженность КАК Задолженность,
	|	ГрафикиФИ.Период КАК ДатаЗадолженности,
	|	втВерсииФИ.ПараметрыУчетаФИ КАК ПараметрыУчетаФИ,
	|	втВерсииФИ.ДатаПризнания КАК ДатаПризнания,
	|	втВерсииФИ.ВерсияФИ КАК ВерсияГрафика,
	|	втВерсииФИ.ЧистаяПриведеннаяСтоимость КАК ЧистаяПриведеннаяСтоимость,
	|	втВерсииФИ.ЭффективнаяПроцентнаяСтавка КАК ЭффективнаяПроцентнаяСтавка,
	|	втВерсииФИ.ПроцентнаяСтавкаПоДоговоруНСБУ КАК ПроцентнаяСтавкаПоДоговоруНСБУ,
	|	втВерсииФИ.РыночнаяПроцентнаяСтавка КАК РыночнаяПроцентнаяСтавка	
	|ИЗ
	|	РегистрСведений.ГрафикиФИ КАК ГрафикиФИ
	|		ЛЕВОЕ СОЕДИНЕНИЕ втВерсииФИ КАК втВерсииФИ
	|		ПО (ИСТИНА)
	|ГДЕ
	|	(ГрафикиФИ.Регистратор, ГрафикиФИ.ФИ, ГрафикиФИ.Период) В
	|			(ВЫБРАТЬ
	|				т.Регистратор,
	|				т.ФИ,
	|				т.ДатаОперации
	|			ИЗ
	|				втПоследниеОперации КАК т)";

КонецФункции

// Функция - Получить денежные потоки
//
// Параметры:
//  ДанныеГрафика	 - Структура	- см. УчетФинансовыхИнструментовМСФОКлиентСерверУХ.ПодготовитьДанныеГрафика
//  Проценты		 - Булево		- включать эти операции
//  ДопРасходУсл	 - Булево	 	- включать эти операции
//  ДопРасходМод	 - Булево	 	- включать эти операции
//  ОсновнойДолг	 - Булево	 	- включать эти операции
//  ВНА				 - Булево	 	- включать эти операции
//  АвансыВкл		 - Булево		- включать эти операции
//  АвансыИскл		 - Булево		- включать эти операции
//  ДатаИскючения	 - Дата 		- операция не включаются в график, если дата операции меньше или равна дате исключения(например исключить пустые даты, или получить часть графика)
// 
// Возвращаемое значение:
//   - ДенежныеПотоки = Новый ТаблицаЗначений;
//		ДенежныеПотоки.Колонки.Добавить("Дата");
//		ДенежныеПотоки.Колонки.Добавить("ДенежныйПоток");
//
Функция ПолучитьДенежныеПотоки(ДанныеГрафика, Проценты = Ложь, ДопРасходУсл = Ложь, ДопРасходМод = Ложь, 
										ОсновнойДолг = Ложь, ВНА = Ложь, АвансыВкл = Ложь, АвансыИскл = Ложь, 
										ДатаИскючения = '00010101') Экспорт

	Если Не ЗначениеЗаполнено(ДатаИскючения) И ЗначениеЗаполнено(ДанныеГрафика.СтрокаФИ.ДатаПризнанияДоРекласса) Тогда
		ДатаНачалаГрафика = ДанныеГрафика.СтрокаФИ.ДатаПризнанияДоРекласса;
	Иначе 
		ДатаНачалаГрафика = ДанныеГрафика.СтрокаФИ.ДатаПризнания;
	КонецЕсли;									
	
	ДенежныеПотоки = Новый ТаблицаЗначений;
	ДенежныеПотоки.Колонки.Добавить("Дата");
	ДенежныеПотоки.Колонки.Добавить("ДенежныйПоток");
	
	Если ОсновнойДолг И Не ДанныеГрафика.Лизинг Тогда
		Для каждого СтрокаТаб Из ДанныеГрафика.ОсновнойДолг Цикл			
			ДобавитьДенежныйПоток(ДенежныеПотоки, СтрокаТаб.Дата, - СтрокаТаб.Получение, ДатаНачалаГрафика, ДатаИскючения);
			ДобавитьДенежныйПоток(ДенежныеПотоки, СтрокаТаб.Дата, СтрокаТаб.Возврат, ДатаНачалаГрафика, ДатаИскючения);
		КонецЦикла;	
	КонецЕсли;
	
	Если ВНА И ДанныеГрафика.Лизинг Тогда
		
		ВалютаФИ = ДанныеГрафика.ВалютаФИ;
		ФВ = ДанныеГрафика.ФВ;
		Для каждого СтрокаТаб Из ДанныеГрафика.ВНА Цикл		
			
			СуммаМСФО = ВВалюту(СтрокаТаб.СуммаМСФО, ВалютаФИ, ФВ, СтрокаТаб.Дата);
			
			Если СтрокаТаб.ВидОперации = ПредопределенноеЗначение("Справочник.ВидыОпераций.ВводВЭксплуатацию") Тогда			
				ДобавитьДенежныйПоток(ДенежныеПотоки, СтрокаТаб.Дата, -СуммаМСФО,	ДатаНачалаГрафика, ДатаИскючения);
			ИначеЕсли СтрокаТаб.ВидОперации = ПредопределенноеЗначение("Справочник.ВидыОпераций.УменьшениеЛизинга") Тогда 
				ДобавитьДенежныйПоток(ДенежныеПотоки, СтрокаТаб.Дата, СуммаМСФО, 	ДатаНачалаГрафика, ДатаИскючения);
			ИначеЕсли СтрокаТаб.ВидОперации = ПредопределенноеЗначение("Справочник.ВидыОпераций.ВозвратОбъектаЛизинга") Тогда 
				ДобавитьДенежныйПоток(ДенежныеПотоки, СтрокаТаб.Дата, СуммаМСФО, 	ДатаНачалаГрафика, ДатаИскючения);
			Иначе //УвеличениеЛизинга
				ДобавитьДенежныйПоток(ДенежныеПотоки, СтрокаТаб.Дата, -СуммаМСФО, 	ДатаНачалаГрафика, ДатаИскючения);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Проценты Тогда
		Для каждого СтрокаТаб Из ДанныеГрафика.Проценты Цикл
			ДобавитьДенежныйПоток(ДенежныеПотоки, СтрокаТаб.Дата, СтрокаТаб.Уплата - СтрокаТаб.НеарендныйПлатеж - СтрокаТаб.НДС, ДатаНачалаГрафика, ДатаИскючения);		
		КонецЦикла;
	КонецЕсли;
	
	Если ДопРасходУсл Или ДопРасходМод Тогда
		Для каждого СтрокаТаб Из ДанныеГрафика.ДополнительныеРасходы Цикл
			
			Если ДопРасходУсл И Не СтрокаТаб.ТипПлатежа Тогда
				ДобавитьДенежныйПоток(ДенежныеПотоки, СтрокаТаб.Дата, СтрокаТаб.СуммаВВалюте - СтрокаТаб.НДСВВалюте, ДатаНачалаГрафика, ДатаИскючения);
			КонецЕсли;
			
			Если ДопРасходМод И СтрокаТаб.ТипПлатежа Тогда
				ДобавитьДенежныйПоток(ДенежныеПотоки, СтрокаТаб.Дата, СтрокаТаб.СуммаВВалюте - СтрокаТаб.НДСВВалюте, ДатаНачалаГрафика, ДатаИскючения);
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	Если АвансыВкл Или АвансыИскл Тогда
		Для каждого СтрокаТаб Из ДанныеГрафика.АвансовыеПлатежи Цикл
			
			Если АвансыВкл И СтрокаТаб.ВключенВОсновнойДолг Тогда
				ДобавитьДенежныйПоток(ДенежныеПотоки, СтрокаТаб.Дата, СтрокаТаб.СуммаВВалюте - СтрокаТаб.НДСВВалюте - СтрокаТаб.НеарендныйПлатеж, ДатаНачалаГрафика, ДатаИскючения);
			КонецЕсли;
			
			Если АвансыИскл И Не СтрокаТаб.ВключенВОсновнойДолг Тогда
				ДобавитьДенежныйПоток(ДенежныеПотоки, СтрокаТаб.Дата, СтрокаТаб.СуммаВВалюте - СтрокаТаб.НДСВВалюте - СтрокаТаб.НеарендныйПлатеж, ДатаНачалаГрафика, ДатаИскючения);
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	ДенежныеПотоки.Свернуть("Дата", "ДенежныйПоток");
	ДенежныеПотоки.Сортировать("Дата Возр");
	
	Возврат ДенежныеПотоки;
	
КонецФункции

Процедура ДобавитьДенежныйПоток(ДенежныеПотоки, Дата, Сумма = 0, ДатаНачалаГрафика, ДатаИскючения = '00010101')

	Если (Сумма = 0) Или (Дата <= ДатаИскючения) Тогда
		Возврат;
	КонецЕсли;
	
	НоваяСтрока = ДенежныеПотоки.Добавить();
	НоваяСтрока.Дата = ?(Дата < ДатаНачалаГрафика, ДатаНачалаГрафика, Дата);
	НоваяСтрока.ДенежныйПоток = Сумма;

КонецПроцедуры

Функция ВВалюту(Сумма, ВалютаИсточник, ВалютаПриемник, Дата) Экспорт

	Если ВалютаИсточник = ВалютаПриемник Тогда
		Возврат Сумма;	
	Иначе	
	    Возврат РаботаСКурсамиВалют.ПересчитатьВВалюту(Сумма, ВалютаИсточник, ВалютаПриемник, Дата); 
	КонецЕсли;
	
КонецФункции

#КонецОбласти

