
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Сценарий = Константы.СценарийМСФО.Получить();
	
	ТекПериодичность = ?(Объект.Сценарий.Периодичность.Пустая(), Перечисления.Периодичность.Год, Объект.Сценарий.Периодичность);
	
	Объект.Организация = ОбщегоНазначенияУХ.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	//Объект.ПериодНачисления = ОбщегоНазначенияУХ.глОтносительныйПериодПоДате(ТекущаяДата(), ТекПериодичность, -1);
	//Объект.ПериодСценария = ОбщегоНазначенияУХ.глОтносительныйПериодПоДате(ТекущаяДата(), ТекПериодичность, 0);
	Объект.ПериодНачисления = Новый СтандартныйПериод(ВариантСтандартногоПериода.ПрошлыйГод);
	Объект.ПериодСценария = Новый СтандартныйПериод(ВариантСтандартногоПериода.ЭтотГод);
	
	ПодготовитьЗапросФакта();
	
	УстановитьОтборыПоРеквизиту("Сценарий");
	УстановитьОтборыПоРеквизиту("Организация");
	УстановитьОтборыПоРеквизиту("ПериодНачисления");
	УстановитьОтборыПоРеквизиту("ПериодСценария");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	УстановитьОтборыПоРеквизиту(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура СценарийПриИзменении(Элемент)
	УстановитьОтборыПоРеквизиту(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ПериодСценарияПриИзменении(Элемент)
	УстановитьОтборыПоРеквизиту(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	УстановитьОтборыПоРеквизиту(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	УстановитьОтборыПоРеквизиту(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачисленияПриИзменении(Элемент)
	УстановитьОтборыПоРеквизиту(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПланПриАктивизацииСтроки(Элемент)
	
	ТекДанные = Элементы.ДокументыПлан.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		ЗначениеОтбор = Неопределено;
	Иначе
		ЗначениеОтбор = ТекДанные.Ссылка;
	КонецЕсли;
	
	ОтборыСписковКлиентСерверУХ.ИзменитьЭлементОтбораСписка(Сопоставление, "ДокументПлан",  ЗначениеОтбор, Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФактНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ПараметрыПеретаскивания.Значение = Новый Массив;	
	Для каждого ИндексСтроки Из Элемент.ВыделенныеСтроки Цикл
		
		текСтрока = Элементы.ДокументыФакт.ДанныеСтроки(ИндексСтроки);
		
		Если (текСтрока.Сумма <> NULL) И (текСтрока.Сумма = текСтрока.СуммаФакт) Тогда
			Продолжить; // уже сопоставлен
		КонецЕсли;
		
		ПараметрыПеретаскивания.Значение.Добавить(Новый Структура("Ссылка,Сумма", текСтрока.Ссылка, текСтрока.Сумма));
		
	КонецЦикла;	
	
	Если ПараметрыПеретаскивания.Значение.Количество() = 0 Тогда
		
		ИмяИсточникаПеретаскивания = "ДокументыФакт";
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
				
		Возврат;
		
	КонецЕсли;
	
	ИмяИсточникаПеретаскивания = "ДокументыФакт";
	
КонецПроцедуры

&НаКлиенте
Процедура СопоставлениеПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	// Создаем запись в регистре сведений. Обновляем интерфейс
	Если ИмяИсточникаПеретаскивания <> "ДокументыФакт" Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыПеретаскивания.Значение.Количество() = 0 Тогда		
		Возврат;
	КонецЕсли;
	
	ТекДанныеПлан = Элементы.ДокументыПлан.ТекущиеДанные;
	Если (ТекДанныеПлан = Неопределено) Или ТекДанныеПлан.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
		
	ОстатокПланаДляСопоставления = ТекДанныеПлан.Сумма - ТекДанныеПлан.СуммаФакт;
	Если (ОстатокПланаДляСопоставления <= 0) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьСопоставления(ТекДанныеПлан.Ссылка, ОстатокПланаДляСопоставления, ПараметрыПеретаскивания.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура СопоставлениеПослеУдаления(Элемент)
		
	Элементы.Сопоставление.Обновить();
	Элементы.ДокументыПлан.Обновить();
	Элементы.ДокументыФакт.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьКорректировки(Команда)
	СформироватьКорректировкиНаСервере();		
КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыФункции

Функция ПолучитьОписаниеДокументовФакта()

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДокументыБД.Ссылка,
	|	ДокументыБД.РеквизитКонтрагент,
	|	ДокументыБД.РеквизитДоговорКонтрагента,
	|	ДокументыБД.РеквизитСуммыДокумента,
	|	ДокументыБД.Наименование
	|ИЗ
	|	Справочник.ДокументыБД КАК ДокументыБД
	|ГДЕ
	|	(ДокументыБД.РеквизитКонтрагент <> """"
	|			ИЛИ ДокументыБД.РеквизитДоговорКонтрагента <> """"
	|			ИЛИ ДокументыБД.РеквизитСуммыДокумента <> """")
	|	И НЕ ДокументыБД.ПометкаУдаления
	|	И ДокументыБД.Ссылка В
	|			(ВЫБРАТЬ
	|				Реквизиты.Ссылка
	|			ИЗ
	|				Справочник.ДокументыБД.Реквизиты КАК Реквизиты
	|			ГДЕ
	|				Реквизиты.Имя = ""Организация"")");

	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

&НаСервере
Функция ТекстЗапроса_ШаблонФакт()

	Возврат 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДокументФакт.Ссылка КАК Ссылка,
	|	ДокументФакт.Проведен КАК Проведен,
	|	ДокументФакт.Организация КАК Организация,
	|	ДокументФакт.Номер КАК Номер,
	|	ДокументФакт.Дата КАК Дата,
	|	ДокументФакт.Контрагент КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК ДоговорКонтрагента,
	|	ДокументФакт.СуммаДокумента КАК Сумма,
	|	ЕСТЬNULL(ЗапросИтогиСопоставленияПланФакт.СуммаФакт, 0) КАК СуммаФакт
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК ДокументФакт
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			СопоставлениеПланФактОперацийНачисленияМСФО.ДокументФакт КАК СсылкаФакт,
	|			СУММА(СопоставлениеПланФактОперацийНачисленияМСФО.СуммаФакт) КАК СуммаФакт
	|		ИЗ
	|			РегистрСведений.СопоставлениеПланФактОперацийНачисленияМСФО КАК СопоставлениеПланФактОперацийНачисленияМСФО
	|		
	|		СГРУППИРОВАТЬ ПО
	|			СопоставлениеПланФактОперацийНачисленияМСФО.ДокументФакт) КАК ЗапросИтогиСопоставленияПланФакт
	|		ПО ДокументФакт.Ссылка = ЗапросИтогиСопоставленияПланФакт.СсылкаФакт
	|ГДЕ
	|	НЕ ДокументФакт.ПометкаУдаления";

КонецФункции

&НаСервере
Процедура ПодготовитьЗапросФакта()
	
	ОписанияДокументовФакта = ПолучитьОписаниеДокументовФакта();
	ТекстЗапросаШаблон = ТекстЗапроса_ШаблонФакт();// Необходимо изменить запрос в соответствии с документами факт
	
	ТекстЗапроса = "";
	
	флУдалитьРазрешенные = Истина;	
	Для Каждого СтрокаДокументаФакт Из ОписанияДокументовФакта Цикл
		
		ИмяДокумента = СтрокаДокументаФакт.Наименование;
		МетаданныеДокумента = Метаданные.Документы.Найти(ИмяДокумента);
		Если МетаданныеДокумента = Неопределено Тогда
			Продолжить; // Нет такого документа
		КонецЕсли;
		
		Если НЕ ПравоДоступа("Просмотр", МетаданныеДокумента) Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяРеквизитаКонтрагент = СтрокаДокументаФакт.РеквизитКонтрагент;
		флНестандартныйРеквизитКонтрагента = (ИмяРеквизитаКонтрагент <> "Контрагент");
		
		ИмяРеквизитаДоговор = СтрокаДокументаФакт.РеквизитДоговорКонтрагента;
		флНестандартныйРеквизитДоговор = (ИмяРеквизитаДоговор <> "ДоговорКонтрагента");
		
		ИмяРеквизитаСумма = СтрокаДокументаФакт.РеквизитСуммыДокумента;
		флНестандартныйРеквизитСумма = (ИмяРеквизитаСумма <> "СуммаДокумента");
		
		флНетКонтрагента = (ИмяРеквизитаКонтрагент = "");
		флНетДоговора = (ИмяРеквизитаДоговор = "");
		флНетСуммы = (ИмяРеквизитаСумма = "");
		
		Если ТекстЗапроса <> "" Тогда
			ТекстЗапроса = ТекстЗапроса + Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС + Символы.ПС;
		КонецЕсли;
		
		ТекТекстЗапроса = СтрЗаменить(ТекстЗапросаШаблон, "Документ.РеализацияТоваровУслуг", "Документ." + ИмяДокумента);
		
		Если флНетКонтрагента Тогда
			ТекТекстЗапроса = СтрЗаменить(ТекТекстЗапроса, "ДокументФакт.Контрагент", "ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)");
		ИначеЕсли флНестандартныйРеквизитКонтрагента Тогда
			ТекТекстЗапроса = СтрЗаменить(ТекТекстЗапроса, "ДокументФакт.Контрагент", "ДокументФакт." + ИмяРеквизитаКонтрагент);				
		КонецЕсли;
		
		Если флНетДоговора Тогда
			ТекТекстЗапроса = СтрЗаменить(ТекТекстЗапроса, "ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)", "ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)");
		ИначеЕсли флНестандартныйРеквизитКонтрагента Тогда
			ТекТекстЗапроса = СтрЗаменить(ТекТекстЗапроса, "ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)", "ДокументФакт." + ИмяРеквизитаДоговор);
		КонецЕсли;
		
		Если флНетСуммы Тогда
		    ТекТекстЗапроса = СтрЗаменить(ТекТекстЗапроса, "ДокументФакт.СуммаДокумента", "0");		
		КонецЕсли; Если флНестандартныйРеквизитСумма Тогда
			ТекТекстЗапроса = СтрЗаменить(ТекТекстЗапроса, "ДокументФакт.СуммаДокумента", "ДокументФакт." + ИмяРеквизитаСумма);
		КонецЕсли;
		
		Попытка
		    ЕстьНомер = МетаданныеДокумента.СтандартныеРеквизиты.Номер.Имя; 		
		Исключение
		    ТекТекстЗапроса = СтрЗаменить(ТекТекстЗапроса, "ДокументФакт.Номер", " ""-"" ");//не используется нумерация		
		КонецПопытки;

		ТекстЗапроса = ТекстЗапроса + ТекТекстЗапроса;
		Если флУдалитьРазрешенные Тогда
			флУдалитьРазрешенные = ЛОжь;
			ТекстЗапросаШаблон = СтрЗаменить(ТекстЗапросаШаблон, "ВЫБРАТЬ РАЗРЕШЕННЫЕ", "ВЫБРАТЬ");
		КонецЕсли;
		
	КонецЦикла;
	
	ЕстьОписанияФакта = ОписанияДокументовФакта.Количество() > 0;
	Если ЕстьОписанияФакта Тогда
		ДокументыФакт.ТекстЗапроса = ТекстЗапроса;
		Элементы.ДокументыФакт.Обновить();
	КонецЕсли;
	
	Элементы.ГруппаДокументыФакт.Видимость = ЕстьОписанияФакта;
	Элементы.НеЗаполненыРеквизитыДокументовБД.Видимость = Не ЕстьОписанияФакта;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИлиСнятьОтбор(Отбор, ПолеКомпоновки, ВидСравнения, Значение)
	
	Если ЗначениеЗаполнено(Значение) Тогда
		ТиповыеОтчеты_УправляемыйРежимУХ.УстановитьОтбор(Отбор, ПолеКомпоновки, ВидСравнения, Значение);
	Иначе
		Элемент = ТиповыеОтчеты_УправляемыйРежимУХ.ВернутьЭлементОтбора(Отбор, ПолеКомпоновки);
		Если Элемент <> Неопределено Тогда
			Элемент.Использование = Ложь;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыПоРеквизиту(ИмяРеквизита)
	
	ТекЗначение = Объект[ИмяРеквизита];
	
	Если (ИмяРеквизита = "ПериодНачисления") Тогда
		
		УстановитьОтборПериода(ДокументыПлан, "Дата", ТекЗначение);
		Возврат;
		
	ИначеЕсли (ИмяРеквизита = "ПериодСценария") Тогда
		
		УстановитьОтборПериода(ДокументыФакт, "Дата", ТекЗначение);		
		Возврат;
		
	КонецЕсли;
	
	ОтборыСписковКлиентСерверУХ.ИзменитьЭлементОтбораСписка(ДокументыПлан, ИмяРеквизита,  ТекЗначение, ЗначениеЗаполнено(ТекЗначение));
	
	Если ИмяРеквизита <> "Сценарий" Тогда
		ОтборыСписковКлиентСерверУХ.ИзменитьЭлементОтбораСписка(ДокументыФакт, ИмяРеквизита,  ТекЗначение, ЗначениеЗаполнено(ТекЗначение));
	КонецЕсли;
	
	Если ИмяРеквизита = "Организация" Тогда
		ОтборыСписковКлиентСерверУХ.ИзменитьЭлементОтбораСписка(Сопоставление, ИмяРеквизита,  ТекЗначение, ЗначениеЗаполнено(ТекЗначение));
	КонецЕсли;
	
	ДоговорНеЗаполнен = Не ЗначениеЗаполнено(Объект.ДоговорКонтрагента);
	
	Элементы.ДокументыПланКонтрагент.Видимость = Объект.Контрагент.Пустая() И ДоговорНеЗаполнен;
	Элементы.ДокументыФактКонтрагент.Видимость = Объект.Контрагент.Пустая() И ДоговорНеЗаполнен;
	
	Элементы.ДокументыПланДоговорКонтрагента.Видимость = ДоговорНеЗаполнен;
	Элементы.ДокументыФактДоговорКонтрагента.Видимость = ДоговорНеЗаполнен;	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПериода(РеквизитСписок, ИмяРеквизита, ТекЗначение)
	
	ОтборыСписковКлиентСерверУХ.УдалитьЭлементОтбораСписка(РеквизитСписок, ИмяРеквизита);
	
	Если ЗначениеЗаполнено(ТекЗначение.ДатаНачала) Тогда
		
		ОтборыСписковКлиентСерверУХ.УстановитьЭлементОтбораСписка(
				РеквизитСписок, 
				ИмяРеквизита, 
				ТекЗначение.ДатаНачала, 
				ВидСравненияКомпоновкиДанных.БольшеИлиРавно
			);
			
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекЗначение.ДатаОкончания) Тогда
		
		ОтборыСписковКлиентСерверУХ.УстановитьЭлементОтбораСписка(
				РеквизитСписок, 
				ИмяРеквизита, 
				ТекЗначение.ДатаОкончания, 
				ВидСравненияКомпоновкиДанных.МеньшеИлиРавно
			);
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьСопоставления(СсылкаПлан, ОстатокСопоставления, ТаблицаФакта)
	
	Для каждого СтрокаФакт Из ТаблицаФакта Цикл	
		
		Если НЕ ЗначениеЗаполнено(СтрокаФакт.Ссылка) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ОстатокСопоставления <= 0 Тогда
			ТекстСообщения = НСтр("ru = 'Для документ факта <%1> не создано сопоставление, т.к. Сумма документа плана <%1> вся сопоставлена'");
			Сообщить(СтрШаблон(ТекстСообщения, СтрокаФакт.Ссылка, СсылкаПлан));
			Продолжить;
		КонецЕсли;
		
		ТекСопоставление = Мин(СтрокаФакт.Сумма, ОстатокСопоставления);
		ОстатокСопоставления = ОстатокСопоставления - ТекСопоставление;
			
		МенеджерЗаписи = РегистрыСведений.СопоставлениеПланФактОперацийНачисленияМСФО.СоздатьМенеджерЗаписи();
		
		МенеджерЗаписи.Организация 		= СсылкаПлан.Организация;
		МенеджерЗаписи.ДокументПлан 	= СсылкаПлан;
		
		МенеджерЗаписи.ДокументФакт 	= СтрокаФакт.Ссылка;
		МенеджерЗаписи.СуммаФакт 		= ТекСопоставление;
		
		МенеджерЗаписи.Записать();	
		
	КонецЦикла;	
		
	Элементы.Сопоставление.Обновить();
	Элементы.ДокументыПлан.Обновить();
	Элементы.ДокументыФакт.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьКорректировкиНаСервере()
	
	РеквизитФормыВЗначение("Объект").СформироватьКорректировки();
			
	Элементы.Сопоставление.Обновить();
	Элементы.ДокументыПлан.Обновить();
	Элементы.ДокументыФакт.Обновить();

КонецПроцедуры

#КонецОбласти
