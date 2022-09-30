#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	НалоговыйПериодДата = Дата(?(НалоговыйПериод <= 0, 1, НалоговыйПериод), 12, 31);
	
	ИдентификаторФайла =  Новый УникальныйИдентификатор();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если  Не ПометкаУдаления Тогда
		СформироватьВыходнойФайл();
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ИдентификаторФайла = Новый УникальныйИдентификатор();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьВыходнойФайл()
	ИмяСформированногоФайла = "";
	ТекстФайла = ТекстФайла(ИмяСформированногоФайла);
	
	ЗарплатаКадры.ЗаписатьФайлВАрхив(Ссылка, ИмяСформированногоФайла + ".xml", ТекстФайла);	
КонецПроцедуры	

Функция ТекстФайла(ИмяФайла)
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Ссылка);
	
	
	ВыборкаПоШапкеДокумента = Документы.ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛ.ВыборкаПоШапкеДокумента(МассивСсылок);
	ВыборкаПоШапкеДокумента.Следующий();
	
	ВыборкаПоСтрокамДокумента = Документы.ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛ.ВыборкаПоСтрокамДокумента(МассивСсылок);	
	
	ОрганизацияЭтоФизЛицо = Не ЗарплатаКадры.ЭтоЮридическоеЛицо(ВыборкаПоШапкеДокумента.Организация);
	
	// -----------------------------------------------------------------------------
	// ФОРМИРОВАНИЕ ДЕРЕВА ДАННЫХ
	
	// Загружаем формат файла сведений
	ДеревоФорматаXML = ПолучитьМакет("Формат");
	ТекстФорматаXML = ДеревоФорматаXML.ПолучитьТекст();

	ДеревоФормата = ЗарплатаКадры.ЗагрузитьXMLВДокументDOM(ТекстФорматаXML);	
	
	ДеревоВыгрузки = ЗарплатаКадры.СоздатьДеревоXML();

	ИмяФайла = ИмяФайла(ВыборкаПоШапкеДокумента.Дата, Не ОрганизацияЭтоФизЛицо, ВыборкаПоШапкеДокумента.КодИФНС, ВыборкаПоШапкеДокумента.ОрганизацияИНН, ВыборкаПоШапкеДокумента.ОрганизацияКПП, ИдентификаторФайла);
	
	Атрибуты = Новый Соответствие;
	Атрибуты.Вставить("ИдФайл", ИмяФайла);
	Атрибуты.Вставить("ВерсПрог", РегламентированнаяОтчетность.НазваниеПрограммы());
	Атрибуты.Вставить("ВерсФорм", "5.01");
	УзелЗаявления = ЗарплатаКадры.ДобавитьУзелВДеревоXML(ДеревоВыгрузки, "Файл", "", Атрибуты);
	
	Если ОрганизацияЭтоФизЛицо Тогда
		ФорматФайла = ЗарплатаКадры.ЗагрузитьФорматНабораЗаписей(ДеревоФормата, "Файл", 2);
	Иначе
		ФорматФайла = ЗарплатаКадры.ЗагрузитьФорматНабораЗаписей(ДеревоФормата, "Файл", 1);
	КонецЕсли;	
	
	ФорматЗаявление = ФорматФайла.Документ.Значение;
	ФорматЗаявление.НомЗаяв.Значение = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаПоШапкеДокумента.Номер, Истина, Истина);
	ФорматЗаявление.ДатаДок.Значение = ВыборкаПоШапкеДокумента.Дата;
	ФорматЗаявление.КодНО.Значение = ВыборкаПоШапкеДокумента.КодИФНС;
	
	// Сведения о лице, подписавшем документ
	НаборЗаписейПодписант = ФорматЗаявление.Подписант.Значение;
	НаборЗаписейПодписант.ПрПодп.Значение = Формат(ОрганизацияЭтоФизЛицо,"БЛ=1; БИ=2"); // налоговый агент
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Телефон) Тогда
		НаборЗаписейПодписант.Удалить("Тлф");
	Иначе
		НаборЗаписейПодписант.Тлф.Значение = ВыборкаПоШапкеДокумента.Телефон;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ИННРуководителя) Тогда
		НаборЗаписейПодписант.Удалить("ИННФЛ");
	Иначе
		НаборЗаписейПодписант.ИННФЛ.Значение = ВыборкаПоШапкеДокумента.ИННРуководителя;
	КонецЕсли;
	Если Не ОрганизацияЭтоФизЛицо Тогда
		НаборЗаписейПодписант.ФИО.Значение.Фамилия = ВыборкаПоШапкеДокумента.ФамилияРуководителя;
		НаборЗаписейПодписант.ФИО.Значение.Имя = ВыборкаПоШапкеДокумента.ИмяРуководителя;
		НаборЗаписейПодписант.ФИО.Значение.Отчество = ВыборкаПоШапкеДокумента.ОтчествоРуководителя;
	Иначе
		НаборЗаписейПодписант.Удалить("ФИО");
	КонецЕсли;
	НаборЗаписейПодписант.Удалить("СвПред");
	
	// Сведения о налоговом агенте
	Если ОрганизацияЭтоФизЛицо Тогда
		
		НаборЗаписейОтправитель = ФорматЗаявление.СвНП.Значение.НПФЛ.Значение;
		НаборЗаписейОтправитель.ИННФЛ.Значение = ВыборкаПоШапкеДокумента.ОрганизацияИНН;
		НаборЗаписейОтправитель.ФИО.Значение.Фамилия = ВыборкаПоШапкеДокумента.ФамилияРуководителя;
		НаборЗаписейОтправитель.ФИО.Значение.Имя = ВыборкаПоШапкеДокумента.ИмяРуководителя;
		НаборЗаписейОтправитель.ФИО.Значение.Отчество = ВыборкаПоШапкеДокумента.ОтчествоРуководителя;
		
	Иначе
		
		НаборЗаписейОтправитель = ФорматЗаявление.СвНП.Значение.НПЮЛ.Значение;
		НаборЗаписейОтправитель.НаимОрг.Значение = ВыборкаПоШапкеДокумента.ОрганизацияНаименованиеПолное;
		НаборЗаписейОтправитель.ИННЮЛ.Значение = СокрЛП(ВыборкаПоШапкеДокумента.ОрганизацияИНН);
		НаборЗаписейОтправитель.КПП.Значение = ВыборкаПоШапкеДокумента.ОрганизацияКПП;
		
	КонецЕсли;
	
	ФорматЗаявПрвУмНал = ФорматЗаявление.ЗаявПрвУмНал.Значение;
	ФорматЗаявление.Удалить("ЗаявПрвУмНал");
	
	УзелЗаявления = ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелЗаявления, "Документ", "", ДанныеВыгружаемыеКакАтрибуты(ФорматЗаявление));
	ЗарплатаКадры.ДобавитьИнформациюВДерево(УзелЗаявления, ФорматЗаявление);
	
	ФорматЗаявПрвУмНал.ГодУмНал.Значение = ВыборкаПоШапкеДокумента.НалоговыйПериод;
	ФорматСвНППртд = ФорматЗаявПрвУмНал.СвНППртд.Значение;
	ФорматЗаявПрвУмНал.Удалить("СвНППртд");
	
	УзелЗаявления = ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелЗаявления, "ЗаявПрвУмНал", "", ДанныеВыгружаемыеКакАтрибуты(ФорматЗаявПрвУмНал));
	ЗарплатаКадры.ДобавитьИнформациюВДерево(УзелЗаявления, ФорматЗаявПрвУмНал);
	
	ФорматФизЛица = ФорматСвНППртд.СвНПФЛ.Значение;
	ФорматСвНППртд.Удалить("СвНПФЛ");
	
	УзелДанных = ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелЗаявления, "СвНППртд", "", ДанныеВыгружаемыеКакАтрибуты(ФорматСвНППртд));
	ЗарплатаКадры.ДобавитьИнформациюВДерево(УзелДанных, ФорматСвНППртд);
	
	Пока ВыборкаПоСтрокамДокумента.Следующий() Цикл
		
		// Данные о физическом лице - получателе дохода
		СтруктураДанныхФизЛица = ОбщегоНазначения.СкопироватьРекурсивно(ФорматФизЛица);
		
		СтруктураДанныхФизЛица.ИННФЛ.Значение = ВыборкаПоСтрокамДокумента.ИНН;
		СтруктураДанныхФизЛица.ДатаРожд.Значение = ВыборкаПоСтрокамДокумента.ДатаРождения;
		
		//  Фамилия, Имя, Отчество
		СтруктураДанныхФизЛица.ФИО.Значение.Фамилия = ВыборкаПоСтрокамДокумента.Фамилия;                     
		СтруктураДанныхФизЛица.ФИО.Значение.Имя = ВыборкаПоСтрокамДокумента.Имя;                     
		СтруктураДанныхФизЛица.ФИО.Значение.Отчество = ВыборкаПоСтрокамДокумента.Отчество;

		// Удостоверение личности                                
		НаборЗаписейДокУдЛичности = СтруктураДанныхФизЛица.УдЛичнФЛ.Значение; 
		НаборЗаписейДокУдЛичности.КодВидДок = ВыборкаПоСтрокамДокумента.ВидДокументаКодМВД;
		НаборЗаписейДокУдЛичности.СерНомДок = СокрЛП(ВыборкаПоСтрокамДокумента.СерияДокумента)  + ?(ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.СерияДокумента + ВыборкаПоСтрокамДокумента.НомерДокумента)," ","") + СокрЛП(ВыборкаПоСтрокамДокумента.НомерДокумента);
		НаборЗаписейДокУдЛичности.ДатаДок = ВыборкаПоСтрокамДокумента.ДатаВыдачиДокумента;
		НаборЗаписейДокУдЛичности.ВыдДок = ВыборкаПоСтрокамДокумента.КемВыданДокумент;
	
		Атрибуты = ДанныеВыгружаемыеКакАтрибуты(СтруктураДанныхФизЛица);
		ЗарплатаКадры.ДобавитьИнформациюВДерево(ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелДанных, "СвНПФЛ","", Атрибуты), СтруктураДанныхФизЛица);
	
		
	КонецЦикла;
	
	// Преобразуем дерево в строковое описание XML
	ПотокВыгрузкиXML = ЗарплатаКадры.СоздатьПотокXML();
	ЗарплатаКадры.ЗаписатьУзелДереваXMLВXML(ДеревоВыгрузки, ПотокВыгрузкиXML, "xsi", "http://www.w3.org/2001/XMLSchema-instance");
	// получаем содержимое файла в виде строки
	СтрокаXML = ЗарплатаКадры.ЗаписатьПотокXML(ПотокВыгрузкиXML);
	
	Возврат СтрокаXML
	
