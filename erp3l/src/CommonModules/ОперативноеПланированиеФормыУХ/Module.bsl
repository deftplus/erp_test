////////////////////////////////////////////////////////////////////////////////
// Модуль содержит общие процедуры и функции, используемые в документах оперативного планирования и создаваемых на их основании: 
// - ОперативныйПлан;
// - ЗаявкаНаОперацию;
// - ПлатежноеПоручение;
// - СписаниеСРасчетногоСчета
// - ПоступлениеНаРасчетныйСчет
// - ОтражениеФактическихДанныхБюджетирования
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

#Область СобытияФормСписков

Функция ПолучитьЗначенияЗаполнения(Форма, ИмяВидаОперации) Экспорт
	
	ЗначенияЗаполнения = Новый Структура;
	
	ЗначенияЗаполнения.Вставить("ВидОперацииУХ", Справочники.ВидыОперацийУХ[ИмяВидаОперации]);

	Для Каждого ЭлементОтбора Из Форма.Список.КомпоновщикНастроек.ПолучитьНастройки().Отбор.Элементы Цикл
		
		Если ЭлементОтбора.Использование И ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
			ЗначенияЗаполнения.Вставить(ЭлементОтбора.ЛевоеЗначение, ЭлементОтбора.ПравоеЗначение);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЗначенияЗаполнения;
	
КонецФункции

#КонецОбласти

#Область СобытияФормОбъектов

// Функция формирует кэш, содержащий типы реквизитов переданного объекта метаданных
//
// Параметры:
//  ОбъектМетаданных - 	ОбъектМетаданных - объект метаданных, реквизиты которого необходимо поместить в кэш
// 
// Возвращаемое значение:
//  ФиксированнаяСтруктура
//
Функция ТипыРеквизитовОбъекта(ОбъектМетаданных) Экспорт
	
	ТипыРеквизитов=Новый Соответствие;
	
	Для Каждого Реквизит ИЗ ОбъектМетаданных.Реквизиты Цикл
		
		Если Реквизит.Имя="ИсходныйДокумент" Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Для Каждого Тип ИЗ Реквизит.Тип.Типы() Цикл
			
			ТипыРеквизитов.Вставить(Тип,Реквизит.Имя);
			
		КонецЦикла;
		
	КонецЦикла;

	Возврат Новый ФиксированноеСоответствие(ТипыРеквизитов);
	
КонецФункции

// Процедура устанавливает связи параметров выбора аналитик статьи бюджета с их владельцами.
Процедура УстановитьСвязиПараметровВыбора(Форма, ИдентификаторСтроки, ВидБюджета, Знач ШаблонИмениРеквизита = Неопределено, Знач ШаблонИмениЭлемента = Неопределено, Знач КолонкаСтатья = Неопределено) Экспорт
	
	Если ИдентификаторСтроки=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект		= Форма.Объект;
	Элементы	= Форма.Элементы;
	
	ТаблицаРеквизит = ОбщегоНазначенияКлиентСерверУХ.ПолучитьРеквизитФормыПоПути(Форма, Форма.ТекущийЭлемент.ПутьКДанным);
	
	ТекущиеДанные = ТаблицаРеквизит.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	ПараметрыБюджета = ДвиженияБюджетированиеКлиентСерверУХ.ПараметрыБюджета(ВидБюджета);
	КодВидаБюджета = ПараметрыБюджета.КодБюджета;
	
	Если КолонкаСтатья = Неопределено Тогда
		КолонкаСтатья = ПараметрыБюджета.КолонкаСтатья;
	КонецЕсли;
	
	Если ШаблонИмениРеквизита = Неопределено Тогда
		ШаблонИмениРеквизита = "Аналитика" + КодВидаБюджета + "%1";
	КонецЕсли;
	
	Если ШаблонИмениЭлемента = Неопределено Тогда
		ШаблонИмениЭлемента = "Аналитика" + КодВидаБюджета + "%1";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные[КолонкаСтатья]) Тогда
		ДанныеАналитики = ОбщегоНазначенияУХ.ПолучитьДанныеГруппыРаскрытияТЧ(,Новый Структура("Аналитики",ПолучитьМассивАналитикСтатьи(ТекущиеДанные, ШаблонИмениРеквизита)));
	Иначе
		Возврат;
	КонецЕсли;
	
	Для Индекс= 1 По АналитикиСтатейБюджетовУХКлиентСервер.КоличествоАналитикСтатьи() Цикл
		
		ИмяЭлемента		= СтрШаблон(ШаблонИмениЭлемента, Индекс);
		ИмяРеквизита	= СтрШаблон(ШаблонИмениРеквизита, Индекс);
		
		ИмяЭлементаВидАналитики = "ВидАналитики" + Индекс;
		Элемент=Элементы[ИмяЭлемента];
		
		ТекВидАналитики = ДанныеАналитики[ИмяРеквизита];
		
		Если Не ЗначениеЗаполнено(ТекВидАналитики.ВидАналитики) Тогда    		
			// Пустая аналитика. Не устанавливаем связи.
			Продолжить;
		КонецЕсли;
		
		Элемент.ПодсказкаВвода = ТекВидАналитики.Наименование;
		
		Если ТекВидАналитики.ТаблицаАналитики="Справочник.ПроизвольныйКлассификаторУХ" Тогда
			// Произвольный классификатор. Устанавливаем связь по нему.
			СвязиПараметровВыбора = Новый Массив;
			СвязиПараметровВыбора.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Элементы." + Форма.ТекущийЭлемент.Имя + ".ТекущиеДанные."+ИмяЭлементаВидАналитики));
			Элемент.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровВыбора);
		ИначеЕсли ТекВидАналитики.Свойство("ТипыВладельцев") Тогда
			// У аналитики есть владелец. Выставим параметры по владельцы. 
			ПолеВладельца="";
			
			Для Каждого КлючИЗначение ИЗ ДанныеАналитики Цикл // Ищем поле субконто с тем же типом, что и владелец
				
				Если Не ЗначениеЗаполнено(КлючИЗначение.Значение.ВидАналитики) Тогда
					
					Продолжить;
					
				ИначеЕсли НЕ ТекВидАналитики.ТипыВладельцев.НайтиПоЗначению(КлючИЗначение.Значение.Тип)=Неопределено Тогда
					
					ПолеВладельца = "Элементы." + Форма.ТекущийЭлемент.Имя + ".ТекущиеДанные."+КлючИЗначение.Ключ;
					Прервать;
					
				КонецЕсли;
				
			КонецЦикла;
			
			Если ПустаяСтрока(ПолеВладельца) Тогда // Ищем реквизит объекта с тем же типом, что и владелец
				
				Для Каждого СтрТип ИЗ ТекВидАналитики.ТипыВладельцев Цикл
					
					РеквизитОбъектаПоТипу = Форма.ТипыРеквизитовОбъекта.Получить(СтрТип.Значение);
					
					Если НЕ РеквизитОбъектаПоТипу=Неопределено Тогда
						
						ПолеВладельца="Объект."+РеквизитОбъектаПоТипу;
						Прервать;
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
			Если НЕ ПустаяСтрока(ПолеВладельца) Тогда
				
				СвязиПараметровВыбора = Новый Массив;
				СвязиПараметровВыбора.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", ПолеВладельца));
				Элемент.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровВыбора);
				
			КонецЕсли;
			
		Иначе
			// Владельца нет. Установим связь по типу.
			СвязиПараметровВыбора = Новый Массив;
			Элемент.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровВыбора);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры //

Процедура УстановитьУсловноеОформлениеДополнительныхАналитик(Форма, ТаблицаФормы, ВидБюджета, КодБюджетаВИменахЭлементов = Истина, Знач ОснованиеИмениЭлемента = Неопределено) Экспорт
	
	УсловноеОформление = Форма.УсловноеОформление;
	
	КодВидаБюджета = ДвиженияБюджетированиеКлиентСерверУХ.КодВидаБюджета(ВидБюджета);
	
	Для Индекс= 1 По АналитикиСтатейБюджетовУХКлиентСервер.КоличествоАналитикСтатьи() Цикл
		
		Если ОснованиеИмениЭлемента = Неопределено Тогда
			ОснованиеИмениЭлемента = "Аналитика";
		КонецЕсли;
		
		Если КодБюджетаВИменахЭлементов Тогда
			ИмяЭлемента=ОснованиеИмениЭлемента + КодВидаБюджета + Индекс;
		Иначе
			ИмяЭлемента = ОснованиеИмениЭлемента + Индекс;
		КонецЕсли;
		
		ИмяРеквизита = "ВидАналитики" + Индекс;
		
		ЭлементУО = УсловноеОформление.Элементы.Добавить();
		
		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, ИмяЭлемента);
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		ТаблицаФормы.ПутьКДанным + "." + ИмяРеквизита, ВидСравненияКомпоновкиДанных.НеЗаполнено,,,Истина);
		
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст",                     НСтр("ru = '<Не используется>'"));
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр",            Истина);
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
		
	КонецЦикла;
	//
	
КонецПроцедуры

Процедура УстановитьУсловноеОформлениеТаблицыКонтроля(Форма, ТаблицаФормы) Экспорт

	УсловноеОформление = Форма.УсловноеОформление;
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	Для Каждого ТекЭлемент Из ТаблицаФормы.ПодчиненныеЭлементы Цикл
		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, ТекЭлемент.Имя);
	КонецЦикла;

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
	ТаблицаФормы.ПутьКДанным + ".ЕстьНарушение", ВидСравненияКомпоновкиДанных.Равно,Ложь,,Истина);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоЗеленый);
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	Для Каждого ТекЭлемент Из ТаблицаФормы.ПодчиненныеЭлементы Цикл
		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, ТекЭлемент.Имя);
	КонецЦикла;

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
	ТаблицаФормы.ПутьКДанным + ".ЕстьНарушение", ВидСравненияКомпоновкиДанных.Равно,Истина,,Истина);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.Лосось);
	
	
КонецПроцедуры

// Процедура заполянет реквизиты строки ДанныеСтроки из сведениях об аналитиках статьи бюджета и приводит значения аналитик1..3 к новым типам
Процедура УстановитьАналитикиСтатьи(ДанныеСтроки, ВидБюджета, ШаблонИмениРеквизита, Знач КолонкаСтатья = Неопределено, ТолькоЛимитируемыеАналитики = Ложь, ПараметрыЛимитирования = неопределено) Экспорт
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если КолонкаСтатья = Неопределено Тогда
		ПараметрыБюджета = ДвиженияБюджетированиеКлиентСерверУХ.ПараметрыБюджета(ВидБюджета);
		КолонкаСтатья = ПараметрыБюджета.КолонкаСтатья;
	КонецЕсли;
	
	ОперативноеПланированиеФормыУХКлиентСервер.ЗаполнитьСведенияОВидахАналитик(ДанныеСтроки[КолонкаСтатья], ДанныеСтроки, ТолькоЛимитируемыеАналитики, ПараметрыЛимитирования);
	
	Для Индекс = 1 По АналитикиСтатейБюджетовУХКлиентСервер.КоличествоАналитикСтатьи() Цикл
		
		ПолеАналитики = СтрШаблон(ШаблонИмениРеквизита, Индекс);
		Если ДанныеСтроки.Свойство("ВидАналитики" + Индекс + "ТипЗначения") Тогда
			Если ЗначениеЗаполнено(ДанныеСтроки["ВидАналитики" + Индекс + "ТипЗначения"]) Тогда
				ДанныеТекущегоПоля = ДанныеСтроки["ВидАналитики" + Индекс + "ТипЗначения"].ПривестиЗначение(ДанныеСтроки[ПолеАналитики]);
				ДанныеСтроки[ПолеАналитики] = ДанныеТекущегоПоля;
			Иначе
				ДанныеСтроки[ПолеАналитики] = Неопределено
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура определяет минимально требуемый приоритет заявки исходя из ее реквизитов (Организация, ЦФО, Договор и статьей бюджета) и заполняет список возможных значений приоритета
//
// Параметры:
//  Форма				- УправляемаяФорма - Форма документа заявки
//  ИмяЭлементПриоритет - Строка - Имя элемента Приоритет (необязательный)
//  РеквизитыДокумента  - неопределено - коллекция реквизитов документа
//
Процедура ОпределитьПриоритетОперации(Форма, ИмяЭлементПриоритет = неопределено, РеквизитыДокумента = неопределено) Экспорт
	
	//
	Объект = Форма.Объект;
	
	//
	Если ИмяЭлементПриоритет = неопределено Тогда
		ЭлементПриоритет = Форма.Элементы.Приоритет;
	Иначе
		ЭлементПриоритет = Форма.Элементы.Найти(ИмяЭлементПриоритет);
	КонецЕсли;
	
	//
	Запрос = Новый Запрос;
	//
	Если РеквизитыДокумента = неопределено Тогда
		Инфо = ЗаявкиНаОперации.РеквизитыДокументаЗаявка(ТипЗнч(Объект.Ссылка));
	Иначе
		Инфо = РеквизитыДокумента;
	КонецЕсли;
	
	//
	Запрос.УстановитьПараметр("Организация",	ЗаявкиНаОперации.РеквизитЗаявки(Объект, Инфо.Организация));
	Запрос.УстановитьПараметр("ЦФО",			ЗаявкиНаОперации.РеквизитЗаявки(Объект, Инфо.ЦФО));
	Запрос.УстановитьПараметр("Договор",		ЗаявкиНаОперации.РеквизитЗаявки(Объект, Инфо.ДоговорКонтрагента));
	Запрос.УстановитьПараметр("СписокСтатей",	ЗаявкиНаОперации.РеквизитЗаявки(Объект, Инфо.СтатьяБюджета));
	
	//
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПриоритетыПлатежей.Ссылка КАК Ссылка,
	|	ПриоритетыПлатежей.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания
	|ПОМЕСТИТЬ ВТ_Приоритеты
	|ИЗ
	|	Справочник.ПриоритетыПлатежей КАК ПриоритетыПлатежей
	|ГДЕ
	|	ПриоритетыПлатежей.Ссылка В
	|			(ВЫБРАТЬ
	|				Организации.ПриоритетПлатежа КАК ПриоритетПлатежа
	|			ИЗ
	|				Справочник.Организации КАК Организации
	|			ГДЕ
	|				Организации.Ссылка В (&Организация, &ЦФО)
	|		
	|			ОБЪЕДИНИТЬ ВСЕ
	|		
	|			ВЫБРАТЬ
	|				ДоговорыКонтрагентов.ПриоритетПлатежа
	|			ИЗ
	|				Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|			ГДЕ
	|				ДоговорыКонтрагентов.Ссылка = &Договор
	|		
	|			ОБЪЕДИНИТЬ ВСЕ
	|		
	|			ВЫБРАТЬ
	|				СтатьиДвиженияДенежныхСредств.Приоритет
	|			ИЗ
	|				Справочник.СтатьиДвиженияДенежныхСредств КАК СтатьиДвиженияДенежныхСредств
	|			ГДЕ
	|				СтатьиДвиженияДенежныхСредств.Ссылка В (&СписокСтатей))
	|
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПриоритетыПлатежей.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания,
	|	ПриоритетыПлатежей.Ссылка КАК Приоритет
	|ИЗ
	|	ВТ_Приоритеты КАК ВТ_Приоритеты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПриоритетыПлатежей КАК ПриоритетыПлатежей
	|		ПО (ВТ_Приоритеты.РеквизитДопУпорядочивания <= ПриоритетыПлатежей.РеквизитДопУпорядочивания
	|				ИЛИ ВТ_Приоритеты.РеквизитДопУпорядочивания ЕСТЬ NULL)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПриоритетыПлатежей.РеквизитДопУпорядочивания,
	|	ПриоритетыПлатежей.Ссылка
	|ИЗ
	|	Справочник.ПриоритетыПлатежей КАК ПриоритетыПлатежей
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_Приоритеты КАК ВТ_Приоритеты
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ВТ_Приоритеты.Ссылка ЕСТЬ NULL
	|
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Приоритеты.Ссылка КАК Приоритет,
	|	ВТ_Приоритеты.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания
	|ИЗ
	|	ВТ_Приоритеты КАК ВТ_Приоритеты";
	
	Результат = Запрос.ВыполнитьПакет();
	
	// Список выбора
	ЭлементПриоритет.СписокВыбора.ЗагрузитьЗначения(Результат[1].Выгрузить().ВыгрузитьКолонку("Приоритет"));
	
	// Текущее значение приритета
	Выборка = Результат[2].Выбрать();
	
	Если Выборка.Следующий() Тогда
		Если ЗначениеЗаполнено(Объект.Приоритет) Тогда
			//
			ТекущийПриоритет = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Приоритет, "РеквизитДопУпорядочивания");
			Если ТекущийПриоритет < Выборка.РеквизитДопУпорядочивания Тогда
				Объект.Приоритет = Выборка.Приоритет;
			КонецЕсли;
		Иначе
			Объект.Приоритет = Выборка.Приоритет;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры 

Процедура ОпределитьНаличиеПредопределенныхРолей(Форма) Экспорт
	
	Объект = Форма.Объект;
	Форма.ЕстьСуперПользователь	= МодульСогласованияДокументовУХ.ЕстьСуперПользователь(Объект.ЦФО);
		
КонецПроцедуры // ОпределитьНаличиеПредопределенныхРолей()

Процедура УстановитьПроектБюджетодержатель(Форма) Экспорт
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если НЕ ЗначениеЗаполнено(Объект.Проект) Тогда
		Форма.ПроектБюджетодержатель = Справочники.Проекты.ПустаяСсылка();
		Элементы.ПроектБюджетодержатель.Видимость = Ложь;
	ИначеЕсли ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Проект, "Проект") Тогда
		Форма.ПроектБюджетодержатель = Объект.Проект;
		Элементы.ПроектБюджетодержатель.Видимость = Ложь;
	Иначе
		Форма.ПроектБюджетодержатель= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Проект, "ПроектЭтапа");
		Элементы.ПроектБюджетодержатель.Видимость = Истина;
	КонецЕсли;

КонецПроцедуры

Процедура ИнициализироватьТаблицуКонтролей(Форма) Экспорт
	
	Объект = Форма.Объект;
	СостояниеКонтролей = Форма.СостояниеКонтролей;
	
	СостояниеКонтролей.Очистить();
	
	// 1. Контроль лимита БДДС
	НовыйКонтроль = СостояниеКонтролей.Добавить();
	НовыйКонтроль.ВидКонтроля = НСтр("ru = 'Контроль лимита по бюджету'");
	НовыйКонтроль.ЕстьНарушение = Объект.ЕстьПревышениеЛимитыБюджет;
	НовыйКонтроль.Уточнение = НСтр("ru = 'Открыть детализацию...'");
	
	// 2. Контроль лимита взаиморасчетов.
	НовыйКонтроль = СостояниеКонтролей.Добавить();
	НовыйКонтроль.ВидКонтроля = НСтр("ru = 'Контроль лимита задолженности'");
	НовыйКонтроль.ЕстьНарушение = Объект.ЕстьПревышениеЛимитыВзаиморасчеты;
	НовыйКонтроль.Уточнение = НСтр("ru = 'Открыть детализацию...'");
	
КонецПроцедуры

Процедура УстановитьПараметрыВыбораДоговоров(Форма) Экспорт
	
	Объект = Форма.Объект;
	ВидОперации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ВидОперацииУХ, "ВидОперацииДДСБезналичныйРасчет");
	МассивВидовДоговоров = УправлениеДоговорамиУХКлиентСерверПовтИсп.ОпределитьВидДоговораПоВидуОперации(ВидОперации);
	Если МассивВидовДоговоров.Количество() Тогда
		ПараметрВыбора = Новый ПараметрВыбора("Отбор.ВидДоговораУХ", ОбщегоНазначения.ФиксированныеДанные(МассивВидовДоговоров));
		МассивПараметровВыбора = Новый ФиксированныйМассив(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПараметрВыбора));
	Иначе
		МассивПараметровВыбора = Новый ФиксированныйМассив(Новый Массив);
	КонецЕсли;
	
	Форма.Элементы.ДоговорКонтрагента.ПараметрыВыбора = МассивПараметровВыбора;
	
КонецПроцедуры

