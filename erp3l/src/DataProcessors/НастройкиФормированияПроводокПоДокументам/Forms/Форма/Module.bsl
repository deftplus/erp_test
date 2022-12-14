
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	ПланСчетов=Справочники.ПланыСчетовБД.НайтиПоНаименованию("МСФО",Истина,,Справочники.ТипыБазДанных.ТекущаяИБ);
	РегистрБухгалтерии=Справочники.РегистрыБухгалтерииБД.НайтиПоНаименованию("МСФО",Истина,,Справочники.ТипыБазДанных.ТекущаяИБ);
			
КонецПроцедуры

&НаКлиенте
Процедура ДокументыБДПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ДокументыБДПриАктивизацииСтрокиОбработчикОжидания",0.2,Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыБДПриАктивизацииСтрокиОбработчикОжидания()

	ТекущиеДанные = Элементы.ДокументыБД.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийДокумент=ТекущиеДанные.Ссылка;
	
	ПолучитьШаблоныПроводок();
	
	РазвернутьСтрокиШаблонов(ДеревоШаблонов);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьШаблоныПроводок()
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	ШаблоныПроводок.Ссылка КАК Ссылка,
	|	ШаблоныПроводок.Наименование КАК Наименование,
	|	ШаблоныПроводок.ПометкаУдаления КАК ПометкаУдаления,
	|	ШаблоныПроводок.Отключен КАК Отключен,
	|	ШаблоныПроводок.Владелец КАК Владелец,
	|	ШаблоныПроводок.УстановленДополнительныйОтбор КАК УстановленДополнительныйОтбор,
	|	ШаблоныПроводок.ПредставлениеОтбора КАК ПредставлениеОтбора,
	|	ШаблоныПроводок.ПредставлениеИсточника КАК ПредставлениеИсточника
	|ПОМЕСТИТЬ ШаблоныПроводок
	|ИЗ
	|	Справочник.ШаблоныПроводок КАК ШаблоныПроводок
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПоказателиОтчетов.Ссылка,
	|	ПоказателиОтчетов.Наименование,
	|	ПоказателиОтчетов.ПометкаУдаления,
	|	ПоказателиОтчетов.Отключен,
	|	ПоказателиОтчетов.Владелец,
	|	NULL,
	|	NULL,
	|	ПроцедурыРасчетов.Процедура
	|ИЗ
	|	Справочник.ПоказателиОтчетов КАК ПоказателиОтчетов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроцедурыРасчетов КАК ПроцедурыРасчетов
	|		ПО ПоказателиОтчетов.Ссылка = ПроцедурыРасчетов.ПотребительРасчета
	|ГДЕ
	|	ПоказателиОтчетов.Владелец ССЫЛКА Справочник.ШаблоныТрансформационныхКорректировок
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Владелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ШаблоныТрансформационныхКорректировок.Ссылка КАК ШаблонКорректировки,
	|	ШаблоныТрансформационныхКорректировок.Наименование КАК ШаблонКорректировкиНаименование,
	|	ШаблоныТрансформационныхКорректировок.ПометкаУдаления КАК ШаблонКорректировкиПометкаУдаления,
	|	ШаблоныТрансформационныхКорректировок.Отключен КАК ШаблонКорректировкиОтключен,
	|	ШаблоныТрансформационныхКорректировок.УстановленДополнительныйОтбор КАК ЕстьОтборВШаблоне,
	|	ШаблоныТрансформационныхКорректировок.ПредставлениеОтбора КАК ШаблонКорректировкиПредставлениеОтбора,
	|	ШаблоныПроводок.Ссылка КАК ШаблонПроводки,
	|	ШаблоныПроводок.Наименование КАК ШаблонПроводкиНаименование,
	|	ШаблоныПроводок.ПометкаУдаления КАК ШаблонПроводкиПометкаУдаления,
	|	ШаблоныПроводок.Отключен КАК ШаблонПроводкиОтключен,
	|	ЕСТЬNULL(ШаблоныПроводок.УстановленДополнительныйОтбор, ЛОЖЬ) КАК ЕстьОтборыВПроводке,
	|	ЕСТЬNULL(ШаблоныПроводок.ПредставлениеОтбора, """") КАК ШаблонПроводкиПредставлениеОтбора,
	|	ЕСТЬNULL(ШаблоныПроводок.ПредставлениеИсточника, """") КАК ПредставлениеИсточника
	|ИЗ
	|	Справочник.ШаблоныТрансформационныхКорректировок КАК ШаблоныТрансформационныхКорректировок
	|		ЛЕВОЕ СОЕДИНЕНИЕ ШаблоныПроводок КАК ШаблоныПроводок
	|		ПО ШаблоныТрансформационныхКорректировок.Ссылка = ШаблоныПроводок.Владелец
	|ГДЕ
	|	ШаблоныТрансформационныхКорректировок.ДокументБД = &ДокументБД
	|	И ШаблоныТрансформационныхКорректировок.ПланСчетов = &ПланСчетов";
	
	Запрос.УстановитьПараметр("ДокументБД",ТекущийДокумент);
	Запрос.УстановитьПараметр("ПланСчетов",ПланСчетов);
	
	ДеревоШаблоновСервер=РеквизитФормыВЗначение("ДеревоШаблонов");
	ДеревоШаблоновСервер.Строки.Очистить();
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		СтрокаШаблон=ДеревоШаблоновСервер.Строки.Найти(Результат.ШаблонКорректировки,"ЭлементНастройки");
		
		Если СтрокаШаблон=Неопределено Тогда
			
			СтрокаШаблон						= ДеревоШаблоновСервер.Строки.Добавить();
			СтрокаШаблон.ЭлементНастройки		= Результат.ШаблонКорректировки;
			СтрокаШаблон.НаименованиеЭлемента	= Результат.ШаблонКорректировкиНаименование;
			СтрокаШаблон.ПометкаУдаления		= Результат.ШаблонКорректировкиПометкаУдаления;
			СтрокаШаблон.ЭтоШаблонОперации		= Истина;
			СтрокаШаблон.Состояние				= ?(СтрокаШаблон.ПометкаУдаления,1,0);
			СтрокаШаблон.Отключен				= Результат.ШаблонКорректировкиОтключен;
			СтрокаШаблон.ЕстьОтбор				= Результат.ЕстьОтборВШаблоне;
			СтрокаШаблон.ПредставлениеОтбора	= Результат.ШаблонКорректировкиПредставлениеОтбора;
			
			СтрокаПростые=СтрокаШаблон.Строки.Добавить();
			СтрокаПростые.НаименованиеЭлемента=Нстр("ru = 'Шаблоны проводок простые'");
			
			СтрокаФормулы=СтрокаШаблон.Строки.Добавить();
			СтрокаФормулы.НаименованиеЭлемента	= Нстр("ru = 'Шаблоны проводок с формулами'");
			СтрокаФормулы.ДляФормулРасчета		= Истина;
			
			СтрокаШаблон.Строки.Сортировать("ДляФормулРасчета");
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Результат.ШаблонПроводки) Тогда
			
			СтрокаВладелец=ПолучитьСтрокуШаблона(СтрокаШаблон,Результат.ШаблонПроводки);
						
			СтрокаПроводки=СтрокаВладелец.Строки.Добавить();
			СтрокаПроводки.ЭлементНастройки		= Результат.ШаблонПроводки;
			СтрокаПроводки.НаименованиеЭлемента	= Результат.ШаблонПроводкиНаименование;
			СтрокаПроводки.ПометкаУдаления		= Результат.ШаблонПроводкиПометкаУдаления;
			СтрокаПроводки.Состояние			= ?(СтрокаПроводки.ПометкаУдаления,1,0);
			СтрокаПроводки.Отключен				= Результат.ШаблонПроводкиОтключен;
			СтрокаПроводки.ЕстьОтбор			= Результат.ЕстьОтборыВПроводке;
			СтрокаПроводки.ПредставлениеОтбора	= Результат.ШаблонПроводкиПредставлениеОтбора;
			СтрокаПроводки.ДляФормулРасчета		= СтрокаВладелец.ДляФормулРасчета;
			
			Если СтрокаПроводки.ДляФормулРасчета Тогда
				
				СтрокаПроводки.ПредставлениеИсточника=ПолучитьПредставлениеПроцедуры(Результат.ПредставлениеИсточника,Результат.ШаблонПроводки,Результат.ШаблонКорректировки);
				
			Иначе
				
				СтрокаПроводки.ПредставлениеИсточника= Результат.ПредставлениеИсточника;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоШаблоновСервер,"ДеревоШаблонов");
	
