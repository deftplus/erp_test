#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("ИдентификаторПакета", ИдентификаторПакета);
	Параметры.Свойство("ЭлектронныйДокумент", ЭлектронныйДокумент);
	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("Контрагент", Контрагент);
	Параметры.Свойство("Договор", Договор);
	
	Если Не ЗначениеЗаполнено(ИдентификаторПакета)
		И Не ЗначениеЗаполнено(ЭлектронныйДокумент) Тогда
			Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	Если ЗначениеЗаполнено(ИдентификаторПакета) Тогда
		ДокументыПакета = ЭлектронныеДокументыЭДО.ДокументыПакета(ИдентификаторПакета);
	Иначе
		ДокументыПакета = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ЭлектронныйДокумент);
	КонецЕсли;
	
	ДанныеОбъектовУчета = ИнтеграцияЭДО.ОбъектыУчетаЭлектронныхДокументов(ДокументыПакета);
	
	ДеревоОбъект = РеквизитФормыВЗначение("ДеревоДокументов", Тип("ДеревоЗначений"));
	
	Для Каждого СтрокаДанныхОбъектовУчета Из ДанныеОбъектовУчета Цикл
		
		ДобавитьДокументВКореньДерева(ДеревоОбъект, СтрокаДанныхОбъектовУчета.ОбъектУчета);
		
		СвязанныеДокументы = ОбъектыПоКритериюОтбора(СтрокаДанныхОбъектовУчета.ОбъектУчета);

		Для Каждого СвязанныйДокумент Из СвязанныеДокументы Цикл

			ДобавитьДокументВКореньДерева(ДеревоОбъект, СвязанныйДокумент);

		КонецЦикла;
	
	КонецЦикла;

	ЗначениеВРеквизитФормы(ДеревоОбъект, "ДеревоДокументов");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)

	ПодготовитьДанныеДляФормированияДокументовПоОбъектамУчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ВыбраннаяСтрока) Тогда
		СтрокаДерева = ДеревоДокументов.НайтиПоИдентификатору(ВыбраннаяСтрока);
		
		Если ЗначениеЗаполнено(СтрокаДерева.ВидФормирования) Тогда
			ПодготовитьДанныеДляФормированияДокументовПоОбъектамУчета();
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УсловноеОформление

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ОформлениеПоляДокумент();
	ОформлениеПоляПредставлениеДокумента();
	ОформлениеПоляКартинка();	
	ОформлениеПоляПиктограммаФайла();
	ОформлениеЦветаТекстаГрупп();
	
КонецПроцедуры

&НаСервере
Процедура ОформлениеПоляПиктограммаФайла()
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоДокументовПиктограммаФайла.Имя);

	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоДокументов.ПиктограммаФайла");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ОформлениеПоляДокумент()
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоДокументовДокумент.Имя);
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоДокументов.ПредставлениеДокумента");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);	
	
КонецПроцедуры

&НаСервере
Процедура ОформлениеПоляКартинка()	
		
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоДокументовКартинка.Имя);
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоДокументов.Картинка");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);	
	
КонецПроцедуры

&НаСервере
Процедура ОформлениеПоляПредставлениеДокумента()	
		
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоДокументовПредставлениеДокумента.Имя);

	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоДокументов.ПредставлениеДокумента");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);	
	
КонецПроцедуры

&НаСервере
Процедура ОформлениеЦветаТекстаГрупп()
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоДокументовПредставлениеДокумента.Имя);
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоДокументовДокумент.Имя);

	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоДокументов.ЭтоГруппа");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ОсновнойЭлементСписка);

КонецПроцедуры

#КонецОбласти

#Область ПредопределенныеЗначения

&НаКлиентеНаСервереБезКонтекста
Функция ВидФормирования_ПоПечатнойФорме() 
	Возврат "ПоПечатнойФорме";
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВидФормирования_ПоПрисоединенномуФайлу() 
	Возврат "ПоПрисоединенномуФайлу";
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВидФормирования_ПоОбъектуУчета() 
	Возврат "ПоОбъектуУчета";
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВидФормирования_ПоОбъектуУчетаСуществующий() 
	Возврат "ПоОбъектуУчетаСуществующий";
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВидФормирования_Группировка() 
	Возврат "Группировка";
КонецФункции

#КонецОбласти

#Область ФормированиеДерева