КонецФункции	

Функция ИмяФайла(ДатаСоставления, ЭтоЮрЛицо, КодНалоговогоОргана, ИНН, КПП, ИдентификаторФайла) Экспорт
	
    Возврат "SR_ZPRUMNAL"
			+ "_" + КодНалоговогоОргана
			+ "_" + КодНалоговогоОргана
			+ "_" + ?(ЭтоЮрЛицо, СокрЛП(ИНН) + СокрЛП(КПП), СокрЛП(ИНН))
			+ "_" + Формат(ДатаСоставления, "ДФ=ггггММдд")
			+ "_" + ИдентификаторФайла;

КонецФункции

Процедура ПроверитьДанныеДокумента(Отказ) Экспорт 		
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;	
	
	ВыборкаСотрудниковДляПроверки = ВыборкаДанныхДляПроверки();
	
	Пока ВыборкаСотрудниковДляПроверки.СледующийПоЗначениюПоля("НомерСтроки") Цикл
		
		ПроверитьДанныеФизическогоЛица(ВыборкаСотрудниковДляПроверки, ВыборкаСотрудниковДляПроверки.НомерСтроки, Отказ);
		
		
		Если ВыборкаСотрудниковДляПроверки.ЕстьПовторяющиесяСтроки Тогда
			ТекстСообщения = НСтр("ru = 'Данные по сотруднику были введены в документе ранее';
									|en = 'Data on the employee has already been entered into the document'");
			ПутьКДанным = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Сотрудники", ВыборкаСотрудниковДляПроверки.НомерСтроки, "Сотрудник");
			
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, ПутьКДанным, ,Отказ);   
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция ВыборкаДанныхДляПроверки()
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛСотрудники.Сотрудник,
	|	ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛСотрудники.ИНН,
	|	ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛСотрудники.Фамилия,
	|	ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛСотрудники.Имя,
	|	ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛСотрудники.Отчество,
	|	ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛСотрудники.ВидДокумента,
	|	ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛСотрудники.СерияДокумента,
	|	ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛСотрудники.НомерДокумента,
	|	ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛСотрудники.КемВыданДокумент КАК КемВыдан,
	|	ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛСотрудники.ДатаВыдачиДокумента КАК ДатаВыдачи,
	|	ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛСотрудники.ДатаРождения,
	|	ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛСотрудники.НомерСтроки
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	&Сотрудники КАК ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛСотрудники
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сотрудники.Сотрудник,
	|	МИНИМУМ(Сотрудники.НомерСтроки) КАК НомерСтроки
	|ПОМЕСТИТЬ ВТДублиСтрок
	|ИЗ
	|	ВТСотрудники КАК Сотрудники
	|
	|СГРУППИРОВАТЬ ПО
	|	Сотрудники.Сотрудник
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(Сотрудники.НомерСтроки) > 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сотрудники.Сотрудник,
	|	Сотрудники.Сотрудник.Наименование КАК Наименование,
	|	Сотрудники.ИНН,
	|	Сотрудники.Фамилия,
	|	Сотрудники.Имя,
	|	Сотрудники.Отчество,
	|	Сотрудники.ВидДокумента,
	|	Сотрудники.СерияДокумента,
	|	Сотрудники.НомерДокумента,
	|	Сотрудники.КемВыдан,
	|	Сотрудники.ДатаВыдачи,
	|	Сотрудники.ДатаРождения,
	|	Сотрудники.НомерСтроки КАК НомерСтроки,
	|	ДублиСтрок.НомерСтроки КАК НомерСтрокиДубль,
	|	ВЫБОР
	|		КОГДА ДублиСтрок.НомерСтроки ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЕстьПовторяющиесяСтроки,
	|	ЗНАЧЕНИЕ(Справочник.СтраныМира.ПустаяСсылка) КАК Гражданство
	|ИЗ
	|	ВТСотрудники КАК Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДублиСтрок КАК ДублиСтрок
	|		ПО Сотрудники.Сотрудник = ДублиСтрок.Сотрудник
	|			И Сотрудники.НомерСтроки > ДублиСтрок.НомерСтроки
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции	

