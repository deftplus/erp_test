#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Доступность = Не ЗначениеЗаполнено(Объект.Претензия);
	
	УстановитьУсловноеОформление();
	РежимРедактирования = НЕ Объект.Проведен;
	Если Объект.ОбъектРасчетов <> Неопределено Тогда
		АктуальнаяВерсия = РегистрыСведений.ВерсииРасчетов.ПолучитьАктуальнуюВерсиюФинансовогоИнструмента(Объект.ОбъектРасчетов);
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
//Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыГрафик

&НаКлиенте
Процедура ГрафикПриИзменении(Элемент)
	РассчитатьЗадолженностьПоДатам();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РассчитатьОтДаты(Команда)
	
	ТекСтрока = Элементы.График.ТекущаяСтрока;
	
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РассчитатьОтДатыНаСервере(ТекСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьВерсию(Команда)
	
	РежимРедактирования = НЕ РежимРедактирования;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАктуальнуюВерсию(Команда)
	ПоказатьЗначение(,АктуальнаяВерсия);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФактическиеДанные(Команда)
	ОбновитьФактическиеДанныеНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПретензию(Команда)
	ПоказатьЗначение(,Объект.Претензия);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура РассчитатьОтДатыНаСервере(Знач ИдентификаторСтроки)
	
	ДанныеСтроки = Объект.График.НайтиПоИдентификатору(ИдентификаторСтроки);
	ДатаОтсчета = ДанныеСтроки.Дата;
	
	ВыполнятьПересчет = Истина;
	
	// Определим указанную позицию.
	Если ДанныеСтроки.СуммаНачисление <> 0 Тогда
		// Это начисление.Необходимо пересчитать постоплату.
		ЭтоНачисление = Истина;
		ТолькоПостоплата = Истина;
		НомерПозиции = 0; // проигнорируется.
	Иначе
		// Это оплата. Нас интересует только случай аванса.
		ЭтоНачисление = Ложь;
		ТолькоПостоплата = Ложь;
		// Проверим, аванс ли это.
		Для Каждого ТекСтрокаГрафика Из Объект.График Цикл
			Если ТекСтрокаГрафика.Дата < ДатаОтсчета И ТекСтрокаГрафика.СуммаНачисление <> 0 Тогда
				ВыполнятьПересчет = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ВыполнятьПересчет Тогда
			ЭтапОплатыАванса = Объект.УсловиеОплаты.ЭтапыОплаты.Найти(Перечисления.ВариантыОплаты.Аванс, "ВариантОплаты");
			Если ЭтапОплатыАванса = Неопределено Тогда
				// аванс не предусмотрен.
				ВыполнятьПересчет = Ложь;
			Иначе
				НомерПозиции = Объект.УсловиеОплаты.ЭтапыОплаты.Индекс(ЭтапОплатыАванса);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВыполнятьПересчет Тогда
		
		ПроизводственныйКалендарь = РаботаСДоговорамиКонтрагентовУХ.ПолучитьПроизводственныеКалендари(Объект.ДоговорКонтрагента);
		НовыйГрафик = РасчетГрафиковОперацийУХ.РассчитатьГрафикПоУсловиюОплаты(Объект.УсловиеОплаты, 
																				ДатаОтсчета, 
																				Объект.СуммаДокумента, 
																				ПроизводственныйКалендарь,
																				ЭтоНачисление,
																				НомерПозиции,
																				ТолькоПостоплата);
																				
		СтрокиКУдалению = Новый Массив;
		Для Каждого ТекСтрокаГрафика Из Объект.График Цикл
			Если ТекСтрокаГрафика.Дата > ДатаОтсчета Тогда
				СтрокиКУдалению.Добавить(ТекСтрокаГрафика);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ТекСтрокаКУдалению Из СтрокиКУдалению Цикл
			Объект.График.Удалить(ТекСтрокаКУдалению);
		КонецЦикла;
		
		Для Каждого ТекНоваяСтрокаГрафика Из НовыйГрафик Цикл
			
			СтрокиПоиска = Объект.График.НайтиСтроки(Новый Структура("Дата", ТекНоваяСтрокаГрафика.Дата));
			Если СтрокиПоиска.Количество() Тогда
				СтрокаДляИзменения = СтрокиПоиска[0];
			Иначе
				СтрокаДляИзменения = Объект.График.Добавить();
				СтрокаДляИзменения.Дата = ТекНоваяСтрокаГрафика.Дата;
			КонецЕсли;
			
			СтрокаДляИзменения.СуммаНачисление = Макс(СтрокаДляИзменения.СуммаНачисление, ТекНоваяСтрокаГрафика.СуммаНачисление);
			СтрокаДляИзменения.СуммаОплата = Макс(СтрокаДляИзменения.СуммаОплата, ТекНоваяСтрокаГрафика.СуммаОплата);
		КонецЦикла;
		
		РассчитатьЗадолженностьПоДатам();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура РассчитатьЗадолженностьПоДатам()
	
	ТаблицаГрафик = Объект.График.Выгрузить();
	
	ТаблицаГрафик.Сортировать("Дата");
	ТаблицаГрафик.Свернуть("Дата", "СуммаНачисление,СуммаОплата,СуммаЗадолженность");
	Задолженность = 0;
	Для Каждого ТекСтрока Из ТаблицаГрафик Цикл
		Задолженность = Задолженность + ТекСтрока.СуммаНачисление - ТекСтрока.СуммаОплата;
		ТекСтрока.СуммаЗадолженность = Задолженность;
	КонецЦикла;
	
	Объект.График.Загрузить(ТаблицаГрафик);
	
	ОтклонениеСумм = Объект.График.Итог("СуммаНачисление") - Объект.График.Итог("СуммаОплата");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьФактическиеДанныеНаСервере()
	
	ДокОбъект = РеквизитФормыВЗначение("Объект");
	ДокОбъект.ЗагрузитьФактическиеДанные();
	ЗначениеВРеквизитФормы(ДокОбъект, "Объект");
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект		= Форма.Объект;
	Элементы	= Форма.Элементы;
	
	Элементы.ГруппаЕстьПретензия.Видимость = ЗначениеЗаполнено(Объект.Претензия);
	Форма.ТолькоПросмотр = НЕ Форма.РежимРедактирования;
	
	ЭтоАктуальнаяВерсия = Форма.АктуальнаяВерсия.Пустая() ИЛИ Объект.Ссылка.Пустая() ИЛИ (Объект.Ссылка = Форма.АктуальнаяВерсия);
	
	Элементы.НадписьТолькоПросмотр.Видимость = ЭтоАктуальнаяВерсия И Объект.Проведен И НЕ Форма.РежимРедактирования И НЕ ЗначениеЗаполнено(Объект.Претензия);
	Элементы.ПодменюРедактировать.Доступность = ЭтоАктуальнаяВерсия;
	Элементы.ГруппаНеактуальныеПараметры.Видимость = НЕ ЭтоАктуальнаяВерсия;
	
	Элементы.ГраницаФактическихДанных.Видимость = ЗначениеЗаполнено(Объект.ГраницаФактическихДанных);
	
	Если ТипЗнч(Объект.ОбъектРасчетов) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		Элементы.ОбъектРасчетов.Заголовок = НСтр("ru = 'Договор'");
	ИначеЕсли ТипЗнч(Объект.ОбъектРасчетов) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		Элементы.ОбъектРасчетов.Заголовок = НСтр("ru = 'Заказ'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Колонки = Новый Массив;
	Колонки.Добавить(Элементы.ГрафикДата);
	Колонки.Добавить(Элементы.ГрафикСуммаНачисление);
	Колонки.Добавить(Элементы.ГрафикСуммаОплата);
	
	// Блокируем операции ДДС, прошедшие фактически.
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	Для Каждого ТекКолонка Из Колонки Цикл
		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, ТекКолонка.Имя);
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
	"Объект.График.Дата", ВидСравненияКомпоновкиДанных.Меньше,Новый ПолеКомпоновкиДанных("Объект.ГраницаФактическихДанных"),,Истина);

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
	"Объект.График.Дата", ВидСравненияКомпоновкиДанных.Заполнено,,,Истина);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр",            Истина);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

#КонецОбласти


