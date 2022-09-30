////////////////////////////////////////////////////////////////////////////////
// 
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс
	
Функция ОбработатьПроизвольныйКодЭтапа(СтруктураПараметров, ТекстПроцедуры, ТексОшибкиИзм = "") Экспорт
	
	
	ПараметрыПроцесса = Новый Структура;
	
	ПараметрыТекущегоПроцесса = СтруктураПараметров.ЭкземплярПроцесса.ПараметрыПроцесса.Выгрузить();
	Для Каждого Пар Из ПараметрыТекущегоПроцесса Цикл
		ПараметрыПроцесса.Вставить(Пар.КодПараметра, Пар.ЗначениеПоУмолчанию);
		СтруктураПараметров.Вставить(Пар.КодПараметра, Пар.ЗначениеПоУмолчанию);
	КонецЦикла;	
	
	ПараметрыТекущегоЭтапа =   СтруктураПараметров.ТекущийЭтап.ЗначенияПараметров.Выгрузить();
	ИспользуемыеФункцииТекущегоЭтапа = ПараметрыТекущегоЭтапа.Скопировать();
	ИспользуемыеФункцииТекущегоЭтапа.Свернуть("Потребитель");
	
	Для Каждого тФункция из ИспользуемыеФункцииТекущегоЭтапа Цикл 
		
		ИмяФункции = СтрЗаменить(тФункция.Потребитель,"()","");
		Если СтрНайти(ТекстПроцедуры,ИмяФункции)>0 Тогда
			
			ТекПараметры = ПараметрыТекущегоЭтапа.НайтиСтроки(Новый Структура("Потребитель",ИмяФункции+"()"));
			Для Каждого мПар из ТекПараметры Цикл 
				Если мПар.ТипОтбораПараметра = "Значение" Тогда
					СтруктураПараметров.Вставить(мПар.ИмяПараметра,мПар.ЗначениеПараметра); 	
				Иначе
					ЗначениеПараметра = ПараметрыТекущегоПроцесса.НайтиСтроки(Новый Структура("ИмяПараметра",мПар.ЗначениеПараметра))[0].ЗначениеПоУмолчанию;
					СтруктураПараметров.Вставить(мПар.ИмяПараметра,ЗначениеПараметра);
				КонецЕсли;	
			КонецЦикла;	 
		КонецЕсли;	
			
	КонецЦикла;
	
	ФлагУспешнойОбработки = Ложь;
	Попытка
		Выполнить(ТекстПроцедуры);
		ФлагУспешнойОбработки = Истина;
	Исключение
		ОбщегоНазначенияУХ.СообщитьОбОшибке(НСтр("ru = 'Выполнение прервано'"));
		ТексОшибкиИзм = ОписаниеОшибки();
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТексОшибкиИзм);
		ФлагУспешнойОбработки = Ложь;	
	КонецПопытки;
	// Запись статуса этапа.
	СтатусСогласованияЭтапа = СтруктураПараметров.ТекущийЭтап.СтатусСогласованияОбъекта;
	ОбъектСсылка = СтруктураПараметров.ЭкземплярПроцесса.КлючевойОбъектПроцесса;
	ДокументПроцесса = СтруктураПараметров.ЭкземплярПроцесса;
	МодульУправленияПроцессамиУХ.ВыполнитьПроцедурыПоСтатусам(ОбъектСсылка, СтатусСогласованияЭтапа, ДокументПроцесса);
	Возврат  ФлагУспешнойОбработки;
	
КонецФункции	

Функция ОбработатьЭтапУниверсальногоЭкспорта(СтруктураПараметров) Экспорт
	
	
	ПараметрыТекущегоПроцесса = СтруктураПараметров.ЭкземплярПроцесса.ПараметрыПроцесса.Выгрузить();
	ПараметрыТекущегоЭтапа =   СтруктураПараметров.ТекущийЭтап.ЗначенияПараметров.Выгрузить();
	
	Для Каждого мПар из ПараметрыТекущегоЭтапа Цикл 
		Если мПар.ТипОтбораПараметра = "Значение" Тогда
			СтруктураПараметров.Вставить(СтрЗаменить(мПар.ИмяПараметра," ",""),мПар.ЗначениеПараметра); 	
		Иначе
			ЗначениеПараметра = ПараметрыТекущегоПроцесса.НайтиСтроки(Новый Структура("ИмяПараметра",мПар.ЗначениеПараметра))[0].ЗначениеПоУмолчанию;
			СтруктураПараметров.Вставить(СтрЗаменить(мПар.ИмяПараметра," ",""),ЗначениеПараметра);
		КонецЕсли;	
	КонецЦикла;	 
	
	Если НЕ СтруктураПараметров.Свойство("Объектссылка") Тогда
		Возврат ложь;
	КонецЕсли;
		
	ИсходныйОбъектСсылка = СтруктураПараметров.Объектссылка;
	
	ДокументБД = СтруктураПараметров.ДокументБД;
	Организация = СтруктураПараметров.Организация;
	Сценарий = СтруктураПараметров.Сценарий;
	
	
	Если ЗначениеЗаполнено(ИсходныйОбъектСсылка) Тогда
		НаименованиеДокумента=ИсходныйОбъектСсылка.Метаданные().Имя;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ДокументыБД.Ссылка
		|ИЗ
		|	Справочник.ДокументыБД КАК ДокументыБД
		|ГДЕ
		|	ДокументыБД.Наименование = &Наименование
		|	И ДокументыБД.Владелец = &Владелец";
		
		Запрос.УстановитьПараметр("Наименование", НаименованиеДокумента);
		Запрос.УстановитьПараметр("Владелец", Справочники.ТипыБазДанных.ТекущаяИБ);
		
		ДокументБД = Запрос.Выполнить().Выгрузить()[0].Ссылка;
		ИсходныйОбъектСсылка_Дата = ИсходныйОбъектСсылка.Дата;
	Иначе	
		ИсходныйОбъектСсылка_Дата = ТекущаяДата();
	КонецЕсли;
	
		
	МассивЗаполняемыхОбъектов=Обработки.ГенерацияОбъектовБД.ПолучитьПараметрыДляЗаполненияОбъектовБДПоИсходному(ДокументБД,Организация,Сценарий);
	
	Если МассивЗаполняемыхОбъектов.Количество()=0 Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Для Каждого ДанныеДляПроведения ИЗ МассивЗаполняемыхОбъектов Цикл
		
		СтруктураЗаписи=Новый Структура;
		СтруктураЗаписи.Вставить("ИспользуемаяИБ",			ДанныеДляПроведения.ИспользуемаяИБ);
		СтруктураЗаписи.Вставить("ПравилоЗаполнения",		ДанныеДляПроведения.ПравилоЗаполнения);
		СтруктураЗаписи.Вставить("ОбъектБД",				ДанныеДляПроведения.ОбъектБД);
		СтруктураЗаписи.Вставить("ИсходныйОбъектСсылка",	ИсходныйОбъектСсылка);
		СтруктураЗаписи.Вставить("Организация",				ИсходныйОбъектСсылка.Организация);
		СтруктураЗаписи.Вставить("Сценарий",				Сценарий);
		СтруктураЗаписи.Вставить("ИсходныйОбъектДата",		ИсходныйОбъектСсылка_Дата);
		СтруктураЗаписи.Вставить("ПроводитьДокументы",		ДанныеДляПроведения.ПроводитьДокументы);
		СтруктураЗаписи.Вставить("ОбластьГенерации",		ДанныеДляПроведения.ОбластьГенерации);
		СтруктураЗаписи.Вставить("ПериодОтчета",			ОбщегоНазначенияУХ.ПолучитьПериодПоДате(ИсходныйОбъектСсылка_Дата, Перечисления.Периодичность.Месяц));
		
			
		ОбработкаОбъект=Обработки.ГенерацияОбъектовБД.Создать();
		ЗаполнитьЗначенияСвойств(ОбработкаОбъект,СтруктураЗаписи);
		ОбработкаОбъект.ОбработатьОбъектыБД();
			

				
	КонецЦикла;

	Возврат Истина;
	
КонецФункции