Процедура ПроверитьДанныеФизическогоЛица(ПроверяемыеДанные, НомерСтроки, Отказ = Ложь) Экспорт
	
	Ошибки = Новый Соответствие;
	
	ПравилаПроверки = ПравилаПроверкиДанныхФизическогоЛица(Дата);
	
	ДанныеФизическогоЛицаДляПроверки = ДанныеФизическогоЛицаДляПроверки(ПроверяемыеДанные);
	
	ФизическиеЛицаЗарплатаКадры.ПроверитьДанныеФизическогоЛица(
		ДанныеФизическогоЛицаДляПроверки,
		ПравилаПроверки,
		Ошибки);
				
	ПутьКДанным = "Объект.Сотрудники[" + Формат(НомерСтроки - 1, "ЧН=0; ЧГ=") + "].Сотрудник";
	
	Для Каждого ОшибкиПоФизЛицу Из Ошибки Цикл
		Для Каждого ОшибкаДанныхФизическогоЛица Из ОшибкиПоФизЛицу.Значение Цикл	
			ОбщегоНазначения.СообщитьПользователю(
				ОшибкаДанныхФизическогоЛица.ТекстОшибки,
				Ссылка,
				ПутьКДанным,,
				Отказ);
		КонецЦикла;		
	КонецЦикла;			
