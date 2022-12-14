////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ПанельФормы.ТекущаяСтраница = ?(Параметры.ОбычныйЭтап, Элементы.ОбычныйЭтап, Элементы.УсловныйПереход);
	
	Если Параметры.ОбычныйЭтап Тогда
		Заголовок = "Список этапов-последователей";
	Иначе
		Заголовок = "Настройка условного перехода";
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(Параметры.АдресТабличноеПолеПереходов) Тогда
		Вн_ТабличноеПолеПереходов = ПолучитьИзВременногоХранилища(Параметры.АдресТабличноеПолеПереходов);
		Вн_ТабличноеПолеПереходов.Колонки.Добавить("ОтображениеДействияТекст", ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСтроки(100));
		ЗначениеВРеквизитФормы(Вн_ТабличноеПолеПереходов, "ТабличноеПолеПерехода");
	Иначе
		Отказ  = Истина;
		Возврат;
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(Параметры.АдресДеревоОтборов) Тогда
		ЗначениеВРеквизитФормы(ПолучитьИзВременногоХранилища(Параметры.АдресДеревоОтборов), "ДеревоОтборов");
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(Параметры.АдресКэшВидовСубконто) Тогда
		ЗначениеВРеквизитФормы(ПолучитьИзВременногоХранилища(Параметры.АдресКэшВидовСубконто), "КэшВидовСубконто");
	КонецЕсли;
	
	СписокВозможныхДействий.Добавить(Перечисления.ДействияЭтапа.УтвердитьОтчет, "2");
	СписокВозможныхДействий.Добавить(Перечисления.ДействияЭтапа.ВернутьИсполнителю, "3");
	СписокВозможныхДействий.Добавить(Перечисления.ДействияЭтапа.ПерейтиКЭтапу, "1");
	
	ПараметрическоеУсловие = Перечисления.УсловияЭтапа.ПараметрическоеУсловие;
	
	СоответствиеУсловийИТиповЗначений.Добавить(Перечисления.УсловияЭтапа.Организация,            "СправочникСсылка.Организации");
	СоответствиеУсловийИТиповЗначений.Добавить(Перечисления.УсловияЭтапа.ПараметрическоеУсловие, "СправочникСсылка.ПараметрическоеУсловие");
	СоответствиеУсловийИТиповЗначений.Добавить(Перечисления.УсловияЭтапа.Исполнитель,            "СправочникСсылка.Пользователи");
	СоответствиеУсловийИТиповЗначений.Добавить(Перечисления.УсловияЭтапа.ВидОтчета,              "СправочникСсылка.ВидыОтчетов");
	СоответствиеУсловийИТиповЗначений.Добавить(Перечисления.УсловияЭтапа.Договор,                "СправочникСсылка.ДоговорыКонтрагентов");
	СоответствиеУсловийИТиповЗначений.Добавить(Перечисления.УсловияЭтапа.Контрагент,             "СправочникСсылка.Контрагенты");
	СоответствиеУсловийИТиповЗначений.Добавить(Перечисления.УсловияЭтапа.СтатьяДДС,              "СправочникСсылка.СтатьиДвиженияДенежныхСредств");
	СоответствиеУсловийИТиповЗначений.Добавить(Перечисления.УсловияЭтапа.ПриоритетЗаявки,        "СправочникСсылка.ПриоритетыПлатежей");
    СоответствиеУсловийИТиповЗначений.Добавить(Перечисления.УсловияЭтапа.НСИВидЗаявки,        "ПеречислениеСсылка.ВидыОперацийИзмененияНСИ");	
	СоответствиеУсловийИТиповЗначений.Добавить(Перечисления.УсловияЭтапа.СуммаПлатежа,           "Число");
	СоответствиеУсловийИТиповЗначений.Добавить(Перечисления.УсловияЭтапа.Взаиморасчеты,          "Число");
	СоответствиеУсловийИТиповЗначений.Добавить(Перечисления.УсловияЭтапа.ОстаткиДС,              "Число");
	СоответствиеУсловийИТиповЗначений.Добавить(Перечисления.УсловияЭтапа.ПланыДДС,               "Число");
	
	Для Каждого Стр из Параметры.СписокВыбораУсловий Цикл 
		СоответствиеУсловийИТиповЗначений.Добавить(Стр.Значение,              Стр.Представление);
		Если Стр.Представление = "Дата" Или Стр.Представление = "Число" Тогда
			НоваяСтрока = ТаблицаВозможныхВыборов.Добавить();
			НоваяСтрока.ТипУсловия.Добавить(Стр.Значение);
			НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.Равно);
			НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.НеРавно);
			НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.Больше);
			НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.Меньше);
			НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.БольшеИлиРавно);
			НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.МеньшеИлиРавно);
			
		КонецЕсли;
		Стр.Представление = Стр.Значение; 
	 КонецЦикла;	
		
	Параметры.Свойство("СписокВыбораУсловий" , СписокВыбораУсловий);
	Параметры.Свойство("СписокВыбораДействий", СписокВыбораДействий);
	Параметры.Свойство("МаршрутСогласования" , МаршрутСогласования);
	
	НоваяСтрока = ТаблицаВозможныхВыборов.Добавить();
	
	НоваяСтрока.ТипУсловия.Добавить(Перечисления.УсловияЭтапа.Взаиморасчеты);
	НоваяСтрока.ТипУсловия.Добавить(Перечисления.УсловияЭтапа.ОстаткиДС);
	НоваяСтрока.ТипУсловия.Добавить(Перечисления.УсловияЭтапа.ПланыДДС);
	
	НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.Равно);
	НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.НеРавно);
	НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.Больше);
	НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.Меньше);
	НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.БольшеИлиРавно);
	НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.МеньшеИлиРавно);
	НоваяСтрока.СписокВыбора.Добавить(Перечисления.ВидСравненияЛимитовЗаявок.АбсолютноеПревышениеЛимитаНа);
	НоваяСтрока.СписокВыбора.Добавить(Перечисления.ВидСравненияЛимитовЗаявок.ОтносительноеПревышениеЛимитаНа);
	
	НоваяСтрока = ТаблицаВозможныхВыборов.Добавить();
	
	НоваяСтрока.ТипУсловия.Добавить(Перечисления.УсловияЭтапа.СуммаПлатежа);
	
	НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.Равно);
	НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.НеРавно);
	НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.Больше);
	НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.Меньше);
	НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.БольшеИлиРавно);
	НоваяСтрока.СписокВыбора.Добавить(ВидСравнения.МеньшеИлиРавно);

	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Настройка_ОтображатьВариантыОтборов = Настройки["ОтображатьВариантыОтборов"];
	Если Настройка_ОтображатьВариантыОтборов <> Неопределено  Тогда
		УправлениеВидимостьюВариантовОтбора(Настройка_ОтображатьВариантыОтборов);
	Иначе
		УправлениеВидимостьюВариантовОтбора(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьОтображениеДействияДляСтрокиДерева(ТабличноеПолеПерехода);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ.
//

&НаКлиенте
Процедура ТабличноеПолеПереходаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ТС = Элемент.ТекущаяСтрока;
	ДанныеСтроки = Элемент.ДанныеСтроки(ТС);

	Если Копирование Тогда
		Если ДанныеСтроки.ЯвляетсяУсловием 
		   И (ДанныеСтроки.ОбработкаУсловия = 1 ИЛИ ДанныеСтроки.ОбработкаУсловия = 2 ИЛИ ДанныеСтроки.ОбработкаУсловия = 5) Тогда
			Возврат;
		КонецЕсли;
		
		ТекРодитель = ДанныеСтроки.ПолучитьРодителя();
		Если ТекРодитель = Неопределено Тогда
			ТекРодитель = ТабличноеПолеПерехода;
		КонецЕсли;
		
		СтрокиРодителя = ТекРодитель.ПолучитьЭлементы();
		Индекс = СтрокиРодителя.Индекс(ДанныеСтроки);
		ЗаполнитьЗначенияСвойств(СтрокиРодителя.Вставить(Индекс), ДанныеСтроки);
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличноеПолеПереходаУсловиеДействияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.ТабличноеПолеПерехода.ДанныеСтроки(Элементы.ТабличноеПолеПерехода.ТекущаяСтрока);
	Если ТекущиеДанные.ЯвляетсяУсловием Тогда
		ДанныеВыбора = СписокВыбораУсловий;
	Иначе
		ДанныеВыбора = СписокВыбораДействий;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличноеПолеПереходаУсловиеДействияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТабличноеПолеПерехода.ДанныеСтроки(Элементы.ТабличноеПолеПерехода.ТекущаяСтрока);
	ТекущиеДанные.Значение = ВидСравнения.Равно;
	ПривестиЗначениеКТипу(Элементы.ТабличноеПолеПерехода.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличноеПолеПереходаЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.ТабличноеПолеПерехода.ДанныеСтроки(Элементы.ТабличноеПолеПерехода.ТекущаяСтрока);
	Если ТипЗнч(ТекущиеДанные.УсловиеДействие) = Тип("ПеречислениеСсылка.ДействияЭтапа") Тогда
		ОткрытьФорму("Справочник.ЭтапыСогласования.ФормаВыбора", Новый Структура("Отбор", Новый Структура("Владелец, ПометкаУдаления", МаршрутСогласования, Ложь)), Элемент);
	Иначе
		Для Каждого СтрокаСоставаВыбора Из ТаблицаВозможныхВыборов Цикл
			Если СтрокаСоставаВыбора.ТипУсловия.НайтиПоЗначению(ТекущиеДанные.УсловиеДействие) <> Неопределено Тогда
				ДанныеВыбора = СтрокаСоставаВыбора.СписокВыбора;
				Возврат;
			КонецЕсли;
		КонецЦикла;
		
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить(ВидСравнения.Равно);
		Если ТекущиеДанные.УсловиеДействие <> ПараметрическоеУсловие Тогда
			ДанныеВыбора.Добавить(ВидСравнения.НеРавно);
			ДанныеВыбора.Добавить(ВидСравнения.ВСписке);
			ДанныеВыбора.Добавить(ВидСравнения.НеВСписке);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличноеПолеПереходаПередУдалением(Элемент, Отказ)
	
	ТС = Элементы.ТабличноеПолеПерехода.ТекущаяСтрока;
	
	Если ТС <> Неопределено Тогда
		
		ДанныеСтроки = ТабличноеПолеПерехода.НайтиПоИдентификатору(ТС);
		Если ДанныеСтроки.ЯвляетсяУсловием
		   И ДанныеСтроки.ОбработкаУсловия <> 0 
		   И ДанныеСтроки.ОбработкаУсловия <> 3 
		   И ДанныеСтроки.ОбработкаУсловия <> 4 Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличноеПолеПереходаПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	Если НЕ Строка = Неопределено Тогда
		ТекущаяСтрока = ТабличноеПолеПерехода.НайтиПоИдентификатору(Строка);
		Если ТекущаяСтрока.ЯвляетсяУсловием И ТекущаяСтрока.ОбработкаУсловия = 0 ТОгда
			ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование;

КонецПроцедуры

&НаКлиенте
Процедура ТабличноеПолеПереходаПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если Строка <> Неопределено Тогда
		
		ТекущаяСтрока = ТабличноеПолеПерехода.НайтиПоИдентификатору(Строка);
		
		Если ТекущаяСтрока.ЯвляетсяУсловием = 1 Тогда
			Если ТекущаяСтрока.ОбработкаУсловия = 3
			 ИЛИ ТекущаяСтрока.ОбработкаУсловия = 4
			 ИЛИ ТекущаяСтрока.ОбработкаУсловия = 5 Тогда
				НоваяСтрока = ВставитьУсловиеВыбора(Строка);
			ИначеЕсли ТекущаяСтрока.ОбработкаУсловия = 1
				  ИЛИ ТекущаяСтрока.ОбработкаУсловия = 2 Тогда
				НоваяСтрока = ВставитьУсловие(Строка);
			КонецЕсли;
		Иначе
			НоваяСтрока = ВставитьУсловие(ТекущаяСтрока.ПолучитьРодителя().ПолучитьИдентификатор());
		КонецЕсли;
		
		Строка_НоваяСтрока = ТабличноеПолеПерехода.НайтиПоИдентификатору(НоваяСтрока);
		Строка_НоваяСтрока.УсловиеДействие = ПараметрыПеретаскивания.Значение[0].Условие;
		Строка_НоваяСтрока.Значение        = ВидСравнения.Равно;
		ПривестиЗначениеКТипу(НоваяСтрока);
		
	Иначе
		НоваяСтрока = ВставитьУсловие();
		Строка_НоваяСтрока = ТабличноеПолеПерехода.НайтиПоИдентификатору(НоваяСтрока);
		Строка_НоваяСтрока.УсловиеДействие = ПараметрыПеретаскивания.Значение[0].Условие;
		Строка_НоваяСтрока.Значение        = ВидСравнения.Равно;
		ПривестиЗначениеКТипу(НоваяСтрока);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтборовНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ТекущаяСтрока = ДеревоОтборов.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение[0]);
	
	Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.Условие) Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.НеОбрабатывать;
		СтандартнаяОбработка = Ложь;
	Иначе
		ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.КопированиеИПеремещение;
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование;
		СтандартнаяОбработка = Истина;
	КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура ТабличноеПолеПерехода_ОбычныйЭтапПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	НоваяСтрока = ТабличноеПолеПерехода.ПолучитьЭлементы().Добавить();
	НоваяСтрока.УсловиеДействие = ПредопределенноеЗначение("Перечисление.ДействияЭтапа.ПерейтиКЭтапу");
	Элементы.ТабличноеПолеПерехода.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		
	Если Копирование Тогда
		
		ДанныеСтроки = ТабличноеПолеПерехода.НайтиПоИдентификатору(Элементы.ТабличноеПолеПерехода.ТекущаяСтрока);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеСтроки);
		
	КонецЕсли;
	
	УстановитьОтображениеДействия(НоваяСтрока.ПолучитьИдентификатор());
	
