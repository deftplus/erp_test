#Область СобытияМодуляФормы

#Область ФормаВыбораИсточникаОбеспечения

#Область СтандартныеОбработчики

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	// Создаем необходимые реквизиты и элементы формы
	СоздатьРеквизитыФормыДокумента(Форма);
	СоздатьЭлементыФормыДокумента(Форма);
	
КонецПроцедуры

#КонецОбласти 

#Область Интерфейс

Функция УстановитьТекстЗапросаСпискаПоставщиков(Форма) экспорт
	
	Элементы = Форма.Элементы;
	
	Если НЕ Форма.ЕстьПланыПоставокПоДоговорам Тогда
		
		// 
		Элементы.ПоставщикиКонтрагент.Видимость			= Ложь;
		Элементы.ПоставщикиДоговор.Видимость			= Ложь;
		Элементы.ПоставщикиНачалоДействия.Видимость		= Ложь;
		Элементы.ПоставщикиОкончаниеДействия.Видимость	= Ложь;
		
		Элементы.ПоставщикиДоступно.Видимость			= Ложь;
		Элементы.ПоставщикиПрошлыхПериодов.Видимость	= Ложь;
		Элементы.ПоставщикиТекущегоПериода.Видимость	= Ложь;
		Элементы.ПоставщикиБудущихПериодов.Видимость	= Ложь;
		
		// Удалить добавленные поля из пользовательских настроек
		Для Каждого Настройка Из Форма.Поставщики.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
			
			Если ТипЗнч(Настройка) <> Тип("ПорядокКомпоновкиДанных") Тогда
				Продолжить;
			КонецЕсли;
			
			ПоляДобавленные = Новый Массив;
			ПоляДобавленные.Добавить("НачалоДействия");
			ПоляДобавленные.Добавить("ОкончаниеДействия");
			ПоляДобавленные.Добавить("Контрагент");
			ПоляДобавленные.Добавить("Договор");
			ПоляДобавленные.Добавить("Доступно");
			ПоляДобавленные.Добавить("ПрошлыхПериодов");
			ПоляДобавленные.Добавить("ТекущегоПериода");
			ПоляДобавленные.Добавить("БудущихПериодов");
			
			Поз = 0;
			Пока Поз < Настройка.Элементы.Количество() Цикл
				
				Порядок = Настройка.Элементы[Поз];
				
				Если ПоляДобавленные.Найти(Строка(Порядок.Поле)) <> неопределено Тогда
					Настройка.Элементы.Удалить(Порядок);
					Продолжить;
				КонецЕсли;
				
				Поз = Поз + 1;
				
			КонецЦикла;
			
			
			Прервать;
			
		КонецЦикла;
		
		Возврат Ложь;
	КонецЕсли;
	
	Поставщики = Форма.Поставщики;
	Параметры = Форма.Параметры;
	
	//
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица              = "Справочник.ДоговорыКонтрагентов";
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	СвойстваСписка.ТекстЗапроса =
		"ВЫБРАТЬ
		|	ПланПоставокПоДоговорамОстатки.Договор КАК Договор,
		|	ПланПоставокПоДоговорамОстатки.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	СУММА(ПланПоставокПоДоговорамОстатки.КоличествоОстаток) КАК Доступно,
		|	СУММА(ВЫБОР
		|			КОГДА &ТекущаяДата >= ПланПоставокПоДоговорамОстатки.ПериодПотребности.ДатаНачала
		|					И &ТекущаяДата >= ПланПоставокПоДоговорамОстатки.ПериодПотребности.ДатаОкончания
		|				ТОГДА ПланПоставокПоДоговорамОстатки.КоличествоОстаток
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ПрошлыхПериодов,
		|	СУММА(ВЫБОР
		|			КОГДА &ТекущаяДата МЕЖДУ ПланПоставокПоДоговорамОстатки.ПериодПотребности.ДатаНачала И ПланПоставокПоДоговорамОстатки.ПериодПотребности.ДатаОкончания
		|				ТОГДА ПланПоставокПоДоговорамОстатки.КоличествоОстаток
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ТекущегоПериода,
		|	СУММА(ВЫБОР
		|			КОГДА &ТекущаяДата < ПланПоставокПоДоговорамОстатки.ПериодПотребности.ДатаНачала
		|					И &ТекущаяДата < ПланПоставокПоДоговорамОстатки.ПериодПотребности.ДатаОкончания
		|				ТОГДА ПланПоставокПоДоговорамОстатки.КоличествоОстаток
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК БудущихПериодов
		|ПОМЕСТИТЬ ВТ_ПланПоставок
		|ИЗ
		|	РегистрНакопления.ПланПоставокПоДоговорам.Остатки(
		|			,
		|			Номенклатура = &Номенклатура
		|				И Характеристика = &Характеристика) КАК ПланПоставокПоДоговорамОстатки
		|ГДЕ
		|	НЕ ПланПоставокПоДоговорамОстатки.Договор.Контрагент.Партнер ЕСТЬ NULL
		|
		|СГРУППИРОВАТЬ ПО
		|	ПланПоставокПоДоговорамОстатки.Договор,
		|	ПланПоставокПоДоговорамОстатки.Номенклатура.ЕдиницаИзмерения
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Договоры.Ссылка КАК Договор,
		|	Договоры.Контрагент.Партнер КАК Поставщик,
		|	Договоры.Контрагент КАК Контрагент,
		|	Договоры.ДатаНачалаДействия КАК НачалоДействия,
		|	Договоры.ДатаОкончанияДействия КАК ОкончаниеДействия,
		|	ЗНАЧЕНИЕ(Справочник.ВидыЦенПоставщиков.ПустаяСсылка) КАК ВидЦены,
		|	ВТ_ПланПоставок.ЕдиницаИзмерения КАК Упаковка,
		|	ВТ_ПланПоставок.Доступно КАК Доступно,
		|	ВТ_ПланПоставок.ПрошлыхПериодов КАК ПрошлыхПериодов,
		|	ВТ_ПланПоставок.ТекущегоПериода КАК ТекущегоПериода,
		|	ВТ_ПланПоставок.БудущихПериодов КАК БудущихПериодов,
		|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК Зарегистрирована,
		|	0 КАК Цена,
		|	0 КАК ЦенаУпрУчет,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ПоследняяПоставка,
		|	0 КАК ВсегоПоставок
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК Договоры
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПланПоставок КАК ВТ_ПланПоставок
		|		ПО (ВТ_ПланПоставок.Договор = Договоры.Ссылка)
		|ГДЕ
		|	НЕ Договоры.Контрагент.Партнер ЕСТЬ NULL
		|	И Договоры.Контрагент.Партнер.Поставщик
		|	И НЕ Договоры.ПометкаУдаления";
	
	УчестьФункциональныеОпцииПриВыбореПартнера(СвойстваСписка.ТекстЗапроса, "Партнеры.Ссылка");
	
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Поставщики, СвойстваСписка);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "Номенклатура",   Параметры.Номенклатура,   Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "Характеристика", Параметры.Характеристика, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "ТекущаяДата",   НачалоДня(Текущаядата()),   Истина);
	
	Элементы.ПоставщикиКонтрагент.Видимость			= Истина;
	Элементы.ПоставщикиДоговор.Видимость			= Истина;
	Элементы.ПоставщикиНачалоДействия.Видимость		= Истина;
	Элементы.ПоставщикиОкончаниеДействия.Видимость	= Истина;
	Элементы.ПоставщикиДоступно.Видимость			= Истина;
	Элементы.ПоставщикиПрошлыхПериодов.Видимость	= Истина;
	Элементы.ПоставщикиТекущегоПериода.Видимость	= Истина;
	Элементы.ПоставщикиБудущихПериодов.Видимость	= Истина;
	
	Возврат Истина;
	
КонецФункции
	
#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура СоздатьРеквизитыФормыДокумента(Форма)
	
	Если ФормыУХ.ЭлементыФормыУХУжеСозданы(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	//
	Реквизиты = Новый Массив;
	Реквизиты.Добавить(Новый РеквизитФормы("ЕстьПланыПоставокПоДоговорам",	Новый ОписаниеТипов("Булево"),,НСтр("ru = 'Есть планы поставок по договорам'")));
	
	Форма.ИзменитьРеквизиты(Реквизиты);
	
КонецПроцедуры

Процедура СоздатьЭлементыФормыДокумента(Форма) 
	
	Если ФормыУХ.ЭлементыФормыУХУжеСозданы(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	Элементы = Форма.Элементы;
	
	//
	ФормыУХ.ЭлементыФормыУХДобавлены(Форма);
	
	// ЕстьПланыПоставокПоДоговорам
	ФормыУХ.СоздатьПолеФормы(
		Элементы, "ЕстьПланыПоставокПоДоговорам",, "ЕстьПланыПоставокПоДоговорам", ВидПоляФормы.ПолеФлажка,
		Элементы.ГруппаОтборПоставщиков, , , ФормыУХ.ПриИзменении("Подключаемый_ПриИзменении"));
		
	#Область ТаблицаПоставщики
		
	// корректировка запроса
	ТекстЗапроса = Форма.Поставщики.ТекстЗапроса;
	ТекстКЗамене = "КАК ВсегоПоставок";
	ТекстЗамены = ТекстКЗамене+ ",
				|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)			КАК Контрагент,
				|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)	КАК Договор,
				|	ДАТАВРЕМЯ(1,1,1)										КАК НачалоДействия,
				|	ДАТАВРЕМЯ(1,1,1)										КАК ОкончаниеДействия,
				|	0 														КАК Доступно,
				|	0 														КАК ПрошлыхПериодов,
				|	0 														КАК ТекущегоПериода,
				|	0 														КАК БудущихПериодов";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ТекстКЗамене, ТекстЗамены);
	Форма.Поставщики.ТекстЗапроса = ТекстЗапроса;
	
	// добавление полей
	ФормыУХ.СоздатьПолеФормы(
		Элементы, "ПоставщикиКонтрагент",, "Поставщики.Контрагент", ,
		Элементы.Поставщики, Элементы.ПоставщикиПоставщик, ФормыУХ.БезПараметров());
	ФормыУХ.СоздатьПолеФормы(
		Элементы, "ПоставщикиДоговор",, "Поставщики.Договор", ,
		Элементы.Поставщики, Элементы.ПоставщикиПоставщик, ФормыУХ.БезПараметров());
	ФормыУХ.СоздатьПолеФормы(
		Элементы, "ПоставщикиНачалоДействия",, "Поставщики.НачалоДействия", ,
		Элементы.Поставщики, Элементы.ПоставщикиЦенаУпрУчет, ФормыУХ.БезПараметров());
	ФормыУХ.СоздатьПолеФормы(
		Элементы, "ПоставщикиОкончаниеДействия",, "Поставщики.ОкончаниеДействия", ,
		Элементы.Поставщики, Элементы.ПоставщикиЦенаУпрУчет, ФормыУХ.БезПараметров());
	ФормыУХ.СоздатьПолеФормы(
		Элементы, "ПоставщикиДоступно",, "Поставщики.Доступно", ,
		Элементы.Поставщики, , ФормыУХ.БезПараметров());
	ФормыУХ.СоздатьПолеФормы(
		Элементы, "ПоставщикиПрошлыхПериодов",, "Поставщики.ПрошлыхПериодов", ,
		Элементы.Поставщики, , ФормыУХ.БезПараметров());
	ФормыУХ.СоздатьПолеФормы(
		Элементы, "ПоставщикиТекущегоПериода",, "Поставщики.ТекущегоПериода", ,
		Элементы.Поставщики, , ФормыУХ.БезПараметров());
	ФормыУХ.СоздатьПолеФормы(
		Элементы, "ПоставщикиБудущихПериодов",, "Поставщики.БудущихПериодов", ,
		Элементы.Поставщики, , ФормыУХ.БезПараметров());
		
	#КонецОбласти 
	
	Форма.ЕстьПланыПоставокПоДоговорам = Истина;
		
КонецПроцедуры

// Процедура скопирована из модуля формы обработки
Процедура УчестьФункциональныеОпцииПриВыбореПартнера(ТекстЗапроса, ИмяПоляПатнера)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		ТекстЗапроса = ТекстЗапроса + "	И " + ИмяПоляПатнера + " <> Значение(Справочник.Партнеры.НеизвестныйПартнер)";
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПередачиТоваровМеждуОрганизациями") Тогда
		ТекстЗапроса = ТекстЗапроса + "	И " + ИмяПоляПатнера + " <> Значение(Справочник.Партнеры.НашеПредприятие)";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 	

#КонецОбласти 

#КонецОбласти 

#Область МодульОбъекта

#КонецОбласти 

#Область МодульМенеджера

#КонецОбласти 