Процедура ОбработатьДокументыЭтапаСервер(ДокументУправленияПериодом,ЭтапПроцесса) Экспорт
		
	МассивСтруткурНастроек = Новый Массив();

	ОрганизацииЭтапа = ЭтапПроцесса.ОрганизационныеЕдиницыОтбор.Выгрузить();
	
	Для Каждого Стр из ОрганизацииЭтапа Цикл 
		
		Для каждого ДокЭтапа ИЗ ЭтапПроцесса.ФормируемыеДокументы Цикл 
			
			СтрукутраНастройки = Новый Структура;

			СтрукутраНастройки.Вставить("Организация",Стр.ОрганизационнаяЕдиница);
			СтрукутраНастройки.Вставить("ПериодОтчета",ДокументУправленияПериодом.ПериодСценария);
			СтрукутраНастройки.Вставить("Сценарий",ДокументУправленияПериодом.Сценарий);
			СтрукутраНастройки.Вставить("ОсновнаяВалюта",Неопределено);
			
			СтрукутраНастройки.Вставить("ШаблонДокументаБД",ДокЭтапа.ШаблонДокумента);
			СтрукутраНастройки.Вставить("ДокументБД",ДокЭтапа.ДокументБД);
			СтрукутраНастройки.Вставить("ДокументСсылка",Неопределено);
			СтрукутраНастройки.Вставить("ДокументОбъект",Неопределено);
			МассивСтруткурНастроек.Добавить(СтрукутраНастройки);	
		КонецЦикла;
		
		//МассивСтруткурНастроек.Добавить(СтрукутраНастройки);	
				
	КонецЦикла;	
	
	ФлагВыполнения = Ложь;
	УправлениеРабочимиПроцессамиУХ.ОбработатьДокументыПоРегламенту(МассивСтруткурНастроек,ДокументУправленияПериодом.ВерсияОрганизационнойСтруктуры,ФлагВыполнения);	
	Если Не ФлагВыполнения Тогда
		ВызватьИсключение(НСтр("ru = 'Обработка не завершена'"));
	КонецЕсли;	
	
КонецПроцедуры	

// Возвращает организацию, соответствующую ссылке СсылкаНаОбъектВход
// согласно настройкам СправочникиБД/ДокументыБД.
Функция ПолучитьОрганизациюОбъекта(СсылкаНаОбъектВход) Экспорт
	// Инициализация.
	ПустаяОрганизация = Справочники.Организации.ПустаяСсылка();
	РезультатФункции = ПустаяОрганизация;
	// Получение справочника БД.
	Если ТипЗнч(СсылкаНаОбъектВход) = Тип("ДанныеФормыСтруктура") Тогда
		СправочникМетаданного = МодульУправленияОповещениямиУХ.ПолучитьТипОбъектаОповещенияПоСсылке(СсылкаНаОбъектВход.Ссылка);
	Иначе
		СправочникМетаданного = МодульУправленияОповещениямиУХ.ПолучитьТипОбъектаОповещенияПоСсылке(СсылкаНаОбъектВход);
	КонецЕсли;
	// Получение реквизита организации.
	Если ЗначениеЗаполнено(СправочникМетаданного) Тогда
		РеквизитОрганизации = СправочникМетаданного.РеквизитРазделенияПоОрганизациям;
		Если ЗначениеЗаполнено(РеквизитОрганизации) Тогда
			// Получение организации по реквизиту.
			Если ОбщегоназначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СсылкаНаОбъектВход, РеквизитОрганизации) Тогда
				РезультатФункции = СсылкаНаОбъектВход[РеквизитОрганизации];
			Иначе
				РезультатФункции = ПустаяОрганизация;			// Такого реквизита нет.
			КонецЕсли;
		Иначе
			РезультатФункции = ПустаяОрганизация;				// Пустой реквизит организации.
		КонецЕсли;
	Иначе
		РезультатФункции = ПустаяОрганизация;					// Нет справочника БД.
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

Процедура ОбработатьЭтапОповещения(СтруктураПараметров) Экспорт
	// Получим таблицу получателей оповещения из этапа.
	Получатели = СтруктураПараметров.ТекущийЭтап.Утверждающие.Выгрузить(); 
	// Получим текст оповещения.
	ПараметрыПроцесса = СтруктураПараметров.ЭкземплярПроцесса.ПараметрыПроцесса.Выгрузить();
	ТекстСообщения = ПолучитьТекстОтправкиЭтапаОповещения(СтруктураПараметров.ТекущийЭтап, ПараметрыПроцесса, СтруктураПараметров.ЭкземплярПроцесса);
	// Отправим оповещения по таблице.
	Если СокрЛП(ТекстСообщения) <> "" Тогда
		КатегорияОповещенияЭтапа	 = Справочники.КатегорииСобытийОповещений.ОповещенияЭтапаПроцесса;
		ВидСобытияОповещенияЭтапа	 = Справочники.ВидыСобытийОповещений.ОповещенияЭтапаПроцесса;
		ТекущаяОрганизация = СтруктураПараметров.ЭкземплярПроцесса.Организация;
		Для Каждого Пользователь Из Получатели Цикл
			ТекПользовательПолучатель = Пользователь.Пользователь;
			Если ТипЗнч(ТекПользовательПолучатель) = Тип("СправочникСсылка.РолиКонтактныхЛиц") Тогда
				// Разыменуем роль.
				КлючевойОбъектПроцесса = СтруктураПараметров.ЭкземплярПроцесса.КлючевойОбъектПроцесса;
				ОрганизацияОбъектаМетаданных = ПолучитьОрганизациюОбъекта(КлючевойОбъектПроцесса);
				ОрганизацияРоли = Справочники.Организации.ПустаяСсылка();
				Если ЗначениеЗаполнено(ОрганизацияОбъектаМетаданных) Тогда
					ОрганизацияРоли = ОрганизацияОбъектаМетаданных;
				ИначеЕсли ЗначениеЗаполнено(Пользователь.Организация) Тогда
					ОрганизацияРоли = Пользователь.Организация;
				Иначе	
					ОрганизацияРоли = ТекущаяОрганизация;
				КонецЕсли;
				ПолучателиПоРоли = МодульУправленияПроцессамиУХ.ПолучитьПользователейПоРоли(ТекПользовательПолучатель, ОрганизацияРоли);	
				// Отправим оповещения каждому из результирующих получателей.
				Для Каждого Получатель Из ПолучателиПоРоли Цикл
					НовыйПолучатель = Получатель.Пользователь;
					МодульУправленияОповещениямиУХ.СоздатьОповещениеПользователю(КатегорияОповещенияЭтапа, ВидСобытияОповещенияЭтапа, НовыйПолучатель, ТекстСообщения);
				КонецЦикла;
			ИначеЕсли ТипЗнч(ТекПользовательПолучатель) = Тип("СправочникСсылка.Пользователи") Тогда   	
				// Отправим конкретному пользователю.
				МодульУправленияОповещениямиУХ.СоздатьОповещениеПользователю(КатегорияОповещенияЭтапа, ВидСобытияОповещенияЭтапа, ТекПользовательПолучатель, ТекстСообщения);
			ИначеЕсли ТипЗнч(ТекПользовательПолучатель) = Тип("СправочникСсылка.РасширеннаяАдресацияСогласования") Тогда
				// Отвественный задан Расширенной адресацией.
				СпособАдресацииРасширенная = Перечисления.СпособыАдресацииСогласования.РасширеннаяАдресация;
				СтруктураОтветственных = Новый Структура;
				СтруктураОтветственных.Вставить("Пользователь", ТекПользовательПолучатель);
				СтруктураОтветственных.Вставить("Организация", ТекущаяОрганизация);
				СтруктураОтветственных.Вставить("СпособАдресации", СпособАдресацииРасширенная);
				ТабОтветственныхИзм = Новый ТаблицаЗначений;
				ТабОтветственныхИзм.Колонки.Добавить("Пользователь");
				ТабОтветственныхИзм.Колонки.Добавить("Организация");
				ТабОтветственныхИзм.Колонки.Добавить("СпособАдресации");
				СтрокаПредставленияИзм = "";
				МодульУправленияПроцессамиУХ.РасшифроватьРасширеннуюАдресацию(СтруктураПараметров.ЭкземплярПроцесса, СтруктураОтветственных, ТабОтветственныхИзм, СтрокаПредставленияИзм);
				Для Каждого ТекТабОтветственныхИзм Из ТабОтветственныхИзм Цикл					
					МодульУправленияОповещениямиУХ.СоздатьОповещениеПользователю(КатегорияОповещенияЭтапа, ВидСобытияОповещенияЭтапа, ТекТабОтветственныхИзм.Пользователь, ТекстСообщения);
				КонецЦикла;
			Иначе
				ТекстОшибка = НСтр("ru = 'Неизвестный вариант получателя оповещения %Получатель% в этапе %Этап%. Отправка оповещения отменена.'");
				ТекстОшибка = СтрЗаменить(ТекстОшибка, "%Получатель%", Строка(ТекПользовательПолучатель));
				ТекстОшибка = СтрЗаменить(ТекстОшибка, "%Этап%", Строка(СтруктураПараметров.ТекущийЭтап));
				ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстОшибка);
			КонецЕсли;
		КонецЦикла;
		
		МассивЭтапов = МодульУправленияПроцессамиУХ.ПолучитьЭтапыПоследователи(СтруктураПараметров.ЭкземплярПроцесса, СтруктураПараметров.ТекущийЭтап);
		
		НужнаДальнейшаяОбработка = Истина;
	Иначе
		// Пустой текст. Не осуществляем его отправку.
	КонецЕсли;
КонецПроцедуры		// ОбработатьЭтапОповещения()

#Область ОбработчикиПараметрическихФункций

Функция ОстаткиДенежныхСредствВКассе(СтруктураПараметров) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ЛимитОстаткаКассыОрганизацийСрезПоследних.Лимит Как Лимит
	|ИЗ
	|	РегистрСведений.ЛимитОстаткаКассыОрганизаций.СрезПоследних(&ТекДата, ) КАК ЛимитОстаткаКассыОрганизацийСрезПоследних";
	
	Запрос.УстановитьПараметр("ТекДата",ТекущаяДата());
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ОстатокРуб = 0;
	Пока Выборка.Следующий() Цикл
		
		 ОстатокРуб = Выборка.Лимит; 
		
	КонецЦикла;
	
	
	//СтруктураВозврата = Новый Структура;
	СтруктураПараметров.Вставить("ОстатокРуб",ОстатокРуб);
	//СтруктураПараметров.Вставить("ОстатокВал",2000);
	
КонецФункции

Процедура УстановитьЗначениеПараметра(СтруктураПараметров) Экспорт
	
	КодПараметра = СтруктураПараметров.КодПараметра;
    ЗначениеПараметра = СтруктураПараметров.ЗначениеПараметра;
	
	Если СтруктураПараметров.Свойство("ЭкземплярПроцессаОбъект") = Ложь Тогда
		ЭкземплярОбъект =  СтруктураПараметров.ЭкземплярПроцесса.ПолучитьОбъект();
	Иначе
		ЭкземплярОбъект =  СтруктураПараметров.ЭкземплярПроцессаОбъект;
	КонецЕсли;	   
	
	
	ПараметрыПроцесса = ЭкземплярОбъект.ПараметрыПроцесса.Выгрузить();
	НужныйПараметрМассив = ПараметрыПроцесса.НайтиСтроки(Новый Структура("КодПараметра",КодПараметра));
	
	Если НужныйПараметрМассив.Количество() = 1 Тогда
		НужныйПараметр = НужныйПараметрМассив[0];
		НужныйПараметр.ЗначениеПоУмолчанию = ЗначениеПараметра;
	КонецЕсли;
	ЭкземплярОбъект.ПараметрыПроцесса.Загрузить(ПараметрыПроцесса);
	ЭкземплярОбъект.Записать();
 КонецПроцедуры

Функция ТекущаяДатаНаСервере(СтруктураПараметров) Экспорт
	СтруктураПараметров.Вставить("ТекущаяДата", ТекущаяДата());
КонецФункции

Функция СоздатьЗаявкуНаПокупкуВалюты(СтруктураПараметров) Экспорт
	
	ЗаявкиНаОперации.СоздатьЗаявкуНаПокупкуВалюты(СтруктураПараметров);
	
КонецФункции

Функция ОстатокЛимитаЗадолженностиПоДоговору(СтруктураПараметров) Экспорт
	
	Если  НЕ ЗначениеЗаполнено(СтруктураПараметров.ДоговорКонтрагента) Тогда
		СтруктураПараметров.Вставить("ОстатокЛимита", 0);
		Возврат 0;
	КонецЕсли;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.ДопустимаяСуммаЗадолженности - ВзаиморасчетыСКонтрагентамиОстатки.СуммаОстаток КАК ОстатокЛимита
	|ИЗ
	|	РегистрНакопления.РасчетыСКонтрагентамиФакт.Остатки(, ДоговорКонтрагента = &ДоговорКонтрагента) КАК ВзаиморасчетыСКонтрагентамиОстатки";
	Запрос.УстановитьПараметр("ДоговорКонтрагента", СтруктураПараметров.ДоговорКонтрагента);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		СтруктураПараметров.Вставить("ОстатокЛимита", Выборка.ОстатокЛимита);
	Иначе
		СтруктураПараметров.Вставить("ОстатокЛимита", СтруктураПараметров.ДоговорКонтрагента.ДопустимаяСуммаЗадолженности);
	КонецЕсли;
	
	Возврат СтруктураПараметров.ОстатокЛимита;
	
КонецФункции

// Функция возвращает нарушен ли в согласуемом документе указанный в параметре вид контроля.
//
// Параметры:
//  СтруктураПараметров  - Структура - Параметры
//		* ТекОбъект	  - ДокументСсылка - Ссылка на проверяемый документ
//      * ВидКонтроля - ПланВидовХарактеристикСсылка.ВидыКонтроляДокументов - Вид контроля
//
// Возвращаемое значение:
//   Булево - нарушен контроль или нет
//
Функция КонтрольНарушен(СтруктураПараметров) Экспорт
	
	Если НЕ СтруктураПараметров.Свойство("ТекОбъект") Тогда
		СтруктураПараметров.Вставить("Результат", Ложь);
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ СтруктураПараметров.Свойство("ВидКонтроля") Тогда
		СтруктураПараметров.Вставить("Результат", Ложь);
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Для Каждого КлючЗначение Из СтруктураПараметров Цикл
		Запрос.УстановитьПараметр(КлючЗначение.Ключ, КлючЗначение.Значение);
	КонецЦикла;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	РезультатыКонтроля.ВидКонтроля КАК ВидКонтроля,
	|	РезультатыКонтроля.КлючКонтроля КАК КлючКонтроля,
	|	РезультатыКонтроля.КонтрольНарушен КАК КонтрольНарушен
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств.РезультатыКонтроля КАК РезультатыКонтроля
	|ГДЕ
	|	РезультатыКонтроля.Ссылка = &ТекОбъект
	|	И РезультатыКонтроля.ВидКонтроля = &ВидКонтроля
	|	И РезультатыКонтроля.КонтрольНарушен = ИСТИНА";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ЗаявкаНаРасходованиеДенежныхСредств", СтруктураПараметров.ТекОбъект.Метаданные().Имя);
	
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	
	СтруктураПараметров.Вставить("Результат", НЕ Результат.Пустой());
	
	Возврат СтруктураПараметров.Результат;
	
КонецФункции

// Функция возвращает нарушен ли какой-либо контроль в согласуемом документе.
//
// Параметры:
//  СтруктураПараметров - Структура - Параметры
//		* ТекОбъект	  - ДокументСсылка - Ссылка на проверяемый документ
//
// Возвращаемое значение:
//   Булево - нарушен контроль или нет
//
Функция ЕстьНарушенияВДокументе(СтруктураПараметров) Экспорт
	
	Если НЕ СтруктураПараметров.Свойство("ТекОбъект") Тогда
		СтруктураПараметров.Вставить("Результат", Ложь);
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Для Каждого КлючЗначение Из СтруктураПараметров Цикл
		Запрос.УстановитьПараметр(КлючЗначение.Ключ, КлючЗначение.Значение);
	КонецЦикла;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	РезультатыКонтроля.ВидКонтроля КАК ВидКонтроля,
	|	РезультатыКонтроля.КлючКонтроля КАК КлючКонтроля,
	|	РезультатыКонтроля.КонтрольНарушен КАК КонтрольНарушен
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств.РезультатыКонтроля КАК РезультатыКонтроля
	|ГДЕ
	|	РезультатыКонтроля.Ссылка = &ТекОбъект
	|	И РезультатыКонтроля.КонтрольНарушен = ИСТИНА";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ЗаявкаНаРасходованиеДенежныхСредств", СтруктураПараметров.ТекОбъект.Метаданные().Имя);
	
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	
	СтруктураПараметров.Вставить("Результат", НЕ Результат.Пустой());
	
	Возврат СтруктураПараметров.Результат;
	
КонецФункции

// Функция возвращает текущий статус согласования объекта
Функция ПолучитьСтатусОбъекта(СтруктураПараметров) Экспорт
	
	Если СтруктураПараметров.Свойство("ТекОбъект") Тогда
		СтруктураПараметров.Вставить("Статус", УправлениеПроцессамиСогласованияУХ.ВернутьСтатусОбъекта(СтруктураПараметров.ТекОбъект));
	Иначе
		СтруктураПараметров.Вставить("Статус", Неопределено);
	КонецЕсли;
	
	Возврат СтруктураПараметров.Статус;
	
КонецФункции

#КонецОбласти

#Область ОбработкаЭтаповПроцессовПодготовкиОтчетности

Функция УстановитьСостояниеЭтапа(ДокументПроцесса, Этап, Организации = Неопределено, Состояние) Экспорт
	
	Если ТипЗнч(Состояние)=Тип("Строка") Тогда	
		Состояние=Перечисления.СостоянияЭтаповУниверсальныхПроцессов[СтрЗаменить(Состояние,"ИзменитьСостояние_","")];
	КонецЕсли;
	
	Если Организации = Неопределено Тогда
		ОрганизацииОтбор = Неопределено;
	Иначе
		ОрганизацииОтбор = Новый Соответствие;
		Если ТипЗнч(Организации) = Тип("СправочникСсылка.Организации") Тогда
			ОрганизацииОтбор.Вставить(Организации, Истина);
		ИначеЕсли ТипЗнч(Организации) = Тип("Массив") Тогда
			Для Каждого Организация Из Организации Цикл
				ОрганизацииОтбор.Вставить(Организация, Истина);
			КонецЦикла; 
		ИначеЕсли ТипЗнч(Организации) = Тип("Соответствие") Тогда
			ОрганизацииОтбор = Организации;
		КонецЕсли;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ВыполнениеПроцессовОрганизаций.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДокументПроцесса.Установить(ДокументПроцесса);
	НаборЗаписей.Отбор.ЭтапПроцесса.Установить(Этап);
	
	НаборЗаписей.Прочитать();
	
	Для Каждого Запись Из НаборЗаписей Цикл
		//Если Утверждение Тогда
		//	 Запись.ДатаОкончания = ТекущаяДата();
		//КонецЕсли;
		Если НЕ ОрганизацииОтбор = Неопределено Тогда
			Если ОрганизацииОтбор.Получить(Запись.Организация) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		Запись.ДокументПроцесса = ДокументПроцесса;
		Запись.ЭтапПроцесса = Этап;
		Запись.Организация = ОрганизацииОтбор.Получить(Запись.Организация);

		Запись.СостояниеЭтапа = Состояние;
			
	КонецЦикла; 
	
	НаборЗаписей.Записать(Истина);
		
	Возврат Истина;
		
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает сформированный по шаблону текст для отправки оповещения по этапу
// ЭтапВход, согласно таблице параметров процесса ТаблицаПараметрыПроцессаВход
// в ходе универсального процесса ЭкземплярПроцессаВход.
Функция ПолучитьТекстОтправкиЭтапаОповещения(ЭтапВход, ТаблицаПараметрыПроцессаВход, ЭкземплярПроцессаВход)
	РезультатФункции = "";
	ТекстОповещения = "";
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ШаблоныОповещений.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ШаблоныОповещений КАК ШаблоныОповещений
	|ГДЕ
	|	ШаблоныОповещений.ЭтапПроцесса = &ЭтапПроцесса";
	
	Запрос.УстановитьПараметр("ЭтапПроцесса", ЭтапВход);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ТекущийШаблон = Неопределено;
	
	Пока Выборка.Следующий() Цикл
		
		ТекущийШаблон = Выборка.Ссылка;
		
	КонецЦикла;
	
	Если ТекущийШаблон <> Неопределено Тогда
		ТекстОповещения = ТекущийШаблон.Шаблон.Получить();
	КонецЕсли;

	Если СокрЛП(ТекстОповещения) = "" Тогда
		РезультатФункции = "";
	Иначе	
		РезультатФункции = МодульУправленияОповещениямиУХ.ПодготовитьТекстОповещенияПоШаблону(ТекстОповещения, ТаблицаПараметрыПроцессаВход, ЭкземплярПроцессаВход.КлючевойОбъектПроцесса);
	КонецЕсли;	
	Возврат РезультатФункции;
КонецФункции		// ПолучитьТекстОтправкиЭтапаОповещения()

#КонецОбласти