КонецПроцедуры // ПолучитьШаблоныПроводок()

&НаСервере
Функция ПолучитьПредставлениеПроцедуры(ПроцедураРасчета,ПоказательОтчета,ШаблонКорректировки)
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	РеквизитыИсточниковДанныхДляФормул.КодИсточника КАК КодИсточника,
	|	РеквизитыИсточниковДанныхДляФормул.ПоказательТекущегоОтчета КАК ПоказательТекущегоОтчета,
	|	РеквизитыИсточниковДанныхДляФормул.ЕстьНестандартныеОтборы КАК ЕстьНестандартныеОтборы,
	|	РеквизитыИсточниковДанныхДляФормул.КодУпрощеннойФормулы КАК КодУпрощеннойФормулы,
	|	РеквизитыИсточниковДанныхДляФормул.ПотребительРасчета КАК ПотребительРасчета,
	|	РеквизитыИсточниковДанныхДляФормул.КодПоказательОтбор КАК КодПоказательОтбор
	|ИЗ
	|	РегистрСведений.РеквизитыИсточниковДанныхДляФормул КАК РеквизитыИсточниковДанныхДляФормул
	|ГДЕ
	|	РеквизитыИсточниковДанныхДляФормул.СпособИспользования = &СпособИспользования
	|	И РеквизитыИсточниковДанныхДляФормул.ПотребительРасчета = &ПотребительРасчета
	|	И РеквизитыИсточниковДанныхДляФормул.НазначениеРасчетов.Владелец = &ШаблонКорректировки";
	
	Запрос.УстановитьПараметр("ШаблонКорректировки",ШаблонКорректировки);
	Запрос.УстановитьПараметр("СпособИспользования",Перечисления.СпособыИспользованияОперандов.ДляФормулРасчета);
	Запрос.УстановитьПараметр("ПотребительРасчета",ПОказательОтчета);
	
	ТекстПроцедуры=ПроцедураРасчета;
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		ТекстОперанда=Результат.КодУпрощеннойФормулы;					
		ТекстПроцедуры=СтрЗаменить(ТекстПроцедуры,"["+СокрЛП(Результат.КодИсточника)+"]",ТекстОперанда);
		
	КонецЦикла;
	
	Возврат ТекстПроцедуры;
	
