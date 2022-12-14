
#Область ОбработкаОсновныхСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПланСчетовМСФО = Справочники.ПланыСчетовБД.НайтиПоНаименованию("МСФО",,,Справочники.ТипыБазДанных.ТекущаяИБ);
	
	АналитикиЭлиминации.Добавить(Перечисления.ТипыАналитикЭлиминации.Организация);
	АналитикиЭлиминации.Добавить(Перечисления.ТипыАналитикЭлиминации.Контрагент);
	АналитикиЭлиминации.Добавить(Перечисления.ТипыАналитикЭлиминации.ВалютаВзаиморасчетов);
	
	ТипПеречислениеАналитикЭлиминации = Новый ОписаниеТипов("ПеречислениеСсылка.ТипыАналитикЭлиминации");
	
	Для каждого Проводка Из Объект.Проводки Цикл
		УстановитьСвойстваСубконто(Проводка.СчетДт, Проводка, "Дт");
		УстановитьСвойстваСубконто(Проводка.СчетКт, Проводка, "Кт");
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаСобытийЭлементовФормы

&НаКлиенте
Процедура ПроводкиСчетДтПриИзменении(Элемент)
	ОбработатьИзменениеСчета("Дт");
КонецПроцедуры

&НаКлиенте
Процедура ПроводкиСчетКтПриИзменении(Элемент)
	ОбработатьИзменениеСчета("Кт");
КонецПроцедуры

&НаКлиенте
Процедура ПроводкиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НЕ Копирование И НоваяСтрока Тогда
		Элемент.ТекущиеДанные.ПроцентОтСуммыРасхождения = 100;
	КонеЦЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроводкиАналитикаВГОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Проводки.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекЭлемент = Элементы.Проводки.ТекущийЭлемент;
	
	Суффикс = Прав(ТекЭлемент.Имя, 3);
	
	ДопПараметры = Новый Структура("ТекСтрока, ИмяЭлемента", Элементы.Проводки.ТекущаяСтрока, "АналитикаВГО" + Суффикс);
	Делегат_ = Новый ОписаниеОповещения("ОбработатьВыборЗначенияКолонки", ЭтаФорма, ДопПараметры);
	АналитикиЭлиминации = ПолучитьСписокАналитикЭлиминации(ТекущиеДанные.РазделВГО);
	АналитикиЭлиминации.ПоказатьВыборЭлемента(Делегат_, НСтр("ru = 'Аналитика сверки'"));
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьШаблон(Команда)
	ЗаполнитьШаблонНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПроводкиСпособЗаполненияСубконтоПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Проводки.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекЭлемент = Элементы.Проводки.ТекущийЭлемент;
	
	Суффикс = Прав(ТекЭлемент.Имя, 3);
	
	ТипЗначения = ТекущиеДанные["ТипСубконто"+Суффикс];
				
	Если ТипЗначения = Неопределено Тогда
		//ТекущиеДанные["ТипСубконто"+Суффикс] = Новый ОписаниеТипов("Неопределено");
		ТекущиеДанные["ЗначениеСубконто"+Суффикс] = Неопределено;
		
	Иначе
		//ТекущиеДанные["ТипСубконто"+Суффикс] = ТипЗначения;
		ТекущиеДанные["ЗначениеСубконто"+Суффикс] = ТипЗначения.ПривестиЗначение(ТекущиеДанные["ЗначениеСубконто"+Суффикс]);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроводкиПриАктивизацииЯчейки(Элемент)
	Если Элемент.ТекущийЭлемент = Неопределено Тогда
		Возврат;
	КонеЦЕсли;
	
	ИмяЭлемента = Элемент.ТекущийЭлемент.Имя;
	
	ПрефиксИмениПоля = "ПроводкиСубконто";
	
	Если Лев(ИмяЭлемента, СтрДлина(ПрефиксИмениПоля)) <> ПрефиксИмениПоля Тогда
		ПрефиксИмениПоля = "ПроводкиАналитикаВГО";
	
		Если Лев(ИмяЭлемента, СтрДлина(ПрефиксИмениПоля)) <> ПрефиксИмениПоля Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Суффикс = Прав(ИмяЭлемента, 3);
	
	Попытка
		Индекс = Число(Прав(Суффикс, 1));
	Исключение
		Возврат;
	КонецПопытки;
	
	Если Индекс < 1 И Индекс > 3 Тогда
		Возврат;
	КонеЦЕсли;
		
	ИдСтроки = Элементы.Проводки.ТекущаяСтрока;
	Если ИдСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СтрокаТаблицы = Объект.Проводки.НайтиПоИдентификатору(ИдСтроки);
	
	ИмяВидСубконто = СтрокаТаблицы["ИмяВидСубконто" + Суффикс];
	
	Если ПрефиксИмениПоля = "ПроводкиАналитикаВГО" Тогда
		Элементы[ПрефиксИмениПоля +  Суффикс].ПодсказкаВвода = ИмяВидСубконто;
		
	ИначеЕсли ИмяВидСубконто = "" Тогда
		Элементы[ПрефиксИмениПоля + Суффикс].ОграничениеТипа 	= Новый ОписаниеТипов("Неопределено");
		Элементы[ПрефиксИмениПоля +  Суффикс].ПодсказкаВвода 	= "";
		
	Иначе
		Элементы[ПрефиксИмениПоля +  Суффикс].ОграничениеТипа = СтрокаТаблицы["ТипСубконто" + Суффикс];
		Элементы[ПрефиксИмениПоля +  Суффикс].ПодсказкаВвода 	= ИмяВидСубконто;
			
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПроводкиИсточникДанныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Проводки.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекЭлемент = Элементы.Проводки.ТекущийЭлемент;
	
	Суффикс = Прав(ТекЭлемент.Имя, 2);
	
	ДопПараметры = Новый Структура("ТекСтрока, ИмяЭлемента", Элементы.Проводки.ТекущаяСтрока, "ИсточникДанных" + Суффикс);
	Делегат_ = Новый ОписаниеОповещения("ОбработатьВыборЗначенияКолонки", ЭтаФорма, ДопПараметры);
	ИсточникиДанных = ПолучитьСписокИсточниковДанных(ТекущиеДанные.РазделВГО, Суффикс = "Дт");
	ИсточникиДанных.ПоказатьВыборЭлемента(Делегат_, НСтр("ru = 'Источнки данных'"));
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыНаСервере

&НаСервереБезКонтекста
Функция ПолучитьСписокАналитикЭлиминации(РазделВГО)
	СписокАналитик = Новый СписокЗначений();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ГруппыАналитикСверкиВГОАналитики.Имя КАК ИмяАналитики
		|ИЗ
		|	Справочник.РазделыСверкиВГО КАК РазделыСверкиВГО
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыАналитикСверкиВГО.Аналитики КАК ГруппыАналитикСверкиВГОАналитики
		|		ПО РазделыСверкиВГО.ГруппаРаскрытия = ГруппыАналитикСверкиВГОАналитики.Ссылка
		|			И (РазделыСверкиВГО.Ссылка = &РазделВГО)
		|			И (НЕ ГруппыАналитикСверкиВГОАналитики.Ссылка.ПометкаУдаления)";
	
	Запрос.УстановитьПараметр("РазделВГО", РазделВГО);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ТЗАналитик = РезультатЗапроса.Выгрузить();
		мИменаАналитик = ТЗАналитик.ВыгрузитьКолонку("ИмяАналитики");
		СписокАналитик.ЗагрузитьЗначения(мИменаАналитик);
	КонецЕсли;
	
	Возврат СписокАналитик;
КонецФункции

&НаКлиенте
Процедура ОбработатьВыборЗначенияКолонки(Значение_, ДопПараметры) Экспорт
	Если Значение_ = Неопределено Тогда
		Возврат;
	КонеЦЕсли;
	
	ТекущиеДанные = Элементы.Проводки.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные[ДопПараметры.ИмяЭлемента] = Значение_.Значение;
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеСчета(ДтКт)
	
	ИдСтроки = Элементы.Проводки.ТекущаяСтрока;
	Если ИдСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СтрокаТаблицы = Объект.Проводки.НайтиПоИдентификатору(ИдСтроки);
	
	СчетБД = СтрокаТаблицы["Счет" + ДтКт];
	
	УстановитьСвойстваСубконто(СчетБД, СтрокаТаблицы, ДтКт)
			
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваСубконто(СчетБД, Проводка, ДтКт) Экспорт
	Для НомерСубконто = 1 По 3 Цикл
		ВидСубконто = ЭлиминацияВГОУХ.ПолучитьСубконтоСчета(СчетБД, НомерСубконто);
		
		Если ЗначениеЗаполнено(ВидСубконто) Тогда
			ТипЗначения = ВидСубконто.ТипЗначения;
			Проводка["ЗначениеСубконто" +  ДтКт + НомерСубконто + "Доступность"] = Истина;
			Проводка["ИмяВидСубконто" + ДтКт + НомерСубконто] = Строка(ВидСубконто);
			Проводка["ТипСубконто" + ДтКт + НомерСубконто] = ТипЗначения;
			Проводка["ЗначениеСубконто" + ДтКт + НомерСубконто] = 
					ТипЗначения.ПривестиЗначение(Проводка["ЗначениеСубконто" + ДтКт + НомерСубконто]);
			
		Иначе
			Проводка["ЗначениеСубконто" +  ДтКт + НомерСубконто + "Доступность"] = ЛОжь;
			Проводка["ЗначениеСубконто" + ДтКт + НомерСубконто] = Неопределено;
			Проводка["СпособЗаполненияСубконто" + ДтКт + НомерСубконто] = Перечисления.СпособыЗаполненияСубконтоВГО.ПустаяСсылка();
			Проводка["ИмяВидСубконто" + ДтКт + НомерСубконто] = "";
			Проводка["ТипСубконто" + ДтКт + НомерСубконто] = Новый ОписаниеТипов("Неопределено");
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокИсточниковДанных(РазделВГО, ЭтоДебет)
	СписокИД = Новый СписокЗначений();
	
	СпособыОпределенияНаправленияУчета = Новый Массив;
	СпособыОпределенияНаправленияУчета.Добавить(Перечисления.СпособОпределенияНаправленияУчета.ПоЗнакуОперации);
	Если ЭтоДебет Тогда
		СпособыОпределенияНаправленияУчета.Добавить(Перечисления.СпособОпределенияНаправленияУчета.ТолькоДебет);
	Иначе
		СпособыОпределенияНаправленияУчета.Добавить(Перечисления.СпособОпределенияНаправленияУчета.ТолькоКредит);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РазделыСверкиВГОИсточникиДанных.ИсточникДанных
		|ИЗ
		|	Справочник.РазделыСверкиВГО.ИсточникиДанных КАК РазделыСверкиВГОИсточникиДанных
		|ГДЕ
		|	РазделыСверкиВГОИсточникиДанных.Ссылка = &РазделВГО
		|	И РазделыСверкиВГОИсточникиДанных.СпособОпределенияНаправленияУчета В(&СпособыОпределенияНаправленияУчета)";
	
	Запрос.УстановитьПараметр("РазделВГО", РазделВГО);
	Запрос.УстановитьПараметр("СпособыОпределенияНаправленияУчета", СпособыОпределенияНаправленияУчета);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ТЗАналитик = РезультатЗапроса.Выгрузить();
		мИсточникиДанных = ТЗАналитик.ВыгрузитьКолонку("ИсточникДанных");
		СписокИД.ЗагрузитьЗначения(мИсточникиДанных);
	КонецЕсли;
	
	Возврат СписокИД;
КонецФункции

&НаСервере
Процедура ЗаполнитьШаблонНаСервере()
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ТекущийОбъект.Заполнить(Новый Структура("ЗаполнитьШаблон", Истина));
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
		
КонецПроцедуры

#КонецОбласти