КонецПроцедуры

Функция ПравилаПроверкиДанныхФизическогоЛица(ДатаДокумента)
	Правила = Новый Массив;
	
	ФизическиеЛицаЗарплатаКадры.ДобавитьПравилоПроверки(
		Правила,
		"ИНН",
		"ИНН",
		НСтр("ru = 'ИНН';
			|en = 'TIN'"),
		Истина);
		
	ФизическиеЛицаЗарплатаКадры.ДобавитьПравилоПроверкиФИО(
		Правила,
		"Фамилия",
		"Имя",
		"Отчество",
		"Гражданство",
		НСтр("ru = 'ФИО';
			|en = 'Full name'"));
		
	ФизическиеЛицаЗарплатаКадры.ДобавитьПравилоПроверкиДатыРождения(
		Правила,
		"ДатаРождения",
		НСтр("ru = 'Дата рождения';
			|en = 'Date of birth'"),
		ДатаДокумента,
		Истина);
		
	ФизическиеЛицаЗарплатаКадры.ДобавитьПравилоПроверкиУдостоверенияЛичностиИностранногоГражданина(
		Правила,
		"ВидДокумента",
		"СерияДокумента",
		"НомерДокумента",
		"ДатаВыдачи",
		"КемВыдан",
		НСтр("ru = 'Документ удостоверяющий личность';
			|en = 'Identity document'"),
		Истина,
		Истина);
		
	Возврат Правила;	
				
КонецФункции	

Функция ДанныеФизическогоЛицаДляПроверки(ПроверяемыеДанные)
	ДанныеФизическогоЛицаДляПроверки = Новый Структура;
	ДанныеФизическогоЛицаДляПроверки.Вставить("ФизическоеЛицо", ПроверяемыеДанные.Сотрудник);
	ДанныеФизическогоЛицаДляПроверки.Вставить("Наименование", ПроверяемыеДанные.Наименование);
	ДанныеФизическогоЛицаДляПроверки.Вставить("Гражданство");
	ДанныеФизическогоЛицаДляПроверки.Вставить("Фамилия");
	ДанныеФизическогоЛицаДляПроверки.Вставить("Имя");
	ДанныеФизическогоЛицаДляПроверки.Вставить("Отчество");
	ДанныеФизическогоЛицаДляПроверки.Вставить("ИНН");
	ДанныеФизическогоЛицаДляПроверки.Вставить("ВидДокумента");
	ДанныеФизическогоЛицаДляПроверки.Вставить("СерияДокумента");
	ДанныеФизическогоЛицаДляПроверки.Вставить("НомерДокумента");
	ДанныеФизическогоЛицаДляПроверки.Вставить("ДатаРождения");
	ДанныеФизическогоЛицаДляПроверки.Вставить("ДатаВыдачи");
	ДанныеФизическогоЛицаДляПроверки.Вставить("КемВыдан");

	ЗаполнитьЗначенияСвойств(ДанныеФизическогоЛицаДляПроверки, ПроверяемыеДанные);

	Возврат  ДанныеФизическогоЛицаДляПроверки;
КонецФункции	

Функция ДанныеВыгружаемыеКакАтрибуты(СтруктураДанных)

	Атрибуты = Новый Структура;
	Для каждого Поле Из СтруктураДанных Цикл
		Если Поле.Значение.ТипЭлемента = "А" Тогда
			Данные = Поле.Значение.Значение;
			Если Поле.Значение.ТипДанных = "ЧИСЛО" Тогда
				Данные = Формат(Данные,"ЧЦ=" + Поле.Значение.Размер + "; ЧДЦ=" + Поле.Значение.РазрядностьДробнойЧасти + "; ЧРД=.; ЧН=; ЧГ=0")
			ИначеЕсли Поле.Значение.ТипДанных = "ДАТА" Тогда
				Если Не ЗначениеЗаполнено(Данные) Тогда
					Данные = ""
				Иначе
					Данные = Формат(Данные,"ДЛФ=D");
				КонецЕсли;
			КонецЕсли;
			Атрибуты.Вставить(Поле.Ключ, Данные);
			СтруктураДанных.Удалить(Поле.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Атрибуты
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли