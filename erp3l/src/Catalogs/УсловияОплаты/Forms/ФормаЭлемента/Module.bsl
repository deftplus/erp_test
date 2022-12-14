&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Объект.ЭтапыОплаты.Количество() Тогда 
		ТипыСроков = Новый Соответствие;
		БазовыеДаты = Новый Соответствие;
		
		Для Каждого ТекСтр Из Объект.ЭтапыОплаты Цикл 
			ТипыСроков.Вставить(ТекСтр.ТипСрока, Истина);
			БазовыеДаты.Вставить(ТекСтр.БазоваяДата, Истина);
		КонецЦикла;
		
		Если ТипыСроков.Количество() = 1 Тогда 
			
			ТипСрокаВСтроках = Ложь;
			Для каждого КлючИЗначение Из ТипыСроков Цикл 
				ТипСрока = КлючИЗначение.Ключ;
			КонецЦикла;
			
		Иначе 
			
			ТипСрокаВСтроках = Истина;
			
		КонецЕсли;
		
		Если БазовыеДаты.Количество() = 1 Тогда 
			
			БазоваяДатаВСтроках = Ложь;
			Для каждого КлючИЗначение Из БазовыеДаты Цикл 
				БазоваяДата = КлючИЗначение.Ключ;
			КонецЦикла;
		Иначе 
			БазоваяДатаВСтроках = Истина;
		КонецЕсли;

	КонецЕсли;
	
	Если Не БазоваяДатаВСтроках И Не ЗначениеЗаполнено(БазоваяДата) Тогда
		БазоваяДата = Справочники.АлгоритмыОпределенияБазовойДаты.ДатаРасчетногоДокумента;
	КонецЕсли;
	
	Если Не ТипСрокаВСтроках И Не ЗначениеЗаполнено(ТипСрока) Тогда
		ТипСрока = Перечисления.СпособыРасчетаКоличестваДнейВПериоде.ПоКалендарнымДням;
	КонецЕсли;
	
	РассчитатьИтоговыеПоказатели(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыОплатыТипСрока.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыОплаты.ТипСрока");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СпособыРасчетаКоличестваДнейВПериоде.ПоКалендарнымДням;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'календарных дней'"));
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыОплатыТипСрока.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыОплаты.ТипСрока");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СпособыРасчетаКоличестваДнейВПериоде.ПоРабочимДням;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'рабочих дней'"));

	//
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыОплатыПроцентОплаты.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПроцентОплатыОбщий");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 100;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Кирпичный);

	//
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыОплатыБазоваяДата.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("БазоваяДатаВСтроках");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыОплатыТипСрока.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипСрокаВСтроках");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьИтоговыеПоказатели(Форма)
	
	Объект = Форма.Объект;
	
	Форма.ПроцентОплатыОбщий = 0;
	
	Для Каждого ТекСтрока Из Объект.ЭтапыОплаты Цикл 
		
		Форма.ПроцентОплатыОбщий = Форма.ПроцентОплатыОбщий + ТекСтрока.ПроцентОплаты;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОплатыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РассчитатьИтоговыеПоказатели(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОплатыПослеУдаления(Элемент)
	
	РассчитатьИтоговыеПоказатели(ЭтотОбъект);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Элементы.БазоваяДата.ТолькоПросмотр = Форма.БазоваяДатаВСтроках;
	Элементы.БазоваяДата.АвтоОтметкаНезаполненного = НЕ Форма.БазоваяДатаВСтроках;
	
	Элементы.ТипСрока.ТолькоПросмотр = Форма.ТипСрокаВСтроках;
	Элементы.ТипСрока.АвтоОтметкаНезаполненного = НЕ Форма.ТипСрокаВСтроках;
	
	Элементы.Наименование.ТолькоПросмотр = Объект.Автонаименование;
	Элементы.Наименование.АвтоОтметкаНезаполненного = НЕ Объект.Автонаименование;

КонецПроцедуры

&НаКлиенте
Процедура БазоваяДатаВСтрокахПриИзменении(Элемент)
	
	Если БазоваяДатаВСтроках Тогда 
		
		БазоваяДата = ПредопределенноеЗначение("Справочник.АлгоритмыОпределенияБазовойДаты.ПустаяСсылка");
		
	ИначеЕсли Объект.ЭтапыОплаты.Количество() Тогда 
		
		БазоваяДата = Объект.ЭтапыОплаты[0].БазоваяДата;
		
		Для Каждого ТекСтр Из Объект.ЭтапыОплаты Цикл 
			ТекСтр.БазоваяДата = БазоваяДата;
		КонецЦикла;

	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипСрокаВСтрокахПриИзменении(Элемент)
	
	Если ТипСрокаВСтроках Тогда 
		
		ТипСрока = ПредопределенноеЗначение("Перечисление.СпособыРасчетаКоличестваДнейВПериоде.ПустаяСсылка");
		
	ИначеЕсли Объект.ЭтапыОплаты.Количество() Тогда 
		
		ТипСрока = Объект.ЭтапыОплаты[0].ТипСрока;
		
		Для Каждого ТекСтр Из Объект.ЭтапыОплаты Цикл 
			ТекСтр.ТипСрока = ТипСрока;
		КонецЦикла;

	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//СтрокаРеквизитовЗаполнения = "";
	//Если НЕ БазоваяДатаВСтроках Тогда 
	//	СтрокаРеквизитовЗаполнения = СтрокаРеквизитовЗаполнения + ",БазоваяДата";
	//КонецЕсли;
	//
	//Если НЕ ТипСрокаВСтроках Тогда
	//	СтрокаРеквизитовЗаполнения = СтрокаРеквизитовЗаполнения + ",ТипСрока";
	//КонецЕсли;
	//
	//Если НЕ ПустаяСтрока(СтрокаРеквизитовЗаполнения) Тогда 
	//	
	//	Для Каждого ТекСтр Из ТекущийОбъект.ЭтапыОплаты Цикл
	//		ЗаполнитьЗначенияСвойств(ТекСтр, ЭтотОбъект, Сред(СтрокаРеквизитовЗаполнения, 2));
	//	КонецЦикла;
	//	
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АвтонаименованиеПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если ТипСрокаВСтроках Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ТипСрока");
	КонецЕсли;
	
	Если БазоваяДатаВСтроках Тогда
		МассивНепроверяемыхРеквизитов.Добавить("БазоваяДата");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура БазоваяДатаПриИзменении(Элемент)
	Для Каждого ТекСтр Из Объект.ЭтапыОплаты Цикл 
		ТекСтр.БазоваяДата = БазоваяДата;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ТипСрокаПриИзменении(Элемент)
	Для Каждого ТекСтр Из Объект.ЭтапыОплаты Цикл 
		ТекСтр.ТипСрока = ТипСрока;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОплатыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И НЕ Копирование Тогда
		ТекДанные = Элементы.ЭтапыОплаты.ТекущиеДанные;
		
		Если Не ТипСрокаВСтроках Тогда
			ТекДанные.ТипСрока = ТипСрока;
		КонецЕсли;
		
		Если Не БазоваяДатаВСтроках Тогда 
			ТекДанные.БазоваяДата = БазоваяДата;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