Процедура ПроверитьДоговорКонтрагента(Форма) Экспорт
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Для Каждого ТекПараметрВыбора Из Элементы.ДоговорКонтрагента.ПараметрыВыбора Цикл
		
		Если ТекПараметрВыбора.Имя = "Отбор.ВидДоговораУХ" Тогда
			
			ВидДоговораУХ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ДоговорКонтрагента, "ВидДоговораУХ");
			
			ДоговорСоответствуетОтбору = Истина;
			
			Если ТипЗнч(ТекПараметрВыбора.Значение) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
				ДоговорСоответствуетОтбору = (ВидДоговораУХ = ТекПараметрВыбора.Значение);
			ИначеЕсли ТипЗнч(ТекПараметрВыбора.Значение) = Тип("ФиксированныйМассив")
				ИЛИ ТипЗнч(ТекПараметрВыбора.Значение) = Тип("Массив") Тогда
				ДоговорСоответствуетОтбору = (ТекПараметрВыбора.Значение.Найти(ВидДоговораУХ) <> Неопределено);
			КонецЕсли;
			
			Если Не ДоговорСоответствуетОтбору Тогда
				Объект.ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	
КонецПроцедуры

Процедура ОграничитьТипДокументаПланированияВДокументахПоступления(Форма, ЭлементыДокументПланирования) Экспорт
	ОписаниеТипов = Новый ОписаниеТипов("ДокументСсылка.ОжидаемоеПоступлениеДенежныхСредств, ДокументСсылка.ОперативныйПлан, СправочникСсылка.Периоды");
	Для Каждого ТекЭлемент Из ЭлементыДокументПланирования Цикл
		ТекЭлемент.ОграничениеТипа = ОписаниеТипов;
	КонецЦикла;
КонецПроцедуры

Функция КартинкаСтраницыКонтроль(ЕстьПревышениеЛимитов, ЕстьПредупреждения = Ложь, ЕстьИнформация = Ложь) Экспорт
	
	Если ЕстьПревышениеЛимитов Тогда
		Возврат БиблиотекаКартинок.СообщениеОПроблемах;
	ИначеЕсли ЕстьПредупреждения Тогда
		Возврат БиблиотекаКартинок.Предупреждение;
	ИначеЕсли ЕстьИнформация Тогда
		Возврат БиблиотекаКартинок.Информация;
	Иначе
		Возврат Новый Картинка;
	КонецЕсли;
	
КонецФункции

Процедура УстановитьКартинкуСтраницыКонтроль(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Элементы.СтраницаКонтроль.Картинка = КартинкаСтраницыКонтроль(
		Объект.ЕстьПревышениеЛимитов,
		Форма.ЕстьПредупреждения,
		Форма.ЕстьИнформация);
	
КонецПроцедуры

Функция КартинкаПоВидуПредупреждения(ВидПредупреждения) Экспорт
	
	Если ВРЕГ(ВидПредупреждения) = "ОШИБКА" Тогда
		Возврат БиблиотекаКартинок.СообщениеОПроблемах;
	ИначеЕсли ВРЕГ(ВидПредупреждения) = "ПРЕДУПРЕЖДЕНИЕ" Тогда
		Возврат БиблиотекаКартинок.Предупреждение;
	ИначеЕсли ВРЕГ(ВидПредупреждения) = "ИНФОРМАЦИЯ" Тогда
		Возврат БиблиотекаКартинок.Информация;
	Иначе
		Возврат Новый Картинка;
	КонецЕсли;
	
КонецФункции
#КонецОбласти

#Область ДокументыБП_ДопАналитики

Процедура ПриСозданииНаСервереДокументДДС(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	УстановитьУсловноеОформлениеДокументДДС(Форма);
	
	Если Форма.Параметры.Ключ.Пустая() Тогда
		ОперативноеПланированиеФормыВстраиваниеУХ.ПодготовитьФормуДокументаДДС(Форма);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЧтенииНаСервереДокументДДС(Форма, ТекущийОбъект) Экспорт
	ОперативноеПланированиеФормыВстраиваниеУХ.ПодготовитьФормуДокументаДДС(Форма);	
КонецПроцедуры

Процедура ПослеЗаписиНаСервереДокументДДС(Форма, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	
	ОперативноеПланированиеФормыВстраиваниеУХ.ПодготовитьФормуДокументаДДС(Форма);
	
КонецПроцедуры

Процедура ПриИзмененииВидаОперацииНаСервереДокументДДС(Форма) Экспорт
	
	ОперативноеПланированиеФормыВстраиваниеУХ.ПодготовитьФормуДокументаДДС(Форма);
	ОперативноеПланированиеФормыУХКлиентСервер.ПривестиЗначениеТиповАналитик(Форма.Объект, Форма);
	ОперативноеПланированиеФормыУХКлиентСервер.УправлениеФормойДокументаДДС(Форма);
	
КонецПроцедуры

Процедура ДобавитьЦфоПроектИзДоговора(СтруктураЗаполнения, Договор) Экспорт
		
	Если ЗначениеЗаполнено(Договор) Тогда
		
		МетДоговора = Договор.Метаданные();	
		
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВерсияСоглашения", МетДоговора) Тогда
			
			СтруктураРеквизитовДоговора = Новый Структура;
			СтруктураРеквизитовДоговора.Вставить("ЦФО", "ВерсияСоглашения.ОсновнойЦФО");
			СтруктураРеквизитовДоговора.Вставить("Проект", "ВерсияСоглашения.ОсновнойПроект");	
			
			Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, СтруктураРеквизитовДоговора);
			Для каждого Элемент Из Реквизиты Цикл
				СтруктураЗаполнения.Вставить(Элемент.Ключ, Элемент.Значение);
			КонецЦикла;	
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьМассивАналитикСтатьи(ИсходныеДанные, ШаблонИмени) Экспорт
	
	МассивАналитик=Новый Массив;
	
	Для Индекс=1 По АналитикиСтатейБюджетовУХКлиентСервер.КоличествоАналитикСтатьи() Цикл
		
		МассивАналитик.Добавить(Новый Структура("Имя,ВидАналитики",
												СтрШаблон(ШаблонИмени,Индекс),
												ИсходныеДанные["ВидАналитики"+Индекс]));
		
	КонецЦикла;
		
	
	Возврат МассивАналитик;
				
КонецФункции // ПолучитьМассивАналитикСтатьи()

Процедура ДобавитьПриоритетОперации(ТаблицаПриоритетов, Приоритет)
	
	Если ЗначениеЗаполнено(Приоритет) Тогда
		НовыйПриоритет = ТаблицаПриоритетов.Добавить();
		НовыйПриоритет.Приоритет = Приоритет;
		НовыйПриоритет.Рейтинг = НовыйПриоритет.Приоритет.РеквизитДопУпорядочивания;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьУсловноеОформлениеДокументДДС(Форма)
	
	УсловноеОформление = Форма.УсловноеОформление;
	
	ЭлементыТабличныеЧасти = Форма.ИменаЭлементовТабличныхЧастей();
	// Аналитики бюджетирования
	Для Сч = 1 По АналитикиСтатейБюджетовУХКлиентСервер.КоличествоАналитикСтатьи() Цикл

		// Видимость аналитики

		ЭлементУО = УсловноеОформление.Элементы.Добавить();
		
		Для Каждого ТекТабЧасть Из ЭлементыТабличныеЧасти Цикл
			КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, ТекТабЧасть + "АналитикаБДДС" + Сч);
		КонецЦикла;

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
			"Объект.РасшифровкаПлатежа.ВидАналитики" + Сч, ВидСравненияКомпоновкиДанных.НеЗаполнено);
		
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);


		// Выделение не заполненной аналитики

		ЭлементУО = УсловноеОформление.Элементы.Добавить();
		
		Для Каждого ТекТабЧасть Из ЭлементыТабличныеЧасти Цикл
			КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, ТекТабЧасть + "АналитикаБДДС" + Сч);
		КонецЦикла;

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
			"Объект.РасшифровкаПлатежа.ВидАналитики" + Сч, ВидСравненияКомпоновкиДанных.Заполнено);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
			"Объект.РасшифровкаПлатежа.АналитикаБДДС" + Сч, ВидСравненияКомпоновкиДанных.НеЗаполнено);

		ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НеЗаполненноеСубконто);

		ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<...>'"));
		
	КонецЦикла;
	
	
КонецПроцедуры

#КонецОбласти
