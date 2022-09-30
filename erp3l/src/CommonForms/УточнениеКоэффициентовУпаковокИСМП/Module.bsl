#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Объект = Новый Структура("Номер, Дата", "", ТекущаяДатаСеанса());
	ПараметрыУказанияСерий = ИнтеграцияИС.ПараметрыУказанияСерийФормыОбъекта(Объект, Документы.МаркировкаТоваровИСМП);
	
	ВходящаяТаблицаОписаниеGTIN = ПолучитьИзВременногоХранилища(Параметры.АдресУточнениеКоэффициентовУпаковок);
	
	ТолькоПотребительскиеУпаковки = Истина;
	
	НомерСтроки = 0;
	Для Каждого СтрокаДанных Из ВходящаяТаблицаОписаниеGTIN Цикл
		
		НомерСтроки = НомерСтроки + 1;
		
		НоваяСтрока = ОписаниеGTIN.Добавить();
		НоваяСтрока.НомерСтроки = НомерСтроки;
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДанных);
		
		Если СтрокаДанных.ВидУпаковки = Перечисления.ВидыУпаковокИС.Потребительская
			И Не ЗначениеЗаполнено(СтрокаДанных.КоличествоПотребительскихУпаковок) Тогда
			НоваяСтрока.КоличествоПотребительскихУпаковок = 1;
		КонецЕсли;
		
		Если СтрокаДанных.ВидУпаковки <> Перечисления.ВидыУпаковокИС.Потребительская Тогда
			ТолькоПотребительскиеУпаковки = Ложь;
		КонецЕсли;
		
		Если Параметры.ДоступноРедактированиеВидаУпаковки Тогда
			НоваяСтрока.ДоступноРедактированиеВидаУпаковки = Истина;
		Иначе
			НоваяСтрока.ДоступноРедактированиеВидаУпаковки = Не ЗначениеЗаполнено(СтрокаДанных.ВидУпаковки);
		КонецЕсли;
		
		ВидПродукции = СтрокаДанных.ВидПродукции;
		
	КонецЦикла;
	
	Если ТолькоПотребительскиеУпаковки Тогда
		Элементы.ОписаниеGTINКоличествоПотребительскихУпаковок.Видимость = Ложь;
	КонецЕсли;
	
	Если ИнтеграцияИСПовтИсп.ЭтоПродукцияМОТП(ВидПродукции) Тогда
		
		Элементы.ОписаниеGTINКоличествоПотребительскихУпаковок.Заголовок = НСтр("ru = 'Количество пачек';
																				|en = 'Количество пачек'");
		Заголовок = НСтр("ru = 'Уточнение количества пачек в коробах и блоках по GTIN';
						|en = 'Уточнение количества пачек в коробах и блоках по GTIN'");
		
		Элементы.ОписаниеGTINВидУпаковки.СписокВыбора.Очистить();
		Элементы.ОписаниеGTINВидУпаковки.СписокВыбора.Добавить(Перечисления.ВидыУпаковокИС.Потребительская, НСтр("ru = 'Пачка';
																												|en = 'Пачка'"));
		Элементы.ОписаниеGTINВидУпаковки.СписокВыбора.Добавить(Перечисления.ВидыУпаковокИС.Групповая, НСтр("ru = 'Блок';
																											|en = 'Блок'"));
		Элементы.ОписаниеGTINВидУпаковки.СписокВыбора.Добавить(Перечисления.ВидыУпаковокИС.Логистическая, НСтр("ru = 'Короб';
																												|en = 'Короб'"));
		
	ИначеЕсли ВидПродукции = Перечисления.ВидыПродукцииИС.Духи Тогда
		
		Элементы.ОписаниеGTINКоличествоПотребительскихУпаковок.Заголовок = НСтр("ru = 'Количество флаконов';
																				|en = 'Количество флаконов'");
		Заголовок = НСтр("ru = 'Уточнение количества флаконов в логистических и групповых упаковках по GTIN';
						|en = 'Уточнение количества флаконов в логистических и групповых упаковках по GTIN'");
		
		Элементы.ОписаниеGTINВидУпаковки.СписокВыбора.Очистить();
		Элементы.ОписаниеGTINВидУпаковки.СписокВыбора.Добавить(Перечисления.ВидыУпаковокИС.Потребительская, НСтр("ru = 'Флакон';
																												|en = 'Флакон'"));
		Элементы.ОписаниеGTINВидУпаковки.СписокВыбора.Добавить(Перечисления.ВидыУпаковокИС.Групповая, НСтр("ru = 'Групповая';
																											|en = 'Групповая'"));
		Элементы.ОписаниеGTINВидУпаковки.СписокВыбора.Добавить(Перечисления.ВидыУпаковокИС.Логистическая, НСтр("ru = 'Логистическая';
																												|en = 'Логистическая'"));
		
	Иначе
		
		Элементы.ОписаниеGTINВидУпаковки.СписокВыбора.Очистить();
		Элементы.ОписаниеGTINВидУпаковки.СписокВыбора.Добавить(Перечисления.ВидыУпаковокИС.Потребительская, НСтр("ru = 'Потребительская';
																												|en = 'Потребительская'"));
		Элементы.ОписаниеGTINВидУпаковки.СписокВыбора.Добавить(Перечисления.ВидыУпаковокИС.Групповая, НСтр("ru = 'Групповая';
																											|en = 'Групповая'"));
		Элементы.ОписаниеGTINВидУпаковки.СписокВыбора.Добавить(Перечисления.ВидыУпаковокИС.Логистическая, НСтр("ru = 'Логистическая';
																												|en = 'Логистическая'"));
		
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,   "ОписаниеGTINХарактеристика", "Элементы.ОписаниеGTIN.ТекущиеДанные.Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,   "ОписаниеGTINУпаковка",       "Элементы.ОписаниеGTIN.ТекущиеДанные.Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,   "ОписаниеGTINСерия",          "Элементы.ОписаниеGTIN.ТекущиеДанные.Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСХарактеристикой(ЭтотОбъект, "ОписаниеGTINСерия",          "Элементы.ОписаниеGTIN.ТекущиеДанные.Характеристика");
	
	ИнтеграцияИСПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, ОписаниеGTIN);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормИСМПКлиентПереопределяемый.ОбработкаВыбораСерии(
		ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора, ПараметрыУказанияСерий);
	
	ИмяФормыУказанияСерии = "";
	ШтрихкодированиеИСКлиентПереопределяемый.ЗаполнитьПолноеИмяФормыУказанияСерии(ИмяФормыУказанияСерии);

	СобытияФормИСМПКлиентПереопределяемый.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеGTINВидУпаковкиПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОписаниеGTIN.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Потребительская") Тогда
		ТекущиеДанные.КоличествоПотребительскихУпаковок = 1;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОписаниеGTINНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОписаниеGTIN.ТекущиеДанные;
	СобытияФормИСМПКлиентПереопределяемый.ПриИзмененииНоменклатуры(
		ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения, ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеGTINНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СобытияФормИСКлиентПереопределяемый.ПриНачалеВыбораНоменклатуры(Элемент, ВидПродукции, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеGTINУпаковкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ОписаниеGTIN.ТекущиеДанные;
	СобытияФормИСКлиентПереопределяемый.ПриНачалеВыбораУпаковки(Элемент, ТекущиеДанные.Номенклатура, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеGTINХарактеристикаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОписаниеGTIN.ТекущиеДанные;
	СобытияФормИСМПКлиентПереопределяемый.ПриИзмененииХарактеристики(ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеGTINХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ОписаниеGTIN.ТекущиеДанные;
	СобытияФормИСМПКлиентПереопределяемый.ПриНачалеВыбораХарактеристики(
		Элемент, ТекущиеДанные, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеGTINСерияПриИзменении(Элемент)
	
	СобытияФормИСМПКлиентПереопределяемый.ПриИзмененииСерии(
		ЭтотОбъект, Элементы.ОписаниеGTIN.ТекущиеДанные, КэшированныеЗначения, ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеGTINСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияИСКлиент.ОткрытьПодборСерий(ЭтаФорма,, Элемент.ТекстРедактирования, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Отказ = Ложь;
	Для Каждого СтрокаТЧ Из ОписаниеGTIN Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТЧ.КоличествоПотребительскихУпаковок) Тогда
			
			Индекс = ОписаниеGTIN.Индекс(СтрокаТЧ) + 1;
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Не заполнено поле ""Количество потребительских упаковок""';
					|en = 'Не заполнено поле ""Количество потребительских упаковок""'"),,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОписаниеGTIN", Индекс, "КоличествоПотребительскихУпаковок"),,
				Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаТЧ.ВидУпаковки) Тогда
			
			Индекс = ОписаниеGTIN.Индекс(СтрокаТЧ) + 1;
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Не заполнено поле ""Вид упаковки""';
					|en = 'Не заполнено поле ""Вид упаковки""'"),,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОписаниеGTIN", Индекс, "ВидУпаковки"),,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = СохранитьДанные();
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть("УточненыКоэффициентыУпаковокИСМП");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтотОбъект, "ОписаниеGTINЕдиницаИзмерения", "ОписаниеGTIN.Упаковка");
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект, "ОписаниеGTINХарактеристика", "ОписаниеGTIN.ХарактеристикиИспользуются");
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтотОбъект, "ОписаниеGTINСерия", "ОписаниеGTIN.СтатусУказанияСерий", "ОписаниеGTIN.ТипНоменклатуры");
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОписаниеGTINНоменклатура.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ОписаниеGTIN.Номенклатура");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст",      Новый ПолеКомпоновкиДанных("ОписаниеGTIN.ПредставлениеСодержимоеУпаковки"));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОписаниеGTINВидУпаковки.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ОписаниеGTIN.ДоступноРедактированиеВидаУпаковки");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОписаниеGTINВидУпаковки.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ОписаниеGTIN.ВидУпаковки");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОписаниеGTINКоличествоПотребительскихУпаковок.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ОписаниеGTIN.ВидУпаковки");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыУпаковокИС.Потребительская;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	//
	
	СписокТабачнойПродукции = Новый СписокЗначений;
	СписокТабачнойПродукции.Добавить(Перечисления.ВидыПродукцииИС.Табак);
	СписокТабачнойПродукции.Добавить(Перечисления.ВидыПродукцииИС.АльтернативныйТабак);
	СписокТабачнойПродукции.Добавить(Перечисления.ВидыПродукцииИС.НикотиносодержащаяПродукция);
	
	СписокДухи = Новый СписокЗначений;
	СписокДухи.Добавить(Перечисления.ВидыПродукцииИС.Духи);
	
	ЭлементыОформления = Новый Массив;
	
	ЭлементОформления = Новый Структура;
	ЭлементОформления.Вставить("ВидыПродукции", Неопределено);
	ЭлементОформления.Вставить("ВидУпаковки",   Перечисления.ВидыУпаковокИС.Потребительская);
	ЭлементОформления.Вставить("Представление", НСтр("ru = 'Потребительская';
													|en = 'Потребительская'"));
	ЭлементыОформления.Добавить(ЭлементОформления);
	
	ЭлементОформления = Новый Структура;
	ЭлементОформления.Вставить("ВидыПродукции", Неопределено);
	ЭлементОформления.Вставить("ВидУпаковки",   Перечисления.ВидыУпаковокИС.Логистическая);
	ЭлементОформления.Вставить("Представление", НСтр("ru = 'Логистическая';
													|en = 'Логистическая'"));
	ЭлементыОформления.Добавить(ЭлементОформления);

	ЭлементОформления = Новый Структура;
	ЭлементОформления.Вставить("ВидыПродукции", Неопределено);
	ЭлементОформления.Вставить("ВидУпаковки",   Перечисления.ВидыУпаковокИС.Групповая);
	ЭлементОформления.Вставить("Представление", НСтр("ru = 'Групповая';
													|en = 'Групповая'"));
	ЭлементыОформления.Добавить(ЭлементОформления);
	
	ЭлементОформления = Новый Структура;
	ЭлементОформления.Вставить("ВидыПродукции", СписокДухи);
	ЭлементОформления.Вставить("ВидУпаковки",   Перечисления.ВидыУпаковокИС.Потребительская);
	ЭлементОформления.Вставить("Представление", НСтр("ru = 'Флакон';
													|en = 'Флакон'"));
	ЭлементыОформления.Добавить(ЭлементОформления);
	
	ЭлементОформления = Новый Структура;
	ЭлементОформления.Вставить("ВидыПродукции", СписокТабачнойПродукции);
	ЭлементОформления.Вставить("ВидУпаковки",   Перечисления.ВидыУпаковокИС.Потребительская);
	ЭлементОформления.Вставить("Представление", НСтр("ru = 'Пачка';
													|en = 'Пачка'"));
	ЭлементыОформления.Добавить(ЭлементОформления);
	
	ЭлементОформления = Новый Структура;
	ЭлементОформления.Вставить("ВидыПродукции", СписокТабачнойПродукции);
	ЭлементОформления.Вставить("ВидУпаковки",   Перечисления.ВидыУпаковокИС.Логистическая);
	ЭлементОформления.Вставить("Представление", НСтр("ru = 'Короб';
													|en = 'Короб'"));
	ЭлементыОформления.Добавить(ЭлементОформления);

	ЭлементОформления = Новый Структура;
	ЭлементОформления.Вставить("ВидыПродукции", СписокТабачнойПродукции);
	ЭлементОформления.Вставить("ВидУпаковки",   Перечисления.ВидыУпаковокИС.Групповая);
	ЭлементОформления.Вставить("Представление", НСтр("ru = 'Блок';
													|en = 'Блок'"));
	ЭлементыОформления.Добавить(ЭлементОформления);
	
	Для Каждого ЭлементОформления Из ЭлементыОформления Цикл
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОписаниеGTINВидУпаковки.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ОписаниеGTINВидУпаковки.ПутьКДанным);
		ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = ЭлементОформления.ВидУпаковки;
		
		Если ЭлементОформления.ВидыПродукции <> Неопределено Тогда
			ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ВидПродукции");
			ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
			ОтборЭлемента.ПравоеЗначение = ЭлементОформления.ВидыПродукции;
		КонецЕсли;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", ЭлементОформления.Представление);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СохранитьДанные()
	
	ТаблицаОписанияGTIN = ОписаниеGTIN.Выгрузить();
	
	Успешно = РегистрыСведений.ОписаниеGTINИС.УстановитьОписаниеПоТаблице(ТаблицаОписанияGTIN);
	
	ТаблицаРегистрацииGTIN = ТаблицаОписанияGTIN.СкопироватьКолонки();
	Для Каждого СтрокаТЧ Из ТаблицаОписанияGTIN Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Номенклатура) Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ТаблицаРегистрацииGTIN.Добавить(), СтрокаТЧ);
		
	КонецЦикла;
	
	ПроверкаИПодборПродукцииИСМППереопределяемый.ЗафиксироватьОписаниеGTIN(ТаблицаРегистрацииGTIN);
	
	Возврат Не Успешно;
	
КонецФункции

#КонецОбласти