КонецФункции // ПолучитьПредставлениеПроцедуры() 

&НаСервере
Функция ПолучитьСтрокуШаблона(СтрокаШаблон,ШаблонПроводки)
	
	ДляФормулРасчета=ТипЗнч(ШаблонПроводки)=Тип("СправочникСсылка.ПоказателиОтчетов");
	
	НаименованиеСтроки=?(ДляФормулРасчета,Нстр("ru = 'Шаблоны проводок с формулами'"),Нстр("ru = 'Шаблоны проводок простые'"));
	
	СтрокаДерева=СтрокаШаблон.Строки.Найти(НаименованиеСтроки,"НаименованиеЭлемента");
	
	Если СтрокаДерева=Неопределено Тогда
		
		СтрокаДерева=СтрокаШаблон.Строки.Добавить();
		СтрокаДерева.НаименованиеЭлемента=НаименованиеСтроки;
		СтрокаДерева.ДляФормулРасчета=ДляФормулРасчета;
		
		СтрокаШаблон.Строки.Сортировать("ДляФормулРасчета");
		
	КонецЕсли;
	
	Возврат СтрокаДерева;
		
КонецФункции // ПолучитьСтрокуШаблона()

&НаСервере
Функция СоздатьШаблонКорректировки()
	
	СправочникОбъект=Справочники.ШаблоныТрансформационныхКорректировок.СоздатьЭлемент();
	СправочникОбъект.Наименование=ТекущийДокумент.Наименование+?(ДеревоШаблонов.ПолучитьЭлементы().Количество()>0,ДеревоШаблонов.ПолучитьЭлементы().Количество()+1,"");
	СправочникОбъект.ВидОперации=Справочники.ВидыОпераций.УчетныеОперации;
	СправочникОбъект.ДвиженияПоРегиструБухгалтерии=Истина;
	СправочникОбъект.ПланСчетов=ПланСчетов;
	СправочникОбъект.РегистрБухгалтерии=РегистрБухгалтерии;
	СправочникОбъект.РасчетДатыОтраженияВУчете=Перечисления.СпособыРасчетаДатыОтраженияВУчете.ДатаОкончанияПериода;
	СправочникОбъект.ДокументБД=ТекущийДокумент;
	СправочникОбъект.ДляОнлайнПроводок=Истина;
	
	Попытка
		
		СправочникОбъект.Записать();	
		УправлениеОтчетамиУХ.ПроверитьНаличиеЭлементовНастройки(СправочникОбъект.Ссылка,Новый Структура("ПравилоОбработки"),Ложь);

		СтрокаШаблон=ДеревоШаблонов.ПолучитьЭлементы().Добавить();
		СтрокаШаблон.ЭлементНастройки		= СправочникОбъект.Ссылка;
		СтрокаШаблон.НаименованиеЭлемента	= СправочникОбъект.Наименование;
		СтрокаШаблон.ЭтоШаблонОперации		= Истина;
		
		СтрокаПростые=СтрокаШаблон.ПолучитьЭлементы().Добавить();
		СтрокаПростые.НаименованиеЭлемента=Нстр("ru = 'Шаблоны проводок простые'");
		
		СтрокаФормулы=СтрокаШаблон.ПолучитьЭлементы().Добавить();
		СтрокаФормулы.НаименованиеЭлемента	= Нстр("ru = 'Шаблоны проводок с формулами'");
		СтрокаФормулы.ДляФормулРасчета		= Истина;
		
		Возврат СправочникОбъект.Ссылка;
		
	Исключение
		
		ТекстСообщения=НСтр("ru = 'Не удалось создать шаблон движений'");
		ТекстСообщения=ТекстСообщения+ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения,,,СтатусСообщения.Важное);
		Возврат Неопределено;
		
	КонецПопытки;
		
