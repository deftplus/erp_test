
#Область ОбработкаОсновныхСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьТекущегоСотрудника();
	
	ПараметрВладелецОбъектовВыбора = Неопределено;
	Параметры.Свойство("ВладелецОбъектовВыбора", ПараметрВладелецОбъектовВыбора);
	
	ВладелецОбъектовВыбора = ПараметрВладелецОбъектовВыбора;
	
	ВладелецОбъектовВыбораСтарый = Неопределено;
	ЗаполнитьНастройкиПроцессаВыбора(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеВыбораАльтернатив" Тогда
		Если ТипЗнч(Параметр) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		
		Если Параметр.Идентификатор = ЭтаФорма.УникальныйИдентификатор Тогда
			Возврат;
		КонеЦЕсли;
		
		Если Параметр.Владелец <> ВладелецОбъектовВыбора Тогда
			Возврат;
		КонецЕсли;
		
		ВладелецОбъектовВыбораСтарый = Неопределено;
		ВладелецПриИзмененииНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработкаСобытийЭлементовФормы


&НаКлиенте
Процедура ВладелецОбъектовВыбораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормыВыбора = Новый Структура("Ответственный,ПоказыватьТолькоНезавершенные,ТолькоСПравомВыбора", Сотрудник, ЛОжь, Истина);
	ОткрытьФорму("ОбщаяФорма.ВыборВладельцаОбъектовВыбора", ПараметрыФормыВыбора, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	ВладелецПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСледующемуЭтапу(Команда)
	мВыбранныеСтроки = ОбъектыОценки.НайтиСтроки(Новый Структура("Выбран", Истина));

	Если мВыбранныеСтроки.Количество() = 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		ТекстСообщения = "";
		Если флЭтоПоследнийЭтап Тогда
			ТекстСообщения = НСтр("ru = 'Невозможно завершить процесс выбора: нет выбранных объектов.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Невозможно перейти к следующему этапу: нет выбранных объектов.'");
		КонецЕсли;
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ВладелецОбъектовВыбора) = Тип("СправочникСсылка.Лоты") И флЭтоПоследнийЭтап Тогда
		ПроверкаЗонтичнойЗакупки = ПроверкаПриЗонтичнойЗакупке();
		Если ПроверкаЗонтичнойЗакупки = Ложь Тогда
			Возврат;
		КонецЕсли;
		
		ПроверкаПриЛотовойИПопозиционнойЗакупке = ПроверкаПриЛотовойИПопозиционнойЗакупке();
		Если ПроверкаПриЛотовойИПопозиционнойЗакупке = Ложь Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;		
	ПерейтиКСледующемуЭтапуНаСервере();
	
	ДопПараметры = Новый Структура("Владелец, Идентификатор", ВладелецОбъектовВыбора, ЭтаФорма.УникальныйИдентификатор);
	Оповестить("ОбновитьСостояниеВыбораАльтернатив", ДопПараметры);
КонецПроцедуры

&НаСервере
Функция ПроверкаПриЗонтичнойЗакупке()
	Если ОбщегоНазначенияУХ.ПолучитьЗначениеРеквизита(ВладелецОбъектовВыбора,"ВидЗакупки") = 
		ПредопределенноеЗначение("Перечисление.ВидЛотовойЗакупки.Зонтичная") Тогда
		СписокПредложений = Новый СписокЗначений();
		Для Каждого СтрокаОбъектов ИЗ ОбъектыОценки Цикл
			Если СтрокаОбъектов.Выбран Тогда
				СписокПредложений.Добавить(СтрокаОбъектов.ОбъектОценки);
			КонецЕсли;
		КонецЦикла;	
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("СписокПредложений",СписокПредложений);
		Запрос.УстановитьПараметр("Лот",ВладелецОбъектовВыбора);
		Запрос.Текст =  "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		                |	ЛотыНоменклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		                |	ЛотыНоменклатура.МестоПоставки КАК МестоПоставки,
		                |	ЛотыНоменклатура.Номенклатура КАК Номенклатура,
		                |	ЛотыНоменклатура.Характеристика КАК Характеристика,
		                |	ЛотыНоменклатура.Ссылка КАК Ссылка
		                |ПОМЕСТИТЬ НоменклатураЛота
		                |ИЗ
		                |	Справочник.Лоты.Номенклатура КАК ЛотыНоменклатура
		                |ГДЕ
		                |	ЛотыНоменклатура.Ссылка = &Лот
		                |
		                |СГРУППИРОВАТЬ ПО
		                |	ЛотыНоменклатура.МестоПоставки,
		                |	ЛотыНоменклатура.Номенклатура,
		                |	ЛотыНоменклатура.ЕдиницаИзмерения,
		                |	ЛотыНоменклатура.Характеристика,
		                |	ЛотыНоменклатура.Ссылка
		                |;
		                |
		                |////////////////////////////////////////////////////////////////////////////////
		                |ВЫБРАТЬ РАЗРЕШЕННЫЕ
		                |	УсловияПредложенийПоставщиков.Лот КАК Лот,
		                |	УсловияПредложенийПоставщиков.Номенклатура КАК Номенклатура,
		                |	УсловияПредложенийПоставщиков.Характеристика КАК Характеристика,
		                |	УсловияПредложенийПоставщиков.МестоПоставки КАК МестоПоставки,
		                |	УсловияПредложенийПоставщиков.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		                |	УсловияПредложенийПоставщиков.Регистратор КАК Регистратор
		                |ПОМЕСТИТЬ НоменклатураПредложений
		                |ИЗ
		                |	РегистрСведений.УсловияПредложенийПоставщиков КАК УсловияПредложенийПоставщиков
		                |ГДЕ
		                |	УсловияПредложенийПоставщиков.Регистратор В(&СписокПредложений)
		                |	И УсловияПредложенийПоставщиков.ТоварНеПоставляется = ЛОЖЬ
		                |
		                |СГРУППИРОВАТЬ ПО
		                |	УсловияПредложенийПоставщиков.Лот,
		                |	УсловияПредложенийПоставщиков.ЕдиницаИзмерения,
		                |	УсловияПредложенийПоставщиков.Характеристика,
		                |	УсловияПредложенийПоставщиков.Номенклатура,
		                |	УсловияПредложенийПоставщиков.МестоПоставки,
		                |	УсловияПредложенийПоставщиков.Регистратор
		                |;
		                |
		                |////////////////////////////////////////////////////////////////////////////////
		                |ВЫБРАТЬ
		                |	НоменклатураЛота.Номенклатура КАК Номенклатура,
		                |	СУММА(ВЫБОР
		                |			КОГДА ЕСТЬNULL(НоменклатураПредложений.Регистратор, 0) = 0
		                |				ТОГДА 0
		                |			ИНАЧЕ 1
		                |		КОНЕЦ) КАК КоличествоПобедителейЗонтичнойЗакупки,
		                |	НоменклатураЛота.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		                |	НоменклатураЛота.МестоПоставки КАК МестоПоставки,
		                |	НоменклатураЛота.Характеристика КАК Характеристика
		                |ПОМЕСТИТЬ Итоговая
		                |ИЗ
		                |	НоменклатураЛота КАК НоменклатураЛота
		                |		ЛЕВОЕ СОЕДИНЕНИЕ НоменклатураПредложений КАК НоменклатураПредложений
		                |		ПО НоменклатураЛота.ЕдиницаИзмерения = НоменклатураПредложений.ЕдиницаИзмерения
		                |			И НоменклатураЛота.МестоПоставки = НоменклатураПредложений.МестоПоставки
		                |			И НоменклатураЛота.Номенклатура = НоменклатураПредложений.Номенклатура
		                |			И НоменклатураЛота.Характеристика = НоменклатураПредложений.Характеристика
		                |			И НоменклатураЛота.Ссылка = НоменклатураПредложений.Лот
		                |
		                |СГРУППИРОВАТЬ ПО
		                |	НоменклатураЛота.Номенклатура,
		                |	НоменклатураПредложений.Регистратор,
		                |	НоменклатураЛота.ЕдиницаИзмерения,
		                |	НоменклатураЛота.МестоПоставки,
		                |	НоменклатураЛота.Характеристика
		                |;
		                |
		                |////////////////////////////////////////////////////////////////////////////////
		                |ВЫБРАТЬ
		                |	Итоговая.Номенклатура КАК Номенклатура,
		                |	СУММА(Итоговая.КоличествоПобедителейЗонтичнойЗакупки) КАК КоличествоПобедителейЗонтичнойЗакупки,
		                |	Итоговая.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		                |	Итоговая.МестоПоставки КАК МестоПоставки,
		                |	Итоговая.Характеристика КАК Характеристика
		                |ИЗ
		                |	Итоговая КАК Итоговая
		                |
		                |СГРУППИРОВАТЬ ПО
		                |	Итоговая.Номенклатура,
		                |	Итоговая.МестоПоставки,
		                |	Итоговая.ЕдиницаИзмерения,
		                |	Итоговая.Характеристика";
			КоличествоПобедителейЗонтичнойЗакупки = ОбщегоНазначенияУХ.ПолучитьЗначениеРеквизита(ВладелецОбъектовВыбора,"КоличествоПобедителейЗонтичнойЗакупки");	
			РезультатЗапроса = Запрос.Выполнить();
			Если РезультатЗапроса.Пустой() Тогда
				Сообщение = Новый СообщениеПользователю;
				ТекстСообщения = "";
				ТекстСообщения = НСтр("ru = 'По выбранным предложениям нет необходимой поставляемой номенклатуры'");
				Сообщение.Текст = ТекстСообщения;
				Сообщение.Сообщить();
				Возврат Ложь;
			КонецЕсли;
			Выборка = РезультатЗапроса.Выбрать();
			ЕстьОшибка = Ложь;
			Пока Выборка.Следующий() Цикл
				Если Выборка.КоличествоПобедителейЗонтичнойЗакупки < КоличествоПобедителейЗонтичнойЗакупки Тогда
					Сообщение = Новый СообщениеПользователю;
					ТекстСообщения = "";
					ТекстСообщения = НСтр("ru = 'По условиям зонтичной закупки победителей должно быть %Количество%'");
					ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Количество%", КоличествоПобедителейЗонтичнойЗакупки);
					Сообщение.Текст = ТекстСообщения;
					Сообщение.Сообщить();
					ЕстьОшибка = Истина;
					Прервать;
				КонецЕсли;	
			КонецЦикла;	
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				Если Выборка.КоличествоПобедителейЗонтичнойЗакупки < КоличествоПобедителейЗонтичнойЗакупки Тогда
					Сообщение = Новый СообщениеПользователю;
					ТекстСообщения = "";
					ТекстСообщения = НСтр("ru = 'по номенклатуре %Номенклатура% должно быть не менее %Количество% победителей'");
					ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Номенклатура%", Выборка.Номенклатура);
					ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Количество%", КоличествоПобедителейЗонтичнойЗакупки);
					Сообщение.Текст = ТекстСообщения;
					Сообщение.Сообщить();
					ЕстьОшибка = Истина;
				КонецЕсли;	
			КонецЦикла;	
			Возврат Не ЕстьОшибка;
	Иначе
		Возврат Истина;		
	КонецЕсли;	
	Возврат Истина;	
КонецФункции

&НаСервере
Функция ПроверкаПриЛотовойИПопозиционнойЗакупке()
	Ответ = Истина;
	КоличествоПобедителей = 0 ;
	Для Каждого Ст Из ОбъектыОценки Цикл
		Если Ст.Выбран Тогда
			КоличествоПобедителей = КоличествоПобедителей+1;
		КонецЕсли;
	КонецЦикла;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Лот",ВладелецОбъектовВыбора);
	Запрос.Текст =  "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЛотыНоменклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ЛотыНоменклатура.МестоПоставки КАК МестоПоставки,
	|	ЛотыНоменклатура.Номенклатура КАК Номенклатура,
	|	ЛотыНоменклатура.Характеристика КАК Характеристика,
	|	ЛотыНоменклатура.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Лоты.Номенклатура КАК ЛотыНоменклатура
	|ГДЕ
	|	ЛотыНоменклатура.Ссылка = &Лот
	|
	|СГРУППИРОВАТЬ ПО
	|	ЛотыНоменклатура.МестоПоставки,
	|	ЛотыНоменклатура.Номенклатура,
	|	ЛотыНоменклатура.ЕдиницаИзмерения,
	|	ЛотыНоменклатура.Характеристика,
	|	ЛотыНоменклатура.Ссылка";
	КоличествоСтрок = Запрос.Выполнить().Выгрузить().Количество();
	
	
	Если ВладелецОбъектовВыбора.ОрганизацияДляЗаключенияДоговора.ЗакупкаПоФЗ223 И
		ОбщегоНазначенияУХ.ПолучитьЗначениеРеквизита(ВладелецОбъектовВыбора,"ВидЗакупки") = 
		ПредопределенноеЗначение("Перечисление.ВидЛотовойЗакупки.ПопозиционнаяЗакупка") 
		И КоличествоПобедителей > КоличествоСтрок Тогда
		Сообщение = Новый СообщениеПользователю;
		ТекстСообщения = "";     
		ТекстСообщения = НСтр("ru = 'По условиям попозиционной закупки победителей должно быть не более %Количество%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Количество%", КоличествоСтрок);
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
		Возврат Ложь;
	КонецЕсли;	
	
	Если ОбщегоНазначенияУХ.ПолучитьЗначениеРеквизита(ВладелецОбъектовВыбора,"ВидЗакупки") = 
		ПредопределенноеЗначение("Перечисление.ВидЛотовойЗакупки.ЛотоваяЗакупка") И КоличествоПобедителей > 1 Тогда
		Сообщение = Новый СообщениеПользователю;
		ТекстСообщения = "";
		ТекстСообщения = НСтр("ru = 'По условиям лотовой закупки победителей должно быть не более %Количество%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Количество%", 1);
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
		Возврат Ложь;
	КонецЕсли;	
	Возврат Ответ;	
КонецФункции


&НаКлиенте
Процедура ОбновитьСписокОбъектов(Команда)
	ЗаполнитьТаблицуОбъектовВыбора(Истина);
КонецПроцедуры

&НаКлиенте
Процедура Отчет(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыФормы.Вставить("ПользовательскиеНастройки",
		ОбщегоНазначенияСерверУХ.ЗаполнитьПользовательскиеНастройкиОтчета(
			"ОценкаАльтернатив", Новый Структура("Владелец", ВладелецОбъектовВыбора)));
	ОткрытьФорму("Отчет.ОценкаАльтернатив.ФормаОбъекта", ПараметрыФормы, ЭтаФорма, Истина);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьЗначенияКритериев(Команда)
	Если ЗначениеЗаполнено(ВладелецОбъектовВыбора) Тогда
		РассчитатьЗначенияКритериевНаСервере(ВладелецОбъектовВыбора);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыОценкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекДанные = Элементы.ОбъектыОценки.ТекущиеДанные;
	Если ТекДанные = Неопределено  Тогда
		Возврат;
	КонецЕсли;
	Если Поле.Имя = "ОбъектыОценкиОбъектОценки" Тогда
		Значение = ТекДанные.ОбъектОценки;
		Если ЗначениеЗаполнено(Значение) Тогда
			ПоказатьЗначение(, Значение);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыНаКлиенте


#КонецОбласти

#Область СлужебныеПроцедурыНаСервере


&НаСервере
Процедура ВладелецПриИзмененииНаСервере()
	ЗаполнитьНастройкиПроцессаВыбора();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиПроцессаВыбора(ПроверятьСтарогоВладельца=Истина)
	Если ПроверятьСтарогоВладельца И ВладелецОбъектовВыбораСтарый = ВладелецОбъектовВыбора Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВладелецОбъектовВыбора) Тогда
		НастройкаПроцессаВыбора = ВыборОбъектовУХ.НастройкаПроцессаВыбораВладельца(ВладелецОбъектовВыбора);
	Иначе
		НастройкаПроцессаВыбора = Справочники.НастройкиПроцессаВыбора.ПустаяСсылка();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НастройкаПроцессаВыбора) Тогда
		
		ЭтапыОценки.Загрузить(НастройкаПроцессаВыбора.ЭтапыВыбора.Выгрузить());
		ОписаниеСостояния = ВыборОбъектовУХ.ПолучитьСостояниеПроцессаСУчетомПереторжки(ВладелецОбъектовВыбора);
		
		ЭтапОценки = ОписаниеСостояния.ТекущийЭтапВыбора;
		флВыборЗавершен = ОписаниеСостояния.ПроцессВыбораЗавершен;
		
		флЕстьПоследующаяОценка = НастройкаПроцессаВыбора.ПоследующаяОценка;
		
		КоличествоЧленовКомиссии = ВыборОбъектовУХ.КоличествоЧленовКомиссииЭтапа(НастройкаПроцессаВыбора, ЭтапОценки);
		
		Если КоличествоЧленовКомиссии = 0 Тогда
			КоличествоЧленовКомиссии = 1;
		КонецЕсли;
		
		СтрокаОценочнойКомиссии = НастройкаПроцессаВыбора.ОценочнаяКомиссия.Найти(Сотрудник, "Сотрудник");
		Если ЗначениеЗаполнено(СтрокаОценочнойКомиссии) Тогда
			РазрешитьИзменятьЭтапОценки = СтрокаОценочнойКомиссии.ЗакрываетЭтапОценки;
		КонецЕсли;
		
		мКритерииЭтапа = НастройкаПроцессаВыбора.КритерииОценки.НайтиСтроки(Новый Структура("ЭтапВыбора", ЭтапОценки));
		КоличествоКритериев = мКритерииЭтапа.Количество();
		
	Иначе
		ЭтапыОценки.Очистить();
		ЭтапОценки = Справочники.ЭтапыОценки.ПустаяСсылка();
		флВыборЗавершен = Истина;
		флЕстьПоследующаяОценка = Ложь;
		ОбъектыОценки.Очистить();
		РазрешитьИзменятьЭтапОценки = Ложь;
		КоличествоКритериев = 0;
		КоличествоЧленовКомиссии = 1; // Чтобы не проверять при делении.
	КонецЕсли;
	
	флЕстьНерассчитанныеКритерии = Ложь; // устанавливаем ниже при заполнении таблицы объектов
	флЕстьРасчетныеКритерии = Ложь;
	
	ОбработатьИзменениеЭтапаНаСервере();
	
	ВладелецОбъектовВыбораСтарый = ВладелецОбъектовВыбора;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуОбъектовВыбора(ОбновитьОценки=Ложь)
		
	Если ЗначениеЗаполнено(ВладелецОбъектовВыбора) И ЗначениеЗаполнено(Сотрудник)
		И ЗначениеЗаполнено(ЭтапОценки) Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	МАКСИМУМ(ЗначенияКритериевОценки.Значение) КАК Значение,
			|	ЗначенияКритериевОценки.ЭтапОценки КАК ЭтапОценки,
			|	ЗначенияКритериевОценки.Критерий КАК Критерий
			|ПОМЕСТИТЬ МаксимальныеЗначения
			|ИЗ
			|	РегистрСведений.ЗначенияКритериевОценки КАК ЗначенияКритериевОценки
			|ГДЕ
			|	ЗначенияКритериевОценки.Владелец = &Владелец
			|	И НЕ ЗначенияКритериевОценки.НеЗаполнен
			|
			|СГРУППИРОВАТЬ ПО
			|	ЗначенияКритериевОценки.Критерий,
			|	ЗначенияКритериевОценки.ЭтапОценки
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	СУММА(1) КАК Количество
			|ПОМЕСТИТЬ РасчетныеКритерии
			|ИЗ
			|	Справочник.НастройкиПроцессаВыбора.КритерииОценки КАК НастройкиПроцессаВыбораКритерииОценки
			|ГДЕ
			|	НастройкиПроцессаВыбораКритерииОценки.Ссылка = &НастройкаПроцессаВыбора
			|	И НастройкиПроцессаВыбораКритерииОценки.ЭтапВыбора = &ЭтапВыбора
			|	И НастройкиПроцессаВыбораКритерииОценки.РассчитатьЗначение
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	СостояниеОценкиОбъектов.ОбъектОценки КАК ОбъектОценки,
			|	СУММА(1) КАК ЧислоЗавершившихОценку
			|ПОМЕСТИТЬ ПроцентЗавершенияОценки
			|ИЗ
			|	РегистрСведений.СостояниеОценкиОбъектов КАК СостояниеОценкиОбъектов
			|ГДЕ
			|	СостояниеОценкиОбъектов.Владелец = &Владелец
			|	И СостояниеОценкиОбъектов.Завершен
			|	И СостояниеОценкиОбъектов.ЭтапОценки = &ЭтапВыбора
			|
			|СГРУППИРОВАТЬ ПО
			|	СостояниеОценкиОбъектов.ОбъектОценки
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ЗначенияКритериевОценки.ОбъектОценки КАК ОбъектОценки,
			|	СУММА(ВЫБОР
			|			КОГДА НастройкиПроцессаВыбораКритерииОценки.НеИспользоватьПреобразованиеВБаллы
			|				ТОГДА ВЫБОР
			|						КОГДА ЕСТЬNULL(МаксимальныеЗначения.Значение, 0) - НастройкиПроцессаВыбораКритерииОценки.МинимальноеЗначение = 0
			|							ТОГДА ЗначенияКритериевОценки.Значение - НастройкиПроцессаВыбораКритерииОценки.МинимальноеЗначение
			|						ИНАЧЕ (ЗначенияКритериевОценки.Значение - НастройкиПроцессаВыбораКритерииОценки.МинимальноеЗначение) / (ЕСТЬNULL(МаксимальныеЗначения.Значение, 0) - НастройкиПроцессаВыбораКритерииОценки.МинимальноеЗначение)
			|					КОНЕЦ
			|			ИНАЧЕ ЗначенияКритериевОценки.БалльноеЗначение / 5
			|		КОНЕЦ * ЗначенияКритериевОценки.Вес) КАК Оценка,
			|	СУММА(ВЫБОР
			|			КОГДА ЗначенияКритериевОценки.ЭтапОценки = &ЭтапВыбора
			|					И НЕ ЗначенияКритериевОценки.НеЗаполнен
			|				ТОГДА 1
			|			ИНАЧЕ 0
			|		КОНЕЦ) КАК КоличествоЗаполненных,
			|	СУММА(ВЫБОР
			|			КОГДА ЗначенияКритериевОценки.ЭтапОценки = &ЭтапВыбора
			|					И НЕ ЗначенияКритериевОценки.НеЗаполнен
			|					И ЕСТЬNULL(НастройкиПроцессаВыбораКритерииОценки.РассчитатьЗначение, ЛОЖЬ)
			|				ТОГДА 1
			|			ИНАЧЕ 0
			|		КОНЕЦ) КАК КоличествоЗаполненныхРасчетных,
			|	СУММА(ЗначенияКритериевОценки.Значение) КАК Значение,
			|	СУММА(ЗначенияКритериевОценки.БалльноеЗначение) КАК Балл
			|ПОМЕСТИТЬ ЗначенияКритериев
			|ИЗ
			|	РегистрСведений.ЗначенияКритериевОценки КАК ЗначенияКритериевОценки
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НастройкиПроцессаВыбора.КритерииОценки КАК НастройкиПроцессаВыбораКритерииОценки
			|		ПО ЗначенияКритериевОценки.Критерий = НастройкиПроцессаВыбораКритерииОценки.КритерийОценки
			|			И ЗначенияКритериевОценки.ЭтапОценки = НастройкиПроцессаВыбораКритерииОценки.ЭтапВыбора
			|			И (НастройкиПроцессаВыбораКритерииОценки.Ссылка = &НастройкаПроцессаВыбора)
			|		ЛЕВОЕ СОЕДИНЕНИЕ МаксимальныеЗначения КАК МаксимальныеЗначения
			|		ПО ЗначенияКритериевОценки.ЭтапОценки = МаксимальныеЗначения.ЭтапОценки
			|			И ЗначенияКритериевОценки.Критерий = МаксимальныеЗначения.Критерий
			|ГДЕ
			|	ЗначенияКритериевОценки.Владелец = &Владелец
			|
			|СГРУППИРОВАТЬ ПО
			|	ЗначенияКритериевОценки.ОбъектОценки
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ОбъектыВыбора.Объект КАК ОбъектОценки,
			|	ОбъектыВыбора.Выбран КАК Выбран,
			|	ЕСТЬNULL(ЗначенияКритериев.Оценка, 0) КАК Оценка,
			|	ЕСТЬNULL(ЗначенияКритериев.КоличествоЗаполненных, 0) КАК КоличествоЗаполненных,
			|	&КоличествоКритериев КАК КоличествоКритериев,
			|	&КоличествоКритериев - ЕСТЬNULL(ЗначенияКритериев.КоличествоЗаполненных, 0) КАК НеЗаполнено,
			|	(ЕСТЬNULL(ПроцентЗавершенияОценки.ЧислоЗавершившихОценку, 0) + ВЫБОР
			|		КОГДА ЕСТЬNULL(РасчетныеКритерии.Количество, 0) > 0
			|				И ЕСТЬNULL(ЗначенияКритериев.КоличествоЗаполненныхРасчетных, 0) >= ЕСТЬNULL(РасчетныеКритерии.Количество, 0)
			|			ТОГДА 1
			|		ИНАЧЕ 0
			|	КОНЕЦ) * 100 / (&КоличествоЧленовКомиссии + ВЫБОР
			|		КОГДА ЕСТЬNULL(РасчетныеКритерии.Количество, 0) > 0
			|			ТОГДА 1
			|		ИНАЧЕ 0
			|	КОНЕЦ) КАК ОценкаЗавершена,
			|	ВЫБОР
			|		КОГДА ЕСТЬNULL(ПроцентЗавершенияОценки.ЧислоЗавершившихОценку, 0) = &КоличествоЧленовКомиссии
			|				И ЕСТЬNULL(ЗначенияКритериев.КоличествоЗаполненныхРасчетных, 0) >= ЕСТЬNULL(РасчетныеКритерии.Количество, 0)
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ ЛОЖЬ
			|	КОНЕЦ КАК флМожноВыбрать,
			|	ВЫБОР
			|		КОГДА ЕСТЬNULL(ЗначенияКритериев.КоличествоЗаполненныхРасчетных, 0) < ЕСТЬNULL(РасчетныеКритерии.Количество, 0)
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ ЛОЖЬ
			|	КОНЕЦ КАК флРасчетныеНезаполнены,
			|	ЗначенияКритериев.Значение КАК Значение,
			|	ЗначенияКритериев.Балл КАК Балл
			|ИЗ
			|	РегистрСведений.ОбъектыВыбора КАК ОбъектыВыбора
			|		ЛЕВОЕ СОЕДИНЕНИЕ ЗначенияКритериев КАК ЗначенияКритериев
			|		ПО ОбъектыВыбора.Объект = ЗначенияКритериев.ОбъектОценки
			|		ЛЕВОЕ СОЕДИНЕНИЕ ПроцентЗавершенияОценки КАК ПроцентЗавершенияОценки
			|		ПО ОбъектыВыбора.Объект = ПроцентЗавершенияОценки.ОбъектОценки
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПереторжкаЗакупок.СрезПоследних КАК ПереторжкаЗакупокСрезПоследних
			|		ПО ОбъектыВыбора.Объект.Лот.ЗакупочнаяПроцедура = ПереторжкаЗакупокСрезПоследних.ЗакупочнаяПроцедура,
			|	РасчетныеКритерии КАК РасчетныеКритерии
			|ГДЕ
			|	ОбъектыВыбора.Владелец = &Владелец
			|	И ОбъектыВыбора.ЭтапВыбора = &ЭтапВыбора
			|	И ОбъектыВыбора.Объект.НомерПереторжки = ЕСТЬNULL(ПереторжкаЗакупокСрезПоследних.НомерПереторжки, 0)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	РасчетныеКритерии.Количество > 0 КАК флЕстьРасчетныеКритерии
			|ИЗ
			|	РасчетныеКритерии КАК РасчетныеКритерии";
		
		НастройкаПроцессаВыбора = ВыборОбъектовУХ.НастройкаПроцессаВыбораВладельца(ВладелецОбъектовВыбора);
		Запрос.УстановитьПараметр("Владелец", ВладелецОбъектовВыбора);
		Запрос.УстановитьПараметр("НастройкаПроцессаВыбора", НастройкаПроцессаВыбора);
		Запрос.УстановитьПараметр("ЭтапВыбора", ЭтапОценки);
		Запрос.УстановитьПараметр("КоличествоКритериев", КоличествоКритериев);
		Запрос.УстановитьПараметр("КоличествоЧленовКомиссии", КоличествоЧленовКомиссии);
		
		мРезультатЗапроса = Запрос.ВыполнитьПакет();
		
		Если НЕ флВыборЗавершен И ОбновитьОценки Тогда
			ТЗВыборОбъектов = ОбъектыОценки.Выгрузить(,"ОбъектОценки,Выбран");
		КонецЕсли;
		
		ОбъектыОценки.Загрузить(мРезультатЗапроса[4].Выгрузить());
		
		ТЗКоличествоРасчетныхКритериев = мРезультатЗапроса[5].Выгрузить();
		Если ТЗКоличествоРасчетныхКритериев.Количество() = 0 Тогда
			флЕстьРасчетныеКритерии = Ложь;
		Иначе
			флЕстьРасчетныеКритерии = ТЗКоличествоРасчетныхКритериев[0].флЕстьРасчетныеКритерии;
		КонецЕсли;
		
		флЕстьНерассчитанныеКритерии = Ложь;
		ДЛя Каждого СтрокаОценки Из ОбъектыОценки Цикл
			флЕстьНерассчитанныеКритерии = флЕстьНерассчитанныеКритерии
				ИЛИ СтрокаОценки.флРасчетныеНезаполнены;
			
			Если НЕ флВыборЗавершен И ОбновитьОценки Тогда
				мСтрок = ТЗВыборОбъектов.НайтиСтроки(Новый Структура("ОбъектОценки", СтрокаОценки.ОбъектОценки));
				Если мСтрок.Количество() > 0 Тогда
					СтрокаОценки.Выбран = мСтрок[0].Выбран;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		
	Иначе
		ОбъектыОценки.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущегоСотрудника()
	
	Сотрудник = Пользователи.ТекущийПользователь().ФизическоеЛицо;
	РазрешитьИзменятьЭтапОценки = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Сотрудник) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Пользователю не назначено физическое лицо.'");
		Сообщение.Сообщить();
	КонецЕсли;
	
КонецПроцедуры
	
&НаСервере
Процедура ПерейтиКСледующемуЭтапуНаСервере()
	
	флВыборЗавершен = флЭтоПоследнийЭтап;
	
	Если НЕ флЭтоПоследнийЭтап ИЛИ флЕстьПоследующаяОценка Тогда
		//Изменить этап
		мТекущийЭтап = ЭтапыОценки.НайтиСтроки(Новый Структура("Этап",ЭтапОценки));
		Если мТекущийЭтап.Количество() > 0 Тогда
			НомерСтрокиЭтапа = мТекущийЭтап[0].НомерСтроки + 1;
			
			мТекущийЭтап = ЭтапыОценки.НайтиСтроки(Новый Структура("НомерСтроки", НомерСтрокиЭтапа));
			Если мТекущийЭтап.Количество() > 0 Тогда
				ЭтапОценки = мТекущийЭтап[0].Этап;
			Иначе
				ТекстСообщения = НСтр("ru = 'Не найден текущий этап с номером ""%НомерЭтапа%""'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерЭтапа%", Строка(НомерСтрокиЭтапа));
				ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
				Возврат;
			КонецЕсли;
		Иначе
			ТекстСообщения = НСтр("ru = 'Не найден текущий этап ""%ЭтапОценки%""'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЭтапОценки%", Строка(ЭтапОценки));
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// записываем состояние процесса выбора
	ВыборОбъектовУХ.УстановитьСостояниеПроцессаСУчетомПереторжки(ВладелецОбъектовВыбора, ЭтапОценки, флВыборЗавершен);
	
	мВыбранныеСтроки = ОбъектыОценки.НайтиСтроки(Новый Структура("Выбран", Истина));
	Для Каждого СтрокаОбъекта_ Из мВыбранныеСтроки Цикл
		// Записать выбор объектов в регистр сведений
		НаборЗаписей = РегистрыСведений.ОбъектыВыбора.СоздатьНаборЗаписей();
	
		НаборЗаписей.Отбор.Владелец.Установить(ВладелецОбъектовВыбора);
		НаборЗаписей.Отбор.Объект.Установить(СтрокаОбъекта_.ОбъектОценки);
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Объект = СтрокаОбъекта_.ОбъектОценки;
		НоваяЗапись.Владелец = ВладелецОбъектовВыбора;
		НоваяЗапись.ЭтапВыбора = ЭтапОценки;
		НоваяЗапись.Выбран = флВыборЗавершен;
		
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
	ОбработатьИзменениеЭтапаНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеЭтапаНаСервере()
	
	Если ЗначениеЗаполнено(ЭтапОценки) Тогда
		флЭтоПоследнийЭтап = (ЭтапОценки = НастройкаПроцессаВыбора.ПоследнийЭтап);
	Иначе
		флЭтоПоследнийЭтап = ЛОжь;
	КонецЕсли;
	
	ЗаполнитьТаблицуОбъектовВыбора();
	
	Если флВыборЗавершен Тогда
		
		Элементы.ГруппаРассчетКритериев.Видимость = Ложь;
		
		Элементы.ПерейтиКСледующемуЭтапу.Заголовок = НСтр("ru = 'Процесс выбора завершен'");
		Элементы.ПерейтиКСледующемуЭтапу.Доступность = ЛОжь;
		Элементы.ОбъектыОценки.ТолькоПросмотр = Истина;
		
	иначе
		
		Элементы.ГруппаРассчетКритериев.Видимость = флЕстьРасчетныеКритерии;
		Элементы.ФормаРассчитатьЗначенияКритериев.Видимость = Истина;
		Элементы.ДекорацияРассчитайтеЗначения.Видимость = флЕстьНерассчитанныеКритерии;
		
		Элементы.ПерейтиКСледующемуЭтапу.Доступность = РазрешитьИзменятьЭтапОценки;
		Элементы.ОбъектыОценки.ТолькоПросмотр = ЛОжь;
		
		Если флЭтоПоследнийЭтап Тогда
			Элементы.ПерейтиКСледующемуЭтапу.Заголовок = НСтр("ru = 'Завершить процесс выбора'");
		Иначе
			Элементы.ПерейтиКСледующемуЭтапу.Заголовок = НСтр("ru = 'Перейти к следующему этапу'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьЗначенияКритериевНаСервере(ВладелецОбъектовВыбора)
	ВыборОбъектовВызовСервераУХ.РассчитатьЗначенияКритериев(ВладелецОбъектовВыбора);
	ОбработатьИзменениеЭтапаНаСервере();
КонецПроцедуры


#КонецОбласти