КонецПроцедуры


&НаКлиенте
Процедура ТабличноеПолеПерехода_ОбычныйЭтапЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Справочник.ЭтапыСогласования.ФормаВыбора", Новый Структура("Отбор", Новый Структура("Владелец", МаршрутСогласования)), Элемент);
	
КонецПроцедуры


&НаКлиенте
Процедура ДобавитьВыбор(Команда)
	
	ВставитьВыбор(Элементы.ТабличноеПолеПерехода.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьДействие(Команда)
	
	Если Элементы.ТабличноеПолеПерехода.ТекущаяСтрока = Неопределено Тогда
		НоваяСтрока = ТабличноеПолеПерехода.ПолучитьЭлементы().Добавить();
	Иначе
		ТС = Элементы.ТабличноеПолеПерехода.ДанныеСтроки(Элементы.ТабличноеПолеПерехода.ТекущаяСтрока);
		Если ТС.ЯвляетсяУсловием Тогда
			Если ТС.ОбработкаУсловия = 0 ИЛИ ТС.ОбработкаУсловия = 3 Тогда
				Родитель = ТС.ПолучитьРодителя();
				Если Родитель = Неопределено Тогда
					Родитель = ТабличноеПолеПерехода;
				КонецЕсли;
				СтрокиРодителя = Родитель.ПолучитьЭлементы();
				Индекс         = СтрокиРодителя.Индекс(ТС);
				НоваяСтрока    = СтрокиРодителя.Вставить(Индекс);
			Иначе
				НоваяСтрока = ТС.ПолучитьЭлементы().Вставить(0);
			КонецЕсли;
			
		Иначе
			Родитель = ТС.ПолучитьРодителя();
			Если Родитель = Неопределено Тогда
				Родитель = ТабличноеПолеПерехода;
			КонецЕсли;
			
			СтрокиРодителя = Родитель.ПолучитьЭлементы();
			Индекс = СтрокиРодителя.Индекс(ТС);
			НоваяСтрока = СтрокиРодителя.Вставить(Индекс);
		КонецЕсли;
	КонецЕсли;
	
	НоваяСтрока.ЯвляетсяУсловием = Ложь;
	НоваяСтрока.УсловиеДействие  = ПредопределенноеЗначение("Перечисление.ДействияЭтапа.ПерейтиКЭтапу");
	Элементы.ТабличноеПолеПерехода.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	
	УстановитьОтображениеДействия(НоваяСтрока.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьУсловие(Команда)
	
	Если Элементы.ТабличноеПолеПерехода.ТекущаяСтрока = Неопределено Тогда
		ВставитьУсловие();
	Иначе
		ТекущаяСтрока = Элементы.ТабличноеПолеПерехода.ДанныеСтроки(Элементы.ТабличноеПолеПерехода.ТекущаяСтрока);
		Если ТекущаяСтрока.ЯвляетсяУсловием Тогда
			Если ТекущаяСтрока.ОбработкаУсловия = 0 Тогда
				Возврат;
			Иначе
				ВставитьУсловие(Элементы.ТабличноеПолеПерехода.ТекущаяСтрока);
			КонецЕсли;
		Иначе
			ВставитьУсловие(ТекущаяСтрока.ПолучитьРодителя().ПолучитьИдентификатор());
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьУсловиеВыбора(Команда)
	
	ТС = Элементы.ТабличноеПолеПерехода.ТекущаяСтрока;
	
	Если ТС = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Элементы.ТабличноеПолеПерехода.ДанныеСтроки(ТС);
	Если НЕ ДанныеСтроки.ЯвляетсяУсловием Тогда
		Возврат;
	КонецЕсли;
	
	ВставитьУсловиеВыбора(ТС);

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЭтапПоследователь(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	
	ТС = Элементы.ТабличноеПолеПерехода.ТекущаяСтрока;
	Если ТС <> Неопределено Тогда
		ДанныеСтроки = ТабличноеПолеПерехода.НайтиПоИдентификатору(ТС);
		Если ДанныеСтроки.ЯвляетсяУсловием
		   И (ДанныеСтроки.ОбработкаУсловия = 1
		      ИЛИ ДанныеСтроки.ОбработкаУсловия = 2
			  ИЛИ ДанныеСтроки.ОбработкаУсловия = 5) Тогда
				Возврат;
		КонецЕсли;
		
		Попытка
			Родитель = ДанныеСтроки.ПолучитьРодителя();
			Если Родитель = Неопределено Тогда
				Родитель = ТабличноеПолеПерехода;
			КонецЕсли;
			СтрокиРодителя = Родитель.ПолучитьЭлементы();
			Индекс         = СтрокиРодителя.Индекс(ДанныеСтроки);
			СтрокиРодителя.Сдвинуть(Индекс, -1);
		Исключение
		КонецПопытки;
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	
	ТС = Элементы.ТабличноеПолеПерехода.ТекущаяСтрока;
	ДанныеСтроки = ТабличноеПолеПерехода.НайтиПоИдентификатору(ТС);
	
	Если ДанныеСтроки.ЯвляетсяУсловием 
	   И (ДанныеСтроки.ОбработкаУсловия = 1
	 ИЛИ ДанныеСтроки.ОбработкаУсловия = 2
	 ИЛИ ДанныеСтроки.ОбработкаУсловия = 5) Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		
		Родитель = ДанныеСтроки.ПолучитьРодителя();
		Если Родитель = Неопределено Тогда
			СтрокиРодителя = ТабличноеПолеПерехода.ПолучитьЭлементы();
		Иначе
			СтрокиРодителя = Родитель.ПолучитьЭлементы();
		КонецЕсли;
		
		Индекс = СтрокиРодителя.Индекс(ДанныеСтроки);
		СтрокиРодителя.Сдвинуть(Индекс, 1);
		
	Исключение
		
	КонецПопытки;

КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьУсловия(Команда)
	
	УправлениеВидимостьюВариантовОтбора(НЕ ОтображатьВариантыОтборов);
	
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	
	ОповеститьОВыборе(СохранитьНастройкиВХранилище(ВладелецФормы.УникальныйИдентификатор));
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ.
//
&НаКлиенте
Процедура УстановитьОтображениеДействия(ИдентификаторСтроки)
	
	ТекущаяСтрока = ТабличноеПолеПерехода.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	Если ТекущаяСтрока.ЯвляетсяУсловием Тогда
		Если ТекущаяСтрока.ОбработкаУсловия = 0 Тогда
			ТекущаяСтрока.ОтображениеДействия = 0;
			ТекущаяСтрока.ОтображениеДействияТекст = ?(ТекущаяСтрока.УсловиеДействие = ПараметрическоеУсловие, "Если выполняются", "Если");
		ИначеЕсли ТекущаяСтрока.ОбработкаУсловия = 1 Тогда
			ТекущаяСтрока.ОтображениеДействия = 4;
			ТекущаяСтрока.ОтображениеДействияТекст = "Тогда";
		ИначеЕсли ТекущаяСтрока.ОбработкаУсловия = 2 Тогда
			ТекущаяСтрока.ОтображениеДействия = 5;
			ТекущаяСтрока.ОтображениеДействияТекст = "Иначе";
		ИначеЕсли ТекущаяСтрока.ОбработкаУсловия = 3 Тогда
			ТекущаяСтрока.ОтображениеДействия = 6;
			ТекущаяСтрока.ОтображениеДействияТекст = "Выбор";
		ИначеЕсли ТекущаяСтрока.ОбработкаУсловия = 4 Тогда
			ТекущаяСтрока.ОтображениеДействияТекст = ?(ТекущаяСтрока.УсловиеДействие = ПараметрическоеУсловие, "Когда выполняются", "Когда");
			ТекущаяСтрока.ОтображениеДействия = 7;
		ИначеЕсли ТекущаяСтрока.ОбработкаУсловия = 5 Тогда
			ТекущаяСтрока.ОтображениеДействияТекст = "Иначе";
			ТекущаяСтрока.ОтображениеДействия = 8;
		КонецЕсли;
	Иначе
		ТекущаяСтрока.ОтображениеДействияТекст = "Выполнить действие: ";
		РезультатПоиска = СписокВозможныхДействий.НайтиПоЗначению(ТекущаяСтрока.УсловиеДействие);
		Если РезультатПоиска <> Неопределено Тогда
			ТекущаяСтрока.ОтображениеДействия = Число(РезультатПоиска.Представление);
		Иначе
			ТекущаяСтрока.ОтображениеДействия = 1;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтображениеДействияДляСтрокиДерева(ТекущийЭлемент)
	
	ЭлементыДерева = ТекущийЭлемент.ПолучитьЭлементы();
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		
		УстановитьОтображениеДействия(ЭлементДерева.ПолучитьИдентификатор());
		УстановитьОтображениеДействияДляСтрокиДерева(ЭлементДерева);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПривестиЗначениеКТипу(ИдентификаторСтроки)
	
	ТекущиеДанные = ТабличноеПолеПерехода.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если ТекущиеДанные.ЯвляетсяУсловием = 0 Тогда
			
			ОписаниеТипов          = Новый ОписаниеТипов("СправочникСсылка.ЭтапыСогласования");
			ТекЗначение            = ТекущиеДанные.Значение;
			ТекущиеДанные.Значение = ОписаниеТипов.ПривестиЗначение(ТекЗначение);
			
		Иначе
			
			ОписаниеТиповЗначение = СоответствиеУсловийИТиповЗначений.НайтиПоЗначению(ТекущиеДанные.УсловиеДействие);
			Если ОписаниеТиповЗначение = Неопределено Тогда
				НайденныеСтроки = КэшВидовСубконто.НайтиСтроки(Новый Структура("Ссылка", ТекущиеДанные.УсловиеДействие));
				Если НайденныеСтроки.Количество() > 0 Тогда
					
					ОписаниеТипов = НайденныеСтроки[0].ТипЗначения;
					
				КонецЕсли;
			Иначе
				ОписаниеТипов = Новый ОписаниеТипов(ОписаниеТиповЗначение.Представление);
			КонецЕсли;
			
		КонецЕсли;
		
		Если ТекущиеДанные.Значение = ВидСравнения.ВСписке ИЛИ ТекущиеДанные.Значение = ВидСравнения.НеВСписке Тогда
			
			ОписаниеСписок = Новый ОписаниеТипов("СписокЗначений");
			ТекЗначение    = ОписаниеСписок.ПривестиЗначение(ТекущиеДанные.ЗначениеОтбора);
			ТекущиеДанные.ЗначениеОтбора = ТекЗначение;
			ТекущиеДанные.ЗначениеОтбора.ТипЗначения = ОписаниеТипов;
			
		Иначе
			
			ТекЗначение = ОписаниеТипов.ПривестиЗначение(ТекущиеДанные.ЗначениеОтбора);
			ТекущиеДанные.ЗначениеОтбора = ТекЗначение;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СохранитьНастройкиВХранилище(ИдентификаторФормыВладельца)
	
	Вн_ТабличноеПолеПерехода = РеквизитФормыВЗначение("ТабличноеПолеПерехода");
	Вн_ТабличноеПолеПерехода.Колонки.Удалить("ОтображениеДействияТекст");
	Возврат ПоместитьВоВременноеХранилище(РеквизитФормыВЗначение("ТабличноеПолеПерехода"), ИдентификаторФормыВладельца);
	
КонецФункции

&НаСервере
Процедура УправлениеВидимостьюВариантовОтбора(ВидимостьВариантов)
	
	ОтображатьВариантыОтборов = ВидимостьВариантов;
	Элементы.ТабличноеПолеПереходаОтобразитьУсловия.Пометка = ОтображатьВариантыОтборов;
	Элементы.ДеревоОтборов.Видимость = ОтображатьВариантыОтборов;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ МОДИФИКАЦИИ/ДОБАВЛЕНИЯ/УДАЛЕНИЯ ВЕТВЕЙ УСЛОВНОГО ПЕРЕХОДА.
//
&НаКлиенте
Функция ОпределитьСтрокуВыбора(ИдентификаторСтроки)
	ТекСтрока = ТабличноеПолеПерехода.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	Если ТекСтрока.ЯвляетсяУсловием И ТекСтрока.ОбработкаУсловия = 3 Тогда
		Возврат ИдентификаторСтроки;
	КонецЕсли;
	
	РодительСтроки = ТекСтрока.ПолучитьРодителя();
	
	Если РодительСтроки = Неопределено Тогда
		Возврат Неопределено;
	Иначе
		Возврат ОпределитьСтрокуВыбора(РодительСтроки.ПолучитьИдентификатор());
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ВставитьУсловие(ИдентификаторСтроки = Неопределено)
	
	Если ИдентификаторСтроки = Неопределено Тогда
		НоваяСтрока = ТабличноеПолеПерехода.ПолучитьЭлементы().Добавить();
	Иначе
		ТекСтрока = ТабличноеПолеПерехода.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		Если ТекСтрока.ЯвляетсяУсловием Тогда
			Если ТекСтрока.ОбработкаУсловия = 0 ИЛИ ТекСтрока.ОбработкаУсловия = 3 Тогда
				ТекРодитель = ТекСтрока.ПолучитьРодителя();
				
				Если ТекРодитель = Неопределено Тогда
					ТекРодитель = ТабличноеПолеПерехода;
				КонецЕсли;
				СтрокиРодителя = ТекРодитель.ПолучитьЭлементы();
				Индекс = СтрокиРодителя.Индекс(ТекСтрока);
				НоваяСтрока = СтрокиРодителя.Вставить(Индекс - 1);
			Иначе
				НоваяСтрока = ТекСтрока.ПолучитьЭлементы().Вставить(0);
			КонецЕсли;
		Иначе
			
			ТекРодитель = ТекСтрока.ПолучитьРодителя();
			Если ТекРодитель = Неопределено Тогда
				ТекРодитель = ТабличноеПолеПерехода;
			КонецЕсли;
			
			СтрокиРодителя = ТекРодитель.ПолучитьЭлементы();
			Индекс = СтрокиРодителя.Индекс(ТекСтрока);
			НоваяСтрока = СтрокиРодителя.Вставить(Индекс - 1);
		КонецЕсли;
		
	КонецЕсли;
	
	НоваяСтрока.ЯвляетсяУсловием = Истина;
	НоваяСтрока.ОбработкаУсловия = 0;
	СтрокаИстина = НоваяСтрока.ПолучитьЭлементы().Добавить();
	СтрокаИстина.ЯвляетсяУсловием = Истина;
	СтрокаИстина.ОбработкаУсловия = 1;
	СтрокаЛожь = НоваяСтрока.ПолучитьЭлементы().Добавить();
	СтрокаЛожь.ЯвляетсяУсловием = Истина;
	СтрокаЛожь.ОбработкаУсловия = 2;
	
	УстановитьОтображениеДействия(НоваяСтрока.ПолучитьИдентификатор());
	УстановитьОтображениеДействия(СтрокаИстина.ПолучитьИдентификатор());
	УстановитьОтображениеДействия(СтрокаЛожь.ПолучитьИдентификатор());
	
	Элементы.ТабличноеПолеПерехода.Развернуть(НоваяСтрока.ПолучитьИдентификатор(), Истина);
	
	Возврат НоваяСтрока.ПолучитьИдентификатор();
	
КонецФункции

&НаКлиенте
Процедура ВставитьВыбор(ИдентификаторСтроки = Неопределено)
	
	Если ИдентификаторСтроки = Неопределено Тогда
		НоваяСтрока = ТабличноеПолеПерехода.ПолучитьЭлементы().Добавить();
	Иначе
		
		ТекСтрока = ТабличноеПолеПерехода.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ТекСтрока.ЯвляетсяУсловием Тогда
			Если ТекСтрока.ОбработкаУсловия = 0 ИЛИ ТекСтрока.ОбработкаУсловия = 3 Тогда
				ТекРодитель = ТекСтрока.ПолучитьРодителя();
				Если ТекРодитель = Неопределено Тогда
					ТекРодитель = ТабличноеПолеПерехода;
				КонецЕсли;
				СтрокиРодителя = ТекРодитель.ПолучитьЭлементы();
				Индекс = СтрокиРодителя.Индекс(ТекСтрока);
				НоваяСтрока = СтрокиРодителя.Вставить(Индекс);
			Иначе
				НоваяСтрока = ТекСтрока.ПолучитьЭлементы().Вставить(0);
			КонецЕсли;
		Иначе
			
			ТекРодитель = ТекСтрока.ПолучитьРодителя();
			Если ТекРодитель = Неопределено Тогда
				ТекРодитель = ТабличноеПолеПерехода;
			КонецЕсли;
			
			СтрокиРодителя = ТекРодитель.ПолучитьЭлементы();
			Индекс = СтрокиРодителя.Индекс(ТекСтрока);
			НоваяСтрока = СтрокиРодителя.Вставить(Индекс);
			
		КонецЕсли;
		
	КонецЕсли;
	
	НоваяСтрока.ЯвляетсяУсловием = Истина;
	НоваяСтрока.ОбработкаУсловия = 3;
	УстановитьОтображениеДействия(НоваяСтрока.ПолучитьИдентификатор());
	
	СтрокаИначе = НоваяСтрока.ПолучитьЭлементы().Добавить();
	СтрокаИначе.ЯвляетсяУсловием = Истина;
	СтрокаИначе.ОбработкаУсловия = 5;
	УстановитьОтображениеДействия(СтрокаИначе.ПолучитьИдентификатор());
	
	Элементы.ТабличноеПолеПерехода.Развернуть(НоваяСтрока.ПолучитьИдентификатор(), Истина);
	Элементы.ТабличноеПолеПерехода.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	
КонецПроцедуры

&НаКлиенте
Функция ВставитьУсловиеВыбора(ИдентификаторСтроки)
	
	ТекСтрока = ТабличноеПолеПерехода.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	Если ТекСтрока.ОбработкаУсловия = 3 Тогда
		НоваяСтрока = ТекСтрока.ПолучитьЭлементы().Вставить(0);
	ИначеЕсли ТекСтрока.ОбработкаУсловия = 4 Тогда
		ТекРодитель = ТекСтрока.ПолучитьРодителя();
		
		Если ТекРодитель = Неопределено Тогда
			ТекРодитель = ТабличноеПолеПерехода;
		КонецЕсли;
		СтрокиРодителя = ТекРодитель.ПолучитьЭлементы();
		Индекс   = СтрокиРодителя.Индекс(ТекСтрока);
		НоваяСтрока = СтрокиРодителя.Вставить(Индекс);
		
	ИначеЕсли ТекСтрока.ОбработкаУсловия = 5 Тогда
		
		ТекРодитель = ТекСтрока.ПолучитьРодителя();
		Если ТекРодитель = Неопределено Тогда
			ТекРодитель = ТабличноеПолеПерехода;
		КонецЕсли;
		
		СтрокиРодителя = ТекРодитель.ПолучитьЭлементы();
		Индекс   = СтрокиРодителя.Индекс(ТекСтрока);
		НоваяСтрока = СтрокиРодителя.Вставить(Индекс);
		
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	НоваяСтрока.ЯвляетсяУсловием = Истина;
	НоваяСтрока.ОбработкаУсловия = 4;
	УстановитьОтображениеДействия(НоваяСтрока.ПолучитьИдентификатор());
	
	Возврат НоваяСтрока.ПолучитьИдентификатор();
	
КонецФункции

&НаКлиенте
Процедура ТабличноеПолеПереходаЗначениеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТабличноеПолеПерехода.ДанныеСтроки(Элементы.ТабличноеПолеПерехода.ТекущаяСтрока);
	//ТекущиеДанные.Значение = ВидСравнения.Равно;
	ПривестиЗначениеКТипу(Элементы.ТабличноеПолеПерехода.ТекущаяСтрока);

КонецПроцедуры





////////////////////////////////////////////////////////////////////////////////