КонецФункции // СоздатьШаблонКорректировки()
	
&НаКлиенте
Функция ОпределитьШаблонКорректировки()
	
	СтрокаРодитель=Элементы.ДеревоШаблонов.ТекущиеДанные.ПолучитьРодителя();
	
	Если СтрокаРодитель=Неопределено Тогда
		
		ШаблонКорректировки=Элементы.ДеревоШаблонов.ТекущиеДанные.ЭлементНастройки;
		
	ИначеЕсли НЕ ЗначениеЗаполнено(СтрокаРодитель.ЭлементНастройки) Тогда
		
		ШаблонКорректировки=СтрокаРодитель.ПолучитьРодителя().ЭлементНастройки;
		
	Иначе
		
		ШаблонКорректировки=СтрокаРодитель.ЭлементНастройки;
				
	КонецЕсли;
	
	Возврат ШаблонКорректировки;
	
КонецФункции // ОпределитьШаблонКорректировки()


&НаКлиенте
Процедура ДобавитьШаблонПроводки(Команда)
	
	Если ДеревоШаблонов.ПолучитьЭлементы().Количество()=0 Тогда
		
		ДобавитьНовыйШаблон();
		Элементы.ДеревоШаблонов.ТекущаяСтрока=ДеревоШаблонов.ПолучитьЭлементы()[0].ПолучитьИдентификатор();
		
	ИначеЕсли Элементы.ДеревоШаблонов.ТекущиеДанные=Неопределено Тогда
		
		ПоказатьПредупреждение(,НСтр("ru = 'Выберите шаблон операции для добавления проводки.'"));
		Возврат;
		
	КонецЕсли;
	
	ШаблонКорректировки=ОпределитьШаблонКорректировки();
	
	Если Элементы.ДеревоШаблонов.ТекущиеДанные.ДляФормулРасчета Тогда
		
		СтруктураПараметров=Новый Структура;
		СтруктураПараметров.Вставить("ДокументБД",			ТекущийДокумент);
		СтруктураПараметров.Вставить("ПланСчетов",			ПланСчетов);
		СтруктураПараметров.Вставить("ШаблонКорректировки",	ШаблонКорректировки);
		СтруктураПараметров.Вставить("РегистрБухгалтерии",	РегистрБухгалтерии);
		
		ОткрытьФорму("Обработка.НастройкиФормированияПроводокПоДокументам.Форма.ФормаНастройкиПоказателяПроводки",СтруктураПараметров);
		
	Иначе
		
		СтруктураПараметров=Новый Структура;
		СтруктураПараметров.Вставить("ДокументБД",			ТекущийДокумент);
		СтруктураПараметров.Вставить("ПланСчетов",			ПланСчетов);
		СтруктураПараметров.Вставить("ШаблонКорректировки",	ШаблонКорректировки);
		СтруктураПараметров.Вставить("РегистрБухгалтерии",	РегистрБухгалтерии);
		
		ОткрытьФорму("Обработка.НастройкиФормированияПроводокПоДокументам.Форма.ФормаНастройкиПроводки",СтруктураПараметров);
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЭлементНастройки(Команда)
	
	ПометитьНаУдалениеСнятьПометку();
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеСнятьПометку()
		
	ТекущиеДанные = Элементы.ДеревоШаблонов.ТекущиеДанные;

	Если ТекущиеДанные=Неопределено
		ИЛИ (НЕ ЗначениеЗаполнено(ТекущиеДанные.ЭлементНастройки)) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ЭлементНастройки		= Элементы.ДеревоШаблонов.ТекущиеДанные.ЭлементНастройки;
	НаименованиеЭлемента	= Элементы.ДеревоШаблонов.ТекущиеДанные.НаименованиеЭлемента;	
		
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПометитьНаУдалениеСнятьПометкуЗавершение", ЭтаФорма, ЭлементНастройки);
		
	Если ТекущиеДанные.ЭтоШаблонОперации Тогда
		
		Если ТекущиеДанные.ПометкаУдаления Тогда
			ТекстВопроса = НСтр("ru = 'Снять пометку удаления с шаблона операции ""%1""?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Пометить на удаление шаблон операции ""%1""?'");
		КонецЕсли;

	Иначе
		
		Если ТекущиеДанные.ПометкаУдаления Тогда
			ТекстВопроса = НСтр("ru = 'Снять пометку удаления с ""%1""?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Пометить на удаление ""%1""?'");
		КонецЕсли;

	КонецЕсли;
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстВопроса,
		НаименованиеЭлемента);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры // ПометитьНаУдалениеСнятьПометку()

&НаКлиенте
Процедура ПометитьНаУдалениеСнятьПометкуЗавершение(Результат, ЭлементНастройки) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
			
	Если ИзменитьПометкуУдаления(ЭлементНастройки) Тогда
		
		ТекущиеДанные=Элементы.ДеревоШаблонов.ТекущиеДанные;
		
		ТекущиеДанные.ПометкаУдаления=НЕ ТекущиеДанные.ПометкаУдаления;
		ТекущиеДанные.Состояние=?(ТекущиеДанные.ПометкаУдаления,1,0);
		
	КонецЕсли;
						
КонецПроцедуры

&НаСервере
Функция ИзменитьПометкуУдаления(ЭлементНастройки)
	
	СправочникОбъект=ЭлементНастройки.ПолучитьОбъект();
	СправочникОбъект.ПометкаУдаления=НЕ СправочникОбъект.ПометкаУдаления;
	СправочникОбъект.ОбменДанными.Загрузка=Истина;
	СправочникОбъект.Записать();
	
	Попытка
		
		СправочникОбъект.Записать();
				
		Возврат Истина;
		
	Исключение
		
		ТекстСообщения=НСтр("ru = 'Не удалось изменить пометку удаления:'");
		ТекстСообщения=ТекстСообщения+ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения,,,СтатусСообщения.Важное);
		Возврат Ложь;
		
	КонецПопытки;
	
КонецФункции // ИзменитьПометкуУдаления() 


&НаСервере
Процедура ПланСчетовПриИзмененииНаСервере()
	
	МассивРегистров=УправлениеОтчетамиУХ.ПолучитьМассивРегистровБухгалтерии(ПланСчетов);
	
	
	Если МассивРегистров.Количество()>0 Тогда
		
		РегистрБухгалтерии=МассивРегистров[0];
		
	Иначе
		
		РегистрБухгалтерии="";
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущийДокумент) Тогда
		
		ПолучитьШаблоныПроводок();
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПланСчетовПриИзменении(Элемент)
		
	ПланСчетовПриИзмененииНаСервере();
	РазвернутьСтрокиШаблонов(ДеревоШаблонов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если (ИмяСобытия="ЗаписанШаблонПроводки" 
		ИЛи ИмяСобытия="ЗаписанШаблонКорректировки")
		И Параметр=ТекущийДокумент Тогда
		
		ПолучитьШаблоныПроводок();
		РазвернутьСтрокиШаблонов(ДеревоШаблонов);
		
	ИначеЕсли ТипЗнч(Параметр)=Тип("Структура") 
		И Параметр.Свойство("ТекстПроцедуры")
		И (НЕ Элементы.ДеревоШаблонов.ТекущиеДанные=Неопределено)
		И Элементы.ДеревоШаблонов.ТекущиеДанные.ЭлементНастройки=Параметр.ПотребительРасчета Тогда
		
		Элементы.ДеревоШаблонов.ТекущиеДанные.ПредставлениеИсточника=Параметр.ТекстПроцедуры;
					
	КонецЕсли;
		
КонецПроцедуры  // 

&НаКлиенте
Процедура ДобавитьНовыйШаблон()
	
	ШаблонКорректировки=СоздатьШаблонКорректировки();
	
	Если Не ЗначениеЗаполнено(ШаблонКорректировки) Тогда
		
		Возврат
		
	КонецЕсли;
	
	СтруктураПараметров=Новый Структура;
	СтруктураПараметров.Вставить("ДокументБД",			ТекущийДокумент);
	СтруктураПараметров.Вставить("ПланСчетов",			ПланСчетов);
	СтруктураПараметров.Вставить("ШаблонКорректировки",	ШаблонКорректировки);
	СтруктураПараметров.Вставить("РегистрБухгалтерии",	РегистрБухгалтерии);
	
	ОткрытьФорму("Обработка.НастройкиФормированияПроводокПоДокументам.Форма.ФормаНастройкиПроводки",СтруктураПараметров);
	
КонецПроцедуры // ДобавитьНовыйШаблон() 



&НаКлиенте
Процедура ДобавитьШаблонКорректировки(Команда)
	
	ДобавитьНовыйШаблон();	
		
КонецПроцедуры

&НаКлиенте
Процедура ДеревоШаблоновВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;
	ЭлементНастройки=Элементы.ДеревоШаблонов.ТекущиеДанные.ЭлементНастройки;
	
	Если НЕ ЗначениеЗаполнено(ЭлементНастройки) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ТипЗнч(ЭлементНастройки)=Тип("СправочникСсылка.ШаблоныТрансформационныхКорректировок") Тогда
		
		ОткрытьФорму("Справочник.ШаблоныТрансформационныхКорректировок.ФормаОбъекта",Новый Структура("Ключ",ЭлементНастройки));
		
	ИначеЕсли ТипЗнч(ЭлементНастройки)=Тип("СправочникСсылка.ПоказателиОтчетов") Тогда
		
		Если Поле.Имя="ДеревоШаблоновПредставлениеИсточника" Тогда
			
			ОткрытьФорму("ОбщаяФорма.ФормаНастройкиФормулРасчета",ПолучитьСтруктуруПоказателяПроцедуры(ЭлементНастройки));
			
		Иначе
			
			ОткрытьФорму("Обработка.НастройкиФормированияПроводокПоДокументам.Форма.ФормаНастройкиПоказателяПроводки",Новый Структура("ПоказательОтчета,РегистрБухгалтерии",ЭлементНастройки,РегистрБухгалтерии));
			
		КонецЕсли;
		
	Иначе
		
		ОткрытьФорму("Обработка.НастройкиФормированияПроводокПоДокументам.Форма.ФормаНастройкиПроводки",Новый Структура("ШаблонПроводки",ЭлементНастройки));
		
	КонецЕсли;
			
КонецПроцедуры

&НаСервере
Функция ПолучитьСтруктуруПоказателяПроцедуры(ПоказательОтчета)
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	ПоказателиОтчетов.Ссылка КАК ПоказательОтчета,
	|	ПравилаОбработки.Ссылка КАК ПравилоОбработки
	|ИЗ
	|	Справочник.ПоказателиОтчетов КАК ПоказателиОтчетов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПравилаОбработки КАК ПравилаОбработки
	|		ПО ПоказателиОтчетов.Владелец = ПравилаОбработки.Владелец
	|ГДЕ
	|	ПоказателиОтчетов.Ссылка = &ПоказательОтчета";
	
	Запрос.УстановитьПараметр("ПоказательОтчета",ПоказательОтчета);
	Результат=Запрос.Выполнить().Выбрать();
	Результат.Следующий();
	
	СтруктураПараметров=Новый Структура;
	СтруктураПараметров.Вставить("НазначениеРасчетов",	Результат.ПравилоОбработки);
	СтруктураПараметров.Вставить("ПотребительРасчета",	ПоказательОтчета);
	СтруктураПараметров.Вставить("СпособИспользования",	Перечисления.СпособыИспользованияОперандов.ДляФормулРасчета);
	
	Возврат СтруктураПараметров;	
	
КонецФункции //  ПолучитьСтруктуруПоказателяПроцедуры()

&НаКлиенте
Процедура ДеревоШаблоновОтключенПриИзменении(Элемент)
	
	ТекущиеДанные=Элементы.ДеревоШаблонов.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ЭлементНастройки) Тогда
		
		ОтключитьВключитьЭлементНастройки(ТекущиеДанные.ЭлементНастройки,ТекущиеДанные.Отключен,ТекущиеДанные.ДляФормулРасчета);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьВключитьЭлементНастройки(ЭлементНастройки,Отключен,ДляФормулРасчета=Ложь)
	
	СправочникОбъект=ЭлементНастройки.ПолучитьОбъект();
	СправочникОбъект.Отключен=Отключен;
	СправочникОбъект.ОбменДанными.Загрузка=Истина;
	СправочникОбъект.Записать();
	
	Если ДляФормулРасчета Тогда
		
		ОчиститьЗаписиРегистраПараметрическихНастроек(ЭлементНастройки);
		
	КонецЕсли;
		