&НаСервере
Процедура ДобавитьДокументВКореньДерева(ДеревоОбъект, ОбъектУчета)

	Если ДеревоОбъект.Строки.Найти(ОбъектУчета, "ОбъектУчета") <> Неопределено Тогда
		Возврат;
	КонецЕсли;

	ВетвьДокумента = ДеревоОбъект.Строки.Добавить();
	ВетвьДокумента.ОбъектУчета = ОбъектУчета;
	ВетвьДокумента.ЭтоГруппа = Истина;
			
	ЗаполнитьВариантыФормированияДокументовОбъекта(ВетвьДокумента);
	
	Если ВетвьДокумента.Строки.Количество() = 0 Тогда
		ДеревоОбъект.Строки.Удалить(ВетвьДокумента);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВариантыФормированияДокументовОбъекта(СтрокаДерева)
	
	ДобавитьДанныеФормированияПоОбъектуУчета(СтрокаДерева);
	ДобавитьДанныеФормированияИзПечатныхФорм(СтрокаДерева);
	ДобавитьДанныеФормированияИзПрисоединенныхФайлов(СтрокаДерева);
		
КонецПроцедуры

&НаСервере
Процедура ДобавитьДанныеФормированияПоОбъектуУчета(СтрокаДерева)
		
	ОбъектУчета = СтрокаДерева.ОбъектУчета;	
	ОписаниеОбъектаУчета = ИнтеграцияЭДО.ОписаниеОбъектаУчета(ОбъектУчета);
	
	Для каждого СтрокаОписания Из ОписаниеОбъектаУчета Цикл
	
		Если СтрокаОписания.Направление = Перечисления.НаправленияЭДО.Исходящий Тогда
			
			Если СтрокаОписания.ТипДокумента = Перечисления.ТипыДокументовЭДО.Прикладной Тогда
				ВидДокумента = ЭлектронныеДокументыЭДО.ВидДокументаПоПрикладномуТипу(СтрокаОписания.ПрикладнойТипДокумента);
			Иначе
				ВидДокумента = ЭлектронныеДокументыЭДО.ВидДокументаПоТипу(СтрокаОписания.ТипДокумента);
			КонецЕсли;
			
			АктуальныйДокумент = ИнтеграцияЭДО.АктуальныйЭлектронныйДокументОбъектаУчета(ОбъектУчета, ВидДокумента,
				СтрокаОписания.Контрагент, СтрокаОписания.Договор);
			
			Если ЗначениеЗаполнено(АктуальныйДокумент) Тогда
				
				СвойстваДокумента = ЭлектронныеДокументыЭДО.СвойстваДокумента(АктуальныйДокумент, "НомерДокумента, ДатаДокумента");
				
				СвойстваПредставления = ЭлектронныеДокументыЭДО.НовыеСвойстваПредставленияДокумента();
				СвойстваПредставления.ВидДокумента = ВидДокумента;
				СвойстваПредставления.НомерДокумента = СвойстваДокумента.НомерДокумента;
				СвойстваПредставления.ДатаДокумента = СвойстваДокумента.ДатаДокумента;
				
				ПредставлениеДокумента = ЭлектронныеДокументыЭДО.ПредставлениеДокументаПоСвойствам(СвойстваПредставления);
				ДобавитьСтрокуВДерево(СтрокаДерева, ОбъектУчета, ПредставлениеДокумента, ВидФормирования_ПоОбъектуУчетаСуществующий(),
					БиблиотекаКартинок.Документ,, АктуальныйДокумент);
			Иначе
				ДобавитьСтрокуВДерево(СтрокаДерева, ОбъектУчета, СтрокаОписания.ТипДокумента, ВидФормирования_ПоОбъектуУчета(),
					БиблиотекаКартинок.Документ);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьДанныеФормированияИзПечатныхФорм(СтрокаДерева)
	
	ОбъектУчета = СтрокаДерева.ОбъектУчета;
	ДоступныеКомандыПечати = ОбщегоНазначения.ТаблицаЗначенийВМассив(ИнтеграцияЭДО.КомандыПечатиДляВнутреннегоЭДО(
		ОбъектУчета.Метаданные()));

	Если ДоступныеКомандыПечати.Количество() = 0 Тогда
		
		Возврат;
		
	ИначеЕсли ДоступныеКомандыПечати.Количество() = 1 Тогда
		
		ДобавитьСтрокуВДерево(СтрокаДерева, ОбъектУчета, ДоступныеКомандыПечати[0].Представление, ВидФормирования_ПоПечатнойФорме(),
			БиблиотекаКартинок.Печать,, ДоступныеКомандыПечати[0]);
			
	Иначе
		
		ПредставлениеГруппы = СтрШаблон(НСтр("ru = 'Печатные формы (%1)';
											|en = 'Print forms (%1)'"), Строка(ДоступныеКомандыПечати.Количество()));
		СтрокаГруппы = ДобавитьСтрокуВДерево(СтрокаДерева, ОбъектУчета, ПредставлениеГруппы, ВидФормирования_Группировка(),
			БиблиотекаКартинок.Печать, Истина);
			
		Для Каждого КомандаПечати Из ДоступныеКомандыПечати Цикл
			ДобавитьСтрокуВДерево(СтрокаГруппы, ОбъектУчета, КомандаПечати.Представление, ВидФормирования_ПоПечатнойФорме(),
				Неопределено,, КомандаПечати);
				
		КонецЦикла;
					
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьДанныеФормированияИзПрисоединенныхФайлов(СтрокаДерева)
	
	ОбъектУчета = СтрокаДерева.ОбъектУчета;	
	ДоступныеФайлы = Новый Массив;
	
	РаботаСФайлами.ЗаполнитьПрисоединенныеФайлыКОбъекту(ОбъектУчета, ДоступныеФайлы); 
	
	Если ДоступныеФайлы.Количество() = 0 Тогда
		
		Возврат;
		
	ИначеЕсли ДоступныеФайлы.Количество() = 1 Тогда
		
		ДанныеФайла = РаботаСФайлами.ДанныеФайла(ДоступныеФайлы[0]);
		ИндексКартинки = ИнтеграцияБСПБЭД.ИндексПиктограммыФайла(ДанныеФайла.Расширение);
		
		ДобавитьСтрокуВДерево(СтрокаДерева, ОбъектУчета, ДанныеФайла.Наименование, ВидФормирования_ПоПрисоединенномуФайлу(),
			ИндексКартинки,, ДоступныеФайлы[0]);
			
	Иначе

		ПредставлениеГруппы = СтрШаблон(НСтр("ru = 'Файлы (%1)';
											|en = 'Files (%1)'"), Строка(ДоступныеФайлы.Количество()));
		СтрокаГруппы = ДобавитьСтрокуВДерево(СтрокаДерева, ОбъектУчета, ПредставлениеГруппы,
			ВидФормирования_Группировка(), 2, Истина);

		Для Каждого ДоступныйФайл Из ДоступныеФайлы Цикл

			ДанныеФайла = РаботаСФайлами.ДанныеФайла(ДоступныйФайл);
			ИндексКартинки = ИнтеграцияБСПБЭД.ИндексПиктограммыФайла(ДанныеФайла.Расширение);

			ДобавитьСтрокуВДерево(СтрокаГруппы, ОбъектУчета, ДанныеФайла.Наименование,
				ВидФормирования_ПоПрисоединенномуФайлу(), ИндексКартинки,, ДоступныйФайл);

		КонецЦикла;
					
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДобавитьСтрокуВДерево(СтрокаДерева, ОбъектУчета, ПредставлениеДокумента, ВидФормирования, Картинка,
	ЭтоГруппа = Ложь, АктуальныйДокумент = Неопределено)

	СтрокаВидаДокумента = СтрокаДерева.Строки.Добавить();
	СтрокаВидаДокумента.ОбъектУчета = ОбъектУчета;
	СтрокаВидаДокумента.ВидФормирования = ВидФормирования;
	
	Если ТипЗнч(Картинка) = Тип("Число") Тогда
		СтрокаВидаДокумента.ПиктограммаФайла = Картинка;
	Иначе
		СтрокаВидаДокумента.Картинка = Картинка;
	КонецЕсли;

	СтрокаВидаДокумента.ПредставлениеДокумента = ПредставлениеДокумента;
	СтрокаВидаДокумента.ЭтоГруппа = ЭтоГруппа;
	СтрокаВидаДокумента.ДанныеФормирования = АктуальныйДокумент;
	
	Возврат СтрокаВидаДокумента;
	
КонецФункции

#КонецОбласти

&НаСервере
Функция ОбъектыПоКритериюОтбора(ЗначениеКритерияОтбора)
	
	Если Не Метаданные.КритерииОтбора.СвязанныеДокументы.Тип.СодержитТип(ТипЗнч(ЗначениеКритерияОтбора))  Тогда
		Возврат Новый Массив;
	КонецЕсли;
		
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СвязанныеДокументы.Ссылка
	|ИЗ
	|	КритерийОтбора.СвязанныеДокументы(&ЗначениеКритерияОтбора) КАК СвязанныеДокументы
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(СвязанныеДокументы.Ссылка) В (&ТипыДокументов)";
	
	ТипыДокументов = ИнтеграцияЭДО.ОписаниеТиповОснованийЭлектронныхДокументов().Типы();
	Запрос.УстановитьПараметр("ЗначениеКритерияОтбора", ЗначениеКритерияОтбора);
	Запрос.УстановитьПараметр("ТипыДокументов", ТипыДокументов);
	ПодчиненныеОбъекты =  Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	РодительскиеОбъекты = Новый Массив;
	
	ЗаполнитьРодительскиеОбъекты(ЗначениеКритерияОтбора, РодительскиеОбъекты,, ТипыДокументов);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПодчиненныеОбъекты, РодительскиеОбъекты);
	
	Возврат ПодчиненныеОбъекты;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьРодительскиеОбъекты(ТекущийОбъект, РодительскиеОбъекты, СлужебныеОбъекты = Неопределено, ТипыДокументов = Неопределено)
	
	МетаданныеОбъекта = ТекущийОбъект.Метаданные();
	СписокРеквизитов  = Новый СписокЗначений;
	
	Если СлужебныеОбъекты = Неопределено Тогда 
		СлужебныеОбъекты = Новый Соответствие;
	КонецЕсли;
	
	Для Каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл
		
		Если Не Метаданные.КритерииОтбора.СвязанныеДокументы.Состав.Содержит(Реквизит) Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ТекущийТип Из Реквизит.Тип.Типы() Цикл
			
			МетаданныеРеквизита = Метаданные.НайтиПоТипу(ТекущийТип);
			Если МетаданныеРеквизита = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если Не ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(МетаданныеРеквизита) 
				Или Не ПравоДоступа("Чтение", МетаданныеРеквизита)
				Или Не ИнтеграцияЭДО.ОписаниеТиповОснованийЭлектронныхДокументов().СодержитТип(ТекущийТип) Тогда
				Продолжить;
			КонецЕсли;
			
			Если Не Метаданные.Документы.Содержит(МетаданныеРеквизита)
				И Не Метаданные.Справочники.Содержит(МетаданныеРеквизита)
				И Не Метаданные.ПланыВидовХарактеристик.Содержит(МетаданныеРеквизита) Тогда
				Продолжить;
			КонецЕсли;
			
			ЗначениеРеквизита = ТекущийОбъект[Реквизит.Имя];
			Если ЗначениеЗаполнено(ЗначениеРеквизита)
				И ТипЗнч(ЗначениеРеквизита) = ТекущийТип
				И ЗначениеРеквизита <> ТекущийОбъект
				И СписокРеквизитов.НайтиПоЗначению(ЗначениеРеквизита) = Неопределено Тогда
				
				ЯвляетсяДокументом  = ОбщегоНазначения.ЭтоДокумент(МетаданныеРеквизита);
				
				Если ЯвляетсяДокументом Тогда
					ДатаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначениеРеквизита, "Дата", Истина);
					СписокРеквизитов.Добавить(ЗначениеРеквизита, Формат(ДатаДокумента, "ДЛФ=DT"));
				Иначе
					СписокРеквизитов.Добавить(ЗначениеРеквизита, Дата(1,1,1));
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	Для Каждого ТЧ Из МетаданныеОбъекта.ТабличныеЧасти Цикл
		
		ИменаРеквизитов = "";
		СодержимоеТЧ = ТекущийОбъект[ТЧ.Имя].Выгрузить(); // ТаблицаЗначений
		Для Каждого Реквизит Из ТЧ.Реквизиты Цикл

			Если Не Метаданные.КритерииОтбора.СвязанныеДокументы.Состав.Содержит(Реквизит) Тогда
				Продолжить;
			КонецЕсли;
				
			Для Каждого ТекущийТип Из Реквизит.Тип.Типы() Цикл
				
				МетаданныеРеквизита = Метаданные.НайтиПоТипу(ТекущийТип);
				Если МетаданныеРеквизита = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				Если Не ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(МетаданныеРеквизита) 
					Или Не ПравоДоступа("Чтение", МетаданныеРеквизита)
					Или Не ИнтеграцияЭДО.ОписаниеТиповОснованийЭлектронныхДокументов().СодержитТип(ТекущийТип) Тогда
					Продолжить;
				КонецЕсли;
				
				Если Не Метаданные.Документы.Содержит(МетаданныеРеквизита)
					И Не Метаданные.Справочники.Содержит(МетаданныеРеквизита)
					И Не Метаданные.ПланыВидовХарактеристик.Содержит(МетаданныеРеквизита) Тогда
					Продолжить;
				КонецЕсли;
				
				ИменаРеквизитов = ИменаРеквизитов + ?(ИменаРеквизитов = "", "", ", ") + Реквизит.Имя;
				Прервать;
				
			КонецЦикла;
			
		КонецЦикла;
		
		СодержимоеТЧ.Свернуть(ИменаРеквизитов);
		Для Каждого КолонкаТЧ Из СодержимоеТЧ.Колонки Цикл
			
			Для Каждого СтрокаТЧ Из СодержимоеТЧ Цикл
			
				ЗначениеРеквизита = СтрокаТЧ[КолонкаТЧ.Имя];
				МетаданныеЗначения = Метаданные.НайтиПоТипу(ТипЗнч(ЗначениеРеквизита));
				Если МетаданныеЗначения = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				Если Не ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(МетаданныеЗначения) 
					Или Не ПравоДоступа("Чтение", МетаданныеЗначения) Тогда
					Продолжить;
				КонецЕсли;
				
				Если ЗначениеРеквизита = ТекущийОбъект
					Или СписокРеквизитов.НайтиПоЗначению(ЗначениеРеквизита) <> Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				ЯвляетсяДокументом  = ОбщегоНазначения.ЭтоДокумент(МетаданныеЗначения);
				Если Не ЯвляетсяДокументом И Не Метаданные.Справочники.Содержит(МетаданныеЗначения)
					И Не Метаданные.ПланыВидовХарактеристик.Содержит(МетаданныеЗначения) Тогда
					Продолжить;
				КонецЕсли;
				
				Если Не ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
					Продолжить;
				КонецЕсли;
				
				Если ЯвляетсяДокументом Тогда
					ДатаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначениеРеквизита, "Дата", Истина);
					СписокРеквизитов.Добавить(ЗначениеРеквизита, Формат(ДатаДокумента, "ДЛФ=DT"));
				Иначе
					СписокРеквизитов.Добавить(ЗначениеРеквизита, Дата(1, 1, 1));
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	СписокРеквизитов.СортироватьПоПредставлению();
	
	Для каждого ЭлементСписка Из СписокРеквизитов Цикл
		// Если элемент не подходит по типу данных, то не учитываем его.		
		Если ЗначениеЗаполнено(ТипыДокументов)
			И ТипЗнч(ТипыДокументов) = Тип("Массив")  
			И ТипыДокументов.Найти(ТипЗнч(ЭлементСписка.Значение)) = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		Если РодительскиеОбъекты.Найти(ЭлементСписка.Значение) = Неопределено Тогда
			
			РодительскиеОбъекты.Добавить(ЭлементСписка.Значение);
			ЗаполнитьРодительскиеОбъекты(ЭлементСписка.Значение, РодительскиеОбъекты, СлужебныеОбъекты, ТипыДокументов);
				
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура ПодготовитьДанныеДляФормированияДокументовПоОбъектамУчета()

	ОбъектыУчета = Новый Массив;
	
	СтрокаДерева = Элементы.ДеревоДокументов.ТекущиеДанные;			
	
	Если СтрокаДерева = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Если СтрокаДерева.ЭтоГруппа Тогда
		ТекстСообщения  = НСтр("ru = 'Выбрана строка группировки.
		|Для добавления в пакет необходимо выбрать конкретный документ.';
		|en = 'A grouping line is selected.
		|To add to the batch, select a specific document.'");
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
			
	Если СтрокаДерева.ВидФормирования = ВидФормирования_ПоОбъектуУчета() Тогда
				
		ОбъектыУчета.Добавить(СтрокаДерева.ОбъектУчета);
		
		РезультатПроверки = ИнтеграцияЭДОВызовСервера.ПроверкаГотовностиКДокументообороту(ОбъектыУчета);
		
		Если Не ЗначениеЗаполнено(РезультатПроверки.Готовые) Тогда
			Возврат;	
		КонецЕсли;		
		
		НаборДействий = Новый Соответствие;	
		ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(НаборДействий, ПредопределенноеЗначение(
			"Перечисление.ДействияПоЭДО.Сформировать"));
		
		ОповещениеУспешногоЗавершения = Новый ОписаниеОповещения("ОповещениеЗавершенияФормированияПоОбъектамУчета",
			ЭтотОбъект, ОбъектыУчета);
			
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("ОбъектыУчета", ОбъектыУчета);
		ПараметрыОповещения.Вставить("ОповещениеУспешногоЗавершения", ОповещениеУспешногоЗавершения);
		
		Оповещение = Новый ОписаниеОповещения("ПослеВыполненияДействийПоЭДО", ИнтерфейсДокументовЭДОКлиент, ПараметрыОповещения);
		
		ПараметрыВыполненияДействийПоЭДО = ЭлектронныеДокументыЭДОКлиентСервер.НовыеПараметрыВыполненияДействийПоЭДО();
		ПараметрыВыполненияДействийПоЭДО.НаборДействий = НаборДействий;
		ПараметрыВыполненияДействийПоЭДО.ОбъектыДействий.ОбъектыУчета = ОбъектыУчета;
	
		ЭлектронныеДокументыЭДОКлиент.НачатьВыполнениеДействийПоЭДО(Оповещение, ПараметрыВыполненияДействийПоЭДО);
					
	ИначеЕсли СтрокаДерева.ВидФормирования = ВидФормирования_ПоОбъектуУчетаСуществующий() Тогда
		
		Если СтрокаДерева.ДанныеФормирования = ЭлектронныйДокумент И Не ЗначениеЗаполнено(ИдентификаторПакета) Тогда
			Возврат;
		КонецЕсли;
		
		ДобавитьДокументВПакет(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СтрокаДерева.ДанныеФормирования));
		
	Иначе

		Оповещение = Новый ОписаниеОповещения("ВводРеквизитовПроизвольногоДокументаЗавершение", ЭтотОбъект);

		ИнтерфейсДокументовЭДОКлиент.ОткрытьВводРеквизитовПроизвольногоДокумента(Оповещение, ЭтотОбъект,
			Неопределено, СтрокаДерева.ОбъектУчета);

	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеЗавершенияФормированияПоОбъектамУчета(Результат, ОбъектыУчета) Экспорт

	Результат = ДобавитьДокументыОбъектовУчетаВПакет(ОбъектыУчета);

	Если Результат.Успех И ЗначениеЗаполнено(Результат.ДобавленныеДокументы) Тогда
		Оповестить("ДобавлениеДокументаВПакет", Результат.ДобавленныеДокументы, ИдентификаторПакета);
		Закрыть();
	Иначе
		ИнтерфейсДокументовЭДОКлиент.ПоказатьПредставлениеОшибокКонтекстаДиагностики(Результат.КонтекстДиагностики);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВводРеквизитовПроизвольногоДокументаЗавершение(РеквизитыДокумента, ДополнительныеПараметры = Неопределено) Экспорт

	Если Не ЗначениеЗаполнено(РеквизитыДокумента) Тогда
		Возврат;
	КонецЕсли;
	
	ДобавленныеДокументы = Новый Массив;

	СтрокаДерева = Элементы.ДеревоДокументов.ТекущиеДанные;

	Если Не ЗначениеЗаполнено(СтрокаДерева.ВидФормирования) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДополнительныеПараметры) Тогда
		ПодписантыОбъектов = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеПараметры,
			"ПодписантыОбъектов", Новый Соответствие);
	Иначе
		ПодписантыОбъектов = Новый Соответствие;
	КонецЕсли;
	
	ОшибкиФормирования = Новый Массив;

	Если СтрокаДерева.ВидФормирования = ВидФормирования_ПоПечатнойФорме() Тогда
		РезультатПечати = ИнтерфейсДокументовЭДОВызовСервера.ПечатныеФормыДокументов(СтрокаДерева.ДанныеФормирования,
			СтрокаДерева.ОбъектУчета, ТипФайлаТабличногоДокумента.PDF);

		Если РезультатПечати = Неопределено Тогда
			Возврат;
		КонецЕсли;

		Для Каждого ПечатныйДокумент Из РезультатПечати Цикл

			ПараметрыФайла = Новый Структура;
			ПараметрыФайла.Вставить("ИмяФайла", ПечатныйДокумент.ИмяФайла);
			ПараметрыФайла.Вставить("АдресХранилища", ПоместитьВоВременноеХранилище(
						ПечатныйДокумент.ДвоичныеДанные, УникальныйИдентификатор));

			ПараметрыФормирования = Новый Структура;

			ПараметрыФормирования.Вставить("Организация", Организация);
			ПараметрыФормирования.Вставить("Контрагент", Контрагент);
			ПараметрыФормирования.Вставить("Договор", Договор);
			ПараметрыФормирования.Вставить("ОбъектыУчета", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
					СтрокаДерева.ОбъектУчета));
					
			ПараметрыФормирования.Вставить("НомерДокумента", РеквизитыДокумента.Номер);
			ПараметрыФормирования.Вставить("ДатаДокумента", РеквизитыДокумента.Дата);
			ПараметрыФормирования.Вставить("СуммаДокумента", РеквизитыДокумента.Сумма);
			Если ЗначениеЗаполнено(РеквизитыДокумента.ВидДокумента) Тогда
				ПараметрыФормирования.Вставить("ВидДокумента", РеквизитыДокумента.ВидДокумента);
			КонецЕсли;
			Подписанты = ПодписантыОбъектов[СтрокаДерева.ОбъектУчета];
			Если ЗначениеЗаполнено(Подписанты) Тогда
				ПараметрыФормирования.Вставить("Подписанты", Подписанты);
			КонецЕсли;
			
			Результат = ИнтерфейсДокументовЭДОВызовСервера.СоздатьЭлектронныйДокументПоФайлу(ПараметрыФормирования, ПараметрыФайла);
			Если Результат.Успех Тогда
				ДобавленныеДокументы.Добавить(Результат.ЭлектронныйДокумент);
			Иначе
				ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ОшибкиФормирования, Результат.Ошибки);
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли СтрокаДерева.ВидФормирования = ВидФормирования_ПоПрисоединенномуФайлу() Тогда
		
		ДанныеФайла = РаботаСФайламиКлиент.ДанныеФайла(СтрокаДерева.ДанныеФормирования, УникальныйИдентификатор, Истина);
		
		ПараметрыФайла = Новый Структура;
		ПараметрыФайла.Вставить("ИмяФайла", ДанныеФайла.ИмяФайла);
		ПараметрыФайла.Вставить("АдресХранилища", ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
		
		ПараметрыФормирования = Новый Структура;
		
		ПараметрыФормирования.Вставить("Организация", Организация);
		ПараметрыФормирования.Вставить("Контрагент", Контрагент);
		ПараметрыФормирования.Вставить("Договор", Договор);
		ПараметрыФормирования.Вставить("ОбъектыУчета", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
				СтрокаДерева.ОбъектУчета));
		
		ПараметрыФормирования.Вставить("НомерДокумента", РеквизитыДокумента.Номер);
		ПараметрыФормирования.Вставить("ДатаДокумента", РеквизитыДокумента.Дата);
		ПараметрыФормирования.Вставить("СуммаДокумента", РеквизитыДокумента.Сумма);
		
		Если ЗначениеЗаполнено(РеквизитыДокумента.ВидДокумента) Тогда
			ПараметрыФормирования.Вставить("ВидДокумента", РеквизитыДокумента.ВидДокумента);
		КонецЕсли;
		
		Подписанты = ПодписантыОбъектов[СтрокаДерева.ОбъектУчета];
		Если ЗначениеЗаполнено(Подписанты) Тогда
			ПараметрыФормирования.Вставить("Подписанты", Подписанты);
		КонецЕсли;
		
		Результат = ИнтерфейсДокументовЭДОВызовСервера.СоздатьЭлектронныйДокументПоФайлу(ПараметрыФормирования,ПараметрыФайла);
		Если Результат.Успех Тогда
			ДобавленныеДокументы.Добавить(Результат.ЭлектронныйДокумент);
		Иначе
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ОшибкиФормирования, Результат.Ошибки);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОшибкиФормирования) Тогда
		Оповещение = Новый ОписаниеОповещения("ВводРеквизитовПроизвольногоДокументаЗавершение", ЭтотОбъект, РеквизитыДокумента);
		ИнтерфейсДокументовЭДОКлиент.НачатьОбработкуОшибокФормированияДокумента(Оповещение, ОшибкиФормирования);
		Возврат;
	КонецЕсли;
	
	ДобавитьДокументВПакет(ДобавленныеДокументы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьДокументВПакетПослеОбработкуОшибокФормирования(Результат, РеквизитыДокумента) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВводРеквизитовПроизвольногоДокументаЗавершение(РеквизитыДокумента, Результат.ПараметрыВыполненияДействийПоЭДО);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьДокументВПакет(ДобавленныеДокументы)

	КонтекстДиагностики = ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики();

	Если ЗначениеЗаполнено(ИдентификаторПакета) Тогда
		
		Для Каждого Документ Из ДобавленныеДокументы Цикл
			Успех = ИнтерфейсДокументовЭДОВызовСервера.ДобавитьДокументВПакет(ИдентификаторПакета, Документ, КонтекстДиагностики);
		КонецЦикла;
		
	Иначе

		ДобавленныеДокументы.Добавить(ЭлектронныйДокумент);
		ИдентификаторПакета = ИнтерфейсДокументовЭДОВызовСервера.СоздатьПакетДокументов(ДобавленныеДокументы, КонтекстДиагностики);
		Успех = ЗначениеЗаполнено(ИдентификаторПакета);
		
	КонецЕсли;
	
	Если Успех И ЗначениеЗаполнено(ДобавленныеДокументы) Тогда
		Оповестить("ДобавлениеДокументаВПакет", ДобавленныеДокументы, ИдентификаторПакета);
		Закрыть();
	Иначе
		ИнтерфейсДокументовЭДОКлиент.ПоказатьПредставлениеОшибокКонтекстаДиагностики(КонтекстДиагностики);
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Функция ДобавитьДокументыОбъектовУчетаВПакет(ОбъектыУчета)

	ДобавленныеДокументы = Новый Массив;
	КонтекстДиагностики = ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики();
	Успех = Ложь;

	Если ЗначениеЗаполнено(ОбъектыУчета) Тогда
		ДокументыОбъектовУчета = ИнтеграцияЭДО.АктуальныеЭлектронныеДокументы(ОбъектыУчета).ВыгрузитьКолонку(
			"ЭлектронныйДокумент");

		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ДобавленныеДокументы, ДокументыОбъектовУчета);
	КонецЕсли;

	Если ЗначениеЗаполнено(ИдентификаторПакета) Тогда
		Для Каждого Документ Из ДобавленныеДокументы Цикл
			Успех = ЭлектронныеДокументыЭДО.ДобавитьДокументВПакет(ИдентификаторПакета, Документ);
		КонецЦикла;

	Иначе

		ДобавленныеДокументы.Добавить(ЭлектронныйДокумент);
		ИдентификаторПакета = ЭлектронныеДокументыЭДО.СоздатьПакетДокументов(ДобавленныеДокументы, КонтекстДиагностики);
		Успех = ЗначениеЗаполнено(ИдентификаторПакета);
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ДобавленныеДокументы", ДобавленныеДокументы);
	Результат.Вставить("КонтекстДиагностики", КонтекстДиагностики);
	Результат.Вставить("Успех", Успех);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьДругойДокумент(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПослеВыбораВидаДокумента", ЭтотОбъект);
	ПолучитьТипыДокументов().ПоказатьВыборЭлемента(Оповещение, НСтр("ru = 'Выберите вид документа';
																	|en = 'Select a document kind'"));

КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораВидаДокумента(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;	
	КонецЕсли;	
	
	Настройки = НастройкиПодбораУчетногоДокумента(Результат.Значение);
	Настройки.Вставить("Организация", Организация);
	Настройки.Вставить("Контрагент" , Контрагент);
	
	Если Настройки <> Неопределено Тогда
		
		Настройки.Вставить("Организация", Организация);
		Настройки.Вставить("Контрагент" , Контрагент);
		Оповещение = Новый ОписаниеОповещения("ПослеВыбораДокумента", ЭтотОбъект);
		ИнтерфейсДокументовЭДОКлиент.ПоказатьПодборУчетногоДокумента(Настройки, Оповещение);
		
	КонецЕсли;

КонецПроцедуры 

&НаСервереБезКонтекста
Функция НастройкиПодбораУчетногоДокумента(ИмяТипа)
	
	Настройки = Новый Структура;
	
	МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ИмяТипа);
	
	Если ОбщегоНазначения.ЭтоСправочник(МетаданныеОбъекта) Тогда
		
		Настройки.Вставить("ИмяОбъектаМетаданных", МетаданныеОбъекта.ПолноеИмя());
		Настройки.Вставить("ИмяТипаСсылки", "СправочникСсылка." + МетаданныеОбъекта.Имя);
		
	ИначеЕсли ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта) Тогда
		
		Настройки.Вставить("ИмяОбъектаМетаданных", МетаданныеОбъекта.ПолноеИмя());
		Настройки.Вставить("ИмяТипаСсылки", "ДокументСсылка." + МетаданныеОбъекта.Имя);
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;	
		
	Возврат Настройки;
		
КонецФункции


&НаКлиенте
Процедура ПослеВыбораДокумента(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;	
	КонецЕсли;	

	ДобавитьДокументВДерево(Результат, Ложь);
	
	СтандартныеПодсистемыКлиент.РазвернутьУзлыДерева(ЭтотОбъект, "ДеревоДокументов",, Истина);
	
КонецПроцедуры 

&НаСервере
Процедура ДобавитьДокументВДерево(ОбъектУчета, ДобавлятьСвязанныеДокументы = Истина) Экспорт
	
	ДеревоОбъект = РеквизитФормыВЗначение("ДеревоДокументов", Тип("ДеревоЗначений"));
	
	ДобавитьДокументВКореньДерева(ДеревоОбъект, ОбъектУчета);

	Если ДобавлятьСвязанныеДокументы Тогда

		СвязанныеДокументы = ОбъектыПоКритериюОтбора(ОбъектУчета);
	
		Для Каждого СвязанныйДокумент Из СвязанныеДокументы Цикл
	
			ДобавитьДокументВКореньДерева(ДеревоОбъект, СвязанныйДокумент);
	
		КонецЦикла;
		
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ДеревоОбъект, "ДеревоДокументов");

КонецПроцедуры     

&НаСервере
Функция ПолучитьТипыДокументов()

	СписокВидовПрикладныхДокументов = Новый СписокЗначений;

	ДокументыПодсистемы = Новый Массив;
	
	ДокументыПодсистемы(Метаданные.Подсистемы.ЭлектронноеВзаимодействие.Подсистемы.ОбменСКонтрагентами, ДокументыПодсистемы);
	
	Для Каждого Документ Из Метаданные.Документы Цикл
		
		Если ДокументыПодсистемы.Найти(Документ) = Неопределено Тогда
			СписокВидовПрикладныхДокументов.Добавить("Документ." + Документ.Имя, Документ.Синоним, , БиблиотекаКартинок.Документ);
		КонецЕсли;
		
	КонецЦикла;	

	Возврат СписокВидовПрикладныхДокументов;

КонецФункции

&НаСервере
Процедура ДокументыПодсистемы(Подсистема, Документы)
	
	Для Каждого ТекущаяПодсистема Из Подсистема.Подсистемы Цикл
		ДокументыПодсистемы(ТекущаяПодсистема, Документы);
	КонецЦикла;
	
	Для Каждого ТекущийОбъект Из Подсистема.Состав Цикл
		Если Метаданные.Документы.Содержит(ТекущийОбъект) Тогда
			Документы.Добавить(ТекущийОбъект);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти