#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.ТолькоПросмотр Тогда
		Элементы.ФормаСохранитьНастройку.Доступность = Ложь;
	КонецЕсли; 
	
	Номенклатура = Параметры.Номенклатура;
	Если НЕ Номенклатура.Пустая() Тогда
		Элементы.СтраницыНоменклатура.ТекущаяСтраница = Элементы.СтраницаНоменклатураВыбрана;
		РеквизитыМатериала = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Номенклатура, "ВидНоменклатуры,ИспользованиеХарактеристик");
		ВидМатериала = РеквизитыМатериала.ВидНоменклатуры;
		ПродукцияИмеетХарактеристики = (РеквизитыМатериала.ИспользованиеХарактеристик 
											<> Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать);
	Иначе
		Элементы.СтраницыНоменклатура.ТекущаяСтраница = Элементы.СтраницаНоменклатураНеВыбрана;
		ПродукцияИмеетХарактеристики = Ложь;
	КонецЕсли;
	
	Характеристика = Параметры.Характеристика;
	Если НЕ Характеристика.Пустая() Тогда
		Элементы.СтраницыХарактеристика.ТекущаяСтраница = Элементы.СтраницаХарактеристикаВыбрана;
	Иначе
		Элементы.СтраницыХарактеристика.ТекущаяСтраница = Элементы.СтраницаХарактеристикаНеВыбрана;
	КонецЕсли;
	
	// Текущая настройка
	СпособАвтовыбораНоменклатуры   = Параметры.СпособАвтовыбораНоменклатуры;
	СпособАвтовыбораХарактеристики = Параметры.СпособАвтовыбораХарактеристики;
	СвойствоСодержащееНоменклатуру = Параметры.СвойствоСодержащееНоменклатуру;
	
	АлгоритмАвтовыбораХарактеристики = Параметры.АлгоритмАвтовыбораХарактеристики;
	ОписанияФункций = УправлениеДаннымиОбИзделияхПовтИсп.ОписаниеФункцийАвтовыбораХарактеристики();
	Для каждого ОписаниеФункции Из ОписанияФункций Цикл
		Если НЕ ТипЗнч(ОписаниеФункции) = Тип("Структура") ИЛИ НЕ ОписаниеФункции.Свойство("ИмяФункции") Тогда
			Продолжить;
		КонецЕсли;
		Элементы.АлгоритмАвтовыбораХарактеристики.СписокВыбора.Добавить(ОписаниеФункции.ИмяФункции, ОписаниеФункции.Представление);
	КонецЦикла;
	Если Элементы.АлгоритмАвтовыбораХарактеристики.СписокВыбора.Количество() Тогда
		Элементы.АлгоритмАвтовыбораХарактеристики.СписокВыбора.СортироватьПоПредставлению();
	Иначе
		Элементы.АлгоритмАвтовыбораХарактеристики.ПодсказкаВвода = НСтр("ru = '<нет алгоритмов доступных для выбора>';
																		|en = '<no algorithm to select>'");
	КонецЕсли;
	
	Если Параметры.Описание = Неопределено Тогда
		Элементы.Описание.ТолькоПросмотр = Истина;
	Иначе
		Описание = Параметры.Описание;
	КонецЕсли;
	
	Для каждого НастройкаСоответствия Из Параметры.СоответствиеСвойств Цикл
		ЗаполнитьЗначенияСвойств(СоответствиеСвойств.Добавить(), НастройкаСоответствия);
	КонецЦикла; 
	
	// Определим вид изделий который содержит доступные свойства
	ВидИзделийИлиНоменклатура = Параметры.ВидИзделийИлиНоменклатура;
	Если ТипЗнч(ВидИзделийИлиНоменклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
		ВидИзделий = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидИзделийИлиНоменклатура, "ВидНоменклатуры");
	Иначе
		ВидИзделий = ВидИзделийИлиНоменклатура;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВидИзделий) Тогда
		ИнформационнаяСтрока = НСтр("ru = 'Не задан вид номенклатуры, свойства будут недоступны для выбора.';
									|en = 'The item kind is not set, the properties will not be available for selection.'");
	ИначеЕсли НЕ Параметры.Свойство("ИнформационнаяСтрока", ИнформационнаяСтрока) Тогда
		Элементы.ГруппаИнформационнаяПанель.Видимость = Ложь;
	КонецЕсли;
	
	СписокВсехДоступныхСвойств.Загрузить(УправлениеДаннымиОбИзделиях.ПолучитьСвойстваДляАвтовыбора(ВидИзделий));
	
	ЗаполнитьВыборСвойстваСодержащегоНоменклатуру();
	
	// Установим представление способа выбора, в зависимости от контекста настройки (спецификация или операция).
	ЗначениеВыбора = Элементы.МатериалУказываетсяВНСИ.СписокВыбора.НайтиПоЗначению(Перечисления.СпособыАвтовыбораНоменклатуры.УказываетсяВНСИ);
	ЗначениеВыбора.Представление = Параметры.НазваниеСвойстваУказываетсяВНСИ;
	
	ЗначениеВыбора = Элементы.ХарактеристикаУказываетсяВНСИ.СписокВыбора.НайтиПоЗначению(Перечисления.СпособыАвтовыбораХарактеристики.УказываетсяВНСИ);
	ЗначениеВыбора.Представление = Параметры.НазваниеСвойстваУказываетсяВНСИ;
	
	// Отключим видимость элементов связанных с характеристиками, если характеристики не используются
	ИспользоватьХарактеристикиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	ИспользоватьДополнительныеРеквизитыИСведения = ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения");
	
	// Элементы связанные с настройкой "Материал указывается в свойстве характеристики продукции"
	Если НЕ ИспользоватьДополнительныеРеквизитыИСведения Тогда
		Элементы.ГруппаЗадаетсяВСвойствеПродукции.Видимость = Ложь;
	КонецЕсли; 
	
	Если НЕ ИспользоватьХарактеристикиНоменклатуры Тогда
		Элементы.ГруппаКакОпределяетсяХарактеристика.Видимость = Ложь;
	КонецЕсли;
	
	// Элементы связанные с настройкой "Определяется по свойствам продукции"
	Если НЕ ИспользоватьХарактеристикиНоменклатуры ИЛИ НЕ ИспользоватьДополнительныеРеквизитыИСведения Тогда
		Элементы.ГруппаХарактеристикаПодбираетсяПоСвойствамПродукции.Видимость = Ложь;
	КонецЕсли; 
	
	Если НЕ ИспользоватьХарактеристикиНоменклатуры Тогда
		Элементы.ПояснениеХарактеристика.Видимость = Ложь;
		Элементы.ПояснениеХарактеристикаПодбираетсяПоСвойствамПродукции.Видимость = Ложь;
		Элементы.ПояснениеНетХарактеристик.Видимость = Ложь;
		Элементы.ПояснениеХарактеристикаУточняетсяПриПроизводстве.Видимость = Ложь;
		Элементы.ДекорацияНастройкаСоответствияСвойствПустая.Видимость = Ложь;
	КонецЕсли;
	
	ИмяТЧ = Параметры.ИмяТЧ;
	
	СвойствоСодержащееНоменклатуруЗаголовок = СвойствоСодержащееНоменклатуруЗаголовок(СвойствоСодержащееНоменклатуру);
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область КакОпределяетсяМатериал

&НаКлиенте
Процедура МатериалУказываетсяВНСИПриИзменении(Элемент)
	
	ПриИзмененииАвтовыбораНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадаетсяВСвойствеПродукцииДоступнаПриИзменении(Элемент)
	
	ПриИзмененииАвтовыбораНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УточняетсяПриПроизводствеПриИзменении(Элемент)
	
	ПриИзмененииАвтовыбораНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СвойствоСодержащееНоменклатуруПриИзменении(Элемент)
	
	СвойствоСодержащееНоменклатуруЗаголовок = СвойствоСодержащееНоменклатуруЗаголовок(СвойствоСодержащееНоменклатуру);
	
КонецПроцедуры

#КонецОбласти

#Область КакОпределяетсяХарактеристикаМатериала

&НаКлиенте
Процедура ХарактеристикаУказываетсяВНСИПриИзменении(Элемент)
	
	ПриИзмененииАвтовыбораХарактеристики(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодбираетсяПоСвойствамПродукцииДоступнаПриИзменении(Элемент)
	
	ПриИзмененииАвтовыбораХарактеристики(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодбираетсяПоАлгоритмуДоступнаПриИзменении(Элемент)
	
	ПриИзмененииАвтовыбораХарактеристики(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСохранитьНастройку(Команда)
	
	Если НЕ ПроверитьЗаполнениеРеквизитов() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("НоменклатураСтрокой,ХарактеристикаСтрокой,
									|СпособАвтовыбораНоменклатуры,СпособАвтовыбораХарактеристики,
									|СвойствоСодержащееНоменклатуру");
	
	ПараметрыФормы.Вставить("СпособАвтовыбораНоменклатуры",   СпособАвтовыбораНоменклатуры);
	ПараметрыФормы.Вставить("СпособАвтовыбораХарактеристики", СпособАвтовыбораХарактеристики);
	ПараметрыФормы.Вставить("АлгоритмАвтовыбораХарактеристики", АлгоритмАвтовыбораХарактеристики);
	
	ПараметрыФормы.Вставить("Описание", Описание);
	
	Если СпособАвтовыбораНоменклатуры = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораНоменклатуры.ЗадаетсяВСвойствеПродукции") Тогда
		ПараметрыФормы.Вставить("Номенклатура", Неопределено);
		
		НоменклатураСтрокой = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									Нстр("ru = '<указывается в свойстве ""%1"">';
										|en = '<specified in the ""%1"" property>'"), 
									СвойствоСодержащееНоменклатуруЗаголовок);
				
		ПараметрыФормы.Вставить("НоменклатураСтрокой", НоменклатураСтрокой);
		
		ПараметрыФормы.Вставить("СвойствоСодержащееНоменклатуру", СвойствоСодержащееНоменклатуру);
		
	ИначеЕсли СпособАвтовыбораНоменклатуры = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораНоменклатуры.УточняетсяПриПроизводстве") Тогда
		ПараметрыФормы.Вставить("Номенклатура", Неопределено);
		ПараметрыФормы.Вставить("НоменклатураСтрокой", Нстр("ru = '<уточняется при производстве>';
															|en = '<specified during production>'"));
		
	Иначе
		ПараметрыФормы.Вставить("Номенклатура", Номенклатура);
		ПараметрыФормы.Вставить("НоменклатураСтрокой", "");
	КонецЕсли; 
	
	Если СпособАвтовыбораХарактеристики = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораХарактеристики.ПодбираетсяПоСвойствамПродукции") Тогда
		ПараметрыФормы.Вставить("Характеристика", Неопределено);
		ПараметрыФормы.Вставить("ХарактеристикаСтрокой", Нстр("ru = '<определяется по свойствам основного изделия>';
																|en = '<determined by main product properties>'"));
		
		ПараметрыФормы.Вставить("СоответствиеСвойств", СоответствиеСвойств);
		
	ИначеЕсли СпособАвтовыбораХарактеристики = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораХарактеристики.ПодбираетсяПоАлгоритму") Тогда
		ПараметрыФормы.Вставить("Характеристика", Неопределено);
		ПараметрыФормы.Вставить("ХарактеристикаСтрокой", Нстр("ru = '<определяется по алгоритму>';
																|en = '<defined by algorithm>'"));
		
	ИначеЕсли СпособАвтовыбораХарактеристики = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораХарактеристики.УточняетсяПриПроизводстве") Тогда
		ПараметрыФормы.Вставить("Характеристика", Неопределено);
		ПараметрыФормы.Вставить("ХарактеристикаСтрокой", Нстр("ru = '<уточняется при производстве>';
																|en = '<specified during production>'"));
		
	Иначе
		ПараметрыФормы.Вставить("Характеристика", Характеристика);
		ПараметрыФормы.Вставить("ХарактеристикаСтрокой", "");
	КонецЕсли; 
	
	ОповеститьОВыборе(ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНастройкаСоответствияСвойств(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидИзделий",          ВидИзделий);
	ПараметрыФормы.Вставить("ВидМатериала",        ВидМатериала);
	ПараметрыФормы.Вставить("СоответствиеСвойств", СоответствиеСвойств);
	ПараметрыФормы.Вставить("ТолькоПросмотр",      ТолькоПросмотр);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НастройкаСоответствияСвойствЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.НастройкаСоответствияСвойств", ПараметрыФормы,,,,,ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СвойствоСодержащееНоменклатуру.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СпособАвтовыбораНоменклатуры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СпособыАвтовыбораНоменклатуры.ЗадаетсяВСвойствеПродукции;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

КонецПроцедуры

&НаКлиенте
Процедура НастройкаСоответствияСвойствЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СоответствиеСвойств.Очистить();
	Для каждого НастройкаСоответствия Из РезультатЗакрытия Цикл
		ЗаполнитьЗначенияСвойств(СоответствиеСвойств.Добавить(), НастройкаСоответствия);
	КонецЦикла; 
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВыборСвойстваСодержащегоНоменклатуру()

	Для каждого ДанныеСвойства Из СписокВсехДоступныхСвойств Цикл
		Если НЕ ДанныеСвойства.ПометкаУдаления 
			И ДанныеСвойства.Свойство.ТипЗначения.СодержитТип(Тип("СправочникСсылка.Номенклатура")) 
			ИЛИ ДанныеСвойства.Свойство = СвойствоСодержащееНоменклатуру Тогда
			Элементы.СвойствоСодержащееНоменклатуру.СписокВыбора.Добавить(ДанныеСвойства.Свойство, ДанныеСвойства.Представление);
		КонецЕсли;
	КонецЦикла;

	Если Элементы.СвойствоСодержащееНоменклатуру.СписокВыбора.Количество() = 0 Тогда
		Элементы.СтраницыЗадаетсяВСвойствеПродукции.ТекущаяСтраница = Элементы.СтраницаЗадаетсяВСвойствеПродукцииНеДоступна;
	Иначе
		Элементы.СтраницыЗадаетсяВСвойствеПродукции.ТекущаяСтраница = Элементы.СтраницаЗадаетсяВСвойствеПродукцииДоступна;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииАвтовыбораНоменклатуры(Форма)

	ПроверитьСпособыАвтовыбораХарактеристики(Форма);
	УправлениеДоступностью(Форма);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииАвтовыбораХарактеристики(Форма)
	
	Если ЗначениеЗаполнено(Форма.АлгоритмАвтовыбораХарактеристики)
		И Форма.СпособАвтовыбораХарактеристики <> ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораХарактеристики.ПодбираетсяПоАлгоритму") Тогда
		Форма.АлгоритмАвтовыбораХарактеристики = Неопределено;
	КонецЕсли;
	УправлениеДоступностью(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПроверитьСпособыАвтовыбораХарактеристики(Форма)
	
 	Если Форма.СпособАвтовыбораНоменклатуры = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораНоменклатуры.ЗадаетсяВСвойствеПродукции") Тогда
		
		Если Форма.СпособАвтовыбораХарактеристики <> ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораХарактеристики.УточняетсяПриПроизводстве") Тогда
			Форма.СпособАвтовыбораХарактеристики = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораХарактеристики.УточняетсяПриПроизводстве");
		КонецЕсли; 
		
	ИначеЕсли Форма.СпособАвтовыбораНоменклатуры = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораНоменклатуры.УточняетсяПриПроизводстве") Тогда
		
		Если Форма.СпособАвтовыбораХарактеристики <> ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораХарактеристики.УточняетсяПриПроизводстве") Тогда
			Форма.СпособАвтовыбораХарактеристики = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораХарактеристики.УточняетсяПриПроизводстве");
		КонецЕсли; 
		
	КонецЕсли;

	Если ЗначениеЗаполнено(Форма.СвойствоСодержащееНоменклатуру)
		И Форма.СпособАвтовыбораНоменклатуры <> ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораНоменклатуры.ЗадаетсяВСвойствеПродукции") Тогда
		Форма.СвойствоСодержащееНоменклатуру = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)

	// СвойствоСодержащееНоменклатуру
	Если Форма.СпособАвтовыбораНоменклатуры = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораНоменклатуры.ЗадаетсяВСвойствеПродукции") Тогда
		Форма.Элементы.СвойствоСодержащееНоменклатуру.ТолькоПросмотр = Ложь;
	Иначе
		Форма.Элементы.СвойствоСодержащееНоменклатуру.ТолькоПросмотр = Истина;
	КонецЕсли; 
	
	// ХарактеристикаУказываетсяВНСИ
	Если Форма.СпособАвтовыбораНоменклатуры = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораНоменклатуры.УказываетсяВНСИ") Тогда
		Форма.Элементы.ХарактеристикаУказываетсяВНСИ.ТолькоПросмотр = Ложь;
	Иначе
		Форма.Элементы.ХарактеристикаУказываетсяВНСИ.ТолькоПросмотр = Истина;
	КонецЕсли; 
	
	// ПодбираетсяПоСвойствамПродукции
	ВыборХарактеристикПоСвойствамДоступен = Истина;
	Если Форма.СпособАвтовыбораНоменклатуры = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораНоменклатуры.УказываетсяВНСИ")
		И Форма.Номенклатура.Пустая() Тогда
		
		ЗначениеВыбора = Форма.Элементы.ПодбираетсяПоСвойствамПродукцииНеДоступна.СписокВыбора[0];
		ЗначениеВыбора.Представление = НСтр("ru = 'Определяется по свойствам основного изделия (необходимо указать материал)';
											|en = 'Determined by main product properties (specify a material)'");
		
		ЗначениеВыбора = Форма.Элементы.ПодбираетсяПоАлгоритмуНеДоступна.СписокВыбора[0];
		ЗначениеВыбора.Представление = НСтр("ru = 'Определяется по алгоритму (необходимо указать материал)';
											|en = 'Determined by the algorithm (material must be specified)'");
		
		ВыборХарактеристикПоСвойствамДоступен = Ложь;
		
	ИначеЕсли Форма.СпособАвтовыбораНоменклатуры = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораНоменклатуры.УточняетсяПриПроизводстве") Тогда
		
		ЗначениеВыбора = Форма.Элементы.ПодбираетсяПоСвойствамПродукцииНеДоступна.СписокВыбора[0];
		ЗначениеВыбора.Представление = НСтр("ru = 'Определяется по свойствам основного изделия (недоступно, т.к. материал уточняется в производстве)';
											|en = 'Determined by main product properties (unavailable as the material is specified in production)'");
		
		ЗначениеВыбора = Форма.Элементы.ПодбираетсяПоАлгоритмуНеДоступна.СписокВыбора[0];
		ЗначениеВыбора.Представление = НСтр("ru = 'Определяется по алгоритму (недоступно, т.к. материал уточняется в производстве)';
											|en = 'Determined by algorithm (unavailable as the material is specified in production)'");
		
		ВыборХарактеристикПоСвойствамДоступен = Ложь;
		
	КонецЕсли;
	
	Если ВыборХарактеристикПоСвойствамДоступен Тогда
		Форма.Элементы.СтраницыХарактеристикаПодбираетсяПоСвойствамПродукции.ТекущаяСтраница = Форма.Элементы.СтраницаХарактеристикаПодбираетсяПоСвойствамПродукцииДоступна;
		Форма.Элементы.СтраницыХарактеристикаПодбираетсяПоАлгоритму.ТекущаяСтраница = Форма.Элементы.СтраницаХарактеристикаПодбираетсяПоАлгоритмуДоступна;
		Если Форма.СпособАвтовыбораНоменклатуры = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораНоменклатуры.УказываетсяВНСИ") Тогда
			Форма.Элементы.СтраницыНастройкаСоответствияСвойств.ТекущаяСтраница = Форма.Элементы.СтраницаНастройкаСоответствияСвойствНастройка;
		Иначе
			Форма.Элементы.СтраницыНастройкаСоответствияСвойств.ТекущаяСтраница = Форма.Элементы.СтраницаНастройкаСоответствияСвойствНастройкаНеТребуется;
		КонецЕсли; 
	Иначе
		Форма.Элементы.СтраницыХарактеристикаПодбираетсяПоСвойствамПродукции.ТекущаяСтраница = Форма.Элементы.СтраницаХарактеристикаПодбираетсяПоСвойствамПродукцииНеДоступна;
		Форма.Элементы.СтраницыХарактеристикаПодбираетсяПоАлгоритму.ТекущаяСтраница = Форма.Элементы.СтраницаХарактеристикаПодбираетсяПоАлгоритмуНеДоступна;
	КонецЕсли; 
	
	Если Форма.СпособАвтовыбораХарактеристики = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораХарактеристики.ПодбираетсяПоСвойствамПродукции") Тогда
		Форма.Элементы.НастройкаСоответствияСвойств.Доступность = Истина;
	Иначе
		Форма.Элементы.НастройкаСоответствияСвойств.Доступность = Ложь;
	КонецЕсли; 
	
	Если Форма.СпособАвтовыбораХарактеристики = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораХарактеристики.ПодбираетсяПоАлгоритму") Тогда
		Форма.Элементы.АлгоритмАвтовыбораХарактеристики.Доступность = Истина;
	Иначе
		Форма.Элементы.АлгоритмАвтовыбораХарактеристики.Доступность = Ложь;
	КонецЕсли; 
	
	Если Форма.ИспользоватьХарактеристикиНоменклатуры Тогда
		Если Форма.СпособАвтовыбораНоменклатуры = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораНоменклатуры.ЗадаетсяВСвойствеПродукции")
			ИЛИ Форма.СпособАвтовыбораНоменклатуры = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораНоменклатуры.УточняетсяПриПроизводстве") Тогда
			Форма.Элементы.СтраницыКакОпределяетсяХарактеристикаМатериала.ТекущаяСтраница = Форма.Элементы.СтраницаКакОпределяетсяХарактеристикаМатериалаМатериалВСвойстве;
			Форма.Элементы.ДекорацияОпределениеХарактеристикиМатериалВСвойстве.Видимость =
				Форма.СпособАвтовыбораНоменклатуры = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораНоменклатуры.УточняетсяПриПроизводстве");
			Форма.Элементы.ГруппаОпределениеХарактеристикиМатериалВСвойствеСВыбором.Видимость = 
				Форма.СпособАвтовыбораНоменклатуры = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораНоменклатуры.ЗадаетсяВСвойствеПродукции");
		ИначеЕсли Форма.ПродукцияИмеетХарактеристики Тогда
			Форма.Элементы.СтраницыКакОпределяетсяХарактеристикаМатериала.ТекущаяСтраница = Форма.Элементы.СтраницаКакОпределяетсяХарактеристикаМатериалаЕстьХарактеристика;
		Иначе
			Форма.Элементы.СтраницыКакОпределяетсяХарактеристикаМатериала.ТекущаяСтраница = Форма.Элементы.СтраницаКакОпределяетсяХарактеристикаМатериалаНетХарактеристики;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеРеквизитов()
	
	Отказ = Ложь;
	
	Если СпособАвтовыбораНоменклатуры = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораНоменклатуры.ЗадаетсяВСвойствеПродукции") 
		И НЕ ЗначениеЗаполнено(СвойствоСодержащееНоменклатуру) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбрано свойство, содержащее номенклатуру.';
																|en = 'Property that contains products is not selected.'"),,
			"СвойствоСодержащееНоменклатуру",,Отказ);
		
	КонецЕсли;
	
	Если СпособАвтовыбораХарактеристики = ПредопределенноеЗначение("Перечисление.СпособыАвтовыбораХарактеристики.ПодбираетсяПоАлгоритму")
		И НЕ ЗначениеЗаполнено(АлгоритмАвтовыбораХарактеристики) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбран алгоритм, по которому определяется характеристика.';
																|en = 'Algorithm that determines variant is not selected.'"),,
			"АлгоритмАвтовыбораХарактеристики",,Отказ);
		
	КонецЕсли;
		
	Возврат НЕ Отказ;
		
КонецФункции

&НаСервереБезКонтекста
Функция СвойствоСодержащееНоменклатуруЗаголовок(СвойствоСодержащееНоменклатуру)
	
	 Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СвойствоСодержащееНоменклатуру, "Заголовок");
	
КонецФункции

#КонецОбласти