КонецПроцедуры // ОтключитьВключитьЭлементНастройки()

&НаСервере
Процедура ОчиститьЗаписиРегистраПараметрическихНастроек(ЭлементНастройки)
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПроцедурыРасчетов.НазначениеРасчетов КАК НазначениеРасчетов
	|ИЗ
	|	РегистрСведений.ПроцедурыРасчетов КАК ПроцедурыРасчетов
	|ГДЕ
	|	ПроцедурыРасчетов.ПотребительРасчета = &ПотребительРасчета";
	
	Запрос.УстановитьПараметр("ПотребительРасчета",ЭлементНастройки);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		
		УправлениеОтчетамиУХ.ОчиститьЗаписиРегистраПараметрическихНастроек(Результат.НазначениеРасчетов);
		
	КонецЕсли;
		
КонецПроцедуры // ОчиститьЗаписиРегистраПараметрическихНастроек() 

&НаКлиенте
Процедура РазвернутьСтрокиШаблонов(КоллекцияЭлементов)
	
	Для Каждого Элемент ИЗ КоллекцияЭлементов.ПолучитьЭлементы() Цикл
		
		Элементы.ДеревоШаблонов.Развернуть(Элемент.ПолучитьИдентификатор());
		
		РазвернутьСтрокиШаблонов(Элемент);
		
	КонецЦикла;
		
КонецПроцедуры // РазвернутьСтрокиШаблонов() 

&НаКлиенте
Процедура СкопироватьЭлементНастройки(Команда)
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоШаблоновПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ=Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоШаблоновПередУдалением(Элемент, Отказ)
	
	Отказ=Истина;	
	ПометитьНаУдалениеСнятьПометку();
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКорректировкиПоШаблонам(Команда)
	
	ОткрытьФорму("Обработка.ЗаполнениеКорректировокПоШаблонам.Форма",Новый Структура("ОбъектОбработки",ТекущийДокумент));
	
КонецПроцедуры






 

